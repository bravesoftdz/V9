{-------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 6.xx.xxx.xxx  10/07/04  JP   Cr�ation de l'unit�
 6.30.001.003  09/03/05  JP   Gestion des impressions des �tats
 6.50.001.018  14/09/05  JP   Ajout d'un test sur l'existence du r�pertoire "SO_REPSORTIEPDF"
                              afin d'�viter de planter l'application
 6.50.001.019  19/09/05  JP   FQ 10290 : Probl�me lors de la r�cup�ration des num�ro de
                              ventes lors de l'impression des transaction valid�es.
                              FQ 10293 : La TobCompta �tait mal tri�e, ce qui cr�e des
                              �critures d�s�quilibr�es en comptabilit�
 7.00.001.001  12/01/06  JP   FQ 10323 : Correction de la gestion de la TVA
 7.09.001.001  18/09/06  JP   Mise en place de l'int�gration multi-soci�t�s
 7.09.001.001  06/10/06  JP   Gestion des ParamSoc multi soci�t�s
 7.09.001.001  23/10/06  JP   Gestion des filtres Multi soci�t�s
 7.09.001.003  19/12/06  JP   FQ 10389 : pouvoir recalculer la vente si les cours ont �t� modifi�s
 7.09.001.005  05/02/07  JP   FQ 10231 (suite) : Affichage d'un message lors de l'int�gration de la
                              validation et de la d�validation pour dire que des flux ont d�j� trait�  
 8.00.001.021  20/06/07  JP   FQ 10480 : Gestion du concept VBO
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TRMULVENTEOPCVM_TOF;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  Controls, Classes,
  {$IFDEF EAGLCLIENT}
  eMul, MaineAGL, UtileAGL,
  {$ELSE}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} Mul, FE_Main, EdtREtat, HPdfPrev, uPDFBatch,
  {$ENDIF}
  Forms, SysUtils, HCtrls, HEnt1, HMsgBox, uTob,
  {$IFDEF TRCONF}
  uLibConfidentialite,
  {$ELSE}
  UTOF,
  {$ENDIF TRCONF}
  Menus, UObjGen, HQry, ULibPieceCompta;


