{***********UNITE*************************************************
Auteur  ...... : Franck VAUTRAIN
Créé le ...... : 19/07/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTINTEGREDOC ()
Mots clefs ... : TOF;BTINTEGREDOC
*****************************************************************}
Unit BTINTEGREDOC_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     HTB97,
     UTOF,
     EtudePiece,
     Dialogs,
     Paramsoc,
     Splash,
     Variants,
     UtilsRapport,
     HRichOLE,
     uEntCommun,
     Udefexport
     ;

Type
  TIntLigne = Record
              CodeFrs : string;
              LigRef  : Integer;
              ColRef  : Integer;
              CleLig  : R_CLEXLS;
              UniteLig: String;
              QteLig  : Double;
              PULig   : Double;
              NbLigT  : Integer;
              NbLigNT : Integer;
              end;

  TOF_BTINTEGREDOC = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

  private
    BValider  : TToolbarButton97;
    BTExcel   : TToolbarButton97;
    BTImprime : TToolbarButton97;
    ChkRapport: THCheckbox;
    XLSName   : THEdit;
    BrowseXLS : TOpenDialog;
    Rapport   : TGestionRapport;
    //
    Tobdoc    : TOB;
    TobPiece  : TOB;
    TobOuvrages: TOB;
    TobErreur : TOB;
    //
    WinXLS    : OleVariant;
    Workbook  : OleVariant;
    WinNew    : Boolean;
    //..
    IntLigne  : TIntLigne;
    //
    procedure ChargeFichierXLS(sender: TObject);
    procedure ChargePiece;
    procedure ChercheFichierXLS(sender: TObject);
    procedure GestionRapport(sender: TObject);
    procedure ImprimeFichierXLS(sender: TObject);
    procedure OuvrirFichierXLS(sender: TObject);
    procedure GestionErreur(LibError: string);
    //
    function RechercheRange(Etiquette: string; var LibEtiq: string; var LigEtiq, ColEtiq: Integer): Boolean;
    function ControlePiece(Cledoc: R_CLEDOC; var MsgErreur: String): Boolean;
    //
  end ;

Implementation
  uses  UtilXLSBTP,
        UtilTOBPiece,
        PiecesRecalculs;


procedure TOF_BTINTEGREDOC.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.OnArgument (S : String ) ;
begin
  Inherited ;

  if Assigned(GetControl('BTINTEGRATION')) then
  begin
    BValider := TToolbarButton97(ecran.FindComponent('BTINTEGRATION'));
    BValider.OnClick := ChargeFichierXLS;
    BValider.Enabled := false;
  end;

  if Assigned(GetControl('BTEXCEL')) then
  begin
    BTExcel := TToolbarButton97(ecran.FindComponent('BTEXCEL'));
    BTExcel.OnClick := OuvrirFichierXLS;
  end;

  if Assigned(GetControl('BTIMPRIME')) then
  begin
    BTImprime := TToolbarButton97(ecran.FindComponent('BTIMPRIME'));
    BTImprime.OnClick := ImprimeFichierXLS;
  end;

  if Assigned(GetControl('CHKRAPPORT')) then
  begin
    ChkRapport := THCheckbox(ecran.FindComponent('CHKRAPPORT'));
    ChkRapport.OnClick := GestionRapport;
  end;

  if Assigned(GetControl('XLSNAME')) then
  begin
    XLSName := THedit(ecran.FindComponent('XLSNAME'));
    XLSName.OnElipsisClick := ChercheFichierXLS;
  end;

  Tobdoc := TOB.Create('DOCUMENT', nil, -1);
  TobErreur := TOB.Create('ERREURS', Nil, -1);
  TobOuvrages := TOB.Create ('LES OUVRAGES',nil,-1);
  //
  Rapport := TGestionRapport.Create(Ecran);
  Rapport.Titre   := 'Intégration XLS dans Document';
  Rapport.Close   := True;
  Rapport.Sauve   := False;
  Rapport.Print   := False;
  //
end ;

procedure TOF_BTINTEGREDOC.OnClose ;
begin
  Inherited ;

  ExcelClose(WinXLS);

  //Fermeture de l'instance Excel
  FreeAndNil(Tobdoc);
  FreeAndNil(TobErreur);
  FreeAndNil(TobOuvrages);

  //Fin de traitement
  if Assigned(Rapport ) then FreeAndNil(Rapport);

end ;

procedure TOF_BTINTEGREDOC.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTINTEGREDOC.ChargeFichierXLS(sender : TObject);
var ActiveWB    : Variant;
    SheetXLS    : OleVariant;
    //
    Splash      : TFsplashScreen;
    //
    ind         : Integer;
    Ligne       : Integer;
    Colonne     : Integer;
    //
    ColRefpiece : Integer;
    LigRefPiece : Integer;
    ColRefExt   : Integer;
    ColUnite    : Integer;
    ColQte      : Integer;
    ColPu       : Integer;
    //
    RefFourn    : string;
    RefPiece    : String;
    RefExterne  : String;
    SheetName   : string;
    CellValue   : string;
    //
