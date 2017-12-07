unit UCotraitance;

interface
Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     fe_main,
{$else}
     eMul,
     MaineAGL,
{$ENDIF}
     Hent1,
		 Menus,
		 HCtrls,
     HMsgBox,
     SysUtils,
     AglInit,
     forms,
     UentCommun,
     SaisUtil,
     CopierCollerUtil,
     uTob;
type

	TPieceCotrait = class (Tobject)
  	private
    	fusable : boolean;
      fCreatedPop : boolean;
      fmaxItems : integer;
      fMaxpopyItems : integer;
      fcopiercoller : TCopieColleDoc;
    	FF : TForm;
      fTOBpiece : TOB;
      fTOBaffaire : TOB;
      fTOBOuvrage : TOB;
      fTOBligneArecalc : TOB;
      GS : THGrid;
      fPOPY : TPopupMenu;
      fPOPGS : TPopupMenu;
      fMenuItem: array[0..2] of TMenuItem;
      fPOPYItem : array[0..1] of TmenuItem;
    	procedure DefiniMenuPop(Parent: Tform);
      procedure GSAffectCotrait (Sender : tobject);
      procedure GSAffectInterne (Sender : tobject);
    	procedure Setaffaire(const Value: TOB);
    	procedure MenuEnabled(State: boolean);
    	procedure AffecteInterne(var Indice: integer);
    	procedure AffecteCoTraitanceLigSDetail(TOBL : TOB; Fournisseur, LibelleFou,NatureTravail: string);
    	procedure AffecteInterneSDetail (TOBL : TOB);
    	procedure AffecteCoTraitanceOuvrage(Fournisseur, LibelleFou,NatureTravail: string;TOBL: TOB; Var NextLig : integer; OkInc : boolean);
      procedure AffecteInterneOuvrage(TOBL: TOB; var indice : integer);
    	procedure AffecteCoTraitanceSousDetail(TOBPere,TOBOUV: TOB; IndiceNomen : Integer;Fournisseur,LibelleFou,NatureTravail: string;Var NextLig : integer; OkINc : boolean);
    	procedure AffecteCoTraitanceSousDetail1(TOBOUV: TOB;indiceNomen: integer; Fournisseur, LibelleFou,NatureTravail: string);
    	procedure AffecteInterneSousDetail(IndiceNomen : integer; TOBOUV: TOB; var indice : integer);
      procedure GSCotraittableau (sender : TObject);
    	procedure NettoiePieceTrait (TOBpieceTrait : TOB);
    	function  FindLignePere(TOBL: TOB): TOB;
    	procedure InitLigneInterne(TOBL: TOB; var indice : integer);
    	procedure SetInfoCotraitancelig(TOBL: TOB; Fournisseur,LibelleFou: string; var Indice : integer);
    	procedure AffecteCoTraitanceLigne(Fournisseur: string; var Indice: integer);
    	procedure InitLigneInterne1(TOBL: TOB);
      procedure ReinitDetailOuvrage(TOBO: TOB);
      procedure ReinitOuvrage(TOBL: TOB);
    	function AddLigneCalcul(TOBLP: TOB): Boolean;
    public
    	constructor create (laForm : Tform);
      destructor destroy; override;
      property Affaire : TOB read fTOBAffaire write Setaffaire;
      property TOBpiece : TOB read fTOBpiece write fTOBpiece;
      property TOBOuvrage:TOB read fTOBouvrage write fTOBouvrage;
      property InUse : boolean read fusable;
    	procedure SetGrilleSaisie(State: boolean);
    	procedure SetSaisie;
    	procedure ReinitSaisie;
  end;

var PieceTraitUsable : boolean;

function CotraitanceAffectationOk (CodeAffaire : string) : boolean;
procedure DecodeCleDoc (laChaine : string; var Cledoc : R_cledoc);
function EncodeCleDoc (Cledoc : R_cledoc) : string; overload;
function EncodeCleDoc (TOBL : TOB) : string; overload;
function GestionMenuCotraitance (Numtag : integer) : integer;
function GetLibCoTraitant (TOBpiece : TOB; Arow : integer) : string; overload;
function GetLibCoTraitant (Fournisseur : string) : string; overload;
function IsIntervenant (CodeAffaire,intervenant : string) : boolean;
function IsLigneCotraite (TOBL : TOB) : boolean;
function IsPieceGerableCoTraitance (TOBpiece,TOBaffaire : TOB) : boolean;
procedure LoadLaTOBPieceAffaireTrait (TOBpieceTrait: TOB;Faffaire : string);
procedure LoadLaTOBPieceTrait(TOBpieceTrait : TOB; cledoc : r_Cledoc);
procedure LoadLaTOBAffaireInterv(TOBAffaireInterv : TOB; Affaire : string);
procedure ReinitMontantPieceTrait(TOBpieceTrait : TOB);
procedure SetTOBpieceTrait(TOBpiece,TOBpieceTrait: TOB);
procedure SommePieceTrait (TOBpieceTrait,TOBL : TOB;Sens:string='+');
procedure ValideLesPieceTrait(TOBPiece, TOBPieceTrait : TOB; DEV : Rdevise);

implementation

uses facture,
     Entgc,
     AffaireUtil,
     FactTOB,
     FACTUREBTP,
     factUtil,
     factComm,
     FactCalc,
     UtilTOBpiece,
     LigNomen,
		 factVariante,
     Paramsoc,
     UTOF_VideInside;

procedure LoadLaTOBAffaireInterv(TOBAffaireInterv : TOB; Affaire : string);
var Q : Tquery;
		req : string;
begin
	TOBAffaireInterv.clearDetail;
  if Affaire = '' then exit;
  Req := 'SELECT * FROM AFFAIREINTERV '+
         'WHERE BAI_AFFAIRE="'+Affaire+'"';
  Q := OpenSql (Req, True,-1, '', True);
  if not Q.eof then TOBAffaireInterv.LoadDetailDB('AFFAIREINTERV', '', '', Q, False);
  Ferme(Q);
end;

procedure LoadLaTOBPieceAffaireTrait (TOBpieceTrait: TOB;Faffaire : string);
var Q : Tquery;
		req : string;
		Indice : integer;
begin
	TOBPieceTrait.clearDetail;
(*
	Req := 'SELECT BPE_FOURNISSEUR,SUM(BPE_TOTALHTDEV) AS BPE_TOTALHTDEV ,'+
  			 'SUM(BPE_TOTALTTCDEV) AS BPE_TOTALTTCDEV,SUM(BPE_MONTANTPR) AS BPE_MONTANTPR,'+
  			 'SUM(BPE_MONTANTFAC) AS BPE_MONTANTFAC,SUM(BPE_MONTANTREGL) AS BPE_MONTANTREGL,'+
         '(SELECT T_LIBELLE FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS=BPE_FOURNISSEUR) AS LIBELLE '+
  			 'FROM PIECETRAIT '+
         'WHERE BPE_AFFAIRE="'+Faffaire+'" AND BPE_NATUREPIECEG="DBT" GROUP BY BPE_FOURNISSEUR';
*)
  Req := 'SELECT BPE_FOURNISSEUR,SUM(BPE_TOTALHTDEV) AS BPE_TOTALHTDEV ,'+
  			 'SUM(BPE_TOTALTTCDEV) AS BPE_TOTALTTCDEV,SUM(BPE_MONTANTPR) AS BPE_MONTANTPR,'+
  			 'SUM(BPE_MONTANTFAC) AS BPE_MONTANTFAC,'+
         '(SELECT T_LIBELLE FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS=BPE_FOURNISSEUR) AS LIBELLE '+
  			 'FROM PIECETRAIT '+
         'WHERE BPE_AFFAIRE="'+Faffaire+'" AND BPE_NATUREPIECEG="DBT" GROUP BY BPE_FOURNISSEUR';
  Q := OpenSql (Req, True,-1, '', True);
  if not Q.eof then TOBPieceTrait.LoadDetailDB('AFFAIRE AFFECT', '', '', Q, False);
  for Indice := 0 to TOBpieceTrait.detail.count -1 do
  begin
  	if TOBpieceTrait.detail[Indice].getValue('BPE_FOURNISSEUR')='' then
    begin
      TOBpieceTrait.detail[Indice].puTvalue('LIBELLE', GetParamSocSecur('SO_LIBELLE','Notre Société'));
      break;
    end;
  end;
  Ferme(Q);
