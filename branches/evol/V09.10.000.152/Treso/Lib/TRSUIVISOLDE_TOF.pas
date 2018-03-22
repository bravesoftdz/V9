{-------------------------------------------------------------------------------------
  Version   |  Date   | Qui |   Commentaires
--------------------------------------------------------------------------------------
   1.01        19/01/04  JP   Cr�ation de l'unit�
 1.05.001      19/03/04  JP   Probl�me dans l'affichage par solde : on faisait les totaux par banque
                              avant d'avoir remplir les soldes pour les jours sans mouvement.
 1.2X.000      21/04/04  JP   Un certain nombre de fonctionnalit�s ont �t� remont�es dans l'anc�tre
                              avec la nouvelle gestion des natures et de l'�ch�ancier
 6.00.018      12/10/04  JP   Mise en place du suivi bancaire
 6.30.001.002  08/03/05  JP   FQ 10217 : gestion de la date d'op�ration lors de l'appel de la saisie.
                              ATTENTION : si on met en place le suivi hebdomadaire, il faudra prendre
                              des pr�cautions !!!! cf. UFicTableau.GetCurDate
 6.30.001.005  05/04/05  JP   FQ 10240 : modification du traitement sur la fiche de suivi bancaire
 6.30.001.007  18/04/05  JP   FQ 10237 : Gestion de la p�riodicit� sur les fiches de suivi
 6.50.001.002  01/06/05  JP   FQ 10250 : On ne g�re les comptes vides que s'il n'y a pas de filtre sur les comptes
 7.00.001.001  16/01/06  JP   FQ 10328 : Refonte de la gestion des devises
 6.53.001.003  31/01/06  JP   FQ 10335 : On ne g�re plus la fiche de suivi bancaire qu'en valeur
 7.09.001.001  11/08/06  JP   Gestion du Multi Soci�t�s
 7.09.001.001  22/08/06  JP   cr�ation des m�thodes ParSoldeMS et GetRequeteMS : en Multi soci�t�s, l'affichage
                              du suivi des soldes est simplifi� : pas de ruptures sur les natures et les banques
 7.09.001.001  31/10/06  JP   FQ 10338 : Dans le pr�visionnel on affiche les non point�es et les point�es
                              ult�rieurement => affichage de la date de rappro
 7.09.001.005  07/02/07  JP   Filtre sur les comptes du regroupement Tr�so
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s : Ajout de la clause dans la requ�te MS, le reste
                              est g�r� dans l'anc�tre
--------------------------------------------------------------------------------------}

unit TRSUIVISOLDE_TOF ;

interface

