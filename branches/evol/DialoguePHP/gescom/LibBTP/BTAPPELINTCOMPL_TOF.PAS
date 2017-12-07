{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 16/10/2009
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTAPPELINTCOMPL ()
Mots clefs ... : TOF;BTAPPELINTCOMPL
*****************************************************************}
Unit BTAPPELINTCOMPL_TOF ;

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
		 AglInit,	
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     LookUp,
     UtilGc,
     DicoBTP ;

Type
  TOF_BTAPPELINTCOMPL = Class (TOF)
  private
  	TOBInfoCOmpl : TOB;
    procedure  StoreChamps;
    procedure  RecupChamps;
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

const  TexteMsgAffaire: array [1..1] of string = (
    {1}'saisi n''existe pas (table libre)'
    ) ;

Implementation

procedure TOF_BTAPPELINTCOMPL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTAPPELINTCOMPL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTAPPELINTCOMPL.OnUpdate ;
begin
  Inherited ;
  if GetControltext ('AFF_LIBREAFF1') <> '' then
  if not LookupValueExist (GetControl ('AFF_LIBREAFF1') ) then
  begin
    LastError := 1;
    LastErrorMsg := TraduitGa (THLabel (GetControl ('TAFF_LIBREAFF1') ) .Caption + ' ' + TexteMsgAffaire [LastError] ) ;
    SetFocusControl ('AFF_LIBREAFF1') ;
    Exit;
  end;
  if GetControlText ('AFF_LIBREAFF2') <> '' then
  if not LookupValueExist (GetControl ('AFF_LIBREAFF2') ) then
  begin
    LastError := 1;
    LastErrorMsg := TraduitGa (THLabel (GetControl ('TAFF_LIBREAFF2') ) .Caption + ' ' + TexteMsgAffaire [LastError] ) ;
    SetFocusControl ('AFF_LIBREAFF2') ;
    Exit;
  end;
  if GetCOntroltext ('AFF_LIBREAFF3') <> '' then
  if not LookupValueExist (GetControl ('AFF_LIBREAFF3') ) then
  begin
    LastError := 1;
    LastErrorMsg := TraduitGa (THLabel (GetControl ('TAFF_LIBREAFF3') ) .Caption + ' ' + TexteMsgAffaire [LastError] ) ;
    SetFocusControl ('AFF_LIBREAFF3') ;
    Exit;
  end;
  //
  StoreChamps;
  TheTOB := TOBInfoCOmpl;
  //
end ;

procedure TOF_BTAPPELINTCOMPL.OnLoad ;
begin
  Inherited ;
  RecupChamps;
end ;

procedure TOF_BTAPPELINTCOMPL.OnArgument (S : String ) ;
begin
  Inherited ;
  TOBInfoCOmpl := LaTOb;
  // Paramétrage des libellés des tables libres en gescom
  GCMAJChampLibre (TForm (Ecran) , False, 'COMBO', 'AFF_LIBREAFF', 10, '') ;
  GCMAJChampLibre (TForm (Ecran) , False, 'EDIT', 'AFF_VALLIBRE', 3, '') ;
  GCMAJChampLibre (TForm (Ecran) , False, 'EDIT', 'AFF_DATELIBRE', 3, '') ;
  GCMAJChampLibre (TForm (Ecran) , False, 'EDIT', 'AFF_CHARLIBRE', 3, '') ;
  GCMAJChampLibre (TForm (Ecran) , False, 'EDIT', 'AFF_RESSOURCE', 3, '') ;
  GCMAJChampLibre (TForm (Ecran) , False, 'BOOL', 'AFF_BOOLLIBRE', 3, '') ;

end ;

