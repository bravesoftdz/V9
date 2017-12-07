unit galOutil;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  UIUtil, StdCtrls, ExtCtrls, HCtrls, ComCtrls, UBob,
{$IFDEF EAGLCLIENT}
  MenuOLX, uHttp,
  {$IFDEF BUREAU}
  CegidPgiUtil,
  {$ENDIF}
{$ELSE}
  DBCtrls, HDB, MajTable,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  Db,
  {$IFNDEF EAGLSERVER}
  MenuOLG,
  {$ENDIF}
  Sql7Util, DaoUtil, HQuickRp, majstruc,
{$ENDIF}
{$IFDEF VER150}
   Variants,
{$ENDIF}
  uWaBDSqlServer, Mask, Hqry, Menus, FileCtrl, HStatus, HMsgBox, HEnt1,
  UDossierSelect, galEnv, // remont�s pour d�claration TPGIConn
  IniFiles, ShellAPI, LicUtil, Math, UTob, Paramsoc,
  HFLabel, ed_tools, UTom, PGIAppli, CBPPath;


{$IFDEF EAGLCLIENT}
{$IFDEF BUREAU}
// $$$ JP 16/12/05 - Cr�ation dossier CWAS
// $$$ JP 17/05/06 - var NoDossier si changement de n� dossier
function galCreateDossier (SGuidPer:string; NoDisk: Integer; var NoDossier:string; lAide, lCreation: THLabel; f: TWinControl; AllowChange:boolean=TRUE;
                           GroupeConf:string=''; Password:string=''; SansBase:boolean=FALSE; bRepriseBase:boolean=TRUE;
                           OnExistingDossier:boolean=FALSE; bInitEtabCompl:boolean=FALSE):integer;

{$ENDIF BUREAU}

{$ELSE}

type
  TPGIEnvInformation = procedure(Sender: TObject; ErrCode: integer; ErrMsg: string) of object;

  {$IFDEF DP}
  TCreedoss = class(TObject)
    // ---- ici propri�t�s de l'objet modifiables directement
    DBDest: TDatabase;
    DBRef: TDatabase;
    RempliDefaut: TStringList;
    RempliStandards: TStringList;
    OnInformation: TPGIEnvInformation;
    // la base mod�le ou la base en cours ont le m�me driver

  private
    DestDriver: TDBDriver;
    DestODBC: Boolean;
    TypeIncrem: string;
    procedure ShowError(Code: Integer; Txt: string);
    procedure CopieDeShare;

  public
    constructor Create(ProcOnInfo: TPGIEnvInformation = nil);
    destructor Destroy; override;
    function BaseModeleOK(lAide, lCreation: THLabel): Boolean;
    procedure ConnecteLeDB(var DB: TDatabase; Nom: string; conn: TPGIConn);
    procedure ObjConnToIni(objconn: TPGIConn; societe: string = '');
    function CreeBase(conn: TPGIConn; chembdd: string): Boolean;
    function CreeDossier(tobAnn: TOB; NoDisq: Integer; var NoDossier: string; lAide, lCreation: THLabel; // $$$ JP 17/05/06 FQ 10107: var NoDossier
      f: TWinControl; AllowChange: Boolean = True; AvecConfirm: Boolean = True; GroupeConf: string = '';
      AutoAttach: Boolean = False; cCree: TPGIConn = nil; Password: string = ''; SansBase: Boolean = False;
      OnExistingDossier: Boolean = False; bInitEtabCompl: Boolean = False; IgnorerGroupeConf : Boolean = False): Integer;
    function CreeBaseDossier(lAide, lCreation: THLabel; f: TWinControl; NoDisq: Integer; NoDossier: string;
      var cDest: TPGIConn; AvecConfirm: Boolean = True; AutoAttach: Boolean = False): Integer;
    procedure InitialiseSoc(cDest: TPGIConn; lAide: THLabel);
    function OpenSQLDB(DB: TDatabase; sSQL: string; RO: Boolean): TQuery;
    function RecupChpDB(DB: TDatabase; Fichier, Champ, Where: string; var Valeur: Variant): Boolean;
    function RepeterAction(F: TWinControl; NomAction, TitreAction, Argums: string): Boolean;
  end;
  {$ENDIF DP}
{$ENDIF EAGLCLIENT}

{$IFDEF EAGLCLIENT}
{$ELSE}
function  BaseExiste(conn: TPGIConn): Boolean;
function  AttachDbAutoclose(DBname, MdfFile, LdfFile: string; ShowErr: Boolean = True;
                            c: TPGIConn = nil; bWithoutLog: Boolean = False): Boolean;
function  DetachDbRemetDroits(DBName, RepMdf, RepLdf: string; ShowErr: Boolean = True;
                            c: TPGIConn = nil): Boolean;
{$IFDEF DP}
// SMA 131205 ajout parametre SansBase
function ForceDossierExiste(nodoss: string; lAide, lCreation: THLabel;
  F: TWinControl; NoDisq: Integer; SansBase: Boolean = False): Boolean;
function EstSQLetLocaletSuperviseur(LocalOkSiDayPass: Boolean = False): Boolean;
{$ENDIF}

function  CreePgiConn(nombase: string): TPGIConn;
procedure CopyPGIConn(cSrc, cDest: TPGIConn);
function  ConnecteDBSansIni(var DB: TDataBase; Nom: string; conn: TPGIConn; Exclusive: Boolean = false): Boolean;
{$ENDIF EAGLCLIENT}

// function  GetCheminBob: string; => remplac� par TCBPPath.GetCegidDistriBob
function  PCL_IMPORT_BOB(CodeProduit: string; TypeBOZ: Boolean = False; ForceChemin: String = ''): Integer;
procedure PCL_SUP_BOB(CodeProduit: string);
procedure SynchroniseParamSoc(GuidPer: string);

procedure SetFlagAppli(sExeName: string; bFlag: Boolean);
procedure SetFlagAppliDossier(sExeName, sNoDossier: string; bFlag: Boolean);
function  GetFlagAppli(sExeName: string): Boolean;
procedure ChangeEtatEcran(lAide, lCreation: THLabel; f: TWinControl; etat: Boolean);
function  NouveauNoDossier(typincrem, nom: string): string;
{$IFNDEF EAGLSERVER}
procedure RajouteCaptionDossier(sTitre: string);
procedure RajouteTitreForm(sTitre: string);
{$ENDIF}
procedure ListeVersCombo(listcod, listlib: TStringList; cb: THValComboBox; withTous: Boolean = FALSE);
procedure TableauVersCombo(aosCodes_p, aosLibelles_p: array of string;
  cbCombo_p: THValComboBox; bAvecTous_p: Boolean = FALSE);

procedure ListeVersMultiValCombo(listlib: TStringList; mv: THMultiValComboBox);
procedure TobVersCombo(tobe: TOB; chp1, chp2: string; cb: THValComboBox);

{$IFDEF DP}
procedure PartagesVersCombo(cb: THValComboBox);
{$ENDIF}

procedure PartagesVersMultiValCombo(mv: THMultiValComboBox);
function  PartageExiste(rep: string): Boolean;
function  CreeEnregDP(Prefixe, Table: string; GuidPer: string): Boolean;
function  DateTjsCorrecte(sDate: string): TDateTime;
function  TroisPremieresLettres(nom: string): string;
function  MotSignifiant(mot: string): Boolean;
function  ElimineCaracZarbi(nom: string; saufespaces: Boolean): string;
function  JaiLeDroitGroupeConf(groupeconf: string): Boolean;
function  JaiLeDroitDossier(NoDossier: string): Boolean;
function  IsSuperviseur(AvecMsg: Boolean = True): Boolean;
function  EtatMarqueDossier(nodoss: string; var usr, login: string; var sansbase: Boolean): string;
function  IsDossierSansBase(nodoss: String): Boolean;
{$IFDEF BUREAU}
function  LanceContexteDossier(stNoDossier: string; AvecVerifPwd: Boolean = True): Boolean;
{$ENDIF}
procedure InitialiserComboGroupeConf (ComboGroupeConf : TControl; FiltreDonnees:string='' ) ; //LM20071008
procedure InitialiserComboApplication (ComboApplication : TControl);
function  GererCritereGroupeConfTous (FiltreDonnees:string='') : String;
function  GererCritereGroupeConf (ComboGroupeConf: TControl; SansGroupeConf: Boolean; bFullGroups: Boolean=False; FiltreDonnees:string='') : String;
function  GererCritereApplication (ComboApplication: TControl) : String;
function  GererCritereDivers (SansDossierCabinet:Boolean=FALSE; SansDossierTransport:Boolean=FALSE;
  SansDossier:Boolean=FALSE; AvecDossiersCabinets:Boolean=FALSE; AvecDossVerrou: String='') : String;
function  GererCritereAgricole (ListeCode : String) : String;
procedure GereCheckboxSansGrpConf(CheckboxGroupeConf, ComboGroupeConf : TControl);
procedure AffecteAppliProtec (nodoss:string; SListeAppli:string);
function  DonnerListeAppliProtec (NoDoss:string) : String;

procedure ErreurChamp(lechp, lapage: string; T: TOM; msg: string);
function  ChampEstDansQuery(nomchp: string; Q: THQuery): Boolean;
function  IsDossierPartiSauf(nodoss, nomexec: string): Boolean;
procedure ChargeListChpDPSTD(lst: TStringList);

{$IFDEF DP}
function  DossierExiste(nodoss: string): Boolean;
function  SupprDonneesCommunesDans(nodoss: string): string;
{$ENDIF}

function  ForcePersonneExiste(nodoss, libacreer: string): String;
function  VersionDossier(nodoss: string): Integer;
// #### function  ChercheEtRenommeLDF(repdoss, dbname: string): string;

// $$$ JP 27/12/05 - changement de nom
function  DBSetAutoClose (strBase:string; bAutoClose:boolean):boolean;
{$IFDEF BUREAU}
{$IFDEF EAGLCLIENT}
function  DBCollationOk  (nodoss:string):boolean; // $$$ JP 19/05/06 FQ 10616
{$ELSE}
function  GetGoodCollation : String;
{$ENDIF}
{$ENDIF}
// $$$

function NoDossierBaseCommune: string;
procedure SetAppliActive(sExeName, sNoDossier: string; bFlag: Boolean);
function GetGuidPer(nodoss: string): String;
function GetNoDossierFromGuidPer(GuidPer: string): String;
function GetGammeDossier(nodoss: string): string;
function ListeCorrecte(sChampNom_p, sChampTitre_p: string; QRY_p: THQuery): Boolean;
function GetParamsocDP(NomParam: string): Variant;
function GetParamsocDossier(NomParam: string; NomBase: String): Variant;
function GetPathDossier(nodoss: string): string;
procedure InsideSynthese (f:TForm); //LMO
function RecupArgument(cle, arg: string): string; //LM20071008
function RecupEtSupprimeArgument(cle : string; var arg: string): string; //LM20071008
procedure InitTTFormeJuridique ( stNomBase : string );



/////////////// IMPLEMENTATION ////////////////
implementation

uses
{$IFNDEF SANSCOMPTA}
    ULibStdCpta, // diffusion\compta\libs
{$ENDIF SANSCOMPTA}
    EntDP,
    PwdDossier,
    galSystem,
    galDossierCste,
    usatUtil;


{$IFDEF EAGLCLIENT}
{$IFDEF BUREAU}
function galCreateDossier (SGuidPer:string; NoDisk: Integer; var NoDossier:string; lAide, lCreation: THLabel; f: TWinControl; AllowChange:boolean=TRUE;
                           GroupeConf:string=''; Password:string=''; SansBase:boolean=FALSE; bRepriseBase:boolean=TRUE;
                           OnExistingDossier:boolean=FALSE; bInitEtabCompl:boolean=FALSE):integer;
var
   TOBAnnuaire   :TOB;
   TOBOptions    :TOB;
   iTryBloque    :integer;
   Q             :TQuery;

   procedure CleanExit;
   begin
     TOBAnnuaire.Free;
     TOBOptions.Free;
   end;

