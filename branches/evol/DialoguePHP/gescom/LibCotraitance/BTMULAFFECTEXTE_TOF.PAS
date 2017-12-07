{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 14/04/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTMULAFFECTEXTE ()
Mots clefs ... : TOF;BTMULAFFECTEXTE
*****************************************************************}
Unit BTMULAFFECTEXTE_TOF ;

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
     HTB97,
     HMsgBox,
     vierge,
     menus,
     UentCommun,
     UTOF ;

Type
	TModeTrait = (TmtAffaire,TmtDocument);
  TModegestion = (TmgCotraitance,TmgSousTraitance);

  TOF_BTMULAFFECTEXTE = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
  	FFromMem : boolean;
    fselection : boolean;
  	fModeTrait : TmodeTrait;
    Fgestion : Tmodegestion;
  	fAffaire : string;
    Fcledoc : R_CLEDOC;
  	LATOB,TOBL : TOB;
  	GS : THGrid;
    BEXPORT : TToolbarButton97;
    //
    fColNames : string;
    Ftitre : Hstring;
    FLargeur, FAlignement: string;
		MnExportDocXls : TmenuItem;
    //
  	procedure getComponents;
  	procedure decodeArgs (S : string);
    procedure ChargeLaGrille;
    procedure ChargelaTOB;
    procedure Definigrid;
    procedure DefiniGrille(grid: ThGrid; fColNames, Falignement, Ftitre,fLargeur: string);
    procedure MnExportDocXlsClick (Sender : Tobject);
    procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GSDblClick (Sender : Tobject);

  end ;

Implementation
uses Ucotraitance,UfactExportXLS,
      windows,
      Messages;

procedure TOF_BTMULAFFECTEXTE.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.OnLoad ;

begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.OnArgument (S : String ) ;
var cancel : boolean;
begin
  Inherited ;

  FFromMem := false;
  fselection := false;
  getComponents;
  decodeArgs (S);
  if fSelection then GS.OnDblClick := GSDblClick;
  
  ChargelaTOB;

  //FV1 : si aucun cotraitant on n'affiche pas le récap aucun intérêt
  if (laTOB= nil) or (laTOB.detail.count = 0) then
  begin
    PGIInfo ('Aucun cotraitant sur cet appel d''offre', Ecran.Caption);
    PostMessage(TFVierge(Ecran).Handle, WM_CLOSE, 0, 0);
  end
  else
  begin
    Definigrid;
    ChargeLaGrille;
    GSRowEnter(self,1,cancel,false);
  end;

end ;


procedure TOF_BTMULAFFECTEXTE.ChargelaTOB;
VAR Indice : integer;
		MontantTot : double;
begin

  if TFvierge(ecran).LaTOF.LaTOB <> nil then
  begin
  	LATOB := TFvierge(ecran).LaTOF.LaTOB; // passé via mémoire
    FFromMem := true;
  end
  else
  begin
  	laTOB := TOB.Create('LES DONNEES',nil,-1);
    if fModeTrait = TmtDocument then
    begin
    	LoadLaTOBPieceTrait (laTOB,Fcledoc);
    end else
    begin
    	LoadLaTOBPieceAffaireTrait (laTOB,Faffaire);
    end;
  end;

  if (laTOB= nil) or (laTOB.detail.count = 0) then exit;
  MontantTot := 0;
  For Indice := 0 to LaTOB.detail.count -1 do
  begin
  	MontantTot := MontantTot+LATOB.detail[Indice].GetDouble('BPE_TOTALHTDEV');
  end;

  For Indice := 0 to LaTOB.detail.count -1 do
  begin
    if not LATOB.detail[0].FieldExists('SEL') then
    begin
    	LATOB.detail[Indice].AddChampSupValeur ('SEL','');
    end;

    if not LATOB.detail[Indice].FieldExists('LIBELLE') then
    begin
      LATOB.detail[Indice].AddChampSupValeur ('LIBELLE',rechdom('GCTIERSFOURN',
                                                                 laTOB.detail[Indice].getvalue('BPE_FOURNISSEUR'),
                                                                 false));
    end;

    if not LATOB.detail[Indice].FieldExists('POURCENT') then
    begin
      LATOB.detail[Indice].AddChampSupValeur ('POURCENT',0);
    end;

    if MontantTot <> 0 then
    begin
      LATOB.detail[Indice].PutValue ('POURCENT',arrondi((LATOB.detail[Indice].GetValue ('BPE_TOTALHTDEV')/MontantTot)*100,2));
    end;
  end;
