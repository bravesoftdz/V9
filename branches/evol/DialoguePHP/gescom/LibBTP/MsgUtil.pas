unit MsgUtil;

interface

uses
		 HEnt1,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
		 sysutils,
     Dicobtp,
     Ent1,
     Forms,
     Dialogs,
     Graphics,
     UTOM,
     UTOF,
     UTob,
     HCtrls,
     HTB97,
     HMsgBox;

     //Zone servant pour l'affichage des Grilles
Type
     AffGrille = RECORD
        ColGAppel  : String;
        LibGAppel	 : String;
        TableGapp	 : String;
        TriGapp		 : String;
        FormatGapp : String;
        LarGappel	 : String;
        AlignAppel : String;
        Alignement : String;
        SepMillier : String;
        NBDecimal  : String;
        Obligatoire: String;
        LibComplet : String;
        Visible    : String;
        BlancSiNul : String;
        Cumul      : String;
        Saisissable: String;
        TitreAppel : String;
     End;

     Procedure AfficheCouleur(Zone, Champs: THEdit);
     Procedure AfficheErreur(FormName, Erreur, Titre : String);
		 Procedure MajFontStyle (var Tobetats: Tob) ;
		 Procedure SelColorNew(Zone, Champs: THEdit; F : TForm);
     Procedure SelFonteNew(Zone : THLabel; Champs: THEdit; F : TForm);
     Procedure ChargeListeAssociee(StListe : String; StTitre : String; TTool : TToolWindow97; var GestGrille : AffGrille);
     Procedure DessineGrille(TTool : TToolWindow97; Grille : THGrid; GestGrille : AffGrille);

     Function DateToFloat (TDate: TDateTime) : Double;
     Function HRStrToInt(const StStr: string) : integer;
     Function LectLibCol(Prefixe, TypeLib, CodeLib, ZoneLib : String) : String;
     function MajItem(Liste: string; var GestGrille : AffGrille; ZoneARecup : String): string;
     Function RecTypeCommun(TypTablette : String; Libelle : String) : String;
		 Function StrDelete (chaine,sousChaine: string): string;

implementation

