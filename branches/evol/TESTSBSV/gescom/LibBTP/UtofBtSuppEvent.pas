{***********UNITE*************************************************
Auteur  ...... : 
Cr�� le ...... : 26/06/2006
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTSUPPEVENT ()
Mots clefs ... : TOF;BTSUPPEVENT
*****************************************************************}
Unit UtofBtSuppEvent ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul,
{$else}
     eMul,
     uTob,
{$ENDIF}
     AglInit,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF ;

Type
  TOF_BTSUPPEVENT = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  end ;

Implementation

procedure TOF_BTSUPPEVENT.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTSUPPEVENT.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTSUPPEVENT.OnUpdate ;
begin
  Inherited ;

	If TRadioButton(GetControl('ENSEMBLE')).Checked then
     LaTob.PutValue('RETOUR', 1)
  Else If TRadioButton(GetControl('EQUIPE')).Checked then
     LaTob.PutValue('RETOUR', 2)
  Else If TRadioButton(GetControl('EVENEMENT')).Checked then
     LaTob.PutValue('RETOUR', 3);

	TheTob := LaTob;

end ;

procedure TOF_BTSUPPEVENT.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTSUPPEVENT.OnArgument (S : String ) ;
begin
  Inherited ;

  LaTob.PutValue('RETOUR', 0);
  ecran.caption := 'Action � effectuer';
  UpdateCaption(ecran);
  if LaTob.GetValue('ACTION') = 'S' then
     Begin
     TRadioButton(GetControl('ENSEMBLE')).Caption := 'Supprimer l''ensemble de l''affectation';
     TRadioButton(GetControl('EQUIPE')).Caption := 'Supprimer toute l''�quipe';
     TRadioButton(GetControl('EVENEMENT')).Caption := 'Supprimer l''Ev�nement Seul';
     end
  else If LaTob.GetValue('ACTION') = 'E' then
  	 Begin
     TRadioButton(GetControl('ENSEMBLE')).Caption := 'Etirer l''ensemble de l''affectation';
     TRadioButton(GetControl('EQUIPE')).Caption := 'Etirer toute l''�quipe';
     TRadioButton(GetControl('EVENEMENT')).Caption := 'Etirer l''Ev�nement Seul';
     end
  else If LaTob.GetValue('ACTION') = 'R' then
  	 Begin
     TRadioButton(GetControl('ENSEMBLE')).Caption := 'R�duire l''ensemble de l''affectation';
     TRadioButton(GetControl('EQUIPE')).Caption := 'R�duire toute l''�quipe';
     TRadioButton(GetControl('EVENEMENT')).Caption := 'R�duire l''Ev�nement Seul';
     end
  else If LaTob.GetValue('ACTION') = 'D' then
  	 Begin
     TRadioButton(GetControl('ENSEMBLE')).Caption := 'D�placer l''ensemble de l''affectation';
     TRadioButton(GetControl('EQUIPE')).Caption := 'D�placer toute l''�quipe';
     TRadioButton(GetControl('EVENEMENT')).Caption := 'D�placer l''Ev�nement Seul';
     end
  else If LaTob.GetValue('ACTION') = 'M' then
  	 Begin
     TRadioButton(GetControl('ENSEMBLE')).Caption := 'Modifier l''ensemble de l''affectation';
     TRadioButton(GetControl('EQUIPE')).Caption := 'Modifier toute l''�quipe';
     TRadioButton(GetControl('EVENEMENT')).Caption := 'Modifier l''Ev�nement Seul';
     end;

  if LaTob.GetValue('EQUIPE') = '' then TRadioButton(GetControl('EQUIPE')).Enabled := false;

end ;

procedure TOF_BTSUPPEVENT.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTSUPPEVENT.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTSUPPEVENT.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_BTSUPPEVENT ] ) ; 
end.

 
