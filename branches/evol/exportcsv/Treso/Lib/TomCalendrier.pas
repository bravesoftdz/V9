{***********UNITE*************************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 16/10/2001
Modifi� le ... : 21/09/2004
Description .. : Source TOM de la TABLE : CALENDRIER (CALENDRIER)
Suite ........ : JP 03/08/03 : Migration eAGL
Suite ........ : JP 21/09/04 : FQ 10142 : affichage des jours ouvrables
Mots clefs ... : TOM;CALENDRIER;FERIE
*****************************************************************}
Unit TomCalendrier ;

Interface

Uses
  {$IFDEF EAGLCLIENT}
  MaineAGL, UTob,
  {$ELSE}
  db,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  FE_Main,
  {$ENDIF}
  Windows, StdCtrls, Controls, Classes, forms, sysutils, UProcGen,
  HCtrls, HEnt1, UTOM, Graphics, Grids, HTB97, Menus, Commun;

Type
  TOM_TRCALENDRIER = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnCancelRecord             ; override ;
  protected
    GrPopupMenu: TPopUpMenu;
    cbMois: THDBValComboBox;
    cbJourFerie: THDBValComboBox;
    cbJourFerme: THDBValComboBox;
    spAnnee: THNumEdit;
    grCalend: THGrid;

    JourFermeModified: Boolean;
    PtClick: TPoint;	// Coordonn�es grille du clic de souris
    clUltraLight: TColor; // Couleur claire pour les cellules hors jours
    WeekOffset: Integer;  // Position dans la semaine du premier jour du mois
    EasterDate: TDateTime; // Date de P�ques de l'ann�e courante

    function GetDateFerie(I: Integer) : TDateTime;
    function GetDateFerme(I: Integer) : TDateTime;
    procedure GetPosition;
    function FormatDateFerme(aDate: TDateTime) : String;
    procedure OnGrPopUpMenu(Sender: TObject);
    procedure GrPopUpMenuOnClick(Sender: TObject);
    procedure CodeCalOnKeyPress(Sender: TObject; var Key: Char);
    procedure cbMoisOnChange(Sender: TObject);
    procedure spAnneeOnChange(Sender: TObject);
    procedure YearPrevOnClick(Sender: TObject);
    procedure YearNextOnClick(Sender: TObject);
    procedure MonthPrevOnClick(Sender: TObject);
    procedure MonthNextOnClick(Sender: TObject);
    procedure SelectDay(aDate: TDateTime);
    procedure FormPaint(Sender: TObject);
    procedure cbJourFerieOnChange(Sender: TObject);
    procedure cbJourFermeOnChange(Sender: TObject);
    procedure grCalendOnDrawCell(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState);
    procedure grCalendOnDblClick(Sender: TObject);
    procedure grCalendOnKeyPress(Sender: TObject; var Key: Char);
    procedure BasculerOnClick(Sender: TObject);
    procedure BasculeJour;
    procedure LoadJourFerie;
    procedure LoadJourFerme;
    procedure DeleteJourFerme;
  end ;

procedure TRLanceFiche_Calendrier(Dom: string; Fiche: string; Range: string; Lequel: string; Arguments: string);

Implementation

{ Contenu des cellules **********************************************
						Cells			:				Objects
 Titres		:	'Titre'					:	True = Colonne de jours ferm�s
			:							:
 Cellules	:	'0' = rien				:	Nil = 0 = rien ou ouvert non f�ri�s
			:	'n' = num�ro de jour	:
			:		jour f�ri� = bleu	:	n = indice du jour f�ri� dans la combo +1
			:		jour ferm� = rouge	:	$80+n = ferm�
*********************************************************************}

{ Contenu des variables/objets ***************************************************
						Items				 	:				Objects
 cbJourFerie : Liste des noms de dates f�ri�s	: Pour les dates mobiles, incr�ment par rapport � P�ques
	de l'ann�e en cours ; tablette TTJOURFERIE 	: Pour les autres, date avec ann�e CalendarClosedYear
												:
 cbJourFerme : Liste des jours ferm�s (sauf		: Date ferm�e (base CalendarXxYear)
	jours de la semaine) format� sans ann�e ou	: si jour f�ri� relatif � P�ques, CalendarEasterBound +
	nom de jour f�ri� ; table JOURFERME			: d�calage

*********************************************************************************}

uses
  Constantes, HDB;

