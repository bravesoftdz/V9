unit VBA_TLB;

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
// Fichier g�n�r� le 18/07/2011 10:56:09 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\Windows\system32\MSVBVM60.DLL (1)
// LIBID: {000204EF-0000-0000-C000-000000000046}
// LCID: 9
// Fichier d'aide : C:\Windows\system32\VBA.HLP
// Cha�ne d'aide : Visual Basic For Applications
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
// Biblioth�que de types parent :
//   (0) v7.1 PDFCreator, (C:\Program Files\PDFCreator\PDFCreator.exe)
// Erreurs :
//   Conseil : Membre 'String' de '_HiddenInterface' modifi� en 'String_'
//   Conseil : Membre 'Raise' de '_ErrObject' modifi� en 'Raise_'
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
  VBAMajorVersion = 6;
  VBAMinorVersion = 0;

  LIBID_VBA: TGUID = '{000204EF-0000-0000-C000-000000000046}';

  IID__HiddenInterface: TGUID = '{1E196B20-1F3C-1069-996B-00DD010EF676}';
  IID__ErrObject: TGUID = '{A4C466B8-499F-101B-BB78-00AA00383CBB}';
  CLASS_ErrObject: TGUID = '{A4C46654-499F-101B-BB78-00AA00383CBB}';
  IID__Collection: TGUID = '{A4C46780-499F-101B-BB78-00AA00383CBB}';
  CLASS_Collection: TGUID = '{A4C4671C-499F-101B-BB78-00AA00383CBB}';

// *********************************************************************//
// D�claration d'�num�rations d�finies dans la biblioth�que de types    
// *********************************************************************//
// Constantes pour enum VbVarType
type
  VbVarType = TOleEnum;
const
  vbEmpty = $00000000;
  vbNull = $00000001;
  vbInteger = $00000002;
  vbLong = $00000003;
  vbSingle = $00000004;
  vbDouble = $00000005;
  vbCurrency = $00000006;
  vbDate = $00000007;
  vbString = $00000008;
  vbObject = $00000009;
  vbError = $0000000A;
  vbBoolean = $0000000B;
  vbVariant = $0000000C;
  vbDataObject = $0000000D;
  vbDecimal = $0000000E;
  vbByte = $00000011;
  vbUserDefinedType = $00000024;
  vbArray = $00002000;

// Constantes pour enum VbMsgBoxStyle
type
  VbMsgBoxStyle = TOleEnum;
const
  vbOKOnly = $00000000;
  vbOKCancel = $00000001;
  vbAbortRetryIgnore = $00000002;
  vbYesNoCancel = $00000003;
  vbYesNo = $00000004;
  vbRetryCancel = $00000005;
  vbCritical = $00000010;
  vbQuestion = $00000020;
  vbExclamation = $00000030;
  vbInformation = $00000040;
  vbDefaultButton1 = $00000000;
  vbDefaultButton2 = $00000100;
  vbDefaultButton3 = $00000200;
  vbDefaultButton4 = $00000300;
  vbApplicationModal = $00000000;
  vbSystemModal = $00001000;
  vbMsgBoxHelpButton = $00004000;
  vbMsgBoxRight = $00080000;
  vbMsgBoxRtlReading = $00100000;
  vbMsgBoxSetForeground = $00010000;

// Constantes pour enum VbMsgBoxResult
type
  VbMsgBoxResult = TOleEnum;
const
  vbOK = $00000001;
  vbCancel = $00000002;
  vbAbort = $00000003;
  vbRetry = $00000004;
  vbIgnore = $00000005;
  vbYes = $00000006;
  vbNo = $00000007;

// Constantes pour enum VbFileAttribute
type
  VbFileAttribute = TOleEnum;
const
  vbNormal = $00000000;
  vbReadOnly = $00000001;
  vbHidden = $00000002;
  vbSystem = $00000004;
  vbVolume = $00000008;
  vbDirectory = $00000010;
  vbArchive = $00000020;
  vbAlias = $00000040;

// Constantes pour enum VbStrConv
type
  VbStrConv = TOleEnum;
const
  vbUpperCase = $00000001;
  vbLowerCase = $00000002;
  vbProperCase = $00000003;
  vbWide = $00000004;
  vbNarrow = $00000008;
  vbKatakana = $00000010;
  vbHiragana = $00000020;
  vbUnicode = $00000040;
  vbFromUnicode = $00000080;

// Constantes pour enum VbDayOfWeek
type
  VbDayOfWeek = TOleEnum;
