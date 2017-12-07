{***********UNITE*************************************************
Auteur  ...... : FV
Créé le ...... : 10/09/2000
Modifié le ... : 15/02/2001
Description .. : Gestion du planning graphique
Mots clefs ... : PLANNING
*****************************************************************}
unit BTPLANNING;

interface
uses
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  graphics,
  StdCtrls,
  ComCtrls,
  Utob,
{$IFDEF EAGLCLIENT}
  MaineAGL, UtilEagl,
  eMul,
{$ELSE}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fe_main,
  EdtREtat,
  mul,
{$ENDIF}
	AglInit,
  HEnt1,
  HCtrls,
  HMsgBox,
  UIUtil,
  Dialogs,
  Hplanning,
  HPanel,
  Mask,
  ExtCtrls,
  HTB97,
  ParamDat,
  Paramsoc,
  Lookup,
  PlanUtil,
  HeureUtil,
  MsgUtil,
  BTsaisieDate,
  BTPUtil,
  Grids,
  uJoursFeries,
  Utof_VideInside,
  Menus, DBCtrls, HDB, HRichEdt, HRichOLE, HCapCtrl,UDateUtils;
//
var

  DateAppel     : TDateTime;

  //Permet de déterminer quelles sont les informations affichées dans les onglets
  TypePlanning  : String;

procedure SaisiePlanning(StArgument: string; mode: integer; action: TActionFiche);
procedure ConsultationPlanning(mode: integer; DateEnCours: TDateTime; Famres, DossierEnCours: string);

type

  TTypeDateTrait = (TtDDebut,TtDFin);
  TTaction = (Ttatransfere,TTaEtirer);

  TMonPlanning = class(TForm)
    MonthCalendar1  : TMonthCalendar;
    PageOnglet      : TPageControl;
    Timer1          : TTimer;
    Dock972         : TDock97;
    Timer2          : TTimer;
    DESCRIPTIF      : THRichEditOLE;
    DesAction       : TMemo;
    GrilleSelection : THGrid;
    MenuCadencement : TPopupMenu;
    //
    CodeDossierRech : TEdit;
    DossierInterdit : TEdit;
    //
    DateEdit        : THCritMaskEdit;
    TheParamPlanning: THCritMaskEdit;
    Hdeb1           : THCritMaskEdit;
    Hfin1           : THCritMaskEdit;
    HDateDeb        : THCritMaskEdit;
    HDateFin        : THCritMaskEdit;
    HtypeAction     : THCritMaskEdit;
    //
    Toolbar972    : TToolWindow97;
    TTWLegende    : TToolWindow97;
    TTWAppels     : TToolWindow97;
    FenHoraire    : TToolWindow97;
    FenDescriptif : TToolWindow97;
    //
    BPagePrec     : TToolbarButton97;
    BPageSuiv     : TToolbarButton97;
    BCalendrier   : TToolbarButton97;
    BRecharger    : TToolbarButton97;
    BChercher     : TToolbarButton97;
    Bimprimer     : TToolbarButton97;
    BQuitter      : TToolbarButton97;
    Excelexport   : TToolbarButton97;
    BLegende      : TToolbarButton97;
    BAffAppel     : TToolbarButton97;
    BValidAff     : TToolbarButton97;
    BAnnulAff     : TToolbarButton97;
    BCREAPPEL     : TToolbarButton97;
    BRefreshAff   : TToolbarButton97;
    bValWindows   : TToolbarButton97;
    bAnnulWindows : TToolbarButton97;
    BDescriptif   : TToolbarButton97;
    BNoteWindows  : TToolbarButton97;
    Btaches       : TToolbarButton97;

    //
    Label1      : TLabel;
    Label2      : TLabel;
    Label3      : TLabel;
    Label4      : TLabel;
    Label5      : TLabel;
    Label6      : TLabel;
    Label7      : TLabel;
    Label8      : TLabel;
    Label9      : TLabel;
    Label10     : TLabel;
    Label11     : TLabel;
    HDuree      : TLabel;
    LLibAction  : TLabel;
    //
    CheckTravailFerie : TCheckBox;
    Modifiable        : TCheckBox;
    Surbooking        : TCheckBox;
    CHKTACHES         : TCheckBox;
    //
    HPanel1     : THPanel;
    Panel1      : TPanel;
    Panel2      : TPanel;

    HLabel1     : THLabel;
    HLabel2     : THLabel;
    LDEB        : THLabel;
    LFIN1       : THLabel;
    LtypeAction : THLabel;
    BCadencement: TToolbarButton97;
    BTypePlanning: TToolbarButton97;
    BTAFFMEMO: TToolbarButton97;
    CBTRAITE: THCheckbox;
    //
    procedure BAffAppelClick(Sender: TObject);
    procedure BAnnulAffClick(Sender: TObject);
    procedure bAnnulWindowsClick(Sender: TObject);
    procedure BCalendrierClick(Sender: TObject);
    procedure BChercherClick(Sender: TObject);
    procedure BCREAPPELClick(Sender: TObject);
    procedure BDescriptifClick(Sender: TObject);
    procedure BImprimeClick(Sender: TObject);
    procedure BLegendeClick(Sender: TObject);
    procedure BPageSuivClick(Sender: TObject);
    procedure BPagePrecClick(Sender: TObject);
    procedure BQuitterClick(Sender: TObject);
    procedure BRechargerClick(Sender: TObject);
    procedure BRefreshAffClick(Sender: TObject);
    procedure BValidAffClick(Sender: TObject);
    procedure bValWindowsClick(Sender: TObject);
    procedure ChangeCadencement(Sender: TObject);
    procedure ExcelexportClick(Sender: TObject);
    procedure FenDescriptifClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure GestionTimer;
    procedure GrilleSelectionClick(Sender: TObject);
    procedure GrilleSelectionDblClick(Sender: TObject);
    procedure GrilleSelectionKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Hdeb1Exit(Sender: TObject);
    procedure Hfin1Exit(Sender: TObject);
    procedure HtypeActionChange(Sender: TObject);
    procedure HTypeActionExit(Sender: TObject);
    procedure PageOngletChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TTWLegendeClose(Sender: TObject);
    procedure TTWAppelsClose(Sender: TObject);
    procedure VoirToutBoutons(choix: Boolean);
    procedure Timer2Timer(Sender: TObject);
    procedure BNoteClick(Sender: TObject);
    procedure CHKTACHESClick(Sender: TObject);
    procedure BtachesClick(Sender: TObject);
    procedure BTypePlanningClick(Sender: TObject);
    procedure BTAFFMEMOClick(Sender: TObject);
    procedure CBTRAITEClick(Sender: TObject);

  private
    {Déclarations privées }
    TobModelePlanning : Tob;
    TobOnglet         : Tob;
    TobEtat           : Tob;
    TobItem				  	: Tob;
    TobAppel				  : Tob;
    TobEvenement		  : Tob;
    TobIntervention	  : Tob;
    TobGrille				  : Tob;
    TobSuppression	  : Tob;
    TobTaches         : Tob;
    TobCalendrier     : Tob;

    Couleur			  : array of TLabel;
    Libelle		  	: array of TLabel;

    OKModif			  : Boolean;
    OkAffect		  : Boolean;
    OkValAction	  : Boolean;
    OKAppelLibre  : Boolean;
    OKVisuAffect  : Boolean;
    OkSpecifCal   : Boolean;
    Ok_TpsReel	  : Boolean;
    TousPossible : boolean;

    DessineGAppel : AffGrille;

    DatePlanDeb   : TDateTime;
    DatePlanFin   : TDateTime;

    DureeJournee  : Double;
    NbHeure		    : Double;
    HeureDeb  	  : Double;
    HeureFin  	  : Double;
    TailleCol	 	  : Double;

    NbOnglet      : Integer;
    NoOnglet      : Integer;

    Nbjour			: String;
    ColNames		: string;
    CodeRes			: string;
    Calendrier  : String;
    Equipe			: string;
    Responsable	: string;
    TypeAction	: string;
    Cadencement	: string;

//    ColGAppel 	: String;
//    LibGAppel		: String;
//    TableGapp		: String;
//    TriGapp		 	: String;
//  	FormatGapp 	: String;
//    LarGappel	 	: String;

    CreerPar    : String;
    AffaireInit : String;
    CodeTiers   : String;

    procedure Affectation(Sender: TObject; Item: Tob; var Cancel: boolean);
    procedure AvertirApplication(Sender: TObject; FromItem: TOB; ToItem: TOB; Actions: THPlanningAction);
    procedure ChargeAppel;
    procedure ChargeElementGrille(Item: Tob);
    procedure ChargeInfoAppel;
    procedure ChargeIntervention;
    procedure ChargeMenuCadencement;
    procedure ChargementFicheHoraire (Item :TOB);
    procedure ChargementModifEvenement(Item: Tob);
    procedure ChargeTobCalendrier;
    procedure ChargeTableEvtGrille;
    procedure CopyItem(Sender: TObject; Item: TOB; var Cancel: boolean);
    procedure Creation(Sender: TObject; Item: TOB; var Cancel: boolean);
    procedure CreationAction ;
    procedure Deplacement(Sender: TObject; Item: TOB; var Cancel: boolean);
    procedure DoubleClickSpec(ACol, ARow: INTEGER; TypeCellule: TPlanningTypeCellule; T: TOB = nil);
    procedure DrawGAppel(NomTablette : String);
    procedure DrawGrille(NbColFixe: Integer);
    procedure Extension(Sender: TObject; Item: Tob; var Cancel: boolean);
    procedure InitItem(Sender: TObject; var Item: TOB; var Cancel: boolean);
    //procedure Link(Sender: TObject; TobSource, TobDestination: TOB; Option: THPlanningOptionLink; var Cancel: Boolean);
    procedure MajEvenements(var MajPlanning: THPlanningBTP);
    procedure MajEventPlanning(Numero: Integer; Item: Tob);
    procedure Modification(Sender: TObject; Item: TOB; var Cancel: boolean);
    procedure ModificationAction;
    //procedure NePasEtirer(Item: TOB);
    procedure OnPopup(Item: tob; ZCode: integer; var Redraw: boolean);
    procedure P1BeforeChange(const Item: TOB; const LaRessource: string; const LaDateDeDebut, LaDateDeFin: TDateTime; var Cancel: Boolean);
    //procedure ReafficherItem;
    procedure Reduction(Sender: TObject; Item: Tob;  var Cancel: boolean);
    procedure SetInfosAction;
    procedure SupprimeAffectation;
    procedure Suppression(Sender: TObject; Item: TOB; var Cancel: boolean);
    procedure SuppressionEquipe(Equipe: String);
    procedure SuppressionItemPlanning(CritereLecture: String);
    procedure TraitSuppItem(CodeRes, NumAppel, NumEvenement: String);

    function ChargeLegende: boolean;
    function Control_BtEtat(NumErreur: String): boolean;
    function ControleAffectation(Item: Tob): Boolean;
    function ControleSurbooking: Boolean;
    function ControleDansLaGrille(Item: TOB): boolean;
    function ControleDateAffectation: Boolean;
    function ControleDateAppel: boolean;
//    function Interval1Jour(HeureDebTemp, HeureFinTemp: Double): String;
    function MajEvtAffectation(ModeOption: String; Item: Tob): Boolean;
    //function FonctionModif(Sender: TObject; Item: Tob): Boolean;
    function RechEquipe : Boolean;

    //function RecupPeriode(NumeroPeriode: integer): string;

    //Procedure de mise en page du planning
    procedure ChargementPlanningStandard(TobModelePlanning: Tob);
    procedure ChargementPlanningSpecifique(TobModelePlanning: Tob);
    procedure RechargePlanning(TMO : Tob);
    //
    function InitialisationPlanning: Boolean;
    procedure Link(Sender: TObject; TobSource, TobDestination: TOB;
      Option: THPlanningOptionLink; var Cancel: Boolean);
    function ConstitueDatePlanning(UneDate: TDateTime;
      TypeDate: TTypeDateTrait): TDateTime;
    function COntrolDestOk(Item: TOB; TheAction: TTaction): boolean;
    procedure ChargeTobCalendrierressource(Ressource: string;
      DateDepart: TdateTime; TOBcalendar: TOB);
    function ControleRessourceDispo(CodeRes: string; var DatePrevDeb,
      DatePrevFin: TDateTime): boolean;
    procedure CheckMoveItem (sender : Tobject; Item : TOB; var cancel : boolean);
    function IsModifiable (Item : TOB) : boolean;
    procedure ModificationsActionGRC (Item : TOB);
    function DeplacementActionGRC(Item: TOB): boolean;
    procedure ReChargeActionGRC(Auxiliaire: string; NumAct: integer); overload;
    procedure ReChargeActionGRC(Item : TOB); overload;
    function SuppressionActionGRC(Item: TOB): boolean;
    procedure DeleteItemGRC(Auxiliaire: string; NumAct: integer);
    function ReductionEtirementActionGRC(Item: TOB): boolean;
    function calculeDateEvtEtireReduit(Item: TOB; var DateD,
      DateF: TdateTime; var Delai: integer): boolean;

  public
    {Déclarations publiques }
    tempscalcule: TTime;
    feuille   : array[0..99] of TTabSheet;
    Planning  : array[0..99] of THPlanningBTP;
{$IFDEF TESTXP}
    PlanningType: array[0..99] of THPlanningBTP;
{$ENDIF}
    TobPlannings: array[0..99] of RecordPlanning;
    PlanningCurrent: THplanningBTP;
    DateSelectionee: TDateTime;
    FindPRien: THpanel;

    procedure GestionSynchroDate(Item: Tob);
    procedure GestionDateLigne(Item: Tob);

  protected // XP 07.06.2006
    CancelAction: boolean ;
  end;

procedure GetDateRecherche(F: TFORM; DATE: THCritMaskEdit);

var
  PremierPassage: Boolean = True;
  FicAppel: Boolean;

implementation

{$R *.DFM}

uses uBtpEtatPlanning, DateUtils, TntStdCtrls, TntGrids;

function Recupdefaut: string;
var QModelePlanning: TQuery;
    StReq : String;
begin

  result := '';

  if (Trim(ReadTokenSt(TypePlanning))) = 'APPEL' then
     stReq := 'Select HPP_PARAMPLANNING from HRPARAMPLANNING where (HPP_MODEPLANNING="PLA") AND HPP_PLANNINGDEFAUT="X"'
  else
     stReq := 'Select HPP_PARAMPLANNING from HRPARAMPLANNING where (HPP_MODEPLANNING="' + TypePlanning + '") AND HPP_PLANNINGDEFAUT="X"';

  QModelePlanning := OpenSQL(streq, True,-1,'',true);

  if not QModelePlanning.eof then
    Result := QModelePlanning.FindField('HPP_PARAMPLANNING').AsString;

  Ferme(QModelePlanning);

end;

procedure SaisiePlanning(StArgument: string; mode: integer; Action: TActionFiche);
var
  Inside: THPanel;
  X: TMonPlanning;
  StDate: string;
  StContrat: string;
  ParamPlanning: string;
  CodeAppel: string;
  TousPossible : boolean;
begin

  StContrat := '-';
  TousPossible := False;

  TypePlanning := StArgument;

  //récupération du planning par défaut
  ParamPlanning := Recupdefaut;

  {le planning détaillé est deja chargé}
  if not PremierPassage then exit;

  NumLigneTO := -1;

  //ModeGestion := Mode;

  if (Action = Tamodif) then
    ModeSaisie := True
  else if (Action = TaConsult) then
    ModeSaisie := False;

  FicAppel     := False;

  if (Trim(ReadTokenSt(StArgument))) = 'APPEL' then
     Begin
     CodeAppel := (Trim(ReadTokenSt(StArgument)));
     DateAppel := StrToDate(Trim(ReadTokenSt(StArgument)));
     StDate := DateToStr(DateAppel);
     TypePlanning := 'PLA';
     FicAppel := True;
  	 end
  else
     StDate := SaisieDate(StContrat, ParamPlanning, TypePlanning,TousPossible, datetimetostr(v_pgi.dateentree), true, true);

  if (StrToDateTime(StDate) = IDate1900) then Exit;

  X := TMonPlanning.Create(Application);

  if (ParamPlanning <> '') then
     X.TheParamPlanning.text := ParamPlanning;
  X.TousPossible := TousPossible;
  X.DateEdit.Text := StDate;
  X.CodeDossierRech.text := CodeAppel;

{$IFDEF EAGLCLIENT}
  Inside := FindInsidePanel;
{$ELSE}
  Inside := nil;
{$ENDIF}

  if Inside = nil then
     begin
     X.FindPrien := nil;
     try
     X.ShowModal;
     finally
     X.Free;
     end;
     end
  else
     begin
     X.findprien := Inside;
     InitInside(X, Inside);
     X.Show;
     end;

end;

procedure ConsultationPlanning(mode: integer; DateEnCours: TDateTime; Famres, DossierEnCours: string);
var
  Inside: THPanel;
  X: TMonPlanning;
begin

  //le planning détaillé est deja chargé
  if not PremierPassage then
    exit;

  NumLigneTO := -1;
  //ModeGestion := Mode;
  ModeSaisie := False;
  X := TMonPlanning.Create(Application);
  X.DateEdit.Text := DateTimeToStr(DateEnCours);
  X.DossierInterdit.Text := DossierEnCours;
{$IFDEF EAGLCLIENT}
  Inside := FindInsidePanel;
{$ELSE}
  Inside := nil;
{$ENDIF}
  if Inside = nil then
  begin
    X.FindPrien := nil;
    try
      X.ShowModal;
    finally
      X.Free;
    end;
  end
  else
  begin
    InitInside(X, Inside);
    X.Show;
  end;
end;

procedure TMonPlanning.FormCreate(Sender: TObject);
var
  i: integer;
begin

  PremierPassage := False;

  MenuCadencement.AutoPopup := False;

  for i := 0 to 99 do
  begin
    feuille[i] := nil;
    Planning[i] := nil;
    with TobPlannings[I] do
    begin
      TobItems  := nil;
      TobEtat   := nil;
      TobRes    := nil;
      TobCols   := nil;
      TobRows   := nil;
      TobEvents := nil;
      TobPeriodeDivers := nil;
    end;
  end;

  TobAppel        := nil;
  TobEtat         := nil;
  TobIntervention := nil;
  TobEvenement    := nil;
  TobGrille       := nil;
  TobSuppression  := nil;
  TobTaches       := nil;
  
  Application.HintHidePause := 20000;

  //Creation des tob génériques
  TobTaches := Tob.create('TACHE', nil, -1);
  TobEtat:= Tob.create('BTETAT', nil, -1);

end;

procedure TMonPlanning.FormShow(Sender: TObject);
begin

  // XP 07.06.2006 Par défaut, l'action est toujours réfusée donc il faut mettre CancelAction à True
  CancelAction := True;

  {$IFDEF EAGLCLIENT}
  BQUITTER.Enabled := False;
  BCREAPPEL.Visible := False;
  {$ENDIF}
  if not ModeSaisie then
  begin
    BCREAPPEL.enabled := false;
    BAffAppel.enabled := false;
  end;
  // Initialisation de la date en cours
  if (DateEdit.Text = DateTimeToStr(iDate1900)) then
     begin
     DateSelectionee := V_PGI.DateEntree;
     DateEdit.Text := DateTimeToStr(V_PGI.DateEntree);
     end
  else
     DateSelectionee := StrToDate(DateEdit.Text);

  If not InitialisationPlanning then
     begin
     Close;
     exit;
     end;

  //Controle du type d'action
  TypeAction := GetParamSoc('SO_TYPEACTION');
  Ok_TpsReel := GetParamSoc('SO_GesTempsReel');

  //chargement de la legende
  if not ChargeLegende then Close;

  if not Control_BtEtat('12') then exit;

  //Chargement du menu Contextuel pour gestion des cadencements en dynamique
  ChargeMenuCadencement;

  GestionTimer;

  if Not FicAppel then
	   DrawGAppel('BTCONTENUGAPP')
  else
     ChargeInfoAppel;

end;

Function TMonPlanning.InitialisationPlanning : Boolean;
Var QModelePlanning : TQuery;
		Sql :string;
Begin

  Result := true;

  if TypePlanning = '' then
     Begin
     HShowMessage('', TraduireMemoire('Attention !'), TraduireMemoire('Aucun modèle de planning n''a été défini'));
     BPageSuiv.Enabled := False;
     BPagePRec.Enabled := False;
     BCalendrier.Enabled := False;
     Result := False;
     exit;
     End;

  // Chargement des modèles de planning dans la TOB les modèles ET LES ONGLETS
  TobModelePlanning := TOB.Create('les modeles', nil, -1);
  TobOnglet := TOB.Create('les Onglets', nil, -1);

  if not FicAppel then
     Begin
     BCREAPPEL.Visible := True;
     end;

  NbHeure := 0;

  //on charge TOUS les champs
  MajParamplanning;

  // RH 16/7/3
//  if TypePlanning = 'PLA' then
//  	Sql := 'Select * from HRPARAMPLANNING where HPP_MODEPLANNING="' + TypePlanning +'" ORDER BY HPP_PLANNINGDEFAUT DESC,HPP_PARAMPLANNING'
//  else
	if TousPossible then
  begin
  	Sql := 'Select * from HRPARAMPLANNING where HPP_MODEPLANNING="' + TypePlanning +'" ORDER BY HPP_PLANNINGDEFAUT DESC,HPP_PARAMPLANNING'
  end else
  begin
		Sql := 'Select * from HRPARAMPLANNING where HPP_MODEPLANNING="' + TypePlanning +'" AND HPP_PARAMPLANNING="' + TheParamPlanning.Text + '" ORDER BY HPP_PLANNINGDEFAUT DESC,HPP_PARAMPLANNING';
  end;
  QModelePlanning := OpenSQL(Sql , True,-1,'',true);

  try
    TobModelePlanning.LoadDetailDB('HRPARAMPLANNING', '', '', QModelePlanning, True)
  finally
    if QModelePlanning <> nil then Ferme(QModelePlanning);
  end;

  // Initialisation de la date en cours
  //maxi := 99;
  if (DateEdit.Text = DateTimeToStr(iDate1900)) then
  begin
    DateSelectionee := V_PGI.DateEntree;
    DateEdit.Text := DateTimeToStr(V_PGI.DateEntree);
  end
  else
    DateSelectionee := StrToDate(DateEdit.Text);

  // Test si pas de modèles de planning
  if TobModelePlanning.Detail.Count = 0 then
     begin
     HShowMessage('', TraduireMemoire('Attention !'), TraduireMemoire('Aucun modèle de planning n''a été défini'));
     BPageSuiv.Enabled := False;
     BPagePRec.Enabled := False;
     BCalendrier.Enabled := False;
     Result := False;
     exit;
     end;

  if TypePlanning = 'PLA' then
     ChargementPlanningStandard(TobModelePlanning)
  ELSE
     ChargementPlanningSpecifique(TobModelePlanning);

end;


procedure TMonPlanning.ChargementPlanningSpecifique(TobModelePlanning : Tob);
Var maxi            : Integer;
    i               : Integer;
    NModele         : integer;
    StSQL           : String;
    CodeSpecif      : string;
    QTableOnglet    : TQuery;
    Prefixe         : String;
    Suffixe         : String;