const

	// libell�s des messages pour la fiche Famille Ressource
  FamResMsg: array[1..8] of string  = (
      {1}  'Rythme de gestion non renseign� !'
      {2}, 'Le nombre de qualit�s est limit� � 10'
      {3}, 'Cette famille est utilis� par un type de ressource !'
      {4}, 'Nouvelle cr�ation impossible, Gestion de 3 familles de ressources au maximum !'
      {5}, 'La p�riode de d�but est incorrecte.'
      {6}, 'La p�riode de fin est incorrecte.'
      {7}, 'La p�riode de fin est sup�rieure � la p�riode de d�but.'
		  {8}, 'Le code famille est obligatoire.'
           );

  // Libell�s des messages pour la Fiche Param�tre Planning
  ParPlann : array[1..19] of string = (
      {1}  'La famille de la ressource n''est pas renseign�e!'
      {2}, 'Le mode de gestion n''est pas renseign�!'
      {3}, 'Le cadencement du planning n''est pas renseign�!'
      {4}, 'Choisissez un format de date.'
      {5}, 'Le libell� de la premi�re colonne de tri n''est pas renseign� !'
      {6}, 'Le libell� de la deuxi�me colonne de tri n''est pas renseign� !'
      {7}, 'Le libell� de la troisi�me colonne de tri n''est pas renseign� !'
      {8}, 'La ressource doit �tre obligatoirement une colonne du planning !'
      {9}, 'L''heure de d�but est obligatoire dans le cas d''un planning horaire'
     {10}, 'L''heure de fin est obligatoire dans le cas d''un planning horaire'
     {11}, 'Lex axes de contingentements doivent �tre diff�rents'
     {12}, 'Il faut au moins une colonne de Tri'
     {13}, 'Il faut au moins une colonne de Fixe'
     {14}, 'Le libell� de la premi�re colonne Fixe n''est pas renseign� !'
     {15}, 'Le libell� de la deuxi�me colonne Fixe n''est pas renseign� !'
     {16}, 'Le libell� de la troisi�me colonne Fixe tri n''est pas renseign� !'
     {17}, 'Le libell� de la quatri�me colonne Fixe n''est pas renseign� !'
     {18}, 'Le libell� de la cinqui�me colonne Fixe n''est pas renseign� !'
     {19}, 'Le libell� de la sixi�me colonne Fixe n''est pas renseign� !'

           );

	// Libell�s des messages de l'�cran des Types d'Action
	BTEtat	 : array[1..7] of string 	= (
      {1}  ''
      {2}, 'Le mode de gestion n''est pas renseign� !'
      {3}, ''
      {4}, 'Impossible de supprimer, type d''action pr�sent dans un �v�nement !'
      {5}, ''
      {6}, ''
      {7}, ''
           );

  // Libell�s des messages de la fiche ev�nementiels
  BTEvenement: array[1..7] of string = (
      {1}  'La d�signation de l''�tat doit �tre renseign�e'
      {2}, 'La date du fin de l''�v�nement est ant�rieure � la date de d�but! '
      {3}, ''
      {4}, ''
      {5}, ''
      {6}, ''
      {7}, ''
    			 );

  MAjPlan : array[1..2] of string = (
      {1}  'Aucun type de ressources n''est d�fini !'
      {2}, ''
           );
  // Libell�s des messages du Planning
  BTPlanning: array[1..15] of string = (
      {1}  'Affectation Impossible, num�ro d''�v�nement non d�termin� !'
      {2}, 'Ressource d�j� pr�sente dans la grille des affectations !'
      {3}, 'La Date d''affectation est inf�rieure � la date d''appel !'
      {4}, 'Une affectation existe d�j� pour cette ressource � cette date et � cette heure'
      {5}, 'le type d''action est obligatoire en saisie d''un �v�nement'
      {6}, 'Le surbooking n''est pas autoris� sur ce type d''action'
      {7}, 'La date de d�but et la date de fin sont �gales !'
      {8}, 'La date de d�but est sup�rieure � la date de fin !'
      {9}, 'Modification impossible sur cet �v�nement !'
			{10},'Le type d''action n''existe pas dans la table Type Action !'
 			{11},'La cr�ation automatique � partir de l''appel ne c''est pas faite !'
			{12},'le type d''action par d�faut n''est pas renseign� au niveau des param�tres'
 			{13},'le type d''action renseign� dans les param�tres n''existe pas'
      {14},'Impossible de modifier un appel r�alis� ou termin� !'
      {15},'La tache associ�e � cet appel ne dispose d''aucun type d''action'
    			 );

  // Libell�s des messages du Planning
  ParamFeuilleVente: array[1..4] of string = (
      {1}  'Impossible d''enlever ce champ il est d�finit dans les zones de tri !'
      {2}, 'Impossible d''enlever ce champ il est obligatoire pour l''affichage !'
      {3}, 'Impossible de placer ce champ dans les zones de tri c''est une formule !'
      {4}, 'Vous devez renseigner une formule !'
    			 );

Procedure AfficheErreur(FormName, Erreur, Titre : String);
var NumError	: Integer;
    Msg     	: String;
Begin

  NumError := StrToInt(Erreur);
  Titre := TraduireMemoire(Titre);

  if NumError <> 0 then
     Begin
     If FormName = 'BTPARAMFEUILLEVENTE' then
          Msg := TraduireMemoire(ParamFeuilleVente[NumError])
     Else if FormName = 'BTFAMRES' then
    	  Msg := TraduireMemoire(FamResMsg[NumError])
     Else if FormName = 'BTPARAMPLAN' then
          Msg := TraduireMemoire(ParPlann[NumError])
     Else if FormName = 'BTPLANNINGEX' then
    	  Msg := TraduireMemoire(MajPlan[NumError])
     Else if FormName = 'BTETAT' then
    	  Msg := TraduireMemoire(BTEtat[NumError])
     Else if FormName = 'BTEVENEMENT' then
          Msg := TraduireMemoire(BTEvenement[NumError])
     Else if FormName = 'BTPLANNING' then
          Msg := TraduireMemoire(BTPlanning[NumError]);
     end
  Else
	   Msg := TraduireMemoire(Erreur);

  if msg <> '' then PGIBox(msg,Titre);

