{***********UNITE*************************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Fiche vierge de saisie group�e des acomptes
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}
{
PT1 29/04/2004 SB V_50 FQ 11036 Int�gration des �l�ments graphiques, nom p�nom salari�
=== PH le 18/08/2004 Refonte du source pour g�rer correctement la saisie
=== Conservation d'une seule grille de saisie pour respecter l'ergonomie et simplifier
=== les contr�les et unifier(simplifier) le code.
PT2 12/10/2004 PH V_50 FQ 11529 Date de sortie et non date de l'acompte
PT3 12/10/2004 PH V_50 FQ 11529 Montant nul non trait�
PT4 10/01/2007 GG V_80 FQ 13404 Saisie des accomptes "par rubrique" : Gestion du
    copiers-coller depuis Excel
PT5 02/07/2007 MF V_72 FQ 14480 Ajout boutons Exporter la liste et Voir l�gende Excel    
}
unit UTofPG_AcompteGrp;

interface
uses
  {$IFDEF VER150}
  Variants,
  {$ENDIF}
  Classes,  SysUtils, StdCtrls, graphics, grids, windows,Dialogs, //PT5
{$IFNDEF EAGLCLIENT}
  //mul,
  FE_Main,  //PT5
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ELSE}
  HQry,
  Maineagl, //PT5
{$ENDIF}
  Utob, UTof, HmsgBox, Vierge, HTB97, Ed_tools, Hctrls, HEnt1, HXlsPas,ParamDat;    //PT5

type TCharTypeCol = (ctcString, ctcReal, ctcK, ctcDate, ctcUnknown);   //PT4

type
  TOF_PGACOMPTEGRP = class(TOF)
    procedure OnArgument(Arguments: string); override;
  private
    TheMul: TQUERY; // Query recuperee du mul
    GDAcompte: THGrid;
    TypeSaisie: string;
    Tob_Acompte: Tob;
    ListeError: TListBox;
    procedure PGGerereAcompteGroup(Sender: TObject);
    procedure PGGerereAcompteInd(Sender: TObject);
    function PgInitTob_Acompte(DateSaisie, Libelle, Montant, Areporter: string): Tob;
    function PGMaxOrdreAcompte(Salarie, DateSaisie, Rub: string): string;
    procedure ClickBtnRecopie(Sender: TObject);
    procedure GrillePostDrawCell(ACol, ARow: Longint; Canvas: TCanvas; AState: TGridDrawState);
    procedure GrilleCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GrilleCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GrilleDblClick(sender: TObject);
    procedure GrilleCellKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnExportClick(Sender: TObject); //PT5
    procedure BLegendeClick(Sender : TObject); //PT5

  end;

  function GrilleCopierColler(Grille : THGrid; NbrCollFigees : integer = -1) : String; //PT4


implementation
uses EntPaie, P5util;

{ TOF_PGMULACOMPTEGRP }

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Gestion du bouton RECOPIE
Suite ........ : Recopie la valeur de la cellule selectionn�e vers les cellules
Suite ........ :  du bas
Suite ........ : Colonne concern�e : DATESAISIE,LIBELLE,AREPORTER
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.ClickBtnRecopie(Sender: TObject);
var
  i: integer;
begin
  { Pour la colonne DATESAISIE, on v�rifie la validit� de la date saisie }
  if GDAcompte.Titres.Strings[GDAcompte.col] = 'DATESAISIE' then
  begin
    if (IsValidDate(GDAcompte.Cells[GDAcompte.col, GDAcompte.Row]) = True) then
    begin
      if GDAcompte.Row = GDAcompte.RowCount - 1 then exit;
      for i := GDAcompte.Row + 1 to GDAcompte.RowCount - 1 do
      begin
        GDAcompte.Cells[GDAcompte.Col, i] := GDAcompte.Cells[GDAcompte.Col, i - 1];
      end;
    end
    else
      PgiBox('Le format de la date n''est pas valide.', Ecran.caption);
  end
  else
    { On exclut la colonne Montant }
    if GDAcompte.Titres.Strings[GDAcompte.col] <> 'MONTANT' then
  begin
    if GDAcompte.Row = GDAcompte.RowCount - 1 then exit;
    for i := GDAcompte.Row + 1 to GDAcompte.RowCount - 1 do
      GDAcompte.Cells[GDAcompte.Col, i] := GDAcompte.Cells[GDAcompte.Col, i - 1];
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Gestion de l'entr�e en cellule
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.GrilleCellEnter(Sender: TObject; var ACol,
  ARow: Integer; var Cancel: Boolean);
