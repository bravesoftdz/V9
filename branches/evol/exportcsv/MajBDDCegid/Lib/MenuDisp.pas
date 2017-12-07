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
unit MenuDisp;
{$IFDEF HVCL}sdsdsd{$ENDIF}

interface

uses Windows,HEnt1, Ent1, EntPGI,LicUtil, ED_TOOLS,
  {$IFDEF eAGLClient}
    utileagl,
    MenuOLX,
    MaineAGL,
    eTablette,
  {$ELSE}
    MenuOLG,
    uedtcomp,
    Tablette,
    FE_Main,
    EdtEtat,
    {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF eAGLClient}
    Forms,
    sysutils,
    HMsgBox,
    Classes,
    Controls,
    HPanel,
    Hctrls,
    UIUtil,
    ImgList,
    AglInitPlus,
    AGLInit,
    MajTable,
    uBTPVerrouilleDossier,
    Messages,
    TraiteMajBDD,
    UgestionBobs;


procedure InitApplication;

type
  TFMenuDisp = class(TDatamodule)
    ImageList1: TImageList;
  end;

var
  FMenuDisp: TFMenuDisp;

FUNCTION ChargeMagHalleyLoc : Boolean ;

implementation

{$R *.DFM}

uses MenuSpec;        //Pour CGEP

function VerifSuperviseur: boolean;
begin
  Result := True;
  if not V_PGI.Superviseur then
  begin
    PGIBox('Vous n''avez pas les droits pour acc�der � cette application', 'Attention');
    Result := False;
    FMenuG.ForceClose := True;
    FMenuG.Close;
  end;
end;


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
procedure Dispatch(Num: Integer; PRien: THPanel; var retourforce, sortiehalley: boolean);
var stMessage : string;
begin

  case Num of
	  10: begin
          //Apres connection
          if (not ISUtilisable) then
          begin
             stMessage := 'Base de donn�es momentan�ment indisponible (mise � niveau en cours) ';
             stMessage := stMessage +#13#10 +'Veuillez r�essayer ult�rieurement';
             PGIInfo(stMessage,'Information de connection');
             FMenuG.ForceClose := True;
             PostMessage(FMenuG.Handle, WM_CLOSE, 0, 0);
             Application.ProcessMessages;
             Exit;
          end;
        end;
    11: ; //Apr�s deconnection
    12: ; //Avant connection ou seria
    13: ; //Avant deconnection
    15: ; //Avant formshow
    16: ;
    1105: ;
    450101 : begin
    					 LanceTraitementActualisationBDD;
               retourforce := True;
     				 end;
    450102 : begin
               LancegestionBobs;
               retourforce := True;
      			 End;
  else HShowMessage('2;?caption?;Fonction non disponible : ;W;O;O;O;', TitreHalley, IntToStr(Num));
  end;
end;

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
procedure DispatchTT(Num: Integer; Action: TActionFiche; Lequel, TT, Range: string);
begin
  case Num of
    80: AglLanceFiche('XXX', 'YYYYY', '', LeQuel, '');
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : cette proc�dure est appel�e par l'AGL � chaque fois que
Suite ........ : dans un �tat, il rencontre une formule, un champ, ...
Suite ........ : contenant @FONCTIONX([P1],[P2],...).
Suite ........ : L'AGL passe en param�tre � cette fonction, le nom de la
Suite ........ : fonction dans "sf" (en l'occurence "FONCTIONX" dans
Suite ........ : l'exemple si-dessus) et les param�tres s�par�s par des
Suite ........ : virgules dans "sp".
Mots clefs ... : @;FORMULE;FONCTION;ETAT
*****************************************************************}
function CalcArobaseEtat(sf, sp: string): variant;
begin
  {$IFDEF EXEMPLE_UTILISATION}
  { Valeur par d�faut si 'sf' est inconnue }
  Result := '';

  if sf = 'FONCTION1' then
  begin
    { Pour cette fonction, il doit y avoir 2 param�tres }
    Param1 := ReadTokenPipe(Sp, ',');
    Param2 := ValeurI(ReadTokenPipe(Sp, ','));

    Result := AppCalculValeur(Param1, Param2 * 100);
  end
  else if sf = 'FONCTION2' then
  begin
  end;
  {$ENDIF}
end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette proc�dure est appel�e par ZoomEdtEtat, et elle
Suite ........ : permet de lancer les fiches/paramtablette/... en fonction du
Suite ........ : code hyperzoom et de LeQuel.
Mots clefs ... : ZOOM;HYPERZOOM
*****************************************************************}
procedure ZoomEdt(Qui: integer; Quoi: string);
begin
  {$IFDEF EXEMPLE_UTILISATION}
  case Qui of
    80: AglLanceFiche('XXX', 'XFICHEX1', '', Quoi, 'ACTION=CONSULTATION');
    81: AglLanceFiche('XXX', 'XFICHEX2', '', Quoi, 'ACTION=CONSULTATION');
  end;
  Screen.Cursor := crDefault;
  {$ENDIF}