begin

  maxi := 99;

  //StSQL := 'SELECT DISTINCT BTR_LIBELLE AS LIBELLE, BTR_TYPRES AS CODEONGLET FROM BTTYPERES ';
  //StSQL := StSQL + 'RIGHT JOIN RESSOURCE ON BTR_TYPRES=ARS_CHAINEORDO ';
  //StSQL := StSQL + 'WHERE BTR_GEREPLANNING = "X" ';

  If TypePlanning = 'PSF' then
     Begin
     StSQl := 'SELECT DISTINCT BTR_LIBELLE AS LIBELLE, BTR_TYPRES AS CODEONGLET FROM RESSOURCE ';
     StSQL := StSQL + 'INNER JOIN BTTYPERES ON BTR_TYPRES=ARS_CHAINEORDO ';
     StSQL := StSQL + 'WHERE ARS_RESSOURCE in (SELECT ARS_RESSOURCE FROM RESSOURCE ';
     StSQL := StSQL + 'LEFT JOIN BTTYPERES ON ARS_CHAINEORDO=BTR_TYPRES ';
     StSQL := StSQL + 'WHERE BTR_GEREPLANNING="X") OR ARS_CHAINEORDO="" ';
     if TobModelePlanning.Detail[0].GetValue('HPP_VISUTYPERES') <> 'X' then
        StSQL := StSQL + 'AND ARS_TYPERESSOURCE="' + TobModelePlanning.Detail[0].GetValue('HPP_FAMRES') + '"';
     QTableOnglet := OpenSQL(StSQL, True,-1,'',true);
     TobOnglet.LoadDetailDB('BTTYPERES', '', '', QTableOnglet, True);
     end
  else if TypePlanning = 'PTA' then
     Begin
     StSQL := 'Select BTA_LIBELLE AS LIBELLE, BTA_BTETAT AS CODEONGLET FROM BTETAT ';
     StSQL := StSQL + 'WHERE BTA_ASSOSRES = "X" ORDER BY BTA_BTETAT';
     QTableOnglet := OpenSQL(StSQL, True,-1,'',true);
     TobOnglet.LoadDetailDB('BTETAT', '', '', QTableOnglet, True);
     end;

  if QTableOnglet <> nil then Ferme(QTableOnglet);

  if TobOnglet.detail.count < maxi then maxi := TobOnglet.detail.count;

  NbOnglet := maxi;

  // Creation des onglets
  for i := 0 to (NbOnglet - 1) do
      begin
      Feuille[i] := TTabSheet.Create(Self);
      if i < 10 then
         Feuille[i].name := 'Page0' + IntToStr(i)
      else
         Feuille[i].name := 'Page' + IntToStr(i);
         if TobOnglet.Detail[i].GetValue('LIBELLE') = '' then
            Feuille[i].Caption := 'Non Attribué'
         else
            Feuille[i].Caption := TobOnglet.Detail[i].GetValue('LIBELLE');
         Feuille[I].PageControl := PageOnglet;
         Feuille[I].Tag := I;
         // Creation des plannings
{$IFDEF TESTXP}
         PlanningType[i] := THPlanningBTP.Create(Self);
         PlanningType[i].parent := Feuille[i];
         PlanningType[i].Name := Format('TYPEPLANNING%2.2d', [i]);
         PlanningType[i].Align := alBottom;
{$ENDIF}
         Planning[i] := THPlanningBTP.Create(Self);
         Planning[i].parent := Feuille[i];
         Planning[i].Name := Format('PLANNING%2.2d', [i]);
         Planning[i].Align := alClient;
      	 Planning[i].AppelsTraites  := CBTRAITE.Checked;
         if TypePlanning = 'PLA' then
	          Planning[i].Tag := i
         else
	          Planning[i].Tag := 0;
         //Evenements
         MajEvenements(Planning[i]);
      end;

  // Charge les paramètres du premier planning
  NModele := 0;

  Planning[NModele].CodeOnglet := TobOnglet.Detail[NModele].GetValue('CODEONGLET');
  Planning[NModele].TypePlanning := Typeplanning;
  Planning[NModele].FamRes  := TobModelePlanning.Detail[NModele].GetValue('HPP_FAMRES');

  PlanningCurrent := Planning[NModele];
  PageOnglet.ActivePageindex := NModele;
  PlanningCurrent.tag := NModele;

  Cadencement := TobModelePlanning.Detail[NModele].Getvalue('HPP_CADENCEMENT');

  // Charge les paramètres du premier planning
  RechargePlanning(TobOnglet.Detail[NModele]);

end;

procedure TMonPlanning.ChargementPlanningStandard(TobModelePlanning : Tob);
Var maxi            : Integer;
    i               : Integer;
    NModele         : integer;
    CodeFamres      : string;
begin

  maxi := 99;

  if TobModelePlanning.detail.count < maxi then maxi := TobModelePlanning.detail.count;

  NbOnglet := maxi;

  // Creation des onglets
  for i := 0 to (maxi - 1) do
      begin
      Feuille[i] := TTabSheet.Create(Self);
      if i < 10 then
         Feuille[i].name := 'Page0' + IntToStr(i)
      else
         Feuille[i].name := 'Page' + IntToStr(i);
      Feuille[i].Caption := TobModelePlanning.Detail[i].GetValue('HPP_ABREGE');
      Feuille[I].PageControl := PageOnglet;
      Feuille[I].Tag := I;
      // Creation des plannings
{$IFDEF TESTXP}
      PlanningType[i] := THPlanningBTP.Create(Self);
      PlanningType[i].parent := Feuille[i];
      PlanningType[i].Name := Format('TYPEPLANNING%2.2d', [i]);
      PlanningType[i].Align := alBottom;
{$ENDIF}
      Planning[i] := THPlanningBTP.Create(Self);
      Planning[i].parent := Feuille[i];
      Planning[i].Name := Format('PLANNING%2.2d', [i]);
      Planning[i].Align := alClient;
      Planning[i].AppelsTraites  := CBTRAITE.Checked;
      if TypePlanning = 'PLA' then
	       Planning[i].Tag := i
      else
         Planning[i].Tag := 0;
      //Evenements
      MajEvenements(Planning[i]);
      end;

  // Charge les paramètres du premier planning
  NModele := 0;
  if (TheParamPlanning.Text <> '') then
     begin
     for i := 0 to TobModelePlanning.detail.count - 1 do
         begin
         if (TobModelePlanning.detail[i].getvalue('HPP_PARAMPLANNING') = TheParamPlanning.Text) then
            begin
            NModele := i;
            break;
            end;
         end;
     end;

  PageOnglet.ActivePageindex := NModele;

  Planning[NModele].CodeOnglet := TobModelePlanning.Detail[NModele].GetValue('HPP_FAMRES');
  Planning[NModele].FamRes := Planning[NModele].CodeOnglet;
  Planning[NModele].TypePlanning := Typeplanning;

  PlanningCurrent := Planning[NModele];
  PlanningCurrent.tag := NModele;

  Cadencement := TobModelePlanning.Detail[NModele].Getvalue('HPP_CADENCEMENT');

  // Charge les paramètres du premier planning
  RechargePlanning(TobModelePlanning.Detail[NModele]);

end;

// Création d'un item
procedure TMonPlanning.Creation(Sender: TObject; Item: TOB; var Cancel: boolean);
Var QQ    : TQuery;
    StSQL : STring;
    DebutDemande,FinDemande,DebutCalc,FinCalc : TdateTime;
    Equipe       : String;
    Rep          : String;
    NumEvent     : Integer;
    I            : Integer;
    TobRessource : Tob;
    TobItemDe    : Tob;
    TobItemA     : Tob;
    Ok_Equipe    : Boolean;
    NumEvenement : String;
begin

  THPlanningBTP(Sender).Enabled := False;

  VoirToutBoutons(False);


  OkAffect := False;

  Descriptif.Visible := False;
  //
  DesAction.Text := '';
  DeScriptif.Text := '';
  //
  HTypeAction.text := '';

  NbHeure := 0;
  NbJour	:= '';
  iTem.putValue('BEP_MODIFIABLE','X');
  DatePlanDeb := Item.GetValue('BEP_DATEDEB');
  DatePlanDeb := CalculDateDebut (DatePlanDeb);
  DatePlanFin := DatePlanDeb;
  NumEvenement := Item.GetString('BEP_CODEEVENT');

  bValWindows.Tag := 1;

  CodeRes	    := Item.GetValue('BEP_RESSOURCE');
  TOBItem := Item;
  (*
  //contrôle si Equipe/Calendrier de la ressource
  if Ok_TpsReel then
     Begin
     StSQL := 'SELECT ARS_STANDCALEN, ARS_EQUIPERESS, ARS_CALENSPECIF FROM RESSOURCE ';
     StSQL := StSQL + 'WHERE ARS_RESSOURCE="' + CodeRes + '"';
     QQ := OpenSQL(StSQL, true,-1,'',true);
     if Not QQ.eof then
        Begin
        Calendrier := QQ.FindField('ARS_STANDCALEN').AsString;
        Equipe     := QQ.FindField('ARS_EQUIPERESS').AsString;
        if QQ.FindField('ARS_CALENSPECIF').AsString = '-' then
           OkSpecifCal := False
        Else
           OkSpecifCal := True;
        end;
     Ferme(QQ);
     end;
  *)
  ChargementFicheHoraire (TOBItem);
  // controle sur delai
  if NbHeure <= 0 then
  begin
    PgiError ('Impossible : La ressource sélectionnée ne peut effectuer le travail aux heures indiquées');
    THPlanningBTP(Sender).Enabled := true;
    VoirToutBoutons(True);
    cancel := true;
    exit;
  end;
  FenHoraire.Visible := True;

  THPlanningBTP(Sender).Enabled := true;

end;

// Initilisation des items
procedure TMonPlanning.InitItem(Sender: TObject; var Item: TOB; var Cancel: boolean);
begin

  if Item = nil then
  begin
     Item := TOB.Create('BTEVENPLAN', nil, -1);

     with Item do
     begin
       AddChampSupvaleur('ACTIONSGRC',0);
       AddChampSupvaleur('CLIENTGRC','');
       AddChampSup('LIBELLE', False);
       AddChampSup('HINT', False);
       AddChampSupValeur('ICONETYPDOS', -1, False);
       AddChampSup('THEICONE', false);
       AddChampSupValeur('NUMEROHRPERIODEDEBUT', 0, true);
       AddChampSupValeur('NUMEROHRPERIODEFIN', 0, true);
     end;
  end;

  Cancel := False;

end;

// Extension d'un item de type Evenement
procedure TMonPlanning.Reduction(Sender: TObject; Item: Tob; var Cancel: boolean);
Begin
	if (not ModeSaisie) then BEGIN Cancel := true;   CancelAction := True; exit; END;

  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	ReductionEtirementActionGRC (Item);
  	cancel := true;
    exit;
  end;

  Cancel := CancelAction ;

  if CancelAction then exit;

  if Not Assigned(Item) then Exit;

  bValWindows.Tag := 2;

  Cancel := not MajEvtAffectation('R', Item);
  if Cancel then
  begin
  	ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
  	exit;
  end;

end;

procedure TMonPlanning.Affectation(Sender: TObject; Item: Tob; var Cancel: boolean);
Begin

	Cancel := CancelAction ;

  if CancelAction then exit;


end;

// Extension d'un item de type Evenement
procedure TMonPlanning.Extension(Sender: TObject; Item: Tob; var Cancel: boolean);
Begin
  if (not ModeSaisie) then BEGIN cancel := true;   CancelAction := True; exit; END;
  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	ReductionEtirementActionGRC (Item);
  	cancel := true;
    exit;
  end;

  Cancel := CancelAction ;

  if CancelAction then exit;

  if Not Assigned(Item) then Exit;

  bValWindows.Tag := 2;

  Cancel := not MajEvtAffectation('E', Item);
  if Cancel then
  begin
  	ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
  	exit;
  end;

end;

// Modification d'un item de type Evenement
procedure TMonPlanning.Modification(Sender: TObject; Item: TOB; var Cancel: boolean);
begin
	if (not ModeSaisie) then exit;
  if not IsModifiable (Item) then
  begin
  	cancel := true;
    exit;
  end;
  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	ModificationsActionGRC (Item);
  	cancel := true;
  end else
  begin
  	ChargementModifEvenement(Item);
  end;
end;

function TMonPlanning.ControleRessourceDispo (CodeRes : string; var DatePrevDeb,DatePrevFin : TDateTime) : boolean;
var TOBCalendar : TOB;
		HeureDeb,HeureFin,Duree : double;
    DatePrevDebInit,DatePrevFinInit : TdateTime;
    Hdeb1,HFin1 : string;
    Datedeb1,DateFin1 : TDateTime;
    DateDeb,DateFin : double;
begin
	result := true; // par defaut elle est dipo
	TobCalendar := Tob.Create('Le Calendrier', nil, -1);
	ChargeTobCalendrierressource (CodeRes,DatePrevDeb,TOBCalendar);
  DatePrevDebInit := ConstitueDatePlanning(DatePrevDeb,TtDDebut);
  DatePrevFinInit := ConstitueDatePlanning(DatePrevFin,TtDFin );

  if TimeToFloat(DatePrevDeb) <> 0 then HeureDeb := TimeToFloat(DatePrevDeb);
  if TimeToFloat(DatePrevFin) <> 0 then HeureFin := TimeToFloat(DatePrevFin);

  if HeureDeb = 0 then HeureDeb := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREDEBUT'), True);
  if HeureFin = 0 then HeureFin := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREFIN'), True);

  //Faire un paramsoc pour la gestion de l'heure de début et heure de fin
  //dans le cas de la journée (005)
  if HeureDeb = 0 then HeureDeb := 8;
  if HeureFin = 0 then HeureFin := 18;

  DateDeb := Trunc(StrToDate(DateToStr(DatePrevDeb)));
  DateFin := Trunc(StrToDate(DateToStr(DatePrevFin)));
  CalculDureeEvenementRess (TOBCalenDar,TobModelePlanning.Detail[PlanningCurrent.Tag],DateDeb,DateFin,HeureDeb,HeureFin);

  DateDeb1 := FloatToDateTime(DateDeb);
  DateFin1 := FloatToDateTime(DateFin);

  Hdeb1 := FormatDateTime('hh:mm', FloatToTime(HeureDeb));
  HFin1 := FormatDateTime('hh:mm', FloatToTime(HeureFin));
  // Correction LS
  DatePrevDeb := Trunc(DateDeb1) + StrToTime(Hdeb1);
  DatePrevFin := Trunc(DateFIn1) + StrToTime(HFin1);
//  if (DatePrevDeb <> DatePrevDebInit) or (DatePrevFin<>DatePrevFinInit) then result := false;
  TOBCalendar.free;
end;

function TMonPlanning.COntrolDestOk (Item : TOB; TheAction : TTaction ) : boolean;
var CodeRes,CodeRes2 : string;
		DatePrevDeb,DatePrevFin : TDateTime;
    nbHeureC : double;
begin
	result := true;
  NbHeureC := 0;
  CodeRes		:= Item.GetValue('BEP_RESSOURCE');
  CodeRes2		:= PlanningCurrent.GetCurItem.GetValue('BEP_RESSOURCE');
  DatePrevDeb := Item.GetValue('BEP_DATEDEB');
  if TheAction = Ttatransfere then
  begin
    NbheureC	  := Item.GetValue('BEP_DUREE');
    DatePrevFin := DatePrevDeb + (NbHeureC*60) / 1440;
  end else
  begin
  	DatePrevFin := Item.GetValue('BEP_DATEFIN')+ 60 / 1440;
  end;
  if not ControleRessourceDispo (CodeRes2,DatePrevDeb,DatePrevFin) then result := false;
end;

// Deplacement d'un item
procedure TMonPlanning.Deplacement(Sender: TObject; Item: TOB; var Cancel: boolean);
begin
  if (not ModeSaisie) then BEGIN Cancel := true;   CancelAction := True; exit; END;
  Cancel := CancelAction ;

  if Not Assigned(Item) then Exit;

  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	cancel := not DeplacementActionGRC (Item);
    if cancel then
    begin
    	ReChargeActionGRC (Item);
      exit;
    end;
  end else
  begin
    THPlanningBTP(Sender).Enabled := False;
    bValWindows.Tag := 2;
    //Rechargement du planning
    THPlanningBTP(Sender).Enabled := True;
    Cancel := not MajEvtAffectation('D', Item);
  end;

  if Cancel then
  begin
  	ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
  	exit;
  end;

  if FicAppel then ChargeIntervention;

end;

// Copie d'un item
procedure TMonPlanning.CopyItem(Sender: TObject; Item: TOB; var Cancel: boolean);
Var NumEvenement : String;
    CodeRes,CoderesIni      : String;
    NumAppel     : String;
    Equipe       : String;
    StSql        : String;
    Rep          : String;
    NumEvent     : Integer;
    I            : Integer;
    QQ           : TQuery;
    TobRessource : Tob;
    TobItemDe    : Tob;
    TobItemA     : Tob;
    Ok_Equipe    : Boolean;
begin

  Cancel := CancelAction ;
  if not IsModifiable (Item) then
  begin
  	cancel := true;
    exit;
  end;
  if CancelAction then exit;
  if Not Assigned(Item) then Exit;

  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	cancel := true; // dans un premier temps
    exit;
  end;

  //Controle du type d'action
  TypeAction := GetParamSoc('SO_TYPEACTION');

  IF NOT control_BtEtat('12') then exit;

  NumEvenement := Item.GetString('BEP_CODEEVENT');
  CodeRes      := Item.GetString('BEP_RESSOURCE');
  NumAppel     := Item.GetString('BEP_AFFAIRE');
  DesAction.text  := Item.GetString('BEP_BLOCNOTE');
  Ok_equipe := false;
  //Controle de cohérence de la duplication
  (*
  if cadencement = '005' then
     Begin
     Nbheure  := PlanningCurrent.GetCurItem.GetValue('BEP_DUREE');
     HeureDeb := PlanningCurrent.GetCurItem.GetValue('BEP_HEUREDEB');
     HeureFin := PlanningCurrent.GetCurItem.GetValue('BEP_HEUREFIN');
     DatePlanDeb := Item.GetValue('BEP_DATEDEB');;
     DatePlanDeb := Trunc(DatePlanDeb) + (HeureDeb);
     end
  else
     Begin
     DatePlanDeb := Item.GetValue('BEP_DATEDEB');//PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     DatePlanFin := Item.GetValue('BEP_DATEFIN');//PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     HeureDeb    := Item.GetValue('BEP_HEUREDEB');
     HeureFin    := Item.GetValue('BEP_HEUREFIN');
     Nbheure	   := Item.GetValue('BEP_DUREE');
	  end;
  *)
   DatePlanDeb := Item.GetValue('BEP_DATEDEB');//PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
   DatePlanFin := Item.GetValue('BEP_DATEFIN');//PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
   HeureDeb    := Item.GetValue('BEP_HEUREDEB');
   HeureFin    := Item.GetValue('BEP_HEUREFIN');
   Nbheure	   := Item.GetValue('BEP_DUREE');

//  DatePlanFin := DatePlanDeb + (NbHeure*60) / 1440;

  ChargementFicheHoraire (Item);

  //Controle si pas déjà une affectation pour la ressource arrivée sur la date et heure de duplication
  StSql := 'SELECT BEP_AFFAIRE FROM BTEVENPLAN WHERE BEP_RESSOURCE ="' + CodeRes + '" ';
  StSQL := StSql + 'AND BEP_DATEDEB="' + USDATETIME(DatePlanDeb) + {' ' + HDeb1.Text +} '"';
  QQ := OpenSQL(StSQL, true,-1,'',true);
  if Not QQ.Eof then
     Begin
     AfficheErreur('BTPLANNING', '4', 'Duplication d''Affectation');
     Ferme(QQ);
     Cancel := True;
     Exit;
     end;
  Ferme(QQ);

  if numAppel <> '' then
  begin
    //Contrôle si appartient à une équipe et si oui demande si duplication sur toute l'équipe
    StSQL := 'SELECT ARS_EQUIPERESS FROM RESSOURCE WHERE ARS_RESSOURCE ="' + CodeRes + '"';
    QQ := OpenSQL(StSQL, true,-1,'',true);
    Ok_Equipe := False;

    if Not QQ.Eof then
       Begin
       Equipe := QQ.FindField('ARS_EQUIPERESS').AsString;
       if Equipe <> '' then
          If PgiAsk('Voulez-vous appliquer la duplication à l''ensemble de l''équipe '+ Equipe + ' ?', rep)=MrYes then Ok_Equipe := true;
       end;

    Ferme(QQ);
  end;
  //chargement d'un tob avec item d'origine
  StSql := 'SELECT * FROM BTEVENPLAN WHERE BEP_CODEEVENT ="' + NumEvenement + '"';
  QQ := OpenSQL(StSQL, true,-1,'',true);
  TobItemDe := Tob.Create('Tob Depart', nil, -1);
  TobItemDe.LoadDetailDB('BTEVENPLAN', '', '', QQ, False);
  Ferme(QQ);

  HTypeAction.text := '';
  HTypeAction.text := TobItemDE.detail[0].getvalue('BEP_BTETAT');

  TobItemA := Tob.Create('BTEVENPLAN', nil, -1);

  if not ok_equipe then
  Begin
    TobItemA.Dupliquer(TobItemDe.Detail[0], true, true);
    //Chargement de la Tob des Evènements avec la tob de l'Appel
    if not GetNumCompteur('BEP', NumEvent) then
    begin
      AfficheErreur('BTPLANNING', '1', 'Affectation d''Appel');
      exit;
    end;
    TobItemA.PutValue('BEP_CODEEVENT', NumEvent);
    TobItemA.PutValue('BEP_RESSOURCE', CodeRes);
    TobItemA.PutValue('BEP_BTETAT', HTypeAction.text);
    TobItemA.PutValue('BEP_DUREE', NbHeure);
    TobItemA.PutValue('BEP_DATEDEB', Trunc(DatePlanDeb) + StrToTime(HDeb1.Text)); // XP 07.06.2006
    TobItemA.PutValue('BEP_HEUREDEB', StrToTime(HDeb1.Text));
    TobItemA.PutValue('BEP_DATEFIN', Trunc(DatePlanFin) + StrToTime(HFin1.Text)); // XP 07.06.2006
    TobItemA.PutValue('BEP_HEUREFIN', StrToTime(HFin1.Text));
    TobItemA.PutValue('BEP_BLOCNOTE', DesAction.text);
    TobItemA.PutValue('BEP_MODIFIABLE', 'X');
    TobItemA.InsertOrUpdateDB(true);
    //chargement des info pour affichage de l'item
    Item.SetString('BEP_CODEEVENT',  IntToStr(NumEvent));
//    ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], TobItemA, 0);
  	PlanningCurrent.InvalidateItem(Item);
//  	PlanningCurrent.Raffraichir;
  end Else
  Begin
    //Chargement d'une tob ressource en fonction de l'équipe
    TobRessource := Tob.Create('Les Ressources', nil, -1);
    StSql := 'SELECT ARS_RESSOURCE, ARS_EQUIPERESS FROM RESSOURCE WHERE ARS_EQUIPERESS ="' + Equipe + '"';
    QQ := OpenSQL(StSQL, true,-1,'',true);
    TobRessource.LoadDetailDB('RESSOURCES', '','', QQ, false);
    //Parcours de la tob ressource pour création des duplications...
    For I:=0 to TobRessource.detail.count-1 do
    begin
//    	if TobRessource.Detail[I].GetValue('ARS_RESSOURCE')=CodeRes then continue;
      TobItemA.Dupliquer(TobItemDe.Detail[0], true, true);
      //Chargement de la Tob des Evènements avec la tob de l'Appel
      if not GetNumCompteur('BEP', NumEvent) then
      begin
        AfficheErreur('BTPLANNING', '1', 'Affectation d''Appel');
        exit;
      end;
      TobItemA.PutValue('BEP_CODEEVENT', NumEvent);
      TobItemA.PutValue('BEP_RESSOURCE', TobRessource.Detail[I].GetValue('ARS_RESSOURCE'));
      TobItemA.PutValue('BEP_EQUIPERESS', Equipe);
      TobItemA.PutValue('BEP_BTETAT', HTypeAction.text);
      TobItemA.PutValue('BEP_DUREE', NbHeure);
      TobItemA.PutValue('BEP_DATEDEB', Trunc(DatePlanDeb) + StrToTime(HDeb1.Text)); // XP 07.06.2006
      TobItemA.PutValue('BEP_HEUREDEB', StrToTime(HDeb1.Text));
      TobItemA.PutValue('BEP_DATEFIN', Trunc(DatePlanFin) + StrToTime(HFin1.Text)); // XP 07.06.2006
      TobItemA.PutValue('BEP_HEUREFIN', StrToTime(HFin1.Text));
      TobItemA.PutValue('BEP_BLOCNOTE', DesAction.text);
    	TobItemA.PutValue('BEP_MODIFIABLE', 'X');
      if not TobItemA.InsertOrUpdateDB(true) then
      begin
      	PgiError ( 'Erreur sur insertion dans planning');
      end;
      //chargement des info pour affichage de l'item
      Item.SetString('BEP_CODEEVENT',  IntToStr(NumEvent));
      Item.SetString('BEP_EQUIPERESS', Equipe);
      if TobRessource.Detail[I].GetValue('ARS_RESSOURCE') <> CodeRes then
      begin
    		ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
      end;
    end;
  End;

  //Libération des Tobs de travail
  TobItemDe.free;
  TobItemA.free;
  if FicAppel then ChargeIntervention;