const
  clWeekText   = clBlack; {Jours ouvr�s}
  clCloseDay   = clRed;   {Jours ferm�s}
  clSpecialDay = clNavy;  {Jours f�ri�s}
  clOuvrable   = clGreen; {Jours ouvrables non ouvr�s : en fait dans l'algo, Jours ferm�s <> des dimanche et jours f�ri�s}

procedure TRLanceFiche_Calendrier(Dom: string; Fiche: string; Range: string; Lequel: string; Arguments: string);
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;


procedure TOM_TRCALENDRIER.OnArgument( S: String );
var	I : Integer;
	C1: TColor;
	Y, M, D: Word;
begin
  Inherited;
  Ecran.HelpContext := 500010;

  cbMois := THDBValComboBox(GetControl('CBMOIS'));
  spAnnee := THNumEdit(GetControl('SPANNEE'));
  cbJourFerie := THDBValComboBox(GetControl('TTJOURFERIE'));
  cbJourFerme := THDBValComboBox(GetControl('TTJOURFERME'));
  grCalend := THGrid(GetControl('GRCALEND'));

  GrPopupMenu := TPopUpMenu(GetControl('GRPOPUPMENU'));
  GrPopupMenu.OnPopup := OnGrPopupMenu;
  GrPopupMenu.Items[0].OnClick := grPopupMenuOnClick; // Ferm�/Ouvr�

	// Couleur claire pour non jour
  if ColorToRGB(clBtnHighLight) <> ColorToRGB(clWindow) then
	clUltraLight := clBtnHighLight
  else
  begin  // Interm�diaire entre clBtnFace et clWhite
	C1 := ColorToRGB(clBtnFace);
	clUltraLight := RGB( ((C1 and $000000FF) + $000000FF) shr 1,
						((C1 and $0000FF00) + $0000FF00) shr 9,
						((C1 and $00FF0000) + $00FF0000) shr 17);
  end;

	// Init champs
  for I := 1 to 12 do	// Noms des mois
	cbMois.Items.Add(FirstMajuscule(LongMonthNames[I]));
  cbMois.ItemIndex := 0;

  DecodeDate(V_PGI.DateEntree, Y, M, D);
  spAnnee.Value := Y;
	// Init de la grille
  grCalend.RowHeights[0] := 21;
  for I := 0 to 6 do	// Noms des jours de la semaine
	grCalend.Cells[I, 0] := FirstMajuscule(LongDayNames[((I+1) mod 7) +1]);

  THDBEdit(GetControl('TCL_CODECAL')).OnKeyPress := CodeCalOnKeyPress;
  cbMois.OnChange := cbMoisOnChange;
  spAnnee.OnChange := spAnneeOnChange;
  cbJourFerie.OnChange := cbJourFerieOnChange;
  cbJourFerme.OnChange := cbJourFermeOnChange;
  grCalend.OnDrawCell := grCalendOnDrawCell;
  grCalend.OnDblClick := grCalendOnDblClick;
  grCalend.OnKeyPress := grCalendOnKeyPress;
  TToolBarButton97(GetControl('BYEARPREV')).OnClick := YearPrevOnClick;
  TToolBarButton97(GetControl('BMONTHPREV')).OnClick := MonthPrevOnClick;
  TToolBarButton97(GetControl('BMONTHNEXT')).OnClick := MonthNextOnClick;
  TToolBarButton97(GetControl('BYEARNEXT')).OnClick := YearNextOnClick;
  TToolBarButton97(GetControl('BASCULER')).OnClick := BasculerOnClick;
  TToolBarButton97(GetControl('BASCULER2')).OnClick := BasculerOnClick;
  TForm(Ecran).OnPaint := FormPaint;
end ;

procedure TOM_TRCALENDRIER.FormPaint(Sender: TObject);
var	Color: TColor;
begin  // En cas de modif de couleur V_PGI
  if V_PGI.NumAltCol=0 then
	Color := $00E8FFFF // ou clInfoBk ?
  else
	Color := AltColors[V_PGI.NumAltCol];
  THLabel(GetControl('BKLEGEND')).Color := Color;
  THLabel(GetControl('BKLEGEND')).Invalidate;
end;

 // Pr�pare le menu popup
procedure TOM_TRCALENDRIER.OnGrPopupMenu(Sender: TObject);
var
  S : string;
  N : Integer;
begin
  GetPosition;
  {On r�cup�re le num�ro du jour}
  N := StrToIntDef(grCalend.Cells[PtClick.X, PtClick.Y], 0);

  {Si l'on est sur une la ligne de titres, dans une colonne jours ferm�s ou sur une zone blanche}
  if (PtClick.Y = 0) or Boolean(grCalend.Objects[PtClick.X, 0]) or (N = 0) then begin
    PtClick.Y := 0; // Pour BasculeJour

    {On r�cup�re le libell� du jour en court}
    S := grCalend.Cells[PtClick.X, 0];

    {Il s'agit d'un jour ferm�}
    if Boolean(grCalend.Objects[PtClick.X, 0]) then
      S := S + ' &ouvr�' {TraduireMemoire ???}
    {21/09/04 : FQ 10142 : On est pas sur la colonne des dimanches}
    else if PtClick.X < 6 then
      S := S + ' &ouvrable'
    else {Jours ouvr�s}
      S := S + ' &ferm�';
  end
  {Autres jours de la semaines : ouvr�s et f�ri�s}
  else begin
    N := Integer(grCalend.Objects[PtClick.X, PtClick.Y]);
    {Jour f�ri�s}
    if (N and $7F) > 0 then begin
      {Si le jour est ouvert}
      if (N and $80) = 0 then S := TraduireMemoire('Jour &ferm�')
                         else S := TraduireMemoire('Jour &ouvr�')
    end
    {Autres jours}
    else begin
      {Si le jour est ouvert}
      if (N and $80) = 0 then S := TraduireMemoire('Jour &ouvrable') {FQ 10142}
                         else S := TraduireMemoire('Jour &ouvr�');
    end;
  end;

  GrPopupMenu.Items[0].Caption := S;

  grCalend.SetFocus;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 14/01/2002
Modifi� le ... :   /  /
Description .. : Met dans PtClick les coordonn�es de la case cliqu�e
Mots clefs ... :
*****************************************************************}
procedure TOM_TRCALENDRIER.GetPosition;
var	Pt: TPoint;
begin
  GetCursorPos(Pt);
  Pt := grCalend.ScreenToClient(Pt);
  grCalend.MouseToCell(Pt.X, Pt.Y, PtClick.X, PtClick.Y);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 05/12/2001
Modifi� le ... :   /  /
Description .. : Rend la date f�ri� � partir de l'indice dans cbFerie
Mots clefs ... : FERIER
*****************************************************************}
function TOM_TRCALENDRIER.GetDateFerie(I: Integer) : TDateTime;
begin
  Result := Integer(cbJourFerie.Items.Objects[I]);
  if Result < 200 then // Relatif � P�ques
	Result := Result+EasterDate;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 05/12/2001
