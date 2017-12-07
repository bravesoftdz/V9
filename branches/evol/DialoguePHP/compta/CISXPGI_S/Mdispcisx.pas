{***********UNITE*************************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Dans cette unit�, on trouve LA FONCTION qui sera
Suite ........ : appel�e par l'AGL pour lancer les options.
Suite ........ : Ainsi que la gestion de l'HyperZoom, de la gestion de
Suite ........ : l'arobase, ...
Suite ........ : C'est aussi dans cette unit� que l'on d�fini le fichier ini
Suite ........ : utilis�, le nom de l'application, sa version, que l'on lance la
Suite ........ : s�rialisation, les diff�rentes possibilit�s d'action sur la mise �
Suite ........ : jour de structure, ...
Mots clefs ... : IMPORTANT;STRCTURE;MENU;SERIALISATION
*****************************************************************}
unit Mdispcisx;

interface
Uses
  Windows, Messages,
  HEnt1,
{$ifdef eAGLClient}
  MenuOLX,MaineAGL,eTablette, UtilEagl,
{$else}
  MenuOLG, FE_Main,
{$endif eAGLClient}
  Forms,sysutils,HMsgBox, Classes, Controls, HPanel,
  hctrls, MajTable,
  ExtCtrls, inifiles, UTOB, ImgList, LicUtil, UDMIMP, UExport;

Procedure InitApplication ;

type
  TFMenuDisp = class(TDatamodule)
    ImageList1  : TImageList;
    Timer1      : TTimer;
    end ;

Var FMenuDisp : TFMenuDisp ;


implementation

{$R *.DFM}
uses
USaveRestore;

Procedure GoMenu(SuperUser : Boolean) ;
BEGIN
  FMenuG.SetFunctions([TraduireMemoire('Scripts'),
                       TraduireMemoire('Restauration'),
                       TraduireMemoire('Sauvegarde'),
                       TraduireMemoire('G�n�ration simple')
                      ],
                      [45100, 45000, 45300, 45200],
                      [46, 40, 41, 45])
END ;

FUNCTION CHARGEMAGHALLEYGG : Boolean ;
Var SuperUser : Boolean ;
BEGIN
Result:=TRUE ;
SuperUser:=(V_PGI.PassWord=CryptageSt(DayPass(Date))) ;
GoMenu(SuperUser) ;
ChargeMenuPop(integer(hm2),FMenuG.DispatchX) ;
END ;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette fonction est appell�e par l'AGL � chaque s�lection
Suite ........ : d'une option de menu, en lui indiquant le TAG du menu en
Suite ........ : question. Ce qui d�clenche l'action en question.
Suite ........ : L'AGL lance aussi cette fonction directement afin d'offrir �
Suite ........ : l'application la possibilit� d'agir avant ou apr�s la connexion,
Suite ........ : et avant ou apr�s la d�connexion.
Suite ........ : Cette fonction prend aussi en param�tre retourForce et
Suite ........ : SortieHalley. Si RetourForce est � True, alors l'AGL
Suite ........ : remontera au niveau des modules, si SortieHalley est �
Suite ........ : True, alors ...
Mots clefs ... : MENU;OPTION;DISPATCH
*****************************************************************}


Procedure DispatchCom ( Num : Integer ; PRien : THPanel ; var retourforce,sortiehalley : boolean);
var
Numopt           : integer;
Stdpath,Dospath  : string;
BEGIN
     Numopt := Num;
   case Numopt of
     16    : ;
     10    :
     begin
           if V_PGI.StdPath[length (V_PGI.StdPath)] <> '\' then  Stdpath := V_PGI.StdPath+'\CISX'
           else Stdpath := V_PGI.StdPath+'CISX';
           if V_PGI.DosPath[length (V_PGI.DosPath)] <> '\' then  Stdpath := V_PGI.DosPath+'\CISX'
           else Dospath := V_PGI.DosPath+'CISX';

          InitDB (Stdpath, Dospath);
     end;
     11    : ;
     12    : ;
     13    : V_PGI.SAV:=FALSE ; //Avant deconnection
     15    : ;
     100   : ;
     45000 : SaveRestore(False, PRien);
     45300 : SaveRestore(TRUE, PRien);
     45100 : AglLanceFiche('CP','CPMULSCRIPT','', '', '')  ;
     45200 : ExportDonneesCISX(PRien);

  end ;