end;

// Supression d'un item
procedure TMonPlanning.Suppression(Sender: TObject; Item: TOB; var Cancel: boolean);
begin
  if (not ModeSaisie) then BEGIN Cancel := true;   CancelAction := True; exit; END;
  if item = nil then exit;

  if Item.GetValue('ACTIONSGRC') <> 0 then
  begin
  	SuppressionActionGRC (Item);
    cancel := true;
    exit;
  end;

  if (Item.getValue('BEP_CODEEVENT')='') then
  begin
  	Cancel := true;
    CancelAction := True;
    exit;
  end;

	VoirToutBoutons(False);

  Cancel := not MajEvtAffectation('S', Item);
  if Cancel then
  begin
 		ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
		VoirToutBoutons(True);
  	exit;
  end;
  cancel := true;
(*
  if not FicAppel then
  Begin
    if Not BAffAppel.Visible then DrawGAppel('BTCONTENUGAPP');
  end else
  begin
  	ChargeIntervention;
  end;

*)
	VoirToutBoutons(True);
end;

procedure TMonPlanning.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MyMenu: TMenuItem;
begin

  // Free tob des modeles de planning et tob des ressources
  if TobModelePlanning <> nil then  TobModelePlanning.Free;
  if TobOnglet <> nil then TobOnglet.free;
  if TobAppel <> nil then TobAppel.Free;
  if TobEtat <> nil then TobEtat.Free;
  if TobTaches <> nil then Tobtaches.free;
  if TobIntervention <> nil then TobIntervention.free;
  if TobEvenement <> nil then TobEvenement.free;
  if TobGrille <> nil then TobGrille.free;
  if TobSuppression <> nil then TobSuppression.free;

  //Lbération du Menu PopUp
  if MenuCadencement.items.count = 0 then exit;

  repeat
    MyMenu := MenuCadencement.items[0];
    if Assigned(MyMenu) then MyMenu.Free;
  until MenuCadencement.items.Count <= 0;

end;

procedure TMonPlanning.PageOngletChange(Sender: TObject);
var
  CodeFamres: string;
begin

  THPlanningBTP(Sender).Enabled := False;

  VoirToutBoutons(false);

  if PlanningCurrent <> nil then
     begin
     if NumLigneTO >= 0 then
        begin
        NumLigneTO := -1;
        planningCurrent.SupprimeLigneFixe(0);
        end;
     PlanningCurrent.free;
     PlanningCurrent := nil;
     PlanningCurrent := THplanningBTP.Create(TPageControl(Sender).ActivePage);
     PlanningCurrent.parent := Feuille[TPageControl(Sender).ActivePage.tag];
     PlanningCurrent.Name := Format('PLANNING%2.2d', [TPageControl(Sender).ActivePage.tag]);
     PlanningCurrent.Align := alClient;
     PlanningCurrent.AppelsTraites := CBTRAITE.Checked;
     if TypePlanning = 'PLA' then
	      PlanningCurrent.tag := TPageControl(Sender).ActivePage.tag
     else
	      PlanningCurrent.tag := 0;
     MajEvenements(PlanningCurrent);
     end;

  PlanningCurrent.TypePlanning := Typeplanning;

  // Recharge les onglets du planning
  if Typeplanning = 'PLA' then
     RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
     //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
     RechargePlanning(Tobonglet.Detail[TPageControl(Sender).ActivePage.tag]);

  Planning[TPageControl(Sender).ActivePage.tag] := PlanningCurrent;
  THPlanningBTP(Sender).Enabled := True;

  VoirToutBoutons(True);

end;

procedure TMonPlanning.BCalendrierClick(Sender: TObject);
var
  DateAvant: TDateTime;
  DateEnCours: TDateTime;
  ParamPlanning: string;
  StContrat: string;
  TousPossible : boolean;
begin

  StContrat := '-';
  ParamPlanning := '-';
  TousPossible := false;

  DateAvant := StrToDateTime(DateEdit.text);
  DateEdit.text := SaisieDate(StContrat, ParamPlanning, TypePlanning, TousPossible,DateEdit.text);
  DateEnCours := StrToDateTime(DateEdit.text);

  if DateEnCours = Idate1900 then
    DateEnCours := DateAvant;

  if DateEnCours <> DateAvant then
     begin
     if PlanningCurrent <> nil then
        begin
        PlanningCurrent.Activate := False;
        PlanningCurrent.free;
        PlanningCurrent := THplanningBTP.Create(PageOnglet.ActivePage);
        PlanningCurrent.parent := Feuille[PageOnglet.ActivePage.tag];
        PlanningCurrent.Name := Format('PLANNING%2.2d', [PageOnglet.ActivePage.tag]);
        PlanningCurrent.Align := alClient;
        PlanningCurrent.AppelsTraites := CBTRAITE.Checked;
        If TypePlanning = 'PLA' then
	         PlanningCurrent.tag := PageOnglet.ActivePage.tag
        Else
	         PlanningCurrent.tag := 0;
        //Evenements
        MajEvenements(PlanningCurrent);
        end;
        PlanningCurrent.TypePlanning := Typeplanning;
        DateSelectionee := DateEnCours;
        // Recharge les onglets du planning
        if Typeplanning = 'PLA' then
           RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
        else
	         RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);
           //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
        Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;
     end;

end;

procedure TMonPlanning.BPageSuivClick(Sender: TObject);
var
  DateEnCours: TDateTime;
  Intervalle: Integer;
begin

  THPlanningBTP(Sender).Enabled := False;

  VoirToutBoutons(false);
  
  //Récupération du planning en cours
  if TypePlanning = 'PLA' then
		 Intervalle := Round((TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_INTERVALLEDEB') +
                          TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_INTERVALLEFIN')) / 2)
  else
		 Intervalle := Round((TobModelePlanning.Detail[0].GetValue('HPP_INTERVALLEDEB') +
                          TobModelePlanning.Detail[0].GetValue('HPP_INTERVALLEFIN')) / 2);

  //Mise à jour de l'intervallle de temps du planning (décalage d'un planning vers la droite)
  DateEnCours := PlanningCurrent.DateOfStart + Intervalle;
  DateEdit.Text := DateTimeToStr(DateEnCours);
  PlanningCurrent := Planning[PageOnglet.ActivePage.tag];

  if PlanningCurrent <> nil then
     begin
     PlanningCurrent.free;
     PlanningCurrent := THplanningBTP.Create(PageOnglet.ActivePage);
     PlanningCurrent.parent := Feuille[PageOnglet.ActivePage.tag];
     PlanningCurrent.Name := Format('PLANNING%2.2d', [PageOnglet.ActivePage.tag]);
     PlanningCurrent.Align := alClient;
     If TypePlanning = 'PLA' then
	      PlanningCurrent.tag := PageOnglet.ActivePage.tag
     else
	      PlanningCurrent.tag := 0;
     //Evenements
     MajEvenements(PlanningCurrent);
     end;

  PlanningCurrent.TypePlanning := Typeplanning;

  // Recharge les onglets du planning
  if Typeplanning = 'PLA' then
     RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
     //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
     RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);

  Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;

  THPlanningBTP(Sender).Enabled := True;

  VoirToutBoutons(True);

end;

procedure TMonPlanning.BPagePrecClick(Sender: TObject);
var
  DateEnCours: TDateTime;
  Intervalle: Integer;
begin

  //Mise à jour de l'intervallle de temps du planning (décalage d'un planning vers la droite)
  THPlanningBTP(Sender).Enabled := False;

  VoirToutBoutons(false);

  if TypePlanning = 'PLA' then
		 Intervalle := TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_INTERVALLEDEB') +
    							 TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_INTERVALLEFIN')
  Else
		 Intervalle := TobModelePlanning.Detail[0].GetValue('HPP_INTERVALLEDEB') +
    							 TobModelePlanning.Detail[0].GetValue('HPP_INTERVALLEFIN');

  Intervalle := Round(intervalle / 2);
  DateEnCours := PlanningCurrent.DateOfStart - intervalle;
  DateEdit.Text := DateTimeToStr(DateEnCours);

  if PlanningCurrent <> nil then
  begin
    PlanningCurrent.free;
    PlanningCurrent := THplanningBTP.Create(PageOnglet.ActivePage);
    PlanningCurrent.parent := Feuille[PageOnglet.ActivePage.tag];
    PlanningCurrent.Name := Format('PLANNING%2.2d', [PageOnglet.ActivePage.tag]);
    PlanningCurrent.Align := alClient;
    If TypePlanning = 'PLA' then
	     PlanningCurrent.tag := PageOnglet.ActivePage.tag
		else
       PlanningCurrent.tag := 0;
    //Evenements
    MajEvenements(PlanningCurrent);
  end;

  PlanningCurrent.TypePlanning := Typeplanning;

  // Recharge les onglets du planning
  if Typeplanning = 'PLA' then
     RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
     //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
     RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);

  Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;

  THPlanningBTP(Sender).Enabled := True;

  VoirToutBoutons(True);

end;

//Gestion du menu PopUp
procedure TMonPlanning.OnPopup(Item: tob; ZCode: integer; var Redraw: boolean);
Var NumAppel 	: string;
    NumRes	 	: String;
    TobParam 	: Tob;
    TobResItem: Tob;
    LignePlan	: Integer;
    Sender		: TObject;
    NumEvent	: string;
    //
    stWhere  		: sTring;
    stNature 		: string ;
    stModele		: String;
    BApercu       : Boolean;
    BAp				: Boolean;
    BDuplicata    : Boolean;
    TheAction : string;
    DebutDemande,FinDemande : TDateTime;
    retour, TitreEtat : string;

begin

  if ZCode = 1 then
  Begin
     LignePlan := PlanningCurrent.Row - PlanningCurrent.FixedRows;
     TobResItem := PlanningCurrent.TobRes.Detail[LignePlan];
     Numres     := TOBResItem.GetString('ARS_RESSOURCE');
  	 // verification disponibilité
     DebutDemande := ConstitueDatePlanning (PlanningCurrent.GetDateOfCol(PlanningCurrent.Col),TTdDebut);
  	 FinDemande := ConstitueDatePlanning(PlanningCurrent.GetDateOfCol(PlanningCurrent.Col+1),TtdFin);
     if not ControleRessourceDispo (Numres,DebutDemande,FinDemande) then
     begin
    	PgiError ('Impossible : La ressource sélectionnée ne peut effectuer le travail aux heures indiquées');
      exit;
     end;
     //positionnement Ligne du planning
     TobParam := Tob.Create('AppelCreaAppel', nil, -1);
     //Chargement du code ressource
     DatePlanDeb := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     DatePlanFin := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     ChargementFicheHoraire (Item);
     TobParam.AddChampSupValeur('BEP_AFFAIRE', '');
     TobParam.AddChampSupValeur('RESSOURCE', NumRes);
     TobParam.AddChampSupValeur('BEP_EQUIPERESS', '');
     TobParam.AddChampSupValeur('DATEDEB', DatePlanDeb);
     TobParam.AddChampSupValeur('DATEFIN', DatePlanFin);
     TobParam.AddChampSupValeur('DUREE', NBHeure);
     TobParam.AddChampSupValeur('TYPEACTION', TypeAction);
     TobParam.AddChampSupValeur('RETOUR', -1);
     TheTob := TobParam;
		  if (not ModeSaisie) then TheAction := 'ACTION=CONSULTATION' else TheAction := 'ACTION=CREATION';

     AglLanceFiche ('BTP','BTAPPELINT','','',theAction+';PLANNING');
     TheTob := nil;
     //chargement des info pour affichage de l'item
     if TOBParam.GetValue('RETOUR') = 1 then
 	     ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], TOBParam, 2);
     TobParam.free;
     exit;
  end Else if ZCode = 2 then
  Begin
     if (not ModeSaisie) then exit;
     if Assigned(Item) then
        Begin
        NumAppel    := item.GetString('BEP_AFFAIRE');
        NumRes	    := item.GetString('BEP_RESSOURCE');
        DatePlanDeb := item.GetValue('BEP_DATEDEB');
        DatePlanFin := item.GetValue('BEP_DATEFIN');
        Nbheure     := Item.GetValue('BEP_DUREE');
        HeureDeb    := Item.GetValue('BEP_HEUREDEB');
        HeureFin    := Item.GetValue('BEP_HEUREFIN');
        if not Ismodifiable (Item) then
        begin
          exit;
        end;
        end;
     CodeDossierRech.text := NumAppel;
     if NumAppel <> '' then
        Begin
        //AGLLanceFiche ('BTP','BTAFFAPPEL','','', NumAppel + ';' + NumRes);
        OKVisuAffect := True;
     		FicAppel			:= True;
     		ChargeInfoAppel;
        TTWappels.Visible := True;
        end;
  end Else if ZCode = 3 then // Affectation d'appel
  Begin
     if (not ModeSaisie) then exit;
     if Assigned(Item) then
        Begin
        NumAppel := item.GetString('BEP_AFFAIRE');
        NumRes	 := item.GetString('BEP_RESSOURCE');
        end;
     CodeDossierRech.text := NumAppel;
     if NumAppel <> '' then
        Begin
	 	    AGLLanceFiche ('BTP','BTAFFAPPEL','','', NumAppel + ';' + NumRes);
        end;
  end Else if ZCode = 5 then // Edition de l'intervention
  Begin
     if Assigned(Item) then  NumAppel := item.GetString('BEP_AFFAIRE');
     CodeDossierRech.text := NumAppel;
     if NumAppel <> '' then
        Begin
        stWhere := 'AFF_AFFAIRE="' + NumAppel + '"';
        stNature := 'APP';
        stModele := GetParamsoc('SO_BTMODBI');
        BAp :=True;
        BDuplicata := false;
        TitreEtat := Copy (NumAppel,2,14);
        LanceEtat('E','INT',stModele,Bap, false, false,Nil,trim(StWhere),'INTERVENTION '+TitreEtat,BDuplicata);
        end;
  end Else if ZCode = 8 then // Création d'une action
  Begin
     LignePlan := PlanningCurrent.Row - PlanningCurrent.FixedRows;
     TobResItem := PlanningCurrent.TobRes.Detail[LignePlan];
     Numres     := TOBResItem.GetString('ARS_RESSOURCE');
     Retour := AGLLanceFiche('RT','RTACTIONS','','','MONOFICHE;ACTION=CREATION;RAC_INTERVENANT='+NumRes) ;
		 BRechargerClick (self);
  end;

end;

// Calendrier
procedure GetDateRecherche(F: TFORM; DATE: THCritMaskEdit);
var
  Key: Char;
begin
  Key := '*';
  PARAMDATE(F, DATE, Key);
end;

// Si touche F5 -> calendrier
procedure TMonPlanning.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if key = vk_F5 then BCalendrierClick(Self);

{$IFNDEF EAGLCLIENT}
  if Key = VK_ESCAPE then BQuitterClick(Self);
{$ENDIF}
end;

procedure TMonPlanning.BLegendeClick(Sender: TObject);
begin
  TTWLegende.Visible := Blegende.down;
end;

procedure TMonPlanning.BImprimeClick(Sender: TObject);
var
  Codefamres: string;
  Criteres: string;
begin

  CodeFamres := TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_FAMRES');

  Criteres := 'HCA_CALENDRIER=' + datetimetostr(PlanningCurrent.IntervalDebut) +
    '`HCA_CALENDRIER_=' + datetimetostr(PlanningCurrent.IntervalFin) +
    '`FAMRES=' + RechDom('HRFAMRES', CodeFamres, false);

{$IFNDEF EAGLCLIENT}
  LanceEtat('E', 'HOT', 'PRE', True, False, False, nil, '', '', False, 0, Criteres, PlanningCurrent.DoPrint);
{$ELSE}
  planningCurrent.TypeEtat := 'E';
  planningCurrent.NatureEtat := 'HOT';
  planningCurrent.CodeEtat := 'PRE';
  planningCurrent.Print(Criteres);
{$ENDIF}

end;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Créé le ...... : 07/06/2006
Modifié le ... :   /  /
Description .. : procédure appelée par le planning sur les évènements
Suite ........ : suivants :
Suite ........ : - copie, déplacement, suppression, etirement, réduction...
Mots clefs ... :
*****************************************************************}
procedure TMonPlanning.AvertirApplication(Sender: TObject; FromItem, ToItem: TOB; Actions: THPlanningAction);
begin

  //FromItem 	: TobItem de l'endroit d'où on part
  //ToItem		: TobItem de l'endroit où on arrive
  //Action		: Action effectuée

  (***
  THPlanningAction = (
    paCreate,
    paModif,
    paConsult,
    paDelete,
    paLink,
    paDelLink,
    paMove,
    paCopy,
    paAll,
    paNone,
    paExtend,
    paReduce,
    paClickLeft,
    paClickRight,
    paMouseMove,
    paCellEnter,
    paResizeColumns);
***)

	CancelAction := False;

  case Actions of
    paClickRight :
       Begin
         THPlanningBTP(Sender).DisplayOptionLiaison := False;
         if FromItem <> nil then
         Begin
            if FromItem.GetValue('BEP_CODEEVENT') = '' then
            Begin
              ThPlanningBTP(Sender).EnableOptionPopup(2, False);
              ThPlanningBTP(Sender).EnableOptionPopup(3, False);
              ThPlanningBTP(Sender).EnableOptionPopup(5, False);
              ThPlanningBTP(Sender).EnableOptionPopup(7, False);
            end else if FromItem.GetValue('BEP_AFFAIRE') = '' then
            Begin
              ThPlanningBTP(Sender).EnableOptionPopup(2, False);
              ThPlanningBTP(Sender).EnableOptionPopup(3, False);
              ThPlanningBTP(Sender).EnableOptionPopup(5, False);
            end else
            Begin
              ThPlanningBTP(Sender).EnableOptionPopup(2, true);
              ThPlanningBTP(Sender).EnableOptionPopup(3, true);
              ThPlanningBTP(Sender).EnableOptionPopup(5, True);
            end;
         end;
       end;
    paExtend :
    	begin
      	FenHoraire.Visible := false;
      	IF (ToItem <> nil) or Assigned(ToItem) then Extension(Sender, ToItem, CancelAction);
      end;
    paReduce :
    	begin
      	FenHoraire.Visible := false;
      	If (ToItem <> nil) or Assigned(ToItem) then Reduction(Sender, ToItem, CancelAction);
      end;
    paMove :
    	begin
      	FenHoraire.Visible := false;
        If (ToItem <> nil) or Assigned(ToItem) then Deplacement(Sender, ToItem, CancelAction);
      end;
    paDelete :
    	begin
      	FenHoraire.Visible := false;
    		CancelAction := false;
      end;
    paCellEnter :
    	begin
    		Affectation(Sender, ToItem, CancelAction);
    	end;
  else
   // CancelAction := true;
  end ;

end;

procedure TMonPlanning.BRechargerClick(Sender: TObject);
var
  DateEnCours: TDateTime;
begin

  // Rechargement des plannings
  uBtpEtatPlanning.BTP_LesEtats.ReLoad() ;

  //Mise à jour de l'intervallle de temps du planning (décalage d'un planning vers la droite)
  DateEnCours := PlanningCurrent.DateOfStart;
  PlanningCurrent := Planning[PageOnglet.ActivePage.Tag];

  VoirToutBoutons(false);

  if PlanningCurrent <> nil then
  begin
    PlanningCurrent.free;
    PlanningCurrent := ThPlanningBTP.Create(PageOnglet.ActivePage);
    PlanningCurrent.parent := Feuille[PageOnglet.ActivePage.tag];
    PlanningCurrent.Name := Format('PLANNING%2.2d', [PageOnglet.ActivePage.tag]);
    PlanningCurrent.Align := alClient;
  	DateEdit.Text := DateTimeToStr(DateEnCours);
    PlanningCurrent.AppelsTraites := CBTRAITE.Checked;

    If TypePlanning = 'PLA' then
	     PlanningCurrent.tag := PageOnglet.ActivePage.tag
    Else
	     PlanningCurrent.tag := 0;
    //Evenements
    MajEvenements(PlanningCurrent);
  end;

  PlanningCurrent.TypePlanning := Typeplanning;

  // Recharge les onglets du planning
  //ChargeParamPlanning(TobPlannings[PlanningCurrent.Tag], PlanningCurrent, TobModelePlanning.Detail[PlanningCurrent.Tag], DateEnCours, True);
  if Typeplanning = 'PLA' then
     RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
     //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
     RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);

  Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;

  VoirToutBoutons(True);

end;

procedure TMonPlanning.BQuitterClick(Sender: TObject);
begin
{$IFNDEF EAGLCLIENT}
  close;
{$ENDIF}
end;

procedure TMonPlanning.GestionSynchroDate(Item: tob);
var
  DateArrivee: TDateTime;
  DateDepart: TDateTime;
  i: integer;
  QDosRes: TQuery;
  QDossier: TQuery;
  TobDosRes: Tob;
  TobDossier: Tob;
begin

  DateArrivee := iDate1900;
  DateDepart := iDate1900;

  //MAJ dates dossier selon dates ligne;
  TobDosRes := Tob.create('les lignes', nil, -1);
  QDosres := OpenSQL('Select BEP_DATEFIN,BEP_DATEDEB from BTEVENPLAN where BEP_CODEEVENT="' + Item.getvalue('BEP_CODEEVENT') + '"', true,-1,'',true);
  try
    TobDosRes.LoadDetailDB('BTEVENPLAN', '', '', QDosRes, True)
  finally
    if QDosres <> nil then
      ferme(QDosres);
  end;

  if TobDosRes.Detail.Count > 0 then
  begin
    DateArrivee := TobDosRes.detail[0].getvalue('BEP_DATEDEB');
    DateDepart := TobDosRes.detail[0].getvalue('BEP_DATEFIN');
    for i := 1 to TobDosRes.Detail.Count - 1 do
    begin
      if TobDosRes.detail[i].getvalue('BEP_DATEDEB') < DateArrivee then
        DateArrivee := TobDosRes.detail[i].getvalue('BEP_DATEDEB');
      if TobDosRes.detail[i].getvalue('BEP_DATEFIN') > Datedepart then
        DateDepart := TobDosRes.detail[i].getvalue('BEP_DATEFIN');
    end;
  end;

  TobDosRes.free;
  TobDossier := Tob.Create('les Appels', nil, -1);
  QDossier := OpenSQL('Select AFF_DATEDEB,AFF_DATEFIN from AFFAIRE where AFF_AFFAIRE="' + Item.getvalue('BEP_CODEEVENT') + '"', true,-1,'',true);
  try
    TobDossier.LoadDetailDB('AFFAIRE', '', '', QDossier, False)
  finally
    if QDossier <> nil then
      ferme(QDossier);
  end;

  if TobDossier.detail.count > 0 then
  begin
    if TobDossier.Detail[0].getvalue('AFF_DATEDEBUT') <> DateArrivee then
      ExecuteSQL('update AFFAIRE set AFF_DATEDEBUT="' + USDATETIME(DateArrivee) + '" where AFF_AFFAIRE="' + item.getvalue('BEP_AFFAIRE') + '"');
    if TobDossier.Detail[0].getvalue('HDC_DATEDEPART') <> DateDepart then
      ExecuteSQL('update AFFAIRE set AFF_DATEFIN="' + USDATETIME(DateDepart) + '" where AFF_AFFAIRE="' + item.getvalue('BEP_AFFAIRE') + '"');
  end;

  TobDossier.free;

end;

procedure TMonPlanning.GestionDateLigne(Item: Tob);
begin
end;

//Recherche ???
procedure TMonPlanning.FormDestroy(Sender: TObject);
var
  i: integer;
