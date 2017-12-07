{Source de la tof TRSUIVIOPCVM
--------------------------------------------------------------------------------------
  Version    |  Date   | Qui |   Commentaires
--------------------------------------------------------------------------------------
 6.2X.000.000  04/11/04  JP   Cr�ation de l'unit�
 6.30.001.007  18/04/05  JP   FQ 10237 : Gestion de la p�riodicit� sur les fiches de suivi
 6.50.001.002  01/06/05  JP   FQ 10262 : La requ�te est mal g�n�r�e � cause du GetControlText
                              sur MCPORTEFEUILLE si on a << tous >> comme valeur
 7.09.001.010  27/03/07  JP   FQ 10416 : exclusion des op�rations du dernier jour de la p�riode de s�lection
 8.01.001.001  15/12/06  JP   FQ 10373 : Le nombres de part deviennent des Doubles et non plus des Integer
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s : Modification de la requ�te et ajout de BANQUECP
 8.10.001.012  02/10/07  JP   Branchement de l'�tat des rendements des portefeuilles
--------------------------------------------------------------------------------------}

unit TRSUIVIOPCVM_TOF;

interface

uses
  StdCtrls, Controls, Classes, UFicTableau,
  {$IFNDEF EAGLCLIENT}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF}
  SysUtils, HCtrls, HEnt1, UTOB, Grids, UProcGen, Windows;

