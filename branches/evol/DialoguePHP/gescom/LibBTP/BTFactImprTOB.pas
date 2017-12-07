unit BTFactImprTOB;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids,UTOB,
  SaisUtil, HEnt1, hmsgbox,Hctrls,
  Menus, EntGC,AGLInitGC,UtilPgi,Aglinit,DicoBTP,FactUtil,HRichOle,HTB97,
{$IFDEF EAGLCLIENT}
  MaineAGL,
{$ELSE}
  Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}Fe_Main,
  {$IFDEF V530}
    EdtDOC,
  {$ELSE}
    EdtRdoc,
  {$ENDIF}
{$ENDIF}

{$IFDEF BTP}
  CalcOleGenericBTP,
{$ENDIF}
  Splash,FactTvaMilliem,
  Math,ParamSoc
  ,uEntCommun
  ;

Type

TImprPieceViaTOB = class
	private
    fcledocFacCur : R_CLEDOC;
    fIsDGD : boolean;
    fisAVA : boolean; // pour déclancher les traitement sur DGD avancement
  	fUsable : boolean;
  	venteAchat :string;
  	fcledoc : r_cledoc;
  	fInternal : boolean;
  	fTOBPieceImp,fTOBPieceRecap : TOB;
    fTobPiece : TOB;
    ftobParPiece : TOB;
    fTOBAdresses : TOB;
    fTOBTiers : TOB;
    fTOBLIENOLE : TOB;
    fTOBArticles : TOB;
    fTOBPieceRG : TOB;
    fTOBBases : TOB;
    fTOBEches : TOB;
    fTOBPorcs : TOB;
    fTOBConds : TOB;
    fTOBComms : TOB;
    fTOBOuvrage : TOB;
    fTOBNomenclature : TOB;
    fTOBLOTS : TOB;
    fTOBSerie : TOB;
    fTOBAcomptes : TOB;
    fTOBAffaire,fTOBAffaireDev : TOB;
    fTOBBasesRG : TOB;
    fTOBFormuleVar : TOB;
    fTOBMetre : TOB;
    fTOBRepart : TOB;
    fTOBCodeTaxes : TOB;
    fTOBmetres : TOB;
    fLastNumordre : integer;
    fTexte : THRichEditOle;
    fInternalWindow : TToolWindow97;
    fForm : TForm;
    fcreation : boolean;
    fAvancement : boolean;
    fTOBSituations : TOB;
    WithRecap : boolean;
    TheRepartTva : TREPARTTVAMILL;
    fTOBTimbres : TOB;
    //
    procedure AjouteChampsParamDoc(TOBMere, TOBAInsere: TOB);
    procedure AjouteChampsPiece(TOBMere, TOBAInsere: TOB);
		procedure AjouteChampsMillieme (TOBMere, TOBAInsere: TOB);
		procedure AjouteTOB (TOBMere : TOB; CodeTraitement : string; TOBAInsere : TOB; TOBPrec : TOB = nil);
    function  InsereTOB(NomTable: string; TOBmere: TOB; WithNewNumOrdre : boolean=true): TOB;
    procedure AjouteChampsDOCTEXTEDEBFIN(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsINTEXTEDEBFIN(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsTiers(TOBmere, TOBAInsere: TOB);
    procedure CumuleChampsAvancLigne(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsAvancementPiece (TOBMere : TOB);
    procedure AjouteChampsAffaire(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsAffaireDEVIS(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPiedBase(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPiedBaseRG(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPieceAdresse(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPiedEche(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPiedPort(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsPieceRG(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsParPiece(TOBmere, TOBAInsere: TOB);
    procedure AjouteChampsDEVISE(TOBmere: TOB);
    procedure AjouteChampsLIGNE(TOBmere, TOBAINSERE: TOB; LigneFac : boolean=false);
    procedure AjouteChampsARTICLES(TOBmere, TOBAINSERE: TOB);
    procedure AjouteChampsOUVRAGE(TOBmere, TOBAINSERE,TOBLigne : TOB);
    procedure AjouteChampsMETRE(TOBmere: TOB);
    procedure prepareTVA;
    procedure PreparePiedbase (TOBMere : TOB);
    function  FindLibre(Prefixe,Code : string) : string;
    procedure AddSupLignesEdt(TOBMere: TOB);
    procedure DefiniAffichageLigne(TOBmere: TOB);
//    procedure ReDefiniNumLig (ThePiece : TOB);
//    function GetLastNumOrdre : integer;
		function IsBlocNoteVide (BlocNote : String; Fichier : boolean=False) : boolean;
    procedure CreeAdresseFacturation(TobMere: TOB);
    procedure AjouteChampsPARAG(TOBmere, TOBAInsere: TOB);
    procedure AlimenteTotauxParag(ThePiece, TOBparag: TOB);
    function  FindLaFinParag(TheLigne: TOB; IndiceDep: integer): TOB;
    procedure PoselesTotaux(ThePiece,TheLigne, LaTotalisation: TOB);
    procedure AlimentePort(ThePiece: TOB);
    procedure AjoutelesPORTS(TOBmere, TOBAInsere: TOB);
    procedure InsereChampMere(TOBMere, LaTOBgrandMere: TOB);
    procedure AlloueTout;
    procedure DetruitTout;
    procedure loadlesTobs;
		procedure RazTout;
    procedure LoadLesArticles;
    procedure InitModePaiement (TOBMere : TOB);
    function GetInfoParams: boolean;
    procedure SetMode;
    procedure SetMontantMarche(TOBmere, LaLigne: TOB);
    procedure AlimenteTableauSituations(ThePiece: TOB);
    procedure InitChamps(TOBL: TOB; iTable, Ichamps, IndiceTOB: integer);
    procedure AjouteChampsSituation(TOBMere: TOB);
    procedure DefiniLigneSituation(TOBMere, TOBSituation: TOB);
    procedure AjouteChampsAcomptesCpta(TOBMere: TOB);
    function SetQueryForOldSituations : Widestring;
    procedure SetLignesRecap(ThePiece: TOB);
    procedure DefiniRecapTotalSit(ThePiece: TOB);
    procedure DefiniLigneTotalHt(ThePiece: TOB);
    procedure DefiniLigneMontantHt(ThePiece: TOB; EscompteCum, RemiseCum,PortCum,CumPortSit: double);
    procedure DefiniLigneRemise (ThePiece : TOB;RemiseCum: double);
    procedure DefiniLigneEscompte (ThePiece : TOB;EscompteCum : double);
    procedure DefiniLignePortFrais(ThePiece: TOB; PortCum,CumPortSit: double);
    procedure ConstitueTOBTVA(ThePiece, TOBTVAPre: TOB);
    procedure SetMontantregleSituations;
    procedure ConstitueTOBRGPrec(ThePiece, TOBRGPre: TOB);
    procedure DefiniLigneTVARG(ThePiece, TOBRGPRE: TOB;var TVARGSIt,TVARGPre : double);
    procedure DefiniLignesTVA(ThePiece, TOBTVAPre: TOB;var CumSitTva,CumPreTva: double);
    procedure DefiniLigneRGHT(ThePiece, TOBRGPRE: TOB; var CumSitHt,
      CumpreHt, ReliquatRGSit, reliquatRGPre: double);
    procedure DefiniLigneRGTTC(ThePiece: TOB; ReliquatRGSit,
      reliquatRGPre: double);
    procedure DefiniLigneTOTALTTC(ThePiece: TOB; CumSitTVA, CumPreTVA,
      CumRGSit, CumRgPre,TVARGSIt,TVARGPre: double; var TTCSIt, TTCPRE: double);
    procedure DefiniLigneACOMPTES(ThePiece: TOB; var AcomptesSit,
      AcomptesPre: double);
    procedure DefiniLigneTOTALNET(ThePiece: TOB; TTCSit, TTCPre,
      ReliquatRGSit, reliquatRGPre, AcomptesSit, AcomptesPre,Timbres: double);
    procedure SetMontantMarcheOldVersion(TOBmere : TOB);
    function IsExistsMemoFacturation: boolean;
    function IsSamePiece(reference, cledoc: r_cledoc): boolean;
    procedure CumuleBudgetFromCledoc(Cledoc: R_cledoc; TOBMere: TOB);
    function isExistsMemo(LaLigne: TOB): boolean;
    procedure PositionneMarcheFromPiece(TheRecap, ThePiece: TOB);
    procedure GestionAnciennesfactureation (TOBL : TOB; Modegenere : string; DEV : RDevise);
    procedure AjoutelesMETRESLIG(TOBmere, TOBAInsere: TOB);
    procedure AlimentemetresLig (ThePiece,TheLigne: TOB; Numordre : integer; TOBmetres : TOB);
    procedure AjouteleMtTimbre(TOBmere, TOBAInsere: TOB);
    function DefiniLigneTimbres(ThePiece, TOBTimbres: TOB) : double;
  public
  	property Usable : boolean read GetInfoParams write fusable;
  	property TOBPiece : TOB read fTOBPiece write fTOBPiece;
    property TOBAdresses : TOB read fTOBAdresses write fTOBAdresses;
    property TOBTiers : TOB read fTOBTiers write fTOBTiers;
    property TOBLIENOLE : TOB read fTOBLIENOLE write fTOBLIENOLE;
    property TOBArticles : TOB read fTOBArticles write fTOBArticles;
    property TOBPieceRG : TOB read fTOBPieceRG write fTOBPieceRG;
    property TOBBasesRG : TOB read fTOBBasesRG write fTOBBasesRG;
    property TOBBases : TOB read fTOBBases write fTOBBases;
    property TOBEches : TOB read fTOBEches write fTOBEches;
    property TOBPorcs : TOB read fTOBPorcs write fTOBPorcs;
    property TOBConds : TOB read fTOBConds write fTOBConds;
    property TOBComms : TOB read fTOBComms write fTOBComms;
    property TOBParPiece : TOB read fTOBParPiece write fTOBParPiece;
    property TOBOuvrage : TOB read fTOBOuvrage write fTOBOuvrage;
    property TOBNomenclature : TOB read fTOBNomenclature write fTOBNomenclature;
    property TOBLOTS : TOB read fTOBLOTS write fTOBLOTS;
    property TOBSerie : TOB read fTOBSerie write fTOBSerie;
    property TOBAcomptes : TOB read fTOBAcomptes write fTOBAcomptes;
    property TOBAffaire : TOB read fTOBAffaire write fTOBAffaire;
    property TOBFormuleVar : TOB read fTOBFormuleVar write fTOBFormuleVar;
    property TOBAIMPRIMER : TOB read fTOBPieceImp write fTOBPieceImp;
    property InCreation : boolean read fcreation write fcreation;
    property TOBRECAP : TOB read fTOBPieceRecap write fTOBPieceRecap;
    property TOBtimbres : TOB read fTOBTimbres write fTOBTimbres;
    procedure AssocieTOBs (TOBPiece,TOBBases,TOBEches,TOBPorcs,TOBTiers,
                           TOBArticles,TOBComms,TOBAdresses,TOBNomenClature,
                           TOBDesLots,TOBSerie,TOBAcomptes,TOBAffaire,TOBOuvrage,TOBLienOle,
                           TOBPieceRg,TOBBasesRG,TOBFormuleVar,TOBMetre,TOBRepart,TOBmetres,TOBTimbres: TOB);
  	constructor create (TheFiche : TForm);
    destructor Destroy; override;
    procedure PreparationEtat;
    procedure SetDocument(Cledoc : R_cledoc; IsDgd : Boolean);
    procedure ClearInternal;
    function GetModeleAssocie(Modele : string) : string;
    function YaMetre : boolean;
end;

function EditionViaTOB (cledoc : r_cledoc) : boolean;
function ImpressionAutoriseViaTOB (cledoc : r_cledoc):boolean;

implementation
uses UtilMetres,FactVariante,FactAdresse,FactNomen,FactTob,OptimizeOuv,FactComm,FactOuvrage,Affaireutil,
			Factcalc,FactPiece,STockUtil,FactCOmmBTP,UtilTOBPiece,BTSAISIEPAGEMETRE_TOF,
      FactTimbres;
{$IFDEF BTP}
//var TheMetre: TStockMetre;
{$ENDIF}

function ImpressionAutoriseViaTOB (cledoc : r_cledoc):boolean;
begin
	Result := (Cledoc.Naturepiece = 'DBT') or
  					(Cledoc.Naturepiece = 'ETU') or
            (Cledoc.Naturepiece = 'FBT') or
            (Cledoc.Naturepiece = 'BCE') or
            (Cledoc.Naturepiece = 'DAC') or
            (Cledoc.Naturepiece = 'ABT') ;
end;

function EditionViaTOB (cledoc : r_cledoc):boolean;
var Req : string;
		Q : TQuery;
    LaTOB : TOB;
begin
	result := false;
  Req := 'SELECT BPD_NUMPIECE,BPD_IMPRVIATOB FROM BTPARDOC WHERE BPD_NATUREPIECE="'+Cledoc.naturepiece +'" AND '+
  			 'BPD_SOUCHE="'+cledoc.souche +'" AND '+
         '((BPD_NUMPIECE=0) OR (BPD_NUMPIECE='+InttoStr(Cledoc.NumeroPiece)+')) ORDER BY BPD_NUMPIECE DESC';
  Q := OpenSql (Req,True,-1,'',true);
  if not Q.eof then
  begin
		LaTOB := TOB.Create ('LES PARAMS',nil,-1);
    laTOB.LoadDetailDB ('BTPARDOC','','',Q,false);
    ferme(Q);
    result := (LaTOB.Detail[0].GetValue('BPD_IMPRVIATOB')='X');
  	LaTOB.free;
  end;
end;


{ TImprPieceViaTOB }

procedure TImprPieceViaTOB.DefiniAffichageLigne(TOBmere : TOB);
var TypePresent : Integer;
		TOBParent : TOB;
begin
	TOBParent := TOBmere.parent;

  if (TOBMERE.GetValue('ISLIGNESTD')='X') OR (TOBMERE.GetValue('ISVARIANTE')='X') then
  begin
  	TOBMere.PutValue('DESCRIPTIF','X');

  	if (TOBParent.GetValue('BPD_IMPDESCRIPTIF')='S') then
    begin
    TOBMere.PutValue('GL_BLOCNOTE','');
    end else if (TOBParent.GetValue('BPD_IMPDESCRIPTIF')='T') then
    begin
			if (TOBMere.getValue('GL_BLOCNOTE') = '') or (IsBlocNoteVide(TOBMere.getValue('GL_BLOCNOTE'))) then
      begin
      	TOBMere.PutValue('DESCRIPTIF','X');
        if (TOBMere.getValue('GA_BLOCNOTE') <> '') and (not IsBlocNoteVide(TOBMere.getValue('GA_BLOCNOTE'))) then
        begin
        	TOBMere.PutValue('GL_BLOCNOTE',TOBMere.GetValue('GA_BLOCNOTE'));
        	TOBMere.PutValue('GA_BLOCNOTE',''); // evite de surcharger la memoire
        end;
      end;
    end else TOBMere.PutValue('DESCRIPTIF','X');

    if (TOBMere.getValue('GL_BLOCNOTE') = '') or (IsBlocNoteVide(TOBMere.getValue('GL_BLOCNOTE'))) then
    begin
      TOBMere.PutValue('GL_BLOCNOTE', '');
      TOBMere.PutValue('DESCRIPTIF','-');
    end;
  end;

  if (TOBMere.getValue('GL_BLOCNOTE') <> '') and (not IsBlocNoteVide(TOBMere.getValue('GL_BLOCNOTE'))) then
  begin
    TOBMERE.PutValue('WITHBLOB','X');
    if TOBMere.GetValue('ISCOMMVARIANTE')='X' then
    begin
    	TOBMERE.PutValue('ISCOMMENTAIRE','X');
    	TOBMERE.PutValue('ISCOMMVARIANTE','-');
    end;
  end;

	if (TOBmere.GetValue('ISDETOUVSTD')='X') OR (TOBmere.GetValue('ISDETOUVVAR')='X') then
  begin
  	TypePresent := TOBParent.GetValue('BPD_TYPESSD');
    if TypePresent = -1 Then TypePresent := DOU_AUCUN else
    if TypePresent = 0 then TypePresent := TOBMere.GetValue('GL_TYPEPRESENT');
  end else
  begin
  	TypePresent := TOBParent.GetValue('BPD_TYPEPRES');
  end;
// TODO Voir en fonction du parametrage de l'edition
//
  if (TypePresent AND DOU_CODE) <> DOU_CODE Then
  begin
    TObMere.putValue('GL_REFARTTIERS','');
    TObMere.putValue('GL_REFARTSAISIE','');
  end;
  if (TypePresent AND DOU_LIBELLE) <> DOU_LIBELLE Then
  begin
    if (TOBMERE.GetValue('ISFINPARAGRAPHE')='-') and ((TOBMERE.GetValue('ISLIGNESTD')='X') or (TOBMERE.GetValue('ISVARIANTE')='X')) then
    	TObMere.putValue('GL_LIBELLE','');
  end;
  TOBMere.PutValue('LIBELLE',TObMere.GetValue('GL_REFARTSAISIE')+' '+TObMere.GetValue('GL_LIBELLE'));
  if (TypePresent AND DOU_QTE) <> DOU_QTE Then
  begin
    TObMere.putValue('GL_QTEFACT',0);
  end else
  begin
  	TOBMere.PutValue('TITREQTE','Quantité');
  end;
  if (TypePresent AND DOU_UNITE) <> DOU_UNITE Then
  begin
    TObMere.putValue('GL_QUALIFQTEVTE','');
  end;
  if (TypePresent AND DOU_PU) <> DOU_PU Then
  begin
    TObMere.putValue('GL_PUHTDEV',0);
    TObMere.putValue('GL_PUTTCDEV',0);
  end else
  begin
  	TOBMere.PutValue('TITREPU','Prix Unit.');
  end;

  if (TypePresent AND DOU_MONTANT) <> DOU_MONTANT Then
  begin
		if not IsParagraphe (TOBMere) then
  	begin
    	TObMere.putValue('GL_MONTANTHTDEV',0);
    	TObMere.putValue('GL_MONTANTTTCDEV',0);
    end;
  end else
  begin
  	TOBMere.PutValue('TITREMONTANT','Montant');
  end;
end;

procedure TImprPieceViaTOB.AddSupLignesEdt (TOBMere : TOB);
begin
  //
  AjouteTOB (TOBMere,'ARTICLES',nil); // définition des champs dans la tob
  AjouteTOB (TOBMere,'LIGNES',nil);
  AjouteTOB (TOBMere,'LIGNEFAC',nil);
  AjouteTOB (TOBMere,'TABLEAUSITUATIONS',nil);
  AjouteTOB (TOBMere,'METRESLIG',nil);
  //
  TOBMEre.AddChampSupValeur ('ISCUMULABLE','-');
  TOBMEre.AddChampSupValeur ('MONTANTPOURREPORT',0);
  //
	TOBMere.AddChampSupValeur ('DEFINIMETRE','');
  TOBMEre.AddChampSupValeur ('ISDEBPARAGRAPHE','-');
  TOBMEre.AddChampSupValeur ('ISDEBPARVARIANT','-');
  TOBMEre.AddChampSupValeur ('ISFINPARAGRAPHE','-');
  TOBMEre.AddChampSupValeur ('ISFINPARVARIANT','-');
  TOBMEre.AddChampSupValeur ('ISPARAGRAPHE','-');
  TOBMEre.AddChampSupValeur ('ISPARVARIANT','-');

  TOBMEre.AddChampSupValeur ('ISDETOUVSTD','-');
  TOBMEre.AddChampSupValeur ('ISDETOUVVAR','-');
  // Commentaires standard
  TOBMEre.AddChampSupValeur ('ISCOMMENTAIRE','-');
  TOBMEre.AddChampSupValeur ('ISCOMMVARIANTE','-');
  // BLOB Ligne renseigne
  TOBMEre.AddChampSupValeur ('WITHBLOB','-');
  // ---
  TOBMEre.AddChampSupValeur ('ISLIGNESTD','-');
  TOBMEre.AddChampSupValeur ('ISVARIANTE','-');
  TOBMEre.AddChampSupValeur ('LIBELLE','');
  TOBMEre.AddChampSupValeur ('TITREQTE','');
  TOBMEre.AddChampSupValeur ('TITREPU','');
  TOBMEre.AddChampSupValeur ('TITREMONTANT','');
	TobMere.addChampSupValeur ('TAX_CODETVA','');
	TobMere.addChampSupValeur ('TX1_CODETVA','');
	TobMere.addChampSupValeur ('TX2_CODETVA','');
	TobMere.addChampSupValeur ('TX3_CODETVA','');
	TobMere.addChampSupValeur ('TX4_CODETVA','');
	TobMere.addChampSupValeur ('TX5_CODETVA','');

  TOBMere.AddChampSupValeur ('DESCRIPTIF','-');
  TOBMere.AddChampSupValeur ('HASMETRE','-');
  TOBMEre.AddChampSupValeur ('ISDEBEDTPAR','-');
  TOBMEre.AddChampSupValeur ('ISFINEDTPAR','-');
  TOBMEre.AddChampSupValeur ('ISLIGEDTPAR','-');
  TOBMEre.AddChampSupValeur ('ISLIGPORT','-');
  TOBMere.AddChampSupValeur ('INDICEMETRE',0);
  TOBMere.AddChampSupValeur ('ISDETOUVVAR','-');
  TOBMere.AddChampSupValeur ('ISDETOUVSTD','-');
  // ------
  // recapitulatif des situations
  // ------
  TOBMere.AddChampSupValeur ('DEBUTRECAPSIT','-');
  TOBMere.AddChampSupValeur ('LIGNERECAPSIT','-');
  TOBMere.AddChampSupValeur ('FINRECAPSIT','-');
  TOBMere.AddChampSupValeur ('ACOMPTESIT',0);
  //
  TOBMEre.AddChampSupValeur ('MONTANTSIT',0);
  TOBMEre.AddChampSupValeur ('LIBELLESIT','');
  TOBMEre.AddChampSupValeur ('MONTANTPRE',0);
  TOBMEre.AddChampSupValeur ('LIBELLEPRE','');
  TOBMEre.AddChampSupValeur ('LIBELLECUM','');
  // -----
  // GESTION DES METRES LIGNES (ex Gamme II)
  // ----
  TOBMEre.AddChampSupValeur ('ISDEBMETRE','-');
  TOBMEre.AddChampSupValeur ('ISFINMETRE','-');
  TOBMEre.AddChampSupValeur ('ISLIGMETRE','-');
  // ----

end;

procedure TImprPieceViaTOB.AjouteChampsARTICLES (TOBmere,TOBAINSERE : TOB);
var ITable,Indice,IndiceTOB : integer;
begin
  iTable := PrefixeToNum('GA');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
      IndiceTOB := TOBMere.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
      InitChamps (TOBmere,iTable,Indice,IndiceTOB);
    end;
    if TOBAInsere <> nil then
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
end;


procedure TImprPieceViaTOB.AjouteChampsLIGNE(TOBmere, TOBAINSERE: TOB; LigneFac : boolean=false);
var ITable,Indice,IndiceTOB: integer;
begin
  if LigneFac then
  begin
    iTable := PrefixeToNum('BLF');
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
      begin
        TOBMere.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
        IndiceTOB := TOBMere.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
        InitChamps (TOBmere,iTable,Indice,IndiceTOB);
      end;
      if TOBAinsere <> nil then
      begin
        TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
                         TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
      end;
    end;
    if TOBmere.GetValue('GL_TYPELIGNE')='ART' then
    begin
      TOBMere.PutValue ('MONTANTPOURREPORT',TOBMere.getValue('BLF_MTCUMULEFACT'));
    end;
  end else
  begin
    iTable := PrefixeToNum('GL');
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
  //  	if V_PGI.Dechamps[iTable, Indice].Nom = 'GL_NUMORDRE' then continue;
      if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
      begin
        TOBMere.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
        IndiceTOB := TOBMere.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
        InitChamps (TOBmere,iTable,Indice,IndiceTOB);
      end;
      if TOBAinsere <> nil then
      begin
        TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
                         TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
      end;
    end;
    if TOBAinsere <> nil then
    begin
    	// METRES
      TOBMere.PutValue ('INDICEMETRE',TOBAInsere.GetValue('INDICEMETRE'));
      //
      if (IsVariante(TOBMERE)) then
      begin
        if IsArticle(TOBMere) then TOBMEre.PutValue ('ISVARIANTE','X') else
        if ISCommentaire(TOBMERE) then TOBMEre.PutValue ('ISCOMMVARIANTE','X') else
        if IsDebutParagraphe(TOBMERE) then TOBMEre.PutValue ('ISDEBPARVARIANT','X') else
        if IsFinParagraphe(TOBMERE) then TOBMEre.PutValue ('ISFINPARVARIANT','X');
      end else
      begin
        if ISArticle(TOBMERE) then BEGIN TOBMEre.PutValue ('ISLIGNESTD','X'); TOBMEre.PutValue ('ISCUMULABLE','X'); end else
        if ISSousTotal(TOBMERE) then TOBMEre.PutValue ('ISLIGNESTD','X') else
        if ISCommentaire(TOBMERE) then TOBMEre.PutValue ('ISCOMMENTAIRE','X') else
        if IsDebutParagraphe(TOBMERE) then TOBMEre.PutValue ('ISDEBPARAGRAPHE','X') else
        if IsFinParagraphe(TOBMERE) then TOBMEre.PutValue ('ISFINPARAGRAPHE','X');
      end;
      if TOBMere.GetValue('ISLIGNESTD')='X' then
      begin
      	if TOBMere.GetValue ('GL_FAMILLETAXE1') <> '*' then
        begin
        TOBMere.PutValue('TX1_CODETVA',findLibre('TX1',TOBMere.GetValue ('GL_FAMILLETAXE1')));
        end else
        begin
        TOBMere.PutValue('TX1_CODETVA',TOBMere.GetValue ('GL_FAMILLETAXE1'));
        end;
        TOBMere.PutValue('TAX_CODETVA',TOBMere.GetValue('TX1_CODETVA'));
        if TOBMere.GetValue ('GL_FAMILLETAXE2') <> '' then
        begin
          TOBMere.PutValue('TX2_CODETVA',findLibre('TX2',TOBMere.GetValue ('GL_FAMILLETAXE2')));
          TOBMere.PutValue('TAX_CODETVA','*');
        end;
        if TOBMere.GetValue ('GL_FAMILLETAXE3') <> '' then
        begin
          TOBMere.PutValue('TX3_CODETVA',findLibre('TX3',TOBMere.GetValue ('GL_FAMILLETAXE3')));
          TOBMere.PutValue('TAX_CODETVA','*');
        end;
        if TOBMere.GetValue ('GL_FAMILLETAXE4') <> '' then
        begin
          TOBMere.PutValue('TX4_CODETVA',findLibre('TX4',TOBMere.GetValue ('GL_FAMILLETAXE4')));
          TOBMere.PutValue('TAX_CODETVA','*');
        end;
        if TOBMere.GetValue ('GL_FAMILLETAXE5') <> '' then
        begin
          TOBMere.PutValue('TX5_CODETVA',findLibre('TX5',TOBMere.GetValue ('GL_FAMILLETAXE5')));
          TOBMere.PutValue('TAX_CODETVA','*');
        end;
      end;
      DefiniAffichageLigne(TOBmere);
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsPARAG (TOBmere,TOBAInsere : TOB);
begin
  TobMere.dupliquer(TOBAInsere,false,true);
  if TOBMere.GetValue('ISDEBPARAGRAPHE')='X' then
  begin
    TOBMere.PutValue('ISDEBPARAGRAPHE','-');
    TOBMere.PutValue('ISPARAGRAPHE','X');
  end else if TOBMere.GetValue('ISDEBPARVARIANT')='X' then
  begin
    TOBMere.PutValue('ISDEBPARVARIANT','-');
    TOBMere.PutValue('ISPARVARIANT','X');
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsDEVISE (TOBmere : TOB);
var QQ : Tquery;
		REQ : String;
begin
	Req := 'SELECT D_SYMBOLE FROM DEVISE WHERE D_DEVISE="'+ fTOBPiece.GEtVAlue('GP_DEVISE')+'"';
  QQ := OpenSql(Req,True,-1,'',true);
  TOBMere.AddChampSup ('D_SYMBOLE',false);
  if not QQ.eof then TOBMere.putValue ('D_SYMBOLE',QQ.findField('D_SYMBOLE').AsString);
  Ferme(QQ);
end;

procedure TImprPieceViaTOB.AjouteChampsAffaire (TOBmere,TOBAInsere : TOB);
var ITable,Indice : integer;
begin
  iTable := PrefixeToNum('AFF');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	//
  	//if V_PGI.Dechamps[iTable, Indice].Nom = 'AFF_DESCRIPTIF' then continue;
    // --
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSupValeur (V_PGI.Dechamps[iTable, Indice].Nom,
      													 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end else
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
  {$IFDEF BTP}
  TOBMere.AddChampSupValeur ('AFF_AFFAIREFORMATE',BTPCodeAffaireAffiche(TobMere.GetValue('AFF_AFFAIRE')));
  {$ELSE}
  TOBMere.AddChampSupValeur ('AFF_AFFAIREFORMATE',CodeAffaireAffiche(TobMere.GetValue('AFF_AFFAIRE')));
  {$ENDIF}
end;

procedure TImprPieceViaTOB.AjouteChampsAffaireDEVIS (TOBmere,TOBAInsere : TOB);
var ITable,Indice : integer;
		Suffixe : string;
    TOBLOC : TOB;
begin
  iTable := PrefixeToNum('AFF');
  if TOBAInsere = nil then
  begin
    // cas de figure  : Impression d'un document en cours de création
    TOBLOc := TOB.Create ('AFFAIRE',nil,-1);
  end;
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
    suffixe := Copy(V_PGI.Dechamps[iTable, Indice].Nom,Pos('_',V_PGI.Dechamps[iTable, Indice].Nom)+1,255);
    if TOBAInsere <> nil then
    begin
      TOBMere.AddChampSupValeur ('IAFF_'+Suffixe,
                                 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end else
    begin
      TOBMere.AddChampSupValeur ('IAFF_'+Suffixe,
                                 TOBLoc.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
  if TOBAInsere = nil then
  begin
    freeAndNil(TOBLOc);
  end;
end;

procedure TImprPieceViaTOB.AjoutelesMETRESLIG(TOBmere,TOBAInsere : TOB);
var ITable,Indice,IndiceTOB : integer;
begin
  iTable := PrefixeToNum('BLM');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	//
  	if Pos(V_PGI.Dechamps[iTable, Indice].Nom ,'BLM_NATUREPIECEG;BLM_SOUCHE,BLM_NUMERO,BLM_INDICEG,BLM_NUMORDRE,BLM_INDICE')>0 then continue;
    // --
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
      IndiceTOB := TOBMere.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
      InitChamps (TOBmere,iTable,Indice,IndiceTOB);
    end;
    if TOBAInsere <> nil then
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
end;


procedure TImprPieceViaTOB.AjouteleMtTimbre (TOBmere,TOBAInsere : TOB);
var Mttimbre : Double;
		indice : Integer;
begin
  Mttimbre := 0;
  for Indice := 0 to TOBAInsere.detail.count -1 do
  begin
    Mttimbre := Mttimbre + TOBAInsere.detail[Indice].getValue('BT0_VALEUR');
  end;
  if not TOBMere.FieldExists ('VALTIMBRES') then
  begin
    TOBMere.AddChampSupValeur ('VALTIMBRES',Mttimbre);
  end else
  begin
    TOBMere.PutValue ('VALTIMBRES',Mttimbre);
  end;
end;

procedure TImprPieceViaTOB.AjoutelesPORTS (TOBmere,TOBAInsere : TOB);
var iTable,Indice : integer;
		LaTOBgrandMere : TOB;
    prefixe,newChamp : String;
begin
  LaTOBGrandMere := Tobmere.Parent;

  InsereChampMere(TOBMere,LaTOBgrandMere);
  iTable := PrefixeToNum('GPT');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	Prefixe := 'GL';
    NewChamp := prefixe+copy(V_PGI.Dechamps[iTable, Indice].Nom,4,255);
		if TOBMere.FieldExists (NewChamp) then
    		TOBMere.PutValue (NewChamp,TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
  end;
  TOBMEre.PutValue ('ISLIGPORT','X');
end;

procedure TImprPieceViaTOB.AjouteChampsMETRE (TOBmere : TOB);
var LaLigneOle : TOB;
begin
	if TOBmere = nil then exit;
	if TOBMere.GetValue('INDICEMETRE')=0 then exit;
	laLigneOle := fTOBMetre.findfirst (['INDICEMETRE'],[TOBMere.getValue('INDICEMETRE')],true);
  if (LaLigneOle <> nil) then TOBMere.PutValue('DEFINIMETRE',laLigneOle.getValue('LO_OBJET'));
  TOBMere.PutValue ('HASMETRE','X');
	if (TOBMere.GetValue('DEFINIMETRE')='') Or (IsBlocNoteVide(TOBMere.GetValue('DEFINIMETRE'),True)) then
  	TOBMere.PutValue ('HASMETRE','-');
end;

procedure TImprPieceViaTOB.AjouteChampsTiers (TOBmere,TOBAInsere : TOB);
var ITable,Indice : integer;
begin
  iTable := PrefixeToNum('T');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	//
  	if V_PGI.Dechamps[iTable, Indice].Nom = 'T_BLOCNOTE' then continue;
    // --
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSupValeur (V_PGI.Dechamps[iTable, Indice].Nom,
      													 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end else
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsPiece (TOBMere,TOBAInsere : TOB);
var ITable,Indice : integer;
begin
  iTable := PrefixeToNum('GP');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSupValeur (V_PGI.Dechamps[iTable, Indice].Nom,
      													 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end else
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
  TOBMere.putValue('GP_NUMERO',fcledocFacCur.NumeroPiece );
end;

procedure TImprPieceViaTOB.AjouteChampsPiedEche (TOBmere,TOBAInsere : TOB);
var ITable,Indice,Num : integer;
		ChampsOrig,ChampsDest,Suffixe : string;
    LaTOBOrig : TOB;
begin
	InitModePaiement (TOBmere);
  iTable := PrefixeToNum('GPE');
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];
    Suffixe := IntToStr (LATOBOrig.GetValue('GPE_NUMECHE'));
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := ChampsOrig+Suffixe;
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
      if TOBMere.getValue('GPE_MODEPAIE1') <> '' then
      	TOBMere.AddChampSupValeur ('GPE_LIBMODEPAIE1',RechDom('GCMODEPAIE',TOBMere.getValue('GPE_MODEPAIE1'),false));
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsPiedBase (TOBmere,TOBAInsere : TOB);
var ITable,Indice,Num,IndiceTaxe,Cpt : integer;
		ChampsOrig,ChampsDest,Suffixe,Prefixe,LastPrefixe,Code,Chpt : string;
    LaTOBOrig,LaTOBRepart,LaTOBInterm,TOBI : TOB ;
begin
  LaTOBInterm := TOB.Create ('LES BASEs',nil,-1);
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
    TOBI := LaTOBInterm.FindFirst(['GPB_CATEGORIETAXE','GPB_FAMILLETAXE'],
    															[TOBAInsere.detail[Num].GetValue('GPB_CATEGORIETAXE'),
                                   TOBAInsere.detail[Num].GetValue('GPB_FAMILLETAXE')],True);
  	if TOBI = nil then
    begin
      TOBI := TOB.Create('PIEDBASE',LaTOBInterm,-1);
      TOBI.Dupliquer(TOBAInsere.detail[Num],False,true);
    end else
    begin
      TOBI.PutValue('GPB_BASETAXE',TOBI.GetValue('GPB_BASETAXE')+TOBAInsere.detail[Num].GetValue('GPB_BASETAXE'));
      TOBI.PutValue('GPB_VALEURTAXE',TOBI.GetValue('GPB_VALEURTAXE')+TOBAInsere.detail[Num].GetValue('GPB_VALEURTAXE'));
      TOBI.PutValue('GPB_BASEDEV',TOBI.GetValue('GPB_BASEDEV')+TOBAInsere.detail[Num].GetValue('GPB_BASEDEV'));
      TOBI.PutValue('GPB_VALEURDEV',TOBI.GetValue('GPB_VALEURDEV')+TOBAInsere.detail[Num].GetValue('GPB_VALEURDEV'));
      TOBI.PutValue('GPB_BASETAXETTC',TOBI.GetValue('GPB_BASETAXETTC')+TOBAInsere.detail[Num].GetValue('GPB_BASETAXETTC'));
      TOBI.PutValue('GPB_BASETTCDEV',TOBI.GetValue('GPB_BASETTCDEV')+TOBAInsere.detail[Num].GetValue('GPB_BASETTCDEV'));
      TOBI.PutValue('GPB_BASETTCDEV',TOBI.GetValue('GPB_BASETTCDEV')+TOBAInsere.detail[Num].GetValue('GPB_BASETTCDEV'));
    end;
  end;
	Tobmere.AddChampSupValeur('PRESENCEMILLIEME','');
  iTable := PrefixeToNum('GPB');
  IndiceTaxe := 0;
  Prefixe := '';
  LastPrefixe := '';
  Cpt := 1;
  for Num := 1 to 5 do
  begin
  	if not TOBmere.fieldExists('TAX_LCODETVA'+inttostr(Num)) then
    begin
      TOBMEre.AddChampSupValeur ('TAX_LCODETVA'+inttoStr(Num),'');
      TOBMEre.AddChampSupValeur ('TAX_BASETVA'+inttoStr(Num),'');
      TOBMEre.AddChampSupValeur ('TAX_TAUXTAXE'+inttoStr(Num),'');
      TOBMEre.AddChampSupValeur ('TAX_VALEURTAXE'+inttoStr(Num),'');
  		Tobmere.AddChampSupValeur ('TAX_REPART'+inttoStr(Num),0);
    end else
    begin
      TOBMEre.PutValue ('TAX_LCODETVA'+inttoStr(Num),'');
      TOBMEre.PutValue ('TAX_BASETVA'+inttoStr(Num),'');
      TOBMEre.PutValue ('TAX_TAUXTAXE'+inttoStr(Num),'');
      TOBMEre.PutValue ('TAX_VALEURTAXE'+inttoStr(Num),'');
    end;
  end;
  For Num := 0 To LaTOBInterm.detail.count -1 do
  begin
  	LATOBOrig := LaTOBInterm.detail[Num];
    prefixe := LATOBOrig.getValue('GPB_CATEGORIETAXE');
    Code := LATOBOrig.getValue('GPB_FAMILLETAXE');
    //
    LaTOBrepart := fTOBrepart.findfirst(['BPM_CATEGORIETAXE','BPM_FAMILLETAXE'],[prefixe,code],true);
    if LastPrefixe <> Prefixe Then
    begin
    	IndiceTaxe := 1;
      LastPrefixe := prefixe;
    end else
    begin
    	inc (IndiceTaxe);
    end;
    Suffixe := IntToStr (Indicetaxe);
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := Prefixe+Copy(ChampsOrig,4,255)+Suffixe;
      Chpt := 'TAX'+Copy(ChampsOrig,4,255)+InttoStr(Cpt);
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
      if not TOBMere.FieldExists (ChPt) then
      begin
        TOBMere.AddChampSupValeur (ChPt,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChPt,LATOBOrig.GetValue(ChampsOrig));
    end;
    end;
    //
    if LaTOBrepart <> nil then
    begin
  		Tobmere.PutValue('TAX_REPART'+inttoStr(Cpt),LaTOBrepart.getValue('BPM_MILLIEME'));
  		Tobmere.PutValue('PRESENCEMILLIEME','X');
    end;
    //
    if not TOBMere.FieldExists('TAX_LCODETVA'+inttostr(Cpt)) then
    begin
      TOBMere.AddChampSup  ('TAX_LCODETVA'+inttostr(Cpt),false);
    end;
    TOBMere.PutValue ('TAX_LCODETVA'+inttostr(Cpt),FindLibre('TX1',Code));
    if TOBMere.FieldExists(Prefixe+'_LCODETVA'+Suffixe) then
    begin
      TOBMere.PutValue (Prefixe+'_LCODETVA'+Suffixe,FindLibre('TX1',Code));
    end;
    inc(Cpt);
  end;
  FreeAndNil(LaTOBInterm);
end;

procedure TImprPieceViaTOB.AjouteChampsPiedBaseRG (TOBmere,TOBAInsere : TOB);
var Num,IndiceTaxe : integer;
		Suffixe,Prefixe,LastPrefixe : string;
    LaTOBOrig : TOB;
begin
  IndiceTaxe := 0;
  Prefixe := '';
  LastPrefixe := '';
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];
    prefixe := LATOBOrig.getValue('PBR_CATEGORIETAXE');
    if LastPrefixe <> Prefixe Then
    begin
    	IndiceTaxe := 1;
      LastPrefixe := prefixe;
    end else
    begin
    	inc (IndiceTaxe);
    end;
    Suffixe := IntToStr (Indicetaxe);
    if TOBMere.FieldExists (Prefixe+'_BASETAXE'+suffixe) and (TOBMere.getValue('GPP_APPLICRG')='X') then
    begin
    	TOBMere.putValue(Prefixe+'_VALEURTAXE'+suffixe,TOBMere.GetValue(Prefixe+'_VALEURTAXE'+suffixe) - LaTOBOrig.GetValue('PBR_VALEURTAXE'));
    	TOBMere.putValue(Prefixe+'_VALEURDEV'+suffixe,TOBMere.GetValue(Prefixe+'_VALEURDEV'+suffixe) - LaTOBOrig.GetValue('PBR_VALEURDEV'));
    end;
    (*
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := Prefixe+Copy(ChampsOrig,4,255)+Suffixe;
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig)*(-1));
      end else
      begin
        TOBMere.PutValue (ChampsDest,TOBMere.getValue(ChampsDest)-LATOBOrig.GetValue(ChampsOrig));
      end;
    end;
    *)
    if not TOBMere.FieldExists(Prefixe+'_LCODETVA'+Suffixe) then
    begin
      TOBMere.AddChampSupValeur (Prefixe+'_LCODETVA'+Suffixe,
                                 rechdom('GCFAMILLETAXE'+Suffixe,LATOBOrig.GetValue('PBR_FAMILLETAXE'),True));
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsPiedPort (TOBmere,TOBAInsere : TOB);
var ITable,Indice,Num : integer;
		ChampsOrig,ChampsDest,Suffixe : string;
    LaTOBOrig : TOB;
begin
	TOBMere.AddChampSupValeur ('GPT_LIBELLE1','');
	TOBMere.AddChampSupValeur ('GPT_LIBELLE2','');
	TOBMere.AddChampSupValeur ('GPT_LIBELLE3','');
	TOBMere.AddChampSupValeur ('GPT_LIBELLE4','');
	TOBMere.AddChampSupValeur ('GPT_LIBELLE5','');
  iTable := PrefixeToNum('GPT');
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];
    Suffixe := IntToStr (LATOBOrig.getValue('GPT_NUMPORT'));
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := ChampsOrig+Suffixe;
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsParamDoc (TOBMere,TOBAInsere : TOB);
var ITable,Indice,Num : integer;
		ChampsOrig,ChampsDest : string;
    LaTOBOrig : TOB;
begin
  iTable := PrefixeToNum('BPD');
  // Compatibilité avec l'existant n'ayant pas de paramétrage doc
  TOBMEre.AddChampSupValeur ('BPD_TYPESSD',0);
  TOBMEre.AddChampSupValeur ('BPD_TYPEPRES',DOU_TOUS);
  TOBMEre.AddChampSupValeur ('BPD_IMPTOTPAR','X');
  TOBMEre.AddChampSupValeur ('BPD_IMPTOTSPP','X');
  TOBMEre.AddChampSupValeur ('BPD_IMPCOLONNES','-');
  TOBMEre.AddChampSupValeur ('BPD_TYPBLOCNOTE','D');
  TOBMEre.AddChampSupValeur ('BPD_SAUTAPRTXTDEB','-');
  TOBMEre.AddChampSupValeur ('BPD_SAUTAVTTXTFIN','-');
  TOBMEre.AddChampSupValeur ('BPD_IMPRRECPAR','-');
  TOBMEre.AddChampSupValeur ('BPD_IMPDESCRIPTIF','I');
  TOBMEre.AddChampSupValeur ('BPD_IMPMETRE','S');
  TOBMEre.AddChampSupValeur ('BPD_IMPTATOTSIT','-');
  TOBMEre.AddChampSupValeur ('BPD_DESCREMPLACE','-');
  TOBMEre.AddChampSupValeur ('BPD_IMPTABTOTSIT','-'); // Tableau total des situations
  TOBMEre.AddChampSupValeur ('BPD_IMPRECSIT','-'); // recap des situations
  // --
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];

    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := ChampsOrig;
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
    end;
  end;
end;

procedure TImprPieceViaTOB.CreeAdresseFacturation (TobMere : TOB);
begin
  if not TOBMere.FieldExists('FAC_ADRESSE1') then
  	TOBMere.AddChampSupValeur('FAC_ADRESSE1',TOBMere.GetValue('LIV_ADRESSE1'))
  else
  	TOBMere.PutValue('FAC_ADRESSE1',TOBMere.GetValue('LIV_ADRESSE1'));

  if not TOBMere.FieldExists('FAC_ADRESSE2') then
  	TOBMere.AddChampSupValeur('FAC_ADRESSE2',TOBMere.GetValue('LIV_ADRESSE2'))
  else
  	TOBMere.PutValue('FAC_ADRESSE2',TOBMere.GetValue('LIV_ADRESSE2'));

  if not TOBMere.FieldExists('FAC_ADRESSE3') then
  	TOBMere.AddChampSupValeur('FAC_ADRESSE3',TOBMere.GetValue('LIV_ADRESSE3'))
  else
  	TOBMere.PutValue('FAC_ADRESSE3',TOBMere.GetValue('LIV_ADRESSE3'));

  if not TOBMere.FieldExists('FAC_CODEPOSTAL') then
  	TOBMere.AddChampSupValeur('FAC_CODEPOSTAL',TOBMere.GetValue('LIV_CODEPOSTAL'))
  else
  	TOBMere.PutValue('FAC_CODEPOSTAL',TOBMere.GetValue('LIV_CODEPOSTAL'));

  if not TOBMere.FieldExists('FAC_VILLE') then
  	TOBMere.AddChampSupValeur('FAC_VILLE',TOBMere.GetValue('LIV_VILLE'))
  else
  	TOBMere.PutValue('FAC_VILLE',TOBMere.GetValue('LIV_VILLE'));

  if not TOBMere.FieldExists('FAC_LIBELLE') then
  	TOBMere.AddChampSupValeur('FAC_LIBELLE',TOBMere.GetValue('LIV_LIBELLE'))
  else
  	TOBMere.PutValue('FAC_LIBELLE',TOBMere.GetValue('LIV_LIBELLE'));

  if not TOBMere.FieldExists('FAC_LIBELLE2') then
  	TOBMere.AddChampSupValeur('FAC_LIBELLE2',TOBMere.GetValue('LIV_LIBELLE2'))
  else
  	TOBMere.PutValue('FAC_LIBELLE2',TOBMere.GetValue('LIV_LIBELLE2'));
end;

procedure TImprPieceViaTOB.AjouteChampsPieceAdresse (TOBmere,TOBAInsere : TOB);
var ITable,Indice,Num : integer;
		ChampsOrig,ChampsDest,Prefixe : string;
    LaTOBOrig : TOB;
begin
  TOBMere.AddChampSupValeur('FAC_JURIDIQUE','');
  TOBMere.AddChampSupValeur('FAC_NIF','');
  TOBMere.AddChampSupValeur('FAC_ADRESSE1','');
  TOBMere.AddChampSupValeur('FAC_ADRESSE2','');
  TOBMere.AddChampSupValeur('FAC_ADRESSE3','');
  TOBMere.AddChampSupValeur('FAC_CODEPOSTAL','');
  TOBMere.AddChampSupValeur('FAC_VILLE','');
  TOBMere.AddChampSupValeur('FAC_LIBELLE','');
  TOBMere.AddChampSupValeur('FAC_LIBELLE2','');
  TOBMere.AddChampSupValeur('FAC_PAYS','');
  TOBMere.AddChampSupValeur('FAC_INCOTERM','');
  TOBMere.AddChampSupValeur('FAC_EAN','');
  TOBMere.AddChampSupValeur('FAC_LIEUDISPO','');
  TOBMere.AddChampSupValeur('FAC_REGION','');
  //
  TOBMere.AddChampSupValeur('LIV_JURIDIQUE','');
  TOBMere.AddChampSupValeur('LIV_NIF','');
  TOBMere.AddChampSupValeur('LIV_ADRESSE1','');
  TOBMere.AddChampSupValeur('LIV_ADRESSE2','');
  TOBMere.AddChampSupValeur('LIV_ADRESSE3','');
  TOBMere.AddChampSupValeur('LIV_CODEPOSTAL','');
  TOBMere.AddChampSupValeur('LIV_VILLE','');
  TOBMere.AddChampSupValeur('LIV_LIBELLE','');
  TOBMere.AddChampSupValeur('LIV_LIBELLE2','');
  TOBMere.AddChampSupValeur('LIV_PAYS','');
  TOBMere.AddChampSupValeur('LIV_EAN','');
  TOBMere.AddChampSupValeur('LIV_LIEUDISPO','');
  TOBMere.AddChampSupValeur('LIV_REGION','');

  iTable := PrefixeToNum('GPA');
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];
    if LATOBOrig.getValue('GPA_TYPEPIECEADR')='001' Then
    begin
    	Prefixe := 'LIV'
    end else // MODIFBRL 22/07/04 if LATOBOrig.getValue('GPA_TYPEPIECEADR')='002' Then
    begin
    	prefixe := 'FAC';
    end;
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := Prefixe + Copy(ChampsOrig,4,255);
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
    end;
  end;
  // Cas ou une adresse manque
  if TOBAInsere.detail.count = 1 then
  begin
  	LATOBOrig := TOBAInsere.detail[0];
    if LATOBOrig.getValue('GPA_TYPEPIECEADR')='001' Then
    begin
    	Prefixe := 'FAC' // Si l'adresse de livraison existe on ajoute celle de facturation
    end else if LATOBOrig.getValue('GPA_TYPEPIECEADR')='002' Then
    begin
    	prefixe := 'LIV'; // Si l'adresse de facturation existe on ajoute celle de livraison
    end;
    for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
    begin
      ChampsOrig := V_PGI.Dechamps[iTable, Indice].Nom;
      ChampsDest := Prefixe + Copy(ChampsOrig,4,255);
      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end;
    end;
  end;
  If (TOBMere.getValue('FAC_ADRESSE1')='') AND
  	 (TOBMere.getValue('FAC_ADRESSE2')='') AND
  	 (TOBMere.getValue('FAC_ADRESSE3')='') AND
  	 (TOBMere.getValue('FAC_CODEPOSTAL')='') AND
  	 (TOBMere.getValue('FAC_VILLE')='') AND
  	 (TOBMere.getValue('FAC_LIBELLE')='') AND
  	 (TOBMere.getValue('FAC_LIBELLE2')='') then CreeAdresseFacturation (TobMere);

end;

procedure TImprPieceViaTOB.AjouteChampsPieceRG (TOBmere,TOBAInsere : TOB);
var Num : integer;
    LaTOBOrig : TOB;
begin

  TOBMere.AddChampSupValeur ('PRG_TYPERG','HT');
  TOBMere.AddChampSupValeur ('PRG_TAUXRG',0);
  TOBMere.AddChampSupValeur ('PRG_MTRG',0);
  TOBMere.AddChampSupValeur ('PRG_MTRGDEV',0);
  TOBMere.AddChampSupValeur ('PRG_MTTTCRG',0);
  TOBMere.AddChampSupValeur ('PRG_MTTTCRGDEV',0);
  TOBMere.AddChampSupValeur ('PRG_CAUTIONMT',0);
  TOBMere.AddChampSupValeur ('PRG_CAUTIONMTDEV',0);
  TOBMere.AddChampSupValeur ('PRG_NUMCAUTION','');

  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];

    if not TOBMere.FieldExists ('PRG_TYPERG') then
    begin
      TOBMere.AddChampSupValeur ('PRG_TYPERG',LATOBOrig.GetValue('PRG_TYPERG'));
    end else
    begin
      TOBMere.PutValue ('PRG_TYPERG',LATOBOrig.GetValue('PRG_TYPERG'));
    end;

    if not TOBMere.FieldExists ('PRG_TAUXRG') then
    begin
      TOBMere.AddChampSupValeur ('PRG_TAUXRG',LATOBOrig.GetValue('PRG_TAUXRG'));
    end else
    begin
      TOBMere.PutValue ('PRG_TAUXRG',LATOBOrig.GetValue('PRG_TAUXRG'));
    end;

    if not TOBMere.FieldExists ('PRG_MTHTRG') then
    begin
      TOBMere.AddChampSupValeur ('PRG_MTHTRG',LATOBOrig.GetValue('PRG_MTHTRG'));
    end else
    begin
    	TOBMere.PutValue ('PRG_MTHTRG',TOBMere.GetValue('PRG_MTRG')+LATOBOrig.GetValue('PRG_MTHTRG'));
    end;

    if not TOBMere.FieldExists ('PRG_MTHTRGDEV') then
    begin
      TOBMere.AddChampSupValeur ('PRG_MTHTRGDEV',LATOBOrig.GetValue('PRG_MTHTRGDEV'));
    end else
    begin
    	TOBMere.PutValue ('PRG_MTHTRGDEV',TOBMere.GetValue('PRG_MTHTRGDEV')+LATOBOrig.GetValue('PRG_MTHTRGDEV'));
    end;

    if not TOBMere.FieldExists ('PRG_MTTTCRG') then
    begin
      TOBMere.AddChampSupValeur ('PRG_MTTTCRG',LATOBOrig.GetValue('PRG_MTTTCRG'));
    end else
    begin
    	TOBMere.PutValue ('PRG_MTTTCRG',TOBMere.GetValue('PRG_MTTTCRG')+LATOBOrig.GetValue('PRG_MTTTCRG'));
    end;

    if not TOBMere.FieldExists ('PRG_MTTTCRGDEV') then
    begin
      TOBMere.AddChampSupValeur ('PRG_MTTTCRGDEV',LATOBOrig.GetValue('PRG_MTTTCRGDEV'));
    end else
    begin
    	TOBMere.PutValue ('PRG_MTTTCRGDEV',TOBMere.GetValue('PRG_MTTTCRGDEV')+LATOBOrig.GetValue('PRG_MTTTCRGDEV'));
    end;
    //
    if not TOBMere.FieldExists ('PRG_CAUTIONMT') then
    begin
      TOBMere.AddChampSupValeur ('PRG_CAUTIONMT',LATOBOrig.GetValue('PRG_CAUTIONMT'));
    end else
    begin
    	TOBMere.PutValue ('PRG_CAUTIONMT',TOBMere.GetValue('PRG_CAUTIONMT')+LATOBOrig.GetValue('PRG_CAUTIONMT'));
    end;

    if not TOBMere.FieldExists ('PRG_CAUTIONMTDEV') then
    begin
      TOBMere.AddChampSupValeur ('PRG_CAUTIONMTDEV',LATOBOrig.GetValue('PRG_CAUTIONMTDEV'));
    end else
    begin
    	TOBMere.PutValue ('PRG_CAUTIONMTDEV',TOBMere.GetValue('PRG_CAUTIONMTDEV')+LATOBOrig.GetValue('PRG_CAUTIONMTDEV'));
    end;

    if not TOBMere.FieldExists ('PRG_NUMCAUTION') then
    begin
      TOBMere.AddChampSupValeur ('PRG_NUMCAUTION',LATOBOrig.GetValue('PRG_NUMCAUTION'));
    end else
    begin
      TOBMere.PutValue ('PRG_NUMCAUTION',LATOBOrig.GetValue('PRG_NUMCAUTION'));
    end;

  end;
end;

procedure TImprPieceViaTOB.AjouteChampsDOCTEXTEDEBFIN (TOBmere,TOBAInsere : TOB);
var Num : integer;
		ChampsOrig,ChampsDest,Suffixe : string;
    LaTOBOrig : TOB;
begin
  TOBMere.AddChampSupValeur ('LO_OBJET_ENTETEGEN',#0);
  TOBMere.AddChampSupValeur ('LO_OBJET_PIEDGEN',#0);
    For Num := 0 To TOBAInsere.detail.count -1 do
    begin
      LATOBOrig := TOBAInsere.detail[Num];

      if LATOBOrig.getValue('LO_RANGBLOB')=1 Then Suffixe := '_ENTETEGEN'
                                             else Suffixe := '_PIEDGEN';

      ChampsOrig := 'LO_OBJET';
      ChampsDest := ChampsOrig+Suffixe;

      if not TOBMere.FieldExists (ChampsDest) then
      begin
        TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
      end else
      begin
        TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsINTEXTEDEBFIN (TOBmere,TOBAInsere : TOB);
var Num : integer;
		ChampsOrig,ChampsDest,Suffixe : string;
    LaTOBOrig : TOB;
begin
  TOBMere.AddChampSupValeur ('LO_OBJET_ENTETEDOC',#0);
  TOBMere.AddChampSupValeur ('LO_OBJET_PIEDDOC',#0);
  For Num := 0 To TOBAInsere.detail.count -1 do
  begin
  	LATOBOrig := TOBAInsere.detail[Num];

    if LATOBOrig.getValue('LO_RANGBLOB')=1 Then Suffixe := '_ENTETEDOC'
                                           else Suffixe := '_PIEDDOC';
    ChampsOrig := 'LO_OBJET';
    ChampsDest := ChampsOrig+Suffixe;

    if not TOBMere.FieldExists (ChampsDest) then
    begin
      TOBMere.AddChampSupValeur (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
    end else
    begin
      TOBMere.PutValue (ChampsDest,LATOBOrig.GetValue(ChampsOrig));
    end;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsOUVRAGE (TOBmere,TOBAINSERE ,TOBLigne : TOB);
var QteDuDetail,QteDuPV,Montant : Double;
		EnHt : boolean;
    DEv : RDevise;
		ITable,Indice: integer;
    NewChamp : string;
begin
  if TOBAinsere = nil then exit;
	FillChar(DEV, Sizeof(DEV), #0);
  DEV.Code := TOBLigne.GetValue('GL_DEVISE');
  GetInfosDevise(DEV);
	EnHt := (TOBLigne.GetValue('GL_FACTUREHT')='X');
  iTable := PrefixeToNum('BLO');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	if V_PGI.Dechamps[iTable, Indice].Nom = 'BLO_NUMORDRE' Then continue;
  	// ca va pas non...
  	if V_PGI.Dechamps[iTable, Indice].Nom = 'BLO_BLOCNOTE' then continue;
    // --
  	NewChamp := 'GL'+Copy(V_PGI.Dechamps[iTable, Indice].Nom,4,255);
    if TOBMere.FieldExists (newChamp) then
    begin
    	TOBMere.PutValue (NewChamp,TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
  TOBMere.PutValue ('GL_TYPEPRESENT',TobLigne.getValue('GL_TYPEPRESENT'));
  //
  QteDudetail := TOBAINSERE.GetValue('BLO_QTEDUDETAIL');
  if QteDUdetail = 0 then qteduDetail := 1;
  QteDuPv := TOBAINSERE.GetValue('BLO_PRIXPOURQTE');
  if QteDUpv = 0 then qtedupv := 1;

  if (IsVariante(TOBAInsere)) or (IsVariante(TOBLigne)) then
  begin
  	TOBMEre.PutValue ('ISDETOUVVAR','X');
  end else
  begin
  	TOBMEre.PutValue ('ISDETOUVSTD','X');
  end;
//
  if TOBAINSERE.GetValue('BLO_TYPEARTICLE') <> 'POU' then
  begin
    if Enht then
      Montant := arrondi(TOBAINSERE.GetValue('BLO_PUHTDEV') * (TOBLigne.getValue('GL_QTEFACT')) * (TOBAINSERE.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)),
        DEV.Decimale)
    else
      Montant := arrondi(TOBAINSERE.GetValue('BLO_PUTTCDEV') * (TOBLigne.getValue('GL_QTEFACT')) * (TOBAINSERE.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)),
        DEV.Decimale);
  end;
//
  TOBmere.PutValue('GL_REFARTSAISIE', TOBAINSERE.GetValue('BLO_CODEARTICLE'));
  TOBmere.PutValue('GL_REFARTTIERS', TOBAINSERE.GetValue('BLO_ARTICLE'));
  TOBmere.PutValue('GL_ARTICLE', TOBAINSERE.GetValue('BLO_ARTICLE'));
  TOBmere.PutValue('GL_CODEARTICLE', TOBAINSERE.GetValue('BLO_CODEARTICLE'));
	TOBmere.PutValue('GL_LIBELLE', TOBAINSERE.GetValue('BLO_LIBELLE'));
  if TOBAINSERE.GetValue('BLO_TYPEARTICLE') = 'POU' then
  	TOBmere.PutValue('GL_QTEFACT', TOBAINSERE.GetValue('BLO_QTEFACT') / QteDuDetail)
  else TOBmere.PutValue('GL_QTEFACT', (TOBAINSERE.GetValue('BLO_QTEFACT') * TOBLigne.GetValue('GL_QTEFACT')) / QteDuDetail);
  TOBmere.PutValue('GL_QUALIFQTEVTE', TOBAINSERE.GetValue('BLO_QUALIFQTEVTE'));
	if TOBAINSERE.GetValue('BLO_TYPEARTICLE') <> 'POU' then
  begin
  	if EnHt then TOBmere.PutValue('GL_PUHTDEV', TOBAINSERE.GetValue('BLO_PUHTDEV') / QteDupv)
    				else TOBmere.PutValue('GL_PUTTCDEV', TOBAINSERE.GetValue('BLO_PUTTCDEV') / QteDupv);
  end;
  if TOBAINSERE.GetValue('BLO_TYPEARTICLE') <> 'POU' then
  begin
    if EnHt then TOBmere.PUtValue('GL_MONTANTHTDEV', Montant)
    				else TOBmere.PUtValue('GL_MONTANTTTCDEV', Montant);
  end;
	DefiniAffichageLigne (TOBMere);
end;

procedure TImprPieceViaTOB.AjouteTOB(TOBMere: TOB; CodeTraitement: string; TOBAInsere: TOB; TOBPrec : TOB);
begin

  if CodeTraitement = 'ACOMPTESCPTA' then
  begin
  	AjouteChampsAcomptesCpta (TOBMere);
  end else if CodeTraitement = 'AVANCEMENTG' then
  begin
  	AjouteChampsAvancementPiece (TOBMere);
  end else if CodeTraitement = 'TABLEAUSITUATIONS' then
  begin
  	AjouteChampsSituation (TOBMere);
  end else if CodeTraitement = 'AVANCLIGNE' then
  begin
  	CumuleChampsAvancLigne (TOBMere,TOBAInsere);
  end else if CodeTraitement = 'PIECE' then
  begin
  	AjouteChampsPiece (TOBMere,TOBAInsere);
  end else if CodeTraitement = 'BTPIECEMILIEME' then
  begin
  	AjouteChampsMillieme (TOBMere,fTOBRepart);
  end else if CodeTraitement = 'PARAMDOC' then
  begin
  	AjouteChampsParamDoc (TOBMere,TOBAInsere);
  end else if CodeTraitement = 'PARPIECE' then
  begin
  	AjouteChampsParPiece (TOBMere,TOBAInsere);
  end else if CodeTraitement = 'DOCTEXTEDEBFIN' then
  begin
  	AjouteChampsDOCTEXTEDEBFIN (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'INTEXTEDEBFIN' then
  begin
  	AjouteChampsINTEXTEDEBFIN (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'TIERS' then
  begin
  	AjouteChampsTiers (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'AFFAIRE' then
  begin
  	AjouteChampsAffaire (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'AFFAIREDEV' then
  begin
  	AjouteChampsAffaireDEVIS (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIEDBASE' then
  begin
  	AjouteChampsPiedBase (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIEDBASERG' then
  begin
  	AjouteChampsPiedBaseRG (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIEDECHE' then
  begin
  	AjouteChampsPiedEche (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIEDPORT' then
  begin
  	AjouteChampsPiedPort (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIECEADRESSE' then
  begin
  	AjouteChampsPieceAdresse (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'PIECERG' then
  begin
  	AjouteChampsPieceRG (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'DEVISES' then
  begin
  	AjouteChampsDEVISE (TOBmere);
  end else if CodeTraitement = 'LIGNES' then
  begin
  	AjouteChampsLIGNE (TOBmere,TOBAINSERE);
  end else if CodeTraitement = 'LIGNEFAC' then
  begin
  	AjouteChampsLIGNE (TOBmere,TOBAINSERE,True);
  end else if CodeTraitement = 'ARTICLES' then
  begin
  	AjouteChampsARTICLES (TOBmere,TOBAINSERE);
  end else if CodeTraitement = 'OUVRAGE' then
  begin
  	AjouteChampsOUVRAGE (TOBmere,TOBAINSERE,TOBPrec);
  end else if CodeTraitement = 'METRE' then
  begin
  	AjouteChampsMETRE (TOBmere);
  end else if CodeTraitement = 'PARAG' then
  begin
  	AjouteChampsPARAG (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'LESPORTS' then
  begin
  	AjoutelesPORTS (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'TIMBRES' then
  begin
  	AjouteleMtTimbre (TOBmere,TOBAInsere);
  end else if CodeTraitement = 'METRESLIG' then
  begin
  	AjoutelesMETRESLIG (TOBmere,TOBAInsere);
  end;

end;

procedure TImprPieceViaTOB.associeTOBs(TOBPiece, TOBBases, TOBEches,
                                      TOBPorcs, TOBTiers, TOBArticles, TOBComms, TOBAdresses, TOBNomenClature,
                                      TOBDesLots, TOBSerie, TOBAcomptes, TOBAffaire, TOBOuvrage, TOBLienOle,
                                      TOBPieceRg, TOBBasesRG, TOBFormuleVar,TOBMEtre,TOBRepart,TOBMetres,TOBTimbres : TOB);
var QQ : TQuery;
begin

	fTobPiece := TOBPiece;
  fTOBBases := TOBBases;
  fTOBEches := TOBEches;
  fTOBPorcs := TOBPorcs;
  fTOBTiers := TOBTiers;
  fTOBMetres := TOBmetres;
  fTOBArticles := TOBArticles;
  fTOBComms := TOBComms;
  fTOBAdresses := TOBAdresses;
  fTOBNomenclature := TOBNomenclature;
  fTOBLOTS := TOBDesLots;
  fTOBSerie := TOBSerie;
  fTOBAcomptes := TOBAcomptes;
  fTOBAffaire := TOBAffaire;
  if fTOBPiece.getValue('GP_AFFAIREDEVIS') <> '' then
  begin
    fTOBAffaireDev := findCetteAffaire(fTOBPiece.getValue('GP_AFFAIREDEVIS'));
    if fTOBAffaireDev = nil then StockeCetteAffaire (fTOBPiece.getValue('GP_AFFAIREDEVIS'))
  end;
  fTOBOuvrage := TOBOuvrage;
  fTOBLIENOLE := TOBLienOle;
  fTOBPieceRG := TOBPieceRG;
  fTOBBasesRG := TOBBasesRG;
  fTOBFormuleVar := TOBFormuleVar;
  fTOBMetre := TOBmetre ;
  fTOBRepart := TOBRepart;
  fTOBTimbres  := TOBTimbres;

  FillChar(fCleDoc, Sizeof(fCleDoc), #0);
  fCleDoc.NaturePiece := TOBPiece.getValue('GP_NATUREPIECEG');
  fCleDoc.DatePiece := TOBPiece.getValue('GP_DATEPIECE');
  fCleDoc.Souche := TOBPiece.getValue('GP_SOUCHE');
  fCleDoc.NumeroPiece := TOBPiece.getValue('GP_NUMERO');
  fCleDoc.Indice := TOBPiece.getValue('GP_INDICEG');
  if fcledoc.Naturepiece <> '' then
  begin
  	QQ := OpenSql ('SELECT * FROM PARPIECE WHERE GPP_NATUREPIECEG="'+fCledoc.NaturePiece+'"',true,-1,'',true);
    ftobParPiece.SelectDB ('',QQ);
    ferme (QQ);
  end;
end;

constructor TImprPieceViaTOB.create (TheFiche : TForm);
begin
  TheRepartTva := TREPARTTVAMILL.create (TheFiche) ;
  fTOBPieceImp := TOB.create ('LA PIECE A IMPRIMER',nil,-1);
  fTOBPieceRecap := TOB.Create ('LE RECAP',nil,-1);
  fTOBParPiece := TOB.Create ('PARPIECE',nil,-1);
  fTOBCodeTaxes := TOB.create ('LES TAXES',nil,-1);
  fTOBSituations := TOB.Create ('LES SITUATIONS',nil,-1);
  //
  fInternalWindow := TToolWindow97.create(fform);
  fInternalWindow.Parent := fform;
  fTexte := THRichEditOLE.Create (fInternalWindow);
  ftexte.Parent := fInternalWindow;
  ftexte.text := '';
  ftexte.Visible := false;
  fInternal := false;
  WithRecap := false;
//  TheMetre:= TStockMetre.create; ;
end;

destructor TImprPieceViaTOB.Destroy;
begin
	if fInternal then
  begin
  	DetruitTout;
  end;
  if TheRepartTva <> nil then FreeAndNil(TheRepartTva);
  if fTOBParPiece <> nil then FreeAndNil(fTOBParPiece);
  if fTOBPieceImp <> nil then FreeAndNil(fTOBPieceImp);
  if fTOBPieceRecap <> nil then FreeAndNil(fTOBPieceRecap);
  if fTOBCodeTaxes <> nil then FreeAndNil(fTOBCodeTaxes);
  if fTOBSituations <> nil then FreeAndNil(fTOBSituations);
  if ftexte <> nil then FreeAndNil(ftexte);
  if fInternalWindow <> nil then FreeAndNil(fInternalWindow);
//  TheMEtre.free;
  inherited;
end;

function TImprPieceViaTOB.InsereTOB (NomTable : string;TOBmere : TOB; WithNewNumOrdre : boolean=true) : TOB;
begin
	result := TOB.Create(NomTable,TOBMere,-1);
  if (NomTable = 'LIGNE') and (WithNewNumOrdre) Then
  begin
  	inc(flastNumordre);
  	AddLesSupLigne (result,false);
    AddSupLignesEdt (result);
  	result.AddChampSupValeur('NUMORDRE',flastNumOrdre);
  	result.AddChampSupValeur('SAUTDEPAGE','-');
  end;
end;

function TImprPieceViaTOB.SetQueryForOldSituations : Widestring;
begin
  result := 'SELECT * FROM BSITUATIONS WHERE '+
            'BST_SSAFFAIRE="'+ fTOBPiece.getValue('GP_AFFAIREDEVIS')+'" AND BST_NUMEROFAC <= ' +
            InttoStr(fcledocFacCur.NumeroPiece)+' ORDER BY BST_NUMEROSIT';
end;

function TImprPieceViaTOB.isExistsMemo(LaLigne:TOB) : boolean;
var cledoc : r_cledoc;
    RefPiece,requete : string;
    QQ : TQuery;
begin
  DecodeRefPiece (LaLigne.getValue('GL_PIECEPRECEDENTE'),cledoc);
  RefPiece := EncoderefSel (cledoc);
  Requete := 'SELECT BMF_NATUREPIECEG,BMF_SOUCHE,BMF_NUMERO,BMF_INDICEG FROM BTMEMOFACTURE '+
             'WHERE BMF_DEVISPRINC=(SELECT BMF_DEVISPRINC FROM BTMEMOFACTURE WHERE BMF_DEVIS="'+RefPiece+'")';
  QQ := OpenSql (requete,true,-1,'',true);
  result := not QQ.eof;
  ferme (QQ);
end;

function TImprPieceViaTOB.IsExistsMemoFacturation : boolean;
var Indice : integer;
    first : boolean;
    LaLIgne : TOB;
    TypeLigne : string;
begin
  result := false;
  if not FAvancement then exit;
  first := false;
  for Indice := 0 to fTobPiece.detail.count -1 do
  begin
    LaLigne := fTobPiece.detail[Indice];
    TypeLigne := LaLigne.GetValue('GL_TYPELIGNE');
    if (first) and (TypeLigne = 'ART') and (LaLIgne.GetValue('GL_PIECEPRECEDENTE')<>'') then
    begin
      result := isExistsMemo(LaLigne);
      break;
    end;
  end;
end;

procedure TImprPieceViaTOB.PositionneMarcheFromPiece (TheRecap,ThePiece : TOB);
begin
  TheRecap.PutValue ('NUMSIT',ThePiece.GetValue ('NUMSIT'));
  TheRecap.PutValue ('MAXNUMSIT',ThePiece.GetValue ('MAXNUMSIT'));
  TheRecap.PutValue ('DATESIT',ThePiece.GetValue ('DATESIT'));
  TheRecap.PutValue ('TOTSITPREC',ThePiece.GetValue ('TOTSITPREC'));
  TheRecap.PutValue ('TOTSITPRECBRUT',ThePiece.GetValue ('TOTSITPRECBRUT'));
  TheRecap.PutValue ('TOTSITPRECTTC',ThePiece.GetValue ('TOTSITPRECTTC'));
  TheRecap.PutValue ('TOTREMPREC',ThePiece.GetValue ('TOTREMPREC'));
  TheRecap.PutValue ('TOTESCPREC',ThePiece.GetValue ('TOTESCPREC'));
  TheRecap.PutValue ('TOTPORTPREC',ThePiece.GetValue ('TOTPORTPREC'));
  TheRecap.PutValue ('TOTPORTSIT',ThePiece.GetValue ('TOTPORTSIT'));
  TheRecap.PutValue ('TOTMARCHE',ThePiece.GetValue ('TOTMARCHE'));
  TheRecap.PutValue ('TOTMARCHENET',ThePiece.GetValue ('TOTMARCHENET'));
  TheRecap.PutValue ('TOTMARCHETTC',ThePiece.GetValue ('TOTMARCHETTC'));
  TheRecap.PutValue ('TOTCUMULEFACT',ThePiece.GetValue ('TOTCUMULEFACT'));
  TheRecap.PutValue ('TOTSITUATION',ThePiece.GetValue ('TOTSITUATION'));
  TheRecap.PutValue ('TOTSOLDE',ThePiece.GetValue ('TOTSOLDE'));
  TheRecap.PutValue ('TOTREGLE',ThePiece.GetValue ('TOTREGLE'));
end;

procedure TImprPieceViaTOB.PreparationEtat;
{$IFDEF BTP}
var Indice,IndiceOuv : integer;
		ThePiece,TheLigne,TheArticle,LaLigne,TheOuvrage,TheParag,LaTotalisation,TheRecap : TOB;
    TOBParamEdt,TOBEntetePiedDoc,TOBOuv,TOBO,TOBPARAG : TOB;
    Req : string;
    QQ : Tquery;
    NbrLignes : integer;
    FromOuvrage,First : boolean;
    TypeLigne : string;
    Niveau : integer;
    MessAttente : TFsplashScreen;
    FromMemoFacturation : boolean;
{$ENDIF}
begin
  FromMemoFacturation := IsExistsMemoFacturation;
  first := true;
(*
  MessAttente := TFsplashScreen.Create (application);
  MessAttente.Label1.Caption := 'Préparation des données en cours ...';
  MessAttente.Animate1.Active := true;
  MessAttente.Show;
  MessAttente.Refresh;
*)
	fTOBPieceImp.ClearDetail;
  fTOBPieceRecap.clearDetail; 
  SetMode; // --> facture Avancement ou demande d'acompte ??
{$IFDEF BTP}
  NbrLignes := 0;
  fLastNumordre := 0;
  prepareTVA;
  //
  fillchar (fcledocFacCur,sizeof(fcledocfaccur),#0);
  fcledocFacCur.NaturePiece := fTOBpiece.GetValue('GP_NATUREPIECEG');
  fcledocFacCur.Souche := fTOBpiece.GetValue('GP_SOUCHE');
  if InCreation then fcledocFacCur.NumeroPiece := 0
                else fcledocFacCur.NumeroPiece := fTOBpiece.GetValue('GP_NUMERO');
  fcledocFacCur.Indice := fTOBpiece.GetValue('GP_INDICEG');
  //
  TOBParamEdt := TOB.Create ('LES PARAMS EDT',nil,-1);
  TOBEntetePiedDoc := TOB.Create ('LES ENTETES ET PIED',nil,-1);
  TOBParag := TOB.Create ('LES PARAGRAPHES',nil,-1);
  // Récupération du paramétrage d'édition
  Req := 'SELECT * FROM BTPARDOC WHERE BPD_NATUREPIECE="'+fcledocFacCur.NaturePiece+'" AND '+
  			 'BPD_SOUCHE="'+fcledocFacCur.Souche+'" AND '+
         '((BPD_NUMPIECE=0) OR (BPD_NUMPIECE='+InttoStr(fcledocFacCur.NumeroPiece)+')) ORDER BY BPD_NUMPIECE';
  QQ := OpenSql (Req,True,-1,'',true);
  if not QQ.eof Then TOBParamEdt.loadDetailDb ('BTPARDOC','','',QQ,True);
  Ferme (QQ);
  // récupération des bloc-notes entete et pied
  req := 'SELECT LO_RANGBLOB,LO_OBJET FROM LIENSOLE WHERE LO_TABLEBLOB="GP" AND LO_IDENTIFIANT="'+
  				fcledocFacCur.NaturePiece+':'+fcledocFacCur.Souche+':0:0"';
  QQ := OpenSql (Req,True,-1,'',true);
  if not QQ.eof Then TOBEntetePiedDoc.loadDetailDb ('LIENSOLE','','',QQ,True);
  Ferme (QQ);
  if fAvancement then
  begin
    Req := SetQueryForOldSituations; // no country for old men ^^
    // récupération des éléments de chiffrage des situations incluant aussi la courante
    QQ := OpenSql (Req,True,-1,'',true);
    if not QQ.eof Then fTOBSituations.loadDetailDb ('BSITUATIONS','','',QQ,false);
    Ferme (QQ);
    SetMontantregleSituations;
  end;
	TRY
		if (GetInfoParPiece(fTOBpiece.GetValue('GP_NATUREPIECEG'), 'GPP_ESTAVOIR') = 'X') then
    begin
      InverseLesPieces(fTOBPiece, 'PIECE');
      InverseLesPieces(fTOBBases, 'PIEDBASE');
      InverseLesPieces(fTOBEches, 'PIEDECHE');
      InverseLesPieces(fTOBPorcs, 'PIEDPORT');
      InverseLesPieces(fTOBPieceRG, 'PIECERG');
      InverseLesPieces(fTOBBasesRG, 'PIEDBASERG');
    end;
		ThePiece := InsereTOB('PIECE',fTOBPieceImp);  TheRecap :=InsereTOB('PIECE',fTOBPieceRecap);
    PreparePiedbase (ThePiece);
    AjouteTOB (ThePiece,'PIECE',fTobPiece);
    AjouteTOB (ThePiece,'BTPIECEMILIEME',fTobrepart);
    AjouteTOB (ThePiece,'PARAMDOC',TOBParamEdt);
    AjouteTOB (ThePiece,'PARPIECE',TOBParPiece);
    AjouteTOB (ThePiece,'DOCTEXTEDEBFIN',TOBEntetePiedDoc);
    AjouteTOB (ThePiece,'INTEXTEDEBFIN',fTOBLIENOLE);
    AjouteTOB (ThePiece,'TIERS',fTOBTiers);
    AjouteTOB (ThePiece,'AFFAIRE',fTOBAffaire);
    AjouteTOB (ThePiece,'AFFAIREDEV',fTOBAffaireDev);
    AjouteTOB (ThePiece,'PIEDBASE',fTOBBases);
    AjouteTOB (ThePiece,'PIEDBASERG',fTOBBasesRG);
    AjouteTOB (ThePiece,'PIEDECHE',fTOBEches);
    AjouteTOB (ThePiece,'PIEDPORT',fTOBPorcs);
    AjouteTOB (ThePiece,'PIECEADRESSE',fTOBAdresses);
    AjouteTOB (ThePiece,'PIECERG',fTOBPieceRG);
    AjouteTOB (ThePiece,'DEVISES',nil);
    AjouteTOB (ThePiece,'ACOMPTESCPTA',nil);
    AjouteTOB (ThePiece,'TIMBRES',fTOBTimbres);
    if fAvancement then
    begin
      AjouteTOB (ThePiece,'AVANCEMENTG',nil); // Mise en place des infos d'avancement général pièce
    end;
    ThePiece.AddChampSupValeur('NBRLIGNES',0);
    if (fAvancement) and (ThePiece.GetValue('BPD_IMPTABTOTSIT')='X') then
    begin
      PreparePiedbase (TheRecap);
      AjouteTOB (TheRecap,'PIECE',fTobPiece);
      AjouteTOB (TheRecap,'BTPIECEMILIEME',fTobrepart);
      AjouteTOB (TheRecap,'PARAMDOC',TOBParamEdt);
      AjouteTOB (TheRecap,'PARPIECE',TOBParPiece);
      AjouteTOB (TheRecap,'DOCTEXTEDEBFIN',TOBEntetePiedDoc);
      AjouteTOB (TheRecap,'INTEXTEDEBFIN',fTOBLIENOLE);
      AjouteTOB (TheRecap,'TIERS',fTOBTiers);
      AjouteTOB (TheRecap,'AFFAIRE',fTOBAffaire);
    	AjouteTOB (TheRecap,'AFFAIREDEV',fTOBAffaireDev);
      AjouteTOB (TheRecap,'PIEDBASE',fTOBBases);
      AjouteTOB (TheRecap,'PIEDBASERG',fTOBBasesRG);
      AjouteTOB (TheRecap,'PIEDECHE',fTOBEches);
      AjouteTOB (TheRecap,'PIEDPORT',fTOBPorcs);
      AjouteTOB (TheRecap,'PIECEADRESSE',fTOBAdresses);
      AjouteTOB (TheRecap,'PIECERG',fTOBPieceRG);
      AjouteTOB (TheRecap,'DEVISES',nil);
      AjouteTOB (TheRecap,'ACOMPTESCPTA',nil);
      AjouteTOB (TheRecap,'AVANCEMENTG',nil); // Mise en place des infos d'avancement général pièce
    	AjouteTOB (TheRecap,'TIMBRES',fTOBTimbres);
      //
      TheRecap.AddChampSupValeur('NBRLIGNES',0);
    end;
    //
    if not FromMemoFacturation then
    begin
      SetMontantMarcheOldVersion (ThePiece);
      PositionneMarcheFromPiece (TheRecap,ThePiece);
    end;
    //
    for Indice := 0 to fTobPiece.detail.count -1 do
    begin
      LaLigne := fTobPiece.detail[Indice];
      TypeLigne := LaLigne.GetValue('GL_TYPELIGNE');
      Niveau := LaLigne.GetValue('GL_NIVEAUIMBRIC');
      if (FromMemoFacturation) and (fAvancement)  and (first) and (TypeLigne = 'ART') and (LaLIgne.GetValue('GL_PIECEPRECEDENTE')<>'') then
      begin
        SetMontantMarche(ThePiece,LaLigne);
        PositionneMarcheFromPiece (TheRecap,ThePiece);
        first := false;
      end;
      if LaLigne.GetValue('GL_NONIMPRIMABLE')='X' Then Continue;
      if IsFinParagraphe(LaLigne) and (Niveau = 1) and (ThePiece.GetValue('BPD_IMPTOTPAR')<>'X') then Continue;
      if IsFinParagraphe(LaLigne) and (Niveau > 1) and (ThePiece.GetValue('BPD_IMPTOTSSP')<>'X') then Continue;
      if IsLigneDetail(nil,LaLigne) then continue;

      TheLigne := InsereTOB ('LIGNE',ThePiece);
      //
    	if (fLastNumOrdre = 1) and
//      	 (not IsBlocNoteVide(ThePiece.getValue('LO_OBJET_ENTETEDOC'))) and
         (ThePiece.getValue('BPD_SAUTAPRTXTDEB')='X') Then
         			TheLigne.PutValue('SAUTDEPAGE','X');

      TheArticle := fTOBArticles.FindFirst(['GA_ARTICLE'],[LaLigne.getValue('GL_ARTICLE')],true);
      AjouteTOB (TheLigne,'ARTICLES',TheArticle);
      AjouteTOB (TheLigne,'LIGNES',LaLigne);
      AjouteTOB (TheLigne,'LIGNEFAC',LaLigne);
    	if fAvancement then
    	begin
      	AjouteTOB (ThePiece,'AVANCLIGNE',LaLigne); // cumul sur entete de pièce
      end;
      if GetParamSocSecur('SO_METRESEXCEL',False) then AjouteTOB (TheLigne,'METRE',nil);
      // Gestion du recap des paragraphes
      if (ThePIece.getValue('BPD_IMPRECPAR')='X') then
      begin
      	if IsDebutParagraphe (LaLigne) Then
        begin
          TheParag := InsereTOB('LIGNE',TOBParag,False);
          LaTotalisation := FindLaFinParag (LaLigne,Indice);
          AjouteTOB (TheParag,'PARAG',TheLigne);
          PoselesTotaux (ThePiece,Theparag,LaTotalisation);
        end;
      end;
      //
      LaLigne.AddChampSupValeur('TYPEPRESENT',LaLigne.GetValue('GL_TYPEPRESENT'));
      if ThePiece.getValue('BPD_TYPESSD') = -1 then
      begin
      	LaLigne.PutValue('TYPEPRESENT',DOU_AUCUN);
      end else if ThePiece.GetValue('BPD_TYPESSD') > 0 then
      begin
      	LaLigne.PutValue('TYPEPRESENT',ThePiece.GetValue('BPD_TYPESSD'));
      end;
      //
      // Ajout des lignes de métrés s'il y en a  et si demandé
      //
      if ThePiece.getValue('BPD_IMPMETRE')='T' then
      begin
      	AlimentemetresLig (ThePiece,Laligne,Laligne.getValue('GL_NUMORDRE'),fTOBmetres);
      end;
      //
      if (LaLigne.GetValue('GL_TYPEARTICLE') <> 'ARP') and
      	 (LaLigne.GetValue('GL_INDICENOMEN')<>0) and
      	 (LaLigne.GetValue('TYPEPRESENT')<>DOU_AUCUN) then
      begin
      	FromOuvrage := false;
        TOBOuv := fTOBOuvrage.Detail[LaLigne.GetValue('GL_INDICENOMEN')-1];
        if TOBOUv = nil then
        begin
        	TOBOuv := fTOBNomenclature.Detail[LaLigne.GetValue('GL_INDICENOMEN')-1];
        end else FromOuvrage := true;
        if TOBOUV <> nil then
        begin
          for IndiceOuv := 0 to TOBOUV.detail.count -1 do
          begin
          	TOBO := TOBOUV.detail[IndiceOuv];
            if FromOuvrage Then
            begin
            	TheOuvrage := InsereTOB ('LIGNE',ThePiece);
      				TheArticle := fTOBArticles.FindFirst(['GA_ARTICLE'],[TOBO.getValue('BLO_ARTICLE')],true);
      				AjouteTOB (TheOuvrage,'ARTICLES',TheArticle);
              AjouteTOB (TheOuvrage,'OUVRAGE',TOBO,LaLigne);
      				AjouteTOB (TheLigne,'METRE',nil);
            end else
            begin
            	TheOuvrage := InsereTOB ('LIGNE',ThePiece);
      				TheArticle := fTOBArticles.FindFirst(['GA_ARTICLE'],[TOBO.getValue('GLN_ARTICLE')],true);
      				AjouteTOB (TheOuvrage,'ARTICLES',TheArticle);
              AjouteTOB (TheOuvrage,'NOMENCLATURE',TOBO);
      				AjouteTOB (TheLigne,'METRE',nil);
            end;
          end;
        end;
      end;
    end;
    ThePiece.PutValue('NBRLIGNES',fLastNumordre);
    if TOBParag.detail.count > 0 then
    begin
    	AlimenteTotauxParag (ThePiece,TOBparag);
    end;
    //
    if (fAvancement) and (ThePiece.GetValue('BPD_IMPRECSIT')='X') then
    begin
      AlimenteTableauSituations (ThePiece);
    end;
    if (fAvancement) and (ThePiece.GetValue('BPD_IMPTABTOTSIT')='X') then
    begin
      DefiniRecapTotalSit (TheRecap);
      if ThePiece.GetValue('BPD_IMPRECSIT')='X' then AlimenteTableauSituations (TheRecap);
    end;
    //
    if fTOBPorcs.detail.count > 0 then
    begin
    	AlimentePort(ThePiece);
    end;
		if (GetInfoParPiece(fTOBpiece.GetValue('GP_NATUREPIECEG'), 'GPP_ESTAVOIR') = 'X') then
    begin
      InverseLesPieces(fTOBPiece, 'PIECE');
      InverseLesPieces(fTOBBases, 'PIEDBASE');
      InverseLesPieces(fTOBEches, 'PIEDECHE');
      InverseLesPieces(fTOBPorcs, 'PIEDPORT');
      InverseLesPieces(fTOBPieceRG, 'PIECERG');
      InverseLesPieces(fTOBBasesRG, 'PIEDBASERG');
    end;

  FINALLY
  	TOBParamEdt.free;
    TOBEntetePiedDoc.free;
    TOBParag.free;
(*
    MessAttente.free; MessAttente := nil;
*)
  END;
{$ENDIF}
end;

procedure TImprPieceViaTOB.AlimenteTotauxParag (ThePiece,TOBparag : TOB);
var Indice,TheOrdre : integer;
		TOBLigne,TOBL : TOB;
begin
	for Indice := 0 to TOBparag.detail.count -1 do
  begin
  	TOBLigne := TOBParag.detail[Indice];
    TOBL := InsereTOB ('LIGNE',ThePiece);
    TheOrdre := TOBL.GetValue('GL_NUMORDRE');
    TOBL.Dupliquer (TOBLigne,false,true);
    TOBL.PutValue('GL_NUMORDRE',TheOrdre); // retablissement
  	if Indice = 0 then TOBL.PutValue ('ISDEBEDTPAR','X');
  	if Indice = TOBparag.detail.count -1 then TOBL.PutValue ('ISFINEDTPAR','X');
  end;
end;

procedure TImprPieceViaTOB.prepareTVA;
var QQ: TQUERY;
begin
	fTOBCodeTaxes.clearDetail;
  QQ := OpenSql ('SELECT * FROM CHOIXCOD WHERE CC_TYPE IN ("TX1","TX2","GX3","GX4","GX5")',True,-1,'',true);
  if not QQ.eof then
  begin
    fTOBCodeTaxes.LoadDetailDB ('CHOIXCOD','','',QQ,false,true);
  end;
  ferme (QQ);
end;

procedure TImprPieceViaTOB.PreparePiedbase(TOBMere: TOB);
var Indice,IndSuiv : integer;
		UnChamp : String;
begin
  for Indice := 1 to 5 do
  begin
  	For indSuiv := 1 to 5 do
    begin
      UnChamp := 'TX'+IntTostr(Indice)+'_LCODETVA'+IntTostr(IndSUiv);
      TOBMERE.AddChampSupValeur (UnChamp,'');
      UnChamp := 'TX'+IntToStr(Indice)+'_BASETAXE'+IntTostr(IndSUiv);
      TOBMERE.AddChampSupValeur (UnChamp,0);
      UnChamp := 'TX'+IntToStr(Indice)+'_TAUXTAXE'+IntTostr(IndSUiv);
      TOBMERE.AddChampSupValeur (UnChamp,0);
      UnChamp := 'TX'+IntToStr(Indice)+'_VALEURTAXE'+IntTostr(IndSUiv);
      TOBMERE.AddChampSupValeur (UnChamp,0);
      UnChamp := 'TX'+IntToStr(Indice)+'_VALEURDEV'+IntTostr(IndSUiv);
      TOBMERE.AddChampSupValeur (UnChamp,0);
    end;
  end;
end;

function TImprPieceViaTOB.FindLibre(Prefixe, Code: string): string;
var ThisTOB : TOB;
begin
	result := '';
  ThisTob := fTOBCodeTaxes.findFirst(['CC_TYPE','CC_CODE'],[Prefixe,Code],true);
  if ThisTOB <> nil then
  begin
  	result := ThisTOB.GetValue('CC_LIBRE');
  end;
end;

(*
procedure TImprPieceViaTOB.ReDefiniNumLig(ThePiece: TOB);
var Indice : integer;
begin
	for Indice := 0 to ThePiece.detail.count -1 do
  begin
  	ThePiece.putValue('GL_NUMLIGNE',Indice+1);
  end;
end;
*)

function TImprPieceViaTOB.IsBlocNoteVide (BlocNote : String; Fichier : boolean=False) : boolean;
begin
	result := true;
	if (Fichier) and (Not FileExists(BlocNote)) then
  	Exit
  else
  	StringToRich(fTexte, BlocNote);
  if (Length(fTexte.Text) <> 0) and (ftexte.Text <> #$D#$A) then result := false;
end;

function TImprPieceViaTOB.FindLaFinParag (TheLigne : TOB; IndiceDep : integer) : TOB;
var Indice : integer;
		TOBL : TOB;
begin
	result := nil;
	for Indice := IndiceDep to fTOBpiece.detail.count -1 do
  begin
    TOBL := fTOBPiece.detail[Indice];
    if isFinParagraphe (TOBL,TheLigne.getValue('GL_NIVEAUIMBRIC')) then result := TOBL;
    if result <> nil then Exit; // la ligne de fin de paragraphe a été trouvée : on sort
  end;
end;

procedure TImprPieceViaTOB.PoselesTotaux (thePiece,TheLigne,LaTotalisation : TOB);
begin
	if LaTotalisation = nil then exit;
	if ((TheLigne.GetValue('GL_NIVEAUIMBRIC')=1)and (thePiece.GetValue('BPD_IMPTOTPAR')='X')) or
  	 ((TheLigne.GetValue('GL_NIVEAUIMBRIC')>1) and (thePiece.GetValue('BPD_IMPTOTSSP')='X')) then
  begin
    TheLIgne.putValue('GL_MONTANTHTDEV',LaTotalisation.GetValue('GL_MONTANTHTDEV'));
    TheLIgne.putValue('GL_MONTANTHT',LaTotalisation.GetValue('GL_MONTANTHT'));
    TheLIgne.putValue('GL_TOTALHTDEV',LaTotalisation.GetValue('GL_TOTALHTDEV'));
    TheLIgne.putValue('GL_TOTALHT',LaTotalisation.GetValue('GL_TOTALHT'));
    TheLIgne.putValue('GL_MONTANTTTCDEV',LaTotalisation.GetValue('GL_MONTANTTTCDEV'));
    TheLIgne.putValue('GL_MONTANTTTC',LaTotalisation.GetValue('GL_MONTANTTTC'));
    TheLIgne.putValue('GL_TOTALTTCDEV',LaTotalisation.GetValue('GL_TOTALTTCDEV'));
    TheLIgne.putValue('GL_TOTALTTC',LaTotalisation.GetValue('GL_TOTALTTC'));
    TheLIgne.putValue('BLF_MTCUMULEFACT',LaTotalisation.GetValue('BLF_MTCUMULEFACT'));
  end;
end;

procedure TImprPieceViaTOB.AlimentePort(ThePiece : TOB);
var Indice : integer;
		TOBLigne,TOBL : TOB;
begin
	for Indice := 0 to fTOBPorcs.detail.count -1 do
  begin
  	TOBLigne := fTOBPorcs.detail[Indice];
    if TOBLigne.getValue('GPT_FRAISREPARTIS')='X' then continue;

    TOBL := InsereTOB ('LIGNE',ThePiece);
    AjouteTOB (TOBL,'LESPORTS',TOBLigne);
  end;
end;

procedure TImprPieceViaTOB.InsereChampMere(TOBMere,LaTOBgrandMere : TOB);
var iTable,Indice : integer;
    prefixe,newChamp : String;
begin
  iTable := PrefixeToNum('GP');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	Prefixe := 'GL';
    NewChamp := prefixe+copy(V_PGI.Dechamps[iTable, Indice].Nom,3,255);
		if TOBMere.FieldExists (NewChamp) then
    		TOBMere.PutValue (NewChamp,LaTOBgrandMere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
  end;
end;

procedure TImprPieceViaTOB.SetDocument(Cledoc: R_cledoc; isDGD : boolean);
begin
	fIsDGD := IsDGD;
  fInternal := true;
  fcledoc := cledoc;
  VenteAchat := GetInfoParPiece(Cledoc.NaturePiece, 'GPP_VENTEACHAT');
  AlloueTout;
	loadlesTobs;
end;

procedure TImprPieceViaTOB.ClearInternal;
begin
	RazTout;
end;

procedure TImprPieceViaTOB.AlloueTout;
begin
  fTOBPiece := TOB.Create('PIECE', nil, -1);
  AddLesSupEntete(TOBPiece);
  // ---
  fTOBBases := TOB.Create('BASES', nil, -1);
  fTOBEches := TOB.Create('Les ECHEANCES', nil, -1);
  fTOBPorcs := TOB.Create('PORCS', nil, -1);
  fTOBTiers := TOB.Create('TIERS', nil, -1);
  TOBTiers.AddChampSup('RIB', False);
  fTOBArticles := TOB.Create('ARTICLES', nil, -1);
  fTOBConds := TOB.Create('CONDS', nil, -1);
  fTOBComms := TOB.Create('COMMERCIAUX', nil, -1);
  // Adresses
  fTOBAdresses := TOB.Create('LESADRESSES', nil, -1);
  if GetParamSoc('SO_GCPIECEADRESSE') then
  begin
    TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Livraison}
    TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
  end else
  begin
    TOB.Create('ADRESSES', TOBAdresses, -1); {Livraison}
    TOB.Create('ADRESSES', TOBAdresses, -1); {Facturation}
  end;
  fTOBNomenclature := TOB.Create('NOMENCLATURES', nil, -1);
  fTOBSerie := TOB.Create('', nil, -1);
  fTOBAcomptes := TOB.Create('', nil, -1);
  // Affaires
  TOBAffaire := TOB.Create('AFFAIRE', nil, -1);
  //Saisie Code Barres
  // MODIF BTP
  // Ouvrages
  fTOBOuvrage := TOB.Create('OUVRAGES', nil, -1);
  // textes debut et fin
  fTOBLIENOLE := TOB.Create('LIENS', nil, -1);
  // retenues de garantie
  fTOBPieceRG := TOB.create('PIECERRET', nil, -1);
  // Bases de tva sur RG
  fTOBBasesRG := TOB.create('BASESRG', nil, -1);
  // --
  //Affaire-Formule des variables
  fTOBFormuleVar := TOB.Create('AFORMULEVAR', nil, -1);
  TheRepartTva := TREPARTTVAMILL.create (fForm);
  TheRepartTva.TOBBases := TOBBases;
  TheRepartTva.TOBpiece := TOBPiece;
  TheRepartTva.TOBOuvrages := TOBOUvrage;
  TheRepartTva.Charge;
  fTOBRepart := theRepartTva.Tobrepart;
  fTOBLOTS := tOB.Create ('LES LOTS',nil,-1);
  fTOBMetre := TOB.Create('LES METRES',nil,-1);
  fTOBMetres := TOB.Create('LES METRES LIGNE',nil,-1);
  fTOBTimbres := TOB.Create('LES TIMBREs',nil,-1);
end;

procedure TImprPieceViaTOB.DetruitTout;
begin
  if ftobpiece <> nil then FreeAndNil(fTOBPiece);
  if ftobbases <> nil then FreeAndNil(fTOBBases);
  if ftobEches <> nil then FreeAndNil(fTOBEches);
  if ftobporcs <> nil then FreeAndNil(fTOBPorcs);
  if fTOBTiers <> nil then FreeAndNil(fTOBTiers);
  if ftobArticles <> nil then FreeAndNil(fTOBArticles);
  if ftobconds <> nil then FreeAndNil(fTOBConds);
  if ftobComms <> nil then FreeAndNil(fTOBComms);
  // Adresses
  if ftobAdresses <> nil then FreeAndNil(fTOBAdresses);
  if fTOBNomenclature <> nil then FreeAndNil(fTOBNomenclature);
  if fTOBSerie <> nil then FreeAndNil(fTOBSerie);
  if fTOBAcomptes <> nil then FreeAndNil(fTOBAcomptes);
  //Saisie Code Barres
  // MODIF BTP
  // Ouvrages
  if fTOBOuvrage <> nil then FreeAndNil(fTOBOuvrage);
  // textes debut et fin
  if fTOBLIENOLE <> nil then FreeAndNil(fTOBLIENOLE);
  // retenues de garantie
  if fTOBPieceRG <> nil then FreeAndNil(fTOBPieceRG);
  // Bases de tva sur RG
  if fTOBBasesRG <> nil then FreeAndNil(fTOBBasesRG);
  // --
  //Affaire-Formule des variables
  if fTOBFormuleVar <> nil then FreeAndNil(fTOBFormuleVar);
  FreeAndNil(TheRepartTva);
  FreeAndNil(fTOBLOTS);
  FreeAndNil(fTOBMetre);
  FreeAndNil(fTOBMetres);
  if fTOBTimbres <> nil then FreeAndNil(fTOBTimbres);

end;

procedure TImprPieceViaTOB.loadlesTobs;
var Q : Tquery;
		indiceOuv,Indice : integer;
		OptimizeOuv :TOptimizeOuv;
    DEV : Rdevise;
begin
	OptimizeOuv := TOptimizeOuv.create;
	IndiceOuv := 1;
  LoadPieceLignes(fCleDoc, fTobPiece);

	FillChar(DEV, Sizeof(DEV), #0);
  DEV.Code := fTobPiece.GetValue('GP_DEVISE');
  GetInfosDevise(DEV);
  //
  loadlesMetres (fCleDoc,fTOBMetres);
  //
  AddLesSupEntete (fTOBpiece);
  //
  for Indice := 0 to fTobPiece.detail.count -1 do
  begin
    AddLesSupLigne (fTobPiece.detail[indice],false);
    InitLesSupLigne (fTobPiece.detail[indice]);
    if fcledoc.Naturepiece = 'FBT' then
      GestionAnciennesfactureation (fTobPiece.detail[indice],fTOBpiece.GetValue('AFF_GENERAUTO'),DEV);
  end;
  // lecture affaire
  if fTOBPiece.getValue('GP_AFFAIRE') <> '' then
  begin
    StockeCetteAffaire (fTOBPiece.getValue('GP_AFFAIRE'));
    fTOBaffaire := FindCetteAffaire (fTOBPiece.getValue('GP_AFFAIRE'));
  end;
  if fTOBPiece.getValue('GP_AFFAIREDEVIS') <> '' then
  begin
    StockeCetteAffaire (fTOBPiece.getValue('GP_AFFAIREDEVIS'));
    fTOBAffaireDev  := FindCetteAffaire (fTOBPiece.getValue('GP_AFFAIREDEVIS'));
  end;
  // Lecture bases
  Q := OpenSQL('SELECT * FROM PIEDBASE WHERE ' + WherePiece(fCleDoc, ttdPiedBase, False), True,-1,'',true);
  fTOBBases.LoadDetailDB('PIEDBASE', '', '', Q, False);
  Ferme(Q);
 // Lecture Echéances
  Q := OpenSQL('SELECT * FROM PIEDECHE WHERE ' + WherePiece(fCleDoc, ttdEche, False), True,-1,'',true);
  fTOBEches.LoadDetailDB('PIEDECHE', '', '', Q, False);
  Ferme(Q);
  // Lecture Ports
  Q := OpenSQL('SELECT * FROM PIEDPORT WHERE ' + WherePiece(fCleDoc, ttdPorc, False), True,-1,'',true);
  fTOBPorcs.LoadDetailDB('PIEDPORT', '', '', Q, False);
  Ferme(Q);
  // Lecture Lignes Formule
//  LoadLesFormules(fTOBPiece,fTOBLigFormule,CleDocfCleDoc) ;
  // Lecture Adresses
  LoadLesAdresses(fTOBPiece, fTOBAdresses);
  // Lecture Nomenclatures
  LoadLesNomen(fTOBPiece, fTOBNomenclature, fTOBArticles, fCleDoc);
  // Lecture ACompte
  LoadLesAcomptes(fTOBPiece, fTOBAcomptes, fCleDoc);
  // Modif BTP
  // chargement textes debut et fin
  LoadLesBlocNotes([tModeBlocNotes], fTOBLIENOLE, fCleDoc);
  // Chargement des retenues de garantie et Tva associe
  if GetParamSoc('SO_RETGARANTIE') then LoadLesRetenues(fTOBPiece, fTOBPieceRG , fTOBBasesRG, fCleDoc);
  {$IFDEF BTP}
  // Lecture Ouvrages
  LoadLesOuvrages(fTOBPiece, fTOBOuvrage, fTOBArticles, fCleDoc, IndiceOuv,OptimizeOuv);
  {$ENDIF}
  LoadLesArticles;
  CalculeSousTotauxPiece(fTOBPiece);
  LoadlesTimbres (fCleDoc,fTOBTimbres);
(*
  TheMetre.Action := taConsult;
  TheMetre.Duplic := false;
  TheMetre.User := V_PGI.User;
  TheMetre.Ouvrages := fTOBOuvrage;
  TheMetre.Document := fTOBPiece;
*)
{$IFDEF BTP}
	OptimizeOuv.fusionneArticles (fTOBArticles);
{$ENDIF}
  OptimizeOUv.free;
  TheRepartTva.TOBBases := TOBBases;
  TheRepartTva.TOBpiece := TOBPiece;
  TheRepartTva.TOBOuvrages := TOBOUvrage;
  TheRepartTva.Charge; // voila voila
  fTOBRepart := TheRepartTva.Tobrepart;
  if fcledoc.Naturepiece <> '' then
  begin
  	Q := OpenSql ('SELECT * FROM PARPIECE WHERE GPP_NATUREPIECEG="'+fCledoc.NaturePiece+'"',true,-1,'',true);
    ftobParPiece.SelectDB ('',Q);
    ferme (Q);
  end;
end;

procedure TImprPieceViaTOB.RazTout;
begin
  if fInternal then
  begin
    if ftobpiece <> nil then fTobPiece.clearDetail;
    if ftobpiece <> nil then ftobPiece.InitValeurs;
    if ftobAdresses <> nil then fTOBAdresses.cleardetail;
    if ftobTiers <> nil then fTOBTiers.InitValeurs;
    if ftobLienOle <> nil then fTOBLIENOLE.clearDetail;
    if ftobArticles <> nil then fTOBArticles.clearDetail;
    if ftobpieceRG <> nil then fTOBPieceRG.cleardetail;
    if ftobBases <> nil then fTOBBases.cleardetail;
    if ftobEches <> nil then fTOBEches.cleardetail;
    if fTOBPorcs <> nil then fTOBPorcs.cleardetail;
    if fTobConds <> nil then fTOBConds.cleardetail;
    if ftobComms <> nil then fTOBComms.cleardetail;
    if fTOBOuvrage <> nil then fTOBOuvrage.cleardetail;
    if fTOBNomenclature <> nil then fTOBNomenclature.cleardetail;
    if fTOBLOTS <> nil then fTOBLOTS.cleardetail;
    if fTOBSerie <> nil then fTOBSerie.cleardetail;
    if fTOBAcomptes <> nil then fTOBAcomptes.cleardetail;
    if fTOBBasesRG <> nil then fTOBBasesRG.cleardetail;
    if fTOBFormuleVar <> nil then fTOBFormuleVar.cleardetail;
    if fTOBMetre <> nil then fTOBMetre.cleardetail;
    if fTOBMetres <> nil then fTOBMetres.cleardetail;
    if fTOBCodeTaxes <> nil then fTOBCodeTaxes.cleardetail;
    if TheRepartTva <> nil then TheRepartTva.Initialise;
    ReinitTOBAffaires;
  end else
  begin
		fTOBPieceImp.clearDetail;
    fTOBPieceRecap.clearDetail;
  end;
end;

procedure TImprPieceViaTOB.LoadLesArticles;
var NbArt : integer;
  StSelect, StSelectDepot, StSelectDepotLot, StSelectCon, {StArticle,}
  StSelectCatalogu, StSelectFormule, {StCodeArticle,} stWhereLigne, ListeDepot,
  VteAch {, RefGen, Statut}: string;
  TOBDispo, TOBDispoLot, TOBArt, TobDispoArt, TobDispoLotArt, TOBCata: TOB;
  QArticle, QDepot, QDepotLot, QCon: TQuery;
  {OkTab,} DoubleDepot: Boolean;
begin
  StSelect := 'SELECT * FROM ARTICLE';
  StSelectDepot := 'SELECT * FROM DISPO';
  StSelectDepotLot := 'SELECT * FROM DISPOLOT';
  StSelectCon := 'SELECT * FROM CONDITIONNEMENT';
  StSelectCatalogu := 'SELECT * FROM CATALOGU';
  StSelectFormule := 'SELECT * FROM ARTICLEQTE';

  ListeDepot := '';
  DoubleDepot := IsTransfert(fTOBPiece.GetValue('GP_NATUREPIECEG'));
  if DoubleDepot then
    ListeDepot := '"' + fTOBPiece.GetValue('GP_DEPOT') + '","' + fTOBPiece.GetValue('GP_DEPOTDEST') + '"'
  else ListeDepot := '"' + fTOBPiece.GetValue('GP_DEPOT') + '"';

  TOBDispo := TOB.CREATE('Les Dispos', nil, -1);
  TOBDispoLot := TOB.CREATE('Les Dispolots', nil, -1);
  TOBCata := TOB.CREATE('Les Catalogues', nil, -1);

{$IFDEF AFFAIRE}
// gestion de la saisie de facture depuis l'affaire avec reprise des lignes de l'affaire
// il faut charger les articles issus des lignes d'affaire  gm 01/07/03
    stWhereLigne := WherePiece(fCleDoc, ttdLigne, False);
(*
  if (CleDocAffaire.NumeroPiece = 0) then
    stWhereLigne := WherePiece(CleDoc, ttdLigne, False)
  else
    stWhereLigne := WherePiece(CleDocAffaire, ttdLigne, False);
*)
{$else}
  stWhereLigne := WherePiece(fCleDoc, ttdLigne, False) ;
{$endif}

  QArticle := OpenSQL(StSelect + ' WHERE GA_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ')', True,-1,'',true);
  if not QArticle.EOF then fTOBArticles.LoadDetailDB('ARTICLE', '', '', QArticle, True, True);
  Ferme(QArticle);

  if DoubleDepot then
    QDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GQ_DEPOT IN (' + ListeDepot + ') AND GQ_CLOTURE="-"', True,-1,'',true)
  else QDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GQ_DEPOT IN (SELECT DISTINCT GL_DEPOT FROM LIGNE WHERE ' + stWhereLigne + ') AND GQ_CLOTURE="-"', True,-1,'',true);
  if not (CtxMode in V_PGI.PGIContexte) then
  begin
    if DoubleDepot then
      QDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
        ') AND GQL_DEPOT IN (' + ListeDepot + ')', True,-1,'',true)
    else QDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
        ') AND GQL_DEPOT IN (SELECT DISTINCT GL_DEPOT FROM LIGNE WHERE ' + stWhereLigne + ')', True,-1,'',true);
    if not QDepotLot.EOF then TOBDispoLot.LoadDetailDB('DISPOLOT', '', '', QDepotLot, True, True);
    Ferme(QDepotLot);
  end;
  if not QDepot.EOF then TOBDispo.LoadDetailDB('DISPO', '', '', QDepot, True, True);
  Ferme(QDepot);
(*
  //Formules de qté  JS 30/10/2003
  QFormule := OpenSQL(StSelectFormule + ' WHERE GAF_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ')', True);
  if not QFormule.EOF then TOBAFormule.LoadDetailDB('ARTICLEQTE', '', '', QFormule, True, True);
  Ferme(QFormule);
*)
  QCon := OpenSQL(StSelectCon + ' WHERE GCO_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
    ') ORDER BY GCO_NBARTICLE', True,-1,'',true);
  if not QCon.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', QCon, True, True);
  Ferme(QCon);
(*
  if (VenteAchat = 'ACH') then
  begin
    QCata := OpenSQL(StSelectCatalogu + ' WHERE GCA_TIERS IN (SELECT DISTINCT GL_TIERS FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GCA_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ')', True);
    if not QCata.EOF then fTOBCata.LoadDetailDB('CATALOGU', '', '', QCata, True, True);
    Ferme(QCata);
  end;
*)
  //Affecte les stocks aux articles sélectionnés
  for NbArt := 0 to fTOBArticles.detail.Count - 1 do
  begin
    with fTOBArticles.detail[NbArt] do
    begin
      AddChampSupValeur('UTILISE', '-', False);
      AddChampSupValeur('REFARTSAISIE', '', False);
      AddChampSupvaleur('REFARTBARRE', '', False);
      AddChampSupValeur('REFARTTIERS', '', False);
    end;
    // FIN MODIF DC

    TOBArt := fTOBArticles.detail[NbArt];
    TobDispoArt := TOBDispo.FindFirst(['GQ_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
    //if TobDispoArt<>nil then //Modif du 18/07/02: Bug chez Negoce
    while TobDispoArt <> nil do
    begin
      TobDispoLotArt := TOBDispoLot.FindFirst(['GQL_ARTICLE', 'GQL_DEPOT'], [TobDispoArt.GetValue('GQ_ARTICLE'), TobDispoArt.GetValue('GQ_DEPOT')], False);
      while TobDispoLotArt <> nil do
      begin
        TobDispoLotArt.Changeparent(TobDispoArt, -1);
        TobDispoLotArt := TOBDispoLot.FindNext(['GQL_ARTICLE', 'GQL_DEPOT'], [TobDispoArt.GetValue('GQ_ARTICLE'), TobDispoArt.GetValue('GQ_DEPOT')], False);
      end;
      TobDispoArt.Changeparent(TOBArt, -1);
      TobDispoArt := TOBDispo.FindNext(['GQ_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
      if DoubleDepot then
      begin
        //TobDispoArt:=TOBDispo.FindNext(['GQ_ARTICLE'],[TOBArt.GetValue('GA_ARTICLE')],False);
        if TobDispoArt <> nil then
        begin
          TobDispoLotArt := TOBDispoLot.FindFirst(['GQL_ARTICLE', 'GQL_DEPOT'], [TobDispoArt.GetValue('GQ_ARTICLE'), TOBPiece.GetValue('GP_DEPOTDEST')],
            False);
          while TobDispoLotArt <> nil do
          begin
            TobDispoLotArt.Changeparent(TobDispoArt, -1);
            TobDispoLotArt := TOBDispoLot.FindNext(['GQL_ARTICLE', 'GQL_DEPOT'], [TobDispoArt.GetValue('GQ_ARTICLE'), TOBPiece.GetValue('GP_DEPOTDEST')],
              False);
          end;
          TobDispoArt.Changeparent(TOBArt, -1);
        end;
        break;
      end;
    end;
(*
    //Affecte les catalogu aux articles sélectionnés
    TobCataArt := fTOBCata.FindFirst(['GCA_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
    while TobCataArt <> nil do
    begin
      for i := 1 to TobCataArt.NbChamps do
      begin
        NomChamp := TobCataArt.GetNomChamp(i);
        if NomChamp = '' then continue;
        TOBArt.AddChampSup(NomChamp, False);
        TOBArt.PutValue(NomChamp, TobCataArt.GetValue(NomChamp));
      end;
      TOBArt.AddChampSup('DPANEW', False);
      TOBArt.PutValue('DPANEW', TOBArt.GetValue('GCA_DPA'));
      TobCataArt := fTOBCata.FindNext(['GCA_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
    end;
*)
  end;

  //Formules de qté  JS 30/10/2003
  if VenteAchat='VEN' then VteAch:='VTE'
  else VteAch := VenteAchat;
(*
  for i := 0 to TobAFormule.Detail.Count -1 do
  begin
    TobAF := fTobAFormule.Detail[i];
    QFormule := OpenSql('SELECT * FROM ARTFORMULEVAR WHERE GAV_ARTICLE="'+
                   TobAF.GetValue('GAF_ARTICLE')+'" AND GAV_VENTEACHAT="'+VteAch+'"',True);
    if not QFormule.Eof then TobAF.LoadDetailDB('ARTICLEQTE','','',QFormule,False) ;
    Ferme(QFormule);
  end;
*)
  TOBDispo.Free;
  TOBDispoLot.Free;
  TOBCata.Free;
  DispoChampSupp(TOBArticles);
end;

procedure TImprPieceViaTOB.InitModePaiement (TOBMere : TOB);
begin
	TOBMERE.AddChampSupValeur ('GPE_NUMECHE1',1);
	TOBMERE.AddChampSupValeur ('GPE_MODEPAIE1','');
	TOBMERE.AddChampSupValeur ('GPE_DATECHE1',TobMere.GetValue('GP_DATEPIECE'));
	TOBMERE.AddChampSupValeur ('GPE_MONTANTECHE1',TobMere.GetValue('GP_TOTALHTDEV'));
	TOBMERE.AddChampSupValeur ('GPE_MONTANTDEV1',TobMere.GetValue('GP_TOTALHTDEV'));
end;

function TImprPieceViaTOB.GetInfoParams: boolean;
begin
(*
{$IFDEF LINE}
  Result := (EditionViaTOB(fcledoc)) and (not YaMetre);
{$ELSE}
  Result := EditionViaTOB(fcledoc);
{$ENDIF}
*)
  Result := EditionViaTOB(fcledoc);
  fusable := result;
end;

function TImprPieceViaTOB.GetModeleAssocie(Modele: string): string;
var NaturePiece : string;
begin
	result := Modele;
  NaturePiece :=  fTOBPieceImp.detail[0].getValue('GP_NATUREPIECEG');
  if (NaturePiece = VH_GC.AFNatAffaire) or (NaturePiece = VH_GC.AFNatProposition) or (NaturePiece = 'FBT') or (Naturepiece = 'ABT')  then
  begin
     result:=GetInfoParPiece(NaturePiece, 'GPP_IMPMODELE');
     if result = '' then result := 'DDT';
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsMillieme(TOBMere, TOBAInsere: TOB);
begin
end;

procedure TImprPieceViaTOB.AjouteChampsParPiece(TOBmere, TOBAInsere: TOB);
var ITable,Indice : integer;
begin
  iTable := PrefixeToNum('GPP');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
  	//
  	if V_PGI.Dechamps[iTable, Indice].Nom = 'GPP_LIBELLE' then continue;
    // --
		if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSupValeur (V_PGI.Dechamps[iTable, Indice].Nom,
      													 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end else
    begin
      TOBMere.PutValue (V_PGI.Dechamps[iTable, Indice].Nom,
      								 TOBAInsere.GetValue(V_PGI.Dechamps[iTable, Indice].Nom));
    end;
  end;
end;

function TImprPieceViaTOB.YaMetre: boolean;
begin
  result := (fTOBMetre.detail.count > 0);
end;

procedure TImprPieceViaTOB.SetMode;
var naturePiece : string;
begin

  // par defaut
  fAvancement := false;
  fisAVA := false;
  //
  Naturepiece := fTOBPiece.getValue('GP_NATUREPIECEG');
  if fTOBPiece.GetValue('AFF_GENERAUTO')='AVA' then fIsAVA := true;
  if (Pos(fTOBPiece.GetValue('AFF_GENERAUTO'),'AVA;DAC;')>0) and (Pos(NaturePiece,'FBT;DAC')>0) then
  begin
    fAvancement := true;
  end;
end;

procedure TImprPieceViaTOB.AjouteChampsAvancementPiece(TOBMere: TOB);
var TOBSit : TOB;
    Indice,PosMax : integer;
    req : string;
    QQ : TQuery;
begin
  PosMax := 1; if (fIsDGD) then PosMax := 0;
  //
  if (not TOBMere.fieldExists ('NUMSIT')) then
  begin
    TOBMere.AddChampSupValeur ('NUMSIT',0);
    TOBMere.AddChampSupValeur ('MAXNUMSIT',0);
    TOBMere.AddChampSupValeur ('DATESIT',idate1900);
    TOBMere.AddChampSupValeur ('TOTSITPREC',0); // montant situation précédente
    TOBMere.AddChampSupValeur ('TOTSITPRECBRUT',0); // montant situation précédente BRUT
    TOBMere.AddChampSupValeur ('TOTSITPRECTTC',0); // montant situation précédente TTC
    TOBMere.AddChampSupValeur ('TOTREMPREC',0); // montant remise / situation précédente
    TOBMere.AddChampSupValeur ('TOTESCPREC',0); // montant escompte / situation
    TOBMere.AddChampSupValeur ('TOTPORTPREC',0); // montant Port / situation précédente
    TOBMere.AddChampSupValeur ('TOTPORTSIT',0); // montant Port / situation précédente
    TOBMere.AddChampSupValeur ('TOTMARCHE',0);  // Total du Marché  BRUT
    TOBMere.AddChampSupValeur ('TOTMARCHENET',0);  // Total du Marché  NET
    TOBMere.AddChampSupValeur ('TOTMARCHETTC',0);  // Total du Marché  TTC
    TOBMere.AddChampSupValeur ('TOTCUMULEFACT',0);  // Total du cumulé facturé
    TOBMere.AddChampSupValeur ('TOTSITUATION',0); // Montant situation
    TOBMere.AddChampSupValeur ('TOTSOLDE',0); // Total du solde a regler
    TOBMere.AddChampSupValeur ('TOTREGLE',0);
  end;

//
  TOBMere.Putvalue ('TOTSITPREC',0); // montant situation précédente
  TOBMere.Putvalue ('TOTREMPREC',0); // montant remise / situation précédente
  TOBMere.Putvalue ('TOTESCPREC',0); // montant escompte / situation précédente
  TOBMere.Putvalue ('TOTPORTPREC',0); // montant Port / situation précédente
  TOBMere.Putvalue ('TOTPORTSIT',0); // montant Port / situation
  TOBMere.Putvalue ('TOTSITPRECBRUT',0); // montant situation précédente BRUT
  TOBMere.Putvalue ('TOTSITPRECTTC',0); // montant situation précédente TTC
  TOBMere.Putvalue ('TOTMARCHE',0);  // Total du Marché BRUT
  TOBMere.PutValue ('TOTMARCHENET',0);  // Total du Marché NET
  TOBMere.PutValue ('TOTMARCHETTC',0);  // Total du Marché TTC
  TOBMere.Putvalue ('TOTCUMULEFACT',0);  // Total du cumulé facturé
  TOBMere.Putvalue ('TOTSITUATION',0); // Montant situation
  TOBMere.Putvalue ('TOTSOLDE',0); // Total du solde a regler
  TOBMere.Putvalue ('TOTREGLE',0);
  //
  for Indice := 0 to fTOBPorcs.detail.count -1 do
  begin
    if fTOBPorcs.detail[Indice].getValue('GPT_FRAISREPARTIS')<>'X' then
    begin
      TOBMere.Putvalue ('TOTPORTSIT',TOBMere.Getvalue ('TOTPORTSIT') + fTOBPorcs.detail[Indice].getValue('GPT_TOTALHTDEV'));
    end;
  end;
  //
  if fTOBSituations.detail.count < 1 then exit;
  TOBSit := fTOBSituations.Detail[fTOBSituations.detail.count-1]; // forcement la derniére
  TOBMere.Putvalue ('NUMSIT',TOBSIT.getValue('BST_NUMEROSIT'));
  TOBMere.Putvalue ('DATESIT',TOBSIT.getValue('BST_DATESIT'));
  //
  if fTOBSituations.detail.count <= PosMax then exit;
  for Indice := 0 to fTOBSituations.detail.count- (1+PosMax) do
  begin
    TOBSit := fTOBSituations.Detail[Indice];
    if (not fIsDGD) or ((fIsDGD) and (fIsAva)) then
    begin
      TOBMere.PutValue ('TOTSITPREC',TOBMere.GetValue ('TOTSITPREC')+TOBSit.GetValue('BST_MONTANTHT'));
      TOBMere.PutValue ('TOTSITPRECTTC',TOBMere.GetValue ('TOTSITPRECTTC')+TOBSit.GetValue('BST_MONTANTTTC'));
    end;
    TOBMere.PutValue ('TOTSOLDE',TOBMere.GetValue ('TOTSOLDE')+(TOBSit.GetValue('BST_MONTANTTTC')-TOBSit.GetValue('ACOMPTESIT')));
    TOBMere.PutValue ('TOTREGLE',TOBMere.GetValue ('TOTREGLE')+TOBSit.GetValue('ACOMPTESIT'));
  end;
  if (not fIsDGD) or ((fIsDGD) and (fIsAva)) then
  begin
    req := 'SELECT SUM(GP_TOTALREMISEDEV) AS REMPREC, SUM(GP_TOTALESCDEV) AS ESCPREC FROM PIECE, BSITUATIONS WHERE '+
           'BST_SSAFFAIRE="'+TOBMere.GetValue('GP_AFFAIREDEVIS')+
           '" AND BST_NATUREPIECE="'+TOBMere.GetValue('GP_NATUREPIECEG')+
           '" AND BST_SOUCHE="'+TOBMere.GetValue('GP_SOUCHE')+
           '" AND BST_NUMEROFAC<'+IntToStr(TOBMere.GetValue('GP_NUMERO')) +
           ' AND GP_NATUREPIECEG=BST_NATUREPIECE AND GP_SOUCHE=BST_SOUCHE AND GP_NUMERO=BST_NUMEROFAC';
    QQ := OpenSql (req,True,-1,'',true);
    if not QQ.eof then //
    begin
      TOBMere.Putvalue ('TOTREMPREC',QQ.findField('REMPREC').asFloat); // montant remise / situation précédente
      TOBMere.Putvalue ('TOTESCPREC',QQ.findField('ESCPREC').asFloat); // montant escompte / situation précédente
    end;
    ferme (QQ);
  //
    req := 'SELECT SUM(GPT_TOTALHTDEV) AS PORTPREC FROM PIEDPORT '+
    			 'WHERE GPT_NATUREPIECEG="'+TOBMere.GetValue('GP_NATUREPIECEG')+'" '+
    			 'AND GPT_SOUCHE="'+TOBMere.GetValue('GP_SOUCHE')+'" '+
           'AND GPT_NUMERO IN ('+
    			 'SELECT BST_NUMEROFAC FROM BSITUATIONS WHERE '+
           'BST_SSAFFAIRE="'+TOBMere.GetValue('GP_AFFAIREDEVIS')+'" '+
           'AND BST_NATUREPIECE="'+TOBMere.GetValue('GP_NATUREPIECEG')+'" '+
           'AND BST_SOUCHE="'+TOBMere.GetValue('GP_SOUCHE')+'" '+
           'AND BST_NUMEROFAC<'+IntToStr(TOBMere.GetValue('GP_NUMERO')) +') '+
           'AND GPT_FRAISREPARTIS="-"';
    QQ := OpenSql (req,True,-1,'',true);
    if not QQ.eof then TOBMere.Putvalue ('TOTPORTPREC',QQ.findField('PORTPREC').asFloat); // montant Port / situation précédente
    ferme (QQ);
  end;
  //
  req := 'SELECT MAX(BST_NUMEROSIT) AS MAXNUMSIT FROM BSITUATIONS WHERE BST_NATUREPIECE="'+
          TOBmere.getValue('GP_NATUREPIECEG')+'" AND BST_SSAFFAIRE="'+
          TOBmere.getValue('GP_AFFAIREDEVIS')+'"';
  QQ := OpenSql (req,true,-1,'',true);
  if not QQ.eof then TOBMere.putValue ('MAXNUMSIT',QQ.Findfield('MAXNUMSIT').asInteger);
  ferme (QQ);
  //
  TOBMere.putValue('TOTSITPRECBRUT',TOBMere.GetValue ('TOTSITPREC')-TOBMere.Getvalue ('TOTPORTPREC')+
  								 TOBMere.getvalue ('TOTREMPREC')+TOBMere.getvalue ('TOTESCPREC'));
end;

procedure TImprPieceViaTOB.CumuleChampsAvancLigne (TOBmere, TOBAInsere: TOB);
begin
  if TOBAInsere.GetValue('GL_TYPELIGNE')<>'ART' then exit;
  // présente pour faire les cumuls sur entete de pièce (CUMULE FAC ET SITUATIONS)
  TOBMere.PutValue ('TOTCUMULEFACT',TOBMere.GetValue ('TOTCUMULEFACT')+ TOBAInsere.GetValue('BLF_MTCUMULEFACT'));  // Total du cumulé facturé
  TOBMere.PutValue ('TOTSITUATION',TOBMere.GetValue ('TOTSITUATION')+ TOBAInsere.GetValue('BLF_MTSITUATION'));  // Total situation
end;

function TImprPieceViaTOB.IsSamePiece(reference, cledoc: r_cledoc): boolean;
begin
  result := false;
  if (reference.NaturePiece=cledoc.NaturePiece) and
     (reference.Souche=cledoc.Souche) and
     (reference.Indice=cledoc.Indice) and
     (reference.NumeroPiece=cledoc.NumeroPiece) then result := true;
end;


procedure TImprPieceViaTOB.SetMontantMarcheOldVersion (TOBmere : TOB);
var Indice : integer;
    TOBL :  TOB;
    RefCledoc,CurCledoc : R_CLEDOC;
    TypeLigne : string;
begin
  if (not fAvancement) then exit;
  fillchar(refcledoc,sizeof(refcledoc),#0); // init
  for Indice := 0 to fTobPiece.detail.count -1 do
  begin
    TOBL := fTOBpiece.detail[Indice];
    TypeLigne := TOBL.GetValue('GL_TYPELIGNE');
    if (TypeLigne = 'ART') and (TOBL.GetValue('GL_PIECEPRECEDENTE')<>'') then
    DecodeRefPiece (TOBL.getValue('GL_PIECEPRECEDENTE'),CurCledoc);
    if not IsSamePiece(CurCledoc ,RefCledoc) then
    begin
      CumuleBudgetFromCledoc (curcledoc,TOBMere);
      RefCledoc := CurCledoc;
    end;
  end;
end;

procedure TImprPieceViaTOB.CumuleBudgetFromCledoc (Cledoc: R_cledoc;TOBMere : TOB);
var requete : string;
    QQ : TQuery;
    TotalHt,Remise,escompte,TotalTTC : double;
begin
  Requete := 'SELECT GP_TOTALHTDEV,GP_TOTALTTCDEV,GP_TOTALREMISEDEV,GP_TOTALESCDEV FROM PIECE WHERE GP_NATUREPIECEG="'+
             Cledoc.NaturePiece +'" AND '+
             'GP_SOUCHE="'+Cledoc.Souche +'" AND '+
             'GP_NUMERO='+InttoStr(Cledoc.NumeroPiece)+' AND '+
             'GP_INDICEG='+InttoStr(Cledoc.Indice);
  QQ := OpenSql (Requete,True,-1,'',true);
  if not QQ.eof then
  begin
    TotalHt := QQ.findField('GP_TOTALHTDEV').asfloat;
    TotalTTC := QQ.findField('GP_TOTALTTCDEV').asfloat;
    Remise := QQ.findField('GP_TOTALREMISEDEV').asfloat;
    Escompte := QQ.findField('GP_TOTALESCDEV').asfloat;
    TOBMere.PutValue ('TOTMARCHE',TOBMere.GetValue ('TOTMARCHE')+ TotalHT+Remise+Escompte );  // Total du Marché brut
    TOBMere.PutValue ('TOTMARCHENET',TOBMere.GetValue ('TOTMARCHENET')+TotalHt );  // Total du Marché Net
    TOBMere.PutValue ('TOTMARCHETTC',TOBMere.GetValue ('TOTMARCHETTC')+TotalTTC );  // Total TTC du Marché
  end;
  ferme (QQ);
  //
  Requete := 'SELECT SUM(GPT_TOTALHTDEV) AS TOTPORT FROM PIEDPORT WHERE GPT_NATUREPIECEG="'+
             Cledoc.NaturePiece+'" AND '+
             'GPT_SOUCHE="'+Cledoc.Souche+'" AND '+
             'GPT_NUMERO='+InttoStr(Cledoc.NumeroPiece)+' AND '+
             'GPT_INDICEG='+InttoStr(Cledoc.Indice)+' AND '+
             'GPT_FRAISREPARTIS="-"';
  QQ := OpenSql (Requete,True,-1,'',true);
  if not QQ.eof then
  begin
    TOBMere.PutValue ('TOTMARCHE',TOBMere.GetValue ('TOTMARCHE') - QQ.findField('TOTPORT').asFloat );  // Total du Marché
  end;
  ferme (QQ);
end;

procedure TImprPieceViaTOB.SetMontantMarche(TOBmere,LaLigne : TOB);
var RefPiece : string;
    Cledoc : r_cledoc;
    TOBDetDevis : TOB;
    requete : string;
    Indice : integer;
    QQ : TQuery;
    TotalHt,Remise,escompte,TotalTTC : double;
begin
  TOBDetDevis := TOB.Create ('LES DEVIS FAC',nil,-1);
  DecodeRefPiece (LaLigne.getValue('GL_PIECEPRECEDENTE'),cledoc);
  RefPiece := EncoderefSel (cledoc);
  Requete := 'SELECT BMF_NATUREPIECEG,BMF_SOUCHE,BMF_NUMERO,BMF_INDICEG FROM BTMEMOFACTURE '+
             'WHERE BMF_DEVISPRINC=(SELECT BMF_DEVISPRINC FROM BTMEMOFACTURE WHERE BMF_DEVIS="'+RefPiece+'")';
  //
  TRY
    TOBDETDEVIS.LoadDetailDBFromSQL ('BTMEMOFACTURE',requete,false);
    for Indice := 0 to TOBDetDevis.detail.count -1 do
    begin
      Requete := 'SELECT GP_TOTALHTDEV,GP_TOTALTTCDEV,GP_TOTALREMISEDEV,GP_TOTALESCDEV FROM PIECE WHERE GP_NATUREPIECEG="'+
                 TOBDetDevis.detail[Indice].getValue('BMF_NATUREPIECEG')+'" AND '+
                 'GP_SOUCHE="'+TOBDetDevis.detail[Indice].getValue('BMF_SOUCHE')+'" AND '+
                 'GP_NUMERO='+InttoStr(TOBDetDevis.detail[Indice].getValue('BMF_NUMERO'))+' AND '+
                 'GP_INDICEG='+InttoStr(TOBDetDevis.detail[Indice].getValue('BMF_INDICEG'));
      QQ := OpenSql (Requete,True,-1,'',true);
      if not QQ.eof then
      begin
        TotalHt := QQ.findField('GP_TOTALHTDEV').asfloat;
        TotalTTC := QQ.findField('GP_TOTALTTCDEV').asfloat;
        Remise := QQ.findField('GP_TOTALREMISEDEV').asfloat;
        Escompte := QQ.findField('GP_TOTALESCDEV').asfloat;
        TOBMere.PutValue ('TOTMARCHE',TOBMere.GetValue ('TOTMARCHE')+ TotalHT+Remise+Escompte );  // Total du Marché brut
        TOBMere.PutValue ('TOTMARCHENET',TOBMere.GetValue ('TOTMARCHENET')+TotalHt );  // Total du Marché Net
        TOBMere.PutValue ('TOTMARCHETTC',TOBMere.GetValue ('TOTMARCHETTC')+TotalTTC );  // Total TTC du Marché
      end;
      ferme (QQ);
      //
      Requete := 'SELECT SUM(GPT_TOTALHTDEV) AS TOTPORT FROM PIEDPORT WHERE GPT_NATUREPIECEG="'+
                 TOBDetDevis.detail[Indice].getValue('BMF_NATUREPIECEG')+'" AND '+
                 'GPT_SOUCHE="'+TOBDetDevis.detail[Indice].getValue('BMF_SOUCHE')+'" AND '+
                 'GPT_NUMERO='+InttoStr(TOBDetDevis.detail[Indice].getValue('BMF_NUMERO'))+' AND '+
                 'GPT_INDICEG='+InttoStr(TOBDetDevis.detail[Indice].getValue('BMF_INDICEG'))+' AND '+
                 'GPT_FRAISREPARTIS="-"';
      QQ := OpenSql (Requete,True,-1,'',true);
      if not QQ.eof then
      begin
        TOBMere.PutValue ('TOTMARCHE',TOBMere.GetValue ('TOTMARCHE') - QQ.findField('TOTPORT').asFloat );  // Total du Marché
      end;
      ferme (QQ);
    end;
  FINALLY
    TOBDETDEVIS.free;
  END;
end;

procedure TImprPieceViaTOB.AlimenteTableauSituations (ThePiece : TOB);
var Indice : integer;
    TOBS,TOBL : TOB;
    TheOrdre : integer;
    MaxC : integer;
begin
	if (fIsDgd) and (fisAVA) then MaxC := 0 else MaxC := 1;
  if fTOBSituations.detail.count <= MaxC then exit;
  for Indice := 0 to fTOBSituations.Detail.count - (1+MaxC) do
  begin
    TOBS := fTOBSituations.detail[Indice];
    TOBL := InsereTOB ('LIGNE',ThePiece);
    TheOrdre := TOBL.GetValue('GL_NUMORDRE');
    //
    DefiniLigneSituation (TOBL,TOBS);
    //
    TOBL.PutValue('GL_NUMORDRE',TheOrdre); // retablissement
  	if Indice = 0 then TOBL.PutValue ('DEBUTRECAPSIT','X');
  	if Indice = fTOBSituations.Detail.count -2 then TOBL.PutValue ('FINRECAPSIT','X');
  end;
end;

procedure TImprPieceViaTOB.SetMontantregleSituations;
var indice : integer;
    TOBS : TOB;
    req : string;
    QQ : TQuery;
begin
  for Indice := 0 to fTOBSituations.detail.count - 1 do
  begin
    TOBS := fTOBSituations.detail[Indice];
    TOBS.AddChampSupValeur ('ACOMPTESIT',0);
    req := 'SELECT SUM(GAC_MONTANTDEV) AS ACOMPTESIT FROM ACOMPTES WHERE '+
            'GAC_NUMERO='+inttoStr(TOBS.getValue('BST_NUMEROFAC'))+' AND '+
            'GAC_NATUREPIECEG="'+TOBS.getValue('BST_NATUREPIECE')+'" AND '+
            'GAC_SOUCHE="'+TOBS.getValue('BST_SOUCHE')+'" AND '+
            'GAC_ISREGLEMENT="-"';
    QQ := OpenSql (req,true,-1,'',true);
    if not QQ.eof then TOBS.putValue('ACOMPTESIT',QQ.FindField('ACOMPTESIT').asFloat);
    ferme (QQ);
  end;
end;

procedure TImprPieceViaTOB.DefiniLigneSituation (TOBMere,TOBSituation : TOB);
var QQ : TQuery;
    req : string;
    Indice : integer;
begin
  TOBMere.PutValue('BST_NUMEROSIT',TOBSituation.GetValue('BST_NUMEROSIT'));
  TOBMere.PutValue('BST_DATESIT',TOBSituation.GetValue('BST_DATESIT'));
  TOBMere.PutValue('BST_MONTANTHT',TOBSituation.GetValue('BST_MONTANTHT'));
  TOBMere.PutValue('BST_MONTANTTTC',TOBSituation.GetValue('BST_MONTANTTTC'));
  TOBMere.PutValue('BST_MONTANTREGL',TOBSituation.GetValue('BST_MONTANTREGL'));
  TOBMere.PutValue('ACOMPTESIT',TOBSituation.GetValue('ACOMPTESIT'));
  TOBMere.PutValue('LIGNERECAPSIT','X');
end;

procedure TImprPieceViaTOB.AjouteChampsSituation (TOBMere: TOB);
var Itable,Indice,IndiceTOB : integer;
begin
  iTable := PrefixeToNum('BST');
  for Indice := 1 to high(V_PGI.DeChamps[Itable]) do
  begin
    if not TOBMere.FieldExists (V_PGI.Dechamps[iTable, Indice].Nom) then
    begin
      TOBMere.AddChampSup (V_PGI.Dechamps[iTable, Indice].Nom,false);
      IndiceTOB := TOBMere.GetNumChamp (V_PGI.Dechamps[iTable, Indice].Nom);
      InitChamps (TOBmere,iTable,Indice,IndiceTOB);
    end;
  end;
end;

procedure TImprPieceViaTOB.InitChamps(TOBL : TOB; iTable,Ichamps,IndiceTOB: integer);
var typeC : string;
begin
  TypeC := V_PGI.Dechamps[iTable, Ichamps].tipe;
  if (typeC = 'INTEGER') or (typeC = 'SMALLINT') then TOBL.putValeur(IndiceTOB,0)
  else if (typeC = 'DOUBLE') or (typeC = 'EXTENDED') or (typeC = 'DOUBLE') then TOBL.putValeur(IndiceTOB,0)
  else if (typeC = 'DATE') then TOBL.putValeur(IndiceTOB,iDate1900)
  else if (typeC = 'BLOB') or (typeC = 'DATA') then TOBL.putValeur(IndiceTOB,'')
  else if (typeC = 'BOOLEAN') then TOBL.putValeur(IndiceTOB,'-')
  else TOBL.putValeur(IndiceTOB,'')
end;


procedure TImprPieceViaTOB.AjouteChampsAcomptesCpta (TOBMere : TOB);
var Value : string;
begin
  if not TOBMere.FieldExists ('ACOMPTECPT') then
  begin
    TOBMere.AddChampSupValeur  ('ACOMPTECPT','-');
  end;
  if (GetParamSoc('SO_BTCOMPTAREGL')) then Value := 'X' else Value := '-';
  TOBMere.Putvalue  ('ACOMPTECPT',Value);
end;

procedure TImprPieceViaTOB.DefiniRecapTotalSit (ThePiece : TOB);
begin
  SetLignesRecap (ThePiece);
end;

procedure TImprPieceViaTOB.SetLignesRecap (ThePiece : TOB);
var RemiseCum,EscompteCum,PortCum,CumPortSit : double;
    QQ : Tquery;
    req : string;
    Indice : integer;
    TOBTVAPre,TOBRGPre : TOB;
    CumSitTVA,CumPreTVA,CumRGSit,CumRgPre,ReliquatRGSit,reliquatRGPre,TVARGSIt,TVARGPre,TTCPre,TTCSit,AcomptesSit,AcomptesPre,Timbres : double;
begin
  TOBTVAPre := TOB.Create ('LES TVA PREC',nil,-1);
  TOBRGPre := TOB.Create ('LES RG PREC',nil,-1);
  //
  CumPortSit := 0;
  for Indice := 0 to fTOBPorcs.detail.count -1 do
  begin
    if fTOBPorcs.detail[Indice].getValue('GPT_FRAISREPARTIS')<>'X' then
    begin
      CumPortSit := CumPortSit + fTOBPorcs.detail[Indice].getValue('GPT_TOTALHTDEV');
    end;
  end;
  //
  req := 'SELECT SUM(GP_TOTALREMISEDEV) AS REMCUM, SUM(GP_TOTALESCDEV) AS ESCCUM FROM PIECE, BSITUATIONS WHERE '+
         'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
         '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
         '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
         '" AND BST_NUMEROFAC<='+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
         ' AND GP_NATUREPIECEG=BST_NATUREPIECE AND GP_SOUCHE=BST_SOUCHE AND GP_NUMERO=BST_NUMEROFAC';
  QQ := OpenSql (Req,true,-1,'',true);
  if not QQ.eof then
  begin
    RemiseCum := QQ.findField('REMCUM').asFloat;
    EscompteCum := QQ.findField('ESCCUM').asFloat;
  end;
  ferme (QQ);
  //
  req := 'SELECT SUM(GPT_TOTALHTDEV) AS PORTCUM FROM PIEDPORT, BSITUATIONS WHERE '+
         'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
         '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
         '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
         '" AND BST_NUMEROFAC<='+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
         ' AND GPT_NATUREPIECEG=BST_NATUREPIECE AND GPT_SOUCHE=BST_SOUCHE AND GPT_NUMERO=BST_NUMEROFAC AND GPT_FRAISREPARTIS<>"X"';
  QQ := OpenSql (Req,true,-1,'',true);
  if not QQ.eof then
  begin
    PortCum := QQ.findField('PORTCUM').asFloat;
  end;
  ferme (QQ);
  //
  ConstitueTOBTVA (ThePiece,TOBTVAPre);
  ConstitueTOBRGPrec (ThePiece,TOBRGPre);
  //
  DefiniLigneMontantHt (ThePiece,EscompteCum,RemiseCum,PortCum,CumPortSit);
  DefiniLigneRemise (ThePiece,RemiseCum);
  DefiniLigneEscompte (ThePiece,EscompteCum);
  DefiniLignePortFrais (ThePiece,PortCum,CumPortSit);
  if (EscompteCum<>0) or (RemiseCum<>0) or (PortCum<>0) or (CumPortSit<>0) then DefiniLigneTotalHt(ThePiece);
  DefiniLignesTVA (ThePiece,TOBTVAPre,CumSitTVA,CumPreTVA);
  DefiniLigneRGHT (ThePiece,TOBRGPRE,CumRGSit,CumRgPre,ReliquatRGSit, reliquatRGPre);
  DefiniLigneTVARG(ThePiece,TOBRGPRE,TVARGSIt,TVARGPre);
  DefiniLigneTOTALTTC (ThePiece,CumSitTVA,CumPreTVA,CumRGSit,CumRgPre,TVARGSIt,TVARGPre,TTCSit,TTCPre);
  DefiniLigneRGTTC(ThePiece,ReliquatRGSit, reliquatRGPre);
  if (TOBtimbres.detail.count > 0) then
  begin
    Timbres := DefiniLigneTimbres(ThePiece,TOBTimbres);
  end;
  if (AcomptesSit<>0) or (AcomptesPre<>0) then DefiniLigneACOMPTES(ThePiece,AcomptesSit,AcomptesPre);
  ThePiece.AddChampSupValeur ('TOTALNET', TTCSit); // défini systématiquement et initialisé au TTC car utilisé si solde sur situations précédentes
  if (AcomptesSit<>0) or (AcomptesPre<>0) or (ReliquatRGSit<>0) or (reliquatRGPre<>0) or (Timbres <> 0) then DefiniLigneTOTALNET (ThePiece,TTCSit,TTCPre,ReliquatRGSit,reliquatRGPre,AcomptesSit,AcomptesPre,Timbres);
  TOBTVAPre.free;
  TOBRGPre.free;
end;

procedure TImprPieceViaTOB.DefiniLigneTOTALNET (ThePiece : TOB;TTCSit,TTCPre,ReliquatRGSit,reliquatRGPre,AcomptesSit,AcomptesPre,Timbres : double);
var TOBL : TOB;
begin
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','TOTAL NET');
  // reliquatRGSit est négatif si la RG n'est pas couverte par une caution sinon il est positif
  if (ThePiece.getValue('PRG_TYPERG')='TTC') and (ReliquatRGSit < 0) then TOBL.putValue('MONTANTSIT',TTCSit-AcomptesSit+ReliquatRGSit)
  else TOBL.putValue('MONTANTSIT',TTCSit-AcomptesSit+Timbres);
  // reliquatRGPre est négatif si la RG n'est pas couverte par une caution sinon il est positif
  if (ThePiece.getValue('PRG_TYPERG')='TTC') and (ReliquatRGPre < 0) then TOBL.putValue('MONTANTPRE',TTCPre-AcomptesPre+reliquatRGPre)
  else TOBL.putValue('MONTANTPRE',TTCPre-AcomptesPre);
  TOBL.putValue('ISLIGNESTD','X');
  ThePiece.Putvalue ('TOTALNET', TOBL.GetValue('MONTANTSIT'));
end;

procedure TImprPieceViaTOB.DefiniLigneACOMPTES(ThePiece : TOB; var AcomptesSit,AcomptesPre : double);
var TOBL,TOBS : TOB;
    Indice : integer;
begin
  AcomptesPre := 0;
  for Indice := 0 to fTOBSItuations.detail.count -1 do
  begin
    TOBS := fTOBSItuations.detail[Indice];
    if Indice = fTOBSItuations.detail.count -1 then
    begin
      AcomptesSit := TOBS.getValue('ACOMPTESIT');
    end else
    begin
      AcomptesPre := AcomptesPre + TOBS.getValue('ACOMPTESIT');
    end;
  end;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','ACOMPTE A LA COMMANDE');
  TOBL.putValue('MONTANTSIT',AcomptesSit);
  TOBL.putValue('MONTANTPRE',AcomptesPre);
  TOBL.putValue('ISLIGNESTD','X');
end;

function TImprPieceViaTOB.DefiniLigneTimbres(ThePiece,TOBTimbres : TOB) : double;
var Cumul : Double;
		Indice : Integer;
    TOBL : TOB;
begin
  Cumul := 0;
	for Indice := 0 to TOBTimbres.detail.count -1 do
  begin
    Cumul := Cumul + TOBTImbres.detail[Indice].getValue('BT0_VALEUR');
  end;
  if Cumul > 0 then
  begin
    TOBL := InsereTOB ('LIGNE',ThePiece);
    TOBL.putValue('LIBELLE','TIMBRES');
  	TOBL.putValue('MONTANTSIT',Cumul);
    TOBL.putValue('MONTANTPRE',0);
    TOBL.putValue('ISLIGNESTD','X');
  end;
  Result := Cumul;
end;

procedure TImprPieceViaTOB.DefiniLigneRGTTC(ThePiece: TOB;ReliquatRGSit, reliquatRGPre : double);
var TOBL : TOB;
begin
  if (ThePiece.GetValue('PRG_TYPERG')<>'TTC') or (ThePiece.GetValue('PRG_TAUXRG')=0) OR (ThePiece.getValue('GPP_APPLICRG')<>'X') then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','RETENUE DE GARANTIE TTC '+FloatToStr(ThePiece.GetValue('PRG_TAUXRG'))+' %');
  if reliquatRGSIt <= 0 then
  begin
    TOBL.putValue('MONTANTSIT',ReliquatRGSit);
  end else
  begin
    TOBL.putValue('LIBELLESIT','CAUTION');
  end;
  if reliquatRGPRE <= 0 then
  begin
    TOBL.putValue('MONTANTPRE',ReliquatRGPRE);
  end else
  begin
    TOBL.putValue('LIBELLEPRE','CAUTION');
  end;
  if ReliquatRgPre+ReliquatRGSit = 0 then
  begin
    TOBL.putValue('LIBELLECUM','CAUTION');
  end;
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneTOTALTTC (ThePiece : TOB; CumSitTVA,CumPreTVA,CumRGSit,CumRgPre,TVARGSIt,TVARGPre : double; var TTCSIt,TTCPRE : double);
var TOBL : TOB;
begin
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','TOTAL T.T.C.');
  if ThePiece.getValue('PRG_TYPERG')='HT' then
  begin
    TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALHTDEV')+CumSitTVA+CumRGSit-TVARGSit);
    TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTSITPREC')+CumPreTVA+CumRGPre-TVARGPre);
  end else
  begin
    TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALHTDEV')+CumSitTVA);
    TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTSITPREC')+CumPreTVA);
  end;
  TTCSit := TOBL.GetValue('MONTANTSIT');
  TTCPre := TOBL.GetValue('MONTANTPRE');
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneTVARG(ThePiece,TOBRGPRE : TOB; var TVARGSIt,TVARGPre : double);
var TOBL : TOB;
    Indice : integer;
begin
  for Indice := 0 to fTOBPieceRG.detail.count -1 do
  begin
    TVARGSIt := TVARGSIt+ (fTOBPieceRG.detail[Indice].getValue('PRG_MTTTCRGDEV')-fTOBPieceRG.detail[Indice].getValue('PRG_MTHTRGDEV'));
  end;
  for Indice := 0 to TOBRGPre.detail.count -1 do
  begin
    TVARGPre := TVARGPre+ (TOBRGPre.detail[Indice].getValue('PRG_MTTTCRGDEV')-TOBRGPre.detail[Indice].getValue('PRG_MTHTRGDEV'));
  end;
  if (ThePiece.GetValue('PRG_TYPERG')<>'HT') or (ThePiece.GetValue('PRG_TAUXRG')=0) OR (ThePiece.getValue('GPP_APPLICRG')<>'X') then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','TVA SUR RETENUE DE GARANTIE');
  if TVARGSIt>0 then
  begin
    TOBL.putValue('MONTANTSIT',TVARGSIt*(-1));
  end;
  if TVARGPre>0 then
  begin
    TOBL.putValue('MONTANTPRE',TVARGPre*(-1));
  end;

  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneRGHT (ThePiece,TOBRGPRE : TOB; Var CumSitHt,CumpreHt,ReliquatRGSit,reliquatRGPre : double);
var TOBL : TOB;
    Indice : integer;
    RgSit,Rgpre : double;
begin
  CumSitHt := 0; CumpreHt := 0;
  ReliquatRgSit := 0; reliquatRgPre := 0;
  //
  for Indice := 0 to fTOBPieceRG.detail.count -1 do
  begin
    ReliquatRgSit := ReliquatRgSit+ (fTOBPieceRG.detail[Indice].getValue('PRG_CAUTIONMT')-fTOBPieceRG.detail[Indice].getValue('PRG_MTTTCRGDEV'));
    RgSit := RgSit+ fTOBPieceRG.detail[Indice].getValue('PRG_MTHTRGDEV');
  end;
  CumSitHt := RgSit*(-1);
  for Indice := 0 to TOBRGPre.detail.count -1 do
  begin
    ReliquatRgpre := ReliquatRgPre + (TOBRGPre.detail[Indice].getValue('PRG_CAUTIONMT')-TOBRGPre.detail[Indice].getValue('PRG_MTTTCRGDEV'));
    Rgpre := Rgpre+ TOBRGPre.detail[Indice].getValue('PRG_MTHTRGDEV');
  end;
  CumpreHt := RgPre*(-1);
  if (ThePiece.GetValue('PRG_TYPERG')<>'HT') or (ThePiece.GetValue('PRG_TAUXRG')=0) OR (ThePiece.getValue('GPP_APPLICRG')<>'X') then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','RETENUE DE GARANTIE HT '+FloatToStr(ThePiece.GetValue('PRG_TAUXRG'))+' %');
  if ReliquatRgSit<=0 then
  begin
    TOBL.putValue('MONTANTSIT',RgSIt*(-1));
  end else
  begin
    TOBL.putValue('LIBELLESIT','CAUTION');
  end;
  if ReliquatRgpre<=0 then
  begin
    TOBL.putValue('MONTANTPRE',RgPRE*(-1));
  end else
  begin
    TOBL.putValue('LIBELLEPRE','CAUTION');
  end;
  if RgSit+RgPre = 0 then TOBL.putValue('LIBELLECUM','CAUTION');

  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.ConstitueTOBRGPrec (ThePiece,TOBRGPre : TOB);
var req : string;
begin
  TOBRGPre.clearDetail;
  if (fIsDGD and fIsAVA) then
  begin
    req := 'SELECT * FROM PIECERG, BSITUATIONS WHERE '+
           'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
           '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
           '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
           '" AND BST_NUMEROFAC<='+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
           ' AND PRG_NATUREPIECEG=BST_NATUREPIECE AND PRG_SOUCHE=BST_SOUCHE AND PRG_NUMERO=BST_NUMEROFAC';
  end else
  begin
  req := 'SELECT * FROM PIECERG, BSITUATIONS WHERE '+
         'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
         '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
         '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
         '" AND BST_NUMEROFAC<'+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
         ' AND PRG_NATUREPIECEG=BST_NATUREPIECE AND PRG_SOUCHE=BST_SOUCHE AND PRG_NUMERO=BST_NUMEROFAC';
  end;
  TOBRGPre.LoadDetailDBFromSQL ('PIECERG',req,false);
end;

procedure TImprPieceViaTOB.ConstitueTOBTVA (ThePiece,TOBTVAPre : TOB);
var Indice : integer;
    TvASit,TOBS,TVAC,TVAS : TOB;
    req : string;
begin
  TOBTVAPre.clearDetail;
  TVASit := TOB.Create ('TVA SITUATION',nil,-1);
//
	if (fISDGD and fIsAVA) then
  begin
		req := 'SELECT * FROM PIEDBASE, BSITUATIONS WHERE '+
           'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
           '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
           '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
           '" AND BST_NUMEROFAC<='+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
           ' AND GPB_NATUREPIECEG=BST_NATUREPIECE AND GPB_SOUCHE=BST_SOUCHE AND GPB_NUMERO=BST_NUMEROFAC';
  end else
  begin
    req := 'SELECT * FROM PIEDBASE, BSITUATIONS WHERE '+
           'BST_SSAFFAIRE="'+ThePiece.GetValue('GP_AFFAIREDEVIS')+
           '" AND BST_NATUREPIECE="'+ThePiece.GetValue('GP_NATUREPIECEG')+
           '" AND BST_SOUCHE="'+ThePiece.GetValue('GP_SOUCHE')+
           '" AND BST_NUMEROFAC<'+IntToStr(ThePiece.GetValue('GP_NUMERO')) +
           ' AND GPB_NATUREPIECEG=BST_NATUREPIECE AND GPB_SOUCHE=BST_SOUCHE AND GPB_NUMERO=BST_NUMEROFAC';
  end;
    //
  TVASIt.LoadDetailDBFromSQL ('PIEDBASE',Req,false);
  for Indice := 0 to TVASIt.detail.count -1 do
  begin
    TVAS :=TVASit.detail[indice];
    TVAC := TOBTVAPre.findFirst(['FAMILLETAXE'],[TVAS.getValue('GPB_FAMILLETAXE')],true);
    if TVAC = nil then
    begin
      TVAC := TOB.create ('UNE TVA',TOBTVAPRE,-1);
      TVAC.AddChampSupValeur ('FAMILLETAXE',TVAS.getValue('GPB_FAMILLETAXE'));
      TVAC.AddChampSupValeur ('TAUXTAXE',TVAS.getValue('GPB_TAUXTAXE'));
      TVAC.AddChampSupValeur ('BASETAXE',0);
      TVAC.AddChampSupValeur ('VALEURTAXEPRE',0);
      TVAC.AddChampSupValeur ('VALEURTAXESIT',0);
    end;
    TVAC.putValue('VALEURTAXEPRE',TVAC.GetValue('VALEURTAXEPRE')+TVAS.GetValue('GPB_VALEURTAXE'));
  end;
  TVASit.free;
  //
  for Indice := 0 to fTOBBases.detail.count -1 do
  begin
    TVAS := fTOBBases.detail[Indice];
    TVAC := TOBTVAPre.findFirst(['FAMILLETAXE'],[TVAS.getValue('GPB_FAMILLETAXE')],true);
    if TVAC = nil then
    begin
      TVAC := TOB.create ('UNE TVA',TOBTVAPRE,-1);
      TVAC.AddChampSupValeur ('FAMILLETAXE',TVAS.getValue('GPB_FAMILLETAXE'));
      TVAC.AddChampSupValeur ('TAUXTAXE',TVAS.getValue('GPB_TAUXTAXE'));
      TVAC.AddChampSupValeur ('BASETAXE',0);
      TVAC.AddChampSupValeur ('VALEURTAXEPRE',0);
      TVAC.AddChampSupValeur ('VALEURTAXESIT',0);
    end;
    TVAC.putValue('VALEURTAXESIT',TVAC.GetValue('VALEURTAXESIT')+TVAS.GetValue('GPB_VALEURTAXE'));
    TVAC.putValue('BASETAXE',TVAS.getValue('GPB_BASETAXE'));
  end;
  //
end;

procedure TImprPieceViaTOB.DefiniLignesTVA (ThePiece,TOBTVAPre : TOB; var CumSitTva,CumPreTva: double);
var TOBL,TOBT : TOB;
    Indice : integer;
    LibTva : string;
begin
  CumSitTva := 0; CumPreTva := 0;
  for Indice := 0 to TOBTVAPRE.detail.count -1 do
  begin
    TOBT := TOBTVAPre.detail[Indice];
    TOBL := InsereTOB ('LIGNE',ThePiece);
    LibTva := 'TVA à '+StrF00(TOBT.getValue('TAUXTAXE'),2)+'%';
    if TOBTVAPRE.detail.count > 1 then
      LibTva := LibTva + ' - Base Sit. : '+StrF00(TOBT.getValue('BASETAXE'), V_PGI.OkDecV);
    TOBL.putValue('LIBELLE',libTva);
    TOBL.putValue('MONTANTSIT',TOBT.GetValue('VALEURTAXESIT')); CumSitTva := CumSitTva + TOBT.GetValue('VALEURTAXESIT');
    TOBL.putValue('MONTANTPRE',TOBT.GetValue('VALEURTAXEPRE')); CumPreTva := CumPreTva + TOBT.GetValue('VALEURTAXEPRE');
    TOBL.putValue('ISLIGNESTD','X');
  end;
end;

procedure TImprPieceViaTOB.DefiniLigneMontantHt (ThePiece : TOB; EscompteCum,RemiseCum,PortCum,CumPortSit : double);
var TOBL : TOB;
begin
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','TOTAL H.T. DES TRAVAUX');
  TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALHTDEV')+ThePiece.getValue('GP_TOTALREMISEDEV')+
                             ThePiece.getValue('GP_TOTALESCDEV')-CumPortSit);
  TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTSITPRECBRUT'));
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneTotalHt (ThePiece : TOB);
var TOBL : TOB;
begin
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','TOTAL H.T.');
  TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALHTDEV'));
  TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTSITPREC'));
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneRemise(ThePiece: TOB; RemiseCum: double);
var TOBL : TOB;
begin
  if (remiseCum = 0) and (ThePiece.getValue('GP_TOTALREMISEDEV')=0) then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','REMISE SUR DEVIS DE BASE');
  TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALREMISEDEV'));
  TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTREMPREC'));
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLigneEscompte(ThePiece: TOB;EscompteCum: double);
var TOBL : TOB;
begin
  if (EscompteCum = 0) and (ThePiece.getValue('GP_TOTALESCDEV')=0) then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','ESCOMPTE SUR DEVIS DE BASE');
  TOBL.putValue('MONTANTSIT',ThePiece.getValue('GP_TOTALESCDEV'));
  TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTESCPREC'));
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.DefiniLignePortFrais(ThePiece: TOB;PortCum,CumPortSit: double);
var TOBL : TOB;
begin
  if (PortCum = 0) and (CumPortSit=0) then exit;
  TOBL := InsereTOB ('LIGNE',ThePiece);
  TOBL.putValue('LIBELLE','PORT & FRAIS SUR DEVIS DE BASE');
  TOBL.putValue('MONTANTSIT',CumPortSit);
  TOBL.putValue('MONTANTPRE',ThePiece.getValue('TOTPORTPREC'));
  TOBL.putValue('ISLIGNESTD','X');
end;

procedure TImprPieceViaTOB.GestionAnciennesfactureation(TOBL: TOB; Modegenere : string; DEV : RDevise);

	procedure  GetInfoMarche (TOBL : TOB; var Mtmarche,QteMarche :double);
  var QQ : TQuery;
  		Req : String;
      Cledoc : r_cledoc;
  begin
  	if TOBL.GetValue('GL_PIECEORIGINE')='' then exit;
  	DecodeRefPiece (TOBL.GetValue('GL_PIECEORIGINE'),Cledoc);
  	req := 'SELECT GL_MONTANTHTDEV,GL_QTEFACT FROM LIGNE WHERE '+
    			 WherePiece(Cledoc,ttdLigne ,true,true);
  	QQ := OpenSql (Req,true,1,'',true);
    if not QQ.Eof then
    begin
    	MtMarche := QQ.findField('GL_MONTANTHTDEV').AsFloat;
    	QteMarche := QQ.findField('GL_QTEFACT').AsFloat;
    end;
    Ferme (QQ);
  end;

var MtDejafac,QteDejaFact,MtHtDev,PQ,PourcentAvanc : double;
		Mtmarche,Qtemarche : double;
begin
  if TOBL.getValue('GL_TYPELIGNE')<>'ART' then exit;
  //
  if (TOBL.GetValue('BLF_MTCUMULEFACT')=0) and ((TOBL.GetValue('GL_QTEPREVAVANC')<>0) or (TOBL.GetValue('GL_QTESIT')<>0)) then
  begin
    PQ := TOBL.GEtValue('GL_PRIXPOURQTE'); if PQ = 0 then PQ := 1;
    MtHtDev := TOBL.getValue('GL_MONTANTHTDEV');
    if MtHtdev = 0 then MtHtdev := arrondi(TOBL.getValue('GL_QTEFACT')*TOBL.GEtValue('GL_PUHTDEV') / PQ,DEV.decimale);
    MtMarche := 0; Qtemarche := 0;
    GetInfoMarche (TOBL,Mtmarche,QteMarche);
    if Modegenere='AVA' then
    begin
      // avancement ou demande d'acompte
      QteDejaFact := TOBL.GetValue('GL_QTEPREVAVANC');
      MtDejaFac := Arrondi(QteDejaFact* TOBL.GEtValue('GL_PUHTDEV') / PQ,DEV.decimale);
      if Mtmarche <> 0 then PourcentAvanc := Arrondi(MtDejaFac / Mtmarche * 100,2) else PourcentAvanc := 0;
      TOBL.putValue('BLF_MTMARCHE',MtMarche);
      TOBL.putValue('BLF_MTDEJAFACT',MtDejaFac);
      TOBL.putValue('BLF_MTCUMULEFACT',MtDejaFac);
      TOBL.putValue('BLF_MTSITUATION',0);
      TOBL.putValue('BLF_QTEMARCHE',QteMarche);
      TOBL.putValue('BLF_QTEDEJAFACT',QteDejaFact);
      TOBL.putValue('BLF_QTECUMULEFACT',QteDejaFact);
      TOBL.putValue('BLF_QTESITUATION',0);
      TOBL.putValue('BLF_POURCENTAVANC',PourcentAvanc);
      TOBL.putValue ('POURCENTAVANCINIT',PourcentAvanc);
      TOBL.putValue ('MTCUMULEFACTINIT',MtDejaFac);
      TOBL.putValue ('QTECUMULEFACTINIT',QteDejaFact);
    end else
    begin
      // facturation directe ou hors devis
      QteDejaFact := TOBL.GetValue('GL_QTESIT');
      MtDejaFac := Arrondi(QteDejaFact* TOBL.GEtValue('GL_PUHTDEV') / PQ,DEV.decimale);
      if MtMarche <> 0 then PourcentAvanc := Arrondi(MtDejaFac / MtMarche * 100,2) else PourcentAvanc := 0;
      TOBL.putValue('BLF_MTMARCHE.',MtMarche);
      TOBL.putValue('BLF_MTDEJAFACT',MtDejaFac);
      TOBL.putValue('BLF_MTCUMULEFACT',0);
      TOBL.putValue('BLF_MTSITUATION',0);
      TOBL.putValue('BLF_QTEMARCHE',QteMarche);
      TOBL.putValue('BLF_QTEDEJAFACT',QteDejaFact);
      TOBL.putValue('BLF_QTECUMULEFACT',0);
      TOBL.putValue('BLF_QTESITUATION',0);
      TOBL.putValue('BLF_POURCENTAVANC',0);
      TOBL.putValue ('POURCENTAVANCINIT',PourcentAvanc);
      TOBL.putValue ('MTCUMULEFACTINIT',MtDejaFac);
      TOBL.putValue ('QTECUMULEFACTINIT',QteDejaFact);
    end;
  end;
end;

procedure TImprPieceViaTOB.AlimentemetresLig(ThePiece,TheLigne: TOB; Numordre : integer; TOBmetres: TOB);
var TOBM,TOBMD,TOBL : TOB;
		indice : integer;
    TheOrdre : integer;
begin
  TOBM := TOBMetres.findFirst(['NUMORDRE'],[numordre],true);
  if TOBM <> nil then
  begin
  	TOBL := InsereTOB ('LIGNE',ThePiece);
    AjouteTOB (TOBL,'LIGNES',TheLigne);
    TOBL.PutValue ('ISDEBMETRE','X');
    TOBL.PutValue ('ISLIGNESTD','-');
  	TOBL.PutValue('DESCRIPTIF','-');
    TOBL.PutValue('GL_NUMORDRE',NumOrdre); // retablissement
    for Indice := 0 to TOBM.detail.count -1 do
    begin
      TOBMD := TOBM.detail[Indice];
      TOBL := InsereTOB ('LIGNE',ThePiece);
    	AjouteTOB (TOBL,'LIGNES',TheLigne);
      TOBL.PutValue('BLM_CHAINE',TOBMD.GetValue('BLM_CHAINE'));
      TOBL.PutValue('BLM_OPERATION',TOBMD.GetValue('BLM_OPERATION'));
      TOBL.PutValue('BLM_VALEUR',TOBMD.GetValue('BLM_VALEUR'));
      TOBL.PutValue('GL_NUMORDRE',NumOrdre); // retablissement
    	TOBL.PutValue ('ISLIGMETRE','X');
    	TOBL.PutValue ('ISLIGNESTD','-');
  		TOBL.PutValue('DESCRIPTIF','-');
    end;
  	TOBL := InsereTOB ('LIGNE',ThePiece);
    AjouteTOB (TOBL,'LIGNES',TheLigne);
    TOBL.PutValue ('ISFINMETRE','X');
    TOBL.PutValue ('ISLIGNESTD','-');
  	TOBL.PutValue('DESCRIPTIF','-');
    TOBL.PutValue('GL_NUMORDRE',NumOrdre); // retablissement
  end;
end;

end.