const
  vbUseSystemDayOfWeek = $00000000;
  vbSunday = $00000001;
  vbMonday = $00000002;
  vbTuesday = $00000003;
  vbWednesday = $00000004;
  vbThursday = $00000005;
  vbFriday = $00000006;
  vbSaturday = $00000007;

// Constantes pour enum VbFirstWeekOfYear
type
  VbFirstWeekOfYear = TOleEnum;
const
  vbUseSystem = $00000000;
  vbFirstJan1 = $00000001;
  vbFirstFourDays = $00000002;
  vbFirstFullWeek = $00000003;

// Constantes pour enum VbIMEStatus
type
  VbIMEStatus = TOleEnum;
const
  vbIMENoOp = $00000000;
  vbIMEModeNoControl = $00000000;
  vbIMEOn = $00000001;
  vbIMEModeOn = $00000001;
  vbIMEOff = $00000002;
  vbIMEModeOff = $00000002;
  vbIMEDisable = $00000003;
  vbIMEModeDisable = $00000003;
  vbIMEHiragana = $00000004;
  vbIMEModeHiragana = $00000004;
  vbIMEKatakanaDbl = $00000005;
  vbIMEModeKatakana = $00000005;
  vbIMEKatakanaSng = $00000006;
  vbIMEModeKatakanaHalf = $00000006;
  vbIMEAlphaDbl = $00000007;
  vbIMEModeAlphaFull = $00000007;
  vbIMEAlphaSng = $00000008;
  vbIMEModeAlpha = $00000008;
  vbIMEModeHangulFull = $00000009;
  vbIMEModeHangul = $0000000A;

// Constantes pour enum VbAppWinStyle
type
  VbAppWinStyle = TOleEnum;
const
  vbHide = $00000000;
  vbNormalFocus = $00000001;
  vbMinimizedFocus = $00000002;
  vbMaximizedFocus = $00000003;
  vbNormalNoFocus = $00000004;
  vbMinimizedNoFocus = $00000006;

// Constantes pour enum VbCompareMethod
type
  VbCompareMethod = TOleEnum;
const
  vbBinaryCompare = $00000000;
  vbTextCompare = $00000001;
  vbDatabaseCompare = $00000002;

// Constantes pour enum VbCalendar
type
  VbCalendar = TOleEnum;
const
  vbCalGreg = $00000000;
  vbCalHijri = $00000001;

// Constantes pour enum VbDateTimeFormat
type
  VbDateTimeFormat = TOleEnum;
const
  vbGeneralDate = $00000000;
  vbLongDate = $00000001;
  vbShortDate = $00000002;
  vbLongTime = $00000003;
  vbShortTime = $00000004;

// Constantes pour enum VbTriState
type
  VbTriState = TOleEnum;
const
  vbUseDefault = $FFFFFFFE;
  vbTrue = $FFFFFFFF;
  vbFalse = $00000000;

// Constantes pour enum VbCallType
type
  VbCallType = TOleEnum;
const
  VbMethod = $00000001;
  VbGet = $00000002;
  VbLet = $00000004;
  VbSet = $00000008;

type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  _HiddenInterface = interface;
  _ErrObject = interface;
  _ErrObjectDisp = dispinterface;
  _Collection = interface;
  _CollectionDisp = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  ErrObject = _ErrObject;
  Collection = _Collection;


// *********************************************************************//
// D�claration de structures, d'unions et d'alias.                        
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PPSafeArray1 = ^PSafeArray; {*}
  PPSafeArray2 = ^PSafeArray; {*}


// *********************************************************************//
// Interface   : _HiddenInterface
// Indicateurs : (0)
// GUID        : {1E196B20-1F3C-1069-996B-00DD010EF676}
// *********************************************************************//
  _HiddenInterface = interface
    ['{1E196B20-1F3C-1069-996B-00DD010EF676}']
    procedure LCase; stdcall;
    procedure Left; stdcall;
    procedure LTrim; stdcall;
    procedure Right; stdcall;
    procedure RTrim; stdcall;
    procedure Space; stdcall;
    procedure Trim; stdcall;
    procedure String_; stdcall;
    procedure UCase; stdcall;
    procedure Str; stdcall;
    procedure Chr; stdcall;
    procedure Date; stdcall;
    procedure Time; stdcall;
    procedure Hex; stdcall;
    procedure Oct; stdcall;
    procedure LeftB; stdcall;
    procedure RightB; stdcall;
    procedure Mid; stdcall;
    procedure MidB; stdcall;
    procedure StrConv; stdcall;
    procedure Error; stdcall;
    procedure CurDir; stdcall;
    procedure Format; stdcall;
    procedure Environ; stdcall;
    procedure Command; stdcall;
    procedure ChrB; stdcall;
    procedure ChrW; stdcall;
  end;

