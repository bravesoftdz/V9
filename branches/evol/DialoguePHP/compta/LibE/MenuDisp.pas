{***********UNITE*************************************************
Auteur  ...... : Djamel ZEDIAR
Cr�� le ...... : 28/01/2001
Modifi� le ... : 28/01/2003
Description .. : Importation des �ventuels bobs
Mots clefs ... :
*****************************************************************}
unit MenuDisp;

interface
Uses Classes, ImgList, Controls, HEnt1,
  Ent1,
 Entpgi,
//  HCtrls,
  galOutil,
  AnnOutils,
{$ifdef eAGLClient}
  MenuOLX,MaineAGL,eTablette,utileagl,
{$else}
  MenuOLG,Tablette,FE_Main,EdtEtat,
{$endif eAGLClient}
  Forms,
  sysutils,
  messages,
  HMsgBox,
  HPanel,
  UIUtil,
  AglInitPlus,
  AGLInit,
  TOFEMPIMP,
  UCreCommun,
   (* Ajout GED*)
  UTob,
{$ifdef eAGLClient}
  eMul,
{$ELSE}
   Mul,
{$ENDIF}
  UGedFiles, YnewDocument;
  (* Fin Ajout GED*)
Procedure InitApplication ;

type
  TFMenuDisp = class(TDatamodule)
  ImageList1: TImageList;
    private
    SeriaGedOk : Boolean;
    end ;

Var FMenuDisp : TFMenuDisp ; gBoInitialisation : Boolean;


implementation

{$R *.DFM}
// uses FRevision;
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
Procedure Initialisation;
begin
   if gBoInitialisation then Exit;
   gBoInitialisation := True;

   // Init de la compta
   ChargeMagExo(False);

   //Pour que l'icone reste dans le popup plaquette du lanceur
  if V_PGI.RunFromLanceur then
    SetFlagAppli('CRES5.EXE', True);

   // Importation des bobs �ventuels
//   ExecuteSQL('Delete From YMYBOBS Where YB_BOBNAME = "CRES50600D001"');
   PCL_IMPORT_BOB('CRES5');

   // S�lection
   AGLLanceFiche('FP','FMULEMPRUNT','','','');

end;
(* Ajout GED*)
procedure MyAfterImport (Sender: TObject; FileGuid: string; var Cancel: Boolean) ;
var
 ParGed : TParamGedDoc;
 x:string;
begin
    if FileGuid = '' then exit;
    if (TForm(Sender) is TFMul) and (TForm(Sender).name = 'FMULEMPRUNT') then // PAR EXEMPLE !!
    begin
        // Description par d�faut du document � archiver...
        x:=TFMUL(Sender).LaTOF.GetField('EMP_CODEEMPRUNT');
        ParGed.DefName := 'Pi�ce jointe � l''emprunt n� ' + x;
    end
    else
    begin
        // Description par d�faut du document � archiver...
        if Sender is TForm then ParGed.DefName := TForm(Sender).Caption;
    end;
    // Propose le rangement dans la GED
    ParGed.SDocGUID := '';
    ParGed.NoDossier := V_PGI.NoDossier;
    ParGed.CodeGed := '';
    // FileId est le n� de fichier obtenu par la GED suite � l'insertion
    ParGed.SFileGUID := FileGuid;

    Application.BringToFront;

    if ((not (ctxPCL in V_PGI.PGIContexte )) or ((ctxPCL in V_PGI.PGIContexte) and (JaileDroitConceptBureau (187315)))) then
    begin
       if ShowNewDocument(ParGed)='##NONE##' then
         // Fichier refus�, suppression dans la GED
          V_GedFiles.Erase(FileGuid);
    end
    else
    begin
        V_GedFiles.Erase(FileGuid);
        PGIInfo ('Vous n''avez pas les droits d''insertion dans la GED.',TitreHalley);
    end;
end ;
(* Fin Ajout GED*)

Procedure Dispatch ( Num : Integer ; PRien : THPanel ; var retourforce,sortiehalley : boolean);
BEGIN
   case Num of
        10 : //Apres connection directe
        begin
