unit BTPUtil;

interface

uses Classes,HEnt1,Ent1,EntGC,UTob, AGLInit, SaisUtil, UtilPGI,forms,Math,
{$IFDEF EAGLCLIENT}
     UtileAGL,MaineAGL,
{$ELSE}
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}EdtREtat,FE_Main,uPDFBatch,
{$ENDIF}
		 BTFactImprTob,  
     UtilPhases,
     FactTOB,TiersUtil,
     UTofGCDatePiece,FactUtil,HCtrls,ParamSoc,SysUtils,FactComm,uRecupSQLModele,
     hPDFPrev,hPDFViewer,hmsgbox,CalcOLEGenericBTP,UTofListeInv,FactCommBtp,uEntCommun;

Const { Concepts }
      bt110=110; //Modif Prospect
      bt111=111; //Modif Client
      bt112=112; //acces au sous-détail
      bt113=113; //accès à la remise
      bt114=114; //accès à l'escompte
      bt115=115; //accès à la simulation de rentabilité
      bt116=116; //accès à la suppression de pièce

Type
  BTTraitChantier = (BTTContrEtud,BTTModif,BTTSuppress);

	StInfosAffaire = record
    TypFac : string;
    ModeFact : boolean;
  end;

  TGenereLivraison = class
    private
    TOBPieces,ThePieces,ThePieceGenere,TheAffaires,TOBClients : TOB;
    TOBLivrDirecte : TOB;
    CompteRendu : boolean;
    DatePriseEnCompte : TDateTime;
    Duplication : Boolean;
    Transformation : Boolean;
    Action : TActionFiche;
//    LesNumPieces : string;
    procedure ChargeTobPieces(LaTob: TOB; Naturepiece: string);
    procedure MiseAjourPieceprec(TOBpiece: TOB);
    procedure AjusteLesLignes;
    procedure SetInfosLivraison(TOBL: TOB);
    procedure SetInfosClient (TOBL : TOB);
    procedure AddLivraisonDirecte (cledoc : r_cledoc);
    function MakeWhere: string;
    function AddDetail(TOBLD: TOB): string;
    function DejaLivre(Piece: string): boolean;
    public
    TheLignesALivrer : TOB;
    constructor create;
    destructor destroy; override;
    procedure GenereThepieces ;
    procedure DecortiqueBesoinLivraison;
    procedure TransformeAchatEnVente (TOBL : TOB);

  end;

var TheImpressionViaTOB : TImprPieceViaTOB;
		TOBDispoLoc : TOB;
    FromDispoGlob,FromDispoArt : boolean;
function SetPlusAffaire0 (TypeForce : string = ''): string;
Function GetEtatAffaire (Codessaff : string) : String ;
Procedure MajSousAffaire(TobPiece,TOBAcomptes:TOB; CodeAffaireAvenant : string;Action : TActionFiche;Duplic:Boolean;SaisieAvanc:boolean);
Function RenvoieTypeFact (Codessaff : string) : String ;
Function RenvoieCodeReg (codeaffaire : string) : String ;
Function RenvoieTypeRes (codeprestation : string) : String ;
Function RenvoieNumPiece (codeaffaire : string) : String ;
Function GetMiniAvancAcompte (CodessAff : string) : Integer;
Procedure MajApresGeneration(TobPiece,TOBPieceRG,TOBBasesRG,TOBAcomptes : Tob; DEV : Rdevise);
Procedure MajQtefacture(TobPiece,TobPiece_ori : Tob);
Procedure BtMajSDP(CleDoc : R_CleDoc;EnTOBUniquement : boolean = false);
Procedure BtMajTenueStock(CleDoc : R_CleDoc);
Function DerniereSituation(TOBPiece : TOB) : Boolean;
Procedure ModifSituation(TobPiece,TOBOuvrage,TobPieceRG,TOBPieceRg_O,TOBBasesRG,TOBAcomptes : Tob; DEV : RDevise );
function SupprimeSituation(TobPiece,TOBOuvrage,TobPieceRG,TOBBasesRG,TOBAcompte : Tob; DEV : RDevise ) : boolean;
//Function CalculMontantRevient (TOBPiece, TOBporcs : TOB; DEV:RDevise;InclusStInFG : boolean; var ExistFG : boolean) : double ;
Function BTPSupprimePieceFrais (CleDoc : R_CLEDOC):boolean; overload;
Function BTPSupprimePieceFrais (TOBPiece : TOB):boolean; overload
Function BTPSupprimePiece (CleDoc : R_CLEDOC;AvecAdresses:boolean=true):boolean;
Function Origine_EXCEL(TOBPiece : TOB) : Boolean;
Function Lexical_RechArt ( GS : THGrid ; TitreSel,NaturePieceG,DomainePiece,SelectFourniss : String ) : boolean ;
function CodeLaPiece (cledoc : r_cledoc) : string;
Procedure ImprimePieceBTP (cledoc : r_cledoc; Bapercu : boolean; Modele, Req ,TypeFacturation : string; DGD : boolean = false; ImpressionViaTOB : TImprPieceViaTOB = nil);
function MajMontantAcompte(TOBPiece,TOBAcomptes : TOB) : boolean;
procedure MajAffaireApresGeneration (TobPiece,TOBPieceRG,TOBBasesRG,TOBAcomptes : TOB;DEV: Rdevise; FinTravaux : boolean=false);
procedure MajQtesAvantSaisie (TobPiece : TOB);
function ControleAffaireRef (CodeAffaire : string) : boolean;
procedure GetMontantsAcomptes (TOBAcomptes : TOB;var MontantAcompte : double ; var MontantRegl : double);
function ControleChantierBTP (TOBPiece : TOB; Mode : BTTraitChantier) : boolean;
procedure ReajusteQteReste (TOBGenere : TOB);
// NEW One
function ISPrepaLivFromAppro : boolean;
//function ISGenereLivFromAppro : boolean;
procedure GenereLivraisonClients (ThePieceGenere : TOB;Action : TActionFiche;transfoPiece,DuplicPiece: boolean;DemandeDate: boolean = true);
function LivraisonVisible : boolean;
Procedure InitParPieceBTP;
function ExisteDocAchatLigne (theLigne : String) : boolean;
function ISAliveLine(TOBpiece: TOB): boolean;
Function GetQtelivrable (TOBL : TOB;gestionConso : TGestionPhase; TOBART : TOB = nil; PriseSurStock : boolean=true) : double;
Function GetQtelivrableHlien (TOBL : TOB;gestionConso : TGestionPhase; TOBART : TOB = nil) : double;
function NaturepieceOKPourOuvrage (TOBPiece : TOB) : boolean;
function IsPrestationInterne(Article : String) : boolean;
function TiersModifiableInDocument(TOBPiece : TOB) : Boolean;
function IsRetourFournisseur (TObpiece : TOB) : boolean;
function IsRetourClient(TOBPiece : TOB) : Boolean;
function ControleDateDocument ( StD : String ; Naturepiece : string) : integer ;
function IsSamePieceOrFromAchat (TOBL : TOB) : boolean;
function GetContact (TOBContact : TOB;LeTiers : string;NumeroContact : integer) : boolean; overload;
function GetContact (LeTiers : string;NumeroContact : integer; var libcontact : string) : boolean; overload;
function GetCodeBQ (TOBBanqueCP : TOB; CodeAuxiliaire: String; NumeroRIB : Integer) : boolean; Overload;
function GetCodeBQ (Auxiliaire : String; NumeroRIB : Integer; var RefBancaire : string) : boolean; overload;
Function  RenvoieInfosAffaireDevis (Codessaff : string) : StInfosAffaire ;
Procedure InitCalcDispo;
procedure InitCalcDispoArticle;
procedure FinCalcDispo;
function IsPrevisionChantier (TOBpiece : TOB) : boolean;
function GetNumCompteur (Souche : string; var TheNumero : integer) : boolean;
function isPieceGerableFraisDetail(naturePiece : string) : boolean;
function IsContreEtude (TOBpiece : TOB) : boolean;
function GetTauxFg (TOBporcs : TOB) : double;
procedure RestitueAcompte(Cledoc : R_cledoc; Journal : string; Numecr : integer ;MontantDev,Montant : double);
procedure DefiniPvLIgneModifiable (TOBpiece,TOBPOrcs: TOB);
function GetCoefFC (TOBpiece : TOB) : double; overload;
function GetCoefFC (MontantAppliquable,MontantFraisChantier : double) : double; overload;
Function GetContrat (Affaire : string) : string;
procedure DefiniDejaFacture (TOBPiece : TOB;DEV : rdevise);
procedure RecalculeCoefFrais (TOBPiece,TOBporcs : TOB);
function GetMontantFraisDetail (TOBPiece : TOB; Var ExistFg : boolean) : double;
procedure  SetLigneFacture (TOBL,TOBD : TOB);
procedure InitChampsSup(TOBL : TOB; iTable,Ichamps: integer; IndiceTOB: integer=0);
procedure AddChampsSupTable (TOBCur : TOB;PrefixeTable : string);
function getInfoPuissance (NbLig : integer) : integer;
procedure SetItemHvalComboBox (Combo : THValComboBox; Valeur : string);
//
Procedure LectBanque(TOBBQE : TOB; NumeroRIB : String);
Procedure LectRIB(TOBBQE : TOB; Auxiliaire : string; NumeroRIB : Integer);
//
implementation

uses AffaireUtil, Facture, FactRg,FactGrp,FactureBTP, TntWideStrings,UtilTOBPiece,factOuvrage,
  DB;


function FindPieceTraitOrig (TOBPieceTraitDevis: TOB; Cledoc : r_cledoc;Fournisseur : string) : TOB;
begin
  Result := TOBPieceTraitDevis.findFirst(['BPE_NATUREPIECEG','BPE_SOUCHE','BPE_NUMERO','BPE_INDICEG','BPE_FOURNISSEUR'],
                                         [Cledoc.NaturePiece,Cledoc.Souche,cledoc.NumeroPiece,Cledoc.Indice,Fournisseur],True);
end;

function ChargePieceTraitOrig(TOBPieceTraitDevis: TOB; cledoc : R_CLEDOC ; Fournisseur : string): TOB;
var Sql : string;
    QQ : TQuery;
begin
  Result := nil;
  Sql := 'SELECT * FROM PIECETRAIT WHERE '+WherePiece(cledoc,ttdPieceTrait,True)+' AND BPE_FOURNISSEUR="'+Fournisseur+'"';
  QQ := OpenSQL(Sql,True,1,'',True);
  if not QQ.eof then
  begin
    result := TOB.Create ('PIECETRAIT',TOBPieceTraitDevis,-1);
    result.SelectDB('',QQ);
  end;
  Ferme(QQ);
end;

procedure AjoutSuprAvancementOuv (TOBPieceTraitDevis,TOBL,TOBOuvrage,TOBENREG : TOB; Avancement : boolean);
var indiceNomen,II : integer;
		TOBOUV,TOBOO,TOBD : TOB;
    cledoc : r_cledoc;
    Req : string;
    QQ : Tquery;
    pourcent : double;
    TOBPTraitDevisL : TOB;
begin
	IndiceNomen := TOBL.GetValue('GL_INDICENOMEN'); if IndiceNomen = 0 then exit;
  TOBOUV := TOBOuvrage.detail[IndiceNomen-1]; if TOBOUV = nil then exit;
  for II := 0 to TOBOUV.detail.count -1 do
  begin
  	TOBOO := TOBOUV.detail[II];
  	if TOBOO.GEtValue('BLO_PIECEPRECEDENTE') = '' then exit;
    DecodeRefPieceOUv (TOBOO.GEtValue('BLO_PIECEPRECEDENTE'),cledoc);
    Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (cledoc,ttdLigneFac,false)+' AND BLF_NUMORDRE=0 AND BLF_UNIQUEBLO='+IntToStr(Cledoc.UniqueBlo);
    QQ:= OpenSql (Req,true,-1,'',true);
    if not QQ.eof then
    begin
      TOBD := TOB.Create ('LIGNEFAC',TOBENREG,-1);
      TOBD.SelectDB('',QQ);
      if Avancement then
      begin
        TOBD.PutValue('BLF_QTEDEJAFACT',TOBOO.GetValue('BLF_QTEDEJAFACT'));
        TOBD.PutValue('BLF_QTECUMULEFACT',TOBOO.GetValue('BLF_QTEDEJAFACT'));
        //
        TOBD.PutValue('BLF_MTDEJAFACT',TOBOO.GetValue('BLF_MTDEJAFACT'));
        TOBD.PutValue('BLF_MTCUMULEFACT',TOBOO.GetValue('BLF_MTDEJAFACT'));
        Pourcent := arrondi((TOBD.GetValue('BLF_QTECUMULEFACT') / TOBD.GetValue('BLF_QTEMARCHE')) * 100,2);
        TOBD.PutValue('BLF_POURCENTAVANC',Pourcent);
      end else
      begin
        TOBD.PutValue('BLF_QTEDEJAFACT',TOBD.GetValue('BLF_QTEDEJAFACT')-TOBOO.GetValue('BLF_QTESITUATION'));
        //
        TOBD.PutValue('BLF_MTDEJAFACT',TOBD.GetValue('BLF_MTDEJAFACT')-TOBOO.GetValue('BLF_MTSITUATION'));
        //
        Pourcent := arrondi((TOBD.GetValue('BLF_QTEDEJAFACT') / TOBD.GetValue('BLF_QTEMARCHE')) * 100,2);
        TOBD.PutValue('BLF_POURCENTAVANC',0);
      end;
    end;
    ferme(QQ);
    if (VALEUR(TOBOO.GetValue('BLO_NATURETRAVAIL'))<10) and (VALEUR(TOBL.GetValue('GLC_NATURETRAVAIL'))>=10) then
    begin
      TOBPTraitDevisL := FindPieceTraitOrig (TOBPieceTraitDevis,cledoc,TOBOO.GetValue('BLO_FOURNISSEUR'));
      if TOBPTraitDevisL = nil then
      begin
        TOBPTraitDevisL := ChargePieceTraitOrig(TOBPieceTraitDevis,cledoc,TOBOO.GetValue('BLO_FOURNISSEUR'));
      end;
      if TOBPTraitDevisL <> nil then
      begin
      	TOBPTraitDevisL.PutValue('BPE_MONTANTFAC',TOBPTraitDevisL.GetValue('BPE_MONTANTFAC')-TOBOO.GetValue('BLF_MTSITUATION'));
      end;
    end;
  end;
end;





function SetPlusAffaire0 (TypeForce : string = ''): string;
begin
	if TypeForce = '' then
  begin
    result := ' AND ((CO_CODE="A")';
    if VH_GC.BTSeriaAO then Result := Result + '  OR (CO_CODE="P")';
    if VH_GC.BTSeriaContrat then result := result + ' OR (CO_CODE="I")';
    if VH_GC.BTSeriaIntervention then result := result + ' OR (CO_CODE="W")';
    result := result + ')';
  end else
  begin
  	result := ' AND (CO_CODE="'+TypeForce+'")';
  end
end;

Function GetEtatAffaire (Codessaff : string) : String ;
{
Var Q : TQuery ;
    Req, EtatAffaire : String;
}
BEGIN
// OPTIMISATIONS LS
{
EtatAffaire := 'ENC';
//récupération du type de facturation pour l'affaire liée au devis
Req:='SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+Codessaff+'"' ;
Q:=OpenSQL(Req,TRUE) ;
if Not Q.EOF then EtatAffaire:=Q.Fields[0].AsString;
Ferme(Q) ;

result := EtatAffaire;
}
result := GetChampsAffaire (CodeSSAff,'AFF_ETATAFFAIRE');
if Result= '' then result := 'ENC';
end;

function ControleAffaireRef (CodeAffaire : string) : boolean;
var nbpiece : integer;
    CleDocAffaire : R_CLEDOC;
    Req : string;
begin
result := true;
if (CodeAffaire <> '') then
   begin
   NbPiece := SelectPieceAffaire(CodeAffaire, 'AFF', CleDocAffaire);
   if NbPiece = 1 then
      begin
      Req := 'UPDATE AFFAIRE SET AFF_MULTIPIECES = "-" WHERE AFF_AFFAIRE='+'"'+CodeAffaire+'"';//MODIFBTP190101
      if (ExecuteSQL(Req) < 1) then result := false;
      end;
   end;
end;

procedure ReinitEltAffaire (TOBAffaire : TOB);
begin
TOBAffaire.putValue('AFF_ACOMPTE',0);
TOBAffaire.putValue('AFF_ACOMPTEREND',0);
TOBAffaire.PutValue('AFF_MULTIPIECES', '-'); //MODIFBTP290301
TOBAffaire.PutValue('AFF_STATUTAFFAIRE', '');
TOBAffaire.PutValue('AFF_ETATAFFAIRE', 'ENC');
if TOBAffaire.GetValue('AFF_GENERAUTO') = '' then TOBAffaire.PutValue('AFF_GENERAUTO', VH_GC.AFFGenerAuto);
end;

Procedure MajSousAffaire(TobPiece,TOBAcomptes:TOB; CodeAffaireAvenant : string;Action : TActionFiche;Duplic:Boolean;SaisieAvanc:boolean);
Var CodeAffaire, Req, annee : string;
    NbPiece, i, Numpiece : Integer;
    Part0, Part1, Part2, Part3,Avenant : String;
    CleDocAffaire : R_CLEDOC;
    TOBAffaire : TOB;
    TOBAffaire2 : TOB;
    codessaff, MultiPiece : String;
    Q : TQuery ;
    Acompte,Regl : double;
BEGIN

CodeAffaire := TobPiece.GetValue('GP_AFFAIRE');
// Contrôle nombre de devis pour l'affaire si code affaire renseigné sinon toujours -1
// Attention la pièce courante est déjà créée donc SelectPieceAffaire renvoie au moins 1
if (CodeAffaire <> '') and (TobPiece.Getvalue ('GP_NATUREPIECEG') = VH_GC.AFNatAffaire) then
  NbPiece := SelectPieceAffaire(CodeAffaire, 'AFF', CleDocAffaire) // Lancement avec AFF pour lecture des devis
else
  NbPiece := -1;
