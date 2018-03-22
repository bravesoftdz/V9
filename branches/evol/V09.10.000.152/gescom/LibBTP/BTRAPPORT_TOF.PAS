{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 21/09/2017
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTRAPPORT ()
Mots clefs ... : TOF;BTRAPPORT
*****************************************************************}
Unit BTRAPPORT_TOF ;

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
     uTob, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox, 
     UTOF ; 

Type
  TOF_BTRAPPORT = Class (TOF)
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

procedure TOF_BTRAPPORT.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnArgument (S : String ) ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTRAPPORT.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_BTRAPPORT ] ) ; 
end.