begin

  PremierPassage := True;

  for i := 0 to NbOnglet - 1 do
      begin
      if feuille[i] <> nil then feuille[i].Free;
      with TobPlannings[i] do
           begin
           if TobItems <> nil then Tobfree(TobItems);
           if TobRes <> nil then   Tobfree(TobRes);
           if TobCols <> nil then  Tobfree(TobCols);
           if TobRows <> nil then  Tobfree(TobRows);
           if TobEvents <> nil then Tobfree(TobEvents);
           if TobPeriodeDivers <> nil then Tobfree(TobPeriodeDivers);
           end;
      end;

  NumLigneTO := -1;

  Application.HintHidePause := 10000;

end;

{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 03/10/2001
Modifié le ... :   /  /
Description .. : Fonction activer ou désativer les boutons pendant le
Suite ........ : chargement du planning
Mots clefs ... : BOUTONS, ACTIVER
*****************************************************************}

procedure TMonPlanning.VoirToutBoutons(choix: Boolean);
begin

  BRecharger.Enabled := Choix;

  PageOnglet.Enabled := Choix;
  BPageSuiv.enabled := Choix;
  BPagePrec.enabled := Choix;

  Timer1.Enabled := Choix;
  Timer2.Enabled := Choix;

end;

{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 16/10/2002
Modifié le ... :   /  /
Description .. : Mode : True creation
Suite ........ : Mode : False modification
Mots clefs ... :
*****************************************************************}

//function TMonPlanning.FonctionModif(Sender: TObject; Item: Tob): Boolean;
//begin
//end;

procedure TMonPlanning.MajEvenements(var MajPlanning: ThPlanningBTP);
begin

//  if (not ModeSaisie) then
//    exit;
  MajPlanning.OnModifyItem := Modification;
  MajPlanning.OnDeleteItem := Suppression;
  MajPlanning.OnCopyItem := CopyItem;
  MajPlanning.OnInitItem := InitItem;
  MajPlanning.OnCreateItem := Creation;
  MajPlanning.OnLink := Link;
  MajPlanning.OnmoveItem := CheckMoveItem;
  MajPlanning.AddOptionPopup(6, '-');

  MajPlanning.AddOptionPopup(5, 'Edition Intervention');

  MajPlanning.AddOptionPopup(7, '-');
  MajPlanning.AddOptionPopup(8, 'Ajout d''une action');
  MajPlanning.AddOptionPopup(4, '-');

  MajPlanning.AddOptionPopup(2, 'Modification Affectation');
  MajPlanning.AddOptionPopup(3, 'Visualisation Appel');

  If (not FicAppel) and (ModeSaisie) then MajPlanning.AddOptionPopup(1, 'Création d''Appel');

  MajPlanning.OnOptionPopup := OnPopup;

  MajPlanning.OnAvertirApplication := AvertirApplication;

  MajPlanning.OnBeforeChange := P1BeforeChange;
  MajPlanning.OnDblClickSpec := DoubleClickSpec;

end;

procedure TMonPlanning.P1BeforeChange(const Item: TOB; const LaRessource: string; const LaDateDeDebut, LaDateDeFin: TDateTime; var Cancel: Boolean);
var codeRes,Coderes2 : string;
		DDeb : TDateTime;
    Item2 : TOB;
    LignePlan : integer;
    TOBresItem : TOB;
begin
	if (not ModeSaisie) then cancel := true;
  Cancel := False;
  if Item <> nil then
  begin
    if not IsModifiable (Item) then
    begin
      cancel := true;
      exit;
    end;
  // contrôle de la possibilité de faire l'action
    if Item.getValue('ACTIONSGRC')=0 then exit;
    //
    CodeRes		:= Item.GetValue('BEP_RESSOURCE');
    if CodeRes <> LaRessource then
    begin
      cancel := true;
      exit;
    end;
  end;

  // Cas partis on ne peut pas etirer, reduire ou deplacer...
  PlanningCurrent.DisplayOptionSuppressionLiaison := False;

end;

procedure TMonPlanning.Timer1Timer(Sender: TObject);
begin

	if TTWappels.Visible then exit;

  BRechargerClick(Sender);

end;

procedure TMonPlanning.GestionTimer;
begin

  Self.Timer1.Enabled := False;
  Self.Timer2.Enabled := False;

  if TobModelePlanning.Detail[PlanningCurrent.Tag].FieldExists('HPP_DUREETIMER') then
     begin
     if (TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_DUREETIMER') > 0) then
        begin
        Self.Timer1.Interval := TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_DUREETIMER') * 60000;
        Self.Timer1.Enabled := True;
        Self.Timer2.Interval := TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_DUREETIMER') * 60000;
        Self.Timer2.Enabled := True;
        end;
     end;

end;

procedure TMonPlanning.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if key = vk_F5 then BCalendrierClick(Self);

end;

{***********A.G.L.Privé.*****************************************
Auteur  ...... : Régis HARANG
Créé le ...... : 21/11/2002
Modifié le ... :   /  /
Description .. : Fonction qui géré les cliques dans les zones grisés du
Suite ........ : planning Ressources & evènements
Mots clefs ... : RESSOURCE;EVENEMENT
*****************************************************************}
procedure TMonPlanning.DoubleClickSpec(ACol, ARow: INTEGER; TypeCellule: TPlanningTypeCellule; T: TOB);
var CodeAffaire	: String;
	  Item      : Tob;
  	LignePlan : Integer;
    NumAppel	: String;
    TOBREsItem : TOB;
    DebutDemande,FinDemande : TDateTime;
    Numres : string;
    heureDef : double;
    QQ : TQuery;
    Auxiliaire:string;
    NumAct:integer;
begin
  if (not ModeSaisie) then exit;
  OkAffect := False;

  bValWindows.Tag := 0;

  //positionnement Ligne du planning
  LignePlan := PlanningCurrent.Row - PlanningCurrent.FixedRows;
  TobResItem := PlanningCurrent.TobRes.Detail[LignePlan];
  Numres     := TOBResItem.GetString('ARS_RESSOURCE');
  Item := PlanningCurrent.GetCurItem;
//  Item := PlanningCurrent.TobRes.Detail[LignePlan];

  if Item = Nil then
  Begin
  // verification disponibilité
    DebutDemande := ConstitueDatePlanning (PlanningCurrent.GetDateOfCol(PlanningCurrent.Col),TTdDebut);
    QQ := OpenSQL('SELECT BTA_DUREEMINI FROM BTETAT WHERE BTA_BTETAT="'+TypeAction+'"', True,-1,'',true);
    if not QQ.eof then
    begin
    	heureDef := QQ.findfield('BTA_DUREEMINI').asfloat;
    	FinDemande := AjouteDuree (DebutDemande,Round(heureDef*60));
    end else
    begin
    	FinDemande := ConstitueDatePlanning (PlanningCurrent.GetDateOfCol(PlanningCurrent.Col+1),TTdFin);
    end;
    ferme (QQ);
    if not ControleRessourceDispo (Numres,DebutDemande,FinDemande) then
    begin
      PgiError ('Impossible : La ressource sélectionnée ne peut effectuer le travail aux heures indiquées');
      exit;
    end;
    DatePlanDeb := DebutDemande;
    DatePlanfin := FinDemande;
    Nbheure := CalculDureeEvenement (DebutDemande,FinDemande);
  end;
  //Si on ne vient pas d'une fiche appel
  if not FicAppel then
  Begin
  	// double click sur un evenement ne provenant pas d'un appel
    VoirToutBoutons(false);
    Item := PlanningCurrent.GetCurItem;
    if Item <> Nil then
    Begin
      NumAppel := Item.GetString('BEP_AFFAIRE');
      if Item.GetValue('ACTIONSGRC') <> 0 then
      begin
      	if Ismodifiable(Item) then
        begin
        	ModificationsActionGRC (Item);
        end else
        begin
          Auxiliaire:= Item.GetValue('CLIENTGRC');
          NumAct:= Item.GetValue('ACTIONSGRC');
          AGLLanceFiche('RT','RTACTIONS','',Auxiliaire+';'+IntToStr(NumAct),'ACTION=CONSULTATION') ;
        end;
      end else if NumAppel = '' then
      begin
        ChargementModifEvenement(Item)
      end else
      Begin
        CodeRes := PlanningCurrent.TobRes.Detail[LignePlan].GetString('ARS_RESSOURCE');
        AGLLanceFiche ('BTP','BTAFFAPPEL','','',NumAppel + ';' + CodeRes);
      end;
    end;
    VoirToutBoutons(True);
    exit;
  end;

  //VoirToutBoutons(False);

  //Chargement de la TOB entete
  TobItem := PlanningCurrent.GetCurItem;
  Item := PlanningCurrent.TobRes.Detail[LignePlan];

  //Chargement du code ressource
  CodeRes     := Item.GetString('ARS_RESSOURCE');
  Calendrier  := Item.GetString('ARS_STANDCALEN');
  Equipe      := Item.GetString('ARS_EQUIPERESS');

  if Item.GetString('ARS_CALENSPECIF') = '-' then
     OkSpecifCal := False
  Else
     OkSpecifCal := True;

  //Gerer le Calendrier !!!!!!
  (*
  if Cadencement = '005' then
     Begin
     DatePlanDeb := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     DatePlanFin := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     HeureDeb    := Getparamsoc('SO_HEUREDEB');
     HeureFin    := GetParamSoc('SO_HEUREFIN');
     Nbheure	   := 0;
     DatePlanDeb := Trunc(DatePlanDeb) + (HeureDeb);
     DatePlanFin := Trunc(DatePlanFin) + (HeureFin);
     end
  else
     Begin
     DatePlanDeb := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col);
     DatePlanFin := PlanningCurrent.GetDateOfCol(PlanningCurrent.Col)+ 60 / 1440;
     end;
  *)
  if CodeAffaire <> '' then OkAffect := True;

  ChargementFicheHoraire(Item);

  //Controle si la ressource n'existe pas déjà dans la liste
  OkValAction := ControleAffectation(Item);
  if not OkValAction then
     Begin
     TTWAppels.Caption := 'Ressources Affectées';
     TTWAppels.Hint := 'Liste des Ressources Affectées sur appel';
		 TTWAppels.Visible := True;
     exit;
     end;

  TTWAppels.Caption := 'Ressources Affectées';
  TTWAppels.Hint := 'Liste des Ressources Affectées';

  TTWAppels.Visible := True;

  //Controle si ressource appartient à une Equipe
  if Equipe = '' then
     ChargeElementGrille(Item)
  else
     if not RechEquipe then ChargeElementGrille(Item);

end;

//procedure TMonPlanning.NePasEtirer(Item: TOB);
//begin
//end;

procedure TMonPlanning.ExcelexportClick(Sender: TObject);
var
  fil: string;
begin

  fil := GetparamSoc('SO_BTREPPLANNING') + '\' + TobModelePlanning.Detail[PlanningCurrent.Tag].GetValue('HPP_LIBELLE');

  planningCurrent.ExportToExcel(true, fil, V_PGI.RunAfterExport); {+}

end;

{function TMonPlanning.RecupPeriode(NumeroPeriode: integer): string;
begin

  result := '';

  // GF 19/01/06 teste si tob <> Nil
  if Assigned(planningCurrent.TobPeriodeDivers) then
    if (NumeroPeriode >= 0) and (NumeroPeriode < planningCurrent.TobPeriodeDivers.detail.count) then
      Result := planningCurrent.TobPeriodeDivers.detail[NumeroPeriode].getstring('CC_CODE');

end;
}
procedure TMonPlanning.Link(Sender: TObject; TobSource, TobDestination: TOB; Option: THPlanningOptionLink; var Cancel: Boolean);
begin
	if not ModeSaisie then cancel := true;
end;

function TMonPlanning.ChargeLegende : boolean;
var i: integer;
    TobLeg  : tob;
begin

  result := true;

  TobLeg := Tob.create('LesEtats', nil, -1);
  TobLeg.LoadDetailFromSQL('SELECT * FROM BTETAT WHERE BTA_ASSOSRES = "X"', False);

  // XP 07.06.2006
  //for i := 0 to uBtpEtatPlanning.BTP_LesEtats.Detail.Count - 1 do
  //  if uBtpEtatPlanning.BTP_LesEtats.Detail[i].GetString('BTA_ASSOSRES') = 'X' then
  //    TOB.Create('', TobEtat, -1).Dupliquer(uBtpEtatPlanning.BTP_LesEtats.Detail[i], True, True);

  SetLength(Libelle, TobLeg.Detail.Count);
  SetLength(Couleur, TobLeg.Detail.Count);

  TTWLegende.Caption := 'Legende';
  TTWLegende.Height := (TobLeg.Detail.Count + 1) * 20 + 30;

  {Taille Mini du panneau}
  if TTWLegende.Height < 165 then TTWLegende.Height := 165;

  if TobLeg.detail.count = 0 then
     begin
     result := false;
     TobLeg.free;
     exit;
     end;

  for i := 0 to TobLeg.detail.count - 1 do
      begin
      //Gestion de la Couleur
      Couleur[I] := TLabel.Create(Self);
      Couleur[I].Parent := TTWlegende;
      Couleur[I].Name := 'Couleur' + IntToStr(I);
      Couleur[I].Left := 10;
	    Couleur[I].Height := 20;
      Couleur[I].caption := ' '+TobLeg.Detail[I].GetValue('BTA_BTETAT')+' ';
      Couleur[I].Color   := StringToColor(TobLeg.Detail[I].GetValue('BTA_COULEURFOND'));
      Couleur[I].Font.Color   := StringToColor(TobLeg.Detail[I].GetValue('BTA_COULEUR'));
      Couleur[I].Transparent := false;
      if I = 0 then
         Couleur[I].Top := 5
      else
	       Couleur[I].Top := Couleur[I-1].Top + 20;
      //Gestion du Libelle
      Libelle[I] := TLabel.Create(Self);
      Libelle[I].Parent := TTWlegende;
      Libelle[I].Name := 'Libelle' + IntToStr(I);
      Libelle[I].caption := TobLeg.Detail[I].GetValue('BTA_ABREGE');
      Libelle[I].Left := Couleur[I].left + Couleur[I].Width + 10;
      Libelle[I].Transparent := true;
      if I = 0 then
         Libelle[I].Top := 5
      else
	       Libelle[I].Top := Couleur[I-1].Top + 20;
      end;

  TobLeg.free;

end;

//Chargement du menu en fonction de la Tablette Cadencement
procedure TMonPlanning.ChargeMenuCadencement;
var
  QQ: TQuery;
  StSql: string;
  TobCad: Tob;
  I: Integer;
  ITemMenCad: TmenuItem;
begin

  Cadencement := TobModelePlanning.Detail[PlanningCurrent.Tag].Getvalue('HPP_CADENCEMENT');

  StSql := 'SELECT CO_CODE, CO_LIBELLE FROM COMMUN WHERE CO_TYPE="BCA" AND CO_ABREGE<>"X" ORDER BY CO_CODE';
  QQ := OpenSQL(StSQl, True,-1,'',true);

  if QQ.Eof then
     begin
     MenuCadencement.Free;
     bcadencement.visible := false;
     Ferme(QQ);
     Exit;
     end;

  TobCad := Tob.create('Les Cadencements', nil, -1);
  TobCad.LoadDetailDB('COMMUN', '', '', QQ, False);
  Ferme(QQ);

  for I := 0 to TobCad.Detail.count - 1 do
    begin
    ITemMenCad := TmenuItem.Create(Self);
    ITemMenCad.Caption := TobCad.Detail[I].getValue('CO_LIBELLE');
    ITemMenCad.OnClick := ChangeCadencement;
    if Cadencement = TobCad.Detail[I].getValue('CO_CODE') then
       begin
       MenuCadencement.Items.Add(ITemMenCad);
       //MenuCadencement.Items.Checked := True;
       ITemMenCad.Checked := true;
       end
    else
       Begin
       MenuCadencement.Items.Add(ITemMenCad);
       ITemMenCad.Checked := False;
       end;
    end;

  TObCad.free;

end;

procedure TMonPlanning.DrawGAppel(NomTablette : String);
Var I			: integer;
	 NbCol   : Integer;
   StTmp	: String;
Begin

  NbCol := 0;

  HPanel1.Visible := false;
  BValidAff.Visible := False;
  BRefreshAff.Visible := True;

//  CHKTACHES.Visible := True; modif BRL 08/07/08 : en attendant les tests et la validation ...
  CHKTACHES.Visible := False;

  StTmp := MajItem(RechDom(NomTablette, TobModelePlanning.Detail[PlanningCurrent.tag].GetValue('HPP_AXECONTINGENT1'), true), DessineGAppel, 'ZZ');

  //chargement des zones de travail avec les infos de la liste associées
  //I := pos ('-', StTmp);
  //If I <> 0 then TableGapp := Copy(StTmp, 1, I - 1) ;
  //StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

  //I := pos ('-', StTmp);
	//StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

	//I := pos ('-', StTmp);
  //If I <> 0 then TriGapp := Copy(StTmp, 1, I - 1) ;
  //StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

	//I := pos ('-', StTmp);
  //If I <> 0 then ColGAppel := Copy(StTmp, 1, I - 1) ;
  //StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

	//I := pos ('-', StTmp);
  //If I <> 0 then LibGappel := Copy(StTmp, 1, I - 1) ;
  //StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

	//I := pos ('-', StTmp);
  //If I <> 0 then LarGappel := Copy(StTmp, 1, I - 1) ;
  //StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

  //I := pos ('-', StTmp);
	//StTmp := Copy (StTmp, I+1, length (StTmp) - I) ;

  //I := pos ('-', StTmp);
  //If I = 0 then
  //   Begin
  //   TTWAppels.Caption := StTmp;
  //   TTWAppels.Hint := StTmp;
  //   end;

  //Dessin de la grille des appels
  DessineGrille(TTWAppels, GrilleSelection, DessineGAppel);

  //calcul du Nombre de Colonne
  //StTmp := ColGAppel;
  //while  StTmp <> '' do
  //   begin
  //   NbCol := NbCol + 1;
  //   ReadTokenst(StTmp);
  //   end;

  //if nbcol = 0 then exit;

  //Dessin de la grille
	//With GrilleSelection do
  //     Begin
 	//	   RowCount := 2;
  //		 ColCount := NbCol + 1;
	//		 FixedCols := 1;
	//		 FixedRows := 1;
	//		 DefaultRowHeight := 20;
  //     ColWidths[0] := 5;
  //     Cells[0,0] := '';
  //     if ColCount <> 1 then
  //        TTWAppels.Width := 0
  //     else
  //        TTWAppels.Width := 581;
 	//     For i := 1 to ColCount - 1 Do
  //         Begin
	//         Cells[I, 0] 	:= ReadTokenst(LibGAppel);
  //         TailleCol   	:= StrToFloat(ReadTokenst(LarGAppel));
  //         TailleCol		:= round((TailleCol * 6.25));
  //         TTWAppels.Width := TTWAppels.Width + StrToInt(FloatToStr(TailleCol)); //round((TailleCol * 6.25)
	//	       ColWidths[I] := StrToInt(FloatToStr(TailleCol));
	//				 end;
  //     end;

  //Affichage et recentrage de la ttoolwindow TTWappel après chargement
  //if TTWAppels.width >=  Screen.Width then
  //   Begin
  //   Taillecol := TTWAppels.Width;
  //   TTWAppels.Width :=  round((Taillecol / 2));
  //   end;

  //TTWAppels.Left:=(Screen.Width-TTWAppels.width) div 2;
  //TTWAppels.Top:=(Screen.Height-TTWAppels.height) div 2;

  ChargeAppel;

end;

procedure TMonPlanning.ChargeAppel;
var QAppel		 : TQuery;
	  I					 : integer;
    J					 : integer;
  	StSQL			 : string;
    ZoneTable	 : String;
begin

  BAFFAppel.Visible := False;
  Baffappel.down := BAFFAppel.Visible;

	ZoneTable := '';

  StSql := DessineGAppel.ColGAppel;

  //Chargement de la TOB
  while  StSql <> '' do
     begin
     if ZoneTable = '' Then
	ZoneTable := ReadTokenst(StSql)
     else
	ZoneTable := ZoneTable + ',' + ReadTokenst(StSql);
     end;

  TobAppel := Tob.create('Les Appels', nil, -1);

  if DessineGAppel.TableGapp = '' then DessineGAppel.TableGapp := 'AFFAIRE';
  StSQL := 'SELECT AFF_DESCRIPTIF,AFF_AFFAIREINIT,AFF_CREERPAR,' + ZoneTable  + ' FROM ' + DessineGAppel.TableGapp + ' WHERE AFF_AFFAIRE0 = "W" AND AFF_ETATAFFAIRE = "ECO" ';

  if chktaches.Checked then
     StSql := StSQL + ' AND AFF_CREERPAR="TAC"';

  if DessineGAppel.TriGapp <> '' then  StSQL := StSQL + ' ORDER BY ' + DessineGAppel.TriGapp;

  QAppel := OpenSQL(StSQL, True,-1,'',true);
  if Qappel.Eof then
     Begin
     Ferme(QAppel);
     exit;
     end;

  TobAppel.LoadDetailDB('AFFAIRE', '', '', QAppel, False);
  Ferme(QAppel);
  Creerpar    := TobAppel.detail[0].Getvalue('AFF_CREERPAR');
  AffaireInit := TobAppel.detail[0].Getvalue('AFF_AFFAIREINIT');
  CodeTiers   := TobAppel.detail[0].Getvalue('AFF_TIERS');
  BAFFAppel.Visible := True;

  StSql := DessineGAppel.ColGAppel;

  with GrilleSelection do
       Begin
       if TobAppel.detail.count = 0 then
	        RowCount := TobAppel.detail.count + 2
       else
          RowCount := TobAppel.detail.count + 1;
 	     For i := 0 to TobAppel.detail.count - 1 Do
           Begin
           Cells[0, I] := '';
           StSql := DessineGAppel.ColGAppel;
  		     For J := 1 to ColCount - 1 do
               begin
               Cells[0, I+1] := '';
               Cells[J, I+1] := TobAppel.Detail[I].GetValue(ReadTokenst(StSql));
					     end;
           Cells[J+1, I+1] := TobAppel.Detail[I].GetValue('AFF_AFFAIRE');
           Cells[J+2, I+1] := TobAppel.Detail[I].GetValue('AFF_DESCRIPTIF');
           end;
       row := 1;
       Descriptif.Text := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_DESCRIPTIF');
       end;

end;

//chargement de la TOBIntervention avec les info de l'appel
procedure TMonPlanning.ChargeInfoAppel;
var TQAppel		: TQuery;
    TQTiers		: TQuery;
    TQContact	: TQuery;
    TQAdrInt	: TQuery;
    TQTache   : TQuery;
    Auxiliaire: string;
    Contact		: string;
    StSQL			: string;
    InfoAppel	: String;
