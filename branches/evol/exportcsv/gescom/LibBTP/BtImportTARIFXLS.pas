{***********UNITE*************************************************
Auteur  ...... : Franck VAUTRAIN
Créé le ...... : 19/07/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTINTEGREDOC ()
Mots clefs ... : TOF;BtImportTARIFXLS
*****************************************************************}
Unit BtImportTARIFXLS ;

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
     SAISUTIL,
     PiecesRecalculs
     ;

Type
  TTypeErreur = (TteWARNING,TteERROR);
  TTypeImport = (TTImport,TtTarifFrs);

  TOF_BtImportTARIFXLS = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

  private
    fTTypeImport : TTYpeImport;

    BValider  : TToolbarButton97;
    BTExcel   : TToolbarButton97;
    BTImprime : TToolbarButton97;
    ChkRapport: THCheckbox;
    XLSName   : THEdit;
    DateDebut : ThEdit;
    Datefin   : ThEdit;
    BrowseXLS : TOpenDialog;
    Rapport   : TGestionRapport;
    //
    Splash    : TFsplashScreen;
    //
    TobTarif  : TOB;
    TobSsFam  : TOB;
    TobErreur : TOB;
    TOBDET    : TOB;
    TOBXLS    : TOB;
    TOBLXLS   : TOB;
    //
    WinXLS    : OleVariant;
    Workbook  : OleVariant;
    WinNew    : Boolean;
    ActiveWB  : Variant;
    SheetXLS  : OleVariant;
    SheetName : string;
    CellValue : string;
    //
    CodeFrs   : String;
    //
    LIMaxTarif : Longint;
    //
    procedure AffichageSplash;
    procedure ChargementAchatByXLS;
    procedure ChargeTOBXLSImport(TOBXLS: TOB);
    procedure ChercheFichierXLS(sender: TObject);
    procedure ControleChamp(Champ, Valeur: String);
    procedure ControleCritere(Critere: String);
    procedure ControleFichierXLS;
    procedure FinTraiteImport;
    procedure GestionErreur(LibError: string);
    procedure GestionRapport(sender: TObject);
    procedure ImportFichierXLS(sender: TObject);
    procedure ImprimeFichierXLS(sender: TObject);
    procedure LogErreur(numErreur : integer; TypeErreur : TTypeErreur);
    procedure OuvrirFichierXLS(sender: TObject);
    procedure CreationTarifDetail(TobDoc: TOB; LIMT: Integer);
    procedure MiseAJourTarif(QQ : TQuery; TOBDOC: TOB);
    //
    function AddligneXls (TOBXLS : TOB) : TOB;
    function ControleFrs(RefFourn : String): integer;
    function OuvertureApplicationExcel: boolean;
    function RechercheRange(Etiquette: string; var LibEtiq: string; var LigEtiq, ColEtiq: Integer): Boolean;
    procedure CreationSousFamilleTarif(TOBDOC: TOB);
    //
  end ;

Implementation
  uses  UtilXLSBTP,
        TarifUtil;

procedure TOF_BtImportTARIFXLS.OnArgument (S : String ) ;
Var critere : String;
    X       : Integer;
    Champ   : string;
    Valeur  : string;
begin
  Inherited ;

  fTTypeImport := TtImport;

  //Récupération valeur de argument
  Critere:=(Trim(ReadTokenSt(S)));

  while (Critere <> '') do
  begin
    if Critere <> '' then
      begin
      X := pos (';', Critere) ;
      if x = 0 then
        X := pos ('=', Critere) ;
      if x <> 0 then
        begin
        Champ := copy (Critere, 1, X - 1) ;
        Valeur:= Copy (Critere, X + 1, length (Critere) - X) ;
        ControleChamp(champ, valeur);
        end
      end;
    ControleCritere(Critere);
    Critere   := (Trim(ReadTokenSt(S)));
  end;

  TOBDET := TOB.create ('LES LIGNES EXCEL',nil,-1);

  if Assigned(GetControl('BTINTEGRATION')) then
  begin
    BValider := TToolbarButton97(ecran.FindComponent('BTINTEGRATION'));
    BValider.OnClick := ImportFichierXLS;
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

  if Assigned(GetControl('DATEDEBUT')) then
  begin
    DateDebut     := THedit(ecran.FindComponent('DATEDEBUT'));
    DateDebut.Text:= DateToStr(idate1900);
  end;

  if Assigned(GetControl('DATEFIN')) then
  begin
    DateFin       := THedit(ecran.FindComponent('DATEFIN'));
    DateFin.Text  := DateToStr(idate2099);
  end;

  TobErreur := TOB.Create('ERREURS', Nil, -1);
  //
  Rapport := TGestionRapport.Create(Ecran);

  if fTTypeImport = TtTarifFrs     then
  begin
    TobTarif := TOB.Create('TARIFS', nil, -1);
    TobSsFam := TOB.Create('SS-FAMILLE', nil, -1);
    Rapport.Titre   := 'Import Tarifs fournisseurs';
  end
  else if fTTypeImport = TtImport then
  begin
    Rapport.Titre   := 'Import d''un fichier XLS';
  end;

  Rapport.Close   := True;
  Rapport.Sauve   := False;
  Rapport.Print   := False;
  //
