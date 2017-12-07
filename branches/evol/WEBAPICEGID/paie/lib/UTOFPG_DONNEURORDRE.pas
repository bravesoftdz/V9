{***********UNITE*************************************************
Auteur  ...... : PAIE PGI
Cr�� le ...... : 14/09/2001
Modifi� le ... :   /  /    
Description .. : Donneur ordre
Mots clefs ... : PAIE;VIREMENT;DONNEURORDRE
*****************************************************************}
{
PT1    : 14/09/2001 SB V547 Champ PDO_PGMODEREGLE DataType non renseign�
PT2    : 14/03/2007 VG V_72 BQ_GENERAL n'est pas forc�ment unique
}
unit UTOFPG_DONNEURORDRE;

interface
uses  Classes,
{$IFNDEF EAGLCLIENT}

{$ELSE}
       eFiche,efichlist,eMul,MaineAgl,
{$ENDIF}
     UTOF, Commun;

Type
     TOF_PGMULDONNEURORDRE = Class (TOF)
       procedure OnArgument(stArgument: String); override;
     END ;

implementation

{ TOF_PGMULDONNEURORDRE }

procedure TOF_PGMULDONNEURORDRE.OnArgument(stArgument: String);
begin
  inherited;
SetControlProperty('PDO_PGMODEREGLE','Datatype','PGMODEREGLE'); //PT1
SetPlusBanqueCP (GetControl ('PDO_RIBASSOCIE'));                //PT2

end;

Initialization
registerclasses([TOF_PGMULDONNEURORDRE]) ;
end.