end;

procedure LoadLaTOBPieceTrait(TOBpieceTrait : TOB; cledoc : r_Cledoc);
var Q : Tquery;
		Indice : integer;
    Sql : string;
begin
  Sql := 'SELECT *,T_LIBELLE AS LIBELLE FROM PIECETRAIT '+
               'LEFT JOIN TIERS ON T_NATUREAUXI="FOU" AND T_TIERS=BPE_FOURNISSEUR '+
               'WHERE ' + WherePiece(CleDoc, ttdpieceTrait, False);
  Q := OpenSQL(Sql, True,-1, '', True);
  TOBPieceTrait.LoadDetailDB('PIECETRAIT', '', '', Q, False);
  for Indice := 0 to TOBpieceTrait.detail.count -1 do
  begin
  	if TOBpieceTrait.detail[Indice].getValue('BPE_FOURNISSEUR')='' then
    begin
//      TOBpieceTrait.detail[Indice].puTvalue('LIBELLE','Notre Société');
      TOBpieceTrait.detail[Indice].puTvalue('LIBELLE',GetParamSocSecur('SO_LIBELLE','Notre Société'));
      break;
    end;
  end;
  Ferme(Q);
end;

procedure DecodeCleDoc (laChaine : string; var Cledoc : R_cledoc);
var TheChaine : string;
begin
	TheChaine := laChaine;
  if TheChaine ='' then exit;
  FillChar (Cledoc,Sizeof(Cledoc),0);
  Cledoc.NaturePiece := READTOKENPipe(TheChaine,':');
  if TheChaine = '' then exit;
  Cledoc.Souche := READTOKENPipe(TheChaine,':');
  if TheChaine = '' then exit;
  Cledoc.NumeroPiece  := StrToInt(READTOKENPipe(TheChaine,':'));
  if TheChaine = '' then exit;
  Cledoc.Indice   := StrToInt(READTOKENPipe(TheChaine,':'));
end;

function EncodeCleDoc (Cledoc : R_cledoc) : string;
begin
	result := Cledoc.NaturePiece+':'+Cledoc.Souche+':'+inttoStr(Cledoc.NumeroPiece)+':'+IntTostr(Cledoc.Indice);
end;

function EncodeCleDoc (TOBL : TOB) : string;
var prefixe : string;
begin
	if Pos(TOBL.NomTable,'LIGNE;LIGNEOUV;PIECE;LIGNEOUVPLAT') = 0 then exit;
  prefixe := GetPrefixeTable (TOBL);
  result := TOBL.getValue(prefixe+'_NATUREPIECEG')+':'+
  					TOBL.getValue(prefixe+'_SOUCHE')+':'+
  					IntToStr(TOBL.getValue(prefixe+'_NUMERO'))+':'+
  					IntToStr(TOBL.getValue(prefixe+'_INDICEG'));
end;

function IsPieceGerableCoTraitance (TOBpiece,TOBaffaire : TOB) : boolean;
begin
	result := false;
  if (VH_GC.SeriaCoTraitance) and
  	 (TOBaffaire.getValue ('AFF_MANDATAIRE') = 'X') and
     (TOBpiece.getValue('GP_VENTEACHAT')='VEN') then result := true;
  PieceTraitUsable := result;
end;

procedure SetTOBpieceTrait(TOBpiece,TOBpieceTrait: TOB);
begin
	if not PieceTraitUsable then exit;
	SommePieceTrait (TOBpieceTrait,TOBpiece);
end;

procedure ReinitMontantPieceTrait(TOBpieceTrait : TOB);
var TOBP : TOB;
	Indice : integer;
begin
	if not PieceTraitUsable then exit;
	For Indice := 0 to TOBpieceTrait.detail.count -1 do
  begin
  	TOBP := TOBpieceTrait.detail[Indice];
    TOBP.PutValue('BPE_TOTALHTDEV',0) ;
    TOBP.PutValue('BPE_TOTALTTCDEV',0) ;
    TOBP.PutValue('BPE_MONTANTPA',0) ;
    TOBP.PutValue('BPE_MONTANTPR',0) ;
  end;
end;

procedure SommePieceTrait (TOBpieceTrait,TOBL : TOB;Sens:string='+');

	function getLibelleFou( Code : string) : string;
  var Sql : string;
  		Q : TQuery;
  begin
    Sql := 'SELECT T_LIBELLE FROM TIERS WHERE '+
			     'T_NATUREAUXI="FOU" AND T_TIERS="'+Code+'"';
    Q := OpenSQL(Sql, True,-1, '', True);
    if not Q.eof then
    begin
    	Result := Q.findField('T_LIBELLE').AsString;
    end;
    ferme (Q);
  end;

var Fournisseur : string;
		TOBPT : TOB;
    prefixe : string;
    X : double;
begin
	if not PieceTraitUsable then exit;
  prefixe := GetPrefixeTable(TOBL);
	Fournisseur := '';
  if TOBL.NomTable = 'LIGNE' then
  begin
  	if TOBL.getvalue('GLC_NATURETRAVAIL')<>'' then Fournisseur := TOBL.getvalue('GL_FOURNISSEUR');
  end else if TOBL.Nomtable = 'LIGNEOUV' then
  begin
  	if TOBL.getvalue('BLO_NATURETRAVAIL')<>'' then Fournisseur := TOBL.getvalue('BLO_FOURNISSEUR');
  end else if TOBL.Nomtable = 'LIGNEOUVPLAT' then
  begin
  	if TOBL.getvalue('BOP_NATURETRAVAIL')<>'' then Fournisseur := TOBL.getvalue('BOP_FOURNISSEUR');
  end;
  TOBPT := TOBpieceTrait.findFirst(['BPE_FOURNISSEUR'],[Fournisseur],true);
  if TOBPT = nil then
  begin
  	TOBPT := TOB.Create ('PIECETRAIT',TOBpieceTrait,-1);
    TOBPT.putvalue('BPE_FOURNISSEUR',Fournisseur);
  	if Fournisseur='' then
    begin
      TOBPT.AddChampSupValeur ('LIBELLE','Notre Société');
    end else
    begin
      TOBPT.AddChampSupValeur ('LIBELLE',GetLibelleFou(Fournisseur));
    end;
  end;
  if Sens = '+' then X:=arrondi(TOBPT.GetValue('BPE_TOTALHTDEV')+TOBL.GetValue(prefixe+'_TOTALHTDEV'),V_PGI.okdecV)
                else X:=arrondi(TOBPT.GetValue('BPE_TOTALHTDEV')-TOBL.GetValue(prefixe+'_TOTALHTDEV'),V_PGI.okdecV);
  TOBPT.PutValue('BPE_TOTALHTDEV',X) ;
  if Sens = '+' then X:=arrondi(TOBPT.GetValue('BPE_TOTALTTCDEV')+TOBL.GetValue(prefixe+'_TOTALTTCDEV'),V_PGI.okdecV)
                else X:=arrondi(TOBPT.GetValue('BPE_TOTALTTCDEV')-TOBL.GetValue(prefixe+'_TOTALTTCDEV'),V_PGI.okdecV);
  TOBPT.PutValue('BPE_TOTALTTCDEV',X) ;
  if Sens = '+' then X:=arrondi(TOBPT.GetValue('BPE_MONTANTPA')+TOBL.GetValue(prefixe+'_MONTANTPA'),V_PGI.okdecV)
                else X:=arrondi(TOBPT.GetValue('BPE_MONTANTPA')-TOBL.GetValue(prefixe+'_MONTANTPA'),V_PGI.okdecV);
  TOBPT.PutValue('BPE_MONTANTPA',X) ;
  if Sens = '+' then X:=arrondi(TOBPT.GetValue('BPE_MONTANTPR')+TOBL.GetValue(prefixe+'_MONTANTPR'),V_PGI.okdecV)
                else X:=arrondi(TOBPT.GetValue('BPE_MONTANTPR')-TOBL.GetValue(prefixe+'_MONTANTPR'),V_PGI.okdecV);
  TOBPT.PutValue('BPE_MONTANTPR',X) ;