type
  TOF_TRSUIVIOPCVM = class (FICTAB)
    procedure OnUpdate              ; override;
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
  private
    TobCours   : TOB; {Tob contenant les cours des opcvm}
    TobVente   : TOB; {Tob contenant les ventes d'opcvm, TobListe contenant les achats}

    function  GetFiltreOpcvm(Prefix : string) : string;
    function  GetFiltrePorte(Prefix : string) : string;
    function  GetFiltreNatur(Prefix : string) : string;
    function  IsMouvemente  (Col, Row : Integer) : Boolean;
  protected
    RecCptOk   : Boolean;
    DepCptOk   : Boolean;

    cbNature   : THMultiValComboBox;
    cbPortef   : THMultiValComboBox; {FQ 10262}
    cbOPCVM    : THMultiValComboBox; {FQ 10262}

    TableRouge : array [0..30] of Char;

    {M�thodes}
    procedure Afficher       ;
    function  GetCoursOpcvm  (Col : Integer; OPCVM : string) : Double;
    {Ev�nements}
    procedure PortefOnChange (Sender : TObject);
    procedure PopupSimulation(Sender : TObject); override;
    {02/10/07 : Branchement de l'acc�s au journal des rendements}
    procedure EditRendements (Sender : TObject);
    {02/10/07 : Pour cacher le menu d'acc�s au journal si on n'est pas sur une ligne de ventes (PMValues r�alis�es)}
    procedure PPOnPopup      (Sender : TObject);
    procedure bGraphClick    (Sender : TObject); override;
    procedure bGraph1Click   (Sender : TObject);
    procedure GridOnDblClick (Sender : TObject); override;
    procedure DessinerCells  (Sender : TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState); override;
    procedure FormOnKeyDown  (Sender : TObject; var Key: Word; Shift: TShiftState); override;
  public

  end ;

function TRLanceFiche_SuiviPortefeuille(Dom, Fiche, Range, Lequel, Arguments : string) : string;

implementation

uses
  AGLInit, Commun, Constantes, TROPCVM_TOM, TRGRAPHOPCVMREND_TOF, HTB97, Menus,
  Graphics, TRDETAILOPCVM_TOF, TRGRAPHOPCVMREPA_TOF, TRQRJALPORTEFEUIL_TOF;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_SuiviPortefeuille(Dom, Fiche, Range, Lequel, Arguments : string) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := FICTAB.FicLance(Dom, Fiche, Range, Lequel, Arguments);
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  TypeDesc := dsOPCVM;
  inherited;
  LargeurCol := 137;

  InArgument := True;

  {02/10/07 : Branchement de l'acc�s au journal des rendements}
  TPopupMenu(GetControl('POPUPMENU')).Items[2].OnClick := EditRendements;
  TPopupMenu(GetControl('POPUPMENU')).OnPopup := PPOnPopup;

  cbPortef := THMultiValComboBox(GetControl('MCPORTEFEUILLE')); {FQ 10262}
  cbPortef.OnChange := PortefOnChange;
  cbOPCVM := THMultiValComboBox(GetControl('MCOPCVM')); {FQ 10262}

  TToolbarButton97(GetControl('BGRAPH1')).OnClick := bGraph1Click;
  {Initialisation de la devise}
  Devise := V_PGI.DevisePivot;
  {Tob contenant les cotations des OPCVM}
  TobCours := TOB.Create('���', nil, -1);
  {Tob contenant les ventes d'OPCVM}
  TobVente := TOB.Create('$$$', nil, -1);

  InArgument := False;

  ListeSolde.Sorted := True;
  ListeSolde.Duplicates := dupIgnore;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobCours) then FreeAndNil(TobCours);
  if Assigned(TobVente) then FreeAndNil(TobVente);
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.PortefOnChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  {01/06/05 : FQ 10262 : GetControlText('MCPORTEFEUILLE') ne renvoie pas '' si on est � <<Tous >>}
  if (cbPortef.Value <> '') and not cbPortef.Tous then
    {On filtre les OPCVM en fonction de la s�lection de portefeuille}
    cbOPCVM.Plus := 'TOF_PORTEFEUILLE IN (' + GetClauseIn(cbPortef.Value) + ')'
  else
    cbOPCVM.Plus := '';
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.GridOnDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Code : string;
begin
  {inherited; on ne lance pas la TofDetailFlux, donc on n'ex�cute pas le code anc�tre}

  {On est sur une colonne Date}
  if (Grid.Col >= COL_DATEDE) and (Grid.Row > 0) and IsMouvemente(Grid.Col, Grid.Row) then begin
    {Les param�tres sont : DateDeb ; DateFin ; Portefeuille ; OPCVM ; NatureA ; NatureV}
    {R�cup�ration des dates}
    Code := DateToStr(ColToDate(Grid.Col - COL_DATEDE)) + ';' + DateToStr(ColToDate(Grid.Col - COL_DATEDE, True)) + ';';

    {R�cup�ration du portefeuille et du code Opcvm}
    Code := Code + Grid.CellValues[COL_TYPE, Grid.Row] + ';' + Grid.CellValues[COL_CODE, Grid.Row] + ';';
    {Recup�ration des filtres sur les natures}
    Code := Code + GetFiltreNatur('TOP_') + ';';
    Code := Code + GetFiltreNatur('TVE_') + ';';
         if Periodicite = tp_30 then Code := Code + 'mois de ' + AnsiLowerCase(Grid.CellValues[Grid.Col, 0]) + ';'
    else if Periodicite = tp_7  then Code := Code + 'p�riode ' + AnsiLowerCase(Grid.CellValues[Grid.Col, 0]) + ';'
                                else Code := Code + Grid.CellValues[Grid.Col, 0] + ';';

    TRLanceFiche_TRDETAILOPCVM('TR', 'TRDETAILOPCVM', '', '', Code);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.FormOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{---------------------------------------------------------------------------------------}
var
  I : Integer;
begin
  if (Shift = [ssCtrl]) then begin
    case Key of
      VK_RIGHT : for I := Grid.Col + 1 to Grid.ColCount - 1 do
                   {Si la date appartient � la liste c'est qu'il y a des �critures}
                   if IsMouvemente(I, Grid.Row) then begin
                     Grid.Col := I;
                     Key := 0;
                     Exit;
                   end;

      VK_LEFT : for I := Grid.Col - 1 downto COL_DATEDE do
                  {Si la date appartient � la liste c'est qu'il y a des �critures}
                   if IsMouvemente(I, Grid.Row) then begin
                    Grid.Col := I;
                    Key := 0;
                    Exit;
                  end;
    end;
  end;

  FormKeyDown(Sender, Key, Shift); // Pour touches standard AGL
end ;

{Lancement de l'�cran de saisie des OPCVM
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.PopupSimulation(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_OPCVM('TR', 'TROPCVM', '', '', ActionToString(taCreat));
  OnUpdate;
end;

{Constitution de la tob contenant les donn�es avant de la mettre dans la grille
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.Afficher;
{---------------------------------------------------------------------------------------}
var
  TobNbPart , {Tob contenant le nombres de parts � vendre pour tous les OPCVM}
  TobL      , {Ligne de la liste en cours}
  TobP      , {Latente}
  TobS      , {Stock}
  TobR      , {R�alis�}
  TobN      , {Nombre de parts non vendues, fille courante de TobNbPart}
  TobG      : TOB; {ligne temporaire de la grille}
  CodeOPCVM ,
  Portef    ,
  tCol      ,
  LibPortef : string;
  TxConv    : Double; {Taux de change entre la devise pivot et la devise d'affichage}
  Premier   : Boolean;

  {L�GENDE DES TYPES : "�"        = Ligne de Total g�n�ral
                       "Portef"   = Ligne de Total de Portefeuille ou d�tail par OPCVM
                       "�"        = ligne contenant le libell� d'un portefeuille
                       "*"        = Ligne de s�paration entre les portefeuille
   L�GENDE DES CODES : "OPCVM"    = ligne contenant le d�tail par OPCVM
                       "�"        = Ligne de Total g�n�ral
                       "$"        = Ligne de Total de Portefeuille
                       "*"        = Ligne de s�paration entre les portefeuille
                       "�"        = ligne contenant le libell� d'un portefeuille
   L�GENDE DES NATURES : "S"      = Lignes concernant le stock d'OPCVM
                         "R"      = Lignes concernant les Plus-Values r�alis�es
                         "P"      = Lignes concernant les Plus-Values latentes}
    {-------------------------------------------------------------------------}
    procedure CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux, Nat : string);
    {-------------------------------------------------------------------------}
    var
      n : Integer;
      T : TOB;
    begin
      {Seule TobN n'est pas une fille de TobGrid : elle ne sert pas � l'affichage, mais juste
       � stocker pour chaque jour ou mois et pour l'OPCVM en cours le nombre de parts � vendre}
      if Nat = 'N' then T := TOB.Create('', TobNbPart, -1)
                   else T := TOB.Create('', TobGrid  , -1);
      T.AddChampSupValeur('TYPEFLUX', TypeFlux);
      T.AddChampSupValeur('CODEFLUX', CodeFlux);
      T.AddChampSupValeur('NATURE'  , Nat);
      T.AddChampSupValeur('LIBELLE' , LibelleFlux);
      {Ajout des colonnes dates avec montant}
      for n := 0 to NbColonne - 1 do
        T.AddChampSupValeur(RetourneCol(n), '');

           if Nat = 'S' then TobS := T {Tob courante contenant le stock des OPCVM non vendues}
      else if Nat = 'P' then TobP := T {Tob courante contenant les plus values r�alis�es}
      else if Nat = 'R' then TobR := T {Tob courante contenant les plus values latentes}
      else if Nat = 'N' then TobN := T {Tob contenant le nombre de parts pour chaque jours/mois}
                        else TobG := T;{Tob courante divers}
    end;

    {Cr�ation des trois tobs pour un OPCVM
    {-------------------------------------------------------------------------}
    procedure GenereTobsDetail(TypeFlux, CodeFlux, LibelleFlux : string);
    {-------------------------------------------------------------------------}
    begin
      CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux + ' (Stock)'   , 'S');
      CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux + ' (PV Lat.)' , 'P');
      CreeTobDetail(TypeFlux, CodeFlux, LibelleFlux + ' (PV R�al.)', 'R');
    end;

    {-------------------------------------------------------------------------}
    procedure SommeTotal(Chp, Val : string);
    {-------------------------------------------------------------------------}
    var
      Mnt : Double;
    begin
      Mnt := TobGrid.Somme(tCol, [Chp, 'NATURE'], [Val, 'S'], False);
      TobS.PutValue(tCol, Mnt);
      Mnt := TobGrid.Somme(tCol, [Chp, 'NATURE'], [Val, 'P'], False);
      TobP.PutValue(tCol, Mnt);
      Mnt := TobGrid.Somme(tCol, [Chp, 'NATURE'], [Val, 'R'], False);
      TobR.PutValue(tCol, Mnt);
    end;

    {-------------------------------------------------------------------------}
    procedure CreeTobTotal(General : Boolean = False);
    {-------------------------------------------------------------------------}
    var
      n   : Integer;
    begin
       if General then CreeTobDetail('*', '*', '', '');
       if General then GenereTobsDetail('�', '�', 'Total g�n�ral')
                  else GenereTobsDetail(Portef, '$', 'Total ' + LibPortef);

      {Cumule chaque colonne date pour le type flux courant}
      for n := 0 to NbColonne - 1 do begin
        tCol := RetourneCol(n);
        {Cumul g�n�ral}
        if General then SommeTotal('CODEFLUX', '$')
      end;
    end;

    {-------------------------------------------------------------------------}
    procedure MajTobStock;
    {-------------------------------------------------------------------------}
    var
      n : Integer;
      m : Double;
    begin
      m := 0;
      for n := 0 to NbColonne - 1 do begin
        tCol := RetourneCol(n);
        {Mise � jour du volume des opcvm par cumul du montant du premier jour avec les
         op�rations des autres jours de la p�riode}
        m := m + TobS.GetDouble(tCol);
        TobS.SetDouble(tCol, m);
      end;
    end;

    {On �te au stocks d'OPCVM une vente
    {-------------------------------------------------------------------------}
    procedure OteVentes(Col : Integer; Mnt : Double);
    {-------------------------------------------------------------------------}
    var
      n : Integer;
    begin
      for n := Col to NbColonne - 1 do begin
        tCol := RetourneCol(n);
        TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Mnt);
      end;
    end;

    {-------------------------------------------------------------------------}
    procedure MajTobLat;
    {-------------------------------------------------------------------------}
    var
      n, p : Integer;
      m, c : Double;
    begin
      p := 0;
      for n := 0 to NbColonne - 1 do begin
        tCol := RetourneCol(n);
        m := TobS.GetDouble(tCol);
        {On ne traite les plus values que s'il y a des OPCVM}
        if m <> 0 then begin
          p := p + TobN.GetInteger(tCol);
          c := GetCoursOpcvm(n, CodeOPCVM) * TxConv;
          {Calcul des plus values latentes : cours du jour * Nb parts � vendre - stock}
          TobP.SetDouble(tCol, c * p - m);
        end;
      end;
    end;

    {-------------------------------------------------------------------------}
    function PositionnerTobs(P, O : string) : Boolean;
    {-------------------------------------------------------------------------}
    begin
      TobS := TobGrid  .FindFirst(['TYPEFLUX', 'CODEFLUX', 'NATURE'], [P, O, 'S'], True);
      TobP := TobGrid  .FindFirst(['TYPEFLUX', 'CODEFLUX', 'NATURE'], [P, O, 'P'], True);
      TobR := TobGrid  .FindFirst(['TYPEFLUX', 'CODEFLUX', 'NATURE'], [P, O, 'R'], True);
      TobN := TobNbPart.FindFirst(['TYPEFLUX', 'CODEFLUX', 'NATURE'], [P, O, 'N'], True);
      Result := Assigned(TobS) and Assigned(TobP) and Assigned(TobR);
      if O <> '$' then
        Result := Result and Assigned(TobN);
    end;

    {-------------------------------------------------------------------------}
    procedure GererPremier(NbPart : Double; Mnt : Double; VenteOk : Boolean);
    {-------------------------------------------------------------------------}
    begin
      tCol := GetTitreFromDate(DateDepart);
      {On cumule avec un �ventuel montant stock� dans la Tob car des ventes ont pu �tre
       m�moris�es sur le premier jour de la s�lection}
      TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Mnt);
      {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
      TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbPart);
      (* A voir : mais je pense qu'il ne faut pas mettre la ligne en gras
      ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';'); *)
      Premier := False;
      if VenteOk then
        {On �te la vente courante au stock d'opcvm pour le reste de la p�riode}
        OteVentes(1, Mnt);
    end;

var
  P, O     : string;
  NbEcrit,
  I,  n    : Integer;
  Montant  : Double;
  MntAchat ,
  MntVente : Double;
  DtAchat  ,
  DtVente  : TDateTime;
  NbParts  ,
  NbpartsA ,
  NbpartsV : Double;
  ListOPCVM: TStringList;
begin
  {Par d�faut on consid�re qu'il n'y a pas de d'imports comptables dans le r�sultat de la requ�te}
  RecCptOk := False;
  DepCptOk := False;
  Montant  := 0;
  NbParts  := 0;
  Premier  := True;
  ListeSolde.Clear;

  Portef := '';
  NbEcrit  := TobListe.Detail.Count;

  if NbEcrit = 0 then Exit;

  {Gestion de la devise d'affichage}
  Portef := GetControlText('CBDEVISE');
  if Portef = '' then
    SetControlText('CBDEVISE', V_PGI.DevisePivot);

  TxConv := DoubleNotNul(RetContreTaux(V_PGI.DateEntree, V_PGI.DevisePivot , Portef));
  Portef := '';

  {Cr�ation de la Tob contenant le nombre de parts}
  TobNbPart := TOB.Create('���', nil, -1);
  {Liste des}
  ListOPCVM := TStringList.Create;
  ListOPCVM.Sorted := True;
  ListOPCVM.Duplicates := DupIgnore;
  try
    {********************************************************************}
    {*********************  GESTION DES ACHATS  *************************}
    {********************************************************************}

    for I := 0 to NbEcrit - 1 do begin
      TobL := TobListe.Detail[I];

      P := TobL.GetString('TOP_PORTEFEUILLE');
      {Changement de type flux}
      if P <> Portef then begin
        ListOPCVM.Add(P + ';$;');
        if (Portef <> '') then begin
          if Premier then GererPremier(NbParts, Montant, False);
          {Maj des Tobs contenant les stocks et des plus values latentes}
          MajTobStock;
          {Cr�ation des trois tobs de totalisation pour le portfeuille pr�c�dent}
          CreeTobTotal;
          {Ligne de s�paration entre deux portefeuilles}
          CreeTobDetail('*', '*', '', '');
        end;
        LibPortef := TobL.GetString('CC_ABREGE');
        {Ligne contenant le libell� des types de flux}
        CreeTobDetail('�', '�', TobL.GetString('CC_LIBELLE'), '');
        Montant := 0;
        NbParts := 0;
        Premier := True;
      end;

      O := TobL.GetString('TOP_CODEOPCVM');
      ListOPCVM.Add(P + ';' + O + ';');

      {Nouvel OPCVM}
      if (CodeOPCVM <> O) or (P <> Portef) then begin
        if Portef <> P then
          Portef := P
        else begin
          if Premier then GererPremier(NbParts, Montant, False);
          MajTobStock;
        end;

        {... on cr�e la tob qui va contenir les soldes du compte pr�c�dent}
        GenereTobsDetail(Portef, O, TobL.GetString('TOF_ABREGE'));
        {Cr�ation de la ligne de parts pour l'opcvm courante}
        CreeTobDetail(Portef, O, '', 'N');

        CodeOPCVM := O;
        Montant := 0;
        NbParts := 0;
        Premier := True;
      end;

      {3 cas sont g�r�s en fonctin de la date d'achat : 1/ avant la p�riode, 2/ dans la p�riode, 3/ apr�s la p�riode.
       Le montant des ventes est recalcul� en fonction du prix d'achat et du nombre de parts vendues : on ne peut
       pas tenir compte du montant figurant dans la table TRVENTEOPCVM, car le cours n'est pas le m�me et on se
       retrouverait dans les lignes de stock d'OPCVM avec les plus / moins values alors que l'on veut juste connaitre
       � quel prix on a achet� les OPCVM et donc le stock achet�
       15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
      NbpartsA := TobL.GetDouble('TOP_NBPARTACHETE');
      MntAchat := TobL.GetDouble('TOP_MONTANTACH') * TxConv;
      DtAchat  := TobL.GetDateTime('TOP_DATEACHAT');

      {1/ Si on est en dehors de la fourchette de s�lection}
      if (DtAchat < DateDepart) then begin
        {On cumule afin de calculer les stocks au d�but de la p�riode de r�f�rence}
        Montant := Montant + MntAchat;
        NbParts := NbParts + NbPartsA;
      end{1/ Si on est en dehors de la fourchette de s�lection}

      {2/ Si on est sur le premier jour de la p�riode}
      else if DtAchat = DateDepart then begin
        Montant := Montant + MntAchat;
        NbParts := NbParts + NbPartsA;

        tCol := GetTitreFromDate(DtAchat);
        {Mise � jour du montant en cours}
        if Premier then begin
          {On cumule avec un �ventuel montant stock� dans la Tob car des ventes ont pu �tre
           m�moris�es sur le premier jour de la s�lection}
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Montant);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbParts);
          ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
        end
        else begin
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) + MntAchat);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbPartsA);
          ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
        end;
        Premier := False
      end{2/ Si on est sur le premier jour de la p�riode}

      {3/ Dans la fourchette d'affichage
       27/03/07 : FQ 10416 : DtAchat <= DateFin et non DtAchat < DateFin, pour ne pas exclure
                  les op�rations du dernier jour}
      else if (DtAchat > DateDepart) and (DtAchat <= DateFin) then begin
        {S'il s'agit de la premi�re transaction dans la p�riode de r�f�rence}
        if Premier then begin
          {On met le cumul ant�rieur � la date de d�part sur la date de d�part}
          tCol := GetTitreFromDate(DateDepart);
          {On cumule avec un �ventuel montant stock� dans la Tob car des ventes ont pu �tre
           m�moris�es sur le premier jour de la s�lection}
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Montant);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbParts);
          Premier := False;
        end;
        {On r�cup�re le titre de la colonne correspondant � la date d'achat}
        tCol := GetTitreFromDate(DtAchat);
        TobS.SetDouble(tCol, TobS.GetDouble(tCol) + MntAchat);
        {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
        TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbPartsA);
        ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
      end;{3/ Dans la fourchette d'affichage}
    end;{Boucle For sur la TobListe}

    {S'il y a des OPCVM dans la TobListe ...}
    if NbEcrit > 0 then begin
      {S'il tous les achats sont ant�rieurs � la p�riode de r�f�rence}
      if Premier then GererPremier(NbParts, Montant, False);

      {Maj des Tobs contenant les stocks}
      MajTobStock;
      {Cr�ation des trois tobs de totalisation pour le portfeuille pr�c�dent}
      CreeTobTotal;
    end;

    {********************************************************************}
    {*********************  GESTION DES VENTES  *************************}
    {********************************************************************}

    NbEcrit   := TobVente.Detail.Count;
    Portef    := '';
    CodeOpcvm := '';

    for I := 0 to NbEcrit - 1 do begin
      TobL := TobVente.Detail[I];

      P := TobL.GetString('TVE_PORTEFEUILLE');
      {Changement de type flux}
      if P <> Portef then begin
        ListOPCVM.Add(P + ';$;');
        if (Portef <> '') then 
          if Premier then GererPremier(NbParts, Montant, True);
        Premier := True;
      end;

      O := TobL.GetString('TVE_CODEOPCVM');
      ListOPCVM.Add(P + ';' + O + ';');

      {Nouvel OPCVM}
      if (CodeOPCVM <> O) or (P <> Portef) then begin
        if Portef <> P then
          Portef := P
        else 
          if Premier then GererPremier(NbParts, Montant, True);

        {On va rechercher les Tobs S, P, R et N correspondant au portefeuille et � l'OPCVM en cours}
        if not PositionnerTobs(P, O) then Continue;

        CodeOPCVM := O;
        Montant := 0;
        NbParts := 0;
        Premier := True;
      end;

      {3 cas sont g�r�s en fonctin de la date d'achat : 1/ avant la p�riode, 2/ dans la p�riode, 3/ apr�s la p�riode.
       Le montant des ventes est recalcul� en fonction du prix d'achat et du nombre de parts vendues : on ne peut
       pas tenir compte du montant figurant dans la table TRVENTEOPCVM, car le cours n'est pas le m�me et on se
       retrouverait dans les lignes de stock d'OPCVM avec les plus / moins values alors que l'on veut juste connaitre
       � quel prix on a achet� les OPCVM et donc le stock achet�
       15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
      NbpartsV := TobL.GetDouble('TVE_NBVENDUE');

      MntVente := TobL.GetDouble('TOP_PRIXUNITAIRE') / DoubleNotNul(TobL.GetDouble('TOP_COTATIONACH')) * NbpartsV * TxConv;

      DtVente := TobL.GetDateTime('TVE_DATEVENTE');

      {1/ Si on est avant la p�riode de r�f�rence on d�duit la vente du stock}
      if (DtVente < DateDepart) then begin
        Montant := Montant - MntVente;
        NbParts := NbParts - NbPartsV;
      end

      {2/ Si on est sur le premier jour de la p�riode}
      else if DtVente = DateDepart then begin
        tCol := GetTitreFromDate(DtVente);
        if Premier then begin
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Montant - MntVente);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbParts - NbPartsV);
          ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
          Montant := Montant - MntVente;
          Premier := False
        end
        else begin
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) - MntVente);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) - NbPartsV);
          ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
          Montant := - MntVente;
        end;

        {Mise � jour des plus-values r�alis�es dans la colonne concern�e par la date de vente}
        TobR.SetDouble(tCol, TobL.GetDouble('TVE_PMVALUEBRUT') * TxConv + TobR.GetDouble(tCol));
        {On �te la vente courante au stock d'opcvm pour le reste de la p�riode}
        OteVentes(DateToCol(DtVente), Montant);
      end{2/ Si on est sur le premier jour de la p�riode}

      {3/ Si on est dans la p�riode de r�f�rence on m�morise le montant de la vente}
      else if DtVente < DateFin then begin
        {On met le cumul ant�rieur � la date de d�part sur la date de d�part,
         puis on met � jour les rang�es concern�es par l'OPCVM}
        if Premier then begin
          tCol := GetTitreFromDate(DateDepart);
          TobS.SetDouble(tCol, TobS.GetDouble(tCol) + Montant);
          {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
          TobN.SetDouble(tCol, TobN.GetDouble(tCol) + NbParts);
          Premier := False;
          {Mise � jour des plus-values r�alis�es dans la colonne concern�e par la date de vente}
//          TobR.SetDouble(tCol, TobL.GetDouble('TVE_PMVALUEBRUT') * TxConv + TobR.GetDouble(tCol));
          {On �te la vente courante au stock d'opcvm pour le reste de la p�riode}
          OteVentes(DateToCol(DateDepart), Montant);
        end;

        {Mise � jour de la colonne correspondant � la date de vente}
        tCol := GetTitreFromDate(DtVente);
        TobS.SetDouble(tCol, TobS.GetDouble(tCol) - MntVente);
        {15/12/06 : FQ 10373 : On passe d'un Integer � un Double}
        TobN.SetDouble(tCol, TobN.GetDouble(tCol) - NbPartsV);
        ListeSolde.Add(tCol + ';' + Portef + ';' + CodeOpcvm + ';');
        Montant := - MntVente;

        {Mise � jour des plus-values r�alis�es dans la colonne concern�e par la date de vente}
        TobR.SetDouble(tCol, TobL.GetDouble('TVE_PMVALUEBRUT') * TxConv + TobR.GetDouble(tCol));
        {On �te la vente courante au stock d'opcvm pour le reste de la p�riode}
        OteVentes(DateToCol(DtVente), Montant);
      end; {3/ Si on est dans la p�riode de r�f�rence on m�morise le montant de la vente}
    end; {Boucle For sur la TobVente}

    {********************************************************************}
    {******************  GESTION DES SOLDES TOTAUX **********************}
    {********************************************************************}

    {S'il y a des OPCVM dans la TobListe ...}
    if (ListOPCVM.Count > 0) then begin
      {S'il tous les achats sont ant�rieurs � la p�riode de r�f�rence}
      if Premier then GererPremier(NbParts, Montant, True);

      {Mise � jour des P/M values latentes}
      for n := ListOPCVM.Count - 1 downto 0 do begin
        {On positionne les Tobs sur l'OPCVM en cours}
        tCol := ListOPCVM[n];
        P := ReadTokenSt(tCol);
        O := ReadTokenSt(tCol);
        if PositionnerTobs(P, O) then begin
          if O = '$' then begin
            {Somme des P/M values latentes du portefeuille}
            for i := 0 to NbColonne - 1 do begin
              tCol := RetourneCol(i);
              SommeTotal('TYPEFLUX', P);
            end;
          end
          else begin
            CodeOPCVM := O;
            {Calcul des P/M values latentes de l'OPCVM courante}
            MajTobLat;
          end;
        end;
      end;

      {Cr�ation de la derni�re tob fille qui contiendra le solde total}
      CreeTobTotal(True);
    end;

  finally
    if Assigned(TobNbPart) then FreeAndNil(TobNbPart);
    if Assigned(ListOPCVM) then FreeAndNil(ListOPCVM);
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIOPCVM.GetCoursOpcvm(Col : Integer; OPCVM : string) : Double;
{---------------------------------------------------------------------------------------}
var
  d : TDateTime;
  T : TOB;
  Q : TQuery;
  c : Double;
begin
  Result := 0;
  d := ColToDate(Col, True);
  {Th�oriquement TobCours est tri�e par OPCVM et par DATE}
  T := TobCours.FindFirst(['TTO_CODEOPCVM'], [OPCVM], True);

  while Assigned(T) do begin
    if T.GetDateTime('TTO_DATE') < d then begin
      c := DoubleNotNul(T.GetDouble('H_COTATION'));
      Result := T.GetDouble('TTO_COTATION') / c;
    end

    else if T.GetDateTime('TTO_DATE') = d then begin
      c := DoubleNotNul(T.GetDouble('H_COTATION'));
      Result := T.GetDouble('TTO_COTATION') / c;
      Break;
    end

    else if T.GetDateTime('TTO_DATE') > d then begin
      {Je ne suis pas s�r que cela soit tr�s logique de prendre un cours post�rieur,
       mais comme il s'agit que d'une analyse ...
       On pourait aussi envisager de prendre le cours le plus proche et pas syst�matiquement
       le dernier avant la date en cours !!!!}
//      if Result = 0 then
  //      Result := T.GetDouble('TTO_COTATION');
      Break;
    end;

    T := TobCours.FindNext(['TTO_CODEOPCVM'], [OPCVM], True);
  end;
  {S'il n'y a pas de cours r�cemment saisi, on va chercher le dernier}
  if Result = 0 then begin
    Q := OpenSQL('SELECT TTO_COTATION, H_COTATION FROM TRCOURSCHANCEL WHERE TTO_CODEOPCVM = "' + OPCVM +
                 '" AND TTO_DATE = (SELECT MAX(TTO_DATE) FROM TRCOTATIONOPCVM WHERE ' +
                 'TTO_CODEOPCVM = "' + OPCVM + '" AND TTO_DATE < "' + UsDateTime(DateDepart) + '")', True);
    try
      if not Q.EOF then begin
        c := DoubleNotNul(Q.FindField('H_COTATION').AsFloat);
        Result := Q.FindField('TTO_COTATION').AsFloat / c;
        {On ajoute le r�sultat pour �viter la multiplication des requ�tes}
        T := TOB.Create('***', TobCours, - 1);
        T.AddChampSupValeur('TTO_CODEOPCVM', OPCVM);
        T.AddChampSupValeur('TTO_DATE'     , DateDepart);
        T.AddChampSupValeur('TTO_COTATION' , Q.FindField('TTO_COTATION').AsFloat);
        T.AddChampSupValeur('H_COTATION'   , c);
        TobCours.Detail.Sort('TTO_CODEOPCVM;TTO_DATE;');
      end;
    finally
      Ferme(Q);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.OnUpdate ;
{---------------------------------------------------------------------------------------}
var
  SQL    : string;
  I      : Integer;
  whConf : string; 
begin
  inherited;
  {On nettoie les tobs, TobListe �tant vid�e dans l'anc�tre}
  TobCours.ClearDetail;
  TobVente.ClearDetail;
  TobListe.ClearDetail;
  {Gestion des confidentialit�}
  whConf := GetWhereConfidentialite;

  {Chargement des cours des OPCVM}
  SQL := 'SELECT TRCOURSCHANCEL.*, TOF_DEVISE FROM  TRCOURSCHANCEL ' +
         'LEFT JOIN TROPCVMREF ON TTO_CODEOPCVM = TOF_CODEOPCVM ';
  SQL := SQL + 'WHERE TTO_DATE BETWEEN "' + UsDateTime(DateDepart) +
               '" AND "' + UsDateTime(DateFin) + '" ';
  SQL := SQL + GetFiltreOpcvm('TTO_') + GetFiltrePorte('TTO_') +
               ' ORDER BY TTO_CODEOPCVM, TTO_DATE';
  TobCours.LoadDetailFromSQL(SQL);

  {Chargement des ventes d'OPCVM}
  SQL := 'SELECT TVE_PMVALUEBRUT, TVE_NBVENDUE, TOP_DATEFIN, TOP_PRIXUNITAIRE, TOP_COTATIONACH, ';
  SQL := SQL + 'TVE_DATEVENTE, TVE_PORTEFEUILLE, TVE_CODEOPCVM FROM TRVENTEOPCVM ';
  SQL := SQL + 'LEFT JOIN BANQUECP ON BQ_CODE = TVE_GENERAL ';
  SQL := SQL + 'LEFT JOIN TROPCVM ON TOP_NUMOPCVM = TVE_NUMTRANSAC ' +
               'WHERE TVE_DATEVENTE <= "' + UsDateTime(DateFin);
  SQL := SQL + '"' + GetFiltreOpcvm('TVE_') + GetFiltrePorte('TVE_') + GetFiltreNatur('TVE_') + whConf;
  SQL := SQL + ' AND (TOP_DATEFIN >= "' + UsDateTime(DateDepart);
  SQL := SQL + ' " OR TOP_DATEFIN IS NULL OR TOP_DATEFIN <= "' + UsDateTime(iDate1900) + '") ';
  SQL := SQL + 'ORDER BY TVE_PORTEFEUILLE, TVE_CODEOPCVM, TVE_DATEVENTE ';
  TobVente.LoadDetailFromSQL(SQL);

  {Chargement des achats d'OPCVM}
  SQL := 'SELECT TOP_MONTANTACH, TOP_NBPARTACHETE, TOP_PORTEFEUILLE, TOP_CODEOPCVM, ';
  SQL := SQL + 'TOP_DATEACHAT, CC_ABREGE, CC_LIBELLE, TOF_ABREGE FROM TROPCVM ';
  SQL := SQL + 'LEFT JOIN BANQUECP ON BQ_CODE = TOP_GENERAL ';
  SQL := SQL + 'LEFT JOIN CHOIXCOD ON CC_CODE = TOP_PORTEFEUILLE AND CC_TYPE="TRP" ';
  SQL := SQL + 'LEFT JOIN TROPCVMREF ON TOF_CODEOPCVM = TOP_CODEOPCVM ';
  SQL := SQL + 'WHERE  (TOP_DATEFIN >= "' + UsDateTime(DateDepart) + '" OR TOP_DATEFIN IS NULL OR ' +
               'TOP_DATEFIN <= "' + UsDateTime(iDate1900) + '") AND TOP_DATEACHAT <= "' + UsDateTime(DateFin) +
               '" ' + GetFiltreOpcvm('TOP_') + GetFiltrePorte('TOP_') + GetFiltreNatur('TOP_') + whConf;
  SQL := SQL + ' ORDER BY TOP_PORTEFEUILLE, TOP_CODEOPCVM, TOP_DATEACHAT';
  TobListe.LoadDetailFromSQL(SQL);

  {G�n�ration de la TobGrid}
  Afficher;

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
  Grid.ColWidths[COL_LIBELLE]:= 170;
  Grid.Col := COL_DATEDE;
  Grid.Row := Grid.FixedRows;
  Grid.SetFocus;
end ;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIOPCVM.GetFiltreOpcvm(Prefix : string) : string;
{---------------------------------------------------------------------------------------}
begin
  {01/06/05 : FQ 10262 : GetControlText('MCOPCVM') ne renvoie pas '' si on est � <<Tous >>}
  if (cbOPCVM.Value <> '') and not cbOPCVM.Tous then 
    Result := ' AND ' + Prefix + 'CODEOPCVM IN (' + GetClauseIn(cbOPCVM.Value) + ') ';
end;

{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIOPCVM.GetFiltrePorte(Prefix : string) : string;
{---------------------------------------------------------------------------------------}
begin
  {01/06/05 : FQ 10262 : GetControlText('MCPORTEFEUILLE') ne renvoie pas '' si on est � <<Tous >>}
  if (cbPortef.Value <> '') and not cbPortef.Tous then begin
    {Le filtre sur les portefeuilles des cours n'est appliqu� que s'il n'y a pas de filtre sur les OPCVM}
    {01/06/05 : FQ 10262 : GetControlText('MCOPCVM') ne renvoie pas '' si on est � <<Tous >>}
    if ((cbOPCVM.Value = '') or cbOPCVM.Tous) and (Prefix = 'TTO_') then
      Result := ' AND TTO_CODEOPCVM IN (SELECT TOF_CODEOPCVM FROM TROPCVMREF WHERE ' +
                'TOF_PORTEFEUILLE IN (' + GetClauseIn(cbPortef.Value) + ')) '
    else if Prefix <> 'TTO_' then
      Result := ' AND ' + Prefix + 'PORTEFEUILLE IN (' + GetClauseIn(cbPortef.Value) + ') ';
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.bGraphClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Titre  : string;
  sDev   : string;
  n, p   : Integer;
  T, D   : TOB;
  sGraph : string;
  Chp    : string;
begin
    Titre := 'Suivi des plus-values latentes par portefeuille';
    sDev  := 'Les montants sont �xprim�s en ' + RechDom('TTDEVISE', V_PGI.DevisePivot, False);

  {Constitution de la tob du graph}
  T := Tob.Create('$$$', nil, -1);
  try

    for n := COL_DATEDE to Grid.ColCount - 1 do begin
      {Les abscisses contiennent les jours/mois qui sont plac�s en premi�re s�rie}
      D := Tob.Create('$$$', T, -1);
      D.AddChampSupValeur('PERIODE', Grid.Cells[n, 0]);
      for p := 1 to Grid.RowCount - 2 do begin
        {On est sur le Total portefeuille}
        if (Grid.Cells[COL_CODE, p] = '$') and (Grid.Cells[COL_NATURE, p] = 'P') then begin
          Chp := DelChaine('(PV Lat.)', Grid.Cells[COL_LIBELLE, p]);
          D.AddChampSupValeur(Chp, Grid.Cells[n, p]);
        end;
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
    TRLanceFiche_GraphOpcvmRend(Titre + ';' + sDev + ';' + sGraph);
  finally
    if Assigned(T) then FreeAndNil(T);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.bGraph1Click(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Titre  : string;
  p, n   : Integer;
  Mnt,
  Total  : Double;
  T, D, G: TOB;
  sGraph : string;
begin
  n := Grid.Col;
  if n < COL_DATEDE then Exit;
       if Periodicite = tp_30 then Titre := ' du mois de ' + RetourneCol(n - COL_DATEDE)
  else if Periodicite = tp_7  then Titre := ' pour la p�riode du ' + RetourneCol(n - COL_DATEDE)
                             else Titre := ' du ' + RetourneCol(n - COL_DATEDE);
  Titre := 'R�partition des portefeuilles et des OPCVM' + Titre;

  Mnt   := 1;
  Total := 0;
  D := nil;
  
  {Constitution de la tob du graph}
  T := Tob.Create('$$$', nil, -1);
  try
    {On parcourant la Tob de la grille � rebours, on cr�era les Tobs portefeuilles avant celles des OPCVM}
    for p := Grid.RowCount - 2 downto 1 do begin

      {On est sur le Total portefeuille}
      if (Grid.Cells[COL_CODE, p] = '$') and (Grid.Cells[COL_NATURE, p] = 'S') then begin
        D := Tob.Create('$$$', T, -1);
        D.AddChampSupValeur('PORTEFEUILLE', DelChaine('Total', DelChaine('(Stock)', Grid.Cells[COL_LIBELLE, p])));
        Mnt := Abs(Valeur(Grid.Cells[n, p]));
        D.AddChampSupValeur('MONTANT', Mnt);
        Total := Total + Abs(Mnt);
        if Mnt = 0 then Mnt := 1;
      end

      {On est sur un Stock d'OPCVM}
      else if not (StrToChr(Grid.Cells[COL_CODE, p]) in ['$', '�', '*', '�']) and (Grid.Cells[COL_NATURE, p] = 'S') then begin
        G := Tob.Create('$$$', D, -1);
        G.AddChampSupValeur('OPCVM', DelChaine('(Stock)', Grid.Cells[COL_LIBELLE, p]));
        G.AddChampSupValeur('MONTANT', Arrondi(Valeur(Grid.Cells[n, p]) / Mnt * 100, 2));
//        G.AddChampSupValeur('MONTANT', Valeur(Grid.Cells[n, p]));
      end;
    end;

    if T.Detail.Count > 0 then begin
      if Total = 0 then Total := 1;
      for p := 0 to T.Detail.Count - 1 do
        T.Detail[p].SetDouble('MONTANT', Arrondi(T.Detail[p].GetDouble('MONTANT') / Total * 100, 2));

      sGraph := 'PORTEFEUILLE:MONTANT;OPCVM:MONTANT;';
      TheTOB := T;
      {!!! Mettre sGraph en fin � cause des ";" qui traine dans la chaine}
      TRLanceFiche_GraphOpcvmRepart(Titre + ';' + sGraph);
    end;
  finally
    if Assigned(T) then FreeAndNil(T);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.DessinerCells(Sender: TObject; Col, Row: Integer; Rect: TRect; State: TGridDrawState);
{---------------------------------------------------------------------------------------}
var
  S     : string;
  sNatu,
  sCode : Char;
begin
  inherited;
  with Grid.Canvas do begin
    {Lignes de valeurs}
    sCode := StrToChr(Grid.Cells[COL_CODE, Row]);
    sNatu := StrToChr(Grid.Cells[COL_NATURE, Row]);

    if gdSelected in State then begin
      Brush.Color := clHighLight;
      Font.Color := clHighLightText;
    end
    {Libell� du portefeuille}
    else if sCode = '�' then begin
      Brush.Color := clUltraLight;
      Font.Style := [fsBold];
    end
    {ligne de s�paration}
    else if sCode = '*' then begin
      Brush.Color := clBtnFace;
      Font.Style := [fsBold];
    end
    {... Pour les autres lignes, cela se joue sur la nature}
    else begin
      {Le Stock}
      if sNatu = 'S' then begin
        {Ligne de total}
        if sCode in ['$', '�'] then begin
          Brush.Color := clOrangePale;
          Font.Color  := clGrisTexte;
          {Total g�n�ral}
          if sCode = '�' then
            Font.Style := [fsBold];
        end
        {Ligne de d�tail}
        else begin
          if IsMouvemente(Col, Row) then Font.Style := [fsBold];
          Brush.Color := clCremePale;
        end;
      end

      {Les plus values latentes}
      else if sNatu = 'P' then begin
        {Ligne de total}
        if sCode in ['$', '�'] then begin
          Brush.Color := clWhite;
          Font.Color  := clGrisTexte;
          {Total g�n�ral}
          if sCode = '�' then
            Font.Style := [fsBold];
        end
        {Ligne de d�tail}
        else
          Brush.Color := clBleuLight;
      end

      {Les plus values r�alis�es}
      else if sNatu = 'R' then begin
        {Ligne de total}
        if sCode in ['$', '�'] then begin
          Brush.Color := clInfoBk;
          Font.Color  := clGrisTexte;
          {Total g�n�ral}
          if sCode = '�' then
            Font.Style := [fsBold];
        end
        {Ligne de d�tail}
        else
          Brush.Color := clUltraCreme;
      end;
      {Total g�n�ral}
      {Gestion des lignes de plus-values}
      if (Col >= COL_DATEDE) and (sNatu in ['P', 'R']) then begin
        S := Grid.Cells[Col, Row];
             if (Valeur(S) > 0) then Font.Color := clGreen {Plus-value}
        else if (Valeur(S) < 0) then Font.Color := clRed; {Moins-value}
      end;
    end;
  end;
end;

{On ne traite que les OPCVM Ouvertes (TOP_STATUT <> "X"). ???? : Th�oriquement g�r�
                  avec la date fin de la requ�te
 Sont de simulation les OPCVM non valid�s BO
 Sont pr�visionnelles les OPCVM valid�s mais pas int�gr�s
 Sont r�alis�s les OPCVM int�gr�s en comptabilit�
{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIOPCVM.GetFiltreNatur(Prefix : string) : string;
{---------------------------------------------------------------------------------------}
var
  Nat : string;
  ROk : Boolean;
  POk : Boolean;
  SOk : Boolean;
begin
  Nat := GetControlText('MCNATURE');
  if Pos('<<', Nat) > 0 then
    Nat := '';
  {S'il n'y a pas de filtre}
  if Nat = '' then Exit;
//  Result := ' (TOP_STATUT <> "X" OR TOP_SATUT IS NULL)';

  ROk := (Pos(na_Realise   , Nat) > 0);
  POk := (Pos(na_Prevision , Nat) > 0);
  SOk := (Pos(na_Simulation, Nat) > 0);

  if ROk and POk and SOk then
    Exit
  else if ROk and POk then
    {Pr�visionnel et r�alis� :
     On traite les OPCVM VBO }
    Result := ' AND ' + Prefix + 'VALBO = "X"  '
  else if ROk and SOk then
    {Pr�visionnel et r�alis� :
     On traite les OPCVM non VBO ou int�gr�s en comptabilit�}
    Result := ' AND (' + Prefix + 'COMPTA = "X" OR ' + Prefix + 'VALBO <> "X" OR ' + Prefix + 'VALBO IS NULL) '
  else if POk and SOk then
    {Pr�vionnel et simulation :
     On exclut les OPCVM int�gr�s en comptabilit�}
    Result := 'AND (' + Prefix + 'COMPTA <> "X" OR ' + Prefix + 'COMPTA IS NULL) '
  else if ROk then
    {R�alis� seulement :
     On ne traite que les OPCVM int�gr�es en comptabilit�}
    Result := ' AND ' + Prefix + 'COMPTA = "X" '
  else if SOk then
    {Simulation seulement :
     On traite les OPCVM qui ne sont ni VBO mais ni int�gr�s en comptabilit�}
    Result := 'AND (' + Prefix + 'VALBO <> "X" OR ' + Prefix + 'VALBO IS NULL) ' +
              'AND (' + Prefix + 'COMPTA <> "X" OR ' + Prefix + 'COMPTA IS NULL) '
  else if POk then
    {Pr�visionnel seulement :
     On ne traite que les OPCVM VBO mais non int�gr�s en comptabilit�}
    Result := ' AND ' + Prefix + 'VALBO = "X" AND (' + Prefix + 'COMPTA <> "X" OR ' + Prefix + 'COMPTA IS NULL) ';
end;

{Renvoie True si on est sur un d�tail des Stocks et qu'au jour / mois courant, il y a des
 mouvements
{---------------------------------------------------------------------------------------}
function TOF_TRSUIVIOPCVM.IsMouvemente(Col, Row : Integer) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  {Si on n'est sur une ligne de stock}
  Result := (Grid.Cells[COL_NATURE, Row] = 'S') and
            (Grid.Cells[COL_CODE, Row]  <> '$') and
            (Grid.Cells[COL_CODE, Row]  <> '�');

  Result := Result and (ListeSolde.IndexOf(Grid.Cells[Col, 0] + ';' +
                               Grid.Cells[COL_TYPE, Row] + ';' +
                               Grid.Cells[COL_CODE, Row] + ';') > -1);
end;

{Appel de l'�tat des rendements
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.EditRendements(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Code : string;
begin
  if (Grid.CellValues[COL_TYPE, Grid.Row] = '*') or {S�paration}
     (Grid.CellValues[COL_TYPE, Grid.Row] = '�') or {Libell�}
     (Grid.CellValues[COL_TYPE, Grid.Row] = '�') {Total}then Exit;


  {On est sur une colonne Date}
  if (Grid.Col >= COL_DATEDE) then begin
    {Les param�tres sont : DateDeb ; DateFin ; Portefeuille ; OPCVM ; }
    {R�cup�ration des dates}
    Code := DateToStr(ColToDate(Grid.Col - COL_DATEDE)) + ';' + DateToStr(ColToDate(Grid.Col - COL_DATEDE, True)) + ';';
    {Ligne de total de portefeuille}
    if Grid.CellValues[COL_CODE, Grid.Row] = '$' then
      Code := Code + Grid.CellValues[COL_TYPE, Grid.Row] + ';;'
    else
      {R�cup�ration du portefeuille et du code Opcvm}
      Code := Code + Grid.CellValues[COL_TYPE, Grid.Row] + ';' + Grid.CellValues[COL_CODE, Grid.Row] + ';';
    TRLanceFiche_JalPortefeuille('', '', Code);
  end;
end;

{02/10/07 : Pour cacher le menu d'acc�s au journal si on n'est pas sur une ligne de ventes (PMValues r�alis�es)
{---------------------------------------------------------------------------------------}
procedure TOF_TRSUIVIOPCVM.PPOnPopup(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
//  TPopupMenu(GetControl('POPUPMENU')).Items[2].Visible := (Grid.Col >= COL_DATEDE) and
  //          (Grid.Cells[COL_NATURE, Grid.Row] = 'R') and (Grid.Cells[Grid.Col, Grid.Row] <> '');
end;

initialization
  RegisterClasses([TOF_TRSUIVIOPCVM]);

end.

