{***********UNITE*************************************************
Auteur  ...... : LS
Cr�� le ...... : 28/03/2008
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTSELFAC_MUL ()
            .. : Nouvelle gestion de la selection pour facturation
Mots clefs ... : TOF;BTSELFAC_MUL
*****************************************************************}
Unit BTSELFAC_MUL_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     Grids,
     AglInit,
{$IFNDEF EAGLCLIENT}
     db,DBGrids,FE_Main,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,MailEagl,
{$ENDIF}
		 Graphics,
     types,
		 Menus,
     HQry,
     HDB,
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     CalcOlegenericBTP,
     EntGC,
     HTB97,
     SaisUtil,
     AffaireUtil,
     splash,
     BTPREPSELFAC_MUL_TOF,
     UTofAfBaseCodeAffaire,uEntCommun,UtilTOBPiece ;

Type
  TmtFact = (TmtFacturation,TmtCloture);
  TResultS = (BTrSOk,BTrsNone,BtrsAnnul);
  TOF_BTSELFAC_MUL = Class (TOF_AFBASECODEAFFAIRE)
      procedure OnNew                    ; override ;
      procedure OnDelete                 ; override ;
      procedure OnUpdate                 ; override ;
      procedure OnLoad                   ; override ;
      procedure OnArgument (S : String ) ; override ;
      procedure OnDisplay                ; override ;
      procedure OnClose                  ; override ;
      procedure OnCancel                 ; override ;
      procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit); override;
    private
    	DateCloture : TDateTime;
    	fTypeFacturation : string;
      ModeTraitement : TmtFact;
    	MnzPiece : TmenuItem;
      TOBFacturable,TOBmemoFact,TOBAFACTURER,TOBReference,TheOldFac : TOB;
      Blance : TToolbarButton97;
      Fliste : THDbGrid;
      GS : THgrid;
      SqlBase,ColName : string;
      RefPieceSel : String;
      Avancement : boolean;
      //
      procedure SetEventsGridListe(Etat : boolean);
      procedure GetControls;
      procedure FlisteDblClick (Sender : TObject);
      function Chargefacturation(TOBFacture : TOB) : boolean;
      function WhereRefPieceSel(TOBL : TOB) : string;
      procedure ChargeLesDevisNonFacture(Affaire,TypeFac: string; NumSelected,Indice : integer);
      procedure NewFacturation (Naturepieceg,Souche : string; Numero,Indice : integer);
      procedure InitGrilleGS;
      procedure AfficheLagridGS;
      procedure TraiteChampAffaireGrid(Gr: THGrid; Nom: string; Col: integer);
      procedure SetEventsGridGS (etat : boolean);
      procedure FlipThisRow (Sender: TObject; ARow: Integer;var Cancel: Boolean);
      function  Existefac (TOBL : TOB): boolean;
      procedure SetEvents;
      procedure BlanceClick (Sender : Tobject);
      procedure EnregistreSelection;
      procedure Majmemorisation;
      procedure SupprimeMemo;
      procedure BchercheClick;
      procedure beforeSelection;
      function FindFirstSelected: TOB;
      function IsPieceSelectionnable(Arow: integer): boolean;
      function ExisteFacturationOld (var Affaire,Naturepieceg,Souche : string; var Numero,Indice : integer) : TResultS;
      procedure ChargeOldfacturation;
      function ExistDevis(cledoc: r_cledoc): boolean; overload;
      function ExistDevis(TOBL : TOB): boolean; overload;
    	function IsPresentDansFactureOld(var TheRefDevis : string;cledoc: r_cledoc): boolean;
      procedure VoirPiece (Sender : TObject);
      function MontantDevZero : boolean;
      procedure GSPostDrawCell (ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    	procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean;Chg: Boolean);
    	procedure GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean;Chg: Boolean);
      procedure VerifDevisFromFacturation (TOBTMP : TOB);
    	function ControleEtatDevisPrinc(NaturepieceG, Souche: string; Numero,IndiceG: integer): boolean;
      function ConfirmationCloture : boolean;
      function ControleArticleEcartFact : boolean;
    	function AddSelection(TOBP: TOB; NumOrdre: integer;var MessageErreur: string): boolean;
    //
  end ;


Implementation
uses factcomm,FactTOB,FactTvaMilliem,FactCOmmBTP,facture,UtilPgi,UtilArticle,ParamSoc,UTOFBTClotureDev;

procedure TOF_BTSELFAC_MUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.OnLoad ;
begin
  Inherited ;
  GS.visible := false;
end ;

procedure TOF_BTSELFAC_MUL.OnArgument (S : String ) ;
begin
  Inherited ;
  //
  if Pos('CLOTURE',S)> 0 then ModeTraitement := TmtCloture else ModeTraitement := TmtFacturation;
  //
  if ModeTraitement = TmtCloture then
  begin
  	DateCloture := V_PGI.DateEntree;
  	ecran.Caption := Traduirememoire('Cloture de facturation');
    UpdateCaption(ecran);
  end;
  TheOldFac := TOB.Create ('LA DERNIERE FACTURE EMISE',nil,-1);
  SqlBase := 'SELECT GP_AFFAIRE,GP_NATUREPIECEG,GP_DATEPIECE,GP_NUMPIECE,GP_PRENUMERO,GP_NUMERO,GP_SOUCHE,GP_INDICEG,GP_TIERS,'+
             'GP_ETABLISSEMENT,GP_REFINTERNE,GP_REPRESENTANT,GP_APPORTEUR,GP_DEVISE,GP_TOTALTTC,GP_TOTALHT,GP_ETATVISA,GP_VIVANTE,'+
             'GP_EDITEE,GP_AFFAIRE1,GP_AFFAIRE2,GP_AFFAIRE3 ,GP_AVENANT,GP_AFFAIREDEVIS,AFF_AFFAIRE1,AFF_AFFAIRE2,'+
             'AFF_AFFAIRE3 ,AFF_AFFAIRE0,AFF_AVENANT,AFF_AFFAIRE,AFF_ETATAFFAIRE, AFF_GENERAUTO,AFF_ADMINISTRATIF, AFF_MODELE,AFF_OKSIZERO '+
             'FROM PIECE LEFT OUTER JOIN AFFAIRE on AFF_AFFAIRE=GP_AFFAIREDEVIS ';
  //
  TOBFacturable := TOB.create ('LA LISTE DES DEVIS',nil,-1);
  TOBmemoFact := TOB.Create ('LES MEMORISATIONS',nil,-1);
  TOBAFACTURER := TOB.Create ('LES PIECES',nil,-1);
  GetControls;
  SetEventsGridListe(True);  // sur Fliste
  SetEvents;
  InitGrilleGS;
  GS.visible := false;