//    RecalcPiece : TRecalculPiece;
begin

  if not OpenExcel (True,WinXLS, WinNew) then
  begin
    GestionErreur(TraduireMemoire('Liaison Excel impossible'));
    XLSName.Text := '';
    Exit;
  end;

  //Affichage d'un splash de traitement pour patienter...
  splash := TFsplashScreen.Create (ecran);
  splash.Label1.Caption := 'Renvoi des données Excel vers Document PGI';
  splash.Show;
  splash.Refresh;

  //Gestion de l'entête de rapport
  if ChkRapport.Checked then Rapport.SauveLigMemo(Splash.Label1.Caption);

  //Contrôle si le fichier existe et si c'est bien un fichier XLS
  WorkBook := OpenWorkBook(XLSName.Text, WinXLS, False);
  ActiveWB:= WinXLS.ActiveWorkBook;

  For ind := 1 to ActiveWB.Sheets.Count do
  begin
    SheetName := ActiveWB.Sheets[ind].Name;
    SheetXLS := SelectSheet (Workbook, SheetName);
    Splash.Label2.Caption := 'Traitement de la feuille : ' + SheetName;
    if ChkRapport.Checked then Rapport.SauveLigMemo(Splash.Label2.Caption);

    //contrôle de l'existence des etiquette de référence du document XLS
    if not RechercheRange('REFFOURNISSEUR', RefFourn, Ligne, Colonne)     then Continue;
    if not RechercheRange('REFEXTERNE', RefExterne, Ligne, ColRefExt)     then Continue;
    if not RechercheRange('REFLIGNE', RefPiece, LigRefPiece, ColRefPiece) then Continue;
    if not RechercheRange('UNITELIGNE', CellValue, Ligne, ColUnite)       then Continue;
    if not RechercheRange('QTELIGNE', CellValue, Ligne, ColQte)           then Continue;
    if not RechercheRange('PULIGNE', CellValue, Ligne, ColPU)             then Continue;

    //si la reference fournisseur est renseignée on enlève les guillemets en début et fin...
    if RefFourn <> '' then refFourn := StringReplace(RefFourn,'"','',[rfReplaceAll]);

    //Chargement du record utiliser pour mettre à jour les TOBlignes et ouvrage....
    IntLigne.CodeFrs  := RefFourn;
    IntLigne.LigRef   := LigRefPiece + 1;
    IntLigne.ColRef   := ColRefpiece;
    IntLigne.UniteLig := '';
    IntLigne.QteLig   := 0;
    IntLigne.PULig    := 0;
    IntLigne.NbLigT   :=0;
    IntLigne.NbLigNT  :=0;

    //parcours des lignes de la feuille XLS
    repeat
      //découpage de la cellule pour récupération Cledoc
      RefPiece := GetExcelFormated(Workbook.ActiveSheet, IntLigne.LigRef, ColRefPiece);
      if RefPiece <> '' then
      begin
        CellValue := Trim(GetExceltext(Workbook.ActiveSheet, IntLigne.LigRef, ColQte));
        if (CellValue <> '0') and (CellValue <> '') then //si la qté est à zéro on ne charge pas la ligne => gain de temps...
        begin
          IntLigne.QteLig := StrToFloat(CellValue);
          CellValue := GetExceltext(Workbook.ActiveSheet, IntLigne.LigRef, ColUnite);
          IntLigne.UniteLig := Cellvalue;
          CellValue := GetExceltext(Workbook.ActiveSheet, IntLigne.LigRef, ColPU);
          IntLigne.PULig := StrToFloat(CellValue);
          //Remise à plat de la référence document...
          DecodeclefXLS(RefPiece, intLigne.CleLig);
          //chargement des différentes tob nécessaire au calcul de la pièce...
          if ChkRapport.Checked then Rapport.SauveLigMemo('Traitement de la pièce ' + intLigne.CleLig.NaturePiece + '/' + IntToStr(intLigne.CleLig.NumeroPiece));
          ChargePiece;
          if ChkRapport.Checked then Rapport.SauveLigMemo('fin Traitement de la pièce ' + intLigne.CleLig.NaturePiece + '/' + IntToStr(intLigne.CleLig.NumeroPiece));
        end;
      end;
      inc(IntLigne.LigRef);
    until RefPiece = '';
  end;

  if ChkRapport.Checked then Rapport.SauveLigMemo('Nbre de ligne(s) traitée(s)     : ' + IntToStr(IntLigne.NbLigT));
  if ChkRapport.Checked then Rapport.SauveLigMemo('Nbre de ligne(s) non traitée(s) : ' + IntToStr(IntLigne.NbLigNT));

  //Recalcul des entêtes de piece
  if TobDoc.Detail.count <> 0 then
  begin
    TobDoc.UpdateDB();
    if TobOuvrages.detail.count>0 then TobOuvrages.UpdateDB();
    //
    if ChkRapport.Checked then Rapport.SauveLigMemo('Recalcul de(s) pièce(s)');

    for ind := 0 to TobDoc.Detail.count-1 do
    begin
      Tobdoc.detail[ind].ClearDetail;
      TraitementRecalculPiece (Tobdoc.detail[ind],false);
    end;
  end;

  //lecture document excel pour chargement pièces
  XLSName.Text := '';
  BValider.Enabled := false;
  //
  Splash.close;
  FreeAndNil(splash);

  //affichage du rapport d'intégration
  if ChkRapport.Checked then Rapport.AfficheRapport;

