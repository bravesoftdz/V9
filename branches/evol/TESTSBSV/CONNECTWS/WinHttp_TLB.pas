unit WinHttp_TLB;

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
// Fichier g�n�r� le 27/09/2016 15:57:12 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\Users\paillard\Desktop\winhttp.tlb (1)
// LIBID: {662901FC-6951-4854-9EB2-D9A2570F2B2E}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : Microsoft WinHttp Services, version 5.1
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans pointeur � type contr�l�. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  WinHttpMajorVersion = 5;
  WinHttpMinorVersion = 1;

  LIBID_WinHttp: TGUID = '{662901FC-6951-4854-9EB2-D9A2570F2B2E}';

  IID_IWinHttpRequest: TGUID = '{016FE2EC-B2C8-45F8-B23B-39E53A75396B}';
  IID_IWinHttpRequestEvents: TGUID = '{F97F4E15-B787-4212-80D1-D380CBBF982E}';
  CLASS_WinHttpRequest: TGUID = '{2087C2F4-2CEF-4953-A8AB-66779B670495}';

// *********************************************************************//
// D�claration d'�num�rations d�finies dans la biblioth�que de types    
// *********************************************************************//
// Constantes pour enum WinHttpRequestOption
type
  WinHttpRequestOption = TOleEnum;
const
  WinHttpRequestOption_UserAgentString = $00000000;
  WinHttpRequestOption_URL = $00000001;
  WinHttpRequestOption_URLCodePage = $00000002;
  WinHttpRequestOption_EscapePercentInURL = $00000003;
  WinHttpRequestOption_SslErrorIgnoreFlags = $00000004;
  WinHttpRequestOption_SelectCertificate = $00000005;
  WinHttpRequestOption_EnableRedirects = $00000006;
  WinHttpRequestOption_UrlEscapeDisable = $00000007;
  WinHttpRequestOption_UrlEscapeDisableQuery = $00000008;
  WinHttpRequestOption_SecureProtocols = $00000009;
  WinHttpRequestOption_EnableTracing = $0000000A;
  WinHttpRequestOption_RevertImpersonationOverSsl = $0000000B;
  WinHttpRequestOption_EnableHttpsToHttpRedirects = $0000000C;
  WinHttpRequestOption_EnablePassportAuthentication = $0000000D;
  WinHttpRequestOption_MaxAutomaticRedirects = $0000000E;
  WinHttpRequestOption_MaxResponseHeaderSize = $0000000F;
  WinHttpRequestOption_MaxResponseDrainSize = $00000010;
  WinHttpRequestOption_EnableHttp1_1 = $00000011;
  WinHttpRequestOption_EnableCertificateRevocationCheck = $00000012;
  WinHttpRequestOption_RejectUserpwd = $00000013;

// Constantes pour enum WinHttpRequestAutoLogonPolicy
type
  WinHttpRequestAutoLogonPolicy = TOleEnum;
const
  AutoLogonPolicy_Always = $00000000;
  AutoLogonPolicy_OnlyIfBypassProxy = $00000001;
  AutoLogonPolicy_Never = $00000002;

// Constantes pour enum WinHttpRequestSslErrorFlags
type
  WinHttpRequestSslErrorFlags = TOleEnum;
const
  SslErrorFlag_UnknownCA = $00000100;
  SslErrorFlag_CertWrongUsage = $00000200;
  SslErrorFlag_CertCNInvalid = $00001000;
  SslErrorFlag_CertDateInvalid = $00002000;
  SslErrorFlag_Ignore_All = $00003300;

// Constantes pour enum WinHttpRequestSecureProtocols
type
  WinHttpRequestSecureProtocols = TOleEnum;
const
  SecureProtocol_SSL2 = $00000008;
  SecureProtocol_SSL3 = $00000020;
  SecureProtocol_TLS1 = $00000080;
  SecureProtocol_TLS1_1 = $00000200;
  SecureProtocol_TLS1_2 = $00000800;
  SecureProtocol_ALL = $000000A8;

type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IWinHttpRequest = interface;
  IWinHttpRequestDisp = dispinterface;
  IWinHttpRequestEvents = interface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  WinHttpRequest = IWinHttpRequest;


// *********************************************************************//
// D�claration de structures, d'unions et d'alias.                        
// *********************************************************************//
  PPSafeArray1 = ^PSafeArray; {*}

  HTTPREQUEST_PROXY_SETTING = Integer; 
  HTTPREQUEST_SETCREDENTIALS_FLAGS = Integer; 