end ;

procedure TOF_BtImportTARIFXLS.OnClose ;
begin
  Inherited ;

  //Fermeture de l'instance Excel
  if fTTypeImport = TtTarifFrs then
  begin
    FreeAndNil(TobTarif);
    FreeAndNil(TobSsFam);
  end;
  if assigned(TobErreur) Then FreeAndNil(TobErreur);
  if assigned(TobDet) Then FreeAndNil (TOBDET);

  //Fin de traitement
  if Assigned(Rapport ) then FreeAndNil(Rapport);

end ;

function TOF_BtImportTARIFXLS.ControleFrs (RefFourn : String) : integer;
Var StSQL : String;
    QQ    : Tquery;
begin

  result := 0;

  if RefFourn <> CodeFrs then result := -2  //Frs fichier <> frs appel
  else
  begin
    StSQl := 'SELECT T_TIERS FROM TIERS WHERE T_TIERS ="' + RefFourn + '" AND T_NATUREAUXI="FOU"';
    QQ := OpenSQL(StSQL, True);
    TRY
      if QQ.eof then Result := -1           //Frs inexistant
    FINALLY
      ferme(QQ);
	  END;
  end;

end;

procedure TOF_BtImportTARIFXLS.ImportFichierXLS(sender : TObject);
begin

  if not OuvertureApplicationExcel then exit;

  TOBXLS := TOB.Create ('LES LIGNES XLS',nil,-1);

  TRY
    //Affichage d'un splash de traitement pour patienter...
    AffichageSplash;

    //Contrôle si le fichier existe et si c'est bien un fichier XLS
    ControleFichierXLS;
    //
    if fTTypeImport = TtTarifFrs then ChargementAchatByXLS;

    //Fin de traitement
    FinTraiteImport;

  FINALLY
    if fTTypeImport = TtTarifFrs then TOBXLS.free;
    if not VarIsEmpty(WinXLS) then WinXLS.Quit;
    WinXLS := unassigned;
    if not ChkRapport.Checked then ecran.close;
  END;

end;

function TOF_BtImportTARIFXLS.OuvertureApplicationExcel : boolean;
begin

  Result := True;

  if not OpenExcel (True,WinXLS, WinNew) then
  begin
    GestionErreur(TraduireMemoire('Liaison Excel impossible'));
    XLSName.Text := '';
    Result := false;
  end;

end;


Procedure TOF_BtImportTARIFXLS.AffichageSplash;
begin

  splash := TFsplashScreen.Create (ecran);

  if fTTypeImport = TtTarifFrs then
    splash.Label1.Caption := 'Renvoi des données Excel vers Tarifs Fournisseurs'
  else if fTTypeImport = TtImport then
    splash.Label1.Caption := 'Renvoi des données Excel';

  splash.Show;
  splash.Refresh;

  //Gestion de l'entête de rapport
  Rapport.SauveLigMemo(Splash.Label1.Caption);


end;

