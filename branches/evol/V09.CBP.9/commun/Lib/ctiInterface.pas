unit ctiInterface;

interface

uses
    sysutils, ctiConst, windows, {$IFNDEF NOCBP} uTOB, {$ENDIF} classes, stdctrls, contnrs, shellapi;

type
    TCtiInterface       = class;

    TCtiStart             = function  (sProfil:pchar; sLine:pchar):LongInt;
    TCtiStop              = procedure;
    TCtiMonitor           = function  (dwLine:DWORD):LongInt;
    TCtiUnmonitor         = procedure (dwLine:DWORD);

    TCtiGetCapacities     = function  :LongInt;
    TCtiGetAllLines       = function  :pchar;
    TCtiGetMonitoredLines = function  :pchar;

    // $$$ JP 09/01/06 - Gestion du log CTI
    TCtiLogStart        = function  (pOnLogEvent:TCtiLogEvent):LongInt;
    TCtiLogStop         = function  (sLogFile:pchar):LongInt;
    TCtiLogAdd          = procedure (sLogLine:pchar);
    TCtiLogClear        = function  :LongInt;
    TCtiLogWrite        = function  (sLogFile:pchar):LongInt; //; iShowMode:integer):LongInt;
    // $$$

    TCtiCallMake        = function  (sTelephone:pchar):LongInt;
    TCtiCallConnect     = function  (lCall:LongInt):LongInt;
    TCtiCallDisconnect  = function  (lCall:LongInt):LongInt;
    TCtiCallRedirect    = function  (lCall:LongInt; sTelephone:pchar):LongInt;
    TCtiCallTransfer    = function  (lHeldCall:LongInt; lConnectedCall:LongInt):LongInt;
    TCtiCallConference  = function  (lHeldCall:LongInt; lConnectedCall:LongInt):LongInt;

    TCtiSetEventHandler = procedure (pCtiCallBack:TCtiEvent);

    // Classe repr�sentant une communication. Peut �tre d�river pour enrichir les informations de la communication
    TCtiCall = class (TObject)
    protected
             m_ctiInterface    :TCtiInterface;  // Interface CTI parente
             m_lID             :LongInt;        // Identifiant de l'appel, sp�cifi� par le connecteur
             m_lState          :LongInt;        // Etat de l'appel
             m_lStateDetails   :LongInt;        // Compl�ment d'information sur l'�tat d'un appel (pour disconnected surtout)
             m_lOrigin         :LongInt;        // Origine de l'appel (entrant, sortant, interne ou externe, ...)
             m_Contacts        :TObjectList;    // Liste d'objet, chacun de ces objets �tant une identit� de l'appellant
             m_Contact         :TObject;        // L'objet repr�sentant l'identit� s�lectionn�e (s'il y en a une)
             m_strContactName  :string;         // Nom affichable du contact en cours (� alimenter par l'appli)
             m_CallerTel       :string;         // Num�ro de t�l�phone de l'appellant
             m_CalledTel       :string;         // Num�ro de t�l�phone de l'appell�
             m_ConnectedTel    :string;         // Num�ro du t�l�phone r�ellement connect� (si transfert, redirection...)
             m_CallTel         :string;         // Num�ro de t�l�phone du correspondant (l'appelant, l'appel� ou le connect�)
             m_bCallTelChanged :boolean;        // Le num�ro de t�l�phone du correspondant a chang� (peut arriver si ligne non SDA par exemple)

             //m_NumAction       :integer;        // num�ro de l'action g�n�r�e
             //m_Auxiliaire      :String;         // tiers utile pour appel sortant
             m_strOutgoingRef  :string;         // R�f�rence associ�e � un appel sortant depuis l'application: elle pourra s�lectionner le bon contact

             m_TimeStart       :TDateTime;      // Horodatage: d�but d'appel (cr�ation)
             m_TimeStartConn   :TDateTime;      // Horodatage: d�but d'appel connect� // $$$ JP 13/08/07
             m_TimeEnd         :TDateTime;      // Horodatage: fin d'appel (connect� ou pas)

             procedure         SetContact (Contact:TObject);
             procedure         SetContactIndex (iIndex:integer);

             procedure         SetOrigin (lOrigin:LongInt);

             procedure         UpdateCallTel;
             procedure         SetCallerTel      (strTel:string);
             procedure         SetCalledTel      (strTel:string);
             procedure         SetConnectedTel   (strTel:string);
             function          GetCallTel        (iIndex:integer):string;
             function          GetCallTelChanged:boolean;
             function          GetFaceName       (iIndex:integer):string;
             function          GetDuringTime     (iIndex:integer):TDateTime;
             function          GetHorodate:string;

    public
          constructor Create (ctiInterface:TCtiInterface);
          destructor  Destroy;                  override;

          procedure   UnloadContacts;

          property    ID             :LongInt     read m_lID             write m_lID;
          property    State          :LongInt     read m_lState          write m_lState;
          property    StateDetails   :LongInt     read m_lStateDetails   write m_lStateDetails;
          property    Origin         :LongInt     read m_lOrigin         write SetOrigin;

          property    CallerTel      :string      read m_CallerTel       write SetCallerTel; //m_CallerTel;
          property    CalledTel      :string      read m_CalledTel       write SetCalledTel; //m_CalledTel;
          property    ConnectedTel   :string      read m_ConnectedTel    write SetConnectedTel; //m_ConnectedTel;
          property    CallTel        :string      index 0                read  GetCallTel;
          property    CallTelName    :string      index 1                read  GetCallTel;
          property    CallTelChanged :boolean     read GetCallTelChanged;

          property    FaceName       :string      index 1                  read GetFaceName;
          property    ShortFaceName  :string      index 2                  read GetFaceName;

          property    Contacts       :TObjectList read  m_Contacts;
          property    Contact        :TObject     read  m_Contact          write SetContact;
          property    ContactIndex   :integer                              write SetContactIndex;
          property    ContactName    :string      read  m_strContactName;

          // Horodatage
          property    TimeStart      :TDateTime             read m_TimeStart; //         write m_TimeStart;
          property    TimeStartConn  :TDateTime             read m_TimeStartConn; //     write m_TimeStartConn; // $$$ JP 13/08/07
          property    TimeEnd        :TDateTime             read m_TimeEnd; //           write m_TimeEnd;
          property    AliveTime      :TDateTime   index 0   read GetDuringTime;
          property    ConnectedTime  :TDateTime   index 1   read GetDuringTime;
          property    Horodate       :string                read GetHorodate;

          // R�f�rence associ�e � un appel sortant depuis l'application: elle pourra s�lectionner le bon contact (via m_AppLoadContacts)
          property    OutgoingRef    :string                read m_strOutgoingRef; //      write m_strOutgoingRef;
          //property    NumAction      :Integer     read m_NumAction         write m_NumAction;
          //property    Auxiliaire     :string      read m_Auxiliaire        write m_Auxiliaire;
    end;

    // Gestionnaire d'�v�nement applicatifs
    TCtiAppEvent          = function (ctiCall:TCtiCall; lEvent:LongInt):LongInt of object;

    // Gestion des identit�s du correspondant (il peut y avoir plusieurs identit�s connues pour un n� de tel)
    TCtiAppLoadContacts   = function  (ctiCall:TCtiCall):integer of object;
    TCtiAppUnloadContacts = function  (ctiCall:TCtiCall):boolean of object;
    TCtiAppGetContactName = function  (ctiCall:TCtiCall):string  of object;

    // Classe d'interface avec le connecteur CTI (dll)
    TCtiInterface = class (TObject)
    protected
          m_hModule           :LongWord;     // handle de la dll
          m_bStarted          :boolean;      // connecteur d�marr� ou non
          m_strInterface      :string;       // code de l'interface CTI utilis� (tablette RTINTERFACECTI)
          m_strConnector      :string;       // nom de la dll associ� � cette interface
          m_strProfil         :string;       // profil de d�marrage du connecteur
          m_strLine           :string;       // ligne � monitor�e
          m_strPrefixe        :string;       // N� pr�fixe pour atteindre l'ext�rieur
          m_lCapacities       :LongInt;      // Possibilit� de CTI: lancement d'appel, r�pondre, transf�rer...
          m_bHorodatage       :boolean;      // On g�re l'horodatage ou pas
          m_strOutgoingRef    :string;       // Stockage temporaire de la r�f�rence lors d'un appel sortant depuis l'application

          // Liste des communications en cours
          m_Calls             :TObjectList;

          // $$$ JP 28/06/07: le log est-il actif?
          m_bHasLog           :boolean;

          // Fonctions de bases de la dll
          m_ctiStart          :TCtiStart;                // D�marrage du connecteur CTI PGI
          m_ctiStop           :TCtiStop;                 // Arr�t du connecteur CTI PGI
          m_ctiMonitor        :TCtiMonitor;              // Monitorer une ligne connue
          m_ctiUnmonitor      :TCtiUnmonitor;            // Arr�t du monitoring

          m_ctiCapacities     :TCtiGetCapacities;        // Possibilit�s cti du connecteur CTI PGI
          m_ctiAllLines       :TCtiGetAllLines;          // Nom de toutes les lignes (avec nom provider et identifiant de ligne)
          m_ctiMonitoredLines :TCtiGetMonitoredLines;    // Nom des lignes monitor�es (pour l'instant une seule)

          // $$$ JP 09/01/06 - gestion du log
          m_ctiLogStart       :TCtiLogStart;
          m_ctiLogStop        :TCtiLogStop;
          m_ctiLogAdd         :TCtiLogAdd;   // $$$ JP 09/08/07: peut �tre utile
          m_ctiLogClear       :TCtiLogClear;
          m_ctiLogWrite       :TCtiLogWrite;
          // $$$

          // Fonctions de traitements t�l�phoniques
          m_ctiCallMake       :TCtiCallMake;             // fonction dll de lancement d'appel
          m_ctiCallConnect    :TCtiCallConnect;          // fonction dll d'acceptation d'un appel
          m_ctiCallDisconnect :TCtiCallDisconnect;       // fonction dll de rejet/terminaison d'un appel
          m_ctiCallRedirect   :TCtiCallRedirect;         // fonction dll de redirection d'un appel (non connect�)
          m_ctiCallTransfer   :TCtiCallTransfer;         // fonction dll de transfert d'un appel en attente sur un appel connect�
          m_ctiCallConference :TCtiCallConference;       // fonction dll de conf�rence � 3 avec un appel en attente et un connect�

          // Fonctions callback pour l'application sur �v�nements CTI
          m_OnAppCallEvent    :TCtiAppEvent;

          // Fonctions de d�terminations des identit�s du correspondant
          m_AppLoadContacts   :TCtiAppLoadContacts;
          m_AppUnloadContacts :TCtiAppUnloadContacts;
          m_AppGetContactName :TCtiAppGetContactName;

          // Nom des lignes monitor�es (pour l'instant une seule)
          function    GetMonitoredLines:string;
          function    GetAllLines:string;

          function    GetCapacity (iIndex:integer):boolean;

          procedure   SetPrefixe  (strPrefixe:string);

          // Gestion de la liste des communications
          function    GetCtiCall     (lID:LongInt):TCtiCall;
          procedure   SetCtiCall     (lID:LongInt; Call:TCtiCall);

          // Fonctions callback de l'interface CTI, d�clar�es aupr�s du connecteur cti, appel retransmis � l'application
          function    OnCallEvent  (lCall:LongInt; lEvent:LongInt; lInfo:LongInt; sInfo:pchar):LongInt; //strInfo:string):LongInt;

          function    GetCallCount (iIndex:integer):integer;

          function    GetLogTempFile:string;

    public
          constructor Create (strInterface:string; pOnLogEvent:TCtiLogEvent=nil);
          destructor  Destroy; override;

          function    Start (bForceRestart:boolean=FALSE):boolean;
          procedure   Stop;

          function    Monitor   (dwLine:DWORD):boolean;
          procedure   Unmonitor (dwLine:DWORD);

          // $$$ JP 09/01/06 - gestion du log
          function    LogStart (pOnLogEvent:TCtiLogEvent=nil):boolean;
          function    LogStop  (strLogFile:string; bShowLog:boolean=FALSE):boolean; // $$$ JP 04/07/07: si '*', fichier temporaire automatique
          procedure   LogAdd   (strLogLine:string);                                 // $$$ JP 09/08/07
          function    LogClear:boolean;
          function    LogWrite (strLogFile:string; bShowLog:boolean=FALSE):boolean;
          // $$$

          function    CallMake       (strTelephone:string; strOutgoingRef:string=''):LongInt;   // Emission d'un appel t�l�phonique
          function    CallConnect    (ctiCall:TCtiCall):LongInt;                                // Acceptation d'un appel t�l�phonique entrant
          function    CallDisconnect (ctiCall:TCtiCall):LongInt;                                // Fin d'appel (connect� ou non)
          function    CallRedirect   (ctiCall:TCtiCall; strTelephone:string):LongInt;           // Redirection d'un appel (non connect�)
          function    CallTransfer   (ConnectedCall:TCtiCall; HeldCall:TCtiCall):LongInt;       // Transfert d'un appel sur un autre
          function    CallConference (ConnectedCall:TCtiCall; HeldCall:TCtiCall):LongInt;       // Conf�rence � 3

          function    GetContactName (ctiCall:TCtiCall):string;                                 // R�cup�re le nom du contact en cours de l'appel
          function    LoadContacts   (ctiCall:TCtiCall):integer;                                // Charge en m�moie les contacts li�s au n� de t�l�phone
          function    UnloadContacts (ctiCall:TCtiCall):boolean;

          // Gestionnaire d'�v�nements CTI applicatif,
          property    OnAppCallEvent     :TCtiAppEvent           read m_OnAppCallEvent    write m_OnAppCallEvent;
          property    AppLoadContacts    :TCtiAppLoadContacts    read m_AppLoadContacts   write m_AppLoadContacts;
          property    AppUnloadContacts  :TCtiAppUnloadContacts  read m_AppUnloadContacts write m_AppUnloadContacts;
          property    AppGetContactName  :TCtiAppGetContactName  read m_AppGetContactName write m_AppGetContactName;

          // Nom des lignes monitor�es (une seule pour l'instant)
          property    MonitoredLines:string                                read GetMonitoredLines;
          property    AllLines:string                                      read GetAllLines;
          property    bCanMakeCall:boolean    index ctiCaps_CallMake       read GetCapacity;
          property    bCanAnswer:boolean      index ctiCaps_CallAnswer     read GetCapacity;
          property    bCanDisconnect:boolean  index ctiCaps_CallDisconnect read GetCapacity;
          property    bCanRedirect:boolean    index ctiCaps_CallRedirect   read GetCapacity;
          property    bCanTransfer:boolean    index ctiCaps_CallTransfer   read GetCapacity;
          property    bCanConference:boolean  index ctiCaps_CallConference read GetCapacity;
          property    bCanSwapHold:boolean    index ctiCaps_CallSwap       read GetCapacity;

          // Interface d�marr�e
          property    Started:boolean                                      read m_bStarted;

          // $$$ JP 28/06/07: log actif?
          property    HasLog:boolean                                       read m_bHasLog;

          // Liste de communication
          property    Call [lID:LongInt] :TCtiCall      read GetCtiCall        write SetCtiCall;
          property    Calls              :TObjectList   read m_Calls;
          property    Lines              :string        read GetAllLines;
          property    Prefixe            :string        read m_strPrefixe      write SetPrefixe;

          // Compteurs divers
          property    CallCount         :integer  index 0                      read GetCallCount;
          property    OfferingCount     :integer  index ctiState_Offering      read GetCallCount;
          property    ConnectedCount    :integer  index ctiState_Connected     read GetCallCount;
          property    HoldCount         :integer  index ctiState_OnHold        read GetCallCount;
          property    RingingCount      :integer  index ctiState_Ringback      read GetCallCount;
          property    DialToneCount     :integer  index ctiState_DialTone      read GetCallCount;
          property    DialingCount      :integer  index ctiState_Dialing       read GetCallCount;
          property    IdleCount         :integer  index ctiState_Idle          read GetCallCount;
          property    NonIdleCount      :integer  index -ctiState_Idle         read GetCallCount;

          // Comportement divers de l'interface
          property    Horodatage        :boolean        read m_bHorodatage     write m_bHorodatage;
    end;

    ECtiError = class (Exception);

