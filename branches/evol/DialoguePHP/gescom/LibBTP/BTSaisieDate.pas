unit BTSaisieDate;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Mask,
  Hctrls,
  ExtCtrls,
  HTB97,
  HPanel,
  HEnt1,
  Lookup,
  HMsgBox,
{$IFDEF EAGLCLIENT}
  MaineAGL,
{$ELSE}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fe_main,
{$ENDIF}
  HSysMenu;

Function SaisieDate (Var HrContrat,Stmodele,TypePlanning:String; var TousPossible : boolean;StDate :string =''; DuPlanning: Boolean= true; PlanningType: Boolean= true) : String ;

//
type
  TFSaisieDate = class(TForm)
    PSAISIEDATE	: THPanel;
    DateDu			: TLabel;
    DateDebut		: THCritMaskEdit;
    Dock972			: TDock97;
    Toolbar972	: TToolWindow97;

    BQUITTER				: TToolbarButton97;
    BSaisie					: TToolbarButton97;
    Label1					: TLabel;
    TParamPlanning	: TLabel;
    LPARAMPLANNING	: TLabel;
    ParamPlanning		: THCritMaskEdit;

    HSystemMenu1        : THSystemMenu;
    LModeplanning       : TLabel;
    ParamPlanningSauve  : THCritMaskEdit;
    MODEPLANNING        : THValComboBox;
    CBTOUS: THCheckbox;

    procedure FormShow(Sender: TObject);
    procedure DateDebutChange(Sender: TObject);
    procedure BSaisieClick(Sender: TObject);
    procedure BQUITTERClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MODEPLANNINGChange(Sender: TObject);
    procedure ParamPlanningElipsisClick(Sender: TObject);
    procedure ParamPlanningExit(Sender: TObject);
    procedure CBTOUSClick(Sender: TObject);
    
  private
    { Déclarations privées }

    PlanningType  : boolean;
    ModelPlanning : String;
    OkFerme       : Boolean;

    function RecupPlanDefaut: string;
    procedure LectureParamPlanning;

  public
    { Déclarations publiques }

  end;

var
  FSaisieDate: TFSaisieDate;
implementation

uses TntStdCtrls;

{$R *.DFM}


Function SaisieDate (Var HrContrat,Stmodele,TypePlanning:String; var TousPossible : boolean;StDate :string =''; DuPlanning: Boolean= true; PlanningType: Boolean= true) : String ;
var FF : TFSaisieDate;
begin

  FF := TFSaisieDate.Create(Application) ;
  if (Not DuPlanning) then { Caption sans le planning}
  	begin
    FF.Caption := 'Date de consultation';
  	end;

  FF.PlanningType :=  PlanningType;

  if (Stmodele = '-') then
  	begin
    FF.ParamPlanning.visible := false;
    FF.LParamPlanning.visible := false;
    FF.TParamPlanning.visible := false;
    FF.MODEPLANNING.visible := false;
    FF.LModeplanning.Visible := False;
    FF.CBTOUS.Visible := False;
  	end
  else if (Stmodele <> '') then
  	begin
    FF.ParamPlanning.text := Stmodele;
    FF.ParamPlanningExit(Application) ;
  	end;

  FF.DateDebut.Text := StDate;
  FF.MODEPLANNING.Value := TypePlanning;
  FF.CBTOUS.Checked := TousPossible;
  try
    FF.ShowModal ;
    result := FF.DateDebut.Text;
    Stmodele := FF.ParamPlanning.Text;
    TypePlanning := FF.MODEPLANNING.Value;
    TousPossible := FF.CBTOUS.Checked;
  finally
    FF.Free;
  end;

END;

procedure TFSaisieDate.FormShow(Sender: TObject);
begin

  //pointeur permettant de savoir si l'on ferme la fenetre de saisie
  OkFerme := True;

  //
  LectureParamPlanning;

end;

procedure TFSaisieDate.DateDebutChange(Sender: TObject);
begin
//
end;

procedure TFSaisieDate.BSaisieClick(Sender: TObject);
begin
  if (MODEPLANNING.Value = '') then
  begin
  	PgiInfo('Vous devez renseigner un type de planning');
    exit;
  end;
  // Ferme La fiche
  if OkFerme then Close;

end;

procedure TFSaisieDate.BQUITTERClick(Sender: TObject);
begin

  DateDebut.Text := DateTimeToStr (IDate1900);
  Close;

end;

procedure TFSaisieDate.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if Key = VK_ESCAPE Then BQuitterClick(Self);
     if Key = VK_F10 then BSaisie.Click;
end;

procedure TFSaisieDate.ParamPlanningElipsisClick(Sender: TObject);
var  Ok:Boolean;
     StRestriction:string;
begin
  if (PlanningType) then
     StRestriction := 'HPP_MODEPLANNING="' + MODEPLANNING.value  + '"'
  else
     StRestriction := 'HPP_MODEPLANNING="PLA"';

  ok := LookupList(ParamPlanning, 'Liste des modèles de planning', 'HRPARAMPLANNING', 'HPP_PARAMPLANNING',
                    'HPP_LIBELLE',StRestriction,'HPP_PARAMPLANNING', TRUE, -1);

  LectureParamPlanning;

end;

procedure TFSaisieDate.ParamPlanningExit(Sender: TObject);
begin

  LectureParamPlanning;

end;

Procedure TFSaisieDate.LectureParamPlanning;
Var StLib : String;
begin

  StLib := RechDom ('HRPARAMPLANNING', ParamPlanning.Text, False);

  if (stlib = '') then ParamPlanning.Text := '';

  if (ParamPlanning.Text = '') and (ParamPlanning.Text <> ParamPlanningSauve.text) then
     Begin
     OkFerme := false;
     StLib := ' ';
     end;

  if (StLib <> '') and (ParamPlanning.Text <> ParamPlanningSauve.text) then
     begin
     OkFerme := true;
     ParamPlanningSauve.text := ParamPlanning.Text;
     LParamPlanning.Caption := StLib;
     end;

end;


procedure TFSaisieDate.MODEPLANNINGChange(Sender: TObject);
begin

  ModelPlanning := MODEPLANNING.Value ;

  ParamPlanning.text := RecupPlanDefaut;

  LectureParamPlanning;

end;

//Récupération du planning par défaut
function TFSaisieDate.RecupPlanDefaut: string;
var QModelePlanning: TQuery;
begin

  result := '';

  QModelePlanning := OpenSQL('Select HPP_PARAMPLANNING from HRPARAMPLANNING where (HPP_MODEPLANNING="' + ModelPlanning + '") AND HPP_PLANNINGDEFAUT="X"', True,-1,'',true);

  if not QModelePlanning.eof then Result := QModelePlanning.FindField('HPP_PARAMPLANNING').AsString;

  Ferme(QModelePlanning);

end;


procedure TFSaisieDate.CBTOUSClick(Sender: TObject);
begin
	if CBTOUS.Checked then
  begin
  	ParamPlanning.Enabled := false;
  end else
  begin
  	ParamPlanning.Enabled := true;
  end;
end;

end.
