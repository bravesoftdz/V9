
unit Facture;

interface                                                                                                    

uses {$IFDEF VER150} variants,{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Hctrls, ExtCtrls, HTB97, StdCtrls, HPanel, UIUtil, Hent1, Menus,
  HSysMenu, Mask, Buttons, HStatus, hmsgbox, UTOF, UtilPGI,
  Hqry, UTOB, HFLabel, Ent1, SaisUtil, LookUp, Math, EntGC, FactSpec,
  FactCalc, FactFormule, UtilFonctionCalcul, FactPiece, FactTOB, FactArticle, FactTiers, FactAdresse,
  FactLotSerie, FactContreM,UTobDebug,
  StockUtil, M3FP, utilarticle, TarifUtil, TiersUtil, Doc_Parser, FileCtrl,ed_tools,
  // Modif BTP
  factrg,
  FGestAffDet,
  FPrixMarche,
  NomenUtil,
  {$IFDEF NOMADE}uToxClasses, {$ENDIF}
  {$IFDEF BTP}
  UTofBTAnalDev,
  BTPUtil,
  FactOuvrage,
  SimulRenTabDoc,
  FactMinute,
  UplannifchUtil,
  UtilMetres,
  FactureBtp,
  UTOF_BTSAISDOCEXT,
  UtilPhases,
  CalcOleGenericBTP,
  FactEmplacementLivr,
  FactRgpBesoin,
  AppelsUtil,
  UtilBlocage,
  {$ENDIF}
  FactVariante,
	FactBordereauMenu,
  CopierCollerUtil,
  {$IFDEF EAGLCLIENT}
  maineagl,uHTTp,
  {$ELSE}
  DBCtrls, Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} fe_main, UserChg, AglIsoflex,
  {$ENDIF}
  UtilTOBPiece,
  AglInit, FactComm, FactCpta,
  AdressePiece, Clipbrd,
  {$IFDEF AFFAIRE}
  ConfidentAffaire, FactActivite, AffaireUtil,
  FactAffaire, UtofAFRevision,
  {$ENDIF}
  ComCtrls, HRichEdt, HRichOLE,
{$IFDEF EAGLCLIENT}
  {$IFNDEF SANSCOMPTA}
  Devise_tom, CPCHANCELL_TOF,
  {$ENDIF}
{$ELSE}
  {$IFNDEF SANSCOMPTA}
  Devise, Chancel,
  {$ENDIF}
{$ENDIF}
  FactNomen, SaisComm, VentAna,
  UtofCegidPCI,
  UTofCegidLibreTiersCom,
  GcComplPrix_tof,
  UTofPiedPort, Choix,
  {$IFNDEF CCS3}
  SaisieSerie_TOF,
  {$ENDIF}
  {$IFDEF MODE}
  FactCodeBarre,
  {$ENDIF}
  DimUtil, LigDispoLot, UTofGCPieceArtLie, ShellAPI, FactUtil, UTofSaisieAvanc, UtilFO,
  GCControleFacture_Tof,
  ImgList,
  {$IFDEF CHR}
  FactChr,
  {$ENDIF} // FIN CHR
  DepotUtil,utilgrp // DBR : Depot unique charg�
  ,UtilGC // JT - eQualit� 10819
  {$IFDEF BTP}
  (* OPTIMZATION *)
  ,BTFactImprTOB,FactLivrFromRecep
  ,OptimizeOuv,FactAdresseBTP
  ,FactTvaMilliem,BTREPARTTVA_TOF,FactBordereau
  ,UtilReglementAffaire
  ,UtilDuplicBordereaux
  ,FactGestParag,gestRemplarticle
  ,BTFACTTEXTES
  ,BTAPPLICDETAILOUV_TOF
  ,PiecesRecalculs
  ,BTRECALCPIECEUNI
  ,splash,FactLigneBase, HImgList,BTStructChampSup
  ,BTINFOLIVRAISONS_TOF
  (* ----------- *)
  ,FactDomaines
  {$ENDIF}
  ,uEntCommun, TntStdCtrls, UCotraitance, FactDetOuvrage, FactTimbres
  ;
type
	TmsFrais = (TmsFValide,TmsFAnul,TmsSuppr,TmsNone); // les 3 seuls mode de gestion
//  TmInsert = (TmiUp,TmiDown);

function CreerPiece(NaturePiece: string ; BoucleCreat : boolean = false): boolean;
function CreerPieceGRC(NaturePiece, LeCodeTiers: string; NoPersp: integer): boolean;
procedure AppelPiece(Parms: array of variant; nb: integer);
function SaisiePiece(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string = ''; Laffaire: string = ''; Lavenant: string = ''; SaisieAvanc: boolean =
  false; OrigineEXCEL: boolean = false ; BoucleCreat : boolean = false; ModeGestionAchat : boolean=false; SaisieBordereau : boolean=false; TheStatutAffaire : String = 'A'): boolean;
//Function SaisiePiece ( CleDoc : R_CleDoc ; Action : TActionFiche ; LeCodeTiers : String = '';Laffaire:string='';Lavenant:string='';SaisieAvanc: boolean =false ) : boolean ;
procedure AppelTransformePiece(Parms: array of variant; nb: integer);
function TransformePiece(CleDoc: R_CleDoc; NewNat: string; SaisieAveug: Boolean = False): boolean; //Saisie Aveugle
procedure AppelDupliquePiece(Parms: array of variant; nb: integer);
function DupliquePiece(CleDoc: R_CleDoc; NewNat: string): boolean;
function DupliqueBordereauBTP(CleDoc: R_CleDoc; NewTiers: string;NewAffaire,Libelle:String;Debut,Fin : string): boolean;
function PieceEnPA (Naturepiece : string): boolean;
function SaisiePieceFrais(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string ; Laffaire: string ): TmsFrais;

type R_IdentCol = record
    ColName, ColTyp: string;
  end;

type R_Col = record
    SG_NL: integer;
    SG_ContreM: integer;
    SG_RefArt: integer;
    SG_Lib: integer;
    SG_QF : integer;
    SG_QS: integer;
    SG_Px: integer;
    SG_Rem: integer;
    SG_Aff: integer;
    SG_Rep: integer;
    SG_Dep: integer;
    SG_RV: integer;
    SG_RL: integer;
    SG_Unit : integer;
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
    SG_CIRCUIT: integer;
    SG_PxAch: integer;
    SG_MontantAch: integer;
		SG_TYPA : integer;
{$IFDEF BTP}
		SG_REFTiers : integer;
    SG_DETAILBORD : integer;
    SG_DEJAFACT : integer;
    SG_QTEPREVUE : integer;
    SG_QTESITUATION : integer;
    SG_POURCENTAVANC : integer;
    SG_TEMPS : integer;
    SG_TEMPSTOT : integer;
    SG_QUALIFTEMPS : integer;
// Correction LS Sur erreur adresse memeoire 000000
//    TheMetre: TStockMetre;
//  	IMPRESSIONTOB : TImprPieceViaTOB;
//    TheGestParag : TGestParagraphe;
//    ThegestRemplArticle : Tgestremplarticle;
{$ENDIF}
		SG_MontantSit : integer;
    SG_MontantMarche : integer;
    SG_MTDEJAFACT : integer;
    SG_CODTVA1 : integer;
    SG_NATURETRAVAIL : integer;
    SG_VOIRDETAIL : integer;
    SG_FOURNISSEUR : integer;
  end;

const StColNameGSA = 'CB;LIBELLE;QTE;';
      NbArtParRequete: integer = 200;
type
  TFFacture = class(TForm)
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
    FindLigne: TFindDialog;
    GP_DEVISE: THValComboBox;
    GP_REPRESENTANT: THCritMaskEdit;
    GP_NUMEROPIECE: THPanel;
    LIBELLETIERS: THPanel;
    HGP_ETABLISSEMENT: THLabel;
    GP_ETABLISSEMENT: THValComboBox;
    HTitres: THMsgBox;
    BZoomArticle: THBitBtn;
    BZoomTiers: THBitBtn;
    BZoomTarif: THBitBtn;
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
    BZoomCommercial: THBitBtn;
    N1: TMenuItem;
    N2: TMenuItem;
    MBtarif: TMenuItem;
    MBTarifGroupe: TMenuItem;
    BZoomPrecedente: THBitBtn;
    BZoomOrigine: THBitBtn;
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
    BZoomAffaire: THBitBtn;
    BZoomSuivante: THBitBtn;
    BZoomEcriture: THBitBtn;
    BDevise: TToolbarButton97;
    PopD: TPopupMenu;
    ISigneEuro: TImage;
    PopL: TPopupMenu;
    TInsLigne: TMenuItem;
    TSupLigne: TMenuItem;
    TCommentEnt: TMenuItem;
    TCommentPied: TMenuItem;
    HErr: THMsgBox;
    POPD_S1: TMenuItem;
    POPD_S2: TMenuItem;
    POPD_S3: TMenuItem;
    GP_SAISIECONTRE: TCheckBox;
    GP_FACTUREHT: TCheckBox;
    GP_REGIMETAXE: THValComboBox;
    BDevise__: TToolbarButton97;
    ISigneEuro__: TImage;
    LDevise: THPanel;
    LDevise__: THPanel;
    N3: TMenuItem;
    MBDetailNomen: TMenuItem;
    BZoomDevise: THBitBtn;
    GP_AVENANT__: THCritMaskEdit;
    BRazAffaire: TToolbarButton97;
    GP_AFFAIRE0__: THCritMaskEdit;
    GP_DATELIVRAISON: THCritMaskEdit;
    HGP_DATELIVRAISON: THLabel;
    MBDatesLivr: TMenuItem;
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
    N4: TMenuItem;
    PlanningLigne: TMenuItem;
    PlanningEntete: TMenuItem;
    EuroPivot__: TEdit;
    LibComplAffaire: THLabel;
    HGP_DOMAINE__: THLabel;
    GP_DOMAINE__: THValComboBox;
    MBSoldeTousReliquat: TMenuItem;
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
    MBAnal: TMenuItem;
    MBAnalDoc: TMenuItem;
    MBAnalLoc: TMenuItem;
    MBModeVisu: TMenuItem;
    BTypeArticle: TToolbarButton97;
    BZoomStock: THBitBtn;
    BZoomDispo: THBitBtn;
    TTVParag: TToolWindow97;
    TVParag: TTreeView;
    TInsParag: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    GP_HRDOSSIER: THCritMaskEdit;
    PopA: TPopupMenu;
    Pourlaligne: TMenuItem;
    Pourledocument: TMenuItem;
    MBDetailLot: TMenuItem;
    HTotaux: THPanel;
    SommeQTE: THNumEdit;
    TFusionner: TMenuItem;
    N8: TMenuItem;
    Fraisdetail: TMenuItem;
    Simulationderentabilit1: TMenuItem;
    SRDocGlobal: TMenuItem;
    SRDocParag: TMenuItem;
    MBTarifVisuOrigine: TMenuItem;
//  MBCommissionVisuOrigine: TMenuItem;
    N9: TMenuItem;
    BtTPI: TToolbarButton97;
    BZoomPiece: THBitBtn;
    PopOuvrage: TPopupMenu;
    DetailOuvrage: TMenuItem;
    SousDetailAff: TMenuItem;
    ImTypeArticle: THImageList;
    BZoomTache: THBitBtn;
    MBCtrlFact: TMenuItem;
    BZoomRevision: THBitBtn;
    GP_REFEXTERNE: TEdit;
    GP_DATEREFEXTERNE: THCritMaskEdit;
    BZoomProposition: THBitBtn;
    Complmentvariables1: TMenuItem;
    NSEPARATEUR: TMenuItem;
    VoirFranc: TMenuItem;
    HGP_DATELIVRAISON__: THLabel;
    GP_DATELIVRAISON__: THCritMaskEdit;
    GP_REFEXTERNE__: TEdit;
    Modebordereau: TMenuItem;
    SepTva1000: TMenuItem;
    MBREPARTTVA: TMenuItem;
    GS: THGrid;
    Descriptif1: THRichEditOLE;
    PPiedAvanc: TPanel;
    PPSITTOT: TPanel;
    HLabel1: THLabel;
    MONTANTSIT: THNumEdit;
    WAIT: TToolWindow97;
    Label1: TLabel;
    Animate1: TAnimate;
    Label2: TLabel;
    MnVisaPiece: TMenuItem;
    ODExcelFile: TOpenDialog;
    BPOPYCOTRAITSEP: TMenuItem;
    BCOTRAITTABLEAU: TMenuItem;
    HGP_REFEXTERNE__: THLabel;
    HGP_REFEXTERNE: THLabel;
    ImgListPlusMoins: THImageList;
    BOuvrirFermer: TToolbarButton97;
    PopInsertLig: TPopupMenu;
    MnInsSousDet: TMenuItem;
    MnInsLigStd: TMenuItem;
    PGlobPied: TPanel;
    PPied: THPanel;
    HGP_ESCOMPTE: THLabel;
    HGP_MODEREGLE: TFlashingLabel;
    HGP_REMISEPIED: THLabel;
    LLIBRG: TFlashingLabel;
    LMontantRg: TFlashingLabel;
    BLanceCalc: TToolbarButton97;
    GP_MODEREGLE: THValComboBox;
    PTotaux1: THPanel;
    HGP_TOTALTTCDEV: THLabel;
    HGP_ACOMPTEDEV: THLabel;
    LGP_ACOMPTEDEV: THLabel;
    LGP_TOTALTTCDEV: THLabel;
    HGP_TOTALTAXESDEV: THLabel;
    LTOTALTAXESDEV: THLabel;
    LNETAPAYERDEV: THLabel;
    HGP_NETAPAYERDEV: THLabel;
    LHTTCDEV: THLabel;
    LCAUTION: TFlashingLabel;
    PTotaux: THPanel;
    HGP_TOTALHTDEV: THLabel;
    LGP_TOTALHTDEV: THLabel;
    LGP_TOTALREMISEDEV: THLabel;
    HGP_TOTALREMISEDEV: THLabel;
    HGP_TOTALPORTSDEV: THLabel;
    LTOTALPORTSDEV: THLabel;
    HGP_TOTALESCDEV: THLabel;
    LGP_TOTALESCDEV: THLabel;
    HGP_TOTALRGDEV: THLabel;
    LTOTALRGDEV: THLabel;
    GP_ESCOMPTE: THNumEdit;
    GP_REMISEPIED: THNumEdit;
    INFOSLIGNE: THGrid;
    GP_TOTALHTDEV: THNumEdit;
    GP_TOTALREMISEDEV: THNumEdit;
    HTOTALTAXESDEV: THNumEdit;
    GP_TOTALESCDEV: THNumEdit;
    GP_TOTALTTCDEV: THNumEdit;
    GP_ACOMPTEDEV: THNumEdit;
    TOTALPORTSDEV: THNumEdit;
    NETAPAYERDEV: THNumEdit;
    TOTALRGDEV: THNumEdit;
    HTTCDEV: THNumEdit;
    TTYPERG: TEdit;
    TCaution: TEdit;
    PButtons: TPanel;
    DockBottom: TDock97;
    Outils97: TToolbar97;
    BMenuZoom: TToolbarButton97;
    BEche: TToolbarButton97;
    BInfos: TToolbarButton97;
    BChercher: TToolbarButton97;
    BSousTotal: TToolbarButton97;
    BAcompte: TToolbarButton97;
    BActionsLignes: TToolbarButton97;
    Sep1: TToolbarSep97;
    Sep2: TToolbarSep97;
    BOffice: TToolbarButton97;
    BVentil: TToolbarButton97;
    BDescriptif: TToolbarButton97;
    BDelete: TToolbarButton97;
    BImprimer: TToolbarButton97;
    BPorcs: TToolbarButton97;
    BSaisieAveugle: TToolbarButton97;
    BNouvelArticle: TToolbarButton97;
    BRetenuGar: TToolbarButton97;
    BPrixMarche: TToolbarButton97;
    BArborescence: TToolbarButton97;
    BtQteAuto: TToolbarButton97;
    Bminute: TToolbarButton97;
    RecalculeDocument: TToolbarButton97;
    BCalculDocAuto: TToolbarButton97;
    BintegreExcel: TToolbarButton97;
    BMinute2: TToolbarButton97;
    Valide97: TToolbar97;
    BValider: TToolbarButton97;
    BAbandon: TToolbarButton97;
    BAide: TToolbarButton97;
    HGP_TOTALTIMBRES: THLabel;
    LGP_TOTALTIMBRES: THLabel;
    GP_TOTALTIMBRES: THNumEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BChercherClick(Sender: TObject);
    procedure GSMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GSMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure GSEnter(Sender: TObject); dynamic;
    procedure GSElipsisClick(Sender: TObject);
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
    procedure MBTarifGroupeClick(Sender: TObject);
    procedure MBtarifClick(Sender: TObject);
    procedure BZoomPrecedenteClick(Sender: TObject);
    procedure BZoomOrigineClick(Sender: TObject);
    procedure MBSoldeReliquatClick(Sender: TObject);
    procedure MBSoldeTousReliquatClick(Sender: TObject); //AC Reliquat de toute la pi�ce
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
    procedure BDeleteClick(Sender: TObject); dynamic;
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
    procedure BZoomPropositionClick(Sender: TObject);
    // Modif BTP
    procedure MBAnalDocClick(Sender: TObject);
    procedure MBAnalLocClick(Sender: TObject);
    procedure MBModeVisuClick(Sender: TObject);
    (*
    procedure DebutResizeRequest(Sender: TObject; Rect: TRect);
    procedure FinResizeRequest(Sender: TObject; Rect: TRect);
    *)
    procedure GSExit(Sender: TObject);
    procedure GSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    (*
    procedure DebutEnter(Sender: TObject);
    procedure FinEnter(Sender: TObject);
    *)
    procedure TVParagClick(Sender: TObject);
    procedure Descriptif1Exit(Sender: TObject);
    procedure BTypeArticleClick(Sender: TObject);
    procedure TInsParagClick(Sender: TObject);
    procedure BArborescenceClick(Sender: TObject);
    procedure BPrixMarcheClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TTVParagClose(Sender: TObject);
    (*
    procedure DebutExit(Sender: TObject);
    procedure FinExit(Sender: TObject);
    *)
    procedure Descriptif1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    (*
    procedure DebutKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FinKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    *)
    procedure BRetenuGarClick(Sender: TObject);
    procedure PPiedResize(Sender: TObject);
    procedure PTotauxResize(Sender: TObject);
    procedure PTotaux1Resize(Sender: TObject);
    procedure PourlaligneClick(Sender: TObject); dynamic;
    procedure PourledocumentClick(Sender: TObject); dynamic;
    procedure TFusionnerClick(Sender: TObject);
    // Modif BTP
    {$IFDEF BTP}
    procedure AfficheZonePiedAchat;
    procedure AfficheZonePiedStd ;
  	 procedure TraiteLivrFromRecep;
	 Function GetMontantPvDEv : Double;
    {$ENDIF}
    procedure FraisdetailClick(Sender: TObject);
    procedure SRDocGlobalClick(Sender: TObject);
    procedure SRDocParagClick(Sender: TObject);
    procedure DescriptifKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SLigneClick(Sender: TObject);
    procedure SPieceClick(Sender: TObject);
    procedure BtTPIClick(Sender: TObject);
    procedure GSSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure BZoomPieceClick(Sender: TObject);
    procedure GP_REFINTERNEExit(Sender: TObject);
    procedure GP_REFEXTERNEExit(Sender: TObject);
    // Modif BTP
    procedure DetailOuvrageClick(Sender: TObject);
    procedure SousDetailAffClick(Sender: TObject);
    procedure BminuteClick(Sender: TObject);
    procedure Bminute2Click(Sender: TObject);
    // Modif BTP (deplac�e pour la gestion du copier coller)
    procedure AfficheLaLigne(ARow: integer);
    procedure CalculeLaSaisie(ACol, ARow: integer; AffTout: boolean; WithFrais : boolean=true; LigDepart : integer = -1; LigFin : integer = -1);
    procedure PosValueCell(valeur: string);
    procedure TraiteLaCompta(ARow: integer);
    procedure BZoomTacheClick(Sender: TObject);
    procedure SGEDLigneClick(Sender: TObject);
    procedure MBCtrlFactClick(Sender: TObject);
    procedure BZoomRevisionClick(Sender: TObject);
    // ----
    procedure MBTarifVisuOrigineClick(Sender: TObject);
    procedure FTitrePieceClick(Sender: TObject);
    procedure Complmentvariables1Click(Sender: TObject);
    procedure VoirFrancClick(Sender: TObject);
    (*
    procedure FinKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DebutKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    *)
//  procedure MBCommissionVisuOrigineClick(Sender: TObject);
	 procedure LoadLesGCS;
    procedure ModebordereauClick(Sender: TObject);
    procedure MBREPARTTVAClick(Sender: TObject);
    procedure RecalculeDocumentClick(Sender: TObject);
    procedure BCalculDocAutoClick(Sender: TObject);
    procedure GSTopLeftChanged(Sender: TObject);

    procedure BintegreExcelClick(Sender: TObject);
    function isEcritureBOP (TOBPiece : TOB) : boolean;
    procedure MnVisaPieceClick(Sender: TObject);
    procedure BOuvrirFermerClick(Sender: TObject);
    procedure DemandeModeInsert;
    procedure MnInsSousDetClick(Sender: TObject);
    procedure MnInsLigStdClick(Sender: TObject);

  private
  	TOBOLDL : TOB;
  	fPieceCoTrait : TPieceCotrait;
    fModifSousDetail : TModifSousDetail;
  	DomaineSoc : string;
    // Modif BTP
    //
    NumeroGUID: String;
    //
    ReceptionModifie : boolean;
    SelInfoRupture : boolean;
    TypeFacturation : string;
    // OPTIMISATIONS LS
    FactReCalculPv : boolean;
    ForceEcriture : boolean;
    ReinitFg : boolean;
    PieceControleModifie : boolean;
    //Modif FV pour gestion type Affaire (A,I,W)...
    StatutAffaire : String;
    //
//    NbLignesGrille: integer;
//    SBPosition: integer;
    NumGraph: integer;
    GestionRetenue, ApplicRetenue: boolean;
    CopierColler: TCopieColleDoc;
    ModifieVariables : Boolean;
    // VARIANTE
    TheListPiecePrec : TOB;
    TheVariante : TVariante;
{$IFDEF BTP}
    TheApplicDetOuv : TApplicDetOuv;
    TheBordereauMen : TFactBordereauMenu;
    TheBordereau : TUseBordereau;
    TheMetre: TStockMetre;
{$ENDIF}
    TOBLigneDel,TOBLBasesDEL,TOBCONSODEL : TOB;
    // --
    {$IFDEF BTP}
		TheRgpBesoin : TFactRgpBesoin;
    TheRepartTva : TREPARTTVAMILL;
    // OPTIMISATION BTP   (LS)
    TOBTablette : TOB;
    LastErrorAffaire : integer;
    // ----
    GestionConso : TGestionPhase;
    TheDestinationLiv : TDestinationLivraison;
    TheLivFromRecepStock : TLivraisonFromRecepStock;
		MultiSel_SilentMode : Boolean;
    function  Multicompteur (Naturepiece : string) : boolean;
    procedure Insere_SDP;
    {$ENDIF}
    function CalculMargeLigne(ARow: integer): double;
    procedure AppliquePrixMarche(NewMontant: double; MtbloqueHtdev,MtbloqueTTCDev: double; TOBPOurcent: TOB;
      RecupPourcent: boolean; ModeGestion, IndDepart, IndFin,
      EtenduApplication: integer);
    procedure AttribueEcartMarche(NewMontant: double; TOBPOurcent: TOB;
      IndDepart, IndFin, EtenduApplication: integer;AvecArtEcart : boolean=true; EnPr : boolean=false);
    procedure LoadLesTextes;
    procedure PositionneTextes;
    procedure RemplitLiens(TOBPiece, TOBLIens: TOB; Texte: THRichEditOLE; Rang: integer);
    function GetLibParag(TOBL: TOB): string;
    procedure Affiche_TVParag;
    procedure PersonnalisationBtp;
    procedure DefiniPied;
    procedure SetTaillePied (Taille : integer);
    procedure InitPositionZones;
    procedure DefinitionGrille;
    procedure DefinitionTaillePied;
    procedure GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG: TOB);
    procedure SaisieAvancement;
    procedure InitContexteGrid;
    // --
    procedure AppliquePourcentAvanc(TOBPiece: TOB; Pourcent: double; IndDepart, IndFin, ModeApplic: integer; Dev: Rdevise);
    function CanChangeArticle(Tobl: Tob): Boolean;
    function IsChpsObligOk(PieceOuLigne, NumLigne : integer) : boolean; // JT - eQualit� 10819
	 procedure SetLigTobDelete (NumLig : integer);
{$IFDEF BTP}
    procedure AjouteMontantPVDevis (TOBL : TOB);
    Procedure TraitementMajEcheance(TobPiece, TobAffaire : TOB);
{$ENDIF}
 	 procedure DefinieRefInterneExterne(NewNature : string);
   procedure NettoieBudget;
   procedure ChangeQteSituation (Acol,Arow : integer);
   procedure ChangePourcentAvancSituation (Acol,Arow : integer);
   procedure ChangeMontantSituation(ACol, ARow : integer);
   procedure CalculeAvancementLigne (TOBL : TOB);
    procedure DefiniModeCalcul;
   procedure CalculeLaLigneAV (TOBL : TOB);
   procedure ResetCells (Acol,Arow : integer);
    procedure EnregistreLigneSupprime (TOBL : TOB);
    procedure DeduitLesLignesSupprimes;
		function Isaffectable (Ecart,Pu : double) : boolean;
	 function IsEcritLesOuvPlat : boolean;
   procedure ChangeTempsPose (Acol,Arow : integer);
   procedure ChangeTempsPoseTOT (Acol,Arow : integer);
	function PositionneRecalculePourcent (Arow : integer) : integer;
  procedure Selectionne (DepartSel,FinSel : integer);
	procedure PositionneDebutFinSel (var debut,fin : integer; SensInverse : boolean=false);

  protected
    GereStatPiece, AvoirDejaInverse: boolean;
    GX, GY: Integer;
    RCol: R_Col;
    WMinX, WMinY: Integer;
    NbTransact: integer;
    FindFirst, ForcerFerme, ReliquatTransfo, GereReliquat, GeneCharge, OkCpta,
      OkCptaStock, NeedVisa, GereLot, GereAcompte, GereSerie, CommentLigne, ForceRupt,
      EstAvoir, QuestionRisque, SansRisque, DejaRentre, ValideEnCours, CataFourn,
      TotEnListe, OuvreAutoPort, PasToucheDepot, AutoCodeAff, PasBouclerCreat, FClosing,
      GereActivite, GereContreM, DelActivite, ObligeRegle, ChangeComplEntete,
      ForcerLaModif: boolean; { NEWPIECE }
    CompAnalP, CompAnalL, CompStockP, CompStockL, GereEche,
      CommentEnt, CommentPied, CalcRupt, CliCur, VenteAchat, DimSaisie,
      TypeCom, OldRepresentant: string;
    MontantVisa, RisqueTiers, OldHT: Double;
    LeAcompte: T_GCAcompte;
    ANCIEN_TOBDimDetailCount: integer; // Sauvegarde du nb initial de dimensions
    NewLigneDim: Boolean; //AC, nouvelle ligne pour gestion d'un art GEN existant
    Col_CB, Col_Lib, Col_Qte: Integer; //Saisie Aveugle
    TOBGSA: TOB; //Saisie Aveugle
    OuiPourTousNewArt, NonPourTousNewArt, OuiPourTousQteSup, NonPourTousQteSup: boolean; //Saisie Aveugle
    BAffecteTous, SaisieCodeBarreAvecFenetre: Boolean;
    // Objets m�moire
    TOBPiece, TOBEches, TOBBases, TOBTiers, TOBArticles, TOBTarif, TOBAdresses, TOBConds, TOBComms,
    TOBBasesSaisies,TOBBasesL,TOBOuvragesP,TOBmetres,
    TOBCpta, TOBAnaP, TOBAnaS, TOBPorcs, TOBDesLots, TOBSerie, TOBSerRel: TOB;
    TOBPiece_O, TOBBases_O, TOBAdresses_O, TOBEches_O, TOBCXV, TOBAffaire, TOBNomenclature, TOBN_O: TOB;
    TOBPiece_OO: Tob; { TobPiece avec toutes les lignes }
    TOBPiece_OS: TOB; // TOBPiece_O limit�e aux champs GL_ARTICLE, GL_QTEFACT tri�e par GL_ARTICLE
    // But : obtenir le cumul qt� par GL_ARTICLE
    TOBDim, TOBSerie_O, TOBLOT_O, TOBAcomptes, TOBAcomptes_O, TOBPorcs_O: TOB;
    TOBCatalogu, TOBDispoContreM: TOB;
    TobLigneTarif, TobLigneTarif_O: Tob; { Pour m�moriser le d�tail du syst�me tarifaire }
    TOBAFormule,TOBLigFormule,TOBLigFormule_O : TOB ;
    TOBFormuleVar,TOBFormuleVarQte,TOBFormuleVarQte_O : TOB; //Affaire-formule des variables
    // MODIF BTP
    PresentSousDetail: integer;
    ModifSousDetail : boolean;
    TOBOUvrage, TOBOuvrage_O: TOB;
    TOBLIENOLE, TOBLIENOLE_O: TOB;
    TOBPIECERG, TOBPIECERG_O: TOB;
    TOBBASESRG, TOBBASESRG_O: TOB;
    TOBLigneRG: TOB;
    TOBImp: TOB;
    TOBPieceTrait : TOB;
    TOBAffaireInterv : TOB;
    TOBTimbres : TOB;
    {$IFDEF BTP}
    TOBLienDEVCHA: TOB;
    ATraiterQte: boolean;
    {$ENDIF}
{$IFDEF NOMADE}
		VariableSite: TCollectionVariable;
  {$ENDIF}
    IndiceOuv: integer;
    bAppelControleFacture : boolean;
    // --
    {$IFDEF CHR}
    TobHRDossier, Tobregrpe: TOB;
    Supp_Commentaire: boolean;
    {$ENDIF} // FIN CHR
// Dimensionnement
    procedure WMGetMinMaxInfo(var MSG: Tmessage); message WM_GetMinMaxInfo;
    // Actions li�es au Grid
    procedure ZoneSuivanteOuOk(var ACol, ARow: Longint; var Cancel: boolean);
    function ZoneAccessible(ACol, ARow: Longint): boolean;
    procedure FormateZoneSaisie(ACol, ARow: Longint);
    function FormateZoneDivers(St: string; ACol: Longint): string;
    function GereElipsis(LaCol: integer;Var FromBordereau : boolean): boolean;
    // Initialisations
    procedure ErgoGCS3;
    procedure InitToutModif (Datemaj : TdateTime = 0);
    procedure BloquePiece(ActionSaisie: TActionFiche; Bloc: boolean);
    procedure BlocageSaisie(Bloc: boolean);
    procedure InitEnteteDefaut(Totale: boolean);
    procedure InitPieceCreation; dynamic;
    procedure LoadLesTOB;
    procedure GereVivante;
    procedure EtudieReliquat;
    procedure ChargelaPiece(GestionAffichage: boolean = True; ElimineLigneSoldee: boolean = True);
    procedure InitEuro;
    procedure InitRIB;
    function FromAvoir: boolean;
    procedure ToutAllouer;
    procedure ToutLiberer;
    procedure ReInitPiece; dynamic;
    procedure AppliqueTransfoDuplic(GestionAffichage: boolean = True); dynamic;
    procedure ChargeFromNature;
    procedure ModifiableLeMemeJour;
    // Calculs, Euro
    procedure AfficheEuro;
    procedure MontreEuroPivot(Montrer: boolean);
    procedure RempliPopY;
    procedure RempliPopD;
    procedure ChoixEuro(Sender: TObject);
    procedure AfficheTaxes;
    procedure PositionneVisa;
    procedure PositionneEuroGescom;
    procedure ZoomOuChoixLib(ACol, ARow: integer);
    procedure AnalyseDollar(ARow: integer);
    procedure ZoomOuChoixDateLiv(ACol, ARow: integer);
    // Affichages
    procedure ZoomOuChoixArt(ACol, ARow: integer);
    procedure EnabledPied;
    procedure EnabledGrid;
    procedure TraiteTiersParam;
    procedure TraiteAffaireParam;
    procedure GereTiersEnabled; dynamic;
    procedure GereArticleEnabled;
    procedure GereCommercialEnabled;
    procedure GereAffaireEnabled;
    procedure GetCellCanvas(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure PostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure GotoEntete;
    procedure GotoGrid(PageDown, FromF10: boolean);
    procedure GotoPied;
    procedure FlagRepres;
    procedure FlagDomaine;
    procedure FlagDepot;
    procedure FlagEEXandSEX;
    procedure CegidModifPCI(ARow: integer);
    procedure CEGIDLibreTiersCom;
    procedure ModifPrixAchat(ARow: integer);
    procedure FlagContreM;
    // TOBS lignes
    procedure OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; var Value: variant);
    function FabricNomWord: string;
    // LIGNES
    function InitLaLigne(ARow: integer; NewQte: double; CalcTarif: boolean = True): T_ActionTarifArt;
    procedure AfficheLigneDimGen(TOBL: TOB; ARow: integer);
    procedure InsertComment(Ent: Boolean);
    procedure RecalculeSousTotaux(TOBPiece: TOB; GestionAffichage: Boolean = True);
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
    procedure NeRestePasSurDim(ARow : integer);
    // AC - Correction fiche mode 10684
    procedure SupprimeDim(Arow: integer) ;
    procedure AffichageDim(MajLigne: integer = 0);
    // Gestion du solde de reliquat pour les articles dimensionn�s (mode)
    procedure SoldeReliquatArtDim(TOBL: Tob; ARow: integer);
    procedure SoldeLigneArtDim(TOBL: Tob; ARow: integer);
    // MODE
    procedure IncidenceMode;
    // ARTICLES
    procedure TraiteLesLies(ARow: integer);
    Procedure TraiteFormuleQte(ARow : integer) ;
    Procedure RappelFormuleQte(ARow : integer) ;
    procedure TraiteLesCons(ARow: integer);
    procedure TraiteLesNomens(ARow: integer);
    // Modif BTP
    function TraiteLesOuv(ARow: integer ; WithDetails : boolean=true ; TOBLigneBord : TOB=nil): boolean;
    // -----
    procedure TraiteLesMacros(ARow: integer);
    {$IFDEF CHR}
    procedure TraiteLesMacrosChr(Arow:integer);
    {$ENDIF} // FIN CHR
    function IdentifierArticle(var ACol, ARow: integer; var Cancel: boolean; Click, FromMacro: Boolean): boolean;
    procedure TraiteArticle(var ACol, ARow: integer; var Cancel: boolean; FromMacro, CalcTarif: boolean; NewQte: double);
    {$IFDEF BTP}
		procedure VerifRefTiers (var Acol,Arow : integer; var Cancel : boolean);
    {$ENDIF}
    {$IFDEF GPAO}
    procedure TraiteCircuit(var ACol, ARow: integer; var Cancel: boolean);
    function RechLeBonCircuit(var ACol, ARow: integer): string;
    function ControleCellModifSt(IdentifiantWOL: integer): boolean;
    {$ENDIF GPAO}
    function PlusEnStock(TOBArt: TOB): boolean;
    procedure ChargeTOBDispo(ARow: integer);
    //procedure LoadLesArticles ;
    procedure LoadLesArticles(GestionAffichage: boolean = True);
    procedure ConstruireTobArt(TOBPiece: Tob);
    { D�palc� en public
    procedure ChargeNouveauDepot(TOBPiece, TobLigne: Tob; stNouveauDepot: string); // DBR : Depot unique charg�
    }
    procedure LoadTOBCond(RefUnique: string);
		procedure InsertArticleLies(Arow : integer;TOBref : TOB; LesRefsLies : string; NbrInsert : integer);
    procedure GereArtsLies(ARow: integer);
    procedure GereLesLots(ARow: integer);
    procedure DetruitLot(ARow: integer);
    procedure GereLesSeries(ARow: integer);
    procedure TraiteLeCata(ARow: integer);
    //  CATALOGUE / CONTREMARQUE
    procedure UpdateCataLigne(ARow: longint; FromMacro, Calc: boolean; NewQte: double);
    procedure LigneEnContreM(var ACol, ARow: integer; var Cancel: boolean);
    function ArticleUniqueDansCatalogue(RefUnique, RefFour: string): TOB;
    // QUANTITES / TARIFS / DIVERS
    function TraiteRupture(ARow: integer; Bparle : boolean=true): boolean;
    function TraiteQte(ACol, ARow: integer; BParle : boolean=true): boolean; dynamic;
    procedure DetruitLigneTarif(ARow: integer);
    // Modif BTP
    function TraiteAvanc(ACol, ARow: integer): Boolean;
    // ----
    procedure TraiteLibelle(ARow: integer);
    procedure TraitePrix(ARow: integer;prixRef : double=0);
    procedure TraitePrixAch(ARow: integer);
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
		procedure EnleveRefPieceprec(TOBPiece : TOB);
    procedure PositionErreurCodeAffaire(Sender: TObject; NbAff: integer);
    procedure ZoomOuChoixAffaire(ACol, ARow: integer);
    procedure ZoomUnite (Acol,Arow : integer);
		procedure VerifUnite (Acol,Arow : integer ; var cancel : boolean);
    procedure TraiteAffaire(ACol, ARow: integer; var Cancel: boolean);
    {$IFDEF AFFAIRE}
    function TraiteFormuleVar(ARow: integer; pStAction: string): Boolean; //Affaire-Formule des variables
    {$ENDIF}
    // Gestion du descriptif d�taill�
    procedure GereDescriptif(ARow: Integer; Enter: Boolean);
    // Actions, outils
    // AC 07/08/03 Optimisation saisie dimension
    procedure ClickDel(ARow: integer; AvecC, FromUser: boolean; SupDim: boolean = False; TraiteDim: boolean = False; FromParag : boolean=false); dynamic;
    // FIN AC
    // MODIF BTP (DEPLACE)
  	//procedure ClickInsert(ARow: integer);
    // --
    procedure ClickPrecedente;
    procedure ClickSuivante;
    procedure ClickOrigine;
//    procedure SoldeLigneSup(Sup: boolean);
//    procedure DesoldeLigneSup(Sup: boolean);
    procedure SoldeReliquat;
    procedure SoldeTousReliquat;
    procedure SoldeLigne(TOBL: Tob; WithMsg: Boolean);
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
    function  ControleFacture : boolean;
    procedure GereLesReliquats; { NEWPIECE }
    function CreerAnnulation(TOBPieceDel, TOBNomenDel: TOB): boolean;
    function CreerReliquat: boolean;
    // ------
    procedure DetruitLaPiece; dynamic; { NEWPIECE }
    procedure AjouteEvent(NatureP, MessEvent: string; QuelCas: integer);
    // Saisie en aveugle
    procedure InitSaisieAveugle;
    procedure InsertLigneGSAveugle;
    procedure InsertNewArtInGSAveugle(CodeBarre: string; Q: TQuery; TOBArt, TOBFilleSA: TOB; ARow: integer);
    function RetourneLibelleAvecDimensions(RefArtDim: string; TOBArt: TOB): string;
    function InsertNewArtInGS(RefArt, Designation: string; Qte: Double; Therow : integer=-1; TOBLigneBord : TOB = nil) : boolean;
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
    procedure CalculeLeDocument (Arow: integer; OnlyPv : boolean=false);
    procedure AddLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
    procedure SupLesLibdetInParag(TOBPiece: TOB; IndRef: integer);
    procedure BouttonVisible(Arow: integer);
    procedure BouttonInVisible;
    // -----
    procedure MultiSelectionArticle(TobMultiSel : TOB);
{$IFDEF BTP}
    procedure MultiSelectionBordereau(TOBMultiSel : TOB);
{$ENDIF}
		procedure TestprovenanceMultiDev(TOBpiece : TOB);
    procedure RecupCoefMargArticle (TOBL,TOBarticles : TOB);
    procedure MajAppel (TOBpiece : TOB);

  public
  	TOBpieceFraisAnnule : TOB;
  	ModeRetourFrs : TmsFrais;
  	TypeSaisieFrs : boolean;
    IsDejaFacture : boolean;
		FraisChantier : boolean;
		CalculPieceAutorise : boolean;
    SaisieTypeAffaire,bSaisieNatAffaire: boolean;
    SaisieAveugle: boolean; //saisie aveugle
    CleDoc,CleDocAffaire: R_CleDoc;
    NumPieceAnnule: integer;
    Action: TActionFiche;
    NewNature, LeCodeTiers, NatPieceAnnule: string;
    DEV: RDEVISE;
    TransfoPiece, DuplicPiece: boolean;
    GppReliquat: boolean; { NEWPIECE }
    Litige: Boolean;
    // modif BTP
    {$IFDEF BTP}
    BligneModif : Boolean;
    {$ENDIF}
    SaisieTypeAvanc, OrigineEXCEL: boolean;
    // MODIF LS Pour MODIF AVANCEMENET
    ModifAvanc : boolean;
    InValidation : boolean;
    // --
    IdentCols: array[0..19] of R_IdentCol;
    Codeaffaireavenant: string;
    SaContexte: TModeAff;
    Laffaire, Lavenant: string;
    DateDepartBord,DateFinBord : TdateTime;
    DESIGNATIONBord : string;
    ValidationSaisie: Boolean; //MODIFBTP
    lesAcomptes: TOB;
    AcompteObligatoire: boolean;
    FinTravaux: boolean;
    TransfertTEM_TRV : string;
    PieceMajStockPhysique: Boolean;
    PiecePrecMajStockPhysique: Boolean;
    // -- MODIF LS pour factbtp
    PPInfosLigne: TStrings;
    // --
    StCellCur : string;
    LesColonnes : string;
    // gestion en PA
    LesColonnesAch,LesColonnesVte : string;
    //
    TextePosition: integer;
    {$IFDEF BTP}
    GereDocEnAchat: boolean;
    InclusSTinFG,InclusSTinFC : boolean;
    TitreInitial : string;
    TiersChanged : boolean;
    (* OMPTIMIZATION *)
    OptimizeOuv : TOptimizeOuv;
  	IMPRESSIONTOB : TImprPieceViaTOB;
    TheGestParag : TGestParagraphe;
    TheGestRemplArticle : Tgestremplarticle;
    (* -------------- *)
    property DestinationLiv : TDestinationLivraison read TheDestinationLiv write TheDestinationLiv ;
    property Comptabilise : boolean read OKCpta;
    property CopierColleObj : TCopieColleDoc read CopierColler write CopierColler;
    property RAZFg : boolean read ReinitFg write ReinitFG;
    property IsVenteAchat : string read venteachat;
    property TheLigADeleted : integer write SetLigTobDelete;
    property  TheConso: TGestionPhase read GestionConso ;
    Property IsReliquatGere : boolean read gereReliquat;
    Property LeRgpBesoin : TFactRgpBesoin read TheRgpBesoin;
    property LaPieceCourante : TOB read TobPiece;
    property TheAction : TactionFiche read Action;
    property TheTOBTiers : TOB read TOBTiers;
    property TheTOBAffaire : TOB read TOBAffaire;
    property TheTOBArticles : TOB read TOBArticles;
    property TheTOBOuvrage : TOB read TOBOuvrage;
    property TheTOBOuvrageP : TOB read TOBOuvragesP;
    property TheTOBConds : TOB read TOBConds;
    property TheTOBBases : TOB read TOBBases;
    property TheTOBBasesL : TOB read TOBBasesL;
    property TheTOBPorcs : TOB read TOBPorcs;
    property TheTOBPieceRG : TOB read TOBPieceRG;
    property TheTOBbasesRG : TOB read TOBBasesRG;
    property ThePieceTrait : TOB read TOBpieceTrait;
    property ThePieceAffaire : TOB read TOBAffaireInterv;
    property GSgrid : THgrid read GS;
    procedure rafraichitPiedAvanc;
    {$ENDIF}
    procedure EtudieColsListe;
    procedure ChargeNouveauDepot(TOBPiece, TobLigne: Tob; stNouveauDepot: string); // DBR : Depot unique charg�
    // Modif BTP
    procedure SaisiePrixMarche(MontantPr : double = 0);
    procedure SauveColList;
    procedure RestoreColList;
    procedure ClickValide(EnregSeul: Boolean = False); dynamic;
    //procedure ClickValide ;  Dynamic ;
    // ------
    procedure SupLesLibDetail(TOBPiece: TOB);
    procedure ModifRefGC(TOBPiece, TOBAcomptes : TOB); // JT eQualit� 10246
    procedure Deselectionne(Arow: integer);
    procedure nettoieGrid;

    {$IFDEF BTP}

    procedure PositionneTOBOrigine;
    procedure BTPClickDel(ARow: integer);
		procedure SetBloquageTarif(Arow : integer);
    {$ENDIF}
    function PieceModifiee: boolean;
    procedure InitPasModif;
    procedure ChargeTiers;
    procedure UpdateArtLigne(ARow: longint; FromMacro, Calc, CalcTarif: boolean; NewQte: double);
    procedure CodesArtToCodesLigne(TOBArt: TOB; ARow: integer);
    procedure GereEnabled(ARow: integer);
    procedure SuppressionDetailOuvrage(Arow: integer; AvecGestionAffichage: boolean = true; TheTOBL : TOB=nil); overload;
    procedure SuppressionDetailOuvrage(TOBL : TOB); overload;
    procedure AffichageDetailOuvrage(RowReference: Integer);
    procedure SupLigneRgUnique;
    procedure SetPieceMajStockPhysique;
    // deplac�e
  	procedure ClickInsert(ARow: integer; SousDetail : boolean=false; ModeInsert : TmodeInsert= TmiCurrent);
    procedure GoToLigne(var Arow, Acol: integer);
		procedure GereCalculPieceBTP (ReafficheTout : boolean = false);
    procedure ApresInsertionParagraphe;
    procedure AffichageDesDetailOuvrages;
		procedure ActiveEventGrille (Status : boolean);
    procedure AfterCalculeLasaisie (Acol,Arow : integer ; Afftout : boolean ; WithFrais : boolean=true);
    procedure deduitLaLigne (TOBL : TOB);
		procedure AjouteLaLigne (TOBL : TOB);
    procedure InitMontantLigne (TOBL : TOB);
    procedure CacheTotalisations (etat : boolean);
    function ControleLigneToCut (Row : integer; WithBlaBla : boolean=true) : boolean;
		procedure CalculheureTot (TOBL : TOB);
		procedure SetLargeurColonnes;
		function Dessus(Arow : integer) : TOB;
		function Dessous(Arow : integer) : TOB;
    function Courante (Arow : integer) : TOB;
    procedure ShowDetail(ARow: integer); dynamic;
    procedure ReinitPieceForCalc;
  end;

implementation

uses
  ParamSoc,
  ResulSuggestion, // LS suite a possibilit� de modifier les proposition de r�approvisionnement
  UVoirSuiviPiece
  {$IFDEF GPAO}
    ,uOrdreSTType
    ,wRegistry
  {$ENDIF GPAO}
  {$IFDEF GPAOLIGHT}
    ,wOrdreCMP
  {$ENDIF GPAOLIGHT}
  ,{wTobDebug_tof,} Tarifs
  {$IFDEF EDI}
    ,EDITiers
    ,EDITransfert
  {$ENDIF EDI}
  {$IFDEF MODE} ,Transfert {$ENDIF}
  {$IFDEF BTP}
  ,factgrp
  {$ENDIF}
  ,FactTarifs
  ,wCommuns
	,AppelMouvStkEx
  ,UImportLigneExcelFac
  ,BTSAISIEPAGEMETRE_TOF
  ,BTMinuteDEV_TOF
  ,LigNomen
  , TntGrids, Types;

{$R *.DFM}


{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Appel d'une saisie Gescom en cr�ation
Mots clefs ... : PIECE;SAISIE;CREATION;
*****************************************************************}

function CreerPiece(NaturePiece: string ; BoucleCreat : boolean = false): boolean;
var CleDoc: R_CleDoc;
		EnAchat : boolean;
begin
  Result := True;
  EnAchat := false;
  if not JaiLeDroitNatureGCCreat(NaturePiece) then
  begin
    PGIInfo(TraduireMemoire('Vous ne pouvez pas cr�er de pi�ce de ce type.'),
      GetInfoParPiece(NaturePiece, 'GPP_LIBELLE'));
    Result := False;
    exit;
  end;
  if PasCreerDateGC(V_PGI.DateEntree) then Exit;
  if (ctxscot in V_PGI.PGIContexte) and (V_PGI.DateEntree <= GetParamSoc('So_AFDATEDEBUTACT')) then
    begin  //mcd 07/10/2003 pour si date entr�e < arr�t� ,p�riode, interdire saisie (10575 en GC)
    PgiInfo(TraduireMemoire('La date d''entr�e est incompatible avec la saisie: Inf�rieure � arr�t� de p�riode'));
    Exit;
    end;
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  CleDoc.NaturePiece := NaturePiece;
  CleDoc.DatePiece := V_PGI.DateEntree;
  CleDoc.Souche := '';
  CleDoc.NumeroPiece := 0;
  CleDoc.Indice := 0;
  VH_GC.GCLastRefPiece := '';
  if Pos(cledoc.naturePiece,'PBT;CBT;LBT;')>0 then
  begin
  	EnAchat := true;
  end;
//  SaisiePiece(CleDoc, taCreat);
  SaisiePiece(CleDoc, taCreat,'','','',false,false,BoucleCreat,EnAchat);

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

function SaisiePieceFrais(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string ; Laffaire: string ): TmsFrais;
var X: TFFacture;
begin
  Result := TmsFValide;
  SourisSablier;
  X  := TFFacture.Create(Application);
  X.LAffaire := laffaire;
  X.lavenant := '';
  X.SaisieTypeAvanc := false;
  X.OrigineEXCEL := false;
  X.ValidationSaisie := false;
  // ----
  X.CleDoc := CleDoc;
  X.Action := Action;
  X.NewNature := X.CleDoc.NaturePiece;
  X.LeCodeTiers := LeCodeTiers;
  X.TransfoPiece := False;
  X.DuplicPiece := False;
  X.TypeSaisieFrs := true;
{$IFDEF BTP}
  X.PasBouclerCreat := true;
{$ENDIF}
	X.StatutAffaire := 'A';
  SourisNormale;
  X.ShowModal;
  result := X.ModeRetourFrs;
  X.Free;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Appel d'une pi�ce en cr�ation ou modification
Mots clefs ... : PIECE;SAISIE;
*****************************************************************}

function SaisiePiece(CleDoc: R_CleDoc; Action: TActionFiche; LeCodeTiers: string = ''; Laffaire: string = ''; Lavenant: string = ''; SaisieAvanc: boolean=false;
         OrigineEXCEL: boolean=false ; BoucleCreat : boolean=false;ModeGestionAchat : boolean=false; SaisieBordereau : boolean=false; TheStatutAffaire : String='A'): boolean;
var X: TFFacture;
  PP: THPanel;
begin

  Result := True;

  if PasCreerDateGC(V_PGI.DateEntree) then Exit;

  // Modif LS Suite a possibilit� de modifier les suggestion de r�approvisionnement
  if cledoc.NaturePiece = 'REA' Then
  	 BEGIN
     ModifSuggestion (cledoc,Action);
     exit;
  	 END;

  // Correction sur nature piece SEX et EEX
  if (cledoc.NaturePiece = 'SEX') or (CleDoc.NaturePiece = 'EEX') Then
  	 BEGIN
     ConsultMouvEx (cledoc,taCOnsult);
     exit;
  	 END;

  SourisSablier;
  PP := FindInsidePanel;
  X  := TFFacture.Create(Application);

  // modif BTP
  (*
  if GetParamSoc('SO_BTDOCAVECTEXTE') then
  begin
    if not SaisieAvanc then X.SaContexte := X.saContexte + [tModeBlocNotes];
    X.BorderStyle := bsSizeable;
  end;
  *)

  if SaisieBordereau then
	   begin
   	 X.SaContexte := X.saContexte + [tModeSaisieBordereau];
     end;

  X.LAffaire := laffaire;
  X.lavenant := lavenant;
  X.SaisieTypeAvanc := SaisieAvanc;
  X.OrigineEXCEL := OrigineEXCEL;
  X.ValidationSaisie := False;
  X.TypeSaisieFrs := false;

  // ----
  X.CleDoc := CleDoc;
  X.Action := Action;
  X.NewNature := X.CleDoc.NaturePiece;
  X.LeCodeTiers := LeCodeTiers;
  X.TransfoPiece := False;
  X.DuplicPiece := False;

{$IFDEF BTP}
  X.PasBouclerCreat := not BoucleCreat;
//X.GereDocEnAchat := ModeGestionAchat;
{$ENDIF}

	X.StatutAffaire := TheStatutAffaire;

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

function PieceEnPa (Naturepiece : string): boolean;
begin
	result := ((NaturePiece = 'PBT') Or (NaturePiece = 'CBT') or (naturePiece = 'LBT'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Appel d'une pi�ce en modification
Mots clefs ... : PIECE;SAISIE;
*****************************************************************}

procedure AppelPiece(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StC, StM: string;
  i_ind: integer;
  Action: TActionFiche;
  {$IFDEF GPAO}
  PiecePilotee: Boolean;
  {$ENDIF GPAO}
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
        PGIInfo(TraduireMemoire('Vous ne pouvez pas cr�er de pi�ce de ce type.'),
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

  {$IFDEF MODE}
  if IsTransfert(CleDoc.NaturePiece) then
  begin
    SaisieTransfert(CleDoc,Action,'TEM_TRV_NUMDIFFERENT');
    Exit;
  end;
  {$ENDIF}

  {$IFDEF GPAO}
  StringToCleDoc(StA, CleDoc);
  PiecePilotee := (GetInfoParPiece(CleDoc.NaturePiece, 'GPP_PIECEPILOTE') = 'X');
  case Action of
    taCreat:
      begin { Emp�che la cr�ation des pi�ces pilot�es depuis facture.pas }
        if PiecePilotee then
        begin
          PGIInfo(TraduireMemoire('Vous ne pouvez pas cr�er de pi�ce de ce type'), GetInfoParPiece(CleDoc.NaturePiece, 'GPP_LIBELLE'));
          EXIT;
        end;
      end;
    taModif:
      begin { Emp�che la modification des pi�ces pilot�es depuis facture.pas }
        if PiecePilotee then Action := taConsult;
      end;
  end;
  {$ENDIF GPAO}
  if Action = tacreat then
  begin
    // Modif LS suite a la possibilit� de modifier les suggestions de r�approvisionnment
    if cledoc.NaturePiece <> 'REA' then CreerPiece(StC);
  end else
  begin
    StringToCleDoc(StA, CleDoc);
    if CleDoc.NaturePiece <> '' then
    begin
      // Modif LS suite a la possibilit� de modifier les suggestions de r�approvisionnment
      if cledoc.NaturePiece = 'REA' Then
      begin
      	ModifSuggestion (cledoc,Action);
      end else if not PieceEnPa (Cledoc.naturepiece) then
      begin
      	SaisiePiece(CleDoc, Action);
      end else
      begin
      	SaisiePiece(CleDoc, Action,'','','',false,false,false,true);
      end;
    end;
  end
end;

procedure AGLCreerPiece(Parms: array of variant; nb: integer);
begin
  CreerPiece(string(Parms[0]));
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Transformation unitaire d'une pi�ce
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
  X.GereDocEnAchat := PieceEnPa (Cledoc.naturepiece);
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
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Transformation unitaire d'une pi�ce
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
  SaisieAveugle := Integer(Parms[2]) = 1; // Check box coch�
  if CleDoc.NaturePiece <> '' then TransformePiece(CleDoc, NewNat, SaisieAveugle);
(*
  {$IFDEF BTP}
  if (Cledoc.naturePiece = 'CF') or (Cledoc.naturePiece = 'CFR') then
  begin
    // reception ou facture fournisseur
    GenereLivraisonClients (false);
  end;
 {$ENDIF}
*)
end;

{***********A.G.L.***********************************************
Auteur  ...... : Jean-Louis DECOSSE
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Duplication unitaire d'une pi�ce
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
  (*
  if GetParamSoc('SO_BTDOCAVECTEXTE') then
  begin
    X.SaContexte := X.SaContexte + [tModeBlocNotes];
    X.BorderStyle := bsSizeable;
  end;
  *)
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

function DupliqueBordereauBTP(CleDoc: R_CleDoc; NewTiers: string;NewAffaire,Libelle:String;Debut,Fin : string): boolean;
var X: TFFacture;
  PP: THPanel;
begin
  FillChar(result, Sizeof(result), #0);
  SourisSablier;
  X := TFFacture.Create(Application);
  // modif BTP
  (*
  if GetParamSoc('SO_BTDOCAVECTEXTE') then
  begin
    X.SaContexte := X.SaContexte + [tModeBlocNotes];
    X.BorderStyle := bsSizeable;
  end;
  *)
  // -----
  X.CleDoc := CleDoc;
  X.Action := taModif;
  X.NewNature := Cledoc.NaturePiece;
  X.TransfoPiece := False;
  X.DuplicPiece := True;
  //
  X.SaContexte := X.saContexte + [tModeSaisieBordereau];
  X.LeCodeTiers := NewTiers;
  X.Laffaire := NewAffaire;
  X.DESIGNATIONBord := Libelle;
  X.DateDepartBord := StrToDate(Debut);
  X.DateFinBord := StrToDate(Fin);
  // --
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
Cr�� le ...... : 19/01/2000
Modifi� le ... : 19/01/2000
Description .. : Duplication unitaire d'une pi�ce
Mots clefs ... : PIECE;SAISIE;DUPLICATION;GENERATION;
*****************************************************************}

procedure AppelDupliquePiece(Parms: array of variant; nb: integer);
var CleDoc: R_CleDoc;
  StA, StM, NewNat, TypFac: string;
begin
  FillChar(CleDoc, Sizeof(CleDoc), #0);
  StA := string(Parms[0]);
  StM := string(Parms[1]);
  if nb > 2 then TypFac := string(Parms[2])
            else TypFac := '';
  StringToCleDoc(STA, CleDoc);
  NewNat := StM;

  // Duplication provenance des factures
  if (cledoc.NaturePiece = 'FBT') and (newNat = 'FBT') then NewNat := 'FBT'
  else if (cledoc.NaturePiece = 'FBT') and (newNat <> 'FBT') then NewNat := 'ABT'
  else if (cledoc.NaturePiece = 'FAC') and (newNat = 'FBT') then NewNat := 'FAC'
  else if (cledoc.NaturePiece = 'FAC') and (newNat <> 'FBT') then NewNat := 'AVC'
  else if (cledoc.NaturePiece = 'FBC') and (newNat = 'FBT') then NewNat := 'FBC'
  else if (cledoc.NaturePiece = 'FBC') and (newNat <> 'FBT') then NewNat := 'ABC';
  // Duplication provenance des avoirs
  if (cledoc.NaturePiece = 'ABT') and (newNat <> 'ABT') then NewNat := 'FBT'
  else if (cledoc.NaturePiece = 'ABT') and (newNat = 'ABT') then NewNat := 'ABT'
  else if (cledoc.NaturePiece = 'AVC') and (newNat = 'ABT') then NewNat := 'AVC'
  else if (cledoc.NaturePiece = 'AVC') and (newNat <> 'ABT') then NewNat := 'FAC'
  else if (cledoc.NaturePiece = 'ABC') and (newNat = 'ABT') then NewNat := 'ABC'
  else if (cledoc.NaturePiece = 'ABC') and (newNat <> 'ABT') then NewNat := 'FBC';
  //
  if CleDoc.NaturePiece <> ''  then
     begin
        if (TypFac = 'AVA') or (TypFac = 'DAC') then
           PgiBox (TraduireMemoire('Seules les factures directes et hors-devis#13#10 peuvent �tre dupliqu�es'),Traduirememoire('Duplication de factures'))
        else
           DupliquePiece(CleDoc, NewNat);
     end;
end;

procedure TFFacture.FindLigneFind(Sender: TObject);
begin
  Rechercher(GS, FindLigne, FindFirst);
end;

procedure TFFacture.BChercherClick(Sender: TObject);
begin
  {$IFDEF BTP}
  if (Action <> taConsult) and (TOBPiece.GetValue('GP_NATUREPIECEG') = VH_GC.AFNatProposition) and (IsTypeAffaire(TOBPiece.GetValue('GP_AFFAIRE'),'P')) then
  begin
    FindNextArticlesBtp (self,TOBpiece,TobArticles,TobTiers,TobAffaire);
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
  GP_REFEXTERNE.Text := '';
  GP_DATEREFEXTERNE.Text := DateToStr(V_PGI.DateEntree);
  GP_REPRESENTANT.Text := '';
  GP_TOTALTIMBRES.Value := 0;
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
	TOBmetres.setAllModifie(false);
  TOBBasesL.SetAllModifie(False);
  TOBPiece.SetAllModifie(False);
  TOBAdresses.SetAllModifie(False);
  TOBBases.SetAllModifie(False);
  TOBEches.SetAllModifie(False);
  TOBAcomptes.SetAllModifie(False);
  TOBPorcs.SetAllModifie(False);
  TOBLigFormule.SetAllModifie(False) ;
  TOBTiers.SetAllModifie(False);
  TOBAnaP.SetAllModifie(False);
  TOBAnaS.SetAllModifie(False);
  TOBDesLots.SetAllModifie(False);
  TOBSerie.SetAllModifie(False);
  TOBNomenclature.SetAllModifie(False);
  // Modif BTP
  TOBOuvrage.SetAllModifie(False);
  TOBOuvragesP.SetAllModifie(False);
  TOBPieceRG.SetAllModifie(False);
  TOBLIENOLE.SetAllModifie(False);
  TOBBasesRG.SetAllModifie(False);
  TOBTimbres.SetAllModifie(False);
  {$IFDEF BTP}
  TOBLienDEVCHA.SetAllModifie(False);
  {$ENDIF}
  TOBPieceTrait.setAllModifie(false);
  // -----
end;

procedure TFFacture.InitToutModif(Datemaj : TdateTime = 0);
var NowFutur: TDateTime;
begin
	if DateMaj = 0 then
  begin
  	NowFutur := NowH;
  end else
  begin
  	NowFutur := DateMaj;
  end;
  TOBPiece.SetAllModifie(True);
  TOBPiece.SetDateModif(NowFutur);
  TOBAdresses.SetAllModifie(True);
  TOBBases.SetAllModifie(True);
  TOBEches.SetAllModifie(True);
  TOBAcomptes.SetAllModifie(True);
  TOBPorcs.SetAllModifie(True);
  TOBLigFormule.SetAllModifie(True) ;
  InvalideModifTiersPiece(TOBTiers);
  TOBAnaP.SetAllModifie(True);
  TOBAnaS.SetAllModifie(True);
  TOBDesLots.SetAllModifie(True);
  TOBSerie.SetAllModifie(True);
  TOBNomenclature.SetAllModifie(True);
  // Modif BTP
	TOBmetres.setAllModifie(true);
  TOBBasesL.SetAllModifie(true);
  TOBOuvrage.SetAllModifie(True);
  TOBOuvragesP.SetAllModifie(True);
  TOBLIENOLE.SetAllModifie(true);
  TOBPieceRG.SetAllModifie(true);
  TOBBasesRG.SetAllModifie(True);
  TOBTimbres.SetAllModifie(True);
  {$IFDEF BTP}
  TOBLienDEVCHA.SetAllModifie(True);
  {$ENDIF}
  // --
  TobLigneTarif.SetAllModifie(True);
  TOBPieceTrait.setAllModifie(true);
end;

procedure TFFacture.LoadLesTOB;
var Q: TQuery;
		indice : integer;
begin
  LoadPieceLignes(CleDoc, TobPiece,true,false);
  PieceAjouteSousDetail(TOBPiece,true,false,true);
  // --
  // OPTIMISATIONS LS
{$IFDEF BTP}
  if TOBPiece.getValue('GP_AFFAIREDEVIS')<> '' then
  begin
    StockeCetteAffaire (string(TOBPiece.getValue('GP_AFFAIREDEVIS')));
  end;
  if TOBPiece.getValue('GP_AFFAIRE')<> '' then
  begin
    StockeCetteAffaire (string(TOBPiece.getValue('GP_AFFAIRE')));
  end;
  // --
{$ENDIF}
  // Lecture des affectations document
  LoadLaTOBPieceTrait(TOBpieceTrait,cledoc);
  // Lecture metres
  loadlesMetres (Cledoc,TOBMetres);
  LoadlesTimbres(cledoc,TOBTimbres);
  // Lecture bases Lignes
  Q := OpenSQL('SELECT * FROM LIGNEBASE WHERE ' + WherePiece(CleDoc, ttdLigneBase, False), True,-1, '', True);
  TOBBasesL.LoadDetailDB('LIGNEBASE', '', '', Q, False);
  Ferme(Q);
{$IFDEF BTP}
  OrdonnelignesBases (TOBBasesL);
{$ENDIF}
  // Lecture bases
  Q := OpenSQL('SELECT * FROM PIEDBASE WHERE ' + WherePiece(CleDoc, ttdPiedBase, False), True,-1, '', True);
  TOBBases.LoadDetailDB('PIEDBASE', '', '', Q, False);
  Ferme(Q);
  // Lecture Ech�ances
  Q := OpenSQL('SELECT * FROM PIEDECHE WHERE ' + WherePiece(CleDoc, ttdEche, False), True,-1, '', True);
  TOBEches.LoadDetailDB('PIEDECHE', '', '', Q, False);
  Ferme(Q);
  // Lecture Ports
  Q := OpenSQL('SELECT * FROM PIEDPORT WHERE ' + WherePiece(CleDoc, ttdPorc, False), True,-1, '', True);
  TOBPorcs.LoadDetailDB('PIEDPORT', '', '', Q, False);
  Ferme(Q);
  // Lecture Lignes Formule
  LoadLesFormules(TOBPiece,TOBLigFormule,CleDoc) ;
  // Lecture Adresses
  LoadLesAdresses(TOBPiece, TOBAdresses);
  // Lecture Nomenclatures
  LoadLesNomen(TOBPiece, TOBNomenclature, TOBArticles, CleDoc);
  // Lecture Lot
  LoadLesLots(TOBPiece, TOBDesLots, CleDoc);
  {$IFNDEF CCS3}
  // Lecture Serie
  LoadLesSeries(TOBPiece, TOBSerie, CleDoc, TransfoPiece);
  {$ENDIF}
  // Lecture ACompte
  LoadLesAcomptes(TOBPiece, TOBAcomptes, CleDoc, lesAcomptes);
  // Lecture Analytiques
  LoadLesAna(TOBPiece, TOBAnaP, TOBAnaS);

  // Modif BTP
  // chargement textes debut et fin
  LoadLesBlocNotes(SaContexte, TOBLienOle, Cledoc);

  // Chargement des retenues de garantie et Tva associe
  if GetParamSoc('SO_RETGARANTIE') then LoadLesRetenues(TOBPiece, TOBPieceRG, TOBBasesRG, CleDoc,Action);
  {$IFDEF BTP}
  // Lecture Ouvrages
  LoadLesOuvrages(TOBPiece, TOBOuvrage, TOBArticles, Cledoc, IndiceOuv,OptimizeOuv);
  if (IsEcritLesOuvPlat)  then LoadLesOuvragesPlat(TOBPiece, TOBOuvragesP, Cledoc);
  {$ENDIF}
  TOBBasesSaisies.Dupliquer(TOBBases,True,True);
  // chargement des details ouvrage ou nomenclatures
  DEV.Code := TOBPIECE.GetValue('GP_DEVISE');
  GetInfosDevise(DEV);
  DEV.Taux := GetLeTauxDevise(DEV.Code, DEV.DateTaux, cledoc.datepiece);
  MemoriseNumLigne(TobPiece);
//  LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc);
  {$IFDEF CHR}
  HRLoadlesTobChr(Self, TOBPiece, Tobregrpe);
  {$ENDIF}
  {$IFDEF AFFAIRE}
  LoadLesAFFormuleVar('LIG', TobPiece, TOBFormuleVar, TOBFormuleVarQte); //Affaire-Formule des variables
  {$ENDIF}
  { Chargement des d�tails tarif par ligne de pi�ce }
//  LoadLesLignesTarifs(TobLigneTarif, CleDoc);
  LoadLesGCS;
  //
  LoadLaTOBAffaireInterv(TOBAffaireInterv,TOBPiece.getValue('GP_AFFAIRE'));
end;

procedure TFFacture.LoadTOBCond(RefUnique: string);
var Q: TQuery;
begin
  if TOBConds.FindFirst(['GCO_ARTICLE'], [RefUnique], False) <> nil then Exit;
  Q := OpenSQL('SELECT * FROM CONDITIONNEMENT WHERE GCO_ARTICLE="' + RefUnique + '" ORDER BY GCO_NBARTICLE', True,-1, '', True);
  if not Q.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', Q, True, False);
  Ferme(Q);
end;

procedure TFFacture.LoadLesArticles(GestionAffichage: boolean = True);
var i, iArt, iRefCata: integer;
  TOBL, TOBArt, TOBC, TOBCata, LocAnaP, LocAnaS: TOB;
  RefUnique, RefCata, RefFour: string;
  NaturePieceG: string;
  EnContremarque : boolean;
begin
  TOBCata := nil;
  iArt := 0;
  iRefCata := 0;
  NaturePieceG := TOBPiece.GetValue('GP_NATUREPIECEG');
  ConstruireTobArt(TOBPiece);
{$IFDEF BTP}
	if OptimizeOuv <> nil then OptimizeOuv.fusionneArticles (TOBArticles);
{$ENDIF}
  InitMove(TOBPiece.Detail.Count, '');
{$IFDEF BTP}
  if (not TransfoPiece) and (not DuplicPiece) and (Action = TaModif)  then
  begin
    GestionConso.InitReceptions;
  end;
{$ENDIF}
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    MoveCur(False);
    if i = 0 then
    begin
      iRefCata := TOBL.GetNumChamp('GL_REFCATALOGUE');
      iArt := TOBL.GetNumChamp('GL_ARTICLE');
    end;
    if ((TOBL.GetValue('GL_QTEPREVAVANC') <> 0) or (TOBL.GetValue('GL_QTESIT') <> 0)) and (TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') and (not ISDejaFacture) then
    begin
      IsDejaFacture := true;
    end;
    //InitLesSupLigne(TOBL);
    // R�cup�ration article
    RefCata := '';
    RefFour := '';
    RefUnique := '';
    EnContremarque := (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X');
    if EnContremarque then
    begin
      RefCata := TOBL.GetValeur(iRefCata);
      RefFour := GetCodeFourDCM(TOBL);
      TOBCata := TOBCatalogu.FindFirst(['GCA_REFERENCE', 'GCA_TIERS'], [RefCata, RefFour], False);
      if TOBCata = nil then
        TOBCata := InitTOBCata(TOBCatalogu, RefCata, RefFour);
      LoadTOBDispoContreM(TOBL, TOBCata, False);
    end;
    RefUnique := TOBL.GetValeur(iArt);
    if RefUnique <> '' then TobArt := TOBArticles.FindFirst(['GA_ARTICLE'], [RefUnique], False) else TOBArt := nil;
    if (refUnique <> '') and (TobArt <> nil) then
    begin
      InitLesSupLigne(TOBL,false);
      // MODIF AC CATALOGU
      //if (VenteAchat='ACH') and ((CataFourn) or (TOBL.GetValue('GL_REFARTTIERS')<>'')) then AjouteCatalogueArt(TOBL,TOBArt) ;
      CodesLigneToCodesArt(TOBL, TOBArt);
      TOBL.PutValue('BNP_TYPERESSOURCE',TOBArt.getValue('BNP_TYPERESSOURCE'));
      TOBL.PutValue('QTEORIG', TOBL.GetValue('GL_QTESTOCK'));
    end;
    if (RefUnique <> '') or ((RefCata <> '') and (RefFour <> '')) then
    begin
      if (TobArt = nil) and (not EnContremarque) then
      begin
        PGIError( TraduireMemoire('La pi�ce n''est plus modifiable car l''article ') + Chr(10) +
        TraduireMemoire('de r�f�rence : ') + RefUnique + Chr(10) +
        TraduireMemoire('et de libell� : ') + TOBL.GetValue('GL_LIBELLE') + Chr(10) +
        TraduireMemoire('a �t� supprim� de la base article') );
        Action := taConsult;
      end
      else
      begin
{$IFDEF BTP}
        if (not TransfoPiece) and (not DuplicPiece) and (Action = TaModif)  then
        begin
          GestionConso.recupereReceptions (TOBL);
        end;
{$ENDIF}
        // Chargement du commercial
        AjouteRepres(TOBL.GetValue('GL_REPRESENTANT'), TypeCom, TOBComms);
        // Compta
        // OPTIMISATION LS
  			if (not TransfoPiece) and (not DuplicPiece) and (Action = TaModif)  then
        begin
        	// on ne touche surtout pas a l'analytique en modif de piece
        end else
        begin
          if ((OkCpta) or (OkCptaStock)) then
          begin
  {$IFDEF BTP}
            TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBL, TOBArt, TOBTiers, TOBCata, TobAffaire, True,TOBTablette);
  {$ENDIF}
  //        if ((OkCpta) or (OkCptaStock)) then
  //        begin
            if (TOBC <> nil) and (TOBL.Detail.Count > 0) then
            begin
              if ((TOBL.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
              if ((TOBL.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
              PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBL);
            end;
          end;
        end;
      end;
    end;
    // Modif BTP le 01/04/03 (Gestion Prix pos�s)
    if TOBL.GetValue('GL_TYPEARTICLE') = 'PRE' then
    begin
(*
      if (Pos(TOBL.GetValue('BNP_TYPERESSOURCE'),'SAL;INT;')>0) then TOBL.putvalue('GL_TPSUNITAIRE', 1)
      																													else TOBL.putvalue('GL_TPSUNITAIRE', 0);
*)
      if (Pos(TOBL.GetValue('BNP_TYPERESSOURCE'),VH_GC.BTTypeMoInterne)>0) then TOBL.putvalue('GL_TPSUNITAIRE', 1)
                                                                           else TOBL.putvalue('GL_TPSUNITAIRE', 0);
    end;
    gestionConso.InitialisationLigne (TOBL);
    if IsArticle (TOBL) then
    begin
      if (TOBL.GetValue('GLC_DOCUMENTLIE') <> '') and (IsPrevisionChantier (TOBL)) then
      begin
        AjouteMontantPVDevis (TOBL);
      end else if (TOBL.GetValue('GLC_DOCUMENTLIE') <> '') and (IsContreEtude (TOBL)) then
      begin
        AjouteMontantPVDevis (TOBL);
      end;
    end;
//    SommationAchatDoc(TOBPiece, TOBL);
//    if ((NaturePieceG= 'BLC') or (Naturepieceg = 'LBT')) and (Action = TaModif) then
    if (Action = TaModif) then
    begin
      TOBL.PutValue('LIVREORIGINE',TOBL.getValue('GL_QTESTOCK')); // Qte initiale de sortie de stock
    end;
    if (IsCommentaire (TOBL)) and (not IsBLobVide(self,TOBL,'GL_BLOCNOTE')) and (not IsLigneReferenceLivr(TOBL)) and (not OrigineExcel) then
    BEGIN
      TOBL.PutValue('GL_LIBELLE', 'BLOC NOTE ASSOCIE');
      TOBL.PutValue('BLOBONE', 'X');
    END;
    // Affichage
(*
			if GestionAffichage then
      AfficheLaLigne(i + 1);
*)
    // VARIANTE
//    if (IsVariante (TOBL)) and (SaisieTypeAvanc) then GS.RowHeights [i+1] := 0;
{
    if (IsVariante (TOBL)) and ((SaisieTypeAvanc)or (ModifAvanc )) then
    BEGIN
       GS.RowHeights [i+1] := 0;
    END;
}
    // --
  end;
  if Pos(NaturePieceG,'PBT;BCE')>0 then
  begin
    NettoieBudget;
  end;
  FiniMove;
  if (ctxMode in V_PGI.PGIContexte) and ((Action = taConsult) or (Action = taModif)) then AffichageDim;
end;

procedure TFFacture.ConstruireTobArt(TOBPiece: Tob);
var i, NbArt : integer;
  StSelect, StSelectDepot, StSelectDepotLot, StSelectCon, {StArticle,}
  StSelectCatalogu, StSelectFormule, {StCodeArticle,} stWhereLigne, ListeDepot,
  NomChamp, VteAch {, RefGen, Statut}: string;
  TOBDispo, TOBDispoLot, TOBArt, TobDispoArt, TobDispoLotArt, TOBCata, TobCataArt, TobAF: TOB;
  QArticle, QDepot, QDepotLot, QCon, QCata, QFormule : TQuery;
  {OkTab,} DoubleDepot: Boolean;
begin

//
  StSelect := 'SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
              'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
              'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE';
//
//  StSelect := 'SELECT * FROM ARTICLE LEFT JOIN ARTICLECOMPL ON GA2_ARTICLE=GA_ARTICLE';
  StSelectDepot := 'SELECT * FROM DISPO';
  StSelectDepotLot := 'SELECT * FROM DISPOLOT';
  StSelectCon := 'SELECT * FROM CONDITIONNEMENT';
  StSelectCatalogu := 'SELECT * FROM CATALOGU';
  StSelectFormule := 'SELECT * FROM ARTICLEQTE';

  ListeDepot := '';
  DoubleDepot := IsTransfert(TOBPiece.GetValue('GP_NATUREPIECEG'));
  if DoubleDepot then
    ListeDepot := '"' + TOBPiece.GetValue('GP_DEPOT') + '","' + TOBPiece.GetValue('GP_DEPOTDEST') + '"'
  else ListeDepot := '"' + TOBPiece.GetValue('GP_DEPOT') + '"';

  TOBDispo := TOB.CREATE('Les Dispos', nil, -1);
  TOBDispoLot := TOB.CREATE('Les Dispolots', nil, -1);
  TOBCata := TOB.CREATE('Les Catalogues', nil, -1);

{$IFDEF AFFAIRE}
// gestion de la saisie de facture depuis l'affaire avec reprise des lignes de l'affaire
// il faut charger les articles issus des lignes d'affaire  gm 01/07/03
  if (CleDocAffaire.NumeroPiece = 0) then
    stWhereLigne := WherePiece(CleDoc, ttdLigne, False)
  else
    stWhereLigne := WherePiece(CleDocAffaire, ttdLigne, False);
{$else}
  stWhereLigne := WherePiece(CleDoc, ttdLigne, False) ;
{$endif}

  QArticle := OpenSQL(StSelect + ' WHERE GA_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ') ORDER BY GA_ARTICLE', True,-1, '', True);
  if not QArticle.EOF then TOBArticles.LoadDetailDB('ARTICLE', '', '', QArticle, True, True);
  Ferme(QArticle);

  if DoubleDepot then
    QDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GQ_DEPOT IN (' + ListeDepot + ') AND GQ_CLOTURE="-"', True,-1, '', True)
  else QDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GQ_DEPOT IN (SELECT DISTINCT GL_DEPOT FROM LIGNE WHERE ' + stWhereLigne + ') AND GQ_CLOTURE="-"', True,-1, '', True);
  if not (CtxMode in V_PGI.PGIContexte) then
  begin
    if DoubleDepot then
      QDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
        ') AND GQL_DEPOT IN (' + ListeDepot + ')', True,-1, '', True)
    else QDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
        ') AND GQL_DEPOT IN (SELECT DISTINCT GL_DEPOT FROM LIGNE WHERE ' + stWhereLigne + ')', True,-1, '', True);
    if not QDepotLot.EOF then TOBDispoLot.LoadDetailDB('DISPOLOT', '', '', QDepotLot, True, True);
    Ferme(QDepotLot);
  end;
  if not QDepot.EOF then TOBDispo.LoadDetailDB('DISPO', '', '', QDepot, True, True);
  Ferme(QDepot);

  //Formules de qt�  JS 30/10/2003
  QFormule := OpenSQL(StSelectFormule + ' WHERE GAF_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ')', True,-1, '', True);
  if not QFormule.EOF then TOBAFormule.LoadDetailDB('ARTICLEQTE', '', '', QFormule, True, True);
  Ferme(QFormule);

  QCon := OpenSQL(StSelectCon + ' WHERE GCO_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne +
    ') ORDER BY GCO_NBARTICLE', True,-1, '', True);
  if not QCon.EOF then TOBConds.LoadDetailDB('CONDITIONNEMENT', '', '', QCon, True, True);
  Ferme(QCon);

  if (VenteAchat = 'ACH') then
  begin
    QCata := OpenSQL(StSelectCatalogu + ' WHERE GCA_TIERS IN (SELECT DISTINCT GL_TIERS FROM LIGNE WHERE ' + stWhereLigne +
      ') AND GCA_ARTICLE IN (SELECT GL_ARTICLE FROM LIGNE WHERE ' + stWhereLigne + ' AND GL_ARTICLE<>"" )', True,-1, '', True);
    if not QCata.EOF then TOBCata.LoadDetailDB('CATALOGU', '', '', QCata, True, True);
    Ferme(QCata);
  end;

  //Affecte les stocks aux articles s�lectionn�s
  for NbArt := 0 to TOBArticles.detail.Count - 1 do
  begin
    with TOBArticles.detail[NbArt] do
    begin
      AddChampSupValeur('UTILISE', '-', False);
      AddChampSupValeur('REFARTSAISIE', '', False);
      AddChampSupvaleur('REFARTBARRE', '', False);
      AddChampSupValeur('REFARTTIERS', '', False);
      AddChampSupValeur('_FROMOUVRAGE', '-', False);
    end;
    // FIN MODIF DC

    TOBArt := TOBArticles.detail[NbArt];
    //
    InitChampsSupArticle (TOBART);
    //
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
    //Affecte les catalogu aux articles s�lectionn�s
    TobCataArt := TOBCata.FindFirst(['GCA_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
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
      TobCataArt := TOBCata.FindNext(['GCA_ARTICLE'], [TOBArt.GetValue('GA_ARTICLE')], False);
    end;
  end;

  //Formules de qt�  JS 30/10/2003
  if VenteAchat='VEN' then VteAch:='VTE'
  else VteAch := VenteAchat;
  for i := 0 to TobAFormule.Detail.Count -1 do
  begin
    TobAF := TobAFormule.Detail[i];
    QFormule := OpenSql('SELECT * FROM ARTFORMULEVAR WHERE GAV_ARTICLE="'+
                   TobAF.GetValue('GAF_ARTICLE')+'" AND GAV_VENTEACHAT="'+VteAch+'"',True,-1, '', True);
    if not QFormule.Eof then TobAF.LoadDetailDB('ARTICLEQTE','','',QFormule,False) ;
    Ferme(QFormule);
  end;

  TOBDispo.Free;
  TOBDispoLot.Free;
  TOBCata.Free;
  DispoChampSupp(TOBArticles);
end;

procedure TFFacture.ChargeNouveauDepot(TOBPiece, TobLigne: Tob; stNouveauDepot: string); // DBR : Depot unique charg�
var Ligne, NbArt: integer;
  StSelectDepot, StSelectDepotLot, Statut, StArticle: string;
  stWhereArt: string;
  TOBDispo, TobDispoLot, TOBArt, TobDispoArt, TobDispoLotArt: TOB;
  TQDepot, TQDepotLot: TQuery;
  TobL : TOB;
begin
  StSelectDepot := 'SELECT * FROM DISPO';
  StSelectDepotLot := 'SELECT * FROM DISPOLOT';

  stWhereArt := '';
  for NbArt := 0 to TobArticles.Detail.Count - 1 do
  begin
    StArticle := TobArticles.Detail[NbArt].GetValue('GA_ARTICLE');
    Statut := TobArticles.Detail[NbArt].GetValue('GA_STATUTART');
    if (Statut = 'DIM') or (Statut = 'UNI') then
    begin
      if stWhereArt = '' then stWhereArt := '"' + StArticle + '"'
      else stWhereArt := stWhereArt + ',"' + StArticle + '"';
    end;
  end; // Sur la piece ca ne permet pas de g�rer les composants de nomenclatures !

  if stWhereArt <> '' then
  begin
    TOBDispo := TOB.CREATE('Les Dispos', nil, -1);
    TOBDispoLot := TOB.CREATE('Les Dispolots', nil, -1);

    TQDepot := OpenSQL(StSelectDepot + ' WHERE GQ_ARTICLE IN (' + stWhereArt + ') AND ' +
      'GQ_DEPOT="' + stNouveauDepot + '" AND GQ_CLOTURE="-"', True,-1, '', True);
    if not TQDepot.EOF then TOBDispo.LoadDetailDB('DISPO', '', '', TQDepot, True, True);
    Ferme(TQDepot);

    TQDepotLot := OpenSQL(StSelectDepotLot + ' WHERE GQL_ARTICLE IN (' + stWhereArt + ') AND ' +
      'GQL_DEPOT="' + stNouveauDepot + '"', True,-1, '', True);
    if not TQDepotLot.EOF then TOBDispoLot.LoadDetailDB('DISPOLOT', '', '', TQDepotLot, True, True);
    Ferme(TQDepotLot);

    //Affecte les stocks aux articles s�lectionn�s
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

    if TobLigne <> nil then
    begin
        TobDispo := TobArticles.FindFirst (['GQ_ARTICLE', 'GQ_DEPOT'],
                                           [TobLigne.GetValue ('GL_ARTICLE'), TobLigne.GetValue ('GL_DEPOT')], True);
        if TobDispo <> nil then
        begin
          TobLigne.PutValue ('GL_PMAP', TobDispo.GetValue ('GQ_PMAP'));
          TobLigne.PutValue ('GL_DPR', TobDispo.GetValue ('GQ_DPR'));
          TobLigne.PutValue ('GL_DPA', TobDispo.GetValue ('GQ_PMAP'));
          TobLigne.PutValue ('GL_PMRP', TobDispo.GetValue ('GQ_PMRP'));
          TobLigne.PutValue ('GL_RECALCULER', 'X');
        end;
    end else
    begin
      for Ligne := 0 to TobPiece.Detail.Count - 1 do
      begin
        TobL := TobPiece.detail[Ligne];
        TobDispo := TobArticles.FindFirst (['GQ_ARTICLE', 'GQ_DEPOT'],
                                           [TobL.GetValue ('GL_ARTICLE'), TobL.GetValue ('GL_DEPOT')], True);
        if TobDispo <> nil then
        begin
          TobL.PutValue ('GL_PMAP', TobDispo.GetValue ('GQ_PMAP'));
          TobL.PutValue ('GL_DPR', TobDispo.GetValue ('GQ_DPR'));
          TobL.PutValue ('GL_DPA', TobDispo.GetValue ('GQ_PMAP'));
          TobL.PutValue ('GL_PMRP', TobDispo.GetValue ('GQ_PMRP'));
          TobL.PutValue ('GL_RECALCULER', 'X');
        end;
      end;
    end;
  end;
end;

procedure TFFacture.AppliqueTransfoDuplic(GestionAffichage: boolean = True);
var i, i_Compo, IndiceNomen: integer;
  TOBL, TOBA, TOBB, TOBN, TOBPlat: TOB;
  j: Integer;
  TobLT: TOB;
  ToblOld: Tob; { NEWPIECE }
  OldNat, ColPlus, ColMoins, EtatVC, RefPiece, RefUnique: string;
  MajLotZero, Galop, MajSerieZero, GaSer, LotSerieTrouve, Recalcul: boolean;
  dQteStock : double;
  bMajZeroQte : boolean;
{$IFDEF BTP}
	OldCledoc,CledocFrs : R_Cledoc;
{$ENDIF}
	CoefPaPr : double;
  GardeFg : boolean;
  MontantFact : double;
begin
	GardeFg := true;
  if ((not TransfoPiece) and (not DuplicPiece)) then
  BEGIN
  	ChangeTzTiersSaisie(NewNature);
//    TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
    if (not SaisieTypeAvanc) and (not ModifAvanc) then DefiniPVLIgneModifiable (TOBpiece,TOBPorcs);
    {$IFDEF BTP}
    // MODIF LS Pour affichage montant de situation
    if SaisieTypeAvanc then
    begin
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        TOBL := TOBPiece.Detail[i];
        // le Montant facture est le pourcentage d'avancement au chargement de la piece * Montant ligne au chargement
        MontantFact := Arrondi((TOBL.GetValue('GL_POURCENTAVANC')/100)* TOBL.GetValue('GL_TOTALHTDEV'),DEV.Decimale );
        TOBL.PutValue('MONTANTFACT',MontantFact);
        TOBL.PutValue('MONTANTSIT',0);
      end;
    end;
//    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
//    CalculPieceAutorise := true;
//    CalculeLaSaisie(-1, -1,(GereDocEnAchat or GestionAffichage));
//    if (not BCalculDocAuto.down) then CalculPieceAutorise := false;
    {$ENDIF}
    Exit;
  END;
{$IFDEF BTP}
  OldCledoc := Cledoc;
{$ENDIF}
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
  if (NewNature = 'FF') and (TransfoPiece = True) then
     GP_DATEPIECE.Text := ''
  else
     GP_DATEPIECE.Text := DateToStr(CleDoc.DatePiece);
  GP_NUMEROPIECE.Caption := HTitres.Mess[10];
  MajFromCleDoc(TOBPiece, CleDoc);
  LotSerieTrouve := False;
  MajLotZero := False;
  MajSerieZero := False;
  TOBPiece.PutValue('GP_DEVENIRPIECE', '');  TOBPiece.PutValue('GP_CODEORDRE',0) ;
  TOBPiece.PutValue('GP_REFCOMPTABLE', '');
  TOBPiece.PutValue('GP_REFCPTASTOCK', '');
  TOBPiece.PutValue('GP_ETATVISA', 'NON');
  TOBPiece.PutValue('GP_DATEVISA', iDate1900);
  TOBPiece.PutValue('GP_EDITEE', '-');
  TOBPiece.PutValue('GP_DATECREATION', Date);
{$IFDEF BTP}
	InitCalcDispoArticle;
{$ENDIF}
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
  	IsDejaFacture := false;
  	PositionneTextes;
    TOBPiece.PutValue('GP_VIVANTE', 'X');
    TOBPiece.PutValue('GP_ACOMPTE', 0);
    TOBPiece.PutValue('GP_ACOMPTEDEV', 0);
    TOBPiece.PutValue('GP_AFFAIREDEVIS', '');
    // GRC-MNG
    TOBPiece.PutValue('GP_PERSPECTIVE', 0);
    TOBPiece.PutValue('GP_RESSOURCE', '');
    //ClearAffaire(TOBPiece) ;
    TOBAcomptes.ClearDetail;
    TOBEches.ClearDetail;
    ReinitRGUtilises(TOBPieceRG);
//    ZeroMontantPorts (TOBPorcs);
    if FraisChantier then
    begin
    	if PgiAsk ('D�sirez-vous conserver les frais du document dupliqu� ?',Caption) = mrNo then gardeFg := false;
      if gardefg then
      begin
      	if ExisteFraisChantier (TOBPiece_o,CledocFrs) then
        begin
        	if G_DupliquePieceBTP(cledocfrs) then
          begin
          	TOBPIece.PutValue ('GP_PIECEFRAIS',CleDocToString (cledocFrs));
        		TOBPiece.putValue('_NEWFRAIS_','X');
          end;
        end;
      end else
      begin
        SupprimeFraisRepartisPiece (TOBPorcs);
    		TOBPiece.putValue('GP_PIECEFRAIS','');
      end;
    end else
    begin
    	TOBPiece.putValue('GP_PIECEFRAIS','');
    end;
    {$IFDEF BTP}
    TobLienDevCha.ClearDetail;
    {$ENDIF}
  end else
  begin
    // Provisoire : Reinitialisation des �ch�ances
    TOBEches.ClearDetail;
    if ((GereLot) and (TOBPiece_O.GetValue('GP_ARTICLESLOT') <> 'X')) then MajLotZero := True;
    if ((GereSerie) and (TOBSerie_O.Detail.Count <= 0)) then MajSerieZero := True;
    if CtxMode in V_PGI.PGIContexte then GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False)
    else GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False);
    {Etudier modif d�p�t O/N}
    ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
    if ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0)) then PasToucheDepot := True;
    if PasToucheDepot then GP_DEPOT.Enabled := False;
    {$IFDEF GPAO}
    if GetInfoParpiece(cledoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X' then
    begin
      GP_DEPOT.Enabled := False;
      GP_DATELIVRAISON.Enabled := false;
    end;
    {$ENDIF GPAO}
  end;
  Recalcul := False; { NEWPIECE }
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    { R�cup�re la ligne pr�c�dente dans la TobPiece_O }{ NEWPIECE }
    ToblOld := FindTobLigInOldTobPiece(Tobl, TobPiece_O);
    if Assigned(ToblOld) then
      RefPiece := EncodeRefPiece(ToblOld);
    MajFromCleDoc(TOBL, CleDoc);
    { TP - NEWPIECE - BUG 10752 }
    dQteStock := Tobl.GetValue ('GL_QTERESTE');
//    dQteStock := Tobl.GetValue ('GL_QTESTOCK');
    bMajZeroQte := false;
    if DuplicPiece then
    begin
{$IFDEF BTP}
			if IsRetourFournisseur (TOBPiece) or IsRetourClient(TOBPiece) then
      begin
      	TOBL.PutValue('GL_PIECEPRECEDENTE', RefPiece);
        TOBL.PutValue('BCO_LIENRETOUR',TOBL.GetValue('BLP_NUMMOUV'));  // sauvegarde du lien
      end else if (CleDoc.NaturePiece = VH_GC.AFNatAffaire) and (IsPieceOrigineEtude(TOBL)) then
      begin
        TOBL.PutValue('GL_PIECEPRECEDENTE', '');
        if not GardeFg then
        begin
        	TOBL.PutValue('GL_PIECEORIGINE', '');
        end;
      end else
      begin
        TOBL.PutValue('GL_PIECEORIGINE', '');
        TOBL.PutValue('GL_PIECEPRECEDENTE', '');
			end;
{$ELSE}
      TOBL.PutValue('GL_PIECEORIGINE', '');
      TOBL.PutValue('GL_PIECEPRECEDENTE', '');
{$ENDIF}
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
{$IFDEF BTP}
      TOBL.PutValue('BLP_NUMMOUV',0);
			TOBL.PutValue('BCO_TRAITEVENTE','-');
			TOBL.PutValue('BCO_QTEVENTE',0);
			TOBL.PutValue('BCO_QUANTITE',0);
			TOBL.PutValue('BCO_LIENVENTE',0);
			TOBL.PutValue('BCO_LIENRETOUR',0);
      if (isPieceGerableFraisDetail (TOBL.GetValue('GL_NATUREPIECEG'))) and (not GardeFg) then
      begin
      	TOBL.PutValue('GL_PIECEORIGINE','');
//      	ReinitCoefPaPr(TOBL,TOBouvrage);
      end;
      ZeroLigneMontant (TOBL);
{$ENDIF}
      // ClearAffaire(TOBL) ;
    end else
    begin
      //       RefPiece:=EncodeRefPiece(TOBPiece_O.Detail[i]) ; { NEWPIECE }
      TOBL.PutValue('GL_PIECEPRECEDENTE', RefPiece);
      if TOBL.GetValue('GL_PIECEORIGINE') = '' then TOBL.PutValue('GL_PIECEORIGINE', RefPiece);
      TOBL.PutValue('GL_QTERELIQUAT', 0);
      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
      {$IFDEF BTP}

      if Pos(TOBL.GetValue('GL_NATUREPIECEG'),GetNaturePieceBLC) <= 0 Then
      begin
        TOBL.putValue('NUMCONSOPREC',TOBL.getValue('BLP_NUMMOUV'));
        if not TOBL.FieldExists ('BLP_NUMMOUV') then TOBL.AddChampSup ('BLP_NUMMOUV',false);
        TOBL.PutValue('BLP_NUMMOUV',0);
      end;

      if Pos(TOBL.GetValue('GL_NATUREPIECEG'),GetNaturePieceBLC) > 0 Then
      BEGIN
         AffecteQtelivrable (ToblOld,TOBL,TOBArticles,dQteStock,GestionConso);
         if TOBL.FieldExists('DPARECUPFROMRECEP') then
         begin
         	if TOBL.GetValue('GL_DPA') <> 0 then CoefPaPr := TOBL.GetValue('GL_DPR')/TOBL.GEtVAlue('GL_DPA')
          																else CoefpapR := 0;
         	TOBL.PutValue('GL_DPA',TOBL.GetValue('DPARECUPFROMRECEP'));
          if CoefPaPR <> 0 then TOBL.PutValue('GL_DPR',TOBL.GetValue('GL_DPA')* CoefPaPr)
         end;
      END else
      BEGIN
      {$ENDIF}
      TOBL.PutValue('GL_QTEFACT', TOBL.GetValue('GL_QTERESTE')); { NEWPIECE }
      TOBL.PutValue('GL_QTESTOCK', TOBL.GetValue('GL_QTERESTE')); { NEWPIECE }
      {$IFDEF BTP}
      END;
      {$ENDIF}
      TOBL.PutValue('GL_NUMORDRE',0) ; ZeroLigneMontant (TOBL);
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
          bMajZeroQte := True;
          if GereReliquat then TOBL.PutValue('GL_QTERELIQUAT', dQteStock); //TOBL.GetValue('GL_QTESTOCK'));
          // JS 20/06/03
          TOBL.PutValue('GL_QTEFACT',0) ; TOBL.PutValue('GL_QTESTOCK',0) ;
          TOBL.PutValue('GL_QTERESTE',0) ;  {NEWPIECE}
          LotSerieTrouve := True;
        end;
      end;
      {S�rie}
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
          if not bMajZeroQte then {NEWPIECE}
          begin
            if GereReliquat then TOBL.PutValue('GL_QTERELIQUAT', dQteStock); //TOBL.GetValue('GL_QTESTOCK'));
            if TOBL.GetValue('GL_QTERELIQUAT') < 0 then TOBL.PutValue('GL_QTERELIQUAT',0);
          // JS 03/07/03
            TOBL.PutValue('GL_QTEFACT',0) ; TOBL.PutValue('GL_QTESTOCK',0) ;
            TOBL.PutValue('GL_QTERESTE',0) ; {NEWPIECE}
          end;
          LotSerieTrouve := True;
        end;
      end;
      if GestionAffichage then
        AfficheLaLigne(i + 1);
    end;
(*  MODIF BRL 28/06/05

    if not VH_GC.GCIfDefCEGID then
      {Pour CEGID, la duplication conserve les px valo et ne les r�affecte pas}
      if ((DuplicPiece) or (GetInfoParPiece(NewNature, 'GPP_RECALCULPRIX') = 'X')) and (not TransfoPiece) then
      begin
{$IFDEF BTP}
				if not DuplicPiece then
        begin
{$ENDIF}
          TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
          if TOBA <> nil then AffectePrixValo(TOBL, TOBA, TOBOuvrage);
{$IFDEF BTP}
				end;
{$ENDIF}
      end;
*)
  end;


  DefinieRefInterneExterne(NewNature);
{$IFDEF BTP}
	FinCalcDispo;
{$ENDIF}

  for i := 0 to TOBmetres.Detail.Count - 1 do
  begin
    TOBB := TOBmetres.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBBases.Detail.Count - 1 do
  begin
    TOBB := TOBBases.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBBasesL.Detail.Count - 1 do
  begin
    TOBB := TOBBasesL.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBEches.Detail.Count - 1 do
  begin
    TOBB := TOBEches.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBPieceRG.Detail.Count - 1 do
  begin
    TOBB := TOBPieceRG.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  for i := 0 to TOBBasesRG.Detail.Count - 1 do
  begin
    TOBB := TOBBasesRG.Detail[i];
    MajFromCleDoc(TOBB, CleDoc);
  end;
  ReliquatTransfo := ((TransfoPiece) and (GereReliquat));
  if ((GereSerie) and (TOBSerie_O.Detail.Count > 0) and (ReliquatTransfo)) then InitialiseReliquatSerie (TobSerRel, TobSerie_O);
  {$IFDEF BTP}
 	if TransfoPiece then
  begin
    // MODIF LS
    if (VenteAchat = 'ACH') and (pos(newNature,'BLF;FF')>0) and (OldCledoc.NaturePiece = 'CF') then
    begin
      if GP_REFINTERNE.text = '' then
      begin
        GP_REFINTERNE.Text := 'Cde Fou'+inttostr(OldCledoc.NumeroPiece)+' du '+DateToStr(OldCledoc.DatePiece);
      end;
    end;
    // -----
  	InsereLigneRefPrecedent (TOBPiece,OldCledoc);
    NumeroteLignesGC (nil,TOBPiece,true,false);
  End;
  for I := 0 to TOBPiece.detail.count -1 do
  begin
  	AfficheLaLigne(I+1);
  end;
  {$ENDIF}
  if (Recalcul) or ((TransfoPiece) and (LotSerieTrouve) and ((MajLotZero) or (MajSerieZero))) then
  begin
    NumeroteLignesGC(nil,TOBpiece, False, false);
    TOBBases.clearDetail; TOBBasesL.clearDetail; ZeroFacture (TOBpiece);
    ZeroMontantPorts (TOBPorcs);
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculPieceAutorise := true;
    CalculeLaSaisie(-1, -1,GestionAffichage);
    if (not BCalculDocAuto.down) then CalculPieceAutorise := false;
  end;
  if DuplicPiece then
  begin
    NumeroteLignesGC(nil,TOBpiece, False, false);
    TOBBases.clearDetail; TOBBasesL.clearDetail; ZeroFacture (TOBpiece);
    ZeroMontantPorts (TOBPorcs);
    if TOBOuvragesP <> nil then TOBOuvragesP.clearDetail;  //modif BRL 31/03/2010 suite pb pouchain
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculPieceAutorise := true;
    FactReCalculPv := false;
    CalculeLaSaisie(-1, -1, GestionAffichage);
    FactReCalculPv := true;
    if (not BCalculDocAuto.down) then CalculPieceAutorise := false;
    TOBPiece.PutEcran(Self);
    AfficheTaxes;
    AffichePorcs;
  end;

  for i := 0 to TobLigneTarif.Detail.Count - 1 do
  begin
    TobLT := TobLigneTarif.Detail[i];
    TobLT.PutValue('GL_NATUREPIECEG', CleDoc.NaturePiece);
    TobLT.PutValue('GL_SOUCHE', CleDoc.Souche);
    TobLT.PutValue('GL_NUMERO', CleDoc.NumeroPiece);
    TobLT.PutValue('GL_INDICEG', CleDoc.Indice);
    { Boucle sur les lignes }
    for j := 0 to TobLT.Detail.count - 1 do
      MajFromCleDoc(TobLT.Detail[j], CleDoc);
  end;

  {$IFDEF AFFAIRE}
  (* Deplace
  {$IFDEF BTP}
 	if TransfoPiece then
  begin
  	InsereLigneRefPrecedent (TOBPiece,OldCledoc);
    NumeroteLignesGC (nil,TOBPiece,true,false);
  End;
  for I := 0 to TOBPiece.detail.count -1 do
  begin
  	AfficheLaLigne(I+1);
  end;
  {$ENDIF}
  *)
  if DuplicPiece or TransfoPiece then
  begin
    NumeroteLignesGC(GS, TOBpiece, False, GestionAffichage);
    DupplicLesAFFormuleVar(TOBPiece,TOBFormuleVarQte,TOBFormuleVarQte_O); //Affaire-Formule des variables
  end;
  {$ENDIF}
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

procedure TFFacture.GereVivante;
var Morte: boolean;
  NumMess: integer;
begin
  if Action <> taModif then Exit;
  if DuplicPiece then Exit;
  //if TransfoPiece then Exit;
  NumMess := 9;
  if (not TransfoPiece) and (not IsModifiable (TOBPiece)) then
  begin
    Action := taConsult;
  end;

  if (not TransfoPiece) and (not CanModifyPiece(TobPiece)) then { NEWPIECE : Pas de modification de piece V421 }
  begin
    Action := taConsult;
    HPiece.Execute(NumMess, Caption, '');
    exit;
  end;

  {$IFDEF BTP}
  DefiniPieceVivanteBtp (TobPiece,NumMess);
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
    { TP - NEWPIECE : Bug 10760 }
    BDelete.Visible := (not TransfoPiece) and (not DuplicPiece) and (JaiLeDroitConcept(TConcept(bt116),False));
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
  if (not RGMultiple(TOBpiece)) then
  begin
    TOBL := TOBPIECE.findfirst(['GL_TYPELIGNE'], ['RG'], true);
//    TOBLIGNERG := TOB.Create('LIGNERGUNIQ', nil, -1);
    if TOBL <> nil then
    begin
//      TOBLIGNERG.addchampsupValeur('PIECEPRECEDENTE', TOBL.GetValue('GL_PIECEPRECEDENTE'));
      DeleteTobLigneTarif(TobPiece, Tobl);
      TOBL.free;
    end;
  end;
end;
// ---

procedure TFFacture.ChargelaPiece(GestionAffichage: boolean = True; ElimineLigneSoldee: boolean = True);
var
  Ind: integer;
  TOBL, TOBA, TOBTmp: TOB;
  ChargeLesDetail : boolean;
  MontantFact : double;
  InAvancement,SauvModCalcul: boolean;
  NaturePiece,lastPrec : string;
  TraiteAvancOuv : boolean;
begin
  lastPreC := '';
  IndiceOuv := 1;
  NaturePiece := cledoc.NaturePiece;
  {$IFDEF CHR}
  RemplirTOBHrdossier(GP_HRDOSSIER.Text, TobHrdossier);
  {$ENDIF}
  LoadLesTOB;
  //
  TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  //
  FraisChantier := IsExisteFraisChantier (TOBPiece);
  EvaluerMaxNumOrdre(TOBPiece);
  TestprovenanceMultiDev(TOBpiece);
  SupLigneRgUnique;
  if TransfoPiece then
  begin
    TOBPiece_OO.Dupliquer(TOBPiece, True, True); { TobPiece avec toutes les lignes }
    if ElimineLigneSoldee then
    begin
      { Lors d'une transformation, �carte les lignes sold�es de la TobPiece }
      for Ind := TobPiece.Detail.Count - 1 downto 0 do
      begin
        TobL := TOBPiece.Detail[ind];
        if EstLigneArticle(TobL) and EstLigneSoldee(TobL) then
        begin
          DeleteTobLigneTarif(TobPiece, Tobl);
          TobL.Free;
        end;
      end;
    end;
    { Message d'alerte si toutes les lignes de la pi�ce d'origine sont sold�es }
    if TobPiece.Detail.Count = 0 then
      HPiece.Execute(54, Caption, '');
  end;
  TOBPiece_O.Dupliquer(TOBPiece, True, True);
  TOBBasesRG_O.Dupliquer(TOBBASESRG, True, True);
  if TOBPieceRG.detail.count = 0 then TOBBasesRG.clearDetail;
  if TOBPiece.Detail.Count >= GS.RowCount - 1 then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      GS.RowCount := TOBPiece.Detail.Count + 2;
      if GS.RowCount < NbRowsInit then GS.RowCount := NbRowsInit;
//      GS.height := (GS.rowHeights[1] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    end
    else
    begin
      {$IFDEF BTP}
      DefiniRowCount ( self,TOBPiece);
      {$ELSE}
      GS.RowCount := TOBPiece.Detail.Count + 1;
      {$ENDIF}
    end;
  end;
    // MODIF LS Pour MODIF AVANCEMENET
  if (((not TransfoPiece) and (not DuplicPiece)) and (IsModeAvancement(TOBPiece))) or (SaisieTypeAvanc) then
  begin
    GS.ListeParam := GetParamsoc('SO_LISTEAVANC');

    // MODIF BRL AVANCEMENTS CHANTIERS
    if NaturePiece= 'PBT' then
      GS.ListeParam := GS.ListeParam + '_CHA';
    if not SaisieTypeAvanc then
		begin
      ModifAvanc := True;
    	GS.ListeParam := 'BTMODIFAVCN';
      if NaturePiece = 'PBT' then
      begin
        MajQtesAvantSaisie (TOBPiece);
      end else
      begin
        DefiniDejaFacture(TOBPiece,DEV);
      end;
    end;
    LesColonnesVte := GS.titres[0];
    LesColonnesAch := GS.titres[0];
  end else
  begin
    if NaturePiece = 'FBT' then MajQtesAvantSaisie (TOBpiece);
    GS.ListeParam := GetInfoParPiece(NewNature, 'GPP_LISTESAISIE');
    //
    LesColonnesVte := GS.titres[0];
    LesColonnesAch := GS.titres[0];
    //
  end;
  if not SaisieTypeAvanc then
  begin
  	GereDocEnAchat := (TOBPiece.getValue('GP_PIECEENPA')='X');
  end else GereDocEnAchat := false;

  //
  DefinieColonnesAchatBtp (Self);
  //
  PositionneModeBordereauBTP (Self,TOBpiece);
  PositionneEuroGescom;
//  if (FromAvoir) or ((not DuplicPiece) and (EstAvoir)) then InverseAvoir;
  if (FromAvoir) and (estavoir) and (duplicpiece) then InverseAvoir;
  if (FromAvoir) and (not EstAvoir) and (DuplicPiece) then inverseAvoir;
  if ((not DuplicPiece) and (EstAvoir)) then InverseAvoir;
  TOBPiece.PutEcran(Self);
  if CleDoc.DatePiece <= 0 then CleDoc.DatePiece := TOBPiece.GetValue('GP_DATEPIECE');
  AfficheTaxes;
  AffichePorcs;
  EtudieColsListe;
  if TOBTimbres.detail.count > 0 then
  begin
  	GP_TOTALTIMBRES.Value := GetTotalTimbres(TOBTimbres,TOBpiece,TOBEches);
  end;

  GP_NUMEROPIECE.Caption := IntToStr(TOBPiece.GetValue('GP_NUMERO'));
  Ind := TOBPiece.GetValue('GP_INDICEG');
  if Ind > 0 then GP_NUMEROPIECE.Caption := GP_NUMEROPIECE.Caption + '  ' + IntToStr(Ind);
  ChargeTiers;
  InitEuro;
  InitRIB;
  LoadLesArticles(GestionAffichage);
  LoadLesTextes;
  //
  {$IFDEF BTP}
  //
  InAvancement := (SaisieTypeAvanc) or (ModifAvanc);
  //
  if (not InAvancement) then LoadLesLienDEVCha(TOBPiece, TOBOuvrage, TOBLienDEVCHA);
  //
  // Gestion des metres
  TheMetre.Ouvrages := TOBOuvrage;
  TheMetre.Document := TOBPiece;
  //
  {$ENDIF}
  // chargement des details ouvrage ou nomenclatures
  ChargeLesDetail := (SaisieTypeAvanc or ModifAvanc);
  // OPTIMISATIONS LS
  (* controle pour piece non encore calcul�e *)
  //
  if (PieceNonMiseAJourOptimise (TOBpiece,TOBBasesL)) then
  begin
//    if CleDoc.NaturePiece <> 'PBT' then
    begin
      if (Action = taModif) then
      begin
        SauvModCalcul := SaisieTypeAvanc;
        SaisieTypeAvanc := false; // debrayage pour calculd e la pi�ce
        ForceEcriture := true; // force la mise a jour lors du click sur valider

        BeforeTraitementCalculCoef (TOBArticles,TOBPiece,TOBPorcs,TOBOUvrage,DEV,SaisieTypeAvanc); // pour sauvegarder le coef en provenance de la fiche article
        FactReCalculPv := false;
        ReinitMontantPieceTrait (TOBPieceTrait);
        ZeroFacture (TOBpiece);
				ZeroMontantPorts (TOBPorcs);
        for Ind := 0 to TOBPiece.detail.count -1 do ZeroLigneMontant (TOBPiece.detail[Ind]);
        PutValueDetail (TOBpiece,'GP_RECALCULER','X');
        TOBBases.ClearDetail;
        TOBBasesL.ClearDetail;
        GereCalculPieceBTP;
        FactReCalculPv := true;
        PieceControleModifie := true;

        SaisieTypeAvanc := SauvModCalcul;
      end else
      begin
        PGIInfo('Attention, cette pi�ce n''a pas �t� recalcul�e',caption);
      end;
    end;
  end else if PieceNonOptimiseCalcul (TOBPiece,TOBOUvrage,TOBBasesL) then
  begin
    SauvModCalcul := SaisieTypeAvanc;
    SaisieTypeAvanc := false; // debrayage pour calcul de la pi�ce
    ForceEcriture := true; // force la mise a jour lors du click sur valider
    FactReCalculPv := false;
    ZeroFacture (TOBpiece);
    ZeroMontantPorts (TOBPorcs);
    ReinitMontantPieceTrait (TOBPieceTrait);
    if SaisieTypeAvanc then
    begin
      for Ind := 0 to TOBPiece.Detail.Count - 1 do
      begin
        TOBL := TOBPiece.Detail[Ind];
        // le Montant facture est le pourcentage d'avancement au chargement de la piece * Montant ligne au chargement
        MontantFact := Arrondi((TOBL.GetValue('GL_POURCENTAVANC')/100)* TOBL.GetValue('GL_TOTALHTDEV'),DEV.Decimale );
        TOBL.PutValue('MONTANTFACT',MontantFact);
        TOBL.PutValue('MONTANTSIT',0);
      end;
    end;
    for Ind := 0 to TOBPiece.detail.count -1 do ZeroLigneMontant (TOBPiece.detail[Ind]);
    TOBBases.ClearDetail;
    TOBBasesL.ClearDetail;
    PutValueDetail (TOBpiece,'GP_RECALCULER','X');
    GereCalculPieceBTP;
    FactReCalculPv := true;
    PieceControleModifie := true;
    SaisieTypeAvanc := SauvModCalcul;
  end;
  if OuvrageNonDifferencie (TOBpiece,TOBouvrage) then
  begin
  	if Action = taModif then
    begin
    	WAIT.Visible := true;
      WAIT.refresh;
      Label1.Caption := 'G�n�ration index unique ouvrage & traitement avancement ouvrage';
      //
  		if ((not TransfoPiece) and (not DuplicPiece)) and (modifavanc) then TraiteAvancOuv := true;
      //
    	OuvrageDifferencie (TOBpiece,TOBOuvrage,TraiteAvancOuv,DEV);
      Wait.Visible := false;
    end;
  end;
  //
  if not PieceControleModifie then LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, ChargeLesDetail);

  if TOBPiece.Detail.Count >= GS.RowCount - 1 then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      GS.RowCount := TOBPiece.Detail.Count + 2;
      if GS.RowCount < NbRowsInit then GS.RowCount := NbRowsInit;
//      GS.height := (GS.rowHeights[1] * GS.Rowcount) + (GS.GridLineWidth * GS.Rowcount);
    end else
    begin
      {$IFDEF BTP}
      DefiniRowCount (self,TobPiece);
      {$ENDIF}
    end;
  end;

  {$IFDEF BTP}
  if ModifAvanc then CalculeSousTotauxPiece(TOBPiece);
  {$ENDIF}

  if GestionAffichage then
  begin
    for ind := 0 to TOBPiece.Detail.Count - 1 do
    begin
      if (IsVariante (TOBPiece.Detail[ind])) and ((SaisieTypeAvanc)or (ModifAvanc )) then
      BEGIN
         GS.RowHeights [ind+1] := 0;
      END;
      AfficheLaLigne(ind + 1);
    end;
    if (ctxMode in V_PGI.PGIContexte) and ((Action = taConsult) or (Action = taModif)) then AffichageDim;
  end;

  // Fin BTP
  //TOBPiece_O.Dupliquer(TOBPiece,True,True) ; { NEWPIECE Deplac� }
  OldHT := TOBPiece_O.GetValue('GP_TOTALHT');
  for ind := 0 to TOBPiece_O.Detail.Count - 1 do
  begin
    TOBL := TOBPiece_O.Detail[ind];
    if TOBL <> nil then
    begin
      if TOBL.FieldExists('ANCIENNUMLIGNE') then
        TOBL.PutValue('GL_NUMLIGNE', TOBL.GetValue('ANCIENNUMLIGNE'));
      // Deplac�
      //SommationAchatDoc(TOBPiece, TOBL);
      //
      if (not SaisieTypeAvanc) and (not ModifAvanc) then
        CalculMargeLigne(Ind + 1)
      else
      begin
        if (not SaisieTypeAvanc) then CalculMargeLigne(Ind + 1);
        CalculValoAvanc(TOBPIece, Ind, DEV);
        if FinTravaux then
          TOBPiece.detail[ind].putvalue('GL_QTESIT', 0);
        AfficheLaLigne(Ind + 1);
      end;
    end;
    if (SaisieTypeAvanc) or (ModifAvanc) then TOBPiece.PutValue('GP_RECALCULER', 'X');
    if TOBL.Detail.Count > 0 then
    begin
      TOBA := TOBL.Detail[0];
      TOBA.ClearDetail;
    end;
  end;
    // Correction FQ 12256 -- Les adresses sont manquantes quand le document provient des interventions
  if TOBAdresses.detail.count = 0 then
  begin
    if GetParamSoc('SO_GCPIECEADRESSE') then
    begin
      TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Livraison}
      TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
    end else
    begin
      TOB.Create('ADRESSES', TOBAdresses, -1); {Livraison}
      TOB.Create('ADRESSES', TOBAdresses, -1); {Facturation}
    end;
    //
    TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece);
    AffaireVersAdresses(TOBAffaire,TOBAdresses,TOBPiece); //mcd 29/09/03 d�plac� pour r�soudre cas clt fact # ds affaire et adresse fact
{$IFDEF BTP}
    if (VenteAchat = 'VEN') and (not DuplicPiece) then
    begin
      LivAffaireVersAdresses (TOBAffaire,TOBAdresses,TOBPiece);
    end;
{$ENDIF}

  end;

  // Duplication pour tri de TOBPiece_OS pour calcul de somme GL_QTERESTE optimis�
  // Parcours de la tob pour duplication des filles, champs GL_ARTICLE et GL_QTERESTE.
  TOBPiece_OS := TOB.Create('Art Qte', nil, -1);
  for ind := 0 to TOBPiece_O.Detail.Count - 1 do
  begin
    TobTmp := TOB.Create('Art Qte', TOBPiece_OS, -1);
    TobTmp.AddChampSupValeur('GL_ARTICLE', TOBPiece_O.Detail[ind].GetValue('GL_ARTICLE'));
    TobTmp.AddChampSupValeur('GL_QTERESTE', TOBPiece_O.Detail[ind].GetValue('GL_QTERESTE'));
  end;
  TOBPiece_OS.Detail.Sort('GL_ARTICLE');

  TOBBases_O.Dupliquer(TOBBases, True, True);
  TOBAdresses_O.Dupliquer(TOBAdresses, True, True);
  TOBEches_O.Dupliquer(TOBEches, True, True);
  TOBPorcs_O.Dupliquer(TOBPorcs, True, True);
  TOBLigFormule_O.Dupliquer(TOBLigFormule,True,True) ;
  TOBN_O.Dupliquer(TOBNomenclature, True, True);
  TOBLOT_O.Dupliquer(TOBdesLots, True, True);
  TOBSerie_O.Dupliquer(TOBSerie, True, True);
  TOBAcomptes_O.Dupliquer(TOBAcomptes, True, True);
//  if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then ChargeAffairePiece(False, True);
  TobLigneTarif_O.Dupliquer(TobLigneTarif, True, True);
  TOBOuvrage_O.Dupliquer(TOBOuvrage, True, True);
  TOBLIENOLE_O.Dupliquer(TOBLIENOLE, True, True);
  TOBPIECERG_O.Dupliquer(TOBPIECERG, True, True);
  TOBFormuleVarQte_O.Dupliquer(TOBFormuleVarQte, True, True); //Affaire-Formule des variables
  NumeroteLignesGC(GS, TOBpiece, False, GestionAffichage);
  // OPTIMISATIONS LS
  //  AjouteEtatLignePrecedente(TobPiece, TobPiece_O, TransfoPiece, Action);
  //
  InclusSTinFG := (TOBPiece.GetValue('GP_APPLICFGST')='X');
  InclusSTinFC := (TOBPiece.GetValue('GP_APPLICFCST')='X');
  //
  TheGestRemplArticle.SetEnabled;
end;

procedure TFFacture.InitEnteteDefaut(Totale: boolean);
begin
  if Totale then
  begin
    CleDoc.DatePiece := V_PGI.DateEntree;
    GP_DATEPIECE.Text := DateToStr(CleDoc.DatePiece);
    {$IFDEF BTP}
    if (NewNature='PBT') or (NewNature='CBT')  then
      GP_DATELIVRAISON.Text := DateToStr(iDate2099)
    else
      GP_DATELIVRAISON.Text := DateToStr(CleDoc.DatePiece);
    {$ENDIF}
    GP_DATEREFEXTERNE.Text := DateToStr(CleDoc.DatePiece);
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
  {$IFDEF NOMADE}
  // Dans PCP, le repr�sentant par d�faut est le repr�sentant du site.
  if (PCP_LesSites <> nil) and (PCP_LesSites.LeSiteLocal <> nil) then
  begin
    VariableSite := PCP_LesSites.LeSiteLocal.LesVariables.Find('$REP');
    if (VariableSite <> nil) and ( VariableSite.SVA_VALUE <> '') then GP_REPRESENTANT.Text := VariableSite.SVA_VALUE;
  end;
  {$ENDIF}

  ChangeTzTiersSaisie(NewNature);
  TOBPiece.GetEcran(Self);
  TOBPiece.PutValue('GP_NATUREPIECEG', NewNature);
  TOBPiece.PutValue('GP_VENTEACHAT', VenteAchat);
  // Application de FG sur Sous traitance
  if InclusSTinFG then TOBPiece.putValue('GP_APPLICFGST','X')
  								else TOBPiece.putValue('GP_APPLICFGST','-');
  if InclusSTinFC then TOBPiece.putValue('GP_APPLICFCST','X')
  								else TOBPiece.putValue('GP_APPLICFCST','-');
  // saisie en PA sur piece de vente
  if (GereDocEnAchat) and (venteAchat='VEN') then TOBPiece.putValue('GP_PIECEENPA','X')
  																					 else TOBPiece.putValue('GP_PIECEENPA','-');
  AfterInitEnteteDefaut(Self);
  {$IFDEF CHR}
  HRMajCHR(Self, TOBPiece, TOBTiers, TobHrdossier, VenteAchat);
  {$ENDIF}
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
  // MODIFBRL du 100107 pour se positionner sur la date de pi�ce.
  //if GP_TIERS.CanFocus then GP_TIERS.SetFocus else
  GotoEntete;
  TOBPiece.PutValue('GP_PERSPECTIVE', CleDoc.NoPersp); //PAUL
  ChargeLesTimbres (TOBPiece,TOBTimbres);
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
    //Descriptif.Enabled := not Bloc;
    {$IFNDEF EAGLCLIENT}
    MBSGED.Visible := AglIsoflexPresent;
    {$ENDIF}
  end else if ActionSaisie = taCreat then
  begin
    GP_DEVISE.Enabled := not Bloc;
    BDEVISE.Enabled := not Bloc;
    GP_DOMAINE.Enabled := not Bloc;
    if ctxMode in V_PGI.PGIContexte then GP_ETABLISSEMENT.Enabled := not Bloc;
    {$IFDEF GPAO}
    if GetInfoParpiece(cledoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X' then
    begin
      GP_DEPOT.Enabled := False;
      GP_DATELIVRAISON.Enabled := false;
    end;
    {$ENDIF GPAO}
  end else
  begin
    if not DuplicPiece then
    begin
{$IFDEF BTP}
      BRazAffaire.enabled := Not IsDejafacture;
      BRechAffaire.enabled := Not IsDejafacture;
      TOBPiece.putvalue('ISDEJAFACT',BoolToStr_(IsDejafacture));
      GP_TIERS.Enabled := TiersModifiableInDocument(TOBPiece);
      GP_DEVISE.Enabled := true;
{$ELSE}
      GP_TIERS.Enabled := not Bloc;
      GP_DEVISE.Enabled := not Bloc;
{$ENDIF}
      BDEVISE.Enabled := not Bloc;
      GP_DOMAINE.Enabled := (not Bloc) or (V_PGI.FSAV); 
      if ctxMode in V_PGI.PGIContexte then GP_ETABLISSEMENT.Enabled := not Bloc;
    end else
    begin
      GP_DEVISE.Enabled := False;
      BDEVISE.Enabled := False;
      GP_DOMAINE.Enabled := true;
    end;
  end;
  AfterBloquePiece(Self, ActionSaisie, Bloc);
end;

procedure TFFacture.GotoGrid(PageDown, FromF10: boolean);
Var Okok : boolean ;
begin
  if Screen.ActiveControl=GS then Exit ;
  if FromF10 then Okok:=True
  else Okok:=((Screen.ActiveControl.Parent=Pentete) and PageDown) or ((Screen.ActiveControl.Parent=PPied) and Not PageDown) ;
  if Okok and GS.CanFocus then GS.SetFocus;
end ;

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
  if GP_REFEXTERNE.CanFocus then
  begin
    GP_REFEXTERNE.SetFocus;
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
{=============================== Ev�nements de la Form ========================================}
{==============================================================================================}

procedure TFFacture.FormCreate(Sender: TObject);
begin
 InitParamTimbres;
	TOBOLDL := NewTOBLigne(nil,-1,true);
  //
  ModifSousDetail :=  GetParamSocSecur('SO_BTMODIFSDETAIL',false);
	ModeRetourFrs := TmsNone;
	TOBpieceFraisAnnule := TOB.Create ('LES PIECE DE FRAIS SUP',nil,-1);
	TypeSaisieFrs := false;
	InitDomaineAct;
	DomaineSoc := GetParamSocSecur('SO_BTDOMAINEDEFAUT','');

  ReceptionModifie := false;
  // OPTIMISATIONS LS
  IsDejaFacture := false;
  ForceEcriture := false;
  //
  ReinitTOBAffaires;
  ReinitFg := false;
  FactReCalculPv := true;
  PieceControleModifie := false;
  // --
  // Modif BTP
  GereDocEnAchat := false;
  InValidation := false;
  DefinitionTaillePied;
  InitContexteGrid;
  // Initialisation pour gestion des acomptes Mode BTP
  LesAcomptes := nil;
  AcompteObligatoire := false;
  FinTravaux := false;
  ModifAvanc := false;
  // --
  TransfertTEM_TRV := 'TEM_TRE';
  Litige := False;
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
//  NbLignesGrille := 10;
  CopierColler := TCopieColleDoc.create(Self);
  with CopierColler do
  begin
    TypeDonnee := 'LIGNE'; // positionne le type de donn�e manipul�
    Grid := GS; // Positionne la grille a manipuler
  end;
  // Int�gration des m�tr�s
  {$IFDEF BTP}
  TheMetre := TStockMetre.create;
  // Ajout LS
  TheMetreShare := TheMetre;
  // --
  GestionConso := TGestionPhase.create;
	TheDestinationLiv := TDestinationLivraison.create (self);
  TheLivFromRecepStock := TLivraisonFromRecepStock.create (self);
  ATraiterQte := True;
  TheRgpBesoin := TFactRgpBesoin.create(self);
  TheRepartTva := TREPARTTVAMILL.create (self) ;
  {$ENDIF}
  // VARIANTE
  TheVariante := TVariante.create (self);
	TheBordereauMen := TFactBordereauMenu.create (self);
  TheBordereau := TUseBordereau.create(self);
  TheGestParag := TGestParagraphe.create (self);
  TheGestRemplArticle := Tgestremplarticle.create (self);
  TheApplicDetOuv := TApplicDetOuv.create (Self);
  // ---
  fPieceCoTrait := TPieceCotrait.create (self);
  //
	fModifSousDetail := TModifSousDetail.create (self);
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
{$IFDEF BTP}
    if uppercase(POPY.Items[i_ind].Name) = 'FRAISDETAIL' then
    begin
      POPY.Items[i_ind].enabled := (Action=TaModif);
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'MBTARIF' then
    begin
      POPY.Items[i_ind].Caption  := TraduireMemoire('R�actualisation des prix');
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'VOIRFRANC' then
    begin
      POPY.Items[i_ind].Visible := True;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'MBREPARTTVA' then
    begin
      POPY.Items[i_ind].Visible := False;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'SEPTVA1000' then
    begin
      POPY.Items[i_ind].Visible := True;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'NSEPARATEUR' then
    begin
      POPY.Items[i_ind].Visible := True;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'MNVISAPIECE' then
    begin
      	POPY.Items[i_ind].Visible := True;
    end;
{$ENDIF}
    if uppercase(POPY.Items[i_ind].Name) = 'LIBREPIECE' then
    begin
      POPY.Items[i_ind].Visible := False;
    end;
    if uppercase(POPY.Items[i_ind].Name) = 'MBSGED' then
    begin
      //mcd 17/04/02 pour ne pas afficher menu SGED si pas g�r�
      {$IFNDEF EAGLCLIENT}
      POPY.Items[i_ind].Visible := AglIsoflexPresent;
      {$ENDIF}
      Break;
    end;

    if (uppercase(POPY.Items[i_ind].Name) = 'MBTARIFVISUORIGINE') then
      POPY.Items[i_ind].Visible := GetParamSoc('SO_PREFSYSTTARIF');
    if (uppercase(POPY.Items[i_ind].Name) = 'MBCOMMISSIONVISUORIGINE') then
      POPY.Items[i_ind].Visible := GetParamSoc('SO_PREFSYSTTARIF');
    if (uppercase(POPY.Items[i_ind].Name) = 'MBTARIFGROUPE') then
      POPY.Items[i_ind].Visible := GetParamSoc('SO_PREFSYSTTARIF') and GetParamSoc('SO_TARIFSGROUPES');
  end;
  if (ctxMode in V_PGI.PGIContexte) then Exit;
  {$IFDEF BTP}

  SRDocGlobal.onclick := SRDocGlobalClick;
  SRDocParag.onclick := SRDocParagClick;
//  Fraisdetail.onclick := FraisdetailClick;
//  {$ENDIF}
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
  {$IFDEF BTP}
//  MemoriseListeSaisieBTP (Self);
  LesColonnesVte := GS.titres[0];
  LesColonnesAch := GS.titres[0];
  //
  DefinieColonnesAchatBtp (Self);
  {$ENDIF}
  // Modif BTP
  PresentSousDetail := GetInfoParPiece(NewNature, 'GPP_TYPEPRESENT');
(*  if OrigineEXCEL then PresentSousDetail := DOU_AUCUN; *) // MODIF LS 30-5-07
  GestionNotesDoc := GetInfoParPiece(NewNature, 'GPP_TYPEPRESDOC');
  {
  if GestionNotesDoc = 'AUC' then
  begin
    if (tModeBlocNotes in SaContexte) then SaContexte := SaContexte - [TModeBlocNotes];
  end;
  if GestionNotesDoc = 'TOU' then
  begin
    if not (tModeBlocnotes in SaContexte) then SaContexte := SaContexte + [tModeBlocNotes];
  end;
  }
  if (not SaisieTypeAvanc) or (NewNature<>'PBT') then
  begin
    GereDocEnAchat := (GetInfoParPiece(NewNature, 'GPP_FORCEENPA')='X');
  end else GereDocEnAchat := false;
  InclusSTinFG := (GetParamSoc ('SO_INCLUSTINFG'));
  InclusSTinFC := (GetParamSocSecur ('SO_INCLUSTINFC',false));

  // -----
  {Caract�ristiques nature}
  VenteAchat := GetInfoParPiece(NewNature, 'GPP_VENTEACHAT');
  GereStatPiece := GetInfoParPiece(NewNature, 'GPP_AFFPIECETABLE') = 'X';
  EstAvoir := (GetInfoParPiece(NewNature, 'GPP_ESTAVOIR') = 'X');
  {commercial}
  TypeCom := GetInfoParPiece(NewNature, 'GPP_TYPECOMMERCIAL');
{$IFNDEF BTP}
  if TypeCom = '' then if ctxFO in V_PGI.PGIContexte then TypeCom := 'VEN' else TypeCom := 'REP';
{$ENDIF}
{$IFDEF BTP}
  if VenteAchat = 'VEN' then TmenuItem(FindComponent('Modebordereau')).visible := true;
{$ENDIF}
  {Comptabilit�}
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
  {M�canismes et automatismes}
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

  {$IFDEF BTP}
(*
  if (NewNature = VH_GC.AFNatProposition) and (not OrigineEXCEL) then
    GereDocEnAchat := True;
*)
  {$ENDIF}
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
  {$ENDIF}
  BVentil.Visible := ((VPiece.Visible) or (VLigne.Visible) or (SPiece.Visible) or (SLigne.Visible));
  BEche.Visible := ((GereEche = 'AUT') or (GereEche = 'DEM'));
  BEche.Enabled := BEche.Visible;
  if ((not BEche.Visible) and (not BVentil.Visible)) then Sep2.Visible := False;
  if EstAvoir then // JT eQualit� 10764
    BAcompte.Enabled := false
    else
    BAcompte.Enabled := ((GereAcompte) and (Action <> taConsult));
  {$IFDEF BTP}
  BAcompte.Enabled := (BAcompte.Enabled and (not AcompteObligatoire)) and
  										((TOBPiece.GetValue('GP_NATUREPIECEG')<>'DBT') OR
                      	((TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') AND (TOBPiece.GetValue('ETATDOC')='ACP')));
  {$ENDIF}
  BInfos.Enabled := True;
  BPorcs.Enabled := True;
  {$IFDEF CHR}
  BPorcs.Enabled := False;
  {$ENDIF}
  if (Action = taConsult) and (not (tModeBlocnotes in saContexte)) then
  begin
    CommentLigne := False;
  end else
  begin
    if not (tModeBlocNotes in SaContexte) then
    begin
{$IFDEF BTP}
      TCommentEnt.Visible := True;
      TCommentPied.Visible := True;
{$ELSE}
      TCommentEnt.Visible := (CommentEnt <> '');
      TCommentPied.Visible := (CommentPied <> '');
{$ENDIF}
    end;
    BActionsLignes.Enabled := True;
    BSousTotal.Enabled := True;
    {$IFDEF GPAO}
    if  ((GetInfoParpiece(cledoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') and (GetInfoParpiece(cledoc.NaturePiece, 'GPP_INSERTLIG') = '-')) then
      BActionsLignes.Enabled := False;
    {$ENDIF GPAO}

    if ((GetInfoParpiece(cledoc.NaturePiece, 'GPP_INSERTLIG') = '-') and (Cledoc.NaturePiece = 'TRE') and (TobPiece_O.getvalue('GP_NATUREPIECEG') = 'TRV')) then
      BActionsLignes.Enabled := False;
    CommentLigne := True;
  end;
  {Acc�s edition Word}
  EnaWord := True;
  if GetInfoParPieceCompl(CleDoc.NaturePiece, TOBPiece.GetValue('GP_ETABLISSEMENT'), 'GPC_MODELEWORD') = '' then EnaWord := False else
    if GetParamSoc('SO_GCREPERTOIREWORD') = '' then EnaWord := False;
  BOffice.Visible := EnaWord;
end;

procedure TFFacture.EnabledPied;
var StC: string;
begin
	BintegreExcel.visible := (Action<>taConsult) and (not DuplicPiece) and (not TransfoPiece); 
  StC := TOBPiece.GetValue('GP_REFCOMPTABLE');
  BZoomEcriture.Enabled := ((StC <> '') and (StC <> 'DIFF'));
  StC := TOBPiece.GetValue('GP_REFCPTASTOCK');
  BZoomStock.Enabled := ((StC <> '') and (StC <> 'DIFF'));
  BZoomSuivante.Enabled := ((Action <> taCreat) and (TOBPiece.GetValue('GP_DEVENIRPIECE') <> ''));
{
	MBCtrlFact.Visible :=
    ((VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA')='NOR') and
     (GetParamSoc ('SO_GCCONTROLEFACTURE')));
}
  MBCtrlFact.Visible :=
    ((VenteAchat = 'ACH') and (not IsTransformable(newNature)) and
     (GetParamSoc ('SO_GCCONTROLEFACTURE')));

  MBTarif.Enabled := ((GetInfoParPiece(NewNature, 'GPP_CONDITIONTARIF') = 'X') and (Action <> taConsult) and (VenteAchat = 'VEN'));
  MBTarifGroupe.Enabled := ((GetInfoParPiece(NewNature, 'GPP_CONDITIONTARIF') = 'X') and (Action <> taConsult));
  MBTarif.Visible := (VenteAchat = 'VEN');
  MBREPARTTVA.Visible := (VenteAchat = 'VEN') and (NewNature<>'ETU');
  MBDatesLivr.Enabled := (Action <> taConsult);
  //
  if (action <> taConsult) and (Pos(TobPiece.GetValue ('GP_ETATVISA'),'ATT;VIS')>0) and (JaiLeDroitTag (145910)) then
  begin
  	MnVisaPiece.Caption := 'Viser la pi�ce/Retirer le visa';
    MnVisaPiece.Enabled := true;
  end else
  begin
    MnVisaPiece.Enabled := false;
  end;
  //
  SGEDLigne.Visible := (Action = taConsult);
  if ctxAffaire in V_PGI.PGIContexte then MBDatesLivr.Visible := False;
  if (ctxMode in V_PGI.PGIContexte) and not (ctxFO in V_PGI.PGIContexte) then BNouvelArticle.visible := True;
  //CHR le 04/03/02
  if (ctxChr in V_PGI.PGIContexte) then BNouvelArticle.visible := False;
  // Modif BTp du 17/05/2001
  MBAnal.visible := False;
  MBModevisu.visible := False;
  {$IFDEF CHR}
  BImprimer.visible := True;
  {$ELSE}
  BImprimer.visible := (Action = TaConsult);
  {$ENDIF}
  BprixMarche.Visible := (VH_GC.BTPrixMarche) or (SaisieTypeAvanc) or (ModifAvanc);
  BArborescence.Visible := VH_GC.BTGestParag;
  BretenuGar.Enabled := (GestionRetenue) and (not RGMultiple(TOBPiece));
  BRetenuGar.visible := (GestionRetenue) and (not RGMultiple(TOBPiece)) and (VenteAchat = 'VEN') ;
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
    Bminute.visible := False;
    Bminute2.visible := False;
    BRetenuGar.Visible := false;
	  BCalculDocAuto.visible := True;
	  RecalculeDocument.visible := (not BCalculDocAuto.down);
  end else
  if (ModifAvanc) then
  begin
    BPrixMarche.hint := traduireMemoire('Saisie avancements');
    Bminute.visible := False;
    Bminute2.visible := False;
    BRetenuGar.Visible := false;
  end;
{$IFDEF BTP}
  EnabledPiedBtp (Self, TobPiece);
{$ENDIF}
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
  //BVentil.Enabled:=False ; BEche.Enabled:=False ; BInfos.Enabled:=False ; BPorcs.Enabled:=False ;
  BVentil.Enabled := False;
  BPorcs.Enabled := False;
  {$IFNDEF CHR}
  BEche.Enabled := False;
  BInfos.Enabled := False;
  {$ENDIF}

  if Action = taConsult then
  begin
    BActionsLignes.Visible := False;
    BSousTotal.Visible := False;
  end else
  begin
    BActionsLignes.Enabled := False;
    BSousTotal.Enabled := False;
  end;
{$IFDEF GRC}
if (ctxGRC in V_PGI.PGIContexte) then
   BZoomProposition.Enabled:=(TOBPiece.GetValue('GP_PERSPECTIVE')<>0) ;
{$ENDIF}
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
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True,-1, '', True);
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
//    SommationAchatDoc(TOBPiece, TOBLig);
//    SommationAchatDoc(TOBPiece, TOBL);
    ShowDetail(ARow);
  end;
  TOBLig.Free;
end;

procedure TFFacture.CegidModifPCI(ARow: integer);
var TOBL: TOB;
  Q: TQuery;
  StF: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('GL_ARTICLE') = '' then Exit;
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True,-1, '', True);
  if not Q.EOF then StF := Q.Fields[0].AsString else StF := '';
  Ferme(Q);
  if Pos('//PCI', StF) <= 0 then Exit;
  ModifCegidPCI(Action, TOBL);
end;

procedure TFFacture.CEGIDLibreTiersCom;
var Q: TQuery;
  StF: string;
begin
  Q := OpenSQL('SELECT US_FONCTION FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"', True,-1, '', True);
  if not Q.EOF then StF := Q.Fields[0].AsString else StF := '';
  Ferme(Q);
  if Pos('//TLC', StF) <= 0 then Exit;
  ModifCegidLibreTiersCom(Action, TobPiece);
  GP_REPRESENTANT.Text := TOBPiece.getvalue('GP_REPRESENTANT');
end;

procedure TFFacture.FlagDepot;
begin
  if (ctxMode in V_PGI.PGIContexte)  and not (ctxGPAO in V_PGI.PGIContexte)  then
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
  GP_REFEXTERNE.Visible := False;  
  GP_DATEREFEXTERNE.Visible := False; 
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
//  {$IFDEF CCS3}
//  GP_DOMAINE.Visible := False;
//  HGP_DOMAINE.Visible := False;
//  {$ENDIF}
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
var indice : integer;
		NewDoc : r_cledoc;
    Etab, UserDoc : string;
    LaTOBmetre : TOB;
begin
  // LS
  fPieceCoTrait.SetGrilleSaisie(false); 
  InitLivraisons; // nettoyage des lignes de livraisons a supprimer ou a modifier
  //modif FV du 20/02/2008
  //Controle de la capacit� de blocage du document en modification
	NumeroGUID := '';
  if (Action = taModif) and (not transfopiece) and (not DuplicPiece) then
  Begin
    UserDoc:='';
    NumeroGUID := BlocageDoc(cledoc.NaturePiece, CleDoc.Souche + ';' + IntToSTr(Cledoc.NumeroPiece), UserDoc);
    if NumeroGUID = 'BLOQUE' then
    Begin
      if (not V_PGI.Sav) and (not V_PGI.Superviseur) then
      Begin
        if (PgiAsk('Ce document est bloqu� par l''utilisateur '+ UserDoc +', vous ne pourrez l''ouvrir qu''en consultation !', 'Document Bloqu�') = mrYes) Then
        Begin
          Action := taConsult;
        End else
  			Begin
	      	PostMessage(Handle, WM_CLOSE, 0, 0); //on sort de la saisie
      		exit;
    		End;
      End else
      Begin
        if (PgiAsk('Ce document est bloqu� par l''utilisateur '+ UserDoc +', Voulez-vous le d�bloquer ?', 'Document Bloqu�') = mrYes) Then
        Begin
          NumeroGUID:=ForceDeblocageDoc(cledoc.NaturePiece, cledoc.Souche + ';' + IntToSTr(Cledoc.NumeroPiece));
        End else
          Action := taConsult;
      End;
    end
    else if NumeroGUID = 'ERREUR' then
    Begin
      Pgibox('Ouverture du document impossible. Contacter votre administrateur !', 'Verrou');
      PostMessage(Handle, WM_CLOSE, 0, 0);
      exit;
    end;
  end;
  //
	CalculPieceAutorise := True; // par defaut

{$IFDEF BTP}
  BCalculDocAuto.down := false;
  {$IFDEF LINE}
  BCalculDocAuto.Down := True;
  CalculPieceAutorise :=  True;
  RecalculeDocument.Visible := false;
  {$ENDIF}
{$ENDIF}

  CalculPieceAutorise := BCalculDocAuto.down;
	TitreInitial := Self.caption;
  if not BeforeShow(Self) then Exit;
  if (ctxMode in V_PGI.PGIContexte) then ModifiableLeMemeJour();
  GeneCharge := True;
  PasToucheDepot := False;
//  AutoCodeAff := True;
  ChangeComplEntete := False;
  LookLesDocks(Self);
  LoadLesGCS;
  // modif 02/08/2001
  ChargeFromNature; //EtudieColsListe ;
  DefiniModeCalcul;

  if (DuplicPiece) then
  	 begin
     if GP_ETABLISSEMENT.Value = '' then Etab := VH^.EtablisDefaut else Etab := GP_ETABLISSEMENT.Value;
     NewDoc.Naturepiece := NewNature;
     NewDoc.Souche := GetSoucheG(NewDoc.NaturePiece, Etab, GP_DOMAINE.Value);
     NewDoc.NumeroPiece := GetNumSoucheG(CleDoc.Souche);
  	 end
  else
  	 begin
  	 newDoc := cledoc;
  	 end;

  if ImpressionAutoriseViaTOB (Newdoc) then
  begin
  	IMPRESSIONTOB := TImprPieceViaTOB.create (Self);
  end else IMPRESSIONTOB := nil;
  FlagRepres;
  FlagDepot;
  FlagContreM;
  FlagDomaine;

  // Modif BTP
  DefinitionGrille;

  {$IFDEF BTP}
  // positionnement des actions sur document
  ModifieVariables := false;
  TheMetre.Action := Action;
  TheMetre.Duplic := DuplicPiece;
  TheMetre.User := V_PGI.User;

  // Gestion des metres (positionnement par defaut)
  TheMetre.Ouvrages := TOBOuvrage;
  TheMetre.Document := TOBPiece;
  //

  CopierColler.Activate;
  TheBordereauMen.Activate;
  {$ENDIF}

  // d�plac� LS Correction fiche qualit�  11546
  // repartition de TVA au 1/1000e
  TheRepartTva.TOBBases := TOBBases;
  TheRepartTva.TOBpiece := TOBPiece;
  TheRepartTva.TOBOuvrages := TOBOUvrage;
  // --
  fPieceCoTrait.TOBpiece := TOBPiece;
  fPieceCoTrait.TOBOuvrage := TOBOuvrage;
  fPieceCoTrait.Affaire := TOBAffaire;
  // --

  //Modif FV suite fiche Qualit� N� 11591 concernant blocage saisie si devis termin�.
  ControleFactureFinie(DuplicPiece,Action, cledoc.NaturePiece, CleDoc.Souche, IntToSTr(Cledoc.NumeroPiece));

  // --------------
  case Action of
    taCreat:
      begin
        InitEnteteDefaut(True);
        // pour definition des champs sup
        MemoriseChampsSupLigneETL (NewNature,true);
  			MemoriseChampsSupLigneOUV (NewNature);
        // --
        InitPieceCreation;
        {$IFDEF AFFAIRE}
        EtudieActivite(NewNature, Action,duplicpiece, GereActivite, DelActivite);
        {$ENDIF}
        EtudieColsListe;
      end;
    taModif:
      begin
        MemoriseChampsSupLigneETL (cledoc.NaturePiece,true);
  			MemoriseChampsSupLigneOUV (cledoc.NaturePiece);
        ChargeLaPiece;
        // d�plac� LS Correction fiche qualit�  11546
        TheRepartTva.Charge; // voila voila
{$IFDEF BTP}
  			WarningSiPrevisionnel (self,TOBpiece,TOBLienDEVCHA);
{$ENDIF}
        if Action <> TaConsult then GereVivante;
        EtudieReliquat;
        {$IFDEF AFFAIRE}
        EtudieActivite(NewNature, Action,duplicpiece, GereActivite, DelActivite);
        {$ENDIF}
        AppliqueTransfoDuplic;
        BloquePiece(Action, True);
        if ((not TransfoPiece) and (not DuplicPiece) and (CleDoc.Indice > 0)) then GP_DATEPIECE.Enabled := False;
        //mcd 08/02/02 interdit delete sur FPR et APR  si affaire(passer par la ligne du menu qui fait des traitements
        if (ctxscot in V_PGI.PGIContexte) or (ctxaffaire in V_PGI.PGIContexte) or (VH_GC.GASeria) then
        begin
          if (CleDoc.NaturePiece = 'FPR') or (Cledoc.Naturepiece = 'APR') then BDelete.Visible := false;
        end;
//  			TypeFacturation := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));

        {$IFDEF GPAO}
        if (GetInfoParpiece(cledoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
        begin
          if (not TransfoPiece) and (ExistPieceOrigine(TobPiece) = false) and (uOkModifPiece(TobPiece) = false) then
            BDelete.visible := False
          else if TransfoPiece then
            BDelete.visible := False;
        end;
        {$ENDIF GPAO}

        //InitSaisieAveugle;
      end;
    taConsult:
      begin
        ChargeLaPiece;
        // d�plac� LS Correction fiche qualit�  11546
        TheRepartTva.Charge; // voila voila
{$IFDEF BTP}
(*        PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
        CalculPieceAutorise := true;
        CalculeLaSaisie(-1, -1, true);
        if (not BCalculDocAuto.down) then CalculPieceAutorise := false;
        TOBPiece.PutEcran(Self); *)
{$ENDIF}
        BloquePiece(Action, True);
        BImprimer.Visible := True;
        Caption := 'Consultation de pi�ce'; // DBR Fiche 10490
      end;
  end;
  SetPieceMajStockPhysique;
  InitSaisieAveugle; //Saisie Code Barres
  if VH_GC.GCIfDefCEGID then
     if ((Action <> taConsult) and (not V_PGI.Superviseur) and (not DuplicPiece)) then GP_DATEPIECE.Enabled := False;
  FlagEEXandSEX;

  AffecteGrid(GS, Action);
  {$IFNDEF BTP}
  if Action = taConsult then
  begin
  	GS.MultiSelect := False;
  end;
  {$ENDIF}

  ChargeAffairePiece(False, False, True);

  if not PieceControleModifie then
  begin
    InitPasModif;
  end;
  EnabledPied;
  GereEnabled(1);
  GeneCharge := False;
  AfterShow(Self);

{$IFDEF BTP}
  TheDestinationLiv.document := TOBPiece;
  TheDestinationLiv.affaire  := TOBAffaire;
  TheDestinationLiv.Tiers  := TOBTiers;
  TheDestinationLiv.grid  := GS;
  //
  if Action = TaCreat then
  begin
    TheLivFromRecepStock.Document := TOBPiece;
    TheLivFromRecepStock.Affaire := TOBAffaire;
  end;


{$ENDIF}

  TraiteAffaireParam;
  TraiteTiersParam;

  ErgoGCS3;
  if NewNature = 'FFO' then BNouvelArticle.Visible := False;
  bAppelControleFacture := GetParamSoc ('SO_GCCONTROLEFACTURE'); // pour que l'appel suivant a GSenter n'appelle pas le controle facture
  // Modif BTP
  PersonnalisationBtp;
  // VARIANTE
  TheVariante.Tiers  := TOBTiers;
  TheVariante.document:= TOBpiece;
  TheVariante.Ouvrage := TOBOuvrage;
  TheVariante.OuvragesP  := TOBOuvragesP;
  TheVariante.affaire := TOBAffaire;
  TheVariante.Bases   := TOBBases;
  TheVariante.BasesL  := TOBBasesL;
  TheVariante.Devise  := DEV;
  TheVariante.PieceTrait := TOBPieceTrait;
  // ---
  TheApplicDetOuv.document := TOBpiece;
  TheApplicDetOuv.Ouvrages := TOBOuvrage;
  // -----
  fModifSousDetail.TOBpiece := TOBpiece;
  fModifSousDetail.TOBOuvrages := TOBOUvrage;
  fModifSousDetail.TOBaffaire := TOBAffaire;
  fModifSousDetail.TOBTiers  := TOBTiers;
  fModifSousDetail.TOBArticles  := TOBArticles;
  fModifSousDetail.DEV  := DEV;
  // --
  if tModeSaisieBordereau in SaContexte then TheBordereauMen.Piece := TOBPiece;
  if (Action = taModif) or (action = taConsult) then
    if Not IsTransfert(NewNature) then GSEnter(Self);
  {$IFDEF BTP}
  // gestion du copier-coller
  with CopierColler do
  begin
    SetTobs(TOBPiece, TOBSerie, TOBdesLots, TOBAdresses, TOBArticles, TOBAffaire,
      TOBCatalogu, TOBNomenclature, TOBOUvrage, TOBCpta, TOBTiers, TOBAnaS, TOBAnaP,TOBBases,TOBBasesL);
    SetInfoDocument(GereLot, GereSerie, false, SaContexte, DEV);
  end;
  if GereDocEnAchat then
  begin
  	AfficheZonePiedAchat;
    if ((TOBPiece.getValue('GP_NATUREPIECEG')='PBT') or (TOBPiece.getValue('GP_NATUREPIECEG')='CBT')) and (TOBPiece.findFirst(['GL_TYPELIGNE'],['ARV'],true) <> nil) then
    begin
    	TOBPiece.AddChampSupValeur ('COEFFGFORCE',Valeur(LTOTALPORTSDEV.Caption),false);
    end;
  end;
  {$ENDIF}
  // ---
  bAppelControleFacture := false;

  {$IFDEF BTP}
  if GetParamSocSecur('SO_METRESEXCEL',true) then
  begin
    // gestion des variables des m�tr�s
    if (GetParamSoc('SO_BTMETREDOC')) and (not OrigineEXCEL) then
    begin
      if (cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
         (cledoc.NaturePiece = 'FBT') or
         (cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION')) then
      begin
        TheMetre.ChargementVariables(CleDoc);
        Complmentvariables1.enabled := true;
      end else
      begin
        Complmentvariables1.enabled := false;
      end;
    end else
    begin
      Complmentvariables1.enabled := false;
    end;
  end else
  begin
  	Complmentvariables1.enabled := false;
  end;


  TheRgpBesoin.TobPiece := TOBPiece;
  TheRgpBesoin.GS := GS;
  TheRgpBesoin.ReajusteGrid;
  DefiniRowCount ( self,TOBPiece);
  // d�plac� LS Correction fiche qualit�  11546
  (*
  // repartition de TVA au 1/1000e
  TheRepartTva.TOBBases := TOBBases;
  TheRepartTva.TOBpiece := TOBPiece;
  TheRepartTva.TOBOuvrages := TOBOUvrage;
  TheRepartTva.Charge; // voila voila
  *)
  // gestion de paragraphe
  TheGestParag.Piece := TOBpiece;
  TheGestParag.Tiers := TOBtiers;
  TheGestParag.Affaire := TOBAffaire;
  //
  TheGestRemplArticle.Piece := TOBpiece;
  TheGestRemplArticle.Tiers := TOBtiers;
  TheGestRemplArticle.Affaire := TOBAffaire;
  TheGestRemplArticle.Articles := TOBArticles;
  TheGestRemplArticle.Ouvrage  := TOBOuvrage;
  TheGestRemplArticle.OuvrageP   := TOBOuvragesP;
  TheGestRemplArticle.PiedBase := TOBBases;
  TheGestRemplArticle.LigneBase := TOBBasesL;
  TheGestRemplArticle.PieceTrait  := TOBPieceTrait;
	fPieceCoTrait.SetSaisie; // positionnement des elements de saisie
  //
  if Action = TaConsult then
  begin
    GS.OnCellEnter := nil;
    GS.OnCellExit := nil;
  end;
  {$ENDIF}

  if ImpressionAutoriseViaTOB (Cledoc) then
  begin
    LaTOBmetre := nil;
    if GetParamSocSecur('SO_METRESEXCEL',true) then
    begin
    	if TheMetre <> nil then LaTOBmetre := TheMetre.TOBMetre;
    end;
    IMPRESSIONTOB.associeTOBs (TOBPiece,TOBBases,TOBEches,TOBPorcs,TOBTiers,
                               TOBArticles,TOBComms,TOBAdresses,TOBNomenClature,
                               TOBDesLots,TOBSerie,TOBAcomptes,TOBAffaire,TOBOuvrage,TOBLienOle,
                               TOBPieceRg,TOBBasesRG,TOBFormuleVar,LaTOBMetre ,TheRepartTva.Tobrepart,TOBmetres,TOBTimbres);
  end;
  // marre des boucle sans fin dans le thgrid
  // pallie le bug du thgrid en consultation lorsque une des colonnes est positionne en collengths=-1
  if Action = TaConsult then
  	 begin
     for Indice := 0 to GS.ColCount -1 do
    		 begin
	       if GS.ColLengths [Indice] = -1 then GS.ColLengths [Indice] := 0;
   			 end;
  	 end;

  CacheTotalisations (false);

{$IFDEF LINE}
	AfterShowForLine (self, TOBPiece.getValue('GP_NATUREPIECEG'));
{$ENDIF}
  // COrrection FQ 12300 -
  if (Action = taModif) and (not DuplicPiece) then
  begin
    GP_ETABLISSEMENT.Enabled := not(Multicompteur(TOBPiece.getValue('GP_NATUREPIECEG')));
  end;

  if (Action=taCreat) and (DomaineSoc <> '') then
  begin
  	TOBPIece.putValue('GP_DOMAINE',DomaineSoc);
    GP_DOMAINE.Value := DomaineSoc;
    GP_DOMAINE.enabled := false;
  end;
  if GP_AFFAIRE.text <> '' then
  begin
  	GP_AFFAIRE0.Text := Copy (GP_AFFAIRE.text,1,1);
  end else
  begin
  	GP_AFFAIRE0.Text := StatutAffaire;
  end;
  if GP_AFFAIRE0.Text = 'P' then
	   HGP_AFFAIRE.caption := 'Appel d''Offre'
  Else if GP_AFFAIRE0.Text = 'I' then
	   HGP_AFFAIRE.caption := 'Contrat'
  Else   if GP_AFFAIRE0.Text = 'W' then
	   HGP_AFFAIRE.caption := 'Appel'
	Else
     HGP_AFFAIRE.caption := 'Chantier';

  HGP_AFFAIRE__.caption := HGP_AFFAIRE.caption;
  if TOBPiece.GetValue('ESCREMMULTIPLE')='X' then
  begin
  	GP_REMISEPIED.enabled := false;
  	GP_ESCOMPTE.enabled := false;
  end;
  if transfoPiece then
  begin
    Bimprimer.Visible := false;
  end;
  GS.Invalidate;
  HMTrad.ResizeGridColumns(GS);
  SetLargeurColonnes;
  //
  if (IsPieceGerableCoTraitance (TOBpiece,TOBaffaire)) and (TOBPieceTrait.detail.count = 0) then
  begin
    SetTOBpieceTrait(TOBpiece,TOBpieceTrait);
  end;
  //
  //  En entrant dans la pi�ce, positionnement syst�matique dans l'ent�te en fonction des champs accessibles
  GotoEntete;

end;

procedure TFFacture.NeRestePasSurDim(ARow : integer);
var TOBL : TOB;
    Cancel : boolean;
begin   // Fiche qualit� 11060
  if Not (ctxMode in V_PGI.PGIContexte) then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if (TOBL = Nil) then Exit;
  if (TOBL.GetValue('GL_TYPEDIM') = 'GEN') or (TOBL.GetValue('GL_TYPEDIM') = 'UNI') then
  begin
    GS.Col := SG_RefArt; GS.Row := GS.Row + 1;
    TOBL := GetTOBLigne(TOBPiece, GS.Row);
    While (TOBL <> Nil) and (TOBL.GetValue('GL_TYPEDIM') = 'DIM') do
    begin
      GS.Row := GS.Row + 1;
      TOBL := GetTOBLigne(TOBPiece, GS.Row);
    end;
    GSRowEnter(Self, GS.Row, Cancel, False);
  end;
end;

procedure TFFacture.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var OkG, Vide: Boolean;
	ACol,Arow : integer;
begin
  OkG := (Screen.ActiveControl = GS);
  Vide := (Shift = []);
  case Key of
    VK_RETURN: if ((OkG) and (Vide)) then
      begin
        if (ctxMode in V_PGI.PGIContexte) then SendMessage(GS.Handle, WM_KeyDown, VK_DOWN, 0)
        else Key := VK_TAB;
      end;
    VK_F5: if ((OkG) and (Vide)) then
      begin
        Key := 0;
        ZoomOuChoixArt(GS.Col, GS.Row);
      end;
    VK_INSERT: if ((OkG) and (Vide)) then
      begin
        Key := 0;
        if IsSousDetail ( Dessus(GS.row)) and IsSousDetail(Courante(GS.row)) then
        begin
        	ClickInsert(GS.Row,true);
        end else if IsSousDetail ( Dessus(GS.row)) and (not IsSousDetail(Courante(GS.row)))  then
        begin
        	DemandeModeInsert;
        end else if ( not IsSousDetail ( Dessus(GS.row))) and (IsSousDetail(Courante(GS.row)))  then
        begin
        	ClickInsert(GS.Row,true);
        end else
        begin
        	ClickInsert(GS.Row);
        end;
      end;
    VK_DELETE: if ((OkG) and (Shift = [ssCtrl])) then
      begin
        Key := 0;
        TSupLigneClick(nil);
      end;
    VK_F9:
      if Shift = [ssShift] then
      begin
        if VH_GC.GCIfDefCEGID then
        begin
          Key := 0;
          CEGIDModifPCI(GS.Row);
        end else
        begin
          Key := 0;
          ModifPrixAchat(GS.Row);
        end;
      end;
    VK_F11: if VH_GC.GCIfDefCEGID then if Shift = [ssShift] then
      begin
        Key := 0;
        CEGIDLibreTiersCom;
      end;
    VK_F10: if Vide then
      begin
        Key := 0;
        {$IFDEF GESCOM} if (Action=taCreat) and (Not DejaRentre) then GotoGrid(True,True) else {$ENDIF}
{$IFDEF BTP}
        BouttonInVisible;
				ClickValideAndStayHere (Self,TOBPiece, TOBNomenclature, TobOuvrage,TOBTiers, TOBAffaire,TOBLigneRg);
        Arow := GS.row;
        Acol := GS.col;
        GoToLigne(Arow,Acol);

        GS.row := Arow;
        GS.col := Acol;
        StCellCur := GS.Cells[GS.Col, GS.Row];
        BouttonVisible(GS.Row);

{$ELSE}
				ClickValide;
{$ENDIF}
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
    VK_NEXT : if Shift = [ssCtrl] then
      begin
        Key := 0;
        GotoGrid(True,False) ;
      end;
    VK_PRIOR : if Shift = [ssCtrl] then
      begin
        Key := 0;
        GotoGrid(False,False) ;
      end;
    VK_RIGHT : if Shift = [ssCtrl] then
      begin
        Key := 0;
        AnalyseDollar(GS.Row);
      end;
    {Ctrl+D} 68: if Shift = [ssCtrl] then
      begin
        Key := 0;
        AppelleDim(GS.Row);
      end else if Shift = [ssAlt] then
      begin {Alt+D}
        Key := 0;
        TCommentEntClick(nil);
      end;
    {Alt+E} 69: if Shift = [ssAlt] then
      begin
        Key := 0;
        BEcheClick(nil);
      end else if Shift = [ssCtrl] then
      begin {Ctrl+E}
        Key := 0;
        CpltEnteteClick(nil);
      end;
    {Alt+F} 70: if Shift = [ssAlt] then
      begin
        Key := 0;
        TCommentPiedClick(nil);;
      end;
    {Ctrl+L} 76: if Shift = [ssCtrl] then
      begin
        Key := 0;
        CpltLigneClick(nil);
      end ;
    {Ctrl+Q} 81 : if Shift=[ssCtrl] then
      begin
        Key:=0 ;
        RappelFormuleQte(GS.Row) ;
      end;
    {Ctrl+R} 82: if Shift = [ssCtrl] then
      begin
        Key := 0;
        if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') then
        begin
          PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
          exit;
        end;
        if IsDejaFacture then
        begin
          PGIBox('IMPOSSIBLE : Une facturation � d�j� �t� effectu� sur ce devis');
          exit;
        end;
        ChangeRegime;
      end;
    {Ctrl+T} 84: if Shift = [ssCtrl] then
      begin
        Key := 0;
        ChangeTva;
      end;
    {$IFDEF BTP}
    {Ctrl+O} 79: if Shift = [ssCtrl] then
      begin
        Key := 0;
        DetailOuvrageClick(self);
      end;
    {Ctrl+Shift+F2} Vk_F2: if Shift = [ssCtrl,ssShift] then
      begin
        Key := 0;
				ModebordereauClick (self);
      end;
    {$ENDIF}
  end;
end;

procedure TFFacture.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var Ctrl : TWinControl ;
	Req : String;
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
    if HPiece.Execute(6, Caption, '') <> mrYes then
       CanClose := False
    else
      Begin
       {$IFDEF BTP}
       // suppression des infos du fichiers variables document si annulation
       // en mode cr�ation
      if (cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
      	 (cledoc.NaturePiece = 'FBT') or
         (cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION')) then
      begin
  			if GetParamSocSecur('SO_METRESEXCEL',true) then
        begin
        	TheMetre.annulation;
        end;
      end;
      if Action = tacreat then
        begin
          Req := 'DELETE FROM BVARDOC WHERE BVD_NATUREPIECE="' + CleDoc.NaturePiece + '"'
                                    + ' AND BVD_SOUCHE="' + CleDoc.Souche + '"'
                                    + ' AND BVD_NUMERO=' + IntToStr(CleDoc.NumeroPiece)
                                    + ' AND BVD_INDICE=' + IntToStr(CleDoc.Indice);
          ExecuteSQL(Req);
//    			if Cledoc.Naturepiece = VH_GC.AFNatProposition then BTPSupprimePieceFrais (cledoc);
        end else
        begin
    			if ((Cledoc.Naturepiece = VH_GC.AFNatProposition) or (Cledoc.Naturepiece = VH_GC.AFNatAffaire)) and
          		(TOBPiece.getValue('_NEWFRAIS_')='X') then
          begin
          	// annulation de la saisie en cours et document avec nouvelle piece de frais associ�e
            // on supprime donc la piece de saisie associ�e
          	BTPSupprimePieceFrais (tobpiece);
          end;
        end;
       {$ENDIF}
       DetruitNewAcc;
	  end
  end;
  // OT 08/10/2003 : pour s'assurer de la validit� du contr�le en cours si c'est une date
  Ctrl := Screen.ActiveControl ;
  if (Ctrl<>nil) and (Ctrl.Parent<>nil) and (Ctrl.Parent=PEntete) then
    if (Ctrl is THCritMaskEdit) and (THCritMaskEdit(Ctrl).OpeType = otDate) then
      if TOBPiece.FieldExists(Ctrl.Name) then
        if THCritMaskEdit(Ctrl).Text <> DateToStr(TOBPiece.GetValue(Ctrl.Name)) then
          THCritMaskEdit(Ctrl).Text := DateToStr(TOBPiece.GetValue(Ctrl.Name));

  {$IFDEF BTP}
  if not OrigineEXCEL then
  begin
    // controle si le r�pertoire est vide ou non
    if (cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
      (cledoc.NaturePiece = 'FBT') or
      (cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION')) then
    begin
  		if GetParamSocSecur('SO_METRESEXCEL',true) then
      begin
      	TheMetre.ControleRepertoire;
      end;
    end;
  end;
  {$ENDIF}
end;

procedure TFFacture.ToutAllouer;
begin
  GS.RowCount := NbRowsInit;
  StCellCur := '';
  // Pi�ce
  TOBPiece := TOB.Create('PIECE', nil, -1);
  TOBPiece_O := TOB.Create('', nil, -1);
  TOBPiece_OS := TOB.Create('', nil, -1);
  TobPiece_OO := Tob.Create('', nil, -1);
  // Modif BTP
  AddLesSupEntete(TOBPiece);
  AddLesSupEntete(TOBPiece_O);
  // ---
  TOBAffaireInterv := TOB.Create ('LES CO-SOUSTRAITANTS',nil,-1);
  //
  TOBPieceTrait := TOB.Create ('LES LIGNES EXTRENALISE',nil,-1);
  TOBmetres := TOB.Create ('LES LIGNES METRES',nil,-1);
  TOBBasesL := TOB.Create('LES BASES LIGNES', nil, -1);
  TOBBases := TOB.Create('BASES', nil, -1);
  TOBBases_O := TOB.Create('', nil, -1);
  TOBBasesSaisies:=TOB.Create('BASES',Nil,-1);
  TOBEches := TOB.Create('Les ECHEANCES', nil, -1);
  TOBEches_O := TOB.Create('', nil, -1);
  TOBPorcs := TOB.Create('PORCS', nil, -1);
  TOBPorcs_O := TOB.Create('', nil, -1);
  TOBLigFormule:=TOB.Create('Formule ligne',Nil,-1);
  TOBLigFormule_O:=TOB.Create('',Nil,-1) ;
  TOBAFormule:=TOB.Create('Article Formule Qte',Nil,-1) ;
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
  {$IFDEF CHR}
  TOBHRDossier := TOB.Create('HRDOSSIER', nil, -1);
  TOBHrDossier.AddChampSup('HDR_HRDOSSIER', False);
  TOBHrDossier.AddChampSup('HDR_DOSRES', False);
  TOBHrDossier.AddChampSup('HDR_DATEARRIVEE', False);
  TOBHrDossier.AddChampSup('HDR_DATEDEPART', False);
  TOBHrDossier.AddChampSup('HDR_TIERS', False);
  TOBHrDossier.AddChampSup('HDR_NBPERSONNE1', False);
  TOBHrDossier.AddChampSup('HDR_RESSOURCE', False);
  TOBHrDossier.AddChampSup('MODIFICATIONTICKET', False);
  {$ENDIF}
  // Affaires
  TOBAffaire := TOB.Create('AFFAIRE', nil, -1);
  // Comptabilit�
  TOBCPTA := CreerTOBCpta;
  TOBANAP := TOB.Create('', nil, -1);
  TOBANAS := TOB.Create('', nil, -1);
  //Saisie Code Barres
  TOBGSA := TOB.Create('', nil, -1);
  // MODIF BTP
  // Ouvrages
  TOBOuvrage := TOB.Create('OUVRAGES', nil, -1);
  TOBOuvrage_O := TOB.Create('', nil, -1);
  // ouvrages Plat
  TOBOuvragesP := TOB.Create('LES OUVRAGES PLAT', nil, -1);
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
  TobLigneTarif := Tob.Create('_ENTETE_', nil, -1);
  TobLigneTarif_O := Tob.Create('', nil, -1);
  {
  PutLesSupEnteteLigneTarif(TobPiece, TobLigneTarif, TobLigneTarif_O);
  PutTobPieceInTobLigneTarif(TobPiece, TobLigneTarif);
  }
  {$IFDEF BTP}
  TOBLienDEVCHA := TOB.Create('LES LIENS DEVCHA', nil, -1);
  TheListPiecePrec := TOB.Create ('LES PIECES PRECEDENTES',nil,-1);
  (* OPTIMIZATION *)
  OptimizeOuv := TOptimizeOuv.create;
  (* ------------- *)
  {$ENDIF}
  //Affaire-Formule des variables
  TOBFormuleVar := TOB.Create('AFORMULEVAR', nil, -1);
  TOBFormuleVarQte := TOB.Create('', nil, -1);
  TOBFormuleVarQte_O := TOB.Create('', nil, -1);
  // OPTIMISATION
	TOBTablette := TOB.Create ('LA TABLETTE GCS',nil,-1);
  TOBLigneDel := TOB.Create ('LES LIGNE SUPPRIME',nil,-1);
  TOBLBasesDEL := TOB.Create ('LES LIGNES BASES DEL',nil,-1);
  TOBCONSODEL := TOB.create ('LES LIGNES DE CONSO DEL',nil,-1);
  TOBTimbres := TOB.Create ('LES TIMBRES',nil,-1);
  // --
end;

procedure TFFacture.ToutLiberer;
begin
  GS.VidePile(False);
  PurgePop(POPZ);
  TOBPiece.Free;
  TOBPiece := nil;
  TOBPiece_O.Free;
  TOBPiece_O := nil;
  TOBPiece_OS.Free;
  TOBPiece_OS := nil;
  TOBPiece_OO.Free;
  TOBPiece_OO := nil;
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
  //
  FreeAndNil(TOBmetres);
  //
  TOBBasesL.free;
  TOBBasesL := nil;
  TOBBases_O.Free;
  TOBBases_O := nil;
  TOBBasesSaisies.Free;
  TOBBasesSaisies:=Nil;
  TOBPorcs.Free;
  TOBPorcs := nil;
  TOBPorcs_O.Free;
  TOBPorcs_O := nil;
  TOBLigFormule.Free;
  TOBLigFormule := Nil;
  TOBLigFormule_O.Free ;
  TOBLigFormule_O := Nil;
  TOBAFormule.Free ;
  TOBAFormule := Nil ;
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
  TOBOuvragesP.free;
  TOBOuvragesP := nil;
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
  //Affaire-Formule des variables
  if TOBFormuleVar <> nil then
  begin
    TOBFormuleVar.free;
    TOBFormuleVar := nil;
  end;
  if TOBFormuleVarQte <> nil then
  begin
    TOBFormuleVarQte.free;
    TOBFormuleVarQte := nil;
  end;
  if TOBFormuleVarQte_O <> nil then
  begin
    TOBFormuleVarQte_O.free;
    TOBFormuleVarQte_O := nil;
  end;
  // Modif BTP
  if TOBLigneRG <> nil then
  begin
    TOBLigneRG.free;
    TOBLigneRG := nil;
  end;
  {$IFDEF BTP}
  TOBLienDEVCHA.free;
  OptimizeOuv.free;
  TheListPiecePrec.free;
  {$ENDIF}
  // --
  // ---------
  {$IFDEF CHR}
  if TOBHrdossier <> nil then
  begin
    TOBHrdossier.Free;
    TOBHrdossier := nil;
  end;
  if Tobregrpe <> nil then
  begin
    Tobregrpe.free;
    Tobregrpe := nil;
  end;
  {$ENDIF}

  if Assigned(TobLigneTarif) then
  begin
    TobLigneTarif.Free;
    TobLigneTarif := nil;
  end;
  if Assigned(TobLigneTarif_O) then
  begin
    TobLigneTarif_O.Free;
    TobLigneTarif_O := nil;
  end;
  // OPTIMISATION
	TOBTablette.free;
  // --
  TOBLigneDel.free;   TOBLigneDel := nil;
  TOBLBasesDEL.free; TOBLBasesDEL := nil;
  TOBCONSODEL.free; TOBCONSODEL := nil;
	FreeAndNil(TOBPieceTrait);
  FreeAndNil(TOBAffaireInterv);
  FreeAndNil(TOBTimbres);
end;

procedure TFFacture.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // VARIANTE
  // dans cet ordre du fait de l'ordre de cr�ation
  fModifSousDetail.free;
  fPieceCoTrait.free;
	FreeAndNil(TOBpieceFraisAnnule);
  TheApplicDetOuv.free;
  TheGestRemplArticle.free;
  TheGestParag.free;
  TheBordereauMen.free;
  TheBordereau.free;
  TheVariante.free;
{$IFDEF BTP}
  TheRepartTva.free;
	TheRgpBesoin.free;
  TheDestinationLiv.free;
  TheLivFromRecepStock.free;
{$ENDIF}
  // ----
  CopierColler.Free;
  PPInfosLigne.Clear;
  PPInfosLigne.Free;
  PPInfosLigne := nil;
  ToutLiberer;
  {$IFDEF BTP}
  TheMetreShare := nil;
  TheMetre.free; // on ne peut pas le mettre dans le ToutLiberer car non cr�� dans ToutAllouer
  TheMetre := nil;
  GestionConso.free;
  {$ENDIF}
	if IMPRESSIONTOB <> nil then BEGIN IMPRESSIONTOB.free; IMPRESSIONTOB := nil; END;
  if IsInside(Self) then Action := caFree;
  FClosing := TRUE;
  // --
  // OPTIMISATIONS
  ReinitTOBAffaires;
  // --

  //Suppression Fichier Blocage !!!!
  SupprimeBlocageDoc(NumeroGUID, cledoc.NaturePiece, cledoc.Souche + ';' + IntToSTr(Cledoc.NumeroPiece));
  NumeroGUID := '';
	InitDomaineAct;
  PieceTraitUsable := false;
  TOBOLDL.free;
  LibereParamTimbres;
end;

{==============================================================================================}
{=============================== Actions li�es au Grid ========================================}
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
  RCol.SG_Unit := SG_Unit;
  RCol.SG_Montant := SG_Montant;
  RCol.SG_MontantsIT := SG_MontantSit;
  RCol.SG_MontantMarche := SG_MontantMarche;
  RCol.SG_DateLiv := SG_DateLiv;
  RCol.SG_Total := SG_Total;
  RCol.SG_QR := SG_QR;
  RCol.SG_Motif := SG_Motif;
  RCol.SG_QReste := SG_QReste; { NEWPIECE }
  Rcol.SG_CIRCUIT := SG_CIRCUIT ;
  {$IFDEF CHR}
  RCol.SG_Folio := SG_Folio;
  RCol.SG_DateProd := SG_DateProd;
  RCol.SG_Regrpe := SG_Regrpe;
  RCol.SG_LibRegrpe := SG_LibRegrpe;
  {$ENDIF}
	RCol.Sg_TYPA := SG_TYPA;
  {$IFDEF BTP}
  RCol.SG_REFTiers := SG_REFTiers;
  RCol.SG_DETAILBORD := SG_DETAILBORD;
  (* Correction LS sur les plantage adresse 0000000
  RCol.TheMetre := TheMetre;
  TheMetre := Nil;
  RCol.IMPRESSIONTOB := IMPRESSIONTOB;
  IMPRESSIONTOB := Nil;
  *)
  TheMetreShare := nil; // pour reinitialiser pour le nouveau document
  {$ENDIF}
  RCol.SG_PxAch := SG_PXAch;
  RCol.SG_MontantAch := SG_MontantAch;
  RCol.SG_DEJAFACT := SG_DEJAFACT;
  Rcol.SG_QTEPREVUE := SG_QTEPREVUE;
  Rcol.SG_QTESITUATION := SG_QTESITUATION;
  Rcol.SG_POURCENTAVANC := SG_POURCENTAVANC;
  Rcol.SG_MontantSit := SG_MontantSit;
  Rcol.SG_MontantMarche := SG_MontantMarche;
  RCOL.SG_MTDEJAFACT := SG_MTDEJAFACT;
  RCOL.SG_TEMPS := SG_TEMPS;
  RCOL.SG_TEMPSTOT := SG_TEMPSTOT;
  RCOL.SG_QUALIFTEMPS := SG_QUALIFTEMPS;
  RCOL.SG_CODTVA1 := SG_CODTVA1;
  RCOL.SG_NATURETRAVAIL := SG_NATURETRAVAIL;
  RCOL.SG_FOURNISSEUR := SG_FOURNISSEUR;
  RCOL.SG_VOIRDETAIL := SG_VOIRDETAIL;
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
  SG_Unit := RCol.SG_Unit;
  SG_Montant := RCol.SG_Montant;
  SG_MontantSit := RCol.SG_MontantSit;
  SG_MontantMarche := Rcol.SG_MontantMarche;
  SG_DateLiv := RCol.SG_DateLiv;
  SG_Total := RCol.SG_Total;
  SG_QR := RCol.SG_QR;
  SG_Motif := RCol.SG_Motif;
  SG_QReste := RCol.SG_QReste; { NEWPIECE }
  SG_CIRCUIT := Rcol.SG_CIRCUIT ;
  {$IFDEF CHR}
  SG_Folio := RCol.SG_Folio;
  SG_DateProd := RCol.SG_DateProd;
  SG_Regrpe := RCol.SG_Regrpe;
  SG_LibRegrpe := RCol.SG_LibRegrpe;
  {$ENDIF}
	SG_TYPA := RCol.Sg_TYPA;
  {$IFDEF BTP}
  SG_REFTiers := RCol.SG_REFTiers;
  SG_DETAILBORD := RCol.SG_DETAILBORD;
  //
  TheMetreShare := TheMetre; // restitution du contexte en retour
	//
  {$ENDIF}
  SG_PxAch := RCOl.SG_PXAch;
  SG_MontantAch := RCol.SG_MontantAch;
  SG_DEJAFACT := RCol.SG_DEJAFACT;
  SG_QTEPREVUE := Rcol.SG_QTEPREVUE;
  SG_QTESITUATION:= rcol.SG_QTESITUATION ;
  SG_POURCENTAVANC:= Rcol.SG_POURCENTAVANC;
  SG_MontantSit:= Rcol.SG_MontantSit ;
  SG_MontantMarche := Rcol.SG_MontantMarche;
  SG_MTDEJAFACT := RCol.SG_MTDEJAFACT;
  SG_TEMPS := RCOL.SG_TEMPS;
  SG_TEMPSTOT := RCOL.SG_TEMPSTOT;
  SG_QUALIFTEMPS := RCOL.SG_QUALIFTEMPS;
  SG_CODTVA1 := RCOL.SG_CODTVA1;
  SG_NATURETRAVAIL := RCOL.SG_NATURETRAVAIL;
  SG_FOURNISSEUR := RCOL.SG_FOURNISSEUR;
  SG_VOIRDETAIL := RCOL.SG_VOIRDETAIL;

	MemoriseChampsSupLigneETL (cledoc.NaturePiece,true);
  MemoriseChampsSupLigneOUV (cledoc.NaturePiece);
end;

procedure TFFacture.EtudieColsListe;
var i: integer;
  Nam, St, StFind, FF, FFP,FFM: string;
  ColAligns: array[0..200] of TAlignment;
begin

//  LesColonnes := GS.Titres[0];
  LesColonnes := lesColonnesVte;
  GS.titres[0] := LesColonnes;
  if not GP_FACTUREHT.Checked then
  begin
    LesColonnes := FindEtReplace(LesColonnes, 'GL_PUHTDEV', 'GL_PUTTCDEV', False);
    LesColonnes := FindEtReplace(LesColonnes, 'GL_TOTALHTDEV', 'GL_TOTALTTCDEV', False);
    LesColonnes := FindEtReplace(LesColonnes, 'GL_MONTANTHTDEV', 'GL_MONTANTTTCDEV', False);
    // ajout 02/08/2001
    LesColonnes := FindEtReplace(LesColonnes, 'GL_PUHTNETDEV', 'GL_PUTTCNETDEV', False);
    GS.Titres[0] := LesColonnes;
    (*
    LesColonnesVte := lesColonnes;
    LesColonnesAch := lesColonnes;
    DefinieColonnesAchatBtp(self);
    *)
  end;
//	MemoriseListeSaisieBTP (Self);
//  DefinieColonnesAchatBtp(self);
{$IFDEF BTP}
  if (SaisieTypeAvanc) and (CleDoc.NaturePiece <> 'PBT') then
  begin
    LesColonnes := FindEtReplace(LesColonnes, 'GL_TOTPREVDEVAVAN', 'MONTANTSIT', False);
    LesColonnesVte := FindEtReplace(LesColonnesVte, 'GL_TOTPREVDEVAVAN', 'MONTANTSIT', False);
    GS.Titres[0] := LesColonnes;
  end;
  (*
  if ModifAvanc then
  begin
    LesColonnes := FindEtReplace(LesColonnes, 'GL_QTESIT', 'DEJAFACT', False);
    LesColonnesVte := FindEtReplace(LesColonnes, 'GL_QTESIT', 'DEJAFACT', False);  // on memorise
  end;
  *)
{$ENDIF}
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
  {$IFDEF BTP}
  if GereDocEnAchat then
  begin
    PositionneDocAchatBtp ( Self);
  end else
  begin
    PositionneDocVenteBtp ( Self);
  end;
  {$ENDIF}
  St := LesColonnes;
  SetLargeurColonnes;
  if GereContreM then
  begin
    GS.Cells[SG_ContreM, 0] := 'Cqe';
    GS.ColWidths[SG_ContreM] := GS.ColWidths[SG_NL];
    GS.ColFormats[SG_ContreM] := '-1';
//    HMTrad.ResizeGridColumns(GS);
  end;
  if SG_RefArt > 0 then GS.ColLengths[SG_RefArt] := 18;
{$IFDEF BTP}
	if SG_REFTiers > 0 then GS.colLengths[SG_REFTiers] := 18;
	if (SG_DETAILBORD > 0) and (Action <> taConsult) then GS.colLengths[SG_DETAILBORD] := -1;
  if (SG_QUALIFTEMPS > 0) and (action <> taconsult) then GS.Collengths[SG_QUALIFTEMPS] :=-1;
	if (SG_CODTVA1 > 0) and (action <> taconsult) then GS.Collengths[SG_CODTVA1] :=-1;
  if (SG_TypA > 0) then GS.colwidths[SG_TypA] := 36;
  {$ENDIF}
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
    FF := '#0.';
    for i := 1 to V_PGI.OkDecQ - 1 do
    begin
      FF := FF + '0';
    end;
    FF := FF + '0';
  end;

  if V_PGI.OkDecV > 0 then
  begin
    FFM := '#0.00';
  end;

  FFP := '#';
  if V_PGI.OkDecP > 0 then
  begin
    FFP := '0.';
    for i := 1 to V_PGI.OkDecP - 1 do
    begin
      FFP := FFP + '#';
    end;
    FFP := FFP + '0';
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

    if (Nam = 'GL_PUHTDEV') or (Nam = 'GL_PUTTCDEV') or
       (Nam = 'GL_PUHTNETDEV') or (Nam = 'GL_PUTTCNETDEV') or (Nam = 'GL_DPA') then GS.ColFormats[i] := FFP;

    if (Nam = 'GL_QTESTOCK') or (Nam = 'GL_QTEFACT') then GS.ColFormats[i] := FF; { NEWPIECE }
    if Nam = 'GL_QTERESTE' then
    begin
      GS.ColEditables[i] := False;
      GS.ColFormats[i] := FF; { NEWPIECE }
    end;
    if Nam = 'GL_MOTIFMVT' then GS.ColFormats[i] := 'CB=GCMOTIFMOUVEMENT';
    if Nam = 'GL_MONTANTPA' then  GS.ColFormats[i] := FFP;
    if Pos(Nam,'BLF_QTEMARCHE;BLF_QTEDEJAFACT')>0  then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColEditables[i] := False;
      GS.ColLengths[i] := -1;
      GS.ColFormats[i] := FF+';-'+FF+'; ;'; { NEWPIECE }
    end;
    if (Nam='BLF_MTMARCHE') then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColEditables[i] := False;
      GS.ColLengths[i] := -1;
      GS.ColFormats[i] := FFM+';-'+FFM+'; ;'; { NEWPIECE }
    end;
    if Nam='BLF_QTESITUATION' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColFormats[i] := FF+';-'+FF+'; ;'; { NEWPIECE }
    end;
    if Nam='BLF_POURCENTAVANC' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
    end;
    if Nam = 'DEJAFACT' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColEditables[i] := False;
      GS.ColFormats[i] := FF+';-'+FF+'; ;'; { NEWPIECE }
    end;
    if Nam = 'GL_QTEPREVAVANC' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColFormats[i] := FF+';-'+FF+'; ;'; { NEWPIECE }
    end;
    if Nam = 'GL_QTESIT' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColEditables[i] := False;
      GS.ColFormats[i] := FF+';-'+FF+'; ;'; { NEWPIECE }
    end;
    if Nam = 'MONTANTSIT' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColEditables[i] := False;
      GS.ColFormats[i] := FFM+';-'+FFM+'; ;'; { NEWPIECE }
    end;
    if Nam = 'BLF_MTSITUATION' then
    begin
      IdentCols[i].ColTyp := 'DOUBLE';
      GS.ColFormats[i] := FFM+';-'+FFM+'; ;'; { NEWPIECE }
    end;
    if Nam = 'GLC_NATURETRAVAIL' then
    begin
    	GS.ColEditables[i] := False;
      GS.Colwidths[i] := 20;
      GS.ColLengths[i] := 20;
      GS.AutoResizeColumn(i,20);
      GS.ColFormats[i] := 'CB=BTNATURETRAVAIL';
      GS.ColDrawingModes[i]:= 'IMAGE'
    end;
    if Nam = 'GLC_VOIRDETAIL' then
    begin
    	if ModifSousDetail then
      begin
        GS.ColEditables[i] := False;
        GS.Colwidths[i] := 25;
        GS.ColLengths [i] := 25;
        GS.AutoResizeColumn(i,25);
      end else
      begin
				GS.ColEditables[i] := False;
        GS.Colwidths[i] := -1;
      end;
    end;
    if Nam = 'GL_FOURNISSEUR' then
    begin
    	GS.ColEditables[i] := False;
    end;
  end;

  {$IFDEF BTP}
  if GereDocEnAchat then
  begin
    PositionneColonnesAchatBtp ( Self);
  end else
  begin
    PositionneColonnesVenteBtp ( Self);
  end;
  {$ENDIF}

  if (SG_TYPA <> -1) and (Action <> Taconsult) then GS.ColLengths[SG_TYPA] := -1;
{$IFDEF BTP}
  if (SG_DETAILBORD <> -1) and (Action <> TaConsult) then
  begin
  	GS.ColTypes [SG_DETAILBORD] := 'B' ;
    GS.colaligns[SG_DETAILBORD]:= tacenter;
    GS.colformats[SG_DETAILBORD]:= inttostr(Integer(csCoche));
  end;
{$ENDIF}
  if (SaisieTypeAvanc) or (ModifAvanc) then
  begin
    if (Sg_RefArt <> -1) or (Action <> Taconsult) then GS.ColLengths[SG_RefArt] := -1;
    if (SG_QF <> -1) and (Action <> TaConsult) then
    begin
    	if not ModifAvanc then
      begin
        GS.ColLengths[SG_QF] := -1;
        GS.ColLengths[SG_QF + 1] := -1;
        if Pos(TypeFacturation,'AVA;DAC;') = 0 then
        begin
          if SG_Montant <> -1 then
          begin
            GS.ColLengths[SG_Montant] := -1;
            GS.ColWidths [SG_MONTANT] := 0;
          end;
          if Sg_MontantSIt <> -1 then GS.ColLengths[SG_MontantSit] := -1;
          if SG_MontantMarche <> -1 then GS.ColLengths[SG_MontantMarche] := -1;
          if SG_MTDEJAFACT <> -1 then GS.ColLengths[SG_MTDEJAFACT]:=-1;
        end;
      end else
      begin
        GS.ColLengths[SG_QA] := -1;
        GS.ColLengths[SG_QA+1] := -1;
      end;
    end;
    if not ModifAvanc then
    begin
      if Sg_MontantSIt <> -1 then GS.ColLengths[SG_MontantSit] := -1;
    end;
    if SG_MontantMarche <> -1 then GS.ColLengths[SG_MontantMarche] := -1;
    if SG_MTDEJAFACT <> -1 then GS.ColLengths[SG_MTDEJAFACT]:=-1;

    if (SG_PCT <> -1) and (Action <> Taconsult) and (not ModifAvanc) then GS.ColLengths[SG_Pct + 1] := -1;
  end
  else
  begin
    if (SG_Unit <> -1)  and (Action <> TaConsult) then
    begin
      if (OrigineEXCEL) or (not PieceUniteautorisee (NewNature)) then
      begin
        GS.ColLengths[SG_Unit] := -1;
      end;
    end;
    {$IFDEF BTP}
    PositionneColonnesBtp ( Self , TOBPiece );
    {$ENDIF}
  end;
end;

function TFFacture.ZoneAccessible(ACol, ARow: Longint): boolean; { NEWPIECE }
var TOBA, TOBL: TOB;
  CodeA, TypeDim, PiecePrec: string;
  IndiceLot, IndiceSerie: integer;
  RemA, ligSup: boolean;
  WarningSuppression : boolean;
  CodeAT : string;
  Gestionreliquat : boolean;
begin
	WarningSuppression := false;
  Result := True;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
{$IFDEF BTP}
  //
  if (ACol=SG_RefArt) and (OrigineEXCEL) and (not IsSousDetail(TOBL)) then BEGIN Result := False; Exit end;
  if (ACol=SG_QF) and (OrigineEXCEL) and (not IsSousDetail(TOBL)) then BEGIN Result := False; Exit end;
  if (Acol=SG_VOIRDETAIL) then begin result := false; exit; end;
  if (Acol=SG_TYPA) then begin result := false; exit; end;
  if (Acol=SG_NATURETRAVAIL) or (Acol = SG_FOURNISSEUR) then begin result := false; exit; end;
  if (Acol=SG_TEMPS) and (pos(TOBL.getValue('GL_TYPEARTICLE'),'ARP;ARV')=0) then begin result := false; exit; end;
  if (Acol=SG_TEMPSTOT) and (pos(TOBL.getValue('GL_TYPEARTICLE'),'ARP;ARV')=0) then begin result := false; exit; end;
  if (SaisieTypeAvanc) and (Acol=SG_QA) and (TOBL.getValue('GL_QTEFACT')=0) then BEGIN result := false; Exit; END;
  //
  if (IsVariante (TOBL)) and ((SaisieTypeAvanc)or (ModifAvanc )) and (not IsPrevisionChantier (Tobpiece)) then BEGIN result := false; exit; END;
	if IsDetailBesoin (TOBL) then begin result := false; exit; end;
(*
  if Acol = SG_montantSit then
  begin
    Result := False;
    EXIT;
  end;
*)

  if SaisieTypeAvanc then Exit; // MODIF BRL AVANCEMENTS CHANTIERS
  GestionReliquat := (GetInfoParPiece (TOBPiece.GetValue('GP_NATUREPIECEG'),'GPP_RELIQUAT')='X');
  if ((Acol = SG_Px) and (TOBL.GetValue('GL_BLOQUETARIF')='X') and (not GereDocEnAchat)) Then begin result := false; exit; end;
  if (action = taModif) and (EstLigneArticle(TOBL)) and (EstLigneSoldee(TOBL)) AND (ACol <> SG_RefArt) then
  begin
    Result := False;
    EXIT;
  end;
{$ENDIF}
  if ACol = SG_QReste then { NEWPIECE }
  begin
    Result := False;
    EXIT;
  {V500_003 D�but}
  end
    else if (ACol = SG_QF) or (ACol = SG_QS) then
  begin
    { Ne pas pouvoir modifier la quantit� si Modification d'une ligne de pi�ce d�j� transform�e }
    Result := not ((Action = taModif) and (not TransfoPiece) and (TOBL.GetValue('GL_QTEFACT') >= 0)
                                                             and (TOBL.GetValue('GL_QTERESTE') < 0));
  end;
  {V500_003 Fin}
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
  {$IFDEF CHR}
  if (Tobhrdossier.FieldExists('MODIFICATIONTICKET') and
     (TobHRDossier.GetValue('MODIFICATIONTICKET') = 'X')) then
  begin
    if (SG_LibRegrpe > 0) and (Acol = SG_LibRegrpe) or (SG_Montant > 0) and (Acol = SG_Montant) then
    begin
      result := False;
      exit;
    end;
  end
  else
  begin
    if (copy(TOBL.GetValue('GL_REFCOLIS'), 5, 1) <> '') then
    begin
      result := False;
      exit;
    end;
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
    if (SG_DateProd > 0) and (Acol = SG_DateProd) then
    begin
      result := False;
      exit;
    end;
    if SG_DateProd > 0 then
    begin
      if (TOBL.GetValue('GL_DATEPRODUCTION') <> iDate1900) and
        (TOBL.GetValue('GL_DATEPRODUCTION') < V_PGI.DateEntree) then
      begin
        // les prix quantit�s dates ne sont pas modifiable
        if (Acol = SG_RefArt) or (Acol = SG_Qf) or (Acol = SG_Px) or (Acol = SG_DateProd) then
        begin
          result := False;
          exit;
        end;
      end else
      begin
        if (Acol = SG_Qf) then
        begin
          if ((TOBL.GetValue('GL_QTEFACT') < 0)
            and ((TOBL.GetValue('GL_REFCOLIS') = 'TRA') or (TOBL.GetValue('GL_REFCOLIS') = 'DED'))) then
            result := False;
          exit;
        end;
      end;
    end;
  end;
  {$ENDIF} // FIN CHR

{$IFDEF BTP}
 	if (Acol=SG_DETAILBORD) and (tModeSaisieBordereau in SaContexte) then
  begin
  	result := false;
    exit;
  end;
  if (Acol = SG_REFTiers) and (OrigineEXCEL) and (not IsSousDetail(TOBL)) and (tModeSaisieBordereau in SaContexte) then
  begin
  	result := false;
    exit;
  end;
{$ENDIF}
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
  (* VARIANTE
    TypeL := Copy(GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow), 1, 2);
    // VARIANTE
    if (TypeL = 'DP') or (TypeL = 'TP') then
  *)
    if Isparagraphe (TOBL) then
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
  if ((SaisieTypeAvanc) or (ModifAvanc)) and (TOBL.getValue('GL_TYPEARTICLE') = 'POU') then
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
  if (ACol = SG_Dep) then
  begin
    if PasToucheDepot then
    begin
      Result := False;
      Exit;
    end
    else
    begin
      if EstLigneArticle(TOBL) and WithPieceSuivante(TOBL) then
      begin
        { Pas de changement de d�p�t si la ligne est partiellement transform�e }
        Result := False;
        Exit;
      end;
    end;
  end;
  if (ACol = SG_ContreM) and (GS.Cells[ACol, ARow] = 'X') then
  begin
    Result := False;
    Exit;
  end;

  
  {$IFDEF GPAO}
  if (GetInfoParpiece(cledoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') and (Action = taModif) then
  begin
    if ((Acol = SG_Circuit) or (aCol = SG_Dep)) then
    begin
      if (not ControleCellModifSt(integer(TOBL.GetValue('GL_IDENTIFIANTWOL')))) then
      begin
        Result := False;
        exit;
      end;
    end
    else if (Acol = SG_RefArt) then
    begin
      if (not ControleCellModifSt(integer(TOBL.GetValue('GL_IDENTIFIANTWOL')))) then
      begin
        Result := False;
        exit;
      end;
    end;
  end;
  {$ENDIF GPAO}
  

  if CodeA = '' then
  begin
    {$IFDEF CHR}
    Result := ((ACol = SG_ContreM) or ((ACol = SG_RefArt) and (TOBL.GetValue('GL_TYPENOMENC') <> 'MAC')) or ((ACol = SG_Lib) and (TOBL.GetValue('GL_TYPENOMENC')
      <> 'MAC')) or (ACol = SG_DateLiv) or (ACol = Sg_Folio) or ((ACol = SG_Motif) and (TypeDim = 'GEN')) or ((ACol = SG_Regrpe) or (ACol = SG_Px) and
      (TOBL.GetValue('GL_TYPENOMENC') = 'MAC')));
    {$ELSE}
    if (tModeSaisieBordereau in SaContexte) and (SG_RefTiers <> -1) then
    begin
    	CodeAt := GS.cells [SG_RefTiers,GS.row];
    	if CodeAt = '' then
      begin
        Result := ((ACol = SG_ContreM) or (ACol = SG_RefArt) or (Acol = SG_RefTiers) or (ACol = SG_Lib) or (ACol = SG_DateLiv) or (ACol = Sg_Folio) or ((ACol = SG_Motif) and (TypeDim =
          'GEN')));
      end;
    end else
    begin
      Result := ((ACol = SG_ContreM) or (ACol = SG_RefArt) or (ACol = SG_Lib) or (ACol = SG_DateLiv) or (ACol = Sg_Folio) or ((ACol = SG_Motif) and (TypeDim =
        'GEN')));
    end;
    {$ENDIF} // FIN CHR
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

    // On ne peut pas changer la quantit� sur une ligne supprim�e
    if ((LigSup) and ((ACol = SG_QF) or (ACol = SG_QS))) then
    begin
      Result := False;
      Exit;
    end;

  end;
  if result then
  begin
    if ACol <> SG_RefArt then Result := CanModifyLigne(TOBL, TransfoPiece, TobPiece_O,WarningSuppression,GestionReliquat,Action);
  end;
end;

procedure TFFacture.ZoneSuivanteOuOk(var ACol, ARow: Longint; var Cancel: boolean);
var Sens, ii, Lim: integer;
  OldEna, ChgLig, ChgSens: boolean;
  RowFirst : integer;
begin
	RowFirst := ARow;
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
      if (tModeBlocNotes in SaContexte) or
          (SaisieTypeAvanc) or
          (ModifAvanc) then Lim := TOBPiece.Detail.Count else Lim := GS.RowCount - 1;
      // ---
      if ((ACol = GS.ColCount - 1) and (ARow >= Lim)) then
      begin
        {$IFDEF BTP}
        if (ChgSens) or (Action = TaConsult) then Break else
        begin
          InsertLigneInGrilleBtp (self,TobPiece,TobTiers,TOBAffaire,Arow,Acol);
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
  if (Arow <> RowFirst) then
  BEGIN
  	GSRowExit (self,RowFirst,cancel,false);
  	if Cancel then
    begin
    	GSRowEnter (self,RowFirst,cancel,false);
    end else
    begin
    	GSRowEnter (self,Arow,cancel,false);
    end;
  END;
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
begin
  St := GS.Cells[ACol, ARow];
  StC := St;
  if ((ACol = SG_RefArt) or (Acol=SG_REFTiers) or (ACol = SG_Rep) or (ACol = SG_Dep)  or (Acol = SG_CIRCUIT) ) then
    StC := uppercase(Trim(St)) else
//    if (ACol = SG_Px) or (ACol = SG_PxNet) then StC := StrF00(Valeur(St), DEV.Decimale) else // Modif MODE 31/07/2002
  if (ACol = SG_Px) or (ACol = SG_PxNet) or (Acol = SG_PxAch) then StC := StrF00(Valeur(St), V_PGI.OkDecP) else
  if ACol = SG_Rem then StC := StrF00(Valeur(St), ADecimP) else
  if ((ACol = SG_QF) or (ACol = SG_QS) or (ACol = SG_QA) or
  		(ACol = SG_QTEPREVUE) or (ACol = SG_DEJAFACT) or
      (Acol = SG_TEMPS) or (Acol = SG_TEMPSTOT) or
      (ACol = SG_QTESITUATION)) then //MODIFBTP
  begin
    StC := StrF00(Valeur(St), V_PGI.OkDecQ);
  end else
  if (ACol = SG_Aff) then {Affaire}
  begin
    StC := uppercase(Trim(St));
    {$IFDEF BTP}
    {$ELSE IF AFFAIRE}
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
{=============================== Ev�nements de le Grid ========================================}
{==============================================================================================}

procedure TFFacture.PostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);

  procedure TireLigne(DebX, DebY, FinX, FinY: integer);
  begin
    GS.Canvas.MoveTo(DebX, DebY);
    GS.Canvas.LineTo(FinX, FinY);
  end;

var ARect: TRect;
  Fix: boolean;
  TheText : string;
  PosX,PosY : integer;
  // modif BTP
  TOBL: TOB;
begin
  if GS.RowHeights[ARow] <= 0 then Exit;
//  if ARow > GS.TopRow + GS.VisibleRowCount - 1 then Exit;
  ARect := GS.CellRect(ACol, ARow);
  Fix := ((ACol < GS.FixedCols) or (ARow < GS.FixedRows));
  GS.Canvas.Pen.Style := psSolid;
  GS.Canvas.Pen.Color := clgray;
  GS.Canvas.Brush.Style := BsSolid;
  {$IFDEF BTP}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then exit;
  if ((Acol = SG_Px) and (not GereDocEnAchat)) Then
  begin
    InformePVBloque(self,TOBL,Arect,GS.Cells [Acol,Arow]);
  end;
  //
  if (Acol=SG_RefArt) and (Arow >= GS.fixedRows) then
  begin
    {Ligne de commentaire rattach�e}// Modif BTP
    if IsSousDetail(TOBL) or IsLigneDetail(nil, TOBL) then
    begin
    	TheText := TOBL.getvalue('GL_REFARTSAISIE');
    	Canvas.FillRect(ARect);
      GS.Canvas.Brush.Style := bsSolid;
      GS.Canvas.TextOut (Arect.left,Arect.Top +2,'   '+Thetext);
    end;
  end;
  //
  if (Acol=SG_FOURNISSEUR) and (Arow >= GS.fixedRows) then
  begin
    if (TOBL <> nil) then
    begin
    	Canvas.FillRect(ARect);
      GS.Canvas.Brush.Style := bsSolid;
      if TOBL.getValue('GLC_NATURETRAVAIL')<>'' then
      	GS.Canvas.TextOut (Arect.left,Arect.Top +2,TOBL.GetValue('LIBELLEFOU'));
    end;
  end;
  if (Acol=SG_CODTVA1) and (Arow >= GS.fixedRows) then
  begin
  	// pour les ouvrages on fait apparaitre des *** � la place du code de taxe
    if (TOBL <> nil) and IsOuvrage(TOBL) then
    begin
    	Canvas.FillRect(ARect);
      GS.Canvas.Brush.Style := bsSolid;
      GS.Canvas.TextOut (((Arect.left+Arect.Right)- canvas.TextWidth('***')) div 2,Arect.Top +2,'***');
    end;
  end;
  if ((Acol = SG_QF) and (Arow >= GS.fixedRows)) then
  begin

    if TOBL = nil then Exit;

  	if GetParamSocSecur('SO_METRESEXCEL',true) then
    begin
      if (not OrigineEXCEL) and (TheMetre <> nil) and (TheMetre.MetreAttached(TOBL)) then
      begin
        InformeMetre (self,TOBL,Arect);
      end;
    end else
    begin
    	if IsMetreExist(TOBmetres,TOBL.getValue('GL_NUMORDRE')) then
      begin
        InformeMetre (self,TOBL,Arect);
      end;
    end;
    if IsCentralisateurBesoin (TOBL) then
    begin
      InformeCentralisation (self,TOBL,Arect);
    end;
  end;
  if (Acol = SG_NL) and (Arow >= GS.fixedRows) then
  begin
  	if tobl <> nil then
    begin
      if IsOuvrage(TOBL) and (TOBL.GetValue('GL_INDICENOMEN')=0) and (NaturepieceOKPourOuvrage(TOBL)) then
      begin
      	if (TOBL.GetValue('GL_NATUREPIECEG') <> 'BCE') then InformeErreurOuvrage (self,TOBL,Arect);
      end;
    end;
  end;
  {$ENDIF}

  if ((SG_TYPA > -1) and (Acol = SG_TypA) and (Arow >= GS.fixedRows)) then
  begin
    if TOBL = nil then Exit;
    Canvas.FillRect(ARect);
    NumGraph := RecupTypeGraph(TOBL);
    if NumGraph >= 0 then
    begin
      ImTypeArticle.DrawingStyle := dsTransparent;
      if (IsSousDetail(TOBL)) or (IsLigneDetail(nil, TOBL)) then
      begin
      	ImTypeArticle.Draw(CanVas, ARect.left+16, ARect.top, NumGraph);
      end else
      begin
      	ImTypeArticle.Draw(CanVas, ARect.left, ARect.top, NumGraph);
      end;
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
{$IFDEF BTP} // LS
	if (Acol = SG_Lib) and (Arow >= GS.fixedRows) and (not OrigineExcel) then
  begin
    if TOBL = nil then Exit;
    {Ligne de commentaire rattach�e}// Modif BTP
    if IsSousDetail( TOBL) or IsLigneDetail(nil, TOBL)  then
    begin
    	TheText := TOBL.getvalue('GL_LIBELLE');
    	Canvas.FillRect(ARect);
      GS.Canvas.Brush.Style := bsSolid;
      GS.Canvas.TextOut (Arect.left,Arect.Top +2,'   '+Thetext);
    end;
    //
  	if TOBL.GetValue('BLOBONE')='X' then
    begin
    	Canvas.FillRect(ARect);
      GS.Canvas.Brush.Style := bsSolid;
      GS.Canvas.Pen.Color := clBlack;
      GS.CanVas.Font.Name := 'Wingdings';
      GS.Canvas.TextOut (((Arect.left+Arect.Right)- canvas.TextWidth('&')) div 2,Arect.Top +2,'&');
    end;
  end;
  if (Arow >= GS.fixedRows) and (Acol=SG_MONTANTSIT) then
  begin
  	if TOBL = nil then exit;
  	if TOBL.GetValue('GL_TYPELIGNE')='RG' then
    begin
    	TheText := StrF00(TOBL.Getvalue('GL_MONTANTHTDEV'),V_PGI.OkDecV);
      GS.Canvas.TextOut (Arect.Right-canvas.TextWidth(TheText+' ')-2,Arect.Top+1,TheText);
      GS.Canvas.MoveTo(Arect.Right, ARect.Top);
      GS.Canvas.LineTo(Arect.Right, ARect.Bottom);
    end;
  end;

  if (Arow >= GS.fixedRows) and ((ACol = SG_TEMPS)or(ACol = SG_TEMPSTOT)) then
  begin
    if TOBL = nil then Exit;
    if pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV;OUV') = 0 then Canvas.FillRect(ARect);
  end;

  if (Arow >= GS.fixedRows) and (ACol = SG_VOIRDETAIL) then
  begin
    if TOBL = nil then Exit;
    Canvas.FillRect(ARect);
    if (TOBL.GetValue('GL_TYPEARTICLE')='OUV') and (IsArticle(TOBL)) then
    begin
      PosX := ((Arect.left+Arect.Right  - ImgListPlusMoins.Width) div 2)+1;
      posY := ((Arect.Top+Arect.Bottom - ImgListPlusMoins.Height) div 2)-1;
      if TOBL.GetValue('GLC_VOIRDETAIL')='X' then
      begin
      	ImgListPlusMoins.Draw(CanVas, PosX, posY, 1);
      end else
      begin
      	ImgListPlusMoins.Draw(CanVas, PosX, posY, 0);
      end;
    end;
  end;

  if (Arow >= GS.fixedRows) and (ACol <> SG_LIB) and (Acol <> SG_NL) and (Acol <> SG_Montant) and
     (Acol <> SG_MontantAch) and (Acol <> SG_montantSit) and (Acol <> SG_POURCENTAVANC) and
     (Acol <> SG_MontantMarche) and (Acol <> SG_MTDEJAFACT) and (Acol <> SG_NATURETRAVAIL)  and (Acol <> SG_FOURNISSEUR) then
  begin
    if TOBL = nil then Exit;
    if Arow >= GS.fixedRows then
    begin
      if isFinParagraphe (TOBL) then Canvas.FillRect(ARect);
      if IsSousTotal (TOBL) then Canvas.FillRect(ARect);
    end;
  end;
  (*
  if (Arow >= GS.fixedRows) and (ACol =SG_montantSit) then
  begin
    if TOBL = nil then Exit;
    if TOBL.getValue('GL_TYPELIGNE')='RG' then
    begin
      Canvas.FillRect(ARect);
      TheValue := FloatToStrF (TOBL.getValue('GL_MONTANTHTDEV'),ffNumber,12,DEV.Decimale);
      GS.Canvas.TextOut (Arect.Right - canvas.TextWidth(TheValue)-6,Arect.Top +2,TheValue);
    end;
  end;
  *)
{$ENDIF}
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
  if Arow < GS.Fixedrows then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  {Ligne non imprimable}
  if TOBL.GetValue('GL_NONIMPRIMABLE') = 'X' then if ((Action <> taConsult) or (ARow <> GS.Row)) then Canvas.Font.Color := clBlue;
  {Ligne supprim�e}
  if TOBL.FieldExists('SUPPRIME') then
    if TOBL.GetValue('SUPPRIME') = 'X' then if ((Action <> taConsult) or (ARow <> GS.Row)) then Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
  {Lignes Multi-Dim}
  if TOBL.GetValue('GL_TYPEDIM') = 'DIM' then AfficheDetailDim(Canvas, DimSaisie, ACol) else
    if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then AfficheGenDim(Canvas, DimSaisie);
  {Lignes de sous-total}
  if TOBL.GetValue('GL_TYPELIGNE') = 'TOT' then Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  {Lignes d�but de paragraphe}// Modif BTP
  (* VARIANTE
  if Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then
  *)
  if IsDebutParagraphe (TOBL) then
  begin
    if TOBL.GetValue('GL_NIVEAUIMBRIC') > 1 then Canvas.Font.Style := Canvas.Font.Style + [fsItalic]
    else Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  end;
  {Lignes fin de paragraphe}// Modif BTP
  (* VARIANTE  -- if Copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'TP' then *)
  if IsFinParagraphe (TOBL) then
  begin
    if TOBL.GetValue('GL_NIVEAUIMBRIC') > 1 then Canvas.Font.Style := Canvas.Font.Style + [fsItalic]
    else Canvas.Font.Style := Canvas.Font.Style + [fsBold, fsItalic];
  end;
  {Ligne de commentaire rattach�e}// Modif BTP
  if IsLigneDetail(nil, TOBL) then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsbold];
    Canvas.Font.Color := clActiveCaption;
  end;
  if IsSousDetail(TOBL) then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsbold];
    Canvas.Font.Color := clActiveCaption;
  end;
  {
  // rajout LS
  if IsOuvrage(TOBL) and (TOBL.GetValue('GL_INDICENOMEN')=0) and (NaturepieceOKPourOuvrage(TOBL)) then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsItalic,fsStrikeOut];
    Canvas.Font.Color := clRed;
  end;
  }
  //
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
      if TOBL.FieldExists('SOLDERELIQUAT') then
        Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
    end;
  end;
{$IFDEF BTP}
  if (((action = taModif) and (not TransfoPiece)) or (action = taConsult)) and EstLigneArticle(TOBL) and EstLigneSoldee(TOBL) and
      Not(SaisieTypeAvanc) then // MODIF BRL AVANCEMENTS CHANTIERS
{$ELSE}
  if (((action = taModif) and (not TransfoPiece)) or (action = taConsult)) and EstLigneArticle(TOBL) and EstLigneSoldee(TOBL) then
{$ENDIF}
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
    Canvas.Font.Color := clGray;
  end;
  {$IFDEF BTP}

  {Ligne Trait�e}
  { -- Supprim� par LS le 10/02/05 suite demande JNL
  if (TOBL.GetValue('GL_VIVANTE') = '-') and not (IsLigneDetail(nil, TOBL)) then if ((Action <> taConsult) or (ARow <> GS.Row)) then
    Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
  }
  {$ENDIF}
  // VARIANTE
  if (isVariante(TOBL)) then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsbold,fsItalic];
    Canvas.Font.Color := clMaroon;
  end;
  // Ligne de r�f�rence de livraison ... Commande fournisseur ou r�ception
  if TOBL.GetValue('GL_TYPELIGNE') = 'RL' then
  begin
    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    Canvas.Font.Color := clRed;
  end;
  if Action = taConsult then exit;
  if (Acol = SG_MontantMarche) or (Acol = SG_MTDEJAFACT) then BEGIN canvas.Brush.Color := clInfoBk; END;
  IF (Acol= SG_POURCENTAVANC) or (Acol= SG_QTESITUATION) then BEGIN Canvas.font.color := $E6A008; Canvas.Font.Style := Canvas.Font.Style + [fsBold]; END;
  IF (Acol= SG_montantSit) then BEGIN canvas.Brush.Color := clInfoBk; Canvas.Font.Style := Canvas.Font.Style + [FsBold]; END;
end;

procedure TFFActure.PositionneDebutFinSel (var debut,fin : integer; SensInverse : boolean=false);
var TOB1,TOB2: TOB;
		Ind1,Ind2: integer;
begin
  TOB1 := GetTOBLigne(TOBpiece,debut);
  TOB2 := GetTOBLigne(TOBpiece,fin);
  //
  if ((TOB1 <> nil) and (TOB1.GetvAlue('GL_NIVEAUIMBRIC') > 0) and
  	 (TOB2 <> nil) and (TOB2.GetvAlue('GL_NIVEAUIMBRIC') > 0)) then
  begin
  	Ind1 := RecupDebutParagraph (TOBpiece,debut-1,TOB1.Getvalue('GL_NIVEAUIMBRIC'),true);
  	Ind2 := RecupDebutParagraph (TOBpiece,Fin-1,TOB2.Getvalue('GL_NIVEAUIMBRIC'),true);
    if Ind1 = Ind2 then exit; // dans le m�me paragraphe
  end;
  //
  if (TOB1 <> nil) and (TOB1.GetvAlue('GL_NIVEAUIMBRIC') > 0) then
  begin
		if SensInverse then
    begin
      Ind1 := RecupFinParagraph (TOBpiece,debut-1,TOB1.Getvalue('GL_NIVEAUIMBRIC'),true);
      debut := Ind1 +1;
    end else
    begin
      Ind1 := RecupDebutParagraph(TOBPiece,Debut-1,TOB1.Getvalue('GL_NIVEAUIMBRIC'),true);
      Debut := Ind1 +1;
    end;
  end;

  if (TOB2 <> nil) and (TOB2.GetvAlue('GL_NIVEAUIMBRIC') > 0) then
  begin
		if SensInverse then
    begin
      Ind1 := RecupDebutParagraph (TOBpiece,fin-1,TOB2.Getvalue('GL_NIVEAUIMBRIC'),true);
      fin := Ind1 +1;
    end else
    begin
      Ind1 := RecupFinParagraph(TOBPiece,Fin-1,TOB2.Getvalue('GL_NIVEAUIMBRIC'),true);
      Fin := Ind1 +1;
    end;
  end;

end;

procedure TFFActure.Selectionne (DepartSel,FinSel : integer);
var cancel,Retrieve : boolean;
		indice : integer;
    Debut,Fin : integer;
begin
	Debut := DepartSel;
  Fin := FinSel;
  if Assigned (GS.OnFlipSelection) then
  begin
    Retrieve := true;
    GS.OnFlipSelection := nil;
    GS.OnBeforeFlip := nil;
  end else Retrieve := false;

  if Debut > Fin then
  begin
  	PositionneDebutFinSel (Debut,fin,true);
  	if debut <> DepartSel then GS.FlipSelection (DepartSel-1);
    Indice := Fin;
    repeat
      cancel := false;
      CopierColler.BeforeFlip(GS,Indice,cancel);
      if not Cancel then
      begin
        GS.FlipSelection (Indice);
        CopierColler.FlipSelection(GS);
        Indice := CopierColler.LastSelected;
      end;
      inc(Indice);
    until indice > Debut-1;
  end else
  begin
  	PositionneDebutFinSel (Debut,Fin);
  	if debut <> DepartSel then  GS.FlipSelection (DepartSel-1);
    indice := Debut;
    repeat
      cancel := false;
      CopierColler.BeforeFlip(GS,Indice,cancel);
      if not Cancel then
      begin
        GS.FlipSelection (Indice);
        CopierColler.FlipSelection(GS);
        Indice := CopierColler.LastSelected;
      end;
      inc(Indice);
    until Indice > Fin;
  end;
  if retrieve then
  begin
    GS.OnFlipSelection := CopierColler.FlipSelection;
    GS.OnBeforeFlip := CopierColler.BeforeFlip;
  end;
end;

procedure TFFacture.GSMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Acol,Arow : integer;
		Depart,Fin : integer;
begin
  GX := X;
  GY := Y;
  GS.MouseToCell(GX,GY,Acol,Arow);
  if (Acol > 0) then exit;
  if (Arow = 0) and (Button=mbLeft) and (ssCtrl in Shift) then
  begin
		Depart := 1;
    Fin := GS.rowCount -1;
    Selectionne (Depart,Fin);
  end else
  begin
    if (Button=mbLeft) and (ssShift in Shift) then
    begin
      Depart := CopierColler.LastSelected+1;
      Fin := Arow;
      Selectionne (Depart,Fin);
    end;
  end;
end;

procedure TFFacture.GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
var
//  Hauteur, Hauteur0: integer;
{$IFDEF BTP}
	TOBL : TOB;
{$ENDIF}
begin
  // Pour �viter de cr�er des lignes vides
  if action <> taconsult then
  begin
    if (tModeBlocNotes in SaContexte) then
    begin
      if Ou >= GS.RowCount - 1 then
      begin
        GS.RowCount := GS.RowCount + 1;
        if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
        SetLargeurColonnes;
//        GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
      end;
      // Positionnement de la barre de scroll
//      Hauteur := (GS.RowHeights[Ou] * (Ou)) + (GS.GridLineWidth * (GS.Row+1));
//      Hauteur0 := GS.RowHeights[0] + GS.GridLineWidth;
(*
      if Debut.height + Hauteur + Hauteur0 > SB.height then
        SB.VertScrollBar.position := Debut.height + Hauteur + Hauteur0 - SB.height
      else
        SB.VertScrollBar.position := 0;
*)
    end else
    begin
      if (not SaisieTypeAvanc) then
      begin
        if Ou >= GS.RowCount - 1 then GS.RowCount := GS.RowCount + NbRowsPlus+TheRgpBesoin.NbLignes;
				SetLargeurColonnes;
      end;
    end;
  end;
  if Action <> taConsult then
  begin
    if (not SaisieTypeAvanc) then
    begin
      CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, Ou,false,TheDestinationLiv);
    end;
    if VH_GC.GCIfDefCEGID then
      if not transfopiece then if GetChampLigne(TOBPiece, 'GL_REFCOLIS', Ou) <> '' then
        begin
          Cancel := True;
          Exit;
        end;
  end;
  GereEnabled(Ou);
  ShowDetail(Ou);
  // VARIANTE
  TOBL := GetTOBLigne (TOBpiece,ou);
  if (TOBL <> Nil) and (pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV;OUV')> 0) then
  begin
  	CalculheureTot (TOBL);
    if SG_TEMPSTOT <> -1 then GS.cells[SG_TEMPSTOT,ou] := StrF00(TOBL.GetValue('GL_HEURE'), V_PGI.OkDecQ);
  end;
  TheVariante.Ligne := TOBL;
  TheApplicDetOuv.Ligne := TOBL;
  TheGestRemplArticle.Ligne := TOBL;
{$IFDEF BTP}
  if tModeSaisieBordereau in SaContexte then TheBordereauMen.Ligne := TOBL;
	TheRgpBesoin.ligne := TOBL;
{$ENDIF}
end;

procedure TFFacture.GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  DeflagTarif(Ou);
  CommVersLigne(TOBPiece, TOBArticles, TOBComms, Ou, True);
  DepileTOBLignes(GS, TOBPiece, Ou, GS.Row);
  GereLesLots(Ou);
  GereLesSeries(Ou);
  GereAnal(Ou);
  GereArtsLies(Ou);
  if Action = taCreat then BlocageSaisie(True);
  if TesteMargeMini(Ou) then Cancel := True;
  if AffecteMotif(Ou) then Cancel := True;
  if not IsChpsObligOk(1,Ou) then // JT - eQualit� 10819
  begin
    GS.Row := Ou;
    CpltLigneClick(nil);
    Cancel := True;
  end;
end;

procedure TFFacture.GSCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
var TOBL: TOB;
  // Modif BTP
  OuvrageDetail: boolean;
begin
  if Action = taConsult then Exit;
  // Modif BTP
  OuvrageDetail := false;
	BouttonInVisible;
  // --
  ZoneSuivanteOuOk(ACol, ARow, Cancel);
  if not Cancel then
  begin
  	GereDescriptif(Arow, True);
    // DEBUT MODIF CHR
    GS.ElipsisButton := (GS.Col = SG_RefArt) or (GS.Col = SG_Aff) or (GS.Col = SG_Rep) or (GS.Col = SG_Dep) or (GS.Col = SG_DateLiv) or (GS.Col = SG_DateProd)
      or (GS.Col = SG_Regrpe)  or (GS.Col = SG_CIRCUIT) or (GS.col = Sg_Unit);
    // FIN MODIF CHR
    if ((CommentLigne) and (GS.Col = SG_Lib) and
        (not SaisieTypeAvanc) and
        (Not ModifAvanc)) then GS.ElipsisButton := true;
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
      {$IFDEF 0CHR}
      if GS.Col = SG_Regrpe then GS.ElipsisHint := HTitres.Mess[28] else
      {$ENDIF}
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
        if (TOBL.FieldExists('GL_INDICEFORMULE')) and (TOBL.GetValue('GL_INDICEFORMULE')>0) then
        begin
          GS.ElipsisButton:=True ;
          GS.ElipsisHint:=TraduireMemoire('Formule Calcul Quantit�') ;
        end ;
        {$IFDEF AFFAIRE}
        if (TOBL.FieldExists('GL_FORMULEVAR')) and (TOBL.GetValue('GL_FORMULEVAR')<>'') then
          TraiteFormuleVar(GS.Row, 'MODIF'); //Affaire-Formule des variables
        {$ENDIF}
      end;
      {$IFDEF BTP}
      if (not OrigineEXCEL) and ((Cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
      	 (Cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION')) or
         (cledoc.NaturePiece = 'FBT')) then
      begin
  			if GetParamSocSecur('SO_METRESEXCEL',true) then
        begin
        	GS.ElipsisButton := TheMetre.ControlMetre;
        end else
        begin
        	GS.ElipsisButton := true;
        end;
        GS.ElipsisHint := TraduireMemoire('Acc�s au m�tr�');
      end else
      begin
        GS.ElipsisButton := false;
        GS.ElipsisHint := TraduireMemoire('');
      end;
      {$ENDIF}
    end;

    {$IFDEF GPAO}
    if ((GS.Col = SG_CIRCUIT) and (GS.Cells[SG_CIRCUIT, Arow] = '')) then
    begin
      GS.Cells[SG_CIRCUIT, Arow] := RechLeBonCircuit(ACol, ARow);
      TOBL.PutValue('GLC_CIRCUIT', RechLeBonCircuit(ACol, ARow));
    end;
    {$ENDIF GPAO}

    StCellCur := GS.Cells[GS.Col, GS.Row];
    BouttonVisible(GS.Row);
  end;
end;

procedure TFFacture.GSCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
var
  TobLigne, TobArticle: tob;
{$IFDEF BTP}
  TOBL :TOB;
{$ENDIF}
begin
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  BouttonInVisible;
  TOBL := GetTOBLigne(TOBPiece, ARow); if TOBL = nil then exit;
  //
  TOBOLDL.Dupliquer(TOBL,false,true);
  //
  GereDescriptif(Arow, False);
  if (assigned(TOBL)) and (TOBL.GetValue('MODIFIABLE')='-') then
  BEGIN
    GS.Cells [Acol,Arow] := StCellCur ;
    exit;
  END;

  // Remarque
  // SI le code article est saisi directement        ALORS on    passe     dans le GSCELLEXIT
  // SI le code article est initialis� par Elipsis   ALORS on NE passe PAS dans le GSCELLEXIT
  // De ce fait les traitements sont diff�rents
  // Pourquoi ??
  // Donc pour l'article et Nouveau Syst�me tarifaire alors pas de EXIT : ne devrait-on pas �tendre cette logique pour toutes les autres cellules
  {TP 30/09/2003 R�activation de la premi�re ligne}
//  if (GS.Cells[ACol, ARow] = StCellCur) then Exit; // deplace par LS
  //if (GS.Cells[ACol, ARow] = StCellCur) and (not ((Action=taCreat) and ( not TransfoPiece) and (ACol = SG_RefArt) and (GetParamSoc('SO_PREFSYSTTARIF'))) ) then Exit;

  if (GS.ColLengths[Acol] = -1) then exit;
  //if Not ((Gs.Col=SG_RefArt) or (Gs.Col=SG_Lib)) then Exit;
  FormateZoneSaisie(ACol, ARow);
  if (GS.Cells[ACol, ARow] = StCellCur) then Exit;

  {$IFDEF GPAO}
    if ACol = SG_RefArt then TraiteArticle(ACol, ARow, Cancel, False, False, 0)
  {$ELSE}
    if ACol = SG_RefArt then TraiteArticle(ACol, ARow, Cancel, False, False, 1)
  {$ENDIF}
{$IFDEF BTP}
  else if (Acol = SG_REFTiers) then VerifRefTiers (Acol,Arow,Cancel)
{$ENDIF}
	else if (Acol = SG_UNit) then VerifUnite (Acol,Arow,cancel)
  else if GereContreM and (ACol = SG_ContreM) then LigneEnContreM(ACol, ARow, Cancel)
  else if ACol = SG_Rep then TraiteRepres(ACol, ARow, Cancel)
  else if ACol = SG_Dep then TraiteDepot(ACol, ARow, Cancel)
  else if (((ACol = SG_QF) and (not ModifAvanc)) or (ACol = SG_QS)) then
  begin
    if not TraiteQte(ACol, ARow) then Cancel := True;
  end
  else if ACol = SG_Lib then TraiteLibelle(ARow)
  else if ACol = SG_Px then TraitePrix(ARow)
  else if ACol = SG_PxAch then TraitePrixAch(ARow)
  else if ACol = SG_Rem then TraiteRemise(ARow)
  else if ((ACol = SG_RV) or (ACol = SG_RL)) then TraiteMontantRemise(ACol, ARow)
  else if ACol = SG_DateLiv then TraiteDateLiv(ACol, ARow)
  else if ACol = SG_Aff then TraiteAffaire(ACol, ARow, Cancel)
  else if (((ACol = SG_QF) and (ModifAvanc))or ((ACol = SG_QA) and (SaisieTypeAvanc)) or (ACol = SG_Pct)) then TraiteAVanc(ACol, ARow)
  // Nouvelle gestion de l'avancement sur facture (en modif)
  else if (ACol = SG_QTESITUATION) then ChangeQteSituation(ACol, ARow)
  else if (ACol = SG_POURCENTAVANC) then ChangePourcentAvancSituation(ACol, ARow)
  else if (ACol = SG_montantSit) then ChangeMontantSituation(ACol, ARow)
  else if (ACol = SG_TEMPS) then ChangeTempsPose(ACol, ARow)
  else if (ACol = SG_TEMPSTOT) then ChangeTempsPoseTOT(ACol, ARow)
  {$IFDEF GPAO}
    else  if (Acol = SG_CIRCUIT) then TraiteCircuit(ACol, ARow, cancel)
  {$ENDIF GPAO}
  {$IFDEF CHR}
    else if ACol = SG_DateProd then HRTraiteDateProd(Self, TobPiece, ACol, ARow, Cancel)
    else if ACol = SG_Regrpe then HRTraiteRegroupe(Self, TobPiece, TobRegrpe, TobHrdossier, ACol, ARow, Cancel)
  {$ENDIF CHR}
  {$IFDEF MODE}
    else if ACol = SG_PxNet then TraitePrixNet(ACol, ARow)
    else if ACol = SG_Montant then TraiteMontantNetLigne(ACol, ARow)
  {$ENDIF}
  ;

    TraiteLesDivers(ACol, ARow);

  { On doit relancer la recherche tarif si
    * Piece de saisie et non de transformation
    * syst�me non verrouill�
    * quantit� <> 0
    * d�pot
    * article
    * circuit
    * quantit�
    * date de livraison
  }
  if (GetParamSoc('SO_PREFSYSTTARIF')) and (not TransfoPiece) then
  begin
    TobLigne := GetTobLigne(TobPiece, ARow);
    if ((TobLigne <> nil)
      and (TobLigne.GetValue('GL_QTESTOCK') <> 0)
      and ((ACol = SG_Dep) //Champ d�pot
      or (ACol = SG_Aff) //Champ affaire
      or (ACol = SG_RefArt) //Champ article
      or (ACol = SG_QF) //Champ quantit� factur�e
      or (ACol = SG_QS) //Champ quantit� de stock
      or (Acol = SG_DateLiv) //Champ date de livraison
      )
      ) then
    begin
      TobArticle := FindTobArtRow(TOBPiece, TOBArticles, ARow);
      TobLigne.PutValue('RECALCULTARIF', 'X');
      TobLigne.PutValue('RECALCULCOMM' , 'X');
      RechercheTarifsCommissions('LIGNE', Action, TobTiers, TobArticle, TobPiece, TobLigne, TobLigneTarif, TobTarif, DEV);
      AfficheLaLigne(ARow);
      TobPiece.PutValue('GP_TARIFSGROUPES', 'X');
    end;
  end;

  if not Cancel then
  begin
    // Correction fiche qualit� 10095
    // CalculeLaSaisie(ACol, ARow, False);
    if ( not IsSousDetail(TOBL)) then
    begin
      deduitLaLigne(TOBOLDL);
      ZeroLigneMontant(TOBL);
    end;
    CalculeLaSaisie(ACol, ARow, True);
    TOBL := GetTOBLigne(TOBPiece, ARow);
    {$IFDEF BTP}
    if Assigned(Tobl) and ( (TOBL.GetValue('GL_TYPEPRESENT') <> DOU_AUCUN) or (TOBL.GetValue('GLC_VOIRDETAIL')='X') ) Then
    begin
    	GestionDetailOuvrage(self,TobPiece,Arow,Acol);
    end;
 //   TheDestinationLiv.SetDestLivrDefaut (TOBL);
    MontreInfosLigne(TOBL, nil, nil, nil, INFOSLIGNE, PPInfosLigne);
    {$ENDIF}
    GereEnabled(Arow);
    NeRestePasSurDim(GS.Row);
    StCellCur := GS.Cells[ACol, ARow];
  end;
end;

procedure TFFacture.GSElipsisClick(Sender: TObject);
var TOBL: TOB;
//  StCode: string;
  {$IFDEF BTP}
  result: double;
  {$ENDIF}
  frombord : boolean;
begin
	result := 0;
  if      GS.Col = SG_RefArt  then ZoomOuChoixArt(GS.Col, GS.Row)
  else if GS.Col = SG_Rep     then ZoomOuChoixRep(GS.Col, GS.Row)
  else if GS.Col = SG_Dep     then ZoomOuChoixDep(GS.Col, GS.Row)
  else if GS.Col = SG_Lib     then ZoomOuChoixLib(GS.Col, GS.Row)
  else if GS.Col = SG_CIRCUIT then GereElipsis(SG_CIRCUIT,frombord)
  else if ((GS.Col = SG_QF) or (GS.Col = SG_QS)) then
  begin
    TOBL := GetTOBLigne(TOBPiece, GS.Row);
    if (not OrigineEXCEL) and ((Cledoc.NaturePiece =GetParamSoc('SO_AFNATAFFAIRE')) or
    	 (cledoc.NaturePiece = 'FBT') or
       (Cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION'))) then
    begin
    	if GetParamSocSecur('SO_METRESEXCEL',true) then
      begin
        if TheMetre.controlMetre then
        begin
           result := TheMetre.ModifieMetre(TOBL, self);
        end;
      end else
      begin
      	result := GereMetre (TOBL,TOBMetres,Action);
      end;
    end;
    if result <> 0 then
      begin
//      TOBL.putValue('GL_QTEFACT', result);
        GS.cells[GS.col, GS.row] := StrF00(result, V_PGI.OkDecQ);
//      AfficheLaLigne(GS.row);
        if GS.cells[GS.col, GS.row] <> StCellCur then ATraiterQte := False;
      end;
  end else
    // Date de livraison
    if GS.Col = SG_DateLiv then ZoomOuChoixDateLiv(GS.Col, GS.Row) else
    {$IFDEF CHR}
    if GS.Col = SG_Regrpe then HRZoomOuChoixRegroupe(Self, TobPiece, GS.Col, GS.Row) else
    if GS.Col = SG_DateProd then ZoomOuChoixDateLiv(GS.Col, GS.Row) else
    {$ENDIF} // FIN CHR
    // Affaire
    if GS.Col = SG_Aff then ZoomOuChoixAffaire(GS.Col, GS.Row) else
    if GS.col = SG_Unit then ZoomUnite (GS.col,GS.row) else
    ;
//  EnvoieToucheGrid_FO(Self, GS.Cells[SG_refart, gs.row], DimSaisie, TOBPiece);
end;

function TFFacture.GereElipsis(LaCol: integer;Var FromBordereau : boolean): boolean;
var SelectFourniss: string;
  {$IFDEF GPAO}
    TobParam, TobL: Tob;
  {$ENDIF GPAO}
begin
  Result := False;
  if LaCol = SG_RefArt then
  begin
    SelectFourniss := '';
    if (ctxMode in V_PGI.PGIContexte) then
    begin
      // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
      // d�fini en ent�te du document d'achat, doivent �tre affich�s sur l'�cran de recherche.
      if (VenteAchat = 'ACH') and (GetParamsoc('SO_MONOFOURNISS') = True) and
        (GetInfoParPiece(NewNature, 'GPP_ARTFOURPRIN') = 'X') then SelectFourniss := GP_TIERS.Text;
    end;

    if GereContreM and (GS.cells[SG_CONTREM, GS.Row] = 'X') then
      Result := GetCatalogueMul(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss)
    else
    begin
      {$IFDEF GPAO} 
      if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_CFGART') = 'X' then
      begin
        { Appel du configurateur pour la s�lection d'un article }
        TobParam := Tob.Create('_TOBSCFX_', nil, -1);
        TobL := GetTobLigne(TobPiece, GS.Row);
        TobParam.AddChampSupValeur('TOBTIERS', Longint(TobTiers));
        TobParam.AddChampSupValeur('TOBPIECE', Longint(TobPiece));
        TobParam.AddChampSupValeur('TOBLIGNE', Longint(GetTobLigne(TobPiece, GS.Row)));
        TobParam.AddChampSupValeur('TOBARTICLE', Longint(TobArticles));
        try
          if wStartCfxArticle(Self, CleDoc, 'ARGUMENTS', TobParam) then
          begin
            GS.Cells[GS.Col, GS.Row] := TobL.GetValue('GL_REFARTSAISIE');
            Result := True;
          end;
        finally
          TobParam.Free;
        end;
      end
      else
        Result := GetArticleRecherche(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss);
      {$ELSE}
      // ICI LS
      result := TheBordereau.RechArticlesFromBordereau (GS.Cells[GS.Col, GS.Row],Cledoc.NaturePiece);
      if result then
      begin
      	FromBordereau := True;
      end else TheTOB := nil;

      // --
      if not FromBordereau then
      begin
      	Result := GetArticleRecherche(GS, HTitres.Mess[1], CleDoc.NaturePiece, GP_DOMAINE.Value, SelectFourniss);
      end;
      {$ENDIF GPAO}
    end

  end else
  begin
    if LaCol = SG_Rep then Result := GetRepresentantSaisi(GS, HTitres.Mess[11], TOBTiers.GetValue('T_ZONECOM'), tlLocate, TOBPiece) else
      if LaCol = SG_Dep then Result := GetDepotSaisi(GS, HTitres.Mess[12], tlLocate) else
      if LaCol = SG_Lib then Result := GetLibellesAutos(GS, HTitres.Mess[16]) else
      ;
  end;
  
  {$IFDEF GPAO}
  if LaCol = SG_CIRCUIT then
  begin
    Result := GetCircuitMul(GS, TOBPiece, GetCodeArtUnique(TOBPiece, gs.row)); //wGetArticleFromCodeArticle(GetChampLigne(TOBPiece,'GL_REFARTSAISIE',gs.Row)));
    RepercCircArtDim(GS, TOBPiece, GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', gs.Row));
  end;
  {$ENDIF GPAO}
  
end;

procedure TFFacture.GSDblClick(Sender: TObject);
begin
//  if GereContreM and (GS.Col = SG_ContreM) and (GS.Cells[SG_ContreM, gs.row] <> 'X') then GS.Cells[SG_ContreM, gs.row] := 'X' else
// DBR Fiche 10490
  if GereContreM and (Action<>taConsult) and (GS.Col = SG_ContreM) and (GS.Cells[SG_ContreM, gs.row] <> 'X') then GS.Cells[SG_ContreM, gs.row] := 'X' else
    if GS.Col = SG_RefArt then ZoomOuChoixArt(GS.Col, GS.Row) else
    if GS.Col = SG_Rep then ZoomOuChoixRep(GS.Col, GS.Row) else
    if GS.Col = SG_Dep then ZoomOuChoixDep(GS.Col, GS.Row) else
    {$IFDEF BTP}
    if (GS.Col = SG_Lib) and (not SaisieTypeAvanc) (*and (not ModifAvanc)*) then  // Modif BRL 23/05/2011 : on autorise la modif des descriptifs en modif de situation
    begin
    	if IsLigneReferenceLivr(GetTobLigne(TOBPiece,GS.row)) Then exit;
      CreeDesc (self, TobPiece);
    end else
    {$ELSE}
    if (GS.Col = SG_Lib) and
        (not SaisieTypeAvanc) and
        (Not ModifAvanc) then ZoomOuChoixLib(GS.Col, GS.Row) else
    {$ENDIF}
    if GS.Col = SG_Aff then ZoomOuChoixAffaire(GS.Col, GS.Row) else
    {$IFDEF AFFAIRE}
    if (GS.Col = SG_QF) then TraiteFormuleVar(GS.Row, 'MODIF') else //Affaire-Formule des variables
    {$ENDIF}
    ;
  EnvoieToucheGrid_FO(Self, GS.Cells[SG_refart, gs.row], DimSaisie, TOBPiece);
end;

procedure TFFacture.GSEnter(Sender: TObject);
var bc, Cancel: boolean;
  ACol, ARow: integer;
begin
	TheBordereau.piece := CleDoc.NaturePiece;
	TheBordereau.Affaire := GP_AFFAIRE.Text;
  If TobPiece.GetValue('GP_TIERSFACTURE') <> '' then
	  TheBordereau.Tiers := TobPiece.GetValue('GP_TIERSFACTURE')
	else
    TheBordereau.Tiers := GP_Tiers.Text;
	TheBordereau.NatureAuxi := TOBTiers.getValue('T_NATUREAUXI');
	TheBordereau.Date := Cledoc.DatePiece;
  TheBordereau.contexte := SaContexte;
	TheBordereau.AppliqueChange;

  BeforeGSEnter(Self);
  // -- Correction fiche qualit� 11992
  if (cledoc.naturepiece = 'PBT') and (GP_AFFAIRE.text = '' ) then
  begin
    PgiBox(TraduireMemoire('Vous devez renseigner un code chantier'));
    GP_AFFAIRE1.setfocus;
    Exit;
  end;
  // --
  if ((GP_TIERS.Text = '') or (GP_TIERS.Text <> TOBTiers.GetValue('T_TIERS'))) then
  begin
    HPiece.Execute(5, Caption, '');
    if GP_TIERS.CanFocus then GP_TIERS.SetFocus else GotoEntete;
    Exit;
  end;
  // JT eQualit� 10785
  if TestDepotOblig then
  begin
    if GP_DEPOT.Text = '' then
    begin
      HPiece.Execute(57, Caption, '');
      if GP_DEPOT.CanFocus then GP_DEPOT.SetFocus else GotoEntete;
      Exit;
    end;
  end;
  //Fin JT
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
    if Action = taModif then MOTIFMVT.Value := TOBPiece.Detail[0].GetValue('GL_MOTIFMVT');
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
  GS.SynEnabled := true;
  GS.ShowEditor;
//  GP_DOMAINE.Enabled := False;
    // MR: Pour l(instant en attendant la correction des lignes commentaires provacant des trous dans la num�rotation des lignes au changement de domaine
  if not EstAvoir then // JT eQualit� 10764
    if ((not DejaRentre) and (Action = taCreat) and (ObligeRegle)) then ClickAcompte(True);
  DejaRentre := True;
  //if (ctxMode in V_PGI.PGIContexte) then GP_ETABLISSEMENT.Enabled:=False ;
end;

{==============================================================================================}
{=============================== Actions sur le Ent�te ========================================}
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
	// si la pi�ce est d�j� positionn� comme vis�, on ne fait pas le traitement.
	if TOBPiece.getValue('GP_ETATVISA')='VIS' then exit;
  //
  if VH_GC.GCIfDefCEGID then
    if ((Action = taModif) and (not TransfoPiece) and (not DuplicPiece) and
      (Arrondi(TOBPiece.GetValue('GP_TOTALHT') - OldHT, 6) = 0)) then Exit;
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
Var    CleDocAffaire : R_CLEDOC;
begin
  // Ajout contr�le si un devis accept� par affaire selon param�tre soci�t�
  if (GetParamSocSecur('SO_BTUNDEVISPARAFFAIRE',False)) and
     (NewNature = VH_GC.AFNatAffaire) and
     ((Action = taCreat) or (DuplicPiece)) and
     (SelectPieceAffaire(GP_AFFAIRE.text, 'AFF', CleDocAffaire, True) > 0) then
  begin
     PgiInfo(TraduireMemoire('Saisie impossible, un devis a d�j� �t� accept� pour cette affaire.'));
     GotoEntete;
     Exit;
  end;

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

  if GP_REPRESENTANT.Text <> OldRepresentant then
  begin
  	if not OKRepresentant (GP_REPRESENTANT.text,TypeCom) then
    begin
      HPiece.execute(40, Caption, '');
      GP_REPRESENTANT.SetFocus;
      Exit;
    end;
    AjouteRepres(GP_REPRESENTANT.Text, TypeCom, TOBComms);
    BalayeLignesRep;
  end;
  GereCommercialEnabled ;
end;

procedure TFFacture.GP_REPRESENTANTElipsisClick(Sender: TObject);
begin
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
var DD: TDateTime;
  i, iLiv, iArt: integer;
  iRefColis : integer; // DBR Pas modif ligne g�n�r�e par la NGI
  TOBL: TOB;
begin
  if csDestroying in ComponentState then Exit;
  if Action = taConsult then Exit;
  if GeneCharge then Exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  DD := StrToDate(GP_DATELIVRAISON.Text);
  if DD = TOBPiece.GetValue('GP_DATELIVRAISON') then Exit;
  TOBPiece.PutValue('GP_DATELIVRAISON', DD);
  if VH_GC.GCIfDefCEGID then
  begin
    iLiv := -1;
    iArt := -1;
    iRefColis := -1; // DBR Pas modif ligne g�n�r�e par la NGI
    for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      if i = 0 then
      begin
        iLiv := TOBL.GetNumChamp('GL_DATELIVRAISON');
        iArt := TOBL.GetNumChamp('GL_ARTICLE');
        iRefColis := TobL.GetNumChamp ('GL_REFCOLIS');  // DBR Pas modif ligne g�n�r�e par la NGI
      end;
//      if TOBL.GetValeur(iArt) <> '' then // DBR Pas modif ligne g�n�r�e par la NGI
      if (TOBL.GetValeur(iArt) <> '') and (TOBL.GetValeur (iRefColis) = '') then
      begin
        TOBL.PutValeur(iLiv, DD);
        if SG_DateLiv > 0 then GS.Cells[SG_DateLiv, i + 1] := DateToStr(DD);
      end;
    end;
   end
  else
    MajDatesLivr;
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
  Datechange : boolean;
begin
  Result := False;
{$IFDEF BTP}
	Err := ControleDateDocument (GP_DATEPIECE.text,NewNature);
{$ELSE}
  Err := ControleDate(GP_DATEPIECE.Text);
{$ENDIF}
  if (Err > 0) and not (GetParamSoc('SO_GCDESACTIVECOMPTA')) then //MODIF AC
  begin
    HPiece.Execute(17 + Err, caption, '');
    if GP_DATEPIECE.CanFocus then GP_DATEPIECE.SetFocus else GotoEntete;
    Exit;
  end;
  DD := StrToDate(GP_DATEPIECE.Text);
  DateChange := (DD <> TOBPiece.Getvalue('GP_DATEPIECE'));
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

  if DateChange then
    TOBEches.ClearDetail;
  if CtxMode in V_PGI.PGIContexte then GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False)
  else GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False);
  Result := True;
end;

procedure TFFacture.GP_TIERSElipsisClick(Sender: TObject);
begin
  if IdentifieTiers then
  begin
  	CliCur := GP_TIERS.Text;
		TheDestinationLiv.ChangeTiers;
    fModifSousDetail.SetChange;
  end;
end;

procedure TFFacture.GP_TIERSDblClick(Sender: TObject);
begin
  if IdentifieTiers then
  begin
  	CliCur := GP_TIERS.Text;
		TheDestinationLiv.ChangeTiers;
    fModifSousDetail.SetChange;
  end;
end;

procedure TFFacture.GP_TIERSExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;
  GereTiersEnabled;
  if GeneCharge then Exit;
  if Action = taConsult then Exit;
  if CliCur <> GP_TIERS.Text then
  begin
    if IdentifieTiers then
    begin
    	CliCur := GP_TIERS.Text;
		TheDestinationLiv.ChangeTiers;
    fModifSousDetail.SetChange;
		end;
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
  Okok, bChargeNouveauDepot: boolean; // DBR : Depot unique charg�
begin
  if GeneCharge then Exit;
  if GP_DEPOT.Value = '' then Exit;
  TOBCata := nil;
  bChargeNouveauDepot := False; // DBR : Depot unique charg�
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
          if (Dep = OldDep) or ((Dep <> GP_DEPOT.Value) and (VH_GC.GCMultiDepots)) then // AC Pr Multi-Depot / Etab
          begin
            
            if EstLigneArticle(TOBL) and (not EstLigneSoldee(TOBL)) and (not WithPieceSuivante(TOBL)) then
            begin
              if GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X' then
              begin
                TOBL.PutValue('GLC_CIRCUIT', '');
                GS.Cells[SG_CIRCUIT, i + 1] := '';
              end;

            if TOBCata <> nil then TOBCata.free;
            TOBCata := nil;
            if TOBL.GetValue('GL_ENCONTREMARQUE') = 'X' then TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, i + 1);
            if TOBCata <> nil then ReserveCliContreM(TOBL, TOBCata, False);
            TOBL.PutValue('GL_DEPOT', GP_DEPOT.Value);
            bChargeNouveauDepot := true; // DBR : Depot unique charg�
            if TOBCata <> nil then
            begin
              LoadTobDispoContreM(TobL, TobCata, False);
              ReserveCliContreM(TOBL, TOBCata, true);
            end;
            if SG_DEP > 0 then GS.Cells[SG_DEP, i + 1] := GP_DEPOT.Value;
            end;
          end;
        end;
      end;
      {$IFNDEF BTP}
      GS.ClearSelected;
      {$ELSE}
      CopierColler.deselectionneRows;
      {$ENDIF}
      Okok := True;
    end;
  end;
  if Okok and BChargeNouveauDepot then
  begin
    ChargeNouveauDepot(TOBPiece, nil, GP_DEPOT.Value); // DBR : Depot unique charg�
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
  end;
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
  // Appel de la fonction renvoyant la liste des d�p�ts li�s � l'�tablissement
  if VH_GC.GCMultiDepots then
  begin
    ListeDepot := ListeDepotParEtablissement(etab);
    if ListeDepot <> '' then
    begin
      // Modif 16/04/2003
      GP_DEPOT.Plus := ' GDE_SURSITE="X" AND GDE_DEPOT in (' + ListeDepot + ')';
      GP_DEPOT.Value := copy(ListeDepot, 2, 3); // Le d�p�t par d�faut est le premier de la liste
    end
    else
    begin
      GP_DEPOT.Plus := ' GDE_SURSITE="X"';
      GP_DEPOT.Value := VH_GC.GCDepotDefaut // Le d�p�t par d�faut est celui des param�tres soci�t�s
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
    Q := OpenSQL('select ET_DEVISE from ETABLISS where ET_ETABLISSEMENT="' + Etab + '"', true,-1, '', True);
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
  if Action = taConsult then Exit; // modif du regime de taxe dans compl�ment autoris� en modif de pi�ce
  {$ELSE}
  if ((Action <> taCreat) and (not DuplicPiece) and (not SaisieTypeAffaire)) then Exit;
  {$ENDIF}

  Reg := GP_REGIMETAXE.Value;
  if Reg = '' then Exit;
  if (Reg = TOBPiece.GetValue('GP_REGIMETAXE')){ and not (ChangeComplEntete)} then Exit;
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
    //
    // MODIF LM 02/04/2003
    // Saisie d'un document EUR sur un dossier en devise OUT
    // La table de chancellerie stocke le taux par rapport � l'EUR, par par rapport � la devise pivot du dossier.
    //
    //if ((CodeD<>V_PGI.DevisePivot) and (Not EstMonnaieIN(CodeD))) then
    if ((CodeD <> 'EUR') and (not EstMonnaieIN(CodeD))) then
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
  {$IFDEF BTP}
  CopierColler.devise := DEV;
  {$ENDIF}
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
{$IFDEF LINE}
  Bdevise.visible := false;
  Ldevise.visible := false;
  EUROPIVOT.visible := false;
  GP_DEVISE.visible := false;
  ISigneEuro.Visible := False;
{$ENDIF}
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
  if BCalculDocAuto.down then
  begin
    CalculeLaSaisie(-1, -1, TotEnListe);
  end else
  begin
    CacheTotalisations (true);
    GS.Refresh;
  end;
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
    exit;
  end;
  {$IFDEF BTP}
  PutValueDetailOuv(TOBOuvrage, 'BLO_REMISEPIED', GP_REMISEPIED.Value);
  {$ENDIF}
  PutValueDetail(TOBPiece, 'GP_REMISEPIED', GP_REMISEPIED.Value);
  PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
  if BCalculDocAuto.down then
  begin
    CalculeLaSaisie(-1, -1, TotEnListe);
  end else
  begin
    CacheTotalisations (true);
    GS.Refresh;
  end;
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
          Total := Arrondi(Total + TOBDim.GetValue('GL_TOTALHTDEV'),6);
          MontantBrut := Arrondi(MontantBrut + (TOBDim.GetValue('GL_QTEFACT') * TOBDim.GetValue('GL_PUHTDEV')),6);
        end
        else
        begin
          Total := Total + TOBDim.GetValue('GL_TOTALTTCDEV');
          MontantBrut := Arrondi(MontantBrut + (TOBDim.GetValue('GL_QTEFACT') * TOBDim.GetValue('GL_PUTTCDEV')),6);
        end;
        MontantLigneHT := Arrondi(MontantLigneHT + TOBDim.GetValue('GL_MONTANTHTDEV'),6);
        MontantLigneTTC := Arrondi(MontantLigneTTC + TOBDim.GetValue('GL_MONTANTTTCDEV'),6);
        TotRemLigne := Arrondi(TotRemLigne + TOBDim.GetValue('GL_TOTREMLIGNEDEV'),6);
        ValRem := Arrondi(ValRem + TOBDim.GetValue('GL_VALEURREMDEV'),6);
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

function TFFacture.InitLaLigne(ARow: integer; NewQte: double; CalcTarif: boolean = True): T_ActionTarifArt;
var TOBL, TOBA, TOBCATA, TOBArtREf: TOB;
begin
  Result := ataOk;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  TOBCATA := FindTOBCataRow(TOBPiece, TOBCatalogu, ARow);
  // pour init des champs venant de l'article de r�f�rence
  TobArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [TOBL.getvalue('_CONTREMARTREF')], False);
  Result := PreAffecteLigne(TobPiece, TobL, TobLigneTarif, TobA, TobTiers, TobTarif,
    TobConds, TobAffaire, TobCata, TobArtRef, ARow, DEV, NewQte, CalcTarif );
  {$IFDEF CHR}
  TOBL.PutValue('GL_DATEPRODUCTION', StrToDate(GP_DATEPIECE.Text));
  {$ENDIF} // FIN CHR
{$IFDEF BTP}
	TheRepartTva.AppliqueLig (TOBL);
{$ENDIF}
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
var
  i: integer;
begin
  Result := False;
  if Action = taConsult then Exit;
  { TP : Si je ne modifie qu'un des champs GLC_xx des TobLignes, TobPiece.IsOneModifie renvoi false :o((( }
  {gm 15/10 je remets tobpiece.isonemodifie, car la modif des sous-filles (VENTANA) n'est pas d�tect�e
  {           lors d'une analytique ligne sur demande}
  i := -1;
  while (i < TobPiece.Detail.Count - 1) and (not Result) do
  begin
    Inc(i);
    Result := TobPiece.Detail[i].Modifie;
  end;
  if not Result then
    Result := ((TOBAdresses.IsOneModifie) or (TOBAcomptes.IsOneModifie) or
      (TOBPorcs.IsOneModifie) or
      (TOBPIECERG.IsOneModifie) or (TOBBasesRg.ISOneModifie) or
      (TOBLIENOLE.IsOneModifie) or (TOBPiece.IsOneModifie) or (ModifieVariables) or
      (TOBmetres.IsOneModifie) or
      (TransfoPiece) or (DuplicPiece) or (SaisieTypeAvanc) or (ForceEcriture));
end;

{==============================================================================================}
{=============================== Manipulation des tiers =======================================}
{==============================================================================================}

function TFFacture.IdentifieTiers: boolean;
var OldTiers: string;
i : integer ;
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
     // Le fournisseur ne peut �tre modifi�, si des lignes existent d�j� dans le document
      i := 0 ;
      While (i<=TOBPiece.Detail.count-1) do
      begin
        if (TOBPiece.Detail[i].GetValue('GL_REFARTSAISIE')<>'') then
        begin
          HPiece.Execute(37, Caption, '');
          GP_TIERS.Text := OldTiers;
          Exit;
        end else Inc(I) ;
      end ;
    end;
    TiersChanged := true;
    ChargeTiers;
    PutValueDetail(TOBPiece, 'GP_TIERS', GP_TIERS.Text);
    if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then ChargeAffairePiece(True, True);
  end;
  GereTiersEnabled;
  TiersChanged := false;
end;

function TFFacture.CalculMargeLigne(ARow: integer): double;
var TOBL, TOBA: TOB;
  RefU, QualM: string;
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
    if PuNet > 0 then MC := (PuNet - PxValo) / PuNet * 100 else MC := 0;
  end;
  TOBL.PutValue('MARGE', MC);
  result := MC;
end;

function TFFacture.TesteMargeMini(ARow: integer): boolean;
var TOBL, TOBA: TOB;
  RefU, QualM: string;
  PasOkM : Boolean;
  MargeMini, MC: double;
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
    (*if (MC <> 0) then *)PasOkM := (MC < MargeMini);
  end;
  if PasOkM then
  begin
    if ((V_PGI.Superviseur) or (not VH_GC.GCBloqueMarge)) then
    begin
      if (VH_GC.GCControleMarge) or (VH_GC.GCBloqueMarge) then
        HPiece.Execute(17, caption, '');
    end else if (VH_GC.GCBloqueMarge) then
    begin
     {$IFDEF EAGLCLIENT}
      Result := True;
      {$ELSE}
      HPiece.Execute(17, caption, '');
      Result := True;
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
    {Non affect� ou Orange --> tester l'encours en temps r�el}
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
  {$IFDEF NOMADE} //Si nomade, interdiction de cr�er des cdes pour les prospects (GC uniquement)
  if not (ctxMode in V_PGI.PGIContexte) and (NewNature = 'CC') then
  begin
    Nature := GetColonneSQL('TIERS', 'T_NATUREAUXI', 'T_TIERS="' + GP_TIERS.Text + '"');
    if Nature = 'PRO' then
    begin
      Nom := GetColonneSQL('TIERS', 'T_LIBELLE', 'T_TIERS="' + GP_TIERS.Text + '"');
      PGIBox('Le tiers ' + GP_TIERS.Text + '-' + Nom + ' est un prospect, il faut cr�er un devis', 'Erreur');
      GP_TIERS.Text := '';
      exit;
    end;
  end;
  {$ENDIF}

  OldT := TOBTiers.GetValue('T_TIERS');
  ChgTiers := (GP_TIERS.Text <> OldT);
  Rouge := False;
  if SaisieTypeAffaire then tr := RemplirTOBTiers(TOBTiers, GP_TIERS.Text, NewNature, False) // mcd 07/05/02 si utilisationd epuis affaire, pas test clt ferm�
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
    {Tiers en Rouge sur une cr�ation (ou duplication) --> interdire ce tiers}
    if (Rouge) and ((Action = taCreat) or (DuplicPiece)) then GP_TIERS.Text := '' else GP_TIERS.Text := TOBTiers.GetValue('T_TIERS')
  end else
  begin
    if ChgTiers then
    begin
      CataFourn := False;
      if VenteAchat = 'ACH' then CataFourn := ExisteSQL('SELECT GCA_TIERS FROM CATALOGU WHERE GCA_TIERS="' + GP_TIERS.Text + '"');
    end;
  end;
  //JT - eQualit� 10788, si annul�, stop la proc�dure
  if GP_TIERS.Text = '' then
    exit;
  //Fin JT
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
{$IFDEF BTP}
  if ((Action = taCreat) or ((Action=taModif) and (TiersChanged) ) {or (DuplicPiece)}) then
{$ELSE}
  if ((Action = taCreat) or (DuplicPiece)) then
{$ENDIF}
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
{$IFDEF BTP}
  if TobAdresses.detail.count > 1 then
    if GetParamSoc('SO_GCPIECEADRESSE') then
    begin
      LIBELLETIERS.Caption := TOBAdresses.Detail[1].Getvalue('GPA_LIBELLE');
    end
    else
    begin
      LIBELLETIERS.Caption := TOBAdresses.Detail[1].Getvalue('ADR_LIBELLE');
    end;
{$ENDIF}
  {Tiers en rouge sur une transformation de pi�ce --> passer en consultation}
  if ((Rouge) and (GeneCharge) and (TransfoPiece)) then
  begin
    Action := taConsult;
    TransfoPiece := False;
    NewNature := TOBPiece.GetValue('GP_NATUREPIECEG');
    FTitrePiece.Caption := GetInfoParPiece(NewNature, 'GPP_LIBELLE');
  end;
  //
  fModifSousDetail.DEV  := DEV;
  fModifSousDetail.SetChange;
  // --

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
  // pour eviter qu'il n'essaye de rappliquer les conditon tarifaires du client en duplic de bordereau
  if (Action=taModif) and (DuplicPiece) and (tModeSaisieBordereau in saContexte) then exit;
  if TOBPiece.Detail.Count <= 0 then Exit;
  if TOBArticles.Detail.Count <= 0 then Exit;
  if GetInfoParPiece(NewNature, 'GPP_CONDITIONTARIF') <> 'X' then Exit;
  if (not GetParamSoc('SO_PREFSYSTTARIF')) then
    St := AGLLanceFiche('GC', 'GCOPTIONTARIF', '', '', '')
  else
    St := '2';
  if ((St = '') or (St = '0') or (st='30')) then Exit;
  if (not GetParamSoc('SO_PREFSYSTTARIF')) or (PGIAsk('Confirmez vous la mise � jour des tarifs sur toutes les lignes de la pi�ce ?', 'Syst�me tarifaire') =     mrYes) then
  begin
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, i + 1);
    if TOBA = nil then Continue;
    TOBL := TOBPiece.Detail[i];
    if ((GS.NbSelected = 0) or (GS.IsSelected(i + 1))) then
    begin
      TarifVersLigne(TobA, TobTiers, TobL, TobLigneTarif, TobPiece, TobTarif, True, ((St = '2') or (st='20')), DEV);
      TOBL.putvalue('GL_RECALCULER', 'X');
      AfficheLaLigne(i + 1);
      end;
    end;
  end;
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1, False);
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  CopierColler.deselectionneRows;
  {$ENDIF}
  Result := True;
end;

procedure TFFacture.MontreEuroPivot(Montrer: boolean);
begin
  if (CleDoc.NaturePiece = 'EEX') or (CleDoc.NaturePiece = 'SEX') then exit;
{$IFDEF LINE}
  exit;
{$ENDIF}
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
    if not VH^.TenueEuro then DEV.Symbole := '�' else DEV.Symbole := VH^.SymboleFongible;
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
var CodeD			: String;
		CodeTiers	: String;
    CodeRepres: string;
  	OkE				: Boolean;
    OkOut			: Boolean;
begin

  if (GeneCharge and (not DuplicPiece)) then Exit;

  if (Action <> taCreat) and (Action <> TaModif) and (not DuplicPiece) then Exit;

  CodeTiers := TOBTiers.GetValue('T_TIERS');

	// Modif BRL pour FQ11433 : On ne touche pas � l'escompte et la remise en modif
  if (Action <> TaModif) then
  	 begin
  	 GP_ESCOMPTE.Value := TOBTiers.GetValue('T_ESCOMPTE');
  	 PutValueDetail(TOBPiece, 'GP_ESCOMPTE', GP_ESCOMPTE.Value);
  	 GP_REMISEPIED.Value := TOBTiers.GetValue('T_REMISE');
  	 PutValueDetail(TOBPiece, 'GP_REMISEPIED', GP_REMISEPIED.Value);
     End;
  //

  GP_MODEREGLE.Value := TOBTiers.GetValue('T_MODEREGLE');
  GP_REGIMETAXE.Value := TOBTiers.GetValue('T_REGIMETVA');

  {$IFDEF NOMADE}
   VariableSite := PCP_LesSites.LeSiteLocal.LesVariables.Find('$REP');
   if (VariableSite = nil) or (VariableSite.SVA_VALUE = '') then
  	  begin
  {$ENDIF}
    	if (GP_REPRESENTANT.Text = '') or (TOBPiece.Detail.Count = 0) then
    		 begin
      	 if TOBTiers.FieldExists('T_REPRESENTANT') then CodeRepres := TOBTiers.GetValue('T_REPRESENTANT') else CodeRepres := '';
      	 GP_REPRESENTANT.Text := CodeRepres;
    		 end
    	else
    		 begin
    		 Coderepres := TOBPiece.getValue('GP_REPRESENTANT');
    		 end;
  {$IFDEF NOMADE}
   	  end
   else
   	  begin
   		GP_REPRESENTANT.Text := VariableSite.SVA_VALUE;
   		end;
  {$ENDIF}

  {$IFDEF BTP}
  if (TiersChanged) then CodeRepres := TOBTiers.GetValue('T_REPRESENTANT');
  if (CodeRepres <> '') And (OKRepresentant (Coderepres,TypeCom)) then GP_REPRESENTANT.Text := CodeRepres else GP_REPRESENTANT.Text := '';
  {$ENDIF}
  if ((TOBPiece.Detail.Count <= 0) and (Action = taCreat)) then
  begin
    GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
    CodeD := TOBTiers.GetValue('T_DEVISE');
    if ((CodeD <> '') and (GP_DEVISE.Values.IndexOf(CodeD) >= 0)) then GP_DEVISE.Value := CodeD;
    if (ctxMode in V_PGI.PGIContexte) then IncidenceMode;
    {JLD 09/03/2001 EtudieColsListe ;}
{$IFDEF BTP}
    if not GP_FACTUREHT.checked then SetTiersTTC(self);
{$ENDIF}
    EtudieColsListe; // MR 05/.4/2001 r�tabli pour modif colonnes si facture TTC
    MemoriseListeSaisieBTP(self);
  end;
  {$IFDEF BTP}
  if (Action= taCreat) or ((Action = taModif) and (TiersChanged)) then
  begin
    GP_FACTUREHT.Checked := (TOBTiers.GetValue('T_FACTUREHT') = 'X');
    CodeD := TOBTiers.GetValue('T_DEVISE');
    if ((CodeD <> '') and (GP_DEVISE.Values.IndexOf(CodeD) >= 0)) then GP_DEVISE.Value := CodeD;
    if (ctxMode in V_PGI.PGIContexte) then IncidenceMode;
    {JLD 09/03/2001 EtudieColsListe ;}
{$IFDEF BTP}
		ReinitListeSaisieBTP (Self);
{$ENDIF}
    EtudieColsListe; // MR 05/.4/2001 r�tabli pour modif colonnes si facture TTC
  end;
  {$ENDIF}
  {#TVAENC}
  GP_TVAENCAISSEMENT.Value := PositionneExige(TOBTiers);
	if (TiersChanged) then
  begin
    TiersVersPiece(TOBTiers, TOBPiece);
    TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece);
  end;

  TiersFraisVersPiedPort(TOBPiece, TOBTiers, TOBPorcs);
{$IFDEF BTP}
  if (((Action = taCreat)or ((Action = taModif) and (TiersChanged))) and (not DuplicPiece)) then
{$ELSE}
  if ((Action = taCreat) and (not DuplicPiece)) then
{$ENDIF}
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
  LibelleTiers.Caption := TOBTiers.GetValue('T_LIBELLE');
  TOBPiece.GetEcran(Self);
  fPieceCoTrait.SetSaisie;
  IsPieceGerableCoTraitance (TOBPiece,TOBaffaire);
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
  if (ColName = '') or (ColName ='GL_AFFAIRE') then Exit; //mcd 15/10/03 si champ affaire, l'affichage �cran est diff�retn de la tob. il ne faut pas �craser (n'�crivait pas le code affair complet dans certain cas
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
{$IFDEF BTP}
	if IsSousDetail (TOBL) then
  begin
		fModifSousDetail.ModifLibelleSousDet (TOBL,GS.Cells[Sg_Lib, Arow] );
    exit;
  end;
	if IsFinParagraphe (TOBL) then
  begin
    GS.Cells[Sg_Lib, Arow] := stcellCur;
    exit;
  end;
  // Fiche Qualit� 11357
	if OrigineEXCEL then
  begin
    GS.Cells[Sg_Lib, Arow] := stcellCur;
    exit;
  end;
  // --
	if (IsLigneReferenceLivr (TOBL)) or (TOBL.GetValue('GLC_FROMBORDEREAU')='X') then
  begin
    GS.Cells[Sg_Lib, Arow] := stcellCur;
    exit;
  end;
{$ENDIF}
  if (SaisieTypeAvanc) (*or (ModifAvanc)*) then  // Modif BRL 23/05/2011 : on autorise la modif des libell�s en modif de situation
  begin
    GS.Cells[Sg_Lib, Arow] := stcellCur;
    exit;
  end;
  if not (IsLigneDetail(nil, TOBL)) then
  begin
    TOBL.PutValue('GL_LIBELLE', GS.Cells[SG_Lib, ARow]);
    TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow);
    Niv := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', ARow);
    // VARIANTE
    (* if (TypeL = 'DP' + IntToStr(Niv)) then *)
    if IsDebutParagraphe (TOBL,niv) then
    begin
      Ligne := Arow + 1;
      // VARIANTE
      TOBL := GetTOBLigne(TOBPiece, Ligne);
     (* while (GetChampLigne(TOBPiece, 'GL_TYPELIGNE', Ligne) <> 'TP' + IntToStr(Niv)) do *)
      while not IsFinParagraphe(TobL,Niv) do
      begin
        Ligne := Ligne + 1;
        TOBL := GetTOBLigne(TOBPiece, Ligne);
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

procedure TFFacture.TraitePrix(ARow: integer;PrixRef : double);
var TOBL: TOB;
  PuFix,ValInit: double;
  EnPa,EnHT : boolean;
  RecupPrix: string;
begin
  //
  RecupPrix := GetInfoParPiece(TOBPIece.GetValue('GP_NATUREPIECEG'), 'GPP_APPELPRIX');
  enPa := ((RecupPrix='PAS') or (RecupPrix = 'DPA'));
  EnHt := (TOBPiece.getValue('GP_FACTUREHT')='X');
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  // Modif BTP
  if (IsLigneDetail(nil, TOBL)) or (TOBL.GetValue('GLC_FROMBORDEREAU')='X')  then
  begin
		GS.Cells[Sg_Px, Arow] := stcellCur;
    exit;
  end;
  //
  if (TOBL.GetValue('GL_QTEPREVAVANC') <> 0) and (TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e sur cette ligne.'));
    GS.Cells[Sg_Px, Arow] := stcellCur;
    exit;
  end;
  //
  if GereDocEnAchat then
  begin
  	if EnHt then
    begin
    	PuFix := TOBL.GetValue('GL_PUHTDEV');
    end else
    begin
    	PuFix := TOBL.GetValue('GL_PUTTCDEV');
    end;
  end else
  begin
  	PuFix := Valeur(GS.Cells[SG_Px, ARow]);
  end;

  if IsSousDetail(TOBL) then
  begin
    if TOBL.getValue('GL_BLOQUETARIF')='X' then
    begin
    	GS.Cells[Sg_Px, Arow] := stcellCur;
      Exit;
    end;
  	fModifSousDetail.ModifPVSousDet (TOBL,PuFix);
    exit;
  end;
  if PrixRef <> 0 then ValInit := Prixref else ValInit := PuFix;

  if GP_FACTUREHT.Checked then
  begin
    {$IFDEF BTP}
    if ((TOBL.getValue('GL_TYPEARTICLE') = 'OUV') or (TOBL.getValue('GL_TYPEARTICLE') = 'ARP')) and
      (ValInit <> TOBL.GetValue('GL_PUHTDEV')) and ApplicPrixPose (TOBpiece) then
    begin
      TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL,TOBOuvrage, EnHt, PuFix,0,DEV,EnPA);
      if CalculPieceAutorise then ReinitCoefMarg (TOBL,TOBOuvrage);
    end else
    {$ENDIF}
      TOBL.PutValue('GL_PUHTDEV', PuFix);
      if GereDocEnAchat then
      begin
      	if TOBL.GetValue('GL_DPR')<>0 THEN TOBL.PutValue('GL_COEFMARG',Arrondi(PuFIx/TOBL.GetValue('GL_DPR'),4)) else TOBL.PutValue('GL_COEFMARG',0);
      end else
      begin
      	TOBL.PutValue('GL_COEFMARG',0);
      end;
  end else
  begin
    if ((TOBL.getValue('GL_TYPEARTICLE') = 'OUV') or (TOBL.getValue('GL_TYPEARTICLE') = 'ARP')) and
      (ValInit <> TOBL.GetValue('GL_PUTTCDEV')) and ApplicPrixPose (TOBpiece) then
    begin
      TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL,TOBOuvrage, EnHT, PuFix,0,DEV,EnPa);
      if CalculPieceAutorise then ReinitCoefMarg (TOBL,TOBOuvrage);
    end else
    begin
      TOBL.PutValue('GL_PUTTCDEV', PuFix);
      TOBL.Putvalue('GL_COEFMARG', 0);
    end;
  end;
  if (Pos(TobL.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,true,false,true,false))>0)  and
     (pufix=0) then
  begin
       TOBL.PutValue('GL_DPA', 0);
       TOBL.PutValue('GL_DPR', 0);
  end;
{$IFDEF BTP}
	BligneModif := true;
{$ENDIF}
{$IFDEF BTP}
	if IsCentralisateurBesoin (TOBL) then
  begin
  	RepercutePrixCentralisation (TOBPiece,TOBL,EnHt);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
    exit;
  end;
{$ENDIF}
  //
  if (Action = TaModif) and (Pos(TobL.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) then
  begin
  	if (TOBL.GetValue('BCO_TRAITEVENTE') = 'X' ) then
    begin
  		//PGIInfo (TraduireMemoire ('Attention : Cet article � d�j� �t� livr�.#13#10Les consommations ne seront pas mises � jour.#13#10Veuillez mettre � jour les livraisons de chantiers'),caption);
    	receptionModifie := true;
    	EnregistreLigneLivAModifier(TOBL,0,0);
    end else if TOBL.GetValue('BLP_NUMMOUV')=0 then
    begin
    	// ligne cr�e dans la pi�ce lors de la modif
    	EnregistreLigneLivAModifier(TOBL,0,0);
    end;
  end;
  //
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  {$IFDEF CHR}
  if (TOBL.GetValue('GL_TYPENOMENC') = 'MAC') then
  begin
    HRTraitePrixDetailChr(Self, TobPiece, Arow);
  end;
  {$ENDIF} // FIN CHR
end;

procedure TFFacture.TraitePrixAch(ARow: integer);
var TOBL: TOB;
  PuFix,CoefPapr,CoefprPV: double;
//  sFonctionnalite: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  // Modif BTP
  if (IsLigneDetail(nil, TOBL)) then
  begin
    GS.Cells[Sg_PxAch, Arow] := stcellCur;
    exit;
  end;
  //
  if (TOBL.GetValue('GL_QTEPREVAVANC') <> 0) and (TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e sur cette ligne.'));
    GS.Cells[Sg_Px, Arow] := stcellCur;
    exit;
  end;
  //
  if TOBL.GetValue('GL_DPA') <> 0 then CoefPaPr := TOBL.GetValue('GL_DPR')/TOBL.GetValue('GL_DPA')
  																else CoefPaPr := 1;
  if TOBL.GetValue('GL_DPR') <> 0 then CoefPrPv := TOBL.GetValue('GL_PUHTDEV')/TOBL.GetValue('GL_DPR')
  																else CoefPrPv := 1;
  PuFix := Valeur(GS.Cells[SG_PxAch, ARow]);
  if IsSousDetail (TOBL) then
  begin
		fModifSousDetail.ModifPASousDet (TOBL,puFix );
    exit;
  end;
 {$IFDEF BTP}
  if ((TOBL.getValue('GL_TYPEARTICLE') = 'OUV') or (TOBL.getValue('GL_TYPEARTICLE') = 'ARP')) and
   (Valeur(GS.Cells[SG_PxAch, ARow]) <> TOBL.GetValue('GL_DPA')) and (ApplicPrixPose (TOBpiece)) then
  begin
(*
    if not isExistsArticle (trim(GetParamsoc('SO_BTECARTPMA'))) then
    BEGIN
      PgiBox (TraduireMemoire('L''article d''�cart est invalide ou non renseign�#13#10Veuillez le d�finir'),Traduirememoire('Gestion d''�cart'));
      GS.Cells[Sg_PxAch, Arow] := stcellCur;
      exit;
    END;
*)
//      TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBOuvrage, True, PuFix,DEV);
   TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL,TOBOuvrage, True, PuFix,0,DEV,true);
   GS.cells[SG_pxAch, Arow] := strf00(TOBL.GetValue('GL_DPA'), V_PGI.OKdecP);
	 CalculMontantsDocOuv (TOBpiece,TOBL,TOBOuvrage,(TOBL.GetValue('GL_BLOQUETARIF')='-'));
//   TOBL.PutValue('GL_DPR', Arrondi(TOBL.GetValue('GL_DPA') * CoefPaPr,V_PGI.okDecP));

   if TOBL.GetValue('GL_BLOQUETARIF') = '-' then
   		TOBL.PutValue('GL_PUHTDEV', Arrondi(TOBL.GetValue('GL_DPR') * CoefPrPV,V_PGI.OkdecP));
  end else
  begin
 {$ENDIF}
   TOBL.PutValue('GL_DPA', PuFix);
 {$IFDEF BTP}
   TOBL.PutValue('GL_DPR', Arrondi(PuFix * CoefPaPr,V_PGI.okDecP));
   if TOBL.GetValue('GL_BLOQUETARIF') = '-' then
   		TOBL.PutValue('GL_PUHTDEV', Arrondi(TOBL.GetValue('GL_DPR') * CoefPrPV,V_PGI.OkdecP));
  end;
 {$ENDIF}
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPiece.PutValue('GP_RECALCULER', 'X');
end;

procedure TFFacture.TraiteRemise(ARow: integer);
var TOBL: TOB;
  RemL: Double;
  sFonctionnalite: string;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  RemL := Valeur(GS.Cells[SG_Rem, ARow]);
  if RemL < 0 then RemL := 0 else if RemL > 100.0 then RemL := 100.0;
  TOBL.PutValue('GL_REMISELIGNE', RemL);

  if (GetParamSoc('SO_PREFSYSTTARIF')) then
  begin
    sFonctionnalite := RechercheFonctionnalite(TobL.GetValue('GL_NATUREPIECEG'));
    AnnulationTobLigneTarif(TobL, TobLigneTarif, sFonctionnalite, '15'); //Annulation des remises libres
    AnnulationTobLigneTarif(TobL, TobLigneTarif, sFonctionnalite, '16'); //Annulation des remises syst�mes
    MajTobLigneTarifFromTobLigne(TobL, TobLigneTarif, sFonctionnalite, '1501', 'REMISELIBRE1', RemL);
    TOBL.PutValue('GL_REMISELIBRE1', RemL);
    TOBL.PutValue('GL_REMISELIBRE2', 0);
    TOBL.PutValue('GL_REMISELIBRE3', 0);
  end
  else
  begin
    TOBL.PutValue('GL_VALEURREMDEV', 0);
  end;
  if RemL = 0 then TOBL.PutValue('GL_TYPEREMISE', '');
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  TOBL.PutValue('GL_RECALCULER', 'X');
end;

procedure TFFacture.TraiteMontantRemise(ACol, ARow: integer);
var
  TobLigne : TOB;
  nMontantHT, nRemiseTotale: Double; 
begin
  TobLigne := GetTobLigne(TobPiece, ARow);
  if TobLigne = nil then Exit;
  TobLigne.PutValue('GL_VALEURREMDEV', Valeur(GS.Cells[ACol, ARow]));
  if ( not GetParamSoc('SO_PREFSYSTTARIF') ) then
  begin
    if GP_FACTUREHT.Checked then
      nMontantHT := TobLigne.GetValue('GL_MONTANTHTDEV')
    else
      nMontantHT := TobLigne.GetValue('GL_MONTANTTTCDEV');

    if nMontantHT <> 0 then
      nRemiseTotale := Arrondi(100.0 * Valeur(GS.Cells[ACol, ARow]) / nMontantHT, 6)
    else
      nRemiseTotale := 0;

    TobLigne.PutValue('GL_REMISELIGNE', nRemiseTotale);
    if nRemiseTotale = 0 then
    begin
      TobLigne.PutValue('GL_VALEURREMDEV', 0);
      TobLigne.PutValue('GL_TOTREMLIGNEDEV', 0);
      TobLigne.PutValue('GL_TYPEREMISE', '');
      if SG_RV > 0 then GS.Cells[SG_RV, ARow] := '';
      if SG_RL > 0 then GS.Cells[SG_RL, ARow] := '';
    end;
  end;
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  TobLigne.PutValue('GL_RECALCULER', 'X');
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
end;
{$ENDIF} // FIN Modif MODE 31/07/2002

procedure TFFacture.TraiteDateLiv(ACol, ARow: integer);
var TOBL: TOB;
  DateLiv: TDateTime;
  i: Integer;
{$IFDEF BTP}
	indice: integer;
{$ENDIF}
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
{$IFDEF BTP}
  if TOBL = nil then exit;
  if TOBL.GetValue('GL_TYPELIGNE') <> 'ART' then exit;
{$ENDIF}
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
{$IFDEF BTP}
	AppliqueChangeDate(Arow,TOBPiece,TOBOuvrage);
  for Indice := Arow to GS.rowCount -1 do AfficheLaLigne (Indice);
{$ENDIF}
end;

{==============================================================================================}
{=============================== Manipulation des Qt�s ========================================}
{==============================================================================================}

procedure TFFacture.DeflagTarif(ARow: integer);
var TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  TOBL.PutValue('RECALCULTARIF', '-');
end;

function TFFacture.TraiteRupture(ARow: integer; Bparle : boolean= true): boolean;
var TOBL, TOBA, TOBD, TOBLiee, TOBCata: TOB;
  Depot, OldNat, ColPlus, ColMoins, ArtSub, sComp, CalcRupture: string;
  QteSais, QteDisp, RatioVA, QteAdd, RatioAdd: Double;
  AddQ, AnnuArt: Boolean;
  {$IFDEF BTP}
  ResteReserve,CoefPaPr : double;
  {$ENDIF}
begin
  Result := True;
  if Action = taConsult then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if TOBL.GetValue('_RUPTURE_AUTH_') = 'X' Then BEGIN result := true; exit; END;

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
{$IFDEF BTP}
  if (TOBL.GetValue('GL_TENUESTOCK') <> 'X') and (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X')  then
  begin
  	AnnuArt := true;
    if TOBL.getValue('GL_PIECEPRECEDENTE') <> '' then
    begin
    	CoefPaPr := 0;
      QteDisp := gestionConso.GetQteLivrable (TOBL);
      if (TOBL.FieldExists ('DPARECUPFROMRECEP')) and (TOBL.GetValue ('DPARECUPFROMRECEP') > 0) then
      begin
        if TOBL.GetValue('GL_DPA') <> 0 then CoefPaPR := TOBL.GetValue('GL_DPR')/TOBL.GetValue('GL_DPA');
        if CoefPaPr = 0 then CoefPaPr := 1;
      	TOBL.PutValue('GL_DPA', TOBL.GetValue ('DPARECUPFROMRECEP'));
        TOBL.PutValue('GL_DPR', Arrondi(TOBL.GEtValue('GL_DPA')*CoefPaPr,V_PGI.okdecP));
      end;
      if QteSais <= QteDisp then Exit;
    end else
    begin
      if Pos(TOBL.GetValue('GL_NATUREPIECEG'),'LBT') > 0 then exit;
    end;
    if bParle and not MultiSel_SilentMode then
    begin
      if ((ForceRupt) and (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X')) then
      begin
        if HPiece.Execute(10, caption, sComp) = mrYes then AnnuArt := False;
      end else
      begin
      	if TOBL.GetValue('_RUPTURE_AUTH_') = '-' Then
        begin
          if PgiAsk(TraduireMemoire('Cette marchandise n''a pas �t� r�ceptionn�e.#13#10Confirmez-vous la livraison ?'),caption )=MrYes then
          begin
            AnnuArt := false;
          end;
        end else
        begin
          Exit;
        end;
    	end;
//    	HPiece.Execute(11, caption, sComp);
    end;
  	if AnnuArt then Result := False;
  end;
{$ENDIF}
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
		QteDisp := gestionConso.GetQteLivrable (TOBL);
    if (TOBL.FieldExists ('DPARECUPFROMRECEP')) and (TOBL.GetValue ('DPARECUPFROMRECEP') > 0) then
    begin
    	CoefPaPr :=  0;
      if TOBL.GetValue('GL_DPA') <> 0 then CoefPaPR := TOBL.GetValue('GL_DPR')/TOBL.GetValue('GL_DPA');
      if CoefPaPr = 0 then CoefPaPr := 1;
      TOBL.PutValue('GL_DPA', TOBL.GetValue ('DPARECUPFROMRECEP'));
      TOBL.PutValue('GL_DPR', Arrondi(TOBL.GEtValue('GL_DPA')*CoefPaPr,V_PGI.okdecP));
    end;
    QteAdd := 0;
  end else
  begin
    if (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X') then
    begin
      QteDisp := TOBD.GetValue('GQ_PHYSIQUE');
      AddQ := False;
      QteAdd := 0;
      if CalcRupt = 'DIS' then
      begin
        QteDisp := QteDisp - TOBD.GetValue('GQ_RESERVECLI') - TOBD.GetValue('GQ_PREPACLI');
{$IFDEF BTP}
        ResteReserve := GetQteResteCdeOrigine (TOBL);
        if (Action = TaModif) then QteDisp := QteDisp + ResteReserve;
{$ENDIF}
      end;
    end else
    begin
      QteDisp := TOBD.GetValue('GQC_PHYSIQUE');
      AddQ := False;
      QteAdd := 0;
      //QteDisp:=QteDisp-TOBD.GetValue('GQC_RESERVECLI')-TOBD.GetValue('GQC_PREPACLI') ;
      QteDisp := QteDisp - TOBD.GetValue('GQC_PREPACLI');
    end;
    // Cas particulier rappel de pi�ce
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
  if bParle and not MultiSel_SilentMode then
  begin
    if ((ForceRupt) and (TOBL.GetValue('GL_ENCONTREMARQUE') <> 'X')) then
    begin
      if HPiece.Execute(10, caption, sComp) = mrYes then AnnuArt := False;
    end else
    begin
      HPiece.Execute(11, caption, sComp);
    end;
  end else if MultiSel_SilentMode then
  begin
    SelInfoRupture := true;
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
  Qte, Qtepre, Pourcentage, QteEcart, QTeDejaFact: Double;
begin
  Result := True;
  QteDejaFact := 0;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;

  if not ModifAvanc then
  begin
    // -------------------------
    // Saisie Avancement
    // -------------------------
    Qte := Valeur(GS.Cells[SG_QA, ARow]);
    Pourcentage := Valeur(GS.Cells[SG_Pct, ARow]);
    Qtepre := TOBL.GetValue('GL_QTEFACT');
    if TypeFacturation = 'DIR' then QteDejaFact := TOBL.GetValue ('GL_QTESIT');

    if Qtepre <> 0 then
    begin
      if (ACol = SG_QA) then Pourcentage := Qte / Qtepre * 100
      else Qte := Qtepre * Pourcentage / 100;
    end else
    begin
      if (ACol = SG_QA) then Pourcentage := 0
      else Qte := 0;
    end;
    QteEcart := ((Pourcentage/100) * QtePre) - TOBL.GetValue ('GL_QTESIT');
    if (Pourcentage > 100) or ((TypeFacturation='DIR')  and (Qte+QteDejaFact > QtePre))then
    begin
      if PGIask (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement > a 100 % ?'),
                Caption) <> mrYes then
      begin
        result := false;
        AfficheLaLigne (ARow);
        exit;
      end;
    end else
    if (TypeFacturation='AVA') and (Abs (QteEcart + TOBL.GetValue('GL_QTESIT')) < abs(TOBL.GetValue('GL_QTESIT'))) then
    begin
      if PGIask (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement inf�rieur � celui de la situation pr�c�dente ?'),
                Caption) <> mrYes then
      begin
        result := false;
        AfficheLaLigne (ARow);
        exit;
      end;
    end ;
		Qte:=Arrondi(Qte,V_PGI.OkDecQ);
    TOBL.PutValue('GL_QTEPREVAVANC', Qte);
//
  end else
  begin
    // -------------------------
    // Modification Avancement
    // -------------------------
    QtePre := TOBL.GetValue('GL_QTEPREVAVANC');
    Qte := Valeur(GS.Cells[SG_QF, ARow]); // Recup de la quantit� saisie
//    QTeDejaFact := TOBL.GetValue('GL_QTESIT');// Recup de la quantit� d�j� factur�e
    QTeDejaFact := TOBL.GetValue('DEJAFACT');// Recup de la quantit� d�j� factur�e
    Pourcentage := Valeur(GS.Cells[SG_Pct, ARow]); // recup de l'avancement saisie
    if ((Pourcentage > 100) and (Acol=SG_Pct)) or ((Qte+QTeDejaFact > QtePre) and (Acol<>SG_Pct))then
    begin
      if PGIask (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement > a 100 % ?'),
                Caption) <> mrYes then
      begin
        result := false;
        AfficheLaLigne (ARow);
        exit;
      end;
    end;
    if (Acol = SG_QF) then
    begin
      if QtePre > 0 then Pourcentage := arrondi(((Qte + TOBL.GetValue('DEJAFACT')) / QtePre) * 100,2)
                    else Pourcentage := 100;
      if Qte +TOBL.GetValue('DEJAFACT') < TOBL.GetValue('OLD_QTESIT') then
      begin
        if PGIask (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement inf�rieur � celui indiqu� pr�c�demment'),
                  Caption) <> mrYes then
        begin
          result := false;
          AfficheLaLigne (ARow);
          exit;
        end;
      end;
    end else
    begin
      Qte := ((Pourcentage/100) * TOBL.GetValue('GL_QTEPREVAVANC')) - TOBL.GetValue ('DEJAFACT');
      if Qte + TOBL.GetValue('DEJAFACT') < TOBL.GetValue('OLD_QTESIT') then
      begin
        if PGIask (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement inf�rieur � celui indiqu� pr�c�demment'),
                  Caption) <> mrYes then
        begin
          result := false;
          AfficheLaLigne (ARow);
          exit;
        end;
      end;
    end;
		Qte:=Arrondi(Qte,V_PGI.OkDecQ);
    TOBL.PutValue ('GL_QTEFACT',QTe);
    TOBL.PutValue ('GL_QTERESTE',QTe);
    TOBL.PutValue ('GL_QTESTOCK',QTe);
  end;
  TOBL.PutValue('GL_POURCENTAVANC', Pourcentage);
  TOBL.PutValue('GL_RECALCULER', 'X');
  TOBPiece.PutValue('GP_RECALCULER', 'X'); // permet de relancer le calcul global de la pi�ce
  TOBL.PutValue('QTECHANGE','X')
end;

function TFFacture.TraiteQte(ACol, ARow: integer; Bparle : boolean = true): Boolean;
var TOBL, TOBA, TOBLiee: TOB;
  NewQte, Qte, OldQte, Ecart: Double;
  OkCond: boolean;
  RefUnique: string;
  lCtrlMinimum : boolean;
  nQteEcoAchat, nQteEcoVente, nQtePCBAchat : double;
  {$IFDEF BTP}
  reliquatInit,ResteInit,QteFactInit,QteStockInit : double;
  {$ENDIF}
begin
  Result := True;
  TOBA := nil;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  {$IFDEF BTP}
  //
  if (TOBL.GetValue('GL_QTEPREVAVANC') <> 0) and (TOBPiece.GetValue('GP_NATUREPIECEG')='DBT') then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e sur cette ligne.'));
    GS.Cells[Acol, Arow] := stcellCur;
    result := false;
    exit;
  end;
  //
  TOBL.PutValue('_RUPTURE_AUTH_','-');
  ResteInit := TOBL.GetValue('GL_QTERESTE');
  ReliquatInit := TOBL.GetValue('GL_QTERELIQUAT');
  QteFactInit := TOBL.GetValue('GL_QTEFACT');
  QteStockInit := TOBL.GetValue('GL_QTESTOCK');
  BligneModif := true;
  {$ENDIF}
  Qte := Valeur(GS.Cells[ACol, ARow]);
  //
  if IsSousDetail(TOBL) then
  begin
  	fModifSousDetail.ModifQteSousDet (TOBL,Qte);
    exit;
  end;
  //
	if OrigineEXCEL then
  begin
    GS.Cells[Acol, Arow] := stcellCur;
    exit;
  end;
  //
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if not AutoriseQteNegative(ACol, ARow, Qte) then exit;
  if (Action = taModif) and (not DuplicPiece) and (ACol = SG_QF) then { NEWPIECE }
  begin
    { Lors de la modification d'une pi�ce, emp�che que la nouvelle quantit� saisie soit inf�rieure au total des quantit�s
      des lignes. (Par exemple la quantit� command�e ne peut-�tre inf�rieure au total des quantit�s livr�es) }
    if not VerifQuantitePieceSuivante(TobL, Qte) then
    begin
      HPiece.Execute(51, Caption, '');
      AfficheLaLigne(ARow);
      EXIT;
    end;
  end;
  if (Action = taModif) and (TransfoPiece)  and (TOBPiece.GetValue('GP_NATUREPIECEG')='FF') and (ACol = SG_QF) then
  begin
    { Lors de la g�n�ration d'une facture fournisseur, emp�che que la nouvelle quantit� saisie soit sup�rieure
      � la quantit� r�ceptionn�e. }
    if (Qte > QteFactInit) and (TOBL.GetValue('QTEORIG')<>0) then
    begin
  	  PGIError (TraduireMemoire ('La quantit� factur�e ne peut �tre sup�rieure � celle livr�e.#13#10 Saisir une ligne de la quantit� suppl�mentaire pour le m�me article.#13#10 Une livraison chantier sera g�n�r�e automatiquement#13#10 si la livraison directe sur chantier est param�tr�e.'),caption);
      AfficheLaLigne(ARow);
      EXIT;
    end;
  end;
  {$IFDEF BTP}
  if GetParamSocSecur('SO_METRESEXCEL',true) then
  begin
    if (not OrigineEXCEL) and (ATraiterQte) then
    begin
      if (not TheMetre.QteModifie(TOBL)) then
      begin
        GS.Cells[ACol, ARow] := StCellCur;
        ATraiterQte := true;
        exit;
      end;
    end;
  end;
  ATraiterQte := true;
  {$ENDIF}
  // Conditionnement
  OkCond := AdapteCond(TOBL, TOBConds, Qte);
  if OkCond then
  begin
    GS.Cells[ACol, ARow] := StrF00(Qte, 10);
    FormateZoneSaisie(ACol, ARow);
  end
  else
  begin
    { Ce test est pour la mode car il g�n�re les pi�ces � qt� 0 et donc il ne faut pas appliquer la r�gle du PCB }
{$IFDEF GPAO}
    if (not TransfoPiece) or (Qte<>0) then
{$ELSE}
    if (Qte<>0) then
{$ENDIF}
    begin
      TobA := FindTobArtRow(TobPiece, TobArticles, ARow);
      if (TobA=nil) then
      begin
        nQteEcoVente := 0;
        nQteEcoAchat := 0;
        nQtePCBAchat := 0;
      end
      else
      begin
        nQteEcoVente := TobA.getValue('GA_QECOVTE');
        nQteEcoAchat := TobA.getValue('GA_QECOACH');
        nQtePCBAchat := TobA.GetValue('GA_QPCBACH');
      end;
      OldQte := Qte;                                                                                                             // Valeur saisie
      lCtrlMinimum := (not TransfoPiece) and (TobL.GetValue('GL_PIECEPRECEDENTE')='');
      if      (VenteAchat = 'VEN') then
        Qte := AjusteQte_MiniMultiple(Qte, iif(lCtrlMinimum, nQteEcoVente, 0), TobL.GetValue('GL_PCB'))   // Valeur Ajust�e
      else if (VenteAchat = 'ACH') then
        Qte := AjusteQte_MiniMultiple(Qte, iif(lCtrlMinimum, nQteEcoAchat, 0), nQtePCBAchat             ); // Valeur Ajust�e
      if (OldQte<>Qte) then //Si Valeur Saisie <> Valeur Ajust�e
      begin
        GS.Cells[ACol, ARow] := StrF00(Qte, 10);
        FormateZoneSaisie(ACol, ARow);
        TOBPiece.PutValue('GP_RECALCULER', 'X');
        TOBL.PutValue('GL_RECALCULER', 'X');
      end;
    end;
  end;
{$IFDEF BTP}
  if TOBA = nil then TobA := FindTobArtRow(TobPiece, TobArticles, ARow);
  if not ControlQteRecepInAchat (self,TOBL,TOBA,Acol,Arow) Then
  begin
    FormateZoneSaisie(ACol, ARow);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    result := false;
    exit;
  end;
  if IsCentralisateurBesoin (TOBL) then
  begin
    TheRgpBesoin.ModifQteCentralisateur(Arow);
  end;
{$ENDIF}
  if (ACol = SG_QF) or (ACol = SG_QS) then
  begin
    { NEWPIECE }
    NewQte := Valeur(GS.Cells[ACol, ARow]);
    if (ACol = SG_QS) then
    begin
      OldQte := TOBL.GetValue('GL_QTESTOCK');
      TOBL.PutValue('GL_QTESTOCK', Valeur(GS.Cells[ACol, ARow]));
      if SG_QF < 0 then TOBL.PutValue('GL_QTEFACT', NewQte);
// MODIF BRL 28/06/05			if GetInfoParPiece(NewNature, 'GPP_RECALCULPRIX') = 'X' then TOBL.PutValue('RECALCULTARIF','X');
    end
    else //if (ACol = SG_QF) then pour �viter avertissement
    begin
      OldQte := arrondi(TOBL.GetValue('GL_QTEFACT'),V_PGI.OkDecQ);
      TOBL.PutValue('GL_QTEFACT', Valeur(GS.Cells[ACol, ARow]));
      if SG_QS < 0 then TOBL.PutValue('GL_QTESTOCK', NewQte);
// MODIF BRL 28/06/05			if GetInfoParPiece(NewNature, 'GPP_RECALCULPRIX') = 'X' then TOBL.PutValue('RECALCULTARIF','X');
    end;
    if (OldQte <> NewQte) then // and (not EstLigneSoldee(TOBL)) then     DBR 07112003
    begin
      TOBL.PutValue('GL_QTERESTE', TOBL.GetValue('GL_QTERESTE') - OldQte + NewQte);
      PutQteReliquat(Tobl, OldQte);
    end;
    if (TOBL.GetValue('RECALCULTARIF') = 'X') and (not GetParamSoc('SO_PREFSYSTTARIF')) then
    begin
      TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
      TarifVersLigne(TobA, TobTiers, TobL, TobLigneTarif, TobPiece, TobTarif, True, True, DEV);
      AfficheLaLigne(ARow);
    end;

    TOBPiece.PutValue('GP_RECALCULER', 'X');
    TOBL.PutValue('GL_RECALCULER', 'X');
    {$IFDEF BTP}
     CalculeAvancementBTP ( self,TobPiece,TOBL,Acol,Arow,OldQte);
    {$ENDIF}
    {$IFDEF CHR}
    if (TOBL.GetValue('GL_TYPENOMENC') = 'MAC') then
      HRTraiteQteDetailChr(Self,TOBPiece,TobArticles,TobTiers,TobTarif, TobLigneTarif,ARow,ACol,Dev,OldQte);
    {$ENDIF}
  end;
  {$IFDEF GPAO}
  if ((ACol = SG_QF) or (SG_QF < 0)) and (not GetParamSoc('SO_PREFSYSTTARIF')) then TOBL.PutValue('RECALCULTARIF', '-');
  {$ELSE}
  if ((ACol = SG_QF) or (SG_QF < 0)) then TOBL.PutValue('RECALCULTARIF', '-');
  {$ENDIF GPAO}
  if ReliquatTransfo then
  begin
    TOBLiee := GetTOBPrec(TOBL, TOBPiece_O);
    if TOBLiee <> nil then
    begin
      NewQte := TOBL.GetValue('GL_QTESTOCK');
      OldQte := TOBLiee.GetValue('GL_QTERESTE');
      if OldQte > NewQte then Ecart := OldQte - NewQte else Ecart := 0;
      TOBL.PutValue('GL_QTERELIQUAT', Ecart);
      TOBPiece.PutValue('GP_RECALCULER', 'X');
      TOBL.PutValue('GL_RECALCULER', 'X');
    end;
  end;
  if not TraiteRupture(ARow,Bparle) then
  begin
{$IFDEF BTP}
    TOBL.PutValue('GL_QTEFACT', QteFactInit);
    TOBL.PutValue('GL_QTESTOCK', QteStockInit);
    TOBL.PutValue('GL_QTERESTE', ResteInit);
    TOBL.PutValue('GL_QTERELIQUAT', ReliquatInit);
    AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
    TOBL.PutValue('GL_RECALCULER', '-');
   	StCellCur  := GS.Cells[SG_QF, ARow];
{$ELSE}
    if SG_QF >= 0 then GS.Cells[SG_QF, ARow] := '';
    if SG_QS >= 0 then GS.Cells[SG_QS, ARow] := '';
{$ENDIF}
    Result := False;
  end;
  {$IFDEF AFFAIRE}
  if not TraiteFormuleVar(ARow, 'AUTORISE') then //Affaire-Formule des variables
  begin
    GS.Cells[SG_QF, ARow] := StCellCur;
    TOBL.PutValue('GL_QTEFACT', Valeur(StCellCur));
    Result := False;
  end;
  {$ENDIF}
  if (TOBL.getValue('GL_NATUREPIECEG')='FBT') and (Result) then
  begin
    TOBL.PutValue('QTECHANGE', 'X');
    TOBL.PutValue('GL_QTESIT',TOBL.GetValue('GL_QTEFACT'));
    TOBL.PutValue('GL_QTEPREVAVANC',TOBL.GetValue('GL_QTEFACT'));
  end;
  {$IFDEF BTP}
  if (Action = TaModif) and (Pos(TobL.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0)  then
  begin
  	if (TOBL.GetValue('BCO_TRAITEVENTE') = 'X' ) then
    begin
      //PGIInfo (TraduireMemoire ('Attention : Cet article � d�j� �t� livr�.#13#10Les consommations ne seront pas mises � jour.#13#10Veuillez mettre � jour les livraisons de chantiers'),caption);
      receptionModifie := true;
      EnregistreLigneLivAModifier(TOBL,Qte,0);
    end else if TOBL.GetValue('BLP_NUMMOUV')=0 then
    begin
    	// ligne cr�e dans la pi�ce lors de la modif
    	EnregistreLigneLivAModifier(TOBL,0,0);
    end;
  end;
  {$ENDIF}
  //if (ctxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM')='DIM') then
  if TOBL.GetValue('GL_TYPEDIM') = 'DIM' then
  begin
    TOBL := TOBPiece.FindFirst(['GL_CODESDIM', 'GL_TYPEDIM'], [TOBL.GetValue('GL_CODEARTICLE'), 'GEN'], False);
    if TOBL <> nil then AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
  end;
  CalculheureTot (TOBL);
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
  CanSoldeReliquat: Boolean ;
  WarningSuppression,GestionReliquat : boolean;
begin
	WarningSuppression := false;
  TOBDim.ClearDetail;
  ANCIEN_TOBDimDetailCount := 0;
  CanSoldeReliquat := True ;
  GestionReliquat := (GetInfoParPiece (TOBPiece.GetValue('GP_NATUREPIECEG'),'GPP_RELIQUAT')='X');
  //iLigne:=0 ;
  Q := OpenSQL('Select GA_Article from Article where GA_CodeArticle="' + CodeArticle + '" AND GA_STATUTART="DIM" order by GA_ARTICLE', True,-1, '', True);
  while not Q.EOF do
  begin
    TOBD := TOB.Create('', TOBDim, -1);
    if Action <> taConsult then
    begin
      QteDejaSaisi := CalcQteDejaSaisie(TOBPiece, Q.FindField('GA_ARTICLE').AsString);
      ReliqDejaSaisi := CalcQteDejaSaisie(TOBPiece_OS, Q.FindField('GA_ARTICLE').AsString);
    end
    else
    begin
      QteDejaSaisi := 0.0;
      ReliqDejaSaisi := 0.0
    end;
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
          { Ancien fonctionnement
            mais inutile : TOBD.GetValue('QteDejaSaisi') et TOBD.GetValue('ReliqDejaSaisi') sont � jour !
          QteDejaSaisi:=CalcQteDejaSaisie(TOBPiece,TOBD.GetValue('GA_ARTICLE')) ;
          ReliqDejaSaisi:=CalcQteDejaSaisie(TOBPiece_O,TOBD.GetValue('GA_ARTICLE')) ;
          LigneVersDim(TOBL,TOBD,QteDejaSaisi,ReliqDejaSaisi) ;
          }
          // Modif AC Gestion du Solde reliquat
          CanSoldeReliquat := CanModifyLigne(TOBL, TransfoPiece, TobPiece_O,WarningSuppression,GestionReliquat) ;
          //
          ANCIEN_TOBDimDetailCount:=ANCIEN_TOBDimDetailCount+1 ;
          LigneVersDim(TOBL, TOBD, TOBD.GetValue('_QteDejaSaisi'), TOBD.GetValue('_ReliqDejaSaisi'));
          Break;
        end else
        begin
          inc(iLigne);
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
  // Modif AC Gestion du Solde reliquat
  if Not CanSoldeReliquat then TOBDim.AddChampSup('_NotModifDim', False) ;
  //
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

// AC - Correction fiche Mode 10684
procedure TFFacture.SupprimeDim(Arow: integer) ;
Var CodeArticle : String ;
i : integer ;
begin
  CodeArticle := GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', ARow) ;
  i := Arow ;
  while (i <= TOBPiece.Detail.count-1) and (TOBPiece.Detail[i].GetValue('GL_TYPEDIM') = 'DIM') do
  begin
    if TOBPiece.Detail[i].GetValue('GL_CODEARTICLE')<> CodeArticle then
    begin
      TOBPiece.Detail[i].Free ;
      DeleteTobLigneTarif(TobPiece, i);
      GS.DeleteRow(i + 1);
    end else inc(i) ;
  end ;
AffichageDim(ARow) ;
end ;
// Fin AC

procedure TFFacture.TraiteLesDim(var ARow: integer; NewArt: boolean);
var RefUnique, CodeArticle, LeCom, TypeDim, LibDim, Grille, CodeDim, CodeArrondi, ArtLie : string;
  TOBL, TOBD, TOBA, TOBArt: TOB;
  i, NbD, LaLig, ACol, k, NbDimInsert, j, NbSup, Indice, ifam, NumOrdre, OldR: integer;
  Cancel, Premier, OkPxUnique, RemA, ModifLigne: boolean;
  Qte, TotQte, Prix, PrixUnique, TotPrix, Remise, TotRem: Double;
  Marge, MontantHT, MontantTTC, TotalHT, TotalTTC, QteReliq: Double; //MAJ Ligne GEN
  TobTemp, TobCond : TOB;
  RefGen, OldRefPrec : string;
  FamilleTaxe: array[1..5] of string;
begin
	NbSup := 0;
  // AC 07/08/03 Optimisation saisie dimension
  OldR := ARow;
  // Fin AC
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (TOBDim.Detail.Count <= 0) and (TOBDim.FieldExists('ANNULE')) then
  begin
    TOBDim.DelChampSup('ANNULE', False);
    exit;
  end; //saisie dim annul�
  // Evite d'exectuter n fois les requ�tes
  RefGen := TOBL.GetValue('GL_CODEARTICLE');
  RefUnique := TOBL.GetValue('GL_ARTICLE');
  if RefGen = '' then RefGen := TOBL.GetValue('GL_CODESDIM');
  if RefUnique = '' then RefUnique := CodeArticleUnique2(RefGen, '');
  TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
  if ((TOBArt = nil) or (TOBArt.GetValue('GA_STATUTART') = 'GEN')) then
  begin
    if ExisteSQL('SELECT GAL_ARTICLE FROM ARTICLELIE WHERE GAL_TYPELIENART="LIE" AND GAL_ARTICLE="' + RefGen + '"') then
      ArtLie := 'X' else ArtLie := '-';
    ChargeNewDims(TOBConds, TOBArticles, TOBDim,
      CreerQuelDepot(TOBPiece),
      TOBL.GetValue('GL_TIERS'),
      IsTransfert(TOBPiece.GetValue('GP_NATUREPIECEG')));
    DispoChampSupp(TOBArticles);
  end;

    {QArticle := OpenSQL('Select * from Article where GA_CODEARTICLE="' + RefGen + '" AND GA_STATUTART ="DIM"', True);
    //JD : Chargement de tous les d�p�ts en multi-d�p�ts sinon chargement du d�p�t courant
    // et si transfert, chargement du d�p�t r�cepteur en plus du d�p�t �metteur
    StQuelDepot := CreerQuelDepot(TOBPiece);
    if StQuelDepot <> '' then StQuelDepot := ' AND GQ_DEPOT IN (' + StQuelDepot + ')';
    QDispo := OpenSQL('Select * from Dispo where GQ_ARTICLE like "' + Copy(RefUnique, 1, 18) + '%" ' +
      'AND GQ_CLOTURE="-"' + StQuelDepot, True);
    QCond := OpenSQL('SELECT * FROM CONDITIONNEMENT WHERE GCO_ARTICLE="' + Copy(RefUnique, 1, 18) + '%" ORDER BY GCO_NBARTICLE', True);
    QCata := OpenSQL('SELECT * FROM CATALOGU WHERE GCA_TIERS="' + TOBL.GetValue('GL_TIERS') + '" AND GCA_ARTICLE="' + Copy(RefUnique, 1, 18) +
      '%" ORDER BY GCA_ARTICLE', True);
    TobTempArt := nil;
    TobTempArtDim := nil;
    TobDispo := nil;
    TobTempCata := nil ;
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
    if not QCata.EOF then
    begin
      TobTempCata := TOB.Create('LesCatalogu', nil, -1);
      TobTempCata.LoadDetailDB('CATALOGU', '', '', QCata, False);
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
      //Affecte les catalogu aux articles s�lectionn�s
      if TobTempCata <> nil then
      begin
        TobTempCataArt := TobTempCata.FindFirst(['GCA_ARTICLE'], [RefUnique], False);
        while TobTempCataArt <> nil do
        begin
          for iChamp := 0 to TobTempCataArt.NbChamps do
          begin
            NomChamp := TobTempCataArt.GetNomChamp(i);
            TOBArt.AddChampSup(NomChamp, False);
            TOBArt.PutValue(NomChamp, TobTempCataArt.GetValue(NomChamp));
          end;
          TOBArt.AddChampSup('DPANEW', False);
          TOBArt.PutValue('DPANEW', TOBArt.GetValue('GCA_DPA'));
          TobTempCataArt := TobTempCata.FindNext(['GCA_ARTICLE'], [RefUnique], False);
        end;
      end;
    end;
    Ferme(QArticle);
    Ferme(QDispo);
    Ferme(QCond);
    Ferme(QCata);
    TobTempArt.Free; //TobTempArt:=nil ;
    TobDispo.Free; //TobDispo:=nil ;
    TobTempCata.Free ;
    //$IFNDEF EAGLCLIENT fonction en CWAS 07/03/2003
    DispoChampSupp(TOBArticles);
    //$ENDIF
  end;}

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
    if TOBDim.Detail.Count = 0 then MAJLigneDim(ARow) //G�n�ration de pi�ce en aveugle
    else ReconstruireTobDim(ARow);
  end else
  begin
    if (ANCIEN_TOBDimDetailCount <> 0) then NbSup := SupDimAZero(GS, CodeArticle, TOBDim, TOBPiece, ARow) else NbSup := 0; // Supprime si QTE=0 dans THDim
    if TOBDim.Detail.Count = 0 then
    begin
      CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, ARow);
      AffichageDim(OldR) ;
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
    if RemA then Remise := Valeur(TOBD.GetValue('GL_REMISELIGNE')); //Si remiseligne autoris� sur l'article
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
      // AC 7/08/03 Optimisation saisie dimension
      if (NbDimInsert > 0) and (ARow < TobPiece.Detail.Count) then
      begin
        // Important dans le cas d'intertion en milieu de pi�ce
        InsertTOBLigne(TOBPiece, Lalig);
        TOBPiece.Detail[TobPiece.Detail.count - 1].Free;
        DeleteTobLigneTarif(TobPiece, TobPiece.Detail.count - 1);
        //GS.DeleteRow(TobPiece.Detail.count + 1);
        NbDimInsert := NbDimInsert - 1;
        GS.RowCount := GS.RowCount + 1;   // MODIF LM 141103
      end;
      // FIN AC
      TraiteArticle(ACol, LaLig, Cancel, False, False, Qte);
      if Cancel then Continue;
      GS.Cells[SG_RefArt, LaLig] := CodeArticle;
    end;
    TOBL := GetTOBLigne(TOBPiece, LaLig);
    TOBL.PutValue('GL_TYPEDIM', 'DIM');
    TOBL.PutValue('GL_QTEFACT', Qte);
    TOBL.PutValue('GL_QTESTOCK', Qte); { NEWPIECE }
    TOBL.PutValue('GL_CODEARRONDI', CodeArrondi);
    TOBL.PutValue('ARTSLIES', ArtLie);
    TOBL.PutValue('GL_RECALCULER', 'X');
    // AC - Correction fiche mode 11008 (Appliquer la commision au dimension)
    CommVersLigne(TOBPiece, TOBArticles, TOBComms, LaLig, True);
    //
    if RemA then TOBL.PutValue('GL_REMISELIGNE', Remise); //Si remiseligne autoris� sur l'article
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  //CalculeLaSaisie(-1, -1, False);  //AC Correction fiche 10834
  {Article g�n�rique passe en commentaire}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  LeCom := TOBL.GetValue('GL_LIBELLE');
  OldRefPrec := TOBL.GetValue('GL_PIECEPRECEDENTE');
  { NEWPIECE : Sauvegarde du num�ro d'ordre de la ligne g�n�rique }
  NumOrdre := TOBL.GetValue('GL_NUMORDRE');
  // AC 07/08/03 Optimisation saisie dimension
  ClickDel(ARow, True, False, False, True);
  // Fin AC
  ClickInsert(ARow);
  TOBL := GetTOBLigne(TOBPiece, ARow);
  TOBL.PutValue('GL_LIBELLE', LeCom);
  TOBL.PutValue('GL_PIECEPRECEDENTE', OldRefPrec);
  { NEWPIECE : Restauration du num�ro d'ordre de la ligne g�n�rique }
  TOBL.PutValue('GL_NUMORDRE', NumOrdre);
  TOBL.PutValue('GL_TYPEDIM', 'GEN');
  // MODIF VARIANTE
  (*TOBL.PutValue('GL_TYPELIGNE', 'COM'); *)
  SetLigneCommentaire (TobPiece,TOBL,Arow);
  //
  TOBL.PutValue('GL_QTEFACT', TotQte);
  TOBL.PutValue('GL_QTESTOCK', TotQte);
  TOBL.PutValue('GL_CODESDIM', CodeArticle);
  TOBL.PutValue('GL_CODEARRONDI', CodeArrondi);
  // pour InfoLignes
  TOBL.PutValue('GL_DATELIVRAISON', TobPiece.GetValue('GP_DATELIVRAISON'));
  TOBL.PutValue('GL_REFARTSAISIE', CodeArticle);
  CalculeLaSaisie(-1, -1, False);  //AC Correction fiche 10834
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
  {Rebalayage des lignes dimensionn�es}
  GS.RowHeights[TOBPiece.Detail.Count + 1] := GS.DefaultRowHeight;
  // AC 07/08/03 Optimisation saisie dimension
  if NewArt then AffichageDim(OldR) else AffichageDim;
  // Fin AC
  TOBDim.ClearDetail;
end;

//modif 02/08/2001

procedure TFFacture.AffichageDim(MajLigne: integer = 0); // Pour g�rer l'affichage par rapport � DimSaisie
var TOBA, TOBL: Tob;
  Grille, CodeDim, LibDim, LibGen: string;
  k, i: integer;
begin
  if MajLigne>0 then Dec(MajLigne) ;
  if (GS.RowCount<=TobPiece.detail.count + NbRowsPlus) then GS.RowCount := GS.RowCount + NbRowsPlus ;   // Modif LM 141103
  for i := MajLigne to TOBPiece.Detail.Count - 1 do
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

{==============================================================================================}
{=============================== Manipulation des articles ====================================}
{==============================================================================================}

procedure TFFacture.CodesArtToCodesLigne(TOBArt: TOB; ARow: integer);
var TOBL: TOB;
  RefSais: string;
  No       : integer ;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow); if TOBL=Nil then Exit ;
  if not (tModeSaisieBordereau in SaCOntexte) then
  begin
  No:=TOBL.GetValue('GL_NUMORDRE') ; TOBL.InitValeurs; TOBL.PutValue('GL_NUMORDRE',No) ;
	TOBL.PutValue('BLP_NUMMOUV',0);
  InitLesSupLigne(TOBL);
  end;
  RefSais := Trim(Copy(GS.Cells[SG_RefArt, ARow], 1, 18));
  TOBArt.PutValue('REFARTSAISIE', RefSais);
  TOBL.PutValue('GL_ARTICLE', TOBArt.GetValue('GA_ARTICLE'));
  TOBL.PutValue('GL_REFARTSAISIE', TOBArt.GetValue('REFARTSAISIE'));
  TOBL.PutValue('GL_CODEARTICLE', TOBArt.GetValue('GA_CODEARTICLE'));
  TOBL.PutValue('GL_REFARTBARRE', TOBArt.GetValue('REFARTBARRE'));
  TOBL.PutValue('BNP_TYPERESSOURCE', TOBArt.GetValue('BNP_TYPERESSOURCE'));
  if not (tModeSaisieBordereau in SaContexte) then TOBL.PutValue('GL_REFARTTIERS', TOBArt.GetValue('REFARTTIERS'));
  if not IsSousDetail(TOBL) then TOBL.PutValue('GL_TYPEREF', 'ART');
  if (ctxMode in V_PGI.PGIContexte) then
  begin
    if (TOBArt.GetValue('REFARTSAISIE') = TOBArt.GetValue('REFARTBARRE')) and not SaisieCodeBarreAvecFenetre then
    begin
      if not TOBL.FieldExists('REGROUPE_CB') then TOBL.AddChampSup('REGROUPE_CB', False);
      if not TOBL.FieldExists('UNI_OU_DIM') then TOBL.AddChampSup('UNI_OU_DIM', False);
      TOBL.PutValue('REGROUPE_CB', '-');
      if TOBArt.GetValue('GA_STATUTART') = 'DIM' then TOBL.PutValue('UNI_OU_DIM', 'DIM')
      else TOBL.PutValue('UNI_OU_DIM', 'UNI');
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
  QQ := OpenSQL('SELECT GQ_PHYSIQUE-QG_RESERVECLI FROM DISPO WHERE GQ_ARTICLE="' + TOBArt.GetValue('GA_ARTICLE') + '" AND GQ_DEPOT="' + Depot + '"', True,-1, '', True);
  if not QQ.EOF then QteDisp := QQ.Fields[0].AsFloat;
  Ferme(QQ);
  if QteDisp <= 0 then Exit;
  Result := False;
end;

function TFFacture.IdentifierArticle(var ACol, ARow: integer; var Cancel: boolean; Click, FromMacro: Boolean): boolean;
var RefSais, StatutArt, RefUnique, CodeArticle, CodeFournis, CodeDepot: string;
  RefCata, RefFour, CCells, TypeRef, CataArticleRef: string;
  TOBArt, TOBArtRef, TOBCata: TOB;
  // MODIF LS MULTI-SELECT
  TobMultiSel: TOB;
  // --
  TOBL: TOB; 
  QQ, QArt: TQuery;
  MultiDim, Okok: Boolean;
  RechArt, EtatRech: T_RechArt;
  fromBordereau : boolean;
begin
	fromBordereau := false;
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
  	if (TheBordereau <> nil) and (TheBordereau.BordereauExists ) then
    BEGIN
    	// surtout ne pas rechercher sur les reference tiers sur la tob article
      // elle peut etre presente plusieurs fois sous des reference tiers differentes
    	TOBART := nil;
    END ELSE
    BEGIN
			TOBArt := FindTOBArtSais(TOBArticles, RefSais);
    END;
    if TOBArt <> nil then
    begin
// MODIF LS
    	if (TheBordereau <> nil ) then
      begin
      	if TheBordereau.BordereauExists then
        begin
           TobMultiSel := TheBordereau.FindReferenceTiers (RefSais);
           if TOBMultiSel <> nil then
           begin
              MultiSelectionBordereau(TOBMultiSel);
              TobMultiSel.Free;
              Result := False;
              exit;
           end;
        end;
      end;
// --
      if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
      begin
        // article g�rable qu'en contremarque
        HPiece.Execute(47, caption, '');
        RechArt := traContreM;
      end else RechArt := traOk;
    end else
    begin
    	if TheBordereau <> nil then
      begin
      	if TheBordereau.BordereauExists then
        begin
           TobMultiSel := TheBordereau.FindReferenceTiers (RefSais);
           if TOBMultiSel <> nil then
           begin
              MultiSelectionBordereau(TOBMultiSel);
              TobMultiSel.Free;
              Result := False;
              exit;
           end;
        end;
      end;
      TOBArt := CreerTOBArt(TOBArticles);
      if FromMacro then
      begin
//
        QArt := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                       'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                       'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefSais+'"',true,-1, '', True);
//
        if Not QArt.EOF then
        begin
          ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QArt) ;
          RechArt:=traOk ;
        end else RechArt:=traErreur ;
        Ferme(QArt);
      end else
      begin
        RechArt := TrouverArticleSQL(CleDoc.NaturePiece, RefSais, GP_DOMAINE.Value, '', CleDoc.DatePiece, TOBArt, TOBTiers);
        if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
        begin
          // article g�rable qu'en contremarque
          HPiece.Execute(47, caption, '');
          RechArt := traContreM;
        end;
        if (RechArt=traOk) then
            ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',Nil) ;

        if (ctxMode in V_PGI.PGIContexte) then
        begin
          if (RechArt = traOk) or (RechArt = traOkGene) or (RechArt = traGrille) then
          begin
            // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
            // d�fini en ent�te du document d'achat, sont autoris�s en saisie.
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
    TOBCata := CreerTOBCata(TOBCatalogu);
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
          QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                         'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                         'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'" AND GA_TENUESTOCK<>"X"',true,-1, '', True);
          if not QQ.EOF then
          begin
            TOBArt := CreerTOBArt(TOBArticles);
            ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QQ) ;
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
          CataArticleRef := CatalogueChoixArticleRef;
          if CataArticleRef <> '' then
          begin
            TOBArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [CataArticleRef], False);
            if TOBartRef = nil then
            begin
              QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                             'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                             'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+CataArticleRef+'"',true,-1, '', True);
              if not QQ.EOF then
              begin
                TOBArtRef := CreerTOBArt(TOBArticles);
                TOBArtRef.SelectDB('', QQ);
                InitChampsSupArticle (TOBArtRef);
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
        if GereElipsis(SG_RefArt,frombordereau) then
        begin
          if GereContreM and (GS.CElls[SG_ContreM, ARow] = 'X') then
          begin
            cCells := GS.Cells[SG_RefArt, ARow];
            RefCata := uppercase(Trim(ReadTokenSt(cCells)));
            RefFour := uppercase(Trim(ReadTokenSt(cCells)));
            TOBCata := FindTOBCataSais(TOBCatalogu, RefCata, RefFour);
            if TOBCata = nil then
            begin
              QQ := OpenSQL('Select * from CATALOGU Where GCA_REFERENCE="' + RefCATA + '" AND GCA_TIERS="' + RefFour + '"', True,-1, '', True);
              if not QQ.EOF then
              begin
                TOBCata := CreerTOBCata(TOBCatalogu);
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
                CataArticleRef := CatalogueChoixArticleRef;
                if CataArticleRef <> '' then
                begin
                  TOBArtRef := TOBArticles.FindFirst(['GA_ARTICLE'], [CataArticleRef], False);
                  if TOBartRef = nil then
                  begin
                    QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                                   'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                                   'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+CataArticleRef+'"',true,-1, '', True);
                    if not QQ.EOF then
                    begin
                      TOBArtRef := CreerTOBArt(TOBArticles);
                      TOBArtRef.SelectDB('', QQ);
                      InitChampsSupArticle (TOBArtRef);
                    end;
                    Ferme(QQ);
                  end;
                end;
              end;
            end;
            GS.Cells[SG_RefArt, ARow] := CodeArticle;
          end else
          begin
//
            if (TheTob <> nil) and (TheTob.Detail.Count > 0) then
            begin
              if (TheTob.detail[0].nomtable = '') and (TheTOB.detail.count > 1) then
              begin
                TobMultiSel := TheTob;
                TheTob := nil;
              	MultiSelectionArticle(TobMultiSel);
                TobMultiSel.Free;
                Result := false;
                exit;
              end else if TheTOB.detail[0].NomTable = 'LIGNE' then
              begin
                TobMultiSel := TheTob;
                TheTob := nil;
              	MultiSelectionBordereau(TOBMultiSel);
                TobMultiSel.Free;
                Result := False;
                exit;
              end else RefUnique := GS.Cells[SG_RefArt, ARow];
            end else
            begin
//
            	RefUnique := GS.Cells[SG_RefArt, ARow];
//
						end;
//
            if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_CFGART') = 'X' then 
            begin
              { Appel du configurateur pour la s�lection d'un article }
              TobL := GetTobLigne(TobPiece, ARow);
              if Assigned(Tobl) then
                RefUnique := TobL.GetValue('GL_ARTICLE');
            end;
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
              QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                             'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                             'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
              if not QQ.EOF then
              begin
                TOBArt := CreerTOBArt(TOBArticles);
                ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QQ) ;
                CodeArticle := QQ.FindField('GA_CODEARTICLE').AsString;
                if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_CFGART') = 'X' then 
                begin
                  { Appel du configurateur pour la s�lection d'un article }
                  TobL := GetTobLigne(TobPiece, ARow);
                  if Assigned(Tobl) then
                  begin
                    TobArt.PutValue('REFARTBARRE', TobL.GetValue('GL_REFARTBARRE'));
                    TobArt.PutValue('REFARTTIERS', TobL.GetValue('GL_REFARTTIERS'));
                    TobArt.PutValue('REFARTSAISIE', TobL.GetValue('GL_REFARTSAISIE'));
                  end;
                end;
                StatutArt := QQ.FindField('GA_STATUTART').AsString;
                CodeFournis := QQ.FindField('GA_FOURNPRINC').AsString;
                if not GereContreM or (GS.Cells[SG_ContreM, ARow] <> 'X') then
                begin
                  if TOBArt.GetValue('GA_CONTREMARQUE') = 'X' then
                  begin
                    // article g�rable qu'en contremarque
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
            if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_CFGART') <> 'X' then
              GS.Cells[SG_RefArt, ARow] := CodeArticle;
            if (ctxMode in V_PGI.PGIContexte) then
            begin
              // Dans le cas d'une gestion Mono-fournisseur, seuls les articles du fournisseur
              // d�fini en ent�te du document d'achat, sont autoris�s en saisie.
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
    ChargerTobArt(TOBArt,TobAFormule,VenteAchat,RefUnique,Nil) ;
  end;
  if (TOBArt <> nil) then
  begin
    //  BBI, fiche correction 10410
    CalculePrixArticle(TOBArt, TobPiece.GetValue('GP_DEPOT'));
    //  BBI, fin fiche correction 10410
    CodesArtToCodesLigne(TOBArt, ARow);
    //
    TobL := GetTobLigne(TobPiece, ARow);
    if TOBPiece.getValue('GP_DOMAINE')<>'' then
    begin
    	TOBL.putvalue('GL_DOMAINE',TOBPiece.getValue('GP_DOMAINE'));
    end;
    if TOBART.getValue('GA_PRIXPASMODIF')<>'X' Then
    begin
      AppliqueCoefDomaineLig (TOBL);
    end;
    TOBL.putValue('GL_RECALCULER','X');
    //
  end;
  if TOBCata <> nil then
  begin
    CodesCataToCodesLigne(TOBCata, TOBArt, CataArticleRef, ARow, TobPiece);
  end;
  Result := True;
end;

procedure TFFacture.ChargeTOBDispo(ARow: integer);
var TOBA: TOB;
begin
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  if TOBA = nil then Exit;
  LoadTOBDispo(TOBA, False, CreerQuelDepot(TOBPiece));
  if (CtxMode in V_PGI.PgiContexte) and (TOBA.GetValue('GA_ARTICLE') <> 'UNI') then exit
  else LoadTOBCond(TOBA.GetValue('GA_ARTICLE'));
  //  BBI, fiche correction 10410
  CalculePrixArticle(TOBA, TobPiece.GetValue('GP_DEPOT'));
  //  BBI, fin fiche correction 10410
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
  // gestion des unites via le coef dans les catalogues (new version)
  if TOBA.FieldExists('GCA_COEFCONVQTEACH') then TOBL.PutValue('GL_COEFCONVQTE', TOBA.GetValue('GCA_COEFCONVQTEACH'));
end;

procedure TFFacture.UpdateArtLigne(ARow: integer; FromMacro, Calc, CalcTarif: boolean; NewQte: double);
var StatutArt: string;
  TOBA, TOBL: Tob;
  {$IFDEF BTP}
  result: double;
  QteDuDetail,SavPrix : double;
  EnPa,EnHt,PrixFixe : boolean;
  RecupPrix : String;
  Arttiers,Libelle,Unite : string;
  {$ENDIF}
begin
	SavPrix := 0;
  PrixFixe := false;
	{$IFDEF BTP}
//  EnPa := (VenteAchat = 'ACH');
  RecupPrix := GetInfoParPiece(TOBPIece.GetValue('GP_NATUREPIECEG'), 'GPP_APPELPRIX');
  enPa := ((RecupPrix='PAS') or (RecupPrix = 'DPA'));
  EnHt := (TOBPiece.getValue('GP_FACTUREHT')='X');
  {$ENDIF}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  {$IFDEF BTP}
  if (tModeSaisieBordereau in SaContexte) then
  begin
  	ArtTiers := TOBL.GetValue('GL_REFARTTIERS');
    Libelle := TOBL.GetValue('GL_LIBELLE');
    Unite := TOBL.GetValue('GL_QUALIFQTEVTE');
    if EnPA then
    begin
    	SavPrix := TOBL.GetValue('GL_DPA');
    end else
    begin
    	SavPrix := TOBL.getValue('GL_PUHTDEV');
    end;
  end;
  if (TOBL.GetValue('GL_BLOQUETARIF')='X') then
  begin
  	SavPrix := TOBL.getValue('GL_PUHTDEV');
    PrixFixe := (TOBL.GetValue('GL_BLOQUETARIF')='X');
  end;
  {$ENDIF}
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
  if not (CtxMode in V_PGI.PGIContexte) then TraiteLeCata(ARow); //Modif AC
  InitLaLigne(ARow, NewQte, CalcTarif);
{$IFDEF BTP}
	if TOBL.GetValue('FROMTARIF')='X' then
  begin
       if EnPA then
       begin
            SavPrix := TOBL.GetValue('GL_DPA');
       end else
       begin
            SavPrix := TOBL.getValue('GL_PUHTDEV');
       end;
// --- modif brl 10/03/05
(*
  	if VenteAchat <> 'ACH' then
    begin
    	SavPrix := TOBL.GetValue('GL_PUHTDEV');
    end else if VenteAchat = 'ACH' then
    begin
    	SavPrix := TOBL.getValue('GL_DPA');
    end;
*)
// ---
  end;
  if VenteAchat = 'VEN' then
  begin
    if IsprestationST (TOBL) then
    begin
      if TOBPIece.getValue('GP_APPLICFGST')='-' then TOBL.putValue('GLC_NONAPPLICFRAIS','X') else TOBL.putValue('GLC_NONAPPLICFRAIS','-');
      if TOBPIece.getValue('GP_APPLICFCST')='-' then TOBL.putValue('GLC_NONAPPLICFC','X') else TOBL.putValue('GLC_NONAPPLICFC','-');
    end;
  end;
  //
  if PrixFixe  then
  begin
  	TOBL.PutValue('GL_PUHTDEV',SavPrix);
    TOBL.PutValue('GL_BLOQUETARIF','-');
    TOBL.PutValue ('FROMTARIF','X');
  end;
{$ENDIF}
  if not FromMacro then
  begin
    TraiteLesDim(ARow, True);
    TraiteFormuleQte(ARow);
    {$IFDEF AFFAIRE}
    TraiteFormuleVar(ARow, 'CREATION'); //Affaire-Formule des variables
    {$ENDIF}
    TraiteLesCons(ARow);
    TraiteLesNomens(ARow);
    {$IFDEF BTP}

    // Gestion des m�tr�s => FV
    //
    if GetParamSocSecur('SO_METRESEXCEL',true) then
    begin
      if (not OrigineEXCEL) and ((Cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
         (cledoc.NaturePiece = 'FBT') or
         (Cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION'))) then
      begin
        if (VenteAchat = 'VEN') then
        begin
          if TheMetre.ControlMetre then
          begin
            TheMetre.DocMetreBiblio (TOBL);
          end;
        end;
      end;
    end;
    //
    // Modif BTP
    if TraiteLesOuv(Arow) then
       begin
         AfficheLaLigne(Arow);
       end
    else
    begin
      VideCodesLigne(TOBPiece, ARow);
      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
      TOBL.putValue('GL_RECALCULER','-');
      TOBL.putValue('GP_RECALCULER','-');
    end;

    if (tModeSaisieBordereau in SaContexte) then
    begin
    	if Arttiers <> '' then TOBL.PutValue('GL_REFARTTIERS',ArtTiers);
      if Libelle <> '' then TOBL.PutValue('GL_LIBELLE',Libelle);
      if Unite <> '' then TOBL.PutValue('GL_QUALIFQTEVTE',Unite);
    end;

    // ------
    {$ENDIF}
    {$IFDEF CHR}
    TraiteLesMacrosChr(ARow);
    {$ELSE}
    TraiteLesMacros(ARow);
    {$ENDIF}  // FIN CHR
    if ((not (ctxMode in V_PGI.PGIContexte)) or ((ctxMode in V_PGI.PGIContexte) and (StatutArt = 'UNI'))) then TraiteLesLies(ARow);
  end;
{$IFDEF BTP}
	if (TheDestinationLiv <> nil) then TheDestinationLiv.SetDestLivrDefaut (TOBL);
	AppliquePrixFromTarif (self,TOBPiece,TOBL,TOBBases,TOBBasesL,TOBouvrage,EnPa,EnHT,Savprix,DEV,Arow);
  if PrixFixe  then
  begin
    TOBL.PutValue('GL_BLOQUETARIF','X');
  end;
{$ENDIF}
  TraiteLaCompta(ARow);
  //TraiteLeCata(ARow) ;  //Pour init libelle article catalogu
  TraiteMotif(ARow);
  {$IFDEF BTP}
  // Modification m�tr�s => fv
  result := 0;
  if GetParamSocSecur('SO_METRESEXCEL',true) then
  begin
    if (not OrigineEXCEL) and (VenteAchat = 'VEN') then
    begin
      if TheMetre.AutorisationMetre(Cledoc.NaturePiece) then
      begin
        result := TheMetre.CalculeMetre(TOBL, self);
      end;
    end;
    if result <> 0 then
    begin
      TOBL.putValue('GL_QTEFACT', result);

      // Modif FV
      TOBL.putvalue('GL_QTESTOCK', result);
      TOBL.putvalue('GL_QTERESTE', result);
      if GetQteDetailOuv (TOBL,TOBOuvrage) = 0 then
      Begin
        QteDuDetail := TobL.GetValue('GL_QTEFACT');
        // fv 02032004
        //if QteDuDetail = 0 then QteDuDetail := 1;
        PosQteDetailAndCalcule (TOBL,TOBOUvrage,QteDuDetail,DEV);
  //      CalculeLaSaisie(-1,-1, false);
      End;
      AfficheLaLigne(GS.row);
      if GS.cells[GS.col, GS.row] <> StCellCur then ATraiterQte := False;
      if (EnPa)  then
          TraitePrixAch(ARow)
      else
          TraitePrix(ARow,Savprix);
    end;
  end;
  // Modif LS Pour OPTIMISATION
  if GereDocEnAchat then
  begin
    if TOBL.GetValue('GL_DPR')=0 then TOBL.PutValue('GL_DPR',TOBL.GetValue('GL_DPA'));
    if TOBL.GetValue('GL_DPR')<>0 then TOBL.putValue('GL_COEFMARG',Arrondi(TOBL.GetValue('GL_PUHT')/TOBL.GetValue('GL_DPR'),4));
  end;
  //
  if pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV')> 0 then
  begin
  	TOBL.putValue('GL_QUALIFHEURE',GetQualifTps(TOBL,TOBOUvrage));
  end;
  if pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV;OUV')> 0 then
  begin
  	CalculheureTot (TOBL);
  end;
  //
(*
  if (TOBL.GetValue('GL_TYPEPRESENT') <> DOU_AUCUN) then
  begin
  	GestionDetailOuvrage(self,TobPiece,Arow);
  end;
*)
  AffecteTenueStock (TOBL,TOBPiece,TOBArticles);
  {$ENDIF}
  if EnHt then
  begin
  	if (TOBL.getValue('GL_PUHTDEV')=0) and (TOBL.getValue('GL_COEFMARG')=0) then
    begin
    	RecupCoefMargArticle (TOBL,TOBarticles);
    end;
  end else
  begin
  	if (TOBL.getValue('GL_PUTTCDEV')=0) and (TOBL.getValue('GL_COEFMARG')=0) then
    begin
    	RecupCoefMargArticle (TOBL,TOBarticles);
    end;
  end;
  TOBPiece.Putvalue('GP_RECALCULER','X');
  TOBL.Putvalue('GL_RECALCULER','X');
(*
  if (((not FromMacro) or (Calc)) and (not (ctxMode in V_PGI.PGIContexte)) or ((ctxMode in V_PGI.PGIContexte) and (StatutArt = 'UNI'))) then
  begin
    TOBPiece.PutValue('GP_RECALCULER', 'X');
//    CalculeLaSaisie(SG_RefArt, ARow, True);
  end;
*)
  ShowDetail(ARow);
  GP_DEVISE.Enabled := False;
  BDEVISE.Enabled := False;
  GP_DOMAINE.Enabled := False;
end;

procedure TFFacture.UpdateCataLigne(ARow: integer; FromMacro, Calc: boolean; NewQte: double);
begin
  InitLaLigne(ARow, NewQte);
  ChargeTOBDispoContreM(ARow, TobPiece, TobCatalogu);
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
  TraiteLaContreM(aRow, TobPiece, TobCatalogu);
  if ((not FromMacro) or (Calc)) then
  begin
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_RefArt, ARow, False);
  end;
  ShowDetail(ARow);
  GP_DEVISE.Enabled := False;
  BDEVISE.Enabled := False;
  GP_DOMAINE.Enabled := False;
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
    TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBL, TOBA, TOBTiers, TOBCata, TobAffaire, True,TOBTablette);
    if TOBC <> nil then
    begin
      if ((TOBL.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
      if ((TOBL.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
    end;
  end;
  PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBL);
end;

// Modif BTP

function TFFacture.TraiteLesOuv(ARow: integer; WithDetails : boolean=true; TOBLigneBord : TOB=nil): boolean;
begin
  	(* OPTIMIZATION *)
//  result := TraiteLesOuvrages(TOBPiece, TOBArticles, TOBOuvrage, ARow, False, DEV, OrigineExcel);
		(* -------------- *)
	if TOBLigneBord = nil then
  begin
  	result := TraiteLesOuvrages(self, TOBPiece, TOBArticles, TOBOuvrage, TheRepartTva.Tobrepart,ARow, False, DEV, OrigineExcel,OptimizeOuv,WithDetails,false);
  end else
  begin
  	if TOBLigneBord.GetValue('GLC_GETCEDETAIL')= 'X' then
    begin
  		result := TraiteOuvrageFromBordereau(self,TOBPiece, TOBArticles, TOBOuvrage, TheRepartTva.Tobrepart,ARow, False, DEV, TOBLigneBord)
    end else
    begin
  		result := TraiteLesOuvrages(self, TOBPiece, TOBArticles, TOBOuvrage, TheRepartTva.Tobrepart,ARow, False, DEV, OrigineExcel,OptimizeOuv,WithDetails,True,GereDocEnAchat);
    end;
  end;
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
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    TOBL.PutValue('GL_RECALCULER', 'X');
    CalculeLaSaisie(SG_QF, ARow, False);
  end;
end;

procedure TFFacture.DetruitLigneTarif(ARow: integer);
begin
  if Action = taConsult then Exit;
//  SupprimeLigneTarif(TobPiece, TobLigneTarif, ARow);
end;

procedure TFFacture.GereLesSeries(ARow: integer);
var TOBA, TOBL, TOBN, TOBPlat: TOB;
  RefUnique: string;
  IndiceSerie, IndiceNomen, i_ind: integer;
  Qte, NewQte, QteN, NbCompoSerie, QteRel: Double;
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
  if (TOBL.GetValue('QTECHANGE') <> 'X') and (QuelQteEnSerie(TobSerie, TOBL, NbCompoSerie) =  Qte) then
  begin
    if TOBPlat <> nil then TOBPlat.Free;
    Exit;
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
      NewQte := QuelQteEnSerie(TobSerie, TOBL, NbCompoSerie);
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
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(SG_QF, ARow, False);
    TOBL.PutValue('QTECHANGE', '-');
  end;
  {$ENDIF}
end;

procedure TFFacture.InsertArticleLies(Arow : integer;TOBref : TOB; LesRefsLies : string; NbrInsert : integer);
var RefUnique, LibRef, Msg, Qteref : string;
    iInd, QteInit,CurRow,CurCol : integer;
    Cancel,InfoLotSerie: Boolean;
    TOBArt, TOBL : TOB;
    QQ : TQuery;
    Ipourcent : integer;
begin
  DepileTOBLignes(GS, TOBPiece, ARow, ARow);
	CurCol := SG_RefArt;
	CurRow := Arow;
  Cancel := False;
  Inc(Arow);
  GS.Cells[SG_RefArt, ARow] := '';
  MultiSel_SilentMode := True;
  InfoLotSerie := False;
  SelInfoRupture := False;
  InitMoveProgressForm(nil,Caption,TraduireMemoire('Insertion de l''article li� : '),NbrInsert,True,True);
  repeat
    RefUnique := ReadTokenSt(LesRefsLies);
    QteRef := ReadTokenSt(LesRefsLies);
    if RefUnique <> '' then
    begin
      TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
      if TOBArt = nil then
      begin
        QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                       'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                       'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
        if not QQ.EOF then
        begin
          TOBArt := CreerTOBArt(TOBArticles);
          ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QQ) ;
        end;
        Ferme(QQ);
      end;
      if TobArt = nil then continue;

      LibRef := TOBArt.GetValue('GA_LIBELLE');
      if not MoveCurProgressForm(TOBArt.GetValue('GA_CODEARTICLE') + ' ' + LibRef) then break;

      if QteRef = '-' then QteInit := 1 else QteInit := TOBRef.getValue('GL_QTEFACT');

      if not InsertNewArtInGS(RefUnique, LibRef, QteInit,Arow) then continue;

      GSRowExit(nil, ARow, Cancel, False);

      if Cancel then break;
      TOBL := GetTOBLigne(TOBPiece, ARow);  // Avant il y avait GS.row
//      if TOBL.FieldExists('GL_LIGNELIEE') then
//        TOBL.putValue('GL_LIGNELIEE', TobRef.GetValue('GL_NUMORDRE')); //Affaire-ligne li�es

    	Ipourcent := PositionneRecalculePourcent (Arow);
      inc(Arow);
    end;
  until ((RefUnique = '') or (LesRefsLies = ''));
  FiniMoveProgressForm;
  if SelInfoRupture then Msg := 'Certains articles n''ont pu �tre int�gr�s suite � une rupture de stock';
  if InfoLotSerie then
  begin
    if Msg <> '' then Msg := Msg + '#13';
    Msg := Msg + 'Certaines lignes n''ont pas de quantit�. Une gestion particuli�re vous oblige � la saisir manuellement.';
  end;
  if Msg <> '' then PGIInfo(Msg,Caption);
  CalculeLaSaisie(-1, -1, False);
  if IPourcent <> -1 then AfficheLaLigne (IPourcent+1);
  GoToLigne(CurCol,CurRow);
  StCellCur := GS.Cells[GS.col, GS.row];
  MultiSel_SilentMode := False;
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
  if (VenteAchat <> 'VEN') and not bSaisieNatAffaire then Exit; //Affaire
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
  {Comptage pour creer les lignes et les tob � l'avance}
  repeat
    RefUnique := ReadTokenSt(StLoc);
    ReadTokenSt(StLoc); //pour QteRef
    if RefUnique <> '' then Inc(NbLies);
  until ((RefUnique = '') or (StLoc = ''));
  {Insertion et cr�ation des lignes li�es}
  (*
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
      if TOBL.FieldExists('GL_LIGNELIEE') then
        TOBPiece.Detail[LaLig - 1].putValue('GL_LIGNELIEE', TobL.GetValue('GL_NUMORDRE')); //Affaire-ligne li�es
      Inc(NbLies);
    end;
  until ((RefUnique = '') or (LesRefsLies = ''));
  *)
	InsertArticleLies (Arow,TOBL,LesRefsLies,NbLies);
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
    TOBPiece.PutValue('GP_RECALCULER', 'X');
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

{$IFDEF AFFAIRE} //Affaire-Formule des variables
function TFFacture.TraiteFormuleVar(ARow: integer; pStAction: string): Boolean;
var TOBA, TOBL,TobLQte: TOB;
  ACol: integer;
  Cancel: Boolean;
  Qte: double;
  FormuleVar, CodeAffaire: string;
begin
  Result := True;
  if not GetParamSoc('SO_AFVARIABLES') then exit;
  TOBA := FindTOBArtRow(TOBPiece, TOBArticles, ARow);
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if (TOBA = nil) or (TOBL = nil) then Exit;
  CodeAffaire := TOBL.GetValue('GL_AFFAIRE');
  FormuleVar := TOBL.GetValue('GL_FORMULEVAR');

  if pStAction = 'CREATION' then
  begin
    FormuleVar := TOBA.GetValue('GA_FORMULEVAR');
    if (FormuleVar <> '') and (TOBL.GetValue('GL_FORMULEVAR') = '') then
      TOBL.PutValue('GL_FORMULEVAR', FormuleVar);

    if not GetParamSoc('SO_AFGENERAUTOLIG') then //type g�n�ration � la ligne
      TOBL.PutValue('GL_GENERAUTO', 'MAN')
    else if (TOBAFFAIRE.GetValue('AFF_GENERAUTO') <> 'POT') then
      TOBL.PutValue('GL_GENERAUTO', 'MAN')
    else if (TOBL.GetValue('GL_GENERAUTO') = '') then
      TOBL.PutValue('GL_GENERAUTO', 'POT');

    if TOBL.GetValue('GL_FACTURABLE') = '' then
    begin
      if TOBA.GetValue('GA_ACTIVITEREPRISE') <> '' then
        TOBL.PutValue('GL_FACTURABLE', TOBA.GetValue('GA_ACTIVITEREPRISE'))
      else
        TOBL.PutValue('GL_FACTURABLE', 'F');
    end;
    if bSaisieNatAffaire and (ARow > 1) then //REVISIONPRIX
    begin
      if (TOBL.GetValue('GL_FORCODE1') = '') then
        TOBL.PutValue('GL_FORCODE1', TOBPiece.Detail[ARow - 2].GetValue('GL_FORCODE1'));
      if (TOBL.GetValue('GL_FORCODE2') = '') then
        TOBL.PutValue('GL_FORCODE2', TOBPiece.Detail[ARow - 2].GetValue('GL_FORCODE2'));
    end;
    if bSaisieNatAffaire and GetParamSoc('SO_AFCOMPLLIGNE') then
      CpltLigneClick(nil);
    if (TOBL.GetValue('GL_FORMULEVAR') <> '') then
      FormuleVar := TOBL.GetValue('GL_FORMULEVAR');
  end
  else if pStAction = 'AUTORISE' then
  begin
    if (FormuleVar <> '') and TobFormuleVarQte.FieldExists ('AUTORISEQTE') then
    result := (TobFormuleVarQte.GetValue('AUTORISEQTE')='X');
    if result then
    begin
      TobLQte := TobFormuleVarQte.FindFirst(['AVV_NUMORDRE'], [TobL.GetValue('GL_NUMORDRE')], False);
      if (TobLQte <> nil) and (TobLQte.GetValue('AVV_QTECALCUL')<>0) then
        TOBL.PutValue('GL_QTEFACT', TobLQte.GetValue('AVV_QTECALCUL'));
    end;
    exit;
  end
  else if (pStAction = 'SUPPRIME') and bSaisieNatAffaire then
  begin
    if existeSql('SELECT ACT_TYPEACTIVITE FROM ACTIVITE WHERE ACT_TYPEACTIVITE="REA" AND ACT_AFFAIRE="' + CodeAffaire + '" AND ACT_NUMORDRE=' +
      IntToStr(TobL.GetValue('GL_NUMORDRE'))) then
    begin
      HPiece.Execute(55, Caption, '');
      Result := False;
      Exit;
    end;
  end;

  if (FormuleVar = '') or (CodeAffaire = '') then Exit;
  if (Action <> taConsult) and (TOBL.GetValue('GL_NUMORDRE') = 0) then
    numerotelignesGc(nil, TOBPiece);
  Qte := EvaluationAFFormuleVar('LIG', FormuleVar, pStAction, TOBFormuleVar, TOBFormuleVarQte, TOBL);
  if (Qte >= 0) and (SG_QF > 0) then
  begin
    GS.Cells[SG_QF, ARow] := StrF00(Qte, V_PGI.OkDecQ);
    TobFormuleVarQte.PutValue('AUTORISEQTE','X');
    if (pStAction = 'MODIF') or (pStAction = 'CREATION') then
    begin
      ACol := SG_QF;
      Cancel := False;
      GS.Col := ACol + 1;
      GSCellExit(nil, ACol, ARow, Cancel);
    end;
    TobFormuleVarQte.PutValue('AUTORISEQTE','-');
  end;
  if (pStAction = 'CONSULT') and (Qte = -1) then Result := False;
end;
{$ENDIF}

{$IFDEF CHR}
procedure TFFacture.TraiteLesMacrosChr(Arow:integer);
var RefUnique, CodeArticle, TypeArt, TypeNomenc, LeCom, Rgpnom, CodeNom, LibRgpNom: string;
  TOBL, TOBDET: TOB;
  i, ACol, LaLig, DecL, lignom, FolNom: integer;
  Cancel: boolean;
  Qte, QteNom, PrixNom: Double;
  Q: TQuery;
begin
  RefUnique := GetCodeArtUnique(TOBPiece, ARow);
  if RefUnique = '' then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  CodeNom := TOBL.GetValue('GL_CODEARTICLE');
  QteNom := TOBL.GetValue('GL_QTEFACT');
  LigNom := TOBL.GetValue('GL_NUMLIGNE');
  RgpNom := TOBL.GetValue('GL_REGROUPELIGNE');
  FolNom := TOBL.GetValue('GL_NOFOLIO');
  PrixNom := TOBL.GetValue('GL_PUTTC');
  LibrgpNom := RechDom('HRTREGROUPELIGNE', RgpNom, False);
  TypeArt := TOBL.GetValue('GL_TYPEARTICLE');
  if TypeArt <> 'NOM' then Exit;
  TypeNomenc := TOBL.GetValue('GL_TYPENOMENC');
  if TypeNomenc <> 'MAC' then Exit;
  //Depot:=TOBL.GetValue('GL_DEPOT') ; if Depot='' then Exit ;
  TobDet := TOB.Create('DETAIL', nil, -1);
  Q := OpenSQL('SELECT GA_QTEDEFAUT,GNL_ARTICLE,GNL_CODEARTICLE FROM ARTICLE LEFT JOIN NOMENLIG ON GNL_ARTICLE=GA_ARTICLE WHERE GNL_NOMENCLATURE="' + RefUnique
    + '"', True,-1, '', True);
  if (not Q.eof) then
  begin
    TobDet.LoadDetailDB('DETAIL', '', '', Q, False, True);
  end;
  ferme(Q);
  DecL := 0;
  GS.RowCount := GS.RowCount + TOBDet.Detail.Count;
  CreerTOBLignes(GS, TOBPiece, TOBTiers, TOBAffaire, TOBPiece.Detail.Count + TOBDet.Detail.Count);
  for i := 0 to TobDet.Detail.Count - 1 do
  begin
    RefUnique := TOBDet.detail[i].GetValue('GNL_ARTICLE');
    CodeArticle := TOBDet.detail[i].GetValue('GNL_CODEARTICLE');
    if (TobDet.detail[i].GetValue('GA_QTEDEFAUT')) <> 'NPE' then
      Qte := 1 else
      Qte := TobHrDossier.GetValue('HDR_NBPERSONNE1');
    LaLig := ARow + 1 + i - DecL;
    TOBL := GetTOBLigne(TOBPiece, LaLig);
    GS.Cells[SG_RefArt, LaLig] := RefUnique;
    ACol := SG_RefArt;
    Cancel := False;
    TraiteArticle(ACol, LaLig, Cancel, True, True, Qte);
    if Cancel then
    begin
      Inc(DecL);
      Continue;
    end;
    GS.Cells[SG_DateProd, LaLig] := GP_DATEPIECE.Text;
    HRTraiteDateProd(Self, TobPiece, SG_DateProd, LaLig, Cancel);
    if (copy((TOBL.GetValue('GL_REFCOLIS')), 1, 4) <> '') then
      TOBL.PutValue('GL_REFCOLIS', copy((TOBL.GetValue('GL_REFCOLIS')), 1, 4) + IntToStr(Lignom)) else
      TOBL.PutValue('GL_REFCOLIS', 'DET;' + Format('%.2d', [lignom]));
    TOBL.PutValue('GL_REGROUPELIGNE', RgpNom);
    GS.Cells[Sg_Regrpe, LaLig] := RgpNom;
    if (RgpNom) <> '' then
    begin
      GS.Cells[Sg_Regrpe + 1, LaLig] := LibRgpNom;
      if not TOBL.FieldExists('(REGROUPEMENT)') then
        TOBL.AddChampSup('(REGROUPEMENT)', False);
      TOBL.PutValue('(REGROUPEMENT)', LibRgpNom);
    end;
    GS.Cells[SG_RefArt, LaLig] := CodeArticle;
  end;
  TOBDet.Free;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  LeCom := TOBL.GetValue('GL_LIBELLE');
  HRTraitePrixDetailChr(Self, TobPiece, Arow);
//  FFact.ClickDel(ARow, True, False);
//  FFact.ClickInsert(ARow);
  TOBL := GetTOBLigne(TOBPiece, ARow);
  GS.Cells[SG_px, Arow] := StrfMontant(Prixnom, 7, V_PGI.OkDecP, '', TRUE);
  GS.Cells[SG_Montant, Arow] := StrfMontant(Prixnom * Qtenom, 7, V_PGI.OkDecP, '', TRUE);
  TOBL.PutValue('GL_LIBELLE', LeCom);
  TOBL.PutValue('GL_CODEARTICLE', CodeNom);
  TOBL.PutValue('GL_TYPENOMENC', 'MAC');
  TOBL.PutValue('GL_QTEFACT', QteNom);
  TOBL.PutValue('GL_REGROUPELIGNE', RgpNom);
  TOBL.PutValue('GL_NOFOLIO', FolNom);
  TOBL.PutValue('GL_REFARTSAISIE','');
  TOBL.PutValue('GL_ARTICLE','');
  TOBL.PutValue('GL_TYPEREF','');
  TOBL.PutValue('GL_FAMILLETAXE1','');
  TOBL.PutValue('GL_CODEARTICLE',CodeNom);
  TOBL.PutValue('GL_TYPENOMENC','MAC');
  TOBL.PutValue('GL_ESCOMPTABLE','-');
  TOBL.PutValue('GL_PCB',0);
  TOBL.PutValue('GL_TYPEARTICLE','');
  TOBL.PutValue('GL_REMISABLELIGNE','-');
  TOBL.PutValue('GL_REMISABLEPIED','-');
  TOBL.PutValue('GL_DATELIVRAISON',iDate1900);
  // MODIF VARIANTE
  SetLigneCommentaire (TobPiece,TOBL,Arow);
  (* TOBL.PutValue('GL_TYPELIGNE','COM'); *)
  TOBL.PutValue('GL_PUTTC', PrixNom);
  TOBL.PutValue('GL_PUTTCDEV', PrixNom);
  TOBL.PutValue('GL_PUTTCNET', PrixNom);
  TOBL.PutValue('GL_PUTTCNETDEV', PrixNom);
  TOBL.PutValue('GL_TOTALTTC', PrixNom * QTeNom);
  TOBL.PutValue('GL_MONTANTTTC', PrixNom * QTeNom);
  TOBL.PutValue('GL_MONTANTTTCDEV', PrixNom * QTeNom);
  TOBL.PutValue('GL_TOTALTTCDEV', PrixNom * QTeNom);
  TOBPIece.putvalue('GP_RECALCULER', 'X');
end;

{$ENDIF}

Procedure TFFacture.TraiteFormuleQte (ARow : integer) ;
Var FoncQte : R_FonctCal ;
    Qte : double ;
    Formule,Flux : string;
    TOBA,TOBADet,TOBL : TOB ;
    ind : integer;
begin
TOBA:=FindTOBArtRow(TOBPiece,TOBArticles,ARow) ;
if TOBA=Nil then exit;
TOBADet:=TOBAFormule.FindFirst(['GAF_ARTICLE'],[TOBA.GEtValue('GA_ARTICLE')],True) ;
if TOBADet=nil then exit;
if VenteAchat='VEN' then Flux:='VTE'
else if VenteAchat='ACH' then Flux:='ACH'
else exit;
Formule:=TOBADet.GetValue('GAF_FORMULEQTE'+Flux);
If Formule='' then exit;
if TOBADet.Detail.Count=0 then
  begin
  FoncQte:=EvaluationFormule (Formule,Formule);
  end else
  begin
  FoncQte.Formule:=Formule;
  FoncQte.Affichage:=Formule;
  for ind:=0 to TOBADet.Detail.Count-1 do
    begin
    FoncQte.VarLibelle[ind]:=TOBADet.Detail[ind].GetValue('GAV_LIBELLEVAR');
    FoncQte.VarValeur[ind]:=TOBADet.Detail[ind].GetValue('GAV_VALEURVAR');
    FoncQte.Modifiable[ind]:=(TOBADet.Detail[ind].GetValue('GAV_ENABLEVAR')='X');
    FoncQte.Affichable[ind]:=(TOBADet.Detail[ind].GetValue('GAV_VISIBLEVAR')='X');
    end;
  FoncQte:=EvaluationFormule (ActionToString(Action),FoncQte);
  end;
if FoncQte.Annule then exit;
Qte:=FoncQte.Resultat ;
if SG_QS>0 then BEGIN GS.Cells[SG_QS,ARow]:=StrF00(Qte,V_PGI.OkDecQ) ; TraiteQte(SG_QS,ARow) ; END ;
if SG_QF>0 then BEGIN GS.Cells[SG_QF,ARow]:=StrF00(Qte,V_PGI.OkDecQ) ; TraiteQte(SG_QF,ARow) ; END ;
TOBL:=GetTOBLigne(TOBPiece,ARow) ; if TOBL=Nil then Exit ;
InsertFormuleToTOB(TOBL,TOBLigFormule,FoncQte);
end;

Procedure TFFacture.RappelFormuleQte (ARow : integer) ;
Var FoncQte : R_FonctCal ;
    Qte : double ;
    Formule,Flux : string;
    TOBDet,TOBL : TOB ;
    ind,IndiceFormule : integer;
begin
TOBL:=GetTOBLigne(TOBPiece,ARow) ; if TOBL=Nil then Exit ;
if TOBL.FieldExists('GL_INDICEFORMULE') then
  IndiceFormule:=TOBL.GetValue('GL_INDICEFORMULE')
  else IndiceFormule:=0;;
if IndiceFormule=0 then exit;
if TOBLigFormule.Detail.Count<IndiceFormule then exit;
TOBDet:=TOBLigFormule.Detail[IndiceFormule-1];
if VenteAchat='VEN' then Flux:='VTE'
else if VenteAchat='ACH' then Flux:='ACH'
else exit;
Formule:=TOBDet.GetValue('GLF_FORMULE');
If Formule='' then exit;
if TOBDet.Detail.Count=0 then
  begin
  FoncQte:=EvaluationFormule (Formule,Formule);
  end else
  begin
  FoncQte.Formule:=Formule;
  FoncQte.Affichage:=Formule;
  for ind:=0 to TOBDet.Detail.Count-1 do
    begin
    FoncQte.VarLibelle[ind]:=TOBDet.Detail[ind].GetValue('GLF_LIBELLEVAR');
    FoncQte.VarValeur[ind]:=TOBDet.Detail[ind].GetValue('GLF_VALEURVAR');
    FoncQte.Modifiable[ind]:=(TOBDet.Detail[ind].GetValue('GLF_ENABLEVAR')='X');
    FoncQte.Affichable[ind]:=(TOBDet.Detail[ind].GetValue('GLF_VISIBLEVAR')='X');
    end;
  FoncQte:=EvaluationFormule (ActionToString(Action),FoncQte);
  end;
if FoncQte.Annule then exit;
Qte:=FoncQte.Resultat ;
if SG_QS>0 then BEGIN GS.Cells[SG_QS,ARow]:=StrF00(Qte,V_PGI.OkDecQ) ; TraiteQte(SG_QS,ARow) ; END ;
if SG_QF>0 then BEGIN GS.Cells[SG_QF,ARow]:=StrF00(Qte,V_PGI.OkDecQ) ; TraiteQte(SG_QF,ARow) ; END ;
UpdateFormuleToTOB(TOBL,TOBLigFormule,FoncQte);
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

procedure TFFacture.TraiteArticle(var ACol, ARow: integer; var Cancel: boolean; FromMacro, CalcTarif: boolean; NewQte: double);
var OkArt: Boolean;
  NewCol, NewRow : integer;
  TypeL, TypeD: string;
  TobL: Tob; { NEWPIECE }
  SupDim : Boolean ;
  {$IFDEF CHR}
  DateProd: TDateTime;
  {$ENDIF}
begin
  if VH_GC.GCIfdefCegid then // DBR pour pas supprimer ligne de la NGI 13112003
  begin
    if (Action = taModif) and (GetChampLigne (TobPiece, 'GL_REFCOLIS', ARow) <> '') then
    begin
      GS.Cells[ACol, ARow] := GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', ARow);
      Cancel := True;
      exit;
    end;
  end;
  //
  if (IsDejaFacture) and ((FraisChantier) or (ExisteCurrentFraisChantier(TOBPorcs))) then
  begin
    PgiInfo('Impossible : Le devis est factur� et des frais repartis ou de chantier existent');
    cancel := true;
    exit;
  end;
  //
  // modif BTP : pas d'acc�s � l'article en saisie d'avancements
  if (SaisieTypeAvanc) or (ModifAvanc) then Exit;
  // AC - Correction fiche Mode 10684
  SupDim := False ;
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
  { Emp�che le changement de l'article si il y a des pi�ces pr�c�dentes ou suivantes }
  TobL := GetTOBLigne(TOBPiece, ARow);
  // AC - Correction fiche Mode 10771
  If Tobl=nil then exit ;
  if IsSousDetail(TOBL) then
  begin
  	if TOBL.getValue('GL_ARTICLE')<>'' then
    begin
    	GS.Cells[ACol, ARow] := StCellCur;
    	exit;
    end;
  end;
  // Modif AC
  If TOBL.GetValue('GL_TYPEDIM')='NOR' then CalcTarif:=TRUE ;
  //
  if ((TypeL = 'ART') or (TypeD = 'GEN')) and (not CanChangeArticle(Tobl)) then { NEWPIECE } // and (PiecePrec<>'') then
  begin
    GS.Cells[ACol, ARow] := GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', ARow);
    Cancel := True;
    exit;
  end;
  if GS.Cells[ACol, ARow] = '' then
  begin
    TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', ARow);
    if (TypeL <> 'TOT') and (TypeD <> 'GEN') and (TypeL <> 'RG') and (TypeL <> 'RL') and (not IsSousDetail(TOBL))
// MODIF VARIANTE
(*      and (copy(TypeL, 1, 2) <> 'DP') and (copy(TypeL, 1, 2) <> 'TP') then //MODIFBTP *)
    and not (IsParagraphe (TOBL)) then
    begin
{$IFDEF BTP}
      if IsOuvrage (TOBL) then
      begin
        SuppressionDetailOuvrage (TOBL);
      end;
{$ENDIF}
      VideCodesLigne(TOBPiece, ARow);
      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow, True);
      SupprimeLigneTarif(TobPiece, TobLigneTarif, ARow);
    end;
    Exit;
  end;
  if IsSousDetail(TOBL) then
  begin
    fModifSousDetail.RechercheCodeArticle (Acol,Arow,TOBL,GS.Cells[SG_RefArt, Arow]);
    exit;
  end;

    // AC - Correction fiche Mode 10684
  if (Tobl.GetValue('GL_REFARTSAISIE')<>'') and (GS.Cells[ACol, ARow] <> Tobl.GetValue('GL_REFARTSAISIE')) and (Tobl.GetValue('GL_TYPEDIM')<>'NOR') then SupDim :=True ;
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
      GS.Cells[Acol, Arow] := StCellCur;
      exit;
    end else
    begin
    	//
      //
      if GetChampLigne(TobPiece, 'GL_ENCONTREMARQUE', ARow) = 'X' then
         UpdateCataLigne(ARow, False, False, NewQte)
      else
         UpdateArtLigne(ARow, False, False, CalcTarif, NewQte);
      if not TraiteRupture(ARow) then
      begin
        if SG_QF >= 0 then
        begin
{$IFDEF BTP}
          GS.Cells[SG_QF, ARow] := '';
          TraiteQte(SG_QF, ARow);
{$ELSE}
          GS.Cells[SG_QF, ARow] := '';
          TraiteQte(SG_QF, ARow);
{$ENDIF}
        end;
        if SG_QS >= 0 then
        begin
          GS.Cells[SG_QS, ARow] := '';
          TraiteQte(SG_QS, ARow);
        end;
      	TOBPiece.PutValue('GP_RECALCULER', 'X');   // Position avant
      end;
      TOBL.putvalue('NEW_LIGNE','X');
//      TOBPiece.PutValue('GP_RECALCULER', 'X');   // Position avant
    end;
    // AC - Correction fiche Mode 10684
    if SupDim then SupprimeDim(Arow) ;

		AffecteTenueStock(TOBL,TOBPiece,TOBArticles);

  	if (Action = TaModif) and (Pos(TobL.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) then
  	begin
      // Pas de message pour cr�ation livraison car en g�n�ration de facture, la livraison est cr��e automatiquement
      if not ((TransfoPiece) and (TOBPiece.GetValue('GP_NATUREPIECEG')='FF')) then
      begin
        receptionModifie := true;
        EnregistreLigneLivAAjouter(TOBL);
      end;
  	end;
  end else
  begin
  	if not cancel then
    begin
      GS.Col := NewCol;
      GS.Row := NewRow;
    end;
  end;
end;

function TFFacture.ArticleUniqueDansCatalogue(RefUnique, RefFour: string): TOB;
// Contr�le si article existe une fois et une seule dans le catalogue
var
  cSQL, RefCata: string;
  QQ: tQuery;
begin
  Result := nil;
  cSql := 'Select * from CATALOGU Where GCA_ARTICLE="' + RefUnique + '"';
  if (RefFour <> '') then cSql := cSql + ' AND GCA_TIERS="' + RefFour + '"';
  QQ := OpenSQL(cSQL, True,-1, '', True);
  if (not QQ.EOF) and (QQ.RecordCount = 1) then
  begin
    RefCata := QQ.FindField('GCA_REFERENCE').AsString;
    RefFour := QQ.FindField('GCA_TIERS').AsString;
    Result := InitTOBCata(TOBCatalogu, RefCata, RefFour);
  end;
  Ferme(QQ);
end;

procedure TFFacture.LigneEnContreM(var ACol, ARow: integer; var Cancel: boolean);
{Changement dans l'�tat du flag contre marque}
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
      {Test si r�f�rence existe dans catalogue et est unique}
      TOBCata := ArticleUniqueDansCatalogue(TOBL.GetValue('GL_ARTICLE'), TOBA.GetValue('GA_FOURNPRINC'));
      if (TOBCata = nil) then
      begin
        {Plusieurs fournisseurs pour l'article => S�lection }
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
        Cancel := True; {Pas de s�lection}
      end;
    end;
  end else {D�sactivation de la contre marque}
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

procedure TFFacture.RecalculeSousTotaux(TOBPiece: TOB; GestionAffichage: Boolean = True); 
var i: integer;
begin
  CalculeSousTotauxPiece(TOBPiece);
  if GestionAffichage then  
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
        if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALHTDEV');
    end else
    begin
      for i := 0 to TOBPorcs.Detail.Count - 1 do
        if TOBPorcs.Detail[i].GetValue('GPT_FRAISREPARTIS') <> 'X' then X := X + TOBPorcs.Detail[i].GetValue('GPT_TOTALTTCDEV');
    end;
  end;
  TOTALPORTSDEV.Value := Arrondi(X, 6);
end;

procedure TFFacture.CalculeLeDocument (Arow : integer; OnLyPv:boolean=false);
var InAvancement : boolean;
		RecalcPuv : boolean;
begin
  InAvancement := (SaisieTypeAvanc) {or (ModifAvanc)};
  RecalcPuv := (FactReCalculPv) and (not ModifAvanc) and (not SaisieTypeavanc);
  if (CalculPieceAutorise) and (TOBPiece.GetValue('GP_RECALCULER') = 'X') then
  begin
// ------------------------------------
//    suppression physique des lignes supprimes
// ------------------------------------
    DeduitLesLignesSupprimes;
// ------------------------------------
		RecalcPuv := (FactReCalculPv) and (not ModifAvanc);
    if BeforeCalcul(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBOuvrage, TOBCpta, TOBcatalogu, TOBAffaire, TOBTablette,TOBPorcs,DEV,Arow,RecalcPuv ,RAZFg,OnlyPv ) then
    begin
      TRY
        CalculFacture(TOBPiece,TOBPieceTrait,TOBOUvrage, TOBOuvragesP,TOBBases, TOBBasesL,TOBTiers, TOBArticles, TOBPorcs, TOBPieceRG, TOBBasesRG, DEV, InAvancement, Action,false,Arow);
      FINALLY
        AfterCalcul(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, TOBPIECERG, TOBBASESRG, DEV);
      END;
    end else
    begin
      CalculeMontantsDoc (TOBPiece,TOBOuvrage);
    end;
  end;
end;


procedure TFFacture.AfterCalculeLasaisie (Acol,Arow : integer ; Afftout : boolean ; WithFrais : boolean=true);
var  Okok: boolean;
     XD, XP: double;
      i : integer;
begin
	OkOK := true;
  TOBPiece.PutEcran(Self, PPied);
  if (SaisieTypeAvanc) then
  begin
    TOBPiece.PutEcran(Self, PPiedAvanc);
  end;
  AfficheTaxes;
  AffichePorcs;
  if ARow > 0 then AfficheLaLigne(ARow) else if (not afftout) then afftout := true;
  RecalculeSousTotaux(TOBPiece, Afftout);

  if (TOBPiece.getValue('GP_ETATVISA')<>'VIS') and (NeedVisa) then
  begin
    if VH_GC.GCIfDefCEGID then
    begin
    if ((Action = taModif) and (not TransfoPiece) and (not DuplicPiece) and
      (Arrondi(TOBPiece.GetValue('GP_TOTALHT') - OldHT, 6) = 0)) then Okok := False;
    end
    else
    Okok := True;
    if Okok then
    begin
      if Abs(TOBPiece.GetValue('GP_TOTALHT')) >= MontantVisa then TOBPiece.PutValue('GP_ETATVISA', 'ATT')
      else TOBPiece.PutValue('GP_ETATVISA', 'NON');
    end;
  end;
  TesteRisqueTiers(False);
  // Modif BTP
  if not RGMultiple(TOBpiece) then
  begin
  	RecalculeRG(TOBPORCS,TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, DEV);
  end;
  GetMontantRGReliquat(TOBPIeceRG, XD, XP);

  TOTALRGDEV.Value := XD;

  TTYPERG.text := GetCumultextRg(TOBPIECERG, 'PRG_TYPERG');
  TCAUTION.text := GetCumulTextRG(TOBPIECERG, 'PRG_NUMCAUTION');
  if TOBTimbres.Detail.Count > 0 then
  begin
    GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, False);
    CalculeTimbres (TOBTimbres,TOBpiece,TOBEches);
    GP_TOTALTIMBRES.Value := GetTotalTimbres(TOBTimbres,TOBpiece,TOBEches);
  end;
  if AffTout then
  begin
    for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
  end;

  if GereDocEnAchat then AfficheZonePiedAchat;
end;

procedure TFFacture.CalculeLaSaisie(ACol, ARow: integer; AffTout: boolean; WithFrais : boolean=true; LigDepart : integer = -1; LigFin : integer = -1);
var i: integer;
  TOBL : TOB;
  DepartTrait,FinTrait : integer;
  PourcentFound,realCalc : integer;
  // ---
begin
	realCalc := -1;
  if ((ACol <> SG_RefArt) and (ACol <> SG_QF) and (ACol <> SG_QS) and (ACol <> SG_QA) and (ACol <> SG_Px) and
    {$IFDEF MODE} // Modif MODE 31/07/2002
    (ACol <> SG_PxNet) and (ACol <> SG_Montant) and
    {$ENDIF}
    (Acol <> SG_QTESITUATION ) and (aCol <> SG_POURCENTAVANC) and (aCol <> SG_MontantSit) and
    (Acol <> Sg_PXAch) and (Acol <> SG_TEMPS) and (Acol <> SG_TEMPSTOT) and
    (ACol <> SG_Rem) and (ACol <> SG_RV) and (ACol <> SG_RL) and (ACol <> SG_Pct) and (ACol <> -1)) then Exit;
  if (CalculPieceAutorise) then
  begin
    if TOBPiece.GetValue('GP_RECALCULER') = 'X' then
    begin
			PourcentFound := PositionneRecalculePourcent (Arow);
      CalculeLeDocument(Arow);
      if PourcentFound <> -1 then CalculeLeDocument(PourcentFound+1);
      // ------
      AfterCalculeLasaisie (Acol,Arow,Afftout,WithFrais);
    	TOBPiece.PutValue('GP_RECALCULER', '-');
    end;
    CacheTotalisations (false);
  end else
  begin
  	if (Arow > 0) then
    begin
    	TOBL := GetTOBLigne (TOBpiece,Arow);
//      if not IsVariante(TOBL) then CacheTotalisations (True);
			PourcentFound := PositionneRecalculePourcent (Arow);
    	CalculeLaLigne (TOBPiece,TOBpieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,TOBARticles,TOBPOrcs,TOBPieceRG,TOBBasesRG,TOBL,DEV,DEV.Decimale,SaisieTypeAvanc,ModifAvanc,self);
      AfficheLaLigne (Arow);
      AfterCalculeLasaisie (Acol,Arow,true,WithFrais);
      (*
      if RealCalc <> -1 then
      begin
    		TOBL := GetTOBLigne (TOBpiece,RealCalc);
    		CalculeLaLigne (TOBPiece,TOBpieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,TOBARticles,TOBPOrcs,TOBPieceRG,TOBBasesRG,TOBL,DEV,DEV.Decimale,SaisieTypeAvanc,ModifAvanc,self);
      	AfficheLaLigne (RealCalc);
      	AfterCalculeLasaisie (Acol,RealCalc,true,WithFrais);
      end;
      *)
      if PourcentFound <> -1 then
      begin
    		TOBL := GetTOBLigne (TOBpiece,PourcentFound);
    		CalculeLaLigne (TOBPiece,TOBpieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,TOBARticles,TOBPOrcs,TOBPieceRG,TOBBasesRG,TOBL,DEV,DEV.Decimale,SaisieTypeAvanc,ModifAvanc,self);
      	AfficheLaLigne (PourcentFound);
      	AfterCalculeLasaisie (Acol,PourcentFound,true,WithFrais);
      end;
    end ELSE
    begin
      if (LigDepart <> -1) and (Ligfin <> -1) then
      begin
				PourcentFound := PositionneRecalculePourcent (ligDepart);
        DepartTrait := LigDepart-1;
        FInTrait := LigFin-1;
        if PourcentFound > FinTrait then FinTrait := PourcentFound;
      end else
      begin
        DepartTrait := 0;
        FinTrait := TOBpiece.detail.count -1;
      end;
      CacheTotalisations (True);
    	for I := DepartTrait to FinTrait do
      begin
         TOBL := GetTOBLigne (TOBpiece,I+1);
//         TOBPiece.putvalue ('GP_RECALCACHAT','X');
    	   CalculeLaLigne (TOBPiece,TOBPieceTrait,TOBOuvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,TOBARticles,TOBPOrcs,TOBPieceRG,TOBBasesRG,TOBL,DEV,DEV.Decimale,SaisieTypeAvanc,ModifAvanc,self);
         if TOBL.GetValue('GL_DPR') <> 0 then
         begin
					TOBL.putValue('GL_COEFMARG',Arrondi(TOBL.GetValue('GL_PUHT')/TOBL.getValue('GL_DPR'),4));
         end;

         AfficheLaLigne (I+1);
      end;
      TOBPiece.putvalue ('GP_RECALCACHAT','-');
      AfterCalculeLasaisie (Acol,Arow,true,WithFrais);
    end;
  end;
end;

{==============================================================================================}
{======================================== Affichages ==========================================}
{==============================================================================================}
{$IFDEF BTP}
procedure TFFacture.AfficheZonePiedAchat;
begin
  DefiniePiedAchat (self , TOBPiece, DEV);
  DefiniPied;
end;

procedure TFFacture.AfficheZonePiedStd;
begin
  DefiniePiedStd (self);
  DefiniPied;
end;

{$ENDIF}

procedure TFFacture.AfficheZonePied(Sender: TObject);
var Nam, Nam2: string;
  CC: THLabel;
  rTaxes, rPay: Double;
  // Modif BTP
  XD, XP: double;
  TXD, TXP: double;
  Vasy: boolean;
  TheMontantRGTTC,TheMontantTimbres : double;
begin
  if Sender = nil then Exit;
  // Modif BTP
  vasy := false;
  // ----
  Nam := THNumEdit(Sender).Name;
  Nam := 'L' + Nam;

  {$IFDEF BTP}
  if GereDocEnAchat then
  begin
    if nam = 'LGP_TOTALHTDEV' then AfficheZonePiedAchat;
    Exit;
  end;
  {$ENDIF}

  CC := THLabel(FindComponent(Nam));
  if CC <> nil then CC.Caption := THNumEdit(Sender).Text;
  // Modif BTP
  if (Nam = 'LTOTALRGDEV') or (Nam = 'LTTYPERG') or (Nam = 'LTCAUTION') then
  begin
    HTTCDEV.Value := 0;
    vasy := true;
    if (TOTALRGDEV.Value <> 0) and (GetCumulTextRG(TOBPieceRG, 'PRG_TYPERG') = 'HT') and (ApplicRetenue) then
    begin
      GetcumultaxesRG(TOBBasesRG, TOBPieceRG, TXD, TXP, DEV);
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
      GetcumultaxesRG(TOBBasesRG, TOBPieceRG, TXD, TXP, DEV);
      rTaxes := TOBPiece.GetValue('GP_TOTALTTCDEV') - TOBPiece.GetValue('GP_TOTALHTDEV') - TXD;
    end else
      // ----
      rTaxes := TOBPiece.GetValue('GP_TOTALTTCDEV') - TOBPiece.GetValue('GP_TOTALHTDEV');
    Nam2 := 'LTOTALTAXESDEV';
    CC := THLabel(FindComponent(Nam2));
    HTotalTaxesDEV.Value := rTaxes;
    if CC <> nil then CC.Caption := HTotalTaxesDEV.Text;
  end;
  if ((Nam = 'LGP_TOTALTTCDEV') or (Nam = 'LGP_ACOMPTEDEV') or
  	 (Nam = 'LNETAPAYERDEV') or (Nam = 'LTOTALRGDEV') or
     (Nam = 'LGP_TOTALTIMBRES')) then
  begin
    //
  	GetMontantRGReliquat(TOBPIeceRG, XD, XP,true);
    TheMontantRGTTC := XD;
    // Recup du montant de timbres
    TheMontantTimbres := GP_TOTALTIMBRES.Value;
    // Modif BTP
    if (TheMontantRGTTC <> 0) and (ApplicRetenue) then
    begin
      vasy := true;
      rPay := TOBPiece.GetValue('GP_TOTALTTCDEV') - TheMontantRGTTC + TheMontantTimbres - TOBPiece.GetValue('GP_ACOMPTEDEV');
    end else
    begin
      // ---
      rPay := TOBPiece.GetValue('GP_TOTALTTCDEV') + TheMontantTimbres - TOBPiece.GetValue('GP_ACOMPTEDEV');
    end;
    Nam2 := 'LNETAPAYERDEV';
    CC := THLabel(FindComponent(Nam2));
    NetAPayerDEV.Value := rPay;
    if CC <> nil then CC.Caption := NetAPayerDEV.Text;
  end;
  if (Nam = 'LGP_TOTALTIMBRES') then
  begin
  	vasy := true;
  end;
  // Modif BTP
  if vasy then DefiniPied;
end;

procedure TFFacture.TraiteAffaireParam;
	procedure SEtAffaireLignes (TOBpiece : TOB);
  var indice : integer;
  begin
  	for indice := 0 to TOBPiece.detail.count -1 do
    begin
    	TOBPiece.detail[Indice].putValue('GL_AFFAIRE',TOBPiece.getValue('GP_AFFAIRE'));
    	TOBPiece.detail[Indice].putValue('GL_AFFAIRE1',TOBPiece.getValue('GP_AFFAIRE1'));
    	TOBPiece.detail[Indice].putValue('GL_AFFAIRE2',TOBPiece.getValue('GP_AFFAIRE2'));
    	TOBPiece.detail[Indice].putValue('GL_AFFAIRE3',TOBPiece.getValue('GP_AFFAIRE3'));
    	TOBPiece.detail[Indice].putValue('GL_AVENANT',TOBPiece.getValue('GP_AVENANT'));
    end;
  end;

	procedure AffecteValue (Champ : THcritMaskEdit; Value : string );
  var PtrChange : TNotifyEvent;
  begin
   PtrChange := Champ.OnChange;
   Champ.OnChange := nil;
   Champ.Text := value;
   Champ.OnChange := PtrChange;
  end;

var Part0,Part1,Part2,PArt3,CodeAvenant,ThisAffaire:string;
		QQ : TQuery;
begin
//	if (Action <> taCreat) and ((Action<>TaModif) or (not DuplicPiece)) then Exit;
//  if (LAffaire = '') then exit;
  if LAffaire<>'' then
  begin
  	ThisAffaire := Laffaire;
  end else
  begin
  	if (TOBPiece.GetValue('GP_VENTEACHAT')<>'VEN') then exit;
  	ThisAffaire := TOBPiece.getValue('GP_AFFAIRE');
  end;
  if ThisAffaire = '' then exit;
  //
	if (ctxAffaire in V_PGI.Pgicontexte) then
  begin
    BTPCodeAffaireDecoupe(ThisAffaire, Part0, Part1, Part2, Part3,CodeAvenant,taConsult,False);
    GP_AFFAIRE.Text := ThisAffaire;

    AffecteValue (GP_AFFAIRE0,Part0);
    AffecteValue (GP_AFFAIRE1,Part1);
    AffecteValue (GP_AFFAIRE2,Part2);
    AffecteValue (GP_AFFAIRE3,Part3);
    AffecteValue (GP_AVENANT,CodeAvenant);
    if LAvenant <> '' then Codeaffaireavenant := LAvenant
    									else Codeaffaireavenant := CodeAvenant;
    if Codeaffaireavenant = '' then Codeaffaireavenant := '00';
   end;
   TOBPiece.putValue('GP_AFFAIRE',GP_AFFAIRE.text);
   TOBPiece.putValue('GP_AFFAIRE1',GP_AFFAIRE1.text);
   TOBPiece.putValue('GP_AFFAIRE2',GP_AFFAIRE2.text);
   TOBPiece.putValue('GP_AFFAIRE3',GP_AFFAIRE3.text);
   TOBPiece.putValue('GP_AVENANT',GP_AVENANT.text);
   TOBAffaire.InitValeurs;
   QQ := OpenSql ('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="'+ThisAffaire+'"',true,-1, '', True);
   if not QQ.eof then TOBAffaire.selectdb ('',QQ);
   ferme (QQ);
   SEtAffaireLignes (TOBpiece);
   // OPTIMISATIONS LS
   StockeCetteAffaire (TOBAffaire);
   // --
end;

procedure TFFacture.TraiteTiersParam;
begin
//MDOIF LS  if Action <> taCreat then Exit;
	if (Action <> taCreat) and ((Action<>TaModif) or (not DuplicPiece)) then Exit;
  if LeCodeTiers = '' then Exit;
  GP_TIERS.Text := LeCodeTiers;
  TiersVersPiece(TOBTiers, TOBPiece);
  TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece);
  if GeneCharge then Exit;
  ChargeTiers;
  PutValueDetail(TOBPiece, 'GP_TIERS', GP_TIERS.Text);
  if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then
    ChargeAffairePiece(True, True, True);
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
  //Gestion de l'affichage dans le cas de l'appel � partir d'un contrat
  if Copy(GP_AFFAIRE.text,1,1) = 'I' then
     Begin
     PEnteteAffaire.Enabled := True;
     GP_AFFAIRE1.Enabled := False;
     GP_AFFAIRE2.Enabled := False;
     GP_AFFAIRE3.Enabled := False;
     BDEVISE.Enabled := false;
     GP_DEVISE.Enabled := False;
     End;
  if not (ctxAffaire in V_PGI.PGIContexte) and not (ctxGCAFF in V_PGI.PGIContexte) then Exit;
  if SaisieTypeAffaire then Exit;
  BZoomAffaire.Enabled := ((TOBAffaire.GetValue('AFF_AFFAIRE') <> '') and (GP_AFFAIRE.Text = TOBAffaire.GetValue('AFF_AFFAIRE')));
  if (GetParamSoc('SO_AFTYPECONF') <> 'A00') then BZoomAffaire.Enabled := False; // mcd 18/01/02 pas zoom si confidentailit�
  if (action=taModif) and (GP_AFFAIRE.text <> '') then
  begin
  	GP_AFFAIRE1.enabled := false;
  	GP_AFFAIRE2.enabled := false;
  	GP_AFFAIRE3.enabled := false;
  end;
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
  Nomenc: boolean;
  // ----
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  BZoomArticle.Enabled := (GetCodeArtUnique(TOBPiece, ARow) <> '');
  BZoomPiece.Enabled := (not TransfoPiece) and (action in [taModif, taConsult]);
  if (Ctxscot in V_PGI.PGIContexte) or (CtxBTP in V_PGI.PGIContexte) or (CtxCHR in V_PGI.PGIContexte) then BZoomPiece.Enabled := False; // mcd bl rh 14/10/2003
  //mcd merci de remettre la ligne suivante en place, quand les modif concernant ce bouton seront report� dans diffus depuis Vdev
  //if (ctxAffaire in V_PGI.PGIContexte) and  not(ctxGCAFF in V_PGI.PGIContexte) then BZoomLignes.Enabled:=False;//mcd 14/04/2003
  {$IFDEF CCS3} // DBR Fiche 10202 - pas de lot et serie en S3
  MBDetailLot.Visible := False;
  {$ENDIF}
  if TOBL = nil then
  begin
    BZoomTarif.Enabled := False;
    BZoomDispo.Enabled := False;
    BZoomPrecedente.Enabled := False;
    BZoomOrigine.Enabled := False;
    BZoomTache.Enabled := false;
    MBSoldeReliquat.Enabled := False;
    MBSoldeTousReliquat.Enabled := False;
    MBDetailNomen.Enabled := False;
(*    {$IFDEF CCS3} // DBR Fiche 10202
    MBDetailLot.Visible := False;
    {$ELSE} *)
    {$IFNDEF CCS3}
    MBDetailLot.Enabled := False;
    {$ENDIF}
    VLigne.Enabled := False;
    SLigne.Enabled := False;
    BZoomRevision.Enabled := false; //Affaire-R�vision des prix
  end else
  begin
    // Modif BTP
    TypeArt := TOBL.GetValue('GL_TYPEARTICLE');
    {$IFDEF BTP}
    DefiniPopYBtp (self,TypeArt,TOBPiece);
    {$ENDIF}

    //BOffice.Visible:=False;
    for Indice := 0 to POPL.Items.Count - 1 do
    begin
      if (POPL.Items[Indice].Name = 'TInsParag') and (VH_GC.BTGestParag = False) then
      begin
        POPL.Items[Indice].Visible := false;
        POPL.Items[Indice + 1].Visible := false;
      end;
      {$IFDEF BTP}
      DefiniPopLBtp (self,Indice);
      {$ENDIF}
    end;

    Nomenc := TOBL.GetValue('GL_TYPEARTICLE') = 'NOM';
    // FIn Modif BTP
    OkArt := ((TOBL.GetValue('GL_ARTICLE') <> '') or (TOBL.GetValue('GL_REFCATALOGUE') <> ''));
    if CtxMode in V_PGI.PGIContexte then OkArt := TOBL.GetValue('GL_REFARTSAISIE') <> '';
    BZoomDispo.Enabled := ((OkArt) and ((TOBL.GetValue('GL_TENUESTOCK') = 'X') or (TOBL.GetValue('GL_ENCONTREMARQUE') = 'X')));
    BZoomTarif.Enabled := ((OkArt) and (TOBL.GetValue('GL_TARIF') > 0));
    BZoomPrecedente.Enabled := ((OkArt) and (TOBL.GetValue('GL_PIECEPRECEDENTE') <> ''));
    BZoomOrigine.Enabled := ((OkArt) and (TOBL.GetValue('GL_PIECEORIGINE') <> ''));
    BZoomTache.Enabled := (VH_GC.GAPlanningSeria and (OkArt) and (Action<>taConsult) and bSaisieNatAffaire );
    { Caption et �tat Activer/Solder ligne ou Activer/Sodler Reliquats }
    if (Action = taModif) and (not TransfoPiece) then
    begin
      { Modification pure de pi�ce }
      if  (PieceMajStockPhysique) or (Not GereReliquat) then
        MBSoldeReliquat.Enabled := False
      else
      begin
        if (TobL.GetValue('GL_SOLDERELIQUAT') = 'X') then
          MBSoldeReliquat.Caption := TraduireMemoire('D�-solder la ligne')
        else
        begin
          MBSoldeReliquat.Caption := TraduireMemoire('Solder la ligne');
          MBSoldeReliquat.Enabled := (TobL.GetValue('GL_QTERESTE') > 0);
        end;
      end;

      MBSoldeTousReliquat.Caption := TraduireMemoire('Solder toutes les lignes');
    end
    else
    begin
      MBSoldeReliquat.Caption := TraduireMemoire('Solder / Activer le reliquat');
      MBSoldeTousReliquat.Caption := TraduireMemoire('Solder / Activer tous les reliquats');
      MBSoldeReliquat.Enabled := OkArt and (ReliquatTransfo or GereReliquat) and (not PiecePrecMajStockPhysique);
      MBSoldeTousReliquat.Enabled := MBSoldeReliquat.Enabled;
    end;
    MBDetailNomen.Enabled := ((OkArt) and (TOBL.GetValue('GL_INDICENOMEN') > 0) and (JaiLeDroitConcept(TConcept(bt112),False)) );
    {$IFNDEF CCS3}
    MBDetailLot.Enabled := ((OkArt) and ((TOBL.GetValue('GL_INDICELOT') > 0) or (TOBL.GetValue('GL_INDICESERIE') > 0)));
    {$ENDIF}
    VLigne.Enabled := OkArt;
    SLigne.Enabled := OkArt;
    BSousTotal.Enabled := ((ARow > 1) and (TOBL.GetValue('GL_TYPELIGNE') <> 'TOT'));
    {$IFDEF AFFAIRE} //Affaire-R�vision des prix
    BZoomRevision.Enabled := GetParamSoc('SO_AFREVISIONPRIX') and OkArt
      and (TOBL.GetValue('GL_TYPELIGNE') = 'ART') and (TOBL.GetValue('GL_TYPEARTICLE')<>'POU')
      and ((CleDoc.NaturePiece = 'FAC') or (CleDoc.NaturePiece = 'FPR')
      or (CleDoc.NaturePiece = 'APR') or (CleDoc.NaturePiece = 'AVC')
      or bSaisieNatAffaire);
    {$ENDIF}
    // Modif BTP
    MBModevisu.Enabled := ((OkArt) and (IsOuvrage(TOBL) or Nomenc) and (Not IsLigneFromBordereau(TOBL)));
    // MODIF VARIANTE
(*    Cpltligne.enabled := ((okart) and (TOBL.getvalue('GL_TYPELIGNE') <> 'COM') and *)
     Cpltligne.enabled := ((okart) and (not IsCommentaire(TOBL)) and
      (TOBL.GetValue('GL_TYPELIGNE') <> 'TOT'));
    // MODIF VARIANTE
(*    if copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) = 'DP' then *)
     if IsDebutParagraphe(TOBL) then
      CpltLigne.enabled := true;
    // ----
  end;
  BVentil.Enabled := ((VPiece.Enabled) or (VLigne.Enabled) or (SPiece.Enabled) or (SLigne.Enabled));
end;

procedure TFFacture.AnalyseDollar(ARow: integer);
Var StComm: String;
    i,iDep,iLen: integer;
BEGIN
  if Action=taConsult then Exit;
  if GS.Col<>SG_Lib then Exit;
  if GS.InPlaceEditor=nil then Exit;
  StComm:=GS.Cells[SG_Lib,ARow];
  iDep:=Pos('$',StComm); if iDep<=0 then Exit;
  iLen:=1; for i:=iDep+1 to Length(StComm) do if StComm[i]='$' then Inc(iLen) else Break ;
  GS.InplaceEditor.SelStart:=iDep-1; GS.InplaceEditor.SelLength:=iLen;
END ;

procedure TFFacture.ZoomOuChoixLib(ACol, ARow: integer);
var TOBL: TOB;
  Contenu: TStrings;
  LigCom: string;
  i_ind, ANewRow: integer;
  frombordereau : boolean;
begin
  if ACol <> SG_Lib then Exit;
  if Action = taConsult then Exit;
  if not CommentLigne then Exit;
  {$IFDEF BTP}
  if AfficheDesc (self,TOBPiece) = True then Exit;
  if OrigineEXCEL then
  begin
    ZoomOuChoixArtLib(self,TOBPiece,TobArticles,TobTiers,TobAffaire,GS.Col, GS.Row);
  end;
  Exit; // Pas de gestion des libell�s auto pour BTP
  {$ENDIF}
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (ctxMode in V_PGI.PGIContexte) or (ctxChr in V_PGI.PGIContexte) or (ctxFO in V_PGI.PGIContexte) then
  begin
    if GereElipsis(ACol,frombordereau) then TOBL.PutValue('GL_LIBELLE', GS.Cells[ACol, ARow]);
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
    end else if GereElipsis(ACol,frombordereau) then
    begin
       TOBL.PutValue('GL_LIBELLE', GS.Cells[ACol, ARow]);
       {$IFDEF GESCOM}
       AnalyseDollar(ARow);
       {$ENDIF}
    end;
  end;
end;

procedure TFFacture.ZoomOuChoixDateLiv(ACol, ARow: integer);
var TOBL: TOB;
  HDATE: THCritMaskEdit;
  Coord: TRect;
begin
  // DEBUT MODIF CHR
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
  if HDATE.Text <> '' then GS.Cells[ACol, GS.Row] := HDATE.Text;
  // FIN MODIF CHR
  HDATE.Free;
end;

procedure TFFacture.ZoomOuChoixArt(ACol, ARow: integer);

procedure SaveCatalogu (TOBC,TOBA : TOB);
var j : integer;
	  Nam : string;
begin
  for j := 1 to TOBC.NbChamps do
  begin
    Nam := TOBC.GetNomChamp(j);
    if TOBA.FieldExists(Nam) then TOBC.PutValue(Nam, TOBA.GetValue(Nam));
  end;
end;

procedure RestitueCatalogu (TOBC,TOBA : TOB);
var j : integer;
	  Nam : string;
begin
  for j := 1 to TOBC.NbChamps do
  begin
    Nam := TOBC.GetNomChamp(j);
    if TOBA.FieldExists(Nam) then TOBA.PutValue(Nam, TOBC.GetValue(Nam));
  end;
end;

var RefUnique, RefCata, RefFour: string;
  Cancel, OkArt: boolean;
  TOBA, TOBL: TOB;
  ActionArt: TActionFiche;
  QQ : Tquery;
  TOBCat : TOB ;
begin
  if (ACol <> SG_RefArt) or (GetTOBLigne(TOBPiece, ARow) = nil) then Exit;
  RefUnique := '';
  RefCata := '';
  RefFour := '';
  TOBL := GetTOBLigne(TOBPiece, ARow);
  {$IFDEF AFFAIRE}
  if (Action = taConsult) and not TraiteFormuleVar(GS.Row, 'CONSULT') then Exit; //Affaire-Formule des variables
  {$ENDIF}
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
      QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                     'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                     'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
//      TOBA.SelectDB('"' + RefUnique + '"', nil);
      TOBA.SelectDB('',QQ);
      InitChampsSupArticle (TOBA);
      ferme (QQ);
    end;
    // -----
    ZoomArticle(RefUnique, TobA.GetValue('GA_TYPEARTICLE'), ActionArt);
{$IFDEF BTP}
    if ActionArt <> taConsult then
    begin
    	TOBCat := TOB.Create ('CATALOGU',nil,-1);
    	SaveCatalogu (TOBCat,TOBA);
      TOBA.InitValeurs;
      QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                     'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                     'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
//      TOBA.SelectDB('"' + RefUnique + '"', nil);
      TOBA.SelectDB('',QQ);
      InitChampsSupArticle (TOBA);
      ferme (QQ);
    	RestitueCatalogu (TOBCat,TOBA);
      TOBCat.free;
			TheRepartTva.AppliqueLig (TOBL);
    	TheDestinationLiv.SetDestLivrDefaut (TOBL);
    end;
{$ENDIF}
  end else if (RefCata <> '') and (RefFour <> '') then
  begin
    ZoomCatalogue(RefCata, RefFour, ActionArt);
  end else if Action <> taConsult then
  begin
    TOBL := GetTOBLigne(TOBPiece, ARow);
    if TOBL = nil then exit;
    if IsSousDetail(TOBL) then
    begin
      fModifSousDetail.RechercheCodeArticle (Acol,Arow,TOBL,GS.Cells[SG_RefArt, Arow]);
      exit;
    end;
    //
    if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
    begin
      AppelleDim(ARow);
    end else
    begin
      Cancel := False;
      OkArt := IdentifierArticle(ACol, ARow, Cancel, true, False);
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
          UpdateArtLigne(ARow, False, False, True, 1);
          if not TraiteRupture(ARow) then
          begin
          	TOBL := GetTOBLigne(TOBPiece, ARow);
            TOBL.putValue('GL_QTEFACT',0);
            TOBL.putValue('GL_QTESTOCK',0);
            TOBL.putValue('GL_QTERESTE',0);
//            VideCodesLigne(TOBPiece, ARow);
//            InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
//            AfficheLaLigne (Arow);
//            exit;
          end;
{$IFDEF BTP}
          if ActionArt <> taConsult then
          begin
            TheRepartTva.AppliqueLig (TOBL);
            TheDestinationLiv.SetDestLivrDefaut (TOBL);
          end;
{$ENDIF}
          CalculeLaSaisie(SG_RefArt, ARow, True);
          TOBL := GetTOBLigne(TOBPiece, ARow);
          if (TOBL.GetValue('GL_TYPEPRESENT') <> DOU_AUCUN) or (TOBL.GetValue('GLC_VOIRDETAIL')='X')  Then
          begin
            GestionDetailOuvrage(self,TobPiece,Arow,Acol);
          end;
          StCellCur := GS.Cells[ACol, ARow];
        end;
        GereEnabled(Arow);
      end;
    end;
  end;
  if (Action = taConsult) and (RefUnique = '') then AppelleDim(ARow);
end;

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
      Q := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                     'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                     'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
      TobTemp := TOB.Create('LesArticles', nil, -1);
      if not Q.EOF then TobTemp.LoadDetailDB('ARTICLE', '', '', Q, False, True);
      TobArt := TobTemp.FindFirst(['GA_ARTICLE'], [RefUnique], False);
      if TobArt <> nil then
      begin
      	InitChampsSupArticle (TOBArt);
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
    ChargeNouveauDepot (nil, TobL, NewDep);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
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
      //stCellCur := GS.Cells[ACol, ARow]; DBR pour que le traitedepot se d�clanche bien.
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
{$IFNDEF BTP}
  if not VH_GC.GCIfDefCEGID then
     if GS.NbSelected <= 0 then Exit;
{$ENDIF}
  for i := 1 to GS.RowCount - 1 do
  begin
    TOBL := GetTOBLigne(TOBPiece, i);
    if TOBL = nil then Break;
{$IFNDEF BTP}
    if ( (not VH_GC.GCIfDefCEGID) and (GS.isSelected(i)) ) or
       (VH_GC.GCIfDefCEGID) then
{$ENDIF}
    begin
      OldRep := TOBL.GetValue('GL_REPRESENTANT');
      if OldRep <> GP_REPRESENTANT.Text then
      begin
        TOBL.PutValue('GL_REPRESENTANT', GP_REPRESENTANT.Text);
        TOBL.PutValue('GL_VALIDECOM', 'NON');
        CommVersLigne(TOBPiece, TOBArticles, TOBComms, i, True);
      end;
    end;
  end;
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  CopierColler.deselectionneRows;
  {$ENDIF}
  ShowDetail(GS.Row);
end;

procedure TFFacture.ZoomRepres(Repres: string);
var Crits: string;
begin
	crits := '';
	if TypeCom <> '' then Crits := ';GCL_TYPECOMMERCIAL="' + TypeCom + '"';
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
{$IFDEF BTP}
		TOBC,TOBART,TOBCata : TOB;
    LocanaP,LocAnaS : TOB;
{$ENDIF}
  
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
    if not YYVentilAna(TOBPiece, TOBRef, Action, ind) then exit;
    if Action <> taConsult then //JT eQualit� 10968
    begin
      // modif BTP 28/04/03 : on demande la repercussion sur toutes les lignes.
      // si oui, on ne contr�le plus la pr�sence d'une ventilation pr�c�dente
      if PgiAsk(TraduireMemoire('Voulez-vous r�percuter la ventilation sur toutes les lignes ?')) = mrYes then
      begin
        for i := 0 to TOBPiece.Detail.Count - 1 do
        begin
          TOBL := TOBPiece.Detail[i];
          if i = 0 then iArt := TOBL.GetNumChamp('GL_ARTICLE');
          if TOBL.GetValeur(iArt) = '' then Continue;
          // if TOBL.FieldExists('OUVREANAL') then if TOBL.GetValue('OUVREANAL')='X' then Continue ;
          // TOBAL:=TOBL.Detail[ind] ; if TOBAL.Detail.Count>0 then Continue ;
{$IFDEF BTP}
					if (LeStock) and (TOBAnaS.detail.count > 0) then
          begin
          	TOBL.detail[1].clearDetail;
            if (OkCptaStock) then LocAnaS := TOBAnaS else LocAnaS := nil;
          	PreVentileLigne(nil, nil, LocAnaS, TOBL)
          end else
          begin
            TOBL.Detail[0].cleardetail;
            TOBL.Detail[1].cleardetail;
            TOBCata := nil;
            TobArt := TOBArticles.FindFirst(['GA_ARTICLE'], [TOBL.GetValeur(iArt)],true);
            if (TOBanaP.detail.count = 0) then
            begin
         			TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBL, TOBArt, TOBTiers, nil, TobAffaire, True,TOBTablette);
              if (TOBC <> nil) and (TOBL.Detail.Count > 0) then
              begin
                if ((TOBL.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
                if ((TOBL.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
                PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBL);
              end;
            end else
            begin
              if (OkCpta) then LocAnaP := TOBAnaP else LocAnaP := nil;
              if (OkCptaStock) then LocAnaS := TOBAnaS else LocAnaS := nil;
            	PreVentileLigne(nil, LocAnaP, LocAnaS, TOBL);
            end;
          end;
{$ELSE}
          if LeStock then PreVentileLigne(nil, nil, TOBAnaS, TOBL) else PreVentileLigne(nil, TOBAnaP, nil, TOBL);
{$ENDIF}
        end;
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
  if (tModeSaisieBordereau in SaContexte) then exit;
  if not BEche.Enabled then Exit;
  if not BEche.Visible then Exit;
  if CtxMode in V_PGI.PGIContexte then Ok := GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, True)
  else Ok := GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPieceRG, Action, DEV, True);
  if Ok then GP_MODEREGLE.Value := TOBPiece.GetValue('GP_MODEREGLE');
  if Ok then
  begin
  	CalculeTimbres (TOBTimbres,TOBpiece,TOBEches);
    GP_TOTALTIMBRES.Value := GetTotalTimbres(TOBTimbres,TOBpiece,TOBEches);
  end;
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
  OKAValider: boolean;
  savcol, savrow: integer;
  {$ENDIF}
  imprimeok: boolean;
  // --
begin
//	Enabled := False;
  TRY
  imprimeok := True;
  {$IFDEF BTP}
	if Not ControleMargeBTP(TOBPiece, True) then Exit;
  GereCalculPieceBTP;
  CalcReglementSituations (TOBPiece.getValue('GP_AFFAIRE'));
  BeforeImprimePieceBtp (self, TOBPiece,SAVcol,SAVrow,ImprimeOk,OkAValider,IMPRESSIONTOB);
  {$ENDIF}
  if imprimeok then ImprimerLaPiece(TOBPiece, TOBTiers, CleDoc, True,false, TobAffaire,IMPRESSIONTOB);
  {$IFDEF BTP}
  if OKAValider then
  begin
  	TRY
    AfterImprimePieceBtp ( self,TOBPiece, TOBNomenclature, TobOuvrage,
                          TOBTiers, TOBAffaire,TOBLigneRg);
    FINALLY
      if Action = TaCreat then
      begin
        Action := TaModif;
        if GetParamSocSecur('SO_METRESEXCEL',true) then
        begin
          TheMetre.action := Action;
        end else
        begin
          // TODO
        end;
      end;
    	if Duplicpiece then Duplicpiece := False;
    END;
  end;
  if (IMPRESSIONTOB = nil) then
  begin
  	GoToLigne(SAvRow, Savcol);
  end else if (not IMPRESSIONTOB.Usable) then
  begin
  	GoToLigne(SAvRow, Savcol);
  end;
  {$ENDIF}
  FINALLY
//  Enabled := True;
//  bringtofront;
  END;
end;

procedure TFFacture.BSousTotalClick(Sender: TObject);
begin
  ClickSousTotal;
end;

procedure TFFacture.MBtarifClick(Sender: TObject);
begin
  {$IFDEF BTP}
  if ReajustePrixDevis (self,TOBTiers,TobLigneTarif,TobTarif,TOBBases,TOBBasesL,TOBPiece,TOBArticles,TOBOuvrage,DEV) then
  begin
//  TOBPiece.PutValue('GP_RECALCULER', 'X');
//  AjusteSousDetail (self,TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire);
//  	CalculeLaSaisie(-1, -1, True);
  end;
  {$ELSE}
  IncidenceTarif;
  {$ENDIF}
end;

procedure TFFacture.MBTarifGroupeClick(Sender: TObject);
begin
  CalculTarifGroupePiece(TobTiers, TobArticles, TobPiece, TobLigneTarif);
  TobPiece.PutValue('GP_RECALCULER', 'X');
  CalculeLaSaisie(-1, -1,True);
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
      if SG_DateLiv > 0 then GS.Cells[SG_DateLiv, i + 1] := DateToStr(DDLiv); // AC
    end;
  end;
  {$IFNDEF BTP}
  GS.ClearSelected;
  {$ELSE}
  CopierColler.deselectionneRows
  {$ENDIF}
end;

procedure TFFacture.MBDatesLivrClick(Sender: TObject);
begin
  MajDatesLivr;
end;

(*
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
*)

(*
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
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
*)

procedure TFFacture.SoldeReliquat;
var TOBL: TOB;
begin
  if not MBSoldeReliquat.Enabled then Exit;
//  if not ReliquatTransfo then Exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then Exit;
  if (CtxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM') = 'GEN') then
    SoldeReliquatArtDim(TobL, GS.Row)
  else
  begin
    if not TOBL.FieldExists('SOLDERELIQUAT') then
      TOBL.AddChampSupValeur('SOLDERELIQUAT', 'X')
    else
      TOBL.DelChampSup('SOLDERELIQUAT', False);
//    { La ligne est issue d'une pi�ce pr�c�dente }
//    if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then
//    begin
//      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
//    end
//    else
//    begin
//      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
//      if not TOBL.FieldExists('SUPPRIME') then
//        TOBL.AddChampSup('SUPPRIME', False);
//      TOBL.PutValue('SUPPRIME', '-');
//    end;
  end;
  GS.InvalidateRow(GS.Row);
end;

procedure TFFacture.SoldeTousReliquat;
var TOBL: TOB;
  i: Integer;
begin
  if not MBSoldeTousReliquat.Enabled then Exit;
  if (Action = taModif) and (not TransfoPiece) then
  begin
    { Confirmation }
    if HPiece.Execute(61, Caption, '') = mrYes then
    begin
      { Solde global des lignes }
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        TOBL := TobPiece.Detail[i];
        if EstLigneArticle(TOBL) then
        begin
          SoldeLigne(TOBL, False);
          GS.InvalidateRow(i + 1);
        end;
      end;
    end;
  end
  else
  begin
    for i := 0 to TOBPiece.Detail.count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      if TOBL = nil then
        Exit;
      if TOBL.FieldExists('SOLDERELIQUAT') then
        TOBL.DelChampSup('SOLDERELIQUAT', False)
      else
        TOBL.AddChampSupValeur('SOLDERELIQUAT', 'X');
      GS.InvalidateRow(i + 1);
    end;
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
//    if TOBL.GetValue('GL_SOLDERELIQUAT') = '-' then
//    begin
//      TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
//    end else
//    begin
//      TOBL.PutValue('GL_SOLDERELIQUAT', '-');
//      if not TOBL.FieldExists('SUPPRIME') then TOBL.AddChampSup('SUPPRIME', False);
//      TOBL.PutValue('SUPPRIME', '-');
//    end;
    if not TOBL.FieldExists('SOLDERELIQUAT') then
      TOBL.AddChampSupValeur('SOLDERELIQUAT', 'X')
    else
      TOBL.DelChampSup('SOLDERELIQUAT', False);
    Inc(i);
    if i > TOBPiece.Detail.count - 1 then exit;
    TOBL := TOBPiece.Detail[i];
  end;
end;

procedure TFFacture.SoldeLigneArtDim(TOBL: Tob; ARow: integer);
var
  i: Integer;
  CodeArt: string;
begin
  if Assigned(TOBL) then
  begin
    CodeArt := TOBL.GetValue('GL_REFARTSAISIE');
    i := ARow - 1;
    while TOBL.GetValue('GL_REFARTSAISIE') = CodeArt do
    begin
      SoldeLigne(TOBL, False);
      AfficheLaLigne(i + 1);
      Inc(i);
      if i > TOBPiece.Detail.count - 1 then
        Exit;
      TOBL := TOBPiece.Detail[i];
    end;
  end;
end;

procedure TFFacture.SoldeLigne(TOBL: Tob; WithMsg: Boolean);
var TOBL1 : TOB;
    Indice : integer;
begin
  if TOBL = nil then
    Exit;
// DBR 07112003  if TOBL.GetValue('GL_PIECEPRECEDENTE') = '' then
  begin
    if not EstLigneSoldee(TOBL) then
    begin
      { Solde de la ligne actuelle }
      if (WithMsg and (HPiece.Execute(58, Caption, '') = mrYes)) or (not WithMsg) then
      begin
        if TOBL.GetValue('GL_TYPELIGNE')<>'CEN' then
        begin
          TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
          TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('GL_QTERESTE'));
          TOBL.PutValue('GL_QTERESTE', 0);
        end else
        begin
          TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
          TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('GL_QTERESTE'));
          TOBL.PutValue('GL_QTERESTE', 0);
          for Indice := TOBL.GetValue('GL_NUMLIGNE') to TOBPiece.detail.count -1 do
          begin
            TOBL1 := TOBpiece.detail[Indice];
            if TOBL1.getValue('GL_LIGNELIEE')<>TOBL.getValue('GL_LIGNELIEE') then break;
            SoldeLigne(TOBL1,false);
          end;
        end;
      end;
    end
    else
    begin
      if TOBL.GetValue('GL_TYPELIGNE')<>'CEN' then
      begin
        { D�solde la ligne actuelle }
        if (WithMsg and (HPiece.Execute(59, Caption, '') = mrYes)) or (not WithMsg) then
        begin
          TOBL.PutValue('GL_SOLDERELIQUAT', '-');
          TOBL.PutValue('GL_QTERESTE', TOBL.GetValue('GL_QTERELIQUAT'));
          TOBL.PutValue('GL_QTERELIQUAT', 0);
        end;
      end else
      begin
        TOBL.PutValue('GL_SOLDERELIQUAT', 'X');
        TOBL.PutValue('GL_QTERELIQUAT', TOBL.GetValue('GL_QTERESTE'));
        TOBL.PutValue('GL_QTERESTE', 0);
        for Indice := TOBL.GetValue('GL_NUMLIGNE') to TOBPiece.detail.count -1 do
        begin
          TOBL1 := TOBpiece.detail[Indice];
          if TOBL1.getValue('GL_LIGNELIEE')<>TOBL.getValue('GL_LIGNELIEE') then break;
          SoldeLigne(TOBL1,false);
        end;
      end;
    end;
  end;
end;

procedure TFFacture.ClickPorcs;
var LastCoef,NewCoef : double;
    TOBPorcsInit : TOB;
    NAction : TActionFiche;
begin
  if IsDejaFacture then
  begin
    NAction := TaConsult;
  end else
  begin
    if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT')  and (not DerniereSituation (TOBpiece)) then
    begin
    	NAction := TaConsult;
    end else
    begin
    	NAction := Action;
    end;
  end;
	lastCoef := TOBPiece.getValue('GP_COEFFR');
  TOBPorcsInit := TOB.create ('SAV PORCS',nil,-1);
  TOBPorcsInit.Dupliquer (TOBPorcs,true,true);
  if (AppelPiedPort(NAction, TOBPiece, TOBPorcs) = True) and (NAction <> taConsult) then
  begin
  // Decution des ports ..du fait qu'ils peuvent etre supprim�s --> on retrouve un montant doc sans les ports youpiii
    AddLesports(TOBpiece,TOBPorcsInit,TOBBases,TOBBasesL,TOBTiers,DEV,Action,'-');
    RecalculPiedPort (Action,TOBpiece,TOBporcs);
    AddLesports(TOBpiece,TOBPorcs,TOBBases,TOBBasesL,TOBtiers,DEV,Action);
  //
  	NewCoef := GetTauxFG (TOBporcs);
    if LastCoef <> newCoef then
    begin
      PutValueDetail (TOBPiece,'GP_RECALCULER','X');
      GereCalculPieceBTP (true);
      AffichePorcs;
    end else
    begin
			if TOBPorcs.isOneModifie then
      begin
        PutValueDetail (TOBPiece,'GP_RECALCULER','X');
        GereCalculPieceBTP (true);
      end;
      TOBPiece.PutEcran(Self, PPied);
      if (SaisieTypeAvanc) then
      begin
        TOBPiece.PutEcran(Self, PPiedAvanc);
      end;
      AfficheTaxes;
      AffichePorcs;
    end;
  end;
end;

procedure TFFacture.BPorcsClick(Sender: TObject);
begin
  if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') and (not DerniereSituation (TOBpiece)) then
  begin
    PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
    exit;
  end;
  if IsDejaFacture then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e.'));
    exit;
  end;
  //
  ClickPorcs;
end;

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
var
  TOBL: TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then
    Exit;
  if (TOBL.GetValue('GL_PIECEPRECEDENTE') = '') or ((Action = taModif) and (not DuplicPiece) and ( not ReliquatTransfo)) then
  begin
    if (CtxMode in V_PGI.PGIContexte) and (TOBL.GetValue('GL_TYPEDIM') = 'GEN') then
      SoldeLigneArtDim(TOBL, GS.Row)
    else
      SoldeLigne(TOBL, True);
    { R�affiche la ligne }
    AfficheLaLigne(TOBL.GetValue('GL_NUMLIGNE'));
    { Etat des boutons sur la ligne }
    GereEnabled(GS.Row);
  end
  else
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
begin
	// gestion des avoirs..
  // MODIF_DBR_DEBUT
  if EstAvoir then
  begin
//    if not AvoirDejaInverse then
//    begin
      InverseAvoir;
//      AvoirDejaInverse := True;
//    end;
  end;
  // MODIF_DBR_FIN

  { NEWPIECE }
//  if GetInfoParPiece (TobPiece_O.GetValue('GP_NATUREPIECEG'),'GPP_RELIQUAT')='X' then
	UpdateResteALivrer(TobPiece, TobPiece_O, TOBArticles, TOBCatalogu, TOBN_O, urSuppr); { NEWPIECE }
  if V_PGI.IoError = oeOk then
  begin
    DetruitLesFormules (TOBPiece_O,TOBLigFormule_O);
    {$IFDEF AFFAIRE}
    DetruitAffaireComplement (TOBFormuleVarQte_O,nil);
    {$ENDIF}
    if not DetruitAncien(TobPiece_O, TobBases_O, TobEches_O, TobN_O, TOBLOT_O, TobAcomptes_O, TobPorcs_O, TobSerie_O, TobOuvrage_O, TobLienOle_O, TobPieceRG_O, TobBasesRg_O, TobLigneTarif_O, True) then
      V_PGI.IoError := oeUnknown;
    {$IFDEF BTP}
    IF V_PGI.IoError = OeOk then DetruitPieceBtp (TOBPiece_O,TobOuvrage_O,TOBPiece, TOBPieceRG, TOBBasesRG, TOBAcomptes, DEV);
    IF V_PGI.IoError = OeOk then TheRepartTva.Delete;
    if GetParamSocSecur('SO_METRESEXCEL',true) then
    begin
    	if V_PGI.IoError = oeOk then TheMetre.Destruct;
    end;
    {$ENDIF}
    // ----
    if V_PGI.IoError = oeOk then InverseStock(TOBPiece_O, TOBArticles, TOBCatalogu, TOBN_O);
    if V_PGI.IoError = oeOk then InverseStockSerie(TOBPiece_O, TOBSerie_O); { NEWPIECE }
    if V_PGI.IoError = oeOk then DetruitCompta(TOBPiece_O,NowH, OldEcr, OldStk);
    if V_PGI.IoError = oeOk then ValideLesArticles(TOBPiece_O, TOBArticles);
    if V_PGI.IoError = oeOk then ValideLesCatalogues(TOBPiece_O, TOBCatalogu);
    if V_PGI.IoError = oeOk then ReactiveEtude(TOBPiece_O);
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
  {$IFDEF BTP}
  if not ControleChantierBTP(TOBPiece, BTTSuppress) then Exit;
  {$ENDIF}
  if CanDeletePiece(TobPiece, TobPiece_O, TransfoPiece, NumL,Action) then
  begin
    if HPiece.Execute(29, caption, '') <> mrYes then Exit;
    if TypeSaisieFrs then
    begin
    	if TypeSaisieFrs then ModeRetourFrs := TmsSuppr;
    	ForcerFerme := True;
      Close;
      exit;
    end;
    if (Action = TaModif) and (Pos(Tobpiece.getValue('GP_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) then
    begin
      EnregistreDocumentASupprimer(TOBpiece);
      ShowInfoLivraisons;
    end;
    if Transactions(DetruitLaPiece, 1) <> oeOk then
    begin
      MessageAlerte(HTitres.Mess[20]);
    end
    else
    begin
      //
      //
      St := 'Pi�ce N� ' + IntToStr(TOBPiece_O.GetValue('GP_NUMERO'))
        + ', Indice ' + IntToStr(TOBPiece_O.GetValue('GP_INDICEG'))
        + ', Date ' + DateToStr(TOBPiece_O.GetValue('GP_DATEPIECE'))
        + ', Tiers ' + TOBPiece_O.GetValue('GP_TIERS')
        + ', Total HT de ' + StrfPoint(TOBPiece_O.GetValue('GP_TOTALHTDEV')) + ' ' + RechDom('TTDEVISETOUTES', TOBPiece_O.GetValue('GP_DEVISE'), False);
      AjouteEvent(TOBPiece_O.GetValue('GP_NATUREPIECEG'), St, 1);
      
      {$IFDEF GPAO}
      if (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
      begin
        if (uOkModifPiece(TobPiece) = true) and (ExistPieceOrigine(TobPiece) = false) then
          PiloteSupprOrdreST(TOBPiece)
        else if (uOkModifPiece(TobPiece) = false) and (ExistPieceOrigine(TobPiece) = true) then
          PiloteDerecOrdreST(TOBPiece);
      end;
      {$ENDIF GPAO}
      
      ForcerFerme := True;
      Close
    end;
  end
  else
  begin
    PgiInfo(TraduireMemoire('Vous ne pouvez pas supprimer cette pi�ce') + #13
      + TraduireMemoire('La ligne n�') + ' ' + IntToStr(1 + NumL) + ' ' + TraduireMemoire('est li�e � d''autres pi�ces')
      , TraduireMemoire('Suppression impossible'));
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
  QQ := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True,-1, '', True);
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

procedure TFFacture.ClickDel(ARow: integer; AvecC, FromUser: Boolean; SupDim: Boolean = False; TraiteDim: Boolean = False; FromParag : boolean=false);
var RefUnique, CodeArticle, RefCata, TypeDim: string;
  bc, cancel: boolean;
  ACol, LaLig, i, OldArow: integer;
  TOBL, TOBCATA: TOB;
  QTE: Double;
  TOBCD  : TOB;
begin
  if Action = taConsult then Exit;
  // AC Fiche 10418
  OldArow := ARow ;
  // Fin AC
  if ((ARow < 1) or (ARow > TOBPiece.Detail.Count)) then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  {$IFDEF BTP}
  if TOBL.GetValue('GL_NATUREPIECEG')='CBT' then
  begin
    if ExisteDocAchatLigne (EncodeRefPiece(TOBL)) then
    begin
  	  PGIInfo ('On ne peut pas supprimer cette ligne d�j� command�e',Caption);
      exit;
    end;
    if TOBL.GetValue('GL_PIECEPRECEDENTE')<>'' then
    begin
  	  PGIInfo ('On ne peut pas supprimer cette ligne rattach�e � une pr�vision',Caption);
      exit;
    end;
  end;
  if existeLienDevCha(TOBPiece, TOBL, self) then exit;
  {$ENDIF}
  {$IFDEF AFFAIRE}
  if not TraiteFormuleVar(ARow, 'SUPPRIME') then exit; //Affaire-Formule des variables
  {$ENDIF}
  GS.beginUpdate;
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
   // -- Ajout LS
  if (Pos(TOBL.getvalue('GL_NATUREPIECEG'),'LBT;BLC')>0) and (TOBL.getValue('BLP_NUMMOUV')<>0) then
  begin
    TOBCD := TOB.Create ('AAA',TOBCONSODEL,-1);
    TOBCD.AddChampSupValeur ('CONSOSUP',TOBL.getValue('BLP_NUMMOUV'));
  end;
 // OPTIMISATION LS
  if BCalculDocAuto.down then
  begin
    DeduitLigneModifie (TOBL,TOBpiece,TOBpieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,DEV, Action);
  end else
  begin
    CacheTotalisations (True);
    EnregistreLigneSupprime (TOBL);
  end;
  PositionneRecalculePourcent (Arow);
  //
  DetruitLot(ARow);
  // Modif BTP
  if GS.IsSelected(Arow) then Deselectionne(Arow);
  if (TOBL.GetValue('GL_TYPEARTICLE') = 'OUV') or (TOBL.GetValue('GL_TYPEARTICLE') = 'ARP') then
  begin
  	PositionneOuvrageOut (TOBPiece,TOBOuvrage,TOBouvragesP,ARow);
  	SuppressionDetailOuvrage(Arow);
  end;
  SupprimeLienDevCha (TOBL,TOBlienDevCha);
  // -----
  DetruitSerie(ARow, Action, GereSerie, TobPiece, TobSerie);
  GS.CacheEdit;
  GS.SynEnabled := False;
{$IFDEF BTP}
  TheRgpBesoin.DeleteDecomposition (ARow);
{$ENDIF}
  GS.DeleteRow(ARow);
  if ((TOBPiece.Detail.Count > 1) and (ARow <> TOBPiece.Detail.Count)) then
  begin
    DeleteTobLigneTarif(TobPiece, ARow - 1);
    //
    DroplesBasesLigne (TOBPiece.Detail[ARow - 1],TOBbasesL);
    //
    TOBPiece.Detail[ARow - 1].Free;
  end
  else
  begin
    DroplesBasesLigne (TOBPiece.Detail[ARow - 1],TOBbasesL);
    TOBPiece.Detail[ARow - 1].InitValeurs;
    InitLesSupLigne(TOBPiece.Detail[ARow - 1]);
    InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, Arow);
  end;
  if (TOBPiece.Detail.Count > 0) then GS.RowHeights[TOBPiece.Detail.Count] := GS.DefaultRowHeight;
  // modif BTP
  if (tModeBlocNotes in SaContexte) then
  begin
    if GS.RowCount < NbRowsInit then GS.RowCount := GS.RowCount + NbRowsPlus;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
//    GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
  end else
  begin
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
  end;
  JustNumerote (TOBPiece,Arow-1);
  if (not FromParag) and (BCalculDocAuto.down) then
  begin
    ToBpiece.putvalue('GP_RECALCULER','X');
    CalculeLaSaisie(-1, -1, false);
    for I := 0 to TOBPiece.detail.count -1 do
    begin
      AfficheLaLigne(I+1);
    end;
  end;
  // --
  GS.EndUpdate;
  GS.MontreEdit;
  GS.SynEnabled := true;
  if (SupDim) and (TypeDim <> 'NOR') then MiseAJourGrid(GS, TOBPiece, Trim(Copy(RefUnique, 1, 18)), QTE, ARow);
//  NumeroteLignesGC(GS, TOBPiece);
  bc := False;
  Cancel := False;
  ACol := GS.fixedcols;
  GSRowEnter(GS, ARow, bc, False);
  GSCellEnter(GS, ACol, ARow, Cancel);
  GS.col := ACol;
  GS.row := Arow;
  StCellCur := GS.cells[Acol,Arow];
  ShowDetail(ARow);
  if ((AvecC) and ((RefUnique <> '') or (RefCata <> '')) and (not TraiteDim)) then
  begin
  (*
    TOBPiece.putValue('GP_RECALCULER', 'X');
    // FIche Qualit� 10133
    // CalculeLaSaisie(-1, -1, False);
    CalculeLaSaisie(-1, Arow, True);
  *)
  end;
  if ((CodeArticle <> '') and (TypeDim = 'GEN') and (FromUser)) then
  begin
    // AC Fiche 10418
    i := OldArow ;
    While i <= TobPiece.Detail.count do
    begin
        TOBL := TOBPiece.Detail[i-1] ;
        if (TOBL <> nil) And (TOBL.GetValue('GL_CODEARTICLE')=CodeArticle) and (TOBL.GetValue('GL_TYPEDIM')='DIM')   then
        begin
          LaLig := TOBL.GetValue('GL_NUMLIGNE');
          ClickDel(LaLig, False, False);
        end else break ;
    end ;
    (*
    // Fin AC
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    // AC 07/08/03 Optimisation saisie dimension
    if (not TraiteDim) then CalculeLaSaisie(-1, -1, False);
    // Fin AC
    *)
  end;
  if DimSaisie = 'DIM' then for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then GS.RowHeights[i + 1] := 0 else GS.RowHeights[i + 1] := GS.DefaultRowHeight;
    end;
  // AC 07/08/03 Optimisation saisie dimension
  if (ctxMode in V_PGI.PGIContexte) and (not TraiteDim) then AffichageDim;
  // Fin AC
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
  if (tModeSaisieBordereau in SaContexte) and (Action <> taConsult) then exit;
{$IFDEF BTP}
	ModifieTexteDebutFin (TOBPiece,TOBLIENOLE,TTtdebut,Action);
{$ELSE}
  InsertComment(True);
{$ENDIF}
end;

procedure TFFacture.TCommentPiedClick(Sender: TObject);
begin
  if (tModeSaisieBordereau in SaContexte) and (Action <> taConsult) then exit;
{$IFDEF BTP}
	ModifieTexteDebutFin (TOBPiece,TOBLIENOLE,TTtFin,action);
{$ELSE}
  InsertComment(False);
{$ENDIF}
end;

procedure TFFacture.TInsLigneClick(Sender: TObject);
begin
  if IsSousDetail ( Dessus(GS.row)) and IsSousDetail(Courante(GS.row)) then
  begin
    ClickInsert(GS.Row,true);
  end else if IsSousDetail ( Dessus(GS.row)) and (not IsSousDetail(Courante(GS.row)))  then
  begin
    DemandeModeInsert;
  end else if ( not IsSousDetail ( Dessus(GS.row))) and (IsSousDetail(Courante(GS.row)))  then
  begin
    ClickInsert(GS.Row,true);
  end else
  begin
    ClickInsert(GS.Row);
  end;
end;

procedure TFFacture.TSupLigneClick(Sender: TObject);
var TypeL : string;
  NivCou, NivDeb,I: integer;
  TobLigne: Tob; { NEWPIECE }
  {$IFDEF BTP}
//  TypeFac: string;
  {$ENDIF}
  {$IFDEF CHR}
  TypeNom: string;
  {$ENDIF} // FIN CHR
  TypePar : string;
  WarningSuppression,Gestionreliquat : boolean;
  TOBL : TOB;
begin
  //
  // pour eviter un groooos plantage
  CopierColler.deselectionneRows;
  //
  TOBL := GetTOBLigne(TOBpiece,GS.row);
  //
  if IsSousDetail ( TOBL) then
  begin
    fModifSousDetail.DelSousDetail(TOBL);
    exit;
  end;

  if (Action = TaModif) and (Pos(TobL.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) and (TOBL.GetValue('BCO_TRAITEVENTE') = 'X' ) then
  begin
  	//PGIInfo (TraduireMemoire ('Attention : Cet article � d�j� �t� livr�.#13#10Les consommations ne seront pas mises � jour.#13#10Veuillez mettre � jour les livraisons de chantiers'),caption);
    receptionModifie := true;
    EnregistreLigneLivAModifier(TOBL,0,0,true,'SUPPR');
  end;
	WarningSuppression := false;
  GestionReliquat := (GetInfoParPiece (TOBPiece.GetValue('GP_NATUREPIECEG'),'GPP_RELIQUAT')='X');

  if (Action <> taConsult) and (VH_GC.GCIfDefCEGID) and // DBR ligne de la NGI intouchable
     (not transfopiece) and (GetChampLigne(TOBPiece, 'GL_REFCOLIS', GS.Row) <> '') then exit;
{$IFDEF BTP}
	if IsLigneReferenceLivr (GetTOBLigne(TOBpiece,GS.row)) then exit;
  if (origineExcel) and (tModeSaisieBordereau in SaContexte) and (Action <> taConsult) then
  begin
  	ReinitLigneBordereau (TOBPiece,TOBOUvrage, GS.row);
    AfficheLaLigne (gs.row);
    StCellCur := GS.Cells[GS.Col, GS.Row];
    exit;
  end;
{$ENDIF}
  if (Action = taConsult) and (GetTOBLigne(TOBPIECE, GS.Row) = nil) then exit; // DBR fiche 10929
  {$IFDEF CHR}
  TypeArt := GetChampLigne(TOBPiece, 'GL_ARTICLE', GS.Row);
  TypeNom := GetChampLigne(TOBPiece, 'GL_TYPENOMENC', GS.Row);
  if (TypeArt <> '') or (TypeNom = 'MAC') then
  begin
    Supp_Commentaire := False;
    exit;
  end else Supp_Commentaire := True;
  {$ENDIF}
  TOBLigne := GetTOBLigne(TOBpiece,GS.row);
  if (TobLigne <> Nil) and (TOBLigne.GetValue('GL_QTEPREVAVANC') <> 0) and (TOBLigne.GetValue('GL_NATUREPIECEG')='DBT') then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e sur cette ligne.'));
    exit;
  end;
  // Modif BTP
  if (IsLigneDetail(TOBPiece, nil, GS.row)) then exit;
//  if BTypeArticle.Visible then BTypeArticle.Visible := false;
	BouttonInVisible;
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
  if TOBLigne.GetValue('MODIFIABLE')='-' then
  begin
    HPiece.Execute(52, Caption, '');
    EXIT;
  end;
  // --
  TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', GS.Row);
  {$IFDEF BTP}
  // En modif. de situation, suppression autoris�e uniquement
  // pour les lignes de commentaires
//  TypeFac := RenvoieTypeFact(TOBPiece.GetValue('GP_AFFAIREDEVIS'));
  if ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'FBT') and (TypeFacturation  = 'AVA')) or
    ((TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAC') and (TypeFacturation  = 'DAC')) then
  begin
    if TypeL <> 'COM' then Exit;
  end;
  {$ENDIF}
//  TypeArt := GetChampLigne(TOBPiece, 'GL_TYPEARTICLE', GS.Row);
//  PiecePrec := GetChampLigne(TOBPiece, 'GL_PIECEPRECEDENTE', GS.Row);
//  if TypeArt = 'NOM' then TenueStock := 'X' else TenueStock := GetChampLigne(TOBPiece, 'GL_TENUESTOCK', GS.Row);
//  if ((TypeL = 'ART') and (PiecePrec <> '') and (TenueStock = 'X')) then
//  begin
//    ReadTokenSt(PiecePrec);
//    OldNat := ReadTokenSt(PiecePrec);
//    ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
//    ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
//    if ((ColPlus <> '') or (ColMoins <> '')) then
//    begin
//      NatAnnul := (GetinfoParPiece(OldNat, 'GPP_NATPIECEANNUL'));
//      if (NatAnnul = '') or (NatAnnul = #0) then SoldeLigneSup(False) else SoldeLigneSup(True);
//      exit;
//    end;
//  end;
  { Interdit la suppression de la ligne si la ligne d'origine est sold�e }
  if not CanModifyLigne(TobLigne, TransfoPiece, TobPiece_O,WarningSuppression,gestionReliquat,Action) then
  begin
    HPiece.Execute(60, Caption, '');
    Exit;
  end;
  if WarningSuppression then
  begin
  	//PGIInfo (TraduireMemoire ('Attention : Cet article � d�j� �t� livr�.#13#10Les consommations ne seront pas mises � jour.#13#10Veuillez mettre � jour les livraisons de chantiers'),caption);
  end;
  // Modif BTP
  // VARIANTE
  (*if ((Copy(TypeL, 1, 2) <> 'DP') and (Copy(TypeL, 1, 2) <> 'TP')) then *)
  if not IsParagraphe (TOBLigne) then
  begin
    ClickDel(GS.Row, True, True, True);
  // VARIANTE
  (* end else if Copy(TypeL, 1, 2) = 'DP' then *)
  end else if IsDebutParagraphe (TOBLigne) then
  begin
    {$IFDEF BTP}
    if not ControleParagSuprimable(self, TobPiece, TOBPiece_O,TOBLienDevCha, GS, GS.row) then exit;
    {$ENDIF}
    if HPiece.Execute(35, caption, '') = mrYes then
    begin
      TypePar := copy (TypeL,2,1);
      NivDeb := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', GS.ROW);
      repeat
        if TypeL <> 'TOT' then ClickDel(GS.Row, True, True, True,false,true) else GS.Row := GS.Row + 1;
        NivCou := GetChampLigne(TOBPiece, 'GL_NIVEAUIMBRIC', GS.Row);
        TypeL := GetChampLigne(TOBPiece, 'GL_TYPELIGNE', GS.Row);
        if TypeL = 'TOT' then NivCou := NivDeb;
      until ((NivCou < NivDeb) or (TypeL = 'T'+TypePar + IntToStr(NivDeb)) or (TOBPiece.Detail.Count <= 0));
      if TypeL = 'T'+TypePar + IntToStr(NivDeb) then ClickDel(GS.Row, True, True, True,false,true);
      // Finalisation
      if BCalculDocAuto.down then
      begin
        ToBpiece.putvalue('GP_RECALCULER','X');
        CalculeLaSaisie(-1, -1, false);
        for I := 0 to TOBPiece.detail.count -1 do
        begin
          AfficheLaLigne(I+1);
        end;
      end;
    end;
  end;
  // --
  if BArborescence.Down = True then BArborescenceClick(Self);
  // --
{$IFDEF BTP}
	BligneModif := True;
{$ENDIF}

  if TypeL = 'TOT' then RecalculeSousTotaux (TobPiece, True); // DBR fiche 10524
end;

procedure TFFacture.ClickInsert(ARow: integer; SousDetail : boolean; ModeInsert : TmodeInsert);
// Modif BTP
var ACol: integer;
  Cancel: boolean;
{$IFDEF BTP}
	TOBL,TOBRef : TOB;
{$ENDIF}
begin
  if Action = taConsult then Exit;

//  if (origineExcel) and (tModeSaisieBordereau in SaContexte) then exit;
  if (tModeSaisieBordereau in SaContexte) then exit;

  if ((ARow < 1) or (ARow > TOBPiece.Detail.Count)) then Exit;
  // Modif BTP
  if (IsLigneDetail(TOBPiece, nil, Arow)) then exit;
	if SousDetail then
  begin
  	TOBL := getTOBLigne(TOBpiece,Arow);
    fModifSousDetail.AddSousDetail(TOBL,ModeInsert);
    exit;
  end;
  //
  {$IFDEF BTP}
  if OrigineEXCEL then exit;
  {$ENDIF}
  // -------

  GS.CacheEdit;
  GS.SynEnabled := False;
  InsertTOBLigne(TOBPiece, ARow);
  // Bug en saisie de pi�ce En commentaire en attendant modif d'Annecy   AC
  //InsertTobLigneTarif(TobLigneTarif, ARow, CleDoc);
  GS.InsertRow(ARow);
  InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
{$IFDEF BTP}
		TOBL := GetTOBLigne(TOBPiece, Arow);
    TheDestinationLiv.SetDestLivrDefaut (TOBL);
    BligneModif := true;
{$ENDIF}
  GS.Row := ARow;
  GS.MontreEdit;
  GS.SynEnabled := True;
  if (tModeBlocNotes in SaContexte) then
  begin
    // Mise � jour de la taille du grid
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
//    GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
    // Positionnement sur la premi�re colonne de saisie possible de la nouvelle ligne
    GS.Col := 1;
    ACol := 0;
    ZoneSuivanteOuOk(ACol, ARow, Cancel);
    GS.Col := ACol;
    GS.Row := ARow;
  end;
  NumeroteLignesGC(GS, TOBPiece);
  ShowDetail(ARow);
  StCellCur := '';
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
{$IFDEF BTP}
  // fiche de bug 10093 -- recharge les modifs de la table dans la tob
  if Action <> taConsult then TOBA.LoadDB;
{$ENDIF}
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
    // mcd 06/10/03 modif 25/02 faite sur vdev tiersutil perdue (lors synchro diffusion ou lors passage Tierutil vers facture ??
    //mcd 25/02/03 mise en tamodif au lieu de taconsult pour permettre la modif tiers lors de la saisie de pi�ce oua ctivit�
    if VenteAchat = 'ACH' then V_PGI.DispatchTT(12, taModif, TOBTiers.GetValue('T_TIERS'), '', '')
    else V_PGI.DispatchTT(8, taModif, TOBTiers.GetValue('T_TIERS'), '', '');
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
	SauveColList;
  ZoomAffaire(GP_AFFAIRE.Text);
  RestoreColList;
end;

procedure TFFacture.BZoomEcritureClick(Sender: TObject);
begin
  ZoomEcriture(False);
end;

procedure TFFacture.CpltEnteteClick(Sender: TObject);
var stComp, ModeRegle_O, Ressource_O: string;
  i: integer;
  {$IFDEF BTP}
  Regimetaxe, Apporteur : string;
  DestLivrFour : integer;
  DateLivr,savdatepiece : TDateTime;
  oldValueGereEnStock, SavAffOkSiZero : string;
  SavModegestionPa : boolean;
  SavModApplicFg,SavModApplicFc : boolean;
  SavRow,SavCol : integer;
  {$ENDIF}
begin
	SavModegestionPa := GereDocEnAchat;
  SavDatePiece := TOBPiece.getValue('GP_DATEPIECE');
  SavModApplicFg := (TOBPiece.getValue('GP_APPLICFGST')='X');
  SavModApplicFC := (TOBPiece.getValue('GP_APPLICFCST')='X');
  SavAffOkSiZero := TOBPiece.getValue('AFF_OKSIZERO');
  ModeRegle_O := TobPiece.GetValue('GP_MODEREGLE');
  Ressource_O := TobPiece.GetValue('GP_RESSOURCE');
  TOBPiece.GetEcran(Self, PEntete);
  TOBPiece.putvalue('ISDEJAFACT',BoolToStr_(IsDejafacture));
  TheTob := TobPiece;
  TobPiece.data := TobAdresses;
  // Modif BTP
  {$IFDEF BTP}
  TOBAdresses.data := TheRepartTva.Tobrepart;
  stComp := '';
  oldValueGereEnStock := TOBPIECE.Getvalue('_GERE_EN_STOCK');
  RegimeTaxe := TOBPIECE.Getvalue('GP_REGIMETAXE');
  OldRepresentant := TOBPIECE.Getvalue('GP_REPRESENTANT');
  Apporteur := TOBPIECE.Getvalue('GP_APPORTEUR');
  DestLivrFour := TOBPIECE.Getvalue('GP_IDENTIFIANTWOT');
  DateLivr := TOBPIECE.Getvalue('GP_DATELIVRAISON');
  if SaisieTypeAffaire then stComp := ';ENTETEAFFAIREPIECE';
  if (TobTiers.GetValue('T_PARTICULIER') = 'X') then stComp := stComp + ';PARTICULIER';
  if (ModifAvanc) and (Action=TaModif) then StComp := stComp + ';MODIFSITUATION';
  {$IFDEF LINE}
  AGLLanceFiche('BTP', 'BTCOMPLPIECE_S1', '', '', ActionToString (Action) + stComp);
  {$ELSE}
  AGLLanceFiche('BTP', 'BTCOMPLPIECE', '', '', ActionToString (Action) + stComp);
  {$ENDIF}

  if (TobAdresses.detail.count > 1) then
  begin
    if GetParamSoc('SO_GCPIECEADRESSE') then
    begin
      LIBELLETIERS.Caption := TOBAdresses.Detail[1].Getvalue('GPA_LIBELLE');
    end
    else
    begin
      LIBELLETIERS.Caption := TOBAdresses.Detail[1].Getvalue('ADR_LIBELLE');
    end;
  end;
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
    if not SaisieTypeAvanc then GereDocEnAchat := TOBPiece.getValue('GP_PIECEENPA')='X';

    ChangeComplEntete := True;
    //
    InclusSTinFG := TOBPiece.GetValue('GP_APPLICFGST')='X';
    //
    TOBPiece.PutEcran(Self, PEntete);
    if ctxAffaire in V_PGI.PGIContexte then TOBPiece.PutEcran(Self, PEnteteAffaire);
    if savdatepiece <> TOBpiece.getValue('GP_DATEPIECE') then
    begin
    	ExitDatePiece;
    end;
    for i := 0 to TobPiece.detail.count - 1 do
    begin
      TobPiece.detail[i].putValue('GL_TIERSLIVRE', TobPiece.getValue('GP_TIERSLIVRE'));
      TobPiece.detail[i].putValue('GL_TIERSFACTURE', TobPiece.getValue('GP_TIERSFACTURE'));
    end;
    // Verif si le mode de r�glement a �t� modifi� dans l'ent�te (affaire uniquement)
    if ctxAffaire in V_PGI.PGIContexte then
    begin
      if (ModeRegle_O <> TobPiece.GetValue('GP_MODEREGLE')) and (TOBEches.Detail.Count > 0) then
        TOBEches.ClearDetail;
    end;
    if Ressource_O <> TobPiece.GetValue('GP_RESSOURCE') then PieceVersLigneRessource(TOBPiece, nil, Ressource_O);
    ChangeComplEntete := False;
    {$IFDEF BTP}
    //
    if TOBPiece.GetValue('_GERE_EN_STOCK') <> oldValueGereEnStock then AppliqueGestionStock(TOBPiece,TOBArticles);
    //
    if TOBPIECE.Getvalue('GP_IDENTIFIANTWOT') <> DestLivrFour then
    begin
      AppliqueDestLivraisonFour (TOBpiece);
    end;
    AppliqueChangementEnteteBtp (self,TheTob,TobPiece,TobOuvrage,TOBporcs,RegimeTaxe,SavModApplicFg,SavModApplicFC);
    if TOBPIECE.Getvalue('GP_DATELIVRAISON') <> DateLivr then
      begin
      AppliqueChangeDate (-1,TOBpiece,TobOuvrage);
      for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
      end;
    if TOBPiece.GetValue('GP_REPRESENTANT') <> OldRepresentant then
    begin
      AjouteRepres(TOBPiece.getValue('GP_REPRESENTANT'), TypeCom, TOBComms);
      BalayeLignesRep;
    end;
    if savAffOKSiZero <> TOBpiece.getValue('AFF_OKSIZERO') then
    begin
    	TOBPiece.SetAllModifie(True);
    end;
//    InclusSTinFG := TOBPiece.GetValue('GP_APPLICFGST')='X';
    if (GereDocEnAchat <> SavModegestionPa ) then
    begin
    	SavRow := GS.row;
    	SavCol := GS.Col;
    	ActiveEventGrille (false);
    	if GereDocEnAchat then
      begin
				PositionneDocAchatBtp (self);
				PositionneColonnesAchatBtp (self);
      end else
      begin
				PositionneDocVenteBtp (self);
				PositionneColonnesVenteBtp (self);
      end;
    	for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
  		CalculeSousTotauxPiece(TOBPiece);
      if GereDocEnAchat then AfficheZonePiedAchat
      									else AfficheZonePiedStd;
      AfficheLaLigne(SavRow);
      GS.row := Savrow;
      GS.col := SavCol;
      StCellCur := GS.Cells [Savcol,SavRow];

    	ActiveEventGrille (true);
      GS.Invalidate;
    end;
    // MODIF Ecriture des ouvrages a plat conditionn�s
    if isEcritureBOP (TOBpiece) then
    begin
    	PutValueDetail (TOBpiece,'GP_RECALCULER','X');
    	CalculeLaSaisie(-1, -1, True);
    end;
    {$ENDIF}
  end;
  TheTob := nil;
  TobPiece.data := nil;
end;

procedure TFFacture.MBDetailNomenClick(Sender: TObject);
var TOBL, TOBNomen, TOBplat: TOB;
  IndiceNomen: integer;
  TypeArticle: string;
  {$IFDEF BTP}
  Addicted: boolean;
  {$ENDIF}
  // -----
begin
	TOBL := GetTOBLigne(TOBpiece,GS.row);
  if TOBL = nil then Exit;
  if (IsSousDetail (TOBL)) then exit;
  {$IFDEF BTP}
  if Not JaiLeDroitConcept(TConcept(bt112),True) then Exit; //confidentialit� , concept acces sous-d�tail
  addicted := false;
  {$ENDIF}
  TypeArticle := TOBL.GetValue('GL_TYPEARTICLE');
  {$IFDEF BTP}
  if (TypeArticle = 'MAR') or (TypeArticle = 'PRE') or ((TypeArticle = 'ARP') and (TOBL.GetValue('GL_INDICENOMEN') = 0)) then
  begin
    AjouteSousDetail(TOBL, TOBOuvrage, TOBArticles);
    addicted := true;
  end;
  {$ENDIF}
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
    TOBPLat := FindOuvragesPlat (TOBL,TOBOuvragesP);
    if TOBPlat = nil then
    begin
      TOBPlat := AddMereLignePlat (TOBOuvragesP,TOBL.GetValue('GL_NUMORDRE'));
    end;
    GetOuvragePlat (TOBpiece,TOBL,TOBOuvrage,TOBPlat,TOBTiers,DEV);
    //
    MBDetailNomenClickBtp (Self,IndiceNomen,TOBaffaire,TobPiece,TobOuvrage,TobArticles,TOBBases,TOBBasesL,TOBL,TheRepartTva.Tobrepart,addicted,DEV,GereDocEnAchat,fPieceCoTrait.InUse);
  	CalculheureTot (TOBL);
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
  IndicePv: Integer;
  AncAffaire: string;
  AncModliv : integer;
  EnHt: boolean;
  SuiteAction : string;
  {$ENDIF}
  sFonctionnalite: string;
  TobArticle: tob;
  TobLigneAvantModif: tob;
  TobLigneApresModif: tob;
  nRemiseLibre, nRemiseSysteme: double;
  TOBLO,TOBL : TOB;
  IDep ,Ifin ,IInd: integer;
begin
	TOBL := GetTOBLigne(TOBpiece,GS.row);
	TOBLO := TOB.Create ('LIGNE',nil,-1);
	AddLesSupLigne (TOBLO,false);

	SuiteAction := '';
  if (IsLigneDetail(TOBPiece, nil, GS.row)) then exit;
  if (IsSousDetail (TOBL)) then exit;

  if (GetParamSoc('SO_PREFSYSTTARIF')) then
  begin
    TobLigneAvantModif := GetTOBLigne(TOBPiece, GS.Row);
    TobLigneAvantModif.AddChampSupValeur('REMISETOTALSYSTEME', CalculRemiseTotaleSurTobLigneTarif(TobLigneAvantModif, TobLigneTarif, '16'), false);
    TobLigneAvantModif.AddChampSupValeur('ANNULEREMISESYSTEME', False, false);
    TheTOB := TobLigneAvantModif;
  end
  else
    TheTOB := GetTOBLigne(TOBPiece, GS.Row);
  if TheTOB = nil then exit; // JT eQualit� 10974
  // Modif Btp
  {$IFDEF BTP}

  TOBLO.Dupliquer (TheTOB,false,true); // sauvegarge
  (*
  AncApplicfrais := TheTob.GetValue('GLC_NONAPPLICFRAIS');
  AncApplicfC := TheTob.GetValue('GLC_NONAPPLICFC');
  ancCodeTva1 := TheTob.getValue('GL_FAMILLETAXE1');
  ancCodeTva2 := TheTob.getValue('GL_FAMILLETAXE2');
  ancCodeTva3 := TheTob.getValue('GL_FAMILLETAXE3');
  ancCodeTva4 := TheTob.getValue('GL_FAMILLETAXE4');
  ancCodeTva5 := TheTob.getValue('GL_FAMILLETAXE5');
//  if (TheTOB.GetValue('GL_TYPEARTICLE') = 'OUV') or (TheTob.getValue('GL_TYPEARTICLE') = 'ARP') then TheTob.PutValue('GL_FAMILLETAXE1', '');
  ancqte := TheTob.getValue('GL_QTEFACT');
  AncDate := TheTOB.GetValue('GL_DATELIVRAISON');
  StDepot := TheTOB.GetValue('GL_DEPOT');
  *)
  
  // modif brl pour FQ12414 : la ligne ci-dessous �tait au milieu des lignes au dessus en commentaires
  AncAffaire := TheTob.getValue('GL_AFFAIRE');
  EnHT := (TOBPiece.GetValue('GP_FACTUREHT') = 'X');
  if EnHt then IndicePv := TheTob.GetNumChamp('GL_PUHTDEV')
  else IndicePv := TheTob.GetNumChamp('GL_PUTTCDEV');
  AncModliv := TheTOB.GetValue('GL_IDENTIFIANTWOL');
  TheTOB.data := TheRepartTva.Tobrepart;
  if ModifAvanc then SuiteAction := 'ACTION=CONSULTATION;CONSULTPRIX'
  						  else SuiteAction := ActionToString(Action);
{$IFDEF LINE}
  AGLLanceFiche('BTP', 'BTCOMPLLIGNE_S1', '', '', SuiteAction);
{$ELSE}
  AGLLanceFiche('BTP', 'BTCOMPLLIGNE', '', '', SuiteAction);
{$ENDIF}
  {$ELSE}
  stArg := ActionToString(Action);
  if VH_GC.GCIfDefCEGID then
    if sender = nil then stArg := stArg + ';FORCEINFO';
  if (ctxAffaire in V_PGI.PGIContexte) or (SaisieTypeAffaire) then
  begin
    if bSaisieNatAffaire then
      stArg := stArg + ';GENERAUTO=' + TobAffaire.getValue('AFF_GENERAUTO');
    if sender = nil then stArg := stArg + ';FORMULEVAR'; //Affaire-Formule des variables
    AGLLanceFiche('AFF', 'AFCOMPLLIGNE', '', '', stArg)
  end
  else
  begin
    if TheTob <> nil then
    begin
      stDepot := TheTob.GetValue ('GL_DEPOT');
    end;
    AGLLanceFiche('GC', 'GCCOMPLLIGNE', '', '', stArg);
    if TheTob <> nil then
    begin
      if stDepot <> TheTob.GetValue ('GL_DEPOT') then
      begin
        ChargeNouveauDepot(nil, TheTob, TheTob.GetValue ('GL_DEPOT'));
      end;
    end;
  end;
  {$ENDIF}

  if (GetParamSoc('SO_PREFSYSTTARIF')) then
  begin
    TobLigneApresModif := TheTob;
    if ((TobLigneApresModif <> nil) and (Action <> taConsult)) then
    begin

      { En sortie de compl�ment ligne lancement de la recherche tarifaire }
      { En sortie de compl�ment ligne lancement de la recherche des commissions }
      if (TobLigneApresModif.GetValue('RECALCULTARIF') = 'X') or (TobLigneApresModif.GetValue('RECALCULCOMM') = 'X') then
      begin
        TobArticle := FindTobArtRow(TOBPiece, TOBArticles, GS.Row);
        RechercheTarifsCommissions('LIGNE', Action, TobTiers, TobArticle, TobPiece, TobLigneApresModif, TobLigneTarif, TobTarif, DEV);
        AfficheLaLigne(GS.Row);
        TobPiece.PutValue('GP_TARIFSGROUPES', 'X');
      end;

      { En sortie de compl�ment ligne recalculer la valeur H.T. de la ligne et tout le reste ... }
      if (TobLigneApresModif.GetValue('RECALCULTARIF') = 'X') or (TobLigneApresModif.GetValue('GL_RECALCULER') = 'X') then
      begin
        { Mise � Jour de la TobLigne Tarif }
        sFonctionnalite := RechercheFonctionnalite(TobLigneApresModif.GetValue('GL_NATUREPIECEG'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1200', 'COUTLANCEMENT', TobLigneApresModif.GetValue('GL_VALEURFIXEDEV'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1300', 'REMISEMONTANT', TobLigneApresModif.GetValue('GL_VALEURREMDEV'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1400', 'PRIXBRUT'     , TobLigneApresModif.GetValue('GL_PUHTDEV'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1501', 'REMISELIBRE1' , TobLigneApresModif.GetValue('GL_REMISELIBRE1'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1502', 'REMISELIBRE2' , TobLigneApresModif.GetValue('GL_REMISELIBRE2'));
        MajTobLigneTarifFromTobLigne(TobLigneApresModif, TobLigneTarif, sFonctionnalite, '1503', 'REMISELIBRE3' , TobLigneApresModif.GetValue('GL_REMISELIBRE3'));

        { Calcul de la remise totale de la ligne }
        nRemiseLibre := CalculRemiseTotaleSurTobLigneTarif(TobLigneApresModif, TobLigneTarif, '15');
        nRemiseSysteme := CalculRemiseTotaleSurTobLigneTarif(TobLigneApresModif, TobLigneTarif, '16');
        TobLigneApresModif.PutValue('GL_REMISELIGNE', (1 - (1 - nRemiseLibre / 100) * (1 - nRemiseSysteme / 100)) * 100);

        TobPiece.PutValue('GP_RECALCULER', 'X');
        CalculeLaSaisie(-1, GS.Row, False);
      end;

      TobLigneApresModif.PutLigneGrid(GS, GS.Row, False, False, LesColonnes);
    end;
  end;

  if ((TheTob <> nil) and (Action <> taConsult)) then
  begin
//    TheTOB.PutLigneGrid(GS, GS.Row, False, False, LesColonnes);
    {$IFDEF BTP}
    CpltLigneClickBtp (self,IndicePv,TOBLO,TheTob,TOBArticles,TOBCatalogu, TOBOuvrage,TOBTiers,TOBPiece,TheRepartTva.Tobrepart,TOBCpta ,TOBAnaP);
    // gestion du changement du mode de livraison
(*
    if (TheTob.GetValue('GL_IDENTIFIANTWOL') <> AncModliv) and
    	 (Pos(TheTob.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) then
    begin
    	if TheTob.GetValue('GL_IDENTIFIANTWOL') = 0 then
      begin
      	// livraison sur chantier enlev�e
        EnregistreLigneLivASupprimer (TheTob);
      end else
      begin
      	// livraison sur chantier positionn�e
        EnregistreLigneLivACreer (TheTob);
      end;
    end;
*)
	  // Modification de l'affaire sur la ligne : maj pour compta analytique
    if (TheTob.GetValue('GL_AFFAIRE') <> AncAffaire) and OkCpta then
    begin
    	TheTOB.detail[0].clearDetail;
     	TheTOB.detail[1].clearDetail;
      //
	    MajAnaAffaire(TOBPiece, TOBCataLogu, TOBArticles, TOBCpta, TOBTiers, TOBAnaP, GS.Row);
      if (Action = TaModif) and (Pos(TheTOB.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) and (TheTOB.GetValue('BCO_TRAITEVENTE') = 'X' ) then
      begin
        //PGIInfo (TraduireMemoire ('Attention : Cet article � d�j� �t� livr�.#13#10Les consommations ne seront pas mises � jour.#13#10Veuillez mettre � jour les livraisons de chantiers'),caption);
        receptionModifie := true;
        EnregistreLigneLivAModifier(TheTOB,0,0);
      end else if (Action = TaModif) and (Pos(TheTOB.getValue('GL_NATUREPIECEG'),GetPieceAchat (false,false,false,True))>0) and (TheTOB.GetValue('NEW_LIGNE') = 'X' ) then
      begin
        EnregistreLigneLivAModifier(TheTOB,0,0);
      end;
   	end;
    {$ENDIF}
    if ((ctxAffaire in V_PGI.PGIContexte) or (SaisieTypeAffaire)) and (TOBPiece.GetString ('GP_RECALCULER')='X') then
    begin
//      TheTob.PutValue('GL_RECALCULER', 'X');
//      TobPiece.PutValue('GP_RECALCULER', 'X');
      if IsDebutParagraphe(TheTOB) then
      begin
      	CalculeLaSaisie(-1, -1, False);
      end else
      begin
      	CalculeLaSaisie(-1, GS.Row, False);
      end;
    end;
    ShowDetail(GS.Row);
  end;
  TheTob := nil;
  FreeAndNil (TOBLO);
end;

procedure TFFacture.AdrLivClick(Sender: TObject);
begin
  EntreeAdressePiece(TobPiece, TobAdresses, 0);
end;

procedure TFFacture.AdrFacClick(Sender: TObject);
begin
  EntreeAdressePiece(TobPiece, TobAdresses, 1);
end;

procedure TFFacture.MBTarifVisuOrigineClick(Sender: TObject);
var
  TobUneLigneTarifFille, TheTob, TobUneLigneTarif, TobLigne, TobContexte: Tob;
  sFonctionnalite: string;
  iCpt: Integer;
begin
  { TobLigne sur les pi�ces }
  TobLigne := GetTOBLigne(TOBPiece, GS.Row);

  sFonctionnalite := RechercheFonctionnalite(TobLigne.GetValue('GL_NATUREPIECEG'));

  { TobLigne sur les tarifs }
  TobUneLigneTarif := Tob.Create('_TobUneLigneTarifMere_', nil, -1);
  TheTob := GetLigneTarif(TobLigneTarif, TobLigne);
  if Assigned(TheTob) then
  begin
    for iCpt := 0 to TheTob.Detail.Count - 1 do
    begin
      if TheTob.Detail[iCpt].GetValue('GLT_FONCTIONNALITE') = sFonctionnalite then
      begin
        TobUneLigneTarifFille := Tob.Create('_TobUneLigneTarifFille_', TobUneLigneTarif, -1);
        TobUneLigneTarifFille.Dupliquer(TheTob.Detail[icpt], False, True);
      end;
    end;
  end;

  if TobUneLigneTarif <> nil then
  begin
    { Contexte de calcul }
    TobContexte := Tob.Create('_TobContexte_', nil, -1);

    try
      GetTobContexteFromPiece(sFonctionnalite, '1', TobContexte, TobPiece, TobLigne);
      ConsultationTarifsRecherche(sFonctionnalite, '1', TobUneLigneTarif, TobContexte);
    finally
      TobContexte.Free;
    end;
  end
  else
    ShowMessage(TraduireMemoire('Impossible d''acc�der � l''origine du tarif'));

  TobUneLigneTarif.Free;
end;
(*
procedure TFFacture.MBCommissionVisuOrigineClick(Sender: TObject);
var
  TobUneLigneTarifFille, TheTob, TobUneLigneTarif, TobLigne, TobContexte: Tob;
  sFonctionnalite: string;
  iCpt: integer;
begin
  { TobLigne sur les pi�ces }
  TobLigne := GetTOBLigne(TOBPiece, GS.Row);

  sFonctionnalite := '202';

  { TobLigne sur les tarifs }
  TobUneLigneTarif := Tob.Create('_TobUneLigneTarifMere_', nil, -1);
  TheTob := GetLigneTarif(TobLigneTarif, TobLigne);
  if Assigned(TheTob) then
  begin
    for iCpt := 0 to TheTob.Detail.Count - 1 do
    begin
      if ((TheTob.Detail[iCpt].GetValue('GLT_FONCTIONNALITE') = sFonctionnalite)
        and (Int(TheTob.Detail[iCpt].GetValue('GLT_RANG') / 1000) = 2)
        ) then
      begin
        TobUneLigneTarifFille := Tob.Create('_TobUneLigneTarifFille_', TobUneLigneTarif, -1);
        TobUneLigneTarifFille.Dupliquer(TheTob.Detail[icpt], False, True);
      end;
    end;
  end;

  if TobUneLigneTarif <> nil then
  begin
    { Contexte de calcul }
    TobContexte := Tob.Create('_TobContexte_', nil, -1);

    try
      GetTobContexteFromPiece(sFonctionnalite, '2', TobContexte, TobPiece, TobLigne);
      ConsultationTarifsRecherche(sFonctionnalite, '2', TobUneLigneTarif, TobContexte);
    finally
      TobContexte.Free;
    end;
  end
  else
    ShowMessage(TraduireMemoire('Impossible d''acc�der � l''origine du commissionnement'));

  TobUneLigneTarif.Free;
end;
*)

procedure TFFacture.OnGetVar(Sender: TObject; VarName: string; VarIndx: Integer; var Value: variant);
var T: TOB;
  NumPiece, NumRang : string;
  Q: TQuery;
begin
  value := '';
  if VarName = 'NBL' then Value := TOBPiece.Detail.Count
  else if VarName = 'GP_BLOCNOTE' then
  begin
    BlobToFile(VarName, TOBPiece.GetValue(VarName));
    Value := '';
  end else //PCS
    if Pos('AFT_', VarName) > 0 then
    begin
      // chargement intervenants de type tiers de l'affaire
      NumRang := Copy (VarName,10,1);
      Q := OpenSQL ('SELECT AFT_LIBELLE FROM AFFTIERS WHERE AFT_AFFAIRE="' + TOBPiece.GetValue('GP_AFFAIRE') + '" AND AFT_RANG=' + NumRang, True,-1, '', True) ;
      if not Q.EOF then
        Value := Q.Fields[0].AsString;
      Ferme (Q) ;
    end else
    if Pos('INT_', VarName) > 0 then
    begin
      // chargement de l'adresse d'intervention de l'affaire
      Q := OpenSQL ('SELECT ADR_' + Copy(VarName, 5, length(VarName)-4) + ' FROM ADRESSES WHERE ADR_REFCODE="' + TOBPiece.GetValue('GP_AFFAIRE') + '" AND ADR_NADRESSE=1 AND ADR_TYPEADRESSE="INT"', True,-1, '', True) ;
      if not Q.EOF then
        Value := Q.Fields[0].AsString;
      Ferme (Q) ;
    end else
    if Pos('T_', VarName) > 0 then Value := TOBTiers.GetValue(VarName) else // Paul
    if Pos('GP_', VarName) > 0 then Value := TOBPiece.GetValue(VarName) else
    if VarName = 'AFF_DESCRIPTIF' then
       begin
       BlobToFile(VarName, TOBAffaire.GetValue(VarName));
       Value := '';
       end
    else if Pos('AFF_', VarName) > 0 then Value := TOBAffaire.GetValue(VarName) else
    if VarName = 'GL_BLOCNOTE' then
    begin
      BlobToFile(VarName, TOBPiece.Detail[VarIndx - 1].GetValue(VarName));
      Value := '';
    end else
    if VarName = 'TEXTEDEBUT' then
    begin
      Numpiece := TOBPiece.GetValue('GP_NATUREPIECEG') + ':' + TOBPiece.GetValue('GP_SOUCHE') + ':' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ':' +
                  IntToStr(TOBPiece.GetValue('GP_INDICEG'));
      T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', Numpiece, 1], false);
      if T <> Nil then BlobToFile(VarName, T.GetValue('LO_OBJET'));
      
      Value := '';
    end else
    if VarName = 'TEXTEFIN' then
    begin
      Numpiece := TOBPiece.GetValue('GP_NATUREPIECEG') + ':' + TOBPiece.GetValue('GP_SOUCHE') + ':' + IntToStr(TOBPiece.GetValue('GP_NUMERO')) + ':' +
                  IntToStr(TOBPiece.GetValue('GP_INDICEG'));
      T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'], ['GP', Numpiece, 2], false);
      if T <> Nil then BlobToFile(VarName, T.GetValue('LO_OBJET'));
      Value := '';
  end else if (VarIndx > 0) then
  begin
    Value := TOBPiece.Detail[VarIndx - 1].GetValue(VarName); //PCS
  end
  else Value := '';
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
  {Tests pr�liminaires}
  Okok := True;
  if ((not BOffice.Visible) or (not BOffice.Enabled)) then Exit;

  if PGIAsk(TraduireMemoire('Confirmez-vous le lancement ?'), TraduireMemoire('Liaison Bureautique')) <> mrYes then Exit;
//  stModele := GetParamSoc('SO_GCMODELEWORD');
//  stModele := GetInfoParPieceCompl(TOBPiece.GetValue('GP_NATUREPIECEG'), TOBPiece.GetValue('GP_ETABLISSEMENT'), 'GPC_MAQUETTEDOC');
  stModele := GetInfoParPieceCompl(TOBPiece.GetValue('GP_NATUREPIECEG'), TOBPiece.GetValue('GP_ETABLISSEMENT'), 'GPC_MODELEWORD');
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
procedure TFFacture.EnleveRefPieceprec(TOBPiece : TOB);
var Indice : integer;
begin
  for Indice := 0 to TOBPiece.detail.count -1 do
  begin
    TOBPiece.detail[Indice].putValue('GL_PIECEPRECEDENTE','');
  end;
end;

function TFFacture.ChargeAffairePiece(TestCle, RepriseTiers: Boolean; ChargeLigne: boolean = True): Integer;
{$IFDEF BTP}
var P0       : String;
    P1       : String;
    P2       : String;
    P3       : String;
    Avn      : String;
    Numpiece : string;
    T : TOB;
    LocAnaP,LocAnaS : TOB;
{$ENDIF}
{$IFDEF AFFAIRE}
var ExitPossible: Boolean;
  EvtCourant: string;
  dDateDebItv, dDateFinItv: TDateTime;
  Indice : integer;
  TOBC,TOBArt : TOB;
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
    if (VenteAchat = 'ACH') and ((ctxTempo in V_PGI.PGIContexte) or (ctxBTP in V_PGI.PGIContexte)) then AFF_TIERS.Text := '';
  end;

  AutoCodeAff := False;
  // on d�branche les �v�nements onchange des parties du code affaire pendant cette fonction
  Result := ChargeAffaire(GP_AFFAIRE, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, AFF_TIERS, GP_AFFAIRE0, Testcle, Action, TobAffaire, nil, True, False, False);
//  AutoCodeAff := True;
  // Contr�le des blocages sur affaires
  if (Result = 1) and not (GeneCharge) and not (SaisieTypeAffaire) then
  begin
    if (VenteAchat = 'ACH') then EvtCourant := 'SAH' else EvtCourant := 'FAC';
    if (BlocageAffaire(EvtCourant, TobAffaire.GetValue('AFF_AFFAIRE'), V_PGI.Groupe, StrTodate(GP_DATEPIECE.Text), True, True, False, dDateDebItv, dDateFinItv,
      nil) <> tbaAucun) then
      Result := 0;
  end;

  if (result = 1) and (not ControleSaisiePieceBtp (Tobpiece,GP_AFFAIRE.Text,Action,TransfoPiece,DuplicPiece)) then
  begin
  	result := 0;
  end;

  if (Result = 1) then
  begin
    LibelleAffaire.Caption := TOBAffaire.GetValue('AFF_LIBELLE');
    if (Action = taCreat) or (DuplicPiece) then // mcd 23/04/02 ajout duplicpiece
    begin
      // Reprise du tiers uniquement en vente
      IncidenceAffaire;
      if ((ctxAffaire in V_PGI.PGIContexte) and (VenteAchat = 'VEN') and (ChargeLigne)) then IncidenceLignesAffaire;
      AffaireVersAdresses(TOBAffaire,TOBAdresses,TOBPiece); //mcd 29/09/03 d�plac� pour r�soudre cas clt fact # ds affaire et adresse fact
{$IFDEF BTP}
			if (VenteAchat = 'VEN') and (not DuplicPiece) then
      begin
        LivAffaireVersAdresses (TOBAffaire,TOBAdresses,TOBPiece);
      end;
{$ENDIF}
    end;
    if SaisieTypeAffaire then
    begin
// A verifier
      if GP_AFFAIRE0.text = 'W' then
         Begin
           P0 := GP_AFFAIRE0.text;
	      	 CodeAppelDecoupe(GP_AFFAIRE.text,P0, P1, P2, P3, Avn);
      	   GP_AFFAIRE1.Text := P1;
    	     GP_AFFAIRE2.Text := P2;
  	       GP_AFFAIRE3.Text := P3;
	         GP_AVENANT.Text := Avn;
         end
      else
    	ChargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, nil, taConsult, GP_AFFAIRE.Text, False);
    end
    else  //Mod�le d'�tat par affaire
      ChargeExceptionDocAffaire (CleDoc.NaturePiece,TOBAffaire);

    // mise � jour des lignes sur la nouvelle affaire
    if not (GeneCharge) then
    begin
    	if (DomaineSoc = '') and (TOBAffaire.GetValue('AFF_DOMAINE')<>'') then
      begin
        PutValueDetail(TOBPiece, 'GP_DOMAINE', TOBAffaire.GetValue('AFF_DOMAINE'),TOBArticles);
        PutValueDetailouv(TOBOUvrage, 'BLO_DOMAINE', TOBAffaire.GetValue('AFF_DOMAINE'),TOBArticles);
        GP_DOMAINE.Value :=TOBAffaire.GetValue('AFF_DOMAINE');
        PutValueDetail(TOBPiece,'GP_RECALCULER','X');
      end;
      //
      PutValueDetail(TOBPiece, 'GP_AFFAIRE', GP_AFFAIRE.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE1', GP_AFFAIRE1.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE2', GP_AFFAIRE2.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE3', GP_AFFAIRE3.Text);
      PutValueDetail(TOBPiece, 'GP_AVENANT', GP_AVENANT.Text);
      SetAffaireSousDetail (TOBPiece,TOBOUvrage);
    end else
    begin
    	if (DomaineSoc = '') and (TOBAffaire.GetValue('AFF_DOMAINE')<>'') then
      begin
    		TOBPiece.PutValue('GP_DOMAINE', TOBAffaire.GetValue('AFF_DOMAINE'));
    		GP_DOMAINE.Value := TOBAffaire.GetValue('AFF_DOMAINE');
    		if not DuplicPiece then GP_DOMAINE.enabled := false;
      end;
    end;
    // OPTIMISATIONS LS
    StockeCetteAffaire (TOBaffaire);
    // ----
    // Correction FQ 15334
    // ------
    if (copy(GP_AFFAIRE.Text,1,1)='I') and (VenteAchat = 'VEN') then
    begin
    	TOBPiece.putValue('GP_GENERAUTO','CON');
    end;

    // ---
		// Modif BRL 28/02
    // Pour remettre � jour les pr�ventilations analytiques si modif de l'affaire
    if (not geneCharge) then
    begin
      for Indice := 0 to TOBPiece.detail.count -1 do
      begin
        T := TOBPiece.detail[Indice];
        TobArt := TOBArticles.FindFirst(['GA_ARTICLE'],[T.GetValue('GL_ARTICLE')], False);
        if TOBArt= nil then continue;
        if ((OkCpta) or (OkCptaStock)) then
        begin
         T.Detail[0].cleardetail;
         T.Detail[1].cleardetail;
         TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, T, TOBArt, TOBTiers, nil, TobAffaire, True,TOBTablette);
         if (TOBC <> nil) and (T.Detail.Count > 0) then
         begin
           if ((T.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
           if ((T.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
           PreVentileLigne(TOBC, LocAnaP, LocAnaS, T);
         end;
        end;
      end;
    end;
    // Fin modif BRL ---
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
      GP_DOMAINE.Value := '';
      ClearAffaire(TOBPiece);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE', GP_AFFAIRE.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE1', GP_AFFAIRE1.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE2', GP_AFFAIRE2.Text);
      PutValueDetail(TOBPiece, 'GP_AFFAIRE3', GP_AFFAIRE3.Text);
      PutValueDetail(TOBPiece, 'GP_AVENANT', GP_AVENANT.Text);
        PutValueDetail(TOBPiece, 'GP_DOMAINE', TOBAffaire.GetValue('AFF_DOMAINE'),TOBArticles);
      TOBAffaire.InitValeurs(False);
    end;
  end
  else
    LibelleAffaire.Caption := '';
  {$ENDIF}

  //chargement du descriptif de l'affaire dans le cas d'un Appel
  //Modifi� le 18 juin 2007 par FV
  if GP_AFFAIRE0.text = 'W' then
     Begin
     Numpiece := Cledoc.NaturePiece + ':' + Cledoc.Souche + ':' + IntToStr(Cledoc.NumeroPiece) + ':' + IntToStr(Cledoc.indice);
     T := TOBLIENOLE.FindFirst(['LO_TABLEBLOB', 'LO_IDENTIFIANT', 'LO_RANGBLOB'],
                               ['GP', NumPiece, '1'], false);
     if T = nil then
        Begin
        T := TOB.Create ('LIENSOLE',TOBLIENOLE,-1);
        T.PutValue('LO_TABLEBLOB', 'GP');
        T.PutValue('LO_QUALIFIANTBLOB', 'MEM');
        T.PutValue('LO_EMPLOIBLOB', '');
        T.PutValue('LO_IDENTIFIANT', Numpiece);
        T.PutValue('LO_RANGBLOB', 1);
        T.PutValue('LO_LIBELLE', '');
        T.PutValue('LO_PRIVE', '-');
        T.PutValue('LO_DATEBLOB', now);
        T.PutValue('LO_OBJET', TobAffaire.GetValue('AFF_DESCRIPTIF'));
        End;
     End;

end;

procedure TFFacture.IncidenceLignesAffaire;
var TobPieceAffaire, TOBPorcsPieceAff, TobP, TobDet, TobDetAffaire, TOBC, TOBA, TOBCata: TOB;
  LocAnaP, LocAnaS: TOB;
  i: integer;
  Q: TQuery;
  numdoc : String;
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

  //  Champs personnalisable dans l'ent�te de pi�ce associ�e � l'affaire
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
    //mcd 21/08/03 ?? remise pas g�r�e comme escompte ...
  GP_REMISEPIED.Value := TobPieceAffaire.GetValue('GP_REMISEPIED');
  PutValueDetail(TOBPiece, 'GP_REMISEPIED', GP_REMISEPIED.Value);

  // gm le 10/01/03
  // r�alignement de l'adresse de Facturation, si le client � facturer de l'affaire
  // est diff�rent de celui du client
     ////mcd 04/03/03 if (TobPieceAffaire.GetValue('GP_TIERSFACTURE') <> TobTiers.GetValue('T_FACTURE'))then
  if (TiersAuxiliaire(TobPieceAffaire.GetValue('GP_TIERSFACTURE'), False) <> TobTiers.GetValue('T_FACTURE')) then
    TiersVersAdresses(TOBTiers, TOBAdresses, TOBPiece, TobPieceAffaire.GetValue('GP_TIERSFACTURE'));

  // non reprise des �l�ments si la pi�ce poss�de d�j� des lignes
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
      Q := OpenSQL('SELECT * FROM PIEDPORT WHERE ' + WherePiece(TOB2CleDoc(TobPieceAffaire), ttdPorc, False), True,-1, '', True);
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
  // Reprise des lignes de la pi�ce associ�e � l'affaire
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
    // gm le 18/11/2003  pour ne pas avoir de soucis avec ces qt�s non g�r�e dans les affaires
    TobDet.putValue('GL_QTERESTE',TobDet.GetValue('GL_QTEFACT'));
    TobDet.putValue('GL_QTESTOCK',TobDet.GetValue('GL_QTEFACT'));
  end;
  // gm 23/09/2003 pour reprise de l'ana saisie sur ligne d'affaire
  LoadLesAna(TobPieceAffaire, TOBAnaP, TOBAnaS);
  Numdoc := EncodeRefPiece(TOBPIECE);
  UG_MajAnalPiece ( TobAnaP,TOBAnaS ,Numdoc ) ;
  for i:=0 to TOBPiece.detail.Count-1 do
  begin
    TobDet :=  TOBPiece.detail[i];
    UG_LoadAnaLigne ( TobPieceAffaire,TOBDet ) ;
    UG_MajAnalLigne(TOBDet,Numdoc) ;
  end;

  CleDocAffaire := Tob2cleDoc(TobPieceAffaire);  // gm 01/07/03
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
    // VARIANTE
    (* if (TobDet.GetValue('GL_TYPELIGNE') = 'COM') or (TobDet.GetValue('GL_TYPELIGNE') = 'TOT') then continue;*)
    if (isVariante(TOBDet)) or (IsCommentaire (TOBDet)) or (TobDet.GetValue('GL_TYPELIGNE') = 'TOT') then continue;
    TOBC := ChargeAjouteCompta(TOBCpta, TOBPiece, TOBDet, TOBA, TOBTiers, TOBCata, TobAffaire, True,TOBTablette);
  // gm 23/09/2003 pour reprise de l'ana saisie sur ligne d'affaire
    if ((OkCpta) or (OkCptaStock)) then
      begin
        if (TOBC <> nil) and (TOBDet.Detail.Count > 0) then
        begin
          if ((TOBDet.Detail[0].Detail.Count <= 0) and (OkCpta)) then LocAnaP := TOBAnaP else LocAnaP := nil;
          if ((TOBDet.Detail[1].Detail.Count <= 0) and (OkCptaStock)) then LocAnaS := TOBAnaS else LocAnaS := nil;
          PreVentileLigne(TOBC, LocAnaP, LocAnaS, TOBDet);
        end;
      end;
//    PreVentileLigne(TOBC, TOBAnaP, TOBAnaS, TOBDet);

  end;
  TOBPiece.PutValue('GP_RECALCULER', 'X');
  {$IFDEF AFFAIRE} //Affaire-Formule des variables
  LoadLesAFFormuleVar('LIG', TobPieceAffaire, TOBFormuleVar, TOBFormuleVarQte);
  {$ENDIF}
  CalculeLaSaisie(-1, -1, False);
  TobPieceAffaire.Free;
end;

procedure TFFacture.IncidenceAffaire;
var CodeD, CodeTiers, LibTiers: string;
begin
  if (Action <> taCreat) and (not DuplicPiece) then Exit; // mcd 23/04/02 ajout DuplicPiece
//  if (VenteAchat <> 'VEN') then exit;
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
  if (VenteAchat='VEN') then
  begin
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
  end;
  GP_ETABLISSEMENT.Value := TOBAffaire.GetValue('AFF_ETABLISSEMENT');
  if GP_ETABLISSEMENT.Value = '' then GP_ETABLISSEMENT.Value := VH^.EtablisDefaut;
  if (VenteAchat='VEN') then
  begin
    AffaireVersPiece(TobPiece, TobAffaire);
    PutValueDetail(TOBPiece, 'GP_APPORTEUR', TOBPiece.GetValue('GP_APPORTEUR'));
  end;
  // mcd 14/02/03 if Not GetParamSoc('SO_GCPIECEADRESSE') then AffaireVersAdresses(TOBAffaire,TOBAdresses,TOBPiece);
  //mcd 29/09/03 d�placer, sinon cas clt fact mission non OK AffaireVersAdresses(TOBAffaire,TOBAdresses,TOBPiece); //mcd 18/09/03 perte de la ligne lors de la synchro vdev/diffusion de 06/2003
  TOBPiece.GetEcran(Self);
end;

procedure TFFacture.OnExitPartieAffaire(Sender: TObject);
{$IFDEF AFFAIRE}
var
  iP, NbAff: integer;
  Part1, Part2, Part3,Nature: string;
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
  GP_AFFAIRE.Text := DechargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, AFF_TIERS.Text, Action, False, True, false, iP);
  // correctif FQ 12573
	AFF_TIERS.text := GetChampsAffaire (GP_AFFAIRE.text,'AFF_TIERS');
  //
  NbAff := ChargeAffairePiece(True, True);
  LastErrorAffaire := NbAff;
  if (NbAff <> 1) then
  BEGIN
  	PositionErreurCodeAffaire(Sender, NbAff);
  END else
  begin
    if VenteAchat = 'VEN' then
    BEGIN
      //if GP_TIERS.text <> AFF_TIERS.text then TiersChanged := true;
      TiersChanged := true;
      GP_TIERS.text := AFF_TIERS.text;
      if ((not TransfoPiece) and (not DuplicPiece)) and (Action <> Tacreat) then nature := TOBPiece.getValue('GP_NATUREPIECEG')
                                                                            else Nature := newnature;
      RemplirTOBTiers(TOBTiers, GP_TIERS.Text, Nature, False);
      IncidenceTiers;
      TiersChanged := false;
  		LivAffaireVersAdresses (TOBAffaire,TOBAdresses,TOBPiece); // ajout BRL 141008 : FQ11927
    END;
  end;
  GereAffaireEnabled;
{$IFDEF BTP}
		TheDestinationLiv.ChangeAffaire;
    if (Action = TaCreat) and (TobPiece <> nil) and (TOBaffaire <> nil) then
    begin
    	TheLivFromRecepStock.ChangeAffaire;
      if (TheLivFromRecepStock.IsExists)  then
      begin
        TraiteLivrFromRecep;
      end;
    end;
{$ENDIF}
  {$ENDIF}
  fPieceCoTrait.Affaire := TOBAffaire;
  fModifSousDetail.DEV  := DEV;
  fModifSousDetail.SetChange;
end;

procedure TFFacture.PositionErreurCodeAffaire(Sender: TObject; NbAff: integer);
var NumPart: integer;
begin
  if GP_AFFAIRE.Text = '' then
  BEGIN
  	if GP_AFFAIRE1.enabled then GP_AFFAIRE1.setFocus
    else if GP_AFFAIRE2.enabled then GP_AFFAIRE2.setFocus
    else GP_AFFAIRE3.setFocus;
    Exit;
  END;
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
		bChangeStatus : boolean;
		{$IFDEF BTP}
		TheAffaire : string;
		{$ENDIF}
		Nature : string;
begin

  bChangeTiers := True;

  if VenteAchat = 'VEN' then
  	 begin
     AFF_TIERS.Text := GP_TIERS.Text;
     if GP_TIERS.Text <> '' then bChangeTiers := False;
     end;

{$IFDEF BTP}
  TheAffaire := GP_AFFAIRE.Text;
  if TheAffaire <> '' then
  begin
  	GP_AFFAIRE0.Text := Copy (TheAffaire,1,1);
  end else
  begin
  	GP_AFFAIRE0.Text := StatutAffaire;
  end;

  if (Pos(TOBPiece.getValue('GP_NATUREPIECEG'),'LBT;CBT') > 0 ) then
	   bChangeStatus := true
  else
  	 bChangeStatus := false;

  if GetAffaireEnteteSt(GP_AFFAIRE0, GP_Affaire1, GP_Affaire2, GP_Affaire3, GP_AVENANT, AFF_TIERS, TheAffaire, false, bChangeStatus, false, bChangeTiers, true,VenteAchat) then
   	 GP_AFFAIRE.text := TheAffaire;
{$ELSE}
  GetAffaireEntete(GP_AFFAIRE, GP_Affaire1, GP_Affaire2, GP_Affaire3, GP_AVENANT, AFF_TIERS, false, false, false, bChangeTiers, true,'FAC');
{$ENDIF}
  //////////////////////////////
  if GP_AFFAIRE.Text <> '' then
  begin
    ChargeCleAffairePiece;
    {$IFDEF BTP}
    if not ControleSaisiePieceBtp (TOBPiece,GP_AFFAIRE.Text,Action,TransfoPiece,Duplicpiece,True) then
    begin
      GP_AFFAIRE.Text := '';
      GP_AFFAIRE1.Text := '';
      GP_AFFAIRE2.Text := '';
      GP_AFFAIRE3.Text := '';
      GP_AVENANT.Text := '';
      AFF_TIERS.Text := '';
      exit;
    end;
    if VenteAchat = 'VEN' then
    BEGIN
      if AFF_TIERS.text <> GP_TIERS.text then TiersChanged := true;

    	GP_TIERS.text := AFF_TIERS.Text;
			if ((not TransfoPiece) and (not DuplicPiece)) and (Action <> Tacreat) then nature := TOBPiece.getValue('GP_NATUREPIECEG')
      																																			else Nature := newnature;
  		RemplirTOBTiers(TOBTiers, GP_TIERS.Text, Nature, False);
      IncidenceTiers;
      TiersChanged := false;
    END;
    {$ENDIF}
     ChargeAffairePiece(False, False, True);
  	 if VenteAchat = 'VEN' then	LivAffaireVersAdresses (TOBAffaire,TOBAdresses,TOBPiece); // ajout BRL 140509 : FQ12507
     fPieceCoTrait.Affaire := TOBAffaire;
     fPieceCoTrait.SetSaisie;
     IsPieceGerableCoTraitance (TOBPiece,TOBaffaire);
     if TOBPiece.Detail.count > 0 then
     begin
       PutValueDetail (TOBPiece,'GP_RECALCULER','X');
		   GereCalculPieceBTP;
     end;
{$IFDEF BTP}
		 TheDestinationLiv.ChangeAffaire;
		 if (Action = TaCreat) then
        begin
        TheLivFromRecepStock.ChangeAffaire;
        if TheLivFromRecepStock.IsExists then
           begin
           TraiteLivrFromRecep;
           end;
        end;
{$ENDIF}
     GereAffaireEnabled;
	end else
  begin
  	if TheAffaire = '' then GP_AFFAIRE0.Text := '';
  end;

end;

procedure TFFacture.BRazAffaireClick(Sender: TObject);
begin
  GP_Affaire.Text := '';
  GP_Affaire1.Text := '';
  GP_Affaire2.Text := '';
  GP_Affaire3.Text := '';
  GP_AVENANT.Text := '';

  // modif BRL 21/04/04 : corrections bug pilotage V5.10.002.007
  GP_Affaire.Text := '';
  LIBELLEAFFAIRE.Caption := '';
  ClearAffaire(TOBPiece);
  PutValueDetail(TOBPiece, 'GP_AFFAIRE', GP_AFFAIRE.Text);
  PutValueDetail(TOBPiece, 'GP_AFFAIRE1', GP_AFFAIRE1.Text);
  PutValueDetail(TOBPiece, 'GP_AFFAIRE2', GP_AFFAIRE2.Text);
  PutValueDetail(TOBPiece, 'GP_AFFAIRE3', GP_AFFAIRE3.Text);
  PutValueDetail(TOBPiece, 'GP_AVENANT', GP_AVENANT.Text);
  TOBAffaire.InitValeurs(False);
  EnleveRefPieceprec(TOBPiece);
  //----
  TheBordereau.ClearAll;
  if (GP_TIERS.Enabled) and (VenteAchat = 'VEN') then
  begin
    GP_Tiers.Text := '';
    LIBELLETIERS.caption := '';
    if GP_TIERS.CanFocus then GP_TIERS.SetFocus;
  end;
  fPieceCoTrait.ReinitSaisie;
  IsPieceGerableCoTraitance (TOBPiece,TOBaffaire);
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
//  AutoCodeAff := False;
  ChargeCleAffaire(GP_AFFAIRE0, GP_AFFAIRE1, GP_AFFAIRE2, GP_AFFAIRE3, GP_AVENANT, nil, Action, GP_AFFAIRE.Text, False);
//  AutoCodeAff := True;
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

  {$IFDEF BTP}
  if Aff = BTPCodeAffaireAffiche(TOBL.GetValue('GL_AFFAIRE')) then Exit;
  {$ELSE}
  if Aff = CodeAffaireAffiche(TOBL.GetValue('GL_AFFAIRE')) then Exit;
  {$ENDIF}
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

  // Contr�le des blocages sur affaires
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
      AffComplet := GS.Cells[ACol, ARow]; // si =1 d�ja alim
      {$IFDEF BTP}
      GS.Cells[ACol, ARow] := BTPCodeAffaireAffiche(AffComplet);      
      {$ELSE}
      GS.Cells[ACol, ARow] := CodeAffaireAffiche(AffComplet);
      {$ENDIF}
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
begin
  if ACol <> SG_Aff then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  if (VenteAchat <> 'VEN') then CodeTiers := '' else CodeTiers := TOBPiece.GetValue('GP_TIERS');
  {$IFDEF BTP}
  {$ELSE IF AFFAIRE}
  CodeAff := GS.Cells[ACol, ARow];
  CodeAffL := CodeAffaireAffiche(TOBL.GetValue('GL_AFFAIRE'));
  if ((CodeAff <> '') and (CodeAff = CodeAffL)) then
  begin
    // M�me code zoom affaire
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
{===============================Gestion descriptif d�tail===============================}
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
  if (TOBL.GetValue('GL_REFARTSAISIE') = '') and (TOBL.GetValue('GL_TYPELIGNE')<>'COM') then CacherDesc := True;
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
    if (TOBL.GetValue('GL_REFARTSAISIE') = '') and (TOBL.GetValue('GL_TYPELIGNE')<>'COM') then CacherDesc := True;
    {$ENDIF}
    TDescriptif.Visible := ((BDescriptif.Down) and (not CacherDesc));
    StringToRich(Descriptif, TOBL.GetValue('GL_BLOCNOTE'));
    TDescriptif.Caption := Format('Descriptif ligne N� %d', [ARow]);
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
  // Cr�ation des TOB utiles � la nouvelle pi�ce
  BasesDel := TOB.Create('BASES', nil, -1);
  if not SetDefinitiveNumber(TOBPieceDel, BasesDel, nil,nil, TOBNomenDel, nil, nil, nil, TobLigneTarif, NumPieceAnnule) then V_PGI.IoError := oePointage;
  if V_PGI.IoError = oeOk then
  begin
    // Calculs
    //CalculFacture(TOBPieceDel, BasesDel, TOBTiers, TOBArticles, TOBPieceRg, TOBBasesRg, nil, DEV);
    
    CalculFacture(TOBPieceDel, nil,nil,nil,BasesDel, Nil,TOBTiers, TOBArticles, TOBPieceRg, TOBBasesRg, nil, DEV, false, action);
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
  Mise � jour du reste � livrer dans la pi�ce d'origine directement dans TobPiece_O
  puis UpDateDB de TobPiece_O
}
var
  NewEtat: string;
  i: Integer;
  TOBL, TOBLOld: TOB;
begin
  for i := 0 to TobPiece.Detail.Count - 1 do { NEWPIECE }
  begin
    Tobl := TobPiece.Detail[i];
    { R�cup�re la ligne dans la pi�ce d'origine }
    TobLOld := GetTOBPrec(TobL, TobPiece_O, True);
    if TobLOld = nil then Continue;
    if not TobL.FieldExists('SOLDERELIQUAT') then
    begin
      { Mise � jour du reste � livrer de la ligne de la pi�ce d'origine }
      TobLOld.PutValue('GL_QTERESTE', Arrondi(TobLOld.GetValue('GL_QTERESTE') - TobL.GetValue('GL_QTESTOCK'), 6));
      if TOBlOld.GetValue('GL_QTERESTE') < 0 then TobLOld.PutValue('GL_QTERESTE',0);
    end
    else
    begin
      { On a fait solder reliquat sur la ligne => Mise � jour de la piece pr�c�dente }
      TobLOld.PutValue('GL_SOLDERELIQUAT', 'X');
      TobLOld.PutValue('GL_QTERESTE', Arrondi(TobLOld.GetValue('GL_QTERESTE') - TobL.GetValue('GL_QTESTOCK'), 6));
      if TOBlOld.GetValue('GL_QTERESTE') < 0 then TobLOld.PutValue('GL_QTERESTE',0);
      if ToblOld.GetValue('GL_QTERESTE') > 0 then
      begin
        TobLOld.PutValue('GL_QTERELIQUAT', ToblOld.GetValue('GL_QTERESTE'));
        TobLOld.PutValue('GL_QTERESTE', 0);
      end;
    end;

    { Pour la nouvelle piece }
    TOBL.PutValue('GL_SOLDERELIQUAT', '-');
    // TOBL.PutValue('GL_QTERELIQUAT', 0);
  end;
  NewEtat := '';
  if ToutesLignesSoldees(TobPiece_O) then
    NewEtat := '-'
  else
    NewEtat := 'X';
  TobPiece_O.PutValue('GP_VIVANTE', NewEtat);
  { Etat des lignes = Etat de l'ent�te }
  for i := 0 to TobPiece_O.Detail.Count - 1 do
    TobPiece_O.detail[i].PutValue('GL_VIVANTE', NewEtat);
  TOBPiece_O.UpdateDB(False);
  if Assigned(TobPiece_OO) then
  begin
    for i := 0 to TobPiece_OO.detail.Count - 1 do
    begin
      Tobl := FindTobLigInOldTobPiece(TobPiece_OO.Detail[i], TobPiece_O);
      if Tobl = nil then
      begin
        { La ligne a �t� sold�e }
        TobPiece_OO.Detail[i].SetAllModifie(False);
        TobPiece_OO.Detail[i].PutValue('GL_VIVANTE', NewEtat);
        TobPiece_OO.Detail[i].UpdateDB(False);
      end;
    end;
  end;
  {$IFNDEF CCS3}
  RazAndSaveLesSeries(TobSerie,TobSerie_O);
  ReaffecteLesReliquatSerie(TobSerRel, TobPiece_O);
  {$ENDIF}
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
    if not GppReliquat then { Transformation d'une pi�ce. On ne g�re pas les reliquats dans la nouvelle pi�ce }
    begin
      RazResteALivrerAndKillPiece(TobPiece_O);
      {$IFNDEF CCS3}
      RazAndSaveLesSeries(nil, TobSerie_O);
      {$ENDIF}
    end;
end;

procedure TFFacture.ValideLaCompta(OldEcr, OldStk: RMVT);
begin
  if VH_GC.GCIfDefCEGID then
     RechLibTiersCegid(VenteAchat, TobTiers, TOBPiece, TobAdresses);
  if not PassationComptable(TOBPiece,TOBOuvragesP, TOBBases,TOBBasesL, TOBEches,TOBPieceTrait,TOBAffaireInterv,TOBTiers, TOBArticles, TOBCpta, TOBAcomptes, TOBPorcs, TOBPIECERG, TOBBASESRG, TOBanaP,TOBanaS,DEV, OldEcr,
    OldStk, True) then
  begin
    MessageValid := 'Erreur / ecriture comptable';
    V_PGI.IoError := oeLettrage;
  end;
  LibereParamTimbres;
end;

function TFFacture.ControleFacture : boolean;
Var RefUnique, CodeArticle : String ;
    TOBBS,TOBB : TOB ;
    okBases, okSaisie, Cancel : boolean ;
    iInd, ACol, ARow : integer ;
BEGIN
  Result := True;
  okBases := True;
  okSaisie := False;
  if Action=taConsult then Exit ;
//  if VenteAchat <> 'ACH' then exit;
//  if GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') <> 'NOR' then exit;
	if (VenteAchat <> 'ACH') or (IsTransformable(NewNature)) then exit;
  if not TobBasesSaisies.FieldExists ('TOTALTTC') then Result := False
  else if Valeur (TobBasesSaisies.GetValue ('TOTALTTC')) = 0 then Result := False;
  if Result then
  begin
    for iInd := 0 to TOBBasesSaisies.Detail.Count -1 do
    begin
      TOBBS := TOBBasesSaisies.Detail[iInd];
      TobB := TOBBases.FindFirst(['GPB_CATEGORIETAXE','GPB_FAMILLETAXE'],
                               [TOBBS.GetValue('GPB_CATEGORIETAXE'),
                                TOBBS.GetValue('GPB_FAMILLETAXE')],
                               False);
      if TobB = nil then
      begin
        okBases := false;
        break;
      end else
      begin
        okBases := true;
        TobBS.PutValue ('GPB_NATUREPIECEG', TobB.GetValue ('GPB_NATUREPIECEG'));
        TobBS.PutValue ('GPB_SOUCHE', TobB.GetValue ('GPB_SOUCHE'));
        TobBS.PutValue ('GPB_INDICEG', TobB.GetValue ('GPB_INDICEG'));
        TobBS.PutValue ('GPB_NUMERO', TobB.GetValue ('GPB_NUMERO'));
        TobBS.PutValue ('GPB_DATEPIECE', TobB.GetValue ('GPB_DATEPIECE'));
        TobBS.PutValue ('GPB_COTATION', TobB.GetValue ('GPB_COTATION'));
        TobBS.PutValue ('GPB_DATETAUXDEV', TobB.GetValue ('GPB_DATETAUXDEV'));
        TobBS.PutValue ('GPB_DEVISE', TobB.GetValue ('GPB_DEVISE'));
        TobBS.PutValue ('GPB_SAISIECONTRE', TobB.GetValue ('GPB_SAISIECONTRE'));
        TobBS.PutValue ('GPB_TAUXDEV', TobB.GetValue ('GPB_TAUXDEV'));
        TobBS.PutValue ('GPB_BASETAXE', TobB.GetValue ('GPB_BASETAXE'));
        TobBS.PutValue ('GPB_VALEURTAXE', TobB.GetValue ('GPB_VALEURTAXE'));
        TobBS.PutValue ('GPB_TAUXTAXE', TobB.GetValue ('GPB_TAUXTAXE'));
      end;
      if Valeur (TobBS.GetValue ('GPB_BASEDEV')) <> 0 then okSaisie := true;
    end;
    Result := (okBases) and (okSaisie);
  end;

  if Result then
  begin
    TOBPiece.PutValue ('GP_TOTALTTCDEV', TOBBasesSaisies.GetValue('TOTALTTC'));
    if DEV.Code<>V_PGI.DevisePivot then
    begin
      TOBPiece.PutValue ('GP_TOTALTTC',
               DeviseToEuro (TOBPiece.GetValue ('GP_TOTALTTCDEV'), DEV.Taux, DEV.Quotite)) ;
    end else
    begin
      TOBPiece.PutValue ('GP_TOTALTTC', TOBPiece.GetValue('GP_TOTALTTCDEV'));
    end;
    TobPiece.PutValue ('GP_REFINTERNE', TobBasesSaisies.GetValue ('REFINTERNE'));
  end else
  begin
    HErr.Execute (8, Caption, '');
    bAppelControleFacture := True;
    if not Entree_ControleFacture (TOBBases, TOBBasesSaisies, TOBPiece, TobTiers, Action) then exit;

    for iInd := 0 to TOBBasesSaisies.Detail.Count -1 do
    begin
      TOBBS := TOBBasesSaisies.Detail[iInd];
      if not TOBBS.FieldExists('GA_ARTICLE') then continue;
      RefUnique:=TOBBS.GetValue('GA_ARTICLE');
      if RefUnique = '' then continue;
      if TobPiece.FindFirst (['GL_ARTICLE'], [RefUnique], True) = nil then
      begin
        ARow := TobPiece.Detail.Count + 1;
        CreerTOBLignes(GS,TOBPiece,TOBTiers,TOBAffaire,ARow) ;
        CodeArticle:=Trim(Copy(RefUnique,1,18)) ;
        GS.Cells[SG_RefArt,ARow]:=RefUnique ;
        ACol:=SG_RefArt ;
        Cancel:=False ;
        TraiteArticle(ACol,ARow,Cancel,True,True,1) ;
        if Cancel then Continue ;
        GS.Cells[SG_RefArt,ARow]:=CodeArticle ;
        AfficheLaLigne(ARow);
        GS.Cells[SG_Px, ARow] := strf00 (TobBS.GetValue ('GPB_BASEDEV'), DEV.Decimale);
        ACol := SG_Px;
        GSCellExit (Nil, ACol, ARow, Cancel);
        StCellCur := GS.Cells[SG_RefArt, ARow] ;
      end;
      TobB := TobBases.FindFirst (['GPB_CATEGORIETAXE', 'GPB_FAMILLETAXE'],
                            [TobBS.GetValue ('GPB_CATEGORIETAXE'),
                             TobBS.GetValue ('GPB_FAMILLETAXE')], True);
      if TobB <> nil then
      begin
        TobBS.PutValue ('GPB_NATUREPIECEG', TobB.GetValue ('GPB_NATUREPIECEG'));
        TobBS.PutValue ('GPB_SOUCHE', TobB.GetValue ('GPB_SOUCHE'));
        TobBS.PutValue ('GPB_INDICEG', TobB.GetValue ('GPB_INDICEG'));
        TobBS.PutValue ('GPB_NUMERO', TobB.GetValue ('GPB_NUMERO'));
        TobBS.PutValue ('GPB_COTATION', TobB.GetValue ('GPB_COTATION'));
        TobBS.PutValue ('GPB_DATETAUXDEV', TobB.GetValue ('GPB_DATETAUXDEV'));
        TobBS.PutValue ('GPB_DEVISE', TobB.GetValue ('GPB_DEVISE'));
        TobBS.PutValue ('GPB_SAISIECONTRE', TobB.GetValue ('GPB_SAISIECONTRE'));
        TobBS.PutValue ('GPB_TAUXDEV', TobB.GetValue ('GPB_TAUXDEV'));
        TobBS.PutValue ('GPB_BASETAXE', TobB.GetValue ('GPB_BASETAXE'));
        TobBS.PutValue ('GPB_VALEURTAXE', TobB.GetValue ('GPB_VALEURTAXE'));
        TobBS.PutValue ('GPB_TAUXTAXE', TobB.GetValue ('GPB_TAUXTAXE'));
      end;
    end;
    result := true;
  end;
END ;

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
    if not SetDefinitiveNumber(TOBPiece, TOBBases, TOBBasesL,TOBEches, TOBNomenclature, TOBAcomptes, TOBPIeceRG, TOBBasesRg, TobLigneTarif, CleDoc.NumeroPiece) then
    begin
      MessageValid := 'Erreur lors de la renum�rotation de la pi�ce';
      V_PGI.IoError := oePointage;
    end;
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
  ExiAccDet, ModifAcpte: Boolean;
begin
	ModifAcpte := false;
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
//  if HPiece.Execute(33, caption, '') <> mrYes then Exit;
  if HPiece.Execute(33, caption, '') = mrNo then
    ModifAcpte := True
    else
    ModifAcpte := False;
  {$ENDIF}
  for i := TOBAcomptes.Detail.Count - 1 downto 0 do
  begin
    TOBC := TOBAcomptes.Detail[i];
    if not TOBC.FieldExists('NEWACC') then Continue;
    FlagAcc := TOBC.GetValue('NEWACC');
    if ((FlagAcc = 'R') or (FlagAcc = 'D')) then
    begin
      DetruitAcompteGCCpta(TOBPiece, TOBC, ModifAcpte, True);
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
    DetruitLesFormules (TOBPiece_O,TOBLigFormule_O);
    {$IFDEF AFFAIRE}
    DetruitAffaireComplement (TOBFormuleVarQte_O,nil);
    {$ENDIF}
    if not DetruitAncien(TOBPiece_O, TOBBases_O, TOBEches_O, TOBN_O, TOBLOT_O, TOBAcomptes_O, TOBPorcs_O, TOBSerie_o, TOBOuvrage_O, TOBLienOLE_O, TOBPIECERG_O, TOBBasesRg_O, TobLigneTarif_O) then V_PGI.IoError := oeSaisie;
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
  if not (Self.ActiveControl = GS) then
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
  InverseLesPieces(TOBPieceRG, 'PIECERG');
  InverseLesPieces(TOBBasesRG, 'PIEDBASERG');

  {Gestion des pi�ces d'avoir}
  if (Action = taModif) and (not DuplicPiece) then
  begin
    InverseLesPieces(TOBPiece_O, 'PIECE');
    InverseLesPieces(TOBBases_O, 'PIEDBASE');
    InverseLesPieces(TOBEches_O, 'PIEDECHE');
    InverseLesPieces(TOBPorcs_O, 'PIEDPORT'); //mcd 07/06/02 port non pris en compte
    InverseLesPieces(TOBPieceRG_O, 'PIECERG');
    InverseLesPieces(TOBBasesRG_O, 'PIEDBASERG');
  end;
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
    {Tests pr�alables}
    TOBL := TOBPiece.Detail[i];
    if TOBL = nil then Break;
    RefArt := TOBL.GetValue('GL_ARTICLE');
    if RefArt = '' then Continue;
    if ((not TOBL.FieldExists('SUPPRIME')) or (TOBL.GetValue('SUPPRIME') <> 'X')) then Continue;
    // suppression des composants de nomenclature rattach�s
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
    {Suppression et renum�rotation : Destruction des lots, s�rie, de l'analytique et en dernier de la ligne}
    DetruitLot(i + 1);
    DetruitSerie(i + 1, Action, GereSerie, TobPiece, TobSerie);
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
    DeleteTobLigneTarif(TobPiece, Tobl);
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
      // DBR : �a d�calait les indices de la tob donc supprimait les mauvais d�tails de nomenclature
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
  if TOBPiece.getValue('GP_RGMULTIPLE')='X' then exit;
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
    if Assigned(TOBL) then
    begin
      DeleteTobLigneTarif(TobPiece, Tobl);
      TOBL.free;
    end;
    InsereLigneRG(TOBPIece, TOBPIeceRG.detail[0], TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG, -1);
  end;
end;

procedure TFFacture.ValideLaPiece; { NEWPIECE }
var OldEcr, OldStk: RMVT;
  SavAcompteInit: double; // Modif BTP
  InAvancement : boolean;
  AutoriseSansDecomp : boolean;
  NowFutur : TDateTime;
begin
	NowFutur := 0;
//  AutoriseSansDecomp := (Pos(TOBPiece.GetValue('GP_NATUREPIECEG'),'BCE;FPR;FAC')>0) ;
	AutoriseSansDecomp := (Pos(TOBPiece.GetValue('GP_NATUREPIECEG'),'BCE;FPR;FAC;AF;AFS')>0) ;
  InAvancement := (SaisieTypeAvanc) or (ModifAvanc);
  SavAcompteInit := -1;
{$IFDEF BTP}
	WarningFinSiprevisionnel (self,TOBPiece,TOBLienDevCha);
{$ENDIF}
	if V_PGI.Ioerror = OeOk then
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
//      if not AvoirDejaInverse then
//      begin
        InverseAvoir;
//        AvoirDejaInverse := True;
//      end;
    end;
    MoveCur(False);
    ReaffecteDispoContreM(TOBPiece_O, TOBPiece, TOBCatalogu);
    ReaffecteDispoDiff(TOBArticles); //JD 25/03/03

    {$IFDEF AFFAIRE}
    ImpactActiviteLigne(TOBPiece, GereActivite);
    {$ENDIF}
    MoveCur(False);
  end;


  {Verification et gestion de la piece d'origine sur piece achat}
  if (Action=taModif) and (not duplicpiece) and (VenteAchat = 'ACH') then
  begin
    ControleEtReajustePieceOrigine (TOBPiece,TOBArticles );
  end;


  {Traitement pi�ce d'origine}
  if ((Action = taModif) and (not DuplicPiece)) then
  begin
  	NowFutur := NowH;
    if V_PGI.IoError = oeOk then DetruitCompta(TOBPiece_O, NowFutur, OldEcr, OldStk,true);
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
      if V_PGI.IoError = oeOk then InverseStockTransfo(TOBPiece_O, TobPiece, TOBArticles, TOBCatalogu, TOBN_O, Litige);
      {$IFNDEF CCS3}
      if V_PGI.IoError = oeOk then InverseStockLotTransfo(TOBPiece_O, TobPiece, TobLot_O, TobArticles);
      if V_PGI.IoError = oeOk then InverseStockSerieTransfo(TOBPiece_O, TobPiece, TOBSerie_O);
      {$ENDIF}
    end;
  end;
  MoveCur(False);
  {Enregistrement nouvelle pi�ce}
  if V_PGI.IoError = oeOk then
  begin
    InitToutModif (NowFutur);
    ValideLaNumerotation;
    ValideLaCotation(TOBPiece, TOBBases, TOBEches);
    ValideLaPeriode(TOBPiece);
    if GetInfoParPiece(NewNature, 'GPP_IMPIMMEDIATE') = 'X' then TOBPiece.PutValue('GP_EDITEE', 'X');
  end;
  MoveCur(False);
  // JT eQualit� 10246
  if (V_PGI.IoError = oeOk) and (TOBAcomptes.detail.count > 0) and (TOBAcomptes.FieldExists('CHGTNUM') )then
    ModifRefGC(TOBPiece, TOBAcomptes);
  // Fin JT
  // Modif Btp
  if V_PGI.IoError = oeOk then SupLesLibDetail(TOBPiece);
  if V_PGI.IoError = oeOk then GestionRgUnique(TOBPIECE, TOBPIECERG, TOBBASES, TOBBASESRG, TOBTIers, TOBAffaire, TOBLigneRG);
  // Correction OPTIMISATION
  if V_PGI.IoError = oeOk then ValideLesArticlesFromOuv(TOBarticles,TOBOuvrage);
  // --
  if V_PGI.IoError = oeOk then ValideLesLignes(TOBPiece, TOBArticles, TOBCatalogu, TOBNomenclature, TobOuvrage, TOBPieceRG, TOBBasesRG, False, False,false,false,nil,AutoriseSansDecomp);
  {$IFDEF BTP}
  if V_PGI.IoError = oeOk then
  begin
    if (V_PGI.IoError = oeOk) and (not InAvancement) then ValideLesLienDevCha(TOBPiece, TOBOuvrage, TOBLienDEVCHA);
  	if V_PGI.IoError=oeOk then ValideLesLignesCompl(TOBPiece, TobPiece_O);
    if VenteAchat <> 'ACH' then
    begin
      if V_PGI.IoError = oeOk then ValideLesOuv(TOBOuvrage, TOBPiece);
      if (IsEcritLesOuvPlat) and (V_PGI.IoError = oeOk) then ValideLesOuvPlat (TOBOuvragesP, TOBPiece);
    end;
  end;
  if V_PGI.IoError = oeOk then ValideLesBases(TOBPiece,TobBases,TOBBasesL);
  if (V_PGI.Ioerror = OeOk) and (not GetParamSocSecur('SO_METRESEXCEL',true)) then ValidelesMetres (TOBPiece,TOBmetres);
  {$ENDIF}
  if V_PGI.IoError = oeOk then
  begin
//    if (tModeBlocNotes in SaContexte) then ValideLesLiensOle(TOBPiece, TOBPiece_O, TOBLienOLE);
    if V_PGI.Ioerror = OeOk then ValideLesLiensOle(TOBPiece, TOBPiece_O, TOBLienOLE);
  end;
  // -------------------
  //if V_PGI.IoError=oeOk then ValideLesLignes(TOBPiece,TOBArticles,TOBCatalogu,TOBNomenclature,False,False) ;
{$IFDEF GPAOLIGHT}
  if V_PGI.IoError=oeOk then ValideLesLignesCompl(TOBPiece, TobPiece_O);
{$ENDIF GPAOLIGHT}
  if V_PGI.IoError = oeOk then ValideLesAdresses(TOBPiece, TOBPiece_O, TOBAdresses);
  if V_PGI.IoError = oeOk then
  begin
    GereLesReliquats;
    ElimineLignesZero;
  end;
  { NEWPIECE }
  if (Action = taModif) and (not DuplicPiece) and (ReliquatTransfo) then
  begin
    if (TransfoPiece) and (HistoPiece(TobPiece_O)) then
    begin
      if not TOBPiece_O.UpdateDB(False) then
      BEGIN
        MessageValid := 'Erreur mise � jour pi�ce pr�c�dente (UPDATE)';
        V_PGI.IoError := oeSaisie; { NEWPIECE }
      end;
    end;
  end;
  if (V_PGI.IoError = oeOk) and (Action = taModif) and (not DuplicPiece) and (not TransfoPiece) then
  begin
    if GppReliquat then { Modification d'une pi�ce dans laquelle les reliquats sont g�r�s }
    begin
      { Remise � jour du GL_QTERESTE dans la pi�ce d'origine }
      UpdateResteALivrer(TobPiece, TobPiece_O, TOBArticles, TOBCatalogu, TOBNomenclature, urModif);
      { Recalcul du GL_QTERELIQUAT dans les lignes issues de la pi�ce en cours de saisie }
  //    if (V_PGI.IoError = oeOk) then
  //      UpdateQuantiteReliquat(TobPiece, TobPiece_O);
    end;
    { En modification de pi�ce g�re le solde ou le d�solde des lignes }
    GereLesLignesSoldees(TobPiece, TobPiece_O, TobArticles, TOBCatalogu, TOBNomenclature);
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
  // if V_PGI.IoError=oeOk then ValideLesLots ; d�plac�
  if V_PGI.IoError = oeOk then ValideLesSeries;
  if V_PGI.IoError = oeOk then ValideLesFormules(TOBPiece,TOBLigFormule);
  {$IFDEF AFFAIRE}  //Affaire-Formule des variables
  if V_PGI.IoError = oeOk then ValideLesAFFormuleVar(TOBPiece, TOBPiece_O, TOBFormuleVarQte);
  {$ENDIF}
  {$IFNDEF CHR}
  if (SaisieTypeAvanc) or ((TobPiece.GetValue('GP_NATUREPIECEG') = GetParamSoc('SO_AFNATAFFAIRE')) and (ISAcompteSoldePartiel(TOBPiece))) then
  begin
    // Pour Eviter de rattacher le reliquat d'acompte au devis initial lors de la facturation
    // ou pour eviter de perdre le montant initial d'acompte lors de la modification d'un devis apres facturation partielle
    SavAcompteInit := TOBPiece_O.GetValue('GP_ACOMPTEDEV');
  end;
  if not EstAvoir then  // JT eQualit� 10764
    if V_PGI.IoError = oeOk then ValideLesAcomptes(TOBPiece, TOBAcomptes);
  if SavAcompteInit >= 0 then TOBPiece.PutValue('GP_ACOMPTEDEV', SavAcompteInit);
  {$ENDIF}
  if V_PGI.IoError = oeOk then ValideLesPorcs(TOBPiece, TOBPorcs);
  {$IFDEF BTP}
//  if (V_PGI.IoError = oeOk) and (VenteAchat <> 'ACH') then DetruitLignesVirtuellesOuv(TOBPIece, DEV);
  {$ENDIF}
  MoveCur(False);
  // Modif BTP
  if V_PGI.IoError = oeOk then ValideLesPieceTrait(TOBPiece, TOBPieceTrait,DEV);
  if V_PGI.IoError = oeOk then ValideLesRetenues(TOBPiece, TOBPieceRG);
  if V_PGI.IoError = oeOk then ValideLesBasesRG(TOBPiece, TOBBasesRG);
  if V_PGI.IoError = oeOk then ValideLesTimbres(TOBPiece, TOBTimbres);
  // --
  if V_PGI.IoError = oeOk then
  begin
//    if (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') = 'NOR') and
//       (Action<>taConsult) and (GetParamSoc ('SO_GCCONTROLEFACTURE')) then
    if ((VenteAchat = 'ACH') and (not IsTransformable(NewNature)) and
    		(Action<>taConsult) and
       (GetParamSoc ('SO_GCCONTROLEFACTURE'))) then
    begin
      if GetInfoParPiece (NewNature, 'GPP_ESTAVOIR') = 'X' then
      begin
        TobPiece.PutValue ('GP_TOTALTTC', TobPiece.GetValue ('TOTALTTC_CFA') * -1);
        TobPiece.PutValue ('GP_TOTALTTCDEV', TobPiece.GetValue ('TOTALTTCDEV_CFA') * -1);
      end else
      begin
        TobPiece.PutValue ('GP_TOTALTTC', TobPiece.GetValue ('TOTALTTC_CFA'));
        TobPiece.PutValue ('GP_TOTALTTCDEV', TobPiece.GetValue ('TOTALTTCDEV_CFA'));
      end;
    end;
    // MODIF LS Pour gestion de la fin de vie des pieces
    if (Action=TaModif) and
    	 (GetInfoParPiece(NewNature, 'GPP_ACTIONFINI') = 'TRA') and
    	 (ToutesLignesSoldees(TOBpiece)) then
    begin
    	TOBPiece.PutValue('GP_VIVANTE','-');
    end;
    //
    if not TOBPiece.InsertDBByNivel(False) then
    begin
      MessageValid := 'Erreur mise � jour LIGNE';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  MoveCur(False);
  if V_PGI.IoError = oeOk then
  begin
    if IsEcritLesOuvPlat and (not TOBOuvragesP.InsertDBByNivel(false)) then
    begin
      MessageValid := 'Erreur mise � jour OUVRAGES PLAT';
      V_PGI.IoError := oeUnknown;
    end else if (not IsEcritLesOuvPlat) then
    begin
      TOBOuvragesP.ClearDetail;
    end;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBBases.InsertDB(nil) then
    begin
      MessageValid := 'Erreur mise � jour BASES';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBBasesL.InsertDB(nil) then
    begin
      MessageValid := 'Erreur mise � jour BASES LIGNE';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBEches.InsertDB(nil) then
    begin
      MessageValid := 'Erreur mise � jour ECHEANCES';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBAnaP.InsertDB(nil) then
    begin
      MessageValid := 'Erreur mise � jour ANALYTIQUE/PIECE';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if V_PGI.IoError = oeOk then
  begin
    if not TOBAnaS.InsertDB(nil) then
    begin
      MessageValid := 'Erreur mise � jour ANALYTIQUE/STOCK';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if (V_PGI.Ioerror = OeOk) and (not GetParamSocSecur('SO_METRESEXCEL',true)) then
  begin
  	if not TOBmetres.InsertDBByNivel(false) then
    begin
      MessageValid := 'Erreur mise � jour METRES';
      V_PGI.IoError := oeUnknown;
    end;
  end;
  if V_PGI.IoError = oeOk then ValideLesNomen(TOBNomenclature);
  {$IFDEF BTP}
  // Modif BTP
  if V_PGI.IoError = oeOk then ModifSituation(TOBPiece, TOBOuvrage, TOBPieceRG, TOBPieceRG_O, TOBBasesRg, TOBAcomptes, DEV);
  {$ENDIF}
  {$IFDEF AFFAIRE}
  if V_PGI.IoError = oeOk then if (ctxAffaire in V_PGI.PGIContexte) or (ctxGCAFF in V_PGI.PGIContexte) then
      MajAffaire(TOBPiece, TOBAcomptes, Codeaffaireavenant, 'VAL', Action, DuplicPiece, InAvancement);
  {$ENDIF}
  if (V_PGI.Ioerror = oeok) and (copy (TOBpiece.getValue('GP_AFFAIRE'),1,1)='W') and
     (TOBPiece.GetValue('GP_NATUREPIECEG') = 'DAP') then
  begin
  	MajAppel (TOBPiece);
  end;
  {$IFDEF EDI}
  if V_PGI.IoError = oeOk then
    if GetInfoParPiece(CleDoc.NaturePiece, 'GPP_PIECEEDI') = 'X' then
      if IsEDITiers(TobPiece) then
        EDICreateETR(TobPiece, EDIGetFieldFromETS('ETS_CODEMESSAGE', EDIGetCleETS(TobPiece.GetValue('GP_TIERS'), TobPiece.GetValue('GP_NATUREPIECEG'))));
  {$ENDIF}

  {$IFDEF GPAOLIGHT}
  if V_PGI.IoError = oeOk then
  begin
    { R�ception � la livraison }
    if Pos(CleDoc.NaturePiece + ';', GetParamSoc('SO_WMISEENPROD')) <> 0 then
      wReceptionneWOLFromGL(TobPiece);
  end;
  {$ENDIF GPAOLIGHT}

  if V_PGI.IoError = oeOk then
  begin
//    wShowMeTheTob(TobLigneTarif);
    if not TOBLigneTarif.InsertDB(nil) then V_PGI.IoError := oeUnknown;
  end;

  // Modif BTP .... A LAISSER EN FIN DE FONCTION SVP
  {$IFDEF BTP}
  (* CONSO *)
  if (V_PGI.IOError = OeOk) Then TheRepartTva.Ecrit;
  if (V_PGI.IOError = OeOk) Then GestionConso.GenerelesPhases(TOBPiece,TOBCONSODEL,TransfoPiece,DuplicPiece,false,Action);
  if (V_PGI.IOError = OeOk) Then GestionConso.clear;
  (* ---- *)
  (* Generation des livraison depuis les recpetions *)
  if (V_PGI.IOError = OeOk) Then GenereLivraisonClients(TOBPiece,Action,transfoPiece,DuplicPiece,false);
  if (V_PGI.IOerror = OeOK) and (DuplicPiece) and (TmodeSaisieBordereau in SaContexte) then
  begin
     EcritEnteteBord(Self,TOBPiece);
  end;
  // Modif BTP .... A LAISSER EN FIN SVP
  if GetParamSocSecur('SO_METRESEXCEL',true) then
  begin
    if (V_PGI.IOError = OeOk) and (TheMetre.Usable) then
    Begin
      TheMetre.Validate;
    end;
  end;
  {$ENDIF}
  if (V_PGI.IOerror = OEOk) and (ForceEcriture) then ForceEcriture := false;
  if EstAvoir then
  begin
    InverseAvoir;
  end;
  FiniMove;
end;

procedure TFFacture.ValideImpression;
var imprimeok: boolean;
  savcol, savrow: integer;
  OKAValider: boolean;
begin
  imprimeok := True;
(*
  {$IFDEF BTP}
  if (TOBPiece.GetValue('GP_VENTEACHAT') = 'VEN') and (WithParamEdition(Cledoc.NaturePiece)) then
    Ret := AGLLanceFiche('BTP', 'BTPARIMPDOC', '', '', 'NATURE=' + CleDoc.NaturePiece + ';NUMERO=' + inttostr(CleDoc.NumeroPiece) + ';AFFAIRE=' +
      TOBPiece.GetValue('GP_AFFAIREDEVIS'))
  else
    Ret := '1';
  if (Ret = '') or (Ret = '0') then
    imprimeok := False;
  {$ENDIF}
*)
  BeforeImprimePieceBtp (self, TOBPiece,SAVcol,SAVrow,ImprimeOk,OkAValider,IMPRESSIONTOB,true);

  {$IFNDEF CHR}
//  if imprimeok then ImprimerLaPiece(TOBPiece, TOBTiers, CleDoc, False, TobAffaire);
  if imprimeok then ImprimerLaPiece(TOBPiece, TOBTiers, CleDoc, false,false, TobAffaire,IMPRESSIONTOB);
  {$ENDIF}
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
  Indice : integer;
  Ok, bForceEche, bOuvreEche: boolean;
  {$IFDEF BTP}
  IsAcompteRegl, ControleMargeOk : Boolean;
  {$ENDIF}
  TOBBases_Dup, TobB : TOB;
  iInd : integer;
  TobExceptionTiers : TOB;
  bTiersExceptionMontantMini : boolean;
  stMessageMiniCde : string;
  CledocS : r_cledoc;

  procedure ErrorValid(NumMsg: integer);
  var TobJnal: TOB;
    Qry: TQuery;
    NumEvt: integer;
    Nature, ActionSurPiece, TypeEvt: string;
    BlocNote: TStringList;
  begin
    MessageAlerte(HTitres.Mess[NumMsg]);
    ValideEnCours := False;

    //Maj Journal uniquement en cr�ation, duplication ou transformation
    GP_NUMEROPIECE.Caption := HTitres.Mess[10]; //Raz du num�ro affich�
    if (Action = taConsult) or
      ((Action = taModif) and ((not DuplicPiece) and (not TransfoPiece))) then exit;

    if Action = taCreat then
    begin
      ActionSurPiece := TraduireMemoire('Cr�ation');
      TypeEvt := 'CRE';
    end else
      if (Action = taModif) and (DuplicPiece) then
    begin
      ActionSurPiece := TraduireMemoire('Duplication');
      TypeEvt := 'DUP';
    end else
      if (Action = taModif) and (TransfoPiece) then
    begin
      ActionSurPiece := TraduireMemoire('G�n�ration');
      TypeEvt := 'GEN';
    end;

    Nature := RechDom('GCNATUREPIECEG', TOBPiece.GetValue('GP_NATUREPIECEG'), False);
    BlocNote := TStringList.Create;
    BlocNote.Add(Nature + TraduireMemoire(' num�ro ') + IntToStr(TOBPiece.GetValue('GP_NUMERO')));
    BlocNote.Add(TraduireMemoire('Num�ro affect� lors d''une erreur en ') + ActionSurPiece);
    BlocNote.Add(TraduireMemoire('Message : ') + HTitres.Mess[NumMsg]);
    TobJnal := TOB.Create('JNALEVENT', nil, -1);
    TobJnal.PutValue('GEV_TYPEEVENT', TypeEvt);
    TobJnal.PutValue('GEV_LIBELLE', Copy(ActionSurPiece + ' de ' + Nature, 1, 35));
    TobJnal.PutValue('GEV_DATEEVENT', Date);
    TobJnal.PutValue('GEV_UTILISATEUR', V_PGI.User);
    TobJnal.PutValue('GEV_ETATEVENT', 'ERR');
    TobJnal.PutValue('GEV_BLOCNOTE', BlocNote.Text);
    Qry := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True,-1, '', True);
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

//if StatusFiche then Enabled := false;
  TRY
  // Tests et actions pr�alables
  if not BValider.Enabled then Exit;
  if Action = taConsult then Exit;
  // Control existance Tiers    FQ Mode 10406 AC
  if ((GP_TIERS.Text = '') or (GP_TIERS.Text <> TOBTiers.GetValue('T_TIERS'))) then
  begin
    HPiece.Execute(5, Caption, '');
    if GP_TIERS.CanFocus then GP_TIERS.SetFocus else GotoEntete;
    Exit;
  end;
  // Correction LS pour forcer le changement du code affaire n validation si besoin
  if copy(ActiveControl.Name,1,10)='GP_AFFAIRE' then
  begin
    OnExitPartieAffaire (ActiveControl);
    if LastErrorAffaire <> 1 then exit;
  end;
  //
  {$IFDEF GPAOLIGHT}
    if (Pos(CleDoc.NaturePiece + ';', GetParamSoc('SO_WMISEENPROD')) <> 0) and wExisteOrdreCompletementGere_NonGenere(TobPiece) then
    begin
      ForcerFerme := True;
      Close;
      Exit;
    end;
  {$ENDIF GPAOLIGHT}
  {$IFDEF MODE}
  TraiteLaFusion(True);
  {$ENDIF}
  if not SortDeLaLigne then Exit;
  if not IsChpsObligOk(0,0) then // JT - eQualit� 10819
  begin
    CpltEnteteClick(nil);
    exit;
  end;
  if TOBGSAPleine then exit;
  {$IFDEF AFFAIRE}
  // mcd 21/03/02 test si affaire renseign�
  if (VenteAchat = 'ACH') and (TestAffaire(TobPiece)) then exit;
  {$ENDIF}
  if Enabled then NextPrevControl(Self);
  {$IFDEF BTP}
  IsAcompteRegl := AcompteRegle(TOBPiece);
  // gestion des acomptes en fonction de la demande d'un acompte obligatoire ou si un acompte a �t� d�fini sur le devis
  if (SaisieTypeAvanc) and ((TOBAcomptes.detail.count > 0) or (AcompteObligatoire and not (IsAcompteRegl))) then
      AvancementAcompte (self,TobTiers,TOBPiece,TOBPieceRG,LesAcomptes,TOBAcomptes) ;
  {$ENDIF}
  // --
  // Modif BTP : dans le cas ou l'on ne modifie que les textes sans sortir
  ValidationSaisie := True; //MODIFBTP
  { argglllll
  if DuplicPiece then
  begin
    TOBLienOLE_O.clearDetail;
    TOBLienOLE.clearDetail;
  end;
  }
  // @@@@@@@ A REVOIR @@@@@@@
//  RemplitLiens(TOBPiece, TOBLienOLE, Debut, 1);
//  RemplitLiens(TOBPiece, TOBLienOLE, Fin, 2);
  // -----

  //Calcul group� des tarifs
  if (GetParamSoc('SO_PREFSYSTTARIF')) and (GetParamSoc('SO_TARIFSGROUPES')) and (TobPiece.GetValue('GP_TARIFSGROUPES') = 'X') then
  begin
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculTarifGroupePiece(TobTiers, TobArticles, TobPiece, TobLigneTarif);
    CalculeLaSaisie(-1, -1, False);
  end;

  if (DuplicPiece) or ((TOBPiece.getValue('GP_DEVISE') <> V_PGI.DevisePivot) and (not EstMonnaieIN(TOBPiece.getValue('GP_DEVISE')))) then
  begin
    for indice := 0 to TOBpiece.detail.count -1 do
    begin
      ReinitCoefMarg (TOBpiece.detail[Indice],TOBOUvrage);
    end;
    FactReCalculPv := false;
    ZeroFacture (TOBpiece);
    for iInd := 0 to TOBPiece.detail.count -1 do ZeroLigneMontant (TOBPiece.detail[iInd]);
    TOBBases.ClearDetail;
    TOBBasesL.ClearDetail;
		ZeroMontantPorts (TOBPorcs);    
    PutValueDetail(TOBPiece, 'GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, False);
  end;
  TOBPiece.GetEcran(Self, PEntete);
  if ctxAffaire in V_PGI.PGIContexte then TOBPiece.GetEcran(Self, PEnteteAffaire);
  AfficheTaxes;
  AffichePorcs;
  PositionneVisa;
	ControleMargeOk:=ControleMargeBTP(TOBPiece, true);
  if not PieceModifiee then Exit;
  // Stat
  if not SaisieTablesLibres(TOBPiece) then Exit;
  DepileTOBLignes(GS, TOBPiece, GS.Row, 1);
  if TesteRisqueTiers(True) then Exit;
  if TesteMargeMini(GS.Row) then Exit;
  if not EstAvoir then // JT eQualit� 10764
  begin
    // Gestion net � payer <> 0 si reglement obligatoire
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
  end;
  // Contr�le int�grit�
  ResGC := GCPieceCorrecte(TOBPiece, TOBArticles, TOBCatalogu, (tModeSaisieBordereau in SaContexte));
  if ResGC > 0 then
  begin
    HErr.Execute(ResGC, Caption, '');
    Exit;
  end;
  { V�rification des quantit�s }
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
  TobBases_Dup := nil;
//  if (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') = 'NOR') and
//     (Action<>taConsult) and (GetParamSoc ('SO_GCCONTROLEFACTURE')) then
	if ((VenteAchat = 'ACH') and (not IsTransformable(NewNature)) and
  		(Action<>taConsult) and
     (GetParamSoc ('SO_GCCONTROLEFACTURE'))) then
  begin
      if not TobPiece.FieldExists ('TOTALTTC_CFA') then
      begin
        TobPiece.AddChampSupValeur ('TOTALTTC_CFA', TobPiece.GetValue ('GP_TOTALTTC'));
        TobPiece.AddChampSupValeur ('TOTALTTCDEV_CFA', TobPiece.GetValue ('GP_TOTALTTCDEV'));
      end;
      if not ControleFacture then exit;
      TOBBases_Dup := TOB.Create('',nil,-1);
      TOBBases_Dup.Dupliquer(TOBBases,True,True);
      TOBBases.ClearDetail;
      TOBBases.Dupliquer(TOBBasesSaisies,True,True);
      for iInd := 0 to TOBBases.Detail.Count - 1 do
      begin
          TobB := TOBBases.Detail[iInd];
          if DEV.Code<>V_PGI.DevisePivot then
          begin
              TobB.PutValue ('GPB_BASETAXE',
              DeviseToEuro (TobB.GetValue('GPB_BASEDEV'), DEV.Taux,
                            DEV.Quotite));
              TobB.PutValue ('GPB_VALEURTAXE',
              DeviseToEuro (TobB.GetValue ('GPB_VALEURDEV'),
                            DEV.Taux, DEV.Quotite)) ;
          end else
          begin
              TobB.PutValue ('GPB_BASETAXE', TobB.GetValue ('GPB_BASEDEV'));
              TobB.PutValue ('GPB_VALEURTAXE', TobB.GetValue ('GPB_VALEURDEV'));
          end;
      end;
      // Ajout LS Correction Controle facture Achat
      TOBPiece.PutValue ('GP_TOTALTTCDEV', TOBBasesSaisies.GetValue('TOTALTTC'));
      if DEV.Code<>V_PGI.DevisePivot then
      begin
        TOBPiece.PutValue ('GP_TOTALTTC',
        DeviseToEuro (TOBPiece.GetValue ('GP_TOTALTTCDEV'), DEV.Taux, DEV.Quotite)) ;
      end else
      begin
        TOBPiece.PutValue ('GP_TOTALTTC', TOBPiece.GetValue('GP_TOTALTTCDEV'));
      end;
      TobPiece.PutValue ('GP_REFINTERNE', TobBasesSaisies.GetValue ('REFINTERNE'));
      // ----
      VH_GC.ModeGestionEcartComptable := 'CPA'; {DBR CPA}
  end;

  if CompAnalP = 'AUT' then ClickVentil(True, False);

  bForceEche := ((DEV.Code <> '') and (DEV.Code <> V_PGI.DevisePivot) and
    (DEV.Code <> V_PGI.DeviseFongible) and (not EstMonnaieIn(DEV.Code)));
  bOuvreEche := (GereEche = 'AUT') or (bForceEche);
  {$IFNDEF CHR}
  if CtxMode in V_PGI.PGIContexte then Ok := GereEcheancesMODE(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPIECERG, Action, DEV, bOuvreEche)
  else Ok := GereEcheancesGC(TOBPiece, TOBTiers, TOBEches, TOBAcomptes, TOBPIECERG, Action, DEV, bOuvreEche);
  if not Ok then
  begin
//    if (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') = 'NOR') and
//       (Action<>taConsult) and (TobBases_Dup <> nil) and (GetParamSoc ('SO_GCCONTROLEFACTURE')) then
		if ((VenteAchat = 'ACH') and (not IsTransformable(newNature)) and
    	 (Action<>taConsult) and (TobBases_Dup <> nil) and
       (GetParamSoc ('SO_GCCONTROLEFACTURE'))) then
    begin
        TOBBases.Dupliquer(TOBBases_Dup,True,True);
        TOBBases_Dup.Free;
    end;
    Exit;
  end else GP_MODEREGLE.Value := TOBPiece.GetValue('GP_MODEREGLE');
  {$ENDIF}

  if TOBPiece.getValue('GP_ETATVISA')<>'VIS' then
  begin
    stMessageMiniCde := 'Le montant minimum n''est pas atteint#13 La pi�ce devra �tre vis�e. Voulez-vous continuer?';
    bTiersExceptionMontantMini := False;
    TobExceptionTiers := TOBTiers.FindFirst(['GTP_NATUREPIECEG'], [TobPiece.GetValue ('GP_NATUREPIECEG')], False) ;
    if TobExceptionTiers <> Nil then
    begin
      if Valeur (TobExceptionTiers.GetValue ('GTP_MONTANTMINI')) <> 0 then
      begin
          if Valeur (TobPiece.GetValue ('GP_TOTALHT')) < Valeur (TobExceptionTiers.GetValue('GTP_MONTANTMINI')) then
          begin
              if PGIAsk(stMessageMiniCde, '') = mrNo then exit;
              TobPiece.PutValue ('GP_ETATVISA', 'ATT');
          end;
          bTiersExceptionMontantMini := true;
      end;
    end;
    if (not bTiersExceptionMontantMini) then
    begin
        if (Valeur (GetInfoParPiece (TobPiece.GetValue ('GP_NATUREPIECEG'), 'GPP_MONTANTMINI')) <> 0) and
           (Valeur (TobPiece.GetValue ('GP_TOTALHT')) < Valeur (GetInfoParPiece (TobPiece.GetValue ('GP_NATUREPIECEG'), 'GPP_MONTANTMINI'))) then
        begin
            if PGIAsk(stMessageMiniCde, '') = mrNo then exit;
            TobPiece.PutValue ('GP_ETATVISA', 'ATT');
        end;
    end;
  end;
  if not ErreurSiZero (TOBpiece) then exit;
  // CORRECTIONS : FQ 11904
  if not VerrouilleValidation (TOBPiece.getValue('GP_NATUREPIECEG'), TOBPiece.getValue('GP_SOUCHE') + ';' + IntToSTr(TOBPiece.getValue('GP_NUMERO'))) then exit;
  // ---
  // Enregistrement de la saisie
  BValider.Enabled := False;
  ValideEnCours := True;
  io := Transactions(ValideNumeroPiece, 5);
  if io = oeOk then
  begin
    if ExisteLigneSupp then io := Transactions(ValideNumeroPieceAnnule, 5);
  end;
  NbTransact := 0;
//  if io = oeOk then io := Transactions(ValideLaPiece, 5);
  if io = oeOk then io := Transactions(ValideLaPiece, 0);
  VH_GC.ModeGestionEcartComptable := ''; {DBR CPA}
  BValider.Enabled := True;
  if io <> oeOk then
  begin
    PGIError (MessageValid);
    if not TOBPiece.FieldExists('REVALIDATION') then TOBPiece.AddChampSup('REVALIDATION', False);
    TOBPiece.PutValue('REVALIDATION', 'X');
    if TOBAdresses.Detail.Count < 2 then
    begin
      TOB.Create('PIECEADRESSE', TOBAdresses, -1); {Facturation}
      TOBAdresses.Detail[1].Dupliquer(TOBAdresses.Detail[0], True, True);
    end;
//    if (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') = 'NOR') and
//      (Action<>taConsult) and (TobBases_Dup <> nil) and (GetParamSoc ('SO_GCCONTROLEFACTURE')) then
	  if ((VenteAchat = 'ACH') and (not IsTransformable(NewNature))
    		and (Action<>taConsult) and (TobBases_Dup <> nil) and
       (GetParamSoc ('SO_GCCONTROLEFACTURE'))) then
    begin
       TOBBases.Dupliquer(TOBBases_Dup,True,True);
       TOBBases_Dup.Free;
    end;
  end;
  case io of
    oeOk:
      begin
        if TOBPiece.FieldExists('REVALIDATION') then TOBPiece.PutValue('REVALIDATION', '-');
        ForcerFerme := True;
        AvoirDejaInverse := False;
        AfterValide(Self, TOBPiece, TOBBases, TOBTiers, TOBArticles, DEV);
      	if TypeSaisieFrs then
        begin
        	ModeRetourFrs := TmsFValide;
        end else
        begin
        	if TOBpieceFraisAnnule.Detail.count > 0 then
          begin
          	for Indice := 0 to TOBpieceFraisAnnule.detail.count -1 do
            begin
              FillChar(CleDocS, Sizeof(CleDocS), #0);
              DecodeRefPiece (TOBpieceFraisAnnule.detail[Indice].getValue('FRSANULLE'),cledocS);
              BTPSupprimePieceFrais (cledocS);
            end;
            TOBpieceFraisAnnule.clearDetail;
					end;
        end;
      end;
    oeUnknown: ErrorValid(5);
    oeSaisie: ErrorValid(6);
    oePointage: ErrorValid(23);
    oeLettrage: ErrorValid(13);
    oeStock: ErrorValid(27);
  end;
  // CORRECTIONS : FQ 11904
  DeverouilleValidation(TOBPiece.getValue('GP_NATUREPIECEG'));
//  if io <> oeOk then exit;
// sortie de la saisie en cas d'erreur de la validation
  if io <> oeOk then BEGIN Close; exit; END;
  ValideEnCours := False;
  BValider.Enabled := False;
  // Modif BTP
  if (EnregSeul) and (Action <> taCreat) then
  begin
    Exit;
  end;
  // -----
  {$IFDEF GPAO}
  if Action <> taCreat then
  begin
    if (io = oeOK) and (not TransfoPiece) and (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
      PiloteModifOrdreST(TobPiece);

    if (io = oeOK) and (TransfoPiece) and (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
      PiloteRecepOrdreST(TobPiece);
  end else
  begin
    if (io = oeOK) and (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
      PiloteCreatOrdreST(TobPiece, 'FAC');
  end;
  {$ENDIF GPAO}
  if (GetInfoParPiece(NewNature, 'GPP_IMPIMMEDIATE') = 'X') then
  begin
    if ((Action = taCreat) or (Action = taModif) or (DuplicPiece) or (TransfoPiece)) and
      not (SaisieTypeAvanc) and ControleMargeOk then
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
  FINALLY
//   if (not Enabled) and (StatusFiche) then Enabled := true;
     BValider.Enabled := True;
     bAppelControleFacture := false;
  END;
end;

procedure TFFacture.BValiderClick(Sender: TObject);
var messageErrCha : string;
		Acol,Arow : integer;
begin
  // correction brl 31/03/2011 : pour forcer la sortie de l'ent�te dans tous les cas
  // utile pour contr�le autre devis accept� dans PEnteteExit
  if (self.ActiveControl.Name <> 'GS') Then
  begin
    GS.setFocus;
  end;

  if StatutAffaire = 'I' then
	   messageErrCha := 'Contrat'
  Else if StatutAffaire = 'W' then
	   messageErrCha := 'Appel';

 	if (pos(StatutAffaire,'I;W')>0) then
  begin
  	if GP_AFFAIRE.text = '' then
    begin
    	PgiInfo('ATTENTION, Vous n''avez pas renseign� de code '+MessageErrCha);
      If (Not EstAvoir) or (StatutAffaire <> 'W') then Exit;
    end;
  end;
//	Enabled := false;
//  TRY
  if ReceptionModifie then
  begin
    ShowInfoLivraisons;
  end;

	GereCalculPieceBTP (true);
{$IFDEF BTP}
	ClickValideAndStayHere (Self,TOBPiece, TOBNomenclature, TobOuvrage,TOBTiers, TOBAffaire,TOBLigneRg);
   //Mise � jour de l'�ch�ance factur� si une modification � eu lieu
   if TobAffaire.getvalue('AFF_AFFAIRE0')='I' Then
      Begin
      if (TobPiece.GetValue('GP_NATUREPIECEG')='FPR') OR (TobPiece.GetValue('GP_NATUREPIECEG')='FAC') then
         Begin
         TraitementMajEcheance(TobPiece, TobAffaire);
         end;
      end;
   if EstAvoir then close; // Fiche qualite 10865
   Arow := GS.row;
   Acol := GS.col;
   GoToLigne(Arow,Acol);

   GS.row := Arow;
   GS.col := Acol;
   StCellCur := GS.Cells[GS.Col, GS.Row];
   BouttonVisible(GS.Row);
{$ELSE}
	ClickValide;
{$ENDIF}
//	FINALLY
//		Enabled := True;
//  END;
end;

Procedure TFFacture.TraitementMajEcheance(TobPiece, TobAffaire : Tob);
Var Numdoc   : String;
    MtEchDev : Double;
    MtEch    : Double;
    REq : string;
Begin

    MtEchDev := TobPiece.GetDouble('GP_TOTALHTDEV');
    MtEch    := TobPiece.GetDouble('GP_TOTALHT');

    Numdoc := EncodeRefPiece(TOBPIECE);
    Req := 'UPDATE FACTAFF SET AFA_MONTANTECHEDEV=' + StrfPoint(MtEchDev);
    Req := Req + ', AFA_MONTANTECHE=' + StrfPoint(MtEch);
    Req := Req + ' WHERE AFA_NUMPIECE="' + Numdoc + '"';

    ExecuteSQL(Req);

End;

procedure TFFacture.BAbandonClick(Sender: TObject);
begin
	if InValidation then exit;
  ValidationSaisie := False; //MODIFBTP
  {$IFDEF BTP}
  ModifieVariables := false;
  {$ENDIF}
//  if TypeSaisieFrs then ModeRetourFrs := TmsFAnul;
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
        Q := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                       'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                       'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_CODEBARRE="'+CodeBarre+'"' + WhereNat,true,-1, '', True);
//        Q := OpenSQL('Select * from ARTICLE LEFT JOIN ARTICLECOMPL ON GA2_ARTICLE=GA_ARTICLE Where GA_CODEBARRE="' + CodeBarre + '" ' + WhereNat, True);
        try
          //Multi code barres sp�cifique DEFI MODE
          if Q.EOF then
          begin
            if GetParamSoc('SO_ARTMULTICODEBARRE') then
            begin
              Ferme(Q);
              Q := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                             'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                             'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_CODEDOUANIER="'+CodeBarre+'"' + WhereNat,true,-1, '', True);
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
        finally
        	Ferme(Q);
        end;
      end
      else InsertNewArtInGSAveugle(CodeBarre, nil, TOBArt, nil, ARow);
    end;
  end;
  if (ACol = Col_Qte) and (TF.GetValue('QTE') <> Valeur(GSAveugle.Cells[Col_Qte, ARow])) then
  begin
    NewQte := Valeur(GSAveugle.Cells[Col_Qte, ARow]);
    {$IFDEF MODE}
    if not QuantiteAutorise(NewQte) then
    begin
      HPiece.Execute(56, Caption, '');
      GSAveugle.SetFocus;
      Cancel := True;
    end;
    {$ENDIF}
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
    Q := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
    						  'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
    						  'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_CODEARTICLE="'+CodeGen+'" AND GA_STATUTART="GEN"' + WhereNat,true,-1, '', True);
    try
      if not Q.EOF then
      begin
        TOBArt := CreerTOBArt(TOBArticles);
        TOBArt.SelectDB('', Q);
        InitChampsSupArticle (TOBArt);
      end
      else MessageAlerte(HAveugle.Mess[4]);
    finally
    	Ferme(Q);
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
      // VARIANTE
      (* TOBL.PutValue('GL_TYPELIGNE', 'COM'); *)
      SetLigneCommentaire (TobPiece,TOBL,Arow);
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

(*
function TFFacture.InsertNewArtInGS(RefArt, Designation: string; Qte: Double) : boolean;
var ACol, ARow, ARowGEN: Integer;
  Cancel, bc: Boolean;
  Etat, CodeGen, StMotif: string;
  TOBArt, TOBLGEN, TOBL: TOB;
begin
  Result := true;
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
  //
    if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow, RefArt) then
    begin
      Result := false;
      exit;
    end;
  //
    CodeGen := TOBArt.GetValue('GA_CODEARTICLE');
    Etat := TOBArt.GetValue('GA_STATUTART');
    if Etat = 'UNI' then Etat := 'NOR';
    if (Etat = 'DIM') then
    begin
      //Recherche Article GEN, s'il existe : insertion de la dimension
      //                       sinon : cr�ation de la ligne GEN puis de la dimension
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
    TraiteLesOuv(Arow);
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
*)
function TFFacture.InsertNewArtInGS(RefArt, Designation: string; Qte: Double; Therow : integer=-1; TOBLigneBord : TOB= nil) : boolean;
var ACol, ARow, ARowGEN: Integer;
  Cancel, bc: Boolean;
  Etat, CodeGen, StMotif: string;
  TOBArt, TOBLGEN, TOBL: TOB;
  SavPrix : double;
  RecupPrix : string;
  Enpa,EnHt : boolean;
  ResultQ,QteDuDetail  : double;
begin
  RecupPrix := GetInfoParPiece(TOBPIece.GetValue('GP_NATUREPIECEG'), 'GPP_APPELPRIX');
  enPa := ((RecupPrix='PAS') or (RecupPrix = 'DPA'));
  EnHt := (TOBPiece.getValue('GP_FACTUREHT')='X');
  SavPrix := 0;

  Result := true;
  Cancel := False;
  bc := False;
  ACol := SG_RefArt;
  TOBLGEN := nil;
  // MODIF LS
  if theRow <> -1 then Arow := TheRow else
  //
  if (TOBPiece.Detail.Count = 1) and (GS.Cells[SG_RefArt, 1] = '') then ARow := 1
  else if (GS.Cells[SG_RefArt, TOBPiece.Detail.Count] = '') then ARow := TOBPiece.Detail.Count
  else ARow := TOBPiece.Detail.Count + 1;
  TOBArt := FindTOBArtSais(TOBArticles, RefArt);
  if (TOBArt <> nil) then
  begin
  //
    if not ArticleAutorise(TOBPiece, TOBArticles, CleDoc.NaturePiece, ARow) then
    begin
      Result := false;
      exit;
    end;
  //

    CodeGen := TOBArt.GetValue('GA_CODEARTICLE');
    Etat := TOBArt.GetValue('GA_STATUTART');
    if Etat = 'UNI' then Etat := 'NOR';

    if (Etat = 'DIM') then
    begin
      //Recherche Article GEN, s'il existe : insertion de la dimension
      //                       sinon : cr�ation de la ligne GEN puis de la dimension
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
    end;
//    else GS.Cells[SG_RefArt, ARow] := CodeGen;

    if ARow = 1 then GSEnter(GS)
    else if ARow = TOBPiece.Detail.Count + 1 then
    begin
      GSRowEnter(GS, ARow, bc, False);
      GS.Col := ACol;
      GS.Row := ARow;
      GSCellEnter(GS, ACol, ARow, Cancel);
    end
    else ClickInsert(ARow);
    // PL le 18/06/04 :
    // ligne d�plac�e apr�s le ClickInsert car on continue � travailler sur le ARow courant
    // et non pas sur la ligne suivante
    if (Etat <> 'DIM') then
      GS.Cells[SG_RefArt, ARow] := CodeGen;
    //////////////


    GS.Col := ACol;
    GS.Row := ARow;

    //Dimensions
    if Etat = 'GEN' then
    begin
      StCellCur := '';
      GSCellExit(nil, ACol, ARow, Cancel);
      if Cancel then
      begin
        GS.Cells[SG_RefArt, ARow] := '';
        DepileTOBLignes(GS, TOBPiece, ARow, 1);
        Result := false;
      end;
      exit;
    end;
    TOBL := GetTOBLigne(TOBPiece, ARow);
    CalculePrixArticle(TOBArt, TobPiece.GetValue('GP_DEPOT'));
//
    CodesArtToCodesLigne(TOBArt, ARow);
//
    if TOBPiece.getValue('GP_DOMAINE')<>'' then
    begin
    	TOBL.putvalue('GL_DOMAINE',TOBPiece.getValue('GP_DOMAINE'));
    end;
    if TOBART.getValue('GA_PRIXPASMODIF')<>'X' Then
    begin
      AppliqueCoefDomaineLig (TOBL);
    end;
//
    ChargeTOBDispo(ARow);
    // Modif AC 20/01/04
    // Probl�me de mise � jour de la quantite
    // InitialiseLigne test GL_REFARTSAISIE<>''
    if TOBLIgneBord = nil then TOBL.PutValue('GL_REFARTSAISIE', TOBL.GetValue('GL_CODEARTICLE'));
    InitLaLigne(ARow, Qte);
    if TOBL <> nil then
    begin

      if TOBL.GetValue('FROMTARIF')='X' then
      begin
         if EnPA then
         begin
              SavPrix := TOBL.GetValue('GL_DPA');
         end else
         begin
              SavPrix := TOBL.getValue('GL_PUHTDEV');
         end;
      end;

      TOBL.PutValue('GL_TYPEDIM', Etat);
      TOBL.PutValue('GL_LIBELLE', Designation);
      GS.Cells[SG_Lib, ARow] := Designation;
      TOBL.PutValue('GL_REFARTSAISIE', TOBL.GetValue('GL_CODEARTICLE'));
      TOBL.PutValue('GL_FOURNISSEUR', TOBArt.GetValue('GA_FOURNPRINC'));
      // MODIF BTP
      if (TOBLigneBord <> nil) then
      begin
        // on replace les reference du tiers dans la ligne
        TOBL.PutValue('GL_REFARTTIERS',TOBLIgneBord.getValue('GL_REFARTTIERS'));
        TOBL.PutValue('GL_REFARTSAISIE',TOBLIgneBord.getValue('GL_REFARTTIERS'));
        TOBL.PutValue('GL_LIBELLE',TOBLIgneBord.getValue('GL_LIBELLE'));
        TOBL.PutValue('GL_PUHTDEV',TOBLIgneBord.getValue('GL_PUHTDEV'));
        TOBL.PutValue('GL_QUALIFQTEVTE',TOBLIgneBord.getValue('GL_QUALIFQTEVTE'));
        TOBL.PutValue('GLC_FROMBORDEREAU','X');
        TOBL.PutValue('GL_BLOQUETARIF','X');
        TOBL.PutValue('GL_BLOCNOTE',TOBLIgneBord.getValue('GL_BLOCNOTE'));
        GS.Cells[SG_RefArt, ARow] := TOBLIgneBord.getValue('GL_REFARTTIERS');
      end;
    end;
    // ---
    TraiteLesCons(ARow);

    // Gestion des m�tr�s => FV
    if (Cledoc.NaturePiece = GetParamSoc('SO_AFNATAFFAIRE')) or
    	 (cledoc.NaturePiece = 'FBT') or
       (Cledoc.NaturePiece = GetParamSoc('SO_AFNATPROPOSITION')) then
    begin
    	if GetParamSocSecur('SO_METRESEXCEL',true) then
      begin
        if (not OrigineEXCEL) and (VenteAchat = 'VEN') then
        begin
          if TheMetre.ControlMetre then
          begin
            TheMetre.DocMetreBiblio (TOBL);
          end;
        end;
      end;
    end;
    //

    TraiteLesOuv(Arow,false,TOBLigneBord);
    TraiteLesNomens(ARow);
    TraiteLesMacros(ARow);
    if GS.Cells[SG_RefArt, ARow] = '' then exit;   // JSI 29/09/04 pour ClickDel
    TraiteLesLies(ARow);
    //
    if TOBL.GetValue('GL_BLOQUETARIF')<> 'X' then
    begin
			AppliquePrixFromTarif (self,TOBPiece,TOBL,TOBBases,TOBBasesL,TOBouvrage,EnPa,EnHT,Savprix,DEV,Arow);
    end;
    //
		if (TheDestinationLiv <> nil) then TheDestinationLiv.SetDestLivrDefaut (TOBL);

    resultQ := 0;
    if (not OrigineEXCEL) and (VenteAchat = 'VEN') then
    begin
      if (Cledoc.NaturePiece =  GetParamSoc('SO_AFNATAFFAIRE')) or
      	 (cledoc.NaturePiece = 'FBT') or
         (Cledoc.NaturePiece =  GetParamSoc('SO_AFNATPROPOSITION')) then
      begin
  			if GetParamSocSecur('SO_METRESEXCEL',true) then
        begin
        	resultQ := TheMetre.CalculeMetre(TOBL, self);
        end;
      end;
    end;

    if resultQ <> 0 then
    begin
      TOBL.putValue('GL_QTEFACT', resultQ);

      // Modif FV
      TOBL.putvalue('GL_QTESTOCK', resultQ);
      TOBL.putvalue('GL_QTERESTE', resultQ);
      if GetQteDetailOuv (TOBL,TOBOuvrage) = 0 then
      Begin
        QteDuDetail := TobL.GetValue('GL_QTEFACT');
        // fv 02032004
        //if QteDuDetail = 0 then QteDuDetail := 1;
        PosQteDetailAndCalcule (TOBL,TOBOUvrage,QteDuDetail,DEV);
        TOBL.Putvalue('GL_RECALCULER','X');
        TOBPiece.Putvalue('GP_RECALCULER','X');
  //      CalculeLaSaisie(-1,-1, false);
      End;
      AfficheLaLigne(GS.row);
      if GS.cells[GS.col, GS.row] <> StCellCur then ATraiterQte := False;
      if (EnPa)  then
          TraitePrixAch(ARow)
      else
          TraitePrix(ARow,Savprix);
    end;

    TraiteLaCompta(ARow);
    TraiteLeCata(ARow);
    if not TraiteRupture(ARow) then
    begin
      GS.Cells[SG_QF, ARow] := '';
      TraiteQte(SG_QF, ARow);
//
//      VideCodesLigne(TOBPiece, ARow);
//      InitialiseTOBLigne(TOBPiece, TOBTiers, TOBAffaire, ARow);
//      AfficheLaLigne (Arow);
//      result := false;
//      exit;
    end;

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
   // StCellCur := GS.Cells[ACol, ARow];
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
      // Insere la quantit� dans le grid de saisie
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
        Reponse := HShowMessage('1;' + TSaisieAveugle.Caption + ';' + TraduireMemoire('La quantit� de cet article : "' + Designation +
          '" est sup�rieure � celle du document, voulez-vous ajouter le suppl�ment ?') + ';Q;YNTZ;N;N;', '', '');
        case Reponse of
          mrYesToAll: OuiPourTousQteSup := True;
          mrNoToAll: NonPourTousQteSup := True;
          mrNo: Exit;
        end;
      end;
    end;
    if (OuiPourTousQteSup) or (Reponse = mrYes) or (NewArt) then
    begin
      // Insere la quantit� dans le grid de saisie
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
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
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(ColQuantite, TOBPiece.Detail.Count, True);
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
  // VARIANTE
  (* if not ((TypeLigne = 'COM') or (TypeLigne = 'TOT')) then *)
  if (not isCommentaire(TOBL)) or (TypeLigne = 'TOT') then
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
  TOBPiece.PutValue('GP_RECALCULER', 'X');
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
  RegisterAglProc('AppelDupliquePiece', False, 3, AppelDupliquePiece);
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
    BtRetour.Visible := Not IsTransfert(TOBPiece.GetValue('GP_NATUREPIECEG')); 
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
    PGIInfo('Cette pi�ce n''est plus modifiable car la date de la pi�ce est inf�rieure � la date du jour.', Caption);
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
  if (tModeSaisieBordereau in SaContexte) then exit;
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
      TOBL.PutValue('GL_FAMILLETAXE1', NewCode);
      if (TOBL.Getvalue('GL_TYPEARTICLE') = 'OUV') or (TOBL.GetValue('GL_TYPEARTICLE') = 'ARP') then
      	AppliqueChangeTaxeOuv(TOBPiece, TOBOuvrage, i + 1, TOBL.GetValue('GL_FAMILLETAXE1'),TOBL.GetValue('GL_FAMILLETAXE2'),TOBL.GetValue('GL_FAMILLETAXE3'),TOBL.GetValue('GL_FAMILLETAXE4'),TOBL.GetValue('GL_FAMILLETAXE5'));
      TOBL.putValue('GL_RECALCULER', 'X');
      Okok := True;
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
  if (tModeSaisieBordereau in SaContexte) then exit;
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

procedure TFFacture.BZoomPropositionClick(Sender: TObject);
var stArg : string;
begin
  stArg:='';
  Case Action of
     taConsult  : stArg:='ACTION=CONSULTATION;' ;
     taModif  : stArg:='ACTION=MODIFICATION;' ;
     end ;
  AGLLanceFiche('RT','RTPERSPECTIVES','',TOBPiece.GetValue('GP_PERSPECTIVE'),stArg+'MONOFICHE;NOZOOMDEVIS')
end;

procedure TFFacture.MBAnalDocClick(Sender: TObject);
{$IFDEF BTP}
var TheTitre : string;
{$ENDIF}
begin
  // Analyse du document complet
  {$IFDEF BTP}
	GereCalculPieceBTP;
  TheTitre := FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption;
  if TOBPiece.getValue('GP_AFFAIRE') <> '' then
  begin
    TheTitre := TheTitre + ' Affaire : '+BTPCodeAffaireAffiche(TOBPIece.GetValue('GP_AFFAIRE'))+' '+TOBaffaire.Getvalue('AFF_LIBELLE');
  end else
  begin
    TheTitre := TheTitre + ' Tiers : '+TOBPiece.getValue('GP_TIERS')+' '+TOBTiers.Getvalue('T_LIBELLE');
  end;
//  EntreeAnalyseDocument(SrcDoc, TOBPiece, TOBOUvrage, ['LIBELLE=' + FTitrePiece.Caption + ' ' + GP_NUMEROPIECE.Caption], 1);
  EntreeAnalyseDocument(SrcDoc, TOBARTicles, TOBPiece, TOBOUvrage, ['LIBELLE=' + TheTitre], 1);
  {$ENDIF}
end;

procedure TFFacture.MBAnalLocClick(Sender: TObject);
begin
  {$IFDEF BTP}
  GereCalculPieceBTP;
  AnalyseDocumentBtp (self,TOBArticles,TobPiece,TOBOuvrage);
  {$ENDIF}
end;

procedure TFFacture.SuppressionDetailOuvrage(TOBL : TOB);
var Indice, IndRech, IndiceNomen: Integer;
  TOBDet: TOB;
  var Acol,Arow : integer;
begin
  Acol := GS.col;
  Arow := GS.row;
  IndiceNomen := TOBL.GetNumChamp('GL_INDICENOMEN');
  IndRech := TOBL.GetValeur(IndiceNomen);
  Indice := TOBL.GetValue('GL_NUMLIGNE')+1;
  repeat
    TOBDet := GetTOBLigne(TOBPiece, Indice);
    if TOBDet = nil then break;
    if (TOBDet.getvaleur(IndiceNomen) = Indrech) and ((isCommentaire(TOBDet)) or (IsSousDetail(TOBDet)))  then
    begin
      TOBDet.free;
    end else Inc(Indice);
  until indice >= GS.RowCount;
//  GS.videpile(false);
	NettoieGrid;
  GS.rowcount := TOBPiece.detail.count + 2;
  if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
//  GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
  numerotelignesGc(nil, TOBPiece);
  for Indice := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(Indice + 1);
  GoToLigne(Arow, Acol);
end;

procedure TFFacture.SuppressionDetailOuvrage(Arow: integer; AvecGestionAffichage: boolean = true; TheTOBL : TOB=nil);
var Indice, IndRech, IndiceNomen: Integer;
  TOBL, TOBDet: TOB;
  bc: boolean;
begin
  if TheTOBL = nil then TOBL := GetTOBLigne(TOBPiece, Arow)
                   else TOBL := TheTOBL;
  IndiceNomen := TOBL.GetNumChamp('GL_INDICENOMEN');
  IndRech := TOBL.GetValeur(IndiceNomen);
  Indice := 1;
  repeat
    TOBDet := GetTOBLigne(TOBPiece, Indice);
    if TOBDet = nil then break;
    // VARIANTE
    (*if (TOBDet.getvaleur(IndiceNomen) = Indrech) and (TOBDet.getvaleur(ITypeLig) = 'COM') then *)
    if (indrech <>0) and ( TOBDet.getvaleur(IndiceNomen) = Indrech ) and ( (isSousDetail(TOBDet)) or (isCommentaire(TOBDet)) ) then
    begin
      TOBDet.free;
    end else Inc(Indice);
  until Indice > GS.RowCount;
  if AvecGestionAffichage then
  begin
//    GS.videpile(false);
		NettoieGrid;
    GS.rowcount := TOBPiece.detail.count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
//    GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
    numerotelignesGc(nil, TOBPiece);
    for Indice := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(Indice + 1);
    GSRowEnter(GS, ARow, bc, False);
    GS.row := Arow;
  end;
end;

procedure TFFacture.nettoieGrid;
var Indice : integer;
begin
  for Indice := TOBPiece.detail.count + 1 to GS.rowCount do
  begin
    GS.Rows[Indice].Clear;
  end;
end;

procedure TFFacture.AffichageDetailOuvrage(RowReference: Integer);
var Insligne, Indice, IndiceNomen, TypePresent: Integer;
  TOBL, TOBOuv, TOBLOC, TOBRef: TOB;
  Montant, QteDuDetail, QteDUPv, MontantOuv, MontantLig, MontantAchat,MontantOuvAch,MontantLigAch: double;
  EnHt: boolean;
  Ouvrage: boolean;
  CumMont: double;
  RowRef: integer;
  ArticleOk: string;
  IndicePou: Integer;
  variante : boolean;
  MontantPa,MontantHtDev,MontantTTCDev : double;
  VoirDetail : boolean;
begin
  //
  MontantAchat := 0;
//  if (SaisieTypeAvanc) or (ModifAvanc) then exit;
  Montant := 0;
  IndicePou := -1;
  EnHT := (TOBPiece.GetValue('GP_FACTUREHT') = 'X');
  TOBRef := GetTOBLigne(TOBPiece, RowReference);
  // VARIANTE
  Variante := IsVariante (TOBRef);
  // --
  if TOBRef.GetValue('GL_TYPEARTICLE') = 'ARP' then exit;
  TypePresent := TOBRef.GetValue('GL_TYPEPRESENT');
  VoirDetail := (TOBRef.GetValue('GLC_VOIRDETAIL')='X');
  if (ModifSousDetail) and (not VoirDetail) then exit;
  if (not ModifSousDetail) and (TypePresent = DOU_AUCUN) then exit;
//  if TypePresent = DOU_AUCUN then Exit;
  CumMont := 0;
  IndiceNomen := TOBRef.Getvalue('GL_INDICENOMEN');
  if IndiceNomen = 0 then exit;

  if EnHt then
  begin
    MontantOuv:=Arrondi(TOBRef.GetValue('GL_PUHTDEV')*TOBRef.GetValue('GL_QTEFACT')*
                        (1.0-(TOBRef.GetValue('GL_REMISELIGNE')/100))/TOBRef.GetValue('GL_PRIXPOURQTE'),DEV.decimale) ;
  end else
  begin
    MontantOuv:=Arrondi(TOBRef.GetValue('GL_PUTTCDEV')*TOBRef.GetValue('GL_QTEFACT')*
                        (1.0-(TOBRef.GetValue('GL_REMISELIGNE')/100))/TOBRef.GetValue('GL_PRIXPOURQTE'),DEV.decimale) ;
  end;
  MontantOuvAch:=Arrondi(TOBRef.GetValue('GL_DPA')*TOBRef.GetValue('GL_QTEFACT')/TOBRef.GetValue('GL_PRIXPOURQTE'),DEV.decimale) ;

  MontantLig := 0; MontantLigAch := 0;
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

    QteDuDetail := 1;
    QteDuPV := 1;
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
      // VARIANTE
      if (modifSousDetail) then
      begin
        if (variante) or (IsVariante(TOBLoc)) then TOBL.PutValue('GL_TYPELIGNE', 'SDV')
                                              else TOBL.PutValue('GL_TYPELIGNE', 'SD');
      end else
      begin
        if (variante) or (IsVariante(TOBLoc)) then TOBL.PutValue('GL_TYPELIGNE', 'COV')
                                              else TOBL.PutValue('GL_TYPELIGNE', 'COM');
      end;
      //
      TOBL.PutValue('GL_FAMILLETAXE1', TOBLoc.GetValue('BLO_FAMILLETAXE1'));
      TOBL.PutValue('GL_QUALIFQTEVTE', TOBLoc.GetValue('BLO_QUALIFQTEVTE'));
      TOBL.PutValue('GL_CODEARTICLE', TOBLoc.GetValue('BLO_CODEARTICLE'));
      TOBL.PutValue('GL_ARTICLE', TOBLoc.GetValue('BLO_ARTICLE'));
      TOBL.PutValue('GL_TYPEARTICLE', TOBLoc.GetValue('BLO_TYPEARTICLE'));
      TOBL.PutValue('GL_INDICENOMEN', IndiceNomen);
      TOBL.PutValue('UNIQUEBLO', TOBLoc.GetValue('BLO_UNIQUEBLO'));
      TOBL.PutValue('GLC_NATURETRAVAIL', TOBLoc.GetValue('BLO_NATURETRAVAIL'));
      if TOBRef.getValue('GL_BLOQUETARIF')='X' then
      begin
        TOBL.putValue('GL_BLOQUETARIF','X');
      end;
      if TOBloc.GetValue('BLO_NATURETRAVAIL') <> '' then TOBL.PutValue('LIBELLEFOU', TOBLoc.GetValue('LIBELLEFOU'));
      if TOBLoc.GetValue('BLO_TYPEARTICLE') = 'POU' then IndicePou := InsLigne;
      if Ouvrage then
      begin
        MontantPA :=Arrondi((TOBLOC.GetValue('BLO_QTEFACT')*TOBLOC.GetValue('BLO_DPA'))/TOBLOC.GetValue('BLO_PRIXPOURQTE'),V_PGI.okdecP);
        if TOBLoc.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
        	MontantAchat := Arrondi((MontantPA * TOBRef.getValue('GL_QTEFACT'))/(QteDuPv*QteDuDetail),V_PGI.okdecP);

          if Enht then
          begin
            MontantHtDev :=Arrondi((TOBLOC.GetValue('BLO_QTEFACT')*TOBLOC.getValue('BLO_PUHTDEV'))/TOBLOC.GetValue('BLO_PRIXPOURQTE'),V_PGI.okdecP);
            Montant := arrondi((MontantHtDev * TOBRef.getValue('GL_QTEFACT'))/(QteDuPv*QteDuDetail),V_PGI.okdecP)
          end else
          begin
            MontantTTCDev :=Arrondi((TOBLOC.GetValue('BLO_QTEFACT')*TOBLOC.getValue('BLO_PUTTCDEV'))/TOBLOC.GetValue('BLO_PRIXPOURQTE'),V_PGI.okdecP);
            Montant := arrondi((MontantTTCDev * TOBRef.getValue('GL_QTEFACT'))/(QteDuPv*QteDuDetail),V_PGI.OkdecP);
          end;
          // VARIANTE
          if ((not IsVariante (TOBLoc)) and (not IsVariante (TOBL))) or (IsVariante (TOBLoc) and (IsVariante (TOBL)))then
          //if not IsVariante (TobLoc) then
          begin
            MontantLig := MontantLig + Montant;
            MontantLigAch := MontantLigAch + MontantAchat;
          end;
          // --
          if ArticleOKInPOUR(TOBLOC.GetValue('BLO_TYPEARTICLE'), ArticleOk) then CumMont := CumMont + Montant;
        end;
      end;
      if ((TypePresent and DOU_CODE) = DOU_CODE) or (ModifSousDetail) then
      begin
        if ouvrage then TOBL.PutValue('GL_REFARTSAISIE', TOBLoc.GetValue('BLO_CODEARTICLE'))
        else TOBL.PutValue('GL_REFARTSAISIE', TOBLoc.GetValue('GLN_CODEARTICLE'))
      end;
      if ouvrage then TOBL.PutValue('GL_REFARTTIERS', TOBLoc.GetValue('BLO_ARTICLE'))
      else TOBL.PutValue('GL_REFARTTIERS', TOBLoc.GetValue('GLN_ARTICLE'));
      if ((TypePresent and DOU_LIBELLE) = DOU_LIBELLE) or (ModifSousDetail) then
      begin
        if ouvrage then TOBL.PutValue('GL_LIBELLE', TOBLoc.GetValue('BLO_LIBELLE'))
        else TOBL.PutValue('GL_LIBELLE', TOBLoc.GetValue('GLN_LIBELLE'));
      end;
      if ((typepresent and DOU_QTE) = DOU_QTE) or (ModifSousDetail) then
      begin
        if ouvrage then
        begin
          if TOBLoc.GetValue('BLO_TYPEARTICLE') = 'POU' then TOBL.PutValue('GL_QTEFACT', TOBLoc.GetValue('BLO_QTEFACT') / QteDuDetail)
          else TOBL.PutValue('GL_QTEFACT', (TOBLoc.GetValue('BLO_QTEFACT') * TOBRef.GetValue('GL_QTEFACT')) / QteDuDetail);
          TOBL.PutValue('GL_QTERESTE',TOBL.getValue('GL_QTEFACT'));
          TOBL.PutValue('GL_QTESTOCK',TOBL.getValue('GL_QTEFACT'));
        end
        else TOBL.PutValue('GL_QTEFACT', TOBLoc.GetValue('GLN_QTEFACT'));
      end;
      if ((typepresent and DOU_UNITE) = DOU_UNITE) or (ModifSousDetail) then
      begin
        if ouvrage then TOBL.PutValue('GL_QUALIFQTEVTE', TOBLoc.GetValue('BLO_QUALIFQTEVTE'))
        else TOBL.PutValue('GL_QUALIFQTEVTE', TOBLoc.GetValue('GLN_QUALIFQTEVTE'));
      end;
      if (((typepresent and DOU_PU) = DOU_PU) and (ouvrage)) or (ModifSousDetail) then
      begin
        if TOBLOC.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
        	TOBL.PutValue('GL_DPA', TOBLoc.GetValue('BLO_DPA') / QteDupv);
          if EnHt then TOBL.PutValue('GL_PUHTDEV', Arrondi(TOBLoc.GetValue('BLO_PUHTDEV') / QteDupv,V_PGI.okdecP))
          else TOBL.PutValue('GL_PUTTCDEV', Arrondi(TOBLoc.GetValue('BLO_PUTTCDEV') / QteDupv,V_PGI.okdecP));
        end;
      end;
      if (((typepresent and DOU_MONTANT) = DOU_MONTANT) and (ouvrage)) or (ModifSousDetail)  then
      begin
        if TOBLOC.GetValue('BLO_TYPEARTICLE') <> 'POU' then
        begin
          TOBL.PutValue('GL_MONTANTPA', MontantAchat);
          if EnHt then TOBL.PUtValue('GL_MONTANTHTDEV', Montant)
          else TOBL.PUtValue('GL_MONTANTTTCDEV', Montant);
        end;
      end;
      if ModifAvanc then
      begin
        TOBL.putValue('BLF_MTMARCHE',TOBLoc.getValue('BLF_MTMARCHE'));
        TOBL.putValue('BLF_MTDEJAFACT',TOBLoc.getValue('BLF_MTDEJAFACT'));
        TOBL.putValue('BLF_MTSITUATION',TOBLoc.getValue('BLF_MTSITUATION'));
        TOBL.putValue('BLF_MTCUMULEFACT',TOBLoc.getValue('BLF_MTCUMULEFACT'));
        TOBL.putValue('BLF_QTEMARCHE',TOBLoc.getValue('BLF_QTEMARCHE'));
        TOBL.putValue('BLF_QTEDEJAFACT',TOBLoc.getValue('BLF_QTEDEJAFACT'));
        TOBL.putValue('BLF_QTESITUATION',TOBLoc.getValue('BLF_QTESITUATION'));
        TOBL.putValue('BLF_QTECUMULEFACT',TOBLoc.getValue('BLF_QTECUMULEFACT'));
        TOBL.putValue('BLF_POURCENTAVANC',TOBLoc.getValue('BLF_POURCENTAVANC'));
      end;
      //
      InsLigne := Insligne + 1; // Pour les avoir dans l'ordre
    end;
    if IndicePou <> -1 then
    begin
      TOBLoc := TOBOuv.FindFirst(['BLO_TYPEARTICLE'], ['POU'], false);
      TOBL := GetTOBLigne(TOBPiece, IndicePOu);
      Montant := arrondi(CumMont * (TOBLoc.GetValue('BLO_QTEFACT') / (QteDuPv * QteDuDetail)), DEV.Decimale);
      MontantLig := MontantLig + Montant;
      if (((typepresent and DOU_PU) = DOU_PU) and (ouvrage)) or (ModifSousDetail) then
      begin
        if EnHt then TOBL.PutValue('GL_PUHTDEV', CumMont)
        else TOBL.PutValue('GL_PUTTCDEV', CumMont);
      end;
      if (((typepresent and DOU_MONTANT) = DOU_MONTANT) and (ouvrage)) or (ModifSousDetail) then
      begin
        if EnHt then TOBL.PUtValue('GL_MONTANTHTDEV', Montant)
        else TOBL.PUtValue('GL_MONTANTTTCDEV', Montant);
      end;
    end;
    // R�ajustement total des lignes / Montant Ouvrage
    if (CalculPieceAutorise) and  (RowRef <> -1) and ((MontantLig <> MontantOuv) or (MontantLigAch <> MontantOuvAch)) and ((typepresent and DOU_MONTANT) = DOU_MONTANT) then
    begin
      TOBL := GetTOBLigne(TOBPiece, RowRef);
      if EnHt then TOBL.PutValue('GL_MONTANTHTDEV', TOBL.GetValue('GL_MONTANTHTDEV') + (MontantOuv - MontantLig))
              else TOBL.PutValue('GL_MONTANTTTCDEV', TOBL.GetValue('GL_MONTANTTTCDEV') + (MontantOuv - MontantLig));
      TOBL.PutValue('GL_MONTANTPA', TOBL.GetValue('GL_MONTANTPA') + (MontantOuvAch - MontantLigAch));
    end;
//    GS.videpile(false);
		NettoieGrid;
    GS.rowcount := TOBPiece.detail.count + 2;
    if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
//    GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
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

procedure TFFacTure.ModifRefGC(TOBPiece, TOBAcomptes : TOB); // JT eQualit� 10246
var Cpt : integer;
begin
  TobAcomptes.DelChampSup('CHGTNUM',false);
  for Cpt := 0 to TobAcomptes.detail.count -1 do
    DetruitAcompteGCCpta(TOBPiece,TobAcomptes.Detail[Cpt],True,False);
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
    if IsLigneDetail(nil, TOBL) or (IsSousDetail(TOBL)) then
    begin
      DeleteTobLigneTarif(TobPiece, Tobl);
      TOBL.Free;
    end
    else
      Inc(Indice);
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
      // VARIANTE
    (* until TOBL.GetValue('GL_TYPELIGNE') = 'TP'+ inttostr(niveau); *)
    until IsFinParagraphe (TOBL,Niveau);
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
      if (IsLigneDetail(nil, TOBL)) then
      begin
        DeleteTobLigneTarif(TobPiece, Tobl);
        TOBL.Free;
      end
      else Inc(Indice);
      TOBL := TOBPiece.detail[indice];
      if TOBL = nil then break;
    // VARIANTE
    (* until TOBL.GetValue('GL_TYPELIGNE') = 'TP'+ inttostr(niveau); *)
    until IsFinParagraphe (TOBL,Niveau);
  end;
end;

// MOdif BTP
(*
procedure TFFacture.DebutEnter(Sender: TObject);
begin
  SBPosition := SB.VertScrollBar.position;
  timer1.Enabled := TRUE;
end;

procedure TFFacture.DebutResizeRequest(Sender: TObject; Rect: TRect);
begin
//  Debut.Height := Rect.Bottom - Rect.Top;
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
*)
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
(*
  if (Key = VK_PRIOR) then
  begin
    if (GS.Row > 1) then
    begin
      Key := 0;
      if ((not SaisieTypeAvanc) and (not ModifAvanc))  then
        if (GS.Row - NbLignesGrille < 1) then GS.Row := 1
        else GS.Row := GS.Row - NbLignesGrille;
    end;
  end;
  if (Key = VK_NEXT) then
  begin
    Key := 0;
    if ((not SaisieTypeAvanc) and (not ModifAvanc))  then
      if (GS.Row + NbLignesGrille >= GS.Rowcount) then GS.Row := GS.Rowcount - 1
      else GS.Row := GS.Row + NbLignesGrille;
  end;
*)

  {$IFDEF BTP}
	if (Shift = []) and (((Key = 38) and (Gs.row > 1)) or (Key =40)) then
  begin
  	// Key = 38 --> deplacement vers le bas
    // key = 40 --> deplacement vers le haut
	  BouttonInVisible;
  end;
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
  TOBL := TOB(Tn.data);
  if (TOBL <> nil) then
  begin
    ARow := TOBL.GetValue('GL_NUMLIGNE');
//    SB.VertScrollBar.Position := Debut.Height + (GS.RowHeights[1] * ARow);
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
  TOBL := GetTOBLigne(TOBPiece, TextePosition); // r�cup�ration TOB ligne
  if TOBL <> nil then
  begin
    if (Length(Descriptif1.text) <> 0) and (Descriptif1.text <> #$D#$A) then
    begin
      TOBL.PutValue('GL_BLOCNOTE', RichToString(Descriptif1));
      // si la ligne n'est pas une ligne article, on prend les 70 premiers
      // caract�res du texte pour inscrire dans le libell�
      if (TOBL.GetValue('GL_REFARTSAISIE') = '') and (not IsLigneReferenceLivr(TOBL)) and (not OrigineExcel) then
      begin
        St := 'BLOC NOTE ASSOCIE';
        TOBL.PutValue('GL_LIBELLE', st);
      	TOBL.PutValue('BLOBONE', 'X');
      end;
    end else
    begin
      TOBL.PutValue('GL_BLOCNOTE', '');
      TOBL.PutValue('BLOBONE', '-');
      TOBL.PutValue('GL_LIBELLE', StCellCur);
    end;
  end;
  Descriptif1.visible := False;
  GS.SetFocus;
  GS.row := texteposition;
  GS.col := SG_LIB;
  //GS.RowHeights[GS.row]:=GS.DefaultRowHeight ;
  AfficheLaLigne(TextePosition);
end;

procedure TFFacture.BTypeArticleClick(Sender: TObject);
var TOBL: TOB;
  TypeArticle: string;
begin
  if (OrigineEXCEL) and not(tModeSaisieBordereau in SaContexte) then exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // r�cup�ration TOB ligne
  if TOBL = nil then exit;
  TypeArticle := TOBL.getValue('GL_TYPEARTICLE');
  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  {$IFDEF BTP}
  if (TypeArticle = 'ARP') or (TypeArticle = 'MAR') or (TypeArticle = 'PRE') then
  begin
    MBDetailNomenClick(self);
  end;
  {$ENDIF}
  if not BTypeArticle.Visible then BTypeArticle.Visible := true;
end;

procedure TFFacture.TInsParagClick(Sender: TObject);
var TOBL: TOB;
  Niv: Integer;
  Arow, Acol: integer;
  Cancel, bc: boolean;
  variante : boolean;
  TheDateLiv : TdateTime;
begin
  // r�cup. niveau ligne courante
  if Action = taconsult then exit;
  {$IFDEF BTP}
  if OrigineEXCEL then exit;
  {$ENDIF}
  BouttonInVisible;
//  if BTypeArticle.Visible then BTypeArticle.Visible := false;
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  if TOBL = nil then
    Niv := 1
  else
  begin
    Niv := TOBL.GetValue('GL_NIVEAUIMBRIC');
    // 9 paragraphes imbriqu�s maximum
    if Niv = 9 then
    begin
      ShowMessage('Insertion impossible,' + chr(10) + 'Le nombre maximum de paragraphes imbriqu�s, � savoir 9, est atteint.');
      Exit;
    end;
    // incr�mentation du niveau sauf si la ligne courante
    // est un d�but de paragraphe.

    // VARIANTE
    (* if copy(TOBL.GetValue('GL_TYPELIGNE'), 1, 2) <> 'DP' then *)
    if not IsDebutParagraphe (TOBL) then
      Niv := Niv + 1;
  end;
  // Insertion des 3 lignes de base :
  ClickInsert(GS.Row);
  ClickInsert(GS.Row);
  ClickInsert(GS.Row);

  // Mise � jour des lignes du nouveau paragraphe
  // D�but paragraphe
  TOBL := GetTOBLigne(TOBPiece, GS.Row);
  // VARIANTE
  (* TOBL.PutValue('GL_TYPELIGNE', 'DP' + IntToStr(Niv)); *)
  SetParagraphe (TOBPiece,TOBL,GS.row,Niv,variante);
  TheDateLiv := TOBL.GetValue('GL_DATELIVRAISON');
  if niv = 1 then TOBL.PutValue('GL_LIBELLE', 'Paragraphe :')
  else TOBL.PutValue('GL_LIBELLE', 'Sous-paragraphe :');
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  // ligne commentaire
  TOBL := GetTOBLigne(TOBPiece, GS.Row + 1);
  TOBL.PutValue('GL_DATELIVRAISON', TheDateLiv);
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  AfficheLaLigne(GS.Row + 1);
  // Fin paragraphe
  TOBL := GetTOBLigne(TOBPiece, GS.Row + 2);
  // VARIANTE
  if variante then TOBL.PutValue('GL_TYPELIGNE', 'TV' + IntToStr(Niv))
              else TOBL.PutValue('GL_TYPELIGNE', 'TP' + IntToStr(Niv));
  if niv = 1 then TOBL.PutValue('GL_LIBELLE', 'Total Paragraphe :')
  else TOBL.PutValue('GL_LIBELLE', 'Total Sous-paragraphe :');
  TOBL.PutValue('GL_NIVEAUIMBRIC', Niv);
  TOBL.PutValue('GL_DATELIVRAISON', TheDateLiv);
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

procedure TFFacture.SaisiePrixMarche(MontantPr : double = 0);


    procedure GetOutPVBloque;
    begin
      PgiInfo ('Application impossible : L''ensemble des lignes sont bloqu�es en prix de vente',self.caption);
    end;

    procedure GetMontantPVBloque(TOBPiece : TOB; IndDepart,IndFin : integer; var MtHt,MtTTC : double);
    var IndMtHtDev,IndMtTTCDdev : integer;
        Indice : integer;
        TOBL : TOB;
    begin
    	IndMtHtDev := -1;
      IndMtTTCDdev := -1;
      MtHt := 0; MtTTC := 0;
      for Indice := IndDepart to IndFin do
      begin
        TOBL := TOBPiece.detail[Indice];
        if Indice = IndDepart then
        begin
          IndMtHtDev := TOBL.GetNumChamp ('GL_MONTANTHTDEV');
          IndMtTTCDdev := TOBL.GetNumChamp ('GL_MONTANTTTCDEV');
        end;
        if (TOBL.GetValue('GL_BLOQUETARIF')='X') and (TOBL.GetValue('GL_TYPELIGNE')='ART')then
        begin
          MTHt := MtHt + TOBL.GetValeur(IndMtHtDev);
          MTTTC := MtTTC + TOBL.GetValeur(IndMtTTCDdev);
        end;
      end;
    end;


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
  MtbloqueHtdev,MtbloqueTTCdev,MtPieceOrigine : double;
  GetOut : boolean;
begin
  GetOUt := false;
  if not isExistsArticle (trim(GetParamsoc('SO_BTECARTPMA'))) then
  BEGIN
    PgiBox (TraduireMemoire('L''article d''�cart est invalide ou non renseign�#13#10Veuillez le d�finir'),Traduirememoire('Gestion d''�cart'));
    exit;
  END;
  TobL := nil;
  IndiceMontantPar := 0;
  IndRefTot := 0;
  if (GS.row > 0) then
  begin
    TOBL := TOBPIECE.detail[GS.row - 1];
    // VARIANTE
    (* if (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'DP') and
      (copy(TOBL.getValue('GL_TYPELIGNE'), 1, 2) <> 'TP') then TOBL := nil *)
    if not IsParagraphe (TOBL) then TOBL := nil
    else indRefTot := RecupFinParagraph(TOBPIece, GS.row - 1, TOBL.GetValue('GL_NIVEAUIMBRIC'), true);

  end;
  NbPassage := 0;
  NbPassageMax := 3;
  RecupPourcent := false;
  ModeGestion := 0;
  Arow := GS.row;
  Acol := GS.col;
  ENHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  EtenduApplication := 0;
  if MontantPr <> 0 then
  begin
    IndiceMontant := TOBPiece.GetNumChamp('GP_MONTANTPR');
    if TOBL <> nil then IndiceMontantPar := TOBPiece.detail[IndrefTot].GetNumChamp('GL_DPR');
  end else
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
  MtPieceOrigine := NewMontant;
  if TOBL <> nil then
    NewMontantPar := TOBPiece.detail[IndRefTot].GetValeur(IndiceMontantPar) else NewMontantPar := 0;
  //
  CalculPieceAutorise := true;
  //
  if MontantPr <> 0 then
  begin
    traitement := True;
    ModeGestion := 3;
    NewMontant := MontantPr;
    NbPassageMax := 1; // 1 seul passage pour le calcul sur PR
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
    if BeforeReCalculPrixMarche(TOBPiece, TOBOuvrage,Modegestion, IndDepart, IndFin) then
    begin
      GS.SynEnabled := false;
      if (Modegestion = 3) or
        ((EtenduApplication = 0) and (NewMontant <> TOBPiece.GetValeur(IndiceMontant))) or
        ((EtenduApplication = 1) and (NewMontant <> TOBPiece.detail[Indfin].GetValeur(IndiceMontantPar))) then
      begin
        initMove(NbPassageMax * TOBPiece.detail.count, '');
        TOBPOurcent := TOB.create('LesPourcentages', nil, -1);
        if EtenduApplication = 0 then
        begin
          SupLesLibDetail(TOBPiece);
          IndFin := TOBPIece.detail.count - 1;
        end else
        begin
          SupLesLibdetInParag(TOBPiece, Inddepart);
          // oblige bicose la fin peut avoir boug� d'indice
          indFin := RecupFinParagraph(TOBPIece, IndDepart, TOBPiece.detail[Inddepart].GetValue('GL_NIVEAUIMBRIC'), true);
        end;
        NumeroteLignesGC(GS, TOBPIece);
        //
        GetMontantPVBloque (TOBPiece,IndDepart,Indfin,MtbloqueHtdev,MtbloqueTTCDev);
        //
        if (Modegestion=1) then
        begin
          if ((EnHt) and (arrondi(MtPieceOrigine-MtbloqueHtdev,2) = 0)) or ((not EnHt) and (arrondi(MtPieceOrigine -MtbloqueTTCDev,2)=0)) then
          begin
            GetOutPVBloque;
            GetOut := true;
          end;
        end;
        if not GetOut then
        begin
          repeat
            AppliquePrixMarche(NewMontant, MtbloqueHtdev,MtbloqueTTCDev,TOBPourcent, RecupPourcent, ModeGestion, IndDepart, IndFin, EtenduApplication);
            RecupPourcent := true;
            inc(NbPassage);
  //          if ModeGestion = 3 then ReferencePrix := NewMontant
            {else}
            if EtenduApplication = 0 then ReferencePrix := arrondi(TOBPiece.GetValeur(IndiceMontant),DEV.decimale)
            else ReferencePrix := TOBPiece.Detail[IndFin].GetValeur(IndiceMontantPar);
          until (NewMontant = ReferencePrix) or (NbPassage >= NbPassageMax);
          //
  //        TOBPiece.PutValue('GP_RECALCULER', 'X');
  //        CalculeLeDocument(ModeGestion=1);
          //
          if (NewMontant <> referencePrix) then
          begin
           if (ModeGestion <> 3) then AttribueEcartMarche(NewMontant, TOBPOurcent, IndDepart, IndFin, EtenduApplication)
                                 else AttribueEcartMarche(NewMontant, TOBPOurcent, IndDepart, IndFin, EtenduApplication, false,True);
          end;
          (*
          PutValueDetail(TOBpiece,'GP_RECALCULER', 'X');
          CalculeLaSaisie(-1, -1, false);
          if EtenduApplication = 0 then ReferencePrix := TOBPiece.GetValeur(IndiceMontant)
                                   else ReferencePrix := TOBPiece.Detail[IndFin].GetValeur(IndiceMontantPar);
          *)
          if EtenduApplication = 0 then LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc)
                                   else AddLesLibdetInParag(TOBPiece, IndDepart);
  //        GS.VidePile(false);
          NettoieGrid;
          GS.RowCount := TOBPiece.detail.count + 2;
          if GS.RowCount < NBRowsInit then GS.RowCount := NBRowsInit+TheRgpBesoin.NbLignes;
  //        GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
          for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
          NumeroteLignesGC(GS, TOBPIece);
        end else
        begin
          if EtenduApplication = 0 then LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, SaisieTypeAvanc)
                                   else AddLesLibdetInParag(TOBPiece, IndDepart);
          for i := 0 to TOBpiece.detail.count -1  do AfficheLaLigne (i+1);
        end;
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
  //
  if (not BCalculDocAuto.down) then CalculPieceAutorise := false;
  //
end;

procedure TFFacture.AppliquePourcentAvanc(TOBPiece: TOB; Pourcent: double; IndDepart, IndFin: integer; ModeApplic: integer; Dev: Rdevise);
var Indice: Integer;
  TOBL: TOB;
begin
  for Indice := IndDepart to Indfin do
  begin
    TOBL := TOBPiece.detail[Indice];
    // mis en commentaire par brl 27/08/02 : inutile car affectation de la ligne de d�but
    // � la ligne de fin pass�es en argument
    // if (copy(TOBL.GetValue ('GL_TYPELIGNE'),1,2) = 'TP') and (ModeApplic=1) then break;
    if TOBL.getValue('GL_ARTICLE') = '' then continue;
    // VARIANTE
    if IsVariante (TOBL) and (not IsPrevisionChantier (Tobpiece)) then continue;
    // --
    TOBL.Putvalue('GL_POURCENTAVANC', Pourcent);
    TOBL.Putvalue('GL_QTEPREVAVANC', arrondi(TOBL.GetValue('GL_QTEFACT') * (Pourcent / 100), V_PGI.OkDecQ));
    TOBL.PutValue('GL_RECALCULER','X');
  end;
//  TOBPiece.PutValue('GP_RECALCULER', 'X');
//  CalculeLaSaisie(-1, -1, false);
end;

procedure TFFacture.SaisieAvancement;
var
  TOBL: TOB;
  EtenduApplication: integer; // tout le document
  IndDepart, Indfin: integer;
  Pourcent: double;
  Parag: boolean;
begin
  EtenduApplication := 0;
  Parag := false;
  if (GS.row > 0) then
  begin
    TOBL := TOBPIECE.detail[GS.row - 1];
    if (TOBL.GetValue('GL_NIVEAUIMBRIC')<>0) then
    begin
      Parag := true;
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
end;

procedure TFFacture.BPrixMarcheClick(Sender: TObject);
begin
  if Action = taConsult then exit;
  if ((SaisieTypeAvanc) or (ModifAvanc)) and (self.ActiveControl.Name <> 'GS') Then
  begin
    GS.setFocus;
  end;
  if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') then
  begin
    PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
    exit;
  end;
  if (IsDejaFacture) and (not SaisieTypeAvanc) then //Modif BRL
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e.'));
    exit;
  end;
//  if BTypeArticle.Visible then BTypeArticle.Visible := false;
	BouttonInVisible;
  if (SaisieTypeAvanc) or (ModifAvanc) then SaisieAvancement
  else
  begin
  	GereCalculPieceBTP;
    SaisiePrixMarche;
  end;
end;

procedure TFFacture.AppliquePrixMarche(NewMontant: double; MtbloqueHtdev,MtbloqueTTCDev: double; TOBPOurcent: TOB; RecupPourcent: boolean; ModeGestion: Integer; IndDepart, IndFin,
  																		 EtenduApplication: integer);
var
  Indice: Integer;
  EnHt: Boolean;
  TOBLig: TOB;
  IndPrixVente, TypeLigne, TypeArticle, IndPrixAchat, IndPrixRevient,IndPvHt: Integer;
  MontantPrec, NewPuLigne, NewPrLigne, MontantAchat, Ppq: double;
  Coef, CoefTva: Double;
  PxValo: double;
{$IFDEF BTP}
  IndiceNomen: integer;
  TOBOuv: TOB;
  OldPuINit : double;
{$ENDIF}
begin
  PxValo := 0;
  Coef := 1;
  if not isExistsArticle(trim(GetParamsoc('SO_BTECARTPMA'))) then
  begin
    PgiBox(TraduireMemoire('L''article d''�cart est invalide ou non renseign�#13#10Veuillez le d�finir'), Traduirememoire('Gestion d''�cart'));
    exit;
  end;
  EnHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  if EtenduApplication = 1 then
  begin
    if ModeGestion = 3 then MontantPrec := TOBPiece.detail[Indfin].GetValue('GL_DPR') else
    if EnHt then MontantPrec := TOBPiece.detail[Indfin].GetValue('GL_MONTANTHTDEV')
            else MontantPrec := TOBPiece.detail[Indfin].GetValue('GL_MONTANTTTCDEV');
  end else
  begin
    if ModeGestion = 3 then MontantPrec := TOBPiece.GetValue('GP_MONTANTPR') else
    if EnHt then MontantPrec := TOBPiece.GetValue('GP_TOTALHTDEV')
            else MontantPrec := TOBPiece.GetValue('GP_TOTALTTCDEV');
  end;
  // recup Valeur Achat du document
  if EtenduApplication = 0 then
  begin
    IndDepart := 0;
    IndFin := TOBPiece.detail.count - 1;
    if VH_GC.GCMargeArticle = 'PMA' then PxValo := TOBPiece.GetValue('GP_MONTANTPA') else
    if VH_GC.GCMargeArticle = 'PMR' then PxValo := TOBPiece.GetValue('GP_MONTANTPR') else
    if VH_GC.GCMargeArticle = 'DPA' then PxValo := TOBPiece.GetValue('GP_MONTANTPA') else
    if VH_GC.GCMargeArticle = 'DPR' then PxValo := TOBPiece.GetValue('GP_MONTANTPR');
  end else
  begin
    if VH_GC.GCMargeArticle = 'PMA' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_PMAP') else
    if VH_GC.GCMargeArticle = 'PMR' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_PMRP') else
    if VH_GC.GCMargeArticle = 'DPA' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_DPA') else
    if VH_GC.GCMargeArticle = 'DPR' then PxValo := TOBPiece.detail[IndFin].GetValue('GL_DPR');
  end;

  if ModeGestion = 3 then
  begin
    // affectation Coef FG
    if MontantPrec <> 0 then
    begin
      if MontantPrec <> 0 then Coef := NewMontant / MontantPrec
    end;
  end else if ModeGestion = 1 then
  begin
    // Calcul sur Montant
    if montantPrec-MtbloqueHtdev <> 0 then
    begin
      if EnHt then
      begin
        Coef := (NewMontant-MtbloqueHtdev) / (montantPrec-MtbloqueHtdev);
      end else
      begin
        Coef := (NewMontant-MtbloqueTTCdev) / (montantPrec-MtbloqueTTCdev);
      end;
    end else Coef := 1;
  end else
  begin
    // Calcul sur Marge
    if MontantPrec <> PxValo then Coef := (NewMontant - PxValo) / (MontantPrec - PxValo)
    												 else Coef := 1;
  end;

  IndPrixAchat := 0;
  IndPrixRevient := 0;
  IndPrixVente := 0;
  IndPvHt := 0;
  TypeArticle := 0;
  TypeLigne := 0;
  //
  if Coef = 1 then exit;
  //
  for Indice := IndDepart to IndFin do
  begin
    TOBLig := TOBPiece.detail[Indice];
    if Indice = IndDepart then
    begin
      if EnHt then
      begin
        IndPrixVente := TOBLIG.GetNumChamp('GL_PUHTDEV');
      end else
      begin
        IndPrixVente := TOBLIG.GetNumChamp('GL_PUTTCDEV');
      end;
      IndPvHt := TOBLIG.GetNumChamp('GL_PUHT');
      if VH_GC.GCMargeArticle = 'PMA' then IndPrixAchat := TOBLig.GetNumchamp('GL_PMAP') else
        if VH_GC.GCMargeArticle = 'PMR' then IndPrixAchat := TOBLig.GetNumchamp('GL_PMRP') else
        if VH_GC.GCMargeArticle = 'DPA' then IndPrixAchat := TOBLig.GetNumchamp('GL_DPA') else
        if VH_GC.GCMargeArticle = 'DPR' then IndPrixAchat := TOBLig.GetNumchamp('GL_DPR');
      IndPrixRevient := TOBLig.GetNumchamp('GL_DPR');
      TypeArticle := TOBLIG.GetNumChamp('GL_TYPEARTICLE');
      TypeLigne := TOBLIG.GetNumChamp('GL_TYPELIGNE');
    end;
    if (TOBLIG.GetValue('GL_BLOQUETARIF')='-')  then
    begin
      if TOBLIG.GetValue('GL_PUHT')<>0 then CoefTva := TOBLIG.GetValue('GL_PUTTCDEV')/TOBLIG.GetValue('GL_PUHTDEV') else CoefTva := 1;
      if (OkLigneCalculMarche(TOBLIG, Typeligne)) then
      begin
        //
        if (TOBLIG.GetValeur(TypeArticle) = 'EPO') then continue;
        if (TOBLIG.GetValeur(TypeArticle) = 'POU') and (RecupPourcent) then
        begin
          AddPourcent(TOBPiece, TOBPourcent, Indice);
          continue;
        end;
        // C'est bien un article a prendre en compte
        if ModeGestion = 1 then
        begin
          OldPuInit := TOBLig.getvaleur(IndPrixvente);
          // Prorata du Montant Ligne
          NewPuLigne := arrondi(TOBLig.getvaleur(IndPrixvente) * Coef, V_PGI.OkDecP);
        end else
        if ModeGestion = 3 then
        begin
          if VH_GC.GCMargeArticle = 'PMR' then
          begin
            IndPrixAchat := TOBLig.GetNumchamp('GL_PMAP');
            IndPrixRevient := TOBLig.GetNumchamp('GL_PMRP');
          end else
          if VH_GC.GCMargeArticle = 'DPR' then
          begin
            IndPrixAchat := TOBLig.GetNumchamp('GL_DPA');
            IndPrixRevient := TOBLig.GetNumchamp('GL_DPR');
          end else
          if VH_GC.GCMargeArticle = 'PMA' then
          begin
            IndPrixAchat := TOBLig.GetNumchamp('GL_PMAP');
            IndPrixRevient := TOBLig.GetNumchamp('GL_PMRP');
          end else
          if VH_GC.GCMargeArticle = 'DPA' then
          begin
            IndPrixAchat := TOBLig.GetNumchamp('GL_DPA');
            IndPrixRevient := TOBLig.GetNumchamp('GL_DPR');
          end;
          OldPuInit := TOBLig.getvaleur(IndPrixvente);
          // affectation d'un coef. de marge sauf
          //  - pour la sous-traitance
          //  - si le prix d'achat est nul
  //        if ((TOBLIG.GetValeur(TypeArticle) = 'PRE'){$IFDEF BTP} and (RenvoieTypeRes(TOBLIG.GetValeur(CodeArticle)) = 'ST'){$ENDIF}) or
          if ((TOBLIG.GetValeur(TypeArticle) = 'PRE'){$IFDEF BTP} and (TOBLIG.GetValue('BNP_TYPERESSOURCE') = 'ST'){$ENDIF}) or
            (TOBLig.getvaleur(IndPrixAchat) = 0) then
          begin
            NewPuLigne := TOBLig.getvaleur(IndPrixvente);
          end else
          begin
            if IndPrixRevient = 0 then
            begin
              NewPuLigne := arrondi(TOBLig.getvaleur(IndPrixAchat) * Coef, V_PGI.okdecP)
            end else
            begin
            {          if TOBLig.getvaleur(IndPrixRevient) <> 0 then CftMrg := TOBLig.getvaleur(IndPrixvente) / TOBLig.getvaleur(IndPrixRevient)
                                           else CftMrg := 0;
            }
              //          TOBLIG.PutValeur(IndPrixRevient, arrondi(TOBLig.getvaleur(IndPrixAchat) * Coef,V_PGI.okdecP));
              NewPrLigne := arrondi(TOBLig.getvaleur(IndPrixAchat) * COEF, V_PGI.okdecP);
              //          NewPuLigne := arrondi(NewPrligne* CftMrg, V_PGI.okdecP);
              NewPuLigne := arrondi(NewPrligne * TOBLIG.GetValue('GL_COEFMARG'), V_PGI.okdecP);
            end;
          end;
        end else
        begin
          // Prorata de la marge Ligne
          if TOBLig.getValue('GL_PRIXPOURQTE') <> 0 then Ppq := TOBLig.getValue('GL_PRIXPOURQTE')
          else Ppq := 1;
          MontantAchat := TOBLig.getvaleur(IndPrixvente) - (TOBLIG.GetValeur(IndPrixAchat) / Ppq);
          NewPuLigne := arrondi((MontantAchat * Coef) + TOBLIG.Getvaleur(IndPrixAchat), DEV.Decimale);
          NewPrLigne := TOBLig.getvaleur(IndPrixRevient);
        end;
        if (TOBLIG.GetValeur(TypeArticle) = 'OUV') or (TOBLIG.GetValeur(TypeArticle) = 'ARP') then
        begin
  {$IFDEF BTP}
          IndiceNomen := TOBLIg.GetValue('GL_INDICENOMEN');
          if IndiceNomen > 0 then
          begin
            TOBOuv := TOBOuvrage.Detail[IndiceNomen - 1];
            TOBLig.PutValue('GL_RECALCULER', 'X');
            if ModeGestion = 3 then // Reajustement du PR
            begin
              ReajusteMontantOuvrage(nil,TOBPiece, TOBLig, TOBOuv, TOBLIG.GetValeur(IndPrixRevient), NewPrLigne, NewPuLigne, DEV, EnHt, false, true);
            end else
            begin
              ReajusteMontantOuvrage(nil,TOBPiece, TOBLig, TOBOuv, TOBLIG.GetValeur(IndPrixVente), NewPrLigne, NewPuLigne, DEV, EnHt, FALSE, false);
            end;
          	TOBLig.putValue('GL_RECALCULER','X');
          end;
  {$ENDIF}
        end;
        if Modegestion <> 1 then TOBLIG.PutValeur(IndPrixRevient, NewPrligne);
        if OldPuINit <> NewPuLigne  then
        begin
          if TOBLIG.GetValue('GL_BLOQUETARIF')='-' then
          begin
            TOBLIG.PutValeur(IndPrixVente, NewPuligne);
            if EnHt then
            begin
              TOBLIG.PutValeur(IndPvHt,DEVISETOPIVOTEx (NewPuLIgne,DEv.Taux,dev.Quotite,V_PGI.okdecP));
            end else
            begin
              TOBLIG.PutValeur(IndPvHt,arrondi(DEVISETOPIVOTEx (NewPuLIgne,DEv.Taux,dev.Quotite,V_PGI.okdecP)/CoefTva,V_PGI.OkDecP));
            end;
            if TOBLig.GetValue('GL_DPR') <> 0 then
            begin
              TOBLig.PutValue('GL_COEFMARG',Arrondi(TOBLig.GetValue('GL_PUHT')/TOBLig.GetValue('GL_DPR'),4));
            end;
          end;
          TOBLig.putValue('GL_RECALCULER','X');
        end;
        MoveCur(false);
      end;
    end;
  end;
  //
  ZeroFacture (TOBpiece);
  ZeroMontantPorts (TOBPorcs);
  ReinitMontantPieceTrait (TOBPieceTrait);
  for Indice := 0 to TOBPiece.detail.count -1 do ZeroLigneMontant (TOBPiece.detail[Indice]);
  TOBBases.ClearDetail;
  TOBBasesL.ClearDetail;
  PutValueDetail (TOBpiece,'GP_RECALCULER','X');
  //
  CalculeLaSaisie(-1, -1, false);
  //
  if (EtenduApplication = 1) or (EtenduApplication = 3) then CalculeSousTotauxPiece(TOBPiece);
end;

function TFFacture.Isaffectable (Ecart,Pu : double) : boolean;
begin
	result := true;
	if (Ecart < 0) and (Pu > 0) and (abs(Pu) < Abs(Ecart)) then result := false;
	if (Ecart > 0) and (Pu < 0)  and (abs(Pu) < Abs(Ecart)) then result := false;
end;

procedure TFFacture.AttribueEcartMarche(NewMontant: double; TOBPOurcent: TOB; IndDepart, IndFin, EtenduApplication: integer;AvecArtEcart : boolean=true; EnPr : boolean=false);
var Indice: Integer;
  EnHt: Boolean;
  TOBLig: TOB;
  IndPrixVente, TypeLigne, TypeArticle, CodeArticle, IndMaxMontant,IndPr,IndMontantVente: Integer;
  MontantPrec, NewPuLigne, MontantMax,NewPrLigne,CoefTva: double;
  Ecart, EcartAffectable,EcartAffecte,PuInit: Double;
  EcartOk: boolean;
  ArtLast: string;
  {$IFDEF BTP}
  IndiceNomen: integer;
  TOBOUv: TOB;
  {$ENDIF}
  valeurs:T_Valeurs;
  Qte,Dpr,PuHt,CoefMarg: double;
begin
  ArtLast := '';
  MontantMax := 0;
  IndMaxMontant := -1;
  EnHt := TOBPIece.getValue('GP_FACTUREHT') = 'X';
  if EtenDuApplication = 0 then
  begin
    IndDepart := 0;
    Indfin := TOBPiece.detail.count - 1;
    if EnPR Then
    begin
    	MontantPrec := TOBPiece.GetValue('GP_MONTANTPR');
    end else
    begin
    	if EnHt then MontantPrec := TOBPiece.GetValue('GP_TOTALHTDEV')
              else MontantPrec := TOBPiece.GetValue('GP_TOTALTTCDEV');
    end;
  end else
  begin
  	if EnPr then
    begin
    	MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_DPR');
    end else
    begin
      if EnHt then MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTHTDEV') else
                   MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTTTCDEV');
    end;
  end;
  Ecart := arrondi(NewMontant - MontantPrec, DEV.Decimale);
  EcartOk := false;
  for Indice := IndDepart to IndFin do
  begin
    TOBLig := TOBPiece.detail[Indice];
    if (EnHt) and (TOBLIG.GetValue('GL_BLOQUETARIF')='X') then continue;
    if Indice = IndDepart then
    begin
    	if EnPr then
      begin
      	IndPrixVente := TOBLIG.GetNumChamp('GL_DPR');
        IndMontantVente := TOBLIG.GetNumChamp('GL_MONTANTPR');
      end else
      begin
        if EnHt then
        begin
        	IndPrixVente := TOBLIG.GetNumChamp('GL_PUHTDEV');
        	IndMontantVente := TOBLIG.GetNumChamp('GL_MONTANTHTDEV');
        end else
        begin
          IndPrixVente := TOBLIG.GetNumChamp('GL_PUTTCDEV');
        	IndMontantVente := TOBLIG.GetNumChamp('GL_MONTANTTTCDEV');
        end;
      end;
      TypeArticle := TOBLIG.GetNumChamp('GL_TYPEARTICLE');
      TypeLigne := TOBLIG.GetNumChamp('GL_TYPELIGNE');
      CodeArticle := TOBLIG.GetNumChamp('GL_ARTICLE');
      IndPr := TOBLIG.GetNumChamp('GL_DPR');
    end;
    //
    if TOBLIG.GetValue('GL_PUHT')<> 0 then CoefTva := TOBLIG.GetValue('GL_PUTTCDEV')/TOBLIG.GetValue('GL_PUHTDEV') else CoefTva := 1;
    //
		if IsArticle (TOBLig) and (TOBLIG.getvaleur(CodeArticle) <> '') then
    begin
      if (TOBLIG.GetValeur(TypeArticle) <> 'POU') and (TOBLIG.GetValeur(TypeArticle) <> 'EPO') then
      begin
        if TOBLIG.GetValeur(TypeArticle) = 'MAR' then
        begin
          ArtLast := TOBLIG.getvalue('GL_ARTICLE');

          if (TOBLIG.GetValeur(IndMontantVente) > MontantMax) or
            (not DansChampsPourcent(Indice, TOBPourcent)) then
            IndMaxMontant := Indice;
        end;
        if (not DansChampsPourcent(Indice, TOBPourcent)) then
        begin
          Qte := TOBLIG.GetValue('GL_QTEFACT');
          EcartAffectable := Arrondi(Ecart / Qte, V_PGI.okdecP);
          if (EcartAffectable <> 0) and (Isaffectable (EcartAffectable,TOBLIG.GetValeur(IndPrixVente))) then
          begin
            NewPuLigne := TOBLIG.GetValeur(IndPrixVente) + EcartAffectable;

            if ((TOBLIG.GetValeur(TypeArticle) = 'OUV') or (TOBLIG.GetValeur(TypeArticle) = 'ARP')) and
            		(ApplicPrixPose (TOBpiece)) then
            begin
            	deduitLaLigne(TOBLIG);
              IndiceNomen := TOBLIg.GetValue('GL_INDICENOMEN');
              if IndiceNomen > 0 then
              begin
                TOBOuv := TOBOuvrage.Detail[IndiceNomen - 1];
              	IndiceNomen := TOBLIg.GetValue('GL_INDICENOMEN');
              	MontantPrec := TOBLIG.GetValeur(IndPrixVente);
                PuInit := MontantPrec;
              	TentativeAffectationQtive (TOBLig,TOBOuv,false,EnPr,EnHt,NewPuLigne,MontantPrec,DEV);
                if EtenDuApplication = 0 then
                begin
                  TOBLIG.putvaleur(IndPrixVente,MontantPrec);
                end;
              	NewPuLigne := MontantPrec;
              end;
              AjouteLaLigne(TOBLIG);
              TOBLig.PutValue('GL_RECALCULER', 'X');
              TOBPiece.PutValue('GP_RECALCULER', 'X');
              //
              CalculeLaSaisie (-1,TOBLIg.getValue('GL_NUMLIGNE'),false);
              //
            end ELSE
            begin
              if enPr then TOBLIG.PutValeur(IndPr, NewPrligne);
              if TOBLIG.GetValue('GL_BLOQUETARIF')='-' then
              begin
            		deduitLaLigne(TOBLIG);
                if EnHt then
                begin
                  TOBLIG.PutValue('GL_PUHT',DEVISETOPIVOTEx (NewPuLIgne,DEv.Taux,dev.Quotite,V_PGI.okdecP));
                  TOBLIG.PutValue('GL_PUHTDEV',NewPuLIgne);
                end else
                begin
                  TOBLIG.PutValue('GL_PUTTC',DEVISETOPIVOTEx (NewPuLIgne,DEv.Taux,dev.Quotite,V_PGI.okdecP));
                  TOBLIG.PutValue('GL_PUTTCDEV',NewPuLIgne);
                end;
                Dpr := TOBLig.GetValue('GL_DPR'); PuHt := TOBLig.GetValue('GL_PUHT');
                if Dpr <> 0 then
                begin
                  CoefMarg := Arrondi(PuHt / Dpr,4);
                end;
                TOBLig.putValue('GL_COEFMARG',COefMarg);
                //
                AjouteLaLigne(TOBLIG);
                TOBLig.PutValue('GL_RECALCULER', 'X');
                TOBPiece.PutValue('GP_RECALCULER', 'X');
                CalculeLaSaisie (-1,TOBLIg.getValue('GL_NUMLIGNE'),false);
                //
              end;
            end;
            //
            if EtenDuApplication = 0 then
            begin
              if EnPR Then
              begin
                MontantPrec := TOBPiece.GetValue('GP_MONTANTPR');
              end else
              begin
                if EnHt then MontantPrec := TOBPiece.GetValue('GP_TOTALHTDEV')
                        else MontantPrec := TOBPiece.GetValue('GP_TOTALTTCDEV');
              end;
            end else
            begin
              if EnPr then
              begin
                MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_DPR');
              end else
              begin
                if EnHt then MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTHTDEV') else
                             MontantPrec := TOBPiece.detail[IndFin].GetValue('GL_MONTANTTTCDEV');
              end;
            end;
            //
            Ecart := arrondi(NewMontant - MontantPrec, DEV.Decimale);
//            Ecart := Ecart - Arrondi(EcartAffecte * TOBLIG.GetValue('GL_QTEFACT'), Dev.decimale);
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
  ecart := Arrondi(ecart,DEV.Decimale );
  if (ecart <> 0) and (not ecartOk) and (AvecArtEcart)  then
  begin
    AffecteEcartPrixMarche(self,TOBPIece, TOBTiers, TOBAffaire, TOBArticles, Ecart, ArtLast, IndMaxMontant, IndDepart, IndFin, EtenduApplication);
  end;
end;

procedure TFFacture.FormResize(Sender: TObject);
var LigCou : integer;
    Cancel : Boolean;
begin
  Cancel := False;
  LigCou := GS.row;
  BouttonInVisible;
  HMTrad.ResizeGridColumns(GS); // Adaptation de la taille du grid
  SetLargeurColonnes;
  HMTrad.ResizeGridColumns(INFOSLIGNE); // Adaptation de la taille du grid
{$IFDEF BTP}
  TheRgpBesoin.ReajusteGrid;
{$ENDIF}
  BouttonVisible (GS.row);
  PPied.refresh;
  PPiedAvanc.refresh;

//  GS.row := LigCou;
  if TOBPiece.Detail.Count > 0 then GSRowEnter (Self,GS.Row,Cancel,False);
end;

procedure TFFacture.PositionneTextes;
var NumPiece: string;
  T: TOB;
  ind : integer;
begin
	// Correction pour associer les bloc notes au document en cours lors de la duplication
  if not DuplicPiece then exit;
  Numpiece := Cledoc.NaturePiece + ':' + Cledoc.Souche + ':' + IntToStr(Cledoc.NumeroPiece) + ':' + IntToStr(Cledoc.indice);
  for ind := 0 to TOBLienOle.detail.count -1 do
  begin
  	T := TOBLienOle.detail[ind];
    T.putValue('LO_IDENTIFIANT',NumPiece);
  end;
end;

procedure TFFacture.LoadLesTextes;
begin
(*
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
*)
end;

procedure TFFacture.TTVParagClose(Sender: TObject);
begin
  BArborescence.Down := False;
end;

{$IFDEF BTP}

procedure TFFacture.Insere_SDP();
var TOBL: TOB;
begin
	TOBL := GetTOBLigne(TOBPiece, GS.Row); // r�cup�ration TOB ligne
  if TOBL <> nil then
  begin
    if TOBL.GetValue('GL_NATUREPIECEG')=GetParamSoc('SO_BTNATBESOINCHA') then // SO_BTNATBESOINCHA
    begin
    	if TOBL.getValue('GL_TENUESTOCK')='X' then TOBL.PutValue('GL_TENUESTOCK','-')
      																			else TOBL.PutValue('GL_TENUESTOCK','X');
    end else
    begin
      if (TOBL.GetValue('GL_ACTIONLIGNE') = '') then
        TOBL.PutValue('GL_ACTIONLIGNE', 'SDP')
      else
        TOBL.PutValue('GL_ACTIONLIGNE', '');
      GS.refresh;
    end;
  end;
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

function TFFacture.GetLibParag(TOBL: TOB): string;
begin
  Result := TOBL.GetValue('GL_LIBELLE');
  {$IFDEF BTP}
  if (TOBL.GetValue('GL_NATUREPIECEG') = 'PBT') or (TOBL.GetValue('GL_NATUREPIECEG') = 'CBT') then
  begin
    Result := REsult + ' (' + DateTimeToStr(TOBL.GetValue('GL_DATELIVRAISON')) + ')';
  end;
  {$ENDIF}
end;

procedure TFFacture.Affiche_TVParag;
//
  function IsRefDevis (TOBL : TOB) : boolean;
  begin
    result := false;
    if (TOBL.GetValue('GL_NATUREPIECEG')='FBT') AND (TOBL.GEtVAlue('GL_TYPEARTICLE')='EPO') then result := true;
  end;
//
var TOBL: TOB;
    TOBC,TOBCL : TOB;
  i: Integer;
  Tn,RootTN: TTreeNode;
  Titre: string;
begin
  TOBC := TOB.Create ('LA TOB ', nil,-1);
  TRY
    // chargement treeview
    TVParag.items.clear;
    Titre := FtitrePiece.Caption + ' N� ' + IntToStr(TOBPiece.GetValue('GP_NUMERO'));
    RootTN := TVParag.items.add(nil, Titre);
    TOBCL := TOB.Create ('UN ITEM',TOBC,-1);
    TOBCL.data := RootTN;

    for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      TOBL := TOBPiece.Detail[i];
      // VARIANTE
      if IsRefDevis (TOBL) then
      begin
        TN := TVParag.Items.AddChild (RootTN,TOBL.GetValue('GL_LIBELLE'));
        Tn.Data := TOBL;
        TOBC.clearDetail;
        TOBCL := TOB.Create ('UN ITEM',TOBC,-1);
        TOBCL.data := TN;
      end else
      begin
        if (IsDebutParagraphe (TOBL)) then
        begin
          Tn := TVParag.Items.AddChild(TTreeNode(TOBC.detail[TOBC.detail.count-1].data), GetLibParag(TOBL));
          Tn.Data := TOBL;
          TOBCL := TOB.Create ('UN ITEM',TOBC,-1);
          TOBCL.data := TN;
        end else if IsFinParagraphe (TOBL) then
        begin
          TOBC.detail[TOBC.detail.count-1].free;
        end;
      end;
    end;
  FINALLY
    TOBC.free;
  END;
  TVParag.FullExpand;
end;
(*
procedure TFFacture.DebutExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit;  // JT eQualit� 10966
  if Debut.Modified then
  begin
    RemplitLiens(TOBPiece, TOBLIenOLE, Debut, 1);
    Debut.modified := false;
  end;
end;

procedure TFFacture.FinExit(Sender: TObject);
begin
  if csDestroying in ComponentState then Exit; // JT eQualit� 10966
  if fin.Modified then
  begin
    RemplitLiens(TOBPiece, TOBLIenOLE, Fin, 2);
    fin.modified := false;
  end;
end;
*)
procedure TFFacture.Descriptif1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//  if (Key = VK_TAB) and (Shift = [ssCtrl]) then
  if (Key = VK_ESCAPE) then
  begin
    Key := 0;
    GS.enabled := true;
    Descriptif1Exit(self);
//    SendMessage(GS.Handle, WM_KeyDown, VK_TAB, 0);
    GS.Cells[ Sg_LIB,texteposition] := TOBPiece.detail[textePosition-1].GetValue('GL_LIBELLE');
  end;
end;

procedure TFFacture.PersonnalisationBtp;
var
  XP, XD : double;
begin
(*
  GetMontantRG(TOBPIeceRG, TOBBasesRG, XD, XP, DEV);

  TheMontantRGTTC := XD;
  GetReliquatCaution (TOBPieceRg,XP,XD);
  TheMontantRGTTC := TheMontantRGTTC - XD;
  if TheMontantRGTTC < 0 then TheMontantRGTTC := 0;
*)
	GetMontantRGReliquat(TOBPIeceRG, XD, XP);
  TOTALRGDEV.Value := XD;
  TTYPERG.text := GetCumultextRG(TOBPIECERG, 'PRG_TYPERG');
  TCAUTION.text := GetCumulTextRG(TOBPIECERG, 'PRG_NUMCAUTION');
//  if RGMultiple(TOBPIECERG) then Action := taConsult;

  {$IFDEF BTP}
  DefiniPersonnalisationBtp (self,TOBPiece,ModifAvanc);
  {$ENDIF}
  if (tModeBlocNotes in SaContexte) then
  begin
    GS.RowCount := TOBPiece.Detail.Count + 2;
    if GS.RowCount < NbRowsInit then GS.RowCount := NbRowsInit+TheRgpBesoin.NbLignes;
//    GS.height := (GS.rowHeights[1] * (GS.Rowcount-TheRgpBesoin.NbLignes)) + (GS.GridLineWidth * (GS.Rowcount-TheRgpBesoin.NbLignes));
  end else
  begin
    {$IFDEF BTP}
    DefiniRowCount ( self,TOBPiece);
    {$ENDIF}
  end;

end;

procedure TFFacture.BRetenuGarClick(Sender: TObject);
var TLocal, TLocalP, TLocalB, TOBRG: TOB;
  XD, XP : Double;
begin
  if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') then
  begin
    PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
    exit;
  end;
  if IsDejaFacture then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e.'));
    exit;
  end;
  if RGMultiple(TOBPiece) then exit;
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
  TLocalB.Data := TOBPorcs;
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
    RecalculeRG(TOBPorcs,TOBPiece, TOBPieceRG, TOBBases, TOBBasesRG, DEV);
    (*
    GetMontantRG(TOBPIeceRG, TOBBasesRG, XD, XP, DEV);
    TheMontantRGTTC := XD;
    GetReliquatCaution (TOBPieceRg,XP,XD);
    TheMontantRGTTC := TheMontantRGTTC - XD;
    if TheMontantRGTTC < 0 then TheMontantRGTTC := 0;
    *)
    GetMontantRGReliquat(TOBPIeceRG, XD, XP);

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
    if GereDocEnAchat then AfficheZonePiedAchat
                      else AfficheZonePiedStd;
  end;
  TLOCALB.free;
  TLocal.free;
  Tlocalp.data := nil;
  TlocalP.free;
end;

procedure TFFacture.SetTaillePied (Taille : integer);
begin
  PPIED.Height := Taille;
  PGLOBPied.Height := PPied.Height + PButtons.Height;
end;

procedure TFFacture.InitPositionZones;
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
  //
  HGP_TOTALESCDEV.top := 42;
  LGP_TOTALESCDEV.top := 42;
  HGP_TOTALREMISEDEV.Top := 61;
  LGP_TOTALREMISEDEV.Top := 61;
  HGP_TOTALTAXESDEV.top := 4;
  LTOTALTAXESDEV.top := 4;
  HGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.visible := true;
  //
  HGP_TOTALTIMBRES.Top := 82;
  LGP_TOTALTIMBRES.Top := 82;
  //
  HGP_TOTALTIMBRES.Visible := false;
  LGP_TOTALTIMBRES.Visible := false;
  //
  HGP_ACOMPTEDEV.top := 42;
  LGP_ACOMPTEDEV.top := 42;
  HGP_NETAPAYERDEV.Top := 61;
  LNETAPAYERDEV.Top := 61;
  //
end;

procedure TFFacture.DefiniPied;
var chaineRg, ChaineRg1: string;
begin
  SetTaillePied (88);
  InitPositionZones;
  //
  if GetCumulValueRg(TOBPIECERG, 'PRG_TAUXRG') <> 0 then
  begin
    chaineRg := 'R.G ';
    if TOBPIeceRG.Detail.Count < 2 then
      chaineRg1 := ChaineRg + floattostr(TOBPIECERG.detail[0].GetValue('PRG_TAUXRG')) + ' % sur ' + TOBPieceRG.detail[0].GetValue('PRG_TYPERG');
    LLIBRG.Visible := true;
    LLIBRG.Caption := ChaineRg1;
    if (not GereDocEnAchat) then
    begin
      if (GetCumulTextRg(TOBPIECERG, 'PRG_TYPERG') = 'HT') then
      begin
      	SetTaillePied (102);
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
        end else if (ApplicRetenue) then
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
        if  GP_TOTALTIMBRES.Value <> 0 then
        begin
          HGP_TOTALTIMBRES.Top := 42;
          LGP_TOTALTIMBRES.Top := 42;
          HGP_ACOMPTEDEV.Top := 61;
          LGP_ACOMPTEDEV.Top := 61;
          HGP_NETAPAYERDEV.Top := 80;
          LNETAPAYERDEV.Top := 80;
          HGP_TOTALTIMBRES.Visible := true;
          LGP_TOTALTIMBRES.Visible := true;
        end;

      end else if (GetCumulTextRg(TOBPIECERG, 'PRG_TYPERG') = 'TTC') then
      begin
        HGP_TOTALRGDEV.Parent := PTotaux1;
        LTOTALRGDEV.Parent := Ptotaux1;
        if (ApplicRetenue) then HGP_TOTALRGDEV.visible := true;
        if  GP_TOTALTIMBRES.Value <> 0 then
        begin
          if ApplicRetenue then
          begin
            SetTaillePied (124);
            HGP_TOTALRGDEV.top := 42;
            LTOTALRGDEV.Top := 42;
            HGP_TOTALTIMBRES.Top := 61;
            LGP_TOTALTIMBRES.Top := 61;
            HGP_ACOMPTEDEV.Top := 80;
            LGP_ACOMPTEDEV.Top := 80;
            HGP_NETAPAYERDEV.Top := 98;
            LNETAPAYERDEV.Top := 98;
            HGP_TOTALTIMBRES.Visible := true;
            LGP_TOTALTIMBRES.Visible := true;
          end else
          begin
            HGP_TOTALTIMBRES.Top := 42;
            LGP_TOTALTIMBRES.Top := 42;
            HGP_ACOMPTEDEV.Top := 61;
            LGP_ACOMPTEDEV.Top := 61;
            HGP_NETAPAYERDEV.Top := 80;
            LNETAPAYERDEV.Top := 80;
            HGP_TOTALTIMBRES.Visible := true;
            LGP_TOTALTIMBRES.Visible := true;
          end;
        end else
        begin
  				SetTaillePied (102);
          HGP_TOTALRGDEV.top := 42;
          LTOTALRGDEV.Top := 42;
          HGP_ACOMPTEDEV.Top := 61;
          LGP_ACOMPTEDEV.Top := 61;
          HGP_NETAPAYERDEV.Top := 80;
          LNETAPAYERDEV.Top := 80;
        end;
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
  end else
  begin
    if  GP_TOTALTIMBRES.Value <> 0 then
    begin
  		SetTaillePied (102);
      HGP_TOTALTIMBRES.Top := 42;
      LGP_TOTALTIMBRES.Top := 42;
      HGP_TOTALTIMBRES.Visible := true;
      LGP_TOTALTIMBRES.Visible := true;
      HGP_ACOMPTEDEV.top := 61;
      LGP_ACOMPTEDEV.top := 61;
      HGP_NETAPAYERDEV.Top := 79;
      LNETAPAYERDEV.Top := 79;
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
(*
  if (tModeBlocNotes in SaContexte) then
  begin
    Debut.Visible := true;
    Fin.Visible := true;
    GS.ScrollBars := ssNone;
  end else
  begin
*)
    GS.align := alClient;
(*
    Debut.Visible := false;
    Fin.Visible := false;
//    NbRowsInit := 100;
//    NbRowsPlus := 20;
  end;
*)
//  NbRowsInit := NbLignesGrille;
  NbRowsInit := 30;
  NbRowsPlus := 1;
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
//    Ppied.height := 110;
//    Ppied.height := 129;
  end else GestionRetenue := false;
end;

procedure TFFacture.PPiedResize(Sender: TObject);
begin
  PTotaux.Height := PPied.height - 2;
  PTotaux1.Height := PPied.height - 2;
  BlanceCalc.height := PPied.height - 2;
  INFOSLIGNE.Height := PPied.height - 2;
end;

procedure TFFacture.PTotauxResize(Sender: TObject);
begin
(*
  HGP_TOTALHTDEV.top := 4;
  LGP_TOTALHTDEV.top := 4;
  HGP_TOTALPORTSDEV.top := 23;
  LTOTALPORTSDEV.top := 23;
  HGP_TOTALESCDEV.top := 42;
  LGP_TOTALESCDEV.top := 42;
  HGP_TOTALREMISEDEV.Top := 61;
  LGP_TOTALREMISEDEV.Top := 61;
*)
end;

procedure TFFacture.PTotaux1Resize(Sender: TObject);
begin
(*
  HGP_TOTALTAXESDEV.top := 4;
  LTOTALTAXESDEV.top := 4;
  HGP_TOTALTTCDEV.top := 23;
  LGP_TOTALTTCDEV.top := 23;
  HGP_ACOMPTEDEV.top := 42;
  LGP_ACOMPTEDEV.top := 42;
  HGP_NETAPAYERDEV.Top := 61;
  LNETAPAYERDEV.Top := 61;
*)
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



procedure TFFacture.Deselectionne(Arow: integer);
begin
  GS.FlipSelection(Arow);
end;


procedure TFFacture.FraisdetailClick(Sender: TObject);
begin
  if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') then
  begin
    PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
    exit;
  end;
  if IsDejaFacture then
  begin
    PgiError(Traduirememoire('Impossible : une facturation a d�j� �t� effectu�e.'));
    exit;
  end;
  AppelFraisDetailBtp (Self,TobPiece,TOBOUvrage,TOBPorcs,InclusSTinFG);
end;


procedure TFFacture.SRDocGlobalClick(Sender: TObject);
begin
{$IFDEF BTP}
	GereCalculPieceBTP;
  if Entree_Simulation(TOBArticles, TOBPiece, TOBOUvrage, TOBPorcs, 'Suivi de rentabilit� du document', Action, DEV, false) then
  begin
    TOBPiece.PutValue('GP_RECALCULER', 'X');
		GereCalculPieceBTP (true);
  end;
{$ENDIF}
end;

procedure TFFacture.SRDocParagClick(Sender: TObject);
begin
	GereCalculPieceBTP;
{$IFDEF BTP}
  if Entree_Simulation(TOBArticles, TOBPiece, TOBOUvrage,TOBPorcs, 'Suivi de rentabilit� du document', Action, DEV, true) then
  begin
    AjusteSousDetail (self,TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
		GereCalculPieceBTP(true);
  end;
{$ENDIF}
end;

procedure TFFacture.GoToLigne(var Arow, Acol: integer);
var cancel: boolean;
begin
	GS.CacheEdit;
  GS.SynEnabled := false;
  cancel := false;
  GSRowEnter(self, Arow, cancel, false);
  GSCellEnter(self, Acol, Arow, cancel);
  if not cancel then
  begin
    GS.col := Acol;
    GS.row := Arow;
  	StCellCur := GS.cells[GS.Col,Gs.row];
  end else
  begin
  	StCellCur := GS.cells[ACol,Arow];
  end;
  GS.SynEnabled := true;
	GS.ShowEditor;
end;


{$IFDEF BTP}

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
  //--- ajout brl 2/03/05
  TOBEches_O.clearDetail;
  TOBBases_O.clearDetail;
  TOBPorcs_O.clearDetail;
  TOBLigFormule_O.clearDetail ;
  TOBLOT_O.clearDetail;
  TOBSerie_O.clearDetail;
  TOBN_O.clearDetail;
  TOBAcomptes_O.clearDetail;
  TOBFormuleVarQte_O.clearDetail;
  TobLigneTarif_O.clearDetail;
  //---
  // Mise en adequations des tob origines
  TOBPIECE_O.Dupliquer(TOBPIECE, true, true);
  TOBAcomptes_O.Dupliquer(TOBAcomptes, true, true);
  TOBPIECERG_O.Dupliquer(TOBPIECERG, true, true);
  TOBBASESRG_O.Dupliquer(TOBBASESRG, true, true);
  TOBLIENOLE_O.Dupliquer(TOBLIENOLE, true, true);
  TOBAdresses_O.Dupliquer(TOBAdresses, true, true);
  TOBOuvrage_O.Dupliquer(TOBOuvrage, true, true);
  //--- ajout brl 2/03/05
  TOBEches_O.Dupliquer(TOBEches, true, true);
  TOBBases_O.Dupliquer(TOBBases, true, true);
  TOBPorcs_O.Dupliquer(TOBPorcs, true, true);
  TOBLigFormule_O.Dupliquer(TOBLigFormule, true, true);
  TOBSerie_O.Dupliquer(TOBSerie, true, true);
  TOBN_O.Dupliquer(TOBNomenclature, True, True);
  TOBLOT_O.Dupliquer(TOBdesLots, True, True);
  TOBAcomptes_O.Dupliquer(TOBAcomptes, true, true);
  TOBFormuleVarQte_O.Dupliquer(TOBFormuleVarQte, true, true);
  TOBLigneTarif_O.Dupliquer(TOBLigneTarif, true, true);
  //---
end;
{$ENDIF}

procedure TFFacture.DescriptifKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var TOBA, TOBL : TOB;
    requete : string;
    QQ : TQuery;
    Desc : string;
begin
{$IFDEF BTP}
  if Key = VK_F2 then
  begin
    desc := '';
    TOBA := FindTOBArtRow(TOBPiece, TOBArticles, GS.Row);
    if TOBA <> nil then
      begin
      if TOBA.GetValue('GA_TYPEARTICLE') = 'OUV' then
        begin
        // lecture � partir du libell� car impossibilit� de retrouver le code
        // de la d�clinaison. Ne fonctionnera pas si le libell� est modifi�
        // dans le document.
        TOBL := GetTOBLigne(TOBPiece, GS.Row); // r�cup�ration TOB ligne
        Requete := 'SELECT GNE_BLOCNOTE FROM NOMENENT WHERE GNE_LIBELLE="' + TOBL.GetValue('GL_LIBELLE') + '"';
        QQ := Opensql(Requete, True,-1, '', True);
        Desc := QQ.Fields[0].AsString;
        if Desc <> '' then StringToRich(Descriptif, Desc);
        Ferme(QQ);
        end;
      if Desc = '' then StringToRich(Descriptif, TOBA.GetValue('GA_BLOCNOTE'));
      end;
  end;
{$ENDIF}
end;

{$IFDEF MODE}

procedure TFFacture.TraiteLaFusion(AvecAffichage: Boolean);
begin
  //Ne g�re pas la fusion pour les Tickets
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
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLeDocument(-1);

    //Si la fusion s'est bien d�roul� alors affichage du document fusionn�
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


{***********A.G.L.***********************************************
Auteur  ...... : Thierry Petetin
Cr�� le ...... : 22/05/2003
Description .. : V�rifie si on peut changer l'article lors de la saisie d'une pi�ce
  Dans tous les cas (Cr�ation, modification, Transformation de pi�ce)
    La ligne ne doit pas �tre issue d'une ligne pr�c�dente
  En transformation :
    La pi�ce d'origine ne doit pas g�rer d'historique et la pi�ce de destination ne doit pas g�rer les reliquats
  En modification :
    La ligne ne doit pas �tre issue d'une ligne pr�c�dente ni avoir de ligne suivante
*****************************************************************}

function TFFacture.CanChangeArticle(TobL: Tob): Boolean;
begin
  Result := True;
  if Assigned(Tobl) then
  begin
    if TransfoPiece then { Transformation d'une pi�ce en cours }
    begin
      if WithPiecePrecedente(Tobl) then
        Result := (not HistoPiece(TobPiece_O)) and (not GppReliquat);
    end
    else if (Action = taModif) and (not DuplicPiece) then { Modification d'une pi�ce }
      Result := (not WithPiecePrecedente(Tobl)) and (not WithPieceSuivante(TobL));
{$IFDEF BTP}
    if TOBL.GetValue ('GL_ARTICLE') <> '' then result := false;
{$ENDIF}
  end;
end;


procedure TFFacture.DetailOuvrageClick(Sender: TObject);
begin
  MBDetailNomenClick(GS);
end;

procedure TFFacture.SousDetailAffClick(Sender: TObject);
var TOBL: TOB;
  bc: boolean;
begin
//  if OrigineEXCEL then exit;
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // r�cup�ration TOB ligne
  if TOBL = nil then exit;
  if IsLigneFromBordereau(TOBL) then exit;
//  if BTypeArticle.Visible then BTypeArticle.Visible := false;
	BouttonInVisible;
  if TOBL.getValue('GL_TYPEARTICLE') = 'OUV' then
  begin
    GS.SynEnabled := false;
    SuppressionDetailOuvrage(GS.Row);
    if TOBL.getValue('GL_TYPEPRESENT') > DOU_AUCUN then TOBL.PutValue('GL_TYPEPRESENT', DOU_AUCUN)
    else TOBL.PUtvalue('GL_TYPEPRESENT', PresentSousDetail);
    AffichageDetailOuvrage(GS.Row);
    GS.Invalidate;
    GS.SynEnabled := true;
  end;
  bc := false;
  GSRowEnter(GS, GS.Row, bc, False);
  BouttonVisible(GS.row);
end;

procedure TFFacture.BminuteClick(Sender: TObject);
begin
  ImprimeMinute(TOBArticles, TOBPiece, TOBOUvrage, TOBTiers, TOBAffaire);
end;

procedure TFFacture.Bminute2Click(Sender: TObject);
begin
  GereCalculPieceBTP;
  LanceMinuteDevis (TOBPiece,TOBTiers,TOBOUvrage,TOBOuvragesP,TOBArticles,DEV);
end;

procedure TFFacture.PosValueCell(valeur: string);
begin
  stcellCur := valeur;
end;

procedure TFFacture.BouttonVisible(Arow: integer);
var TOBL: TOB;
  Arect: Trect;
begin
  TOBL := GetTOBLigne(TOBPiece, Arow); // r�cup�ration TOB ligne
  if (SG_TypA <> -1) and (TOBL <> nil) and (Action <> taconsult) then
  begin
    ARect := GS.CellRect(SG_Typa, Arow);
    NumGraph := RecupTypeGraph(TOBL);
    BTypeArticle.ImageIndex := NumGraph;
    BTYpeArticle.Opaque := false;
    BTYpeArticle.visible := false;
		if IsArticle(TOBL) then
    begin
      with BTypeArticle do
      begin
        Top := Arect.top - GS.GridLineWidth;
        Left := Arect.Left;
        Width := Arect.Right - Arect.Left;
        Height := Arect.Bottom - Arect.Top;
        Parent := GS;
        Visible := true;
        if (TOBL.GetValue('GL_TYPEARTICLE') = 'OUV') and (IsArticle(TOBL)) then
        begin
          DropdownArrow := true;
          DropdownMenu := PopOuvrage;
        end else
        begin
          DropdownArrow := false;
          DropdownMenu := nil;
        end;
      end;
    end;
  end;
  if (SG_VOIRDETAIL <> -1) and (TOBL <> nil) and (Action <> taConsult) then
  begin
    ARect := GS.CellRect(SG_VOIRDETAIL, Arow);
    BOuvrirFermer.Opaque := false;
    BOuvrirFermer.visible := false;
    with BOuvrirFermer do
    begin
      if (TOBL.GetValue('GL_TYPEARTICLE')='OUV') and (IsArticle(TOBL)) then
      begin
        Top := Arect.top - GS.GridLineWidth;
        Left := Arect.Left;
        Width := Arect.Right - Arect.Left;
        Height := Arect.Bottom - Arect.Top;
        Parent := GS;
        if TOBL.GetValue('GLC_VOIRDETAIL')='X' then
        begin
          BOuvrirFermer.ImageIndex := 1;
        end else
        begin
          BOuvrirFermer.ImageIndex := 0;
        end;
        Visible := true;
      end;
    end;
  end;
end;

procedure TFFacture.BouttonInVisible;
begin
  BTypeArticle.visible := false;
  BOuvrirFermer.visible := false;
end;

procedure TFFacture.BZoomTacheClick(Sender: TObject);
  var vStCleLigne : string;
begin
{$IFDEF AFFAIRE}
  Bvalider.enabled := PieceModifiee;
  ClickValide (False);
  BValider.Enabled:=True;
  vStCleLigne := EncodeRefPiece (GetTOBLigne(TOBPiece,GS.Row));
  AFLignePieceToTache (TobAffaire.GetValue ('AFF_AFFAIRE'), TobAffaire.GetValue ('AFF_TIERS'), vStCleLigne, Action);
{$ENDIF}
end;

procedure TFFacture.SGEDLigneClick(Sender: TObject);
var CleLigne, Param : string;
    NumOrdre : integer;
    TOBL : TOB;
begin
  {$IFNDEF EAGLCLIENT}
  TOBL := GetTOBLigne(TOBPiece, GS.Row); if TOBL=Nil then Exit ;
  NumOrdre:=TOBL.GetValue('GL_NUMORDRE') ;
  CleLigne := CleDoc.NaturePiece + CleDoc.Souche + IntToStr(CleDoc.NumeroPiece) + IntToStr(CleDoc.indice) + IntToStr(NumOrdre);
  Param := CleDoc.NaturePiece + ';' + CleDoc.Souche + ';' + IntToStr(CleDoc.NumeroPiece) + ';' + IntToStr(CleDoc.indice) + ';' + IntToStr(NumOrdre);
  AglIsoflexViewDoc(NomHalley, 'FACTURE', 'LIGNE', 'GL_CLE1', 'GL_NATUREPIECEG, GL_SOUCHE, GL_NUMERO, GL_INDICEG, GL_NUMORDRE', CleLigne, Param);
  {$ENDIF}
end;

procedure TFFacture.GP_REFINTERNEExit(Sender: TObject); 
begin
  if not ReferenceIntExtIsOk(crInterne, TobPiece, GP_REFINTERNE.Text) then GP_REFINTERNE.SetFocus;
end;

procedure TFFacture.GP_REFEXTERNEExit(Sender: TObject);
begin
  if not ReferenceIntExtIsOk(crExterne, TobPiece, GP_REFEXTERNE.Text) then GP_REFEXTERNE.SetFocus;
end;

procedure TFFacture.MBCtrlFactClick(Sender: TObject);
begin
//if (VenteAchat = 'ACH') and (GetInfoParPiece(NewNature,'GPP_TYPEECRCPTA') = 'NOR') then
    if (VenteAchat = 'ACH') and (not IsTransformable(NewNature)) then
    Entree_ControleFacture (TOBBases, TOBBasesSaisies, TOBPiece, TobTiers, Action);
end;

procedure TFFacture.BZoomRevisionClick(Sender: TObject);
var
  St: string;
  TobL: Tob;
begin
  {$IFDEF AFFAIRE}
  TobL := GetTOBLigne(TOBPiece, GS.Row);
  St := ' WHERE AFR_AFFAIRE ="' + TobL.GetValue('GL_AFFAIRE') + '"';
  St := St + ' AND AFR_NATUREPIECEG = "' + TobL.GetValue('GL_NATUREPIECEG') + '"';
  St := St + ' AND AFR_SOUCHE = "' + TobL.GetValue('GL_SOUCHE') + '"';
  St := St + ' AND AFR_NUMERO = ' + intToStr(TobL.GetValue('GL_NUMERO'));
  St := St + ' AND AFR_INDICEG = ' + intToStr(TobL.GetValue('GL_INDICEG'));
  St := St + ' AND AFR_NUMORDRE = ' + intToStr(TobL.GetValue('GL_NUMORDRE'));

  AglLanceFicheAFREVISION('', 'Clause_where=' + St + ';LIGNEAFFAIRE;ACTION=MODIFICATION');
  {$ENDIF}
end;


{$IFDEF GPAO}
procedure TFFacture.TraiteCircuit(var ACol, ARow: integer; var Cancel: boolean);
var sSQL: string;
  Q: tquery;
  Codecirc, CodeArt, NaturePiece: string;
begin
  NaturePiece := GetChampLigne(TOBPiece, 'GL_NATUREPIECEG', ARow);
  CodeCirc := GS.Cells[SG_CIRCUIT, ARow];
  CodeArt :=  GetCodeArtUnique(TOBPiece, ARow);
  sSQL := 'SELECT QCI_CIRCUIT ' +
    'FROM QCIRCUIT ' +
    
  'WHERE "' + CodeCirc + '" IN (SELECT QCI_CIRCUIT ' +
    'FROM WARTNAT ' +
    'LEFT JOIN QCIRCUIT Q1 ON QCI_CODITI=WAN_CODITI ' +
    'WHERE WAN_ARTICLE="' + CodeArt + '" ' +
    'AND WAN_NATURETRAVAIL="FAB" ' +
    'AND NOT EXISTS (SELECT "X" ' +
    'FROM QDETCIRC Q2 ' +
    'LEFT JOIN QSITE ON Q2.QDE_SITE=QSI_SITE AND Q2.QDE_CTX=QSI_CTX ' +
    'WHERE Q2.QDE_CIRCUIT = Q1.QCI_CIRCUIT ' +
    'AND QSI_TIERS<>"' + TOBPiece.GetValue('GP_TIERS') + '" ' +
    'AND  Q2.QDE_OPECIRC <> (SELECT MAX(Q3.QDE_OPECIRC) ' +
    'FROM QDETCIRC Q3 ' +
    'WHERE Q3.QDE_CTX=Q1.QCI_CTX ' +
    'AND   Q3.QDE_CIRCUIT = Q1.QCI_CIRCUIT)) ' +
    'AND EXISTS(SELECT "X" ' +
    'FROM QDETCIRC Q4 ' +
    'LEFT JOIN QSITE ON Q4.QDE_SITE=QSI_SITE AND Q4.QDE_CTX=QSI_CTX ' +
    'WHERE Q4.QDE_CIRCUIT = Q1.QCI_CIRCUIT ' +
    'AND QSI_DEPOT="' + TOBPiece.GetValue('GP_DEPOT') + '" ' +
    'AND Q4.QDE_OPECIRC = (SELECT MAX(Q5.QDE_OPECIRC) ' +
    'FROM QDETCIRC Q5 ' +
    'WHERE Q5.QDE_CTX=Q1.QCI_CTX ' +
    'AND   Q5.QDE_CIRCUIT = Q1.QCI_CIRCUIT))) ';
  
  Q := OPENSQL(sSQL, true,-1, '', True);
  if Q.EOF then
  begin
    ferme(Q);
    sSQL := 'SELECT QCI_CIRCUIT FROM QCIRCUIT WHERE QCI_CIRCUIT="' + CodeCirc + '" ';
    Q := OPENSQL(sSQL, true,-1, '', True);
    if Q.Eof then
    begin
      PGIInfo('Le circuit ' + CodeCirc + ' n''existe pas');
      GS.Cells[SG_CIRCUIT, ARow] := '';
      Ferme(Q);
      Cancel := true;
    end
    else
    begin
      ferme(Q);
      PGIInfo('Le circuit ' + CodeCirc + ' est incorrect');
      GS.Cells[SG_CIRCUIT, ARow] := '';
      Cancel := true;
    end;
  end
  else
  begin
    ferme(Q);
    TOBPiece.Detail[ARow - 1].PutValue('GLC_CIRCUIT', CodeCirc);
    Cancel := false;
  end;
end;
{$ENDIF GPAO}

{$IFDEF GPAO}
function TFFacture.RechLeBonCircuit(var ACol, ARow: integer): string;
var sql, CodeArt, TypeDim: string;
  q: tquery;
begin
  CodeArt := GetCodeArtUnique(TOBPiece, gs.row); //GetChampLigne(TOBPiece,'GL_ARTICLE',ARow);
  TypeDim := GetChampLigne(TOBPiece, 'GL_TYPEDIM', ARow);
  if TypeDim <> 'DIM' then
  begin
    SQL := 'SELECT QCI_CIRCUIT,WAN_CIRCUIT ' +
      'FROM WARTNAT ' +
      'LEFT JOIN QCIRCUIT Q1 ON QCI_CODITI=WAN_CODITI ' +
      'WHERE WAN_ARTICLE="' + CodeArt + '" ' +
      'AND WAN_NATURETRAVAIL="FAB" ' +
      'AND NOT EXISTS (SELECT "X" ' +
      'FROM QDETCIRC Q2 ' +
      'LEFT JOIN QSITE ON Q2.QDE_SITE=QSI_SITE AND Q2.QDE_CTX=QSI_CTX ' +
      'WHERE Q2.QDE_CIRCUIT = Q1.QCI_CIRCUIT ' +
      'AND QSI_TIERS<>"' + TOBPiece.GetValue('GP_TIERS') + '" ' +
      'AND  Q2.QDE_OPECIRC <> (SELECT MAX(Q3.QDE_OPECIRC) ' +
      'FROM QDETCIRC Q3 ' +
      'WHERE Q3.QDE_CTX=Q1.QCI_CTX ' +
      'AND   Q3.QDE_CIRCUIT = Q1.QCI_CIRCUIT)) ' +
      'AND EXISTS(SELECT "X" ' +
      'FROM QDETCIRC Q4 ' +
      'LEFT JOIN QSITE ON Q4.QDE_SITE=QSI_SITE AND Q4.QDE_CTX=QSI_CTX ' +
      'WHERE Q4.QDE_CIRCUIT = Q1.QCI_CIRCUIT ' +
      'AND QSI_DEPOT="' + TOBPiece.GetValue('GP_DEPOT') + '" ' +
      'AND Q4.QDE_OPECIRC = (SELECT MAX(Q5.QDE_OPECIRC) ' +
      'FROM QDETCIRC Q5 ' +
      'WHERE Q5.QDE_CTX=Q1.QCI_CTX ' +
      'AND   Q5.QDE_CIRCUIT = Q1.QCI_CIRCUIT))' +
      'ORDER BY IIF(QCI_CIRCUIT=WAN_CIRCUIT,0,1),QCI_CIRCUIT';
    Q := OPENSQL(SQL, true,-1, '', True);
    if not Q.EOF then
    begin
      if (q.RecordCount = 1)
        or (Q.FINDFIELD('QCI_CIRCUIT').asstring = Q.FINDFIELD('WAN_CIRCUIT').asstring) then
      begin
        result := Q.FINDFIELD('QCI_CIRCUIT').asstring;
        RepercCircArtDim(GS, TOBPiece, GetChampLigne(TOBPiece, 'GL_REFARTSAISIE', gs.Row));
      end
      else if q.RecordCount > 1 then
        result := '';
    end
    else
      result := '';
    ferme(Q);
  end;
end;
{$ENDIF GPAO}



procedure TFFacture.GSSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
{$IFDEF GPAO}
var IdentWOL: integer;
{$ENDIF}
begin
{$IFDEF GPAO}
  IdentWOL := GetChampLigne(TOBPiece, 'GL_IDENTIFIANTWOL', ARow);
  {Je suis en modification de piece, ma pi�ce pilote un ordre de fabrication}
  if (Action = taModif) and (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_PILOTEORDRE') = 'X') then
  begin
    {je suis sur une ligne d�j� existante et je ne suis pas en train de r�ceptionner}
    if (IdentWOL <> 0) and (not transfopiece) then
    begin
      if (uOkModifPiece(IdentWOL) = false) then
      begin
        if ((Acol <> SG_PX) and (Acol <> SG_rem) and (Acol <> SG_montant)) then
        begin
          gs.col := SG_PX;
          canselect := false;
        end
        else
          canselect := true;
      end
      else
      begin
        if GetChampLigne(TOBPiece, 'GL_TYPEDIM', ARow) = 'DIM' then
        begin
          if ((Acol = SG_CIRCUIT)) then
          begin
            gs.col := SG_PX;
            canselect := false;
          end
          else
            canselect := true;
        end
        else
          canselect := true;
      end;
    end
      {je suis sur une ligne d�j� existante et je suis en train de r�ceptionner}
    else if (IdentWOL <> 0) and (transfopiece) then
    begin
      if ((Acol <> SG_QF) and (Acol <> SG_PX) and (Acol <> SG_rem) and (Acol <> SG_montant)) then
      begin
        gs.col := SG_QF;
        canselect := false;
      end
      else
        canselect := true;
    end
      {je suis sur nouvelle ligne et je suis en train de r�ceptionner }
    else if (IdentWOL = 0) and (transfopiece) then
    begin
      gs.col := SG_PX;
      canselect := false;
    end
      {je suis sur nouvelle ligne, je ne suis pas en train de r�ceptionner et j'ai pas le droit d'ins�rer des lignes }
    else if (IdentWOL = 0) and (not transfopiece) and (GetInfoParpiece(cleDoc.NaturePiece, 'GPP_INSERTLIG') = '-') then
    begin
      gs.col := SG_PX;
      canselect := false;
    end
    else
      canselect := true;
  end
  else
  begin
    canselect := true;
  end;
  {$ELSE}
    canselect := true;
  {$ENDIF GPAO}

  if (Cledoc.NaturePiece = 'TRE') and (TobPiece_O.getvalue('GP_NATUREPIECEG') = 'TRV')
    and (Arow > Tobpiece.detail.count)
    and (GetInfoParpiece(cledoc.NaturePiece, 'GPP_INSERTLIG') = '-') then
  begin
    gs.col := 1;
    canselect := false;
  end
  else
    canselect := true;
end;


{$IFDEF GPAO}

function TFFacture.ControleCellModifSt(IdentifiantWOL: integer): boolean;
var
  Q: tQuery;
  sSql: string;
begin
  Result := True;
  sSql := 'SELECT SUM(WOB_QCONSTOC), SUM(WOB_QTSTSTOC) '
    + 'FROM WORDREBES '
    + 'LEFT JOIN WORDRELIG ON (WOB_NATURETRAVAIL=WOL_NATURETRAVAIL) AND (WOB_LIGNEORDRE=WOL_LIGNEORDRE) '
    + 'WHERE (WOL_IDENTIFIANT = "' + IntToStr(IdentifiantWOL) + '") '
    + 'GROUP BY WOB_NATURETRAVAIL, WOB_LIGNEORDRE '
    ;
  Q := OpenSQL(sSql, True,-1, '', True);
  try
    if not Q.Eof then
      Result := (Q.fields[0].AsInteger = 0) and (Q.fields[1].AsInteger = 0)
    else
      Result := True;
  finally
    Ferme(Q);
  end;
end;
{$ENDIF GPAO}

function TFFacture.IsChpsObligOk(PieceOuLigne, NumLigne : integer) : boolean; // JT - eQualit� 10819
var TobL, TobTmp : TOB;
    Cpt : integer;
begin
  Result := True;
{$IFNDEF CCS3}
  if VH_GC.IsChpsOblig = False then exit;       
  if Action = taConsult then Exit;
  if PieceOuLigne = 1 then
  begin
    TobL := GetTobLigne(TobPiece,NumLigne);
    if TobL = nil then exit;
    if TobL.GetValue('GL_ARTICLE') = '' then exit;
  end else
  begin
    TobL := TobPiece;
  end;
  if VenteAchat = 'VEN' then
    TobTmp := VH_GC.MTobChpsOblig.Detail[0].Detail[PieceOuLigne]
    else
    TobTmp := VH_GC.MTobChpsOblig.Detail[1].Detail[PieceOuLigne];
  for Cpt := 0 to TobTmp.detail.count -1 do
  begin
    if TobL.GetValue(TobTmp.Detail[0].GetValue('NOMCHAMP')) = TobTmp.Detail[0].GetValue('VALEURVIDE') then
    begin
      PGIBox('La saisie du champ suivant est obligatoire : '+TobTmp.Detail[0].GetValue('LIBCHAMP'),'ATTENTION');
      Result := False;
      Exit;
    end;
  end;
{$ENDIF CCS3}
end;

procedure TFFacture.FTitrePieceClick(Sender: TObject);
begin
  if DelphiRunning and V_PGI.Sav then
    www(TobPiece);
end;

procedure TFFacture.SetPieceMajStockPhysique;
var
  NewNat, OldNat: String;
  ColPlus, ColMoins: String;
begin
  NewNat := TOBPiece.GetValue('GP_NATUREPIECEG');
  ColPlus := GetInfoParPiece(NewNat, 'GPP_QTEPLUS');
  ColMoins := GetInfoParPiece(NewNat, 'GPP_QTEMOINS');
  PieceMajStockPhysique := ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0));
  PiecePrecMajStockPhysique := False;
  if TransfoPiece then
  begin
    OldNat := TOBPiece_O.GetValue('GP_NATUREPIECEG');
    ColPlus := GetInfoParPiece(OldNat, 'GPP_QTEPLUS');
    ColMoins := GetInfoParPiece(OldNat, 'GPP_QTEMOINS');
    PiecePrecMajStockPhysique := ((Pos('PHY', ColPlus) > 0) or (Pos('PHY', ColMoins) > 0));
  end;
end;

procedure TFFacture.Complmentvariables1Click(Sender: TObject);
begin
{$IFDEF BTP}
  if (not OrigineEXCEL) and (GetParamSoc('SO_BTMETREDOC')) then
  begin
    ModifieVariables := true;
    TheMetre.LanceVar(Action);
  end;
{$ENDIF}
end;

procedure TFFacture.VoirFrancClick(Sender: TObject);
{$IFDEF BTP}
var VisuDocument : T_VisuDoc;
{$ENDIF}
begin
{$IFDEF BTP}
	GereCalculPieceBTP;
  VisuDocument := T_VisuDoc.create;
  TRY
    VisuDocument.TOBPiece := TOBpiece;
    VisuDocument.Modegestion := GdeVisuFRF;
    VisuDocument.VoirDocument;
  FINALLY
    VisuDocument.Free;
  END;
{$ENDIF}
//
end;
(*
procedure TFFacture.FinKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 86) and (Shift = [ssCtrl]) then // CTRL + V
  begin
    FIN.Invalidate;
  end;
end;

procedure TFFacture.DebutKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 86) and (Shift = [ssCtrl]) then // CTRL + V
  begin
    DEBUT.Invalidate;
  end;
end;
*)
procedure TFFacture.LoadLesGCS;
var Q : TQuery;
begin
  Q := OpenSQL('Select * from Commun where CO_TYPE="GCS" and CO_LIBRE Like "%'+VH_GC.GCMarcheVentilAna+'%"',True,-1, '', True);
  if not Q.eof Then TOBTablette.LoadDetailDB ('COMMUN','','',Q,false,true);
  ferme (Q);
end;

{$IFDEF BTP}
procedure TFFacture.BTPClickDel(ARow: integer);
begin
  ClickDel(ARow, True, False, False, True);
end;

procedure TFFacture.SetBloquageTarif(Arow : integer);
var TOBL : TOB;
		indice : integer;
begin
  for Indice := 0 to TOBpiece.detail.count -1 do
  begin
    TOBL := GetTOBLigne (TOBPiece,Indice+1);
    if TOBL = nil then exit;
    if not (TOBL.getValue('GLC_FROMBORDEREAU')='X') then TOBL.Putvalue('GL_BLOQUETARIF',TOBPiece.GetValue('_BLOQUETARIF'));
  end;
end;

procedure TFFacture.TraiteLivrFromRecep;
var TheDoc : T_VisuDoc;
begin
	TheDoc := T_VisuDoc.create;
  TRY
    TheDoc.TOBAffaire := TOBAffaire;
    TheDoc.TOBTiers := TOBTiers;
    TheDoc.TOBRecep := GestionConso.GetTOBrecepHLien;
    TheDoc.Modegestion := GdeSelectRF;
    TheDoc.VoirDocument;
    if TheDoc.TOBresult <> nil then
    begin
      AjouteLesLignesBTP (self,TOBpiece,TOBAffaire,TobTiers,TOBArticles,TheDoc,GestionConso);
    end;
  FINALLY
  	TheDoc.free;
  END;
end;
{$ENDIF}

procedure TFFacture.ModebordereauClick(Sender: TObject);
begin
{$IFDEF BTP}
  if (tModeSaisieBordereau in SaContexte) then exit;
	if VenteAchat <> 'VEN' then exit;
  if TOBPiece.GetValue('_BLOQUETARIF')='X' Then
  begin
    TmenuItem(FindComponent('Modebordereau')).caption := 'Mode P.V bloqu�';
    TToolBarButton97(FindComponent('BprixMarche')).enabled := true;
    self.caption := TitreInitial;
    self.refresh;
    TOBPiece.PutValue('_BLOQUETARIF','-');
  end else
  begin
    TToolBarButton97(FindComponent('BprixMarche')).enabled := false;
    TmenuItem(FindComponent('Modebordereau')).caption := 'Mode standard';
    self.caption := TitreInitial + ' (Mode P.U bloqu�)';
    self.refresh;
    TOBPiece.PutValue('_BLOQUETARIF','X');
  end;
  SetBloquageTarif(GS.row);
  GS.Invalidate;
{$ENDIF}
end;

procedure TFFacture.SetLigTobDelete (NumLig : integer);
begin
    ClickDel(NumLig, True, True, True);
end;

{$IFDEF BTP}
procedure TFFacture.MultiSelectionBordereau(TOBMultiSel : TOB);
var RefUnique, LibRef, Msg,Select : string;
    ARow, iInd, QteInit : integer;
    Cancel,InfoLotSerie, InfoRupture : Boolean;
    TOBArt, TOBL : TOB;
    QQ : TQuery;
    TOBMSL : TOB;
begin
  Cancel := False;
  ARow := GS.Row;
  GS.Cells[SG_RefArt, ARow] := '';
  MultiSel_SilentMode := True;
  InfoLotSerie := False;
  InfoRupture := False;
  DepileTOBLignes(GS, TOBPiece, ARow, ARow);
  InitMoveProgressForm(nil,Caption,TraduireMemoire('Insertion de l''article : '),TobMultiSel.Detail.Count,True,True);
  TRY
  for iInd := 0 to TobMultiSel.Detail.Count -1 do
  begin
  	TOBMSL := TobMultiSel.Detail[iInd];
    Select := 'SELECT LIGNE.*,LIGNECOMPL.*,N.BNP_TYPERESSOURCE FROM LIGNE '+
							'LEFT JOIN NATUREPREST N ON BNP_TYPERESSOURCE=(SELECT GA_NATUREPRES FROM ARTICLE WHERE GA_ARTICLE=LIGNE.GL_ARTICLE) '+
              'LEFT JOIN LIGNECOMPL ON (GL_NATUREPIECEG = GLC_NATUREPIECEG and GL_SOUCHE = GLC_SOUCHE AND GL_NUMERO = GLC_NUMERO ' +
              'AND GL_INDICEG = GLC_INDICEG and GL_NUMORDRE = GLC_NUMORDRE) '+
							'WHERE GL_NATUREPIECEG="'+TOBMSL.GetValue('GL_NATUREPIECEG')+'" AND '+
    					'GL_SOUCHE="'+TOBMSL.GetValue('GL_SOUCHE')+'" AND ' +
    					'GL_NUMERO='+InttoStr(TOBMSL.GetValue('GL_NUMERO'))+' AND ' +
              'GL_INDICEG='+IntToStr(TOBMSL.getValue('GL_INDICEG'))+' AND ' +
              'GL_NUMORDRE='+IntToStr(TOBMSL.getValue('GL_NUMORDRE'));
    QQ := OpenSql (Select,True,-1, '', True);
    TOBMSL.SelectDb ('',QQ);
    ferme (QQ);
    if TOBMSL.getValue('GLC_GETCEDETAIL') = 'X' then
    begin
    	// on charge les lignes de sous d�tail correspondante
      LoadlesSousDetailBordereaux (TOBpiece,TOBMSL,TOBArticles);
    end;
    RefUnique := TOBMSL.GetValue('GL_ARTICLE');
    if RefUnique <> '' then
    begin
      TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
      if TOBArt = nil then
      begin
        QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                       'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                       'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
        if not QQ.EOF then
        begin
          TOBArt := CreerTOBArt(TOBArticles);
          ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QQ) ;
        end;
        Ferme(QQ);
      end;
      if TobArt = nil then continue;

      LibRef := TOBMsl.GetValue('GL_LIBELLE');
      if not MoveCurProgressForm(TOBMSL.GetValue('GL_REFARTTIERS') + ' ' + LibRef) then break;

      QteInit := 1;
      //Exceptions     //JS supprim� le 20/07/04
      ///if (PieceContainer.GereLot and (TOBArt.GetValue('GA_LOT') = 'X')) then QteInit := 0;
      //if (PieceContainer.GereSerie and (TOBArt.GetValue('GA_NUMEROSERIE') = 'X')) then QteInit := 0;

      if not InsertNewArtInGS(RefUnique, LibRef, QteInit,Arow,TOBMSL) then continue;
(*      GSRowExit(nil, GS.Row, Cancel, False); *)
      GSRowExit(nil, ARow, Cancel, False);

      if Cancel then break;
      TOBL := GetTOBLigne(TOBPiece, ARow);  // Avant il y avait GS.row
      TOBL.PutValue('GLC_FROMBORDEREAU','X');
      TOBL.PutValue('GL_BLOQUETARIF','X');

      inc(Arow);
    end;
  end;
  FINALLY
  	FiniMoveProgressForm;
  END;
{
  if InfoRupture then Msg := 'Les quantit�s signal�es en rouge indiquent une rupture de stock.';
  if InfoLotSerie then
  begin
    if Msg <> '' then Msg := Msg + '#13';
    Msg := Msg + 'Certaines lignes n''ont pas de quantit�. Une gestion particuli�re vous oblige � la saisir manuellement.';
  end;
}
  if Msg <> '' then PGIInfo(Msg,Caption);
  StCellCur := GS.Cells[GS.Col, GS.Row];  //JS 20/07/04
  CalculeLaSaisie(-1, -1, False);
  MultiSel_SilentMode := False;
end;
{$ENDIF}

procedure TFFacture.MultiSelectionArticle(TobMultiSel : TOB);
var RefUnique, LibRef, Msg : string;
    ARow, iInd, QteInit,CurRow,CurCol : integer;
    Cancel,InfoLotSerie: Boolean;
    TOBArt, TOBL : TOB;
    QQ : TQuery;
    Ipourcent : integer;
begin
	CurCol := GS.col;
	CurRow := GS.row;
  Cancel := False;
  ARow := GS.Row;
  GS.Cells[SG_RefArt, ARow] := '';
  MultiSel_SilentMode := True;
  InfoLotSerie := False;
  SelInfoRupture := False;
  DepileTOBLignes(GS, TOBPiece, ARow, ARow);
  InitMoveProgressForm(nil,Caption,TraduireMemoire('Insertion de l''article : '),TobMultiSel.Detail.Count,True,True);
  for iInd := 0 to TobMultiSel.Detail.Count -1 do
  begin
    RefUnique := TobMultiSel.Detail[iInd].GetValue('ARTICLE');
    if RefUnique <> '' then
    begin
      TOBArt := FindTOBArtSais(TOBArticles, RefUnique);
      if TOBArt = nil then
      begin
        QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                       'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                       'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+RefUnique+'"',true,-1, '', True);
        if not QQ.EOF then
        begin
          TOBArt := CreerTOBArt(TOBArticles);
          ChargerTobArt(TOBArt,TobAFormule,VenteAchat,'',QQ) ;
        end;
        Ferme(QQ);
      end;
      if TobArt = nil then continue;

      LibRef := TOBArt.GetValue('GA_LIBELLE');
      if not MoveCurProgressForm(TOBArt.GetValue('GA_CODEARTICLE') + ' ' + LibRef) then break;

      QteInit := 1;
      //Exceptions     //JS supprim� le 20/07/04
      ///if (PieceContainer.GereLot and (TOBArt.GetValue('GA_LOT') = 'X')) then QteInit := 0;
      //if (PieceContainer.GereSerie and (TOBArt.GetValue('GA_NUMEROSERIE') = 'X')) then QteInit := 0;

      if not InsertNewArtInGS(RefUnique, LibRef, QteInit,Arow) then continue;

(*      GSRowExit(nil, GS.Row, Cancel, False); *)
      GSRowExit(nil, ARow, Cancel, False);

      if Cancel then break;
      TOBL := GetTOBLigne(TOBPiece, ARow);  // Avant il y avait GS.row
//      if not InfoRupture then InfoRupture := (TOBL.GetValue('RUPTURE') = 'X');
    	Ipourcent := PositionneRecalculePourcent (Arow);
      inc(Arow);
      //if not InfoLotSerie then InfoLotSerie := (TOBL.GetValue('GL_QTEFACT') = 0);
    end;
  end;
  FiniMoveProgressForm;
  if SelInfoRupture then Msg := 'Certains articles n''ont pu �tre int�gr�s suite � une rupture de stock';
  if InfoLotSerie then
  begin
    if Msg <> '' then Msg := Msg + '#13';
    Msg := Msg + 'Certaines lignes n''ont pas de quantit�. Une gestion particuli�re vous oblige � la saisir manuellement.';
  end;
  if Msg <> '' then PGIInfo(Msg,Caption);
  CalculeLaSaisie(-1, -1, False);
  if IPourcent <> -1 then AfficheLaLigne (IPourcent+1);
  GoToLigne(CurCol,CurRow);
  StCellCur := GS.Cells[GS.col, GS.row];
  MultiSel_SilentMode := False;
end;

procedure TFFacture.MBREPARTTVAClick(Sender: TObject);
{$IFDEF BTP}
var isExists : boolean;
{$ENDIF}
begin
{$IFDEF BTP}
  if (ModifAvanc) and (TOBpiece.GetValue('GP_NATUREPIECEG')='FBT') then
  begin
    PGIBox('IMPOSSIBLE : Ce document est issu d''un devis');
    exit;
  end;
	if IsDejaFacture then
  begin
  	PGIBox('IMPOSSIBLE : Une facturation � d�j� �t� effectu� sur ce devis');
    exit;
  end;
  TheTOb := TheRepartTva.Tobrepart  ;
  if (TheTOB <> nil) and (TheTOB.detail.count > 0) then IsExists := true else IsExists := false;
  if TheTOB.FieldExists ('VALIDATION') then TheTOB.PutValue ('VALIDATION','-')
  																		 else TheTOB.AddChampSupValeur ('VALIDATION','-');
  definiRepartitionTva (Action);
  if TheTOB <> nil then
  begin
  	if TheTOB.GetValue ('VALIDATION') = 'X' then
    begin
      if IsExists then
      begin
        TheRepartTva.InitAppliquePiece;
      end;
    	TheRepartTva.Applique;
    	TobPiece.putValue ('GP_RECALCULER','X');
  		CalculeLaSaisie(-1, -1, False);
    end;
    TheTOB := nil;
  end;
{$ENDIF}
end;

procedure TFFacture.VerifRefTiers (var Acol,Arow : integer; var Cancel : boolean);
begin
  if GS.Cells[ACol, ARow] = '' then exit;
  if TOBPIece.findFirst(['GL_REFARTTIERS'],[GS.Cells[ACol, ARow]],true) <> nil then
  begin
  	PGIError (TraduireMemoire('Cette r�f�rence tiers existe d�j�'),caption);
    Cancel := True;
    exit;
  end;
end;

procedure TFFacture.ZoomUnite (Acol,Arow : integer);
var CODE: THCritMaskEdit;
  Coord: TRect;
	TOBL : TOB;
begin
  if ACol <> SG_Unit then Exit;
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  Coord := GS.CellRect(ACol, ARow);
  CODE := THCritMaskEdit.Create(self);
  CODE.Parent := GS;
  CODE.Top := Coord.Top;
  CODE.Left := Coord.Left;
  CODE.Width := 3;
  CODE.Visible := False;
  CODE.Text := GS.Cells[ACol, ARow];
  CODE.DataType := 'GCQUALUNITEVTE';
  LookupList(CODE,'Unit�','MEA','GME_MESURE','GME_LIBELLE','GME_QUALIFMESURE="PIE"','',false,-1);
  if CODE.Text <> '' then GS.Cells[ACol, ARow] := CODE.Text;
  CODE.Destroy;
end;

procedure TFFacture.VerifUnite (Acol,Arow : integer ; var cancel : boolean);
var std : string;
		TOBL : TOB;
begin
  TOBL := GetTOBLigne(TOBPiece, ARow);
  if TOBL = nil then Exit;
  StD := RechDom('GCQUALUNITPIECE', GS.cells[Acol,Arow], False);
  cancel := ((StD = '') or (StD = 'Error'));
	if IsSousDetail (TOBL) then
  begin
		fModifSousDetail.ModifUniteSousDet (TOBL,GS.Cells[Acol, Arow] );
    exit;
  end;
end;

{$IFDEF BTP}
procedure TFFacture.AjouteMontantPVDevis (TOBL : TOB);
var cledoc : r_cledoc;
		TOBE,TOBD : TOB;
    PiecePrec,RefCherche,RefProvenance,NatureRef : string;
    QQ : TQuery;
begin
	if IsVariante (TOBL) then exit;
  PiecePrec := TOBL.GetValue('GLC_DOCUMENTLIE');
  DecodeRefPiece (PiecePrec,Cledoc);
  RefCherche := cledoc.NaturePiece+';'+cledoc.Souche+';'+IntToStr(cledoc.NumeroPiece);
  NatureRef := cledoc.NaturePiece;
  //
  TOBE := TheListPiecePrec.FindFirst(['REFERENCE'],[RefCherche],true);
  if (TOBE = nil) and (cledoc.NaturePiece = 'DBT') then
  begin
    QQ:= OpenSql ('SELECT GP_TOTALHTDEV FROM PIECE WHERE '+WherePiece(cledoc,ttdPiece,false),true,-1, '', True);
    if not QQ.eof then
    begin
    	TOBE := TOB.Create ('UNE PIECE',TheListPiecePrec,-1);
      //
      TOBE.AddChampSupValeur ('TYPE',NatureRef,false);
      TOBE.AddChampSupValeur ('REFERENCE',RefCherche,false);
      TOBE.AddChampSupValeur ('PROVENANCE','',false);
      TOBE.AddChampSupValeur ('NETTOYE','-',false);
      TOBE.AddChampSupValeur ('MONTANT',QQ.findField('GP_TOTALHTDEV').AsFloat,false);
    end;
    ferme (QQ);
  end;
  PiecePrec := TOBL.GetValue('GL_PIECEORIGINE');
  if (TOBE <> nil) and (PiecePrec <> '') then
  begin
    DecodeRefPiece (PiecePrec,Cledoc);
    Refprovenance := cledoc.NaturePiece+';'+cledoc.Souche+';'+IntToStr(cledoc.NumeroPiece);
    TOBD := TOBE.FindFirst(['PROVENANCE'],[Refprovenance],true);
    if (TOBD = nil) and (cledoc.NaturePiece = 'DBT') then
    begin
      TOBD := TOB.Create ('UNE PIECE',TOBE,-1);
      //
      TOBD.AddChampSupValeur ('TYPE',NatureRef,false);
      TOBD.AddChampSupValeur ('REFERENCE',RefCherche,false);
      TOBD.AddChampSupValeur ('PROVENANCE',Refprovenance,false);
      TOBD.AddChampSupValeur ('NETTOYE','-',false);
      TOBD.AddChampSupValeur ('MONTANT',0);
    end;
  end;
end;

function TFFacture.GetMontantPvDEv : Double;
var Indice : integer;
begin
	result := 0;
  for Indice := 0 to TheListPiecePrec.detail.count -1 do
  begin
  	result := result + TheListPiecePrec.detail[Indice].GetValue('MONTANT');
  end;
end;
{$ENDIF}

procedure TFFacture.RecalculeDocumentClick(Sender: TObject);
begin
	GereCalculPieceBTP(true);
end;


procedure TFFacture.GereCalculPieceBTP (ReafficheTout : boolean);
var i : integer;
begin
  SourisSablier;
  if TOBPiece.GetValue ('GP_RECALCULER')='X' then
  begin
    CalculPieceAutorise := true;
    CalculeLaSaisie (-1,-1,false);
  	AjusteSousDetail (self,TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire);
    if reafficheTout then  for i := 0 to TOBPiece.Detail.Count - 1 do AfficheLaLigne(i + 1);
    if not BcalculDocAuto.Down then CalculPieceAutorise := false;
  end;
  SourisNormale;
end;

procedure TFFacture.BCalculDocAutoClick(Sender: TObject);
begin

  if BcalculDocAuto.Down then
  	 begin
     CalculPieceAutorise := true;
     RecalculeDocument.Visible := false;
     end
  else
     begin
  	 CalculPieceAutorise := false;
     RecalculeDocument.Visible := true;
     end;

end;

procedure TFFacture.DefinieRefInterneExterne(NewNature : string);
begin
  if GetInfoParPiece(NewNature, 'GPP_REFINTEXT') = 'INT' then
  begin
     HGP_REFINTERNE.Caption  := TraduireMemoire('R�f.Interne');
     HGP_REFINTERNE.Visible  := True;
     GP_REFINTERNE.Visible   := True;
     GP_REFEXTERNE.Visible   := False;
     GP_DATEREFEXTERNE.Visible := False;
     GP_REFINTERNE.Enabled := True;
  end
  else if GetInfoParPiece(NewNature, 'GPP_REFINTEXT') = 'EXT' then
  begin
     HGP_REFINTERNE.Caption := TraduireMemoire('R�f.Externe');
     HGP_REFINTERNE.Visible := True;
     GP_REFINTERNE.Visible   := False;
     GP_REFEXTERNE.Visible   := True;
     GP_DATEREFEXTERNE.Visible := False;
     GP_REFEXTERNE.Enabled := True;
  end
  else if GetInfoParPiece(NewNature, 'GPP_REFINTEXT') = 'NON' then
  begin
     HGP_REFINTERNE.Visible := False;
     GP_REFINTERNE.Visible   := False;
     GP_REFEXTERNE.Visible     := False;
     GP_DATEREFEXTERNE.Visible := False;
  end;
end;

procedure TFFacture.ApresInsertionParagraphe;
begin
	RecalculeSousTotaux(TOBPiece);
end;

procedure TFFacture.ActiveEventGrille (Status : boolean);
begin
	if not status then
  begin
		gs.SynEnabled := false;
    GS.OnCellExit := nil;
    GS.OnCellEnter := nil;
  end else
  begin
    GS.OnCellExit := GSCellExit;
    GS.OnCellEnter := GSCellEnter;
		GS.SynEnabled := true;
  end;
end;

procedure TFFacture.AffichageDesDetailOuvrages;
begin
  LoadLesLibDetail(TOBPiece, TOBNomenclature, TobOuvrage, TOBTiers, TOBAffaire, DEV, (SaisieTypeAvanc or ModifAvanc));
end;

procedure TFFacture.GSTopLeftChanged(Sender: TObject);
begin
	BouttonInVisible;
end;

procedure TFFacture.rafraichitPiedAvanc;
begin
  TOBPiece.PutEcran(self, PPiedAvanc);
end;
        
procedure TFFacture.CacheTotalisations (etat : boolean);
begin
  PTotaux.visible := (not Etat);
  PTotaux1.visible := (not Etat);
  BLanceCalc.visible := (Etat);
end;

procedure TFFacture.deduitLaLigne (TOBL : TOB);
begin
  DeduitLigneCalc (TOBL,TOBpiece,TOBPieceTrait,TOBOUvrage,TOBOuvragesP, TOBBases,TOBBasesL,TOBTiers,DEV, Action);
end;

procedure TFFacture.AjouteLaLigne (TOBL : TOB);
begin
	AjoutLigneCalc (TOBL,TOBpiece,TOBPieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBBasesL,TOBTiers,DEV, Action);
end;

procedure TFFacture.InitMontantLigne (TOBL : TOB);
begin
  ZeroLigneMontant (TOBL);  // reinit des montants de la ligne
end;

procedure TFFacture.CalculeLaLigneAV (TOBL : TOB);
begin
  TOBL.PutValue('BLF_MTCUMULEFACT',Arrondi(TOBL.GetValue('BLF_MTMARCHE')*TOBL.GetValue('BLF_POURCENTAVANC')/100,DEV.decimale));
  TOBL.PutValue('BLF_MTSITUATION',TOBL.GetValue('BLF_MTCUMULEFACT')-TOBL.GetValue('BLF_MTDEJAFACT'));
  // Pour les Quantit�s
  TOBL.PutValue('BLF_QTECUMULEFACT',Arrondi(TOBL.GetValue('BLF_QTEMARCHE')*TOBL.GetValue('BLF_POURCENTAVANC')/100,V_PGI.okdecQ));
  TOBL.PutValue('BLF_QTESITUATION',TOBL.GetValue('BLF_QTECUMULEFACT')-TOBL.GetValue('BLF_QTEDEJAFACT'));
  //
  TOBL.PutValue('GL_QTEFACT',TOBL.GetValue('BLF_QTESITUATION'));
  //
  TOBL.putValue('GL_RECALCULER','X');
  TOBPiece.putValue('GP_RECALCULER','X');
end;

procedure TFFacture.CalculeAvancementLigne (TOBL : TOB);
var POurcent : double;
begin
  Pourcent := Arrondi(TOBL.GetValue('BLF_QTECUMULEFACT')/TOBL.GetValue('BLF_QTEMARCHE')*100,2);
  TOBL.PutValue('BLF_POURCENTAVANC',Pourcent);
  CalculeLaLigneAV (TOBL);
end;


procedure TFFacture.ResetCells (Acol,Arow : integer);
begin
  GS.cells[Acol,Arow]:=StCellCur;
end;

procedure TFFacture.ChangeQteSituation (Acol,Arow : integer);

  function ControleQteSaisie (Acol,Arow : integer) : boolean;
  var TOBL : TOB;
  begin
    result := true;
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then exit;
    if (TOBL.GetValue('BLF_QTEDEJAFACT')+Valeur(GS.cells[Acol,Arow])) > TOBL.GetValue('BLF_QTEMARCHE') then
    begin
      result := (PgiAsk (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement > � 100 % ?'))=Mryes)
    end;
  end;

var TOBL : TOB;
    pourcent,Qte : double;
begin
  if ControleQteSaisie (Acol,Arow) then
  begin
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then BEGIN ResetCells(Acol,Arow) ;exit; END;
    //
    if IsSousDetail(TOBL) then
    begin
    	Qte := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifQteAvancSousDet (TOBL,Qte,TypeFacturation,DEV);
      exit;
    end;
    //
    if IsOuvrage (TOBL) and (not IsSousDetail(TOBL)) then
    begin
    	Qte := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifQteAvancOuv (TOBL,Pourcent,TypeFacturation,DEV);
      exit;
    end;
    //
    TOBL.PutValue('BLF_QTESITUATION',Valeur(GS.cells[Acol,Arow]));
    TOBL.PutValue('GL_QTEFACT',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTERESTE',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTESTOCK',TOBL.GetValue('BLF_QTESITUATION'));


    TOBL.PutValue('BLF_QTECUMULEFACT',TOBL.GetValue('BLF_QTEDEJAFACT')+Valeur(GS.cells[Acol,Arow]));
    //
    TOBL.PutValue('BLF_MTSITUATION',Arrondi(TOBL.GetValue('BLF_QTESITUATION')*TOBL.GetValue('GL_PUHTDEV')/TOBL.GEtValue('GL_PRIXPOURQTE'),DEV.decimale));
    TOBL.PutValue('BLF_MTCUMULEFACT',TOBL.GetValue('BLF_MTDEJAFACT')+TOBL.GetValue('BLF_MTSITUATION'));
    //
    if (Pos(TypeFacturation,'DAC;AVA')>0) then // avancement
    begin
      Pourcent := Arrondi(TOBL.GetValue('BLF_MTCUMULEFACT')/TOBL.GetValue('BLF_MTMARCHE')*100,2);
    end else
    begin
      Pourcent := Arrondi(TOBL.GetValue('BLF_MTSITUATION')/TOBL.GetValue('BLF_MTMARCHE')*100,2);
    end;
    TOBL.PutValue('BLF_POURCENTAVANC',Pourcent);

    TOBL.PutValue('QTECHANGE','X');
    TOBL.putValue('GL_RECALCULER','X');
    TOBPiece.putValue('GP_RECALCULER','X');
    AfficheLaLigne (Arow);
  end else
  begin
    ResetCells(Acol,Arow);
  end;
end;

procedure TFFacture.ChangeTempsPose (Acol,Arow : integer);
var TOBL: TOB;
		TOBOUV,TOBOP : TOB;
    IndiceNomen : integer;
    Qte,Tps : double;
    valeurs : T_Valeurs;
    PrestDefaut : string;
begin
	Tps := valeur(GS.Cells[Acol,Arow]);
	TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then BEGIN ResetCells(Acol,Arow) ;exit; END;
  IndiceNomen := TOBL.getValue('GL_INDICENOMEN'); if IndiceNomen = 0 then BEGIN ResetCells(Acol,Arow) ; exit; END;
  TOBOUV := TOBOUvrage.Detail[IndiceNomen-1]; TOBOP := TOBOUV.detail[0]; // la on est sur l'article prix pos�
  if (TOBOP.detail.count  = 1) and (Tps > 0) then
  begin
  	PrestDefaut := GetParamSocSecur ('SO_BTPRESTPRIXPOS','');
  	if PrestDefaut <> '' then
    begin
    	AjoutePrestationPrixPose (TOBPiece,TOBL,TOBOP,TOBArticles,PrestDefaut,DEV);
    end;
  end;
  if TOBOP.detail.count > 1 then
  begin
    TOBL.putValue('GL_QUALIFHEURE',TOBOP.detail[1].getValue('BLO_QUALIFQTEVTE'));
    AffecteTempsPoseOuvrage (TOBArticles,TOBOP,Tps,DEV);
    InitTableau (Valeurs);
    CalculeOuvrageDoc (TOBOP,1,1,true,DEV,valeurs,(TOBPIECE.GetValue('GP_FACTUREHT')='X'));
    GetValoDetail (TOBOP); // pour le cas des Article en prix pos�s
    Qte := TOBL.Getvalue('GL_QTEFACT');
    TOBL.Putvalue('GL_MONTANTPAFG',valeurs[10]*Qte);
    TOBL.Putvalue('GL_MONTANTPAFR',valeurs[11]*Qte);
    TOBL.Putvalue('GL_MONTANTPAFC',valeurs[12]*Qte);
    TOBL.Putvalue('GL_MONTANTFG',valeurs[13]*Qte);
    TOBL.Putvalue('GL_MONTANTFR',valeurs[14]*Qte);
    TOBL.Putvalue('GL_MONTANTFC',valeurs[15]*Qte);
    TOBL.Putvalue('GL_MONTANTPA',Arrondi((Qte * TOBL.GetValue('GL_DPA')),V_PGI.okdecV));
    TOBL.Putvalue('GL_MONTANTPR',Arrondi((Qte * TOBL.GetValue('GL_DPR')),V_PGI.okdecV));

    TOBL.Putvalue('GL_DPA',valeurs[16]);
    TOBL.Putvalue('GL_DPR',valeurs[17]);
    //
    TOBL.Putvalue('GL_PUHTDEV',valeurs[2]);
    TOBL.Putvalue('GL_PUTTCDEV',valeurs[3]);
    TOBL.Putvalue('GL_PUHT',DeviseToPivotEx(TOBL.GetValue('GL_PUHTDEV'),DEV.Taux,DEV.quotite,V_PGI.OkdecP));
    TOBL.Putvalue('GL_PUTTC',DevisetoPivotEx(TOBL.GetValue('GL_PUTTCDEV'),DEV.taux,DEV.quotite,V_PGI.okdecP));
    TOBL.Putvalue('GL_PUHTBASE',TOBL.GetValue('GL_PUHT'));
    TOBL.Putvalue('GL_PUTTCBASE',TOBL.GetValue('GL_PUTTC'));
    TOBL.Putvalue('GL_DPA',valeurs[0]);
    TOBL.Putvalue('GL_DPR',valeurs[1]);
    TOBL.Putvalue('GL_PMAP',valeurs[6]);
    TOBL.Putvalue('GL_PMRP',valeurs[7]);
    TOBL.putvalue('GL_TPSUNITAIRE',valeurs[9]);
    TOBL.PutValue('GL_RECALCULER', 'X');
  	CalculheureTot (TOBL);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end else
  begin
  	ResetCells(Acol,Arow);
  end;
end;


procedure TFFacture.ChangeTempsPoseTOT (Acol,Arow : integer);
var TOBL: TOB;
		TOBOUV,TOBOP : TOB;
    IndiceNomen : integer;
    Qte,TPSUni : double;
    valeurs : T_Valeurs;
    PrestDefaut : string;
begin
	TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then BEGIN ResetCells(Acol,Arow) ;exit; END;
  IndiceNomen := TOBL.getValue('GL_INDICENOMEN'); if IndiceNomen = 0 then BEGIN ResetCells(Acol,Arow) ; exit; END;
  TOBOUV := TOBOUvrage.Detail[IndiceNomen-1]; TOBOP := TOBOUV.detail[0]; // la on est sur l'article prix pos�
  if TOBOP.detail.count  = 1 then
  begin
  	PrestDefaut := GetParamSocSecur ('SO_BTPRESTPRIXPOS','');
  	if PrestDefaut <> '' then
    begin
    	AjoutePrestationPrixPose (TOBPiece,TOBL,TOBOP,TOBArticles,PrestDefaut,DEV);
    end;
  end;
  if TOBOP.detail.count > 1 then
  begin
    Qte := TOBL.Getvalue('GL_QTEFACT');
  	TOBL.putValue('GL_QUALIFHEURE',TOBOP.detail[1].getValue('BLO_QUALIFQTEVTE'));
    TPSUni :=Arrondi(valeur(GS.Cells[Acol,Arow])/Qte,V_PGI.OkdecQ);
  	AffecteTempsPoseOuvrage (TOBArticles,TOBOP,TpsUni,DEV);
    InitTableau (Valeurs);
    CalculeOuvrageDoc (TOBOP,1,1,true,DEV,valeurs,(TOBPIECE.GetValue('GP_FACTUREHT')='X'));
    GetValoDetail (TOBOP); // pour le cas des Article en prix pos�s
    TOBL.Putvalue('GL_MONTANTPAFG',valeurs[10]*Qte);
    TOBL.Putvalue('GL_MONTANTPAFR',valeurs[11]*Qte);
    TOBL.Putvalue('GL_MONTANTPAFC',valeurs[12]*Qte);
    TOBL.Putvalue('GL_MONTANTFG',valeurs[13]*Qte);
    TOBL.Putvalue('GL_MONTANTFR',valeurs[14]*Qte);
    TOBL.Putvalue('GL_MONTANTFC',valeurs[15]*Qte);
    TOBL.Putvalue('GL_MONTANTPA',Arrondi((Qte * TOBL.GetValue('GL_DPA')),V_PGI.okdecV));
    TOBL.Putvalue('GL_MONTANTPR',Arrondi((Qte * TOBL.GetValue('GL_DPR')),V_PGI.okdecV));

    TOBL.Putvalue('GL_DPA',valeurs[16]);
    TOBL.Putvalue('GL_DPR',valeurs[17]);
    //
    TOBL.Putvalue('GL_PUHTDEV',valeurs[2]);
    TOBL.Putvalue('GL_PUTTCDEV',valeurs[3]);
    TOBL.Putvalue('GL_PUHT',DeviseToPivotEx(TOBL.GetValue('GL_PUHTDEV'),DEV.Taux,DEV.quotite,V_PGI.OkdecP));
    TOBL.Putvalue('GL_PUTTC',DevisetoPivotEx(TOBL.GetValue('GL_PUTTCDEV'),DEV.taux,DEV.quotite,V_PGI.okdecP));
    TOBL.Putvalue('GL_PUHTBASE',TOBL.GetValue('GL_PUHT'));
    TOBL.Putvalue('GL_PUTTCBASE',TOBL.GetValue('GL_PUTTC'));
    TOBL.Putvalue('GL_DPA',valeurs[0]);
    TOBL.Putvalue('GL_DPR',valeurs[1]);
    TOBL.Putvalue('GL_PMAP',valeurs[6]);
    TOBL.Putvalue('GL_PMRP',valeurs[7]);
    TOBL.putvalue('GL_TPSUNITAIRE',valeurs[9]);
    TOBL.PutValue('GL_RECALCULER', 'X');
  	CalculheureTot (TOBL);
    TOBPiece.PutValue('GP_RECALCULER', 'X');
    CalculeLaSaisie(-1, -1, True);
  end else
  begin
  	ResetCells(Acol,Arow);
  end;
end;

procedure TFFacture.ChangeMontantSituation(ACol, ARow : integer);
  function ControleMontantSitSaisie (Acol,Arow : integer) : boolean;
  var TOBL : TOB;
  begin
    result := true;
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then exit;
    //
    if TOBL.GetValue('BLF_MTCUMULEFACT')-TOBL.GetValue('BLF_MTSITUATION')+Valeur(GS.cells[Acol,Arow]) > TOBL.getValue('BLF_MTMARCHE') then
    begin
      result := (PgiAsk (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement > � 100 % ?'))=Mryes)
    end
    else if Valeur(GS.cells[Acol,Arow]) < 0 then
    begin
      result := (PgiAsk (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement < � la pr�c�dente facturation % ?'))=Mryes)
    end;
  end;
var TOBL : TOB;
    Mt,Pourcent : double;
begin
  if ControleMontantSitSaisie (Acol,Arow) then
  begin
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then BEGIN ResetCells(Acol,Arow) ;exit; END;

    if IsSousDetail(TOBL) then
    begin
    	Mt := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifMontantAvancSousDet (TOBL,Mt,TypeFacturation,DEV);
      exit;
    end;

    if IsOuvrage (TOBL) and (not IsSousDetail(TOBL)) then
    begin
    	Mt := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifMontantAvancOuv (TOBL,Mt,TypeFacturation,DEV);
      exit;
    end;

    TOBL.PutValue('BLF_MTSITUATION',Valeur(GS.cells[Acol,Arow]));
    TOBL.PutValue('BLF_MTCUMULEFACT',TOBL.GetValue('BLF_MTDEJAFACT')+TOBL.GetValue('BLF_MTSITUATION'));
    if (Pos(TypeFacturation,'DAC;AVA')>0) then // avancement
    begin
      Pourcent := Arrondi(TOBL.GetValue('BLF_MTCUMULEFACT')/TOBL.GetValue('BLF_MTMARCHE')*100,2);
    end else
    begin
      Pourcent := Arrondi(TOBL.GetValue('BLF_MTSITUATION')/TOBL.GetValue('BLF_MTMARCHE')*100,2);
    end;
    //
    TOBL.PutValue('BLF_POURCENTAVANC',pourcent);
    //
    TOBL.PutValue('BLF_QTECUMULEFACT',Arrondi(TOBL.GetValue('BLF_QTEMARCHE')*TOBL.GetValue('BLF_POURCENTAVANC')/100,V_PGI.okdecQ));
    TOBL.PutValue('BLF_QTESITUATION',TOBL.GetValue('BLF_QTECUMULEFACT')-TOBL.GetValue('BLF_QTEDEJAFACT'));
    TOBL.PutValue('GL_QTEFACT',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTERESTE',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTESTOCK',TOBL.GetValue('BLF_QTESITUATION'));
    //
    TOBL.PutValue('QTECHANGE','X');
    TOBL.putValue('GL_RECALCULER','X');
    TOBPiece.putValue('GP_RECALCULER','X');
    AfficheLaLigne (Arow);
  end else
  begin
    ResetCells(Acol,Arow);
  end;
end;


procedure TFFacture.ChangePourcentAvancSituation (Acol,Arow : integer);

  function ControleAvancSaisie (Acol,Arow : integer) : boolean;
  var TOBL : TOB;
      CumuleFact : double;
  begin
    result := true;
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then exit;
    //
    if Valeur(GS.cells[Acol,Arow]) > 100 then
    begin
      result := (PgiAsk (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement > � 100 % ?'))=Mryes)
    end else
    begin
      CumuleFact := Arrondi(TOBL.GetValue('BLF_QTEMARCHE')*Valeur(GS.cells[Acol,Arow])/100,DEV.decimale);
      if CumuleFact < TOBL.GetValue('BLF_QTEDEJAFACT') then
      begin
        result := (PgiAsk (TraduireMemoire('Etes vous sur de vouloir indiquer un avancement < � la pr�c�dente facturation ?'))=Mryes)
      end;
    end;
  end;

var TOBL : TOB;
		Pourcent : double;
begin
  if ControleAvancSaisie (Acol,Arow) then
  begin
    TOBL := GetTOBLigne (TOBPiece,Arow); if TOBL=nil then BEGIN ResetCells(Acol,Arow) ;exit; END;
    if IsOuvrage (TOBL) and (not IsSousDetail(TOBL)) then
    begin
    	Pourcent := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifPourcentAvancOuv (TOBL,Pourcent,TypeFacturation,DEV);
      exit;
    end;
    if IsSousDetail(TOBL) then
    begin
    	Pourcent := Valeur(GS.cells[Acol,Arow]);
      fModifSousDetail.ModifPourcentAvancSousDet (TOBL,Pourcent,TypeFacturation,DEV);
      exit;
    end;
    TOBL.PutValue('BLF_POURCENTAVANC',Valeur(GS.cells[Acol,Arow]));
    //
    TOBL.PutValue('BLF_QTECUMULEFACT',Arrondi(TOBL.GetValue('BLF_QTEMARCHE')*TOBL.GetValue('BLF_POURCENTAVANC')/100,V_PGI.okdecQ));
    TOBL.PutValue('BLF_QTESITUATION',TOBL.GetValue('BLF_QTECUMULEFACT')-TOBL.GetValue('BLF_QTEDEJAFACT'));
    TOBL.PutValue('GL_QTEFACT',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTERESTE',TOBL.GetValue('BLF_QTESITUATION'));
    TOBL.PutValue ('GL_QTESTOCK',TOBL.GetValue('BLF_QTESITUATION'));
    //
    TOBL.PutValue('BLF_MTCUMULEFACT',arrondi(TOBL.GetValue('BLF_MTMARCHE')*TOBL.GetValue('BLF_POURCENTAVANC')/100,DEV.Decimale));
    TOBL.PutValue('BLF_MTSITUATION',TOBL.GetValue('BLF_MTCUMULEFACT')-TOBL.GetValue('BLF_MTDEJAFACT'));
    //
    TOBL.PutValue('QTECHANGE','X');
    TOBL.putValue('GL_RECALCULER','X');
    TOBPiece.putValue('GP_RECALCULER','X');
    AfficheLaLigne (Arow);
  end else
  begin
    ResetCells(Acol,Arow);
  end;
end;

procedure TFFacture.NettoieBudget;

  procedure  TraiteLeNettoyage (TOBE : TOB);
  var Indice : integer;
      TOBD : TOB;
      RefOrigine : string;
  begin
    for Indice := 0 to TOBE.detail.count -1 do
    begin
      RefOrigine := TOBE.detail[Indice].GetValue('PROVENANCE');
      if RefOrigine <> '' then
      begin
        repeat
          TOBD := TheListPiecePrec.FindFirst(['REFERENCE'],[RefOrigine],true);
          if TOBD <> nil then TOBD.Free;
        until TOBD = nil;
      end;
    end;
  end;

var TOBE : TOB;
begin
  TheListPiecePrec.detail.Sort ('TYPE');
  repeat
    TOBE := TheListPiecePrec.FindFirst(['TYPE','NETTOYE'],['BCE','-'],true);
    if TOBE<> nil then
    begin
      TraiteLeNettoyage (TOBE);
      TOBE.PutValue('NETTOYE','X');
    end;
  until TOBE = nil;
end;

procedure TFFacture.DefiniModeCalcul;
begin
  if (not isPieceGerableFraisDetail(NewNature)) or (VenteAchat<>'VEN') then
  begin
    BCalculDocAuto.down := true;
    BCalculDocAuto.visible := false;
    RecalculeDocument.visible := false;
    CalculPieceAutorise := true;
  end;
end;


procedure TFFacture.EnregistreLigneSupprime (TOBL : TOB);
var TOBLD,TOBBL  : TOB;
    TOBBB : TOB;
    NumOrdre : integer;
begin
  NumOrdre := TOBL.getValue('GL_NUMORDRE');
  TOBLigneDel.Dupliquer(TOBpiece,false,true); 
  //
  TOBLD := TOB.Create ('LIGNE',TOBLigneDel,-1);
  TOBLD.Dupliquer (TOBL,false,true);
  //
  TOBBB := FindLignesbases (NumOrdre,TOBBasesL);
  if TOBBB <> nil then
  begin
		ChangeParentLignesBases (TOBLBasesDEL,TOBBB,DEV.Decimale);
  end;
  TOBPiece.PutValue ('GP_RECALCULER','X');
end;

procedure TFFacture.DeduitLesLignesSupprimes;
var TOBL : TOB;
    Indice : integer;
begin
  Indice := 0;
  if TOBLigneDel.detail.count = 0 then exit;
  repeat
    TOBL := TOBLigneDel.detail[Indice];
    DeduitLigneModifie (TOBL,TOBpiece,TOBPieceTrait,TOBOUvrage,TOBOuvragesP,TOBBases,TOBLBasesDEL,TOBTiers,DEV, Action);
    TOBL.free;
  until Indice >= TOBLigneDel.detail.count;
  TOBLBasesDEL.ClearDetail;
end;

function TFFacture.ControleLigneToCut (Row : integer; WithBlaBla : boolean=true) : boolean;
begin
	result := false;
end;

function  TFFacture.Multicompteur (Naturepiece : string) : boolean;
var QQ : TQuery;
begin
  QQ := OpenSql ('select GPC_SOUCHE FROM PARPIECECOMPL WHERE GPC_NATUREPIECEG="'+Naturepiece+'"',true,-1,'',true);
  result := not QQ.eof;
  ferme (QQ);
end;

function TFFacture.IsEcritLesOuvPlat : boolean;
begin
	result := false;
	if (OkCpta) then BEGIN result := true; Exit; END;
  if (isEcritureBOP(TOBpiece)) then result := true;
end;

procedure TFFacture.BintegreExcelClick(Sender: TObject);
var ImportExcel : TimportLigneFacture;
		TOBL : TOB;
begin
  ODExcelFile.Filter := 'fichiers Excel (*xls;*xlsx)|*.xls;*.xlsx';
  if ODExcelFile.execute then
  begin
  	ImportExcel := TimportLigneFacture.create;
    ImportExcel.documentPGI := TForm(TFFacture);
    ImportExcel.documentExcel := ODexcelFile.FileName;
    ImportExcel.LignePGI := GS.row;
		ImportExcel.TOBpiece := TOBpiece;
    ImportExcel.TOBArticles := TOBArticles;
    ImportExcel.TOBTiers := TOBTiers;
    ImportExcel.TOBAffaire := TOBAffaire;
    ImportExcel.TOBOuvrage := TOBOUvrage;
    ImportExcel.TOBOuvrageP :=TOBOuvragesP;
    ImportExcel.TOBBases  :=TOBBases;
    ImportExcel.TOBBasesL  := TOBBasesL;
    ImportExcel.TOBporcs  := TOBPorcs;
    ImportExcel.TOBpieceRG  := TOBPIECERG;
    ImportExcel.TOBbasesRG  := TOBBASESRG;
    ImportExcel.TOBConds := TOBConds;
    ImportExcel.DEV := DEV;
    TRY
    	ImportExcel.execute;
      DefiniRowCount ( self,TOBPiece);
    	NumeroteLignesGC(nil,TOBpiece, False, true);
      TOBpiece.PutValue('GP_RECALCULER','X');
      CalculeLaSaisie(-1, -1, True);
      TOBL := GetTOBLigne(TOBPiece, GS.row);
      if Assigned(Tobl) and ( (TOBL.GetValue('GL_TYPEPRESENT') <> DOU_AUCUN) or (TOBL.GetValue('GLC_VOIRDETAIL')='X')) Then
      begin
        GestionDetailOuvrage(self,TobPiece,GS.row,GS.col);
      end;
    //   TheDestinationLiv.SetDestLivrDefaut (TOBL);
      MontreInfosLigne(TOBL, nil, nil, nil, INFOSLIGNE, PPInfosLigne);
      GereEnabled(GS.row);
      NeRestePasSurDim(GS.Row);
      StCellCur := GS.Cells[GS.col, GS.row];
    FINALLY
    	ImportExcel.free;
    END;
  end;
end;

function TFFacture.isEcritureBOP (TOBPiece : TOB) : boolean;
var TheCondition : string;
		theZone, TheValeur : string;
begin
	result := false;
  if TOBPiece.getvalue('GP_NATUREPIECEG')<>'DBT' then exit;
  TheCondition := GetparamSoc('SO_BTCONDECRITBOPDEV');
  if TheCondition = '' then exit;
  TheZone := READTOKENPipe (TheCondition,'=');
  Thevaleur := TheCondition;
  if TOBPiece.getValue(TheZone)=TheValeur then result := true;
end;

procedure TFFacture.MnVisaPieceClick(Sender: TObject);
var MessText : string;
begin
	if TOBPiece.getValue('GP_ETATVISA')='ATT' then
  begin
    Messtext := 'Attention : Vous allez viser cette pi�ce. Elle ne sera accessible qu''en consultation.#13#10'+
               'Confirmez-vous ?';
  end else
  begin
    Messtext := 'Attention : Vous allez enlever le visa sur cette pi�ce.#13#10'+
               'Confirmez-vous ?';
  end;


	if PGIAsk (MEssText)=Mryes then
  begin
  	if TOBPiece.getValue('GP_ETATVISA')='ATT' then TOBpiece.putValue('GP_ETATVISA','VIS')
    																					else TOBpiece.putValue('GP_ETATVISA','ATT');
  end;
end;

procedure TFFacture.CalculheureTot (TOBL : TOB);
begin
	TOBL.putvalue('GL_HEURE',Arrondi(TOBL.getValue('GL_TPSUNITAIRE')*TOBL.GetValue('GL_QTEFACT'),V_PGI.okdecQ));
end;


function TFFacture.PositionneRecalculePourcent (Arow : Integer) : integer;
var Ind,IndTypeArt : integer;
begin
	result := -1;
	if Arow < 1 then exit;
	for ind := Arow to TOBpiece.detail.count -1 do
  begin
  	if IsDebutParagraphe (TOBPiece.detail[Ind]) then exit;
  	if IsFinParagraphe (TOBPiece.detail[Ind]) then exit;
    if Ind=Arow then IndTypeArt := TOBPiece.detail[Ind].GetNumChamp('GL_TYPEARTICLE');
  	if TOBPiece.detail[Ind].getValeur(IndTypeArt)='POU' then
    begin
			TOBPiece.detail[Ind].putValue('GL_RECALCULER','X');
      result := Ind;
    end;
  end;
end;

procedure TFFACTURE.TestprovenanceMultiDev(TOBpiece : TOB);
var Indice : integer;
		TOBL : TOB;
    Cledoc : r_cledoc;
    Lastprec , CurrPiece : string;
begin
	LastPrec := '';
  CurrPiece := '';
  if TOBPiece.getValue('GP_NATUREPIECEG')<>'FBT' then exit;
  if TOBPiece.getValue('GP_RGMULTIPLE')='' then
  begin
  	TOBPiece.putValue('GP_RGMULTIPLE','-');
    for Indice := 0 to TOBPiece.detail.count -1 do
    begin
      TOBL := TOBPiece.detail[Indice];
      if TOBL.getValue('GL_PIECEPRECEDENTE')<>'' then
      begin
        DecodeRefPiece(TOBL.getValue('GL_PIECEPRECEDENTE'),Cledoc);
        CurrPiece := Cledoc.NaturePiece+';'+cledoc.Souche +';'+IntToStr(Cledoc.NumeroPiece)+';'+IntToStr(Cledoc.Indice);
        if lastPrec = '' then
        begin
          lastprec := CurrPiece;
        end else if lastPrec <> CurrPiece then
        begin
          TOBPiece.putValue('GP_RGMULTIPLE','X');
          break;
        end;
      end;
    end;
  end;
end;

procedure TFFACTURE.RecupCoefMargArticle (TOBL,TOBarticles : TOB);
var TOBA : TOB;
begin
	TOBA := TOBArticles.findFirst(['GA_ARTICLE'],[TOBL.getValue('GL_ARTICLE')],true);
  if TOBA <> nil then
  begin
  	TOBL.PutValue('GL_COEFMARG',TOBA.getValue('GA_COEFCALCHT'));
  end;
end;

procedure TFFACTURE.MajAppel (TOBpiece : TOB);
var Sql : string;
	NbOk : integer;
begin
(*
  TobAppel.PutValue('AFF_TOTALHT', QQ.FindField('GP_TOTALHT').AsString );
  TobAppel.PutValue('AFF_TOTALHTDEV', QQ.FindField('GP_TOTALHTDEV').AsString );
  TobAppel.PutValue('AFF_TOTALTTC', QQ.FindField('GP_TOTALTTC').AsString );
  TobAppel.PutValue('AFF_TOTALTTCDEV', QQ.FindField('GP_TOTALTTCDEV').AsString );
*)
	Sql := 'UPDATE AFFAIRE SET AFF_TOTALHT='+STRFPOINT (TOBpiece.getValue('GP_TOTALHT'))+
  			 ',AFF_TOTALHTDEV='+STRFPOINT(TOBpiece.getVAlue('GP_TOTALHTDEV'))+
         ',AFF_TOTALTTC='+STRFPOINT(TOBpiece.getVAlue('GP_TOTALTTC'))+
         ',AFF_TOTALTTCDEV='+STRFPOINT(TOBpiece.getVAlue('GP_TOTALTTCDEV'))+
         ',AFF_ETATAFFAIRE="ACD" '+
         'WHERE AFF_AFFAIRE="'+TOBpiece.getValue('GP_AFFAIRE')+'"';
  NBOk := ExecuteSQL(Sql);
end;


procedure TFFacture.GSMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var Acol,Arow : integer;
begin
 //
 (*
  GS.MouseToCell(X,Y,Acol,Arow);
  if (Acol = SG_NATURETRAVAIL) then
  begin
  	GS.showHint := true;
  	Application.CancelHint;
  	GS.Hint := GetLibCoTraitant (TOBpiece,Arow);
  end else
  begin
  	GS.showHint := false;
  	GS.hint := '';
  end;
  *)
end;

procedure TFFacture.SetLargeurColonnes;
var  InfosNbLig : integer;
begin
	if SG_NL <> -1 then
  begin
    InfosNbLig := getInfoPuissance (TOBPiece.detail.count);
    if InfosNbLig < 3 then InfosNbLig := 3 else  InfosNbLig := InfosNbLig +1;
    GS.ColLengths[SG_NL] := ((InfosNbLig)*(GS.canvas.textWidth('9')));
    GS.ColWidths  [SG_NL] := ((InfosNbLig)*(GS.canvas.textWidth('9')));
  end;
  if SG_TYPA <> -1 then
  begin
    GS.Colwidths[SG_TYPA] := 36;
    GS.ColLengths[SG_TYPA] := 36;
  end;
  if (SG_NATURETRAVAIL <> -1) and (GS.Colwidths[SG_NATURETRAVAIL]>0) then
  begin
    GS.Colwidths[SG_NATURETRAVAIL] := 20;
    GS.ColLengths[SG_NATURETRAVAIL] := 20;
  end;
  if (SG_VOIRDETAIL <> -1) then
  begin
  	if ModifSousDetail then
    begin
      GS.Colwidths[SG_VOIRDETAIL] := 25;
      GS.ColLengths [SG_VOIRDETAIL] := 25;
    end else
    begin
      GS.Colwidths[SG_VOIRDETAIL] := -1;
    end;
  end;
end;

function TFFacture.Dessus(Arow : integer) : TOB;
begin
	if Arow = 1 then
  begin
  	result := nil;
    exit;
  end;
  result := GetTOBLigne(TOBpiece,GS.row-1);
end;

function TFFacture.Dessous(Arow : integer) : TOB;
begin
	if Arow = TobPiece.detail.count+1 then
  begin
  	result := nil;
    exit;
  end;
  result := GetTOBLigne(TOBpiece,GS.row+1);
end;

function TFFacture.courante (Arow : integer) : TOB;
begin
  result := GetTOBLigne(TOBpiece,GS.row);
end;

procedure TFFacture.BOuvrirFermerClick(Sender: TObject);
var TOBL: TOB;
  bc: boolean;
begin
  TOBL := GetTOBLigne(TOBPiece, GS.Row); // r�cup�ration TOB ligne
  if TOBL = nil then exit;
  if IsLigneFromBordereau(TOBL) then exit;
//  if BTypeArticle.Visible then BTypeArticle.Visible := false;
	BouttonInVisible;
  if TOBL.getValue('GL_TYPEARTICLE') = 'OUV' then
  begin
    GS.SynEnabled := false;
    SuppressionDetailOuvrage(GS.Row);
    if TOBL.getValue('GLC_VOIRDETAIL') = 'X' then TOBL.PutValue('GLC_VOIRDETAIL', '-')
    																				 else TOBL.PUtvalue('GLC_VOIRDETAIL', 'X');
    AffichageDetailOuvrage(GS.Row);
    GS.Invalidate;
    GS.SynEnabled := true;
  end;
  bc := false;
  GSRowEnter(GS, GS.Row, bc, False);
  BouttonVisible(GS.row);
end;

procedure TFFacture.DemandeModeInsert;
var Arect : TRect;
    PointD,PointF : Tpoint;
begin
  ARect := GS.CellRect(GS.Col, GS.Row);
  PointD := GS.ClientToScreen ( Arect.Topleft)  ;
  PointF := GS.ClientToScreen ( Arect.BottomRight )  ;
  PopInsertLig.Popup(pointF.X ,pointD.y+10);
end;

procedure TFFacture.MnInsSousDetClick(Sender: TObject);
begin
	ClickInsert(GS.Row,True,TmiUp);
end;

procedure TFFacture.MnInsLigStdClick(Sender: TObject);
begin
	ClickInsert(GS.Row);
end;

procedure TFFacture.ReinitPieceForCalc;
var ind : Integer;
begin
  ZeroFacture (TOBpiece);
  ZeroMontantPorts (TOBPorcs);
  for Ind := 0 to TOBPiece.detail.count -1 do ZeroLigneMontant (TOBPiece.detail[Ind]);
  TOBpieceTrait.clearDetail;
  PutValueDetail (TOBpiece,'GP_RECALCULER','X');
  TOBBases.ClearDetail;
  TOBBasesL.ClearDetail;
  GereCalculPieceBTP;
end;

initialization
  InitFacGescom();
end.