end;

Procedure SelColorNew(Zone, Champs: THEdit; F : TForm);
Var T				: TColorDialog;
    Couleur	: Variant;
Begin

  Couleur := Champs.Text;

  T := TColorDialog.Create(F);

  T.color := Zone.Color;
  T.CustomColors.Clear;
  T.CustomColors.Add('ColorA=' + InttoHex(Zone.Color, 6));

  if T.Execute then
	   begin
     Couleur := IntTostr(T.Color);
     T.Free;
     end;

  if Couleur = '' then Couleur := StringToColor('ClWhite');

  Champs.Text := Couleur;
  Zone.Color := StringToColor(Couleur);
  Zone.Visible := True;

end;

procedure AfficheCouleur(Zone, Champs: THEdit);
var Couleur	: string;
begin

  Couleur := Champs.Text ;

  if (zone <> nil) and (champs.text <> '') then
	   begin
     Zone.Color := StringToColor(Champs.text);
     Zone.Visible := True;
     end
  else
     if (Zone <> nil) and (Champs.Text = '') then
        Zone.Visible := False;

end;

Procedure SelFonteNew(Zone : THLabel; Champs: THEdit; F : TForm);
Var T			: TFontDialog;
    Fonte	: Variant;
Begin

  Fonte := Champs.text ;

  T := TFontDialog.Create(F);

  T.Font.Size  := Zone.Font.Size;
	T.Font.Style := Zone.Font.Style;
  T.Font.Color := Zone.Font.Color;
  T.Font.Name  := Fonte;

  if T.Execute then Fonte := T.Font.Name;

  if Fonte = '' then Fonte := 'MS Sans Serif';

  Champs.Text := Fonte;

  Zone.Font.name := Fonte;
  Zone.Font.Size := T.Font.Size;
  Zone.Font.Style := T.Font.Style;
  Zone.Font.Color := T.Font.Color;

  T.Free;

end;

procedure MajFontStyle (var Tobetats: Tob) ;
var Boucle: integer;
    Etat	: string;
begin

  if (Tobetats <> nil) then
  	 begin
     for boucle := 0 to Tobetats.Detail.count - 1 do
    		 begin
	       Etat := TobEtats.detail[boucle].getvalue('BTA_FONTESTYLE') ;
         if Etat = 'fsBold' then
            TobEtats.detail[boucle].Putvalue('BTA_FONTESTYLE', 'G')
         else if Etat = 'fsItalic' then
            TobEtats.detail[boucle].Putvalue('BTA_FONTESTYLE', 'I') ;
         end;
     end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : R�gis H
Cr�� le ...... : 18/04/2005
Modifi� le ... :   /  /
Description .. : fonction qui s�curise le STRTOINT
Mots clefs ... : STRTOINT
*****************************************************************}

function HRStrToInt (const StStr: string) : integer;
begin

  if (IsNumeric (StStr) ) then
    result := strtoint (StStr)
  else
    result := 0;

end;

Function LectLibCol(Prefixe, TypeLib, CodeLib, ZoneLib : String) : String;
Var Req	  : String;
		QQ	  : TQuery;
    Table : String;
Begin

  Result := '';

  if Prefixe = 'CC' then
     Table := 'CHOIXCOD'
  else if Prefixe = 'CO' then
     Table := 'COMMUN'
  else
     Table := 'CHOIXEXT';


  Req := 'SELECT ' + ZoneLib + ' FROM ' + Table;
  Req := Req + ' WHERE ' + Prefixe + '_TYPE="' + TypeLib ;
  Req := Req + '" AND ' + Prefixe +'_CODE="' + CodeLib + '"';
  QQ  := OpenSQL(Req, true,-1, '', True);

  if ZoneLib = '' then ZoneLib := Prefixe + '_LIBRE';

  if not QQ.EOF then Result := QQ.FindField(ZoneLib).asString;

  Ferme(QQ);