end;

Procedure TOF_BTINTEGREDOC.ChargePiece;
var StSQl     : string;
    QQ        : TQuery;
    CleDoc    : R_CLEDOC;
    MsgErreur : String;
    TobLigne,TOBOuvrage  : TOB;
begin

  //mise à jour des informations de la piece
  CleDoc.NaturePiece := intLigne.CleLig.NaturePiece;
  CleDoc.Souche      := intLigne.CleLig.Souche;
  CleDoc.Indice      := intLigne.CleLig.Indice;
  CleDoc.NumeroPiece := intLigne.CleLig.NumeroPiece;
  CleDoc.NumOrdre    := intLigne.CleLig.NumOrdre;

  if not ControlePiece(Cledoc, MsgErreur) then
  begin
    inc(IntLigne.NbLigNT); //calcul du nombre de ligne non traitée
    GestionErreur(MsgErreur);
    Exit;
  end;

  TOBPIECE := TobDoc.FindFirst(['GP_NATUREPIECEG', 'GP_NUMERO'], [Cledoc.NaturePiece, Cledoc.NumeroPiece], false);

  //si on ne trouve aucune ligne de la tob qui correpond on crée le tobpiece...
  if TOBPIECE = nil then
  begin
    TobPiece := TOB.Create('PIECE', Tobdoc, -1);
    StSQl := 'SELECT * FROM PIECE WHERE ' + WherePiece(Cledoc, ttdPiece,True);
    QQ := OpenSQL(StSQL, True, 1, '', True);
    try
      if not QQ.eof then
      begin
        TobPiece.SelectDB('',QQ);
      end;
    finally
      ferme(QQ);
    end;
  end;

  if intLigne.CleLig.UniqueBlo = 0 then
  begin
    StSQl := 'SELECT * FROM LIGNE WHERE ' + WherePiece(CleDoc, ttdLigne, True, True);
    QQ := OpenSQL(StSQl, True, 1, '', True);
    try
      if not QQ.Eof then
      begin
        //contrôle si cotraitant = cotraitant de la ligne document
        if QQ.Findfield('GL_FOURNISSEUR').AsString = IntLigne.CodeFrs then
        begin
          //
          TobLigne := TOB.Create('LIGNE', TOBPIECE, -1);
          TobLigne.SelectDB('', QQ);
          //Mise à jour des unites, quantités et PU du document PGI avec les info document XLS
          TobLigne.PutValue('GL_QTEFACT', intLigne.QteLig);
          TobLigne.PutValue('GL_PUHTDEV', intLigne.PULig);
          TobLigne.PutValue('GL_DPA', intLigne.PULig);
          TobLigne.PutValue('GL_QUALIFQTEVTE', intLigne.UniteLig);
          Inc(IntLigne.NbLigT);
        end
        else Inc(IntLigne.NbLigNT);
      end;
    finally
      ferme(QQ);
    end;
  end
  else
  begin
    //chargement des informations de l'ouvrage de la ligne de pièce
    StSQL := 'SELECT * FROM LIGNEOUV WHERE ' + WherePiece (cledoc,ttdOuvrage,true)+' AND BLO_UNIQUEBLO='+IntTOStr(intLigne.CleLig.UniqueBlo);
    QQ := OpenSql(StSQL, True) ;
    try
      if not QQ.Eof then
      begin
        if QQ.FindField('BLO_FOURNISSEUR').AsString = IntLigne.codefrs then
        begin
          TobOuvrage := TOB.Create('LIGNEOUV', TobOuvrages, -1);
          TobOuvrage.SelectDB  ('',QQ);
          TobOuvrage.PutValue('BLO_QTEFACT', intLigne.QteLig);
          TobOuvrage.PutValue('BLO_PUHTDEV', intLigne.PULig);
          TobOuvrage.PutValue('BLO_DPA', intLigne.PULig);
          TobOuvrage.PutValue('BLO_QUALIFQTEVTE', intLigne.UniteLig);
          Inc(IntLigne.NbLigT);
        end
        else Inc(IntLigne.NbLigNT);
      end;
    finally
      ferme(QQ);
    end;
  end;