end;

function GetLibCoTraitant (TOBpiece : TOB; Arow : integer) : string;
var TOBL : TOB;
		QQ : TQuery;
begin
	TOBL := TOBPiece.detail[Arow-1];
  if TOBL.GetValue('GL_FOURNISSEUR')<> '' then
  begin
    QQ := OpenSql('SELECT T_LIBELLE FROM TIERS WHERE T_TIERS="'+TOBL.getvalue('GL_FOURNISSEUR')+'" AND T_NATUREAUXI="FOU"',
    							true,1,'',true);
    if not QQ.eof then
    begin
      result := QQ.findField('T_LIBELLE').AsString;
    end;
    ferme (QQ);
  end;
end;

function GetLibCoTraitant (Fournisseur : string) : string;
var QQ : TQuery;
begin
	result := '';
	if Fournisseur <> '' then
  begin
    QQ := OpenSql('SELECT T_LIBELLE FROM TIERS WHERE T_TIERS="'+Fournisseur+'" AND T_NATUREAUXI="FOU"',
    							true,1,'',true);
    if not QQ.eof then
    begin
      result := QQ.findField('T_LIBELLE').AsString;
    end;
    ferme (QQ);
  end;
end;

function IsLigneCotraite (TOBL : TOB) : boolean;
begin
	result := false;
  if TOBL.NomTable = 'LIGNE' then
  begin
		if Pos(TOBL.getValue('GLC_NATURETRAVAIL'),'001;011')> 0 then result := true;
  end else if TOBL.NomTable = 'LIGNEOUV' then
  begin
		if Pos(TOBL.getValue('BLO_NATURETRAVAIL'),'001;011')> 0 then result := true;
  end else if TOBL.NomTable = 'LIGNEOUVPLAT' then
  begin
		if Pos(TOBL.getValue('BOP_NATURETRAVAIL'),'001;011')> 0 then result := true;
  end;
end;

function CotraitanceAffectationOk (CodeAffaire : string) : boolean;
var QQ : TQuery;
begin
	QQ := OpenSql ('SELECT BAI_TYPEINTERV FROM AFFAIREINTERV WHERE BAI_AFFAIRE="'+CodeAffaire+'"',true,
  							 -1,'',true);
	result := not QQ.eof;
  ferme (QQ);
end;

function GestionMenuCotraitance (Numtag : integer) : integer;
begin
	if not VH_GC.SeriaCoTraitance then
  begin
  	PgiBox('Ce module n''est pas sérialisé. Il ne peut être utilisé.','CoTraitance');
    result := -1;
    exit;
  end;
  result := 0;
  case Numtag of
    325110 : AGLLanceFiche('BTP','BTAFFAIRE_MUL','AFF_AFFAIRE=P','','MANDATAIRE=X; ETAT=ENC; STATUT=PRO');  //Selection Appel d'offre
    325120 : AGLLanceFiche('BTP','BTAFFAIRE_MUL','AFF_AFFAIRE=A','','MANDATAIRE=X; ETAT=ENC; STATUT=AFF');  //Selection affaire
    325130 : AGLLanceFiche('BTP','BTINTEGREDOC','','','');                                                  //intégration document XLS cotraitant
    325140 : AGLLanceFiche('BTP','BTDEVIS_MUL', 'GP_NATUREPIECEG=DBT;GP_VENTEACHAT=VEN','','MODIFICATION');
    //
    325210 : AGLLanceFiche('BTP','BTEDTBONPAIEMENT','GP_NATUREPIECEG=FBT;GP_VENTEACHAT=VEN','','MODIFICATION;STATUT=INT');  //Edition lettre d'éclatement et bon de paiement
    325310 : BEGIN
    					AGLLanceFiche('GC','GCPORT_MUL','','','COTRAITANCE') ;
    			   END;
    325320 : AGLLanceFiche('BTP', 'BTPARAMMAIL', '', '','TYPEMAIL=S');//BEGIN SaisirHorsInside('BTPARAMMAIL', 'TYPEMAIL=S'); Result := -1 ; end;
    325330 : AGLLanceFiche('BTP', 'BTPARAMMAIL', '', '','TYPEMAIL=T');//BEGIN SaisirHorsInside('BTPARAMMAIL','TYPEMAIL=T'); Result := -1 ; end;
    else HShowMessage('2;?caption?;'+'Fonction non disponible : '+';W;O;O;O;','CoTraitance',IntToStr(Numtag)) ;
  end;
end;

function IsIntervenant (CodeAffaire,Intervenant : string) : boolean;
var QQ : TQuery;
begin
	QQ := OpenSql ('SELECT BAI_TYPEINTERV FROM AFFAIREINTERV WHERE BAI_AFFAIRE="'+CodeAffaire+'" AND BAI_TIERSFOU="'+Intervenant+'"',true,
  							 -1,'',true);
	result := not QQ.eof;
  ferme (QQ);
end;

procedure ValideLesPieceTrait(TOBPiece, TOBPieceTrait : TOB; DEV : Rdevise);
var i, Numero, Indice: integer;
  Nature, Souche: string;
  TOBP: TOB;
  TOTHt,TOTTTC,MaxHt,Diff : double;
  TmaxHt : TOB;