// Cr�ateur de l'interface CTI, en fonction du code interface (tablette RTINTERFACECTI)
function CreateCtiInterface (strInterfaceName:string; strPrefixe:string; pOnLogEvent:TCtiLogEvent=nil):TCtiInterface;

{$IFDEF NOCBP}
var
   TheCtiInterface  :TCtiInterface;
{$ENDIF NOCBP}



implementation

{$IFNDEF NOCBP}
uses
    hctrls, hent1, utilPgi, hmsgbox,
//{$IFDEF EAGLCLIENT}
//    hstatus,
//{$ENDIF}
{$IFDEF BUREAU}
    entDP;
{$ELSE}
    entRT;
{$ENDIF BUREAU}
{$ENDIF NOCBP}

{$IFDEF NOCBP}
function CleTelephone (strTelephone:string; bFixedLen:boolean=TRUE):string;
var
   car   :string;
   i     :integer;
begin
     Result := '';
     strTelephone := Trim (strTelephone);
     for i := 1 to length (strTelephone) do
     begin
          car := copy (strTelephone, i, 1);
          if (car >= '0') and (car <= '9') and (car <>'.') and (car<>',') and (car<>'-') and (car<>' ') then
             Result := Result + car;
     end;

     // Si cl� v�ritable (donc toujours 9 car.), on construit une chaine de 9 caract�res. Sinon, on laisse telle quelle
     if bFixedLen = TRUE then
     begin
          i := Length (Result);
          if i > 9 then
              Result := Copy (Result, i-8, 9)
          else
              if i < 9 then
                 Result := StringOfChar ('0', 9-i) + Result;
     end;