//           if not V_PGI.RunFromLanceur then
           Initialisation;
(* Ajout GED*)
            {IFNDEF EAGL}
            V_PGI.QRPdf := True;
             if FMenuDisp.SeriaGedOk then
               InitializeGedFiles(V_PGI.DbName, MyAfterImport);
            {ENDIF}
(* Fin Ajout GED*)
        end;
     11 : ; //Apr�s deconnection
     12 : //Avant connection ou seria
        begin
        end;
     13 :  //Avant deconnection
         //  FinalizeGedFiles;
         FinalizeGedFiles;
     15 :  //Avant formshow
        begin
        end;
     16 :
        begin
           Initialisation;
        end;
     100 :  //Apres connection depuis le lanceur
        begin
//           if V_PGI.RunFromLanceur then
           Initialisation;
           if FMenuDisp.SeriaGedOk then
            InitializeGedFiles(V_PGI.DefaultSectionDBName, MyAfterImport);
        end;
     1105 : ;
     61110 :
        // S�lection d'emprunt
        begin
           AGLLanceFiche('FP','FMULEMPRUNT','','','');
        end;
     61120 :
        begin
             // Editions synth�tiques
           if EstSerialise then
             LancerEditions;
          //  LancerRevPaie;
           //   LancerRevision;
        end;
     //
     else HShowMessage('2;?caption?;Fonction non disponible : ;W;O;O;O;',TitreHalley,IntToStr(Num)) ;
     end ;

//     FMenug.Caption := TitreHalley;

END ;


{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette fonction est appel�e par l'AGL a chaque fois qu'un
Suite ........ : utilisateur click sur un bouton de param�trage d'un combo.
Suite ........ : Le param�tre NUM est la valeur qui est affect�e dans la
Suite ........ : zone Tag des tablettes.
Mots clefs ... : TABLETTE;COMBO
*****************************************************************}
Procedure DispatchTT ( Num : Integer ; Action : TActionFiche ; Lequel,TT,Range : String ) ;
BEGIN
{   case Num of
     80 :  AglLanceFiche ( 'XXX', 'YYYYY', '', LeQuel, '' ) ;
     99310 : AglLancefiche ('FP','XFOURNISSEUR','','','');
     end ;}
END ;

Procedure AfterProtec ( sAcces : String ) ;
begin
   VH^.OkModCre := (sAcces[1] = 'X');
   if (Length(sAcces)>=1) and (sAcces[1]='X') then FMenuDisp.SeriaGedOk := True;

