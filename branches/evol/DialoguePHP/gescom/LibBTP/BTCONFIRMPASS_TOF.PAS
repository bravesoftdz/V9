{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 30/09/2009
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTCONFIRMPASS ()
Mots clefs ... : TOF;BTCONFIRMPASS
*****************************************************************}
Unit BTCONFIRMPASS_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     AglInit,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     LicUtil,
     UTOF ;

Type
  TOF_BTCONFIRMPASS = Class (TOF)
  private
  	TOBOMFG : TOB;
    IsDayPass : boolean;
    Irpt : integer;
  public
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

procedure TOF_BTCONFIRMPASS.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTCONFIRMPASS.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTCONFIRMPASS.OnUpdate ;
begin
  Inherited ;
  if (IsDayPass) then
  begin
    if THEdit (GetControl('EPASSWORD')).Text <> DayPass(Now) then
    begin
    	THLabel(getCOntrol('TMESSAGEBAD')).visible := true;
    	THLabel(getCOntrol('TMESSAGEBAD')).Caption := 'Mot de passe invalide';
    	inc(IRpt);
      if IRpt < 4 then BEGIN ecran.ModalResult := 0; Exit; END;
    end else TOBOMFG.putValue('RESULTAT','OK');
  end else
  begin
  	TOBOMFG.putValue('RESULTAT','NOK');
  end;
  TheTOB := TOBOMFG;
end ;

procedure TOF_BTCONFIRMPASS.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTCONFIRMPASS.OnArgument (S : String ) ;
begin
  Inherited ;
  TOBOMFG := LaTOB;
  IsDayPass := TOBOMFG.fieldExists('DAYPASS');
  THLabel(getCOntrol('TMESSAGEBAD')).visible := false;
  Irpt :=0;
end ;

procedure TOF_BTCONFIRMPASS.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTCONFIRMPASS.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTCONFIRMPASS.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_BTCONFIRMPASS ] ) ; 
end.