end;

procedure TOF_BTMULAFFECTEXTE.ChargeLaGrille;
begin
	GS.RowCount := LATOB.Detail.count+1; if GS.rowCount < 2 then GS.rowCount := 2;
	LATOB.PutGridDetail(GS,false,false,fColNames);
  TFvierge(ecran).HMTrad.ResizeGridColumns(GS);
end;

procedure TOF_BTMULAFFECTEXTE.OnClose ;
begin
  Inherited ;
  if not FFromMem then laTOB.free;
end ;

procedure TOF_BTMULAFFECTEXTE.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTMULAFFECTEXTE.decodeArgs(S: string);
var lesArgs,UnArg,UnChamp,UneValeur : string;
begin
  LesArgs := S;
  Repeat
    UnArg := READTOKENST(lesArgs);
    UnChamp := '';
    Unevaleur := '';
    if UnArg <> '' then
    begin
    	if Pos('=',UnArg) > 0 then
      begin
      	UnChamp := copy(UnArg,1,Pos('=',UnArg)-1);
        Unevaleur := copy(UnArg,Pos('=',UnArg)+1,255);
      end else
      begin
      	unChamp := UnArg;
      end;
      if Unchamp = 'COTRAITANCE' then
      begin
      	Fgestion := TmgCotraitance;
      end else if UnChamp = 'SOUSTRAITANCE' then
      begin
      	Fgestion := TmgSousTraitance;
      end else if UnChamp = 'AFFAIRE' then
      begin
      	fAffaire := Unevaleur;
        fModeTrait := TmtAffaire;
      end else if UnChamp = 'DOCUMENT' then
      begin
      	DecodeCleDoc (Unevaleur,Fcledoc);
        fModeTrait := TmtDocument;
      end else if UnChamp = 'SELECTION' then
      begin
        fselection := true;
      end;
    end;
  Until UnArg = '';
  if fAffaire <> '' then BEXPORT.visible := true else BEXPORT.visible := false;
end;

procedure TOF_BTMULAFFECTEXTE.getComponents;
begin
	GS := THGrid(GetControl('GS'));
  GS.OnRowEnter := GSRowEnter;
  BEXPORT := TToolbarButton97 (getControl('BEXPORT'));
  MnExportDocXls := TmenuItem(getControl('MnExportDocXls'));
  MnExportDocXls.OnClick := MnExportDocXlsClick;
end;

procedure TOF_BTMULAFFECTEXTE.DefiniGrille (grid: ThGrid; fColNames,Falignement,Ftitre,fLargeur : string);
var st,lestitres,lesalignements,FF,alignement,Nam,leslargeurs,lalargeur,letitre,lelement : string;
    Obli,OkLib,OkVisu,OkNulle,OkCumul,Sep,Okimg : boolean;
    dec,NbCols : integer;
    indice,ind : integer;
    FFQTE,FFDEC : string;