begin
     // Par d�faut, dossier non cr�er
     Result := TDOSS_CANTCREEDOSSIER;

     // Si pas d'interface sur le plugin cwas, impossible de faire quoi que ce soit
     if VH_DP.ePlugin = nil then
        exit;

     // Pr�paration des param�tres pour la cr�ation du dossier: fiche personne li�e + options de cr�ation
     TOBAnnuaire := TOB.Create ('ANNUAIRE', nil, -1);
     TOBOptions  := TOB.Create ('OPTIONS PLUGIN BUREAU', nil, -1);
     SourisSablier;
     try
        // Chargement de la fiche personne li�e au futur dossier
        TOBAnnuaire.SelectDB ('"'+SGuidPer+'"', nil, TRUE);

        // Mise en place des options de cr�ation dossier
        with TOBOptions do
        begin
             AddChampSupValeur ('OPB_NODISK',            NoDisk,            CSTInteger);
             AddChampSupValeur ('OPB_NODOSSIER',         NoDossier,         CSTString);
             AddChampSupValeur ('OPB_PWD',               Password,          CSTString);
             AddChampSupValeur ('OPB_GROUPE',            GroupeConf,        CSTString);
             AddChampSupValeur ('OPB_BASEPROD',          not SansBase,      CSTBoolean);
             AddChampSupValeur ('OPB_REPRISEBASE',       bRepriseBase,      CSTBoolean);
             AddChampSupValeur ('OPB_ONEXISTINGDOSSIER', OnExistingDossier, CSTBoolean);
             AddChampSupValeur ('OPB_INITETABL',         bInitEtabCompl,    CSTBoolean);
        end;

        // On tente de rentrer dans le traitement bloquant "CreationDossier"
        iTryBloque := 0;
        while EstBloque ('CreationDossier', FALSE) = TRUE do
        begin
             if iTryBloque > 9 then
             begin
                  if PgiAsk ('Un dossier est en cours de cr�ation'#10' D�sirez-vous attendre la fin de cette cr�ation pour enchainer la votre ?') <> mrYes then
                  begin
                       Result := TDOSS_DBMODELEINUSE;
                       CleanExit;
                       exit; // Sortie
                  end
                  else
                      iTryBloque := 0;
             end
             else
             begin
                  Inc (iTryBloque);
                  Delay (3000);
                  Application.ProcessMessages;
             end;
        end;

        // V�rifications ignor�es si on sait qu'on cr�e sur un dossier existant
        if (not OnExistingDossier) then
        begin
             // personne ayant d�j� un dossier
             Q := OpenSql('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_GUIDPER="' + TobAnnuaire.GetValue('ANN_GUIDPER') + '"', True,-1, '', True);
             if not Q.Eof then
             begin
                  PGIInfo('Cette personne a d�j� un dossier sous le num�ro ' + Q.FindField('DOS_NODOSSIER').AsString + '.');
                  Result := TDOSS_PERSONWITHDOSS;
                  Ferme(Q);
                  CleanExit;
                  exit; // Sortie
             end;
             Ferme(Q);

             // On v�rifie le n� de dossier, et on en propose un autre si pas correct (et si changement n� dossier possible)
             if IsNoDossierOk (NoDossier) = FALSE then
             begin
                  // Si changement interdit, on ne peut pas cr�er de dossier
                  if not AllowChange then
                  begin
                       PgiInfo ('Cr�ation de dossier impossible: le num�ro de dossier souhait� "' + NoDossier + '" n''est pas correct'#10' Veuillez utiliser uniquement des lettres majuscules ou des chiffres');
                       Result := TDOSS_BADNODOSSIER;
                       CleanExit;
                       exit; // Sortie
                  end;

                  // Calcul d'un nouveau n� de dossier
                  NoDossier := NouveauNoDossier (GetParamSocSecur ('SO_MDINCREMNODOSS', 'ALP'), TOBAnnuaire.Detail [0].GetString ('ANN_NOM1'));
                  if NoDossier = '' then
                  begin
                       PgiInfo ('Cr�ation de dossier impossible: le num�ro de dossier souhait� "' + NoDossier + '" n''est pas correct,'#10' et incr�mentation automatique non activ�e (pr�f�rences)');
                       Result := TDOSS_BADNODOSSIER;
                       CleanExit;
                       exit; // Sortie
                  end;

                  if PGIAsk ('Proposition de num�ro de dossier : [' + NoDossier + ']. Ce num�ro vous convient-il ?', TitreHalley) = mrNo then
                  begin
                       PgiInfo ('Cr�ation de dossier impossible: le num�ro de dossier propos� "' + NoDossier + '" est refus�,'#10' et le num�ro souhait� "' + NoDossier + '" n''est pas correct');
                       Result := TDOSS_NODOSSREFUSED;
                       CleanExit;
                       exit; // Sortie
                  end;
             end;
        end;

        // Bloque la cr�ation de dossier pour les autres
        Bloqueur ('CreationDossier', TRUE);
        ChangeEtatEcran(lAide, lCreation, f, False);
        try
           // Invocation du serveur cwas pour cr�ation dossier
           Result := VH_DP.ePlugin.WACreateDossier (TOBAnnuaire, TOBOptions);
        finally
               // Terminares, on ne bloque plus le traitement "CreationDossier"
               ChangeEtatEcran(lAide, lCreation, f, True);
               Bloqueur ('CreationDossier', FALSE);
        end;

     finally
            SourisNormale;
     end;

     CleanExit;
end;
{$ENDIF BUREAU}

{$ELSE}

  {$IFDEF DP}

{ TCreedoss }
constructor TCreedoss.Create(ProcOnInfo: TPGIEnvInformation = nil);
begin
  DBDest := TDatabase.Create(Appli);
  DBDest.Name := 'DBDEST';
  DBRef := TDatabase.Create(Appli);
  DBRef.Name := 'DBREF';
  RempliDefaut := TStringList.Create();
  RempliStandards := TStringList.Create();
  TypeIncrem := GetParamSocSecur('SO_MDINCREMNODOSS', 'ALP');
  // pointeur de proc�dure d'affichage des infos
  OnInformation := ProcOnInfo;
  // voir InitSoc de S5
  DestDriver := V_PGI.Driver; DestODBC := V_PGI.ODBC; V_PGI.StopCourrier := TRUE;
end;


destructor TCreedoss.Destroy;
begin
  if DBRef <> nil then
  begin
    DBRef.Connected := False;
    DBRef.Free;
  end;
  if DBDest <> nil then
  begin
    DBDest.Connected := False;
    DBDest.Free;
  end;
  if RempliDefaut <> nil then RempliDefaut.Free;
  if RempliStandards <> nil then RempliStandards.Free;
  V_PGI.Driver := DestDriver; V_PGI.ODBC := DestODBC; V_PGI.StopCourrier := FALSE;
  inherited;
end;


function TCreeDoss.BaseModeleOK(lAide, lCreation: THLabel): Boolean;
// V�rifie ou cr�e la base mod�le permettant la cr�ation rapide d'un dossier
// Emplacement : standards clients (DAT) - Nom : DBMODELE
// La v�rification de sa disponibilit� doit �tre faite avant
// (cr�ation de dossier = mono-utilisateur, voir JaiBloque('CreationDossier'))
var cModel: TPGIConn;
    conndbok, doitalimenter: Boolean;
    VMod, VRef: Variant;
begin
  Result := False;
  lAide.Caption := 'V�rification de la base mod�le...';

  // normalement, cas d�j� �limin� lors du form_show
  if (V_PGI.Driver<>dbMsSQL) and (V_PGI.Driver<>dbMSSQL2005) then
  begin
    SourisNormale;
    PgiInfo('Le type de driver ' + DriverToSt(V_PGI.Driver, True) + ' n''est pas trait� en multi-dossier.', TitreHalley);
    exit;
  end;

  // --- Pr�pare objet de connexion � la base mod�le
  cModel := CreePGIConn('DBMODELE');
  cModel.Societe := '###MODELE###'; // pour info
  cModel.Dir := V_PGI.DatPath;

  // --- Existence de la base MODELE
  doitalimenter := False;
  if not DBExists('DBMODELE') then
  begin
    doitalimenter := True;
    if not CreeBaseSql('DBMODELE', VH_DP.PathDatLoc+'\DBMODELE.MDF', VH_DP.PathDatLoc+'\DBMODELE.LDF', GetParamsocSecur('SO_ENVFILEGROWTH', '2')) then
    begin
      SourisNormale;
      PGIInfo('Impossible de cr�er la base mod�le pour les cr�ations de dossier.', TitreHalley);
      cModel.Free;
      exit;
    end;
  end;

  // --- Teste la connexion
  conndbok := False;
  try
    conndbok := ConnecteDBSansIni(DBDest, 'DBDEST', cModel);
  except
  end;
  if not conndbok then
  begin
    SourisNormale;
    PgiInfo('Impossible de se connecter � la base mod�le.', TitreHalley);
    cModel.Free;
    exit;
  end;

  // --- Si base existait d�j�, on regarde le no de version
  if not doitalimenter then
  begin
    if not DBRef.Connected then ConnecteDB('Reference', DBRef, 'DBREF');
    // m�me si ConnecteDB ne positionne pas V_PGI.Driver, le opensqldb le fait...
    RecupChpDB(DBRef, 'SOCIETE', 'SO_VERSIONBASE', '', VRef);
    if VarToStr(VRef) = '' then VRef := 0;
    DBRef.Connected := False;
    // le DBDest est "pr�par�" dans le try except
    if not DBDest.Connected then DBDest.Connected := True;
    RecupChpDB(DBDest, 'SOCIETE', 'SO_VERSIONBASE', '', VMod);
    // absence de version = pas de table soci�t� : base abim�e
    if VarToStr(VMod) = '' then VMod := 0;
    // version base mod�le incorrecte
    if VMod <> VRef then
      // #### choix actuel : d�truire la base mod�le au lieu d'1 majstruc
    begin
         // $$$ JP 30/12/05 - il faut "planter" si la base mod�le est de version sup�rieure: pas normal du tout!!
         if vMod > vRef then
         begin
              SourisNormale;
              PgiInfo ('La base mod�le actuelle est plus r�cente que la base de r�f�rence'#10' Ceci est anormal, veuillez contacter un administrateur');
              cModel.Free;
              exit;
         end;
         // $$$

         DBDest.Connected := False;
         if not SupprimeBaseSql('DBMODELE') then
         begin
              SourisNormale;
              PGIInfo ('Impossible de supprimer l''ancienne base mod�le pour les cr�ations de dossier.', TitreHalley);
              cModel.Free;
              exit;
         end;

      doitalimenter := True;
      if not CreeBaseSql(cModel.Base, VH_DP.PathDatLoc+'\'+cModel.Base+'.MDF', VH_DP.PathDatLoc+'\'+cModel.Base+'.LDF', GetParamsocSecur('SO_ENVFILEGROWTH', '2')) then      begin
        SourisNormale;
        PGIInfo ('Impossible de cr�er la base mod�le pour les cr�ations de dossier.', TitreHalley);
        cModel.Free;
        exit;
      end;
    end;
  end;

  // --- Si la base mod�le vient d'�tre cr��e
  if doitalimenter then
  begin
    // --- d�but copie des tables
    if lCreation <> nil then
        lCreation.Caption := 'Cr�ation de la base mod�le...'
    else
        lAide.Caption := 'Cr�ation de la base mod�le...';

    // Cr�ation de toutes les tables et recopie des tables minimum
    InitialiseSoc(cModel, lAide);

    // 21/02/01 - Purge des paramsoc compta => trop tard, d�cal� dans le InitialiseSoc
    // ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" where SOC_TREE LIKE "001;001;%"', DBDest) ;

    // Param�tres applicatifs : Exos et devise, ...
    //####ExecuteSQLDB('delete from EXERCICE',DBDest) ; etc...

    // Divers & fin
    ExecuteSQLDB('UPDATE UTILISAT SET US_PRESENT="-"', DBDest);

    // --- fin copie
  end;
  // --- Fin alimentation de la base mod�le

  cModel.Free;
  DBDest.Connected := False;
  DBRef.Connected := False;
  Result := True;
end;

procedure TCreeDoss.ConnecteLeDB(var DB: TDatabase; Nom: string; conn: TPGIConn);
begin
  if DB = nil then DB := TDataBase.Create(Appli);
  // cet appel modifie V_PGI.Driver et V_PGI.ODBC
  ConnecteDBSansIni(DB, Nom, conn);
  DB.Connected := True;
end;


procedure TCreeDoss.ObjConnToIni(objconn: TPGIConn; societe: string = '');
// �crit une section dans cegidpgi.ini
var Buffer: array[0..1023] of Char;
  IniFile: TIniFile;
  sWinPath, section: string;
begin

  if societe <> '' then section := societe
  else section := objconn.Societe;
  if section = '' then exit;

  // ---- R�pertoires
  GetWindowsDirectory(Buffer, 1023);
  SetString(sWinPath, Buffer, StrLen(Buffer));

  IniFile := TIniFile.Create(sWinPath + '\CEGIDPGI.INI');
  if societe = '' then IniFile.WriteString(section, 'Societe', objconn.Societe);
  IniFile.WriteString(section, 'Share', objconn.Share);
  IniFile.WriteString(section, 'Dir', objconn.Dir);
  IniFile.WriteString(section, 'Driver', objconn.Driver);
  IniFile.WriteString(section, 'Server', objconn.Server);
  IniFile.WriteString(section, 'Path', objconn.Path);
  IniFile.WriteString(section, 'ODBC', objconn.ODBC);
  IniFile.WriteString(section, 'DataBase', objconn.Base);
  IniFile.WriteString(section, 'Options', objconn.Options);
  IniFile.WriteString(section, 'User', CryptageSt(objconn.User));
  IniFile.WriteString(section, 'Password', CryptageSt(objconn.Password));
  IniFile.UpdateFile;
  IniFile.Free;
end;


function TCreeDoss.CreeBase(conn: TPGIConn; chembdd: string): Boolean;
// chembdd est le r�pertoire local au serveur (pour cr�ation base)
begin
  Result := False;
  // cr�ation base Access
  if conn.Driver = 'MSACCESS' then
  begin
    CreateDatabaseMSACCESS(conn.Base);
    Result := FileExists(conn.Base);
  end
  // cr�ation base Interbase
  else if conn.Driver = 'INTRBASE' then
    Result := CreateDataBaseINTERBASE(conn.Server, conn.User, conn.Password)
  // cr�ation base Sql Server
  else if (conn.Driver = 'ODBC_MSSQL') or (conn.Driver = 'ODBC_MSSQL2005') then
    // chemin vu du client
    Result := CreateDatabaseMSSQL7(conn.Base, chembdd, True, conn);
    // #### Attente AGL>7.0.20.15 : utiliser CreateDatabaseMSSQL(conn.Base, mdf, ldf, filegrowth...)
end;


function TCreedoss.CreeDossier(tobAnn: TOB; NoDisq: Integer; var NoDossier: string; lAide, lCreation: THLabel;
  f: TWinControl; AllowChange: Boolean = True; AvecConfirm: Boolean = True; GroupeConf: string = '';
  AutoAttach: Boolean = False; cCree: TPGIConn = nil; Password: string = ''; SansBase: Boolean = False;
  OnExistingDossier: Boolean = False; bInitEtabCompl: Boolean = False ; IgnorerGroupeConf : Boolean = False): Integer;
// --- voir les codes d'erreur en t�te du module ---
// TobAnn (tob annuaire) doit contenir les champs n�cessaires : ANN_GUIDPER, ANN_NOM1...
// NoDisq : no du disque de donn�es pour cr�er le dossier (voir les paramsoc d'environnement)
// AllowChange : autorise modif du var NoDossier si il n'est pas correct
// AvecConfirm : demande confirmation avant de faire le changement
var
  LibDossier, newNoDossier: string;
  st, sForme: string;
  cDest: TPGIConn;
  conndbok: Boolean;
  Q: TQuery;
  i: Integer;
  SQLSociete: string;
  strMessage  :string;
  strPathDossier :string;
begin
  Result := TDOSS_CREATIONOK;

  // si type de driver non support�, on va quitter...         
  // #### voir driver pour autres SGBD
  if (V_PGI.Driver<>dbMSACCESS) and (V_PGI.Driver<>dbINTRBASE) and (V_PGI.Driver<>dbMSSQL) and (V_PGI.Driver<>dbMSSQL2005) then
  begin
    ShowError(TDOSS_DRIVERNOTSUPPORTED, 'Le type de driver "' + DriverToSt(V_PGI.Driver, True) + '" n''est pas support� en multi-dossier.');
    Result := TDOSS_DRIVERNOTSUPPORTED;
    exit;
  end;
  // v�rif des disques disponibles
  if V_PGI.Partages[1] = '' then
  begin
    ShowError(TDOSS_NOSHAREDDISK, 'Aucun disque partag� disponible.');
    Result := TDOSS_NOSHAREDDISK;
    exit;
  end;

  // identification de l'emplacement
  // (no disq est en base 1 => de 1 � V_PGI.Partages.Count)
  if (NoDisq < 1) or (V_PGI.Partages[NoDisq] = '') then
  begin
    ShowError(TDOSS_DISKNOTEXISTS, 'Le disque ' + IntToStr(NoDisq) + ' n''est pas un disque disponible.');
    Result := TDOSS_DISKNOTEXISTS;
    exit;
  end;

  // v�rifications
  if (not TobAnn.FieldExists('ANN_GUIDPER'))
  or (not TobAnn.FieldExists('ANN_NOM1')) then
  begin
    ShowError(TDOSS_BADPERSON, 'Aucun champ pour la r�f�rence � une personne de l''annuaire.');
    Result := TDOSS_BADPERSON;
    exit;
  end;

  // V�rif personne
  if (TobAnn.GetValue('ANN_GUIDPER') = '') then
  begin
    ShowError(TDOSS_NOPERSON, 'La r�f�rence � une personne de l''annuaire est vide.' + #13 + #10 + 'Vous n''avez pas cr�� ou choisi une fiche dans l''annuaire.');
    Result := TDOSS_NOPERSON;
    exit;
  end;

  // V�rifications ignor�es si on sait qu'on cr�e sur un dossier existant
  if (not OnExistingDossier) then
  begin
    // personne ayant d�j� un dossier
    Q := OpenSql('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_GUIDPER="' + TobAnn.GetValue('ANN_GUIDPER') + '"', True,-1, '', True);
    if not Q.Eof then
    begin
      ShowError(TDOSS_PERSONWITHDOSS, 'Cette personne a d�j� un dossier sous le num�ro ' + Q.FindField('DOS_NODOSSIER').AsString + '.');
      Result := TDOSS_PERSONWITHDOSS;
      Ferme(Q);
      exit;
    end;
    Ferme(Q);

    // v�rif ou calcul du no de dossier
    // (n�cessite nom abr�g�)
    LibDossier := TobAnn.GetValue('ANN_NOM1');
    // validit�
    if not IsNoDossierOK(NoDossier) then
    begin
      if not AllowChange then
      begin
        ShowError(TDOSS_BADNODOSSIER, 'Le no de dossier n''est pas correct. Utilisez uniquement des lettres majuscules ou des chiffres.');
        Result := TDOSS_BADNODOSSIER;
        exit;
      end;
      newNoDossier := NouveauNoDossier(TypeIncrem, LibDossier);
      if newNoDossier = '' then
      begin
        ShowError(TDOSS_BADNODOSSIER, 'Le no de dossier n''est pas correct et pas d''incr�mentation automatique dans les pr�f�rences.');
        Result := TDOSS_BADNODOSSIER;
        exit;
      end;
      if (AvecConfirm) and (PGIAsk('Proposition de No de dossier : [' + newNoDossier + '] - Est-ce que ce num�ro vous convient ?', TitreHalley) = mrNo) then
      begin
        ShowError(TDOSS_NODOSSREFUSED, 'Le no de dossier ' + newNoDossier + ' propos� est refus�, le no souhait� ' + NoDossier + ' est incorrect.');
        Result := TDOSS_NODOSSREFUSED;
        exit;
      end;
      NoDossier := newNoDossier;
    end;

    // doublon sur no dossier
    if IsNoDossierOK(NoDossier) then
    begin
      Q := OpenSql('SELECT DOS_GUIDPER, ANN_NOM1, ANN_NOM2 FROM DOSSIER LEFT JOIN ANNUAIRE ON DOS_GUIDPER=ANN_GUIDPER WHERE DOS_NODOSSIER="' + NoDossier + '"', True,-1, '', True);
      if not Q.Eof then
      begin
           // $$$ JP 17/05/06 FQ 10107: guidper seulement si vision sav
           if V_PGI.SAV = TRUE then
               strMessage := 'Le num�ro de dossier "' + NoDossier + '" existe d�j� pour la fiche '#10
                             + '   * GUID: ' + Q.FindField ('DOS_GUIDPER').AsString + #10
                             + '   * NOM:  ' + Trim (Q.FindField('ANN_NOM1').AsString + ' ' + Q.FindField ('ANN_NOM2').AsString)
           else
               strMessage := 'Le num�ro de dossier "' + NoDossier + '" existe d�j� pour la fiche '
                             + Trim (Q.FindField('ANN_NOM1').AsString + ' ' + Q.FindField ('ANN_NOM2').AsString);

           if not AllowChange then
           begin
                ShowError (TDOSS_DOSSALREADYEXISTS, strMessage); //'Ce num�ro de dossier existe d�j� pour la fiche [' + Q.FindField('DOS_GUIDPER').AsString + ']' + ' ' + Q.FindField('ANN_NOM1').AsString + '.');
                Ferme(Q);
                Result := TDOSS_DOSSALREADYEXISTS;
                exit;
           end;

           newNoDossier := NouveauNoDossier(TypeIncrem, LibDossier);
           if AvecConfirm = TRUE then
           begin
                // $$$ JP 17/05/06 FQ 10107: guidper seulement si vision sav
                strMessage := strMessage + #10' Num�ro de dossier propos�: [' + newNoDossier + ']. Ce num�ro vous convient-il ?';
                if PGIAsk (strMessage, TitreHalley) = mrNo then
                begin
                     Ferme(Q);
                     ShowError(TDOSS_EXISTSANDREFUSED, 'Cr�ation de dossier impossible: le num�ro de dossier propos� "' + newNoDossier + '" est refus�,'#10' et le num�ro souhait� "' + NoDossier + '" est un doublon');
                     Result := TDOSS_EXISTSANDREFUSED;
                     exit;
                end;
                NoDossier := newNoDossier;
           end;
           Ferme(Q);
      end;
    end;
  end;

  // No de TIERS
  //#### + tard, v�rifier existence du Tiers ou le cr�er if ANN_TIERS.text<>'' ?
  //#### mais redondant avec dans galAssistDB l'appel � AfDos_Tiers

  // d�sactivations
  ChangeEtatEcran(lAide, lCreation, f, False);

  // Tests blocages
  // $$$ JP 02/08/06: la boucle d'attente doit �tre faite si on est pas d�j� le bloqueur
  if not JaiBloque('CreationDossier') then
  begin
       // --- Attend que plus personne ne soit en train d'utiliser la base mod�le
       for i := 12 downto 1 do
       begin
            if EstBloque('CreationDossier', False) then
            begin
                 lAide.Caption := 'Un dossier est d�j� en cours de cr�ation : attente disponibilit� base mod�le... (' + IntToStr(i * 5) + ' s)';
                 Delay(5000); // 10 fois 5 secondes
            end
            else
                break;
       end;

       // Fonction pas dispo pour l'instant
       if EstBloque('CreationDossier', False) then
       begin
            ShowError(TDOSS_DBMODELEINUSE, 'Un dossier est toujours en cours de cr�ation, veuillez r�essayez ult�rieurement.');
            Result := TDOSS_DBMODELEINUSE;
            ChangeEtatEcran(lAide, lCreation, f, True);
            exit;
       end;

       // Blocage
       Bloqueur('CreationDossier', True);
  end;

  // MD 25/05/04 - On a la possibilit� de cr�er un dossier fictif, sans base,
  // pour pouvoir alimenter le DP ou la GED

  // $$$ JP 15/03/07: mais il faut v�rifier s'il n'y en a pas d�j� une, auquel cas on ne doit RIEN faire: c'est une erreur
  // $$$ JP 15/03/07: d�plac� dans CreeDossier, car il faut aussi v�rifier m�me si on veut un dossier sans base...
  strPathDossier := V_PGI.Partages [NoDisq] + '\D' + NoDossier;
  if FileExists (strPathDossier + '\DB' + NoDossier + '.mdf') then
  begin
     ShowError (TDOSS_EXISTINGDBFILE, 'Impossible de cr�er un nouveau dossier, car une base existe d�j� dans ' + strPathDossier
                                     + #10' Veuillez v�rifier sa taille, sa date, sa version ...'#10' Il peut s''agir d''une base dossier incompl�te');
     Result := TDOSS_EXISTINGDBFILE;
     exit;
  end;

  // --- CREATION DE LA BASE DOSSIER ---
  if not SansBase then
  begin
    cDest := nil;
    Result := CreeBaseDossier (lAide, lCreation, f, NoDisq, NoDossier, cDest, AvecConfirm, AutoAttach); // $$$JP 15/03/07 AllowChange);
    if Result <> TDOSS_CREATIONOK then
    begin
      ChangeEtatEcran(lAide, lCreation, f, True);
      Bloqueur('CreationDossier', False);
      exit;
    end;
  end;
  // --- Fin CREATION DE LA BASE DOSSIER ---


  // --- Alimentation de la base commune
  // autorise alimentation si r�paration dossier du cabinet
  if (Result = TDOSS_CREATIONOK) or (SansBase) or (NoDossier = '000000') then
  begin
    // Mise � jour des donn�es de connexion
    Q := OpenSQL('SELECT * FROM DOSSIER WHERE DOS_NODOSSIER="' + NoDossier + '"', False);
    if Q.Eof then
    begin
      Q.Insert; InitNew(Q);
      Q.FindField('DOS_NODOSSIER').AsString := NoDossier;
    end
    else
    begin
      // if Not OnExistingDossier then PgiInfo('Le dossier ['+NoDossier+'] poss�de d�j� des informations de connexion. Elles vont �tre mises � jour.', TitreHalley);
      Q.Edit;
    end;
    Q.FindField('DOS_SOCIETE').AsString := '001';
    Q.FindField('DOS_GUIDPER').AsString := TobAnn.GetValue('ANN_GUIDPER');
    Q.FindField('DOS_LIBELLE').AsString := TobAnn.GetValue('ANN_NOM1');
    if ChampToNum('DOS_PASSWORD') >= 0 then
    begin
      Q.FindField('DOS_PASSWORD').AsString := CryptageSt(UpperCase(Password));
      Q.FindField('DOS_PWDGLOBAL').AsString := 'X';
    end;
    // Le DOS_NODISQUELOC est important pour un dossier parti (DOS_VERROU=PAR),
    // pour identifier son emplacement LOCAL de mani�re diff�rente de DOS_NODISQUE
    // qui son emplacement c�t� serveur
    if VH_DP.LeMode = 'L' then
      Q.FindField('DOS_NODISQUELOC').AsInteger := NoDisq;
    Q.FindField('DOS_NODISQUE').AsInteger := NoDisq;
    // s�rie principale du dossier ####pour l'instant tjs S5
    if Q.FindField('DOS_LASERIE').AsString = '' then Q.FindField('DOS_LASERIE').AsString := 'S5';

    //--- Gestion des groupes de configuration
    // MB : Affectation du/des groupe(s) de conf.
    if not IgnorerGroupeConf then
       AffecteGroupe (NoDossier,GroupeConf) ;
    (*else
     begin
      ExecuteSQl ('DELETE FROM DOSSIERGRP WHERE DOG_NODOSSIER="'+NoDossier+'"');
      ExecuteSQl ('INSERT INTO DOSSIERGRP (DOG_NODOSSIER,DOG_GROUPECONF) VALUES ("'+NoDossier+'","")');
     end;*)

    // Pr�cise si dossier sans base de production
    if SansBase then
      Q.FindField('DOS_ABSENT').AsString := 'X'
    else
      Q.FindField('DOS_ABSENT').AsString := '-';

    // Etat du dossier : accessible !
    Q.FindField('DOS_VERROU').AsString := 'ENL';
    Q.Post;
    Ferme(Q);
  end;
  // --- Fin alimentation de la base commune


  // --- Alimentation de la base dossier
  if not SansBase then
  begin
    // teste la connexion � la nouv. base
    conndbok := False;
    try
      conndbok := ConnecteDBSansIni(DBDest, 'DBDEST', cDest);
    except
    end;
    if not conndbok then
    begin
      ShowError(TDOSS_NEWDBCONNECTFAILED, 'Impossible de se connecter � la nouvelle base de donn�es.');
      Result := TDOSS_NEWDBCONNECTFAILED;
      cDest.Free;
      ChangeEtatEcran(lAide, lCreation, f, True);
      // D�blocage
      Bloqueur('CreationDossier', False);
      exit;
    end;

    // #### Avant ExecuteSQLDB, v�rifier V_PGI.Driver et .ODBC sont positionn�s
    // car ExecuteSQLDB ne le fait pas...

    // Correspondance forme juridique
    sForme := '';
    if TobAnn.FieldExists('ANN_FORME') then
    begin
      Q := OpenSQL('select JFJ_CODEDP from JUFORMEJUR where JFJ_FORME="'+TobAnn.GetValue('ANN_FORME')+'"', TRUE,-1, '', True);
      if Q.eof then
        sForme := ''
      else
        sForme := Q.FindField('JFJ_CODEDP').AsString;
      Ferme (Q);
    end;

    // Param�tres soci�t�
    SQLSociete := 'UPDATE SOCIETE SET SO_SOCIETE="001"';
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="001" WHERE SOC_NOM="SO_SOCIETE"', DBDest);
    // Nom
    st := '';
    // Personne physique :
    if (TobAnn.FieldExists('ANN_CVA') and TobAnn.FieldExists('ANN_PPPM') and (TobAnn.GetValue('ANN_PPPM')='PP')) then
      st := TobAnn.GetValue('ANN_CVA') + ' '; // pr�fixe par la civilit� ou le type de soci�t�
    // #### mais sinon il faudrait r�cup�rer le type de soci�t� ? (formejur ?)
    st := Trim ( st + TobAnn.GetValue('ANN_NOM1') );
    if TobAnn.FieldExists('ANN_NOM2') then
      st := Trim ( st + ' ' + TobAnn.GetValue('ANN_NOM2') );
    EntreCote(st, False);
    SQLSociete := SQLSociete + ', SO_LIBELLE="' + Copy(st,1,35) + '"';
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + Copy(st,1,70) + '" WHERE SOC_NOM="SO_LIBELLE"', DBDest);
    // Adresse 1
    if TobAnn.FieldExists('ANN_ALRUE1') then
    begin
      st := TobAnn.GetValue('ANN_ALRUE1');
      EntreCote(st, False);
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + st + '" WHERE SOC_NOM="SO_ADRESSE1"', DBDest);
      SQLSociete := SQLSociete + ', SO_ADRESSE1="' + st + '"';
    end;
    // Adresse 2
    if TobAnn.FieldExists('ANN_ALRUE2') then
    begin
      st := TobAnn.GetValue('ANN_ALRUE2');
      EntreCote(st, False);
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + st + '" WHERE SOC_NOM="SO_ADRESSE2"', DBDest);
      SQLSociete := SQLSociete + ', SO_ADRESSE2="' + st + '"';
    end;
    // Adresse 3
    if TobAnn.FieldExists('ANN_ALRUE3') then
    begin
      st := TobAnn.GetValue('ANN_ALRUE3');
      EntreCote(st, False);
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + st + '" WHERE SOC_NOM="SO_ADRESSE3"', DBDest);
      SQLSociete := SQLSociete + ', SO_ADRESSE3="' + st + '"';
    end;
    // APE
    if TobAnn.FieldExists('ANN_CODENAF') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_CODENAF') + '" WHERE SOC_NOM="SO_APE"', DBDest);
      SQLSociete := SQLSociete + ', SO_APE="' + TobAnn.GetValue('ANN_CODENAF') + '"';
    end;
    // Capital
    if TobAnn.FieldExists('ANN_CAPITAL') then
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + StrfPoint(TobAnn.GetValue('ANN_CAPITAL')) + '" where SOC_NOM="SO_CAPITAL" ', DBDest);
    // Code postal
    if TobAnn.FieldExists('ANN_ALCP') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_ALCP') + '" WHERE SOC_NOM="SO_CODEPOSTAL"', DBDest);
      SQLSociete := SQLSociete + ', SO_CODEPOSTAL="' + TobAnn.GetValue('ANN_ALCP') + '"';
    end;
    // #### Contact : r�cup�rer le contact principal ? ou bien ANN_PERASS1GUID ?
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" WHERE SOC_NOM="SO_CONTACT"', DBDest); //#### en attendant on r�init
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" WHERE SOC_NOM="SO_DIVTERRIT"', DBDest); //#### en attendant on r�init
    // Fax
    if TobAnn.FieldExists('ANN_ALFAX') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_FAX') + '" WHERE SOC_NOM="SO_FAX"', DBDest);
      SQLSociete := SQLSociete + ', SO_FAX="' + TobAnn.GetValue('ANN_FAX') + '"';
    end;
    // Email
    if TobAnn.FieldExists('ANN_EMAIL') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_EMAIL') + '" WHERE SOC_NOM="SO_MAIL"', DBDest);
      SQLSociete := SQLSociete + ', SO_MAIL="' + Copy(TobAnn.GetValue('ANN_EMAIL'), 1, 35) + '"';
    end;
    // Forme : correspondance pour tablette TTFORMEJURIDIQUE
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="'+sForme+'" WHERE SOC_NOM="SO_NATUREJURIDIQUE"', DBDest);
    // #### doit-on mettre � jour SO_TXTJURIDIQUE dans la table SOCIETE ?
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" WHERE SOC_NOM="SO_TXTJURIDIQUE"', DBDest);
    // #### SO_NIF = No d'Immatriculation Fiscale
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" WHERE SOC_NOM="SO_NIF"', DBDest);
    // Pays
    if TobAnn.FieldExists('ANN_PAYS') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_PAYS') + '" WHERE SOC_NOM="SO_PAYS"', DBDest);
      SQLSociete := SQLSociete + ', SO_PAYS="' + TobAnn.GetValue('ANN_PAYS') + '"';
    end;
    // Ville RCS
    if TobAnn.FieldExists('ANN_RCSVILLE') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_RCSVILLE') + '" WHERE SOC_NOM="SO_RC"', DBDest);
      SQLSociete := SQLSociete + ', SO_RC="' + Copy(TobAnn.GetValue('ANN_RCSVILLE'), 1, 17) + '"';
    end;
    // #### SO_RVA = R�seau � valeur ajout�e (g�n�ralement le site Web)
    ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" WHERE SOC_NOM="SO_RVA"', DBDest);
    // Siret
    if (TobAnn.FieldExists('ANN_SIREN')) and (TobAnn.FieldExists('ANN_CLESIRET')) then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_SIREN') + TobAnn.GetValue('ANN_CLESIRET') + '" WHERE SOC_NOM="SO_SIRET"', DBDest);
      SQLSociete := SQLSociete + ', SO_SIRET="' + TobAnn.GetValue('ANN_SIREN') + TobAnn.GetValue('ANN_CLESIRET') + '"';
    end;
    // Telephone
    if TobAnn.FieldExists('ANN_TEL1') then
    begin
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + TobAnn.GetValue('ANN_TEL1') + '" WHERE SOC_NOM="SO_TELEPHONE"', DBDest);
      SQLSociete := SQLSociete + ', SO_TELEPHONE="' + TobAnn.GetValue('ANN_TEL1') + '"';
    end;
    // Ville
    if TobAnn.FieldExists('ANN_ALVILLE') then
    begin
      st := TobAnn.GetValue('ANN_ALVILLE');
      EntreCote(st, False);
      ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="' + st + '" WHERE SOC_NOM="SO_VILLE"', DBDest);
      SQLSociete := SQLSociete + ', SO_VILLE="' + st + '"';
    end;

    // Maj enreg societe car sera utilis� par InitEtablissement (!)
    ExecuteSQLDB(SQLSociete, DBDest);

    //#### en attendant assistants
    ExecuteSQLDB('UPDATE SOUCHE SET SH_SOCIETE="001"', DBDest);

    // Divers & fin
    DBDest.Connected := False;

{$IFNDEF SANSCOMPTA}
    // Cr�ation d'�tablissement
    // Attention : utilise les informations de la table SOCIETE, pas des PARAMSOC !
    InitEtablissement('DB' + NoDossier);
    if bInitEtabCompl then
    begin
      Q := OpenSQL('SELECT ET_ETABLISSEMENT, ET_LIBELLE FROM DB' + NoDossier + '.dbo.ETABLISS ORDER BY ET_ETABLISSEMENT', True,-1, '', True);
      if not Q.Eof then
        InitEtablissementCompl('DB' + NoDossier, Q.FindField('ET_ETABLISSEMENT').AsString, Q.FindField('ET_LIBELLE').AsString);
      Ferme(Q);
    end;
{$ENDIF SANSCOMPTA}

    // FQ BUR 11872
    InitTTFormeJuridique('DB'+NoDossier);

    // FQ BUR 11893
    ShrinkDatabaseMsSql('DB'+NoDossier);
  end

  // --- sauf si volontairement pas de cr�ation de la base dossier !
  else
    // on retourne "succ�s", c'est � l'appelant de savoir ce qu'il va faire sans base...
    Result := TDOSS_CREATIONOK;
  // --- Fin alimentation de la base dossier


  // D�blocage
  Bloqueur('CreationDossier', False);
  ChangeEtatEcran(lAide, lCreation, f, True);
  // pour conso :
  if cCree <> nil then CopyPGIConn(cDest, cCree);
  cDest.Free;

end;


function TCreedoss.CreeBaseDossier(lAide, lCreation: THLabel; f: TWinControl; NoDisq: Integer; NoDossier: string;
  var cDest: TPGIConn; AvecConfirm: Boolean = True; AutoAttach: Boolean = False): Integer;
// Les v�rifs "mono-utilisateur" via Bloqueur('CreationDossier'...) sont faites en amont
// cDest pass� en var sera rendu pr�t � se connecter � la base qu'on vient de cr�er
var
    sRepDossier, sRepMdf, sRepLdf: string;
    sFileMdf, sFileLdf : string;
    creadbok, copyok, attachok, detachok :boolean;
begin
  Result := TDOSS_CREATIONOK;

  sRepDossier := V_PGI.Partages[NoDisq];
  // r�pertoires locaux au serveur sql
  sRepMdf := V_PGI.PartagesLoc[NoDisq]+'\D'+NoDossier;
  if V_PGI.PartagesLog[NoDisq]='' then
    sRepLdf := sRepMdf
  else
    sRepLdf := V_PGI.PartagesLog[NoDisq]+'\D'+NoDossier; // ou GetParamsocDPSecur('SO_ENVDISK'+IntToStr(NoDisq)+'LOG', '');

  // v�rifications
  // (en mode local : partage = partagelocal)
  // (en mode serveur : partage = disque partag�, partagelocal = r�p. local au serveur, correspondant au partage)
  if sRepDossier = '' then
  begin
    ShowError(TDOSS_BADCEGIDENV, 'La valeur du partage Disk' + sRepDossier + ' n''est pas d�finie dans les param�tres communs');
    Result := TDOSS_BADCEGIDENV;
    exit; // laisse possibilit� de choisir un autre partage
  end;

  // --- V�rification ou cr�ation de la base MODELE
  lCreation.Caption := ' ';
  if not BaseModeleOK(lAide, lCreation) then
  begin
    ShowError(TDOSS_BADDBMODELE, 'La base mod�le permettant les cr�ations de dossier n''est pas utilisable.');
    Result := TDOSS_BADDBMODELE;
    exit;
  end;

  // --- Cr�ation base dossier par copie de la base mod�le
  lCreation.Caption := 'Cr�ation de la base dossier...';
  lAide.caption := ' ';

  //#### il va apparaitre ce $#*%* de sablier ?
  Delay(1000);

  // --- Cr�ation des sous-r�pertoires si absents
  // ExecuteMSSQL7 n'utilise pas ChangeSql et se connecte � la base master
  // mais on pourrait faire try ExecuteSql('exec master.dbo.xp_cmdshell "mkdir ..."') ...
  ExecuteMSSQL7('xp_cmdshell ''mkdir ' + sRepMdf + '''', False);
  ExecuteMSSQL7('xp_cmdshell ''mkdir ' + sRepLdf + '''', False);

  // DRIVER NON SUPPORTE
  if (V_PGI.Driver<>dbMSSQL) and (V_PGI.Driver<>dbMSSQL2005) then
  begin
    ShowError(TDOSS_DRIVERNOTSUPPORTED, 'Impossible de cr�er la base dossier car le type de driver n''est pas support� en multi-dossier.');
    Result := TDOSS_DRIVERNOTSUPPORTED;
    exit;
  end;

  cDest := CreePGIConn('DB' + NoDossier);
  cDest.Societe := '###DESTINATION###'; // pour info !
  cDest.Dir := sRepDossier + '\D' + NoDossier;

  // chemins vus du serveur
  sFileMdf := sRepMdf + '\DB' + NoDossier + '.mdf';
  sFileLdf := sRepLdf + '\DB' + NoDossier + '.ldf';

  // v�rification minimum : existence base mod�le
  // $$$ JP 15/03/07: d�plac� dans CreeDossier, car il faut aussi v�rifier m�me si on veut un dossier sans base...

  // utilisation de la base mod�le
  // $$$ JP 06/12/05 - warning delphi (inutile) -> creadbok := False;
  // d�tachement base indispensable pour la copie
  DBSetAutoClose ('DBMODELE',False);
  detachok := DetachDbRemetDroits('DBMODELE', VH_DP.PathDatLoc, VH_DP.PathDatLoc, False);
  if not detachok then detachok := RepeterAction(f, 'DetachDbRemetDroits', 'Attente disponibilit� de la base mod�le...', 'DBMODELE;'+VH_DP.PathDatLoc+';'+VH_DP.PathDatLoc);
  if not detachok then
  begin
    ShowError(TDOSS_DBMODELEBUSY, 'La base mod�le n''est pas accessible. R�essayez ult�rieurement.');
    Result := TDOSS_DBMODELEBUSY;
    FreeAndNil(cDest);
    exit;
  end;

  // Copie base mod�le #### � remplacer par un backup / restore comme en Web Access ?
  // xp_cmdshell pour copier sans passer par poste client
  // (ExecuteMsSql7 n'utilise pas ChangeSql et se connecte � la master)
  copyok := ExecuteMSSQL7('xp_cmdshell ''copy '+VH_DP.PathDatLoc+'\DBMODELE.mdf '+sFileMdf+'''', False);
  // le pb : si la copie �choue, �a ne remonte pas d'erreur, car xp_cmdshell a "fonctionn�"
  if not copyok then
    copyok := RepeterAction(f, 'ExecuteMSSQL7', 'Attente fin copie de la base mod�le...', 'xp_cmdshell ''copy '+VH_DP.PathDatLoc+'\DBMODELE.mdf '+sFileMdf+'''');
  if not copyok then
  begin
    ShowError(TDOSS_CANTCOPYDBMODELE, 'La base mod�le n''a pas pu �tre copi�e. R�essayez ult�rieurement.');
    Result := TDOSS_CANTCOPYDBMODELE;
    FreeAndNil(cDest);
    exit;
  end;
  copyok := ExecuteMSSQL7('xp_cmdshell ''copy '+VH_DP.PathDatLoc+'\DBMODELE.ldf '+sFileLdf+'''', False);
  if not copyok then
    copyok := RepeterAction(f, 'ExecuteMSSQL7', 'Attente fin copie du log de la base mod�le...', 'xp_cmdshell ''copy '+VH_DP.PathDatLoc+'\DBMODELE.ldf '+sFileLdf+'''');
  if not copyok then
  begin
    ShowError(TDOSS_CANTCOPYLOGDBMODELE, 'Le journal de la base mod�le n''a pas pu �tre copi�. R�essayez ult�rieurement.');
    Result := TDOSS_CANTCOPYLOGDBMODELE;
    FreeAndNil(cDest);
    exit;
  end;

  // r�attacher base mod�le
  attachok := AttacherBaseSqlAutoclose('DBMODELE', VH_DP.PathDatLoc+'\DBMODELE.MDF', VH_DP.PathDatLoc+'\DBMODELE.LDF');
  if not attachok then attachok := RepeterAction(f, 'AttacherBaseSqlAutoclose', 'Attente r�attachement de la base mod�le...', 'DBMODELE;' + VH_DP.PathDatLoc + '\DBMODELE.MDF;' + VH_DP.PathDatLoc + '\DBMODELE.LDF');
  if not attachok then
  begin
    ShowError(TDOSS_CANTREATTACHDBMODELE, 'La base mod�le n''a pas pu �tre r�attach�e. R�essayez ult�rieurement.');
    // mais erreur non bloquante !
    // Result := TDOSS_CANTREATTACHDBMODELE;
    // FreeAndNil(cDest);
    // exit;
  end;

  // attacher nouvelle base
  creadbok := AttacherBaseSqlAutoclose('DB'+NoDossier, sFileMdf, sFileLdf);

  if not creadbok then Result := TDOSS_CANTCREATENEWDB;
end;


procedure TCreeDoss.InitialiseSoc(cDest: TPGIConn; lAide: THLabel);
// si utilis�e seule, ne pas oublier de d�connecter le TCreeDoss.DBDest
// pour lib�rer la connexion sur la base aliment�e
var StLibTable, StTable, Prefixe, Commun: string;
  T: THTable;
  Nb: integer;
  Val: Variant;
  Q, QDest, QRef: TQuery;
  Entete, LLigne: THTable;
begin
  // Connecte la source
  if not DBRef.Connected then ConnecteDB('Reference', DBRef, 'DBREF');
  V_PGI.Driver := V_PGI.RefDriver;
  V_PGI.ODBC := V_PGI.RefODBC;
  Entete := THTable.Create(Appli);
  Entete.DatabaseName := DBRef.DatabaseName;
  Entete.TableName := 'DETABLES';
  Entete.IndexName := 'DT_CLE1';
  Entete.Open;
  LLigne := THTable.Create(Appli);
  LLigne.DatabaseName := DBRef.DatabaseName;
  LLigne.TableName := 'DECHAMPS';
  LLigne.IndexName := 'DH_CLE1';
  LLigne.Open;
  // Connecte la destination (d�j� fait dans un try)
  if not DBDest.Connected then ConnecteLeDB(DBDest, 'DBDEST', cDest);
  // R�tablissement
  V_PGI.Driver := DestDriver; V_PGI.ODBC := DestODBC;

  // Identifie les tables de type 'standard' non DP
  // = contenant un champ PREDEFINI mais non top�es S
  // (car sinon inutiles dans une base dossier !)
  Q := OpenSQLDB(DBRef, 'SELECT DT_NOMTABLE FROM DECHAMPS LEFT JOIN DETABLES ON DT_PREFIXE=DH_PREFIXE WHERE DH_NOMCHAMP LIKE "%_PREDEFINI" AND DT_COMMUN="-"', True,-1, '', True);
  while not Q.Eof do
  begin
    RempliStandards.Add(Q.FindField('DT_NOMTABLE').AsString);
    Q.Next;
  end;
  Ferme(Q);
  // Ici, on devrait retirer de RempliDefaut toutes les tables de type DP
  // mais bon c'est trait� dans la boucle While Not Entete.eof (tests sur Commun)...
  RempliDefaut.Add('AXE');
  RempliDefaut.Add('CHOIXCOD');
  RempliDefaut.Add('CHOIXEXT');
  RempliDefaut.Add('CODEPOST');
  // #### DP RempliDefaut.Add('COMMUN');
  RempliDefaut.Add('DECHAMPS');
  RempliDefaut.Add('DECOMBOS');
  RempliDefaut.Add('DELIENS');
  RempliDefaut.Add('DETABLES');
  RempliDefaut.Add('DEVISE');
  RempliDefaut.Add('DEVUES');
  RempliDefaut.Add('LISTE');
  RempliDefaut.Add('MENU');
  RempliDefaut.Add('MODEDATA');
  RempliDefaut.Add('MODELES');
  RempliDefaut.Add('MODEPAIE');
  RempliDefaut.Add('MODEREGL');
  RempliDefaut.Add('PARPIECE');
  RempliDefaut.Add('PARAMSOC');
  RempliDefaut.Add('PARAMLIB'); // 18/09/02
  RempliDefaut.Add('PAYS');
  RempliDefaut.Add('SOUCHE');
  RempliDefaut.Add('TRADUC');
  // #### manquerait TRADDICO...

  // Cr�e toutes les tables
  Nb := 1;
  Q := OpenSQL('SELECT COUNT(*) FROM DETABLES', True,-1, '', True);
  if not Q.Eof then Nb := Q.Fields[0].AsInteger; ; // pour la barre d'avancement
  Ferme(Q);
  Initmove(Nb, '');
  Entete.First;
  // traite m�me les tables de versions < 100
  while not Entete.EOF do
  begin
    StLibTable := Entete.FindField('DT_LIBELLE').AsString;
    StTable := Entete.FindField('DT_NOMTABLE').AsString;
    Commun := Entete.FindField('DT_COMMUN').AsString;
    lAide.Caption := 'Cr�ation de la table : ' + StLibTable;
    Application.ProcessMessages;
    Prefixe := Entete.FindField('DT_PREFIXE').AsString;
    LLigne.SetRange([Prefixe, 000], [Prefixe, 9999]);
    DBCreateTable(DBDest, Entete, LLigne, DestDriver, False);
    // en access, on d�connecte/reconnecte (viva access !)
    if DestDriver = dbMSACCESS then ConnecteTRUEFALSE(DBDest);
    if (DestDriver<>dbMSSQL) and (DestDriver<>dbMSSQL2005) then DBDest.StartTransaction;

    // Alimentations
    if StTable = 'DESHARE' then
    begin
      CopieDeShare ;
      // FQ GIGA 14547
      ExecuteSQLDB('UPDATE DESHARE SET DS_NOMTABLE="YPARAMEDITION" WHERE DS_NOMTABLE="YHISTOPRINT"', DBDest);
    end
    else
    // - en MONO (pour conso), on fait une base mod�le avec toutes les tables
    // - en MULTI, �limine les tables communes, car on cr�e un dossier, mais...
    // #### ... on ne peut pas tester TableSurAutreBase(StTable) car toujours False sur la base commune !
    // donc on continue � tester DT_COMMUN (qui n'est pas forc�ment en phase avec deshare, ex: dossappli)
      if (VH_DP.ModeFonc <> 'DB0') or ((Commun <> 'D') and (Commun <> 'S')) then
      begin
        lAide.Caption := 'R�cup�re les donn�es de la table : ' + StLibTable + ' (' + StTable + ')';
        Application.ProcessMessages;

        // - alim depuis la base commune
        if False then // #### pas utilis�
        begin
          DBCopyTableBM(DBSOC, DBDest, StTable, StTable);
        end

        // - alim depuis la Reference
        else if (VH_DP.ModeFonc <> 'DB0')
          or ((RempliDefaut.IndexOf(StTable) > -1) and (RempliStandards.IndexOf(StTable) <= -1)) then
        begin
          DBCopyTableBM(DBRef, DBDest, StTable, StTable);
        end

        // - alim depuis la Ref, table de standards non DP : prend que les CEG
        else if (RempliStandards.IndexOf(StTable) > -1) then
        begin
          // suppression enreg CEG (mais inutile sur base mod�le car tjs recr��e)
          ExecuteSQLDB('DELETE FROM ' + StTable + ' WHERE ' + Prefixe + '_PREDEFINI="CEG"', DBDest);
          // Recopie des enreg dans la table temporaire (DBRef et DBDest connect�s au d�but)
          QRef := OpenSQLDB(DBRef, 'SELECT * FROM ' + StTable + ' WHERE ' + Prefixe + '_PREDEFINI="CEG"', True);
          QDest := OpenSQLDB(DBDest, 'SELECT * FROM ' + StTable + ' WHERE ' + Prefixe + '_PREDEFINI="CEG"', False);
          while not QRef.EOF do
          begin
            AddParam(QDest, QRef);
            QRef.Next;
          end;
          Ferme(QRef); Ferme(QDest);
        end;
      end;
      // fin alimentations
    if (DestDriver<>dbMSSQL) and (DestDriver<>dbMSSQL2005) then DBDest.Commit;
    Entete.Next;
    MoveCur(False);
  end;
  Entete.Close;
  Entete.Free;
  LLigne.Close;
  LLigne.Free;

  // FQ 11405 - Traitement sp�cifique des menus d�vers�s
  ExecuteSQLDB('UPDATE MENU SET MN_ACCESGRP="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", '
                             + 'MN_VERSIONDEV="-" WHERE MN_VERSIONDEV="X"', DBDest);
  // Cr�ation des vues
  // #### on n'est pas connect� � la base destination, donc on utilise les caract�ristiques
  // #### de la base en cours : heureusement que DeShare est remplie sur la base commune !!!
  DBCreateAllView(DBDest, lAide, DestDriver);

  // Mise � jour des PARAMSOC
  lAide.Caption := 'Mise � jour des param�tres SOCIETE';
  Application.ProcessMessages;
  // R�cup version de la socref, le DBRef est connect� au d�but
  Val := '';
  RecupChpDB(DBRef, 'SOCIETE', 'SO_VERSIONBASE', '', Val);
  // Maj no de version dans table SOCIETE
  T := THTable.Create(Appli);
  T.DataBaseName := DBDest.DataBaseName;
  T.TableName := 'SOCIETE'; T.IndexName := 'SO_CLE1';
  T.Open; T.Insert; InitNew(T);
  T.FindField('SO_VERSIONBASE').Value := Val;
  T.FindField('SO_SOCIETE').Value := '---';
  T.FindField('SO_LIBELLE').Value := 'BASE MODELE';
  if T.FieldDefs.IndexOf('SO_MODEFONC') > -1 then
    T.FindField('SO_MODEFONC').Value := VH_DP.ModeFonc;
  T.Post; T.Close;
  MoveCur(False);
  // Purge des paramsoc compta
  ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" where SOC_TREE LIKE "001;001;%"', DBDest);
  ExecuteSQLDB('UPDATE PARAMSOC SET SOC_DATA="" where SOC_NOM LIKE "SO_GCCPTE%" OR SOC_NOM LIKE "SO_CPTE%"', DBDest);
  // Param�tres minimums pour la compta
  T.TableName := 'PARAMSOC'; T.IndexName := 'SOC_CLE1'; T.Open;
  if T.FindKey(['SO_TAUXEURO']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 6.55957; T.Post; end;
  if T.FindKey(['SO_DECVALEUR']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 2; T.Post; end;
  if T.FindKey(['SO_DEVISEPRINC']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 'EUR'; T.Post; end;
  if T.FindKey(['SO_TENUEEURO']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := '-'; T.Post; end;
  if T.FindKey(['SO_DATEDEBUTEURO']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 36161; T.Post; end; // 1/1/99
  if T.FindKey(['SO_DATEBASCULE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 2; T.Post; end; // pas iDate1900 car pas bon !
  if T.FindKey(['SO_CPCONFORMEBOI']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := 'X'; T.Post; end; // FQ 20715 - CA - Conformit� BOI par d�faut

  //--- Pour la compta et les immo initialisation � vide des paramsoc
  if T.FindKey(['SO_CPTEAMORTINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEAMORTSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTECBINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTECBSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDEPOTINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDEPOTSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDEROGINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDEROGSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDOTEXCINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDOTEXCSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDOTINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEDOTSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEEXPLOITINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEEXPLOITSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEFININF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEFINSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEIMMOINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEIMMOSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTELOCINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTELOCSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEPROVDERINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEPROVDERSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEREPDERINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEREPDERSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEREPEXCINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEREPEXCSUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEVACEDEEINF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_CPTEVACEDEESUP']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEESCACH']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEESCVTE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEHTACH']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEHTVTE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEPORTACH']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEPORTVTE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEREMACH']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEREMVTE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTERGVTE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTESTOCK']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCPTEVARSTK']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_PGCPTNETAPAYER']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCFOUCPTADIFF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCLICPTADIFF']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCFOUCPTADIFFPART']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCLICPTADIFFPART']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCVRTINTERNE']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCCAISSGAL']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCECARTCREDIT']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;
  if T.FindKey(['SO_GCECARTDEBIT']) then begin T.Edit; T.FindField('SOC_DATA').AsVariant := ''; T.Post; end;

  T.Close;
  T.Free;
  FiniMove;
end;


function TCreeDoss.OpenSQLDB(DB: TDatabase; sSQL: string; RO: Boolean): TQuery;
var Q: TQuery;
// voir DBOpenSQL dans majtable !
begin
  // adapter driver pour le changesql
  if Copy(DB.DatabaseName, 1, 5) = 'DBREF' then
    begin V_PGI.Driver := V_PGI.RefDriver; V_PGI.ODBC := V_PGI.RefODBC; end;
  Q := TQuery.Create(Appli);
{$IFNDEF DBXPRESS}
  Q.DataBaseName := DB.DataBaseName;
{$ELSE}
  Q.SQLConnection := DB;
{$ENDIF}
  Q.SessionName := DB.SessionName;
  Q.SQL.Clear; Q.SQL.Add(sSQL);
  ChangeSQL(Q);
  Q.RequestLive := not RO;
  try
    Q.Open;
    Result := Q;
  except
    Result := nil;
  end;
  // r�tablissement
  V_PGI.Driver := DestDriver; V_PGI.ODBC := DestODBC;
end;


function TCreeDoss.RecupChpDB(DB: TDatabase; Fichier, Champ, Where: string; var Valeur: Variant): Boolean;
// utilisable qu'avec les TDatabase pr�sents et connect�s
var Q: TQuery;
  SQL: string;
begin
  Result := False;
  SQL := 'Select ' + Champ + ' from ' + Fichier + Where;
  Q := OpenSQLDB(DB, SQL, True);
  if Q <> nil then
  begin
    Result := (not Q.EOF);
    if not Q.Eof then Valeur := Q.Fields[0].Value;
    Ferme(Q);
  end;
end;


function TCreeDoss.RepeterAction(F: TWinControl; NomAction, TitreAction,
  Argums: string): Boolean;
// r�p�te une action avec fen�tre de progression
// les arguments string sont pass�s avec s�parateur ;
// sortie si clic annuler ou si l'action aboutit (l'action doit retourner True)
//     ou si plus de 100 occurences
var
    i: Integer;
    ShowErr: Boolean;
    args, DbName, sql : string;
    PathMdf, PathLdf : String;
    MdfFile, LdfFile : String;
begin
  Result := False;
  i := 1;
  InitMoveProgressForm(F, TitreAction, TitreHalley, 100, True, True);
  ShowErr := False;
  // r�cup des arguments
  args := Argums;
  if (NomAction = 'DetachDbRemetDroits') then
   begin
    DbName := ReadTokenSt(args);
    PathMdf := ReadTokenSt(args);
    PathLdf := ReadTokenSt(args);
   end
  else if (NomAction = 'AttacherBaseSqlAutoclose') then
   begin
    DbName := ReadTokenSt(args);
    MdfFile := ReadTokenSt(args);
    LdfFile := ReadTokenSt(args);
   end
  else if NomAction = 'ExecuteMSSQL7' then
    sql := args;
  // �x�cution des commandes
  while i <= 100 do
  begin
    if not MoveCurProgressForm then break; ;
    // derni�re occurrence : on affiche les msg
    if i = 100 then ShowErr := True;
    if NomAction = 'DetachDbRemetDroits' then
     begin
      DBSetAutoClose (DbName,False);
      Result := DetachDbRemetDroits(dbname, PathMdf, PathLdf, False);
     end
    else if NomAction = 'ExecuteMSSQL7' then
      Result := ExecuteMSSQL7(sql, ShowErr)
    else if NomAction = 'AttacherBaseSqlAutoclose' then
      Result := AttacherBaseSqlAutoclose(DbName, MdfFile, LdfFile);
    Application.ProcessMessages;
    if Result then break;
    i := i + 1;
  end;
  FiniMoveProgressForm;
end;


procedure TCreedoss.ShowError(Code: Integer; Txt: string);
begin
  if Assigned(OnInformation) then
    OnInformation(Self, Code, Txt)
  else
    PgiInfo(Txt, TitreHalley + ' (' + IntToStr(Code) + ')');
end;


procedure TCreedoss.CopieDeShare;
// inspir�e de MajDEShare de majstruc
var
  QRef, QDest: Tquery;
  db0: string;
begin
  if VH_DP.ModeFonc = '' then Exit;

  // pas de recopie si redirections personnalisables
  if VH_DP.ModeFonc = 'LIB' then Exit;

  if TableToNum('DESHARE') = 0 then exit;

  db0 := v_pgi.DefaultSectionDBName;
  if db0 = '' then db0 := V_PGI.DbName;

  // Recopie des enreg (DBRef et DBDest connect�s au d�but)
  try
    Qref := OpenSQLDB(DBRef, 'SELECT DS_NOMTABLE, DS_NOMBASE, DS_TYPTABLE FROM DESHARE'
      + ' WHERE DS_MODEFONC = "' + VH_DP.ModeFonc + '" ORDER BY DS_NOMTABLE', True);
    QDest := OpenSQLDB(DBDest, 'SELECT * FROM DESHARE', False);
    while not Qref.EOF do
    begin
      QDest.Insert;
      QDest.FindField('DS_NOMTABLE').Value := Qref.FindField('DS_NOMTABLE').AsString;
      QDest.FindField('DS_MODEFONC').Value := VH_DP.ModeFonc;
      if VH_DP.ModeFonc = 'DB0' then
        QDest.FindField('DS_NOMBASE').Value := db0
      else
        QDest.FindField('DS_NOMBASE').Value := QRef.FindField('DS_NOMBASE').AsString;
      QDest.FindField('DS_TYPTABLE').Value := QRef.FindField('DS_TYPTABLE').AsString;
      QDest.Post;
      QRef.Next;
    end;
    Ferme(QDest);
    Ferme(QRef);
  except
  end;
end;

{$ENDIF DP}
{$ENDIF EAGLCLIENT}



{ ------------- proc publiques ------------- }
{$IFNDEF EAGLCLIENT}
function BaseExiste(conn: TPGIConn): Boolean;
// teste l'existence � partir des param de l'objet de connexion fourni
// (donc permet de tester l'existence sur un autre serveur que celui de la DBSOC en cours)
var dbname: string;
begin
  Result := False;
  if conn.Driver = 'MSACCESS' then
    Result := FileExists(conn.Base)
  else if conn.Driver = 'INTRBASE' then
  begin
    dbname := ExtractFileName(conn.Server);
    Result := FileExists(conn.Dir + '\' + dbname);
  end
  else if (conn.Driver = 'ODBC_MSSQL') or (conn.Driver = 'ODBC_MSSQL2005') then
  begin
    Result := ExisteBaseMSSQL7(conn.Base, False, conn);
  end;
end;


function AttachDbAutoclose(DBname, MdfFile, LdfFile: string; ShowErr: Boolean = True;
  c: TPGIConn = nil; bWithoutLog: Boolean = False): Boolean;
// Effectue l'attache + mise en place option autoclose
begin
  // #### Attente Agl>7.0.20.14 pour passer les fichiers complets, dont le ldf, via AttachDbMSSQL
  // #### et aussi en profiter pour g�rer le _Log.ldf si existe en l'absence du .ldf ?
  // Result := AttachDbMSSQL7(DBName, Repert, ShowErr, c, bWithoutLog);
  // Result := AttachDbMSSQL(DBName, MdfFile, LdfFile, ShowErr, c, bWithoutLog);
  Result := ExecuteMSSQL7('sp_attach_db '+DBName+', '''+MdfFile+''', '''+LdfFile+'''', False, c);
  if Result then DbOptionMSSQL7(DBName, 'Autoclose', True, ShowErr, c);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 06/10/2006
Modifi� le ... : 23/04/2007
Description .. : Fonction de d�tachement de base qui sait :
Suite ........ : - r�attribuer les droits sur les fichiers dans le cas SQL2005
Suite ........ : - trouver le .ldf ou _log.ldf et standardiser son nom
Suite ........ :   et son emplacement
Suite ........ : - RepMdf / RepLdf : chemins vus du serveur sql
Mots clefs ... : 
*****************************************************************}
function  DetachDbRemetDroits(DBName, RepMdf, RepLdf: string; ShowErr: Boolean = True;
                            c: TPGIConn = nil): Boolean;
// Rq : en cas de passage d'un c: TPGIConn, on peut s'adresser � un autre serveur
var
    Q: TQuery;
    FichierLdfReel, FichierLdfVoulu : String;
    bRectifierLdf, bConnOk : Boolean;
    DB : TDatabase;
    OldDriver : TDBDriver;
    OldOdbc : Boolean;
    cBase, cMaster : TPGIConn;
begin
  Result := True;

  // Base d�j� d�tach�e
  if c=Nil then
  begin
       if Not DBExists(DBName) then exit;
  end
  else
  begin
       // Attention : impose que le TPGIConn repr�sente bien la base qu'on veut d�tacher !
       if Not BaseExiste(c) then exit;
  end;

  // Travail sur la connexion en cours (DB0)
  if (c=Nil) then
  begin
       // Travail direct sur DBSOC
       if (DBName<>V_PGI.DbName) then
           cBase := Nil
       // sauf si on veut d�tacher la base o� on est connect� !
       else
           cBase := CreePgiConn(DBName);
  end
  // Travail sur une connexion pr�cis�e en param�tre
  else
       cBase := c;

  // Travail sur la connexion en cours (DB0)
  if (cBase=Nil) then
  begin
       DB := DBSOC;
       bConnOk := True
  end
  // ou sur la base � d�tacher, mais dans ce cas on se connecte � la master du m�me serveur,
  // pour ne pas d�tacher une base sur laquelle on est connect�
  else
  begin
       bConnOk := False;
       DB := TDataBase.Create(Appli);
       OldDriver := V_PGI.Driver;
       OldOdbc   := V_PGI.Odbc;
       cMaster := TPGIConn.Create;
       CopyPGIConn(cBase, cMaster);
       cMaster.Base := 'master';
       try
          // cet appel modifie V_PGI.Driver et V_PGI.ODBC
          bConnOk := ConnecteDBSansIni(DB, 'master', cMaster);
       except
          DB := Nil;
       end;
  end;

  // R�cup. du chemin r�el du log (pour remettre le log sous un nom normalis�)
  bRectifierLdf := False;
  if (bConnOk) and (DB<>Nil) then
  begin
      // ne pas utiliser like "%LDF" car il y a des carac r�siduels apr�s LDF !
      Q := DBOpenSQL(DB, 'select filename from '+DBName+'.dbo.sysfiles where filename like "%LDF%"', V_PGI.Driver);
      If Not Q.Eof then FichierLdfReel := UpperCase(Trim(Q.FindField('filename').AsString));
      Ferme(Q);
      FichierLdfVoulu := UpperCase(RepLdf+'\'+DBName+'.LDF');
      if (FichierLdfReel<>'') and (FichierLdfReel<>FichierLdfVoulu) then
          bRectifierLdf := True;
      // Refermer la connexion sur l'autre base
      if (cBase<>Nil) then
      begin
           DB.Connected := False;
           DB.Free;
      end;
  end;

  // R�tablir les param�tres de connexion � la base en cours
  if cBase<>Nil then
  begin
       V_PGI.Driver := OldDriver;
       V_PGI.Odbc   := OldOdbc;
       cMaster.Free;
  end;

  // D�tachement
  Result := DetachDbMSSQL7(DBName, ShowErr, cBase);

  // Rectification du log sous forme normalis�e
  if Result and bRectifierLdf then
  begin
       ExecuteMSSQL7('xp_cmdshell ''del '+FichierLdfVoulu+'''', False, cBase);
       ExecuteMSSQL7('xp_cmdshell ''move '+FichierLdfReel+' '+FichierLdfVoulu+'''', False, cBase);
  end;

  // MD 06/10/06 - Sql2005 modifie les droits sur les fichiers � chaque attach
  // donc profitons du detach pour les remettre d'applomb
  if Result and (V_PGI.Driver=dbMSSQL2005) then
  begin
  {$IFDEF DP}
    //SL 14/11/2007 prise en compte des OS US
    if VH_DP.StrToutLeMonde<>'' then
    begin
      // ExecuteMsSql7 n'utilise pas ChangeSql et se connecte � la master, et sur un TPGIConn !
      ExecuteMSSQL7('xp_cmdshell ''cacls '+RepMdf+'\*.mdf /e /g "'+VH_DP.StrToutLeMonde+'":r''', False, cBase);
      ExecuteMSSQL7('xp_cmdshell ''cacls '+RepLdf+'\*.ldf /e /g "'+VH_DP.StrToutLeMonde+'":r''', False, cBase);
    end;
  {$ENDIF}
  end;
end;


{$IFDEF DP}
// SMA 131205 ajout parametre SansBase
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 20/02/2006
Modifi� le ... :   /  /    
Description .. : Cr�ation d'un dossier dans le premier partage disponible, 
Suite ........ : sans groupe de confidentialit�, 
Suite ........ : mais avec v�rif ou cr�ation dans l'annuaire
Mots clefs ... : 
*****************************************************************}
function ForceDossierExiste(nodoss: string; lAide, lCreation: THLabel;
  F: TWinControl; NoDisq: Integer; SansBase: Boolean = False): Boolean;
var
    Guidper  : String;
    nodisque : Integer;
    TOBAnn   : TOB;
    CreeDoss : TCreeDoss;
begin
  Result := False;
  if DossierExiste(nodoss) then
  begin Result := True; exit; end;

  // tob annuaire
  Guidper := ForcePersonneExiste(nodoss, 'EN COURS DE CREATION');
  TOBAnn := TOB.Create('ANNUAIRE', nil, -1);
  TOBAnn.SelectDB('"'+GuidPer+'"', nil, TRUE);

  // cr�ation du dossier
  CreeDoss := TCreeDoss.Create();
  // attention : le premier nodisq ok est 1 (pas 0)
  nodisque := NoDisq;
  if nodisque = 0 then nodisque := 1;
  //if CreeDoss.CreeDossier(TOBAnn, nodisque, nodoss, lAide, lCreation, F, True, False,
  //  '', True) = 0 then
  // SMA 131205 passage param�tre SansBase pour cr�ation dossier pour winner dans base PGI
  if CreeDoss.CreeDossier(TOBAnn, nodisque, nodoss, lAide, lCreation, F, True, False,
                          '', True, Nil, '', SansBase) = 0 then
    Result := True; // Base cr��e

  // --- Fin alimentation de la base
  TOBAnn.Free;
  CreeDoss.Free;
end;

function EstSQLetLocaletSuperviseur(LocalOkSiDayPass: Boolean = False): Boolean;
var okqdmeme: Boolean;
begin
  Result := False;
  // Permet d'autoriser un traitement "local" m�me si le share est un chemin UNC
  // au lieu d'un chemin local, d�s lors que le nom de machine est le m�me !
  okqdmeme := (VH_DP.LeServeur = GetNomComputer);

  if (V_PGI.Driver<>dbMSSQL) and (V_PGI.Driver<>dbMSSQL2005) then
  begin PGIInfo('Ce traitement n''est possible qu''en MSSQLServer !', TitreHalley); exit; end;
  // quand doit-on tester local...
  if not (LocalOkSiDayPass and (V_PGI.Password = CryptageSt(DayPass(Date)))) then
  begin
    if (VH_DP.LeMode <> 'L') and (not okqdmeme) then // force 18/02/02
    begin
      PGIInfo('Vous �tes connect� � une soci�t� r�seau.' + #13 + #10
        + ' Ce traitement n''est possible que sur une soci�t� locale !', TitreHalley);
      exit;
    end;
  end;
  if IsSuperviseur(True) then
    Result := True;
end;
{$ENDIF DP}

function CreePgiConn(nombase: string): TPGIConn;
// Compatible Sql Server uniquement
begin
  Result := TPGIConn.Create;
  Result.Share := V_PGI.Share;
  Result.Dir := V_PGI.DatPath;
  if V_PGI.Driver=dbMsSql2005 then
    Result.Driver := 'ODBC_MSSQL2005'
  else
    Result.Driver := 'ODBC_MSSQL';
  Result.Base     := nombase;
  Result.Path     := '';
{$IFDEF DBXADO}
  Result.Server   := DBSOC.Params.Values['HostName'];
  Result.ODBC     := 'Microsoft OLEDB Driver';
  Result.User     := DBSOC.Params.Values['User_name'];
  Result.Password := DBSOC.Params.Values['Password'];
  // MD-PJM 16/11/06 - D�sactivation du connection pooling
  // sinon op�rations de maintenances impossibles sur les bases ("in use")
  Result.Options  := '*OLE DB Services=-4';
{$ELSE}
  Result.Server   := DBSOC.Params.Values['ODBC DSN'];
  Result.ODBC     := 'SQL Server';
  Result.User     := DBSOC.Params.Values['USER NAME'];
  Result.Password := DBSOC.Params.Values['PASSWORD'];
  Result.Options  := '';
{$ENDIF}
end;

procedure CopyPGIConn(cSrc, cDest: TPGIConn);
// copie tout l'objet sauf prop. Societe (identifiant)
begin
  cDest.Share := cSrc.Share;
  cDest.Dir := cSrc.Dir;
  cDest.Driver := cSrc.Driver;
  cDest.Server := cSrc.Server;
  cDest.Path := cSrc.Path;
  cDest.ODBC := cSrc.ODBC;
  cDest.Base := cSrc.Base;
  cDest.Options := cSrc.Options;
  cDest.User := cSrc.User;
  cDest.Password := cSrc.PassWord;
end;

function ConnecteDBSansIni(var DB: TDataBase; Nom: string; conn: TPGIConn; Exclusive: Boolean = false): Boolean;
var Driver: TDBDriver;
begin
  try
    if DB = nil then DB := TDataBase.Create(Appli);
    Driver := AssignDBParamsSansIni(DB, Nom, conn);
// {en EAGLCLIENT}
  {if DBSession<>Nil then
     BEGIN
     DB.SessionName:=DBSession.SessionName ;
     DB.DataBaseName:=DB.DataBaseName+DBSession.SessionName ;
     END ; }
    if (Driver <> dbMSACCESS) then exclusive := FALSE;
    DB.Exclusive := exclusive;
(*mcd 29/09/09 Tous les projets doivent �tre en 7.4 donc sans la directive et donccode caduque  
{$IFNDEF CBP74}
    if V_PGI.PrivateBDEDir <> '' then
      DB.Session.PrivateDir := V_PGI.PrivateBDEDir;
    if V_PGI.NetBDEDir <> '' then
      DB.Session.NetFileDir := V_PGI.NetBDEDir;
{$ENDIF}
*)

    DB.Connected := TRUE;

{$IFDEF eAGLServer}
//AFAIREAGL
{$ELSE}
    V_PGI.Driver := Driver;
{$ENDIF}

    MajOracleSession(DB);
    Result := TRUE;
  except
    on E: Exception do begin result := FALSE; PGIInfo(E.Message, 'Connexion'); end;
  end;
end;


{$ENDIF EAGLCLIENT}

function GetPathDossier(nodoss: string): string;
var
  nodisq: Integer;
  sPartage_l: string;
  Q: TQuery;
begin
  Result := '';

  Q := OpenSQL('SELECT DOS_NODISQUE FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"', True);
  if Q.Eof then begin Ferme(Q); exit; end;
  nodisq := Q.FindField('DOS_NODISQUE').AsInteger;
  Ferme(Q);

  // si integer non initialis� dans table, il peut valoir -1 ou 7123564...
  if (nodisq < 1) or (nodisq > 100) then exit;
{$IFDEF EAGLCLIENT}
  sPartage_l := GetParamSocSecur('SO_ENVDISK' + inttostr(nodisq), '');
{$ELSE}
  sPartage_l := V_PGI.Partages[nodisq];
{$ENDIF}
  if sPartage_l <> '' then
    Result := sPartage_l + '\D' + nodoss;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : P. BASSET
Cr�� le ...... : ??/??/????
Modifi� le ... : 14/11/2005
Description .. : IMPORTATION DES BOBS
Suite ........ : MODIF PB
Suite ........ : le case : case TestAGLIntegreBob(Chemin + sFileBOB) of
Suite ........ : devient
Suite ........ : case AGLIntegreBob(Chemin + sFileBOB) of
Suite ........ : CM : importation des .BOZ
Mots clefs ... :
*****************************************************************}
function PCL_IMPORT_BOB(CodeProduit: string; TypeBOZ: boolean = False; ForceChemin: String = ''): Integer;
var sFileImport : string;
    Chemin, Msg : string;
    SearchRec   : TSearchRec;
    NumVersion, ret, iCase_l : integer;
begin
  // LE NOM DES BOB SE COMPOSE DE
  // - Code Produit   XXXX
  // - Num version base 9999
  // - type de BOB (F:fiche,M:Menu,D:data);
  // - Num version 999
  // - extension .BOB
  // - exemple CCS50582F0001.BOB

  // CODE RETOUR DE LA FONCTION
  Result := 0;
  NumVersion  := 0;
  
  // MD 31/08/06 - Possibilit� de forcer le r�pertoire des bobs
  // pour importer les bobs d'une autre appli
  if ForceChemin='' then
    Chemin := IncludeTrailingBackSlash(TCBPPath.GetCegidDistriBob) + IncludeTrailingBackSlash(CodeProduit) //EX: C:\Program Files\CEGID\BOB\2035\
  else
    Chemin := IncludeTrailingBackSlash(ForceChemin);

  if TypeBOZ then
    ret := FindFirst(Chemin + CodeProduit + '*.BOZ', faAnyFile, SearchRec)
  else
    ret := FindFirst(Chemin + CodeProduit + '*.BOB', faAnyFile, SearchRec);

  Msg := '';
  while ret = 0 do
  begin
       //RECUPERE NOM DU BOB
       sFileImport := SearchRec.Name;

       //RECUPERE NUM VERSION
       try
          NumVersion := ValeurI(Copy(sFileImport, 5, 4));
       except
             Result := -6;
             exit;
       end;

       // MD 08/11/04 if NumVersion > V_PGI.NumVersionBase then
       // => remplac� par NumVersionSoc sinon risque pour un vieil exe
       // de remonter des bobs p�rim�s dans une base r�cente !!
    if NumVersion > V_PGI.NumVersionSoc then
    begin
      iCase_l := AglIntegreBob(Chemin + sFileImport, FALSE, TRUE);
      case iCase_l of
        0: // OK
          begin
            if V_PGI.SAV then Pgiinfo('Int�gration de : ' + sFileImport, TitreHalley);
            if copy(sFileImport, 9, 1) = 'M' then Result := 1; //SI BOB AVEC MENU, ON REND 1 POUR SORTIR DE L'APPLICATION
          end;
        1: if V_PGI.SAV then Msg := Msg + ' -> ' + sFileImport + #13#10;
        -1: // Erreur d'�criture dans la table YMYBOBS
          begin
            if V_PGI.SAV then PGIInfo('Erreur d''�criture dans la table YMYBOBS :' + Chemin + sFileImport, 'PCL_IMPORT_BOB');
          end;
        -2: // Erreur d'int�gration dans la fonction AglImportBob
          begin
            if V_PGI.SAV then PGIInfo('Erreur d''int�gration dans la fonction AglImportBob :' + Chemin + sFileImport, 'PCL_IMPORT_BOB');
          end;
        -3: //Erreur de lecture du fichier BOB.
          begin
            if V_PGI.SAV then PGIInfo('Erreur de lecture du fichier BOB :' + Chemin + sFileImport, 'PCL_IMPORT_BOB');
          end;
        -4: // Erreur inconnue.
          begin
            if V_PGI.SAV then PGIInfo('Erreur inconnue :' + Chemin + sFileImport, 'PCL_IMPORT_BOB');
          end;
      end;

    end;
    ret := FindNext(SearchRec);
  end;
  sysutils.FindClose(SearchRec);

  if Msg<>'' then
    begin
    Msg := 'Int�grations d�j� effectu�es : '+#13#10+Msg;
    if V_PGI.SAV then PGIInfo(Msg, TitreHalley);
    end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Pascal BASSET
Cr�� le ...... : 05/07/2004
Modifi� le ... : 05/07/2004
Description .. : Supprime les anciens bob de type:
Suite ........ : A (table)
Suite ........ : M (menu)
Suite ........ : F (fiche)
Suite ........ : sauf les type D (Data)
Mots clefs ... :
*****************************************************************}
procedure PCL_SUP_BOB(CodeProduit: string);
var sFileBOB: string;
  Chemin: string;
  SearchRec: TSearchRec;
  ret: integer;
begin
  // LE NOM DES BOB SE COMPOSE DE
  // - Code Produit   XXXX
  // - Num version base 9999
  // - type de BOB (F:fiche,M:Menu,D:data);
  // - Num version BOB 999
  // - extension .BOB
  // - exemple CCS50582F0001.BOB
  Chemin := IncludeTrailingBackSlash(TCBPPath.GetCegidDistriBob) + IncludeTrailingBackSlash(CodeProduit); //EX : C:\Program Files\CEGID\BOB\2035\
  ret := FindFirst(Chemin + CodeProduit + '*.BOB', faAnyFile, SearchRec);
  while ret = 0 do
  begin
       //RECUPERE NOM DU BOB
    sFileBOB := SearchRec.Name;
       {25610900A001.BOB}
    if Copy(sFileBOB, 9, 1) <> 'D' then
    begin
      DeleteFile(PChar(IncludeTrailingBackSlash(Chemin) + SFileBOB));
    end;
    ret := FindNext(SearchRec);
  end;
  sysutils.FindClose(SearchRec);
end;

procedure SynchroniseParamsoc(GuidPer: string);
// maj des paramsoc dans la base dossier en fonction des modifs tiers/annuaire
var
    TobAnn, TobEtab  : TOB;
    Q                : TQuery;
    sNoDossier, sNom, sForme, sSql : String;

    procedure MajParamSocDossier(NomParamsoc, Valeur: String);
    begin
       ExecuteSQL('UPDATE DB'+sNoDossier+'.dbo.PARAMSOC SET SOC_DATA="'+Valeur+'" WHERE SOC_NOM="'+NomParamsoc+'"');
    end;

begin
  if GuidPer = '' then exit;

  // valable uniquement en connexion � la base commune (qui h�berge l'annuaire)
  if (V_PGI.DefaultSectionName <> '') and (V_PGI.DbName <> V_PGI.DefaultSectionDbName) then exit;

  // recherche du dossier correspondant au code personne
  // on est dans base 'DP' (synchro utilis�e par DP/Juri/GI)
  Q := OpenSQL('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_GUIDPER="' + GuidPer
    + '" AND DOS_VERROU<>"PAR"', True);
  sNoDossier := '';
  if not Q.Eof then sNoDossier := Q.FindField('DOS_NODOSSIER').AsString;
  Ferme(Q);

  // pas de dossier correspondant � cette personne
  if sNoDossier = '' then exit;

  // tob annuaire
  TobAnn := TOB.Create('ANNUAIRE', nil, -1);
  TobAnn.SelectDB('"'+GuidPer+'"', nil, TRUE);
  if TobAnn = nil then begin TobAnn.free; exit; end;

  // mise � jour du nom du dossier
  if (V_PGI.DefaultSectionName = '') or (V_PGI.DbName = V_PGI.DefaultSectionDbName) then
    ExecuteSQL('UPDATE DOSSIER SET DOS_LIBELLE="' + TobAnn.GetValue('ANN_NOM1') + '"'
      + ' WHERE DOS_NODOSSIER="' + sNoDossier + '"');

  // maj � faire dans la base dossier, par DBxxxx.dbo.nomtable
  if ( (V_PGI.Driver<>dbMSSQL) and (V_PGI.Driver<>dbMSSQL2005) )
  // dossier sans base de production : rien d'autre � mettre � jour
  or ( not DBExists ('DB' + sNoDossier) ) then
    begin TobAnn.Free; exit; end;

  // Correspondance forme juridique
  Q := OpenSQL('select JFJ_CODEDP from JUFORMEJUR where JFJ_FORME="'+TobAnn.GetValue('ANN_FORME')+'"', TRUE);
  if Q.eof then
    sForme := ''
  else
    sForme := Q.FindField('JFJ_CODEDP').AsString;
  Ferme (Q);

  // Param�tres soci�t�
  if TobAnn.GetValue('ANN_PPPM') = 'PP' then // si personne physique
    sNom := TobAnn.GetValue('ANN_CVA') + ' '; // pr�fixe par la civilit�
  // #### mais sinon il faudrait r�cup�rer le type de soci�t� ? (formejur ?)
  sNom := Trim ( sNom + TobAnn.GetValue('ANN_NOM1') + ' ' + TobAnn.GetValue('ANN_NOM2') );
  ExecuteSQL('UPDATE DB' + sNoDossier + '.dbo.SOCIETE SET SO_LIBELLE="' + Copy(sNom, 1, 35) + '"');
  MajParamSocDossier('SO_LIBELLE',          Copy(sNom, 1, 70));
  MajParamSocDossier('SO_ADRESSE1',         TobAnn.GetValue('ANN_ALRUE1'));
  MajParamSocDossier('SO_ADRESSE2',         TobAnn.GetValue('ANN_ALRUE2'));
  MajParamSocDossier('SO_ADRESSE3',         TobAnn.GetValue('ANN_ALRUE3'));
  MajParamSocDossier('SO_APE',              TobAnn.GetValue('ANN_CODENAF'));
  MajParamSocDossier('SO_CAPITAL',          StrfPoint(TobAnn.GetValue('ANN_CAPITAL')));
  MajParamSocDossier('SO_CODEPOSTAL',       TobAnn.GetValue('ANN_ALCP'));
  // R�cup�rer le contact principal ? ou bien ANN_PERASS1GUID ?
  // #### MajParamSocDossier('SO_CONTACT', ??);
  MajParamSocDossier('SO_FAX',              TobAnn.GetValue('ANN_FAX'));
  MajParamSocDossier('SO_MAIL',             TobAnn.GetValue('ANN_EMAIL'));
  MajParamSocDossier('SO_NATUREJURIDIQUE',  sForme);
  // #### Faut-il mettre � jour SO_TXTJURIDIQUE ?
  // #### SO_NIF = No d'Immatriculation Fiscale
  MajParamSocDossier('SO_PAYS',             TobAnn.GetValue('ANN_PAYS'));
  MajParamSocDossier('SO_RC',               TobAnn.GetValue('ANN_RCSVILLE'));
  // #### SO_RVA = R�seau � valeur ajout�e (g�n�ralement le site Web)
  MajParamSocDossier('SO_SIRET',            TobAnn.GetValue('ANN_SIREN')+TobAnn.GetValue('ANN_CLESIRET'));
  MajParamSocDossier('SO_TELEPHONE',        TobAnn.GetValue('ANN_TEL1'));
  MajParamSocDossier('SO_VILLE',            TobAnn.GetValue('ANN_ALVILLE'));

  // Mise � jour de l'�tablissement dans la base dossier (uniquement si il est unique)
  TobEtab := TOB.Create('ETABLISS', Nil, -1);
  TobEtab.LoadDetailFromSQL('select ET_ETABLISSEMENT from DB'+sNoDossier+'.dbo.ETABLISS');
  if TobEtab.Detail.Count = 1 then
    begin
    // Rq : MakeUpdateSql sera inutilisable car base d�port�e, donc on reconstruit le sql
    sSql := 'UPDATE DB'+sNoDossier+'.dbo.ETABLISS SET '
     + 'ET_LIBELLE="' +     Copy(sNom, 1, 35) + '",'
     + 'ET_ABREGE="' +      Copy(TobAnn.GetValue('ANN_NOMPER'), 1, 17) + '",'
     + 'ET_ADRESSE1="' +    TobAnn.GetValue('ANN_ALRUE1') + '",'
     + 'ET_ADRESSE2="' +    TobAnn.GetValue('ANN_ALRUE2') + '",'
     + 'ET_ADRESSE3="' +    TobAnn.GetValue('ANN_ALRUE3') + '",'
     + 'ET_CODEPOSTAL="' +  TobAnn.GetValue('ANN_ALCP') + '",'
     + 'ET_VILLE="' +       TobAnn.GetValue('ANN_ALVILLE') + '",'
     + 'ET_PAYS="' +        TobAnn.GetValue('ANN_PAYS') + '",'
     + 'ET_LANGUE="' +      TobAnn.GetValue('ANN_LANGUE') + '",'
     + 'ET_TELEPHONE="' +   TobAnn.GetValue('ANN_TEL1') + '",'
     + 'ET_TELEX="' +       TobAnn.GetValue('ANN_MINITEL') + '",'
     + 'ET_FAX="' +         TobAnn.GetValue('ANN_FAX') + '",'
     + 'ET_JURIDIQUE="' +   sForme + '",'
     + 'ET_EMAIL="' +       Copy(TobAnn.GetValue('ANN_EMAIL'),1,128) + '",'
     + 'ET_SIRET="' +       TobAnn.GetValue('ANN_SIREN')+TobAnn.GetValue('ANN_CLESIRET') + '",'
     + 'ET_APE="' +         TobAnn.GetValue('ANN_CODENAF') + '",'

     + 'ET_VOIENOM="' +     TobAnn.GetValue('ANN_VOIENOM') + '",'              //+LM20071128
     + 'ET_VOIENO="' +      TobAnn.GetValue('ANN_VOIENO') + '",'
     + 'ET_VOIENOCOMPL="' + TobAnn.GetValue('ANN_VOIENOCOMPL') + '",'
     + 'ET_VOIETYPE="' +    TobAnn.GetValue('ANN_VOIETYPE') + '",'
     + 'ET_ALRESID="' +     TobAnn.GetValue('ANN_ALRESID') + '",'
     + 'ET_ALBAT="' +       TobAnn.GetValue('ANN_ALBAT') + '",'
     + 'ET_ALESC="' +       TobAnn.GetValue('ANN_ALESC') + '",'
     + 'ET_ALETA="' +       TobAnn.GetValue('ANN_ALETA') + '",'
     + 'ET_ALNOAPP="' +     TobAnn.GetValue('ANN_ALNOAPP') + '" '              //-LM20071128

     +' WHERE ET_ETABLISSEMENT="' + TobEtab.Detail[0].GetValue('ET_ETABLISSEMENT') + '"';
    try
      ExecuteSQl (sSql);
    except
      on E:Exception do PGIInfo('Erreur lors de la mise � jour de l''�tablissement#13#10 ('+E.Message+')', TitreHalley);
    end;
   end;
  TobEtab.Free;
  TobAnn.Free;
end;

procedure SetFlagAppli(sExeName: string; bFlag: Boolean);
// Met � jour l'indicateur "appli activ�e" dans la base commune
// Bien mettre le nom de l'appli sous la forme 'NOMAPPLI.EXE'
var
  nodoss: string;
begin
  // DOSSAPPLI est li�e � des dossiers, donc uniquement g�r�e en mode DB0
  if (GetModeFonc <> 'DB0') then exit;

  {if V_PGI.RunFromLanceur then
    nodoss := V_PGI.NoDossier
  else
    nodoss := VH_Doss.NoDossier;}
    // MD 23/05/07 - Plus coh�rent !
{$IFDEF BUREAU}
    nodoss := VH_Doss.NoDossier;
{$ELSE}
    nodoss := V_PGI.NoDossier;
{$ENDIF}

  SetFlagAppliDossier(sExeName, nodoss, bFlag);
end;


{***********A.G.L.***********************************************
Auteur  ...... : C.Mali�
Cr�� le ...... : 18/11/2005
Modifi� le ... :   /  /
Description .. : Passage par une tob
Mots clefs ... : 
*****************************************************************}
procedure SetFlagAppliDossier(sExeName, sNoDossier: string; bFlag: Boolean);
var
  Q: string;
  TobDossAppli: TOB;
begin
  // DOSSAPPLI est li�e � des dossiers, donc uniquement g�r�e en mode DB0
  if (GetModeFonc <> 'DB0') then exit;

  if sNoDossier = '' then
  begin
    PGIInfo('Pas de dossier ou de soci�t� en cours.', TitreHalley);
    exit;
  end;

  // activation d'une application
  if bFlag then
  begin
    Q := 'SELECT * FROM ##DP##.DOSSAPPLI'
      + ' WHERE DAP_NODOSSIER="' + sNoDossier + '"'
      + ' AND DAP_NOMEXEC="' + Uppercase(sExeName) + '"';
    TobDossAppli := Tob.Create('DOSSAPPLI', nil, -1);
    TobDossAppli.LoadDetailFromSQL(Q, FALSE, TRUE);
    if (TobDossAppli.Detail.Count = 0) then
    begin
      TobDossAppli.InitValeurs; 
      TobDossAppli.PutValue('DAP_NODOSSIER', sNoDossier);
      TobDossAppli.PutValue('DAP_NOMEXEC', UpperCase(sExeName));
      TobDossAppli.InsertOrUpdateDB;
    end;
    FreeAndNil(TobDossAppli);
  end
  else // d�sactivation
    ExecuteSql('DELETE FROM ##DP##.DOSSAPPLI'
      + ' WHERE DAP_NODOSSIER="' + sNoDossier + '"'
      + ' AND DAP_NOMEXEC="' + Uppercase(sExeName) + '"');
end;


function GetFlagAppli(sExeName: string): Boolean;
// Consulte l'indicateur "appli activ�e" dans la base commune
// Bien mettre le nom de l'appli sous la forme 'NOMAPPLI.EXE'
var Q: TQuery;
  nodoss: string;
begin
  Result := False;
  // DOSSAPPLI est li�e � des dossiers, donc uniquement g�r�e en mode DB0
  if (GetModeFonc <> 'DB0') then exit;

  {if V_PGI.RunFromLanceur then
    nodoss := V_PGI.NoDossier
  else
    nodoss := VH_Doss.NoDossier;}
    // MD 23/05/07 - Plus coh�rent !
{$IFDEF BUREAU}
    nodoss := VH_Doss.NoDossier;
{$ELSE}
    nodoss := V_PGI.NoDossier;
{$ENDIF}

  if nodoss = '' then
  begin
    PGIInfo('Pas de dossier ou de soci�t� en cours.', TitreHalley);
    exit;
  end;

  Q := OpenSQL('SELECT DAP_NOMEXEC FROM ##DP##.DOSSAPPLI WHERE DAP_NODOSSIER="' + nodoss
    + '" AND DAP_NOMEXEC="' + Uppercase(sExeName) + '"', True);
  if not Q.Eof then Result := True;
  Ferme(Q);
end;


procedure ChangeEtatEcran(lAide, lCreation: THLabel; f: TWinControl; etat: Boolean);
// Pratique pour les assistants...
begin
  // raz
  if etat then
  begin
    SourisNormale;
    lAide.Caption := '';
    lCreation.Caption := '';
  end
  // traitement
  else
    SourisSablier;
  EnableControls(f, etat);
  lAide.enabled := not etat;
  lCreation.enabled := not etat;
end;


function NouveauNoDossier(typincrem, nom: string): string;
// Calcule un nouveau num�ro de dossier
// plusieurs types d'incr�mentation du no de dossier :
// ALP = Alphab./num�rique
//  3c (1�res lettres des mots du nom) + 3c (no d'incr�ment si doublon)
// NUM = Num�rique
//  6c num�riques
// LIB = Libre, on ne renvoie rien
var
  QDos: TQuery;
  retour, entete, increm: string;
begin
  Result := '';
  // Libre
  if typincrem = 'LIB' then exit;

  // Num�rique
  if typincrem = 'NUM' then
  begin
       // $$$ JP 04/05/06 - FQ 10832: il faut prendre en compte que les n� dossier de forme num�rique
       // $$$ JP 16/05/06 - FQ 11061: il faut tenir compte du dernier �l�ment possible, pour ne pas le d�passer
       //     MD 05/04/07 - FQ 11316: conversion failed when converting the varchar value
       QDos := OpenSQL ('SELECT MAX(DOS1.DOS_NODOSSIER) FROM DOSSIER DOS1 WHERE ISNUMERIC(DOS1.DOS_NODOSSIER)=1 AND DOS1.DOS_NODOSSIER<>"999999" '
                      + 'AND NOT EXISTS (SELECT 1 FROM DOSSIER DOS2 WHERE ISNUMERIC(DOS1.DOS_NODOSSIER)=1 AND ISNUMERIC(DOS2.DOS_NODOSSIER)=1 AND CAST(DOS1.DOS_NODOSSIER AS INTEGER)+1=CAST(DOS2.DOS_NODOSSIER AS INTEGER))', TRUE);
       //QDos := OpenSQL ('SELECT MAX(DOS_NODOSSIER) FROM DOSSIER WHERE ISNUMERIC(DOS_NODOSSIER)<>0', TRUE); //', True);

       // d�finit un no de dossier de d�part
       if (not QDos.eof) and (not VarIsNull (QDos.Fields[0].Value)) then
           retour := QDos.Fields[0].AsString
       else
           retour := '000000';
       Ferme(QDos);

       // $$$ JP 04/05/06 - FQ 10832: forc�ment num�rique, la requ�te filtrant les non num�riques
       //if IsNumeric(retour) then
       Result := Format('%.6d', [StrToInt(retour) + 1])
       //else
       // impossible en num�rique, appel r�cursif en alpha
       //Result := NouveauNoDossier('ALP', nom);
  end

  // Alphab.&num. par d�faut
  else
  begin
    // calcul des 3c alphab.
    entete := TroisPremieresLettres(nom);
    // no maxi
    QDos := OpenSQL('SELECT MAX(DOS_NODOSSIER) FROM DOSSIER WHERE DOS_NODOSSIER LIKE "' + entete + '%"', True);
    // d�finit un no de dossier de d�part
    if (not QDos.eof) and (not VarIsNull(QDos.Fields[0].Value)) and (Length(QDos.Fields[0].AsString) > 3) then
      increm := Copy(QDos.Fields[0].AsString, 4, 3)
    else
      increm := '000';
    Ferme(QDos);
    if IsNumeric(increm) then
    begin
      // normalement, l'incr�ment est bien sur 3 carac.
      if Length(increm) < 3 then increm := Format('%.3d', [StrToInt(increm)]);
      Result := entete + Format('%.3d', [StrToInt(increm) + 1])
    end
    else
    begin
      // appel r�cursif en incr�mentant les carac. de d�but
      entete := Copy(entete, 1, 2) + Chr(Ord(entete[3]) + 1);
      Result := NouveauNoDossier('ALP', entete);
    end;
  end;
end;

procedure RajouteCaptionDossier(sTitre: string);
// Met � jour le titre de FMenuG � partir du titre demand�
// Le titre doit contenir le no+libell� du dossier en cours
// car il sera automatiquement rajout� sous la forme
// ' \ '+sTitre
var st: string;
  i: Integer;
begin
   // rechercher la chaine ' \ '
  st := FMenuG.Status.Caption;
  i := Pos(' \ ', st);
   // info existe, on ne garde que le d�but
  if i > 1 then st := Copy(FMenuG.Status.Caption, 1, i - 1);
   // rajoute le titre demand�
  FMenuG.Status.Caption := st + ' \ ' + sTitre;

   // si on voulait caption de l'appli : remplacer
   // FMenuG.Status.Caption par FMenuG.Caption
end;

procedure RajouteTitreForm(sTitre: string);
// voir RajouteCaptionDossier
var st: string;
  i: Integer;
begin
  if FMenuG.pTitre.Visible then
  begin
    st := FMenuG.pTitre.Caption;
    i := Pos(' \ ', FMenuG.pTitre.Caption);
    if i > 1 then st := Copy(FMenuG.pTitre.Caption, 1, i - 1);
    FMenuG.pTitre.Caption := st + ' \ ' + sTitre;
  end;
end;


procedure ListeVersCombo(listcod, listlib: TStringList; cb: THValComboBox; withTous: Boolean = FALSE);
// charge la combo avec les 2 string list (codes et libell�s)
// si listcod=nil, incr�mente les codes en integer depuis 1
// withTous permet d'ajouter la ligne <<Tous>> de code blanc
var i: Integer;
begin
  if withTous then
  begin
    cb.Values.Add('');
    cb.Items.Add('<<Tous>>');
  end;
  // code et libell�
  if listcod <> nil then
  begin
    if (listcod.Count > 0) and (listlib.Count > 0) then
      for i := 0 to Min(listcod.Count, listlib.Count) - 1 do
      begin
        cb.Values.Add(listcod[i]); // code
        cb.items.Add(listlib[i]); // libell�
      end;
  end
  // libell� seul
  else
  begin
    if (listlib.Count > 0) then
      for i := 0 to listlib.Count - 1 do
      begin
        cb.Values.Add(IntToStr(i + 1)); // code
        cb.items.Add(listlib[i]); // libell�
      end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : B. M�riaux
Cr�� le ...... : 01/06/2004
Modifi� le ... :   /  /
Description .. : charge la combo avec les 2 tableaux
Suite ........ : si aosCodes_p = nil, incr�mente les codes en integer depuis
Suite ........ : 1
Suite ........ : bAvecTous_p permet d'ajouter la ligne <<Tous>> de code
Suite ........ : blanc
Mots clefs ... :
*****************************************************************}
procedure TableauVersCombo(aosCodes_p, aosLibelles_p: array of string;
  cbCombo_p: THValComboBox; bAvecTous_p: Boolean = FALSE);
var
  iInd_l: Integer;
begin
  if bAvecTous_p then
  begin
    cbCombo_p.Values.Add('');
    cbCombo_p.Items.Add('<<Tous>>');
  end;
   // code et libell�
  if Length(aosCodes_p) <> 0 then
  begin
    if (Length(aosCodes_p) > 0) and (Length(aosLibelles_p) > 0) then
    begin
      for iInd_l := 0 to Min(Length(aosCodes_p), Length(aosLibelles_p)) - 1 do
      begin
        cbCombo_p.Values.Add(aosCodes_p[iInd_l]); // code
        cbCombo_p.items.Add(aosLibelles_p[iInd_l]); // libell�
      end;
    end;
  end
   // libell� seul
  else
  begin
    if (Length(aosLibelles_p) > 0) then
    begin
      for iInd_l := 0 to Length(aosLibelles_p) - 1 do
      begin
        cbCombo_p.Values.Add(IntToStr(iInd_l + 1)); // code
        cbCombo_p.items.Add(aosLibelles_p[iInd_l]); // libell�
      end;
    end;
  end;
end;


procedure ListeVersMultiValCombo(listlib: TStringList; mv: THMultiValComboBox);
// charge la multivalcombo avec un string list (en incr�mentant les codes)
var i: Integer;
begin
  // code et libell�
  if (listlib.Count > 0) then
    for i := 0 to listlib.Count - 1 do
    begin
      mv.Values.Add(IntToStr(i + 1)); // code
      mv.Items.Add(listlib[i]); // libell�
    end;
end;


procedure TobVersCombo(tobe: TOB; chp1, chp2: string; cb: THValComboBox);
// charge la combo avec les 2 champs de la TOB, en code et libell�
var i: Integer;
begin
  // si la tobe 'table' contient des enregistrements
  if tobe.Detail.count > 0 then
    // pour chaque tobe 'enregistrement', on charge la combo
    for i := 0 to tobe.Detail.count - 1 do
    begin
      cb.Values.Add(tobe.Detail[i].GetValue(chp1)); // code
      cb.items.Add(tobe.Detail[i].GetValue(chp2)); // libell�
    end;
end;

// charge la combo avec la liste des libell�s
{$IFDEF DP} // $$$ JP 02/01/06 - concerne � priori que le DP/Bureau
procedure PartagesVersCombo(cb: THValComboBox);
var
   i  :integer;
{$IFDEF EAGLCLIENT}
  ListeDisque :HTStringList;
{$ENDIF}
begin
     // $$$ JP 15/12/05 - il faut vider la combo d'abord
     cb.Clear;

{$IFDEF EAGLCLIENT}
     {$IFDEF BUREAU}
     // $$$ JP 15/12/05 - on r�cup�re la liste des disques � partir du serveur Cegid Pgi
     // #### donc inutilisable sans le plug in sCegidPgi
     if VH_DP.ePlugin <> nil then
     begin
          ListeDisque := HTStringList.Create;
          try
             if VH_DP.ePlugin.GetDisks (ListeDisque) = TRUE then
             begin
                  for i := 0 to ListeDisque.Count - 1 do
                  begin
                       //cb.Values.Add (IntToStr (i + 1));  // code
                       cb.items.Add  (ListeDisque [i]);   // libell�
                  end;
             end;
          finally
                 FreeAndNil (ListeDisque);
          end;
     end;
     {$ENDIF}
{$ELSE}
  for i := 1 to 8 do
  begin
    if V_PGI.Partages [i] = '' then
       exit;
    cb.Values.Add (IntToStr (i));    // code
    cb.items.Add  (V_PGI.Partages [i]); // libell�
  end;
{$ENDIF EAGLCLIENT}
end;
{$ENDIF DP}

procedure PartagesVersMultiValCombo(mv: THMultiValComboBox);
// charge la combo avec la liste des libell�s
var
{$IFDEF EAGLCLIENT}
  ListeDisque: TStringList;
{$ELSE}
  i: Integer;
{$ENDIF}
begin
{$IFDEF EAGLCLIENT}
  // #### A FAIRE EAGL 570c => rapatrier la liste des partages par un process serveur
  ListeDisque := TStringList.Create;
  // #### valeur bidon pour repr�senter des noms de partages
  ListeDisque.Add('DISK1');
  ListeVersMultiValCombo(ListeDisque, mv);
  ListeDisque.Free;
{$ELSE}
  for i := 1 to 8 do
  begin
    if V_PGI.Partages[i] = '' then exit;
    mv.Values.Add(IntToStr(i)); // code
    mv.items.Add(V_PGI.Partages[i]); // libell�
  end;
{$ENDIF}
end;


function PartageExiste(rep: string): Boolean;
{$IFNDEF EAGLCLIENT}
var
 i: Integer;
{$ENDIF}
begin
{$IFDEF EAGLCLIENT}
  // #### A FAIRE EAGL => seul le serveur sait si tel partage existe,
  // � moins d'un adressage indirect sur le n� de partage...
  Result := False;
{$ELSE}
  Result := False;
  for i := 1 to 8 do
    if UpperCase(V_PGI.Partages[i]) = UpperCase(rep) then begin Result := True; exit; end;
{$ENDIF}
end;

function CreeEnregDP(Prefixe, Table: string; GuidPer: string): Boolean;
var stChamp: string;
  Q: TQuery;
begin
  stChamp := Prefixe + '_GUIDPER';
  Q := OpenSQL('SELECT * FROM ' + Table + ' WHERE ' + stChamp + '= "' + GuidPer + '"', False);
  if Q.Eof then
  begin
    Q.Insert;
    InitNew(Q);
    Q.FindField(stChamp).AsString := GuidPer;
    Q.Post;
  end;
  Ferme(Q);
  result := True;
end;


function DateTjsCorrecte(sDate: string): TDateTime;
begin
  Result := iDate1900;
  if IsValidDate(sDate) then Result := StrToDate(sDate);
end;


function TroisPremieresLettres(nom: string): string;
var i: Integer;
  lstmots: TStringList;
  restenom, mot: string;
begin
  Result := 'AAA';
  if nom = '' then exit;
  Result := '';

    // recherche de mots
  restenom := Trim(ElimineCaracZarbi(nom, True));
  i := pos(' ', restenom);
  lstmots := TStringList.Create;
  while i > 1 do
  begin
    mot := Copy(trim(restenom), 1, i - 1);
    if MotSignifiant(mot) then lstmots.add(mot);
    restenom := Trim(Copy(restenom, i + 1, Length(Trim(restenom)) - i));
    i := pos(' ', restenom);
  end;
    // dernier mot
  if MotSignifiant(Trim(restenom)) then lstmots.add(Trim(restenom));

    // aucun mot signifiant=> on ajoute ce qu'on peut
  if lstmots.count = 0 then
  begin
    for i := 0 to Length(nom) do mot := mot + Trim(Copy(nom, i, 1));
    lstmots.add(mot);
  end;

    // selon le nb de mots
  case lstmots.count of
    1:
      begin
      // prend les 3 premiers carac
        Result := Copy(lstmots[0], 1, 3);
      // si trop peu, compl�te avec des A
        while Length(Result) < 3 do
          Result := Result + 'A';
      end;
    2:
      // 2 carac du premier, 1 carac du 2�me
      Result := Copy(lstmots[0], 1, 2) + Copy(lstmots[1], 1, 1);
  else
      // 1 carac de chaque
    Result := Copy(lstmots[0], 1, 1) + Copy(lstmots[1], 1, 1) + Copy(lstmots[2], 1, 1)
  end;
  lstmots.Free;
end;


function MotSignifiant(mot: string): Boolean;
// False si mot fait partie de la liste
begin
  Result := False;

  if mot = 'LE' then exit;
  if mot = 'LA' then exit;
  if mot = 'LES' then exit;
  if mot = 'DE' then exit;
  if mot = 'DES' then exit;
  if mot = 'DU' then exit;
  if mot = 'AU' then exit;
  if mot = 'A' then exit;

  if mot = 'ASS' then exit;
  if mot = 'EURL' then exit;
  if mot = 'GIE' then exit;
  if mot = 'SA' then exit;
  if mot = 'SARL' then exit;
  if mot = 'SCI' then exit;

  if mot = 'DR' then exit;
  if mot = 'MELLE' then exit;
  if mot = 'MLE' then exit;
  if mot = 'MME' then exit;
  if mot = 'MR' then exit;

  if mot = 'CCI' then exit;
  if mot = 'CDI' then exit;
  if mot = 'CFE' then exit;
  if mot = 'GTC' then exit;
  if mot = 'RCS' then exit;
  if mot = 'RDI' then exit;
  if mot = 'RM' then exit;

  Result := True;
end;


function ElimineCaracZarbi(nom: string; saufespaces: Boolean): string;
// passe en majuscules puis enl�ve tous les carac. autres que A � Z
// cas saufespaces : on laisse les espaces, et on transforme les tirets en espaces
var buf, carac: string;
  i: Integer;
begin
  Result := '';
  buf := Trim(nom);
  if Length(buf) = 0 then exit;
  for i := 1 to Length(buf) do
  begin
    carac := Uppercase(Copy(buf, i, 1));
    // valeur hors limites, on repart sur un incr�ment correct
    if (carac[1] in ['A'..'Z']) then
      Result := Result + carac
    else if (saufespaces) and ((carac = ' ') or (carac = '-')) then
      Result := Result + ' ';
  end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 23/01/2006
Modifi� le ... : 23/01/2006
Description .. : Est-ce que le user en cours appartient
Suite ........ : au groupe de travail demand�
Mots clefs ... : 
*****************************************************************}
function JaiLeDroitGroupeConf(GroupeConf: string): boolean;
begin
     // $$$ JP 13/10/2004 - un utilisateur "administrateur" n'a pas forc�ment le droit de connaitre le dossier d'un groupe auquel il n'est pas rattach�
     // MD 27/10/2004 - rajout ##DP## pour que �a fonctionne depuis une appli fille ouverte sur un dossier autre que 000000
     // MD 07/11/2007 - FQ 11811 - �limination des vues
     //  Result := (Trim(GroupeConf) = '') or (ExisteSQL('SELECT UCO_GROUPECONF FROM ##DP##.USERCONF WHERE UCO_GROUPECONF="' + GroupeConf + '" AND UCO_USER="' + V_PGI.User + '"'));
     // MD 14/11/2007 - Lisibilit� => JOIN au lieu des WHERE
     //  Result := (Trim(GroupeConf) = '') or (ExisteSQL('SELECT 1 FROM GRPDONNEES, LIENDONNEES WHERE GRP_NOM = LND_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID= LND_GRPID AND GRP_CODE="' + GroupeConf + '" AND LND_USERID="' + V_PGI.User + '"'));
     Result := (Trim(GroupeConf) = '')
            or (ExisteSQL('SELECT 1 FROM GRPDONNEES '
                         +'LEFT JOIN LIENDONNEES ON GRP_NOM=LND_NOM AND GRP_ID=LND_GRPID '
                         +'WHERE GRP_NOM="GROUPECONF" AND GRP_CODE="'+GroupeConf+'" AND LND_USERID="'+V_PGI.User+'"'));
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 23/01/2006
Modifi� le ... : 23/01/2006
Description .. : Est-ce que le user en cours a les droits
Suite ........ : sur le dossier demand�
Mots clefs ... : 
*****************************************************************}
function JaiLeDroitDossier(NoDossier: string): boolean;
begin
  // MD 07/11/2007 - FQ 11811 - �limination des vues
  //  Result := Not ExisteSQL('SELECT 1 FROM DOSSIERGRP WHERE DOG_NODOSSIER="'+NoDossier+'"')
  //             or ExisteSQL('SELECT 1 FROM DOSSIERGRP, ##DP##.USERCONF WHERE UCO_GROUPECONF = DOG_GROUPECONF AND UCO_USER="'+ V_PGI.User+'" AND DOG_NODOSSIER="'+NoDossier+'"');
  // MD 14/11/2007 - Lisibilit� => JOIN au lieu des WHERE
  // Result := Not ExisteSQL('SELECT 1 FROM GRPDONNEES, LIENDOSGRP WHERE GRP_NOM = LDO_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID = LDO_GRPID AND LDO_NODOSSIER="'+NoDossier+'"')
  //            or ExisteSQL('SELECT 1 FROM GRPDONNEES, LIENDOSGRP, LIENDONNEES WHERE GRP_NOM = LDO_NOM AND GRP_NOM = LND_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID= LND_GRPID AND GRP_ID = LDO_GRPID AND LND_USERID="'+ V_PGI.User+'" AND LDO_NODOSSIER="'+NoDossier+'"');
  Result := Not ExisteSQL('SELECT 1 FROM GRPDONNEES '
                         +'LEFT JOIN LIENDOSGRP ON GRP_NOM=LDO_NOM AND GRP_ID=LDO_GRPID '
                         +'WHERE GRP_NOM = "GROUPECONF" AND LDO_NODOSSIER="'+NoDossier+'"')
             or ExisteSQL('SELECT 1 FROM GRPDONNEES '
                         +'LEFT JOIN LIENDOSGRP ON GRP_NOM=LDO_NOM AND GRP_ID=LDO_GRPID '
                         +'LEFT JOIN LIENDONNEES ON GRP_NOM=LND_NOM AND GRP_ID=LND_GRPID '
                         +'WHERE GRP_NOM="GROUPECONF" AND LDO_NODOSSIER="'+NoDossier+'" AND LND_USERID="'+V_PGI.User+'"');
end;


function IsSuperviseur(AvecMsg: Boolean = True): Boolean;
// donne tous les droits si connect� avec mot de passe du jour
// affiche un message
begin
  Result := False;
  if (not V_PGI.Superviseur) and (V_PGI.Password <> CryptageSt(DayPass(Date))) then
  begin
    if AvecMsg then PgiInfo('Seul un administrateur peut lancer cette fonction !', TitreHalley);
  end
  else
    Result := True;
end;


function EtatMarqueDossier(nodoss: string; var usr, login: string; var sansbase: Boolean): string;
// => trouve la valeur du marquage (verrou) d'un dossier
// => dans usr, login : indique le userlogin qui a fait le marquage
// => dans sansbase : indique si le dossier est flagu� "sans base de production" (dos_absent)
// Marquages possibles :
//    ENL : en ligne
//    MAR : marqu� pour transport
//    PAR : parti
//    SOS : en cours de r�paration (apr�s attachement d'un sql7 sous sql2000)
//    MAJ : en cours de mise � jour (administration base PGI)
//    BLO : dossier bloqu� fonctionnellement
// Attention : ABS "ABSENT" n'est plus un �tat stock� dans DOS_VERROU,
//   mais dans un bool�en DOS_ABSENT signifiant "dossier cr�� sans base de production"
var Q: TQuery;
begin
  Result := '';
  if nodoss = '' then exit;

  // �tat du marquage du dossier
  Q := OpenSQL('SELECT DOS_VERROU, DOS_ABSENT, DOS_UTILISATEUR FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"', True);
  if Q.Eof then begin Ferme(Q); exit; end;
  Result := UpperCase(Q.FindField('DOS_VERROU').AsString);
  if Result = '' then Result := 'ENL';

  // dossier sans base de production
  {$IFDEF VER150}
  sansbase := StrToBool_(Q.FindField('DOS_ABSENT').AsString);
  {$ELSE}
  sansbase := StrToBool_(Q.FindField('DOS_ABSENT').AsString);
  {$ENDIF}

  // user qui a fait la modif
  usr := Q.FindField('DOS_UTILISATEUR').AsString;
  Ferme(Q);
  if usr = '' then exit;

  // login du user qui a fait la modif
  if usr = V_PGI.User then
    login := V_PGI.UserLogin
  else
  begin
    Q := OpenSQL('SELECT US_ABREGE FROM UTILISAT WHERE US_UTILISATEUR="' + usr + '"', True);
    if not Q.EOF then login := Q.FindField('US_ABREGE').AsString;
    Ferme(Q);
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 25/04/2006
Modifi� le ... :   /  /
Description .. : Est-ce que le dossier est cr�� sans base de
Suite ........ : de production... (ancien statut "ABSENT")
Mots clefs ... :
*****************************************************************}
function IsDossierSansBase(nodoss: String): Boolean;
begin
  Result := ExisteSQL('SELECT 1 FROM DOSSIER WHERE DOS_NODOSSIER="'+nodoss+'" AND DOS_ABSENT="X"');
end;

{$IFDEF BUREAU}
function LanceContexteDossier(stNoDossier: string; AvecVerifPwd: Boolean = True): Boolean;
// s�lectionne un dossier, dans une appli de type lanceur
begin
  Result := False;
  if stNoDossier='' then exit;
  if (AvecVerifPwd) and (not VerifPwdDossier(stNoDossier)) then exit;
  if VH_Doss = nil then VH_Doss := TDossSelect.Create;
  VH_Doss.NoDossier := stNoDossier;
  // rappelle le dossier en cours dans la barre de titre
  RajouteCaptionDossier('Dossier : ' + VH_Doss.NoDossier + ' ' + VH_Doss.LibDossier);
  Result := (VH_Doss.NoDossier = stNoDossier);
  // MD 28/03/06 - on en profite pour enlever l'option autoclose sur les bases cabinet,
  // ce qui acc�l�rera les calculs de solde client cumul� dans la fiche synth�se
  if (VH_Doss.NoDossier=stNoDossier) and VH_Doss.Cabinet then
    DBSetAutoClose(VH_Doss.DBSocName, False);
end;
{$ENDIF}

//---------------------------------------
//--- Nom : InitialiserComboGroupeConf
//---------------------------------------
procedure InitialiserComboGroupeConf (ComboGroupeConf : TControl; FiltreDonnees:string='' ) ; //LM20071008
var s, SSql : String;
    QSql : TQuery;
begin
 if Not (ComboGroupeConf is THMultiValComboBox) then exit;

 Ssql:='';

 if (ComboGroupeConf <> nil) then
 begin
   SSql:='GRP_CODE=""' ;
   //+LM20071008
   if filtreDonnees='' then //ps : ces sont des vues sql & fonctionnement par d�faut avec le crit�re GROUPECONF
    // MD 07/11/2007 - FQ 11811 - �limination des vues
    // s:='SELECT UCO_GROUPECONF FROM ##DP##.USERCONF WHERE UCO_USER="'+V_PGI.User+'"'
    // MD 14/11/2007 - Lisibilit� => JOIN au lieu des WHERE
    // s:='SELECT GRP_CODE FROM GRPDONNEES, LIENDONNEES WHERE GRP_NOM = LND_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID= LND_GRPID AND LND_USERID="'+V_PGI.User+'"'

    // GHA : Formule avant modif
    {s:='SELECT GRP_CODE FROM GRPDONNEES '
      +'LEFT JOIN LIENDONNEES ON GRP_NOM=LND_NOM AND GRP_ID=LND_GRPID '
      +'WHERE GRP_NOM="GROUPECONF" AND LND_USERID="'+V_PGI.User+'"'}

     //GHA 02/2008 - Amelioration Requete 2 en 1. Evite une instruction sql
     //volumineuse en terme de r�daction. plusieurs lignes dans le debuglog.
     //(or grp_code = 'x' or grp_code ='y' or ...etc)
     SSql := 'AND EXISTS (SELECT 1 '
                          +'FROM LIENDONNEES '
                         +'WHERE LND_NOM = GRP_NOM '
                           +'AND LND_GRPID = GRP_ID '
                           +'AND LND_USERID = "'+V_PGI.User+'")'
   else
   begin
     s:='select UCO_GROUPECONF from ##DP##.USERCONF_FILTREDONNEES '+
        'where UCO_USER="'+V_PGI.User+'" and UCO_FILTREDONNEES="'+FiltreDonnees+'"' ;
     QSql:=OpenSQL(s, True, -1, '', True);
     //-LM20071008

     try
       while not QSql.Eof do
       begin
         SSql:=SSql + ' OR GRP_CODE="'+QSql.Fields[0].AsString+'"'; //LM20071112 ' OR GRP_CODE="'+QSql.FindField('GRP_CODE').AsString+'"'
         QSql.Next;
       end;
     finally
      Ferme(QSql);
     end;

     Ssql:=' AND ('+SSql+')';
   end;
 end;

 THMultiValCombobox(ComboGroupeConf).Plus := SSql;
end;

//----------------------------------------
//--- Nom : InitialiserComboApplication
//----------------------------------------
procedure InitialiserComboApplication (ComboApplication : TControl);
var Indice : Integer;
    Appli  : TPgiAppli;
    NomExe : String;
begin
 if (ComboApplication<>nil) and (V_Applis<>nil) then
  begin
   THMultiValCombobox (ComboApplication).Items.Clear;
   for Indice:=0 to V_Applis.Applis.count-1 do
    begin
     Appli:=TPGIAppli (V_Applis.Applis [Indice]);
{$IFDEF EAGLCLIENT}
     // ne pas prendre les applis 2 tiers
     if Not Appli.eAgl then Continue;
     // sauf Bureau PGI (mnu rajout� pour contenir la cl� de s�ria)
     if Appli.Nom='ECEGIDPGI.EXE' then Continue;
{$ELSE}
     // ne pas prendre les applis eAgl
     if Appli.eAgl then Continue;
     // sauf Bureau PGI (mnu rajout� pour contenir la cl� de s�ria)
     if Appli.Nom='CEGIDPGI.EXE' then Continue;
{$ENDIF}
     // ne pas prendre les gestion des standards
     if Appli.Std then Continue;
     if Appli.Visible then
      begin
       THMultiValCombobox (ComboApplication).Items.add (Appli.Titre);
       NomExe := Appli.Nom;
{$IFDEF EAGLCLIENT}
       // Les applications actives sont test�es avec des noms d'�x�cutables 2 tiers
       // (pour uniformit� du stockage dans DOSSAPPLI), donc on vire le e de eCCS5.EXE...
       if UpperCase(Copy(NomExe, 1, 1))='E' then NomExe := Copy(NomExe, 2, Length(NomExe)-1);
{$ENDIF}
       THMultiValCombobox (ComboApplication).Values.add (NomExe);
      end;
    end;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : D.C.
Cr�� le ...... : 01/01/2005
Modifi� le ... : 10/05/2006
Description .. : Retourne la requ�te XXWHERE pour limiter une liste de
Suite ........ : dossiers lorsqu'on a choisi <<Tous>> dans la combo 
Suite ........ : GroupeConf
Suite ........ : (= acc�s � tous les groupes auxquels le user
Suite ........ : en cours appartient)
Mots clefs ... :
*****************************************************************}
function GererCritereGroupeConfTous (FiltreDonnees:string='') : String;
begin
  // MB pour test :
//  Result := ' FILTRE("GROUPECONF","'+V_PGI.User+'","")' ;
  Result := '';

  if FiltreDonnees='' then  //LM20071008
    begin
    // MD 07/11/2007 - FQ 11811 - �limination des vues
    {Result := 'NOT EXISTS (SELECT 1 FROM DOSSIERGRP WHERE DOG_NODOSSIER=DOS_NODOSSIER)'
            + ' OR EXISTS (SELECT 1 FROM DOSSIERGRP, USERCONF ' +
                          'WHERE UCO_GROUPECONF = DOG_GROUPECONF AND UCO_USER="'+ V_PGI.User+'" ' +
                          'AND DOG_NODOSSIER=DOS_NODOSSIER) ' }
    // MD 14/11/2007 - Lisibilit� => JOIN au lieu des WHERE + FQ 11831
    {Result := 'NOT EXISTS (SELECT 1 FROM GRPDONNEES, LIENDOSGRP WHERE GRP_NOM = LDO_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID = LDO_GRPID AND LDO_NODOSSIER=DOS_NODOSSIER)';
    Result := Result + ' OR EXISTS (SELECT 1 FROM LIENDOSGRP, GRPDONNEES, LIENDONNEES '
                                 + 'WHERE GRP_NOM = LDO_NOM AND GRP_NOM = LND_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID = LDO_GRPID AND GRP_ID = LND_GRPID '
                                 + 'AND LND_USERID="'+V_PGI.User+'" AND LDO_NODOSSIER=DOS_NODOSSIER)' }
    // Dossier sans groupes
    if GetParamsocDpSecur('SO_MDDOSSANSGRP', True) then
      Result := 'NOT EXISTS (SELECT 1 FROM GRPDONNEES '
                           +'LEFT JOIN LIENDOSGRP ON GRP_NOM=LDO_NOM AND GRP_ID=LDO_GRPID '
                           +'WHERE GRP_NOM="GROUPECONF" AND LDO_NODOSSIER=DOS_NODOSSIER) OR ';
    // Dossiers dans des groupes auxquels l'utilisateur en cours a droit
    Result := Result
                  + 'EXISTS (SELECT 1 FROM GRPDONNEES '
                           +'LEFT JOIN LIENDOSGRP ON GRP_NOM=LDO_NOM AND GRP_ID=LDO_GRPID '
                           +'LEFT JOIN LIENDONNEES ON GRP_NOM=LND_NOM AND GRP_ID=LND_GRPID '
                           +'WHERE GRP_NOM="GROUPECONF" AND LDO_NODOSSIER=DOS_NODOSSIER AND LND_USERID="'+V_PGI.User+'")'
    end
  else
    Result := 'not exists (select 1 FROM DOSSIERGRP_FILTREDONNEES ' +
                          'where DOG_NODOSSIER=DOS_NODOSSIER  and DOG_FILTREDONNEES="'+ FiltreDonnees+'") ' +
              'or exists (select 1 from DOSSIERGRP_FILTREDONNEES, USERCONF_FILTREDONNEES '+
                         'where UCO_GROUPECONF = DOG_GROUPECONF '+
                         'and UCO_USER="'+ V_PGI.User+'" ' +
                         'and DOG_NODOSSIER=DOS_NODOSSIER '+
                         'and DOG_FILTREDONNEES="'+ FiltreDonnees+'") ' ; //LM20071008
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : D.C.
Cr�� le ...... : 01/01/2005
Modifi� le ... : 10/05/2006
Description .. : Retourne la requ�te XXWHERE pour limiter une liste de
Suite ........ : dossiers � ceux qui figurent dans la combo GroupeConf
Suite ........ :
Suite ........ : Option SansGroupe : voir uniquement les dossiers
Suite ........ : qui ne sont rattach�s � aucun groupe de travail
Suite ........ :
Suite ........ : Option bFullGroups : en choix <<Tou>>, prend tous
Suite ........ : les groupes existants, pas seulement ceux auxquels
Suite ........ : le user en cours appartient
Mots clefs ... :
*****************************************************************}
function GererCritereGroupeConf (ComboGroupeConf: TControl; SansGroupeConf: Boolean; bFullGroups: Boolean=False; FiltreDonnees:string='') : String;
var
    XxWhere, SValeur, SCritGroupes : String;
begin
  if FiltreDonnees = '' then
    // MD 07/11/2007 - FQ 11811 - �limination des vues
    // XXWhere := 'NOT EXISTS (SELECT 1 FROM DOSSIERGRP WHERE DOG_NODOSSIER=DOS_NODOSSIER)'
    XXWhere := 'NOT EXISTS (SELECT 1 FROM GRPDONNEES, LIENDOSGRP '
                         +'WHERE GRP_NOM = LDO_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID = LDO_GRPID '
                         + 'AND LDO_NODOSSIER =DOS_NODOSSIER)'
  else
    XXWhere := 'not exists (select 1 from DOSSIERGRP_FILTREDONNEES ' +
                           'where DOG_NODOSSIER=DOS_NODOSSIER and DOG_FILTREDONNEES="'+FiltreDonnees+'") ' ; //-LM20071008

  SCritGroupes := '';
  if (ComboGroupeConf<>nil) then
  begin
    //--- Uniquement les dossiers sans groupe : rien � modifier
    if (SansGroupeConf) then
    //--- Tous les groupes du user
    else if (THMultiValComboBox (ComboGroupeConf).Tous) then
    begin
       //--- Groupes auxquels appartient l'utilisateur + dossiers sans groupes
       if Not bFullGroups then
           XxWhere := GererCritereGroupeConfTous (FiltreDonnees) //LM20071008
       //--- Non limit� (vision de tous les dossiers m�me si l'utilisateur n'est dans aucun groupe !)
       else
           XxWhere := '';
    end
    //--- Uniquement les groupes s�lectionn�s par l'utilisateur
    else
    begin
       SValeur:=THMultiValComboBox (ComboGroupeConf).Text;
       while (SValeur<>'') do
       begin
           if SCritGroupes<>'' then SCritGroupes := SCritGroupes + ' OR ';
           if FiltreDonnees ='' then
             SCritGroupes:=SCritGroupes+'GRP_CODE="'+ReadToKenPipe (SValeur,';')+'"'
           else
             SCritGroupes:=SCritGroupes+'DOG_GROUPECONF="'+ReadToKenPipe (SValeur,';')+'"';
       end;
       if SCritGroupes<>'' then
       begin
           // XxWhere := '('+XxWhere+') OR ('+SCritGroupes+')'; => Non, nouveau comportement :
           // lorsqu'on a s�lectionn� des groupes, on ne voit plus les dossiers sans groupes
           if FiltreDonnees ='' then
             //XxWhere := 'EXISTS (SELECT 1 FROM DOSSIERGRP WHERE DOG_NODOSSIER=DOS_NODOSSIER AND ('+SCritGroupes+'))'
             // MD 14/11/2007 - Lisibilit� => JOIN au lieu des WHERE
             // XxWhere := 'EXISTS (SELECT 1 FROM GRPDONNEES, LIENDOSGRP WHERE GRP_NOM = LDO_NOM AND GRP_NOM = "GROUPECONF" AND GRP_ID = LDO_GRPID '
             //                 + 'AND LDO_NODOSSIER=DOS_NODOSSIER AND ('+SCritGroupes+'))'
             XxWhere := 'EXISTS (SELECT 1 FROM GRPDONNEES '
                               +'LEFT JOIN LIENDOSGRP ON GRP_NOM = LDO_NOM AND GRP_ID = LDO_GRPID '
                               +'WHERE GRP_NOM = "GROUPECONF" AND LDO_NODOSSIER=DOS_NODOSSIER AND ('+SCritGroupes+'))'
           else
            XxWhere := 'exists (select 1 from DOSSIERGRP_FILTREDONNEES '+
                               'where DOG_NODOSSIER=DOS_NODOSSIER and ('+SCritGroupes+') '+
                               'and DOG_FILTREDONNEES="'+FiltreDonnees+'") '; //-LM20071008
       end
     end;
  end;

 if XxWhere<>'' then Result := '(' + XxWhere + ')'
 else Result := '';
end;

//------------------------------------
//--- Nom : GererCritereApplication
//------------------------------------
function GererCritereApplication (ComboApplication : TControl) : String;
var XxWhere           : String;
    SValeur, SCritere : String;
begin
 xxwhere:='';

 if (ComboApplication<>nil) then
  if (not THMultiValComboBox (ComboApplication).Tous) then
   begin
    SValeur:=THMultiValComboBox (ComboApplication).Text;
    if (SValeur<>'') then
     begin
      SCritere:='DAP_NOMEXEC="'+ReadToKenPipe (SValeur,';')+'"';
      while (SValeur<>'') do
       Scritere:=Scritere+' OR DAP_NOMEXEC="'+ReadToKenPipe (SValeur,';')+'"';
     end;
    XxWhere:=' AND (EXISTS (SELECT 1 FROM DOSSAPPLI WHERE DAP_NODOSSIER=DOS_NODOSSIER AND ('+SCritere+')))';
   end;

 Result:=XxWhere;
end;

//---------------------------------------
//--- Nom : GererCritereDivers
//---------------------------------------
function GererCritereDivers (SansDossierCabinet:Boolean=FALSE; SansDossierTransport:Boolean=FALSE;
  SansDossier:Boolean=FALSE; AvecDossiersCabinets:Boolean=FALSE; AvecDossVerrou: String='') : String;
var xxwhere : String;
begin
 //--- Enl�ve le dossier des standards (toujours)
 xxwhere:=' AND DOS_NODOSSIER<>"000STD"';

 //--- Enl�ve le dossier du cabinet (si demand�)
 if SansDossierCabinet then xxwhere:=xxwhere+' AND DOS_NODOSSIER<>"'+NoDossierBaseCommune+'"';

 //--- Enl�ve les dossiers partis (si demand�)
 if SansDossierTransport then xxwhere:=xxwhere+' AND DOS_VERROU<>"PAR"';

 //--- Traite uniquement les dossiers de tel verrou
 if AvecDossVerrou<>'' then xxwhere:=xxwhere+' AND DOS_VERROU="'+AvecDossVerrou+'"';

 //--- Seulement dossier cabinet (hors db0 elle m�me)
 if AvecDossiersCabinets then xxwhere:=xxwhere+' AND DOS_CABINET="X" AND DOS_NODOSSIER<>"000000"';

 //--- Accepte les codes dossiers "vide" (si demand�)
 if SansDossier then xxwhere:='('+xxwhere+') OR (DOS_NODOSSIER IS NULL)';

 result:=xxwhere;
end;

//---------------------------------
//--- Nom : GererCritereAgricole
//---------------------------------
function GererCritereAgricole (ListeCode : String) : String;
var UnCode, SSql : String;
begin
 SSql:=''; Result:='';
 UnCode:=ReadToKenSt (ListeCode);

 while (UnCode<>'') do
  begin
   if (SSql='') then
    SSql:='YDS_CODE="'+UnCode+'"'
   else
    SSql:=SSql+' OR YDS_CODE="'+UnCode+'"';
   UnCode:=ReadToKenSt (ListeCode);
  end;

 if (SSql<>'') then
  Result:=' AND (EXISTS (SELECT 1 FROM CHOIXDPSTD WHERE YDS_PREDEFINI="DOS" AND YDS_NODOSSIER=DOS_NODOSSIER AND YDS_TYPE="DAG" AND ('+SSql+')))';
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : M.D.
Cr�� le ...... : 02/05/2006
Modifi� le ... :   /  /
Description .. : Selon l'�tat de la case � cocher "Sans groupe de travail",
Suite ........ : masque ou non l'acc�s � la combo "Groupe de travail"
Mots clefs ... : 
*****************************************************************}
procedure GereCheckboxSansGrpConf(CheckboxGroupeConf, ComboGroupeConf : TControl);
begin
  if (CheckboxGroupeConf=Nil) or (ComboGroupeConf=Nil) then exit;
  
  if TCheckBox(CheckboxGroupeConf).Checked then
  begin
       THMultiValComboBox (ComboGroupeConf).Text := '<<Tous>>';
       THMultiValComboBox (ComboGroupeConf).Enabled := False
  end
  else
  begin
       THMultiValComboBox (ComboGroupeConf).Text := '';
       THMultiValComboBox (ComboGroupeConf).Enabled := True;
  end;
end;

//---------------------------------------
//--- Nom : AffecteAppliProtec
//---------------------------------------
procedure AffecteAppliProtec (NoDoss:string; SListeAppli:string);
var UneTob,UneTobEnreg : Tob;
begin
 //--- Effacement des anciennes donn�es
 ExecuteSQL ('DELETE FROM DOSSAPPLISPROTEC WHERE DAC_NODOSSIER="'+NoDoss+'"');
 if SListeAppli='' then exit;

 //--- Construction de la tob
 UneTob:=TOB.Create('Table application protec', Nil, -1);
 if (UneTob<>nil) then
  begin
   while (SListeAppli<>'') do
    begin
     UneTobEnreg:=TOB.Create ('DOSSAPPLISPROTEC', UneTob, -1);
     UneTobEnreg.InitValeurs;

     UneTobEnreg.PutValue ('DAC_NODOSSIER',NoDoss);
     UneTobEnreg.PutValue ('DAC_NOMEXEC',ReadToKenPipe (SListeAppli,';'));
    end;

   UneTob.InsertDB (Nil);
   UneTob.Free;
  end;
end;

//------------------------------------
//--- Nom : DonnnerListeAppliProtec
//------------------------------------
function DonnerListeAppliProtec (NoDoss : String) : String;
Var SSql,SListeAppli : String;
    RSql             : TQuery;
begin
 SListeAppli:='';
 SSql:='SELECT DAC_NOMEXEC FROM DOSSAPPLISPROTEC WHERE DAC_NODOSSIER="'+NoDoss+'"';
 RSql:= OpenSQL(SSql, True, -1, '', True);
 while (not RSql.Eof) do
  begin
   SListeAppli:=SListeAppli+RSql.FindField('DAC_NOMEXEC').AsString+';';
   RSql.Next;
  end;
 Ferme (RSql);
 Result:=SListeAppli;
end;


procedure ErreurChamp(lechp, lapage: string; T: TOM; msg: string);
// Pour g�rer la validit� des champs dans un UpdateRecord d'une TOM
begin
  if T.GetControl('Pages')<>Nil then
  begin
    if lapage <> '' then
      TPageControl(T.GetControl('Pages')).ActivePage := TTabSheet(T.GetControl(lapage));
    if lechp <> '' then
      T.SetFocusControl(lechp);
  end;
  T.LastError := 1;
  HShowMessage('0;?caption?;' + msg + ';E;O;O;O;', '', '');
end;


function ChampEstDansQuery(nomchp: string; Q: THQuery): Boolean;
//var chp: TField;
begin
  Result := False;
  try
    // #### Ne marche plus depuis v7 ? chp := Q.FindField(nomchp); // rq : en eagl, le findfield sait faire Q.TQ.Findfield
    if (Pos(nomchp+',', Q.Champs)>0) or (Pos(', '+nomchp, Q.Champs)>0) then
      Result := True;
  except
    // chp := nil;
  end;
  // if chp <> nil then Result := True;
end;


function IsDossierPartiSauf(nodoss, nomexec: string): Boolean;
// Teste, dans une appli de type lanceur, si le dossier est parti
// sauf pour telle appli (parti au sens 'transport en nomade')
var lexec: string;
begin
  Result := False;
  // DOSSIER est uniquement g�r�e en mode DB0
{$IFDEF DP}
  if (VH_DP.ModeFonc <> 'DB0') then exit;
{$ELSE}
  if not ExisteSQL('SELECT 1 FROM SOCIETE WHERE SO_MODEFONC="DB0"') then exit;
{$ENDIF}

  if not ExisteSQL('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss
    + '" AND DOS_VERROU="PAR"') then exit;

  lexec := UpperCase(nomexec);
  // vide ou commence par une extension !
  if (Length(lexec) = 0) or (Copy(lexec, 1, 1) = '.') then exit;
  // manque l'extension
  if Length(lexec) < 4 then lexec := lexec + '.EXE';
  if not ExisteSQL('SELECT DOF_NODOSSIER FROM DOSSAPPFIXE WHERE DOF_NODOSSIER="' + nodoss
    + '" AND DOF_NOMEXEC="' + lexec + '"') then exit;

  Result := True;
end;


procedure ChargeListChpDPSTD(lst: TStringList);
// charge la liste des chps des tables communes (DP ou STD)
// de type XX_NODOSSIER ou XX_GUIDPER (donc li�s aux dossiers)
var Q: TQuery;
begin
  if lst = nil then exit;

  // liste des champs d�pendant d'un no de dossier, ou d'un code personne
  Q := OpenSQL('SELECT DH_NOMCHAMP FROM DETABLES INNER JOIN DECHAMPS ON DT_PREFIXE=DH_PREFIXE '
    + 'WHERE (DT_COMMUN="D" OR DT_COMMUN="S") '
    + 'AND (DH_NOMCHAMP LIKE "%[_]NODOSSIER" OR DH_NOMCHAMP LIKE "%[_]GUIDPERDOS" '
    + 'OR DH_NOMCHAMP LIKE "%[_]GUIDPER" OR DH_NOMCHAMP LIKE "%[_]GUIDLIA")', True, -1, '', True);
  while not Q.Eof do
  begin
    lst.Add(Q.FindField('DH_NOMCHAMP').AsString);
    Q.Next;
  end;
  Ferme(Q);
end;

{$IFDEF DP}
function DossierExiste(nodoss: string): Boolean;
begin
  Result := False;
  if ExisteSQL('SELECT 1 FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"') then
     Result := DBExists ('DB' + nodoss);
end;
{$ENDIF}

function ForcePersonneExiste(nodoss, libacreer: string): String;
var Q: TQuery;
    TobAnnuaire : TOB;
begin
  Result := '';
  Q := OpenSQL('SELECT DOS_GUIDPER FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"', False);
  if not Q.Eof then
  begin
    Result := Q.FindField('DOS_GUIDPER').AsString;
    {$IFDEF EAGLCLIENT}
      ExecuteSQL('DELETE FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"');
    {$ELSE}
      Q.Delete; // oblig� pour pouvoir cr�er dossier apr�s...
    {$ENDIF}
  end;
  Ferme(Q);
  if Result = '' then
  begin
    Result := AglGetGuid();

    // normalement, ne se produit jamais car un GUID est unique !!!
    if not ExisteSQL('SELECT 1 FROM ANNUAIRE WHERE ANN_GUIDPER="' + Result + '"') then
    begin
      TobAnnuaire := TOB.Create('ANNUAIRE',nil,-1);
      TobAnnuaire.InitValeurs;
      TobAnnuaire.PutValue('ANN_GUIDPER',Result);
      TobAnnuaire.PutValue('ANN_CODEPER',-2); // $$$ JP 21/04/06
      TobAnnuaire.PutValue('ANN_NOMPER',libacreer);
      TobAnnuaire.PutValue('ANN_NOM1',libacreer);
      TobAnnuaire.InsertDB(nil);
      FreeAndNil(TobAnnuaire);
    end;
  end;
end;


function VersionDossier(nodoss: string): Integer;
// Passer chaine vide pour version de la base en cours
// Si nodoss<>'', s'assurer auparavant de l'existence de la base dossier,
// sinon opensql provoque un access vio, m�me dans un try except !
var Q: TQuery;
  table: string;
begin
  Result := 0;
//  try
  table := 'SOCIETE';
  if nodoss <> '' then table := 'DB' + nodoss + '.dbo.SOCIETE';
  Q := OpenSQL('SELECT SO_VERSIONBASE FROM ' + table, True);
  if (Q <> nil) and (not Q.Eof) then
    Result := Q.Fields[0].AsInteger;
//  finally
  Ferme(Q);
//  end;
end;

{// #### Fonction inutilisable en v8 car le ldf peut �tre sur un autre disque
function ChercheEtRenommeLDF(repdoss, dbname: string): string;
// un fichier dbxxxxxx_log.ldf devient dbxxxxxx.ldf tout court
var ldf1, ldf2: string;
begin
  // Plusieurs ldf possibles
  ldf1 := repdoss + '\' + dbname + '.LDF';
  ldf2 := repdoss + '\' + dbname + '_log.LDF';
  Result := ldf1;
  // _log.ldf existe
  if FileExists(ldf2) then
  begin
    // on renomme _log
    if not FileExists(ldf1) then
      RenameFile(ldf2, ldf1)
    // .ldf existe
    else
      // garde le plus r�cent
    begin
      if FileDateToDateTime(FileAge(ldf2)) > FileDateToDateTime(FileAge(ldf1)) then
      begin
        DeleteFile(ldf1);
        RenameFile(ldf2, ldf1);
      end
      else
        DeleteFile(ldf2);
    end;
  end;
end;
}

{$IFDEF DP}
function SupprDonneesCommunesDans(nodoss: string): string;
var Q: TQuery;
  sNomTable: string;
begin
  Result := '';
  if not DBExists ('DB' + nodoss) then
  begin Result := '*** La base DB' + nodoss + ' n''existe pas'; exit; end;

  // Liste des tables communes du dossier
  Q := OpenSQL('SELECT DT_NOMTABLE FROM DB' + nodoss + '.dbo.DETABLES'
    + ' WHERE DT_COMMUN="D" OR DT_COMMUN="S"', True, -1, '', True);
  while not Q.Eof do
  begin
    sNomTable := Q.FindField('DT_NOMTABLE').AsString;
    // Pour chacune, purge la table dans le dossier
    try
      V_Pgi.EnableDeShare := False;
      ExecuteSQL('TRUNCATE TABLE DB' + nodoss + '.dbo.' + sNomTable);
      V_Pgi.EnableDeShare := True;
    except
    end;
    Q.Next;
  end;
  Ferme(Q);
  Result := 'Suppression effectu�e dans le dossier ' + nodoss;
end;
{$ENDIF}


// $$$ JP 19/05/06 FQ 10616
{$IFDEF BUREAU}
{$IFDEF EAGLCLIENT}
function DBCollationOk(nodoss : String):boolean;
begin
     if VH_DP.ePlugin <> nil then
         // MD 02/06/06 - la collation officielle est celle de la base "model"
         {if VH_DP.ActiverChoixColl = TRUE then
            Result := VH_DP.ePlugin.CheckCollationBase ('DB' + nodoss, '', VH_DP.CollationDef)
         else
            Result := VH_DP.ePlugin.CheckCollationBase ('DB' + nodoss, V_PGI.DBName, '')}
         Result := VH_DP.ePlugin.CheckCollationBase('DB' + nodoss, 'model', '')
     else
         Result := FALSE;
end;
{$ELSE}
function GetGoodCollation : String;
begin
{  // Si le choix de collation est impos�
  if VH_DP.ActiverChoixColl then
    Result := VH_DP.CollationDef
  // sinon, c'est celui de la DB0 qui l'emporte
  else
    Result := GetCollationBase(V_PGI.DBName); }

  // MD 02/06/06
  // maintenant, la collation officielle est celle de la base "model"
  // (base syst�me fournie par l'installation MsSql)
  Result := GetCollationBase('model');
end;
{$ENDIF EAGLCLIENT}
{$ENDIF BUREAU}

{***********A.G.L.***********************************************
Auteur  ...... : MD
Cr�� le ...... : 26/05/2005
Modifi� le ... : 26/05/2005
Description .. : Mise en place ou retrait de l'option autoclose
Suite ........ : sur une base de type Sql Server
Mots clefs ... :
*****************************************************************}
function DBSetAutoClose (strBase:string; bAutoClose:boolean):boolean;
begin
     //Result := True;
     if (V_PGI.Driver<>dbMSSQL) and (V_PGI.Driver<>dbMSSQL2005) then
     begin
          Result := False;
          exit;
     end
     else
     begin
          try
                Result := True;
                if bAutoClose then
                    ExecuteSQL('exec sp_dboption ' + strBase + ', autoclose, true')
                else
                    ExecuteSQL('exec sp_dboption ' + strBase + ', autoclose, false');
          except
                Result := False;
          end;
     end;
end;

function NoDossierBaseCommune: string;
begin
  if V_PGI.DefaultSectionDBName <> '' then
    Result := V_PGI.DefaultSectionDbName
  else
    Result := V_PGI.DbName; // ou DBSOC.Params.Values['DataBase'] (BDE : ['DATABASE NAME'])
  // enl�ve DB
  if UpperCase(Copy(Result, 1, 2)) = 'DB' then Result := Copy(Result, 3, Length(Result) - 2);
end;


// Met � jour l'indicateur "appli activ�e" dans la base commune
// Bien mettre le nom de l'appli sous la forme 'NOMAPPLI.EXE'
procedure SetAppliActive(sExeName, sNoDossier: string; bFlag: Boolean);
{$IFDEF EAGLCLIENT}
var
   TOBAppli  :TOB;
begin
     // pas de ##DP##, car DOSSAPPLI est une table "syst�me DP"
     sExeName := UpperCase (sExeName);
     if bFlag = TRUE then
     begin
          // Cr�ation de l'enregistrement s'il n'existe pas (par une TOB, le TQuery ne fonctionne apparement pas)
          if ExisteSQL ('SELECT 1 FROM DOSSAPPLI WHERE DAP_NODOSSIER="' + sNoDossier + '" AND DAP_NOMEXEC="' + sExeName + '"') = FALSE then
          begin
               TOBAppli := TOB.Create ('DOSSAPPLI', nil, -1);
               try
                  TOBAppli.InitValeurs;
                  TOBAppli.PutValue ('DAP_NODOSSIER', sNoDossier);
                  TOBAppli.PutValue ('DAP_NOMEXEC', sExeName);
                  TOBAppli.InsertDB (nil);
               finally
                      FreeAndNil (TOBAppli);
               end;
          end;
     end
     else
         ExecuteSql ('DELETE FROM DOSSAPPLI WHERE DAP_NODOSSIER="' + sNoDossier + '" AND DAP_NOMEXEC="' + sExeName + '"');
end;
{$ELSE}
var Q: TQuery;
begin
  // activation d'une application
  if bFlag then
  begin
    // guillemets si on ouvre en �criture une table d'une autre base
    Q := OpenSQL('SELECT * FROM ##DP##.DOSSAPPLI'
      + ' WHERE DAP_NODOSSIER="' + sNoDossier + '"'
      + ' AND DAP_NOMEXEC="' + Uppercase(sExeName) + '"', False);
    if Q.Eof then
    begin
      Q.Insert;
      InitNew(Q);
      Q.FindField('DAP_NODOSSIER').AsString := sNoDossier;
      Q.FindField('DAP_NOMEXEC').AsString := UpperCase(sExeName);
      Q.Post;
    end;
    Ferme(Q);
  end
  // d�sactivation
  else
    ExecuteSql('DELETE FROM ##DP##.DOSSAPPLI'
      + ' WHERE DAP_NODOSSIER="' + sNoDossier + '"'
      + ' AND DAP_NOMEXEC="' + Uppercase(sExeName) + '"');
end;
{$ENDIF}



{***********A.G.L.Priv�.*****************************************
Auteur  ...... : M. DESGOUTTE
Cr�� le ...... : 21/02/2006
Modifi� le ... :   /  /
Description .. : Retourne l'id de la fiche annuaire du dossier,
Suite ........ : en allant chercher dans la base commune si il y en a une,
Suite ........ : ou dans la base en cours si il n'y en a pas.
Mots clefs ... :
*****************************************************************}
function GetGuidPer(nodoss: string): String;
// Retourne le code personne de la fiche annuaire du dossier,
// en allant chercher dans la base commune si il y en a une,
// ou dans la base en cours si il n'y en a pas.
var Q: TQuery;
begin
  Result := '';
  if nodoss = '' then exit;
  Q := OpenSQL('SELECT DOS_GUIDPER FROM ##DP##.DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"', True);
  if not Q.Eof then Result := Q.FindField('DOS_GUIDPER').AsString;
  Ferme(Q);
end;


function GetNoDossierFromGuidPer(GuidPer: string): String;
var
    Q : TQuery;
begin
 Result:='';
 Q := OpenSql('SELECT DOS_NODOSSIER FROM DOSSIER WHERE DOS_GUIDPER="'+GuidPer+'"', True);
 if (Not Q.Eof) then Result := Q.FindField ('DOS_NODOSSIER').AsString;
 Ferme (Q);
end;


function GetGammeDossier(nodoss: string): string;
var laserie: string;
  Q: TQuery;
begin
  Result := '';
  Q := OpenSQL('SELECT DOS_LASERIE FROM DOSSIER WHERE DOS_NODOSSIER="'
    + VH_Doss.NoDossier + '"', True);
  if not Q.EOF then laserie := Q.FindField('DOS_LASERIE').AsString;
  Ferme(Q);
  if (laserie = 'S1') or (laserie = 'S3') then
    Result := 'S1S3'
  else // cas le plus courant
    Result := 'S5S7';
end;


function ListeCorrecte(sChampNom_p, sChampTitre_p: string; QRY_p: THQuery): Boolean;
begin
  Result := True;
  if not ChampEstDansQuery(sChampNom_p, QRY_p) then
  begin
    Result := False;
    PGIInfo('La colonne "' + sChampTitre_p + '" ne figure pas dans votre param�trage de liste.' + #13 + #10 +
      'Veuillez la rajouter dans "Afficher les colonnes suivantes".', TitreHalley);
  end;
end;


function GetParamsocDP(NomParam: String): Variant;
// Lecture d'un paramsoc dans la base commune
begin
  Result := GetParamsocDossier(NomParam, '##DP##');
end;


function GetParamsocDossier(NomParam: String; NomBase: String): Variant;
// Lecture d'un paramsoc dans la base dossier demand�e
var
    Q: TQuery;
    St, Data: string;
    zz: Char;
begin
  Result := #0;
  if UpperCase(NomBase)='##DP##' then
    Q := OpenSQL('SELECT * FROM ##DP##.PARAMSOC WHERE SOC_NOM="' + NomParam + '"', True)
  else
    Q := OpenSQL('SELECT * FROM '+NomBase+'.dbo.PARAMSOC WHERE SOC_NOM="' + NomParam + '"', True);

  if not Q.Eof then
  begin
    St := Q.FindField('SOC_DESIGN').AsString;
    St := ReadTokenSt(St); if St <> '' then zz := St[1] else zz := ' ';
    Data := Q.FindField('SOC_DATA').AsString;
    Result := ParamSocDataToVariant(NomParam, Data, zz);
  end;
  Ferme(Q);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : LM
Cr�� le ...... : 31/08/2006
Modifi� le ... :   /  /    
Description .. : Provisoire ...
Mots clefs ... :
*****************************************************************}
procedure InsideSynthese (f:TForm); //LMO
begin
  if (f.parent<>nil) and (f.parent.ClassNameIs('THPanel'))
   and (f.parent.Name='pVue') then TControl(f.parent).Visible := false ;