uses
  StdCtrls, Controls, Classes, UFicTableau,
  {$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  SysUtils, HCtrls, HEnt1, UTOB, Grids, Windows;

type
  TOF_TRSUIVISOLDE = class(FICTAB)
    procedure OnUpdate              ; override;
    procedure OnArgument(S : string); override;
  private
    procedure ParSoldeMS;
    function  GetRequeteMS(Cl1 : string) : string;
  protected
    cbCompte : THMultiValComboBox;

    {Ev�nements}
    procedure GeneralOnChange(Sender : TObject);
    procedure PopupSimulation(Sender : TObject); override;
    procedure bGraphClick    (Sender : TObject); override;
    function  IsCelulleReinit(Col, Row : Integer) : Boolean; override;
    {Clause where sur les banques et les comptes}
    function  GetWhereBqCpt : string; override;
    procedure DessinerCells(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState); override;
    procedure FormOnKeyDown  (Sender : TObject; var Key : Word; Shift : TShiftState); override;
  public
    function  CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean; override;
  end ;

function TRLanceFiche_TRSUIVISOLDE(Dom, Fiche, Range, Lequel, Arguments : string) : string;

implementation

uses
  ExtCtrls, Commun, TRSAISIEFLUX_TOF, UProcGen, Constantes, TRGRAPHBANCAIRE_TOF, HMsgBox,
  UProcSolde, Graphics, uTobDebug, ed_tools;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_TRSUIVISOLDE(Dom, Fiche, Range, Lequel, Arguments : string) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := FICTAB.FicLance(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  if ReadTokenSt(S) = 'SUIBQE' then TypeDesc := dsBancaire
                               else TypeDesc := dsSolde;
  inherited;
  LargeurCol := 100;
  InArgument := True;

  if TypeDesc = dsSolde then begin
    ListeRouge.Sorted := True;
    ListeRouge.Duplicates := dupIgnore;
  end

  else begin
    {31/01/06 : FQ 10335 : Soit l'on repense la gestion en op�ration, soit on ne traite pas
                le suivi bancaire en op�ration. Pour le moment, c'est la deuxi�me solution
                qui est retenue en attendant une analyse des donn�es � afficher en op�ration}
    SetControlVisible('LBAFFICHER1', False);
    SetControlVisible('DATEVAL'    , False);
    SetControlVisible('DATEOPE'    , False);
    {10/11/06 : Devant l'impossibilit� de g�rer les soldes point�s autour du 01/01 lorsqu'une semaine
                est � cheval sur le mill�sime, On cache le suivi bancaire Hebdomadaire (Vu avec OG, ce jour)}
    SetControlVisible('RBHEBDO'    , False);
  end;

  TRadioButton(GetControl('DATEVAL')).OnClick := CritereClick;
  cbDevise.OnChange := GeneralOnChange;
  cbCompte := THMultiValComboBox(GetControl('MCCOMPTE'));
  cbBanque.OnChange := GeneralOnChange;
  if TypeDesc = dsBancaire then begin
    SetPlusBancaire(cbBanque, 'PQ',  CODECOURANTS + ';' + CODETITRES + ';');
    {20/06/07 : On enl�ve le filtre �ventuel}
    cbCompte.Plus := '';
    {07/02/07 : On exclut les comptes courants de la combo}
    cbCompte.DataType := tcp_Bancaire;
  end;

  {07/02/07 : Filtre sur les dossiers du regroupement Tr�so}
  cbCompte.Plus := FiltreBanqueCp(THMultiValComboBox(GetControl('MCCOMPTE')).DataType, '', '');

  {Initialisation de la devise}
  Devise := V_PGI.DevisePivot;
  MajComboDevise(Devise);

  InArgument := False;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.GeneralOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  DevISO : string;
  NoDos  : string;
begin
  if UpperCase(TComponent(Sender).Name) = 'BANQUE' then begin
    DevIso := GetClauseIn(cbBanque.Value);
    {07/02/07 : Filtre sur les dossiers du regroupement Tr�so}
    if not (GetControl('REGROUPEMENT') as THMultiValComboBox).Tous then
      NoDos := GetControlText('REGROUPEMENT');
    cbCompte.Plus := FiltreBanqueCp(THMultiValComboBox(GetControl('MCCOMPTE')).DataType, '', NoDos);
    {01/06/05 : FQ 10250 : Mise en place d'une gestion plus coh�rente !! des filtres sur les comptes}
    {Si on est dans un affichage par solde, on filtre les comptes en fonction des banques choisies}
    if Trim(DevIso) <> '' then begin
      if (cbCompte.Plus = '') and (cbCompte.DataType = tcp_Tous) then
        cbCompte.Plus := 'BQ_BANQUE IN(' + DevIso + ')'
      else
        cbCompte.Plus := cbCompte.Plus + ' AND BQ_BANQUE IN(' + DevIso + ')'
    end;
    SetControlText('MCCOMPTE', '');

    {Par d�faut on r�cup�re la devise du premier compte trouv�}
    if cbCompte.Items.Count > 0 then begin
      Devise := RetDeviseCompte(cbCompte.Values[0]);
      {Mise � jour de la combo des devises}
      MajComboDevise(Devise);
    end;
  end
  else
    Devise := cbDevise.Value;

  if Devise = '' then Devise := V_PGI.DevisePivot;
  AssignDrapeau(TImage(GetControl('IDEV')), Devise);

  CritereClick(edDepart);
end;

{---------------------------------------------------------------------------------------}
function  TOF_TRSUIVISOLDE.CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean;
{---------------------------------------------------------------------------------------}
var
  Lib : string;
begin
  Result := inherited CommandeDetail(CurRow, TT);
  {Si on est sur une ligne de totalisation, on sort}
  if (CurRow[COL_NATURE] = '') or (CurRow[COL_NATURE] = na_Total)then Exit;
  {A cette date, il n'y a pas d'�criture, on n'affiche donc pas le d�tail}
  if (CurRow[PtClick.X] = '0') or (CurRow[PtClick.X] = '') then Exit;

  if CurRow[COL_CODE] = '' then Exit; {Sur banque}

  Lib := Grid.Cells[Grid.Col, 0] + '|' + CurRow[COL_CODE] + '|';
  if IsTresoMultiSoc and (ListeRouge.IndexOf(Lib) = -1) and (TypeDesc = dsSolde) then Exit;

  TT.SetString('GENERAL', CurRow[COL_CODE]);
  TT.SetString('CODE', CurRow[COL_TYPE]);
  TT.SetString('DATEOPE', sDateOpe);
  TT.SetInteger('APPEL', Ord(TypeDesc));
  TT.SetInteger('PERIODICITE', Ord(Periodicite));
  TT.SetString('LIBNAT', LibNature);
  TT.SetDateTime('DATEDEB', ColToDate(PtClick.X - COL_DATEDE));
  TT.SetDateTime('DATEFIN', ColToDate(PtClick.X - COL_DATEDE, True));

  Lib := Copy(CurRow[COL_LIBELLE], 1, Pos('(', CurRow[COL_LIBELLE]) - 1);
  if rbDateOpe.Checked then Lib := Lib + ' (en date d''op�ration) '
                       else Lib := Lib + ' (en date de valeur) ';

  {Suivi des soldes}
  if TypeDesc = dsSolde then begin
    Lib := 'Op�rations sur le compte ' + Lib;
    TT.SetString('LIBELLE', Lib);
    if IsTresoMultiSoc then begin
      if Nature <> '' then
        //TT.SetString('NATURE', 'AND TE_NATURE IN (' + GetClauseIn(Nature) + ')')
        TT.SetString('NATURE', Nature)
      else
        TT.SetString('NATURE', '');
    end
    else
      TT.SetString('NATURE', 'AND TE_NATURE = "' + CurRow[COL_NATURE] + '"');
  end
  {Suivi bancaire}
  else begin
    {S'il n'y a pas de mouvement sur ce jour-l�}
    if ((CurRow[COL_NATURE] = na_Prevision) and (Valeur(Grid.Cells[Grid.Col, Grid.Row]) = 0)) or
       ((CurRow[COL_NATURE] <> na_Prevision) and (ListeRouge.IndexOf(Grid.Cells[Grid.Col, 0] + '|' + CurRow[COL_CODE] + '|' + CurRow[COL_NATURE] + '|') = -1)) then Exit;
    TT.SetString('TYPE', CurRow[COL_NATURE]);
    {G�n�ration du libell�}
    if CurRow[COL_NATURE] = na_Estime then
      TT.SetString('LIBELLE', 'Liste des �critures du compte ' + Lib)
    else if CurRow[COL_NATURE] = na_Pointe then begin
      TT.SetString('LIBELLE', 'Rapprochement(s)') {FQ 10240};
      TT.SetString('DATEOPE', 'TE_DATERAPPRO');
      TT.SetString('DATEAFF', sDateOpe);
    end
    else if CurRow[COL_NATURE] = na_Prevision then begin
      TT.SetString('LIBELLE', '�critures non point�es du compte ' + Lib);
      {31/10/06 : FQ 10338 : On affiche la date de rappro puisque les �critures affich�es sont le non point�es
                  mais aussi les �critures dont la date de rappro est > � la date de valeur}
      TT.SetString('DATEAFF', 'TE_DATERAPPRO');
    end;
    TT.SetString('NATURE', Nature);
  end;

  Result := True;
end;

{JP 27/10/03 : Lancement de l'�cran de saisie des �critures de simulation
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.PopupSimulation(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  General : string;
begin
  inherited;
  General := Grid.Cells[COL_CODE, Grid.Row];
  {08/03/05 : FQ 10217 : se positionner sur la date d'op�ration, si on est en date d'op�ration}
  TRLanceFiche_SaisieFlux('TR', 'TRSAISIEFLUX', '', '', General + ';;' + DateCourante + ';');
end;


{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.OnUpdate ;
{---------------------------------------------------------------------------------------}
var
  Q      : TQuery;
  SQL    : string;
  I      : Integer;
  sCpt,
  Tmp1   : string;
  wBanque: string;
  wDate  : string;
  sNat   : string;
begin
  inherited;
  {31/01/06 : FQ 10335 : Dans l'imm�diat, on ne g�re plus le suivi bancaire en op�ration}
  if TypeDesc = dsBancaire then begin
    if rbDateOpe.Checked then rbDateOpe.Checked := False;
    sDateOpe := 'TE_DATEVALEUR';
    {10/11/06 : on emp�che le suivi bancaire hebdomadaire}
    if Periodicite = tp_7 then rbQuoti.Checked := True;  
  end;

  sNat := GetControlText('MCNATURE');
  if (Pos('<<' , sNat) = 0) and (Trim(sNat) <> '') then
    Nature := 'AND TE_NATURE IN (' + GetClauseIn(sNat) + ')'
  else
    Nature := '';

  wDate  := '(' + sDateOpe + ' >= "' + UsDateTime(DateDepart) + '" AND ' + sDateOpe + ' <= "' + UsDateTime(DateFin) + '") ';

  {Constitution du filtre sur les comptes}
  if cbCompte.Value <> '' then begin
    sCpt := ' AND TE_GENERAL IN (';
    Tmp1 := GetClauseIn(cbCompte.Value);
    sCpt := sCpt + Tmp1 + ') ';
  end;

  if (cbBanque.Value <> '') then begin
    wBanque := 'AND BQ_BANQUE IN (';
    Tmp1 := GetClauseIn(cbBanque.Value);
    if (TypeDesc = dsSolde) and IsTresoMultiSoc then
      {22/08/06 : En multi soci�t�s pas de jointure sur BANQUES}
      wBanque := wBanque + Tmp1 + ') '
    else
      wBanque := wBanque + Tmp1 + ') AND PQ_BANQUE IN (' + Tmp1 + ') ';
  end
  else
    wBanque := '';

  Tmp1 := wBanque + sCpt;

  if TypeDesc = dsSolde then begin
    if IsTresoMultiSoc then SQL := GetRequeteMS(' WHERE ' + wDate + Tmp1)
                       else SQL := GetRequete(' WHERE ' + wDate + Tmp1);
  end
  else
    SQL := GetRequete(' WHERE ' + wDate + Tmp1);

  Q := OpenSQL(SQL, True);
  TobListe.LoadDetailDB('1', '', '', Q, False, True);
  Ferme(Q);

  {05/04/05 : FQ 10240 : Ajout d'une deuxi�me requ�te sur les �critures raproch�es}
  if (TypeDesc = dsBancaire) and Assigned(TobRappro) then begin
    wDate := '(TE_DATERAPPRO >= "' + UsDateTime(DateDepart) + '" AND TE_DATERAPPRO <= "' + UsDateTime(DateFin) + '") ';
    {Pour que l'order by se fasse sur la date de rappro}
    sNat     := sDateOpe;
    sDateOpe := 'TE_DATERAPPRO';
    try
      SQL := GetRequete(' WHERE ' + wDate + Tmp1);
    finally
      sDateOpe := sNat;
    end;

    Q := OpenSQL(SQL, True);
    TobRappro.LoadDetailDB('2', '', '', Q, False, True);
    Ferme(Q);
  end;

  if TypeDesc = dsSolde then begin
    if IsTresoMultiSoc then ParSoldeMs
                       else ParSolde;
  end
  else
    ParPointage;

  Grid.ColCount := COL_DATEDE + NbColonne;

  {Formatage des montant : '#,##0.00'; Euros}
  SQL := StrFMask(CalcDecimaleDevise(Devise), '', True);
  {Formatage des dates}
  for I := COL_DATEDE to COL_DATEDE + NbColonne - 1 do
    Grid.ColFormats[I] := SQL;

  TobGrid.PutGridDetail(Grid, True, True, '', True);

  Grid.Cells[COL_LIBELLE, 0] := '';

  {Gestion du s�parateur de ligne par solde entre chaque banque}
  for i := 0 to Grid.RowCount - 1 do
    if Grid.Cells[COL_TYPE, i] = '*' then Grid.RowHeights[i] := 3
                                     else Grid.RowHeights[i] := 18; {16/07/05 : dans certains cas, on a des �ffets inattendus}

  SQL := 'Suivi des soldes ';
  if not MultiNature then begin
         if Pos('"' + na_Realise    + '"', Nature) > 0 then LibNature := ' r�alis�s'
    else if Pos('"' + na_Simulation + '"', Nature) > 0 then LibNature := ' de simulation'
                                                       else LibNature := ' pr�visionnels';
    SQL := SQL + ' (flux' + LibNature + ')';
  end
  else
    LibNature := '';

  if TypeDesc = dsSolde then
    Ecran.Caption := TraduireMemoire(SQL)
  else
    Ecran.Caption := TraduireMemoire('Fiche de suivi bancaire');
  UpdateCaption(Ecran);

  Grid.Col := COL_DATEDE;
  Grid.Row := Grid.FixedRows;
  Grid.SetFocus;
end ;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVISOLDE.IsCelulleReinit(Col, Row : Integer) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := inherited IsCelulleReinit(Col, Row);
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVISOLDE.GetWhereBqCpt : string;
{---------------------------------------------------------------------------------------}
begin
  {13/06/05 : FQ 10250 : On ne g�re plus les comptes vides que sur les comptes du filtre}
  Result := inherited GetWhereBqCpt;
  if cbCompte.Value <> '' then begin
    Result := 'BQ_CODE IN (';
    Result := Result + GetClauseIn(cbCompte.Value);
    Result := Result + ')';
  end

  {13/06/05 : FQ 10250 : sinon sur les banques, s'il n'y a pas de filtre sur les comptes}
  else if cbBanque.Value <> '' then begin
    Result := 'BQ_BANQUE IN (';
    Result := Result + GetClauseIn(cbBanque.Value);
    Result := Result + ')';
  end
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.bGraphClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  Titre  : string;
  sSolde : string;
  sDev   : string;
  n, p   : Integer;
  T, D   : TOB;
  sGraph : string;
  Ch     : Char;
begin
  if TypeDesc = dsSolde then
    inherited
  else begin
    if cbCompte.NbSelected <> 1 then begin
      HShowMessage('0;' + Ecran.Caption + ';Veuillez ne s�lectionner qu''un seul compte.;W;O;O;O;', '', '');
      Exit;
    end;
    sSolde := cbCompte.Value;
    sSolde := RechDom('TRBANQUECP', ReadTokenSt(sSolde), False);
    Titre := TraduireMemoire('�volution du rapprochement bancaire : ' + sSolde);

    if rbDateOpe.Checked then sSolde := 'Les montants sont calcul�s en date d''op�ration'
                         else sSolde := 'Les montants sont calcul�s en date de valeur';
    sDev  := 'Les montants sont �xprim�s en ' + cbDevise.Items[cbDevise.ItemIndex];

    {Constitution de la chaine qui servira aux param�tres de "LanceGraph"}
    sGraph := 'DATE;ESTIME;POINTE';

    {Constitution de la tob des flux}
    T := Tob.Create('$$$', nil, -1);

    for n := COL_DATEDE to Grid.ColCount - 1 do begin
      D := Tob.Create('$$$', T, -1);
      D.AddChampSup('DATE', False);
      D.AddChampSup('ESTIME', False);
      D.AddChampSup('POINTE', False);
      D.PutValue('DATE', Grid.Cells[n, 0]);
      for p := 1 to Grid.RowCount - 1 do begin
        Ch := StrToChr(Grid.Cells[COL_NATURE, p]);
        {Les lignes contenant les soldes des comptes}
        if Ch = na_Estime then
          D.PutValue('ESTIME', Grid.Cells[n, p])
        else if Ch = na_Pointe then
          D.PutValue('POINTE', Grid.Cells[n, p]);
      end;
    end;

    {!!! Mettre sGraph en fin � cause des ";" qui traine dans la chaine}
    TRLanceFiche_TRGRAPHBANCAIRE(Titre + ';' + sDev + ';' + sSolde + ';' + sGraph, T);
    T.ClearDetail;
    FreeAndNil(T);

  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVISOLDE.GetRequeteMS(Cl1: string): string;
{---------------------------------------------------------------------------------------}
var
  TmpREI : string;
  s      : string;
  whConf : string;
begin
  TmpREI := '';
  {S'il y a un filtre sur les natures, il ne faut pas qu'il s'applique sur les �critures de r�initialisation}
  if Trim(Nature) <> '' then begin
    TmpREI := Copy(Nature, Pos('AND', Nature) + 4, Length(Nature));
    TmpREI := ' AND ((' + TmpREI + ') OR TE_QUALIFORIGINE = "' + CODEREINIT + '") '
  end;

  whConf := GetWhereConfidentialite;
  
  s := GetWhereDossier;
  if s <> '' then s := ' AND ' + s;
  TmpREI := TmpREI + s;

  Result := 'SELECT TE_NODOSSIER, TE_GENERAL, ' + sDateOpe + ', MAX(TE_DEVISE) ADEVISE, SUM(' + ChpMontant + ') MONTANT,' +
        ' DOS_LIBELLE LIBDOSSIER, BQ_LIBELLE LIBCPT, BQ_NATURECPTE FROM TRECRITURE' +
        ' LEFT JOIN BANQUECP ON TE_GENERAL = BQ_CODE' +
        ' LEFT JOIN DOSSIER ON TE_NODOSSIER = DOS_NODOSSIER' + Cl1 + TmpRei + whConf + 
        ' GROUP BY TE_NODOSSIER, BQ_NATURECPTE, ' + sDateOpe + ', TE_GENERAL, BQ_LIBELLE, DOS_LIBELLE' +
        ' ORDER BY TE_NODOSSIER, BQ_NATURECPTE, DOS_LIBELLE, TE_GENERAL, ' + sDateOpe
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.ParSoldeMS;
{---------------------------------------------------------------------------------------}
var
  aTob,
  TobL,
  TobG : TOB;
  MntTmp   : Double; {20/11/03}
  txConv   : Double;
  NbDec    : Integer;
  lSociete : string;
  CodeSoc  : string;
  General  : string;
  {L�GENDE DES TYPES : "LibSoci�t�" = Ligne contenant le solde d'un compte 
                       ""           = Ligne contenant le libell� d'une soci�t�
                       "*"          = Ligne de s�paration entre deux soci�t�s
                       "+"          = Solde total d'une soci�t�
                       "-"          = Solde g�n�ral
  }

    {------------------------------------------------------------------}
    procedure CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux, Nat : string);
    {------------------------------------------------------------------}
    var
      n : Integer;
    begin
      TobG := TOB.Create('', TobGrid, -1);
      TobG.AddChampSupValeur('TYPE', TypeFlux);
      TobG.AddChampSupValeur('CODE', CodeFlux);
      TobG.AddChampSupValeur('NATURE'  , Nat);
      TobG.AddChampSupValeur('LIBELLE', LibelleFlux);
      for n := 0 to NbColonne - 1 do {Ajout des colonnes dates}
        TobG.AddChampSupValeur(RetourneCol(n), '');
    end;

    {-------------------------------------------------------------------------}
    procedure SommerSociete(SocOk : Boolean = False);
    {-------------------------------------------------------------------------}
    var
      N   : Integer;
      S   : string;
      Mnt : Double;
      UsD : string;
    begin
      MntTmp := 0.0;
      Mnt    := 0.0;

      {Cumule chaque colonne date pour le type flux courant}
      for N := 0 to NbColonne - 1 do begin
        S := RetourneCol(n);

        {Gestion du solde forc� au premier janvier, dans la mesure o� l'on n'est pas sur un total banque}
        if IsColAvecSoldeInit(n) and not SocOk then begin {JP 28/11/05 : FQ 10317 : IsColAvecSoldeInit}
          if Periodicite = tp_7 then UsD := USDateTime(DebutAnnee(ColToDate(n + 1)))
                                else UsD := USDateTime(DebutAnnee(ColToDate(n)));

          if ExisteSQL('SELECT TE_GENERAL FROM TRECRITURE WHERE TE_DATEVALEUR = "' + UsD +
                       '" AND TE_GENERAL = "' + General{lSociete{GENE} + '" AND TE_QUALIFORIGINE = "' + CODEREINIT + '"') then begin
            {JP 28/11/05 : FQ 10317 : chaque type d'affichage demande une gestion sp�cifique du solde d'initialisation
                           Quotidien : on r�cup�re le solde du 01/01 au soir et on le met dans la colonne du 01/01
                           Hebdomadaire : r�cup�ration du solde du 01/01 au matin (ColToDate(n + 1) pour �tre s�r de
                                          prendre la bonne ann�e auquel on ajoute les op�rations comprises entre le
                                          01/01 et la fin de la semaine contenant le 01/01 (GetlOpeDebAnnee)
                           Mensuel : r�cup�ration du solde au 01/01 au matin auquel on rajoute toutes les op�rations
                                     du mois de janvier}
            {04/05/06 : FQ 10343 : Gestions des soldes initiaux : GetSoldeMillesime
                        Suite au probl�me rencontr� avec THermocompact, je mets en dernier param�tre IsMntPivot
                        plut�t que True, car � la diff�rence de la 6.53, txConv n'est plus calcul� lorsque l'on
                        travaille avec TE_MONTANTDEV, or en mettant true, on demande un montant en euro alors que
                        tous les autres montants sont en devise. Le probl�me doit �tre le m�me dans ParPointage }
            if Periodicite = tp_1 then
              Mnt := GetSoldeMillesime(General, DateToStr(ColToDate(n)), Nature, not rbDateOpe.Checked, False, IsMntPivot) * txConv
            else if Periodicite = tp_7 then
              Mnt := GetSoldeMillesime(General, DateToStr(ColToDate(n + 1)), Nature, not rbDateOpe.Checked, True, IsMntPivot) * txConv
            else
              Mnt := GetSoldeMillesime(General, DateToStr(ColToDate(n)), Nature, not rbDateOpe.Checked, True, IsMntPivot) * txConv;

            {Il y a un solde forc�}
            if StrFPoint(Mnt) <> '0.001' then begin
              {Pour mettre le solde en Bleu dans la grille}
              ListeRouge.Add(S + '|' + TobG.GetString('CODE') + '|');

              {JP 28/11/05 : FQ 10317 : GetlOpeDebAnnee renvoie 0 sauf en affichage hebdomadaire}
              Mnt := Mnt + GetlOpeDebAnnee(General{lSociete{GENE});
              {Sauf en affichage mensuel, on force le solde ainsi calcul�}
              if Periodicite <> tp_30 then TobG.SetDouble(S, Arrondi(Mnt, NbDec));
              MntTmp := Mnt;
              {JP 28/11/05 : FQ 10317 : en affichage mensuel, on ajoute au solde r�cup�r� toutes les op�rations du mois}
              if Periodicite <> tp_30 then Continue;
              Mnt := TobG.GetDouble(S);
              Mnt := MntTmp + Mnt;
            end;
          end;
        end
        (* 16/11/06 : je ne vois pas pourquoi j'avais mis cela qui a pour effets seconds de doubler
                      les montants sur les comptes non  mouvement�s sur la p�riode de s�lection  
        {On m�morise le montant des op�rations du premier jour}
        else if not SocOk and (N = 0) then begin
          Mnt := TobG.GetDouble(S);
          MntTmp := GetSoldeInit(General, DateToStr(ColToDate(n) {- 1}), Nature, not rbDateOpe.Checked, IsMntPivot);
          Mnt := MntTmp + Mnt;
        end
        *)
        {Calcul des totaux par compte}
        else if SocOk then
          Mnt := TobGrid.Somme(S, ['TYPE'], [CodeSoc], False)
        else begin
          Mnt := TobG.GetDouble(S);
          Mnt := MntTmp + Mnt;
        end;

        TobG.SetDouble(S, Arrondi(Mnt, NbDec));
        MntTmp := Mnt;
      end;
    end;

    {12/05/04 : Ajout des comptes de la banque pr�c�dante non mouvement�s sur la p�riodes
                mais appartenant � la s�lection}
    {-------------------------------------------------------------------------}
    procedure GererComptesAbsents;
    {-------------------------------------------------------------------------}
    begin
      if not Assigned(ListeCpte) then Exit;

      aTob := ListeCpte.FindFirst(['CODDOSSIER'], [CodeSoc], True);
      while aTob <> nil do begin
        {Cr�ation de la tob qui va contenir les soldes du compte non mouvement�}
        CreeTobDetail(CodeSoc, aTob.GetString('COMPTE'), RetourneNomLib(aTob.GetString('LIBELLE'), na_Total), aTob.GetString('BQ_NATURECPTE'));
        {28/11/05 : FQ 10317 : R�cup�ration et affectation du solde de d�part}
        GereSoldeDepart(TobG, aTob.GetString('COMPTE'), aTob.GetString('ADEVISE'), txConv);
        {On supprime ce compte, car il est possible que des banques n'est aucun compte mouvement�.
         A la fin de la boucle, on bouclera sur les comptes qui restent la Tob ListeCpte}
        SupprimeCptePresentMS(aTob.GetString('COMPTE'));
        aTob := ListeCpte.FindNext(['CODDOSSIER'], [CodeSoc], True);
      end;
    end;

var
  I, N    : Integer;
  S, Code : string;
  Montant : Double;
  LibCpte : string;
  DevTmp  : string;
begin
  {On vide la liste des soldes vides}
  ListeRouge.Clear;
  ColRouge := -1;

  Code     := '';
  General  := '';
  lSociete := '';

  {16/01/06 : FQ 10328 : On ne g�re le taux de conversion que si on travaille avec TE_MONTANT}
  txConv := 1;
  NbDec := CalcDecimaleDevise(Devise);
  if ChpMontant = 'TE_MONTANT' then
    txConv := RetContreTaux(V_PGI.DateEntree, V_PGI.DevisePivot, Devise);

  for I := 0 to TobListe.Detail.Count - 1 do begin
    TobL := TobListe.Detail[I];

    S := TobL.GetString('LIBDOSSIER');
    {Changement de Banque}
    if S <> lSociete then begin
      if lSociete <> '' then begin
        {12/05/04 : On ajoute les �ventuels comptes non mouvement�s de la banque en cours}
        GererComptesAbsents;

        {Cr�ation de la tob contenant le solde total de la banque}
        CreeTobDetail('+', CodeSoc, 'Total ' + lSociete, '');
        {Mise � jour du code de la banque pour GererComptesAbsents}
        CodeSoc := TobL.GetString('TE_NODOSSIER');
        {Cr�ation d'une tob fille vide pour s�parer les banques}
        CreeTobDetail('*', '', '', '');
      end;

      {Mise � jour du code de la banque pour GererComptesAbsents}
      CodeSoc := TobL.GetString('TE_NODOSSIER');

      lSociete := S;
      {Cr�ation de la tob contenant le libell� de la banque}
      CreeTobDetail('', '', lSociete, '');
      General := '';
    end;

    S := TobL.GetString('TE_GENERAL');

    {Nouveau compte}
    if General <> S then begin
      {Si on n'est pas sur la premi�re ligne ...}
      if General <> '' then begin
        // CALCUL DES SOLDES
      end;

      {Mise � jour du compte bancaire et de son libell�}
      General := S;

      {06/12/05 : remont� et non plus � la fin du For}
      DevTmp := TobL.GetString('ADEVISE'); {***}

      LibCpte := TobL.GetString('LIBCPT');
      {Cr�ation de la ligne de cumul des op�rations pour le nouveau compte et la nature en cours}
      CreeTobDetail(CodeSoc, General, RetourneNomLib(LibCpte, na_Total), TobL.GetString('BQ_NATURECPTE'));
      {R�cup�ration du solde de d�part}
      GereSoldeDepart(TobG, General, DevTmp, txConv);

      {On supprime le compte de la liste des comptes non mouvement�s}
      SupprimeCptePresentMS(General);
    end;

    S := GetTitreFromDate(TobL.GetDateTime(sDateOpe));
    {Dans la fourchette d'affichage}
    if (TobL.GetDateTime(sDateOpe) >= DateDepart) and (TobL.GetDateTime(sDateOpe) <= DateFin) then begin
      Montant := Arrondi(TobL.GetDouble('MONTANT') * txConv, NbDec);
      TobG.SetDouble(S, Montant + TobG.GetDouble(S));
      SetlOpeDebAnnee(General, Montant, TobL.GetDateTime(sDateOpe));
      ListeRouge.Add(S + '|' + TobG.GetString('CODE') + '|');
    end;
  end;{Boucle For}

  if lSociete <> '' then begin
    {12/05/04 : On ajoute les �ventuels comptes non mouvement�s de la banque en cours}
    GererComptesAbsents;

    {Pour la derni�re banque}
    CreeTobDetail('+', CodeSoc, 'Total ' + lSociete, '');
  end;

  {Ajout des soci�t�s non mouvement�es}
  if Assigned(ListeCpte)  then
    {12/05/04 : ajout des banques n'ayant que des comptes non mouvement�s}
    while ListeCpte.Detail.Count > 0 do begin
      CodeSoc  := ListeCpte.Detail[0].GetString('CODDOSSIER');
      lSociete := ListeCpte.Detail[0].GetString('LIBDOSSIER');

      {Cr�ation d'une tob fille vide pour s�parer les Soci�t�s}
      CreeTobDetail('*', '', '', '');
      {Cr�ation de la tob contenant le libell� de la soci�t�}
      CreeTobDetail('', '', ListeCpte.Detail[0].GetString('LIBDOSSIER'), '');
      {On ajoute les comptes de la banque}
      GererComptesAbsents;
      {Pour la derni�re banque}
      CreeTobDetail('+', CodeSoc, 'Total ' + lSociete, '');
    end;

  {16/04/04 : Gestion des soldes des comptes, on part du solde initial auquel on ajoute les op�rations du jours}
  for I := 1 to TobGrid.Detail.Count-1 do begin
    TobG := TobGrid.Detail[I];
    if (TobG.GetString('TYPE') = '*') or (TobG.GetString('TYPE') = '') then Continue;
    if TobG.GetString('TYPE') = '+' then begin
      CodeSoc := TobG.GetString('CODE');
      SommerSociete(True);
    end else begin
      General := TobG.GetString('CODE');
      SommerSociete(False);
    end;
  end;

  {Totaux g�n�raux}
  CreeTobDetail('-', '', TraduireMemoire('Solde g�n�ral'), '');
  MntTmp := 0.0;
  for n := 0 to NbColonne - 1 do begin
    {D�finition de la colonne du mill�sime}
    if IsColAvecSoldeInit(n) then ColRouge := COL_DATEDE + n; {28/11/05 : FQ 10317}
    S := RetourneCol(n);
    Montant := TobGrid.Somme(S, ['TYPE'], ['+'], False);
    if Montant <> 0 then TobG.SetDouble(S, Arrondi(Montant, NbDec))
                    else TobG.SetDouble(S, Arrondi(MntTmp , NbDec));
    if Montant <> 0 then MntTmp := Montant;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.DessinerCells(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState);
{---------------------------------------------------------------------------------------}
var
  S, sType : string;
begin
  if IsTresoMultiSoc and (TypeDesc = dsSolde) then begin

    S := Grid.Cells[Col, Row];
    sType := Grid.Cells[COL_TYPE, Row];

    with Grid.Canvas do begin
      {On est sur des totaux}
      if (sType = '+') or (sType = '-') then begin
        if V_PGI.NumAltCol = 0 then Brush.Color := clInfoBk
                               else Brush.Color := AltColors[V_PGI.NumAltCol];
        {Solde g�n�ral, par solde}
        if sType = '-' then begin
          Font.Style := [fsBold];
          Brush.Color := clBtnFace;
        end
      end
      else if (Grid.Cells[COL_NATURE, Row] <> na_Total) and (Grid.Cells[COL_NATURE, Row] <> '') then begin
        {Gestion du type de compte}
             if Grid.Cells[COL_NATURE, Row] = tcb_Bancaire then Brush.Color := clBleuLight
        else if Grid.Cells[COL_NATURE, Row] = tcb_Courant  then Brush.Color := clCremePale
        else if Grid.Cells[COL_NATURE, Row] = tcb_Titre    then Brush.Color := clOrangePale;
        if (Col >= COL_DATEDE) then begin
          {Gestion du signe du solde}
               if (Valeur(S) > 0) then Font.Color := clGreen {Solde positif}
          else if (Valeur(S) < 0) then Font.Color := clRed; {Solde n�gatif}
          {Gestion des c�llules mouvement�es}
          S := Grid.Cells[Col, 0] + '|' + Grid.Cells[COL_CODE, Row] + '|';
          if (ListeRouge.IndexOf(S) > -1) then
            Font.Style := [fsBold];
          {Gestion des montants de r�initialisation}
          if IsColAvecSoldeInit(Col - COL_DATEDE) then
            Font.Color := clBlue;
        end;
      end;

    end; {With Canvas}
  end

  else
    {Soit d�tail des soldes en Tr�so multi soci�t�s, soit Suivi des soldes en mono soci�t�,
    on reprend le code de UFicTableau}
    inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVISOLDE.FormOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{---------------------------------------------------------------------------------------}
var
  I : Integer;

    {-----------------------------------------------------------------------}
    function Reached(Col, Row: Integer): Boolean;
    {-----------------------------------------------------------------------}
    var
      S : string;
    begin
      S := Grid.Cells[Col, 0] + '|' + Grid.Cells[COL_CODE, Row] + '|';
      Result := (ListeRouge.IndexOf(S) > -1);
    end;
begin
  if IsTresoMultiSoc and (TypeDesc = dsSolde) and (Shift = [ssCtrl]) then begin
    case Key of
      VK_RIGHT : for I := Grid.Col + 1 to Grid.ColCount - 1 do
		   if Reached(I, Grid.Row) then	begin
		      Grid.Col := I;
		      Key := 0;
                      Break;
		    end;

      VK_LEFT :	for I := Grid.Col - 1 downto COL_DATEDE do
		  if Reached(I, Grid.Row) then	begin
                    Grid.Col := I;
                    Key := 0;
                    Break;
                  end;
      VK_DOWN : for I := Grid.Row + 1 to Grid.RowCount - 3 do
                  if Reached(Grid.Col, I) then begin
                    Grid.Row := I;
                    Break;
                  end;
      VK_UP : for I := Grid.Row - 1 downto 2 do
                if Reached(Grid.Col, I) then begin
                  Grid.Row := I;
                  Break;
                end;
    end;
  end;
  inherited;
end;

initialization
  RegisterClasses([TOF_TRSUIVISOLDE]);

end.