begin
  //
  if Grid.rowcount < 2 then Grid.rowCount := 2;
  st := fColNames;
  NbCols := 0;
  repeat
    lelement := READTOKENST (st);
    if lelement <> '' then
    begin
      inc(NbCols);
    end;
  until lelement = '';
  //
  Grid.ColCount := Nbcols;
  //
  st := fColNames;
  lesalignements := Falignement;
  lestitres := Ftitre;
  leslargeurs := fLargeur;

  for indice := 0 to Nbcols -1 do
  begin
    Nam := ReadTokenSt (St); // nom
    alignement := ReadTokenSt(lesalignements);
    lalargeur := readtokenst(leslargeurs);
    letitre := readtokenst(lestitres);
    TransAlign(alignement,FF,Dec,Sep,Obli,OkLib,OkVisu,OkNulle,OkCumul) ;
    grid.cells[Indice,0] := leTitre;
    grid.ColNames [Indice] := Nam;
    if copy(Alignement,1,1)='G' then grid.ColAligns[indice] := taLeftJustify
    else if copy(Alignement,1,1)='D' then grid.ColAligns[indice] := taRightJustify
    else if copy(Alignement,1,1)='C' then grid.ColAligns[indice] := taCenter;
    okImg := (copy(Alignement,8,1)='X');
    if OkVisu then
    begin
  		grid.ColWidths[indice] := strtoint(lalargeur)*GS.Canvas.TextWidth('W');
    end else
    begin
    	grid.ColWidths[indice] := -1;
    end;

    if (OkLib) or (okImg) then
    begin
    	grid.ColFormats[indice] := 'CB=' + Get_Join(Nam);
      if OkImg then
      begin
      	grid.ColDrawingModes[Indice]:= 'IMAGE';
      end;
    end else if (Dec<>0) or (Sep) then
    begin
      FFQTE := '#';
      if Sep then FFQte := FFQTE+' ##';
      if Dec > 0 then
      begin
        FFQTE := FFQTE+'0.';
        for ind := 1 to Dec do
        begin
          FFQTE := FFQTE + '0';
        end;
      end else FFQTE := FFQTE + '0';
    	if OkNulle then
      begin
        //
				FFDEC := FFQTE+';-'+FFQTE+'; ;';
      	GS.ColFormats[indice] := FFDEC ;
      end else
      begin
      	GS.ColFormats[indice] := FFQTE ;
      end;
    end;
  end ;
end;

procedure TOF_BTMULAFFECTEXTE.Definigrid;
begin

	if Fgestion = TmgCotraitance then
  begin
    // Définition de la liste de saisie pour la grille Détail
(*
    fColNames := 'SEL;BPE_FOURNISSEUR;LIBELLE;BPE_TOTALHTDEV;BPE_TOTALTTCDEV;POURCENT;BPE_MONTANTFAC;BPE_MONTANTGREL';
    Falignement := 'D.0  ---;G.0  ---;G.0  ---;D/2  -X-;D/2  -X-;D.2  -X-;D/2  -X-;D/2  -X-;';
    Ftitre := 'Num;Cotraitant;Raison sociale;Montant HT;Montant TTC;%;Facturé;Reglé;';
    fLargeur := '5;18;60;20;20;12;20;20;';
*)
    fColNames := 'SEL;BPE_FOURNISSEUR;LIBELLE;BPE_TOTALHTDEV;BPE_TOTALTTCDEV;POURCENT;BPE_MONTANTFAC';
    Falignement := 'D.0  ---;G.0  ---;G.0  ---;D/2  -X-;D/2  -X-;D.2  -X-;D/2  -X-;';
    Ftitre := 'Num;Cotraitant;Raison sociale;Montant HT;Montant TTC;%;Facturé;';
    fLargeur := '5;18;60;20;20;12;20;';

  end else
  begin
  end;
  //
  DefiniGrille (GS,fColNames,Falignement,Ftitre,fLargeur);
end;


procedure TOF_BTMULAFFECTEXTE.MnExportDocXlsClick(Sender: Tobject);
var Fournisseur : string;
    TOBL : TOB;
    cledoc : r_cledoc;
begin
  fillchar(cledoc,sizeof(cledoc),0);
  TOBL := LATOB.Detail[GS.Row-1];
  Fournisseur := TOBL.getvalue('BPE_FOURNISSEUR');
  LanceExportDocument (fAffaire,Fournisseur);
end;

procedure TOF_BTMULAFFECTEXTE.GSRowEnter(Sender: TObject; Ou: Integer;var Cancel: Boolean; Chg: Boolean);
begin
  BEXPORT.enabled := false;
 	if Ou <= GS.fixedRows then exit;
  if laTOB.detail.count = 0 then exit;
  TOBL := LaTOB.Detail[Ou-1]; if TOBl = nil then exit;
  if TOBL.getvalue('BPE_FOURNISSEUR')<> '' then Bexport.Enabled := true;
end;

procedure TOF_BTMULAFFECTEXTE.GSDblClick(Sender: Tobject);
var Fournisseur : string;
    TOBL : TOB;
begin
  TOBL := LATOB.Detail[GS.Row-1];
  Fournisseur := TOBL.getvalue('BPE_FOURNISSEUR');
  TFVierge(ecran).Retour := Fournisseur;
  TFvierge(ecran).Close;
end;

Initialization
  registerclasses ( [ TOF_BTMULAFFECTEXTE ] ) ;
end.