begin
	if not PieceTraitUsable then exit;
  if TOBPieceTrait = nil then Exit;
  if TOBPieceTrait.Detail.Count = 0 then Exit;
  //
  i:=0;
  repeat
    TOBP := TOBPieceTrait.Detail[i];
    if (TOBP.getvalue('BPE_TOTALHTDEV')=0) and (TOBP.getvalue('BPE_DEJAFACT')=0) and (TOBP.getvalue('BPE_MONTANTREGL')=0) then
    begin
    	TOBP.free;
    end else inc(I);
  until i >= TOBPieceTrait.Detail.Count;
  //
  Nature := TOBPiece.GetValue('GP_NATUREPIECEG');
  Souche := TOBPiece.GetValue('GP_SOUCHE');
  Numero := TOBPiece.GetValue('GP_NUMERO');
  Indice := TOBPiece.GetValue('GP_INDICEG');
  TmaxHt := nil;
  TOTHT := 0; TOTTTC := 0;
  MaxHt := 0;
  for i := 0 to TOBPieceTrait.Detail.Count - 1 do
  begin
    TOBP := TOBPieceTrait.Detail[i];
    TOBP.PutValue('BPE_NATUREPIECEG', Nature);
    TOBP.PutValue('BPE_SOUCHE', Souche);
    TOBP.PutValue('BPE_NUMERO', Numero);
    TOBP.PutValue('BPE_INDICEG', Indice);
    TOBP.PutValue('BPE_AFFAIRE', TOBpiece.getValue('GP_AFFAIRE'));
    TOTHT := TOTHT + TOBP.getvalue('BPE_TOTALHTDEV');
    TOTTTC := TOTTTC + TOBP.getvalue('BPE_TOTALTTCDEV');
    if TOBP.getvalue('BPE_TOTALHTDEV') > maxHt then TmaxHt := TOBP;
  end;
  Diff := Arrondi(TOTHT - TOBpiece.getValue('GP_TOTALHTDEV'),Dev.Decimale);
  if diff <> 0 then
  begin
  	TMaxHT.Putvalue('BPE_TOTALHTDEV',TMaxHT.getvalue('BPE_TOTALHTDEV')+Diff);
  end;
  Diff := Arrondi(TOTTTC - TOBpiece.getValue('GP_TOTALTTCDEV'),Dev.Decimale);
  if diff <> 0 then
  begin
  	TMaxHT.Putvalue('BPE_TOTALTTCDEV',TMaxHT.getvalue('BPE_TOTALTTCDEV')+Diff);
  end;
  if not TOBPieceTrait.InsertDB(nil) then
  begin
    MessageValid := 'Erreur mise à jour des PIECETRAIT';
    V_PGI.IoError := oeUnknown;
  end;
end;


{ TPieceCotrait }

constructor TPieceCotrait.create ( LaForm : Tform);
var ThePop : Tcomponent;
begin
	fusable := true; // par défaut
  fTOBligneArecalc := TOB.Create ('LES LIGNES A RECALC',nil,-1);
	if not VH_GC.SeriaCoTraitance then fusable := false; // meme pas la peine de continuer
  FF := laForm;
	if (FF is TFLigNomen) then
  begin
    fusable := false;
    GS := TFligNomen(FF).G_NLIG;
  end else if (FF is TFFacture) then
  begin
    GS := TFfacture(FF).GS;
		fcopiercoller := TFFacture(FF).CopierColleObj;
  end else fusable := false;
  //
  if FF is TFfacture then
  begin
    ThePop := FF.Findcomponent  ('POPBTP');
    if ThePop = nil then
    BEGIN
      // pas de menu BTP trouve ..on le cree
      fPOPGS := TPopupMenu.Create(FF);
      fPOPGS.Name := 'POPBTP';
      fCreatedPop := true;
    END else
    BEGIN
      fCreatedPop := false;
      fPOPGS := TPopupMenu(thePop);
    END;
    ThePop := FF.Findcomponent  ('POPY');
    if ThePop <> nil then
    begin
      fPOPY := TPopupMenu(thePop);
    end;
  end else
  begin
    ThePop := FF.Findcomponent  ('PopupG_NLIG');
    if ThePop <> nil then
    begin
      fCreatedPop := false;
      fPOPGS := TPopupMenu(thePop);
    end;
  end;
  DefiniMenuPop(FF);
  PieceTraitUsable := fusable;
end;

destructor TPieceCotrait.destroy;
var indice : integer;
begin
  fTOBligneArecalc.free;
  for Indice := 0 to fMaxItems -1 do
  begin
  	if fMenuItem[Indice]<> nil then fMenuItem[Indice].Free;
  end;
	if fcreatedPop then fPOPGS.free;
  PieceTraitUsable := false;
  inherited;
end;

procedure TPieceCotrait.DefiniMenuPop (Parent : Tform);
var Indice : integer;
		ThePop : TComponent;
begin
  fMaxItems := 0;
  if not fcreatedPop then
  begin
    fMenuItem[fMaxItems] := TmenuItem.Create (parent);
    with fMenuItem[fMaxItems] do
      begin
    	Name := 'BCOTRAITSEP';
      Caption := '-';
      Visible := false;
      end;
    inc (fMaxItems);
  end;
  // Affectation à un cotraitant
  fMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with fMenuItem[fMaxItems] do
    begin
    Name := 'BCOTRAITAFFECT';
    Caption := 'Affectation à un cotraitant';
    Visible := false;
    OnClick := GSAffectCotrait;
    end;
  inc (fMaxItems);
  // Récupération des travaux
  fMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with fMenuItem[fMaxItems] do
    begin
    Name := 'BCOINTERNE';
//    Caption := 'Travaux effectués par nous même';
    Caption := 'Affectation en interne';
    Visible := false;
    OnClick := GSAffectInterne;
    end;
  inc (fMaxItems);

  for Indice := 0 to fMaxItems -1 do
  begin
  	if fMenuItem [Indice] <> nil then fPOPGS.Items.Add (fMenuItem[Indice]);
  end;

  // definition sur POPY du facture.pas
  if FF is TFFacture then
  begin
    fMaxpopyItems := 0;
    if fPOPY <> nil then
    begin
      ThePOp := TFFacture(FF).FindComponent('BPOPYCOTRAITSEP');
      if ThePop <> nil then fPOPYItem[fMaxpopyItems]  := TmenuItem(ThePop);
      with fPOPYItem[fMaxpopyItems] do
      begin
        Visible := false;
      end;
      inc (fMaxpopyItems);
      ThePOp := TFFacture(FF).FindComponent('BCOTRAITTABLEAU');
      if ThePop <> nil then fPOPYItem[fMaxpopyItems]  := TmenuItem(ThePop);
      with fPOPYItem[fMaxpopyItems] do
      begin
        Visible := false;
        OnClick := GSCotraittableau;
      end;
      inc (fMaxpopyItems);
    end;
  end;
end;

function TPieceCotrait.FindLignePere (TOBL : TOB) : TOB;
var indice : integer;
		TOBI : TOB;
    IndiceNomen : integer;
begin
	IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
  //
	result := nil;
  for Indice := TOBL.GetIndex -1 downto 0 do
  begin
    TOBI := fTOBpiece.detail[Indice];
    if Isouvrage(TOBI) and (not IsSousDetail(TOBI)) and TOBI.GetValue('GL_INDICENOMEN')=IndiceNomen then
    begin
    	result := TOBI;
      break;
    end;
  end;
end;

function TPieceCotrait.AddLigneCalcul (TOBLP : TOB) : Boolean;
var TOBI : TOB;
begin
  TOBI := fTOBligneArecalc.FindFirst(['NUMORDRE'],[TOBLP.GetValue('GL_NUMORDRE')],true);
  result := (TOBI = nil);
  if result then
  begin
  	TOBI := TOB.Create ('UNE LIGNE',fTOBligneArecalc,-1);
    TOBI.AddChampSupValeur ('NUMORDRE',TOBLP.GetValue('GL_NUMORDRE'));
    TOBI.Data := TOBLP;
  end;
end;

procedure TPieceCotrait.AffecteCoTraitanceLigSDetail( TOBL : TOB; Fournisseur, LibelleFou, NatureTravail: string);
var TOBOUV,TOBOL,TOBLP : TOB;
		Indice : integer;
    indiceNomen,UniqueBlo : integer;
    found : boolean;
    Affect,WhoAffect : string;
    Multiple : boolean;
