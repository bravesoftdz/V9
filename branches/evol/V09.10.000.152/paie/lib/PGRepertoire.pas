{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 06/06/2007
Modifi� le ... :   /  /
Description .. : Unit� qui contient l'ensemble des fonctions et proc�dures
Suite ........ : utilis�es pour la gestion des r�pertoires
Mots clefs ... : PAIE;PGDIR
*****************************************************************}
{
}
unit PGRepertoire;

interface
uses SysUtils, CbpPath;

function VerifieCheminPG (Repertoire : string) : string;

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 06/06/2007
Modifi� le ... :   /  /    
Description .. : 
Mots clefs ... : PAIE;PGDIR
*****************************************************************}
function VerifieCheminPG (Repertoire : string) : string;
begin
if not DirectoryExists(Repertoire) then
   begin
   Result:= TCbpPath.GetCegidDistriStd;
   if not DirectoryExists(Result) then
      Result:= '';
   end
else
   Result:= Repertoire;
end;

end.
