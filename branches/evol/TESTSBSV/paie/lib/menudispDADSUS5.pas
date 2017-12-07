{***********UNITE*************************************************
Auteur  ...... : PH
Cr�� le ...... : 08/04/2004
Modifi� le ... :   /  /
Description .. : Menu de la TOX paie
Mots clefs ... : PAIE
*****************************************************************}

unit menudispDADSUS5;

interface
uses HEnt1,
  Forms,
  sysutils,
  HMsgBox,
  Classes,
  Controls,
  HPanel,
  UIUtil,
  Windows,
  Hdebug,
  FE_Main,
  AGLInit,
  MenuOLG,
  PgiExec,
{$IFDEF MEMCHECK}
  memcheck,
{$ENDIF}
  ParamSoc,
  Hctrls;

procedure InitApplication;
type
  TFMenuDisp = class(TDatamodule)
  end;

var FMenuDisp: TFMenuDisp;

implementation

uses EntToxPaie;

{$R *.DFM}
// Procedure qui indique que le dossier en mode nomade . Uniquement PCL !!!

procedure Dispatch(Num: Integer; PRien: THPanel; var retourforce, sortiehalley: boolean);
begin
  case Num of
    10: ;
    11: ;
    12: begin // avant connexion
        FMenuG.SetSeria('05970012', ['05050050'], ['Paie et GRH']); // Paie entreprise
      end;
    13: ;
    16: ;
    100: ; // action A Faire quand on passe par le lanceur
    42506: AglLanceFiche('PAY', 'EDITDADSIMP', '', '', ''); // Import DADS � partir fichier
    42521: AglLanceFiche('PAY', 'MUL_DADS', '', '', 'S'); // Multi-crit�re Saisie activit�
    42522: AglLanceFiche('PAY', 'MUL_DADS', '', '', 'I'); // Multi-crit�re Saisie inactivit�
    42523: AglLanceFiche('PAY', 'MUL_DADS', '', '', 'U'); // Multi-crit�re Suppression p�riodes
    42531: AglLanceFiche('PAY', 'EDITDADSPER', '', '', 'N'); // Edition des p�riodes DADS
    42535: AglLanceFiche('PAY', 'EDIT_COMPDADS', '', '', ''); // Edition comparatif DADS / fiche individuelle
    42537: AglLanceFiche('PAY', 'EDIT_EXODADS', '', '', ''); // Edition comparatif DADS / fiche individuelle
    42532: AglLanceFiche('PAY', 'EDITDADSPER', '', '', 'B'); // Edition des p�riodes DADS cong�s BTP
    42533: AglLanceFiche('PAY', 'EDITDADSPER', '', '', 'S'); // Traitements et salaires pay�s au salari�
    42534: AglLanceFiche('PAY', 'EDITDADSPER', '', '', 'I'); // P�riodes d'inactivit�
    42551: AglLanceFiche('PAY', 'MUL_DADS_HONOR', '', '', 'S'); // Multi-crit�re Honoraires
    42552: AglLanceFiche('PAY', 'EDITDADSHON', '', '', ''); // Edition des honoraires
    42553: AglLanceFiche('PAY', 'MUL_DADS_HONOR', '', '', 'D'); // Multi-crit�re Duplication des honoraires
    42555: AglLanceFiche('PAY', 'MUL_DADS_HONOR', '', '', 'U'); // Multi-crit�re suppression des honoraires
    42539: AglLanceFiche('PAY', 'EDITDADSCONT', '', '', 'D'); // Edition du contr�le dossier
    42540: AglLanceFiche('PAY', 'MUL_DADS_FICHIER', '', '', ''); // Multi-crit�re G�n�ration du pr�-fichier standard
    41802: AglLanceFiche('PAY', 'MUL_EMETTEURSOC', '', '', '');
    41811: AglLanceFiche('PAY', 'MUL_ENVOISOCIAL', '', '', 'DADSU');
    41812: AglLanceFiche('PAY', 'EDITFICHIERDADS', '', '', 'FICHIER'); // Edition DADS � partir fichier
    41813: AglLanceFiche('PAY', 'MUL_CONSULTENVSOC', '', '', 'DADSU');
    41815: AglLanceFiche('PAY', 'MUL_ENVOISOCIAL', '', '', 'DADSUP'); //PT10
    41814: AglLanceFiche('PAY', 'EDITDADSCONT', '', '', 'S'); // Edition du contr�le STanDard
  end;
end;

procedure DispatchTT(Num: Integer; Action: TActionFiche; Lequel, TT: string; Range: string);
begin
  case Num of
    1: ;
  end;
end;

