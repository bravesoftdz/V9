unit ETOBACTIVE_TLB;

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
// Fichier g�n�r� le 31/07/2001 16:49:35 depuis la biblioth�que de types ci-dessous.

// ************************************************************************ //
// Bibl.Types     : Y:\PgiS5\VDEV\Gescom\LibEC\ETOBACTIVE.tlb (1)
// IID\LCID       : {E86A1F53-9EB6-4D78-8463-A42EB3D22C16}\0
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
  ETOBACTIVEMajorVersion = 1;
  ETOBACTIVEMinorVersion = 0;

  LIBID_ETOBACTIVE: TGUID = '{E86A1F53-9EB6-4D78-8463-A42EB3D22C16}';

  IID_ITOBActive: TGUID = '{C66A60D3-522F-46D2-864D-52DCFD9C3B8A}';
  CLASS_TOBActive: TGUID = '{F57812CB-8A8A-485E-B8EE-E9C274A79D25}';
type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  ITOBActive = interface;
  ITOBActiveDisp = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClass � son Interface par d�faut)              
// *********************************************************************//
  TOBActive = ITOBActive;


// *********************************************************************//
// Interface   : ITOBActive
// Indicateurs : (4416) Dual OleAutomation Dispatchable
// GUID        : {C66A60D3-522F-46D2-864D-52DCFD9C3B8A}
// *********************************************************************//
  ITOBActive = interface(IDispatch)
    ['{C66A60D3-522F-46D2-864D-52DCFD9C3B8A}']
    procedure OnStartPage(const AScriptingContext: IUnknown); safecall;
    procedure OnEndPage; safecall;
    function  EGETTARIF(FichierIni: OleVariant; NomSoc: OleVariant; CodeArt: OleVariant; 
                        TarifArticle: OleVariant; CodeTiers: OleVariant; TarifTiers: OleVariant; 
                        CodeDevise: OleVariant; CodeDepot: OleVariant; LaDate: OleVariant; 
                        Qte: OleVariant; RemiseTiers: OleVariant; var LePrix: OleVariant; 
                        var LaRemise: OleVariant): OleVariant; safecall;
    function  EGETTAUXTVA(FichierIni: OleVariant; NomSoc: OleVariant; Regime: OleVariant; 
                          Code: OleVariant): OleVariant; safecall;
    procedure EGetDBParams(FichierIni: OleVariant; NomSoc: OleVariant; var StDriver: OleVariant; 
                           var StServer: OleVariant; var StPath: OleVariant; 
                           var StODBC: OleVariant; var StBase: OleVariant; var StUser: OleVariant; 
                           var StPassWord: OleVariant; var StOptions: OleVariant); safecall;
    function  EGETTARIF_WP(CodeArt: OleVariant; TarifArticle: OleVariant; CodeTiers: OleVariant; 
                           TarifTiers: OleVariant; CodeDevise: OleVariant; CodeDepot: OleVariant; 
                           LaDate: OleVariant; Qte: OleVariant; RemiseTiers: OleVariant; 
                           var LePrix: OleVariant; var LaRemise: OleVariant; StDriver: OleVariant; 
                           StServer: OleVariant; StPath: OleVariant; StODBC: OleVariant; 
                           StBase: OleVariant; StUser: OleVariant; StPassWord: OleVariant; 
                           StOptions: OleVariant): OleVariant; safecall;
    procedure EGetInfosDossier(FichierIni: OleVariant; NomSoc: OleVariant; 
                               var DevisePivot: OleVariant; var TenueEuro: OleVariant; 
                               var DepotDefaut: OleVariant); safecall;
  end;

// *********************************************************************//
// DispIntf:  ITOBActiveDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C66A60D3-522F-46D2-864D-52DCFD9C3B8A}
// *********************************************************************//
  ITOBActiveDisp = dispinterface
    ['{C66A60D3-522F-46D2-864D-52DCFD9C3B8A}']
    procedure OnStartPage(const AScriptingContext: IUnknown); dispid 1;
    procedure OnEndPage; dispid 2;
    function  EGETTARIF(FichierIni: OleVariant; NomSoc: OleVariant; CodeArt: OleVariant; 
                        TarifArticle: OleVariant; CodeTiers: OleVariant; TarifTiers: OleVariant; 
                        CodeDevise: OleVariant; CodeDepot: OleVariant; LaDate: OleVariant; 
                        Qte: OleVariant; RemiseTiers: OleVariant; var LePrix: OleVariant; 
                        var LaRemise: OleVariant): OleVariant; dispid 8;
    function  EGETTAUXTVA(FichierIni: OleVariant; NomSoc: OleVariant; Regime: OleVariant; 
                          Code: OleVariant): OleVariant; dispid 9;
    procedure EGetDBParams(FichierIni: OleVariant; NomSoc: OleVariant; var StDriver: OleVariant; 
                           var StServer: OleVariant; var StPath: OleVariant; 
                           var StODBC: OleVariant; var StBase: OleVariant; var StUser: OleVariant; 
                           var StPassWord: OleVariant; var StOptions: OleVariant); dispid 3;
    function  EGETTARIF_WP(CodeArt: OleVariant; TarifArticle: OleVariant; CodeTiers: OleVariant; 
                           TarifTiers: OleVariant; CodeDevise: OleVariant; CodeDepot: OleVariant; 
                           LaDate: OleVariant; Qte: OleVariant; RemiseTiers: OleVariant; 
                           var LePrix: OleVariant; var LaRemise: OleVariant; StDriver: OleVariant; 
                           StServer: OleVariant; StPath: OleVariant; StODBC: OleVariant; 
                           StBase: OleVariant; StUser: OleVariant; StPassWord: OleVariant; 
                           StOptions: OleVariant): OleVariant; dispid 4;
    procedure EGetInfosDossier(FichierIni: OleVariant; NomSoc: OleVariant; 
                               var DevisePivot: OleVariant; var TenueEuro: OleVariant; 
                               var DepotDefaut: OleVariant); dispid 5;
  end;

// *********************************************************************//
// La classe CoTOBActive fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut ITOBActive expos�e             
// pas la CoClass TOBActive. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClass expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoTOBActive = class
    class function Create: ITOBActive;
    class function CreateRemote(const MachineName: string): ITOBActive;
  end;

implementation

uses ComObj;

class function CoTOBActive.Create: ITOBActive;
begin
  Result := CreateComObject(CLASS_TOBActive) as ITOBActive;
end;

class function CoTOBActive.CreateRemote(const MachineName: string): ITOBActive;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TOBActive) as ITOBActive;
end;

end.
