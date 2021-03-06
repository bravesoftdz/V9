{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 06/11/2015
Modifi� le ... :   /  /
Description .. : Source TOM de la TABLE : DEPOTS (DEPOTS)
Mots clefs ... : TOM;DEPOTS
*****************************************************************}
Unit DEPOTS_TOM ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     Fiche,
     FichList,HDb,
{$else}
     eFiche,
     eFichList,
{$ENDIF}
     HCtrls,
     forms,
     sysutils,
     ComCtrls,
     HEnt1,
     HMsgBox,
     UTOM,
     HTB97,
     UTob ;

Type
  TOM_DEPOTS = Class (TOM)
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

    CodeDepot : THEdit;

    BDelete   : TToolBarButton97;

    StSQL     : string;
    end ;

Implementation
uses Paramsoc;

procedure TOM_DEPOTS.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnDeleteRecord ;
begin
  Inherited ;

end ;

procedure TOM_DEPOTS.OnUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnAfterDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnLoadRecord ;
begin
  Inherited ;

  //contr�le si code d�p�t sur une pi�ce
  StSQL := 'SELECT GP_DEPOT FROM PIECE WHERE GP_DEPOT="' + CodeDepot.Text + '"';
  if ExisteSQL(StSQL) then Bdelete.Visible := False else Bdelete.Visible := True;

end ;

procedure TOM_DEPOTS.OnChangeField ( F: TField ) ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnArgument ( S: String ) ;
var codeAxe : string;
begin
  Inherited ;

  CodeDepot := THEdit(Getcontrol('GDE_DEPOT'));
  Bdelete   := TToolBarButton97(Getcontrol('BDELETE'));
 CodeAxe := GetparamSocSecur('SO_BTAXEANALSTOCK','TX1');
 THDbEdit(GetControl('GDE_SECTION')).DataType := 'TZSECTION'+Copy(CodeAxe,2,1);

end ;

procedure TOM_DEPOTS.OnClose ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnCancelRecord ;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnLoadAlerte;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnAfterBeginTrans;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnAfterCommit;
begin
  Inherited ;
end ;

procedure TOM_DEPOTS.OnAfterRollBack;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOM_DEPOTS ] ) ; 
end.