end ;

procedure TOF_BTSELFAC_MUL.OnClose ;
begin
  TheOldFac.free;
  TOBFacturable.free;
  TOBmemoFact.free;
  TOBAFACTURER.free;
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTSELFAC_MUL.SetEventsGridListe(Etat: boolean);
begin
  if Etat then
  begin
  	Fliste.OnDblClick := FlisteDblClick
  end else
  begin
  	Fliste.OnDblClick := nil;
  end;
end;

procedure TOF_BTSELFAC_MUL.GetControls;
begin
  Fliste := THDbGrid(GetCOntrol('Fliste'));
  GS := THgrid(GetCOntrol('GS'));
  Blance := TToolbarButton97 (GetControl('BOUVRIR'));
  GS.visible := false;
	MnzPiece := TmenuItem (GetControl('mnZPiece'));
end;

procedure TOF_BTSELFAC_MUL.FlisteDblClick(Sender: TObject);
var Affaire,Naturepieceg,Souche,TypeFac,Sql : string;
    Numero,IndiceG : integer;
    QQ : TQuery;
    TOBFacture : TOB;
    DevisPrinc : string;
    MessAttente : TFsplashScreen;
    sortie : TResultS;
begin
	if not ControleArticleEcartFact then
  BEGIN
//    PgiError (TraduireMemoire('L''article d''�cart est invalide ou non renseign�#13#10Veuillez le d�finir'),Traduirememoire('Gestion d''�cart'));
    exit;
  END;
  if ModeTraitement = TmtCloture then
  begin
    if not ConfirmationCloture then exit;
    if not SaisieDateCloture (DateCloture) then exit;
  end;
  //
  TheOldFac.clearDetail;
  TOBFacturable.clearDetail;
  //
  DevisPrinc := '';
  TOBFacture := TOB.Create('LA MEMO FACTURE',nil,-1);
  With TFMul(Ecran) do
  begin
    {$IFDEF EAGLCLIENT}
    Q.TQ.Seek(FListe.Row-1) ;
    {$ENDIF}
    TypeFac := Q.findField('AFF_GENERAUTO').AsString;
    Affaire := Q.FindField('GP_AFFAIRE').asstring;
    NaturepieceG := Q.FindField('GP_NATUREPIECEG').asstring ;
    Souche := Q.FindField('GP_SOUCHE').asstring ;
    Numero := Q.FindField('GP_NUMERO').asInteger ;
    IndiceG := Q.FindField('GP_INDICEG').asInteger ;
  end;
  fTypeFacturation := TypeFac;
  if (Pos(TypeFac,'AVA;DAC;')>0) then
  begin
    Avancement := True;
  end else
  begin
    Avancement := false;
  end;
  RefPieceSel := EncoderefSel (NaturePieceg,Souche,Numero,IndiceG);
  QQ := OpenSql ('SELECT BMF_DEVISPRINC FROM BTMEMOFACTURE WHERE BMF_DEVIS="'+RefPieceSel+'"',true);
  if not QQ.eof then
  begin
    // on change la reference de la piece initiale par le devis initial de la facture
    DevisPrinc  := QQ.findfield('BMF_DEVISPRINC').AsString;
  end;
  ferme(QQ);
  // Phase 1 -- On recup les devis d'une facture existante
  if DevisPrinc <> '' then
  begin
    Sql := 'SELECT * FROM BTMEMOFACTURE WHERE BMF_DEVISPRINC="'+DevisPrinc+'"';
    TOBFacture.LoadDetailDBFromSQL ('BTMEMOFACTURE',Sql,false);
    TRY
      RefPieceSel := DevisPrinc;
      if not Chargefacturation(TOBFacture) then
      begin
      	PgiInfo ('Facturation impossible. La facturation � �t� clotur�',ecran.Caption);
      	exit;
      end;
    FINALLY
      TOBFacture.free;
    END;
  end else
  begin
    Sortie := ExisteFacturationOld (Affaire,Naturepieceg,Souche,Numero,IndiceG);
    if Sortie = Btrsok then
    begin
      if ControleEtatDevisPrinc (NaturepieceG,Souche,Numero,IndiceG) then
      begin
        MessAttente := TFsplashScreen.Create (ecran);
        MessAttente.Label1.Caption := 'R�cup�ration de la structure de la facture en cours ...';
        MessAttente.Animate1.Active := true;
        MessAttente.Show;
        MessAttente.Refresh;
        ChargeOldfacturation;
        MessAttente.free;
      end else
      begin
      	Exit;
      end;
    end else if Sortie = BtrsNone then
    begin
      NewFacturation (NaturepieceG,Souche,Numero,IndiceG);
    end else if Sortie = BtrsAnnul then
    begin
      exit;
    end;
  end;
  TheOldFac.clearDetail;
  // Phase 2 -- Selection des devis non factur�s
  ChargeLesDevisNonFacture (Affaire,TypeFac,Numero,IndiceG);
  beforeSelection;
  // Now c'est correct -- On peut afficher la grille de multiselection
  AfficheLagridGS;
  GS.Visible := true;
//  if TOBfacturable.detail.count = 1 then BlanceClick (self);

end;

procedure TOF_BTSELFAC_MUL.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2,
  Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers,
  Tiers_: THEdit);
begin
  inherited;
  Aff0 := THEdit(GetControl('AFFAIRE0'));
  Aff := THEdit(GetControl('GP_AFFAIRE'));
  Aff1 := THEdit(GetControl('GP_AFFAIRE1'));
  Aff2 := THEdit(GetControl('GP_AFFAIRE2'));
  Aff3 := THEdit(GetControl('GP_AFFAIRE3'));
  Aff4 := THEdit(GetControl('GP_AVENANT'));

end;

function TOF_BTSELFAC_MUL.Chargefacturation(TOBFacture: TOB) : boolean;
var Sql : string;
    TOBDevis,TOBL : TOB;
    Indice : integer;
    QQ : TQuery;