procedure TOF_BtImportTARIFXLS.ControleFichierXLS;
Var Ligne       : Integer;
    Colonne     : Integer;
    //
    Ind         : Integer;
    INbvide     : Integer;
    LigRefLIDIC : Integer;
    ColRefLIDIC : Integer;
    ColLig      : Integer;
    ColSsFam    : Integer;
    ColLibFam   : Integer;
    ColRemise   : Integer;
    ColDateDeb  : Integer;
    ColDateFin  : Integer;
    LigneDepart : Integer;
    //
    RefFourn    : string;
    CtrlFrs     : Integer;
begin

  WorkBook := OpenWorkBook(XLSName.Text, WinXLS, False);
  ActiveWB:= WinXLS.ActiveWorkBook;

  INbVide := 0;

  For ind := 1 to ActiveWB.Sheets.Count do
  begin
    INbVide   := 0;
    SheetName := ActiveWB.Sheets[ind].Name;
    SheetXLS  := SelectSheet (Workbook, SheetName);
    Splash.Label2.Caption := 'Traitement de la feuille : ' + SheetName;
    Rapport.SauveLigMemo(Splash.Label2.Caption);
    //
    //contrôle de l'existence des etiquette de référence du document XLS
    if not RechercheRange('REFFOURNISSEUR', RefFourn, Ligne, Colonne) then
    BEGIN
      LogErreur(1,TteERROR);
      continue;
    END;
    //Controle si la référence fournisseur est valide
    CtrlFrs := ControleFrs(RefFourn);
    if CtrlFrs = -1 then
    begin
      Rapport.SauveLigMemo('Fournisseur '+RefFourn+' inconnu');
      Continue;
    end
    else if CtrlFrs = -2 then
    begin
      Rapport.SauveLigMemo('Fournisseur ' + CodeFrs + ' différent de celui du fichier importé (' + RefFourn + ')');
      Continue;
    end
    else
      Rapport.SauveLigMemo('Traitement fournisseur '+ RefFourn);
    //contrôle de l'existence des etiquette de référence du document XLS
    if not RechercheRange('REFLIGNE',     CellValue, LigrefLIDIC, ColLig) then BEGIN LogErreur(1,TteERROR); Exit; END;
    if not RechercheRange('REFARTLIGNE',  CellValue, Ligne, ColRefLIDIC)  then BEGIN LogErreur(6,TteERROR); Exit; END;
    if not RechercheRange('SOUSFAMILLE',  CellValue, Ligne, ColSsFam)     then BEGIN LogErreur(7,TteERROR); Exit; END;
    if not RechercheRange('LIBELLELIGNE', CellValue, Ligne, ColLibFam)    then BEGIN LogErreur(8,TteERROR); Exit; END;
    if not RechercheRange('REMISETARIF',  CellValue, Ligne, ColRemise)    then BEGIN LogErreur(9,TteERROR); Exit; END;
    if not RechercheRange('DATEDEBUT',    CellValue, Ligne, ColDateDeb)   then BEGIN LogErreur(10,TteERROR); Exit; END;
    if not RechercheRange('DATEFIN',      CellValue, Ligne, ColDateFin)   then BEGIN LogErreur(11,TteERROR); Exit; END;

    //parcours des lignes de la feuille XLS
    LigneDepart := LigRefLIDIC;
    inc(LigneDepart);

    repeat
      //Si remise à zéro on ne traite pas la ligne...
      CellValue := Trim(GetExceltext(Workbook.ActiveSheet, LigneDepart, ColRemise));
      if (CellValue <> '0') and (CellValue <> '') then //si la qté ou le Pu est à zéro on ne charge pas la ligne => gain de temps...
      begin
        if fTTypeImport = TtTarifFrs then ChargeTOBXLSImport(TOBXLS);
        //Mise à jour de la TOB Excel
        if Colonne      <> 0 then TOBLXLS.SetString  ('REFFOURNISSEUR', RefFourn);
        if ColRefLIDIC  <> 0 then TOBLXLS.SetString  ('REFARTLIGNE',            GetExceltext(Workbook.ActiveSheet, LigneDepart, ColRefLIDIC));
        if ColSsFam     <> 0 then TOBLXLS.SetString  ('SOUSFAMILLE',            GetExceltext(Workbook.ActiveSheet, LigneDepart, ColSsFam));
        if ColLibFam    <> 0 then TOBLXLS.SetString  ('LIBELLELIGNE',           GetExceltext(Workbook.ActiveSheet, LigneDepart, ColLibFam));
        if ColRemise    <> 0 then TOBLXLS.SetDouble  ('REMISETARIF', StrToFloat(GetExceltext(Workbook.ActiveSheet, LigneDepart, ColRemise)));
        if ColDateDeb   <> 0 then
        begin
          CellValue := Trim(GetExceltext(Workbook.ActiveSheet, LigneDepart, ColDateDeb));
          if (CellValue <> '0') and (CellValue <> '') then
            TOBLXLS.SetDateTime('DATEDEBUT',   StrToDate (CellValue))
          else
            TOBLXLS.SetDateTime('DATEDEBUT',   StrToDate(DateDebut.text));
        end;
        if ColDateFin   <> 0 then
        begin
          CellValue := Trim(GetExceltext(Workbook.ActiveSheet, LigneDepart, ColDateFin));
          if (CellValue <> '0') and (CellValue <> '') then
            TOBLXLS.SetDateTime('DATEFIN',   StrToDate (CellValue))
          else
            TOBLXLS.SetDateTime('DATEFIN',   StrToDate(Datefin.text));
        end;
        if (ColRefLIDIC = 0) And (ColSsFam = 0) and (ColLibFam = 0) and (ColRemise = 0) and (ColDateDeb = 0) and (ColDateFin =0) then
          INbVide := 6
        else
        begin
          TOBLXLS.SetString  ('TRAITEOK','-');
          Rapport.SauveLigMemo('Traitement Ligne '+ TOBLXLS.GetString('REFARTLIGNE') + '/' + TOBLXLS.GetString('SOUSFAMILLE'));
          inc(LigneDepart);
        end;
      end
      else
      begin
        Inc(INbVide);
        inc(LigneDepart);
      end;
    until INBvide > 5;
  end;

