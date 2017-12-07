{***********UNITE*************************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 07/06/2006
Modifi� le ... :   /  /
Description .. : Unit� de gestion des diff�rents Affaires
Suite ........ : Exemple du Design Pattern : Singleton
Mots clefs ... :
*****************************************************************}
unit uBtpChargeTob;

interface

uses Windows,
  classes,
  sysutils,
  HCtrls,
  utob;

type
  MaTob = class (Tob)
  public
    procedure ReLoad() ;
    constructor Create () ; reintroduce ; overload ;
  end ;

function BTP_ChargeTob(StArguments : String) : MaTOB;

implementation

var
  FDatas  : MaTOB;

  StSQl   : String;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 07/06/2006
Modifi� le ... :   /  /
Description .. : Chargement des donn�es
Mots clefs ... :
*****************************************************************}
procedure Load () ;
begin

  FDatas := MaTOB.Create () ;

  FDatas.LoadDetailFromSQL (StSql) ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 07/06/2006
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function BTP_ChargeTob(StArguments : String) : MaTOB;
begin

  If StArguments = '' then
     Begin
     Result := nil;
     exit;
     end;

  if StSql <> StArguments then
     Begin
     FreeAndNil(FDatas);
     StSql := StArguments;
     end;

  if not assigned(FDatas) then Load() ;

  Result := FDatas;

end;

{ MaTob }

constructor MaTob.Create;
begin
  inherited Create ('', Nil, -1) ;
end;

procedure MaTob.ReLoad;
begin
  if assigned(FDatas) then
    FDatas.ClearDetail ;
  Load () ;
end;

initialization
  FDatas := nil;

finalization
  if assigned(FDatas) then
    FreeAndNil(FDatas);

end.