begin

  //Affichage des infos de l'appel en bas de l'écran.

  InfoAppel	:= 'Appel N° ' + CodeDossierRech.text + ' ';

  label11.Caption := InfoAppel;
  label11.Visible := true;

  //remise à zéro des zones de la TOB
  if Assigned(TobGrille) then
     TobGrille.free;
  if Assigned(TobEvenement) then
     TobEvenement.Free;
  if Assigned(TobSuppression) then
     TobSuppression.Free;

  TobIntervention := Tob.create('AFFAIRE', nil, -1);

  //Chargement de la table intervention
  StSQL := 'SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE ="' + CodeDossierRech.text + '"';
  TQAppel := OpenSQL(StSQL, True,-1,'',true);

  if TQAppel.Eof then
     Begin
     Ferme(TQAppel);
     Exit;
     end;

  //chargement de la Tob pour mise à jour de l'appel
  TobIntervention.selectDB('', TQAppel);

  Ferme(TQAppel);

  //chargement de la tob Appel pour affichage détail appel si vient
  //intervention Préventive...
  Creerpar    := TobIntervention.Getvalue('AFF_CREERPAR');
  AffaireInit := TobIntervention.Getvalue('AFF_AFFAIREINIT');
  CodeTiers   := TobIntervention.Getvalue('AFF_TIERS');

  if CreerPar <> 'TAC' then
     BTaches.Visible := False
  else
     BTaches.Visible := True;

  BValidAff.Visible := True;
  BRefreshAff.Visible := False;

  Responsable := TobIntervention.GetValue('AFF_RESPONSABLE');

  Label3.Caption := 'APPEL N°' + TobIntervention.GetValue('AFF_AFFAIRE1');
  Label3.Caption := Label3.caption + TobIntervention.GetValue('AFF_AFFAIRE2');
  Label3.Caption := Label3.caption + TobIntervention.GetValue('AFF_AFFAIRE3');
  Descriptif.Text:= TobIntervention.GetValue('AFF_DESCRIPTIF');

  DateAppel := TobIntervention.GetValue('AFF_DATEDEBUT');

  //Lecture Tiers
  StSQL := 'SELECT T_LIBELLE, T_AUXILIAIRE FROM TIERS ';
  StSQL := StSQL + 'WHERE T_NATUREAUXI ="CLI" AND T_TIERS="' + TobIntervention.GetString('AFF_TIERS') + '"';
  TQTiers := OpenSQL(StSQL, True,-1,'',true);

  if not TQTiers.Eof then
     begin
     Label4.caption := 'Tiers : ' + TQTiers.FindField('T_LIBELLE').AsString;
     Label4.caption := Label4.caption + ' (' + TobIntervention.GetValue('AFF_TIERS') + ')';
     Auxiliaire := TQTiers.FindField('T_AUXILIAIRE').AsString;
     InfoAppel := InfoAppel + 'de ' + TQTiers.FindField('T_LIBELLE').AsString + ' ';
     end
  else
     Label4.caption := 'Tiers Inconnu';

  Ferme(TQTiers);

  //Lecture Adresse Intervention
  StSQL := 'SELECT ADR_ADRESSE1, ADR_CODEPOSTAL, ADR_VILLE, ADR_TELEPHONE FROM ADRESSES WHERE ADR_REFCODE="' + TobIntervention.getvalue('AFF_AFFAIRE') + '" ';
  StSQL := StSQL + 'AND ADR_TYPEADRESSE="INT"';

  TQAdrInt := OpenSQL(StSQL, True,-1,'',true);

  if not TQAdrInt.Eof then
     begin
     Label5.caption := TQAdrInt.FindField('ADR_ADRESSE1').AsString;
     Label6.caption := TQAdrInt.FindField('ADR_CODEPOSTAL').AsString;
     Label7.caption := TQAdrInt.FindField('ADR_VILLE').AsString;
     Label9.caption := 'Tel : ' + TQAdrInt.FindField('ADR_TELEPHONE').AsString;
     if TQAdrInt.FindField('ADR_TELEPHONE').AsString <> '' then InfoAppel := InfoAppel + '(' + TQAdrInt.FindField('ADR_TELEPHONE').AsString + ')';
     end
  else
     begin
     Label5.caption := '';
     Label6.caption := '';
     Label7.caption := '';
     Label9.caption := '';
     end;

  Ferme(TQAdrInt);

  //Lecture Contact;
  Contact := TobIntervention.getvalue('AFF_NUMEROCONTACT');

  if contact <> '0' then
     Begin
     StSql := 'SELECT C_NOM FROM CONTACT ';
     StSql := StSQL + 'WHERE C_AUXILIAIRE ="' + Auxiliaire + '"';
     StSql := StSQL + '  AND C_NUMEROCONTACT =' + Contact;
     TQContact := OpenSQL(StSQL, True,-1,'',true);
     if not TQContact.Eof then
        Label8.caption := TQContact.FindField('C_NOM').AsString
     else
      	Label8.caption := '';
     Ferme(TQContact);
     end;

  //Controle du type d'action
  TypeAction := GetParamSoc('SO_TYPEACTION');

  //vérification si l'appel provient d'une tache
  if CreerPar = 'TAC' then
     Begin
     Stsql := 'SELECT ATA_BTETAT, ATA_JOURFERIE, ATA_NBJOURSDECAL, ATA_QTEINTERVENT, ';
     StSQL := StSQL + 'ATA_UNITETEMPS FROM TACHE ';
     StSQL := StSQL + 'WHERE ATA_AFFAIRE="' + AffaireInit + '"';
     StSQL := StSQL + '  AND ATA_TIERS="' + CodeTiers + '"';
     StSQL := StSQL + '  AND ATA_NUMEROTACHE=' + IntToStr(TobIntervention.Getvalue('AFF_NUMEROTACHE'));
     TQTache := OpenSQL(StSQL, True,-1,'',true);
     TobTaches.selectDB('', TQTache);
     if not TQTache.eof then TypeAction := TobTaches.GetValue('ATA_BTETAT');
     Ferme(TQTache);
     end;

  if Not Control_BtEtat('15') then exit;

  if Not OkAppelLibre then
     if TTWappels.Visible then TTWappels.Visible := False;

  HPanel1.Visible := True;
  BValidAff.Visible := True;
  BRefreshAff.Visible := False;
  CHKTACHES.Visible := False;

  ChargeIntervention;

end;

//Controle de l'existence du type d'action
Function TMonPlanning.Control_BtEtat(NumErreur : String) : boolean;
var QQ : TQuery;
Begin

  Result := false;

  if TypeAction = '' then
     Begin
     AfficheErreur('BTPLANNING', NumErreur, 'Erreur d''affectation');
     Exit;
     end;
  QQ := OpenSql('Select * from BTETAT WHERE BTA_BTETAT="' + TypeAction + '" ORDER BY BTA_BTETAT',True,-1,'',true);
  //Création de la Tob Tache
  if QQ.eof then
     begin
     AfficheErreur('BTPLANNING', NumErreur, 'Erreur d''affectation');
     end
  else
     Begin
     TobEtat.SelectDB ('',QQ);
     Result := True;
     end;
  ferme(QQ);

end;


//chargement de la TOBIntervention avec les info de l'appel
procedure TMonPlanning.ChargeIntervention;
Var NbColFixe: Integer;
begin

  //Initialisation de la grille
  NbColFixe := TobModelePlanning.Detail[PlanningCurrent.tag].GetValue('HPP_NBCOLDIVERS');

  //Chargement de la Tablette des zone des colonnes Fixes
  DrawGrille(NbColFixe);

  //Contrôle si les affectation ne sont pas déjà faites et chargement du tableau
  ChargeTableEvtGrille;

end;

procedure TMonPlanning.TTWLegendeClose(Sender: TObject);
begin
  BLegende.Down := False;
end;

procedure TMonPlanning.BAffAppelClick(Sender: TObject);
begin

  //if BAffAppel.down then ChargeAppel;

  TTWAppels.Visible := BAffAppel.down;
  TTWAppels.Caption := 'Liste des appels non affectés';

  if BAffAppel.down then DrawGappel('BTCONTENUGAPP');

end;

procedure TMonPlanning.TTWAppelsClose(Sender: TObject);
begin
  BAffAppel.Down := False;
end;

//Procedure de recherche de l'équipe associée à une ressource
function TMonPlanning.RechEquipe : Boolean;
var StSql: string;
    ZoneLue: string;
    rep: string;
    I: Integer;
    QQ: TQuery;
    TobEquipe: Tob;
begin

  Result := False;

  ZoneLue := 'ARS_RESSOURCE,' + FindEtReplace(ColNames, ';', ',', true);

  StSQL := 'SELECT ' + ZoneLue + ' FROM RESSOURCE ';
  StSQL := StSQL + 'WHERE ARS_EQUIPERESS="' + Equipe + '" ';
  StSQL := StSQL + 'ORDER BY ARS_TYPERESSOURCE';

  QQ := OpenSQL(StSql, True,-1,'',true);
  if QQ.eof then
     begin
     Ferme(QQ);
     Exit;
     end;

  if PGIAsk(TraduireMemoire('La Ressource appartient à l''Equipe ' + Equipe + '.' + Chr(10) + 'Voulez-vous gérer l''equipe ?'), rep) = mrno then
     begin
     Ferme(QQ);
     exit;
     end;

  Result := true;

  //Création de la Tob equipe uniquement si Equipe existe et
  //si réponse oui à la question
  TobEquipe := Tob.Create('Equipe', nil, -1);
  TobEquipe.LoadDetailDB('LEQUIPE', '', '', QQ, False);

  Ferme(QQ);

  //Vérification si les info de la tob n'existe pas déjà dans le grille
  for i := 0 to TobEquipe.detail.count - 1 do
     begin
     if ControleDansLaGrille(TobEquipe.Detail[I]) then
        begin
        CodeRes := TobEquipe.Detail[i].getvalue('ARS_RESSOURCE');
        ChargeElementGrille(TobEquipe.Detail[I]);
        end;
     end;

  TobEquipe.free;

end;

//Fonction de controle des doublons dans la grille des affectations
function TMonPlanning.ControleDansLaGrille(Item: TOB): boolean;
var
  I: Integer;
  NomChamp: string;
  ChampTob: string;
  ChampPlanning: string;
  Critere: string;
  TobLigne: Tob;
begin

  Result := True;

  if TobGrille = nil then exit;

  if not Assigned(TobGrille) then exit;

  //Récupération valeur des Noms de zone Pour Controle Doublon
  Critere := ColNames;
  NomChamp := (Trim(ReadTokenSt(Critere)));

  while (NomChamp <> '') do
  begin
    if ChampPlanning = '' then
      ChampPlanning := Item.GetString(NomChamp)
    else
      ChampPlanning := ChampPlanning + ';' + Item.GetString(NomChamp);
    NomChamp := (Trim(ReadTokenSt(Critere)));
  end;

  //Récupération valeur des noms de la TOB pour controle doublons
  Critere := ColNames;
  NomChamp := (Trim(ReadTokenSt(Critere)));

  if TobGrille.Detail.Count <> 0 then
  begin
    for I := 0 to TobGrille.Detail.Count - 1 do
    begin
      TOBligne := TOBGrille.detail[I];
      while (NomChamp <> '') do
      begin
        if ChampTob = '' then
          ChampTob := TobLigne.getvalue(NomChamp)
        else
          ChampTob := ChampTob + ';' + TobLigne.GetValue(NomChamp);
        NomChamp := (Trim(ReadTokenSt(Critere)));
      end;
      if ChampPlanning = ChampTob then
      begin
        result := false;
        break;
      end
      else
      begin
        ChampTob := '';
        Critere := ColNames;
        NomChamp := (Trim(ReadTokenSt(Critere)));
      end;
    end;
  end;

end;

//Fonction de controle des date d'affectation et des dates d'appel
function TMonPlanning.ControleDateAppel: boolean;
var DeltaDate : TDateTime;
    DeltaHeure: TDateTime;
  	QQ		    : TQuery;
  	HeureDeb  : TdateTime;
  	HeureFin  : TdateTime;
    HeureCal  : TdateTime;
    DureeInt  : Double;
  	StSQL	    : string;
  	Rep		    : String;
    NoJour    : string;
  	I			    : Integer;
    DateOk : Boolean;
begin
  DateOk := true;
  if not control_BtEtat('12') then exit;

  if CodeRes = '' then exit;

  //if UsDateTime(DateAppel) > UsDateTime(DatePlanDeb) then Exit;
  if DateAppel > DatePlanDeb then Exit;

  Result := True;

  //Si l'appel provient d'une tache on charge la durée d'intervention et
  //on la traduit en heure si l'unité de temps est jour.
  if CreerPar <> 'TAC' then
  begin
     DureeInt  := TobEtat.GetValue('BTA_DUREEMINI') * 60;
     DatePlanFin := AjouteDuree (DatePlanDeb,Round(DureeInt));
  end else
  Begin
     DureeInt  := TobTaches.GetValue('ATA_QTEINTERVENT');
     if TobTaches.GetValue('ATA_UNITETEMPS') = 'J' then
     begin
     	DureeInt := Dureeint * DureeJour;
     end else
     begin
     	DureeInt := Dureeint * 60
     end;
     DatePlanFin := AjouteDuree (DatePlanDeb,Round(DureeInt));
     Nbheure := CalculDureeEvenement (DatePlanDeb,DatePlanFin);
  end;


  if NbHeure = 0 then NbHeure   := DureeInt;

  NoJour    := IntToStr(DayOfWeek(DatePlanDeb)-1);

  HeureDeb 	:= StrToTime(TimeToStr(DatePlanDeb));
  HeureFin 	:= StrToTime(TimeToStr(DatePlanFin));

  //Vérification si Calendrier Particulier à la Ressource
  if assigned(TobCalendrier) then
  Begin
  	if heureDeb < FloatToTime (TobCalendrier.Detail[0].GetValue('ACA_HEUREDEB1')) then
  		HeureDeb := FloatToTime (TobCalendrier.Detail[0].GetValue('ACA_HEUREDEB1'));
    if HeureFin > FloatToTime (TobCalendrier.Detail[0].GetValue('ACA_HEUREFIN1')) then
    	HeureFin := FloatToTime (TobCalendrier.Detail[0].GetValue('ACA_HEUREFIN1'));
    DatePlanDeb := StrTODate(DateToStr(DatePlanDeb))+HeureDeb;
    DatePlanFin := StrTODate(DateToStr(DatePlanFin))+HeureFin;
    Nbheure := CalculDureeEvenement (DatePlanDeb,DatePlanFin);
  end;
(*
  if DureeInt <> 0 then
     DeltaDate := DeltaDate + (DureeInt*60) / 1440
  else
     Begin
     if Cadencement = '001' then //gestion heure deb + 15 minutes
        DeltaDate := DeltaDate + (DureeInt*60) / 1440
     else if Cadencement = '002' then //Gestion Heure deb + 30 Minutes
        DeltaDate := DeltaDate + (DureeInt*60) / 1440
     else if cadencement = '003' then //Gestion Heure Deb + 1 heure
        DeltaDate := DeltaDate + DureeInt / 24
     Else if (Cadencement = '004') or (Cadencement = '005') then //Gestion à la journée ou la 1/2 journée
        begin
        //Manque gestion AM/PM ???
        HeureCal := Heurefin;
        DeltaDate := FloatToTime(HeureFin, true);
        end;
     end;

  HeureFin := TimeToFloat(DeltaDate);
*)
  HDeb1.Text := TimeToStr(HeureDeb);
  HFin1.Text := TimeToStr(HeureFin);

  if DateAppel = 0 then exit;

 //Controle si la date et l'heure correspondent à celle déjà saisie
 //en affectation
 For i:=0 to TobEvenement.Detail.count - 1 do
     Begin
     //Gestion des dates
     DeltaDate := TobEvenement.Detail[I].GetValue('BEP_DATEDEB');
     if UsDateTime(DatePlanDeb) <> UsDateTime(DeltaDate) then
        Begin
        	DateOk := false;
           DatePlanDeb := TobEvenement.Detail[I].GetValue('BEP_DATEDEB');
        end;
     DeltaDate := TobEvenement.Detail[I].GetValue('BEP_DATEFIN');
     if UsDateTime(DatePlanFin) <> UsDateTime(DeltaDate) then
        Begin
        	DateOk := false;
           DatePlanFin := TobEvenement.Detail[I].GetValue('BEP_DATEFIN');
        end;
     //Gestion des heures
     DeltaHeure := TobEvenement.Detail[I].GetValue('BEP_HEUREDEB');
     if UsDateTime(DeltaHeure) <> UsDateTime(HeureDeb) then
        Begin
        	DateOk := false;
           HeureDeb := TobEvenement.Detail[I].GetValue('BEP_HEUREDEB');
        end;
     DeltaHeure := TobEvenement.Detail[I].GetValue('BEP_HEUREFIN');
     if UsDateTime(DeltaHeure) <> UsDateTime(HeureFin) then
        Begin
        	DateOk := false;
           HeureFin := TobEvenement.Detail[I].GetValue('BEP_HEUREFIN');
        end;
     end;
  DatePlanDeb := StrToDate(DateToStr(DatePlanDeb))+HeureDeb;
  DatePlanFin := StrToDate(DateToStr(DatePlanFin))+HeureFin;
  Nbheure := CalculDureeEvenement (DatePlanDeb,DatePlanFin);
  HDeb1.Text := TimeToStr(HeureDeb);
  HFin1.Text := TimeToStr(HeureFin);

  //Label10.Caption := DateToStr(DatePlanDeb);

end;

//Dessin de la grille et création de la TOB de remplissage
procedure TMonPlanning.DrawGrille(NbColFixe: Integer);
var I					 : Integer;
    Ind				 : Integer;
    TGril			 : Integer;
    Champ			 : String;
    NomChamp	 : String;
begin

  //Création de la Tob Mère de remplissage de la Grille
  TobGrille := Tob.create('GRILLE AFFECTATION', nil, -1);

  //Création de la Tob des Evènements
  TobEvenement := Tob.create('La BTEVENPLAN', nil, -1);

  //Création de la Tob Mère de Suppression de Lignes
  TobSuppression := Tob.create('la SUPPRESSION', nil, -1);

  ColNames := '';

  //Initialisation de la Grille
  GrilleSelection.RowCount := 2;
  GrilleSelection.ColCount := NbColFixe;

  For i := 0 To GrilleSelection.RowCount -1 do
      Begin
      For Ind := 0 TO GrilleSelection.ColCount - 1 do
          Begin
          GrilleSelection.Cells[Ind, I] := '';
          end;
      end;

  GrilleSelection.FixedRows := 1;
  GrilleSelection.FixedCols := 0;
  TTWappels.Width := 305;

  TGril := TTWappels.Width;

  //Chargement de l'entete en fonction des paramètres planning
  for I := 4 to NbColFixe + 3 do
  begin
    Ind := I - 4;
    Champ := TobModelePlanning.Detail[PlanningCurrent.tag].GetValue('HPP_LIBCOLENT' + IntToStr(I));
    if Champ <> '' then
    begin
      NomChamp := LectLibCol('CC', 'BLI', Champ, 'CC_LIBRE');
      GrilleSelection.Cells[Ind, 0] := RechDom('BTLIBCOLPLANNING', Champ, True);
      GrilleSelection.ColWidths[Ind] := TGril div NbColFixe;
    end
    else
    begin
      NomChamp := 'ARS_LIBELLE';
      GrilleSelection.Cells[0, 0] := 'Ressource';
      GrilleSelection.ColWidths[0] := TGril div NbColFixe;
      break;
    end;
    if ColNames = '' then
      ColNames := Nomchamp
    else
      ColNames := ColNames + ';' + Nomchamp;
  end;

end;

procedure TMonPlanning.ChargeTableEvtGrille();
var StSql				: string;
    Nomchamp		: string;
    ValeurChamp : String;
    NumAppel    : string;
    I						: Integer;
    TobLigne		: Tob;
    TobEvnt			: Tob;
    QQ					: TQuery;
    Critere			: string;
begin

  NumAppel := CodeDossierRech.text;

  //Lecture des évènements pour recherche éventuelles affectations
  Nomchamp := FindEtReplace(ColNames, ';', ',', true);

  if NomChamp = '' then NomChamp := 'ARS_LIBELLE';

  StSql := 'SELECT BEP_CODEEVENT, ' + Nomchamp + ' FROM BTEVENPLAN ';
  StSql := StSql + 'LEFT JOIN RESSOURCE ON BEP_RESSOURCE = ARS_RESSOURCE ';
  StSql := StSql + 'WHERE BEP_AFFAIRE="' + NumAppel + '" ORDER BY BEP_CODEEVENT'; //

  TobEvnt := Tob.Create('Mode Evenement', nil, -1);
  QQ := OpenSQL(StSQL, true,-1,'',true);
  TobEvnt.LoadDetailDB('LIGEVENT', '', '', QQ, False);
  Ferme(QQ);

  if TobEvnt.detail.count <> 0 then
     OKModif := true
  else
     OKModif := False;

  //Récupération valeur des Noms de zone
  Critere := ColNames;
  NomChamp := (Trim(ReadTokenSt(Critere)));

  for i := 0 to TobEvnt.detail.Count - 1 do
  begin
    TobLigne := Tob.create('LA LIGNE', TobGrille, -1);
    while (NomChamp <> '') do
    begin
      ValeurChamp := RechDom(TabletteAssociee(NomChamp),TobEvnt.Detail[I].getvalue(nomchamp), False);
      If ValeurChamp = '' then ValeurChamp := TobEvnt.Detail[I].getvalue(nomchamp);
      TobLigne.AddChampSupValeur(NomChamp, ValeurChamp);
      NomChamp := Trim(ReadTokenSt(Critere));
    end;
    Critere := ColNames;
    NomChamp := (Trim(ReadTokenSt(Critere)));
  end;

  //Chargement de la table des Evènements
  StSQL := 'SELECT * FROM BTEVENPLAN WHERE BEP_AFFAIRE = "' + CodeDossierRech.text + '"';
  QQ := OpenSQL(StSQL, true,-1,'',true);
  TobEvenement.LoadDetailDB('BTEVENPLAN', '', '', QQ, False);
  Ferme(QQ);
  for i := 0 to TobEvenement.detail.count -1 do
  begin
  	TobEvenement.detail[i].AddChampSupValeur('NEW_ONE','-');
  end;
  if Assigned(TobEvnt) then TobEvnt.free;

  TobGrille.PutGridDetail(GrilleSelection, False, False, ColNames);

  if TobEvenement.Detail.Count <> 0 then
    begin
    for i := 0 to TobEvenement.Detail.Count - 1 do
      begin
      if TobEvenement.Detail[I].GetValue('BEP_RESPRINCIPALE') <> 'X' then
         Begin
         GrilleSelection.RowHeights[I + 1] := 18;
         Nbheure  := TobEvenement.Detail[I].GetValue('BEP_DUREE');
         HeureDeb := TobEvenement.Detail[I].GetValue('BEP_HEUREDEB');
         HeureFin := TobEvenement.Detail[I].GetValue('BEP_HEUREFIN');
         DatePlanDeb := TobEvenement.Detail[I].GetValue('BEP_DATEDEB');;
         DatePlanFin := TobEvenement.Detail[I].GetValue('BEP_DATEFIN');;
         end;
      end;
    end;

end;

procedure TMonPlanning.ChargeElementGrille(Item: TOB);
var Critere	: string;
    NomChamp: string;
    TobLigne: Tob;
    NumEvent: Integer;
begin

  TobLigne := Tob.create('LA LIGNE', TobGrille, -1);

  //Récupération valeur des Noms de zone
  Critere := ColNames;
  NomChamp := (Trim(ReadTokenSt(Critere)));

  while (NomChamp <> '') do
  begin
    TobLigne.AddChampSupValeur(NomChamp, Item.GetString(NomChamp));
    NomChamp := Trim(ReadTokenSt(Critere));
  end;

  TobGrille.PutGridDetail(GrilleSelection, False, False, ColNames);

  GrilleSelection.RowHeights[GrilleSelection.Row] := 18;

  //Chargement de la Tob des Evènements avec la tob de l'Appel
  if not GetNumCompteur('BEP', NumEvent) then
  begin
    AfficheErreur('BTPLANNING', '1', 'Affectation d''Appel');
    exit;
  end
  else
    MajEventPlanning(NumEvent, Item);

end;

