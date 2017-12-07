{***********UNITE*************************************************
Auteur  ...... : NA
Cr�� le ...... : 04/05/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : DROITJOURTYPE ()

Mots clefs ... : UTOFPGDROITjourneetype
*****************************************************************
PT1  19/07/2007  FLO  Param�trage des droits
PT2  09/08/2007  GGU  Recalcul automatique des compteurs lors d'une modification ou d'une suppresion de compteur.
}
unit UTOFPGDroitJourneeType;

interface

uses
  Classes,Controls,Utof,
  {$IFDEF EAGLCLIENT}
  eMul,
  MaineAgl,
  {$ELSE}
  db,
  FE_Main,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  HDB,
  Mul,
  {$ENDIF}
  Hmsgbox,Htb97,Utob,uTableFiltre,SaisieList,HQRY,Hctrls,sysutils,HEnt1,UTOM;

type
  TOF_PGDROITJOURNEETYPE = class(TOF)
    procedure OnArgument(Arguments: string); override;
    procedure OnLoad; override;
    procedure OnUpdate ; override ;
    procedure OnNew ; override ;
    procedure onDelete ; override;
    procedure Donneejournee(Sender : TObject);
  private
    TF : TTableFiltre;
    proven, jourtype : string;
    procedure OnClickParamDroits (Sender : TObject);
  End;

  //PT1 - D�but
  TOF_PGDROITSJOURNEE = class(TOF)
    procedure OnArgument(Arguments: string)  ; override ;
    procedure onDelete ; override;
  private
   TF : TTableFiltre;
   Fliste   : THGrid;
  End;
  //PT1 - Fin

implementation

Uses
  PGPresence, TntGrids;


{ TOF_PGDROITJOURNEETYPE }


{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 21/06/2007
Modifi� le ... :   /  /    
Description .. : On argument
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.OnArgument(Arguments: string);
Var Btn : TToolBarButton97;
begin
  inherited;

     proven := readtokenst(Arguments);
     jourtype := readtokenst(Arguments);

     If (Ecran <> nil ) and (Ecran is TFSaisieList ) then
          TF := TFSaisieList(Ecran).LeFiltre;

     if proven = 'JTYP' then
          TF.WhereTable := 'WHERE PDJ_JOURNEETYPE = "'+jourtype+'"'
     else
     begin
          TF.OnSetNavigate  :=  donneejournee;
          TFSaisieList(Ecran).TreeEntete.OnEnter := donneejournee;
          TFSaisieList(Ecran).TreeEntete.OnDblClick := donneejournee;
          TFSaisieList(Ecran).TreeEntete.OnClick := donneejournee;
     end;

     //PT1 - D�but
     // Bouton de param�trage des droits
     Btn := GetControl('BTNDROITS') As TToolBarButton97;
     If Assigned(Btn) Then Btn.OnClick := OnClickParamDroits;
     //PT1 - Fin
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 04/05/2007
Modifi� le ... :   /  /    
Description .. : Chargement des donn�es
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.OnLoad;
begin
  inherited;
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 21/06/2007
Modifi� le ... :   /  /    
Description .. : Nouveau droit
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.OnNew;
begin
  inherited;
     if proven <> 'JTYP' then
          donneejournee(nil)
     else
          setcontroltext('PDJ_JOURNEETYPE', jourtype);
end;
{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 04/05/2007
Modifi� le ... :   /  /
Description .. : Mise � jour
Mots clefs ... :
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.OnUpdate;
{var
libdroitjour, droitst : string;
droitjour: Thvalcombobox;}
var DD,DF : TDateTime;
begin
  inherited;
     //PT1 - D�but
//  droitjour := THValComboBox(GetControl('PDJ_PGDROIT'));
//  droitst := droitjour.value;

//  libdroitjour := rechdom('PGDROITJOURNEETYPE',droitst,False);
//  setcontroltext('PDJ_LIBELLE', libdroitjour);
     //PT1 - Fin
     PresenceDonneMoisCalculActuel (DD,DF);   //PT3
     CompteursARecalculer(DD); //PT2
end;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 14/06/2007
Modifi� le ... :   /  /    
Description .. : R�cup�ration des donn�es de la journ�e
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.donneejournee(sender : Tobject);
var
Q1: Tquery;
journee , stnom : String;
hordebplage1, horfinplage1, hordebplage2, horfinplage2 : Tdatetime;
begin
  // affichage libell�
  StNom := TF.TobFiltre.GetValue('PJO_JOURNEETYPE') + ' ' + TF.TobFiltre.GetValue('PJO_LIBELLE');
  TFSaisieList(Ecran).Caption := 'Droits associ�s � la journ�e type : '+StNom;
  UpdateCaption(TFSaisieList(Ecran));

  // affichage horaires de la journ�e
  journee := TF.TobFiltre.GetValue('PJO_JOURNEETYPE');
  Q1:= opensql('Select PJO_HORDEBPLAGE1, PJO_HORFINPLAGE1, PJO_HORDEBPLAGE2, PJO_HORFINPLAGE2 from'+
  ' JOURNEETYPE where PJO_JOURNEETYPE = "'+journee+'"', true);
  if not (Q1.EOF) then
  begin
    hordebplage1 := Q1.findfield('PJO_HORDEBPLAGE1').asdatetime;
    horfinplage1 := Q1.findfield('PJO_HORFINPLAGE1').asdatetime;
    hordebplage2 := Q1.findfield('PJO_HORDEBPLAGE2').asdatetime;
    horfinplage2 := Q1.findfield('PJO_HORFINPLAGE2').asdatetime;
    setControlText('HORDEBPLAGE1',FormatDateTime('hh:mm',hordebplage1));
    setControlText('HORDEBPLAGE2',FormatDateTime('hh:mm',hordebplage2));
    SetControlText('HORFINPLAGE1',FormatDateTime('hh:mm',horfinplage1));
    SetControlText('HORFINPLAGE2',FormatDateTime('hh:mm',horfinplage2));
  end;
  Ferme (Q1); //PT1
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 19/07/2007 / PT1
Modifi� le ... :   /  /    
Description .. : Param�trage des droits
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGDROITJOURNEETYPE.OnClickParamDroits(Sender: TObject);
var Combo : THValComboBox;
begin
     AglLanceFiche('PAY','DROITJOURNEE_FSL','','','');
     Combo := GetControl('PDJ_PGDROIT') As THValComboBox;
     If Combo <> nil Then Combo.ReLoad;
end;

procedure TOF_PGDROITJOURNEETYPE.onDelete;
var DD,DF : TDateTime;
begin
  inherited;
     PresenceDonneMoisCalculActuel (DD,DF);   //PT3
     CompteursARecalculer(DD); //PT2
end;

{ TOF_PGDROITSJOURNEE }

procedure TOF_PGDROITSJOURNEE.OnArgument(Arguments: string);
begin
  inherited;
     If (Ecran <> nil ) and (Ecran is TFSaisieList ) then TF := TFSaisieList(Ecran).LeFiltre;
     If Assigned(TF) Then TF.WhereTable := 'WHERE PDJ_JOURNEETYPE="***"';
end;

procedure TOF_PGDROITSJOURNEE.onDelete;
var
  Code : String;
begin
  inherited;
  Fliste   := THGrid(GetControl('FLISTE'));
  Code := Fliste.Cells[1,Fliste.Row];
end;

initialization
  registerclasses([TOF_PGDROITJOURNEETYPE, TOF_PGDROITSJOURNEE]);
end.