begin
	found := false;
  TOBLP := FindLignePere(TOBL);
  if TOBLP = nil then exit;
  if (not IsVariante(TOBLP)) and (TOBLP.GetValue('GL_ARTICLE') <> '') then
  begin
    if AddLigneCalcul (TOBLP) then TFfacture(FF).deduitLaLigne (TOBLP);
  end;
  IndiceNomen := TOBL.getValue('GL_INDICENOMEN');
  UniqueBlo := TOBL.getValue('UNIQUEBLO');
	if IndiceNomen = 0 then exit;
	TOBOUV := TOBOuvrage.detail[IndiceNomen-1];
	for Indice := 0 to TOBOUV.detail.count -1 do
  begin
		TOBOL := TOBOUV.detail[Indice];
    if UniqueBlo <> TOBOL.getValue('BLO_UNIQUEBLO') then continue;
    TOBOL.putValue('BLO_FOURNISSEUR',Fournisseur);
    TOBOL.putValue('GA_FOURNPRINC',Fournisseur);
    TOBOL.putValue('LIBELLEFOU',LibelleFou);
    TOBOL.putValue('BLO_NATURETRAVAIL',NatureTravail);
    TOBOL.putValue('BLO_DPA',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_DPR',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_COEFFR',0);
    TOBOL.putValue('BLO_COEFFG',0);
    TOBOL.putValue('BLO_COEFFC',0);
    TOBOL.putValue('BLO_COEFMARG',1);
    TOBOL.putValue('BLO_NONAPPLICFRAIS','X');
    TOBOL.putValue('BLO_NONAPPLICFC','X');
    TOBOL.putValue('BLO_NONAPPLICFG','X');
    if TOBOL.detail.count > 0 then
    begin
    	AffecteCoTraitanceSousDetail1 (TOBOL,indiceNomen,Fournisseur,LibelleFou,NatureTravail);
    end;
    found := true;
    break;
  end;
  if found then
  begin
    TOBL.putvalue('GLC_NATURETRAVAIL',NatureTravail);
    TOBL.putvalue('GL_FOURNISSEUR',Fournisseur);
    TOBL.putvalue('LIBELLEFOU',LibelleFou);
    TFFActure(FF).AfficheLaLigne(TOBL.getIndex);
  	Multiple := false;
    for Indice := 0 to TOBOUV.detail.count -1 do
    begin
      TOBOL := TOBOUV.detail[Indice];
      if Indice = 0 then
      begin
      	Affect := TOBOL.getValue('BLO_NATURETRAVAIL');
      	WhoAffect := TOBOL.getValue('BLO_NATURETRAVAIL');
      end;
      if (TOBOL.getValue('BLO_NATURETRAVAIL')<>Affect) or (TOBOL.getValue('BLO_FOURNISSEUR')<>WhoAffect) then Multiple := true;
    end;
    //
    if (Multiple) then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL','010');
      TOBLP.putvalue('GL_FOURNISSEUR','');
      TOBLP.putvalue('LIBELLEFOU','');
    end else if (not Multiple) and (Affect='') then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL','');
      TOBLP.putvalue('GL_FOURNISSEUR','');
      TOBLP.putvalue('LIBELLEFOU','');
    end else if (not Multiple) and (Affect<>'') then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL',TOBOUV.detail[0].getValue('BLO_NATURETRAVAIL'));
      TOBLP.putvalue('GL_FOURNISSEUR',TOBOUV.detail[0].getValue('BLO_FOURNISSEUR'));
      TOBLP.putvalue('LIBELLEFOU',TOBOUV.detail[0].getValue('LIBELLEFOU'));
    end;
    TFFActure(FF).AfficheLaLigne(TOBLP.getIndex);
    TOBLP.putvalue('GL_RECALCULER','X');
    fTOBPiece.putvalue('GP_RECALCULER','X');
  end;
  // deporte
  // if (not IsVariante(TOBLP)) and (TOBLP.GetValue('GL_ARTICLE') <> '')  then TFfacture(FF).AjouteLaLigneCotrait (TOBLP);
end;

procedure TPieceCotrait.AffecteInterneSDetail(TOBL: TOB);
var TOBOUV,TOBOL,TOBLP : TOB;
		Indice : integer;
    indiceNomen,UniqueBlo : integer;
    found : boolean;
    II : integer;
    Affect,WhoAffect : string;
    Multiple : boolean;
begin
	found := false;
  multiple := false;
  TOBLP := FindLignePere(TOBL);
  if TOBLP = nil then exit;
  if (not IsVariante(TOBLP)) and (TOBLP.GetValue('GL_ARTICLE') <> '') then
  begin
  	if AddLigneCalcul (TOBLP) then TFfacture(FF).deduitLaLigne (TOBLP);
  end;
  IndiceNomen := TOBL.getValue('GL_INDICENOMEN');
  UniqueBlo := TOBL.getValue('UNIQUEBLO');
	if IndiceNomen = 0 then exit;
	TOBOUV := TOBOuvrage.detail[IndiceNomen-1];
	for Indice := 0 to TOBOUV.detail.count -1 do
  begin
		TOBOL := TOBOUV.detail[Indice];
    if UniqueBlo <> TOBOL.getValue('BLO_UNIQUEBLO') then continue;
    TOBOL.putValue('BLO_FOURNISSEUR','');
    TOBOL.putValue('GA_FOURNPRINC','');
    TOBOL.putValue('LIBELLEFOU','');
    TOBOL.putValue('BLO_NATURETRAVAIL','');
    TOBOL.putValue('BLO_DPA',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_DPR',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_COEFFR',0);
    TOBOL.putValue('BLO_COEFFG',0);
    TOBOL.putValue('BLO_COEFFC',0);
    TOBOL.putValue('BLO_COEFMARG',1);
    TOBOL.putValue('BLO_NONAPPLICFRAIS','-');
    TOBOL.putValue('BLO_NONAPPLICFC','-');
    TOBOL.putValue('BLO_NONAPPLICFG','-');
    if TOBOL.detail.count > 0 then
    begin
    	AffecteInterneSousDetail (IndiceNomen,TOBOL,II);
    end;
    found := true;
    break;
  end;
  if found then
  begin
    TOBL.putvalue('GLC_NATURETRAVAIL','');
    TOBL.putvalue('GL_FOURNISSEUR','');
    TOBL.putvalue('LIBELLEFOU','');
    TFFActure(FF).AfficheLaLigne(TOBL.getIndex);
  //
  	Multiple := false;
    for Indice := 0 to TOBOUV.detail.count -1 do
    begin
      TOBOL := TOBOUV.detail[Indice];
      if Indice = 0 then
      begin
      	Affect := TOBOL.getValue('BLO_NATURETRAVAIL');
        WhoAffect := TOBOL.getValue('BLO_FOURNISSEUR');
      end;
      if (TOBOL.getValue('BLO_NATURETRAVAIL')<>Affect) or (TOBOL.getValue('BLO_FOURNISSEUR')<>WhoAffect) then Multiple := true;
    end;
    if (Multiple) then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL','010');
      TOBLP.putvalue('GL_FOURNISSEUR','');
      TOBLP.putvalue('LIBELLEFOU','');
    end else if (not Multiple) and (Affect='') then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL','');
      TOBLP.putvalue('GL_FOURNISSEUR','');
      TOBLP.putvalue('LIBELLEFOU','');
    end else if (not Multiple) and (Affect<>'') then
    begin
      TOBLP.putvalue('GLC_NATURETRAVAIL',TOBOUV.detail[0].getValue('BLO_NATURETRAVAIL'));
      TOBLP.putvalue('GL_FOURNISSEUR',TOBOUV.detail[0].getValue('BLO_FOURNISSEUR'));
      TOBLP.putvalue('LIBELLEFOU',TOBOUV.detail[0].getValue('LIBELLEFOU'));
    end;
    TFFActure(FF).AfficheLaLigne(TOBLP.getIndex);
    TOBLP.putvalue('GL_RECALCULER','X');
    fTOBPiece.putvalue('GP_RECALCULER','X');
  end;
  // if (not IsVariante(TOBLP)) and (TOBLP.GetValue('GL_ARTICLE') <> '')  then TFfacture(FF).AjouteLaLigneCotrait (TOBLP);
