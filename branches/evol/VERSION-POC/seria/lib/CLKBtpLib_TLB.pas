unit CLKBtpLib_TLB;

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
// Fichier g�n�r� le 17/12/2009 13:16:06 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\WINDOWS\system32\CLKBtp.dll (1)
// LIBID: {03E4880B-E1F7-4F3A-AC96-0F1E227D92D7}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : Biblioth�que de types CLKBtp 1.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// Erreurs :
//   Erreur � la cr�ation du bitmap de palette de (TBuilder) : Le serveur C:\WINDOWS\system32\CLKBtp.dll ne contient pas d'ic�nes
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

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  CLKBtpLibMajorVersion = 1;
  CLKBtpLibMinorVersion = 0;

  LIBID_CLKBtpLib: TGUID = '{03E4880B-E1F7-4F3A-AC96-0F1E227D92D7}';

  IID_IBuilder: TGUID = '{B0D592CB-7D9A-4968-A897-C07A62512867}';
  CLASS_Builder: TGUID = '{746E59FD-BB06-41E8-A0DB-4A67E4D9EC93}';
type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IBuilder = interface;
  IBuilderDisp = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  Builder = IBuilder;


// *********************************************************************//
// Interface   : IBuilder
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {B0D592CB-7D9A-4968-A897-C07A62512867}
// *********************************************************************//
  IBuilder = interface(IDispatch)
    ['{B0D592CB-7D9A-4968-A897-C07A62512867}']
    function GetKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer): WideString; safecall;
    function GetTempKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer; 
                        LastMonth: Integer; LastYear: Integer): WideString; safecall;
  end;

// *********************************************************************//
// DispIntf :  IBuilderDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {B0D592CB-7D9A-4968-A897-C07A62512867}
// *********************************************************************//
  IBuilderDisp = dispinterface
    ['{B0D592CB-7D9A-4968-A897-C07A62512867}']
    function GetKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer): WideString; dispid 1;
    function GetTempKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer; 
                        LastMonth: Integer; LastYear: Integer): WideString; dispid 3;
  end;

// *********************************************************************//
// La classe CoBuilder fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IBuilder expos�e             
// par la CoClasse Builder. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoBuilder = class
    class function Create: IBuilder;
    class function CreateRemote(const MachineName: string): IBuilder;
  end;


// *********************************************************************//
// D�claration de classe proxy de serveur OLE
// Objet serveur        : TBuilder
// Cha�ne d'aide        : Builder Class
// Interface par d�faut : IBuilder
// DISP Int. D�f. ?     : No
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TBuilderProperties= class;
{$ENDIF}
  TBuilder = class(TOleServer)
  private
    FIntf:        IBuilder;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TBuilderProperties;
    function      GetServerProperties: TBuilderProperties;
{$ENDIF}
    function      GetDefaultInterface: IBuilder;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IBuilder);
    procedure Disconnect; override;
    function GetKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer): WideString;
    function GetTempKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer; 
                        LastMonth: Integer; LastYear: Integer): WideString;
    property DefaultInterface: IBuilder read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TBuilderProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// Classe proxy Propri�t�s Serveur OLE
// Objet serveur    : TBuilder
// (Cet objet est utilis� pas l'inspecteur de propri�t� de l'EDI pour la 
//  modification des propri�t�s de ce serveur)
// *********************************************************************//
 TBuilderProperties = class(TPersistent)
  private
    FServer:    TBuilder;
    function    GetDefaultInterface: IBuilder;
    constructor Create(AServer: TBuilder);
  protected
  public
    property DefaultInterface: IBuilder read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoBuilder.Create: IBuilder;
begin
  Result := CreateComObject(CLASS_Builder) as IBuilder;
end;

class function CoBuilder.CreateRemote(const MachineName: string): IBuilder;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Builder) as IBuilder;
end;

procedure TBuilder.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{746E59FD-BB06-41E8-A0DB-4A67E4D9EC93}';
    IntfIID:   '{B0D592CB-7D9A-4968-A897-C07A62512867}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TBuilder.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IBuilder;
  end;
end;

procedure TBuilder.ConnectTo(svrIntf: IBuilder);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TBuilder.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TBuilder.GetDefaultInterface: IBuilder;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface est NULL. Le composant n''est pas connect� au serveur. Vous devez appeler ''Connect'' ou ''ConnectTo'' avant cette op�ration');
  Result := FIntf;
end;

constructor TBuilder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TBuilderProperties.Create(Self);
{$ENDIF}
end;

destructor TBuilder.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TBuilder.GetServerProperties: TBuilderProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TBuilder.GetKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer): WideString;
begin
  Result := DefaultInterface.GetKey(HdwId, ProductCodeVer, LicenseNum);
end;

function TBuilder.GetTempKey(HdwId: Integer; const ProductCodeVer: WideString; LicenseNum: Integer; 
                             LastMonth: Integer; LastYear: Integer): WideString;
begin
  Result := DefaultInterface.GetTempKey(HdwId, ProductCodeVer, LicenseNum, LastMonth, LastYear);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TBuilderProperties.Create(AServer: TBuilder);
begin
  inherited Create;
  FServer := AServer;
end;

function TBuilderProperties.GetDefaultInterface: IBuilder;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TBuilder]);
end;

end.