begin
	result := true;
  For Indice := 0 to TOBFacture.detail.count -1 do
  begin
    TOBL := TOBFacture.detail[Indice];
    Sql := Sqlbase+' WHERE '+WhereRefPieceSel(TOBL);
    QQ := OPenSql (Sql,True);
    if not QQ.eof then
    begin
      TOBDevis := TOB.Create ('PIECE',nil,-1);
      TOBdevis.AddChampSupValeur ('AFF_GENERAUTO','');
      TOBDevis.selectDb('',QQ);
      if (Indice = 0) and (TOBDevis.GetValue('AFF_ETATAFFAIRE')='TER') then
      begin
      	TOBDevis.free;
      	ferme(QQ);
      	Result := false;
        exit;
      end;
      TOBDevis.changeparent(TOBFacturable,-1);
      TOBDevis.AddChampSupValeur ('SELECTED','X');
      if indice = 0 then TOBReference := TOBdevis;
    end;
    ferme(QQ);
  end;
end;

function TOF_BTSELFAC_MUL.WhereRefPieceSel(TOBL: TOB): string;
var cledoc : r_cledoc;
begin
   DecodeRefPiece(TOBL.GetValue('BMF_DEVIS'),Cledoc);
   result := WherePiece (cledoc,ttdpiece,true);
end;

procedure TOF_BTSELFAC_MUL.ChargeLesDevisNonFacture (Affaire,TypeFac: string; NumSelected,Indice : integer);
var
    Part0,Part1,Part2,Part3,Avenant : string;
    Sql : string;
    TOBLocal : TOB;
begin
  BTPCodeAffaireDecoupe(Affaire,Part0,Part1,Part2,Part3,Avenant,taModif,false);
  if Avenant = '00' then
  begin
    TOBLOcal := TOB.Create('LES DOCUMENTS',nil,-1);
    Sql := SqlBase + ' WHERE GP_AFFAIRE1="'+Part1+'" AND GP_AFFAIRE2="'+Part2+'" AND GP_AFFAIRE3="'+Part3+'" AND '+
          'GP_NATUREPIECEG = "DBT" AND AFF_ETATAFFAIRE="ACP" '+
          'AND NOT EXISTS (SELECT BMF_DEVIS FROM BTMEMOFACTURE WHERE BMF_NATUREPIECEG=GP_NATUREPIECEG AND '+
                           'BMF_SOUCHE=GP_SOUCHE AND BMF_NUMERO=GP_NUMERO AND BMF_INDICEG=GP_INDICEG) '+
          'AND (GP_NUMERO <> '+IntToStr(Numselected)+' OR GP_INDICEG <> '+IntToStr(Indice)+') '+
          'AND AFF_GENERAUTO="'+TypeFac+'" '+
          'AND AFF_ADMINISTRATIF <> "X" AND AFF_MODELE <> "X"';
    TOBLOcal.LoadDetailDBFromSQL ('PIECE',Sql,true);
    if TOBlocal.detail.count > 0 then
    begin
      Indice := 0;
      repeat
        if not ExistDevis (TOBlocal.detail[Indice]) then
        begin
          TOBLOcal.detail[Indice].AddChampSupValeur ('SELECTED','-');
          TOBLocal.detail[Indice].changeparent (TOBfacturable,-1);
        end else inc(indice);
      until Indice >= TOBLocal.detail.count;
    end;
    TOBLocal.free;
  end;
end;

procedure TOF_BTSELFAC_MUL.NewFacturation(Naturepieceg, Souche: string;Numero, Indice: integer);
var Sql : string;
    Piece : string;
    cledoc : r_cledoc;
    TOBDevis : TOB;
    QQ : Tquery;
begin
   Piece := EncoderefSel (Naturepieceg,Souche,Numero,Indice);
   DecodeRefPiece(Piece,Cledoc);
   Sql := SqlBase + ' WHERE '+WherePiece (cledoc,ttdpiece,true);
   QQ := OpenSql (Sql,true);
   if not QQ.eof then
   begin
      TOBDevis := TOB.Create ('PIECE',nil,-1);
      TOBDevis.selectDb('',QQ);
      TOBDevis.changeparent(TOBFacturable,-1);
      TOBdevis.AddChampSupValeur ('SELECTED','X');
      TOBReference := TOBdevis;
   end;
   Ferme (QQ);
end;

procedure TOF_BTSELFAC_MUL.InitGrilleGS;
var Col,Dec, FixedWidth, Larg : integer ;
    tal : TAlignment ;
    STitre,St,Ch,stA,FF,Typ,FPerso : string ;
    NomList,FRecordSource,FLien,FSortBy,FFieldList,FLargeur,FAlignement,FParams : string ;
    Sep,Obli,OkLib,OkVisu,OkNulle,OkCumul,OkTri,OkNumCol : boolean ;
    Nom : string;
    lescolonnes : string;
    Indice : integer;
    Ftitre,tt,NC : Hstring;
begin
  FixedWidth:=6;
  GS.ColCount:=60;
  Col:=1; STitre:=' '; ColName:='Fixed';

  With TFMul(Ecran) do
  BEGIN
    NomList:=Q.Liste;
    ChargeHListe(NomList,FRecordSource,FLien,FSortBy,FFieldList,FTitre,FLargeur,FAlignement,FParams,tt,NC,FPerso,OkTri,OkNumCol);
    GS.Titres.Add(FFieldList) ;
    While Ftitre<> '' do
    BEGIN
      StA:=ReadTokenSt(FAlignement);
      St:=ReadTokenSt(Ftitre);
      Ch:=ReadTokenSt(FFieldList);
      Larg:=ReadTokenI(FLargeur);
      tal:=TransAlign(StA,FF,Dec,Sep,Obli,OkLib,OkVisu,OkNulle,OkCumul) ;
      if OkVisu then
      BEGIN
        GS.Cells[Col,0]:=St ;
        GS.ColAligns[Col]:=tal;
        GS.ColWidths[Col]:=Larg*GS.Canvas.TextWidth('W') ;
        if OkLib then GS.ColFormats[Col]:='CB=' + Get_Join(Ch);
        Typ:=ChampToType(Ch) ;
        if (Typ='INTEGER') or (Typ='SMALLINT') or (Typ='DOUBLE') then GS.ColFormats[Col]:=FF ;
        STitre:=STitre+';'+St;
        ColName:=ColName+';'+Ch;
        inc (Col);
      END;
    END;
    GS.ColCount:=Col ;
    GS.ColWidths[0]:=FixedWidth;
  END ;
  //
  lescolonnes := ColName;
  Nom := READTOKENST (LesColonnes);
  Indice := 0;
  repeat
    TraiteChampAffaireGrid (GS,Nom,indice);
    Nom := READTOKENST (LesColonnes);
    inc(Indice);
  until nom='';
  GS.Options:=GS.Options-[GoEditing,GoTabs,GoAlwaysShowEditor] ;
  GS.Options:=GS.Options+[GoRowSelect] ;
  GS.MultiSelect := true;
  GS.TwoColors := true;
