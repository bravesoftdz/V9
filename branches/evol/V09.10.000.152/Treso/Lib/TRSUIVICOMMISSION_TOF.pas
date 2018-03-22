{Source de la tof TRSUIVICOMMISSION
--------------------------------------------------------------------------------------
  Version    |  Date   | Qui |   Commentaires
--------------------------------------------------------------------------------------
  0.91         06/11/03  JP   cr�ation de l'unit�
 1.50.000.000  22/04/04  JP   Nouvelle gestion des natures (OnUpdate, ModifierLibelle)
 6.30.001.007  18/04/05  JP   FQ 10237 : La gestion est remont�e dans l'anc�tre
 8.01.001.015  14/05/07  JP   FQ 10460 : R�cup�ration de la nature pour le d�tail des bases
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s : Modification de la requ�te et ajout de BANQUECP
--------------------------------------------------------------------------------------}

unit TRSUIVICOMMISSION_TOF;

interface

uses
  StdCtrls, Controls, Classes, UFicTableau,
  {$IFNDEF EAGLCLIENT}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  SysUtils, HCtrls, HEnt1, UTOB, Grids, UProcGen, Windows;

type
  TOF_TRSUIVICOMMISSION = class (FICTAB)
    procedure OnUpdate              ; override;
    procedure OnArgument(S : string); override;
  protected
    sTypeMnt   : string;
    RecCptOk   : Boolean;
    DepCptOk   : Boolean;

    cbGeneral  : THValComboBox;
    cbNature   : THMultiValComboBox;

    TableRouge : array [0..30] of Char;

    {M�thodes}
    function  Afficher       (Clause : string): Boolean;
    {Ev�nements}
    procedure GeneralOnChange(Sender : TObject);
    procedure PopupSimulation(Sender : TObject); override;
    procedure bGraphClick    (Sender : TObject); override;
    procedure DessinerCells  (Sender : TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState); override;
  public
    function  CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean; override;
  end ;

function TRLanceFiche_TrSuiviCommission(Dom, Fiche, Range, Lequel, Arguments : string) : string;

implementation

uses
  ExtCtrls, AGLInit, Commun, TRSAISIEFLUX_TOF, Constantes,
  Graphics, HMsgBox, UProcCommission, TRGRAPHCOMMISSION_TOF;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_TrSuiviCommission(Dom, Fiche, Range, Lequel, Arguments : string) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := FICTAB.FicLance(Dom, Fiche, Range, Lequel, Arguments);
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  TypeDesc := dsCommission;
  inherited;
  LargeurCol := 137;

  InArgument := True;

  cbGeneral := THValComboBox(GetControl('GENERAL'));
  cbGeneral.OnChange := GeneralOnChange;
  cbGeneral.Plus := FiltreBanqueCp(cbGeneral.DataType, '', '');

  {Initialisation de la devise}
  Devise := V_PGI.DevisePivot;

  cbGeneral.DataType := 'TRBANQUECP';

  Nature := S;

  InArgument := False;
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.GeneralOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  Gen : string;
begin
  Gen := GetControlText('GENERAL');
  if Trim(Gen) <> '' then Devise := RetDeviseCompte(Gen)
                     else Devise := V_PGI.DevisePivot;
  if Devise = '' then Devise := V_PGI.DevisePivot;
  AssignDrapeau(TImage(GetControl('IDEV')), Devise);
  SetControlCaption('DEV', Devise);
  CritereClick(Sender);
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVICOMMISSION.CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean;
{---------------------------------------------------------------------------------------}
var
  Lib : string;
  Code : string;