// *********************************************************************//
// Interface   : IWinHttpRequest
// Indicateurs : (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID        : {016FE2EC-B2C8-45F8-B23B-39E53A75396B}
// *********************************************************************//
  IWinHttpRequest = interface(IDispatch)
    ['{016FE2EC-B2C8-45F8-B23B-39E53A75396B}']
    procedure SetProxy(ProxySetting: HTTPREQUEST_PROXY_SETTING; ProxyServer: OleVariant; 
                       BypassList: OleVariant); safecall;
    procedure SetCredentials(const UserName: WideString; const Password: WideString; 
                             Flags: HTTPREQUEST_SETCREDENTIALS_FLAGS); safecall;
    procedure Open(const Method: WideString; const Url: WideString; Async: OleVariant); safecall;
    procedure SetRequestHeader(const Header: WideString; const Value: WideString); safecall;
    function GetResponseHeader(const Header: WideString): WideString; safecall;
    function GetAllResponseHeaders: WideString; safecall;
    procedure Send(Body: OleVariant); safecall;
    function Get_Status: Integer; safecall;
    function Get_StatusText: WideString; safecall;
    function Get_ResponseText: WideString; safecall;
    function Get_ResponseBody: OleVariant; safecall;
    function Get_ResponseStream: OleVariant; safecall;
    function Get_Option(Option: WinHttpRequestOption): OleVariant; safecall;
    procedure Set_Option(Option: WinHttpRequestOption; Value: OleVariant); safecall;
    function WaitForResponse(Timeout: OleVariant): WordBool; safecall;
    procedure Abort; safecall;
    procedure SetTimeouts(ResolveTimeout: Integer; ConnectTimeout: Integer; SendTimeout: Integer; 
                          ReceiveTimeout: Integer); safecall;
    procedure SetClientCertificate(const ClientCertificate: WideString); safecall;
    procedure SetAutoLogonPolicy(AutoLogonPolicy: WinHttpRequestAutoLogonPolicy); safecall;
    property Status: Integer read Get_Status;
    property StatusText: WideString read Get_StatusText;
    property ResponseText: WideString read Get_ResponseText;
    property ResponseBody: OleVariant read Get_ResponseBody;
    property ResponseStream: OleVariant read Get_ResponseStream;
    property Option[Option: WinHttpRequestOption]: OleVariant read Get_Option write Set_Option;
  end;

// *********************************************************************//
// DispIntf :  IWinHttpRequestDisp
// Flags :     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID :      {016FE2EC-B2C8-45F8-B23B-39E53A75396B}
// *********************************************************************//
  IWinHttpRequestDisp = dispinterface
    ['{016FE2EC-B2C8-45F8-B23B-39E53A75396B}']
    procedure SetProxy(ProxySetting: HTTPREQUEST_PROXY_SETTING; ProxyServer: OleVariant; 
                       BypassList: OleVariant); dispid 13;
    procedure SetCredentials(const UserName: WideString; const Password: WideString; 
                             Flags: HTTPREQUEST_SETCREDENTIALS_FLAGS); dispid 14;
    procedure Open(const Method: WideString; const Url: WideString; Async: OleVariant); dispid 1;
    procedure SetRequestHeader(const Header: WideString; const Value: WideString); dispid 2;
    function GetResponseHeader(const Header: WideString): WideString; dispid 3;
    function GetAllResponseHeaders: WideString; dispid 4;
    procedure Send(Body: OleVariant); dispid 5;
    property Status: Integer readonly dispid 7;
    property StatusText: WideString readonly dispid 8;
    property ResponseText: WideString readonly dispid 9;
    property ResponseBody: OleVariant readonly dispid 10;
    property ResponseStream: OleVariant readonly dispid 11;
    property Option[Option: WinHttpRequestOption]: OleVariant dispid 6;
    function WaitForResponse(Timeout: OleVariant): WordBool; dispid 15;
    procedure Abort; dispid 12;
    procedure SetTimeouts(ResolveTimeout: Integer; ConnectTimeout: Integer; SendTimeout: Integer; 
                          ReceiveTimeout: Integer); dispid 16;
    procedure SetClientCertificate(const ClientCertificate: WideString); dispid 17;
    procedure SetAutoLogonPolicy(AutoLogonPolicy: WinHttpRequestAutoLogonPolicy); dispid 18;
  end;

// *********************************************************************//
// Interface   : IWinHttpRequestEvents
// Indicateurs : (384) NonExtensible OleAutomation
// GUID        : {F97F4E15-B787-4212-80D1-D380CBBF982E}
// *********************************************************************//
  IWinHttpRequestEvents = interface(IUnknown)
    ['{F97F4E15-B787-4212-80D1-D380CBBF982E}']
    procedure OnResponseStart(Status: Integer; const ContentType: WideString); stdcall;
    procedure OnResponseDataAvailable(var Data: PSafeArray); stdcall;
    procedure OnResponseFinished; stdcall;
    procedure OnError(ErrorNumber: Integer; const ErrorDescription: WideString); stdcall;
  end;

// *********************************************************************//
// La classe CoWinHttpRequest fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IWinHttpRequest expos�e             
// par la CoClasse WinHttpRequest. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoWinHttpRequest = class
    class function Create: IWinHttpRequest;
    class function CreateRemote(const MachineName: string): IWinHttpRequest;
  end;

implementation

uses ComObj;

class function CoWinHttpRequest.Create: IWinHttpRequest;
begin
  Result := CreateComObject(CLASS_WinHttpRequest) as IWinHttpRequest;
end;

class function CoWinHttpRequest.CreateRemote(const MachineName: string): IWinHttpRequest;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WinHttpRequest) as IWinHttpRequest;
end;

end.