end;

procedure TPieceCotrait.AffecteCoTraitanceOuvrage (Fournisseur,LibelleFou,NatureTravail: string; TOBL : TOB; Var NextLig : integer; OkInc : boolean);
var TOBOUV : TOB;
		IndiceNomen : integer;
begin
	IndiceNomen := TOBL.getvalue('GL_INDICENOMEN');
	if IndiceNomen > 0 then
  begin
    TOBOUV := TOBOuvrage.detail[IndiceNomen-1];
    AffecteCoTraitanceSousDetail(TOBL,TOBOUV,IndiceNomen,Fournisseur,LibelleFou,NatureTravail,nextLig,OkInc);
  end;
end;

procedure  TPieceCotrait.AffecteCoTraitanceSousDetail1 (TOBOUV : TOB; indiceNomen : integer;Fournisseur,LibelleFou,NatureTravail: string);
var TOBOL : TOB;
		II : Integer;
begin
	for II := 0 to TOBOUV.detail.count -1 do
  begin
		TOBOL := TOBOUV.detail[II];
    TOBOL.putValue('BLO_FOURNISSEUR',Fournisseur);
    TOBOL.putValue('GA_FOURNPRINC',Fournisseur);
    TOBOL.putValue('LIBELLEFOU',LibelleFou);
    TOBOL.putValue('BLO_NATURETRAVAIL',NatureTravail);
    TOBOL.putValue('BLO_DPA',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_DPR',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_COEFFR',0);
    TOBOL.putValue('BLO_COEFFG',0);
    TOBOL.putValue('BLO_COEFFC',0);
    TOBOL.putValue('BLO_COEFMARG',1);
    TOBOL.putValue('BLO_NONAPPLICFRAIS','X');
    TOBOL.putValue('BLO_NONAPPLICFC','X');
    TOBOL.putValue('BLO_NONAPPLICFG','X');
    if TOBOL.detail.count > 0 then
    begin
    	AffecteCoTraitanceSousDetail1 (TOBOL,IndiceNomen,Fournisseur,LibelleFou,NatureTravail);
    end;
  end;
end;

procedure  TPieceCotrait.AffecteCoTraitanceSousDetail(TOBPere,TOBOUV: TOB;IndiceNomen : Integer;Fournisseur,LibelleFou,NatureTravail : string; Var NextLig : integer; OkINc : boolean);
var TOBOL,TOBL : TOB;
		II,NextII,SS,CurrII : integer;
begin
	CurrII := NextLig;
  NextII := NextLig +1;
	for II := 0 to TOBOUV.detail.count -1 do
  begin
		TOBOL := TOBOUV.detail[II];
    TOBOL.putValue('BLO_FOURNISSEUR',Fournisseur);
    TOBOL.putValue('GA_FOURNPRINC',Fournisseur);
    TOBOL.putValue('LIBELLEFOU',LibelleFou);
    TOBOL.putValue('BLO_NATURETRAVAIL',NatureTravail);
    TOBOL.putValue('BLO_DPA',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_DPR',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_COEFFR',0);
    TOBOL.putValue('BLO_COEFFG',0);
    TOBOL.putValue('BLO_COEFFC',0);
    TOBOL.putValue('BLO_COEFMARG',1);
    TOBOL.putValue('BLO_NONAPPLICFRAIS','X');
    TOBOL.putValue('BLO_NONAPPLICFC','X');
    TOBOL.putValue('BLO_NONAPPLICFG','X');
    if TOBPere.GetValue('GLC_VOIRDETAIL')='X' then
    begin
      SS := CurrII + II + 1;
      TOBL := TOBPiece.detail[SS-1];
      if  (IsSousDetail(TOBL)) and
          (TOBL.getValue('GL_INDICENOMEN')=IndiceNomen) and
          (TOBL.getValue('UNIQUEBLO')=TOBOL.GetValue('BLO_UNIQUEBLO')) then
      begin
        TOBL.putvalue('GL_FOURNISSEUR',Fournisseur);
        TOBL.putvalue('LIBELLEFOU',LibelleFou);
        TOBL.putvalue('GLC_NATURETRAVAIL','001');
        TOBL.putvalue('GL_DPA',TOBL.getValue('GL_PUHT'));
        TOBL.putvalue('GL_DPR',TOBL.getValue('GL_PUHT'));
//        TOBL.putvalue('GL_BLOQUETARIF','X');
        TOBL.putvalue('GLC_NONAPPLICFC','X');
        TOBL.putvalue('GLC_NONAPPLICFG','X');
        TOBL.putvalue('GLC_NONAPPLICFRAIS','X');
        TOBL.putvalue('GL_COEFFC',0.0);
        TOBL.putvalue('GL_COEFFR',0.0);
        TOBL.putvalue('GL_COEFFG',0.0);
        TOBL.putvalue('GL_COEFMARG',1.0);
        NextII := SS+1;
      end;
    end;
    if TOBOL.detail.count > 0 then
    begin
    	AffecteCoTraitanceSousDetail1 (TOBOL,IndiceNomen,Fournisseur,LibelleFou,NatureTravail);
    end;
  end;
  NextLig := NextII;
end;

procedure TPieceCotrait.SetInfoCotraitancelig (TOBL: TOB; Fournisseur,LibelleFou : string; var Indice : integer);
begin

  if (not IsVariante(TOBL)) and (TOBL.GetValue('GL_ARTICLE') <> '') then
  begin
  	if AddLigneCalcul (TOBL) then TFfacture(FF).deduitLaLigne (TOBL);
  end;
  TOBL.putvalue('GL_FOURNISSEUR',Fournisseur);
  TOBL.putvalue('LIBELLEFOU',LibelleFou);
  TOBL.putvalue('GLC_NATURETRAVAIL','001');
  if TOBL.getvalue('GL_TYPELIGNE')<> 'ART' then BEGIN inc(Indice); exit; END;
  TOBL.putvalue('GL_DPA',TOBL.getValue('GL_PUHT'));
  TOBL.putvalue('GL_DPR',TOBL.getValue('GL_PUHT'));
//  TOBL.putvalue('GL_BLOQUETARIF','X');
  TOBL.putvalue('GLC_NONAPPLICFC','X');
  TOBL.putvalue('GLC_NONAPPLICFG','X');
  TOBL.putvalue('GLC_NONAPPLICFRAIS','X');
  TOBL.putvalue('GL_COEFFC',0.0);
  TOBL.putvalue('GL_COEFFR',0.0);
  TOBL.putvalue('GL_COEFFG',0.0);
  TOBL.putvalue('GL_COEFMARG',1.0);
  TOBL.putvalue('GL_RECALCULER','X');
  fTOBPiece.putvalue('GP_RECALCULER','X');
  TFFActure(FF).AfficheLaLigne(TOBL.getIndex);
  if IsOuvrage(TOBL) then
  begin
    AffecteCoTraitanceOuvrage (Fournisseur,LibelleFou,'001',TOBL,Indice,true);
  end else Inc(Indice);
//  if (not IsVariante(TOBL)) and (TOBL.GetValue('GL_ARTICLE') <> '') then TFfacture(FF).AjouteLaLigneCotrait (TOBL);
end;

procedure TPieceCotrait.AffecteCoTraitanceLigne (Fournisseur: string; var Indice: integer) ;
var TOBL : TOB;
		LibelleFou : string;
