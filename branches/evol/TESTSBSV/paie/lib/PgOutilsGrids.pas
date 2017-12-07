{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 17/01/2008
Modifi� le ... :   /  /
Description .. : Unit� qui contient l'ensemble des fonctions et proc�dures
Suite ........ : utilis�es pour la gestion des grids
Mots clefs ... : PAIE;GRIDS
*****************************************************************}
unit PgOutilsGrids;

interface

Uses HCtrls;

procedure ValideComboDansGrid (Grille : THGrid; ActualCol, Col, Row : Integer);

implementation

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 17/01/2008
Modifi� le ... :   /  /    
Description .. : Proc�dure permettant la sortie de la cellule d'une grid de 
Suite ........ : type Combo.
Suite ........ : Param�tres :
Suite ........ : Grille : Control sur la grid
Suite ........ : ActualCol : Colonne en cours
Suite ........ : Col : Colonne par d�faut
Suite ........ : Row : Ligne par d�faut
Mots clefs ... : PAIE;GRIDS
*****************************************************************}
procedure ValideComboDansGrid (Grille : THGrid; ActualCol, Col, Row : Integer);
begin
if (Assigned (Grille.ValCombo)) then
   begin
   if (Copy(Grille.ColFormats[ActualCol], 1, 3)='CB=') then
      begin
      Grille.UpdateCell;
      Grille.Col:= Col;
      Grille.Row:= Row;
      Grille.ValCombo.Hide;
      Grille.ValCombo.Free;
      end;
   end;
end;

end.