end;

Function TOF_BTINTEGREDOC.ControlePiece(Cledoc : R_CLEDOC; Var MsgErreur : String) : Boolean;
var StSQL : string;
    QQ    : TQuery;
    ClePiece  : string;
    TobErr : TOB;
begin

  result := false;
  MsgErreur := '';

  ClePiece := Cledoc.NaturePiece + ';' + Cledoc.Souche + ';' + IntToStr(Cledoc.NumeroPiece) + ';' + IntToStr(Cledoc.indice);

  if TobErreur.FindFirst(['CLEDOC'], [ClePiece], false) <> nil then Exit;

  //Contrôle si la pièce n'est pas acceptée ou facturée...
  StSQL := 'SELECT AFF_ETATAFFAIRE  FROM AFFAIRE WHERE AFF_AFFAIRE=(SELECT GP_AFFAIREDEVIS FROM PIECE WHERE ' + WherePiece(Cledoc, ttdPiece, true) + ')';
  QQ := OpenSQL(StSQL, True, 1, '', True);
  if not QQ.eof then
  begin
    if QQ.FindField('AFF_ETATAFFAIRE').AsString = 'ACP' then
    begin
      TobErr := TOB.Create('ERR', TobErreur, -1);
      TobErr.AddChampSupValeur('CLEDOC', ClePiece);
      MsgErreur := 'Intégration impossible sur un document accepté et/ou facturé';
      ferme(QQ);
      Exit;
    end;
  end
  else
  begin
    TobErr := TOB.Create('ERR', TobErreur, -1);
    TobErr.AddChampSupValeur('CLEDOC', ClePiece);
    MsgErreur := 'Anomalie d''intégration piece : ' + ClePiece;
    Ferme(QQ);
    Exit;
  end;

  Result := True;

end;

function TOF_BTINTEGREDOC.RechercheRange(Etiquette : string; Var LibEtiq : string; Var LigEtiq, ColEtiq : Integer) : Boolean;
var SheetName : string;
    NBCols    : Integer;
begin

  result := false;

  SheetName := Workbook.ActiveSheet.Name;

  ExcelFindRange(Workbook, SheetName, Etiquette, LigEtiq, ColEtiq, Nbcols);

  if ColEtiq = 0 then
    GestionErreur('L''étiquette' + Etiquette + ' n''existe pas dans la feuille ' + SheetName)
  else
  begin
    result  := True;
    LibEtiq := GetExcelText(Workbook.ActiveSheet, LigEtiq, ColEtiq);
  end;

end;

Procedure TOF_BTINTEGREDOC.GestionErreur(LibError : string);
begin

  if ChkRapport.Checked then
    Rapport.SauveLigMemo(LibError)
  else
    PGIInfo(TraduireMemoire(Liberror), 'Erreur integration XLS');

end;

//si click sur elipsis appel recherche fichier XLS sur le disque
procedure TOF_BTINTEGREDOC.ChercheFichierXLS(sender : TObject);
begin

  if ChkRapport.Checked then Rapport.InitRapport;

  BrowseXLS := TOpenDialog.Create(ecran);
  BrowseXLS.Title := 'Recherche fichier XLS à intégrer';
  BrowseXLS.Filter := 'Fichiers Excel|*.XLS;*.XLSX';
  BrowseXLS.InitialDir := GetParamSocSecur('SO_BTSTOCKAGEEXPORT', 'C:\');

  if ChkRapport.Checked then Rapport.SauveLigMemo(BrowseXLS.Title);

  if BrowseXLS.Execute then
  begin
    XLSName.Text := BrowseXLS.FileName;
    BValider.Enabled := True;
  end
  else
    XLSName.Text := '';


  FreeAndNil(BrowseXLS);

end;

procedure TOF_BTINTEGREDOC.OuvrirFichierXLS(sender : TObject);
begin

  OpenFicXLS(XLSName.Text);

end;

procedure TOF_BTINTEGREDOC.GestionRapport(sender: TObject);
begin
  Rapport.Affiche := ChkRapport.Checked;
end;

procedure TOF_BTINTEGREDOC.ImprimeFichierXLS(sender: TObject);
begin   

end;

Initialization
  registerclasses ( [ TOF_BTINTEGREDOC ] ) ;
end.

