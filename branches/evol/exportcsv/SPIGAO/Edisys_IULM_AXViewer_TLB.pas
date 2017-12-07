unit Edisys_IULM_AXViewer_TLB;

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
// Bibl. types : C:\Program Files (x86)\Edisys\IULM\x86\Edisys.IULM.AXViewer.tlb (1)
// LIBID: {E4442298-F916-4372-804D-B3B01B261217}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : 
// DepndLst: 
//   (1) v2.0 mscorlib, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\mscorlib.tlb)
//   (2) v2.0 System, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.tlb)
//   (3) v2.0 System_Windows_Forms, (C:\Windows\Microsoft.NET\Framework\v2.0.50727\System.Windows.Forms.tlb)
//   (4) v2.2 Edisys_IULM_Core, (C:\Program Files (x86)\Edisys\IULM\x86\Edisys.IULM.Core.tlb)
//   (5) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// Erreurs :
//   Erreur � la cr�ation du bitmap de palette de (TDocumentViewer) : Cl� de registre CLSID\{713C7960-0964-4D42-B771-D1AF99C0EBC7}\ToolboxBitmap32 non trouv�e
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

uses Windows, ActiveX, Classes, Edisys_IULM_Core_TLB, Graphics, mscorlib_TLB, OleCtrls, OleServer, 
StdVCL, System_TLB, System_Windows_Forms_TLB, Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  Edisys_IULM_AXViewerMajorVersion = 2;
  Edisys_IULM_AXViewerMinorVersion = 2;

  LIBID_Edisys_IULM_AXViewer: TGUID = '{E4442298-F916-4372-804D-B3B01B261217}';

  CLASS_DocumentViewer: TGUID = '{713C7960-0964-4D42-B771-D1AF99C0EBC7}';
type

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  DocumentViewer = IDocumentViewer;



// *********************************************************************//
// D�claration de classe proxy de contr�le OLE
// Nom du contr�le      : TDocumentViewer
// Cha�ne d'aide        : 
// Interface par d�faut : IDocumentViewer
// DISP Int. D�f. ?     : Yes
// Interface �v�nements : 
// TypeFlags            : (2) CanCreate
// *********************************************************************//
  TDocumentViewer = class(TOleControl)
  private
    FIntf: IDocumentViewer;
    function  GetControlInterface: IDocumentViewer;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Show(const Project: IProject);
    function NavigateTo(const Project: IProject; const workItemId: WideString; 
                        documentType: ComDocumentType): WordBool;
    property  ControlInterface: IDocumentViewer read GetControlInterface;
    property  DefaultInterface: IDocumentViewer read GetControlInterface;
  published
    property Anchors;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TDocumentViewer.InitControlData;
const
  CControlData: TControlData2 = (
    ClassID: '{713C7960-0964-4D42-B771-D1AF99C0EBC7}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TDocumentViewer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IDocumentViewer;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TDocumentViewer.GetControlInterface: IDocumentViewer;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TDocumentViewer.Show(const Project: IProject);
begin
  DefaultInterface.Show(Project);
end;

function TDocumentViewer.NavigateTo(const Project: IProject; const workItemId: WideString; 
                                    documentType: ComDocumentType): WordBool;
begin
  Result := DefaultInterface.NavigateTo(Project, workItemId, documentType);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TDocumentViewer]);
end;

end.