procedure TOF_BTAPPELINTCOMPL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTAPPELINTCOMPL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTAPPELINTCOMPL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTAPPELINTCOMPL.RecupChamps;
begin
	(*
	SetCOntroltext('AFF_LIBREAFF1',TOBInfoCOmpl.getValue('AFF_LIBREAFF1'));
	SetCOntroltext('AFF_LIBREAFF2',TOBInfoCOmpl.getValue('AFF_LIBREAFF2'));
	SetCOntroltext('AFF_LIBREAFF3',TOBInfoCOmpl.getValue('AFF_LIBREAFF3'));
	SetCOntroltext('AFF_LIBREAFF4',TOBInfoCOmpl.getValue('AFF_LIBREAFF4'));
	SetCOntroltext('AFF_LIBREAFF5',TOBInfoCOmpl.getValue('AFF_LIBREAFF5'));
	SetCOntroltext('AFF_LIBREAFF6',TOBInfoCOmpl.getValue('AFF_LIBREAFF6'));
	SetCOntroltext('AFF_LIBREAFF7',TOBInfoCOmpl.getValue('AFF_LIBREAFF7'));
	SetCOntroltext('AFF_LIBREAFF8',TOBInfoCOmpl.getValue('AFF_LIBREAFF8'));
	SetCOntroltext('AFF_LIBREAFF9',TOBInfoCOmpl.getValue('AFF_LIBREAFF9'));
	SetCOntroltext('AFF_LIBREAFFA',TOBInfoCOmpl.getValue('AFF_LIBREAFFA'));
	SetCOntrolText('AFF_DATELIBRE1',TOBInfoCOmpl.getValue('AFF_DATELIBRE1'));
	SetCOntrolText('AFF_DATELIBRE2',TOBInfoCOmpl.getValue('AFF_DATELIBRE2'));
	SetCOntrolText('AFF_DATELIBRE3',TOBInfoCOmpl.getValue('AFF_DATELIBRE3'));
	SetControlText('AFF_VALLIBRE1',TOBInfoCOmpl.getValue('AFF_VALLIBRE1'));
	SetControlText('AFF_VALLIBRE2',TOBInfoCOmpl.getValue('AFF_VALLIBRE2'));
	SetControlText('AFF_VALLIBRE3',TOBInfoCOmpl.getValue('AFF_VALLIBRE3'));
	SetControlText('AFF_BOOLLIBRE1',TOBInfoCOmpl.getValue('AFF_BOOLLIBRE1'));
	SetControlText('AFF_BOOLLIBRE2',TOBInfoCOmpl.getValue('AFF_BOOLLIBRE2'));
	SetControlText('AFF_BOOLLIBRE3',TOBInfoCOmpl.getValue('AFF_BOOLLIBRE3'));
	SetControlText('AFF_CHARLIBRE1',TOBInfoCOmpl.getValue('AFF_CHARLIBRE1'));
	SetControlText('AFF_CHARLIBRE2',TOBInfoCOmpl.getValue('AFF_CHARLIBRE2'));
	SetControlText('AFF_CHARLIBRE3',TOBInfoCOmpl.getValue('AFF_CHARLIBRE3'));
  *)
  TOBInfoCOmpl.PutEcran(ecran);
end;

procedure TOF_BTAPPELINTCOMPL.StoreChamps;
begin
  (*
  TOBInfoCOmpl.PutValue('AFF_LIBREAFF1',GetCOntroltext('AFF_LIBREAFF1'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF2',GetCOntroltext('AFF_LIBREAFF2'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF3',GetCOntroltext('AFF_LIBREAFF3'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF4',GetCOntroltext('AFF_LIBREAFF4'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF5',GetCOntroltext('AFF_LIBREAFF5'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF6',GetCOntroltext('AFF_LIBREAFF6'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF7',GetCOntroltext('AFF_LIBREAFF7'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF8',GetCOntroltext('AFF_LIBREAFF8'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFF9',GetCOntroltext('AFF_LIBREAFF9'));
	TOBInfoCOmpl.PutValue('AFF_LIBREAFFA',GetCOntroltext('AFF_LIBREAFFA'));
	TOBInfoCOmpl.PutValue('AFF_DATELIBRE1',GetCOntroltext('AFF_DATELIBRE1'));
	TOBInfoCOmpl.PutValue('AFF_DATELIBRE2',GetCOntroltext('AFF_DATELIBRE2'));
	TOBInfoCOmpl.PutValue('AFF_DATELIBRE3',GetCOntroltext('AFF_DATELIBRE3'));
	TOBInfoCOmpl.PutValue('AFF_VALLIBRE1',GetCOntroltext('AFF_VALLIBRE1'));
	TOBInfoCOmpl.PutValue('AFF_VALLIBRE2',GetCOntroltext('AFF_VALLIBRE2'));
	TOBInfoCOmpl.PutValue('AFF_VALLIBRE3',GetCOntroltext('AFF_VALLIBRE3'));
	TOBInfoCOmpl.PutValue('AFF_BOOLLIBRE1',GetCOntroltext('AFF_BOOLLIBRE1'));
	TOBInfoCOmpl.PutValue('AFF_BOOLLIBRE2',GetCOntroltext('AFF_BOOLLIBRE2'));
	TOBInfoCOmpl.PutValue('AFF_BOOLLIBRE3',GetCOntroltext('AFF_BOOLLIBRE3'));
	TOBInfoCOmpl.PutValue('AFF_CHARLIBRE1',GetCOntroltext('AFF_CHARLIBRE1'));
	TOBInfoCOmpl.PutValue('AFF_CHARLIBRE2',GetCOntroltext('AFF_CHARLIBRE2'));
	TOBInfoCOmpl.PutValue('AFF_CHARLIBRE3',GetCOntroltext('AFF_CHARLIBRE3'));
  *)
  TOBInfoCOmpl.GetEcran(ecran);
end;

Initialization
  registerclasses ( [ TOF_BTAPPELINTCOMPL ] ) ;
end.