//Procedure de mise à jour de la table des evenements
procedure TMonPlanning.MajEventPlanning(Numero: Integer; Item: Tob);
var TobLigEvt: Tob;
begin

  //If not Control_BtEtat('12') then exit;

  TobLigEvt := Tob.create('BTEVENPLAN', TobEvenement, -1);

  TobLigEvt.PutValue('BEP_CODEEVENT', IntToStr(Numero));
  TobLigEvt.PutValue('BEP_RESSOURCE', CodeRes);
  TobLigEvt.PutValue('BEP_BTETAT', TypeAction);
  TobLigEvt.PutValue('BEP_AFFAIRE', TobIntervention.GetValue('AFF_AFFAIRE'));
  TobLigEvt.PutValue('BEP_TIERS', TobIntervention.GetValue('AFF_TIERS'));
  TobLigEvt.PutValue('BEP_NUMEROADRESSE', TobIntervention.GetValue('AFF_NUMEROCONTACT'));
  TobLigEvt.PutValue('BEP_EQUIPERESS', Equipe);
  TobLigEvt.PutValue('BEP_MODIFIABLE', 'X'); // XP 07.06.2006

  if TobEvenement.Detail.Count = 1 then
    begin
    TobLigEvt.PutValue('BEP_RESPRINCIPALE', 'X');
    Responsable := CodeRes;
    end
  else
    TobLigEvt.PutValue('BEP_RESPRINCIPALE', '-');

  // TempoDate := DateToStr(DatePlanning);
  TobLigEvt.PutValue('BEP_EQUIPESEP', '-');
  TobLigEvt.PutValue('BEP_OBLIGATOIRE', 'X');
  TobLigEvt.PutValue('BEP_DUREE', NbHeure);
  TobLigEvt.PutValue('BEP_DATEDEB', Trunc(DatePlanDeb) + StrToTime(HDeb1.Text)); // XP 07.06.2006
  TobLigEvt.PutValue('BEP_HEUREDEB', StrToTime(HDeb1.Text));
  TobLigEvt.PutValue('BEP_DATEFIN', Trunc(DatePlanFin) + StrToTime(HFin1.Text)); // XP 07.06.2006
  TobLigEvt.PutValue('BEP_HEUREFIN', StrToTime(HFin1.Text));
  TobLigEvt.PutValue('BEP_PERIODEDEBUT', '');
  TobLigEvt.PutValue('BEP_PERIODEFIN', '');
  TobLigEvt.PutValue('BEP_GEREPLAN', TobEtat.GetValue('BTA_ASSOSRES'));
  TobLigEvt.PutValue('BEP_HEURETRAV', 'X');
  TobLigEvt.PutValue('BEP_CREAPLANNING', 'X');
  TobLigEvt.PutValue('BEP_BLOCNOTE', '');
  TobLigEvt.AddChampSupValeur ('NEW_ONE', 'X');

end;

procedure TMonPlanning.BValidAffClick(Sender: TObject);
var
  I: Integer;
  StSql,StNEw: string;
begin

	TTWappels.Visible := False;
  Fenhoraire.Visible := False;
  FenDescriptif.Visible := False;

  //Gestion de la Tob suppression pour mise à jour
  if TobSuppression <> nil then
     begin
         if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
         begin
           StSQL := '';
           for I := 0 to TobSuppression.Detail.count - 1 do
           begin
            if StSql = '' then
            begin
              StSQL := 'WHERE BEP_CODEEVENT IN ('+ TobSuppression.Detail[I].Getvalue('BEP_CODEEVENT');
            end else
            begin
              StSql := StSql + ','+TobSuppression.Detail[I].Getvalue('BEP_CODEEVENT');
            end;
           end;
           StSql := StSql + ')';
           //
           if TobSuppression.detail.count > 0 then
           begin
      	 	 	EnvoieEmailFromIntervention (TobSuppression.Detail[0],StSql,'S',IDate1900,0);
           end;
         end;
         //
     for I := 0 to TobSuppression.Detail.count - 1 do
         begin
         StSQL := TobSuppression.Detail[I].Getvalue('BEP_CODEEVENT');
         SuppressionItemPlanning('WHERE BEP_CODEEVENT ="' + StSQL + '"');
         end;
     end;

  StNew := '';
  if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
  begin
    for i:=0 to TOBevenement.detail.count -1 do
    begin
    	if TobEvenement.detail[i].getValue('NEW_ONE')='X' then
      begin
        if StNew = '' then
        begin
          StNew := 'WHERE BEP_CODEEVENT IN ('+ TOBevenement.Detail[I].Getvalue('BEP_CODEEVENT');
        end else
        begin
          Stnew := Stnew + ','+TOBevenement.Detail[I].Getvalue('BEP_CODEEVENT');
        end;
      end;
    end;
    if StNew <> '' then Stnew := StNew + ')';
    //
    for i:=0 to TOBevenement.detail.count -1 do
    begin
    	TobEvenement.detail[i].PutValue('NEW_ONE','-');
    end;
  end;
  //Mise à jour de la table à partir de la TOB
  TobEvenement.InsertOrUpdateDB(true);
  if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
  begin
    if StNew <> '' then
    begin
    EnvoieEmailFromIntervention (TOBevenement.Detail[0],StNew,'C',IDate1900,0);
    end;
  end;

  //Mise à jour de la fiche appels
  if Responsable = '' then
     begin
     TobIntervention.PutValue('AFF_RESPONSABLE', '');
     TobIntervention.PutValue('AFF_ETATAFFAIRE', 'ECO');
     TobIntervention.PutValue('AFF_DATEREPONSE', idate2099);
     end
  else
     begin
     TobIntervention.PutValue('AFF_DATEREPONSE', Trunc(DatePlanDeb) + StrToTime(HDeb1.Text));
     TobIntervention.PutValue('AFF_RESPONSABLE', Responsable);
     TobIntervention.PutValue('AFF_ETATAFFAIRE', 'AFF');
     end;

  TobIntervention.SetAllModifie(True);
  TobIntervention.UpdateDB;

  for i := 0 to TobEvenement.detail.count -1 do
      Begin
      TobItem := TobEvenement.detail[i];
      ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], TobItem, 0);
      end;

  if TOBitem <> nil then FreeAndNil(TOBitem);

  if not FicAppel then
     Begin
     label11.caption := '';
     label11.Visible := false;
     end;

  if tobcalendrier <> nil then FreeAndNil(TobCalendrier);

  if OkAppelLibre then
     Begin
     FicAppel := false;
     OkAppelLibre := false;
     CodeDossierRech.text := '';
     TTWappels.Visible := True;
     DrawGAppel('BTCONTENUGAPP');
	   TTWappels.Visible := BAffAppel.visible;
	  end
  else if OkVisuAffect then
     Begin
     FicAppel := false;
     OkVisuAffect := false;
     CodeDossierRech.text := '';
     exit;
     end;

  if FicAppel then
     ChargeIntervention
  else
	   ChargeAppel;

  VoirToutBoutons(True);

end;

procedure TMonPlanning.BAnnulAffClick(Sender: TObject);
begin

  //fermeture de la fiche affectation
  TTWappels.Visible := False;
  BAffAppel.down := TTWappels.Visible;

  FenDescriptif.Visible := False;
  BDescriptif.down := FenDescriptif.Visible;

  if not FicAppel then
     Begin
     label11.caption := '';
     label11.Visible := false;
     end;

  FreeAndNil(TobCalendrier);

  //Gestion de l'affectation d'un appel à partir du planning
  if OkAppelLibre then
     Begin
     FicAppel := false;
     OkAppelLibre := false;
     CodeDossierRech.text := '';
     GrilleSelection.ClearSelected;
     DrawGAppel('BTCONTENUGAPP');
     TTWappels.Visible := BAffAppel.visible;
     end
  else if OkVisuAffect then
     Begin
     FicAppel := false;
     OkVisuAffect := false;
     CodeDossierRech.text := '';
     GrilleSelection.ClearSelected;
     exit;
     end;

  //Gestion de l'affectation à partir d'un appel
  if FicAppel then
     Begin
	   //Rechargement du planning
  	 ChargeIntervention;
     BChercherClick(Sender);
     end;

  VoirToutBoutons(True);

end;

procedure TMonPlanning.GrilleSelectionDblClick(Sender: TObject);
begin     

  if ficappel then
     Begin
     if TobEvenement.Detail.count = 0 then exit;
	   OkAffect := True;
     bValWindows.Tag := 0;
     HTypeAction.text := TobEvenement.Detail[GrilleSelection.Row - 1].GetValue('BEP_BTETAT');
     SetInfosAction;
     HTypeAction.Enabled := false;
     NbHeure := 0;
     DatePlanDeb := TobEvenement.Detail[GrilleSelection.Row - 1].GetValue('BEP_DATEDEB');
     DatePlanFin := TobEvenement.Detail[GrilleSelection.Row - 1].GetValue('BEP_DATEFIN');
     //chargement de la fiche horaire avec la table évènement
     ChargementFicheHoraire(nil);
     FenHoraire.Visible := True
     end
  else
     Begin
     OkAppelLibre := True;
     FicAppel			:= True;
	   CodeDossierRech.text := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_AFFAIRE');
     Descriptif.Text 	    := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_DESCRIPTIF');

//		 CodeDossierRech.text := GrilleSelection.cells[2,GrilleSelection.Row];
     ChargeInfoAppel;
     end;

	if FenDescriptif.visible then  FenDescriptif.SetFocus;

end;

procedure TMonPlanning.bAnnulWindowsClick(Sender: TObject);
begin
  //Rechargement du planning
  FenDescriptif.visible := false;
  HTypeAction.Enabled := True;

  OkAffect := False;

  FenHoraire.Visible := False;

  ThPlanningBTP(Sender).Enabled := True;

  VoirToutBoutons(True);
//  BRechargerClick (self);
  // Recharge les onglets du planning
  DateEdit.Text := DateToStr( PlanningCurrent.GetDateOfCol(PlanningCurrent.Col));
  if Typeplanning = 'PLA' then
     RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
     //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
     RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);

  Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;

end;

procedure TMonPlanning.Hdeb1Exit(Sender: TObject);
var DateDeb,DateFin : double;
begin

	NbHeure := 0;

  DateDeb := DateToFloat (StrToDate(HDateDeb.Text));
  DateFin := DateToFloat (StrToDate(HDateFin.Text));
  HeureDeb := TimeToFloat(StrToTime (HDeb1.Text));
  HeureFin := TimeToFloat(StrToTime(HFin1.Text));
  Nbheure := CalculDureeEvenement (DateDeb,HeureDeb,DateFin,HeureFin);
  HDuree.Caption := LibelleDuree (NbHeure);

  Hdeb1.Text := FormatDateTime('hh:mm:ss', FloatToTime(HeureDeb));

end;

procedure TMonPlanning.Hfin1Exit(Sender: TObject);
var DateDeb,DateFin : Double;
begin

	NbHeure := 0;
  DateDeb := DateToFloat (StrToDate(HDateDeb.Text));
  DateFin := DateToFloat (StrToDate(HDateFin.Text));

  HeureDeb := TimeToFloat(StrToTime(HDeb1.Text));
  HeureFin := TimeToFloat(StrToTime(HFin1.Text));

  Nbheure := CalculDureeEvenement (DateDeb,HeureDeb,DateFin,HeureFin);
  HDuree.Caption := LibelleDuree (NbHeure);

  HFin1.Text := FormatDateTime('hh:mm:ss', FloatToTime(HeureFin));

end;

procedure TMonPlanning.bValWindowsClick(Sender: TObject);
var DebutDemande,FinDemande,DebutCalc,FinCalc : TdateTime;

begin

  OkValAction := true;
  FenDescriptif.Visible := false;

  if HTypeAction.Text = '' then
     begin
     AfficheErreur('BTPLANNING', '5', 'Création/Modification Evènement');
     exit;
     end;

  NbHeure := 0;

  DatePlanDeb := Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text);
  DatePlanFin := Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text);
  //
  DebutDemande := ConstitueDatePlanning (DatePlanDeb,TTdDebut);
  FinDemande := ConstitueDatePlanning(DatePlanFin,TtdFin);
  //
  //DatePlanFin := GestionDateFinPourEnreg (DatePlanFin); // Decalage pour la gestion de l'affichage

  ChargementFicheHoraire (nil);

  // controle sur delai
  if NbHeure = 0 then
  begin
    PgiError ('Impossible : La ressource sélectionnée ne peut effectuer le travail aux heures indiquées');
    exit;
  end else if  (DebutDemande <> DatePlanDeb) or (FinDemande <> DatePlanFin) then
  begin
    Pgiinfo ('Les heures de début et de fin de travaux ont été réajustés#13#10'+
           ' aux horaires de présences de la ressource');
  end;
  //HDuree.Caption := CalculDureeEvenement;

  if OkAffect then
     Begin
     //chargement TOb Evénement pour mise à jour durée
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_BTETAT',HTypeAction.Text);
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_DATEDEB',Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text));
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_DATEFIN',Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text));
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_HEUREDEB',StrToTime(HDeb1.Text));
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_HEUREFIN',StrToTime(HFin1.Text));
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_DUREE',NbHeure);
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_MODIFIABLE','X');
     TobEvenement.Detail[GrilleSelection.Row - 1].PutValue('BEP_BLOCNOTE',DesAction.text);
     end
  else
     Begin
     If bValWindows.Tag = 1 then
        CreationAction
     Else If bValWindows.Tag = 2 then ModificationAction;
     end;

	if Not OkValAction then exit;

  //Rechargement du planning
  HTypeAction.Enabled := True;

  OkAffect := False;

  FenHoraire.Visible := False;

  ThPlanningBTP(Sender).Enabled := True;

  VoirToutBoutons(True);

end;

Procedure TMonPlanning.CreationAction ;
Var TobLigEvt : Tob;
    NumEvent	: Integer;
    QEtat			: TQuery;
begin

//	TobItem := Item;

  if not ControleAffectation(nil) then exit;

  //Création de l'évènement dans le cas de la création sans appel
	if not GetNumCompteur('BEP', NumEvent) then
     begin
     AfficheErreur('BTPLANNING', '1', 'Affectation d''Appel');
     exit;
     end;

  //chargement du type d'action dans la tob pour MAJ
  QEtat   := OpenSQL('SELECT * FROM BTETAT WHERE BTA_BTETAT="' + HTypeAction.Text + '"', True,-1,'',true);

  if Qetat.eof then
     Begin
     Ferme (QEtat);
  	 AfficheErreur('BTPLANNING', '10', 'Creation Action');
     Exit;
     end;

  TobEtat.SelectDb('', QEtat);
  Ferme(QEtat);

  TobLigEvt := Tob.create('BTEVENPLAN', nil, -1);

  TobLigEvt.PutValue('BEP_CODEEVENT', IntToStr(NumEvent));
  TobLigEvt.PutValue('BEP_RESSOURCE', CodeRes);
  TobLigEvt.PutValue('BEP_BTETAT', HTypeAction.Text);
  TobLigEvt.PutValue('BEP_AFFAIRE', '');
  TobLigEvt.PutValue('BEP_TIERS', '');
  TobLigEvt.PutValue('BEP_NUMEROADRESSE', '0');
  TobLigEvt.PutValue('BEP_EQUIPERESS', Equipe);
  TobLigEvt.PutValue('BEP_MODIFIABLE', 'X');
  TobLigEvt.PutValue('BEP_OBLIGATOIRE', 'X');
  TobLigEvt.PutValue('BEP_RESPRINCIPALE', '-');
  TobLigEvt.PutValue('BEP_EQUIPESEP', '-');
  TobLigEvt.PutValue('BEP_DUREE', NbHeure);
  TobLigEvt.PutValue('BEP_DATEDEB', Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text)); // XP 07.06.2006
  TobLigEvt.PutValue('BEP_HEUREDEB', StrToTime(HDeb1.Text));
  TobLigEvt.PutValue('BEP_DATEFIN', Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text)); // XP 07.06.2006
  TobLigEvt.PutValue('BEP_HEUREFIN', StrToTime(HFin1.Text));
  TobLigEvt.PutValue('BEP_PERIODEDEBUT', '');
  TobLigEvt.PutValue('BEP_PERIODEFIN', '');
  TobLigEvt.PutValue('BEP_GEREPLAN', 'X');
  TobLigEvt.PutValue('BEP_HEURETRAV', 'X');
  TobLigEvt.PutValue('BEP_CREAPLANNING', 'X');
  TobLigEvt.PutValue('BEP_BLOCNOTE', DesAction.text);

  if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
  begin
    EnvoieEltEmailFromAction (TobLigEvt,'C',Idate1900,0);
  end;
  //Mise à jour de l'évènement
  TobLigEvt.InsertOrUpdateDB(True);

  TobLigEvt.Free;

  //chargement des info pour affichage de l'item
  if tobItem <> nil then TobItem.SetString('BEP_CODEEVENT',  IntToStr(NumEvent));
  ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], TobItem, 0);
	//
  //
end;

Procedure TMonPlanning.ModificationAction;
Var StSql		: String;
    NumEvent   : String;
    DDebut		: TdateTime;
    Dfin			: TDatetime;
    TobLigEvt  : Tob;
    QEvent     : TQuery;
    Oldress : string;
    OldDate : TdateTime;
    OldDelai : integer;
begin

    OkValAction := ControleAffectation(nil);
    if not OkValAction then exit;

    NumEvent := Label10.caption;

    DDebut := Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text);
	  DFin   := Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text);

    //chargement de la tob evenement pour MAJ
    QEvent := OpenSQL('SELECT * FROM BTEVENPLAN WHERE BEP_CODEEVENT="' + NumEvent + '"', true,-1,'',true);
    TobLigEvt := TOB.Create('BTEVENPLAN', Nil, -1) ;
    TobLigEvt.SelectDB('',QEvent);
    Ferme(QEvent);
    //
    OldRess := TobLigEvt.getValue('BEP_RESSOURCE');
    OldDate := StrToDate(DateTostr(TobLigEvt.getValue('BEP_DATEDEB')))+StrToTime(TimeToStr(TobLigEvt.getValue('BEP_DATEDEB')));
    OldDelai := TobLigEvt.getValue('BEP_DUREE');
    //
    TobLigEvt.PutValue('BEP_RESSOURCE', CodeRes);
    TobLigEvt.PutValue('BEP_BTETAT', HTypeAction.Text);
    TobLigEvt.PutValue('BEP_DATEDEB', DDebut);
    TobLigEvt.PutValue('BEP_DATEFIN', DFin);
    TobLigEvt.PutValue('BEP_HEUREDEB', StrToTime(HDeb1.Text));
    TobLigEvt.PutValue('BEP_HEUREFIN', StrToTime(HFin1.Text));
    TobLigEvt.PutValue('BEP_DUREE', NbHeure);
    TobLigEvt.PutValue('BEP_BLOCNOTE', DesAction.text);

    //Mise à jour de l'évènement
    TobLigEvt.UpdateDB;
    ExecuteSql ('UPDATE AFFAIRE SET AFF_RESPONSABLE="'+TobLigEvt.GetValue('BEP_RESSOURCE')+'", '+
    						'AFF_DATEREPONSE="'+UsDateTime(DDebut)+'" '+
    						'WHERE AFF_AFFAIRE="'+TobLigEvt.GetValue('BEP_AFFAIRE')+'"');
    if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
    begin
      EnvoieEltEmailFromAction (TobLigEvt,'M',OldDate ,OldDelai,True,OlDRess);
    end;
    TobLigEvt.free;

    ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], TobItem, 0);

end;

procedure TMonPlanning.GrilleSelectionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin

  //Gestion de la suppression de l'afectation
  if Key = VK_DELETE then
  begin
  	SupprimeAffectation;
  end;

  //if key = VK_SPACE then
  //   Begin
  //   end;

end;

procedure TMonPlanning.SupprimeAffectation;
var TobSupLig	: Tob;
  	NumEquipe	: String;
    I					: Integer;
begin

  if TobEvenement.detail.Count = 0 then exit;

  NumEquipe := TOBEvenement.detail[GrilleSelection.Row - 1].GetString('BEP_EQUIPERESS');

  //vérification si la ressource appartient à une équipe
  if NumEquipe <> '' then
     Begin
     SuppressionEquipe(NumEquipe);
     exit;
     end;

  //Modification du responsable
  if TobEvenement.Detail[GrilleSelection.Row - 1].GetValue('BEP_RESPRINCIPALE') = 'X' then
     begin
     Responsable := '';
     if TobEvenement.detail.Count > 1 then
        TobEvenement.Detail[1].PutValue('BEP_RESPRINCIPALE', 'X');
     end;

  //Chargement dans TOB Tempo Suppression
  TobSupLig := Tob.Create('BTEVENPLAN', TobSuppression, -1);
  TobSupLig.Dupliquer(TOBEvenement.detail[GrilleSelection.Row - 1], False, True);

  //Suppression de la ligne dans la Tob Evènement
  TobEvenement.Detail[GrilleSelection.Row - 1].Free;

  //Rechargement de la grille avec la tob Evènement
  TobGrille.Detail[GrilleSelection.row - 1].free;

  For i := 1 to GrilleSelection.rowcount -1 do GrilleSelection.DeleteRow(I);

  //Rechargement de la grille avec la tob Evènement
  TobGrille.PutGridDetail(GrilleSelection, False, False, ColNames);

end;

Procedure TmonPlanning.SuppressionEquipe(Equipe : String);
Var I	      : Integer;
    Ressource : String;
    Rep	      : String;
    TobSupLig : Tob;
    TOBl : TOB;
Begin

    //Controle si plusieurs ressources de la même équipe affectées
    if TobEvenement.Detail.count = 0 then exit;
    TOBL := TobEvenement.FindFirst(['BEP_EQUIPERESS'], [Equipe], true);
    if TOBL = nil then exit;
    Ressource := TobEvenement.FindFirst(['BEP_EQUIPERESS'], [Equipe], true).GetValue('BEP_RESSOURCE');
    if GrilleSelection.Row < 1 then exit;
    if Ressource = TobEvenement.Detail[GrilleSelection.Row - 1].GetValue('BEP_RESSOURCE') then
       Ressource := TobEvenement.FindNext(['BEP_EQUIPERESS'], [Equipe], true).GetValue('BEP_RESSOURCE');

    if Ressource = '' then exit;

    if pgiAsk('Désirez-vous supprimer toute l''équipe', rep)=MrNo then exit;

    I := 0;

    //suppression de l'équipe au complet
    While I < TobEvenement.Detail.count do
          Begin
          if TobEvenement.Detail[I].GetValue('BEP_EQUIPERESS') = Equipe then
             Begin
             //Chargement dans TOB Tempo Suppression
				     TobSupLig := Tob.Create('BTEVENPLAN', TobSuppression, -1);
	    			 TobSupLig.Dupliquer(TOBEvenement.detail[I], False, True);
	    			 //Suppression de la ligne dans la Tob Evènement
	     			 TobEvenement.Detail[I].Free;
             TobGrille.Detail[I].free;
             end
          else
	     		I := I +1;
          End;

  For i := 1 to GrilleSelection.rowcount -1 do GrilleSelection.DeleteRow(I);

  //Rechargement de la grille avec la tob Evènement
  TobGrille.PutGridDetail(GrilleSelection, False, False, ColNames);

end;

procedure TMonPlanning.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  //MenuCadencement.Popup(X, Y);

end;

procedure TMonPlanning.ChangeCadencement(Sender: TObject);
var MyMenu  : TMenuItem;
    MenuLib : string;
    i       : integer;
begin

  for i:=0 to MenuCadencement.Items.Count -1 do
      Begin
      MenuCadencement.items[i].Checked := false;
      end;

  MyMenu := TmenuItem(Sender);
  MyMenu.Checked := true;

  MenuLib := StrDelete(MyMenu.Caption, '&');

  Cadencement := RecTypeCommun('BCA', MenuLib);

  if Cadencement = '' then exit;

  // Recharge les onglets du planning
  TobModelePlanning.Detail[PlanningCurrent.Tag].putvalue('HPP_CADENCEMENT', Cadencement);

  BRechargerClick(Sender);

end;

procedure TMonPlanning.SetInfosAction;
Var STSql : string;
    QQ    : TQuery;
    DeltaDate : TDateTime;
    DateDeb,DateFin : TdateTime;
Begin

    StSql := 'SELECT BTA_LIBELLE, BTA_DUREEMINI FROM BTETAT WHERE BTA_BTETAT ="' + HTypeAction.text + '"';
    QQ := OpenSQL(StSQL, true,-1,'',true);

    if QQ.Eof then
       Begin
       LLibAction.Caption := 'Intervention Inconnu';
       Nbheure := 60;
       end
    Else
       Begin
       LLibAction.Caption := QQ.Findfield('BTA_LIBELLE').AsString;
       Nbheure	:= round(QQ.Findfield('BTA_DUREEMINI').AsFloat*60) ;
       end;

    if BvalWindows.Tag = 1 then
       Begin
       //Intégrer Durée par défaut et recalcul du temps
       DateDeb := StrToDate(HDateDeb.Text)+strToTime(Hdeb1.text);
       DateFin := AjouteDuree (DateDeb,round(Nbheure));
       HdateFin.text := DateToStr(DateFin);
       HFin1.Text := FormatDateTime('hh:mm:ss', DateFin);
       HDuree.Caption := LibelleDuree (NbHeure);
       end;

    Ferme(QQ);

end;