type
  {$IFDEF TRCONF}
  TOF_TRMULVENTEOPCVM = class (TOFCONF)
  {$ELSE}
  TOF_TRMULVENTEOPCVM = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
  private
    procedure GererPopup;
    procedure TermineAffichage;
    function  GetValChp(Chp : string; Q : THQuery = nil) : Variant;
  protected
    {Composants et �v�nements du mul}
    PopupMenu : TPopUpMenu;

    procedure BDeleteClick   (Sender : TObject);
    procedure ListDblClick   (Sender : TObject);
  public
    {Tob contenant les �critures � int�grer au "format comptable"}
    TobCompta : TobPieceCompta;
    {Pour le calcul des contrevaleurs}
    ObjDevise : TObjDevise;
    {Pour l'int�gration en compta}
    ObjTva    : TObjTVA;
    {Liste pour le recalcul des soldes}
    lSoldes   : TStringList;

    {V�rifie si au moins une ligne est s�lectionn�e}
    function  TesteSelection : Boolean;
    {Finitions sur les traitements ci-dessous}
    procedure FinirTraitements;
    {09/03/05 : Gestion des impressions}
    procedure GestionImpressions(Clause : string);

    procedure AnnulerVBO     (Sender : TObject);
    procedure ValidationBO   (Sender : TObject);
    procedure IntegreCompta  (Sender : TObject);
    procedure RecalculVente  (Sender : TObject); {FQ 10389}
    procedure Integration    (Q : THQuery = nil);
    procedure MajApresInteg  ;
    function  ValiderBO      (Q : THQuery = nil) : Boolean;
    procedure AnnulationVBO  (Q : THQuery = nil);
    procedure RecalculerVente(Q : THQuery = nil);{FQ 10389}
  end ;

procedure TRLanceFiche_MulVenteOPCVM(Dom, Fiche, Range, Lequel, Arguments : string);


implementation

uses
  TRVENTEOPCVM_TOM, AglInit, HTB97, Commun, UProcEcriture, Constantes, UProcCommission, UProcGen,
  UProcSolde, UObjOPCVM, ParamSoc, FileCtrl, cbpPath, uProcEtat;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_MulVenteOPCVM(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited;
  {06/10/06 : Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
  GereDllEtat(True);

  Ecran.HelpContext := 50000140;
  {Affectation des �v�nements aux menus}
  GererPopup;
  {Autres �v�nements}
  TermineAffichage;

  {Tob contenant les �critures � int�grer au "format comptable"}
  TobCompta := TobPieceCompta.Create('$$$', nil, -1);
  {Cr�ation de l'objet devise pour la gestion des taux de change}
  ObjDevise := TObjDevise.Create(V_PGI.DateEntree);
  lSoldes   := TStringList.Create;
  lSoldes.Duplicates := dupIgnore;
  {Objet qui va permettre une �ventuelle gestion de la TVA lors de l'int�gration en comptabilit�}
  ObjTva := TObjTVA.Create;
  {23/10/06 : Gestion des filtres multi soci�t�s sur banquecp et dossier}
  THValComboBox(GetControl('TVE_GENERAL')).Plus := FiltreBanqueCp(THValComboBox(GetControl('TVE_GENERAL')).DataType, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(ObjTva)    then FreeAndNil(ObjTva);
  if Assigned(ObjDevise) then FreeAndNil(ObjDevise);
  if Assigned(lSoldes)   then LibereListe(lSoldes, True);
  if Assigned(TobCompta) then FreeAndNil(TobCompta);
  {06/10/06 : Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
  GereDllEtat(False);
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.ListDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_TRVenteOPCVM('TR', 'TRFICVENTEOPCVM', GetField('TVE_NUMVENTE'), '', ActionToString(taConsult));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.GererPopup;
{---------------------------------------------------------------------------------------}
begin
  PopupMenu := TPopUpMenu(GetControl('POPUPMENU'));
  PopupMenu.Items[0].OnClick := BDeleteClick;
  PopupMenu.Items[2].OnClick := ValidationBO;
  PopupMenu.Items[3].OnClick := AnnulerVBO;
  PopupMenu.Items[5].OnClick := IntegreCompta;
  PopupMenu.Items[7].OnClick := RecalculVente; {FQ 10389}

  {La validation et le d�nouage ne sont pas accessible � tous le monde
   20/06/07 : FQ 10480 : Gestion du concept VBO
  PopupMenu.Items[2].Enabled := V_PGI.Superviseur;
  PopupMenu.Items[3].Enabled := V_PGI.Superviseur;
  PopupMenu.Items[5].Enabled := AutoriseFonction(dac_Integration);}
  CanValidateBO(PopupMenu.Items[2]);
  CanValidateBO(PopupMenu.Items[3]);
  PopupMenu.Items[5].Visible := AutoriseFonction(dac_Integration);

  AddMenuPop(PopupMenu, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.TermineAffichage;
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF EAGLCLIENT}
  TFMul(Ecran).bSelectAll.Visible := False;
  {$ENDIF}
  TFMul(Ecran).FListe.OnDblClick := ListDblClick;
  TFMul(Ecran).BOuvrir.OnClick   := ListDblClick;
  TToolbarButton97(GetControl('BDELETE')).OnClick := BDeleteClick;
  TToolbarButton97(GetControl('BVBO'   )).OnClick := ValidationBO;
  TToolbarButton97(GetControl('BDVBO'  )).OnClick := AnnulerVBO;
  TToolbarButton97(GetControl('BDATE'  )).OnClick := RecalculVente;
  TToolbarButton97(GetControl('BCPTA'  )).OnClick := IntegreCompta;

  {La validation et le d�nouage ne sont pas accessible � tous le monde
   20/06/07 : FQ 10480 : Gestion du concept VBO
  SetControlEnabled('BVBO'  , V_PGI.Superviseur);
  SetControlEnabled('BDVBO' , V_PGI.Superviseur);
  SetControlEnabled('BCPTA' , AutoriseFonction(dac_Integration));}
  CanValidateBO(GetControl('BVBO'));
  CanValidateBO(GetControl('BDVBO'));
  SetControlVisible('BCPTA' , AutoriseFonction(dac_Integration));
end;

{V�rifie si au moins une ligne est s�lectionn�e
{---------------------------------------------------------------------------------------}
function TOF_TRMULVENTEOPCVM.TesteSelection : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := True;
  {Aucune s�lection, on sort}
  if (TFMul(Ecran).FListe.NbSelected = 0)
  {$IFNDEF EAGLCLIENT}
  and not TFMul(Ecran).FListe.AllSelected
  {$ENDIF}
  then begin
    HShowMessage('0;' + Ecran.Caption + ';Veuillez s�lectionner une ligne.;W;O;O;O;', '', '');
    Result := False;
  end;
  {Vide la liste des comptes pour le recalcul des soldes}
  LibereListe(lSoldes, False);
  {22/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  InitGestionErreur;
end;

{Finitions sur les traitements ci-dessous
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.FinirTraitements;
{---------------------------------------------------------------------------------------}
begin
  MultiRecalculSolde(lSoldes);
  {22/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
  AfficheMessageErreur;
  {Rafra�chissement de la liste}
  TFMul(Ecran).BChercheClick(TFMul(Ecran).BCherche);
end;

{Avec le AllSelected, le GetField est in�ficient : d'o� cette petite fonction
{---------------------------------------------------------------------------------------}
function TOF_TRMULVENTEOPCVM.GetValChp(Chp : string; Q : THQuery = nil) : Variant;
{---------------------------------------------------------------------------------------}
begin
  if Q = nil then Result := GetField(Chp)
             else Result := Q.FindField(Chp).AsVariant;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.BDeleteClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n     : Integer;
  MsgOk : Boolean;
begin
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer le(s) OPCVM s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    MsgOk := False;
    BeginTrans;
    try
      {$IFNDEF EAGLCLIENT}
      TFMul(Ecran).Q.First;
      if TFMul(Ecran).FListe.AllSelected then
        while not TFMul(Ecran).Q.EOF do begin
          {On ne peut supprimer les transactions qui ont d�j� �t� int�gr�es en comptabilit�}
          if TFMul(Ecran).Q.FindField('TVE_COMPTA').AsString <> 'X' then begin
            {Mise � jour des OPCVM et suppression de la vente et des �ventuelles �critures}
            SupprimerVente(TFMul(Ecran).Q.FindField('TVE_NUMVENTE').AsString);

            if TFMul(Ecran).Q.FindField('TVE_VALBO').AsString = 'X' then
              {Mise � jour de la liste pour le recalcul des soldes de la table TRECRITURE}
              AddGestionSoldes(lSoldes, TFMul(Ecran).Q.FindField('TVE_GENERAL').AsString, TFMul(Ecran).Q.FindField('TVE_DATEVENTE').AsDateTime);
          end
          else if not MsgOk then begin
            MessageAlerte(TraduireMemoire('Certaines ventes ont �t� int�gr�es en comptabilit�.'#13 +
                                          'Elles ne peuvent donc �tre supprim�es.'));
            MsgOk := True;
          end;
          TFMul(Ecran).Q.Next;
        end
      else
      {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        {On ne peut supprimer les transactions qui ont d�j� �t� int�gr�es en comptabilit�}
        if VarToStr(GetField('TVE_COMPTA')) <> 'X' then begin
          {Mise � jour des OPCVM et suppression de la vente et des �ventuelles �critures}
          SupprimerVente(VarToStr(GetField('TVE_NUMVENTE')));
          if VarToStr(GetField('TVE_VALBO')) = 'X' then
            {Mise � jour de la liste pour le recalcul des soldes de la table TRECRITURE}
            AddGestionSoldes(lSoldes, VarToStr(GetField('TVE_GENERAL')), VarToDateTime(GetField('TVE_DATEVENTE')));
        end
        else if not MsgOk then begin
          MessageAlerte(TraduireMemoire('Certaines ventes ont �t� int�gr�es en comptabilit�.'#13 +
                                        'Elles ne peuvent donc �tre supprim�es.'));
          MsgOk := True;
        end;
      end;
      CommitTrans;
    except
      on E : Exception do begin
        RollBack;
        PGIError(E.Message);
        {On sort pour ne pas ex�cuter FinirTraitements;}
        Exit;
      end;
    end;
    FinirTraitements;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.AnnulerVBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  B : Boolean;{05/02/07 : FQ 10231}
begin
  B := False;

  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir annuler la validation Back Office de(s) vente(s) s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if TFMul(Ecran).FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        {On d�valide les op�rations valid�es}
        if (TFMul(Ecran).Q.FindField('TVE_VALBO').AsString = 'X') then
          AnnulationVBO(TFMul(Ecran).Q)
        else
          B := True;{05/02/07 : FQ 10231}

        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

    {On boucle sur la s�lection}
    for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
      TFMul(Ecran).FListe.GotoLeBookmark(n);
      {On d�valide les op�rations valid�es}
      if (VarToStr(GetField('TVE_VALBO')) = 'X') then
        AnnulationVBO
      else
        B := True;{05/02/07 : FQ 10231}
    end;

    {05/02/07 : FQ 10231 : affichage d'un message}
    if B then
      HShowMessage('1;' + Ecran.Caption + ';Certaines transactions n''�taient pas valid�es et n''ont donc pas �t� trait�es.;I;O;O;O;', '', '');

    FinirTraitements;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.ValidationBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  c : string;
  B : Boolean;{05/02/07 : FQ 10231 : suite}
begin
  B := False;
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir valider Back Office le(s) vente(s) s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if TFMul(Ecran).FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        if TFMul(Ecran).Q.FindField('TVE_VALBO').AsString <> 'X' then begin
          if ValiderBO(TFMul(Ecran).Q) then {09/03/05 : Gestion des �tats automatiques}
            c := c + TFMul(Ecran).Q.FindField('TVE_NUMVENTE').AsString + ', ';
        end
        else
          B := True;{05/02/07 : FQ 10231}

        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        if VarToStr(GetField('TVE_VALBO')) <> 'X' then begin
          if ValiderBO then {09/03/05 : Gestion des �tats automatiques}
            {19/09/05 : FQ 10290 : Manquait l'espace apr�s la virgule, ce qui fait que dans
                        GestionImpressions, le Delete de 2 caract�res modifiait le num�ro de la vente}
            c := c + VarToStr(GetField('TVE_NUMVENTE')) + ', ';
        end
        else
          B := True;{05/02/07 : FQ 10231}
      end;

    {05/02/07 : FQ 10231 : affichage d'un message}
    if B then
      HShowMessage('1;' + Ecran.Caption + ';Certaines transactions �taient d�j� valid�es et n''ont donc pas �t� trait�es.;I;O;O;O;', '', '');

    GestionImpressions(c);
    FinirTraitements;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.IntegreCompta(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  B : Boolean;{05/02/07 : FQ 10231 : suite}
begin
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  B := False;
  
  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir int�grer en comptabilit� les �critures'#13 +
                  'attach�es aux ventes s�lectionn�s ?;Q;YNC;N;C;', '', '') = mrYes then begin
    {On commence par vider la tob contenant les �critures de comptabilit�}
    TobCompta.ClearDetailPC;
    
    BeginTrans;
    try
      {$IFNDEF EAGLCLIENT}
      TFMul(Ecran).Q.First;
      if TFMul(Ecran).FListe.AllSelected then
        while not TFMul(Ecran).Q.EOF do begin
          {On n'int�gre en comptabilit� que les op�rations valid�es BO}
          if (TFMul(Ecran).Q.FindField('TVE_VALBO').AsString = 'X') and
             (TFMul(Ecran).Q.FindField('TVE_COMPTA').AsString <> 'X') then
            {Pr�paration de la TobCompta}
            Integration(TFMul(Ecran).Q)
          else
            B := True;{05/02/07 : FQ 10231}

          TFMul(Ecran).Q.Next;
        end
      else
      {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        {On n'int�gre en comptabilit� que les op�rations valid�es BO}
        if (VarToStr(GetField('TVE_VALBO')) = 'X') and (VarToStr(GetField('TVE_COMPTA')) <> 'X') then
          {Pr�paration de la TobCompta}
          Integration
        else
          B := True;{05/02/07 : FQ 10231}
      end;

      {Si des lignes d'�critures comptables ont �t� g�n�r�es ...}
      if TobCompta.Detail.Count > 0 then begin
        {22/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
        AfficheMessageErreur;

        {18/09/06 : Nouvelle fonction de traitement Multi-soci�t�s}
        if TRIntegrationPieces(TobCompta, False) then
          MajApresInteg;
      end;

      CommitTrans;
    except
      on E : Exception do begin
        RollBack;
        PGIError(E.Message);
      end;
    end;
    {05/02/07 : FQ 10231 : affichage d'un message, suite ...}
    if B then
      HShowMessage('1;' + Ecran.Caption + ';Certaines transactions �taient d�j� int�gr�es et n''ont donc pas �t� trait�es.;I;O;O;O;', '', '');
    FinirTraitements;
  end;
end;

{Pr�paration de la TobCompta
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.Integration(Q : THQuery = nil);
{---------------------------------------------------------------------------------------}
var
  Cle   : string;
  tEcr  : TOB;
begin
  {Si la transaction a d�j� �t� int�gr�, on sort}
  if VarToStr(GetValChp('TVE_COMPTA', Q)) = 'X' then Exit;

  Cle := GetNumTransacVente(VarToStr(GetValChp('TVE_NUMVENTE', Q)), True);
  if Cle = '' then Exit;

  tEcr := TOB.Create('���', nil, -1);
  try
    tEcr.LoadDetailFromSQL('SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + Cle + '"');
    {S'il n'y a pas d'�critures pour la transaction !!?}
    if tEcr.Detail.Count = 0 then Exit;
    {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
    TRGenererPieceCompta(TobCompta, tEcr);
  finally
    if Assigned(tEcr) then FreeAndNil(tEcr);
  end;
end;

{Mise � jour des tables TRECRITURE et TROPCVM apr�s l'int�gration
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.MajApresInteg;
{---------------------------------------------------------------------------------------}
var
  T   : TOB;
  n   : Integer;
  SQL : string;
  Cle : string;
begin
  try
    {On Stocke le num�ro de transaction dans la r�f�rence interne}
    TobCompta.Detail.Sort('E_REFINTERNE');
    {On boucle sur les �critures comptables}
    for n := 0 to TobCompta.Detail.Count - 1 do begin
      T := TobCompta.Detail[n];
      {Si l'int�gration s'est bien pass�e ...}
      if (T.GetString('RESULTAT') = 'OK') and (T.Detail.Count > 0) then begin
        {... on regarde si on a chang� de transaction sachant que pour une OPCVM on peut avoir plusieurs
         �critures de Tr�osrerie et que pour chacune de ces derni�res on a deux ou trois �critures comptables}
        Cle := T.Detail[0].GetString('E_REFINTERNE');
        Cle := ReadTokenPipe(Cle, '-');
        {Mise � jour des �critures int�gr�es en comptabilit�}
        UpdatePieceStr('', Cle, '', '', 'TE_NATURE', na_Realise);
        {Mise � jour de la table TROPCVM}
        SQL := 'UPDATE TRVENTEOPCVM SET TVE_USERCOMPTA = "' +  V_PGI.User + '", TVE_COMPTA = "X", ' +
               'TVE_USERMODIF = "' + V_PGI.User + '", TVE_DATEMODIF = "' + UsDateTime(Now) +
               '", TVE_DATECOMPTA = "' + USDateTime(v_PGI.DateEntree) + '" WHERE TVE_NUMVENTE = ' + GetNumTransacVente(Cle, False);
        ExecuteSQL(SQL);
      end;
    end;
  except
    raise;
  end;
end;

{G�n�ration de la ligne d'�criture correspondant � l'achat d'un OPCVM
{---------------------------------------------------------------------------------------}
function TOF_TRMULVENTEOPCVM.ValiderBO(Q : THQuery = nil) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := True;
  BeginTrans;
  try
    CreerEcritureVenteOPCVM(lSoldes, VarToStr(GetValChp('TVE_NUMVENTE', Q)), ObjDevise);
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      Result := False;
      PGIError(E.Message);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.AnnulationVBO(Q : THQuery = nil);
{---------------------------------------------------------------------------------------}
begin
  {On ne peut d�valider une op�ration int�gr�e en comptabilit�}
  if VarToStr(GetValChp('TVE_COMPTA', Q)) = 'X' then begin
    {16/03/05 : FQ 10223 : Nouvelle gestion des messages d'erreur sur les �critures}
    ErreurCategorie.TypeErreur := ErreurCategorie.TypeErreur + [CatErr_TRE];
    ErreurCategorie.TrEcriture := ErreurCategorie.TrEcriture + [NatErr_Int];
    Exit;
  end;

  BeginTrans;
  try
    SupprEcritureVenteOPCVM(VarToStr(GetValChp('TVE_NUMVENTE', Q)));
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      PGIError(E.Message);
    end;
  end;
  {Mise � jour de la liste de recalcul des soldes}
  AddGestionSoldes(lSoldes, VarToStr(GetValChp('TVE_GENERAL', Q)), VarToDateTime(GetValChp('TVE_DATEVENTE', Q)));
end;

{09/03/05 : Gestion des impressions
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.GestionImpressions(Clause : string);
{---------------------------------------------------------------------------------------}
var
  c : string;
  s : string;
begin
  {14/09/05 : Test l'existence du r�pertoire sinon en CWas, cela plante}
  if not DirectoryExists(GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData, True)) then begin
    HShowMessage('0;' + Ecran.Caption + ';Le r�pertoire de sortie des �ditions n''existe pas.'#13 +
                                        'Veuillez v�rifier le param�tre soci�t�.;W;O;O;O;', '', '');
    Exit;
  end;

  if (Clause <> '') and (GetParamSocSecur('SO_TICKETOPE', False) or
     GetParamSocSecur('SO_LETTRECONFIRM', False) or GetParamSocSecur('SO_ORDREPAIEMENT', False)) then begin
    {Constitution de la clause Where � partir des num�ro de transaction}
    System.Delete(Clause, Length(Clause) - 1, 2);
    Clause := 'TVE_NUMVENTE IN (' + Clause + ')';
    {Constitution du r�pertoire de sortie}
    c := GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData) + '\TRANSAC.PDF';
    {Pour n'appeler qu'une fois l'aper�u}
    V_PGI.NoPrintDialog := True;
    V_PGI.QRPDF := True;
    V_PGI.QRPDFQueue := c;
    V_PGI.QRPDFMerge := c;
    try
      StartPDFBatch(c);

      if GetParamSocSecur('SO_TICKETOPE', False) then begin
        LanceEtat('E', 'TVT', 'TVT', True, False, False, nil, Clause, '', False); {Ticket d'Op�ration}
        S := 'UPDATE TRVENTEOPCVM SET TVE_TICKET = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_LETTRECONFIRM', False) then begin
        LanceEtat('E', 'TVL', 'TVL', True, False, False, nil, Clause, '', False);{Lettre de confirmation}
        S := 'UPDATE TRVENTEOPCVM SET TVE_LETTRECONFIRM = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_ORDREPAIEMENT', False) then begin
        LanceEtat('E', 'TVO', 'TVO', True, False, False, nil, Clause, '', False);{Ordre de paiement}
        S := 'UPDATE TRVENTEOPCVM SET TVE_ORDREPAIE = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      CancelPDFBatch;

      {$IFNDEF EAGLCLIENT}
      {FQ 10044 : Copy du fichier PDF car celui g�n�rer par l'AGL est supprimer apr�s l'aper�u}
      CopierFichier(c, GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData), 'VENTEOPCVM', 'PDF');
      PreviewPDFFile('', c);
      {$ENDIF}
    finally
      V_PGI.QRPDF := False;
      V_PGI.QRPDFQueue := '';
      V_PGI.QRPDFMerge := '';
    end;
  end;
end;

{19/12/06 : FQ 10389 : pouvoir recalculer la vente si les cours ont �t� modifi�s
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.RecalculerVente(Q : THQuery = nil);
{---------------------------------------------------------------------------------------}
var
  Obj : TObjCalculPMVR;
begin
  {Cr�ation de l'objet de recalcul}
  Obj := TObjCalculPMVR.CreateAvecVente(VarToInt(GetValChp('TVE_NUMVENTE', Q)));
  try
    {Recalcul des montants des OPCVM correspondant � la vente et mise � jour de la vente}
    Obj.CalculVente(False);
  finally
    FreeAndNil(Obj);
  end;
end;

{19/12/06 : FQ 10389 : pouvoir recalculer la vente si les cours ont �t� modifi�s
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVENTEOPCVM.RecalculVente(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir recalculer le(s) vente(s) s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if TFMul(Ecran).FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        {On d�valide les op�rations valid�es}
        if (TFMul(Ecran).Q.FindField('TVE_VALBO').AsString <> 'X') then
          RecalculerVente(TFMul(Ecran).Q);
        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

    {On boucle sur la s�lection}
    for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
      TFMul(Ecran).FListe.GotoLeBookmark(n);
      {On d�valide les op�rations valid�es}
      if (VarToStr(GetField('TVE_VALBO')) <> 'X') then
        RecalculerVente;
    end;
    FinirTraitements;
  end;
end;

initialization
  RegisterClasses([TOF_TRMULVENTEOPCVM]);

end.