end;
{$ENDIF NOCBP}

function CreateCtiInterface (strInterfaceName:string; strPrefixe:string; pOnLogEvent:TCtiLogEvent):TCtiInterface;
begin
     Result := TCtiInterface.Create (strInterfaceName, pOnLogEvent);
     if Result <> nil then
        Result.Prefixe := strPrefixe;
end;

// -------------------------------
//    Fonctions callback de la dll
// -------------------------------
function DllOnCallEvent (lCall:LongInt; lEvent:LongInt; lInfo:LongInt; sInfo:pchar):LongInt;
begin
     Result := ctiStatus_Error;

{$IFNDEF NOCBP}
{$IFNDEF EAGLSERVER}
{$IFNDEF ERADIO}
{$IFDEF BUREAU}
        if VH_DP.ctiAlerte <> nil then
           Result := VH_DP.ctiAlerte.ctiInterface.OnCallEvent (lCall, lEvent, lInfo, sInfo);
{$ELSE}
        if VH_RT.ctiAlerte <> nil then
           Result := VH_RT.ctiAlerte.ctiInterface.OnCallEvent (lCall, lEvent, lInfo, sInfo);
{$ENDIF BUREAU}
{$ENDIF ERADIO}
{$ENDIF EAGLSERVER}
{$ELSE}
     TheCtiInterface.OnCallEvent (lCall, lEvent, lInfo, sInfo);
{$ENDIF NOCBP}
end;




              // --------------------------
              //       TCtiInterface
              // --------------------------
constructor TCtiInterface.Create (strInterface:string; pOnLogEvent:TCtiLogEvent);
var
{$IFNDEF NOCBP}
   TOBCti              :TOB;
{$ENDIF}
   ctiSetEventHandler  :TCtiSetEventHandler;
begin
     // Code de l'interface CTI dans la table PGI
     m_strInterface := strInterface;
     m_bHorodatage  := TRUE;