end;

Procedure TOF_BtImportTARIFXLS.ChargeTOBXLSImport(TOBXLS : TOB);
begin

  TOBLXLS := AddligneXls (TOBXLS);

end;

Procedure TOF_BtImportTARIFXLS.ChargementAchatByXLS;
var Ind         : Integer;
    LigMAJ      : Integer;
    LigNonMAJ   : Integer;
    //
    RefFrs      : String;
    ArtTarif    : String;
    SousFam     : String;
    LibSousFam  : String;
    //
    StSQL       : String;
    QQ          : TQuery;
    //
    TOBDOC      : TOB;
begin

  StSQL := 'SELECT MAX(GF_TARIF) FROM TARIF';
  QQ := OpenSQL (StSQL, TRUE,-1,'',true) ;
  if QQ.EOF then LIMaxTarif := 1 else LIMaxTarif := QQ.Fields[0].AsInteger;
  Ferme(QQ) ;

  LigMaj    := 0;
  LigNonMaj := 0;

  For ind := 0 to TobXLS.Detail.count -1 do
  begin
    TOBDOC    := TOBXLS.detail[Ind];
    RefFrs    := TOBDOC.GetString('REFFOURNISSEUR');
    ArtTarif  := TOBDOC.GetString('REFARTLIGNE');
    SousFam   := TOBDOC.GetString('SOUSFAMILLE');
    LibSousFam:= TOBDOC.GetString('LIBELLELIGNE');
    //recherche si le tarif existe déjà...
    StSQL := 'SELECT * FROM TARIF WHERE GF_TIERS="' + RefFrs + '" AND GF_TARIFARTICLE="' + ArtTarif + '" AND GF_SOUSFAMTARART="' + SousFam + '"';
    QQ := OpenSQL(StSQL, False);
    if QQ.eof then
    begin
      Inc(LIMaxTarif);
      CreationTarifDetail (TOBDOC, LIMaxTarif);
      Inc(LigMaj);
      TOBDOC.PutValue('TRAITEOK','X');
    end
    else
    begin
      MiseAJourTarif(QQ, TOBDOC);
      Inc(LigNonMaj);
      TOBDOC.PutValue('TRAITEOK','X');
    end;
    Ferme(QQ);
    //contrôle existence sous-Famille Tarif
    //StSQl := 'SELECT CC_CODE FROM CHOIXCOD WHERE CC_TYPE="BFT" AND CC_CODE="' + SousFam + '"';
    StSQl := 'SELECT BSF_SOUSFAMTARART FROM BTSOUSFAMILLETARIF WHERE BSF_SOUSFAMTARART="' + SousFam + '"';
    if ExecuteSQL(StSQL) = 0 then
    begin
      CreationSousFamilleTarif(TOBDOC);
      Rapport.SauveLigMemo('Création sous-famille Tarif : ' + sousFam);
    end;
    Ferme(QQ);
  end;

  TobTarif.SetAllModifie (True);
  TobTarif.InsertOrUpdateDB(True) ;

  TobSsFam.SetAllModifie (True);
  TobSsFam.InsertOrUpdateDB(True);

  if (LigMaj <> 0) And (LigNonMaj = 0) then
  Begin
    Rapport.SauveLigMemo('Nbre de ligne(s) Crée(s)     : ' + IntToStr(LigMaj));
    Rapport.SauveLigMemo('Document enregistré avec succès.');
  end
  else if (LigMaj <> 0) And (LigNonMaj <> 0) then
  begin
    Rapport.SauveLigMemo('Nbre de ligne(s) Crée(s)     : ' + IntToStr(LigMaj));
    Rapport.SauveLigMemo('Nbre de ligne(s) Modifiée(s) : ' + IntToStr(LigNonMaj));
    Rapport.SauveLigMemo('Document enregistré succès.');
  end
  else if (LigMaj = 0) And (LigNonMaj <> 0) then
  begin
    Rapport.SauveLigMemo('Nbre de ligne(s) Modifiée(s) : ' + IntToStr(LigNonMaj));
    Rapport.SauveLigMemo('Document enregistré avec succès.');
  end
  else if (LigMaj = 0) And (LigNonMaj = 0) then
    Rapport.SauveLigMemo('Aucune ligne à traiter, veuillez vérifier le fichier ' + XLSName.Text + ' intégré')