Modifi� le ... :   /  /
Description .. : Rend la date ferm�e � partir de l'indice dans cbFerme
Mots clefs ... : FERME
*****************************************************************}
function TOM_TRCALENDRIER.GetDateFerme(I: Integer) : TDateTime;
var	Y, M, D: Word;
begin
  Result := Integer(cbJourFerme.Items.Objects[I]);
  DecodeDate(Result, Y, M, D);
  if Y = CalendarEasterYear then // = if aDate-CalendarEasterBound < 200
	Result := EasterDate + Result-CalendarEasterBound; // Date mobile dans l'ann�e courante
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 05/12/2001
Modifi� le ... :   /  /
Description .. : Formate une date de fermeture (sans ann�e et non f�ri�)
Suite ........ : pour affichage
Mots clefs ... : FERME;FORMAT
*****************************************************************}
function TOM_TRCALENDRIER.FormatDateFerme(aDate: TDateTime) : String;
begin
  Result := FormatDateTime('dd mmmm', aDate);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 22/10/2001
Modifi� le ... :   /  /
Description .. : Gestion des tables du calendrier
Suite ........ : Cr�ation / suppression / mise � jour / chargement
Mots clefs ... : CALENDRIER;JOUR FERME
*****************************************************************}
procedure TOM_TRCALENDRIER.DeleteJourFerme;
begin // Supprime les jours existants
  ExecuteSQL('Delete from JOURFERME where TJF_CODECAL="'+GetField('TCL_CODECAL')+'"');
end;

procedure TOM_TRCALENDRIER.LoadJourFerie;
var Q: TQuery;
	S: String;
	N, I: Integer;
