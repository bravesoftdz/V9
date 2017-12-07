{-------------------------------------------------------------------------------------
  Version   |  Date   | Qui |   Commentaires
--------------------------------------------------------------------------------------
7.06.001.001  08/08/06  JP   Cr�ation de l'unit� : suivi global au niveau du groupe (ensemble des
                             soci�t�s) de tous les types de comptes (bancaires, courants, Titres) et
                             ce de mani�re globalis�e : 1 ligne par soci�t� et par type de compte
7.06.001.001  09/11/06  JP   FQ 10256 : D�placement des soldes initiaux au 01/01 au MATIN
7.06.001.001  16/11/06  JP   Gestion des comptes absents 
--------------------------------------------------------------------------------------}

unit TRSUIVIGROUPE_TOF;

interface

uses
  StdCtrls, Controls, Classes, UFicTableau,
  {$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  SysUtils, HCtrls, HEnt1, UTOB, Grids, Windows;

type
  TOF_TRSUIVIGROUPE = class(FICTAB)
    procedure OnUpdate              ; override;
    procedure OnArgument(S : string); override;
  private
    procedure SupprimeLignePresente(Soc, Nat : string);
  protected
    {Ev�nements}
    procedure bGraphClick    (Sender : TObject); override;
    function  IsCelulleReinit(Col, Row : Integer) : Boolean; override;
    procedure DessinerCells  (Sender : TObject; Col, Row : Integer; Rect : TRect; State : TGridDrawState); override;
    procedure FormOnKeyDown  (Sender : TObject; var Key : Word; Shift : TShiftState); override;
    procedure DeviseOnChange (Sender : TObject);
    {Clause where sur les banques et les comptes}
    function  GetWhereBqCpt : string; override;
    procedure ParGroupes;
    function  GetLibelle(Lib, Nat : string) : string;
  public
    function  CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean; override;
  end ;

function TRLanceFiche_TRSUIVIGROUPE(Arg : string): string;

implementation

uses
  ExtCtrls, Commun, UProcGen, UProcSolde, Constantes, TRSUIVISOLDE_TOF, HMsgBox,
  uTobDebug, Graphics, UtilPgi, AglInit;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_TRSUIVIGROUPE(Arg : string): string;
{---------------------------------------------------------------------------------------}
begin
  Result := FICTAB.FicLance('TR', 'TRSUIVIGROUPE', '', '', Arg);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  TypeDesc := dsGroupe;
  inherited;
  Ecran.HelpContext := 5000150;
  LargeurCol := 100;
  InArgument := True;

  ListeRouge.Sorted := True;
  ListeRouge.Duplicates := dupIgnore;

  TRadioButton(GetControl('DATEVAL')).OnClick := CritereClick;

  {Initialisation de la devise}
  Devise := V_PGI.DevisePivot;
  cbDevise.OnChange := DeviseOnChange;
  MajComboDevise(Devise);

  InArgument := False;
  {09/11/06 : Pas le temps de fair un graph pour le moment}
  SetControlVisible('BGRAPH', False);
end;

{Appel de la fiche de suivi de solde correspondant � la ligne en cours
{---------------------------------------------------------------------------------------}
function  TOF_TRSUIVIGROUPE.CommandeDetail(CurRow : HTStrings; var TT : TOB) : Boolean;
{---------------------------------------------------------------------------------------}
var
  s : string;
  Q : TQuery;
begin
  {False, pour ne pas lancer le d�tail des flux}
  Result := inherited CommandeDetail(CurRow, TT);

  {L�GENDE DES TYPES : "NODOSSIER" = Ligne contenant le solde d'une nature de compte
                       ""          = Ligne contenant le libell� d'une soci�t�
                       "*"         = Ligne de s�paration entre deux banques
                       "+"         = Total g�n�ral
                       "-"         = Total par nature de compte
                CODES  "+"         = solde total d'une soci�t� avec TYPE = "NODOSSIER"
                       "NATCPTE"   = Ligne contenant le solde d'une nature de compte
                       }

  {Si on est sur une ligne de de libell�, on sort}
  if CurRow[COL_CODE] = '' then Exit;

  if (CurRow[COL_TYPE] = '-') or (CurRow[COL_TYPE] = '+') then
    TT.SetString('REGROUP', '')
  else
    TT.SetString('REGROUP', CurRow[COL_TYPE]);
  TT.SetString('CODE'   , CurRow[COL_CODE]);
  TT.SetString('TYPE'   , CurRow[COL_TYPE]);
  TT.SetString('NATURE' , GetControlText('MCNATURE'));
  TT.SetString('DATEOPE', sDateOpe);
  TT.SetString('DEVISE' , Devise);
  TT.SetString('INTERVAL', GetControlText('INTERVAL'));
  TT.SetInteger('PERIODICITE', Ord(Periodicite));
  TT.SetInteger('APPEL'      , Ord(TypeDesc));
  TT.SetDateTime('DATEDEB', ColToDate(PtClick.X - COL_DATEDE));
  TT.SetDateTime('DATEFIN', ColToDate(PtClick.X - COL_DATEDE, True));
  {On n'affichera que les comptes correspondant � la nature de la ligne courante :
   le filtre va se faire avec la banque}
  if CurRow[COL_CODE] = tcb_Titre then
    {On affiche que la banque "comptes titres"}
    TT.SetString('BANQUE', CODETITRES)
  else if CurRow[COL_CODE] = tcb_Courant then
    {On affiche que la banque "comptes courants"}
    TT.SetString('BANQUE', CODECOURANTS)
  else if CurRow[COL_CODE] = tcb_Bancaire then begin
    {On affiche que les banques "normales"}
    s := cbBanque.Value;
    {Si pas de banque, on prend toutes les banques autre que titre et courant}
    if s = '' then begin
      Q := OpenSQL('SELECT PQ_BANQUE FROM BANQUES WHERE NOT (PQ_BANQUE IN ("' + CODETITRES + '","' + CODECOURANTS + '"))', True);
      while not Q.EOF do begin
        s := s + Q.FindField('PQ_BANQUE').AsString + ';';
        Q.Next;
      end;
      Ferme(Q);
    end
    {Sinon suppression �ventuelle des banques Titre et Courant}
    else begin
      s := FindEtReplace(s, CODETITRES, '', True);
      s := FindEtReplace(s, CODECOURANTS, '', True);
      s := FindEtReplace(s, ';;', ';', True);
    end;

    TT.SetString('BANQUE', s);
  end
  else
    {On est sur une ligne de total soci�t�, on affichera tous les comptes de la soci�t�}
    TT.SetString('BANQUE' , cbBanque.Value);

  TheTob := TT;

  {Rafraichissement en cas de modifications}
  if TRLanceFiche_TRSUIVISOLDE('TR', 'TRSUIVISOLDE', '', '', 'SOLDE;')  <> '' then
    MouetteClick;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.OnUpdate ;
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
  end;

  sNat := GetControlText('MCNATURE');
  if (Pos('<<' , sNat) = 0) and (Trim(sNat) <> '') then
    Nature := 'AND TE_NATURE IN (' + GetClauseIn(sNat) + ')'
  else
    Nature := '';

  wDate  := '(' + sDateOpe + ' >= "' + UsDateTime(DateDepart) + '" AND ' + sDateOpe + ' <= "' + UsDateTime(DateFin) + '") ';

  {12/05/04 : Cr�ation de la liste des comptes
   24/01/06 : Fait dans le OnLoad suite � la FQ 10328
  CreerListeCompte;}
  if (cbBanque.Value <> '') then begin
    wBanque := 'AND BQ_BANQUE IN (';
    Tmp1 := GetClauseIn(cbBanque.Value);
    wBanque := wBanque + Tmp1 + ') ';
  end
  else
    wBanque := '';

  Tmp1 := wBanque + sCpt;
  SQL := GetRequete(' WHERE ' + wDate + Tmp1);

  Q := OpenSQL(SQL, True); 
  TobListe.LoadDetailDB('1', '', '', Q, False, True);
  Ferme(Q);

  ParGroupes;

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

  SQL := 'Suivi du groupe ';
  if not MultiNature then begin
         if Pos('"' + na_Realise    + '"', Nature) > 0 then LibNature := ' r�alis�s'
    else if Pos('"' + na_Simulation + '"', Nature) > 0 then LibNature := ' de simulation'
                                                       else LibNature := ' pr�visionnels';
    SQL := SQL + ' (flux' + LibNature + ')';
  end
  else
    LibNature := '';

  Ecran.Caption := TraduireMemoire(SQL);
  UpdateCaption(Ecran);

  Grid.Col := COL_DATEDE;
  Grid.Row := Grid.FixedRows;
  Grid.SetFocus;
end ;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIGROUPE.IsCelulleReinit(Col, Row : Integer) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := inherited IsCelulleReinit(Col, Row);
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIGROUPE.GetWhereBqCpt : string;
{---------------------------------------------------------------------------------------}
begin
  {13/06/05 : FQ 10250 : On ne g�re plus les comptes vides que sur les comptes du filtre}
  Result := inherited GetWhereBqCpt;
  {13/06/05 : FQ 10250 : sinon sur les banques, s'il n'y a pas de filtre sur les comptes}
  if cbBanque.Value <> '' then begin
    Result := 'BQ_BANQUE IN (';
    Result := Result + GetClauseIn(cbBanque.Value);
    Result := Result + ')';
  end
end;

{09/11/06 : FQ 10256 : Refonte de la qu�te des soldes 
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.ParGroupes;
{---------------------------------------------------------------------------------------}
var
  TobL,
  TobG : TOB;
  lSociete : string;
  MntTmp   : Double;
  CodeSoc  : string;
  txConv   : Double;
  NbDec    : Integer;
  {L�GENDE DES TYPES : "NODOSSIER" = Ligne contenant le solde d'une nature de compte
                       ""          = Ligne contenant le libell� d'une soci�t�
                       "*"         = Ligne de s�paration entre deux banques
                       "+"         = Total g�n�ral
                       "-"         = Total par nature de compte
                CODES  "+"         = solde total d'une soci�t� avec TYPE = "NODOSSIER"
                       "NATCPTE"   = Ligne contenant le solde d'une nature de compte
                       }

    {------------------------------------------------------------------}
    procedure CreeTobDetail(CodSoc, NatC, LibLig, Nat : string; Ind : Integer = -1);
    {------------------------------------------------------------------}
    var
      n : Integer;
    begin
      TobG := TOB.Create('', TobGrid, Ind);
      TobG.AddChampSupValeur('TYPE', CodSoc);
      TobG.AddChampSupValeur('CODE', NatC);
      TobG.AddChampSupValeur('NATURE'  , Nat);
      TobG.AddChampSupValeur('LIBELLE', LibLig);
      for n := 0 to NbColonne - 1 do {Ajout des colonnes dates}
        TobG.AddChampSupValeur(RetourneCol(n), '');
    end;

    {JP 19/03/04 : Le traitement de SommerBanque a �t� sorti pour pouvoir �tre
                   ex�cut� plus tard
    {-------------------------------------------------------------------------}
    procedure CreeTobTotal;
    {-------------------------------------------------------------------------}
    begin
      CreeTobDetail(CodeSoc, '+', GetLibelle(lSociete, na_Total), '');
    end;

    {-------------------------------------------------------------------------}
    procedure SetMontant(Chp : string; Val : Double);
    {-------------------------------------------------------------------------}
    begin
      TobG.SetDouble(Chp, Arrondi(Val, NbDec));
    end;

    {-------------------------------------------------------------------------}
    procedure CalculTotal(Nat : string);
    {-------------------------------------------------------------------------}
    var
      N   : Integer;
      S   : string;
      Mnt : Double;
    begin
      MntTmp := 0.0;

      {Cumule chaque colonne date pour le type flux courant}
      for N := 0 to NbColonne - 1 do begin
        S := RetourneCol(n);
        {Calcul des totaux par soci�t�}
        if CodeSoc <> '' then
          Mnt := TobGrid.Somme(S, ['TYPE', 'NATURE'], [CodeSoc, na_Total], False) {Total par soci�t�}
        else
          Mnt := TobGrid.Somme(S, ['CODE', 'NATURE'], [Nat, na_Total], False); {Total par nature}

        if Mnt <> 0 then SetMontant(S, Mnt)
                    else SetMontant(S, MntTmp);
        MntTmp := Mnt;
        SetMontant(S, MntTmp);
      end;
    end;

    {Cr�ation et calcul des totaux g�n�raux 
    {-------------------------------------------------------------------------}
    procedure GererTotaux(Nat : string);
    {-------------------------------------------------------------------------}
    begin
      if Nat = na_Total then begin
        CreeTobDetail('+', Nat, TraduireMemoire('Total g�n�ral'), na_Total);
        CodeSoc := '-';
        CalculTotal('');
      end
      else begin
        CodeSoc := '';  {Par pr�caution !}
        if TobGrid.FindFirst(['CODE'], [Nat], True) <> nil then begin
          CreeTobDetail('-', Nat, GetLibelle('Total', Nat), na_Total);
          CalculTotal(Nat);
        end;
      end;
    end;

    {-------------------------------------------------------------------------}
    procedure CalculeSoldes;
    {-------------------------------------------------------------------------}
    var
      N   : Integer;
      S   : string;
      Mnt : Double;
      UsD : string;
    begin
      if not Assigned(TobG) then Exit;
      MntTmp := 0;

      for N := 0 to NbColonne - 1 do begin
        S := RetourneCol(n);

        {Gestion du solde forc� au premier janvier, dans la mesure o� l'on n'est pas sur un total banque}
        if IsColAvecSoldeInit(n) then begin 
          {On m�morise le montant des op�rations du premier jour}
          Mnt := TobG.GetDouble(S);
          {M�morisation des cellules mouvement�s}
          if Mnt <> 0 then ListeRouge.Add(S + '|' + TobG.GetString('TYPE') + '|' + TobG.GetString('CODE')+ '|');

          if Periodicite = tp_7 then UsD := USDateTime(DebutAnnee(ColToDate(n + 1)))
                                else UsD := USDateTime(DebutAnnee(ColToDate(n)));

          {JP 28/11/05 : FQ 10317 : chaque type d'affichage demande une gestion sp�cifique du solde d'initialisation
                         Quotidien : on r�cup�re le solde du 01/01 au matin et on ajoute les op�rations du 01/01
                         Hebdomadaire : r�cup�ration du solde du 01/01 au Matin (ColToDate(n + 1) pour �tre s�r de
                                        prendre la bonne ann�e auquel on ajoute les op�rations comprises entre le
                                        01/01 et la fin de la semaine contenant le 01/01 (MntHebdo)
                         Mensuel : r�cup�ration du solde au 01/01 au matin auquel on rajoute toutes les op�rations
                                   du mois de janvier}
          if Periodicite = tp_1 then
            MntTmp := GetSoldeNatureCompte(TobG.GetString('TYPE'), TobG.GetString('CODE'), DateToStr(ColToDate(n)), Nature, cbBanque.Value, not rbDateOpe.Checked, True)
          else if Periodicite = tp_7 then
            MntTmp := GetSoldeNatureCompte(TobG.GetString('TYPE'), TobG.GetString('CODE'), DateToStr(ColToDate(n + 1)), Nature, cbBanque.Value, not rbDateOpe.Checked, True)
          else
            MntTmp := GetSoldeNatureCompte(TobG.GetString('TYPE'), TobG.GetString('CODE'), DateToStr(ColToDate(n)), Nature, cbBanque.Value, not rbDateOpe.Checked, True);
          {Conversion en devise d'affichage}
          MntTmp := MntTmp * txConv;

          {Sauf en affichage mensuel, on force le solde ainsi calcul�}
          if Periodicite = tp_7 then begin
            MntTmp := MntTmp + GetlOpeDebAnnee(TobG.GetString('TYPE') + '|' + TobG.GetString('CODE'));
            SetMontant(S, MntTmp);
          end
          else begin
            MntTmp := MntTmp + Mnt;
            SetMontant(S, MntTmp);
          end;
        end
        else if N = 0 then begin
          {On m�morise le montant des op�rations du premier jour}
          Mnt := TobG.GetDouble(S);
          {M�morisation des cellules mouvement�s}
          if Mnt <> 0 then ListeRouge.Add(S + '|' + TobG.GetString('TYPE') + '|' + TobG.GetString('CODE')+ '|');
          {Calcul du solde initial}                                                                              {***}
          MntTmp := GetSoldeNatureCompte(TobG.GetString('TYPE'), TobG.GetString('CODE'), DateToStr(DateDepart - 1), Nature, cbBanque.Value, not rbDateOpe.Checked, False);
          {Conversion en devise d'affichage}
          MntTmp := MntTmp * txConv;
          {Ajout les op�rations du jour au solde calcul�}
          MntTmp := MntTmp + Mnt;
          {Mise � jour du montant}
          SetMontant(S, MntTmp);
        end
        else begin
          {R�cup�ration des op�rations du jour}
          Mnt := TobG.GetDouble(S);
          {M�morisation des cellules mouvement�s}
          if Mnt <> 0 then ListeRouge.Add(S + '|' + TobG.GetString('TYPE') + '|' + TobG.GetString('CODE')+ '|');
          {Ajout les op�rations de la p�riode au solde de la p�riode pr�c�dente}
          MntTmp := Mnt + MntTmp;
          SetMontant(S, MntTmp);
        end;
      end;
    end;


    {Gestion des nature non mouvement�es
    {-------------------------------------------------------------------------}
    procedure GererDossiersAbsents;
    {-------------------------------------------------------------------------}
    var
      F : TOB;
      T : TOB;

          {---------------------------------------------------------------}
          procedure CreeLigneSolde(Typ : string; Ind : Integer = -1);
          {---------------------------------------------------------------}
          var
            s : string;
          begin
            s := cbBanque.Value;
            {On s'assure que le filtre sur les banques rend utile la cr�ation de la ligne}
            if s <> '' then begin
              if s[Length(s)] <> ';' then s := s + ';';
              {Si la banque des comptes courants ne fait pas partie de la s�lection ...}
              if (Typ = tcb_Courant) and (Pos(CODECOURANTS, s) = 0) then Exit;
              {Si la banque des comptes titres ne fait pas partie de la s�lection ...}
              if (Typ = tcb_Titre  ) and (Pos(CODETITRES  , s) = 0) then Exit;
              {Si seuls les comptes titres ou / et courants sont dans le filtre, on
               n'affiche pas de ligne pour les comptes bancaires}
              if (Typ = tcb_bancaire) and
                 ((s = CODECOURANTS + ';') or (s = CODETITRES + ';') or
                  (s = CODECOURANTS + ';' + CODETITRES + ';') or
                  (s = CODETITRES + ';' + CODECOURANTS + ';')) then Exit;
            end;
            CreeTobDetail(CodeSoc, Typ, GetLibelle('', Typ), na_Total, Ind);
            CalculeSoldes;
          end;

          {---------------------------------------------------------------}
          function GetIndexTob(NC : string) : Integer;
          {---------------------------------------------------------------}
          begin
            Result := -1;
            F := TobGrid.FindFirst(['LIBELLE'], [lSociete], True);
            {Ne devrait th�oriquement pas arriv�}
            if Assigned(F) then begin
                   if NC = tcb_Bancaire then Result := F.GetIndex + 1
              else if NC = tcb_Courant  then Result := F.GetIndex + 2
                                        else Result := F.GetIndex + 3
            end;
          end;

    begin
      if not Assigned(ListeCpte) then Exit;

      T := ListeCpte.FindFirst(['CODDOSSIER'], [CodeSoc], True);
      while T <> nil do begin
        CreeLigneSolde(T.GetString('BQ_NATURECPTE'));
        {Cr�ation de la tob qui va contenir les soldes du compte non mouvement�}
        //CreeTobDetail(CodeSoc, T.GetString('COMPTE'), RetourneNomLib(T.GetString('LIBELLE'), na_Total), T.GetString('BQ_NATURECPTE'));
        {28/11/05 : FQ 10317 : R�cup�ration et affectation du solde de d�part}
        ///GereSoldeDepart(TobG, aTob.GetString('COMPTE'), aTob.GetString('ADEVISE'), txConv);
        {On supprime ce compte, car il est possible que des banques n'est aucun compte mouvement�.
         A la fin de la boucle, on bouclera sur les comptes qui restent la Tob ListeCpte}
        SupprimeLignePresente(CodeSoc, T.GetString('BQ_NATURECPTE'));
        T := ListeCpte.FindNext(['CODDOSSIER'], [CodeSoc], True);
      end;
      (*
      for n := 0 to ListeCpte.Detail.Count - 1 do begin
        F := ListeCpte.Detail[n];
        if not Assigned(F) then begin
          lSociete := Q.FindField('DOS_LIBELLE').AsString;
          CreeTobDetail('', '', lSociete, '');
          {Cr�ation de la ligne des comptes bancaires}
          CreeLigneSolde(tcb_Bancaire);
          {Cr�ation de la ligne des comptes courants}
          CreeLigneSolde(tcb_Courant);
          {Cr�ation de la ligne des comptes Titres
          CreeLigneSolde(tcb_Titre);}
          {Cr�ation de la tob contenant le solde total du dossier}
          CreeTobTotal;
          {Cr�ation d'une tob fille vide pour s�parer les banques}
          CreeTobDetail('*', '', '', '');
          Q.Next;
          Continue;
        end;
        *)
        {
        lSociete := Q.FindField('DOS_LIBELLE').AsString;

        F := TobGrid.FindFirst(['TYPE', 'CODE'], [Q.FindField('DOS_NODOSSIER').AsString, tcb_Bancaire], True);
        if not Assigned(F) then
          CreeLigneSolde(tcb_Bancaire, GetIndexTob(tcb_Bancaire));

        F := TobGrid.FindFirst(['TYPE', 'CODE'], [Q.FindField('DOS_NODOSSIER').AsString, tcb_Courant], True);
        if not Assigned(F) then
          CreeLigneSolde(tcb_Courant, GetIndexTob(tcb_Courant));

        {F := TobGrid.FindFirst(['TYPE', 'CODE'], [Q.FindField('DOS_NODOSSIER').AsString, tcb_Titre], True);
        if not Assigned(F) then
          CreeLigneSolde(tcb_Titre, GetIndexTob(tcb_Titre));
        
      end;}
    end;

var
  I       : Integer;
  NatCpte : string;
  S, Code : string;
  Montant : Double;
begin
  {On vide la liste des soldes vides}
  ListeRouge.Clear;
  ColRouge := -1;

  Code    := '';
  NatCpte := '';
  lSociete := '';
  TobL    := nil;

  {16/01/06 : FQ 10328 : On ne g�re le taux de conversion que si on travaille avec TE_MONTANT}
  txConv := RetContreTaux(V_PGI.DateEntree, V_PGI.DevisePivot, Devise);
  NbDec := CalcDecimaleDevise(Devise);

  for I := 0 to TobListe.Detail.Count - 1 do begin
    TobL := TobListe.Detail[I];

    S := TobL.GetString('DOS_LIBELLE');
    {Changement de soci�t�}
    if S <> lSociete then begin
      if lSociete <> '' then begin
        GererDossiersAbsents;
        {Calcule les soldes � partir des montants mis dans la grille}
        CalculeSoldes;
        {Cr�ation de la tob contenant le solde total du dossier}
        CreeTobTotal;
        {Cr�ation d'une tob fille vide pour s�parer les banques}
        CreeTobDetail('*', '', '', '');
      end;

      {Mise � jour du code de la banque pour GererComptesAbsents}
      CodeSoc := TobL.GetString('BQ_NODOSSIER');

      lSociete := S;
      {Cr�ation de la tob contenant le libell� de la banque}
      CreeTobDetail('', '', lSociete, '');
      NatCpte := '';
    end;

    S := TobL.GetString('BQ_NATURECPTE');

    {Nouvelle nature de compte}
    if NatCpte <> S then begin
      {Si on n'est pas sur la premi�re ligne ...}
      if NatCpte <> '' then begin
        {Calcule les soldes � partir des montants mis dans la grille}
        CalculeSoldes;
      end;

      {Mise � jour du compte bancaire et de son libell�}
      NatCpte := S;
      {Cr�ation de la ligne de cumul des op�rations pour le nouveau compte et la nature en cours}
      CreeTobDetail(CodeSoc, NatCpte, GetLibelle('', NatCpte), na_Total);
      {Suppression des lignes trait�es}
      SupprimeLignePresente(CodeSoc, NatCpte);
    end;

    S := GetTitreFromDate(TobL.GetDateTime(sDateOpe));
    {Dans la fourchette d'affichage}
    if (TobL.GetDateTime(sDateOpe) >= DateDepart) and (TobL.GetDateTime(sDateOpe) <= DateFin) then begin
      Montant := TobL.GetDouble('MONTANT') * txConv;
      SetMontant(S, Montant + TobG.GetDouble(S));
      SetlOpeDebAnnee(CodeSoc + '|' + NatCpte, Montant, TobL.GetDateTime(sDateOpe));
    end;
  end;{Boucle For}

  if lSociete <> '' then begin
    {Calcule les soldes � partir des montants mis dans la grille}
    CalculeSoldes;
    {Mise � jour du code de la banque pour GererComptesAbsents}
    CodeSoc := TobL.GetString('BQ_NODOSSIER');
    GererDossiersAbsents;
    {Pour la derni�re banque}
    CreeTobTotal;
    {Cr�ation d'une tob fille vide pour s�parer les banques}
    CreeTobDetail('*', '', '', '');
  end;
/////////////////////
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
      GererDossiersAbsents;
      {Pour la derni�re banque}
      CreeTobDetail('+', CodeSoc, 'Total ' + lSociete, '');
    end;

  {16/04/04 : Gestion des soldes des comptes, on part du solde initial auquel on ajoute les op�rations du jours}
  CodeSoc := '';
  for I := 1 to TobGrid.Detail.Count - 1 do begin
    TobG := TobGrid.Detail[I];
    if (TobG.GetString('CODE') <> '+') or (TobG.GetString('TYPE') = '') then Continue;
    CodeSoc := TobG.GetString('TYPE');
    CalculTotal('');
  end;

  {Totaux g�n�raux}
  CreeTobDetail('', '', TraduireMemoire('Totaux g�n�raux'), '');
  GererTotaux(tcb_Bancaire);
  GererTotaux(tcb_Courant);
  GererTotaux(tcb_Titre);
  GererTotaux(na_Total);
//  TobDebug(TobGrid);
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIGROUPE.GetLibelle(Lib, Nat: string): string;
{---------------------------------------------------------------------------------------}
begin
       if Nat = tcb_Titre    then Result := Lib + ' Cptes titres'
  else if Nat = tcb_Bancaire then Result := Lib + ' Cptes bancaires'
  else if Nat = tcb_Courant  then Result := Lib + ' Cptes courants'
  else if Nat = na_Total     then Result := 'Total ' + Lib
  else Result := Lib;
end;


{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.bGraphClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  (*
var
  Titre  : string;
  sSolde : string;
  sDev   : string;
  n, p   : Integer;
  T, D   : TOB;
  sGraph : string;
  Ch     : Char;
begin
  (*
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
  *)
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.DessinerCells(Sender : TObject; Col, Row : Integer; Rect : TRect; State : TGridDrawState);
{---------------------------------------------------------------------------------------}
var
  S     : string;
  sType : string;
  sCode : string;
begin
  inherited;
  S := Grid.Cells[Col, Row];
  sType := Grid.Cells[COL_TYPE, Row];
  sCode := Grid.Cells[COL_CODE, Row];
  with Grid.Canvas do begin
    {Ligne s�lectionn�e}
    if gdSelected in State then begin
      Brush.Color := clHighLight;
      Font.Color := clHighLightText;
    end

    {Ligne de libell� des dossiers}
    else if sType = '' then begin
      Font.Style := [fsBold];
      Brush.Color := clBleuLight;//clUltraLight;
    end

    {Ligne de s�paration}
    else if sType = '*' then
      Brush.Color := clCremePale

    {On est sur des soldes}
    else if (sType = '+') or (sCode = '+') then begin
      if V_PGI.NumAltCol = 0 then Brush.Color := clInfoBk
                             else Brush.Color := AltColors[V_PGI.NumAltCol];
      Font.Style := [fsBold];
    end

    {Ligne de solde ou total pour une nature}
    else begin
      Brush.Color := clUltraCreme;
      {Gestion de la couleur de la fonte en fonction du sens du solde}
      if (Col >= COL_DATEDE) then begin
             if (Valeur(S) > 0) then Font.Color := clGreen {Solde positif}
        else if (Valeur(S) < 0) then Font.Color := clRed; {Solde n�gatif}
      end;
      {Gestion des c�llules mouvement�es}
      sCode := Grid.Cells[Col, 0] + '|' + Grid.Cells[COL_TYPE, Row] + '|' + Grid.Cells[COL_CODE, Row] + '|';
      if (ListeRouge.IndexOf(sCode) > -1) then
        Font.Style := [fsBold];
      {Gestion des montants de r�initialisation}
      if IsColAvecSoldeInit(Col - COL_DATEDE) then
        Font.Color := clBlue;
    end
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.FormOnKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
{---------------------------------------------------------------------------------------}
var
  I : Integer;
  {-----------------------------------------------------------------------}
  function Reached(Col, Row: Integer): Boolean;
  {-----------------------------------------------------------------------}
  begin
    {True si on est sur une ligne de solde par nature de compte}
    Result := (Grid.Cells[Col, Row] <> '') and
              (Grid.Cells[COL_TYPE, Row] <> '*') and
              (Grid.Cells[COL_TYPE, Row] <> '+') and
              (Grid.Cells[COL_CODE, Row] <> '+') and
              (Grid.Cells[COL_TYPE, Row] <> '-');
    Result := Result and (ListeRouge.IndexOf(Grid.Cells[Col, 0] + '|' +
                                             Grid.Cells[COL_TYPE, Row] + '|' +
                                             Grid.Cells[COL_CODE, Row] + '|') > -1);

  end;

begin
  if (Shift = [ssCtrl]) then begin
    case Key of
      VK_RIGHT : for I := Grid.Col + 1 to Grid.ColCount - 1 do
                   {Si la date appartient � la liste c'est qu'il y a des �critures}
                   if Reached(I, Grid.Row) then begin
                     Grid.Col := I;
                     Key := 0;
                     Exit;
                   end;

      VK_LEFT : for I := Grid.Col - 1 downto COL_DATEDE do
                  {Si la date appartient � la liste c'est qu'il y a des �critures}
                   if Reached(I, Grid.Row) then begin
                    Grid.Col := I;
                    Key := 0;
                    Exit;
                  end;
    end;
  end;

  FormKeyDown(Sender, Key, Shift); // Pour touches standard AGL
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.DeviseOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  Devise := cbDevise.Value;
  if Devise = '' then Devise := V_PGI.DevisePivot;
  AssignDrapeau(TImage(GetControl('IDEV')), Devise);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIGROUPE.SupprimeLignePresente(Soc, Nat : string);
{---------------------------------------------------------------------------------------}
var
  T : TOB;
begin
  if not Assigned(ListeCpte) then Exit;
  T := ListeCpte.FindFirst(['CODDOSSIER', 'BQ_NATURECPTE'], [Soc, Nat], True);
  if T <> nil then FreeAndNil(T);
end;

initialization
  RegisterClasses([TOF_TRSUIVIGROUPE]);

end.