begin
  { La colonne SALARIE et INTEGRER ne sont pas accessibles }
  if (GDAcompte.Titres.Strings[GDAcompte.col] = 'SALARIE') or (GDAcompte.Titres.Strings[GDAcompte.col] = 'INTEGRER') then
  begin
    if (GDAcompte.col = GDAcompte.ColCount - 1) then
    begin
      { En fin de ligne on se positionne au d�but de la ligne suivante }
      GDAcompte.col := 0;
      if (ARow <> GDAcompte.RowCount - 1) then
        GDAcompte.Row := GDAcompte.Row + 1;
    end
    else
      GDAcompte.Col := GDAcompte.Col + 1;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Gestion de la sortie de cellule
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.GrilleCellExit(Sender: TObject; var ACol,
  ARow: Integer; var Cancel: Boolean);
begin
  { V�rification de la validit� de la date saisie }
  if GDAcompte.Titres.Strings[Acol] = 'DATESAISIE' then
  begin
    if (IsValidDate(GDAcompte.Cells[Acol, ARow]) = False) AND (TypeSaisie = 'GRP') then
    begin
      PgiError('La date de l''acompte est invalide', Ecran.caption);
      cancel := TRUE;
    end;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Evenement Keydown
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.GrilleCellKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  K: Char;
begin
  { Affichage du calendrier sur les cellules DATESAISIE }
  if GDAcompte.Titres.Strings[GDAcompte.col] = 'DATESAISIE' then
    case Key of
      VK_SPACE:
        begin
          K := '*';
          ParamDate(Ecran, Sender, K);
        end;
    end;
  //PT4
  if (Key = 86) and (ssCtrl in Shift) then
    GrilleCopierColler(GDAcompte,1);
  //FinPT4
  //Key 46 : Suppr
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Ev�nement Dblclick
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.GrilleDblClick(sender: TObject);
var
  K: Char;
begin
  { Affichage du calendrier sur les cellules DATESAISIE }
  if GDAcompte.Titres.Strings[GDAcompte.col] = 'DATESAISIE' then
  begin
    K := '*';
    ParamDate(Ecran, Sender, K);
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Mise forme des cellules non accessibles
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.GrillePostDrawCell(ACol, ARow: Integer;
  Canvas: TCanvas; AState: TGridDrawState);
begin
  if ((Acol = 5) or (Acol = 0)) then GridGriseCell(GDAcompte, Acol, Arow, Canvas);
end;

procedure TOF_PGACOMPTEGRP.OnArgument(Arguments: string);
var
  BValider, Btn, BtnExport,BLegende: TToolBarButton97;   //PT5
  i: integer;
begin
  inherited;
  {TypeSaisie = IND pour Saisie individuelle }
  {TypeSaisie = GRP pour Saisie group�e }
  TypeSaisie := ReadTokenSt(Arguments);
  BValider := TToolBarButton97(GetControl('BValider'));

  if TFVierge(Ecran) <> nil then
  begin
{$IFDEF EAGLCLIENT}
    TheMul := THQuery(TFVierge(Ecran).FMULQ).TQ;
{$ELSE}
    TheMul := TFVierge(Ecran).FMULQ;
{$ENDIF}
  end;
  if not Assigned(TheMul) then exit;
  GDAcompte := THGrid(GetControl('GDACPIND'));
  if GDAcompte = nil then exit;
  if (GetControl ('TBTABGRP') <> NIL) then SetControlProperty('TBTABGRP', 'TabVisible', False);

// d PT5
  BtnExport := TToolbarButton97(GetControl('BEXPORTER'));
  if BtnExport <> nil then BtnExport.OnClick := BtnExportClick;
    BLegende := TToolBarButton97(GetControl('BLEGENDE'));
  If BLegende <> Nil then BLegende.OnClick := BLegendeClick;
