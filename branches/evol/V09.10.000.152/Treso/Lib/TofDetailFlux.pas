{-------------------------------------------------------------------------------------
   Version    |  Date  | Qui | Commentaires
--------------------------------------------------------------------------------------
               20/03/02  BT   Cr�ation de l'unit�
 1.20.001.001  08/03/04  JP   Autoriser la suppression d'�critures non r�alis�es FQ 10010
 1.2X.000.001  15/04/04  JP   Nouvelle gestion des natures (R, S, P, "" ?)
 1.90.xxx.xxx  25/06/04  JP   Cr�ation de l'impression de la Grille FQ 10100
 1.90.xxx.xxx  29/06/04  JP   Affichage de la date Valeur/Op�ration dans la Grille FQ 10100
 6.xx.xxx.xxx  20/07/04  JP   Gestion des commissions dans la r�alisation et l'int�gration
 6.xx.xxx.xxx  30/07/04  JP   Appel depuis la fiche de suivi des commissions
 6.00.018.002  14/10/04  JP   Gestion de l'affichage des �critures point�es pour le solde bancaire
 6.30.001.006  05/04/05  JP   FQ 10240 : Correction de la requ�te sur les �critures du suivi bancaire
 6.30.001.007  18/04/05  JP   FQ 10237 : Gestion de la p�riodicit� sur les fiches de suivi
                              M�nage dans le OnArgument qui devenait illisible
 6.50.001.018  14/09/05  JP   FQ 10282 : Ajout d'une protection lors de la d�finition du range pour
                              appeler la tom TRECRITURE et le lancement des traitements
 6.50.001.020  29/09/05  JP   FQ 10296 : On ne tenait pas compte du g�n�ral pass� en param�tre lors de l'appel
                              de la fiche car il y avait un doublon entre les variables General et FGeneral
 6.50.001.021  03/10/05  JP   FQ 10277 : En d�tail des commissions, on remplace le g�n�ral par
                              le code flux.
 6.51.001.001  30/11/05  JP   FQ 10303 : Sur le suivi des commission, la jointure sur TE_NUMEROPIECE est de trop
 7.01.001.001  23/03/06  JP   Gestion de TE_NODOSSIER
 7.09.001.001  18/09/06  JP   Mise en place de l'int�gration Multi-soci�t�s
 7.09.001.001  31/10/06  JP   FQ 10338 : Dans le pr�visionnel on affiche les non point�es et les point�es
                              ult�rieurement => affichage de la date de rappro
 7.06.001.002  11/01/07  JP   FQ 10399 : plantage sur le changement des dates de valeurs (Clevaleur n'est plus
                              la derni�re colonne depuis qu'il y a le NoDossier) +
                              On d�sactive le bouton si on est en date de valeur, comme c'est fait pour le popup
                              car en date d'op�ration, on n'a pas la clef dans la requ�te
 8.01.001.001  12/12/06  JP   Ajout du contr�le des soldes
 8.00.001.019  10/06/07  JP   FQ 10432 : gestion de l'appel depuis les �chelles d'int�r�ts
 8.00.001.021  20/06/07  JP   FQ 10480 : gestion des concepts
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
 8.10.001.013  09/10/07  JP   FQ 10522 : Corrections du contr�le des soldes.
                              branchement de l'objet �tat pour l'impression de l'�cran.
--------------------------------------------------------------------------------------}
unit TofDetailFlux ;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  Controls, Classes, Commun, Constantes, HQry, HMsgBox,
  {$IFDEF EAGLCLIENT}
  MaineAGL, UtileAgl,
  {$ELSE}
  FE_Main, db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} EdtREtat,
  {$ENDIF}
  Forms, SysUtils, HCtrls, HEnt1, UTOF, Grids, UTOB, Menus, ParamSoc,
  ULibPieceCompta, HStatus;