end;

Procedure TOF_BtImportTARIFXLS.CreationSousFamilleTarif(TOBDOC: TOB);
var TobLigSsFam : TOB;
begin

  TobLigSsFam := TOB.Create('BTSOUSFAMILLEARTICLE', TobSsFam, -1);

  //TOBLigSsFam.PutValue('CC_TYPE', 'BFT');

  TOBLigSsFam.PutValue('BSF_SOUSFAMTARART', TOBDOC.GetString('SOUSFAMILLE'));
  TOBLigSsFam.PutValue('BSF_FAMILLETARIF',  TOBDOC.GetString('REFARTLIGNE'));
  TOBLigSsFam.PutValue('BSF_LIBELLE',       TOBDOC.GetString('REFARTLIGNE') + '_' + TOBDOC.GetString('LIBELLELIGNE'));

end;

procedure TOF_BtImportTARIFXLS.CreationTarifDetail (TobDoc : TOB; LIMT : Longint) ;
var TobT : Tob;
begin

  TobT := Tob.Create ('TARIF', TobTarif, -1);

  TobT.PutValue ('GF_TARIF', LIMT);

  TobT.PutValue ('GF_TIERS', TOBDOC.GetString('REFFOURNISSEUR'));
  TobT.PutValue ('GF_ARTICLE', '');

  TobT.PutValue ('GF_TARIFARTICLE', TOBDOC.GetString('REFARTLIGNE'));

  TobT.PutValue ('GF_TARIFTIERS', '');

  TobT.PutValue ('GF_LIBELLE', 'REMISE DE BASE');

  TobT.PutValue ('GF_PRIXUNITAIRE', 0);

  TobT.PutValue ('GF_QUALIFPRIX', 'GRP');

  TobT.PutValue ('GF_CALCULREMISE', TOBDOC.GetString('REMISETARIF')) ;
  TobT.PutValue ('GF_QUALIFREMISE', TOBDOC.GetString('')) ;

  TobT.PutValue ('GF_BORNEINF', -999999);
  TobT.PutValue ('GF_BORNESUP', 999999);

  TobT.PutValue ('GF_DATEDEBUT', TOBDOC.GetDateTime('DATEDEBUT'));
  TobT.PutValue ('GF_DATEFIN', TOBDOC.GetDateTime('DATEFIN'));

  TobT.PutValue ('GF_DEVISE', V_PGI.DevisePivot);
  TobT.PutValue ('GF_DEPOT', '');
  TobT.PutValue ('GF_SOCIETE', V_PGI.CodeSociete);

  TobT.PutValue ('GF_REMISE', TOBDOC.GetString('REMISETARIF'));

  TobT.PutValue ('GF_DATEEFFET', idate1900);

  TobT.PutValue ('GF_PRIXANCIEN', 0);
  TobT.PutValue ('GF_REMISEANCIEN', 0);

  CalcPriorite (TobT);

  TobT.PutValue ('GF_CASCADEREMISE', 'MIE');

  TobT.PutValue ('GF_DATEMODIF', now);

  TobT.PutValue ('GF_MODECREATION', 'AUT');
  TobT.PutValue ('GF_FERME', '-');
  TobT.PutValue ('GF_NUMLIGNE', 0);
  TobT.PutValue ('GF_FERME', '-');

  TobT.PutValue ('GF_NATUREAUXI', 'FOU');

  TobT.PutValue ('GF_RESSOURCE', '');
  TobT.PutValue ('GF_TARIFRESSOURCE', '');
  TobT.PutValue ('GF_CONDAPPLIC', '');

  TobT.PutValue ('GF_QUANTITATIF', '-');

  TobT.PutValue ('GF_REGIMEPRIX', 'GLO');

  TobT.PutValue ('GF_ARRONDI', '');
  TobT.PutValue ('GF_DEMARQUE', '');
  TobT.PutValue ('GF_TARIFMODE', 0);
  TobT.PutValue ('GF_DATEINTEGR', Now);

  TobT.PutValue ('GF_TYPRES', '');
  TobT.PutValue ('GF_REGROUPELIGNE', '');
  TobT.PutValue ('GF_HRPREFACT', '-');
  TobT.PutValue ('GF_NOFOLIO', 0);

  TobT.PutValue ('GF_HRGCOM', '-');
  TobT.PutValue ('GF_HRGNUITGRAT', '-');
  TobT.PutValue ('GF_NIVEAUYIELD', 0);

  TobT.PutValue ('GF_ATRANSFERER', '-');
  TobT.PutValue ('GF_TRANSFERER', '-');
  TobT.PutValue ('GF_TRFMESSAGE', '');

  TobT.PutValue ('GF_SOUSFAMTARART', TOBDoc.GetString('SOUSFAMILLE'));

