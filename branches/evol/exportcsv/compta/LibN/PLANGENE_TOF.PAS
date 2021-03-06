{***********UNITE*************************************************
Auteur  ...... : Vincent Laroche
Cr�� le ...... : 21/12/2004
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : PLANGENE ()
Mots clefs ... : TOF;PLANGENE
*****************************************************************}
Unit PLANGENE_TOF ;

Interface

Uses StdCtrls, Controls, Classes,
{$IFDEF EAGLCLIENT}
  eMul, uTob, MaineAGL, eQRS1,
{$ELSE}
  db,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  mul, FE_Main, QRS1,
{$ENDIF}
  forms, sysutils, ComCtrls, HCtrls, HEnt1, HMsgBox, UTOF;

procedure CPLanceFiche_PLANGENE(const Compte : String);

Type
  TOF_PLANGENE = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    FTri, TYPEEDITION : THRadioGroup;
    procedure TriOnClick(Sender : TObject);
    procedure TypeOnClick(Sender : TObject);

    procedure SetItemIndex(Combo : String);
  end ;

Implementation

procedure CPLanceFiche_PLANGENE(const Compte : String);
begin
  AGLLanceFiche('CP','CPPLANGENE','','',Compte);
end;

procedure TOF_PLANGENE.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnArgument (S : String ) ;
var
  i : Integer;
begin
  Inherited ;

  SetControlText('G_GENERAL', S);
  SetControlText('G_GENERAL_', S);
  
  SetItemIndex('G_NATUREGENE');
  SetItemIndex('G_SENS');

  FTri := THRadioGroup(GetControl('FTRI', True));
  FTri.OnClick := TriOnClick;

  TYPEEDITION := THRadioGroup(GetControl('TYPEEDITION', True));
  TYPEEDITION.OnClick := TypeOnClick;
  TypeOnClick(nil);

  // Libell� des tables libres (Evite des requ�tes � chaque fiche)
  for i := 0 to 9 do
    SetControlText('T'+IntToStr(i), RechDom('TTTABLESLIBRESGEN', 'G0'+IntToStr(i), False));
end ;

procedure TOF_PLANGENE.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_PLANGENE.OnCancel () ;
begin
  Inherited ;
end ;

// Choix du tri de l'�dition : Par compte g�n�ral ou Libell�
procedure TOF_PLANGENE.TriOnClick(Sender: TObject);
begin
  if (FTri.ItemIndex = 0) then SetControlText('XX_ORDERBY' , 'G_GENERAL')
                          else SetControlText('XX_ORDERBY' , 'G_LIBELLE')
end;

procedure TOF_PLANGENE.SetItemIndex(Combo: String);
begin
  TComboBox(GetControl(Combo, True)).ItemIndex := 0;
end;

// Choix du type d'�dition : Liste ou Fiche
procedure TOF_PLANGENE.TypeOnClick(Sender: TObject);
var
  b : Boolean;
begin
  b := (TYPEEDITION.ItemIndex = 0);
  if b then TFQRS1(Ecran).CodeEtat := 'GE2'
       else TFQRS1(Ecran).CodeEtat := 'GEN';

  SetControlEnabled('RIB', not b);
  {JP 02/11/05 : On n'autorise l'export qu'en mode liste}
  if not B then SetControlChecked('FLISTE', False);
  SetControlEnabled('FLISTE', B);
end;

Initialization
  registerclasses ( [ TOF_PLANGENE ] ) ;
end.