end;

procedure TOF_BTSELFAC_MUL.AfficheLagridGS;
var Indice : integer;
begin
  SetEventsGridGS (false);
  //
  GS.ClearSelected;
  GS.VidePile (false);
  GS.rowCount := TOBFacturable.detail.count+1;
  For Indice := 0 to TOBFacturable.detail.count -1 do
  begin
    TOBFacturable.detail[Indice].PutLigneGrid (GS,Indice+1,false,false,ColName);
    GS.Objects [0,Indice+1] := TOBFacturable.detail[Indice];
    if TOBFacturable.detail[Indice].GetValue('SELECTED')='X' then GS.FlipSelection (Indice+1);
  end;
  //
  SetEventsGridGS (True);
end;

Procedure TOF_BTSELFAC_MUL.TraiteChampAffaireGrid ( Gr : THGrid; Nom : string; Col : integer);
Var  Lg,ind,NumPart : integer;
     NomChamp,Libelle : string;
     Visible : Boolean;
begin
if nom = '' then Exit;
lg := Length(Nom); ind:= Pos ('_',Nom);
if (lg =0) or (ind = 0) then  exit;
Nomchamp := Copy (Nom, ind+1,lg-ind);
Visible:=False; //mcd 14/02/03
If ((Nomchamp = 'AFFAIRE1') Or (Nomchamp = 'AFFAIRE2') Or (Nomchamp = 'AFFAIRE3')) Then
  Begin
  NumPart := StrToInt(Copy(NomChamp, 8,1));
  Case NumPart Of
      1 : Begin Visible:=True; Libelle:=VH_GC.CleAffaire.Co1Lib;  End;
      2 : Begin Visible:=VH_GC.CleAffaire.Co2Visible; Libelle:=VH_GC.CleAffaire.Co2Lib; End;
      3 : Begin Visible:=VH_GC.CleAffaire.Co3Visible; Libelle:=VH_GC.CleAffaire.Co3Lib; End;
      End;
  if not(Visible) then Gr.colwidths[Col]:=0;
  Gr.Cells[Col,0]:=Libelle;
  End;
if ((Nomchamp='AVENANT') and Not(VH_GC.CleAffaire.GestionAvenant)) then Gr.colwidths[Col]:=0;
end;


procedure TOF_BTSELFAC_MUL.SetEventsGridGS(etat: boolean);
begin
  if Etat  then
  begin
    GS.OnBeforeFlip := FlipThisRow;
    GS.PostDrawCell := GSPostDrawCell;
    GS.OnRowEnter   := GSRowEnter;
    GS.OnRowExit    := GSRowExit;
  end else
  begin
    GS.OnBeforeFlip := nil;
    GS.PostDrawCell := nil;
    GS.OnRowEnter   := nil;
    GS.OnRowExit    := nil;
  end;
end;

function TOF_BTSELFAC_MUL.IsPieceSelectionnable(Arow : integer) : boolean;
var TOBL : TOB;
begin
  result := true;
  TOBL := TOB(GS.Objects [0,Arow]);
  if TOBreference <> nil then
  begin
    if TOBreference.getValue('RUPTMILLIEME')<> TOBL.getValue('RUPTMILLIEME') then
    begin
      result := false;
    end;
  end;
  if Existefac (TOBL) then
  BEGIN
    PgiBox('Impossible. Il existe une facturation sur ce devis');
    result := false;
  end;
end;

procedure TOF_BTSELFAC_MUL.FlipThisRow(Sender: TObject; ARow: Integer; var Cancel: Boolean);
var TOBL : TOB;
begin
  if GS.IsSelected (Arow) then
  begin
    // Cas ou l'on veut enlever un devis de la s�lection
    // On verifie alors s'il existe des lignes de LIGNEFAC pour ce devis
    TOBL := TOB(GS.Objects [0,Arow]);
    if Existefac (TOBL) then
    BEGIN
      PgiBox('Impossible. Il existe une facturation sur ce devis');
      cancel := true;
    end;
    if TOBL = TOBreference then TOBreference := FindFirstSelected;
  end else
  begin
    If not IsPieceSelectionnable(Arow) then begin cancel := true;exit; end;
    if TOBreference = nil then TOBreference := TOB(GS.Objects [0,Arow]);
  end;
end;

function TOF_BTSELFAC_MUL.FindFirstSelected : TOB;
var Indice : integer;
begin
  result := nil;
  for Indice := 1 to GS.rowCount do
  begin
    if GS.IsSelected (Indice) then
    begin
      result := TOB(GS.Objects [0,Indice]);
      break;
    end;
  end;
end;

function TOF_BTSELFAC_MUL.Existefac(TOBL: TOB): boolean;
var req : string;
begin
	// Sur Affaire type avancement
  result := false;
  req := 'SELECT ##TOP 1## BLF_NUMORDRE FROM LIGNEFAC WHERE BLF_NATUREPIECEG="'+
         TOBL.GetValue('GP_NATUREPIECEG')+'" AND BLF_SOUCHE="'+TOBL.GetValue('GP_SOUCHE')+'" '+
         'AND BLF_NUMERO='+InttoStr(TOBL.GetValue('GP_NUMERO'))+' AND BLF_INDICEG='+InttoStr(TOBL.GetValue('GP_INDICEG'));
  if ExisteSql(Req) then BEGIN result := True; Exit; END;
  req := 'SELECT ##TOP 1## BST_NUMEROSIT FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+ TOBL.GetValue('GP_AFFAIREDEVIS')+'"';
  if ExisteSql(Req) then BEGIN result := True; Exit; END;
  // Sur affaire type directe ou type avancement (ant�riorit� V7)
  req := 'SELECT GL_PIECEPRECEDENTE FROM LIGNE WHERE (GL_NATUREPIECEG IN ("FBT","DAC")) AND '+
  			 '(GL_PIECEPRECEDENTE LIKE "%;'+TOBL.GetValue('GP_NATUREPIECEG')+';'+
         TOBL.GetValue('GP_SOUCHE')+';'+IntToStr(TOBL.GetValue('GP_NUMERO'))+';'+
         InttoStr(TOBL.GetValue('GP_INDICEG'))+';%")';
  if ExisteSql(Req) then BEGIN result := True; Exit; END;