begin
  if FF is TFFacture then
  begin
    TOBL := fTOBPiece.detail[Indice-1]; if TOBL=nil then exit;
    LibelleFou := GetLibCoTraitant (Fournisseur);
    if IsSousDetail (TOBL) then
    begin
      AffecteCoTraitanceLigSDetail (TOBL,Fournisseur,LibelleFou,'001');
      Inc(Indice);
      exit;
    end;
    SetInfoCotraitancelig (TOBL,Fournisseur,LibelleFou,Indice);
    //
  end;
end;

procedure TPieceCotrait.GSAffectCotrait(Sender: tobject);
var retour : string;
		Indice,IndiceIni : integer;
begin
  fTOBligneArecalc.ClearDetail;
	if GS.nbSelected = 0 then BEGIN PGiInfo('Aucune ligne sélectionnée');exit; END;
  // Sélection du cotraitant
  retour := AGLLanceFiche('BTP','BTMULAFFAIREINTER','BAI_AFFAIRE='+fTOBAffaire.getValue('AFF_AFFAIRE'),'','');
  // --
  if retour <> '' then
  begin
  	Indice := 1;
  	repeat
      if (GS.IsSelected (Indice) ) then
      begin
      	IndiceIni := Indice;
        AffecteCoTraitanceLigne (Retour,Indice);
        if FF is TFFActure then
        begin
        	TFFActure(FF).AfficheLaLigne(IndiceIni)
        end else
        begin
        	TFLigNomen(FF).AfficheLaLigne(IndiceIni)
        end;
      end else inc(Indice);
    until Indice > GS.rowCount;
    for Indice := 0 to fTOBligneArecalc.Detail.count -1 do
    begin
      TFfacture(FF).AjouteLaLigne (TOB(fTOBligneArecalc.Detail[Indice].Data));
    end;
		NettoiePieceTrait(TFFacture(FF).ThePieceTrait);
    if FF is TFFActure then TFFacture(FF).CalculeLaSaisie(-1,-1,true);
  end;
  if assigned(fCopierColler) then
  begin
    GS.OnBeforeFlip := nil;
    GS.OnFlipSelection  := nil;
  end;
  GS.AllSelected := false;
  if assigned(fCopierColler) then
  begin
    GS.OnBeforeFlip := fcopiercoller.BeforeFlip;
    GS.OnFlipSelection  := fcopiercoller.FlipSelection;
  end;
end;

procedure TPieceCotrait.MenuEnabled(State: boolean);
var Indice : integer;
begin
  for Indice := 0 to fMaxItems -1 do
  begin
    fMenuItem[Indice].visible := State;
  end;
  if fPOPY <> nil then
  begin
    for Indice := 0 to fMaxpopyItems  -1 do
    begin
      fPOPYItem[Indice].visible := State;
    end;
  end;
end;

procedure TPieceCotrait.SetGrilleSaisie (State : boolean);
begin
	if SG_NATURETRAVAIL <> -1 then
  begin
    GS.ColEditables[SG_NATURETRAVAIL] := False;
    if not state then
    begin
      GS.Colwidths[SG_NATURETRAVAIL] := -1;
    end else
    begin
      GS.Colwidths[SG_NATURETRAVAIL] := 20;
      GS.ColFormats[SG_NATURETRAVAIL] := 'CB=BTNATURETRAVAIL';
      GS.ColDrawingModes[SG_NATURETRAVAIL]:= 'IMAGE'
    end;
	end;
  if SG_FOURNISSEUR <> -1 then
  begin
  	GS.ColEditables[SG_FOURNISSEUR] := False;
    if not state then
    begin
      GS.Colwidths[SG_FOURNISSEUR] := -1;
    end else
    begin
      GS.Colwidths[SG_FOURNISSEUR] := 90;
    end;
  end;
end;

procedure TPieceCotrait.SetSaisie;
begin
	fusable := true; // par défaut
	if not VH_GC.SeriaCoTraitance then fusable := false; // meme pas la peine de continuer
	if (fTOBaffaire <> nil) and (ftobPiece <> nil) then
  begin
  	if (fTOBaffaire.getValue ('AFF_MANDATAIRE') <> 'X') or
    	 (fTOBpiece.getValue('GP_VENTEACHAT')<>'VEN') then fusable := false; // on est pas en mode mandataire
  end;
  if not fusable then
  begin
  	SetGrilleSaisie(false);
  	MenuEnabled (false)
  end else
  begin
  	SetGrilleSaisie(true);
  	MenuEnabled (true);
  end;
  PieceTraitUsable := fUsable;
end;

procedure TPieceCotrait.Setaffaire(const Value: TOB);
begin
  fTOBAffaire := Value;
end;

procedure TPieceCotrait.AffecteInterneSousDetail(IndiceNomen : integer; TOBOUV : TOB; var indice : integer);
var TOBOL,TOBL : TOB;
		II,JJ,NextII,SS,CurrII : integer;