begin
  Result := inherited CommandeDetail(CurRow, TT);
  {Code flux}
  if (CurRow[PtClick.X] = '') or ((Length(CurRow[COL_TYPE]) <= 1) and (CurRow[COL_CODE] <> '�')) then Exit; {Pas de montant}

  Code := CurRow[COL_CODE];
  Code := Copy(Code, 1, Length(Code) - 1);
  if CurRow[COL_CODE] = '�' then
    Lib := 'Flux soumis � commissions de mouvement'
  else
    Lib := ' "' + RechDom('TRCODEFLUX', Code, False) + '"';

  if Periodicite = tp_30 then Lib := Lib + ' pour le mois de ' + AnsiLowerCase(Grid.Cells[Grid.Col, 0])
                         else Lib := Lib + ' pour la p�riode ' + AnsiLowerCase(Grid.Cells[Grid.Col, 0]);

  TT.SetString('GENERAL', cbGeneral.Value);
  TT.SetString('CODE', Code);
  TT.SetString('DATEOPE', 'TE_DATEVALEUR');
  TT.SetInteger('APPEL', Ord(TypeDesc));
  TT.SetInteger('PERIODICITE', Ord(Periodicite));
  TT.SetString('LIBELLE', Lib);
  TT.SetDateTime('DATEDEB', ColToDate(PtClick.X - COL_DATEDE));
  TT.SetDateTime('DATEFIN', ColToDate(PtClick.X - COL_DATEDE, True));

  {Comme dans le d�tail il y a une jointure, il faut pr�fixer TE_NATURE}
  if Nature <> '' then
    {14/05/07 : FQ 10460 : MCNATURE c'est Mieux que NATURE}
    TT.SetString('NATURE', ' AND (T2.TE_NATURE IN (' + GetClauseIn(GetControlText('MCNATURE')) + ')) ')
  else
    TT.SetString('NATURE', '');

  if Grid.Cells[COL_CODE, Grid.Row] = '�' then
    TT.SetString('LIBNAT', suc_Divers)
  else
    TT.SetString('LIBNAT', CurRow[COL_NATURE]);
  Result := True;
end;

{Lancement de l'�cran de saisie des �critures de simulation
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.PopupSimulation(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  General : string;
begin
  inherited;
  GetPosition;
  {On est sur une colonne Date}
  if (PtClick.X >= COL_DATEDE) and (PtClick.Y > 0) then begin
    General := cbGeneral.Value; // ?
    if TRLanceFiche_SaisieFlux('TR', 'TRSAISIEFLUX', '', '', General + ';LIBRE;' + DateCourante + ';') <> '' then
      MouetteClick;
  end;
end;

{Constitution de la tob contenant les donn�es avant de la mettre dans la grille
{---------------------------------------------------------------------------------------}
function TOF_TRSUIVICOMMISSION.Afficher(Clause : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  TobL,
  TobG,
  TobA,
  TobT     : TOB;
  TypeFlux ,
  Mois     ,
  LibFlux  : string;

  {L�GENDE DES TYPES : "TypeFlux" = Ligne contenant le montant des commissions ou de leur base
                                    1/ Code : "CodeFlux" + "A" = montant de la base
                                    2/ Code : "CodeFlux" + "C" = montant des commissions
                       "*"        = Ligne de s�paration entre deux types de commissions (NATURE vide)
                                  = Ligne contenant les totaux g�n�raux (NATURE � "A" ou "S")
   L�GENDE DES CODES : "�"        = ligne contenant le titres des types de commission
                       "$"        = ligne contenant Le nom des commissions
                       "+"        = ligne contenant le total de la base pour un type de commission
                       "�"        = ligne contenant le total de la base pour les commissions de mouvements
                       "-"        = ligne contenant le total des commissions pour un type de commission
   L�GENDE DES NATURES : "C"      = Lignes concernant les commission
                         "A"      = Lignes concernant la base
                         ""       = lignes de titre et de s�paration}
    {-------------------------------------------------------------------------}
    procedure CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux, Nat : string; Base : Boolean = True);
    {-------------------------------------------------------------------------}
    var
      n : Integer;
      T : TOB;
    begin
      T := TOB.Create('', TobGrid, -1);
      T.AddChampSupValeur('TYPEFLUX', TypeFlux);
      T.AddChampSupValeur('CODEFLUX', CodeFlux);
      T.AddChampSupValeur('NATURE'  , Nat);
      T.AddChampSupValeur('LIBELLE' , LibelleFlux);
      {Ajout des colonnes dates avec montant}
      for n := 0 to NbColonne - 1 do
        T.AddChampSupValeur(RetourneCol(n), '');
      if Base then TobA := T
              else TobG := T;
    end;

    {-------------------------------------------------------------------------}
    procedure CreeTobTotal(Base : Boolean = False; Mvt : Boolean = False);
    {-------------------------------------------------------------------------}
    var
      n   : Integer;
      Mnt : Double;
    begin
      if Mvt then begin
        {Cr�ation de la tob total d'un type de flux}
        if Base then CreeTobDetail('', '�', TraduireMemoire('Base'), suc_AvecCom) {Pour la base}
                else CreeTobDetail('', '-', TraduireMemoire('Commissions'), suc_Commission, False);{Pour les commisssions}
      end
      else begin
        {Cr�ation de la tob total d'un type de flux}
        if Base then CreeTobDetail('', '+', TraduireMemoire('Total ' + LibFlux + ' (Base)'), suc_AvecCom) {Pour la base}
                else CreeTobDetail('', '-', TraduireMemoire('Total ' + LibFlux + ' (Com.)'), suc_Commission, False);{Pour les commisssions}
      end;

      {Sur les commissions de mouvement, il n'y a pas de totaux � faire}
      if Mvt then Exit;

      {Cumule chaque colonne date pour le type flux courant}
      for n := 0 to NbColonne - 1 do begin
        Mois := RetourneCol(n);
        {Cumul d'un type de flux}
        if Base then begin
          Mnt := TobGrid.Somme(Mois, ['TYPEFLUX', 'NATURE'], [TypeFlux + suc_AvecCom, suc_AvecCom], False);
          TobA.SetDouble(Mois, Mnt);
        end
        else begin
          Mnt := TobGrid.Somme(Mois, ['TYPEFLUX', 'NATURE'], [TypeFlux + suc_Commission, suc_Commission], False);
          TobG.SetDouble(Mois, Mnt);
        end;
      end;
    end;

var
  S, CodeFlux : string;
  I, NbEcrit  : Integer;
  Montant     : Double;
  MntBase     : Double;
  QQ          : TQuery;
  Obj         : TObjContrat;
  DtValeur    : TDateTime;
begin
  {Par d�faut on consid�re qu'il n'y a pas de d'imports comptables dans le r�sultat de la requ�te}
  RecCptOk := False;
  DepCptOk := False;

  TypeFlux := '';
  Result   := True;
  NbEcrit  := TobListe.Detail.Count;

  {********************************************************************}
  {******************  REMPLISSAGE DE LA TOB GRILLE  ******************}
  {********************************************************************}

  for I := 0 to NbEcrit - 1 do begin
    TobL := TobListe.Detail[I];
    {On a trait� toutes les commissions, on sort de la boucle}
    if TobL.GetString('TE_COMMISSION') = suc_AvecCom then Break;

    S := TobL.GetString('TFT_TYPEFLUX');
    {Changement de type flux}
    if S <> TypeFlux then begin
      if (TypeFlux <> '') then begin
        {Total de la base}
        CreeTobTotal(True);
        {Total des commissions}
        CreeTobTotal;
        {Ligne de s�paration entre deux types de flux}
        CreeTobDetail('*', '*', '', '');
      end;
      TypeFlux := S;
      LibFlux  := TobL.GetString('TTL_LIBELLE');
      {Ligne contenant le libell� des types de flux}
      CreeTobDetail('', '�', LibFlux, '');
    end;

    CodeFlux := TobL.GetString('TE_CODEFLUX');

    TobG := TobGrid.FindFirst(['CODEFLUX'], [CodeFlux + suc_Commission], True);
    TobA := TobGrid.FindFirst(['CODEFLUX'], [CodeFlux + suc_AvecCom], True);
    {Il sagit d'un nouveau flux, on cr�e une tob fille de la TobGrid}
    if TobG = nil then begin
      CreeTobDetail('', '$', TobL.GetString('TFT_LIBELLE'), '');
      {22/04/04 : La nature ne sert que pour le KeyDown dans l'imm�diat.
       21/01/05 : On ajoute suc_XX au TypeFlux pour �tre s�r que TYPEFLUX dans la TOB aura au moins une
                  longueur de deux caract�res => cf. CommandeDetail}
      CreeTobDetail(TypeFlux + suc_AvecCom, CodeFlux + suc_AvecCom, 'Base', suc_AvecCom);
      CreeTobDetail(TypeFlux + suc_Commission, CodeFlux + suc_Commission, 'Commissions', suc_Commission, False);
    end;

    Montant := Abs(TobL.GetDouble(sTypeMnt));
    DtValeur := TobL.GetDateTime('TE_DATEVALEUR');
    {On r�cup�re le titre de la colonne correspondant � la date de l'�criture}
    Mois := GetTitreFromDate(DtValeur);

    {Dans la fourchette d'affichage}
    if (DtValeur >= DateDepart) and (DtValeur < DateFin) then begin
      {On cumule la commission}
      Montant := Montant + Abs(TobG.GetDouble(Mois));
      TobG.SetDouble(Mois, Montant);
      {On recherche l'op�ration financi�re qui sert de base � la commission en cours}
      TobT := TobListe.FindFirst(['TE_NUMTRANSAC', 'TE_GENERAL', 'TE_COMMISSION'],
                                 [TobL.GetString('TE_NUMTRANSAC'), TobL.GetString('TE_GENERAL'), suc_AvecCom], True);

      if Assigned(TobT) then
        MntBase := Abs(TobT.GetDouble(sTypeMnt))
      else begin
        MntBase := 0.0;
        Result  := False;
      end;

      if Assigned(TobA) then begin
        MntBase := MntBase + Abs(TobA.GetDouble(Mois));
        TobA.SetDouble(Mois, MntBase);
      end
      else
        Result := False;
    end;
  end;{Boucle For}

  {S'il y a des �critures dasn la TobListe ...}
  if NbEcrit > 0 then begin
    {Cr�ation de la tob total pour le total des d�penses}
    CreeTobTotal(True);
    CreeTobTotal;
  end;

  {********************************************************************}
  {*************  GESTION DES COMMISSIONS DE MOUVEMENT ****************}
  {********************************************************************}

  TobG := nil;
  TobA := nil;

  {Les commissions de mouvements de sont pas stock�es dans la table, mais calcul�es � la vol�e
   en fonction du Boolean TFT_COMMOUVEMENT de la table FLUXTRESO : pour le d�tail cf. TofEchellesInt}
  {21/10/04 : Les jointures avec une vue ne sont pas recommand�es dans l'AGL : au cas o�, je garde le code
  S := 'SELECT TRECRITURE.TE_DATEVALEUR, TRECRITURE.' + sTypeMnt + ', FLUXTRESO.TFT_COMMOUVEMENT, ' +
       'TRECRITURE.TE_GENERAL FROM TRECRITURE, FLUXTRESO ' +
       'WHERE TE_CODEFLUX = TFT_FLUX AND TFT_COMMOUVEMENT = "X" ' + Clause;
  S := S + ' UNION SELECT TRECRITURE.TE_DATEVALEUR, TRECRITURE.' + sTypeMnt + ', RUBRIQUE.RB_CATEGORIE, ' +
       'TRECRITURE.TE_GENERAL FROM TRECRITURE, RUBRIQUE ' +
       'WHERE TE_CODEFLUX = RB_RUBRIQUE AND RB_CATEGORIE = "X" ' + Clause;
  }
  S := 'SELECT TRECRITURE.TE_DATEVALEUR, TRECRITURE.' + sTypeMnt + ', TRLISTEFLUX.TFT_COMMOUVEMENT, ' +
       'TRECRITURE.TE_GENERAL FROM TRECRITURE, TRLISTEFLUX, BANQUECP ' +
       'WHERE TE_CODEFLUX = TFT_FLUX AND TE_GENERAL = BQ_CODE AND TFT_COMMOUVEMENT = "X" ' + Clause + GetWhereConfidentialite;

  QQ := OpenSQL(S, True);
  try
    {S'il y a des op�rations soumise � la commission, on cr�e les TOB filles n�cessaires � la
     gestion des commissions de mouvements}
    if not QQ.EOF then begin
      if NbEcrit > 0 then
        {Ligne de s�paration entre deux types de flux}
        CreeTobDetail('*', '*', '', '');

      {Ligne contenant le titre "Commission de mouvement"}
      CreeTobDetail('', '�', 'Commissions de mouvements', '');

      {Cr�ation de la tob (sous forme de total car il est inutile de dupliquer les lignes) contenant
       les bases et les montants des commissions}
      CreeTobTotal(True, True);
      CreeTobTotal(False, True);
    end;

    Obj := TObjContrat.Create(DateDepart, DateFin, cbGeneral.Value);
    try
      while not QQ.EOF do begin
        MntBase := Abs(QQ.FindField(sTypeMnt).AsFloat);
        DtValeur := QQ.FindField('TE_DATEVALEUR').AsDateTime;
        {On r�cup�re le titre de la colonne correspondant � la date de l'�criture}
        Mois := GetTitreFromDate(DtValeur);

        {Dans la fourchette d'affichage}
        if (DtValeur >= DateDepart) and (DtValeur < DateFin) then begin
          {On cumule la Base}
          Montant := MntBase + TobA.GetDouble(Mois);
          TobA.SetDouble(Mois, Montant);
          {Calcul de la commission de mouvement}
          Montant := MntBase * Obj.GetComFromGene(QQ.FindField('TE_GENERAL').AsString, DtValeur) / 100 + TobG.GetDouble(Mois);
          TobG.SetDouble(Mois, Montant);
        end;
        QQ.Next;
      end;
    finally
      FreeAndNil(Obj);
    end;
  finally
    Ferme(QQ);
  end;

  {Aucune �criture n'a �t� trait�e pour les crit�res de s�lection, on sort}
  if TobGrid.Detail.Count = 0 then Exit;

  {********************************************************************}
  {*****************  GESTION DES MONTANTS TOTAUX *********************}
  {********************************************************************}

  {Cr�ation de la derni�re tob fille qui contiendra le solde total}
  CreeTobDetail('*', '', TraduireMemoire('Total g�n�ral (Base)'), suc_AvecCom);
  CreeTobDetail('*', '', TraduireMemoire('Total g�n�ral (Com.)'), suc_Commission, False);

  {Calcul des soldes des dates de la fourchette de s�lection}
  for I := 0 to NbColonne - 1 do begin
    Mois := RetourneCol(i);
    {On cumule tous les totaux Commission(-) et base (+)}
    Montant := TobGrid.Somme(Mois, ['CODEFLUX'], ['+'], False);
    TobA.SetDouble(Mois, Montant);
    Montant := TobGrid.Somme(Mois, ['CODEFLUX'], ['-'], False);
    TobG.SetDouble(Mois, Montant);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.OnUpdate ;
{---------------------------------------------------------------------------------------}
var
  Q      : TQuery;
  SQL    : string;
  I      : Integer;
  Clause : string;
  WhCrit : string;
begin
  inherited ;
  {Maj des devises}
  InArgument := True; {Pour ne pas lancer une recherche et faire une boucle sans fin}
  GeneralOnChange(cbGeneral);
  InArgument := False;

  Clause := 'AND TE_COMMISSION IN ("' + suc_Commission + '", "' + suc_AvecCom + '") AND TE_CODEFLUX <> "' + CODEREGULARIS + '" ';

  if cbGeneral.Value <> '' then begin
    WhCrit := ' AND TE_GENERAL="' + cbGeneral.Value + '" ';
    sTypeMnt := 'TE_MONTANTDEV';
  end
  else
    sTypeMnt := 'TE_MONTANT';

  if (GetControlText('MCNATURE') <> '') and (Pos('<<', GetControlText('MCNATURE')) = 0) then
    {Par contre si filtre sur la nature, il ne faut pas exclure les montants forc�s}
    Nature := 'AND (TE_NATURE IN (' + GetClauseIn(GetControlText('MCNATURE')) + ')) ' {23/02/05 : FQ 10208 : Oubli d'une parenth�se}
  else
    Nature := '';

  {29/07/04 : +/- 30 pour tenir compte du d�calage entre commissions et op�rations}
  WhCrit := WhCrit + Nature + ' AND TE_DATEVALEUR >= "' + UsDateTime(DateDepart - 30) + '" ' +
                              ' AND TE_DATEVALEUR <= "' + UsDateTime(DateFin + 30) + '" ';
  Clause := Clause + WhCrit + GetWhereConfidentialite;

  {21/01/05 : Remplacement de TE_NUMEROPIECE par TE_GENERAL, car s'il est possible de retrouver la base d'une
              commission � partir du num�ro de transaction et du num�ro de pi�ce avant l'int�gration, le changement
              du num�ro de pi�ce lors de l'int�gration rend la chose impossible ensuite. Par contre je pense que
              TE_NUMTRANSAC et TE_GENERAL doivent permettre de r�cup�rer � coup s�r la bases d'une commissions}
  SQL := 'SELECT TR.TE_DATEVALEUR, TR.TE_COMMISSION , TR.TE_CODEFLUX, TR.' +
        sTypeMnt + ', FL.TFT_FLUX, FL.TFT_TYPEFLUX, FL.TFT_LIBELLE, TR.TE_CLEVALEUR, ' +
       'TY.TTL_SENS, TY.TTL_LIBELLE, TR.TE_NUMTRANSAC, TR.TE_GENERAL ' +
       'FROM TRECRITURE TR, FLUXTRESO FL, TYPEFLUX TY, BANQUECP ' +
       'WHERE TE_CODEFLUX = TFT_FLUX AND TFT_TYPEFLUX = TTL_TYPEFLUX AND BQ_CODE = TE_GENERAL ' + Clause;
  SQL := SQL + ' UNION ALL ' +
       'SELECT TRE.TE_DATEVALEUR, TRE.TE_COMMISSION, TRE.TE_CODEFLUX, TRE.' +
       sTypeMnt + ', RUB.RB_RUBRIQUE TFT_FLUX, RUB.RB_TYPERUB TFT_TYPEFLUX, RUB.RB_LIBELLE TFT_LIBELLE, ' +
       'TRE.TE_CLEVALEUR, RUB.RB_SIGNERUB TTL_SENS, "' + CODETEMPO + '" TTL_LIBELLE, TRE.TE_NUMTRANSAC, ';
  SQL := SQL + 'TRE.TE_GENERAL FROM TRECRITURE TRE, RUBRIQUE RUB, BANQUECP ' +
       'WHERE TE_CODEFLUX = RB_RUBRIQUE  AND BQ_CODE = TE_GENERAL ' + Clause +
       ' ORDER BY TE_COMMISSION DESC, TFT_TYPEFLUX, TE_CODEFLUX';

  Q := OpenSQL(SQL, True);
  TobListe.LoadDetailDB('1', '', '', Q, False, True);
  Ferme(Q);

  if not Afficher(WhCrit) then
    HShowMessage('0;' + Ecran.Caption + ';Une erreur est intervenue lors du calcul des bases.'#13 +
                                        'Certains montants sont erron�s.;E;O;O;O;', '', '');

  Grid.ColCount := COL_DATEDE + NbColonne;

  {Formatage des montant : '#,##0.00'; Euros}
  SQL := StrFMask(CalcDecimaleDevise(Devise), '', True);
  {Formatage des dates}
  for I := COL_DATEDE to COL_DATEDE + NbColonne - 1 do
    Grid.ColFormats[I] := SQL;

  TobGrid.PutGridDetail(Grid, True, True, '', True);

  {Eventuelle r�duction de la hauteur de lignes de s�paration}
  for i := 0 to Grid.RowCount - 1 do
    if (Grid.Cells[COL_TYPE, i] = '*') and (Grid.Cells[COL_CODE, i] = '*') then
      Grid.RowHeights[i] := 3;

  Grid.Cells[COL_LIBELLE, 0] := '';
  Grid.ColWidths[COL_LIBELLE]:= 160;
  Grid.Col := COL_DATEDE;
  Grid.Row := Grid.FixedRows;
  Grid.SetFocus;
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.bGraphClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Titre  : string;
  sDev   : string;
  n, p   : Integer;
  T, D   : TOB;
  sGraph : string;
  Chp    : string;
begin
//  inherited;
  if (cbGeneral.Value = '') or ( Pos('>>', cbGeneral.Value) > 0) then begin
    Titre := 'Suivi des commissions';
    sDev  := 'Les montants sont �xprim�s en ' + RechDom('TTDEVISE', V_PGI.DevisePivot, False);
  end
  else begin
    Titre := 'Suivi des commissions du compte : ' + cbGeneral.Items[cbGeneral.ItemIndex];
    sDev  := 'Les montants sont �xprim�s en ' + RechDom('TTDEVISE', GetControlText('DEV'), False);
  end;

  {Constitution de la tob du graph}
  T := Tob.Create('$$$', nil, -1);
  try
    for n := COL_DATEDE to Grid.ColCount - 1 do begin
      {Les abscisses contiennent les mois qui sont plac�s en premi�re s�rie}
      D := Tob.Create('$$$', T, -1);
      D.AddChampSupValeur('MOIS', Grid.Cells[n, 0]);
      for p := 1 to Grid.RowCount - 2 do begin
        {On est sur le libell� d'un type de flux}
        if Grid.Cells[COL_CODE, p] = '�' then begin
          Chp := Grid.Cells[COL_LIBELLE, p];
          D.AddChampSup(Chp, False);
        end
        {On est sur un total par type de flux}
        else if Grid.Cells[COL_CODE, p] = '-' then
            D.PutValue(chp, Grid.Cells[n, p])
        {On est sur le total g�n�ral}
        else if (Grid.Cells[COL_CODE, p] = '*') and (Grid.Cells[COL_NATURE, p] = suc_Commission) then
          D.AddChampSupValeur('TOTAL', Grid.Cells[n, p]);
      end;
    end;

    if T.Detail.Count = 0 then Exit;

    {Constitution de la chaine qui servira aux param�tres de "LanceGraph"}
    for n := 0 to T.Detail[0].ChampsSup.Count - 1 do begin
      if sGraph <> '' then
        sGraph := sGraph + T.Detail[0].GetNomChamp(1000 + n) + ';'
      else
        sGraph := T.Detail[0].GetNomChamp(1000 + n) + ';';
    end;
    TheTOB := T;
    {!!! Mettre sGraph en fin � cause des ";" qui traine dans la chaine}
    TRLanceFiche_GraphCommission(Titre + ';' + sDev + ';' + sGraph);
  finally
    FreeAndNil(T);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVICOMMISSION.DessinerCells(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState);
{---------------------------------------------------------------------------------------}
var
  sNatu,
  sCode,
  sType : string;
begin
  inherited;
  with Grid.Canvas do begin
    {Lignes de valeurs}
    sType := Grid.Cells[COL_TYPE, Row];
    sCode := Grid.Cells[COL_CODE, Row];
    sNatu := Grid.Cells[COL_NATURE, Row];

    if gdSelected in State then begin
      Brush.Color := clHighLight;
      Font.Color := clHighLightText;
    end
    {Lignes de total g�n�ral ...}
    else if sType = '*' then begin
      {Total de commission}
      if sNatu = suc_Commission then begin
        Font.Style := [fsBold];
        Brush.Color := AltColors[V_PGI.NumAltCol];
      end
      {Total de base}
      else if sNatu = suc_AvecCom then begin
        Font.Style := [fsBold];
        Brush.Color := clUltraLight;
      end
      {Lignes de s�paration des types de flux}
      else
        Brush.Color := clVertMat;

    end
    {... Lignes de d�tail ...}
    else if sType <> '' then begin
      {D�tail de commission}
      if sNatu = suc_Commission then begin
        Brush.Color := clBleuLight;
        if Col >= COL_DATEDE then Font.Style := [fsBold];
      end
      {D�tail de base}
      else begin
        if Col >= COL_DATEDE then Font.Style := [fsBold];
      end;
    end
    {... Pour les autres lignes, cela se joue sur le code}
    else begin
      {Libell� type flux}
      if sCode = '�' then begin
        Font.Style := [fsBold];
        Brush.Color := clBtnFace;
      end
      {Libell� code flux}
      else if sCode = '$' then begin
        Brush.Color := clCremePale;
      end
      {Total base pour un type de flux}
      else if StrToChr(sCode) in ['+', '�'] then begin
        Brush.Color := clInfoBk;
        if (Col >= COL_DATEDE) and (sCode = '�') then Font.Style := [fsBold];
      end
      {Total commission pour un type de flux}
      else if sCode = '-' then begin
        Brush.Color := clUltraCreme;
      end
    end;

  end;
end;

initialization
  RegisterClasses([TOF_TRSUIVICOMMISSION]);

end.