// f PT5

  if TypeSaisie = 'GRP' then
  begin
    BtnExport.Visible := False; //PT5
    BLegende.Visible := False; //PT5
    { Param�trage de la grille en saisie group�e }
    if BValider <> nil then BValider.OnClick := PGGerereAcompteGroup;
    GDAcompte.RowCount := 2;
    GDAcompte.Cells[0, 1] := 'Pour tous les salari�s s�lectionn�s';
    Ecran.Caption := 'Saisie group�e des acomptes';
  end
  else
    if TypeSaisie = 'IND' then
  begin
    BtnExport.Visible := True; //PT5
    BLegende.Visible := True; //PT5
    { Param�trage de la grille en saisie individuelle }
    if BValider <> nil then BValider.OnClick := PGGerereAcompteInd;
    SetControlVisible('BTRECOPIE', True);
    Ecran.Caption := 'Saisie individuelle des acomptes';
    Btn := TToolBarButton97(GetControl('BTRECOPIE'));
    if Btn <> nil then Btn.OnClick := ClickBtnRecopie;
    GDAcompte.RowCount := TheMul.RecordCount + 1;
    TheMul.First;
    i := 0;
    while not TheMul.EOF do
    begin
      Inc(i);
      GDAcompte.Cells[0, i] := TheMul.FindField('PSA_SALARIE').AsString + ' - ' + RechDom('PGSALARIE', TheMul.FindField('PSA_SALARIE').AsString, False); { PT1 }
      TheMul.Next;
    end;
  end;
  GDAcompte.ColEditables[0] := False;
  GDAcompte.ColTypes[1] := 'D';
  GDAcompte.ColFormats[1] := ShortDateFormat;
  GDAcompte.ColLengths[2] := 35;
  GDAcompte.ColFormats[3] := 'CB=PGOUINON';
  GDAcompte.ColTypes[4] := 'R';
  GDAcompte.ColFormats[4] := '# ##0.00';
  GDAcompte.ColAligns[4] := TaRightJustify;
  GDAcompte.ColEditables[5] := False;
  GDAcompte.ColFormats[5] := 'CB=PGOUINONGRAPHIQUE'; { PT1 }
  GDAcompte.Titres.Clear;
  GDAcompte.Titres.Add('SALARIE');
  GDAcompte.Titres.Add('DATESAISIE');
  GDAcompte.Titres.Add('LIBELLE');
  GDAcompte.Titres.Add('AREPORTER');
  GDAcompte.Titres.Add('MONTANT');
  GDAcompte.Titres.Add('INTEGRER');
  { Gestionnaire d'�v�nement sur la grille }
  GDAcompte.PostDrawCell := GrillePostDrawCell;
  GDAcompte.OnCellExit := GrilleCellExit;
  GDAcompte.OnCellEnter := GrilleCellEnter;
  GDAcompte.OnCellEnter := GrilleCellEnter;
  GDAcompte.OnDblClick := GrilleDblClick;
  GDAcompte.OnKeyDown := GrilleCellKeyDown;
  GDAcompte.FixedRows := 1;
  GDAcompte.Col := 1 ;
  UpdateCaption (Ecran);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : G�n�ration des acomptes en saisie group�e
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}
procedure TOF_PGACOMPTEGRP.PGGerereAcompteGroup(Sender: TObject);
var
  Salarie, DateSaisie, Libelle, Areporter, Montant: string;
  I: Integer;
  LaGrille : THGrid;
