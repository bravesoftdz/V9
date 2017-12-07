{***********UNITE*************************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 07/06/2006
Modifi� le ... :   /  /
Description .. : Unit� de gestion des diff�rents �tats du planning
Suite ........ : Exemple du Design Pattern : Singleton
Mots clefs ... :
*****************************************************************}
unit uBtpEtatPlanning;

interface

uses Windows,
  classes,
  sysutils,
  utob;

type
  MaTob = class (Tob)
  public
    procedure ReLoad() ;
    constructor Create () ; reintroduce ; overload ;
  end ;

function BTP_LesEtats: MaTOB;

implementation

var
  FDatas: MaTOB;

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
  FDatas.LoadDetailFromSQL ('Select * from BTETAT ORDER BY BTA_BTETAT') ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 07/06/2006
Modifi� le ... :   /  /
Description .. :
Mots clefs ... :
*****************************************************************}
function BTP_LesEtats: MaTOB;
begin
  if not assigned(FDatas) then Load() ;
  Result := FDatas ;
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