procedure TMonPlanning.HtypeActionExit(Sender: TObject);
begin

    SetInfosAction;

end;

procedure TMonPlanning.BCREAPPELClick(Sender: TObject);
begin

	AglLanceFiche ('BTP','BTAPPELINT','','','ACTION=CREATION;PLANNING');
  if Not BAffAppel.Visible then DrawGAppel('BTCONTENUGAPP');

end;


procedure TMonPlanning.HtypeActionChange(Sender: TObject);
begin
  SetInfosAction;
end;


Procedure TMonPlanning.ChargementModifEvenement(Item : Tob);
var TempDate	 : String;
    //Cadencement : String;
Begin

  VoirToutBoutons(false);

  //Controle du code état pour modification affectation

  TobItem := Item;
  OkAffect := False;

  HTypeAction.text := '';

  NbHeure := 0;
  NbJour	 := '';

  bValWindows.Tag := 2;


  CodeRes := Item.GetValue('BEP_RESSOURCE');

  DesAction.text := Item.GetValue('BEP_BLOCNOTE');

  DatePlanDeb := Item.GetValue('BEP_DATEDEB');

  DatePlanFin := Item.GetValue('BEP_DATEFIN');
  //chargement de la fiche horaire avec la table évènement
  Label10.Caption := Item.GetValue('BEP_CODEEVENT');
  HTypeAction.Text := Item.GetValue('BEP_BTETAT');

  Nbheure := Item.GetValue('BEP_DUREE');

  ChargementFicheHoraire (Item);

  FenHoraire.Visible := True;

end;

procedure TMonPlanning.BChercherClick(Sender: TObject);
var TobResultat	: tob;
  	Ok				 	: Boolean;
  	P					 	: ThPlanningBTP;
  	CodeFamres 	: string;
begin

  P := planningCurrent;

  CodeFamres := codeDossierRech.text;

  if CodeDossierRech.text = '' then
     ok := false
  else
     ok := true;

  //ici on affiche le module de recherche des évènements si pas de n° d'appel

  if Ok then
     begin
     TobResultat := PlanningCurrent.TobItems.FindFirst(['BEP_AFFAIRE'], [CodeFamRes], True);
     if TobResultat <> nil then planningCurrent.GoToItem(Tobresultat);
     end;

end;

Function TMonPlanning.ControleAffectation(Item : Tob) : Boolean;
Begin

  Result := false;

  if bValWindows.Tag = 0 then
     if assigned(Item) then
	      if not ControleDansLaGrille(Item) then
           Begin
     		   if Not okModif then AfficheErreur('BTPLANNING', '2', 'Affectation d''Appel');
     		   exit;
     		   end;

  //Controle de la date d'affectation en fonction de la date d'appel
  if bValWindows.Tag = 0 then
     if not ControleDateAppel then
        Begin
        if Not OkModif then AfficheErreur('BTPLANNING', '3', 'Affectation d''Appel');
        exit;
        end;

	Result := true;

  //Controle si il existe déjà une affectation et si l'on peut surbooker
  {Item := PlanningCurrent.GetCurItem;
  if Assigned(Item) then
     Begin
     Result := ControleSurbooking;
     if not result then exit;
     end;

  Result := ControleDateAffectation;}

End;

//Contrôle du surbooking et des fonctions de modification
Function  TMonplanning.ControleSurbooking : Boolean;
var Item 	: Tob;
    StSQL	: String;
    QQ		: TQuery;
    HD		: TTime;
    HF		: TTime;
    HDItem: TTime;
    HFItem: TTIme;
Begin

  Item := PlanningCurrent.GetCurItem;

	Result := False;

  //Controle sir l'évènement courant est modifiable
	if bValWindows.Tag = 2 then
     Begin
     if Item.GetValue('BEP_MODIFIABLE')= '-' then
        Begin
        AfficheErreur('BTPLANNING', '9', 'Saisie d''Evenement');
        exit;
        End;
     End;

  //Controle si un evènement existe pour le période et s'il est obligatoire ou non... surbooking
  StSQL := 'SELECT * FROM BTEVENPLAN WHERE ';
  StSQL := StSQL + 'BEP_RESSOURCE="' + CodeRes + '" AND ';
  StSQL := StSQL + 'BEP_OBLIGATOIRE ="X" AND ' ;
  StSQL := StSQL + 'BEP_DATEDEB >="' + UsDateTime(item.GetValue('BEP_DATEDEB')) + '" AND ';
  StSQL := StSQL + 'BEP_DATEDEB <"' + UsDateTime(item.GetValue('BEP_DATEDEB') + 1) + '" ';

  QQ := OpenSQL(StSQL, true,-1,'',true);
  if QQ.Eof then
     Begin
     Result := True;
     Ferme(QQ);
     Exit;
     end;

  Item := Tob.Create('CtrlDate', nil, -1);
  item.LoadDetailDB('BTEVENPLAN', '', '', QQ, False);

  Ferme(QQ);

  //HD := StrToTime(HDeb1.Text);
  //HF := StrToTime(HFin1.Text);

  Result := True;

  {for I := 0 to item.Detail.count - 1 do
      Begin
      HDItem := item.Detail[I].GetValue('BEP_HEUREDEB');
      HFItem := item.Detail[I].GetValue('BEP_HEUREFIN');
      if ((HD < HDitem) And (HD > HFItem)) Or
         ((HF > HDItem) And (HF < HFItem)) Or
				 ((HD > HDItem) And (HF > HFItem)) Or
				 ((HD < HDItem) And (HF < HFItem)) Or
				 ((HDItem < HD) And (HDItem > HF)) Then
         Begin
         AfficheErreur('BTPLANNING', '6', 'Gestion du Surbooking');
         Result := false;
         break;
         end;
      end;}

end;

//Pavé de controle et de reformatage des différente dates...
function TMonplanning.ControleDateAffectation : Boolean;
var Rep		: String;
    Hdeb	: TTime;
    HFin	: TTime;
    Ddeb	: TDateTime;
    DFin	: TDateTime;
begin

    result := false;

    Hdeb := iDate1900;
    HFin := iDate1900;

    DDeb := StrToDate(HDateDeb.Text) + StrToTime(HDeb1.Text);
    DFin := StrToDate(HDateFin.Text) + StrToTime(HFin1.Text);

    HDeb := StrToTime(HDeb1.Text);
    HFin := StrToTime(HFin1.Text);

  	if AglJoursFeries(DDeb) then
       if PgiAsk('Confirmez vous le début sur un jour férié ?', rep) = MrNo then
          exit;

    if AglJoursFeries(DFin) then
       if PgiAsk('Confirmez vous la fin sur un jour férié ?', rep) = MrNo then
          exit;

    //Controle si la date de début est un samedi ou un dimanche
    if (DayOfWeek(DDeb) = 1) Or (DayOfWeek(DDeb) = 7) then
       if PgiAsk('Confirmez vous le début sur un week-end ?', rep) = MrNo then
          exit;

    //Controle si la date de fin est un samedi ou un dimanche
    if (DayOfWeek(DFin) = 1) Or (DayOfWeek(DFin) = 7) then
       if PgiAsk('Confirmez vous la fin sur un week-end ?', rep) = MrNo then
          exit;

    //La date de début est > à la date de fin
    if DDeb > DFin then
       Begin
       AfficheErreur('BTPLANNING', '8', 'Saisie d''évènement');
       exit;
       end;

    if DDeb = DFin then
       Begin
       AfficheErreur('BTPLANNING', '7', 'Saisie d''évènement');
       HFin := HFin + 1 / 24;
       HFin1.Text := FormatDateTime('hh:mm:ss', HFin);
       end;

    Nbheure := CalculDureeEvenement (DDeb,HDeb,DFin,Hfin);
    HDuree.Caption := LibelleDuree (NbHeure);

    HDateDeb.text := DateToStr(DDeb);
    HDateFin.text := DateToStr(DFin);

    HDeb1.Text := TimeToStr(HDeb);
    HFin1.Text := TimeToStr(HFin);

    Hdeb1.Text := FormatDateTime('hh:mm:ss', HDeb);
    HFin1.Text := FormatDateTime('hh:mm:ss', HFin);

    result := True;

end;

function TMonPlanning.ConstitueDatePlanning (UneDate : TDateTime; TypeDate : TTypeDateTrait) : TDateTime;
var DateRec : string;
    Heurerec  	  : Double;
    Heure : string;
begin
  DateRec := DateToStr(UneDate);
  if TimeToFloat(UneDate) <> 0 then HeureRec := TimeToFloat(UneDate);

  if Heurerec = 0 then
  begin
  	if TypeDate = TtdDebut then
    begin
  		HeureRec := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREDEBUT'), True);
    end else
    begin
  		HeureRec := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREFIN'), True);
    end;
  end;

  if (Heurerec = 0) and (TypeDate = TTdDebut) then HeureRec := 8;
  if (Heurerec = 0) and (TypeDate = TTdFin) then HeureRec := 18;

  Heure := FormatDateTime('hh:mm', FloatToTime(Heurerec));
  result := Trunc(StrToDate(DateRec)) + StrToTime(Heure);
end;

Procedure TMonPlanning.ChargementFicheHoraire (Item : TOB);
var DateDeb,DateFin : double;
Begin
	// Du fait que dans la tob les date de fin sont décalées pour la gestion de l'affichage
  if Item <> nil then
  begin
  	DatePlanFin := GestionDateFinPourModif (DatePlanFin);
  end;
  //chargement de la fiche horaire avec la table évènement
  HDateDeb.Text := DateToStr(DatePlanDeb);
  HDateFin.Text := DateToStr(DatePlanFin);
  Hdeb1.text := TimeToStr(DatePlanDeb);
  Hfin1.text := TimeToStr(DatePlanFin);

  //
  HeureDeb := TimeToFloat(DatePlanDeb);
  HeureFin := TimeToFloat(DatePlanFin);
  //Chargement de la Tob Calendrier dans le cas d'une gestion au temps reel
  ChargeTobCalendrier;
  //
  if HeureDeb = 0 then HeureDeb := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREDEBUT'), True);
  if HeureFin = 0 then HeureFin := TimeToFloat(TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_HEUREFIN'), True);

  //Faire un paramsoc pour la gestion de l'heure de début et heure de fin
  //dans le cas de la journée (005)
  if HeureDeb = 0 then HeureDeb := 8;
  if HeureFin = 0 then HeureFin := 18;

  DateDeb := DateToFloat (StrToDate(HDateDeb.Text));
  DateFin := DateToFloat (StrToDate(HDateFin.Text));
  Nbheure := CalculDureeEvenement (DateDeb,HeureDeb,DateFin,HeureFin);
  HDuree.Caption := LibelleDuree (NbHeure);

//  Hdeb1.Text := FormatDateTime('hh:mm', FloatToTime(HeureDeb));
//  HFin1.Text := FormatDateTime('hh:mm', FloatToTime(HeureFin));
  // Correction LS
  DatePlanDeb := Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text);
  DatePlanFin := Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text);
  if assigned (Item) then
  begin
  	if (not IsModifiable (Item)) then
    begin
    	bValWindows.visible := false;
      BTAFFMEMO.visible := false;
    end else
    begin
    	bValWindows.visible := true;
      if Item.GetValue('BEP_AFFAIRE') = '' then
      begin
        BTAFFMEMO.visible := true;
      end else
      begin
        BTAFFMEMO.visible := false;
      end;
    end;
  end;
end;

function TMonPlanning.MajEvtAffectation(ModeOption: String; Item : Tob): Boolean;
Var DFin			 	: TDateTime;
	  DDebut,DDateFin,DDF		 	: TDateTime;
    CodeRes2	 	: String;
	  NumEvenement: String;
    NumAppel 	 	: String;
    Rep			 	  : String;
    Equipe      : String;
    StSql,SQLB  : String;
    TobParam    : Tob;
    QQ			 	  : TQuery;
    sender		 	: Tobject;
    Duree : double;
    newDate : TdateTime;
begin

  Result := true;

  CodeRes		:= Item.GetValue('BEP_RESSOURCE');
  CodeRes2		:= PlanningCurrent.GetCurItem.GetValue('BEP_RESSOURCE');
  DDateFin := PlanningCurrent.GetCurItem.GetValue('BEP_DATEFIN');
  DDF := Item.getValue('BEP_DATEFIN');
  DesAction.text := Item.getValue('BEP_BLOCNOTE');
  NbJour			:= '';
	if not IsModifiable (Item) then
  begin
  	result := false;
    exit;
  end;
  //chargement de la fiche horaire avec la table évènement
  Label10.Caption  := Item.GetValue('BEP_CODEEVENT');
  HTypeAction.Text := Item.GetValue('BEP_BTETAT');

  NumEvenement := Item.GetString('BEP_CODEEVENT');
  NumAppel     := Item.GetString('BEP_AFFAIRE');
  Equipe       := Item.GetString('BEP_EQUIPERESS');

  CodeDossierRech.text := NumAppel;

  DatePlanDeb := Item.GetValue('BEP_DATEDEB');

  //control si l'appel n'est pas terminé sinon on fait rien
  if NumAppel <> '' then
     Begin
     StSql := 'SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE = "' + NumAppel + '"';
     QQ := OpenSQL(StSQL, True,-1,'',true);
     if (QQ.FindField('AFF_ETATAFFAIRE').AsString = 'TER') or (QQ.FindField('AFF_ETATAFFAIRE').AsString = 'REA') then
        Begin
        AfficheErreur('BTPLANNING', '14', 'Modification d''affectation');
        Ferme(QQ);
        result := false;
        exit;
        end;
     Ferme(QQ);
     end;

  //Recalcul de la Durée
  if ModeOption <> 'S' then
     Begin
	   Heuredeb := 0;
	   HeureFin := 0;
     end;

  if ModeOption = 'D' then    // deplacement
  Begin
     if cadencement = '005' then // Journée
     Begin
	      DatePlanDeb := Item.GetValue('BEP_DATEDEB');
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        Duree := Item.GetValue('BEP_DUREE');
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,Duree,CodeRes2) then
        begin
          result := false;
          exit;
        end;
     End Else if Cadencement = '004' then  // 1/2 Journée
     begin
        Nbheure	  := 0;
	      DatePlanDeb := Item.GetValue('BEP_DATEDEB');
        DatePlanDeb := CalculDateDebut (DatePlanDeb);
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        Duree := Item.GetValue('BEP_DUREE');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,Duree,CodeRes2) then
        begin
          result := false;
          exit;
        end;
     End Else if Cadencement = '003' then // Heure
     begin
        Nbheure	  := 0;
	      DatePlanDeb := Item.GetValue('BEP_DATEDEB');
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        Duree := Item.GetValue('BEP_DUREE');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,Duree,CodeRes2) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     end else if cadencement = '002' then // 1/2 heure
     Begin
        DatePlanDeb := Item.GetValue('BEP_DATEDEB');
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        Duree := Item.GetValue('BEP_DUREE');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,Duree,CodeRes2) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     end else if cadencement = '001' then // 1/4 heure
     Begin
        DatePlanDeb := Item.GetValue('BEP_DATEDEB');
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        Duree := Item.GetValue('BEP_DUREE');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,Duree,CodeRes2) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     end;
  end else if pos(ModeOption,'E;R') > 0  then // etirement ou reduction
  Begin
     if cadencement = '005' then // journée
     Begin
        Nbheure	  := 0;
        DatePlanDeb := Trunc(DatePlanDeb) + GetDebutMatinee;
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        DatePlanFin := Trunc(DatePlanFin) + GetFinJournee;
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,0,CodeRes) then
        begin
          result := false;
          exit;
        end;
     End Else if Cadencement = '004' then  // 1/2 Journée
     begin
        Nbheure	  := 0;
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,0,CodeRes) then
        begin
          result := false;
          exit;
        end;
     End Else if Cadencement = '003' then // heure
     begin
        Nbheure	  := 0;
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,0,CodeRes) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     End Else if Cadencement = '002' then // 1/2 heure
     begin
        Nbheure	  := 0;
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,0,CodeRes) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     End Else if Cadencement = '001' then // 1/4 heure
     begin
        Nbheure	  := 0;
	      DatePlanFin := Item.GetValue('BEP_DATEFIN');
        DatePlanFin := GestionDateFinPourModif (DatePlanFin);
        if not ControleHoraires (DatePlanDeb,DatePlanFin,ModeOption,0,CodeRes) then
        begin
          result := false;
          exit;
        end;
        DatePlanFin := GestionDateFinPourEnreg (DatePlanFin);
     end;
	end;
  ChargementFicheHoraire (Item);

  label10.caption := NumEvenement;

  //Controle s'il n'y a pas de changement d'affectation
  if Coderes <> CodeRes2 then
     Begin
     if PgiAsk('Confirmez-vous le changement d''affectation ?', rep)=mryes then
        Begin
        TobItem := Item;
        ModificationAction;
        exit;
        end
     else
        Begin
        result := false;
        exit;
        end;
     end;

  //Traitement de la modification ou de la suppression d'un évènement libre
  if NumAppel = '' then
  Begin
     if ModeOption = 'S' then
     Begin
			  If pgiAsk('Confirmez-vous la suppression de l''évènement ?', rep)=MrYes then
        begin
          if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
          begin
        		EnvoieEltEmailFromAction (Item,'S',Idate1900,0);
          end;
          SuppressionItemPlanning('WHERE BEP_CODEEVENT ="' + NumEvenement + '"');
        end;
     end else
     Begin
        TobItem := Item;
     		ModificationAction;
     end;
     exit;
  end;

  //gestion de la suppression ou de la modification d'un évènement lié à un appel
  TobParam := Tob.Create('AppelActionEvenement', nil, -1);

  //vérification si un ou plusieur évènement pour cet appel
  StSql := 'SELECT BEP_CODEEVENT FROM BTEVENPLAN WHERE BEP_AFFAIRE = "' + NumAppel + '"';
  QQ := OpenSQL(StSQL, True,-1,'',false);
  If QQ.RecordCount > 1 then
     Begin
 	   TobParam.AddChampSupValeur('RETOUR', -1);
	   TobParam.AddChampSupValeur('ACTION', ModeOption);
     TobParam.AddChampSupValeur('EQUIPE', Equipe);
     TheTob := TobParam;
     AglLanceFiche ('BTP','BTSUPPEVENT','','','');
     TheTob := nil;
			if TOBParam.getValue('RETOUR')= 0 then
      begin
      	TOBParam.free;
				result := false;
        exit;
      end;
     end
   else
     Begin
	   TobParam.AddChampSupValeur('RETOUR', 1);
	   TobParam.AddChampSupValeur('ACTION', ModeOption);
  	 TobParam.AddChampSupValeur('EQUIPE', Equipe);
     end;

   Ferme(QQ);

   //retour de la fiche de choix sans choix
   if TobParam = nil then exit;
   //Sauvegarde de l'heure de début et de fin pour maj
   DDebut := Trunc(StrToDate(HDateDeb.Text)) + StrToTime(HDeb1.Text);
   DFin   := Trunc(StrToDate(HDateFin.Text)) + StrToTime(HFin1.Text);

   //Traitement de suppression (1 - ensemble de l'affectation, 2 - Equipe, 3 - Item Sélectionnées)
   if ModeOption = 'S' then
   Begin
		  If TobParam.GetValue('RETOUR') = 1 then
      begin
      		SqlB := 'WHERE BEP_AFFAIRE ="' + NumAppel + '"';
          if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
          begin
      			EnvoieEmailFromIntervention (Item,SqlB,'S',IDate1900,0);
          end;
         SuppressionItemPlanning(SqlB);
      end Else If TobParam.GetValue('RETOUR') = 2 Then
      begin
      		SqlB := 'WHERE BEP_AFFAIRE="' + NumAppel + '" AND BEP_EQUIPERESS="'+ Equipe+ '"';
          if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
          begin
      			EnvoieEmailFromIntervention (Item,SqlB,'S',IDate1900,0);
          end;
	       SuppressionItemPlanning(SqlB);
      end Else If TobParam.GetValue('RETOUR') = 3 Then
      begin
      	SqlB := ' WHERE BEP_CODEEVENT="'+NumEvenement+'"';
          if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
          begin
      			EnvoieEmailFromIntervention (Item,SqlB,'S',IDate1900,0);
          end;
         SuppressionItemPlanning(SqlB);
      end;
 	   	TobParam.free;
      TraitSuppItem(CodeRes, NumAppel, NumEvenement);
      exit;
   end;

	 //Traitement de Modification ou déplacement (1 - ensemble de l'affectation, 2 - Equipe, 3 - Item Sélectionnées)
   StSQL := 'UPDATE BTEVENPLAN SET BEP_DATEDEB="' + USTIME(DDebut) + '", ';
   StSQL := StSQL + 'BEP_DATEFIN="' + USTIME(DFin) + '", ';
   StSQL := StSQL + 'BEP_HEUREDEB="' + USTIME(StrToTime(HDeb1.text)) + '", ';
   StSQl := StSQl + 'BEP_HEUREFIN="' + USTIME(StrToTime(HFin1.Text)) + '", ';
   StSQl := StSQl + 'BEP_DUREE=' + StringReplace(FloatToStr(NbHeure),',','.',[rfReplaceAll]) + ' ';
   If TobParam.GetValue('RETOUR') = 1 then
   Begin
   	SqlB := 'WHERE BEP_AFFAIRE ="' + NumAppel + '"';
      StSql := StSQl +SqlB;
      if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
      begin
        EnvoieEmailFromIntervention (Item,SqlB,'M',DDebut,round(NbHeure));
      end;
      ExecuteSQL(StSql);
      ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 1);
   end else if TobParam.GetValue('RETOUR') = 2 Then
   Begin
   		SqlB := 'WHERE BEP_AFFAIRE="' + NumAppel + '" AND BEP_EQUIPERESS="'+ Equipe+ '"';
      StSQL := StSQl + SqlB;
      if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
      begin
        EnvoieEmailFromIntervention (Item,SQLB,'M',DDebut,round(NbHeure));
      end;
      ExecuteSQL(StSql);
      ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 2);
   end Else If TobParam.GetValue('RETOUR') = 3 Then
   Begin
   		SqlB := ' WHERE BEP_CODEEVENT="' + NumEvenement + '"';
      StSQL := StSQl + SqlB;
      if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
      begin
        EnvoieEmailFromIntervention (Item,SQLB,'M',DDebut,round(NbHeure));
      end;
      ExecuteSQL(StSql);
      ChargeItemPlanningSelectif(TobPlannings[PlanningCurrent.Tag], PlanningCurrent,TobModelePlanning.Detail[PlanningCurrent.Tag], Item, 0);
   end;

   // mise à jour de l'appel
   StSql := 'UPDATE AFFAIRE SET AFF_DATEREPONSE="'+ USDateTIME(DDebut)+'" WHERE AFF_AFFAIRE="'+NumAppel+'"';
   ExecuteSQL(StSql);

   TobParam.free;

//   Result := False;

end;

Procedure TMonPlanning.SuppressionItemPlanning(CritereLecture : String);
Var TobDelete : Tob;
    TobEvt		: Tob;
    StSql			: string;
    QQ				: TQuery;
    NumEvent	: String;
    i					: Integer;
Begin

  //Lecture en fonction de l'option choisie
  StSql := 'SELECT * FROM BTEVENPLAN ' + CritereLecture;
  QQ := OpenSQL(StSQL, True,-1,'',true);

  TobEvt := Tob.Create('Tob_Evenements', nil, -1);
  TobEvt.LoadDetailDB('BTEVENPLAN', '', '', QQ, False);

  Ferme(QQ);

  for i := 0 to TobEvt.Detail.Count -1 do
      Begin
      NumEvent  := TobEvt.detail[i].getValue('BEP_CODEEVENT');
      TobDelete := PlanningCurrent.TobItems.FindFirst(['BEP_CODEEVENT'], [NumEvent], True);
      if TobDelete <> nil then
         Begin
         PlanningCurrent.DeleteItem(TobDelete);
         end;
      end;

  TobEvt.free;

  //Suppression de l'évènement du planning
  StSql := 'DELETE FROM BTEVENPLAN ' +  CritereLecture;
  ExecuteSQL(StSql);

end;

