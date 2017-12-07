unit Accessibility_TLB;

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
// Fichier g�n�r� le 27/06/2012 15:25:09 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\Windows\System32\oleacc.dll (1)
// LIBID: {1EA4DBF0-3C3B-11CF-810C-00AA00389B71}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// Biblioth�que de types parent :
//   (0) v2.2 Edisys_IULM_AXViewer, (C:\Program Files (x86)\Edisys\IULM\x86\Edisys.IULM.AXViewer.tlb)
// Erreurs :
//   Remarque : param�tre 'var' dans IAccPropServices.SetPropValue chang� en 'var_'
//   Remarque : param�tre 'var' dans IAccPropServices.SetHwndProp chang� en 'var_'
//   Remarque : param�tre 'var' dans IAccPropServices.SetHmenuProp chang� en 'var_'
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
  AccessibilityMajorVersion = 1;
  AccessibilityMinorVersion = 1;

  LIBID_Accessibility: TGUID = '{1EA4DBF0-3C3B-11CF-810C-00AA00389B71}';

  IID_IAccessible: TGUID = '{618736E0-3C3D-11CF-810C-00AA00389B71}';
  IID_IAccessibleHandler: TGUID = '{03022430-ABC4-11D0-BDE2-00AA001A1953}';
  IID_IAccIdentity: TGUID = '{7852B78D-1CFD-41C1-A615-9C0C85960B5F}';
  IID_IAccPropServer: TGUID = '{76C0DBBB-15E0-4E7B-B61B-20EEEA2001E0}';
  IID_IAccPropServices: TGUID = '{6E26E776-04F0-495D-80E4-3330352E3169}';
  CLASS_CAccPropServices: TGUID = '{B5F8350B-0548-48B1-A6EE-88BD00B4A5E7}';

// *********************************************************************//
// D�claration d'�num�rations d�finies dans la biblioth�que de types    
// *********************************************************************//
// Constantes pour enum AnnoScope
type
  AnnoScope = TOleEnum;
const
  ANNO_THIS = $00000000;
  ANNO_CONTAINER = $00000001;

type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IAccessible = interface;
  IAccessibleDisp = dispinterface;
  IAccessibleHandler = interface;
  IAccIdentity = interface;
  IAccPropServer = interface;
  IAccPropServices = interface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  CAccPropServices = IAccPropServices;


// *********************************************************************//
// D�claration de structures, d'unions et d'alias.                        
// *********************************************************************//
  wireHWND = ^_RemotableHandle; 
  wireHMENU = ^_RemotableHandle; 
  PByte1 = ^Byte; {*}
  PUserType1 = ^TGUID; {*}


  __MIDL_IWinTypes_0009 = record
    case Integer of
      0: (hInproc: Integer);
      1: (hRemote: Integer);
  end;

  _RemotableHandle = packed record
    fContext: Integer;
    u: __MIDL_IWinTypes_0009;
  end;


// *********************************************************************//
// Interface   : IAccessible
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessible = interface(IDispatch)
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    function Get_accParent: IDispatch; safecall;
    function Get_accChildCount: Integer; safecall;
    function Get_accChild(varChild: OleVariant): IDispatch; safecall;
    function Get_accName(varChild: OleVariant): WideString; safecall;
    function Get_accValue(varChild: OleVariant): WideString; safecall;
    function Get_accDescription(varChild: OleVariant): WideString; safecall;
    function Get_accRole(varChild: OleVariant): OleVariant; safecall;
    function Get_accState(varChild: OleVariant): OleVariant; safecall;
    function Get_accHelp(varChild: OleVariant): WideString; safecall;
    function Get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant): Integer; safecall;
    function Get_accKeyboardShortcut(varChild: OleVariant): WideString; safecall;
    function Get_accFocus: OleVariant; safecall;
    function Get_accSelection: OleVariant; safecall;
    function Get_accDefaultAction(varChild: OleVariant): WideString; safecall;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); safecall;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); safecall;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; safecall;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; safecall;
    procedure accDoDefaultAction(varChild: OleVariant); safecall;
    procedure Set_accName(varChild: OleVariant; const pszName: WideString); safecall;
    procedure Set_accValue(varChild: OleVariant; const pszValue: WideString); safecall;
    property accParent: IDispatch read Get_accParent;
    property accChildCount: Integer read Get_accChildCount;
    property accChild[varChild: OleVariant]: IDispatch read Get_accChild;
    property accName[varChild: OleVariant]: WideString read Get_accName write Set_accName;
    property accValue[varChild: OleVariant]: WideString read Get_accValue write Set_accValue;
    property accDescription[varChild: OleVariant]: WideString read Get_accDescription;
    property accRole[varChild: OleVariant]: OleVariant read Get_accRole;
    property accState[varChild: OleVariant]: OleVariant read Get_accState;
    property accHelp[varChild: OleVariant]: WideString read Get_accHelp;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer read Get_accHelpTopic;
    property accKeyboardShortcut[varChild: OleVariant]: WideString read Get_accKeyboardShortcut;
    property accFocus: OleVariant read Get_accFocus;
    property accSelection: OleVariant read Get_accSelection;
    property accDefaultAction[varChild: OleVariant]: WideString read Get_accDefaultAction;
  end;