END ;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette proc�dure permet d'initiliaser certaines r�f�rence de
Suite ........ : fonction, les modules des menus g�r�s par l'application, ...
Suite ........ :
Suite ........ : Cette proc�dure est appel�e directement dans le source du
Suite ........ : projet.
Mots clefs ... : INITILISATION
*****************************************************************}

Procedure AfterProtec ( sAcces : String ) ;
BEGIN
V_PGI.VersionDemo:=FALSE ;
END ;


procedure InitApplication ;
begin
     { R�f�rence � la fonction PRINCIPALE qui permet de lancer les actions en fonction de la
       s�lection d'une option des menus.
       }
     FMenuG.OnDispatch        :=DispatchCom ;

     { R�f�rence � une fonction qui est lanc�e apr�s la connexion � la base et le chargement du dictionnaire }
     FMenuG.OnChargeMag       :=ChargeMagHalleyGG ;

     { R�f�rence � une fonction qui est lanc�e avant la mise � jour de structure }
     FMenuG.OnMajAvant        :=Nil ;

     { R�f�rence � une fonction qui est lanc�e pendant la mise � jour de structure }
     FMenuG.OnMajpendant       :=Nil ;
     FMenuG.Timer1.Enabled     := FALSE;

     { R�f�rence � une fonction qui est lanc�e apr�s la mise � jour de structure }
     FMenuG.OnMajApres          :=Nil ;
     FMenuG.OnChangeModule      :=nil ;
     FMenuG.OnAfterProtec       :=AfterProtec ;

     V_PGI.NumVersionBase       :=833 ;
     V_PGI.NumVersion           :='1.5' ;
     V_PGI.NumBuild             :='0' ;
     V_PGI.DateVersion          :=EncodeDate(2006,06,22) ;
     HalSocIni                  :='CEGIDPGI.INI' ;
     NomHalley                  := 'CISXPGI';
     TitreHalley                := 'Importateur PGI' ;
     V_PGI.LaSerie              := S5;
     Application.HelpFile       := '';
     Application.Title          := TitreHalley ;

END ;

Procedure InitLaVariablePGI;
Begin
Apalatys            :='CEGID' ;
Copyright           :='� Copyright ' + Apalatys ;

HalSocIni           :='CEGIDPGI.INI' ;
V_PGI.OutLook       :=FALSE ;
V_PGI.VersionDemo   :=FALSE ;
V_PGI.MenuCourant   :=0 ;
V_PGI.VersionDEV    :=TRUE ;
V_PGI.ImpMatrix     := True ;
V_PGI.OKOuvert      :=FALSE ;
V_PGI.Halley        :=TRUE ;
V_PGI.OfficeMsg     :=True ;
V_PGI.NumMenuPop    :=27 ;
V_PGI.DispatchTT    :=nil ;
V_PGI.ParamSocLast  :=False ;
V_PGI.RAZForme      :=TRUE ;
V_PGI.NoModuleButtons:=False ;
V_PGI.PGIContexte    :=[ctxCompta] ;
V_PGI.BlockMAJStruct :=True ;
V_PGI.EuroCertifiee  :=False ;

V_PGI.SAV            :=False ;
V_PGI.VersionReseau  :=True ;
V_PGI.CegidAPalatys  :=FALSE ;
V_PGI.CegidBureau    :=TRUE ;
V_PGI.StandardSurDP  :=True ;
V_PGI.MajPredefini   :=False ;
V_PGI.MultiUserLogin :=False ;

V_PGI.OfficeMsg      :=True ;
V_PGI.NoModuleButtons:=FALSE ;
V_PGI.NbColModuleButtons:=1 ;
V_PGI.LaSerie           := S5;
ChargeXuelib ;
end;

Initialization
  InitLaVariablePGI ;

end.
