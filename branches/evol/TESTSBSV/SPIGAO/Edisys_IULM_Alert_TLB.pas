unit Edisys_IULM_Alert_TLB;

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
// Fichier g�n�r� le 26/02/2014 11:17:05 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\Program Files\Edisys\IULM\x86\Edisys.IULM.Alert.tlb (1)
// LIBID: {F80E576F-2CF6-41AE-AEB5-6DD998D1DBF6}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : 
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
//   (2) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
//   (3) v3.2 Edisys_IULM_Core, (C:\Program Files\Edisys\IULM\x86\Edisys.IULM.Core.tlb)
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

uses Windows, ActiveX, Classes, Edisys_IULM_Core_TLB, Graphics, mscorlib_TLB, OleServer, StdVCL, 
Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  Edisys_IULM_AlertMajorVersion = 3;
  Edisys_IULM_AlertMinorVersion = 2;

  LIBID_Edisys_IULM_Alert: TGUID = '{F80E576F-2CF6-41AE-AEB5-6DD998D1DBF6}';

  CLASS_ResultEventArgs: TGUID = '{CAF58E65-2F4F-4EA2-B19D-9861606D002B}';
  IID__ResultHandler: TGUID = '{7BE49544-9221-36AB-B7C7-E11F2AABC728}';
  CLASS_DetectionAlerts: TGUID = '{755155DC-AB81-4DAC-AD64-EAA36EE27501}';
  CLASS_ResultHandler: TGUID = '{8506CD28-4910-4E51-B6CF-7B30C3B4D1F3}';
type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  _ResultHandler = interface;
  _ResultHandlerDisp = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  ResultEventArgs = IResultEventArgs;
  DetectionAlerts = IDetectionAlerts;
  ResultHandler = _ResultHandler;


// *********************************************************************//
// Interface   : _ResultHandler
// Indicateurs : (4432) Hidden Dual OleAutomation Dispatchable
// GUID        : {7BE49544-9221-36AB-B7C7-E11F2AABC728}
// *********************************************************************//
  _ResultHandler = interface(IDispatch)            
    ['{7BE49544-9221-36AB-B7C7-E11F2AABC728}']
  end;

// *********************************************************************//
// DispIntf :  _ResultHandlerDisp
// Flags :     (4432) Hidden Dual OleAutomation Dispatchable
// GUID :      {7BE49544-9221-36AB-B7C7-E11F2AABC728}
// *********************************************************************//
  _ResultHandlerDisp = dispinterface
    ['{7BE49544-9221-36AB-B7C7-E11F2AABC728}']
  end;

// *********************************************************************//
// La classe CoResultEventArgs fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IResultEventArgs expos�e             
// par la CoClasse ResultEventArgs. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoResultEventArgs = class
    class function Create: IResultEventArgs;
    class function CreateRemote(const MachineName: string): IResultEventArgs;
  end;

// *********************************************************************//
// La classe CoDetectionAlerts fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IDetectionAlerts expos�e             
// par la CoClasse DetectionAlerts. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoDetectionAlerts = class
    class function Create: IDetectionAlerts;
    class function CreateRemote(const MachineName: string): IDetectionAlerts;
  end;

// *********************************************************************//
// La classe CoResultHandler fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut _ResultHandler expos�e             
// par la CoClasse ResultHandler. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoResultHandler = class
    class function Create: _ResultHandler;
    class function CreateRemote(const MachineName: string): _ResultHandler;
  end;

implementation

uses ComObj;

class function CoResultEventArgs.Create: IResultEventArgs;
begin
  Result := CreateComObject(CLASS_ResultEventArgs) as IResultEventArgs;
end;

class function CoResultEventArgs.CreateRemote(const MachineName: string): IResultEventArgs;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ResultEventArgs) as IResultEventArgs;
end;

class function CoDetectionAlerts.Create: IDetectionAlerts;
begin
  Result := CreateComObject(CLASS_DetectionAlerts) as IDetectionAlerts;
end;

class function CoDetectionAlerts.CreateRemote(const MachineName: string): IDetectionAlerts;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DetectionAlerts) as IDetectionAlerts;
end;

class function CoResultHandler.Create: _ResultHandler;
begin
  Result := CreateComObject(CLASS_ResultHandler) as _ResultHandler;
end;

class function CoResultHandler.CreateRemote(const MachineName: string): _ResultHandler;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ResultHandler) as _ResultHandler;
end;

end.