end;

procedure TOF_BTSELFAC_MUL.SetEvents;
begin
  Blance.OnClick := BlanceClick;
  mnZPiece.OnClick := VoirPiece;
end;

procedure TOF_BTSELFAC_MUL.BlanceClick(Sender: Tobject);
begin
  if GS.visible then
  begin
  	if not MontantDevZero then
    begin
    	EnregistreSelection;
    end else
    begin
      PgiBox('Certains documents dont le montant est nul doivent �tre recalcul�s...');
    end;
  end else
  begin
    PgiBox('Vous n''avez pas encore s�lectionn� de devis');
  end;
end;

procedure TOF_BTSELFAC_MUL.EnregistreSelection;
var Arow,Numordre : integer;
    TOBP : TOB;
    io: TIoErr;
    DocOk : boolean;
    TRAITEMENT,MessageErreur : String;
begin
  Numordre := 0;
  TOBmemoFact.clearDetail;
  TOBAfacturer.clearDetail;
  DocOk := true;
  for Arow := 1 to GS.rowCount do
  begin
    if GS.IsSelected (Arow) then
    begin
      Inc(NumOrdre);
      TOBP := TOB(GS.objects[0,Arow]);
      DocOk := AddSelection(TOBP,NumOrdre,MessageErreur);
      if not DocOk then break;
    end;
  end;
  if not DocOk then
  BEGIN
  	PgiInfo (MessageErreur);
    BchercheClick;
    exit;
  END;
  io := TRANSACTIONS (Majmemorisation,0);
  if io = OeOk then
  begin
    if TOBAFacturer.detail.count > 0 then
    begin
      // Go la saisie ..go
      TheTOB := TOBAFACTURER;
      if ModeTraitement = TmtCloture then TRAITEMENT :='CLOTURE' else TRAITEMENT :='';
      AglLanceFiche ('BTP','BTSAISIEAVANC','','',TRAITEMENT);
      TheTOB := Nil;
    end;
    BchercheClick;
  end else
  begin
    PGIError ('ATTENTION : S�lection non enregistr�e');
    BchercheClick;
  end;
end;

function TOF_BTSELFAC_MUL.AddSelection(TOBP : TOB; NumOrdre : integer; var MessageErreur : string) : boolean;
var TOBMF : TOB;
    Document,Sql : string;
    QQ : TQuery;
    piece : string;
    cledoc : r_cledoc;
begin
	result := true;
	Sql := 'SELECT BLO_UNIQUEBLO FROM LIGNEOUV WHERE BLO_NATUREPIECEG="'+TOBP.GetValue('GP_NATUREPIECEG')+'" AND '+
  			 'BLO_SOUCHE="'+TOBP.GetValue('GP_SOUCHE')+'" AND BLO_NUMERO='+intToStr(TOBP.GetValue('GP_NUMERO'))+ ' AND '+
         'BLO_INDICEG='+IntToStr(TOBP.GetValue('GP_INDICEG'))+' AND BLO_UNIQUEBLO=0';
  if ExisteSQL(Sql) then
  begin
  	result := false;
    MessageErreur := 'Veuillez mettre � niveau les documents dans "Administration/Mise � niveau/Documents"';
  end;
  // Constitution de la Memorisation
  TOBMF := TOB.Create ('BTMEMOFACTURE',TOBmemoFact,-1);
  TOBMF.putValue('BMF_AFFAIRE',TOBP.GetValue('GP_AFFAIRE'));
  TOBMF.putValue('BMF_AFFAIRE1',TOBP.GetValue('GP_AFFAIRE1'));
  TOBMF.putValue('BMF_AFFAIRE2',TOBP.GetValue('GP_AFFAIRE2'));
  TOBMF.putValue('BMF_AFFAIRE3',TOBP.GetValue('GP_AFFAIRE3'));
  TOBMF.putValue('BMF_DEVISPRINC',RefPieceSel);
  Document := EncoderefSel (TOBP);
  TOBMF.putValue('BMF_DEVIS',document);
  TOBMF.putValue('BMF_NATUREPIECEG',TOBP.GetValue('GP_NATUREPIECEG'));
  TOBMF.putValue('BMF_SOUCHE',TOBP.GetValue('GP_SOUCHE'));
  TOBMF.putValue('BMF_NUMERO',TOBP.GetValue('GP_NUMERO'));
  TOBMF.putValue('BMF_INDICEG',TOBP.GetValue('GP_INDICEG'));
  TOBMF.putValue('BMF_NUMORDRE',NumOrdre);
  // constitution de la TOB des pices a facturer
  TOBMF := TOB.create ('PIECE',TOBAFACTURER,-1);
  Piece := EncodeRefPiece (TOBP);
  DecodeRefPiece (Piece,Cledoc);
  QQ := OpenSql ('SELECT PIECE.*,AFF_GENERAUTO,AFF_OKSIZERO,AFF_MANDATAIRE FROM PIECE '+
  							 'LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS '+
                 'WHERE '+WherePiece (Cledoc,ttdPiece,false),true);
  if not QQ.eof then
  begin
    TOBMF.SelectDB ('',QQ);
    TOBAfacturer.AddChampSupValeur ('GP_AFFAIRE',TOBMF.GetValue('GP_AFFAIRE'));
    TOBAfacturer.AddChampSupValeur ('GP_TIERS',TOBMF.GetValue('GP_TIERS'));
    TOBAfacturer.AddChampSupValeur ('LIBELLEAFFAIRE',GetChampsAffaire(TOBMF.GetValue('GP_AFFAIRE'),'AFF_LIBELLE'));
    TOBAfacturer.AddChampSupValeur ('LIBELLETIERS',RecupLibelleTiers(TOBMF.GetValue('GP_TIERS')));
    TOBAfacturer.AddChampSupValeur ('AFF_GENERAUTO',TOBMF.GetValue('AFF_GENERAUTO'));
    TOBAfacturer.AddChampSupValeur ('DATECLOTURE',DateCloture);
    TOBAfacturer.AddChampSupValeur ('AFF_MANDATAIRE',TOBMF.GetValue('AFF_MANDATAIRE'));
  end;
  ferme(QQ);
end;