begin
  EasterDate := CalculPaques(Trunc(spAnnee.Value));
	// Initialisation de la liste des jours f�ri�s
  N := 0;
  Q := OpenSQL('SELECT CO_LIBRE FROM COMMUN WHERE CO_TYPE="TJF"' {Ancien type :JFE}, True);
  try
	while not Q.Eof do
	begin
		S := Q.Fields[0].AsString;
		if S[1] = 'P' then	// Date � calculer par rapport � P�ques
		begin	// Stocke le d�calage (<200) au lieu de la date
			if S = 'P' then
				I := 0
			else	// P+
				I := StrToInt(Copy(S, 3, 9));
		end
		else	// Date fixe
			I := Trunc(StrToDate(S));
		cbJourFerie.Items.Objects[N] := Pointer(I);
		Inc(N);
		Q.Next;
	end;
  finally
	Ferme(Q);
  end;
end;

 // Charge les jours ferm�s, les jours de la semaines sont stock�s dans la grille, les autres dans la combo
procedure TOM_TRCALENDRIER.LoadJourFerme;
var	Q: TQuery;
	I: Integer;
	S: String;
	aDate: TDateTime;
begin
	// RAZ
  cbJourFerme.Items.Clear; // Vide les jours ferm�s
  for I:=0 to 6 do // Vide les jours de la semaine ferm�s
	grCalend.Objects[I, 0] := Pointer(False);

  Q := OpenSQL('Select * from JOURFERME where TJF_CODECAL="'+GetField('TCL_CODECAL')+
				'" order by TJF_DATEFERMEE', True);
  try
	while not Q.Eof do
	begin
		aDate := Q.FindField('TJF_DATEFERMEE').AsDateTime; // FindField ?
		// Dans la table JourFerme, un nombre proche de CalendarWeekBound signifie un jour de la semaine
		I := Trunc(aDate-CalendarWeekBound);
		if I < 10 then
			grCalend.Objects[I, 0] := Pointer(True)
		else // Dans la table JourFerme, une date avec CalendarEasterYear signifie un jour relatif � P�ques
		begin
			I := cbJourFerie.Items.IndexOfObject(Pointer(Trunc(aDate)));
			if I >= 0 then	// Si la date est un jour f�ri�, mettre le libell�
				S := cbJourFerie.Items[I]
			else
			begin
				I := Trunc(aDate-CalendarEasterBound);
				if I < 200 then  // D�calage
					S := cbJourFerie.Items[cbJourFerie.Items.IndexOfObject(Pointer(I))] // Existe forcemment !
				else
					S := FormatDateFerme(aDate);
			end;
			cbJourFerme.Items.AddObject(S, Pointer(Trunc(aDate)));
		end;
		Q.Next;
	end;
  finally
	Ferme(Q);
  end;

  JourFermeModified := False;
  cbMoisOnChange(Nil); // Pour tout recalculer
end ;

procedure TOM_TRCALENDRIER.OnLoadRecord ;
begin
  Inherited ;
  LoadJourFerie; // Contenu de la cbJourFerie utilis� par LoadJourFerme
  LoadJourFerme;
end;

 // Met � jour la table des jours ferm�s apr�s celle du calendrier
procedure TOM_TRCALENDRIER.OnAfterUpdateRecord ;
var	I: Integer;
	Sql: String;
	aDate: TDateTime;
	Y, M, D: Word;
begin
  Inherited ;
  if JourFermeModified then
  try
	BeginTrans;
	// Supprime les jours existants
	DeleteJourFerme;

	Sql := 'Insert into JOURFERME (TJF_CODECAL,TJF_DATEFERMEE) values ("'+GetField('TCL_CODECAL')+'","';
	// Ajoute les jours de la semaine
	for I:=0 to 6 do
		if grCalend.Objects[I, 0] = Pointer(True) then
			ExecuteSQL(Sql+UsDateTime(I+CalendarWeekBound)+'")');
	// Ajoute les nouveaux
	for I:=0 to cbJourFerme.Items.Count-1 do
	begin
		aDate := Integer(cbJourFerme.Items.Objects[I]);
		DecodeDate(aDate, Y, M, D);	 // Ne sauve pas si la date est ordinaire et dans une colonne ferm�e (nettoyage)
		if (Y <= CalendarEasterYear) or (grCalend.Objects[(D+WeekOffset) mod 7, 0] = Pointer(False)) then
			ExecuteSQL(Sql+UsDateTime(aDate)+'")');
	end;

	CommitTrans;
	JourFermeModified := False;
  except
	RollBack;
  end;