procedure ZoomEdt(Qui: integer; Quoi: string);
begin
  Screen.Cursor := crDefault;
end;

procedure ZoomEdtEtat(Quoi: string);
var i, Qui: integer;
begin
  i := Pos(';', Quoi);
  Qui := StrToInt(Copy(Quoi, 1, i - 1));
  Quoi := Copy(Quoi, i + 1, Length(Quoi) - i);
  ZoomEdt(Qui, Quoi);
end;


procedure RechargeMenuPopPaie;
begin
//
end;
//

procedure AfterChangeModule(NumModule: Integer);
begin

end;

procedure AfterProtec(sAcces: string); //S�rialisation des modules
begin
// cas o� on coche "version non s�rialis�e' dans
// l'�cran de s�ria. On force la non s�rialisation
  if V_PGI.NoProtec then V_PGI.VersionDemo := TRUE
  else V_PGI.VersionDemo := False;
  if (sAcces[1] = '-') then V_PGI.VersionDemo := TRUE;

  FMenuG.SetModules([916], [110]);
end;

procedure AGLAfterChangeModule(Parms: array of variant; nb: integer);
begin
  AfterChangeModule(Integer(Parms[0]));
end;

procedure InitApplication;
begin
{$IFDEF MEMCHECK}
  MemCheckLogFileName := ChangeFileExt(Application.exename, '.log');
  MemChk;
{$ENDIF}

//  ProcCalcEdt:=CalcOLEEtatPG;
  ProcZoomEdt := ZoomEdtEtat;

  FMenuG.OnDispatch := Dispatch;

  //  FMenuG.OnChargeMag:=ChargeMagHalley  ;
{$IFNDEF EAGLCLIENT}
//  FMenuG.OnMajAvant:=MAJHalleyAvant ;
//  FMenuG.OnMajApres:=MAJHalleyApres ;
{$ENDIF}
// Mais initialisation faite quand meme pour avoir la variable sAcces definie pour la fonction AfterProtect
  FMenuG.SetSeria('05970012', ['05050065'], ['Paie et GRH']); // Paie entreprise
  FMenuG.OnAfterProtec := AfterProtec;
  FMenuG.SetModules([49], [49]);
  FMenuG.OnChangeModule := AfterChangeModule;
  V_PGI.DispatchTT := DispatchTT;
end;

{ TFMenuDisp }

procedure InitLaVariablePGI;
begin
  Apalatys := 'CEGID';
  HalSocIni := 'cegidpgi.ini';
  Copyright := '� Copyright ' + Apalatys;
  V_PGI.OutLook := TRUE;
  V_PGI.LaSerie := S5;
  TitreHalley := 'PAIE-DADS-U';
  NomHalley := 'CDADSUS5';
  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'CDADSUS5.HLP';
  V_PGI.OfficeMsg := FALSE;
  V_PGI.ToolsBarRight := TRUE;
  ChargeXuelib;
  if V_PGI.ModePcl = '1' then V_PGI.PortailWeb := 'http://experts.cegid.fr/home.asp'
  else V_PGI.PortailWeb := 'http://utilisateurs.cegid.fr';
  V_PGI.OfficeMsg := TRUE;
  V_PGI.VersionDemo := True;
  V_PGI.MenuCourant := 0;
  V_PGI.VersionReseau := False;
//  V_PGI.NumVersion := '7.00';
  V_PGI.NumVersion := '2006';
  V_PGI.NumBuild := '000.0';
  V_PGI.NumVersionBase := 620;
  V_PGI.DateVersion := EncodeDate(2006, 05, 31);
  V_PGI.ImpMatrix := True;
  V_PGI.OKOuvert := FALSE;
  V_PGI.Halley := TRUE;
  V_PGI.MenuCourant := 0;
  V_PGI.DebugSQL := False;
  V_PGI.Debug := False;
  V_PGI.QRPdf := True;
  V_PGI.NumMenuPop := 27;
  V_PGI.CegidBureau := True;
  V_PGI.CegidApalatys := FALSE;
  // pour autoriser l'acces au dp comme dossier de travail,au multi dossier
  V_PGI.StandardSurDP := true;
  // pour autoriser l'acces au dp comme base de reference pour tous les dossiers ==> Table DP+STD
  V_PGI.MajPredefini := True;
// Confidentialit�
  V_PGI.PGIContexte := [CtxPaie];
  V_PGI.RAZForme := TRUE;
// Blocage des mises � jour de structure par l'appli. Elle doit etre faite par PgiMajVEr fourni dans le kit socref
  V_PGI.BlockMAJStruct := TRUE;
  v_pgi.sav := true;
end;

initialization
  ProcChargeV_PGI := InitLaVariablePGI;
end.