end ;

function RecupArgument(cle, arg: string): string; //LM20071008
var p: integer;
    s: string;
begin
  p := pos(cle, arg);
  if p > 0 then
  begin
    s := trim(copy(arg, p + length(cle), 1000));
    s := trim(gtfs(s, ';', 1));
    p := pos('=', s);
    if p > 0 then s := trim(copy(s, p + 1, 1000));
  end;
  result := s;
end;

function RecupEtSupprimeArgument(cle : string; var arg: string): string; //LM20071008
var p, D, F: integer;
    s: string;
begin
  p := pos(cle, arg);
  if p > 0 then
  begin
    D:= p ;
    F:=pos (';',copy (s, D,1000));
    if F=0 then F:=1000 ;
    s := trim(copy(arg, p + length(cle), 1000));
    s := trim(gtfs(s, ';', 1));
    p := pos('=', s);
    if p > 0 then s := trim(copy(s, p + 1, 1000));

    delete(arg, D, F);
  end;
  result := s;
end;

////////////////////////////////////////////////////////////////////////////////
{***********A.G.L.***********************************************
Auteur  ...... : Pierre Lenormand
Cr�� le ...... : 22/12/2007
Modifi� le ... :   /  /
Description .. : Proc�dure de r�paration de la tablette TTFormeJuridique
suite ........ : � n'utiliser que jusqu'� la socref 9
Mots clefs ... :
*****************************************************************}
procedure InitTTFormeJuridique ( stNomBase : string );
var
    stCode, stLibelle, stAbrege, stLibre : string;
    stDB : string;