end ;

 // Initialise un nouveau calendrier
procedure TOM_TRCALENDRIER.OnNewRecord ;
begin
  Inherited ;
  // Copier le standard ?
end ; // Fait un OnLoad ensuite ! (fait donc le RAZ : OK)

 // Efface un calendrier
procedure TOM_TRCALENDRIER.OnDeleteRecord ;
begin
  Inherited ;
  DeleteJourFerme;
end ;

procedure TOM_TRCALENDRIER.OnCancelRecord ;
begin
  Inherited ;
  if JourFermeModified then
	LoadJourFerme;	// Restore jours ferm�s
end ;

procedure TOM_TRCALENDRIER.CodeCalOnKeyPress(Sender: TObject; var Key: Char);
begin
  Inherited;
  ValidCodeOnKeyPress(Key);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 16/10/2001
Modifi� le ... :   /  /
Description .. : Rempli la grille selon le mois courant et le code calendrier
Mots clefs ... : MOIS
*****************************************************************}
procedure TOM_TRCALENDRIER.cbMoisOnChange(Sender: TObject);
var
  D, M, Y,
  DMax     : Word;
  CurMonth : Integer;
  I, J     : Integer;
begin
	// Calcule position du premier jour
  CurMonth := cbMois.ItemIndex+1;
  WeekOffset := DayOfWeek(EncodeDate(Trunc(spAnnee.Value), CurMonth, 1))-3;
  if WeekOffset = -2 then	WeekOffset := 5;
  DMax := DaysPerMonth(Trunc(spAnnee.Value), CurMonth);

  {Affectation les num�ros de jour aux cellules}
  D := 1;
  for J := 1 to 6 do
    for I := 0 to 6 do begin
      if (I+ J*7 -8 < WeekOffset) or (D > DMax) then
        grCalend.Cells[I, J] := '0'
      else begin
        grCalend.Cells[I, J] := IntToStr(D);
        Inc(D);
      end;
      {Vide les jours f�ri�s ou ferm�s}
      grCalend.Objects[I, J] := nil;
    end;

  {Recherche des jours f�ri�s du mois courant}
  for I := 0 to cbJourFerie.Items.Count - 1 do begin
    DecodeDate(GetDateFerie(I), Y, M, D);
    if M = CurMonth then begin
            //Inc(D, WeekOffset); marche pas chez R�gis !
      D := D + WeekOffSet;
      grCalend.Objects[D mod 7, D div 7 +1] := Pointer(I+1); // Nom du jour
    end;
  end;

	 // Recherche des jours ferm�s du mois courant
  for I:=0 to cbJourFerme.Items.Count-1 do
  begin
	DecodeDate(GetDateFerme(I), Y, M, D);
	if M = CurMonth then
	begin
		//Inc(D, WeekOffset); marche pas chez R�gis !
		D := D+ WeekOffSet;
		grCalend.Objects[D mod 7, D div 7 +1] := Pointer(Integer(grCalend.Objects[D mod 7, D div 7 +1]) + $80);
	end;
  end;

end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 19/10/2001
Modifi� le ... :   /  /
Description .. : Recalcule les jours f�ri�s de l'ann�e en cours et raffraichi la
Suite ........ : grille suite au changement d'ann�e
Mots clefs ... : ANNEE
*****************************************************************}
procedure TOM_TRCALENDRIER.spAnneeOnChange(Sender: TObject);
begin
  LoadJourFerie;
  cbMoisOnChange(nil);
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.YearPrevOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if spAnnee.Value > 1980 then
    spAnnee.Value := spAnnee.Value -1;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.YearNextOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if spAnnee.Value < 2100 then
    spAnnee.Value := spAnnee.Value +1;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.MonthPrevOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  N : Integer;
begin
  N := cbMois.ItemIndex -1;
  if N < 0 then N := 11;
  cbMois.ItemIndex := N;
  cbMoisOnChange(nil);
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.MonthNextOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  N : Integer;
begin
  N := cbMois.ItemIndex +1;
  if N > 11 then N := 0;
  cbMois.ItemIndex := N;
  cbMoisOnChange(nil);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 19/10/2001