procedure TOF_BTSELFAC_MUL.Majmemorisation;
begin
  SupprimeMemo ;
  if TOBmemofact.detail.count > 0 then if not TOBmemofact.InsertDB (nil) then V_PGI.IOError := OeUnknown;
end;

procedure TOF_BTSELFAC_MUL.SupprimeMemo;
begin
  V_PGI.ioerror := OeOk;
  ExecuteSql ('DELETE FROM BTMEMOFACTURE WHERE BMF_DEVISPRINC="'+RefPieceSel+'"');
end;

procedure TOF_BTSELFAC_MUL.BchercheClick;
begin
  TToolBarButton97(GetCOntrol('BCHERCHE')).Click;
end;

procedure TOF_BTSELFAC_MUL.beforeSelection;
var Indice : integer;
    TOBL,TOBMilliemes : TOB;
    QQ : TQuery;
    cledoc : r_cledoc;
begin
  TOBMilliemes := TOB.Create ('LES MILLIEMEES',nil,-1);
  for Indice := 0 to TOBFacturable.detail.count -1 do
  begin
    TOBL := TOBfacturable.detail[Indice];
 		TOBL.AddChampSupValeur('AVANCSAISIE',0);
 		TOBL.AddChampSupValeur('AVANCPREC',0);
 		TOBL.AddChampSupValeur('RUPTMILLIEME','');
    //
    TOBMilliemes.ClearDetail;
    Cledoc := TOB2CleDoc (TOBL);
    QQ := OPenSql ('SELECT BPM_CATEGORIETAXE,BPM_FAMILLETAXE,BPM_MILLIEME FROM BTPIECEMILIEME WHERE '+WherePiece (Cledoc,TTdRepartmill,false),True);
    if not QQ.eof then
    begin
     TOBMilliemes.LoadDetailDB ('BTPIECEMILIEME','','',QQ,false);
     TOBL.putValue('RUPTMILLIEME',EncodeRepartTva (TOBMilliemes));
    end;
    Ferme(QQ);
  end;
  TOBMilliemes.free;
end;

function TOF_BTSELFAC_MUL.IsPresentDansFactureOld (Var TheRefDevis : string; cledoc : r_cledoc) : boolean;
var SQl,ClePiece : String;
		QQ : TQuery;
    TOBDFact : TOB;
begin
	result := false;
	TOBDfact := TOB.create ('LES FACTURES', nil,-1);
  TRY
    ClePiece :=';'+Cledoc.NaturePiece+';'+Cledoc.souche+';'+IntToStr(Cledoc.NumeroPiece)+';';
    Sql := 'SELECT DISTINCT BST_SSAFFAIRE FROM LIGNE '+
    			 'LEFT JOIN BSITUATIONS ON BST_NATUREPIECE=GL_NATUREPIECEG AND '+
           'BST_SOUCHE=GL_SOUCHE AND BST_NUMEROFAC=GL_NUMERO WHERE '+
           'GL_NATUREPIECEG="FBT" AND GL_PIECEPRECEDENTE LIKE "%'+ClePiece+'%"';
    QQ := OpenSql (Sql,true,-1,'',True);
    if not QQ.eof then
    begin
      TOBDfact.LoadDetailDB('UNE LIGNE','','',QQ,false);
      TheRefDevis := TOBDfact.detail[0].getValue('BST_SSAFFAIRE');
      result := true;
    end;
    ferme (QQ);
  FINALLY
  	TOBDFact.free;
  END;
end;

function TOF_BTSELFAC_MUL.ExisteFacturationOld(var Affaire,Naturepieceg,Souche: string; var Numero, Indice: integer): TResultS;
var QQ : TQuery;
    TheRefDevis : string;
    TOBTMP,TOBSEL : TOB;
    req : string;
    cledoc : r_cledoc;
