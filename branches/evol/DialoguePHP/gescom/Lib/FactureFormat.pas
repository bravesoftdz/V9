unit Facture;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Hctrls, ExtCtrls, HTB97, StdCtrls, HPanel, UIUtil, Hent1, Menus,
  HSysMenu, Mask, Buttons, HStatus, hmsgbox, UTOF, UtilPGI,
  Hqry, UTOB, HFLabel, Ent1, SaisUtil, LookUp, Math, EntGC, FactSpec,
  FactCalc, StockUtil, M3FP, utilarticle, TarifUtil, TiersUtil, Doc_Parser, FileCtrl,
  // Modif BTP
  factrg, FGestAffDet, FPrixMarche, NomenUtil,
  {$IFDEF BTP}
  UTofBTAnalDev, BTPUtil, FactOuvrage, SimulRenTabDoc,
  {$ENDIF}
  UTOFBTMEMORISATION,
  {$IFDEF EAGLCLIENT}
  maineagl,
  {$ELSE}
  DBCtrls, Db, DBTables, fe_main, UserChg, AglIsoflex,
  {$ENDIF}
  AglInit, FactComm, FactCpta,
  AdressePiece, Clipbrd,
  {$IFDEF AFFAIRE}
  ConfidentAffaire, FactActivite, AffaireUtil, CalcOleGenericAff,
  {$ENDIF}
  ComCtrls, HRichEdt, HRichOLE,
  {$IFNDEF SANSCOMPTA}
  Devise, Chancel,
  {$ENDIF}
  FactNomen, SaisComm, VentAna,
  {$IFDEF CEGID}
  UtofCegidPCI,
  UTofCegidLibreTiersCom,
  {$ELSE}
  GcComplPrix_tof,
  {$ENDIF}
  LigNomen, UTofPiedPort, Choix,
  {$IFNDEF CCS3}
  SaisieSerie_TOF,
  {$ENDIF}
  {$IFDEF MODE}
  FactCodeBarre,
  {$ENDIF}
  DimUtil, LigDispoLot, UTofGCPieceArtLie, ShellAPI, FactUtil, UTofSaisieAvanc, UtilFO,
  ImgList,
  DepotUtil; // DBR : Depot unique chargé

function CreerPiece(NaturePiece: string): boolean;
function CreerPieceGRC(NaturePiece, LeCodeTiers: string; NoPersp: integer): boolean;
procedure AppelPiece(Parms: array of variant; nb: integer);
function SaisiePiece(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string = ''; Laffaire: string = ''; Lavenant: string = ''; SaisieAvanc: boolean =
  false; OrigineEXCEL: boolean = false): boolean;
//Function SaisiePiece ( CleDoc : R_CleDoc ; Action : TActionFiche ; LeCodeTiers : String = '';Laffaire:string='';Lavenant:string='';SaisieAvanc: boolean =false ) : boolean ;
procedure AppelTransformePiece(Parms: array of variant; nb: integer);
function TransformePiece(CleDoc: R_CleDoc; NewNat: string; SaisieAveug: Boolean = False): boolean; //Saisie Aveugle
procedure AppelDupliquePiece(Parms: array of variant; nb: integer);
function DupliquePiece(CleDoc: R_CleDoc; NewNat: string): boolean;
procedure ToutDel;

type R_IdentCol = record
    ColName, ColTyp: string;
  end;

type R_Col = record
    SG_NL: integer;
    SG_ContreM: integer;
    SG_RefArt: integer;
    SG_Lib: integer;
    SG_QF: integer;
    SG_QS: integer;
    SG_Px: integer;
    SG_Rem: integer;
    SG_Aff: integer;
    SG_Rep: integer;
    SG_Dep: integer;
    SG_RV: integer;
    SG_RL: integer;
    SG_Montant: integer;
    SG_DateLiv: integer;
    SG_Total: integer;
    SG_QR: integer;
    SG_QReste: integer; { NEWPIECE }
    SG_Motif: integer;
    NbRowsInit: integer;
    NbRowsPlus: integer;
    SG_Folio: integer; // CHR le 04/03/2002
    SG_DateProd: integer; // CHR le 04/03/2002
    SG_Regrpe: integer; // CHR le 04/03/2002
    SG_LibRegrpe: integer; // CHR le 04/03/2002
  end;

const StColNameGSA = 'CB;LIBELLE;QTE;';
  NbArtParRequete: integer = 200;
type
  TFFacture = class(TForm)
    PPied: THPanel;
    PEntete: THPanel;
    HGP_NUMPIECE: THLabel;
    GP_REFINTERNE: TEdit;
    HGP_REFINTERNE: THLabel;
    GP_TIERS: THCritMaskEdit;
    HGP_TIERS: THLabel;
    HGP_DATEPIECE: THLabel;
    GP_DATEPIECE: THCritMaskEdit;
    HGP_REPRESENTANT: THLabel;
    HMTrad: THSystemMenu;
    GP_MODEREGLE: THValComboBox;
    FindLigne: TFindDialog;
    GP_DEVISE: THValComboBox;
    PTotaux1: THPanel;
    HGP_TOTALTTCDEV: THLabel;
    HGP_ACOMPTEDEV: THLabel;
    LGP_TOTALTTCDEV: THLabel;
    LGP_ACOMPTEDEV: THLabel;
    PTotaux: THPanel;
    HGP_TOTALHTDEV: THLabel;
    LGP_TOTALHTDEV: THLabel;
    LGP_TOTALREMISEDEV: THLabel;
    DockBottom: TDock97;
    GP_REPRESENTANT: THCritMaskEdit;
    GP_NUMEROPIECE: THPanel;
    GP_ESCOMPTE: THNumEdit;
    HGP_ESCOMPTE: THLabel;
    HGP_MODEREGLE: TFlashingLabel;
    LIBELLETIERS: THPanel;
    HGP_ETABLISSEMENT: THLabel;
    GP_ETABLISSEMENT: THValComboBox;
    HGP_REMISEPIED: THLabel;
    GP_REMISEPIED: THNumEdit;
    HTitres: THMsgBox;
    BZoomArticle: TBitBtn;
    BZoomTiers: TBitBtn;
    BZoomTarif: TBitBtn;
    POPZ: TPopupMenu;
    HPiece: THMsgBox;
    FTitrePiece: THLabel;
    POPY: TPopupMenu;
    CpltEntete: TMenuItem;
    CpltLigne: TMenuItem;
    GP_DEPOT: THValComboBox;
    HGP_DEPOT: THLabel;
    AdrLiv: TMenuItem;
    AdrFac: TMenuItem;
    BZoomCommercial: TBitBtn;
    N1: TMenuItem;
    N2: TMenuItem;
    MBtarif: TMenuItem;
    BZoomPrecedente: TBitBtn;
    BZoomOrigine: TBitBtn;
    MBSoldeReliquat: TMenuItem;
    PEnteteAffaire: THPanel;
    HGP_NUMPIECE__: THLabel;
    HGP_REFINTERNE__: THLabel;
    HGP_TIERS__: THLabel;
    HGP_DATEPIECE__: THLabel;
    HGP_REPRESENTANT__: THLabel;
    HGP_ETABLISSEMENT__: THLabel;
    FTitrePiece__: THLabel;
    HGP_DEPOT__: THLabel;
    BRechAffaire__: TToolbarButton97;
    HGP_AFFAIRE__: THLabel;
    GP_REFINTERNE__: TEdit;
    GP_TIERS__: THCritMaskEdit;
    GP_DATEPIECE__: THCritMaskEdit;
    GP_DEVISE__: THValComboBox;
    GP_REPRESENTANT__: THCritMaskEdit;
    GP_NUMEROPIECE__: THPanel;
    LIBELLETIERS__: THPanel;
    GP_ETABLISSEMENT__: THValComboBox;
    GP_DEPOT__: THValComboBox;
    GP_AFFAIRE1__: THCritMaskEdit;
    GP_AFFAIRE2__: THCritMaskEdit;
    GP_AFFAIRE3__: THCritMaskEdit;
    LIBELLEAFFAIRE: THPanel;
    GP_AFFAIRE: THCritMaskEdit;
    BZoomAffaire: TBitBtn;
    INFOSLIGNE: THGrid;
    Outils97: TToolbar97;
    BMenuZoom: TToolbarButton97;
    BEche: TToolbarButton97;
    BInfos: TToolbarButton97;
    BChercher: TToolbarButton97;
    BSousTotal: TToolbarButton97;
    BActionsLignes: TToolbarButton97;
    Valide97: TToolbar97;
    BValider: TToolbarButton97;
    BAbandon: TToolbarButton97;
    BAide: TToolbarButton97;
    Sep1: TToolbarSep97;
    Sep2: TToolbarSep97;
    BOffice: TToolbarButton97;
    BZoomSuivante: TBitBtn;
    BZoomEcriture: TBitBtn;
    BDevise: TToolbarButton97;
    PopD: TPopupMenu;
    ISigneEuro: TImage;
    BVentil: TToolbarButton97;
    PopL: TPopupMenu;
    TInsLigne: TMenuItem;
    TSupLigne: TMenuItem;
    TCommentEnt: TMenuItem;
    TCommentPied: TMenuItem;
    HErr: THMsgBox;
    POPD_S1: TMenuItem;
    POPD_S2: TMenuItem;
    POPD_S3: TMenuItem;
    GP_TOTALHTDEV: THNumEdit;
    GP_TOTALREMISEDEV: THNumEdit;
    HTOTALTAXESDEV: THNumEdit;
    GP_TOTALESCDEV: THNumEdit;
    GP_TOTALTTCDEV: THNumEdit;
    GP_SAISIECONTRE: TCheckBox;
    GP_FACTUREHT: TCheckBox;
    GP_REGIMETAXE: THValComboBox;
    BDevise__: TToolbarButton97;
    ISigneEuro__: TImage;
    BDescriptif: TToolbarButton97;
    LDevise: THPanel;
    LDevise__: THPanel;
    N3: TMenuItem;
    MBDetailNomen: TMenuItem;
    BZoomDevise: TBitBtn;
    BDelete: TToolbarButton97;
    GP_ACOMPTEDEV: THNumEdit;
    BAcompte: TToolbarButton97;
    GP_AVENANT__: THCritMaskEdit;
    BRazAffaire: TToolbarButton97;
    BImprimer: TToolbarButton97;
    GP_AFFAIRE0__: THCritMaskEdit;
    GP_DATELIVRAISON: THCritMaskEdit;
    HGP_DATELIVRAISON: THLabel;
    MBDatesLivr: TMenuItem;
    HGP_TOTALREMISEDEV: THLabel;
    BPorcs: TToolbarButton97;
    HGP_TOTALPORTSDEV: THLabel;
    LTOTALPORTSDEV: THLabel;
    HGP_TOTALTAXESDEV: THLabel;
    LTOTALTAXESDEV: THLabel;
    HGP_TOTALESCDEV: THLabel;
    LGP_TOTALESCDEV: THLabel;
    LNETAPAYERDEV: THLabel;
    HGP_NETAPAYERDEV: THLabel;
    TOTALPORTSDEV: THNumEdit;
    NETAPAYERDEV: THNumEdit;
    HGP_AFFAIRE: THLabel;
    GP_AFFAIRE0: THCritMaskEdit;
    GP_AFFAIRE1: THCritMaskEdit;
    GP_AFFAIRE2: THCritMaskEdit;
    GP_AFFAIRE3: THCritMaskEdit;
    GP_AVENANT: THCritMaskEdit;
    BRechAffaire: TToolbarButton97;
    AFF_TIERS: THCritMaskEdit;
    EUROPIVOT: TEdit;
    GP_TVAENCAISSEMENT: THValComboBox;
    Librepiece: TMenuItem;
    HGP_DOMAINE: THLabel;
    GP_DOMAINE: THValComboBox;
    HAveugle: THMsgBox;
    BSaisieAveugle: TToolbarButton97;
    N4: TMenuItem;
    PlanningLigne: TMenuItem;
    PlanningEntete: TMenuItem;
    EuroPivot__: TEdit;
    LibComplAffaire: THLabel;
    HGP_DOMAINE__: THLabel;
    GP_DOMAINE__: THValComboBox;
    MBSoldeTousReliquat: TMenuItem;
    BNouvelArticle: TToolbarButton97;
    MOTIFMVT: THValComboBox;
    HMOTIFMVT: THLabel;
    N5: TMenuItem;
    MBSGED: TMenuItem;
    SGEDPiece: TMenuItem;
    SGEDLigne: TMenuItem;
    PopV: TPopupMenu;
    VPiece: TMenuItem;
    VLigne: TMenuItem;
    VSepare: TMenuItem;
    SPiece: TMenuItem;
    SLigne: TMenuItem;
    SB: TScrollBox;
    Debut: THRichEditOLE;
    Fin: THRichEditOLE;
    GS: THGrid;
    Descriptif1: THRichEditOLE;
    Timer1: TTimer;
    TSaisieAveugle: TToolWindow97;
    GSAveugle: THGrid;
    PSaisieCB: THPanel;
    BtValiderSA: TToolbarButton97;
    BtFermerSA: TToolbarButton97;
    BtRefreshSA: TToolbarButton97;
    BtDelLigneSA: TToolbarButton97;
    BtRetour: TToolbarButton97;
    TDescriptif: TToolWindow97;
    Descriptif: THRichEditOLE;
    TOTALRGDEV: THNumEdit;
    HTTCDEV: THNumEdit;
    TTYPERG: TEdit;
    TCaution: TEdit;
    LLIBRG: TFlashingLabel;
    LMontantRg: TFlashingLabel;
    HGP_TOTALRGDEV: THLabel;
    LTOTALRGDEV: THLabel;
    LHTTCDEV: THLabel;
    LCAUTION: TFlashingLabel;
    ImTypeArticle: TImageList;
    MBAnal: TMenuItem;
    MBAnalDoc: TMenuItem;
    MBAnalLoc: TMenuItem;
    MBModeVisu: TMenuItem;
    BTypeArticle: TToolbarButton97;
    BRetenuGar: TToolbarButton97;
    BPrixMarche: TToolbarButton97;
    BZoomStock: TBitBtn;
    BZoomDispo: TBitBtn;
    TTVParag: TToolWindow97;
    TVParag: TTreeView;
    TInsParag: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    BArborescence: TToolbarButton97;
    GP_HRDOSSIER: THCritMaskEdit;
    PopA: TPopupMenu;
    Pourlaligne: TMenuItem;
    Pourledocument: TMenuItem;
    BtQteAuto: TToolbarButton97;
    MBDetailLot: TMenuItem;
    TTransfert: TToolWindow97;
    Mtransfert: TMemo;
    POPGS: TPopupMenu;
    GScopier: TMenuItem;
    GSColler: TMenuItem;
    GSEnregistrer: TMenuItem;
    GSRappeler: TMenuItem;
    HTotaux: THPanel;
    SommeQTE: THNumEdit;
    TFusionner: TMenuItem;
    N8: TMenuItem;
    Fraisdetail: TMenuItem;
    Simulationderentabilit1: TMenuItem;
    SRDocGlobal: TMenuItem;
    SRDocParag: TMenuItem;
    BtTPI: TToolbarButton97;
    BZoomPiece: TBitBtn;
    BZoomPieceTV: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BChercherClick(Sender: TObject);
    procedure GSMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GSElipsisClick(Sender: TObject);
    procedure GSEnter(Sender: TObject);
    procedure GSDblClick(Sender: TObject);
    procedure GSCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure FindLigneFind(Sender: TObject);
    procedure BZoomArticleClick(Sender: TObject);
    procedure BMenuZoomMouseEnter(Sender: TObject);
    procedure BZoomTarifClick(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    procedure BZoomTiersClick(Sender: TObject);
    procedure PEnteteExit(Sender: TObject);
    procedure GP_DEVISEChange(Sender: TObject);
    procedure GP_DATEPIECEExit(Sender: TObject);
    procedure GP_TIERSElipsisClick(Sender: TObject);
    procedure GP_TIERSDblClick(Sender: TObject);
    procedure GP_TIERSExit(Sender: TObject);
    procedure GP_DEPOTChange(Sender: TObject);
    procedure GP_ESCOMPTEExit(Sender: TObject);
    procedure GP_REMISEPIEDExit(Sender: TObject);
    procedure CpltEnteteClick(Sender: TObject);
    procedure CpltLigneClick(Sender: TObject);
    procedure AfficheZonePied(Sender: TObject);
    procedure AdrLivClick(Sender: TObject);
    procedure AdrFacClick(Sender: TObject);
    procedure GP_REPRESENTANTElipsisClick(Sender: TObject);
    procedure BZoomCommercialClick(Sender: TObject);
    procedure GP_REPRESENTANTExit(Sender: TObject);
    procedure MBtarifClick(Sender: TObject);
    procedure BZoomPrecedenteClick(Sender: TObject);
    procedure BZoomOrigineClick(Sender: TObject);
    procedure MBSoldeReliquatClick(Sender: TObject);
    procedure MBSoldeTousReliquatClick(Sender: TObject); //AC Reliquat de toute la pièce
    procedure BZoomAffaireClick(Sender: TObject);
    procedure OnExitPartieAffaire(Sender: TObject);
    procedure BRechAffaire__Click(Sender: TObject);
    procedure GP_AFFAIRE1__Change(Sender: TObject);
    procedure GP_AFFAIRE2__Change(Sender: TObject);
    procedure TDescriptifClose(Sender: TObject);
    procedure BZoomEcritureClick(Sender: TObject);
    procedure BSousTotalClick(Sender: TObject);
    procedure BZoomSuivanteClick(Sender: TObject);
    procedure BEcheClick(Sender: TObject);
    procedure VPieceClick(Sender: TObject);
    procedure VLigneClick(Sender: TObject);
    procedure TInsLigneClick(Sender: TObject);
    procedure TSupLigneClick(Sender: TObject);
    procedure TCommentEntClick(Sender: TObject);
    procedure TCommentPiedClick(Sender: TObject);
    procedure PopEuro(Sender: TObject);
    procedure GP_ETABLISSEMENTChange(Sender: TObject);
    procedure BDescriptifClick(Sender: TObject);
    procedure BOfficeClick(Sender: TObject);
    procedure GP_TIERSEnter(Sender: TObject);
    procedure MBDetailNomenClick(Sender: TObject);
    procedure MBDetailLotClick(Sender: TObject);
    procedure BZoomDeviseClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BAcompteClick(Sender: TObject);
    procedure BRazAffaireClick(Sender: TObject);
    procedure BImprimerClick(Sender: TObject);
    procedure GP_REGIMETAXEChange(Sender: TObject);
    procedure MBDatesLivrClick(Sender: TObject);
    procedure BPorcsClick(Sender: TObject);
    procedure BAideClick(Sender: TObject);
    procedure BAbandonClick(Sender: TObject);
    procedure GP_TVAENCAISSEMENTChange(Sender: TObject);
    procedure LibrepieceClick(Sender: TObject);
    procedure TSaisieAveugleClose(Sender: TObject);
    procedure TSaisieAveugleResize(Sender: TObject);
    procedure GSAveugleCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSAveugleRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GSAveugleCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSAveugleRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GSAveugleKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtRefreshSAClick(Sender: TObject);
    procedure BtFermerSAClick(Sender: TObject);
    procedure BtValiderSAClick(Sender: TObject);
    procedure BtDelLigneSAClick(Sender: TObject);
    procedure GP_DATELIVRAISONExit(Sender: TObject);
    procedure BSaisieAveugleClick(Sender: TObject);
    procedure GP_DOMAINEChange(Sender: TObject);
    procedure BZoomDispoClick(Sender: TObject);
    procedure BNouvelArticleClick(Sender: TObject);
    procedure BInfosClick(Sender: TObject);
    procedure SGEDPieceClick(Sender: TObject);
    procedure GP_REPRESENTANTEnter(Sender: TObject);
    procedure BZoomStockClick(Sender: TObject);
    // Modif BTP
    procedure MBAnalDocClick(Sender: TObject);
    procedure MBAnalLocClick(Sender: TObject);
    procedure MBModeVisuClick(Sender: TObject);
    procedure DebutResizeRequest(Sender: TObject; Rect: TRect);
    procedure FinResizeRequest(Sender: TObject; Rect: TRect);
    procedure GSExit(Sender: TObject);
    procedure GSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DebutEnter(Sender: TObject);
    procedure FinEnter(Sender: TObject);
    procedure TVParagClick(Sender: TObject);
    procedure Descriptif1Exit(Sender: TObject);
    procedure BTypeArticleClick(Sender: TObject);
    procedure TInsParagClick(Sender: TObject);
    procedure BArborescenceClick(Sender: TObject);
    procedure BPrixMarcheClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TTVParagClose(Sender: TObject);
    procedure DebutExit(Sender: TObject);
    procedure FinExit(Sender: TObject);
    procedure Descriptif1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DebutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BRetenuGarClick(Sender: TObject);
    procedure PPiedResize(Sender: TObject);
    procedure PTotauxResize(Sender: TObject);
    procedure PTotaux1Resize(Sender: TObject);
    procedure PourlaligneClick(Sender: TObject); dynamic;
    procedure PourledocumentClick(Sender: TObject); dynamic;
    procedure TFusionnerClick(Sender: TObject);
    // Modif BTP
    procedure GScopierClick(Sender: TObject);
    procedure GSEnregistrerClick(Sender: TObject);
    procedure GSCollerClick(Sender: TObject);
    procedure GSRappelerClick(Sender: TObject);
    {$IFDEF BTP}
    procedure GSFlipSelection(Sender: TObject);
    procedure GSBeforeFlip(Sender: TObject; ARow: Integer; var Cancel: Boolean);
    procedure GSContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    {$IFDEF BTPS5}
    procedure FraisdetailClick(Sender: TObject);
    {$ENDIF}
    procedure SRDocGlobalClick(Sender: TObject);
    procedure SRDocParagClick(Sender: TObject);
    {$ENDIF}
    procedure DescriptifKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SLigneClick(Sender: TObject);
    procedure SPieceClick(Sender: TObject);
    procedure BtTPIClick(Sender: TObject);
    procedure BZoomPieceClick(Sender: TObject);
    procedure BZoomPieceTVClick(Sender: TObject);
  private
    // Modif BTP
    NbLignesGrille: integer;
    SBPosition: integer;
    NumGraph: integer;
    TextePosition: integer;
    GestionRetenue, ApplicRetenue: boolean;
    {$IFDEF BTP}
    procedure AppliqueChangeTaxe(IndLigne: Integer);
    procedure Insere_SDP;
    procedure CreeDesc;
    function AfficheDesc: boolean;
    {$ENDIF}
    function CalculMargeLigne(ARow: integer): double;
    procedure AppliquePrixMarche(NewMontant: double; TOBPOurcent: TOB;
      RecupPourcent: boolean; ModeGestion, IndDepart, IndFin,
      EtenduApplication: integer);
    procedure AttribueEcartMarche(NewMontant: double; TOBPOurcent: TOB;
      IndDepart, IndFin, EtenduApplication: integer);
    function OkLigneCalculMarche(TOBLig: TOB;
      IndtypeLigne: integer): boolean;
    procedure LoadLesTextes;
    procedure RemplitLiens(TOBPiece, TOBLIens: TOB; Texte: THRichEditOLE; Rang: integer);
    procedure Affiche_TVParag;
    procedure PersonnalisationBtp;
    procedure DefiniPied;
    procedure DefinitionGrille;
    procedure DefinitionTaillePied;
    procedure SupLigneRgUnique;
    procedure GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG: TOB);
    {$IFDEF BTP}
    procedure AfficheTexteLigne(Arow: integer; Desc: THRichEditOLE);
    procedure GestionDetailOuvrage(Arow: integer);
    procedure TraitePrixOuvrage(TOBL: TOB; EnHt: boolean; PuFix: double);
    procedure AvancementAcompte;
    procedure AjusteSousDetail;
    {$ENDIF}
    procedure SaisiePrixMarche(Coef: double = 0);
    procedure SaisieAvancement;
    procedure InitContexteGrid;
    // --
    {$IFDEF BTP}
    procedure CopieDonnee;
    procedure ExportTOB(TOBLoc: TOB; Mcopy: TstringList);
    procedure EnregistreDonne;
    procedure ajouteLigneSel(TOBSel: TOB; Indice: Integer);
    function IsTypeTOB: boolean;
    procedure CollageDonnee;
    procedure ChargeDonnee;
    function AjouteLigneImport(TOBLoc: TOB; var Niveau: integer; var Arow: integer; var SauteAFinPar: boolean; var ArticleNonOk: boolean): boolean;
    function RecupTob(Atob: TOB): Integer;
    function ISArticleOK(Arow: integer): boolean;
    procedure RappellerMemo;
    procedure deselectionneRows;
    procedure InsertDebParagrapheImp(TOBLOC: TOB; niveau, Arow: integer);
    procedure InsertFinParagrapheImp(TOBLOC: TOB; niveau, Arow: integer);
    function InsertLigneArticleImp(TOBLOC: TOB; var Arow: integer; Niveau: integer; var ArticleNonOk: boolean): boolean;
    procedure InsertLigneCommentaireImp(TOBLoc: TOB; Arow, Niveau: Integer);
    procedure InsertLigneTotalImp(TOBLoc: TOB; Arow, Niveau: integer);
    {$ENDIF}
    procedure Deselectionne(Arow: integer);
    procedure PositionneTOBOrigine;
    procedure AppliquePourcentAvanc(TOBPiece: TOB; Pourcent: double; IndDepart, IndFin, ModeApplic: integer; Dev: Rdevise);
    {$IFDEF BTP}
    procedure GoToLigne(var Arow, Acol: integer);
    {$ENDIF}
    function CanChangeArticle(Tobl: Tob): Boolean;

  protected
    GereStatPiece, AvoirDejaInverse: boolean;
    GX, GY: Integer;
    WMinX, WMinY: Integer;
    NbTransact: integer;
    FindFirst, ForcerFerme, ReliquatTransfo, GereReliquat, GeneCharge, OkCpta,
      OkCptaStock, NeedVisa, GereLot, GereAcompte, GereSerie, CommentLigne, ForceRupt,
      EstAvoir, QuestionRisque, SansRisque, DejaRentre, ValideEnCours, CataFourn,
      TotEnListe, OuvreAutoPort, PasToucheDepot, AutoCodeAff, PasBouclerCreat, FClosing,
      GereActivite, GereContreM, DelActivite, ObligeRegle, ChangeComplEntete,
      ForcerLaModif, GppReliquat: boolean; { NEWPIECE }
    StCellCur, LesColonnes, CompAnalP, CompAnalL, CompStockP, CompStockL, GereEche,
      CommentEnt, CommentPied, CalcRupt, CliCur, VenteAchat, DimSaisie,
      TypeCom, OldRepresentant: string;
    IdentCols: array[0..19] of R_IdentCol;
    RCol: R_Col;
    PPInfosLigne: TStrings;
    MontantVisa, RisqueTiers, OldHT: Double;
    LeAcompte: T_GCAcompte;
    ANCIEN_TOBDimDetailCount: integer; // Sauvegarde du nb initial de dimensions
    NewLigneDim: Boolean; //AC, nouvelle ligne pour gestion d'un art GEN existant
    Col_CB, Col_Lib, Col_Qte: Integer; //Saisie Aveugle
    TOBGSA: TOB; //Saisie Aveugle
    OuiPourTousNewArt, NonPourTousNewArt, OuiPourTousQteSup, NonPourTousQteSup: boolean; //Saisie Aveugle
    BAffecteTous, SaisieCodeBarreAvecFenetre: Boolean;
    // Objets mémoire
    TOBPiece, TOBEches, TOBBases, TOBTiers, TOBArticles, TOBTarif, TOBAdresses, TOBConds, TOBComms,
      TOBCpta, TOBAnaP, TOBAnaS, TOBPorcs, TOBDesLots, TOBSerie, TOBSerRel: TOB;
    TOBPiece_O, TOBBases_O, TOBAdresses_O, TOBEches_O, TOBCXV, TOBAffaire, TOBNomenclature, TOBN_O: TOB;
    TOBDim, TOBSerie_O, TOBLOT_O, TOBAcomptes, TOBAcomptes_O, TOBPorcs_O: TOB;
    TOBCatalogu, TOBDispoContreM: TOB;
    // MODIF BTP
    PresentSousDetail: integer;
    TOBOUvrage, TOBOuvrage_O: TOB;
    TOBLIENOLE, TOBLIENOLE_O: TOB;
    TOBPIECERG, TOBPIECERG_O: TOB;
    TOBBASESRG, TOBBASESRG_O: TOB;
    TOBLigneRG: TOB;
    TOBImp: TOB;
    IndiceOuv: integer;
    RowSelected: integer;
    RowCollage: integer;
    ColCollage: integer;
    // --
    // DEBUT AJOUT CHR
    {$IFDEF CHR}
    TobHRDossier, Tobregrpe: TOB;
    Supp_Commentaire: boolean;
    {$ENDIF}
    // FIN AJOUT CHR
// Dimensionnement
    procedure WMGetMinMaxInfo(var MSG: Tmessage); message WM_GetMinMaxInfo;
    // Actions liées au Grid
    procedure SauveColList;
    procedure RestoreColList;
    procedure EtudieColsListe;
    procedure ZoneSuivanteOuOk(var ACol, ARow: Longint; var Cancel: boolean);
    function ZoneAccessible(ACol, ARow: Longint): boolean;
    procedure FormateZoneSaisie(ACol, ARow: Longint);
    function FormateZoneDivers(St: string; ACol: Longint): string;
    function GereElipsis(LaCol: integer): boolean;
    // Initialisations
    procedure ErgoGCS3;
    procedure InitPasModif;
    procedure InitToutModif;
    procedure BloquePiece(ActionSaisie: TActionFiche; Bloc: boolean);
    procedure BlocageSaisie(Bloc: boolean);
    procedure InitEnteteDefaut(Totale: boolean);
    procedure InitPieceCreation; dynamic;
    procedure LoadLesTOB;
    procedure MemoriseNumLigne;
    // DEBUT AJOUT CHR
    {$IFDEF CHR}
    procedure LoadLesTOBChr;
    {$ENDIF}
    // FIN AJOUT CHR
    procedure GereVivante;
    procedure EtudieReliquat;
    procedure InitialiseReliquatSerie;
    procedure ChargelaPiece;
    procedure InitEuro;
    procedure InitRIB;
    function FromAvoir: boolean;
    procedure ToutAllouer;
    procedure ToutLiberer;
    procedure ReInitPiece; dynamic;
    procedure AppliqueTransfoDuplic; dynamic;
    procedure ChargeFromNature;
    procedure ModifiableLeMemeJour;
    // Calculs, Euro
    procedure CalculeLaSaisie(ACol, ARow: integer; AffTout: boolean);
    procedure AfficheEuro;
    procedure MontreEuroPivot(Montrer: boolean);
    procedure RempliPopY;
    procedure RempliPopD;
    procedure ChoixEuro(Sender: TObject);
    procedure AfficheTaxes;
    procedure PositionneVisa;
    procedure PositionneEuroGescom;
    procedure ZoomOuChoixLib(ACol, ARow: integer);
    procedure ZoomOuChoixDateLiv(ACol, ARow: integer);
    // Affichages
    procedure ShowDetail(ARow: integer); dynamic;
    procedure ZoomOuChoixArt(ACol, ARow: integer);
    {$IFDEF BTP}
    function ZoomOuChoixArtLib(ACol, ARow: integer): Boolean;
    {$ENDIF}
    procedure GereEnabled(ARow: integer);
    procedure EnabledPied;
    procedure EnabledGrid;
    procedure TraiteTiersParam;
    procedure GereTiersEnabled; dynamic;
    procedure GereArticleEnabled;
    procedure GereCommercialEnabled;
    procedure GereAffaireEnabled;
    procedure GetCellCanvas(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure PostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure GotoEntete;
    procedure GotoPied;
    procedure FlagRepres;
    procedure FlagDomaine;
    procedure FlagDepot;
    procedure FlagEEXandSEX;
    {$IFDEF CEGID}
    procedure CegidModifPCI(ARow: integer);
    procedure CEGIDLibreTiersCom;
    {$ELSE}
    procedure ModifPrixAchat(ARow: integer);
    {$ENDIF}
    procedure FlagContreM;
    // TOBS lignes
    function PieceModifiee: boolean;
    procedure OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; var Value: variant);
    function FabricNomWord: string;
    // LIGNES
    function InitLaLigne(ARow: integer; NewQte: double): T_ActionTarifArt;
    procedure AfficheLaLigne(ARow: integer);
    procedure AfficheLigneDimGen(TOBL: TOB; ARow: integer);
    procedure InsertComment(Ent: Boolean);
    procedure RecalculeSousTotaux(TOBPiece: TOB);
    procedure AffichePorcs;
    procedure ClickPorcs;
    function InsereLigneGEN(CodeGen: string; ARow: integer; Qte: Double): TOB;
    function NbDimensionsLigneGEN(ARow: integer): integer;
    {$IFDEF MODE}
    procedure TraiteLaFusion(AvecAffichage: Boolean);
    {$ENDIF}
    // REPRESENTANTS
    procedure BalayeLignesRep;
    function IdentifierRepres(var ACol, ARow: integer): boolean;
    procedure ZoomRepres(Repres: string);
    function RepresExiste(Repres: string): boolean;
    procedure ZoomOuChoixRep(ACol, ARow: integer);
    procedure TraiteRepres(var ACol, ARow: integer; var Cancel: boolean);
    // COMPTABILITE
    procedure ZoomEcriture(DeStock: boolean);
    procedure GereAnal(ARow: integer);
    procedure ClickVentil(LePied, LeStock: Boolean);
    // DEPOTS
    procedure TraiteDepot(var ACol, ARow: integer; var Cancel: boolean);
    procedure ZoomOuChoixDep(ACol, ARow: integer);
    function IdentifierDepot(var ACol, ARow: integer): boolean;
    function DepotExiste(Depot: string): boolean;
    // DIMENSIONS
    procedure RemplirTOBDim(CodeArticle: string; Ligne: Integer);
    procedure AppelleDim(ARow: integer);
    procedure TraiteLesDim(var ARow: integer; NewArt: boolean);
    procedure AffichageDim;
    // Gestion du solde de reliquat pour les articles dimensionnés (mode)
    procedure SoldeReliquatArtDim(TOBL: Tob; ARow: integer);
    // MODE
    procedure IncidenceMode;
    // ARTICLES
    procedure UpdateArtLigne(ARow: longint; FromMacro, Calc: boolean; NewQte: double);
    procedure TraiteLesLies(ARow: integer);
    procedure TraiteLesCons(ARow: integer);
    procedure TraiteLesNomens(ARow: integer);
    // Modif BTP
    function TraiteLesOuv(ARow: integer): boolean;
    // -----
    procedure TraiteLesMacros(ARow: integer);
    procedure TraiteLaCompta(ARow: integer);
    function IdentifierArticle(var ACol, ARow: integer; var Cancel: boolean; Click, FromMacro: Boolean): boolean;
    procedure TraiteArticle(var ACol, ARow: integer; var Cancel: boolean; FromMacro, Calc: boolean; NewQte: double);
    procedure CodesArtToCodesLigne(TOBArt: TOB; ARow: integer);
    procedure CodesCataToCodesLigne(TOBCata, TOBArt: TOB; ArticleRef: string; ARow: integer);
    function PlusEnStock(TOBArt: TOB): boolean;
    procedure ChargeTOBDispo(ARow: integer);
    procedure LoadLesArticles;
    procedure ConstruireTobArt(TOBPiece: Tob);
    procedure ChargeNouveauDepot(TOBPiece: Tob; stNouveauDepot: string); // DBR : Depot unique chargé
    procedure LoadTOBCond(RefUnique: string);
    procedure GereArtsLies(ARow: integer);
    procedure GereLesLots(ARow: integer);
    procedure DetruitLot(ARow: integer);
    procedure GereLesSeries(ARow: integer);
    procedure DetruitSerie(ARow: integer);
    procedure TraiteLeCata(ARow: integer);
    //  CATALOGUE / CONTREMARQUE
    procedure UpdateCataLigne(ARow: longint; FromMacro, Calc: boolean; NewQte: double);
    procedure ChargeTOBDispoContreM(ARow: integer);
    procedure LigneEnContreM(var ACol, ARow: integer; var Cancel: boolean);
    function ArticleUniqueDansCatalogue(RefUnique, RefFour: string): TOB;
    procedure TraiteLaContreM(ARow: integer);
    // QUANTITES / TARIFS / DIVERS
    function TraiteRupture(ARow: integer): boolean;
    function TraiteQte(ACol, ARow: integer): boolean; dynamic;
    // Modif BTP
    function TraiteAvanc(ACol, ARow: integer): Boolean;
    // ----
    // DEBUT AJOUT CHR
    {$IFDEF CHR}
    procedure ZoomOuChoixRegroupe(ACol, ARow: integer);
    procedure TraiteDateProd(ACol, ARow: integer; var Cancel: boolean);
    procedure TraiteRegroupe(ACol, ARow: integer; var Cancel: boolean);
    procedure GereChampsChr(Arow: integer; var cancel: boolean);
    {$ENDIF}
    // FIN AJOUT CHR
    procedure TraiteLibelle(ARow: integer);
    procedure TraitePrix(ARow: integer);
    procedure TraiteRemise(ARow: integer);
    procedure TraiteMontantRemise(ACol, ARow: integer);
    {$IFDEF MODE} // Modif MODE 31/07/2002
    procedure TraitePrixNet(ACol, ARow: integer);
    procedure TraiteMontantNetLigne(ACol, ARow: integer);
    {$ENDIF}
    procedure TraiteDateLiv(ACol, ARow: integer);
    procedure TraiteLesDivers(ACol, ARow: integer);
    procedure DeflagTarif(ARow: integer);
    function TesteMargeMini(ARow: integer): boolean;
    function AutoriseQteNegative(ACol, ARow: integer; Qte: Double): boolean;
    // Motifs
    function PositionneMotif(ARow: integer): boolean;
    procedure TraiteMotif(ARow: integer);
    function AffecteMotif(ARow: integer): boolean;
    procedure ChargeTiersDefaut;
    // TIERS, DEVISES
    procedure IncidenceTauxDate;
    procedure IncidenceTiers;
    function IncidenceTarif: boolean;
    procedure IncidenceRefs;
    procedure IncidenceAcompte;
    function IdentifieTiers: boolean;
    function CalculeRisqueTiers: string;
    function TesteRisqueTiers(Valid: Boolean): boolean;
    function GetLeTauxDevise(CodeD: string; var DateTaux: TDateTime; DateP: TDateTime): Double;
    // AFFAIRES
    procedure MajDatesLivr;
    procedure IncidenceAffaire;
    procedure IncidenceLignesAffaire;
    function ChargeAffairePiece(TestCle, RepriseTiers: Boolean; ChargeLigne: boolean = True): Integer;
    procedure ChargeCleAffairePiece;
    procedure PositionErreurCodeAffaire(Sender: TObject; NbAff: integer);
    procedure ZoomOuChoixAffaire(ACol, ARow: integer);
    procedure TraiteAffaire(ACol, ARow: integer; var Cancel: boolean);
    // DEBUT AJOUT CHR
    {$IFDEF CHR}
    procedure MajCHR;
    procedure IncidenceChr;
    {$ENDIF}
    // FIN AJOUT CHR
    // Gestion du descriptif détaillé
    procedure GereDescriptif(ARow: Integer; Enter: Boolean);
    // Actions, outils
    procedure ClickDel(ARow: integer; AvecC, FromUser: boolean; SupDim: boolean = False); dynamic;
    procedure ClickInsert(ARow: integer);
    procedure ClickPrecedente;
    procedure ClickSuivante;
    procedure ClickOrigine;
    procedure SoldeLigneSup(Sup: boolean);
    procedure DesoldeLigneSup(Sup: boolean);
    procedure SoldeReliquat;
    procedure SoldeTousReliquat;
    procedure ClickSousTotal;
    procedure ClickDevise;
    procedure ChangeTVA;
    procedure ChangeRegime;
    function ExitDatePiece: Boolean;
    procedure ClickAcompte(ForcerRegle: Boolean);
    // Validations
    function SortDeLaLigne: boolean;
    procedure InverseAvoir;
    procedure ElimineLignesZero;
    procedure ValideLaPiece;
    procedure ValideImpression;
    function ExisteLigneSupp: Boolean;
    procedure ValideNumeroPieceAnnule;
    procedure ValideNumeroPiece;
    procedure DelOrUpdateAncien;
    procedure DetruitnewAcc;
    procedure ValideTiers;
    procedure ValideLaNumerotation;
    procedure ValideLesLots;
    procedure ValideLesSeries;
    procedure ValideLaCompta(OldEcr, OldStk: RMVT);
    procedure GereLesReliquats; { NEWPIECE }
    function CreerAnnulation(TOBPieceDel, TOBNomenDel: TOB): boolean;
    function CreerReliquat: boolean;
    // Modif BTP
    procedure ClickValide(EnregSeul: Boolean = False); dynamic;
    //procedure ClickValide ;  Dynamic ;
    // ------
    procedure DetruitLaPiece; dynamic; { NEWPIECE }
    procedure AjouteEvent(NatureP, MessEvent: string; QuelCas: integer);
    // Saisie en aveugle
    procedure InitSaisieAveugle;
    procedure InsertLigneGSAveugle;
    procedure InsertNewArtInGSAveugle(CodeBarre: string; Q: TQuery; TOBArt, TOBFilleSA: TOB; ARow: integer);
    function RetourneLibelleAvecDimensions(RefArtDim: string; TOBArt: TOB): string;
    procedure InsertNewArtInGS(RefArt, Designation: string; Qte: Double);
    procedure GSAVersGS(RefArt, Designation: string; Qte: double);
    procedure AffecteQuantiteZeroInGS(ReaffecteQte: Boolean = False);
    procedure AffecteUneLigneInGS(ACol, ARow: integer; ReaffecteQte: Boolean);
    procedure MAJLigneDim(ARow: Integer);
    procedure ReconstruireTobDim(ARow: Integer);
    procedure SupLigneGSA(ARow: Integer);
    function CreerTOBFilleGSA(ARow: integer): TOB;
    function RetourneTOBSaisieAveugle: TOB;
    procedure PositionFicheSaisieCodeBarre;
    function TOBGSAPleine: Boolean;
    // Modif BTP
    procedure SuppressionDetailOuvrage(Arow: integer; AvecGestionAffichage: boolean = true);
    procedure AffichageDetailOuvrage(RowReference: Integer);
    procedure SupLesLibDetail(TOBPiece: TOB);
    procedure CalculeLeDocument;
    procedure AddLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
    procedure SupLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
    // -----
  public
    SaisieTypeAffaire: boolean;
    SaisieAveugle: boolean; //saisie aveugle
    CleDoc: R_CleDoc;
    NumPieceAnnule: integer;
    Action: TActionFiche;
    NewNature, LeCodeTiers, NatPieceAnnule: string;
    DEV: RDEVISE;
    TransfoPiece, DuplicPiece: boolean;
    // modif BTP
    SaisieTypeAvanc, OrigineEXCEL: boolean;
    Codeaffaireavenant: string;
    SaContexte: TModeAff;
    Laffaire, Lavenant: string;
    ValidationSaisie: Boolean; //MODIFBTP
    lesAcomptes: TOB;
    AcompteObligatoire: boolean;
    FinTravaux: boolean;
    // --
    procedure ChargeTiers;
  end;

implementation

uses
  ParamSoc,
  UVoirSuiviPiece {GPAO VOIR_SUIVI_PIECE}
  ;

{$R *.DFM}

procedure ToutDel;
  function HGetUserName: string;
  var S: array[0..255] of char;
    i: {$IFNDEF VER110}LongWord{$ELSE}Integer{$ENDIF};
  begin
    i := sizeof(s);
    GetUserName(@s, i);
    Result := StrPas(s);
  end;
  {$IFDEF EAGLCLIENT}
var
  Q: TQuery;
  Nb: integer;
  {$ENDIF}
begin
  {$IFDEF EAGLCLIENT}
  Q := OpenSQL('SELECT COUNT(*) FROM PIECE', True);
  Nb := Q.Fields[0].AsInteger;
  Ferme(Q);
  if Nb > 20 then Exit;
  {$ELSE}
  EXIT;
  {$ENDIF}
  if uppercase(HGetUserName) <> 'DECOSSE' then Exit;
  if not DelphiRunning then Exit;
  if not V_PGI.SAV then Exit;
  ExecuteSQL('DELETE FROM PIECE');
  ExecuteSQL('DELETE FROM PIEDBASE');
  ExecuteSQL('DELETE FROM PIEDECHE');
  ExecuteSQL('DELETE FROM LIGNE');
  ExecuteSQL('DELETE FROM LIGNELOT');
  ExecuteSQL('DELETE FROM DISPO');
  ExecuteSQL('DELETE FROM DISPOLOT');
  ExecuteSQL('DELETE FROM ECRITURE');
  ExecuteSQL('DELETE FROM ANALYTIQ');
  ExecuteSQL('DELETE FROM VENTANA');
  ExecuteSQL('DELETE FROM ACOMPTES');
  ExecuteSQL('DELETE FROM PIEDPORT');
  ExecuteSQL('DELETE FROM COMPTADIFFEREE');
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Appel d'une saisie Gescom en création
Mots clefs ... : PIECE;SAISIE;CREATION;
*****************************************************************}

function CreerPiece(NaturePiece: string): boolean;
var CleDoc: R_CleDoc;
begin
  Result := True;
  if not JaiLeDroitNatureGCCreat(NaturePiece) then
  begin
    PGIInfo(TraduireMemoire('Vous ne pouvez pas créer de pièce de ce type.'),
      GetInfoParPiece(NaturePiece, 'GPP_LIBELLE'));
    Result := False;
    exit;
  end;
  if PasCreerDateGC(V_PGI.DateEntree) then Exit;
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  CleDoc.NaturePiece := NaturePiece;
  CleDoc.DatePiece := V_PGI.DateEntree;
  CleDoc.Souche := '';
  CleDoc.NumeroPiece := 0;
  CleDoc.Indice := 0;
  VH_GC.GCLastRefPiece := '';
  SaisiePiece(CleDoc, taCreat);
end;

function CreerPieceGRC(NaturePiece, LeCodeTiers: string; NoPersp: integer): boolean;
var CleDoc: R_CleDoc;
begin
  Result := True;
  if PasCreerDateGC(V_PGI.DateEntree) then Exit;
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  CleDoc.NaturePiece := NaturePiece;
  CleDoc.DatePiece := V_PGI.DateEntree;
  CleDoc.Souche := '';
  CleDoc.NumeroPiece := 0;
  CleDoc.Indice := 0;
  CleDoc.NoPersp := NoPersp;
  VH_GC.GCLastRefPiece := '';
  SaisiePiece(CleDoc, taCreat, LeCodeTiers);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Appel d'une pièce en création ou modification
Mots clefs ... : PIECE;SAISIE;
*****************************************************************}

function SaisiePiece(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string = ''; Laffaire: string = ''; Lavenant: string = ''; SaisieAvanc: boolean =
  false; OrigineEXCEL: boolean = false): boolean;
var X: TFFacture;
  PP: THPanel;
begin
  Result := True;
  SourisSablier;
  PP := FindInsidePanel;
  X := TFFacture.Create(Application);
  // modif BTP
  if GetParamSoc('SO_BTDOCAVECTEXTE') then
  begin
    if not SaisieAvanc then X.SaContexte := X.saContexte + [tModeBlocNotes];
    X.BorderStyle := bsSizeable;
  end;
  X.LAffaire := laffaire;
  X.lavenant := lavenant;
  X.SaisieTypeAvanc := SaisieAvanc;
  X.OrigineEXCEL := OrigineEXCEL;
  X.ValidationSaisie := False;
  // ----
  X.CleDoc := CleDoc;
  X.Action := Action;
  X.NewNature := X.CleDoc.NaturePiece;
  X.LeCodeTiers := LeCodeTiers;
  X.TransfoPiece := False;
  X.DuplicPiece := False;
  if PP = nil then
  begin
    try
      X.ShowModal;
    finally
      // Modif BTP
      result := X.ValidationSaisie;
      // --
      X.Free;
    end;
    SourisNormale;
  end else
  begin
    InitInside(X, PP);
    X.Show;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Appel d'une pièce en modification
Mots clefs ... : PIECE;SAISIE;
*****************************************************************}

procedure AppelPiece(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StC, StM: string;
  i_ind: integer;
  Action: TActionFiche;
  {$IFDEF GPAO}
  PiecePilotee: Boolean;
  {$ENDIF}
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StA := string(Parms[0]);
  StM := string(Parms[1]);
  {$IFDEF AFFAIRE}
  if ctxaffaire in V_PGI.PGIContexte then if AGLJaiLeDroitFiche(['PIECE', stm, sta], 3) = false then exit;
  {$ENDIF}

  Action := taModif;
  i_ind := Pos('ACTION=', StM);
  if i_ind > 0 then
  begin
    StringToCleDoc(StA, CleDoc);
    Delete(StM, 1, i_ind + 6);
    StM := uppercase(ReadTokenSt(StM));
    if StM = 'CREATION' then
    begin
      if JaiLeDroitNatureGCCreat(CleDoc.NaturePiece) then
        Action := taCreat
      else
      begin
        PGIInfo(TraduireMemoire('Vous ne pouvez pas créer de pièce de ce type.'),
          GetInfoParPiece(CleDoc.NaturePiece, 'GPP_LIBELLE'));
        exit;
      end;
    end else
      if StM = 'MODIFICATION' then
    begin
      if JaiLeDroitNatureGCModif(CleDoc.NaturePiece) then Action := taModif else Action := taConsult;
    end else
      if StM = 'CONSULTATION' then Action := taConsult;
  end;

  {$IFDEF GPAO}
  StringToCleDoc(StA, CleDoc);
  PiecePilotee := (GetInfoParPiece(CleDoc.NaturePiece, 'GPP_PIECEPILOTE') = 'X');
  case Action of
    taCreat:
      begin { Empêche la création des pièces pilotées depuis facture.pas }
        if PiecePilotee then
        begin
          PGIInfo(TraduireMemoire('Vous ne pouvez pas créer de pièce de ce type'), GetInfoParPiece(CleDoc.NaturePiece, 'GPP_LIBELLE'));
          EXIT;
        end;
      end;
    taModif:
      begin { Empêche la modification des pièces pilotées depuis facture.pas }
        if PiecePilotee then Action := taConsult;
      end;
  end;
  {$ENDIF}
  if Action = tacreat then
  begin
    CreerPiece(StC);
  end else
  begin
    StringToCleDoc(StA, CleDoc);
    if CleDoc.NaturePiece <> '' then SaisiePiece(CleDoc, Action);
  end
end;

procedure AGLCreerPiece(Parms: array of variant; nb: integer);
begin
  CreerPiece(string(Parms[0]));
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Transformation unitaire d'une pièce
Mots clefs ... : PIECE;SAISIE;TRANSFORMATION;GENERATION;
*****************************************************************}

function TransformePiece(CleDoc: R_CleDoc; NewNat: string; SaisieAveug: Boolean = False): boolean;
var X: TFFacture;
  PP: THPanel;
begin
  Result := True;
  SourisSablier;
  X := TFFacture.Create(Application);
  X.CleDoc := CleDoc;
  X.Action := taModif;
  X.NewNature := NewNat;
  X.TransfoPiece := True;
  X.DuplicPiece := False;
  X.SaisieAveugle := SaisieAveug;
  PP := FindInsidePanel;
  if ((PP = nil) or (ctxFO in V_PGI.PGIContexte)) then
  begin
    try
      X.ShowModal;
    finally
      X.Free;
    end;
    SourisNormale;
  end else
  begin
    InitInside(X, PP);
    X.Show;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Transformation unitaire d'une pièce
Mots clefs ... : PIECE;SAISIE;TRANSFORMATION;GENERATION;
*****************************************************************}

procedure AppelTransformePiece(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StM, NewNat: string;
  SaisieAveugle: Boolean;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StA := string(Parms[0]);
  StM := string(Parms[1]);
  StringToCleDoc(STA, CleDoc);
  NewNat := StM;
  SaisieAveugle := Integer(Parms[2]) = 1; // Check box coché
  if CleDoc.NaturePiece <> '' then TransformePiece(CleDoc, NewNat, SaisieAveugle);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Duplication unitaire d'une pièce
Mots clefs ... : PIECE;SAISIE;DUPLICATION;GENERATION;
*****************************************************************}

function DupliquePiece(CleDoc: R_CleDoc; NewNat: string): boolean;
var X: TFFacture;
  PP: THPanel;
begin
  Result := True;
  SourisSablier;
  X := TFFacture.Create(Application);
  // modif BTP
  if GetParamSoc('SO_BTDOCAVECTEXTE') then
  begin
    X.SaContexte := X.SaContexte + [tModeBlocNotes];
    X.BorderStyle := bsSizeable;
  end;
  // -----
  X.CleDoc := CleDoc;
  X.Action := taModif;
  X.NewNature := NewNat;
  X.TransfoPiece := False;
  X.DuplicPiece := True;
  PP := FindInsidePanel;
  if ((PP = nil) or (ctxFO in V_PGI.PGIContexte)) then
  begin
    try
      X.ShowModal;
    finally
      X.Free;
    end;
    SourisNormale;
  end else
  begin
    InitInside(X, PP);
    X.Show;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Créé le ...... : 19/01/2000
Modifié le ... : 19/01/2000
Description .. : Duplication unitaire d'une pièce
Mots clefs ... : PIECE;SAISIE;DUPLICATION;GENERATION;
*****************************************************************}

procedure AppelDupliquePiece(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StM, NewNat: string;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StA := string(Parms[0]);
  StM := string(Parms[1]);
  StringToCleDoc(STA, CleDoc);
  NewNat := StM;
  if CleDoc.NaturePiece <> '' then DupliquePiece(CleDoc, NewNat);
end;

procedure TFFacture.FindLigneFind(Sender: TObject);
begin
  Rechercher(GS, FindLigne, FindFirst);
end;

procedure TFFacture.BChercherClick(Sender: TObject);
{$IFDEF BTP}
var ind: integer;
  TOBL: TOB;
  {$ENDIF}
begin
  {$IFDEF BTP}
  if (Action <> taConsult) and (TOBPiece.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatProposition) then
  begin
    // Boucle de recherche à partir de la position courante dans la grille
    for Ind := GS.Row - 1 to TOBPiece.detail.count - 1 do
    begin
      TOBL := GetTOBLigne(TOBPiece, Ind + 1);
      // On ne traite que les lignes quantifiées hormis les lignes de sous-détails
      if (TOBL <> nil) and not (IsLigneDetail(nil, TOBL)) and (TOBL.GetValue('GL_QTEFACT') <> 0) then
      begin
        GS.Row := Ind + 1;
        GS.Col := SG_Lib;
        StCellCur := GS.Cells[GS.Col, GS.Row];
        if not (ZoomOuChoixArtLib(GS.Col, GS.Row)) then Exit; // Si on stoppe la recherche, la fonction ZoomOuChoixArtLib retourne False
      end;
    end;
  end
  else
  begin
    if GS.RowCount <= 2 then Exit;
    FindFirst := True;
    FindLigne.Execute;
  end;
  {$ELSE}
  if GS.RowCount <= 2 then Exit;
  FindFirst := True;
  FindLigne.Execute;
  {$ENDIF}
end;

{==============================================================================================}
{======================================= Initialisations ======================================}
{==============================================================================================}

procedure TFFacture.ReInitPiece;
begin
  ForcerFerme := False;
  GeneCharge := False;
  ForcerLaModif := False;
  ToutLiberer;
  ToutAllouer;
  BlocageSaisie(False);
  GP_TIERS.Text := '';
  LibelleTiers.Caption := '';
  DejaRentre := False;
  GP_ESCOMPTE.Value := 0;
  GP_REMISEPIED.Value := 0;
  GP_MODEREGLE.Value := '';
  GP_REFINTERNE.Text := '';
  GP_REPRESENTANT.Text := '';
  // MOdif BTP
  TOTALRGDEV.Value := 0;
  HTTCDEV.value := 0;
  TTYPERG.Text := '';
  TCAUTION.text := '';
  // --
  TOBPiece.PutEcran(Self, PPied);
  AfficheTaxes;
  AffichePorcs;
  // MOdif BTP
  LoadLesTextes;
  // -------
  InitEnteteDefaut(False);
  InitPieceCreation;
  AffecteGrid(GS, Action);
  if Action = taConsult then GS.MultiSelect := False else GS.Col := SG_RefArt;
  if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then
  begin
    GP_AFFAIRE.Text := '';
    GP_AFFAIRE1.Text := '';
    GP_AFFAIRE2.Text := '';
    GP_AFFAIRE3.Text := '';
    AFF_TIERS.Text := '';
    GP_AVENANT.text := '';
    LibelleAffaire.Caption := '';
  end;
  if (ctxMode in V_PGI.PGIContexte) then GS.ElipsisButton := False;
end;

procedure TFFacture.InitPasModif;
begin
  TOBPiece.SetAllModifie(False);
  TOBAdresses.SetAllModifie(False);
  TOBBases.SetAllModifie(False);
  TOBEches.SetAllModifie(False);
  TOBAcomptes.SetAllModifie(False);
  TOBPorcs.SetAllModifie(False);
  TOBTiers.SetAllModifie(False);
  TOBAnaP.SetAllModifie(False);
  TOBAnaS.SetAllModifie(False);
  TOBDesLots.SetAllModifie(False);
  TOBSerie.SetAllModifie(False);
  TOBNomenclature.SetAllModifie(False);
  // Modif BTP
  TOBOuvrage.SetAllModifie(False);
  TOBPieceRG.SetAllModifie(False);
  TOBLIENOLE.SetAllModifie(False);
  TOBBasesRG.SetAllModifie(False);
  // -----
end;

procedure TFFacture.InitToutModif;
var NowFutur: TDateTime;
begin
  NowFutur := NowH;
  TOBPiece.SetAllModifie(True);
  TOBPiece.SetDateModif(NowFutur);
  TOBAdresses.SetAllModifie(True);
  TOBBases.SetAllModifie(True);
  TOBEches.SetAllModifie(True);
  TOBAcomptes.SetAllModifie(True);
  TOBPorcs.SetAllModifie(True);
  InvalideModifTiersPiece(TOBTiers);
  TOBAnaP.SetAllModifie(True);
  TOBAnaS.SetAllModifie(True);
  TOBDesLots.SetAllModifie(True);
  TOBSerie.SetAllModifie(True);
  TOBNomenclature.SetAllModifie(True);
  // Modif BTP
  TOBOuvrage.SetAllModifie(True);
  TOBLIENOLE.SetAllModifie(true);
  TOBPieceRG.SetAllModifie(true);
  TOBBasesRG.SetAllModifie(True);
  // --
end;

procedure TFFacture.MemoriseNumLigne;
var ind, inl: integer;
  TOBL: TOB;
begin
  inl := 0;
  for ind := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := GetTOBLigne(TOBPiece, ind + 1);
    if ind = 0 then
    begin
      inl := TOBL.GetNumChamp('GL_NUMLIGNE');
      TOBL.AddChampSup('ANCIENNUMLIGNE', True);
    end;
    TOBL.PutValue('ANCIENNUMLIGNE', TOBL.GetValeur(inl));
  end;
end;

procedure TFFacture.LoadLesTOB;
var Q: TQuery;
begin
  // Lecture Pied
  Q := OpenSQL('SELECT * FROM PIECE WHERE ' + WherePiece(CleDoc, ttdPiece, False), True);
  TOBPiece.SelectDB('', Q);
  Ferme(Q);
  // Lecture Lignes
  Q := OpenSQL('SELECT * FROM LIGNE WHERE ' + WherePiece(CleDoc, ttdLigne, False) + ' ORDER BY GL_NUMLIGNE', True);
  TOBPiece.LoadDetailDB('LIGNE', '', '', Q, False, True);
  Ferme(Q);
  PieceAjouteSousDetail(TOBPiece);
  // Lecture bases
  Q := OpenSQL('SELECT * FROM PIEDBASE WHERE ' + WherePiece(CleDoc, ttdBase, False), True);
  TOBBases.LoadDetailDB('PIEDBASE', '', '', Q, False);
  Ferme(Q);
  // Lecture Echéances
  Q := OpenSQL('SELECT * FROM PIEDECHE WHERE ' + WherePiece(CleDoc, ttdEche, False), True);
  TOBEches.LoadDetailDB('PIEDECHE', '', '', Q, False);
  Ferme(Q);
  // Lecture Ports
  Q := OpenSQL('SELECT * FROM PIEDPORT WHERE ' + WherePiece(CleDoc, ttdPorc, False), True);
  TOBPorcs.LoadDetailDB('PIEDPORT', '', '', Q, False);
  Ferme(Q);
  // Lecture Adresses
  LoadLesAdresses(TOBPiece, TOBAdresses);
  // Lecture Nomenclatures
  LoadLesNomen(TOBPiece, TOBNomenclature, TOBArticles, CleDoc);
  // Lecture Lot
  LoadLesLots(TOBPiece, TOBDesLots, CleDoc);
  {$IFNDEF CCS3}
  // Lecture Serie
  LoadLesSeries(TOBPiece, TOBSerie, CleDoc);
  {$ENDIF}
  // Lecture ACompte
  LoadLesAcomptes(TOBPiece, TOBAcomptes, CleDoc, lesAcomptes);
  // Lecture Analytiques
  LoadLesAna(TOBPiece, TOBAnaP, TOBAnaS);
  // Modif BTP
  // chargement textes debut et fin
  LoadLesBlocNotes(SaContexte, TOBLienOle, Cledoc);
  // Chargement des retenues de garantie et Tva associe
  LoadLesRetenues(TOBPiece, TOBPieceRG, TOBBasesRG, CleDoc);
  // Lecture Ouvrages
  {$IFDEF BTP}
  LoadLesOuvrages(TOBPiece, TOBOuvrage, TOBArticles, Cledoc, IndiceOuv);
  {$ENDIF}
  // chargement des details ouvrage ou nomenclatures
  DEV.Code := TOBPIECE.GetValue('GP_DEVISE');
  GetInfosDevise(DEV);
  DEV.Taux := GetLeTauxDevise(DEV.Code, DEV.DateTaux, cledoc.datepiece);
  MemoriseNumLigne;
  LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc);
  // ----------
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  LoadLesTobChr;
  {$ENDIF}
  // FIN AJOUT CHR

end;

procedure TFFacture.LoadTOBCond(RefUnique: string);
var Q: TQuery;
begin
  if TOBConds.FindFirst(['GCO_ARTICLE'], [RefUnique], False) <> nil then Exit;
  Q := OpenSQL('SELECT * FROM CONDITIONNEMENT WHERE GCO_ARTICLE="' + RefUnique + '" ORDER BY GCO_NBARTICLE', True);
  if not Q.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', Q, True, False);
  Ferme(Q);
end;

procedure TFFacture.LoadLesArticles;
var i, iArt, iRefCata: integer;
  TOBL, TOBArt, TOBC, TOBCata, LocAnaP, LocAnaS: TOB;
  RefUnique, RefCata, RefFour: string;
  NaturePieceG: string;
begin
  TOBCata := nil;
  iArt := 0;
  iRefCata := 0;
  NaturePieceG := TOBPiece.GetValue('GP_NATUREPIECEG');
  ConstruireTobArt(TOBPiece);
  InitMove(TOBPiece.Detail.Count, '');
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    MoveCur(False);
    if i = 0 then
    begin
      iRefCata := TOBL.GetNumChamp('GL_REFCATALOGUE');
      iArt := TOBL.GetNumChamp('GL_ARTICLE');
    end;
    InitLesSupLigne(TOBL);
    // Récupération article
    RefCata := '';
    RefFour := '';
    RefUnique := '';
    if (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X') then
    begin
      RefCata := TOBL.GetValeur(iRefCata);
      RefFour := GetCodeFourDCM(TOBL);
      TOBCata := TOBCatalogu.FindFirst(['GCA_REFERENCE', 'GCA_TIERS'], [RefCata, RefFour], False);
      if TOBCata = nil then
        TOBCata := InitTOBCata(TOBCatalogu, RefCata, RefFour);
      LoadTOBDispoContreM(TOBL, TOBCata, False);
    end;
    RefUnique := TOBL.GetValeur(iArt);
    TobArt := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
    if TobArt <> nil then
    begin
      if (VenteAchat = 'ACH') and ((CataFourn) or (TOBL.GetValue('GL_REFARTTIERS') <> '')) then AjouteCatalogueArt(TOBL, TOBArt);
      CodesLigneToCodesArt(TOBL, TOBArt);
      TOBL.PutValue('QTEORIG', TOBL.GetValue('GL_QTESTOCK'));
    end;
    if (RefUnique <> '') or ((RefCata <> '') and (RefFour <> '')) then
    begin
      // Chargement du commercial
      AjouteRepres(TOBL.GetValue('GL_REPRESENTANT'), TypeCom, TOBComms);
      // Compta
      TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBL, TOBArt, TOBTiers, TOBCata, TobAffaire, True);
      if ((OkCpta) or (OkCptaStock)) then
      begin
        if (TOBC <> nil) and (TOBL.Detail.Count > 0) then
        begin
          if ((TOBL.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
          if ((TOBL.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
          PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBL);
        end;
      end;
    end;
    // Affichage
    AfficheLaLigne(i + 1);
  end;
  FiniMove;
  if (ctxMode in V_PGI.PGIContexte) and ((Action = taConsult) or (Action = taModif)) then AffichageDim;
end;

procedure TFFacture.ConstruireTobArt(TOBPiece: Tob);
var i, NbArt, x, CountStArt, NbRequete, y: integer;
  StSelect, StSelectDepot, StSelectDepotLot, StSelectCon, StArticle, StCodeArticle, ListeDepot, RefGen, Statut: string;
  TabWhere, TabWhereDepot, TabWhereCon: array of string;
  TOBDispo, TOBDispoLot, TOBArt, TobDispoArt, TobDispoLotArt: TOB;
  QArticle, QDepot, QDepotLot, QCon: TQuery;
  OkTab, DoubleDepot: Boolean;
begin
  StSelect := 'SELECT * FROM ARTICLE';
  StSelectDepot := 'SELECT * FROM DISPO';
  StSelectDepotLot := 'SELECT * FROM DISPOLOT';
  StSelectCon := 'SELECT * FROM CONDITIONNEMENT';
  CountStArt := 0;
  NbRequete := 0;
  ListeDepot := '';
  SetLength(TabWhere, 1);
  SetLength(TabWhereDepot, 1);
  SetLength(TabWhereCon, 1);
  DoubleDepot := (TOBPiece.GetValue('GP_NATUREPIECEG') = 'TEM') or (TOBPiece.GetValue('GP_NATUREPIECEG') = 'TRE') or (TOBPiece.GetValue('GP_NATUREPIECEG') =
    'TRV');
  if DoubleDepot then
    ListeDepot := '"' + TOBPiece.GetValue('GP_DEPOT') + '","' + TOBPiece.GetValue('GP_DEPOTDEST') + '"'
  else ListeDepot := '"' + TOBPiece.GetValue('GP_DEPOT') + '"';
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    StArticle := TOBPiece.Detail[i].GetValue('GL_ARTICLE');
    StCodeArticle := TOBPiece.Detail[i].GetValue('GL_CODEARTICLE');
    RefGen := TOBPiece.Detail[i].GetValue('GL_CODESDIM');
    Statut := TOBPiece.Detail[i].GetValue('GL_TYPEDIM');
    if Pos(TobPiece.Detail[i].GetValue('GL_DEPOT'), ListeDepot) = 0 then
    begin
      ListeDepot := ListeDepot + ', "' + TobPiece.Detail[i].GetValue('GL_DEPOT') + '"'; // DBR : Depot unique chargé
    end;
    OkTab := False;
    if CountStArt >= NbArtParRequete then
    begin
      NbRequete := NbRequete + 1;
      SetLength(TabWhere, NbRequete + 1);
      SetLength(TabWhereDepot, NbRequete + 1);
      SetLength(TabWhereCon, NbRequete + 1);
      CountStArt := 0;
    end;
    if (Statut = 'GEN') or (Statut = 'DIM') or (Statut = 'NOR') then
    begin
      if (StArticle = '') and (RefGen <> '') then RefGen := CodeArticleUnique2(RefGen, '');
      if StArticle <> '' then RefGen := StArticle;
      if TabWhere[NbRequete] = '' then TabWhere[NbRequete] := '"' + RefGen + '"'
      else TabWhere[NbRequete] := TabWhere[NbRequete] + ',"' + RefGen + '"';
      OkTab := True;
    end;
    if (Statut = 'DIM') or (Statut = 'NOR') then
    begin
      if TabWhereDepot[NbRequete] = '' then TabWhereDepot[NbRequete] := '"' + StArticle + '"'
      else TabWhereDepot[NbRequete] := TabWhereDepot[NbRequete] + ',"' + StArticle + '"';
      if TabWhereCon[NbRequete] = '' then TabWhereCon[NbRequete] := '"' + StArticle + '"'
      else TabWhereCon[NbRequete] := TabWhereCon[NbRequete] + ',"' + StArticle + '"';
      OkTab := True;
    end;
    if OkTab then CountStArt := CountStArt + 1;
  end;
  if TabWhere[0] <> '' then
  begin
    TOBDispo := TOB.CREATE('Les Dispos', nil, -1);
    TOBDispoLot := TOB.CREATE('Les Dispolots', nil, -1);
    for y := Low(TabWhere) to High(TabWhere) do
    begin
      if TabWhere[y] <> '' then
      begin
        QArticle := OpenSQL(StSelect + ' WHERE GA_ARTICLE IN (' + TabWhere[y] + ')', True);
        if not QArticle.EOF then TOBArticles.LoadDetailDB('ARTICLE', '', '', QArticle, True, True);
        Ferme(QArticle);
      end;
      if TabWhereDepot[y] <> '' then
      begin
        QDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (' + TabWhereDepot[y] + ') AND GQ_DEPOT IN (' + ListeDepot + ') AND GQ_CLOTURE="-"', True);
        { DBR : Depot unique chargé
                        If CtxMode in V_PGI.PGIContexte then QDepot:=OpenSQL(StSelectDepot+' WHERE GQ_ARTICLE IN ('+TabWhereDepot[y]+') AND GQ_DEPOT IN ('+ListeDepot+') AND GQ_CLOTURE="-"',True)
                        else begin
                            QDepot:=OpenSQL(StSelectDepot+' WHERE GQ_ARTICLE IN ('+TabWhereDepot[y]+') AND GQ_CLOTURE="-"',True) ; }
        if not (CtxMode in V_PGI.PGIContexte) then
        begin
          QDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (' + TabWhereDepot[y] + ') AND GQL_DEPOT IN (' + ListeDepot + ')', True);
          if not QDepotLot.EOF then TOBDispoLot.LoadDetailDB('DISPOLOT', '', '', QDepotLot, True, True);
          Ferme(QDepotLot);
        end;
        if not QDepot.EOF then TOBDispo.LoadDetailDB('DISPO', '', '', QDepot, True, True);
        Ferme(QDepot);
      end;
      if TabWhereCon[y] <> '' then
      begin
        QCon := OpenSQL(StSelectCon + ' WHERE GCO_ARTICLE IN (' + TabWhereCon[y] + ') ORDER BY GCO_NBARTICLE', True);
        if not QCon.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', QCon, True, True);
        Ferme(QCon);
      end;
    end;
    for x := 0 to TOBArticles.detail.count - 1 do
    begin
      TOBArticles.detail[x].AddChampSup('UTILISE', False);
      TOBArticles.detail[x].PutValue('UTILISE', '-');
      TOBArticles.detail[x].AddChampSupValeur('REFARTSAISIE', '', False);
      TOBArticles.detail[x].AddChampSupvaleur('REFARTBARRE', '', False);
      TOBArticles.detail[x].AddChampSupValeur('REFARTTIERS', '', False);
    end;
    //Affecte les stocks aux articles sélectionnés
    for NbArt := 0 to TOBArticles.detail.Count - 1 do
    begin
      TOBArt := TOBArticles.detail[NbArt];
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
    end;
    TOBDispo.Free;
    TOBDispoLot.Free;
    DispoChampSupp(TOBArticles);
  end;
end;

procedure TFFacture.ChargeNouveauDepot(TOBPiece: Tob; stNouveauDepot: string); // DBR : Depot unique chargé
var Ligne, NbArt: integer;
  StSelectDepot, StSelectDepotLot, Statut, StArticle: string;
  stWhereArt: string;
  TOBDispo, TobDispoLot, TOBArt, TobDispoArt, TobDispoLotArt: TOB;
  TQDepot, TQDepotLot: TQuery;
begin
  StSelectDepot := 'SELECT * FROM DISPO';
  StSelectDepotLot := 'SELECT * FROM DISPOLOT';

  stWhereArt := '';
  for Ligne := 0 to TOBPiece.Detail.Count - 1 do
  begin
    StArticle := TOBPiece.Detail[Ligne].GetValue('GL_ARTICLE');
    Statut := TOBPiece.Detail[Ligne].GetValue('GL_TYPEDIM');
    if (Statut = 'DIM') or (Statut = 'NOR') then
    begin
      if stWhereArt = '' then stWhereArt := '"' + StArticle + '"'
      else stWhereArt := stWhereArt + ',"' + StArticle + '"';
    end;
  end;

  if stWhereArt <> '' then
  begin
    TOBDispo := TOB.CREATE('Les Dispos', nil, -1);
    TOBDispoLot := TOB.CREATE('Les Dispolots', nil, -1);

    TQDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (' + stWhereArt + ') AND ' +
      'GQ_DEPOT="' + stNouveauDepot + '" AND GQ_CLOTURE="-"', True);
    if not TQDepot.EOF then TOBDispo.LoadDetailDB('DISPO', '', '', TQDepot, True, True);
    Ferme(TQDepot);

    TQDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (' + stWhereArt + ') AND ' +
      'GQL_DEPOT="' + stNouveauDepot + '"', True);
    if not TQDepotLot.EOF then TOBDispoLot.LoadDetailDB('DISPOLOT', '', '', TQDepotLot, True, True);
    Ferme(TQDepotLot);

    //Affecte les stocks aux articles sélectionnés
    for NbArt := 0 to TOBArticles.detail.Count - 1 do
    begin
      TOBArt := TOBArticles.detail[NbArt];
      if TobArt.FindFirst(['GQ_DEPOT'], [stNouveauDepot], False) = nil then
      begin
        TobDispoArt := TOBDispo.FindFirst(['GQ_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
        if TobDispoArt <> nil then
        begin
          TobDispoLotArt := TOBDispoLot.FindFirst(['GQL_ARTICLE', 'GQL_DEPOT'],
            [TobDispoArt.GetValue('GQ_ARTICLE'),
            TobDispoArt.GetValue('GQ_DEPOT')],
              False);
          while TobDispoLotArt <> nil do
          begin
            TobDispoLotArt.Changeparent(TobDispoArt, -1);
            TobDispoLotArt := TOBDispoLot.FindNext(['GQL_ARTICLE', 'GQL_DEPOT'],
              [TobDispoArt.GetValue('GQ_ARTICLE'),
              TobDispoArt.GetValue('GQ_DEPOT')],
                False);
          end;
          TobDispoArt.Changeparent(TOBArt, -1);
        end;
      end;
    end;
    TobDispo.Free;
    TobDispoLot.Free;
  end;
end;

procedure TFFacture.AppliqueTransfoDuplic;
var i, i_Compo, IndiceNomen: integer;
  TOBL, TOBA, TOBB, TOBN, TOBPlat: TOB;
  ToblOld: Tob; { NEWPIECE }
  OldNat, ColPlus, ColMoins, EtatVC, RefPiece, RefUnique: string;
  MajLotZero, Galop, MajSerieZero, GaSer, LotSerieTrouve, Recalcul: boolean;
begin
  if ((not TransfoPiece) and (not DuplicPiece)) then Exit;
  OldNat := TOBPiece_O.GetValue('GP_NATUREPIECEG');
  if GereStatPiece then StatPieceDuplic(TOBPiece, OldNat, NewNature)
    //  BBI : fiche correction 10336
    //else MAVideStatPiece(TOBPiece)
    ;
  //  BBI : fin fiche correction 10336
  if DuplicPiece then ChangeTzTiersSaisie(NewNature);
  CleDoc.NaturePiece := NewNature;
  CleDoc.Souche := GetSoucheG(CleDoc.NaturePiece, TOBPiece.GetValue('GP_ETABLISSEMENT'), TOBPiece.GetValue('GP_DOMAINE'));
  if not (OldNat = 'TRV') then CleDoc.NumeroPiece := GetNumSoucheG(CleDoc.Souche);
  //CleDoc.NumeroPiece:=GetNumSoucheG(CleDoc.Souche) ; NE PAS REMETTRE CETTE LIGNE : JD
  CleDoc.Indice := 0;
  CleDoc.DatePiece := V_PGI.DateEntree;
  GP_DATEPIECE.Text := DateToStr(CleDoc.DatePiece);
  GP_NUMEROPIECE.Caption := HTitres.Mess[10];
  MajFromCleDoc(TOBPiece, CleDoc);
  LotSerieTrouve := False;
  MajLotZero := False;
  MajSerieZero := False;
  TOBPiece.PutValue('GP_DEVENIRPIECE', '');
  TOBPiece.PutValue('GP_REFCOMPTABLE', '');
  TOBPiece.PutValue('GP_REFCPTASTOCK', '');
  TOBPiece.PutValue('GP_ETATVISA', 'NON');
  TOBPiece.PutValue('GP_EDITEE', '-');
  if GetParamSoc('SO_GCPIECEADRESSE') then
  begin
    // Laisser comme c'est
  end else
  begin
    TOBPiece.PutValue('GP_NUMADRESSELIVR', -1);
    TOBPiece.PutValue('GP_NUMADRESSEFACT', -2);
  end;
  if DuplicPiece then
  begin
    TOBPiece.PutValue('GP_VIVANTE', 'X');
    TOBPiece.PutValue('GP_ACOMPTE', 0);
    TOBPiece.PutValue('GP_ACOMPTEDEV', 0);
    TOBPiece.PutValue('GP_ACOMPTECON', 0);
    // GRC-MNG
    TOBPiece.PutValue('GP_PERSPECTIVE', 0);
    TOBPiece.PutValue('GP_RESSOURCE', '');
    //ClearAffaire(TOBPiece) ;
    TOBAcomptes.ClearDetail;
    TOBEches.ClearDetail;
    ReinitRGUtilises(TOBPieceRG);
  end else
  begin
    // Provisoire : Reinitialisation des échéances
    TOBEches.ClearDetail;
    if ((GereLot) and (TOBPiece_O.GetValue('GP_ARTICLESLOT') <> 'X')) then MajLotZero := True;
    if ((GereSerie) and (TOBSerie_O.Detail.Count <= 0)) then MajSerieZero := True;
    if CtxMode in V_PGI.PGIContexte then GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False)
    else GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False);
    {Etudier modif dépôt O/N}
    ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
    if ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0)) then PasToucheDepot := True;
    if PasToucheDepot then GP_DEPOT.Enabled := False;
  end;

  Recalcul := False; { NEWPIECE }
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    { Récupère la ligne précédente dans la TobPiece_O }{ NEWPIECE }
    ToblOld := FindTobLigInOldTobPiece(Tobl, TobPiece_O);
    if Assigned(ToblOld) then
      RefPiece := EncodeRefPiece(ToblOld);
    MajFromCleDoc(TOBL, CleDoc);
    if DuplicPiece then
    begin
      TOBL.PutValue('GL_PIECEORIGINE', '');
      TOBL.PutValue('GL_PIECEPRECEDENTE', '');
      TOBL.PutValue('GL_QTERELIQUAT', 0);
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      TOBL.PutValue('GL_QTERESTE', TOBL.GetValue('GL_QTESTOCK'));
      TOBL.PutValue('GL_POURCENTAVANC', 0);
      TOBL.PutValue('GL_QTEPREVAVANC', 0);
      TOBL.PutValue('GL_QTESIT', 0);
      TOBL.PutValue('GL_VALIDECOM', 'NON');
      CommVersLigne(TOBPiece, TOBArticles, TOBComms, i + 1, True);
      TOBL.PutValue('GL_VIVANTE', 'X');
      TOBL.PutValue('GL_REFCOLIS', '');
      TOBL.PutValue('GL_NUMORDRE', 0);
      // ClearAffaire(TOBL) ;
    end else
    begin
      //       RefPiece:=EncodeRefPiece(TOBPiece_O.Detail[i]) ; { NEWPIECE }
      TOBL.PutValue('GL_PIECEPRECEDENTE', RefPiece);
      if TOBL.GetValue('GL_PIECEORIGINE') = '' then TOBL.PutValue('GL_PIECEORIGINE', RefPiece);
      TOBL.PutValue('GL_QTERELIQUAT', 0);
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      TOBL.PutValue('GL_QTEFACT', TOBL.GetValue('GL_QTERESTE')); { NEWPIECE }
      TOBL.PutValue('GL_QTESTOCK', TOBL.GetValue('GL_QTERESTE')); { NEWPIECE }
      Recalcul := True;
      EtatVC := TOBL.GetValue('GL_VALIDECOM');
      if EtatVC = 'VAL' then TOBL.PutValue('GL_VALIDECOM', 'AFF') else
        if EtatVC = 'AFF' then CommVersLigne(TOBPiece, TOBArticles, TOBComms, i + 1, False);
      {Lots}
      if MajLotZero then
      begin
        TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
        if TOBA <> nil then Galop := (TOBA.GetValue('GA_LOT') = 'X') else Galop := False;
        if Galop then
        begin
          if GereReliquat then TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('GL_QTESTOCK'));
          //             TOBL.PutValue('GL_QTEFACT',0) ; TOBL.PutValue('GL_QTESTOCK',0) ; { NEWPIECE }
          LotSerieTrouve := True;
        end;
      end;
      {Série}
      if MajSerieZero then
      begin
        GaSer := (TOBL.GetValue('GL_NUMEROSERIE') = 'X');
        if not (GaSer) then
        begin
          TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
          if TOBA <> nil then GaSer := (TOBA.GetValue('GA_NUMEROSERIE') = 'X') else GaSer := False;
          //JS 13/03/03
          if ((TOBL.GetValue('GL_TYPEARTICLE') = 'NOM') and (TOBL.GetValue('GL_TYPENOMENC') = 'ASS')) then
          begin // Nomenclatures
            IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
            if (IndiceNomen > 0) and (TOBNomenclature <> nil) then
              if TOBNomenclature.Detail.Count - 1 >= IndiceNomen - 1 then
              begin
                TOBN := TOBNomenclature.Detail[IndiceNomen - 1];
                TOBPlat := TOB.Create('', nil, -1);
                NomenAPlat(TOBN, TOBPlat, 1);
                for i_Compo := 0 to TOBPlat.Detail.Count - 1 do
                begin
                  RefUnique := TOBPlat.Detail[i_Compo].GetValue('GLN_ARTICLE');
                  TOBA := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
                  if TOBA <> nil then
                    if TOBA.GetValue('GA_NUMEROSERIE') = 'X' then
                    begin
                      GaSer := True;
                      break;
                    end;
                end;
                TOBPlat.Free; //TOBPlat := nil;
              end;
          end;
        end;
        if GaSer then
        begin
          TOBL.PutValue('GL_NUMEROSERIE', 'X');
          if GereReliquat then TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('GL_QTESTOCK'));
          //             TOBL.PutValue('GL_QTEFACT',0) ; TOBL.PutValue('GL_QTESTOCK',0) ; { NEWPIECE }
          LotSerieTrouve := True;
        end;
      end;
      AfficheLaLigne(i + 1);
    end;
    {$IFNDEF CEGID}
    {Pour CEGID, la duplication conserve les px valo et ne les réaffecte pas}
    if ((DuplicPiece) or (GetInfoParPiece(NewNature, 'GPP_RECALCULPRIX') = 'X')) then
    begin
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
      if TOBA <> nil then AffectePrixValo(TOBL, TOBA, TOBOuvrage);
    end;
    {$ENDIF}
  end;
  for i := 0 to TOBBases.Detail.Count - 1 do
  begin
    TOBB := TOBBases.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBEches.Detail.Count - 1 do
  begin
    TOBB := TOBEches.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  ReliquatTransfo := ((TransfoPiece) and (GereReliquat));
  if ((GereSerie) and (TOBSerie_O.Detail.Count > 0) and (ReliquatTransfo)) then InitialiseReliquatSerie;
  if (Recalcul) or ((TransfoPiece) and (LotSerieTrouve) and ((MajLotZero) or (MajSerieZero))) then
  begin
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end;
  if DuplicPiece then
  begin
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
    TOBPiece.PutEcran(Self);
    AfficheTaxes;
    AffichePorcs;
  end;
end;

procedure TFFacture.EtudieReliquat;
var
  TOBT: TOB;
  TypeRel: string;
begin
  GereReliquat := (Action = taModif) and GppReliquat; { NEWPIECE }
  { Exceptions tiers }
  if TOBTiers = nil then Exit;
  TOBT := TOBTiers.FindFirst(['GTP_NATUREPIECEG'], [NewNature], False);
  if TOBT <> nil then
  begin
    TypeRel := TOBT.GetValue('GTP_RELIQUAT');
    if TypeRel = 'OUI' then
    begin
      GereReliquat := (Action = taModif);
      GppReliquat := True;
    end
    else
      if TypeRel = 'NON' then
    begin
      GereReliquat := False;
      GppReliquat := False;
    end;
  end;
end;

procedure TFFacture.InitialiseReliquatSerie;
var i_ind1: integer;
  //TOBSRel : TOB;
begin
  for i_ind1 := 0 to TOBSerie_O.Detail.Count - 1 do
  begin
    //TOBSRel:=TOB.Create('',TOBSerRel,-1);
    TOB.Create('', TOBSerRel, -1);
    //   for i_ind2:=0 to TOBSerie_O.Detail[i_ind1].Detail.Count-1 do TOB.Create('LIGNESERIE',TOBSRel,-1);
  end;
end;

procedure TFFacture.GereVivante;
var Morte: boolean;
  NumMess: integer;
  {$IFDEF BTP}
  TypeFac: string;
  {$ENDIF}
begin
  if Action <> taModif then Exit;
  if DuplicPiece then Exit;
  //if TransfoPiece then Exit;
  NumMess := 9;

  {$IFDEF BTP}
  TypeFac := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (TypeFac = 'AVA')) or
    ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC') and (TypeFac = 'DAC')) then
  begin
    if DerniereSituation(TOBPiece) = False then TobPiece.PutValue('GP_VIVANTE', '-');
    NumMess := 43;
  end;
  {$ENDIF}

  Morte := (TOBPiece.GetValue('GP_VIVANTE') = '-');

  if Morte then
  begin
    if TransfoPiece then
    begin
      TransfoPiece := False;
      NewNature := TOBPiece.GetValue('GP_NATUREPIECEG');
      FTitrePiece.Caption := GetInfoParPiece(NewNature, 'GPP_LIBELLE');
    end;
    Action := taConsult;
    HPiece.Execute(NumMess, Caption, '');
  end else
  begin
    BDelete.Visible := True;
  end;
end;

procedure TFFacture.InitEuro;
begin
  if TOBPiece.GetValue('GP_SAISIECONTRE') = 'X' then PopD.Items[1].Checked := True else
    if TOBPiece.GetValue('GP_DEVISE') <> V_PGI.DevisePivot then PopD.Items[2].Checked := True else
    PopD.Items[0].Checked := True;
  AfficheEuro;
end;

procedure TFFacture.InitRIB;
begin
  if Action = taCreat then Exit;
  if DuplicPiece then Exit;
  TOBTiers.PutValue('RIB', TOBPiece.GetValue('GP_RIB'));
end;

function TFFacture.FromAvoir: boolean;
begin
  Result := False;
  if TOBPiece = nil then Exit;
  if Action = taConsult then Exit;
  if not DuplicPiece then Exit;
  Result := (GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_ESTAVOIR') = 'X');
end;

// Modif BTP

procedure TFFActure.SupLigneRgUnique;
var TOBL: TOB;
begin
  if (not RGMultiple(TOBPIECERG)) then
  begin
    TOBL := TOBPIECE.findfirst(['GL_TYPELIGNE'], ['RG'], true);
    TOBLIGNERG := TOB.Create('LIGNERGUNIQ', nil, -1);
    if TOBL <> nil then
    begin
      TOBLIGNERG.addchampsupValeur('PIECEPRECEDENTE', TOBL.GetValue('GL_PIECEPRECEDENTE'));
      TOBL.free;
    end;
  end;
end;
// ---

procedure TFFacture.ChargeLaPiece;
var
  Ind: integer;
  TOBL, TOBA: TOB;
  {$IFDEF BTP}
  TypeFacturation: string;
  {$ENDIF}
begin
  IndiceOuv := 1;
  {$IFDEF CHR}
  RemplirTOBHrdossier(GP_HRDOSSIER.Text, TobHrdossier);
  {$ENDIF}
  LoadLesTOB;
  EvaluerMaxNumOrdre(TOBPiece);
  TOBPiece_O.Dupliquer(TOBPiece, True, True); { NEWPIECE }
  if TransfoPiece then
  begin
    { Lors d'une transformation, écarte les lignes soldées de la TobPiece }
    for Ind := TobPiece.Detail.Count - 1 downto 0 do
    begin
      TobL := TOBPiece.Detail[ind];
      if EstLigneArticle(TobL) and EstLigneSoldee(TobL) then
        TobL.Free;
    end;
    { Message d'alerte si toutes les lignes de la pièce d'origine sont soldées }
    if TobPiece.Detail.Count = 0 then
      HPiece.Execute(54, Caption, '');
  end;
  SupLigneRgUnique;
  TOBBasesRG_O.Dupliquer(TOBBASESRG, True, True);
  if TOBPieceRG.detail.count = 0 then TOBBasesRG.clearDetail;
  if TOBPiece.Detail.Count >= GS.RowCount - 1 then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      GS.RowCount := TOBPiece.Detail.Count + 2;
      if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
      GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    end
    else
    begin
      {$IFDEF BTP}
      TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
      if (SaisieTypeAvanc = true) and ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
        GS.RowCount := TOBPiece.Detail.Count + 1
          {$ELSE}
      GS.RowCount := TOBPiece.Detail.Count + 1;
      {$ENDIF}
    end;
  end;
  PositionneEuroGescom;
  if (FromAvoir) or ((not DuplicPiece) and (EstAvoir)) then InverseAvoir;
  TOBPiece.PutEcran(Self);
  if CleDoc.DatePiece <= 0 then CleDoc.DatePiece := TOBPiece.GetValue('GP_DATEPIECE');
  AfficheTaxes;
  AffichePorcs;
  EtudieColsListe;
  GP_NUMEROPIECE.Caption := IntToStr(TOBPiece.GetValue('GP_NUMERO'));
  Ind := TOBPiece.GetValue('GP_INDICEG');
  if Ind > 0 then GP_NUMEROPIECE.Caption := GP_NUMEROPIECE.Caption + '  ' + IntToStr(Ind);
  ChargeTiers;
  InitEuro;
  InitRIB;
  LoadLesArticles;
  LoadLesTextes;
  //TOBPiece_O.Dupliquer(TOBPiece,True,True) ; { NEWPIECE Deplacé }
  OldHT := TOBPiece_O.GetValue('GP_TOTALHT');
  for ind := 0 to TOBPiece_O.Detail.Count - 1 do
  begin
    TOBL := TOBPiece_O.Detail[ind];
    if TOBL <> nil then
    begin
      if TOBL.FieldExists('ANCIENNUMLIGNE') then
        TOBL.PutValue('GL_NUMLIGNE', TOBL.GetValue('ANCIENNUMLIGNE'));
      SommationAchatDoc(TOBPiece, TOBL);
      if (not SaisieTypeAvanc) then
        CalculMargeLigne(Ind + 1)
      else
      begin
        CalculValoAvanc(TOBPIece, Ind, DEV);
        if FinTravaux then
          TOBPiece.detail[ind].putvalue('GL_QTESIT', 0);
        AfficheLaLigne(Ind + 1);
      end;
    end;
    if SaisieTypeAvanc then TOBPiece.PutValue('GP_RECALCULER', 'X');
    if TOBL.Detail.Count > 0 then
    begin
      TOBA := TOBL.Detail[0];
      TOBA.ClearDetail;
    end;
  end;
  TOBBases_O.Dupliquer(TOBBases, True, True);
  TOBAdresses_O.Dupliquer(TOBAdresses, True, True);
  TOBEches_O.Dupliquer(TOBEches, True, True);
  TOBPorcs_O.Dupliquer(TOBPorcs, True, True);
  TOBN_O.Dupliquer(TOBNomenclature, True, True);
  TOBLOT_O.Dupliquer(TOBdesLots, True, True);
  TOBSerie_O.Dupliquer(TOBSerie, True, True);
  TOBAcomptes_O.Dupliquer(TOBAcomptes, True, True);
  if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then ChargeAffairePiece(False, True);
  TOBOuvrage_O.Dupliquer(TOBOuvrage, True, True);
  TOBLIENOLE_O.Dupliquer(TOBLIENOLE, True, True);
  TOBPIECERG_O.Dupliquer(TOBPIECERG, True, True);
  NumeroteLignesGC(GS, TOBpiece);
end;

procedure TFFacture.InitEnteteDefaut(Totale: boolean);
begin
  if Totale then
  begin
    CleDoc.DatePiece := V_PGI.DateEntree;
    GP_DATEPIECE.Text := DateToStr(CleDoc.DatePiece);
    GP_DATELIVRAISON.Text := DateToStr(CleDoc.DatePiece);
    if VH^.EtablisDefaut <> '' then GP_ETABLISSEMENT.Value := VH^.EtablisDefaut else
      if GP_ETABLISSEMENT.Values.Count > 0 then GP_ETABLISSEMENT.Value := GP_ETABLISSEMENT.Values[0];
    if VH_GC.GCMultiDepots then
    begin
      if VH_GC.GCDepotDefaut <> '' then GP_DEPOT.Value := VH_GC.GCDepotDefaut else
        if GP_DEPOT.Values.Count > 0 then GP_DEPOT.Value := GP_DEPOT.Values[0];
    end;
  end;
  GP_DEVISE.Value := V_PGI.DevisePivot;
  GP_NUMEROPIECE.Caption := '';
  CleDoc.NumeroPiece := 0;
  GP_FACTUREHT.Checked := True;
  GP_SAISIECONTRE.Checked := False;
  GP_REGIMETAXE.Value := VH^.RegimeDefaut;
  ChangeTzTiersSaisie(NewNature);
  TOBPiece.GetEcran(Self);
  TOBPiece.PutValue('GP_NATUREPIECEG', NewNature);
  TOBPiece.PutValue('GP_VENTEACHAT', VenteAchat);
  AfterInitEnteteDefaut(Self);
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  MajCHR;
  {$ENDIF}
  // FIN AJOUT CHR
end;

procedure TFFacture.InitPieceCreation;
var Etab: string;
begin
  if Action = taCreat then PositionneEtabUser(GP_ETABLISSEMENT);
  if GP_ETABLISSEMENT.Value = '' then Etab := VH^.EtablisDefaut else Etab := GP_ETABLISSEMENT.Value;
  CleDoc.Souche := GetSoucheG(CleDoc.NaturePiece, Etab, GP_DOMAINE.Value);
  CleDoc.NumeroPiece := GetNumSoucheG(CleDoc.Souche);
  GP_NUMEROPIECE.Caption := HTitres.Mess[10];
  ChargeTiersDefaut;
  InitTOBPiece(TOBPiece);
  TOBPiece.PutValue('GP_NUMERO', CleDoc.NumeroPiece);
  TOBPiece.PutValue('GP_SOUCHE', CleDoc.Souche);
  if GP_TIERS.CanFocus then GP_TIERS.SetFocus else GotoEntete;
  TOBPiece.PutValue('GP_PERSPECTIVE', CleDoc.NoPersp); //PAUL
end;

procedure TFFacture.BlocageSaisie(Bloc: boolean);
begin
  if Action <> taCreat then Exit;
  if ((Bloc) and (TOBArticles.Detail.Count <= 0)) then Exit;
  BloquePiece(taCreat, Bloc);
end;

procedure TFFacture.BloquePiece(ActionSaisie: TActionFiche; Bloc: boolean);
begin
  if ActionSaisie = taConsult then
  begin
    PEntete.Enabled := not Bloc;
    GP_ESCOMPTE.Enabled := not Bloc;
    GP_REMISEPIED.Enabled := not Bloc;
    BValider.Enabled := not Bloc;
    Descriptif.Enabled := not Bloc;
    {$IFNDEF EAGLCLIENT}
    MBSGED.Visible := AglIsoflexPresent;
    {$ENDIF}
  end else if ActionSaisie = taCreat then
  begin
    GP_DEVISE.Enabled := not Bloc;
    BDEVISE.Enabled := not Bloc;
    GP_DOMAINE.Enabled := not Bloc;
    if ctxMode in V_PGI.PGIContexte then GP_ETABLISSEMENT.Enabled := not Bloc;
  end else
  begin
    if not DuplicPiece then
    begin
      GP_TIERS.Enabled := not Bloc;
      GP_DEVISE.Enabled := not Bloc;
      BDEVISE.Enabled := not Bloc;
      GP_DOMAINE.Enabled := not Bloc;
      if ctxMode in V_PGI.PGIContexte then GP_ETABLISSEMENT.Enabled := not Bloc;
    end else
    begin
      GP_DEVISE.Enabled := False;
      BDEVISE.Enabled := False;
      GP_DOMAINE.Enabled := False;
    end;
  end;
  AfterBloquePiece(Self, ActionSaisie, Bloc);
end;

procedure TFFacture.GotoEntete;
begin
  if GP_DATEPIECE.CanFocus then
  begin
    GP_DATEPIECE.SetFocus;
    Exit;
  end;
  if GP_TIERS.CanFocus then
  begin
    GP_TIERS.SetFocus;
    Exit;
  end;
  if GP_ETABLISSEMENT.CanFocus then
  begin
    GP_ETABLISSEMENT.SetFocus;
    Exit;
  end;
  if GP_REFINTERNE.CanFocus then
  begin
    GP_REFINTERNE.SetFocus;
    Exit;
  end;
end;

procedure TFFacture.WMGetMinMaxInfo(var MSG: Tmessage);
begin
  with PMinMaxInfo(MSG.lparam)^.ptMinTrackSize do
  begin
    X := WMinX;
    Y := WMinY;
  end;
  if Assigned(TSaisieAveugle) and (ctxMode in V_PGI.PGIContexte) then PositionFicheSaisieCodeBarre;
end;

procedure TFFacture.GotoPied;
begin
  if GP_ESCOMPTE.CanFocus then
  begin
    GP_ESCOMPTE.SetFocus;
    Exit;
  end;
  if GP_REMISEPIED.CanFocus then
  begin
    GP_REMISEPIED.SetFocus;
    Exit;
  end;
end;

{==============================================================================================}
{=============================== Evènements de la Form ========================================}
{==============================================================================================}

procedure TFFacture.FormCreate(Sender: TObject);
begin
  // Modif BTP
  DefinitionTaillePied;
  InitContexteGrid;
  // Initialisation pour gestion des acomptes Mode BTP
  LesAcomptes := nil;
  AcompteObligatoire := false;
  FinTravaux := false;
  // --
  InitLesCols;
  PPInfosLigne := TStringList.Create;
  FillChar(IdentCols, Sizeof(IdentCols), #0);
  ToutAllouer;
  GeneCharge := False;
  DejaRentre := False;
  ValideEnCours := False;
  CataFourn := False;
  TotEnListe := False;
  AvoirDejaInverse := False;
  ForcerLaModif := False;
  PasBouclerCreat := False;
  {$IFDEF BTP}
  PasBouclerCreat := True;
  {$ELSE}
  if CleDoc.NoPersp > 0 then PasBouclerCreat := True;
  {$ENDIF}
  {$IFDEF CHR}
  PasBouclerCreat := True;
  {$ENDIF}
  GS.GetCellCanvas := GetCellCanvas;
  GS.PostDrawCell := PostDrawCell;
  //GSAveugle.PostDrawCell:=ColTriangle; //Saisie Aveugle
  GSAveugle.DBIndicator := True;
  GS.SquizzInvisibleCells := True;
  RempliPopD;
  RempliPopY;
  WMinX := Width - 100;
  WMinY := Height - 10;
  AfterFormCreate(Self);
  FClosing := False;
  // Modif BTP
  NbLignesGrille := GS.Rowcount;
  RowCollage := -1;
  ColCollage := -1;
  {$IFDEF BTP}
  GS.PopupMenu := POPGS;
  GS.OnContextPopup := GSContextPopup;
  GS.OnFlipSelection := GSFlipSelection;
  GS.OnBeforeFlip := GSBeforeFlip;
  {$ENDIF}
  // ---
end;

procedure TFFacture.PopEuro(Sender: TObject);
begin
  ChoixEuro(Sender);
end;

procedure TFFacture.ChoixEuro(Sender: TObject);
var T: TMenuItem;
begin
  T := TMenuItem(Sender);
  if T.Name = 'POPD_S1' then PopD.Items[0].Checked := True else
    if T.Name = 'POPD_S2' then PopD.Items[1].Checked := True else
    if T.Name = 'POPD_S3' then PopD.Items[2].Checked := True;
  AfficheEuro;
end;

procedure TFFacture.RempliPopY;
var i_ind: integer;
begin
  for i_ind := 0 to POPY.Items.Count - 1 do
  begin
    if uppercase(POPY.Items[i_ind].Name) = 'LIBREPIECE' then
    begin
      POPY.Items[i_ind].Visible := False;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'MBSGED' then
    begin
      //mcd 17/04/02 pour ne pas afficher menu SGED si pas géré
      {$IFNDEF EAGLCLIENT}
      POPY.Items[i_ind].Visible := AglIsoflexPresent;
      {$ENDIF}
      Break;
    end;
  end;
  if (ctxMode in V_PGI.PGIContexte) then Exit;
  {$IFDEF BTP}
  SRDocGlobal.onclick := SRDocGlobalClick;
  SRDocParag.onclick := SRDocParagClick;
  {$IFDEF BTPS5}
  Fraisdetail.onclick := FraisdetailClick;
  {$ENDIF}
  {$ENDIF}
end;

procedure TFFacture.RempliPopD;
var S1, S2, S3: string;
begin
  S1 := RechDom('TTDEVISETOUTES', V_PGI.DevisePivot, False);
  if VH^.TenueEuro then S2 := RechDom('TTDEVISETOUTES', V_PGI.DeviseFongible, False)
  else S2 := HTitres.Mess[14];
  S3 := HTitres.Mess[15];
  POPD_S1.Caption := S1;
  POPD_S2.Caption := S2;
  POPD_S3.Caption := S3;
  if ForceEuroGC then POPD_S2.Enabled := False;
end;

procedure TFFacture.ChargeFromNature;
var PassP, CodeL: string;
  i: integer;
  GestionNotesDoc: string;
begin
  if ctxAffaire in V_PGI.PGIContexte then
  begin
    if SaisieTypeAvanc = True then GS.ListeParam := GetParamsoc('SO_LISTEAVANC')
    else
      {$IFDEF BTP}
      GS.ListeParam := GetInfoParPiece(NewNature, 'GPP_LISTESAISIE');
    {$ELSE}
      GS.ListeParam := GetInfoParPiece(NewNature, 'GPP_LISTEAFFAIRE');
    {$ENDIF}
  end else GS.ListeParam := GetInfoParPiece(NewNature, 'GPP_LISTESAISIE');
  // Modif BTP
  PresentSousDetail := GetInfoParPiece(NewNature, 'GPP_TYPEPRESENT');
  if OrigineEXCEL then PresentSousDetail := DOU_AUCUN;
  GestionNotesDoc := GetInfoParPiece(NewNature, 'GPP_TYPEPRESDOC');
  if GestionNotesDoc = 'AUC' then
  begin
    if (tModeBlocNotes in SaContexte) then SaContexte := SaContexte - [TModeBlocNotes];
  end;
  if GestionNotesDoc = 'TOU' then
  begin
    if not (tModeBlocnotes in SaContexte) then SaContexte := SaContexte + [tModeBlocNotes];
  end;
  // -----
  {Caractéristiques nature}
  VenteAchat := GetInfoParPiece(NewNature, 'GPP_VENTEACHAT');
  GereStatPiece := GetInfoParPiece(NewNature, 'GPP_AFFPIECETABLE') = 'X';
  EstAvoir := (GetInfoParPiece(NewNature, 'GPP_ESTAVOIR') = 'X');
  {commercial}
  TypeCom := GetInfoParPiece(NewNature, 'GPP_TYPECOMMERCIAL');
  if TypeCom = '' then if ctxFO in V_PGI.PGIContexte then TypeCom := 'VEN' else TypeCom := 'REP';
  {Comptabilité}
  PassP := GetInfoParPiece(NewNature, 'GPP_TYPEECRCPTA');
  OkCpta := ((PassP <> '') and (PassP <> 'RIE'));
  CompAnalP := GetInfoParPiece(NewNature, 'GPP_COMPANALPIED');
  CompAnalL := GetInfoParPiece(NewNature, 'GPP_COMPANALLIGNE');
  CompStockP := GetInfoParPiece(NewNature, 'GPP_COMPSTOCKPIED');
  CompStockL := GetInfoParPiece(NewNature, 'GPP_COMPSTOCKLIGNE');
  OkCptaStock := IsComptaStock(NewNature);
  {Visas}
  NeedVisa := (GetInfoParPiece(NewNature, 'GPP_VISA') = 'X');
  MontantVisa := GetInfoParPiece(NewNature, 'GPP_MONTANTVISA');
  {Commentaires}
  CommentEnt := GetInfoParPiece(NewNature, 'GPP_COMMENTENT');
  CommentPied := GetInfoParPiece(NewNature, 'GPP_COMMENTPIED');
  {Ruptures}
  CalcRupt := GetInfoParPiece(NewNature, 'GPP_CALCRUPTURE');
  ForceRupt := (GetInfoParPiece(NewNature, 'GPP_FORCERUPTURE') = 'X');
  {Mécanismes et automatismes}
  GereEche := GetInfoParPiece(NewNature, 'GPP_GEREECHEANCE');
  GereAcompte := (GetInfoParPiece(NewNature, 'GPP_ACOMPTE') = 'X');
  ObligeRegle := (GetInfoParPiece(NewNature, 'GPP_OBLIGEREGLE') = 'X');
  OuvreAutoPort := (GetInfoParPiece(NewNature, 'GPP_OUVREAUTOPORT') = 'X');
  GereContreM := (VenteAchat = 'VEN') and (GetInfoParPiece(NewNature, 'GPP_CONTREMARQUE') = 'X');
  ApplicRetenue := (GetInfoParPiece(NewNature, 'GPP_APPLICRG') = 'X');
  if not (ctxAffaire in V_PGI.PGIContexte) then // PA a voir pb plantage ?
    GereLot := (GetInfoParPiece(NewNature, 'GPP_LOT') = 'X');
  {$IFDEF CCS3}
  GereSerie := False;
  {$ELSE}
  GereSerie := (GetInfoParPiece(NewNature, 'GPP_NUMEROSERIE') = 'X');
  {$ENDIF}
  GppReliquat := (GetInfoParPiece(NewNature, 'GPP_RELIQUAT') = 'X'); { NEWPIECE }
  {Divers}
  DimSaisie := GetInfoParPiece(NewNature, 'GPP_DIMSAISIE');
  {Infos lignes}
  PPInfosLigne.Clear;
  for i := 1 to 8 do
  begin
    CodeL := GetInfoParPiece(NewNature, 'GPP_IFL' + IntToStr(i));
    if CodeL <> '' then PPInfosLigne.Add(RechDom('GCINFOLIGNE', CodeL, False) + ';' + RechDom('GCINFOLIGNE', CodeL, True));
  end;
  {Titres}
  FTitrePiece.Caption := GetInfoParPiece(NewNature, 'GPP_LIBELLE');
  if VenteAchat = 'VEN' then HGP_TIERS.Caption := HTitres.Mess[24] else
    if VenteAchat = 'ACH' then HGP_TIERS.Caption := HTitres.Mess[25];
end;

procedure TFFacture.EnabledGrid;
var EnaWord: boolean;
begin
  if (CtxMode in V_PGI.PGIContexte) then
  begin
    BSaisieAveugle.Enabled := True;
    TFusionner.Visible := True;
  end;
  //CHR le 04/03/02
  if (CtxChr in V_PGI.PGIContexte) then BSaisieAveugle.Visible := False;
  Librepiece.Visible := GereStatPiece;
  {$IFDEF BTP}
  if OrigineEXCEL then HTitres.Mess[16] := TraduireMemoire('Recherche Lexicale')
  else HTitres.Mess[16] := '';
  {$ELSE}
  BVentil.Visible := ((VPiece.Visible) or (VLigne.Visible) or (SPiece.Visible) or (SLigne.Visible));
  {$ENDIF}
  BEche.Visible := ((GereEche = 'AUT') or (GereEche = 'DEM'));
  BEche.Enabled := BEche.Visible;
  if ((not BEche.Visible) and (not BVentil.Visible)) then Sep2.Visible := False;
  BAcompte.Enabled := ((GereAcompte) and (Action <> taConsult));
  {$IFDEF BTP}
  BAcompte.Enabled := BAcompte.Enabled and (not AcompteObligatoire);
  {$ENDIF}
  BInfos.Enabled := True;
  BPorcs.Enabled := True;
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  BPorcs.Enabled := False;
  {$ENDIF}
  // FIN AJOUT CHR
  if (Action = taConsult) and (not (tModeBlocnotes in saContexte)) then
  begin
    CommentLigne := False;
  end else
  begin
    if not (tModeBlocNotes in SaContexte) then
    begin
      TCommentEnt.Visible := (CommentEnt <> '');
      TCommentPied.Visible := (CommentPied <> '');
    end;
    BActionsLignes.Enabled := True;
    BSousTotal.Enabled := True;
    CommentLigne := True;
  end;
  {Accès edition Word}
  EnaWord := True;
  if GetParamSoc('SO_GCMODELEWORD') = '' then EnaWord := False else
    if GetParamSoc('SO_GCREPERTOIREWORD') = '' then EnaWord := False else
    if ((OkCpta) or (OkCptaStock)) then EnaWord := False else
    if Pos('PHY', GetInfoParPiece(NewNature, 'GPP_QTEPLUS')) > 0 then EnaWord := False else
    if Pos('PHY', GetInfoParPiece(NewNature, 'GPP_QTEMOINS')) > 0 then EnaWord := False;
  BOffice.Visible := EnaWord;
end;

procedure TFFacture.EnabledPied;
var StC: string;
  {$IFDEF BTP}
  TypeFac: string;
  {$ENDIF}
begin
  StC := TOBPiece.GetValue('GP_REFCOMPTABLE');
  BZoomEcriture.Enabled := ((StC <> '') and (StC <> 'DIFF'));
  StC := TOBPiece.GetValue('GP_REFCPTASTOCK');
  BZoomStock.Enabled := ((StC <> '') and (StC <> 'DIFF'));
  BZoomSuivante.Enabled := ((Action <> taCreat) and (TOBPiece.GetValue('GP_DEVENIRPIECE') <> ''));
  MBTarif.Enabled := ((GetInfoParPiece(NewNature, 'GPP_CONDITIONTARIF') = 'X') and (Action <> taConsult));
  MBDatesLivr.Enabled := (Action <> taConsult);
  if ctxAffaire in V_PGI.PGIContexte then MBDatesLivr.Visible := False;
  if (ctxMode in V_PGI.PGIContexte) and not (ctxFO in V_PGI.PGIContexte) then BNouvelArticle.visible := True;
  //CHR le 04/03/02
  if (ctxChr in V_PGI.PGIContexte) then BNouvelArticle.visible := False;
  // Modif BTp du 17/05/2001
  {$IFDEF BTP}
  MBAnal.visible := True;
  MBModevisu.visible := not OrigineEXCEL;
  MBSGED.visible := False;
  MBSoldeTousReliquat.visible := False;
  BImprimer.visible := True;
  if TOBPiece.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatProposition then
    Bchercher.Hint := TraduireMemoire('Recherche et affectation globale');
  BVentil.Visible := False;
  {$ELSE}
  MBAnal.visible := False;
  MBModevisu.visible := False;
  // DEBUT MODIF CHR
  {$IFDEF CHR}
  BImprimer.visible := True;
  {$ELSE}
  BImprimer.visible := (Action = TaConsult);
  {$ENDIF}
  // FIN MODIF CHR
  BprixMarche.Visible := (VH_GC.BTPrixMarche) or (SaisieTypeAvanc);
  BArborescence.Visible := VH_GC.BTGestParag;
  {$ENDIF}
  {$IFDEF BTP}
  Typefac := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (Typefac = 'AVA')) or
    ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC') and (Typefac = 'DAC')) then
  begin
    BprixMarche.Visible := False;
  end;
  //
  SimulationdeRentabilit1.visible := true;
  //SimulationdeRentabilit1.Enabled := not (Action=taConsult);
  FraisDetail.visible := true;
  FraisDetail.enabled := not (Action = taConsult);
  N8.visible := true;
  {$ENDIF}
  if SaisieTypeAvanc then
  begin
    BMenuZoom.visible := false;
    BInfos.visible := False;
    BEche.visible := False;
    BVentil.visible := False;
    BActionsLignes.visible := False;
    BSousTotal.visible := False;
    BImprimer.visible := False;
    Bdelete.visible := false;
    BPrixMarche.hint := traduireMemoire('Saisie avancements');
  end;
  BretenuGar.Enabled := (GestionRetenue) and (not RGMultiple(TOBPIECERG));
  BRetenuGar.visible := (GestionRetenue) and (not RGMultiple(TOBPIECERG));
  // ------
  GereTiersEnabled;
  GereCommercialEnabled;
  GereAffaireEnabled;
  if ((CompAnalP = '') or (CompAnalP = 'SAN')) then
  begin
    VPiece.Visible := False;
    VPiece.Enabled := False;
  end;
  if ((CompAnalL = '') or (CompAnalL = 'SAN')) then
  begin
    VLigne.Visible := False;
    VLigne.Enabled := False;
  end;
  if ((CompStockP = '') or (CompStockP = 'SAN')) then
  begin
    SPiece.Visible := False;
    SPiece.Enabled := False;
  end;
  if ((CompStockL = '') or (CompStockL = 'SAN')) then
  begin
    SLigne.Visible := False;
    SLigne.Enabled := False;
  end;
  // DEBUT MODIF CHR
  //BVentil.Enabled:=False ; BEche.Enabled:=False ; BInfos.Enabled:=False ; BPorcs.Enabled:=False ;
  BVentil.Enabled := False;
  BPorcs.Enabled := False;
  {$IFNDEF CHR}
  BEche.Enabled := False;
  BInfos.Enabled := False;
  {$ENDIF}
  // FIN MODIF

  if Action = taConsult then
  begin
    BActionsLignes.Visible := False;
    BSousTotal.Visible := False;
  end else
  begin
    BActionsLignes.Enabled := False;
    BSousTotal.Enabled := False;
  end;
end;

procedure TFFacture.FlagRepres;
begin
  if VenteAchat = 'VEN' then Exit;
  GP_REPRESENTANT.Visible := False;
  GP_REPRESENTANT.TabStop := False;
  HGP_REPRESENTANT.Visible := False;
end;

procedure TFFacture.FlagDomaine;
begin
  if GP_DOMAINE.Values.Count > 1 then
  begin
    GP_DOMAINE.Visible := True;
    HGP_DOMAINE.Visible := True;
  end;
  if Action = taCreat then PositionneDomaineUser(GP_DOMAINE);
end;

{$IFNDEF CEGID}

procedure TFFacture.ModifPrixAchat(ARow: integer);
var TOBL, TOBLig: TOB;
  Q: TQuery;
  StF: string;
  ActionFich: TActionFiche;
begin
  if VenteAchat <> 'VEN' then exit;
  //ActionFich:=Action ;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_ARTICLE') = '' then Exit;
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True);
  if not Q.EOF then StF := Q.Fields[0].AsString else StF := '';
  Ferme(Q);
  if Pos('//MPA', StF) > 0 then ActionFich := Action
  else if Pos('//CPA', StF) > 0 then ActionFich := taConsult
  else exit;
  TOBLig := TOB.Create('LIGNE', nil, -1);
  TOBLig.Dupliquer(TOBL, True, True);
  if EntreeModifPrixAchat(ActionFich, TOBL) then
  begin
    TOBLig.PutValue('GL_QTEFACT', TOBLig.Getvalue('GL_QTEFACT') * (-1));
    SommationAchatDoc(TOBPiece, TOBLig);
    SommationAchatDoc(TOBPiece, TOBL);
    ShowDetail(ARow);
  end;
  TOBLig.Free;
end;
{$ENDIF}

{$IFDEF CEGID}

procedure TFFacture.CegidModifPCI(ARow: integer);
var TOBL: TOB;
  Q: TQuery;
  StF: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_ARTICLE') = '' then Exit;
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True);
  if not Q.EOF then StF := Q.Fields[0].AsString else StF := '';
  Ferme(Q);
  if Pos('//PCI', StF) <= 0 then Exit;
  ModifCegidPCI(Action, TOBL);
end;

procedure TFFacture.CEGIDLibreTiersCom;
var Q: TQuery;
  StF: string;
begin
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True);
  if not Q.EOF then StF := Q.Fields[0].AsString else StF := '';
  Ferme(Q);
  if Pos('//TLC', StF) <= 0 then Exit;
  ModifCegidLibreTiersCom(Action, TobPiece);
  GP_REPRESENTANT.Text := TOBPiece.getvalue('GP_REPRESENTANT');
end;
{$ENDIF} // CEGID

procedure TFFacture.FlagDepot;
begin
  if (ctxMode in V_PGI.PGIContexte) then
  begin
    GP_ETABLISSEMENT.Plus := 'ET_SURSITE="X"';
    GP_DEPOT.Plus := 'GDE_SURSITE="X"';
  end;
  if VH_GC.GCMultiDepots then Exit;
  GP_DEPOT.Visible := False;
  GP_DEPOT.TabStop := False;
  HGP_DEPOT.Visible := False;
end;

procedure TFFacture.FlagContreM;
begin
  if not GereContreM and (SG_ContreM <> -1) then
  begin
    // ...A VOIR...
    //     GS.DeleteCol(SG_ContreM);
    //     EtudieColsGrid(GS);
  end;
end;

procedure TFFacture.FlagEEXandSEX;
begin
  if not ((CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX')) then exit;
  TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece);
  HGP_TIERS.Visible := False;
  GP_TIERS.Visible := False;
  LIBELLETIERS.Visible := False;
  BDevise.Visible := False;
  LDevise.Visible := False;
  EUROPIVOT.Visible := False;
  GP_DEVISE.Visible := False;
  GP_DEVISE__.Visible := False;
  HGP_REFINTERNE.Visible := False;
  GP_REFINTERNE.Visible := False;
  HGP_DATELIVRAISON.Visible := False;
  GP_DATELIVRAISON.Visible := False;
  ControlsVisible(PPied, False, ['INFOSLIGNE']);
  BMenuZoom.Visible := False;
  BAcompte.Visible := False;
  BPorcs.Visible := False;
  BNouvelArticle.Visible := False;
  ISigneEuro.Visible := False;
  if Action <> taConsult then
  begin
    MOTIFMVT.Visible := True;
    HMOTIFMVT.Visible := True;
  end;
end;

procedure TFFacture.ErgoGCS3;
begin
  {$IFDEF CCS3}
  GP_DOMAINE.Visible := False;
  HGP_DOMAINE.Visible := False;
  {$ENDIF}
end;

procedure TFFacture.PositionneEuroGescom;
var LeModeOppose: boolean;
begin
  if Action = taConsult then Exit;
  if not ForceEuroGC then Exit;
  LeModeOppose := (TOBPiece.GetValue('GP_SAISIECONTRE') = 'X');
  if not LeModeOppose then Exit;
  if TOBPiece.GetValue('GP_DEVISE') <> V_PGI.DevisePivot then Exit;
  GP_SAISIECONTRE.Checked := False;
  ForcePieceEuro(TOBPiece, TOBBases, TOBEches, TOBPorcs, TOBNomenclature, TOBAcomptes, TOBOuvrage, TOBPIeceRG, TOBBasesRG);
end;

procedure TFFacture.FormShow(Sender: TObject);
begin
  if not BeforeShow(Self) then Exit;
  if (ctxMode in V_PGI.PGIContexte) then ModifiableLeMemeJour();
  GeneCharge := True;
  PasToucheDepot := False;
  AutoCodeAff := True;
  ChangeComplEntete := False;
  LookLesDocks(Self);
  // modif 02/08/2001
  ChargeFromNature; //EtudieColsListe ;
  FlagRepres;
  FlagDepot;
  FlagContreM;
  FlagDomaine;
  // Modif BTP
  DefinitionGrille;
  // --------------
  case Action of
    taCreat:
      begin
        InitEnteteDefaut(True);
        InitPieceCreation;
        {$IFDEF AFFAIRE}
        EtudieActivite(NewNature, Action, GereActivite, DelActivite);
        {$ENDIF}
      end;
    taModif:
      begin
        ChargeLaPiece;
        GereVivante;
        EtudieReliquat;
        {$IFDEF AFFAIRE}
        EtudieActivite(NewNature, Action, GereActivite, DelActivite);
        {$ENDIF}
        AppliqueTransfoDuplic;
        BloquePiece(Action, True);
        if ((not TransfoPiece) and (not DuplicPiece) and (CleDoc.Indice > 0)) then GP_DATEPIECE.Enabled := False;
        //mcd 08/02/02 interdit delete sur FPR et APR  si affaire(passer par la ligne du menu qui fait des traitements
        if (ctxscot in V_PGI.PGIContexte) or (ctxaffaire in V_PGI.PGIContexte) or (VH_GC.GASeria) then
        begin
          if (CleDoc.NaturePiece = 'FPR') or (Cledoc.Naturepiece = 'APR') then BDelete.Visible := false;
        end;
        //InitSaisieAveugle;
      end;
    taConsult:
      begin
        ChargeLaPiece;
        BloquePiece(Action, True);
        BImprimer.Visible := True;
      end;
  end;
  InitSaisieAveugle; //Saisie Code Barres
  {$IFDEF CEGID}
  if ((Action <> taConsult) and (not V_PGI.Superviseur) and (not DuplicPiece)) then GP_DATEPIECE.Enabled := False;
  {$ENDIF}
  FlagEEXandSEX;
  HMTrad.ResizeGridColumns(GS);
  AffecteGrid(GS, Action);
  if Action = taConsult then GS.MultiSelect := False;
  InitPasModif;
  EnabledPied;
  GereEnabled(1);
  GeneCharge := False;
  AfterShow(Self);
  TraiteTiersParam;
  ErgoGCS3;
  if NewNature = 'FFO' then BNouvelArticle.Visible := False;
  // Modif BTP
  PersonnalisationBtp;
  if (Action = taModif) or (action = taConsult) then GSENter(Self);
  // ---
end;

procedure TFFacture.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var OkG, Vide: Boolean;
begin
  OkG := (Screen.ActiveControl = GS);
  Vide := (Shift = []);
  case Key of
    VK_RETURN: if ((OkG) and (Vide)) then
      begin
        if (ctxMode in V_PGI.PGIContexte) then SendMessage(GS.Handle, WM_KeyDown, VK_DOWN, 0) else Key := VK_TAB;
      end;
    VK_F5: if ((OkG) and (Vide)) then
      begin
        Key := 0;
        ZoomOuChoixArt(GS.Col, GS.Row);
      end;
    VK_INSERT: if ((OkG) and (Vide)) then
      begin
        Key := 0;
        ClickInsert(GS.Row);
      end;
    VK_DELETE: if ((OkG) and (Shift = [ssCtrl])) then
      begin
        Key := 0;
        TSupLigneClick(nil);
      end;
    {$IFDEF CEGID}
    VK_F9: if Shift = [ssShift] then
      begin
        Key := 0;
        CEGIDModifPCI(GS.Row);
      end;
    VK_F11: if Shift = [ssShift] then
      begin
        Key := 0;
        CEGIDLibreTiersCom;
      end;
    {Ctrl+L} 76: if Shift = [ssCtrl] then
      begin
        Key := 0;
        CpltLigneClick(nil);
      end;
    {$ELSE}
    VK_F9: if Shift = [ssShift] then
      begin
        Key := 0;
        ModifPrixAchat(GS.Row);
      end;
    {$ENDIF}
    VK_F10: if Vide then
      begin
        Key := 0;
        ClickValide;
      end;
    VK_HOME: if Shift = [ssCtrl] then
      begin
        Key := 0;
        GotoEntete;
      end;
    VK_END: if Shift = [ssCtrl] then
      begin
        Key := 0;
        GotoPied;
      end;
    {Ctrl+D} 68: if Shift = [ssCtrl] then
      begin
        Key := 0;
        AppelleDim(GS.Row);
      end;
    {Alt+E} 69: if Shift = [ssAlt] then
      begin
        Key := 0;
        BEcheClick(nil);
      end;
    {Ctrl+R} 82: if Shift = [ssCtrl] then
      begin
        Key := 0;
        ChangeRegime;
      end;
    {Ctrl+T} 84: if Shift = [ssCtrl] then
      begin
        Key := 0;
        ChangeTva;
      end;
  end;
end;

procedure TFFacture.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Action = taConsult then Exit;
  if SaisieTypeAffaire then Exit;
  if ValideEnCours then
  begin
    CanClose := False;
    Exit;
  end;
  if ((not ForcerFerme) and (PieceModifiee) and (DejaRentre)) then
  begin
    if HPiece.Execute(6, Caption, '') <> mrYes then CanClose := False else DetruitNewAcc;
  end;
end;

procedure TFFacture.ToutAllouer;
begin
  GS.RowCount := NbRowsInit;
  StCellCur := '';
  // Pièce
  TOBPiece := TOB.Create('PIECE', nil, -1);
  TOBPiece_O := TOB.Create('', nil, -1);
  // Modif BTP
  AddLesSupEntete(TOBPiece);
  AddLesSupEntete(TOBPiece_O);
  // ---
  TOBBases := TOB.Create('BASES', nil, -1);
  TOBBases_O := TOB.Create('', nil, -1);
  TOBEches := TOB.Create('Les ECHEANCES', nil, -1);
  TOBEches_O := TOB.Create('', nil, -1);
  TOBPorcs := TOB.Create('PORCS', nil, -1);
  TOBPorcs_O := TOB.Create('', nil, -1);
  // Fiches
  TOBTiers := TOB.Create('TIERS', nil, -1);
  TOBTiers.AddChampSup('RIB', False);
  TOBArticles := TOB.Create('ARTICLES', nil, -1);
  TOBConds := TOB.Create('CONDS', nil, -1);
  TOBTarif := TOB.Create('TARIF', nil, -1);
  TOBComms := TOB.Create('COMMERCIAUX', nil, -1);
  TOBCatalogu := TOB.Create('LECATALOGUE', nil, -1);
  // Adresses
  TOBAdresses := TOB.Create('LESADRESSES', nil, -1);
  TOBAdresses_O := TOB.Create('', nil, -1);
  if GetParamSoc('SO_GCPIECEADRESSE') then
  begin
    TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Livraison}
    TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
  end else
  begin
    TOB.Create('ADRESSES', TOBAdresses, -1); {Livraison}
    TOB.Create('ADRESSES', TOBAdresses, -1); {Facturation}
  end;
  // Divers
  TOBCXV := TOB.Create('', nil, -1);
  TOBNomenclature := TOB.Create('NOMENCLATURES', nil, -1);
  TOBN_O := TOB.Create('', nil, -1);
  TOBDim := TOB.Create('', nil, -1);
  TOBDesLots := TOB.Create('', nil, -1);
  TOBLOT_O := TOB.Create('', nil, -1);
  TOBSerie := TOB.Create('', nil, -1);
  TOBSerie_O := TOB.Create('', nil, -1);
  TOBSerRel := TOB.Create('', nil, -1);
  TOBAcomptes := TOB.Create('', nil, -1);
  TOBAcomptes_O := TOB.Create('', nil, -1);
  TOBDispoContreM := TOB.Create('', nil, -1);
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  TOBHRDossier := TOB.Create('HRDOSSIER', nil, -1);
  TOBHrDossier.AddChampSup('HDR_HRDOSSIER', False);
  TOBHrDossier.AddChampSup('HDR_DOSRES', False);
  TOBHrDossier.AddChampSup('HDR_DATEARRIVEE', False);
  TOBHrDossier.AddChampSup('HDR_DATEDEPART', False);
  TOBHrDossier.AddChampSup('HDR_TIERS', False);
  TOBHrDossier.AddChampSup('HDR_NBPERSONNE1', False);
  TOBHrDossier.AddChampSup('HDR_RESSOURCE', False);
  {$ENDIF}
  // FIN AJOUT CHR
  // Affaires
  TOBAffaire := TOB.Create('AFFAIRE', nil, -1);
  // Comptabilité
  TOBCPTA := CreerTOBCpta;
  TOBANAP := TOB.Create('', nil, -1);
  TOBANAS := TOB.Create('', nil, -1);
  //Saisie Code Barres
  TOBGSA := TOB.Create('', nil, -1);
  // MODIF BTP
  // Ouvrages
  TOBOuvrage := TOB.Create('OUVRAGES', nil, -1);
  TOBOuvrage_O := TOB.Create('', nil, -1);
  // textes debut et fin
  TOBLIENOLE := TOB.Create('LIENS', nil, -1);
  TOBLIENOLE_O := TOB.Create('', nil, -1);
  // retenues de garantie
  TOBPieceRG := TOB.create('PIECERRET', nil, -1);
  TOBPieceRG_O := TOB.create('', nil, -1);
  // Bases de tva sur RG
  TOBBasesRG := TOB.create('BASESRG', nil, -1);
  TOBBASESRG_O := TOB.create('', nil, -1);
  // --
  TOBLIGNERG := nil;
end;

procedure TFFacture.ToutLiberer;
begin
  GS.VidePile(False);
  PurgePop(POPZ);
  TOBPiece.Free;
  TOBPiece := nil;
  TOBPiece_O.Free;
  TOBPiece_O := nil;
  TOBTiers.Free;
  TOBTiers := nil;
  TOBArticles.Free;
  TOBArticles := nil;
  TOBCatalogu.Free;
  TOBCatalogu := nil;
  TOBConds.Free;
  TOBConds := nil;
  TOBComms.Free;
  TOBComms := nil;
  TOBEches.Free;
  TOBEches := nil;
  TOBEches_O.Free;
  TOBEches_O := nil;
  TOBBases.Free;
  TOBBases := nil;
  TOBBases_O.Free;
  TOBBases_O := nil;
  TOBPorcs.Free;
  TOBPorcs := nil;
  TOBPorcs_O.Free;
  TOBPorcs_O := nil;
  TOBTarif.Free;
  TOBTarif := nil;
  TOBAdresses.Free;
  TOBAdresses := nil;
  TOBAdresses_O.Free;
  TOBAdresses_O := nil;
  TOBCXV.Free;
  TOBCXV := nil;
  TOBAffaire.Free;
  TOBAffaire := nil;
  TOBDim.Free;
  TOBDim := nil;
  TOBCpta.Free;
  TOBCpta := nil;
  TOBAnaP.Free;
  TOBAnaP := nil;
  TOBAnaS.Free;
  TOBAnaS := nil;
  TOBDesLots.Free;
  TOBDesLots := nil;
  TOBLOT_O.Free;
  TOBLOT_O := nil;
  TOBSerie.Free;
  TOBSerie := nil;
  TOBSerie_O.Free;
  TOBSerie_O := nil;
  TOBSerRel.Free;
  TOBSerRel := nil;
  TOBNomenclature.Free;
  TOBNomenclature := nil;
  TOBN_O.Free;
  TOBN_O := nil;
  TOBAcomptes.Free;
  TOBAcomptes := nil;
  TOBAcomptes_O.Free;
  TOBAcomptes_O := nil;
  TOBDispoContreM.Free;
  TOBDispoContreM := nil;
  TOBGSA.free;
  TOBGSA := nil;
  // MOdif BTP
  TOBOuvrage.free;
  TOBOuvrage := nil;
  TOBOuvrage_O.free;
  TOBOuvrage_O := nil;
  TOBLIENOLE.free;
  TOBLIENOLE_O.free;
  TOBLIENOLE := nil;
  TOBLIENOLE := nil;
  TOBPIECERG.free;
  TOBPIECERG_O.free;
  TOBBASESRG.free;
  TOBBASESRG_O.free;
  // Modif BTP
  if TOBLigneRG <> nil then
  begin
    TOBLigneRG.free;
    TOBLigneRG := nil;
  end;
  // --
  // ---------
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  TOBHrdossier.Free;
  TOBHrdossier := nil;
  Tobregrpe.free;
  Tobregrpe := nil;
  {$ENDIF}
  // FIN AJOUT CHR
end;

procedure TFFacture.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PPInfosLigne.Clear;
  PPInfosLigne.Free;
  PPInfosLigne := nil;
  ToutLiberer;
  if IsInside(Self) then Action := caFree;
  FClosing := TRUE;
end;

{==============================================================================================}
{=============================== Actions liées au Grid ========================================}
{==============================================================================================}

procedure TFFacture.SauveColList;
begin
  RCol.SG_NL := SG_NL;
  RCol.SG_RefArt := SG_RefArt;
  RCol.SG_Lib := SG_Lib;
  RCol.SG_QF := SG_QF;
  RCol.SG_QS := SG_QS;
  RCol.SG_Px := SG_Px;
  RCol.SG_Rem := SG_Rem;
  RCol.SG_Aff := SG_Aff;
  RCol.SG_Rep := SG_Rep;
  RCol.SG_Dep := SG_Dep;
  RCol.SG_RV := SG_RV;
  RCol.SG_RL := SG_RL;
  RCol.SG_ContreM := SG_ContreM;
  RCol.SG_Montant := SG_Montant;
  RCol.SG_DateLiv := SG_DateLiv;
  RCol.SG_Total := SG_Total;
  RCol.SG_QR := SG_QR;
  RCol.SG_Motif := SG_Motif;
  RCol.SG_QReste := SG_QReste; { NEWPIECE }
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  RCol.SG_Folio := SG_Folio;
  RCol.SG_DateProd := SG_DateProd;
  RCol.SG_Regrpe := SG_Regrpe;
  RCol.SG_LibRegrpe := SG_LibRegrpe;
  {$ENDIF}
  // FIN AJOUT CHR
end;

procedure TFFacture.RestoreColList;
begin
  SG_NL := RCol.SG_NL;
  SG_RefArt := RCol.SG_RefArt;
  SG_Lib := RCol.SG_Lib;
  SG_QF := RCol.SG_QF;
  SG_QS := RCol.SG_QS;
  SG_Px := RCol.SG_Px;
  SG_Rem := RCol.SG_Rem;
  SG_Aff := RCol.SG_Aff;
  SG_Rep := RCol.SG_Rep;
  SG_Dep := RCol.SG_Dep;
  SG_RV := RCol.SG_RV;
  SG_RL := RCol.SG_RL;
  SG_ContreM := RCol.SG_ContreM;
  SG_Montant := RCol.SG_Montant;
  SG_DateLiv := RCol.SG_DateLiv;
  SG_Total := RCol.SG_Total;
  SG_QR := RCol.SG_QR;
  SG_Motif := RCol.SG_Motif;
  SG_QReste := RCol.SG_QReste; { NEWPIECE }
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  SG_Folio := RCol.SG_Folio;
  SG_DateProd := RCol.SG_DateProd;
  SG_Regrpe := RCol.SG_Regrpe;
  SG_LibRegrpe := RCol.SG_LibRegrpe;
  {$ENDIF}
  // FIN AJOUT CHR
end;

procedure TFFacture.EtudieColsListe;
var i: integer;
  Nam, St, StFind, FF: string;
  ColAligns: array[0..200] of TAlignment;
  {$IFDEF BTP}
  TypeFac: string;
  {$ENDIF}
begin
  LesColonnes := GS.Titres[0];
  if not GP_FACTUREHT.Checked then
  begin
    LesColonnes := FindEtReplace(LesColonnes, 'GL_PUHTDEV', 'GL_PUTTCDEV', False);
    LesColonnes := FindEtReplace(LesColonnes, 'GL_TOTALHTDEV', 'GL_TOTALTTCDEV', False);
    LesColonnes := FindEtReplace(LesColonnes, 'GL_MONTANTHTDEV', 'GL_MONTANTTTCDEV', False);
    // ajout 02/08/2001
    LesColonnes := FindEtReplace(LesColonnes, 'GL_PUHTNETDEV', 'GL_PUTTCNETDEV', False);
  end;
  if GereContreM then
  begin
    for i := 0 to GS.ColCount - 1 do
    begin
      ColAligns[i] := GS.FColAligns[i];
    end;
    St := LesColonnes;
    StFind := 'GL_ENCONTREMARQUE';
    i := Pos(StFind, St);
    if i = 0 then
    begin
      Nam := ReadTokenSt(St);
      LesColonnes := Nam + ';' + StFind + ';' + St;
      //GS.ColCount:=GS.ColCount+1;
      GS.Titres[0] := LesColonnes;
      SG_ContreM := 1;
      for i := 1 to GS.ColCount - 1 do GS.Titres.Add('');
      if Action <> taConsult then
      begin // Modif pour tenir compte de la gestion de FColEditables de l'AGL 540
        if not (goEditing in GS.Options) then GS.Options := GS.Options + [GoEditing];
      end;
      GS.InsertCol(SG_ContreM);
      for i := GS.ColCount - 1 downto 1 do GS.Titres.Delete(i);
      for i := 0 to SG_ContreM - 1 do GS.FColAligns[i] := ColAligns[i];
      GS.FColAligns[SG_ContreM] := TaCenter;
      for i := SG_ContreM + 1 to GS.ColCount - 1 do GS.FColAligns[i] := ColAligns[i - 1];
    end;
  end;
  EtudieColsGrid(GS);
  St := LesColonnes;
  if GereContreM then
  begin
    GS.Cells[SG_ContreM, 0] := 'Cqe';
    GS.ColWidths[SG_ContreM] := GS.ColWidths[SG_NL];
    GS.ColFormats[SG_ContreM] := '-1';
  end;
  if SG_RefArt > 0 then GS.ColLengths[SG_RefArt] := 18;
  if SG_lib > 0 then GS.ColLengths[SG_Lib] := 70;
  if (GetInfoParPiece(NewNature, 'GPP_GESTIONGRATUIT') = 'X') and not (ctxMode in V_PGI.PGIContexte) then
  begin
    if SG_px > 0 then GS.ColLengths[SG_px] := -1;
    if SG_pxNet > 0 then GS.ColLengths[SG_pxNet] := -1; // Modif MODE 31/07/2002
    if SG_rem > 0 then GS.ColLengths[SG_rem] := -1;
  end;
  FF := '#';
  if V_PGI.OkDecQ > 0 then
  begin
    FF := '#.';
    for i := 1 to V_PGI.OkDecQ - 1 do
    begin
      FF := FF + '#';
    end;
    FF := FF + '0';
  end;
  for i := 0 to GS.ColCount - 1 do
  begin
    Nam := ReadTokenSt(St);
    IdentCols[i].ColName := Nam;
    IdentCols[i].ColTyp := ChampToType(Nam);
    if IdentCols[i].ColTyp = 'DATE' then
    begin
      GS.ColTypes[i] := 'D';
      GS.ColFormats[i] := ShortdateFormat;
    end;
    if Nam = 'GL_TYPEREMISE' then GS.ColFormats[i] := 'CB=GCTYPEREMISE';
    if Nam = 'GL_TOTALHTDEV' then TotEnListe := True;
    if (Nam = 'GL_QTESTOCK') or (Nam = 'GL_QTEFACT') then GS.ColFormats[i] := FF; { NEWPIECE }
    if Nam = 'GL_QTERESTE' then
    begin
      GS.ColEditables[i] := False;
      GS.ColFormats[i] := FF; { NEWPIECE }
    end;
    if Nam = 'GL_MOTIFMVT' then GS.ColFormats[i] := 'CB=GCMOTIFMOUVEMENT';
  end;

  if (SG_TYPA <> -1) and (Action <> Taconsult) then GS.ColLengths[SG_TYPA] := -1;

  if SaisieTypeAvanc = True then
  begin
    if Sg_RefArt <> -1 then GS.ColLengths[SG_RefArt] := -1;
    if SG_QF <> -1 then
    begin
      GS.ColLengths[SG_QF] := -1;
      GS.ColLengths[SG_QF + 1] := -1;
    end;
    if SG_PCT <> -1 then GS.ColLengths[SG_Pct + 1] := -1;
  end
  else
  begin
    if SG_Unit <> -1 then GS.ColLengths[SG_Unit] := -1;
    {$IFDEF BTP}
    TypeFac := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
    if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (TypeFac = 'AVA')) or
      ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC') and (TypeFac = 'DAC')) then
    begin
      // pas d'accès à la référence ni aux prix en modification de situation
      if SG_RefArt <> -1 then GS.ColLengths[SG_RefArt] := -1;
      if SG_Px <> -1 then GS.ColLengths[SG_Px] := -1;
      if SG_Montant <> -1 then GS.ColLengths[SG_Montant] := -1;
    end;
    if OrigineEXCEL then
    begin
      // pas d'accès à la référence ni aux prix en Etude d'origine EXCEL
      if SG_RefArt <> -1 then GS.ColLengths[SG_RefArt] := -1;
    end;
    {$ENDIF}
  end;
  // ----
end;

function TFFacture.ZoneAccessible(ACol, ARow: Longint): boolean; { NEWPIECE }
var TOBA, TOBL: TOB;
  CodeA, TypeDim, PiecePrec, TypeL: string;
  IndiceLot, IndiceSerie: integer;
  RemA, ligSup: boolean;
begin
  Result := True;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if ACol = SG_QReste then { NEWPIECE }
  begin
    Result := False;
    EXIT;
  end;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA <> nil then CodeA := TOBA.GetValue('GA_ARTICLE') else CodeA := '';
  if (CodeA = '') and (TOBL.GetValue('GL_TYPEREF') = 'CAT') then CodeA := TOBL.GetValue('GL_REFCATALOGUE');
  {$IFDEF CCS3}
  IndiceLot := 0;
  IndiceSerie := 0;
  {$ELSE}
  IndiceLot := TOBL.GetValue('GL_INDICELOT');
  IndiceSerie := TOBL.GetValue('GL_INDICESERIE');
  {$ENDIF}
  TypeDim := TOBL.GetValue('GL_TYPEDIM');
  PiecePrec := TOBL.GetValue('GL_PIECEPRECEDENTE');
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  if (SG_Montant > 0) and (Acol = SG_Montant) then
  begin
    result := False;
    exit;
  end;
  if (SG_LibRegrpe > 0) and (Acol = SG_LibRegrpe) then
  begin
    result := False;
    exit;
  end;
  if SG_DateProd > 0 then
  begin
    if (TOBL.GetValue('GL_DATEPRODUCTION') <> iDate1900) and
      (TOBL.GetValue('GL_DATEPRODUCTION') < V_PGI.DateEntree) then
    begin
      // les prix quantités dates ne sont pas modifiable
      if (Acol = SG_RefArt) or (Acol = SG_Qf) or (Acol = SG_Px) or (Acol = SG_DateProd) then
      begin
        result := False;
        exit;
      end;
    end;
  end;
  {$ENDIF}
  // FIN AJOUT CHR
  if TOBL.FieldExists('SUPPRIME') then LigSup := (TOBL.GetValue('SUPPRIME') = 'X') else LigSup := False;

  if GS.ColLengths[ACol] < 0 then
  begin
    Result := False;
    Exit;
  end;

  if IsLigneDetail(nil, TOBL) then
  begin
    result := False;
    exit;
  end;

  // Modif BTP
  if ACol = SG_RefArt then
  begin
    TypeL := Copy(GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow), 1, 2);
    if (TypeL = 'DP') or (TypeL = 'TP') then
    begin
      Result := False;
      exit;
    end;
  end;
  if (TOBL.getValue('GL_TYPEARTICLE') = 'POU') and (Acol = SG_Px) then
  begin
    result := false;
    exit;
  end;
  if (SaisieTypeAvanc = True) and (TOBL.getValue('GL_TYPEARTICLE') = 'POU') then
  begin
    result := false;
    exit;
  end;
  // ---

  if not (ctxMode in V_PGI.PGIContexte) then
  begin
    if TypeDim = 'GEN' then
    begin
      if DimSaisie = 'DIM' then Result := False else
      begin
        Result := (ACol = SG_Lib);
        if not Result then ACol := SG_Lib;
      end;
      Exit;
    end;
  end;

  if TypeDim = 'DIM' then
  begin
    if DimSaisie = 'GEN' then
    begin
      Result := False;
      Exit;
    end;
  end;

  if ((GereLot) and (IndiceLot > 0) and (ACol = SG_Dep)) then
  begin
    Result := False;
    Exit;
  end;
  if ((GereSerie) and (IndiceSerie > 0) and (ACol = SG_Dep)) then
  begin
    Result := False;
    Exit;
  end;
  if ((PasToucheDepot) and (ACol = SG_Dep)) then
  begin
    Result := False;
    Exit;
  end;
  if (ACol = SG_ContreM) and (GS.Cells[ACol, ARow] = 'X') then
  begin
    Result := False;
    Exit;
  end;

  if CodeA = '' then
  begin
    // DEBUT MODIF CHR
    // Result:=((ACol=SG_ContreM) or (ACol=SG_RefArt) or (ACol=SG_Lib) or (ACol=SG_DateLiv) or ((ACol=SG_Motif) and (TypeDim='GEN'))) ; if Not Result then ACol:=GS.FixedCols ;
    Result := ((ACol = SG_ContreM) or (ACol = SG_RefArt) or (ACol = SG_Lib) or (ACol = SG_DateLiv) or (ACol = Sg_Folio) or ((ACol = SG_Motif) and (TypeDim =
      'GEN')));
    //if Not Result then ACol:=GS.FixedCols ;
 // DEBUT MODIF CHR
  end else
  begin
    // Remises
    RemA := True;
    if (TOBA <> nil) then RemA := (TOBA.GetValue('GA_REMISELIGNE') = 'X');
    if not RemA then
    begin
      if ACol = SG_Rem then Result := False;
      if ((IdentCols[ACol].ColName = 'GL_TOTREMLIGNEDEV') or (IdentCols[ACol].ColName = 'GL_MONTANTHTDEV') or
        (IdentCols[ACol].ColName = 'GL_MONTANTTTCDEV')) then Result := False;
      if IdentCols[ACol].ColName = 'GL_TYPEREMISE' then if TOBL.GetValue('GL_TOTREMLIGNEDEV') = 0 then Result := False;
      if not Result then Exit;
    end;

    // On ne peut pas changer la quantité sur une ligne supprimée
    if ((LigSup) and ((ACol = SG_QF) or (ACol = SG_QS))) then
    begin
      Result := False;
      Exit;
    end;

  end;
end;

procedure TFFacture.ZoneSuivanteOuOk(var ACol, ARow: Longint; var Cancel: boolean);
var Sens, ii, Lim: integer;
  OldEna, ChgLig, ChgSens: boolean;
begin
  OldEna := GS.SynEnabled;
  GS.SynEnabled := False;
  Sens := -1;
  ChgLig := (GS.Row <> ARow);
  ChgSens := False;
  if GS.Row > ARow then Sens := 1 else if ((GS.Row = ARow) and (ACol <= GS.Col)) then Sens := 1;
  ACol := GS.Col;
  ARow := GS.Row;
  ii := 0;
  while not ZoneAccessible(ACol, ARow) do
  begin
    Cancel := True;
    inc(ii);
    if ii > 500 then Break;
    if Sens = 1 then
    begin
      // Modif BTP
      if (tModeBlocNotes in SaContexte) or (saisietypeavanc) then Lim := TOBPiece.Detail.Count else Lim := GS.RowCount - 1;
      // ---
      if ((ACol = GS.ColCount - 1) and (ARow >= Lim)) then
      begin
        {$IFDEF BTP}
        if ChgSens then Break else
        begin
          inc(Arow);
          Acol := GS.FixedCols;
          InsertTOBLigne(TOBPiece, Arow);
          InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
          NumeroteLignesGC(GS, TOBPiece);
          if (tModeBlocNotes in SaContexte) then
          begin
            GS.RowCount := TOBPiece.Detail.Count + 2;
            if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
            GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
          end else
          begin
            GS.RowCount := TOBPiece.Detail.Count + 1;
          end;
          break;
        end;
        {$ELSE}
        if ChgSens then Break else
        begin
          Sens := -1;
          Continue;
          ChgSens := True;
        end;
        {$ENDIF}
      end;
      if ChgLig then
      begin
        ACol := GS.FixedCols - 1;
        ChgLig := False;
      end;
      if ACol < GS.ColCount - 1 then Inc(ACol) else
      begin
        Inc(ARow);
        ACol := GS.FixedCols;
      end;
    end else
    begin
      if ((ACol = GS.FixedCols) and (ARow = 1)) then
      begin
        if ChgSens then Break else
        begin
          Sens := 1;
          Continue;
        end;
      end;
      if ChgLig then
      begin
        ACol := GS.ColCount;
        ChgLig := False;
      end;
      if ACol > GS.FixedCols then Dec(ACol) else
      begin
        Dec(ARow);
        ACol := GS.ColCount - 1;
      end;
    end;
  end;
  GS.SynEnabled := OldEna;
end;

function TFFacture.FormateZoneDivers(St: string; ACol: Longint): string;
var ColName, Typ, StC: string;
begin
  Result := St;
  StC := St;
  ColName := IdentCols[ACol].ColName;
  if ColName = '' then Exit;
  Typ := IdentCols[ACol].ColTyp;
  if (Typ = 'INTEGER') or (Typ = 'SMALLINT') then StC := InttoStr(ValeurI(St)) else
    if (Typ = 'DOUBLE') or (Typ = 'RATE') then StC := StrF00(Valeur(St), V_PGI.OkDecV) else
    if Typ = 'DATE' then
  begin
    if St <> '' then if not IsValidDate(St) then StC := GP_DATEPIECE.Text;
  end else
    if Typ = 'BOOLEAN' then
  begin
    if Uppercase(St) <> 'X' then St := '-';
    StC := Uppercase(St);
  end else
    if ((Typ = 'COMBO') and (Copy(GS.ColFormats[ACol], 1, 3) <> 'CB=')) then StC := Uppercase(St)
  else StC := St;
  Result := StC;
end;

procedure TFFacture.FormateZoneSaisie(ACol, ARow: Longint);
var St, StC: string;
  {$IFDEF AFFAIRE}
  CodeAffTotal: Boolean;
  {$ENDIF}
begin
  St := GS.Cells[ACol, ARow];
  StC := St;
  if ((ACol = SG_RefArt) or (ACol = SG_Rep) or (ACol = SG_Dep)) then StC := uppercase(Trim(St)) else
    if (ACol = SG_Px) or (ACol = SG_PxNet) then StC := StrF00(Valeur(St), DEV.Decimale) else // Modif MODE 31/07/2002
    if ACol = SG_Rem then StC := StrF00(Valeur(St), ADecimP) else
    if ((ACol = SG_QF) or (ACol = SG_QS) or (ACol = SG_QA)) then //MODIFBTP
  begin
    StC := StrF00(Valeur(St), V_PGI.OkDecQ);
  end else
    if (ACol = SG_Aff) then {Affaire}
  begin
    StC := uppercase(Trim(St));
    {$IFDEF AFFAIRE}
    CodeAffTotal := False;
    if StC <> '' then
    begin
      if Length(StC) > MaxLngAffaireAffiche then CodeAffTotal := True;
      if CodeAffTotal then StC := CodeAffaireAffiche(StC);
    end;
    {$ENDIF}
  end else StC := FormateZoneDivers(St, ACol);
  GS.Cells[ACol, ARow] := StC;
end;

{==============================================================================================}
{=============================== Evènements de le Grid ========================================}
{==============================================================================================}

procedure TFFacture.PostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);

  procedure TireLigne(DebX, DebY, FinX, FinY: integer);
  begin
    GS.Canvas.MoveTo(DebX, DebY);
    GS.Canvas.LineTo(FinX, FinY);
  end;

var ARect: TRect;
  Fix: boolean;
  // modif BTP
  TOBL: TOB;
begin
  if GS.RowHeights[ARow] <= 0 then Exit;
  if ARow > GS.TopRow + GS.VisibleRowCount - 1 then Exit;
  ARect := GS.CellRect(ACol, ARow);
  Fix := ((ACol < GS.FixedCols) or (ARow < GS.FixedRows));
  GS.Canvas.Pen.Style := psSolid;
  GS.Canvas.Pen.Color := clgray;
  GS.Canvas.Brush.Style := BsSolid;
  if ((Acol = SG_TypA) and (Arow >= GS.fixedRows)) then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then Exit;
    Canvas.FillRect(ARect);
    NumGraph := RecupTypeGraph(TOBL);
    if NumGraph >= 0 then
    begin
      ImTypeArticle.DrawingStyle := dsTransparent;
      ImTypeArticle.Draw(CanVas, ARect.left, ARect.top, NumGraph);
    end;
  end;
  if (tModeGridMode in SaContexte) then
  begin
    GS.Canvas.Brush.Style := bsClear;
    TireLigne(ARect.Left, ARect.Bottom - 1, ARect.Right, ARect.Bottom - 1);
    if Fix then
    begin
      GS.Canvas.Brush.Style := bsSolid;
      GS.Canvas.Pen.Color := clBlack;
      TireLigne(ARect.Left, ARect.Bottom - 1, ARect.Right, ARect.Bottom - 1);
      GS.Canvas.Pen.Color := clWhite;
      GS.Canvas.Brush.Style := bsClear;
      if ARow < GS.FixedRows then TireLigne(ARect.Left, ARect.Top, ARect.Right, ARect.Top);
      if ACol < GS.FixedCols then TireLigne(ARect.Left + 1, ARect.Top, ARect.Right, ARect.Top);
    end;
  end;
  if Arow >= GS.fixedRows then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then Exit;
    if TOBL.GetValue('GL_ACTIONLIGNE') = 'SDP' then
    begin
      GS.Canvas.Pen.Color := clRed;
      GS.Canvas.MoveTo(GS.Left, ARect.Top);
      GS.Canvas.LineTo(GS.Left + GS.Width, ARect.Top);
    end;
  end;
end;

procedure TFFacture.GetCellCanvas(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
var TOBL: TOB;
  //ARect : TRect ;
begin
  if not BeforeGetCellCanvas(Self, ACol, ARow, Canvas, AState) then Exit;
  if ACol < GS.FixedCols then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  {Ligne non imprimable}
  if TOBL.GetValue('GL_NONIMPRIMABLE') = 'X' then if ((Action <> taConsult) or (ARow <> GS.Row)) then Canvas.Font.Color := clBlue;
  {Ligne supprimée}
  if TOBL.FieldExists('SUPPRIME') then
    if TOBL.GetValue('SUPPRIME') = 'X' then if ((Action <> taConsult) or (ARow <> GS.Row)) then Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
  {Lignes Multi-Dim}
  if TOBL.GetValue('GL_TYPEDIM') = 'DIM' then AfficheDetailDim(Canvas, DimSaisie, ACol) else
    if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then AfficheGenDim(Canvas, DimSaisie);
  {Lignes de sous-total}
  if TOBL.GetValue('GL_TYPELIGNE') = 'TOT' then Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  {Lignes début de paragraphe}// Modif BTP
  if Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
  begin
    if TOBL.GetValue('GL_NIVEAUIMBRIC') > 1 then Canvas.Font.Style := Canvas.Font.Style + [fsItalic]
    else Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  end;
  {Lignes fin de paragraphe}// Modif BTP
  if Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'TP' then
  begin
    if TOBL.GetValue('GL_NIVEAUIMBRIC') > 1 then Canvas.Font.Style := Canvas.Font.Style + [fsItalic]
    else Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  end;
  {Ligne de commentaire rattachée}// Modif BTP
  if IsLigneDetail(nil, TOBL) then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsbold, fsItalic];
    Canvas.Font.Color := clActiveCaption;
  end;
  {Ligne de retenue de garantie}// Modif BTP
  if (TOBL.GetValue('GL_TYPELIGNE') = 'RG') then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsbold, fsItalic];
    Canvas.Font.Color := clRed;
  end;
  {Reliquats}
  if ((Action <> taCreat) and (GereReliquat)) then
  begin
    if IdentCols[ACol].ColName = 'GL_QTERELIQUAT' then
    begin
      if TOBL.GetValue('GL_SOLDERELIQUAT') = 'X' then Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
    end;
  end;
end;

procedure TFFacture.GSMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GX := X;
  GY := Y;
end;

procedure TFFacture.GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
var TOBL: TOB;
  Arect: Trect;
  Hauteur: integer;
begin
  // Pour éviter de créer des lignes vides
  if action <> taconsult then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      if Ou >= GS.RowCount - 1 then
      begin
        GS.RowCount := GS.RowCount + 1;
        if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
        GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
      end;
      // Positionnement de la barre de scroll
      // on ajoute 1 au n° de ligne pour prendre en compte la ligne de titre
      Hauteur := (GS.RowHeights[GS.Row] * (GS.Row + 1)) + (GS.GridLineWidth * (GS.Row + 3));
      if Debut.height + Hauteur - SB.VertScrollBar.position > SB.height then
        SB.VertScrollBar.position := SB.VertScrollBar.position + (Debut.height + Hauteur - SB.VertScrollBar.position - SB.height)
      else if Debut.height + Hauteur < SB.VertScrollBar.position then
        SB.VertScrollBar.position := SB.VertScrollBar.position - (SB.VertScrollBar.position - (Debut.height + Hauteur) + GS.RowHeights[GS.Row])
    end else
    begin
      if Ou >= GS.RowCount - 1 then GS.RowCount := GS.RowCount + NbRowsPlus;
    end;
  end;
  if Action <> taConsult then
  begin
    CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, Ou);
    {$IFDEF CEGID}
    if not transfopiece then if GetChampLigne(TOBPiece, 'GL_REFCOLIS', Ou) <> '' then
      begin
        Cancel := True;
        Exit;
      end;
    {$ENDIF}
  end;
  GereEnabled(Ou);
  ShowDetail(Ou);
  GereDescriptif(Ou, True);
  // Modif BTP
  TOBL := GetTOBLigne(TOBPiece, Ou); // récupération TOB ligne
  if (SG_TypA <> -1) and (TOBL <> nil) and (Action <> taconsult) then
  begin
    ARect := GS.CellRect(SG_Typa, GS.Row);
    NumGraph := RecupTypeGraph(TOBL);
    BTypeArticle.ImageIndex := NumGraph;
    BTYpeArticle.Opaque := false;
    with BTypeArticle do
    begin
      Top := Arect.top - GS.GridLineWidth;
      Left := Arect.Left;
      Width := Arect.Right - Arect.Left;
      Height := Arect.Bottom - Arect.Top - GS.GridLineWidth;
      Parent := GS;
      Visible := true;
    end;
  end;
end;

procedure TFFacture.GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  // DEBUT AJOUT CHR
  {$IFDEF CHR}
  GereChampsChr(ou, cancel);
  {$ENDIF}
  // FIN AJOUT CHR
  // Modif BTP
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  // --
  DeflagTarif(Ou);
  CommVersLigne(TOBPiece, TOBArticles, TOBComms, Ou, True);
  DepileTOBLignes(GS, TOBPiece, Ou, GS.Row);
  GereDescriptif(Ou, False);
  GereLesLots(Ou);
  GereLesSeries(Ou);
  GereAnal(Ou);
  GereArtsLies(Ou);
  if Action = taCreat then BlocageSaisie(True);
  if TesteMargeMini(Ou) then Cancel := True;
  if AffecteMotif(Ou) then Cancel := True;
end;

procedure TFFacture.GSCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
var TOBL: TOB;
  // Modif BTP
  OuvrageDetail: boolean;
begin
  if Action = taConsult then Exit;
  // Modif BTP
  OuvrageDetail := false;
  // --
  ZoneSuivanteOuOk(ACol, ARow, Cancel);
  if not Cancel then
  begin
    // DEBUT MODIF CHR
    // GS.ElipsisButton:=(GS.Col=SG_RefArt) or (GS.Col=SG_Aff) or (GS.Col=SG_Rep) or (GS.Col=SG_Dep) or (GS.Col=SG_DateLiv) ;
    GS.ElipsisButton := (GS.Col = SG_RefArt) or (GS.Col = SG_Aff) or (GS.Col = SG_Rep) or (GS.Col = SG_Dep) or (GS.Col = SG_DateLiv) or (GS.Col = SG_DateProd)
      or (GS.Col = SG_Regrpe);
    // FIN MODIF CHR
    if ((CommentLigne) and (GS.Col = SG_Lib) and (not SaisieTypeAvanc)) then GS.ElipsisButton := true;
    // Modif BTP
    TOBL := GetTOBLigne(TOBPiece, GS.Row);
    if (TOBL <> nil) and (IsLigneDetail(nil, TOBL)) then OuvrageDetail := true;
    if OuvrageDetail then GS.ElipsisButton := false;
    // -----
    if GS.Col = SG_RefArt then
    begin
      GS.ElipsisHint := HTitres.Mess[0];
      GereArticleEnabled;
    end else //AC
      if GS.Col = SG_Aff then GS.ElipsisHint := HTitres.Mess[3] else
      if GS.Col = SG_Rep then GS.ElipsisHint := HTitres.Mess[11] else
      if GS.Col = SG_Dep then GS.ElipsisHint := HTitres.Mess[12] else
      if GS.Col = SG_Lib then GS.ElipsisHint := HTitres.Mess[16] else
      // DEBUT AJOUT CHR
      {$IFDEF CHR}
      if GS.Col = SG_Regrpe then GS.ElipsisHint := HTitres.Mess[28] else
      {$ENDIF}
      // FIN AJOUT CHR
      if ((GS.Col = SG_QF) or (GS.Col = SG_QS)) then
    begin
      TOBL := GetTOBLigne(TOBPiece, ARow);
      if TOBL <> nil then
      begin
        if TOBL.GetValue('GL_CODECOND') <> '' then
        begin
          GS.ElipsisButton := True;
          GS.ElipsisHint := HTitres.Mess[8];
        end;
      end;
    end;
    StCellCur := GS.Cells[GS.Col, GS.Row];
  end;
end;

{$IFDEF BTP}

procedure TFFacture.GestionDetailOuvrage(Arow: integer);
var TOBL: TOB;
  IndiceNomen: integer;
begin
  GS.SynEnabled := false;
  TOBL := GetTOBLigne(TOBPIECE, Arow);
  if (TOBL.getValue('GL_TYPEARTICLE') = 'OUV') then
  begin
    IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
    if (IndiceNomen > 0) and (TOBL.GetValue('GL_TYPEPRESENT') > DOU_AUCUN) then
    begin
      SuppressionDetailOuvrage(Arow, false);
      AffichageDetailOuvrage(Arow);
    end;
  end;
  GS.synEnabled := true;
end;
{$ENDIF}

procedure TFFacture.GSCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  if GS.Cells[ACol, ARow] = StCellCur then Exit;
  if (GS.ColLengths[Acol] = -1) then exit;
  //if Not ((Gs.Col=SG_RefArt) or (Gs.Col=SG_Lib)) then Exit;
  FormateZoneSaisie(ACol, ARow);
  if ACol = SG_RefArt then TraiteArticle(ACol, ARow, Cancel, False, False, 1) else
    if GereContreM and (ACol = SG_ContreM) then LigneEnContreM(ACol, ARow, Cancel) else
    if ACol = SG_Rep then TraiteRepres(ACol, ARow, Cancel) else
    if ACol = SG_Dep then TraiteDepot(ACol, ARow, Cancel) else
    if ((ACol = SG_QF) or (ACol = SG_QS)) then
  begin
    if not TraiteQte(ACol, ARow) then Cancel := True;
  end else
    if ACol = SG_Lib then TraiteLibelle(ARow) else
    if ACol = SG_Px then TraitePrix(ARow) else
    if ACol = SG_Rem then TraiteRemise(ARow) else
    if ((ACol = SG_RV) or (ACol = SG_RL)) then TraiteMontantRemise(ACol, ARow) else
    if ACol = SG_DateLiv then TraiteDateLiv(ACol, ARow) else
    if ACol = SG_Aff then TraiteAffaire(ACol, ARow, Cancel) else
    // Modif BTP
    if ((ACol = SG_QA) or (ACol = SG_Pct)) then TraiteAVanc(ACol, ARow) else
    // -----
// DEBUT AJOUT CHR
    {$IFDEF CHR}
    if ACol = SG_DateProd then TraiteDateProd(ACol, ARow, Cancel) else
    if ACol = SG_Regrpe then TraiteRegroupe(ACol, ARow, Cancel) else
    {$ENDIF}
    // FIN AJOUT CHR
    // DEBUT Modif MODE 31/07/2002
    {$IFDEF MODE}
    if ACol = SG_PxNet then TraitePrixNet(ACol, ARow) else
    if ACol = SG_Montant then TraiteMontantNetLigne(ACol, ARow) else
    {$ENDIF}
    // FIN Modif MODE 31/07/2002

    TraiteLesDivers(ACol, ARow);
  if not Cancel then
  begin
    CalculeLaSaisie(ACol, ARow, False);
    {$IFDEF BTP}
    GestionDetailOuvrage(Arow);
    TOBL := GetTOBLigne(TOBPiece, ARow);
    MontreInfosLigne(TOBL, nil, nil, nil, INFOSLIGNE, PPInfosLigne);
    {$ENDIF}
    GereEnabled(Arow);
    StCellCur := GS.Cells[ACol, ARow];
  end;
end;

procedure TFFacture.GSElipsisClick(Sender: TObject);
var TOBL: TOB;
  StCode: string;
begin
  // Articles
  if GS.Col = SG_RefArt then ZoomOuChoixArt(GS.Col, GS.Row) else
    if GS.Col = SG_Rep then ZoomOuChoixRep(GS.Col, GS.Row) else
    if GS.Col = SG_Dep then ZoomOuChoixDep(GS.Col, GS.Row) else
    if GS.Col = SG_Lib then ZoomOuChoixLib(GS.Col, GS.Row) else
    // Conditionnements
    if ((GS.Col = SG_QF) or (GS.Col = SG_QS)) then
  begin
    TOBL := GetTOBLigne(TOBPiece, GS.Row);
    if TOBL <> nil then
    begin
      StCode := GetCondRecherche(GS, TOBL.GetValue('GL_CODECOND'), TOBL.GetValue('GL_ARTICLE'), TOBConds);
      TOBL.PutValue('GL_CODECOND', StCode);
    end;
  end else
    // Date de livraison
    if GS.Col = SG_DateLiv then ZoomOuChoixDateLiv(GS.Col, GS.Row) else
    // DEBUT AJOUT CHR
    {$IFDEF CHR}
    if GS.Col = SG_Regrpe then ZoomOuChoixRegroupe(GS.Col, GS.Row) else
    if GS.Col = SG_DateProd then ZoomOuChoixDateLiv(GS.Col, GS.Row) else
    {$ENDIF}
    // FIN AJOUT CHR
    // Affaire
    if GS.Col = SG_Aff then ZoomOuChoixAffaire(GS.Col, GS.Row) else
    ;
  EnvoieToucheGrid_FO(Self, GS.Cells[SG_refart, gs.row], DimSaisie, TOBPiece);
end;

function TFFacture.GereElipsis(LaCol: integer): boolean;
var SelectFourniss: string;
begin
  Result := False;
  if LaCol = SG_RefArt then
  begin
    SelectFourniss := '';
    if (ctxMode in V_PGI.PGIContexte) then
    begin
      // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
      // défini en entête du document d'achat, doivent être affichés sur l'écran de recherche.
      if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
        (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then SelectFourniss := GP_TIERS.Text;
    end;

    if GereContreM and (GS.cells[SG_CONTREM, GS.Row] = 'X')
      then Result := GetCatalogueMul(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss)
    else Result := GetArticleRecherche(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss);
  end else
  begin
    if LaCol = SG_Rep then Result := GetRepresentantSaisi(GS, HTitres.Mess[11], TOBTiers.GetValue('T_ZONECOM'), tlLocate, TOBPiece) else
      if LaCol = SG_Dep then Result := GetDepotSaisi(GS, HTitres.Mess[12], tlLocate) else
      if LaCol = SG_Lib then Result := GetLibellesAutos(GS, HTitres.Mess[16]) else
      ;
  end;
end;

procedure TFFacture.GSDblClick(Sender: TObject);
begin
  if GereContreM and (GS.Col = SG_ContreM) and (GS.Cells[SG_ContreM, gs.row] <> 'X') then GS.Cells[SG_ContreM, gs.row] := 'X' else
    if GS.Col = SG_RefArt then ZoomOuChoixArt(GS.Col, GS.Row) else
    if GS.Col = SG_Rep then ZoomOuChoixRep(GS.Col, GS.Row) else
    if GS.Col = SG_Dep then ZoomOuChoixDep(GS.Col, GS.Row) else
    {$IFDEF BTP}
    if (GS.Col = SG_Lib) and (not SaisieTypeAvanc) then CreeDesc else
    {$ELSE}
    if (GS.Col = SG_Lib) and (not SaisieTypeAvanc) then ZoomOuChoixLib(GS.Col, GS.Row) else
    {$ENDIF}
    if GS.Col = SG_Aff then ZoomOuChoixAffaire(GS.Col, GS.Row) else
    ;
  EnvoieToucheGrid_FO(Self, GS.Cells[SG_refart, gs.row], DimSaisie, TOBPiece);
end;

procedure TFFacture.GSEnter(Sender: TObject);
var bc, Cancel: boolean;
  ACol, ARow: integer;
begin
  BeforeGSEnter(Self);
  if ((GP_TIERS.Text = '') or (GP_TIERS.Text <> TOBTiers.GetValue('T_TIERS'))) then
  begin
    HPiece.Execute(5, Caption, '');
    if GP_TIERS.CanFocus then GP_TIERS.SetFocus else GotoEntete;
    Exit;
  end;
  if GP_DEVISE.Value = '' then
  begin
    HPiece.Execute(32, Caption, '');
    GP_DEVISE.Value := V_PGI.DevisePivot;
    if GP_DEVISE.CanFocus then GP_DEVISE.SetFocus else GotoEntete;
    Exit;
  end;
  {$IFNDEF BTP}
  if ((ctxAffaire in V_PGI.PGIContexte) and (not (ctxBTP in V_PGI.PGIContexte))) then
  begin
    // mcd 21/02/03 if (GP_AFFAIRE.Text ='') and (DejaRentre=False) then HPiece.Execute(27,Caption,'');
    if not (ctxGCAFF in V_PGI.PGIContexte) then
    begin
      if (GP_AFFAIRE.Text = '') and (VenteAchat <> 'ACH') and (DejaRentre = False) then HPiece.Execute(27, Caption, '');
    end
    else
    begin
      if (GP_AFFAIRE.Text = '') and (DejaRentre = False) then HPiece.Execute(27, Caption, '');
    end;
  end;
  {$ENDIF}
  if ((CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX')) and (Action <> taConsult) then
  begin
    if (MOTIFMVT.Value = '') then
    begin
      HPiece.Execute(41, Caption, '');
      MOTIFMVT.SetFocus;
      exit;
    end;
  end;
  bc := False;
  Cancel := False;
  ACol := GS.Col;
  ARow := GS.Row;
  // MOdif BTP
  if (tModeBlocNotes in SaContexte) then
  begin
    SBPosition := SB.VertScrollBar.position;
    timer1.Enabled := TRUE;
  end;
  // ---
  GSRowEnter(GS, GS.Row, bc, False);
  GSCellEnter(GS, ACol, ARow, Cancel);
  if ((Cancel) and (Action <> taConsult)) then
  begin
    ZoneSuivanteOuOk(ACol, ARow, Cancel);
    GS.Col := ACol;
    GS.Row := ARow;
    GSRowEnter(GS, GS.Row, bc, False);
    GSCellEnter(GS, ACol, ARow, Cancel);
  end;
  EnabledGrid;
  GP_DOMAINE.Enabled := False;
    // MR: Pour l(instant en attendant la correction des lignes commentaires provacant des trous dans la numérotation des lignes au changement de domaine
  if ((not DejaRentre) and (Action = taCreat) and (ObligeRegle)) then ClickAcompte(True);
  DejaRentre := True;
  //if (ctxMode in V_PGI.PGIContexte) then GP_ETABLISSEMENT.Enabled:=False ;
end;

{==============================================================================================}
{=============================== Actions sur le Entête ========================================}
{==============================================================================================}

procedure TFFacture.AfficheTaxes;
begin
  LTotalTaxesDEV.Caption := HTotalTaxesDEV.Text;
end;

procedure TFFacture.PositionneVisa;
var Lib, Domaine: string;
  NeedVisaDom: Boolean;
  MontantVisaDom: Double;
begin
  {$IFDEF CEGID}
  if ((Action = taModif) and (not TransfoPiece) and (not DuplicPiece) and
    (Arrondi(TOBPiece.GetValue('GP_TOTALHT') - OldHT, 6) = 0)) then Exit;
  {$ENDIF}
  Domaine := GP_DOMAINE.Value;
  Lib := '';
  if Domaine <> '' then Lib := GetInfoParPieceDomaine(NewNature, Domaine, 'GDP_LIBELLE');
  if ((Domaine = '') or (Lib = '')) then
  begin
    if NeedVisa then
    begin
      if Abs(TOBPiece.GetValue('GP_TOTALHT')) >= MontantVisa then TOBPiece.PutValue('GP_ETATVISA', 'ATT')
      else TOBPiece.PutValue('GP_ETATVISA', 'NON');
    end;
  end else
  begin
    NeedVisaDom := (GetInfoParPieceDomaine(NewNature, Domaine, 'GDP_VISA') = 'X');
    if not NeedVisaDom then
    begin
      TOBPiece.PutValue('GP_ETATVISA', 'NON');
    end else
    begin
      MontantVisaDom := GetInfoParPieceDomaine(NewNature, Domaine, 'GDP_MONTANTVISA');
      if Abs(TOBPiece.GetValue('GP_TOTALHT')) >= MontantVisaDom then TOBPiece.PutValue('GP_ETATVISA', 'ATT')
      else TOBPiece.PutValue('GP_ETATVISA', 'NON');
    end;
  end;
end;

procedure TFFacture.PEnteteExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  TOBPiece.GetEcran(Self, PEntete);
  if ctxAffaire in V_PGI.PGIContexte then TOBPiece.GetEcran(Self, PEnteteAffaire);
  AjouteRepres(GP_REPRESENTANT.Text, TypeCom, TOBComms);
end;

procedure TFFacture.GP_REPRESENTANTExit(Sender: TObject);
var st: string;
begin
  if csDestroying in ComponentState then Exit;
  st := GP_REPRESENTANT.Text;
  EntreCote(st, true);
  GP_REPRESENTANT.Text := st;
  if ((OldRepresentant <> '') and (not JaiLeDroitConcept(TConcept(gcSaisModifRepres), False))) then Exit;

  if GP_REPRESENTANT.Text <> OldRepresentant then
  begin
    if not existeSQL('SELECT * FROM COMMERCIAL WHERE GCL_TYPECOMMERCIAL="' + TypeCom + '" AND GCL_COMMERCIAL="' + GP_REPRESENTANT.Text + '"') then
    begin
      HPiece.execute(40, Caption, '');
      GP_REPRESENTANT.SetFocus;
      Exit;
    end;
    AjouteRepres(GP_REPRESENTANT.Text, TypeCom, TOBComms);
    BalayeLignesRep;
  end;
  GereCommercialEnabled;
end;

procedure TFFacture.GP_REPRESENTANTElipsisClick(Sender: TObject);
begin
  if ((OldRepresentant <> '') and (not JaiLeDroitConcept(TConcept(gcSaisModifRepres), False))) then Exit;
  if GetRepresentantEntete(GP_REPRESENTANT, HTitres.Mess[11], TOBTiers.GetValue('T_ZONECOM'), TOBPiece) then
  begin
    if GP_REPRESENTANT.Text <> OldRepresentant then
    begin
      AjouteRepres(GP_REPRESENTANT.Text, TypeCom, TOBComms);
      BalayeLignesRep;
      OldRepresentant := GP_REPRESENTANT.Text;
    end;
  end;
  GereCommercialEnabled;
end;

procedure TFFacture.GP_DATELIVRAISONExit(Sender: TObject);
{$IFDEF CEGID}
var DD: TDateTime;
  i, iLiv, iArt: integer;
  TOBL: TOB;
  {$ENDIF}
begin
  {$IFDEF CEGID}
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  if GeneCharge then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  DD := StrToDate(GP_DATELIVRAISON.Text);
  if DD = TOBPiece.GetValue('GP_DATELIVRAISON') then Exit;
  TOBPiece.PutValue('GP_DATELIVRAISON', DD);
  iLiv := -1;
  iArt := -1;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if i = 0 then
    begin
      iLiv := TOBL.GetNumChamp('GL_DATELIVRAISON');
      iArt := TOBL.GetNumChamp('GL_ARTICLE');
    end;
    if TOBL.GetValeur(iArt) <> '' then
    begin
      TOBL.PutValeur(iLiv, DD);
      if SG_DateLiv > 0 then GS.Cells[SG_DateLiv, i + 1] := DateToStr(DD);
    end;
  end;
  {$ENDIF}
end;

procedure TFFacture.GP_DATEPIECEExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  ExitDatePiece;
end;

function TFFacture.ExitDatePiece: Boolean;
var Err: integer;
  DD: TDateTime;
  ColPlus, ColMoins: string;
begin
  Result := False;
  Err := ControleDate(GP_DATEPIECE.Text);
  if (Err > 0) and not (GetParamSoc('SO_GCDESACTIVECOMPTA')) then //MODIF AC
  begin
    HPiece.Execute(17 + Err, caption, '');
    if GP_DATEPIECE.CanFocus then GP_DATEPIECE.SetFocus else GotoEntete;
    Exit;
  end;
  DD := StrToDate(GP_DATEPIECE.Text);
  if (ctxscot in V_PGI.PGIContexte) and (DD <= GetParamSoc('So_AFDATEDEBUTACT')) then
  begin
    HPiece.Execute(46, caption, '');
    if GP_DATEPIECE.CanFocus then GP_DATEPIECE.SetFocus else GotoEntete;
    Exit;
  end;
  if DD < V_PGI.DateDebutEuro then
  begin
    HPiece.Execute(25, caption, ' ' + DateToStr(V_PGI.DateDebutEuro));
    if GP_DATEPIECE.CanFocus then GP_DATEPIECE.SetFocus else GotoEntete;
    Exit;
  end;
  if ((DD <= VH_GC.GCDateClotureStock) and (VH_GC.GCDateClotureStock > 100)) then
  begin
    ColPlus := GetInfoParPiece(NewNature, 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(NewNature, 'GPP_QTEMOINS');
    if ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0)) then
    begin
      HPiece.Execute(28, caption, '');
      if GP_DATEPIECE.CanFocus then GP_DATEPIECE.SetFocus else GotoEntete;
      Exit;
    end;
  end;
  CleDoc.DatePiece := StrToDate(GP_DATEPIECE.Text);
  PutValueDetail(TOBPiece, 'GP_DATEPIECE', CleDoc.DatePiece);
  IncidenceTauxDate;
  //  BBI, correction fiche 10052
  TOBEches.ClearDetail;
  if CtxMode in V_PGI.PGIContexte then GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False)
  else GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False);
  //  BBI, fin correction fiche 10052
  Result := True;
end;

procedure TFFacture.GP_TIERSElipsisClick(Sender: TObject);
begin
  if IdentifieTiers then CliCur := GP_TIERS.Text;
end;

procedure TFFacture.GP_TIERSDblClick(Sender: TObject);
begin
  if IdentifieTiers then CliCur := GP_TIERS.Text;
end;

procedure TFFacture.GP_TIERSExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  GereTiersEnabled;
  if GeneCharge then Exit;
  if Action = taConsult then Exit;
  if CliCur <> GP_TIERS.Text then
  begin
    if IdentifieTiers then CliCur := GP_TIERS.Text;
  end;
end;

procedure TFFacture.GP_TIERSEnter(Sender: TObject);
begin
  CliCur := GP_TIERS.Text;
end;

procedure TFFacture.GP_DEPOTChange(Sender: TObject);
var i, IndiceLot, IndiceSerie, NbSel: integer;
  TOBL, TOBCata: TOB;
  Dep, OldDep: string;
  Okok, bChargeNouveauDepot: boolean; // DBR : Depot unique chargé
begin
  if GeneCharge then Exit;
  if GP_DEPOT.Value = '' then Exit;
  TOBCata := nil;
  bChargeNouveauDepot := False; // DBR : Depot unique chargé
  OldDep := TOBPiece.GetValue('GP_DEPOT');
  NbSel := GS.NbSelected;
  Okok := False;
  if ((OldDep <> GP_DEPOT.Value) and ((TOBArticles.Detail.Count > 0) or (TOBCatalogu.Detail.Count > 0))) then
  begin
    if (not VH_GC.GCMultiDepots) or (HPiece.Execute(7, Caption, '') = mrYes) then //AC
    begin
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        if ((NbSel = 0) or (GS.IsSelected(i + 1))) then
        begin
          TOBL := TOBPiece.Detail[i];
          {$IFNDEF CCS3}
          IndiceLot := TOBL.GetValue('GL_INDICELOT');
          if IndiceLot > 0 then Continue;
          IndiceSerie := TOBL.GetValue('GL_INDICESERIE');
          if IndiceSerie > 0 then Continue;
          {$ENDIF}
          Dep := TOBL.GetValue('GL_DEPOT');
          if (Dep = OldDep) or
            ((Dep <> GP_DEPOT.Value) and (VH_GC.GCMultiDepots) and (ctxMode in V_PGI.PGIContexte)) then // AC en Attente modification Gescom
          begin
            if TOBCata <> nil then TOBCata.free;
            TOBCata := nil;
            if TOBL.GetValue('GL_ENCONTREMARQUE') = 'X' then TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, i + 1);
            if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, False);
            TOBL.PutValue('GL_DEPOT', GP_DEPOT.Value);
            bChargeNouveauDepot := true; // DBR : Depot unique chargé
            if TOBCata <> nil then
            begin
              LoadTobDispoContreM(TobL, TobCata, False);
              ReserveCliContreM(TOBL, TOBCata, true);
            end;
            if SG_DEP > 0 then GS.Cells[SG_DEP, i + 1] := GP_DEPOT.Value;
          end;
        end;
      end;
      {$IFNDEF BTP}
      GS.ClearSelected;
      {$ELSE}
      deselectionneRows;
      {$ENDIF}
      Okok := True;
    end;
  end;
  if Okok and BChargeNouveauDepot then ChargeNouveauDepot(TOBPiece, GP_DEPOT.Value); // DBR : Depot unique chargé
  if ((NbSel > 0) and (Okok)) then
  begin
    TOBPiece.PutValue('GP_DEPOT', OldDep);
    GP_DEPOT.Value := OldDep;
  end;
end;

procedure TFFacture.GP_ETABLISSEMENTChange(Sender: TObject);
var Etab: string;
  {$IFDEF MODE}
  ListeDepot: string;
  {$ENDIF}
  Q: TQuery;
begin
  {$IFDEF MODE}
  Etab := GP_ETABLISSEMENT.Value;
  if Etab = '' then Exit;
  // Appel de la fonction renvoyant la liste des dépôts liés à l'établissement
  if VH_GC.GCMultiDepots then
  begin
    ListeDepot := ListeDepotParEtablissement(etab);
    if ListeDepot <> '' then
    begin
      // Modif 16/04/2003
      GP_DEPOT.Plus := ' GDE_SURSITE="X" AND GDE_DEPOT in (' + ListeDepot + ')';
      GP_DEPOT.Value := copy(ListeDepot, 2, 3); // Le dépôt par défaut est le premier de la liste
    end
    else
    begin
      GP_DEPOT.Plus := ' GDE_SURSITE="X"';
      GP_DEPOT.Value := VH_GC.GCDepotDefaut // Le dépôt par défaut est celui des paramètres sociétés
    end;
  end;
  {$ENDIF}
  if ((Action <> taCreat) and (not DuplicPiece)) then Exit;
  {$IFNDEF MODE}
  Etab := GP_ETABLISSEMENT.Value;
  if Etab = '' then Exit;
  {$ENDIF}
  if Etab = TOBPiece.GetValue('GP_ETABLISSEMENT') then Exit;
  PutValueDetail(TOBPiece, 'GP_ETABLISSEMENT', Etab);
  if not VH_GC.GCMultiDepots then GP_DEPOT.Value := Etab;
  CleDoc.Souche := GetSoucheG(CleDoc.NaturePiece, Etab, GP_DOMAINE.Value);
  CleDoc.NumeroPiece := GetNumSoucheG(CleDoc.Souche);
  PutValueDetail(TOBPiece, 'GP_SOUCHE', CleDoc.Souche);
  PutValueDetail(TOBPiece, 'GP_NUMERO', CleDoc.NumeroPiece);
  if (ctxMode in V_PGI.PGIContexte) and (not duplicPiece) then
  begin
    Q := OpenSQL('select ET_DEVISE from ETABLISS where ET_ETABLISSEMENT="' + Etab + '"', true);
    if not Q.EOF then GP_DEVISE.Value := Q.FindField('ET_DEVISE').AsString;
    Ferme(Q);
  end;
end;

procedure TFFacture.GP_DOMAINEChange(Sender: TObject);
var Domaine: string;
begin
  if ((Action <> taCreat) and (not DuplicPiece)) then Exit;
  Domaine := GP_DOMAINE.Value;
  if Domaine = '' then Exit;
  if Domaine = TOBPiece.GetValue('GP_DOMAINE') then Exit;
  CleDoc.Souche := GetSoucheG(CleDoc.NaturePiece, GP_ETABLISSEMENT.Value, Domaine);
  CleDoc.NumeroPiece := GetNumSoucheG(CleDoc.Souche);
  PutValueDetail(TOBPiece, 'GP_SOUCHE', CleDoc.Souche);
  PutValueDetail(TOBPiece, 'GP_NUMERO', CleDoc.NumeroPiece);
end;

procedure TFFacture.GP_TVAENCAISSEMENTChange(Sender: TObject);
var Exi: string;
begin
  if GeneCharge then Exit;
  if Action = taConsult then Exit;
  Exi := GP_TVAENCAISSEMENT.Value;
  if (Exi = TOBPiece.GetValue('GP_TVAENCAISSEMENT')) and not (ChangeComplEntete) then Exit;
  TOBPiece.PutValue('GP_TVAENCAISSEMENT', Exi);
  PieceVersLigneExi(TOBPiece, nil);
end;

procedure TFFacture.GP_REGIMETAXEChange(Sender: TObject);
var Reg: string;
begin
  if GeneCharge then Exit;
  {$IFDEF AFFAIRE}
  if Action = taConsult then Exit; // modif du regime de taxe dans complément autorisé en modif de pièce
  {$ELSE}
  if ((Action <> taCreat) and (not DuplicPiece) and (not SaisieTypeAffaire)) then Exit;
  {$ENDIF}

  Reg := GP_REGIMETAXE.Value;
  if Reg = '' then Exit;
  if (Reg = TOBPiece.GetValue('GP_REGIMETAXE')) and not (ChangeComplEntete) then Exit;
  PutValueDetail(TOBPiece, 'GP_REGIMETAXE', Reg);
  PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
  if ChangeComplEntete then CalculeLaSaisie(-1, -1, False);
end;

function TFFacture.GetLeTauxDevise(CodeD: string; var DateTaux: TDateTime; DateP: TDateTime): Double;
var Taux: Double;
  AvecT, ChoixT, Taux1: Boolean;
  ii: integer;
begin
  AvecT := False;
  ChoixT := False;
  Taux1 := False;
  case Action of
    taCreat: AvecT := True;
    taModif:
      begin
        if DuplicPiece then AvecT := True else
          if ((TransfoPiece) and (GetInfoParPiece(NewNature, 'GPP_TYPEECRCPTA') = 'NOR')) then AvecT := True;
      end;
  end;
  if AvecT then
  begin
    Taux := GetTaux(CodeD, DateTaux, DateP);
    if ((CodeD <> V_PGI.DevisePivot) and (not EstMonnaieIN(CodeD))) then
    begin
      if VH_GC.GCAlerteDevise = 'JOU' then ChoixT := (DateTaux <> DateP) else
        if VH_GC.GCAlerteDevise = 'SEM' then ChoixT := (NumSemaine(DateTaux) <> NumSemaine(DateP)) else
        if VH_GC.GCAlerteDevise = 'MOI' then ChoixT := (GetPeriode(DateTaux) <> GetPeriode(DateP));
      if Taux = 1 then
      begin
        Taux1 := True;
        ChoixT := True;
      end;
      if ChoixT then
      begin
        if Taux1 then ii := HPiece.Execute(16, caption, '') else ii := HPiece.Execute(15, caption, '');
        if ii = mrYes then
        begin
          {$IFNDEF SANSCOMPTA}
          FicheChancel(CodeD, True, DateP, taCreat, (DateP >= V_PGI.DateDebutEuro));
          {$ENDIF}
          Taux := GetTaux(CodeD, DateTaux, DateP);
        end;
      end;
    end;
  end else
  begin
    Taux := TOBPiece.GetValue('GP_TAUXDEV');
  end;
  Result := Taux;
end;

procedure TFFacture.GP_DEVISEChange(Sender: TObject);
begin
  if GP_DEVISE.Value = '' then
  begin
    FillChar(DEV, Sizeof(DEV), #0);
    Exit;
  end;
  DEV.Code := GP_DEVISE.Value;
  GetInfosDevise(DEV);
  DEV.Taux := GetLeTauxDevise(DEV.Code, DEV.DateTaux, CleDoc.DatePiece);
  PutValueDetail(TOBPiece, 'GP_DEVISE', DEV.Code);
  PutValueDetail(TOBPiece, 'GP_TAUXDEV', DEV.Taux);
  PutValueDetail(TOBPiece, 'GP_DATETAUXDEV', DEV.DateTaux);
  ChangeFormatDevise(Self, DEV.Decimale, DEV.Symbole);
  LDevise.Caption := DEV.Symbole;
  if DEV.Code <> V_PGI.DevisePivot then
  begin
    PopD.Items[2].Checked := True;
    BDevise.Enabled := False;
    GP_DEVISE.Enabled := True;
    LDevise.Visible := True;
  end else
  begin
    if not DuplicPiece then BDevise.Enabled := True;
    if PopD.Items[2].Checked then PopD.Items[0].Checked := True;
    GP_DEVISE.Enabled := False;
    LDevise.Visible := False;
  end;
  if not GeneCharge then
  begin
    AfficheEuro;
    ValideLaCotation(TOBPiece, TOBBases, TOBEches);
  end;
end;

{==============================================================================================}
{=============================== Actions sur le Pied ==========================================}
{==============================================================================================}

procedure TFFacture.GP_ESCOMPTEExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  if GP_ESCOMPTE.Value = TOBPiece.GetValue('GP_ESCOMPTE') then Exit;
  if GP_ESCOMPTE.Value > 100 then
  begin
    HPiece.Execute(49, Caption, '');
    GP_ESCOMPTE.Value := TOBPiece.GetValue('GP_ESCOMPTE');
    exit;
  end;
  {$IFDEF BTP}
  PutValueDetailOuv(TOBOuvrage, 'BLO_ESCOMPTE', GP_ESCOMPTE.Value);
  {$ENDIF}
  PutValueDetail(TOBPiece, 'GP_ESCOMPTE', GP_ESCOMPTE.Value);
  PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, TotEnListe);
end;

procedure TFFacture.GP_REMISEPIEDExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  if GP_REMISEPIED.Value = TOBPiece.GetValue('GP_REMISEPIED') then Exit;
  if GP_REMISEPIED.Value < 0 then GP_REMISEPIED.Value := 0;
  if GP_REMISEPIED.Value > 100 then
  begin
    HPiece.Execute(50, Caption, '');
    GP_REMISEPIED.Value := TOBPiece.GetValue('GP_REMISEPIED');
    Exit;
  end;
  {$IFDEF BTP}
  PutValueDetailOuv(TOBOuvrage, 'BLO_REMISEPIED', GP_REMISEPIED.Value);
  {$ENDIF}
  PutValueDetail(TOBPiece, 'GP_REMISEPIED', GP_REMISEPIED.Value);
  PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, TotEnListe);
end;

{==============================================================================================}
{=============================== Manipulation des LIGNES ======================================}
{==============================================================================================}

procedure TFFacture.AfficheLigneDimGen(TOBL: TOB; ARow: integer);
var
  TOBDim: TOB;
  j, iDim, iArt: integer;
  Total, MontantLigneHT, MontantLigneTTC, MontantBrut,
    TotRemLigne, RemLigne, ValRem, QteReliq,
    PxHTBrut, PxTTCBrut, PxHTnet, PxTTCnet, QteFact, QteStock, QteReste: Double;
  Premier: Boolean;
begin
  if TOBL.GetValue('GL_TYPEDIM') <> 'GEN' then Exit;

  Total := 0;
  MontantLigneHT := 0;
  MontantLigneTTC := 0;
  TotRemLigne := 0;
  ValRem := 0;
  QteReliq := 0;
  PxHTBrut := 0;
  PxTTCBrut := 0;
  PxHTnet := 0;
  PxTTCnet := 0;
  MontantBrut := 0;
  RemLigne := 0;
  QteFact := 0;
  QteStock := 0;
  QteReste := 0;

  Premier := True;
  GS.Cells[SG_RefArt, ARow] := TOBL.GetValue('GL_CODESDIM');
  { NEWPIECE }
  j := TOBL.GetIndex + 1;
  if j <= TobPiece.Detail.Count - 1 then
  begin
    TobDim := TobPiece.Detail[j];
    iDim := TOBDim.GetNumChamp('GL_TYPEDIM');
    iArt := TOBDim.GetNumChamp('GL_CODEARTICLE');
    while TOBDim.GetValeur(iDim) = 'DIM' do
    begin
      if TOBDim.GetValeur(iArt) = GS.Cells[SG_RefArt, ARow] then
      begin
        if GP_FACTUREHT.Checked then
        begin
          Total := Total + TOBDim.GetValue('GL_TOTALHTDEV');
          MontantBrut := MontantBrut + (TOBDim.GetValue('GL_QTEFACT') * TOBDim.GetValue('GL_PUHTDEV'));
        end
        else
        begin
          Total := Total + TOBDim.GetValue('GL_TOTALTTCDEV');
          MontantBrut := MontantBrut + (TOBDim.GetValue('GL_QTEFACT') * TOBDim.GetValue('GL_PUTTCDEV'));
        end;
        MontantLigneHT := MontantLigneHT + TOBDim.GetValue('GL_MONTANTHTDEV');
        MontantLigneTTC := MontantLigneTTC + TOBDim.GetValue('GL_MONTANTTTCDEV');
        TotRemLigne := TotRemLigne + TOBDim.GetValue('GL_TOTREMLIGNEDEV');
        ValRem := ValRem + TOBDim.GetValue('GL_VALEURREMDEV');
        QteReliq := QteReliq + TOBDim.GetValue('GL_QTERELIQUAT');
        QteFact := QteFact + TOBDim.GetValue('GL_QTEFACT');
        QteStock := QteStock + TOBDim.GetValue('GL_QTESTOCK');
        QteReste := QteReste + TOBDim.GetValue('GL_QTERESTE');
        if Premier then
        begin
          PxHTBrut := TOBDim.GetValue('GL_PUHTDEV');
          PxHTNet := TOBDim.GetValue('GL_PUHTNETDEV');
          PxTTCBrut := TOBDim.GetValue('GL_PUTTCDEV');
          PxTTCNet := TOBDim.GetValue('GL_PUTTCNETDEV');
        end
        else
        begin
          if ((PxHTBrut <> 0) and (PxHTBrut <> TOBDim.GetValue('GL_PUHTDEV'))) then PxHTBrut := 0;
          if ((PxHTNet <> 0) and (PxHTNet <> TOBDim.GetValue('GL_PUHTNETDEV'))) then PxHTNet := 0;
          if ((PxTTCBrut <> 0) and (PxTTCBrut <> TOBDim.GetValue('GL_PUTTCDEV'))) then PxTTCBrut := 0;
          if ((PxTTCNet <> 0) and (PxTTCNet <> TOBDim.GetValue('GL_PUTTCNETDEV'))) then PxTTCNet := 0;
        end;
        Premier := False;
      end;
      Inc(j);
      if j > TOBPiece.Detail.Count - 1 then Break;
      TOBDim := TOBPiece.Detail[j];
    end;
  end;
  // modif 02/08/2001
  if MontantBrut <> 0 then
  begin
    if GP_FACTUREHT.Checked then
    begin
      if MontantLigneHT <> 0 then
      begin
        RemLigne := Arrondi(((MontantBrut - MontantLigneHT) / MontantBrut) * 100.0, 6);
        //Modif JD 16/05/2002
        if (RemLigne = 100) or (QteFact = 0) then PxHTBrut := 0 else
          PxHTBrut := Arrondi(((MontantLigneHT * 100) / (100 - RemLigne)) / QteFact, DEV.Decimale);
      end;
    end else
    begin
      if MontantLigneTTC <> 0 then
      begin
        RemLigne := Arrondi(((MontantBrut - MontantLigneTTC) / MontantBrut) * 100.0, 6);
        //Modif JD 16/05/2002
        if (RemLigne = 100) or (QteFact = 0) then PxTTCBrut := 0 else
          PxTTCBrut := Arrondi(((MontantLigneTTC * 100) / (100 - RemLigne)) / QteFact, DEV.Decimale)
      end;
    end;
  end;
  if SG_Montant <> -1 then
  begin
    if GP_FACTUREHT.Checked then GS.Cells[SG_Montant, Arow] := FloatToStr(MontantLigneHT)
    else GS.Cells[SG_Montant, Arow] := FloatToStr(MontantLigneTTC);
  end;
  if SG_Rem <> -1 then GS.Cells[SG_Rem, Arow] := FloatToStr(RemLigne);
  if SG_RL <> -1 then GS.Cells[SG_RL, ARow] := FloatToStr(TotRemLigne);
  if SG_RV <> -1 then GS.Cells[SG_RV, ARow] := FloatToStr(ValRem);
  if SG_Total <> -1 then GS.Cells[SG_Total, ARow] := FloatToStr(Total);
  if SG_QR <> -1 then GS.Cells[SG_QR, ARow] := FloatToStr(QteReliq);
  if SG_QF >= 0 then GS.Cells[SG_QF, ARow] := FloatToStr(QteFact);
  if SG_QS >= 0 then GS.Cells[SG_QS, ARow] := FloatToStr(QteStock);
  if SG_QReste <> -1 then GS.Cells[SG_QReste, ARow] := FloatToStr(QteReste);
  if SG_Px <> -1 then
  begin
    if GP_FACTUREHT.Checked then GS.Cells[SG_Px, Arow] := FloatToStr(PxHTBrut) else GS.Cells[SG_Px, Arow] := FloatToStr(PxTTCBrut);
  end;
  // Modif MODE 31/07/2002
  if SG_PxNet <> -1 then
  begin
    if GP_FACTUREHT.Checked then GS.Cells[SG_PxNet, Arow] := FloatToStr(PxHTNet) else GS.Cells[SG_PxNet, Arow] := FloatToStr(PxTTCNet);
  end;
  TOBL.Putvalue('GL_MONTANTHTDEV', MontantLigneHT);
  TOBL.Putvalue('GL_MONTANTTTCDEV', MontantLigneTTC);
  TOBL.PutValue('GL_PUHTDEV', PxHTBrut);
  TOBL.PutValue('GL_PUHTNETDEV', PxHTNet);
  TOBL.PutValue('GL_PUTTCDEV', PxTTCBrut);
  TOBL.PutValue('GL_PUTTCNETDEV', PxTTCNet);
  TOBL.PutValue('GL_QTEFACT', QteFact);
  TOBL.PutValue('GL_QTESTOCK', QteStock);
  TOBL.PutValue('GL_REMISELIGNE', RemLigne);
  TOBL.PutValue('GL_QTERELIQUAT', QteReliq);
  TOBL.PutValue('GL_QTERESTE', QteReste); { NEWPIECE }
end;

procedure TFFacture.AfficheLaLigne(ARow: integer);
var TOBL: TOB;
  i: integer;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBL.PutLigneGrid(GS, ARow, False, False, LesColonnes);
  AfficheLigneDimGen(TOBL, ARow);
  for i := 1 to GS.ColCount - 1 do FormateZoneSaisie(i, ARow);
end;

function TFFacture.InitLaLigne(ARow: integer; NewQte: double): T_ActionTarifArt;
var TOBL, TOBA, TOBCATA, TOBArtREf: TOB;
begin
  Result := ataOk;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
  // pour init des champs venant de l'article de référence
  TobArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [TOBL.getvalue('_CONTREMARTREF')], False);
  Result := PreAffecteLigne(TOBPiece, TOBL, TOBA, TOBTiers, TOBTarif, TOBConds, TOBAffaire, TOBCata, TOBArtRef, ARow, DEV, NewQte);
  case Result of
    ataOk: ;
    ataAlerte: HPiece.Execute(0, Caption, '');
    ataCancel:
      begin
        HPiece.Execute(1, Caption, '');
        GS.Cells[SG_RefArt, ARow] := '';
        VideCodesLigne(TOBPiece, ARow);
        InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
      end;
  end;
  AfficheLaLigne(ARow);
  GereDescriptif(ARow, True);
end;

function TFFacture.PieceModifiee: boolean;
begin
  Result := False;
  if Action = taConsult then Exit;
  Result := ((TOBPiece.IsOneModifie) or (TOBAdresses.IsOneModifie) or (TOBAcomptes.IsOneModifie) or
    (TOBPIECERG.IsOneModifie) or (TOBBasesRg.ISOneModifie) or (TOBLIENOLE.IsOneModifie) or
    (TransfoPiece) or (DuplicPiece));
end;

{==============================================================================================}
{=============================== Manipulation des tiers =======================================}
{==============================================================================================}

function TFFacture.IdentifieTiers: boolean;
var OldTiers: string;
begin
  Result := True;
  if ((GP_TIERS.Text <> '') and (GP_TIERS.Text = TOBTiers.GetValue('T_TIERS'))) then Exit;
  Result := GetTiers(GP_TIERS);
  if Result then
  begin
    OldTiers := TOBTiers.GetValue('T_TIERS');
    if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
      (OldTiers <> '') and (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then
    begin
      // Le fournisseur ne peut être modifié, si des lignes existent déjà dans le document
      if TOBPiece.Detail.Count > 1 then
      begin
        HPiece.Execute(37, Caption, '');
        GP_TIERS.Text := OldTiers;
        Exit;
      end;
    end;
    ChargeTiers;
    PutValueDetail(TOBPiece, 'GP_TIERS', GP_TIERS.Text);
    if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then ChargeAffairePiece(True, True);
  end;
  GereTiersEnabled;
end;

function TFFacture.CalculMargeLigne(ARow: integer): double;
var TOBL, TOBA: TOB;
  RefU, QualM: string;
  //OkUs : Boolean ;
  //ii          : integer ;
  PxValo, PuNet, MC: double;
begin
  result := 0;
  MC := 0;
  if ARow <= 0 then Exit;
  if Action = taConsult then Exit;
  if EstAvoir then Exit;
  if VenteAchat <> 'VEN' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefU := TOBL.GetValue('GL_ARTICLE');
  if RefU = '' then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  QualM := TOBA.GetValue('GA_QUALIFMARGE');
  if QualM = '' then Exit;
  if VH_GC.GCMargeArticle = 'PMA' then PxValo := TOBL.GetValue('GL_PMAP') else
    if VH_GC.GCMargeArticle = 'PMR' then PxValo := TOBL.GetValue('GL_PMRP') else
    if VH_GC.GCMargeArticle = 'DPA' then PxValo := TOBL.GetValue('GL_DPA') else
    if VH_GC.GCMargeArticle = 'DPR' then PxValo := TOBL.GetValue('GL_DPR') else Exit;
  PuNet := TOBL.GetValue('GL_PUHTNET');
  if QualM = 'MO' then
  begin
    MC := PuNet - PxValo;
  end else if QualM = 'CO' then
  begin
    if TOBPiece.GetValue('GP_FACTUREHT') = '-' then PuNet := TOBL.GetValue('GL_PUTTCNET');
    if PxValo > 0 then MC := (PuNet / PxValo) else MC := 0;
  end else if QualM = 'PC' then
  begin
    if PuNet > 0 then MC := (PuNet - PxValo) / PuNet else MC := 0;
  end;
  TOBL.PutValue('MARGE', MC);
  result := MC;
end;

function TFFacture.TesteMargeMini(ARow: integer): boolean;
var TOBL, TOBA: TOB;
  RefU, QualM: string;
  PasOkM, OkUs: Boolean;
  ii: integer;
  MargeMini, MC: double;
  //PxValo,PuNet
begin
  Result := False;
  if ARow <= 0 then Exit;
  if Action = taConsult then Exit;
  if EstAvoir then Exit;
  if VenteAchat <> 'VEN' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefU := TOBL.GetValue('GL_ARTICLE');
  if RefU = '' then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  QualM := TOBA.GetValue('GA_QUALIFMARGE');
  if QualM = '' then Exit;
  MargeMini := TOBA.GetValue('GA_MARGEMINI'); //MC:=0 ;
  PasOkM := false;
  // Modif BTP
  MC := CalculMargeLigne(Arow);
  // Fin Modif BTP
  if QualM = 'MO' then
  begin
    PasOkM := (MC < MargeMini);
  end else if QualM = 'CO' then
  begin
    if MC <> 0 then PasOkM := (MC < MargeMini);
  end else if QualM = 'PC' then
  begin
    if MC <> 0 then PasOkM := (MC < MargeMini);
  end;
  if PasOkM then
  begin
    if ((V_PGI.Superviseur) or (not VH_GC.GCBloqueMarge)) then
    begin
      HPiece.Execute(17, caption, '');
    end else
    begin
      {$IFDEF EAGLCLIENT}
      Result := True;
      {$ELSE}
      ii := HPiece.Execute(23, caption, '');
      if ii <> mrYes then Result := True else
      begin
        OkUs := ChangeUser;
        if ((not OkUs) or (not V_PGI.Superviseur)) then Result := True;
      end;
      {$ENDIF}
    end;
  end;
end;

/////////////////////////////////////////////////////
// Motifs
////////////////////////////////////////////////////

procedure TFFacture.TraiteMotif(ARow: integer);
var TOBL: TOB;
begin
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then Exit;
    if GS.CellValues[SG_Motif, ARow] = '' then GS.CellValues[SG_Motif, ARow] := MOTIFMVT.Value;
    TOBL.PutValue('GL_MOTIFMVT', GS.CellValues[SG_Motif, ARow]);
  end;
end;

function TFFacture.AffecteMotif(ARow: integer): boolean;
var TOBL: TOB;
  Ligne: integer;
  StMotif, CodeArticle, StArt, StTypeDim: string;
  Continue: boolean;
begin
  result := false;
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then Exit;
    StArt := TOBL.GetValue('GL_ARTICLE');
    StTypeDim := TOBL.GetValue('GL_TYPEDIM');
    if (StArt = '') and (StTypeDim <> 'GEN') then Exit;
    TraiteMotif(ARow);
    if StTypeDim = 'GEN' then
    begin
      CodeArticle := TOBL.GetValue('GL_CODESDIM');
      if CodeArticle = '' then exit;
      Ligne := ARow;
      StMotif := TOBL.GetValue('GL_MOTIFMVT');
      Continue := True;
      while Continue do
      begin
        TOBL := GetTOBLigne(TOBPiece, Ligne + 1);
        if TOBL = nil then Exit;
        if (TOBL.GetValue('GL_CODEARTICLE') = CodeArticle) and (TOBL.GetValue('GL_TYPEDIM') = 'DIM') then
        begin
          Ligne := Ligne + 1;
          TOBL.PutValue('GL_MOTIFMVT', StMotif);
        end
        else Continue := False;
      end;
    end;
  end;
end;

procedure TFFacture.ChargeTiersDefaut;
begin
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
  begin
    GeneCharge := False;
    GP_TIERS.Text := GetParamsoc('SO_GCTIERSMVSTK');
    ChargeTiers;
  end;
end;

/////////////////////////////////////////////////////
// TIERS, DEVISES
////////////////////////////////////////////////////

function TFFacture.TesteRisqueTiers(Valid: boolean): boolean;
var TotR, CreditA, PlaF: Double;
  OkUs: boolean;
  InfoR: string;
begin
  Result := False;
  if SansRisque then Exit;
  if TOBTiers.GetValue('T_AUXILIAIRE') = '' then Exit;
  if ((QuestionRisque) and (not Valid)) then Exit;
  TotR := RisqueTiers + TOBPiece.GetValue('GP_TOTALTTC');
  Plaf := TOBTiers.GetValue('T_CREDITPLAFOND');
  if TOTR >= Plaf then
  begin
    QuestionRisque := True;
    InfoR := #13 + #10 + '(' + HTitres.Mess[21] + ' ' + Strf00(Plaf, V_PGI.OkDecV) + ' / ' + HTitres.Mess[22] + ' ' + Strf00(TOTR, V_PGI.OkDecV) + ')';
    if V_PGI.Superviseur then HPiece.Execute(13, caption, InfoR) else
    begin
      {$IFDEF EAGLCLIENT}
      HPiece.Execute(13, caption, InfoR);
      Result := True;
      {$ELSE}
      if HPiece.Execute(24, caption, '') = mrYes then
      begin
        OkUs := ChangeUser;
        if ((not OkUs) or (not V_PGI.Superviseur)) then Result := True;
      end else Result := True;
      {$ENDIF}
    end;
  end else
  begin
    CreditA := TOBTiers.GetValue('T_CREDITACCORDE');
    InfoR := #13 + #10 + '(' + HTitres.Mess[21] + ' ' + Strf00(CreditA, V_PGI.OkDecV) + ' / ' + HTitres.Mess[22] + ' ' + Strf00(TOTR, V_PGI.OkDecV) + ')';
    if ((CreditA > 0) and (TOTR > CreditA)) then
    begin
      HPiece.Execute(14, caption, '');
      QuestionRisque := True;
    end;
  end;
end;

function TFFacture.CalculeRisqueTiers: string;
var NaturePieceG: string;
  Plaf, TotR: Double;
begin
  Result := '';
  RisqueTiers := 0;
  SansRisque := True;
  QuestionRisque := False;
  if Action = taConsult then Exit;
  if EstAvoir then Exit;
  NaturePieceG := TOBPiece.GetValue('GP_NATUREPIECEG');
  if VenteAchat <> 'VEN' then Exit;
  if GetInfoParPiece(NewNature, 'GPP_ENCOURS') <> 'X' then Exit;
  if ((Action = taCreat) or (DuplicPiece) or (TransfoPiece)) then Result := TOBTiers.GetValue('T_ETATRISQUE');
  if ((Result = '') or (Result = 'O')) then
  begin
    {Non affecté ou Orange --> tester l'encours en temps réel}
    Plaf := TOBTiers.GetValue('T_CREDITPLAFOND');
    if Plaf = 0 then Exit;
    RisqueTiers := RisqueTiersGC(TOBTiers) + RisqueTiersCPTA(TOBTiers, V_PGI.DateEntree);
    if ((Action = taModif) and (not DuplicPiece)) then RisqueTiers := RisqueTiers - TOBPiece.GetValue('GP_TOTALTTC');
    TotR := RisqueTiers + TOBPiece.GetValue('GP_TOTALTTC');
    if ((Action = taCreat) or (DuplicPiece) or (TransfoPiece)) then
    begin
      if TotR > Plaf then Result := 'R';
    end;
    SansRisque := False;
  end else if Result = 'V' then
  begin
    {Vert --> pas de test d'encours}
    if TOBTiers.GetValue('T_CREDITPLAFOND') = 0 then Exit;
    RisqueTiers := 0;
    SansRisque := True;
  end else if Result = 'R' then
  begin
    {Rouge --> Risque + tiers interdit}
    SansRisque := False;
  end;
end;

procedure TFFacture.ChargeTiers;
var tr: T_RechTiers;
  ChgTiers, Rouge: boolean;
  OldT, EtatR: string;
  {$IFDEF NOMADE}
  Nature, Nom: string;
  {$ENDIF}
  TOBT: TOB;
begin
  {$IFDEF NOMADE} //Si nomade, interdiction de créer des cdes pour les prospects (GC uniquement)
  if not (ctxMode in V_PGI.PGIContexte) and (NewNature = 'CC') then
  begin
    Nature := GetColonneSQL('TIERS', 'T_NATUREAUXI', 'T_TIERS="' + GP_TIERS.Text + '"');
    if Nature = 'PRO' then
    begin
      Nom := GetColonneSQL('TIERS', 'T_LIBELLE', 'T_TIERS="' + GP_TIERS.Text + '"');
      PGIBox('Le tiers ' + GP_TIERS.Text + '-' + Nom + ' est un prospect, il faut créer un devis', 'Erreur');
      GP_TIERS.Text := '';
      exit;
    end;
  end;
  {$ENDIF}

  OldT := TOBTiers.GetValue('T_TIERS');
  ChgTiers := (GP_TIERS.Text <> OldT);
  Rouge := False;
  if SaisieTypeAffaire then tr := RemplirTOBTiers(TOBTiers, GP_TIERS.Text, NewNature, False) // mcd 07/05/02 si utilisationd epuis affaire, pas test clt fermé
  else tr := RemplirTOBTiers(TOBTiers, GP_TIERS.Text, NewNature, True);
  case tr of
    trtIncorrect: HPiece.Execute(8, Caption, '');
    trtFerme: HPiece.Execute(3, Caption, '');
    trtOk:
      begin
        EtatR := CalculeRisqueTiers;
        if EtatR = 'R' then
        begin
          HPiece.Execute(34, caption, '');
          tr := trtIncorrect;
          Rouge := True;
        end;
      end;
  end;
  if tr <> trtOk then
  begin
    {Tiers en Rouge sur une création (ou duplication) --> interdire ce tiers}
    if (Rouge) and ((Action = taCreat) or (DuplicPiece)) then GP_TIERS.Text := '' else GP_TIERS.Text := TOBTiers.GetValue('T_TIERS')
  end else
  begin
    if ChgTiers then
    begin
      CataFourn := False;
      if VenteAchat = 'ACH' then CataFourn := ExisteSQL('SELECT GCA_TIERS FROM CATALOGU WHERE GCA_TIERS="' + GP_TIERS.Text + '"');
    end;
  end;
  LibelleTiers.Caption := TOBTiers.GetValue('T_LIBELLE');
  LibelleTiers.Refresh;
  {Exceptions tiers}
  TOBT := TOBTiers.FindFirst(['GTP_NATUREPIECEG'], [NewNature], False);
  if TOBT <> nil then
  begin
    NeedVisa := (TOBT.GetValue('GTP_VISA') = 'X');
    MontantVisa := TOBT.GetValue('GTP_MONTANTVISA');
  end;
  {Incidences tiers}
  if ((Action = taCreat) or (DuplicPiece)) then
  begin
    IncidenceTiers;
    if ((ChgTiers) and (not GeneCharge)) then
    begin
      IncidenceRefs;
      IncidenceAcompte;
      if not IncidenceTarif then
      begin
        PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
        CalculeLaSaisie(-1, -1, TotEnListe);
      end;
    end;
  end;
  GP_REPRESENTANT.Enabled := True;
  {Tiers en rouge sur une transformation de pièce --> passer en consultation}
  if ((Rouge) and (GeneCharge) and (TransfoPiece)) then
  begin
    Action := taConsult;
    TransfoPiece := False;
    NewNature := TOBPiece.GetValue('GP_NATUREPIECEG');
    FTitrePiece.Caption := GetInfoParPiece(NewNature, 'GPP_LIBELLE');
  end;
end;

procedure TFFacture.IncidenceTauxDate;
var OldTaux: Double;
begin
  if GeneCharge then Exit;
  if Action = taConsult then Exit;
  if ((Action = taModif) and (not DuplicPiece) and (not TransfoPiece)) then Exit;
  OldTaux := DEV.Taux;
  GP_DEVISEChange(nil);
  if Arrondi(OldTaux - DEV.Taux, 9) <> 0 then
  begin
    ChangeTauxAcomptes(TOBPiece, TOBAcomptes, DEV);
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
    ChangeTauxEches(TOBPiece, TOBEches, DEV);
  end;
end;

procedure TFFacture.IncidenceAcompte;
begin
  TOBAcomptes.ClearDetail;
  AcomptesVersPiece(TOBAcomptes, TOBPiece);
  GP_ACOMPTEDEV.Value := TOBPiece.GetValue('GP_ACOMPTEDEV');
end;

procedure TFFacture.IncidenceRefs;
var TOBL: TOB;
  i, iArt: integer;
  RefA: string;
begin
  if Action = taConsult then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  iArt := 0;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if TOBL = nil then Break;
    if i = 0 then iArt := TOBL.GetNumChamp('GL_CODEARTICLE');
    RefA := TOBL.GetValeur(iArt);
    if RefA = '' then Continue;
    if TOBL.GetValue('GL_REFARTSAISIE') = TOBL.GetValue('GL_REFARTTIERS') then
    begin
      TOBL.PutValue('GL_REFARTSAISIE', RefA);
      TOBL.PutValue('GL_REFARTTIERS', '');
      GS.Cells[SG_RefArt, i + 1] := RefA;
      AfficheLaLigne(i + 1);
    end;
  end;
end;

function TFFacture.IncidenceTarif: boolean;
var St: string;
  TOBL, TOBA: TOB;
  i: integer;
begin
  Result := False;
  if TOBPiece.Detail.Count <= 0 then Exit;
  if TOBArticles.Detail.Count <= 0 then Exit;
  if GetInfoParPiece(NewNature, 'GPP_CONDITIONTARIF') <> 'X' then Exit;
  St := AGLLanceFiche('GC', 'GCOPTIONTARIF', '', '', '');
  if ((St = '') or (St = '0')) then Exit;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
    if TOBA = nil then Continue;
    TOBL := TOBPiece.Detail[i];
    if ((GS.NbSelected = 0) or (GS.IsSelected(i + 1))) then
    begin
      TarifVersLigne(TOBA, TOBTiers, TOBL, TOBPiece, TOBTarif, True, (St = '2'), DEV);
      TOBL.putvalue('GL_RECALCULER', 'X');
      AfficheLaLigne(i + 1);
    end;
  end;
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, False);
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  deselectionneRows;
  {$ENDIF}
  Result := True;
end;

procedure TFFacture.MontreEuroPivot(Montrer: boolean);
begin
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then exit;
  EUROPIVOT.Visible := Montrer;
  GP_DEVISE.Visible := not Montrer;
  if ((Montrer) and (EuroPivot.Text = '')) then
  begin
    if VH^.TenueEuro then EuroPivot.Text := VH^.LibDeviseFongible else EuroPivot.Text := HTitres.Mess[14];
  end;
end;

procedure TFFacture.AfficheEuro;
var ModeOppose: boolean;
begin
  ModeOppose := False;
  if VH^.TenueEuro then
  begin
    if PopD.Items[0].Checked then ModeOppose := False else
      if PopD.Items[1].Checked then ModeOppose := True else
      if PopD.Items[2].Checked then ModeOppose := False;
  end else
  begin
    if PopD.Items[0].Checked then ModeOppose := False else
      if PopD.Items[1].Checked then ModeOppose := True else
      if PopD.Items[2].Checked then ModeOppose := False;
  end;
  GP_SAISIECONTRE.Checked := ModeOppose;
  GP_DEVISE.Enabled := PopD.Items[2].Checked;
  if ModeOppose then
  begin
    TOBPiece.PutValue('GP_SAISIECONTRE', 'X');
    DEV.Decimale := V_PGI.OkDecE;
    if not VH^.TenueEuro then DEV.Symbole := '€' else DEV.Symbole := VH^.SymboleFongible;
    ChangeFormatDevise(Self, DEV.Decimale, DEV.Symbole);
  end else
  begin
    TOBPiece.PutValue('GP_SAISIECONTRE', '-');
    if DEV.Code = V_PGI.DevisePivot then
    begin
      DEV.Decimale := V_PGI.OkDecV;
      DEV.Symbole := V_PGI.SymbolePivot;
      ChangeFormatDevise(Self, DEV.Decimale, DEV.Symbole);
    end;
  end;
  MontreEuroPivot((not GP_DEVISE.Enabled) and (ModeOppose));
  ColorOpposeEuro(GS, ModeOppose, (GP_DEVISE.Value <> V_PGI.DevisePivot));
end;

procedure TFFacture.IncidenceTiers;
var CodeD, CodeTiers, CodeRepres: string;
  OkE, OkOut: Boolean;
begin
  // DEBUT AJOUT CHR
  //if GeneCharge then Exit ;
  {$IFDEF BTP}
  if (GeneCharge and (not DuplicPiece)) then
    {$ELSE}
  if GeneCharge then
    {$ENDIF}
  begin
    {$IFDEF CHR}
    GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
    {$ENDIF}
    Exit;
  end;
  // FIN AJOUT CHR
  if ((Action <> taCreat) and (not DuplicPiece)) then Exit;
  CodeTiers := TOBTiers.GetValue('T_TIERS');
  GP_ESCOMPTE.Value := TOBTiers.GetValue('T_ESCOMPTE');
  PutValueDetail(TOBPiece, 'GP_ESCOMPTE', GP_ESCOMPTE.Value);
  GP_REMISEPIED.Value := TOBTiers.GetValue('T_REMISE');
  PutValueDetail(TOBPiece, 'GP_REMISEPIED', GP_REMISEPIED.Value);
  GP_MODEREGLE.Value := TOBTiers.GetValue('T_MODEREGLE');
  GP_REGIMETAXE.Value := TOBTiers.GetValue('T_REGIMETVA');
  if (GP_REPRESENTANT.Text = '') or (TOBPiece.Detail.Count = 0) then
  begin
    if TOBTiers.FieldExists('T_REPRESENTANT') then CodeRepres := TOBTiers.GetValue('T_REPRESENTANT') else CodeRepres := '';
    if CodeRepres <> '' then GP_REPRESENTANT.Text := CodeRepres else GP_REPRESENTANT.Text := ChoixCommercial(TypeCom, TOBTiers.GetValue('T_ZONECOM'));
  end;
  if ((TOBPiece.Detail.Count <= 0) and (Action = taCreat)) then
  begin
    GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
    CodeD := TOBTiers.GetValue('T_DEVISE');
    if ((CodeD <> '') and (GP_DEVISE.Values.IndexOf(CodeD) >= 0)) then GP_DEVISE.Value := CodeD;
    if (ctxMode in V_PGI.PGIContexte) then IncidenceMode;
    {JLD 09/03/2001 EtudieColsListe ;}
    EtudieColsListe; // MR 05/.4/2001 rétabli pour modif colonnes si facture TTC
  end;
  {#TVAENC}
  GP_TVAENCAISSEMENT.Value := PositionneExige(TOBTiers);
  TiersVersPiece(TOBTiers, TOBPiece);
  TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece);
  if ((Action = taCreat) and (not DuplicPiece)) then
  begin
    if ForceEuroGC then OkE := True else OkE := (TOBTiers.GetValue('T_EURODEFAUT') = 'X');
    CodeD := GP_DEVISE.Value;
    OkOut := ((CodeD <> '') and (CodeD <> V_PGI.DevisePivot) and (CodeD <> V_PGI.DeviseFongible) and (not EstMonnaieIn(CodeD)));
    if OkOut then
    begin
      PopD.Items[2].Checked := True;
    end else if OkE then
    begin
      if VH^.TenueEuro then PopD.Items[0].Checked := True else PopD.Items[1].Checked := True;
      GP_DEVISE.Value := V_PGI.DevisePivot;
    end else if GP_DEVISE.Value = V_PGI.DevisePivot then
    begin
      if VH^.TenueEuro then
      begin
        PopD.Items[1].Checked := True;
      end else
      begin
        PopD.Items[0].Checked := True;
      end;
      if not GeneCharge then AfficheEuro;
    end;
  end;
  {Ecran}
  TOBPiece.GetEcran(Self);
end;

{==============================================================================================}
{=============================== Manipulation des divers ======================================}
{==============================================================================================}

procedure TFFacture.TraiteLesDivers(ACol, ARow: integer);
var TOBL: TOB;
  VV: Variant;
  ColName, St, Typ: string;
  j: integer;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  ColName := IdentCols[ACol].ColName;
  if ColName = '' then Exit;
  j := TOBL.GetNumChamp(ColName);
  if j < 0 then Exit;
  St := GS.Cells[ACol, ARow];
  Typ := IdentCols[ACol].ColTyp;
  if (Typ = 'INTEGER') or (Typ = 'SMALLINT') then Vv := ValeurI(St) else
    if (Typ = 'DOUBLE') or (Typ = 'RATE') then Vv := Valeur(St) else
    if Typ = 'DATE' then Vv := StrToDate(St) else
    if Typ = 'BOOLEAN' then
  begin
    if Uppercase(St) <> 'X' then St := '-';
    Vv := Uppercase(St);
  end
  else Vv := St;
  TOBL.PutValeur(j, Vv);
end;

procedure TFFacture.TraiteLibelle(ARow: integer);
var TOBL: TOB;
  Niv, Ligne: integer;
  TypeL: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  // Modif BTP
  if SaisieTypeAvanc then
  begin
    GS.Cells[Sg_Lib, Arow] := stcellCur;
    exit;
  end;
  if not (IsLigneDetail(nil, TOBL)) then
  begin
    TOBL.PutValue('GL_LIBELLE', GS.Cells[SG_Lib, ARow]);
    TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow);
    Niv := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', ARow);
    if (TypeL = 'DP' + IntToStr(Niv)) then
    begin
      Ligne := Arow + 1;
      while (GetChampLigne(TOBPiece, 'GL_TYPELIGNE', Ligne) <> 'TP' + IntToStr(Niv)) do
      begin
        Ligne := Ligne + 1;
        if (Ligne > GS.RowCount) then break;
      end;
      if (Ligne <= GS.RowCount) then
      begin
        TOBL := GetTOBLigne(TOBPiece, Ligne);
        if (TOBL <> nil) then
        begin
          TOBL.PutValue('GL_LIBELLE', 'Total ' + GetChampLigne(TOBPiece, 'GL_LIBELLE', Arow));
          AfficheLaLigne(Ligne);
          if BArborescence.Down = True then BArborescenceClick(Self);
        end;
      end;
    end;
  end else GS.Cells[Sg_Lib, Arow] := stcellCur;
  // ---
end;

{$IFDEF BTP}

procedure TFFacture.TraitePrixOuvrage(TOBL: TOB; EnHt: boolean; PuFix: double);
var IndiceNomen, i: Integer;
  TobNomen: TOB;
  PURef, PUSaisi: double;
begin
  if EnHt then PuRef := TOBL.GetValue('GL_PUHTDEV')
  else PuRef := TOBL.GetValue('GL_PUTTCDEV');
  IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
  if IndiceNomen > 0 then
  begin
    TOBNomen := TOBOuvrage.Detail[IndiceNomen - 1];

    // boucle pour essayer d'affecter complètement la valeur saisie
    // on fait 5 tentatives maxi
    PuSaisi := PuFix;
    i := 1;
    repeat
      ReajusteMontantOuvrage(TOBNomen, PuRef, PuFix, DEV, EnHt);
      if PuFix = PuSaisi then i := 6
      else
      begin
        PuRef := PuFix;
        PuFix := PuSaisi;
        Inc(i);
      end;
    until (i = 6);

    if EnHt then
    begin
      TOBL.PutValue('GL_PUHTDEV', PuFix);
      TOBL.PutValue('GL_RECALCULER', 'X');
      CalculeLigneHT(TOBL, TOBBases, TOBPiece, DEV.decimale, true);
    end else
    begin
      TOBL.PutValue('GL_PUTTCDEV', PuFix);
      TOBL.PutValue('GL_RECALCULER', 'X');
      CalculeLigneTTC(TOBL, TOBBases, TOBPiece, DEV.decimale, true);
    end;
  end;
end;
{$ENDIF}

procedure TFFacture.TraitePrix(ARow: integer);
var TOBL: TOB;
  PuFix: double;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  // Modif BTP
  if (IsLigneDetail(nil, TOBL)) then
  begin
    GS.Cells[Sg_Px, Arow] := stcellCur;
    exit;
  end;
  PuFix := Valeur(GS.Cells[SG_Px, ARow]);
  if GP_FACTUREHT.Checked then
  begin
    {$IFDEF BTP}
    if (TOBL.getValue('GL_TYPEARTICLE') = 'OUV') and
      (Valeur(GS.Cells[SG_Px, ARow]) <> TOBL.GetValue('GL_PUHTDEV')) then
    begin
      TraitePrixOuvrage(TOBL, True, PuFix);
      GS.cells[SG_px, Arow] := strf00(TOBL.GetValue('GL_PUHTDEV'), DEV.Decimale);
    end else
      {$ENDIF}
      TOBL.PutValue('GL_PUHTDEV', PuFix);
  end else
  begin
    {$IFDEF BTP}
    if (TOBL.getValue('GL_TYPEARTICLE') = 'OUV') and
      (Valeur(GS.Cells[SG_Px, ARow]) <> TOBL.GetValue('GL_PUTTCDEV')) then
    begin
      TraitePrixOuvrage(TOBL, False, PuFix);
      GS.cells[SG_px, Arow] := strf00(TOBL.GetValue('GL_PUTTCDEV'), DEV.Decimale);
    end else
      {$ENDIF}
      TOBL.PutValue('GL_PUTTCDEV', PuFix);
  end;
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPIece.putvalue('GP_RECALCULER', 'X');
end;

procedure TFFacture.TraiteRemise(ARow: integer);
var TOBL: TOB;
  RemL: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RemL := Valeur(GS.Cells[SG_Rem, ARow]);
  if RemL < 0 then RemL := 0 else if RemL > 100.0 then RemL := 100.0;
  TOBL.PutValue('GL_REMISELIGNE', RemL);
  TOBL.PutValue('GL_VALEURREMDEV', 0);
  if RemL = 0 then TOBL.PutValue('GL_TYPEREMISE', '');
  TOBPiece.putvalue('GP_RECALCULER', 'X');
  TOBL.PutValue('GL_RECALCULER', 'X');
end;

procedure TFFacture.TraiteMontantRemise(ACol, ARow: integer);
var TOBL: TOB;
  MontantL, RemL: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBL.PutValue('GL_VALEURREMDEV', Valeur(GS.Cells[ACol, ARow]));
  if GP_FACTUREHT.Checked then MontantL := TOBL.GetValue('GL_MONTANTHTDEV') else MontantL := TOBL.GetValue('GL_MONTANTTTCDEV');
  if MontantL <> 0 then RemL := Arrondi(100.0 * Valeur(GS.Cells[ACol, ARow]) / MontantL, 6) else RemL := 0;
  TOBL.PutValue('GL_REMISELIGNE', RemL);
  if RemL = 0 then
  begin
    TOBL.PutValue('GL_VALEURREMDEV', 0);
    TOBL.PutValue('GL_TOTREMLIGNEDEV', 0);
    TOBL.PutValue('GL_TYPEREMISE', '');
    if SG_RV > 0 then GS.Cells[SG_RV, ARow] := '';
    if SG_RL > 0 then GS.Cells[SG_RL, ARow] := '';
  end;
  TOBPIece.putvalue('GP_RECALCULER', 'X');
  TOBL.PutValue('GL_RECALCULER', 'X');
end;

{$IFDEF MODE} // DEBUT Modif MODE 31/07/2002

procedure TFFacture.TraitePrixNet(ACol, ARow: integer);
var TOBL: TOB;
  QteF, PUDEV, PQ, MontantBrutL, MontantNetL, MtRemL, RemL: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  QteF := TOBL.GetValue('GL_QTEFACT');
  if QteF = 0 then Exit;
  // Calcul du montant brut
  if GP_FACTUREHT.Checked then PUDEV := TOBL.GetValue('GL_PUHTDEV') else PUDEV := TOBL.GetValue('GL_PUTTCDEV'); //if PUDEV=0 then Exit ;
  PQ := TOBL.GetValue('GL_PRIXPOURQTE');
  if PQ <= 0 then
  begin
    PQ := 1.0;
    TOBL.PutValue('GL_PRIXPOURQTE', PQ);
  end;
  MontantBrutL := Arrondi(PUDEV * QteF / PQ, 6);
  // Calcul du montant net
  MontantNetL := Arrondi((Valeur(GS.Cells[ACol, ARow]) * QteF) / PQ, 6);
  if MontantBrutL <> 0 then
  begin
    // Calcul du montant de la remise
    MtRemL := MontantBrutL - MontantNetL;
    // Calcul du pourcentage de remise
    RemL := Arrondi(((MtRemL / MontantBrutL)) * 100.0, 6);
  end else
  begin
    MtRemL := 0;
    RemL := 0;
  end;
  TOBL.PutValue('GL_VALEURREMDEV', MtRemL);
  TOBL.PutValue('GL_REMISELIGNE', RemL);
  if RemL = 0 then
  begin
    TOBL.PutValue('GL_VALEURREMDEV', 0);
    TOBL.PutValue('GL_TOTREMLIGNEDEV', 0);
    TOBL.PutValue('GL_TYPEREMISE', '');
    if SG_RV > 0 then GS.Cells[SG_RV, ARow] := '';
    if SG_RL > 0 then GS.Cells[SG_RL, ARow] := '';
  end;
  if PUDEV = 0 then
  begin
    PUDEV := Valeur(GS.Cells[ACol, ARow]);
    if GP_FACTUREHT.Checked then TOBL.PutValue('GL_PUHTDEV', PUDEV) else TOBL.PutValue('GL_PUTTCDEV', PUDEV);
  end;
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPIece.putvalue('GP_RECALCULER', 'X');
end;
{$ENDIF}

{$IFDEF MODE}

procedure TFFacture.TraiteMontantNetLigne(ACol, ARow: integer);
var TOBL: TOB;
  QteF, PUDEV, PQ, MontantBrutL, MontantNetL, MtRemL, RemL: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  QteF := TOBL.GetValue('GL_QTEFACT');
  if QteF = 0 then Exit;
  // Calcul du montant brut
  if GP_FACTUREHT.Checked then PUDEV := TOBL.GetValue('GL_PUHTDEV') else PUDEV := TOBL.GetValue('GL_PUTTCDEV');
  if PUDEV = 0 then Exit;
  PQ := TOBL.GetValue('GL_PRIXPOURQTE');
  if PQ <= 0 then
  begin
    PQ := 1.0;
    TOBL.PutValue('GL_PRIXPOURQTE', PQ);
  end;
  MontantBrutL := Arrondi(PUDEV * QteF / PQ, 6);
  // Calcul du montant de la remise
  MtRemL := MontantBrutL - Valeur(GS.Cells[ACol, ARow]);
  // Calcul du montant net
  MontantNetL := MontantBrutL - MtRemL;
  // Calcul du pourcentage de remise
  if MontantBrutL <> 0 then RemL := Arrondi((1.0 - (MontantNetL / MontantBrutL)) * 100.0, 6) else RemL := 0;
  TOBL.PutValue('GL_VALEURREMDEV', MtRemL);
  TOBL.PutValue('GL_REMISELIGNE', RemL);
  if RemL = 0 then
  begin
    TOBL.PutValue('GL_VALEURREMDEV', 0);
    TOBL.PutValue('GL_TOTREMLIGNEDEV', 0);
    TOBL.PutValue('GL_TYPEREMISE', '');
    if SG_RV > 0 then GS.Cells[SG_RV, ARow] := '';
    if SG_RL > 0 then GS.Cells[SG_RL, ARow] := '';
  end;
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPIece.putvalue('GP_RECALCULER', 'X');
end;
{$ENDIF} // FIN Modif MODE 31/07/2002

procedure TFFacture.TraiteDateLiv(ACol, ARow: integer);
var TOBL: TOB;
  DateLiv: TDateTime;
  i: Integer;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  DateLiv := StrToDate(GS.Cells[SG_DATELIV, AROW]);
  if TOBL.GetValue('GL_TYPEDIM') <> 'GEN' then
  begin
    TOBL.PutValue('GL_DATELIVRAISON', DateLiv);
  end else
  begin
    TOBL.PutValue('GL_DATELIVRAISON', DateLiv);
    i := ARow;
    TOBL := TOBPiece.Detail[i];
    while TOBL.GetValue('GL_TYPEDIM') = 'DIM' do
    begin
      TOBL.PutValue('GL_DATELIVRAISON', DateLiv);
      i := i + 1;
      if i > TOBPiece.Detail.Count - 1 then break;
      TOBL := TOBPiece.Detail[i];
    end;
  end;
end;
// DEBUT AJOUT CHR
{$IFDEF CHR}

procedure TFFacture.TraiteDateProd(ACol, ARow: integer; var cancel: boolean);
var DateProd: TDateTime;
  TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  DateProd := StrToDate(GS.Cells[Sg_DateProd, AROW]);

  if (DateProd < TOBPiece.GetValue('GP_DATELIVRAISON')) then
  begin
    GS.Cells[Sg_DateProd, AROW] := datetostr(TOBPiece.GetValue('GP_DATELIVRAISON'));
    Cancel := True;
  end
  else
  begin
    TOBL.PutValue('GL_DATEPRODUCTION', DateProd);
    Cancel := False;
  end;
end;

procedure TFFacture.TraiteRegroupe(ACol, ARow: integer; var cancel: boolean);
var TOBL, TobResultat: TOB;
  regrpe, regroupeligne: string;
  Qgrp: TQuery;
  r: integer;
begin
  Cancel := False;
  regrpe := GS.Cells[Sg_Regrpe, AROW];
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if not TOBL.FieldExists('(REGROUPEMENT)') then
    TOBL.AddChampSup('(REGROUPEMENT)', False);
  if TOBL <> nil then
  begin
    // faire la fonction de controle
    if regrpe = '' then
    begin
      TOBL.PutValue('(REGROUPEMENT)', '');
      TOBL.PutValue('GL_REGROUPELIGNE', '');
      GS.Cells[Sg_Regrpe + 1, AROW] := ''
    end
    else
    begin
      if (TobRegrpe = nil) then LoadlesTobChr;
      TobResultat := TobRegrpe.findFirst(['HGP_REGROUPELIGNE'], [regrpe], True);
      if TobResultat = nil then
      begin
        TOBL.PutValue('(REGROUPEMENT)', '');
        TOBL.PutValue('GL_REGROUPELIGNE', '');
        GS.Cells[Sg_Regrpe + 1, AROW] := '';
        Cancel := True;
      end
      else
      begin
        Qgrp := OpenSQL('Select GA_CODEARTICLE, GA_LISTEREGROUPE from ARTICLE Where GA_CODEARTICLE="' + TOBL.GetValue('GL_CODEARTICLE') + '"', True);
        if (not Qgrp.eof) then
        begin
          Regroupeligne := Qgrp.findField('GA_LISTEREGROUPE').AsString;
        end;
        if Qgrp <> nil then Ferme(Qgrp);
        r := pos(GS.Cells[Sg_Regrpe, AROW], Regroupeligne);
        if (Regroupeligne <> TraduireMemoire('<<Tous>>')) and (r = 0) then
        begin
          HShowMessage('0;Regroupement incorrect;Il n''appartient pas à la liste des regroupements de la prestation;E;O;O;O;', '', '');
          GS.Cells[Sg_Regrpe + 1, AROW] := '';
          Cancel := True;
        end else
        begin
          TOBL.PutValue('GL_REGROUPELIGNE', regrpe);
          TOBL.PutValue('(REGROUPEMENT)', TobResultat.GetValue('HGP_ABREGE'));
          GS.Cells[Sg_Regrpe + 1, AROW] := TobResultat.GetValue('HGP_ABREGE');
        end;
      end;
    end;
  end;
end;
{$ENDIF}
// FIN AJOUT CHR

{==============================================================================================}
{=============================== Manipulation des Qtés ========================================}
{==============================================================================================}

procedure TFFacture.DeflagTarif(ARow: integer);
var TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBL.PutValue('RECALCULTARIF', '-');
end;

function TFFacture.TraiteRupture(ARow: integer): boolean;
var TOBL, TOBA, TOBD, TOBLiee, TOBCata: TOB;
  Depot, OldNat, ColPlus, ColMoins, ArtSub, sComp, CalcRupture: string;
  QteSais, QteDisp, RatioVA, QteAdd, RatioAdd: Double;
  AddQ, AnnuArt: Boolean;
begin
  Result := True;
  if Action = taConsult then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  CalcRupture := CalcRupt;
  if ((TOBL.GetValue('GL_ENCONTREMARQUE') = 'X') and
    (GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_VENTEACHAT') <> 'ACH')) then
  begin
    ColPlus := GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_QTEMOINS');
    if ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0)) then CalcRupture := 'PHY' else CalcRupture := '';
  end;
  if ((CalcRupture = '') or (CalcRupture = 'AUC')) then Exit;
  if (ctxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM') = 'DIM') then exit;
  if (TOBL.GetValue('GL_ARTICLE') = '') and (TOBL.GetValue('GL_REFCATALOGUE') = '') then Exit;
  QteSais := TOBL.GetValue('GL_QTESTOCK');
  if QteSais <= 0 then Exit;
  if (TOBL.GetValue('GL_TENUESTOCK') <> 'X') and (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X') then Exit;
  Depot := TOBL.GetValue('GL_DEPOT');
  if Depot = '' then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  TOBCata := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
  if (TOBA = nil) and (TOBCata = nil) then Exit;
  if (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X') then
    TOBD := TOBA.FindFirst(['GQ_DEPOT'], [Depot], False)
  else
    TOBD := TOBCata.FindFirst(['GQC_DEPOT'], [Depot], False);
  RatioAdd := 1;
  RatioVA := GetRatio(TOBL, nil, trsStock);
  if RatioVA = 0 then RatioVA := 1;
  if TOBD = nil then
  begin
    QteDisp := 0;
    QteAdd := 0;
  end else
  begin
    if (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X') then
    begin
      QteDisp := TOBD.GetValue('GQ_PHYSIQUE');
      AddQ := False;
      QteAdd := 0;
      if CalcRupt = 'DIS' then QteDisp := QteDisp - TOBD.GetValue('GQ_RESERVECLI') - TOBD.GetValue('GQ_PREPACLI');
    end else
    begin
      QteDisp := TOBD.GetValue('GQC_PHYSIQUE');
      AddQ := False;
      QteAdd := 0;
      //QteDisp:=QteDisp-TOBD.GetValue('GQC_RESERVECLI')-TOBD.GetValue('GQC_PREPACLI') ;
      QteDisp := QteDisp - TOBD.GetValue('GQC_PREPACLI');
    end;
    // Cas particulier rappel de pièce
    if ((Action = taModif) and (not DuplicPiece)) then
    begin
      OldNat := TOBPiece_O.GetValue('GP_NATUREPIECEG');
      ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
      ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
      if ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0)) then AddQ := True;
      if ((CalcRupt = 'DIS') or (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X') or (not TransfoPiece)) then
      begin
        if ((Pos('RC', ColPlus) > 0) or (Pos('RC', ColMoins) > 0)) then AddQ := True;
        if ((Pos('PRE', ColPlus) > 0) or (Pos('PRE', ColMoins) > 0)) then AddQ := True;
      end;
      if AddQ then
      begin
        if TransfoPiece then
        begin
          TOBLiee := GetTOBPrec(TOBL, TOBPiece_O);
          if TOBLiee <> nil then
          begin
            QteAdd := TOBLiee.GetValue('GL_QTESTOCK');
            RatioAdd := GetRatio(TOBLiee, nil, trsStock);
            if RatioAdd = 0 then RatioAdd := 1;
          end;
        end else
        begin
          if TOBL.FieldExists('QTEORIG') then QteAdd := TOBL.GetValue('QTEORIG');
          RatioAdd := RatioVA;
        end;
      end;
    end;
  end;
  QteSais := (QteSais / RatioVA) - (QteAdd / RatioAdd);
  if QteSais <= QteDisp then Exit;
  if (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X') then
    ArtSub := Trim(Copy(TOBA.GetValue('GA_SUBSTITUTION'), 1, 18))
  else ArtSub := '';
  if ArtSub <> '' then sComp := HTitres.Mess[17] + ' ' + ArtSub + ')' else sComp := '';
  AnnuArt := True;
  if ((ForceRupt) and (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X')) then
  begin
    if HPiece.Execute(10, caption, sComp) = mrYes then AnnuArt := False;
  end else
  begin
    HPiece.Execute(11, caption, sComp);
  end;
  if AnnuArt then Result := False;
end;

function TFFacture.AutoriseQteNegative(ACol, ARow: integer; Qte: Double): boolean;
begin
  Result := True;
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
  begin
    if Qte < 0 then
    begin
      HPiece.Execute(42, Caption, '');
      GS.Cells[ACol, ARow] := FloatToStr(-Qte);
      Result := False;
    end;
  end;
end;

// Modif BTP

function TFFacture.TraiteAvanc(ACol, ARow: integer): Boolean;
var TOBL: TOB;
  Qte, Qtepre, Pourcentage: Double;
begin
  Result := True;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  Qte := Valeur(GS.Cells[SG_QA, ARow]);
  Pourcentage := Valeur(GS.Cells[SG_Pct, ARow]);
  Qtepre := TOBL.GetValue('GL_QTEFACT');
  if Qtepre > 0 then
  begin
    if (ACol = SG_QA) then Pourcentage := Qte / Qtepre * 100
    else Qte := Qtepre * Pourcentage / 100;
  end else
  begin
    if (ACol = SG_QA) then Pourcentage := 0
    else Qte := 0;
  end;
  TOBL.PutValue('GL_QTEPREVAVANC', Qte);
  TOBL.PutValue('GL_POURCENTAVANC', Pourcentage);
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPIECE.PutValue('GP_RECALCULER', 'X'); // permet de relancer le calcul global de la pièce
end;

function TFFacture.TraiteQte(ACol, ARow: integer): Boolean;
var TOBL, TOBA, TOBLiee: TOB;
  NewQte, Qte, PCB, X, OldQte, Ecart: Double;
  Neg, OkCond: boolean;
  RefUnique: string;
begin
  Result := True;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  Qte := Valeur(GS.Cells[ACol, ARow]);
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if not AutoriseQteNegative(ACol, ARow, Qte) then exit;
  if (Action = taModif) and (not DuplicPiece) and (ACol = SG_QF) then { NEWPIECE }
  begin
    { Lors de la modification d'une pièce, empèche que la nouvelle quantité saisie soit inférieure au total des quantités
      des lignes. (Par exemple la quantité commandée ne peut-être inférieure au total des quantités livrées) }
    if not VerifQuantitePieceSuivante(TobL, Qte) then
    begin
      HPiece.Execute(51, Caption, '');
      AfficheLaLigne(ARow);
      EXIT;
    end;
  end;
  // Conditionnement
  OkCond := AdapteCond(TOBL, TOBConds, Qte);
  if OkCond then
  begin
    GS.Cells[ACol, ARow] := StrF00(Qte, 10);
    FormateZoneSaisie(ACol, ARow);
  end else
  begin
    // Prix par combien
    PCB := TOBL.GetValue('GL_PCB');
    if ((PCB <> 0) and (Qte <> 0) and (VenteAchat = 'VEN')) then
    begin
      Neg := (Qte < 0);
      Qte := Abs(Qte);
      X := Arrondi(Qte / PCB, 9);
      if Arrondi(X - Trunc(X), 6) <> 0 then
      begin
        X := Arrondi(X + 0.5, 0);
        X := X * PCB;
        if Neg then X := -X;
        Qte := X;
        GS.Cells[ACol, ARow] := StrF00(Qte, 10);
        FormateZoneSaisie(ACol, ARow);
        TOBPIece.putvalue('GP_RECALCULER', 'X');
        TOBL.PutValue('GL_RECALCULER', 'X');
      end;
    end;
  end;
  if ACol = SG_QF then
  begin
    { NEWPIECE }
    OldQte := TOBL.GetValue('GL_QTEFACT');
    TOBL.PutValue('GL_QTEFACT', Valeur(GS.Cells[ACol, ARow]));
    if SG_QS < 0 then TOBL.PutValue('GL_QTESTOCK', Valeur(GS.Cells[ACol, ARow]));
    NewQte := TobL.GetValue('GL_QTEFACT');
    if OldQte <> NewQte then
    begin
      TOBL.PutValue('GL_QTERESTE', TOBL.GetValue('GL_QTERESTE') - OldQte + NewQte);
      PutQteReliquat(Tobl, OldQte);
    end;
    if TOBL.GetValue('RECALCULTARIF') = 'X' then
    begin
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
      TarifVersLigne(TOBA, TOBTiers, TOBL, TOBPiece, TOBTarif, True, True, DEV);
      AfficheLaLigne(ARow);
    end;
    TOBPIece.putvalue('GP_RECALCULER', 'X');
    TOBL.PutValue('GL_RECALCULER', 'X');
    {$IFDEF BTP}
    // Recalculs pour une situation ou une facture directe :
    if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') or
      (TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC')) and
      (TOBPiece.GetValue('GP_AFFAIREDEVIS') <> '') then
    begin
      // recalcul qté cumulée
      NewQte := Valeur(GS.Cells[ACol, ARow]);
      Qte := TOBL.GetValue('GL_QTESIT') - OldQte;
      TOBL.PutValue('GL_QTESIT', Qte + NewQte);
      // recalcul % avancement cumulé ou % de facturation
      OldQte := TOBL.GetValue('GL_QTEPREVAVANC');
      if OldQte <> 0 then
        X := ((Qte + NewQte) / OldQte) * 100
      else
        X := 0;
      TOBL.PutValue('GL_POURCENTAVANC', X);
    end;
    {$ENDIF}
  end else
  begin
    TOBL.PutValue('GL_QTESTOCK', Valeur(GS.Cells[ACol, ARow]));
    if SG_QF < 0 then TOBL.PutValue('GL_QTEFACT', Valeur(GS.Cells[ACol, ARow]));
    TOBPIece.putvalue('GP_RECALCULER', 'X');
    TOBL.PutValue('GL_RECALCULER', 'X');
  end;
  {$IFDEF GPAO}
  {GPAO V1.0 permet de recalculer le tarif à chaque changement de quantité}
  if ((ACol = SG_QF) or (SG_QF < 0)) and (not GetParamSoc('SO_WPREFSYSTTARIF')) then TOBL.PutValue('RECALCULTARIF', '-');
  {$ELSE}
  if ((ACol = SG_QF) or (SG_QF < 0)) then TOBL.PutValue('RECALCULTARIF', '-');
  {$ENDIF}
  if ReliquatTransfo then
  begin
    TOBLiee := GetTOBPrec(TOBL, TOBPiece_O);
    if TOBLiee <> nil then
    begin
      NewQte := TOBL.GetValue('GL_QTESTOCK');
      OldQte := TOBLiee.GetValue('GL_QTESTOCK');
      if OldQte > NewQte then Ecart := OldQte - NewQte else Ecart := 0;
      TOBL.PutValue('GL_QTERELIQUAT', Ecart);
      TOBPIece.putvalue('GP_RECALCULER', 'X');
      TOBL.PutValue('GL_RECALCULER', 'X');
    end;
  end;
  if not TraiteRupture(ARow) then
  begin
    if SG_QF >= 0 then GS.Cells[SG_QF, ARow] := '';
    if SG_QS >= 0 then GS.Cells[SG_QS, ARow] := '';
    Result := False;
  end;
  if Result then TOBL.PutValue('QTECHANGE', 'X');
  //if (ctxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM')='DIM') then
  if TOBL.GetValue('GL_TYPEDIM') = 'DIM' then
  begin
    TOBL := TOBPiece.FindFirst(['GL_CODESDIM', 'GL_TYPEDIM'], [TOBL.GetValue('GL_CODEARTICLE'), 'GEN'], False);
    if TOBL <> nil then AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
  end;
end;

{==============================================================================================}
{====================================== DIMENSIONS ============================================}
{==============================================================================================}
// modif 02/08/2001

procedure TFFacture.RemplirTOBDim(CodeArticle: string; Ligne: Integer);
var iLigne, jDim: integer;
  TOBL, TOBD: TOB;
  Q: TQuery;
  QteDejaSaisi, ReliqDejaSaisi: Double;
begin
  TOBDim.ClearDetail;
  ANCIEN_TOBDimDetailCount := 0;
  //iLigne:=0 ;
  Q := OpenSQL('Select GA_Article from Article where GA_CodeArticle="' + CodeArticle + '" AND GA_STATUTART="DIM" order by GA_ARTICLE', True);
  while not Q.EOF do
  begin
    TOBD := TOB.Create('', TOBDim, -1);
    QteDejaSaisi := CalcQteDejaSaisie(TOBPiece, Q.FindField('GA_ARTICLE').AsString);
    ReliqDejaSaisi := CalcQteDejaSaisie(TOBPiece_O, Q.FindField('GA_ARTICLE').AsString);
    InitDim(TOBD, Q.FindField('GA_ARTICLE').AsString, QteDejaSaisi, ReliqDejaSaisi);
    Q.Next;
  end;
  ferme(Q);
  if not NewLigneDim then
  begin
    for jDim := 0 to TOBDim.Detail.Count - 1 do
    begin
      TOBD := TOBDim.Detail[jDim];
      iLigne := Ligne;
      TOBL := TOBPiece.Detail[iLigne];
      while TOBL.GetValue('GL_CODEARTICLE') = CodeArticle do
      begin
        if TOBL.GetValue('GL_ARTICLE') = TOBD.GetValue('GA_ARTICLE') then
        begin
          QteDejaSaisi := CalcQteDejaSaisie(TOBPiece, TOBD.GetValue('GA_ARTICLE'));
          ReliqDejaSaisi := CalcQteDejaSaisie(TOBPiece_O, TOBD.GetValue('GA_ARTICLE'));
          LigneVersDim(TOBL, TOBD, QteDejaSaisi, ReliqDejaSaisi);
          ANCIEN_TOBDimDetailCount := ANCIEN_TOBDimDetailCount + 1;
          Break;
        end else
        begin
          iLigne := iLigne + 1;
          if iLigne > TOBPiece.Detail.Count - 1 then break;
          TOBL := TOBPiece.Detail[iLigne];
        end;
      end;
    end;
  end;
  if not TOBDim.FieldExists('GP_DEVISE') then TOBDim.AddChampSup('GP_DEVISE', False);
  if not TOBDim.FieldExists('GP_TAUXDEV') then TOBDim.AddChampSup('GP_TAUXDEV', False);
  if not TOBDim.FieldExists('GP_SAISIECONTRE') then TOBDim.AddChampSup('GP_SAISIECONTRE', False);
  if not TOBDim.FieldExists('GP_FACTUREHT') then TOBDim.AddChampSup('GP_FACTUREHT', False);
  if not TOBDim.FieldExists('GP_VENTEACHAT') then TOBDim.AddChampSup('GP_VENTEACHAT', False);
  if not TOBDim.FieldExists('GP_NATUREPIECEG') then TOBDim.AddChampSup('GP_NATUREPIECEG', False);
  if not TOBDim.FieldExists('GP_DATEPIECE') then TOBDim.AddChampSup('GP_DATEPIECE', False); // recup tarif
  if not TOBDim.FieldExists('GP_TIERS') then TOBDim.AddChampSup('GP_TIERS', False); // recup tarif achat
  if not TOBDim.FieldExists('GP_TARIFTIERS') then TOBDim.AddChampSup('GP_TARIFTIERS', False); // recup tarif tiers
  TOBDim.PutValue('GP_DEVISE', TOBPiece.GetValue('GP_DEVISE'));
  TOBDim.PutValue('GP_TAUXDEV', TOBPiece.GetValue('GP_TAUXDEV'));
  TOBDim.PutValue('GP_SAISIECONTRE', TOBPiece.GetValue('GP_SAISIECONTRE'));
  TOBDim.PutValue('GP_FACTUREHT', TOBPiece.GetValue('GP_FACTUREHT'));
  TOBDim.PutValue('GP_VENTEACHAT', TOBPiece.GetValue('GP_VENTEACHAT'));
  TOBDim.PutValue('GP_NATUREPIECEG', TOBPiece.GetValue('GP_NATUREPIECEG'));
  TOBDim.PutValue('GP_DATEPIECE', TOBPiece.GetValue('GP_DATEPIECE'));
  TOBDim.PutValue('GP_TIERS', TOBPiece.GetValue('GP_TIERS'));
  TOBDim.PutValue('GP_TARIFTIERS', TOBPiece.GetValue('GP_TARIFTIERS'));
  TheTOB := TOBDim;
end;

procedure TFFacture.AppelleDim(ARow: integer);
var TypeDim, CodeArticle, CodeDepot: string;
  //FindValeur
  TOBL, TOBGEN: TOB;
  LigGen: integer;
begin
  NewLigneDim := False;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TypeDim := TOBL.GetValue('GL_TYPEDIM');
  if ((TypeDim <> 'GEN') and (TypeDim <> 'DIM')) then Exit;
  if TypeDim = 'DIM' then
  begin
    CodeArticle := TOBL.GetValue('GL_CODEARTICLE');
    LigGen := -1;
  end
  else
  begin
    CodeArticle := TOBL.GetValue('GL_CODESDIM');
    LigGen := ARow;
  end;
  if CodeArticle = '' then Exit;
  RemplirTOBDim(CodeArticle, ARow);
  //if SelectMultiDimensions(CodeArticle,GS,TobPiece.GetValue('GP_ETABLISSEMENT'),Action) then TOBDim:=TheTOB else TOBDim.ClearDetail ; //AC
  if (CleDoc.NaturePiece = 'TRE') or (CleDoc.NaturePiece = 'TRV') then
    CodeDepot := TOBPiece.GetValue('GP_DEPOTDEST')
  else CodeDepot := TOBPiece.GetValue('GP_ETABLISSEMENT');
  if SelectMultiDimensions(CodeArticle, GS, CodeDepot, Action) then TOBDim := TheTOB else TOBDim.ClearDetail; //AC+JD
  TheTOB := nil;
  if LigGen < 0 then
  begin
    TOBGEN := TOBPiece.FindFirst(['GL_CODESDIM', 'GL_TYPEDIM'], [CodeArticle, 'GEN'], False);
    if TOBGen = nil then Exit;
    LigGen := TOBGEN.GetValue('GL_NUMLIGNE');
  end;
  TraiteLesDim(LigGen, False);
end;

//modif 02/08/2001

procedure TFFacture.TraiteLesDim(var ARow: integer; NewArt: boolean);
var RefUnique, CodeArticle, LeCom, TypeDim, LibDim, Grille, CodeDim, CodeArrondi, ArtLie: string;
  TOBL, TOBD, TOBA, TOBArt: TOB;
  i, NbD, LaLig, ACol, k, NbDimInsert, j, NbSup, Indice, ifam, NumOrdre: integer;
  Cancel, Premier, OkPxUnique, RemA, ModifLigne: boolean;
  Qte, TotQte, Prix, PrixUnique, TotPrix, Remise, TotRem: Double;
  Marge, MontantHT, MontantTTC, TotalHT, TotalTTC, QteReliq: Double; //MAJ Ligne GEN
  TOBItem, TobTemp, TobTempArt, TobTempArtDim, TobDispo, TobDispoArt, TobCond: TOB;
  QArticle, QDispo, QCond: TQuery;
  RefGen, OldRefPrec, StQuelDepot: string;
  FamilleTaxe: array[1..5] of string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (TOBDim.Detail.Count <= 0) and (TOBDim.FieldExists('ANNULE')) then
  begin
    TOBDim.DelChampSup('ANNULE', False);
    exit;
  end; //saisie dim annulé
  // Evite d'exectuter n fois les requêtes
  RefGen := TOBL.GetValue('GL_CODEARTICLE');
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefGen = '' then RefGen := TOBL.GetValue('GL_CODESDIM');
  if RefUnique = '' then RefUnique := CodeArticleUnique2(RefGen, '');
  TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
  if ((TOBArt = nil) or (TOBArt.GetValue('GA_STATUTART') = 'GEN')) then
  begin
    if ExisteSQL('SELECT GAL_ARTICLE FROM ARTICLELIE WHERE GAL_TYPELIENART="LIE" AND GAL_ARTICLE="' + RefGen + '"') then
      ArtLie := 'X' else ArtLie := '-';
    QArticle := OpenSQL('Select * from Article where GA_CODEARTICLE="' + RefGen + '" AND GA_STATUTART ="DIM"', True);
    //JD : Chargement de tous les dépôts en multi-dépôts sinon chargement du dépôt courant
    // et si transfert, chargement du dépôt récepteur en plus du dépôt émetteur
    StQuelDepot := CreerQuelDepot(TOBPiece);
    if StQuelDepot <> '' then StQuelDepot := ' AND GQ_DEPOT IN (' + StQuelDepot + ')';
    QDispo := OpenSQL('Select * from Dispo where GQ_ARTICLE like "' + Copy(RefUnique, 1, 18) + '%" ' +
      'AND GQ_CLOTURE="-"' + StQuelDepot, True);
    QCond := OpenSQL('SELECT * FROM CONDITIONNEMENT WHERE GCO_ARTICLE="' + Copy(RefUnique, 1, 18) + '%" ORDER BY GCO_NBARTICLE', True);
    TobTempArt := nil;
    TobTempArtDim := nil;
    TobDispo := nil;
    if not QArticle.EOF then
    begin
      TobTempArt := TOB.Create('LesArticles', nil, -1);
      TobTempArt.LoadDetailDB('ARTICLE', '', '', QArticle, False);
    end;
    if not QDispo.EOF then
    begin
      TobDispo := TOB.Create('', nil, -1);
      TobDispo.LoadDetailDB('DISPO', '', '', QDispo, False);
    end;
    if not QCond.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', QCond, True, False);
    for i := 0 to TOBDim.Detail.Count - 1 do
    begin
      TOBItem := TOBDim.Detail[i];
      if TOBItem = nil then exit;
      RefUnique := TOBItem.GetValue('GA_ARTICLE');
      if TobTempArt <> nil then TobTempArtDim := TobTempArt.FindFirst(['GA_ARTICLE'], [RefUnique], False);
      if (TobTempArtDim <> nil) and (TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False) = nil) then
      begin
        TobTempArtDim.AddChampSupValeur('REFARTBARRE', '', False);
        TobTempArtDim.AddChampSupValeur('REFARTTIERS', '', False);
        TobTempArtDim.AddChampSupValeur('REFARTSAISIE', '', False);
        TobTempArtDim.AddChampSupValeur('UTILISE', '-', False);
        TobTempArtDim.Changeparent(TOBArticles, -1);
        //if TobDispo<>nil then TobDispoArt:=TobDispo.FindFirst(['GQ_ARTICLE'],[RefUnique],False) ;
        if TobTempArtDim.FindFirst(['GQ_ARTICLE'], [RefUnique], False) = nil then
        begin
          if TobDispo <> nil then
          begin
            TobDispoArt := TobDispo.FindFirst(['GQ_ARTICLE'], [RefUnique], False);
            while TobDispoArt <> nil do
            begin
              TobDispoArt.Changeparent(TobTempArtDim, -1);
              TobDispoArt := TobDispo.FindNext(['GQ_ARTICLE'], [RefUnique], False);
            end;
          end;
        end;
      end;
    end;
    Ferme(QArticle);
    Ferme(QDispo);
    Ferme(QCond);
    TobTempArt.Free; //TobTempArt:=nil ;
    TobDispo.Free; //TobDispo:=nil ;
    //$IFNDEF EAGLCLIENT fonction en CWAS 07/03/2003
    DispoChampSupp(TOBArticles);
    //$ENDIF
  end;

  ////////////////////////////////////////////////////
  if NewArt then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
    if TOBA = nil then Exit;
    if TOBA.GetValue('GA_STATUTART') <> 'GEN' then Exit;
    CodeArticle := TOBL.GetValue('GL_CODEARTICLE');
    RemA := (TOBA.GetValue('GA_REMISELIGNE') = 'X');
  end else
  begin
    RemA := False;
    TypeDim := TOBL.GetValue('GL_TYPEDIM');
    if ((TypeDim <> 'GEN') and (TypeDim <> 'DIM')) then Exit;
    if TypeDim = 'GEN' then
    begin
      CodeArticle := TOBL.GetValue('GL_CODESDIM');
      TOBA := TOBArticles.FindFirst(['GA_ARTICLE'], [CodeArticleUnique2(CodeArticle, '')], False);
      if TOBA <> nil then RemA := (TOBA.GetValue('GA_REMISELIGNE') = 'X');
    end;
    if TypeDim = 'DIM' then CodeArticle := TOBL.GetValue('GL_CODEARTICLE');
  end;
  if CodeArticle = '' then Exit;
  if TransfoPiece then
  begin
    if TOBDim.Detail.Count = 0 then MAJLigneDim(ARow) //Génération de pièce en aveugle
    else ReconstruireTobDim(ARow);
  end else
  begin
    if (ANCIEN_TOBDimDetailCount <> 0) then NbSup := SupDimAZero(GS, CodeArticle, TOBDim, TOBPiece, ARow) else NbSup := 0; // Supprime si QTE=0 dans THDim
    if TOBDim.Detail.Count = 0 then
    begin
      CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, ARow);
      exit;
    end;
  end;
  NbD := TOBDim.Detail.Count - (ANCIEN_TOBDimDetailCount - NbSup); //ac
  NbDimInsert := NbD;
  GS.RowCount := GS.RowCount + NbD;
  CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TOBPiece.Detail.Count + NbD);
  //NbD:=0 ;
  TotQte := 0;
  Premier := True;
  OkPxUnique := True;
  TotPrix := 0;
  Remise := 0; //TotRem:=0 ;
  for ifam := 1 to 5 do FamilleTaxe[ifam] := '.';
  PrixUnique := 0;
  for i := 0 to TOBDim.Detail.Count - 1 do
  begin
    TOBD := TOBDim.Detail[i]; //Qte:=0 ;
    {Infos depuis TOBDim}
    RefUnique := TOBD.GetValue('GA_ARTICLE');
    CodeArticle := Trim(Copy(RefUnique, 1, 18));
    Qte := Arrondi(TOBD.GetValue('GL_QTEFACT'), 6); //if Qte=0 then Continue ;
    CodeArrondi := TOBD.GetValue('GL_CODEARRONDI');
    if RemA then Remise := Valeur(TOBD.GetValue('GL_REMISELIGNE')); //Si remiseligne autorisé sur l'article
    //trf
    if TOBPiece.GetValue('GP_NATUREPIECEG') = 'TEM' then Prix := TOBD.GetValue('GL_PUHTDEV')
      //fin trf
    else if GP_FACTUREHT.Checked then Prix := TOBD.GetValue('GL_PUHTDEV') else Prix := TOBD.GetValue('GL_PUTTCDEV');
    for J := ARow to ARow + TOBDim.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[j];
      if TOBL.GetValue('GL_ARTICLE') = RefUnique then Break
      else TOBL := nil;
    end;
    if TOBL <> nil then
    begin
      {Modification ligne}
      LaLig := j + 1;
      if SG_QF >= 0 then
      begin
        GS.Cells[SG_QF, LaLig] := FloatToStr(Qte);
        TraiteQte(SG_QF, LaLig);
      end;
      if SG_QS >= 0 then
      begin
        GS.Cells[SG_QS, LaLig] := FloatToStr(Qte);
        TraiteQte(SG_QS, LaLig);
      end;
    end else
    begin
      {Insertion nouvelle ligne}
      NbD := i;
      Inc(NbD);
      LaLig := ARow + NbD;
      GS.Cells[SG_RefArt, LaLig] := RefUnique;
      ACol := SG_RefArt;
      Cancel := False;
      if (NbDimInsert > 0) and (ARow < TobPiece.Detail.Count) then
      begin
        InsertTOBLigne(TOBPiece, Lalig);
        TOBPiece.Detail[TobPiece.Detail.count - 1].Free;
        GS.DeleteRow(TobPiece.Detail.count + 1);
        NbDimInsert := NbDimInsert - 1;
        GS.RowCount := GS.RowCount + 1;
      end;
      TraiteArticle(ACol, LaLig, Cancel, True, False, Qte);
      if Cancel then Continue;
      GS.Cells[SG_RefArt, LaLig] := CodeArticle;
    end;
    TOBL := GetTOBLigne(TOBPiece, LaLig);
    TOBL.PutValue('GL_TYPEDIM', 'DIM');
    TOBL.PutValue('GL_QTEFACT', Qte);
    TOBL.PutValue('GL_QTESTOCK', Qte); { NEWPIECE }
    TOBL.PutValue('GL_CODEARRONDI', CodeArrondi);
    TOBL.PutValue('ARTSLIES', ArtLie);
    if RemA then TOBL.PutValue('GL_REMISELIGNE', Remise); //Si remiseligne autorisé sur l'article
    if GP_FACTUREHT.Checked then TOBL.PutValue('GL_PUHTDEV', Prix) else TOBL.PutValue('GL_PUTTCDEV', Prix);
    AfficheLaLigne(LaLig);
    TotQte := TotQte + Qte;
    TotPrix := Arrondi(TotPrix + Qte * Prix, DEV.Decimale); //TotRem:=TotRem+Remise;
    if Premier then PrixUnique := Prix else if Prix <> PrixUnique then OkPxUnique := False;
    for ifam := 1 to 5 do
    begin
      if (FamilleTaxe[ifam] <> TOBL.GetValue('GL_FAMILLETAXE' + IntToStr(ifam))) and (FamilleTaxe[ifam] <> '.') then FamilleTaxe[ifam] := ''
      else FamilleTaxe[ifam] := TOBL.GetValue('GL_FAMILLETAXE' + IntToStr(ifam));
    end;
    Premier := False;
  end;
  TOBPiece.Putvalue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, False);
  {Article générique passe en commentaire}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  LeCom := TOBL.GetValue('GL_LIBELLE');
  OldRefPrec := TOBL.GetValue('GL_PIECEPRECEDENTE');
  { NEWPIECE : Sauvegarde du numéro d'ordre de la ligne générique }
  NumOrdre := TOBL.GetValue('GL_NUMORDRE');
  ClickDel(ARow, True, False);
  ClickInsert(ARow);
  TOBL := GetTOBLigne(TOBPiece, ARow);
  TOBL.PutValue('GL_LIBELLE', LeCom);
  TOBL.PutValue('GL_PIECEPRECEDENTE', OldRefPrec);
  { NEWPIECE : Restauration du numéro d'ordre de la ligne générique }
  TOBL.PutValue('GL_NUMORDRE', NumOrdre);
  TOBL.PutValue('GL_TYPEDIM', 'GEN');
  TOBL.PutValue('GL_TYPELIGNE', 'COM');
  TOBL.PutValue('GL_QTEFACT', TotQte);
  TOBL.PutValue('GL_QTESTOCK', TotQte);
  TOBL.PutValue('GL_CODESDIM', CodeArticle);
  TOBL.PutValue('GL_CODEARRONDI', CodeArrondi);
  // pour InfoLignes
  TOBL.PutValue('GL_DATELIVRAISON', TobPiece.GetValue('GP_DATELIVRAISON'));
  TOBL.PutValue('GL_REFARTSAISIE', CodeArticle);
  //////////////////
  if not OkPxUnique then
  begin
    if ((ctxMode in V_PGI.PGIContexte) and (TotQte <> 0)) then PrixUnique := Arrondi(TotPrix / TotQte, DEV.Decimale);
  end;
  if GP_FACTUREHT.Checked then TOBL.PutValue('GL_PUHTDEV', PrixUnique) else TOBL.PutValue('GL_PUTTCDEV', PrixUnique);
  TobTemp := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
  if TobTemp <> nil then
  begin
    TOBL.PutValue('GL_QUALIFQTEVTE', TobTemp.GetValue('GA_QUALIFUNITEVTE'));
    if TobTemp.FieldExists('GCA_QUALIFUNITEACH') then TOBL.PutValue('GL_QUALIFQTEACH', TobTemp.GetValue('GCA_QUALIFUNITEACH'));
    TOBL.PutValue('GL_QUALIFQTESTO', TobTemp.GetValue('GA_QUALIFUNITESTO'));
    TOBL.PutValue('GL_FOURNISSEUR', TobTemp.GetValue('GA_FOURNPRINC'));
  end;
  for ifam := 1 to 5 do TOBL.PutValue('GL_FAMILLETAXE' + IntToStr(ifam), FamilleTaxe[ifam]);
  {Rebalayage des lignes dimensionnées}
  GS.RowHeights[TOBPiece.Detail.Count + 1] := GS.DefaultRowHeight;
  AffichageDim;
  TOBDim.ClearDetail;
end;

//modif 02/08/2001

procedure TFFacture.AffichageDim; // Pour gérer l'affichage par rapport à DimSaisie
var TOBA, TOBL: Tob;
  Grille, CodeDim, LibDim, LibGen: string;
  k, i: integer;
begin
  GS.RowCount := GS.RowCount + TOBPiece.Detail.count;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    if DimSaisie = 'GEN' then GS.RowHeights[i + 1] := GS.DefaultRowHeight;
    TOBL := TOBPiece.Detail[i]; //if TOBL.GetValue('GL_CODEARTICLE')<>CodeArticle then Continue ;
    if TOBL.GetValue('GL_TYPEDIM') = 'DIM' then
    begin
      if DimSaisie = 'GEN' then GS.RowHeights[i + 1] := 0;
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
      if (TOBL.GetValue('GL_LIBELLE') = LibGen) then
      begin
        if TOBA <> nil then for k := 1 to 5 do
          begin
            Grille := TOBA.GetValue('GA_GRILLEDIM' + IntToStr(k));
            CodeDim := TOBA.GetValue('GA_CODEDIM' + IntToStr(k));
            if (Grille <> '') and (CodeDim <> '') then //and (TOBL.GetValue('GL_LIBELLE')=LibGen)) then
            begin
              if TOBL.GetValue('GL_LIBELLE') = LibGen then
                LibDim := RechDom('GCGRILLEDIM' + IntToStr(k), Grille, True) + ' ' + GCGetCodeDim(Grille, CodeDim, k)
              else LibDim := GCGetCodeDim(Grille, CodeDim, k);
              LibDim := Copy(TOBL.GetValue('GL_LIBELLE') + '  ' + LibDim, 1, 70);
              TOBL.PutValue('GL_LIBELLE', LibDim);
            end;
          end;
      end;
    end else
    begin
      LibGen := TOBL.GetValue('GL_LIBELLE');
      if (DimSaisie = 'DIM') and (TOBL.GetValue('GL_TYPEDIM') = 'GEN') then GS.RowHeights[i + 1] := 0;
    end;
    AfficheLaLigne(i + 1);
  end;
end;

procedure TFFacture.IncidenceMode;
var TypeFacturation: string;
begin
  TypeFacturation := GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_TYPEFACT');
  if TypeFacturation = 'HT' then GP_FACTUREHT.Checked := True
  else if TypeFacturation = 'TTC' then GP_FACTUREHT.Checked := False
  else GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
end;

procedure TFFacture.CodesCataToCodesLigne(TOBCata, TOBArt: TOB; ArticleRef: string; ARow: integer);
var TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  TOBL.InitValeurs; // ??
  InitLesSupLigne(TOBL);
  if TOBCata = nil then EXIT;
  TOBL.PutValue('GL_ENCONTREMARQUE', 'X');
  TOBL.PutValue('GL_REFARTSAISIE', TOBCata.GetValue('GCA_REFERENCE'));
  TOBL.PutValue('GL_ARTICLE', TOBCata.GetValue('GCA_ARTICLE'));
  TOBL.PutValue('GL_REFCATALOGUE', TOBCata.GetValue('GCA_REFERENCE'));
  TOBL.PutValue('GL_FOURNISSEUR', TOBCata.GetValue('GCA_TIERS'));
  TOBL.PutValue('_CONTREMARTREF', ArticleRef);
  TOBL.PutValue('GL_TYPEREF', 'CAT');
  if TobArt <> nil then
  begin
    TOBL.PutValue('GL_REFARTSAISIE', TOBArt.GetValue('REFARTSAISIE'));
    TOBL.PutValue('GL_CODEARTICLE', TOBArt.GetValue('GA_CODEARTICLE'));
    TOBL.PutValue('GL_REFARTBARRE', TOBArt.GetValue('REFARTBARRE'));
    TOBL.PutValue('GL_REFARTTIERS', TOBArt.GetValue('REFARTTIERS'));
    TOBL.PutValue('GL_TYPEREF', 'ART');
  end;
end;

{==============================================================================================}
{=============================== Manipulation des articles ====================================}
{==============================================================================================}

procedure TFFacture.CodesArtToCodesLigne(TOBArt: TOB; ARow: integer);
var TOBL: TOB;
  RefSais: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  TOBL.InitValeurs;
  InitLesSupLigne(TOBL);
  RefSais := Trim(Copy(GS.Cells[SG_RefArt, ARow], 1, 18));
  TOBArt.PutValue('REFARTSAISIE', RefSais);
  TOBL.PutValue('GL_ARTICLE', TOBArt.GetValue('GA_ARTICLE'));
  TOBL.PutValue('GL_REFARTSAISIE', TOBArt.GetValue('REFARTSAISIE'));
  TOBL.PutValue('GL_CODEARTICLE', TOBArt.GetValue('GA_CODEARTICLE'));
  TOBL.PutValue('GL_REFARTBARRE', TOBArt.GetValue('REFARTBARRE'));
  TOBL.PutValue('GL_REFARTTIERS', TOBArt.GetValue('REFARTTIERS'));
  TOBL.PutValue('GL_TYPEREF', 'ART');
  if (ctxMode in V_PGI.PGIContexte) then
  begin
    if (TOBArt.GetValue('REFARTSAISIE') = TOBArt.GetValue('REFARTBARRE')) and not SaisieCodeBarreAvecFenetre then
    begin
      if not TOBL.FieldExists('REGROUPE_CB') then
      begin
        TOBL.AddChampSup('REGROUPE_CB', False);
        TOBL.PutValue('REGROUPE_CB', '-');
        TOBL.AddChampSup('UNI_OU_DIM', False);
        if TOBArt.GetValue('GA_STATUTART') = 'DIM' then
          TOBL.PutValue('UNI_OU_DIM', 'DIM') else TOBL.PutValue('UNI_OU_DIM', 'UNI');
      end;
    end;
  end;
end;

function TFFacture.PlusEnStock(TOBArt: TOB): boolean;
var Depot: string;
  QQ: TQuery;
  QteDisp: Double;
begin
  Result := True;
  QteDisp := 0;
  if TOBArt.GetValue('GA_TENUESTOCK') = '-' then Exit;
  Depot := GP_DEPOT.Value;
  if Depot = '' then Depot := VH_GC.GCDepotDefaut;
  QQ := OpenSQL('SELECT GQ_PHYSIQUE-QG_RESERVECLI FROM DISPO WHERE GQ_ARTICLE="' + TOBArt.GetValue('GA_ARTICLE') + '" AND GQ_DEPOT="' + Depot + '"', True);
  if not QQ.EOF then QteDisp := QQ.Fields[0].AsFloat;
  Ferme(QQ);
  if QteDisp <= 0 then Exit;
  Result := False;
end;

function TFFacture.IdentifierArticle(var ACol, ARow: integer; var Cancel: boolean; Click, FromMacro: Boolean): boolean;
var RefSais, StatutArt, RefUnique, CodeArticle, CodeFournis, CodeDepot: string;
  RefCata, RefFour, CCells, TypeRef, CataArticleRef: string;
  TOBArt, TOBArtRef, TOBCata: TOB;
  QQ, QArt: TQuery;
  MultiDim, Okok: Boolean;
  RechArt, EtatRech: T_RechArt;
begin
  if not Click then
  begin
    RefSais := GS.Cells[SG_RefArt, ARow];
    if RefSais = '' then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
  RefUnique := '';
  CodeArticle := '';
  StatutArt := '';
  CataArticleRef := '';
  MultiDim := False;
  TOBArt := nil;
  TobCata := nil;
  if not GereContreM or (GS.Cells[SG_ContreM, ARow] <> 'X') then
  begin
    TOBArt := FindTOBArtSais(TOBArticles, RefSais);
    if TOBArt <> nil then
    begin
      if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
      begin
        // article gérable qu'en contremarque
        HPiece.Execute(47, caption, '');
        RechArt := traContreM;
      end else RechArt := traOk;
    end else
    begin
      TOBArt := CreerTOBArt(TOBArticles);
      if FromMacro then
      begin
        QArt := OpenSQL('Select * from ARTICLE Where GA_ARTICLE="' + RefSais + '"', True);
        if not QArt.EOF then
        begin
          TOBArt.SelectDB('', QArt);
          RechArt := traOk;
        end
        else RechArt := traErreur;
        Ferme(QArt);
      end else
      begin
        RechArt := TrouverArticleSQL(CleDoc.NaturePiece, RefSais, GP_DOMAINE.Value, '', CleDoc.DatePiece, TOBArt, TOBTiers);
        if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
        begin
          // article gérable qu'en contremarque
          HPiece.Execute(47, caption, '');
          RechArt := traContreM;
        end;
        if (ctxMode in V_PGI.PGIContexte) then
        begin
          if (RechArt = traOk) or (RechArt = traOkGene) or (RechArt = traGrille) then
          begin
            // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
            // défini en entête du document d'achat, sont autorisés en saisie.
            if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
              (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then
              if TOBArt.GetValue('GA_FOURNPRINC') <> GP_TIERS.Text then RechArt := traErrFour;
          end;
        end;
      end;
    end;
  end else
  begin
    // Article de contremarque
    TOBCata := FactUtil.CreerTOBCata(TOBCatalogu);
    RechArt := TrouverContreMSQL(CleDoc.NaturePiece, UpperCase(RefSais), CleDoc.DatePiece, TOBCata);
    if RechArt = traAucun then
    begin
      TOBCata.Free;
      TOBCata := nil;
    end else
    begin
      StatutArt := 'UNI';
      if Trim(TOBCata.GetValue('GCA_ARTICLE')) <> '' then
      begin
        RefUnique := TOBCata.GetValue('GCA_ARTICLE');
        CodeArticle := TOBCata.GetValue('GCA_ARTICLE');
        TypeRef := 'ART';
        TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
        if TOBArt <> nil then
        begin
          if TOBArt.GetValue('GA_TENUESTOCK') = 'X' then RechArt := traAucun;
          CodeArticle := TOBArt.GetValue('GA_CODEARTICLE');
          StatutArt := TOBArt.GetValue('GA_STATUTART');
        end else
        begin
          QQ := OpenSQL('Select * from ARTICLE Where GA_ARTICLE="' + RefUnique + '" and GA_TENUESTOCK<>"X" ', True);
          if not QQ.EOF then
          begin
            TOBArt := CreerTOBArt(TOBArticles);
            TOBArt.SelectDB('', QQ);
            CodeArticle := QQ.FindField('GA_CODEARTICLE').AsString;
            StatutArt := QQ.FindField('GA_STATUTART').AsString;
          end else RechArt := traAucun;
          Ferme(QQ);
        end;
        EtatRech := EtudieEtat(TOBArt, CleDoc.NaturePiece);
        if EtatRech = traGrille then StatutArt := 'GEN' else StatutArt := 'UNI';
      end else
      begin
        RefUnique := '';
        CodeArticle := TOBCata.GetValue('GCA_REFERENCE');
        TypeRef := 'CAT';
        if GetInfoParPiece(NewNature, 'GPP_CONTREMREF') = 'X' then
        begin
          CataArticleRef := FactUtil.CatalogueChoixArticleRef;
          if CataArticleRef <> '' then
          begin
            TOBArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [CataArticleRef], False);
            if TOBartRef = nil then
            begin
              QQ := OpenSQL('Select * from ARTICLE Where GA_ARTICLE="' + CataArticleRef + '" ', True);
              if not QQ.EOF then
              begin
                TOBArtRef := CreerTOBArt(TOBArticles);
                TOBArtRef.SelectDB('', QQ);
              end;
              Ferme(QQ);
            end;
          end;
        end;
      end;
    end;
  end;
  case RechArt of
    traErreur:
      begin
        if not FromMAcro then ErreurCodeArticle(RefSais);
        CodeArticle := '';
        RefUnique := '';
        StatutArt := '';
      end;
    traErrFour:
      begin
        ErreurCodeArticleFour(RefSais);
        CodeArticle := '';
        RefUnique := '';
        StatutArt := '';
      end;
    traSus:
      begin
        CodeArticle := '';
        RefUnique := '';
        StatutArt := '';
      end;
    traContreM:
      begin
        CodeArticle := '';
        RefUnique := '';
        StatutArt := '';
      end;
    traOk:
      begin
        if not GereContreM or (GS.Cells[SG_ContreM, ARow] <> 'X') then
        begin
          CodeArticle := TOBArt.GetValue('GA_CODEARTICLE');
          RefUnique := TOBArt.GetValue('GA_ARTICLE');
          StatutArt := TOBArt.GetValue('GA_STATUTART');
        end;
      end;
    traOkGene:
      begin
        CodeArticle := TOBArt.GetValue('GA_CODEARTICLE');
        RefUnique := TOBArt.GetValue('GA_ARTICLE');
        StatutArt := 'UNI';
      end;
    traGrille:
      begin
        CodeArticle := TOBArt.GetValue('GA_CODEARTICLE');
        RefUnique := TOBArt.GetValue('GA_ARTICLE');
        StatutArt := TOBArt.GetValue('GA_STATUTART');
        GS.Cells[SG_RefArt, ARow] := CodeArticle;
      end;
    traAucun:
      begin
        if TobArt <> nil then
        begin
          TobArt.free;
          TobArt := nil;
        end;
        CodeArticle := '';
        RefUnique := '';
        StatutArt := '';
        GS.Col := SG_RefArt;
        GS.Row := ARow;
        if GereElipsis(SG_RefArt) then
        begin
          if GereContreM and (GS.CElls[SG_ContreM, ARow] = 'X') then
          begin
            cCells := GS.Cells[SG_RefArt, ARow];
            RefCata := uppercase(Trim(ReadTokenSt(cCells)));
            RefFour := uppercase(Trim(ReadTokenSt(cCells)));
            TOBCata := FactComm.FindTOBCataSais(TOBCatalogu, RefCata, RefFour);
            if TOBCata = nil then
            begin
              QQ := OpenSQL('Select * from CATALOGU Where GCA_REFERENCE="' + RefCATA + '" AND GCA_TIERS="' + RefFour + '"', True);
              if not QQ.EOF then
              begin
                TOBCata := FactUtil.CreerTOBCata(TOBCatalogu);
                TOBCata.SelectDB('', QQ);
              end;
              Ferme(QQ);
            end;
            if Trim(TOBCata.GetValue('GCA_ARTICLE')) <> '' then
            begin
              RefUnique := TOBCata.GetValue('GCA_ARTICLE');
              CodeArticle := TOBCata.GetValue('GCA_ARTICLE');
              TypeRef := 'ART';
              StatutArt := 'UNI'; //??
            end else
            begin
              RefUnique := '';
              CodeArticle := TOBCata.GetValue('GCA_REFERENCE');
              TypeRef := 'CAT';
              StatutArt := 'UNI';
              if GetInfoParPiece(NewNature, 'GPP_CONTREMREF') = 'X' then
              begin
                CataArticleRef := FactUtil.CatalogueChoixArticleRef;
                if CataArticleRef <> '' then
                begin
                  TOBArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [CataArticleRef], False);
                  if TOBartRef = nil then
                  begin
                    QQ := OpenSQL('Select * from ARTICLE Where GA_ARTICLE="' + CataArticleRef + '" ', True);
                    if not QQ.EOF then
                    begin
                      TOBArtRef := CreerTOBArt(TOBArticles);
                      TOBArtRef.SelectDB('', QQ);
                    end;
                    Ferme(QQ);
                  end;
                end;
              end;
            end;
            GS.Cells[SG_RefArt, ARow] := CodeArticle;
          end else
          begin
            RefUnique := GS.Cells[SG_RefArt, ARow];
          end;
          if RefUnique <> '' then
          begin
            CodeFournis := '';
            TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
            if TOBArt <> nil then
            begin
              TypeRef := 'ART';
              CodeArticle := TOBArt.GetValue('GA_CODEARTICLE');
              StatutArt := TOBArt.GetValue('GA_STATUTART');
              CodeFournis := TOBArt.GetValue('GA_FOURNPRINC');
            end else
            begin
              QQ := OpenSQL('Select * from ARTICLE Where GA_ARTICLE="' + RefUnique + '" ', True);
              if not QQ.EOF then
              begin
                TOBArt := CreerTOBArt(TOBArticles);
                TOBArt.SelectDB('', QQ);
                CodeArticle := QQ.FindField('GA_CODEARTICLE').AsString;
                StatutArt := QQ.FindField('GA_STATUTART').AsString;
                CodeFournis := QQ.FindField('GA_FOURNPRINC').AsString;
                if not GereContreM or (GS.Cells[SG_ContreM, ARow] <> 'X') then
                begin
                  if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
                  begin
                    // article gérable qu'en contremarque
                    HPiece.Execute(47, caption, '');
                    CodeArticle := '';
                    RefUnique := '';
                    StatutArt := '';
                    CodeFournis := '';
                  end;
                end;
              end;
              Ferme(QQ);
            end;
            EtatRech := EtudieEtat(TOBArt, CleDoc.NaturePiece);
            if EtatRech = traGrille then StatutArt := 'GEN' else StatutArt := 'UNI';
            GS.Cells[SG_RefArt, ARow] := CodeArticle;
            if (ctxMode in V_PGI.PGIContexte) then
            begin
              // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
              // défini en entête du document d'achat, sont autorisés en saisie.
              if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
                (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then
                if CodeFournis <> GP_TIERS.Text then
                begin
                  ErreurCodeArticleFour(CodeArticle);
                  CodeArticle := '';
                  RefUnique := '';
                  StatutArt := '';
                end;
            end;
          end;
        end;
      end;
  end;
  if ((StatutArt = '') or (CodeArticle = '') or ((RefUnique = '') and (TypeREf = 'ART'))) then
  begin
    Cancel := True;
    GS.Col := ACol;
    GS.Row := ARow;
    TOBArt.Free;
    TOBCata.free;
    Exit;
  end;
  if StatutArt = 'GEN' then
  begin
    if (ctxMode in V_PGI.PGIContexte) or (GetInfoParPiece(NewNature, 'GPP_MULTIGRILLE') = 'X') then
    begin
      if GS.Cells[SG_Lib, Arow] = '' then NewLigneDim := True;
      RemplirTOBDim(CodeArticle, ARow);
      //modif 28/03/2002
      if (CleDoc.NaturePiece = 'TRE') or (CleDoc.NaturePiece = 'TRV') then
        CodeDepot := TOBPiece.GetValue('GP_DEPOTDEST')
      else CodeDepot := TOBPiece.GetValue('GP_ETABLISSEMENT');
      if SelectMultiDimensions(CodeArticle, GS, CodeDepot, Action) then //AC+JD
      begin
        MultiDim := True;
        TOBDim := TheTOB;
        TheTOB := nil;
      end else
      begin
        RefUnique := '';
        TOBDim.ClearDetail;
        TheTOB := nil;
      end;
    end else
    begin
      RefUnique := SelectUneDimension(RefUnique);
    end;
    if RefUnique = '' then
    begin
      Cancel := True;
      GS.Col := ACol;
      GS.Row := ARow;
      TOBArt.Free;
      Exit;
    end;
  end;
  Okok := (StatutArt = 'UNI') or ((StatutArt = 'GEN') and (MultiDim)) or (StatutArt = 'DIM');
  if not Okok then
  begin
    TOBArt.Free;
    TOBArt := CreerTOBArt(TOBArticles);
    TOBArt.SelectDB('"' + RefUnique + '"', nil);
  end;
  if (TOBArt <> nil) then
  begin
    //  BBI, fiche correction 10410
    CalculePrixArticle(TOBArt, TobPiece.GetValue('GP_DEPOT'));
    //  BBI, fin fiche correction 10410
    CodesArtToCodesLigne(TOBArt, ARow);
  end;
  if TOBCata <> nil then
  begin
    CodesCataToCodesLigne(TOBCata, TOBArt, CataArticleRef, ARow);
  end;
  Result := True;
end;

procedure TFFacture.ChargeTOBDispo(ARow: integer);
var TOBA: TOB;
begin
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  LoadTobDispo(TobA, False, CreerQuelDepot(TobPiece));

  if (CtxMode in V_PGI.PgiContexte) and (TOBA.GetValue('GA_ARTICLE') <> 'UNI') then exit
  else LoadTOBCond(TOBA.GetValue('GA_ARTICLE'));
  //  BBI, fiche correction 10410
  CalculePrixArticle(TOBA, TobPiece.GetValue('GP_DEPOT'));
  //  BBI, fin fiche correction 10410
end;

procedure TFFacture.ChargeTOBDispoContreM(ARow: integer);
var TOBL, TOBC: TOB;
begin
  TOBC := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
  if TOBC = nil then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  LoadTOBDispoContreM(TOBL, TOBC, False, CreerQuelDepot(TOBPiece));
end;

procedure TFFacture.TraiteLeCata(ARow: integer);
var TOBL, TOBA: TOB;
begin
  if VenteAchat <> 'ACH' then Exit;
  if not CataFourn then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if not TOBA.FieldExists('DPANEW') then AjouteCatalogueArt(TOBL, TOBA);
  if TOBA.FieldExists('GCA_QUALIFUNITEACH') then TOBL.PutValue('GL_QUALIFQTEACH', TOBA.GetValue('GCA_QUALIFUNITEACH'));
  if TOBA.FieldExists('GCA_REFERENCE') then TOBL.PutValue('GL_REFARTTIERS', TOBA.GetValue('GCA_REFERENCE'));
end;

procedure TFFacture.UpdateArtLigne(ARow: integer; FromMacro, Calc: boolean; NewQte: double);
var StatutArt: string;
  TOBA, TOBL: Tob;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if CtxMode in V_PGI.PGIContexte then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
    if (TOBA <> nil) and (TOBA.GetValue('GA_STATUTART') <> 'UNI') then
      StatutArt := 'GEN' else StatutArt := 'UNI';
    if (StatutArt = 'UNI') or TOBL.FieldExists('REGROUPE_CB') then ChargeTOBDispo(ARow);
  end
  else
    ChargeTOBDispo(ARow);
  TOBL.PutValue('GL_TIERS', GP_TIERS.TEXT); //Pour init libelle article catalogu
  TraiteLeCata(ARow);
  InitLaLigne(ARow, NewQte);
  if not FromMacro then
  begin
    TraiteLesDim(ARow, True);
    TraiteLesCons(ARow);
    TraiteLesNomens(ARow);
    {$IFDEF BTP}
    // Modif BTP
    if TraiteLesOuv(Arow) then AfficheLaLigne(Arow)
    else
    begin
      VideCodesLigne(TOBPiece, ARow);
      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
    end;

    // ------
    {$ENDIF}
    TraiteLesMacros(ARow);
    if ((not (ctxMode in V_PGI.PGIContexte)) or ((ctxMode in V_PGI.PGIContexte) and (StatutArt = 'UNI'))) then TraiteLesLies(ARow);
  end;
  TraiteLaCompta(ARow);
  //TraiteLeCata(ARow) ;  //Pour init libelle article catalogu
  TraiteMotif(ARow);
  if (((not FromMacro) or (Calc)) and (not (ctxMode in V_PGI.PGIContexte)) or ((ctxMode in V_PGI.PGIContexte) and (StatutArt = 'UNI'))) then
  begin
    TOBPiece.putvalue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_RefArt, ARow, False);
  end;
  ShowDetail(ARow);
  GP_DEVISE.Enabled := False;
  BDEVISE.Enabled := False;
  GP_DOMAINE.Enabled := False;
  {$IFDEF BTP}
  GestionDetailOuvrage(Arow);
  {$ENDIF}
end;

procedure TFFacture.UpdateCataLigne(ARow: integer; FromMacro, Calc: boolean; NewQte: double);
begin
  InitLaLigne(ARow, NewQte);
  ChargeTOBDispoContreM(ARow);
  if not FromMacro then
  begin
    //CONTREM ???
    //   TraiteLesDim(ARow,True) ;
    TraiteLesCons(ARow);
    //   TraiteLesNomens(ARow) ;
    //   TraiteLesMacros(ARow) ;
    TraiteLesLies(ARow);
  end;
  //CONTREM ??? Article Reference ?
  TraiteLaCompta(ARow);
  //TraiteLeCata(ARow) ;
  TraiteLaContreM(aRow);
  if ((not FromMacro) or (Calc)) then
  begin
    TOBPiece.putvalue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_RefArt, ARow, False);
  end;
  ShowDetail(ARow);
  GP_DEVISE.Enabled := False;
  BDEVISE.Enabled := False;
  GP_DOMAINE.Enabled := False;
end;

procedure TFFacture.TraiteLaContreM(ARow: integer);
var RefCata, RefFour: string;
  TOBL, TOBCata: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_TYPEREF') = 'CAT' then
  begin
    GetCodeCataUnique(TOBPiece, ARow, RefCata, RefFour);
    if (RefCata = '') or (RefFour = '') then Exit;
    TOBCata := FindTOBCataRow(TOBPiece, TOBCataLogu, ARow);
    if TOBCata = nil then Exit;
    if TOBCata <> nil then
      ReserveCliContreM(TOBL, TOBCata, True);
  end;
end;

procedure TFFacture.TraiteLaCompta(ARow: integer);
var RefUnique, RefCata, RefFour: string;
  TOBL, TOBA, TOBC, TOBCata, LocAnaP, LocAnaS: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_TYPEREF') = 'CAT' then
  begin
    GetCodeCataUnique(TOBPiece, ARow, RefCata, RefFour);
    if (RefCata = '') or (RefFour = '') then Exit;
  end else
  begin
    RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  end;
  if RefUnique = '' then Exit;
  LocAnaP := TOBAnaP;
  LocAnaS := TOBAnaS;
  TOBC := nil;
  TOBA := nil;
  TOBCata := nil;
  if ((OkCpta) or (OkCptaStock)) then
  begin
    if TOBL.GetValue('GL_TYPEREF') = 'CAT' then
    begin
      TOBCata := FindTOBCataRow(TOBPiece, TOBCataLogu, ARow);
      if TOBCata = nil then Exit;
    end else
    begin
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
      if TOBA = nil then Exit;
    end;
    TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBL, TOBA, TOBTiers, TOBCata, TobAffaire, True);
    if TOBC <> nil then
    begin
      if ((TOBL.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
      if ((TOBL.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
    end;
  end;
  PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBL);
end;

// Modif BTP

function TFFacture.TraiteLesOuv(ARow: integer): boolean;
begin
  result := true;
  {$IFDEF BTP}
  result := TraiteLesOuvrages(TOBPiece, TOBArticles, TOBOuvrage, ARow, False, DEV, OrigineExcel);
  {$ENDIF}
end;
// ---------

procedure TFFacture.TraiteLesNomens(ARow: integer);
begin
  TraiteLesNomenclatures(TOBPiece, TOBArticles, TOBNomenclature, ARow, False);
end;

procedure TFFacture.DetruitLot(ARow: integer);
var TOBA, TOBL, TOBDepot, TOBNoeud: TOB;
  IndiceLot: integer;
  Depot: string;
begin
  if Action = taConsult then Exit;
  if not GereLot then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  if TOBA.GetValue('GA_LOT') <> 'X' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  IndiceLot := TOBL.GetValue('GL_INDICELOT');
  if IndiceLot <= 0 then Exit;
  Depot := TOBL.GetValue('GL_DEPOT');
  TOBDepot := TOBA.FindFirst(['GQ_DEPOT'], [Depot], False);
  if TOBDepot = nil then Exit;
  TOBNoeud := TOBDesLots.Detail[IndiceLot - 1];
  SupprimeLot(TobDepot, TobNoeud, VenteAchat);
end;

procedure TFFacture.GereLesLots(ARow: integer);
var TOBA, TOBDepot, TOBL, TOBNoeud: TOB;
  Depot, RefUnique: string;
  IndiceLot: integer;
  Qte, NewQte: Double;
  Valid, OkSerie: boolean;
begin
  if Action = taConsult then Exit;
  if not GereLot then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  if TOBA.GetValue('GA_LOT') <> 'X' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if not TOBL.FieldExists('QTECHANGE') then
  begin
    TOBL.AddChampSup('QTECHANGE', False);
    TOBL.PutValue('QTECHANGE', 'X');
  end;
  if TOBL.GetValue('QTECHANGE') <> 'X' then Exit;
  Depot := TOBL.GetValue('GL_DEPOT');
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  Qte := TOBL.GetValue('GL_QTEFACT');
  TOBDepot := TOBA.FindFirst(['GQ_DEPOT'], [Depot], False);
  if TOBDepot = nil then
  begin
    TOBDepot := TOB.Create('DISPO', TOBA, -1);
    TOBDepot.PutValue('GQ_ARTICLE', RefUnique);
    TOBDepot.PutValue('GQ_DEPOT', Depot);
    TOBDepot.PutValue('GQ_CLOTURE', '-');
    DispoChampSupp(TOBDepot);
    TOBDepot.AddChampSupValeur('NEW_ENREG', 'X');
  end;
  IndiceLot := TOBL.GetValue('GL_INDICELOT');
  if IndiceLot > 0 then TOBNoeud := TOBDesLots.Detail[IndiceLot - 1] else
  begin
    TOBNoeud := CreerNoeudLot(TOBPiece, TOBDesLots);
    IndiceLot := TOBDesLots.Detail.Count;
    TOBL.PutValue('GL_INDICELOT', IndiceLot);
  end;
  OkSerie := (GereSerie) and (TOBA.GetValue('GA_NUMEROSERIE') = 'X');
  GS.CacheEdit;
  GS.SynEnabled := False;
  Valid := Entree_LigDispolot(TOBDepot, TOBNoeud, TOBL, TobSerie, OkSerie, Action);
  GS.MontreEdit;
  GS.SynEnabled := True;
  TOBL.PutValue('QTECHANGE', '-');
  if not Valid then
  begin
    NewQte := Arrondi(TOBNoeud.GetValue('QUANTITE'), 6);
    if NewQte <> Qte then
    begin
      if SG_QS > 0 then
      begin
        GS.Cells[SG_QS, ARow] := StrF00(NewQte, V_PGI.OkDecQ);
        TraiteQte(SG_QS, ARow);
      end;
      if SG_QF > 0 then
      begin
        GS.Cells[SG_QF, ARow] := StrF00(NewQte, V_PGI.OkDecQ);
        TraiteQte(SG_QF, ARow);
      end;
    end;
    TOBPIece.putvalue('GP_RECALCULER', 'X');
    TOBL.PutValue('GL_RECALCULER', 'X');
    CalculeLaSaisie(SG_QF, ARow, False);
  end;
end;

procedure TFFacture.DetruitSerie(ARow: integer);
var TOBL, TOBLS: TOB;
  IndiceSerie, i_ind: integer;
begin
  {$IFDEF CCS3}
  Exit;
  {$ELSE}
  if Action = taConsult then Exit;
  if not GereSerie then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_NUMEROSERIE') <> 'X' then Exit;
  IndiceSerie := TOBL.GetValue('GL_INDICESERIE');
  if IndiceSerie <= 0 then Exit;
  TOBL.PutValue('GL_INDICESERIE', 0);
  for i_ind := TOBSerie.Detail[IndiceSerie - 1].Detail.Count - 1 downto 0 do
  begin
    TOBLS := TOBSerie.Detail[IndiceSerie - 1].Detail[i_ind];
    if i_ind = 0 then TOBLS.PutValue('GLS_IDSERIE', '')
    else TOBLS.Free;
  end;
  {$ENDIF}
end;

procedure TFFacture.GereLesSeries(ARow: integer);
var TOBA, TOBL, TOBM, TOBN, TOBPlat: TOB;
  RefUnique, QualQte: string;
  IndiceSerie, IndiceNomen, i_ind: integer;
  Qte, NewQte, UnitePiece, QteN, NbCompoSerie, QteRel: Double;
  Valid: boolean;
begin
  {$IFDEF CCS3}
  Exit;
  {$ELSE}
  if Action = taConsult then Exit;
  if not GereSerie then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_TYPELIGNE') <> 'ART' then Exit;
  if not TOBL.FieldExists('QTECHANGE') then
  begin
    TOBL.AddChampSup('QTECHANGE', False);
    TOBL.PutValue('QTECHANGE', 'X');
  end;
  if TOBL.GetValue('QTECHANGE') <> 'X' then Exit;
  IndiceNomen := 0;
  NbCompoSerie := 0;
  Qte := TOBL.GetValue('GL_QTESTOCK');
  QteRel := TOBL.GetValue('GL_QTERELIQUAT');
  if ((TOBL.GetValue('GL_TYPEARTICLE') = 'NOM') and (TOBL.GetValue('GL_TYPENOMENC') = 'ASS')) then
  begin // Nomenclatures
    IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
    if IndiceNomen <= 0 then exit;
    if TOBNomenclature = nil then Exit;
    if TOBNomenclature.Detail.Count - 1 < IndiceNomen - 1 then Exit;
    TOBN := TOBNomenclature.Detail[IndiceNomen - 1];
    TOBPlat := TOB.Create('', nil, -1);
    NomenAPlat(TOBN, TOBPlat, 1);
    for i_ind := TOBPlat.Detail.Count - 1 downto 0 do
    begin
      RefUnique := TOBPlat.Detail[i_ind].GetValue('GLN_ARTICLE');
      TOBA := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
      if TOBA = nil then
      begin
        TOBPlat.Detail[i_ind].Free;
        Continue;
      end;
      if TOBA.GetValue('GA_NUMEROSERIE') <> 'X' then
      begin
        TOBPlat.Detail[i_ind].Free;
        Continue;
      end;
      QteN := TOBPlat.Detail[i_ind].GetValue('GLN_QTE');
      NbCompoSerie := NbCompoSerie + QteN;
      TOBPlat.Detail[i_ind].PutValue('GLN_QTE', Qte * QteN);
      if not TOBPlat.Detail[i_ind].FieldExists('QTERELIQUAT') then
        TOBPlat.Detail[i_ind].AddChampSup('QTERELIQUAT', False);
      TOBPlat.Detail[i_ind].PutValue('QTERELIQUAT', QteRel * QteN);
    end;
    if (TOBPlat.Detail.Count = 0) or (NbCompoSerie = 0) then exit else TOBL.PutValue('GL_NUMEROSERIE', 'X');
  end else
  begin
    //   TOBA:=FindTOBArtRow(TOBPiece,TOBArticles,ARow) ; if TOBA=Nil then Exit ;
    //   if TOBA.GetValue('GA_NUMEROSERIE')<>'X' then Exit ;
    if TOBL.GetValue('GL_NUMEROSERIE') <> 'X' then Exit;
    TOBPlat := nil;
  end;
  TOBL.PutValue('QTECHANGE', '-');
  GS.CacheEdit;
  GS.SynEnabled := False;
  IndiceSerie := TOBL.GetValue('GL_INDICESERIE');
  if IndiceSerie <= 0 then
  begin
    IndiceSerie := TOBSerie.Detail.Count + 1;
    TOBL.PutValue('GL_INDICESERIE', IndiceSerie);
  end;
  Valid := Entree_SaisiSerie(TOBL, TOBPlat, TOBSerie, TOBSerie_O, TOBSerRel, Action);
  GS.MontreEdit;
  GS.SynEnabled := True;
  if TOBPlat <> nil then TOBPlat.Free;
  if not Valid then
  begin
    if (IndiceSerie > TOBSerie.Detail.Count) then
    begin
      TOBL.PutValue('GL_INDICESERIE', 0);
      NewQte := 0;
    end else
    begin
      if IndiceNomen <= 0 then NewQte := TOBSerie.Detail[IndiceSerie - 1].Detail.Count
      else NewQte := TOBSerie.Detail[IndiceSerie - 1].Detail.Count / NbCompoSerie;
      if VenteAchat = 'ACH' then QualQte := TOBL.GetValue('GLN_QUALIFQTEACH')
      else if (VenteAchat = 'AUT') or (VenteAchat = 'TRF') then QualQte := TOBL.GetValue('GL_QUALIFQTESTO')
      else QualQte := TOBL.GetValue('GL_QUALIFQTEVTE');
      TOBM := VH_GC.TOBMEA.FindFirst(['GME_QUALIFMESURE', 'GME_MESURE'], ['PIE', QualQte], False);
      UnitePiece := 0;
      if TOBM <> nil then UnitePiece := TOBM.GetValue('GME_QUOTITE');
      if (UnitePiece = 0) or (IndiceNomen > 0) then UnitePiece := 1.0;
      NewQte := Arrondi(NewQte / UnitePiece, 6);
    end;
    if NewQte <> Qte then
    begin
      if SG_QS > 0 then
      begin
        GS.Cells[SG_QS, ARow] := StrF00(NewQte, V_PGI.OkDecQ);
        TraiteQte(SG_QS, ARow);
      end;
      if SG_QF > 0 then
      begin
        GS.Cells[SG_QF, ARow] := StrF00(NewQte, V_PGI.OkDecQ);
        TraiteQte(SG_QF, ARow);
      end;
    end;
    TOBPIece.putvalue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_QF, ARow, False);
    TOBL.PutValue('QTECHANGE', '-');
  end;
  {$ENDIF}
end;

procedure TFFacture.GereArtsLies(ARow: integer);
var RefUnique, CodeArticle, LesRefsLies, StLoc, QteRef: string;
  TOBL: TOB;
  Qte: Double;
  Cancel: boolean;
  NbLies, LaLig, ACol: integer;
begin
  if not VH_GC.GCArticlesLies then Exit;
  if Action = taConsult then Exit;
  if ((TransfoPiece) or (DuplicPiece)) then Exit;
  if VenteAchat <> 'VEN' then Exit;
  RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  if RefUnique = '' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('ARTSLIES') <> 'X' then Exit;
  TOBL.PutValue('ARTSLIES', '-');
  Qte := TOBL.GetValue('GL_QTEFACT');
  CodeArticle := Trim(Copy(RefUnique, 1, 18));
  LesRefsLies := SelectArticlesLies(CodeArticle);
  if LesRefsLies = '' then Exit;
  StLoc := LesRefsLies;
  NbLies := 0;
  {Comptage pour creer les lignes et les tob à l'avance}
  repeat
    RefUnique := ReadTokenSt(StLoc);
    ReadTokenSt(StLoc); //pour QteRef
    if RefUnique <> '' then Inc(NbLies);
  until ((RefUnique = '') or (StLoc = ''));
  GS.RowCount := GS.RowCount + NbLies;
  CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TOBPiece.Detail.Count + NbLies);
  {Insertion et création des lignes liées}
  NbLies := 0;
  repeat
    RefUnique := ReadTokenSt(LesRefsLies);
    QteRef := ReadTokenSt(LesRefsLies);
    if RefUnique <> '' then
    begin
      CodeArticle := Trim(Copy(RefUnique, 1, 18));
      LaLig := ARow + 1 + NbLies;
      GS.Cells[SG_RefArt, LaLig] := RefUnique;
      ACol := SG_RefArt;
      Cancel := False;
      if QteRef <> '-' then TraiteArticle(ACol, LaLig, Cancel, True, True, Qte)
      else TraiteArticle(ACol, LaLig, Cancel, True, True, 1);
      if Cancel then Continue;
      GS.Cells[SG_RefArt, LaLig] := CodeArticle;
      AfficheLaLigne(LaLig);
      Inc(NbLies);
    end;
  until ((RefUnique = '') or (LesRefsLies = ''));
end;

procedure TFFacture.TraiteLesLies(ARow: integer);
var RefUnique, CodeArticle: string;
  TOBL: TOB;
  OkL: boolean;
begin
  if not VH_GC.GCArticlesLies then Exit;
  if Action = taConsult then Exit;
  if ((TransfoPiece) or (DuplicPiece)) then Exit;
  RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  if RefUnique = '' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('ARTSLIES') = '-' then Exit;
  CodeArticle := TOBL.GetValue('GL_CODEARTICLE');
  if CodeArticle = '' then Exit;
  OkL := ExisteSQL('SELECT GAL_ARTICLE FROM ARTICLELIE WHERE GAL_TYPELIENART="LIE" AND GAL_ARTICLE="' + CodeArticle + '"');
  if OkL then TOBL.PutValue('ARTSLIES', 'X') else TOBL.PutValue('ARTSLIES', '-');
end;

procedure TFFacture.TraiteLesMacros(ARow: integer);
var RefUnique, CodeArticle, TypeArt, TypeNomenc, Depot, LeCom: string;
  TOBL, TOBNomen, TOBLN, TOBPlat, TOBpl: TOB;
  i, ACol, LaLig, DecL: integer;
  Cancel: boolean;
  Qte: Double;
begin
  RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  if RefUnique = '' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TypeArt := TOBL.GetValue('GL_TYPEARTICLE');
  if TypeArt <> 'NOM' then Exit;
  TypeNomenc := TOBL.GetValue('GL_TYPENOMENC');
  if TypeNomenc <> 'MAC' then Exit;
  Depot := TOBL.GetValue('GL_DEPOT');
  if Depot = '' then Exit;
  TOBNomen := ChoixNomenclature(RefUnique, Depot, TOBArticles, False);
  TOBLN := TOB.Create('', TOBNomenclature, -1);
  TOBLN.AddChampSup('UTILISE', False);
  TOBLN.PutValue('UTILISE', '-');
  if TOBNomen <> nil then
  begin
    NomenligVersLignomen(TOBL, TOBNomen, TOBLN, 1, 0);
    TOBPlat := TOB.Create('', nil, -1);
    NomenAPlat(TOBLN, TOBPlat, 1);
    DecL := 0;
    GS.RowCount := GS.RowCount + TOBPlat.Detail.Count;
    CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TOBPiece.Detail.Count + TOBPlat.Detail.Count);
    for i := 0 to TOBPlat.Detail.Count - 1 do
    begin
      TOBpl := TOBPlat.Detail[i];
      RefUnique := TOBpl.GetValue('GLN_ARTICLE');
      CodeArticle := TOBpl.GetValue('GLN_CODEARTICLE');
      Qte := TOBpl.GetValue('GLN_QTE');
      LaLig := ARow + 1 + i - DecL;
      GS.Cells[SG_RefArt, LaLig] := RefUnique;
      ACol := SG_RefArt;
      Cancel := False;
      TraiteArticle(ACol, LaLig, Cancel, True, True, Qte);
      if Cancel then
      begin
        Inc(DecL);
        Continue;
      end;
      GS.Cells[SG_RefArt, LaLig] := CodeArticle;
    end;
    TOBL := GetTOBLigne(TOBPiece, ARow);
    LeCom := TOBL.GetValue('GL_LIBELLE');
    ClickDel(ARow, True, False);
    ClickInsert(ARow);
    TOBL := GetTOBLigne(TOBPiece, ARow);
    TOBL.PutValue('GL_LIBELLE', LeCom);
    TOBPIece.putvalue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
    TOBPlat.Free;
  end else
  begin
    VideCodesLigne(TOBPiece, ARow);
    InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
  end;
  TOBLN.Free;
  TOBNomen.Free;
end;

procedure TFFacture.TraiteLesCons(ARow: integer);
var RefUnique: string;
  TOBTOF, TOBC, TOBFille, TOBL: TOB;
  Qte: double;
  CodeCond: string;
begin
  RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  if RefUnique = '' then Exit;
  TOBC := TOBConds.FindFirst(['GCO_ARTICLE', 'GCO_CHANGEUNITE'], [RefUnique, 'X'], False);
  if TOBC = nil then Exit;
  TOBTOF := TOB.Create('', nil, -1);
  TOBTOF.AddChampSup('QTEARTICLE', False);
  TOBTOF.AddChampSup('GCO_CODECOND', False);
  Qte := GetChampLigne(TOBPiece, 'GL_QTESTOCK', ARow);
  TOBTOF.PutValue('QTEARTICLE', Qte);
  CodeCond := GetChampLigne(TOBPiece, 'GL_CODECOND', ARow);
  TOBTOF.PutValue('GCO_CODECOND', CodeCond);
  while TOBC <> nil do
  begin
    TOBFille := TOB.Create('CONDITIONNEMENT', TOBTOF, -1);
    TOBFille.Dupliquer(TOBC, False, True);
    TOBC := TOBConds.FindNext(['GCO_ARTICLE', 'GCO_CHANGEUNITE'], [RefUnique, 'X'], False);
  end;
  TheTOB := TOBTOF;
  AGLLanceFiche('GC', 'GCSAISCOND', '', '', '');
  if TheTob <> nil then
  begin
    Qte := TheTOB.GetValue('QTEARTICLE');
    CodeCond := TheTOB.GetValue('GCO_CODECOND');
    TOBL := GetTOBLigne(TOBPiece, ARow);
    TOBL.PutValue('GL_CODECOND', CodeCond);
    if SG_QS > 0 then
    begin
      GS.Cells[SG_QS, ARow] := StrF00(Qte, V_PGI.OkDecQ);
      TraiteQte(SG_QS, ARow);
    end;
    if SG_QF > 0 then
    begin
      GS.Cells[SG_QF, ARow] := StrF00(Qte, V_PGI.OkDecQ);
      TraiteQte(SG_QF, ARow);
    end;
  end;
  TOBTOF.Free;
  TheTOB := nil;
end;

procedure TFFacture.TraiteArticle(var ACol, ARow: integer; var Cancel: boolean; FromMacro, Calc: boolean; NewQte: double);
var OkArt: Boolean;
  NewCol, NewRow: integer;
  TypeL, TypeD: string;
  Tobl: Tob; { NEwPIECE }
  {$IFDEF CHR}
  DateProd: TDateTime;
  {$ENDIF}
begin
  // modif BTP : pas d'accès à l'article en saisie d'avancements
  if SaisieTypeAvanc = True then Exit;

  TypeD := GetChampLigne(TOBPiece, 'GL_TYPEDIM', ARow);
  TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow);
  {$IFDEF CHR}
  DateProd := GetChampLigne(TOBPiece, 'GL_DATEPRODUCTION', ARow);
  if (DateProd <> iDate1900) and (DateProd < V_PGI.DateEntree) then
  begin
    Cancel := False;
    exit;
  end;
  {$ENDIF}
  { Empèche le changement de l'article si il y a des pièces précédentes ou suivantes }
  TobL := GetTOBLigne(TOBPiece, ARow);
  if ((TypeL = 'ART') or (TypeD = 'GEN')) and (not CanChangeArticle(Tobl)) then { NEWPIECE } // and (PiecePrec<>'') then
  begin
    GS.Cells[ACol, ARow] := GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', ARow);
    Cancel := True;
    exit;
  end;
  if GS.Cells[ACol, ARow] = '' then
  begin
    TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow);
    if (TypeL <> 'TOT') and (TypeD <> 'GEN') and (TypeL <> 'RG')
      and (copy(TypeL, 1, 2) <> 'DP') and (copy(TypeL, 1, 2) <> 'TP') then //MODIFBTP
    begin
      VideCodesLigne(TOBPiece, ARow);
      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow, True);
    end;
    Exit;
  end;
  if TypeD = 'GEN' then
  begin
    if GS.Cells[ACol, ARow] = GetChampLigne(TOBPiece, 'GL_CODESDIM', ARow) then Exit;
  end;
  // Modif BTP
  if (IsLigneDetail(TOBPiece, nil, Arow)) then
  begin
    GS.Cells[Acol, Arow] := StCellCur;
    exit;
  end;
  // ---------
  NewCol := GS.Col;
  NewRow := GS.Row;
  OkArt := IdentifierArticle(ACol, ARow, Cancel, False, FromMacro);
  if ((OkArt) and (not Cancel)) then
  begin
    GS.Col := NewCol;
    GS.Row := NewRow;
    if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow) then
    begin
      HPiece.Execute(2, Caption, '');
      VideCodesLigne(TOBPiece, ARow);
      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
    end else
    begin
      if GetChampLigne(TobPiece, 'GL_ENCONTREMARQUE', ARow) = 'X' then UpdateCataLigne(ARow, False, False, NewQte)
      else UpdateArtLigne(ARow, False, False, NewQte);
      if not TraiteRupture(ARow) then
      begin
        if SG_QF >= 0 then
        begin
          GS.Cells[SG_QF, ARow] := '';
          TraiteQte(SG_QF, ARow);
        end;
        if SG_QS >= 0 then
        begin
          GS.Cells[SG_QS, ARow] := '';
          TraiteQte(SG_QS, ARow);
        end;
      end;
      TOBPiece.putvalue('GP_RECALCULER', 'X');
    end;
  end;
end;

function TFFacture.ArticleUniqueDansCatalogue(RefUnique, RefFour: string): TOB;
// Contrôle si article existe une fois et une seule dans le catalogue
var
  cSQL, RefCata: string;
  QQ: tQuery;
begin
  Result := nil;
  cSql := 'Select * from CATALOGU Where GCA_ARTICLE="' + RefUnique + '"';
  if (RefFour <> '') then cSql := cSql + ' AND GCA_TIERS="' + RefFour + '"';
  QQ := OpenSQL(cSQL, True);
  if (not QQ.EOF) and (QQ.RecordCount = 1) then
  begin
    RefCata := QQ.FindField('GCA_REFERENCE').AsString;
    RefFour := QQ.FindField('GCA_TIERS').AsString;
    Result := InitTOBCata(TOBCatalogu, RefCata, RefFour);
  end;
  Ferme(QQ);
end;

procedure TFFacture.LigneEnContreM(var ACol, ARow: integer; var Cancel: boolean);
{Changement dans l'état du flag contre marque}
var
  TOBL, TOBA, TOBCATA: TOB;
  RefCata, RefFour, cTmp: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if (TOBL = nil) then exit;
  if GS.Cells[SG_ContreM, ARow] = 'X' then {Activation de la contre marque}
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
    if (TOBA <> nil) then
    begin
      if TOBA.GetValue('GA_TENUESTOCK') = 'X' then
      begin
        HPiece.Execute(36, Caption, '');
        GS.Cells[SG_ContreM, ARow] := '-';
        exit;
      end;
      {Test si référence existe dans catalogue et est unique}
      TOBCata := ArticleUniqueDansCatalogue(TOBL.GetValue('GL_ARTICLE'), TOBA.GetValue('GA_FOURNPRINC'));
      if (TOBCata = nil) then
      begin
        {Plusieurs fournisseurs pour l'article => Sélection }
        cTmp := GetCatalogueMulArticle(GS, HTitres.Mess[1], CleDoc.NaturePiece);
        if cTmp <> '' then
        begin
          RefCata := uppercase(Trim(ReadTokenSt(cTmp)));
          RefFour := uppercase(Trim(ReadTokenSt(cTmp)));
          TOBCata := InitTOBCata(TOBCatalogu, RefCata, RefFour);
        end;
      end;
      if (TOBCata <> nil) then
      begin
        TOBL.PutValue('GL_ENCONTREMARQUE', 'X');
        TOBL.PutValue('GL_REFCATALOGUE', TOBCata.GetValue('GCA_REFERENCE'));
        TOBL.PutValue('GL_FOURNISSEUR', TOBCata.GetValue('GCA_TIERS'));
        TOBL.PutValue('_CONTREMARTREF', '');
        TOBL.PutValue('GL_TYPEREF', 'ART');
        LoadTOBDispoContreM(TOBL, TOBCata, true);
        ReserveCliContreM(TOBL, TOBCata, true);
        Cancel := False;
      end else
      begin
        // ContreM
        GS.Cells[SG_ContreM, ARow] := '-';
        Cancel := True; {Pas de sélection}
      end;
    end;
  end else {Désactivation de la contre marque}
  begin
    if TOBL.GetValue('GL_TYPEREF') = 'CAT' then
    begin
      ClickDel(ARow, True, False);
    end;
  end;
end;

{==============================================================================================}
{======================================== Calculs =============================================}
{==============================================================================================}

procedure TFFacture.RecalculeSousTotaux;
var i: integer;
begin
  CalculeSousTotauxPiece(TOBPiece);
  for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
end;

procedure TFFacture.AffichePorcs;
var X: Double;
  i: integer;
begin
  X := 0;
  if TOBPorcs <> nil then
  begin
    if GP_FACTUREHT.Checked then
    begin
      for i := 0 to TOBPorcs.Detail.Count - 1 do
        {$IFDEF BTPS5}
        if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALHTDEV');
      {$ELSE}
        X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALHTDEV');
      {$ENDIF}
    end else
    begin
      for i := 0 to TOBPorcs.Detail.Count - 1 do
        {$IFDEF BTPS5}
        if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALTTCDEV');
      {$ELSE}
        X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALTTCDEV');
      {$ENDIF}
    end;
  end;
  TOTALPORTSDEV.Value := Arrondi(X, 6);
end;

procedure TFFacture.CalculeLeDocument;
begin
  if (TOBPIece.Getvalue('GP_RECALCULER') = 'X') then
  begin
    if BeforeCalcul(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBOuvrage, TOBCpta, TOBcatalogu, TOBAffaire, DEV)
      then CalculFacture(TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBPorcs, TOBPieceRG, TOBBasesRG, DEV, SaisieTypeAvanc);
    AfterCalcul(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBPIECERG, TOBBASESRG, DEV);
  end;
end;

procedure TFFacture.CalculeLaSaisie(ACol, ARow: integer; AffTout: boolean);
var i: integer;
  Okok: boolean;
  // Modif BTP
  XD, XP, XE: double;
  {$IFDEF BTPS5}
  OldTotalAchat: double;
  {$ENDIF}
  // ---
begin
  if ((ACol <> SG_RefArt) and (ACol <> SG_QF) and (ACol <> SG_QS) and (ACol <> SG_QA) and (ACol <> SG_Px) and
    {$IFDEF MODE} // Modif MODE 31/07/2002
    (ACol <> SG_PxNet) and (ACol <> SG_Montant) and
    {$ENDIF}
    (ACol <> SG_Rem) and (ACol <> SG_RV) and (ACol <> SG_RL) and (ACol <> SG_Pct) and (ACol <> -1)) then Exit;

  if TOBPiece.GetValue('GP_RECALCULER') = 'X' then
  begin
    {$IFDEF BTPS5}
    // sauvegarde total achat
    if VH_GC.GCMargeArticle = 'PMA' then OldTotalAchat := TOBPiece.GetValue('PMAP') else
      if VH_GC.GCMargeArticle = 'PMR' then OldTotalAchat := TOBPiece.GetValue('PMRP') else
      if VH_GC.GCMargeArticle = 'DPA' then OldTotalAchat := TOBPiece.GetValue('DPA') else
      if VH_GC.GCMargeArticle = 'DPR' then OldTotalAchat := TOBPiece.GetValue('DPR');
    {$ENDIF}
    // Modif BTP
    CalculeLeDocument;
    // ------
    TOBPiece.PutEcran(Self, PPied);
    AfficheTaxes;
    AffichePorcs;
    if ARow > 0 then AfficheLaLigne(ARow);
    RecalculeSousTotaux(TOBPiece);
    if AffTout then
    begin
      for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
    end;
    if NeedVisa then
    begin
      {$IFDEF CEGID}
      if ((Action = taModif) and (not TransfoPiece) and (not DuplicPiece) and
        (Arrondi(TOBPiece.GetValue('GP_TOTALHT') - OldHT, 6) = 0)) then Okok := False;
      {$ELSE}
      Okok := True;
      {$ENDIF}
      if Okok then
      begin
        if Abs(TOBPiece.GetValue('GP_TOTALHT')) >= MontantVisa then TOBPiece.PutValue('GP_ETATVISA', 'ATT')
        else TOBPiece.PutValue('GP_ETATVISA', 'NON');
      end;
    end;
    TesteRisqueTiers(False);
    // Modif BTP
    RecalculeRG(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, DEV);
    GetMontantRG(TOBPIeceRG, TOBBasesRG, XD, XP, XE, DEV);
    TOTALRGDEV.Value := XD;
    TTYPERG.text := GetCumultextRg(TOBPIECERG, 'PRG_TYPERG');
    TCAUTION.text := GetCumulTextRG(TOBPIECERG, 'PRG_NUMCAUTION');
    // --
    {$IFDEF BTPS5}
    // Lancement du calcul du coefficient de frais
    // si le total en PA du document a changé
    // => CONDITIONNE SELON LE PARAMETRE GPP_GESTDETFRAIS DANS LA NATURE DE PIECE
    if GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_GESTDETFRAIS') = 'X' then
    begin
      if VH_GC.GCMargeArticle = 'PMA' then NewTotalAchat := TOBPiece.GetValue('PMAP') else
        if VH_GC.GCMargeArticle = 'PMR' then NewTotalAchat := TOBPiece.GetValue('PMRP') else
        if VH_GC.GCMargeArticle = 'DPA' then NewTotalAchat := TOBPiece.GetValue('DPA') else
        if VH_GC.GCMargeArticle = 'DPR' then NewTotalAchat := TOBPiece.GetValue('DPR');
      if NewTotalAchat <> OldTotalAchat then
      begin
        Cf := CalculCoefFrais(TOBPiece, TOBPorcs, DEV);
        if cf <> 1 then SaisiePrixMarche(Cf);
      end;
    end;
    {$ENDIF}
  end;
  TOBPiece.putvalue('GP_RECALCULER', '-');
end;

{==============================================================================================}
{======================================== Affichages ==========================================}
{==============================================================================================}

procedure TFFacture.AfficheZonePied(Sender: TObject);
var Nam, Nam2: string;
  CC: THLabel;
  rTaxes, rPay: Double;
  // Modif BTP
  XD, XP, XE: double;
  TXD, TXE, TXP: double;
  Vasy: boolean;
begin
  if Sender = nil then Exit;
  // Modif BTP
  vasy := false;
  // ----
  Nam := THNumEdit(Sender).Name;
  Nam := 'L' + Nam;
  CC := THLabel(FindComponent(Nam));
  if CC <> nil then CC.Caption := THNumEdit(Sender).Text;
  // Modif BTP
  if (Nam = 'LTOTALRGDEV') or (Nam = 'LTTYPERG') or (Nam = 'LTCAUTION') then
  begin
    HTTCDEV.Value := 0;
    vasy := true;
    if (TOTALRGDEV.Value <> 0) and (GetCumulTextRG(TOBPieceRG, 'PRG_TYPERG') = 'HT') and (ApplicRetenue) then
    begin
      GetcumultaxesRG(TOBBasesRG, TOBPieceRG, TXD, TXP, TXE, DEV);
      HTTCDEV.value := GP_TOTALTTCDEV.value - TOTALRGDEV.value - TXD;
    end;
  end;
  // --
  if (Nam = 'LGP_TOTALTTCDEV') or (Nam = 'LGP_TOTALHTDEV') or (Nam = 'LTOTALRGDEV') then
  begin
    // Affichage des taxes
       // Modif BTP
    if (TOTALRGDEV.Value <> 0) and (GetCumulTextRG(TOBPieceRG, 'PRG_TYPERG') = 'HT') and (ApplicRetenue) then
    begin
      vasy := true;
      GetcumultaxesRG(TOBBasesRG, TOBPieceRG, TXD, TXP, TXE, DEV);
      rTaxes := TOBPiece.GetValue('GP_TOTALTTCDEV') - TOBPiece.GetValue('GP_TOTALHTDEV') - TXD;
    end else
      // ----
      rTaxes := TOBPiece.GetValue('GP_TOTALTTCDEV') - TOBPiece.GetValue('GP_TOTALHTDEV');
    Nam2 := 'LTOTALTAXESDEV';
    CC := THLabel(FindComponent(Nam2));
    HTotalTaxesDEV.Value := rTaxes;
    if CC <> nil then CC.Caption := HTotalTaxesDEV.Text;
  end;
  if ((Nam = 'LGP_TOTALTTCDEV') or (Nam = 'LGP_ACOMPTEDEV') or (Nam = 'LNETAPAYERDEV') or (Nam = 'LTOTALRGDEV')) then
  begin
    // Affichage du net à payer
    // Modif BTP
    if (TOTALRGDEV.Value <> 0) and (ApplicRetenue) then
    begin
      vasy := true;
      GetCumulRG(TOBPIECERG, XP, XD, XE);
      rPay := TOBPiece.GetValue('GP_TOTALTTCDEV') - XD - TOBPiece.GetValue('GP_ACOMPTEDEV');
    end else
      // ---
      rPay := TOBPiece.GetValue('GP_TOTALTTCDEV') - TOBPiece.GetValue('GP_ACOMPTEDEV');
    Nam2 := 'LNETAPAYERDEV';
    CC := THLabel(FindComponent(Nam2));
    NetAPayerDEV.Value := rPay;
    if CC <> nil then CC.Caption := NetAPayerDEV.Text;
  end;
  // Modif BTP
  if vasy then DefiniPied;
end;

procedure TFFacture.TraiteTiersParam;
begin
  if Action <> taCreat then Exit;
  if LeCodeTiers = '' then Exit;
  GP_TIERS.Text := LeCodeTiers;
  if GeneCharge then Exit;
  ChargeTiers;
  PutValueDetail(TOBPiece, 'GP_TIERS', GP_TIERS.Text);
  if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then
    {$IFDEF BTP}
    ChargeAffairePiece(True, True, False);
  {$ELSE}
    ChargeAffairePiece(True, True, True);
  {$ENDIF}
  CliCur := GP_TIERS.Text;
  GP_TIERS.enabled := false;
  if GP_ETABLISSEMENT.CanFocus then GP_ETABLISSEMENT.SetFocus else GotoEntete;
  GereTiersEnabled;
  if (TOBPiece.GetValue('GP_PERSPECTIVE') <> 0) then BValider.ModalResult := mrOK;
end;

procedure TFFacture.GereTiersEnabled;
begin
  BZoomTiers.Enabled := ((TOBTiers.GetValue('T_TIERS') <> '') and (GP_TIERS.Text = TOBTiers.GetValue('T_TIERS')));
end;

procedure TFFacture.GereCommercialEnabled;
begin
  BZoomCommercial.Enabled := (GP_REPRESENTANT.Text <> '');
end;

procedure TFFacture.GereAffaireEnabled;
begin
  if not (ctxAffaire in V_PGI.PGIContexte) and not (ctxGCAFF in V_PGI.PGIContexte) then Exit;
  if SaisieTypeAffaire then Exit;
  BZoomAffaire.Enabled := ((TOBAffaire.GetValue('AFF_AFFAIRE') <> '') and (GP_AFFAIRE.Text = TOBAffaire.GetValue('AFF_AFFAIRE')));
  if (GetParamSoc('SO_AFTYPECONF') <> 'A00') then BZoomAffaire.Enabled := False; // mcd 18/01/02 pas zoom si confidentailité
end;

procedure TFFacture.GereArticleEnabled;
begin
  BZoomArticle.Enabled := (GS.Cells[SG_RefArt, GS.Row] <> '');
end;

procedure TFFacture.GereEnabled(ARow: integer);
var TOBL: TOB;
  OkArt: boolean;
  // Modif Btp
  TypeArt: string;
  Indice: Integer;
  ouvrageDetail: boolean;
  Nomenc: boolean;
  // ----
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  BZoomArticle.Enabled := (GetCodeArtUnique(TOBPiece, ARow) <> '');
  BZoomPiece.Enabled := (not TransfoPiece) and (action in [taModif, taConsult]); { GPAO VOIR_SUIVI_PIECE }
  BZoomPieceTV.Enabled := BZoomPiece.Enabled; { GPAO VOIR_SUIVI_PIECE }
  //mcd merci de remettre la ligne suivante en place, quand les modif concernant ce bouton seront reporté dans diffus depuis Vdev
  //if (ctxAffaire in V_PGI.PGIContexte) and  not(ctxGCAFF in V_PGI.PGIContexte) then BZoomLignes.Enabled:=False;//mcd 14/04/2003
  if TOBL = nil then
  begin
    BZoomTarif.Enabled := False;
    BZoomDispo.Enabled := False;
    BZoomPrecedente.Enabled := False;
    BZoomOrigine.Enabled := False;
    MBSoldeReliquat.Enabled := False;
    MBSoldeTousReliquat.Enabled := False;
    MBDetailNomen.Enabled := False;
    {$IFDEF CCS3}
    MBDetailLot.Visible := False;
    {$ELSE}
    MBDetailLot.Enabled := False;
    {$ENDIF}
    VLigne.Enabled := False;
    SLigne.Enabled := False;
  end else
  begin
    // Modif BTP
    TypeArt := TOBL.GetValue('GL_TYPEARTICLE');
    {$IFDEF BTP}
    MBDetailLot.Visible := False;
    for Indice := 0 to POPY.Items.Count - 1 do
    begin
      if (POPY.Items.Items[Indice].Name = 'MBDetailNomen') then
      begin
        if TypeArt = 'NOM' then
          POPY.Items.Items[Indice].Caption := TraduireMemoire('Détail Nomenclature')
        else
          POPY.Items.Items[Indice].Caption := TraduireMemoire('Détail Ouvrage');
      end;

      if (POPY.Items.Items[Indice].Name = 'CpltEntete') then
        POPY.Items.Items[Indice].Caption := TraduireMemoire('Complément Document');
    end; // fin du FOR
    {$ENDIF}

    {$IFDEF BTPS5}
    if GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_GESTDETFRAIS') = 'X' then
      FraisDetail.Visible := True
    else
      FraisDetail.Visible := False;
    {$ENDIF}

    // BOffice.Visible:=False;
    for Indice := 0 to POPL.Items.Count - 1 do
    begin
      if (POPL.Items[Indice].Name = 'TInsParag') and (VH_GC.BTGestParag = False) then
      begin
        POPL.Items[Indice].Visible := false;
        POPL.Items[Indice + 1].Visible := false;
      end;
      {$IFDEF BTP}
      if (POPL.Items.Items[Indice].Name = 'TCommentEnt') then
        POPL.Items.Items[Indice].Caption := TraduireMemoire('Accès au texte de début');
      if (POPL.Items.Items[Indice].Name = 'TCommentPied') then
        POPL.Items.Items[Indice].Caption := TraduireMemoire('Accès au texte de fin');
      {$ENDIF}
    end;

    OuvrageDetail := (TOBL.GetValue('GL_TYPEARTICLE') = 'OUV') and (TOBL.GetValue('GL_TYPENOMENC') = 'OUV');
    Nomenc := TOBL.GetValue('GL_TYPEARTICLE') = 'NOM';
    // FIn Modif BTP
    OkArt := ((TOBL.GetValue('GL_ARTICLE') <> '') or (TOBL.GetValue('GL_REFCATALOGUE') <> ''));
    if CtxMode in V_PGI.PGIContexte then OkArt := TOBL.GetValue('GL_REFARTSAISIE') <> '';
    BZoomDispo.Enabled := ((OkArt) and ((TOBL.GetValue('GL_TENUESTOCK') = 'X') or (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X')));
    BZoomTarif.Enabled := ((OkArt) and (TOBL.GetValue('GL_TARIF') > 0));
    BZoomPrecedente.Enabled := ((OkArt) and (TOBL.GetValue('GL_PIECEPRECEDENTE') <> ''));
    BZoomOrigine.Enabled := ((OkArt) and (TOBL.GetValue('GL_PIECEORIGINE') <> ''));
    MBSoldeReliquat.Enabled := ((OkArt) and (ReliquatTransfo) and (TOBL.GetValue('GL_PIECEPRECEDENTE') <> ''));
    MBSoldeTousReliquat.Enabled := ((OkArt) and (ReliquatTransfo) and (TOBL.GetValue('GL_PIECEPRECEDENTE') <> ''));
    MBDetailNomen.Enabled := ((OkArt) and (TOBL.GetValue('GL_INDICENOMEN') > 0));
    {$IFNDEF CCS3}
    MBDetailLot.Enabled := ((OkArt) and ((TOBL.GetValue('GL_INDICELOT') > 0) or (TOBL.GetValue('GL_INDICESERIE') > 0)));
    {$ENDIF}
    VLigne.Enabled := OkArt;
    SLigne.Enabled := OkArt;
    BSousTotal.Enabled := ((ARow > 1) and (TOBL.GetValue('GL_TYPELIGNE') <> 'TOT'));
    // Modif BTP
    MBModevisu.Enabled := ((OkArt) and (OuvrageDetail or Nomenc));
    Cpltligne.enabled := ((okart) and (TOBL.getvalue('GL_TYPELIGNE') <> 'COM') and
      (TOBL.GetValue('GL_TYPELIGNE') <> 'TOT'));
    if copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
      CpltLigne.enabled := true;
    // ----
  end;
  BVentil.Enabled := ((VPiece.Enabled) or (VLigne.Enabled) or (SPiece.Enabled) or (SLigne.Enabled));
end;

procedure TFFacture.ZoomOuChoixLib(ACol, ARow: integer);
var TOBL: TOB;
  Contenu: TStrings;
  LigCom: string;
  i_ind, ANewRow: integer;
begin
  if ACol <> SG_Lib then Exit;
  if Action = taConsult then Exit;
  if not CommentLigne then Exit;
  {$IFDEF BTP}
  if AfficheDesc = True then Exit;
  if OrigineEXCEL then
  begin
    ZoomOuChoixArtLib(ACol, Arow);
  end;
  Exit; // Pas de gestion des libellés auto pour BTP
  {$ENDIF}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (ctxMode in V_PGI.PGIContexte) or (ctxChr in V_PGI.PGIContexte) or (ctxFO in V_PGI.PGIContexte) then
  begin
    if GereElipsis(ACol) then TOBL.PutValue('GL_LIBELLE', GS.Cells[ACol, ARow]);
  end else
  begin
    if GetParamSoc('SO_GCCOMMENTAIRE') then
    begin
      Contenu := GetCommentaireLigne;
      if Contenu <> nil then
      begin
        if GS.RowCount < TOBPiece.Detail.Count + Contenu.Count then GS.RowCount := GS.RowCount + Contenu.Count;
        for i_ind := 0 to Contenu.Count - 1 do
        begin
          LigCom := Contenu[i_ind];
          ANewRow := ARow + i_ind;
          if ANewRow > TOBPiece.Detail.Count then CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, ANewRow)
          else if i_ind > 0 then ClickInsert(ANewRow);
          TOBL := GetTOBLigne(TOBPiece, ANewRow);
          if TOBL = nil then Continue;
          GS.Cells[ACol, ANewRow] := LigCom;
          TOBL.PutValue('GL_LIBELLE', GS.Cells[ACol, ANewRow]);
        end;
        Contenu.Free;
      end;
    end else if GereElipsis(ACol) then TOBL.PutValue('GL_LIBELLE', GS.Cells[ACol, ARow]);
  end;
end;

procedure TFFacture.ZoomOuChoixDateLiv(ACol, ARow: integer);
var TOBL: TOB;
  HDATE: THCritMaskEdit;
  Coord: TRect;
begin
  // DEBUT MODIF CHR
  // if ACol<>SG_DateLiv then Exit ;
  if (ACol <> SG_DateLiv) and (ACol <> SG_DateProd) then Exit;
  // FIN MODIF CHR
  if Action = taConsult then Exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  Coord := GS.CellRect(GS.Col, GS.Row);
  HDATE := THCritMaskEdit.Create(GS);
  HDATE.Parent := GS;
  HDATE.Top := Coord.Top;
  HDATE.Left := Coord.Left;
  HDATE.Width := 3;
  HDATE.Visible := False;
  HDATE.OpeType := otDate;
  GetDateRecherche(TForm(HDATE.Owner), HDATE);
  // DEBUT MODIF CHR
  //if HDATE.Text<>'' then GS.Cells[SG_DATELIV,GS.Row]:=HDATE.Text ;
  if HDATE.Text <> '' then GS.Cells[ACol, GS.Row] := HDATE.Text;
  // FIN MODIF CHR
  HDATE.Free;
end;

// DEBUT AJOUT CHR
{$IFDEF CHR}

procedure TFFacture.ZoomOuChoixRegroupe(ACol, ARow: integer);
var TOBL: TOB;
begin
  if (ACol <> SG_Regrpe) then Exit;
  if Action = taConsult then Exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  LookupList(GS, 'Liste des regroupements', 'HRREGROUPELIGNE', 'HGP_REGROUPELIGNE', 'HGP_ABREGE', '', '', False, -1);
end;

procedure TFFacture.GereChampsChr(Arow: integer; var cancel: boolean);
begin
  if (((GS.Cells[SG_RefArt, Arow] <> '') or (GS.Cells[SG_Lib, Arow] <> ''))
    and (GS.Cells[SG_DateProd, Arow] = '')) then
  begin
    GS.Cells[SG_DateProd, Arow] := GP_DATEPIECE.Text;
    TraiteDateProd(SG_DateProd, Arow, Cancel);
  end;
  if ((GS.Cells[SG_RefArt, Arow] <> '')
    and (GS.Cells[SG_Folio, Arow] = '0')) then
  begin
    GS.Cells[SG_Folio, Arow] := '1';
    GetTOBLigne(TOBPiece, Arow).PutValue('GL_NOFOLIO', 1);
    if (GetTOBLigne(TOBPiece, Arow).GetValue('GL_QTESIT') = 0) then
      GetTOBLigne(TOBPiece, Arow).PutValue('GL_QTESIT', TobHrDossier.GetValue('HDR_NBPERSONNE1'));
  end;
end;
{$ENDIF}
// FIN AJOUT CHR

procedure TFFacture.ZoomOuChoixArt(ACol, ARow: integer);
var RefUnique, RefCata, RefFour: string;
  Cancel, OkArt: boolean;
  TOBA, TOBL: TOB;
  ActionArt: TActionFiche;
begin
  if (ACol <> SG_RefArt) or (GetTOBLigne(TOBPiece, ARow) = nil) then Exit;
  RefUnique := '';
  RefCata := '';
  RefFour := '';
  if VarToStr(GetChampLigne(TOBPiece, 'GL_TYPEREF', ARow)) = 'CAT' then
    GetCodeCataUnique(TOBPiece, ARow, RefCata, RefFour)
  else
    // MODIF BTP
  begin
    if (IsLigneDetail(TOBPiece, nil, Arow)) then RefUnique := GetChampLigne(TOBPiece, 'GL_REFARTTIERS', ARow)
    else RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  end;
  // --
  if (CtxMode in V_PGI.PGIContexte) and (VarToStr(GetChampLigne(TOBPiece, 'GL_TYPEDIM', ARow)) = 'GEN') then RefUnique := ''; //AC
  ActionArt := Action;
  if ((ActionArt <> taConsult) and (not JaiLeDroitConcept(TConcept(gcArtModif), false))) then ActionArt := taConsult;
  if RefUnique <> '' then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
    // Modif BTP
    if (TOBA = nil) then
    begin
      TOBA := CreerTOBArt(TOBArticles);
      TOBA.SelectDB('"' + RefUnique + '"', nil);
    end;
    // -----
    ZoomArticle(RefUnique, TobA.GetValue('GA_TYPEARTICLE'), ActionArt);
  end else if (RefCata <> '') and (RefFour <> '') then
  begin
    ZoomCatalogue(RefCata, RefFour, ActionArt);
  end else if Action <> taConsult then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then exit;
    if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
    begin
      AppelleDim(ARow);
    end else
    begin
      Cancel := False;
      OkArt := IdentifierArticle(ACol, ARow, Cancel, True, False);
      if ((OkArt) and (not Cancel)) then
      begin
        if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow) then
        begin
          HPiece.Execute(2, Caption, '');
          VideCodesLigne(TOBPiece, ARow);
          InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
        end else if (TOBL.GetValue('GL_TYPEREF') = 'CAT') or (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X') then //Catalogue
        begin
          UpdateCataLigne(ARow, False, False, 1);
          StCellCur := GS.Cells[ACol, ARow];
        end else
        begin
          UpdateArtLigne(ARow, False, False, 1);
          StCellCur := GS.Cells[ACol, ARow];
        end;
        GereEnabled(Arow);
      end;
    end;
  end;
  if (Action = taConsult) and (RefUnique = '') then AppelleDim(ARow);
end;

{$IFDEF BTP}

function TFFacture.ZoomOuChoixArtLib(ACol, ARow: integer): Boolean;
var Cancel, OkArt: boolean;
  TOBArt, TOBL: TOB;
  ReferenceSav, UniteSav, RefUnique, LibSav: string;
  QteSav: Double;
begin
  result := True;
  if Action <> taConsult then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then exit;
    if TOBL.GetValue('GL_QTEFACT') = 0 then exit;
    LibSav := TOBL.GetValue('GL_LIBELLE');
    ReferenceSav := GS.Cells[SG_RefArt, ARow];
    QteSav := Valeur(GS.Cells[SG_QF, ARow]);
    UniteSav := GS.Cells[SG_Unit, ARow];
    OkArt := Lexical_RechArt(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, '');
    GS.Col := SG_Lib;
    if not OkArt then
    begin
      if GS.Row > TOBPiece.Detail.count then result := False; // Cas où on stoppe la recherche globale
      GS.Row := ARow;
      GS.Cells[SG_Lib, ARow] := LibSav;
      TOBL.PutValue('GL_LIBELLE', LibSav);
    end
    else
    begin
      TOBArt := CreerTOBArt(TOBArticles);
      TOBArt.SelectDB('"' + GS.Cells[SG_RefArt, ARow] + '"', nil);

      if TOBArt.Getvalue('GA_STATUTART') = 'GEN' then
      begin
        RefUnique := TOBArt.Getvalue('GA_ARTICLE');
        RefUnique := SelectUneDimension(RefUnique);
        TOBArt.Free;
        TOBArt := CreerTOBArt(TOBArticles);
        TOBArt.SelectDB('"' + RefUnique + '"', nil);
      end;

      CalculePrixArticle(TOBArt);
      if TOBPiece.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatProposition then
        GS.Cells[SG_RefArt, ARow] := ReferenceSav;
      CodesArtToCodesLigne(TOBArt, ARow);

      if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow) then
      begin
        HPiece.Execute(2, Caption, '');
        VideCodesLigne(TOBPiece, ARow);
        InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
        GS.Cells[SG_Lib, ARow] := LibSav;
        TOBL.PutValue('GL_LIBELLE', LibSav);
      end else
      begin
        if QTeSav = 0 then QteSav := 1;
        UpdateArtLigne(ARow, False, False, QteSav);
        if TOBPiece.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatProposition then
        begin
          GS.Cells[SG_Lib, ARow] := LibSav;
          TOBL.PutValue('GL_LIBELLE', LibSav);
          GS.Cells[SG_QF, ARow] := FloatToStr(QteSav);
          TOBL.PutValue('GL_QTEFACT', QteSav);
          GS.Cells[SG_Unit, ARow] := UniteSav;
          TOBL.PutValue('GL_QUALIFQTEVTE', UniteSav);
          TOBPiece.putValue('GP_RECALCULER', 'X');
          CalculeLaSaisie(-1, ARow, False);
          AfficheLaLigne(Arow);
        end
        else StCellCur := GS.Cells[ACol, ARow];
      end;
      GereEnabled(Arow);
    end;
  end;
end;
{$ENDIF}

procedure TFFacture.ShowDetail(ARow: integer);
var TOBArt, TOBLig, TOBCata, TobTemp: TOB;
  RefUnique, RefCata, RefFour: string;
  Q: TQuery;
begin
  if ARow <= TOBPiece.Detail.Count then
  begin
    TOBLig := GetTOBLigne(TOBPiece, ARow);
    if (CtxMode in V_PGI.PGIContexte) and (TOBLig.GetValue('GL_TYPEDIM') = 'GEN') then
    begin
      RefUnique := CodeArticleUnique2(TOBLig.GetValue('GL_CODESDIM'), '');
    end
    else RefUnique := TOBLig.GetValue('GL_ARTICLE');
  end else
  begin
    TOBLig := nil;
    RefUnique := '';
  end;
  if (TOBLig <> nil) and (CtxMode in V_PGI.PGIContexte) and ((Action = taConsult) or (Action = taModif)) and (TOBLig.GetValue('GL_TYPEDIM') = 'GEN') then
  begin
    if TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False) = nil then
    begin
      Q := OpenSQL('Select * from ARTICLE where GA_ARTICLE="' + RefUnique + '"', True);
      TobTemp := TOB.Create('LesArticles', nil, -1);
      if not Q.EOF then TobTemp.LoadDetailDB('ARTICLE', '', '', Q, False, True);
      TobArt := TobTemp.FindFirst(['GA_ARTICLE'], [RefUnique], False);
      if TobArt <> nil then
      begin
        TobArt.AddChampSupValeur('REFARTBARRE', '', False);
        TobArt.AddChampSupValeur('REFARTTIERS', '', False);
        TobArt.AddChampSupValeur('REFARTSAISIE', '', False);
        TobArt.AddChampSupValeur('UTILISE', '-', False);
        TobArt.Changeparent(TOBArticles, -1);
      end;
      Ferme(Q);
      TobTemp.Free;
    end;
  end;
  TOBArt := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
  TOBCata := nil;
  if (TOBLig <> nil) then
  begin
    if (TOBLig.GetValue('GL_ENCONTREMARQUE') = 'X') then
    begin
      RefCata := TOBLig.GetValue('GL_REFCATALOGUE');
      RefFour := GetCodeFourDCM(TOBLig);
      TOBCata := TOBCatalogu.FindFirst(['GCA_REFERENCE', 'GCA_TIERS'], [RefCata, RefFour], False);
    end;
  end;
  MontreInfosLigne(TOBLig, TOBArt, TOBCata, TOBTiers, INFOSLIGNE, PPInfosLigne);
  AfterShowDetail(Self, TOBPiece, TOBLig, RefUnique);
end;

{==============================================================================================}
{======================================== REPRESENTANTS =======================================}
{==============================================================================================}

procedure TFFacture.TraiteDepot(var ACol, ARow: integer; var Cancel: boolean);
var TOBL, TOBCata: TOB;
  sDep, NewDep: string;
  NewCol, NewRow: integer;
begin
  if ACol <> SG_Dep then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (TOBL.GetValue('GL_ARTICLE') = '') and (TOBL.GetValue('GL_TYPEREF') <> 'CAT') then Exit;
  TOBCata := nil;
  if (TOBL.GetValue('GL_TYPEREF') = 'CAT') or (GetChampLigne(TobPiece, 'GL_ENCONTREMARQUE', ARow) = 'X') then
    TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
  sDep := GS.Cells[ACol, ARow];
  if ((sDep <> '') and (sDep = TOBL.GetValue('GL_DEPOT'))) then Exit;
  NewCol := GS.Col;
  NewRow := GS.Row;
  GS.SynEnabled := False;
  GS.Col := ACol;
  GS.Row := ARow;
  if ((DepotExiste(sDep)) or (GetDepotSaisi(GS, HTitres.Mess[12], tlWhere))) then
  begin
    NewDep := GS.Cells[ACol, ARow];
    if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, False);
    TOBL.PutValue('GL_DEPOT', NewDep);
    if TOBCata <> nil then
    begin
      LoadTobDispoContreM(TobL, TobCata, False);
      ReserveCliContreM(TOBL, TOBCata, true);
    end;
    GS.Col := NewCol;
    GS.Row := NewRow;
    ChargeUnDepot(TOBArticles.FindFirst(['GA_ARTICLE'], [TobL.GetValue('GL_ARTICLE')], False), NewDep); // DBR : Depot unique chargé
  end else
  begin
    if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, False);
    TOBL.PutValue('GL_DEPOT', '');
    if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, true);
    Cancel := True;
  end;
  GS.SynEnabled := True;
end;

procedure TFFacture.ZoomOuChoixDep(ACol, ARow: integer);
var Depot, RefUnique, DepL: string;
  TOBL: TOB;
begin
  if ACol <> SG_Dep then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefUnique = '' then Exit;
  Depot := GS.Cells[ACol, ARow];
  DepL := TOBL.GetValue('GL_DEPOT');
  if ((Depot <> '') and (Depot = DepL) and (DepotExiste(Depot))) then
  begin
    TOBL.PutValue('GL_DEPOT', Depot);
  end else if Action <> taConsult then
  begin
    if IdentifierDepot(ACol, ARow) then
    begin
      StCellCur := GS.Cells[ACol, ARow];
      TOBL.PutValue('GL_DEPOT', GS.Cells[ACol, ARow]);
    end else
    begin
      TOBL.PutValue('GL_DEPOT', '');
    end;
  end;
end;

function TFFacture.IdentifierDepot(var ACol, ARow: integer): boolean;
var RefUnique, Depot: string;
  TOBL: TOB;
  OkD: boolean;
begin
  Result := False;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefUnique = '' then Exit;
  Depot := GS.Cells[ACol, ARow];
  if Depot <> '' then OkD := DepotExiste(Depot) else OkD := False;
  if OkD then Result := True else Result := GetDepotSaisi(GS, HTitres.Mess[12], tlWhere);
end;

function TFFacture.DepotExiste(Depot: string): boolean;
var StD: string;
begin
  StD := RechDom('GCDEPOT', Depot, False);
  Result := ((StD <> '') and (StD <> 'Error'));
end;

{==============================================================================================}
{======================================== REPRESENTANTS =======================================}
{==============================================================================================}

procedure TFFacture.TraiteRepres(var ACol, ARow: integer; var Cancel: boolean);
var TOBL: TOB;
  sRep, NewRep: string;
  NewCol, NewRow: integer;
begin
  if ACol <> SG_Rep then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_ARTICLE') = '' then Exit;
  sRep := GS.Cells[ACol, ARow];
  if sRep = '' then
  begin
    TOBL.PutValue('GL_REPRESENTANT', '');
    Exit;
  end;
  if sRep = TOBL.GetValue('GL_REPRESENTANT') then Exit;
  NewCol := GS.Col;
  NewRow := GS.Row;
  GS.SynEnabled := False;
  GS.Col := ACol;
  GS.Row := ARow;
  if GetRepresentantSaisi(GS, HTitres.Mess[11], TOBTiers.GetValue('T_ZONECOM'), tlWhere, TOBPiece) then
  begin
    NewRep := GS.Cells[ACol, ARow];
    TOBL.PutValue('GL_REPRESENTANT', NewRep);
    GS.Col := NewCol;
    GS.Row := NewRow;
    AjouteRepres(NewRep, TypeCom, TOBComms);
  end else
  begin
    TOBL.PutValue('GL_REPRESENTANT', '');
    GS.Cells[ACol, ARow] := '';
    Cancel := True;
  end;
  GS.SynEnabled := True;
end;

function TFFacture.RepresExiste(Repres: string): boolean;
begin
  Result := (TOBComms.FindFirst(['GCL_COMMERCIAL'], [Repres], False) <> nil);
end;

procedure TFFacture.ZoomOuChoixRep(ACol, ARow: integer);
var Repres, RefUnique, RepL: string;
  TOBL: TOB;
begin
  if ACol <> SG_Rep then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefUnique = '' then Exit;
  Repres := GS.Cells[ACol, ARow];
  RepL := TOBL.GetValue('GL_REPRESENTANT');
  if ((Repres <> '') and (Repres = RepL) and (RepresExiste(Repres))) then
  begin
    TOBL.PutValue('GL_REPRESENTANT', Repres);
    ZoomRepres(Repres);
  end else if Action <> taConsult then
  begin
    if IdentifierRepres(ACol, ARow) then
    begin
      StCellCur := GS.Cells[ACol, ARow];
      TOBL.PutValue('GL_REPRESENTANT', GS.Cells[ACol, ARow]);
      AjouteRepres(GS.Cells[ACol, ARow], TypeCom, TOBComms);
    end else
    begin
      TOBL.PutValue('GL_REPRESENTANT', '');
    end;
  end;
end;

function TFFacture.IdentifierRepres(var ACol, ARow: integer): boolean;
var RefUnique, Repres: string;
  TOBL, TOBC: TOB;
begin
  Result := False;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefUnique = '' then Exit;
  Repres := GS.Cells[ACol, ARow];
  if Repres <> '' then TOBC := TOBComms.FindFirst(['GCL_COMMERCIAL'], [Repres], False) else TOBC := nil;
  if TOBC <> nil then Result := True else Result := GetRepresentantSaisi(GS, HTitres.Mess[11], TOBTiers.GetValue('T_ZONECOM'), tlWhere, TOBPiece);
end;

procedure TFFacture.BalayeLignesRep;
var i: integer;
  TOBL: TOB;
  OldRep: string;
begin
  if Action = taConsult then Exit;
  if GeneCharge then Exit;
  {$IFNDEF CEGID}
  if GS.NbSelected <= 0 then Exit;
  {$ENDIF}
  for i := 1 to GS.RowCount - 1 do
  begin
    TOBL := GetTOBLigne(TOBPiece, i);
    if TOBL = nil then Break;
    {$IFNDEF CEGID}
    if GS.isSelected(i) then
    begin
      {$ENDIF}
      OldRep := TOBL.GetValue('GL_REPRESENTANT');
      if OldRep <> GP_REPRESENTANT.Text then
      begin
        TOBL.PutValue('GL_REPRESENTANT', GP_REPRESENTANT.Text);
        TOBL.PutValue('GL_VALIDECOM', 'NON');
        CommVersLigne(TOBPiece, TOBArticles, TOBComms, i, True);
      end;
      {$IFNDEF CEGID}
    end;
    {$ENDIF}
  end;
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  deselectionneRows;
  {$ENDIF}
  ShowDetail(GS.Row);
end;

procedure TFFacture.ZoomRepres(Repres: string);
var Crits: string;
begin
  Crits := ';GCL_TYPECOMMERCIAL="' + TypeCom + '"';
  AGLLanceFiche('GC', 'GCCOMMERCIAL', '', Repres, 'ACTION=CONSULTATION' + Crits);
end;

{==============================================================================================}
{======================================== COMPTABILITE ========================================}
{==============================================================================================}

procedure TFFacture.ZoomEcriture(DeStock: boolean);
begin
  LanceZoomEcriture(TOBPiece, DeStock);
end;

procedure TFFacture.GereAnal(ARow: integer);
var TOBL: TOB;
  RefU, OuvreA: string;
begin
  if Action = taConsult then Exit;
  if CompAnalL <> 'AUT' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefU := TOBL.GetValue('GL_ARTICLE');
  if RefU = '' then Exit;
  if TOBL.FieldExists('OUVREANAL') then OuvreA := TOBL.GetValue('OUVREANAL') else OuvreA := '';
  if OuvreA = 'X' then Exit;
  YYVentilAna(TOBL, TOBL.Detail[0], Action, 0);
  TOBL.PutValue('OUVREANAL', 'X');
end;

procedure TFFacture.VPieceClick(Sender: TObject);
begin
  ClickVentil(True, False);
end;

procedure TFFacture.VLigneClick(Sender: TObject);
begin
  ClickVentil(False, False);
end;

procedure TFFacture.ClickVentil(LePied, LeStock: Boolean);
var TOBL, {TOBAL,} TOBRef: TOB;
  i, iArt, ind: integer;
begin
  if LePied then
  begin
    if LeStock then
    begin
      TOBRef := TOBAnaS;
      ind := 1;
    end else
    begin
      TOBRef := TOBAnaP;
      ind := 0;
    end;
    YYVentilAna(TOBPiece, TOBRef, Action, ind);
    // modif BTP 28/04/03 : on demande la repercussion sur toutes les lignes.
    // si oui, on ne contrôle plus la présence d'une ventilation précédente
    if PgiAsk(TraduireMemoire('Voulez-vous répercuter la ventilation sur toutes les lignes ?')) = mrYes then
    begin
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        TOBL := TOBPiece.Detail[i];
        if i = 0 then iArt := TOBL.GetNumChamp('GL_ARTICLE') else iArt := 0;
        if TOBL.GetValeur(iArt) = '' then Continue;
        // if TOBL.FieldExists('OUVREANAL') then if TOBL.GetValue('OUVREANAL')='X' then Continue ;
        // TOBAL:=TOBL.Detail[ind] ; if TOBAL.Detail.Count>0 then Continue ;
        if LeStock then PreVentileLigne(nil, nil, TOBAnaS, TOBL) else PreVentileLigne(nil, TOBAnaP, nil, TOBL);
      end;
    end;
  end else
  begin
    ind := 0;
    TOBL := GetTOBLigne(TOBPiece, GS.Row);
    if TOBL = nil then Exit;
    YYVentilAna(TOBL, TOBL.Detail[ind], Action, ind);
  end;
end;

{==============================================================================================}
{===================================== Actions, boutons =======================================}
{==============================================================================================}

procedure TFFacture.BEcheClick(Sender: TObject);
var Ok: Boolean;
begin
  if not BEche.Enabled then Exit;
  if not BEche.Visible then Exit;
  {$IFNDEF CHR}
  if CtxMode in V_PGI.PGIContexte then Ok := GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, True)
  else Ok := GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, True);
  if Ok then GP_MODEREGLE.Value := TOBPiece.GetValue('GP_MODEREGLE');
  {$ENDIF}
end;

procedure TFFacture.ClickSousTotal;
var ARow: integer;
  TOBL: TOB;
begin
  if Action = taConsult then Exit;
  if not BSousTotal.Enabled then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  ARow := GS.Row;
  if ARow <= 1 then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow - 1);
  if TOBL.GetValue('GL_TYPELIGNE') = 'TOT' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL.GetValue('GL_TYPELIGNE') = 'TOT' then Exit;
  ClickInsert(ARow);
  TOBL := GetTOBLigne(TOBPiece, ARow);
  TOBL.PutValue('GL_TYPELIGNE', 'TOT');
  RecalculeSousTotaux(TOBPiece);
end;

procedure TFFacture.BImprimerClick(Sender: TObject);
// modif BTP
var
  {$IFDEF BTP}
  Ret: string;
  i: integer;
  OKAValider: boolean;
  savcol, savrow: integer;
  TypeFacturation: string;
  {$ENDIF}
  imprimeok: boolean;
  // --
begin
  imprimeok := True;
  {$IFDEF BTP}
  SavCol := GS.col;
  SavRow := GS.row;
  NextPrevControl(Self);
  OKAvalider := PieceModifiee;
  ClickValide(True);
  BValider.Enabled := True;
  Ret := AGLLanceFiche('BTP', 'BTPARIMPDOC', '', '', 'NATURE=' + CleDoc.NaturePiece + ';NUMERO=' + inttostr(CleDoc.NumeroPiece) + ';AFFAIRE=' +
    TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if (Ret = '') or (Ret = '0') then
    imprimeok := False;
  {$ENDIF}
  // DEBUT AJOUT CHR
  {$IFNDEF CHR}
  if imprimeok then ImprimerLaPiece(TOBPiece, TOBTiers, CleDoc, True);
  {$IFDEF BTP}
  if OKAValider then
  begin
    if (TOBLigneRG <> nil) and (TOBLigneRg.detail.count > 0) then TOBLigneRG.cleardetail;
    SupLigneRgUnique;
    LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc);
    if TOBPiece.Detail.Count >= GS.RowCount - 1 then
    begin
      if (tModeBlocNotes in SaContexte) then
      begin
        GS.RowCount := TOBPiece.Detail.Count + 2;
        if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
        GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
      end else
      begin
        TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
        if (SaisieTypeAvanc = true) and ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
          GS.RowCount := TOBPiece.Detail.Count + 1;
      end;
    end;
    NumeroteLignesGC(nil, TobPiece);
    for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
    PositionneTOBOrigine;
    InitPasModif;
    if Action = TaCreat then Action := TaModif;
    if Duplicpiece then Duplicpiece := False;
  end;
  GoToLigne(SAvRow, Savcol);
  {$ENDIF}
  {$ENDIF}
  // FIN AJOUT CHR
end;

procedure TFFacture.BSousTotalClick(Sender: TObject);
begin
  ClickSousTotal;
end;

procedure TFFacture.MBtarifClick(Sender: TObject);
begin
  IncidenceTarif;
end;

procedure TFFacture.MajDatesLivr;
var NbSel, NumQ: integer;
  i: integer;
  TOBL: TOB;
  DDLiv: TDateTime;
begin
  NbSel := GS.NbSelected;
  if NbSel > 0 then NumQ := 31 else NumQ := 30;
  if HPiece.Execute(NumQ, Caption, '') <> mrYes then Exit;
  DDLiv := StrToDate(GP_DATELIVRAISON.Text);
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    if ((NbSel = 0) or (GS.IsSelected(i + 1))) then
    begin
      TOBL := TOBPiece.Detail[i];
      if TOBL <> nil then TOBL.PutValue('GL_DATELIVRAISON', DDLiv);
    end;
  end;
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  deselectionneRows;
  {$ENDIF}
end;

procedure TFFacture.MBDatesLivrClick(Sender: TObject);
begin
  MajDatesLivr;
end;

procedure TFFacture.DesoldeLigneSup(Sup: boolean);
var TOBL: TOB;
  NewQte, OldQte: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif) and (not Sup)) then exit;
  NewQte := TOBL.GetValue('GL_QTERELIQUAT');
  OldQte := 0;
  if SG_QS > 0 then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
      OldQte := Valeur(GS.Cells[SG_QS, GS.Row]);
    GS.Cells[SG_QS, GS.Row] := StrF00(NewQte, V_PGI.OkDecQ);
    TraiteQte(SG_QS, GS.Row);
  end;
  if SG_QF > 0 then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
      OldQte := Valeur(GS.Cells[SG_QF, GS.Row]);
    GS.Cells[SG_QF, GS.Row] := StrF00(NewQte, V_PGI.OkDecQ);
    TraiteQte(SG_QF, GS.Row);
  end;
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(SG_QF, GS.Row, False);
  if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then SoldeReliquat;
  if sup then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
    begin
      if TOBL.FieldExists('OLDQTERELIQUAT') then TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('OLDQTERELIQUAT'))
      else TOBL.PutValue('GL_QTERELIQUAT', OldQte);
      if not TOBL.FieldExists('OLDSOLDERELIQUAT') then TOBL.PutValue('GL_SOLDERELIQUAT', TOBL.GetValue('OLDSOLDERELIQUAT'))
      else TOBL.PutValue('GL_SOLDERELIQUAT', '-')
    end;
    if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
    TOBL.PutValue('SUPPRIME', '-');
    AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
  end;
end;

procedure TFFacture.SoldeLigneSup(Sup: boolean);
var TOBL: TOB;
  NewQte, OldQte: Double;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif) and (not Sup)) then exit;
  NewQte := 0;
  OldQte := 0;
  if (TOBL.FieldExists('SUPPRIME')) and (TOBL.GetValue('SUPPRIME') = 'X') then
  begin
    DesoldeLigneSup(Sup);
    exit;
  end;
  if SG_QS > 0 then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
      OldQte := Valeur(GS.Cells[SG_QS, GS.Row]);
    GS.Cells[SG_QS, GS.Row] := StrF00(NewQte, V_PGI.OkDecQ);
    TraiteQte(SG_QS, GS.Row);
  end;
  if SG_QF > 0 then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
      OldQte := Valeur(GS.Cells[SG_QF, GS.Row]);
    GS.Cells[SG_QF, GS.Row] := StrF00(NewQte, V_PGI.OkDecQ);
    TraiteQte(SG_QF, GS.Row);
  end;
  TOBPiece.putvalue('GP_RECALCULER', 'X');
  CalculeLaSaisie(SG_QF, GS.Row, False);
  if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then SoldeReliquat;
  if sup then
  begin
    if ((not TransfoPiece) and (not DuplicPiece) and (Action = taModif)) then
    begin
      if not TOBL.FieldExists('OLDQTERELIQUAT') then TOBL.AddChampSup('OLDQTERELIQUAT', False);
      if not TOBL.FieldExists('OLDSOLDERELIQUAT') then TOBL.AddChampSup('OLDSOLDERELIQUAT', False);
      TOBL.PutValue('OLDQTERELIQUAT', TOBL.GetValue('GL_QTERELIQUAT'));
      TOBL.PutValue('OLDSOLDERELIQUAT', TOBL.GetValue('GL_SOLDERELIQUAT'));
      TOBL.PutValue('GL_QTERELIQUAT', OldQte);
      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
    end;
    if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
    TOBL.PutValue('SUPPRIME', 'X');
    AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
  end;
end;

procedure TFFacture.SoldeReliquat;
var TOBL: TOB;
begin
  if not MBSoldeReliquat.Enabled then Exit;
  if not ReliquatTransfo then Exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  if (CtxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM') = 'GEN') then SoldeReliquatArtDim(TobL, GS.Row)
  else
  begin
    if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
    end else
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
      TOBL.PutValue('SUPPRIME', '-');
    end;
  end;
  GS.InvalidateRow(GS.Row);
end;

procedure TFFacture.SoldeTousReliquat;
var TOBL: TOB;
  i: Integer;
begin
  if not MBSoldeTousReliquat.Enabled then Exit;
  if not ReliquatTransfo then Exit;
  for i := 0 to TOBPiece.Detail.count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if TOBL = nil then Exit;
    if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
    end else
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
      TOBL.PutValue('SUPPRIME', '-');
    end;
    GS.InvalidateRow(i + 1);
  end;
end;

procedure TFFacture.SoldeReliquatArtDim(TOBL: Tob; ARow: integer);
var i: Integer;
  CodeArt: string;
begin
  CodeArt := TOBL.GetValue('GL_REFARTSAISIE');
  i := Arow - 1;
  while TOBL.GetValue('GL_REFARTSAISIE') = CodeArt do
  begin
    if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
    end else
    begin
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
      TOBL.PutValue('SUPPRIME', '-');
    end;
    Inc(i);
    if i > TOBPiece.Detail.count - 1 then exit;
    TOBL := TOBPiece.Detail[i];
  end;
end;

procedure TFFacture.ClickPorcs;
{$IFDEF BTPS5}
var Cf: Double;
  {$ENDIF}
begin
  if (AppelPiedPort(Action, TOBPiece, TOBPorcs) = True) and
    (Action <> taConsult) then
  begin
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
    AffichePorcs;
    {$IFDEF BTPS5}
    // Calcul et affectation coef. de frais
    // => CONDITIONNE SELON LE PARAMETRE GPP_GESTDETFRAIS DANS LA NATURE DE PIECE
    if GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_GESTDETFRAIS') = 'X' then
    begin
      Cf := CalculCoefFrais(TOBPiece, TOBPorcs, DEV);
      if cf <> 1 then SaisiePrixMarche(Cf);
    end;
    {$ENDIF}
  end;
end;

procedure TFFacture.BPorcsClick(Sender: TObject);
begin
  ClickPorcs;
end;

{$IFDEF BTP}

procedure TFFacture.AvancementAcompte;
var X: T_GCAcompte;
  TOBAcc, TOBPieceLoc, TOBLesAcomptes, TOBAcptes, TOBA: TOB;
  StRegle, stModeTraitement: string;
  Indice: integer;
begin
  if LesAcomptes = nil then exit;
  TOBAcptes := TOB.Create('LACOMPTE', nil, -1);
  TOBPieceLoc := TOB.Create('PIECE', nil, -1);

  for Indice := 0 to LesAcomptes.detail.count - 1 do
  begin
    TOBA := TOB.Create('ACOMPTES', TOBAcptes, -1);
    TOBA.Dupliquer(LesAcomptes.detail[Indice], true, true);
  end;

  TOBPieceLoc.Dupliquer(TOBPiece, true, true);
  TobAcc := Tob.Create('Les acomptes', nil, -1);
  StRegle := '';
  Tob.Create('', TobAcc, -1);
  TobAcc.Detail[0].Dupliquer(TobTiers, False, TRUE, TRUE);
  Tob.Create('', TobAcc.Detail[0], -1);
  TobAcc.Detail[0].Detail[0].Dupliquer(TobPieceLoc, False, TRUE, TRUE);
  TheTob := TobAcc;
  TOBAcptes.ChangeParent(TobAcc.Detail[0].Detail[0], -1);
  // Modif BTP
  TheTob.data := TOBPieceRG;
  // ---
  if TOBPiece.GetValue('GP_AFFAIREDEVIS') = '' then stModeTraitement := ';HDEVIS'
  else if RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS')) = 'AVA' then stModeTraitement := ';AVANCEMENT'
  else if RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS')) = 'DAC' then stModeTraitement := ';MEMOIRE'
  else stModeTraitement := ';DIRECTE';
  stModeTraitement := stModetraitement + ';CHOIXSEL';
  AGLLanceFiche('BTP', 'BTACOMPTES', '', '', ActionToString(Action) + StModeTraitement);
  LEsAcomptes.ClearDetail;
  if TOBAcptes.detail.count = 0 then // cas de l'abandon d'application d'acompte
  begin
    for Indice := 0 to TOBAcomptes.detail.count - 1 do
    begin
      TOBA := TOB.Create('ACOMPTES', LesAcomptes, -1);
      TOBA.Dupliquer(TOBAcomptes.detail[Indice], true, true);
      TOBA.putValue('GAC_MONTANT', 0);
      TOBA.putValue('GAC_MONTANTDEV', 0);
      TOBA.putValue('GAC_MONTANTCON', 0);
    end;
  end else
  begin
    for Indice := 0 to TOBAcptes.detail.count - 1 do
    begin
      TOBA := TOB.Create('ACOMPTES', LesAcomptes, -1);
      TOBA.Dupliquer(TOBAcptes.detail[Indice], true, true);
    end;
  end;
  TobAcc.Free;
  TobAcc := nil;
  TOBPieceLoc.free;
end;
{$ENDIF}

procedure TFFacture.ClickAcompte(ForcerRegle: Boolean);
var TOBAcc: TOB;
  StRegle: string;
begin
  TobAcc := Tob.Create('Les acomptes', nil, -1);
  StRegle := '';
  Tob.Create('', TobAcc, -1);
  TobAcc.Detail[0].Dupliquer(TobTiers, False, TRUE, TRUE);
  Tob.Create('', TobAcc.Detail[0], -1);
  TobAcc.Detail[0].Detail[0].Dupliquer(TobPiece, False, TRUE, TRUE);
  TheTob := TobAcc;
  TOBAcomptes.ChangeParent(TobAcc.Detail[0].Detail[0], -1);
  // Modif BTP
  TheTob.data := TOBPieceRG;
  // ---
  if ForcerRegle then StRegle := ';ISREGLEMENT=X';
  {$IFDEF BTP}
  AGLLanceFiche('BTP', 'BTACOMPTES', '', '', ActionToString(Action) + StRegle);
  {$ELSE}
  AGLLanceFiche('GC', 'GCACOMPTES', '', '', ActionToString(Action) + StRegle);
  {$ENDIF}
  TOBAcomptes.ChangeParent(nil, -1);
  TobAcc.Free;
  AcomptesVersPiece(TOBAcomptes, TOBPiece);
  GP_ACOMPTEDEV.Value := TOBPiece.GetValue('GP_ACOMPTEDEV');
end;

procedure TFFacture.BAcompteClick(Sender: TObject);
begin
  ClickAcompte(False);
end;

procedure TFFacture.MBSoldeReliquatClick(Sender: TObject);
begin
  SoldeReliquat;
end;

procedure TFFacture.MBSoldeTousReliquatClick(Sender: TObject);
begin
  SoldeTousReliquat;
end;

procedure TFFacture.BZoomPrecedenteClick(Sender: TObject);
begin
  ClickPrecedente;
end;

procedure TFFacture.BZoomSuivanteClick(Sender: TObject);
begin
  ClickSuivante;
end;

procedure TFFacture.BZoomOrigineClick(Sender: TObject);
begin
  ClickOrigine;
end;

procedure TFFacture.DetruitLaPiece; { NEWPIECE }
var OldEcr, OldStk: RMVT;
  {$IFDEF BTP}
  nb: integer;
  {$ENDIF}
begin
  { NEWPIECE }
  UpdateResteALivrer(TobPiece, TobPiece_O, TOBArticles, TOBCatalogu, TOBN_O, urSuppr); { NEWPIECE }
  if V_PGI.IoError = oeOk then
  begin
    if not DetruitAncien(TOBPiece_O, TOBBases_O, TOBEches_O, TOBN_O, TOBLOT_O, TOBAcomptes_O, TOBPorcs_O, TOBSerie_O, TOBOuvrage_O, TOBLienOle_O, TOBPieceRG_O,
      TOBBasesRg_O, True) then
      V_PGI.IoError := oeUnknown;
    {$IFDEF BTP}
    if (TOBPiece_O.GetValue('GP_AFFAIREDEVIS') <> '') and (copy(TOBPiece_O.GetValue('GP_AFFAIREDEVIS'), 1, 1) = 'Z') and
      (GetParamSoc('SO_AFNATAFFAIRE') = TOBPiece_O.GetValue('GP_NATUREPIECEG')) then
    begin
      // on ne supprime que si l'on est sur la piece ayant crée l'affaire du devis
      Nb := ExecuteSQL('DELETE FROM AFFAIRE WHERE AFF_AFFAIRE="' + TOBPiece_O.GetValue('GP_AFFAIREDEVIS') + '"');
      if Nb <= 0 then
      begin
        V_PGI.IoError := oeUnknown;
        Exit;
      end;
      if not ControleAffaireRef(TOBPiece_O.GetValue('GP_AFFAIRE')) then
      begin
        V_PGI.IoError := oeUnknown;
        Exit;
      end;
    end;
    if not SupprimeSituation(TOBPiece, TOBPieceRG, TOBBasesRG, TOBAcomptes, DEV) then
    begin
      V_PGI.IoError := oeUnknown;
      Exit;
    end;
    // suppression dans BTPARDOC
    ExecuteSQL('DELETE FROM BTPARDOC WHERE BPD_NATUREPIECE="' + TOBPiece_O.GetValue('GP_NATUREPIECEG') + '" AND BPD_SOUCHE="' + TOBPiece_O.GetValue('GP_SOUCHE')
      + '" AND BPD_NUMPIECE=' + IntToStr(TOBPiece_O.GetValue('GP_NUMERO')));
    {$ENDIF}
    // ----
    if V_PGI.IoError = oeOk then InverseStock(TOBPiece_O, TOBArticles, TOBCatalogu, TOBN_O);
    if V_PGI.IoError = oeOk then InverseStockSerie(TOBPiece_O, TOBSerie_O); { NEWPIECE }
    if V_PGI.IoError = oeOk then DetruitCompta(TOBPiece_O, OldEcr, OldStk);
    if V_PGI.IoError = oeOk then ValideLesArticles(TOBPiece_O, TOBArticles);
    if V_PGI.IoError = oeOk then ValideLesCatalogues(TOBPiece_O, TOBCatalogu);
    {$IFDEF AFFAIRE}
    if V_PGI.IoError = oeOk then ValideActivite(nil, TOBPiece_O, TOBArticles, GereActivite, False, DelActivite);
    {$ENDIF}
  end;
end;

procedure TFFacture.BDeleteClick(Sender: TObject); { NEWPIECE }
var
  St: string;
  NumL: Integer;
begin
  if CanDeletePiece(TobPiece, NumL) then
  begin
    if HPiece.Execute(29, caption, '') <> mrYes then Exit;
    if Transactions(DetruitLaPiece, 1) <> oeOk then
    begin
      MessageAlerte(HTitres.Mess[20]);
    end
    else
    begin
      St := 'Pièce N° ' + IntToStr(TOBPiece_O.GetValue('GP_NUMERO'))
        + ', Indice ' + IntToStr(TOBPiece_O.GetValue('GP_INDICEG'))
        + ', Date ' + DateToStr(TOBPiece_O.GetValue('GP_DATEPIECE'))
        + ', Tiers ' + TOBPiece_O.GetValue('GP_TIERS')
        + ', Total HT de ' + StrfPoint(TOBPiece_O.GetValue('GP_TOTALHTDEV')) + ' ' + RechDom('TTDEVISETOUTES', TOBPiece_O.GetValue('GP_DEVISE'), False);
      AjouteEvent(TOBPiece_O.GetValue('GP_NATUREPIECEG'), St, 1);
      ForcerFerme := True;
      Close
    end;
  end;
end;

procedure TFFacture.AjouteEvent(NatureP, MessEvent: string; QuelCas: integer);
var QQ: TQuery;
  MotifPiece: TStrings;
  NumEvent: integer;
  LeLibelle: string;
begin
  case QuelCas of
    1: LeLibelle := Copy('Suppression de ' + RechDom('GCNATUREPIECEG', NatureP, False), 1, 35);
    2: LeLibelle := Copy('Validation de ' + RechDom('GCNATUREPIECEG', NatureP, False), 1, 35);
    3: LeLibelle := Copy('Impression de ' + RechDom('GCNATUREPIECEG', NatureP, False), 1, 35);
  end;

  MotifPiece := TStringList.Create;
  MotifPiece.Add(MessEvent);
  NumEvent := 0;
  QQ := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True);
  if not QQ.EOF then NumEvent := QQ.Fields[0].AsInteger;
  Ferme(QQ);
  Inc(NumEvent);
  QQ := OpenSQL('SELECT * FROM JNALEVENT WHERE GEV_TYPEEVENT="GEN" AND GEV_NUMEVENT=-1', False);
  QQ.Insert;
  InitNew(QQ);
  QQ.FindField('GEV_NUMEVENT').AsInteger := NumEvent;
  QQ.FindField('GEV_TYPEEVENT').AsString := 'SPI';
  QQ.FindField('GEV_LIBELLE').AsString := LeLibelle;
  QQ.FindField('GEV_DATEEVENT').AsDateTime := Date;
  QQ.FindField('GEV_UTILISATEUR').AsString := V_PGI.User;
  QQ.FindField('GEV_ETATEVENT').AsString := 'OK';
  TMemoField(QQ.FindField('GEV_BLOCNOTE')).Assign(MotifPiece);
  QQ.Post;
  Ferme(QQ);
  MotifPiece.Free;
end;

procedure TFFacture.ClickSuivante;
var StSuiv: string;
  CD: R_CleDoc;
begin
  StSuiv := TOBPiece.GetValue('GP_DEVENIRPIECE');
  if StSuiv = '' then Exit;
  DecodeRefPiece(StSuiv, CD);
  if not ExistePiece(CD) then ShowPiecePasHisto(CD, True)
  else
  begin
    SauveColList;
    SaisiePiece(CD, taConsult);
    RestoreColList;
  end;
end;

procedure TFFacture.ClickPrecedente;
var TOBL: TOB;
  StPrec: string;
  CD: R_CleDoc;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  StPrec := TOBL.GetValue('GL_PIECEPRECEDENTE');
  if StPrec = '' then Exit;
  DecodeRefPiece(StPrec, CD);
  if not ExistePiece(CD) then ShowPiecePasHisto(CD, True)
  else
  begin
    SauveColList;
    SaisiePiece(CD, taConsult);
    RestoreColList;
  end;
end;

procedure TFFacture.ClickOrigine;
var TOBL: TOB;
  StOri: string;
  CD: R_CleDoc;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  StOri := TOBL.GetValue('GL_PIECEORIGINE');
  if StOri = '' then Exit;
  DecodeRefPiece(StOri, CD);
  if not ExistePiece(CD) then ShowPiecePasHisto(CD, False)
  else
  begin
    SauveColList;
    SaisiePiece(CD, taConsult);
    RestoreColList;
  end;
end;

procedure TFFacture.ClickDel(ARow: integer; AvecC, FromUser: Boolean; SupDim: Boolean = False);
var RefUnique, CodeArticle, RefCata, TypeDim: string;
  bc, cancel: boolean;
  ACol, LaLig, i: integer;
  TOBL, TOBCATA: TOB;
  QTE: Double;
begin
  if Action = taConsult then Exit;
  if ((ARow < 1) or (ARow > TOBPiece.Detail.Count)) then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RefUnique := '';
  CodeArticle := '';
  RefCata := '';
  if TOBL.GetValue('GL_TYPEREF') = 'CAT' then
  begin
    RefCata := TOBL.Getvalue('GL_REFCATALOGUE');
    TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
    if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, False);
  end else
  begin
    RefUnique := TOBL.Getvalue('GL_ARTICLE');
    CodeArticle := TOBL.GetValue('GL_CODESDIM');
  end;
  TypeDim := TOBL.GetValue('GL_TYPEDIM');
  Qte := TOBL.GetValue('GL_QTEFACT');
  DetruitLot(ARow);
  // Modif BTP
  if GS.IsSelected(Arow) then Deselectionne(Arow);
  // -----
  DetruitSerie(ARow);
  GS.CacheEdit;
  GS.SynEnabled := False;
  if (TOBL.GetValue('GL_TYPEARTICLE') = 'OUV') then SuppressionDetailOuvrage(Arow);
  GS.DeleteRow(ARow);
  if ((TOBPiece.Detail.Count > 1) and (ARow <> TOBPiece.Detail.Count)) then TOBPiece.Detail[ARow - 1].Free else
  begin
    TOBPiece.Detail[ARow - 1].InitValeurs;
    InitLesSupLigne(TOBPiece.Detail[ARow - 1]);
  end;
  if (TOBPiece.Detail.Count > 0) then GS.RowHeights[TOBPiece.Detail.Count] := GS.DefaultRowHeight;
  // modif BTP
  if (tModeBlocNotes in SaContexte) then
  begin
    if GS.RowCount < NbRowsInit then GS.RowCount := GS.RowCount + NbRowsPlus;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
    GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount); //MODIFBTP140301
  end else
  begin
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
  end;
  // --
  GS.MontreEdit;
  GS.SynEnabled := true;
  if (SupDim) and (TypeDim <> 'NOR') then MiseAJourGrid(GS, TOBPiece, Trim(Copy(RefUnique, 1, 18)), QTE, ARow);
  NumeroteLignesGC(GS, TOBPiece);
  bc := False;
  Cancel := False;
  ACol := GS.fixedcols;
  GSRowEnter(GS, ARow, bc, False);
  GSCellEnter(GS, ACol, ARow, Cancel);
  GS.col := ACol;
  GS.row := Arow;
  ShowDetail(ARow);
  if ((AvecC) and ((RefUnique <> '') or (RefCata <> ''))) then
  begin
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
  end;
  if ((CodeArticle <> '') and (TypeDim = 'GEN') and (FromUser)) then
  begin
    repeat
      TOBL := TOBPiece.FindFirst(['GL_CODEARTICLE', 'GL_TYPEDIM'], [CodeArticle, 'DIM'], False);
      if TOBL <> nil then
      begin
        LaLig := TOBL.GetValue('GL_NUMLIGNE');
        ClickDel(LaLig, False, False);
      end;
    until TOBL = nil;
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
  end;
  if DimSaisie = 'DIM' then for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then GS.RowHeights[i + 1] := 0 else GS.RowHeights[i + 1] := GS.DefaultRowHeight;
    end;
  if ctxMode in V_PGI.PGIContexte then AffichageDim;
end;

procedure TFFacture.InsertComment(Ent: Boolean);
var PosDep: integer;
  StComm, StC, LeCom, StLoc: string;
  TOBL: TOB;
begin
  if Ent then
  begin
    StLoc := CommentEnt;
    PosDep := 1;
  end
  else
  begin
    StLoc := CommentPied;
    PosDep := TOBPiece.Detail.Count + 1;
  end;
  StComm := '';
  repeat
    StC := ReadTokenSt(StLoc);
    if StC <> '' then StComm := StC + ';' + StComm;
  until ((StLoc = '') or (StC = ''));
  if not Ent then
  begin
    GS.RowCount := GS.RowCount + 1;
    CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TOBPiece.Detail.Count + 2);
  end;
  repeat
    StC := ReadTokenSt(StComm);
    if StC <> '' then
    begin
      if Ent then LeCom := RechDom('GCCOMMENTAIREENT', StC, False) else LeCom := RechDom('GCCOMMENTAIREPIED', StC, False);
      ClickInsert(PosDep);
      TOBL := GetTOBLigne(TOBPiece, PosDep);
      TOBL.PutValue('GL_LIBELLE', LeCom);
      AfficheLaLigne(PosDep);
    end;
  until ((StC = '') or (StComm = ''));
end;

procedure TFFacture.TCommentEntClick(Sender: TObject);
begin
  if (tModeBlocNotes in SaContexte) then
  begin
    SB.VertScrollBar.position := 0;
    Debut.SetFocus;
  end else InsertComment(True);
end;

procedure TFFacture.TCommentPiedClick(Sender: TObject);
begin
  if (tModeBlocNotes in SaContexte) then
  begin
    SB.VertScrollBar.position := Debut.Height + GS.Height + Fin.Height;
    Fin.SetFocus;
  end else InsertComment(False);
end;

procedure TFFacture.TInsLigneClick(Sender: TObject);
begin
  ClickInsert(GS.Row);
end;

procedure TFFacture.TSupLigneClick(Sender: TObject);
var TypeL, PiecePrec, TenueStock, TypeArt, OldNat, NatAnnul, ColPlus, ColMoins: string;
  NivCou, NivDeb: integer;
  TobLigne: Tob; { NEWPIECE }
  {$IFDEF BTP}
  TypeFac: string;
  {$ENDIF}
begin
  {$IFDEF CHR}
  TypeArt := GetChampLigne(TOBPiece, 'GL_ARTICLE', GS.Row);
  if (TypeArt <> '') then
  begin
    Supp_Commentaire := False;
    exit;
  end else Supp_Commentaire := True;
  {$ENDIF}
  // Modif BTP
  if (IsLigneDetail(TOBPiece, nil, GS.row)) then exit;
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  {$IFDEF BTP}
  if OrigineEXCEL then exit;
  {$ENDIF}
  { Interdit la suppression des lignes si il y a des lignes suivantes }
  TobLigne := GetTOBLigne(TOBPiece, GS.Row); { NEWPIECE }
  if Assigned(TobLigne) and WithPieceSuivante(TobLigne) then
  begin
    HPiece.Execute(52, Caption, '');
    EXIT;
  end;
  // --
  TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', GS.Row);
  {$IFDEF BTP}
  // En modif. de situation, suppression autorisée uniquement
  // pour les lignes de commentaires
  TypeFac := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (TypeFac = 'AVA')) or
    ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC') and (TypeFac = 'DAC')) then
  begin
    if TypeL <> 'COM' then Exit;
  end;
  {$ENDIF}
  TypeArt := GetChampLigne(TOBPiece, 'GL_TYPEARTICLE', GS.Row);
  PiecePrec := GetChampLigne(TOBPiece, 'GL_PIECEPRECEDENTE', GS.Row);
  if TypeArt = 'NOM' then TenueStock := 'X' else TenueStock := GetChampLigne(TOBPiece, 'GL_TENUESTOCK', GS.Row);
  if ((TypeL = 'ART') and (PiecePrec <> '') and (TenueStock = 'X')) then
  begin
    ReadTokenSt(PiecePrec);
    OldNat := ReadTokenSt(PiecePrec);
    ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
    if ((ColPlus <> '') or (ColMoins <> '')) then
    begin
      NatAnnul := (GetinfoParPiece(OldNat, 'GPP_NATPIECEANNUL'));
      if (NatAnnul = '') or (NatAnnul = #0) then SoldeLigneSup(False) else SoldeLigneSup(True);
      exit;
    end;
  end;
  // Modif BTP
  if ((Copy(TypeL, 1, 2) <> 'DP') and (Copy(TypeL, 1, 2) <> 'TP')) then
  begin
    ClickDel(GS.Row, True, True, True);
  end else if Copy(TypeL, 1, 2) = 'DP' then
  begin
    if HPiece.Execute(35, caption, '') = mrYes then
    begin
      NivDeb := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', GS.ROW);
      repeat
        if TypeL <> 'TOT' then ClickDel(GS.Row, True, True, True) else GS.Row := GS.Row + 1;
        NivCou := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', GS.Row);
        TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', GS.Row);
        if TypeL = 'TOT' then NivCou := NivDeb;
      until ((NivCou < NivDeb) or (TypeL = 'TP' + IntToStr(NivDeb)) or (TOBPiece.Detail.Count <= 0));
      if TypeL = 'TP' + IntToStr(NivDeb) then ClickDel(GS.Row, True, True, True);
    end;
  end;
  // --
  if BArborescence.Down = True then BArborescenceClick(Self);
  // --
end;

procedure TFFacture.ClickInsert(ARow: integer);
// Modif BTP
var ACol: integer;
  Cancel: boolean;
begin
  if Action = taConsult then Exit;
  if ((ARow < 1) or (ARow > TOBPiece.Detail.Count)) then Exit;
  // Modif BTP
  if (IsLigneDetail(TOBPiece, nil, Arow)) then exit;
  {$IFDEF BTP}
  if OrigineEXCEL then exit;
  {$ENDIF}
  // -------
  GS.CacheEdit;
  GS.SynEnabled := False;
  InsertTOBLigne(TOBPiece, ARow);
  GS.InsertRow(ARow);
  InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
  GS.Row := ARow;
  GS.MontreEdit;
  GS.SynEnabled := True;
  if (tModeBlocNotes in SaContexte) then
  begin
    // Mise à jour de la taille du grid
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
    GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount); //MODIFBTP140301
    // Positionnement sur la première colonne de saisie possible de la nouvelle ligne
    GS.Col := 1;
    ACol := 0;
    ZoneSuivanteOuOk(ACol, ARow, Cancel);
    GS.Col := ACol;
    GS.Row := ARow;
  end;
  NumeroteLignesGC(GS, TOBPiece);
  ShowDetail(ARow);
end;

procedure TFFacture.BZoomArticleClick(Sender: TObject);
var RefUnique: string;
  TOBA: TOB;
begin
  if not BZoomArticle.Enabled then Exit;
  RefUnique := GetCodeArtUnique(TOBPiece, GS.Row);
  if RefUnique = '' then exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, GS.Row);
  ZoomArticle(RefUnique, TobA.GetValue('GA_TYPEARTICLE'), Action);
end;

procedure TFFacture.BMenuZoomMouseEnter(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  PopZoom97(BMenuZoom, POPZ);
end;

procedure TFFacture.ClickDevise;
begin
  if GP_DEVISE.Value = '' then Exit;
  {$IFNDEF SANSCOMPTA}
  FicheDevise(GP_DEVISE.Value, taConsult, False);
  {$ENDIF}
end;

procedure TFFacture.BZoomDeviseClick(Sender: TObject);
begin
  ClickDevise;
end;

procedure TFFacture.BZoomTarifClick(Sender: TObject);
//Var CodeTar : integer ;
begin
  {if Not BZoomTarif.Enabled then Exit ;
  CodeTar:=GetChampLigne(TOBPiece,'GL_TARIF',GS.Row) ;
  if CodeTar<>0 then FicheTarif(Nil,CodeTar,taConsult,0) ;}
end;

procedure TFFacture.BZoomCommercialClick(Sender: TObject);
begin
  ZoomRepres(GP_REPRESENTANT.Text);
end;

procedure TFFacture.BZoomTiersClick(Sender: TObject);
begin
  if ctxAffaire in V_PGI.PGIContexte then
  begin
    {$IFDEF BTP}
    V_PGI.DispatchTT(8, taConsult, TOBTiers.GetValue('T_AUXILIAIRE'), '', '');
    {$ELSE}
    // mcd 16/09/02 pour OK fournissuer V_PGI.DispatchTT( 8, taConsult, TOBTiers.GetValue('T_TIERS'), '', '') ;
    if VenteAchat = 'ACH' then V_PGI.DispatchTT(12, taConsult, TOBTiers.GetValue('T_TIERS'), '', '')
    else V_PGI.DispatchTT(8, taConsult, TOBTiers.GetValue('T_TIERS'), '', '');
    {$ENDIF}
  end else
  begin
    if VenteAchat = 'ACH' then AGLLanceFiche('GC', 'GCFOURNISSEUR', '', TOBTiers.GetValue('T_AUXILIAIRE'), 'ACTION=CONSULTATION;MONOFICHE')
    else
      AGLLanceFiche('GC', 'GCTIERS', '', TOBTiers.GetValue('T_AUXILIAIRE'), 'ACTION=CONSULTATION;MONOFICHE;T_NATUREAUXI=' + TOBTiers.GetValue('T_NATUREAUXI'));
  end;
end;

procedure TFFacture.BZoomAffaireClick(Sender: TObject);
begin
  ZoomAffaire(GP_AFFAIRE.Text);
end;

procedure TFFacture.BZoomEcritureClick(Sender: TObject);
begin
  ZoomEcriture(False);
end;

procedure TFFacture.CpltEnteteClick(Sender: TObject);
var stComp, ModeRegle_O, Ressource_O: string;
  i: integer;
  {$IFDEF BTP}
  Familletaxe, Regimetaxe: string;
  {$ENDIF}
begin
  ModeRegle_O := TobPiece.GetValue('GP_MODEREGLE');
  Ressource_O := TobPiece.GetValue('GP_RESSOURCE');
  TheTob := TobPiece;
  TobPiece.data := TobAdresses;
  // Modif BTP
  {$IFDEF BTP}
  stComp := '';
  FamilleTaxe := TOBPIECE.Getvalue('FAMILLETAXE1');
  RegimeTaxe := TOBPIECE.Getvalue('GP_REGIMETAXE');
  if SaisieTypeAffaire then stComp := ';ENTETEAFFAIREPIECE';
  if (TobTiers.GetValue('T_PARTICULIER') = 'X') then stComp := stComp + ';PARTICULIER';
  AGLLanceFiche('BTP', 'BTCOMPLPIECE', '', '', ActionToString(Action) + stComp);
  LIBELLETIERS.Caption := TOBAdresses.Detail[1].Getvalue('ADR_LIBELLE');
  {$ELSE}
  //
  if (ctxAffaire in V_PGI.PGIContexte) or (SaisieTypeAffaire) then
  begin
    stComp := '';
    if SaisieTypeAffaire then stComp := ';ENTETEAFFAIREPIECE';
    if (TobTiers.GetValue('T_PARTICULIER') = 'X') then stComp := stComp + ';PARTICULIER';
    AGLLanceFiche('AFF', 'AFCOMPLPIECE', '', '', ActionToString(Action) + stComp);
  end else
  begin
    AGLLanceFiche('GC', 'GCCOMPLPIECE', '', '', ActionToString(Action));
  end;
  {$ENDIF}
  if ((TheTob <> nil) and (Action <> taConsult)) then
  begin
    ChangeComplEntete := True;
    TOBPiece.PutEcran(Self, PEntete);
    if ctxAffaire in V_PGI.PGIContexte then TOBPiece.PutEcran(Self, PEnteteAffaire);
    for i := 0 to TobPiece.detail.count - 1 do
    begin
      TobPiece.detail[i].putValue('GL_TIERSLIVRE', TobPiece.getValue('GP_TIERSLIVRE'));
      TobPiece.detail[i].putValue('GL_TIERSFACTURE', TobPiece.getValue('GP_TIERSFACTURE'));
    end;
    // Verif si le mode de règlement a été modifié dans l'entête (affaire uniquement)
    if ctxAffaire in V_PGI.PGIContexte then
    begin
      if (ModeRegle_O <> TobPiece.GetValue('GP_MODEREGLE')) and (TOBEches.Detail.Count > 0) then
        TOBEches.ClearDetail;
    end;
    if Ressource_O <> TobPiece.GetValue('GP_RESSOURCE') then PieceVersLigneRessource(TOBPiece, nil, Ressource_O);
    ChangeComplEntete := False;
    {$IFDEF BTP}
    if TheTOB.getValue('FAMILLETAXE1') <> '' then
    begin
      AppliqueChangeTaxe(0);
      TOBPIECE.Putvalue('FAMILLETAXE1', '');
      CalculeLaSaisie(-1, GS.Row, False);
    end;
    if TOBPiece.getValue('GP_REGIMETAXE') <> RegimeTaxe then
    begin
      PutValueDetailOuv(TOBOuvrage, 'BLO_REGIMETAXE', TOBPiece.getValue('GP_REGIMETAXE'));
      AppliqueChangeTaxe(0);
      CalculeLaSaisie(-1, GS.Row, False);
    end;
    {$ENDIF}
  end;
  TheTob := nil;
  TobPiece.data := nil;
end;

procedure TFFacture.MBDetailNomenClick(Sender: TObject);
var TOBL, TOBNomen: TOB;
  IndiceNomen: integer;
  {$IFDEF BTP}
  Valeurs: T_Valeurs;
  Taction: TActionFiche;
  EnHt: Boolean;
  OkTrait: boolean;
  Xp, XE: double;
  {$ENDIF}
  // -----
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
  if IndiceNomen <= 0 then Exit;
  if TOBL.getValue('GL_TYPEARTICLE') = 'NOM' then
  begin
    TOBNomen := TOBNomenclature.Detail[IndiceNomen - 1];
    if TOBNomen = nil then Exit;
    Entree_LigneNomen(TOBNomen, TobArticles, False, 1, 0);
    RenseigneValoNomen(TOBL, TOBNomen);
  end else
  begin
    {$IFDEF BTP}
    // Ouvrages
    if Action = taconsult then Taction := taconsult else Taction := taModif;
    TOBNomen := TOBOuvrage.Detail[IndiceNomen - 1];
    if TOBNomen = nil then Exit;
    EnHT := (TOBPiece.GetValue('GP_FACTUREHT') = 'X');
    OkTrait := Entree_LigneOuv(TOBNomen, TobArticles, TOBL, False, 1, 0, DEV, TOBL.GetValue('GL_QUALIFQTEVTE'), valeurs, Taction, Enht);
    if (not (action = taconsult)) and (OKtrait) then
    begin
      TOBL.Putvalue('GL_PUHTDEV', valeurs[2]);
      TOBL.Putvalue('GL_PUTTCDEV', valeurs[3]);
      TOBL.Putvalue('GL_DPA', valeurs[0]);
      TOBL.Putvalue('GL_DPR', valeurs[1]);
      TOBL.Putvalue('GL_PMAP', valeurs[6]);
      TOBL.Putvalue('GL_PMRP', valeurs[7]);
      CalculeMontantsAssocie(TOBL.Getvalue('GL_PUHTDEV'), XP, XE, DEV, (TOBL.GetValue('GL_SAISIECONTRE') = 'X'));
      TOBL.Putvalue('GL_PUHT', XP);
      TOBL.Putvalue('GL_PUHTCON', XE);
      CalculeMontantsAssocie(TOBL.Getvalue('GL_PUTTCDEV'), XP, XE, DEV, (TOBL.GetValue('GL_SAISIECONTRE') = 'X'));
      TOBL.Putvalue('GL_PUTTC', XP);
      TOBL.Putvalue('GL_PUTTCCON', XE);
      TOBPIece.putvalue('GP_RECALCULER', 'X');
      TOBL.PutValue('GL_RECALCULER', 'X');
      CalculeLaSaisie(-1, GS.row, False);
      AfficheLaLigne(GS.row);
      GestionDetailOuvrage(GS.row);
    end;
    {$ENDIF}
  end;
end;

procedure TFFacture.MBDetailLotClick(Sender: TObject);
var TOBL, TOBA, TOBDepot, TOBNoeud, TOBN, TOBPlat: TOB;
  IndiceLot, IndiceSerie, IndiceNomen, i_ind: integer;
  Depot, RefUnique: string;
  OkSerie: boolean;
  Qte, QteN, NbCompoSerie, QteRel: double;
begin
  {$IFDEF CCS3}
  Exit;
  {$ELSE}
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  IndiceLot := TOBL.GetValue('GL_INDICELOT');
  IndiceSerie := TOBL.GetValue('GL_INDICESERIE');
  if (IndiceLot <= 0) and (IndiceSerie <= 0) then Exit;
  if Action = taConsult then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, GS.Row);
    if TOBA = nil then Exit;
    if IndiceLot > 0 then
    begin
      Depot := TOBL.GetValue('GL_DEPOT');
      TOBDepot := TOBA.FindFirst(['GQ_DEPOT'], [Depot], False);
      if TOBDepot = nil then Exit;
      TOBNoeud := TOBDesLots.Detail[IndiceLot - 1];
      OkSerie := (GereSerie) and (TOBA.GetValue('GA_NUMEROSERIE') = 'X');
      GS.CacheEdit;
      GS.SynEnabled := False;
      Entree_LigDispolot(TOBDepot, TOBNoeud, TOBL, TobSerie, OkSerie, Action);
      GS.MontreEdit;
      GS.SynEnabled := True;
    end else if IndiceSerie > 0 then
    begin
      Qte := TOBL.GetValue('GL_QTESTOCK');
      QteRel := TOBL.GetValue('GL_QTERELIQUAT');
      if ((TOBL.GetValue('GL_TYPEARTICLE') = 'NOM') and (TOBL.GetValue('GL_TYPENOMENC') = 'ASS')) then
      begin // Nomenclatures
        IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
        if IndiceNomen <= 0 then exit;
        if TOBNomenclature = nil then Exit;
        if TOBNomenclature.Detail.Count - 1 < IndiceNomen - 1 then Exit;
        TOBN := TOBNomenclature.Detail[IndiceNomen - 1];
        TOBPlat := TOB.Create('', nil, -1);
        NomenAPlat(TOBN, TOBPlat, 1);
        NbCompoSerie := 0;
        for i_ind := TOBPlat.Detail.Count - 1 downto 0 do
        begin
          RefUnique := TOBPlat.Detail[i_ind].GetValue('GLN_ARTICLE');
          TOBA := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False);
          if TOBA = nil then
          begin
            TOBPlat.Detail[i_ind].Free;
            Continue;
          end;
          if TOBA.GetValue('GA_NUMEROSERIE') <> 'X' then
          begin
            TOBPlat.Detail[i_ind].Free;
            Continue;
          end;
          QteN := TOBPlat.Detail[i_ind].GetValue('GLN_QTE');
          NbCompoSerie := NbCompoSerie + QteN;
          TOBPlat.Detail[i_ind].PutValue('GLN_QTE', Qte * QteN);
          if not TOBPlat.Detail[i_ind].FieldExists('QTERELIQUAT') then
            TOBPlat.Detail[i_ind].AddChampSup('QTERELIQUAT', False);
          TOBPlat.Detail[i_ind].PutValue('QTERELIQUAT', QteRel * QteN);
        end;
        if (TOBPlat.Detail.Count = 0) or (NbCompoSerie = 0) then exit;
      end else
      begin
        TOBPlat := nil;
      end;
      GS.CacheEdit;
      GS.SynEnabled := False;
      Entree_SaisiSerie(TOBL, TOBPlat, TOBSerie, TOBSerie_O, TOBSerRel, Action);
      GS.MontreEdit;
      GS.SynEnabled := True;
      if TOBPlat <> nil then TOBPlat.Free;
    end;
  end else
  begin
    if IndiceLot > 0 then
    begin
      if not TOBL.FieldExists('QTECHANGE') then TOBL.AddChampSup('QTECHANGE', False);
      TOBL.PutValue('QTECHANGE', 'X');
      GereLesLots(GS.Row)
    end else if IndiceSerie > 0 then
    begin
      if not TOBL.FieldExists('QTECHANGE') then TOBL.AddChampSup('QTECHANGE', False);
      TOBL.PutValue('QTECHANGE', 'X');
      GereLesSeries(GS.Row);
    end;
  end;
  {$ENDIF}
end;

procedure TFFacture.CpltLigneClick(Sender: TObject);
// Modif BTP
var
  {$IFDEF BTP}
  Ancpv, AncQte: double;
  IndiceNomen: Integer;
  TOBNomen: TOB;
  IndicePv: Integer;
  AncCodeTva: string;
  MontantInterm: double;
  EnHt: boolean;
  {$ENDIF}
  stArg: string;
begin
  if (IsLigneDetail(TOBPiece, nil, GS.row)) then exit;
  TheTOB := GetTOBLigne(TOBPiece, GS.Row);
  // Modif Btp
  {$IFDEF BTP}
  EnHT := (TOBPiece.GetValue('GP_FACTUREHT') = 'X');
  if (TheTOB.GetValue('GL_TYPEARTICLE') = 'OUV') then TheTob.PutValue('GL_FAMILLETAXE1', '');
  ancCodeTva := TheTob.getValue('GL_FAMILLETAXE1');
  ancqte := TheTob.getValue('GL_QTEFACT');
  if EnHt then IndicePv := TheTob.GetNumChamp('GL_PUHTDEV')
  else IndicePv := TheTob.GetNumChamp('GL_PUTTCDEV');
  ancpv := TheTOB.getValeur(IndicePv);
  AGLLanceFiche('BTP', 'BTCOMPLLIGNE', '', '', ActionToString(Action));
  {$ELSE}
  stArg := ActionToString(Action);
  {$IFDEF CEGID}
  if sender = nil then stArg := stArg + ';FORCEINFO';
  {$ENDIF}
  if (ctxAffaire in V_PGI.PGIContexte) or (SaisieTypeAffaire) then
    AGLLanceFiche('AFF', 'AFCOMPLLIGNE', '', '', stArg)
  else
    AGLLanceFiche('GC', 'GCCOMPLLIGNE', '', '', stArg);
  {$ENDIF}
  if ((TheTob <> nil) and (Action <> taConsult)) then
  begin
    TheTOB.PutLigneGrid(GS, GS.Row, False, False, LesColonnes);
    {$IFDEF BTP}
    if (TheTob.GetValue('GL_FAMILLETAXE1') <> AncCodeTva) then AppliqueChangeTaxe(GS.row);
    //
    if (copy(TheTOB.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP') or
      (copy(TheTOB.GetValue('GL_TYPEARTICLE'), 1, 2) = 'OU')
      then TheTOB.PutValue('GL_FAMILLETAXE1', '');
    //
    if (TheTOB.getValue('GL_TYPEARTICLE') = 'OUV') and
      ((ancpv <> TheTob.GetValeur(IndicePv)) or (ancqte <> TheTob.GetValue('GL_QTEFACT'))) then
    begin
      IndiceNomen := TheTob.GetValue('GL_INDICENOMEN');
      if IndiceNomen > 0 then
      begin
        TOBNomen := TOBOuvrage.Detail[IndiceNomen - 1];
        if (ancpv <> TheTob.Getvaleur(indicepv)) then
        begin
          MontantInterm := TheTob.GetValeur(IndicePv);
          ReajusteMontantOuvrage(TOBNomen, ancpv, MontantInterm, DEV, EnHt, true);
          TheTob.PutValeur(IndicePv, MontantInterm);
          TOBPIece.putvalue('GP_RECALCULER', 'X');
          TheTob.PutValue('GL_RECALCULER', 'X');
        end;
        GestionDetailOuvrage(GS.row);
      end;
    end;
    {$ENDIF}
    if (ctxAffaire in V_PGI.PGIContexte) or (SaisieTypeAffaire) then
    begin
      TheTob.PutValue('GL_RECALCULER', 'X');
      TobPiece.PutValue('GP_RECALCULER', 'X');
      CalculeLaSaisie(-1, GS.Row, False);
    end;
    ShowDetail(GS.Row);
  end;
  TheTob := nil;
end;

procedure TFFacture.AdrLivClick(Sender: TObject);
begin
  EntreeAdressePiece(TobPiece, TobAdresses, 0);
end;

procedure TFFacture.AdrFacClick(Sender: TObject);
begin
  EntreeAdressePiece(TobPiece, TobAdresses, 1);
end;

procedure TFFacture.OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; var Value: variant);
var T: TOB;
  NumPiece: string;
begin
  if VarName = 'NBL' then Value := TOBPiece.Detail.Count else
    if VarName = 'GP_BLOCNOTE' then
  begin
    BlobToFile(VarName, TOBPiece.GetValue(VarName));
    Value := '';
  end else //PCS
    if Pos('T_', VarName) > 0 then Value := TOBTiers.GetValue(VarName) else // Paul
    if Pos('GP_', VarName) > 0 then Value := TOBPiece.GetValue(VarName) else
    if VarName = 'GL_BLOCNOTE' then
  begin
    BlobToFile(VarName, TOBPiece.Detail[VarIndx - 1].GetValue(VarName));
    Value := '';
  end else
    if VarName = 'TEXTEDEBUT' then
  begin
    Numpiece := TOBPiece.GetValue('GP_NATUREPIECEG') + ':' + TOBPiece.GetValue('GP_SOUCHE') + ':' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ':' +
      IntToStr(TOBPiece.GetValue('GP_INDICEG'));
    // récup Texte de Debut
    T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', NumPiece, '1'], false);
    if (T <> nil) then
    begin
      BlobToFile(VarName, T.GetValue('LO_OBJET'));
      Value := '';
    end;
    T.Free;
  end else
    if VarName = 'TEXTEFIN' then
  begin
    Numpiece := TOBPiece.GetValue('GP_NATUREPIECEG') + ':' + TOBPiece.GetValue('GP_SOUCHE') + ':' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ':' +
      IntToStr(TOBPiece.GetValue('GP_INDICEG'));
    // récup Texte de Debut
    T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', NumPiece, '2'], false);
    if (T <> nil) then
    begin
      BlobToFile(VarName, T.GetValue('LO_OBJET'));
      Value := '';
    end;
  end else
  begin
    Value := TOBPiece.Detail[VarIndx - 1].GetValue(VarName); //PCS
  end;
end;

function TFFacture.FabricNomWord: string;
var St: string;
begin
  St := TOBPiece.GetValue('GP_NATUREPIECEG');
  if Action <> taCreat then St := St + IntToStr(TOBPiece.GetValue('GP_NUMERO'));
  St := St + '_' + TOBTiers.GetValue('T_LIBELLE') + '.DOC';
  Result := St;
end;

procedure TFFacture.BOfficeClick(Sender: TObject);
var ii: integer;
  stModele, stDocWord, stPathWord: string;
  Okok: boolean;
begin
  {Tests préliminaires}
  Okok := True;
  if ((not BOffice.Visible) or (not BOffice.Enabled)) then Exit;
  stModele := GetParamSoc('SO_GCMODELEWORD');
  stPathWord := GetParamSoc('SO_GCREPERTOIREWORD');
  if ((stModele = '') or (stPathWord = '')) then okok := False else
    if not FileExists(stModele) then okok := False else
    if not DirectoryExists(stPathWord) then okok := False;
  if not Okok then
  begin
    HPiece.Execute(45, caption, '');
    Exit;
  end;
  {Traitement}
  stDocWord := stPathWord + '\' + FabricNomWord;
  DeleteFile(stDocWord);
  ii := ConvertDocFile(stModele, stDocWord, nil, nil, nil, OnGetVar, nil, nil);
  if ii = 0 then ShellExecute(0, PCHAR('open'), PChar(stDocWord), nil, nil, SW_RESTORE); //PCS
end;

{==============================================================================================}
{=============================== Manipulation des Affaires ====================================}
{==============================================================================================}

function TFFacture.ChargeAffairePiece(TestCle, RepriseTiers: Boolean; ChargeLigne: boolean = True): Integer;
{$IFDEF AFFAIRE}
var ExitPossible: Boolean;
  EvtCourant: string;
  dDateDebItv, dDateFinItv: TDateTime;
  {$ENDIF}
begin
  Result := 1;
  {$IFDEF AFFAIRE}
  ExitPossible := True;
  if (GP_TIERS.Text <> '') and (TobAffaire.GetValue('AFF_TIERS') <> GP_TIERS.Text) and
    (TobAffaire.GetValue('AFF_TIERS') <> '') and (VenteAchat = 'VEN') then
    ExitPossible := False; // pas de sortie rapide
  if (GP_AFFAIRE.Text = TobAffaire.GetValue('AFF_AFFAIRE')) and ExitPossible then Exit;

  if PEnteteAffaire.visible = true then
  begin
    if (VenteAchat = 'VEN') and (RepriseTiers) then AFF_TIERS.Text := GP_TIERS.Text;
    if (VenteAchat = 'ACH') and (ctxTempo in V_PGI.PGIContexte) then AFF_TIERS.Text := '';
  end;

  AutoCodeAff := False;
  // on débranche les évènements onchange des parties du code affaire pendant cette fonction
  Result := ChargeAffaire(GP_AFFAIRE, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, AFF_TIERS, GP_AFFAIRE0, Testcle, Action, TobAffaire, nil, True, False,
    False);
  AutoCodeAff := True;
  // Contrôle des blocages sur affaires
  if (Result = 1) and not (GeneCharge) and not (SaisieTypeAffaire) then
  begin
    if (VenteAchat = 'ACH') then EvtCourant := 'SAH' else EvtCourant := 'FAC';
    if (BlocageAffaire(EvtCourant, TobAffaire.GetValue('AFF_AFFAIRE'), V_PGI.Groupe, StrTodate(GP_DATEPIECE.Text), True, True, False, dDateDebItv, dDateFinItv,
      nil) <> tbaAucun) then
      Result := 0;
  end;

  if (Result = 1) then
  begin
    LibelleAffaire.Caption := TOBAffaire.GetValue('AFF_LIBELLE');
    if (Action = taCreat) or (DuplicPiece) then // mcd 23/04/02 ajout duplicpiece
    begin
      // Reprise du tiers uniquement en vente
      IncidenceAffaire;
      if ((ctxAffaire in V_PGI.PGIContexte) and (VenteAchat = 'VEN') and (ChargeLigne)) then IncidenceLignesAffaire;
    end;
    if SaisieTypeAffaire then
    begin
      ChargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, nil, taConsult, GP_AFFAIRE.Text, False);
    end;
    // mise à jour des lignes sur la nouvelle affaire
    if not (GeneCharge) then
    begin
      PutValueDetail(TOBPiece, 'GP_AFFAIRE', GP_AFFAIRE.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE1', GP_AFFAIRE1.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE2', GP_AFFAIRE2.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE3', GP_AFFAIRE3.Text);
      PutValueDetail(TOBPiece, 'GP_AVENANT', GP_AVENANT.Text);
    end;
  end
  else if (Result = 0) then
  begin
    LibelleAffaire.Caption := '';
    if (GP_AFFAIRE.Text <> '') then
    begin
      GP_AFFAIRE.Text := '';
      GP_AFFAIRE1.Text := '';
      GP_AFFAIRE2.Text := '';
      GP_AFFAIRE3.Text := '';
      GP_AVENANT.Text := '';
      ClearAffaire(TOBPiece);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE', GP_AFFAIRE.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE1', GP_AFFAIRE1.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE2', GP_AFFAIRE2.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE3', GP_AFFAIRE3.Text);
      PutValueDetail(TOBPiece, 'GP_AVENANT', GP_AVENANT.Text);
      TOBAffaire.InitValeurs(False);
    end;
  end
  else
    LibelleAffaire.Caption := '';
  {$ENDIF}
end;

procedure TFFacture.IncidenceLignesAffaire;
var TobPieceAffaire, TOBPorcsPieceAff, TobP, TobDet, TobDetAffaire, TOBC, TOBA, TOBCata: TOB;
  i: integer;
  Q: TQuery;
begin
  if SaisieTypeAffaire then Exit;
  if (Action <> taCreat) and (not DuplicPiece) then Exit;
  // mcd 23/04/02   il faut uniquement changer le code clt dans les lignes
  if DuplicPiece then
  begin
    for i := 1 to TobPiece.Detail.Count do
    begin
      TobDet := GetTOBLigne(TobPiece, i);
      PieceVersLigne(TobPiece, TobDet);
    end;
    Exit;
  end;
  {$IFDEF BTP}
  Exit;
  {$ENDIF}

  TobPieceAffaire := TOB.Create('PIECE', nil, -1);
  // Modif BTP
  AddLesSupEntete(TobPieceAffaire);
  // -----
  TobPieceAffaire.PutValue('GP_AFFAIRE', TobAffaire.GetValue('AFF_AFFAIRE'));
  {$IFDEF AFFAIRE}
  LectureLignesAffaire(TobPieceAffaire, True);
  {$ENDIF}

  //  Champs personnalisable dans l'entête de pièce associée à l'affaire
  GP_REFINTERNE.Text := TobPieceAffaire.GetValue('GP_REFINTERNE');
  TOBPiece.PutValue('GP_REFINTERNE', TobPieceAffaire.GetValue('GP_REFINTERNE'));
  TOBPiece.PutValue('GP_TIERSFACTURE', TobPieceAffaire.GetValue('GP_TIERSFACTURE'));
  TOBPiece.PutValue('GP_TARIFTIERS', TobPieceAffaire.GetValue('GP_TARIFTIERS'));
  TOBPiece.PutValue('GP_TIERSPAYEUR', TobPieceAffaire.GetValue('GP_TIERSPAYEUR'));
  GP_REGIMETAXE.Value := TobPieceAffaire.GetValue('GP_REGIMETAXE');
  GP_MODEREGLE.Value := TobPieceAffaire.GetValue('GP_MODEREGLE');
  TOBPiece.PutValue('GP_MODEREGLE', TobPieceAffaire.GetValue('GP_MODEREGLE'));
  GP_TVAENCAISSEMENT.Value := TobPieceAffaire.GetValue('GP_TVAENCAISSEMENT');

  TOBPiece.PutValue('GP_QUALIFESCOMPTE', TobPieceAffaire.GetValue('GP_QUALIFESCOMPTE'));
  GP_ESCOMPTE.Value := TobPieceAffaire.GetValue('GP_ESCOMPTE');
  PutValueDetail(TOBPiece, 'GP_ESCOMPTE', GP_ESCOMPTE.Value);

  // gm le 10/01/03
  // réalignement de l'adresse de Facturation, si le client à facturer de l'affaire
  // est différent de celui du client
     ////mcd 04/03/03 if (TobPieceAffaire.GetValue('GP_TIERSFACTURE') <> TobTiers.GetValue('T_FACTURE'))then
  if (TiersAuxiliaire(TobPieceAffaire.GetValue('GP_TIERSFACTURE'), False) <> TobTiers.GetValue('T_FACTURE')) then
    TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece, TobPieceAffaire.GetValue('GP_TIERSFACTURE'));

  // non reprise des éléments si la pièce posséde déjà des lignes
  if TobPiece.Detail.Count > 0 then
  begin
    HPiece.Execute(26, Caption, '');
    Exit;
  end;
  // Recup des ports
  if TobPorcs <> nil then
  begin
    if TOBPorcs.Detail.count = 0 then
    begin
      Q := OpenSQL('SELECT * FROM PIEDPORT WHERE ' + WherePiece(TOB2CleDoc(TobPieceAffaire), ttdPorc, False), True);
      TOBPorcsPieceAff := TOB.Create('Liste ports', nil, -1);
      TOBPorcsPieceAff.LoadDetailDB('PIEDPORT', '', '', Q, False);
      for i := 0 to TOBPorcsPieceAff.Detail.Count - 1 do
      begin
        TOBP := TOBPorcsPieceAff.Detail[i];
        TOBP.PutValue('GPT_NATUREPIECEG', CleDoc.NaturePiece);
        TOBP.PutValue('GPT_SOUCHE', CleDoc.Souche);
        TOBP.PutValue('GPT_NUMERO', CleDoc.NumeroPiece);
        TOBP.PutValue('GPT_INDICEG', CleDoc.Indice);
      end;
      TOBPorcs.Dupliquer(TOBPorcsPieceAff, True, True);
      Ferme(Q);
      TOBPorcsPieceAff.Free;
    end;
  end;
  // Reprise des lignes de la pièce associée à l'affaire
  CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TobPieceAffaire.Detail.Count);
  for i := 1 to TobPiece.Detail.Count do
  begin
    TobDet := GetTOBLigne(TobPiece, i);
    TobDetAffaire := GetTOBLigne(TobPieceAffaire, i);
    TobDet.Dupliquer(TobDetAffaire, False, True);
    AddLesSupLigne(TOBDet, False);
    InitLesSupLigne(TOBDet);
    TOB.Create('', TOBDet, -1);
    TOB.Create('', TOBDet, -1); // GMGM 070202
    PieceVersLigne(TobPiece, TobDet);
    AffaireVersLigne(TOBPiece, TOBDet, TOBAffaire);
  end;
  LoadLesArticles;
  TOBA := nil;
  TOBCata := nil;
  for i := 1 to TobPiece.Detail.Count do
  begin
    TobDet := GetTOBLigne(TobPiece, i);
    if TobDet.GetValue('GL_TYPEREF') = 'CAT' then
    begin
      TOBCata := FindTOBCataRow(TOBPiece, TOBCataLogu, i);
      if TOBCata = nil then continue;
    end else
    begin
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i);
      if TOBA = nil then continue;
    end;
    if (TobDet.GetValue('GL_TYPELIGNE') = 'COM') or (TobDet.GetValue('GL_TYPELIGNE') = 'TOT') then continue;
    TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBDet, TOBA, TOBTiers, TOBCata, TobAffaire, True);
    PreVentileLigne(TOBC, TOBAnaP, TOBAnaS, TOBDet);
  end;
  TOBPiece.putvalue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, False);
  TobPieceAffaire.Free;
end;

procedure TFFacture.IncidenceAffaire;
var CodeD, CodeTiers, LibTiers: string;
begin
  if (Action <> taCreat) and (not DuplicPiece) then Exit; // mcd 23/04/02 ajout DuplicPiece
  if (VenteAchat <> 'VEN') then exit;
  if (VenteAchat = 'VEN') and (GP_TIERS.Enabled) then // maj du tiers uniquement en vente
  begin
    if ((GP_TIERS.Text = '') or (GP_TIERS.Text <> TOBTiers.GetValue('T_TIERS'))) then
    begin
      CodeTiers := TOBAffaire.GetValue('AFF_TIERS');
      LibTiers := RechDom('GCTIERSSAISIE', CodeTiers, False);
      if ((LibTiers = '') or (LibTiers = 'Error')) then
      begin
        GP_AFFAIRE.Text := '';
        LibelleAffaire.Caption := '';
        ChargeCleAffairePiece;
        HPiece.Execute(4, Caption, '');
      end else
      begin
        GP_TIERS.Text := CodeTiers;
        ChargeTiers;
        CliCur := GP_TIERS.Text;
      end;
    end;
  end;
  GP_FACTUREHT.Checked := (TOBAffaire.GetValue('AFF_AFFAIREHT') = 'X');
  if ctxAffaire in V_PGI.PGIContexte then
  begin
    CodeD := TOBAffaire.GetValue('AFF_DEVISE');
    if CodeD <> '' then GP_DEVISE.Value := CodeD;
    if (Action = taCreat) and (GP_DEVISE.Value = V_PGI.DevisePivot) then
    begin
      if (TobAffaire.GetValue('AFF_SAISIECONTRE') = 'X') then PopD.Items[1].Checked := True
      else PopD.Items[0].Checked := True;
      if not GeneCharge then AfficheEuro;
    end;
  end;
  GP_ETABLISSEMENT.Value := TOBAffaire.GetValue('AFF_ETABLISSEMENT');
  if GP_ETABLISSEMENT.Value = '' then GP_ETABLISSEMENT.Value := VH^.EtablisDefaut;
  AffaireVersPiece(TobPiece, TobAffaire);
  PutValueDetail(TOBPiece, 'GP_APPORTEUR', TOBPiece.GetValue('GP_APPORTEUR'));
  // mcd 14/02/03 if Not GetParamSoc('SO_GCPIECEADRESSE') then AffaireVersAdresses(TOBAffaire,TOBAdresses,TOBPiece);
  TOBPiece.GetEcran(Self);
end;

procedure TFFacture.OnExitPartieAffaire(Sender: TObject);
{$IFDEF AFFAIRE}
var
  iP, NbAff: integer;
  Part1, Part2, Part3: string;
  {$ENDIF}
begin
  if csDestroying in ComponentState then Exit;
  if (GP_AFFAIRE1.Text = '') and (GP_AFFAIRE2.Text = '') and (GP_AFFAIRE3.Text = '') then Exit;
  {$IFDEF AFFAIRE}
  if (THCritMaskEdit(sender).Name = 'GP_AVENANT') then // Avenant
  begin
    if (Copy(GP_AFFAIRE.Text, 16, 2) <> (GP_AVENANT.Text)) then
    begin
      Part1 := GP_AFFAIRE1.Text;
      Part2 := GP_AFFAIRE2.Text;
      Part3 := GP_AFFAIRE3.Text;
      RAZIdentifiantAffaire(Part1, Part2, Part3);
      if Part2 = '' then GP_AFFAIRE2.Text := Part2;
      if Part3 = '' then GP_AFFAIRE3.Text := Part3;
    end;
  end;
  GP_AFFAIRE.Text := DechargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, GP_TIERS.Text, Action, False, True, false, iP);
  NbAff := ChargeAffairePiece(True, True);
  if (NbAff <> 1) then PositionErreurCodeAffaire(Sender, NbAff);
  GereAffaireEnabled;
  {$ENDIF}
end;

procedure TFFacture.PositionErreurCodeAffaire(Sender: TObject; NbAff: integer);
var NumPart: integer;
begin
  if GP_AFFAIRE.Text = '' then Exit;
  if ((GP_AFFAIRE1.Focused) or (GP_AFFAIRE2.Focused) or (GP_AFFAIRE3.Focused) or
    (GP_AVENANT.Focused)) then Exit;
  if NbAff = 0 then THCritMaskEdit(Sender).SetFocus;
  if NbAff > 1 then
  begin
    if THCritMaskEdit(Sender).Name = 'GP_AFFAIRE1' then NumPart := 1 else
      if THCritMaskEdit(Sender).Name = 'GP_AFFAIRE2' then NumPart := 2 else
      if THCritMaskEdit(Sender).Name = 'GP_AFFAIRE3' then NumPart := 3 else
      NumPart := 4;
    if (NumPart = 1) and (GP_AFFAIRE2.Visible) then GP_AFFAIRE2.SetFocus else
      if (NumPart = 2) and (GP_AFFAIRE3.Visible) then GP_AFFAIRE3.SetFocus else
      if (NumPart = 3) and (GP_AFFAIRE3.Visible) then GP_AFFAIRE3.SetFocus
    else GP_AFFAIRE1.SetFocus;
  end;
end;

procedure TFFacture.BRechAffaire__Click(Sender: TObject);
var bChangeTiers: Boolean;
begin
  bChangeTiers := True;
  if VenteAchat = 'VEN' then
  begin
    AFF_TIERS.Text := GP_TIERS.Text;
    if GP_TIERS.Text <> '' then bChangeTiers := False;
  end;
  // PL le 07/11/02 : ajout du paramètre contexte d'appel : ici FAC
  GetAffaireEntete(GP_AFFAIRE, GP_Affaire1, GP_Affaire2, GP_Affaire3, GP_AVENANT, AFF_TIERS, false, false, false, bChangeTiers, 'FAC');
  //////////////////////////////
  if GP_AFFAIRE.Text <> '' then
  begin
    ChargeCleAffairePiece;
    {$IFDEF BTP}
    ChargeAffairePiece(False, False, False);
    {$ELSE}
    ChargeAffairePiece(False, False, True);
    {$ENDIF}
    GereAffaireEnabled;
  end;
end;

procedure TFFacture.BRazAffaireClick(Sender: TObject);
begin
  GP_Affaire1.Text := '';
  GP_Affaire2.Text := '';
  GP_Affaire3.Text := '';
  GP_AVENANT.Text := '';
  if (GP_TIERS.Enabled) and (VenteAchat = 'VEN') then
  begin
    GP_Tiers.Text := '';
    if GP_TIERS.CanFocus then GP_TIERS.SetFocus;
  end;
end;

procedure TFFacture.GP_AFFAIRE1__Change(Sender: TObject);
begin
  if GeneCharge then Exit;
  if SaisieTypeAffaire then Exit;
  {$IFDEF AFFAIRE}
  if AutoCodeAff then GoSuiteCodeAffaire(GP_AFFAIRE1, GP_AFFAIRE2, 1);
  {$ENDIF}
end;

procedure TFFacture.GP_AFFAIRE2__Change(Sender: TObject);
begin
  if GeneCharge then Exit;
  if SaisieTypeAffaire then Exit;
  {$IFDEF AFFAIRE}
  if AutoCodeAff then GoSuiteCodeAffaire(GP_AFFAIRE2, GP_AFFAIRE3, 2);
  {$ENDIF}
end;

procedure TFFacture.ChargeCleAffairePiece;
begin
  {$IFDEF AFFAIRE}
  AutoCodeAff := False;
  ChargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, nil, Action, GP_AFFAIRE.Text, False);
  AutoCodeAff := True;
  {$ENDIF}
end;

procedure TFFacture.TraiteAffaire(ACol, ARow: integer; var Cancel: boolean);
var TOBL: TOB;
  {$IFDEF AFFAIRE}
  Aff, AffComplet, CodeTiers, EvtCourant: string;
  NewCol, NewRow, NumMaj: integer;
  dDateDebItv, dDateFinItv: TDateTime;
  {$ENDIF}
begin
  if ACol <> SG_Aff then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  {$IFDEF AFFAIRE}
  Aff := GS.Cells[ACol, ARow];
  if (Aff = '') then
  begin
    ClearAffaire(TOBL);
    Exit;
  end;
  if (Venteachat <> 'VEN') then CodeTiers := '' else CodeTiers := TOBPiece.GetValue('GP_TIERS');

  if Aff = CodeAffaireAffiche(TOBL.GetValue('GL_AFFAIRE')) then Exit;
  NewCol := GS.Col;
  NewRow := GS.Row;
  GS.SynEnabled := False;
  GS.Col := ACol;
  GS.Row := ARow;

  NumMaj := 0;
  AffComplet := CodeAffAfficheToComplet(Aff, CodeTiers);
  if ExisteAffaire(AffComplet, CodeTiers) then NumMaj := 1;
  if (NumMaj = 0) then
    if GetAffaireLigne(GS, TOBPiece.GetValue('GP_TIERS'), NewNature, False) then NumMaj := 2;

  // Contrôle des blocages sur affaires
  if (NumMaj = 1) and not (GeneCharge) and not (SaisieTypeAffaire) then
  begin
    if (VenteAchat = 'ACH') then EvtCourant := 'SAH' else EvtCourant := 'FAC';
    if (BlocageAffaire(EvtCourant, AffComplet, V_PGI.Groupe, StrTodate(GP_DATEPIECE.Text), True, True, False, dDateDebItv, dDateFinItv, nil) <> tbaAucun) then
      NumMaj := 0;
  end;

  if (NumMaj > 0) then
  begin
    if (NumMaj = 2) then
    begin
      AffComplet := GS.Cells[ACol, ARow]; // si =1 déja alim
      GS.Cells[ACol, ARow] := CodeAffaireAffiche(AffComplet);
    end;
    TOBL.PutValue('GL_AFFAIRE', AffComplet);
    DecoupeCodeAffsurTOB(TOBL);
    // Compta
    if OkCpta then MajAnaAffaire(TOBPiece, TOBCataLogu, TOBArticles, TOBCpta, TOBTiers, TOBAnaP, ARow);
    GS.Col := NewCol;
    GS.Row := NewRow;
  end else
  begin
    ClearAffaire(TOBL);
    GS.Cells[ACol, ARow] := '';
    Cancel := True;
  end;
  GS.SynEnabled := True;
  {$ENDIF}
end;

procedure TFFacture.ZoomOuChoixAffaire(ACol, ARow: integer);
var TOBL: TOB;
  CodeTiers: string;
  {$IFDEF AFFAIRE}
  CodeAff, CodeAffL, AffComplet, EvtCourant: string;
  AffOk: Boolean;
  dDateDebItv, dDateFinItv: TDateTime;
  {$ENDIF}
begin
  if ACol <> SG_Aff then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (VenteAchat <> 'VEN') then CodeTiers := '' else CodeTiers := TOBPiece.GetValue('GP_TIERS');
  {$IFDEF AFFAIRE}
  CodeAff := GS.Cells[ACol, ARow];
  CodeAffL := CodeAffaireAffiche(TOBL.GetValue('GL_AFFAIRE'));
  if ((CodeAff <> '') and (CodeAff = CodeAffL)) then
  begin
    // Même code zoom affaire
    AffComplet := TOBL.GetValue('GL_AFFAIRE');
    DecoupeCodeAffsurTOB(TOBL);
    ZoomAffaire(AffComplet);
  end else if Action <> taConsult then
  begin
    if GetAffaireLigne(GS, TOBPiece.GetValue('GP_TIERS'), NewNature, False) then AffOk := true else affok := False;

    if AffOk then // controle blocages sur affaires
    begin
      if (VenteAchat = 'ACH') then EvtCourant := 'SAH' else EvtCourant := 'FAC';
      if (BlocageAffaire(EvtCourant, GS.Cells[ACol, ARow], V_PGI.Groupe, StrTodate(GP_DATEPIECE.Text), True, True, False, dDateDebItv, dDateFinItv, nil) <>
        tbaAucun) then
      begin
        AffOk := false;
        GS.Cells[ACol, ARow] := '';
      end;
    end;

    if AffOk then
    begin
      AffComplet := GS.Cells[ACol, ARow];
      GS.Cells[ACol, ARow] := CodeAffaireAffiche(AffComplet);
      TOBL.PutValue('GL_AFFAIRE', AffComplet);
      DecoupeCodeAffsurTOB(TOBL);
      // Compta
      if OkCpta then MajAnaAffaire(TOBPiece, TOBCataLogu, TOBArticles, TOBCpta, TOBTiers, TOBAnaP, ARow);
    end else
    begin
      ClearAffaire(TOBL);
    end;
  end;
  {$ENDIF}
end;

{=======================================================================================}
{===============================Gestion descriptif détail===============================}
{=======================================================================================}

procedure TFFacture.TDescriptifClose(Sender: TObject);
begin
  GereDescriptif(GS.Row, False);
  BDescriptif.Down := False;
end;

procedure TFFacture.BDescriptifClick(Sender: TObject);
var TOBL: TOB;
  CacherDesc: Boolean;
begin
  CacherDesc := False;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  {$IFDEF BTP}
  if TOBL.GetValue('GL_REFARTSAISIE') = '' then CacherDesc := True;
  {$ENDIF}
  GereDescriptif(GS.Row, True);
  TDescriptif.Visible := ((BDescriptif.Down) and (not CacherDesc));
  {$IFDEF CHR}
  if (Action <> TaConsult) then
  begin
    if TDescriptif.Visible = True then Descriptif.SetFocus;
  end;
  {$ENDIF}
end;

procedure TFFacture.GereDescriptif(ARow: Integer; Enter: Boolean);
var TOBL: TOB;
  st: string;
  CacherDesc: boolean;
begin
  if not BDescriptif.Down then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if Enter then
  begin
    CacherDesc := False;
    {$IFDEF BTP}
    if TOBL.GetValue('GL_REFARTSAISIE') = '' then CacherDesc := True;
    {$ENDIF}
    TDescriptif.Visible := ((BDescriptif.Down) and (not CacherDesc));
    StringToRich(Descriptif, TOBL.GetValue('GL_BLOCNOTE'));
    TDescriptif.Caption := Format('Descriptif ligne N° %d', [ARow]);
    {$IFDEF BTP}
  end else if TOBL.GetValue('GL_REFARTSAISIE') <> '' then
    {$ELSE}
  end else
    {$ENDIF}
  begin
    St := Descriptif.Text;
    if (Length(st) <> 0) and (st <> #$D#$A) then
    begin
      TOBL.PutValue('GL_BLOCNOTE', RichToString(Descriptif));
    end else
    begin
      if (TOBL.GetValue('GL_BLOCNOTE') <> '') then TOBL.PutValue('GL_BLOCNOTE', '');
    end;
  end;
end;

{=======================================================================================}
{======================================= VALIDATIONS ===================================}
{=======================================================================================}

function TFFacture.CreerAnnulation(TOBPieceDel, TOBNomenDel: TOB): boolean;
var i: integer;
  TOBL, BasesDel: TOB;
  Qte: double;
  Souche: string;
  NowFutur: TDateTime;
begin
  Result := False;
  if TOBPieceDel.Detail.Count <= 0 then Exit;
  NowFutur := NowH;
  for i := 0 to TOBPieceDel.Detail.Count - 1 do
  begin
    TOBL := TOBPieceDel.Detail[i];
    //if (TransfoPiece) then Qte:=-TOBL.GetValue('GL_QTERELIQUAT') else Qte:=TOBL.GetValue('GL_QTERELIQUAT') ;
    Qte := -TOBL.GetValue('GL_QTERELIQUAT');
    TOBL.PutValue('GL_QTESTOCK', Qte);
    TOBL.PutValue('GL_QTEFACT', Qte);
    TOBL.PutValue('GL_QTERELIQUAT', 0);
    TOBL.PutValue('GL_QTERESTE', 0);
    TOBL.PutValue('GL_SOLDERELIQUAT', '-');
  end;
  NumeroteLignesGC(nil, TOBPieceDel);
  TOBPieceDel.PutValue('GP_DEVENIRPIECE', '');
  Souche := GetSoucheG(NatPieceAnnule, TOBPieceDel.GetValue('GP_ETABLISSEMENT'), TOBPieceDel.GetValue('GP_DOMAINE'));
  PutValueDetail(TOBPieceDel, 'GP_NATUREPIECEG', NatPieceAnnule);
  PutValueDetail(TOBPieceDel, 'GP_SOUCHE', Souche);
  PutValueDetail(TOBPieceDel, 'GP_NUMERO', NumPieceAnnule);
  PutValueDetail(TOBPieceDel, 'GP_INDICEG', 0);
  PutValueDetail(TOBPieceDel, 'GP_VIVANTE', '-');
  // Création des TOB utiles à la nouvelle pièce
  BasesDel := TOB.Create('BASES', nil, -1);
  if not SetDefinitiveNumber(TOBPieceDel, BasesDel, nil, TOBNomenDel, nil, nil, nil, NumPieceAnnule) then V_PGI.IoError := oePointage;
  if V_PGI.IoError = oeOk then
  begin
    // Calculs
    CalculFacture(TOBPieceDel, BasesDel, TOBTiers, TOBArticles, TOBPieceRg, TOBBasesRg, nil, DEV);
    ValideLesLignes(TOBPieceDel, TOBArticles, TOBCatalogu, TOBNomenDel, nil, TOBPieceRG, TOBbasesRg, True, False);
    // Tout modif
    TOBPieceDel.SetAllModifie(True);
    TOBPieceDel.SetDateModif(NowFutur);
    BasesDel.SetAllModifie(True);
    TOBNomenDel.SetAllModifie(True);
    if not TOBPieceDel.InsertDBByNivel(False) then V_PGI.IoError := oeUnknown;
    if V_PGI.IoError = oeOk then if not BasesDel.InsertDB(nil) then V_PGI.IoError := oeUnknown;
    if V_PGI.IoError = oeOk then
    begin
      for i := TOBNomenDel.Detail.Count - 1 downto 0 do
        if TOBNomenDel.Detail[i].GetValue('UTILISE') <> 'X' then TOBNomenDel.Detail[i].Free;
      if not TOBNomenDel.InsertDB(nil) then V_PGI.IoError := oeUnknown;
    end;
  end;
  BasesDel.Free;
end;

function TFFacture.CreerReliquat: boolean; { NEWPIECE }
{
  Mise à jour du reste à livrer dans la pièce d'origine directement dans TobPiece_O
  puis UpDateDB de TobPiece_O
}
var
  NewEtat: string;
  i: Integer;
  TOBL, TOBLOld: TOB;
begin
  Result := False;
  for i := 0 to TobPiece.Detail.Count - 1 do { NEWPIECE }
  begin
    Tobl := TobPiece.Detail[i];
    { Récupère la ligne dans la pièce d'origine }
    TobLOld := GetTOBPrec(TobL, TobPiece_O, True);
    if TobLOld = nil then Continue;
    if TobL.GetValue('GL_SOLDERELIQUAT') = '-' then
    begin
      { Mise à jour du reste à livrer de la ligne de la pièce d'origine }
      TobLOld.PutValue('GL_QTERESTE', Arrondi(TobLOld.GetValue('GL_QTERESTE') - TobL.GetValue('GL_QTESTOCK'), 6));
    end;
  end;
  NewEtat := '';
  if ToutesLignesSoldees(TobPiece_O) then
    NewEtat := '-'
  else
    NewEtat := 'X';
  TobPiece_O.PutValue('GP_VIVANTE', NewEtat);
  { Etat des lignes = Etat de l'entête }
  for i := 0 to TobPiece_O.Detail.Count - 1 do
    TobPiece_O.detail[i].PutValue('GL_VIVANTE', NewEtat);
  TOBPiece_O.UpdateDB(False);
  Result := True;
end;

procedure TFFacture.GereLesReliquats; { NEWPIECE }
begin
  if not TransfoPiece then
    Exit;
  if ReliquatTransfo then // TransfoPiece et Action=taModif et GPP_RELIQUAT = 'X'
  begin
    if not BeforeReliquat(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, DEV) then
      Exit;
    CreerReliquat;
  end
  else
    if not GppReliquat then { Transformation d'une pièce. On ne gère pas les reliquats dans la nouvelle pièce }
    RazResteALivrerAndKillPiece(TobPiece_O);
end;

procedure TFFacture.ValideLaCompta(OldEcr, OldStk: RMVT);
begin
  {$IFDEF CEGID}
  RechLibTiersCegid(VenteAchat, TobTiers, TOBPiece, TobAdresses);
  {$ENDIF}
  if not PassationComptable(TOBPiece, TOBBases, TOBEches, TOBTiers, TOBArticles, TOBCpta, TOBAcomptes, TOBPorcs, TOBPIECERG, TOBBASESRG, DEV.Decimale, OldEcr,
    OldStk, True)
    then V_PGI.IoError := oeLettrage;
end;

procedure TFFacture.ValideLesLots;
var i, IndiceLot: integer;
  TOBDL, TOBL: TOB;
begin
  if not GereLot then Exit;
  if TOBDesLots.Detail.Count <= 0 then Exit;
  TOBDesLots.Detail[0].AddChampSup('UTILISE', True);
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    IndiceLot := GetChampLigne(TOBPiece, 'GL_INDICELOT', i + 1);
    if IndiceLot > 0 then
    begin
      TOBL := TOBPiece.Detail[i];
      TOBDL := TOBDesLots.Detail[IndiceLot - 1];
      TOBDL.PutValue('UTILISE', 'X');
      UpdateNoeudLot(TOBL, TOBDL);
      MAJDispoLot(TOBArticles, TOBL, TOBDL, VenteAchat, TOBPiece.GetValue('GP_DEPOT'));
    end;
  end;
  for i := TOBDesLots.Detail.Count - 1 downto 0 do
  begin
    TOBDL := TOBDesLots.Detail[i];
    if TOBDL.GetValue('UTILISE') <> 'X' then TOBDL.Free;
  end;
  if TOBDesLots.Detail.Count > 0 then TOBPiece.PutValue('GP_ARTICLESLOT', 'X');
  if not TOBDesLots.InsertDB(nil) then V_PGI.IoError := oeUnknown;
end;

procedure TFFacture.ValideLesSeries;
var i, IndiceSerie: integer;
  TOBSerLig, TOBL: TOB;
begin
  {$IFDEF CCS3}
  Exit;
  {$ELSE}
  if not GereSerie then Exit;
  if TOBSerie.Detail.Count <= 0 then Exit;
  TOBSerie.Detail[0].AddChampSup('UTILISE', True);
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    IndiceSerie := GetChampLigne(TOBPiece, 'GL_INDICESERIE', i + 1);
    if IndiceSerie > 0 then
    begin
      TOBL := TOBPiece.Detail[i];
      TOBSerLig := TOBSerie.Detail[IndiceSerie - 1];
      TOBSerLig.PutValue('UTILISE', 'X');
      UpdateLesSeries(TOBL, TOBSerLig);
      MAJDispoSerie(TOBL, TOBSerLig, False);
    end;
  end;
  for i := TOBSerie.Detail.Count - 1 downto 0 do
  begin
    TOBSerLig := TOBSerie.Detail[i];
    if TOBSerLig.GetValue('UTILISE') <> 'X' then TOBSerLig.Free;
  end;
  //if TOBSerie.Detail.Count>0 then TOBPiece.PutValue('GP_ARTICLESLOT','X') ;
  if not TOBSerie.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  {$ENDIF}
end;

procedure TFFacture.ValideTiers;
begin
  if Action <> taCreat then if ((not DuplicPiece) and (not TransfoPiece)) then Exit;
  ValideleTiers(TOBPiece, TOBTiers);
end;

//modif 02/08/2001

procedure TFFacture.ValideLaNumerotation;
var ind, OldNum, NewNum: integer;
  NaturePieceG: string;
begin
  NaturePieceG := TOBPiece.GetValue('GP_NATUREPIECEG');
  //if (NaturePieceG='TRE') or (NaturePieceG='TRV') then Exit;
  if ((Action = taCreat) or (TransfoPiece) or (DuplicPiece)) then
  begin
    OldNum := TOBPiece.GetValue('GP_NUMERO');
    if not SetDefinitiveNumber(TOBPiece, TOBBases, TOBEches, TOBNomenclature, TOBAcomptes, TOBPIeceRG, TOBBasesRg, CleDoc.NumeroPiece) then
      V_PGI.IoError := oePointage;
    //if Not SetNumeroDefinitif(TOBPiece,TOBBases,TOBEches,TOBNomenclature,TOBAcomptes) then V_PGI.IoError:=oePointage ;
    if GetInfoParPiece(NaturePieceG, 'GPP_ACTIONFINI') = 'ENR' then TOBPiece.PutValue('GP_VIVANTE', '-');
    NewNum := TOBPiece.GetValue('GP_NUMERO');
    GP_NUMEROPIECE.Caption := IntToStr(NewNum);
    CleDoc.NumeroPiece := NewNum;
    Ind := TOBPiece.GetValue('GP_INDICEG');
    if Ind > 0 then GP_NUMEROPIECE.Caption := GP_NUMEROPIECE.Caption + ' ' + IntToStr(Ind);
    if ((OldNum <> NewNum)) then MajAccRegleDiff(TOBPiece, TOBAcomptes, OldNum);
  end;
end;

procedure TFFacture.DetruitNewAcc;
var i: integer;
  TOBC: TOB;
  FlagAcc: string;
  ExiAccDet: Boolean;
begin
  if TOBAcomptes = nil then Exit;
  if TOBAcomptes.Detail.Count <= 0 then Exit;
  ExiAccDet := False;
  for i := 0 to TOBAcomptes.Detail.Count - 1 do
  begin
    TOBC := TOBAcomptes.Detail[i];
    if not TOBC.FieldExists('NEWACC') then Continue;
    FlagAcc := TOBC.GetValue('NEWACC');
    if ((FlagAcc = 'R') or (FlagAcc = 'D')) then
    begin
      ExiAccDet := True;
      Break;
    end;
  end;
  if not ExiAccDet then Exit;
  {$IFDEF BTP}
  if HPiece.Execute(33, caption, '') <> mrYes then
  begin
    for i := TOBAcomptes.Detail.Count - 1 downto 0 do
    begin
      TOBC := TOBAcomptes.Detail[i];
      if not TOBC.FieldExists('NEWACC') then Continue;
      FlagAcc := TOBC.GetValue('NEWACC');
      if ((FlagAcc = 'R') or (FlagAcc = 'D')) then
      begin
        ReinitAcompteGCCpta(TOBC);
        TOBC.Free;
      end;
    end;
    exit;
  end;
  {$ELSE}
  if HPiece.Execute(33, caption, '') <> mrYes then Exit;
  {$ENDIF}
  for i := TOBAcomptes.Detail.Count - 1 downto 0 do
  begin
    TOBC := TOBAcomptes.Detail[i];
    if not TOBC.FieldExists('NEWACC') then Continue;
    FlagAcc := TOBC.GetValue('NEWACC');
    if ((FlagAcc = 'R') or (FlagAcc = 'D')) then
    begin
      DetruitAcompteGCCpta(TOBPiece, TOBC);
      TOBC.Free;
    end;
  end;
end;

procedure TFFacture.DelOrUpdateAncien; { NEWPIECE }
var NowFutur: TdateTime;
begin
  NowFutur := NowH;
  TOBPiece_O.SetDateModif(NowFutur);
  TOBPiece_O.CleWithDateModif := True;
  if ((not TransfoPiece) or (not HistoPiece(TobPiece_O))) then
  begin
    if not DetruitAncien(TOBPiece_O, TOBBases_O, TOBEches_O, TOBN_O, TOBLOT_O, TOBAcomptes_O, TOBPorcs_O, TOBSerie_o, TOBOuvrage_O, TOBLienOLE_O, TOBPIECERG_O,
      TOBBasesRg_O) then V_PGI.IoError := oeSaisie;
  end else
  begin
    if not UpdateAncien(TOBPiece_O, TOBPiece, TOBAcomptes_O, TobTiers, False, CleDoc.NumeroPiece) then V_PGI.IoError := oeSaisie;
  end;
end;

function TFFacture.SortDeLaLigne: boolean;
var ACol, ARow: integer;
  Cancel, ATraiter: boolean;
begin
  Result := False;
  ATraiter := True;
  if GP_ESCOMPTE.Focused then
  begin
    if GP_REMISEPIED.CanFocus then GP_REMISEPIED.SetFocus
    else GP_ESCOMPTEExit(nil);
    ATraiter := False;
  end;
  if GP_REMISEPIED.Focused then
  begin
    if GP_ESCOMPTE.CanFocus then GP_ESCOMPTE.SetFocus
    else GP_REMISEPIEDExit(nil);
    ATraiter := False;
  end;
  if GP_DATEPIECE.Focused then
  begin
    if not ExitDatePiece then Exit;
    ATraiter := False;
  end;
  if not DejaRentre then
  begin
    Result := True;
    Exit;
  end;
  if not (Screen.ActiveControl = GS) then
  begin
    Result := True;
    Exit;
  end;
  if ATraiter then NextPrevControl(Self);
  Result := False;
  ACol := GS.Col;
  ARow := GS.Row;
  Cancel := False;
  GSCellExit(nil, ACol, ARow, Cancel);
  if Cancel then Exit;
  GSRowExit(nil, ARow, Cancel, False);
  if Cancel then Exit;
  Result := True;
end;

procedure TFFacture.InverseAvoir;
begin
  InverseLesPieces(TOBPiece, 'PIECE');
  InverseLesPieces(TOBBases, 'PIEDBASE');
  InverseLesPieces(TOBEches, 'PIEDECHE');
  InverseLesPieces(TOBPorcs, 'PIEDPORT'); //mcd 07/06/02 port non pris en compte
end;

procedure TFFacture.ElimineLignesZero;
var TOBL, TOBDec, TOBAL, TOBAna: TOB;
  TOBPieceDel, TOBLDel, TOBNomenDel, TOBLNDel, TobNomenCop: TOB;
  RefArt: string;
  i, j, k, IndiceNomen, IndiceNomenDel: integer;
  NomenASup: array of Boolean;
begin
  if Action <> taModif then Exit;
  TOBPieceDel := TOB.Create('PIECE', nil, -1);
  TOBPieceDel.Dupliquer(TOBPiece, False, True);
  TOBNomenDel := TOB.Create('', nil, -1);
  SetLength(NomenASup, TOBNomenclature.Detail.Count);
  IndiceNomenDel := 1;
  for i := Low(NomenASup) to High(NomenASup) do NomenASup[i] := False;
  for i := TOBPiece.Detail.Count - 1 downto 0 do
  begin
    {Tests préalables}
    TOBL := TOBPiece.Detail[i];
    if TOBL = nil then Break;
    RefArt := TOBL.GetValue('GL_ARTICLE');
    if RefArt = '' then Continue;
    if ((not TOBL.FieldExists('SUPPRIME')) or (TOBL.GetValue('SUPPRIME') <> 'X')) then Continue;
    // suppression des composants de nomenclature rattachés
    if TOBL.GetValue('GL_TYPEARTICLE') = 'NOM' then
    begin
      IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
      if TOBNomenclature.Detail.Count - 1 >= IndiceNomen - 1 then
      begin
        TOBLNDel := TOB.Create('LIGNENOMEN', TOBNomenDel, -1);
        if TOBLNDel = nil then Continue;
        TOBLNDel.Dupliquer(TOBNomenclature.Detail[IndiceNomen - 1], True, True);
        NomenASup[IndiceNomen - 1] := True;
        //TOBNomenclature.Detail[IndiceNomen-1].Free ;
      end;
    end;
    TOBLDel := NewTOBLigne(TOBPieceDel, 0);
    if TOBLDel = nil then Continue;
    TOBLDel.Dupliquer(TOBL, False, True);
    if TOBL.GetValue('GL_TYPEARTICLE') = 'NOM' then
    begin
      TOBLDel.PutValue('GL_INDICENOMEN', IndiceNomenDel);
      Inc(IndiceNomenDel);
    end;
    {Suppression et renumérotation : Destruction des lots, série, de l'analytique et en dernier de la ligne}
    DetruitLot(i + 1);
    DetruitSerie(i + 1);
    TOBL.ClearDetail;
    for j := i + 1 to TOBPiece.Detail.Count - 1 do
    begin
      TOBDec := TOBPiece.Detail[j];
      TOBDec.PutValue('GL_NUMLIGNE', j);
      if TOBDec.Detail.Count > 0 then
      begin
        TOBAL := TOBDec.Detail[0];
        for k := 0 to TOBAL.Detail.Count - 1 do
        begin
          TOBAna := TOBAL.Detail[k];
          TOBAna.PutValue('YVA_IDENTLIGNE', FormatFloat('000', j + 1));
        end;
      end;
    end;
    TOBL.Free;
  end;
  if TOBPieceDel.Detail.Count > 0 then
  begin
    for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      // Nomenclatures
      if TOBL.GetValue('GL_TYPEARTICLE') = 'NOM' then
      begin
        IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
        ReAffecteLigNomen(IndiceNomen, TOBL, TOBNomenclature);
      end;
    end;

    TobNomenCop := Tob.Create('', nil, -1);
    TobNomenCop.Dupliquer(TobNomenclature, True, True, True);
    TobNomenclature.ClearDetail;
    for i := Low(NomenASup) to High(NomenASup) do
    begin
      if NomenASup[i] = False then
        Tob.Create('', TobNomenclature, -1).Dupliquer(TobNomenCop.Detail[i], True, True, True);
      // DBR : ça décalait les indices de la tob donc supprimait les mauvais détails de nomenclature
      //if NomenASup[i]=True then TOBNomenclature.Detail[i].Free ;
    end;
    TobNomenCop.Free;

    CreerAnnulation(TOBPieceDel, TOBNomenDel);
  end;
  TOBPieceDel.Free;
  TOBNomenDel.Free;
end;

procedure TFFacture.GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG: TOB);
var TOBL, TOBRG: TOB;
  Indice: integer;
begin
  if TOBPieceRG = nil then exit;
  if TOBPIeceRG.detail.count > 0 then
  begin
    Indice := 0;
    repeat
      TOBRG := TOBPieceRG.detail[Indice];
      if TOBRG.GEtVAlue('PRG_TAUXRG') = 0 then TOBRG.free else Inc(Indice);
    until Indice >= TOBPieceRG.detail.count - 1;
  end;
  if (TOBPIECERG.Detail.count = 1) then
  begin
    TOBL := TOBPIece.findfirst(['GL_TYPELIGNE'], ['RG'], true);
    if (TOBL <> nil) then TOBL.free;
    InsereLigneRG(TOBPIece, TOBPIeceRG.detail[0], TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG, -1);
  end;
end;

procedure TFFacture.ValideLaPiece; { NEWPIECE }
var OldEcr, OldStk: RMVT;
  SavAcompteInit: double; // Modif BTP
begin
  if Action = taConsult then
  begin
    Close;
    Exit;
  end;
  Inc(NbTransact);
  if NbTransact > 1 then
  begin
    if not TOBPiece.FieldExists('REVALIDATION') then TOBPiece.AddChampSup('REVALIDATION', False);
    TOBPiece.PutValue('REVALIDATION', 'X');
    if TOBAdresses.Detail.Count < 2 then
    begin
      TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
      TOBAdresses.Detail[1].Dupliquer(TOBAdresses.Detail[0], True, True);
    end;
  end;
  InitMove(8, '');
  SavAcompteInit := -1; // Modif BTP
  if EstAvoir then
  begin
    if not AvoirDejaInverse then
    begin
      InverseAvoir;
      AvoirDejaInverse := True;
    end;
  end;
  MoveCur(False);
  ReaffecteDispoContreM(TOBPiece_O, TOBPiece, TOBCatalogu);
  ReaffecteDispoDiff(TOBArticles); //JD 25/03/03

  {$IFDEF AFFAIRE}
  ImpactActiviteLigne(TOBPiece, GereActivite);
  {$ENDIF}
  MoveCur(False);
  {Traitement pièce d'origine}
  if ((Action = taModif) and (not DuplicPiece)) then
  begin
    if V_PGI.IoError = oeOk then DetruitCompta(TOBPiece_O, OldEcr, OldStk);
    if V_PGI.IoError = oeOk then DelOrUpdateAncien; { NEWPIECE }
    if not TransfoPiece then
    begin
      if V_PGI.IoError = oeOk then InverseStock(TOBPiece_O, TOBArticles, TOBCatalogu, TOBN_O);
      {$IFNDEF CCS3}
      if V_PGI.IoError = oeOk then InverseStockLot(TOBPiece_O, TOBLOT_O, TOBArticles);
      if V_PGI.IoError = oeOk then InverseStockSerie(TOBPiece_O, TOBSerie_O);
      {$ENDIF}
    end
    else
    begin
      if V_PGI.IoError = oeOk then InverseStockTransfo(TOBPiece_O, TobPiece, TOBArticles, TOBCatalogu, TOBN_O);
      {$IFNDEF CCS3}
      if V_PGI.IoError = oeOk then InverseStockLotTransfo(TOBPiece_O, TobPiece, TobLot_O, TobArticles);
      if V_PGI.IoError = oeOk then InverseStockSerieTransfo(TOBPiece_O, TobPiece, TOBSerie_O);
      {$ENDIF}
    end;
  end;
  MoveCur(False);
  {Enregistrement nouvelle pièce}
  if V_PGI.IoError = oeOk then
  begin
    InitToutModif;
    ValideLaNumerotation;
    ValideLaCotation(TOBPiece, TOBBases, TOBEches);
    ValideLaPeriode(TOBPiece);
    if GetInfoParPiece(NewNature, 'GPP_IMPIMMEDIATE') = 'X' then TOBPiece.PutValue('GP_EDITEE', 'X');
  end;
  MoveCur(False);
  // Modif Btp
  if V_PGI.IoError = oeOk then SupLesLibDetail(TOBPiece);
  if V_PGI.IoError = oeOk then GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG);
  if V_PGI.IoError = oeOk then ValideLesLignes(TOBPiece, TOBArticles, TOBCatalogu, TOBNomenclature, TobOuvrage, TOBPieceRG, TOBBasesRG, False, False);
  {$IFDEF BTP}
  if V_PGI.IoError = oeOk then ValideLesOuv(TOBOuvrage, TOBPIece);
  if V_PGI.IoError = oeOk then
  begin
    AjouteLignesVirtuellesOuv(TOBPIece, TOBOuvrage, TOBArticles, TOBCpta, TOBTiers, TOBCatalogu, TOBAffaire, DEV);
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculFacture(TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBPorcs, TOBPieceRG, TOBBasesRg, DEV);
  end;
  {$ENDIF}
  if V_PGI.IoError = oeOk then
  begin
    if (tModeBlocNotes in SaContexte) then ValideLesLiensOle(TOBPiece, TOBPiece_O, TOBLienOLE);
  end;
  // -------------------
  //if V_PGI.IoError=oeOk then ValideLesLignes(TOBPiece,TOBArticles,TOBCatalogu,TOBNomenclature,False,False) ;
  if V_PGI.IoError = oeOk then ValideLesAdresses(TOBPiece, TOBPiece_O, TOBAdresses);
  if V_PGI.IoError = oeOk then
  begin
    GereLesReliquats;
    ElimineLignesZero;
  end;
  { NEWPIECE }
  if (Action = taModif) and (not DuplicPiece) and (ReliquatTransfo) then
  begin
    if not TOBPiece_O.UpdateDB(False) then
      V_PGI.IoError := oeSaisie; { NEWPIECE }
  end;
  if (V_PGI.IoError = oeOk) and (Action = taModif) and (not DuplicPiece) and (not TransfoPiece) then
  begin
    if GppReliquat then { Modification d'une pièce dans laquelle les reliquats sont gérés }
    begin
      { Remise à jour du GL_QTERESTE dans la pièce d'origine }
      UpdateResteALivrer(TobPiece, TobPiece_O, TOBArticles, TOBCatalogu, TOBNomenclature, urModif);
      { Recalcul du GL_QTERELIQUAT dans les lignes issues de la pièce en cours de saisie }
  //    if (V_PGI.IoError = oeOk) then
  //      UpdateQuantiteReliquat(TobPiece, TobPiece_O);
    end;
  end;

  {$IFDEF AFFAIRE}
  if V_PGI.IoError = oeOk then ValideActivite(TOBPiece, TOBPiece_O, TOBArticles, GereActivite, False, DelActivite);
  {$ENDIF}
  MoveCur(False);
  if V_PGI.IoError = oeOk then ValideLesLots;
  if V_PGI.IoError = oeOk then ValideLesArticles(TOBPiece, TOBArticles);
  if V_PGI.IoError = oeOk then ValideLesCatalogues(TOBPiece, TOBCatalogu);
  if V_PGI.IoError = oeOk then ValideAnalytiques(TOBPiece, TOBAnaP, TOBAnaS);
  if V_PGI.IoError = oeOk then ValideTiers;
  MoveCur(False);
  if V_PGI.IoError = oeOk then ValideLaCompta(OldEcr, OldStk);
  // if V_PGI.IoError=oeOk then ValideLesLots ; déplacé
  if V_PGI.IoError = oeOk then ValideLesSeries;
  {$IFNDEF CHR}
  if (SaisieTypeAvanc) or ((TobPiece.GetValue('GP_NATUREPIECEG') = GetParamSoc('SO_AFNATAFFAIRE')) and (ISAcompteSoldePartiel(TOBPiece))) then
  begin
    // Pour Eviter de rattacher le reliquat d'acompte au devis initial lors de la facturation
    // ou pour eviter de perdre le montant initial d'acompte lors de la modification d'un devis apres facturation partielle
    SavAcompteInit := TOBPiece_O.GetValue('GP_ACOMPTEDEV');
  end;
  if V_PGI.IoError = oeOk then ValideLesAcomptes(TOBPiece, TOBAcomptes);
  if SavAcompteInit >= 0 then TOBPiece.PutValue('GP_ACOMPTEDEV', SavAcompteInit);
  {$ENDIF}
  if V_PGI.IoError = oeOk then ValideLesPorcs(TOBPiece, TOBPorcs);
  {$IFDEF BTP}
  if V_PGI.IoError = oeOk then DetruitLignesVirtuellesOuv(TOBPIece, DEV);
  {$ENDIF}
  MoveCur(False);
  // Modif BTP
  if V_PGI.IoError = oeOk then ValideLesRetenues(TOBPiece, TOBPieceRG);
  if V_PGI.IoError = oeOk then ValideLesBasesRG(TOBPiece, TOBBasesRG);
  // --
  if V_PGI.IoError = oeOk then
  begin
    if not TOBPiece.InsertDBByNivel(False) then V_PGI.IoError := oeUnknown;
  end;
  MoveCur(False);
  if V_PGI.IoError = oeOk then
  begin
    if not TOBBases.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBEches.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBAnaP.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBAnaS.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  end;
  if V_PGI.IoError = oeOk then ValideLesNomen(TOBNomenclature);
  {$IFDEF BTP}
  // Modif BTP
  if V_PGI.IoError = oeOk then ModifSituation(TOBPiece, TOBPieceRG, TOBPieceRG_O, TOBBasesRg, TOBAcomptes, DEV);
  {$ENDIF}
  {$IFDEF AFFAIRE}
  if V_PGI.IoError = oeOk then if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then
      MajAffaire(TOBPiece, TOBAcomptes, Codeaffaireavenant, 'VAL', Action, DuplicPiece, SaisieTypeAvanc);
  {$ENDIF}
  FiniMove;
end;

procedure TFFacture.ValideImpression;
var imprimeok: boolean;
  {$IFDEF BTP}
  Ret: string;
  {$ENDIF}
begin
  imprimeok := True;
  {$IFDEF BTP}
  Ret := AGLLanceFiche('BTP', 'BTPARIMPDOC', '', '', 'NATURE=' + CleDoc.NaturePiece + ';NUMERO=' + inttostr(CleDoc.NumeroPiece) + ';AFFAIRE=' +
    TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if (Ret = '') or (Ret = '0') then
    imprimeok := False;
  {$ENDIF}
  // DEBUT AJOUT CHR
  {$IFNDEF CHR}
  if imprimeok then ImprimerLaPiece(TOBPiece, TOBTiers, CleDoc);
  {$ENDIF}
  // FIN AJOUT CHR
end;

function TFFacture.ExisteLigneSupp: Boolean;
var TOBL: TOB;
  i: integer;
  PiecePrec, NatPiece: string;
begin
  Result := False;
  if (Action <> taModif) then Exit;
  //if Not TransfoPiece then Exit ;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if ((TOBL.FieldExists('SUPPRIME')) and (TOBL.GetValue('SUPPRIME') = 'X')) then
    begin
      PiecePrec := TOBL.GetValue('GL_PIECEPRECEDENTE');
      ReadTokenSt(PiecePrec);
      NatPiece := ReadTokenSt(PiecePrec);
      NatPieceAnnule := GetinfoParPiece(NatPiece, 'GPP_NATPIECEANNUL');
      if NatPieceAnnule <> '' then Result := True;
      break;
    end;
  end;
end;

procedure TFFacture.ValideNumeroPieceAnnule;
var NewNum: integer;
  TOBPieceDel: TOB;
  Souche: string;
begin
  if (Action = taModif) then
  begin
    TOBPieceDel := TOB.Create('PIECE', nil, -1);
    TOBPieceDel.Dupliquer(TOBPiece, False, True);
    Souche := GetSoucheG(NatPieceAnnule, TOBPieceDel.GetValue('GP_ETABLISSEMENT'), TOBPieceDel.GetValue('GP_DOMAINE'));
    TOBPieceDel.PutValue('GP_NATUREPIECEG', NatPieceAnnule);
    TOBPieceDel.PutValue('GP_SOUCHE', Souche);
    NewNum := SetNumberAttribution(TOBPieceDel.GetValue('GP_SOUCHE'), 1);
    if NewNum > 0 then NumPieceAnnule := NewNum;
    TOBPieceDel.Free;
  end;
end;

procedure TFFacture.ValideNumeroPiece;
var NewNum: integer;
begin
  if ((Action = taCreat) or (TransfoPiece) or (DuplicPiece)) then
  begin
    NewNum := SetNumberAttribution(TOBPiece.GetValue('GP_SOUCHE'), 1);
    if NewNum > 0 then CleDoc.NumeroPiece := NewNum;
  end;
end;

function TFFacture.TOBGSAPleine: Boolean;
begin
  Result := False;
  if (CtxMode in V_PGI.PGIContexte) then
  begin
    if TOBGSA.Detail.Count > 0 then
    begin
      if HPiece.Execute(48, Caption, '') = mrYes then
      begin
        Result := True;
        BSaisieAveugleClick(nil);
      end;
    end;
  end;
end;

procedure TFFacture.ClickValide(EnregSeul: boolean = False);
var io: TIOErr;
  ResGC: integer;
  Ok, bForceEche, bOuvreEche: boolean;
  {$IFDEF BTP}
  IsAcompteRegl: Boolean;
  {$ENDIF}

  procedure ErrorValid(NumMsg: integer);
  var TobJnal: TOB;
    Qry: TQuery;
    NumEvt: integer;
    Nature, ActionSurPiece, TypeEvt: string;
    BlocNote: TStringList;
  begin
    MessageAlerte(HTitres.Mess[NumMsg]);
    ValideEnCours := False;

    //Maj Journal uniquement en création, duplication ou transformation
    GP_NUMEROPIECE.Caption := HTitres.Mess[10]; //Raz du numéro affiché
    if (Action = taConsult) or
      ((Action = taModif) and ((not DuplicPiece) and (not TransfoPiece))) then exit;

    if Action = taCreat then
    begin
      ActionSurPiece := TraduireMemoire('Création');
      TypeEvt := 'CRE';
    end else
      if (Action = taModif) and (DuplicPiece) then
    begin
      ActionSurPiece := TraduireMemoire('Duplication');
      TypeEvt := 'DUP';
    end else
      if (Action = taModif) and (TransfoPiece) then
    begin
      ActionSurPiece := TraduireMemoire('Génération');
      TypeEvt := 'GEN';
    end;

    Nature := RechDom('GCNATUREPIECEG', TOBPiece.GetValue('GP_NATUREPIECEG'), False);
    BlocNote := TStringList.Create;
    BlocNote.Add(Nature + TraduireMemoire(' numéro ') + IntToStr(TOBPiece.GetValue('GP_NUMERO')));
    BlocNote.Add(TraduireMemoire('Numéro affecté lors d''une erreur en ') + ActionSurPiece);
    BlocNote.Add(TraduireMemoire('Message : ') + HTitres.Mess[NumMsg]);
    TobJnal := TOB.Create('JNALEVENT', nil, -1);
    TobJnal.PutValue('GEV_TYPEEVENT', TypeEvt);
    TobJnal.PutValue('GEV_LIBELLE', Copy(ActionSurPiece + ' de ' + Nature, 1, 35));
    TobJnal.PutValue('GEV_DATEEVENT', Date);
    TobJnal.PutValue('GEV_UTILISATEUR', V_PGI.User);
    TobJnal.PutValue('GEV_ETATEVENT', 'ERR');
    TobJnal.PutValue('GEV_BLOCNOTE', BlocNote.Text);
    Qry := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True);
    if not Qry.EOF then
      NumEvt := Qry.Fields[0].AsInteger
    else
      NumEvt := 0;
    Ferme(Qry);
    Inc(NumEvt);
    TOBJnal.PutValue('GEV_NUMEVENT', NumEvt);
    TobJnal.InsertDB(nil);
    TobJnal.Free;
    BlocNote.Free;
  end;

begin
  // Tests et actions préalables
  if not BValider.Enabled then Exit;
  if Action = taConsult then Exit;
  {$IFDEF MODE}
  TraiteLaFusion(True);
  {$ENDIF}
  if not SortDeLaLigne then Exit;
  if TOBGSAPleine then exit;
  {$IFDEF AFFAIRE}
  // mcd 21/03/02 test si affaire renseigné
  if (VenteAchat = 'ACH') and (TestAffaire(TobPiece)) then exit;
  {$ENDIF}
  NextPrevControl(Self);
  {$IFDEF BTP}
  IsAcompteRegl := AcompteRegle(TOBPiece);
  // gestion des acomptes en fonction de la demande d'un acompte obligatoire ou si un acompte a été défini sur le devis
  if (SaisieTypeAvanc) and ((TOBAcomptes.detail.count > 0) or (AcompteObligatoire and not (IsAcompteRegl))) then AvancementAcompte;
  {$ENDIF}
  // --
  // Modif BTP : dans le cas ou l'on ne modifie que les textes sans sortir
  ValidationSaisie := True; //MODIFBTP
  if DuplicPiece then
  begin
    TOBLienOLE_O.clearDetail;
    TOBLienOLE.clearDetail;
  end;
  RemplitLiens(TOBPiece, TOBLienOLE, Debut, 1);
  RemplitLiens(TOBPiece, TOBLienOLE, Fin, 2);
  // -----
  if (DuplicPiece) or ((GP_DEVISE.Value <> V_PGI.DevisePivot) and (not EstMonnaieIN(GP_DEVISE.Value))) then
  begin
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
  end;
  TOBPiece.GetEcran(Self, PEntete);
  if ctxAffaire in V_PGI.PGIContexte then TOBPiece.GetEcran(Self, PEnteteAffaire);
  AfficheTaxes;
  AffichePorcs;
  PositionneVisa;
  if not PieceModifiee then Exit;
  // Stat
  if not SaisieTablesLibres(TOBPiece) then Exit;
  DepileTOBLignes(GS, TOBPiece, GS.Row, 1);
  if TesteRisqueTiers(True) then Exit;
  if TesteMargeMini(GS.Row) then Exit;
  // Gestion net à payer <> 0 si reglement obligatoire
  if ((Action = taCreat) and (ObligeRegle)) then
  begin
    case GCValideReglementOblig(TobPiece, TobTiers, TOBPieceRg, DEV) of
      0: Exit; {retour en saisie}
      1:
        begin
          ClickAcompte(False);
          exit;
        end; {Retour en affectation de reglement}
      2: ; {on enregistre tout }
    end;
  end;
  // Contrôle intégrité
  ResGC := GCPieceCorrecte(TOBPiece, TOBArticles, TOBCatalogu);
  if ResGC > 0 then
  begin
    HErr.Execute(ResGC, Caption, '');
    Exit;
  end;
  { Vérification des quantités }
  if Action = taModif then
  begin
    if VerifQuantitePieceSuivante(TobPiece) <> 0 then
      HPiece.Execute(51, Caption, '');
  end;
  if ((Action = taModif) and (not DuplicPiece)) then
    if not PieceEncoreVivante(TOBPiece_O) then
    begin
      HErr.Execute(7, Caption, '');
      Exit;
    end;
  // Appels automatiques en fin de saisie
  if not BeforeValide(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, DEV, OldHT) then Exit;
  if OuvreAutoPort then ClickPorcs;
  if CompAnalP = 'AUT' then ClickVentil(True, False);

  bForceEche := ((DEV.Code <> '') and (DEV.Code <> V_PGI.DevisePivot) and
    (DEV.Code <> V_PGI.DeviseFongible) and (not EstMonnaieIn(DEV.Code)));
  bOuvreEche := (GereEche = 'AUT') or (bForceEche);
  {$IFNDEF CHR}
  if CtxMode in V_PGI.PGIContexte then Ok := GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPIECERG, Action, DEV, bOuvreEche)
  else Ok := GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPIECERG, Action, DEV, bOuvreEche);
  if not Ok then Exit else GP_MODEREGLE.Value := TOBPiece.GetValue('GP_MODEREGLE');
  {$ENDIF}
  // Enregistrement de la saisie
  BValider.Enabled := False;
  ValideEnCours := True;
  io := Transactions(ValideNumeroPiece, 5);
  if io = oeOk then
  begin
    if ExisteLigneSupp then io := Transactions(ValideNumeroPieceAnnule, 5);
  end;
  NbTransact := 0;
  if io = oeOk then io := Transactions(ValideLaPiece, 5);
  BValider.Enabled := True;
  if io <> oeOk then
  begin
    if not TOBPiece.FieldExists('REVALIDATION') then TOBPiece.AddChampSup('REVALIDATION', False);
    TOBPiece.PutValue('REVALIDATION', 'X');
    if TOBAdresses.Detail.Count < 2 then
    begin
      TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
      TOBAdresses.Detail[1].Dupliquer(TOBAdresses.Detail[0], True, True);
    end;
  end;
  case io of
    oeOk:
      begin
        if TOBPiece.FieldExists('REVALIDATION') then TOBPiece.PutValue('REVALIDATION', '-');
        ForcerFerme := True;
        AvoirDejaInverse := False;
        AfterValide(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, DEV);
      end;
    oeUnknown: ErrorValid(5);
    oeSaisie: ErrorValid(6);
    oePointage: ErrorValid(23);
    oeLettrage: ErrorValid(13);
    oeStock: ErrorValid(27);
  end;
  if io <> oeOk then exit;
  ValideEnCours := False;
  BValider.Enabled := False;
  // Modif BTP
  if (EnregSeul) and (Action <> taCreat) then
  begin
    Exit;
  end;
  // -----
  if (GetInfoParPiece(NewNature, 'GPP_IMPIMMEDIATE') = 'X') or (GetInfoParPiece(NewNature, 'GPP_VALMODELE') = 'X') or (GetInfoParPiece(NewNature, 'GPP_IMPETIQ')
    = 'X') then
  begin
    if ((Action = taCreat) or (Action = taModif) or (DuplicPiece) or (TransfoPiece)) and
      not (SaisieTypeAvanc) then
    begin
      io := Transactions(ValideImpression, 1);
      if io <> oeOk then
      begin
        DeflagEdit(TOBPiece);
        MessageAlerte(HTitres.Mess[19]);
      end;
    end;
  end;
  if Action <> taCreat then
  begin
    if ((DuplicPiece) or (TransfoPiece)) then MontreNumero(TOBPiece);
    Close;
  end else
  begin
    VH_GC.GCLastRefPiece := EncodeRefPiece(TOBPiece);
    MontreNumero(TOBPiece);
    if (PasBouclerCreat) then Close else ReInitPiece;
  end;
  BValider.Enabled := True;
end;

procedure TFFacture.BValiderClick(Sender: TObject);
begin
  ClickValide;
end;

procedure TFFacture.BAbandonClick(Sender: TObject);
begin
  ValidationSaisie := False; //MODIFBTP
  Close;
  if FClosing and IsInside(Self) then THPanel(parent).CloseInside;
end;

procedure TFFacture.TSaisieAveugleClose(Sender: TObject);
var i: integer;
begin
  for i := TOBGSA.Detail.Count - 1 downto 0 do
    if Trim(TOBGSA.detail[i].GetValue('CB')) = '' then TOBGSA.detail[i].Free;
  GSEnter(GS);
  GS.SynEnabled := True;
  PEnTete.Enabled := True;
  PPied.Enabled := True;
  BValider.Enabled := True;
  GS.Col := SG_RefArt;
end;

procedure TFFacture.TSaisieAveugleResize(Sender: TObject);
var Coord: TRect;
begin
  HMTrad.ResizeGridColumns(GSAveugle);
  if TSaisieAveugle.Height < 116 then TSaisieAveugle.Height := 116;
  if TSaisieAveugle.Width < 400 then TSaisieAveugle.Width := 400;

  Coord := GSAveugle.CellRect(Col_Qte, 0);
  SommeQTE.Left := Coord.Left;
  SommeQTE.Width := HTotaux.Width - SommeQTE.Left;
end;

procedure TFFacture.GSAveugleCellEnter(Sender: TObject; var ACol,
  ARow: Integer; var Cancel: Boolean);
begin
  if Action = taConsult then Exit;
  if (GSAveugle.Col = Col_Qte) and (GSAveugle.Cells[Col_Lib, GSAveugle.Row] = '') then
    GSAveugle.Col := Col_CB;
end;

procedure TFFacture.GSAveugleRowExit(Sender: TObject; Ou: Integer;
  var Cancel: Boolean; Chg: Boolean);
begin
  if Action = taConsult then Exit;
  if (GSAveugle.RowCount <> 2) and (GSAveugle.Cells[Col_CB, Ou] = '') then
    SupLigneGSA(Ou);
  SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
end;

procedure TFFacture.GSAveugleCellExit(Sender: TObject; var ACol,
  ARow: Integer; var Cancel: Boolean);
var CodeBarre, WhereNat, SelectFourniss: string;
  TOBArt, TF, TOBNat, TOBG: TOB;
  NewQte: double;
  Q: TQuery;
  IsFerme: Boolean;
begin
  if Action = taConsult then Exit;
  SelectFourniss := '';
  CodeBarre := Trim(GSAveugle.Cells[Col_CB, ARow]);
  TF := GetTOBLigne(TOBGSA, ARow);
  if TF = nil then exit;
  if (ACol = Col_CB) and (TF.GetValue('CB') <> CodeBarre) then
  begin
    if CodeBarre = '' then
    begin
      TF.Free;
      CreerTOBFilleGSA(ARow);
      exit;
    end;
    //Recherche dans TOBGSA
    TF := TOBGSA.FindFirst(['CB'], [CodeBarre], False);
    if TF <> nil then
    begin
      InsertNewArtInGSAveugle(CodeBarre, nil, nil, TF, ARow);
      exit;
    end
    else
    begin
      //Recherche Article dans TOBPiece par son Code Barre
      TOBArt := TOBArticles.FindFirst(['GA_CODEBARRE'], [CodeBarre], False);
      if TOBArt = nil then
      begin
        //Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur sont dispo.
        if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
          (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then SelectFourniss := GP_TIERS.Text;
        WhereNat := FabricWhereNatArt(CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss);
        if WhereNat <> '' then WhereNat := ' AND ' + WhereNat;
        // Recherche via code barre
        Q := OpenSQL('Select * from ARTICLE Where GA_CODEBARRE="' + CodeBarre + '" ' + WhereNat, True);
        try
          //Multi code barres spécifique DEFI MODE
          if Q.EOF then
          begin
            if GetParamSoc('SO_ARTMULTICODEBARRE') then
            begin
              Ferme(Q);
              Q := OpenSQL('Select * from ARTICLE Where GA_CODEDOUANIER="' + CodeBarre + '" ' + WhereNat, True);
            end;
          end;
          if not Q.EOF then
          begin
            isFerme := (Q.FindField('GA_FERME').AsString = 'X');
            if isFerme then
            begin
              TOBNat := VH_GC.TOBParPiece.FindFirst(['GPP_NATUREPIECEG'], [CleDoc.NaturePiece], False);
              if TOBNat <> nil then
                TOBG := TOBNat.FindFirst(['GAP_NATUREPIECEG', 'GAP_ARTICLE'], [CleDoc.NaturePiece, Q.FindField('GA_ARTICLE').AsString], False)
              else TOBG := nil;
              if TOBG <> nil then IsFerme := (TOBG.GetValue('GAP_SUSPENSION') = 'X');
            end;
            if isFerme then
            begin
              HPiece.Execute(2, Caption, '');
              GSAveugle.SetFocus;
              Cancel := True;
            end
            else InsertNewArtInGSAveugle(CodeBarre, Q, nil, nil, ARow);
          end
          else
          begin
            if SelectFourniss = '' then MessageAlerte(HAveugle.Mess[0]) else MessageAlerte(HAveugle.Mess[4]);
            GSAveugle.SetFocus;
            Cancel := True;
          end;
        finally Ferme(Q);
        end;
      end
      else InsertNewArtInGSAveugle(CodeBarre, nil, TOBArt, nil, ARow);
    end;
  end;
  if (ACol = Col_Qte) and (TF.GetValue('QTE') <> Valeur(GSAveugle.Cells[Col_Qte, ARow])) then
  begin
    NewQte := Valeur(GSAveugle.Cells[Col_Qte, ARow]);
    if ((BtRetour.Down) and (NewQte > 0)) or (not (BtRetour.Down) and (NewQte < 0)) then
    begin
      NewQte := -NewQte;
      GSAveugle.Cells[Col_Qte, ARow] := FloatToStr(NewQte);
    end;
    TF.PutValue('QTE', NewQte);
    SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
  end;
end;

procedure TFFacture.GSAveugleRowEnter(Sender: TObject; Ou: Integer;
  var Cancel: Boolean; Chg: Boolean);
begin
  if Action = taConsult then Exit;
  if (TOBGSA.Detail.Count >= GSAveugle.RowCount - 1) or (Ou = 0) then Exit;
  if GetTOBLigne(TOBGSA, Ou) = nil then CreerTOBFilleGSA(Ou);
end;

function TFFacture.CreerTOBFilleGSA(ARow: integer): TOB;
var TF: TOB;
begin
  TF := TOB.Create('', TOBGSA, ARow - 1);
  TF.AddChampSup('RefArticle', True);
  TF.AddChampSup('CB', True);
  TF.AddChampSup('LIBELLE', True);
  TF.AddChampSup('QTE', True);
  TF.PutValue('QTE', 0);
  Result := TF;
end;

procedure TFFacture.GSAveugleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Vide, Cancel: Boolean;
  ARow, ACol: Longint;
begin
  Vide := (Shift = []);
  ARow := GSAveugle.Row;
  ACol := GSAveugle.Col;
  Cancel := False;
  case Key of
    VK_RETURN: if Vide then SendMessage(GSAveugle.Handle, WM_KeyDown, VK_DOWN, 0);
    VK_DOWN:
      begin
        if Vide and (ARow = GSAveugle.RowCount - 1) then
        begin
          GSAveugleCellExit(GSAveugle, ACol, ARow, Cancel);
          if not Cancel then GSAveugleRowExit(GSAveugle, ARow, Cancel, False);
          if not Cancel then InsertLigneGSAveugle;
        end;
      end;
    VK_TAB:
      begin
        GSAveugleCellExit(GSAveugle, ACol, ARow, Cancel);
        if Vide and (GSAveugle.Col = Col_Qte) and (ARow = GSAveugle.RowCount - 1) then
        begin
          if not Cancel then GSAveugleRowExit(GSAveugle, ARow, Cancel, False);
          if not Cancel then InsertLigneGSAveugle;
          GSAveugle.Row := GSAveugle.RowCount - 1;
        end;
      end;
  end;
end;

procedure TFFacture.BtRefreshSAClick(Sender: TObject);
begin
  if TOBGSA.Detail.Count = 0 then exit;
  if GSAveugle.Cells[Col_Lib, 1] = '' then exit;
  if HAveugle.Execute(3, 'Saisie par code barre', '') = MrYes then
  begin
    GSAveugle.VidePile(False);
    GSAveugle.Row := 1;
    GSAveugle.Col := Col_CB;
    GSAveugle.SetFocus;
    TOBGSA.ClearDetail;
    CreerTOBFilleGSA(1);
    SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
  end;
end;

procedure TFFacture.BtFermerSAClick(Sender: TObject);
begin
  TSaisieAveugle.Hide;
  TSaisieAveugleClose(Sender);
end;

procedure TFFacture.BtValiderSAClick(Sender: TObject);
var i, ACol, ARow: integer;
  Cancel, Traiter: boolean;
  RefArticle, Designation: string;
  Quantite: Double;
  TOBSaisieAveugle: TOB;
begin
  SourisSablier;
  SaisieCodeBarreAvecFenetre := True;
  ACol := GSAveugle.Col;
  ARow := GSAveugle.Row;
  Cancel := False;
  GSAveugleCellExit(GSAveugle, ACol, ARow, Cancel);
  if Cancel then exit;
  GSEnter(GS);
  try
    GS.SynEnabled := False;
    TOBSaisieAveugle := RetourneTOBSaisieAveugle;
    for i := TOBSaisieAveugle.Detail.count - 1 downto 0 do
      if Valeur(TOBSaisieAveugle.Detail[i].GetValue('QTE')) = 0 then TOBSaisieAveugle.Detail[i].Free;
    TOBSaisieAveugle.Detail.Sort('RefArticle');
    Traiter := TOBSaisieAveugle.Detail.Count > 0;
    if Traiter then
    begin
      NonPourTousNewArt := False;
      NonPourTousQteSup := False;
      if Action = taCreat then
      begin
        OuiPourTousNewArt := True;
        OuiPourTousQteSup := True;
      end
      else
      begin
        OuiPourTousNewArt := False;
        OuiPourTousQteSup := False;
      end;
      for i := 0 to TOBSaisieAveugle.Detail.count - 1 do
      begin
        RefArticle := TOBSaisieAveugle.Detail[i].GetValue('RefArticle');
        Designation := TOBSaisieAveugle.Detail[i].GetValue('LIBELLE');
        Quantite := TOBSaisieAveugle.Detail[i].GetValue('QTE');
        GSAVersGS(RefArticle, Designation, Quantite);
      end;
    end;
    GSAveugle.VidePile(False);
    TOBSaisieAveugle.Free;
    TOBGSA.ClearDetail;
    TSaisieAveugle.Hide;
    CalculeLaSaisie(-1, -1, False);
    if Traiter then ShowDetail(TOBPiece.Detail.Count);
  finally
    SaisieCodeBarreAvecFenetre := False;
    SourisNormale;
    GS.SynEnabled := True;
    PEnTete.Enabled := True;
    PPied.Enabled := True;
    BValider.Enabled := True;
    GS.Col := SG_RefArt;
  end;
end;

function TFFacture.RetourneTOBSaisieAveugle: TOB;
var TOBSaisieAveugle, TF, TFSuivant: TOB;
  CodeBarre: string;
begin
  TOBSaisieAveugle := TOB.Create('', nil, -1);
  while TOBGSA.Detail.Count <> 0 do
  begin
    CodeBarre := Trim(TOBGSA.detail[0].GetValue('CB'));
    if CodeBarre = '' then TOBGSA.detail[0].Free
    else
    begin
      TF := TOBGSA.FindFirst(['CB'], [CodeBarre], False);
      if TF <> nil then TF.ChangeParent(TOBSaisieAveugle, -1);
      TFSuivant := TOBGSA.FindNext(['CB'], [CodeBarre], False);
      while TFSuivant <> nil do
      begin
        TF.PutValue('QTE', Valeur(TF.GetValue('QTE')) + Valeur(TFSuivant.GetValue('QTE')));
        TFSuivant.Free;
        TFSuivant := TOBGSA.FindNext(['CB'], [CodeBarre], False);
      end;
    end;
  end;
  Result := TOBSaisieAveugle;
end;

procedure TFFacture.BtDelLigneSAClick(Sender: TObject);
var ARow: integer;
begin
  ARow := GSAveugle.Row;
  if (ARow <= 0) or (GSAveugle.RowCount < 2) then Exit;
  if GSAveugle.Cells[Col_Lib, ARow] = '' then
  begin
    GSAveugle.Cells[Col_CB, ARow] := '';
    exit;
  end;
  if HShowMessage('1;' + TSaisieAveugle.Caption + ';' + TraduireMemoire('Voulez-vous supprimer cet article : "' + GSAveugle.Cells[Col_Lib, ARow] + '" ?') +
    ';Q;YN;N;N;', '', '') = mrYes then
  begin
    SupLigneGSA(ARow);
    SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
  end;
end;

procedure TFFacture.SupLigneGSA(ARow: Integer);
var TF: TOB;
begin
  if GSAveugle.RowCount = 2 then GSAveugle.RowCount := 3;
  GSAveugle.DeleteRow(ARow);
  TF := GetTOBLigne(TOBGSA, ARow);
  if TF <> nil then TF.Free;
  if ARow = 1 then GSAveugle.Row := 1 else GSAveugle.Row := ARow - 1;
  if TOBGSA.Detail.Count = 0 then CreerTOBFilleGSA(1);
  GSAveugle.SetFocus;
end;

procedure TFFacture.InitSaisieAveugle;
var Coord: TRect;
begin
  if (CtxMode in V_PGI.PGIContexte) and (Action <> taConsult) then
  begin
    BSaisieAveugle.Enabled := False;
    BSaisieAveugle.Visible := True;
    if TransfoPiece then
    begin
      BtQteAuto.Visible := True;
      AffecteQuantiteZeroInGS;
    end;
    Col_CB := 1;
    Col_Lib := 2;
    Col_Qte := 3;
    with GSAveugle do
    begin
      ColWidths[Col_CB] := 50;
      ColWidths[Col_Lib] := 100;
      ColWidths[Col_Qte] := 30;
      ColLengths[Col_Lib] := -1;
      ColTypes[Col_Qte] := 'R';
      ColFormats[Col_Qte] := '0.00';
      ColAligns[Col_Qte] := taRightJustify;
      RowCount := 2;
    end;
    AffecteGrid(GSAveugle, Action);

    Coord := GSAveugle.CellRect(Col_Qte, 0);
    SommeQTE.Left := Coord.Left;
    SommeQTE.Width := HTotaux.Width - SommeQTE.Left;
    SommeQTE.Value := 0;

    //Augmente la taille de la police et la hauteur des lignes de la grille pour l'utilisation tactile
    if CtxFO in V_PGI.PGIContexte then
    begin
      GSAveugle.DefaultRowHeight := 21;
      GSAveugle.Font.Size := 11;
    end;

    if SaisieAveugle then BSaisieAveugleClick(nil);
  end;
end;

procedure TFFacture.InsertLigneGSAveugle;
begin
  if (GSAveugle.Row = GSAveugle.Rowcount - 1) and (GSAveugle.Cells[Col_CB, GSAveugle.Rowcount - 1] <> '') then
  begin
    CreerTOBFilleGSA(GSAveugle.Rowcount);
    GSAveugle.InsertRow(GSAveugle.Rowcount);
    GSAveugle.Col := Col_CB;
  end;
end;

procedure TFFacture.InsertNewArtInGSAveugle(CodeBarre: string; Q: TQuery; TOBArt, TOBFilleSA: TOB; ARow: integer);
var TF: TOB;
  RefArt, Designation: string;
begin
  if (Q <> nil) then
  begin
    TOBArt := CreerTOBArt(TOBArticles);
    TOBArt.SelectDB('', Q);
  end;
  if (TOBArt <> nil) then
  begin
    RefArt := TOBArt.getvalue('GA_ARTICLE');
    if TOBArt.getvalue('GA_STATUTART') = 'DIM' then
      Designation := Copy(TOBArt.getvalue('GA_LIBELLE') + RetourneLibelleAvecDimensions(RefArt, TOBArt), 1, 70)
    else Designation := TOBArt.getvalue('GA_LIBELLE');
  end
  else if TOBFilleSA <> nil then
  begin
    RefArt := TOBFilleSA.getvalue('RefArticle');
    Designation := TOBFilleSA.getvalue('Libelle');
  end;

  TF := GetTOBLigne(TOBGSA, ARow);
  if TF = nil then exit;
  TF.PutValue('CB', CodeBarre);
  TF.PutValue('RefArticle', RefArt);
  TF.PutValue('LIBELLE', Designation);
  if BtRetour.Down then TF.PutValue('QTE', -1) else TF.PutValue('QTE', 1);
  TF.PutLigneGrid(GSAveugle, ARow, False, False, StColNameGSA);
end;

function TFFacture.RetourneLibelleAvecDimensions(RefArtDim: string; TOBArt: TOB): string;
var k: integer;
  Grille, CodeDim, LibDim: string;
begin
  LibDim := '';
  if TOBArt <> nil then
  begin
    for k := 1 to 5 do
    begin
      Grille := TOBArt.GetValue('GA_GRILLEDIM' + IntToStr(k));
      CodeDim := TOBArt.GetValue('GA_CODEDIM' + IntToStr(k));
      if ((Grille <> '') and (CodeDim <> '')) then
        LibDim := LibDim + '  ' + RechDom('GCGRILLEDIM' + IntToStr(k), Grille, True) + ' ' + GCGetCodeDim(Grille, CodeDim, k);
    end;
  end;
  Result := LibDim;
end;

function TFFacture.InsereLigneGEN(CodeGen: string; ARow: integer; Qte: Double): TOB;
var TOBArt, TOBL: TOB;
  WhereNat, SelectFourniss: string;
  Q: TQuery;
  i: integer;
begin
  WhereNat := '';
  SelectFourniss := '';
  //Recherche Article dans TOBPiece par son Code Article + son statut
  TOBArt := TOBArticles.FindFirst(['GA_CODEARTICLE', 'GA_STATUTART'], [CodeGen, 'GEN'], False);
  if TOBArt = nil then
  begin
    if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
      (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then SelectFourniss := GP_TIERS.Text;
    WhereNat := FabricWhereNatArt(CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss);
    if WhereNat <> '' then WhereNat := ' AND ' + WhereNat;
    Q := OpenSQL('Select * from ARTICLE Where GA_CODEARTICLE="' + CodeGen + '" AND GA_STATUTART="GEN"' + WhereNat, True);
    try
      if not Q.EOF then
      begin
        TOBArt := CreerTOBArt(TOBArticles);
        TOBArt.SelectDB('', Q);
      end
      else MessageAlerte(HAveugle.Mess[4]);
    finally Ferme(Q);
    end;
  end;
  if TOBArt <> nil then
  begin
    CodesArtToCodesLigne(TOBArt, ARow);
    InitLaLigne(ARow, Qte);
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL <> nil then
    begin
      TOBL.PutValue('GL_ARTICLE', '');
      TOBL.PutValue('GL_VALIDECOM', 'AFF');
      TOBL.PutValue('GL_FOURNISSEUR', GP_TIERS.Text);
      TOBL.PutValue('GL_CODEARTICLE', '');
      TOBL.PutValue('GL_TYPEREF', '');
      TOBL.PutValue('GL_TYPELIGNE', 'COM');
      TOBL.PutValue('GL_TYPEARTICLE', '');
      TOBL.PutValue('GL_TENUESTOCK', '-');
      TOBL.PutValue('GL_REMISABLEPIED', '-');
      TOBL.PutValue('GL_TYPEDIM', 'GEN');
      TOBL.PutValue('GL_CODESDIM', CodeGen);
      TOBL.PutValue('GL_REFARTSAISIE', CodeGen);
      for i := 1 to 9 do TOBL.PutValue('GL_LIBREART' + IntToStr(i), '');
      TOBL.PutValue('GL_LIBREARTA', '');
      if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
      begin
        TOBL.PutValue('GL_MOTIFMVT', MOTIFMVT.Value);
        //TOBL.PutValue('GL_MOTIFMVT',AGLLanceFiche('GC','GCMOTIFMVT','','',TOBArt.GetValue('GA_LIBELLE')));
      end;
      if (CleDoc.NaturePiece = 'FCF') then TOBL.PutValue('GL_FOURNISSEUR', TOBArt.GetValue('GA_FOURNPRINC'));
    end;
  end
  else TOBL := nil;
  result := TOBL;
end;

function TFFacture.NbDimensionsLigneGEN(ARow: integer): integer;
var TOBL: TOB;
  Ligne, NbLignes: integer;
  CodeArticle: string;
  Continue: Boolean;
begin
  Result := 0;
  NbLignes := 0;
  Ligne := ARow;
  Continue := True;
  TOBL := GetTOBLigne(TOBPiece, Ligne);
  if TOBL = nil then exit;
  if TOBL.GetValue('GL_TYPEDIM') <> 'GEN' then exit;
  CodeArticle := TOBL.GetValue('GL_CODESDIM');
  while Continue do
  begin
    TOBL := GetTOBLigne(TOBPiece, Ligne + 1);
    if TOBL <> nil then
    begin
      if (TOBL.GetValue('GL_CODEARTICLE') = CodeArticle) and (TOBL.GetValue('GL_TYPEDIM') = 'DIM') then
      begin
        Ligne := Ligne + 1;
        NbLignes := NbLignes + 1;
      end
      else Continue := False;
    end
    else Continue := False;
  end;
  Result := NbLignes;
end;

function TFFacture.PositionneMotif(ARow: integer): boolean;
var ACol: integer;
begin
  result := false;
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
  begin
    if GS.Col = SG_RefArt then
    begin
      ACol := SG_Motif;
      GS.Col := ACol;
      GS.ShowCombo(ACol, ARow);
      Result := True;
    end;
  end;
end;

procedure TFFacture.InsertNewArtInGS(RefArt, Designation: string; Qte: Double);
var ACol, ARow, ARowGEN: Integer;
  Cancel, bc: Boolean;
  Etat, CodeGen, StMotif: string;
  TOBArt, TOBLGEN, TOBL: TOB;
begin
  Cancel := False;
  bc := False;
  ACol := SG_RefArt;
  TOBLGEN := nil;
  if (TOBPiece.Detail.Count = 1) and (GS.Cells[SG_RefArt, 1] = '') then ARow := 1
  else if (GS.Cells[SG_RefArt, TOBPiece.Detail.Count] = '') then ARow := TOBPiece.Detail.Count
  else ARow := TOBPiece.Detail.Count + 1;
  TOBArt := FindTOBArtSais(TOBArticles, RefArt);
  if (TOBArt <> nil) then
  begin
    CodeGen := TOBArt.GetValue('GA_CODEARTICLE');
    Etat := TOBArt.GetValue('GA_STATUTART');
    if Etat = 'UNI' then Etat := 'NOR';
    if (Etat = 'DIM') then
    begin
      //Recherche Article GEN, s'il existe : insertion de la dimension
      //                       sinon : création de la ligne GEN puis de la dimension
      TOBLGEN := TOBPiece.FindFirst(['GL_CODESDIM', 'GL_TYPEDIM'], [CodeGen, 'GEN'], False);
      if TOBLGEN = nil then
      begin
        if ARow = 1 then GSEnter(GS)
        else if ARow = TOBPiece.Detail.Count + 1 then
        begin
          GSRowEnter(GS, ARow, bc, False);
          GS.Col := ACol;
          GS.Row := ARow;
          GSCellEnter(GS, ACol, ARow, Cancel);
        end;
        GS.Cells[SG_RefArt, ARow] := CodeGen;
        TOBLGEN := InsereLigneGEN(CodeGen, ARow, 0);
        if TOBLGEN = nil then exit;
        if DimSaisie = 'DIM' then GS.RowHeights[ARow] := 0;
        ARow := ARow + 1;
      end
      else ARow := TOBLGEN.GetValue('GL_NUMLIGNE') + NbDimensionsLigneGEN(TOBLGEN.GetValue('GL_NUMLIGNE')) + 1;
    end
    else GS.Cells[SG_RefArt, ARow] := CodeGen;
    if ARow = 1 then GSEnter(GS)
    else if ARow = TOBPiece.Detail.Count + 1 then
    begin
      GSRowEnter(GS, ARow, bc, False);
      GS.Col := ACol;
      GS.Row := ARow;
      GSCellEnter(GS, ACol, ARow, Cancel);
    end
    else ClickInsert(ARow);
    GS.Col := ACol;
    GS.Row := ARow;
    CodesArtToCodesLigne(TOBArt, ARow);
    ChargeTOBDispo(ARow);
    InitLaLigne(ARow, Qte);
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL <> nil then
    begin
      TOBL.PutValue('GL_TYPEDIM', Etat);
      TOBL.PutValue('GL_LIBELLE', Designation);
      GS.Cells[SG_Lib, ARow] := Designation;
      TOBL.PutValue('GL_REFARTSAISIE', TOBL.GetValue('GL_CODEARTICLE'));
      TOBL.PutValue('GL_FOURNISSEUR', TOBArt.GetValue('GA_FOURNPRINC'));
    end;
    TraiteLesCons(ARow);
    TraiteLesNomens(ARow);
    TraiteLesMacros(ARow);
    TraiteLesLies(ARow);
    TraiteLaCompta(ARow);
    TraiteLeCata(ARow);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_RefArt, ARow, False);
    // motif mouvement
    if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then
    begin
      if (Etat = 'DIM') then
      begin
        if TOBLGEN <> nil then TOBL.PutValue('GL_MOTIFMVT', TOBLGEN.GetValue('GL_MOTIFMVT'));
      end
      else
      begin
        StMotif := AGLLanceFiche('GC', 'GCMOTIFMVT', '', '', TOBArt.GetValue('GA_LIBELLE'));
        TOBL.PutValue('GL_MOTIFMVT', StMotif);
        GS.CellValues[SG_Motif, ARow] := StMotif;
      end;
    end;
    if (Etat = 'DIM') then
    begin
      if DimSaisie = 'GEN' then GS.RowHeights[ARow] := 0;
      AfficheLaLigne(ARow);
      if TOBLGEN <> nil then ARowGEN := TOBLGEN.getvalue('GL_NUMLIGNE') else ARowGEN := 0;
      if ARowGEN <> 0 then
      begin
        TOBPiece.PutValue('GP_RECALCULER', 'X');
        CalculeLaSaisie(SG_RefArt, ARowGEN, False);
      end;
    end;
    StCellCur := GS.Cells[ACol, ARow];
  end;
end;

procedure TFFacture.GSAVersGS(RefArt, Designation: string; Qte: double);
var ARow: integer;
  TOBL, TOBLiee: TOB;
  NewQte, OldQte, ResteQte, QteInc: Double;
  Suivant, NewArt: boolean;
  Reponse: Word;
begin
  Suivant := True;
  ResteQte := Qte;
  ARow := -1;
  NewArt := False;
  Reponse := MrNo;
  TOBL := TOBPiece.FindFirst(['GL_ARTICLE'], [RefArt], False);
  if TOBL = nil then
  begin
    if NonPourTousNewArt then exit;
    if not (OuiPourTousNewArt) then
    begin
      Reponse := HShowMessage('1;' + TSaisieAveugle.Caption + ';' + TraduireMemoire('Voulez-vous ajouter cet article : "' + Designation +
        '" qui n''existe pas dans le document ?') + ';Q;YNTZ;N;N;', '', '');
      case Reponse of
        mrYesToAll: OuiPourTousNewArt := True;
        mrNoToAll: NonPourTousNewArt := True;
        mrNo: Exit;
      end;
    end;
    if OuiPourTousNewArt or (Reponse = mrYes) then
    begin
      GS.Setfocus;
      InsertNewArtInGS(RefArt, Designation, ResteQte);
      TOBL := nil;
    end;
  end;
  while (TOBL <> nil) and Suivant do
  begin
    ARow := TOBL.GetValue('GL_NUMLIGNE');
    NewQte := TOBL.GetValue('GL_QTESTOCK');
    TOBLiee := GetTOBPrec(TOBL, TOBPiece_O);
    if TOBLiee = nil then OldQte := 0 else OldQte := TOBLiee.GetValue('GL_QTESTOCK');
    if OldQte = 0 then
    begin
      NewArt := True;
      break;
    end;
    if NewQte >= OldQte then
    begin
      TOBL := TOBPiece.FindNext(['GL_ARTICLE'], [RefArt], True);
    end else
    begin
      QteInc := NewQte + ResteQte;
      ResteQte := QteInc - OldQte;
      if ResteQte <= 0 then
      begin
        if SG_QF <> -1 then GS.Cells[SG_QF, ARow] := FloatToStr(QteInc);
        if SG_QS <> -1 then GS.Cells[SG_QS, ARow] := FloatToStr(QteInc);
        Suivant := False;
      end else
      begin
        if SG_QF <> -1 then GS.Cells[SG_QF, ARow] := FloatToStr(OldQte);
        if SG_QS <> -1 then GS.Cells[SG_QS, ARow] := FloatToStr(OldQte);
        TOBL := TOBPiece.FindNext(['GL_ARTICLE'], [RefArt], True);
      end;
      // Insere la quantité dans le grid de saisie
      if SG_QF <> -1 then TraiteQte(SG_QF, ARow);
      if SG_QS <> -1 then TraiteQte(SG_QS, ARow);
    end;
  end;
  //or ((Qte<0) and (ResteQte<0)))
  if ((Qte > 0) and (ResteQte > 0)) and (ARow <> -1) then
  begin
    if not NewArt then
    begin
      if NonPourTousQteSup then exit;
      if not (OuiPourTousQteSup) then
      begin
        Reponse := HShowMessage('1;' + TSaisieAveugle.Caption + ';' + TraduireMemoire('La quantité de cet article : "' + Designation +
          '" est supérieure à celle du document, voulez-vous ajouter le supplément ?') + ';Q;YNTZ;N;N;', '', '');
        case Reponse of
          mrYesToAll: OuiPourTousQteSup := True;
          mrNoToAll: NonPourTousQteSup := True;
          mrNo: Exit;
        end;
      end;
    end;
    if (OuiPourTousQteSup) or (Reponse = mrYes) or (NewArt) then
    begin
      // Insere la quantité dans le grid de saisie
      GS.Setfocus;
      if SG_QF <> -1 then
      begin
        GS.Cells[SG_QF, ARow] := FloatToStr(Valeur(GS.Cells[SG_QF, ARow]) + ResteQte);
        TraiteQte(SG_QF, ARow);
      end;
      if SG_QS <> -1 then
      begin
        GS.Cells[SG_QS, ARow] := FloatToStr(Valeur(GS.Cells[SG_QS, ARow]) + ResteQte);
        TraiteQte(SG_QS, ARow);
      end;
    end;
  end;
  TOBPiece.putValue('GP_RECALCULER', 'X');
  if SG_QF <> -1 then CalculeLaSaisie(SG_QF, 1, False)
  else if SG_QS <> -1 then CalculeLaSaisie(SG_QS, 1, False)
end;

procedure TFFacture.AffecteQuantiteZeroInGS(ReaffecteQte: Boolean = False);
var ARow: integer;
  ColQuantite: integer;
begin
  SourisSablier;
  try
    GS.SynEnabled := False;
    ColQuantite := -1;
    if SG_QF <> -1 then ColQuantite := SG_QF else if SG_QS <> -1 then ColQuantite := SG_QS;
    if ColQuantite = -1 then Exit;
    for ARow := 1 to TOBPiece.Detail.Count do
      AffecteUneLigneInGS(ColQuantite, ARow, ReaffecteQte);
    TOBPiece.putValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(ColQuantite, 1, False);
    BAffecteTous := not BAffecteTous;
  finally
    GS.SynEnabled := True;
    SourisNormale;
  end;
end;

procedure TFFacture.AffecteUneLigneInGS(ACol, ARow: integer; ReaffecteQte: Boolean);
var TOBL, TOBLiee: TOB;
  TypeLigne: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then exit;
  TypeLigne := TOBL.GetValue('GL_TYPELIGNE');
  if not ((TypeLigne = 'COM') or (TypeLigne = 'TOT')) then
  begin
    if ReaffecteQte then
    begin
      TOBLiee := GetTOBPrec(TOBL, TOBPiece_O);
      if TOBLiee = nil then exit;
      if SG_QF <> -1 then GS.Cells[SG_QF, ARow] := TOBLiee.GetValue('GL_QTERESTE') { NEWPIECE }
      else if SG_QS <> -1 then GS.Cells[SG_QS, ARow] := TOBLiee.GetValue('GL_QTERESTE'); { NEWPIECE }
    end
    else GS.Cells[ACol, ARow] := '0';
    TraiteQte(ACol, ARow);
  end;
end;

procedure TFFacture.MAJLigneDim(ARow: Integer);
var i, ColQuantite: Integer;
  TOBL: TOB;
begin
  i := ARow;
  ColQuantite := -1;
  if SG_QF <> -1 then ColQuantite := SG_QF else if SG_QS <> -1 then ColQuantite := SG_QS;
  if ColQuantite = -1 then Exit;
  TOBL := TOBPiece.Detail[i - 1];
  if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
  begin
    Inc(i);
    TOBL := TOBPiece.Detail[i - 1];
  end;
  while TOBL.GetValue('GL_TYPEDIM') = 'DIM' do
  begin
    GS.Cells[ColQuantite, i] := '0';
    TraiteQte(ColQuantite, i);
    inc(i);
    if i > TOBPiece.Detail.Count then Break;
    TOBL := TOBPiece.Detail[i - 1];
  end;
  TOBPiece.putValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, False);
end;

procedure TFFacture.ReconstruireTobDim(ARow: Integer);
var i, j: Integer;
  TOBL, TOBD: TOB;
  CodeArticle: string;
  QteDejaSaisi, ReliqDejaSaisi: Double;
begin
  i := Arow;
  TOBL := TOBPiece.Detail[i - 1];
  if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
  begin
    CodeArticle := TOBL.GetValue('GL_CODESDIM');
    i := i + 1;
    TOBL := TOBPiece.Detail[i - 1];
  end;
  while TOBL.GetValue('GL_CODEARTICLE') = CodeArticle do
  begin
    for j := 0 to TOBDim.Detail.count - 1 do
    begin
      if TOBL.GetValue('GL_ARTICLE') = TOBDim.Detail[j].GetValue('GA_ARTICLE') then break else
      begin
        if (TOBL.GetValue('GL_ARTICLE') < TOBDim.Detail[j].GetValue('GA_ARTICLE')) or (j = TOBDim.Detail.count - 1) then
        begin
          if j = TOBDim.Detail.count - 1 then TOBD := TOB.Create('', TOBDim, TOBDim.Detail.count)
          else TOBD := TOB.Create('', TOBDim, j);
          TOBD.Dupliquer(TOBDim.Detail[TOBDim.Detail.Count - 1], false, false);
          QteDejaSaisi := CalcQteDejaSaisie(TOBPiece, TOBL.GetValue('GL_ARTICLE'));
          ReliqDejaSaisi := CalcQteDejaSaisie(TOBPiece_O, TOBL.GetValue('GL_ARTICLE'));

          if not TOBD.FieldExists('GA_ARTICLE') then TOBD.AddChampSup('GA_ARTICLE', False);
          if not TOBD.FieldExists('GL_QTEFACT') then TOBD.AddChampSup('GL_QTEFACT', False);
          if not TOBD.FieldExists('GL_PUHTDEV') then TOBD.AddChampSup('GL_PUHTDEV', False);
          if not TOBD.FieldExists('GL_PUTTCDEV') then TOBD.AddChampSup('GL_PUTTCDEV', False);
          if not TOBD.FieldExists('GL_REMISELIGNE') then TOBD.AddChampSup('GL_REMISELIGNE', False);
          if not TOBD.FieldExists('GL_CODEARRONDI') then TOBD.AddChampSup('GL_CODEARRONDI', False);
          if not TOBD.FieldExists('_QteDejaSaisi') then TOBD.AddChampSup('_QteDejaSaisi', False);
          if not TOBD.FieldExists('_ReliqDejaSaisi') then TOBD.AddChampSup('_ReliqDejaSaisi', False);

          TOBD.PutValue('GA_ARTICLE', TOBL.GetValue('GL_ARTICLE'));
          TOBD.PutValue('GL_QTEFACT', 0);
          TOBD.PutValue('GL_PUHTDEV', TOBL.GetValue('GL_PUHTDEV'));
          TOBD.PutValue('GL_PUTTCDEV', TOBL.GetValue('GL_PUTTCDEV'));
          TOBD.PutValue('GL_REMISELIGNE', TOBL.GetValue('GL_REMISELIGNE'));
          TOBD.PutValue('GL_CODEARRONDI', TOBL.GetValue('GL_CODEARRONDI'));
          TOBD.PutValue('_QteDejaSaisi', QteDejaSaisi);
          TOBD.PutValue('_ReliqDejaSaisi', ReliqDejaSaisi);
          break;
        end;
      end;
    end;
    Inc(i);
    if i > TOBPiece.Detail.Count then break;
    TOBL := TOBPiece.Detail[i - 1];
  end;
end;

procedure InitFacGescom();
begin
  RegisterAglProc('AppelPiece', False, 2, AppelPiece);
  RegisterAglProc('AppelTransformePiece', False, 3, AppelTransformePiece); //Saisie Aveugle
  RegisterAglProc('AppelDupliquePiece', False, 2, AppelDupliquePiece);
  RegisterAglProc('CreerPiece', False, 1, AGLCreerPiece);
end;

procedure TFFacture.BAideClick(Sender: TObject);
begin
  CallHelpTopic(Self);
end;

procedure TFFacture.LibrepieceClick(Sender: TObject);
begin
  SaisieTablesLibres(TOBPiece, True);
end;

procedure TFFacture.PositionFicheSaisieCodeBarre;
var CoordonneCellule: TRect;
  PointEcran: TPoint;
begin
  CoordonneCellule := GS.CellRect(0, 0);
  PointEcran := GS.ClientToScreen(CoordonneCellule.TopLeft);
  TSaisieAveugle.Top := PointEcran.y;
  TSaisieAveugle.Left := PointEcran.x;
  TSaisieAveugle.Width := GS.Width;
  TSaisieAveugle.Height := GS.Height;
end;

procedure TFFacture.BSaisieAveugleClick(Sender: TObject);
var BVisible, Cancel: Boolean;
  ACol, ARow: integer;
begin
  BVisible := not TSaisieAveugle.Visible;
  if BVisible then
  begin
    PositionFicheSaisieCodeBarre;
    if GS.ValCombo <> nil then
    begin
      GS.ValCombo.Perform(CM_EXIT, 0, 0);
      GS.ValCombo.Visible := FALSE;
    end;
    ACol := GS.Col;
    ARow := GS.Row;
    Cancel := False;
    GSCellExit(sender, ACol, ARow, Cancel);
    if Cancel then exit;
    GSRowExit(Sender, ARow, Cancel, False);
    if Cancel then exit;
  end;
  BSaisieAveugle.Down := BVisible;
  if BVisible then
  begin
    DepileTOBLignes(GS, TOBPiece, GS.Row, 1);
    if TOBPiece.Detail.Count = 0 then GS.Row := 1 else GS.Row := TOBPiece.Detail.Count;
    GS.Col := SG_RefArt;
    TOBGSA.PutGridDetail(GSAveugle, False, False, StColNameGSA, True);
    SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
    GSAveugle.Row := 1;
    GSAveugle.Col := Col_CB;
    HMTrad.ResizeGridColumns(GSAveugle);
    GSAveugleRowEnter(Sender, 1, Cancel, False);
    PPied.Enabled := False;
    PEntete.Enabled := False;
    TSaisieAveugle.Show;
    TSaisieAveugle.SetFocus;
    BValider.Enabled := False;
    GSAveugle.SetFocus;
  end
  else
  begin
    TSaisieAveugle.Hide;
    TSaisieAveugleClose(Sender);
  end;
end;

// DEBUT AJOUT CHR
{$IFDEF CHR}
{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 13/01/2002
Modifié le ... :   /  /
Description .. : Fonction pour recuperer les infos du dossier à la creation de la piece
Mots clefs ... : MajCHR
*****************************************************************}

procedure TFFacture.MajCHR;
begin
  IncidenceChr;
  if (TobHrdossier.Fieldexists('HDR_DOSRES')) then
    GP_TIERS.Text := TobHrdossier.GetValue('HDR_TIERS');
end;

{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 13/01/2002
Modifié le ... :   /  /
Description .. : Fonction d'initialisation propre à l'hotellerie / restauration
Mots clefs ... : IncidenceChr
*****************************************************************}

procedure TFFacture.IncidenceChr;
var CodeTiers, LibTiers: string;
begin
  if Action <> taCreat then Exit;
  if (VenteAchat <> 'VEN') then exit;
  if (VenteAchat = 'VEN') then // maj du tiers uniquement en vente
  begin
    RemplirTOBHrdossier(GP_HRDOSSIER.Text, TobHrdossier);
    GP_TIERS.Text := TobHrdossier.GetValue('HDR_TIERS');
    if ((GP_TIERS.Text = '') or (GP_TIERS.Text <> TOBTiers.GetValue('T_TIERS'))) then
    begin
      CodeTiers := TobHrdossier.GetValue('HDR_TIERS');
      LibTiers := RechDom('GCTIERSSAISIE', CodeTiers, False);
      if ((LibTiers = '') or (LibTiers = 'Error')) then
      begin
        GP_AFFAIRE.Text := '';
        HPiece.Execute(4, Caption, '');
      end else
      begin
        GP_TIERS.Text := CodeTiers;
        ChargeTiers;
        CliCur := GP_TIERS.Text;
      end;
    end;
  end;
  GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
  TOBPiece.GetEcran(Self);
end;

{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 21/01/2002
Modifié le ... : 25/02/2002
Description .. : Chargement des Tob CHR
Mots clefs ... : LOADLESTOBCHR
*****************************************************************}

procedure TFFacture.LoadlesTobChr;
var indice: integer;
  regrpe: string;
  TobResultat: Tob;
  QGrp: TQuery;
begin
  inherited;
  Tobregrpe := TOB.Create('REGRPE', nil, -1);

  Qgrp := OpenSQL('Select HGP_ABREGE,HGP_REGROUPELIGNE from HRREGROUPELIGNE', true);

  if not Qgrp.EOF then
  begin
    Tobregrpe.LoadDetailDB('REGRPE', '', '', Qgrp, False, True);
  end;
  if Qgrp <> nil then Ferme(Qgrp);

  for indice := 0 to TOBPiece.detail.count - 1 do
  begin
    Tobpiece.detail[indice].addchampSup('(REGROUPEMENT)', true);
    regrpe := TOBPiece.detail[indice].getvalue('GL_REGROUPELIGNE');
    if regrpe <> '' then
    begin
      TobResultat := TobRegrpe.findFirst(['HGP_REGROUPELIGNE'], [regrpe], True);
      if TobResultat <> nil then
      begin
        TOBPiece.detail[indice].AddChampSupValeur('(REGROUPEMENT)', TobResultat.GetValue('HGP_ABREGE'));
      end;
    end;
  end;

end;
{$ENDIF}
// FIN AJOUT CHR

procedure TFFacture.BZoomDispoClick(Sender: TObject);
var RefUnique, RefFour, Client, Four, Depot: string;
  Contrem: boolean;
begin
  if not BZoomDispo.Enabled then Exit;
  RefUnique := GetCodeArtUnique(TOBPiece, GS.Row);
  if VenteAchat = 'ACH' then
  begin
    Four := TOBPiece.GetValue('GP_TIERS');
    Client := GetChampLigne(TOBPiece, 'GL_FOURNISSEUR', GS.Row);
  end else
  begin
    Client := TOBPiece.GetValue('GP_TIERS');
    Four := GetChampLigne(TOBPiece, 'GL_FOURNISSEUR', GS.Row);
  end;
  RefFour := GetChampLigne(TOBPiece, 'GL_REFCATALOGUE', GS.Row);
  Depot := GetChampLigne(TOBPiece, 'GL_DEPOT', GS.Row);
  Contrem := (GetChampLigne(TOBPiece, 'GL_ENCONTREMARQUE', GS.Row) = 'X');
  ZoomDispo(RefUnique, RefFour, Client, Four, Depot, Contrem);
end;

procedure TFFacture.BNouvelArticleClick(Sender: TOBject);
begin
  if (ctxMode in V_PGI.PgiContexte) and (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then
    AGLLanceFiche('MBO', 'ARTICLE', '', '', 'ACTION=CREATION;FOURNDOCACH=' + GP_TIERS.Text + '')
  else
    AGLLanceFiche('MBO', 'ARTICLE', '', '', 'ACTION=CREATION');
end;

procedure TFFacture.BInfosClick(Sender: TObject);
var i: integer;
  MnContol: TMenuItem;
begin
  if not ((CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX')) then exit;
  for i := 0 to POPY.Items.Count - 1 do
  begin
    MnContol := POPY.Items[i];
    if pos(MnContol.Name, 'CpltEntete;Librepiece;CpltLigne') = 0 then
      MnContol.Visible := False;
  end;
end;

procedure TFFacture.ModifiableLeMemeJour;
begin
  if CleDoc.NaturePiece <> 'ALF' then Exit;
  if (Action = taModif) and (not TransfoPiece) and (not DuplicPiece) and (Date >= CleDoc.DatePiece + 1) then
  begin
    Action := taConsult;
    PGIInfo('Cette pièce n''est plus modifiable car la date de la pièce est inférieure à la date du jour.', Caption);
  end;
end;

procedure TFFacture.SGEDPieceClick(Sender: TObject);
var ClePiece, Param: string;
begin
  {$IFNDEF EAGLCLIENT}
  ClePiece := CleDoc.NaturePiece + CleDoc.Souche + IntToStr(CleDoc.NumeroPiece) + IntToStr(CleDoc.indice);
  Param := CleDoc.NaturePiece + ';' + CleDoc.Souche + ';' + IntToStr(CleDoc.NumeroPiece) + ';' + IntToStr(CleDoc.indice);
  AglIsoflexViewDoc(NomHalley, 'FACTURE', 'PIECE', 'GP_CLE1', 'GP_NATUREPIECEG, GP_SOUCHE, GP_NUMERO, GP_INDICEG', ClePiece, Param);
  {$ENDIF}
end;

procedure TFFacture.ChangeTVA;
var NewCode: string;
  i, NbSel: integer;
  Okok: Boolean;
  TOBL: TOB;
begin
  if Action = taConsult then Exit;
  if not GP_FACTUREHT.Checked then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  NewCode := Choisir(HTitres.Mess[28], 'CHOIXCOD', 'CC_LIBELLE', 'CC_CODE', 'CC_TYPE="TX1"', 'CC_CODE');
  if NewCode = '' then Exit;
  if HPiece.Execute(38, Caption, '') <> mrYes then Exit;
  NbSel := GS.NbSelected;
  Okok := False;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    if ((NbSel = 0) or (GS.IsSelected(i + 1))) then
    begin
      TOBL := TOBPiece.Detail[i];
      if TOBL.GetValue('GL_ARTICLE') = '' then Continue;
      if TOBL.GetValue('GL_FAMILLETAXE1') <> NewCode then
      begin
        TOBL.PutValue('GL_FAMILLETAXE1', NewCode);
        TOBL.putValue('GL_RECALCULER', 'X');
        Okok := True;
      end;
    end;
  end;
  if Okok then
  begin
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X'); // positionne le recalcul du document
    CalculeLaSaisie(-1, -1, True);
  end;
end;

procedure TFFacture.ChangeRegime;
var NewCode: string;
begin
  if Action = taConsult then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  NewCode := Choisir(HTitres.Mess[28], 'CHOIXCOD', 'CC_LIBELLE', 'CC_CODE', 'CC_TYPE="RTV"', 'CC_CODE');
  if NewCode = '' then Exit;
  if HPiece.Execute(39, Caption, '') <> mrYes then Exit;
  GP_REGIMETAXE.Value := NewCode;
  // Modif BTP
  PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
  // --
  CalculeLaSaisie(-1, -1, True);
end;

procedure TFFacture.GP_REPRESENTANTEnter(Sender: TObject);
begin
  OldRepresentant := GP_REPRESENTANT.Text;
end;

procedure TFFacture.BZoomStockClick(Sender: TObject);
begin
  ZoomEcriture(True);
end;

procedure TFFacture.MBAnalDocClick(Sender: TObject);
begin
  // Analyse du document complet
  {$IFDEF BTP}
  EntreeAnalyseDocument(SrcDoc, TOBPiece, TOBOUvrage, ['LIBELLE=' + FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption], 1);
  {$ENDIF}
end;

procedure TFFacture.MBAnalLocClick(Sender: TObject);
{$IFDEF BTP}
var
  Indice: Integer;
  TOBLOc: TOB;
  Parametre, Libelle: string;
  TypeAnal: TsrcAnal;
  {$ENDIF}
begin
  {$IFDEF BTP}
  //
  Indice := GS.Row - 1;
  TOBLoc := TOBPIece.Detail[Indice];
  if copy(TOBLOC.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
  begin
    Parametre := 'DEBUT=' + intTostr(Indice);
    TypeAnal := SrcPar;
    Libelle := FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption + ' Paragraphe : ' + TOBLOC.GetValue('GL_LIBELLE');
  end
  else if Copy(TOBLOC.GetValue('GL_TYPELIGNE'), 1, 2) = 'TP' then
  begin
    Parametre := 'FIN=' + intTostr(Indice);
    TypeAnal := SrcPar;
    Libelle := FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption + ' Paragraphe : ' + TOBLOC.GetValue('GL_LIBELLE');
  end
  else
  begin
    Parametre := 'CURLIG=' + intToStr(Indice);
    TypeAnal := SrcOuv;
    if TOBLOC.GetValue('GL_TYPEARTICLE') = 'ART' then
      Libelle := FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption + ' Article : ' + TOBLOC.GetValue('GL_LIBELLE')
    else if (TOBLOC.GetValue('GL_TYPEARTICLE') = 'NOM') or (TOBLOC.GetValue('GL_TYPEARTICLE') = 'OUV') then
      Libelle := FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption + ' Ouvrage : ' + TOBLOC.GetValue('GL_LIBELLE');
  end;
  EntreeAnalyseDocument(TypeAnal, TOBPiece, TobOuvrage, ['LIBELLE=' + Libelle, Parametre], 2);
  {$ENDIF}
end;

procedure TFFacture.SuppressionDetailOuvrage(Arow: integer; AvecGestionAffichage: boolean = true);
var Indice, IndRech, IndiceNomen, ITypeLig: Integer;
  TOBL, TOBDet: TOB;
  bc: boolean;
begin
  TOBL := GetTOBLigne(TOBPiece, Arow);
  IndiceNomen := TOBL.GetNumChamp('GL_INDICENOMEN');
  ITypeLig := TOBL.GetNumchamp('GL_TYPELIGNE');
  IndRech := TOBL.GetValeur(IndiceNomen);
  Indice := 1;
  repeat
    TOBDet := GetTOBLigne(TOBPiece, Indice);
    if TOBDet = nil then break;
    if (TOBDet.getvaleur(IndiceNomen) = Indrech) and (TOBDet.getvaleur(ITypeLig) = 'COM') then
    begin
      TOBDet.free;
    end else Inc(Indice);
  until Indice > GS.RowCount;
  if AvecGestionAffichage then
  begin
    GS.videpile(false);
    GS.rowcount := TOBPiece.detail.count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
    GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    numerotelignesGc(nil, TOBPiece);
    for Indice := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(Indice + 1);
    GSRowEnter(GS, ARow, bc, False);
    GS.row := Arow;
  end;
end;

procedure TFFacture.AffichageDetailOuvrage(RowReference: Integer);
var Insligne, Indice, IndiceNomen, TypePresent: Integer;
  TOBL, TOBOuv, TOBLOC, TOBRef: TOB;
  Montant, QteDuDetail, QteDUPv, MontantOuv, MontantLig: double;
  EnHt: boolean;
  Ouvrage: boolean;
  CumMont: double;
  RowRef: integer;
  ArticleOk: string;
  IndicePou: Integer;
begin
  if SaisieTypeAvanc then exit;
  IndicePou := -1;
  EnHT := (TOBPiece.GetValue('GP_FACTUREHT') = 'X');
  TOBRef := GetTOBLigne(TOBPiece, RowReference);
  TypePresent := TOBRef.GetValue('GL_TYPEPRESENT');
  if TypePresent = DOU_AUCUN then Exit;
  CumMont := 0;
  IndiceNomen := TOBRef.Getvalue('GL_INDICENOMEN');
  if IndiceNomen = 0 then exit;
  if EnHt then MontantOuv := TOBRef.GetValue('GL_MONTANTHTDEV')
  else MontantOuv := TOBRef.GetValue('GL_MONTANTTTCDEV');
  MontantLig := 0;
  InsLigne := RowReference + 1;
  RowRef := InsLigne;
  if copy(TOBRef.getvalue('GL_TYPENOMENC'), 1, 2) = 'OU' then
  begin
    TOBOUv := TOBOuvrage.Detail[IndiceNomen - 1];
    ouvrage := true;
  end else
  begin
    TOBOUv := TOBnomenclature.Detail[IndiceNomen - 1];
    ouvrage := false;
  end;
  if TOBOUv <> nil then
  begin
    TOBLoc := TOBOuv.FindFirst(['BLO_TYPEARTICLE'], ['POU'], false);
    if TOBLOC <> nil then ArticleOk := TOBLoc.GetValue('BLO_LIBCOMPL');

    for Indice := 0 to TOBOUv.detail.count - 1 do
    begin
      TOBLoc := TOBOUV.detail[Indice];
      if Ouvrage then
      begin
        QteDudetail := TOBLoc.GetValue('BLO_QTEDUDETAIL');
        if QteDUdetail = 0 then qteduDetail := 1;
        QteDuPv := TOBLoc.GetValue('BLO_PRIXPOURQTE');
        if QteDUpv = 0 then qtedupv := 1;
      end else
      begin
        qteduDetail := 1;
        qtedupv := 1;
      end;
      if InsLigne > TOBPiece.detail.count then
      begin
        if (tModeBlocNotes in SaContexte) then
        begin
          if Insligne >= GS.RowCount - 1 then
          begin
            GS.RowCount := GS.RowCount + 1;
          end;
        end else
        begin
          if Insligne >= GS.RowCount - 1 then GS.RowCount := GS.RowCount + NbRowsPlus;
        end;
        CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, InsLigne, false)
      end else
      begin
        InsertTOBLigne(TOBPiece, InsLigne);
        InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, InsLigne, false);
      end;
      TOBL := GetTOBLigne(TOBPiece, Insligne);
      TOBL.PutValue('GL_TYPELIGNE', 'COM');
      TOBL.PutValue('GL_INDICENOMEN', IndiceNomen);
      if TOBLoc.GetValue('BLO_TYPEARTICLE') = 'POU' then IndicePou := InsLigne;
      if Ouvrage then
      begin
        if TOBLoc.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
          if Enht then
            Montant := arrondi(TOBLoc.GetValue('BLO_PUHTDEV') * (TOBRef.getValue('GL_QTEFACT')) * (TOBLoc.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)),
            DEV.Decimale)
          else
            Montant := arrondi(TOBLoc.GetValue('BLO_PUTTCDEV') * (TOBRef.getValue('GL_QTEFACT')) * (TOBLoc.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)),
            DEV.Decimale);
          MontantLig := MontantLig + Montant;
          if ArticleOKInPOUR(TOBLOC.GetValue('BLO_TYPEARTICLE'), ArticleOk) then CumMont := CumMont + Montant;
        end;
      end;
      if (TypePresent and DOU_CODE) = DOU_CODE then
      begin
        if ouvrage then TOBL.PutValue('GL_REFARTSAISIE', TOBLoc.GetValue('BLO_CODEARTICLE'))
        else TOBL.PutValue('GL_REFARTSAISIE', TOBLoc.GetValue('GLN_CODEARTICLE'))
      end;
      if ouvrage then TOBL.PutValue('GL_REFARTTIERS', TOBLoc.GetValue('BLO_ARTICLE'))
      else TOBL.PutValue('GL_REFARTTIERS', TOBLoc.GetValue('GLN_ARTICLE'));
      if (TypePresent and DOU_LIBELLE) = DOU_LIBELLE then
      begin
        if ouvrage then TOBL.PutValue('GL_LIBELLE', TOBLoc.GetValue('BLO_LIBELLE'))
        else TOBL.PutValue('GL_LIBELLE', TOBLoc.GetValue('GLN_LIBELLE'));
      end;
      if (typepresent and DOU_QTE) = DOU_QTE then
      begin
        if ouvrage then
        begin
          if TOBLoc.GetValue('BLO_TYPEARTICLE') = 'POU' then TOBL.PutValue('GL_QTEFACT', TOBLoc.GetValue('BLO_QTEFACT') / QteDuDetail)
          else TOBL.PutValue('GL_QTEFACT', (TOBLoc.GetValue('BLO_QTEFACT') * TOBRef.GetValue('GL_QTEFACT')) / QteDuDetail);
        end
        else TOBL.PutValue('GL_QTEFACT', TOBLoc.GetValue('GLN_QTEFACT'));
      end;
      if (typepresent and DOU_UNITE) = DOU_UNITE then
      begin
        if ouvrage then TOBL.PutValue('GL_QUALIFQTEVTE', TOBLoc.GetValue('BLO_QUALIFQTEVTE'))
        else TOBL.PutValue('GL_QUALIFQTEVTE', TOBLoc.GetValue('GLN_QUALIFQTEVTE'));
      end;
      if ((typepresent and DOU_PU) = DOU_PU) and (ouvrage) then
      begin
        if TOBLOC.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
          if EnHt then TOBL.PutValue('GL_PUHTDEV', TOBLoc.GetValue('BLO_PUHTDEV') / QteDupv)
          else TOBL.PutValue('GL_PUTTCDEV', TOBLoc.GetValue('BLO_PUTTCDEV') / QteDupv);
        end;
      end;
      if ((typepresent and DOU_MONTANT) = DOU_MONTANT) and (ouvrage) then
      begin
        if TOBLOC.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
          if EnHt then TOBL.PUtValue('GL_MONTANTHTDEV', Montant)
          else TOBL.PUtValue('GL_MONTANTTTCDEV', Montant);
        end;
      end;
      InsLigne := Insligne + 1; // Pour les avoir dans l'ordre
    end;
    if IndicePou <> -1 then
    begin
      TOBLoc := TOBOuv.FindFirst(['BLO_TYPEARTICLE'], ['POU'], false);
      TOBL := GetTOBLigne(TOBPiece, IndicePOu);
      Montant := arrondi(CumMont * (TOBLoc.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)), DEV.Decimale);
      MontantLig := MontantLig + Montant;
      if ((typepresent and DOU_PU) = DOU_PU) and (ouvrage) then
      begin
        if EnHt then TOBL.PutValue('GL_PUHTDEV', CumMont)
        else TOBL.PutValue('GL_PUTTCDEV', CumMont);
      end;
      if ((typepresent and DOU_MONTANT) = DOU_MONTANT) and (ouvrage) then
      begin
        if EnHt then TOBL.PUtValue('GL_MONTANTHTDEV', Montant)
        else TOBL.PUtValue('GL_MONTANTTTCDEV', Montant);
      end;
    end;
    // Réajustement total des lignes / Montant Ouvrage
    if (RowRef <> -1) and (MontantLig <> MontantOuv) and ((typepresent and DOU_MONTANT) = DOU_MONTANT) then
    begin
      TOBL := GetTOBLigne(TOBPiece, RowRef);
      if EnHt then TOBL.PutValue('GL_MONTANTHTDEV', TOBL.GetValue('GL_MONTANTHTDEV') + (MontantOuv - MontantLig))
      else TOBL.PutValue('GL_MONTANTTTCDEV', TOBL.GetValue('GL_MONTANTTTCDEV') + (MontantOuv - MontantLig))
    end;
    GS.videpile(false);
    GS.rowcount := TOBPiece.detail.count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
    GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    numerotelignesGc(nil, TOBPiece);
    for Indice := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(Indice + 1);
  end;
  GS.Row := RowReference;
end;

procedure TFFacture.MBModeVisuClick(Sender: TObject);
var Presentation: Integer;
  TOBL: TOB;
  RowReference: integer;
begin
  if Action = taConsult then Exit;
  RowReference := GS.row;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  Presentation := TOBL.Getvalue('GL_TYPEPRESENT');
  ParamDetailOuvrage(Presentation);
  TOBL.Putvalue('GL_TYPEPRESENT', presentation);
  //
  GS.SynEnabled := false;
  SuppressionDetailOuvrage(Rowreference);
  AffichageDetailOuvrage(Rowreference);
  GS.SynEnabled := True;
  //
end;

procedure TFFacTure.SupLesLibDetail(TOBPiece: TOB);
var Indice: Integer;
  TOBL: TOB;
begin
  Indice := 0;
  if TOBPiece.detail.count = 0 then exit; // mcd 16/04/02 cas mission sans lignes ...
  repeat
    TOBL := TOBPiece.detail[indice];
    if TOBL = nil then break;
    if (IsLigneDetail(nil, TOBL)) then TOBL.Free
    else Inc(Indice);
  until Indice > TOBPiece.detail.count - 1;
  NumeroteLignesGC(nil, TOBPIece);
end;

procedure TFFacTure.AddLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
var debut, Niveau, Indice: integer;
  TOBL: TOB;
begin
  TOBL := TOBPiece.detail[Indref];
  if TOBL <> nil then
  begin
    Niveau := TOBL.getvalue('GL_NIVEAUIMBRIC');
    Debut := RecupDebutParagraph(TOBPIece, Indref, niveau);
    Indice := Debut;
    TOBL := TOBPiece.detail[indice];
    if TOBL = nil then exit;
    repeat
      if TOBL.GetValue('GL_TYPEARTICLE') = 'OUV' then
        {$IFDEF BTP}
        LoadLesLibDetOuvLig(TOBPIECE, TOBOuvrage, TOBTiers, TOBAffaire, TOBL, Indice, DEV)
          {$ENDIF}
      else if (TOBL.GetValue('GL_TYPENOMENC') = 'ASS') then
        LoadLesLibDetailNomLig(TOBPIECE, TOBNomenclature, TOBTiers, TOBAffaire, TOBL, Indice, DEV)
      else inc(Indice);

      TOBL := TOBPiece.detail[indice];
      if TOBL = nil then break;
    until TOBL.GetValue('GL_TYPELIGNE') = 'TP' + inttostr(niveau);
  end;
end;

procedure TFFacTure.SupLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
var Debut, Niveau, Indice: integer;
  TOBL: TOB;
begin
  TOBL := TOBPiece.detail[Indref];
  if TOBL <> nil then
  begin
    Niveau := TOBL.getvalue('GL_NIVEAUIMBRIC');
    Debut := RecupDebutParagraph(TOBPIece, Indref, niveau);
    Indice := Debut;
    TOBL := TOBPiece.detail[indice];
    if TOBL = nil then exit;
    repeat
      if (IsLigneDetail(nil, TOBL)) then TOBL.Free
      else Inc(Indice);
      TOBL := TOBPiece.detail[indice];
      if TOBL = nil then break;
    until TOBL.GetValue('GL_TYPELIGNE') = 'TP' + inttostr(niveau);
  end;
end;

{$IFDEF BTP}

procedure TFFacTure.AppliqueChangeTaxe(IndLigne: Integer);
var TOBL: TOB;
  CodeTaxe, LocTaxe: string;
  Niveau: Integer;
  Indice, IndDep, IndFin: integer;
begin
  if IndLigne > 0 then
  begin
    CodeTaxe := '';
    IndDep := Indligne - 1;
    IndFin := IndLigne - 1;
  end else
  begin
    CodeTaxe := TOBPiece.GetValue('FAMILLETAXE1');
    IndDep := 0;
    IndFin := TOBPiece.detail.count - 1;
  end;
  for Indice := Inddep to IndFin do
  begin
    TOBL := TOBPiece.detail[Indice];
    if TOBL = nil then exit; // pour l'instant
    if CodeTaxe <> '' then LocTaxe := CodeTaxe
    else LocTaxe := TOBL.GetValue('GL_FAMILLETAXE1');
    if (copy(TOBL.Getvalue('GL_TYPELIGNE'), 1, 2) = 'DP') then
    begin
      Niveau := TOBL.getValue('GL_NIVEAUIMBRIC');
      TOBL.PutValue('GL_RECALCULER', 'X');
      AppliqueChangeTaxePara(TOBPIece, TOBOuvrage, Indice + 1, LocTaxe, Niveau);
    end
    else if TOBL.Getvalue('GL_TYPEARTICLE') = 'OUV' then
    begin
      TOBL.PutValue('GL_FAMILLETAXE1', LocTaxe); (* a revoir *)
      TOBL.PutValue('GL_RECALCULER', 'X');
      AppliqueChangeTaxeOuv(TOBPiece, TOBOuvrage, Indice + 1, locTaxe);
    end
    else if (TOBL.GetValue('GL_TYPEARTICLE') <> 'COM') and
      (copy(TOBL.GetValue('GL_TYPEARTICLE'), 1, 2) <> 'TP') then
    begin
      TOBL.PutValue('GL_RECALCULER', 'X');
      TOBL.Putvalue('GL_FAMILLETAXE1', LocTaxe)
    end;
  end;
  TOBPIECE.PutValue('GP_RECALCULER', 'X');
end;
{$ENDIF}

// MOdif BTP

procedure TFFacture.DebutEnter(Sender: TObject);
begin
  SBPosition := SB.VertScrollBar.position;
  timer1.Enabled := TRUE;
end;

procedure TFFacture.DebutResizeRequest(Sender: TObject; Rect: TRect);
begin
  Debut.Height := Rect.Bottom - Rect.Top;
end;

procedure TFFacture.DebutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Hauteur: Integer;
  Rect: TRect;
begin
  Rect := Debut.ClientRect;
  Hauteur := Rect.Bottom - Rect.Top;
  if Hauteur >= SB.height then
  begin
    SB.VertScrollBar.position := Debut.CurrentLine * Abs(Debut.Font.Height);
  end
  else
  begin
    SB.VertScrollBar.position := 0;
  end;
  SBPosition := SB.VertScrollBar.position;
end;

procedure TFFacture.FinEnter(Sender: TObject);
begin
  SBPosition := SB.VertScrollBar.position;
  timer1.Enabled := TRUE;
end;

procedure TFFacture.FinResizeRequest(Sender: TObject; Rect: TRect);
begin
  Fin.Height := Rect.Bottom - Rect.Top;
end;

procedure TFFacture.FinKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Hauteur: Integer;
  Rect: TRect;
begin
  Rect := Fin.ClientRect;
  Hauteur := Rect.Bottom - Rect.Top;
  if Hauteur > SB.height then
  begin
    SB.VertScrollBar.position := Debut.height + GS.Height + (Fin.CurrentLine * Abs(Fin.Font.Height));
  end
  else
  begin
    SB.VertScrollBar.position := SB.VertScrollBar.Range;
  end;
  SBPosition := SB.VertScrollBar.position;

end;

procedure TFFacture.GSExit(Sender: TObject);
var cancel: boolean;
  ACOl, ARow: integer;
begin
  // MODIFBTP : en attendant la modif de JLD dans facture.pas
  ACol := GS.Col;
  ARow := GS.Row;
  Cancel := False;
  GSCellExit(nil, ACol, ARow, Cancel);
  if Cancel then Exit;
  GSRowExit(nil, ARow, Cancel, False);
  if Cancel then Exit;
end;

procedure TFFacture.GSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_PRIOR) then
  begin
    if (GS.Row > 1) then
    begin
      Key := 0;
      if (not SaisieTypeAvanc) then
        if (GS.Row - NbLignesGrille < 1) then GS.Row := 1
        else GS.Row := GS.Row - NbLignesGrille;
    end;
  end;
  if (Key = VK_NEXT) then
  begin
    Key := 0;
    if (not SaisieTypeAvanc) then
      if (GS.Row + NbLignesGrille >= GS.Rowcount) then GS.Row := GS.Rowcount - 1
      else GS.Row := GS.Row + NbLignesGrille;
  end;

  {$IFDEF BTP}
  {Ctrl+P}
  if (VH_GC.BTGestParag) and (Shift = [ssctrl]) and (Key = 80) then
  begin
    Key := 0;
    TInsParagClick(nil);
  end;
  {Ctrl+S}
  if (Shift = [ssctrl]) and (Key = 83) then
  begin
    Key := 0;
    Insere_SDP;
  end;
  {$ENDIF}

end;

procedure TFFacture.TVParagClick(Sender: TObject);
var Tn: TTreeNode;
  TOBL: TOB;
  Acol, Arow: integer;
begin
  Tn := TVParag.selected;
  TOBL := Tn.data;
  if (TOBL <> nil) then
  begin
    ARow := TOBL.GetValue('GL_NUMLIGNE');
    SB.VertScrollBar.Position := Debut.Height + (GS.RowHeights[0] * ARow);
    ACol := SG_Lib;
    GS.SetFocus;
    GSEnter(GS);
    GS.Row := Arow;
    GS.col := Acol;
    StCellCur := GS.Cells[GS.Col, GS.Row];
  end;
end;

// Gestion de la saisie d'un texte descriptif sur une ligne commentaire

procedure TFFacture.Descriptif1Exit(Sender: TObject);
var TOBL: TOB;
  st: string;
begin
  TOBL := GetTOBLigne(TOBPiece, TextePosition); // récupération TOB ligne
  if TOBL <> nil then
  begin
    if (Length(Descriptif1.text) <> 0) and (Descriptif1.text <> #$D#$A) then
    begin
      TOBL.PutValue('GL_BLOCNOTE', RichToString(Descriptif1));
      // si la ligne n'est pas une ligne article, on prend les 70 premiers
      // caractères du texte pour inscrire dans le libellé
      if (TOBL.GetValue('GL_REFARTSAISIE') = '') then
      begin
        st := '{\rtf1\ansi\ ' + Copy(Descriptif1.text, 1, 55) + '}';
        TOBL.PutValue('GL_LIBELLE', st);
      end;
    end else
    begin
      TOBL.PutValue('GL_BLOCNOTE', '');
    end;
  end;
  Descriptif1.visible := False;
  //GS.RowHeights[GS.row]:=GS.DefaultRowHeight ;
  AfficheLaLigne(TextePosition);
end;

procedure TFFacture.BTypeArticleClick(Sender: TObject);
var TOBL: TOB;
  bc: boolean;
begin
  if OrigineEXCEL then exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // récupération TOB ligne
  if TOBL = nil then exit;
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  if TOBL.getValue('GL_TYPEARTICLE') = 'OUV' then
  begin
    GS.SynEnabled := false;
    SuppressionDetailOuvrage(GS.Row);
    if TOBL.getValue('GL_TYPEPRESENT') > DOU_AUCUN then TOBL.PutValue('GL_TYPEPRESENT', DOU_AUCUN)
    else TOBL.PUtvalue('GL_TYPEPRESENT', PresentSousDetail);
    AffichageDetailOuvrage(GS.Row);
    GS.SynEnabled := true;
  end;
  bc := false;
  GSRowEnter(GS, GS.Row, bc, False);
end;

procedure TFFacture.TInsParagClick(Sender: TObject);
var TOBL: TOB;
  Niv: Integer;
  Arow, Acol: integer;
  Cancel, bc: boolean;
begin
  // récup. niveau ligne courante
  if Action = taconsult then exit;
  {$IFDEF BTP}
  if OrigineEXCEL then exit;
  {$ENDIF}
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then
    Niv := 1
  else
  begin
    Niv := TOBL.GetValue('GL_NIVEAUIMBRIC');
    // 9 paragraphes imbriqués maximum
    if Niv = 9 then
    begin
      ShowMessage('Insertion impossible,' + chr(10) + 'Le nombre maximum de paragraphes imbriqués, à savoir 9, est atteint.');
      Exit;
    end;
    // incrémentation du niveau sauf si la ligne courante
    // est un début de paragraphe.
    if copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) <> 'DP' then
      Niv := Niv + 1;
  end;
  // Insertion des 3 lignes de base :
  ClickInsert(GS.Row);
  ClickInsert(GS.Row);
  ClickInsert(GS.Row);
  // Mise à jour de la taille du grid
  //  GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);//MODIFBTP140301

  // Mise à jour des lignes du nouveau paragraphe
  // Début paragraphe
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  TOBL.PutValue('GL_TYPELIGNE', 'DP' + IntToStr(Niv));
  if niv = 1 then TOBL.PutValue('GL_LIBELLE', 'Paragraphe :')
  else TOBL.PutValue('GL_LIBELLE', 'Sous-paragraphe :');
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  // ligne commentaire
  TOBL := GetTOBLigne(TOBPiece, GS.Row + 1);
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  AfficheLaLigne(GS.Row + 1);
  // Fin paragraphe
  TOBL := GetTOBLigne(TOBPiece, GS.Row + 2);
  TOBL.PutValue('GL_TYPELIGNE', 'TP' + IntToStr(Niv));
  if niv = 1 then TOBL.PutValue('GL_LIBELLE', 'Total Paragraphe :')
  else TOBL.PutValue('GL_LIBELLE', 'Total Sous-paragraphe :');
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  AfficheLaLigne(GS.Row + 2);

  //GSEnter(GS);
  AfficheLaLigne(GS.Row);
  Arow := GS.row;
  Acol := GS.fixedcols;
  bc := False;
  Cancel := False;
  ACol := GS.fixedCols;
  GSRowEnter(GS, ARow, bc, False);
  GSCellEnter(GS, ACol, ARow, Cancel);
  GS.col := ACol;
  GS.row := Arow;
end;

procedure TFFacture.BArborescenceClick(Sender: TObject);
begin
  if (BArborescence.Down = False) then
    TTVParag.visible := False
  else
  begin
    Affiche_TVParag;
    TTVParag.Visible := true;
  end;
end;

procedure TFFacture.SaisiePrixMarche(Coef: double = 0);
var NewMontant, NewMontantPar: double;
  EnHt: Boolean;
  IndiceMontant, IndiceMontantPar, NbPassage, I: Integer;
  TOBPourcent, TOBL: TOB;
  RecupPourcent, traitement: boolean;
  Acol, Arow: integer;
  ModeGestion: Integer;
  NbPassageMax: Integer;
  EtenduApplication: integer; // tout le document
  IndDepart, Indfin, IndRefTot: integer;
  ReferencePrix: double;
begin
  TOBL := nil;
  if (GS.row > 0) then
  begin
    TOBL := TOBPIECE.detail[GS.row - 1];
    if (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'DP') and
      (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'TP') then TOBL := nil
    else indRefTot := RecupFinParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'), true);

  end;
  NbPassage := 0;
  NbPassageMax := 4;
  RecupPourcent := false;
  ModeGestion := 0;
  Arow := GS.row;
  Acol := GS.col;
  ENHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  EtenduApplication := 0;
  if EnHt then
  begin
    IndiceMontant := TOBPiece.GetNumChamp('GP_TOTALHTDEV');
    if TOBL <> nil then IndiceMontantPar := TOBPiece.detail[IndrefTot].GetNumChamp('GL_MONTANTHTDEV');
  end else
  begin
    IndiceMontant := TOBPiece.GetNumChamp('GP_TOTALTTCDEV');
    if TOBL <> nil then IndiceMontantPar := TOBPiece.detail[IndrefTot].GetNumChamp('GL_MONTANTTTCDEV');
  end;
  NewMontant := TOBPiece.GetValeur(IndiceMontant);
  if TOBL <> nil then NewMontantPar := TOBPiece.detail[IndRefTot].GetValeur(IndiceMontantPar) else NewMontantPar := 0;

  if Coef <> 0 then
  begin
    traitement := True;
    ModeGestion := 3;
    NewMontant := Coef;
  end
  else if GestionPrixMarche(NewMontant, NewMontantPar, ModeGestion, EnHt, EtenduApplication) then
    traitement := True
  else
    traitement := False;

  if traitement = True then
  begin
    if EtenduApplication = 1 then
    begin
      indDepart := RecupDebutParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'), true);
      indFin := RecupFinParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'), true);
      NewMontant := NewMontantPar;
    end else
    begin
      IndDepart := 0;
      IndFin := TOBPIece.detail.count - 1;
    end;
    if BeforeReCalculPrixMarche(TOBPiece, Modegestion, IndDepart, IndFin) then
    begin
      GS.SynEnabled := false;
      if (Modegestion = 3) or
        ((EtenduApplication = 0) and (NewMontant <> TOBPiece.GetValeur(IndiceMontant))) or
        ((EtenduApplication = 1) and (NewMontant <> TOBPiece.detail[Indfin].GetValeur(IndiceMontantPar))) then
      begin
        if ModeGestion <> 1 then NbPassageMax := 6; // bicose recalcul de prix sur marge demande du calcul
        initMove(NbPassageMax * TOBPiece.detail.count, '');
        TOBPOurcent := TOB.create('LesPourcentages', nil, -1);
        if EtenduApplication = 0 then SupLesLibDetail(TOBPiece)
        else
        begin
          SupLesLibdetInParag(TOBPiece, Inddepart);
          // oblige bicose la fin peut avoir bougé d'indice
          indFin := RecupFinParagraph(TOBPIece, IndDepart, TOBPiece.detail[Inddepart].GetValue('GL_NIVEAUIMBRIC'), true);
        end;
        NumeroteLignesGC(GS, TOBPIece);
        repeat
          AppliquePrixMarche(NewMontant, TOBPourcent, RecupPourcent, ModeGestion, IndDepart, IndFin, EtenduApplication);
          RecupPourcent := true;
          inc(NbPassage);
          if ModeGestion = 3 then ReferencePrix := NewMontant
          else if EtenduApplication = 0 then ReferencePrix := TOBPiece.GetValeur(IndiceMontant)
          else ReferencePrix := TOBPiece.Detail[IndFin].GetValeur(IndiceMontantPar);
        until (abs(NewMontant - ReferencePrix) < 0.02) or (NbPassage > NbPassageMax);
        if NewMontant <> referencePrix then AttribueEcartMarche(NewMontant, TOBPOurcent, IndDepart, IndFin, EtenduApplication);
        PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
        CalculeLaSaisie(-1, -1, true);
        if EtenduApplication = 0 then LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc) else
          AddLesLibdetInParag(TOBPiece, IndDepart);
        GS.VidePile(false);
        GS.RowCount := TOBPiece.detail.count + 2;
        if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
        GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
        for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
        NumeroteLignesGC(GS, TOBPIece);
        TOBPourcent.free;
        finiMove;
      end;
      GS.row := Arow;
      GS.col := Acol;
      GS.SynEnabled := true;
      MontreInfosLigne(TOBPIECE.detail[GS.row - 1], nil, nil, nil, INFOSLIGNE, PPInfosLigne);
    end else
    begin
      ShowMessage('Ce recalcul n''est pas compatible' + #13#10 + 'avec l''utilisation de pourcentage dans le document');
    end;
  end;
end;

procedure TFFacture.AppliquePourcentAvanc(TOBPiece: TOB; Pourcent: double; IndDepart, IndFin: integer; ModeApplic: integer; Dev: Rdevise);
var Indice: Integer;
  TOBL: TOB;
begin
  for Indice := IndDepart to Indfin do
  begin
    TOBL := TOBPiece.detail[Indice];
    // mis en commentaire par brl 27/08/02 : inutile car affectation de la ligne de début
    // à la ligne de fin passées en argument
    // if (copy(TOBL.GetValue ('GL_TYPELIGNE'),1,2) = 'TP') and (ModeApplic=1) then break;
    if TOBL.getValue('GL_ARTICLE') = '' then continue;
    TOBL.Putvalue('GL_POURCENTAVANC', Pourcent);
    TOBL.Putvalue('GL_QTEPREVAVANC', arrondi(TOBL.GetValue('GL_QTEFACT') * (Pourcent / 100), V_PGI.OkDecQ));
  end;
  TOBPIece.PutValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, false);
end;

procedure TFFacture.SaisieAvancement;
var
  TOBL: TOB;
  EtenduApplication: integer; // tout le document
  IndDepart, Indfin: integer;
  Pourcent: double;
  Parag: boolean;
begin
  IndDepart := 0;
  EtenduApplication := 0;
  if (GS.row > 0) then
  begin
    TOBL := TOBPIECE.detail[GS.row - 1];
    if (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'DP') and
      (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'TP') then TOBL := nil
    else
    begin
      indDepart := RecupDebutParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'), true);
      Parag := true;
    end;
  end;
  if AssistSaisieAvanc(EtenduApplication, Pourcent, parag) then
  begin
    if EtenduApplication = 1 then
    begin
      indDepart := RecupDebutParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'));
      indFin := RecupFinParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'));
    end else
    begin
      indDepart := 0;
      IndFin := TOBPIece.detail.count - 1
    end;
    AppliquePourcentAvanc(TOBPiece, Pourcent, IndDepart, IndFin, EtenduApplication, DEV);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end;
end;

procedure TFFacture.BPrixMarcheClick(Sender: TObject);
begin
  if Action = taConsult then exit;
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  if SaisieTypeAvanc then SaisieAvancement
  else SaisiePrixMarche;
end;

function TFFacture.OkLigneCalculMarche(TOBLig: TOB; IndtypeLigne: integer): boolean;
var TypeLigne: string;
begin
  result := false;
  if TOBLig = nil then exit;
  TypeLigne := TOBLIG.GetValeur(IndTypeLigne);

  if (TYpeLigne <> 'COM') and
    (TypeLigne <> 'TOT') and
    (Copy(TYpeLIgne, 1, 2) <> 'DP') and
    (Copy(TypeLigne, 1, 2) <> 'TP') then Result := true;
end;

procedure TFFacture.AppliquePrixMarche(NewMontant: double; TOBPOurcent: TOB; RecupPourcent: boolean; ModeGestion: Integer; IndDepart, IndFin,
  EtenduApplication: integer);
var Indice: Integer;
  EnHt: Boolean;
  TOBLig: TOB;
  IndPrixVente, TypeLigne, TypeArticle, CodeArticle, IndPrixAchat, IndPrixRevient: Integer;
  MontantPrec, NewPuLigne, MontantAchat: double;
  Coef, CoefFG, CftMrg: Double;
  PxValo: double;
  {$IFDEF BTP}
  IndiceNomen: integer;
  TOBOuv: TOB;
  {$ENDIF}
begin
  EnHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  if EtenduApplication = 1 then
  begin
    if EnHt then MontantPrec := TOBPiece.detail[Indfin].GetValue('GL_MONTANTHTDEV') else
      MontantPrec := TOBPiece.detail[Indfin].GetValue('GL_MONTANTTTCDEV');
  end else
  begin
    if EnHt then MontantPrec := TOBPiece.GetValue('GP_TOTALHTDEV') else
      MontantPrec := TOBPiece.GetValue('GP_TOTALTTCDEV');
  end;
  // recup Valeur Achat du document
  if EtenduApplication = 0 then
  begin
    IndDepart := 0;
    IndFin := TOBPiece.detail.count - 1;
    if VH_GC.GCMargeArticle = 'PMA' then PxValo := TOBPiece.GetValue('PMAP') else
      if VH_GC.GCMargeArticle = 'PMR' then PxValo := TOBPiece.GetValue('PMRP') else
      if VH_GC.GCMargeArticle = 'DPA' then PxValo := TOBPiece.GetValue('DPA') else
      if VH_GC.GCMargeArticle = 'DPR' then PxValo := TOBPiece.GetValue('DPR');
  end else
  begin
    if VH_GC.GCMargeArticle = 'PMA' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_PMAP') else
      if VH_GC.GCMargeArticle = 'PMR' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_PMRP') else
      if VH_GC.GCMargeArticle = 'DPA' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_DPA') else
      if VH_GC.GCMargeArticle = 'DPR' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_DPR');
  end;

  if ModeGestion = 3 then Coef := NewMontant // affectation Coef FG
  else if ModeGestion = 1 then Coef := NewMontant / MontantPrec // Calcul sur Montant
  else Coef := (NewMontant - PxValo) / (MontantPrec - PxValo); // Calcul sur Marge

  for Indice := IndDepart to IndFin do
  begin
    TOBLig := TOBPiece.detail[Indice];
    if Indice = IndDepart then
    begin
      if EnHt then IndPrixVente := TOBLIG.GetNumChamp('GL_PUHTDEV') else
        IndPrixVente := TOBLIG.GetNumChamp('GL_PUTTCDEV');
      if VH_GC.GCMargeArticle = 'PMA' then IndPrixAchat := TOBLig.GetNumchamp('GL_PMAP') else
        if VH_GC.GCMargeArticle = 'PMR' then IndPrixAchat := TOBLig.GetNumchamp('GL_PMRP') else
        if VH_GC.GCMargeArticle = 'DPA' then IndPrixAchat := TOBLig.GetNumchamp('GL_DPA') else
        if VH_GC.GCMargeArticle = 'DPR' then IndPrixAchat := TOBLig.GetNumchamp('GL_DPR');
      TypeArticle := TOBLIG.GetNumChamp('GL_TYPEARTICLE');
      TypeLigne := TOBLIG.GetNumChamp('GL_TYPELIGNE');
      CodeArticle := TOBLIG.GetNumChamp('GL_ARTICLE');
    end;
    if (OkLigneCalculMarche(TOBLIG, Typeligne)) then
    begin
      if (TOBLIG.GetValeur(TypeArticle) = 'EPO') then continue;
      if (TOBLIG.GetValeur(TypeArticle) = 'POU') and (RecupPourcent) then
      begin
        AddPourcent(TOBPiece, TOBPourcent, Indice);
        continue;
      end;
      // C'est bien un article a prendre en compte
      if ModeGestion = 1 then
      begin
        // Prorata du Montant Ligne
        NewPuLigne := arrondi(TOBLig.getvaleur(IndPrixvente) * Coef, DEV.Decimale);
      end
      else if ModeGestion = 3 then
      begin
        if VH_GC.GCMargeArticle = 'PMR' then
        begin
          IndPrixAchat := TOBLig.GetNumchamp('GL_PMAP');
          IndPrixRevient := TOBLig.GetNumchamp('GL_PMRP');
        end
        else if VH_GC.GCMargeArticle = 'DPR' then
        begin
          IndPrixAchat := TOBLig.GetNumchamp('GL_DPA');
          IndPrixRevient := TOBLig.GetNumchamp('GL_DPR');
        end
        else IndPrixRevient := 0;

        // affectation d'un coef. de marge sauf
        //  - pour la sous-traitance
        //  - si le prix d'achat est nul
        if ((TOBLIG.GetValeur(TypeArticle) = 'PRE'){$IFDEF BTP} and (RenvoieTypeRes(TOBLIG.GetValeur(CodeArticle)) = 'ST'){$ENDIF}) or
          (TOBLig.getvaleur(IndPrixAchat) = 0) then
          NewPuLigne := TOBLig.getvaleur(IndPrixvente)
        else
          if IndPrixRevient = 0 then
          NewPuLigne := arrondi(TOBLig.getvaleur(IndPrixAchat) * Coef, DEV.Decimale)
        else
        begin
          if TOBLig.getvaleur(IndPrixRevient) <> 0 then CftMrg := TOBLig.getvaleur(IndPrixvente) / TOBLig.getvaleur(IndPrixRevient)
          else CftMrg := 0;
          TOBLIG.PutValeur(IndPrixRevient, arrondi(TOBLig.getvaleur(IndPrixAchat) * Coef, DEV.Decimale));
          NewPuLigne := arrondi(TOBLig.getvaleur(IndPrixRevient) * CftMrg, DEV.Decimale);
        end;
      end
      else
      begin
        // Prorata de la marge Ligne
        MontantAchat := TOBLig.getvaleur(IndPrixvente) - (TOBLIG.GetValeur(IndPrixAchat) / TOBLig.getValue('GL_PRIXPOURQTE'));
        NewPuLigne := arrondi((MontantAchat * Coef) + TOBLIG.Getvaleur(IndPrixAchat), DEV.Decimale)
      end;
      if TOBLIG.GetValeur(TypeArticle) = 'OUV' then
      begin
        {$IFDEF BTP}
        IndiceNomen := TOBLIg.GetValue('GL_INDICENOMEN');
        if IndiceNomen > 0 then
        begin
          TOBOuv := TOBOuvrage.Detail[IndiceNomen - 1];
          TOBLig.PutValue('GL_RECALCULER', 'X');
          if ModeGestion = 3 then CoefFG := Coef
          else CoefFG := 0;
          ReajusteMontantOuvrage(TOBOuv, TOBLIG.GetValeur(IndPrixVente), NewPuLigne, DEV, EnHt, True, CoefFG);
        end;
        {$ENDIF}
      end;
      TOBLIG.PutValeur(IndPrixVente, NewPuligne);
      TOBLig.PutValue('GL_RECALCULER', 'X');
      MoveCur(false);
    end;
  end;
  TOBPIece.putvalue('GP_RECALCULER', 'X');
  CalculeLeDocument;
  if EtenduApplication = 1 then CalculeSousTotauxPiece(TOBPiece);
end;

procedure TFFacture.AttribueEcartMarche(NewMontant: double; TOBPOurcent: TOB; IndDepart, IndFin, EtenduApplication: integer);
var Indice: Integer;
  EnHt: Boolean;
  TOBLig: TOB;
  IndPrixVente, TypeLigne, TypeArticle, CodeArticle, IndMaxMontant: Integer;
  MontantPrec, NewPuLigne, MontantMax: double;
  Ecart, EcartAffectable: Double;
  EcartOk: boolean;
  ArtLast: string;
  {$IFDEF BTP}
  IndiceNomen: integer;
  TOBOUv: TOB;
  {$ENDIF}
begin
  ArtLast := '';
  MontantMax := 0;
  IndMaxMontant := -1;
  EnHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  if EtenDuApplication = 0 then
  begin
    IndDepart := 0;
    Indfin := TOBPiece.detail.count - 1;
    if EnHt then MontantPrec := TOBPiece.GetValue('GP_TOTALHTDEV') else
      MontantPrec := TOBPiece.GetValue('GP_TOTALTTCDEV');
  end else
  begin
    if EnHt then MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTHTDEV') else
      MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTTTCDEV');
  end;
  Ecart := arrondi(NewMontant - MontantPrec, DEV.Decimale);
  EcartOk := false;
  for Indice := IndDepart to IndFin do
  begin
    TOBLig := TOBPiece.detail[Indice];
    if Indice = IndDepart then
    begin
      if EnHt then IndPrixVente := TOBLIG.GetNumChamp('GL_PUHTDEV') else
        IndPrixVente := TOBLIG.GetNumChamp('GL_PUTTCDEV');
      TypeArticle := TOBLIG.GetNumChamp('GL_TYPEARTICLE');
      TypeLigne := TOBLIG.GetNumChamp('GL_TYPELIGNE');
      CodeArticle := TOBLIG.GetNumChamp('GL_ARTICLE');
    end;
    if (TOBLIG.getvaleur(Typeligne) = 'ART') and (TOBLIG.getvaleur(CodeArticle) <> '') then
    begin
      if (TOBLIG.GetValeur(TypeArticle) <> 'POU') and (TOBLIG.GetValeur(TypeArticle) <> 'EPO') then
      begin
        if TOBLIG.GetValeur(TypeArticle) = 'MAR' then
        begin
          ArtLast := TOBLIG.getvalue('GL_ARTICLE');
          if (((TOBLIG.GetValue('GL_MONTANTHTDEV') > MontantMax) and (EnHt)) or
            ((TOBLIG.GetValue('GL_MONTANTTTCDEV') > MontantMax) and (not EnHt))) and
            (not DansChampsPourcent(Indice, TOBPourcent)) then
            IndMaxMontant := Indice;
        end;
        if (not DansChampsPourcent(Indice, TOBPourcent)) then
        begin
          EcartAffectable := Arrondi(Ecart / TOBLIG.GetValue('GL_QTEFACT'), Dev.Decimale);
          if EcartAffectable <> 0 then
          begin
            NewPuLigne := TOBLIG.GetValeur(IndPrixVente) + EcartAffectable;
            if TOBLIG.GetValeur(TypeArticle) = 'OUV' then
            begin
              {$IFDEF BTP}
              IndiceNomen := TOBLIg.GetValue('GL_INDICENOMEN');
              if IndiceNomen > 0 then
              begin
                TOBOuv := TOBOuvrage.Detail[IndiceNomen - 1];
                TOBLig.PutValue('GL_RECALCULER', 'X');
                ReajusteMontantOuvrage(TOBOuv, TOBLIG.GetValeur(IndPrixVente), NewPuLigne, DEV, true);
              end;
              {$ENDIF}
            end;
            TOBLIG.PutValeur(IndPrixVente, NewPuligne);
            TOBLig.PutValue('GL_RECALCULER', 'X');
            Ecart := Ecart - Arrondi(EcartAffectable * TOBLIG.GetValue('GL_QTEFACT'), Dev.decimale);
            if Ecart = 0 then
            begin
              EcartOk := true;
              break;
            end;
          end;
        end;
      end;
    end;
  end;
  if (ecart <> 0) and (not ecartOk) then
  begin
    AffecteEcartPrixMarche(TOBPIece, TOBTiers, TOBAffaire, TOBArticles, Ecart, ArtLast, IndMaxMontant, IndDepart, IndFin, EtenduApplication);
  end;
end;

procedure TFFacture.FormResize(Sender: TObject);
var Taille: Extended;
begin
  GS.height := SB.height - Debut.height - Fin.height;
  // On recalcule le nombre de lignes nécessaires pour afficher une grille correcte
  Taille := GS.height / (GS.rowHeights[0] + GS.GridLineWidth);
  GS.Rowcount := round(Taille); //

  // il y a plus de lignes détail que de lignes affichables dans la grille
  if TOBPiece.Detail.Count >= GS.rowcount then
    GS.Rowcount := TOBPiece.Detail.Count + 2; // nb de ligne détail + ligne de titre + une ligne de marge

  // il y a moins de lignes détail que de lignes minimum prévues dans la grille
  if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;

  HMTrad.ResizeGridColumns(GS); // Adaptation de la taille du grid
  HMTrad.ResizeGridColumns(INFOSLIGNE); // Adaptation de la taille du grid

  // Recalcul de la taille exacte de la grille en fonction du nb de lignes
  if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
  GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount); //on ajoute la taille des interlignes
  GS.FixedRows := 1;
  PPied.refresh;
end;

procedure TFFacture.Timer1Timer(Sender: TObject);
begin
  SB.VertScrollBar.Position := SBPosition;
  timer1.Enabled := FALSE;
end;

procedure TFFacture.LoadLesTextes;
var NumPiece: string;
  T: TOB;
begin
  // Texte de Debut
  Numpiece := cledoc.NaturePiece + ':' + cledoc.Souche + ':' + IntToStr(cledoc.NumeroPiece) + ':' + IntToStr(cledoc.indice);
  T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', NumPiece, '1'], false);
  if (T <> nil) then
  begin
    StringToRich(Debut, T.GetValue('LO_OBJET'));
  end else Debut.text := #$D#$A;

  // Texte de fin
  T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', NumPiece, '2'], false);
  if (T <> nil) then
  begin
    StringToRich(Fin, T.GetValue('LO_OBJET'));
  end else Fin.text := #$D#$A;
end;

procedure TFFacture.TTVParagClose(Sender: TObject);
begin
  BArborescence.Down := False;
end;

{$IFDEF BTP}

procedure TFFacture.Insere_SDP();
var TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // récupération TOB ligne
  if TOBL <> nil then
  begin
    if (TOBL.GetValue('GL_ACTIONLIGNE') = '') then
      TOBL.PutValue('GL_ACTIONLIGNE', 'SDP')
    else
      TOBL.PutValue('GL_ACTIONLIGNE', '');
  end;
  GS.refresh;
end;
{$ENDIF}

procedure TFFacture.RemplitLiens(TOBPiece, TOBLIens: TOB; Texte: THRichEditOLE; Rang: integer);
var T: TOB;
  NumPiece: string;
  Datepiece: TDatetime;
begin
  Numpiece := TOBPiece.GetValue('GP_NATUREPIECEG') + ':' + TOBPiece.GetValue('GP_SOUCHE') + ':' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ':' +
    IntToStr(TOBPiece.GetValue('GP_INDICEG'));
  Datepiece := StrToDate(TOBPIECE.GetValue('GP_DATEPIECE'));
  T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', NumPiece, rang], false);
  if (Length(Texte.Text) <> 0) and (texte.Text <> #$D#$A) then
  begin
    if T = nil then T := TOB.create('LIENSOLE', TOBLIENOLE, -1);
    T.PutValue('LO_TABLEBLOB', 'GP');
    T.PutValue('LO_QUALIFIANTBLOB', 'MEM');
    T.PutValue('LO_IDENTIFIANT', NumPiece);
    T.PutValue('LO_RANGBLOB', Rang);
    T.PutValue('LO_DATEBLOB', Datepiece);
    T.PutValue('LO_OBJET', RichtoString(Texte));
  end else
  begin
    if T <> nil then T.free;
  end;
end;

procedure TFFacture.Affiche_TVParag;
var TOBL: TOB;
  i, j, niv, nivcou: Integer;
  ligniv: array[1..9] of Integer;
  Tn: TTreeNode;
  Titre: string;
begin
  nivcou := 0;
  // chargement treeview
  TVParag.items.clear;
  Titre := FtitrePiece.Caption + ' N° ' + IntToStr(TOBPiece.GetValue('GP_NUMERO'));
  TVParag.items.add(nil, Titre);
  j := 0;

  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
    begin
      niv := TOBL.GetValue('GL_NIVEAUIMBRIC');
      if (niv > nivcou) then
      begin
        Tn := TVParag.Items.AddChild(TVParag.Items[j], TOBL.GetValue('GL_LIBELLE'));
        Tn.Data := TOBL;
        j := j + 1;
        ligniv[niv] := j;
      end else if (niv = nivcou) then
      begin
        Tn := TVParag.Items.Add(TVParag.Items[j], TOBL.GetValue('GL_LIBELLE'));
        Tn.Data := TOBL;
        j := j + 1;
      end else
      begin
        Tn := TVParag.Items.Add(TVParag.Items[ligniv[niv]], TOBL.GetValue('GL_LIBELLE'));
        Tn.Data := TOBL;
        j := j + 1;
        ligniv[niv] := j;
      end;

      nivcou := niv;
    end;
  end;
  TVParag.FullExpand;
end;

{$IFDEF BTP}

procedure TFFacture.AfficheTexteLigne(Arow: integer; Desc: THRichEditOLE);
var TOBL: TOB;
  ARect: TRect;
begin
  TOBL := GetTOBLigne(TOBPiece, Arow); // récupération TOB ligne
  if (TOBL.GetValue('GL_REFARTSAISIE') = '') and
    (Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) <> 'DP') and
    (Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) <> 'TP') then
  begin
    if TOBL <> nil then
    begin
      StringToRich(Desc, TOBL.GetValue('GL_BLOCNOTE'));
    end;
    ARect := GS.CellRect(GS.Col, Arow);
    Desc.Left := ARect.Left;
    Desc.Top := ARect.Top;
    Desc.top := Desc.top + GS.Top;

    Desc.Width := GS.ColWidths[SG_LIB];
    Desc.Visible := true;
    //   GS.rowHeights[GS.Row] := Desc.Height ;
    Desc.SetFocus;
    TextePosition := Arow;
  end;
end;

procedure TFFacture.CreeDesc;
begin
  if (IsLigneDetail(TOBPiece, nil, GS.row)) then exit;
  AfficheTexteLigne(GS.row, Descriptif1);
end;

function TFFacture.AfficheDesc: boolean;
var TOBL: TOB;
  Lib, RefArt: string;
begin
  result := False;
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // récupération TOB ligne
  if TOBL <> nil then
  begin
    Lib := TOBL.GetValue('GL_BLOCNOTE');
    RefArt := TOBL.GetValue('GL_REFARTSAISIE');
    if (RefArt = '') and (Length(Lib) <> 0) and (Lib <> #$D#$A) then
    begin
      AfficheTexteLigne(GS.row, Descriptif1);
      result := True;
    end;
  end;
end;
{$ENDIF}

procedure TFFacture.DebutExit(Sender: TObject);
begin
  if Debut.Modified then
  begin
    RemplitLiens(TOBPiece, TOBLIenOLE, Debut, 1);
    Debut.modified := false;
  end;
end;

procedure TFFacture.FinExit(Sender: TObject);
begin
  if fin.Modified then
  begin
    RemplitLiens(TOBPiece, TOBLIenOLE, Fin, 2);
    fin.modified := false;
  end;
end;

procedure TFFacture.Descriptif1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_TAB) and (Shift = [ssCtrl]) then
  begin
    Key := 0;
    Descriptif1Exit(self);
    SendMessage(GS.Handle, WM_KeyDown, VK_TAB, 0);
  end;
end;

procedure TFFacture.PersonnalisationBtp;
var XP, XD, XE: double;
  {$IFDEF BTP}
  TypeFacturation: string;
  {$ENDIF}
begin
  GetMontantRG(TOBPIeceRG, TOBBasesRG, XD, XP, XE, DEV);
  TOTALRGDEV.Value := XD;
  TTYPERG.text := GetCumultextRG(TOBPIECERG, 'PRG_TYPERG');
  TCAUTION.text := GetCumulTextRG(TOBPIECERG, 'PRG_NUMCAUTION');
  if RGMultiple(TOBPIECERG) then Action := taConsult;

  {$IFDEF BTP}
  // Pas d'accès aux codes tiers et affaire si création depuis la fiche affaire
  // ou si saisie de frais détaillés
  if ((Action = TaCreat) and (GP_AFFAIRE.text <> '')) or
    (TOBPiece.GetValue('GP_NATUREPIECEG') = 'FRC') then
  begin
    GP_TIERS.Enabled := False;
    GP_AFFAIRE1.Enabled := False;
    GP_AFFAIRE2.Enabled := False;
    GP_AFFAIRE3.Enabled := False;
    GP_AVENANT.Enabled := False;
    BRechAffaire.Enabled := False;
    BRazAffaire.Enabled := False;
  end;

  if (SaisieTypeAvanc) then PPied.Visible := false;
  TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if (SaisieTypeAvanc = true) and
    ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
  begin
    if SG_QA <> -1 then GS.cells[SG_QA, 0] := TraduireMemoire('Qté d''avancement');
    if SG_PCT <> -1 then GS.cells[SG_Pct, 0] := TraduireMemoire('% d''avancement');
  end;
  {$ENDIF}
  if (tModeBlocNotes in SaContexte) then
  begin
    GS.RowCount := TOBPiece.Detail.Count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
    GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
  end else
  begin
    {$IFDEF BTP}
    if (SaisieTypeAvanc = true) and
      ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
      GS.RowCount := TOBPiece.Detail.Count + 1;
    {$ENDIF}
  end;

end;

procedure TFFacture.BRetenuGarClick(Sender: TObject);
var TLocal, TLocalP, TLocalB, TOBRG: TOB;
  XD, XP, XE: Double;
begin
  if RGMultiple(TOBPIECERG) then exit;
  if TOBPIECERG.detail.count = 0 then
  begin
    TOBRG := TOB.create('PIECERG', TOBPIECERG, -1);
    initLigneRg(TOBRG, TOBPIECE);
  end else TOBRG := TOBPIECERG.detail[0];
  TLocal := TOB.create('PERSO', nil, -1);

  TLocal.Dupliquer(TOBRG, true, true);
  TheTob := TLocal;
  TLocalP := TOB.Create('LAPIECE', nil, -1);
  TLocalP.Dupliquer(TOBPIECE, true, true);
  TLocalB := TOB.Create('LESBASES', nil, -1);
  TLocalB.Dupliquer(TOBBases, true, true);
  TlocalP.Data := TlocalB;
  TheTOB.data := TlocalP;
  // On interdit la modification lorsqu'il y a +ieurs RG dans le doc
  AGLLanceFiche('BTP', 'BTPIECERG', '', '', ActionToString(Action));
  if TheTob <> nil then
  begin
    TheTob.data := nil;
    TOBRG.InitValeurs;
    TOBRG.Dupliquer(TheTOB, true, true);
    // Controle devenu obligatoire
    if TOBRG.GetValue('PRG_TAUXRG') = 0 then
    begin
      TOBBASESRG.clearDetail;
    end;
    RecalculeRG(TOBPiece, TOBPieceRG, TOBBases, TOBBasesRG, DEV);
    GetMontantRG(TOBPIeceRG, TOBBasesRG, XD, XP, XE, DEV);
    TOTALRGDEV.Value := XD;
    if TOBRG <> nil then
    begin
      TTYPERG.Text := TOBRG.GetValue('PRG_TYPERG');
      TCAUTION.text := TOBRG.GetValue('PRG_NUMCAUTION');
    end else
    begin
      TTYPERG.Text := '';
      TCAUTION.text := '';
    end;
    TheTob := nil;
  end;
  TLOCALB.free;
  TLocal.free;
  Tlocalp.data := nil;
  TlocalP.free;
end;

procedure TFFacture.DefiniPied;
var chaineRg, ChaineRg1: string;
begin
  // repositionne pour le cas ou l'on supprime la RG
  HGP_TOTALRGDEV.visible := false;
  LTOTALRGDEV.Visible := false;
  LHTTCDEV.visible := false;
  LLIBRG.Visible := false;
  LMONTANTRG.Visible := false;
  LCAUTION.Visible := false;
  LGP_TOTALTTCDEV.visible := true;
  HGP_TOTALHTDEV.top := 4;
  LGP_TOTALHTDEV.top := 4;
  HGP_TOTALPORTSDEV.top := 23;
  LTOTALPORTSDEV.top := 23;
  HGP_TOTALESCDEV.top := 42;
  LGP_TOTALESCDEV.top := 42;
  HGP_TOTALREMISEDEV.Top := 61;
  LGP_TOTALREMISEDEV.Top := 61;
  HGP_TOTALTAXESDEV.top := 4;
  LTOTALTAXESDEV.top := 4;
  HGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.visible := true;
  HGP_ACOMPTEDEV.top := 42;
  LGP_ACOMPTEDEV.top := 42;
  HGP_NETAPAYERDEV.Top := 61;
  LNETAPAYERDEV.Top := 61;
  //
  if (GetCumulValueRg(TOBPIECERG, 'PRG_TAUXRG') <> 0) then
  begin
    chaineRg := 'R.G ';
    if TOBPIeceRG.Detail.Count < 2 then
      chaineRg1 := ChaineRg + floattostr(TOBPIECERG.detail[0].GetValue('PRG_TAUXRG')) + ' % sur ' + TOBPieceRG.detail[0].GetValue('PRG_TYPERG');
    LLIBRG.Visible := true;
    LLIBRG.Caption := ChaineRg1;
    if (GetCumulTextRg(TOBPIECERG, 'PRG_TYPERG') = 'HT') then
    begin
      HGP_TOTALRGDEV.top := 80;
      LTOTALRGDEV.Top := 80;
      HGP_TOTALRGDEV.Parent := PTotaux;
      LTOTALRGDEV.Parent := Ptotaux;
      if (ApplicRetenue) then HGP_TOTALRGDEV.visible := true;
      if TOTALRGDEV.value = 0 then
      begin
        HGP_TOTALRGDEV.visible := true;
        LCAUTION.Parent := PTotaux;
        LCAUTION.Top := LTOTALRGDEV.top;
        LCAUTION.Left := (LGP_TOTALHTDEV.left + LGP_TOTALHTDEV.width) - LCAUTION.width;
        LCAUTION.Visible := true;
      end else
        if (ApplicRetenue) then
      begin
        LHTTCDEV.visible := true;
        LGP_TOTALTTCDEV.visible := false;
        LHTTCDEV.top := LGP_TOTALTTCDEV.top;
        LHTTCDEV.left := (LGP_TOTALTTCDEV.left + LGP_TOTALTTCDEV.width) - LHTTCDEV.width;
        LHTTCDEV.Parent := PTotaux1;
        LHTTCDEV.visible := true;
        LTOTALRGDEV.Visible := true;
      end else
      begin
        LMONTANTRG.Visible := true;
        chaineRg1 := 'Montant R.G ' + floattostr(GetCumulValueRG(TOBPIECERG, 'PRG_MTHTRGDEV')) + ' ' + DEV.Symbole;
        LMONTANTRG.Caption := ChaineRG1;
      end;
    end;
    if (GetCumulTextRg(TOBPIECERG, 'PRG_TYPERG') = 'TTC') then
    begin
      HGP_ACOMPTEDEV.Top := 61;
      LGP_ACOMPTEDEV.Top := 61;
      HGP_NETAPAYERDEV.Top := 80;
      LNETAPAYERDEV.Top := 80;
      HGP_TOTALRGDEV.top := 42;
      LTOTALRGDEV.Top := 42;
      HGP_TOTALRGDEV.Parent := PTotaux1;
      LTOTALRGDEV.Parent := Ptotaux1;
      if (ApplicRetenue) then HGP_TOTALRGDEV.visible := true;
      ptotaux1.refresh;
      LTOTALRGDEV.left := (LGP_TOTALTTCDEV.left + LGP_TOTALTTCDEV.width) - LTOTALRGDEV.width;
      if TOTALRGDEV.value = 0 then
      begin
        HGP_TOTALRGDEV.visible := true;
        LCAUTION.Parent := PTotaux1;
        LCAUTION.Top := LTOTALRGDEV.top;
        LCAUTION.Left := (LGP_TOTALTTCDEV.left + LGP_TOTALTTCDEV.width) - LCAUTION.width;
        LCAUTION.Visible := true;
      end else
        if (ApplicRetenue) then
      begin
        LTOTALRGDEV.Visible := true;
      end else
      begin
        LMONTANTRG.Visible := true;
        chaineRg1 := 'Montant R.G ' + floattostr(GetCumulValueRG(TOBPIECERG, 'PRG_MTTTCRGDEV')) + ' ' + DEV.Symbole;
        LMONTANTRG.Caption := ChaineRG1;
        HGP_ACOMPTEDEV.Top := 42;
        LGP_ACOMPTEDEV.Top := 42;
        HGP_NETAPAYERDEV.Top := 61;
        LNETAPAYERDEV.Top := 61;
      end;
    end;
  end;
  ptotaux.refresh;
  ptotaux1.refresh;
end;

procedure TFFacture.DefinitionGrille;
var O: boolean;
begin
  O := GS.enabled;
  GS.enabled := true;
  if (tModeBlocNotes in SaContexte) then
  begin
    Debut.Visible := true;
    Fin.Visible := true;
    GS.ScrollBars := ssNone;
    NbRowsInit := 10;
    NbRowsPlus := 1;
  end else
  begin
    GS.align := alClient;
    Debut.Visible := false;
    Fin.Visible := false;
    NbRowsInit := 100;
    NbRowsPlus := 20;
  end;
  GS.RowCount := NbRowsInit;
  if (tModeGridStd in SaContexte) then
  begin
    GS.Options := GS.options + [goFixedVertLine, goFixedHorzLine, goVertLine, goDrawFocusSelected, goColSizing, goTabs, goThumbTracking];
  end;
  GS.enabled := O;
end;

procedure TFFacture.DefinitionTaillePied;
begin
  if GetParamsoc('SO_RETGARANTIE') = True then
  begin
    GestionRetenue := true;
    Ppied.height := 110;
  end else GestionRetenue := false;
end;

procedure TFFacture.PPiedResize(Sender: TObject);
begin
  PTotaux.Height := PPied.height - 5;
  PTotaux1.Height := PPied.height - 5;
  INFOSLIGNE.Height := PPied.height - 6;
end;

procedure TFFacture.PTotauxResize(Sender: TObject);
begin
  HGP_TOTALHTDEV.top := 4;
  LGP_TOTALHTDEV.top := 4;
  HGP_TOTALPORTSDEV.top := 23;
  LTOTALPORTSDEV.top := 23;
  HGP_TOTALESCDEV.top := 42;
  LGP_TOTALESCDEV.top := 42;
  HGP_TOTALREMISEDEV.Top := 61;
  LGP_TOTALREMISEDEV.Top := 61;
end;

procedure TFFacture.PTotaux1Resize(Sender: TObject);
begin
  HGP_TOTALTAXESDEV.top := 4;
  LTOTALTAXESDEV.top := 4;
  HGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.top := 23;
  HGP_ACOMPTEDEV.top := 42;
  LGP_ACOMPTEDEV.top := 42;
  HGP_NETAPAYERDEV.Top := 61;
  LNETAPAYERDEV.Top := 61;
end;

procedure TFFacture.InitContexteGrid;
begin
  if CtxMode in V_PGI.PGIContexte then SaContexte := [tModeGridMode]
  else SaContexte := [tModeGridStd];
end;

procedure TFFacture.PourlaligneClick(Sender: TObject);
var ARow, ARowTemp, ColQuantite: integer;
  CodeArticle: string;
  TOBL: TOB;
  ReaffecteQte: boolean;
begin
  SourisSablier;
  try
    GS.SynEnabled := False;
    ColQuantite := -1;
    if SG_QF <> -1 then ColQuantite := SG_QF else if SG_QS <> -1 then ColQuantite := SG_QS;
    if ColQuantite = -1 then Exit;
    ARow := GS.Row;
    ARowTemp := ARow;
    ReaffecteQte := GS.Cells[ColQuantite, ARow] = '';
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then exit;
    if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
    begin
      CodeArticle := TOBL.GetValue('GL_CODESDIM');
      Inc(ARow);
      TOBL := TOBPiece.Detail[ARow - 1];
      while TOBL.GetValue('GL_CODEARTICLE') = CodeArticle do
      begin
        AffecteUneLigneInGS(ColQuantite, ARow, ReaffecteQte);
        Inc(ARow);
        TOBL := GetTOBLigne(TOBPiece, ARow);
        if TOBL = nil then Break;
      end;
    end
    else AffecteUneLigneInGS(ColQuantite, ARow, ReaffecteQte);
    CalculeLaSaisie(ColQuantite, ARowTemp, False);
  finally
    GS.SynEnabled := True;
    SourisNormale;
  end;
end;

procedure TFFacture.PourledocumentClick(Sender: TObject);
begin
  AffecteQuantiteZeroInGS(BAffecteTous);
end;

{$IFDEF BTP}

procedure TFFacture.GSFlipSelection(Sender: TObject);
var Arow, Niveau: integer;
  TOBL, TOBL1: TOB;
  retrieve: boolean;
  RefSais: string;
begin
  if Assigned(GS.OnFlipSelection) then
  begin
    Retrieve := true;
    GS.OnFlipSelection := nil;
    GS.OnBeforeFlip := nil;
  end else Retrieve := false;

  TOBL := GetTOBLigne(TOBPiece, RowSelected);
  if TOBL = nil then Exit;
  if (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) = 'DP') then
  begin
    Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
    for Arow := RowSelected + 1 to GS.rowcount do
    begin
      TOBL1 := GetTOBLigne(TOBPiece, ARow);
      if TOBL1 = nil then break;
      GS.FlipSelection(Arow);
      if (copy(TOBL1.getValue('GL_TYPELIGNE'), 1, 2) = 'TP') and
        (Niveau = TOBL1.GetValue('GL_NIVEAUIMBRIC')) then break;
    end;
  end;
  if TOBL.GetValue('GL_TYPEARTICLE') = 'OUV' then
  begin
    Niveau := TOBL.GetValue('GL_INDICENOMEN');
    for Arow := RowSelected + 1 to GS.rowcount do
    begin
      TOBL1 := GetTOBLigne(TOBPiece, ARow);
      if TOBL1 = nil then break;
      if (TOBL1.getValue('GL_TYPELIGNE') = 'COM') and
        (TOBL1.GetVAlue('GL_INDICENOMEN') = Niveau) then GS.flipSelection(Arow)
      else break;
    end;
  end;
  // Rajout pour Mode
  if (TOBL.GetValue('GL_TYPELIGNE') = 'COM') and (TOBL.GetValue('GL_TYPEDIM') = 'GEN') then
  begin
    RefSais := TOBL.GetValue('GL_CODESDIM');
    for Arow := RowSelected + 1 to GS.rowcount do
    begin
      TOBL1 := GetTOBLigne(TOBPiece, ARow);
      if TOBL1 = nil then break;
      if (TOBL1.getValue('GL_TYPELIGNE') = 'ART') and
        (TOBL1.GetVAlue('GL_TYPEDIM') = 'DIM') and (TOBL1.GetVAlue('GL_CODEARTICLE') = RefSais) then
      begin
        GS.flipSelection(Arow);
      end else break;
    end;
  end;
  if Retrieve then
  begin
    GS.OnFlipSelection := GSFlipSelection;
    GS.OnBeforeFlip := GSBeforeFlip;
  end;
  if GS.nbselected = 0 then RowSelected := 0;
end;

procedure TFFacture.GSBeforeFlip(Sender: TObject; ARow: Integer; var Cancel: Boolean);
var TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, Arow);
  if TOBL = nil then
  begin
    cancel := true;
    Exit;
  end;
  if (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) = 'TP') then
  begin
    cancel := true;
    Exit;
  end;
  if not ISLigneGerableCC(TOBPiece, TOBArticles, GereLot, GereSerie, Arow) then
  begin
    Cancel := true;
    exit;
  end;
  if IsLigneDetail(nil, TOBL) then
  begin
    cancel := true;
    Exit;
  end;
  if IsLigneDetailMode(TOBL) then
  begin
    cancel := true;
    Exit;
  end; // Rajout pour Mode
  if not cancel then RowSelected := Arow;
end;

procedure TFFacture.ajouteLigneSel(TOBSel: TOB; Indice: Integer);
var IndiceNomen: Integer;
  TOBLoc, TOBL, TOBOuv, TOBLIen: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, Indice);
  if TOBL = nil then exit;
  if (TOBL.GetValue('GL_TYPELIGNE') <> 'COM') or (TOBL.GetValue('GL_INDICENOMEN') = 0) then
  begin
    TOBLOC := TOB.Create('LIGNE', TOBSEL, -1);
    AddLesSupLigne(TOBLOC, false);
    InitLesSupLigne(TOBLoc); // Rajout par ls le 5/09/2002
    TOBLOC.Dupliquer(TOBL, false, true);
    // Gestion des ouvrages
    if copy(TOBL.GetValue('GL_TYPEARTICLE'), 1, 2) = 'OU' then
    begin
      IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
      TobOuv := TOBOUvrage.detail[IndiceNomen - 1];
      TOBLien := TOB.create('LIGNEOUV', TOBLOC, -1);
      InsertionChampSupOuv(TOBLIEN, false);
      TOBLIen.dupliquer(TOBOuv, true, true);
    end;
  end;
end;

procedure TFFacture.CopieDonnee;
var Indice: Integer;
  Mcopy: TstringList;
  TOBSEL: TOB;
begin
  Clipboard.clear;
  if GS.nbSelected = 0 then
  begin
    SendMessage(GS.InplaceEditor.Handle, WM_COPY, 0, 0);
    exit;
  end;
  GS.OnFlipSelection := nil;
  GS.OnBeforeFlip := nil;
  TOBSEL := TOB.create('DONNEAINS', nil, -1);
  TOBSEL.AddChampSupValeur('TYPE', 'LIGNE');
  Mcopy := TstringList.Create;
  for Indice := 1 to GS.RowCount do
  begin
    if (GS.IsSelected(Indice)) then
    begin
      ajouteLigneSel(TOBSel, Indice);
    end;
  end;
  ExportTob(TOBSel, Mcopy);
  Clipboard.clear;
  Mtransfert.Lines := Mcopy;
  Mtransfert.SelectAll;
  Mtransfert.CopyToClipboard;
  Mcopy.Clear;
  Mcopy.Free;
  TOBSel.free;
  Mcopy := nil;
  GS.OnFlipSelection := GSFlipSelection;
  GS.OnBeforeFlip := GSBeforeFlip;
end;

procedure TFFacture.ExportTOB(TOBLoc: TOB; Mcopy: TstringList);
begin
  MCopy.Add(TobLoc.SaveToBuffer(true, TRUE, 'GL_BLOCNOTE'));
end;
{$ENDIF}

procedure TFFacture.GScopierClick(Sender: TObject);
begin
  {$IFDEF BTP}
  RowCollage := -1;
  ColCollage := -1;
  CopieDonnee;
  {$ENDIF}
end;

{$IFDEF BTP}

procedure TFFacture.EnregistreDonne;
var CodeEnreg, LibEnreg: string;
  Indice: Integer;
  Mcopy: TstringList;
  TOBSEL, TOBENREG: TOB;
begin
  if GS.nbSelected = 0 then exit;
  GS.OnFlipSelection := nil;
  GS.OnBeforeFlip := nil;
  if DemandeNomEnreg('LIGNE', CodeEnreg, LibEnreg) then
  begin
    TOBSEL := TOB.create('DONNEAINS', nil, -1);
    TOBSEL.AddChampSupValeur('TYPE', 'LIGNE');
    Mcopy := TstringList.Create;
    for Indice := 1 to GS.RowCount do
    begin
      if (GS.IsSelected(Indice)) then ajouteLigneSel(TOBSel, Indice);
    end;
    ExportTob(TOBSel, Mcopy);
    MTransfert.Lines := Mcopy;
    MTransfert.SelectAll;
    //
    TOBENREG := TOB.create('BMEMORISATION', nil, -1);
    TOBENreg.PutValue('BMO_TYPEMEMO', 'LIGNE');
    TOBENreg.PutValue('BMO_CODEMEMO', CodeEnreg);
    TOBENreg.PutValue('BMO_LIBMEMO', LibEnreg);
    TOBENREG.PutValue('BMO_MEMO', Mtransfert.Text);
    try
      TOBENreg.InsertOrUpdateDB(true);
    finally
      TOBEnreg.free;
      Mcopy.Clear;
      Mcopy.Free;
      TOBSel.free;
      Mcopy := nil;
    end;
  end;
  GS.OnFlipSelection := GSFlipSelection;
  GS.OnBeforeFlip := GSBeforeFlip;
end;
{$ENDIF}

procedure TFFacture.GSEnregistrerClick(Sender: TObject);
begin
  {$IFDEF BTP}
  if GS.nbSelected = 0 then exit;
  RowCollage := -1;
  ColCollage := -1;
  EnregistreDonne;
  {$ENDIF}
end;

{$IFDEF BTP}

function TFFacture.IsTypeTOB: boolean;
begin
  result := false;
  MTransfert.SelectAll;
  Mtransfert.Clear;
  MTransfert.PasteFromClipboard;
  if copy(Mtransfert.Text, 1, 4) = '$|0|' then Result := true;
  Mtransfert.clear;
end;

procedure TFFacture.deselectionneRows;
begin
  GS.OnFlipSelection := nil;
  GS.OnBeforeFlip := nil;
  gs.AllSelected := false;
  GS.OnFlipSelection := GSFlipSelection;
  GS.OnBeforeFlip := GSBeforeFlip;
end;

procedure TFFacture.CollageDonnee;
begin
  deselectionneRows;
  MTransfert.SelectAll; // JLD+LS : utile ?????
  Mtransfert.Clear;
  MTransfert.PasteFromClipboard;
  ChargeDonnee;
end;

procedure TFFacture.ChargeDonnee;
var TOBLOC, TOBL: TOB;
  Indice, Niveau: Integer;
  SauteAfinPar, ArticleNonOk: boolean;
  Arow, SavRow, SavCol: integer;
  OldEna, bc, cancel: boolean;
  TypeFacturation: string;
begin
  if RowCollage = -1 then
  begin
    RowCollage := GS.row;
    ColCollage := GS.col;
  end;
  SavRow := RowCollage;
  SavCol := ColCollage;
  bc := False;
  Cancel := False;
  SavCol := GS.fixedCols;
  GSRowEnter(GS, SavRow, bc, False);
  GSCellEnter(GS, SavCol, SavRow, Cancel);
  GS.col := SavCol;
  GS.row := Savrow;
  TOBL := GetTOBLigne(TOBPiece, Savrow);
  if IsLigneDetail(nil, TOBL) then exit;
  OldEna := GS.SynEnabled;
  GS.SynEnabled := False;
  SauteAFinPar := false;
  ArticleNonOk := false;
  if TOBL = nil then
  begin
    Niveau := 0;
  end
  else
  begin
    Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
    // Sur une ligne de début de §, on insère au-dessus donc au niveau précédent
    if copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) = 'DP' then Niveau := Niveau - 1;
  end;
  TOBLoadFromBuffer(Mtransfert.Text, RecupTob);
  Arow := SavRow;
  if TOBImp.getValue('TYPE') = 'LIGNE' then
  begin
    for Indice := 0 to TOBImp.detail.count - 1 do
    begin
      TOBLoc := TOBImp.detail[Indice];
      AjouteLigneImport(TOBLoc, Niveau, Arow, SauteAFinPar, ArticleNonOk);
    end;
  end;
  if TOBPiece.Detail.Count >= GS.RowCount - 1 then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      GS.RowCount := TOBPiece.Detail.Count + 2;
      if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
      GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    end else
    begin
      {$IFDEF BTP}
      TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
      if (SaisieTypeAvanc = true) and ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
        GS.RowCount := TOBPiece.Detail.Count + 1;
      {$ENDIF}
    end;
  end;
  if ArticleNonOk then HPiece.Execute(44, Caption, '');
  Arow := SavRow;
  NumeroteLignesGC(GS, TOBpiece);
  for indice := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(indice + 1);
  TOBPiece.putValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, false);
  AfficheLaLigne(SavRow);
  // --
  bc := False;
  Cancel := False;
  SavCol := GS.fixedCols;
  GS.SynEnabled := OldEna;
  GSRowEnter(GS, SavRow, bc, False);
  GSCellEnter(GS, SavCol, SavRow, Cancel);
  GS.col := SavCol;
  GS.row := Savrow;
  StCellCur := GS.Cells[GS.Col, GS.Row];
  TOBIMP.free;
  GS.refresh;
end;

function TFFacture.RecupTob(Atob: TOB): Integer;
begin
  Result := 0;
  TOBImp := ATob;
end;

function TFFacture.IsArticleOk(Arow: integer): boolean;
var TOBArt, TOBL: TOB;
  rechart: T_RechArt;
  refsais: string;
begin
  result := false;
  TOBArt := FindTOBArtRow(TOBPiece, TobArticles, Arow);
  TOBL := GetTOBLigne(TOBPiece, Arow);
  if TOBL = nil then exit;
  if TOBArt <> nil then
  begin
    Result := true;
  end else
  begin
    TOBArt := CreerTOBArt(TOBArticles);
    RefSais := TOBL.GetValue('GL_CODEARTICLE');
    RechArt := TrouverArticleSQL(CleDoc.NaturePiece, RefSais, GP_DOMAINE.Value, '', CleDoc.DatePiece, TOBArt, TOBTiers);
    if RechArt = traOk then
    begin
      if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow) then
      begin
      end else
        result := false;
      begin
        result := true;
      end;
    end;
  end;
end;

procedure TFFacture.InsertDebParagrapheImp(TOBLOC: TOB; niveau: integer; Arow: integer);
var TOBL: TOB;
begin
  // Code insertion nouveau paragraphe
  InsertTobLigne(TOBPiece, Arow);
  TOBL := GetTOBLIgne(TOBPiece, Arow);
  PieceVersLigne(TOBPIece, TOBL);
  AffaireVersLigne(TOBPiece, TOBL, TOBAffaire);
  TOBL.PutValue('GL_LIBELLE', TOBLOC.GetValue('GL_LIBELLE'));
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
  TOBL.PutValue('GL_TYPELIGNE', 'DP' + intToStr(Niveau));
end;

procedure TFFacture.InsertFinParagrapheImp(TOBLOC: TOB; niveau, Arow: integer);
var TOBL: TOB;
begin
  // Code insertion fin de paragraphe
  InsertTobLigne(TOBPiece, Arow);
  TOBL := GetTOBLIgne(TOBPiece, Arow);
  PieceVersLigne(TOBPIece, TOBL);
  AffaireVersLigne(TOBPiece, TOBL, TOBAffaire);
  TOBL.PutValue('GL_LIBELLE', TOBLOC.GetValue('GL_LIBELLE'));
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
  TOBL.PutValue('GL_TYPELIGNE', 'TP' + intToStr(Niveau));
end;

function TFFacture.InsertLigneArticleImp(TOBLOC: TOB; var Arow: integer; Niveau: integer; var ArticleNonOk: boolean): boolean;
var TOBL, TOBA, TOBOuv: TOB;
  X: double;
  DetailATraiter: boolean;
  {$IFDEF BTP}
  TOBLN: TOB;
  Indice: integer;
  {$ENDIF}
begin
  result := false;
  TOBOuv := nil;
  DetailATraiter := false;
  // Code Insertion ligne de document
  InsertTobLigne(TOBPiece, Arow);
  TOBL := GetTOBLIgne(TOBPiece, Arow);
  if (TOBLoc.detail.count > 0) and (TOBLoc.GetValue('GL_TYPEARTICLE') = 'OUV') then
  begin
    // gestion du detail de l'ouvrage
    TOBOuv := TOB.create('', nil, -1);
    TOBOUV.dupliquer(TOBLoc.detail[0], true, true);
    TobLoc.ClearDetail;
  end;
  TOBL.dupliquer(TOBLOC, true, true);
  AddLesSupLigne(TOBL, False);
  InitLesSupLigne(TOBL);
  NewTOBLigneFille(TOBL);
  PieceVersLigne(TOBPIece, TOBL);
  AffaireVersLigne(TOBPiece, TOBL, TOBAffaire);
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
  if TOBL.GetValue('GL_TYPEARTICLE') <> 'POU' then
  begin
    if TOBPiece.GetValue('GP_FACTUREHT') = 'X' then X := TOBL.GetValue('GL_PUHTDEV')
    else X := TOBL.GetValue('GL_PUTTCDEV');
    // Retablissement du pu dans la monnaie du client
    if TOBL.GetValue('GL_DEVISE') <> TOBPiece.getValue('GP_DEVISE') then
    begin
      X := DEVISETODEVISE(X, TOBL.GetValue('GL_TAUXDEV'), TOBL.GetValue('GL_COTATION'),
        TOBPiece.GetValue('GP_TAUXDEV'), TOBPiece.GetValue('GP_COTATION'), V_PGI.okdecV);
    end else
    begin
      if TOBPiece.GetValue('GP_FACTUREHT') = 'X' then X := TOBL.GEtValue('GL_PUHTDEV')
      else X := TOBL.GetValue('GL_PUTTCDEV');
    end;

    if TOBPiece.GetValue('GP_FACTUREHT') = 'X' then TOBL.PutValue('GL_PUHTDEV', X)
    else TOBL.PutValue('GL_PUTTCDEV', X);
  end;
  if IsArticleOk(Arow) then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBarticles, Arow);
    ArticleVersLigne(TOBPIece, TOBA, nil, TOBL, TOBTiers, false); // recup des infos articles sans PU
    TraiteLaCompta(ARow);
    TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
    {$IFDEF BTP}
    if TobOuv <> nil then
    begin
      TOBLN := TOB.create('', TOBOUvrage, -1);
      TOBLN.dupliquer(TOBOuv, true, true);
      if TOBLN.detail.count > 0 then // On saute le groupe d'ouvrage
      begin
        DetailATraiter := true;
        RepriseDonneeArticle(TOBLN, nil);
        for indice := 0 to TOBLN.detail.count - 1 do
        begin
          ReajusteLigneParDoc(TOBL, TOBLN.detail[indice], DEV, 1);
        end;
      end;
      TOBL.Putvalue('GL_INDICENOMEN', TobOuvrage.detail.count);
    end;
    StringToRich(Descriptif1, TOBL.GetValue('GL_BLOCNOTE'));
    if (Length(Descriptif1.text) <> 0) and (Descriptif1.text <> #$D#$A) then
    begin
      TOBL.PutValue('GL_BLOCNOTE', RichToString(Descriptif1));
    end else
    begin
      TOBL.PutValue('GL_BLOCNOTE', '');
    end;
    {$ENDIF}
    result := true;
    TOBL.PutValue('GL_RECALCULER', 'X');
    TOBL.PUTVALUE('GL_LIBELLE', TOBLOC.GetValue('GL_LIBELLE'));
    TOBL.PutValue('GL_POURCENTAVANC', 0);
    TOBL.PutValue('GL_QTEPREVAVANC', 0);
    TOBL.PutValue('GL_QTESIT', 0);
    {$IFDEF BTP}
    // Traitement des détail ouvrages
    if DetailATraiter then
    begin
      dec(Arow);
      LoadLesLibDetOuvLig(TOBPIece, TOBOuvrage, TOBTiers, TOBAffaire, TOBL, Arow, DEV);
    end;
    {$ENDIF}
    inc(Arow);
  end else
  begin
    TOBL.free;
    ArticleNonOk := true;
  end;
  if TOBOuv <> nil then TOBOuv.free;
end;

procedure TFFacture.InsertLigneCommentaireImp(TOBLoc: TOB; Arow, Niveau: Integer);
var TOBL: TOB;
  {$IFDEF BTP}
  st: string;
  {$ENDIF}
begin
  InsertTobLigne(TOBPiece, Arow);
  TOBL := GetTOBLIgne(TOBPiece, Arow);
  TOBL.dupliquer(TOBLOC, true, true);
  AddLesSupLigne(TOBL, False);
  NewTOBLigneFille(TOBL);
  PieceVersLigne(TOBPIece, TOBL);
  AffaireVersLigne(TOBPiece, TOBL, TOBAffaire);
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
  {$IFDEF BTP}
  StringToRich(Descriptif1, TOBL.GetValue('GL_BLOCNOTE'));
  if (Length(Descriptif1.text) <> 0) and (Descriptif1.text <> #$D#$A) then
  begin
    TOBL.PutValue('GL_BLOCNOTE', RichToString(Descriptif1));
    // si la ligne n'est pas une ligne article, on prend les 70 premiers
    // caractères du texte pour inscrire dans le libellé
    if (TOBL.GetValue('GL_REFARTSAISIE') = '') then
    begin
      st := '{\rtf1\ansi\ ' + Copy(Descriptif1.text, 1, 55) + '}';
      TOBL.PutValue('GL_LIBELLE', st);
    end;
  end else
  begin
    TOBL.PutValue('GL_BLOCNOTE', '');
  end;
  {$ELSE}
  TOBL.PutValue('GL_LIBELLE', TOBLoc.getValue('GL_LIBELLE'));
  {$ENDIF}
end;

procedure TFFacture.InsertLigneTotalImp(TOBLoc: TOB; Arow, Niveau: integer);
var TOBl: TOB;
begin
  InsertTobLigne(TOBPiece, Arow);
  TOBL := GetTOBLIgne(TOBPiece, Arow);
  TOBL.dupliquer(TOBLOC, true, true);
  NewTOBLigneFille(TOBL);
  AddLesSupLigne(TOBL, False);
  InitLesSupLigne(TOBL);
  PieceVersLigne(TOBPIece, TOBL);
  AffaireVersLigne(TOBPiece, TOBL, TOBAffaire);
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niveau);
end;

function TFFacture.AjouteLigneImport(TOBLoc: TOB; var Niveau: integer; var Arow: integer; var SauteAFinPar: boolean; var ArticleNonOk: boolean): boolean;
var TOBL, TOBA, TOBOuv, TOBLN: TOB;
  X: double;
  st: string;
begin
  Result := false;
  if copy(TOBLOc.getValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
  begin
    // Debut de paragraphe
    if Niveau = 9 then
    begin
      SauteAfinPar := true;
      ArticleNonOk := true;
    end;
    if not SauteAFinPar then
    begin
      inc(niveau);
      InsertDebParagrapheImp(TOBLOC, niveau, Arow);
      inc(Arow);
      result := true;
    end;
  end else if copy(TOBLOC.getValue('GL_TYPELIGNE'), 1, 2) = 'TP' then
  begin
    if not SauteAFinPar then
    begin
      // Fin de paragraphe
      InsertFinParagrapheImp(TOBLOC, niveau, Arow);
      inc(Arow);
      Dec(niveau);
      result := true;
    end;
    if SauteAFinPar then SauteAFinPar := false;
  end else
  begin
    if not SauteAFinPar then
    begin
      if TOBLoc.GetValue('GL_TYPELIGNE') = 'ART' then
      begin
        result := InsertLigneArticleImp(TOBLOC, Arow, Niveau, ArticleNonOk);
      end else if (TOBLoc.getValue('GL_TYPELIGNE') = 'COM') and
        (TOBLoc.GetValue('GL_TYPEARTICLE') <> 'EPO') then
      begin
        InsertLigneCommentaireImp(TOBLoc, Arow, Niveau);
        inc(Arow);
        result := true;
      end else if (TOBLoc.getValue('GL_TYPELIGNE') = 'TOT') then
      begin
        InsertLigneTotalImp(TOBLoc, Arow, Niveau);
        inc(Arow);
        result := true;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TFFacture.GSCollerClick(Sender: TObject);
begin
  {$IFDEF BTP}
  if (not IsTypeTOB) then
  begin
    SendMessage(GS.InplaceEditor.Handle, WM_PASTE, 0, 0);
    exit;
  end;
  CollageDonnee;
  RowCollage := -1;
  ColCollage := -1;
  {$ENDIF}
end;

procedure TFFacture.GSRappelerClick(Sender: TObject);
begin
  {$IFDEF BTP}
  RappellerMemo;
  RowCollage := -1;
  ColCollage := -1;
  {$ENDIF}
end;

{$IFDEF BTP}

procedure TFFacture.RappellerMemo;
var Retour: string;
  TOBMemo: TOB;
  QQ: TQuery;
begin
  deselectionneRows;
  Retour := AGLLanceFiche('BTP', 'BTMEMORIS_MUL', 'BMO_TYPEMEMO=LIGNE', '', '');
  if Retour <> '' then
  begin
    TOBMemo := TOB.create('BMEMORISATION', nil, -1);
    QQ := OpenSQL('Select BMO_MEMO from BMEMORISATION Where BMO_TYPEMEMO="LIGNE" AND' +
      ' BMO_CODEMEMO="' + Retour + '"', True);
    TOBMemo.SelectDB('', QQ);
    ferme(QQ);
    MTransfert.SelectAll;
    MTransfert.Clear;
    MTransfert.text := TOBMemo.getValue('BMO_MEMO');
    TobMemo.Free;
    ChargeDonnee;
  end;
end;
{$ENDIF}

procedure TFFacture.Deselectionne(Arow: integer);
begin
  GS.FlipSelection(Arow);
end;

{$IFDEF BTP}

procedure TFFacture.GSContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var Acol, Arow: Integer;
  TOBL: TOB;
  Cancel: boolean;
begin
  if (MousePos.X = -1) or (MousePos.y = -1) then exit;
  GS.MouseToCell(MousePos.X, MousePos.Y, Acol, ARow);
  TOBL := GetTOBLigne(TOBPiece, Arow);
  if TOBL = nil then
  begin
    Handled := true;
    exit;
  end;
  Cancel := true;
  GS.synenabled := false;
  if Acol < GS.FixedCols then Acol := GS.fixedCols;
  GS.col := Acol;
  GS.row := Arow;
  GSRowEnter(Self, Arow, Cancel, false);
  GSCellEnter(Self, Acol, Arow, cancel);
  GS.row := Arow;
  GS.col := Acol;
  rowCollage := Arow;
  colCollage := Acol;
  GS.SynEnabled := true;
end;
{$ENDIF}

{$IFDEF BTPS5}

procedure TFFacture.FraisdetailClick(Sender: TObject);
var CleDoc: R_CleDoc;
  EnHT, SaisieContre, Retour: Boolean;
  NatureFrais: string;
  Cf: double;
begin
  NatureFrais := GetInfoParPiece(TOBPiece.GetValue('GP_NATUREPIECEG'), 'GPP_NATPIECEFRAIS');
  if NatureFrais = '' then
  begin
    PgiBox(TraduireMemoire('Nature de pièce associée pour les frais non paramétrée'), TraduireMemoire('Saisie Détaillée des frais'));
    Exit;
  end;
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  CleDoc.NaturePiece := NatureFrais;
  CleDoc.DatePiece := TOBPiece.GetValue('GP_DATEPIECE');
  CleDoc.Souche := TOBPiece.GetValue('GP_SOUCHE');
  CleDoc.NumeroPiece := TOBPiece.GetValue('GP_NUMERO');
  CleDoc.Indice := TOBPiece.GetValue('GP_INDICEG');
  if not ExistePiece(CleDoc) then
  begin
    EnHt := TOBPiece.GetValue('GP_FACTUREHT') = 'X';
    SaisieContre := TOBPiece.GetValue('GP_SAISIECONTRE') = 'X';
    CreerPieceVide(CleDoc, TOBPiece.GetValue('GP_TIERS'), TOBPiece.GetValue('GP_AFFAIRE'), TOBPiece.GetValue('GP_ETABLISSEMENT'),
      TOBPiece.GetValue('GP_DOMAINE'), EnHT, SaisieContre);
  end;
  SauveColList;
  Retour := SaisiePiece(CleDoc, TaModif);
  RestoreColList;
  if Retour = True then
  begin
    Cf := CalculCoefFrais(TOBPiece, TOBPorcs, DEV);
    if Cf <> 1 then SaisiePrixMarche(Cf);
  end;
end;
{$ENDIF}

{$IFDEF BTP}

procedure TFFacture.AjusteSousDetail;
var TypeFacturation: string;
begin
  SupLesLibDetail(TOBPiece);
  LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc);
  if TOBPiece.Detail.Count >= GS.RowCount - 1 then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      GS.RowCount := TOBPiece.Detail.Count + 2;
      if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;
      GS.height := (GS.rowHeights[0] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    end else
    begin
      TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
      if (SaisieTypeAvanc = true) and ((TypeFacturation = 'AVA') or (TypeFacturation = 'DAC')) then
        GS.RowCount := TOBPiece.Detail.Count + 1;
    end;
  end;
  NumeroteLignesGC(nil, TobPiece);
end;

procedure TFFacture.SRDocGlobalClick(Sender: TObject);
begin
  if Entree_Simulation(TOBArticles, TOBPiece, TOBOUvrage, 'Suivi de rentabilité du document', Action, DEV, false) then
  begin
    AjusteSousDetail;
    TOBPIece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end;
end;

procedure TFFacture.SRDocParagClick(Sender: TObject);
begin
  if Entree_Simulation(TOBArticles, TOBPiece, TOBOUvrage, 'Suivi de rentabilité du document', Action, DEV, true) then
  begin
    AjusteSousDetail;
    TOBPIece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end;
end;
{$ENDIF}

{$IFDEF BTP}

procedure TFFacture.GoToLigne(var Arow, Acol: integer);
var cancel: boolean;
begin
  GS.SynEnabled := false;
  cancel := false;
  GSRowEnter(self, Arow, cancel, false);
  GSCellEnter(self, Acol, Arow, cancel);
  GS.col := Acol;
  GS.row := Arow;
  GS.SynEnabled := true;
end;
{$ENDIF}

procedure TFFacture.PositionneTOBOrigine;
begin
  // initialisation;
  TOBPIECE_O.clearDetail;
  TOBAcomptes_O.clearDetail;
  TOBPIECERG_O.clearDetail;
  TOBBASESRG_O.clearDetail;
  TOBLIENOLE_O.clearDetail;
  TOBAdresses_O.clearDetail;
  TOBOuvrage_O.clearDetail;
  // Mise en adequations des tob origines
  TOBPIECE_O.Dupliquer(TOBPIECE, true, true);
  TOBAcomptes_O.Dupliquer(TOBAcomptes, true, true);
  TOBPIECERG_O.Dupliquer(TOBPIECERG, true, true);
  TOBBASESRG_O.Dupliquer(TOBBASESRG, true, true);
  TOBLIENOLE_O.Dupliquer(TOBLIENOLE, true, true);
  TOBAdresses_O.Dupliquer(TOBAdresses, true, true);
  TOBOuvrage_O.Dupliquer(TOBOuvrage, true, true);
end;

procedure TFFacture.DescriptifKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var TOBA: TOB;
begin
  if Key = VK_F2 then
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, GS.Row);
    if TOBA <> nil then StringToRich(Descriptif, TOBA.GetValue('GA_BLOCNOTE'));
  end;
end;

{$IFDEF MODE}

procedure TFFacture.TraiteLaFusion(AvecAffichage: Boolean);
begin
  //Ne gère pas la fusion pour les Tickets
  if TOBPiece.GetValue('GP_NATUREPIECEG') = 'FFO' then exit;

  //Supprime les lignes vides
  DepileTOBLignes(GS, TOBPiece, GS.Row, 1);

  //Fusionne les lignes
  if FusionnerLignesCodeBarre(TOBPiece) then
  begin
    //Vide la grille
    GS.VidePile(False);
    GS.RowCount := TOBPiece.Detail.Count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit;

    //Renumerote les lignes de la piece
    NumeroteLignesGC(GS, TOBPiece);

    //Calcul les prix
    TOBPiece.Putvalue('GP_RECALCULER', 'X');
    CalculeLeDocument;

    //Si la fusion s'est bien déroulé alors affichage du document fusionné
    if AvecAffichage then AffichageDim;
    StCellCur := GS.Cells[GS.Col, GS.Row];
  end;
end;
{$ENDIF}

procedure TFFacture.TFusionnerClick(Sender: TObject);
begin
  {$IFDEF MODE}
  TraiteLaFusion(True);
  {$ENDIF}
end;

procedure TFFacture.SLigneClick(Sender: TObject);
begin
  ClickVentil(False, True);
end;

procedure TFFacture.SPieceClick(Sender: TObject);
begin
  ClickVentil(True, True);
end;

procedure TFFacture.BtTPIClick(Sender: TObject);
var ACol, ARow: integer;
  Cancel: boolean;
begin
  ACol := GSAveugle.Col;
  ARow := GSAveugle.Row;
  Cancel := False;
  GSAveugleCellExit(GSAveugle, ACol, ARow, Cancel);
  if Cancel then exit;
  RetourneTOBSaisieAveugle();

  TheTOB := TOBGSA;
  TheTOB.Data := TOBArticles;

  AGLLanceFiche('MBO', 'TRANSTPI', '', '', 'PIECETPI=YES;NATUREPIECE=' + CleDoc.NaturePiece +
    ';DOMAINE=' + GP_DOMAINE.Value + ';FOURNISSEUR=' + GP_TIERS.Text);

  if TOBGSA <> nil then
  begin
    TOBGSA.PutGridDetail(GSAveugle, False, False, StColNameGSA, True);
    SommeQTE.Value := TOBGSA.Somme('QTE', [''], [''], False);
  end;
end;

procedure TFFacture.BZoomPieceClick(Sender: TObject);
var CDRef: R_CleDoc;
begin
  CDRef := Tob2cleDoc(TobPiece);
  VoirPiece(CDRef.NumeroPiece, CDRef, 'E');
end;

procedure TFFacture.BZoomPieceTVClick(Sender: TObject);
var CDRef: R_CleDoc;
begin
  CDRef := Tob2cleDoc(TobPiece);
  VoirPiece(CDRef.NumeroPiece, CDRef, 'TV');
end;

{***********A.G.L.***********************************************
Auteur  ...... : Thierry Petetin
Créé le ...... : 22/05/2003
Description .. : Vérifie si on peut changer l'article lors de la saisie d'une pièce
  Dans tous les cas (Création, modification, Transformation de pièce)
    La ligne ne doit pas être issue d'une ligne précédente
  En transformation :
    La pièce d'origine ne doit pas gérer d'historique et la pièce de destination ne doit pas gérer les reliquats
  En modification :
    La ligne ne doit pas être issue d'une ligne précédente ni avoir de ligne suivante
*****************************************************************}

function TFFacture.CanChangeArticle(TobL: Tob): Boolean;
begin
  Result := True;
  if Assigned(Tobl) then
  begin
    if TransfoPiece then { Transformation d'une pièce en cours }
    begin
      if WithPiecePrecedente(Tobl) then
        Result := (not HistoPiece(TobPiece_O)) and (not GppReliquat);
    end
    else if (Action = taModif) and (not DuplicPiece) then { Modification d'une pièce }
      Result := (not WithPiecePrecedente(Tobl)) and (not WithPieceSuivante(TobL));
  end;
end;

initialization
  InitFacGescom();

end.
