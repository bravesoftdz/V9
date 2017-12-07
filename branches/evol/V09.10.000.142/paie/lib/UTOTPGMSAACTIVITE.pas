{***********UNITE*************************************************
Auteur  ...... : JL
Cr�� le ...... : 21/04/2004
Modifi� le ... :   /  /
Description .. : Source TOT de la TABLE : PGMSAACTIVITE
Mots clefs ... : TOF;PGMSAACTIVITE                             
*****************************************************************
PT1 19/05/2005 JL V_60 FQ 12167 Code ab�r�g num�rique et 4 caract�res
}
Unit UTOTPGMSAACTIVITE ;

Interface

Uses StdCtrls, Controls, Classes,forms,sysutils,ComCtrls,
{$IFNDEF EAGLCLIENT}
      db,{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}HDB,
{$ELSE}
       UTOB,
{$ENDIF}
     HCtrls,HEnt1,HMsgBox,UTOT ;

Type
  TOT_PGMSAACTIVITE = Class ( TOT )
    procedure OnNewRecord              ; override ;
    procedure OnDeleteRecord           ; override ;
    procedure OnUpdateRecord           ; override ;
    procedure OnAfterUpdateRecord      ; override ;
    procedure OnClose                  ; override ;
    procedure OnArgument (S : String ) ; override ;
  end ;

Implementation

procedure TOT_PGMSAACTIVITE.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOT_PGMSAACTIVITE.OnDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOT_PGMSAACTIVITE.OnUpdateRecord ;
var Abrege : String;
begin
  Inherited ;
        Abrege := GetField('CC_ABREGE');
        If ExisteSQL('SELECT * FROM CHOIXCOD WHERE CC_TYPE="PMS" AND CC_CODE<>"'+GetField('CC_CODE')+'" '+
                     'AND CC_ABREGE="'+Abrege+'"') then
        begin
                PGIBox('Le code saisi dans l''abr�g� existe d�j�, vous devez en saisir un autre','Saisie activit� MSA');
                LastError := 1;
                Exit;
        end;
        //DEBUT PT1
        If (Length(Abrege) <> 4) or Not (IsNumeric(Abrege)) then
        begin
             PGIBox('Le code saisi dans l''abr�g� doit �tre num�rique et sur 4 caract�res','Saisie activit� MSA');
             LastError := 1;
             Exit;
        end;
        //FIN PT1
end ;

procedure TOT_PGMSAACTIVITE.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOT_PGMSAACTIVITE.OnClose ;
begin
  Inherited ;
end ;

procedure TOT_PGMSAACTIVITE.OnArgument (S : String ) ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOT_PGMSAACTIVITE ] ) ;
end.