begin
  result := BtrsNone;
  TOBTMP := TOB.Create ('LES SITUATIONS SUR LAFFAIRE',nil,-1);
  TheRefDevis := '';
  QQ := OpenSql ('SELECT GP_AFFAIREDEVIS FROM PIECE WHERE GP_NATUREPIECEG="'+NaturepIeceg+'" AND '+
                 'GP_SOUCHE="'+SOuche+'" AND GP_NUMERO='+InttoStr(Numero)+' AND GP_INDICEG='+InttOstr(Indice),True,-1,'',true);
  if not QQ.eof then
  begin
    TheRefDevis := QQ.findField('GP_AFFAIREDEVIS').AsString;
  end;
  ferme (QQ);

  if not avancement then
  begin
  	result := BtrsNone;
    exit;
  end;

  if TheRefDevis <> '' then
  begin
    QQ := OpenSQL ('SELECT * FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+TheRefDevis+'" ORDER BY BST_NUMEROFAC',true,-1,'',true);
    if not QQ.eof then
    begin
      TheOldFac.LoadDetailDB ('BSITUATIONS','','',QQ,false);
      result := BtrsOK;
    end;
    ferme (QQ);
  end;
  // cas de figure ou il n'existe pas de facturation pr�c�dente avce le devis indiqu� comme devis principal
  if result <> Btrsok then
  begin
  	//
    cledoc.NaturePiece := Naturepieceg;
    cledoc.Souche      := Souche;
    cledoc.NumeroPiece := Numero;
    cledoc.Indice := Indice;
    if IsPresentDansFactureOld (TheRefDevis,cledoc) then
    begin
      Naturepieceg := Copy(TheRefDevis,2,3);
      Souche := Copy(TheRefDevis,5,3);
      Numero := Strtoint(Copy(TheRefDevis,8,8));
      Indice := 0;
      result := BtrsOK;
      QQ := OpenSQL ('SELECT * FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+TheRefDevis+'" ORDER BY BST_NUMEROFAC',true,-1,'',true);
      if not QQ.eof then
      begin
        TheOldFac.LoadDetailDB ('BSITUATIONS','','',QQ,false);
        result := BtrsOK;
      end;
      ferme (QQ);
      exit;
    end;
    //
    REq := 'SELECT B1.* FROM BSITUATIONS B1 WHERE B1.BST_AFFAIRE="'+Affaire+'" AND B1.BST_NUMEROSIT=(SELECT MAX(B2.BST_NUMEROSIT) FROM BSITUATIONS B2 WHERE B2.BST_SSAFFAIRE=B1.BST_SSAFFAIRE) ORDER BY B1.BST_DATESIT';
    QQ := OpenSQL (req,true,-1,'',true);
    if not QQ.eof then
    begin
      TOBTMP.loadDetailDb ('SITUATIONS','','',QQ,false);
    end;
    ferme (QQ);
    // TODO (evacuer ici les factures sur les devis termine ...cf cloture)
    VerifDevisFromFacturation (TOBTMP);
    //
    if TOBTMP.detail.count <> 0 then
    begin
      TOBSEL := ChoixSelectionFacture (TOBTMP);
      if TOBSel <> nil then
      begin
        TheRefDevis := TOBSel.getValue('BST_SSAFFAIRE');
        if TheRefDevis <> '' then
        begin
          QQ := OpenSQL ('SELECT * FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+TheRefDevis+'" ORDER BY BST_NUMEROFAC',true,-1,'',true);
          if not QQ.eof then
          begin
            TheOldFac.LoadDetailDB ('BSITUATIONS','','',QQ,false);
            Naturepieceg := Copy(TheRefDevis,2,3);
            Souche := Copy(TheRefDevis,5,3);
            Numero := Strtoint(Copy(TheRefDevis,8,8));
            Indice := 0;
            result := BtrsOK;
          end;
          ferme (QQ);
        end else
        begin
          TOBSel.free;
        end;
      end else
      begin
        result := BtrsAnnul;
      end;
    end;
  end;
end;

function TOF_BTSELFAC_MUL.ExistDevis (cledoc : r_cledoc): boolean;
begin
  result :=  (TOBFacturable.FindFirst(['GP_NATUREPIECEG','GP_SOUCHE','GP_NUMERO','GP_INDICEG'],
                                [cledoc.NaturePiece,cledoc.Souche,cledoc.NumeroPiece,Cledoc.Indice],true)<>nil);
end;

procedure TOF_BTSELFAC_MUL.ChargeOldfacturation;
var TOBDevis,TOBFacture,TheLastFacture,TOBL : TOB;
    indice,IndFac : integer;
    QQ : TQuery;
    cledoc : R_CLEDOC;
    first : boolean;
begin
  first := true;
  TOBfacture := TOB.Create ('LA FACTURE',nil,-1);
  TRY
    for IndFac := 0 to TheOldFac.detail.count -1 do
    begin
      TOBFacture.clearDetail;
      TheLastFacture := TheOldFac.detail[IndFac];
      TOBfacture.LoadDetailDBFromSQL ('LIGNE','SELECT DISTINCT (GL_PIECEPRECEDENTE) FROM LIGNE '+
                                      'WHERE GL_NATUREPIECEG="'+TheLastFacture.getValue('BST_NATUREPIECE')+'" AND '+
                                      'GL_SOUCHE="'+TheLastFacture.getValue('BST_SOUCHE')+'" AND '+
                                      'GL_NUMERO='+IntToStr(TheLastFacture.getValue('BST_NUMEROFAC')),false);
// modif brl pour pb regroupement sur DAC ABH PACE (cas du devis principal sans ligne article factur�e)
//'GL_NUMERO='+IntToStr(TheLastFacture.getValue('BST_NUMEROFAC'))+' AND GL_TYPELIGNE="ART"',false);
      if TOBfacture.detail.count <> 0 then
      begin
        for Indice := 0 to TOBFacture.detail.count -1 do
        begin
          TOBL := TOBFacture.detail[Indice];
// modif brl pour pb regroupement sur DAC ABH PACE (cas du devis principal sans ligne article factur�e)
//          if TOBL.getValue('GL_TYPELIGNE')<>'ART' then continue;
          if TOBL.getValue('GL_PIECEPRECEDENTE')='' then continue;
          DecodeRefPiece (TOBL.getValue('GL_PIECEPRECEDENTE'),cledoc);
          //
          if not ExistDevis (Cledoc) then
          begin
            QQ := OpenSql (SqlBase +'WHERE GP_NATUREPIECEG="'+Cledoc.NaturePiece+'" AND '+
                           'GP_SOUCHE="'+Cledoc.Souche+'" AND GP_NUMERO='+InttoStr(cledoc.NumeroPiece)+ ' AND '+
                           'GP_INDICEG='+InttOStr(Cledoc.Indice)+' AND AFF_ETATAFFAIRE="ACP"',true,-1,'',true);
            if not QQ.eof then
            begin
              TOBDevis := TOB.Create ('PIECE',nil,-1);
              TOBDevis.selectDb('',QQ);
              TOBDevis.changeparent(TOBFacturable,-1);
              TOBdevis.AddChampSupValeur ('SELECTED','X');
              if first then
              begin
                TOBReference := TOBdevis;
                first := false;
              end;
            end;
          end;
          ferme(QQ);
        end;
      end;
    end;
  FINALLY
    TOBfacture.free;
  END;
end;

function TOF_BTSELFAC_MUL.ExistDevis(TOBL: TOB): boolean;
var cledoc: r_cledoc;
    TheRef : string;
begin
  TheRef := EncodeRefPiece (TOBL);
  DecodeRefPiece (TheRef,cledoc);
  result := existDevis (cledoc);
end;


procedure TOF_BTSELFAC_MUL.VoirPiece(Sender: TObject);
var cledoc : r_cledoc;
		Laction : TactionFiche;
    QQ : TQuery;
begin
  if GS.visible then
  begin
    cledoc.NaturePiece  := TOBFacturable.detail[GS.row-1].getValue('GP_NATUREPIECEG');
    cledoc.Souche  := TOBFacturable.detail[GS.row-1].getValue('GP_SOUCHE');
    cledoc.NumeroPiece  := TOBFacturable.detail[GS.row-1].getValue('GP_NUMERO');
    cledoc.Indice  := TOBFacturable.detail[GS.row-1].getValue('GP_INDICEG');
  end else
  begin
    With TFMul(Ecran) do
    begin
      {$IFDEF EAGLCLIENT}
      Q.TQ.Seek(FListe.Row-1) ;
      {$ENDIF}
      cledoc.NaturePiece := Q.FindField('GP_NATUREPIECEG').asstring ;
      cledoc.Souche := Q.FindField('GP_SOUCHE').asstring ;
      cledoc.NumeroPiece := Q.FindField('GP_NUMERO').asInteger ;
      cledoc.Indice := Q.FindField('GP_INDICEG').asInteger ;
    end;
  end;
  //
  if JaiLeDroitNatureGCModif(CleDoc.NaturePiece) then LAction := taModif else LAction := taConsult;
  //
  SaisiePiece(CleDoc, LAction,'','','',false,false,false,true);
  if GS.visible then
  begin
  	if LAction = taModif then
    begin
      QQ := OpenSql ('SELECT * FROM PIECE WHERE '+WherePiece(Cledoc,ttdpiece,true),true,-1,'',true);
      if not QQ.eof then TOBFacturable.detail[GS.row-1].SelectDB('',QQ);
      ferme (QQ);
      TOBFacturable.detail[GS.row-1].PutLigneGrid (GS,Gs.row,false,false,ColName);
    end;
  end else
  begin
    BchercheClick;
  end;
end;

function TOF_BTSELFAC_MUL.MontantDevZero: boolean;
var Arow : integer;
		TOBP : TOB;
begin
	result := false;
  for Arow := 1 to GS.rowCount do
  begin
    if GS.IsSelected (Arow) then
    begin
      TOBP := TOB(GS.objects[0,Arow]);
      if TOBP.GetValue('GP_TOTALHT')=0 then
      begin
      	result := true;
        break;
      end;
    end;
  end;
end;

procedure TOF_BTSELFAC_MUL.GSPostDrawCell(ACol, ARow: Integer;Canvas: TCanvas; AState: TGridDrawState);
var ARect: TRect;
		Triangle: array[0..2] of TPoint;
begin
  if (gdFixed in AState) and (ACol = 0) then
  begin
    Arect := GS.CellRect(Acol, Arow);
    Canvas.Brush.Color := GS.FixedColor;
    Canvas.FillRect(ARect);
    if (ARow = GS.row) then
    begin
      Canvas.Brush.Color := clBlack;
      Canvas.Pen.Color := clBlack;
      Triangle[1].X := ARect.Right - 2;
      Triangle[1].Y := ((ARect.Top + ARect.Bottom) div 2);
      Triangle[0].X := Triangle[1].X - 5;
      Triangle[0].Y := Triangle[1].Y - 5;
      Triangle[2].X := Triangle[1].X - 5;
      Triangle[2].Y := Triangle[1].Y + 5;
      if false then Canvas.PolyLine(Triangle) else Canvas.Polygon(Triangle);
    end;
  end;
end;

procedure TOF_BTSELFAC_MUL.GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
	GS.InvalidateRow(Ou);
end;

procedure TOF_BTSELFAC_MUL.GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
	GS.InvalidateRow(Ou);
end;

procedure TOF_BTSELFAC_MUL.VerifDevisFromFacturation(TOBTMP: TOB);
var Indice : integer;
		TOBLS : TOB;
    Nature,Souche,noDevis : string;
    QQ : Tquery;
begin
	if TOBTmp.detail.count = 0 then exit;
	Indice := 0;
	repeat
    TOBLS := TOBTMP.detail[Indice];
    Nature := Copy(TOBLS.getValue('BST_SSAFFAIRE'),2,3);
    Souche := Copy(TOBLS.getValue('BST_SSAFFAIRE'),5,3);
    NoDevis := Copy(TOBLS.getValue('BST_SSAFFAIRE'),8,8);
    QQ := OpenSql ('SELECT AFF_ETATAFFAIRE,GP_REFINTERNE FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS '+
   								 'WHERE GP_NATUREPIECEG="'+Nature+'" AND GP_SOUCHE="'+Souche+'" AND '+
	                 'GP_NUMERO='+NoDevis+' AND GP_INDICEG=0',true,-1,'',true);
    if Not QQ.eof then
    begin
    	if QQ.findfield('AFF_ETATAFFAIRE').asString='TER' then TOBLS.free else Inc(Indice);
    end else
    begin
    	Inc(Indice);
    end;
    ferme (QQ);
  until Indice >= TOBTmp.detail.count;
end;

function TOF_BTSELFAC_MUL.ControleEtatDevisPrinc (NaturepieceG,Souche : string; Numero,IndiceG : integer) : boolean;
var QQ : Tquery;
		Sql : string;
begin
  result := true;
  Sql := 'SELECT AFF_ETATAFFAIRE FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS WHERE '+
         'GP_NATUREPIECEG="'+NaturepieceG+'" AND GP_SOUCHE="'+Souche+'" AND GP_NUMERO='+InttoStr(Numero)+
         ' AND GP_INDICEG='+InttoStr(IndiceG);
  QQ := OPenSql (Sql,True);
  if not QQ.eof then
  begin
    if QQ.FindField('AFF_ETATAFFAIRE').asString = 'TER' then
    begin
    	PgiInfo ('Facturation impossible. La facturation � �t� clotur�',ecran.Caption);
      result := false;
    end;
  end;
  ferme (QQ);
end;

function TOF_BTSELFAC_MUL.ConfirmationCloture: boolean;
var UneTOB : TOB;
		Modefacturation : string;
begin
  if fTypeFacturation  ='AVA' then
  begin
  	ModeFacturation := 'AVANCEMENT';
  end else if fTypeFacturation ='DAC' then
  begin
  	ModeFacturation := 'MEMOIREFINAL';
  end else
  begin
  	ModeFacturation := 'DIRECTE';
  end;
  UneTOB := TOB.create ('UNE DEMANDE',nil,-1);
  UneTOB.AddChampSupValeur('CONFIRMATION','-');
  UneTOB.AddChampSupValeur('MODECLOTURE',ModeFacturation);
  TheTOB := UneTOB;
  AGLLanceFiche('BTP','BTCONFIRMECLOTURE','','','');
  result := (UneTOB.GetValue('CONFIRMATION')='X');
  TheTOB := nil;
  UneTOB.free;
end;


function TOF_BTSELFAC_MUL.ControleArticleEcartFact: boolean;
var ARtEcart : string;
		QArt : TQuery;
begin
	result := true;
  ArtEcart := GetParamsoc('SO_ECARTFACTURATION');
  if ArtEcart = '' then
  begin
    PgiError (Traduirememoire('Impossible : l''article d''�cart n''a pas �t� param�tr�'));
    result := false;
  end;
  Qart := opensql('Select GA_ARTICLE from ARTICLE Where GA_CODEARTICLE="' + ArtEcart + '"', true,-1, '', True);
  if Qart.eof then
  begin
    PgiError (Traduirememoire('Impossible : l''article d''�cart est invalide'));
    result := false;
  end;
  ferme (Qart);
end;

Initialization
  registerclasses ( [ TOF_BTSELFAC_MUL ] ) ;
end.