end;

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
procedure InitApplication ;
begin
     { R�f�rence � la fonction de gestion de l'hyperzoom }
//     ProcZoomEdt := ZoomEdtEtat ;

     { R�f�rence � la fonction de gestion @ dans les �tats }
//     ProcCalcEdt := CalcArobaseEtat ;

     { R�f�rence � la fonction qui permet dans les tablettes de faire l'interpr�tation
       d'un condition de la forme WHERE G_GENERAUX="VH^.CHAMP3" ... , pour l'instant
       utilis� que dans la comptabilit�. }
{$IFDEF EAGLCLIENT}
{$ELSE}
//     ProcGetVH   := GetVS1 ;
{$ENDIF}

     { R�f�rence � une fonction qui permet d'avoir des dates suppl�mentaires particuli�res
       D�but d'exercice, exercice suivant, ... }
{$IFDEF EAGLCLIENT}
{$ELSE}
//     ProcGetDate := GetDate ;
{$ENDIF}

     { R�f�rence � la fonction PRINCIPALE qui permet de lancer les actions en fonction de la
       s�lection d'une option des menus.
       }

     FMenuG.OnDispatch:=Dispatch ;

     { R�f�rence � une fonction qui est lanc�e apr�s la connexion � la base et le chargement du dictionnaire }
     FMenuG.OnChargeMag:=Nil ;

     { R�f�rence � une fonction qui est lanc�e avant la mise � jour de structure }
     FMenuG.OnMajAvant:=Nil ;

     { R�f�rence � une fonction qui est lanc�e pendant la mise � jour de structure }
{$IFDEF EAGLCLIENT}
{$ELSE}
//     FMenuG.OnMajpendant:=Nil ;
{$ENDIF}       //Dans ['00054042'],Changer seulement les 3 derniers chiffres
 //    FMenuG.SetSeria('00280011',['00054042'],['CRE S5']) ;
     FMenuG.SetSeria('00280011', ['00054065','00119065'], ['CRE S5','GED']);

     FMenuG.OnAfterProtec:=AfterProtec;

     { R�f�rence � une fonction qui est lanc�e apr�s la mise � jour de structure }
     FMenuG.OnMajApres:=Nil ;

     { Renseigne les n� de modules ( menu ) que l'application doit g�rer }
     FMenuG.SetModules([61],[0]) ;
     //FMenuG.FPassword.Text:='';

     { R�f�rence � une fonction qui permet de lancer des actions dans le cas ou l'on autorise
     le param�trage d'un combo dans une fiche de saisie.
     Il faut aussi dans ce cas renseigner le n� de tag au niveau de la tablette correspondante. }
     V_PGI.DispatchTT := DispatchTT ;
     (* Ajout GED *)
     V_PGI.TabletteHierarchiques := True;
     (* Fin Ajout GED *)

END ;

Procedure InitLaVariablePGI;
Begin
  {Version}
     { Ce nom appara�t en haut � gauche dans la fen�tre Inside }
     Apalatys:='CEGID' ;

     { Ce nom appara�t dans le caption de l'application, c'est aussi le clef dans la BDR pour le
       stockage des informations pr�f�rence de l'application. }
     NomHalley:='Calcul de Remboursement d''Emprunts' ;

     { Ce nom appara�t en bas � gauche de l'application }
     TitreHalley:='Calcul de Remboursement d''Emprunt PGI Expert' ;

     { Pr�cise le nom du fichier ini utilis� par l'application. Normalement CEGIDPGI.INI }
     HalSocIni:='cegidpgi.ini' ;

     { Ce nom appara�t en bas � gauche de l'application }
     Copyright:='� Copyright ' + Apalatys ;

   //  V_PGI.NumVersion:='4.2.0' ; V_PGI.NumBuild:='800.0' ;
     V_PGI.NumVersion:='7.00' ; V_PGI.NumBuild:='002.0' ;
     V_PGI.DateVersion:=EncodeDate(2006,05,04) ;

     { Pr�cise la s�rie. Cela modifie l'affichage OutLook }
     V_PGI.LaSerie:=S5 ;
     V_PGI.OutLook:=TRUE ;
     V_PGI.OfficeMsg:=TRUE ;
     V_PGI.ToolsBarRight:=TRUE ;
     //Je ne sais pas � quoi cela sert, mais modifs du 24/10/2003
//     V_PGI.PGIContexte := [ctxPcl];
     V_PGI.CegidUpdateServerParams:= 'www.update.cegid.fr';
     V_PGI.CascadeForms :=True;

     ChargeXuelib ;
     V_PGI.VersionDemo:=False ;
     V_PGI.ImpMatrix := True ;
     V_PGI.OKOuvert:=FALSE ;
     V_PGI.Halley:=TRUE ;
     V_PGI.NiveauAccesConf:=0 ;
     V_PGI.MenuCourant:=0 ;
     V_PGI.NumVersionBase:=744;
     V_PGI.QRPdf := FALSE;

     V_PGI.VersionReseau  := True;         // permet de rendre certaines actions mono-utilisateur (fcts blocagemonoposte, existeblocage...)
     V_PGI.StandardSurDP  := TRUE;         // indispensable pour l'aiguillage entre le DP et les bases dossiers (gamme Expert), voir SQL025
     V_PGI.PGIContexte    := [ctxCompta,ctxPcl]; //
     V_PGI.CegidBureau    := TRUE;         // permet � l'application d'�tre pilot�e par le lanceur
     V_PGI.CegidApalatys  := False;        //
     V_PGI.MajPredefini   := TRUE;         //
End;

initialization
  ProcChargeV_PGI :=  InitLaVariablePGI ;

end.
