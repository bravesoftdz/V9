{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 01/04/2011
Modifié le ... :   /  /
Description .. : Source TOM de la TABLE : PORT (PORT)
Mots clefs ... : TOM;PORT
*****************************************************************}
Unit PORT_TOM ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     Fiche, 
     FichList, 
{$else}
     eFiche, 
     eFichList, 
{$ENDIF}
     forms,
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox, 
     UTOM, 
     UTob ;

Type
  TOM_PORT = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnAfterDeleteRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnClose                    ; override ;
    procedure OnCancelRecord             ; override ;
    procedure OnLoadAlerte               ; override ;
    procedure OnAfterCommit              ; override ;
    procedure OnAfterRollBack            ; override ;
    procedure OnAfterBeginTrans          ; override ;
  private
    fTypefrs : string;
    procedure afterFormShow;
  end ;

Implementation

procedure TOM_PORT.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnUpdateRecord ;
begin
  Inherited ;
  if fTypefrs = 'CO' then
  begin
  	SetField('GPO_TYPEFRAIS','B00');
  end else
  begin
  	SetField('GPO_TYPEFRAIS','501');
  end;
end ;

procedure TOM_PORT.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnAfterDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnLoadRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnChangeField ( F: TField ) ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnArgument ( S: String ) ;
begin
  Inherited ;
  if Pos('COTRAITANCE',S) > 0 then
  begin
  	fTypefrs := 'CO'; // frais de gestion cotraitance
  end else
  begin
  	fTypefrs := 'PO'; // frais et ports standard
  end;
  if fTypeFrs = 'CO' then
  begin
  	SetControlVisible ('GP_TVA',false);
  	SetControlVisible ('GPO_PVHT',false);
  	SetControlVisible ('TGPO_PVHT',false);
  	SetControlVisible ('GPO_FRAISREPARTIS',false);
  	SetControlVisible ('GPO_FRANCO',false);
  	SetControlVisible ('GPO_MINIMUM',false);
  	SetControlVisible ('TGPO_MINIMUM',false);
  	SetControlVisible ('GPO_MINIMUMTTC',false);
  	SetControlVisible ('TGPO_MINIMUMTTC',false);
  	SetControlVisible ('TGPO_VERROU',false);
  	SetControlVisible ('GPO_VERROU',false);
    THdBValComboBox(getControl('GPO_TYPEPORT')).plus := ' AND (CO_LIBRE LIKE "%CO%")';

  end else
  begin
    THdBValComboBox(getControl('GPO_TYPEPORT')).plus := ' AND (CO_LIBRE LIKE "%PO%")';
  end;
  TFFiche(Ecran).OnAfterFormShow := AfterFormShow;
end ;

procedure TOM_PORT.OnClose ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnCancelRecord ;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnLoadAlerte;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnAfterBeginTrans;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnAfterCommit;
begin
  Inherited ;
end ;

procedure TOM_PORT.OnAfterRollBack;
begin
  Inherited ;
end ;

procedure TOM_PORT.afterFormShow;
begin
  if fTypefrs = 'CO' then
  begin
    Ecran.Caption := 'Frais de gestion de cotraitance';
    UpdateCaption(ecran);
  end;
end;

Initialization
  registerclasses ( [ TOM_PORT ] ) ;
end.