Modifi� le ... :   /  /
Description .. : Positionne le focus sur un jour f�ri� ou ferm� choisi dans
Suite ........ : une des combos
Mots clefs ... : FERIE;FERME
*****************************************************************}
procedure TOM_TRCALENDRIER.SelectDay(aDate: TDateTime);
var	Y, M, D: Word;
begin
  DecodeDate(aDate, Y, M, D);
  cbMois.ItemIndex := M-1; // Positionne le mois
  cbMoisOnChange(Nil); // Pas d�clanch� par affectation !
  //Inc(D, WeekOffset); Marche pas chez R�gis !
  D := D+WeekOffset;
  grCalend.Col := D mod 7; // Positionne le jour
  grCalend.Row := D div 7 +1;
  grCalend.SetFocus;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.cbJourFerieOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  SelectDay(GetDateFerie(cbJourFerie.ItemIndex));
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.cbJourFermeOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  SelectDay(GetDateFerme(cbJourFerme.ItemIndex));
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 19/10/2001
Modifi� le ... :   /  /
Description .. : Bascule le jour double-cliqu� (ou Espace ou menu) en ouvert / ferm�
Suite ........ : Un double-clic dans le titre bascule la colonne
Suite ........ : Le jour ferm� est ajout� et tri� ou retir� dans la combo
Mots clefs ... : DBLCLICK;FERME
*****************************************************************}
procedure TOM_TRCALENDRIER.BasculeJour;
  procedure ForceModified;
  begin	 // Force l'�tat modified de la table calendrier pour provoquer la mise � jour de la table des jours f�ri�s
    // if not DS.Modified ?
    DS.Edit;
    SetField('TCL_CODECAL', GetField('TCL_CODECAL'));
    JourFermeModified := True;
  end;

var
  N, I  : Integer;
  S     : String;
  aDate : TDateTime;
begin
  if PtClick.Y = 0 then
  begin
    grCalend.Objects[PtClick.X, 0] := Pointer(not Boolean(grCalend.Objects[PtClick.X, 0]));
    grCalend.InvalidateCol(PtClick.X);
    // Si marquage colonne, ouvrir tous les jours inclus (g�r� en sauvegarde) ?
    ForceModified;
  end
  else if not Boolean(grCalend.Objects[PtClick.X, 0]) then
  begin		// Par sur colonne des ferm�s
    N := StrToInt(grCalend.Cells[PtClick.X, PtClick.Y]); // Num�ro du jour
    if N > 0 then	// Sur une date
    begin
      aDate := EncodeDate(CalendarClosedYear, cbMois.ItemIndex+1, N);
      N := Integer(grCalend.Objects[PtClick.X, PtClick.Y]);
      if (N and $7F) > 0 then // F�ri�
      begin	// Recalcule la date si mobile, et le libell�
        I := Integer(cbJourFerie.Items.Objects[(N and $7F) -1]);
        if I < 200 then // Relatif � P�ques
                aDate := CalendarEasterBound + I;
        S := cbJourFerie.Items[(N and $7F) -1];
      end
      else
        S := FormatDateFerme(aDate);

      if (N and $80) = 0 then
      begin // Ouvert -> Ferm�
        I := N or $80;
        N := 0;	 // Ajoute dans la combo des jours ferm�s (tri�, mais les jours relatifs � P�ques restent au d�but)
        while (N < cbJourFerme.Items.Count) and (Integer(cbJourFerme.Items.Objects[N]) < aDate) do
                Inc(N);
        cbJourFerme.Items.Insert(N, S);
        cbJourFerme.Items.Objects[N] := Pointer(Trunc(aDate));
        cbJourFerme.ItemIndex := N;
      end
      else
      begin // Ferm� -> Ouvert
        I := N and $7F;
        cbJourFerme.ItemIndex := -1;
        N := cbJourFerme.Items.IndexOf(S); // N >= 0 !
        cbJourFerme.Items.Delete(N); // Retire de la combo
      end;
      grCalend.Objects[PtClick.X, PtClick.Y] := Pointer(I);

      ForceModified;
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.grCalendOnDblClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  GetPosition;
  BasculeJour;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.GrPopUpMenuOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  BasculeJour;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.BasculerOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  PtClick := TPoint(grCalend.Selection.TopLeft);
  if (Sender <> Nil) and (TToolBarButton97(Sender).Tag > 0) then // Jour de la semaine
    PtClick.Y := 0;
  BasculeJour;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_TRCALENDRIER.grCalendOnKeyPress(Sender: TObject; var Key: Char);
{---------------------------------------------------------------------------------------}
begin  // Que dans la grille !!
  if Key = ' ' then  // Ferme/Ouvre le jour Focused
    BasculerOnClick(Nil);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 19/10/2001