// Chargement clé document pour la pièce en cours
FillChar(CleDocAffaire,Sizeof(CleDocAffaire),#0) ;
CleDocAffaire.NaturePiece:= TOBPIECE.GetValue('GP_NATUREPIECEG');
CleDocAffaire.DatePiece:= TOBPIECE.GetValue('GP_DATEPIECE');
CleDocAffaire.Souche:= TOBPIECE.GetValue('GP_SOUCHE');
CleDocAffaire.NumeroPiece:= TOBPIECE.GetValue('GP_NUMERO');
CleDocAffaire.Indice:= TOBPIECE.GetValue('GP_INDICEG');
Annee:=FormatDateTime('yy',CleDocAffaire.DatePiece) ;

// création TOB Affaire
TOBAffaire:=TOB.Create('AFFAIRE',Nil,-1) ;
RemplirTOBAffaire(CodeAffaire,TobAffaire);
TOBAffaire2:=TOB.Create('AFFAIRE',Nil,-1);
TOBAffaire2.Dupliquer (TOBAffaire, True, true);
ReinitEltAffaire (TOBAffaire2);
if CodeAffaire = '' then
begin
	TOBAffaire.PutValue('AFF_GENERAUTO', 'DIR');
	TOBAffaire2.PutValue('AFF_GENERAUTO', 'DIR');
end;
// Récupération code sous-affaire du devis
Req := 'SELECT GP_NUMERO, GP_AFFAIREDEVIS,GP_REFINTERNE FROM PIECE WHERE GP_AFFAIRE = "'+ CodeAffaire +
         '" AND GP_NATUREPIECEG = "' + CleDocAffaire.NaturePiece + '" AND GP_NUMERO = '+ IntToStr(CleDocAffaire.NumeroPiece);
Q := OpenSQL(Req, True,-1,'',true);
if Not Q.EOF then
    begin
    Codessaff:=Q.FindField('GP_AFFAIREDEVIS').AsString;
    end else
    begin
    Codessaff := '';
    end;

Ferme(Q);
Numpiece:= CleDocAffaire.NumeroPiece;

if NbPiece = 2 then
    begin
    if (Action = taCreat) or (Duplic = True) then
       begin
       Req := 'SELECT GP_NUMERO, GP_AFFAIREDEVIS,GP_REFINTERNE FROM PIECE WHERE GP_AFFAIRE = "'+ CodeAffaire +
           '" AND GP_NATUREPIECEG = "' + CleDocAffaire.NaturePiece + '" AND GP_NUMERO <> '+ IntToStr(CleDocAffaire.NumeroPiece);
       Q := OpenSQL(Req, True,-1,'',true);
       if Not Q.EOF then
          begin
          Numpiece:= Q.FindField('GP_NUMERO').AsInteger;
          Codessaff:=Q.FindField('GP_AFFAIREDEVIS').AsString;
          end else
          begin
          Numpiece := 0;
          Codessaff := '';
          end;
       Ferme(Q);
       end;
    // En création d'avenant, on met à jour le code sous-affaire
    // avec le nouveau code affaire créé
    if (CodeAffaireAvenant <> '00') then
       begin
       CodeAffaireAvenant := codessaff;
       end;

    end;  // fin du traitement particulier pour le deuxième devis

// BRL FQ10118 6/10/03
// maj affaire multipièces
if  (TobPiece.Getvalue ('GP_NATUREPIECEG') = VH_GC.AFNatAffaire) and (CodeAffaire <> '') then
    begin
    if NbPiece > 1 then MultiPiece:='X'
    else                MultiPiece:='-';
    Req := 'UPDATE AFFAIRE SET AFF_MULTIPIECES = "'+MultiPiece+'" WHERE AFF_AFFAIRE='+'"'+CodeAffaire+'"';
    ExecuteSQL(Req);
    end;

GetMontantsAcomptes (TOBAcomptes,Acompte,regl);

// Traitement de création d'un nouveau devis
if CledocAffaire.Naturepiece = 'DAP' then Codessaff := CodeAffaire
else if (Action = taCreat) or (Duplic = True) then {or ((Action = taModif) and (V_PGI.SAV)) : pour recréer fiche affaire-devis cf pb partage beneteau}
    begin
      // création sous-affaire pour nouveau devis
      if (CodeAffaireAvenant = '00') then
         begin // cas d'un devis initial
         Codessaff := Format ('%.8d',[CleDocAffaire.NumeroPiece]);
         Codessaff := 'Z'+CleDocAffaire.NaturePiece+CledocAffaire.Souche+Codessaff+'00';
         end else
         begin // cas d'un avenant
         Codessaff := Copy(CodeAffaireAvenant,2,14);
         Avenant := '01';
         Part0 := 'Z'+Codessaff+Avenant;
        // boucle pour verifier si la sous-affaire existe déjà
         while (existeaffaire (Part0,'') = true) Do
             begin
             i := StrToInt (Avenant);
             Inc(i);
             Avenant := Format ('%.2d',[i]);
             Part0 := 'Z'+Codessaff+Avenant;
             end;
         Codessaff := Part0;
         end;

      BTPCodeAffaireDecoupe(Codessaff, Part0, Part1, Part2, Part3,Avenant,taConsult,False);
      TOBAffaire2.PutValue('AFF_AFFAIRE', Codessaff);
      TOBAffaire2.PutValue('AFF_AFFAIRE0', 'Z');
      TOBAffaire2.PutValue('AFF_AFFAIRE1', Part1);
      TOBAffaire2.PutValue('AFF_AFFAIRE2', Part2);
      TOBAffaire2.PutValue('AFF_AFFAIRE3', Part3);
      TOBAffaire2.PutValue('AFF_AVENANT', Avenant);
      TOBAffaire2.PutValue('AFF_AFFAIREINIT', CodeAffaire);
      TOBAffaire2.PutValue('AFF_AFFAIREREF', CodeAffaire);
      TOBAffaire2.PutValue('AFF_TIERS', TOBPIECE.GetValue('GP_TIERS'));
      TOBAffaire2.PutValue('AFF_LIBELLE', TOBPIECE.GetValue('GP_REFINTERNE'));
      // AJOUT LS POUR GESTION LIGNE A ZERO
      TOBAffaire2.PutValue('AFF_OKSIZERO', TOBPIECE.GetValue('AFF_OKSIZERO'));
      // --
      if Acompte <> 0 then TOBAffaire2.PutValue('AFF_ACOMPTE',Acompte);
      TOBAffaire2.InsertDB(Nil);
    end else
    begin  // Traitement de modification d'un devis
      // maj code affaire reférence dans sous-affaire
      Req := 'UPDATE AFFAIRE SET AFF_OKSIZERO="'+TOBPiece.getValue('AFF_OKSIZERO')+'",AFF_AFFAIREREF ='+'"'+ CodeAffaire +'"'+',AFF_AFFAIREINIT ='+'"'+ CodeAffaire +'"'+',AFF_ACOMPTE='+StringReplace(FloatToStr(acompte),',','.',[rfReplaceAll])+' WHERE AFF_AFFAIRE ='+'"'+Codessaff+'"';
      ExecuteSQL(Req);
    end;

  // Maj code sous-affaire dans pièce
Req := 'UPDATE PIECE SET GP_AFFAIREDEVIS ='+'"'+ Codessaff+'" WHERE '+WherePiece(CleDocAffaire,ttdPiece,False) ;
ExecuteSQL(Req);
TOBPiece.PutValue('GP_AFFAIREDEVIS', Codessaff);

  // suppression des TOB Affaire
TOBAffaire.free;
TOBAffaire := Nil;
TOBAffaire2.free;
TOBAffaire2 := Nil;
END;

function MajMontantAcompte(TOBPiece,TOBAcomptes : TOB) : boolean;
var TOBAffaire : TOB;
    Req : string;
    Q : TQuery;
    Acompte,Regl : double;
begin
result := true;
if (TOBPiece.GetValue ('GP_AFFAIREDEVIS') <> '') and (TOBPiece.GetValue('GP_NATUREPIECEG')=GetParamSoc('SO_AFNATAFFAIRE')) then
   begin
   result := false;
   Req := 'SELECT AFF_AFFAIRE,AFF_ACOMPTE FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBPiece.GetValue('GP_AFFAIREDEVIS')+'"' ;
   Q := OpenSql (Req,true,-1,'',true);
   if not Q.eof then
      begin
      TobAffaire := TOB.Create ('AFFAIRE',nil,-1);
      TOBAffaire.selectdb ('',Q);
      ferme (Q);
      GetMontantsAcomptes (TOBAcomptes,Acompte,regl);
      if Acompte > 0 then
         begin
         TOBAffaire.PutValue('AFF_ACOMPTE',Acompte);
         if TOBAffaire.updateDb (true) then result := true;
         end else Result := true;
      TOBAffaire.free;
      end else Ferme(Q);
   end;
end;

procedure MajAffaireApresGeneration (TobPiece,TOBPieceRG,TOBBasesRG,TOBAcomptes : TOB;DEV: Rdevise; FinTravaux : boolean=false);
var Req : String;
    Q : Tquery;
    TOBAffaire : TOB;
begin
  if (TobPiece <> NIL) and ((TOBPIECE.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatAffaire) or (TOBPIECE.GetValue('GP_NATUREPIECEG') =VH_GC.AFNatProposition)) then Exit;

  if (not FinTravaux) then MajApresGeneration(TobPiece,TOBPieceRG,TOBBasesRG,TOBAcomptes,DEV);

  if TobPiece = nil then exit;
  if TOBPiece.GetValue('GP_AFFAIREDEVIS') = '' then exit;
  TobAffaire := TOB.Create ('AFFAIRE',nil,-1);
  Req := 'SELECT AFF_AFFAIRE,AFF_ACOMPTEREND FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBPiece.GetValue('GP_AFFAIREDEVIS')+'"' ;
  Q := OpenSql (Req,true,-1,'',true);
  TRY
    if not Q.eof then
    begin
      TOBAffaire.selectdb ('',Q);
      TOBAffaire.PutValue('AFF_ACOMPTEREND',TOBAffaire.GetValue('AFF_ACOMPTEREND')+TOBPiece.GetValue('GP_ACOMPTE'));
      TOBAffaire.updateDb (true);
    end;
  FINALLY
    TOBAffaire.free;
  ferme (Q);
  END;
end;

// fonction retournant le type de facturation lié au devis
Function  RenvoieTypeFact (Codessaff : string) : String ;
Var Q : TQuery ;
    Req, TypFac : String;
    TobLocal : TOB;
BEGIN
  if Codessaff = '' then BEGIN result := 'DIR'; exit; end;
  //
  TOBlocal := TOBlesAffaires.findfirst(['AFF_AFFAIRE'],[Codessaff],true);
  if TOBlocal = nil then
  begin
    //récupération du type de facturation pour l'affaire liée au devis
    Req:='SELECT AFF_GENERAUTO FROM AFFAIRE WHERE AFF_AFFAIRE="'+Codessaff+'"' ;
    Q:=OpenSQL(Req,TRUE,-1,'',true) ;
    if Not Q.EOF then TypFac:=Q.Fields[0].AsString
                 else TypFac := 'DIR';
    Ferme(Q) ;
    result := TypFac;
  end else
  begin
    result := TOBlocal.getValue('AFF_GENERAUTO');
  end;

end;

Function  RenvoieInfosAffaireDevis (Codessaff : string) : StInfosAffaire ;
Var Q : TQuery ;
    Req : string ;
    TheResult : stInfosAffaire;
BEGIN

//récupération du type de facturation pour l'affaire liée au devis
Req:='SELECT AFF_OKSIZERO,AFF_GENERAUTO FROM AFFAIRE WHERE AFF_AFFAIRE="'+Codessaff+'"' ;
Q:=OpenSQL(Req,TRUE,-1,'',true) ;
if Not Q.EOF then
begin
	TheResult.TypFac:=Q.Fields[1].AsString;
  TheResult.ModeFact := (Q.Fields[0].AsString='X');
end else
begin
	TheResult.TypFac := 'DIR';
  TheResult.ModeFact := false;
end;
Ferme(Q) ;

result := TheResult;

end;
// fonction retournant le code regroupement sur facture d'une affaire
Function  RenvoieCodeReg (codeaffaire : string) : String ;
Var Q : TQuery ;
    Req, CodReg : String;
BEGIN

Req:='SELECT AFF_REGROUPEFACT FROM AFFAIRE WHERE AFF_AFFAIRE="'+Codeaffaire+'"' ;
Q:=OpenSQL(Req,TRUE,-1,'',true);
if Not Q.EOF then CodReg:=Q.Fields[0].AsString
else CodReg := 'AUC';
Ferme(Q) ;

result := CodReg;

end;

// fonction retournant le N° de devis depuis le champ affairedevis
Function  RenvoieNumPiece (codeaffaire : string) : String ;
Var Q : TQuery ;
    Req : String;
    NumPiece : Integer;
BEGIN

Req:='SELECT GP_NUMERO FROM PIECE WHERE GP_AFFAIREDEVIS="'+Codeaffaire+'" AND GP_NATUREPIECEG="DBT"' ;
Q:=OpenSQL(Req,TRUE,-1,'',true);
if Not Q.EOF then NumPiece:=Q.Fields[0].AsInteger
else NumPiece := 0;
Ferme(Q) ;

result := IntToStr(NumPiece);

end;

// fonction retournant le type de ressource d'une prestation
Function  RenvoieTypeRes (codeprestation : string) : String ;
Var Q : TQuery ;
    Req, TypeRes : String;
BEGIN
TypeRes:='';
Req:='SELECT BNP_TYPERESSOURCE FROM NATUREPREST WHERE BNP_NATUREPRES=(';
Req:=Req+'SELECT GA_NATUREPRES FROM ARTICLE WHERE GA_ARTICLE="'+Codeprestation+'")';
Q:=OpenSQL(Req,TRUE,-1,'',true);
if Not Q.EOF then TypeRes:=Q.Fields[0].AsString;
Ferme(Q) ;

result := TypeRes;

end;

Procedure MajQtefacture(TobPiece,TobPiece_ori : Tob);
Var i : integer;
    TOBL : TOB;
    TypeFacturation : string;
Begin
  // Après génération de facture,
  // Maj dans le devis de la qté réellement facturée (en cumul pour les situations)
  if (TOBPiece.GetValue('GP_NATUREPIECEG')<>'FBT') and
  	 (TOBPiece.GetValue('GP_NATUREPIECEG')<>'DAC') then exit;
  for i:=0 to TOBPiece_ori.Detail.Count-1 do
  begin
    TOBL:=TOBPiece_ori.Detail[i] ;
    // Correction fiche qualité 11545 par LS
    // if (TOBL.GetValue('GL_REFARTSAISIE') <> '') then
    if (TOBL.GetValue('GL_ARTICLE') <> '') then
    begin
      TypeFacturation := RenvoieTypeFact(TOBPiece_ori.GetValue('GP_AFFAIREDEVIS'));
      if (TypeFacturation = 'AVA') or (TypeFacturation = 'DAC') then
      begin
        // en situation, stockage qté cumulée
        TOBL.PutValue('GL_QTESIT',TOBL.GetValue('GL_QTEPREVAVANC'));
      end else
      begin
        // en facture directe, cumul + stockage qté facturée
        TOBL.PutValue('GL_QTESIT',TOBL.GetValue('GL_QTESIT')+TOBL.GetValue('GL_QTEPREVAVANC')) ;
        TOBL.PutValue('GL_QTEPREVAVANC',0) ;
        TOBL.PutValue('GL_POURCENTAVANC',0) ;
      end;
      // MODIFBRL 13/11
      TOBL.PutValue('GL_QTERESTE',TOBL.GetValue('GL_QTEFACT')); {newpiece}
    end;
  end;
  TOBPiece_ori.UpdateDB (False);
End;

procedure GetMontantsAcomptes (TOBAcomptes : TOB;var MontantAcompte : double ; var MontantRegl : double);
var Indice : integer;
begin
MontantAcompte := 0;
MontantRegl := 0;
if TOBAcomptes = nil then Exit;
if TOBAcomptes.detail.count = 0  then Exit;
for Indice := 0 to TOBAcomptes.detail.count -1 do
    begin
(* ancienne gestion
    if TOBAcomptes.detail[Indice].getValue('GAC_ISREGLEMENT')='X' then
       begin
       MontantRegl := MontantRegl + TOBAcomptes.detail[Indice].getValue('GAC_MONTANTDEV');
       end else
       begin
       MontantAcompte := MontantAcompte + TOBAcomptes.detail[Indice].getValue('GAC_MONTANTDEV');
       end;
*)
			MontantAcompte := MontantAcompte + TOBAcomptes.detail[Indice].getValue('GAC_MONTANTDEV');
    end;
end;

Procedure MajApresGeneration(TobPiece,TOBPieceRG,TOBBasesRG ,TOBAcomptes: Tob; DEV : Rdevise);
Var Req: string;
    numsit : integer;
    tottva : double;
    Q : TQuery ;
    TTC,XP,XD,XE,TXD,TXP,TXE : Double;
    TypeFacturation : string;
    MontantRegl,MontantAcompte : double;
Begin
// Après génération de facture,
// Si situation, Maj table Situations
if TOBPieceRG = nil then Exit;
TypeFacturation := RenvoieTypeFact (TOBPiece.GetValue('GP_AFFAIREDEVIS'));
if (TypeFacturation = 'AVA') or (TypeFacturation = 'DAC') then
  begin
  // récupération dernier numéro de situation
  (*
  Req:='SELECT BST_NUMEROSIT FROM BSITUATIONS WHERE BST_NATUREPIECE="'+TOBPiece.GetValue('GP_NATUREPIECEG')+
       '" AND BST_SOUCHE="'+ TOBPiece.GetValue('GP_SOUCHE') +
       '" AND BST_SSAFFAIRE="'+ TOBPiece.GetValue('GP_AFFAIREDEVIS') +
       '" ORDER BY BST_SSAFFAIRE,BST_NUMEROSIT DESC';
  *)
  Req:='SELECT BST_NUMEROSIT FROM BSITUATIONS WHERE '+
       'BST_SSAFFAIRE="'+ TOBPiece.GetValue('GP_AFFAIREDEVIS') + '" '+
       'ORDER BY BST_SSAFFAIRE,BST_NUMEROSIT DESC';
  Q:=OpenSQL(Req,TRUE,-1,'',true);
  if Q.EOF then
    numsit := 0
  else
    begin
//inutile et pb pour eagl    Q.Findfirst;
    numsit := Q.Fields[0].AsInteger;
    end;
  Ferme(Q) ;
  // Maj table situations
  Inc(numsit);
  GetMontantsAcomptes (TOBAcomptes,MontantAcompte,MontantRegl);
  GetMontantRG (TOBPieceRG,TOBBasesRG,XD,XP,DEV,True);
  GetcumultaxesRG (TOBBasesRG,TOBPieceRG,TXD,TXP,DEV);
  TTC := TOBPiece.GetValue('GP_TOTALTTCDEV') - XD - TXD;
  tottva := TTC - TOBPiece.GetValue('GP_TOTALHTDEV');
  Req := 'INSERT INTO BSITUATIONS '+
         '(BST_NATUREPIECE,BST_SOUCHE,BST_NUMEROFAC,BST_NUMEROSIT,BST_DATESIT,BST_AFFAIRE,BST_SSAFFAIRE,BST_MONTANTHT,BST_MONTANTTVA,BST_MONTANTTTC,BST_MONTANTACOMPTE,BST_MONTANTREGL) '+
         ' VALUES '+
         '("'+
         TOBPiece.GetValue('GP_NATUREPIECEG')+
         '","'+
         TOBPiece.GetValue('GP_SOUCHE')+
         '",'+
         IntToStr(TOBPiece.GetValue('GP_NUMERO'))+
         ','+
         IntToStr(numsit)+
         ',"'+
         usdatetime(StrToDate(TOBPiece.GetValue('GP_DATEPIECE')))+
         '","'+
         TOBPiece.GetValue('GP_AFFAIRE')+
         '","'+
         TOBPiece.GetValue('GP_AFFAIREDEVIS')+
         '",'+
         StringReplace(FloatToStr(TOBPiece.GetValue('GP_TOTALHTDEV')),',','.',[rfReplaceAll])+
         ','+
         StringReplace(FloatToStr(tottva),',','.',[rfReplaceAll])+
         ','+
         StringReplace(FloatToStr(TTC),',','.',[rfReplaceAll])+
         ','+
         StringReplace(FloatToStr(MontantAcompte),',','.',[rfReplaceAll])+
         ','+
         StringReplace(FloatToStr(MontantRegl),',','.',[rfReplaceAll])+
         ')';
  ExecuteSQL(Req);
  end;
End;


Procedure ModifSituation(TobPiece,TOBOuvrage,TobPieceRG,TOBPieceRg_O,TOBBasesRG,TOBAcomptes : Tob; DEV : RDevise );

	procedure MajLigneDevisOuv ( TOBL,TOBOuvrage : TOB);
  var TOBO ,TOBOO, TOBODD : TOB;
  		II,Indicenomen : integer;
      QQ : Tquery;
    	CD : R_CleDoc ;
      Req : string;
      Pourcent : double;
      created : boolean;
  begin
    IndiceNomen := TOBL.getValue('GL_INDICENOMEN'); if IndiceNomen = 0 then exit;
    TOBOO := TOBOuvrage.detail[IndiceNomen-1];
    TOBODD := TOB.Create ('LIGNEFAC',nil,-1);
    for II := 0 TO TOBOO.detail.count -1 do
    begin
    	TOBO := TOBOO.detail[II];
      if TOBO.getValue('BLO_PIECEPRECEDENTE')='' then continue;
      DecodeRefPieceOUv(TOBO.getValue('BLO_PIECEPRECEDENTE'),CD) ;
      Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (CD,ttdLigneFac,false)+' AND BLF_NUMORDRE=0 AND BLF_UNIQUEBLO='+IntToStr(CD.UniqueBlo);
      QQ:= OpenSql (Req,true,-1,'',true);
      created := false;
      if not QQ.eof then
      begin
        TOBODD.SelectDb ('',QQ);
      end else
      begin
      	TOBODD.InitValeurs(false);
        TOBODD.putValue('BLF_NATUREPIECEG',CD.NaturePiece );
        TOBODD.putValue('BLF_SOUCHE',CD.Souche );
        TOBODD.putValue('BLF_DATEPIECE',CD.DatePiece);
        TOBODD.putValue('BLF_NUMERO',CD.NumeroPiece );
        TOBODD.putValue('BLF_INDICEG',CD.Indice );
        TOBODD.putValue('BLF_NUMORDRE',0);
        TOBODD.putValue('BLF_UNIQUEBLO',CD.UniqueBlo);
        TOBODD.putValue('BLF_MTMARCHE',TOBO.GetValue('BLF_MTMARCHE'));
      	TOBODD.putValue('BLF_MTDEJAFACT',TOBO.GetValue('BLF_MTDEJAFACT'));
        TOBODD.putValue('BLF_QTEMARCHE',TOBO.GetValue('BLF_QTEMARCHE'));
        TOBODD.putValue('BLF_QTEDEJAFACT',TOBO.GetValue('BLF_QTEDEJAFACT'));
        created := true;
      end;
      TOBODD.PutValue('BLF_QTEDEJAFACT',TOBO.GetValue('BLF_QTECUMULEFACT'));
      TOBODD.PutValue('BLF_QTECUMULEFACT',TOBO.GetValue('BLF_QTECUMULEFACT'));
      //
      TOBODD.PutValue('BLF_MTDEJAFACT',TOBO.GetValue('BLF_MTCUMULEFACT'));
      TOBODD.PutValue('BLF_MTCUMULEFACT',TOBO.GetValue('BLF_MTCUMULEFACT'));
      //
      Pourcent := arrondi((TOBODD.GetValue('BLF_MTCUMULEFACT') / TOBODD.GetValue('BLF_MTMARCHE')) * 100,2);
      TOBODD.PutValue('BLF_POURCENTAVANC',Pourcent);
      if TOBODD.getvalue('BLF_MTCUMULEFACT')=0 then
      begin
      	if not created then
        begin
      		TOBODD.SetAllModifie(true);
        	TOBODD.DeleteDB(false);
        end;
      end else
      begin
      	if created then
        begin
      		TOBODD.SetAllModifie(true);
        	TOBODD.InsertDB(nil,false)
        end else TOBODD.UpdateDB(false);
      end;
      ferme (QQ);
    end;
    TOBODD.free;
  end;

  procedure MajLignesFacOuvr (TOBL,TOBOuvrage : TOB);
  var TOBO ,TOBOO, TOBODF : TOB;
  		II,Indicenomen : integer;
      QQ : Tquery;
    	CD : R_CleDoc ;
      Req,refPiece : string;
      Pourcent : double;
      created : boolean;
  begin
    IndiceNomen := TOBL.getValue('GL_INDICENOMEN'); if IndiceNomen = 0 then exit;
    TOBOO := TOBOuvrage.detail[IndiceNomen-1];
    TOBODF := TOB.Create('LIGNEFAC',nil,-1);
    for II := 0 TO TOBOO.detail.count -1 do
    begin
    	TOBO := TOBOO.detail[II];
      RefPiece := EncodeRefPieceOuv(TOBO);
      DecodeRefPieceOUv(RefPiece,CD);
      created := false;
      Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (CD,ttdLigneFac,false)+' AND BLF_NUMORDRE=0 AND BLF_UNIQUEBLO='+IntToStr(CD.UniqueBlo);
      QQ:= OpenSql (Req,true,-1,'',true);
      if not QQ.eof then
      begin
      	TOBODF.SelectDB('',QQ);
      end else
      begin
        TOBODF.putValue('BLF_NATUREPIECEG',TOBL.GetValue('GL_NATUREPIECEG'));
        TOBODF.putValue('BLF_SOUCHE',TOBL.GetValue('GL_SOUCHE'));
        TOBODF.putValue('BLF_DATEPIECE',TOBL.GetValue('GL_DATEPIECE'));
        TOBODF.putValue('BLF_NUMERO',TOBL.GetValue('GL_NUMERO'));
        TOBODF.putValue('BLF_INDICEG',TOBL.GetValue('GL_INDICEG'));
        TOBODF.putValue('BLF_NUMORDRE',0);
        TOBODF.putValue('BLF_UNIQUEBLO',TOBO.GetValue('BLO_UNIQUEBLO'));
        TOBODF.putValue('BLF_MTMARCHE',TOBO.GetValue('BLF_MTMARCHE'));
      	TOBODF.putValue('BLF_MTDEJAFACT',TOBO.GetValue('BLF_MTDEJAFACT'));
        TOBODF.putValue('BLF_QTEMARCHE',TOBO.GetValue('BLF_QTEMARCHE'));
        TOBODF.putValue('BLF_QTEDEJAFACT',TOBO.GetValue('BLF_QTEDEJAFACT'));
        created := true;
      end;
      //
      TOBODF.putValue('BLF_MTCUMULEFACT',TOBO.GetValue('BLF_MTCUMULEFACT'));
      TOBODF.putValue('BLF_MTSITUATION',TOBO.GetValue('BLF_MTSITUATION'));
      TOBODF.putValue('BLF_QTECUMULEFACT',TOBO.GetValue('BLF_QTECUMULEFACT'));
      TOBODF.putValue('BLF_QTESITUATION',TOBO.GetValue('BLF_QTESITUATION'));
      TOBODF.putValue('BLF_POURCENTAVANC',TOBO.GetValue('BLF_POURCENTAVANC'));
      TOBODF.SetAllModifie (true);
      //
      if TOBODF.GetValue('BLF_MTSITUATION') = 0 then
      begin
      	if not Created then TOBODF.DeleteDB(false); // le montant de situation est devenu nul alors qu'il existait préalablement
      end else
      begin
      	if Created then TOBODF.InsertDB(nil,false) // situation positionné alors qu'elle n'existait pas avant
        	 				 else TOBODF.UpdateDB(false);    // mise à jour
      end;
    end;
    TOBODF.free;
  end;

Var Req, StPrec, QteSit, QtePrevavanc, PourcentSit,NaturePiece: string;
    i : integer;
    TOBL,TOBSIT,TOBLF,TOBLIGNEFAC : TOB;
    CD : R_CleDoc ;
    QQ : TQuery;
    XP,XD,XE,TXP,TXD,TXE,Pourcent : double;
    TTC : double;
    TypeFacturation : string;
    MontantRegl,MontantAcompte : double;
    Avancement : boolean;
Begin
  Avancement := (Pos(RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS')),'AVA;DAC')>0);
  TOBLIGNEFAC := TOB.create ('LES LIGNES FACTURATION',nil,-1);
  NaturePiece := TOBPiece.GetValue('GP_NATUREPIECEG');
// Après modification de facture,
// Si situation, Maj lignes du devis
//if (TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'))='AVA') then
  if ((NaturePiece = 'FBT') or (NaturePiece = 'DAC')) and
  	 (TOBPiece.GetValue('GP_AFFAIREDEVIS')<>'') then
  begin
    for i:=0 to TOBPiece.Detail.Count-1 do
    begin
      TOBL:=TOBPiece.Detail[i] ;
      if IsSousDetail(TOBL) then continue;
      //
      if (TOBL <> Nil) and (TOBL.GetValue('QTECHANGE')='X') then
      begin
        if TOBL.GetValue ('GL_TYPELIGNE') <> 'ART' Then Continue;
        StPrec:=TOBL.GetValue('GL_PIECEPRECEDENTE') ;
        if StPrec <> '' then
        begin
          DecodeRefPiece(StPrec,CD) ;
          Req := 'SELECT * FROM LIGNE WHERE '+ WherePiece (CD,ttdLigne,true,True);
          QQ:= OpenSql (Req,true,-1,'',true);
          if not QQ.eof then
          begin
            TOBLF := TOB.Create ('LIGNE',nil,-1);
            TOBLF.SelectDB ('',QQ);
            //
            if Avancement then  
            begin
            	if TOBL.getValue('GL_QTEPREVAVANC')=0 then
              begin
              	Pourcent := Arrondi(TOBL.GetValue('BLF_POURCENTAVANC'),2);
              end else
              begin
              	Pourcent := Arrondi(TOBL.GetValue('GL_QTESIT')/TOBL.GetValue('GL_QTEPREVAVANC')*100,2);
              end;
              TOBLF.PutValue('GL_QTEPREVAVANC',TOBL.GetValue('GL_QTESIT'));
              TOBLF.PutValue('GL_QTESIT',TOBL.GetValue('GL_QTESIT'));
              TOBLF.PutValue('GL_POURCENTAVANC',Pourcent);
            end else
            begin
              TOBLF.PutValue('GL_QTEPREVAVANC',TOBLF.GetValue('GL_QTEPREVAVANC')-TOBL.GetValue('OLD_QTESIT')+TOBL.GetValue('GL_QTEFACT'));
              TOBLF.PutValue('GL_QTESIT',TOBLF.GetValue('GL_QTEPREVAVANC'));
            end;
            TOBLF.UpdateDB (false);
            //
            if avancement then
            begin
              Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (CD,ttdLigneFac,true,True);
              QQ:= OpenSql (Req,true,-1,'',true);
              if not QQ.eof then
              begin
                TOBLF := TOB.Create ('LIGNEFAC',nil,-1);
                TOBLF.SelectDB ('',QQ);
                //
                TOBLF.PutValue('BLF_QTEDEJAFACT',TOBL.GetValue('BLF_QTECUMULEFACT'));
                TOBLF.PutValue('BLF_QTECUMULEFACT',TOBL.GetValue('BLF_QTECUMULEFACT'));
                //
                TOBLF.PutValue('BLF_MTDEJAFACT',TOBL.GetValue('BLF_MTCUMULEFACT'));
                TOBLF.PutValue('BLF_MTCUMULEFACT',TOBL.GetValue('BLF_MTCUMULEFACT'));
                //
                Pourcent := arrondi((TOBL.GetValue('BLF_MTCUMULEFACT') / TOBL.GetValue('BLF_MTMARCHE')) * 100,2);
                TOBLF.PutValue('BLF_POURCENTAVANC',Pourcent);
                if TOBLF.GetValue('BLF_QTEDEJAFACT') <> 0 then
                begin
                  TOBLF.UpdateDB (false);
                end else
                begin
                  TOBLF.DeleteDB (false);
                end;
                TOBLF.free;
              end;
              ferme (QQ);
              //
              if IsOuvrage(TOBL) and (TOBL.getValue('GL_INDICENOMEN')>0) then
              begin
              	MajLigneDevisOuv (TOBL,TOBOUvrage);
              end;
            end;
          end;
        end;
      end;
      //
      if (Avancement) and (TOBL <>Nil) then
      begin
        TOBLF := TOB.Create ('LIGNEFAC',TOBLIGNEFAC,-1);
        SetLigneFacture (TOBL,TOBLF);
        if IsOuvrage(TOBL) then MajLignesFacOuvr(TOBL,TOBOUvrage);
      end;
      //
    end;
    //
    if TOBLIGNEFAC.detail.count > 0 then TOBLIGNEFAC.InsertDB (nil);
    //
    ReajusteCautionDocOrigine (TOBPIECE,TOBPieceRG,true,TOBPieceRG_O);
    // Reajustement de BSITUATION si besoin est

    req := 'SELECT * FROM BSITUATIONS WHERE BST_NATUREPIECE="'+TOBPIece.GetValue('GP_NATUREPIECEG')+'" AND ';
    req := Req + 'BST_SOUCHE="'+TOBPIece.GetVAlue('GP_SOUCHE')+'" AND BST_NUMEROFAC="'+inttoStr(TOBPiece.GetValue('GP_NUMERO'))+'"';
    QQ := OpenSql(Req,true,-1,'',true);
    if not QQ.eof then
    begin
      GetMontantsAcomptes (TOBAcomptes,MontantAcompte,MontantRegl);
      GetMontantRG (TOBPieceRG,TOBBasesRG,XD,XP,DEV,True,True);
      GetcumultaxesRG (TOBBasesRG,TOBPieceRG,TXD,TXP,DEV);
      TOBSit := TOB.create ('BSITUATIONS',nil,-1);
      TOBSIt.SelectDB ('',QQ);
      TTC := TOBPiece.GetValue('GP_TOTALTTCDEV') - XD - TXD;
      TOBSIt.putvalue('BST_MONTANTHT',TOBPiece.GetValue('GP_TOTALHTDEV'));
      TOBSIt.putvalue('BST_MONTANTTVA',TTC - TOBPiece.GetValue('GP_TOTALHTDEV'));
      TOBSIt.putvalue('BST_MONTANTTTC',TTC);
      TOBSIT.PutValue('BST_MONTANTREGL',MontantRegl);
      TOBSIT.PutValue('BST_MONTANTACOMPTE',MontantAcompte);
      TOBSit.SetAllModifie (true);
      TOBSIT.UpdateDB (false);
      TOBSIT.free;
    end;
    ferme (QQ);
  end;
  TOBLIGNEFAC.Free;
End;

function GetClefEcriture (TOBA: TOB) : string;
begin
result :='E_JOURNAL="'+TOBA.GetValue('GAC_JALECR')+'" AND E_NUMEROPIECE='+IntToStr(TOBA.GetValue('GAC_NUMECR'));
end;

function SupprimeSituation(TobPiece,TOBOuvrage,TobPieceRG,TOBBasesRG,TOBAcompte : Tob; DEV : RDevise ) : boolean;
Var Req, StPrec: string;
    i : integer;
    TOBL,TOBSIT,TOBPIece_O,TOBL_O,TOBA,TOBFACTURE_O : TOB;
    CD : R_CleDoc ;
    QQ,Q : TQuery;
    Pourcent,reste : double;
    TypeFacturation,EtatLettrage : string;
    NaturePiece: string;
    NewValeur : double;
    TOBPieceTraitDevis,TOBPTraitDevisL : TOB;
Begin
	TOBPieceTraitDevis := TOB.Create ('LES PIECETRAIT ORIG',nil,-1);
  //
  NaturePiece := TOBPiece.GetValue('GP_NATUREPIECEG');
  result := true;
  TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  //
  if (NaturePiece = 'FBT') or (Naturepiece = 'DAC') then
  begin
  	if not RestitueMontantCautionUtilise (TOBPieceRG) then exit;
  end;
  //
  // ancienne position
  // if ((TypeFacturation<>'AVA') And (TypeFacturation<>'DAC')) then exit;

  TOBPiece_O := TOB.Create ('LES LIGNES DEVIS',nil,-1);
  TOBFacture_O := TOB.Create ('LES LIGNES AVANC',nil,-1);
  //
  if ((TypeFacturation='AVA') or (TypeFacturation='DAC')) then
  begin
    if ((NaturePiece = 'FBT') or (NaturePiece = 'DAC')) and (TOBPiece.GetValue('GP_AFFAIREDEVIS')<>'') then
    begin
      for i:=0 to TOBPiece.Detail.Count-1 do
      begin
        TOBL:=TOBPiece.Detail[i] ;
        if (TOBL <> Nil) then
        begin
          StPrec:=TOBL.GetValue('GL_PIECEPRECEDENTE') ;
          if (StPrec <> '') and (TOBL.GetValue('GL_QTEFACT') <> 0) then
          begin
            DecodeRefPiece(StPrec,CD) ;
            //
            Req:='SELECT * FROM LIGNE WHERE '+ WherePiece (CD,ttdLigne,true,True);
            Q := OpenSql (Req,true,-1,'',true);
            if not Q.eof then
            begin
              TOBL_O := TOB.Create ('LIGNE',TOBPiece_O,-1);
              TOBL_O.SelectDB ('',Q);
              //
              NewValeur := TOBL_O.GetValue('GL_QTESIT') - TOBL.GetValue('GL_QTEFACT');
              if ((TOBL_O.GetValue('GL_QTESIT') < 0) and (newValeur > 0)) or ((TOBL_O.GetValue('GL_QTESIT') > 0) and (newValeur < 0)) then
              begin
                newValeur := 0;
              end;
              TOBL_O.PutValue('GL_QTESIT',NewValeur);
              TOBL_O.PutValue('GL_QTEPREVAVANC',NewValeur);
              //
              if TOBL_O.GetValue('GL_QTEFACT') <> 0 then
              begin
                Pourcent := arrondi((TOBL_O.GetValue('GL_QTESIT') / TOBL_O.GetValue('GL_QTEFACT')) * 100,2);
                TOBL_O.PutValue('GL_POURCENTAVANC',Pourcent);
              end;
            end;
            ferme (Q);
            // traitement de mise à jour des lignes fac du devis initial
            Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (CD,ttdLigneFac,true,True);
            Q := OpenSql (Req,true,-1,'',true);
            if not Q.eof then
            begin
              TOBL_O := TOB.Create ('LIGNEFAC',TOBFacture_O,-1);
              TOBL_O.SelectDB ('',Q);
              //
              TOBL_O.PutValue('BLF_QTEDEJAFACT',TOBL.GetValue('BLF_QTEDEJAFACT'));
              TOBL_O.PutValue('BLF_QTECUMULEFACT',TOBL.GetValue('BLF_QTEDEJAFACT'));
              //
              TOBL_O.PutValue('BLF_MTDEJAFACT',TOBL.GetValue('BLF_MTDEJAFACT'));
              TOBL_O.PutValue('BLF_MTCUMULEFACT',TOBL.GetValue('BLF_MTDEJAFACT'));
              //
              Pourcent := arrondi((TOBL_O.GetValue('BLF_QTECUMULEFACT') / TOBL_O.GetValue('BLF_QTEMARCHE')) * 100,2);
              TOBL_O.PutValue('BLF_POURCENTAVANC',Pourcent);
            end;
            ferme (Q);
            //
            if VALEUR(TOBL.GetValue('GLC_NATURETRAVAIL'))<10 then
            begin
              TOBPTraitDevisL := FindPieceTraitOrig (TOBPieceTraitDevis,CD,TOBL.GetValue('GL_FOURNISSEUR'));
              if TOBPTraitDevisL = nil then
              begin
                TOBPTraitDevisL := ChargePieceTraitOrig(TOBPieceTraitDevis,CD,TOBL.GetValue('GL_FOURNISSEUR'));
              end;
              if TOBPTraitDevisL <> nil then
              begin
                TOBPTraitDevisL.PutValue('BPE_MONTANTFAC',TOBPTraitDevisL.GetValue('BPE_MONTANTFAC')-TOBL.GetValue('BLF_MTSITUATION'));
              end;
            end;
            //
            if isOuvrage (TOBL) then
            begin
              AjoutSuprAvancementOuv (TOBPieceTraitDevis,TOBL,TOBOuvrage,TOBfacture_O,true);
            end;

          end;
        end;
      end;
      //  ReajusteCautionDocOrigine (TOBPIECE,TOBPieceRG,false);
      // Suppression de la situation
      req := 'SELECT * FROM BSITUATIONS WHERE BST_NATUREPIECE="'+TOBPIece.GetValue('GP_NATUREPIECEG')+'" AND ';
      req := Req + 'BST_SOUCHE="'+TOBPIece.GetVAlue('GP_SOUCHE')+'" AND BST_NUMEROFAC="'+inttoStr(TOBPiece.GetValue('GP_NUMERO'))+'"';
      QQ := OpenSql(Req,true,-1,'',true);
      if not QQ.eof then
      begin
        TOBSit := TOB.create ('BSITUATIONS',nil,-1);
        TOBSIt.selectdb ('',QQ);
        if not TOBSIt.DeleteDB (false) then Result := false;
        TOBSit.free;
      end;
      ferme (QQ);
    end;
  end else if (NaturePiece = 'FBT') and (TOBPiece.GetValue('GP_AFFAIREDEVIS')<>'') then
  begin
  	// facture directe
    for i:=0 to TOBPiece.Detail.Count-1 do
    begin
      TOBL:=TOBPiece.Detail[i] ;
      if (TOBL <> Nil) then
      begin
        StPrec:=TOBL.GetValue('GL_PIECEPRECEDENTE') ;
        if IsSousDetail(TOBL) then continue; // on ne traite pas les lignes de gestion des sous détail
        if (StPrec <> '') and (TOBL.GetValue('GL_QTEFACT') <> 0) then
        begin
          DecodeRefPiece(StPrec,CD) ;
          Req:='SELECT * FROM LIGNE WHERE '+ WherePiece (CD,ttdLigne,true,True);
          Q := OpenSql (Req,true,-1,'',true);
          if not Q.eof then
          begin
            TOBL_O := TOB.Create ('LIGNE',TOBPiece_O,-1);
            TOBL_O.SelectDB ('',Q);
            //
            NewValeur := TOBL_O.GetValue('GL_QTESIT') - TOBL.GetValue('GL_QTEFACT');
            if ((TOBL_O.GetValue('GL_QTESIT') < 0) and (newValeur > 0)) or ((TOBL_O.GetValue('GL_QTESIT') > 0) and (newValeur < 0)) then
            begin
              newValeur := 0;
            end;
            TOBL_O.PutValue('GL_QTESIT',NewValeur);
            TOBL_O.PutValue('GL_QTEPREVAVANC',NewValeur);
          end;
          ferme (Q);
          // traitement de mise à jour des lignes fac du devis initial
          Req := 'SELECT * FROM LIGNEFAC WHERE '+ WherePiece (CD,ttdLigneFac,true,True);
          Q := OpenSql (Req,true,-1,'',true);
          if not Q.eof then
          begin
            TOBL_O := TOB.Create ('LIGNEFAC',TOBFacture_O,-1);
            TOBL_O.SelectDB ('',Q);
            //
            TOBL_O.PutValue('BLF_QTEDEJAFACT',TOBL_O.GetValue('BLF_QTEDEJAFACT')-TOBL.GetValue('BLF_QTESITUATION'));
            //
            TOBL_O.PutValue('BLF_MTDEJAFACT',TOBL_O.GetValue('BLF_MTDEJAFACT')-TOBL.GetValue('BLF_MTSITUATION'));
            //
            Pourcent := arrondi((TOBL_O.GetValue('BLF_QTEDEJAFACT') / TOBL_O.GetValue('BLF_QTEMARCHE')) * 100,2);
            TOBL_O.PutValue('BLF_POURCENTAVANC',0);
          end;
          ferme (Q);

          if VALEUR(TOBL.GetValue('GLC_NATURETRAVAIL'))<10 then
          begin
            TOBPTraitDevisL := FindPieceTraitOrig (TOBPieceTraitDevis,CD,TOBL.GetValue('GL_FOURNISSEUR'));
            if TOBPTraitDevisL = nil then
            begin
              TOBPTraitDevisL := ChargePieceTraitOrig(TOBPieceTraitDevis,CD,TOBL.GetValue('GL_FOURNISSEUR'));
            end;
            if TOBPTraitDevisL <> nil then
            begin
              TOBPTraitDevisL.PutValue('BPE_MONTANTFAC',TOBPTraitDevisL.GetValue('BPE_MONTANTFAC')-TOBL.GetValue('BLF_MTSITUATION'));
            end;
          end;
            //
          if isOuvrage (TOBL) then
          begin
            AjoutSuprAvancementOuv (TOBPieceTraitDevis,TOBL,TOBOuvrage,TOBfacture_O,false);
          end;
        end;
      end;
    end;
  end;

  if (Result) and (TOBPieceTraitDevis.detail.count > 0 ) then
  BEGIN
  	if not TOBPieceTraitDevis.UpdateDB (false) then result := false;
  END;
  if (Result) and (TOBPIece_O.detail.count > 0 ) then
  BEGIN
  	if not TOBPiece_O.UpdateDB (false) then result := false;
  END;
  if (Result) and (TOBFACTURE_O.detail.count > 0 ) then
  BEGIN
    i := 0;
    repeat
      if TOBFACTURE_O.detail[i].getValue('BLF_MTDEJAFACT')=0 then
      begin
        TOBFACTURE_O.detail[i].DeleteDB  (false);
        TOBFACTURE_O.Detail[i].Free;
      end else inc(I);
    until i >= TOBfacture_O.detail.count;
  	if not TOBFACTURE_O.UpdateDB (false) then result := false;
  END;
  //
  TOBPiece_O.free;
  TOBFacture_O.free;
  TOBPieceTraitDevis.Free;
  //
  if ((TypeFacturation<>'AVA') And (TypeFacturation<>'DAC')) then exit;


  if Result Then
  begin
  	TOBA := TOB.Create('AFFAIRE',nil,-1);
    if TOBPiece.getValue('GP_AFFAIREDEVIS')<> '' then
    begin
      Req := 'SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBPiece.GetValue('GP_AFFAIREDEVIS')+'"';
      QQ := OpenSql (Req,true,-1,'',true);
      if not QQ.eof then
      begin
      	TOBA.SelectDb ('',QQ);
      	TOBA.putValue('AFF_ACOMPTEREND',TOBA.GetValue('AFF_ACOMPTEREND')- TOBPiece.GetValue('GP_ACOMPTEDEV'));
        TOBA.UpdateDB;
        (*
        reste := QQ.findfield ('AFF_ACOMPTEREND').AsFloat;
        Reste := Reste - TOBPiece.GetValue('GP_ACOMPTEDEV');
        Req := 'UPDATE AFFAIRE SET AFF_ACOMPTEREND=';
        if Reste > 0 then Req := REq +StringReplace(StrF00(Reste,V_PGI.OkDecV),',','.',[rfReplaceAll])
                     else Req := REq + '0';
        req := req +' WHERE AFF_AFFAIRE="'+TOBPiece.GetValue('GP_AFFAIREDEVIS')+'"';
        if (ExecuteSQL(req) < 0) then result := false;
        *)
      end;
      QQ.close;
    end;
    TOBA.free;
  end;
  if (Result) and (TOBAcompte.detail.count > 0) then
  begin
    for I := 0 to TOBAcompte.detail.count -1 do
    begin
    	if TOBAcompte.detail[I].GetValue('GAC_PIECEPRECEDENTE')<> '' then
      begin
      	DecodeRefpiece (TOBAcompte.detail[I].GetValue('GAC_PIECEPRECEDENTE'),CD);
        RestitueAcompte(CD,TOBAcompte.detail[I].GetValue('GAC_JALECR'),TOBAcompte.detail[I].GetValue('GAC_NUMECR'),
        								TOBAcompte.detail[I].GetValue('GAC_MONTANTDEV'),TOBAcompte.detail[I].GetValue('GAC_MONTANT'));
      end;
      QQ := OpenSql ('SELECT E_ETATLETTRAGE FROM ECRITURE WHERE '+GetClefecriture(TOBACompte.detail[I]),true,-1,'',true);
      EtatLettrage := QQ.findfield('E_ETATLETTRAGE').AsString;
      ferme (QQ);
      if EtatLettrage = 'TL' then
      BEGIN
        req := 'UPDATE ECRITURE SET E_ETATLETTRAGE="AL" WHERE '+GetClefEcriture (TOBACompte.detail[I]);
        if ExecuteSQL (req) < 0 then result := false;
      END;
    end;
  end;
End;

// Fonction qui vérifie si la facture passée en argument dans la TOB
// est la dernière situation.
Function DerniereSituation(TOBPiece : TOB) : Boolean ;
Var Req: string;
    Num : integer;
    Q : TQuery ;
Begin

result := False;

// récupération numéro de facture de la dernière situation
Req:='SELECT BST_NUMEROFAC FROM BSITUATIONS WHERE BST_NATUREPIECE="'+TOBPiece.GetValue('GP_NATUREPIECEG')+
     '" AND BST_SOUCHE="'+ TOBPiece.GetValue('GP_SOUCHE') +
     '" AND BST_SSAFFAIRE="'+ TOBPiece.GetValue('GP_AFFAIREDEVIS') +
     '" ORDER BY BST_SSAFFAIRE,BST_NUMEROSIT DESC';
Q:=OpenSQL(Req,TRUE,-1,'',true);
if Not Q.EOF then
  begin
  Num := Q.Fields[0].AsInteger;
  if Num = TOBPiece.GetValue('GP_NUMERO') then result:=True;
  end;
Ferme(Q) ;

end;

// Fonction qui vérifie si l'étude provient d'un document EXCEL
Function Origine_EXCEL(TOBPiece : TOB) : Boolean ;
Var Req, RefPiece: string;
    Q : TQuery ;
Begin
result := False;

if TOBPiece.GetValue('GP_NATUREPIECEG') <> VH_GC.AFNatProposition Then Exit;

// récupération Type de document d'origine
RefPiece:=EncodeRefPiece(TOBPiece) ;
Req:='SELECT BDE_TYPE FROM BDETETUDE WHERE BDE_PIECEASSOCIEE="'+RefPiece+'"';
Q:=OpenSQL(Req,TRUE,-1,'',true);
if Not Q.EOF then result:=True;
Ferme(Q) ;

end;

Procedure BtMajSDP(CleDoc : R_CleDoc;EnTOBUniquement : boolean = false);
Var Q : TQuery;
    St : String;
    TOBL : TOB;
    NumOrdre : Integer;
Begin
	if not EnTOBUniquement then
  begin
    //Maj TABLE LIGNE
    Q:=OpenSQL ( 'SELECT GL_ACTIONLIGNE, GL_NUMORDRE FROM LIGNE WHERE '+WherePiece(CleDoc,ttdLigne,True,False),true,-1,'',true);
    if Not Q.EOF then
    begin
      St:=Q.FindField('GL_ACTIONLIGNE').AsString;
      NumOrdre:=Q.FindField('GL_NUMORDRE').AsInteger;
    end else
    begin
      St := '';
      numordre:=0;
    end;
    Ferme(Q);

    if St = 'SDP' then St :=''
    else St := 'SDP';

    ExecuteSQL('UPDATE LIGNE SET GL_ACTIONLIGNE="'+St+'" WHERE '+WherePiece(CleDoc,ttdLigne,True,False)) ;
    TOBL:=TheTOB.FindFirst(['GL_NUMORDRE'],[NumOrdre],False) ;
  end
  else
    begin
    TOBL:=TheTOB.FindFirst(['GL_NUMLIGNE'],[CleDoc.Numligne],False) ;
    end;
  if TOBL<>Nil then
  Begin
  	if TOBL.GetValue('GL_ACTIONLIGNE')='SDP' Then st := '' else st := 'SDP';
    TOBL.PutValue('GL_ACTIONLIGNE',St) ;
    if EnTOBUniquement then
    begin
      if TheImpressionViaTOB <> nil then TheImpressionViaTOB.PreparationEtat;
    End;
  end;
End;

// Fonction appelée depuis l'impression du décisionnel stock
// traitement temporaire en attendant le developpement de la fonctionnalité
Procedure BtMajTenueStock(CleDoc : R_CleDoc);
Var Q : TQuery;
    TenueStock, stArticle, stDepot : String;
    Nb : integer;
    Qte : Double;
Begin
  // Maj TABLE LIGNE : bascule du code tenue en stock
  // et maj du stock disponible
  Q:=OpenSQL ( 'SELECT GL_ARTICLE, GL_DEPOT, GL_TENUESTOCK, GL_QTEFACT FROM LIGNE WHERE '+WherePiece(CleDoc,ttdLigne,True,False),true,-1,'',true);
  if Not Q.EOF then
  begin
    stArticle:=Q.FindField('GL_ARTICLE').AsString;
    stDepot:=Q.FindField('GL_DEPOT').AsString;
    TenueStock:=Q.FindField('GL_TENUESTOCK').AsString;
    Qte:=Q.FindField('GL_QTEFACT').AsFloat;
    if TenueStock = 'X' then
    begin
      TenueStock:='-';
      Qte := Qte * -1.0;
    end else
    begin
      TenueStock:='X';
    end;
    Nb:=ExecuteSQL('UPDATE LIGNE SET GL_TENUESTOCK="'+TenueStock+'" WHERE '+WherePiece(CleDoc,ttdLigne,True,False)) ;
    if Nb>0 then
    begin
      ExecuteSQL('UPDATE DISPO SET GQ_RESERVECLI=GQ_RESERVECLI + "'+
                 StrfPoint(Qte) + '" WHERE ' +
                 'GQ_ARTICLE="' + stArticle + '" AND ' +
                 'GQ_DEPOT="' + stDepot + '" AND ' +
                 'GQ_CLOTURE="-"') ;
    end;
  end;
  Ferme(Q);
End;

function GetMontantFraisDetail (TOBPiece : TOB; Var ExistFg : boolean) : double;
var NatureFrais : string;
		Req : string;
    Q : TQuery;
    cledoc : R_CLEDOC;
begin
  result := 0;
	existFg :=  ExisteFraisChantier (TOBPiece,Cledoc);
  if Existfg then
  begin
  	Req:='SELECT GP_TOTALHTDEV FROM PIECE WHERE '+WherePiece (cledoc,ttdpiece,true) ;
    Q := OpenSql (Req,True,-1,'',true);
    if not Q.eof then result:=Q.Fields[0].AsFloat;
    Ferme (Q);
  end;
end;

function GetTauxFg (TOBporcs : TOB) : double;
var i : integer;
begin
  result:=0;
  for i:=0 to TOBPorcs.Detail.Count-1 do
  BEGIN
    if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') = 'X' then
    Begin
      result := result + TOBPorcs.Detail[i].GetValue('GPT_POURCENT');
    End;
  END;
end;

(*
// fonction retournant le coefficient de FG d'une étude
// avec prise en compte des frais généraux et des frais de chantier
Function CalculMontantRevient (TOBPiece, TOBporcs : TOB; DEV:RDevise;InclusStInFG : boolean; var ExistFG : boolean) : double ;
Var  Revient, TotalAchat, TotalFrais, TauxFrais : double ;
    i : integer ;
    Q : TQuery ;
    Req, NatureFrais : String;
    cledoc : r_cledoc;
BEGIN
result:=1;

// Récupération du total de l'étude des frais
// => lire le document de même numéro pour la nature de frais associée
//modif brl 080604 : NatureFrais:=GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'),'GPP_NATPIECEFRAIS');
TotalFrais := GetMontantFraisDetail (TOBPiece, ExistFg);
if (ExistFg) and (TotalFrais = 0) then
begin
	BTPSupprimePieceFrais (TOBpiece);
  ExistFg := false;
end;



// Calcul du pourcentage total de frais répartis
// => Dans TOBPorcs cumul des pourcentage de frais ayant le code FRAISREPARTIS à TRUE
//    puis calcul du coefficient global que réprésentent ces frais sur le total HT du document
TauxFrais := GetTauxFg (TOBporcs);
ExistFG := (tauxFrais <> 0);

  // Calcul déboursé sec hors sous-traitance :
TotalAchat:=TOBPiece.GetValue('DPA_FG');

if (TotalAchat <> 0) and (TauxFrais < 100) then
   begin
   Revient := (TotalAchat+TotalFrais) * (1+(TauxFrais/100));
//---   METHODE LEVAUX incompréhensible !!!
//   Revient := ((TotalAchat+TotalFrais)*100) / (100-TauxFrais);
//---
   result := Revient/TotalAchat;
//   result := Arrondi(Revient,V_PGI.OkdecP);
   end;

if result=0 then result:=1;

end;
*)

Function BTPSupprimePieceFrais (CleDoc : R_CLEDOC):boolean;
//var Naturefrais : string;
begin
result := false;
(* modif brl 080604 :
NatureFrais:=GetInfoParPiece(cledoc.NaturePiece ,'GPP_NATPIECEFRAIS');
if NatureFrais = '' then exit;
CleDoc.NaturePiece:=NatureFrais;
*)
if cledoc.naturepiece <> 'FRC' then CleDoc.NaturePiece:='FRC';
if ExistePiece (cledoc) then BTPSupprimePiece (cledoc);
end;

Function BTPSupprimePieceFrais (TOBPiece : TOB):boolean;
var cledoc : r_cledoc;
begin
	if TOBPiece.GetValue('GP_PIECEFRAIS') = '' then
  begin
    FillChar(CleDoc, Sizeof(CleDoc), #0);
    CleDoc.NaturePiece := TOBPiece.GetValue('GP_NATUREPIECEG');
    CleDoc.DatePiece := TOBPiece.GetValue('GP_DATEPIECE');
    CleDoc.Souche := TOBPiece.GetValue('GP_SOUCHE');
    CleDoc.NumeroPiece := TOBPiece.GetValue('GP_NUMERO');
    CleDoc.Indice := TOBPiece.GetValue('GP_INDICEG');
    BTPSupprimePieceFrais (cledoc);
  end else
  begin
  	DecodeRefPiece (TOBpiece.getValue('GP_PIECEFRAIS'),cledoc);
		BTPSupprimePieceFrais (cledoc);
	end;

end;

Function BTPSupprimePiece (CleDoc : R_CLEDOC;AvecAdresses:boolean=true):boolean;
var nb : Integer;
		Sql : string;
    AffaireDevis : string;
    QQ : TQuery;
begin
  result := true;
  QQ := OpenSql ('SELECT GP_AFFAIREDEVIS FROM PIECE WHERE '+WherePiece(CleDoc,ttdPiece,False),true,-1,'',true);
  if not QQ.eof then
  begin
  	AffaireDevis :=  QQ.FindField  ('GP_AFFAIREDEVIS').AsString;
    ferme (QQ);
    if AffaireDevis <> '' then
    begin
      Sql := 'DELETE FROM AFFAIRE WHERE AFF_AFFAIRE="'+AffaireDevis+'"';
      nb := ExecuteSQL(Sql);
      if nb < 0 then
      begin
        V_PGI.IoError:=oeunknown ;
        result := false;
        Exit ;
      end;
    end;
  end else
  begin
  	Ferme (QQ);
  end;
  Sql := 'DELETE FROM PIECE WHERE '+WherePiece(CleDoc,ttdPiece,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM LIGNE WHERE '+WherePiece(CleDoc,ttdLigne,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM LIGNECOMPL WHERE '+WherePiece(CleDoc,ttdLigneCompl,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM PIEDBASE WHERE '+WherePiece(CleDoc,ttdPiedBase,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM PIEDECHE WHERE '+WherePiece(CleDoc,ttdEche,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM PIEDPORT WHERE '+WherePiece(CleDoc,ttdPorc,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql:= 'DELETE FROM ACOMPTES WHERE '+WherePiece(CleDoc,ttdAcompte,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  //
  Sql := 'DELETE FROM LIGNEOUVPLAT WHERE '+WherePiece(CleDoc,ttdOuvrageP,False);
  nb := ExecuteSQL(Sql) ;
  //
  Sql := 'DELETE FROM LIGNEOUV WHERE '+WherePiece(CleDoc,ttdOuvrage,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM LIENSOLE WHERE '+WherePiece(CleDoc,ttdLienOle,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM LIGNEPHASES WHERE '+WherePiece(CleDoc,ttdLignePhase,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM PIECERG WHERE '+WherePiece(CleDoc,ttdretenuG,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM PIEDBASERG WHERE '+WherePiece(CleDoc,ttdBaseRG,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  Sql := 'DELETE FROM BSITUATIONS WHERE '+WherePiece(CleDoc,ttdSit,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  //
  Sql := 'DELETE FROM PIECETRAIT WHERE '+WherePiece(CleDoc,ttdPieceTrait,False);
  //
  nb := ExecuteSQL(Sql) ;
  Sql := 'DELETE FROM BTPARDOC WHERE '+WherePiece(CleDoc,ttdParDoc,False);
  nb := ExecuteSQL(Sql) ;
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     Exit ;
     end;
  if AvecAdresses then
     begin
       if GetParamSoc('SO_GCPIECEADRESSE') then
       begin
       	 Sql := 'DELETE FROM PIECEADRESSE WHERE '+WherePiece(CleDoc,ttdPieceAdr,False);
         nb := ExecuteSQL(Sql) ;
         if nb < 0 then
            begin
            V_PGI.IoError:=oeunknown ;
            result := false;
            end;
       end else
       begin
       	 Sql := 'DELETE FROM ADRESSES WHERE '+WherePiece(CleDoc,ttdAdresse,False);
         nb := ExecuteSQL(Sql) ;
         if nb < 0 then
            begin
            V_PGI.IoError:=oeunknown ;
            result := false;
            end;
       end;
     end;
  Sql := 'DELETE FROM BLIENEXCEL WHERE BLX_PIECEASSOCIEE="'+CodeLaPiece(cledoc)+'"';
  nb := ExecuteSQL(Sql);
  if nb < 0 then
     begin
     V_PGI.IoError:=oeunknown ;
     result := false;
     end;
end;

Function Lexical_RechArt ( GS : THGrid ; TitreSel,NaturePieceG,DomainePiece,SelectFourniss : String ) : boolean ;
Var sw,sWhere,CodeArt,StChamps,Libel, Mot : String ;
BEGIN
result := false;
// recup du libellé saisi
CodeArt:=GS.Cells[GS.Col,GS.Row] ;

// recup conditions liées à la nature de pièce
sWhere:='' ;
sW:=FabricWhereNatArt(NaturePieceG,DomainePiece,SelectFourniss) ;
if sw<>'' then sWhere:=sWhere+' AND '+sw ;

// Préparation de la chaine de recherche
// - On remplace les points, les virgules, les tirets et les traits de soulignement par des blancs
// - On remplace ensuite les blancs par des point-virgules
// - On intégre dans la chaine le libellé complet puis tous les mots de plus de 2 lettres
StChamps := CodeArt;
StChamps := StringReplace(StChamps,'.',' ',[rfReplaceAll]); // remplacement des points par des blancs
StChamps := StringReplace(StChamps,',',' ',[rfReplaceAll]); // remplacement des virgules par des blancs
StChamps := StringReplace(StChamps,'-',' ',[rfReplaceAll]); // remplacement des tirets par des blancs
StChamps := StringReplace(StChamps,'_',' ',[rfReplaceAll]); // remplacement des soulignés par des blancs
StChamps := StringReplace(StChamps,' ',';',[rfReplaceAll]); // remplacement des blancs par un point-virgule

Libel:=Trim(CodeArt)+';';
Repeat
      Mot:=ReadTokenSt(StChamps) ;
      if Length(Mot)>3 then Libel:=Libel+Mot+';' ;
Until (StChamps='') ;
Libel := FabricWhereToken(Libel,'GA_LIBELLE');     // Création clause where
Libel := StringReplace(Libel,'="',' LIKE @%',[rfReplaceAll]); // remplacement des blancs par un point-virgule
Libel := StringReplace(Libel,'"','%"',[rfReplaceAll]); // remplacement des blancs par un point-virgule
Libel := StringReplace(Libel,'@','"',[rfReplaceAll]); // remplacement des blancs par un point-virgule
StChamps:='XX_WHERE='+sWhere+';XX_WHERE1= AND '+Libel;

// Lancement de la recherche
CodeArt:=AGLLanceFiche('BTP','BTARTICLE_RECH','','',StChamps);

// traitement du code retour : si le code est à -1 (cas du bouton STOP), on renvoit False
// et on positionne la ligne au nombre maximum de lignes présentes
if CodeArt= '-1' then
   Begin
   Result:=False;
   GS.Row:=GS.RowCount-1;
   Exit;
   End;

if CodeArt<>'' then BEGIN Result:=True ; GS.Cells[SG_RefArt,GS.Row]:=CodeArt ; END ;

END ;

function CodeLaPiece (cledoc : r_cledoc) : string;
var std : string;
begin
StD:=FormatDateTime('ddmmyyyy',Cledoc.DatePiece ) ;
Result:=StD+';'+CleDoc.NaturePiece +';'+cledoc.Souche +';'
          +IntToStr(cledoc.NumeroPiece)+';'+inttostr(cledoc.Indice)+';;'
end;

Procedure ImprimePieceBTP (cledoc : r_cledoc; Bapercu : boolean; Modele, Req ,TypeFacturation : string; DGD : boolean = false; ImpressionViaTOB : TImprPieceViaTOB = nil);
var SQL, SQLOrder : string;
    TableauSituation : String;
    Q : TQuery ;
    UneTOB : TOB;
    TheModele, ModeleR : string;
begin
  application.bringtofront;
  TableauSituation:='-';
//  if Modele=GetParamsoc('SO_BTETATSIT') then
  if ((CleDoc.NaturePiece = 'DAC') or (CleDoc.NaturePiece = 'FBT')) and
    ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
  Begin
    //récupération du code impression tableau totalisation de situation
    SQL:='SELECT BPD_IMPTABTOTSIT FROM BTPARDOC WHERE BPD_NATUREPIECE="'+CleDoc.NaturePiece+'" AND BPD_SOUCHE="'+CleDoc.Souche+'" AND BPD_NUMPIECE='+IntToStr(CleDoc.NumeroPiece) ;
    Q:=OpenSQL(SQL,TRUE,-1,'',true);
    if Not Q.EOF then
      TableauSituation:=Q.Fields[0].AsString
    else
    Begin
      Ferme(Q);
      SQL:='SELECT BPD_IMPTABTOTSIT FROM BTPARDOC WHERE BPD_NATUREPIECE="'+CleDoc.NaturePiece+'" AND BPD_SOUCHE="'+CleDoc.Souche+'" AND BPD_NUMPIECE=0' ;
      Q:=OpenSQL(SQL,TRUE,-1,'',true);
      if Not Q.EOF then TableauSituation:=Q.Fields[0].AsString
                   else TableauSituation:='-';
    End;
    Ferme(Q) ;
  End;

  if TableauSituation = 'X' then
  Begin
    Repeat
      RelancerEtat:=False;
    	StartPdfBatch;
      if (ImpressionViaTOB = nil) OR (not ImpressionViaTOB.Usable) then
      begin
        if LanceEtat('E','GPJ',Modele,True,False,False,Nil,Req,'',False)<0 then V_PGI.IoError:=oeUnknown ;
      end else
      begin
        TheModele:=Modele;
        UneTOB := ImpressionViaTOB.TOBAIMPRIMER;
        if LanceEtatTOB ('E','GPJ',TheModele,UneTOB,Bapercu,false,false,nil,'','',false) < 0 then V_PGI.IoError:=oeUnknown ;
      end;

      if V_PGI.IoError=oeOK then
      Begin
        SQLOrder:='';
        if (ImpressionViaTOB = nil) OR (not ImpressionViaTOB.Usable) then
        begin
          ModeleR:=GetParamsoc('SO_BTETATSIR');
          if ModeleR='' then ModeleR:=Copy(Modele,1,2)+'R';
          SQL:=RecupSQLEtat('E','GPJ',ModeleR,'','','',' WHERE '+WherePiece(CleDoc,ttdPiece,False),SQLOrder) ;
          SQL:=SQL+' '+SQLOrder;
      		LastPdfBatch ;
          LanceEtat('E','GPJ',ModeleR,True,False,False,Nil,Trim(SQL),'',False);
        end else
        begin
        	if DGD then
          begin
          	ModeleR:=GetParamsoc('SO_BTETATDGDRDIR');
          end else
          begin
          	ModeleR:=GetParamsoc('SO_BTETATSIRDIR');
          end;
          if ModeleR='' then ModeleR:=Copy(Modele,1,2)+'R';
          UneTOB := ImpressionViaTOB.TOBRECAP;
    			LastPdfBatch ;
          if LanceEtatTOB ('E','GPJ',ModeleR,UneTOB,Bapercu,false,false,nil,'','',false) < 0 then V_PGI.IoError:=oeUnknown ;
        end;
      end
      else
      Begin
        CancelPDFBatch ;
      end;
      {$IFNDEF EAGLCLIENT}
      // RH le 14/10/2003 ne passe pas à la compile WebAcces
      PreviewPDFFile('',GetMultiPDFPath,True);
      {$ENDIF}
      //PrintPDF (GetMultiPDFPath,'','');
    Until (Not RelancerEtat) or (V_PGI.IoError=oeUnknown);
  End else
  Begin
    Repeat
      RelancerEtat:=False;
      if (ImpressionViaTOB = nil) OR (not ImpressionViaTOB.Usable) then
      begin
        if LanceEtat('E','GPJ',Modele,BApercu,False,False,Nil,Req,'',False) < 0 then V_PGI.IoError:=oeUnknown ;
      end else
      begin
        TheModele:=Modele;
        If TheModele = '' Then TheModele := ImpressionViaTOB.GetModeleAssocie(Modele);
        if TheModele = '' then break;
        UneTOB := ImpressionViaTOB.TOBAIMPRIMER;
        if LanceEtatTOB ('E','GPJ',TheModele,UneTOB,Bapercu,false,false,nil,'','',false) < 0 then
        V_PGI.IoError:=oeUnknown ;
      end;
    Until (Not RelancerEtat) or (V_PGI.IoError=oeUnknown);
  End;
end;

Function GetMiniAvancAcompte (CodessAff : string) : Integer;
var req : string;
    Q : TQuery;
begin
result := 0;
(* POUR PLUS TARD ???
Req:='SELECT AFF_MINAVANCACC FROM AFFAIRE WHERE AFF_AFFAIRE="'+Codessaff+'"' ;
Q:=OpenSQL(Req,TRUE) ;
if Not Q.EOF then result := Q.Fields[0].AsInteger;
Ferme(Q) ;
*)
end;

function ExisteDocAchatLigne (theLigne : String) : boolean;
var Req : string;
begin
    result := false;
    REq := 'SELECT GL_NUMERO FROM LIGNE WHERE GL_PIECEORIGINE="'+TheLigne+'" AND GL_NATUREPIECEG IN ('+GetPieceAchat (true,true,true,true)+')';
    if ExisteSql (req) then result := true;
end;

function ExisteDocumentAchat (TOBpiece : TOB) : boolean;
var Indice : integer;
    TOBL : TOB;
begin
  result := false;
  for Indice := 0 to TOBpiece.detail.count -1 do
  begin
    TOBL := TOBPiece.detail[indice];
    if ExisteDocAchatLigne (EncodeRefPiece(TOBL)) then
    begin
      Result := true;
      exit;
    end;
  end;
end;

function ControleChantierBTP (TOBPiece : TOB; Mode : BTTraitChantier) : boolean;
var Indice : integer;
    Req : String;
    QQ : Tquery;
    MessageRet : string;
    Cledoc : r_cledoc;
    refPiece : string;
begin
  result := true;
  if TOBPIece.GetValue('GP_NATUREPIECEG') = 'BCE' then
  begin
    if Mode = BTTSuppress then
    begin
    	RefPiece := EncodeRefPiece (TOBPiece,0,false);
      RefPiece := Copy(RefPiece,1,length(RefPiece)-1); // pour enlever le ; de fin
      Req := 'SELECT DISTINCT GL_NUMERO FROM LIGNE WHERE GL_NATUREPIECEG IN ("PBT") AND GL_PIECEPRECEDENTE LIKE "'+
      			 RefPiece+'%"';
      QQ := OpenSql (Req,True,-1,'',true);
      TRY
        if not QQ.eof then
        begin
        	Result := false;
					PgiBox (TraduireMemoire('Suppression impossible. Une prévision de chantier existe'),'Suppression de pièce');
          exit;
				end;
      FINALLY
      	ferme (QQ);
      END;
    end;
  end;

  if (GetParamSoc('SO_AFNATAFFAIRE') = TOBPIece.GetValue('GP_NATUREPIECEG')) then
  BEGIN
// controle si chantier terminé
	 if Mode = BTTModif then
   begin
   	if ControleChantiertermineBTP (TOBpiece,TOBPiece.getValue('GP_AFFAIRE'),true,false) then
    begin
    	PgiError ('IMPOSSIBLE : Le chantier est clôturé');
    	result := false;
      exit;
    end;
   end;
// Nouvelle gestion
    Req := 'SELECT AFF_PREPARE FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBPiece.getValue('GP_AFFAIREDEVIS')+'"';
    QQ := OpenSql (Req,true,-1,'',true);
    TRY
      if not QQ.eof then
      begin
        if QQ.FindField ('AFF_PREPARE').AsString = 'X' then
        begin
          Result := false;
          if Mode = BTTSuppress then PgiBox (TraduireMemoire('Suppression impossible. Une prévision de chantier existe'),'Suppression de pièce')
          else if Mode = BTTmodif then PgiBox (TraduireMemoire('La prévision de chantier ou la contre étude existe déjà'),'Création de prévision de chantier')
          else if Mode = BTTContrEtud then PgiBox (TraduireMemoire('La prévision de chantier ou la contre étude existe déjà'),'Génération de contre étude');
          exit;
        end;
      end;
    FINALLY
      Ferme (QQ);
    END;
// verif si devis facture
    if Mode = BTTSuppress then
    begin
    	RefPiece := EncodeRefPiece (TOBPiece,0,false);
      RefPiece := Copy(RefPiece,1,length(RefPiece)-1); // pour enlever le ; de fin
      Req := 'SELECT DISTINCT GL_NUMERO FROM LIGNE WHERE GL_NATUREPIECEG IN ("FBT","DAC","ABT") AND GL_PIECEPRECEDENTE LIKE "'+
      			 RefPiece+'%"';
      QQ := OpenSql (Req,True,-1,'',true);
      TRY
        if not QQ.eof then
        begin
        	Result := false;
					PgiBox (TraduireMemoire('Suppression impossible. Une Facture existe'),'Suppression de pièce');
          exit;
				end;
      FINALLY
      	ferme (QQ);
      END;
    end;
// ---------
  END;

  if (TOBPIece.GetValue('GP_NATUREPIECEG')='CBT') then
  BEGIN
    if ExisteDocumentAchat (TOBpiece) then
    begin
      PgiBox (TraduireMemoire('Suppression impossible. Un document d''achat existe pour cette pièce'),'Suppression de pièce');
      result := false;
    end;
    exit;
  END;
  (* GESTION CONSO *)
  if not ControlePiecePhases (TOBPiece,MessageRet) then
  begin
    PgiBox (TraduireMemoire(MessageRet),'Suppression de pièce');
    result := false;
  end;

end;

procedure ReajusteQteReste (TOBGenere : TOB);
var indice : integer;
    TOBL : TOB;
    CleDoc : R_CLEDOC;
    QQ : Tquery;
    req : string;
begin
  for indice := 0 to TOBgenere.detail.count -1 do
  begin
    TOBL := TOBGenere.detail[indice];
    if TOBL.GetValue('GL_PIECEPRECEDENTE') = '' then continue;
    DecodeRefPiece (TOBL.GetValue('GL_PIECEPRECEDENTE'),Cledoc);
    if ExecuteSql ('UPDATE LIGNE SET GL_QTERESTE=0 WHERE '+wherePiece(cledoc,ttdLigne,true,true)) < 0 then
        V_PGI.IOError := oeUnknown ;
  end;
end;


function ISPrepaLivFromAppro : boolean;
begin
  result := (GetParamSoc ('SO_BTOPTGENREA') = 'GEN');
end;
(*
function ISGenereLivFromAppro : boolean;
begin
  result := (GetParamSoc ('SO_BTOPTLANCEREA') = 'GBL');
end;
*)
function LivraisonVisible : boolean;
begin
  result := GetParamSoc ('SO_BTLIVRVISIBLE');
end;
//
{
procedure ChargeTobPieces (LaTob : TOB;Naturepiece : string);
var Requete : string;
    QQ : Tquery;
begin
  Requete := 'SELECT * FROM PIECE WHERE GP_NATUREPIECEG="'+Naturepiece+'" AND GP_VIVANTE="X"';
  QQ := OpenSql (requete,true);
  if not QQ.eof Then LaTob.LoadDetailDB ('PIECE','','',QQ,false);
  ferme (QQ);
end;
}
procedure GenereLivraisonClients (ThePieceGenere : TOB;Action : TActionFiche;transfoPiece,DuplicPiece: boolean;DemandeDate: boolean = true);
var Livraison : TGenereLivraison;
    indice : integer;
    TOBL : TOB;
begin
	//
	//if (Action <> taModif) or (DuplicPiece = True) or (TransfoPiece = false) then exit;
	if (Action = taModif) and (TransfoPiece = false) and (not DuplicPiece)  then exit;
  //
	// Si c'est pas une reception ou une facture fournisseur ---> Get out
	if Pos(ThePieceGenere.GetValue('GP_NATUREPIECEG'),GetPieceAchat (false,false,false)) = 0 then exit;
  Livraison := TGenereLivraison.create ;
  Livraison.CompteRendu := false; // mode silencieux
  TRY
  	Livraison.ThePieceGenere := ThePieceGenere;
    // Positionnement des infos
    Livraison.Duplication := DuplicPiece;
    Livraison.Transformation := transfoPiece;
    Livraison.Action := Action;
    //
		Livraison.DecortiqueBesoinLivraison;
    Livraison.ChargeTobPieces (Livraison.TOBPieces,'CBT');
    Livraison.datePriseEnCompte := ThePieceGenere.getValue('GP_DATEPIECE');
    if Livraison.TOBPieces.detail.count > 0 then
    begin
      for Indice := 0 to Livraison.TOBPieces.detail.count -1 do
      begin
        TOBL := Livraison.TOBPieces.detail[Indice];
        // FQ 12066
        if TOBL.getValue('GL_INDICENOMEN')<>0 then TOBL.PutValue('GL_INDICENOMEN',0);
        // --
        TOBL.putvalue('GL_PIECEPRECEDENTE',EncodeRefPiece(TOBL));
        TOBL.putvalue('GL_PIECEORIGINE',EncodeRefPiece(TOBL));
        TOBL.addChampSupValeur('ORIGINE',EncodeRefPiece(TOBL,0,false));
        TOBL.addChampSupValeur('REFINTERNE','');
        if TOBL.fieldExists ('GP_REFINTERNE') then
        begin
        	TOBL.PutValue('REFINTERNE',TOBL.GetValue('GP_REFINTERNE'));
        end;
      end;
    end;
		if Livraison.TheLignesALivrer.detail.count > 0 then Livraison.AjusteLesLignes;
    Transactions(Livraison.GenereThepieces,1);

  FINALLY
    Livraison.Free;
  END;
end;

// Chargement de valeurs particulières pour les natures de pièces communes
// avec d'autres applications.
Procedure InitParPieceBTP ;
Var TOBNat : TOB ;
BEGIN
// Pour la nature REAPPROS, on force l'action de fermeture à TRANSFORMATION
TOBNat:=VH_GC.TOBParPiece.FindFirst(['GPP_NATUREPIECEG'],['REA'],False) ;
if TOBNat<>Nil then
  Begin
  TOBNat.PutValue('GPP_ACTIONFINI','TRA') ;
  TOBNat.UpdateDB;
  End;
TOBNat:=VH_GC.TOBParPiece.FindFirst(['GPP_NATUREPIECEG'],['EEX'],False) ;
if TOBNat<>Nil then
  Begin
  TOBNat.PutValue('GPP_LISTESAISIE','BTSAISIEEX') ;
  TOBNat.UpdateDB;
  End;
TOBNat:=VH_GC.TOBParPiece.FindFirst(['GPP_NATUREPIECEG'],['SEX'],False) ;
if TOBNat<>Nil then
  Begin
  TOBNat.PutValue('GPP_LISTESAISIE','BTSAISIEEX') ;
  TOBNat.UpdateDB;
  End;
{
// Pour la nature BL ClIENT, on force le calcul de rupture de stock à STOCK PHYSIQUE
TOBNat:=VH_GC.TOBParPiece.FindFirst(['GPP_NATUREPIECEG'],['BLC'],False) ;
if TOBNat<>Nil then
  Begin
  TOBNat.PutValue('GPP_CALCRUPTURE','PHY') ;
  TOBNat.UpdateDB;
  End;
}
END ;
{ TGenereLivraison }

constructor TGenereLivraison.create;
begin
TOBPieces := TOB.Create ('LES LIGNES',nil,-1);
ThePieces := TOB.Create ('LES LIGNES GENEREES',nil,-1);
TheLignesALivrer := TOB.Create ('LES LIGNES RECEP A LIVRER DIRECTEMENT',nil,-1);
TheAffaires := TOB.create ('LES AFFAIRES',nil,-1);
TOBClients := TOB.Create ('LES TIERS (CLIENTS)',nil,-1);
TOBLivrDirecte := TOB.Create ('LES LIGNES LIVRABLES',nil,-1);
end;

function TGenereLivraison.AddDetail(TOBLD : TOB) : string;
var Indice : integer;
		TOBLDD : TOB;
begin
	result := ' AND (GL_NUMORDRE IN (';
	for Indice := 0 to TOBLD.detail.count -1 do
  begin
  	TOBLDD := TOBLD.detail[Indice];
    if Indice > 0 then result := result + ',';
    result := result +  IntToStr(TOBLDD.GetValue('NUMORDRE'));
  end;
  result := result + '))';
end;

function TGenereLivraison.MakeWhere : string;
var Indice : integer;
		LaChaineWhere : string;
    TOBLD : TOB;
begin
  for Indice := 0 to TOBLivrDirecte.detail.count -1 do
  begin
    TOBLD := TOBLivrDirecte.detail[Indice];
    if Indice = 0 Then
    begin
    LaChaineWhere :='((GL_NATUREPIECEG="'+TOBLD.GEtValue('NATURE')+'") AND '+
                    '(GL_NUMERO="'+InttoStr(TOBLD.GEtValue('NUMERO'))+'") AND '+
                    '(GL_INDICEG="'+IntToStr(TOBLD.GEtValue('INDICE'))+'")'+AddDetail(TOBLD)+')'
    end else
    begin
    LaChaineWhere := LAChaineWhere + 'OR ((GL_NATUREPIECEG="'+TOBLD.GEtValue('NATURE')+'") AND '+
                    '(GL_NUMERO="'+InttoStr(TOBLD.GEtValue('NUMERO'))+'") AND '+
                    '(GL_INDICEG="'+IntToStr(TOBLD.GEtValue('INDICE'))+'")'+addDetail(TOBLD)+')'
    end;
    LaChaineWhere := '('+LaChaineWhere+') ' +
                     'AND GL_QTERESTE <> 0 AND GL_IDENTIFIANTWOL=-1';
  end;
  Result := ' WHERE ' + LaChaineWhere;
end;

procedure TGenereLivraison.ChargeTobPieces (LaTob : TOB;Naturepiece : string);
var Requete : string;
    QQ : Tquery;
begin
	if TOBLivrDirecte.detail.count = 0 then exit;
(* precedemment *)
//  Requete := 'SELECT *,PIE.GP_REFINTERNE,PIE.GP_NUMADRESSEFACT,PIE.GP_NUMADRESSELIVR FROM LIGNE '+
//             'LEFT JOIN PIECE PIE ON (PIE.GP_NATUREPIECEG=GL_NATUREPIECEG) and (PIE.GP_NUMERO=GL_NUMERO)' +
//             ' WHERE GL_NATUREPIECEG="'+Naturepiece+'" AND GL_QTERESTE > 0 AND GL_IDENTIFIANTWOL=-1';
(* maintenant *)
	requete := MakeSelectLigneBtp (true,True) + MakeWhere;
  QQ := OpenSql (requete,true,-1,'',true);
  if not QQ.eof Then LaTob.LoadDetailDB ('LIGNE','','',QQ,false);
  ferme (QQ);
end;

destructor TGenereLivraison.destroy;
begin
  inherited;
  TOBPieces.free;
  ThePieces.free;
	TheLignesALivrer.free;
  TheAffaires.free;
  TOBClients.free;
	TOBLivrDirecte.free;
end;


procedure TGenereLivraison.MiseAjourPieceprec (TOBpiece : TOB);
var Indice : integer;
    TobPrecTraite : TOB;
    TOBL : TOB;
    cledoc : R_CleDoc;
    TOBD : TOB;
begin
  TOBPrecTraite := TOB.create ('LES DOCUMENTS TRAITES',nil,-1);
  TRY
    // Mise à jour des lignes
    for Indice := 0 to TOBpiece.detail.count -1 do
    begin
      TOBL := TOBpiece.detail[Indice];
      DecodeRefPiece (TOBL.GetValue('GL_PIECEPRECEDENTE'),Cledoc);
      TOBD := TOBPrecTraite.findFirst (['GP_NATUREPIECEG','GP_SOUCHE','GP_NUMERO','GP_INDICEG'],
                                  [cledoc.NaturePiece,cledoc.Souche,cledoc.NumeroPiece,cledoc.indice],true);
      if TOBD = nil then
      begin
        TOBD := TOB.create ('PIECE',TobPrecTraite,-1);
        TOBD.putvalue ('GP_NATUREPIECEG',cledoc.Naturepiece);
        TOBD.putvalue ('GP_SOUCHE',cledoc.Souche);
        TOBD.putvalue ('GP_NUMERO',cledoc.NumeroPiece);
        TOBD.putvalue ('GP_INDICEG',cledoc.Indice);
        TOBD.LoadDB (true);
      end;
      //UPdateLignePrec (Cledoc);
    end;

    // mise à jour des pièces
    for Indice := 0 to TOBPrecTraite.detail.count -1 do
    begin
      TOBD := TOBPrecTraite.detail[Indice];
      if not ISAliveLine (TOBD) then
      begin
        TOBD.PutValue('GP_VIVANTE','-');
        TOBD.UpdateDB;
      end;
    end;
  FINALLY
    TOBPrecTraite.free;
  END;
end;


procedure TGenereLivraison.SetInfosClient(TOBL: TOB);
var TOBClient : TOB;
		QQ : TQuery;
    TypeCom,CodeRepres : string;
begin
  TypeCom := GetInfoParPiece('LBT', 'GPP_TYPECOMMERCIAL');
  TOBClient := TOBClients.findFirst(['T_TIERS'],[TOBL.GetValue('GL_TIERS')],true);
  if TOBClient = nil then
  begin
  	TOBClient := TOB.Create ('TIERS',TOBClients,-1);
    QQ := OpenSql ('SELECT T_DEVISE,T_FACTUREHT,T_REGIMETVA,T_COMPTATIERS,T_DOMAINE,T_ZONECOM FROM TIERS WHERE T_TIERS="'+TOBL.GetValue('GL_TIERS')+'" AND T_NATUREAUXI="CLI"',true,-1,'',true);
    if not QQ.eof Then
    begin
      TOBClient.selectDb ('',QQ,true);
    end;
    ferme (QQ);
  end;
//  TOBL.PutValue('GP_MODEREGLE',TOBClient.GetValue('T_MODEREGLE'));
  TOBL.PutValue('GL_REGIMETAXE', TOBClient.GetValue('T_REGIMETVA'));
  if TOBClient.FieldExists('T_REPRESENTANT') then CodeRepres := TOBClient.GetValue('T_REPRESENTANT') else CodeRepres := '';
  TOBL.PutValue('GL_REPRESENTANT', CodeRepres);
end;

procedure TGenereLivraison.DecortiqueBesoinLivraison;
var Indice,NbDoc : integer;
		TOBL,TheLigneAlivrer : TOB;
    PieceOrigine,PieceCde,PiecePrecedente : string;
    Cledoc,CledocPrec : R_Cledoc;
begin
	// Initialisations
  TOBLivrDirecte.ClearDetail;
  NbDoc := 0;
	TheLignesALivrer.ClearDetail;
  PieceCde := GetNaturePieceCde(false);
  // --
  For indice := 0 to ThePieceGenere.detail.count -1 do
  begin
    TOBL := ThePieceGenere.detail[Indice];
    
    if TOBL.GetValue('GL_TYPELIGNE') <> 'ART' Then Continue;
    if TOBL.GetValue('GL_ARTICLE')='' Then Continue;

    PieceOrigine := TOBL.GetValue ('GL_PIECEORIGINE');
    PiecePrecedente := TOBL.GetValue ('GL_PIECEPRECEDENTE');
    if Pieceprecedente <> '' then
    begin
    	DecodeRefPiece (PiecePrecedente,cledocPrec);
    end;
    // si transformation d'une réception en facture fournisseur alors on degage
    {
    if (Pos(CledocPrec.NaturePiece ,GetPieceAchat (false,false,false,false)) > 0) and (Not Duplication)  then continue;
    If DejaLivre (PiecePrecedente) then continue; // si la piece precedente est deja livré on ne continue pas
    }
    if (Pos(CledocPrec.NaturePiece ,GetPieceAchat (false,false,false,true)) > 0) and
    	 (Not Duplication) and
       DejaLivre (PiecePrecedente) then continue; // si la piece precedente est deja livré on ne continue pas
    // --
    if PieceOrigine <> '' then
    begin
    	DecodeRefPiece (PieceOrigine,cledoc);
    end;
    if (TOBL.GetValue('GL_AFFAIRE') <> '') AND
    	 ((PieceOrigine='') or (IsSamePieceOrFromAchat(TOBL))) AND
    	 (TOBL.GetValue('GL_IDENTIFIANTWOL')=-1) then
    begin
    	// provenance des achats et livraison sur chantier par fourniseur
      if TOBL.GEtValue('GL_QTEFACT') <> 0 then
      begin
        TheLigneALivrer := TOB.Create ('LIGNE',TheLignesALivrer,-1);
        TheLigneALivrer.Dupliquer (TOBL,false,true); // on mémorise la ligne
        TransformeAchatEnVente (TheLigneALivrer);
      end;
    end else if ((PieceOrigine<>'') and
    				 		(Pos(Cledoc.NaturePiece ,PieceCde)>0)) then
    begin
(*
      if NbDOc = 0 then
      BEGIN
      	LesNumPieces := '"'+inttoStr(Cledoc.NumeroPiece))+'"';
        Inc(NbDoc);
      END else LesNumPieces := LesNumPieces + ',"'+InttoStr(Cledoc.NumeroPiece)+'"';
*)
			if TOBL.GetValue('GL_QTEFACT') <> 0 then
      begin
				AddLivraisonDirecte (cledoc);
      end;
    end;
  end;
end;

function IsSamePieceOrFromAchat(TOBL: TOB): boolean;
var cledoc : R_CLEDOC;
begin
	result := false;
	if TOBL.GetValue('GL_PIECEORIGINE') = '' then Exit;
  //
  DecodeRefPiece (TOBL.GetValue('GL_PIECEORIGINE'),Cledoc);
  if ((Cledoc.NaturePiece = TOBL.GetValue('GL_NATUREPIECEG')) and
  	 (Cledoc.Souche = TOBL.GetValue('GL_SOUCHE')) and
     (Cledoc.NumeroPiece = TOBL.GetValue('GL_NUMERO')) and
     (Cledoc.Indice = TOBL.GetValue('GL_INDICEG'))) OR
     ( Pos(CleDoc.NaturePiece,GetNaturePieceCde(false)) = 0 ) then result := true;
end;

procedure TGenereLivraison.SetInfosLivraison(TOBL : TOB);
var Affaire : string;
		TobA : TOB;
    QQ : TQuery;
    OldDevise : string;
    OldTauxDevise : double;
begin
	Affaire := TOBL.GetValue('GL_AFFAIRE');
  TOBA := TheAffaires.FindFirst (['AFF_AFFAIRE'],[Affaire],True)  ;
  if TOBA = nil then
  begin
    TOBA := TOB.Create ('AFFAIRE',TheAffaires,-1);
    QQ := OpenSql ('SELECT AFF_AFFAIRE,AFF_TIERS FROM AFFAIRE WHERE AFF_AFFAIRE="'+affaire+'"',True,-1,'',true);
    if not QQ.eof then
    begin
      TOBA.SelectDb ('',QQ,true);
    end;
    Ferme (QQ);
  end;
  TOBL.PutValue('GL_PIECEORIGINE',EncodeRefPiece (TOBL));
  TOBL.PutValue('GL_PIECEPRECEDENTE','');
  TOBL.PutValue ('GL_TIERS',TOBA.GetValue('AFF_TIERS'));
  OldDevise := TOBL.GetValue('GL_DEVISE');
  OldTauxDevise := TOBL.GetValue('GL_TAUXDEV');
  SetInfosClient (TOBL);
end;

procedure TGenereLivraison.AjusteLesLignes;
var TOBL : TOB;
		Indice : integer;
begin
	for indice := 0 to TheLignesALivrer.detail.count -1 do
  begin
  	TOBL := TheLignesALivrer.detail[Indice];
    SetInfosLivraison(TOBL);
  end;
end;

procedure TGenereLivraison.GenereThepieces;
var Indice : integer;
    TOBpiece : TOB;
begin
	if TOBPieces.detail.count > 0 then
  begin
  	CreerPiecesFromLignes(TobPieces,'CBTTOLIVC',DatePriseEnCompte,True,false,ThePieces);
  end;
  if (TheLignesALivrer.detail.count > 0) and (V_PGI.IOError = OeOk) then
  begin
  	CreerPiecesFromLignes(TheLignesALivrer,'RFOTOLIVC',DatePriseEnCompte, True,false,ThePieces);
  end;
end;

function ISAliveLine (TOBpiece : TOB) : boolean;
var Requete : String;
    QQ : TQuery;
    cledoc : R_cledoc;
begin
  result := false;
  cledoc := TOB2CleDoc (TOBPiece);
  Requete := 'SELECT GL_NUMERO FROM LIGNE WHERE '+WherePiece (Cledoc,ttdLigne,false) +
             ' AND GL_VIVANTE="X" AND GL_QTERESTE <> 0 AND GL_TYPELIGNE="ART"';
  QQ := OpenSql (requete,true,-1,'',true);
  if not QQ.eof then result := true;
  ferme (QQ);
end;

procedure InitCalcDispo;
begin
	TOBDispoLoc := TOB.Create ('LES STOCKS',nil,-1);
	FromDispoGlob := true;
end;

procedure InitCalcDispoArticle;
begin
	FromDispoArt := true;
end;

procedure FinCalcDispo;
begin
	if TOBDispoLoc <> nil then
  begin
  	TOBDispoLoc.free;
  	TOBDispoLoc := nil;
  end;
	FromDispoGlob := false;
	FromDispoArt := false;
end;

procedure AddChampsSupDispoAff (TOBDEPOT : TOB);
begin
	TOBDepot.AddChampSupValeur  ('_LIVRE',0,false);
end;

Function GetQtelivrable (TOBL : TOB;gestionConso : TGestionPhase; TOBART : TOB = nil; PriseSurStock : boolean=true) : double;
var QTeRecep,QTeDejaLivre,QteLivrable,QteDispo,QteResteAlivrer,QTe,QteTemp : double;
    requete,Moderecep : string;
    QQ : TQuery;
    TOBDepot,TOBA,TOBDR,TOBR,TOBLS : TOB;
    TypeArticle : string;
    RefOrigine : string;
    Created : boolean;
    FUA,FUS,FUV : double;
    MTAchat,PUA,CoefPAPR : double;
    NumMouv : double;
    QteRecepFour,QTeDejaLivrCli : double;
    Indice : integer;
    UneLoc : TOB;
begin
  Created := false;
  PUA := 0;
  UneLoc := nil;
  if TOBL.getValue('GL_DPA') <> 0 then
    CoefPAPR := TOBL.getValue('GL_DPR')/TOBL.getValue('GL_DPA')
  else
    CoefPAPR := 0;
  if TOBART <> nil then
  begin
    TOBA := TOBART;
  end else
  begin
    TOBA := TOB.Create ('ARTICLE',nil,-1);
    TOBA.PutVAlue('GA_ARTICLE',TOBL.GetValue('GL_ARTICLE'));
    TOBA.LoadDB;
    Created := true;
  end;
  result := 0;
  if TOBL.GetValue('GL_TYPELIGNE') <> 'ART' then Exit;
  TypeArticle := TOBL.GetValue('GL_TYPEARTICLE');
  if (TypeArticle = 'PRE') and (IsPrestationInterne(TOBL.GetValue('GL_ARTICLE'))) then
  begin
    Result := TOBL.GetValue('GL_QTERESTE'); // pour l'instant
    exit;
  end;
  //
  refOrigine := TOBL.GetValue('GL_PIECEPRECEDENTE');
  if RefOrigine = '' then exit;
  TOBR := TOB.Create ('LES LIGNES',nil,-1);
  // initialisation
  QteResteAlivrer := 0;
  QTeRecep := 0;
  QTeDejaLivre := 0;
  QteLivrable := 0;
  QteDispo := 0;
  MtAchat := 0;
  //
  FUV := RatioMesure('PIE', TOBL.GetValue('GL_QUALIFQTEVTE'));
  if FUV = 0 then FUV := 1;
  FUS := RatioMesure('PIE', TOBL.GetValue('GL_QUALIFQTESTO'));
  if FUS = 0 then FUS := 1;
  // calcule les quantités réceptionnées des fourniseurs
  requete := 'SELECT GL_NATUREPIECEG,GL_DATEPIECE,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE,GL_NUMORDRE,'+
  					 'GL_QTESTOCK AS QTERECEP,GL_PIECEPRECEDENTE'+
             ',(GL_QTESTOCK*GL_PUHTNET) AS MTACHAT, GL_QUALIFQTEACH,GL_COEFCONVQTE,'+
             'BCO_NUMMOUV,BCO_INDICE,BCO_QUANTITE,BCO_QTEVENTE,BCO_TRANSFORME,BCO_TRAITEVENTE '+
             'FROM LIGNE '+
             'LEFT JOIN CONSOMMATIONS ON '+
             '(BCO_NATUREPIECEG=GL_NATUREPIECEG) AND (BCO_SOUCHE=GL_SOUCHE) AND (BCO_NUMERO=GL_NUMERO) '+
             'AND (BCO_NUMORDRE=GL_NUMORDRE) '+
             'WHERE GL_PIECEORIGINE="'+RefOrigine+ '" '+
             'AND GL_NATUREPIECEG IN ('+GetPieceAchat+') '+
             {AND GL_VIVANTE="X" AND BCO_TRAITEVENTE<>"X"}
             'AND BCO_TRANSFORME<>"X"';
  QQ := OpenSql (requete,true,-1,'',true);
  TRY
    if not QQ.eof then
    begin
    	TOBR.loadDetailDb ('LIGNE','','',QQ,false);
      For Indice := 0 to TOBR.detail.count -1 do
      begin
      	TOBDR := TOBR.detail[Indice];
        NumMouv := TOBDR.GetValue('BCO_NUMMOUV');
        if NumMouv <> 0 then
        begin
          QteRecepFour := TOBDR.GetValue('BCO_QUANTITE');
//          QTeDejaLivrCli := TOBDR.GetValue('BCO_QTEVENTE');
          if TOBDR.GetValue('BCO_TRAITEVENTE') <> 'X' then GestionConso.MemoriseLienReception (TOBL,TOBDR);
        end;
        Qte := TOBDR.GetValue('QTERECEP');
        FUA := RatioMesure('PIE', TOBDR.GetValue('GL_QUALIFQTEACH'));
        if TOBDR.getValue('GL_COEFCONVQTE') <> 0 then
        begin
        	Qterecep := QteRecep + (Qte * TOBDR.getValue('GL_COEFCONVQTE'));
        end else
        begin
        	Qterecep := QteRecep + (Qte * FUA / FUV);
        end;
        MtAchat := MtAchat + TOBDR.GetValue('MTACHAT');
      end;
    end;
  FINALLY
    Ferme (QQ);
  END;
  //
  (*
  if (TOBL.getValue('GL_TENUESTOCK') = '-') then ModeRecep := 'X' else ModeRecep := '-';
  // deja livre depuis le stock
  requete := 'SELECT GL_QTEFACT,(GL_QTEFACT*GL_DPA) AS MTACHAT '+
             'FROM LIGNE WHERE GL_PIECEORIGINE="'+RefOrigine+ '" '+
             'AND GL_NATUREPIECEG ="LBT" AND GL_TENUESTOCK="'+Moderecep+'"';
  QQ := OpenSql (requete,true,-1,'',true);
  //
  TOBLS := TOB.Create ('LES LIGNES',nil,-1);
  if not QQ.eof then
  begin
    TOBLS.loadDetailDb ('LIGNE','','',QQ,false);
    For Indice := 0 to TOBLS.detail.count -1 do
    begin
      Qterecep := QteRecep + TOBLS.detail[Indice].getValue('GL_QTEFACT');
      MtAchat := MtAchat + TOBLS.detail[Indice].GetValue('MTACHAT');
    end;
  end;
  ferme (QQ);
  TOBLS.free;
  //
  *)
  if QteRecep > 0 then PUA := Arrondi(MtAchat / QteRecep,V_PGI.okdecP);
  QteDejaLivre := TOBL.GetValue('GL_QTESTOCK')-TOBL.GetValue('GL_QTERESTE');
  QteResteAlivrer := TOBL.GetValue('GL_QTERESTE');
  (*
  QteTemp := Abs(QteRecep) - (QteDejaLivre);
  if QTeTemp <= 0 then QteLivrable := 0
  								else QteLivrable := QteRecep - QteDejaLivre;
  *)
  if QteRecep > QteResteAlivrer then QteLivrable := QteResteAlivrer
  															else QteLivrable := QteRecep;
//  if QTeLivrable < 0 then QTeLivrable := 0;
  // Controle sur le stock
  if (TOBL.getValue('GL_TENUESTOCK') = 'X') and (PriseSurStock) then
  begin
    if (QteResteAlivrer > QteLivrable) then QteLivrable :=QteResteALivrer;

    if FromDispoGlob then
    begin
      TOBDEPOT := TOBDispoLoc.findFirst(['GQ_ARTICLE','GQ_DEPOT'],[TOBL.GetValue('GL_ARTICLE'),TOBL.GetValue('GL_DEPOT')],true);
    end else if FromDispoArt then
    begin
      TOBDEPOT := TOBA.findFirst(['GQ_ARTICLE','GQ_DEPOT'],[TOBL.GetValue('GL_ARTICLE'),TOBL.GetValue('GL_DEPOT')],true);
    end;

    if TOBDepot = nil then
    begin
    	if FromDispoGlob then
      begin
      	TOBDEpot := TOB.create ('DISPO',TOBDispoLoc,-1);
      end else if FromDispoArt then
      begin
      	TOBDEpot := TOB.create ('DISPO',TOBART,-1);
      end else
      begin
				TOBDEpot := TOB.create ('DISPO',nil,-1);
      end;
      Requete := 'SELECT * FROM DISPO WHERE GQ_ARTICLE="'+TOBL.GetValue('GL_ARTICLE')+'" AND '+
                  'GQ_CLOTURE="-" AND GQ_DEPOT="'+ TOBL.GetValue('GL_DEPOT')+'"';
      QQ := OpenSql (Requete,true,-1,'',true);
      TOBDepot.SelectDB ('',QQ);
      AddChampsSupDispoAff (TOBDEPOT);
      ferme (QQ);
    end;
    if not TOBDepot.fieldExists('_LIVRE') then AddChampsSupDispoAff (TOBDepot);
    QteDispo := TOBDepot.GetValue('GQ_PHYSIQUE') - TOBDepot.GetValue('_LIVRE') -
                TOBDepot.GetValue('GQ_PREPACLI') ;
    QteDispo := (QteDispo * FUS / FUV);// + QteResteALivrer;
    if QteDispo < 0 then QteDispo := 0;
    // Passage US - UV
    if (QteLivrable > QteDispo) then QteLivrable := QteDispo;
    PUA := TOBdepot.GetValue('GQ_PMAP');
    if (not FromDispoGlob) and (not FromDispoArt) then
    begin
    	TOBDepot.free;
      TOBDepot := nil;
    end;
  end;
  if (QteLivrable <> 0 ) and (PUA > 0) then
  begin
    // on peut livrer a concurence de QTeLivrable
    if not (TOBL.FieldExists ('DPARECUPFROMRECEP')) then TOBL.AddChampSup('DPARECUPFROMRECEP',false);
    TOBL.PutValue('DPARECUPFROMRECEP',PUA);
    if (TOBdepot <> nil) and ((FromDispoGlob) or (FromDispoArt))  then
    begin
    	TOBDepot.putValue('_LIVRE', TOBDepot.GetValue('_LIVRE')+ (QteLivrable * FUV / FUS));
    end;
  end;
  Result := QteLivrable;
  TOBR.free;
  if Created then TOBA.free;
end;

Function GetQtelivrableHlien (TOBL : TOB;gestionConso : TGestionPhase; TOBART : TOB = nil) : double;
begin
	result := gestionConso.GetQteLivrable (TOBL,True);
end;

function NaturepieceOKPourOuvrage (TOBPiece : TOB) : boolean;
var Naturepiece,Prefixe : string;
begin
  result := false;

  if TOBPiece.NomTable = 'PIECE' Then Prefixe := 'GP'
  else if TOBPiece.NomTable = 'LIGNE' Then Prefixe := 'GL'
  else exit;

  // MODIF FV Pour facturation des appels (articles en prix posés)
  //if copy(TOBPiece.getValue(prefixe+'_AFFAIRE'),1,1)='W' then exit;
  //
  
  Naturepiece := TOBPiece.GetValue (prefixe+'_NATUREPIECEG');
  if (Naturepiece = 'DBT') or (Naturepiece = 'FBT') or
     (Naturepiece = 'AFF') or (Naturepiece = 'FAC') or
     (Naturepiece = 'ETU') or (Naturepiece = 'DAC') or
     (Naturepiece = 'BCE') or (Naturepiece = 'AVC') or
     (Naturepiece = GetParamSoc('SO_BTNATBORDEREAUX')) or
     (Naturepiece = 'ABT') or (Naturepiece = 'FRC') or
     (Naturepiece = 'DAP') or (Naturepiece = 'FPR') then Result := true;
end;

function IsPrestationInterne(Article : String) : boolean;
var TheType : string;
    Q : Tquery;
begin
  result := false;
  Q := OpenSql ('SELECT BNP_TYPERESSOURCE FROM NATUREPREST WHERE BNP_NATUREPRES = (SELECT GA_NATUREPRES FROM ARTICLE WHERE GA_ARTICLE="'+Article+'")',true,-1,'',true);
  TRY
    if not Q.eof then
    begin
      TheType := trim(Q.FindField('BNP_TYPERESSOURCE').AsString);
      if (TheType = 'SAL') or (TheType = 'MAT') then result := true;
    end;
  FINALLY
    ferme (Q);
  END;
end;

function TiersModifiableInDocument(TOBPiece : TOB) : Boolean;
var NaturePiece : string;
begin
  result := false;
  NaturePiece := TOBPiece.GetValue('GP_NATUREPIECEG');
  if Pos (NaturePiece,'DBT;ETU;CF;') = 0 then exit;
  { Ancienne gestion


  if TOBPiece.GetValue('GP_NATUREPIECEG') <> 'DBT' then exit;

  if TOBPiece.GetValue('GP_NATUREPIECEG') <> 'DAP' then exit;
  }

//if TOBPiece.GetValue('GP_AFFAIRE') <> '' then exit;
  if NaturePiece = 'DBT' then
  begin
    result := ((GetEtatAffaire(TOBPiece.getValue('GP_AFFAIREDEVIS')) = 'ENC') or
              (TOBPiece.getValue('ISDEJAFACT') = '-'));
  end else if NaturePiece = 'ETU' then
  begin
    result := (GetEtatAffaire(TOBPiece.getValue('GP_AFFAIREDEVIS')) = 'ENC');
  end else if NaturePiece = 'CF' then
  begin
    result := (TOBPiece.getValue('GP_DEVENIRPIECE') = '');
  end;
end;

function IsRetourFournisseur (TObpiece : TOB) : boolean;
var Prefixe : string;
begin
	result := false;
  if TOBPiece.NomTable = 'PIECE' Then
  begin
  	Prefixe := 'GP';
  end else if TOBPiece.NomTable = 'LIGNE' Then
  begin
  	Prefixe := 'GL';
  end else Exit;
  if TOBPIece.getValue(Prefixe+'_NATUREPIECEG')='BFA' Then Result := true;
end;

function IsRetourClient(TOBPiece : TOB) : Boolean;
var Prefixe : string;
begin
	result := false;
  if TOBPiece.NomTable = 'PIECE' Then
  begin
  	Prefixe := 'GP';
  end else if TOBPiece.NomTable = 'LIGNE' Then
  begin
  	Prefixe := 'GL';
  end else Exit;
  if TOBPIece.getValue(Prefixe+'_NATUREPIECEG')='BFC' Then Result := true;
end;

function ControleDateDocument ( StD : String ; Naturepiece : string) : integer ;
Var DD  : TDateTime ;
BEGIN
Result:=0 ;
if Not IsValidDate(StD) then BEGIN Result:=1 ; Exit ; END ;
{$IFDEF CONSOCERIC}
Exit ;
{$ENDIF}
DD:=StrToDate(StD) ;
(* Ajout LS *)
if GetInfoParPiece(Naturepiece,'GPP_TYPEECRCPTA') = 'RIE' then Exit;
(* --------- *)
if DD<VH^.Encours.Deb then BEGIN Result:=2 ; Exit ; END ;
if ((VH^.Suivant.Fin>0) and (DD>VH^.Suivant.Fin)) then BEGIN Result:=2 ; Exit ; END ;
if ((VH^.Suivant.Fin=0) and (DD>VH^.Encours.Fin)) then BEGIN Result:=2 ; Exit ; END ;
if ((VH^.DateCloturePer>0) and (DD<=VH^.DateCloturePer)) then BEGIN Result:=3 ; Exit ; END ;
{$IFNDEF GCGC}
if ((VH^.NbjEcrAv>0) and (DD<V_PGI.DateEntree) and (V_PGI.DateEntree-DD>VH^.NbjEcrAv)) then BEGIN Result:=5 ; Exit ; END ;
if ((VH^.NbjEcrAp>0) and (DD>V_PGI.DateEntree) and (DD-V_PGI.DateEntree>VH^.NbjEcrAp)) then BEGIN Result:=5 ; Exit ; END ;
{$ENDIF}
END ;

function GetCodeBQ (TOBBanqueCP : TOB; CodeAuxiliaire: String; NumeroRIB : Integer) : boolean;
var Req : string;
		QQ : TQuery;
begin
	result := false;
  Req := 'SELECT R_DOMICILIATION,R_ETABBQ,R_GUICHET,R_NUMEROCOMPTE,R_CLERIB FROM RIB WHERE ' +
         'R_AUXILIAIRE="' + CodeAuxiliaire + '"' +
         'R_NUMERORIB='+ IntToStr(NumeroRIB);
  QQ := OpenSql(Req,True,-1,'',true);
  if not QQ.eof then
  begin
  	TOBBanqueCP.SelectDB ('',QQ,true);
    result := true;
  end;
  ferme (QQ);
end;

function GetCodeBQ (Auxiliaire : String; NumeroRIB : Integer; var RefBancaire : string) : boolean;
var Req : string;
		QQ : TQuery;
begin
	result := false;
  Req := 'SELECT R_DOMICILIATION FROM RIB WHERE ' +
         'R_AUXILIAIRE="'+ Auxiliaire + '"  AND ' +
         'R_NUMERORIB='  + IntToStr(NumeroRIB);
  QQ := OpenSql(Req,True,1,'',true);
  if not QQ.eof then
  begin
    RefBancaire := (QQ.FindField('R_DOMICILIATION').AsString);
    result := true;
  end;
  ferme (QQ);

end;

function GetContact (TOBContact : TOB;LeTiers : string;NumeroContact : integer) : boolean;
var Req : string;
		QQ : TQuery;
begin
	result := false;
  Req := 'SELECT C_CIVILITE,C_NOM,C_PRENOM,C_TELEPHONE,C_RVA FROM CONTACT WHERE C_TYPECONTACT="T" AND '+
         'C_AUXILIAIRE="'+TiersAuxiliaire(LeTiers)+'" AND C_NUMEROCONTACT='+inttoStr(NumeroContact);
  QQ := OpenSql(Req,True,-1,'',true);
  if not QQ.eof then
  begin
  	TOBCOntact.SelectDB ('',QQ,true);
    result := true;
  end;
  ferme (QQ);
end;

function GetContact (LeTiers : string;NumeroContact : integer; var libcontact : string) : boolean;
var Req : string;
		QQ : TQuery;
begin
	result := false;
  Req := 'SELECT C_NOM FROM CONTACT WHERE C_TYPECONTACT="T" AND '+
         'C_AUXILIAIRE="'+TiersAuxiliaire(LeTiers)+'" AND C_NUMEROCONTACT='+inttoStr(NumeroContact);
  QQ := OpenSql(Req,True,1,'',true);
  if not QQ.eof then
  begin
    libcontact := (QQ.FindField('C_NOM').AsString);
    result := true;
  end;
  ferme (QQ);
end;

procedure TGenereLivraison.AddLivraisonDirecte(cledoc: r_cledoc);
var TOBLD,TOBLDD : TOB;
begin
	TOBLD := TOBLivrDirecte.findFirst (['NATURE','NUMERO','INDICE'],[Cledoc.NaturePiece,Cledoc.NumeroPiece,Cledoc.Indice],true);
  if TOBLD = nil then
  begin
  	TOBLD := TOB.create ('__LIVREE ',TOBLivrDirecte,-1);
    TOBLD.AddChampSupValeur ('NATURE',Cledoc.NaturePiece);
    TOBLD.AddChampSupValeur ('NUMERO',Cledoc.NumeroPiece);
    TOBLD.AddChampSupValeur ('INDICE',Cledoc.Indice);
  end;
  TOBLDD := TOB.create ('__DETAIL ',TOBLD,-1);
  TOBLDD.AddChampSupValeur ('NUMORDRE',Cledoc.Numordre);
end;

procedure MajQtesAvantSaisie (TobPiece : TOB);
Var ind : integer;
		QteSitRest : double;
    TOBL : TOB;
    Cledoc : R_CLEDOC;
    LastPrec,CurrPiece : string;
begin
   for ind := 0 to TOBpiece.detail.count -1 do
   begin
     if TOBPiece.detail[Ind].getValue('GL_TYPELIGNE')= 'ART' then
     begin
     	 TOBPiece.detail[Ind].putValue('OLD_QTESIT',TOBPiece.detail[Ind].GetValue('GL_QTESIT'));
     	 QteSitRest := Abs(TOBPiece.detail[Ind].GetValue('GL_QTESIT')) - Abs(TOBPiece.detail[Ind].GetValue('GL_QTEFACT'));
       if QteSitRest > 0 then
       begin
         TOBPiece.detail[Ind].PutValue('GL_QTESIT',TOBPiece.detail[Ind].GetValue('GL_QTESIT') -
                                                   TOBPiece.detail[Ind].GetValue('GL_QTEFACT'));
       end else
       begin
       	 TOBPiece.detail[Ind].PutValue('GL_QTESIT',0);
       end;
     end else
     begin
       TOBPiece.detail[Ind].PutValue('GL_QTESIT',0);
       TOBPiece.detail[Ind].PutValue('GL_QTEPREVAVANC',0);
       TOBPiece.detail[Ind].PutValue('GL_POURCENTAVANC',0);
     end;
   end;
end;

procedure DefiniDejaFacture (TOBPiece : TOB;DEV : rdevise);

Var ind : integer;
		QteSitRest : double;
    TOBL : TOB;
    lastprec,CurrPiece : string;
    Cledoc : R_CLEDOC;
begin
  for ind := 0 to TOBpiece.detail.count -1 do
  begin
    if TOBPiece.detail[Ind].getValue('GL_TYPELIGNE')= 'ART' then
    begin
      TOBL := TOBPiece.detail[Ind];
      // Ancienne gestion (pour rester compatible)
      TOBL.putValue('OLD_QTESIT',TOBL.GetValue('GL_QTESIT'));
(*    MODIF BRL 2/08/2011 FQ 15631
      QteSitRest := Abs(TOBL.GetValue('GL_QTESIT')) - abs(TOBL.GetValue('GL_QTEFACT'));
      if QteSitRest > 0 then
      begin
        TOBL.putValue('DEJAFACT',TOBL.GetValue('GL_QTESIT')-TOBL.GetValue('GL_QTEFACT'));
      end else
      begin
        TOBL.putValue('DEJAFACT',0);
      end;
*)
      TOBL.putValue('DEJAFACT',TOBL.GetValue('GL_QTESIT')-TOBL.GetValue('GL_QTEFACT'));
      // -------
      if TOBL.getValue('BLF_NATUREPIECEG')=''  then
      begin
        if TOBL.GetValue('GL_QTEPREVAVANC')<>0 then
        begin
          // gestion des anciennes facturations
          PositionneAncienneFacturation(TOBL,DEV);
        end else
        begin
          InitMontantfacturation(TOBL);
        end;
      end;
    end;
 end;
end;

function TGenereLivraison.DejaLivre(Piece: string): boolean;
var Cledoc : R_CLEDOC;
		REQUETE : String;
    QQ : TQuery;
begin
	result := false;
  if Piece = '' then exit;
	DecodeRefPiece (Piece,cledoc);
  Requete := 'SELECT BCO_LIENVENTE FROM CONSOMMATIONS WHERE BCO_NUMMOUV = (SELECT BLP_NUMMOUV FROM LIGNEPHASES WHERE'+
  					 ' BLP_NATUREPIECEG="'+Cledoc.NaturePiece+'"'+
             ' AND BLP_SOUCHE="'+Cledoc.Souche+'" AND BLP_NUMERO='+inttoStr(Cledoc.NumeroPiece)+
             ' AND BLP_NUMORDRE='+IntToStr(cledoc.NumOrdre)+') AND BCO_LIENVENTE <> 0';
  QQ := OpenSql (Requete,True,-1,'',true);
  result := not QQ.eof;
  ferme (QQ);
end;
function IsContreEtude (TOBpiece : TOB) : boolean;
begin
	result := false;
	if TOBPIece.NomTable = 'PIECE' then result := (TOBPiece.getValue('GP_NATUREPIECEG')='BCE')
  else if TOBPIece.NomTable = 'LIGNE' then result := (TOBPiece.getValue('GL_NATUREPIECEG')='BCE')
  else if TOBPIece.NomTable = 'LIGNEOUV' then result := (TOBPiece.getValue('BLO_NATUREPIECEG')='BCE');
end;

function IsPrevisionChantier (TOBpiece : TOB) : boolean;
begin
	result := false;
	if TOBPIece.NomTable = 'PIECE' then result := (TOBPiece.getValue('GP_NATUREPIECEG')='PBT')
  else if TOBPIece.NomTable = 'LIGNE' then result := (TOBPiece.getValue('GL_NATUREPIECEG')='PBT')
  else if TOBPIece.NomTable = 'LIGNEOUV' then result := (TOBPiece.getValue('BLO_NATUREPIECEG')='PBT');
end;

function GetNumCompteur (Souche : string; var TheNumero : integer) : boolean;
var TheNumPrec : integer;
		QQ : TQuery;
    requete : string;
    CptArret : integer;
    MajOk : boolean;
begin
	result := true;
  CptArret := 1;
  MajOk := false;
	QQ := OpenSQL('SELECT SH_NUMDEPART FROM SOUCHE WHERE SH_TYPE="BTP" AND SH_SOUCHE="'+Souche+'"', True,-1,'',true);
  if not QQ.eof then
  begin
  	TheNumprec := QQ.findfield('SH_NUMDEPART').AsInteger;
  	ferme (QQ);
    repeat
      TheNumero := TheNumPrec + 1;
      requete := 'UPDATE SOUCHE SET SH_NUMDEPART ='+IntToStr(TheNumero)+' WHERE SH_TYPE="BTP" AND SH_SOUCHE="'+Souche+'" AND'+
                 ' SH_NUMDEPART='+IntToStr(TheNumprec);
      if ExecuteSQL (requete) <= 0 then inc(CptArret) else MajOk := true;
    until (CptArret > 10) or (MajOk);
    result := MajOk;
  end else
  begin
    ferme (QQ);
  	PgiBox ('le compteur '+Souche+' n''existe pas..il faut la creer');
  end
end;

function isPieceGerableFraisDetail(naturePiece : string) : boolean;
begin
  result := (naturePiece = VH_GC.AFNatProposition) or
         		(naturePiece = VH_GC.AFNatAffaire) or
         		(naturePiece = 'PBT') or
            (naturePiece = 'BCE') ;
end;

procedure RestitueAcompte(Cledoc : R_cledoc; Journal : string; Numecr : integer ;MontantDev,Montant : double);
var QQ : TQuery;
		TOBA : TOB;
begin
	TOBA := TOB.Create('ACOMPTES',nil,-1);
	QQ := OpenSql ('SELECT * FROM ACOMPTES WHERE GAC_NATUREPIECEG="'+Cledoc.NaturePiece+'" AND'+
  							 ' GAC_SOUCHE="'+Cledoc.Souche+'" AND GAC_NUMERO='+InttoStr(cledoc.NumeroPiece)+
                 ' AND GAC_INDICEG='+IntToStr(cledoc.Indice)+' AND GAC_JALECR="'+JOurnal+'"'+
                 ' AND GAC_NUMECR='+InttoStr(Numecr),true,-1,'',true);
  if not QQ.eof then
  begin
  	TOBA.SelectDB ('',QQ);
    TOBA.PutValue('GAC_MONTANTDEV',TOBA.GetValue('GAC_MONTANTDEV')+MontantDEv);
    TOBA.PutValue('GAC_MONTANT',TOBA.GetValue('GAC_MONTANT')+Montant);
    TOBA.UpdateDB (false);
  end;
  TOBA.Free;
end;

procedure DefiniPvLIgneModifiable (TOBpiece,TOBPOrcs: TOB);
var indice : integer;
begin
	if (TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') and
//  	 (RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'))='AVA') and
     (IsExisteFraisChantier (TOBPiece) or (GetTauxFg(Tobporcs)<>0)) and
		 (TOBPiece.GetValue('ETATDOC')='ACP') then
  begin
  	for Indice := 0 to TOBPiece.detail.count -1 do
    begin
    	TOBPiece.Detail[Indice].putValue('GL_BLOQUETARIF','X');
    end;
  end;
end;


procedure RecalculeCoefFrais (TOBPiece,TOBporcs : TOB);
var ExistFG : boolean;
		TotalFrais,TauxFG,TauxFC : double;
    i : integer;
begin

  TotalFrais := GetMontantFraisDetail (TOBPiece, ExistFg);
  if (ExistFg) and (TotalFrais = 0) then
  begin
    BTPSupprimePieceFrais (TOBpiece);
    ExistFg := false;
  end;

  if (TOBPiece.getValue('GP_MONTANTPAFC') <> 0) and (TotalFrais <> 0) then
  begin
  	TauxFC := arrondi(TotalFrais / (TOBPiece.getValue('GP_MONTANTPAFC')+TOBPiece.getValue('GP_MONTANTFG')),9);
  end else
  begin
  	TauxFC := 0;
  end;
  TOBPIece.putValue('GP_COEFFC',TauxFC);


// Calcul du pourcentage total de frais répartis
// => Dans TOBPorcs cumul des pourcentage de frais ayant le code FRAISREPARTIS à TRUE
//    puis calcul du coefficient global que réprésentent ces frais sur le total HT du document
  TOBPIece.putValue('GP_COEFFR',Arrondi(getTauxFG(TOBporcs)/100,6));

end;


function GetCoefFC (TOBpiece : TOB) : double;
var TotalFrais : double;
		ExistFg : boolean;
begin
  TotalFrais := GetMontantFraisDetail (TOBPiece, ExistFg);
  if (TOBPiece.getValue('GP_MONTANTPAFC') <> 0) and (TotalFrais <> 0) then
  begin
  	result := arrondi(TotalFrais / (TOBPiece.getValue('GP_MONTANTPAFC')+TOBPiece.getValue('GP_MONTANTFG')),9);
  end else
  begin
  	result := 0;
  end;
end;

function GetCoefFC (MontantAppliquable,MontantFraisChantier : double) : double;
begin
  if (MontantAppliquable <> 0 ) and (MontantFraisChantier <> 0) then
  begin
  	result := arrondi(MontantFraisChantier / MontantAppliquable,9);
  end else
  begin
  	result := 0;
  end;
end;

Function GetContrat (Affaire : string) : string;
var QQ : TQUery;
begin
  result := '';
  if Affaire = '' then exit;
  QQ := OpenSql ('SELECT AFF_AFFAIREINIT FROM AFFAIRE WHERE AFF_AFFAIRE="'+Affaire+'"',True,-1,'',true);
  if not QQ.eof then
  begin
    Result := QQ.findField('AFF_AFFAIREINIT').AsString;
  end;
  ferme (QQ);
end;

procedure  SetLigneFacture (TOBL,TOBD : TOB);
begin
  TOBD.putValue('BLF_NATUREPIECEG',TOBL.GetValue('GL_NATUREPIECEG'));
  TOBD.putValue('BLF_SOUCHE',TOBL.GetValue('GL_SOUCHE'));
  TOBD.putValue('BLF_DATEPIECE',TOBL.GetValue('GL_DATEPIECE'));
  TOBD.putValue('BLF_NUMERO',TOBL.GetValue('GL_NUMERO'));
  TOBD.putValue('BLF_INDICEG',TOBL.GetValue('GL_INDICEG'));
  TOBD.putValue('BLF_NUMORDRE',TOBL.GetValue('GL_NUMORDRE'));
  TOBD.putValue('BLF_MTMARCHE',TOBL.GetValue('BLF_MTMARCHE'));
  TOBD.putValue('BLF_MTDEJAFACT',TOBL.GetValue('BLF_MTDEJAFACT'));
  TOBD.putValue('BLF_MTCUMULEFACT',TOBL.GetValue('BLF_MTCUMULEFACT'));
  TOBD.putValue('BLF_MTSITUATION',TOBL.GetValue('BLF_MTSITUATION'));
  TOBD.putValue('BLF_QTEMARCHE',TOBL.GetValue('BLF_QTEMARCHE'));
  TOBD.putValue('BLF_QTEDEJAFACT',TOBL.GetValue('BLF_QTEDEJAFACT'));
  TOBD.putValue('BLF_QTECUMULEFACT',TOBL.GetValue('BLF_QTECUMULEFACT'));
  TOBD.putValue('BLF_QTESITUATION',TOBL.GetValue('BLF_QTESITUATION'));
  TOBD.putValue('BLF_POURCENTAVANC',TOBL.GetValue('BLF_POURCENTAVANC'));
  TOBD.putValue('BLF_NATURETRAVAIL',TOBL.Getvalue('GLC_NATURETRAVAIL'));
  TOBD.putValue('BLF_FOURNISSEUR',TOBL.Getvalue('GL_FOURNISSEUR'));
  TOBD.SetAllModifie (true);
end;

procedure AddChampsSupTable (TOBCur : TOB;PrefixeTable : string);
var ITable,Indice,IndiceTOB : integer;
begin
  iTable := PrefixeToNum(PrefixeTable);  if iTable = 0 then exit;
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
    if not TOBCur.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBCur.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
      IndiceTOB := TOBCur.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
      InitChampsSup (TOBCur,iTable,Indice,IndiceTOB);
    end;
  end;
end;

procedure InitChampsSup(TOBL : TOB; iTable,Ichamps: integer; IndiceTOB: integer=0);
var typeC : string;
    IndiceChamps : integer;
begin
  if IndiceTOB = 0 then IndiceChamps := TOBL.GetNumChamp (V_PGI.Dechamps[iTable, Ichamps].Nom)
                   else IndiceChamps := IndiceTOB;
  TypeC := V_PGI.Dechamps[iTable, Ichamps].tipe;
  if (typeC = 'INTEGER') or (typeC = 'SMALLINT') then TOBL.putValeur(IndiceChamps,0)
  else if (typeC = 'DOUBLE') or (typeC = 'EXTENDED') or (typeC = 'DOUBLE') then TOBL.putValeur(IndiceChamps,0)
  else if (typeC = 'DATE') then TOBL.putValeur(IndiceChamps,iDate1900)
  else if (typeC = 'BLOB') or (typeC = 'DATA') then TOBL.putValeur(IndiceChamps,'')
  else if (typeC = 'BOOLEAN') then TOBL.putValeur(IndiceChamps,'-')
  else TOBL.putValeur(IndiceChamps,'')
end;

function getInfoPuissance (NbLig : integer) : integer;
var termine : boolean;
    Iloc : integer;
begin
  result := 1;
  termine := false;
  Iloc := 0;
  if NbLig = 0 then exit;
  repeat
    if nbLig < Power(10, Iloc) then
    begin
      termine := true;
    end else
    begin
      Inc(Iloc);
    end;
  until termine;
  result := Iloc;
end;


procedure SetItemHvalComboBox (Combo : THValComboBox; Valeur : string);
var Indice : integer;
begin
	for Indice := 0 to Combo.Values.Count -1 do
  begin
  	if Combo.Values[Indice]=Valeur then
    begin
    	Combo.ItemIndex := Indice;
      break;
    end;
  end;
end;

//FV1 : function de recherche des informations bancaire à partir de la table BANQUECP et envoie dans TOB
Procedure LectBanque(TOBBQE : TOB; NumeroRIB : String);
var StSQL : string;
    QQ    : TQuery;
begin

  //Chargement suite info bancaire...
  StSQL := 'SELECT * FROM BANQUECP WHERE BQ_CODE="' + NumeroRib + '"';

	QQ := OpenSql (StSQL, true, -1, '', true);
  if not QQ.eof then TOBBQE.SelectDB ('',QQ);

end;

Procedure LectRIB(TOBBQE : TOB; Auxiliaire : string; NumeroRIB : Integer);
var StSQL : string;
    QQ    : TQuery;
begin

  //Chargement suite info bancaire...
  StSQL := 'SELECT * FROM RIB WHERE R_AUXILIAIRE="' +  Auxiliaire + '" AND R_NUMERORIB=' + IntToStr(NumeroRib);

	QQ := OpenSql (StSQL, true, -1, '', true);
  if not QQ.eof then TOBBQE.SelectDB ('',QQ);

end;

procedure TGenereLivraison.TransformeAchatEnVente(TOBL: TOB);

	function GetUniteVte (Article : string) : string;
  var QQ : TQuery;
  begin
  	result := '';
    QQ := openSql ('SELECT GA_QUALIFUNITEVTE FROM ARTICLE WHERE GA_ARTICLE="'+Article+'"',true,1,'',true);
    if not QQ.eof then
    begin
    	result := QQ.findField('GA_QUALIFUNITEVTE').AsString;
    end;
    Ferme (QQ);
  end;
	function GetUniteSTO (Article : string) : string;
  var QQ : TQuery;
  begin
  	result := '';
    QQ := openSql ('SELECT GA_QUALIFUNITESTO FROM ARTICLE WHERE GA_ARTICLE="'+Article+'"',true,1,'',true);
    if not QQ.eof then
    begin
    	result := QQ.findField('GA_QUALIFUNITESTO').AsString;
    end;
    Ferme (QQ);
  end;

var FUA,FUV,FUS : double;
begin
	if TOBL.getvalue('GL_COEFCONVQTE') <> 0 then
  begin
    FUV := RatioMesure('PIE', TobL.GetValue('GL_QUALIFQTEVTE')); if FUV = 0 then FUV := 1;
    FUS := RatioMesure('PIE', GetUniteSTO(TOBL.GetValue('GL_ARTICLE'))); if FUS = 0 then FUS := 1;
    TOBL.PutValue('GL_PUHTNET', Arrondi(TOBL.GetValue('GL_PUHTNET') / TOBL.GetValue('GL_COEFCONVQTE')/FUS*FUV,V_PGI.okdecP));
    TOBL.PutValue('GL_QUALIFQTEACH', TOBL.GetValue('GL_QUALIFQTEVTE'));
    TOBL.PutValue('GL_QUALIFQTEVTE', GetUniteVte(TOBL.GetValue('GL_ARTICLE')));
  end else
  begin
    TOBL.PutValue('GL_QUALIFQTEACH', TOBL.GetValue('GL_QUALIFQTEVTE'));
    TOBL.PutValue('GL_QUALIFQTEVTE', GetUniteVte(TOBL.GetValue('GL_ARTICLE')));
    FUV := RatioMesure('PIE', TobL.GetValue('GL_QUALIFQTEVTE')); if FUV = 0 then FUV := 1;
    FUA := RatioMesure('PIE', TobL.GetValue('GL_QUALIFQTEACH')); if FUA = 0 then FUA := 1;
    //
    TOBL.PutValue('GL_PUHTNET', Arrondi(TOBL.GetValue('GL_PUHTNET') * FUV / FUA,V_PGI.okdecP));
  end;
end;

end.

