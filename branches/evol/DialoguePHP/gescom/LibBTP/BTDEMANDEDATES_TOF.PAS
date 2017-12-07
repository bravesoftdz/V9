{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 03/09/2010
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTDEMANDEDATES ()
Mots clefs ... : TOF;BTDEMANDEDATES
*****************************************************************}
Unit BTDEMANDEDATES_TOF ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes,
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
     UTOF ;

Type
  TOF_BTDEMANDEDATES = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  	private
    	TOBData : TOB;
  end ;

Implementation

procedure TOF_BTDEMANDEDATES.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTDEMANDEDATES.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTDEMANDEDATES.OnUpdate ;
begin
  Inherited ;
  TOBData.SetDateTime ('DATEFAC',StrToDate(GetControlText('DATEFAC')));
  TOBData.putValue('RETOUROK','X');
end ;

procedure TOF_BTDEMANDEDATES.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTDEMANDEDATES.OnArgument (S : String ) ;
begin
  Inherited ;
  TOBData := LaTOB;
  SetControlText('DATEFAC',TOBData.getValue('DATEFAC'));
  if TOBData.getValue('DATESITUATION')='X' then
  begin
  	ecran.Caption := TraduireMemoire ('Date de situation');
    SetControlCaption('TDATEFAC','Date situation');
  end;
end ;

procedure TOF_BTDEMANDEDATES.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTDEMANDEDATES.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTDEMANDEDATES.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_BTDEMANDEDATES ] ) ; 
end.