{$IFNDEF NOCBP}
     // $$$ JP 23/05/07: initialisation
     m_strConnector := '';
     m_strProfil    := '';
     m_strLine      := '';

     // Nom du connecteur (dll) associ�, et lecture du profil de d�marrage (param�tre de type chaine de car.)
     TOBCti := TOB.Create ('interface CTI', nil, -1);
     if TOBCti <> nil then
     begin
          // On d�termine le profil d'utilisation du CTI en fonction de l'interface: en g�n�ral le code provider
          try
             TOBCti.LoadDetailFromSQL ('SELECT CO_ABREGE,CO_LIBRE FROM COMMUN WHERE CO_TYPE="RCT" AND CO_CODE="' + m_strInterface + '"');
             if TOBCti.Detail.Count = 0 then
                  raise ECtiError.Create ('Initialisation du CTI Cegid impossible'#10' "' + m_strInterface + '" n''est pas r�f�renc� comme interface CTI')
             else
             begin
                  m_strConnector := TOBCti.Detail [0].GetString ('CO_ABREGE');
                  m_strProfil    := TOBCti.Detail [0].GetString ('CO_LIBRE');
             end;

             // $$$ JP 23/05/07: d�sormais, US_TEL1 (s'il existe) repr�sente la ligne � monitorer (si inexistante, le connecteur utilise la premi�re trouv�e)
             TOBCti.ClearDetail;
             TOBCti.LoadDetailFromSQL ('SELECT US_TEL1 FROM UTILISAT WHERE US_UTILISATEUR="' + V_PGI.User + '"');
             if TOBCti.Detail.Count > 0 then
                m_strLine := Trim (TOBCti.Detail [0].GetString ('US_TEL1'));
          finally
                 TOBCti.Free;
          end;

          // On d�termine la ligne t�l�phonique � �couter
          // $$$todo v7 - dans la fiche utilisateur, pas dans la registry
          // $$$ JP 23/05/07: ok fait, cf un peu plus haut
//          m_strLine := '';
//          RegCti := TRegistry.Create;
//          try
//             if V_PGI.WinNT = TRUE then
//                 RegCti.RootKey := HKEY_CURRENT_USER
//             else
//                 RegCti.RootKey := HKEY_LOCAL_MACHINE;
//{$IFDEF BUREAU}
//             if RegCti.OpenKey ('\Software\Cegid\Bureau PGI S5\', FALSE) = TRUE then
//{$ELSE}
//             if RegCti.OpenKey ('\Software\Cegid\CGS5\', FALSE) = TRUE then
//{$ENDIF BUREAU}
//             begin
//                  m_strLine := RegCti.ReadString ('CTI');
//                  RegCti.CloseKey;
//             end;
//          finally
//                 FreeAndNil (RegCti);
//          end;
{$ELSE}
          m_strConnector := m_strInterface;
          m_strProfil    := '*';
          m_strLine      := '*';
{$ENDIF NOCBP}

          // Chargement de la dll (le connecteur) dans le process
          m_hModule := LoadLibrary (pchar (m_strConnector));
          if m_hModule = 0 then
             raise ECtiError.Create ('Initialisation du CTI Cegid impossible'#10' Le connecteur CTI "' + m_strConnector + '" est absent ou d�fectueux');

          // Identification des points d'entr�e principaux: d�marrage et fonctions t�l�phoniques
          @m_ctiStart          := GetProcAddress (m_hModule, pchar ('ctiStart'));
          @m_ctiStop           := GetProcAddress (m_hModule, pchar ('ctiStop'));
          @m_ctiMonitor        := GetProcAddress (m_hModule, pchar ('ctiMonitor'));
          @m_ctiUnmonitor      := GetProcAddress (m_hModule, pchar ('ctiUnmonitor'));

          @m_ctiCapacities     := GetProcAddress (m_hModule, pchar ('ctiGetCapacities'));
          @m_ctiAllLines       := GetProcAddress (m_hModule, pchar ('ctiGetAllLines'));
          @m_ctiMonitoredLines := GetProcAddress (m_hModule, pchar ('ctiGetMonitoredLines'));

          // $$$ JP 09/01/06 - Gestion du log CTI
          //@m_ctiLogStart       := GetProcAddress (m_hModule, pchar ('ctiLogStart'));
          @m_ctiLogStart       := GetProcAddress (m_hModule, pchar ('ctiLogStart'));
          @m_ctiLogStop        := GetProcAddress (m_hModule, pchar ('ctiLogStop'));
          @m_ctiLogAdd         := GetProcAddress (m_hModule, pchar ('ctiLogAdd'));
          @m_ctiLogClear       := GetProcAddress (m_hModule, pchar ('ctiLogClear'));
          @m_ctiLogWrite       := GetProcAddress (m_hModule, pchar ('ctiLogWrite'));
          // $$$

          @m_ctiCallMake       := GetProcAddress (m_hModule, pchar ('ctiCallMake'));
          @m_ctiCallConnect    := GetProcAddress (m_hModule, pchar ('ctiCallConnect'));
          @m_ctiCallDisconnect := GetProcAddress (m_hModule, pchar ('ctiCallDisconnect'));
          @m_ctiCallRedirect   := GetProcAddress (m_hModule, pchar ('ctiCallRedirect'));
          @m_ctiCallTransfer   := GetProcAddress (m_hModule, pchar ('ctiCallTransfer'));
          @m_ctiCallConference := GetProcAddress (m_hModule, pchar ('ctiCallConference'));

          // Il faut au moins ctiStart/ctiStop/ctiCallMake
          if (@m_ctiStart = nil) or (@m_ctiStop = nil) or (@m_ctiCallMake = nil) then
             raise ECtiError.Create ('Initialisation du CTI Cegid impossible'#10' Le connecteur CTI n''est pas conforme');

          // $$$ JP 09/01/06 - Log visible qu'en mode SAV
{$IFNDEF NOCBP}
          // D�marrage du log en mode SAV, dont la mise � jour doit �tre notifi� ou pas � l'application
          if V_PGI.Sav = TRUE then
{$ENDIF}
             LogStart (pOnLogEvent);

          // Sp�cification au conecteur du gestionnaire d'�v�nement CTI de l'application
          @ctiSetEventHandler := GetProcAddress (m_hModule, pchar ('ctiSetEventHandler'));
          if (@ctiSetEventHandler <> nil) then
             ctiSetEventHandler (DllOnCallEvent);

          // Cr�ation de la liste des communications (vide pour l'instant)
          m_Calls := TObjecTList.Create (TRUE);
{$IFNDEF NOCBP}
     end
     else
         raise ECtiError.Create ('Initialisation de l''interface CTI Cegid impossible (TOB.Create a �chou�)');
{$ENDIF}
end;

destructor TCtiInterface.Destroy;
begin
     // Arr�t de l'interface
     Stop;

     // Plus besoin de la liste des communications
     FreeAndNil (m_Calls);

     // Plus besoin de la dll
     if m_hModule <> 0 then
        FreeLibrary (m_hModule);

     inherited;
end;

function TCtiInterface.Start (bForceRestart:boolean):boolean;
begin
     // Si d�j� d�marr�, on ne fait rien (sauf si force le red�marrage)
     try
        // Si d�marrage forc�, on arr�te s'il �tait d�j� d�marr�
        if bForceRestart = TRUE then
           Stop;

        // D�marrage du connecteur
        if (m_bStarted = FALSE) then
        begin
             m_bStarted := m_ctiStart (pchar (m_strProfil), pchar (m_strLine)) = ctiStatus_OK;

             // Si connecteur d�marr�, on lui demande ses possibilit�s
             if (m_bStarted = TRUE) and (@m_ctiCapacities <> nil) then
                m_lCapacities := m_ctiCapacities;
        end;
     finally
            // On indique si interface d�marr�e
            Result := m_bStarted;
     end;
end;

procedure TCtiInterface.Stop;
begin
     if m_bStarted = TRUE then
     begin
          // Arr�t du connecteur
          m_ctiStop;

          // Plus de r�f�rence sur les appels CTI (suppression automatique, car liste propri�taire)
          m_Calls.Clear;

          // Cti arr�t�
          m_bStarted    := FALSE;
          m_lCapacities := 0;
     end;
end;

function TCtiInterface.Monitor (dwLine:DWORD):boolean;
begin
     Result := FALSE;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     if @m_ctiMonitor <> nil then
        Result := m_ctiMonitor (dwLine) = ctiStatus_OK;
end;

procedure TCtiInterface.Unmonitor (dwLine:DWORD);
begin
     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     if @m_ctiUnmonitor <> nil then
        m_ctiUnmonitor (dwLine);
end;

function TCtiInterface.GetAllLines:string;
begin
     Result := '';

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     if @m_ctiAllLines <> nil then
        Result := string (m_ctiAllLines);
end;

function TCtiInterface.GetMonitoredLines:string;
begin
     Result := '';

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     if @m_ctiMonitoredLines <> nil then
        Result := string (m_ctiMonitoredLines);
end;

function TCtiInterface.GetCapacity (iIndex:integer):boolean;
begin
     if m_lCapacities <> ctiStatus_Error then
         Result := (m_lCapacities and iIndex) = iIndex
     else
         Result := FALSE;
end;

procedure TCtiInterface.SetPrefixe (strPrefixe:string);
begin
     m_strPrefixe := strPrefixe;

     LogAdd ('External prefix set to ' + strPrefixe);
end;

function TCtiInterface.GetLogTempFile:string;
var
   sLogFile     :array [0..MAX_PATH] of char;
begin
     // $$$ JP 28/06/07: renommer en .log pour qu'il puisse se lancer automatiquement (.tmp sans association � priori)
     Result := '';

     GetTempPath (SizeOf (sLogFile) - 1, sLogFile);
     if GetTempFileName (sLogfile, 'CTI', 0, sLogFile) <> 0 then
     begin
          // On enregistre le log dans le fichier, et on le visualise
          Result := ChangeFileExt (sLogFile, '.log');
          if RenameFile (sLogFile, Result) = FALSE then
             Result := '';
     end;
end;

function TCtiInterface.LogStart (pOnLogEvent:TCtiLogEvent):boolean;
begin
     m_bHasLog := FALSE;
     if @m_ctiLogStart <> nil then
        m_bHasLog := m_ctiLogStart (pOnLogEvent) = ctiStatus_OK;

     Result := m_bHasLog;
end;

function TCtiInterface.LogStop (strLogFile:string; bShowLog:boolean):boolean;
begin
     Result := FALSE;
     if @m_ctiLogStop <> nil then
     begin
          // Nom de fichier temporaire si '*' (si vide, on ne veut pas �crire dans le fichier)
          if strLogFile = '*' then
             strLogFile := GetLogTempFile;

          // Arr�t du log avec enregistrement �ventuel dans fichier de log
          Result := m_ctiLogStop (pchar (strLogFile)) = ctiStatus_OK;
          if bShowLog = TRUE then
             ShellExecute (0, 'open', pchar (strLogFile), nil, nil, SW_SHOWNORMAL);

          // Plus de log actif
          m_bHasLog := FALSE;
     end;
end;

procedure TCtiInterface.LogAdd (strLogLine:string);
begin
     if @m_ctiLogAdd <> nil then
        m_ctiLogAdd (pchar (strLogLine));
end;
                                                          
function TCtiInterface.LogClear:boolean;
begin
     Result := FALSE;
     if @m_ctiLogClear <> nil then
        Result := m_ctiLogClear = ctiStatus_OK;
end;

function TCtiInterface.LogWrite (strLogFile:string; bShowLog:boolean):boolean;
begin
     Result := FALSE;
     if @m_ctiLogWrite <> nil then
     begin
          // Nom de fichier temporaire si aucun nom de fichier sp�cifi�
          if strLogFile = '' then
             strLogFile := GetLogTempFile;

          if strLogFile <> '' then
          begin
               Result := m_ctiLogWrite (pchar (strLogFile)) = ctiStatus_OK;
               if bShowLog = TRUE then
                  ShellExecute (0, 'open', pchar (strLogFile), nil, nil, SW_SHOWNORMAL);
          end
          else
              Result := FALSE;
     end;
end;

function TCtiInterface.OnCallEvent (lCall:LongInt; lEvent:LongInt; lInfo:LongInt; sInfo:pchar):LongInt; //trInfo:string):LongInt;
var
   ctiCall        :TCtiCall;
   bNeedIdentify  :boolean;
begin
     Result := ctiStatus_OK;

     // Recherche de l'appel cti dans la liste d�j� �tablie
     ctiCall := Call [lCall];

     // Traitement de l'�v�nement CTI en fonction de sa nature
     bNeedIdentify := FALSE;
     case lEvent of
          // Cr�ation d'un appel dans le connecteur
          ctiEvent_CallNew:
          begin
               if ctiCall = nil then
               begin
                    ctiCall := TCtiCall.Create (Self);
                    if ctiCall <> nil then
                    begin
                         Call [lCall] := ctiCall;

                         // $$$ JP 13/08/07: prise en compte de la r�f�rence d'appel sortant
                         // !!!: si 2 appels sortants en m�me temps, m�lange possible (bien que peu probable)
                         // $$$ todo: il faudrait donc fournir cette r�f�rence au connecteur, qu'il renverrait sur ctiEvent_CallNew => v2009?
                         ctiCall.m_strOutgoingRef := m_strOutgoingRef;
                         m_strOutgoingRef         := '';

                         // Horodatage de cr�ation de l'appel (pas encore connect�)
                         if Horodatage = TRUE then
                            ctiCall.m_TimeStart := Time;
                    end;
               end;
          end;

          // Suppression d'un appel dans le connecteur: on le marque comme n'existant plus (non supprim� en m�moire)
          ctiEvent_CallDestroy:
          begin
               if ctiCall <> nil then
               begin
                    // $$$ JP 12/01/06 - Si pas encore fait, on m�j l'horodate de fin
                    if (Horodatage = TRUE) and (ctiCall.TimeEnd = 0) then
                       ctiCall.m_TimeEnd := Time;

                    ctiCall.State := ctiState_Idle;
               end;
          end;

          ctiEvent_CallOffering:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Offering;
          end;

          ctiEvent_CallConnect:
          begin
               if ctiCall <> nil then
               begin
                    ctiCall.State        := ctiState_Connected;
                    ctiCall.StateDetails := lInfo;

                    // $$$ JP 13/08/07: horodatage de connexion
                    if Horodatage = TRUE then
                       ctiCall.m_TimeStartConn := Time;

                    ctiCall.State := ctiState_Connected;
               end;
          end;

          ctiEvent_CallDisconnect:
          begin
               if ctiCall <> nil then
               begin
                    // $$$ JP 12/01/06 - Si pas encore fait, on m�j l'horodate de fin
                    if (Horodatage = TRUE) and (ctiCall.TimeEnd = 0) then
                       ctiCall.m_TimeEnd := Time;

                    // $$$ JP 06/11/06: si un appel sortant n'a jamais �t� connect�, on consid�re que le correspondant �tait injoignable (raison inconnue)
                    if (ctiCall.State <> ctiState_Connected) and (ctiCall.Origin = ctiOrigin_Outgoing) and ((lInfo = ctiStateC_None) or (lInfo = ctiStateC_DisconnectNormal)) then
                        ctiCall.StateDetails := ctiStateC_DisconnectNoAnswer
                    else
                        ctiCall.StateDetails := lInfo;

                    ctiCall.State := ctiState_Disconnected;
               end;
          end;

          ctiEvent_CallHold:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_OnHold;
          end;

          ctiEvent_CallConference:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Conferenced;
          end;

          ctiEvent_CallDialTone:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Dialtone;
          end;

          ctiEvent_CallDialing:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Dialing;
          end;

          ctiEvent_CallRingBack:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Ringback;
          end;

          ctiEvent_CallProceeding:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Proceeding;
          end;

          ctiEvent_CallAccepted:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Accepted;
          end;

          ctiEvent_CallBusy:
          begin
               if ctiCall <> nil then
                  ctiCall.State := ctiState_Busy;
          end;

          ctiEvent_CallInfoCallerId:
          begin
               // $$$ JP 31/10/06: modification que si changement
               if ctiCall <> nil then
               begin
                    ctiCall.CallerTel := Trim (string (sInfo)); //strInfo);

                    // Identification n�cessaire (pour appel entrant)
                    bNeedIdentify := TRUE;
               end;
          end;

          ctiEvent_CallInfoCalledId:
          begin
               // $$$ JP 31/10/06: modification que si changement
               if ctiCall <> nil then
               begin
                    ctiCall.CalledTel := Trim (string (sInfo));

                    // Identification n�cessaire
                    bNeedIdentify := TRUE;
               end;
          end;

          ctiEvent_CallInfoConnectedId:
          begin
               // $$$ JP 31/10/06: modification que si changement, et n�cessite identification (peut avoir chang� via le PABX distant)
               if ctiCall <> nil then
               begin
                    ctiCall.ConnectedTel := Trim (string (sInfo));

                    // Identification n�cessaire
                    bNeedIdentify := TRUE;
               end;
          end;

          ctiEvent_CallInfoOrigin:
          begin
               if ctiCall <> nil then
               begin
                    ctiCall.Origin := lInfo;

                    // Identification n�cessaire
                    bNeedIdentify := TRUE;
               end;
          end;

          ctiEvent_CallInfoReason:
          begin
          end;
     end;

     // Appel connu: identification du correspondant si n�cessaire, et transmet l'�v�nement � l'application
     if ctiCall <> nil then
     begin
          // D'abord les identit�s du correspondant, si c'est n�cessaire et possible
          if (bNeedIdentify = TRUE) and (ctiCall.CallTelChanged = TRUE) then
             LoadContacts (ctiCall);

          // Transmission de l'�v�nement � l'application
          if @m_OnAppCallEvent <> nil then
             m_OnAppCallEvent (ctiCall, lEvent);
     end
     else
         // Des �v�nements peuvent ne pas concerner un appel (mais le connecteur, par exemple ctiEvent_ConnectorInactive)
         if @m_OnAppCallEvent <> nil then
            m_OnAppCallEvent (nil, lEvent);
end;

// $$$ JP 13/08/07: pouvoir sp�cifier une r�f�rence associ�e � l'appel sortant (l'appli pourra alors s�lectionner le bon contact lors de OnLoadContacts)
function TCtiInterface.CallMake (strTelephone:string; strOutgoingRef:string=''):LongInt;
//function TCtiInterface.CallMake (strTelephone:string):LongInt;
begin
     // Par d�faut, appel non lanc�
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si proc�dure d'appel d�finie dans la dll, on l'invoque
     if @m_ctiCallMake <> nil then
     begin
          if Length (strTelephone) > 4 then
             strTelephone := m_strPrefixe + strTelephone;

          // $$$ JP 13/08/07: r�f�rence sur appel sortant depuis l'application, qui sera affect� au TCtiCall d�s l'�v�nement ctiEvent_CallNew
          m_strOutgoingRef := strOutgoingRef;

          // Lancement de l'appel par le connecteur
          Result := m_ctiCallMake (pchar (CleTelephone (strTelephone, FALSE)));
     end;
end;

function TCtiInterface.CallConnect (ctiCall:TCtiCall):LongInt;
begin
     // Par d�faut, appel non connect�
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si appel idle, action impossible
     if ctiCall.State = ctiState_Idle then //ID = LongInt ($FFFFFFFF) then
        exit;

     // Si proc�dure d'appel d�finie dans la dll, on l'invoque
     if @m_ctiCallConnect <> nil then
        Result := m_ctiCallConnect (ctiCall.ID);
end;

function TCtiInterface.CallDisconnect (ctiCall:TCtiCall):LongInt;
begin
     // Par d�faut, appel non termin�e
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si appel idle, action impossible
     if ctiCall.State = ctiState_Idle then
        exit;

     // Si proc�dure d�finie dans la dll, on l'invoque
     if @m_ctiCallDisconnect <> nil then
        Result := m_ctiCallDisconnect (ctiCall.ID);
end;

function TCtiInterface.CallRedirect (ctiCall:TCtiCall; strTelephone:string):LongInt;
begin
     // Par d�faut, appel non redirig�e
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si proc�dure d�finie dans la dll, on l'invoque
     if @m_ctiCallRedirect <> nil then
        Result := m_ctiCallRedirect (ctiCall.ID, pchar (CleTelephone (strTelephone, FALSE)));
end;

function TCtiInterface.CallTransfer (ConnectedCall:TCtiCall; HeldCall:TCtiCall):LongInt;
begin
     // Par d�faut, communication non transf�r�e
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si proc�dure d'appel d�finie dans la dll, on l'invoque
     if (@m_ctiCallTransfer <> nil) and (ConnectedCall <> nil) and (HeldCall <> nil) then
        Result := m_ctiCallTransfer (ConnectedCall.ID, HeldCall.ID);
end;

function TCtiInterface.CallConference (ConnectedCall:TCtiCall; HeldCall:TCtiCall):LongInt;
begin
     // Par d�faut, appel non mis en conf�rence
     Result := 0;

     // Si interface CTI non d�marr�e, on ne fait rien
     if m_bStarted = FALSE then
        exit;

     // Si proc�dure d'appel d�finie dans la dll, on l'invoque
     if (@m_ctiCallConference <> nil) and (ConnectedCall <> nil) and (HeldCall <> nil) then
        Result := m_ctiCallConference (ConnectedCall.ID, HeldCall.ID);
end;

function TCtiInterface.GetContactName (ctiCall:TCtiCall):string;
begin
     Result := '';
     if (ctiCall <> nil) and (@m_AppGetContactName <> nil) then
        Result := m_AppGetContactName (ctiCall);
end;

// $$$ JP 31/10/06: on enl�ve les anciens contacts d�j� existant (plusieurs identification peuvent �tre demand�es)
function TCtiInterface.LoadContacts (ctiCall:TCtiCall):integer;
begin
     // On enl�ve les contacts d�j� pr�sents
     ctiCall.UnloadContacts;

     // On charge les contacts (c'est l'appli qui sait faire)
     if @m_AppLoadContacts <> nil then
         Result := m_AppLoadContacts (ctiCall)
     else
         Result := 0;
end;

function TCtiInterface.UnloadContacts (ctiCall:TCtiCall):boolean;
begin
     if @m_AppUnloadContacts <> nil then
         Result := m_AppUnloadContacts (ctiCall)
     else
         Result := FALSE;
end;

function TCtiInterface.GetCtiCall (lID:LongInt):TCtiCall;
var
   i           :integer;
   SearchCall  :TCtiCall;
begin
     // Par d�faut, communication non trouv�e
     Result := nil;

     // Recherche parmi les communications existantes
     for i := 0 to m_Calls.Count-1 do
     begin
          SearchCall := TCtiCall (m_Calls [i]);
          if SearchCall.ID = lID then
          begin
               Result := SearchCall;
               exit;
          end;
     end;
end;

procedure TCtiInterface.SetCtiCall (lID:LongInt; Call:TCtiCall);
begin
     // Si on r�f�rence un nouvel appel, on l'ajoute � la liste (pas de controle de doublon sur l'id)
     if Call <> nil then
     begin
          // On sp�cifi� l'identifiant de l'appel
          Call.ID := lId;

          // Ajout � la liste
          m_Calls.Add (Call);
     end
     else
     begin
          // On supprime l'appel (de la liste, en m�moire)
          Call := GetCtiCall (lId);
          if Call <> nil then
             m_Calls.Remove (Call);
     end;
end;

function TCtiInterface.GetCallCount (iIndex:integer):integer;
var
   i       :integer;
   iState  :integer;
begin

     // $$$ JP 06/01/06 - pour tous les appels, on renvoie le nb de la liste
     if iIndex = 0 then
         Result := m_Calls.Count
     else
     begin
          Result := 0;
          for i := 0 to m_Calls.Count-1 do
          begin
               iState := integer (TCtiCall (m_Calls [i]).State);

               // $$$ JP 12/01/06 - pouvoir compter les appels qui NE sont PAS dans un �tat donn�
               if iIndex > 0 then
               begin
                    if iState = iIndex then
                       Inc (Result);
               end
               else
               begin
                    if iState <> -iIndex then
                       Inc (Result);
               end;
          end;
     end;
end;




                 // -----------------------------------------
                 //      CLASSE DES APPELS CTI
                 // -----------------------------------------
constructor TCtiCall.Create (ctiInterface:TCtiInterface);
begin
     m_ctiInterface    := ctiInterface;
     m_lId             := LongInt ($FFFFFFFF);
     m_lState          := ctiState_Unknown;
     m_lStateDetails   := ctiStateC_None;
     m_lOrigin         := ctiOrigin_Unknown; // Outgoing      := FALSE;
     m_Contacts        := TObjectList.Create (FALSE); // $$$ JP 16/12/05 - c'est � l'appli de virer ce qu'elle y a mis
     m_Contact         := nil;
     m_strContactName  := '';
     m_CallerTel       := '';
     m_CalledTel       := '';
     m_ConnectedTel    := '';
     m_CallTel         := '';
     m_bCallTelChanged := FALSE;
     //m_NumAction       := 0;
     //m_Auxiliaire      := '';
     m_strOutgoingRef  := '';

     // $$$ JP 12/01/06 - horodatage
     m_TimeStart     := 0;
     m_TimeStartConn := 0; // $$$ JP 13/08/07
     m_TimeEnd       := 0;
end;

destructor TCtiCall.Destroy;
begin
     // On vide la liste des contacts
     UnloadContacts;

     // On supprime la liste des contacts
     FreeAndNil (m_Contacts);

     inherited;
end;

procedure TCtiCall.UnloadContacts;
var
   i   :integer;
begin
     // $$$ JP 16/12/05 - demande � l'interface CTI de supprimer les contacts qu'elle a mis dans ce cticall
     // sinon, on fait ce qu'on peut: on les vire tel quel, sans fioritures
     if m_ctiInterface.UnloadContacts (Self) = FALSE then
        for i := 0 to m_Contacts.Count - 1 do
            m_Contacts [i].Free;

     // vide la liste
     m_Contacts.Clear;
end;

procedure TCtiCall.SetContact (Contact:TObject);
var
   i   :integer;
begin
     // Doit �tre dans la liste des contacts (on pourrait �tre plus permissif, �ventuellement)
     if Contact <> nil then
     begin
          for i := 0 to m_Contacts.Count - 1 do
          begin
               if m_Contacts [i] = Contact then
               begin
                    SetContactIndex (i);
                    exit;
               end;
          end;
     end
     else
         SetContactIndex (-1);
end;

procedure TCtiCall.SetContactIndex (iIndex:integer);
begin
     // Par d�faut, identit� non trouv�e
     m_Contact        := nil;
     m_strContactName := '';

     // Si identit� trouv�e, on la s�lectionne
     if (iIndex >= 0) and (iIndex < m_Contacts.Count) then
     begin
          // On demande �galement le nom du contact
          m_Contact := m_Contacts [iIndex];
          if m_Contact <> nil then
              m_strContactName := m_ctiInterface.GetContactName (Self);
     end;
end;

procedure TCtiCall.SetOrigin (lOrigin:LongInt);
begin
     if lOrigin <> m_lOrigin then
     begin
          m_lOrigin := lOrigin;
          UpdateCallTel;
     end;
end;

function TCtiCall.GetCallTel (iIndex:integer):string;
begin
     UpdateCallTel;

     // Si libell� (facename), on indique si n� cach�
     Result := m_CallTel;
     if (iIndex = 1) and (Result = '') then
         Result := '<n� cach�>'
end;

procedure TCtiCall.UpdateCallTel;
var
   strCallTel  :string;
begin
     // C'est le num�ro connect� en priorit�
     strCallTel := Trim (m_ConnectedTel);
     if strCallTel = '' then
     begin
          // Sinon, selon origine de l'appel, l'appellant ou l'appell�
          case m_lOrigin of
               ctiOrigin_Outgoing:
                  strCallTel := Trim (m_CalledTel);

               ctiOrigin_Incoming:
                  strCallTel := Trim (m_CallerTel);
          end;
     end;

     // Si a chang�, on l'indique
     if strCallTel <> m_CallTel then
     begin
          m_CallTel         := strCallTel;
          m_bCallTelChanged := TRUE;
     end;
end;

function TCtiCall.GetCallTelChanged:boolean;
begin
     Result            := m_bCallTelChanged;
     m_bCallTelChanged := FALSE;
end;

procedure TCtiCall.SetCallerTel (strTel:string);
begin
    if strTel <> m_CallerTel then
    begin
         m_CallerTel := strTel;
         UpdateCallTel;
    end;
end;

procedure TCtiCall.SetCalledTel (strTel:string);
begin
    if strTel <> m_CalledTel then
    begin
         m_CalledTel := strTel;
         UpdateCallTel;
    end;
end;

procedure TCtiCall.SetConnectedTel (strTel:string);
begin
    if strTel <> m_ConnectedTel then
    begin
         m_ConnectedTel := strTel;
         UpdateCallTel;
    end;
end;

function TCtiCall.GetDuringTime (iIndex:integer):TDateTime;
begin
     Result := 0;

     case iIndex of
          // Dur�e de l'appel depuis la notification de sa cr�ation
          0:
            if m_TimeStart > 0 then
               if m_TimeEnd > 0 then
                   Result := m_TimeEnd - m_TimeStart
               else
                   Result := Time - m_TimeStart
            else
                Result := 0;

          // Dur�e de l'appel depuis la notification de sa connexion
          1:
            if m_TimeStartConn > 0 then
               if m_TimeEnd > 0 then
                   Result := m_TimeEnd - m_TimeStartConn
               else
                   Result := Time - m_TimeStartConn
            else
                Result := 0;
     end;
end;

function TCtiCall.GetHorodate:string;
begin
     Result := '';
     if m_TimeStart > 0 then
     begin
          // $$$ JP 13/08/07: heure d�but d'appel connect� si connue
          if m_TimeStartConn > m_TimeStart then
              Result := FormatDateTime ('hh"h"nn', m_TimeStartConn)
          else
              // Heure de d�but d'appel (cr�ation, non connect�)
              Result := FormatDateTime ('hh"h"nn', m_TimeStart);

          // On veut aussi la dur�e, si on a l'heure de fin
          if m_TimeEnd > 0 then
          begin
               // $$$ JP 13/08/07: heure de connexion si connue
               if m_TimeStartConn > m_TimeStart then
                   Result := Result + ', ' + FormatDateTime ('nn"''"ss"''''"', m_TimeEnd-m_TimeStartConn)
               else
                   Result := Result + ', ' + FormatDateTime ('nn"''"ss"''''"', m_TimeEnd-m_TimeStart);
          end;
     end;
end;

function TCtiCall.GetFaceName (iIndex:integer):string;
begin
     Result := '';
     if iIndex = 1 then
     begin
          // Texte en fonction de l'�tat de la communication
          case m_lState of
               ctiState_Offering:
                  Result := 'De ' + CallTelName; //CorrespondentTelFaceName; //GetNumTel (m_CallerTel);

               ctiState_Connected:
               begin
                    // Horodatage
                    Result := Horodate;
                    if Result <> '' then
                       Result := '(' + Result + ') ';

                    case m_lOrigin of
                         ctiOrigin_Outgoing:
                            Result := Result + 'Vers ';

                         ctiOrigin_Incoming:
                            Result := Result + 'De ';
                    end;

                    // $$$ JP 11/01/06 - n� de t�l�phone du correspondant
                    Result := Result + CallTelName; // GetNumTel (m_ConnectedTel)
               end;

               ctiState_Disconnected,
               ctiState_Idle:
               begin
                    // $$$ JP 12/01/06 - heure de fin de l'appel (s'il �tait connect�)
                    Result := Horodate;
                    if Result <> '' then
                       Result := '(' + Result + ') ';

                    // $$$ JP 11/01/06 - normalement le connect�
                    case m_lStateDetails of
                         ctiStateC_DisconnectNormal,
                         ctiStateC_DisconnectUnknown,
                         ctiStateC_None:
                            Result := Result + 'Termin� ';

                         ctiStateC_DisconnectBusy:
                            Result := Result + 'Occup� ';

                         ctiStateC_DisconnectNoAnswer:
                            Result := Result + 'Injoignable ';

                         ctiStateC_DisconnectBadAddress:
                            Result := Result + 'Mauvais num�ro ';

                         ctiStateC_DisconnectCongestion:
                            Result := Result + 'Probl�me r�seau t�l�phonique ';

                         ctiStateC_DisconnectReject,
                         ctiStateC_DisconnectBlocked:
                            Result := Result + 'Rejet� ';
                    end;
                    Result := Result + CallTelName; //CorrespondentTelFaceName;
               end;

               ctiState_OnHold:
                  Result := 'Attente ' + CallTelName; //GetNumTel (m_ConnectedTel);

               ctiState_Dialtone:
                  Result := 'Attente de num�rotation';

               ctiState_Dialing:
                  Result := 'Num�rotation en cours';

               ctiState_Proceeding:
                  Result := 'Acheminement vers ' + CallTelName; //GetNumTel (m_CalledTel);

               ctiState_Ringback:
                  Result := 'Sonnerie sur ' + CallTelName; //GetNumTel (m_CalledTel);

               ctiState_Conferenced:
                  // $$$ JP 11/01/06 - normalement le connected id
                  Result := 'Conf�rence avec ' + CallTelName; //GetNumTel (m_ConnectedTel);
          end;
     end;

     // Si une identit� en s�lection, on l'indique
     if (m_Contact <> nil) and (m_strContactName <> '') then
     begin
          if Result <> '' then
             Result := Result + ': ';
          Result := Result + m_strContactName;
     end;
end;


end.

