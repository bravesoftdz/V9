unit ULIBECRITURE;

interface

Uses
  {$IFNDEF EAGLCLIENT}
   db,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  {$IFDEF EAGLSERVER}
  eSession,
  uWa,
  ULibCpContexte ,
  {$ENDIF}
  {$IFDEF VER150}
  variants,
 {$ENDIF}
  UTOB,
  Classes,
  HEnt1 ,
  SaisComm,
  HCompte,
  ZCompte,   // pour le ZCompte
  SAISUTIL,  // pour le tDC  RDEVISE SAISUTIL
  CBPPath,
  {$IFNDEF EAGLSERVER}
  controls,
  {$IFNDEF ERADIO}
  {$IFNDEF EAGLCLIENT}
  fe_main,
  {$ELSE}
  MainEagl,
  {$ENDIF}
  {$ENDIF !ERADIO}
  {$ENDIF}
  hctrls,   // pour OpenSql
  Windows ,
  ULibExercice
  , Ent1      // pour le VH
  {$IFDEF MODENT1}
  , CPTypeCons
  {$ENDIF MODENT1}
,uEntCommun
  ; // pour le TZExercice


const RC_PASERREUR              =  -1 ;
      RC_SELCOMPTE              =  0 ;
      RC_SELTIERS               =  1 ;
      RC_BADNUMFOLIO            =  2 ;
      RC_JALNONSOLDE            =  3 ;
      RC_SELNATURE              =  4 ;
      RC_BADWRITE               =  5 ;
      RC_CINTERDIT              =  6 ;
      RC_BADGUIDE               =  7 ;
      RC_RESTOREFOLIO           =  8 ;
      RC_LIBREBLACKOUT          =  9 ;
      RC_AUXATTEND              = 10 ;
      RC_ECRLETTREE             = 11 ;
      RC_THEBADGUY              = 12 ;
      RC_FOLIOLOCK              = 13 ;
      RC_EURO                   = 14 ;
      RC_MODEBOR                = 15 ;
      RC_MODELIB                = 16 ;
      RC_BORCLOTURE             = 17 ;
      RC_BADDATEEURO            = 18 ;
      RC_CNATURE                = 19 ;
      RC_ABANDON                = 20 ;
      RC_NOJALAUTORISE          = 21 ;
      RC_CFERMESOLDE            = 22 ;
      RC_COUVREBIL              = 23 ;
      RC_NONEGATIF              = 24 ;
      RC_NOGRPMONTANT           = 25 ;
      RC_SAISIEECR              = 26 ;
      RC_CFERME                 = 27 ;
      RC_AUXFERME               = 28 ;
      RC_BADROW                 = 29 ;
      RC_RIB                    = 30 ;
      RC_JALNONSOLDEEXIT        = 31 ;
      RC_TRESO                  = 32 ;
      RC_TRESO2                 = 33 ;
      RC_CNATURE2               = 34 ;
      RC_NEWIMMO                = 35 ;
      RC_CONCEPTVISU            = 36 ;
      RC_BADGUYJAL              = 37 ;
      RC_LETTRAGE               = 38 ;
      RC_TMONODEVISE            = 39 ;
      RC_GUIDESTOP              = 40 ;
      RC_NOEXISTIMMO            = 41 ;
      RC_VALIDAGAIN             = 42 ;
      RC_BORREVISION            = 43 ;
      RC_ECRPOINTEE             = 45 ;
      RC_ECRIMMO                = 46 ;
      RC_ECRTVAENC              = 47 ;
      RC_MAJSOLDE               = 48 ;
      RC_PASTOUCHEMODELIBRE     = 49 ;
      RC_PARAMAUX               = 50 ;
      RC_COMPTEECART            = 51 ;
      RC_PASCOLLECTIF           = 52 ;
      RC_AUXINEXISTANT          = 53 ;
      RC_JALINEXISTANT          = 54 ;
      RC_JALNONMULTIDEVISE      = 55 ;
      RC_DATEINCORRECTE         = 56 ;
      RC_ECRANOUVEAU            = 57 ;
      RC_MODESAISIE             = 58 ;
      RC_NUMPERIODE             = 59 ;
      RC_COMPTEINEXISTANT       = 60 ;
      RC_AUXOBLIG               = 61 ;
      RC_NATAUX                 = 62 ;
      RC_DEVISE                 = 63 ;
      RC_ECRECART               = 64 ;
      RC_NATINEXISTANT          = 65 ;
      RC_ETABLISSINEXISTANT     = 66 ;
      RC_NATUREJAL              = 67 ;
      RC_ERREURINFOLETT         = 68 ;
      RC_MODEPAIEINCORRECT      = 69 ;
      RC_DATEVALEURINCORRECT    = 70 ;
      RC_REGIMETVAINCORRECT     = 71 ;
      RC_TAUXDEVINCORRECT       = 72 ;
      RC_ABANDONINTERDIT        = 73 ;
      RC_JALFERME               = 74 ;
      RC_NONSOLDER              = 75 ;
      RC_MONTANTINEXISTANT      = 76 ;
      RC_CHAMPSOBLIGATOIRE      = 77 ;
      RC_NUMPIECEOBLIG          = 78 ;
      RC_NUMLIGNEOBLIG          = 79 ;
      RC_JALVALID               = 80 ;
      RC_ERREURINFOPOINTAGE     = 81 ;
      RC_COMPTECONFIDENT        = 82 ;
      RC_BORCONF                = 83 ;
      RC_CONTREINCORRECT        = 84 ;
      RC_PERIODECLOSE           = 85 ;
      RC_COMPTEVISA             = 86 ;
      RC_GCTTC                  = 87 ;
      RC_QUALIFPIECEMS          = 88 ;
      RC_NATUREERR              = 89 ;
      // Code 90 � ne pas utiliser ( saisie bordereau )
      RC_YSECTIONINEXIST        = 91 ;
      RC_YSECTIONOBLIG          = 92 ;
      RC_YSECTIONFERMEE         = 93 ;
      RC_YSECTIONRESTRICTION    = 94 ;
      RC_YAXESECTION            = 95 ;
      RC_YSOLDEPOURC            = 96 ;
      RC_YSOLDEMONTANT          = 97 ;
      RC_YSOLDEMONTANTDEV       = 98 ;
      RC_YSOLDEQTE1             = 99 ;
      RC_YSOLDEQTE2             = 100 ;
      RC_YPOURCINEXISTANT       = 101 ;
      RC_YMONTANTINEXISTANT     = 102 ;
      RC_YAXEVIDE               = 103 ;
      RC_YSECTIONBUDGET         = 104 ;
      //
      RC_MODEENCAISSEMENT       = 105 ;
      RC_YSECTIONINCONNUE       = 106 ;
      RC_DEVISEENLIBRE          = 107 ;
      RC_DATEECHEINCORRECTE     = 108 ;
      RC_ETABLISSEMENT          = 109 ;
      RC_MODEREGLE              = 110 ;
      RC_PASTOUCHEDATE          = 111 ;
      RC_EXOINTERDIT            = 112 ;
      RC_PIECEMODIF             = 113 ;
      RC_ERREURSUPP             = 114 ;

      RC_CODEFOU                = 'F' ;
      RC_CODEFOUN               = '0' ;
      RC_CODECLIN               = '9' ;
      RC_CODECLI                = 'C' ;
      RC_CODESAL                = 'S' ;
      RC_CODEDIV                = 'D' ;
      RC_CODEGEN                = '*' ;


      {$IFNDEF EAGLSERVER}
       KEY_LOOKUP                = VK_F5  ;
       KEY_MENUPOP               = VK_F11 ;
       //KEY_AUTONEXT              = VK_F4 ;
       //KEY_AUTOPREV              = VK_F3 ;
      {$ENDIF}

 const
  cStDateInfDateDebExo                  = 'La date saisie ne peut �tre inf�rieure � la date de d�but de l''exercice N';  // FB 14331
  cStDateInfDateFinExo                  = 'La date saisie ne peut �tre sup�rieure � la date de fin de l''exercice N+1';
  cStDateHorsExo                        = 'La date saisie n''est pas valide';

type

 TInfoEcriture = class ;

 RecCalcul = record
  D, C, DD, CD : Double;
  Index : integer;
 end;

TTypeRechGen = ( RechTous , RechGen , RechAux , ControlGen, ControlAux ) ;

 // Permet d'identifier le contexte de message a utiliser par TMessageCompta, liste non exhaustive...
 TTypeMessage = ( msgSaisieBor, msgSaisiePiece, msgSaisieLibre, msgSaisieAnal ) ;

 TRecError = record
   RC_Error    : integer;
   RC_Message  : string;
   RC_Methode  : string ;
   RC_Valeur   : string ;
   RC_Axe      : integer ;  // utilis� uniquement dans le cadre de l'analytique
 end;


 // classe contenant les info utile � la saisie d'ecriture simplifie
 // unite UTOFECRLET
 TAGLLanceFiche_TOFECRLET = Class
  TOBEcr     : TOB ; // TOB contenant les ecritures d'origines
  TOBResult  : TOB ; // TOB contenant les ecritures generes
  Info       : TObject; // lG -015/07/2002 obj de type TInfoEcriture mais on utilise un TObject pour ne pas inclure l'unite ULibEcriture
 end;

 TErrorProc = procedure (sender : TObject; Error : TRecError ) of object;

 TMessageCompta = Class
  private
   FStTitre      : string ;
   FListeMessage : HTStringList ;
  public
   constructor Create ( vStTitre : string; vTypeMsg : TTypeMessage = msgSaisieBor ) ;
   destructor  Destroy ; override ;
   function    Execute( RC_Numero : integer ) : integer ;
   function    GetMessage ( RC_Numero : integer ) : string ;
 end;

 TZList = Class(TObject)
  private
   function    GetCount : Integer ;
   function    GetTOB : TOB ;
   function    GetTOBByIndex(Index : integer) : TOB ;
  protected
   FTOB        : TOB ;
   FInIndex    : integer ;
   FStTable    : string ;
   FDossier    : string ;
   function    MakeTOB ( vBoEnBase : boolean = false ) : TOB ; virtual ;
   procedure   Initialize ; virtual ; abstract ;
   procedure   SetCrit(vTOB : TOB; const Values : array of string) ; virtual ;
  public
   constructor Create( vDossier : string = '') ; virtual ;
   destructor  Destroy ; override ;
   function    GetValue(Name : string ; Index : integer=-1) : Variant;
   function    GetString(Name : string ; Index : integer=-1) : string;
   procedure   PutValue(Name : string ; Value : Variant) ;
   procedure   PutValueByIndex(Name : string ; Value : Variant ; Index : integer) ;
   function    Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer ; virtual ;
   procedure   Clear ; virtual ;

   property    Count   : Integer read GetCount ;
   property    InIndex : integer read FInIndex ;
   property    Item    : TOB read GetTOB ;
   property    Items   : TOB read FTOB ;

 end;


 TZDevise = Class(TZList)
  private
   function    GetRecDevise : RDevise ;
  protected
   function    MakeTOB ( vBoEnBase : boolean = false ) : TOB ; override ;
   procedure   Initialize ; override ;
   public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer ; override ;
   procedure   AffecteTaux ( vDtDateComptable : TDateTime ; vBoEnBase : boolean = false ) ;

   // nouvelle gestion des taux
   function    GetTauxReel     ( vDtDateComptable : TDateTime ; var vDtDateTaux : TDateTime ; vBoEnBase : boolean = false ) : Double ;
   function    GetTobTaux      ( vDtDateComptable : TDateTime ; vBoExact : boolean = false ) : Tob ;
   procedure   SetTauxVolatil  ( vDtDateComptable : TDateTime ; vDev : RDevise ) ;
   function    EstTauxVolatil  ( vDtDateComptable : TDateTime ) : boolean ;
   function    LoadTaux        ( vDtDateComptable : TDateTime ; var vTobResult : Tob ) : boolean ;

   property    Dev          : RDevise read GetRecDevise ;

  end ;

 TZScenario = Class(TZList)
  protected
   FListe  : HTStringList ; // liste des codes inexistant
   FMemo   : HTStringList ;
   function    GetMemo : HTStringList ;
   procedure   Initialize ; override ;
  public
   constructor Create( vDossier : String = '' ) ; override ;
   destructor  Destroy ; override ;
   function    Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer ; override ;
   procedure   Clear ; override ;

   property    Memo : HTStringList read GetMemo ;

 end;

  TZListJournal = Class(TZList)
  private
   function    GetNatureParDefaut : string ;
  protected
   procedure   Initialize ; override ;
   function    MakeTOB ( vBoEnBase : boolean = false ) : TOB ; override ;
   function    GetNombreDeCompteAuto : integer ;
   function    GetCompteAuto : string ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ; override ; // charge un journal soit depuis la base ou la tob FTOBJournal et positionne FTOBLigneJournal
   function    GetNumJal(vDtDateComptable : TDateTime) : integer; // retourne le prochain numero de journal
   function    GetTabletteNature : string; // retourne le nom de la tablette des natures de piece en fonction de la nature du journal
   function    isJalBqe : boolean ;
   property    NatureParDefaut : string read GetNatureParDefaut ;
   property    NombreDeCompteAuto : integer read GetNombreDeCompteAuto ;
   property    CompteAuto : string read GetCompteAuto ;
//   property    CompteAuto : string read GetCompteAuto ;
  end ;

  TZTier = Class(TZList)
  private
   FBoCodeOnly     : boolean ;
   FBoLibelleOnly  : boolean ;
   FBoBourrageCode : Boolean ;
  protected
   procedure   Initialize ; override ;
   function    MakeTOB ( vBoEnBase : boolean = false ) : TOB; override ;
   function    LoadFromList(const Values : array of string) : integer;

  public
   procedure   RAZSolde ;
   function    Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer ; reintroduce ;
   function    GetCompte(var NumCompte : string ; vBoEnBase : boolean = false ) : integer ;
   procedure   Solde(var D, C: double ; vTypeExo : TTypeExo );

   // Chargement sans SQL
   function    GetCompteOpti(var NumCompte : string ; vTobSource : tob ) : Integer ;

   property    BoCodeOnly     : boolean  read FBoCodeOnly      write FBoCodeOnly ;
   property    BoLibelleOnly  : boolean  read FBoLibelleOnly   write FBoLibelleOnly ;
   property    BoBourrageCode : boolean  read FBoBourrageCode  write FBoBourrageCode ;
  end ;

 TZEtabliss = Class(TZList)
  protected
   procedure   Initialize ; override ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ; override ; // charge un journal soit depuis la base ou la tob FTOBJournal et positionne FTOBLigneJournal
   procedure   LoadAll ;
  end ;

  TZNature = Class(TZList)
  protected
   procedure   Initialize ; override ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer ; override ; // charge un journal soit depuis la base ou la tob FTOBJournal et positionne FTOBLigneJournal
   procedure   LoadAll ;
   procedure   MakeTag( vStNatureJal : string ) ;
   function    NextNature : string ;
  end ;

  TZSections = Class(TZList)
  private
   function    GetStAxe :  string ;
   function    GetNumAxe : integer ;
  protected
   procedure   Initialize ; override ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ; reintroduce ;
   function    GetCompte( var NumCompte : string ; NumAxe : string ; vBoEnBase : boolean = false ) : integer ; // Ok

   property    StAxe : string    read GetStAxe ;
   property    NumAxe : integer  read GetNumAxe ;

  end ;

 // Gestion des modes de r�glements et de paiement dans le TInfoEcriture (SBO 22/01/2007)
 TZModeReglement = Class(TZList)
  protected
   procedure   Initialize ; override ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ; override ;
   procedure   LoadAll ;

   function    CalculModeFinal( vMontantEcr : Double ; vStModeInit : string ) : tob ;
   function    GetDateDepart( vTobEcr : Tob; vStMR : string = ''): TDateTime;

  end ;

 TZModePaiement = Class(TZList)
  protected
   procedure   Initialize ; override ;
  public
   function    Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ; override ;
   procedure   LoadAll ;

  end ;


 TTErreurIgnoree = array of integer ;

 TInfoEcriture = Class
  private
   FCompte           : TZCompte ;
   FAux              : TZTier ;
   FJournal          : TZListJournal ;
   FDevise           : TZDevise ;
   FEtabliss         : TZEtabliss ;
   FOnError          : TErrorProc ;
   FLastError        : TRecError ;
   FTypeExo          : TTypeExo ;
   FErreurIgnoree    : TTErreurIgnoree ;
   FDossier          : string ;

   FSection          : TZSections ;
   FModeRegle        : TZModeReglement ;
   FModePaie         : TZModePaiement ;

   procedure   NotifyError( RC_Error : integer ; RC_Message : string ) ;
   procedure   SetOnError( Value : TErrorProc ) ;
   function    GetDevise    : TZDevise ;
   function    GetEtabliss  : TZEtabliss ;
   function    GetJournal   : string ;
   function    GetCompte    : string ;
   function    GetAux       : string ;
   function    GetExercice  : TZExercice ;
   function    GetSection   : string ;

   function    GetModeRegle : TZModeReglement ;
   function    GetModePaie  : TZModePaiement ;
  public

   constructor Create( vDossier : string = '' ) ;
   destructor  Destroy ; override ;

   procedure   Initialize ; virtual ;

   procedure   Load( vStCompte , vStAux , vStJournal : string ; vBoEnBase : boolean = false) ;
   function    LoadCompte ( vStCompte : string ; vBoEnBase : boolean = false) : boolean ;
   function    LoadAux ( vStAux : string ; vBoEnBase : boolean = false ) : boolean ;
   function    LoadJournal ( vStJournal : string ; vBoEnBase : boolean = false) : boolean ;
   function    Compte_GetValue( vStNom : string ) : variant ;
   function    Aux_GetValue( vStNom : string ) : variant ;
   function    GetValue( vStNom : string ; vIndex : integer = - 1 ) : variant ;
   function    GetString( vStNom : string ; vIndex : integer = - 1 ) : string ;
   procedure   AjouteErrIgnoree( Value : array of Integer ) ;
   function    LoadSection ( vStSection, vStAxe : string ; vBoEnBase : boolean = false) : boolean ;
   procedure   ClearSection;
   function    Section_GetValue( vStNom : string ) : variant ;

   function    LoadModeRegle ( vStCode : string ; vBoEnBase : boolean = false) : boolean ;
   function    LoadModePaie  ( vStCode : string ; vBoEnBase : boolean = false) : boolean ;

   procedure   LoadOpti( vStCompte , vStAux : string ; vTobSource : Tob ) ;

   property    StCompte          : string           read GetCompte ;
   property    StAux             : string           read GetAux ;
   property    StJournal         : string           read GetJournal ;
   property    StSection         : string           read GetSection ;
   property    Compte            : TZCompte         read FCompte ;
   property    Aux               : TZTier           read FAux ;
   property    Journal           : TZListJournal    read FJournal ;
   property    Section           : TZSections       read FSection ;
   property    Etabliss          : TZEtabliss       read GetEtabliss ;
   property    Devise            : TZDevise         read GetDevise ;
   property    Exercice          : TZExercice       read GetExercice ;

   property    ModeRegle         : TZModeReglement  read GetModeRegle ;
   property    ModePaie          : TZModePaiement   read GetModePaie ;

   property    TypeExo           : TTypeExo         read FTypeExo         write FTypeExo ;
   property    OnError           : TErrorProc       read FOnError         write SetOnError;
   property    ErreurIgnoree     : TTErreurIgnoree  read FErreurIgnoree   ; //write FErreurIgnoree;
   property    Dossier           : string           read FDossier ;

 end;


 TOBCompta = Class(TOB)
  private
   PInfo      : TInfoEcriture ;
   FLastError : TRecError ;
   FOnError   : TErrorProc ;
  protected
   procedure SetOnError( Value : TErrorProc ) ; virtual ;
   procedure NotifyError( RC_Error : integer ; RC_Message : string ; RC_Methode : string = '' ) ;
   procedure SetInfo ( Value : TInfoEcriture ) ; virtual ;
  public

   procedure Initialize ; virtual ;

   property  OnError   : TErrorProc             read FOnError write SetOnError ;
   property  Info      : TInfoEcriture          read PInfo  write SetInfo ;
   property  LastError : TRecError              read FLastError ;
 end;


 TTOBEcriture = Class(TOBCompta)
 protected
  procedure CheckInfo ;
 public
  procedure SupprimerInfoLettrage ;
  procedure RemplirInfoLettrage ;
  procedure PutDefautEcr ;
  procedure RemplirInfoPointage ;
  procedure CompleteInfo ;
  function  IsValidEtabliss : boolean ; virtual ;
  function  IsValidCompte : boolean ; virtual ;
  function  IsValidAux : boolean ; virtual ;
  function  IsValidNat : boolean ; virtual ;
  function  IsValidDateComptable : boolean ; virtual ;
  function  IsValidJournal : boolean ; virtual ;
  function  IsValidPeriodeSemaine : boolean ; virtual ;
  function  IsValidEcrANouveau : boolean ; virtual ;
  function  IsValidModeSaisie : boolean ; virtual ;
  function  IsValidDebit : boolean ; virtual ;
  function  IsValidCredit : boolean ; virtual ;
  function  IsValidMontant( vRdMontant : double ) : boolean; virtual ;
  function  IsValidDebitCredit: boolean; virtual ;
  function  IsValid  : TRecError ;
 end;


 TObjetCompta = Class(TObject)
  private
   FInfo      : TInfoEcriture ;
   FLastError : TRecError ;
   FOnError   : TErrorProc ;
  protected
   procedure SetOnError( Value : TErrorProc ) ; virtual ;
   procedure NotifyError( RC_Error : integer ; RC_Message : string  ; RC_Methode : string = '' ) ; overload ; virtual ;
   procedure NotifyError( RC_Message, RC_MessageDelphi, RC_Methode : string ) ; overload ; virtual ;
   procedure SetInfo ( Value : TInfoEcriture ) ; virtual ;
  public
   constructor Create( vInfoEcr : TInfoEcriture ) ; virtual ;
   procedure Initialize ; virtual ;

   property  OnError  : TErrorProc             read FOnError write SetOnError ;
   property  Info     : TInfoEcriture          read FInfo    write SetInfo ;
 end;

 {$IFNDEF EAGLSERVER}
 {$IFNDEF ERADIO}
 TRechercheGrille = Class(TObjetCompta)
  private
   PEcr              : TOB ;
   FTypeRech         : TTypeRechGen ;
   FStCarLookUp      : string ;
   FFocusControl     : TTypeRechGen ;
   FInKey            : Word ;
   FShift            : TShiftState ;
   FCOL_GEN          : integer ;
   FCOL_AUX          : integer ;
   FRow              : integer ;
   FCol              : integer ;
   FGrille           : THGrid ;
   FOnChangeGeneral  : TNotifyEvent ;
   FOnChangeAux      : TNotifyEvent ;
  protected
   procedure LookUpGen (Sender: TObject; var ACol,ARow: integer; var Cancel: boolean) ;
   procedure LookUpAux (Sender: TObject; var ACol,ARow: integer; var Cancel: boolean) ;
//   procedure QuelRecherche ;
   procedure NotifyGeneral ;
   procedure NotifyAux ;
  public
   constructor Create( vInfo : TInfoEcriture ) ; 
   procedure   CellExitGen( Sender : TObject; var ACol,ARow : integer; var Cancel : boolean ) ;
   procedure   CellExitAux( Sender : TObject; var ACol,ARow : integer; var Cancel : boolean ) ;
   function    ElipsisClick( Sender : TObject ; vBoAvecDeplacement : boolean = true ) : boolean;

   property COL_GEN         : integer         read FCOL_GEN          write FCOL_GEN ;
   property COL_AUX         : integer         read FCOL_AUX          write FCOL_AUX ;
   property Row             : integer         read FRow              write FRow ;
   property Col             : integer         read FCol              write FCol ;
   property Grille          : THGrid          read FGrille           write FGrille ;
   property TypeRech        : TTypeRechGen    read FTypeRech         write FTypeRech ;
   property FocusControl    : TTypeRechGen    read FFocusControl     write FFocusControl ;
   property InKey           : Word            read FInKey            write FInKey ;
   property Shift           : TShiftState     read FShift            write FShift ;
   property Ecr             : TOB             read PEcr              write PEcr ;
   property OnChangeGeneral : TNotifyEvent    read FOnChangeGeneral  write FOnChangeGeneral ;
   property OnChangeAux     : TNotifyEvent    read FOnChangeAux      write FOnChangeAux ;

 end ;

{$ENDIF !ERADIO}
{$ENDIF}

function  CCalculProchainNumeroSouche ( const vStTypeSouche, vStCodeSouche : string ) : Integer ;
function  CCalculClefUniqueInteger ( const StTableName, StFieldName, StCloseWhere : string ) : Integer ;
function  CMAJNumeroSouche ( const vStTypeSouche, vStCodeSouche : string ; vNewValue,vOldValue : integer) : boolean;
function  CEquilibrePiece ( vTOBEcr : TOB ; TOBResult : TOB = nil ) : boolean;
function  CSoldePieceCompteAttente ( vTOBEcr : TOB ; var vRdSolde : double ; vInIndex : integer = 0 ; TOBResult : TOB = nil ) : boolean;
function  CCalculSoldePiece ( vTOBEcr : TOB ; vInIndex : integer = 0 ) : RecCalcul;
function  CAffectCompteContrePartie ( vTOBEcr : TOB ; vInfo : TInfoEcriture = nil ) : boolean;
procedure CSetMontants ( vTOBLigneEcr : TOB ; vRdDebit, vRdCredit : Double; vDev : RDEVISE; vBoForce : Boolean = true);
procedure CSetCotation ( vTOBLigneEcr : TOB ) ;
procedure CSetPeriode  ( vTOBLigneEcr : TOB );
function  CGetBalanceParcompte (Exo,Compte : string; Dateecr1,Dateecr2 : TDateTime ; var MttDeb,MttCre,MttSolde : double; Anouveau : string=''; Auxi : Boolean=FALSE) : Boolean;
function  CBlocageBor(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean;
function  CBloqueurBor(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Bloc : boolean ; Parle : boolean = true) : boolean;
function  CEstBloqueBor( vStJournal : string = '' ; vDtDateComptable : TDateTime = -1 ; vInNumeroPiece : integer = -1 ; Parle : boolean = true ) : boolean;
procedure CAfficheLigneEcrEnErreur( O : TOB );
procedure CSupprimerInfoLettrage( vTOBLigneEcr : TOB );
procedure CRemplirInfoLettrage( vTOBLigneEcr : TOB );

function  CBloqueurJournal( Bloc : boolean ; vStJournal : string = '' ; Parle : boolean = true ) : boolean ;
function  CEstBloqueJournal( vStJournal : string ; Parle : boolean = true ) : boolean;

{$IFNDEF NOVH}
procedure CRemplirDateComptable( vTOBLigneEcr : TOB ; Value : TDateTime );
{$ENDIF}
procedure CPutDefautEcr( vTOBLigneEcr : TOB );
procedure CDupliquerTOBEcr( vTOBLigneSource,vTOBLigneDestination : TOB );
procedure CDupliquerInfoAux( vTOBLigneSource,vTOBLigneDestination : TOB );
procedure CRemplirInfoPointage( vTOBLigneEcr : TOB );
procedure CNumeroPiece( vTOBPiece : TOB );
function  COuvreScenario( vStJournal, vStNature, vStQualifpiece, vStEtablissement : string ; vTOBResult : TOB ; var vMemoComp : HTStringList ; vDossier : String = '') : boolean;
function  CGetRIB( vTOBLigneEcr : TOB ) : string;
procedure CInitMessageBor ( vListe : HTStringList );
procedure CInitMessagePiece ( vListe : HTStringList );
function  CPrintMessageRC(vStTitre : string ; RC_Numero : integer ; vListe : HTStrings ) : integer;
function  CPrintMessageReC(vStTitre : string ; RC_Error : TRecError ; vListe : HTStrings ) : integer;
function  CGetMessageRC( RC_Numero : integer ; vListe : HTStrings ) : string ;
procedure CRDeviseVersTOB( vRecRDevise : RDevise ; vTOB : TOB ) ;
procedure CTOBVersRDevise( vTOB : TOB ; var vRecRDevise : RDevise ) ;
function  CIsCarRecherche ( vValues : string ) : boolean ;
function  CGetSQLFromTable(TableName : string; ExceptFields : array of string ; WithOutFrom : boolean = false ) : string;
procedure CMakeSQLLookupGen(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vTypeExo : TTypeExo = teEnCours ) ;
procedure CMakeSQLLookupAux(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vStNaturePiece,vStNatureGene : string ) ;
procedure CMakeSQLLookupAuxGrid(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vStPremierCarDuCompte,vStNaturePiece,vStNatureGene : string ) ;
function  CQuelRecherche ( var vStCompte,vStAux : string ; vStNat : string ) : TTypeRechGen;
function  CControleDateBor(vDateComptable : TDateTime ; vExercice : TZExercice ; Parle : Boolean = true ; vStCodeExo : string = '' ) : boolean ;
function  CGetListeBordereauBloque : TOB ;
function  CEstBloqueEcritureBor ( vEcr : TOB ; vListeBor : TOB = nil ) : boolean ;
{$IFNDEF EAGLSERVER}
function  CIsRowLock(G : THGrid ; Lig : integer = - 1) : boolean ;
function  CControleLigneBor( G : THGrid ; vListeBor : TOB = nil )  : boolean ;
{$ENDIF}
function  CEstSaisieOuverte( Parle : boolean = false) : boolean ;
function  CUnSeulEtablis : boolean ;
{$IFNDEF EAGLSERVER}
{$IFNDEF NOVH}
procedure CDateParDefautPourSaisie( var vDateDebut,vDateFin : TDateTime ) ;
procedure CDecodeKeyForAux ( vInKey : Word ; vShift : TShiftState ; var vBoCodeOnly, vBoLibelleOnly, vBoBourrage : boolean );
{$ENDIF}
{$ENDIF}
function  CControleChampsObligSaisie ( vEcr : TOB ; var vStMessage : string ) : Integer ;
procedure CSupprimeLigneSaisieVide ( vTOB : TOB ) ;
function  CZompteVersTGGeneral ( vCompte : TZCompte ) : TGGeneral ;
procedure CAffectRegimeTva( vTOBEcr : TOB ) ;
function  CGetRowTiers( vTOBEcr : TOB ; vIndex : integer ; vInfo : TInfoEcriture ) : integer ;
procedure CRempliComboFolio ( vItem, vValue : HTStrings ; E_JOURNAL,E_EXERCICE : string ; E_DATECOMPTABLE : TDateTime ; vBoTestErcValide : boolean = false) ;
{$IFNDEF EAGLSERVER}
function  CControleVisa ( vStCompte : string ; vInfo : TInfoEcriture )  : boolean ;
{$ENDIF}

procedure CNumeroLigneBor(vTOBPiece : TOB );
function  CEnregistreSaisie( vTOBEcr : TOB ; vNumerote : boolean ; vAjouter : boolean = false ; vBoInsert : boolean = true ; vInfo : TInfoEcriture = nil ; vBoEcrNormale : Boolean = True) : boolean ;
function  CMAJSaisie( vTOBEcr : TOB ) : boolean ;
function  CDetruitAncienPiece( vTOB : TOB ; vDossier : String = '' ) : boolean ;
function  CDetruitAncienAnaPiece( vTOB : TOB ; vDossier : String = '' ) : boolean ;
function  CDetruitAncienAnaEcr( vTOB : TOB ) : boolean ;

function  CIsValidEtabliss( vTOB : TOB ; const vInfo : TInfoEcriture  ) : integer ;
function  CIsValidNat ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidEcrANouveau ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidModeSaisie ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidPeriodeSemaine( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidMontant( vRdMontant : double ) : integer ;
function  CIsValidJournal( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidJal( vStCodeJal : string ; vStCodeDev : string ; vInfo : TInfoEcriture ) : integer ;
function  CIsValidCompte( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidAux( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidAuxEnSaisie( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
function  CIsValidDate( vTOB : TOB ; vInfo : TInfoEcriture ) : integer ;
function  CIsValidDateC( vDate : TDateTime ; vInfo : TInfoEcriture ; vBoForceBor : boolean = false ) : integer ;

function  CIsValidSaisiePiece( vTob : TOB ; vInfo : TInfoEcriture ; vBoPourSaisie : boolean = false ) : TRecError ;
function  CIsValidLigneSaisie( vTob : TOB ; vInfo : TInfoEcriture ; vBoPourSaisie : boolean = false  ) : TRecError ;
procedure CChargeTInfoEcr( vTob : TOB ; var vInfo : TInfoEcriture ; vDossier : String = '' ) ;

function  CBlocageLettrage(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean ;
procedure CDeBlocageLettrage ( Parle : boolean = false ) ;
//procedure CDeBlocageLettrageP (vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) ;
function  CEstBloqueLettrage ( Parle : boolean = false) : boolean ;
function  CEstBloqueLett (vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean ;
function  EncodeDateBor ( vInAnnee , vInMois : integer ; vTExo : TExoDate ) : TDateTime ;
//procedure CGetEch        ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
procedure CGetRegimeTVA  ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
procedure CGetTVA        ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
procedure CGetConso      ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
//procedure CGetAnalytique ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
{$IFNDEF NOVH}
procedure CGetTypeMvt    ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
{$ENDIF}

function WhereEcritureTOB( vTS : TTypeSais ; vTobEcr : TOB ; vBoLigneSeule : boolean ; vBoBordereau : Boolean = FALSE; Prefix : string = '' ) : String ;
function RIBestIBAN ( vE_Rib : String ) : Boolean ;
Function IBANtoE_RIB( vIBan : String ) : String ;

function CEstAutoriseDelettrage( vBoSelected : Boolean; vBoTestSelected : Boolean ) : Boolean;

procedure CPutTOBCompl ( vTOB : TOB ;  Valeur : TOB ) ;
function  CSelectDBTOBCompl( vTOB : TOB ; TheParent : TOB ) : TOB ;
function  CGetTOBCompl ( vTOB : TOB ) : TOB ;
function  CGetValueTOBCompl ( vTOB : TOB  ; Nom : string ) : variant ;
procedure CPutValueTOBCompl (  vTOB : TOB ;  Nom : string ; Valeur : variant ) ;
procedure CFreeTOBCompl ( vTob : TOB ) ;
function  CCreateDBTOBCompl( vTOB : TOB ; TheParent : TOB ; Q : TQuery ) : TOB ;
function  CCreateTOBCompl( vTOB : TOB ; TheParent : TOB ) : TOB ;
procedure CMAJTOBCompl( vTOB : TOB ) ;
procedure CDeleteDBTOBCompl( vQ : TQuery ) ;
procedure CSupprimerEcrCompl( vTOB : TOB ;  vDossier : String = '' ) ;
procedure CCalculDateCutOff( vTOB : TOB ; G_CUTOFFPERIODE : string ; G_CUTOFFECHUE : string) ;

{$IFNDEF EAGLSERVER}
{$IFNDEF ERADIO}
function  CLookupListAux( E : TControl ; vStCarLookUp,vStNaturePiece,vStNatureGene : string ; vStTableTiers : string = '' ) : boolean ;
{$ENDIF}
{$ENDIF}

// Nouvelles fonctions de calcul des �ch�ances s'appuiyant sur le TInfoEcriture
function  CGetModeRegleInit  ( vTobEcr : Tob   ; vInfo : TInfoEcriture ) : string ;
procedure CGetEch            ( vTobEcr : Tob   ; vInfo : TInfoEcriture = nil ) ;
function  CCalculEche        ( vTobPiece : Tob ; vIndex : integer ; var vStModeFinal : string ; vInfo : TInfoEcriture = nil ; vBoMono : boolean = False ) : boolean ;
function  CCalculMonoEche    ( vTobEcr : Tob   ; vInfo : TInfoEcriture = nil ; vStModeForce : string = '' ) : boolean ;
function  EcheArrondie( DRef : TDateTime ; ArrondirAu : String3 ; JP1,JP2 : integer) : TDateTime ;
function  NextEche ( DD : TDateTime ; Separe : String3 ) : TDateTime ;
function  ProchaineDate( DD : TDateTime ; SEP, ARR : String3 ) : TDateTime ;

type

 TOnUpdateEcriture = ( cEcrCompl, cEcrBor ) ;
 TOnUpdateEcritures = set of TOnUpdateEcriture ;

// SBO 26/11/2003 : EVT sur maj table �criture (utilis� pour mode pi�ce uniquement pout le moment)
//Function  OnUpdateEcriture( vEcr : TQuery ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ) : Boolean ; // ok
function  OnUpdateEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ; vInfo : TInfoEcriture = nil  ) : boolean ;
//Function  OnDeleteEcriture( vEcr : TQuery ; vListeAction : TOnUpdateEcritures) : Boolean ;
Function  OnDeleteEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ) : Boolean ;

// SBO 01/07/2007 : enregistrement sp�cifique pour pb CWAS
function CTobInsertDB( vTob : Tob ; vBoByNivel : boolean = false ; vBoTransac : boolean = false; vBoMultiNiv : boolean = True ) : boolean ;


function  CSupprimerPiece( vTOB : TOB ; vInfo : TInfoEcriture = nil ) : integer ;


implementation



uses
 {$IFNDEF ERADIO}
 {$IFNDEF EAGLSERVER}
 ULibWindows, // pour le CGetGridSens
 Lookup,
 {$ENDIF}
 {$ENDIF}
 ParamSoc,
 hdebug,  // debug
 UtilSais, // pour le NaturePieceCompteOk
 Messages,  // pour le WM_KEYDOWN
 SysUtils,  // pour IntToStr
 HMsgBox,   // pour le PGIInfo
 UtilPGI,   // pour les fct de conversion ( EuroToPivot ... )
 {$IFNDEF LAURENT}
 {$IFNDEF CCADM}
 {$IFNDEF CCSTD}
 ULibTrSynchro,
 {$ENDIF}
 {$ENDIF}
 {$ENDIF}
 {$IFDEF MODENT1}
 CPVersion, 
 CPProcGen,
 CPProcMetier,
 {$ENDIF MODENT1}
 uLibAnalytique ;



const
 _InMaxChamps = 35 ;   _InMaxChampsRepar = 5 ;
 _RecChampsOblig : array[0.._InMaxChamps] of string =
 ('E_EXERCICE'     ,'E_JOURNAL'       ,'E_DATECOMPTABLE' ,'E_NUMEROPIECE'     ,'E_NUMLIGNE'     ,'E_GENERAL'       ,'E_DEBIT'         ,'E_CREDIT',
  'E_NATUREPIECE'  ,'E_QUALIFPIECE'   ,'E_VALIDE'          ,'E_UTILISATEUR'   ,'E_DATECREATION'  ,'E_DATEMODIF',
  'E_SOCIETE'      ,'E_ETABLISSEMENT' {'E_VISION'}        ,'E_TVAENCAISSEMENT' ,'E_LETTRAGEDEV'  ,'E_DATEPAQUETMAX' ,'E_ECRANOUVEAU',
  'E_DATEPAQUETMIN','E_DEVISE'          ,'E_DEBITDEV'     ,'E_CREDITDEV'       ,'E_TAUXDEV'       ,'E_COTATION',
  'E_MODESAISIE'   ,'E_PERIODE'       ,'E_SEMAINE'       {'E_ETATREVISION'}    ,'E_IO'           ,'E_PAQUETREVISION','E_CONTROLE'    ,
  'E_ETATLETTRAGE' ,'E_CREERPAR'        ,'E_EXPORTE'       , 'E_CONFIDENTIEL'  ) ;
 _RecReparChampsOblig : array[0.._InMaxChampsRepar ,0..1 ] of string =
 ( ( 'E_VISION'       , 'DEM' ) ,
   ( 'E_ETAT  '       , '0000000000' ) ,
   ( 'E_ETATREVISION' , '-' ) ,
   ( 'E_CONTROLETVA'  , 'RIE' ) ,
   ( 'E_ENCAISSEMENT' , 'RIE' ) ,
   ( 'E_TYPEMVT'      , 'DIV' ) ) ;


{type

 TProcAction  = procedure ( vTOB : TOB ; vInfo : TInfoEcriture  ) ;
 TProcControle = function ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
 TRecRepare = record
   RC_Error    : integer;
   Action      : TProcAction ;
   Controle    : TProcControle ;
 end ;

const
 _ListeError : array [0..1] of TRecRepare =
 (
  ( RC_Error : RC_DATEVALEURINCORRECT ; Action : CGetEch ; Controle : _IsValidLigne ) ,
  ( RC_Error : 2  ; Action : CGetEch ; Controle : _IsValidLigne )
  )
 ;

procedure RepareTOBEcr ( vTOB : TOB ; var vRC_Error : integer ; vInfo : TInfoEcriture  ) ;
var
 i : integer ;
begin

 for i := low(_ListeError) to high(_ListeError) do
  if _ListeError[i].RC_Error = vRC_Error then
   begin
    _ListeError[i].Action(vTOB,vInfo) ;
    vRC_Error := _ListeError[i].Controle(vTOB,vInfo) ;
   end ;


end ; }


{$IFDEF TT}
var
 TheLogU : HTStringList;
 TheLastError : string ;

procedure DelEvenement ;
begin
 exit ;
 if TheLogU=nil then TheLogU:=HTStringList.Create ;
 TheLogU.Clear ;
 {$I-}
 //Modif FV Version 5 - Version 7
 //TheLogU.SaveToFile('c:\ULibEcriture.txt') ;
 TheLogU.SaveToFile(IncludeTrailingBackSlash(TCBPPath.GetGegidDataDistri) + 'ULibEcriture.txt') ;
 {$I+}
end;

procedure AddEvenement( value : string );
begin
 // fuite memoire qd on l'utilise a remettre pour test
 exit ;
 if TheLogU=nil then TheLogU:=HTStringList.Create ;
 TheLastError:=value ;
 TheLogU.Add(Value) ;
 {$I-}
 //Modif FV Version 5 - Version 7
 //TheLogU.SaveToFile('c:\ULibEcriture.txt') ;
 TheLogU.SaveToFile(IncludeTrailingBackSlash(TCBPPath.GetGegidDataDistri) + 'ULibEcriture.txt') ;
 {$I+}
end;

{$ENDIF}

procedure _CTestErreur( var vErreur : TRecError ; vInfo : TInfoEcriture ) ;
var
 j : integer ;
begin
 for j := low(vInfo.ErreurIgnoree) to high(vInfo.ErreurIgnoree) do
  if vErreur.RC_Error = vInfo.ErreurIgnoree[j] then
   begin
    vErreur.RC_Error := RC_PASERREUR ;
    break ;
   end ;
end ;

procedure _CTestCodeErreur( var vErreur : integer ; vInfo : TInfoEcriture ) ;
var
 j : integer ;
begin
 for j := low(vInfo.ErreurIgnoree) to high(vInfo.ErreurIgnoree) do
  if vErreur = vInfo.ErreurIgnoree[j] then
   begin
    vErreur := RC_PASERREUR ;
    break ;
   end ;
end ;



{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 02/12/2002
Modifi� le ... : 10/12/2002
Description .. : -02/12/2002 - fiche 10942 - on ne pouvait pas saisir des
Suite ........ : comptes
Suite ........ : generaux alphanumerique
Mots clefs ... :
*****************************************************************}
function CQuelRecherche ( var vStCompte,vStAux : string ; vStNat : string ) : TTypeRechGen;
var
 lStCar : string ;
begin

 lStCar := UpperCase(Copy(vStCompte,1,1)) ;

 if ( lStCar = RC_CODEGEN ) then
  begin
    vStAux         := Copy(vStCompte,2,length(vStCompte)) ;
    vStCompte      := '' ;
    result         := RechAux ;
    exit ;
  end;

 if ( ( lStCar = RC_CODEFOUN ) and (CASENATP(vStNat) in [4,5,6,7]) ) or ( ( lStCar = RC_CODECLIN ) and (CASENATP(vStNat) in [1,2,3,7]) ) then
  begin
    vStAux           := vStCompte ;
    vStCompte        := '' ;
    result           := RechAux ;
    exit ;
  end;

  if ( (lStCar = RC_CODEFOU) and (CASENATP(vStNat) in [7]) ) or ( (lStCar = RC_CODECLI) and (CASENATP(vStNat) in [7]) ) or
     ( (lStCar = RC_CODESAL) and (CASENATP(vStNat) in [7]) ) or ( (lStCar = RC_CODEDIV) and (CASENATP(vStNat) in [7]) ) then
   begin
    vStAux             := Copy(vStCompte,2,length(vStCompte)) ;
    vStCompte          := '' ;
    result             := RechAux ;
    exit ;
   end; // if

   if ( vStCompte <> '' ) and  not IsNumeric(vStCompte) then
    begin
     if not(lStCar[1] in ['1'..'8']) then
     begin
     vStAux            := vStCompte ;
     vStCompte         := '' ;
     result            := RechAux ;
     exit ;
     end;
    end; // if
 
  result := RechGen ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 20/02/2003
Modifi� le ... : 25/08/2005
Description .. : - 20/02/2003 - FB 12005 - on ne propose pas les comptes 
Suite ........ : ferme
Suite ........ : - FB 16397 - LG  - 25/08/2005 - test de la revision
Suite ........ : uniquement pour l'exercice en cours
Mots clefs ... : 
*****************************************************************}
procedure CMakeSQLLookupGen(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vTypeExo : TTypeExo = teEnCours ) ;
begin
 vStSelect  := 'G_LIBELLE' ;
 vStOrder   := 'G_GENERAL' ;
 vStColonne := 'G_GENERAL' ;
 vStWhere   := 'G_FERME<>"X" ' + ' AND ' + CGenereSQLConfidentiel('G') ;
// if ( vTypeExo = teEnCours ) then
//  vStWhere   := ' AND G_VISAREVISION<>"X" ' ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 20/02/2003
Modifi� le ... : 09/09/2005
Description .. : - 20/02/2003 - FB 12005 - on ne propose pas les comptes
Suite ........ : ferme
Suite ........ : - VL - 14/10/2003 - FB 12769 - ?
Suite ........ : - LG - 31/10/2003 - FB 12904 - pour une nature d'ecriture 
Suite ........ : OD on affiche trois colonne : code,libelle et nature
Suite ........ : - LG - 03/08/2004 - FB 13626 - le compte sur les auxi ferme
Suite ........ : etait incorrect
Suite ........ : - LG - 10/11/2004 - FB 14912 - ajout des tiers crediteurs et 
Suite ........ : debiteurs pour les natures FF et FC
Suite ........ : - LG - 09/09/2205 - FB x
Suite ........ : en saisie  Bordereau  Uniquement sur les journaux qui ne 
Suite ........ : sont pas de type Achat et Vente on voit dans la liste des 
Suite ........ : tiers des tiers de nature Prospect , Concurrent , Suspect .
Mots clefs ... : 
*****************************************************************}
procedure CMakeSQLLookupAux(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vStNaturePiece,vStNatureGene : string ) ;
begin

 vStWhere   := '' ;
 vStColonne := 'T_AUXILIAIRE' ;
 vStOrder   := 'T_AUXILIAIRE' ;
 vStSelect  := 'T_LIBELLE' ;

 case CaseNatP(vStNaturePiece) of
  4,5,6 : vStWhere := '(T_NATUREAUXI="FOU" OR T_NATUREAUXI="AUC" OR T_NATUREAUXI="DIV") ' ;
  1,2,3 : vStWhere := '(T_NATUREAUXI="CLI" OR T_NATUREAUXI="AUD" OR T_NATUREAUXI="DIV") ' ;
 end; // case

 if vStNatureGene = 'COF' then vStWhere := '(T_NATUREAUXI="FOU" OR T_NATUREAUXI="AUC" OR T_NATUREAUXI="DIV") '  // FQ 12769
  else
   if vStNatureGene = 'COC' then vStWhere := '(T_NATUREAUXI="CLI" OR T_NATUREAUXI="AUD" OR T_NATUREAUXI="DIV") '  // FQ 12769
    else
     if vStNatureGene = 'COS' then vStWhere := 'T_NATUREAUXI="SAL"'
      else
       if vStNatureGene = 'COD' then vStWhere := '' // FQ 12769 un collectif divers peut prendre TOUT type d'auxiliaire
        else
         if vStNatureGene = 'DIV' then vStWhere := 'T_NATUREAUXI="DIV"';  // FQ 12769

  if vStWhere = '' then
   vStWhere := vStWhere + ' T_FERME<>"X" AND (T_NATUREAUXI<>"NCP" AND T_NATUREAUXI<>"CON" AND T_NATUREAUXI<>"PRO" AND T_NATUREAUXI<>"SUS") '
               + ' AND ' + CGenereSQLConfidentiel('T')
    else
     vStWhere := vStWhere + 'AND T_FERME<>"X" AND (T_NATUREAUXI<>"NCP" AND T_NATUREAUXI<>"CON" AND T_NATUREAUXI<>"PRO" AND T_NATUREAUXI<>"SUS") '
               + ' AND ' + CGenereSQLConfidentiel('T') ;

  if UpperCase(vStNaturePiece) = 'OD' then
  begin
   vStSelect  := 'T_LIBELLE, T_NATUREAUXI' ;
   vStOrder   := 'T_AUXILIAIRE,T_NATUREAUXI ' ;
  end
   else
    begin
     vStSelect  := 'T_LIBELLE' ;
     vStOrder   := 'T_AUXILIAIRE' ;
    end; // if

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 20/02/2003
Modifi� le ... : 14/10/2003
Description .. : - 20/02/2003 - FB 11938 - la saisie d'un 0 ou 9 avec une
Suite ........ : nature OD ne fct pas.
Suite ........ : - LG - 28/07/2003 - FB 12005 - le C+F5 ds la case des
Suite ........ : generaux affichaient les auxi fermes
Suite ........ : - VL - 14/10/2003 - FB 12769 - ?
Mots clefs ... :
*****************************************************************}
{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 31/10/2003
Modifi� le ... :   /  /
Description .. : - LG - 31/10/2003 - FB 12904 - pour une nature d'ecriture
Suite ........ : OD on affiche trois colonne : code,libelle et nature
Mots clefs ... :
*****************************************************************}
procedure CMakeSQLLookupAuxGrid(var vStWhere,vStColonne,vStOrder,vStSelect : string ; vStPremierCarDuCompte,vStNaturePiece,vStNatureGene : string ) ;


 procedure _AjoutCondition( vStSql : string ) ;
 begin
  if vStWhere = '' then vStWhere := vStSql
   else
   vStWhere := vStWhere + 'AND ' + vStSql ;
 end;

begin

 CMakeSQLLookupAux(vStWhere,vStColonne,vStOrder,vStSelect,vStNaturePiece,vStNatureGene) ;

 vStPremierCarDuCompte := UpperCase(vStPremierCarDuCompte) ;
 // pour les piece de type OD si le collectif n'est pas renseigner on test le 1er caractere du compte
 if ( CaseNatP(vStNaturePiece) = 7 ) and ( vStNatureGene = '' ) then
   begin
    if (vStPremierCarDuCompte = RC_CODEFOU) or (vStPremierCarDuCompte = RC_CODEFOUN) then _AjoutCondition('T_NATUREAUXI="FOU" OR T_NATUREAUXI="AUC" OR T_NATUREAUXI="DIV"')  // FQ 12769
     else
      if (vStPremierCarDuCompte = RC_CODECLI) or (vStPremierCarDuCompte = RC_CODECLIN) then _AjoutCondition('T_NATUREAUXI="CLI" OR T_NATUREAUXI="AUD" OR T_NATUREAUXI="DIV"' )  // FQ 12769
       else
        if (vStPremierCarDuCompte = RC_CODESAL) then _AjoutCondition('T_NATUREAUXI="SAL"')
         else
          if (vStPremierCarDuCompte = RC_CODEDIV) then _AjoutCondition('T_NATUREAUXI="DIV" OR T_NATUREAUXI="AUC" OR T_NATUREAUXI="AUD"') ; // FQ 12769

    vStPremierCarDuCompte := '' ;

   end;

end;


function CGetSQLFromTable(TableName : string; ExceptFields : array of string ; WithOutFrom : boolean = false ) : string;
var
 i,j : integer;
 lIndex : integer ;
 GarderChamps : boolean ;
begin

 result:='' ;
 if (trim(TableName)='') then exit ; TableName:=UpperCase(TableName) ;
 lIndex:=PrefixeToNum(TableToPrefixe(TableName)) ; if lIndex=-1 then exit ;
 {$IFDEF EAGLSERVER}
 for i:=1 to High(V_PGI.HDEChamps[LookupCurrentSession.SocNum, lIndex]) do
 {$ELSE EAGLSERVER}
 for i:=1 to High(V_PGI.DeChamps[lIndex]) do
 {$ENDIF EAGLSERVER}
  begin
   GarderChamps:=true ;
   for j:=low(ExceptFields) to high(ExceptFields) do
    if V_PGI.DEChamps[lIndex,i].Nom=UpperCase(ExceptFields[j]) then begin GarderChamps:=false; break ; end ;
   if GarderChamps then result:= result+V_PGI.DEChamps[lIndex,i].Nom+',';
  end; // for;
 if result = '' then
  begin
   if WithOutFrom then
    result := 'select *'
    else
     result := 'select ' + TableName + '.* from ' +TableName ;
  end
   else
    if WithOutFrom then
     result:='SELECT '+copy(result,1,length(result)-1)
      else
       result:='SELECT '+copy(result,1,length(result)-1)+' FROM '+TableName ;

end;

procedure CInitMessageBor ( vListe : HTStringList );
begin
 vListe.Clear;
 vListe.Add('0;?caption?;S�lection du compte;E;O;O;O;');
 vListe.Add('1;?caption?;S�lection du tiers;E;O;O;O;');
 vListe.Add('2;?caption?;Num�ro de Bordereau incorrect;E;O;O;O;');
 vListe.Add('3;?caption?;Journal non sold�;E;O;O;O;');
 vListe.Add('4;?caption?;S�lection de la nature;E;O;O;O;');
 vListe.Add('5;?caption?;Impossible de sauvegarder le Bordereau;E;O;O;O;');
 vListe.Add('6;?caption?;Compte interdit sur ce journal;E;O;O;O;');
 vListe.Add('7;?caption?;Le guide de saisie est incorrect !!!;E;O;O;O;');
 vListe.Add('8;?caption?;Le dernier folio n''a pas �t� sauvegard� correctement;E;O;O;O;');
 vListe.Add('9;?caption?;Simulation d''une coupure de courant;E;O;O;O;');
 vListe.Add('10;?caption?;Veuillez param�trer les comptes d''attente de la fiche soci�t�;E;O;O;O;');
 vListe.Add('11;?caption?;Mouvement lettr� non modifiable ...;E;O;O;O;');
 vListe.Add('12;?caption?;Cr�ation de ce folio en cours.;E;O;O;O;');
 vListe.Add('13;?caption?;Ce bordereau est en cours de modification, seule la consultation est possible;E;O;O;O;');
 vListe.Add('14;?caption?;Euro;E;O;O;O;');
 vListe.Add('15;?caption?;en mode Bordereau;E;O;O;O;');
 vListe.Add('16;?caption?;en mode Libre;E;O;O;O;');
 vListe.Add('17;?caption?;Ce bordereau est valid�, seule la consultation est possible;E;O;O;O;');
 vListe.Add('18;?caption?;La saisie en Euro avant sa date d''entr�e en vigueur est impossible;E;O;O;O;');
 vListe.Add('19;?caption?;Ce compte g�n�ral est interdit pour cette nature de pi�ce;E;O;O;O;');
 vListe.Add('20;?caption?;Aucune des modifications apport�es ne sera prise en compte.#10#13Veuillez utiliser F10 pour enregister.#10#13Confirmez-vous l''abandon de la saisie ?;Q;YN;N;N;');
 vListe.Add('21;?caption?;Vous n''avez pas le droit de saisir sur ce journal;E;O;O;O;');
 vListe.Add('22;?caption?;Attention : ce compte est ferm� et sold�. Vous ne pouvez plus l''utiliser en saisie;E;O;O;O;');
 vListe.Add('23;?caption?;Vous ne pouvez pas saisir sur le compte d''ouverture de bilan;E;O;O;O;');
 vListe.Add('24;?caption?;Vous ne pouvez pas saisir des montants n�gatifs;E;O;O;O;');
 vListe.Add('25;?caption?;Le montant que vous avez saisi est en dehors de la fourchette autoris�e;E;O;O;O;');
 vListe.Add('26;?caption?;Saisie des �critures;E;O;O;O;');
 vListe.Add('27;?caption?;Mouvement li� � un compte ferm� non modifiable;E;O;O;O;');
 vListe.Add('28;?caption?;Attention : le compte auxiliaire est en sommeil;E;O;O;O;');
 vListe.Add('29;?caption?;Attention : la ligne n''est pas correcte;E;O;O;O;');
 vListe.Add('30;?caption?;Attention : le RIB de la ligne n''est pas correct;E;O;O;O;');
 vListe.Add('31;?caption?;Journal non sold�, Voulez-vous abandonner la saisie ?;Q;YN;N;N;');
 vListe.Add('32;?caption?;Votre pi�ce est incorrecte : elle doit comporter une ligne sur le compte de tr�sorerie du journal;E;O;O;O;');
 vListe.Add('33;?caption?;Votre bordereau est incorrect : il doit comporter une ligne sur le compte de tr�sorerie du journal;E;O;O;O;');
 vListe.Add('34;?caption?;Le compte g�n�ral  %s de la ligne %d est interdit pour cette nature de pi�ce;E;O;O;O;');
 vListe.Add('35;?caption?;Voulez-vous cr�er une fiche d''immobilisation ?;Q;YN;Y;N;');
 vListe.Add('36;?caption?;Vous n''avez pas le droit de modifier les �critures : seule la consultation est autoris�e;E;O;O;O;');
 vListe.Add('37;?caption?;Journal utilis� par : ;E;O;O;O;');
 vListe.Add('38;?caption?;Voulez-vous lettrer vos �ch�ances ?;Q;YN;Y;Y;');
 vListe.Add('39;?caption?;La devise saisie ne peut �tre utilis�e avec ce tiers;E;O;O;O;');
 vListe.Add('40;?caption?;Voulez-vous arr�ter le guide de saisie ?;Q;YN;Y;Y;');
 vListe.Add('41;?caption?;L''immobilisation n''existe plus;W;O;O;O;');
 vListe.Add('42;?caption?;Ce bordereau n''a pas �t� enregistr�, Voulez-vous recommencer ?;Q;YN;Y;Y;');
 vListe.Add('43;?caption?;Ce bordereau a d�j� �t� r�vis�;E;O;O;O;');
 vListe.Add('44;?caption?;Choix d''un compte automatique;E;O;O;O;');
 vListe.Add('45;?caption?;Mouvement point� non modifiable ...;E;O;O;O;');
 vListe.Add('46;?caption?;Mouvement  li� � une immobilisation non modifiable ...;E;O;O;O;');
 vListe.Add('47;?caption?;Mouvement  valid� en TVA encaissements non modifiable ...;E;O;O;O;');
 vListe.Add('48;?caption?;ATTENTION : Des conflits d''acc�s ont �t� d�tect�s ! '+#13#10+'La pi�ce est valid�e, mais vous devez demander � l''administrateur de lancer un recalcul du solde des comptes;E;O;O;O;');
 vListe.Add('49;?caption?;PME;E;O;O;O;');
 vListe.Add('50;?caption?;Le compte rattach� � l''auxiliaire n''existe pas;E;O;O;O;');
 vListe.Add('51;?caption?;Vous ne pouvez pas saisir sur le compte d''�cart de conversion euro;E;O;O;O;');
 vListe.Add('52;?caption?;Ce compte n''est pas collectif ! ;E;O;O;O;');
 vListe.Add('53;?caption?;Compte auxiliaire inexistant !;E;O;O;O;');
 vListe.Add('54;?caption?;Ce journal n''existe pas !;E;O;O;O;');
 vListe.Add('55;?caption?;Ce journal n''est pas multidevise !;E;O;O;O;');
 vListe.Add('56;?caption?;La date d''entr�e est incompatible avec la saisie. Vous ne pouvez pas cr�er de pi�ce � cette date;W;O;O;O;') ;
 vListe.Add('57;?caption?;Le champ E_ECRANOUVEAU n''est pas coh�rent avec le journal;E;O;O;O;') ;
 vListe.Add('58;?caption?;Le champ E_MODESAISIE n''est pas coh�rent avec le journal;E;O;O;O;') ;
 vListe.Add('59;?caption?;Erreur dans le champ E_NUMPERIODE/E_SEMAINE;E;O;O;O;') ;
 vListe.Add('60;?caption?;Le compte g�n�ral n''existe pas;E;O;O;O;') ;
 vListe.Add('61;?caption?;Le compte auxiliaire doit �tre renseign� ! ;E;O;O;O;') ;
 vListe.Add('62;?caption?;La nature du compte n''est pas coh�rente avec la nature du g�n�ral ! ;E;O;O;O;') ;
 vListe.Add('63;?caption?;la devise n''est pas renseign�e ! ;E;O;O;O;') ;
 vListe.Add('64;?caption?;Ecart de conversion euro non modifiable.... ! ;E;O;O;O;') ;
 vListe.Add('65;?caption?;Votre ecriture est incorrecte : nature inexistante.... ! ;E;O;O;O;') ;
 vListe.Add('66;?caption?;Votre ecriture est incorrecte : �tablissement inexistant.... ! ;E;O;O;O;') ;
 vListe.Add('67;?caption?;Cette nature est interdite pour ce journal ! ;E;O;O;O;') ;
 vListe.Add('68;?caption?;Votre �criture est incorrecte : les informations de lettrage ne sont pas correctes.... ! ;E;O;O;O;') ;
 vListe.Add('69;?caption?;Votre �criture est incorrecte : Le champ E_MODEPAIE n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('70;?caption?;Votre �criture est incorrecte : Le champ E_DATEVALEUR n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('71;?caption?;Votre �criture est incorrecte : Le champ E_REGIMETVA n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('72;?caption?;Votre �criture est incorrecte : Le champ E_TAUXDEV n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('73;?caption?;Vous ne pouvez pas abandonner la saisie alors qu''un lettrage ou une consultation est en cours !;W;O;O;O;');
 vListe.Add('74;?caption?;ATTENTION : Le journal est ferm� ;E;O;O;O;');
 vListe.Add('75;?caption?;L''�criture n''est pas sold�e !;E;O;O;O;');
 vListe.Add('76;?caption?;Votre �criture est incorrecte : Aucun montant n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('77;?caption?;Votre �criture est incorrecte : Un champ obligatoire n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('78;?caption?;Votre �criture est incorrecte : Le champ E_NUMEROPIECE n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('79;?caption?;Votre �criture est incorrecte : Le champ E_NUMLIGNE n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('80;?caption?;ATTENTION : Le journal est valid� ;E;O;O;O;');
 vListe.Add('81;?caption?;Votre �criture est incorrecte : les informations de pointage ne sont pas correctes.... ! ;E;O;O;O;') ;
 vListe.Add('82;?caption?;Ce compte est confidentiel ! ;E;O;O;O;') ;
 vListe.Add('83;?caption?;Ce bordereau contient un compte confidentiel ! ;E;O;O;O;') ;
 vListe.Add('84;?caption?;Votre �criture est incorrecte : Le champ E_CONTREPARTIEGEN n''est pas renseign� ;E;O;O;O;') ;
// ajout me fiche 19032 vListe.Add('85;?caption?;Ce bordereau est cl�tur�, seule la consultation est possible;W;O;O;O;');
 vListe.Add('85;?caption?;Cette p�riode est cl�tur�e, seule la consultation est possible;W;O;O;O;');
 vListe.Add('86;?caption?;Mouvement li� � un compte vis� non modifiable;E;O;O;O;');
 vListe.Add('87;?caption?;Ligne TTC import�e non modifiable;E;O;O;O;');
 vListe.Add('88;?caption?;Votre �criture est incorrecte : Le champ E_QUALIFPIECE n''est pas coh�rent avec le champs E_MODESAISIE ;E;O;O;O;') ;
 vListe.Add('89;?caption?;Votre pi�ce est incorrecte : toutes les lignes n''ont pas la m�me nature ! ;E;O;O;O;') ;
 vListe.Add('90;?caption?;ATTENTION : Des conflits d''acc�s ont �t� d�tect�s ! '+#13#10+'La pi�ce est valid�e, mais vous devez demander � l''administrateur de lancer un recalcul des a-nouveaux;E;O;O;O;');
 vListe.Add('91;?caption?;La section est inexistante !;E;O;O;O;');
 vListe.Add('92;?caption?;La section doit �tre renseign�e ! ;E;O;O;O;') ;
 vListe.Add('93;?caption?;Attention : cette section est ferm�e. Vous ne pouvez plus l''utiliser en saisie;E;O;O;O;');
 vListe.Add('94;?caption?;Cette section est soumise a un mod�le de restriction !;E;O;O;O;');
 vListe.Add('95;?caption?;L''axe de la section n''est pas coh�rente avec l''axe de la ligne;E;O;O;O;');
 vListe.Add('96;?caption?;La somme des ventilations doit �tre �gale � 100% !;E;O;O;O;') ;
 vListe.Add('97;?caption?;Le montant des ventilations n''est pas �gal au montant de la ligne d''�criture !;E;O;O;O;') ;
 vListe.Add('98;?caption?;Le montant en devise des ventilations n''est pas �gal au montant en devise de la ligne d''�criture !;E;O;O;O;') ;
 vListe.Add('99;?caption?;Attention ! Il a �t� relev� une incoh�rence dans les quantit�s saisies ( Quantit� 1 ) !;E;O;O;O;');
 vListe.Add('100;?caption?;Attention ! Il a �t� relev� une incoh�rence dans les quantit�s saisies ( Quantit� 2 ) !;E;O;O;O;');
 vListe.Add('101;?caption?;Votre ligne d''analytique est incorrecte : Aucun pourcentage n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('102;?caption?;Votre ligne d''analytique est incorrecte : Aucun montant n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('103;?caption?;La ventilation doit comporter au moins une ligne !;E;O;O;O;') ;
 vListe.Add('104;?caption?;Certaines sections sur le compte g�n�ral ne sont pas compatibles avec la d�finition du budget. Confirmez-vous la validation ?;Q;YN;N;N;') ;
 vListe.Add('105;?caption?;Le champs E_ENCAISSEMENT est obligatoire !;E;O;O;O;') ;
 vListe.Add('106;?caption?;L''�criture fait r�f�rence � la section "$$" qui n''existe pas. Veuillez corriger votre param�trage;E;O;O;O;') ;
 vListe.Add('107;?caption?;Saisie multidevise impossible en mode libre;E;O;O;O;') ;
 vListe.Add('108;?caption?;La date d''�ch�ance doit respecter la plage de saisie autoris�e.;E;O;O;O;') ;
 vListe.Add('109;?caption?;Votre saisie comporte plusieurs �tablissements !.;E;O;O;O;') ;
 vListe.Add('110;?caption?;la condition de r�glement du tiers est inconnue !' + '#10#13' +'Veuillez la renseigner dans l''onglet "R�glements" du param�trage du compte auxiliaire.;E;O;O;O;') ;
 vListe.Add('111;?caption?;la date n''est pas modifiable, une �criture de la pi�ce est lettr�e !.;E;O;O;O;') ;
 vListe.Add('112;?caption?;Vous ne pouvez pas saisir sur cette �tablissement !.;E;O;O;O;') ;
 vListe.Add('113;?caption?;Suppression impossible, la pi�ce a �t� modifi�e !.;E;O;O;O;') ;
 vListe.Add('114;?caption?;Impossible d''enregistrer la pi�ce de suppression !.;E;O;O;O;') ;
end;

procedure CInitMessagePiece ( vListe : HTStringList );
begin
// Message d'erreurs
 vListe.Clear;
 vListe.Add('0;?caption?;S�lection du compte;E;O;O;O;');
 vListe.Add('1;?caption?;S�lection du tiers;E;O;O;O;');
 vListe.Add('2;?caption?;Num�ro de pi�ce incorrect;E;O;O;O;');
 vListe.Add('3;?caption?;Journal non sold�;E;O;O;O;');
 vListe.Add('4;?caption?;S�lection de la nature;E;O;O;O;');
 vListe.Add('5;?caption?;Impossible de sauvegarder la pi�ce;E;O;O;O;');
 vListe.Add('6;?caption?;Compte interdit sur ce journal;E;O;O;O;');
 vListe.Add('7;?caption?;Le guide de saisie est incorrect !!!;E;O;O;O;');
 vListe.Add('8;?caption?;Le dernier folio n''a pas �t� sauvegard� correctement;E;O;O;O;');
 vListe.Add('9;?caption?;Simulation d''une coupure de courant;E;O;O;O;');
 vListe.Add('10;?caption?;Veuillez param�trer les comptes d''attente de la fiche soci�t�;E;O;O;O;');
 vListe.Add('11;?caption?;Mouvement lettr� non modifiable ...;E;O;O;O;');
 vListe.Add('12;?caption?;Cr�ation de ce folio en cours.;E;O;O;O;');
 vListe.Add('13;?caption?;Cette pi�ce est en cours de modification, seule la consultation est possible;E;O;O;O;');
 vListe.Add('14;?caption?;Euro;E;O;O;O;');
 vListe.Add('15;?caption?;en mode Bordereau;E;O;O;O;');
 vListe.Add('16;?caption?;en mode Libre;E;O;O;O;');
 vListe.Add('17;?caption?;Cette pi�ce est valid�e, seule la consultation est possible;E;O;O;O;');
 vListe.Add('18;?caption?;La saisie en Euro avant sa date d''entr�e en vigueur est impossible;E;O;O;O;');
 vListe.Add('19;?caption?;Ce compte g�n�ral est interdit pour cette nature de pi�ce;E;O;O;O;');
 vListe.Add('20;?caption?;Aucune des modifications apport�es ne sera prise en compte.#10#13Veuillez utiliser F10 pour enregister.#10#13Confirmez-vous l''abandon de la saisie ?;Q;YN;N;N;');
 vListe.Add('21;?caption?;Vous n''avez pas le droit de saisir sur ce journal;E;O;O;O;');
 vListe.Add('22;?caption?;Attention : ce compte est ferm� et sold�. Vous ne pouvez plus l''utiliser en saisie;E;O;O;O;');
 vListe.Add('23;?caption?;Vous ne pouvez pas saisir sur le compte d''ouverture de bilan;E;O;O;O;');
 vListe.Add('24;?caption?;Vous ne pouvez pas saisir des montants n�gatifs;E;O;O;O;');
 vListe.Add('25;?caption?;Le montant que vous avez saisi est en dehors de la fourchette autoris�e;E;O;O;O;');
 vListe.Add('26;?caption?;Saisie des �critures;E;O;O;O;');
 vListe.Add('27;?caption?;Mouvement li� � un compte ferm� non modifiable;E;O;O;O;');
 vListe.Add('28;?caption?;Attention : le compte auxiliaire est en sommeil;E;O;O;O;');
 vListe.Add('29;?caption?;Attention : la ligne n''est pas correcte;E;O;O;O;');
 vListe.Add('30;?caption?;Attention : le RIB de la ligne n''est pas correct;E;O;O;O;');
 vListe.Add('31;?caption?;Journal non sold�, Voulez-vous abandonner la saisie ?;Q;YN;N;N;');
 vListe.Add('32;?caption?;Votre pi�ce est incorrecte : elle doit comporter une ligne sur le compte de tr�sorerie du journal;E;O;O;O;');
 vListe.Add('33;?caption?;Votre pi�ce est incorrecte : elle doit comporter une ligne sur le compte de tr�sorerie du journal;E;O;O;O;');
 vListe.Add('34;?caption?;Le compte g�n�ral  %s de la ligne %d est interdit pour cette nature de pi�ce;E;O;O;O;');
 vListe.Add('35;?caption?;Voulez-vous cr�er une fiche d''immobilisation ?;Q;YN;Y;N;');
 vListe.Add('36;?caption?;Vous n''avez pas le droit de modifier les �critures : seule la consultation est autoris�e;E;O;O;O;');
 vListe.Add('37;?caption?;Journal utilis� par : ;E;O;O;O;');
 vListe.Add('38;?caption?;Voulez-vous lettrer vos �ch�ances ?;Q;YN;Y;Y;');
 vListe.Add('39;?caption?;La devise saisie ne peut �tre utilis�e avec ce tiers;E;O;O;O;');
 vListe.Add('40;?caption?;Voulez-vous arr�ter le guide de saisie ?;Q;YN;Y;Y;');
 vListe.Add('41;?caption?;L''immobilisation n''existe plus;W;O;O;O;');
 vListe.Add('42;?caption?;Cette pi�ce n''a pas �t� enregistr�e, Voulez-vous recommencer ?;Q;YN;Y;Y;');
 vListe.Add('43;?caption?;Cette pi�ce a d�j� �t� r�vis�e;E;O;O;O;');
 vListe.Add('44;?caption?;Choix d''un compte automatique;E;O;O;O;');
 vListe.Add('45;?caption?;Mouvement point� non modifiable ...;E;O;O;O;');
 vListe.Add('46;?caption?;Mouvement  li� � une immobilisation non modifiable ...;E;O;O;O;');
 vListe.Add('47;?caption?;Mouvement  valid� en TVA encaissements non modifiable ...;E;O;O;O;');
 vListe.Add('48;?caption?;ATTENTION : Des conflits d''acc�s ont �t� d�tect�s ! '+#13#10+'La pi�ce est valid�e, mais vous devez demander � l''administrateur de lancer un recalcul du solde des comptes;E;O;O;O;');
 vListe.Add('49;?caption?;PME;E;O;O;O;');
 vListe.Add('50;?caption?;Le compte rattach� � l''auxiliaire n''existe pas;E;O;O;O;');
 vListe.Add('51;?caption?;Vous ne pouvez pas saisir sur le compte d''�cart de conversion euro;E;O;O;O;');
 vListe.Add('52;?caption?;Ce compte n''est pas collectif ! ;E;O;O;O;');
 vListe.Add('53;?caption?;Compte auxiliaire inexistant !;E;O;O;O;');
 vListe.Add('54;?caption?;Ce journal n''existe pas !;E;O;O;O;');
 vListe.Add('55;?caption?;Ce journal n''est pas multidevise !;E;O;O;O;');
 vListe.Add('56;?caption?;La date d''entr�e est incompatible avec la saisie. Vous ne pouvez pas cr�er de pi�ce � cette date;W;O;O;O;') ;
 vListe.Add('57;?caption?;Le champ E_ECRANOUVEAU n''est pas coh�rent avec le journal;E;O;O;O;') ;
 vListe.Add('58;?caption?;Le champ E_MODESAISIE n''est pas coh�rent avec le journal;E;O;O;O;') ;
 vListe.Add('59;?caption?;Erreur dans le champ E_NUMPERIODE/E_SEMAINE;E;O;O;O;') ;
 vListe.Add('60;?caption?;Le compte g�n�ral n''existe pas;E;O;O;O;') ;
 vListe.Add('61;?caption?;Le compte auxiliaire doit �tre renseign� ! ;E;O;O;O;') ;
 vListe.Add('62;?caption?;La nature du compte n''est pas coh�rente avec la nature du g�n�ral ! ;E;O;O;O;') ;
 vListe.Add('63;?caption?;la devise n''est pas renseign�e ! ;E;O;O;O;') ;
 vListe.Add('64;?caption?;Ecart de conversion euro non modifiable.... ! ;E;O;O;O;') ;
 vListe.Add('65;?caption?;Votre ecriture est incorrecte : nature inexistante.... ! ;E;O;O;O;') ;
 vListe.Add('66;?caption?;Votre ecriture est incorrecte : �tablissement inexistante.... ! ;E;O;O;O;') ;
 vListe.Add('67;?caption?;Cette nature est interdite pour ce journal ! ;E;O;O;O;') ;
 vListe.Add('68;?caption?;Votre �criture est incorrecte : les informations de lettrage ne sont pas correctes.... ! ;E;O;O;O;') ;
 vListe.Add('69;?caption?;Votre �criture est incorrecte : Le mode de paiement n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('70;?caption?;Votre �criture est incorrecte : La date de valeur n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('71;?caption?;Votre �criture est incorrecte : Le r�gime de tva n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('72;?caption?;Votre �criture est incorrecte : Le taux de change n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('73;?caption?;Vous ne pouvez pas abandonner la saisie alors qu''un lettrage ou une consultation est en cours !;W;O;O;O;');
 vListe.Add('74;?caption?;ATTENTION : Le journal est ferm� ;E;O;O;O;');
 vListe.Add('75;?caption?;L''�criture n''est pas sold�e !;E;O;O;O;');
 vListe.Add('76;?caption?;Votre �criture est incorrecte : Aucun montant n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('77;?caption?;Votre �criture est incorrecte : Un champ obligatoire n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('78;?caption?;Votre �criture est incorrecte : Le numero de pi�ce n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('79;?caption?;Votre �criture est incorrecte : Le num�ro de ligne n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('80;?caption?;ATTENTION : Le journal est valid� ;E;O;O;O;');
 vListe.Add('81;?caption?;Votre �criture est incorrecte : les informations de pointage ne sont pas correctes.... ! ;E;O;O;O;') ;
 vListe.Add('82;?caption?;Ce compte est confidentiel ! ;E;O;O;O;') ;
 vListe.Add('83;?caption?;Cette pi�ce contient un compte confidentiel ! ;E;O;O;O;') ;
 vListe.Add('84;?caption?;Votre �criture est incorrecte : Le champ E_CONTREPARTIEGEN n''est pas renseign� ;E;O;O;O;') ;
 vListe.Add('85;?caption?;Cette pi�ce est cl�tur�e, seule la consultation est possible;W;O;O;O;');
 vListe.Add('86;?caption?;Mouvement li� � un compte vis� non modifiable;E;O;O;O;');
 vListe.Add('87;?caption?;Ligne TTC import�e non modifiable;E;O;O;O;');
 vListe.Add('88;?caption?;Votre �criture est incorrecte : Le champ E_QUALIFPIECE n''est pas coh�rent avec le champs E_MODESAISIE ;E;O;O;O;') ;
 vListe.Add('89;?caption?;Votre pi�ce est incorrecte : toutes les lignes n''ont pas la m�me nature ! ;E;O;O;O;') ;
 vListe.Add('90;?caption?;ATTENTION : Des conflits d''acc�s ont �t� d�tect�s ! '+#13#10+'La pi�ce est valid�e, mais vous devez demander � l''administrateur de lancer un recalcul des a-nouveaux;E;O;O;O;');
 vListe.Add('91;?caption?;La section est inexistante !;E;O;O;O;');
 vListe.Add('92;?caption?;La section doit �tre renseign�e ! ;E;O;O;O;') ;
 vListe.Add('93;?caption?;Attention : cette section est ferm�e. Vous ne pouvez plus l''utiliser en saisie;E;O;O;O;');
 vListe.Add('94;?caption?;Cette section est soumise a un mod�le de restriction !;E;O;O;O;');
 vListe.Add('95;?caption?;L''axe de la section n''est pas coh�rente avec l''axe de la ligne;E;O;O;O;');
 vListe.Add('96;?caption?;La somme des ventilations doit �tre �gale � 100% !;E;O;O;O;') ;
 vListe.Add('97;?caption?;Le montant des ventilations n''est pas �gal au montant de la ligne d''�criture !;E;O;O;O;') ;
 vListe.Add('98;?caption?;Le montant en devise des ventilations n''est pas �gal au montant en devise de la ligne d''�criture !;E;O;O;O;') ;
 vListe.Add('99;?caption?;Attention ! Il a �t� relev� une incoh�rence dans les quantit�s saisies ( Quantit� 1 ) !;E;O;O;O;');
 vListe.Add('100;?caption?;Attention ! Il a �t� relev� une incoh�rence dans les quantit�s saisies ( Quantit� 2 ) !;E;O;O;O;');
 vListe.Add('101;?caption?;Votre ligne d''analytique est incorrecte : Aucun pourcentage n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('102;?caption?;Votre ligne d''analytique est incorrecte : Aucun montant n''a �t� saisi ;E;O;O;O;') ;
 vListe.Add('103;?caption?;La ventilation doit comporter au moins une ligne !;E;O;O;O;') ;
 vListe.Add('104;?caption?;Certaines sections sur le compte g�n�ral ne sont pas compatibles avec la d�finition du budget. Confirmez-vous la validation ?;Q;YN;N;N;') ;
 vListe.Add('105;?caption?;Le champs E_ENCAISSEMENT est obligatoire !;E;O;O;O;') ;
 vListe.Add('106;?caption?;La section %s est inconnue !;E;O;O;O;') ;
 vListe.Add('107;?caption?;Saisie multidevise impossible en mode libre;E;O;O;O;') ;
 vListe.Add('108;?caption?;La date d''�ch�ance doit respecter la plage de saisie autoris�e.;E;O;O;O;') ;
 vListe.Add('109;?caption?;Votre saisie comporte plusieurs �tablissements !.;E;O;O;O;') ;
 vListe.Add('110;?caption?;la condition de r�glement du tiers est inconnue !' + '#10#13' +'Veuillez la renseigner dans l''onglet "R�glements" du param�trage du compte auxiliaire.;E;O;O;O;') ;
 vListe.Add('111;?caption?;la date n''est pas modifiable, une �criture de la pi�ce est lettr�e !.;E;O;O;O;') ;
 vListe.Add('112;?caption?;Vous ne pouvez pas saisir sur cette �tablissement !.;E;O;O;O;') ;
 vListe.Add('113;?caption?;Suppression impossible, la pi�ce a �t� modifi�e !.;E;O;O;O;') ;
 vListe.Add('114;?caption?;Impossible d''enregistrer la pi�ce de suppression !.;E;O;O;O;') ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : 
Cr�� le ...... : 29/09/2006
Modifi� le ... :   /  /    
Description .. : LG - 29/09/2006 - le silent Mode ne faisant pas afficher les 
Suite ........ : messages, on ne pouvait plus ferme la saisie bordereau 
Suite ........ : apres avoir ouvert un etat de synthese
Mots clefs ... : 
*****************************************************************}
function CPrintMessageRC(vStTitre : string ; RC_Numero : integer ; vListe : HTStrings) : integer;
var
 lOldSilentMode : boolean ;
begin

 result := 1;

 if vListe = nil then exit ;

 if RC_Numero > vListe.Count then
  begin
   PGIInfo('Le num�ro ' + intToStr(RC_Numero) + ' est inconnu ', vStTitre ) ;
   exit ;
  end; // if

 lOldSilentMode    := V_PGI.SilentMode ;
 V_PGI.SilentMode  := false ;
 result            := HShowMessage(vListe[RC_Numero] , '' , '' ) ;
 V_PGI.SilentMode  := lOldSilentMode ;

end;

function CPrintMessageReC(vStTitre : string ; RC_Error : TRecError ; vListe : HTStrings ) : integer ;
var
 lOldSilentMode : boolean ;
begin
  result := 1;

 if vListe = nil then exit ;

 if RC_Error.RC_Error > vListe.Count then
  begin
   PGIInfo('Le num�ro ' + intToStr(RC_Error.RC_Error) + ' est inconnu ', vStTitre ) ;
   exit ;
  end; // if

 lOldSilentMode    := V_PGI.SilentMode ;
 V_PGI.SilentMode  := false ; 
 result            := HShowMessage(vListe[RC_Error.RC_Error] , '' , RC_Error.RC_Valeur ) ;
 V_PGI.SilentMode  := lOldSilentMode ;

end ;

function CGetMessageRC( RC_Numero : integer ; vListe : HTStrings ) : string ;
var
 lStParam : string ;
 lStTexte : string ;
begin

 if ( RC_Numero > vListe.Count ) or ( RC_Numero < 0 ) then
  begin
   PGIInfo('Le num�ro ' + intToStr(RC_Numero) + ' est inconnu ', 'Attention' ) ;
   exit ;
  end; // if

 lStTexte := vListe[RC_Numero] ;
 lStParam := ReadTokenSt(lStTexte) ;
 result  := ReadTokenSt(lStTexte) ;
 result  := ReadTokenSt(lStTexte) ;

 if ( Valeur(lStParam) <> RC_Numero ) or ( result = '' ) then
  begin
   PGIInfo('Le formatage du message ' + intToStr(RC_Numero) + ' est incorrect ! ', 'Attention' ) ;
   exit ;
  end; // if

end ;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 04/04/2002
Description .. : Solde une piece desequilibre sur le compte d'attente definie
Suite ........ : dans les parametres
Suite ........ : Attention : si le compte d'attente n'existe pas la ligne n'est
Suite ........ : pas generee
Suite ........ : Param :
Suite ........ :  vTOBEcr : TOB des ecritures ( piece ou bordereau)
Suite ........ :  vRdSolde : solde en monnaie de tenue
Suite ........ :  vRdSoldeEuro : solde en contrevaleur
Suite ........ : attention: un solde > 0 (debiteur ) sera affecte au credit de
Suite ........ : la piece
Suite ........ :  vIndex : index de depart dans la TOB ( pour un bordereau )
Suite ........ :  TOBResult : tob contenant les ecritures generees
Suite ........ : rem :
Suite ........ : 1) les soldes sont recalcules tenir compte de la nouvelle
Suite ........ : ligne ajoute
Suite ........ : 2) fonction travaillant de paire avec CCalculSoldePiece
Suite ........ :
Suite ........ : LG - 04-04-2002 - correction de l'equilibrage de la piece
Suite ........ : pour une saisie en contre-valeur
Mots clefs ... :
*****************************************************************}
function CSoldePieceCompteAttente ( vTOBEcr : TOB ; var vRdSolde : double ; vInIndex : integer = 0 ; TOBResult : TOB = nil ) : boolean;
var
 lTOBLigneEcr       : TOB;
 lTOBLastLigneEcr   : TOB;
 lTOBLigneResult    : TOB;
 lInNbFille         : integer;
 lDEV               : RDEVISE;
 lComptes           : TZCompte;
 lIndex             : integer;
 CpteAttente        : string;
begin

 result             := false;
 // precaution
 if vRdSolde = 0 then exit;

 if vInIndex = 0 then
  lInNbFille        := vTOBEcr.Detail.Count - 1
   else
    lInNbFille      := vInIndex;

 lTOBLastLigneEcr   := vTOBEcr.Detail[lInNbFille-1];
 lComptes           := TZCompte.Create();

 CpteAttente        := GetParamSocSecur ('SO_GENATTEND','') ;


 // test l'existence du compte d'attente
 lIndex := lComptes.GetCompte(CpteAttente);
 if lIndex < 0 then begin lComptes.Free ; exit; end;

 lTOBLigneEcr       := TOB.Create('ECRITURE',vTOBEcr,lInNbFille);

  try

      CPutDefautEcr(lTOBLigneEcr);
      CDupliquerTOBEcr(lTOBLastLigneEcr,lTOBLigneEcr);

      if lComptes.IsLettrable(lIndex) then
       CRemplirInfoLettrage(lTOBLastLigneEcr)
        else
         CSupprimerInfoLettrage( lTOBLigneEcr );

      lDEV.Code := lTOBLigneEcr.GetValue( 'E_DEVISE' );
      GETINFOSDEVISE(lDEV);
      lDEV.Taux := GetTaux(lDEV.Code , lDEV.DateTaux, V_PGI.DateEntree) ;

      // on equilibre la piece sur la monnais pivot
      if vRdSolde > 0 then
       CSetMontants(lTOBLigneEcr,0,vRdSolde,lDEV,false)
        else
          CSetMontants(lTOBLigneEcr,-vRdSolde,0,lDEV,false);

      lTOBLigneEcr.PutValue ( 'E_LIBELLE'          , lComptes.GetValue('G_LIBELLE',lIndex) ) ;
      lTOBLigneEcr.PutValue ( 'E_GENERAL'          , CpteAttente ) ;
      lTOBLigneEcr.PutValue ( 'E_CONTREPARTIEGEN'  , '' ) ;
      lTOBLigneEcr.PutValue ( 'E_NUMLIGNE'         , lInNbFille + 2 ) ;

      result := true;
      // ajoute dans TOB Result de la nouvelle ligne d'ecriture
      if assigned(TOBResult) then
       begin
        lTOBLigneResult := TOB.Create('ECRITURE',TOBResult,-1);
        lTOBLigneResult.Dupliquer(lTOBLigneEcr,false,true);
       end; // if

 lComptes.Free ;

 except
  On E:Exception do
   begin
    PGIINfo('Erreur sur la g�n�ration des �critures de r�gularisation' + #10#13 + E.Message , 'Attention !');
    lTOBLigneEcr.Free ; raise ;
   end; //if
 end;

end;

function CCalculClefUniqueInteger ( const StTableName, StFieldName, StCloseWhere : string ) : Integer ;
var
 Q               : TQuery ;
 lInCodeDepart   : integer;
 lInCode         : integer;
begin

 lInCode       := -1;
 Q             := nil;

 try

  Q            := OpenSQL ( 'SELECT ' + StFieldName + ' FROM ' + StTableName + ' WHERE ' + StCloseWhere , True,-1,'',true );

  if not Q.Eof then
   begin

    lInCode       := Q.FindField(StFieldName).AsInteger;
    lInCodeDepart := lInCode;
    ferme ( Q );

     while True do
      begin

       Inc (lInCode);
       // on remet � jour le nouveau numero
       if ExecuteSQL ( 'UPDATE ' + StTableName  + ' SET ' + StFieldName + '=' + intToStr(lInCode)  +
                       ' WHERE ' + StCloseWhere + ' AND ' + StFieldName + '=' + intToStr(lInCodeDepart) ) = 1 then Break ;
      end; // while
   end
    else
     ferme ( Q );

  Q := nil;

  result := lInCode;

 finally
   if assigned(Q) then ferme(Q);
 end; // try

end;


function CCalculProchainNumeroSouche ( const vStTypeSouche, vStCodeSouche : string ) : Integer ;
begin
 result := CCalculClefUniqueInteger('SOUCHE','SH_NUMDEPART','SH_TYPE = "' + vStTypeSouche + '" and SH_SOUCHE = "' + vStCodeSouche + '"');
end;


function CMAJNumeroSouche ( const vStTypeSouche, vStCodeSouche : string ; vNewValue,vOldValue : integer) : boolean;
var
 s  : string;
begin

 s := 'UPDATE SOUCHE SET SH_NUMDEPART ='  + intToStr(vNewValue)      +
      'WHERE SH_TYPE = "' + vStTypeSouche + '" and SH_SOUCHE = "' + vStCodeSouche + '" AND ' +
      'SH_NUMDEPART =' + intToStr(vOldValue);

 // on remet � jour le nouveau numero
 result := ExecuteSQL (s) = 1;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... :   /  /
Description .. : calcul de le solde d'une piece
Suite ........ : Param :
Suite ........ :  vTOBEcr : TOB des ecritures ( piece ou bordereau )
Suite ........ :  vInINdex : index de depart ( pour un bordereau )
Mots clefs ... :
*****************************************************************}
function CCalculSoldePiece ( vTOBEcr : TOB ; vInIndex : integer = 0 ) : RecCalcul;
var
 lStPrefixe       : string;
 lTOBLigneEcr     : TOB;
 i                : integer;
 lvarNumGroupeEcr : variant;
 lBoTableEcr      : boolean;
begin

 result.D   := 0;
 result.C   := 0;
 result.DD  := 0;
 result.CD  := 0;

 if ( not assigned(vTOBEcr) ) or  ( not assigned( vTOBEcr.Detail ) ) or ( vTOBEcr.Detail.Count = 0 ) then exit;

 lStPrefixe  := TableToPrefixe ( vTOBEcr.Detail[0].NomTable );
 lBoTableEcr := lStPrefixe = 'E';

 if lBoTableEcr then
  lvarNumGroupeEcr := vTOBEcr.Detail[vInIndex].GetValue( lStPrefixe + '_NUMGROUPEECR');

 for i := vInIndex to ( vTOBEcr.Detail.Count - 1 ) do
  begin

   lTOBLigneEcr  := vTOBEcr.Detail[i];

   if lBoTableEcr and ( lTOBLigneEcr.GetValue( lStPrefixe + '_NUMGROUPEECR') <> lvarNumGroupeEcr ) then
    begin
      Result.Index        := i;
      exit;
    end; // if

//   if ( lTOBLigneEcr.GetValue( lStPrefixe + '_GENERAL' ) <> VH^.EccEuroDebit ) or
//      ( lTOBLigneEcr.GetValue( lStPrefixe + '_GENERAL' ) <> VH^.EccEuroCredit ) then
//    begin

     result.D    := result.D  + lTOBLigneEcr.GetValue( lStPrefixe + '_DEBIT' );
     result.C    := result.C  + lTOBLigneEcr.GetValue( lStPrefixe + '_CREDIT' );
     result.DD   := result.DD + lTOBLigneEcr.GetValue( lStPrefixe + '_DEBITDEV' );
     result.CD   := result.CD + lTOBLigneEcr.GetValue( lStPrefixe + '_CREDITDEV' );

//    end; // if

  end; // for
 // on renvoie l'incide de fin de la piece pour une prochaine iteration dans celle ci ( pour la fct CEquilibrePiece )
 Result.Index    := vTOBEcr.Detail.Count ;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 12/03/2002
Modifi� le ... : 15/03/2002
Description .. : fonction d' equilibre d'une piece et de geenration des ecartd
Suite ........ : de conversion
Suite ........ : fct pour une piece ou un bordereau.
Suite ........ : rem : si la piece n'est pas equilibre -> generation d'une ligne
Suite ........ : sur le compte d'attente
Mots clefs ... :
*****************************************************************}
function CEquilibrePiece ( vTOBEcr : TOB ; TOBResult : TOB = nil) : boolean;
var
 lTdc           : RecCalcul; // structure de retour de la fonction de calcul du solde
 lRdSolde       : double;    // solde en monnaie de tenue
 lInIndex       : integer;   // index permettant de se deplacer dans la piece
 lBoContinue    : boolean;
 Montant        : double;
 lRdSoldeDevise : double;
 lDEV           : RDEVISE;
 lRdSoldeDev    : double;
begin

 result    := false;
 // controle de la piece pass� en parametre
 if ( not assigned(vTOBEcr) ) or  ( not assigned( vTOBEcr.Detail ) ) or ( vTOBEcr.Detail.Count = 0 ) then exit;

 lInIndex        := 0;
 lBoContinue     := true;

 while lBoContinue do
  begin

   lTDC           := CCalculSoldePiece ( vTOBEcr,lInIndex );

   lRdSolde       := Arrondi ( ( lTDC.D  - lTDC.C )  , V_PGI.OkDecV );
   // ajout me fiche 10361
   lRdSoldeDev    := Arrondi ( ( lTDC.DD  - lTDC.CD )  , V_PGI.OkDecV );

   lDEV.Code := vTOBEcr.detail[vTOBEcr.Detail.Count-1].GetValue( 'E_DEVISE' );

   if ( lRdSolde <> 0 ) then
   begin
       if lDEV.Code = V_PGI.DevisePivot then
       begin
         // la piece n'est pas equilibre on l'equilibre sur le compte d'attente
         lBoContinue := CSoldePieceCompteAttente( vTOBEcr , lRdSolde , lTdc.Index , TOBResult);
         // on incremente Index puisque l'on vient de rajouter une ligne � la piece
         if lBoContinue then Inc(lTdc.Index) ;
       end
       else      //AJOUT ME 16-03-2005 // �quilibre de l'�cart euro sur la derni�re ligne
       begin
          lRdSoldeDevise       := lTDC.D  - lTDC.C ;
          Montant := vTOBEcr.detail[vTOBEcr.Detail.Count-1].GetValue('E_DEBIT') - vTOBEcr.detail[vTOBEcr.Detail.Count-1].GetValue('E_CREDIT');
          lRdSolde  := Montant - lRdSoldeDevise;
          if lRdSolde > 0 then
          begin
               vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_CREDIT', 0);
               vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_DEBIT',  Arrondi (lRdSolde, V_PGI.OkDecV));
          end
          else
          begin
               vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_CREDIT',  Arrondi (lRdSolde*(-1), V_PGI.OkDecV));
               vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_DEBIT', 0);
          end;
       end;
   end
   else
   begin
         if ( lRdSoldeDev <> 0 ) then   // ajout me fiche 10361
         begin
             if lDEV.Code <> V_PGI.DevisePivot then
             begin
                lRdSoldeDevise       := lTDC.DD  - lTDC.CD ;
                Montant := vTOBEcr.detail[vTOBEcr.Detail.Count-1].GetValue('E_DEBITDEV') - vTOBEcr.detail[vTOBEcr.Detail.Count-1].GetValue('E_CREDITDEV');
                lRdSolde  := Montant - lRdSoldeDevise;
                if lRdSolde > 0 then
                begin
                     vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_CREDITDEV', 0);
                     vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_DEBITDEV',  Arrondi (lRdSolde, V_PGI.OkDecV));
                end
                else
                begin
                     vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_CREDITDEV',  Arrondi (lRdSolde*(-1), V_PGI.OkDecV));
                     vTOBEcr.detail[vTOBEcr.Detail.Count-1].PutValue('E_DEBITDEV', 0);
                end;
             end;
         end;
   end;
   // on continue jusqu'a la fin !
   lBoContinue    := lBoContinue and ( lTdc.Index < ( vTOBEcr.Detail.Count - 1 ) );

    // on passe � la piece suivante
   lInIndex        := lTdc.Index;

  end; // while

  result := true;
end;



procedure CSetCotation ( vTOBLigneEcr : TOB ) ;
var
 lRdCote              : double;
 lRdTaux              : double;
 lStDev               : string;
 lDtDateComptable     : TDateTime;
 lStPrefixe           : string;
begin

 if vTOBLigneEcr = nil then exit;

 lStPrefixe       := TableToPrefixe ( vTOBLigneEcr.NomTable );

 lDtDateComptable := vTOBLigneEcr.GetValue( lStPrefixe + '_DATECOMPTABLE');
 lRdTaux          := vTOBLigneEcr.GetValue( lStPrefixe + '_TAUXDEV');

 if lDtDateComptable < V_PGI.DateDebutEuro then
  lRdCote := lRdTaux
   else
    begin
     lStDev := vTOBLigneEcr.GetValue( lStPrefixe + '_DEVISE') ;
     if ( ( lStDev = V_PGI.DevisePivot ) or ( lStDev = V_PGI.DeviseFongible)) then
      lRdCote := 1.0
       else
        if V_PGI.TauxEuro <> 0 then
         lRdCote := lRdTaux / V_PGI.TauxEuro
          else
           lRdCote := 1;
    end ; // if

 vTOBLigneEcr.PutValue( lStPrefixe + '_COTATION',lRdCote) ;

END ;


procedure CSetMontants ( vTOBLigneEcr : TOB ; vRdDebit, vRdCredit : Double; vDev : RDEVISE;  vBoForce : Boolean = true );
var
 lRdOldDebit  : double;
 lRdOldCredit : double;
 lStPrefixe   : string;
begin

 if not assigned(vTOBLigneEcr) then exit ;
 if vDev.Taux = 0 then
  begin
   MessageAlerte('Le taux n''est pas d�finie') ;
   exit ;
  end;

 lStPrefixe := TableToPrefixe ( vTOBLigneEcr.NomTable );

 vRdDebit   := Arrondi(vRdDebit  , vDev.Decimale);
 vRdCredit  := Arrondi(vRdCredit , vDev.Decimale);

 if vDev.Code = V_PGI.DevisePivot then
  begin
   vTOBLigneEcr.PutValue ( lStPrefixe + '_DEBIT'      , vRdDebit  ) ;
   vTOBLigneEcr.PutValue ( lStPrefixe + '_CREDIT'     , vRdCredit ) ;
   vTOBLigneEcr.PutValue ( lStPrefixe + '_DEBITDEV'   , vRdDebit  );
   vTOBLigneEcr.PutValue ( lStPrefixe + '_CREDITDEV'  , vRdCredit ) ;
  end // else Compta tenue en Euro
  else
    begin
     {Saisie en Devise}
     lRdOldDebit  := vTOBLigneEcr.GetValue ( lStPrefixe + '_DEBITDEV' ) ;
     lRdOldCredit := vTOBLigneEcr.GetValue ( lStPrefixe + '_CREDITDEV' ) ;

     if ( ( lRdOldDebit = vRdDebit ) and ( lRdOldCredit = vRdCredit ) and ( not vBoForce ) ) then
      Exit;

     vTOBLigneEcr.PutValue ( lStPrefixe + '_DEBIT'      , DeviseToEuro ( vRdDebit  , vDEV.Taux , vDEV.Quotite ) ) ;
     vTOBLigneEcr.PutValue ( lStPrefixe + '_CREDIT'     , DeviseToEuro ( vRdCredit , vDEV.Taux , vDEV.Quotite ) ) ;
     vTOBLigneEcr.PutValue ( lStPrefixe + '_DEBITDEV'   , vRdDebit ) ;
     vTOBLigneEcr.PutValue ( lStPrefixe + '_CREDITDEV'  , vRdCredit ) ;

  end ;

 vTOBLigneEcr.PutValue ( lStPrefixe + '_DEVISE'     , vDev.Code ) ;
 vTOBLigneEcr.PutValue ( lStPrefixe + '_TAUXDEV'    , vDev.Taux ) ;

 // pour la table analytiq le champ cotation n'est pas d�finie
 if vTOBLigneEcr.GetNumChamp( lStPrefixe + '_COTATION' ) <> -1 then
  CSetCotation ( vTOBLigneEcr );

  // pour la table analytiq le champ cotation n'est pas d�finie
 if vTOBLigneEcr.GetNumChamp( lStPrefixe + '_ENCAISSEMENT' ) <> -1 then
   vTOBLigneEcr.PutValue ( lStPrefixe + '_ENCAISSEMENT' ,SENSENC ( vRdDebit,vRdCredit) ) ;

end;



procedure CSetPeriode  ( vTOBLigneEcr : TOB );
var
 lStPrefixe : string;
begin

 lStPrefixe := TableToPrefixe ( vTOBLigneEcr.NomTable );

 if not assigned(vTOBLigneEcr) then exit ;

 vTOBLigneEcr.PutValue( lStPrefixe + '_PERIODE' , GetPeriode( vTOBLigneEcr.getValue( lStPrefixe + '_DATECOMPTABLE' ) ) );
 vTOBLigneEcr.PutValue( lStPrefixe + '_SEMAINE' , NumSemaine( vTOBLigneEcr.getValue( lStPrefixe + '_DATECOMPTABLE' ) ) );

end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 15/03/2002
Description .. : fct de recherche des comptes de contrepartie gen et aux
Suite ........ : param :
Suite ........ :  vTOBEcr : piece
Suite ........ :  vInIndex  : indice de la ligne a traiter
Suite ........ :  vBoJalEffet : true si journal effet ( J_EFFET='X' )
Suite ........ :  vBoJalEffet : true si journal bqe ( J_NATUREJAL='BQE'
Suite ........ :                       ou J_NATUREJAL='CAI' )
Suite ........ :  vStCptContreP : compte de contrepartie du journal de  bqe
Suite ........ :  vcompte : objet ZCompte
Mots clefs ... :
*****************************************************************}
function CGetCptsContreP( vTOBEcr : TOB ; vInIndex : integer ; vBoJalBqe,vBoJalEffet : boolean ; lStCptContreP : string ; vCompte : TZCompte ; Parle : boolean = true) : boolean ;
var
 lInNumGroupeEcr  : integer;
 lTOBLigneEcr     : TOB;
 lTOBLigneRef     : TOB;
 lInIndex         : integer;
 i                : integer;
 lInPos           : integer ;
 lInMax           : integer ;
 lInMin           : integer ;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent gendreau
Cr�� le ...... : 22/02/2007
Modifi� le ... :   /  /    
Description .. : - LG - 22/02/2007 - on ne limite plus le nbr de boucle en 
Suite ........ : mode piece
Mots clefs ... : 
*****************************************************************}
 function PosCompte : integer;
 var
  lStCompte       : string;
 begin
  lStCompte    := lTOBLigneEcr.GetValue('E_GENERAL');
  result       := vCompte.GetCompte(lStCompte);
  if result = - 1 then
   begin
    if Parle then
     MessageAlerte('Le compte de contrepartie ' + lStCompte + ' est inconnu !' + #10#13 +'V�rifiez le param�trage soci�t�');
    exit;
   end;
 end;

begin

 result := false ;

 if not assigned(vTOBEcr) then exit;

 lTOBLigneRef    := vTOBEcr.Detail[vInIndex];

 if ( lTOBLigneRef.GetString('E_MODESAISIE') = '' ) or ( lTOBLigneRef.GetString('E_MODESAISIE') = '-' ) then
  begin // en mode piece on ne bloque pas le nbr de boucle ( on triate toutes la piece )
   lInMin := 0 ;
   lInMax := vTOBEcr.Detail.Count - 1 ;
  end
   else
    begin
     lInMax := vInIndex + 4 ;
     if lInMax > vTOBEcr.Detail.Count - 1 then lInMax := vTOBEcr.Detail.Count - 1 ;
     lInMin := vInIndex - 4 ;
     if lInMin < 0 then lInMin := 0 ;
    end ;

 lInNumGroupeEcr := lTOBLigneRef.GetValue('E_NUMGROUPEECR');
 lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , '');
 lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , '');

 if vBoJalBqe or vBoJalEffet then
  begin
  // piece de banque
   if lTOBLigneRef.GetValue('E_GENERAL') = lStCptContreP then
    begin
    // sur compte de banque, contrepartie= premier compte non banque au dessus
     for i := ( vInIndex - 1 ) downto lInMin do
      begin
       lTOBLigneEcr  := vTOBEcr.Detail[i];
       if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
       if (lTOBLigneEcr.GetValue('E_GENERAL') <> lStCptContreP) then
        begin
         lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL') );
         CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
//         if vBoJalEffet then // SBO 22/01/2007 : il faut aussi renseigner la contrepartieaux sur les journaux de banque !
//          begin
           lTOBLigneRef.PutValue('E_CONTREPARTIEAUX'  , vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE') );
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE') , true ) ;
//          end ;
         result := true ;
         exit;
        end; // if
      end; // for
    end // if
     else
      begin
      // sur compte non banque, contrepartie = premier compte banque en dessous
      lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , lStCptContreP);
       for i := ( vInIndex + 1 ) to lInMax do
        begin
         lTOBLigneEcr  := vTOBEcr.Detail[i];
         if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
         if (lTOBLigneEcr.GetValue('E_GENERAL') = lStCptContreP) then
          begin
           lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL'));
           lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE'));
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE') , true ) ;
           result := true ;
           exit;
          end; // if
        end; // for
      end;
  end // if vBoJalBqe or vBoJalEffet
   else
   // journal non banque
    begin
     lTOBLigneEcr := vTOBEcr.Detail[vInIndex] ;
     if vCompte.iSTiers( PosCompte ) or ( Length( lTOBLigneEcr.GetString('E_AUXILIAIRE') ) = GetInfoCpta( fbAux ).Lg ) then
      begin
      // lecture avant pout trouver le HT
       for i := ( vInIndex + 1 ) to lInMax do
        begin
         lTOBLigneEcr := vTOBEcr.Detail[i];
         if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
         if vCompte.iSHT(PosCompte) then
          begin
           lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , lTOBLigneEcr.GetValue('E_GENERAL'));
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', lTOBLigneEcr.GetValue('E_GENERAL') , true ) ;
           result := true ;
           exit;
          end; // if
        end; // for
       if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') = '' then
        begin
         // lecture arriere pour trouver le HT
         for i := ( vInIndex - 1 ) downto lInMin do
          begin
           lTOBLigneEcr := vTOBEcr.Detail[i];
           if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
           if vCompte.iSHT(PosCompte) then
            begin
             lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , lTOBLigneEcr.GetValue('E_GENERAL'));
             CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', lTOBLigneEcr.GetValue('E_GENERAL') , true ) ;
             result := true ;
             exit;
            end; // if
          end; // for
        end; // if
      end // if tiers
       else
        begin
         // lecture arriere pour trouver le tiers
         for i := ( vInIndex - 1 ) downto lInMin do
          begin
           lTOBLigneEcr := vTOBEcr.Detail[i];
           if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
           lInPos := PosCompte ;  if lInPos = - 1 then exit ;
           if ( Length( lTOBLigneEcr.GetString('E_AUXILIAIRE') ) = GetInfoCpta( fbAux ).Lg )
              or ( (lInPos <> -1) and vCompte.isTiers(lInPos) ) then
            begin
             lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , lTOBLigneEcr.GetValue('E_GENERAL'));
             lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , lTOBLigneEcr.GetValue('E_AUXILIAIRE'));
             CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', lTOBLigneEcr.GetValue('E_GENERAL') , true ) ;
             CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', lTOBLigneEcr.GetValue('E_AUXILIAIRE') , true ) ;
             result := true ;
             exit;
            end; // if
          end; // for
           if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') = '' then
            begin
             // lecture avant pour trouver le tiers
             for i := ( vInIndex + 1 ) to lInMax do
              begin
               lTOBLigneEcr := vTOBEcr.Detail[i];
               if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break;
               lInPos := PosCompte ;  if lInPos = - 1 then exit ;
               if ( Length( lTOBLigneEcr.GetString('E_AUXILIAIRE') ) = GetInfoCpta( fbAux ).Lg )
                  or ( (lInPos <> -1) and vCompte.isTiers(lInPos) ) then
                begin
                 lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , lTOBLigneEcr.GetValue('E_GENERAL'));
                 lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , lTOBLigneEcr.GetValue('E_AUXILIAIRE'));
                 CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', lTOBLigneEcr.GetValue('E_GENERAL') , true ) ;
                 CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', lTOBLigneEcr.GetValue('E_AUXILIAIRE') , true ) ;
                 result := true ;
                 exit;
                end; // if
              end; // for
            end; // if
        end;
    end; // journal non banque

 // cas particulier
 if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') <> '' then
  begin
   result := true ;
   exit;
  end ;

 lTOBLigneEcr := vTOBEcr.Detail[vInIndex];

 if not vCompte.IsBqe(PosCompte) then
  begin
   for i := ( vInIndex + 1 ) to lInMax do
    begin
     lTOBLigneEcr := vTOBEcr.Detail[i];
     if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break; //exit ;
     if vCompte.isBqe(PosCompte) then
      begin
       lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL'));
       CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
       result := true ;
       exit;
      end; // if
    end; // for
   if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') =  '' then
    begin
     for i := ( vInIndex - 1 ) downto lInMin do
      begin
       lTOBLigneEcr := vTOBEcr.Detail[i];
       if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break; //exit ;
       if vCompte.isBqe(PosCompte) then
        begin
         lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL'));
         CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
         result := true ;
         exit;
        end; // if
      end; // for
    end; // if Gene=''
  end // if not Comptes.IsBqe(lInNumCompte)
   else
    begin
     for i := ( vInIndex - 1 ) downto lInMin do
      begin
       lTOBLigneEcr := vTOBEcr.Detail[i];
       if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break; //exit ;
       if ( Length( lTOBLigneEcr.GetString('E_AUXILIAIRE') ) = GetInfoCpta( fbAux ).Lg )
          or vCompte.isTiers(PosCompte) then
//       if ( lTOBLigneEcr.GetValue('E_AUXILIAIRE') <> ' ' ) or vCompte.isTiers(PosCompte) then
        begin
         lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL'));
         lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE'));
         CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
         CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE') , true ) ;
         result := true ;
         exit;
        end; // if
      end; // for
     if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') = '' then
      begin
       for i := ( vInIndex + 1 ) to vTOBEcr.Detail.Count - 1 do
        begin
         lTOBLigneEcr := vTOBEcr.Detail[i];
         if lTOBLigneEcr.GetValue('E_NUMGROUPEECR') <> lInNumGroupeEcr then break; //exit ;
         if vCompte.isTiers(PosCompte) then
          begin
           lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[i].GetValue('E_GENERAL'));
           lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE'));
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[i].GetValue('E_GENERAL') , true ) ;
           CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', vTOBEcr.Detail[i].GetValue('E_AUXILIAIRE') , true ) ;
           result := true ;
           exit;
          end; // if
        end; // for
      end; // if
    end;

  result := true ;
  // si rien trouve, swaper les lignes 1 et 2
  if lTOBLigneRef.GetValue('E_CONTREPARTIEGEN') <> '' then exit;

  lInIndex := -1 ;

  if ( vInIndex > 0 ) and ( vTOBEcr.Detail[vInIndex-1].GetValue('E_NUMGROUPEECR') =lInNumGroupeEcr ) then
   lInIndex := vInIndex - 1
    else
     if ( ( vInIndex + 1 ) <= ( vTOBEcr.Detail.count - 1 ) ) and ( vTOBEcr.Detail[vInIndex+1].GetValue('E_NUMGROUPEECR') =lInNumGroupeEcr ) then
      lInIndex := vInIndex + 1 ;

  if lInIndex <> - 1 then
   begin
    lTOBLigneRef.PutValue('E_CONTREPARTIEGEN' , vTOBEcr.Detail[lInIndex].GetValue('E_GENERAL'));
    lTOBLigneRef.PutValue('E_CONTREPARTIEAUX' , vTOBEcr.Detail[lInIndex].GetValue('E_AUXILIAIRE'));
    CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEGEN', vTOBEcr.Detail[lInIndex].GetValue('E_GENERAL') , true ) ;
    CReporteVentil(lTOBLigneRef,'E_CONTREPARTIEAUX', vTOBEcr.Detail[lInIndex].GetValue('E_AUXILIAIRE') , true ) ;
   end; // if

end;

procedure CAffectRegimeTva( vTOBEcr : TOB ) ;
var
 i            : integer ;
 lStRegimeTva : string ;
begin

 if not assigned(vTOBEcr) then exit ;
 lStRegimeTva := '' ;
 i            := vTOBEcr.Detail.Count - 1 ;

 while ( lStRegimeTva = '' ) and ( i > - 1) do
  begin
   lStRegimeTva := vTOBEcr.Detail[i].GetValue('E_REGIMETVA') ;
   dec(i) ;
  end; // while

 if lStRegimeTva <> '' then
  for i := 0 to vTOBEcr.Detail.Count - 1 do
   vTOBEcr.Detail[i].PutValue('E_REGIMETVA',lStRegimeTva) ;

end;



{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 19/07/2002
Description .. : Fct de gen�ration des comptes de contrepartie generaux et
Suite ........ : auxiliaires
Suite ........ :
Suite ........ : - 18/07/2002 - ajout d'un TInfoEcriture pour eviter des
Suite ........ : requetes en base
Mots clefs ... :
*****************************************************************}
function CAffectCompteContrePartie ( vTOBEcr : TOB ; vInfo : TInfoEcriture = nil ) : boolean;
var
 i                    : integer;
 lCompte              : TZCompte;
 lBoJalEffet          : boolean;
 lBoJalBqe            : boolean;
 lStNatJal            : string;
 lStCptContreP        : string;
 lQ                   : TQuery;
 lBoCreateCompte      : boolean ;
begin

 result               := true;
 if vTOBEcr.Detail.Count > 1000 then exit ;
 lBoCreateCompte      := false ;

 if ( not assigned(vTOBEcr) ) or  ( not assigned( vTOBEcr.Detail ) ) or ( vTOBEcr.Detail.Count = 0 ) then exit;

 if vInfo = nil then
  begin
   // recherche des info de parametrage du journal
   lQ := OpenSQL('select J_CONTREPARTIE,J_NATUREJAL,J_EFFET from JOURNAL where J_JOURNAL="' + vTOBEcr.Detail[0].GetValue('E_JOURNAL') + '"' ,true,-1,'',true);

   lStNatJal         := lQ.FindField('J_NATUREJAL').asString;
   lBoJalBqe         := ( lQ.FindField('J_NATUREJAL').asString = 'BQE' ) or ( lQ.FindField('J_NATUREJAL').asString = 'CAI' );
   lBoJalEffet       := lQ.FindField('J_EFFET').asString = 'X';
   lStCptContreP     := lQ.FindField('J_CONTREPARTIE').asString;
   lCompte           := TZCompte.Create();
   lBoCreateCompte   := true ;
   Ferme(lQ);
  end
   else
    begin
     lCompte         := vInfo.Compte ;
     vInfo.Journal.Load( [vTOBEcr.Detail[0].GetValue('E_JOURNAL')] ) ;
     lStNatJal       := vInfo.GetString('J_NATUREJAL') ;
     lBoJalBqe       := ( vInfo.GetString('J_NATUREJAL') = 'BQE' ) or ( vInfo.GetString('J_NATUREJAL') = 'CAI' );
     lBoJalEffet     := vInfo.GetString('J_EFFET') = 'X' ;
     lStCptContreP   := vInfo.GetString('J_CONTREPARTIE') ;
    end; // if

 result      := false;

 try

  for i:= 0 to vTOBEcr.Detail.Count - 1 do
   if not CGetCptsContreP( vTOBEcr , i , lBoJalBqe,lBoJalEffet, lStCptContreP,lCompte) then break ;

 finally
  if lBoCreateCompte and assigned(lCompte) then lCompte.Free;
 end;

end;

function _IsRowTiers( vTOBEcr : TOB ; vInfo : TInfoEcriture ) : Boolean ;
begin
 //result := false ;
 vInfo.LoadCompte(vTOBEcr.GetString('E_GENERAL')) ;
 result := ( trim(vTOBEcr.GetString('E_AUXILIAIRE')) <> '' ) or ( ( vInfo.Compte.InIndex > -1 ) and vInfo.Compte.IsTiers ) ;
end ;

function CGetRowTiers( vTOBEcr : TOB ; vIndex : integer ; vInfo : TInfoEcriture ) : integer ;
var
 i              : integer ;
 lInNumeroPiece : integer ;
begin

 result         := -1 ;
 lInNumeroPiece := vTOBEcr.Detail[vIndex].getValue('E_NUMEROPIECE') ;

 for i := vIndex downto 0 do
  begin
   if vTOBEcr.Detail[i].getValue('E_NUMEROPIECE') <> lInNumeroPiece then Break ;
   if _IsRowTiers(vTOBEcr.Detail[i],vInfo) then
    begin
     result := i ;
     exit ;
    end ; // if
  end ; // for

 for i:= vIndex to vTOBEcr.Detail.Count - 1 do
  begin
   if vTOBEcr.Detail[i].getValue('E_NUMEROPIECE') <> lInNumeroPiece then Break ;
   if _IsRowTiers(vTOBEcr.Detail[i],vInfo) then
    begin
     result := i ;
     exit ;
    end ; // if
  end ; // for

end ;

{***********A.G.L.*****************************************
Auteur  ...... : M.ENTRESSANGLE
Cr�� le ...... : 29/11/2001
Modifi� le ... :   /  /
Description .. : Fonction de la lecture d'une balance pour un compte donn�
Suite ........ : Exo                    :  Exercice comptable
Suite ........ : Compte                 :  Pr�cision du compte
Suite ........ : Dateecr1, Dateecr2     :  Date d�but et fin de s�l�ction
Suite ........ : Mttdeb, Mttcre         :  Les montants d�biteurs et cr�diteurs
Suite ........ : MttSolde               :  solde de la balance
Suite ........ : Anouveau               :  'O' uniquement les anouveaux
Suite ........ :                           'N' sans les anouveaux
Suite ........ :                           ' ' balance comptable + anouveaux
Suite ........ : Auxi                   :  TRUE si Compte=auxiliaire
Mots clefs ... :
*****************************************************************}
Function CGetBalanceParcompte (Exo,Compte : string; Dateecr1,Dateecr2 : TDateTime ; var MttDeb,MttCre,MttSolde : double; Anouveau : string=''; Auxi : Boolean=FALSE) : Boolean;
var
Q1               : TQuery;
Sql              : string;
Condition      : string;
begin
           Result := FALSE;
           Condition := '';

           if Exo <> '' then
            Condition := ' AND E_EXERCICE="'+Exo+'" ';

           if Auxi  then Condition := Condition + ' AND E_AUXILIAIRE="'+ Compte + '" '
           else
           Condition := Condition + ' AND E_GENERAL="'+Compte+'" AND E_AUXILIAIRE<>"." ';

           if Anouveau = 'O' then  Condition := Condition + 'AND E_ECRANOUVEAU="H" or E_ECRANOUVEAU="OAN" ';
           if Anouveau = 'N' then  Condition := Condition + 'AND E_ECRANOUVEAU="N" ';

           Sql := 'SELECT sum(E_DEBIT) as TOTDEBIT, sum(E_CREDIT) as TOTCREDIT FROM ECRITURE ' +
           'WHERE E_DATECOMPTABLE>="'+USDateTime(Dateecr1)+'" AND E_DATECOMPTABLE<="'+USDateTime(Dateecr2) +
           '" AND (E_QUALIFPIECE="N" ) '+ Condition;

           Q1 := OpenSql (Sql, TRUE,-1,'',true);
           if not Q1.EOF then
           begin
               MttDeb    := Q1.FindField ('TOTDEBIT').asFloat;
               MttCre    := Q1.FindField ('TOTCREDIT').asFloat;
               MttSolde  := MttDeb-MttCre;
               Result    := TRUE;
           end;
           Ferme (Q1);
end;

function EncodeKeyBordereau( vDtDateComptable : TDateTime ; vStJournal : string ; vInNumeroPiece : integer ) : string;
var
 lYear, lMonth, lDay : Word;
begin
 DecodeDate(vDtDateComptable,lYear,lMonth,lDay);
 result := DateToStr(EncodeDate(lYear, lMonth, 1)) + ';' + vStJournal + ';' + intToStr(vInNumeroPiece) + ';';
end;

function CBloqueurBor(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Bloc : boolean ; Parle : boolean = true) : boolean;
var
 lStSql : string;
begin
 result := false;
 if Bloc then
  begin
   lStSql := 'insert into courrier(mg_utilisateur,mg_combo,mg_type,mg_dejalu,mg_date,mg_averti,mg_expediteur) ' +
             'values("' + W_W + '","' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '",2000,"-","' +
             USTime(iDate1900) + '","-","' + V_PGI.User + '")';
   try
    ExecuteSQL(lStSQL);
    result := true ;
   except
    on E : Exception do
     begin
      if Parle then MessageAlerte('Bordereau bloqu�' + #10#13#10#13 + E.Message);
     end;
   end; // try
  end // if
   else
    begin
      lStSql := 'delete from courrier ' +
                'where mg_utilisateur = "' + W_W + '" and mg_type=2000 and mg_expediteur = "' + V_PGI.User + '"' +
                ' and mg_combo="' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '" ';
      ExecuteSQL(lStSQL);
      result := true ;
    end; // if
end;


function CEstBloqueJournal( vStJournal : string ; Parle : boolean = true ) : boolean;
var
 lStSql,lStUser : string;
 lQ             : TQuery;
begin
 lStSql := 'select US_LIBELLE from COURRIER,UTILISAT ' +
           ' where MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=5000 AND MG_COMBO="' + vStJournal + '"' +
           ' and US_UTILISATEUR=MG_EXPEDITEUR ' ; //AND MG_EXPEDITEUR<>"' + V_PGI.User + '" ' ;
 lQ     := OpenSql(lStSql,true,-1,'',true);
 result := not lQ.EOF;
 if result then lStUser:=lQ.FindField('US_LIBELLE').AsString;
 Ferme(lQ);
{$IFNDEF EAGLSERVER}
 if ( lStUser <> '' ) and  Parle then MessageAlerte('Bordereau bloqu� par ' + lStUser);
{$ELSE}
 cWA.MessagesAuClient('COMSX.IMPORT','','Bordereau bloqu� par ' + lStUser) ;
{$ENDIF}
end;


function CBloqueurJournal( Bloc : boolean ; vStJournal : string = '' ; Parle : boolean = true ) : boolean ;
var
 lStSql : string;
begin
 result := false;
 if Bloc then
  begin
   if vStJournal = '' then exit ;
   lStSql := 'insert into courrier(mg_utilisateur,mg_combo,mg_type,mg_dejalu,mg_date,mg_averti,mg_expediteur) ' +
             'values("' + W_W + '","' + vStJournal + '",5000,"-","' +
             USTime(iDate1900) + '","-","' + V_PGI.User + '")';
   try
    ExecuteSQL(lStSQL);
    result := true ;
   except
    on E : Exception do
     begin
      {$IFNDEF EAGLSERVER}
       if Parle then MessageAlerte('Bordereau bloqu�' + #10#13#10#13 + E.Message);
      {$ELSE}
      cWA.MessagesAuClient('COMSX.IMPORT','','Bordereau bloqu�' + #10#13#10#13 + E.Message) ;
      {$ENDIF}
     end;
   end; // try
  end // if
   else
    begin
      lStSql := 'delete from courrier ' +
                'where mg_utilisateur = "' + W_W + '" and mg_type=5000 and mg_expediteur = "' + V_PGI.User + '"' ;
      if vStJournal <> '' then
       lStSql := lStSql + ' and mg_combo="' + vStJournal + '" ' ;
      ExecuteSQL(lStSQL);
      result := true ;
    end; // if
end;


function CEstBloqueBor( vStJournal : string = '' ; vDtDateComptable : TDateTime = -1 ; vInNumeroPiece : integer = -1 ; Parle : boolean = true ) : boolean;
var
 lStSql,lStUser : string;
 lQ             : TQuery;
begin
 if vStJournal = '' then
  lStSql := 'select US_LIBELLE from COURRIER,UTILISAT ' +
            ' where MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=2000 ' +
            ' and US_UTILISATEUR=MG_EXPEDITEUR'
  else
   lStSql := 'select US_LIBELLE from COURRIER,UTILISAT ' +
             ' where MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=2000 AND MG_COMBO="' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '"' +
             ' and US_UTILISATEUR=MG_EXPEDITEUR';
 lQ     := OpenSql(lStSql,true,-1,'',true);
 result := not lQ.EOF;
 if result then lStUser:=lQ.FindField('US_LIBELLE').AsString;
 Ferme(lQ);
 if ( lStUser <> '' ) and  Parle then MessageAlerte('Bordereau bloqu� par ' + lStUser);
end;

function CEstSaisieOuverte( Parle : boolean = false) : boolean;
var
 lStSQL : string;
begin
 {$IFDEF EAGLSERVER}
   lStSql := 'select MG_COMBO from COURRIER where MG_UTILISATEUR="' + W_W + '" and MG_EXPEDITEUR="' + V_PGI.User + '" ' +
             ' and MG_TYPE=2000 ' ;
 {$ELSE  EAGLSERVER}
   lStSql := 'select MG_COMBO from COURRIER where MG_UTILISATEUR="' + W_W + '" and MG_EXPEDITEUR="' + V_PGI.FUser + '" ' +
             ' and MG_TYPE=2000 ' ;
 {$ENDIF EAGLSERVER}
 result  := ExisteSQL(lStSql);
 if result and Parle then
  PGIInfo('Une saisie est ouverte, vous ne pouvez pas utiliser cette fonction !');
end;


function CBlocageBor(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean;
begin
 result := false;
 if not CEstBloqueBor(vStJournal,vDtDateComptable,vInNumeroPiece,Parle) then
  begin
   result := CBloqueurBor(vStJournal,vDtDateComptable,vInNumeroPiece,true,Parle);
  end;
end;

procedure CAfficheLigneEcrEnErreur( O : TOB );
begin
 PGIInfo('La ligne : '+#10#13+
 'Exercice : '+O.GetValue('E_EXERCICE')+' journal : '+ O.GetValue('E_JOURNAL')+#10#13+
 'Bordereau n� '+intToStr(O.GetValue('E_NUMEROPIECE'))+' du '+ DateToStr(O.GetValue('E_DATECOMPTABLE'))+' libell� '+ O.GetValue('E_LIBELLE')+
 ' d�bit : '+StrS0(O.GetValue('E_DEBIT'))+' cr�dit : '+StrS0(O.GetValue('E_CREDIT'))+#10#13+' n''a pas �tre mise � jour ! ','Erreur dans l''�criture');
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 22/03/2005
Modifi� le ... :   /  /    
Description .. : - LG - 22/03/2005 - ajout d'un test sur mg_expediteur pour 
Suite ........ : ne pas ce bloque sois meme
Mots clefs ... :
*****************************************************************}
function CGetListeBordereauBloque : TOB ;
var
 lQ : TQuery ;
begin
 result := TOB.Create('',nil,-1) ; lQ:=nil ;
 try
  lQ := OpenSql('SELECT  * FROM COURRIER WHERE MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=2000 AND MG_EXPEDITEUR<>"' + V_PGI.User+'" ',true,-1,'',true) ;
  result.LoadDetailDB('COURRIER','','',lQ,true) ;
 finally
  Ferme(lQ) ;
 end; // try
end;

function CEstBloqueEcritureBor ( vEcr : TOB ; vListeBor : TOB = nil ) : boolean ;
var
 lBoDetruireListeBor : boolean ;
 lStKey              : string ;
 i                   : integer ;
begin

 result := false;

 if vEcr.NomTable <> 'ECRITURE' then
  begin
   MessageAlerte('Fonction CEstBloqueEcriture : la TOB n''est pas bas� sur la table ecriture ! ');
   exit;
  end; // if

 if vEcr = nil then
  begin
   MessageAlerte('Fonction CEstBloqueEcriture : vEcr = nil');
   exit;
  end; // if

 if (trim(vEcr.GetValue('E_DATECOMPTABLE')) = '' ) then
  begin
   MessageAlerte('fonction CEstBloqueEcritureBor : E_DATECOMPTABLE est vide') ;
   exit;
  end; // if


 if (vEcr.GetValue('E_MODESAISIE') = '-' ) or (vEcr.GetValue('E_MODESAISIE') = '' ) then exit ;

 if vListeBor = nil then
  begin
   vListeBor            := CGetListeBordereauBloque ;
   lBoDetruireListeBor  := true ;
  end
   else
    lBoDetruireListeBor := false ;

 try
  lStKey := EncodeKeyBordereau( vEcr.GetValue('E_DATECOMPTABLE'),
                                vEcr.GetValue('E_JOURNAL'),
                                vEcr.GetValue('E_NUMEROPIECE') ) ;

  for i := 0 to vListeBor.Detail.Count - 1 do
   begin
    result     := vListeBor.Detail[i].GetValue('MG_COMBO') = lStKey ;
    if result then exit ;
   end; // for

 finally
  if lBoDetruireListeBor then vListeBor.Free ;
 end;

end;

{$IFNDEF EAGLSERVER}
function CControleLigneBor( G : THGrid ; vListeBor : TOB = nil )  : boolean ;
var
 i : integer ;
 O : TOBM ;
begin
 result :=  true ;
 G.BeginUpdate ;
 try
 for i:=1 to G.RowCount-1 do
  begin
   O:=GetO(G,i) ; if O=nil then continue ;
   if CEstBloqueEcritureBor(TOB(O),vListeBor) then
    begin
     G.Row:=i ; G.EndUpdate ;
     //caption:=AttribTitre + ' : ligne modifi� dans le folio n�' + intToStr(O.GetValue('E_NUMEROPIECE')) + ' du ' + dateToStr(O.GetValue('E_DATECOMPTABLE')) + ' pour le journal ' + O.GetValue('E_JOURNAL') ;
     if PGIAsk('La ligne d''�criture est en cours de modification' + #10#13 + 'Voulez-vous quand m�me enregistrer ?')<>idYes then
      begin
        result:= false ; exit ;
      end
       else exit ;
    end
     else O.PutMvt('E_CONTROLEUR','') ;
 end; // for
 finally
  G.EndUpdate ;
 end ;
end;

function CIsRowLock(G : THGrid ; Lig : integer = - 1) : boolean ;
var
 O : TOBM ;
begin
 result:=false ; if Lig=-1 then Lig:=G.Row ;
 O:=GetO(G,Lig) ; if O=Nil then exit ;
 result:=O.GetString('E_CONTROLEUR')='X' ;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 16/01/2004
Description .. : Remise � zero des info de lettrage
Suite ........ :
Suite ........ : -LG-24/09/2002- suppression de la remise � zero des
Suite ........ : champs de pointage
Suite ........ : -LG-21/10/2002- suppression de le remise � z�ro du
Suite ........ : champs e_modepaie
Suite ........ : -20/11/2002- plus re emise � zero de la reference de
Suite ........ : pointage
Suite ........ : - 16/01/2001 - LG - suppression de la remise a zero de la
Suite ........ : date d'echeance
Mots clefs ... :
*****************************************************************}
procedure CSupprimerInfoLettrage( vTOBLigneEcr : TOB );
begin
  vTOBLigneEcr.PutValue('E_LETTRAGE'          , '');
  vTOBLigneEcr.PutValue('E_LETTRAGEDEV'       , '-');
  vTOBLigneEcr.PutValue('E_ECHE'              , '-');
  vTOBLigneEcr.PutValue('E_ETATLETTRAGE'      , 'RI');
//  vTOBLigneEcr.PutValue('E_DATEPOINTAGE'      , iDate1900);
  vTOBLigneEcr.PutValue('E_DATEECHEANCE'      , iDate1900);
  vTOBLigneEcr.PutValue('E_COUVERTURE'        , 0);
  vTOBLigneEcr.PutValue('E_COUVERTUREDEV'     , 0);
  vTOBLigneEcr.PutValue('E_DATEPAQUETMAX'     , iDate1900);
  vTOBLigneEcr.PutValue('E_DATEPAQUETMIN'     , iDate1900);
  vTOBLigneEcr.PutValue('E_NUMECHE'           , 0);
  vTOBLigneEcr.PutValue('E_MODEPAIE'          , '');
  vTOBLigneEcr.PutValue('E_ENCAISSEMENT'      , 'RIE');
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 26/04/2005
Description .. : Affectation des valeurs par d�fauts pour un compte lettrable
Suite ........ : - LG - 20/03/2003 - correction sur le numero d'echeance
Suite ........ : - lg - 24/08/2004 - ajout de la date de valeur
Suite ........ : - FB 15668 - 26/04/2005 - suppression de la remise a zero 
Suite ........ : des info de pointage, faissait plant� le letrte sur journal
Mots clefs ... : 
*****************************************************************}
procedure CRemplirInfoLettrage( vTOBLigneEcr : TOB );
begin
 vTOBLigneEcr.PutValue('E_LETTRAGE'          , '');
 vTOBLigneEcr.PutValue('E_LETTRAGEDEV'       , '-');
 vTOBLigneEcr.PutValue('E_ECHE'              , 'X');
// vTOBLigneEcr.PutValue('E_REFPOINTAGE'       , '');
 vTOBLigneEcr.PutValue('E_ETATLETTRAGE'      , 'AL');
// vTOBLigneEcr.PutValue('E_DATEPOINTAGE'      , iDate1900);
 vTOBLigneEcr.PutValue('E_COUVERTURE'        , 0);
 vTOBLigneEcr.PutValue('E_COUVERTUREDEV'     , 0);
 vTOBLigneEcr.PutValue('E_DATEPAQUETMAX'     , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_DATEPAQUETMIN'     , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_DATEECHEANCE'      , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_DATEVALEUR'        , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 if vTOBLigneEcr.GetValue('E_NUMECHE') = 0 then
   vTOBLigneEcr.PutValue('E_NUMECHE'          , 1);
{$IFNDEF TRESO}
 {JP 27/09/04 : FQ TRESO 10115 : On passe E_TRESOSYNCHRO des �critures lettrables � CRE
                IFNDEF TRESO, car toutes les �critures g�n�r�es en Tr�sorerie sont consid�r�es
                � RIE car il est inutile de les synchroniser}
 vTOBLigneEcr.PutValue('E_TRESOSYNCHRO'      , 'CRE');
{$ENDIF}
end;

procedure CRemplirInfoPointage( vTOBLigneEcr : TOB );
begin
 vTOBLigneEcr.PutValue('E_LETTRAGE'          , '');
 vTOBLigneEcr.PutValue('E_LETTRAGEDEV'       , '-');
 vTOBLigneEcr.PutValue('E_ECHE'              , 'X');
 vTOBLigneEcr.PutValue('E_ETATLETTRAGE'      , 'RI');
 vTOBLigneEcr.PutValue('E_COUVERTURE'        , 0);
 vTOBLigneEcr.PutValue('E_COUVERTUREDEV'     , 0);
 vTOBLigneEcr.PutValue('E_DATEPAQUETMAX'     , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_DATEPAQUETMIN'     , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_DATEECHEANCE'      , vTOBLigneEcr.GetValue('E_DATECOMPTABLE'));
 vTOBLigneEcr.PutValue('E_NUMECHE'           , 1);
// vTOBLigneEcr.PutValue('E_MODEPAIE'          , 'DIV');   // LG 06/02/2008 doit etre affecter ds le code
{$IFNDEF TRESO}
 {JP 27/09/04 : FQ TRESO 10115 : On passe E_TRESOSYNCHRO des �critures pointables � CRE.
                IFNDEF TRESO, car toutes les �critures g�n�r�es en Tr�sorerie sont consid�r�es
                � RIE car il est inutile de les synchroniser}
 vTOBLigneEcr.PutValue('E_TRESOSYNCHRO'      , 'CRE');
{$ENDIF}
end;

{$IFNDEF NOVH}
procedure CRemplirDateComptable( vTOBLigneEcr : TOB ; Value : TDateTime );
begin
 vTOBLigneEcr.PutValue('E_DATECOMPTABLE', Value);
 vTOBLigneEcr.PutValue('E_EXERCICE', QuelExoDT(Value) );
 vTOBLigneEcr.PutValue('E_PERIODE'      , GetPeriode ( Value ) ) ;
 vTOBLigneEcr.PutValue('E_SEMAINE'      , NumSemaine ( Value ) ) ;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 19/02/2007
Description .. : fct d'initialisation d'une nouvelle ligne d'ecriture
Suite ........ : Attention : les champs de lettrage ne sont pas initialis�
Suite ........ : - LG - 02/04/2004 - E_IO passe a X pour un nouvel enr. ( 
Suite ........ : modif a faire ds importcom
Suite ........ : - LG - 04/04/2005 - suppression de l'affectation de
Suite ........ : e_exercice ( doit etre fait lors dela mise a jour de la date
Suite ........ : comptable )
Suite ........ : - LG - 19/02/2007 - suppression des directif de compil 
Suite ........ : SANSCOMPTA
Mots clefs ... : 
*****************************************************************}
procedure CPutDefautEcr( vTOBLigneEcr : TOB );
begin
 vTOBLigneEcr.PutValue ( 'E_ETABLISSEMENT'     , GetParamSocSecur('SO_ETABLISDEFAUT','') ) ;
 vTOBLigneEcr.PutValue ( 'E_PERIODE'           , GetPeriode ( V_PGI.DateEntree ) ) ;
 vTOBLigneEcr.PutValue ( 'E_SEMAINE'           , NumSemaine ( V_PGI.DateEntree ) ) ;
 vTOBLigneEcr.PutValue ( 'E_DATECOMPTABLE'     , V_PGI.DateEntree ) ;
 vTOBLigneEcr.PutValue ( 'E_NATUREPIECE'       , 'OD' ) ;
 vTOBLigneEcr.PutValue ( 'E_QUALIFPIECE'       , 'N' ) ;
 vTOBLigneEcr.PutValue ( 'E_TYPEMVT'           , 'DIV' ) ;
 vTOBLigneEcr.PutValue ( 'E_VALIDE'            , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_ETAT'              , '0000000000' ) ;
 vTOBLigneEcr.PutValue ( 'E_UTILISATEUR'       , V_PGI.User ) ;
 vTOBLigneEcr.PutValue ( 'E_DATECREATION'      , Date ) ;
 vTOBLigneEcr.PutValue ( 'E_DATEMODIF'         , NowH ) ;
 vTOBLigneEcr.PutValue ( 'E_SOCIETE'           , V_PGI.CodeSociete ) ;
 vTOBLigneEcr.PutValue ( 'E_VISION'            , 'DEM' ) ;
 vTOBLigneEcr.PutValue ( 'E_TVAENCAISSEMENT'   , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_DEVISE'            , V_PGI.DevisePivot ) ;
 vTOBLigneEcr.PutValue ( 'E_CONTROLE'          , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_TIERSPAYEUR'       , '' ) ;
 vTOBLigneEcr.PutValue ( 'E_QUALIFQTE1'        , '...' ) ;
 vTOBLigneEcr.PutValue ( 'E_QUALIFQTE2'        , '...' ) ;
 vTOBLigneEcr.PutValue ( 'E_ECRANOUVEAU'       , 'N' ) ;
 vTOBLigneEcr.PutValue ( 'E_DATEPAQUETMIN'     , V_PGI.DateEntree ) ;
 vTOBLigneEcr.PutValue ( 'E_DATEPAQUETMAX'     , V_PGI.DateEntree ) ;
 vTOBLigneEcr.PutValue ( 'E_ETATLETTRAGE'      , 'RI' ) ;
 vTOBLigneEcr.PutValue ( 'E_EMETTEURTVA'       , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_ANA'               , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_FLAGECR'           , '' ) ;
 vTOBLigneEcr.PutValue ( 'E_DATETAUXDEV'       , V_PGI.DateEntree ) ;
 vTOBLigneEcr.PutValue ( 'E_CONTROLETVA'       , 'RIE' ) ;
 vTOBLigneEcr.PutValue ( 'E_CONFIDENTIEL'      , '0' ) ;
 vTOBLigneEcr.PutValue ( 'E_CREERPAR'          , 'SAI' ) ;
 vTOBLigneEcr.PutValue ( 'E_EXPORTE'           , '---' ) ;
 vTOBLigneEcr.PutValue ( 'E_TRESOLETTRE'       , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_CFONBOK'           , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_MODESAISIE'        , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_EQUILIBRE'         , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_AVOIRRBT'          , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_CODEACCEPT'        , 'NON' ) ;
 vTOBLigneEcr.PutValue ( 'E_EDITEETATTVA'      , '-' ) ;
 vTOBLigneEcr.PutValue ( 'E_IO'                , '-' ) ; // une nouvelle enregistrement doit etre exporte par defaut
 vTOBLigneEcr.PutValue ( 'E_ETATREVISION'      , '-') ;
 vTOBLigneEcr.PutValue ( 'E_TRESOSYNCHRO'      , 'RIE') ; // Modif SBO : MAJ champs pour synchro Tr�so (CRE MOD DYN) par d�faut CRE
// CEGID V9
 vTOBLigneEcr.PutValue('E_DATEORIGINE', iDate1900) ;
 vTOBLigneEcr.PutValue('E_DATEPER',iDate1900) ;
 vTOBLigneEcr.PutValue('E_ENTITY',0 );
 vTOBLigneEcr.PutValue('E_REFGUID','') ;
// -----------------
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 15/03/2002
Modifi� le ... : 28/07/2003
Description .. : fct de duplication d'une ligne d'ecriture
Suite ........ : Attention : les champs consernant les montant et le lettrage
Suite ........ : ne sont pas repris
Suite ........ :
Suite ........ : LG - 28/072003 - FB 12576 - on ne reprends pas le code
Suite ........ : utilisateur
Mots clefs ... :
*****************************************************************}
procedure CDupliquerTOBEcr( vTOBLigneSource,vTOBLigneDestination : TOB );
begin
// E_JOURNAL, E_EXERCICE, E_DATECOMPTABLE, E_NUMEROPIECE, E_NUMLIGNE, E_NUMECHE, E_QUALIFPIECE
 vTOBLigneDestination.PutValue( 'E_JOURNAL'         , vTOBLigneSource.GetValue('E_JOURNAL') );
 vTOBLigneDestination.PutValue( 'E_EXERCICE'        , vTOBLigneSource.GetValue('E_EXERCICE') );
 vTOBLigneDestination.PutValue( 'E_DATECOMPTABLE'   , vTOBLigneSource.GetValue('E_DATECOMPTABLE') );
 vTOBLigneDestination.PutValue( 'E_NUMEROPIECE'     , vTOBLigneSource.GetValue('E_NUMEROPIECE') );
 vTOBLigneDestination.PutValue( 'E_QUALIFPIECE'     , vTOBLigneSource.GetValue('E_QUALIFPIECE') );
 vTOBLigneDestination.PutValue( 'E_DATECOMPTABLE'   , vTOBLigneSource.GetValue('E_DATECOMPTABLE') ) ;
 vTOBLigneDestination.PutValue( 'E_NATUREPIECE'     , vTOBLigneSource.GetValue('E_NATUREPIECE') ) ;
 vTOBLigneDestination.PutValue( 'E_TYPEMVT'         , vTOBLigneSource.GetValue('E_TYPEMVT')) ;
 vTOBLigneDestination.PutValue( 'E_VALIDE'          , vTOBLigneSource.GetValue('E_VALIDE') ) ;
// vTOBLigneDestination.PutValue( 'E_DATECREATION'    , vTOBLigneSource.GetValue('E_DATECREATION') ) ;
// vTOBLigneDestination.PutValue( 'E_DATEMODIF'       , vTOBLigneSource.GetValue('E_DATEMODIF') ) ;
 vTOBLigneDestination.PutValue( 'E_SOCIETE'         , vTOBLigneSource.GetValue('E_SOCIETE') ) ;
 vTOBLigneDestination.PutValue( 'E_DEVISE'          , vTOBLigneSource.GetValue('E_DEVISE') ) ;
 vTOBLigneDestination.PutValue( 'E_CONTROLE'        , vTOBLigneSource.GetValue('E_CONTROLE') ) ;
 vTOBLigneDestination.PutValue( 'E_ECRANOUVEAU'     , vTOBLigneSource.GetValue('E_ECRANOUVEAU') ) ;
 vTOBLigneDestination.PutValue( 'E_CONFIDENTIEL'    , vTOBLigneSource.GetValue('E_CONFIDENTIEL') ) ;
 vTOBLigneDestination.PutValue( 'E_CREERPAR'        , vTOBLigneSource.GetValue('E_CREERPAR') ) ;
 vTOBLigneDestination.PutValue( 'E_EXPORTE'         , vTOBLigneSource.GetValue('E_EXPORTE') ) ;
 vTOBLigneDestination.PutValue( 'E_TRESOLETTRE'     , vTOBLigneSource.GetValue('E_TRESOLETTRE') ) ;
 vTOBLigneDestination.PutValue( 'E_MODESAISIE'      , vTOBLigneSource.GetValue('E_MODESAISIE') ) ;
 vTOBLigneDestination.PutValue( 'E_PERIODE'         , vTOBLigneSource.GetValue('E_PERIODE') ) ;
 vTOBLigneDestination.PutValue( 'E_SEMAINE'         , vTOBLigneSource.GetValue('E_SEMAINE') ) ;
 vTOBLigneDestination.PutValue( 'E_TYPEMVT'         , vTOBLigneSource.GetValue('E_TYPEMVT')) ;
 vTOBLigneDestination.PutValue( 'E_COTATION'        , vTOBLigneSource.GetValue('E_COTATION') ) ;
 vTOBLigneDestination.PutValue( 'E_NUMGROUPEECR'    , vTOBLigneSource.GetValue('E_NUMGROUPEECR') ) ;
 vTOBLigneDestination.PutValue( 'E_ETABLISSEMENT'   , vTOBLigneSource.GetValue('E_ETABLISSEMENT') ) ;
 vTOBLigneDestination.PutValue( 'E_TAUXDEV'         , vTOBLigneSource.GetValue('E_TAUXDEV') ) ;
 vTOBLigneDestination.PutValue( 'E_COTATION'        , vTOBLigneSource.GetValue('E_COTATION') ) ;
end;

procedure CDupliquerInfoAux( vTOBLigneSource,vTOBLigneDestination : TOB );
begin
 vTOBLigneDestination.PutValue( 'E_AUXILIAIRE'      , vTOBLigneSource.GetValue('E_AUXILIAIRE'));
 vTOBLigneDestination.PutValue( 'E_MODEPAIE'        , vTOBLigneSource.GetValue('E_MODEPAIE'));
 vTOBLigneDestination.PutValue( 'E_DATEECHEANCE'    , vTOBLigneSource.GetValue('E_DATEECHEANCE'));
 vTOBLigneDestination.PutValue( 'E_ORIGINEPAIEMENT' , vTOBLigneSource.GetValue('E_ORIGINEPAIEMENT'));
end;


procedure CNumeroPiece( vTOBPiece : TOB );
var
 k                : integer;
 i                : integer;
 lTOBLigneEcr     : TOB;
 lTOBSection      : TOB;
 lInNumLigne      : integer;
 lInNumAxe        : integer;
 lInNumeroPiece   : integer;
begin

 lInNumLigne     := 0;
 lInNumeroPiece  := 0;

 for k:=0 to vTOBPiece.Detail.Count-1 do
  begin

   lTOBLigneEcr   := vTOBPiece.Detail[k];

   if lInNumeroPiece <> lTOBLigneEcr.GetValue('E_NUMEROPIECE') then
    begin
      lInNumLigne     := 1;
      lInNumeroPiece  := lTOBLigneEcr.GetValue('E_NUMEROPIECE');
    end
     else
      Inc(lInNumLigne) ;

   lTOBLigneEcr.PutValue('E_NUMLIGNE' , lInNumLigne);

   // renumerotation de l'analytique
   if assigned( lTOBLigneEcr.Detail ) and ( lTOBLigneEcr.detail.Count > 0 ) then
    begin
     for lInNumAxe := 0 to ( MaxAxe - 1 ) do
      begin
       lTOBSection := lTOBLigneEcr.detail[lInNumAxe];
       if assigned( lTOBSection.Detail ) and ( lTOBSection.detail.Count > 0 ) then
         for i := 0 to lTOBSection.detail.Count - 1 do
          begin
           lTOBSection.Detail[i].PutValue('Y_NUMLIGNE',lInNumLigne);
           lTOBSection.Detail[i].PutValue('Y_NUMEROPIECE',lInNumeroPiece);
           lTOBSection.Detail[i].PutValue('Y_QUALIFPIECE',lTOBLigneEcr.GetValue('E_QUALIFPIECE')); // pour la saisie en vrac la qualif piece est r�effecter ici ( pour une ecriture normal ne sert pas ! )
           lTOBSection.Detail[i].PutValue('Y_DATECOMPTABLE',lTOBLigneEcr.GetValue('E_DATECOMPTABlE')); // pour le CUTOFF la datecomptable est r�effecter ici ( pour une ecriture normal ne sert pas ! )
          end; // for
      end; // for
    end; // if

 end; // for

end;

function COuvreScenario( vStJournal, vStNature, vStQualifpiece, vStEtablissement : string ; vTOBResult : TOB ; var vMemoComp : HTStringList ; vDossier : String = '' ) : boolean;
var
 Q : TQuery;
begin

 result := false;
 Q      := nil;

 if vTOBResult =  nil then exit ;

 if ( vStJournal = '' ) or (  vStNature = '' ) then exit;

 try

 Q:=OpenSelect( 'Select * from SUIVCPTA Where SC_JOURNAL="' + vStJournal
             + '" AND SC_NATUREPIECE="' + vStNature + '"'
             + ' AND (SC_QUALIFPIECE="' + vStQualifpiece
             + '" OR SC_QUALIFPIECE="" OR SC_QUALIFPIECE="...") '
             + ' AND (SC_ETABLISSEMENT="" OR SC_ETABLISSEMENT="' + vStEtablissement + '" OR SC_ETABLISSEMENT="...")'
             + ' AND (SC_USERGRP="" OR SC_USERGRP="' + V_PGI.Groupe + '" OR SC_USERGRP="...")'
             + ' order by SC_USERGRP, SC_ETABLISSEMENT, SC_QUALIFPIECE ' , vDossier );

 if not Q.EOF then
  begin
   vTOBResult.SelectDB('',Q) ;
   if ( Not TMemoField(Q.FindField('SC_ATTRCOMP')).IsNull ) and ( vMemoComp <> nil ) then
    vMemoComp.Text:=Q.FindField('SC_ATTRCOMP').asString ;
   result := true;
  end;

 finally
  if assigned(Q) then Ferme(Q);
 end;

end;

function CGetRIB ( vTOBLigneEcr : TOB ) : string;
var
 lTOB : TOB;
 lTemp : HTStringList ;
begin

 result := '' ;
 lTemp  := nil ;

 if ( vTOBLigneEcr = nil ) or ( trim(vTOBLigneEcr.GetValue('E_AUXILIAIRE')) = '' ) then exit;

 lTOB   := TOB.Create('',nil,-1);

 try

  if COuvreScenario(vTOBLigneEcr.GetValue('E_JOURNAL'),
                    vTOBLigneEcr.GetValue('E_NATUREPIECE'),
                    vTOBLigneEcr.GetValue('E_QUALIFPIECE'),
                    vTOBLigneEcr.GetValue('E_ETABLISSEMENT'),
                    lTOB,
                    lTemp) then
   begin
    if lTOB.GetValue('SC_RIB') = 'PRI' then
     result := GetRIBPrincipal(vTOBLigneEcr.GetValue('E_AUXILIAIRE'));
   end
    else
     if GetParamSocSecur('SO_ATTRIBRIBAUTO',False) then
       result := GetRIBPrincipal(vTOBLigneEcr.GetValue('E_AUXILIAIRE'));

 finally
  if assigned(lTOB) then lTOB.Free;
 end;

end;


procedure CRDeviseVersTOB( vRecRDevise : RDevise ; vTOB : TOB ) ;
begin
 vTOB.PutValue('D_DEVISE'            , vRecRDevise.Code) ;
 vTOB.PutValue('D_LIBELLE'           , vRecRDevise.Libelle) ;
 vTOB.PutValue('D_SYMBOLE'           , vRecRDevise.Symbole) ;
 vTOB.PutValue('D_DECIMALE'          , vRecRDevise.Decimale) ;
 vTOB.PutValue('D_QUOTITE'           , vRecRDevise.Quotite) ;
 vTOB.PutValue('D_CPTLETTRDEBIT'     , vRecRDevise.CptDebit) ;
 vTOB.PutValue('D_CPTLETTRCREDIT'    , vRecRDevise.CptCredit) ;
 vTOB.PutValue('D_MAXDEBIT'          , vRecRDevise.MaxDebit) ;
 vTOB.PutValue('D_MAXCREDIT'         , vRecRDevise.MaxCredit) ;
 vTOB.PutValue('TAUX'                , vRecRDevise.Taux) ;
 vTOB.PutValue('DATETAUX'            , vRecRDevise.DateTaux) ;
end;

procedure CTOBVersRDevise( vTOB : TOB ; var vRecRDevise : RDevise ) ;
begin
 vRecRDevise.Code       := vTOB.GetValue('D_DEVISE') ;
 vRecRDevise.Libelle    := vTOB.GetValue('D_LIBELLE') ;
 vRecRDevise.Symbole    := vTOB.GetValue('D_SYMBOLE') ;
 vRecRDevise.Decimale   := vTOB.GetValue('D_DECIMALE') ;
 vRecRDevise.Quotite    := vTOB.GetValue('D_QUOTITE') ;
 vRecRDevise.CptDebit   := vTOB.GetValue('D_CPTLETTRDEBIT') ;
 vRecRDevise.CptCredit  := vTOB.GetValue('D_CPTLETTRCREDIT') ;
 vRecRDevise.MaxDebit   := vTOB.GetValue('D_MAXDEBIT') ;
 vRecRDevise.MaxCredit  := vTOB.GetValue('D_MAXCREDIT') ;
 vRecRDevise.Taux       := vTOB.GetValue('TAUX') ;
 vRecRDevise.DateTaux   := vTOB.GetValue('DATETAUX') ;
end;

{$IFNDEF EAGLSERVER}
{$IFNDEF NOVH}
procedure CDecodeKeyForAux ( vInKey : Word ; vShift : TShiftState ; var vBoCodeOnly, vBoLibelleOnly, vBoBourrage : boolean );
begin
 vBoCodeOnly    := ((vInKey=VK_F5) and (vShift=[])) or ((vInKey=VK_TAB) and VH^.CPCodeAuxiOnly) ;
 vBoLibelleOnly := (vInKey=VK_F5) and (vShift=[ssCtrl]) ;
 vBoBourrage    :=  not (vInKey=VK_F5) ;
end;
{$ENDIF}
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 21/11/2002
Modifi� le ... : 06/06/2006
Description .. : - suppression de warning
Suite ........ : - 20/01/2002 - correction pour la date
Suite ........ : - FB 11/08/2004 - FB 14053 - si l'exercice de ref est definie
Suite ........ : on le prends pour controler la date
Suite ........ : - LG 14/10/2004 - FB 14634 14297 14798 - voir fiche ( pb
Suite ........ : sur les cloture etc etc )
Suite ........ : - LG - 06/06/2006 - on force le controle des compte vises 
Suite ........ : pour les ecritures simplifiees
Suite ........ : 
Mots clefs ... :
*****************************************************************}
function CControleDateBor(vDateComptable : TDateTime ; vExercice : TZExercice ; Parle : Boolean = true ; vStCodeExo : string = '' ) : boolean ;
var
 lDtDateDebN : TDateTime ;
 lDtDateFinN : TDateTime ;
 lStExo      : string ;
 lDt         : TDateTime ;
begin

 result      := false ;
 lDtDateDebN := iDate1900 ;
 lDtDateFinN := iDate1900 ;

 if vStCodeExo <> '' then
  lStExo := vStCodeExo
   else
    lStExo := vExercice.QuelExoDt(vDateComptable) ;

 if (lStExo='') then
  begin
    if Parle then PgiInfo('l''exercice n''existe pas !','V�rification d''exercice');
    exit;
  end; // if


 if vExercice.EstExoClos(lStExo) then
  begin
   if Parle then PgiInfo('l''exercice est clos','V�rification d''exercice');
   exit;
  end; // for

 if (lStExo=vExercice.Entree.Code) then
  begin
   lDtDateFinN := vExercice.Entree.Fin ;
   lDtDateDebN := vExercice.Entree.Deb ;
  end
   else
    if (lStExo=vExercice.Suivant.Code) then
     begin
      lDtDateDebN := vExercice.Suivant.Deb ;
      lDtDateFinN := vExercice.Suivant.Fin ;
     end
      else
       if (lStExo=vExercice.Precedent.Code) then
        begin
         lDtDateDebN := vExercice.Precedent.Deb ;
         lDtDateFinN := vExercice.Precedent.Fin ;
        end
         else
          if (lStExo=vExercice.EnCours.Code) then
           begin
            lDtDateDebN := vExercice.EnCours.Deb ;
            lDtDateFinN := vExercice.EnCours.Fin ;
           end;


 // recherche de la derniere date de cloture periodique
 // SBO 22/01/2007 : La date de cloture p�riodique doit �tre coh�rente sur une session de saisie
 // Faire un test en amont dans les traitements qui sont amen�s � modifier cette date si besoin...
 {$IFDEF EAGLCLIENT}
 lDt := GetParamSocSecur('SO_DATECLOTUREPER',iDate1900) ;
 if lDt > iDate1900 then
  lDtDateDebN  := lDt + 1 ;
 {$ELSE}
  lDt := GetParamSocSecur('SO_DATECLOTUREPER',iDate1900) ;
  if ( lDt > iDate1900 ) and ( lDt > lDtDateDebN )  then
  lDtDateDebN  := lDt + 1 ;
 {$ENDIF}

 if ( lDtDateDebN > vDateComptable ) then
  begin
   if Parle then PGIError(cStDateInfDateDebExo,'Attention');
   exit ;
  end ;

 if ( lDtDateFinN  < vDateComptable ) then
  begin
   if Parle then PGIError(cStDateInfDateFinExo,'Attention');
   exit ;
  end ;

 result := true ;

end;

function CUnSeulEtablis : boolean ;
var
 lQ : TQuery ;
begin
 lQ := OpenSQL('select count(et_etablissement) N from etabliss',true,-1,'',true) ;
 result := lQ.FindField('N').asInteger = 1 ;
 Ferme(lQ);
end;

{$IFNDEF EAGLSERVER}
{$IFNDEF NOVH}
procedure CDateParDefautPourSaisie( var vDateDebut,vDateFin : TDateTime ) ;
begin

 vDateDebut  := GetParamSocSecur('SO_DATECLOTUREPER',iDate1900,true) + 1 ;

 if (VH^.DateCloturePer + 1) > VH^.CPExoRef.Deb then
  vDateDebut := VH^.DateCloturePer + 1
   else
    begin
     if ( VH^.CPExoRef.Code <> '' ) then
      vDateDebut := VH^.CPExoRef.Deb
       else
        vDateDebut := VH^.EnCours.Deb ;
    end; // if

 if ( VH^.CPExoRef.Code <> '' ) then
  vDateFin := VH^.CPExoRef.Fin
   else
    vDateFin := VH^.EnCours.Fin ;

end;
{$ENDIF}
{$ENDIF}

function CControleChampsObligSaisie ( vEcr : TOB ; var vStMessage : string ) : Integer ;
var
 i : integer ;
begin
 result := RC_CHAMPSOBLIGATOIRE ;

 if vEcr = nil then
  begin
   MessageAlerte('Fonction CControleChampsObligSaisie : vEcr = nil');
   exit;
  end; // if

 for i := 0 to _InMaxChamps do
  begin
   if trim(vEcr.GetValue(_RecChampsOblig[i])) = '' then
    begin
     vStMessage := 'le champ ' + _RecChampsOblig[i] + ' est obligatoire !'  ;
     exit ;
    end; // if
  end; // for _InMaxChampsRepar

 for i := 0 to _InMaxChampsRepar do
  if trim(vEcr.GetValue(_RecReparChampsOblig[i,0])) = '' then
   vEcr.PutValue(_RecReparChampsOblig[i,0],_RecReparChampsOblig[i,1]) ;

 if vEcr.GetValue('E_NUMEROPIECE') = 0 then
  begin
   result := RC_NUMPIECEOBLIG ;
   vStMessage := 'le champ E_NUMEROPIECE ne peut pas etre nul !'  ;
   exit ;
  end; // if

  if vEcr.GetValue('E_NUMLIGNE') = 0 then
  begin
   result := RC_NUMLIGNEOBLIG ;
   vStMessage := 'le champ E_NUMLIGNE ne peut pas etre nul !'  ;
   exit ;
  end; // if

 result := RC_PASERREUR ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 16/09/2002
Modifi� le ... :   /  /
Description .. : - 16/09/2002 - Supprime les lignes vides provenant de la
Suite ........ : saisie
Mots clefs ... :
*****************************************************************}
procedure CSupprimeLigneSaisieVide ( vTOB : TOB ) ;
var lEcr : TOB ;
i : integer ;
begin
if (vTOB=nil) or (vTOB.DEtail=nil) then exit;
i:=0 ;
while i<vTOB.Detail.Count do
 begin
  lEcr:=vTOB.Detail[i] ;
  if (lEcr.GetValue('E_DEBIT')=0) and (lEcr.GetValue('E_CREDIT')=0) then lEcr.Free
  else Inc(i) ;
 end; // while
end ;

function CZompteVersTGGeneral ( vCompte : TZCompte ) : TGGeneral ;
var
 lC  : Char ;
 lSt : String ;
begin
 result                      := TGGeneral.Create('') ;
 result.General              := vCompte.GetValue('G_GENERAL') ;
 result.Libelle              := vCompte.GetValue('G_LIBELLE');
 result.Collectif            := vCompte.GetValue('G_COLLECTIF') = 'X' ;
 result.NatureGene           := vCompte.GetValue('G_NATUREGENE');
 result.Ventilable[1]        := vCompte.GetValue('G_VENTILABLE1') = 'X' ;
 result.Ventilable[2]        := vCompte.GetValue('G_VENTILABLE2') = 'X' ;
 result.Ventilable[3]        := vCompte.GetValue('G_VENTILABLE3') = 'X' ;
 result.Ventilable[4]        := vCompte.GetValue('G_VENTILABLE4') = 'X' ;
 result.Ventilable[5]        := vCompte.GetValue('G_VENTILABLE5') = 'X' ;
 result.Lettrable            := vCompte.GetValue('G_LETTRABLE') = 'X' ;
 result.TotalDebit           := vCompte.GetValue('G_TOTALDEBIT') ;
 result.TotalCredit          := vCompte.GetValue('G_TOTALCREDIT') ;
 result.Budgene              := vCompte.GetValue('G_BUDGENE') ;
 result.Tva                  := vCompte.GetValue('G_TVA') ;
 result.Tpf                  := vCompte.GetValue('G_TPF') ;
 result.Tva_Encaissement     := vCompte.GetValue('G_TVAENCAISSEMENT') ;
 result.SoumisTPF            := vCompte.GetValue('G_SOUMISTPF') = 'X' ;
 result.RegimeTVA            := vCompte.GetValue('G_REGIMETVA') ;
 result.Moderegle            := vCompte.GetValue('G_MODEREGLE') ;
 result.Pointable            := vCompte.GetValue('G_POINTABLE') = 'X' ;
 result.Ferme                := vCompte.GetValue('G_FERME') = 'X' ;
 result.QQ1                  := vCompte.GetValue('G_QUALIFQTE1') ;
 result.QQ2                  := vCompte.GetValue('G_QUALIFQTE2') ;
 result.TvaSurEncaissement   := vCompte.GetValue('G_TVASURENCAISS') = 'X' ;
 result.Abrege               := vCompte.GetValue('G_ABREGE') ;
 result.SuiviTreso           := vCompte.GetValue('G_SUIVITRESO') ;
 result.Confidentiel         := vCompte.GetValue('G_CONFIDENTIEL') ;
 result.CodeConso            := vCompte.GetValue('G_CONSO') ;
 result.Effet                := vCompte.GetValue('G_EFFET') = 'X' ;
 lSt                         := vCompte.GetValue('G_SENS') ;
 if lSt <> '' then lC := lSt[1] else lC := 'M' ;
 case lC of 'D' : result.Sens := 1 ; 'C' : result.Sens := 2 ; else result.Sens := 3 ; end ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent gendreau
Cr�� le ...... : 20/07/2007
Modifi� le ... :   /  /    
Description .. : - LG - 20/07/2007 - FB 20202 - rajout d'un test sur les 
Suite ........ : ecritrue valide
Mots clefs ... : 
*****************************************************************}
procedure CRempliComboFolio ( vItem, vValue : HTStrings ; E_JOURNAL,E_EXERCICE : string ; E_DATECOMPTABLE : TDateTime ; vBoTestErcValide : boolean = false ) ;
var
 lQ                  : TQuery ;
 lYear, lMonth, lDay : word ;
 lInMaxJour          : integer ;
 lStSQL              : string ;
begin

 vItem.Clear ;
 vValue.Clear ;
 DecodeDate( E_DATECOMPTABLE , lYear , lMonth , lDay ) ;
 lInMaxJour := DaysPerMonth( lYear, lMonth) ;

 lStSQL := 'SELECT E_NUMEROPIECE FROM ECRITURE WHERE '            +
               'E_JOURNAL="'                                          + E_JOURNAL  + '"' +
               ' AND E_EXERCICE="'                                    + E_EXERCICE + '"' +
               ' AND E_DATECOMPTABLE>="'                              + USDateTime(EncodeDate(lYear, lMonth, 1)) + '"' +
               ' AND E_DATECOMPTABLE<="'                              + USDateTime(EncodeDate(lYear, lMonth, lInMaxJour)) + '"' +
               ' AND ( E_QUALIFPIECE="N" OR E_QUALIFPIECE="C" ) ' ;
 if vBoTestErcValide then
  lStSQL := lStSQL + ' AND E_VALIDE<>"X" ' ;

 lStSQL := lStSQL + ' GROUP BY E_NUMEROPIECE ORDER BY E_NUMEROPIECE DESC ' ;

 lQ := OpenSQL( lStSQL , true,-1,'',true) ;

 while not lQ.EOF do
  begin
   vItem.Add  ( lQ.FindField('E_NUMEROPIECE').AsString ) ;
   vValue.Add( lQ.FindField('E_NUMEROPIECE').AsString ) ;
   lQ.Next ;
  end ; // while

 Ferme(lQ) ;

end ;


//*obj*

{ TInfoEcriture }

constructor TInfoEcriture.Create( vDossier : String = '' ) ;
begin
 if vDossier <> '' then
  FDossier := vDossier
   else FDossier := V_PGI.SchemaName ;
 FCompte           := TZCompte.Create(FDossier) ;
 FAux              := TZTier.Create(FDossier) ;
 FJournal          := TZListJournal.Create(FDossier) ;
 FTypeExo          := teEncours ;
 FSection          := TZSections.Create(FDossier) ;
 
end;

destructor TInfoEcriture.Destroy;
begin

 try
  if assigned(FCompte)    then FCompte.Free ;
  if assigned(FAux)       then FAux.Free ;
  if assigned(FJournal)   then FJournal.Free ;
  if assigned(FDevise)    then FDevise.Free ;
  if assigned(FEtabliss)  then FEtabliss.Free ;
  if assigned(FSection)   then FSection.Free ;
  if assigned(FModeRegle) then FModeRegle.Free ;
  if assigned(FModePaie)  then FModePaie.Free ;
 finally
  FCompte                := nil ;
  FAux                   := nil ;
  FJournal               := nil ;
  FDevise                := nil ;
  FEtabliss              := nil ;
  FSection               := nil ;
  FModeRegle             := nil ;
  FModePaie              := nil ;
 end ;

 inherited;

end;

function TInfoEcriture.GetExercice : TZExercice ;
begin
 result := ctxExercice ;
end ;

function TInfoEcriture.GetDevise : TZDevise;
begin
 if FDevise = nil then
  begin
   FDevise := TZDevise.Create( FDossier ) ;
   result  := FDevise ;
  end
   else
    result := FDevise ;
end;

function TInfoEcriture.GetEtabliss : TZEtabliss;
begin
 if FEtabliss = nil then
  begin
   FEtabliss := TZEtabliss.Create( FDossier ) ;
   result  := FEtabliss ;
  end
   else
    result := FEtabliss ;
end;

function TInfoEcriture.GetJournal : string;
begin
 result := Journal.GetString('J_JOURNAL') ;
end;

function TInfoEcriture.GetCompte : string;
begin
 result := Compte.GetString('G_GENERAL') ;
end;

function TInfoEcriture.GetAux : string;
begin
 result := Aux.GetString('T_AUXILIAIRE') ;
end;



procedure TInfoEcriture.Load(vStCompte, vStAux , vStJournal : string ; vBoEnBase : boolean = false ) ;
begin

 LoadCompte( vStCompte , vBoEnBase) ;
 LoadAux( vStAux,vBoEnBase) ;
 LoadJournal(vStJournal,vBOEnBase) ;

end;

function TInfoEcriture.LoadCompte( vStCompte : string ; vBoEnBase : boolean = false) : boolean;
begin
  result := ( FCompte.GetCompte(vStCompte, vBoEnBase ) <> - 1  ) ;
end;

function TInfoEcriture.LoadAux( vStAux : string ; vBoEnBase : boolean = false) : boolean;
begin
  result := ( FAux.GetCompte(vStAux,vBoEnBase) <> - 1  ) ;
end;

function TInfoEcriture.LoadJournal( vStJournal : string ; vBoEnBase : boolean = false ) : boolean;
begin
 result := ( FJournal.Load([vStJournal],vBoEnBase) <> - 1  ) ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 14/10/2003
Modifi� le ... :   /  /
Description .. : - 14/10/2003 - VL -  VL Correction faute orthographe
Mots clefs ... :
*****************************************************************}
function TInfoEcriture.Compte_GetValue( vStNom : string ) : variant;
begin

  result := #0 ;

  if ( FCompte.InIndex = - 1 ) or ( trim(vStNom) = '' ) then
   begin
     NotifyError( RC_COMPTEINEXISTANT, 'Le compte est inconnu' ) ;
     exit ;
   end; // if

  result := FCompte.GetString( vStNom ) ;

end;

function TInfoEcriture.Aux_GetValue( vStNom : string ) : variant;
begin

  result := #0 ;

  if ( FAux.InIndex = - 1 ) or ( trim(vStNom) = '' ) then
   begin
     NotifyError( RC_AUXINEXISTANT, '' ) ;
     exit ;
   end; // if

  result := FAux.GetString( vStNom ) ;

end;


function  TInfoEcriture.GetValue( vStNom : string ; vIndex : integer = - 1 ) : variant ;
var
 lStPrefixe : string ;
begin

 lStPrefixe := Copy(vStNom,1,1) ;

 if lStPrefixe = 'G' then
  result := FCompte.GetValue(vStNom,vIndex)
   else
    if ( lStPrefixe = 'T' ) or ( lStPrefixe = 'Y' ) then
     result := FAux.GetValue(vStNom,vIndex)
      else
       if lStPrefixe = 'J' then
        result := FJournal.GetValue(vStNom,vIndex)
         else
          result := #0 ;
end ;

function  TInfoEcriture.GetString( vStNom : string ; vIndex : integer = - 1  ) : string ;
var
 lStPrefixe : string ;
begin

 lStPrefixe := Copy(vStNom,1,1) ;

 if lStPrefixe = 'G' then
  result := FCompte.GetString(vStNom,vIndex)
   else
    if ( lStPrefixe = 'T' ) or ( lStPrefixe = 'Y' ) then
     result := FAux.GetString(vStNom,vIndex)
      else
       if lStPrefixe = 'J' then
        result := FJournal.GetString(vStNom,vIndex)
         else
          if lStPrefixe = 'S' then
           result := FSection.GetString(vStNom,vIndex)
            else
             result := '' ;
end ;

procedure TInfoEcriture.NotifyError( RC_Error : integer ; RC_Message : string ) ;
begin
 FLastError.RC_Error   := RC_Error ;
 FLastError.RC_Message := RC_Message ;
 if assigned(FOnError) then FOnError(self,FLastError) ;
end;


procedure TInfoEcriture.SetOnError( Value : TErrorProc );
begin
 FOnError := Value ;
end;

procedure TInfoEcriture.Initialize;
begin
 FLastError.RC_Error   := - 1 ;
 FLastError.RC_Message := '' ;
end;


{ TTOBCompta }
procedure TOBCompta.SetInfo( Value : TInfoEcriture );
begin
 PInfo := Value ;
end;


procedure TOBCompta.NotifyError( RC_Error : integer ; RC_Message : string ; RC_Methode : string = '') ;
begin
 FLastError.RC_Error   := RC_Error ;
 FLastError.RC_Message := RC_Message ;
 FLastError.RC_Methode := RC_Methode ;
 if assigned(FOnError) then FOnError(self,FLastError) ;
end;


procedure TOBCompta.SetOnError( Value : TErrorProc );
begin
 FOnError := Value ;
end;

procedure TOBCompta.Initialize ;
begin
 NotifyError(RC_PASERREUR,'');
end;


{ TOBEcriture }

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 09/08/2004
Modifi� le ... :   /  /
Description .. : - 09/08/2004 - FB 13563 - getvalue remplace par getstring
Mots clefs ... :
*****************************************************************}
function TTOBEcriture.IsValidDateComptable : boolean;
begin

 result := false ;
 CheckInfo ;

  if (length(trim(GetString('E_DATECOMPTABLE')))) < 10 then exit;

  if ( Info.GetString('J_MODESAISIE')='-' ) or ( Info.GetString('J_MODESAISIE')='' ) then
   result := ControleDate(GetValue('E_DATECOMPTABLE')) = 0
    else
     result := CControleDateBor(GetValue('E_DATECOMPTABLE'),Info.Exercice,false) ;

  if not result then notifyError(RC_DATEINCORRECTE,'','TOBEcriture.IsValidDateComptable') ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 10/07/2003
Modifi� le ... :   /  /
Description .. : - FB 12483 - on pouvait passer une ecriture sur un compte
Suite ........ : ferme
Mots clefs ... :
*****************************************************************}
function TTOBEcriture.IsValidJournal : boolean ;
var
 lInCodeErreur : integer ;
begin

 CheckInfo ;

 lInCodeErreur := CIsValidJournal(self,Info) ;
 result        := lInCodeErreur = RC_PASERREUR ;

 if not result then
   NotifyError( lInCodeErreur , '' ) ;

end;


function TTOBEcriture.IsValid : TRecError ;
begin
 CheckInfo ;
 result := CIsValidLigneSaisie(Self,Info ) ;
end;


function TTOBEcriture.IsValidEtabliss : boolean;
var
 lInCodeErreur : integer ;
begin
 CheckInfo ;
 Initialize ;

 lInCodeErreur := CIsValidEtabliss(self,Info) ;
 result        := lInCodeErreur = RC_PASERREUR ;

 if not result then
   NotifyError( lInCodeErreur , '' ) ;

end;


function TTOBEcriture.IsValidCompte : boolean ;
var
 lInCodeErreur : integer ;
 lStCompte     : string ;
 lStAux        : string ;
 lStJournal    : string ;
begin

 {$IFDEF TT}
 AddEvenement('TOBEcriture.IsValidCompte');
{$ENDIF}

// result                := false ;
 CheckInfo ;
 Initialize ;

 lInCodeErreur := CIsValidCompte(self,Info) ;
 if ( lInCodeErreur <> RC_PASERREUR ) then
   NotifyError( lInCodeErreur , '' ) ;
 result := not ( ( lInCodeErreur = RC_COMPTEINEXISTANT ) or
                 ( lInCodeErreur = RC_CINTERDIT ) or
                 ( lInCodeErreur = RC_CNATURE ) ) ;

 if result then
  begin

   lStCompte             := Info.StCompte ;
   lStAux                := Info.StAux ;
   lStJournal            := Info.StJournal ;

   result := false ;

   if ( lStCompte = GetParamsocSecur('SO_OUVREBIL','') ) then
    begin
     PutValue('E_GENERAL' , '' );
     NotifyError(RC_COUVREBIL , '' ) ;
     exit ;
    end ;

   if EstInterdit( PInfo.GetString('J_COMPTEINTERDIT') , PInfo.StCompte , 0 ) > 0 then
    begin
     NotifyError(RC_CINTERDIT , '' ) ;
     PutValue('E_GENERAL' , '' ) ;
     exit;
    end ;

   result := ( FLastError.RC_Error = -1 ) ;

  end ;
  
 case FLastError.RC_Error of
  RC_PASCOLLECTIF ,
  RC_NATAUX        : lStAux    := '' ;
  RC_CINTERDIT ,
  RC_CNATURE       : begin lStCompte := '' ; lStAux    := '' ; end ;
 end ; // if

 PutValue('E_GENERAL'    , lStCompte ) ;
 PutValue('E_AUXILIAIRE' , lStAux ) ;
 PutValue('E_JOURNAL'    , lStJournal ) ;


end;

function TTOBEcriture.IsValidAux : boolean ;
var
 lInCodeErreur : integer ;
 lStAux        : string ;
 lStcompte     : string ;
begin

 {$IFDEF TT}
 AddEvenement('TOBEcriture.IsValidAux');
{$ENDIF}

 CheckInfo ;
 Initialize ;

 lInCodeErreur := CIsValidAux( self, Info ) ;
 if lInCodeErreur <> RC_PASERREUR then
   NotifyError( lInCodeErreur , '' ) ;

 result := lInCodeErreur = RC_PASERREUR ;

 if not result then exit ;

 lStCompte             := Info.StCompte ;
 lStAux                := Info.StAux ;

 if Info.GetString('T_FERME') = 'X' then
  begin
   if ( Arrondi(Info.GetValue('T_TOTALDEBIT') - Info.GetValue('T_TOTALCREDIT'), 2) = 0 ) then
     begin
      PutValue('E_AUXILIAIRE' , '' ) ;
      NotifyError( RC_AUXFERME , '' ) ;
      exit ;
     end
      else
       begin
        NotifyError( RC_AUXFERME , '' ) ;
       end ;
  end ; // if

 if ( FLastError.RC_Error = RC_COMPTEINEXISTANT ) or ( FLastError.RC_Error = RC_NATAUX ) then
  begin
   lStCompte := Info.GetString('T_COLLECTIF') ;
   PutValue('E_GENERAL'    , lStCompte ) ;
   PutValue('E_AUXILIAIRE' , lStAux ) ;
   result    := IsValidCompte ;
   if result then lStCompte := Info.StCompte ;
   if not result then exit ;
  end; // if

 PutValue('E_GENERAL'    , lStCompte ) ;
 PutValue('E_AUXILIAIRE' , lStAux ) ;

end;

function TTOBEcriture.IsValidNat : boolean;
var
 lInCodeErreur : integer ;
begin

 lInCodeErreur := CIsValidNat(self,Info) ;
 result        := lInCodeErreur = RC_PASERREUR ;

 if not result then
   NotifyError( lInCodeErreur , '' ) ;

end;

function TTOBEcriture.IsValidEcrANouveau : boolean;
var
 lInCodeErreur : integer ;
begin

 CheckInfo ;

 lInCodeErreur := CIsValidEcrANouveau(self,Info) ;
 result        := lInCodeErreur = RC_PASERREUR ;

 if not result then
   NotifyError( lInCodeErreur , '' ) ;

end;

function TTOBEcriture.IsValidModeSaisie : boolean ;
var
 lInCodeErreur : integer ;
begin

 CheckInfo ;

 lInCodeErreur := CIsValidModeSaisie(self,Info) ;
 result        := lInCodeErreur = RC_PASERREUR ;

 if not result then
   NotifyError( lInCodeErreur , '' ) ;

end;

function TTOBEcriture.IsValidPeriodeSemaine : boolean;
begin
 Result := ( NumSemaine(GetValue('E_DATECOMPTABLE')) = GetValue('E_SEMAINE') ) and
           ( GetPeriode(GetValue('E_DATECOMPTABLE')) = GetValue('E_PERIODE') ) ;
 if not result then
  NotifyError( RC_NUMPERIODE , '' ) ;

end;


function TTOBEcriture.IsValidMontant( vRdMontant : double ) : boolean;
begin
 result := CIsValidMontant(vRdMontant) = RC_PASERREUR ;
end;

function TTOBEcriture.IsValidCredit : boolean;
begin
 result := IsValidMontant( GetValue('E_CREDIT') ) ;
end;

function TTOBEcriture.IsValidDebit : boolean;
begin
 result := IsValidMontant( GetValue('E_DEBIT') ) ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 02/10/2003
Modifi� le ... :   /  /    
Description .. : - LG - 02/10/2003 - on ne pouvait pas saisir un montant du 
Suite ........ : type 0.3
Mots clefs ... : 
*****************************************************************}
function TTOBEcriture.IsValidDebitCredit : boolean;
begin
 result := IsValidCredit and IsValidDebit and ( (GetValue('E_CREDIT') > 0 ) xor ( GetValue('E_DEBIT') > 0 ) ) ;
end;

procedure TTOBEcriture.PutDefautEcr;
begin
 CPutDefautEcr(self) ;
end;

procedure TTOBEcriture.RemplirInfoLettrage;
begin
 CRemplirInfoLettrage(self) ;
end;

procedure TTOBEcriture.RemplirInfoPointage;
begin
 CRemplirInfoPointage(self) ;
end;

procedure TTOBEcriture.SupprimerInfoLettrage;
begin
 CSupprimerInfoLettrage(self) ;
end;


procedure TTOBEcriture.CheckInfo ;
begin
 if PInfo = nil then
  begin
    MessageAlerte('La variable Info n''est pas initialis�e ! ') ;
    raise EAbort.Create('') ;
  end;
end;


procedure TTOBEcriture.CompleteInfo ;
begin

 {$IFDEF TT}
 AddEvenement('CompleteInfo');
{$ENDIF}

 CSetCotation(self) ;

 if Info.Compte.InIndex = - 1 then exit ; // le ligne n'est pas finis, on ne compleyt pas les infos de lettrage

 if ( AnsiUpperCase(Info.GetString('T_LETTRABLE')) = 'X' ) or ( Info.Compte.IsLettrable ) then
  begin
   PutValue('E_LETTRAGE','X') ;
   CRemplirInfoLettrage(self) ;
  end
   else
    CSupprimerInfoLettrage(self) ;

 if Info.compte.IsPointable then
  CRemplirInfoPointage(self) ;

 {$IFDEF COMPTA}
 if IsValidDebitCredit then
  begin
   CGetEch(Self , Info ) ;
   CGetTVA(Self,Info) ;
  end ;
  {$ENDIF}

end;


procedure TInfoEcriture.ClearSection;
begin
 FSection.Free ;
 FSection := TZSections.Create( FDossier ) ;
end;

function TInfoEcriture.GetSection: string;
begin
  result := FSection.GetValue('S_SECTION') ;
end;

function TInfoEcriture.LoadSection(vStSection, vStAxe: string ; vBoEnBase : boolean): boolean;
begin
  result := ( FSection.GetCompte( vStSection, vStAxe, vBoEnBase ) <> - 1  ) ;
end;

function TInfoEcriture.Section_GetValue(vStNom: string): variant;
begin

  result := #0 ;

  if ( FSection.InIndex = - 1 ) or ( trim(vStNom) = '' ) then
   begin
     NotifyError( RC_YSECTIONINEXIST, '' ) ;
     exit ;
   end; // if

  result := FSection.GetValue( vStNom ) ;

end;

procedure TInfoEcriture.LoadOpti(vStCompte, vStAux: string ; vTobSource : Tob );
begin
  if ( vStCompte <> '' ) then
    FCompte.GetCompteOpti( vStCompte , vTobSource ) ;
  if ( vStAux <> '' ) then
    FAux.GetCompteOpti( vStAux , vTobSource ) ;
end;


function CIsCarRecherche ( vValues : string ) : boolean ;
begin
 result := (vValues=RC_CODEFOU) or (vValues=RC_CODECLI) or (vValues=RC_CODECLIN) or (vValues=RC_CODEFOUN);
end;

{$IFNDEF EAGLSERVER}
{$IFNDEF ERADIO}
{***********A.G.L.***********************************************
Auteur  ...... : Laurent gendreau
Cr�� le ...... : 14/11/2002
Modifi� le ... :   /  /
Description .. : -14/111/2002 - utilisation de l fct CQuelRecherche
Mots clefs ... :
*****************************************************************}
constructor TRechercheGrille.Create ( vInfo : TInfoEcriture ) ;
begin

 Inherited Create(vInfo ) ;

 FTypeRech     := RechTous ;
 FStCarLookUp  := '' ;

 if Assigned( vInfo ) then
   vInfo.Aux.BoCodeOnly := GetParamSocSecur('SO_CPCODEAUXIONLY',false) ;

end;

procedure TRechercheGrille.NotifyGeneral ;
begin
 if Assigned(FOnChangeGeneral) then
  FOnChangeGeneral(PEcr) ;
end ;

procedure TRechercheGrille.NotifyAux ;
begin
 if Assigned(FOnChangeAux) then
  FOnChangeAux(PEcr) ;
end ;

(*procedure TRechercheGrille.QuelRecherche ;
begin
 (*if PEcr =  nil then exit ;

 FGrille   := THGrid(Sender) ;
 lStCompte := FGrille.Cells[FCOL_GEN, ARow] ;
 {$IFDEF EAGLCLIENT}
 if UpperCase(lStCompte) = 'ERREUR' then
  begin
   lStCompte                     := '' ;
   FGrille.Cells[FCOL_GEN, ARow] := '' ;
  end ;
 {$ENDIF}
 lStAux    := FGrille.Cells[FCOL_AUX, ARow] ;
 lStNat    := PEcr.GetString('E_NATUREPIECE') ;
 lStOldGen := PEcr.GetString('E_GENERAL') ;
 Cancel    := false ;

 if ( lStCompte = '' ) then
  exit ;

 Cancel    := true ;

 lBoExistGen := Info.LoadCompte(lStCompte) ;
 lRech       := CQuelRecherche(lStCompte,lStAux,lStNat) ;  

end ;*)

procedure TRechercheGrille.LookUpGen(Sender: TObject; var ACol,ARow: integer; var Cancel: boolean) ;
var
 lStSelect     : string ;
 lStColonne    : string ;
 lStOrder      : string ;
 lStWhere      : string ;
begin
 {$IFDEF TT}
 AddEvenement('LookUpGen');
 {$ENDIF}
 FGrille      := THGrid(Sender) ;
 ACol         := FCOL_GEN ;
 FGrille.Col  := FCOL_GEN ;
 CMakeSQLLookupGen(lStWhere,lStColonne,lStOrder,lStSelect,Info.TypeExo) ;
 Cancel := not LookupList(FGrille,TraduireMemoire('Comptes'),GetTableDossier(Info.Dossier, 'GENERAUX'),lStColonne,lStSelect,lStWhere,lStOrder,true, 1,'',tlLocate) ;
 if not Cancel then
  CellExitGen(Sender,ACol,ARow,Cancel) ;
end;


procedure TRechercheGrille.LookUpAux(Sender: TObject; var ACol,ARow: integer; var Cancel: boolean) ;
var
 lStCompte     : string ;
 lStNatureGene : string ;
begin
 {$IFDEF TT}
  AddEvenement('LookUpAux');
 {$ENDIF}
 FGrille      := THGrid(Sender) ;
 ACol         := FCOL_AUX ;
 FGrille.Col  := FCOL_AUX ;
 lStCompte    := FGrille.Cells[FCOL_GEN, ARow] ;

 if Info.LoadCompte(lStCompte) then
  lStNatureGene := Info.GetString('G_NATUREGENE')
   else
    lStNatureGene:='' ;

 FStCarLookUp := Copy(FGrille.Cells[FCOL_AUX, ARow],1,1) ; // FB 11938
 Cancel := not CLookupListAux( FGrille , FStCarLookUp ,PEcr.GetValue('E_NATUREPIECE'),lStNatureGene,GetTableDossier(Info.Dossier, 'TIERS')) ;
 if not Cancel then
  begin
   CellExitAux(Sender,ACol, ARow,Cancel) ;
   if not Cancel then
    FGrille.Col := FGrille.Col + 1 ;
  end ; // if

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 28/10/2002
Modifi� le ... : 07/09/2007
Description .. : - 28/10/2002 - on n'appelait pas la bonne fct
Suite ........ : -28/11/2002 - sur F5 on ouvre systematiquement la fentre
Suite ........ : lookup, on ne passe plus � la case suivante
Suite ........ : -29/11/2002 - fiche 10859 - la gestion des caracteres ne fct
Suite ........ : pas
Suite ........ : - 01/07/2003 - qd on a choisit l'auxiliaire on passe a lo
Suite ........ : colonne suivante
Suite ........ : - 06/10/2003 - FB 11938 - 0 + F5 ne fct pas ds la case des
Suite ........ : auxi
Suite ........ : - 12/08/2004 - FB 13941 - sur F5 ds la case des auxi, on
Suite ........ : recuperais les info du compte de la ligne sup�rieur
Suite ........ : - 20/09/2005 - LG  - on bloque le deplacement si le compte
Suite ........ : choisit n'est aps correct ( les comptes vise apparaissent ds
Suite ........ : le lookup, mais on ne doit pas ce deplacer de la case des
Suite ........ : generaux )
Suite ........ : - le echap sur le lookup passait a la ligne suivante
Suite ........ : - LG - FB 21384 - 02/07/2007 - branchement de la recher 
Suite ........ : par auxi ds le case des gene sur le F5
Mots clefs ... : 
*****************************************************************}
function TRechercheGrille.ElipsisClick(Sender: TObject ; vBoAvecDeplacement : boolean = true ) : boolean ;
var
 ARow          : integer ;
 ACol          : integer ;
 lCancel       : boolean ;
 lStCompte     : string ;
 lStAux        : string ;
 lStNat        : string ;
 lBoExistGen   : boolean ;
 lRech         : TTypeRechGen ;
begin

 {$IFDEF TT}
 AddEvenement('ElipsisClick');
{$ENDIF}

 Result       := false ;
 if PEcr = nil then exit ;

 FGrille      := THGrid(Sender) ;
 ARow         := FGrille.Row ;
 ACol         := FGrille.Col ;

 lStCompte    := FGrille.Cells[FCOL_GEN, ARow] ;
 lStAux       := FGrille.Cells[FCOL_AUX, ARow] ;
 lStNat       := PEcr.GetString('E_NATUREPIECE') ;
 lBoExistGen  := Info.LoadCompte(lStCompte) ;
 lRech        := CQuelRecherche(lStCompte,lStAux,lStNat) ;

 if not lBoExistGen and ( lRech = RechAux ) then
  begin
   FGrille.Cells[FCOL_GEN, ARow]  := '' ;
   FGrille.Cells[FCOL_AUX, ARow]  := lStAux ;
   FGrille.Row                    := ARow ;
   FGrille.Col                    := FCOL_AUX ;
   ACol                           := FCOL_AUX ;
   FocusControl                   := ControlAux ;
   LookUpAux(FGrille,ACol,ARow,lCancel) ;
  end
   else
    if FGrille.Col = FCOL_GEN then
     LookUpGen(FGrille,ACol,ARow,lCancel)
      else
        if FGrille.Col = FCOL_AUX then
         LookUpAux(FGrille,ACol,ARow,lCancel) ;

 Result := not lCancel ;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 06/04/2004
Modifi� le ... : 04/06/2007
Description .. : - LG FB 13372 - 06/04/2004 - on ouvre pas le lookup qd on
Suite ........ : va sur la gauche
Suite ........ : - LG - FB 20154 - traitement particulier des erreurs WA
Mots clefs ... : 
*****************************************************************}
procedure TRechercheGrille.CellExitGen(Sender: TObject; var ACol,ARow: integer; var Cancel: boolean) ;
var
 lStCompte    : string ;
 lStAux       : string ;
 lStNat       : string ;
 lBoExistGen  : boolean ;
 lRech        : TTypeRechGen ;
 lInError     : integer ;
 lStOldGen    : string ;
begin

 {$IFDEF TT}
  AddEvenement('CellExitGen');
{$ENDIF}

 if PEcr =  nil then exit ;

 FGrille   := THGrid(Sender) ;
 lStCompte := FGrille.Cells[FCOL_GEN, ARow] ;
 {$IFDEF EAGLCLIENT}
 if UpperCase(lStCompte) = 'ERREUR' then
  begin
   lStCompte                     := '' ;
   FGrille.Cells[FCOL_GEN, ARow] := '' ;
  end ;
 {$ENDIF}
 lStAux    := FGrille.Cells[FCOL_AUX, ARow] ;
 lStNat    := PEcr.GetString('E_NATUREPIECE') ;
 lStOldGen := PEcr.GetString('E_GENERAL') ;
 Cancel    := false ;

 if ( lStCompte = '' ) then
  exit ;

 Cancel    := true ;

 lBoExistGen := Info.LoadCompte(lStCompte) ;
 lRech       := CQuelRecherche(lStCompte,lStAux,lStNat) ;

 if not lBoExistGen and ( lRech = RechAux ) then
  begin
   FGrille.Cells[FCOL_GEN, ARow]  := '' ;
   FGrille.Cells[FCOL_AUX, ARow]  := lStAux ;
   FGrille.Row                    := ARow ;
   FGrille.Col                    := FCOL_AUX ;
   ACol                           := FCOL_AUX ;
   FocusControl                   := ControlAux ;
   PostMessage(FGrille.Handle, WM_KEYDOWN,VK_TAB, 0) ; // declencehe un cellExitAux
   exit ;
  end ;

 if not lBoExistGen and ( lRech = RechGen ) then
  begin
   LookUpGen(Sender,Acol,ARow,Cancel) ;
   exit ;
  end ;

 // le compte existe
 lStCompte := Info.StCompte ;
 PEcr.PutValue('E_GENERAL' , Info.StCompte) ;

 lInError := CIsValidCompte(PEcr,Info) ;

 if ( lInError = RC_AUXINEXISTANT ) or ( lInError = RC_AUXOBLIG ) then
  begin
   FocusControl := ControlAux ;
   ACol         := FCOL_AUX ;
   FGrille.Col  := FCOL_AUX ;
   FGrille.Cells[FCOL_GEN, ARow] := lStCompte ;
  end
   else
    if lInError <> RC_PASERREUR then
     begin
      FocusControl                   := ControlGen ;
      ACol                           := FCOL_GEN ;
      FGrille.Cells[FCOL_GEN, ARow]  := '' ;
      NotifyError(lInError,'') ;
      PostMessage(FGrille.Handle, WM_KEYDOWN, VK_F5, 0) ; // balance un LookUpGen
      exit ;
     end
      else
       begin
        FGrille.Cells[FCOL_GEN, ARow] := lStCompte ;
        Cancel                        := false ;
       end ;

 if lStOldGen <> PEcr.GetString('E_GENERAL') then
  NotifyGeneral ;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 04/06/2007
Modifi� le ... : 10/09/2007
Description .. : - LG - FB 20154 - traitement particulier des erreurs WA
Suite ........ : - LG - FB 10824 - utilisation du parametre v_pgi.lookupdate 
Suite ........ : pour forcer l'affichage du lookup
Mots clefs ... : 
*****************************************************************}
procedure TRechercheGrille.CellExitAux(Sender: TObject; var ACol, ARow: integer; var Cancel: boolean);
var
 lStCompte      : string ;
 lStAux         : string ;
 lStNat         : string ;
 lBoExistAux    : boolean ;
 lInError       : integer ;
 lBoCodeOnly    : boolean ;
 lBoLibOnly     : boolean ;
 lBoBourrage    : boolean ;
 lStOldGen      : string ;
 lStOldAux      : string ;
begin
 {$IFDEF TT}
 AddEvenement('TRechercheGrille.CellExitAux');
{$ENDIF}

 if PEcr = nil then exit ;

 {$IFNDEF EAGLSERVER}
 CDecodeKeyForAux(FInKey,FShift,lBoCodeOnly,lBoLibOnly,lBoBourrage) ;
 {$ENDIF}
 Info.Aux.BoCodeOnly       := lBoCodeOnly ;
// Info.Aux.BoLibelleOnly    := lBoLibOnly ;
 Info.Aux.BoBourrageCode   := lBoBourrage ;

 FGrille                   := THGrid(Sender) ;
 lStCompte                 := FGrille.Cells[FCOL_GEN, ARow] ;
 lStAux                    := FGrille.Cells[FCOL_AUX, ARow] ;
 lStNat                    := PEcr.GetString('E_NATUREPIECE') ;
 lStOldGen                 := PEcr.GetString('E_GENERAL') ;
 lStOldAux                 := PEcr.GetString('E_AUXILIAIRE') ;
 Cancel                    := true ;

 {$IFDEF EAGLCLIENT}
 if UpperCase(lStAux) = 'ERREUR' then
  begin
   lStCompte                     := '' ;
   FGrille.Cells[FCOL_AUX, ARow] := '' ;
  end ;
 {$ENDIF}

 Info.LoadCompte(lStCompte) ;
 lBoExistAux               := Info.LoadAux(lStAux) ;

 if not lBoExistAux then //or ( V_PGI.LookUpLocate and ( length(lStaux) < VH^.Cpta[fbGene].Lg ) ) then
  begin
   if ( CGetGridSens(FGrille,ACol,Arow) = RC_GAUCHE_DROITE ) then
    begin
     FGrille.Row := ARow ;
     LookUpAux(Sender,ACol,ARow,Cancel) ;
    end
     else
      begin
       FGrille.Cells[FCOL_AUX, ARow] := '' ;
       Cancel := false ;
      end ;
   exit ;
  end ;

 FGrille.Cells[FCOL_GEN, ARow] := Info.StCompte ;
 FGrille.Cells[FCOL_AUX, ARow] := Info.StAux ;
 PEcr.PutValue('E_GENERAL'    , Info.StCompte) ;
 PEcr.PutValue('E_AUXILIAIRE' , Info.StAux) ;

 lInError := CIsValidAuxEnSaisie(PEcr,Info) ;
 _CTestCodeErreur(lInError,Info) ;

 if lInError in [RC_PARAMAUX,RC_CINTERDIT,RC_CNATURE,RC_CFERMESOLDE] then
  begin
   FocusControl                  := ControlAux ;
   ACol                          := FCOL_AUX ;
   FGrille.Cells[FCOL_AUX, ARow] := '' ;
   NotifyError(lInError,'') ;
   exit ;
  end
   else
    if lInError <> RC_PASERREUR then
     begin
      FocusControl := ControlAux ;
      ACol         := FCOL_AUX ;
      NotifyError(lInError,'') ;
      exit ;
     end ;

 FGrille.Cells[FCOL_GEN, ARow] := PEcr.GetValue('E_GENERAL') ;
 FGrille.Cells[FCOL_AUX, ARow] := PEcr.GetValue('E_AUXILIAIRE') ;
 ACol                          := ACol + 1 ;
 Cancel                        := false ;

 if lStOldGen <> PEcr.GetString('E_GENERAL') then
  NotifyGeneral ;

 if lStOldAux <> PEcr.GetString('E_AUXILIAIRE') then
  NotifyAux ;

end;


{$ENDIF !ERADIO}
{$ENDIF}


{ TMessageCompta }
{***********A.G.L.***********************************************
Auteur  ...... : St�phane BOUSSERT
Cr�� le ...... : 11/02/2003
Modifi� le ... :   /  /
Description .. : Nouveau Param�tre :
Suite ........ :   - vTypeMsg, indentifie le contexte concern� :
Suite ........ :        msgSaisieBor :    Saisie bordereau
Suite ........ :        msgSaisiePiece :  Saisie pi�ce
Suite ........ :        msgSaisieLibre :  Saisie libre
Suite ........ :        msgSaisieAnal :   Saisie Analityque
Suite ........ :        ..... C.F. TTypeMessage  ...
Mots clefs ... :
*****************************************************************}
constructor TMessageCompta.Create( vStTitre : string ; vTypeMsg : TTypeMessage ) ;
begin
 FStTitre      := vStTitre ;
 FListeMessage := HTStringList.Create ;
 case vTypeMsg of
   msgSaisieBor     : CInitMessageBor(FListeMessage) ;
   msgSaisiePiece   : CInitMessagePiece(FListeMessage) ;
//   msgSaisieLibre
//   msgSaisieAnal
 end ;
end;

destructor TMessageCompta.Destroy;
begin
 FListeMessage.Clear ;
 if assigned( FListeMessage ) then
  begin
   FListeMessage.Free ;
   FListeMessage := nil ;
  end; // if
 inherited;
end;

function TMessageCompta.Execute( RC_Numero : integer ) : integer;
begin
 if RC_Numero = RC_PASERREUR then
  result:=0
   else
    result := CPrintMessageRC(FStTitre,RC_Numero,FListeMessage ) ;
end;

function TMessageCompta.GetMessage(RC_Numero: integer) : string;
begin
 result := CGetMessageRC(RC_Numero,FListeMessage ) ;
end;


function TInfoEcriture.GetModePaie: TZModePaiement;
begin
 if FModePaie = nil then
  begin
   FModePaie := TZModePaiement.Create( FDossier ) ;
   result  := FModePaie ;
  end
   else
    result := FModePaie ;
end;

function TInfoEcriture.GetModeRegle: TZModeReglement;
begin
 if FModeRegle = nil then
  begin
   FModeRegle := TZModeReglement.Create( FDossier ) ;
   result  := FModeRegle ;
  end
   else
    result := FModeRegle ;
end;

function TInfoEcriture.LoadModePaie(vStCode: string; vBoEnBase: boolean): boolean;
begin
  result := ( ModePaie.Load( [ vStCode ], vBoEnBase) <> - 1  ) ;
end;

function TInfoEcriture.LoadModeRegle( vStCode : string; vBoEnBase: boolean): boolean;
begin
  result := ( ModeRegle.Load( [ vStCode ], vBoEnBase) <> - 1  ) ;
end;

{ TZList }

constructor TZList.Create( vDossier : String = '');
begin
 if vDossier <> '' then
  FDossier := vDossier
   else
    FDossier := V_PGI.SchemaName ;
 FTOB      := TOB.Create('',nil,-1) ;
 FInIndex  := -1 ;
 Initialize ;
end;

destructor TZList.Destroy;
begin
try
 if assigned(FTOB) then FTOB.Free ;
finally
 FTOB := nil ;
end;
inherited;
end;


function TZList.MakeTOB ( vBoEnBase : boolean = false ) : TOB;
begin
 if vBoEnBase and ( FInIndex > - 1 ) and ( FInIndex <= FTOB.Detail.Count - 1 ) then
  result := FTOB.Detail[FInIndex]
   else
    begin
     result := TOB.Create(FStTable,FTOB,-1) ;
     result.AddChampSup('CRIT',false) ;
     result.AddChampSupValeur('TAG','',false) ;
     FInIndex:=FTOB.Detail.Count-1 ;
    end ;
end;


function TZList.GetCount: Integer;
begin
 result := FTOB.Detail.Count - 1 ;
end;

function TZList.GetTOB : TOB;
begin
 result:=GetTOBByIndex(FInIndex);
end;

function TZList.GetTOBByIndex(Index : integer) : TOB;
begin
 result:=nil ;
 if (Index<>-1) and (Index<=GetCount) then begin result:=FTOB.Detail[Index] ; FInIndex:=Index ; end ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 09/11/2006
Modifi� le ... :   /  /
Description .. : - FB 18508 - 09/11/2006 - qd on remettait la liste a jour, le 
Suite ........ : findex depasse le count ( fonctionnement change en v800 )
Mots clefs ... : 
*****************************************************************}
function TZList.GetValue(Name : string ; Index : integer=-1): Variant;
begin
 Result:=#0 ;
 if (Index<>-1) and (Index<=Count) then FInIndex:=Index ;
 if (FTOB<>nil) and (FInIndex<>-1) and (FInIndex<=Count) then
  Result:=FTOB.Detail[FInIndex].GetValue(Name) ;
end;

function TZList.GetString(Name : string ; Index : integer=-1): string ;
begin
 result := GetValue(Name,Index) ;
 if result = #0 then
  result := '' ;
end;

procedure TZList.PutValue(Name: string; Value: Variant);
begin
 if (FTOB<>nil) and (FInIndex<>-1) then FTOB.Detail[FInIndex].PutValue(Name, Value) ;
end;

procedure TZList.PutValueByIndex(Name: string; Value: Variant;Index: integer);
begin
 if (Index<0) or (Index>Count) then exit ;
 FInIndex:=Index ; PutValue(Name,Value) ;
end;

function TZList.Load(const Values : array of string ; vBoEnBase : boolean = false) : integer;
var
 lStCode : string ;
 i       : integer ;
begin
 Result:=-1 ; if (SizeOf(Values)=0) then exit ; lStCode:='' ;
 for i:=low(Values) to High(Values) do lStCode:=lStCode+Values[i] ; lStCode:=UpperCase(lStCode) ;
 if GetValue('CRIT')=lStCode then // on commence directement par l'index
  Result:=FInIndex
   else
    for i:=0 to FTOB.Detail.Count-1 do
     if FTOB.Detail[i].GetValue('CRIT')=lStCode then begin FInIndex:=i ; Result:=FInIndex ; Exit ; end ;
end;

procedure TZList.SetCrit(vTOB : TOB; const Values : array of string);
var
 lStCode : string ;
 i : integer ;
begin
 for i:=low(Values) to High(Values) do lStCode:=lStCode+Values[i] ; lStCode:=UpperCase(lStCode) ;
 vTOB.PutValue('CRIT',lStCode) ;
end;

procedure TZList.Clear ;
begin
 FTOB.ClearDetail ;
 FInIndex := - 1 ;
end;



{ TZScenario }
constructor TZScenario.Create ( vDossier : String = '' ) ;
begin
 inherited ;
  if vDossier <> '' then
  FDossier := vDossier
   else FDossier := V_PGI.SchemaName ;
 FListe:= HTStringList.Create ;
end;

destructor TZScenario.Destroy;
begin
 try
  if Assigned(FMemo)  then FMemo.Free ;
  if assigned(FListe) then FListe.Free;
 finally
  FMemo:=nil ; FListe:=nil ;
 end;
 inherited;
end;


procedure TZScenario.Initialize;
begin
 FStTable :='SUIVCPTA' ;
end;

function TZScenario.GetMemo : HTStringList;
begin
// result:=nil ;
 if not Assigned( FMemo ) then
   FMemo:=HTStringList.Create ;
 FMemo.Clear ;
 FMemo.Text := Item.GetString('SC_ATTRCOMP') ;
 result:=FMemo ;
end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 20/09/2002
Modifi� le ... : 04/11/2002
Description .. : -20/09/2002- modif du fct de base. tous element qui 
Suite ........ : n'existe pas et stocke. On commence la recherche par
Suite ........ : rechercher dans la liste des elements inexistants
Suite ........ : -04/11/2002- initlialisation de la stringlist
Mots clefs ... : 
*****************************************************************}
function TZScenario.Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer;
var
 lStJournal,lStNature,lStQualifpiece,lStEta,lStCrit : string ;
 lTOB : TOB ;
 lMemoComp : HTStringList;
 i : integer;
begin
 result:=-1 ; if length(Values)<>4 then exit ;
 lStJournal:=Values[0] ; lStNature:=Values[1] ; lStQualifpiece:=Values[2] ; lStEta:=Values[3] ;
 lStCrit:=lStJournal+lStNature+lStQualifpiece+lStEta ;
 for i:=0 to FListe.Count-1 do if FListe[i]=lStCrit then exit ; // le code n'existe pas
 Result:= Inherited Load(Values,vBoEnBase) ; if result<>-1 then exit ; if length(Values)<>4 then exit ;
 lTOB := MakeTOB ; lMemoComp:=nil ; // on n'utilise pas la stringlist
 if not COuvreScenario(lStJournal,lStNature,lStQualifPiece,lStEta,lTOB,lMemoComp,FDossier) then
  begin
   FListe.Add(lStCrit) ; // on stocke le fait qu'il n'existe pas de scenario pour ce guide
   lTOB.Free ;
   exit ;
  end ;
 SetCrit(lTOB,Values) ;
 result := FTOB.Detail.Count - 1 ; FInIndex := result ;
end;


procedure TZScenario.Clear;
begin
  inherited;
  FListe.Clear ;
end;

{ TZListJournal }

function TZListJournal.MakeTOB ( vBoEnBase : boolean = false ) : TOB;
begin
 result := inherited MakeTOB(vBoEnBase) ;
 result.AddChampSupValeur('NBAUTO',-1,false) ;
end;


procedure TZListJournal.Initialize;
begin
 FStTable :='JOURNAL' ;
end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 14/02/2002
Modifi� le ... : 14/02/2002
Description .. : chargement des info du journal :
Suite ........ : - soit depuis la tob journal s'ila d�j� �t� charger
Suite ........ : - soit depuis la base
Suite ........ : et place le pointeur de ligne courant sur cette ligne
Mots clefs ... :
*****************************************************************}
function TZListJournal.Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ;
var
lStCode : string ; lTOB : TOB ;
Q : TQuery ;
begin
Result:=inherited Load(Values,vBoEnBase) ; if not vBoEnBase and ( result<>-1 ) then exit ; if SizeOf(Values)=0 then exit ;
lStCode:=Values[0] ; if Trim(lStCode)='' then exit ; Q:=nil ;
try
 Q:=OpenSelect('SELECT * FROM JOURNAL WHERE J_JOURNAL="'+UpperCase(lStCode)+'"',FDossier) ;
 if not Q.EOF then
  begin
   lTOB:=MakeTOB(vBoEnBase) ;
   lTOB.SelectDB('',Q) ; SetCrit(lTOB,Values) ; result := FInIndex ;
  end;
finally
 Ferme(Q) ;
end; /// try
end ;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 14/02/2002
Modifi� le ... :   /  /
Description .. : retourne le prochain numero de piece du journal en fonction
Suite ........ : de la date comptable
Mots clefs ... :
*****************************************************************}
function TZListJournal.GetNumJal(vDtDateComptable : TDateTime) : integer;
begin
 result:=GetNewNumJal(GetValue('J_JOURNAL'),true,vDtDateComptable,GetValue('J_COMPTEURNORMAL'),GetValue('J_MODESAISIE'));
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 14/02/2002
Modifi� le ... :   /  /
Description .. : Retourne le nom de la tablette pour la nature de piece ne
Suite ........ : fonction du type de journal
Mots clefs ... :
*****************************************************************}
function TZListJournal.GetTabletteNature : string;
begin
 case CaseNatJal(GetValue('J_NATUREJAL')) of
  tzJVente       : result:='ttNatPieceVente' ;
  tzJAchat       : result:='ttNatPieceAchat' ;
  tzJBanque      : result:='ttNatPieceBanque' ;
  tzJEcartChange : result:='ttNatPieceEcartChange' ;
  tzJOD          : result:='ttNaturePiece' ;
 end ; // case
end;

function TZListJournal.GetNatureParDefaut : string;
begin
 result := GetValue('J_NATDEFAUT') ;
 if trim(result) <> '' then exit ;
 case CaseNatJal(GetValue('J_NATUREJAL')) of
  tzJVente       : Result:='FC' ;
  tzJAchat       : Result:='FF' ;
  tzJBanque      : Result:='OD' ;
  tzJEcartChange : Result:='OD' ;
  tzJOD          : Result:='OD' ;
 end ; // case
end;

function TZListJournal.GetNombreDeCompteAuto : integer ;
var
 lStCompteAuto : string ;
begin
 if GetValue('NBAUTO') = - 1 then
  begin
   lStCompteAuto := GetValue('J_COMPTEAUTOMAT') ;
   result        := 0 ;
   while ReadTokenSt(lStCompteAuto) <> '' do Inc(result) ;
   PutValue('NBAUTO',result) ;
  end ;
 result := GetValue('NBAUTO') ;
end;

function TZListJournal.isJalBqe : boolean;
begin
 result := UpperCAse(GetValue('J_NATUREJAL')) = 'BQE' ;
end;

function TZListJournal.GetCompteAuto : string;
begin
 result := GetValue('J_COMPTEAUTOMAT') ;
 if length(trim(GetValue('J_CONTREPARTIE'))) <> 0 then
  result := GetValue('J_CONTREPARTIE') + ';' ;
end;

{ TZDevise }

function TZDevise.GetRecDevise : RDevise ;
begin
 FillChar(result,SizeOf(RDevise),#0) ;
 if Item = nil then
  begin
   MessageAlerte('GetRecDevise : Devise inconnue ') ;
   exit ;
  end;
 CTOBVersRDevise( Item , result ) ;
end;

function TZDevise.Load(const Values : array of string ; vBoEnBase : boolean = false) : integer ;
var lRecDevise : RDevise ; lTOB : TOB ; lStCode : string ;
begin
 FillChar(lRecDevise,Sizeof(lRecDevise),#0) ;
 Result := Inherited Load(Values,vBoEnBase) ; if not vBoEnBase and (result<>-1) then exit ;
 lStCode:=Values[0] ; if trim(lStCode)='' then exit ;
 lRecDevise.Code := lStCode ;
 GETINFOSDEVISE( lRecDevise, FDossier ) ;
 if lRecDevise.Code = V_PGI.DevisePivot then
  lRecDevise.Taux := 1 ;
 lTOB:=MakeTOB(vBoEnBase) ;
 CRDeviseVersTOB(lRecDevise,lTOB) ;
 SetCrit(lTOB,Values) ;
 result := FInIndex ;
end ;

procedure TZDevise.Initialize;
begin
 FStTable        := 'DEVISE' ;
end;

procedure TZDevise.AffecteTaux( vDtDateComptable : TDateTime ; vBoEnBase : boolean ) ;
var
 lRecDevise : RDevise ;
begin
 if ( Item = nil ) or ( not vBoEnBase and (vDtDateComptable = VarToDateTime(Item.GetValue('DATEC')))) then exit ;
 Item.PutValue('DATEC' , vDtDateComptable );
 CTOBVersRDevise(Item,lRecDevise) ;
 lRecDevise.Taux :=  GetTaux(lRecDevise.Code,lRecDevise.DateTaux,vDtDateComptable) ;
 CRDeviseVersTOB(lRecDevise,Item) ;
end;

function TZDevise.MakeTOB( vBoEnBase : boolean = false ) : TOB;
begin
 result := inherited MakeTOB(vBoEnBase) ;
 if not vBoEnBase then
  begin
   result.AddChampSup('TAUX'     , false) ;
   result.AddChampSup('DATETAUX' , false) ;
   result.AddChampSupValeur('DATEC'    , iDate1900 , false) ;
  end ;
end;

function TZDevise.GetTauxReel( vDtDateComptable : TDateTime ; var vDtDateTaux : TDateTime ; vBoEnBase: boolean): Double;
var lTob    : tob ;
//    lBoLoad : boolean ;
begin
  result := 1.0 ;

  if not Assigned( Item ) then Exit ;
  if Item.GetString('D_DEVISE')=V_PGI.DevisePivot then Exit ;
//  if Item.Detail.count = 0 then Exit ;

  if vBoEnBase then
    Item.ClearDetail ;

  // recherche taux deja charg�
  lTob := GetTobTaux( vDtDateComptable ) ;

  // recherche taux en base si nessaire
  //lBoLoad :=
  LoadTaux( vDtDateComptable, lTob ) ;

  if Assigned(lTob) then
    begin
    result      := lTob.GetDouble('H_TAUXREEL') ;
    vDtDateTaux := lTob.GetDateTime('H_DATECOURS') ;
    end ;

end;

procedure TZDevise.SetTauxVolatil(vDtDateComptable: TDateTime; vDev : RDevise );
var lTobH : Tob ;
begin
  lTobH := GetTobTaux( vDtDateComptable ) ;
  if Assigned( lTobH ) then
    begin
    if lTobH.GetDateTime('H_DATECOURS')<>vDtDateComptable then
      begin
      lTobH := Tob.Create('CHANCELL',  Item,   lTobH.GetIndex + 1 ) ;
      lTobH.PutValue('H_DEVISE',       Item.GetString('D_DEVISE') ) ;
      lTobH.PutValue('H_DATECOURS',    vDtDateComptable);
      // Maj des champs de gestion
      lTobH.AddChampSupValeur('DATEC', vDtDateComptable ) ;
      lTobH.AddChampSup('VOLATIL',    False ) ;
      end ;
    end
  else
    begin
    lTobH := Tob.Create('CHANCELL',  Item,   0 ) ;
    lTobH.PutValue('H_DEVISE',       Item.GetString('D_DEVISE') ) ;
    lTobH.PutValue('H_DATECOURS',    vDtDateComptable);
    // Maj des champs de gestion
    lTobH.AddChampSupValeur('DATEC', vDtDateComptable ) ;
    lTobH.AddChampSup('VOLATIL',    False ) ;
    end ;

  lTobH.PutValue('H_TAUXREEL',     vDev.Taux) ;
  lTobH.PutValue('H_COTATION',     vDev.Cotation) ;

  // Maj des champs de gestion
  lTobH.PutValue('VOLATIL',       'X' ) ;

end;

function TZDevise.GetTobTaux(vDtDateComptable: TDateTime ; vBoExact : boolean = false ): Tob;
var i : integer ;
begin
  result := nil ;

  if Item.GetString('D_DEVISE')=V_PGI.DevisePivot then Exit ;
  if Item.Detail.count = 0 then Exit ;

  for i := item.Detail.Count-1 downto 0 do
    if item.Detail[i].GetDateTime('H_DATECOURS')<=vDtDateComptable then
      begin
      if vBoExact and (item.Detail[i].GetDateTime('H_DATECOURS')<vDtDateComptable) then Exit ;
      result := item.Detail[i] ;
      break ;
      end ;

end;

function TZDevise.LoadTaux( vDtDateComptable: TDateTime ; var vTobResult : Tob ) : boolean ;
var lStReq     : string ;
    lDtDateMin : TDateTime ;
    lTob       : Tob ;
    lStCode    : string ;
    lQReq      : TQuery ;
begin

  result := False ;

  if not Assigned( Item ) then Exit ;
  lStCode := Item.GetString('D_DEVISE') ;
  if lStCode = V_PGI.DevisePivot then Exit ;

  if Assigned( vTobResult ) then
    begin
    if vDtDateComptable <= vTobResult.GetDateTime('DATEC') then Exit ;
    lDtDateMin := vTobResult.GetDateTime('H_DATECOURS') ;
    end
  else lDtDateMin := V_PGI.DateDebutEuro ;

  lStReq := 'SELECT ##TOP 1## * FROM CHANCELL WHERE H_DEVISE = "' + lStCode + '"'
              + ' AND H_DATECOURS <= "' + UsDateTime(vDtDateComptable) + '"'
              + ' AND H_DATECOURS > "'  + UsDateTime(lDtDateMin)       + '"'
                + ' ORDER BY H_DATECOURS DESC' ;
  lQReq := OpenSql( lStReq , True ,-1,'',true) ;

  if not lQReq.Eof then
    begin
    // comparaison avec tob deja charg�e
    if Assigned( vTobResult )
      then lTob := Tob.Create('CHANCELL', Item, vTobResult.GetIndex+1 )
      else lTob := Tob.Create('CHANCELL', Item, 0 ) ;
    // chargement des donn�es
    lTOb.SelectDB('', lQReq ) ;
    // Maj des champs de gestion
    lTob.AddChampSupValeur('DATEC',       vDtDateComptable ) ;
    lTob.AddChampSupValeur('VOLATIL',   '-' ) ;

    // R�sultats
    vTobResult := lTob ;
    result     := True ;
    end
  else
    if Assigned( vTobResult ) then
      vTobResult.PutValue('DATEC', vDtDateComptable ) ;

  Ferme(lQReq) ;

end ;


function TZDevise.EstTauxVolatil(vDtDateComptable: TDateTime): boolean;
var lTobH : Tob ;
begin
  result := False ;
  lTobH := GetTobTaux( vDtDateComptable ) ;
  if Assigned( lTobH ) then
    result := lTobH.GetString('VOLATIL')= 'X' ;
end;

{ TZTier }

procedure TZTier.Initialize;
begin
 FStTable        := 'TIERS' ;
 FBoCodeOnly     := True ; // activation du paramsoc uniquement en saisie !!! GetParamSocSecur('SO_CPCODEAUXIONLY',false) ;
 FBoLibelleOnly  := false ;
 FBoBourrageCode := true ;
end;

function TZTier.GetCompte(var NumCompte : string ; vBoEnBase : boolean = false) : Integer;
begin
 result   := Load([NumCompte],vBoEnBase) ;
 FInIndex := result ;
 if result <> -1 then
  NumCompte := GetValue('T_AUXILIAIRE') ;
end;

function TZTier.MakeTOB( vBoEnBase : boolean = false ) : TOB;
begin
 result := inherited MakeTOB(vBoEnBase) ;
 result.AddChampSup('_SOLDED',false) ;
 result.AddChampSup('_SOLDEC',false) ;
end;

function TZTier.LoadFromList(const Values : array of string) : integer;
var
 lStCode : string ;
 i : integer ;
begin
 Result:=-1 ; if (SizeOf(Values)=0) then exit ; lStCode:='' ;
 for i:=low(Values) to High(Values) do lStCode:=lStCode+Values[i] ; lStCode:=UpperCase(lStCode) ;
 for i:=0 to FTOB.Detail.Count-1 do
  if FTOB.Detail[i].GetValue('CRIT')=lStCode then begin FInIndex:=i ; Result:=FInIndex ; Exit ; end ;
 if FBoCodeOnly then exit ;
 for i:=0 to FTOB.Detail.Count-1 do
  if (Pos(Values[0],FTOB.detail[i].GetValue('T_LIBELLE'))>0) or
     (Pos(UpperCase(Values[0]),FTOB.detail[i].GetValue('T_LIBELLE'))>0) then
      begin  FInIndex:=i ; result:=FInIndex ; exit ; end ;
end;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent gendreau
Cr�� le ...... : 17/10/2002
Modifi� le ... : 18/05/2006
Description .. : - 17/10/2002 - on fait une recherche approche pour le
Suite ........ : libelle
Suite ........ : - 18/05/2006 - changement du test pour deetcter els base 
Suite ........ : oracle/db2
Mots clefs ... : 
*****************************************************************}
function TZTier.Load(const Values : array of string ; vBoEnBase : boolean = false ) : integer;
var
 lAValues : array of string ;
 i : integer ;
 lQ : TQuery ;
 lStSQL : string ;
 lTOB : TOB ;
begin

 result:=-1 ; if trim(Values[0])='' then exit ; SetLength(lAValues,1) ; lAValues[0]:=Values[0] ;

 try

  if FBoBourrageCode then lAValues[0]:=BourreLaDonc(lAValues[0] , fbAux) ;

  Result:=LoadFromList(lAValues) ;
  if not vBoEnBase and ( result <> -1 ) then exit ;
  // YM 02/09/2005 Prise en compte de DB2 FQ 16525
  if isOracle or isDB2 then
   lStSQL:= 'select TIERS.*,YTC_SCHEMAGEN,YTC_ACCELERATEUR FROM TIERS LEFT OUTER JOIN TIERSCOMPL ON T_AUXILIAIRE=YTC_AUXILIAIRE '
    else
     begin
      lStSQL:=CGetSQLFromTable('TIERS',['T_EMAIL','T_BLOCNOTE','T_RVA'],true) ; // construit le texte de la requete sql sans les champs passe en parametre
      lStSQL:=lStSQL+',YTC_SCHEMAGEN,YTC_ACCELERATEUR FROM TIERS LEFT OUTER JOIN TIERSCOMPL ON T_AUXILIAIRE=YTC_AUXILIAIRE ' ;
     end ;

  if not FBoLibelleOnly then
   BEGIN
    lQ:=nil ;
    try
     lQ:=OpenSelect(lStSQL+' WHERE T_AUXILIAIRE="'+lAValues[0]+'" ',FDossier) ;
     if not lQ.EOF then
      begin
       lTOB:=MakeTOB(vBOEnBase) ;
       lTOB.SelectDB('',lQ) ;
       SetCrit(lTOB,lAValues) ;
       lTOB.PutValue('T_AUXILIAIRE',lQ.FindField('T_AUXILIAIRE').asString) ;
       if (VarType(lQ.FindField('YTC_ACCELERATEUR').Asvariant) = VarNull) or (VarType(lQ.FindField('YTC_ACCELERATEUR').Asvariant) = VarEmpty) then
        lTOB.PutValue('YTC_ACCELERATEUR','-') ;
       lTOB.PutValue('_SOLDED',-1) ;
       lTOB.PutValue('_SOLDEC',-1) ;
       // Gestion des cumuls en multisoc
       CChargeCumulsMS( fbAux, lTOB.GetString('T_AUXILIAIRE') , '', lTOB, FDossier ) ;
       result:=FInIndex ; exit ;
      end;
    finally
     Ferme(lQ) ;
    end; // try
   END ; // not FBoLibelleOnly

  if FBoCodeOnly then exit ; // on recherche par code uniquement -> on sort de la fonction

  for i:=0 to FTOB.Detail.Count-1 do
   if (Pos(Values[0],FTOB.detail[i].GetValue('T_LIBELLE'))>0) or
      (Pos(UpperCase(Values[0]),FTOB.detail[i].GetValue('T_LIBELLE'))>0) then begin FInIndex:=i ; result:=FInIndex ; exit ; end ;
  lQ:=nil ;
  try
   lQ:=OpenSelect(lStSQL+' WHERE T_LIBELLE LIKE "'+Values[0]+'%" ',FDossier) ;
   if not lQ.EOF then
   begin
    lTOB:=MakeTOB(vBoEnBase) ; lTOB.SelectDB('',lQ) ; SetCrit(lTOB,[lTOB.GetValue('T_AUXILIAIRE')]) ;
    if (VarType(lQ.FindField('YTC_ACCELERATEUR').Asvariant) = VarNull) or (VarType(lQ.FindField('YTC_ACCELERATEUR').Asvariant) = VarEmpty) then
     lTOB.PutValue('YTC_ACCELERATEUR','-') ;
    lTOB.PutValue('_SOLDED',-1) ;
    lTOB.PutValue('_SOLDEC',-1) ;
    // Gestion des cumuls en multisoc
    CChargeCumulsMS( fbAux, lTOB.GetString('T_AUXILIAIRE') , '', lTOB, FDossier ) ;
    result:=FInIndex ;
   end;
  finally
   Ferme(lQ) ;
  end; // try

 finally
  lAValues:=nil ;
 end; // try

end;

procedure TZTier.RAZSolde ;
var
 i : integer ;
begin
  for i:=0 to FTOB.Detail.Count-1 do
   begin
    FTOB.Detail[i].PutValue('_SOLDED',-1) ;
    FTOB.Detail[i].PutValue('_SOLDEC',-1) ;
   end ;
end;


procedure TZTier.Solde(var D, C: double; vTypeExo: TTypeExo);
var
 lStLettre : string ;
begin

 case vTypeExo of
  teEncours   : lStLettre := 'E' ;
  teSuivant   : lStLettre := 'S' ;
  tePrecedent : lStLettre := 'P' ;
 end ;// case

 D := GetValue('T_TOTDEB' + lStLettre) ;
 C := GetValue('T_TOTCRE' + lStLettre) ;

end;

function TZTier.GetCompteOpti(var NumCompte: string ; vTobSource : tob ): Integer;
var lTOB    : TOB ;
    lStChp  : string ;
    i       : integer ;
begin

  // recherche dans la liste
  FInIndex := inherited Load( [NumCompte] ) ;

  if ( FInIndex = -1 ) and ( Trim( NumCompte ) <> '' ) then
    begin

    if Assigned( vTobSource ) and ( vTobSource.GetString('T_AUXILIAIRE') = NumCompte ) then
      begin
      // Cr�ation nouvel objet
      lTOB := MakeTOB ;

      // Recopie des infos
      for i:=1 to lTob.NbChamps do
        begin
        lStChp := lTob.GetNomChamp( i ) ;
        if vTobSource.GetNumChamp( lstChp ) > 0 then
          lTOB.PutValue( lStChp, vTobSource.GetValue( lStChp ) ) ;
        end ;
      SetCrit( lTOB, [NumCompte] ) ;

      // indicateur
      FInIndex := FTOB.Detail.Count-1 ;

      end
    // Ancienne m�thode sinon
    else result := GetCompte( NumCompte ) ;

    end ;

  if FInIndex <> -1 then
    NumCompte := GetValue('T_AUXILIAIRE') ;

  result := FInIndex ;

end;

{ TObjetCompta }

constructor TObjetCompta.Create( vInfoEcr : TInfoEcriture );
begin
 FInfo := vInfoEcr ;
end;

procedure TObjetCompta.Initialize;
begin
 NotifyError(RC_PASERREUR,'');
end;

procedure TObjetCompta.NotifyError(RC_Error: integer; RC_Message: string ; RC_Methode : string = '' );
begin
 FLastError.RC_Error   := RC_Error ;
 FLastError.RC_Message := RC_Message ;
 FLastError.RC_Methode := RC_Methode ;
 if assigned(FOnError) then FOnError(self,FLastError) ;
end;

procedure TObjetCompta.NotifyError( RC_Message, RC_MessageDelphi, RC_Methode : string ) ;
begin
 FLastError.RC_Error   := -1 ;
 FLastError.RC_Methode := RC_Methode ;

 if RC_MessageDelphi = '' then
  FLastError.RC_Message := RC_Message
   else
    FLastError.RC_Message := RC_Message + #13#10 + RC_MessageDelphi + #13#10 + RC_Methode ;

 if assigned(FOnError) then FOnError(self,FLastError) ;

end;

procedure TObjetCompta.SetInfo(Value: TInfoEcriture);
begin
 FInfo := Value ;
end;

procedure TObjetCompta.SetOnError(Value: TErrorProc);
begin
 FOnError := Value ;
end;



{ TZEtabliss }

procedure TZEtabliss.Initialize;
begin
 FStTable :='ETABLISS' ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : LG
Cr�� le ...... : 03/09/2007
Modifi� le ... :   /  /    
Description .. : - LG - 03/09/2007 - FB 15187 - bloque sur l'etablissemebt 
Suite ........ : autorisee
Mots clefs ... : 
*****************************************************************}
function TZEtabliss.Load (const Values : array of string ; vBoEnBase : boolean = false ) : integer;
var Q : TQuery ;
lStCode : string ; lTOB : TOB ;
lStSQL : string ;
begin
Result:=inherited Load(Values,vBoEnBase) ; if result<>-1 then exit ; if SizeOf(Values)=0 then exit ;
lStCode:=Values[0] ; if Trim(lStCode)='' then exit ; Q:=nil ;
lStSQL := '' ;
{$IFNDEF NOVH}
if VH^.ProfilUserC[prEtablissement].ForceEtab and VH^.EtablisCpta then
 lStSQL := ' AND ET_ETABLISSEMENT ="' +  VH^.ProfilUserC[prEtablissement].Etablissement + '" ' ;
{$ENDIF}
try
  Q:=OpenSelect('SELECT * FROM ETABLISS WHERE ET_ETABLISSEMENT="'+UpperCase(lStCode)+'" ' + lStSQL,FDossier) ;
 if not Q.EOF then
  begin
   lTOB:=MakeTOB(vBoEnBase) ; lTOB.SelectDB('',Q) ; SetCrit(lTOB,Values) ;
   result:=FInIndex ;
  end;
finally
 Ferme(Q) ;
end; /// try
end ;

{***********A.G.L.***********************************************
Auteur  ...... : LG
Cr�� le ...... : 03/09/2007
Modifi� le ... :   /  /
Description .. : - LG - 03/09/2007 - FB 15187 - bloque sur l'etablissemebt
Suite ........ : autorisee
Mots clefs ... :
*****************************************************************}
procedure TZEtabliss.LoadAll;
var
 Q       : TQuery ;
 lTOB    : TOB ;
 lStSQL  : string ;
begin
 Q:=nil ;
 lStSQL := '' ;
 {$IFNDEF NOVH}
 if VH^.ProfilUserC[prEtablissement].ForceEtab and VH^.EtablisCpta then
  lStSQL := ' WHERE ET_ETABLISSEMENT ="' +  VH^.ProfilUserC[prEtablissement].Etablissement + '" ' ;
 {$ENDIF}
 try
  Q:=OpenSelect('SELECT * FROM ETABLISS' + lStSQL,FDossier) ;
  while not Q.EOF do
   begin
    lTOB:=MakeTOB ;
    lTOB.SelectDB('',Q) ;
    SetCrit(lTOB,[Q.findField('ET_ETABLISSEMENT').asString] ) ;
    Q.Next ;
   end; // while
  FInIndex:=FTOB.Detail.Count-1 ;
 finally
  Ferme(Q) ;
 end; /// try
end;

{ TZNature }

procedure TZNature.Initialize;
begin
 FStTable :='COMMUN' ;
end;

function TZNature.Load( const Values : array of string ; vBoEnBase : boolean = false ): integer;
var Q : TQuery ;
lStCode : string ; lTOB : TOB ;
begin
Result:=inherited Load(Values,VBoEnBase) ; if result<>-1 then exit ; if SizeOf(Values)=0 then exit ;
lStCode:=Values[0] ; if Trim(lStCode)='' then exit ; Q:=nil ;
try
 Q:=OpenSelect('SELECT * FROM COMMUN WHERE  CO_TYPE="NTP" AND CO_CODE="'+UpperCase(lStCode)+'"',FDossier) ;
 if not Q.EOF then
  begin
   lTOB:=MakeTOB(vBoEnBase) ; lTOB.SelectDB('',Q) ; SetCrit(lTOB,Values) ;
   //FInIndex:=FTOB.Detail.Count-1 ;
   result:=FInIndex ;
  end;
finally
 Ferme(Q) ;
end; /// try
end ;

procedure TZNature.LoadAll;
var
 Q : TQuery ;
 lTOB : TOB ;
begin
 Q:=nil ;
 try
  Q:=OpenSelect('SELECT * FROM COMMUN WHERE CO_TYPE="NTP" ',FDossier) ;
  while not Q.EOF do
   begin
    lTOB:=MakeTOB ;
    lTOB.SelectDB('',Q) ;
    SetCrit(lTOB,[Q.findField('CO_CODE').asString] ) ;
    Q.Next ;
   end; // while
  FInIndex:=FTOB.Detail.Count-1 ;
 finally
  Ferme(Q) ;
 end; /// try
end;

procedure TZNature.MakeTag ( vStNatureJal : string ) ;
var
 i : integer ;
begin
 for i := 0 to FTOB.Detail.Count - 1 do
  if NATUREJALNATPIECEOK( vStNatureJal , FTOB.Detail[i].GetValue('CO_CODE') ) then
   FTOB.Detail[i].PutValue('TAG','1')
    else
     FTOB.Detail[i].PutValue('TAG','0') ;
end;



function TZNature.NextNature : string;

 function _n ( var vIndex : integer ) : string ;
 var
  i,d  : integer ;
 begin
  result := '' ; d := vIndex + 1 ;
  for i := d to FTOB.Detail.Count - 1 do
   begin
    if FTOB.Detail[i].GetValue('TAG') = '1' then
     begin
      vIndex   := i ;
      result   := FTOB.Detail[vIndex].GetValue('CO_CODE') ;
      exit ;
     end;
   end; // for
   vIndex := 0 ;
 end;

begin
 result := _n(FInIndex) ;
 if result = '' then   // on relance le test
  result := _n(FInIndex) ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 28/11/2005
Modifi� le ... :   /  /
Description .. : - LG - 28/11/2005 - FB 17069 - correction de la mise ajour 
Suite ........ : des soldes
Mots clefs ... : 
*****************************************************************}
function _CEnregistrePiece( vTOBEcr : TOB ; vBoInsert : boolean = true ) : boolean;
begin

// CEquilibrePiece(vTOBEcr) ; // g�n�ration des ecart de conversion
 //CAffectCompteContrePartie(vTOBEcr) ;
 CNumeroPiece(vTOBEcr) ;

 if vBoInsert then
  result := vTOBEcr.InsertDBByNivel(false)
   else
    result := vTOBEcr.UpdateDb(false) ;

end;


procedure CNumeroLigneBor(vTOBPiece : TOB );
var
 lInNumGroupEcr     : integer;
 lInNumLigne        : integer;
 k                  : integer;
 i                  : integer;
 lNumAxe            : integer;
 lInNumLignePrec    : integer;
 lQ                 : TQuery;
 lTOBLigneEcr       : TOB;
 lTOBSection        : TOB;
begin
 if ( vTOBPiece.Detail = nil ) or ( vTOBPiece.Detail.Count = 0 ) then exit ; 
 lInNumLignePrec:=0 ;
 // on recherche le dernier numero  de ligne et de numgroupecr
 lQ:=OpenSQL('select max(E_NUMLIGNE) as N ,max(E_NUMGROUPEECR) as M from ecriture where E_EXERCICE="'+vTOBPiece.Detail[0].GetValue('E_EXERCICE')+'" '+
             'and E_NUMEROPIECE='+intToStr(vTOBPiece.Detail[0].GetValue('E_NUMEROPIECE'))+' and E_QUALIFPIECE="N" ' +
             'and E_JOURNAL="'+vTOBPiece.Detail[0].GetValue('E_JOURNAL')+'" and E_PERIODE='+intToStr(vTOBPiece.Detail[0].GetValue('E_PERIODE')),true,-1,'',true);
 lInNumLigne:=lQ.FindField('N').asInteger ; Inc(lInNumLigne) ; lInNumGroupEcr:=lQ.FindField('M').asInteger ; Ferme(lQ) ;
 // on parcourt l'ensemble des lignes de la piece et on numerote les lignes
 for k:=0 to vTOBPiece.Detail.Count-1 do
  BEGIN
   lTOBLigneEcr := vTOBPiece.Detail[k];
   lTOBLigneEcr.PutValue('E_NUMLIGNE',lInNumLigne) ;
   // renumerotation de l'analytique
   if assigned( lTOBLigneEcr.Detail ) and ( lTOBLigneEcr.detail.Count > 0 ) then
    begin
     for lNumAxe := 0 to 4 do
      begin
       lTOBSection := lTOBLigneEcr.detail[lNumAxe];
       if assigned( lTOBSection.Detail ) and ( lTOBSection.detail.Count > 0 ) then
         for i := 0 to lTOBSection.detail.Count - 1 do
          lTOBSection.Detail[i].PutValue('Y_NUMLIGNE',lInNumLigne);
      end; // for
    end; // if
   Inc(lInNumLigne) ;
   if lTOBLigneEcr.GetValue('E_MODESAISIE')='BOR' then
    BEGIN
     if lTOBLigneEcr.GetValue('E_NUMGROUPEECR')<>lInNumLignePrec then
      BEGIN
       lInNumLignePrec:=lTOBLigneEcr.GetValue('E_NUMGROUPEECR') ; Inc(lInNumGroupEcr) ;
      END;
    END // if
     else lInNumGroupEcr:=1;
   // on supprime les eventuelles caract�res speciaux du lettrages
   if lTOBLigneEcr.GetValue('E_LETTRAGE')<>'' then
    lTOBLigneEcr.PutValue('E_LETTRAGE',Copy(vTOBPiece.Detail[k].GetValue('E_LETTRAGE'),1,4));
   lTOBLigneEcr.PutValue('E_NUMGROUPEECR',lInNumGroupEcr);
  END;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent gendreau
Cr�� le ...... : 28/11/2005
Modifi� le ... :   /  /    
Description .. : - LG - 28/11/2005 - FB 17069 - correction de la mise ajour 
Suite ........ : des soldes
Mots clefs ... : 
*****************************************************************}
function _CEnregistreBordereau( vTOBEcr : TOB ; vAjouter : boolean = false ; vBoInsert : boolean = true ) : boolean ;
begin

 if CBlocageBor(
                vTOBEcr.Detail[0].GetValue('E_JOURNAL'),
                vTOBEcr.Detail[0].GetValue('E_DATECOMPTABLE'),
                vTOBEcr.Detail[0].GetValue('E_NUMEROPIECE'),true) then
    begin
     try

      //CEquilibrePiece(vTOBEcr) ; // g�n�ration des ecart de conversion
      //CAffectCompteContrePartie(vTOBEcr) ;

      if vAjouter then
       CNumeroLigneBor(vTOBEcr)
       else
        CNumeroPiece(vTOBEcr) ;
      vTOBEcr.SetAllModifie(true) ;

      if vBoInsert then
       result := vTOBEcr.InsertDB(nil)
        else
         result := vTOBEcr.UpdateDB(false) ;

     finally
      CBloqueurBor(
                   vTOBEcr.Detail[0].GetValue('E_JOURNAL'),
                   vTOBEcr.Detail[0].GetValue('E_DATECOMPTABLE'),
                   vTOBEcr.Detail[0].GetValue('E_NUMEROPIECE'), false);
     end; //try

    end
     else
      begin
       result := false;
       CAfficheLigneEcrEnErreur(vTOBEcr.Detail[0]) ;
       V_PGI.IOError:=oeStock ;
      end ;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 09/09/2003
Modifi� le ... : 28/11/2005
Description .. : Duplication de CEnregistreSaisie � fusionner d�s le retour
Suite ........ : de LG : probl�me de compatibilit� de param�tres avec la
Suite ........ : version existante.
Suite ........ :
Suite ........ : 14/01/2005  : on ne renum�rote plus automatiquement en
Suite ........ : mode pi�ce (SBO)
Suite ........ : - LG - 28/11/2005 - FB 17069 - correction de la mise ajour
Suite ........ : des soldes
Mots clefs ... :
*****************************************************************}
function CEnregistreSaisie( vTOBEcr : TOB ; vNumerote : boolean ; vAjouter : boolean = false ; vBoInsert : boolean = true ; vInfo : TInfoEcriture = nil ; vBoEcrNormale : Boolean = True) : boolean ;
var
 lInNumFolio   : integer ;
 j             : integer ;
 i             : integer ;
begin

 result := false ;

 if vTOBEcr =  nil then
  begin
   MessageAlerte('Enregistrement impossible, la TOB est vide ! ' );
   exit ;
  end;

 if vTOBEcr.Detail.Count =  0 then
  begin
   MessageAlerte('Enregistrement impossible, Aucun enfant ! ' );
   exit ;
  end;

// SBO 14/01/2005 on ne renum�rote plus automatiquement en mode pi�ce
// if vNumerote or ( vTOBEcr.Detail[0].GetValue('E_MODESAISIE') = '-' ) then
 if vNumerote  then
  begin // on genere un numero pour le nouveau bordereau/piece
   lInNumFolio := GetNewNumJal( vTOBEcr.Detail[0].GetValue('E_JOURNAL') , vBoEcrNormale, vTOBEcr.Detail[0].GetValue('E_DATECOMPTABLE'));
   for j := 0 to vTOBEcr.Detail.Count - 1 do
   vTOBEcr.Detail[j].PutValue('E_NUMEROPIECE', lInNumFolio ) ;
  end; // if

 if ( vTOBEcr.Detail[0].GetValue('E_MODESAISIE')='BOR' ) or ( vTOBEcr.Detail[0].GetValue('E_MODESAISIE')='LIB' ) then
  begin
   if not _CEnregistreBordereau( vTOBEcr, vAjouter , vBoInsert) then exit ;
  end
   else
    if not _CEnregistrePiece( vTOBEcr , vBoInsert ) then exit ;

 MajSoldesEcritureTOB (vTOBEcr,true,vInfo) ;

 // pour les tres grosses bases, on ne fait aps ce test
 if vTOBEcr.Detail.Count < 2000 then
  for i := 0 to vTOBEcr.Detail.Count - 1 do
   OnUpdateEcritureTOB(vTOBEcr.Detail[i],taCreat,[cEcrCompl]) ;

 // on force la synchro avec les liasses , car ds le OnUpdate elle ne se declanche pour pour la ligne 1.
 // les ecritures simplifies creer des ecritures qui s'ajoute au bordereau existant
  if EstMultiSoc and Assigned( vInfo ) then
   CPStatutDossier( vInfo.Dossier )
    else
     CPStatutDossier ;

 result := true ;

end;


function CIsValidEtabliss( vTOB : TOB ; const vInfo : TInfoEcriture  ) : integer ;
begin
 if vInfo.Etabliss.Load([vTOB.GetString('E_ETABLISSEMENT')]) <> - 1 then
  begin
   {$IFNDEF NOVH}
   if VH^.EtablisCpta and ( VH^.ProfilUserC[prEtablissement].ForceEtab and ( VH^.ProfilUserC[prEtablissement].Etablissement <> vTOB.GetString('E_ETABLISSEMENT') ) ) then
    begin
     vTOB.PutValue('E_ETABLISSEMENT' , '' ) ;
     result := RC_EXOINTERDIT ;
    end
     else
   {$ENDIF}
      result := RC_PASERREUR ;
  end
   else
    result := RC_ETABLISSINEXISTANT ;

end;

function CIsValidNat ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lStNat    : string ;
 lStJal : string ;
begin

 vTOB.PutValue('E_NATUREPIECE',AnsiUpperCase(vTOB.GetString('E_NATUREPIECE'))) ;

 lStNat := vTOB.GetString('E_NATUREPIECE') ;
 lStJal := vTOB.GetString('E_JOURNAL') ;

 if ( lStNat = '' ) or ( ( CASENATP(lStNat) = 7 ) and ( AnsiUpperCase(lStNat) <>'OD' ) ) then
  begin
    result := RC_NATINEXISTANT ;
    exit ;
  end; // if

 if ( vTOB.GetString('E_GENERAL') = '' ) and ( lStJal = '' ) then
  begin
   result := RC_PASERREUR ;
   exit ;
  end; // if

 // controle coherence journal / nature de piece
 if ( lStJal <> '' ) and ( not NATUREJALNATPIECEOK(vInfo.Journal.Item.getValue('J_NATUREJAL'),lStNat) ) then
  begin
   result := RC_NATUREJAL ;
   exit ;
  end; // if

 result := RC_PASERREUR;

end;

function CIsValidEcrANouveau ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lStEcrANouveau : string ;
 lBoResult : boolean ;
begin

 lStEcrANouveau := vTOB.GetString('E_ECRANOUVEAU') ;

 if ( vInfo.GetString('J_NATUREJAL') = 'ANO') then
  lBoResult := (lStEcrANouveau = 'O') or (lStEcrANouveau = 'H') or (lStEcrANouveau = 'OAN')
   else
    if ( vInfo.GetString('J_NATUREJAL') = 'CLO') then
     lBoResult := (lStEcrANouveau = 'C') or (lStEcrANouveau = 'N') or (lStEcrANouveau = 'OAN')
     else
      lBoResult := (lStEcrANouveau = 'N') ;

 if not lBoResult then
  result := RC_ECRANOUVEAU
   else
    result := RC_PASERREUR ;

end;

function CIsValidModeSaisie ( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lBoResult     : boolean ;
 lStModeSaisie : string ;
begin

 result := RC_JALINEXISTANT ;

 if not vInfo.LoadJournal( vTOB.GetString('E_JOURNAL') ) then exit ;

 lStModeSaisie := vTOB.GetString('E_MODESAISIE') ;

 if lStModeSaisie = '-' then
  lBoResult := ( trim(vInfo.GetString('J_MODESAISIE')) = '' ) or ( vInfo.GetString('J_MODESAISIE') = '-' )
   else
    lBoResult := ( vInfo.GetString('J_MODESAISIE') = lStModeSaisie) ;

 if not lBoResult then
  result := RC_MODESAISIE
   else
    begin
     if ( ( lStModeSaisie = 'BOR' ) or ( lStModeSaisie = 'LIB' ) )
        and ( ( vTOB.GetString('E_QUALIFPIECE') <> 'N' ) and ( vTOB.GetString('E_QUALIFPIECE') <> 'C' ) and ( vTOB.GetString('E_QUALIFPIECE') <> 'L' )) then
      result := RC_QUALIFPIECEMS
       else
        result := RC_PASERREUR ;
    end ;

end;

function CIsValidPeriodeSemaine( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lBoResult : boolean ;
begin
 lBoResult:= ( NumSemaine(vTOB.GetDateTime('E_DATECOMPTABLE')) = vTOB.GetInteger('E_SEMAINE') ) and
             ( GetPeriode(vTOB.GetDateTime('E_DATECOMPTABLE')) = vTOB.GetInteger('E_PERIODE') ) ;
 if not lBoResult then
  result := RC_NUMPERIODE
   else
    result := RC_PASERREUR ;

end;


function CIsValidMontant( vRdMontant : double ) : integer ;
begin

 result := RC_PASERREUR ;

 if (not GetParamSocSecur('SO_MONTANTNEGATIF',false)) and ( vRdMontant < 0 ) then
  begin
   result :=  RC_NONEGATIF ;
   exit ;
  end ;

 vRdMontant := Abs(vRdMontant) ;

 if ( vRdMontant <> 0 )and
    ( ( vRdMontant < GetGrpMontantMin ) or
      ( vRdMontant > GetGrpMontantMax ) ) then
  result := RC_NOGRPMONTANT ;

end;


function  CIsValidDate( vTOB : TOB ; vInfo : TInfoEcriture ) : integer ;
begin

 result := RC_PASERREUR ;

 if ( vInfo.GetString('J_MODESAISIE')='-' ) or ( vInfo.GetString('J_MODESAISIE')='' ) then
  begin
    if ControleDate(vTOB.GetString('E_DATECOMPTABLE')) <> 0 then
     result := RC_DATEINCORRECTE ;
  end
   else
    begin
     if not CControleDateBor(vTOB.GetDateTime('E_DATECOMPTABLE'),vINfo.Exercice,false) then
      result := RC_DATEINCORRECTE ;
    end ;
end ;

function  CIsValidDateC( vDate : TDateTime ; vInfo : TInfoEcriture ; vBoForceBor : boolean = false ) : integer ;
begin

 result := RC_PASERREUR ;

 if not vBoForceBor and ( ( vInfo.GetString('J_MODESAISIE')='-' ) or ( vInfo.GetString('J_MODESAISIE')='' ) ) then
  begin
    if ControleDate(DateToStr(vDate)) <> 0 then
     result := RC_DATEINCORRECTE ;
  end
   else
    begin
     if not CControleDateBor(vDate,vInfo.Exercice,false) then
      result := RC_DATEINCORRECTE ;
    end ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 16/09/2004
Modifi� le ... : 05/10/2006
Description .. : LG - 16/09/2004 - FB 14590 - pour le controle sur un
Suite ........ : compte pointable, il fait aussi qu'il soit de type bq ou caisse
Suite ........ : - LG - 22/03/2005 - FB 15522 - on ne controlait pas le
Suite ........ : e_regimetva pour les tic ou tid
Suite ........ : - LG - 03/10/2006 - FB 18633 - changement du controle sur
Suite ........ : e_encaissement, affectation sur les tiers uniquements
Suite ........ : - LG - 05/10/2006 - FB 18908 - on supprime le controle sur 
Suite ........ : les mode de paiement sur les compte divers pointable
Mots clefs ... : 
*****************************************************************}
function _IsValidLigne( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lBoLettrable : boolean ;
 lBoPointage  : boolean ;
 lBoTiers     : boolean ;
begin

 result       := RC_PASERREUR ;

 lBoLettrable := ( vInfo.Compte.IsLettrable or ( vInfo.GetString('T_LETTRABLE') = 'X' ) )  ;

 lBoPointage  := vInfo.Compte.IsPointable and  ( ( vInfo.Compte.GetValue('G_NATUREGENE') = 'BQE' ) or  ( vInfo.Compte.GetValue('G_NATUREGENE') = 'CAI' ) );

 if ( lBoLettrable and ( UpperCase(vTOB.GetValue('E_ETATLETTRAGE')) = 'RI' ) )  then
  result := RC_ERREURINFOLETT ;

 if ( result = RC_PASERREUR ) and lBoPointage and ( vTOB.GetValue('E_NUMECHE') = 0 ) then
  result := RC_ERREURINFOPOINTAGE ;

 if ( result = RC_PASERREUR ) and lBoLettrable and ( vTOB.GetValue('E_NUMECHE') = 0 ) then
  result := RC_ERREURINFOLETT ;

 // SBO 25/07/2006 : tester le mode de paiement pour les comptes pointables aussi
 lBoTiers := ( ( vInfo.Compte.IsCollectif and ( vInfo.GetString('T_LETTRABLE')='X' ) ) // tiers lettrable
             or ( vInfo.Compte.IsPointable and ( vInfo.GetString('G_NATUREGENE')<>'DIV' ) )                                           // g�n�ral pointable
             or ( vInfo.Compte.IsTICTID and vInfo.Compte.IsLettrable )                  // Tic / Tic lettrable
             ) ;
 if ( result = RC_PASERREUR ) and lBoTiers and ( trim(vTOB.GetValue('E_MODEPAIE')) = '' ) then
  result := RC_MODEPAIEINCORRECT ;

 if ( result = RC_PASERREUR ) and lBoTiers and ( trim(vTOB.GetValue('E_ENCAISSEMENT')) = '' ) then
  result := RC_MODEENCAISSEMENT ;

 if ( result = RC_PASERREUR ) and ( vInfo.Compte.IsCollectif ) and ( vInfo.GetString('T_LETTRABLE')='X' ) and ( vTOB.GetValue('E_DATEVALEUR') = iDate1900 )   then
  result := RC_DATEVALEURINCORRECT ;

 if ( result = RC_PASERREUR ) and vInfo.Compte.IsCollectif and ( vInfo.GetString('T_NATUREAUXI') <> 'SAL' ) and ( length(trim( vTOB.GetValue('E_REGIMETVA') )) = 0 )   then
  result := RC_REGIMETVAINCORRECT ;

  if ( result = RC_PASERREUR ) and vInfo.Compte.IsTICTID and ( length(trim( vTOB.GetValue('E_REGIMETVA') )) = 0 )   then
  result := RC_REGIMETVAINCORRECT ;

 if ( vTOB.GetValue('E_TAUXDEV') = 0 )   then
  result := RC_TAUXDEVINCORRECT ;

end;



function _IsValidPiece ( vTOB : TOB ; vInfo : TInfoEcriture ) : integer ;
var
 i               : integer ;
 lStContrepartie : string ;
 lTdc            : RecCalcul; // structure de retour de la fonction de calcul du solde
 lStRegimeTva    : string ;
 lStLastNat      : string ;
 lStLastDev      : string ;
 lStEta          : string ;
 lRecError       : TRecError ;
begin

// result := RC_PASERREUR ;

 vInfo.LoadJournal( vTOB.Detail[0].GetValue('E_JOURNAL') ) ;

 if vInfo.Journal.isJalBqe then
  begin

   result          := RC_TRESO ;
   lStContrepartie := vInfo.GetString('J_CONTREPARTIE') ;
   i               := 0 ;

   while ( i < vTOB.Detail.Count ) and ( vTOB.Detail[i].GetValue('E_GENERAL') <> lStContrepartie ) do inc(i) ;

   if ( i < vTOB.Detail.Count ) then
    begin
     if vTOB.Detail[i].GetValue('E_GENERAL') <> lStContrepartie then exit ; // FQ16842 SBO 11/10/2005
    end
     else
      exit ;

  end; // if

 lStRegimeTva := vTOB.Detail[0].GetValue('E_REGIMETVA') ;
 lStLastNat   := vTOB.Detail[0].GetValue('E_NATUREPIECE') ;
 lStLastDev   := vTOB.Detail[0].GetValue('E_DEVISE') ;
 lStEta       := vTOB.Detail[0].GetValue('E_ETABLISSEMENT') ;

 for i := 0 to vTOB.Detail.Count - 1 do
  begin
   if ( ( lStRegimeTva <> '' ) and ( vTOB.Detail[i].GetValue('E_REGIMETVA') = '' ) ) or
      ( ( lStRegimeTva = '' ) and ( vTOB.Detail[i].GetValue('E_REGIMETVA') <> '' ) )   then
    begin
     result  := RC_REGIMETVAINCORRECT ;
     exit ;
    end ;// if
   if ( vTOB.Detail[i].GetValue('E_CONTREPARTIEGEN') = '' ) then
    begin
     result  := RC_CONTREINCORRECT ;
     exit ;
    end ;

   if ( vInfo.GetString('J_MODESAISIE') = '-' ) and ( lStLastNat <> vTOB.Detail[i].GetValue('E_NATUREPIECE')  ) then
    begin
     result  := RC_NATUREERR ;
     exit ;
    end ; // if

   if ( vInfo.GetString('J_MODESAISIE') = 'LIB' ) and ( lStLastDev <> vTOB.Detail[0].GetValue('E_DEVISE') ) then
    begin
     result := RC_DEVISEENLIBRE ;
     exit ;
    end ;

   if lStEta <> vTOB.Detail[i].GetValue('E_ETABLISSEMENT') then
    begin
     result             := RC_ETABLISSEMENT ;
     lRecError.RC_Error := RC_ETABLISSEMENT ;
     _CTestErreur(lRecError,vInfo ) ;
     if lRecError.RC_Error <> RC_PASERREUR then
      exit ;
    end ;

  end ;

 result  := RC_PASERREUR ;
 lTDC    := CCalculSoldePiece (vTOB) ;

 if not ( Arrondi ( ( lTDC.DD  - lTDC.CD )  , V_PGI.OkDecV ) = 0 ) then // SBO 27/05/2005 : test sur montant en devise
  result := RC_NONSOLDER

end ;

function CIsValidJal( vStCodeJal : string ; vStCodeDev : string ; vInfo : TInfoEcriture ) : integer ;
begin

 if vStCodeDev = '' then
  begin
   if (vInfo.Devise.Dev.Code <> '') then
    vStCodeDev := vInfo.Devise.Dev.Code
     else
      begin
       result := RC_DEVISE ;
       exit ;
      end;
  end; // if

 if (vStCodeJal = '') or ( vInfo.Journal.Load(vStCodeJal)=-1) then
  begin
   result := RC_JALINEXISTANT ;
   exit ;
  end; // if

 if (vInfo.GetString('J_FERME') = 'X') then
  begin
   result := RC_JALFERME ;
   exit ;
  end; // if


 if ( GetJalAutorises <> '' ) and ( Pos(';' + vStCodeJal + ';' , GetJalAutorises ) <=0 ) then
  begin
   result := RC_NOJALAUTORISE ;
   exit;
  end; // if

 if ( vStCodeDev <> V_PGI.DevisePivot ) and (vInfo.GetString('J_MULTIDEVISE') <> 'X') then
  begin
   result := RC_JALNONMULTIDEVISE ;
   exit;
  end; // if

 result := RC_PASERREUR ;

end;

function CIsValidJournal( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
begin
 result := CIsValidJal(vTOB.GetString('E_JOURNAL'),vTOB.GetString('E_DEVISE'), vInfo ) ; 
end;



{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 25/08/2005
Modifi� le ... :   /  /    
Description .. : - FB 16397 - LG  - 25/08/2005 - test de la revision 
Suite ........ : uniquement pour l'exercice en cours
Mots clefs ... : 
*****************************************************************}
function CIsValidCompte( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lStCompte     : string ;
 lStAux        : string ;
 lStJournal    : string ;
begin

 {$IFDEF TT}
 AddEvenement('CIsValidCompte');
{$ENDIF}

 result                := RC_PASERREUR ;

 lStCompte             := vTOB.GetString('E_GENERAL') ;
 lStAux                := vTOB.GetString('E_AUXILIAIRE') ;
 lStJournal            := vTOB.GetString('E_JOURNAL') ;

 vInfo.Load( lStCompte , lStAux , lStJournal ) ;

 lStCompte             := vInfo.StCompte ;
 lStAux                := vInfo.StAux ;
 lStJournal            := vInfo.StJournal ;

 if ( lStCompte = '' ) or ( vInfo.Compte.InIndex = - 1 ) then
  begin
   result := RC_COMPTEINEXISTANT ;
   exit ;
  end;

 if EstInterdit( vInfo.GetString('J_COMPTEINTERDIT') , vInfo.StCompte , 0 ) > 0 then
  begin
   result := RC_CINTERDIT ;
   exit;
  end ;

 if ( vInfo.GetString('G_FERME') = 'X' ) then
    begin
      if (Arrondi( vInfo.GetValue('G_TOTALDEBIT') - vInfo.GetValue('G_TOTALCREDIT') , 2 ) = 0) then
      begin
       vTOB.PutValue('E_GENERAL' , '' ) ;
       result :=  RC_CFERMESOLDE ;
       exit;
      end
       else
        begin
         result :=  RC_CFERME ;
         exit ;
        end;
    end ;

 if not NaturePieceCompteOK( vTOB.GetString('E_NATUREPIECE') , vInfo.GetString('G_NATUREGENE') ) then
  begin
   result := RC_CNATURE ;
   exit;
  end ;

  if ( Result = RC_PASERREUR ) and ( vInfo.TypeExo = teEnCours ) and ( vInfo.GetString('G_VISAREVISION') = 'X' ) then
  begin
   //vTOB.PutValue('E_GENERAL' , '' ) ;
   result :=  RC_COMPTEVISA ;
   exit;
  end ;

 if ( vInfo.GetString('G_COLLECTIF') = 'X' )  then
  begin
   if vInfo.Aux.InIndex = -1 then
    begin
     if Trim( lStAux ) = '' then
      result := RC_AUXOBLIG
       else
        result := RC_AUXINEXISTANT
    end
     else
      begin
       if not NATUREGENAUXOK( vInfo.GetString('G_NATUREGENE') , vInfo.GetString('T_NATUREAUXI') ) then
        result := RC_NATAUX ;
      end;
  end // if
   else
    if Trim(lStAux) <> '' then
     result := RC_PASCOLLECTIF ;

 if ( Result = RC_PASERREUR ) and EstConfidentiel( vInfo.GetString('G_CONFIDENTIEL') ) then
  result := RC_COMPTECONFIDENT ;

 if Result = RC_PASERREUR then
  vTOB.PutValue('E_GENERAL'    , lStCompte ) ;

end;

function CEstBloqueLett (vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean ;
var
 lStSql  : string ;
 lStUser : string ;
 lQ      : TQuery ;
begin
 lStSql := 'select US_LIBELLE from COURRIER,UTILISAT ' +
           ' where MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=3000 AND MG_COMBO="' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '"' +
           ' and US_UTILISATEUR=MG_EXPEDITEUR' ;

 lQ     := OpenSql(lStSql,true,-1,'',true) ;
 result := not lQ.EOF ;
 if result then lStUser := lQ.FindField('US_LIBELLE').AsString ;
 Ferme(lQ) ;
 if ( lStUser <> '' ) and  Parle then MessageAlerte('Lettrage en saisie utilis� par ' + lStUser) ;
end ;

function CEstBloqueLettrage ( Parle : boolean = false) : boolean ;
var
 lStSql  : string ;
 lStUser : string ;
 lQ      : TQuery ;
begin
 lStSql := 'select US_LIBELLE from COURRIER,UTILISAT ' +
           ' where MG_UTILISATEUR="' + W_W + '" AND MG_TYPE=3000 and US_UTILISATEUR=MG_EXPEDITEUR and mg_expediteur = "' + V_PGI.User + '" ' ;

 lQ     := OpenSql(lStSql,true,-1,'',true) ;
 result := not lQ.EOF ;
 if result then lStUser := lQ.FindField('US_LIBELLE').AsString ;
 Ferme(lQ) ;
 if ( lStUser <> '' ) and  Parle then MessageAlerte('Lettrage en saisie utilis� par ' + lStUser) ;
end ;

function _BlocageLett (vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean ;
var
 lStSql : string ;
begin
 result := false ;
 lStSql := 'insert into courrier(mg_utilisateur,mg_combo,mg_type,mg_dejalu,mg_date,mg_averti,mg_expediteur) ' +
           'values("' + W_W + '","' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '",3000,"-","' +
           USTime(vDtDateComptable) + '","-","' + V_PGI.User + '")';
 try
  ExecuteSQL(lStSQL);
  result := true ;
 except
  on E : Exception do
   begin
    if Parle then MessageAlerte('Bordereau bloqu�' + #10#13#10#13 + E.Message);
   end;
 end; // try
end;

function CBlocageLettrage(vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) : boolean ;
begin
 result := false;
 if not CEstBloqueLett(vStJournal,vDtDateComptable,vInNumeroPiece,Parle) then
  result := _BlocageLett(vStJournal,vDtDateComptable,vInNumeroPiece,Parle);
end;

{procedure CDeBlocageLettrageP (vStJournal : string ; vDtDateComptable : TDateTime ; vInNumeroPiece : integer ; Parle : boolean = true) ;
begin
 ExecuteSQL( 'delete from courrier ' +
             'where mg_utilisateur = "' + W_W + '" and mg_type=3000 and mg_expediteur = "' + V_PGI.User + '"' +
             ' and mg_combo="' + EncodeKeyBordereau(vDtDateComptable,vStJournal,vInNumeroPiece) + '" ' ) ;
end; }

procedure CDeBlocageLettrage ( Parle : boolean = false ) ;
begin
 ExecuteSQL( 'delete from courrier ' +
             'where mg_utilisateur = "' + W_W + '" and mg_type=3000 and mg_expediteur = "' + V_PGI.User + '"' ) ;
end;


function CDetruitAncienPiece( vTOB : TOB ; vDossier : String = '' ) : boolean ;
var
 lStW          : string ;
 lStSql        : string ;
 lDtDateUnique : TDateTime ;
 lBoMonoDate   : boolean ;
 lTOB          : TOB ;
 i             : integer ;
 lInNb         : integer ;
 lInExec       : integer ;
 lBoModePiece  : boolean ;
begin

 result := false ;

 if ( vTOB = nil ) or ( vTOB.Detail = nil ) or ( vTOB.Detail.Count = 0 ) then exit ;

 lTOB          := vTOB.Detail[0] ;
 lInNb         := vTOB.Detail.Count ;
 lBoMonoDate   := True ;
 lDtDateUnique := 0 ;

 lBoModePiece := (lTOB.GetString('E_MODESAISIE')='-') or (lTOB.GetString('E_MODESAISIE')='') ;
 if lBoModePiece then
    // Mode pi�ce
   lStW := ' E_JOURNAL="'                + lTOB.GetString('E_JOURNAL')                     + '" ' +
             ' AND E_EXERCICE="'         + lTOB.GetString('E_EXERCICE')                    + '" ' +
             ' AND E_DATECOMPTABLE="'    + UsDateTime(lTOB.GetDateTime('E_DATECOMPTABLE')) + '" ' +
             ' AND E_NUMEROPIECE='       + InttoStr(lTOB.GetInteger('E_NUMEROPIECE'))      +
             ' AND E_QUALIFPIECE="'      + lTOB.GetString('E_QUALIFPIECE')                 + '" '
  else
    // Mode bordereau
   lStW := ' E_JOURNAL="'                + lTOB.GetString('E_JOURNAL')                   + '" ' +
             ' AND E_EXERCICE="'         + lTOB.GetString('E_EXERCICE')                  + '" ' +
             ' AND E_DATECOMPTABLE>="'   + USDATETIME(DebutDeMois(lTOB.GetDateTime('E_DATECOMPTABLE'))) + '" ' +
             ' AND E_DATECOMPTABLE<="'   + USDATETIME(FinDeMois(lTOB.GetDateTime('E_DATECOMPTABLE')))   + '" ' +
//             ' AND E_PERIODE='           + InttoStr(lTOB.GetValue('E_PERIODE'))     +
             ' AND E_NUMEROPIECE='       + InttoStr(lTOB.GetInteger('E_NUMEROPIECE'))    +
             ' AND E_QUALIFPIECE="'      + lTOB.GetString('E_QUALIFPIECE')               + '" ' ;

 for i := 0 to vTOB.Detail.Count - 1 do
  begin
   lTOB := vTOB.Detail[i] ;
   if  i = 0 then
    lDtDateUnique := lTOB.GetDateTime('E_DATEMODIF')
     else
      if lTOB.GetDateTime('E_DATEMODIF') <> lDtDateUnique then
       begin
        lBoMonoDate := false ;
        break ;
       end ; // if
  end ; // for


 if lBoMonoDate and  ( lDtDateUnique > 0 ) then
  begin
   lStSQL := lStW + ' AND E_DATEMODIF="' + UsTime(lDtDateUnique) + '" ' ;
   lInExec := ExecuteSQL( 'DELETE FROM ' + GetTableDossier( vDossier, 'ECRITURE' ) + ' WHERE ' + lStSQL ) ;

    if lInExec <> lInNb then
    begin
     V_PGI.IOError := oeSaisie ;
     Exit ;
    end ; // if
  end
   else
    begin
     for i := 0 to vTOB.Detail.Count - 1 do
      begin
       lTOB   := vTOB.Detail[i] ;
       lStSQL := lStW + ' AND E_NUMLIGNE='    + lTOB.GetString('E_NUMLIGNE')
                      + ' AND E_NUMECHE='     + lTOB.GetString('E_NUMECHE')
                      + ' AND E_DATEMODIF="'  + UsTime(lTOB.GetDateTime('E_DATEMODIF')) + '"' ;

       lInExec := ExecuteSQL('DELETE FROM ' + GetTableDossier( vDossier, 'ECRITURE' ) + ' WHERE ' + lStSQL ) ;

       if lInExec <> 1 then
        begin
         V_PGI.IOError := oeSaisie ;
         Exit ;
        end ; // if
      end ; // for
    end ; // else

 result := true ;

end;


{***********A.G.L.***********************************************
Auteur  ...... : Compta
Cr�� le ...... : 20/12/2004
Modifi� le ... :   /  /
Description .. : Supprime en base les lignes d'analytique de la pi�ce
Suite ........ : comptable pass�e en param�tre.
Mots clefs ... :
*****************************************************************}
function  CDetruitAncienAnaPiece( vTOB : TOB ; vDossier : String = '' ) : boolean ;
var vBoAvecAna    : Boolean ;
    lTob          : TOB ;
    i             : Integer ;
    lBoModePiece  : boolean ;
begin

  result := True ;

  if ( vTOB = nil ) or ( vTOB.Detail = nil ) or ( vTOB.Detail.Count = 0 ) then exit ;

  // Test pr�sence d'analytique
  vBoAvecAna := False ;
  for i := 0 to (vTob.Detail.count - 1) do
   begin
   lTOB := vTOB.Detail[ i ] ;
   if lTob.GetValue('E_ANA')='X' then
     begin
     vBoAvecAna := True ;
     break ;
     end ;
   end ;

  // Delete analytique si pr�sence
  if vBoAvecAna then
    begin
    lTOB          := vTOB.Detail[0] ;
    lBoModePiece  := (lTOB.GetString('E_MODESAISIE')='-') or (lTOB.GetString('E_MODESAISIE')='') ;
    ExecuteSQL( 'DELETE FROM ' + GetTableDossier( vDossier, 'ANALYTIQ' ) + ' WHERE ' + WhereEcritureTOB( tsAnal, vTOB.Detail[0], False, not lBoModePiece ) ) ;
    end ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : Compta
Cr�� le ...... : 20/12/2004
Modifi� le ... :   /  /
Description .. : Supprime en base les lignes d'analytique de l'�criture
Suite ........ : comptable pass�e en param�tre.
Mots clefs ... :
*****************************************************************}
function  CDetruitAncienAnaEcr( vTOB : TOB ) : boolean ;
var lBoModePiece : boolean ;
begin
  result := True ;
  if ( vTOB = nil ) then exit ;

  // Delete analytique si pr�sence
  if ( vTob.GetValue('E_ANA') = 'X' ) then
    begin
    lBoModePiece  := (vTOB.GetString('E_MODESAISIE')='-') or (vTOB.GetString('E_MODESAISIE')='') ;
    ExecuteSQL( 'DELETE FROM ANALYTIQ WHERE ' + WhereEcritureTOB( tsAnal, vTOB, True, not lBoModePiece ) ) ;
    end ;

end ;

function CMAJSaisie( vTOBEcr : TOB ) : boolean ;
begin

 result := false ;

 if vTOBEcr =  nil then
  begin
   MessageAlerte('Enregistrement impossible, la TOB est vide ! ' );
   exit ;
  end;

 if vTOBEcr.Detail.Count =  0 then
  begin
   MessageAlerte('Enregistrement impossible, Aucun enfant ! ' );
   exit ;
  end;

// result := _DetruitAncienPiece(vTOBEcr) ;

 if ( vTOBEcr.Detail[0].GetValue('E_MODESAISIE')='BOR' ) or ( vTOBEcr.Detail[0].GetValue('E_MODESAISIE')='LIB' ) then
  begin
   if not _CEnregistreBordereau( vTOBEcr, true ) then exit ;
  end
   else
    if not _CEnregistrePiece( vTOBEcr , true ) then exit ;

 result := true ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 15/03/2004
Modifi� le ... : 26/06/2007
Description .. : 15/03/2004 : Externalisation de la fonction
Suite ........ : TOBEcriture.IsValidAux.
Suite ........ : - LG - FB 16482 - on interdit la saisie des tiers de nature
Suite ........ : Prospect , Concurrent , Suspect .
Suite ........ : - LG - 26/06/2007 - on sort de la validation si le compte 
Suite ........ : n'est pas collectif
Mots clefs ... : 
*****************************************************************}
function  CIsValidAux( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lStCompte : string ;
 lStAux    : string ;
 lStNat    : string ;
begin

  {$IFDEF TT}
  AddEvenement('IsValidAux');
  {$ENDIF}

  result                := RC_PASERREUR ;

  lStCompte             := vTob.GetString('E_GENERAL') ;
  lStAux                := vTob.GetString('E_AUXILIAIRE') ;

  vInfo.Load( lStCompte , lStAux , '' ) ;

  lStCompte             := vInfo.StCompte ;
  lStAux                := vInfo.StAux ;

  if ( vInfo.Compte.InIndex <> -1 ) and ( vInfo.Aux.InIndex <> - 1 ) then
  begin // contr�le si le compte est collectif
    if ( vInfo.GetString('G_COLLECTIF') = '-' ) then
    begin
      result := RC_PASCOLLECTIF ;
      exit ;
    end; // if
  end;

  if ( vInfo.Compte.InIndex <> -1 ) and ( lStAux  = '' ) and ( vInfo.GetString('G_COLLECTIF') = '-' ) then
   begin // le compte n'est pas collectif on sort direct
    result := RC_PASERREUR ;
    exit ;
   end; // if

  if ( vInfo.Aux.InIndex = - 1 ) and ( vInfo.GetString('G_COLLECTIF') = 'X' ) then
   begin
    result := RC_AUXINEXISTANT ;
    exit;
   end; // if

  if ( vInfo.Aux.InIndex <> - 1 ) and EstConfidentiel( vInfo.GetString('T_CONFIDENTIEL') ) then
   begin
    result := RC_COMPTECONFIDENT ;
    exit ;
   end ;

  // Refuser tiers en devise si pas celle de saisie et pas sur devise pivot ni oppos�e
  if ( vTob.GetString('E_DEVISE') <> '' ) and // vTob.GetValue('E_NATUREPIECE') <> 'ECC'
     ( vTob.GetString('E_DEVISE') <> V_PGI.DevisePivot ) and
     ( vInfo.GetString('T_MULTIDEVISE') = '-' ) and
     ( vInfo.GetString('T_DEVISE') <> vTob.GetString('E_DEVISE') ) then
   begin
    result := RC_TMONODEVISE ;
    exit ;
   end ;


 if ( vInfo.Aux.InIndex <> - 1 ) then
  begin

  lStNat := vInfo.GetString('T_NATUREAUXI') ;

  if ( lStNat = 'PRO' ) or ( lStNat = 'CON' ) or ( lStNat = 'SUS' ) then
   begin
    Result := RC_AUXINEXISTANT ;
    exit ;
   end ;

  end ;

 if result = RC_PASERREUR then
  begin
   vTob.PutValue('E_GENERAL'    , vInfo.StCompte ) ;
   vTob.PutValue('E_AUXILIAIRE' , vInfo.StAux ) ;
   result := CIsValidCompte(vTob, vInfo) ;
  end ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 24/04/2007
Modifi� le ... :   /  /    
Description .. : - LG - 24/04/2007 - FB 20056 - ajour d'une nouvelle gestion 
Suite ........ : d'erreur si le mode de reglement du tier est inconnue
Mots clefs ... : 
*****************************************************************}
function CIsValidAuxEnSaisie( vTOB : TOB ; vInfo : TInfoEcriture  ) : integer ;
var
 lStAux    : string ;
 lStcompte : string ;
begin

 result := CIsValidAux(vTOB,vInfo) ;

 if ( result = RC_COMPTEINEXISTANT ) or ( result = RC_NATAUX ) then
  begin
   vTob.PutValue('E_GENERAL' , vInfo.GetString('T_COLLECTIF') ) ;
   result    := CIsValidCompte(vTOB,vInfo) ;
  end; // if

 if result <> RC_PASERREUR then exit ;       // Correction LGE 29/01/2007 : saisie sur auxi ferm�s

 lStCompte  := vTob.GetString('E_GENERAL') ;
 lStAux     := vTob.GetString('E_AUXILIAIRE') ;

 if vInfo.GetString('T_FERME') = 'X' then
  begin
   if ( Arrondi(vInfo.GetValue('T_TOTALDEBIT') - vInfo.GetValue('T_TOTALCREDIT'), 2) = 0 ) then
     begin
      vTOB.PutValue('E_AUXILIAIRE' , '' ) ;
      result := RC_AUXFERME ;
      exit ;
     end
      else
       begin
        result := RC_AUXFERME ;
        exit ;
       end ;
  end ; // if

 if not vInfo.LoadModeRegle(vInfo.GetString('T_MODEREGLE')) then
   begin
    result := RC_MODEREGLE ;
    exit ;
   end ;

end ;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 09/08/2004
Modifi� le ... :   /  /    
Description .. : - 09/08/2004 - test diff pour le mode bor ou piece pour le 
Suite ........ : controle de la date
Mots clefs ... : 
*****************************************************************}
function CIsValidLigneSaisie( vTob : TOB ; vInfo : TInfoEcriture ; vBoPourSaisie : boolean = false ) : TRecError ;
begin

 result.RC_Error := RC_PASERREUR ;

  // test la variable info
  if vInfo = nil then
  begin
    MessageAlerte('La variable Info n''est pas initialis�e ! ') ;
    raise EAbort.Create('') ;
  end;

  // test la variable vTob
  if (vTob = nil) then
  begin
    MessageAlerte('La variable vTob (tob de la pi�ce) ne contient aucune ligne ! ') ;
    raise EAbort.Create('') ;
  end;

  // Mode de saisie
  result.RC_Error := CIsValidModeSaisie ( vTob , vInfo ) ;

  // Etablissement
  if result.RC_Error = RC_PASERREUR then
     result.RC_Error := CIsValidEtabliss( vTob , vInfo ) ;

  // Date Comptable
  if result.RC_Error = RC_PASERREUR then
   result.RC_Error := CIsValidDate( vTob , vInfo ) ;
   
  _CTestErreur(result,vInfo ) ;

  // P�ridoe / Semaine
  if result.RC_Error = RC_PASERREUR then
     result.RC_Error := CIsValidPeriodeSemaine( vTob , vInfo ) ;

  // Journal
  _CTestErreur(result,vInfo ) ;
  if result.RC_Error = RC_PASERREUR then
    result.RC_Error := CIsValidJournal( vTob , vInfo ) ;

  // Nature
  if result.RC_Error = RC_PASERREUR then
    result.RC_Error := CIsValidNat ( vTob , vInfo ) ;

  // Comptes
  if result.RC_Error = RC_PASERREUR then
   begin
    result.RC_Error := CIsValidCompte(vTob,vInfo) ;
    _CTestErreur(result,vInfo ) ;
    if ( result.RC_Error = RC_COMPTEVISA ) and not vBoPourSaisie then
     result.RC_Error := RC_PASERREUR ;
   end ;

  // Auxiliaire
  if result.RC_Error = RC_PASERREUR then
    result.RC_Error := CIsValidAux(vTob,vInfo) ;
  _CTestErreur(result,vInfo ) ;

  // DebitCredit
  if result.RC_Error = RC_PASERREUR then
    begin
    result.RC_Error := CIsValidMontant( vTob.GetDouble('E_DEBIT') ) ;
    if result.RC_Error = RC_PASERREUR then
      result.RC_Error := CIsValidMontant( vTob.GetDouble('E_CREDIT') ) ;
    if result.RC_Error = RC_PASERREUR then
      if ( vTob.GetDouble('E_DEBIT') = 0 ) and ( vTob.GetDouble('E_CREDIT') = 0 ) then
        result.RC_Error := RC_MONTANTINEXISTANT ;
    end ;
  _CTestErreur(result,vInfo ) ;

  // A-nouveaux
  if result.RC_Error = RC_PASERREUR then
    result.RC_Error := CIsValidEcrANouveau ( vTob , vInfo ) ;
  _CTestErreur(result,vInfo ) ;

  // Autres tests sur la ligne
  if result.RC_Error = RC_PASERREUR then
    result.RC_Error := _IsValidLigne( vTob , vInfo ) ;
  _CTestErreur(result,vInfo ) ;

  // Champs obligatoire
  if result.RC_Error = RC_PASERREUR then
   result.RC_Error := CControleChampsObligSaisie( vTob, result.RC_Message ) ;
  _CTestErreur(result,vInfo ) ;

end ;


procedure TInfoEcriture.AjouteErrIgnoree(Value : array of Integer);
var
 i : integer ;
begin
 SetLength(FErreurIgnoree, SizeOf(Value));
 for  i := low(Value) to High(Value) do
  FErreurIgnoree[i] := Value[i] ;
end;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 19/03/2004
Modifi� le ... :   /  /
Description .. : Valide une pi�ce sous forme de TOB, vInfo doit �tre
Suite ........ : renseign� (cf CChargeTInfoEcr si besoin).
Suite ........ :
Suite ........ : Retourne un code erreur :
Suite ........ :  RC_PASERREUR si ok,
Suite ........ :  un autre code sinon.
Mots clefs ... :
*****************************************************************}
Function CIsValidSaisiePiece( vTob : TOB ; vInfo : TInfoEcriture ; vBoPourSaisie : boolean = false ) : TRecError ;
var
 i : integer ;
begin

  result.RC_Error := RC_PASERREUR ;

  // test la variable info
  if vInfo = nil then
  begin
    MessageAlerte('La variable Info n''est pas initialis�e ! ') ;
    raise EAbort.Create('') ;
  end;

  // test la variable vTob
  if (vTob = nil) or (vTob.Detail.Count = 0) then
  begin
    MessageAlerte('La variable vTob (tob de la pi�ce) ne contient aucune ligne ! ') ;
    raise EAbort.Create('') ;
  end;

   // Test unitaire des �critures
  for i := 0 to vTob.Detail.Count - 1 do
   begin
    result  := CIsValidLigneSaisie( vTob.Detail[i] , vInfo , vBoPourSaisie ) ;
    _CTestErreur(result,vInfo ) ;
    if  result.RC_Error <> RC_PASERREUR then exit ;
   end ; // for

   // Test le compte de contrepartie + l'�quilibrage de la pi�ce
  result.RC_Error := _IsValidPiece( vTob, vInfo ) ;
  _CTestErreur(result,vInfo ) ;

 end ;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 16/03/2004
Modifi� le ... :   /  /
Description .. : Renseigne vInfo � partir des donn�es de vTob.
Suite ........ : vTob contient un pi�ce comptable :
Suite ........ :  - Ecriture >> Axe >> Analytiq
Mots clefs ... :
*****************************************************************}
procedure CChargeTInfoEcr( vTob : TOB ; var vInfo : TInfoEcriture ; vDossier : String = '' ) ;
var i    : Integer ;
    lTob : TOB ;
begin

  // instanciation du TInfoECriture
  if vInfo= nil then
    vInfo := TInfoEcriture.Create( vDossier ) ;

  // pas de chargement si pas de ligne d'�criture dans la pi�ce
  if vTob.Detail.count = 0 then Exit ;

  // Donn�es communes � la pi�ce
  lTob := vTob.Detail[0] ;
  vInfo.LoadJournal(    lTob.GetValue('E_JOURNAL')           ) ; // Journal
  vInfo.Etabliss.load(  [ lTob.GetValue('E_ETABLISSEMENT') ] ) ; // Etablissement
  vInfo.Devise.load(    [ lTob.GetValue('E_DEVISE') ]        ) ; // Devise

  // Donn�es pour chaques lignes
  for i := 0 to vTob.Detail.count - 1 do
    begin
    lTob := vTob.Detail[i] ;
    vInfo.LoadCompte( lTob.GetValue('E_GENERAL')    ) ; // Compte g�n�ral
    vInfo.LoadAux(    lTob.GetValue('E_AUXILIAIRE') ) ; // compte auxiliaire
    end ;

end ;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 28/04/2004
Modifi� le ... : 21/07/2006
Description .. : Equivalent de WhereEcriture d�finit dans Saiscomm, mais 
Suite ........ : en prenant pour r�f�rence une TOB � la place du RMVT.
Suite ........ :
Suite ........ : Retourne la condition SQL permettant permettant d'identifier 
Suite ........ : la pi�ce dont la ligne d'�criture de r�f�rence vTobEcr est 
Suite ........ : issue.
Suite ........ : Si vBoLigneSeule est � True, alors la clause where
Suite ........ : comprend la condition sur le num�ro de ligne de vTobEcr.
Suite ........ :
Suite ........ : 02/08/2004 : Prise en compte que la tob de r�f�rence ne
Suite ........ : pointe pas forc�ment sur la m�me table que la condition
Suite ........ : g�n�r�e (utiliser par ex. pour retrouver l'analytique d'une
Suite ........ : ligne d'�criture g�n�rale)
Suite ........ :
Suite ........ : 21/02/05 : JP suppression de NaturePiece qui ne fait pas
Suite ........ : partie des clefs sur les �critures
Suite ........ :
Suite ........ : 21/07/06 : JP Ajout du param�tre facultatif "Prefix"
Mots clefs ... :
*****************************************************************}
function WhereEcritureTOB( vTS : TTypeSais ; vTobEcr : TOB ; vBoLigneSeule : boolean ; vBoBordereau : Boolean = FALSE; Prefix : string = '') : String ;
var lStPref : String ; // Pr�fixe � utiliser sur la Tob pass�e en param�tres
begin

  Result := '' ;

  // D�termination du pr�fixe utilis� par la tob contenant l'�criture de r�f�rence
  {JP 21/07/06 : Ajout du param�tre facultatif Pr�fix}
  if Prefix <> '' then lStPref := Prefix
                  else lStPref := TableToPrefixe( vTobEcr.NomTable ) ;
//  if (lStPref = '') and (vTobEcr.FieldExists('PREFIXE') ) then // Possibilit� d'utilis� un champ suppl�mentaire pour les tobs virtuelles
  //  lStPref := vTobEcr.GetValue('PREFIXE') ;
  if lStPref = '' then                                         // Pas de pr�fixe on sort
    Exit ;

  // construction de la condition SQL suivant table de destination
  case vTS of
    tsGene,tsTreso,tsPointage,tsLettrage :
              begin
              if vBoBordereau then
                begin
                Result := 'E_JOURNAL="'     + vTobEcr.GetString( lStPref + '_JOURNAL')      + '"' +
                     ' AND E_EXERCICE="'    + vTobEcr.GetString( lStPref + '_EXERCICE')     + '"' +
                     ' AND E_DATECOMPTABLE>="' + USDATETIME( DebutDeMois( vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE'))) + '" ' +
                     ' AND E_DATECOMPTABLE<="' + USDATETIME( FinDeMois(   vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE'))) + '" ' +
//                     ' AND E_PERIODE='      + vTobEcr.GetString( lStPref + '_PERIODE')      +
                     ' AND E_NUMEROPIECE='  + vTobEcr.GetString( lStPref + '_NUMEROPIECE')  +
                     ' AND E_QUALIFPIECE="' + vTobEcr.GetString( lStPref + '_QUALIFPIECE')  + '" ' ;
                end else
                begin
                Result := 'E_JOURNAL="'         + vTobEcr.GetString( lStPref + '_JOURNAL')     + '"' +
                       ' AND E_EXERCICE="'      + vTobEcr.GetString( lStPref + '_EXERCICE')    + '"' +
                       ' AND E_DATECOMPTABLE="' + UsDateTime( vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE') ) + '"' +
                       ' AND E_NUMEROPIECE='    + vTobEcr.GetString( lStPref + '_NUMEROPIECE') +
                       ' AND E_QUALIFPIECE="'   + vTobEcr.GetString( lStPref + '_QUALIFPIECE') + '"';
                end ;
              if vBoLigneSeule then
                Result := Result + ' AND E_NUMLIGNE=' + vTobEcr.GetString( lStPref + '_NUMLIGNE')
                                 + ' AND E_NUMECHE='  + vTobEcr.GetString( lStPref + '_NUMECHE')  ;
              end ;
   tsBudget : begin
              Result := 'BE_BUDJAL="'      + vTobEcr.GetValue( lStPref + '_BUDJAL')      + '"' +
                   ' AND BE_NATUREBUD="'   + vTobEcr.GetValue( lStPref + '_NATUREBUD')   + '"' +
                   ' AND BE_QUALIFPIECE="' + vTobEcr.GetValue( lStPref + '_QUALIFPIECE') + '"' +
                   ' AND BE_NUMEROPIECE='  + IntToStr(vTobEcr.GetValue( lStPref + '_NUMEROPIECE')) ;
              if vBoLigneSeule then
                Result := Result + ' AND BE_BUDGENE="' + vTobEcr.GetValue( lStPref + '_BUDGENE') + '"'
                                 + ' AND BE_BUDSECT="' + vTobEcr.GetValue( lStPref + '_BUDSECT') + '"'
                                 + ' AND BE_AXE="'     + vTobEcr.GetValue( lStPref + '_AXE')     + '"' ;
              end ;
         else begin
              {tsAnal, tsODA}
              if vBoBordereau then
                begin
                Result := 'Y_JOURNAL="'       + vTobEcr.GetString( lStPref + '_JOURNAL')     + '"' +
                     ' AND Y_EXERCICE="'      + vTobEcr.GetString( lStPref + '_EXERCICE')    + '"' +
                     ' AND Y_DATECOMPTABLE>="' + USDATETIME( DebutDeMois( vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE'))) + '" ' +
                     ' AND Y_DATECOMPTABLE<="' + USDATETIME( FinDeMois(   vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE'))) + '" ' +
//                     ' AND Y_PERIODE='        + vTobEcr.GetString( lStPref + '_PERIODE')     +
                     ' AND Y_NUMEROPIECE='    + vTobEcr.GetString( lStPref + '_NUMEROPIECE') +
                     ' AND Y_QUALIFPIECE="'   + vTobEcr.GetString( lStPref + '_QUALIFPIECE') + '"' ;
                end
              else
                begin
                Result := 'Y_JOURNAL="'       + vTobEcr.GetString( lStPref + '_JOURNAL')     + '"' +
                     ' AND Y_EXERCICE="'      + vTobEcr.GetString( lStPref + '_EXERCICE')    + '"' +
                     ' AND Y_DATECOMPTABLE="' + UsDateTime(vTobEcr.GetDateTime( lStPref + '_DATECOMPTABLE')) + '"' +
                     ' AND Y_NUMEROPIECE='    + vTobEcr.GetString( lStPref + '_NUMEROPIECE') +
                     ' AND Y_QUALIFPIECE="'   + vTobEcr.GetString( lStPref + '_QUALIFPIECE') + '"' ;
                end ;
              if vTS = tsODA then
                 begin
                 Result := Result + ' AND Y_AXE="'     + vTobEcr.GetValue( lStPref + '_AXE')     + '"'
                                  + ' AND Y_GENERAL="' + vTobEcr.GetValue( lStPref + '_GENERAL') + '"' ;
                 if vTobEcr.GetValue( lStPref + '_NUMLIGNE') > 0 then
                   Result := Result + ' AND Y_NUMLIGNE=' + vTobEcr.GetString( lStPref + '_NUMLIGNE') ;
                 end
              else if vBoLigneSeule then
                   Result := Result + ' AND Y_NUMLIGNE=' + vTobEcr.GetString( lStPref + '_NUMLIGNE') ;
              end ;
   end ;

end ;



const MarquedIBANpourE_RIB = '*' ;
{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 23/04/2004
Modifi� le ... :   /  /
Description .. : Renvoie TRUE si le contenu de vE_RIB para�tre un IBAN
Mots clefs ... : E_RIB;IBAN
*****************************************************************}
function RIBestIBAN ( vE_Rib : String ) : Boolean ;
Begin
  Result:=(Copy(vE_RIB,1,length(MarquedIBANpourE_RIB))=MarquedIBANpourE_RIB) ;
End ;

{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 23/04/2004
Modifi� le ... :   /  /
Description .. : Fait les adaptation n�cessaires pour signaler que le contenu
Suite ........ : de E_RIB est un IBAN
Mots clefs ... :
*****************************************************************}
Function IBANtoE_RIB( vIBan : String ) : String ;
Begin
   Result:='' ;
   viban:=trim(vIban) ;
   if vIban<>'' then
      Result:=MarquedIBANpourE_RIB+vIban ;
End ;




{***********A.G.L.***********************************************
Auteur  ...... : Stephane BOUSSERT
Cr�� le ...... : 23/12/2004
Modifi� le ... :   /  /
Description .. : Renseigne le champ E_REGIMETVA dans la Tob Ecriture
Suite ........ : pass�e en param�tre
Mots clefs ... :
*****************************************************************}
procedure CGetRegimeTVA ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
var lStRegime       : String ;
    lBoDetruireInfo : Boolean ;
begin

 if length(trim( vTOB.GetValue('E_REGIMETVA') )) <> 0 then exit ;

  // === INSTANCIATION TINFOECRITURE ===
  if vInfo = nil then
    begin
    vInfo           := TInfoEcriture.Create ;
    lBoDetruireInfo := true ;
    end
  else
    lBoDetruireInfo := false ;

  try

  // === DETERMINATION DU REGIME ===
  // En priorit�, r�gime de l'auxiliaire
  if vTob.GetValue('E_AUXILIAIRE') <> '' then
    begin
    if vInfo.LoadAux( vTob.GetValue('E_AUXILIAIRE') ) then
      lStRegime := vInfo.GetString('T_REGIMETVA') ;
    end
  // finalement r�gime du g�n�ral
  else if vTob.GetValue('E_GENERAL') <> '' then
    begin
    if vInfo.LoadCompte( vTob.GetValue('E_GENERAL') ) then
      lStRegime := vInfo.GetString('G_REGIMETVA') ;
    end ;
  // R�gime par d�faut
  if lStRegime=''
    then lStRegime := GetParamSocSecur('SO_REGIMEDEFAUT','');

  // === AFFECTATION DU REGIME ===
  vTob.PutValue('E_REGIMETVA', lStRegime ) ;


  finally
   // === LIBERATION TINFOECRITURE ===
   if lBoDetruireInfo then vInfo.Free ;
  end ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : Stephane BOUSSERT
Cr�� le ...... : 23/12/2004
Modifi� le ... :   /  /
Description .. : Renseigne les champs E_REGIMETVA, E_TVA et E_TPF
Suite ........ : dans la Tob Ecriture pass�e en param�tre
Mots clefs ... :
*****************************************************************}
procedure CGetTVA       ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
var lBoDetruireInfo : Boolean ;
begin

  // === INSTANCIATION TINFOECRITURE ===
  if vInfo = nil then
    begin
    vInfo           := TInfoEcriture.Create ;
    lBoDetruireInfo := true ;
    end
  else
    lBoDetruireInfo := false ;

  // === AFFETATION DU REGIME TVA ===
  CGetRegimeTva( vTOB, vInfo ) ;

  // === AFFECTATION CODES TVA / TPF
  vTob.PutValue( 'E_TVA', '' ) ;
  vTob.PutValue( 'E_TPF', '' ) ;
  if vInfo.LoadCompte( vTob.GetValue('E_GENERAL') ) then
      begin
      // Taxes
      if vInfo.Compte.IsHT then
        begin
        vTob.PutValue( 'E_TVA', vInfo.GetString('G_TVA') ) ;
        vTob.PutValue( 'E_TPF', vInfo.GetString('G_TPF') ) ;
        end ;
      end ;

  // === LIBERATION TINFOECRITURE ===
  if lBoDetruireInfo then vInfo.Free ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : Stephane BOUSSERT
Cr�� le ...... : 23/12/2004
Modifi� le ... :   /  /    
Description .. : Renseigne le champ E_CONSO dans la Tob Ecriture
Suite ........ : pass�e en param�tre
Mots clefs ... : 
*****************************************************************}
procedure CGetConso     ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
var lBoDetruireInfo : Boolean ;
    lStConso        : String ;
begin

  // === INSTANCIATION TINFOECRITURE ===
  if vInfo = nil then
    begin
    vInfo           := TInfoEcriture.Create ;
    lBoDetruireInfo := true ;
    end
  else
    lBoDetruireInfo := false ;

  // === DETERMINATION DU CODE CONSO ===
  if vTob.GetValue('E_AUXILIAIRE') <> '' then
    begin
    if vInfo.LoadAux( vTob.GetValue('E_AUXILIAIRE') ) then
       lStConso := vInfo.GetString('T_CONSO') ;
    end
  else if vTob.GetValue('E_GENERAL') <> '' then
    begin
    if vInfo.LoadCompte( vTob.GetValue('E_GENERAL') ) then
       lStConso := vInfo.Compte.GetValue('G_CONSO') ;
    end
  else
    lStConso := '' ;

  // === AFFECTATION DU CODE CONSO ===
  vTob.PutValue( 'E_CONSO', lStConso ) ;

  // === LIBERATION TINFOECRITURE ===
  if lBoDetruireInfo then vInfo.Free ;

end ;



function EncodeDateBor ( vInAnnee , vInMois : integer ; vTExo : TExoDate ) : TDateTime ;
begin
 result := EncodeDate(vInAnnee,vInMois,1) ;
 if result < vTExo.Deb then
  result := vTExo.Deb ;
end ;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... :   /  /
Modifi� le ... : 20/01/2005
Description .. :
Mots clefs ... :
*****************************************************************}
function CEstAutoriseDelettrage( vBoSelected : Boolean; vBoTestSelected : Boolean ) : Boolean;
begin
  Result := False;
  if vBoTestSelected then
  begin
    if not vBoSelected then
    begin
      PGIInfo('Aucune ligne de selectionn�e ! ', 'Selection impossible');
      Exit;
    end;
  end;

  if CEstBloqueBor('', -1, -1, True) then
  begin
    PGIError('Un bordereau est ouvert, vous ne pouvez pas utilis� ce traitement  ! ', 'Traitement impossible');
    exit;
  end;
  Result := True;
end;


procedure CPutTOBCompl ( vTOB : TOB ;  Valeur : TOB ) ;
begin
 vTob.AddChampSupValeur('PCOMPL',longInt(Valeur),false) ;
end ;

function CGetTOBCompl ( vTOB : TOB ) : TOB ;
var
 lP : Variant ;
begin
 result := nil ;
 if vTOB.FieldExists('PCOMPL') then
  begin
   lP     := vTOB.GetValue('PCOMPL') ;
   if ( VarAsType(lP, VarString) <> #0 ) and ( VarAsType(lP, VarInteger) <> - 1 ) then  //if Length(VarAsType(lP, VarString)) > 1 then
   result := TOB(LongInt(lP)) ;
  end ; // if
end ;

procedure CPutValueTOBCompl ( vTOB : TOB ;  Nom : string ; Valeur : Variant ) ;
var
 lTOB : TOB ;
begin
 lTOB := CGetTOBCompl(vTOB) ;
 if lTOB <> nil then
  lTOB.PutValue(Nom,Valeur) ;
end ;

function CGetValueTOBCompl ( vTOB : TOB ; Nom : string ) : Variant ;
var
 lTOB : TOB ;
begin
 result := #0 ;
 lTOB := CGetTOBCompl(vTOB) ;
 if lTOB <> nil then
  result := lTOB.GetValue(Nom) ;
end ;

function CSelectDBTOBCompl( vTOB : TOB ; TheParent : TOB ) : TOB ;
var
 lSt   : string ;
 lQ    : TQuery ;
begin
  lSt := 'SELECT * FROM ECRCOMPL WHERE EC_JOURNAL="' + vTOB.GetString('E_JOURNAL')      + '" ' +
        'AND EC_EXERCICE="'            + vTOB.GetString('E_EXERCICE')                  + '" ' +
        'AND EC_DATECOMPTABLE="'       + usDateTime(vTOB.GetDateTime('E_DATECOMPTABLE')) + '" ' +
        'AND EC_EXERCICE="'            + vTOB.GetString('E_EXERCICE')                  + '" ' +
        'AND EC_NUMEROPIECE='          + vTOB.GetString('E_NUMEROPIECE')     + ' '  +
        'AND EC_NUMLIGNE='             + vTOB.GetString('E_NUMLIGNE')        + ' '  +
        'AND EC_QUALIFPIECE="'         + vTOB.GetString('E_QUALIFPIECE')               + '" ' ;

  lQ     := OpenSql( lSt , true,-1,'',true ) ;
  result := TOB.Create('ECRCOMPL',TheParent,-1) ;
  result.SelectDB('',lQ) ;
  CPutTOBCompl(vTOB,result) ;
  Ferme(lQ) ;
end ;

procedure CDeleteDBTOBCompl( vQ : TQuery ) ;
begin
  ExecuteSQL( 'DELETE FROM ECRCOMPL WHERE EC_JOURNAL="' + vQ.FindField('E_JOURNAL').asString           + '" ' +
              'AND EC_EXERCICE="'            + vQ.FindField('E_EXERCICE').asString                     + '" ' +
              'AND EC_DATECOMPTABLE>="'      + usDateTime( DebutDeMois( vQ.FindField('E_DATECOMPTABLE').asDateTime ) ) + '" ' +
              'AND EC_DATECOMPTABLE<="'      + usDateTime( FinDeMois( vQ.FindField('E_DATECOMPTABLE').asDateTime ) ) + '" ' +
              'AND EC_EXERCICE="'            + vQ.FindField('E_EXERCICE').asString                     + '" ' +
              'AND EC_NUMEROPIECE='          + vQ.FindField('E_NUMEROPIECE').asString                  + ' '  +
              'AND EC_NUMLIGNE='             + vQ.FindField('E_NUMLIGNE').asString                     + ' '  +
              'AND EC_QUALIFPIECE="'         + vQ.FindField('E_QUALIFPIECE').asString                  + '" ' )
end ;


procedure CSupprimerEcrCompl( vTOB : TOB ; vDossier : String = '' ) ;
begin
 if vTOB.GetValue('E_NUMLIGNE') = 1 then
   begin
   ExecuteSQL( 'DELETE FROM ' + GetTableDossier( vDossier, 'ECRCOMPL' ) +
               ' WHERE EC_JOURNAL="'        + vTOB.GetString('E_JOURNAL')                   + '" ' +
                  'AND EC_EXERCICE="'       + vTOB.GetString('E_EXERCICE')                  + '" ' +
                  'AND EC_DATECOMPTABLE>="'  + usDateTime( DebutDeMois( vTOB.GetDateTime('E_DATECOMPTABLE') ) ) + '" ' +
                  'AND EC_DATECOMPTABLE<="'  + usDateTime( FinDeMois( vTOB.GetDateTime('E_DATECOMPTABLE') ) ) + '" ' +
                  'AND EC_EXERCICE="'       + vTOB.GetString('E_EXERCICE')                  + '" ' +
                  'AND EC_NUMEROPIECE='     + vTOB.GetString('E_NUMEROPIECE')               + ' '  +
                  'AND EC_QUALIFPIECE="'    + vTOB.GetString('E_QUALIFPIECE')               + '" ' )
   end ;
end ;

function CCreateDBTOBCompl( vTOB : TOB ; TheParent : TOB ; Q : TQuery ) : TOB ;
begin
 result:= TOB.CreateDB('ECRCOMPL',TheParent,-1,Q) ;
 CPutTOBCompl(vTOB,result) ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 22/11/2007
Modifi� le ... :   /  /    
Description .. : - 22/11/2007 - LG - on stocke le numgroupeecr pour els 
Suite ........ : jointure ds la consultation des comptes
Mots clefs ... : 
*****************************************************************}
procedure CMAJTOBCompl( vTOB : TOB ) ;
var
 lTOB : TOB ;
begin
 lTOB :=  CGetTOBCompl(vTOB) ;
 if lTOB = nil then exit ;
 lTOB.PutValue('EC_EXERCICE'      , vTOB.GetValue('E_EXERCICE') ) ;
 lTOB.PutValue('EC_JOURNAL'       , vTOB.GetValue('E_JOURNAL') ) ;
 lTOB.PutValue('EC_DATECOMPTABLE' , vTOB.GetValue('E_DATECOMPTABLE') ) ;
 lTOB.PutValue('EC_NUMEROPIECE'   , vTOB.GetValue('E_NUMEROPIECE') ) ;
 lTOB.PutValue('EC_NUMLIGNE'      , vTOB.GetValue('E_NUMLIGNE') ) ;
 lTOB.PutValue('EC_QUALIFPIECE'   , vTOB.GetValue('E_QUALIFPIECE') ) ;
 lTOB.PutValue('EC_CLEECR'        , vTOB.GetString('E_NUMGROUPEECR') ) ;
{ lTOB.PutValue('EC_CLEECR'        , vTOB.GetString('E_EXERCICE')                  + ';' +
                                    vTOB.GetString('E_JOURNAL')                   + ';' +
                                    DateToStr(vTOB.GetDateTime('E_DATECOMPTABLE'))  + ';' +
                                    vTOB.GetString('E_NUMEROPIECE')                 + ';' +
                                    vTOB.GetString('E_NUMLIGNE')                    + ';' +
                                    vTOB.GetString('E_QUALIFPIECE')                  + ';' ) ; }

 // CEGID V9
 lTOB.PutValue('EC_ENTITY'        , 0 ) ;
 lTOB.PutValue('EC_ID'            , 0 ) ;
 // ------------------------------------------
end ;

function CCreateTOBCompl( vTOB : TOB ; TheParent : TOB ) : TOB ;
begin
 result:= TOB.Create('ECRCOMPL',TheParent,-1) ;
 CPutTOBCompl(vTOB,result) ;
 CMAJTOBCompl(vTOB) ;
end ;

procedure CFreeTOBCompl ( vTob : TOB ) ;
var
 lTOB : TOB ;
begin
 lTOB := CGetTOBCompl(vTob) ;
 if Assigned(lTOB) then FreeAndNil(lTOB) ;
 if vTOB.FieldExists('PCOMPL') then
   vTob.PutValue('PCOMPL',-1) ;
end ;


{***********A.G.L.***********************************************
Auteur  ...... : Laurent Gendreau
Cr�� le ...... : 30/08/2005
Modifi� le ... : 16/05/2007
Description .. : - FB - 15874 - ajout du calcul du trimestre, semestre et 
Suite ........ : quadri
Suite ........ : - FB 19119 - ajout du bi-menstrielle
Suite ........ :  - FB 20097 - la calcul bimestre etait incorrect
Mots clefs ... : 
*****************************************************************}
procedure CCalculDateCutOff( vTOB : TOB ; G_CUTOFFPERIODE : string ; G_CUTOFFECHUE : string) ;
var
 lYear,lDay,lMonth : word ;
 s : string ;
 lDt1,lDt2 : TDateTime ;
begin

 lDT1 := iDate1900 ;
 lDT2 := iDate1900 ;
 s    := G_CUTOFFPERIODE ;

 if length(trim(s)) = 0 then exit ;

 DecodeDate(vTOB.GetValue('EC_DATECOMPTABLE') , lYear, lMonth, lDay) ;

 if G_CUTOFFECHUE = '-' then
  begin // avance
   lDT1 := vTOB.GetValue('EC_DATECOMPTABLE') ;
   case s[2] of
    'A' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 1 , 'A') - 1 ;//EncodeDate(lYear+1,lMonth, lDay) - 1 ;
    'M' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 1 , 'M') - 1 ;
    'S' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 6 , 'M') - 1 ;
    'T' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 3 , 'M') - 1 ;
    'Q' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 4 , 'M') - 1 ;
    'P' :  lDT2 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , 2 , 'M') - 1 ;
   end ; // Case
  end
   else
    begin
     lDT2 := vTOB.GetValue('EC_DATECOMPTABLE') ;
     case s[2] of
      'A' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -1 , 'A') + 1 ; //EncodeDate(lYear-1,lMonth, lDay) + 1 ;
      'M' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -1 , 'M') + 1;
      'S' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -6 , 'M') + 1;
      'T' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -3 , 'M') + 1;
      'Q' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -4 , 'M') + 1;
      'P' :  lDT1 := PlusDate(vTOB.GetValue('EC_DATECOMPTABLE') , -2 , 'M') + 1 ;
     end ; // Case
    end ;

 vTOB.PutValue( 'EC_CUTOFFDEB' , lDT1 ) ;
 vTOB.PutValue( 'EC_CUTOFFFIN' , lDT2 ) ;

end ;

{$IFNDEF EAGLSERVER}
{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 25/08/2005
Modifi� le ... : 25/08/2005
Description .. : - FB 16397 - LG  - 25/08/2005 - test de la revision 
Suite ........ : uniquement pour l'exercice en cours
Mots clefs ... : 
*****************************************************************}
function CControleVisa ( vStCompte : string ; vInfo : TInfoEcriture )  : boolean ;
begin
 result := true ;

 if not vInfo.LoadCompte( vStCompte ) or ( vInfo.TypeExo <> teEnCours ) then exit ;

 if ( vInfo.GetString('G_VISAREVISION') = 'X' ) then
  begin

   if PGIAsk('Le compte est vis�' + #10#13 + 'Voulez-vous supprimer le visa de r�vision ?')<> idYes then
    begin
     result := false ;
     exit ;
    end ; // if

   ExecuteSQL('update GENERAUX set G_VISAREVISION="-" where G_GENERAL="'+ vStCompte + '" ') ;
   vInfo.Compte.Clear ;
   
  end ;

end ;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 23/08/2005
Modifi� le ... :   /  /
Description .. :
Suite ........ : Renseigne le champ E_TYPEMVT dans la ligne d'�criture.
Mots clefs ... :
*****************************************************************}
{$IFNDEF NOVH}
procedure CGetTypeMvt    ( vTOB : TOB ; vInfo : TInfoEcriture = nil ) ;
var lBoDetruireInfo : Boolean ;
    lStNatCpt       : String ;
    lStCpt          : String ;
    lStNatPiece     : String ;
    lStTypeMvt      : String ;
    lBoTiers        : Boolean ;
begin

  // === INSTANCIATION TINFOECRITURE ===
  if vInfo = nil then
    begin
    vInfo           := TInfoEcriture.Create ;
    lBoDetruireInfo := true ;
    end
  else
    lBoDetruireInfo := false ;

  // === DETERMINATION DE LA NATURE DE LA PIECE ===
  lStNatPiece := vTob.GetString('E_NATUREPIECE') ;

  // === DETERMINATION DE LA NATURE DU COMPTE ===
  lBoTiers := False ;
  if vTob.GetValue('E_AUXILIAIRE') <> '' then
    begin
    lBoTiers := True ;
    lStCpt   := vTob.GetValue('E_AUXILIAIRE') ;
    if vInfo.LoadAux( lStCpt ) then
      lStNatCpt := vInfo.GetString('T_NATUREAUXI') ;
    end
  else if vTob.GetValue('E_GENERAL') <> '' then
    begin
    lStCpt   := vTob.GetValue('E_GENERAL') ;
    if vInfo.LoadCompte( lStCpt ) then
      lStNatCpt := vInfo.GetString('G_NATUREGENE') ;
    end ;

  // === DETERMINATION DU TYPE DE MVT ===
  lStTypeMvt := 'DIV' ; // par d�faut
  if ( lStNatCpt <> '' ) and ( lStNatPiece <> '' ) and
     not ( ( VH^.PaysLocalisation<>CodeISOES ) and // XVI 24/02/2005
           ( (lStNatPiece<>'FC') and (lStNatPiece<>'AC') and
             (lStNatPiece<>'FF') and (lStNatPiece<>'AF') ) ) then
    begin
    if ( (lStNatCpt='TID') or (lStNatCpt='TIC') or (lStNatCpt='CLI') or
         (lStNatCpt='FOU') or (lStNatCpt='AUD') or (lStNatCpt='AUC')) then lStTypeMvt:='TTC'
    else if EstChaPro( lStNatCpt )     then lStTypeMvt:='HT'
    else if EstTVATPF( lStCpt, True )  then lStTypeMvt:='TVA'
    else if EstTVATPF( lStCpt, False ) then lStTypeMvt:='TPF'
    else if (lStNatCpt='DIV') then
        // Sp�cif compte lettrable divers
        if lBoTiers then lStTypeMvt:='TTC' ; // Point 62 FFF
    end ;

  // === AFFECTATION DU TYPEMVT ===
  vTob.PutValue( 'E_TYPEMVT', lStTypeMvt ) ;

  // === LIBERATION TINFOECRITURE ===
  if lBoDetruireInfo then vInfo.Free ;

end ;
{$ENDIF}


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 27/11/2003
Modifi� le ... : 27/11/2003
Description .. :
Suite ........ : Permet la mise en place de traitements sur une ligne
Suite ........ : d'�criture comptable avant la maj en base de donn�es.
Suite ........ :
Suite ........ : Utilisation de V_PGI.IoError pour gestion des erreurs
Mots clefs ... :
*****************************************************************}
(*
Function  OnUpdateEcriture( vEcr : TQuery ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ) : Boolean ;
begin
  Result := True ;
  // Si la tr�so est s�rialis� (on se contente d'un IFDEF pour le moment), maj des infos de synchro
{$IFNDEF TRESO}
 if EstComptaTreso then
  Result := MajTresoEcriture( vEcr , vAction ) ;
{$ENDIF}
end ;
*)
{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 27/11/2003
Modifi� le ... : 26/10/2006
Description .. : 
Suite ........ : Permet la mise en place de traitements sur une ligne
Suite ........ : d'�criture comptable avant la maj en base de donn�es.
Suite ........ : 
Suite ........ : Utilisation de V_PGI.IoError pour gestion des erreurs
Suite ........ : - LG - 26/10/2006 - mise � jour du parametre societe des 
Suite ........ : liaisses indiquant un modif d'ecrire
Mots clefs ... : 
*****************************************************************}
function  OnUpdateEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ; vInfo : TInfoEcriture = nil  ) : boolean ;
var lTOB     : TOB ;
    lDossier : String ;
begin
 result := true ;
{$IFNDEF PGIIMMO}

 if EstMultiSoc and Assigned( vInfo ) then
  lDossier := vInfo.Dossier
   else
    lDossier := '' ;

 if ( vEcr.GetValue('E_NUMLIGNE') = 1 ) then
  CPStatutDossier(lDossier) ;

 if cEcrCompl in vListeAction then
  begin
   CSupprimerEcrCompl( vEcr, lDossier ) ;
   lTOB := CGetTOBCompl(vEcr) ;
   if lTOB <> nil then
    begin
     CMAJTOBCompl(vEcr) ;
     if lDossier <> '' then InsertTobMS( lTob, lDossier )
       else
        lTOB.InsertDB(nil) ;
    end ;
  end ;
{$ENDIF}
  // Si la tr�so est s�rialis� (on se contente d'un IFDEF pour le moment), maj des infos de synchro
{$IFNDEF LAURENT}
{$IFNDEF CCSTD}
{$IFNDEF CCADM}
{$IFNDEF TRESO}
  {JP 14/06/06 : FQ TRESO 10365 : Pour le moment on d�sactive la saisie bordereau, car il faut repenser
                 la constitution du num�ro de transaction en Treso : un m�me num�ro de pi�ce (id Folio)
                 pouvant exister pour chaque mois, on se retrouve avec un violation de clef
   JP 11/10/06 : Apr�s modification du num�ro de transaction en Tr�so, je tente de r�activ� la saisie Boredereau}
  if EstComptaTreso {and not (cEcrBor in vListeAction)} then
     Result := MajTresoEcritureTOB( vEcr , vAction, vInfo ) ;
{$ENDIF}
{$ENDIF}
{$ENDIF}
{$ENDIF} 
end ;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 27/11/2003
Modifi� le ... : 27/11/2003
Description .. :
Suite ........ : Permet la mise en place de traitements sur une ligne
Suite ........ : d'�criture comptable avant sa suppression en base de
Suite ........ : donn�es.
Suite ........ :
Suite ........ : Utilisation de V_PGI.IoError pour gestion des erreurs
Mots clefs ... :
*****************************************************************}
(*
Function  OnDeleteEcriture( vEcr : TQuery ; vListeAction : TOnUpdateEcritures) : Boolean ;
begin
  Result := True ;
  {$IFNDEF PGIIMMO}
  if cEcrCompl in vListeAction then CDeleteDBTOBCompl(vEcr) ;
  {$ENDIF}
  // Si la tr�so est s�rialis� (on se contente d'un IFDEF pour le moment), maj des infos de synchro
  if EstComptaTreso then
    Result := MajTresoSupprEcriture( vEcr ) ;
end ;
*)
Function  OnDeleteEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vListeAction : TOnUpdateEcritures ) : Boolean ;
begin
  Result := True ;
  {$IFNDEF PGIIMMO}
 if ( vEcr.GetValue('E_NUMLIGNE') = 1 ) then
  CPStatutDossier ;
  
  if cEcrCompl in vListeAction then CSupprimerEcrCompl(vEcr) ;
  {$ENDIF}
  // Si la tr�so est s�rialis� (on se contente d'un IFDEF pour le moment), maj des infos de synchro
  {JP 14/06/06 : FQ TRESO 10365 : Pour le moment on d�sactive la saisie bordereau, car il faut repenser
                 la constitution du num�ro de transaction en Treso : un m�me num�ro de pi�ce (id Folio)
                 pouvant exister pour chaque mois, on se retrouve avec un violation de clef
   JP 11/10/06 : Apr�s modification du num�ro de transaction en Tr�so, je tente de r�activ� la saisie Boredereau}
  {$IFNDEF LAURENT}
  {$IFNDEF CCSTD}
  {$IFNDEF CCADM}
  if EstComptaTreso {and not (cEcrBor in vListeAction)} then
    Result := MajTresoSupprEcritureTOB( vEcr ) ;
  {$ENDIF}
  {$ENDIF}
  {$ENDIF} 
end ;





{ TZSections }

function TZSections.GetCompte(var NumCompte: string ; NumAxe : string ; vBoEnBase : boolean ): integer;
begin
 result   := Load([NumCompte,NumAxe], vBoEnBase) ;
 FInIndex := result ;
 if result <> -1 then
  NumCompte := GetValue('S_SECTION') ;
end;

function TZSections.GetNumAxe: integer;
var lStAxe : string ;
begin
  result := 0 ;
  lStAxe := GetValue('S_AXE') ;
  if length( lStAxe ) = 2 then
    result := ValeurI( lStAxe[2] ) ;
end;

function TZSections.GetStAxe: string;
begin
  result := GetValue('S_AXE') ;
end;

procedure TZSections.Initialize;
begin
  FStTable := 'SECTION' ;
end;

function TZSections.Load(const Values: array of string ; vBoEnBase : boolean = false): integer;
var lStCode : string ;
    lStAxe  : string ;
    lTOB    : TOB ;
    Q       : TQuery ;
begin

  // recherche dans la liste
  Result := inherited Load(Values,vBoEnBase) ;
  if result<>-1 then exit ;
  if SizeOf(Values)=0 then exit ;

  // V�rif code
  lStCode := Values[0] ;
  if Trim(lStCode)='' then exit ;

  lStAxe := Values[1] ;
  if Trim(lStAxe)='' then exit ;

  // Chargement dans la base
  Q := nil ;
  try
    Q := OpenSelect('SELECT * FROM SECTION WHERE S_SECTION="' + UpperCase(lStCode) + '" AND S_AXE="' + lStAxe + '"' , FDossier ) ;
    if not Q.EOF then
      begin
      lTOB := MakeTOB(vBoEnBase) ;
      lTOB.SelectDB( '', Q ) ;
      SetCrit( lTOB, Values ) ;
      //FInIndex := FTOB.Detail.Count-1 ;
      result   := FInIndex ;
      end;
  finally
    Ferme(Q) ;
  end;

end;

{$IFNDEF EAGLSERVER}
{$IFNDEF ERADIO}
function  CLookupListAux( E : TControl ; vStCarLookUp,vStNaturePiece,vStNatureGene : string ; vStTableTiers : string = '' ) : boolean ;
var
 lStSelect     : string ;
 lStColonne    : string ;
 lStOrder      : string ;
 lStWhere      : string ;
 lStAux        : string ;
begin

 CMakeSQLLookupAuxGrid(lStWhere,lStColonne,lStOrder,lStSelect,vStCarLookUp,vStNaturePiece,vStNatureGene);

 if E is THGrid  then
  lStAux := THGrid(E).Cells[THGrid(E).Col,THGrid(E).Row]
   else
    if E is THEdit then
     lStAux := THEdit(E).Text ;

 if vStTableTiers = '' then
  vStTableTiers := 'TIERS' ;

 if GetParamSocSecur('SO_CPMULTIERS',false) then
  begin
   lStAux := AGLLanceFiche('CP','MULTIERS','','','M;' + lStAux + ';' + lStWhere + ';' ) ;
   result := lStAux <> '' ;
   if result and ( E is THGrid ) then
    THGrid(E).Cells[THGrid(E).Col,THGrid(E).Row] := lStAux
     else
      if result and ( E is THEdit ) then
       THEdit(E).Text := lStAux ;
   end
    else
     result := LookupList(E,TraduireMemoire('Auxiliaire'), vStTableTiers ,lStColonne,lStSelect,lStWhere,lStOrder,true, 2,'',tlLocate) ;

end ;
{$ENDIF}
{$ENDIF}



{ TZModePaiement }


procedure TZModePaiement.Initialize;
begin
  FStTable := 'MODEPAIE' ;
end;

function TZModePaiement.Load(const Values: array of string; vBoEnBase: boolean): integer;
var lQEnreg  : TQuery ;
    lStCode  : string ;
    lTOB     : TOB ;
begin

  Result := inherited Load(Values,vBoEnBase) ;
  if result<>-1 then exit ;
  if SizeOf(Values)=0 then exit ;

  lStCode := Values[0] ;
  if Trim(lStCode)='' then exit ;

  lQEnreg:=nil ;
  try
    lQEnreg := OpenSelect('SELECT * FROM MODEPAIE WHERE MP_MODEPAIE="' + UpperCase(lStCode) + '"', FDossier ) ;
    if not lQEnreg.EOF then
      begin
      lTOB := MakeTOB(vBoEnBase) ;
      lTOB.SelectDB('',lQEnreg) ;
      SetCrit(lTOB,Values) ;
      result := FInIndex ;
      end;

    finally
      Ferme(lQEnreg) ;
    end; // try

end;

procedure TZModePaiement.LoadAll;
var lQEnreg  : TQuery ;
    lTOB     : TOB ;
begin

  FTOB.ClearDetail ;

  lQEnreg:=nil ;
  try
    lQEnreg := OpenSelect('SELECT * FROM MODEPAIE', FDossier ) ;
    while not lQEnreg.EOF do
      begin
      lTOB:=MakeTOB ;
      lTOB.SelectDB('',lQEnreg) ;
      SetCrit(lTOB,[lQEnreg.findField('MP_MODEPAIE').asString] ) ;
      lQEnreg.next ;
      end;

    FInIndex := FTOB.Detail.Count-1 ;

    finally
      Ferme(lQEnreg) ;
    end; // try

end;

{ TZModeReglement }

function TZModeReglement.CalculModeFinal( vMontantEcr : Double ; vStModeInit : string ) : tob ;

  function _DetermineMR( vStModeEnCours : string ) : TOB ;
  begin
    if Load([vStModeEnCours])<>-1 then
      begin
      if ( vMontantEcr >= Item.GetDouble('MR_MONTANTMIN') )
               or ( Item.GetString('MR_REMPLACEMIN') = '' )
               or ( Item.GetString('MR_REMPLACEMIN') = vStModeEnCours )
        then result := Item
        else begin
             result := _DetermineMR( Item.GetString('MR_REMPLACEMIN') ) ;
             if result = nil then
               begin
               Load([vStModeEnCours]) ;
               result := Item ;
               end ;
             end ;
      end
    else
      result := nil ;
  end ;

begin

  result       := nil ;

  // Montant � r�partir
//  if vMontantEcr = 0 then Exit ; 

  // Mode de r�glement initiale...
  if vStModeInit = ''
    then vStModeInit := GetParamSocSecur('SO_GCMODEREGLEDEFAUT','') ;
  if vStModeInit = '' then Exit ;

  result := _DetermineMR( vStModeInit ) ;

end;

procedure TZModeReglement.Initialize;
begin
  FStTable := 'MODEREGL' ;
end;

function TZModeReglement.Load(const Values: array of string; vBoEnBase: boolean): integer;
var lQEnreg  : TQuery ;
    lStCode  : string ;
    lTOB     : TOB ;
begin

  Result := inherited Load(Values,vBoEnBase) ;
  if result<>-1 then exit ;
  if SizeOf(Values)=0 then exit ;

  lStCode := Values[0] ;
  if Trim(lStCode)='' then exit ;

  lQEnreg:=nil ;
  try
    lQEnreg := OpenSelect('SELECT * FROM MODEREGL WHERE MR_MODEREGLE="' + UpperCase(lStCode) + '"', FDossier ) ;
    if not lQEnreg.EOF then
      begin
      lTOB := MakeTOB(vBoEnBase) ;
      lTOB.SelectDB('',lQEnreg) ;
      SetCrit(lTOB,Values) ;
      result := FInIndex ;
      end;

    finally
      Ferme(lQEnreg) ;
    end; // try

end;

procedure TZModeReglement.LoadAll;
var lQEnreg  : TQuery ;
    lTOB     : TOB ;
begin

  FTOB.ClearDetail ;
  lQEnreg:=nil ;
  try
    lQEnreg := OpenSelect('SELECT * FROM MODEREGL', FDossier ) ;
    while not lQEnreg.EOF do
      begin
      lTOB:=MakeTOB ;
      lTOB.SelectDB('',lQEnreg) ;
      SetCrit(lTOB,[lQEnreg.findField('MR_MODEREGLE').asString] ) ;
      lQEnreg.next ;
      end;

    FInIndex := FTOB.Detail.Count-1 ;

    finally
      Ferme(lQEnreg) ;
    end; // try

end;

function TZModeReglement.GetDateDepart( vTobEcr : Tob; vStMR : string ): TDateTime;
var lStAPartirDe : string ;
begin

  result := vTobEcr.GetDateTime('E_DATECOMPTABLE') ;

  if (vStMR <> '')
    then Load([ vStMR ])
  else if FInIndex<0 then
    begin
    vStMR := GetParamSocSecur('SO_GCMODEREGLEDEFAUT','') ;
    Load([ vStMR ])
    end ;

  if Item=nil then Exit ;

  lStAPartirDe := Item.GetString('MR_APARTIRDE') ;

  // Choix du d�part
  if lStAPartirDe <> '' then
    begin

    if lStAPartirDe = 'FIN' then
      result := FinDeMois( result )
    else if lStAPartirDe = 'DEB' then
      result := DebutDeMois( result )
    else if lStAPartirDe = 'FAC' then
      begin
      if vTobEcr.GetDateTime('E_DATEREFEXTERNE') > IDate1900 then
        result := vTobEcr.GetDateTime('E_DATEREFEXTERNE') ;
      end
    else if lStAPartirDe = 'FAF' then
      begin
      if vTobEcr.GetDateTime('E_DATEREFEXTERNE') > IDate1900 then
        result := vTobEcr.GetDateTime('E_DATEREFEXTERNE') ;
      result := FinDeMois(result);
      end;
    end ;

  result := result + Item.GetInteger('MR_PLUSJOUR') ;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Laurent GENDREAU
Cr�� le ...... : 18/07/2007
Modifi� le ... :   /  /    
Description .. : - LG - FB 20056 - si le mode de reglment n'existe pas en 
Suite ........ : base , on prends le parma par defaut
Mots clefs ... : 
*****************************************************************}
function CCalculEche( vTobPiece : Tob ; vIndex : integer ; var vStModeFinal : string ; vInfo : TInfoEcriture = nil ; vBoMono : boolean = False ) : boolean ;
var lMontant    : Double ;
    lTotal      : Double ;
    lTobTmp     : Tob ;
    lTobEche    : Tob ;
    lTobRef     : Tob ;
    lMontantRef : Double ;
    lTobMR      : Tob ;
    lStDev      : String ;
    lRDev       : RDEvise ;
    lBoFreeInfo : boolean ;
    lInNbEche   : integer ;
    lInEche     : integer ;
    lStModePaie : string ;
    lTaux       : Double ;
    lDtDepart   : TDateTime ;
    lDtDateRef  : TDateTime ;
begin

  // === Init variables ===
  result       := False ;
  lMontant     := 0 ;
  lTotal       := 0 ;
  lTobRef      := vTobPiece.Detail[ vIndex ] ;
  lDtDateRef   := lTobRef.GetDateTime('E_DATECOMPTABLE') ;
  lBoFreeInfo  := not Assigned( vInfo ) ;
  if lBoFreeInfo then
    vInfo       := TInfoEcriture.Create ;

  try

    // ==================================================
    // === TESTS PREALABLE COMPTES / DEVISE / MONTANT ===
    // ==================================================
    // --> General
    if not vInfo.LoadCompte( lTobRef.GetString('E_GENERAL') ) then Exit ;
    // --> Auxi si collectif
    if vInfo.Compte.IsCollectif and not vInfo.LoadAux( lTobRef.GetString('E_AUXILIAIRE') ) then Exit ;
    // --> Devise
    lStDev       := lTobRef.GetString('E_DEVISE');
    if vInfo.Devise.Load([lStDev])<>-1
      then lRDev := vInfo.Devise.Dev
      else Exit ;
    // --> Montant
    lMontantRef  := Arrondi( lTobRef.GetDouble('E_CREDITDEV') + lTobRef.GetDouble('E_DEBITDEV'), lRDev.Decimale ) ;
    if lMontantRef = 0 then Exit ;

    // R�cup taux
    if lTobRef.GetDouble('E_TAUXDEV')<>0
      then lRDev.Taux := lTobRef.GetDouble('E_TAUXDEV') // lTobRef.GetDouble('E_COTATION') * V_PGI.TauxEuro ;   // lRdCote := lRdTaux / V_PGI.TauxEuro
      else vInfo.Devise.AffecteTaux( lDtDateRef ) ;

    // =========================
    // === Calcul mode final ===
    // =========================
    if (vStModeFinal<>'') and ( vInfo.ModeRegle.Load([vStModeFinal]) <> -1 )
      then lTobMR := vInfo.ModeRegle.Item
      else begin
           // Calcul mode initial
           vStModeFinal := CGetModeRegleInit( lTobRef, vInfo ) ;
           // Calcul mode final
           lTobMR := vInfo.ModeRegle.CalculModeFinal( lMontantRef, vStModeFinal ) ;
           if lTobMR = nil then
            lTobMR := vInfo.ModeRegle.CalculModeFinal( lMontantRef, GetParamSocSecur('SO_GCMODEREGLEDEFAUT','') ) ;
           end ;

    if not Assigned(lTobMR) then Exit ;
    vStModeFinal := lTobMR.GetString('MR_MODEREGLE') ;

    // ============================================================
    // === Cas sp�cifique des divers lettrables : MONO ECHEANCE ===
    // ============================================================
    vInfo.LoadCompte( lTobRef.GetString('E_GENERAL') ) ;
    if vInfo.GetString('G_NATUREGENE') = 'DIV' then
      vBoMono := True ;

    // ====================================
    // ==== Construction des �ch�ances ====
    // ====================================
    lDtDepart   := vInfo.ModeRegle.GetDateDepart( lTobRef ) ;
    lTobTmp     := Tob.Create('CALCUL_ECHE', nil, -1) ;            // conteneur temporaire des �ch�ances
    if vBoMono                                                     // Calcul du nombre d'�ch�ances
      then lInNbEche := 1
      else lInNbEche := lTobMR.GetInteger('MR_NOMBREECHEANCE') ;

    // ===================================
    For lInEche := 1 to lInNbEche do
      begin

      // Cr�ation de l'�criture
      lTobEche := Tob.Create('ECRITURE', lTobTmp, lInEche-1 ) ;
      lTobEche.Dupliquer( lTobRef, False, True, True ) ;
      lTobEche.PutValue( 'E_NUMECHE',      lInEche  ) ;

      // D�termination Mode et Taux
      lStModePaie := lTobMR.GetString('MR_MP'   + IntToStr(lInEche)) ;
      lTaux       := lTobMR.GetDouble('MR_TAUX' + IntToStr(lInEche)) ;

      // Traitement ligne / derni�re ligne
      if lInEche < lInNbEche then
        begin
        if lTaux <> 0 then
          begin
          lMontant := Arrondi(lMontantRef * lTaux / 100.0, lRDev.Decimale );
          lTotal   := Arrondi(lTotal + lMontant, lRDev.Decimale );
          end ;
        end
      else
        lMontant := Arrondi( lMontantRef - lTotal, lRDev.Decimale );

      // affectation des montants
      if lTobRef.GetDouble('E_DEBITDEV')<>0
        then CSetMontants( lTobEche,   lMontant,    0,           lRDev,   True )
        else CSetMontants( lTobEche,   0,           lMontant,    lRDev,   True ) ;

      // Affectation de la date d'�ch�ance
      lDtDepart := EcheArrondie( lDtDepart, lTobMR.GetString('MR_ARRONDIJOUR'), 0, 0);
      lTobEche.PutValue( 'E_DATEECHEANCE',    lDtDepart  ) ;
      lTobEche.PutValue( 'E_ORIGINEPAIEMENT', lDtDepart  ) ;

      // Affectation du mode de paiement
      lTobEche.PutValue( 'E_MODEPAIE',      lStModePaie  ) ;
      {$IFNDEF NOVH}
      lTobEche.PutValue( 'E_CODEACCEPT',    MPTOACC ( lStModePaie ) ) ;
      {$ENDIF}

      // Date de valeur
      if lTobEche.GetDateTime('E_DATEVALEUR')=iDate1900 then
        begin
        if vInfo.GetString('G_POINTABLE')='X'
          then lTobEche.PutValue('E_DATEVALEUR', lDtDateRef )   // Comptes pointables --> Date comptable
          else lTobEche.PutValue('E_DATEVALEUR', lDtDepart ) ;  // Comptes lettrable  --> Date d'�ch�ances
        end ;

      // Calcul de la prochaine date
      lDtDepart := NextEche( lDtDepart, lTobMR.GetString('MR_SEPAREPAR') );

      end ; // FOR

    // ===================================
    // === Mise en place dans la pi�ce ===
    // ===================================
    for lInEche := lTobTmp.Detail.count - 1 downto 0 do
      if lInEche = 0
        then vTobpiece.Detail[vIndex].Dupliquer( lTobTmp.Detail[0], True, True )  // sur Lgned de r�f�rence, copie des valeurs
        else lTobTmp.Detail[lInEche].ChangeParent( vTobpiece, vIndex + 1 ) ;      // ajout des autres lignes

    // ===================================
    result := True ;

    // ===================================
    finally

      // lib�rations
      if assigned( lTobTmp ) then
        FreeAndNil( lTobTmp ) ;

      if lBoFreeInfo then
        FreeAndNil( vInfo ) ;

      end ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : ?
Cr�� le ...... : 12/04/2007
Modifi� le ... :   /  /    
Description .. : - LG - FB 19801 - le calcul des echeances modifiait l'ordre 
Suite ........ : ds ecritures ds la TOB
Mots clefs ... : 
*****************************************************************}
function CCalculMonoEche( vTobEcr : Tob ; vInfo : TInfoEcriture ; vStModeForce : string ) : boolean ;
var lTobPiece   : Tob ;
    lParent     : Tob ;
    lInIndex    : integer ;
    lBoFreeInfo : boolean ;
begin

  if vInfo = nil then
    begin
    vInfo       := TInfoEcriture.Create ;
    lBoFreeInfo := true ;
    end
  else
    lBoFreeInfo := false ;

  lTobPiece := Tob.Create('VIRTUAL_PIECE', nil, -1) ;
  lParent   := vTobEcr.Parent ;
  lInIndex  := vTobEcr.GetIndex ;
  vTobEcr.ChangeParent( lTobPiece, - 1 ) ;

  result := CCalculEche( lTobPiece, 0, vStModeForce, vInfo, True ) ;

  if Assigned( lParent ) then
   vTobEcr.ChangeParent( lParent, lInIndex )
    else
     vTobEcr.ChangeParent( nil,     - 1 ) ;

  // lib�rations
  lTobPiece.Free ;
  if lBoFreeInfo then
    vInfo.Free ;

end ;

function CGetModeRegleInit( vTobEcr : Tob ; vInfo : TInfoEcriture ) : string ;
begin
  result := '' ;

  // recherche du mode de r�glement du compte
  if vInfo.LoadCompte( vTobEcr.GetValue('E_GENERAL') ) then
    begin
    // Auxiliaires
    if vInfo.Compte.IsCollectif then
      begin
      if vInfo.LoadAux( vTobEcr.GetValue('E_AUXILIAIRE') ) then
        result  := vInfo.GetString('T_MODEREGLE') ;
      end
    // TIC / TID / Divers lettrable...
    //   --> Initialisation sur MR par d�faut pour les compte divers lettrables ( FQ 16136 SBO 23/08/2005 )
    else if vInfo.GetString('G_NATUREGENE') <> 'DIV'
       then result := vInfo.GetString('G_MODEREGLE') ;
    end ;

  // si rien de renseign� dans le tiers, mode de r�glement par d�faut
  if result = '' then
    result := GetParamSocSecur('SO_GCMODEREGLEDEFAUT','') ;

end ;


procedure CGetEch ( vTobEcr : Tob   ; vInfo : TInfoEcriture ) ;
var lBoFreeInfo : boolean ;
    lBoAvecEche : boolean ;
begin

  if vInfo = nil then
    begin
    vInfo       := TInfoEcriture.Create ;
    lBoFreeInfo := true ;
    end
  else
    lBoFreeInfo := false ;

  // D�termination du mode de gestion ( avec ou sans �ch�...)
  vInfo.LoadCompte( vTobEcr.GetString('E_GENERAL') ) ;
  lBoAvecEche := // Auxi lettrable
                 ( ( vInfo.GetString('G_COLLECTIF') = 'X' )
                         and vInfo.LoadAux( vTobEcr.GetValue('E_AUXILIAIRE') )
                         and ( vInfo.GetString('T_LETTRABLE') = 'X' )
                 ) OR (
                 // Compte g�n� lettrable ou pointable
                   ( vInfo.GetString('G_POINTABLE')='X' ) or
                   ( vInfo.GetString('G_LETTRABLE') = 'X' ) ) ;

  // Gestion des Ech�ances...
  if lBoAvecEche then
    begin
    // MAJ Indicateurs + init des champs associ�es si besoin
    if vTobEcr.GetString( 'E_ECHE' ) <> 'X' then
      begin
      // Compte pointable ?
      if ( vInfo.GetString('G_NATUREGENE') = 'BQE' ) or ( vInfo.GetString('G_NATUREGENE') = 'CAI' )
        then begin
             CRemplirInfoPointage( vTobEcr ) ;
             vTobEcr.PutValue('E_MODEPAIE', '') ;
             end
        else begin
             CRemplirInfoLettrage( vTobEcr ) ;
             vTobEcr.PutValue('E_MODEPAIE', '') ;
             end ;
      end ;

    // Calcul si les montants sont renseign�s
    if ( vTobEcr.GetDouble('E_CREDITDEV') + vTobEcr.GetValue('E_DEBITDEV') ) <> 0 then
      CCalculMonoEche( vTOBEcr , vInfo ) ;

    end
  else
    begin
    // Suppression des infos si besoin
     CSupprimerInfoLettrage( vTobEcr ) ;
    end ;

  // Lib�ration
  if lBoFreeInfo then
    FreeAndNil( vInfo ) ;

end ;

function EcheArrondie(DRef: TDateTime; ArrondirAu: String3; JP1, JP2: integer): TDateTime;
var
  dd, mm, yy, D1, D2, D3: Word;
  D: TDateTime;
  JMax: integer;
begin
  D := DRef;
  DecodeDate(D, yy, mm, dd);
  if ArrondirAu = 'FIN' then D := FinDeMois(D) else
    if ArrondirAu = 'DEB' then
  begin
    if dd > 1 then D := DebutDeMois(PlusMois(D, 1));
  end else
    if ArrondirAu = '05M' then
  begin
    if dd <= 05 then D := EncodeDate(yy, mm, 05) else D := DebutDeMois(PlusMois(D, 1)) + 4;
  end else
    if ArrondirAu = '10M' then
  begin
    if dd <= 10 then D := EncodeDate(yy, mm, 10) else D := DebutDeMois(PlusMois(D, 1)) + 9;
  end else
    if ArrondirAu = '15M' then
  begin
    if dd <= 15 then D := EncodeDate(yy, mm, 15) else D := DebutDeMois(PlusMois(D, 1)) + 14;
  end else
    if ArrondirAu = '20M' then
  begin
    if dd <= 20 then D := EncodeDate(yy, mm, 20) else D := DebutDeMois(PlusMois(D, 1)) + 19;
  end else
    if ArrondirAu = '25M' then
  begin
    if dd <= 25 then D := EncodeDate(yy, mm, 25) else D := DebutDeMois(PlusMois(D, 1)) + 24;
  end;
  // Arrondi � la d�cade (Modif SBO)
  if ArrondirAu = 'KED' then
  begin
    if dd <= 10
      then D := EncodeDate(yy, mm, 10)
    else if dd <= 20
      then D := EncodeDate(yy, mm, 20)
    else D := FinDeMois(D);
  end;
  // Arrondi � la quinzaine (Modif SBO)
  if ArrondirAu = 'KIN' then
  begin
    if dd <= 15 then D := EncodeDate(yy, mm, 15) else D := FinDeMois(D);
  end;
  //if ArrondirAu='PAS' then
  DecodeDate(D, yy, mm, dd);
  if JP1 > 0 then D1 := JP1 else D1 := 0;
  if JP2 > 0 then D2 := JP2 else D2 := 0;
  if D2 = 0 then D2 := D1;
  if D1 = 0 then D1 := D2;
  if D1 > D2 then
  begin
    D3 := D1;
    D1 := D2;
    D2 := D3;
  end;
  if ((D2 > 0) and (D1 > 0)) then
  begin
    if dd < D1 then
    begin
      JMax := StrToInt(FormatDateTime('d', FinDeMois(EncodeDate(yy, mm, 1))));
      if D1 > JMax then D1 := JMax;
      D := EncodeDate(yy, mm, D1);
    end else if dd < D2 then
    begin
      JMax := StrToInt(FormatDateTime('d', FinDeMois(EncodeDate(yy, mm, 1))));
      if D2 > JMax then D2 := JMax;
      D := EncodeDate(yy, mm, D2);
    end else
    begin
      D := DebutDeMois(PlusMois(D, 1));
      DecodeDate(D, yy, mm, dd);
      JMax := StrToInt(FormatDateTime('d', FinDeMois(EncodeDate(yy, mm, 1))));
      if D1 - 1 > JMax then D1 := JMax + 1;
      D := DebutDeMois(PlusMois(D, 1)) + D1 - 1;
    end;
  end;
  EcheArrondie := D;
end;

function NextEche(DD: TDateTime; Separe: String3): TDateTime;
var
  D: TDateTime;
begin
  D := DD;
  if Separe = 'SEM' then D := D + 7 else
    if Separe = 'QUI' then D := D + 15 else
    if Separe = '1M' then D := PlusMois(D, 1) else
    if Separe = '2M' then D := PlusMois(D, 2) else
    if Separe = '3M' then D := PlusMois(D, 3) else
    if Separe = '4M' then D := PlusMois(D, 4) else
    if Separe = '5M' then D := PlusMois(D, 5) else
    if Separe = '6M' then D := PlusMois(D, 6);
  NextEche := D;
end;

function ProchaineDate( DD : TDateTime ; SEP, ARR : String3 ) : TDateTime;
var
  D : TDateTime;
begin
  D               := NextEche(DD, SEP);
  D               := EcheArrondie(D, ARR, 0, 0);
  ProchaineDate   := D;
end;


function CTobInsertDB( vTob : Tob ; vBoByNivel : boolean ; vBoTransac : boolean ; vBoMultiNiv : boolean ) : boolean ;
var lBoBlobModifie : Boolean ;
    lStNomBlob     : string ;
    lStSQL         : string ;
    i              : integer ;
    lStMess        : string ;
begin

  if V_PGI.Debug then
    debug( '##### CTobInsertDB =====> Tob nomTable : ' + vTob.NomTable + ', niveau : ' + IntToStr(vTob.niveau) );

  result  := True ;
  lStMess := '' ;

  lBoBlobModifie := False;
  if ( vTob.NumTable >= 0) and ( V_PGI.DETables[ vTob.NumTable ].NumChampBlob > 0 ) then
    begin
    lStNomBlob := vTob.GetNomChamp( V_PGI.DETables[ vTob.NumTable ].NumChampBlob );
    if vTob.IsFieldModified( lStNomBlob ) then
      lBoBlobModifie := True ;
    end;

  // Le blob est modifi� on laisse la main � l'AGL
  if lBoBlobModifie then
    begin
    if vBoByNivel
      then begin
           if V_PGI.Debug then
             debug( '##### CTobInsertDB =====> InsertDBByNivel' );
           if vBoMultiNiv
             then result := vTob.InsertDBByNivel( False )
             else result := vTob.InsertDBByNivel( False, 0, 0 ) ;
           end
      else begin
           if V_PGI.Debug then
             debug( '##### CTobInsertDB =====> InsertDB' );
           result := vTob.InsertDB( nil ) ;
           end ;
    if not result then
      debug( '##### CTobInsertDB =====> RESULT AGL = False !!!' ) ;
    end
  // Sinon on fait nous meme l'insert
  else
    begin

    try

       if vBoTransac then
         BeginTrans ;

       if vTob.NumTable >= 0 then
        begin
        lStSql := vTob.MakeInsertSql;
        Result := ( ExecuteSql( lStSql ) = 1 );
        end;

        if vBoMultiNiv then
          for i := 0 to vTob.Detail.Count - 1 do
            Result := ( Result ) and ( CTobInsertDB( vTob.Detail[ i ], vBoByNivel, False ) ) ;

       if vBoTransac then
         CommitTrans ;

      except
        on E : Exception do
          begin
            Result := False;
            lStMess := '##### CTobInsertDB =====> Exception ' + E.Message + ' SQL : ' + lStSql;
            if vBoTransac
              then Rollback
              else Raise;
          end;

      end;

    if lStMess <> '' then
      begin
      if V_PGI.Debug then
        debug( lStMess );
      if ( V_PGI.SAV ) then
        PGIError( lStMess );
      end ;

    end ;

end ;

function CEstLigneSupprimable( vTOB : TOB ; vInfo : TInfoEcriture ) : integer ;
begin

 result := RC_PASERREUR ;

 if vInfo.LoadCompte(vTOB.GetString('E_GENERAL')) then
  begin
    if ( vInfo.TypeExo = teEnCours ) and ( vInfo.GetString('G_VISAREVISION') = 'X' ) then
     begin
      result :=  RC_COMPTEVISA ;
      _CTestCodeErreur(result,vInfo) ;
      if result <> RC_PASERREUR then exit ;
     end ;
  end ;

 if ( vTOB.GetString('E_ETATLETTRAGE') = 'PL' ) or ( vTOB.GetString('E_ETATLETTRAGE')='TL') then
  begin
   result := RC_ECRLETTREE ;
   _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 if vTOB.GetString('E_REFPOINTAGE') <> '' then
  begin
   result := RC_ECRPOINTEE ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 if vTOB.GetString('E_IMMO') <> '' then
  begin
   result := RC_ECRIMMO ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 {$IFNDEF NOVH}
  if VH^.OuiTvaEnc and ( vTOB.GetString('E_EDITEETATTVA') = '#' ) then
   begin
    result := RC_ECRTVAENC ;
    _CTestCodeErreur(result,vInfo) ;
    if result <> RC_PASERREUR then exit ;
   end ;
 {$ENDIF}

 if ( vTOB.GetString('E_REFGESCOM') <> '' ) and ( vTOB.GetString('E_TYPEMVT') = 'TTC') then
  begin
   result := RC_GCTTC ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 if ( vTOB.GetString('E_QUALIFORIGINE') = 'TRO' ) then
  begin
   result := RC_GCTTC ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 if ( vTOB.GetString('E_VALIDE') = 'X' ) then
  begin
   result := RC_BORCLOTURE ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

 if ( vTOB.GetString('E_ETATREVISION') = 'X' ) then
  begin
   result := RC_BORREVISION ;
    _CTestCodeErreur(result,vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ;

end ;


function _CreationPieceDET( vTOB : TOB ) : integer ;
var
 lTOBRef        : TOB ;
 lTOBPiece      : TOB ;
 lTOBLigne1     : TOB ;
 lTOBLigne2     : TOB ;
 lStCpteAttente : string ;
begin

 result := RC_PASERREUR ;

 lTOBRef := vTOB.Detail[0] ;
 if lTOBRef = nil then exit ;

 if lTOBRef.GetString('E_MODESAISIE') <> '-' then exit ;

 result := RC_ERREURSUPP ;

 lTOBPiece       := TOB.Create('',nil,-1) ;
 lTOBLigne1      := TOB.Create('ECRITURE',lTOBPiece,-1) ;
 lTOBLigne2      := TOB.Create('ECRITURE',lTOBPiece,-1) ;
 lStCpteAttente  := GetParamSocSecur ('SO_GENATTEND','') ;

 try

 CPutDefautEcr(lTOBLigne1) ;
 CPutDefautEcr(lTOBLigne2) ;

 CDupliquerTOBEcr(lTOBRef,lTOBLigne1) ;
 lTOBLigne1.PutValue('E_NUMEROPIECE'   , lTOBRef.GetValue('E_NUMEROPIECE') );
 lTOBLigne1.PutValue('E_ETABLISSEMENT' , lTOBRef.GetValue('E_ETABLISSEMENT') );
 lTOBLigne1.PutValue('E_NUMLIGNE'      , 1 ) ;
 lTOBLigne1.PutValue('E_GENERAL'       , lStCpteAttente ) ;
 lTOBLigne1.PutValue('E_DEBIT'         , -1 ) ;
 lTOBLigne1.PutValue('E_DEBITDEV'      , -1 ) ;
 lTOBLigne1.PutValue('E_CREDIT'        , 0 ) ;
 lTOBLigne1.PutValue('E_CREDITDEV'     , 0 ) ;
 lTOBLigne1.PutValue('E_CREERPAR'      , 'DET' ) ;
 lTOBLigne1.PutValue('E_IO'            , 'X') ;
 lTOBLigne1.PutValue('E_QUALIFORIGINE' , 'SUP') ;

 CDupliquerTOBEcr(lTOBRef,lTOBLigne2) ;
 lTOBLigne2.PutValue('E_NUMEROPIECE'   , lTOBRef.GetValue('E_NUMEROPIECE') );
 lTOBLigne2.PutValue('E_ETABLISSEMENT' , lTOBRef.GetValue('E_ETABLISSEMENT') );
 lTOBLigne2.PutValue('E_NUMLIGNE'      , 2 ) ;
 lTOBLigne2.PutValue('E_GENERAL'       , lStCpteAttente ) ;
 lTOBLigne2.PutValue('E_DEBIT'         , 0 ) ;
 lTOBLigne2.PutValue('E_DEBITDEV'      , 0 ) ;
 lTOBLigne2.PutValue('E_CREDIT'        , -1 ) ;
 lTOBLigne2.PutValue('E_CREDITDEV'     , -1 ) ;
 lTOBLigne2.PutValue('E_CREERPAR'      , 'DET' ) ;
 lTOBLigne2.PutValue('E_IO'            , 'X') ;
 lTOBLigne1.PutValue('E_QUALIFORIGINE' , 'SUP') ;

 lTOBPiece.InsertDB(nil) ;

 result := RC_PASERREUR ;

 finally
  lTOBPiece.Free ;
 end ;

end ;


function CSupprimerPiece( vTOB : TOB ; vInfo : TInfoEcriture = nil ) : integer ;
var
 i               : integer ;
 lBoResult       : boolean ;
 lBoDetruireInfo : boolean ;
 lStCodeExo      : string ;
begin

 result          := RC_PASERREUR ;
 lBoDetruireInfo := false ;

 if ( vTOB = nil ) or ( vTOB.Detail = nil ) or ( vTOB.Detail.Count = 0 ) then exit ;

 if vInfo = nil then
  begin
   lBoDetruireInfo := true ;
   vInfo           :=  TInfoEcriture.Create();
  end ;

 lStCodeExo := vTOB.Detail[0].GetString('E_EXERCICE') ;

 if lStCodeExo = GetEncours.Code then
  vInfo.TypeExo := teEncours
   else
    if lStCodeExo = GetSuivant.Code then
     vInfo.TypeExo := teSuivant
      else
       vInfo.TypeExo := tePrecedent;

 try

 for i := 0 to vTOB.Detail.Count - 1 do
  begin
   result := CEstLigneSupprimable(vTOB.Detail[i],vInfo) ;
   if result <> RC_PASERREUR then exit ;
  end ; // for

 lBoResult := CDetruitAncienPiece(vTOB) ;

 if not lBoResult then
  begin
   result := RC_PIECEMODIF ;
   exit ;
  end ;

 if lBoResult then
  begin
   lBoResult := CDetruitAncienAnaPiece(vTOB) ;
   if lBoResult then
    MajSoldesEcritureTOB(vTOB,false,vInfo) ;
   if not lBoResult then
    result := RC_MAJSOLDE ;
  end ;

  result := _CreationPieceDET(vTOB) ;

 finally
  if lBoDetruireInfo then
   vInfo.Free ;
 end ;

end ;


end.