type
  TOF_DETAILFLUX = class (TOF)
    procedure OnArgument (S : string); override;
    procedure OnClose                ; override;
  private
    FAppelant  : TDescendant;
    FPeriode   : TypePeriod;
    FDateDeb   : TDateTime;
    FDateFin   : TDateTime;
    FDateModif : TDateTime;
    FGeneral   : string;
    FNature    : string;
    FDateOpe   : string;
    RequeteSQL : string;
    TobArgument: TOB;

    function  SetFVariables     : Boolean;
    function  GetFiltreDossier  : string;
    procedure SetAppelant       (Value : string);
    procedure SetPeriode        (Value : string);
    procedure GererDetailTreso  (Arg : string);
    procedure InitVariable      ;
    procedure PrepareRequete    ;
    procedure PrepareRequeteCtrl; {12/12/06 : Contr�le des soldes}
  protected
    TREcritureModified : string;
    PopupMenu : TPopUpMenu;
    Grid      : THGrid;
    FinMois   : string;
    {29/09/05 : FQ 10296 : c'etait en doublon avec FGeneral
     General   : string; {Compte g�n�ral sur lequel on est}
    Regle     : TReglesInteg;
    TobGrid   : TOB;
    TobGen    : TobPieceCompta;
    EchelleOk : Boolean; {10/06/07 : FQ 10432}
    WhereConf : string; {10/08/07 : Gestion des confidentialit�s}

    procedure OnPopUpMenu           (Sender : TObject);
    procedure PopupRealiseOnClick   (Sender : TObject);
    procedure PopupChangeDateOnClick(Sender : TObject);
    procedure ToutSelectionner      (Sender : TObject);
    procedure ToutDeSelectionner    (Sender : TObject);
    {JP 16/09/03 : Saisie d'�critures de simulation}
    procedure PopupSimulation       (Sender : TObject);
    procedure BImprimerClick        (Sender : TObject);
    procedure ListeOnDbleClick      (Sender : TObject);
    procedure ListeOnDbleClickCP    (Sender : TObject); {12/12/06 : Affichage de la ligne comptable}
    procedure ListeOnDbleClickBQ    (Sender : TObject); {09/10/07 : Affichage de la ligne EEXBQLIG}
    {JP 08/03/04 : Suppression des �critures non r�alis�es}
    procedure BDeleteClick          (Sender : TObject);
    {JP 20/11/03 : pour interdir la s�lection des �critures r�alis�es}
    procedure ListeOnBeforeFlip     (Sender : TObject ; ARow : Integer ; Var Cancel : Boolean);

    {JP 28/08/03 : Int�gration en comptabilit�}
    procedure IntegreCompta;
    procedure PrepareEcriture(NumTransac, NumPiece : string);

    {20/04/05 : M�thodes appel�es dans le Onargument}
    procedure GestionControls  ;
    procedure GestionBoutons   (VisibleOk : Boolean = True); {10/06/07 : FQ 10432 : ajout du param�tre}
    procedure PrepareGrille    (Dev : string);
    procedure PrepareGrilleCtrl(Dev : string);
    procedure MajCaptionForm   ;
  end;

function TRLanceFiche_DetailFlux(Dom, Fiche, Range, Lequel, Arguments: string): string;
function InitTobPourDetail : TOB;

implementation

uses
  {$IFDEF TRCONF}
  ULIbConfidentialite,
  {$ENDIF TRCONF}
  HTB97, ParamDat, Vierge, TRSAISIEFLUX_TOF, UProcCommission, UProcEcriture, UProcGen,
  UProcSolde, UtilPgi, TRLIGNEECRCOMPTA_TOF, UlibPointage, uObjEtats, EEXBQLIG_TOM, AglInit;

const
  COL_DATEAFF  = 0;
  COL_NATURE   = 1;
  COL_COMPTE   = 2; // Colonne Compte / Code flux
  COL_NUMPIECE = 3;
  COL_TRANSAC  = 4;
  COL_CIB      = 5;
  COL_LIBELLE  = 6;
  COL_DEVISE   = 7;
  COL_MONTANT  = 8;
  COL_NUMLIGNE = 10;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_DetailFlux(Dom, Fiche, Range, Lequel, Arguments: string): string;
{---------------------------------------------------------------------------------------}
begin
  Result := AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
function InitTobPourDetail : TOB;
{---------------------------------------------------------------------------------------}
begin
  Result := TOB.Create('$���', nil, -1);
  Result.AddChampSupValeur('CODE'    , '');
  Result.AddChampSupValeur('GENERAL' , '');
  Result.AddChampSupValeur('NATURE'  , '');
  Result.AddChampSupValeur('APPEL'   , '');
  Result.AddChampSupValeur('PERIODICITE', '');
  Result.AddChampSupValeur('DATEDEB' , iDate1900);
  Result.AddChampSupValeur('DATEFIN' , iDate1900);
  Result.AddChampSupValeur('DATEOPE' , '');
  Result.AddChampSupValeur('DATEAFF' , '');
  Result.AddChampSupValeur('LIBELLE' , '');
  Result.AddChampSupValeur('LIBNAT'  , '');
  Result.AddChampSupValeur('MOIS'    , '');
  Result.AddChampSupValeur('TYPE'    , '');
  Result.AddChampSupValeur('DEVISE'  , '');
  Result.AddChampSupValeur('REGROUP' , '');
  Result.AddChampSupValeur('INTERVAL', '');
  Result.AddChampSupValeur('BANQUE'  , '');
  Result.AddChampSupValeur('NOMBASE' , ''); {12/12/06 : contr�le des soldes}
  Result.AddChampSupValeur('LEFTJOIN', ''); {10/06/07 : FQ 10432}
  Result.AddChampSupValeur('WHERE'   , ''); {10/06/07 : FQ 10432}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.OnArgument (S : string ) ;
{---------------------------------------------------------------------------------------}
var
  S1 : string;
begin
  inherited;
  Ecran.HelpContext := 150;
  {Initialisation des variables de traitement}
  InitVariable;
  {R�cup�ration de la fiche appelante}
  SetAppelant(ReadTokenSt(S));
  {20/04/05 : Gestion des Contr�les autres que les boutons}
  GestionControls;

  {R�cup�ration du type de p�riodicit�}
  {Le suivi du tr�sorier est trop diff�rent pour �tre g�rer d'une mani�re standard}
  if FAppelant = dsTreso then begin
    GererDetailTreso(S);
    Exit;
  end
  else begin
    SetPeriode(TobArgument.GetString('PERIODICITE'));
    SetFVariables;
  end;

  {10/06/07 : FQ 10432 : gestion de l'appel depuis les �chelles d'int�r�ts}
  EchelleOk := ReadTokenSt(S) = 'ECHINT';

  {Pr�paration de la requ�te}
  PrepareRequete;
  TobGrid.LoadDetailDBFromSQL('1', RequeteSQL);
  {Th�oriquement le r�sultat de l requ�te ne renvoie qu'une m�me devise}
  if TobGrid.Detail.Count > 0 then
    S1 := TobGrid.Detail[0].GetString('TE_DEVISE');

  TobGrid.PutGridDetail(Grid, False, False, '', True);
  {20/04/05 : Dessin de la grille}
  PrepareGrille(S1);
  {20/04/05 : Gestion des boutons
   10/06/07 : FQ 10432 : gestion de l'appel depuis les �chelles d'int�r�ts}
  EchelleOk := ReadTokenSt(S) = 'ECHINT';
  GestionBoutons(not EchelleOk);
  {20/04/05 : Mise � jour tu titre de la forme}
  MajCaptionForm;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.OnClose ;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobGrid) then FreeAndNil(TobGrid);
  if Assigned(TobGen ) then FreeAndNil(TobGen);

  TFVierge(Ecran).Retour := TREcritureModified;

  if FDateModif < iDate2099 then
    TFVierge(Ecran).Retour := DateToStr(FDateModif - 1); // La veille, pour recalcul des soldes
  inherited;
end ;

{Pr�pare le menu popup
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.OnPopupMenu(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if PopupMenu.Items.Count = 0 then Exit;

  {Les simulations de virements ne peuvent �tre pass�es qu'en "V" lors de la g�n�ration du virement li�}
  PopupMenu.Items[0].Enabled := (Grid.nbSelected > 0   )  and
                                (Pos('"' + na_Realise   + '"', FNature) = 0) and
                                {JP 15/04/04 : les �critures de l'�ch�ancier sont modifiables
                                (Pos('"' + na_ImpCompta + '"', Nature) = 0) and}
                                {Il faut les droits pour injecter en compta}
                                V_PGI.Superviseur; // ?
  PopupMenu.Items[1].Enabled := (Grid.nbSelected > 0) and (FDateOpe = 'TE_DATEVALEUR');
  {JP 08/03/04 : FQ 10010 : mise en place de la suppression}
  PopupMenu.Items[3].Enabled := (Grid.nbSelected > 0);
end;

{21/07/04 : on ne traite plus que les �critures de saisie ; ancien code en fin d'unit�
 Passe les lignes d'�critures s�lectionn�es � r�alis�
 Rappel     : Les lignes d'�critures sont d�finies par un Num�ro de transaction,
              un num�ro de pi�ce et un mum�ro de ligne
 Les �tapes :
    1/ Il faut que les �critures de la transaction dont le num�ro de ligne est inf�rieur �
       celui que de la ligne en cours soient d�j� r�alis�es
    2/ Si c'est le cas, on "r�alise" la ligne en cours
    3/ On regarde si la transaction de le ligne en cours a encore des �critures non r�alis�es
    4/ Si ce n'est pas le cas, on d�noue la transaction et on propose l'int�gration en compta
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PopupRealiseOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  I : Integer;
  N : string;
  Ok : Boolean;
begin
  if Grid.nbSelected = 0 then begin
    MessageAlerte('Veuillez s�lectionner des �critures.');
    Exit;
  end;

  Ok := False;

  if trShowMessage(Ecran.Caption, 20, '', '') = mrYes then begin
    InitMove(Grid.nbSelected, 'R�alisation des �critures');
    for I := Grid.RowCount - 1 downto 1 do begin
      Movecur(False);
      {On ne traite que les lignes s�lectionn�es qui sont pr�visionnelles}
      if Grid.IsSelected(I) and (Grid.Cells[COL_NATURE, I] = na_Prevision) and
         {21/07/04 : on ne traite plus que les �critures de saisie}
         (Pos(TRANSACSAISIE, UpperCase(Grid.Cells[COL_TRANSAC, I])) >= 0) then begin

        N := TOB(Grid.Objects[0, I]).GetValue('TE_NUMLIGNE');

        {On passe toute l'�criture � r�alis�, op�ration et commissions
         14/09/05 : FQ 10282 : Ajout de Trim et de FloatToStr(Valeur()), car il semble qu'il y ait
                               maintenant un formatage automatique des zones}
        UpdatePieceStr(TOB(Grid.Objects[0, I]).GetString('TE_NODOSSIER'), Trim(Grid.Cells[COL_TRANSAC, I]),
                       FloatToStr(ValeurI(Grid.Cells[COL_NUMPIECE, I])), '', 'TE_NATURE', na_Realise);

        {Int�gration en comptabilit�}
        if (GetParamSocSecur('SO_TRINTEGAUTO', False) = True)  or OK or
           (HShowMessage('0;Int�gration en comptabilit�;Voulez-vous int�grer' +
                        ' en comptabilit� les lignes de la transaction ?;Q;YN;N;N;', '', '') = mrYes) then begin
          Ok := True;

          {De m�me, on int�gre toute la pi�ce en comptabilit�
           14/09/05 : FQ 10282 : Ajout de Trim et de FloatToStr(Valeur()), car il semble qu'il y ait
                                 maintenant un formatage automatique des zones}
          PrepareEcriture(Trim(Grid.Cells[COL_TRANSAC, I]), FloatToStr(ValeurI(Grid.Cells[COL_NUMPIECE, I])));

          {Si les �critures affich�es n'�taient pas filtr�es}
          if (FNature = '') or (Pos(na_Realise, FNature) > 0) then
            {On passe la nature � r�alis�}
            Grid.Cells[COL_NATURE, I] := na_Realise
          else
            {Sinon, on supprime la ligne}
            Grid.DeleteRow(I);

          TREcritureModified := na_Realise;
        end;
      end;
    end;
    FiniMove;
    if Ok and AutoriseFonction(dac_Integration) then IntegreCompta;
    Grid.ClearSelected;
  end;
end;

{Mise � jour de la date uniquement dans le cas d'un traitement par date de valeur
 Il faut aussi mettre � jour la CleValeur qui est compos�e de la date et d'un num�ro unique
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PopupChangeDateOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  C     : Char;
  aDate : THEdit;
  I     : Integer;
  D1, D2: TDateTime;
  Clef  : string;
  dtTemp: string;
begin
  if Grid.nbSelected = 0 then begin
    MessageAlerte('Veuillez s�lectionner des �critures.');
    Exit;
  end;

  dtTemp := TobArgument.GetString('DATEDEB');
  D2 := StrToDate(dtTemp);

  aDate := THEdit.Create(Ecran);
  // aDate.OpeType := otDate; ?
  aDate.Parent := Grid; // Grid.ClientOrigin
  aDate.Left := 100;
  aDate.Top := 12;
  aDate.Visible := False;
  aDate.Text := dtTemp;
  C := ' ';
  try
    ParamDate(Ecran, aDate, C);
    if aDate.Text <> dtTemp then {123456}
      if trShowMessage(Ecran.Caption, 20, '', '') = mrYes then
        for I := Grid.RowCount-1 downto 1 do
          {On balaie les lignes selectionn�es}
          if Grid.IsSelected(I) then begin
            D1 := StrToDate(aDate.Text);
            {11/01/07 : FQ 10399 : ColCount - 2, car maintenant ColCount - 1 est pour no Dossier}
            Clef := RetourneCleEcriture(D1, StrToInt(Copy(Grid.Cells[Grid.ColCount - 2, I], 7, 7)));
            ExecuteSQL('UPDATE TRECRITURE SET TE_DATEVALEUR = "' + UsDateTime(D1) + '", TE_CLEVALEUR = "' +
                       Clef + '" WHERE TE_CLEVALEUR = "' + Grid.Cells[Grid.ColCount - 2, I] + '"');
            {20/11/06 : �ventuel recalcul des soldes si la date change de mill�sime}
            GereSoldeInitClef(Grid.Cells[Grid.ColCount - 2, I], Clef,
                             TobArgument.GetString('GENERAL'), Valeur(Grid.Cells[COL_MONTANT + 1, I]), False);  
            {Pour �viter des effets de bords, on d�selectionne la ligne}
            Grid.FlipSelection(I);
            {On efface la ligne si elle n'appartient plus � la fourchette de dates}
            if not Between(StrToDate(aDate.Text), FDateDeb, FDateFin) then
              Grid.DeleteRow(I);
            {Sauve la date mini de modif du solde}
            if D1 < D2 then begin
              if D1 < FDateModif then
                FDateModif := D1;
            end
            else if D2 < FDateModif then
              FDateModif := D2;
          end;
  finally
    aDate.Free;
  end;
end;

{JP 16/09/03 : Lancement de l'�cran de saisie des �critures de simulation
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PopupSimulation(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  {29/09/05 : FQ 10296 : General etait en doublon avec FGeneral}
  TREcritureModified := TRLanceFiche_SaisieFlux('TR', 'TRSAISIEFLUX', '', '', FGeneral + ';');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PrepareEcriture(NumTransac, NumPiece : string);
{---------------------------------------------------------------------------------------}
var
  tEcr : TOB;
  S    : string;
begin
  {Cr�ation de la requ�te contenant les �critures � int�grer}
  S := 'SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + NumTransac + '" AND TE_NUMEROPIECE = "' + NumPiece +
       '" AND (TE_USERCOMPTABLE = "" OR TE_USERCOMPTABLE IS NULL) ORDER BY TE_NUMLIGNE';

  tEcr := TOB.Create('���', nil, -1);
  try
    tEcr.LoadDetailFromSQL(S);
    {S'il n'y a pas d'�critures pour la transaction !!?}
    if tEcr.Detail.Count = 0 then Exit;
    {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
    TRGenererPieceCompta(TobGen, tEcr);
  finally
    if Assigned(tEcr) then FreeAndNil(tEcr);
  end;
end;

{JP 28/08/03 : Int�gration en compta d'une transaction d�nou�e lors de la r�alisation
               d'une �criture
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.IntegreCompta;
{---------------------------------------------------------------------------------------}
begin
  {Par pr�caution, th�oriquement arriv� ici, la tob ne peut �tre vide}
  if TobGen.Detail.Count = 0 then begin
    {06/07/05 : Il arrive que, sur Bug (!), la tob soit vide : mise en place d'un message plus neutre}
    HShowMessage('4;' + Ecran.Caption + ';Il est impossible de g�n�rer les �critures comptables.'#13 +
                 'Veuillez v�rifier votre param�trage.;W;O;O;O;', '', '');
    Exit;
  end;

  {18/09/06 : Nouvelle fonction de traitement Multi-soci�t�s}
  TRIntegrationPieces(TobGen, True);

  TobGen.ClearDetailPC;
end;

{Imprime la grille rajout�e au lieu de la DB grille
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.BImprimerClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  T : TOB;
begin
  {25/06/04 : pour g�rer le cas de l'eAgl (pas de PrintDBGrid) et le titre sur deux lignes}
  if TobGrid.Detail.Count = 0 then Exit;
  T := TOB.Create('$TRECRITURE', nil, -1);
  try
    T.Dupliquer(TobGrid, True, True);
//    T.Detail[0].AddChampSupValeur('TITRE', Ecran.Caption, True);
  //  T.Detail[0].AddChampSupValeur('TE_DATELIB', Grid.Titres[COL_DATEAFF], True);
    //T.Detail[0].AddChampSupValeur('TE_GENELIB', Grid.Titres[COL_COMPTE], True);
    //LanceEtatTOB('E', 'ECT', 'DFX', T, True, False, False, nil, '', 'titre', False);
    TObjEtats.GenereEtatGrille(Grid, Ecran.Caption);
  finally
    if Assigned(T) then FreeAndNil(T);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ListeOnBeforeFlip(Sender : TObject ; ARow : Integer ; var Cancel : Boolean);
{---------------------------------------------------------------------------------------}
var
  Ok : Boolean;
begin
  {18/09/06 : on ne permet la s�lection que des �critures "saisies"}
  Ok := Copy(Grid.Cells[COL_TRANSAC, ARow], 7, 4) <> TRANSACSAISIE;
  {On n'autorise pas la s�lection d'une �criture r�alis�e, car on ne peut la r�aliser de
   nouveau ou lui changer de date de valeur}
  Cancel := (Grid.Cells[COL_NATURE, ARow] = na_Realise) or Ok;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ToutSelectionner(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  for n := 1 to Grid.RowCount - 1 do
    if not Grid.IsSelected(n) then Grid.FlipSelection(n);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ToutDeSelectionner(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  Grid.ClearSelected
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ListeOnDbleClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  s : string;
  e : string;
begin
  {14/09/05 : FQ 10282 : Ajout de Trim et de FloatToStr(Valeur()), car il semble qu'il y ait
                         maintenant un formatage automatique des zones}
//  e := GetExoFromDate(VarToDateTime(Grid.Cells[COL_DATEAFF, Grid.Row]));
  {23/03/06 : Mise ne place du NODOSSIER}
  e := Trim(Grid.CellValues[Grid.ColCount - 1, Grid.Row]);

  s := e + ';' + Trim(Grid.Cells[COL_TRANSAC, Grid.Row]) + ';' + FloatToStr(ValeurI(Grid.Cells[COL_NUMPIECE, Grid.Row])) + ';' +
       FloatToStr(ValeurI(Grid.Cells[COL_NUMLIGNE, Grid.Row])) + ';';
  AGLLanceFiche('TR', 'TRFICECRITURE', '', s, Trim(Grid.Cells[COL_NATURE, Grid.Row]) + ';');
end;

{Affichage d'une �criture comptable
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ListeOnDbleClickCP(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  T : TOB;
begin
  T := TOB.Create('���', nil, -1);
  try
    T.AddChampSupValeur('E_JOURNAL'      , Grid.CellValues[COL_NATURE      , Grid.Row]);
    T.AddChampSupValeur('E_EXERCICE'     , Grid.CellValues[COL_NUMLIGNE + 1, Grid.Row]);
    T.AddChampSupValeur('E_NUMLIGNE'     , Grid.CellValues[COL_TRANSAC     , Grid.Row]);
    T.AddChampSupValeur('E_NUMECHE'      , Grid.CellValues[COL_NUMLIGNE    , Grid.Row]);
    T.AddChampSupValeur('E_GENERAL'      , Grid.CellValues[COL_COMPTE      , Grid.Row]);
    T.AddChampSupValeur('E_NUMEROPIECE'  , Valeur(Grid.CellValues[COL_NUMPIECE, Grid.Row]));
    T.AddChampSupValeur('E_DATECOMPTABLE', LaTob.GetDateTime('DATEDEB'));
    T.AddChampSupValeur('NOMBASE'        , LaTob.GetString('NOMBASE'));
    AffDetailEcr(T, True);
  finally
    FreeAndNil(T);
  end;
end;

{Affichage d'un mouvement bancaire
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.ListeOnDbleClickBQ(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  lq : string;
begin
  lq := Grid.CellValues[COL_COMPTE  , Grid.Row] + ';' +
        Grid.CellValues[COL_NUMPIECE, Grid.Row] + ';' +
        Grid.CellValues[COL_NUMLIGNE, Grid.Row] + ';' ;
  CPLanceFiche_EEXBQLIG('', lq, ActionToString(taConsult) + ';;');
end;

{JP 08/03/04 : FQ 10010 : suppression des �critures non r�alis�es
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.BDeleteClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  I : Integer;
begin
  if Grid.nbSelected = 0 then begin
    HShowMessage('0;' + Ecran.Caption + ';Aucun �l�ment n''est s�lectionn�.;I;O;O;O', '', '');
    Exit;
  end;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer les �l�ments s�lectionn�s.;Q;YNC;N;N;', '', '') <> mrYes then Exit;

  InitMove(Grid.nbSelected, 'Suppression des �critures');
  for I := Grid.RowCount - 1 downto 1 do begin
    Movecur(False);
    {On ne traite que les lignes s�lectionn�es qui ne sont pas r�alis�es ni import� de comptabilit�.
     JP 15/04/04 : On consid�re que l'on peut supprimer une �criture de l'�ch�ancier ....
                   Sinon, il faudra g�rer TE_QUALIFORIGINE}
    if Grid.IsSelected(I) and (Grid.Cells[COL_NATURE, I] <> na_Realise) and
       {15/04/04 : On exclue les �critures de comptabilit�}
       (Pos(TRANSACIMPORT , UpperCase(Grid.Cells[COL_TRANSAC, I])) < 1) then begin

      {On interdit la suppression d'�critures qui appartiennent � une transaction financi�res
       14/09/05 : FQ 10282 : Ajout de Trim et de FloatToStr(Valeur()), car il semble qu'il y ait
                             maintenant un formatage automatique des zones}
      Q := OpenSQL('SELECT TE_NUMEROPIECE FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + Trim(Grid.Cells[COL_TRANSAC, I]) +
                   '" AND TE_NUMEROPIECE <> "' + FloatToStr(ValeurI(Grid.Cells[COL_NUMPIECE, I])) + '"', True);
      try
        {Supression de l'�criture}
        if Q.RecordCount = 0 then begin
          {20/07/04 : suppression des �critures avec la gestion des commissions
           14/09/05 : FQ 10282 : Ajout de Trim et de FloatToStr(Valeur()), car il semble qu'il y ait
                                 maintenant un formatage automatique des zones}
          if not SupprimeEcriture(Ecran.Caption, Trim(Grid.Cells[COL_TRANSAC, I]),
                                                 FloatToStr(ValeurI(Grid.Cells[COL_NUMPIECE, I])),
                                                 FloatToStr(ValeurI(Grid.Cells[COL_NUMLIGNE, I])),
                                                 Trim(Grid.CellValues[Grid.ColCount - 1, I])) then Break;

          {On supprime la ligne de la grille}
          Grid.DeleteRow(I);
          {Pour demander un recalcul des soldes en retour sur le d�tail des suivis}
          TREcritureModified := DateToStr(FDateDeb);
        end {Supression}

        else begin
          {Constitution du message d'avertissement}
          HShowMessage('4;' + Ecran.Caption + ';Certaines �critures appartiennent � des transactions financi�res,'#13 +
                       'et ne peuvent �tre supprim�es. Pour les supprimer, vous devez "d�valider" la transaction.;I;O;O;O;', '', '');
        end;
      finally
        Ferme(Q);
      end;
    end;
  end;
  FiniMove;
  Grid.ClearSelected;
end;

{10/06/07 : FQ 10432 : gestion de l'appel depuis les �chelles d'int�r�ts : dans ce cas, on
            cache tous les boutons d'office. C'est le seul cas o� VisibleOk arrive � False
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.GestionBoutons(VisibleOk : Boolean = True);
{---------------------------------------------------------------------------------------}
var
  Btn : TToolbarButton97;
  Ok1 : Boolean;
  Ok2 : Boolean;
begin
  if VisibleOk then begin
    Ok1 := not (FAppelant in [dsMensuel, dsTreso, dsControle]);
    Ok2 := not (FAppelant = dsBancaire) or (TobArgument.GetString('TYPE') = na_Prevision);
    VisibleOk := Ok1 and Ok2;
  end;
  Btn := TToolbarButton97(GetControl('BREALISE'));
  Btn.Hint := TraduireMemoire('R�aliser les �critures s�lectionn�es');
  Btn.OnClick := PopupRealiseOnClick;
  Btn.Visible := VisibleOk;
  {20/06/07 : FQ 10480 : Gestion du concept la cr�ation / Suppresion des flux}
  CanValidateBO(Btn);

  Btn := TToolbarButton97(GetControl('BCHANGE'));
  Btn.Hint := TraduireMemoire('Modifier la date des �critures s�lectionn�es');
  Btn.OnClick := PopupChangeDateOnClick;
  {11/01/07 : FQ 10399 : n'est valable que si l'on vient d'un suivi en valeur}
  Btn.Visible := VisibleOk and (FDateOpe = 'TE_DATEVALEUR');

  Btn := TToolbarButton97(GetControl('BSAISIE'));
  Btn.Hint := TraduireMemoire('Saisie d''une nouvelle �criture');
  Btn.OnClick := PopupSimulation;
  {20/06/07 : FQ 10480 : Gestion du concept la cr�ation / Suppresion des flux}
  CanCreateEcr(Btn);

  Btn.Visible := VisibleOk;
  Btn := TToolbarButton97(GetControl('BSELECT'));
  Btn.Hint := TraduireMemoire('S�lectionner toutes les lignes');
  Btn.OnClick := ToutSelectionner;
  Btn.Visible := VisibleOk;
  Btn := TToolbarButton97(GetControl('BDESELECT'));
  Btn.Hint := TraduireMemoire('D�s�lectionner toutes les lignes');
  Btn.OnClick := ToutDeSelectionner;
  Btn.Visible := VisibleOk;
  {JP 08/03/04 : FQ 10010 : mise en place de la suppression}
  Btn := TToolbarButton97(GetControl('BDELETE'));
  Btn.Hint := TraduireMemoire('Suppression des lignes s�lectionn�es');
  Btn.OnClick := BDeleteClick;
  Btn.Visible := VisibleOk;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.GestionControls;
{---------------------------------------------------------------------------------------}
begin
  PopupMenu := TPopUpMenu(GetControl('POPUPMENU'));
  PopupMenu.OnPopup := OnPopupMenu;
  PopupMenu.Items[0].OnClick := PopupRealiseOnClick; // Passe en r�alis�
  PopupMenu.Items[1].OnClick := PopupChangeDateOnClick;
  PopupMenu.Items[2].OnClick := PopupSimulation;
  PopupMenu.Items[3].OnClick := BDeleteClick;{JP 08/03/04 : suppression d'�critures}
  PopupMenu.Items[4].OnClick := ToutSelectionner;
  PopupMenu.Items[5].OnClick := ToutDeSelectionner;

  {20/06/07 : FQ 10480 : Gestion du concept la cr�ation / Suppresion des flux}
  CanCreateEcr(PopupMenu.Items[2]);
  CanValidateBO(PopupMenu.Items[0]);

  Grid := THGrid(GetControl('GRID'));
  TToolbarButton97(GetControl('BIMPRIMER')).OnClick := BImprimerClick;

  {On limite les fonctions pour les fiches de budget et de Treso}
  if FAppelant in [dsTreso, dsMensuel, dsControle] then begin
    PopupMenu.Items.Clear;
    Grid.MultiSelect := False;
  end
  else
    {Ajout du popup au menu 27}
    AddMenuPop(PopupMenu, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PrepareGrille(Dev : string);
{---------------------------------------------------------------------------------------}
begin
  {1/ PR�PARATION DE LA REQU�TE}
  if FAppelant = dsControle then begin
    PrepareGrilleCtrl(Dev);
    Exit;
  end;

  {24/03/06 : on cache, pour le moment le NODOSSIER qui a �t� ajout� � toutes les requ�tes
              comme dernier champ}
  Grid.ColWidths[Grid.ColCount - 1] := 0;

  {Mise � jour des libell�s de la grille}
  if FAppelant in [dsDetail, dsMensuel, dsTreso] then Grid.Titres[COL_COMPTE] := 'Compte'
                                                 else Grid.Titres[COL_COMPTE] := 'Code flux';

  {29/06/04 : Ajout de la date compl�mentaire dans la grille}
  if FDateOpe = 'TE_DATERAPPRO' then begin
   {15/04/05 : FQ 10240 : Gestion de la date d'affichage}
    if TobArgument.GetString('DATEAFF') <> 'TE_DATEVALEUR' then Grid.Titres[COL_DATEAFF] := 'Date Op�.'
                                                           else Grid.Titres[COL_DATEAFF] := 'Date Val.';
  end
  else if FDateOpe = 'TE_DATEVALEUR' then begin
    {31/10/06 : FQ 10338 : affichage de la date de rappro sur le d�tail du suivi bancaire}
    if TobArgument.GetString('DATEAFF') = 'TE_DATERAPPRO' then Grid.Titres[COL_DATEAFF] := 'Date Rap.'
                                                          else Grid.Titres[COL_DATEAFF] := 'Date Op�.';
    {Si on est en date de valeur, on cache la colonne contenant la CleValeur}
    Grid.ColWidths[Grid.ColCount - 2] := 0;
  end
  else
    Grid.Titres[COL_DATEAFF] := 'Date Val.';

  {Ajustement des colonnes}
  Grid.ColWidths[COL_TRANSAC] := Grid.ColWidths[COL_TRANSAC] + 15;
  Grid.ColWidths[COL_COMPTE]  := Grid.ColWidths[COL_COMPTE]  - 10;

  Grid.UpdateTitres;
  {Gestion des formats des montants}
  if Dev = V_PGI.DevisePivot then Grid.ColFormats[COL_MONTANT] := StrFMask(V_PGI.OkDecV, '', True)
                             else Grid.ColFormats[COL_MONTANT] := StrFMask(CalcDecimaleDevise(Dev), '', True);
  Grid.ColAligns[COL_MONTANT] := taRightJustify;
  Grid.ColFormats[COL_MONTANT + 1] := StrFMask(V_PGI.OkDecV, '', True);
  Grid.ColAligns [COL_MONTANT + 1] := taRightJustify;

  Grid.OnBeforeFlip := ListeOnBeforeFlip;
  Grid.OnDblClick   := ListeOnDbleClick;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PrepareGrilleCtrl(Dev : string);
{---------------------------------------------------------------------------------------}
begin
  if TobGrid.Detail.Count = 0 then Exit;
  {24/03/06 : on cache, pour le moment le NODOSSIER qui a �t� ajout� � toutes les requ�tes
              comme dernier champ}
  Grid.ColWidths[Grid.ColCount - 1] := 0;

  Grid.ColTypes[COL_DATEAFF] := 'D';
  Grid.ColFormats[COL_DATEAFF] := 'dd/mm/yyyy';

  {Mise � jour des libell�s de la grille}
  Grid.Cells[COL_COMPTE, 0] := 'Compte';

  {Sur TRECRITURE}
  if LaTob.GetString('TYPE') = 'T' then begin
    if LaTob.GetString('DATEAFF') = 'TE_DATEVALEUR' then Grid.Cells[COL_DATEAFF, 0] := 'Date Val.'
                                                    else Grid.Cells[COL_DATEAFF, 0] := 'Date Op�.';

    {Ajustement des colonnes}
    Grid.ColWidths[COL_TRANSAC] := Grid.ColWidths[COL_TRANSAC] + 15;
    Grid.ColWidths[COL_COMPTE]  := Grid.ColWidths[COL_COMPTE]  - 10;

    {Gestion des formats des montants}
    if Dev = V_PGI.DevisePivot then Grid.ColFormats[COL_MONTANT] := StrFMask(V_PGI.OkDecV, '', True)
                               else Grid.ColFormats[COL_MONTANT] := StrFMask(CalcDecimaleDevise(Dev), '', True);
    Grid.OnDblClick  := ListeOnDbleClick;
  end

  {Sur ECRITURE}
  else if LaTob.GetString('TYPE') = 'C' then begin
    Grid.Cells[COL_DATEAFF    , 0] := 'Date Val.';
    Grid.Cells[COL_NATURE     , 0] := 'Jal.';
    Grid.Cells[COL_MONTANT    , 0] := 'D�bit Dev.';
    Grid.Cells[COL_MONTANT + 1, 0] := 'Cr�dit Dev.';
    Grid.Cells[COL_TRANSAC    , 0] := 'Num. Lig.';
    Grid.Cells[COL_NUMLIGNE   , 0] := 'Eche.';
    Grid.Cells[COL_CIB        , 0] := 'Paie.';
    Grid.ColWidths[COL_NUMLIGNE + 2] := 0;
    Grid.ColWidths[COL_TRANSAC     ] := 54;
    Grid.ColWidths[COL_LIBELLE     ] := Grid.ColWidths[COL_LIBELLE] + 55;
    Grid.ColWidths[COL_CIB         ] := Grid.ColWidths[COL_CIB]  + 7;

    Grid.ColFormats[COL_MONTANT] := StrFMask(V_PGI.OkDecV, '', True);
    Grid.OnDblClick  := ListeOnDbleClickCP;
  end
  {Sur EEXBQLIG}
  else if LaTob.GetString('TYPE') = 'B' then begin
    Grid.Cells[COL_NATURE     , 0] := 'R�f. Ptg.';
    Grid.Cells[COL_DATEAFF    , 0] := 'Date Op�.';
    Grid.Cells[COL_MONTANT    , 0] := 'D�bit Dev.';
    Grid.Cells[COL_MONTANT + 1, 0] := 'Cr�dit Dev.';
    Grid.Cells[COL_NUMPIECE   , 0] := 'Rel.';
    Grid.Cells[COL_TRANSAC    , 0] := 'Lib. Enrichi.';

    Grid.ColWidths[COL_NATURE     ] := Grid.ColWidths[COL_NATURE] * 2;
    Grid.ColWidths[COL_TRANSAC    ] := Grid.ColWidths[COL_TRANSAC ] - 7;
    Grid.ColWidths[COL_NUMPIECE   ] := Grid.ColWidths[COL_NUMPIECE] - 17;

    Grid.ColFormats[COL_MONTANT   ] := StrFMask(V_PGI.OkDecV, '', True);
    Grid.OnDblClick  := ListeOnDbleClickBQ;
  end;

  Grid.ColWidths[COL_NUMLIGNE + 1] := 0;

  Grid.ColFormats[COL_MONTANT + 1] := StrFMask(V_PGI.OkDecV, '', True);

  Grid.ColAligns[COL_MONTANT + 1] := taRightJustify;
  Grid.ColAligns[COL_MONTANT    ] := taRightJustify;
  Grid.ColAligns[COL_NUMPIECE   ] := taRightJustify;
  Grid.ColAligns[COL_NUMLIGNE   ] := taRightJustify;
  Grid.ColAligns[COL_DEVISE     ] := taCenter;
  Grid.ColAligns[COL_NATURE     ] := taCenter;
  Grid.ColAligns[COL_COMPTE     ] := taCenter;
  Grid.ColAligns[COL_CIB        ] := taCenter;
  Grid.ColAligns[COL_DATEAFF    ] := taCenter;
  if LaTob.GetString('TYPE') = 'C' then Grid.ColAligns[COL_TRANSAC] := taRightJustify;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.MajCaptionForm;
{---------------------------------------------------------------------------------------}
begin
  {Suivi des commissions}
  if FAppelant = dsCommission then begin
    if TobArgument.GetString('LIBNAT') = suc_Commission then
      TForm(Ecran).Caption := 'Commissions ' + TobArgument.GetString('LIBELLE')
    else if TobArgument.GetString('LIBNAT') = suc_Divers then
      TForm(Ecran).Caption := TobArgument.GetString('LIBELLE')
    else
      TForm(Ecran).Caption := 'Base des commissions ' + TobArgument.GetString('LIBELLE');
  end

  else
    TForm(Ecran).Caption := TobArgument.GetString('LIBELLE') + TobArgument.GetString('MOIS');

  UpdateCaption(Ecran);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.GererDetailTreso(Arg : string);
{---------------------------------------------------------------------------------------}
var
  SDateAff : string;
  Code     : string;
  Where    : string;
  Clef     : string;
  s1       : string;
  sDate    : string;
begin
  FDateOpe := ReadTokenSt(Arg);
  Code := ReadTokenSt(Arg);
  FGeneral := ReadTokenSt(Arg);
  sDate := ReadTokenSt(Arg);
  TForm(Ecran).Caption := ReadTokenSt(Arg);
  UpdateCaption(Ecran);
  FNature := ReadTokenSt(Arg);

  Where := 'TE_QUALIFORIGINE = "' + Code + '" AND ' + FGeneral + ' ' + FNature;
  {15/11/06 : Gestion du filtre sur les dossiers pour le suivi Tr�so et les budgets}
  Where := Where + GetFiltreDossier;

  if FDateOpe = 'TE_DATEVALEUR' then begin
    Clef := ', TE_CLEVALEUR';
    SDateAff := 'TE_DATECOMPTABLE AS TE_DATEAFF, '; {29/06/04 : Ajout de la date compl�mentaire dans la grille}
  end
  else begin
    SDateAff := 'TE_DATEVALEUR AS TE_DATEAFF, '; {29/06/04 : Ajout de la date compl�mentaire dans la grille}
  end;

  if LaTob.GetDateTime('DATEDEB') = iDate1900 then
    {23/03/06 : Ajout du NO_DOSSIER dans la requ�te}
    RequeteSQL := 'SELECT ' + SDateAff + 'TE_NATURE, TE_GENERAL AS TE_GENE, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE,' +
                  'TE_DEVISE, TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE' + Clef + ', TE_NODOSSIER FROM TRECRITURE '+
                  'LEFT JOIN BANQUECP on BQ_CODE = TE_GENERAL ' +
                  'WHERE ' + FDateOpe + '= "' + UsDateTime(StrToDate(sDate)) + '" AND ' + Where + WhereConf +
                  ' ORDER BY TE_NUMEROPIECE, TE_GENERAL'
  else
    {14/11/06 : On est en affichage mensuel}
    RequeteSQL := 'SELECT ' + SDateAff + 'TE_NATURE, TE_GENERAL AS TE_GENE, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE,' +
                  'TE_DEVISE, TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE' + Clef + ', TE_NODOSSIER FROM TRECRITURE '+
                  'LEFT JOIN BANQUECP on BQ_CODE = TE_GENERAL ' +
                  'WHERE ' + FDateOpe + ' BETWEEN "' + UsDateTime(LaTob.GetDateTime('DATEDEB')) +
                  '" AND "' + UsDateTime(LaTob.GetDateTime('DATEFIN')) + '" AND ' + Where + WhereConf +
                  ' ORDER BY TE_NUMEROPIECE, TE_GENERAL';

  {Th�oriquement le r�sultat de l requ�te ne renvoie qu'une m�me devise}
  TobGrid.LoadDetailDBFromSQL('1', RequeteSQL);
  if TobGrid.Detail.Count > 0 then
    S1 := TobGrid.Detail[0].GetString('TE_DEVISE');

  TobGrid.PutGridDetail(Grid, False, False, '', True);
  {20/04/05 : Dessin de la grille}
  PrepareGrille(S1);
  {20/04/05 : Gestion des boutons}
  GestionBoutons();

  ADDMenuPop(PopupMenu, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.SetAppelant(Value : string);
{---------------------------------------------------------------------------------------}
var
  ap : TDescendant;
begin
  if Value = '' then Value := TobArgument.GetString('APPEL');

  ap := dsDetail;
  repeat
    if Value = IntToStr(Ord(ap)) then begin
      FAppelant := ap;
      Exit;
    end;
    ap := Succ(ap);
  until ap = dsOPCVM;
end;

{---------------------------------------------------------------------------------------}
function TOF_DETAILFLUX.SetFVariables : Boolean;
{---------------------------------------------------------------------------------------}
begin
  {R�cup�ration de la date sur laquelle doit se faire la requ�te}
  FDateOpe := TobArgument.GetString('DATEOPE');
  {31/10/06 : FQ 10338 : affichage de la date de rappro pour le suivi bancaire "pr�visionnel"}
//  if (FDateOpe = 'TE_DATERAPPRO') and (FDateOpe = TobArgument.GetString('DATEAFF')) then
    {Remarque : le suivi bancaire est toujours en date de valeur}
  //  FDateOpe := 'TE_DATEVALEUR';                                 
  {R�cup�ration du compte g�n�ral sur lequel doit se faire la requ�te}
  FGeneral := TobArgument.GetString('GENERAL');
  {R�cup�ration de la date de d�but, qui doit toujours �tre renseign�e}
  FDateDeb := TobArgument.GetDateTime('DATEDEB');
  {R�cup�ration de la date de fin, qui doit �tre renseign�e si on n'est pas en affichage quotidien}
  FDateFin := TobArgument.GetDateTime('DATEFIN');
  {R�cup�ration de la clause where sur TE_NATURE}
  FNature := TobArgument.GetString('NATURE');

  {On teste les Variables}
  Result := (FDateOpe <> '') and (FGeneral <> '') and
            (FDateDeb > iDate1900) and ((FDateFin > iDate1900) or (FPeriode = tp_1));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.SetPeriode(Value : string);
{---------------------------------------------------------------------------------------}
var
  ap : TypePeriod;
begin
  ap := tp_1;
  repeat
    if Value = IntToStr(Ord(ap)) then begin
      FPeriode := ap;
      Exit;
    end;
    ap := Succ(ap);
  until ap = tp_30;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.InitVariable;
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  WhereConf := TObjConfidentialite.GetWhereConf(V_PGI.User, tyc_Banque);
  if WhereConf <> '' then WhereConf := ' AND (' + WhereConf + ') ';
  {$ENDIF TRCONF}
  
  TREcritureModified := '';
  FDateModif := iDate2099;
  {Tob d'affichage}
  TobGrid := TOB.Create('', nil, -1);
  {Tob pour le processus d'int�gration en comptabilit�}
  TobGen := TobPieceCompta.Create('�ECRIT', nil, -1);
  {Tob contenant les param�tres pour la requ�te et l'affichage}
  TobArgument := TFVierge(Ecran).LaTOF.LaTOB;
end;

{23/03/06 : Ajout du champ NODOSSIER comme dernier champ des requ�tes
{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PrepareRequete;
{---------------------------------------------------------------------------------------}
var
  Where  : string;
  Prefix : string;
  Select : string;
  Clef   : string;
  SDateAff : string;
begin
  {1/ PR�PARATION DE LA REQU�TE}
  if FAppelant = dsControle then begin
    PrepareRequeteCtrl;
    Exit;
  end;

  if FAppelant = dsCommission then Prefix := 'T2.';

  Where  := Prefix + FDateOpe + ' >= "' + UsDateTime(TobArgument.GetDateTime('DATEDEB')) + '" AND ' +
            Prefix + FDateOpe + ' <= "' + UsDateTime(TobArgument.GetDateTime('DATEFIN')) + '" ';

  {15/11/06 : Gestion du filtre sur les dossiers pour le suivi Tr�so et les budgets}
  Where := Where + GetFiltreDossier;

  {30/07/04 : Suivi des commissions}
  if FAppelant = dsCommission then begin
    {Pour les commissions de mouvement, la requ�te est ind�pendante des codes flux}
    if TobArgument.GetString('LIBNAT') <> suc_Divers then
      Where  := Where + 'AND T2.TE_CODEFLUX = "' + TobArgument.GetString('CODE') + '" ';

    if FGeneral <> '' then
      Where  := Where + 'AND T2.TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '" ';

    {Pour la base, la requ�te est plus sp�cifique !!!}
    if TobArgument.GetString('LIBNAT') = suc_Commission then
      Where  := Where + 'AND T2.TE_COMMISSION = "' + TobArgument.GetString('LIBNAT') + '"';

    Where := Where + FNature;
    Select := 'T2.TE_GENERAL';
  end

  {Budget mensuel ou p�riodique}
  else if FAppelant = dsMensuel then begin
    Select := 'TE_GENERAL';
    if TobArgument.GetString('CODE') <> '' then
      Where  := Where + 'AND TE_CODEFLUX = "' + TobArgument.GetString('CODE') + '" ';
    {29/09/05 : FQ 10296 : General etait en doublon avec FGeneral}
    if FGeneral <> '' then
      Where  := Where + 'AND TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '" ';
    Where := Where + FNature;
  end

  {Suivi par flux}
  else if FAppelant = dsDetail then begin
    Select := 'TE_GENERAL';
    Where  := Where + ' AND TE_CODEFLUX = "' + TobArgument.GetString('CODE') +
             '" AND TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '"' + FNature;
  end

  {Suivi bancaire}
  else if FAppelant = dsBancaire then begin
    Select := 'TE_CODEFLUX';
    {05/04/05 : FQ 10240 : Si on demande les �critures point�es, on affiche le rappro du jour
     31/10/06 : FQ 10338 : modification des �critures affich�es}
    if TobArgument.GetString('TYPE') = na_Prevision then begin
      Where := 'TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '" ' + FNature;
      Where := Where + ' AND ((TE_DATEVALEUR > "' + UsDateTime(TobArgument.GetDateTime('DATEFIN')) + '" AND ' +
                             'TE_DATERAPPRO BETWEEN "' + UsDateTime(iDate1900 + 1) + '" AND "' + UsDateTime(TobArgument.GetDateTime('DATEDEB')) + '")';
      Where := Where + ' OR (TE_DATEVALEUR <= "' + UsDateTime(TobArgument.GetDateTime('DATEFIN')) + '" AND ' +
                            'TE_DATERAPPRO = "' + UsDateTime(iDate1900) + '")';
      Where := Where + ' OR (TE_DATEVALEUR <= "' + UsDateTime(TobArgument.GetDateTime('DATEDEB')) + '" AND ' +
                            'TE_DATERAPPRO > "' + UsDateTime(TobArgument.GetDateTime('DATEFIN')) + '"))';
    end
    else
      Where  := Where + ' AND TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '" ' + FNature;
//    else if TobArgument.GetString('TYPE') = na_Pointe then
  //    Where := Where + ' AND TE_DATERAPPRO > "' + UsDateTime(TobArgument.GetDateTime('DATEDEB')) + '" AND TE_DATERAPPRO <= "' +
    //           UsDateTime(TobArgument.GetDateTime('DATEFIN')) + '"';
  end

  {Suivi par solde}
  else if FAppelant = dsSolde then begin
    Select := 'TE_CODEFLUX';
    {10/06/07 : FQ 10432 : gestion des �chelles d'int�r�ts}
    if EchelleOk then Where := Where + ' ' + TobArgument.GetString('WHERE')
                 else Where := Where + ' AND TE_GENERAL = "' + TobArgument.GetString('GENERAL') + '"' + FNature;
    Where := Where + FNature;
  end;

  {15/04/05 : FQ 10240 : Gestion de la date d'affichage}
  if FDateOpe = 'TE_DATERAPPRO' then begin
    {Dans ce cas on inverse : la date d'affichage est la date d'op�ration de la fiche appelante}
    if TobArgument.GetString('DATEAFF') = 'TE_DATECOMPTABLE' then SDateAff := 'TE_DATECOMPTABLE AS TE_DATEAFF, '
                                                             else SDateAff := 'TE_DATEVALEUR AS TE_DATEAFF, ';
  end
  else if FDateOpe = 'TE_DATEVALEUR' then begin
    {31/10/06 : FQ 10338 : affichage de la date de rappro pour le "pr�visionnel"}
    if TobArgument.GetString('DATEAFF') = 'TE_DATERAPPRO' then SDateAff := 'TE_DATERAPPRO AS TE_DATEAFF, '
                                                          {29/06/04 : Ajout de la date compl�mentaire dans la grille}
                                                          else SDateAff := 'TE_DATECOMPTABLE AS TE_DATEAFF, ';
    Clef := ', TE_CLEVALEUR';
  end
  else
    SDateAff := 'TE_DATEVALEUR AS TE_DATEAFF, '; {29/06/04 : Ajout de la date compl�mentaire dans la grille}

  {2/ REQU�TE PROPREMENT DITE}
  if FAppelant = dsCommission then begin
    {Commissions : r�cup�ration des �critures de commission (TE_COMMISSION = "C") selon les crit�res pass�s en param�tre
                   dans le OnArgument de la fiche}
    if TobArgument.GetString('LIBNAT') = suc_Commission then
      {03/10/05 : FQ 10277 : Pour les commissions, on affiche les codes flux au lieu de T2.TE_GENERAL}
      RequeteSQL := 'SELECT T2.TE_DATEVALEUR, T2.TE_NATURE, T2.TE_CODEFLUX AS TE_GENE, T2.TE_NUMEROPIECE, T2.TE_NUMTRANSAC, T2.TE_CODECIB, T2.TE_LIBELLE,' +
             'T2.TE_DEVISE, T2.TE_MONTANTDEV, T2.TE_MONTANT, T2.TE_NUMLIGNE, T2.TE_CLEVALEUR, T2.TE_NODOSSIER FROM TRECRITURE T2 '+
             'LEFT JOIN BANQUECP on BQ_CODE = TE_GENERAL ' +
             ' WHERE ' + Where + WhereConf +
             ' ORDER BY T2.TE_NUMEROPIECE,' + Select

    {Cas particulier des commissions de mouvement}
    else if TobArgument.GetString('LIBNAT') = suc_Divers then begin
      {03/10/05 : FQ 10277 : Pour les commissions, on affiche les codes flux au lieu de T2.TE_GENERAL}
      RequeteSQL := 'SELECT T2.TE_DATEVALEUR, T2.TE_NATURE, T2.TE_CODEFLUX AS TE_GENE, T2.TE_NUMEROPIECE, T2.TE_NUMTRANSAC AS NUM, T2.TE_CODECIB, T2.TE_LIBELLE,' +
             'T2.TE_DEVISE, T2.TE_MONTANTDEV, T2.TE_MONTANT, T2.TE_NUMLIGNE, T2.TE_CLEVALEUR, T2.TE_NODOSSIER FROM TRECRITURE T2, FLUXTRESO, BANQUECP WHERE ' +
             'TE_CODEFLUX = TFT_FLUX AND TFT_COMMOUVEMENT = "X" AND TE_GENERAL = BQ_CODE AND ' + Where + WhereConf;
      RequeteSQL := RequeteSQL + ' UNION ALL ' +
      {03/10/05 : FQ 10277 : Pour les commissions, on affiche les codes flux au lieu de T2.TE_GENERAL}
             'SELECT T2.TE_DATEVALEUR, T2.TE_NATURE, T2.TE_CODEFLUX AS TE_GENE, T2.TE_NUMEROPIECE, T2.TE_NUMTRANSAC AS NUM, T2.TE_CODECIB, T2.TE_LIBELLE,' +
             'T2.TE_DEVISE, T2.TE_MONTANTDEV, T2.TE_MONTANT, T2.TE_NUMLIGNE, T2.TE_CLEVALEUR, T2.TE_NODOSSIER FROM TRECRITURE T2, RUBRIQUE, BANQUECP WHERE ' +
             'TE_CODEFLUX = RB_RUBRIQUE AND RB_CATEGORIE = "X" AND TE_GENERAL = BQ_CODE AND ' + Where + WhereConf +
             ' ORDER BY NUM, TE_GENE' {Remarque : sous oracle, le order by ne supporte que des champs aliass�s sur les union}
    end
    else
    {Base : Les crit�res pass�s en param�tre dans le OnArgument de la fiche sont les m�mes que ci-dessus sauf TE_COMMISSION
            qui est � "A". On fait une jointure sur la table �criture elle-m�me, o� T1 repr�sente la base et T2 les commissions.
            On r�cup�re donc les ecritures de "Base" qui correpondent aux commissions concern�es par les crit�res de s�lection.
            Rappel : dans la fiche de suivi des commissions, le test sur les dates se fait sur les commissions et on ram�ne la base
                     qui correspond aux dites commissions}
      {10/10/05 : FQ 10277 : Pour les commissions, on affiche les codes flux au lieu de T2.TE_GENERAL.

        !!!!!!!!!!!!!!!! A VOIR A L'OCCASION D'UN BUG !!!!!!!!!!!!!!!!

        REMARQUE !!! Il y a peut-�tre un probl�me avec la jointure sur le num�ro de pi�ce : les com et les bases
                     ont-elles le m�me num�ro de pi�ce ??

        !!!!!!!!!!!!!!!! A VOIR A L'OCCASION D'UN BUG !!!!!!!!!!!!!!!!
        30/11/05 : FQ 10303 : Effectivement la jointure sur TE_NUMEROPIECE est de trop !!
                   AND T1.TE_NUMEROPIECE = T2.TE_NUMEROPIECE}

      RequeteSQL := 'SELECT T1.TE_DATEVALEUR, T1.TE_NATURE, T1.TE_CODEFLUX AS TE_GENE, T1.TE_NUMEROPIECE, T1.TE_NUMTRANSAC, T1.TE_CODECIB, T1.TE_LIBELLE,' +
             'T1.TE_DEVISE, T1.TE_MONTANTDEV, T1.TE_MONTANT, T1.TE_NUMLIGNE, T1.TE_CLEVALEUR, T1.TE_NODOSSIER FROM TRECRITURE T1, TRECRITURE T2, BANQUECP ' +
             'WHERE T1.TE_GENERAL = BQ_CODE AND T1.TE_NUMTRANSAC = T2.TE_NUMTRANSAC AND T1.TE_COMMISSION = "' +
             suc_AvecCom + '" AND T2.TE_COMMISSION = "' + suc_Commission + '" AND ' + Where + WhereConf +
             ' ORDER BY T1.TE_NUMEROPIECE, T1.TE_GENERAL';
  end
  else if FAppelant = dsMensuel then
    RequeteSQL := 'SELECT ' + SDateAff + 'TE_NATURE,' + Select + ' AS TE_GENE, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE,' +
           'TE_DEVISE, TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE' + Clef + ', TE_NODOSSIER FROM TRECRITURE ' +
           'LEFT JOIN BANQUECP on BQ_CODE = TE_GENERAL ' +
           'WHERE ' + Where + WhereConf + ' ORDER BY TE_NUMEROPIECE,' + Select
  {15/04/05 : FQ 10240 : Pour le d�tail des �critures non point�es du suivi bancaire on affiche
             les �critures qui ne sont pas encore point�es en "sDate" : d'o� le <=}
  else if (FAppelant = dsBancaire) and (TobArgument.GetString('TYPE') = na_Prevision) then begin
    RequeteSQL:= 'SELECT ' + SDateAff + 'TE_NATURE,' + Select + ' AS TE_GENE, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE,' +
           'TE_DEVISE, TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE' + Clef + ', TE_NODOSSIER FROM TRECRITURE '+
           'WHERE ' + Where +
           ' ORDER BY TE_NUMEROPIECE,' + Select;
  end
  else
    RequeteSQL := 'SELECT ' + SDateAff + 'TE_NATURE,' + Select + ' AS TE_GENE, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE,' +
           'TE_DEVISE, TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE' + Clef + ', TE_NODOSSIER FROM TRECRITURE ' +
           TobArgument.GetString('LEFTJOIN') + ' WHERE ' + Where +
           ' ORDER BY TE_NUMEROPIECE,' + Select;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_DETAILFLUX.PrepareRequeteCtrl;
{---------------------------------------------------------------------------------------}
var
  DW : string;
begin
  if LaTob.GetString('TYPE') = 'C' then begin
    RequeteSQL := 'SELECT E_DATEVALEUR, E_JOURNAL, E_GENERAL, E_NUMEROPIECE, E_NUMLIGNE, E_MODEPAIE, E_LIBELLE, ' +
                  'E_DEVISE, E_DEBITDEV, E_CREDITDEV, E_NUMECHE, E_EXERCICE, "" FROM ' +
                  GetTableDossier(LaTOB.GetString('NOMBASE') ,'ECRITURE') + ' WHERE ';
    RequeteSQL := RequeteSQL + 'E_DATECOMPTABLE = "' + UsDateTime(LaTOB.GetDateTime('DATEDEB')) + '" AND ' +
                  'E_GENERAL = "' + LaTOB.GetString('GENERAL') + '" AND E_QUALIFPIECE = "N"';
  end

  else if LaTob.GetString('TYPE') = 'B' then begin
    {09/10/07 : FQ 10522 : on travaille sur eexblig et non plus sur eexbq}
    RequeteSQL := 'SELECT CEL_DATEOPERATION, CEL_REFPOINTAGE, CEL_GENERAL, CEL_NUMRELEVE, CEL_LIBELLE1, CEL_CODEAFB, CEL_LIBELLE, ' +
                  'IIF(CEL_DEBITDEV-CEL_CREDITDEV = 0, "' + V_PGI.DevisePivot + '", "DEV"), ' +
                  'IIF(CEL_DEBITDEV-CEL_CREDITDEV = 0, CEL_DEBITEURO, CEL_DEBITDEV), ';
    RequeteSQL := RequeteSQL + 'IIF(CEL_DEBITDEV-CEL_CREDITDEV = 0, CEL_CREDITEURO, CEL_CREDITDEV), ' +
                  'CEL_NUMLIGNE, "", "" FROM ' +
                  GetTableDossier(LaTOB.GetString('NOMBASE') ,'EEXBQLIG') +
                  ' WHERE CEL_DATEVALEUR = "' + UsDateTime(LaTOB.GetDateTime('DATEDEB')) + '" AND ';
    if EstPointageSurTreso then
      RequeteSQL := RequeteSQL + 'CEL_GENERAL = "' + LaTOB.GetString('CODE') + '" '
    else
      RequeteSQL := RequeteSQL + 'CEL_GENERAL = "' + LaTOB.GetString('GENERAL') + '" ';
  end
  else if LaTob.GetString('TYPE') = 'T' then begin
    if LaTob.GetString('DATEAFF') = 'TE_DATECOMPTABLE' then DW := 'TE_DATEVALEUR'
                                                       else DW := 'TE_DATECOMPTABLE';
    RequeteSQL := 'SELECT ' + LaTob.GetString('DATEAFF') + ', TE_NATURE, TE_GENERAL, TE_NUMEROPIECE, TE_NUMTRANSAC, TE_CODECIB, TE_LIBELLE, TE_DEVISE, ' +
                  'TE_MONTANTDEV, TE_MONTANT, TE_NUMLIGNE, "", TE_NODOSSIER FROM TRECRITURE WHERE ';
    RequeteSQL := RequeteSQL + DW + ' = "' + UsDateTime(LaTOB.GetDateTime('DATEDEB')) + '" AND ' +
                  'TE_GENERAL = "' + LaTOB.GetString('CODE') + '" AND TE_NATURE = "' + na_Realise + '"';
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_DETAILFLUX.GetFiltreDossier : string;
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  Result := '';
  s := LaTob.GetString('REGROUP');
  if (s <> '') and (Pos('<<', s) = 0 ) then begin
    if s[Length(s)] <> ';' then s := s + ';';
    Result := ' AND TE_NODOSSIER IN (' + GetClauseIn(s) + ') ';
  end;
end;

initialization
  RegisterClasses([TOF_DETAILFLUX]);

end.
