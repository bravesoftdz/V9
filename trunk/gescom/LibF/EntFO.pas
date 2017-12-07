{***********UNITE*************************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 05/05/2004
Modifi� le ... : 05/05/2004
Description .. : Gestion de la variable globale du Front Office VH_FO
Mots clefs ... : 
*****************************************************************}

unit EntFO;

interface

uses
  Windows;

type
  LaVariableFO = Class
    private
    public
      hSemaphoreFORun: THandle;
    published
  end;

procedure InitLaVariableFO;
procedure ChargeParamsFO;
procedure LibereLaVariableFO;

var
  VH_FO: LaVariableFO;

implementation

uses
  Sysutils;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 05/05/2004
Modifi� le ... : 05/05/2004
Description .. : Cr�ation de la variable globale du Front Office
Mots clefs ... :
*****************************************************************}

procedure InitLaVariableFO;
begin
  VH_FO := LaVariableFO.Create;
  with VH_FO do
  begin
    hSemaphoreFORun := 0;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 05/05/2004
Modifi� le ... : 05/05/2004
Description .. : Chargement des donn�es de la variable globale du Front
Suite ........ : Office
Mots clefs ... : 
*****************************************************************}

procedure ChargeParamsFO;
begin
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 05/05/2004
Modifi� le ... : 05/05/2004
Description .. : Lib�ration de la variable globale du Front Office
Mots clefs ... : 
*****************************************************************}

procedure LibereLaVariableFO;
begin
  if VH_FO <> nil then FreeAndNil(VH_FO);
end;

end.
