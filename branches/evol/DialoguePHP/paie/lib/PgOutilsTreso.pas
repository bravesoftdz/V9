{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 13/03/2007
Modifi� le ... :   /  /    
Description .. : Unit� qui les fonctions utiles pour les liens avec la tr�so
Mots clefs ... : PAIE;PGTRESO
*****************************************************************}
unit PgOutilsTreso;

interface

uses HEnt1,
{$IFNDEF EAGLCLIENT}
{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
     HCtrls,
     Constantes;

function PGBanqueCP (StAnd : Boolean) : String;

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 13/03/2007
Modifi� le ... :   /  /
Description .. : Ajout d'une condition sur BANQUECP
Mots clefs ... : PAIE;PGTRESO
*****************************************************************}
function PGBanqueCP (StAnd : Boolean) : String;
var
Trouve : boolean;
begin
result:= '';

Trouve:= TableSurAutreBase ('BANQUECP');

if (Trouve) then
   begin
   if (StAnd = True) then
      result:= ' AND'
   else
      result:= ' WHERE';

   result:= result+' BQ_NODOSSIER="'+V_PGI.NoDossier+'" AND '+BQCLAUSEWHERE;
   end;
end;

end.
 