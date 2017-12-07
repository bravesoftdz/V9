unit CRCS5_TLB;

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

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// Fichier g�n�r� le 06/08/2001 11:40:29 depuis la biblioth�que de types ci-dessous.

// ************************************************************************ //
// Bibl.Types     : Y:\PgiS5\VDEV\Prospect\CRCS5.tlb (1)
// IID\LCID       : {53F352D6-702F-4F81-8DDD-782F69C61176}\0
// Fichier d'aide :
// DepndLst       : 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans v�rification de type des pointeurs. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Version majeure et mineure de la biblioth�que de types
  CRCS5MajorVersion = 1;
  CRCS5MinorVersion = 0;

  LIBID_CRCS5: TGUID = '{53F352D6-702F-4F81-8DDD-782F69C61176}';

  IID_IGRCWINDOW: TGUID = '{6F339FD2-EF7F-47CD-8801-281A43B91FB4}';
  CLASS_GRCWINDOW: TGUID = '{B4519199-7216-4B34-9DF9-B8E04D68059D}';
type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IGRCWINDOW = interface;
  IGRCWINDOWDisp = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClass � son Interface par d�faut)              
// *********************************************************************//
  GRCWINDOW = IGRCWINDOW;


// *********************************************************************//
// Interface   : IGRCWINDOW
// Indicateurs : (4416) Dual OleAutomation Dispatchable
// GUID        : {6F339FD2-EF7F-47CD-8801-281A43B91FB4}
// *********************************************************************//
  IGRCWINDOW = interface(IDispatch)
    ['{6F339FD2-EF7F-47CD-8801-281A43B91FB4}']
    function  GRCCumulPersp(const etat: WideString; datcredeb: TDateTime; datcrefin: TDateTime; 
                            datfinviedeb: TDateTime; datfinviefin: TDateTime): OleVariant; safecall;
    function  GRCRechDOMOLE(const TT: WideString; const Code: WideString): OleVariant; safecall;
    procedure GRCInitDico; safecall;
    procedure GRCNewDico; safecall;
    procedure GRCShowDico; safecall;
    procedure GRCFreeDico; safecall;
  end;

// *********************************************************************//
// DispIntf:  IGRCWINDOWDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F339FD2-EF7F-47CD-8801-281A43B91FB4}
// *********************************************************************//
  IGRCWINDOWDisp = dispinterface
    ['{6F339FD2-EF7F-47CD-8801-281A43B91FB4}']
    function  GRCCumulPersp(const etat: WideString; datcredeb: TDateTime; datcrefin: TDateTime; 
                            datfinviedeb: TDateTime; datfinviefin: TDateTime): OleVariant; dispid 1;
    function  GRCRechDOMOLE(const TT: WideString; const Code: WideString): OleVariant; dispid 2;
    procedure GRCInitDico; dispid 3;
    procedure GRCNewDico; dispid 4;
    procedure GRCShowDico; dispid 5;
    procedure GRCFreeDico; dispid 6;
  end;

// *********************************************************************//
// La classe CoGRCWINDOW fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IGRCWINDOW expos�e             
// pas la CoClass GRCWINDOW. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClass expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoGRCWINDOW = class
    class function Create: IGRCWINDOW;
    class function CreateRemote(const MachineName: string): IGRCWINDOW;
  end;

implementation

uses ComObj;

class function CoGRCWINDOW.Create: IGRCWINDOW;
begin
  Result := CreateComObject(CLASS_GRCWINDOW) as IGRCWINDOW;
end;

class function CoGRCWINDOW.CreateRemote(const MachineName: string): IGRCWINDOW;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_GRCWINDOW) as IGRCWINDOW;
end;

end.