begin
  if TheMul = nil then Exit;
  if TheMul.Eof then Exit;
  ListeError := TListBox(GetControl('LBERROR'));
  if ListeError = nil then exit;
  ListeError.Items.Clear;
  { Cr�ation de la tob des acomptes }
  Tob_Acompte := Tob.Create('HISTOSAISRUB', nil, -1);
  InitMoveProgressForm(nil, 'G�n�ration des acomptes...', 'Veuillez patienter SVP ...', TheMul.RecordCount, FALSE, TRUE);
  { Parcours de la grille }
  for i := 1 to GDAcompte.RowCount - 1 do
  begin
    { R�cup�ration des donn�es de la grille }
    DateSaisie := GDAcompte.CellValues[1, i];
    Libelle := GDAcompte.CellValues[2, i];
    Areporter := GDAcompte.CellValues[3, i];
    Montant := GDAcompte.CellValues[4, i];
    { V�rification de la validit� des donn�es }
    if (Trim(DateSaisie) = '') and (Trim(libelle) = '') and (Trim(Montant) = '') and (Trim(Areporter) = '') then
      Continue;
    if GDAcompte.CellValues[5, i] = '' then GDAcompte.CellValues[5, i] := 'NON'; { PT1 }
    if (IsValidDate(DateSaisie) = False) or (Trim(libelle) = '') or (isNumeric(Montant) = False) or (Trim(Areporter) = '') then
    begin
      ListeError.Items.Add('La ligne ' + IntToStr(i) + ' est incompl�te ou mal param�tr�e.');
      Continue;
    end;
    // DEB PT3
    if Valeur(Montant) = 0 then
    begin
      ListeError.Items.Add('Le montant de la ligne ' + IntToStr(i) + ' est nul.');
      Continue;
    end;
    // FIN PT3

    if GDAcompte.CellValues[5, i] = 'OUI' then Continue; { PT1 }

    { Parcours du multicrit�re }
    TheMul.First;
    while not TheMul.EOF do
    begin
      Salarie := TheMul.FindField('PSA_SALARIE').AsString;
      MoveCurProgressForm('Salari� : ' + Salarie);
      { Cr�ation de l'acompte par salari� via tob }
      PgInitTob_Acompte(DateSaisie, Libelle, Montant, Areporter);
      TheMul.Next;
    end;
    GDAcompte.CellValues[5, i] := 'OUI'; { PT1 }
  end; //Fin For
  MoveCurProgressForm('Mise � jour des donn�es.');
  { Mise � jour de la tob }
  Tob_Acompte.InsertOrUpdateDB;
  FreeAndNil(Tob_Acompte);
  FiniMoveProgressForm;
  PgiInfo('Traitement termin�.', Ecran.caption);
  SetControlEnabled ('BVALIDER', FALSE);
  LaGrille := THGrid (GetControl ('GDACPIND'));
  if LaGrille <> NIL then LaGrille.Options := LaGrille.Options - [goEditing];
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : G�n�ration des acomptes en saisie individuelle
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

procedure TOF_PGACOMPTEGRP.PGGerereAcompteInd(Sender: TObject);
var
  Salarie, DateSaisie, Libelle, Areporter, Montant: string;
  T_Acompte: Tob;
  I: Integer;
  Trouve: Boolean;
  LaGrille : THGrid;
begin
  ListeError := TListBox(GetControl('LBERROR'));
  if ListeError = nil then exit;
  ListeError.Items.Clear;
  { Cr�ation de la tob des acomptes }
  Tob_Acompte := Tob.Create('HISTOSAISRUB', nil, -1);
  InitMoveProgressForm(nil, 'G�n�ration des acomptes...', 'Veuillez patienter SVP ...', TheMul.RecordCount, FALSE, TRUE);
  { Parcours de la grille de saisie }
  for i := 1 to GDAcompte.RowCount - 1 do
  begin
    { R�cup�ration des donn�es de la grille }
    Salarie := Copy(GDAcompte.CellValues[0, i], 1, 10); { PT1 }
    DateSaisie := GDAcompte.CellValues[1, i];
    Libelle := GDAcompte.CellValues[2, i];
    Areporter := GDAcompte.CellValues[3, i];
    Montant := GDAcompte.CellValues[4, i];
    if GDAcompte.CellValues[5, i] = '' then GDAcompte.CellValues[5, i] := 'NON'; { PT1 }
    { V�rification de la validit� des donn�es }
    if (Trim(DateSaisie) = '') and (Trim(libelle) = '') and (Trim(Montant) = '') and (Trim(Areporter) = '') then
      Continue;
    if (IsValidDate(DateSaisie) = False) or (Trim(libelle) = '') or (isNumeric(Montant) = False) or (Trim(Areporter) = '') then
    begin
      ListeError.Items.Add('La ligne du salari� ' + Salarie + ' est incompl�te ou mal param�tr�e.');
      Continue;
    end;

    if GDAcompte.CellValues[5, i] = 'OUI' then Continue; { PT1 }

    T_Acompte := nil;
    { Parcours du multicrit�re }
    TheMul.First;
    Trouve := False;
    while not TheMul.EOF do
    begin
      if Salarie = TheMul.FindField('PSA_SALARIE').AsString then
      begin
        MoveCurProgressForm('Salari� : ' + Salarie);
        { Cr�ation de l'acompte par salari� via tob }
        T_Acompte := PgInitTob_Acompte(DateSaisie, Libelle, Montant, Areporter);
        Trouve := True;
      end;
      TheMul.Next;
    end;
    if not trouve then ListeError.Items.Add('Le salari� ' + Salarie + ' n''est pas pr�sent dans la liste de selection.')
    else if Assigned(T_Acompte) then GDAcompte.CellValues[5, i] := 'OUI'; { PT1 }
  end; //End For;
  MoveCurProgressForm('Mise � jour des donn�es.');
  { Mise � jour de la tob }
  Tob_Acompte.InsertOrUpdateDB;
  FreeAndNil(Tob_Acompte);
  FiniMoveProgressForm;
  PgiInfo('Traitement termin�.', Ecran.caption);
  SetControlEnabled ('BVALIDER', FALSE);
  LaGrille := THGrid (GetControl ('GDACPIND'));
  If LaGrille <> NIL then LaGrille.Options := LaGrille.Options -[goEditing];
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Initialisation de la tob fille des acomptes g�n�r�s
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

function TOF_PGACOMPTEGRP.PgInitTob_Acompte(DateSaisie, Libelle, Montant, Areporter: string): Tob;
var
  TypeRegle, Salarie: string;
begin
  { Affectation des champs de la table }
  Result := nil;
  Salarie := TheMul.FindField('PSA_SALARIE').AsString;
  if TheMul.FindField('PSA_DATEENTREE').AsDateTime > StrToDate(DateSaisie) then
  begin
    ListeError.Items.Add('Le salari� ' + Salarie + ' n''est pas entr�e au ' + DateSaisie + '.');
    exit;
  end;
  if (TheMul.FindField('PSA_DATESORTIE').AsDateTime > idate1900) and (TheMul.FindField('PSA_DATESORTIE').AsDateTime <> NULL) and
    (TheMul.FindField('PSA_DATESORTIE').AsDateTime < StrToDate(DateSaisie)) then
  begin // PT2
    ListeError.Items.Add('Le salari� ' + Salarie + ' est sorti au ' + DateToStr(TheMul.FindField('PSA_DATESORTIE').AsDateTime) + '.'); { PT1 }
    Exit;
  end;
  Result := Tob.Create('HISTOSAISRUB', Tob_Acompte, -1);
  Result.PutValue('PSD_ORIGINEMVT', 'ACP');
  Result.PutValue('PSD_SALARIE', Salarie);
  Result.PutValue('PSD_DATEDEBUT', StrToDate(DateSaisie));
  Result.PutValue('PSD_DATEFIN', StrToDate(DateSaisie));
  Result.PutValue('PSD_RUBRIQUE', VH_Paie.PgRubAcompte);
  Result.PutValue('PSD_ORDRE', PGMaxOrdreAcompte(Salarie, DateSaisie, VH_Paie.PgRubAcompte));
  Result.PutValue('PSD_LIBELLE', Libelle);
  Result.PutValue('PSD_RIBSALAIRE', '');
  Result.PutValue('PSD_BANQUEEMIS', '');
  if TheMul.FindField('PSA_TYPPAIACOMPT').AsString = 'ETB' then
    TypeRegle := TheMul.FindField('ETB_PAIACOMPTE').AsString
  else
    TypeRegle := TheMul.FindField('PSA_PAIACOMPTE').AsString;
  if TypeRegle = '008' then
  begin
    Result.PutValue('PSD_TOPREGLE', '-');
    Result.PutValue('PSD_DATEPAIEMENT', idate1900);
  end
  else
  begin
    Result.PutValue('PSD_TOPREGLE', 'X');
    Result.PutValue('PSD_DATEPAIEMENT', StrToDate(DateSaisie));
  end;
  Result.PutValue('PSD_ETABLISSEMENT', TheMul.FindField('PSA_ETABLISSEMENT').AsString);
  Result.PutValue('PSD_TYPALIMPAIE', '');
  Result.PutValue('PSD_BASE', 0);
  Result.PutValue('PSD_TAUX', 0);
  Result.PutValue('PSD_COEFF', 0);
  Result.PutValue('PSD_MONTANT', Valeur(Montant));
  Result.PutValue('PSD_DATEINTEGRAT', idate1900);
  Result.PutValue('PSD_DATECOMPT', idate1900);
  Result.PutValue('PSD_AREPORTER', Areporter);
  Result.PutValue('PSD_CONFIDENTIEL', TheMul.FindField('PSA_CONFIDENTIEL').AsString);
  Result.PutValue('PSD_TOPCONVERT', '-');
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Recherche du max num�ro d'ordre d'enregistrement de cl�
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}

function TOF_PGACOMPTEGRP.PGMaxOrdreAcompte(Salarie, DateSaisie, Rub: string): string;
var
  Q: TQuery;
begin
  Q := OpenSql('SELECT MAX(PSD_ORDRE) AS ORDRE FROM HISTOSAISRUB ' +
    'WHERE PSD_SALARIE="' + Salarie + '" ' +
    'AND PSD_RUBRIQUE="' + Rub + '" ' +
    'AND PSD_ORIGINEMVT="ACP" ' +
    'AND PSD_DATEDEBUT="' + USDateTime(StrToDate(DateSaisie)) + '"', True);
  if not Q.eof then Result := IntToStr(Q.FindField('ORDRE').AsInteger + 1)
  else Result := '1';
  Ferme(Q);
end;

//PT4
{***********A.G.L.***********************************************
Auteur  ...... : GGU
Cr�� le ...... : 10/01/2007
Modifi� le ... :
Description .. : Reprise et adaptation de la fonction Copier/Coller de la 
Suite ........ : saisie par rubrique (UTofPG_SAISRUB).
Suite ........ : Les colonnes fig�es sont les colonnes auxquelles l'utilisateur
Suite ........ : n'a pas acc�s, au d�but du tableau (� gauche) qui permettent
Suite ........ : d'indiquer le salari� concern� par la ligne du tableau
Mots clefs ... : Copier;Coller;THGrid
*****************************************************************}
function GrilleCopierColler(Grille : THGrid; NbrCollFigees : integer) : String;
var
  T, TT: TOB;
  i, j, k, NbreCol, LstErrorL, LstErrorP: integer;
  St, Salarie, StVar: string;
  LeVar: Variant;
  TitreCol: array[1..35] of string;
  SavGrilleOptions : TGridOptions;
  
  function CharToTypeCol(C : Char) : TCharTypeCol;
  begin
    if C = 'S' then result := ctcString
    else if C = 'R' then result := ctcReal //Pr�cision � 2 chiffres apr�s la virgule
    else if C = 'K' then result := ctcK  //Pr�cision � 5 chiffres apr�s la virgule
    else if C = 'D' then result := ctcDate
    else result := ctcUnknown;
  end;
  
  function GrilleIdentSalarie(Salarie: string; Grille : THGrid): Integer;
  var
    i: Integer;
  begin
    result := -1;
    for i := 1 to Grille.RowCount - 1 do
    begin
    if VH_PAie.PgTypeNumSal = 'NUM' then
      begin
        if Valeur(Salarie) = Valeur(Grille.Cells[0, i]) then
        begin
          Result := i;
          break;
        end;
      end
    else
      begin
        if Grille.Cells[0, i] = Salarie then
        begin
          Result := i;
          break;
        end;
      end;
  end;
  end;

begin
  if NbrCollFigees = -1 then
  begin
    NbrCollFigees := Grille.FixedCols;
  end;
  LstErrorL := 0;
  LstErrorP := 0;
  Try
    T := TOBLoadFromClipBoard;
    T.Detail[0].Free;
  Except
    PGIBox('Erreur lors de la lecture du presse-papiers.');
    Grille.Options := SavGrilleOptions;
    Exit;
  End;
  NbreCol := Grille.ColCount - NbrCollFigees;
  for i := 1 to 35 do TitreCol[i] := '';
  for i := 1 to 35 do
  begin
    if i > NbreCol then break;
    // Les espaces des libell�s de colonnes du PGI sont remplac� par des _ pour la recherche
    // du nom de colonne d�fini dans Excel (l'espace est interdit � ce niveau dans Excel)
    // Par exemple, une colonne nom�e "Date de sortie" dans le masque correspondra � une colonne
    // "Date_de_sortie" dans Excel.
    TitreCol[i] := StringReplace(Grille.Cells[i - 1 + NbrCollFigees, 0],' ','_',[rfReplaceAll]);
  end;
  for i := 0 to T.Detail.Count - 1 do
  begin
    TT := T.Detail[i];
    LeVar := TT.GetValue('Matricule');
    Salarie := VarToStr(LeVar);
    k := GrilleIdentSalarie(Salarie,Grille);
    if k = -1 then LstErrorL := LstErrorL + 1;
    if (k > 0) and (k < Grille.RowCount) then
    begin // Boucle sur les lignes de la TOB
      for j := 1 to 35 do
      begin // Boucle sur les colonnes de la grille qui correspondent aux colonnes de la feuilles EXCEL
        st := TitreCol[j];
        if TT.FieldExists(TitreCol[j]) then
          StVar := TT.GetString(TitreCol[j])
        else StVar := '';
        if StVar <> '' then // colonne identifi�e
        begin
          case CharToTypeCol(Grille.ColTypes[j - 1 + NbrCollFigees]) of
            ctcReal  : begin
              if IsNumeric(StVar) then
                Grille.Cells[j - 1 + NbrCollFigees, k] := DoubleToCell( Valeur(StVar), 2 )
              else
                LstErrorP := LstErrorP + 1;
            End;
            ctcK  : begin
              if IsNumeric(StVar) then
                Grille.Cells[j - 1 + NbrCollFigees, k] := DoubleToCell( Valeur(StVar), 5 )
              else
                LstErrorP := LstErrorP + 1;
            End;
            ctcDate    : begin
             { On test si le format date est valide pour g�rer les cas o� la colonne Excel est
               mise en format date (la chaine de caract�res de la date est renvoy�e par Excel)
               et
               On test si le format est num�rique pour g�rer les cas o� la colonne Excel est
               mise en format standard (Excel stock un entier dans le presse-papier (meme
               gestion que Delphi : 1 = 01/01/1900, 2= 02/01/1900...  )
             }
              if (IsValidDate(StVar)) or (IsNumeric(StVar)) then
                Grille.Cells[j - 1 + NbrCollFigees, k] := AGLDateToStr( TT.GetDateTime(TitreCol[j]))
              else
                LstErrorP := LstErrorP + 1;
            End;
            ctcString  : begin
              Grille.Cells[j - 1 + NbrCollFigees, k] := StVar;
            end;
            ctcUnknown : begin
              Grille.Cells[j - 1 + NbrCollFigees, k] := StVar;
            end;
          end;
        end;
      end;
    end;
  end;
  T.Free;
  St := 'Attention,'#13#10;
  if LstErrorL > 0 then St := St + IntTOstr(LstErrorL) + ' ligne(s)';
  if (LstErrorL > 0) and (LstErrorP > 0) then St := St + ' et ';
  if LstErrorP > 0 then St := St + IntTOstr(LstErrorP) + ' cellule(s)';
  if (LstErrorL > 0) or (LstErrorP > 0) then PGIBox(St + ' n''ont pas �t� int�gr�es');//Ecran.Caption);
  Result := St;
end;

//FinPT4

{ d PT5 : Export de la grille }
procedure TOF_PGACOMPTEGRP.BtnExportClick(Sender: TObject);
var
  Grille: ThGrid;
  SD: TSaveDialog;
begin
  Grille := ThGrid(GetControl('GDACPIND'));
  if Grille = nil then exit;
  SD := TSaveDialog.Create(nil);
  SD.Filter := 'Fichier Excel (*.xls)|*.xls';
  if SD.Execute then
  begin
    //Fichier Excel (*.xls)|*.xls|  SD.FilterIndex = 1
    if (SD.FilterIndex = 1) and (Pos('.xls', SD.FileName) < 1) then
      SD.FileName := Trim(SD.FileName) + '.xls';
    ExportGrid(Grille, nil, SD.FileName, SD.FilterIndex, True);
  end;
  SD.Destroy;
end;

{Voir l�gende Excel}
procedure TOF_PGACOMPTEGRP.BLegendeClick(Sender : TObject);
begin
  AGLLanceFiche('PAY','HISTOGROUPEELEG','','','ACOMPTE_GRP');
end;

{ f PT5 }


initialization
  registerclasses([TOF_PGACOMPTEGRP]);
end.

