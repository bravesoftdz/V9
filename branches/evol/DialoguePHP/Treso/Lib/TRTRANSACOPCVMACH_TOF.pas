{-------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 6.20.xxx.xxx  24/11/04  JP   Cr�ation de l'unit�
 6.30.001.003  09/03/05  JP   Gestion des impressions des �tats
 6.50.001.001  20/05/05  JP   Gestion de l'affichage des devises
 6.50.001.018  14/09/05  JP   Ajout d'un test sur l'existence du r�pertoire "SO_REPSORTIEPDF"
                              afin d'�viter de planter l'application
 6.50.001.019  19/09/05  JP   FQ 10293 : La TobCompta �tait mal tri�e, ce qui cr�e des
                              �critures d�s�quilibr�es en comptabilit�
 7.00.001.001  12/01/06  JP   FQ 10323 : Correction de la gestion de la TVA
 7.09.001.001  18/09/06  JP   Mise en place de l'int�gration multi-soci�t�s
 7.09.001.001  04/10/06  JP   FQ 10231 : Affichage d'un message lors de la (d�)validation des
                              transactions si des pi�ces de la s�lection ont d�j� �t� trait�es
 7.09.001.001  06/10/06  JP   Gestion des ParamSoc multi soci�t�s
 7.09.001.001  23/10/06  JP   Gestion des filtres Multi soci�t�s
 7.09.001.005  05/02/07  JP   FQ 10231 (suite) : Affichage d'un message lors de l'int�gration en compta
 8.00.001.021  20/06/07  JP   FQ 10480 : Gestion du concept VBO
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TRTRANSACOPCVMACH_TOF;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  StdCtrls, Controls, Classes,
  {$IFDEF EAGLCLIENT}
  eMul, MaineAGL, UtileAGL,
  {$ELSE}
  db, {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} Mul, FE_Main, EdtREtat, HPdfPrev, uPDFBatch,
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
  TOF_TRTRANSACOPCVMACH = class (TOFCONF)
  {$ELSE}
  TOF_TRTRANSACOPCVMACH = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
  private
    {Traitements sur l'interface utilisateur et fonctions diverses}
    procedure GererPopup;
    procedure TermineAffichage;
    function  GetValChp(Chp : string; Q : THQuery = nil) : Variant;
  protected
    {Composants et �v�nements du mul}
    PopupMenu : TPopUpMenu;

    procedure BInsertClick   (Sender : TObject);
    procedure BDeleteClick   (Sender : TObject);
    procedure ListDblClick   (Sender : TObject);
    {20/05/05 : Gestion des devises en fonction du code OPCVM}
    procedure CodeOpcvmClick (Sender : TObject);
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
    procedure Integration    (Q : THQuery = nil);
    procedure MajApresInteg  ;
    function  ValiderBO      (Q : THQuery = nil) : Boolean;
    procedure AnnulationVBO  (Q : THQuery = nil);
  end ;

procedure TRLanceFiche_TRansacOpcvmAch(Dom, Fiche, Range, Lequel, Arguments : string);


implementation

uses
  TROPCVM_TOM, AglInit, HTB97, Commun, UProcEcriture, Constantes, UProcCommission, UProcGen,
  UProcSolde, UObjOPCVM, ParamSoc, FileCtrl, cbpPath, UProcEtat;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_TRansacOpcvmAch(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited;
  {06/10/06 : Pour la gestion de la fonction de r�cup�ration des paramsoc multi soci�t�s}
  GereDllEtat(True);

  Ecran.HelpContext := 50000137;
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
  {20/05/05 : Pour la gestion des devises}
  THValComboBox(GetControl('TOP_CODEOPCVM')).OnChange := CodeOpcvmClick;
  CodeOpcvmClick(GetControl('TOP_CODEOPCVM'));
  {23/10/06 : Gestion des filtres multi soci�t�s sur banquecp et dossier}
  THValComboBox(GetControl('TOP_GENERAL')).Plus := FiltreBanqueCp(THValComboBox(GetControl('TOP_GENERAL')).DataType, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.OnClose;
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
procedure TOF_TRTRANSACOPCVMACH.BInsertClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_OPCVM('TR', 'TROPCVM', '', '', ActionToString(taCreat));
  TFMul(Ecran).BChercheClick(TFMul(Ecran).BCherche);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.BDeleteClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n     : Integer;
  MsgOk : Boolean;
  Gene  : string;
  NumO  : string;
  aDate : TDateTime;
  ValBo : Boolean;
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
          if TFMul(Ecran).Q.FindField('TOP_COMPTA').AsString <> 'X' then begin
            Gene  := TFMul(Ecran).Q.FindField('TOP_GENERAL').AsString;
            NumO  := TFMul(Ecran).Q.FindField('TOP_NUMOPCVM').AsString;
            aDate := TFMul(Ecran).Q.FindField('TOP_DATEACHAT').AsDateTime;
            ValBo := TFMul(Ecran).Q.FindField('TOP_VALBO').AsString = 'X';
            {Suppression des Achats et �critures attach�s � ce num�ro de transaction}
            SupprimerOPCVM(NumO);

            if ValBo then
              {Mise � jour de la liste pour le recalcul des soldes de la table TRECRITURE}
              AddGestionSoldes(lSoldes, Gene, aDate);
          end
          else if not MsgOk then begin
            MessageAlerte(TraduireMemoire('Certaines transactions ont �t� int�gr�es en comptabilit�.'#13 +
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
        if VarToStr(GetField('TOP_COMPTA')) <> 'X' then begin
          Gene  := VarToStr(GetField('TOP_GENERAL'));
          NumO  := VarToStr(GetField('TOP_NUMOPCVM'));
          aDate := VarToDateTime(GetField('TOP_DATEACHAT'));
          ValBo := VarToStr(GetField('TOP_VALBO')) = 'X';
          {Suppression des Achats et �critures attach�s � ce num�ro de transaction}
          SupprimerOPCVM(NumO);

          if ValBo then
            {Mise � jour de la liste pour le recalcul des soldes de la table TRECRITURE}
            AddGestionSoldes(lSoldes, Gene, aDate);
        end
        else if not MsgOk then begin
          MessageAlerte(TraduireMemoire('Certaines transactions ont �t� int�gr�es en comptabilit�.'#13 +
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
procedure TOF_TRTRANSACOPCVMACH.ListDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
 if GetField('TOP_VALBO') = 'X' then
  TRLanceFiche_OPCVM('TR', 'TROPCVM', '', GetField('TOP_NUMOPCVM'), ActionToString(taConsult))
 else
  TRLanceFiche_OPCVM('TR', 'TROPCVM', '', GetField('TOP_NUMOPCVM'), ActionToString(taModif));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.GererPopup;
{---------------------------------------------------------------------------------------}
begin
  PopupMenu := TPopUpMenu(GetControl('POPUPMENU'));
  PopupMenu.Items[0].OnClick := BInsertClick;
  PopupMenu.Items[1].OnClick := ListDblClick;
  PopupMenu.Items[2].OnClick := BDeleteClick;
  PopupMenu.Items[4].OnClick := ValidationBO;
  PopupMenu.Items[5].OnClick := AnnulerVBO;
  PopupMenu.Items[7].OnClick := IntegreCompta;
  {La validation et le d�nouage ne sont pas accessible � tous le monde
   20/06/07 : FQ 10480 : Gestion du concept VBO
  PopupMenu.Items[4].Enabled := V_PGI.Superviseur;
  PopupMenu.Items[5].Enabled := V_PGI.Superviseur;
  PopupMenu.Items[7].Enabled := AutoriseFonction(dac_Integration);}
  CanValidateBO(PopupMenu.Items[4]);
  CanValidateBO(PopupMenu.Items[5]);
  PopupMenu.Items[7].Visible := AutoriseFonction(dac_Integration);

  AddMenuPop(PopupMenu, '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.TermineAffichage;
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF EAGLCLIENT}
  TFMul(Ecran).bSelectAll.Visible := False;
  {$ENDIF}
  TFMul(Ecran).FListe.OnDblClick := ListDblClick;
  TFMul(Ecran).BOuvrir.OnClick   := ListDblClick;
  TFMul(Ecran).BInsert.OnClick   := BInsertClick;
  TToolbarButton97(GetControl('BDELETE')).OnClick := BDeleteClick;
  TToolbarButton97(GetControl('BVBO'   )).OnClick := ValidationBO;
  TToolbarButton97(GetControl('BDVBO'  )).OnClick := AnnulerVBO;
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
function TOF_TRTRANSACOPCVMACH.TesteSelection : Boolean;
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
procedure TOF_TRTRANSACOPCVMACH.FinirTraitements;
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
function TOF_TRTRANSACOPCVMACH.GetValChp(Chp : string; Q : THQuery = nil) : Variant;
{---------------------------------------------------------------------------------------}
begin
  if Q = nil then Result := GetField(Chp)
             else Result := Q.FindField(Chp).AsVariant;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.AnnulerVBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  B : Boolean;{04/10/06 : FQ 10231}
begin
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir annuler la validation Back Office de(s) OPCVM s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    B := False;
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if TFMul(Ecran).FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        {On d�valide les op�rations valid�es}
        if (TFMul(Ecran).Q.FindField('TOP_VALBO').AsString = 'X') then
          AnnulationVBO(TFMul(Ecran).Q)
        else
          B := True;{04/10/06 : FQ 10231}
        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        {On d�valide les op�rations valid�es}
        if (VarToStr(GetField('TOP_VALBO')) = 'X') then
          AnnulationVBO
        else
          B := True;{04/10/06 : FQ 10231}
      end;

    {04/10/06 : FQ 10231 : affichage d'un message}
    if B then
      HShowMessage('1;' + Ecran.Caption + ';Certaines transactions n''�taient pas valid�es et n''ont donc pas �t� trait�es.;I;O;O;O;', '', '');
    FinirTraitements;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.ValidationBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  C : string;
  B : Boolean;{04/10/06 : FQ 10231}
begin
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir valider Back Office le(s) OPCVM s�lectionn�(s) ?;Q;YNC;N;C;', '', '') = mrYes then begin
    B := False;

    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if TFMul(Ecran).FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        if TFMul(Ecran).Q.FindField('TOP_VALBO').AsString <> 'X' then begin
          if ValiderBO(TFMul(Ecran).Q) then {09/03/05 : Gestion des �tats automatiques}
            c := c + '"' + TFMul(Ecran).Q.FindField('TOP_NUMOPCVM').AsString + '",';
        end
        else
          B := True;{04/10/06 : FQ 10231}
        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        if VarToStr(GetField('TOP_VALBO')) <> 'X' then begin
          if ValiderBO then {09/03/05 : Gestion des �tats automatiques}
            c := c + '"' + VarToStr(GetField('TOP_NUMOPCVM')) + '",';
        end
        else
          B := True;{04/10/06 : FQ 10231}
      end;

    {04/10/06 : FQ 10231 : affichage d'un message}
    if B then
      HShowMessage('1;' + Ecran.Caption + ';Certaines transactions �taient d�j� valid�es et n''ont donc pas �t� trait�es.;I;O;O;O;', '', '');
    GestionImpressions(c);

    FinirTraitements;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.IntegreCompta(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  B : Boolean;{05/02/07 : FQ 10231 : suite}
begin
  B := False;
  {On v�rifie si il y a une s�lection}
  if not TesteSelection then Exit;

  if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir int�grer en comptabilit� les �critures'#13 +
                  'attach�es aux OPCVM s�lectionn�s ?;Q;YNC;N;C;', '', '') = mrYes then begin
    {On commence par vider la tob contenant les �critures de comptabilit�}
    TobCompta.ClearDetailPC;
    
    BeginTrans;
    try
      {$IFNDEF EAGLCLIENT}
      TFMul(Ecran).Q.First;
      if TFMul(Ecran).FListe.AllSelected then
        while not TFMul(Ecran).Q.EOF do begin
          {On n'int�gre en comptabilit� que les op�rations valid�es BO}
          if (TFMul(Ecran).Q.FindField('TOP_VALBO').AsString = 'X') and
             (TFMul(Ecran).Q.FindField('TOP_COMPTA').AsString <> 'X') then
            {Pr�paration de la TobCompta}
            Integration(TFMul(Ecran).Q)
          else
            B := True;{05/02/07 : FQ 10231 : suite ...}
            
          TFMul(Ecran).Q.Next;
        end
      else
      {$ENDIF}

      {On boucle sur la s�lection}
      for n := 0 to TFMul(Ecran).FListe.nbSelected - 1 do begin
        TFMul(Ecran).FListe.GotoLeBookmark(n);
        {On n'int�gre en comptabilit� que les op�rations valid�es BO}
        if (VarToStr(GetField('TOP_VALBO')) = 'X') and (VarToStr(GetField('TOP_COMPTA')) <> 'X') then
          {Pr�paration de la TobCompta}
          Integration
        else
          B := True;{05/02/07 : FQ 10231 : suite ...}
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
        Exit;
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
procedure TOF_TRTRANSACOPCVMACH.Integration(Q : THQuery = nil);
{---------------------------------------------------------------------------------------}
var
  Cle   : string;
  tEcr  : TOB;
begin
  {Si la transaction a d�j� �t� int�gr�, on sort}
  if VarToStr(GetValChp('TOP_COMPTA', Q)) = 'X' then Exit;

  Cle := VarToStr(GetValChp('TOP_NUMOPCVM', Q));
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
procedure TOF_TRTRANSACOPCVMACH.MajApresInteg;
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
        SQL := 'UPDATE TROPCVM SET TOP_USERCOMPTA = "' +  V_PGI.User + '", TOP_COMPTA = "X", ' +
               'TOP_USERMODIF = "' + V_PGI.User + '", TOP_DATEMODIF = "' + UsDateTime(Now) +
               '", TOP_DATECOMPTA = "' + USDateTime(v_PGI.DateEntree) + '" WHERE TOP_NUMOPCVM = "' + Cle + '"';
        ExecuteSQL(SQL);
      end;
    end;
  except
    raise;
  end;
end;

{G�n�ration de la ligne d'�criture correspondant � l'acaht d'une OPCVM
{---------------------------------------------------------------------------------------}
function TOF_TRTRANSACOPCVMACH.ValiderBO(Q : THQuery = nil) : Boolean;
{---------------------------------------------------------------------------------------}
var
  T : TOB;
begin
  Result := True;

  BeginTrans;
  try
    T := TOB.Create('TRECRITURE', nil, -1);
    try
      {Initialisation de l'�criture}
      InitNlleEcritureTob(T, GetValChp('TOP_GENERAL', Q), GetValChp('TOP_SOCIETE', Q));
      {Reprise des champs de la transaction}
      T.SetDateTime('TE_DATECOMPTABLE', GetValChp('TOP_DATEACHAT', Q));
      T.SetString('TE_LIBELLE', GetValChp('TOP_LIBELLE', Q));
      T.SetString('TE_REFINTERNE', GetValChp('TOP_REFERENCE', Q));
      T.SetString('TE_NUMTRANSAC', GetValChp('TOP_NUMOPCVM', Q));

      {R�cup�ration des informations depuis la table FluxTreso : Le flux est celui param�tr� comme
       �tant celui de versement dans la table Transac}
      ChargeChpFluxTreso(T, GetField('TOP_TRANSACTION'), VERSEMENT);

      {Les montants sont n�gatifs puisqu'il s'agit d'un achat}
      T.SetDouble('TE_MONTANT', -1 * Abs(Valeur(GetField('TOP_MONTANTACH'))));
      {Termine l'�criture, g�re les commissions et l'ins�re dans la rable}

      {22/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
      if not TermineEcritureTob(T, ObjDevise, True) then begin
        RollBackDiscret;
        Result := False;
        Exit;
      end;

      ExecuteSQL('UPDATE TROPCVM SET TOP_VALBO = "X", TOP_USERVBO = "' + V_PGI.User + '", TOP_DATEVBO = "' +
                 UsDateTime(V_PGI.DateEntree) + '", TOP_USERMODIF = "' + V_PGI.User + '", TOP_DATEMODIF = "' +
                 UsDateTime(Now) + '" WHERE TOP_NUMOPCVM = "' + GetValChp('TOP_NUMOPCVM', Q) + '"');
      CommitTrans;
      AddGestionSoldes(lSoldes, VarToStr(GetValChp('TOP_GENERAL', Q)), VarToDateTime(GetValChp('TOP_DATEACHAT', Q)));
    finally
      FreeAndNil(T);
    end;
  except
    on E : Exception do begin
      RollBack;
      PGIError(E.Message);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.AnnulationVBO(Q : THQuery = nil);
{---------------------------------------------------------------------------------------}
begin
  {On ne peut d�valider une op�ration int�gr�e en comptabilit�}
  if VarToStr(GetValChp('TOP_COMPTA', Q)) = 'X' then begin
    {22/03/05 : FQ 10223 : Nouvelle gestion des erreurs}
    ErreurCategorie.TypeErreur := ErreurCategorie.TypeErreur + [CatErr_TRE];
    ErreurCategorie.TrEcriture := ErreurCategorie.TrEcriture + [NatErr_Int];
    Exit;
  end;

  BeginTrans;
  try
    {Suppression des �critures li�es � la transaction : opcvm, frais, commissions}
    if SupprimePiece(GetValChp('TOP_NODOSSIER', nil), GetValChp('TOP_NUMOPCVM', nil), '', '') then
      {Mise � jour de la table TROPCVM}
      ExecuteSQL('UPDATE TROPCVM SET TOP_VALBO = "", TOP_USERVBO = "", TOP_DATEVBO = "' + UsDateTime(iDate1900) +
                 '", TOP_USERMODIF = "' + V_PGI.User + '", TOP_DATEMODIF = "' + UsDateTime(Now) +
                 '" WHERE TOP_NUMOPCVM = "' + GetValChp('TOP_NUMOPCVM', Q) + '"');
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      PGIError(E.Message);
      Exit;
    end;
  end;
  {Mise � jour de la liste de recalcul des soldes}
  AddGestionSoldes(lSoldes, VarToStr(GetValChp('TOP_GENERAL', Q)), VarToDateTime(GetValChp('TOP_DATEACHAT', Q)));
end;

{09/03/05 : Gestion des impressions
{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.GestionImpressions(Clause : string);
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
    System.Delete(Clause, Length(Clause), 1);
    Clause := 'TOP_NUMOPCVM IN (' + Clause + ')';
    {Constitution du r�pertoire de sortie}
    c := GetParamSocSecur('SO_REPSORTIEPDF', 'c:') + '\TRANSAC.PDF';
    {Pour n'appeler qu'une fois l'aper�u}
    V_PGI.NoPrintDialog := True;
    V_PGI.QRPDF := True;
    V_PGI.QRPDFQueue := c;
    V_PGI.QRPDFMerge := c;
    try
      StartPDFBatch(c);

      if GetParamSocSecur('SO_TICKETOPE', False) then begin
        LanceEtat('E', 'TAT', 'TAT', True, False, False, nil, Clause, '', False); {Ticket d'Op�ration}
        S := 'UPDATE TROPCVM SET TOP_TICKET = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_LETTRECONFIRM', False) then begin
        LanceEtat('E', 'TAL', 'TAL', True, False, False, nil, Clause, '', False);{Lettre de confirmation}
        S := 'UPDATE TROPCVM SET TOP_LETTRECONFIRM = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      if GetParamSocSecur('SO_ORDREPAIEMENT', False) then begin
        LanceEtat('E', 'TAO', 'TAO', True, False, False, nil, Clause, '', False);{Ordre de paiement}
        S := 'UPDATE TROPCVM SET TOP_ORDREPAIE = "X" WHERE ' + Clause;
        ExecuteSQL(S);
      end;

      CancelPDFBatch;

      {$IFNDEF EAGLCLIENT}
      {FQ 10044 : Copy du fichier PDF car celui g�n�rer par l'AGL est supprimer apr�s l'aper�u}
      CopierFichier(c, GetParamSocSecur('SO_REPSORTIEPDF', TcbpPath.GetCegidUserLocalAppData), 'ACHATOPCVM', 'PDF');
      PreviewPDFFile('', c);
      {$ENDIF}
    finally
      V_PGI.QRPDF := False;
      V_PGI.QRPDFQueue := '';
      V_PGI.QRPDFMerge := '';
    end;
  end;
end;

{20/05/05 : Affichage de la devise et du drapeau en fonction du code OPCVM
{---------------------------------------------------------------------------------------}
procedure TOF_TRTRANSACOPCVMACH.CodeOpcvmClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  MajAffichageDevise(GetControl('IDEV'), GetControl('DEV'), GetControlText('TOP_CODEOPCVM'), sd_Opcvm);
end;

initialization
  RegisterClasses([TOF_TRTRANSACOPCVMACH]);

end.