// *********************************************************************//
// DispIntf :  IAccessibleDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessibleDisp = dispinterface
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface   : IAccessibleHandler
// Indicateurs : (272) Hidden OleAutomation
// GUID        : {03022430-ABC4-11D0-BDE2-00AA001A1953}
// *********************************************************************//
  IAccessibleHandler = interface(IUnknown)
    ['{03022430-ABC4-11D0-BDE2-00AA001A1953}']
    function AccessibleObjectFromID(hwnd: Integer; lObjectID: Integer; out pIAccessible: IAccessible): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IAccIdentity
// Indicateurs : (0)
// GUID        : {7852B78D-1CFD-41C1-A615-9C0C85960B5F}
// *********************************************************************//
  IAccIdentity = interface(IUnknown)
    ['{7852B78D-1CFD-41C1-A615-9C0C85960B5F}']
    function GetIdentityString(dwIDChild: LongWord; out ppIDString: PByte1; 
                               out pdwIDStringLen: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IAccPropServer
// Indicateurs : (0)
// GUID        : {76C0DBBB-15E0-4E7B-B61B-20EEEA2001E0}
// *********************************************************************//
  IAccPropServer = interface(IUnknown)
    ['{76C0DBBB-15E0-4E7B-B61B-20EEEA2001E0}']
    function GetPropValue(var pIDString: Byte; dwIDStringLen: LongWord; idProp: TGUID; 
                          out pvarValue: OleVariant; out pfHasProp: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface   : IAccPropServices
// Indicateurs : (0)
// GUID        : {6E26E776-04F0-495D-80E4-3330352E3169}
// *********************************************************************//
  IAccPropServices = interface(IUnknown)
    ['{6E26E776-04F0-495D-80E4-3330352E3169}']
    function SetPropValue(var pIDString: Byte; dwIDStringLen: LongWord; idProp: TGUID; 
                          var_: OleVariant): HResult; stdcall;
    function SetPropServer(var pIDString: Byte; dwIDStringLen: LongWord; var paProps: TGUID; 
                           cProps: SYSINT; const pServer: IAccPropServer; AnnoScope: AnnoScope): HResult; stdcall;
    function ClearProps(var pIDString: Byte; dwIDStringLen: LongWord; var paProps: TGUID; 
                        cProps: SYSINT): HResult; stdcall;
    function SetHwndProp(var hwnd: _RemotableHandle; idObject: LongWord; idChild: LongWord; 
                         idProp: TGUID; var_: OleVariant): HResult; stdcall;
    function SetHwndPropStr(var hwnd: _RemotableHandle; idObject: LongWord; idChild: LongWord; 
                            idProp: TGUID; str: PWideChar): HResult; stdcall;
    function SetHwndPropServer(var hwnd: _RemotableHandle; idObject: LongWord; idChild: LongWord; 
                               var paProps: TGUID; cProps: SYSINT; const pServer: IAccPropServer; 
                               AnnoScope: AnnoScope): HResult; stdcall;
    function ClearHwndProps(var hwnd: _RemotableHandle; idObject: LongWord; idChild: LongWord; 
                            var paProps: TGUID; cProps: SYSINT): HResult; stdcall;
    function ComposeHwndIdentityString(var hwnd: _RemotableHandle; idObject: LongWord; 
                                       idChild: LongWord; out ppIDString: PByte1; 
                                       out pdwIDStringLen: LongWord): HResult; stdcall;
    function DecomposeHwndIdentityString(var pIDString: Byte; dwIDStringLen: LongWord; 
                                         out phwnd: wireHWND; out pidObject: LongWord; 
                                         out pidChild: LongWord): HResult; stdcall;
    function SetHmenuProp(var hmenu: _RemotableHandle; idChild: LongWord; idProp: TGUID; 
                          var_: OleVariant): HResult; stdcall;
    function SetHmenuPropStr(var hmenu: _RemotableHandle; idChild: LongWord; idProp: TGUID; 
                             str: PWideChar): HResult; stdcall;
    function SetHmenuPropServer(var hmenu: _RemotableHandle; idChild: LongWord; var paProps: TGUID; 
                                cProps: SYSINT; const pServer: IAccPropServer; AnnoScope: AnnoScope): HResult; stdcall;
    function ClearHmenuProps(var hmenu: _RemotableHandle; idChild: LongWord; var paProps: TGUID; 
                             cProps: SYSINT): HResult; stdcall;
    function ComposeHmenuIdentityString(var hmenu: _RemotableHandle; idChild: LongWord; 
                                        out ppIDString: PByte1; out pdwIDStringLen: LongWord): HResult; stdcall;
    function DecomposeHmenuIdentityString(var pIDString: Byte; dwIDStringLen: LongWord; 
                                          out phmenu: wireHMENU; out pidChild: LongWord): HResult; stdcall;
  end;

// *********************************************************************//
// La classe CoCAccPropServices fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IAccPropServices expos�e             
// par la CoClasse CAccPropServices. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoCAccPropServices = class
    class function Create: IAccPropServices;
    class function CreateRemote(const MachineName: string): IAccPropServices;
  end;

implementation

uses ComObj;

class function CoCAccPropServices.Create: IAccPropServices;
begin
  Result := CreateComObject(CLASS_CAccPropServices) as IAccPropServices;
end;

class function CoCAccPropServices.CreateRemote(const MachineName: string): IAccPropServices;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CAccPropServices) as IAccPropServices;
end;

end.