end;


//Suppression d'un caract�re dans une chaine String
function StrDelete (chaine,sousChaine: string): string;
var indice : integer;
begin

  Repeat
  indice := pos (souschaine,chaine);
  if Indice = 1 then
     chaine := copy (chaine,2,255)
  else if Indice > 1 then
     Chaine := copy (chaine,1,Indice -1)+ copy(chaine,Indice+1,255);
  until indice <= 0;

  Result := Chaine;

end;

Function RecTypeCommun(TypTablette : String; Libelle : String) : String;
Var Req	: String;
		QQ	: TQuery;
Begin

  Result := '';

  Req := 'SELECT CO_CODE FROM COMMUN ';
  Req := Req + 'WHERE CO_TYPE="' + TypTablette + '" AND CO_LIBELLE="' + Libelle + '"';
  QQ  := OpenSQL(Req, true,-1, '', True);

  if not QQ.EOF then Result := QQ.FindField('CO_CODE').asString;

  Ferme(QQ);

end;

{***********A.G.L.***********************************************
Auteur  ...... : R�gis HARANG
Cr�� le ...... : 04/10/2001
Modifi� le ... :   /  /
Description .. : fonction qui retourne la partie entiere de la date, cad sans
Suite ........ : l'heure
Mots clefs ... :
*****************************************************************}
function DateToFloat (TDate: TDateTime) : Double;
var
  tmp: double;
begin
  tmp := Tdate - 0.49999;
  result := arrondi (Tmp, 0) ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Franck VAUTRAIN
Cr�� le ...... : 27/11/2007
Modifi� le ... :   /  /
Description .. : Fonction qui permet de d�couper le m�mo des liste
Suite ........ : pour r�cup�rer les zone, la taille, le formatage...
Mots clefs ... :
*****************************************************************}
Procedure ChargeListeAssociee(StListe : String; StTitre : String; TTool : TToolWindow97; var GestGrille : AffGrille);
Var StTmp	      : String;
    I			      : integer;
Begin

  StTmp := MajItem(StListe, GestGrille, 'ZZ');

  if not assigned(TTool) then exit;

(* : brl no comprendo donc en commentaires
  If I = 0 then
     Begin
     TTool.Caption := StTmp;
     TTool.Hint := StTmp;
     end
  else
     Begin
*)
     TTool.caption := StTitre;
     TTool.Hint := StTitre;
//     end;

end;

function MajItem(Liste: string; var GestGrille : AffGrille; ZoneARecup : String): string;
var
  Table: string;
  Crit: string; //param�tre de jointure
  Tri: string;
  Champ: string;
  Titre: Hstring;
  Larg: string;
  Align: string;
  Params: string;
  LeTitre: Hstring;
  NomCol: Hstring;
  Perso: string;
  OkTri: Boolean;
  OkNumCol: Boolean;