begin
	CurrII := indice;
  NextII := Indice +1;
	for II := 0 to TOBOUV.detail.count -1 do
  begin
		TOBOL := TOBOUV.detail[II];
    TOBOL.putValue('BLO_FOURNISSEUR','');
    TOBOL.putValue('GA_FOURNPRINC','');
    TOBOL.putValue('LIBELLEFOU','');
    TOBOL.putValue('BLO_NATURETRAVAIL','');
    TOBOL.putValue('BLO_DPA',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_DPR',TOBOL.GetValue('BLO_PUHT'));
    TOBOL.putValue('BLO_COEFFR',0);
    TOBOL.putValue('BLO_COEFFG',0);
    TOBOL.putValue('BLO_COEFFC',0);
    TOBOL.putValue('BLO_COEFMARG',1);
    TOBOL.putValue('BLO_NONAPPLICFRAIS','-');
    TOBOL.putValue('BLO_NONAPPLICFC','-');
    TOBOL.putValue('BLO_NONAPPLICFG','-');
		SS := CurrII + II + 1;
    TOBL := TOBPiece.detail[SS-1];
    if  (IsSousDetail(TOBL)) and
    		(TOBL.getValue('GL_INDICENOMEN')=IndiceNomen) and
    	  (TOBL.getValue('UNIQUEBLO')=TOBOL.GetValue('BLO_UNIQUEBLO')) then
    begin
    	InitLigneInterne1 (TOBL);
      NextII := SS+1;
    end;
    if TOBOL.detail.count > 0 then
    begin
    	AffecteInterneSousDetail (IndiceNomen,TOBOL,JJ);
    end;
  end;
  indice := NextII;
end;


procedure TPieceCotrait.AffecteInterneOuvrage (TOBL : TOB; var indice : integer);
var TOBOUV : TOB;
		IndiceNomen : integer;
begin
	IndiceNomen := TOBL.getvalue('GL_INDICENOMEN');
	if IndiceNomen > 0 then
  begin
    TOBOUV := TOBOuvrage.detail[IndiceNomen-1];
    AffecteInterneSousDetail(IndiceNomen,TOBOUV,Indice);
  end else Inc(Indice);
end;

procedure TPieceCotrait.InitLigneInterne1(TOBL : TOB);
begin
  TOBL.putvalue('GLC_NATURETRAVAIL','');
  TOBL.putvalue('GL_FOURNISSEUR','');
  TOBL.putvalue('LIBELLEFOU','');
  if TOBL.getvalue('GL_TYPELIGNE')<> 'ART' then exit;
  TOBL.putvalue('GL_DPA',TOBL.getValue('GL_PUHT'));
  TOBL.putvalue('GL_DPR',TOBL.getValue('GL_PUHT'));
//  TOBL.putvalue('GL_BLOQUETARIF','-');
  TOBL.putvalue('GLC_NONAPPLICFC','X');
  TOBL.putvalue('GLC_NONAPPLICFG','-');
  TOBL.putvalue('GLC_NONAPPLICFRAIS','X');
  TOBL.putvalue('GL_COEFFC',0.0);
  TOBL.putvalue('GL_COEFFR',0.0);
  TOBL.putvalue('GL_COEFFG',0.0);
  TOBL.putvalue('GL_COEFMARG',1.0);
end;

procedure TPieceCotrait.InitLigneInterne(TOBL : TOB; var Indice : integer);
begin
  if (not IsVariante(TOBL)) and (TOBL.GetValue('GL_ARTICLE') <> '') then
  begin
  	if AddLigneCalcul (TOBL) then TFfacture(FF).deduitLaLigne (TOBL);
  end;
  TOBL.putvalue('GLC_NATURETRAVAIL','');
  TOBL.putvalue('GL_FOURNISSEUR','');
  TOBL.putvalue('LIBELLEFOU','');
  if TOBL.getvalue('GL_TYPELIGNE')<> 'ART' then BEGIN Inc(Indice); exit; END;
  TOBL.putvalue('GL_DPA',TOBL.getValue('GL_PUHT'));
  TOBL.putvalue('GL_DPR',TOBL.getValue('GL_PUHT'));
//  TOBL.putvalue('GL_BLOQUETARIF','-');
  TOBL.putvalue('GLC_NONAPPLICFC','X');
  TOBL.putvalue('GLC_NONAPPLICFG','-');
  TOBL.putvalue('GLC_NONAPPLICFRAIS','X');
  TOBL.putvalue('GL_COEFFC',0.0);
  TOBL.putvalue('GL_COEFFR',0.0);
  TOBL.putvalue('GL_COEFFG',0.0);
  TOBL.putvalue('GL_COEFMARG',1.0);
  //
  if IsOuvrage(TOBL) then
  begin
    AffecteInterneOuvrage (TOBL,Indice);
  end else Inc(Indice);
  //
  TOBL.putvalue('GL_RECALCULER','X');
  fTOBPiece.putvalue('GP_RECALCULER','X');
  // if (not IsVariante(TOBL)) and (TOBL.GetValue('GL_ARTICLE') <> '') then TFfacture(FF).AjouteLaLigneCotrait (TOBL);
end;

procedure TPieceCotrait.AffecteInterne (var Indice : integer);
var TOBL : TOB;
		Fournisseur : string;
begin
	Fournisseur := '';
  if FF is TFFacture then
  begin
    TOBL := fTOBPiece.detail[Indice-1]; if TOBL=nil then exit;
    if IsSousDetail (TOBL) then
    begin
    	AffecteInterneSDetail (TOBL);
      Inc(Indice);
      exit;
    end;
    //
    InitLigneInterne(TOBL,Indice);

  end;
end;

procedure TPieceCotrait.NettoiePieceTrait(TOBpieceTrait : TOB);
var i : integer;
		TOBPT : TOB;
begin
  i:=0;
  repeat
    TOBPT := TOBPieceTrait.Detail[i];
    if (TOBPT.getvalue('BPE_TOTALHTDEV')=0) and (TOBPT.getvalue('BPE_DEJAFACT')=0) and (TOBPT.getvalue('BPE_MONTANTREGL')=0) then
    begin
    	TOBPT.free;
    end else inc(I);
  until i >= TOBPieceTrait.Detail.Count;
end;

procedure TPieceCotrait.GSAffectInterne(Sender: tobject);
var Indice,IndiceIni : integer;
begin
  fTOBligneArecalc.ClearDetail;
	if GS.nbSelected = 0 then BEGIN PGiInfo('Aucune ligne sélectionnée');exit; END;
  if PgiAsk ('Désirez-vous réellement affecter ces taches en interne ?','cotraitance') = mryes then
  begin
  	indice := 1;
    repeat
      if (GS.IsSelected (Indice) ) then
      begin
      	IndiceIni := Indice;
        AffecteInterne (Indice);
        if FF is TFFacture then TFFActure(FF).AfficheLaLigne(IndiceIni);
      end else Inc(Indice);
    until indice >= GS.rowCount;
    for Indice := 0 to fTOBligneArecalc.Detail.count -1 do
    begin
      TFfacture(FF).AjouteLaLigne (TOB(fTOBligneArecalc.Detail[Indice].data));
    end;
    if FF is TFFacture then TFFacture(FF).CalculeLaSaisie(-1,-1,true);
    NettoiePieceTrait (TFFacture(FF).ThePieceTrait );
  end;
  GS.OnBeforeFlip := nil;
  GS.OnFlipSelection  := nil;
  GS.AllSelected := false;
  if assigned(fCopiercoller) then
  begin
    GS.OnBeforeFlip := fcopiercoller.BeforeFlip;
    GS.OnFlipSelection  := fcopiercoller.FlipSelection;
  end;
end;

procedure TPieceCotrait.GSCotraittableau(sender: TObject);
begin
	TheTOB := TFFacture(FF).ThePieceTrait;
	AGLLanceFiche('BTP','BTMULAFFECTEXTE','','','COTRAITANCE;ACTION=MODIFICATION');
  TheTOB := nil;
end;

procedure TPieceCotrait.ReinitDetailOuvrage(TOBO : TOB);
var Indice : Integer;
begin
  TOBO.PutValue('BLO_NATURETRAVAIL','');
  TOBO.PutValue('BLO_FOURNISSEUR','');
  TOBO.putvalue('LIBELLEFOU','');
  if TOBO.Detail.Count > 0 then
  begin
    for Indice := 0 to TOBO.detail.count -1 do
    begin
      ReinitDetailOuvrage(TOBO.detail[Indice]);
    end;
  end;
end;

procedure TPieceCotrait.ReinitOuvrage(TOBL : TOB);
var indice : Integer;
		IndiceNomen : Integer;
    TOBOUV : TOB;
begin
  IndiceNomen := TOBL.GetValue('Gl_INDICENOMEN');
  if IndiceNomen > 0 then
  begin
    TOBOUV := fTOBOuvrage.detail[IndiceNomen-1];
    for Indice := 0 to TOBOUV.Detail.count -1 do
    begin
      ReinitDetailOuvrage (TOBOUV.detail[Indice]);
    end;
  end;
end;

procedure TPieceCotrait.ReinitSaisie;
var indice : integer;
begin
  GS.BeginUpdate;
	for Indice := 0 to fTOBpiece.detail.count -1 do
  begin
  	fTOBpiece.detail[Indice].PutValue('GLC_NATURETRAVAIL','');
  	fTOBpiece.detail[Indice].PutValue('GL_FOURNISSEUR','');
  	fTOBpiece.detail[Indice].PutValue('GL_RECALCULER','');
  	fTOBpiece.detail[Indice].putvalue('LIBELLEFOU','');
    ZeroLigneMontant (fTOBpiece.detail[Indice]);
    if (IsOuvrage(fTOBpiece.detail[Indice])) and (fTOBpiece.detail[Indice].GetValue('GL_INDICENOMEN')>0) then
    begin
      ReinitOuvrage(fTOBpiece.detail[Indice]);
    end;
  end;
  TFFacture(FF).ReinitPieceForCalc;
  GS.EndUpdate;
  fTOBpiece.putvalue('GP_RECALCULER','X');
  TFFacture(FF).CalculeLaSaisie(-1,-1,false); 
end;

end.