end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette proc�dure est appel�e par l'AGL quand l'utilisateur
Suite ........ : double-click sur un aper�u d'un �tat configur� pour la
Suite ........ : gestion de l'HyperZoom.
Suite ........ : Le param�tre "Quoi" contient le code du zoom ( valeur
Suite ........ : contenue dans la tablette TTZOOMEDT ), ainsi que la zone
Suite ........ : permettant de se positionner sur l'�l�ment en question. Les
Suite ........ : deux valeurs �tant s�par�es par un point-virgule.
Mots clefs ... : ZOOM;HYPERZOOM
*****************************************************************}
procedure ZoomEdtEtat(Quoi: string);
var
  i, Qui: integer;
begin

  i := Pos(';', Quoi);

  { Qui est le code de l'HyperZoom }
  Qui := StrToInt(Copy(Quoi, 1, i - 1));

  { Quoi est le code de l'�l�ment }
  Quoi := Copy(Quoi, i + 1, Length(Quoi) - i);

    if (Qui>=900) and (Qui<=999) and vmDisp_ZoomEdt( Qui,Quoi) then Exit ;   //Pour CGEP

  ZoomEdt(Qui, Quoi);

end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette function est appel�e � chaque fois que l'AGL
Suite ........ : rencontre une condition de la forme
Suite ........ : WHERE XX_YYYYYY="VH^.CHAMPX"
Suite ........ : dans les conditions des tablettes.
Mots clefs ... : TABLETTE;CONDITION;VH;COMPTA
*****************************************************************}
function GetVS1(S: string): string;
begin
  {$IFDEF EXEMPLE_UTILISATION}
  { Valeur par d�faut si 'S' est inconnue }
  Result := '';

  if S = 'VH^.CHAMP3' then Result := CProcCalculChampVH(S);
  {$ENDIF}
end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette fonction permet � l'application d'utiliser des
Suite ........ : "raccourcies" pour d�terminer les dates dans les �crans de
Suite ........ : saisie.
Suite ........ : Ainsi, si l'utilisateur saisie D, l'AGL va appeler cette fonction
Suite ........ : qui va lui retourner ( dans l'exemple ), la date de
Suite ........ : d�but de l'exercice  courant, ...
Mots clefs ... : DATE;RACCOURIE;SAISIE
*****************************************************************}
function GetDate(S: string): TDateTime;
  {$IFDEF EXEMPLE_UTILISATION}
var
  Year, Month, Day: WORD;
  {$ENDIF}
begin
  {$IFDEF EXEMPLE_UTILISATION}
  { Valeur par d�faut si 'S' est inconnue }
  Result := Now;

  if S = 'D' then { Date de D�but d'exercice }
  begin
    Result := ComptaDateDebutExercice;
  end
  else if S = 'F' then { Date de fin d'exercice }
  begin
    Result := ComptaFinDebutExercice;
  end
  else if S = 'G' then { Date de d�but du mois en cours }
  begin
    DecodeDate(Date, Year, Month, Day);
    Result := EncodeDate(Year, Month, 1);
  end;
  {$ELSE}
  result := Now ;
  {$ENDIF}
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
procedure InitApplication;
begin
  { R�f�rence � la fonction de gestion de l'hyperzoom }
  ProcZoomEdt := ZoomEdtEtat;

  { R�f�rence � la fonction de gestion @ dans les �tats }
  ProcCalcEdt := CalcArobaseEtat;

  { R�f�rence � la fonction qui permet dans les tablettes de faire l'interpr�tation
    d'un condition de la forme WHERE G_GENERAUX="VH^.CHAMP3" ... , pour l'instant
    utilis� que dans la comptabilit�. }
  {$IFDEF EAGLCLIENT}
  {$ELSE}
  ProcGetVH := GetVS1;
  {$ENDIF}

  { R�f�rence � une fonction qui permet d'avoir des dates suppl�mentaires particuli�res
    D�but d'exercice, exercice suivant, ... }
  {$IFDEF EAGLCLIENT}
  {$ELSE}
  ProcGetDate := GetDate;
  {$ENDIF}

  { R�f�rence � la fonction PRINCIPALE qui permet de lancer les actions en fonction de la
    s�lection d'une option des menus.
    }
  FMenuG.OnDispatch := Dispatch;

  { R�f�rence � une fonction qui est lanc�e apr�s la connexion � la base et le chargement du dictionnaire }
  FMenuG.OnChargeMag := ChargeMagHalleyLoc ;

  { R�f�rence � une fonction qui est lanc�e avant la mise � jour de structure }
  FMenuG.OnMajAvant := nil;

  { R�f�rence � une fonction qui est lanc�e pendant la mise � jour de structure }
  {$IFDEF EAGLCLIENT}
  {$ELSE}
  FMenuG.OnMajpendant := nil;
  {$ENDIF}

  { R�f�rence � une fonction qui est lanc�e apr�s la mise � jour de structure }
  FMenuG.OnMajApres := nil;

  { Renseigne les n� de modules ( menu ) que l'application doit g�rer }
  FMenuG.SetModules([450], [19]);

  { R�f�rence � une fonction qui permet de lancer des actions dans le cas ou l'on autorise
  le param�trage d'un combo dans une fiche de saisie.
  Il faut aussi dans ce cas renseigner le n� de tag au niveau de la tablette correspondante. }
  V_PGI.DispatchTT := DispatchTT;
end;

FUNCTION ChargeMagHalleyLoc : Boolean ;
var Q : TQuery;
		stmessage : string;
BEGIN
  result := true;
  VH^.ExoV8.Code:='' ; VH^.ExoV8.Deb:=0 ; VH^.ExoV8.Fin:=0 ;
  VH^.VNUMSOC:=500 ;
  V_PGI.CergEF:=FALSE ;

  Q:=OPENSQL('SELECT SO_VERSIONBASE FROM SOCIETE ',TRUE,-1,'',true) ;
  If Not Q.Eof Then VH^.VNUMSOC:=Q.Fields[0].AsInteger ;
  Ferme(Q) ;
  if v_pgi.NumversionBase>VH^.VNUMSOC then
  begin
    stMessage := 'Cette soci�t� (' + inttostr(VH^.VNUMSOC) + ') n�cessite une mise � jour de structure.';
    stMessage := stMessage +#13 +'Vous devez lancer l''utilitaire Administration de base PGI.';
    stMessage := stMessage +#13 ;
    stMessage := stMessage +#13 +'Contacter votre administrateur.';
    PGIInfo(stMessage,'Erreur de version de base');
    result := false ;
  end ;

  if not result then exit;
  if (not ISUtilisable) then
  begin
    stMessage := 'Base de donn�es momentan�ment indisponible (mise � niveau en cours) ';
    stMessage := stMessage +#13#10 +'Veuillez r�essayer ult�rieurement';
    PGIInfo(stMessage,'Information de connection');
    result := false;
  end;
END ;


initialization
  { Ce nom appara�t en haut � gauche dans la fen�tre Inside }
  Apalatys := 'LSE';

  { Ce nom appara�t dans le caption de l'application, c'est aussi le clef dans la BDR pour le
    stockage des informations pr�f�rence de l'application. }
  NomHalley := 'LSE';

  { Ce nom appara�t en bas � gauche de l'application }
  TitreHalley := 'Outil de migration base CEGID -> LSE';

  { Pr�cise le nom du fichier ini utilis� par l'application. Normalement CEGIDPGI.INI }
  HalSocIni := 'MigBDD.ini';

  { Ce nom appara�t en bas � gauche de l'application }
  Copyright := '� Copyright L.S.E';

  V_PGI.PGIContexte:=[ctxGescom,ctxAffaire,ctxBTP,ctxGRC];
  V_PGI.StandardSurDp := False;  // indispensable pour l'aiguillage entre le DP et les bases dossiers (gamme Expert), voir SQL025
  V_PGI.OutLook:=TRUE ;
  V_PGI.OfficeMsg:=TRUE ;
  V_PGI.ToolsBarRight:=TRUE ;
  ChargeXuelib ;
  V_PGI.VersionDemo:=false ;
  V_PGI.MenuCourant:=0 ;
  V_PGI.VersionReseau:=True ;
  V_PGI.NumVersion:='1.0.0' ;
  V_PGI.NumVersionBase:=998 ;
  V_PGI.NumBuild:='000.001';
  V_PGI.CodeProduit:='033' ;
  V_PGI.DateVersion:=EncodeDate(2011,06,23);
  V_PGI.ImpMatrix := True ;
  V_PGI.OKOuvert:=FALSE ;
  V_PGI.Halley:=TRUE ;
  V_PGI.BlockMAJStruct:=TRUE ;
  V_PGI.PortailWeb:='http://www.lse.fr/' ;
  V_PGI.CegidApalatys:=FALSE ;
  V_PGI.QRMultiThread:=TRUE;
  V_PGI.MenuCourant:=0 ;
  V_PGI.RazForme:=TRUE;
  V_PGI.NumMenuPop:=27 ;
  V_PGI.CegidBureau:= True;
  V_PGI.VersionDemo := True;   
  V_PGI.LookUpLocate:= True;   // utile pour les ellipsis_click sur THEDIT
  V_PGI.QRPDFOptions:=4;        // pour tronquer les libell�s en impression
  V_PGI.QRPdf:=True;           // Mode PDF Par d�faut pour totalisations situations
end.


