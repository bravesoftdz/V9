unit Edisys_IULM_Updater_TLB;

// ************************************************************************ //
// AVERTISSEMENT                                                                 
// -------                                                                    
// Les types d�clar�s dans ce fichier ont �t� g�n�r�s � partir de donn�es lues 
// depuis la biblioth�que de types. Si cette derni�re (via une autre biblioth�que de types 
// s'y r�f�rant) est explicitement ou indirectement r�-import�e, ou la commande "Rafra�chir"  
// de l'�diteur de biblioth�que de types est activ�e lors de la modification de la biblioth�que 
// de types, le contenu de ce fichier sera r�g�n�r� et toutes les modifications      
// manuellement apport�es seront perdues.                                     
// ************************************************************************ //

// PASTLWTR : 1.2
// Fichier g�n�r� le 27/06/2012 15:25:58 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\Program Files (x86)\Edisys\IULM\x86\Edisys.IULM.Updater.tlb (1)
// LIBID: {1D17E365-4FE8-494D-B18B-733420A26600}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
// Erreurs :
//   Erreur � la cr�ation du bitmap de palette de (TSpigaoUpdater) : Le serveur mscoree.dll ne contient pas d'ic�nes
// ************************************************************************ //
// *************************************************************************//
// REMARQUE :                                                                      
// Les �l�ments gard�s par $IFDEF_LIVE_SERVER_AT_DESIGN_TIME sont  utilis�s 
// par des propri�t�s qui renvoient des objets pouvant n�cessiter d'�tre  
// explicitement cr��s par un appel de fonction avant tout acc�s via la   
// propri�t�. Ces �l�ments ont �t� d�sactiv�s afin de pr�venir une utilisation  
// accidentelle depuis l'inspecteur d'objets. Vous pouvez les activer en d�finissant  
// LIVE_SERVER_AT_DESIGN_TIME ou en les retirant s�lectivement des blocs 
//  $IFDEF. Cependant, ces �l�ments doivent toujours �tre cr��s par programmation
//  via une m�thode de la CoClasse appropri�e avant d'�tre utilis�s.                          
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans pointeur � type contr�l�. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, mscorlib_TLB, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  Edisys_IULM_UpdaterMajorVersion = 1;
  Edisys_IULM_UpdaterMinorVersion = 0;

  LIBID_Edisys_IULM_Updater: TGUID = '{1D17E365-4FE8-494D-B18B-733420A26600}';

  DIID_ISpigaoUpdater: TGUID = '{6AA6C6F4-8938-4049-A1DE-CD25C069D3B0}';
  CLASS_SpigaoUpdater: TGUID = '{D03D750A-7FA8-45C0-8212-BA2BC11D8415}';
type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  ISpigaoUpdater = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  SpigaoUpdater = ISpigaoUpdater;


// *********************************************************************//
// DispIntf :  ISpigaoUpdater
// Flags :     (4096) Dispatchable
// GUID :      {6AA6C6F4-8938-4049-A1DE-CD25C069D3B0}
// *********************************************************************//
  ISpigaoUpdater = dispinterface
    ['{6AA6C6F4-8938-4049-A1DE-CD25C069D3B0}']
    property LastErrorMessage: WideString readonly dispid 1;
    function IsUpdateAvailable: WordBool; dispid 128;
    function Update: WordBool; dispid 129;
  end;

// *********************************************************************//
// La classe CoSpigaoUpdater fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut ISpigaoUpdater expos�e             
// par la CoClasse SpigaoUpdater. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoSpigaoUpdater = class
    class function Create: ISpigaoUpdater;
    class function CreateRemote(const MachineName: string): ISpigaoUpdater;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TSpigaoUpdater
// Cha�ne d'aide        : 
// Interface par d�faut : ISpigaoUpdater
// DISP Int. D�f. ?     : Yes
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TSpigaoUpdaterProperties= class;
{$ENDIF}
  TSpigaoUpdater = class(TOleServer)
  private
    FIntf:        ISpigaoUpdater;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TSpigaoUpdaterProperties;
    function      GetServerProperties: TSpigaoUpdaterProperties;
{$ENDIF}
    function      GetDefaultInterface: ISpigaoUpdater;
  protected
    procedure InitServerData; override;
    function Get_LastErrorMessage: WideString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: ISpigaoUpdater);
    procedure Disconnect; override;
    function IsUpdateAvailable: WordBool;
    function Update: WordBool;
    property DefaultInterface: ISpigaoUpdater read GetDefaultInterface;
    property LastErrorMessage: WideString read Get_LastErrorMessage;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TSpigaoUpdaterProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TSpigaoUpdater
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TSpigaoUpdaterProperties = class(TPersistent)
  private
    FServer:    TSpigaoUpdater;
    function    GetDefaultInterface: ISpigaoUpdater;
    constructor Create(AServer: TSpigaoUpdater);
  protected
    function Get_LastErrorMessage: WideString;
  public
    property DefaultInterface: ISpigaoUpdater read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoSpigaoUpdater.Create: ISpigaoUpdater;
begin
  Result := CreateComObject(CLASS_SpigaoUpdater) as ISpigaoUpdater;
end;

class function CoSpigaoUpdater.CreateRemote(const MachineName: string): ISpigaoUpdater;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_SpigaoUpdater) as ISpigaoUpdater;
end;

procedure TSpigaoUpdater.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{D03D750A-7FA8-45C0-8212-BA2BC11D8415}';
    IntfIID:   '{6AA6C6F4-8938-4049-A1DE-CD25C069D3B0}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TSpigaoUpdater.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as ISpigaoUpdater;
  end;
end;

procedure TSpigaoUpdater.ConnectTo(svrIntf: ISpigaoUpdater);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TSpigaoUpdater.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TSpigaoUpdater.GetDefaultInterface: ISpigaoUpdater;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TSpigaoUpdater.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TSpigaoUpdaterProperties.Create(Self);
{$ENDIF}
end;

destructor TSpigaoUpdater.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TSpigaoUpdater.GetServerProperties: TSpigaoUpdaterProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TSpigaoUpdater.Get_LastErrorMessage: WideString;
begin
    Result := DefaultInterface.LastErrorMessage;
end;

function TSpigaoUpdater.IsUpdateAvailable: WordBool;
begin
  Result := DefaultInterface.IsUpdateAvailable;
end;

function TSpigaoUpdater.Update: WordBool;
begin
  Result := DefaultInterface.Update;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TSpigaoUpdaterProperties.Create(AServer: TSpigaoUpdater);
begin
  inherited Create;
  FServer := AServer;
end;

function TSpigaoUpdaterProperties.GetDefaultInterface: ISpigaoUpdater;
begin
  Result := FServer.DefaultInterface;
end;

function TSpigaoUpdaterProperties.Get_LastErrorMessage: WideString;
begin
    Result := DefaultInterface.LastErrorMessage;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TSpigaoUpdater]);
end;

end.