end;

procedure TOF_BtImportTARIFXLS.MiseAJourTarif(QQ : TQuery; TOBDOC : TOB);
var TobT : Tob;
begin

  TOBDOC.PutValue('GF_TARIF', QQ.FindField('GF_TARIF').AsString);

  //
  TobT := Tob.Create ('TARIF', TobTarif, -1);
  TobT.SelectDB('', QQ);
  //
  TobT.PutValue ('GF_TARIF', TOBDOC.GetInteger('GF_TARIF'));

  TobT.PutValue ('GF_TIERS', TOBDOC.GetString('REFFOURNISSEUR'));
  TobT.PutValue ('GF_TARIFARTICLE', TOBDOC.GetString('REFARTLIGNE'));
  TobT.PutValue ('GF_SOUSFAMTARART', TOBDoc.GetString('SOUSFAMILLE'));
  //
  TobT.PutValue ('GF_DATEDEBUT', TOBDOC.GetString('DATEDEBUT'));
  TobT.PutValue ('GF_DATEFIN', TOBDOC.GetString('DATEFIN'));
  //
  TobT.PutValue ('GF_REMISE', TOBDOC.GetString('REMISETARIF')) ;
  TobT.PutValue ('GF_CALCULREMISE', TOBDOC.GetString('REMISETARIF')) ;

end;

//si click sur elipsis appel recherche fichier XLS sur le disque
procedure TOF_BtImportTARIFXLS.ChercheFichierXLS(sender : TObject);
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

procedure TOF_BtImportTARIFXLS.OuvrirFichierXLS(sender : TObject);
begin
  OpenFicXLS(XLSName.Text);
end;

procedure TOF_BtImportTARIFXLS.GestionRapport(sender: TObject);
begin
  Rapport.Affiche := ChkRapport.Checked;
end;