// *********************************************************************//
// Interface   : _ErrObject
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {A4C466B8-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _ErrObject = interface(IDispatch)
    ['{A4C466B8-499F-101B-BB78-00AA00383CBB}']
    function Get_Number: Integer; safecall;
    procedure Set_Number(pi4: Integer); safecall;
    function Get_Source: WideString; safecall;
    procedure Set_Source(const pbstr: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const pbstr: WideString); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const pbstr: WideString); safecall;
    function Get_HelpContext: Integer; safecall;
    procedure Set_HelpContext(pi4: Integer); safecall;
    procedure Raise_(Number: Integer; var Source: OleVariant; var Description: OleVariant; 
                     var HelpFile: OleVariant; var HelpContext: OleVariant); safecall;
    procedure Clear; stdcall;
    function Get_LastDllError: Integer; safecall;
    property Number: Integer read Get_Number write Set_Number;
    property Source: WideString read Get_Source write Set_Source;
    property Description: WideString read Get_Description write Set_Description;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property HelpContext: Integer read Get_HelpContext write Set_HelpContext;
    property LastDllError: Integer read Get_LastDllError;
  end;

// *********************************************************************//
// DispIntf :  _ErrObjectDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {A4C466B8-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _ErrObjectDisp = dispinterface
    ['{A4C466B8-499F-101B-BB78-00AA00383CBB}']
    property Number: Integer dispid 0;
    property Source: WideString dispid 1610743810;
    property Description: WideString dispid 1610743812;
    property HelpFile: WideString dispid 1610743814;
    property HelpContext: Integer dispid 1610743816;
    procedure Raise_(Number: Integer; var Source: OleVariant; var Description: OleVariant; 
                     var HelpFile: OleVariant; var HelpContext: OleVariant); dispid 1610743818;
    procedure Clear; dispid 1610743819;
    property LastDllError: Integer readonly dispid 1610743820;
  end;

// *********************************************************************//
// Interface   : _Collection
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {A4C46780-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _Collection = interface(IDispatch)
    ['{A4C46780-499F-101B-BB78-00AA00383CBB}']
    function Item(var Index: OleVariant): OleVariant; safecall;
    procedure Add(var Item: OleVariant; var Key: OleVariant; var Before: OleVariant; 
                  var After: OleVariant); safecall;
    function Count: Integer; safecall;
    procedure Remove(var Index: OleVariant); safecall;
    function _NewEnum: IUnknown; safecall;
  end;

// *********************************************************************//
// DispIntf :  _CollectionDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {A4C46780-499F-101B-BB78-00AA00383CBB}
// *********************************************************************//
  _CollectionDisp = dispinterface
    ['{A4C46780-499F-101B-BB78-00AA00383CBB}']
    function Item(var Index: OleVariant): OleVariant; dispid 0;
    procedure Add(var Item: OleVariant; var Key: OleVariant; var Before: OleVariant; 
                  var After: OleVariant); dispid 1;
    function Count: Integer; dispid 2;
    procedure Remove(var Index: OleVariant); dispid 3;
    function _NewEnum: IUnknown; dispid -4;
  end;

// *********************************************************************//
// La classe CoErrObject fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut _ErrObject expos�e             
// par la CoClasse ErrObject. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoErrObject = class
    class function Create: _ErrObject;
    class function CreateRemote(const MachineName: string): _ErrObject;
  end;

// *********************************************************************//
// La classe CoCollection fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut _Collection expos�e             
// par la CoClasse Collection. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoCollection = class
    class function Create: _Collection;
    class function CreateRemote(const MachineName: string): _Collection;
  end;

implementation

uses ComObj;

class function CoErrObject.Create: _ErrObject;
begin
  Result := CreateComObject(CLASS_ErrObject) as _ErrObject;
end;

class function CoErrObject.CreateRemote(const MachineName: string): _ErrObject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ErrObject) as _ErrObject;
end;

class function CoCollection.Create: _Collection;
begin
  Result := CreateComObject(CLASS_Collection) as _Collection;
end;

class function CoCollection.CreateRemote(const MachineName: string): _Collection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Collection) as _Collection;
end;

end.