begin
  if stNomBase <> '' then stDB := stNomBase+'.dbo.'
    else stDB := '';


    { Delete de la tablette dans la base }
    ExecuteSQL ('DELETE FROM '+stDB+'CHOIXCOD WHERE CC_TYPE="JUR"');


    { Insertions dans la base }
    stCode := '...';
    stLibelle := 'Aucune';
    stAbrege := '';
    stLibre := '---';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'ASS';
    stLibelle := 'ASS';
    stAbrege := 'Association';
    stLibre := 'Association � but non lucratif r�gie par la loi du 1er juillet 1901';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'COO';
    stLibelle := 'COOP';
    stAbrege := 'Soci�t� coop. agr';
    stLibre := 'Soci�t� coop�rative agricole';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'DIV';
    stLibelle := 'Divers';
    stAbrege := 'Divers';
    stLibre := '';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'EAR';
    stLibelle := 'EARL';
    stAbrege := 'exploit. agricole';
    stLibre := 'Exploitation agricole � responsabilit� limit�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'EI';
    stLibelle := 'E.I.';
    stAbrege := '';
    stLibre := '---';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'EPI';
    stLibelle := 'EPIC';
    stAbrege := 'Pers. morale d. p';
    stLibre := 'Personne morale de droit public soumise droit commercial';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GAE';
    stLibelle := 'GAEC';
    stAbrege := 'Grpt agricole';
    stLibre := 'Groupement agricole d''exploitation en commun';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GAF';
    stLibelle := 'GAF';
    stAbrege := 'Grp agricol fonci';
    stLibre := 'Groupement agricole foncier';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GEI';
    stLibelle := 'GEIE';
    stAbrege := 'Grpt int�r�t �co';
    stLibre := 'Groupement Europ�en d''int�r�t �conomique';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GFA';
    stLibelle := 'GFA';
    stAbrege := 'Grpt fonc. agric.';
    stLibre := 'Groupement Foncier Agricole';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GFO';
    stLibelle := 'GFO';
    stAbrege := 'Grpt forestier';
    stLibre := 'Groupement forestier';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GFR';
    stLibelle := 'GFR';
    stAbrege := 'Grpt fonc. rural';
    stLibre := 'Groupement foncier rural';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GIE';
    stLibelle := 'GIE';
    stAbrege := 'Grpt int. �co.';
    stLibre := 'Groupement d''int�r�t �conomique';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'GP';
    stLibelle := 'GP';
    stAbrege := 'Grp pastoral';
    stLibre := 'Groupement pastoral';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'IND';
    stLibelle := 'IND';
    stAbrege := 'Exploitant indivi';
    stLibre := 'Exploitant individuel';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'IVI';
    stLibelle := 'INDIV';
    stAbrege := 'Indivision';
    stLibre := 'Indivision';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'ME';
    stLibelle := 'Madame';
    stAbrege := '';
    stLibre := '';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'MLE';
    stLibelle := 'Mademoiselle';
    stAbrege := '';
    stLibre := '';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'MM.';
    stLibelle := 'Messieurs';
    stAbrege := '';
    stLibre := '';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'MR';
    stLibelle := 'Monsieur';
    stAbrege := '';
    stLibre := '';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SA';
    stLibelle := 'SA';
    stAbrege := 'Soci�t� anonyme';
    stLibre := 'Soci�t� anonyme';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SAD';
    stLibelle := 'SADIR';
    stAbrege := 'SA � directoire';
    stLibre := 'Soci�t� Anonyme � directoire et conseil de surveillance';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SAG';
    stLibelle := 'SAGEN';
    stAbrege := 'SAGEN';
    stLibre := 'Soci�t� anonyme g�n�rique';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SAR';
    stLibelle := 'SARL';
    stAbrege := 'S.A.R.L.';
    stLibre := 'Soci�t� � responsabilit� limit�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SAS';
    stLibelle := 'SAS';
    stAbrege := 'ste action simpl';
    stLibre := 'Soci�t� par actions simplifi�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SC';
    stLibelle := 'SC';
    stAbrege := 'soci�t� civile';
    stLibre := 'Soci�t� civile';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SC1';
    stLibelle := 'SCPI';
    stAbrege := 'Ste civile immo';
    stLibre := 'Soci�t� civile de placements immobiliers';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCA';
    stLibelle := 'SCA';
    stAbrege := 'Ste commandit� ac';
    stLibre := 'Soci�t� en commandit�s par actions';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCE';
    stLibelle := 'SCEA';
    stAbrege := 'Ste civile explo.';
    stLibre := 'Soci�t� civile d''exploitation agricole';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCF';
    stLibelle := 'SCF';
    stAbrege := 'Ste civile fonci�';
    stLibre := 'Soci�t� civile fonci�re';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCG';
    stLibelle := 'SCGA';
    stAbrege := 'Ste civile expl.';
    stLibre := 'Soci�t� civile d''exploitation agricole';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCI';
    stLibelle := 'SCI';
    stAbrege := 'Ste civile immo';
    stLibre := 'Soci�t� civile immobili�re';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCM';
    stLibelle := 'SCM';
    stAbrege := 'Ste civile moyens';
    stLibre := 'Soci�t� civile de moyens';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCP';
    stLibelle := 'SCP';
    stAbrege := 'Ste civile prof';
    stLibre := 'Soci�t� civile professionelle';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SCS';
    stLibelle := 'SCS';
    stAbrege := 'St� command. sim.';
    stLibre := 'Soci�t� en commandit� simple';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SDF';
    stLibelle := 'SDF';
    stAbrege := 'soci�t� de fait';
    stLibre := 'Soci�t� de fait';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEA';
    stLibelle := 'SELARL';
    stAbrege := 'St� ex lib (SARL)';
    stLibre := 'Soci�t� d''exercice lib�ral � responsabilit� limit�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEC';
    stLibelle := 'SELCA';
    stAbrege := 'Ste ex lib. (SCA)';
    stLibre := 'Soci�t� d''exercice lib�ral en commandit� par actions';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEL';
    stLibelle := 'SELAFA';
    stAbrege := 'Ste ex lib. (SA)';
    stLibre := 'Soci�t� d''exercice lib�ral � forme anonyme';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEM';
    stLibelle := 'SEM';
    stAbrege := 'St� �co mixte';
    stLibre := 'Soci�t� d''�conomie mixte';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEP';
    stLibelle := 'SEP';
    stAbrege := 'St� en particip.';
    stLibre := 'Soci�t� en participation';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SES';
    stLibelle := 'SELAS';
    stAbrege := 'St� ex lib (SAS)';
    stLibre := 'Soci�t� d''exercice lib�ral par actions simplifi�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SEU';
    stLibelle := 'SELASU';
    stAbrege := 'St� ex lib (SASU)';
    stLibre := 'Soci�t� d''exercice lib�ral par actions simplifi�e unipersonnelle';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SNC';
    stLibelle := 'SNC';
    stAbrege := 'St� nom collect.';
    stLibre := 'Soci�t� en nom collectif';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'SSU';
    stLibelle := 'SASU';
    stAbrege := 'St� act. simpl.';
    stLibre := 'Soci�t� par actions simplifi�es unipersonnelle';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

    stCode := 'URL';
    stLibelle := 'EURL';
    stAbrege := 'Entr. uniperson.';
    stLibre := 'Entreprise unipersonnelle � responsabilit� limit�e';
    ExecuteSQL ('INSERT INTO '+stDB+'CHOIXCOD (CC_TYPE,CC_CODE,CC_LIBELLE,CC_ABREGE,CC_LIBRE) '+
         'VALUES ("JUR","'+stCode+'","'+stLibelle+'","'+stAbrege+'","'+stLibre+'")');

end;


end.