procedure TOF_BtImportTARIFXLS.ImprimeFichierXLS(sender: TObject);
begin

end;

function TOF_BtImportTARIFXLS.AddligneXls  (TOBXLS : TOB) : TOB;
begin
	result := TOB.Create ('UNE LIGNE XLS',TOBXLS,-1);
	result.AddChampSupValeur ('REFFOURNISSEUR','');
	result.AddChampSupValeur ('REFARTLIGNE','');
	result.AddChampSupValeur ('SOUSFAMILLE','');
  result.AddChampSupValeur ('LIBELLELIGNE', '');
  result.AddChampSupValeur ('REMISETARIF',0);
  result.AddChampSupValeur ('DATEDEBUT',idate1900);
	result.AddChampSupValeur ('DATEFIN',idate2099);
  result.AddChampSupValeur ('GF_TARIF', '');
	result.AddChampSupValeur ('TRAITEOK','-');
end;

procedure TOF_BtImportTARIFXLS.LogErreur(numErreur: integer; TypeErreur : TTypeErreur);
var MessErreur : string;
begin
  if TypeErreur = TteERROR then
  begin
    Case Numerreur of
      1: MessErreur := 'ERREUR : Zones obligatoire [REFFOURNISSEUR] manquantes,' + #13#10 + 'Feuille Abandonnée';
      2: MessErreur := 'ERREUR : Zones obligatoire [REFARTLIGNE] manquantes ,' + #13#10 + 'Feuille Abandonnée';
      3: MessErreur := 'ERREUR : Zones obligatoire [SOUSFAMILLE]  manquantes, ' + #13#10 + 'Feuille Abandonnée';
      4: MessErreur := 'ERREUR : Zones obligatoire [LIBELLELIGNE] manquantes, ' + #13#10 + 'Feuille Abandonnée';
      5: MessErreur := 'ERREUR : Zones obligatoire [REMISETARIF] manquantes, ' + #13#10 + 'Feuille Abandonnée';
      6: MessErreur := 'ERREUR : Zones obligatoire [DATEDEBUT] manquantes, ' + #13#10 + 'Feuille Abandonnée';
      7: MessErreur := 'ERREUR : Zones obligatoire [DATEFIN] manquantes, ' + #13#10 + 'Feuille Abandonnée';
      else MessErreur := 'ERREUR';
    end;
  end else if TypeErreur = TteWARNING then
  begin
    Case Numerreur of
      1: MessErreur := 'ATTENTION : la zone unité n''est pas définie';
      else MessErreur := 'ERREUR';
    end;
  end;
	Rapport.SauveLigMemo(MessErreur);
end;

procedure TOF_BtImportTARIFXLS.ControleChamp(Champ, Valeur: String);
begin

  if Champ = 'TYPEIMPORT' then
  begin
    if valeur = 'TAR' then fTTypeImport := TtTarifFrs;
  end
  else if Champ = 'FOURNISSEUR' then CodeFrs := Valeur;

end;

procedure TOF_BtImportTARIFXLS.ControleCritere(Critere: String);
begin
end;


Procedure TOF_BtImportTARIFXLS.FinTraiteImport;
Begin

  XLSName.Text := '';
  BValider.Enabled := false;
  Splash.close;
  FreeAndNil(splash);

  //affichage du rapport d'intégration
  if ChkRapport.Checked then Rapport.AfficheRapport;    //affichage du rapport d'intégration

end;

function TOF_BtImportTARIFXLS.RechercheRange(Etiquette : string; Var LibEtiq : string; Var LigEtiq, ColEtiq : Integer) : Boolean;
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

Procedure TOF_BtImportTARIFXLS.GestionErreur(LibError : string);
begin

  if ChkRapport.Checked then
    Rapport.SauveLigMemo(LibError)
  else
    PGIInfo(TraduireMemoire(Liberror), 'Erreur integration XLS');

end;

procedure TOF_BtImportTARIFXLS.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BtImportTARIFXLS.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BtImportTARIFXLS.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BtImportTARIFXLS.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BtImportTARIFXLS.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BtImportTARIFXLS.OnCancel () ;
begin
  Inherited ;
end ;


Initialization
  registerclasses ( [ TOF_BtImportTARIFXLS ] ) ;
end.