begin

  ChargeHListe(Liste, Table, Crit, tri, Champ, Titre, Larg, Align, Params, LeTitre, NomCol, Perso, OkTri, OkNumCol);

  if ZoneARecup = 'C' then
     Result := Champ
  Else if ZoneARecup = 'AL' then
     Result := Align
  Else if ZoneARecup = 'ZZ' then
     Begin
     //Chargement des variables du Record AffGrille
     GestGrille.ColGAppel  := Champ;
     GestGrille.LibGAppel  := Titre;
     GestGrille.TableGapp  := Table;
     GestGrille.TriGapp	   := tri;
     GestGrille.FormatGapp := '';
     GestGrille.LarGappel  := Larg;
     GestGrille.AlignAppel := Align;
     GestGrille.Alignement := '';
     GestGrille.SepMillier := '';
     GestGrille.NBDecimal  := '';
     GestGrille.Obligatoire:= '';
     GestGrille.LibComplet := '';
     GestGrille.Visible    := '';
     GestGrille.BlancSiNul := '';
     GestGrille.Cumul      := '';
     GestGrille.Saisissable:= '';
     // Erreur ne marche que pour une seule zone !!!!!!
     While Align <> '' do
        begin
        Champ := ReadTokenSt(Align);
        GestGrille.Alignement := GestGrille.Alignement  + Copy(Champ, 1, 1) + ';';
        GestGrille.SepMillier := GestGrille.SepMillier  + Copy(Champ, 2, 1) + ';';
        GestGrille.NBDecimal  := GestGrille.NBDecimal   + Copy(Champ, 3, 1) + ';';
        GestGrille.Obligatoire:= GestGrille.Obligatoire + Copy(Champ, 4, 1) + ';';
        GestGrille.LibComplet := GestGrille.LibComplet  + Copy(Champ, 5, 1) + ';';
        GestGrille.Visible    := GestGrille.Visible     + Copy(Champ, 6, 1) + ';';
        GestGrille.BlancSiNul := GestGrille.BlancSiNul  + Copy(Champ, 7, 1) + ';';
        GestGrille.Cumul      := GestGrille.Cumul       + Copy(Champ, 8, 1) + ';';
        GestGrille.Saisissable:= GestGrille.Saisissable + Copy(Champ, 9, 1) + ';';
        end;
     //
     GestGrille.TitreAppel := LeTitre;
     Result := Table + '-' +  Crit + '-' +  tri + '-' +  Champ + '-' +  Titre + '-' +  Larg + '-' + '-' + Params + '-' +  LeTitre;
     end;

  while Champ <> '' do
     begin
     Champ := ReadTokenst(Align);
     if Pos('$', Champ) <> 0 then
        GestGrille.FormatGapp := GestGrille.FormatGapp + '$;'
     else
        GestGrille.FormatGapp := GestGrille.FormatGapp + ';'
     end;

end;
{***********A.G.L.***********************************************
Auteur  ...... : Franck VAUTRAIN
Cr�� le ...... : 27/11/2007
Modifi� le ... :   /  /
Description .. : Fonction qui permet de d�ssiner une grille �
Suite ........ : partir d'une liste param�trable...
Mots clefs ... :
*****************************************************************}
Procedure DessineGrille(TTool : TToolWindow97; Grille : THGrid; GestGrille : AffGrille);
var StTmp       : String;
    Nbcol       : Integer;
    I			      : integer;
    TailleCol	  : Double;
Begin

  nbcol := 0;

  //calcul du Nombre de Colonne
  StTmp := GestGrille.ColGAppel;
  while  StTmp <> '' do
     begin
     NbCol := NbCol + 1;
     ReadTokenst(StTmp);
     end;

  if nbcol = 0 then exit;

  //Dessin de la grille
	With Grille do
       Begin
 		   RowCount := 2;
  		 ColCount := NbCol + 1;
			 FixedCols := 1;
			 FixedRows := 1;
			 DefaultRowHeight := 20;
       ColWidths[0] := 5;
       Cells[0,0] := '';
       if ColCount <> 1 then
          TTool.Width := 0
       else
          TTool.Width := 581;
 	     For i := 1 to ColCount - 1 Do
           Begin
	         Cells[I, 0] 	:= ReadTokenst(GestGrille.LibGAppel);
           TailleCol   	:= StrToFloat(ReadTokenst(GestGrille.LarGAppel));
           TailleCol		:= round((TailleCol * 6.25));
  				 if TTool.width < (Screen.Width-TailleCol) then
           	 TTool.Width := TTool.Width + StrToInt(FloatToStr(TailleCol));
		       ColWidths[I] := StrToInt(FloatToStr(TailleCol));
					 end;
       end;

  //Affichage et recentrage de la ttoolwindow TTWappel apr�s chargement
  TTool.Height := Screen.Height div 2;
  if TTool.width >=  Screen.Width then
     Begin
     Taillecol := TTool.Width;
     TTool.Width :=  round(Taillecol / 2);
     end;

  TTool.Left:=(Screen.Width-TTool.width) div 2;
  TTool.Top:=(Screen.Height-TTool.height) div 2;

end;



end.