Procedure TMonPlanning.TraitSuppItem(CodeRes : String; NumAppel : String; NumEvenement : String);
Var QQ		: TQuery;
		StSQL	: String;
    I			: Integer;
Begin

  //Vérification si la ressource est la ressource principale
  StSql := 'SELECT * FROM BTEVENPLAN WHERE BEP_AFFAIRE="' + NumAppel + '"';
  QQ := OpenSQL(StSQL, True,-1,'',true);
  if QQ.eof then
     Begin
     StSql := 'UPDATE AFFAIRE SET AFF_RESPONSABLE="", AFF_ETATAFFAIRE="ECO", AFF_DATEREPONSE=' + DateTimeToStr(iDate2099) + ' WHERE AFF_AFFAIRE ="' + NumAppel + '"';
     ExecuteSQL(StSql);
     ferme(QQ);
     exit;
     end;

  for I := 0 to QQ.recordcount -1 do
      Begin
      if QQ.FindField('BEP_RESSOURCE').AsString = CodeRes then
         begin
         if QQ.FindField('BEP_RESPRINCIPAL').AsString = 'X' then
            Begin
			      StSql := 'UPDATE AFFAIRE SET AFF_RESPONSABLE="' + CodeRes + '", AFF_ETATAFFAIRE="AFF", AFF_DATEREPONSE=' + USDateTime(DatePlanDeb) + ' WHERE AFF_AFFAIRE ="' + NumAppel + '"';
     				ExecuteSQL(StSql);
            ferme(QQ);
            exit;
            end;
         end
      else
         Begin
         if QQ.FindField('BEP_RESPRINCIPAL').AsString = 'X' then
            Begin
			      StSql := 'UPDATE AFFAIRE SET AFF_RESPONSABLE="' + QQ.FindField('BEP_RESPRINCIPAL').AsString + '", AFF_ETATAFFAIRE="AFF", AFF_DATEREPONSE=' + UsDateTime(DatePlanDeb) + ' WHERE AFF_AFFAIRE ="' + NumAppel + '"';
     				ExecuteSQL(StSql);
            ferme(QQ);
            exit;
            end;
         end;
      end;

  ferme(QQ);

end;

procedure TMonPlanning.BRefreshAffClick(Sender: TObject);
begin
	ChargeAppel;
end;

procedure TMonPlanning.FenDescriptifClose(Sender: TObject);
begin
  BDescriptif.down := False;
  BNoteWindows.Down := False;
  BTAFFMEMO.down := false;
end;

procedure TMonPlanning.BDescriptifClick(Sender: TObject);
begin
  BTAFFMEMO.down := false;
  FenDescriptif.Caption := 'Descriptif de l''appel';
  DESCRIPTIF.visible := true;
  DESCRIPTIF.Enabled := true;
  DesAction.Enabled  := false;
  DesAction.visible := false;

  FenDescriptif.Visible := BDescriptif.down;

  if FenDescriptif.visible then FenDescriptif.SetFocus;

end;

procedure TMonPlanning.GrilleSelectionClick(Sender: TObject);
begin

  if GrilleSelection.row = 1 then exit;
  if CreerPar <> 'TAC' then
     BTaches.Visible := False
  else
     BTaches.Visible := True;

	if Not ficappel then
     Begin
	   CodeDossierRech.text := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_AFFAIRE');
     Descriptif.Text 	    := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_DESCRIPTIF');
     if FenDescriptif.visible then FenDescriptif.SetFocus;
     end
  else
     Begin
     Nbheure  := TobEvenement.Detail[GrilleSelection.Row-1].GetValue('BEP_DUREE');
     HeureDeb := TobEvenement.Detail[GrilleSelection.Row-1].GetValue('BEP_HEUREDEB');
     HeureFin := TobEvenement.Detail[GrilleSelection.Row-1].GetValue('BEP_HEUREFIN');
//     Hdeb1.Text := FormatDateTime('hh:mm', FloatToTime(HeureDeb));
//     HFin1.Text := FormatDateTime('hh:mm', FloatToTime(HeureFin));
     DatePlanDeb := TobEvenement.Detail[GrilleSelection.Row-1].GetValue('BEP_DATEDEB');;
     DatePlanDeb := Trunc(DatePlanDeb) + (HeureDeb);
     end;

end;

procedure TMonPlanning.Timer2Timer(Sender: TObject);
begin
 if Not ficappel then BRefreshAffClick(Sender);
end;

procedure TMonPlanning.BNoteClick(Sender: TObject);
begin

  DESCRIPTIF.visible := False;
  DESCRIPTIF.Enabled := false;
  DesAction.Enabled  := true;
  DesAction.visible := true;

  FenDescriptif.Visible := BNoteWindows.down;

  if FenDescriptif.visible then FenDescriptif.SetFocus;

end;

procedure TMonPlanning.CHKTACHESClick(Sender: TObject);
begin

  ChargeAppel;

end;

procedure TMonPlanning.BTachesClick(Sender: TObject);
var StAffaire : String;
    StTiers   : String;
begin

  StAffaire := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_AFFAIREINIT');
  StTiers   := TobAppel.Detail[GrilleSelection.Row-1].GetString('AFF_TIERS');

  if stAffaire = '' then
     Begin
     pgibox('Il n''y a pas d''affaire de référence sur cet appel', 'Appel Tache');
     exit;
     end;

  AGLLanceFiche('BTP', 'BTTACHES','','', 'BYAFFAIRE;ATA_AFFAIRE:'+StAffaire+';ATA_TIERS:'+StTiers);

end;

Procedure TMonPlanning.RechargePlanning(TMO : Tob);
var CodeFamres : String;
Begin

  // Recharge les Onglets du planning
  if Typeplanning = 'PLA' then
     Begin
     //Cadencement := TobModelePlanning.Detail[PlanningCurrent.Tag].Getvalue('HPP_CADENCEMENT');
     PlanningCurrent.TypePlanning := Typeplanning;
     PlanningCurrent.CodeOnglet := TMO.GetValue('HPP_FAMRES');
     PlanningCurrent.FamRes := TMO.GetValue('HPP_FAMRES');
     ChargeParamPlanning(TobPlannings[PlanningCurrent.Tag], PlanningCurrent, TobModelePlanning.Detail[PlanningCurrent.Tag], StrToDateTime(DateEdit.Text), True);     // MAJ du titre de la fenetre
     CodeFamres := TobModelePlanning.Detail[PlanningCurrent.Tag].getvalue('HPP_FAMRES');
     Caption := TraduireMemoire('Planning ' + RechDom('HRFAMRES', CodeFamres, false) + ' Le ' + DateTimeToStr(DateSelectionee));
     end
  else
     Begin
     // MAJ du titre de la fenetre
	   //Cadencement := TobModelePlanning.Detail[0].Getvalue('HPP_CADENCEMENT');
     PlanningCurrent.TypePlanning := Typeplanning;
     PlanningCurrent.CodeOnglet := TMO.GetValue('CODEONGLET');
     PlanningCurrent.FamRes := TobModelePlanning.Detail[0].GetValue('HPP_FAMRES');
     ChargeParamPlanning(TobPlannings[PlanningCurrent.Tag], PlanningCurrent, TobModelePlanning.Detail[0], StrToDateTime(DateEdit.Text), True);
     Caption := TraduireMemoire(TobModelePlanning.Detail[0].GetValue('HPP_LIBELLE'));
     end;

end;

procedure TMonPlanning.BTypePlanningClick(Sender: TObject);
Var DateEnCours   : TDateTime;
    StContrat     : string;
    ParamPlanning : string;
    CodeAppel     : string;
    i             : integer;
    LTousPossible : boolean;
begin

  FormDestroy(Sender);

  PremierPassage := false;
  LTousPossible := false;
  DateEdit.Text := SaisieDate(StContrat, ParamPlanning, TypePlanning, LTousPossible,DateEdit.Text, true, true);

  if (ParamPlanning <> '') then
     TheParamPlanning.text := ParamPlanning;
  TousPossible := LTousPossible;
  CodeDossierRech.text := CodeAppel;

  DateSelectionee := StrToDate(DateEdit.Text);

  TobModelePlanning.free;
  TobOnglet.Free;

  InitialisationPlanning;

end;

Procedure TMonPlanning.ChargeTobCalendrierressource (Ressource : string; DateDepart : TdateTime ; TOBcalendar : TOB);
Var NoJour : String;
    StSQL  : String;
    QQ     : TQuery;
    Sql  : string;
    OkSpecifCal : boolean;
    Calendrier : string;
    Equipe : string;
Begin

  if not Assigned(TOBcalendar) then exit;

  if not Ok_TpsReel then Exit;

  //chargement du N° du jour pour recherche dans calendrier
  NoJour := IntToStr(DayOfWeek(DateDepart)-1);
  SQL := 'SELECT ARS_STANDCALEN, ARS_EQUIPERESS, ARS_CALENSPECIF FROM RESSOURCE ';
  SQL := SQL + 'WHERE ARS_RESSOURCE="' + Ressource + '"';
  QQ := OpenSQL(SQL, true,-1,'',true);
  if Not QQ.eof then
  Begin
    Calendrier := QQ.FindField('ARS_STANDCALEN').AsString;
    Equipe     := QQ.FindField('ARS_EQUIPERESS').AsString;
    if QQ.FindField('ARS_CALENSPECIF').AsString = '-' then
    	OkSpecifCal := False
    Else
    	OkSpecifCal := True;
  end;
  Ferme(QQ);
  Sql := '';
  //Vérification si Calendrier Particulier à la Ressource
  if Calendrier <> '' then
  Begin
     SQL := 'SELECT * FROM CALENDRIER WHERE ACA_JOUR  =' + NoJour;
     SQL := SQL + ' AND ACA_DATE <="' + UsDateTime(DateDepart) + '"';
     SQL := SQL + ' AND ACA_STANDCALEN="' + Calendrier + '"';
     if OkSpecifCal then
        SQL := SQL + ' AND ACA_RESSOURCE="' + Ressource + '"'
     else
        SQL := SQL + ' AND ACA_RESSOURCE="***"';
  end;

  if SQL = '' then exit;

  QQ := OpenSQL(SQL, true,-1,'',true);

  TOBcalendar.LoadDetailDB('CALENDRIER', '', '', QQ, False);

  Ferme(QQ);

end;

Procedure TMonPlanning.ChargeTobCalendrier;
Var NoJour : String;
    StSQL  : String;
    QQ     : TQuery;
Begin

  if Assigned(TobCalendrier) then FreeAndNil(TobCalendrier);

  if not Ok_TpsReel then Exit;

  //chargement du N° du jour pour recherche dans calendrier
  NoJour := IntToStr(DayOfWeek(DatePlanDeb)-1);

  //Vérification si Calendrier Particulier à la Ressource
  if Calendrier <> '' then
     Begin
     StSQL := 'SELECT * FROM CALENDRIER WHERE ACA_JOUR  =' + NoJour;
     StSQL := StSQL + ' AND ACA_DATE <="' + UsDateTime(DatePlanDeb) + '"';
     StSQL := StSQL + ' AND ACA_STANDCALEN="' + Calendrier + '"';
     if OkSpecifCal then
        StSQL := StSQL + ' AND ACA_RESSOURCE="' + CodeRes + '"'
     else
        StSQL := StSQL + ' AND ACA_RESSOURCE="***"';
     end;

  if StSQL = '' then exit;

  TobCalendrier := Tob.Create('Le Calendrier', nil, -1);

  QQ := OpenSQL(StSQL, true,-1,'',true);

  TobCalendrier.LoadDetailDB('CALENDRIER', '', '', QQ, False);

  Ferme(QQ);

end;

procedure TMonPlanning.CheckMoveItem(sender: Tobject; Item: TOB; var cancel: boolean);
begin
end;


procedure TMonPlanning.BTAFFMEMOClick(Sender: TObject);
begin
	FenDescriptif.Caption := 'Descriptif de l''évenement';
  FenDescriptif.Visible := true;
  DESCRIPTIF.visible := false;
  DESCRIPTIF.Enabled := false;
  DesAction.Enabled  := true;
  DesAction.visible := true;
end;

procedure TMonPlanning.CBTRAITEClick(Sender: TObject);
begin
  if PlanningCurrent <> nil then
  begin
    PlanningCurrent.Activate := False;
    PlanningCurrent.free;
    PlanningCurrent := THplanningBTP.Create(PageOnglet.ActivePage);
    PlanningCurrent.parent := Feuille[PageOnglet.ActivePage.tag];
    PlanningCurrent.Name := Format('PLANNING%2.2d', [PageOnglet.ActivePage.tag]);
    PlanningCurrent.Align := alClient;
    PlanningCurrent.AppelsTraites := CBTRAITE.Checked;
    If TypePlanning = 'PLA' then
      PlanningCurrent.tag := PageOnglet.ActivePage.tag
    Else
      PlanningCurrent.tag := 0;
    //Evenements
    MajEvenements(PlanningCurrent);
  end;
  PlanningCurrent.TypePlanning := Typeplanning;
  // Recharge les onglets du planning
  if Typeplanning = 'PLA' then
  	RechargePlanning(TobModelePlanning.Detail[PlanningCurrent.tag])
  else
  	RechargePlanning(Tobonglet.Detail[PageOnglet.ActivePage.tag]);
  //RechargePlanning(Tobonglet.Detail[PlanningCurrent.tag]);
  Planning[PageOnglet.ActivePage.tag] := PlanningCurrent;
end;

function TMonPlanning.IsModifiable(Item: TOB): boolean;
var QQ : TQuery;
begin
	result := true;
  if Item = nil then exit;
  if not assigned(Item) then exit;
  if Item.getValue('BEP_MODIFIABLE')<>'X' then
  begin
  	result := false;
    exit;
  end;
  if (Item.fieldExists('ACTIONSGRC')) and (Item.GetValue('ACTIONSGRC') <> 0) then
  begin
    QQ := OpenSql ('SELECT RAC_ETATACTION FROM ACTIONS WHERE RAC_AUXILIAIRE="'+
                   Item.getValue('CLIENTGRC')+'" AND RAC_NUMACTION='+IntToStr(Item.getValue('ACTIONSGRC')),true,1,'',true);
    if not QQ.eof then
    begin
      if QQ.FindField('RAC_ETATACTION').AsString <> 'PRE' then result := false;
    end;
    ferme (QQ);
    exit
  end;
	if Item.getValue('BEP_AFFAIRE') = '' then exit;
  QQ := OpenSql ('SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+
  								Item.getValue('BEP_AFFAIRE')+'"',true,1,'',true);
  if not QQ.eof then
  begin
  	if QQ.FindField('AFF_ETATAFFAIRE').AsString <> 'AFF' then result := false;
  end;
  ferme (QQ);
end;

procedure TMonPlanning.DeleteItemGRC (Auxiliaire : string; NumAct : integer);
var TOBEvt : TOB;
begin
	TOBEvt := PlanningCurrent.TobItems.FindFirst(['CLIENTGRC','ACTIONSGRC'],[Auxiliaire,NumAct],True);
  repeat
    PlanningCurrent.DeleteItem (TOBEvt);
    TOBEvt := PlanningCurrent.TobItems.FindNext(['CLIENTGRC','ACTIONSGRC'],[Auxiliaire,NumAct],True);
  until TOBevt = nil;
end;

procedure TMonPlanning.ReChargeActionGRC (Auxiliaire : string ; NumAct : integer);
var indice : Integer;
    OneTOB,TOBEvt : Tob;
begin
	DeleteItemGRC (Auxiliaire,NumAct);
  //
  OneTOB := TOB.Create ('LES ACTION GRC',nil,-1);
  ChargeActionsGRCDetail (OneTOB,Idate1900,Idate2099,PlanningCurrent.AppelsTraites,Auxiliaire,NumAct);

  if OneTOB.detail.count > 0 then
  begin
    for Indice := 0 to OneTOB.detail.count -1 do
    begin
      TOBEvt := TOB.Create ('BTEVENPLAN',PlanningCurrent.TobItems,-1);
      TransformeActionsEnItem (OneTOB.detail[indice],TOBevt,PlanningCurrent);
      ChargementTobItem (TOBEvt);
      PlanningCurrent.AddItem (TOBEvt) ;
      PlanningCurrent.InvalidateItem (TOBEvt);
    end;
  end;
  OneTOB.free;
end;

procedure TMonPlanning.ReChargeActionGRC (Item : TOB);
var Auxiliaire : string;
    Numaction : integer;
begin
  Auxiliaire:= Item.GetValue('CLIENTGRC');
  NumAction:= Item.GetValue('ACTIONSGRC');
  ReChargeActionGRC (Auxiliaire,NumAction);
end;

procedure TMonPlanning.ModificationsActionGRC(Item : TOB);
var resultat,auxiliaire : string;
    NumAct : Integer;
    DateD: TdateTime;
    Duree : integer;
begin
  Auxiliaire:= Item.GetValue('CLIENTGRC');
  NumAct:= Item.GetValue('ACTIONSGRC');
  DateD:= Item.GetValue('BEP_DATEDEB');
  Duree:= Item.GetValue('BEP_DUREE');
  resultat :=   AGLLanceFiche('RT','RTACTIONS','',Auxiliaire+';'+IntToStr(NumAct),'ACTION=MODIFICATION;MODIFPLANNING') ;
  if resultat <> '' then
  begin
    if (pos('DELETE',resultat) > 0) then
    begin
      if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
      begin
        EnvoieEltEmailFromGRC (Auxiliaire,NumAct,'D',Idate1900,0);
      end;
    	DeleteItemGRC (Auxiliaire,Numact);
    end
    else
    begin
      if GetParamSocSecur ('SO_BTAVERTIRENMODIF',true) then
      begin
        EnvoieEltEmailFromGRC (Auxiliaire,NumAct,'M',DateD,Duree,true);
      end;
    	ReChargeActionGRC (Auxiliaire,NumAct);
    end;
  end;
end;


function TMonPlanning.DeplacementActionGRC (Item : TOB) : boolean;
var CodeRes,Coderes2 : string;
	DateDeb,DateFin : TdateTime;
  duree : double;
  Auxiliaire : string;
  NumAction : integer;
begin
	result := true;
	if not IsModifiable(Item) then
  begin
  	result := false;
    exit;
  end;
  Auxiliaire:= Item.GetValue('CLIENTGRC');
  NumAction:= Item.GetValue('ACTIONSGRC');
  CodeRes		:= Item.GetValue('BEP_RESSOURCE');
  CodeRes2		:= PlanningCurrent.GetCurItem.GetValue('BEP_RESSOURCE');
  if CodeRes <> CodeRes2 then
  begin
  	result := false;
    exit;
  end;
  //
  if cadencement = '005' then // Journée
  Begin
    DateDeb := Item.GetValue('BEP_DATEDEB');
    DateDeb := Trunc(DateDeb) + GetDebutMatinee;
    DateFin := Item.GetValue('BEP_DATEFIN');
    DateFin := Trunc(DateFin) + GetFinJournee;
    Duree :=  CalculDureeEvenement (DateDeb,DatePlanFin);
    if not ControleHoraires (DateDeb,DateFin,'D',Duree,CodeRes2) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '004' then  // 1/2 Journée
  begin
    DateDeb := Item.GetValue('BEP_DATEDEB');
    DateDeb := CalculDateDebut (DateDeb);
    DateFin := Item.GetValue('BEP_DATEFIN');
    Duree := Item.GetValue('BEP_DUREE');
    DateFin := GestionDateFinPourModif (DateFin);
    if not ControleHoraires (DateDeb,DateFin,'D',Duree,CodeRes2) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '003' then // Heure
  begin
    DateDeb := Item.GetValue('BEP_DATEDEB');
    DateFin := Item.GetValue('BEP_DATEFIN');
    Duree := Item.GetValue('BEP_DUREE');
    DateFin := GestionDateFinPourModif (DateFin);
    if not ControleHoraires (DateDeb,DateFin,'D',Duree,CodeRes2) then
    begin
      result := false;
      exit;
    end;
  end else if cadencement = '002' then // 1/2 heure
  Begin
    DateDeb := Item.GetValue('BEP_DATEDEB');
    DateFin := Item.GetValue('BEP_DATEFIN');
    Duree := Item.GetValue('BEP_DUREE');
    DateFin := GestionDateFinPourModif (DateFin);
    if not ControleHoraires (DateDeb,DateFin,'D',Duree,CodeRes2) then
    begin
      result := false;
      exit;
    end;
  end else if cadencement = '001' then // 1/4 heure
  Begin
    DateDeb := Item.GetValue('BEP_DATEDEB');
    DateFin := Item.GetValue('BEP_DATEFIN');
    Duree := Item.GetValue('BEP_DUREE');
    DateFin := GestionDateFinPourModif (DateFin);
    if not ControleHoraires (DateDeb,DateFin,'D',Duree,CodeRes2) then
    begin
      result := false;
      exit;
    end;
  end;
  if not UpdateActionGRC (Auxiliaire,NumAction,DateDeb,DateFin) then
  begin
  	result := false;
    exit;
  end;
	ReChargeActionGRC (Auxiliaire,NumAction);
end;

function TMonPlanning.SuppressionActionGRC (Item : TOB) : boolean;
var  Auxiliaire : string;
		 NumAction : integer;
begin
	if not IsModifiable(Item) then
  begin
  	result := false;
    exit;
  end;
  If pgiAsk('Confirmez-vous la suppression de l''action ?')<>MrYes then
  begin
  	result := false;
    exit;
  end;

  Auxiliaire:= Item.GetValue('CLIENTGRC');
  NumAction:= Item.GetValue('ACTIONSGRC');
  if not DeleteActionGRC (Auxiliaire,NumAction) then
  begin
  	result := false;
    exit;
  end;
  DeleteItemGRC (Auxiliaire,numAction);
end;


function TmonPlanning.calculeDateEvtEtireReduit (Item : TOB; var DateD,DateF : TdateTime; var Delai : integer): boolean;
begin
	result := true;
  if cadencement = '005' then // journée
  Begin
    Delai	  := 0;
    DateD := Trunc(DateD) + GetDebutMatinee;
    DateF := Item.GetValue('BEP_DATEFIN');
    DateF := Trunc(DateF) + GetFinJournee;
    if not ControleHoraires (DateD,DateF,'E',0,CodeRes) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '004' then  // 1/2 Journée
  begin
    Delai	  := 0;
    DateF := Item.GetValue('BEP_DATEFIN');
    DateF := GestionDateFinPourModif (DateF);
    if not ControleHoraires (DateD,DateF,'E',0,CodeRes) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '003' then // heure
  begin
    Delai	  := 0;
    DateF := Item.GetValue('BEP_DATEFIN');
    DateF := GestionDateFinPourModif (DateF);
    if not ControleHoraires (DateD,DateF,'E',0,CodeRes) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '002' then // 1/2 heure
  begin
    Delai	  := 0;
    DateF := Item.GetValue('BEP_DATEFIN');
    DateF := GestionDateFinPourModif (DateF);
    if not ControleHoraires (DateD,DateF,'E',0,CodeRes) then
    begin
      result := false;
      exit;
    end;
  End Else if Cadencement = '001' then // 1/4 heure
  begin
    Delai	  := 0;
    DateF := Item.GetValue('BEP_DATEFIN');
    DateF := GestionDateFinPourModif (DateF);
    if not ControleHoraires (DateD,DateF,'E',0,CodeRes) then
    begin
      result := false;
      exit;
    end;
  end;
  Delai := round(CalculDureeEvenement (DateD,DateF));
end;


function TMonPlanning.ReductionEtirementActionGRC (Item : TOB) : boolean;
var DateD,DateF : TdateTime;
delai : integer;
		Auxiliaire : string;
    Numaction : integer;
begin
  Auxiliaire:= Item.GetValue('CLIENTGRC');
  NumAction:= Item.GetValue('ACTIONSGRC');
  DateD := Item.GetValue('BEP_DATEDEB');
  DateF := Item.GetValue('BEP_DATEFIN');
	result := calculeDateEvtEtireReduit (Item,DateD,DateF,Delai);
  if not result then exit;
  if not UpdateActionGRC (Auxiliaire,NumAction,DateD,DateF) then
  begin
  	result := false;
    exit;
  end;
	ReChargeActionGRC (Auxiliaire,NumAction);
end;

end.