Modifi� le ... :   /  /
Description .. : Affichage de la grille
Suite ........ : Choix de couleur selon le type de jour
Mots clefs ... : AFFICHAGE;CELLULE
*****************************************************************}
procedure TOM_TRCALENDRIER.grCalendOnDrawCell(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState);
var
  S : string;
  N : Integer;
  a, m, j : Word;
begin
  S := grCalend.Cells[Col, Row];
  with grCalend.Canvas do begin
    if Row = 0 then
    begin	// Titres  (Center)
      Brush.Color := clBtnFace;
      FillRect(Rect);
      if Boolean(grCalend.Objects[Col, 0]) then
        N := DFCS_BUTTONPUSH or DFCS_FLAT
      else
        N := DFCS_BUTTONPUSH;
      DrawFrameControl(Handle, Rect, DFC_BUTTON, N);
      DrawText(Handle, PChar(S), Length(S), Rect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      if S = '0' then
        Brush.Color := clUltraLight
      else if Boolean(grCalend.Objects[Col, 0]) then
        if V_PGI.NumAltCol=0 then	  // Jour de la semaine ferm�
          Brush.Color := $00E8FFFF // ou clInfoBk ?
        else
          Brush.Color := AltColors[V_PGI.NumAltCol]
      else
        Brush.Color := clWindow;
      FillRect(Rect);

      InflateRect(Rect, -2, -2);
      if gdSelected in State then // MultiSelect et goRangeSelect False
        DrawFocusRect(Rect);

      {Sur une date}
      if S <> '0' then begin
        Rect.Top := Rect.Top +2;
        Font.Style := [fsBold];
        Font.Size := 16;
        N := Integer(grCalend.Objects[Col, Row]);

        {21/09/04 : FQ 10142 : Si les jours sont ferm�s (sachant que les jours ouvrables sont
                    stock�s comme ferm�s : ce qui les distinguent des jours r�ellement ferm�s,
                    c'est qu'ils ne sont ni des dimanche ni des jours f�ri�s)}
        {Si le jour est un un jour ferm� ou s'il appartient � une colonnes jours ferm�s}
        if (N >= $80) or Boolean(grCalend.Objects[Col, 0]) then begin
          {Reconstitution de la date en cours}
          a :=  StrToInt(spAnnee.Text);
          m := cbMois.ItemIndex + 1;
          j := StrToInt(S);

          {Il s'agit d'un dimanche ou d'un jour f�ri�}
          if (DayOfWeek(EncodeDate(a, m, j)) = 1) or ((N and $7F) > 0) then begin
            {Si colonne jours ferm�s et jour f�ri� et pas un dimanche => ouvrable ex : samedi 01/01/200X,
             sinon les dimanches et jours f�ri�s sont en rouge (ferm�)}
            if Boolean(grCalend.Objects[Col, 0]) and
               ((N and $7F) > 0) and
               (DayOfWeek(EncodeDate(a, m, j)) <> 1) then Font.Color := clOuvrable
                                                     else Font.Color := clCloseDay
          end
          else
            Font.Color := clOuvrable;
        end
        {Jours f�ri�s ouvr�s}
        else if N > 0 then
          Font.Color := clSpecialDay
        else {Jours ouvr�s}
          Font.Color := clWeekText;

        DrawText(Handle, PChar(S), Length(S), Rect, DT_CENTER or DT_TOP or DT_SINGLELINE);
        Font.Color := clWindowText; // Couleur texte par d�faut

        Font.Size := grCalend.Font.Size;
        Font.Style := [];
        if (N and $7F) > 0 then // F�ri�
        begin // Affiche le nom du jour
          Rect.Bottom := Rect.Bottom -1;
          S := cbJourFerie.Items[(N and $7F) -1];
          DrawText(Handle, PChar(S), Length(S), Rect, DT_CENTER or DT_BOTTOM or DT_SINGLELINE or DT_NOCLIP);
        end;
      end;
    end;
  end;
end;


Initialization
  registerclasses ( [ TOM_TRCALENDRIER ] ) ;
end.

