{***********UNITE*************************************************
Auteur  ...... : MD
Cr�� le ...... : 04/03/2004
Modifi� le ... :   /  /
Description .. : Objet de gestion du dossier "s�lectionn�"
Suite ........ : => concerne uniquement un lanceur d'application
Suite ........ :   (=une appli connect�e � la base contenant les dossiers)
Suite ........ : => attention, V_PGI.NoDossier est fixe, et repr�sente
Suite ........ :   le no de dossier de la base en cours
Suite ........ :   (donc 000000 pour un lanceur d'application)
Suite ........ :
Mots clefs ... :
*****************************************************************}
unit UDossierSelect;


interface

uses
  SysUtils, Forms, HCtrls, Hent1,
{$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  Db, Sql7Util,
{$ENDIF}
  UTob,
  PGIAppli,
  Paramsoc,
  HMsgBox;


Type
  TDossSelect = class(TObject)
    // ---- Ici propri�t�s de l'objet modifiables directement
    LibDossier:  String;      // libell� du dossier en cours

  private
    // ---- Dossier en cours (au sens soci�t�)
    sNoDossier:   String;      // no de dossier en cours (bijection avec code soci�t�)
    sCodeSoc:     String;      // code soci�t� en cours
    sGuidPer:     String;      // guid personne dans l'annuaire
    sPwdDossier:  String;      // password (crypt�) du dossier en cours
    sPathDos:     String;      // r�pertoire de travail du dossier
    sPathMdf:     String;      // chemin base mdf local au serveur
    sPathLdf:     String;      // chemin lof ldf local au serveur
    sDBSocName:   String;      // nom de la base soci�t� ou dossier
    bCabinet:     Boolean;     // dossier faisant partie du groupe cabinet
{$IFDEF EAGLCLIENT}
    // #### pas de TPGIConn en eAGLClient
{$ELSE}
    cSoc:         TPGIConn;    // ---- param connexion soci�t� (pointeur)
{$ENDIF}
    procedure SetSocDossier(const nodoss : String);
    procedure SetCodeSoc(const codesoc: String);

    function ForceDossierExiste(nodoss, libacreer: string): String;

  protected

  public
    constructor Create;
    destructor  Destroy; override;

    // ---- Dossier en cours (au sens soci�t�)
    property  NoDossier:   String read sNoDossier write SetSocDossier;
    property  CodeSoc:     String read sCodeSoc write SetCodeSoc;
    property  GuidPer:     String read sGuidPer;
    property  PwdDossier:  String read sPwdDossier;
    property  PathDos:     String read sPathDos;
    property  PathMdf:     String read sPathMdf;
    property  PathLdf:     String read sPathLdf;
    property  DBSocName:   String read sDBSocName;
    property  Cabinet:     Boolean read bCabinet write bCabinet;
{$IFDEF EAGLCLIENT}
{$ELSE}
    property  Soc:         TPGIConn read cSoc;
{$ENDIF}
  end;


procedure LanceAppliMultiDossier(lappli : TPGIAppli);
function  RetourneDossierPcl: String; overload;
function  RetourneDossierPcl(NoDossier : String) : String; overload;

function  IsDossierMajPcl(dbname : String): Boolean;
function  IsDossierOptimise(dbname : String): Boolean;

var VH_Doss : TDossSelect = Nil;


//////////// IMPLEMENTATION /////////////
implementation

uses
galsystem,
EntDP;

procedure LanceAppliMultiDossier(lappli : TPGIAppli);
begin
  // iconisation du bureau pour gain de m�moire (int�r�t surtout en TSE)
  Application.Minimize;
  {$IFDEF EAGLCLIENT}
  SaveSynRegKey('eAGLHost',copy(V_PGI.eAGLHost,1,pos(':',V_PGI.eAGLHost)-1) ,true) ; //AppServer.HostName + ':' + IntToStr(AppServer.PortNumber),True);
  {$ENDIF}
  // lancement
  V_Applis.ActiveAppli (lappli, VH_Doss.NoDossier, V_PGI.CurrentAlias, V_PGI.DbName, VH_Doss.GuidPer, VH_DOSS.NoDossier); //$$$JP 16/02/06 VH_Doss.CodeSoc);
end;

{ TDossSelect }

constructor TDossSelect.Create;
begin
  sNoDossier   := '' ;
  sCodeSoc     := '' ;
  sGuidPer     := '' ;
  LibDossier   := '' ;
  sPwdDossier  := '' ;
  sPathDos     := '' ;
  sPathMdf     := '' ;
  sPathLdf     := '' ;
  sDBSocName   := '' ;
  bCabinet     := False;
{$IFDEF EAGLCLIENT}
  // #### pas de TPGIConn en eAGLClient
{$ELSE}
  cSoc          := TPGIConn.Create;
  cSoc.Share    := V_PGI.Share;
  cSoc.Dir      := V_PGI.DatPath;
  if V_PGI.Driver=dbMsSql2005 then
    cSoc.Driver := 'ODBC_MSSQL2005'
  else
    cSoc.Driver   := 'ODBC_MSSQL';
  cSoc.Base     := '';
  cSoc.Path     := '';
  {$IFDEF DBXADO}
  cSoc.Server   := DBSOC.Params.Values['HostName'] ;
  cSoc.ODBC     := 'Microsoft OLEDB Driver';
  cSoc.User     := DBSOC.Params.Values['User_name'];
  cSoc.Password := DBSOC.Params.Values['Password'];
  // MD-PJM 16/11/06 - D�sactivation du connection pooling
  // sinon op�rations de maintenances impossibles sur les bases ("in use")
  cSoc.Options  := '*OLE DB Services=-4';
  {$ELSE}
  cSoc.Server   := DBSOC.Params.Values['ODBC DSN'] ;
  cSoc.ODBC     := 'SQL Server';
  cSoc.User     := DBSOC.Params.Values['USER NAME'] ;
  cSoc.Password := DBSOC.Params.Values['PASSWORD'] ;
  cSoc.Options  := '';
  {$ENDIF}
{$ENDIF}

end;

destructor TDossSelect.Destroy;
begin
{$IFDEF EAGLCLIENT}
{$ELSE}
  cSoc.Free;
{$ENDIF}
  inherited;
end;

function TDossSelect.ForceDossierExiste(nodoss, libacreer: string): String;
var Q: TQuery;
    TobAnnuaire : TOB;
begin
  Result := '';
  Q := OpenSQL('SELECT DOS_GUIDPER FROM DOSSIER WHERE DOS_NODOSSIER="' + nodoss + '"', False);
  if Q.Eof then
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
    if not ExisteSQL('SELECT 1 FROM DOSSIER WHERE DOS_GUIDPER="' + Result + '"') then
    begin
      TobAnnuaire := TOB.Create('DOSSIER',nil,-1);
      TobAnnuaire.InitValeurs;
      TobAnnuaire.PutValue('DOS_GUIDPER',Result);
      TobAnnuaire.PutValue('DOS_NODOSSIER',nodoss);
      TobAnnuaire.PutValue('DOS_CODEPER',-2); // $$$ JP 21/04/06
      TobAnnuaire.PutValue('DOS_LIBELLE',libacreer);
      TobAnnuaire.PutValue('DOS_NODISQUE',1);
      TobAnnuaire.PutValue('DOS_GROUPECONF','');
      TobAnnuaire.InsertDB(nil);
      FreeAndNil(TobAnnuaire);
    end;
  end
  else
  begin
    Result := Q.FindField('DOS_GUIDPER').AsString;
  end;
  Ferme(Q);
end;


procedure TDossSelect.SetSocDossier(const nodoss: String);
var Q : TQuery;
    volume : String;
    nodisq : Integer;
begin
  // purge
  sNoDossier := Trim(nodoss);
  sCodeSoc     := '' ;
  sGuidPer     := '' ;
  LibDossier   := '' ;
  sPwdDossier  := '' ;
  sPathDos     := '' ;
  sPathMdf     := '' ;
  sPathLdf     := '' ;
  sDBSocName   := '' ;
{$IFDEF EAGLCLIENT}
{$ELSE}
  cSoc.Base    := '';
  cSoc.Path    := '';
{$ENDIF}
  if sNoDossier='' then exit; // pas de dossier demand�

  // MB le 07/01/08 : Dossier des standards non existant sur base r�pliqu�s :
  // On le cr�e si il n'existe pas !!!! 
{$IFDEF DP}
  If ( sNoDossier = '000STD' )
  and DBExists('DB'+SNoDossier)
  and VH_DP.SeriaKPMG then
  begin
    ForceDossierExiste('000STD', 'STANDARDS');
  end;
{$ENDIF}

  Q := OpenSQL('SELECT * FROM ##DP##.DOSSIER WHERE DOS_NODOSSIER="'+sNoDossier+'"', True,-1,'',true);
  // pas d'infos de connexion
  if Q.EOF then
    begin
    PGIInfo('Le dossier '+sNoDossier+' est inconnu et ne peut pas �tre s�lectionn�.', 'S�lection de dossier') ;
    sNoDossier := ''; // Informe le client qu'il n'y a pas de dossier en cours
    Ferme(Q);
    exit;
    end;

  // ---- Code soci�t�, code personne
  sCodeSoc := Q.FindField('DOS_SOCIETE').AsString;
  sGuidPer := Q.FindField('DOS_GUIDPER').AsString;

  // ---- Nom de la base soci�t�
  sDBSocName := 'DB'+sNoDossier;
  bCabinet := StrToBool(Q.FindField('DOS_CABINET').AsString);
{$IFDEF EAGLCLIENT}
{$ELSE}
  cSoc.Base := sDBSocName;
{$ENDIF}
  LibDossier := Q.FindField('DOS_LIBELLE').AsString;
  // m�me si test sur la base en cours...
  if ChampToNum('DOS_PASSWORD')>0 then
    sPwdDossier := Q.FindField('DOS_PASSWORD').AsString;

  // ---- R�pertoire du dossier
  if (GetLeMode='L') and (Q.FindField('DOS_VERROU').AsString='PAR') then
    nodisq := Q.FindField('DOS_NODISQUELOC').AsInteger
  else
    nodisq := Q.FindField('DOS_NODISQUE').AsInteger;
  Ferme(Q);

  // si integer non initialis� dans table, il peut valoir -1 ou 7123564...
  if (nodisq<1) or (nodisq>100) then
    begin
    PGIInfo('Pas de no de disque associ� au dossier '+sNoDossier);
    exit;
    end;

  // rq : en mode local (sLeMode='L'), sPartages et sPartagesLoc sont identiques
  volume := '';
{$IFDEF EAGLCLIENT}
  // #### A FAIRE EAGL => r�cup chemin local pour le dossier (ou s�l doss dans le plugin)
  // Rq : $DOS non utilisable, car correspond au r�p. dossier dans une appli fille
  // volume := AppServer.Request('...
  // ...
{$ELSE}
  if (nodisq >= 1) and (V_PGI.Partages[nodisq]<>'') then
    volume := V_PGI.Partages[nodisq];
  if volume='' then
    PGIInfo('Disk'+IntToStr(nodisq)+' non d�fini pour le dossier '+sNoDossier)
  else
    sPathDos := volume+'\D'+sNoDossier;
  cSoc.Dir := sPathDos;

  // r�pertoires locaux du serveur
  if V_PGI.PartagesLoc[nodisq]<>'' then
    begin
    sPathMdf := V_PGI.PartagesLoc[nodisq]+'\D'+sNoDossier;
    // r�pertoire du log
    if V_PGI.PartagesLog[nodisq]='' then
      sPathLdf := sPathMdf
    else
      sPathLdf := V_PGI.PartagesLog [nodisq]+'\D'+sNoDossier; // ou GetParamsocDPSecur('SO_ENVDISK'+IntToStr(nodisq)+'LOG', '');
    end;
{$ENDIF}

end;

procedure TDossSelect.SetCodeSoc(const codesoc: String);
var nodoss: String;
    Q : TQuery;
begin
  if sCodeSoc=trim(codesoc) then exit;

  // purge
  SetSocDossier('');
  if codesoc='' then exit; // pas de dossier demand�

  // retrouve le no de dossier correspondant
  Q := OpenSQL('SELECT * FROM ##DP##.DOSSIER WHERE DOS_SOCIETE="'+trim(codesoc)+'"', True,-1,'',true);
  // pas d'infos de connexion
  if Q.EOF then
    begin
    PGIInfo('Le dossier de code soci�t� '+codesoc+' est inconnu et ne peut pas �tre s�lectionn�.', 'S�lection de dossier') ;
    sCodeSoc := ''; // Informe le client qu'il n'y a pas de dossier en cours
    Ferme(Q);
    exit;
    end
  else
    begin
    nodoss := Q.FindField('DOS_NODOSSIER').AsString;
    Ferme(Q);
    end;

  // d�finit le dossier en cours
  SetSocDossier(nodoss);
end;

{***********A.G.L.***********************************************
Auteur  ...... : MD
Cr�� le ...... : 14/09/2005
Modifi� le ... :   /  /
Description .. : Retourne la commande /DOSSIERPCL=TRUE
Suite ........ : si le dossier en cours le permet
Suite ........ : (c'est � dire : pas de GI dessus)
Mots clefs ... :
*****************************************************************}
function RetourneDossierPcl: String;
begin
  Result := RetourneDossierPcl(VH_Doss.NoDossier);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 31/01/2006
Modifi� le ... :   /  /    
Description .. : Retourne /DOSSIERPCL=TRUE
Suite ........ : si le dossier demand� le permet
Suite ........ : (c'est � dire : pas de GI dessus)
Mots clefs ... : 
*****************************************************************}
function  RetourneDossierPcl(NoDossier : String) : String; overload;
begin
  Result := '';
  // Mode de mise � jour all�g� pour un Dossier PCL non top� cabinet, autre que la base des standards
  if (V_PGI.ModePCL='1')
  // MD20070724 FQ11628 - Mis en commentaire car on peut mettre un dossier all�g� dans le groupe cabinet
  // and Not ExisteSQL('SELECT 1 FROM DOSSIER WHERE DOS_NODOSSIER="' + NoDossier + '" AND DOS_CABINET="X"')
  and (NoDossier<>'000STD')
  // n'ayant pas eu la GI activ�e
  and Not ExisteSQL('SELECT 1 FROM DOSSAPPLI WHERE DAP_NODOSSIER="' + NoDossier + '" AND DAP_NOMEXEC="CGIS5.EXE"')
  then
    begin
    // et ne contenant r�ellement pas de GI !
    try
      // - soit parce que c'est un dossier d�j� mis � jour de mani�re all�g�e, donc sans table AFFAIRE
      // (ne pas tester pr�sence de AFFAIRE dans detables, car DETABLES est compl�te
      // tant qu'on n'a pas eu de traitement de purge !!)
      if (Not ExisteSQL('SELECT 1 FROM DB' + NoDossier + '.dbo.DECHAMPS WHERE DH_PREFIXE="AFF"'))
      // - soit parce qu'il n'y a aucune AFFAIRE cr��e dans ce dossier
      // (les nouveaux dossiers ont une base compl�te issue de la DBMODELE)
      or (Not ExisteSQL('SELECT ##TOP 1## AFF_AFFAIRE FROM DB' + NoDossier + '.dbo.AFFAIRE')) then
        Result := ' /DOSSIERPCL=TRUE';
    except
      end;
    end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : MD
Cr�� le ...... : 26/09/2005
Modifi� le ... : 22/03/2006
Description .. : Est-ce que le dossier a �t� mis � jour en mode PCL
Suite ........ : (= all�g�)
Suite ........ : Voir dans UtilPgi la fct similaire sur la base en cours : 
Suite ........ : EstBasePCLAllegee
Mots clefs ... : 
*****************************************************************}
function IsDossierMajPcl(dbname : String): Boolean;
begin
  Result := False;
  try
    Result := Not ExisteSQL('SELECT 1 FROM '+dbname+'.dbo.DECHAMPS WHERE DH_PREFIXE="AFF"');
  except
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : MD
Cr�� le ...... : 17/10/2005
Modifi� le ... : 22/03/2006
Description .. : Est-ce que le dossier a �t� optimis�
Suite ........ : (suppression r�elle des objets suite � une
Suite ........ : mise � jour PCL)
Suite ........ : Voir dans UtilPgi la fct similaire sur la base en cours : 
Suite ........ : EstBasePclOptimise
Mots clefs ... : 
*****************************************************************}
function  IsDossierOptimise(dbname : String): Boolean;
begin
  Result := False;
  try
    Result := Not ExisteSQL('SELECT 1 FROM '+dbname+'.dbo.DETABLES WHERE DT_PREFIXE="AFF"');
  except
  end;
end;

Initialization

Finalization
  FreeAndNil(VH_Doss);

end.
