{***********UNITE*************************************************
Auteur  ...... : CB
Cr�� le ...... : 26/03/2001
Modifi� le ... :
Description .. : Fonction g�n�rales aux �crans de plan de charge
*****************************************************************}
unit UtilPlanDeCharge;

interface

uses Sysutils; //AFPlanningCst, UTOB;

  function MoisCourant(pInMois : Integer) : String;
  function CalculDate(pInMois : Integer) : TDateTime;

implementation

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 15/05/2002
Modifi� le ... :   /  /
Description .. : Retourne les mois formater pour les entetes de
               : colonnes de la grille au format mm/yy
Mots clefs ... :
*****************************************************************}
function MoisCourant(pInMois : Integer) : String;
var
  Y,M,D : Word;

begin
  decodeDate(Now, Y, M, D);
  if (M + pInMois) > 12 then
    begin
      M := M + pInMois - 12;
      Y := Y + 1;
    end
  else
    M := M + pInMois;

    result := formatDateTime('mm/yy',(encodeDate(Y, M, 1)));
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 10/05/2002
Modifi� le ... :   /  /
Description .. : Debut du mois pour la ligne de planning en PDC
Mots clefs ... :
*****************************************************************}
Function CalculDate(pInMois : Integer) : TDateTime;
begin
  Result := StrToDate('01/' + MoisCourant(pInMois));
end;

end.
