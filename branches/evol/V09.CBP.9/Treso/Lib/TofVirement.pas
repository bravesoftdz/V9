{***********UNITE*************************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 11/12/2001
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : VIREMENT ()
               : JP 03/08/03 : Migration eAGL
Mots clefs ... : TOF;VIREMENT
*****************************************************************}
{-------------------------------------------------------------------------------------
  Version   |   Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
               11/12/01  BT   Cr�ation de l'unit�
   5.0.4       27/02/04  JP   Modification de l'appel � la fiche de suivi
                              D�placement de la boucle sur TobVir de OnArgument vers ChargerTobVir
 1.0.5.001     22/03/04  JP   Mise en place d'une variable d'interruption ('Interrompre') des
                              traitements en cas d'anomalies (pour le moment sur le CIB)
 1.9.0.XXX     28/06/04  JP   Les �critures de tr�sorerie ne sont plus modifi�eslors de la
                              g�n�ration des virements. Maintenant le fonctionnement est
                              1/ Validation / d�validtion BO => cr�ation /suppression des TREcritures
                              2/ G�n�ration du fichier => r�alisation des TREcritures et �ventuellement,
                                 si l'utilissateur et le ParamSoc l'autorise, int�gration en comptabilit�
 6.0x.xxx.xxx  20/07/04  JP   Gestion des commissions dans la r�alisation et l'int�gration
                              cf PrepareEcriture et PrepareIntegration
 6.00.014.001  16/09/04  JP   On ne passe plus par les transactions, mais directement par les codes flux
                              au moment de la g�n�ration des ecritures de Tr�sorerie FQ 10136
 6.00.015.001  20/09/04  JP   FQ 10137 : Utilisation de la propri�t� ForcePresentationChange au lieu
                              if not V_PGI.AutoSearch then TFStat(Ecran).ChercheClick;
 6.30.001.002  02/03/05  JP   FQ 10210 : les commissions ne sont pas distingu�es des virements, ce qui fait
                              que lors de l'int�gration en comptabilit� on ne tient pas compte du compte de
                              contrepartie du flux commission et l'on met d'office le "Compte poublelle" (580xxx)
 6.30.001.005  23/03/05  JP   FQ 10223 : nouvelle gestion des messages d'erreur lors de la g�n�ration d'�critute
                              REMARQUE : j'en profite pour mettre en place une int�gration bas�e sur des Tobs
                                         et non plus les structures TrEcriture (cf. PrepareIntegration)
 7.00.001.001  12/01/06  JP   FQ 10323 : Correction de la gestion de la TVA
 7.09.001.001  07/08/06  JP   Gestion du Multi soci�t�s : SNODOSSIER, DNODOSSIER, BQ_CODE
 7.09.001.001  18/09/06  JP   Int�gration multi-soci�t�s
 7.09.001.001  19/09/06  JP   Rupture dans les fichiers sur la soci�t�s en plus de la banque et de la devise
 7.09.001.001  11/10/06  JP   FQ 10379 : ajout du param�trage de l'�tat
 8.00.001.021  20/06/07  JP   FQ 10480 : Gestion du concept VBO
 8.10.001.004  13/08/07  JP   Gestion des confidentialit�s : On filtre les virements � l'affichage : cf. ChargerTobVir
--------------------------------------------------------------------------------------}
unit TofVirement ;

interface

uses
  StdCtrls, Controls, Classes, Constantes, CFONB, UtilPGI,
  {$IFDEF EAGLCLIENT}
  MaineAGL, UtileAGL,
  {$ELSE}
  FE_Main, db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} EDtREtat,
  {$ENDIF}
  Forms, SysUtils, FileCtrl, HCtrls, HEnt1, HMsgBox, UTOF, UTOB, Menus, UObjGen,
  HStatus, ULibPieceCompta;

type
  TOF_VIREMENT = class (TOF)
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
  protected
    {A "X" si au moins un virement a �t� fait}
    TREcritureModified : string;
    PopupMenu      : TPopUpMenu;
    TobVir         : TOB;
    {Tob pour le LanceEtatTob pour les lettres de confirmations}
    TobLettre      : TOB;
    {Tob pour l'int�gration en compta}
    TobCompta      : TobPieceCompta;
    LettreConfirm  : Boolean;
    FichierOk      : Boolean;
    CheminVirement : string;
    CptePoubelle   : string;
    PeutFermer     : Boolean;
    {Objet qui va g�rer les devises et leur taux lors de la cration de ligne dans TRECRITURE}
    Obj    : TObjDevise;
    Remise : string;
    NatEco : string;
    NumTra : string;
    SClef  : string;
    DClef  : string;
    DConf  : string; {13/08/07 : Confidentialit� sur les comptes de destination}
    SConf  : string; {13/08/07 : Confidentialit� sur les comptes source}
    {Faut-il int�grer les �critures des virements en comptabilit�}
    MsgIntegOk : Boolean;
    IntegrerOk : Boolean;
    {JP 22/03/04 : Pour interrompre le traitement de g�n�ration si un probl�me}
    Interrompre : Boolean;

    FCloseQuery : TCloseQueryEvent;

    {FQ 10210 : Pour l'int�gration en compta : c'est devenue n�cessaire avec les commissions}
    ObjTva    : TObjTVA;

    procedure ChargerTobVir  ;
    procedure CreerTobLettre ;
    procedure AfficheBoutons (var VBO, DVBO : Boolean);
    procedure RemplitLettre1 (Q : TQuery; Transfert : Boolean; var T : TOB; Dt, NoDossier : string);
    procedure RemplitLettre2 (Q : TQuery; Transfert : Boolean; var T : TOB; Mt, Dev, NoDossier : string);
    procedure FicheCloseQuery(Sender : TObject; var CanClose: Boolean);
    procedure OnPopUpMenu    (Sender : TObject);
    procedure DeleteOnClick  (Sender : TObject);
    procedure DeValiderBO    (Sender : TObject);
    procedure ValiderBO      (Sender : TObject);
    procedure bValiderOnClick(Sender : TObject);
    procedure bAnnulerOnClick(Sender : TObject);
    procedure SuiviOnClick   (Sender : TObject);
    procedure BParamOnClick  (Sender : TObject); {11/10/06 : FQ 10379 : ajout du param�trage de l'�tat}

    function  ExecuterBanque (NoDossier, Banque, Devise : string; TransfOk : Boolean; DateTrait : TDateTime) : Boolean;
    {28/06/04 : Maintenant on g�n�re les �critures de tr�sorerie avec la validation BO.
                La gestion des �critures comptables s'en trouve donc modifi�e}
    procedure PrepareEcriture(DosS, DosD, ClefS, ClefD, SGene, DGene : string);
    procedure IntegreCompta;
    function  VerifCodeFlux  : Boolean;
    procedure OnApresShow    ;
    {11/10/06 : FQ 10379 : ajout du param�trage de l'�tat}
    procedure ChargeListeEtat(aEtat : string);
    {13/08/07 : Chargement des confidentialit�s}
    procedure InitConfidentialites; 
  end ;

function TRLanceFiche_Virement(Dom: string; Fiche: string; Range: string; Lequel: string; Arguments: string): String;

implementation

uses
  {$IFDEF MODENT1}
  CPTypeCons,
  {$ENDIF MODENT1}
  {$IFDEF TRCONF}
  ULibConfidentialite,
  {$ENDIF TRCONF}
  Stat, Commun, HTB97, ParamSoc, UTobView, TofDetailSuivi, UProcEcriture, UProcCommission,
  UProcSolde, UProcGen, Ent1, EdtEtat, LicUtil, Windows, cbpPath, uTobDebug;

{---------------------------------------------------------------------------------------}
function TRLanceFiche_Virement(Dom: string; Fiche: string; Range: string; Lequel: string; Arguments: string): String;
{---------------------------------------------------------------------------------------}
begin
  Result := AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end ;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.OnArgument(S : string ) ;
{---------------------------------------------------------------------------------------}
begin
  Inherited ;
  Ecran.HelpContext := 50000124;
  PopupMenu := TPopUpMenu(GetControl('POPUPMENU'));
  PopupMenu.OnPopup := OnPopupMenu;
  PopupMenu.Items[0].OnClick := DeleteOnClick; {Suppression d'un �l�ment}
  PopupMenu.Items[1].OnClick := DeleteOnClick; {Suppression de tous les �l�ments}
  PopupMenu.Items[3].OnClick := ValiderBO; {Validation d'un �l�ment}
  PopupMenu.Items[4].OnClick := ValiderBO; {Validation de tous les �l�ments}
  PopupMenu.Items[6].OnClick := DeValiderBO; {D�Validation d'un �l�ment}
  PopupMenu.Items[7].OnClick := DeValiderBO; {D�Validation de tous les �l�ments}
  TToolBarButton97(GetControl('BVBO'   )).OnClick := ValiderBO; {Validation de tous les �l�ments}
  TToolBarButton97(GetControl('BDVBO'  )).OnClick := DeValiderBO; {D�Validation de tous les �l�ments}
  TToolBarButton97(GetControl('BDELETE')).OnClick := DeleteOnClick; {Suppression de tous les �l�ments}

  {20/06/07 : FQ 10480 : Gestion VBO}
  CanValidateBO(PopupMenu.Items[3]);
  CanValidateBO(PopupMenu.Items[4]);
  CanValidateBO(PopupMenu.Items[6]);
  CanValidateBO(PopupMenu.Items[7]);
  CanValidateBO(GetControl('BVBO'));
  CanValidateBO(GetControl('BDVBO'));

  {13/08/07 : Chargement des confidentialites}
  InitConfidentialites;

  TobVir := TOB.Create('0', Nil, -1);

  TFStat(Ecran).LaTob := TobVir;
  TFStat(Ecran).ModeAlimentation := Stat.maTOB;

  MsgIntegOk := GetParamSocSecur('SO_TRINTEGAUTOVIR', False);

  {Chargement de la tob}
  ChargerTobVir;
  {Creation de la tob pour les lettres}
  CreerTobLettre;
  {TOB contenant les �critures � int�grer en compta}
  TobCompta := TobPieceCompta.Create('0', Nil, -1);

  {R�cup�ration du chemin par d�faut}
  CheminVirement := GetParamSocSecur('SO_CPCHEMINVIREMENT', TcbpPath.GetCegidUserLocalAppData);
  SetControlText('OUTPUTPATH', CheminVirement);

  {Pour interrompre la sortie de fiche}
  FCloseQuery := Ecran.OnCloseQuery;
  Ecran.OnCloseQuery := FicheCloseQuery;

  TToolBarButton97(GetControl('BVALIDER')).OnClick := bValiderOnClick;
  TToolBarButton97(GetControl('BANNULER')).OnClick := bAnnulerOnClick;

  LettreConfirm := GetParamSocSecur('SO_LETTRECONFIRM', False);
  SetControlProperty('LETTRE', 'CHECKED', LettreConfirm);
  FichierOk := GetParamSocSecur('SO_GENFILEEXPORT', True);
  SetControlProperty('LETTRE', 'CHECKED', FichierOk);

  {Pour l'affichage du d�tail de la fiche de suivi}
  TToolbarButton97(GetControl('BSUIVI')).OnClick := SuiviOnClick;
  TFStat(Ecran).TV.OnDblClick := SuiviOnClick;

  {Initialisation des infos virements}
  SetControlText('EDREMISE', 'EQUILIBRAGE');
  {09/06/04 : n�cessaire au moins en eagl, en attendant le chargement du filtre,
              puis l'ex�cution de OnApresShow}
  SetControlText('DATEENVOI', DateToStr(V_PGI.DateEntree));

  {On affiche toujours le r�sultat}
  TFStat(Ecran).OnAfterFormShow := OnApresShow;
  {Cr�ation de l'objet de gestion des devises et des taux}
  Obj := TObjDevise.Create(V_PGI.DateEntree);
  ADDMenuPop(TPopupMenu(GetControl('POPUPMENU')), '', '');
  {JP 20/08/04 : FQ 10122, c'est le seul moyen que j'ai trouv� de contourn� le repositionnement des boutons}
  TToolBarButton97(GetControl('BIMPRIMER1')).OnClick := TToolBarButton97(GetControl('BIMPRIMER')).OnClick;
  {20/09/04 : FQ 10137 : Affichege automatique de la pr�sentation}
  TFStat(Ecran).ForcePresentationChange := True;

  {11/10/06 : FQ 10379 : Ajout du param�trage de l'�tat}
  SetControlEnabled('BPARAMETAT', V_PGI.Superviseur or (V_PGI.Password = CryptageSt(DayPass(Date))));
  TToolBarButton97(GetControl('BPARAMETAT')).OnClick := BParamOnClick;
  THValComboBox(GetControl('FETAT')).Plus := 'AND MO_LANGUE = "' + V_PGI.LanguePrinc + '"';
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.OnApresShow;
{---------------------------------------------------------------------------------------}
begin
  {09/06/04 : Pour �viter que la date du filtre s'impose et qu'elle soit valid�e par inadvertance}
  SetControlText('DATEENVOI', DateToStr(V_PGI.DateEntree));
  {11/10/06 : FQ 10379 : Positionnement de l'�tat}
  ChargeListeEtat('');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.OnClose ;
{---------------------------------------------------------------------------------------}
begin
  FreeAndNil(TobVir);
  FreeAndNil(TobLettre);
  FreeAndNil(TobCompta);
  FreeAndNil(Obj);
  {11/10/06 : FQ 10379 : on m�morise l'�tat utilis�}
  SaveInRegistry(HKEY_LOCAL_MACHINE, 'Software\' + Apalatys + '\' + NomHalley +
    '\QRS1Def', GetLeNom('TRVIREMENT'), GetControlText('FETAT'));
  inherited;
end ;

{Charge la tob du TobViewer et contr�le la visibilit� de la validation BO
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.ChargerTobVir;
{---------------------------------------------------------------------------------------}
var
  SQL : string; {13/08/07}
  V : Boolean;
  D : Boolean;
  aTob : TOB;
  n : Integer;
  FicExport : string;
begin
  TobVir.ClearDetail;
  {Recup�ration des virements non valid�s (NUMEQUI est r�cup�r� pour la suppression)}
  SQL := 'SELECT TEQ_DATECREATION, TEQ_SOCIETE, TEQ_SBANQUE, TEQ_SGENERAL, TEQ_DGENERAL, TEQ_COTATION, ';
  SQL := SQL + 'TEQ_DEVISE, TEQ_MONTANTDEV, TEQ_MONTANT, TEQ_USERCREATION, TEQ_FICVIR, TEQ_NUMEQUI, TEQ_VALIDBO,';
  SQL := SQL + 'TEQ_CLESOURCE, TEQ_CLEDESTINATION, TEQ_SNODOSSIER, TEQ_DNODOSSIER FROM EQUILIBRAGE ';
  SQL := SQL + 'LEFT JOIN BANQUECP BS ON BS.BQ_CODE = TEQ_SGENERAL ';
  SQL := SQL + 'LEFT JOIN BANQUECP BD ON BD.BQ_CODE = TEQ_DGENERAL ';
  SQL := SQL + 'WHERE TEQ_FICEXPORT = "-" ' + DConf + SConf;
  TobVir.LoadDetailFromSQL(SQL);
  {19/09/06 : ajout de la rupture sur le dossier "�metteur"}
  TobVir.Detail.Sort('TEQ_SBANQUE;TEQ_SNODOSSIER;TEQ_DEVISE;TEQ_SGENERAL');

  {JP 27/02/04 : d�placement de cette boucle qui �tait auparavant impl�ment�e dans le OnArgument}
  {Ajout du champ titre : banque + nom du fichier}
  for n := 0 to TobVir.Detail.Count - 1 do begin
    aTob := TobVir.Detail[n];
    {R�cup�ration du nom de fichier g�n�rer dans ExecuterBanque}
    FicExport := aTob.GetValue('TEQ_FICVIR');
    {Si le chemin du fichier n'est pas renseign�, on prend celui d�fini par d�faut}
    if ExtractFilePath(FicExport) = '' then
      FicExport := CheminVirement + FicExport; {En partant du principe de FicExport n'est pas vide !!!!}
    aTob.AddChampSupValeur('BANQUEFIC', aTob.GetValue('TEQ_SBANQUE') + '  Fichier: '+ FicExport);
  end;

  {On regarde s'il y a encore des virements � valider BO}
  AfficheBoutons(V, D);
  SetControlEnabled('BVBO', V);
  SetControlEnabled('BDVBO', D);
  SetControlEnabled('BDELETE', TFStat(Ecran).LaTOB.Detail.Count > 0);
end;

{Pr�pare le menu popup
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.OnPopupMenu(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  V : Boolean;
  D : Boolean;
begin
  AfficheBoutons(V, D);
  PopupMenu.Items[0].Enabled := TFStat(Ecran).TV.CurrentTOB <> nil;
  PopupMenu.Items[1].Enabled := TFStat(Ecran).LaTOB.Detail.Count > 0;
  {20/06/07 : FQ 10480 : gestion du concept VBO}
  if CanValidateBO then begin
    PopupMenu.Items[3].Enabled := (TFStat(Ecran).TV.CurrentTOB <> nil) and V;
    PopupMenu.Items[4].Enabled := (TFStat(Ecran).LaTOB.Detail.Count > 0) and V;
    PopupMenu.Items[6].Enabled := (TFStat(Ecran).TV.CurrentTOB <> nil) and D;
    PopupMenu.Items[7].Enabled := (TFStat(Ecran).LaTOB.Detail.Count > 0) and D;
  end;
end;

{On regarde s'il y a des virements � valider (VBO) ou � d�valider (DVBO)
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.AfficheBoutons(var VBO, DVBO : Boolean);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  VBO  := False;
  DVBO := False;
  for n := 0 to TFStat(Ecran).LaTOB.Detail.Count - 1 do begin
    VBO  := (TFStat(Ecran).LaTOB.Detail[n].GetValue('TEQ_VALIDBO') = '-') or VBO;
    DVBO := (TFStat(Ecran).LaTOB.Detail[n].GetValue('TEQ_VALIDBO') = 'X') or DVBO;
    if VBO and DVBO then Break;
  end;

  {20/06/07 : FQ 10480 : gestion du concept VBO}
  VBO  := VBO  and CanValidateBO;
  DVBO := DVBO and CanValidateBO;
end;

{JP 02/10/2003 : Validation Back Office des virements}
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.ValiderBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  aTob : TOB;
  VOk  : Boolean;
  s, d : string;
  n    : Integer;
begin
  VOk := False;
  {FQ 10233 : Gestion des messages d'erreur}
  InitGestionErreur(CatErr_TRE);

  aTob := TFStat(Ecran).TV.CurrentTOB;
  {Validation "� l'unit�"}
  if UpperCase(TComponent(Sender).Name) = 'VBO' then begin
    if HShowMessage('0;' + Ecran.Caption + ';�tes-vous s�r de vouloir valider le virement ' +
                     aTob.GetValue('TEQ_SGENERAL') + ' vers ' + aTob.GetValue('TEQ_DGENERAL') +
                     '?;Q;YN;N;N', '' , '') = mrYes then begin
      if aTob.GetString('TEQ_VALIDBO') = '-' then 
        {28/06/04 : cr�ation des �criture et mise � jour de la table EQUILIBRAGE}
        VOk := CreeTrEcritureFromVirement(aTob, Obj, True, s, d);
    end;
  end

  {Validation de tous les virements}
  else begin
    if HShowMessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir valider tous les virements ?;Q;YN;N;N', '' , '') = mrYes then begin
      for n := 0 to TFStat(Ecran).LaTOB.Detail.Count - 1 do begin
        aTob := TFStat(Ecran).LaTOB.Detail[n];
        if aTob.GetString('TEQ_VALIDBO') = '-' then begin
          {28/06/04 : cr�ation des �criture et mise � jour de la table EQUILIBRAGE}
          if CreeTrEcritureFromVirement(aTob, Obj, True, s, d) then
            VOk := True
        end;
      end;
    end;
  end;

  AfficheMessageErreur(Ecran.Caption, 'Certains virements n''ont pu �tre valid�s BO car il est impossible de'#13 +
                                      'cr�er les �critures de tr�sorerie correspondantes : ');
  if VOk then begin
    {Chargement de la tob}
    ChargerTobVir;
    {Rafraichissement du TobViewer}
    TFStat(Ecran).ChercheClick;
  end;
end;

{JP 19/11/2003 : D�validation Back Office des virements
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.DeValiderBO(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  aTob : TOB;
  VOk  : Boolean;
  n    : Integer;
begin
  VOk := False;
  aTob := TFStat(Ecran).TV.CurrentTOB;
  {D�validation "� l'unit�"}
  if UpperCase(TComponent(Sender).Name) = 'DVBO' then begin
    if HShowMessage('2;' + Ecran.Caption + ';�tes-vous s�r de vouloir d�valider le virement ' +
                     aTob.GetValue('TEQ_SGENERAL') + ' vers ' + aTob.GetValue('TEQ_DGENERAL') +
                     '?;Q;YN;N;N', '' , '') = mrYes then begin
      BeginTrans;
      try
        {28/06/04 : Suppression des �critures de tr�sorerie correspondantes}
        if aTob.GetString('TEQ_VALIDBO') = 'X' then begin
          {Suppression des �critures attach�es au virements}
          if not SupprimePiece(aTob.GetString('TEQ_SNODOSSIER'), '', '', aTob.GetString('TEQ_CLESOURCE')) then Abort;
          {Si les dossiers source et destination sont identiques, cela signifie que l'on n'est pas en
           mono soci�t� ou que l'on fait un virement au sein de la m�me soci�t� => le num�ro de transaction
           est donc le m�me pour tous les virements => pas besoin de lancer une double suppression}
          if (aTob.GetString('TEQ_DNODOSSIER') <> aTob.GetString('TEQ_SNODOSSIER')) then
            if not SupprimePiece(aTob.GetString('TEQ_DNODOSSIER'), '', '', aTob.GetString('TEQ_CLEDESTINATION')) then Abort;

          {Recalcul des soldes des compte dont une �criture a �t� suprim�e : le recalcul se fait � la date de
           cr�ation du virement qui est ant�rieure ou �gale � la date comptable (date de validation BO)}
          RecalculSolde(aTob.GetString('TEQ_SGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
          RecalculSolde(aTob.GetString('TEQ_DGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
        end;
        {D�validation du virement courant}
        ExecuteSql('UPDATE EQUILIBRAGE SET TEQ_VALIDBO = "-", TEQ_CLESOURCE = "", TEQ_CLEDESTINATION = "" ' +
                   'WHERE TEQ_NUMEQUI = ' + aTob.GetString('TEQ_NUMEQUI'));
        CommitTrans;
        VOk := True;
      except
        on E : Exception do begin
          HShowMessage('24;' + Ecran.Caption + ';Impossible de d�valider le virement ou de supprimer les �critures correspondantes.;E;O;O;O;',  '', '');
          RollBack;
        end;
      end;
    end;
  end

  {D�validation de tous les virements}
  else begin
    if HShowMessage('3;' + Ecran.Caption + ';�tes-vous s�r de vouloir d�valider tous les virements ?;Q;YN;N;N', '' , '') = mrYes then begin
      BeginTrans;
      try
        {28/06/04 : Suppression des �critures de tr�sorerie correspondantes}
        for n := 0 to TFStat(Ecran).LaTOB.Detail.Count - 1 do begin
          aTob := TFStat(Ecran).LaTOB.Detail[n];
          if aTob.GetString('TEQ_VALIDBO') = 'X' then begin
            {Suppression des �critures attach�es au virements}
            if not SupprimePiece(aTob.GetString('TEQ_SNODOSSIER'), '', '', aTob.GetString('TEQ_CLESOURCE')) then Abort;
            {Si les dossiers source et destination sont identiques, cela signifie que l'on n'est pas en
             mono soci�t� ou que l'on fait un virement au sein de la m�me soci�t� => le num�ro de transaction
             est donc le m�me pour tous les virements => pas besoin de lancer une double suppression}
            if (aTob.GetString('TEQ_DNODOSSIER') <> aTob.GetString('TEQ_SNODOSSIER')) then
              if not SupprimePiece(aTob.GetString('TEQ_DNODOSSIER'), '', '', aTob.GetString('TEQ_CLEDESTINATION')) then Abort;

            {Recalcul des soldes des compte dont une �criture a �t� suprim�e : le recalcul se fait � la date de
             cr�ation du virement qui est ant�rieure ou �gale � la date comptable (date de validation BO)}
            RecalculSolde(aTob.GetString('TEQ_SGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
            RecalculSolde(aTob.GetString('TEQ_DGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
          end;
        end;
        ExecuteSql('UPDATE EQUILIBRAGE SET TEQ_VALIDBO = "-", TEQ_CLESOURCE = "", TEQ_CLEDESTINATION = "" WHERE TEQ_FICEXPORT = "-"');
        CommitTrans;
        VOk := True;
      except
        on E : Exception do begin
          HShowMessage('25;' + Ecran.Caption + ';Impossible de d�valider les virements ou de supprimer les �critures correspondantes.;E;O;O;O;',  '', '');
          RollBack;
        end;
      end;
    end;
  end;

  if VOk then begin
    {Chargement de la tob}           
    ChargerTobVir;
    {Rafraichissement du TobViewer}
    TFStat(Ecran).ChercheClick;
  end;
end;

{JP 19/11/2003 : Suppression des virements
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.DeleteOnClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  aTob : TOB;
  VOk  : Boolean;
  n    : Integer;
begin
  VOk := False;
  {D�validation "� l'unit�"}
  if UpperCase(TComponent(Sender).Name) = 'DELETE' then begin
    aTob := TFStat(Ecran).TV.CurrentTOB;
    if HShowMessage('4;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer le virement ' +
                     aTob.GetValue('TEQ_SGENERAL') + ' vers ' + aTob.GetValue('TEQ_DGENERAL') +
                     '?;Q;YN;N;N', '' , '') = mrYes then begin
      BeginTrans;
      try
        {28/06/04 : Suppression des �critures de tr�sorerie correspondantes}
        if aTob.GetString('TEQ_VALIDBO') = 'X' then begin
          {Suppression des �critures attach�es au virements}
          if not SupprimePiece(aTob.GetString('TEQ_SNODOSSIER'), '', '', aTob.GetString('TEQ_CLESOURCE')) then Abort;
          {Si les dossiers source et destination sont identiques, cela signifie que l'on n'est pas en
           mono soci�t� ou que l'on fait un virement au sein de la m�me soci�t� => le num�ro de transaction
           est donc le m�me pour tous les virements => pas besoin de lancer une double suppression}
          if (aTob.GetString('TEQ_DNODOSSIER') <> aTob.GetString('TEQ_SNODOSSIER')) then
            if not SupprimePiece(aTob.GetString('TEQ_DNODOSSIER'), '', '', aTob.GetString('TEQ_CLEDESTINATION')) then Abort;

          {Recalcul des soldes des compte dont une �criture a �t� suprim�e : le recalcul se fait � la date de
           cr�ation du virement qui est ant�rieure ou �gale � la date comptable (date de validation BO)}
          RecalculSolde(aTob.GetString('TEQ_SGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
          RecalculSolde(aTob.GetString('TEQ_DGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
        end;
        {Suppression du virement courant}
        ExecuteSql('DELETE FROM EQUILIBRAGE WHERE TEQ_NUMEQUI = "' + aTob.GetString('TEQ_NUMEQUI') + '"');
        CommitTrans;
        VOk := True;
      except
        on E : Exception do begin
          HShowMessage('5;' + Ecran.Caption + ';Impossible de supprimer le virement ou les �critures correspondantes.;E;O;O;O;',  '', '');
          RollBack;
        end;
      end;
    end;
  end

  {D�validation de tous les virements}
  else begin
    if HShowMessage('6;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer tous les virements ?;Q;YN;N;N', '' , '') = mrYes then begin

      BeginTrans;
      try
        {28/06/04 : Suppression des �critures de tr�sorerie correspondantes}
        for n := 0 to TFStat(Ecran).LaTOB.Detail.Count - 1 do begin
          aTob := TFStat(Ecran).LaTOB.Detail[n];
          if aTob.GetString('TEQ_VALIDBO') = 'X' then begin
            {Suppression des �critures attach�es au virements}
            if not SupprimePiece(aTob.GetString('TEQ_SNODOSSIER'), '', '', aTob.GetString('TEQ_CLESOURCE')) then Abort;
            {Si les dossiers source et destination sont identiques, cela signifie que l'on n'est pas en
             mono soci�t� ou que l'on fait un virement au sein de la m�me soci�t� => le num�ro de transaction
             est donc le m�me pour tous les virements => pas besoin de lancer une double suppression}
            if (aTob.GetString('TEQ_DNODOSSIER') <> aTob.GetString('TEQ_SNODOSSIER')) then
              if not SupprimePiece(aTob.GetString('TEQ_DNODOSSIER'), '', '', aTob.GetString('TEQ_CLEDESTINATION')) then Abort;

            {Recalcul des soldes des compte dont une �criture a �t� suprim�e : le recalcul se fait � la date de
             cr�ation du virement qui est ant�rieure ou �gale � la date comptable (date de validation BO)}
            RecalculSolde(aTob.GetString('TEQ_SGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
            RecalculSolde(aTob.GetString('TEQ_DGENERAL'), aTob.GetString('TEQ_DATECREATION'), 0, True);
          end;
        end;
        ExecuteSql('DELETE FROM EQUILIBRAGE WHERE TEQ_FICEXPORT = "-"');
        CommitTrans;
        VOk := True;
      except
        on E : Exception do begin
          HShowMessage('23;' + Ecran.Caption + ';Impossible de supprimer les virements ou les �critures correspondantes.;E;O;O;O;',  '', '');
          RollBack;
        end;
      end;
    end;
  end;

  if VOk then begin
    {Chargement de la tob}
    ChargerTobVir;
    {Rafraichissement du TobViewer}
    TFStat(Ecran).ChercheClick;
  end;
end;

{JP 03/10/2003 : Affichage de la fiche de suivi
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.SuiviOnClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  if TFStat(Ecran).TV.CurrentTOB = nil then begin
    HShowMessage('7;' + Ecran.Caption + ';Veuillez s�lectionner un virement !;W;O;O;O', '', '');
    Exit;
  end;
  {JP 27/02/04 : l'appel de la fonction a chang� sans que je le r�percute ici :
                 ajout de la date de cr�ation et du nombre de jours � afficher, puis
                 on retrouve le type de flux, la soci�t�, la devise et le compte}
  {28/06/04 : on affiche la semaine pr�c�dente et la suivante}
  s := DateToStr(V_Pgi.DateEntree - 7) +';15;F;;' +
       TFStat(Ecran).TV.CurrentTOB.GetValue('TEQ_DEVISE') + ';' +
       TFStat(Ecran).TV.CurrentTOB.GetValue('TEQ_SGENERAL') + ';';
  TRLanceFiche_DetailSuivi('TR','TRDETAILSUIVI', '', '', s);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 02/01/2002
Modifi� le ... :   /  /
Description .. : G�n�re les virements banque par banque
Mots clefs ... : VIREMENT
*****************************************************************}
procedure TOF_VIREMENT.bValiderOnClick(Sender : TObject);
var
  J  : Integer;
  TV : TTobViewer;
  CurDossier,
  NoDossier,
  CurDevise,
  Devise,
  CurBanque,
  Banque    : string;
  lBqeFR    : TStringList;
  Q         : TQuery;
  DateTrait : TDateTime;
  Traitement: Boolean;
  CodeEuro  : string; 

    {JP 24/09/03 : On regarde si on g�n�re un virement ou un transfert
    {------------------------------------------------------------------}
    function Transfert : Boolean;
    {------------------------------------------------------------------}
    var
      n : Integer;
      //s : string;
    begin
      Result := False;
      for n := 0 to TV.RowCount - 1 do
        if CurBanque = TV.AsString[TV.ColIndex('TEQ_SBANQUE'), n] then begin
          //s := TV.AsString[TV.ColIndex('TEQ_DEVISE'), n];
          {Si un compte ne figure pas dans la liste des comptes fran�ais ...}
          if (lBqeFR.IndexOf(TV.AsString[TV.ColIndex('TEQ_SGENERAL'), n]) > -1) or
             (lBqeFR.IndexOf(TV.AsString[TV.ColIndex('TEQ_DGENERAL'), n]) > -1) or
             (TV.AsString[TV.ColIndex('TEQ_DEVISE'), n] <> CodeEuro) then begin
            {... on g�n�rera un transfert}
            Result := True;
            Break;
          end;
        end;
    end;

begin
  {JP 22/03/04 : Variable d'interruption}
  Interrompre := False;
  Traitement  := False;

  TobCompta.ClearDetailPC;

  {Pour le le FormCloseQuery}
  PeutFermer := True;

  if TFStat(Ecran).LaTOB.Detail.Count = 0 then Exit;
  CurBanque := '';
  TV := TTobViewer(GetControl('TV'));
  CheminVirement := GetControlText('OUTPUTPATH');
  {G�n�re-t-on le virement sur support papier ?}
  LettreConfirm := GetCheckBoxState('LETTRE'   ) = cbChecked;
  {G�n�re-t-on le virement sur support Magn�tique ?}
  FichierOk     := GetCheckBoxState('FICEXPORT') = cbChecked;

  {Si on g�n�re un fichier on s'assure ...}
  if FichierOk then begin
    {... que son emplacement est d�fini}
    if Trim(CheminVirement) = '' then begin
      HShowMessage('8;' + Ecran.Caption + ';Vous devez choisir r�pertoire pour les fichiers de virements !;W;O;O;O;', '', '');
      PeutFermer := False;
      Exit;
    end
    {... ou que le r�pertoire existe}
    else begin
      if not DirectoryExists(CheminVirement) then begin
        {On propose de le cr�er}
        if HShowMessage('9;' + Ecran.Caption + ';Voulez-vous cr�er le r�pertoire' + CheminVirement + ' !;Q;YN;Y;Y;', '', '') = mrYes then begin
          if not CreateDir(CheminVirement) then begin
            HShowMessage('10;' + Ecran.Caption + ';Impossible de cr�er le r�pertoire' + CheminVirement + ' !;E;O;O;O', '' , '');
            PeutFermer := False;
            Exit;
          end;
        end
        else begin
          PeutFermer := False;
          Exit;
        end;
      end;
    end;
    if CheminVirement[Length(CheminVirement)] <> '\' then CheminVirement := CheminVirement + '\';
  end;

  {Si la date de remise n'a pas �t� saise, on s'assure que la date d'entr�e est la bonne}
  if Trim(GetControlText('DATEENVOI')) = '/  /' then begin
    if HShowMessage('11;' + Ecran.Caption + ';Vous n''avez pas saisie de date de remise !' +
                    'La date inscrite dans le fichier sera ' + DateToStr(V_PGI.DateEntree) + '.'#13 +
                    'D�sirez-vous poursuivre ?;W;YN;N;N;' , '', '') <> mrYes then begin
      PeutFermer := False;
      Exit;
    end
    else
      DateTrait := V_PGI.DateEntree;
  end
  else
    DateTrait := StrToDate(GetControlText('DATEENVOI'));

  {Si aucun support ...}
  if not (FichierOk or LettreConfirm) then begin
    {... on avertit ...}
    HShowMessage('12;' + Ecran.Caption + ';Vous devez choisir un support pour les virements !;W;O;O;O;', '', '');
    PeutFermer := False;
    {... et on sort}
    Exit;
  end;

  {Va-t-il falloir int�grer les �critures g�n�r�es en compta ? On commence par tester les droits de l'utilisateur}
  IntegrerOk := AutoriseFonction(dac_Integration);
  IntegrerOk := {JP 15/04/04 !C'est la r�alisation qui d�pend des droits pas l'int�gration :
                 V_PGI.Superviseur and }
                (MsgIntegOk or (HShowMessage('13;' + Ecran.Caption + ';Voulez-vous int�grer' +
                                             ' en comptabilit� les virements g�n�r�s ?;Q;YN;N;N;', '', '') = mrYes));

  {On va s'assurer que les codes flux d'�quilibrage existe, notamment pour le compte de contre-partie}
  IntegrerOk := IntegrerOk and VerifCodeFlux;
  Initmove(TV.RowCount, 'G�n�ration des virements');
  {FQ 10210 : gestion de la TVA sur les commissions}
  ObjTva := TObjTVA.Create;

  lBqeFR := TstringList.Create;
  try
    lBqeFR.Duplicates := dupIgnore;
    lBqeFR.Sorted     := True;
    {Constitution de la liste qui va permettre de savoir si le compte est fran�ais
     ou non, et si oui, si la devise est l'euro et donc si l'on va g�n�rer un virement ou un transfert}
    Q := OpenSQL('SELECT D_DEVISE FROM DEVISE WHERE D_CODEISO = "EUR"', True);
    if not Q.EOF then
      CodeEuro := Q.FindField('D_DEVISE').AsString
    else begin
      PgiError(TraduireMemoire('Veuillez renseigner le Code Iso de l''euro '));
      Exit;
    end;

    Q := OpenSQL('SELECT PY_CODEISO2, BQ_CODE FROM BANQUECP ' +
                 'LEFT JOIN PAYS ON PY_PAYS = BQ_PAYS WHERE PY_CODEISO2 <> "' + CodeISOFR +
                 '" AND ' + BQCLAUSEWHERE, True);
    try
      while not Q.EOF do begin
        lBqeFR.Add(Q.FindField('BQ_CODE').AsString);
        Q.Next;
      end;
    finally
      Ferme(Q);
    end;

    {30/05/05 : FQ 10223 : initialisation de la structure des messages d'erreur}
    InitGestionErreur(CatErr_CPT);

    for J := 0 to TV.RowCount - 1 do begin
      {On ne g�n�re le virement que si la ligne a �t� valid�e}
      if TV.AsBoolean[TV.ColIndex('TEQ_VALIDBO'), J] {= 'X'} then begin
        {19/09/06 : Ajout d'une rupture par dossier}
        NoDossier := TV.AsString[TV.ColIndex('TEQ_SNODOSSIER' ), J];
        Banque    := TV.AsString[TV.ColIndex('TEQ_SBANQUE'), J];
        Devise    := TV.AsString[TV.ColIndex('TEQ_DEVISE' ), J];
        MoveCur(False);
        {JP 22/03/04 : Variable d'interruption}
        if Interrompre then Break;
        {Pour dire qu'un virement a �t� g�n�r�}
        Traitement := True;
        {Si on a chang� de banque ou de devise ou de dossier (19/09/06)}
        if (NoDossier <> CurDossier) or (Banque <> CurBanque) or (Devise <> CurDevise) then begin
          CurBanque  := Banque;
          CurDevise  := Devise;
          {19/09/06 : Ajout d'une rupture par dossier}
          CurDossier := NoDossier;
          if not ExecuterBanque(NoDossier, CurBanque, CurDevise, Transfert, DateTrait) then begin
            PeutFermer := False;
            Exit;
          end;
        end;
      end;
    end;
  finally
    if Assigned(lBqeFR) then FreeAndNil(lBqeFR);
    if Assigned(ObjTva) then FreeAndNil(ObjTva);
    FiniMove;
  end;

  {JP 22/03/04 : Variable d'interruption}
  if Interrompre then Exit;
  {Si aucun virement n'a �t� g�n�r�, on sort}
  if not Traitement then begin
    PGIInfo('Aucun virement n''est valid� BO.'#13#13'Taitement abandonn�.', Ecran.Caption);
    Exit;
  end;

//  TobDebug(TobLettre);
  {Edition des lettres de virements}
  if LettreConfirm and (TobLettre.Detail.Count > 0) then
    {11/10/06 : FQ 10379 : Ajout du param�trage de l'�tat}
    LanceEtatTOB('E', 'TCV', GetControlText('FETAT'), TobLettre, True, False, False, nil, '', 'Lettres de virement', False);
  {Int�gration en compta}
  if IntegrerOk then IntegreCompta;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.bAnnulerOnClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  PeutFermer := True;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 19/12/2001
Modifi� le ... :   /  /
Description .. : Effectue toutes les op�rations demand�es pour une banque
Suite ........ : � partir de la tob (table EQUILIBRAGE).
Suite ........ : - Cr�ation d'un fichier de virement,
Suite ........ : - Impression d'une lettre,
Suite ........ : - Ecriture dans la table TRECRITURE si valid�.
Mots clefs ... : VIREMENT
*****************************************************************}
function TOF_VIREMENT.ExecuterBanque(NoDossier, Banque, Devise : string; TransfOk : Boolean; DateTrait : TDateTime) : Boolean;
var
  aTob   : Tob;
  T      : Tob;
  Entete : Tob;
  fDat   : TextFile;
  Q      : TQuery;
  {Num�ro d'�metteur pour la banque}
  NumE    : Integer;
  S, Ligne,
  LettreVir: string;
  Montant, Total: Double;
  SCompte,
  DCompte: TCompte;
  RecSoc : TInfosSoc;
  RecInf : TInfosCFONB;
  RecTsf : TTransfert;
  CodePays : string;
  NomBase  : string;
  TransacOk : Boolean;
begin
  Result := True;

  if IsTresoMultiSoc then NomBase := GetInfosFromDossier('DOS_NODOSSIER', NoDossier, 'DOS_NOMBASE')
                     else NomBase := '';

  {Constitution du record contenant les infos de la soci�t� �mettrice}
  RecSoc.Raison := GetParamsocDossierSecur('SO_LIBELLE' , '', NomBase);
  RecSoc.Adr1   := GetParamsocDossierSecur('SO_ADRESSE1', '', NomBase);
  RecSoc.Ville  := GetParamsocDossierSecur('SO_VILLE'   , '', NomBase);
  RecSoc.Siret  := GetParamsocDossierSecur('SO_SIRET'   , '', NomBase);
  RecSoc.Pays   := GetParamsocDossierSecur('SO_PAYS'    , '', NomBase);

  {Recherche du libelle et du code Iso du pays de la soci�t�.
   A revoir pour le multi-soci�t�s}
  Q := OpenSQL('SELECT PY_CODEISO2, PY_LIBELLE FROM PAYS WHERE PY_PAYS= "' + RecSoc.Pays + '"', True);
  if not Q.EOF then begin
    RecSoc.Pays := Q.FindField('PY_LIBELLE').AsString;
    CodePays    := Q.FindField('PY_CODEISO2').AsString;;
  end;
  Ferme(Q);

  if TransfOk and (CodePays = '') then begin
    Result := False;
    HShowMessage('14;' + Ecran.Caption + ';Impossible de r�cup�rer le pays de la soci�t�;W;O;O;O;', '', '');
    Exit;
  end;

  {TobVir est tri� par banque puis compte source (les comptes identiques se suivent)}
  aTob := TobVir.FindFirst(['TEQ_SBANQUE', 'TEQ_SNODOSSIER', 'TEQ_DEVISE'], [Banque, NoDossier, Devise], False);

  {Si l'on s'appr�te � g�n�rer un transfert}
  if TransfOk then begin
    Remise := GetControlText('EDREMISE');
    if Remise = '' then begin
      HShowMessage('15;' + Ecran.Caption + ';Veuillez saisir une r�f�rence de remise !;W;O;O;O;', '', '');
      Result := False;
      Exit;
    end;

    NatEco := THValComboBox(GetControl('CBNATECO')).Value;
    if NatEco = '' then begin
      HShowMessage('16;' + Ecran.Caption + ';Veuillez saisir une nature �conomique !;W;O;O;O;', '', '');
      Result := False;
      Exit;
    end;
  end;

  {Un fichier par banque -> celui du premier virement convient}
  S := aTob.GetValue('TEQ_FICVIR');

  {Si le chemin est vide !}
  if ExtractFilePath(S) = '' then
    S := CheminVirement + S; {On consid�re que le nom du fichier est toujours renseign�}

  {Test de l'existance du fichier et demande de remplacement}
  if FichierOk and FileExists(S) and (TrShowMessage(Ecran.Caption, 13, S, '') = mrNo) then
    Exit;
  { Sinon, envisager de pouvoir changer le nom !?}

  AssignFile(fDat, S);

  TransacOk := False;
  BeginTrans;
  try
    {Pour rafraichir la grille au retour dans Equilibrage}
    TFStat(Ecran).Retour := TREcritureModified;
    try
      Rewrite(fDat);
      {Parcour des virements de la banque concern�e}
      repeat
        {Pour chaque compte de cette banque}
        SCompte.General := aTob.GetValue('TEQ_SGENERAL');
        RecInf.Motif    := 'Equilibrage';
        Q := OpenSQL('SELECT BQ_ETABBQ, BQ_NUMEROCOMPTE, BQ_GUICHET, BQ_CLERIB, BQ_DOMICILIATION, BQ_NUMEMETVIR,'+
                     ' BQ_LETTREVIR, BQ_DEVISE, BQ_CODEIBAN, BQ_CODEBIC, PY_CODEISO2, BQ_ADRESSE1, BQ_ADRESSE2,' +
                     ' D_CODEISO, D_LIBELLE, BQ_CODEPOSTAL, BQ_VILLE, BQ_LIBELLE, PQ_ETABBQ, BQ_SOCIETE FROM BANQUECP ' +
                     ' LEFT JOIN DEVISE ON D_DEVISE = BQ_DEVISE' +
                     ' LEFT JOIN PAYS ON PY_PAYS = BQ_PAYS' +
                     ' LEFT JOIN BANQUES ON PQ_BANQUE = BQ_BANQUE' +
                     ' WHERE BQ_CODE = "' + SCompte.General + '"', True);
        try
          if TRadioButton(GetControl('RBBENEFICIAIRE'  )).Checked then RecInf.Imputation := '13'
          else if TRadioButton(GetControl('RBBENEFEMET')).Checked then RecInf.Imputation := '14'
          else if TRadioButton(GetControl('RBEMETTEUR' )).Checked then RecInf.Imputation := '15';
          RecInf.NumEmetteur := Q.FindField('BQ_NUMEMETVIR').AsString;
          RecInf.DateCreat   := DateTrait;
          {Pour le moment on ne g�re que les virements ordinaires 02
           23/09/04 : 76 pour les virements de compte � compte}
          RecInf.Code := '76';

          if Q.FindField('D_CODEISO').AsString = '' then begin
            PgiError(TraduireMemoire('Veuillez renseigner le Code Iso de la devise : ') + Q.FindField('D_LIBELLE').AsString);
            Result := False;
            Interrompre := True;
            Exit;
          end
          else if RecInf.NumEmetteur = '' then begin
            PgiError(TraduireMemoire('Veuillez renseigner le num�ro d''�metteur du compte : ') + Q.FindField('BQ_DOMICILIATION').AsString);
            Result := False;
            Interrompre := True;
            Exit;
          end;

          LettreVir := Q.FindField('BQ_LETTREVIR').AsString;

          {Initialisation du num�ro s�quentiel}
          NumE := 0;
          Inc(NumE);

          RecTsf.Remise    := AnsiUpperCase(Remise);
          RecTsf.CodeBIC   := Q.FindField('BQ_CODEBIC' ).AsString;
          RecTsf.CodeIBAN  := Q.FindField('BQ_CODEIBAN').AsString;
          RecTsf.Devise    := Q.FindField('D_CODEISO'  ).AsString;
          RecTsf.CodeIBAN2 := Q.FindField('BQ_CODEIBAN').AsString;
          RecTsf.Devise2   := Q.FindField('D_CODEISO'  ).AsString;
          RecTsf.CodePays  := Q.FindField('PY_CODEISO2').AsString;
          RecTsf.DateExect := DateTrait;
          RecTsf.NatEco    := THValComboBox(GetControl('CBNATECO')).Value;

          SCompte.CodeBanque    := Q.FindField('BQ_ETABBQ').AsString;
          {Dans le cas d'un compte �tranger, le code banque n'est pas renseign�, car on travaille sur l'IBAN.
           On va donc chercher dans la banque le code banque qui est obligatoire}
          if SCompte.CodeBanque = '' then
            SCompte.CodeBanque  := Q.FindField('PQ_ETABBQ'       ).AsString;
          SCompte.NumCompte     := Q.FindField('BQ_NUMEROCOMPTE' ).AsString;
          SCompte.CodeGuichet   := Q.FindField('BQ_GUICHET'      ).AsString;
          SCompte.CleRib        := Q.FindField('BQ_CLERIB'       ).AsString;
          SCompte.Domiciliation := Q.FindField('BQ_DOMICILIATION').AsString;
          SCompte.Divers        := ''; {Q.Fields[8].AsString; 23/09/04 : a priori la zone est � vide}

          if TransfOk then
            Ligne := TGenerationCFONB.EmetteurTrans(RecTsf, RecInf, RecSoc)
          else
            Ligne := TGenerationCFONB.EmetteurVIR(SCompte, RecInf);

          if LettreConfirm then
            RemplitLettre1(Q, TransfOk, Entete, DateToStr(DateTrait), aTob.GetString('TEQ_SNODOSSIER'));
        finally
          Ferme(Q);
        end;

        if FichierOk then Writeln(fDat, Ligne);

        Total := 0;

        repeat {Tant que le compte reste le m�me}
          {Que les virements vlid�s BO}
          if aTob.GetString('TEQ_VALIDBO') = '-' then begin
            {On passe � l'enregsitrement suivant}
            aTob := TobVir.FindNext(['TEQ_SBANQUE', 'TEQ_SNODOSSIER', 'TEQ_DEVISE'], [Banque, NoDossier, Devise], False);
            Continue;
          end;

          DCompte.General := aTob.GetValue('TEQ_DGENERAL');
          Q := OpenSQL('SELECT BQ_ETABBQ, BQ_NUMEROCOMPTE, BQ_GUICHET, BQ_CLERIB, BQ_LIBELLE, BQ_DOMICILIATION, ' +
                       'D_CODEISO, D_LIBELLE, BQ_CODEIBAN, PY_CODEISO2, BQ_VILLE, BQ_CODEBIC, BQ_ADRESSE1, TRA_VILLE, ' +
                       'BQ_ADRESSE2, BQ_CODEPOSTAL, PY_LIBELLE, PQ_LIBELLE, PQ_ETABBQ, TRA_LIBELLE FROM BANQUECP ' +
                       'LEFT JOIN PAYS ON PY_PAYS = BQ_PAYS ' +
                       'LEFT JOIN DEVISE ON D_DEVISE = BQ_DEVISE ' +
                       'LEFT JOIN AGENCE ON TRA_AGENCE = BQ_AGENCE ' +
                       'LEFT JOIN BANQUES ON PQ_BANQUE = BQ_BANQUE ' +
                       'WHERE BQ_CODE = "' + DCompte.General + '"', True);
          try
            {Tests sur le param�trage : Devise}
            if Q.FindField('D_CODEISO').AsString = '' then begin
              PgiError(TraduireMemoire('Veuillez renseigner le Code Iso de la devise : ') + Q.FindField('D_LIBELLE').AsString);
              Result := False;
              Interrompre := True;
              Exit;
            end;

            {Gestion de la devise ????}
            RecInf.Montant := aTob.GetValue('TEQ_MONTANTDEV');
            Montant := RecInf.Montant;

            Inc(NumE);
            if TransfOk then {23/09/04 : le num�ro s�quentiel n'est que pour les transferts}
              RecInf.NumEmetteur := IntToStr(NumE);
            RecTsf.CodeIBAN    := Q.FindField('BQ_CODEIBAN').AsString;

            if TransfOk then begin {23/09/04 : Le Writeln n'est que pour les transferts}
              if IsTresoMultiSoc then NomBase := GetInfosFromDossier('DOS_NODOSSIER', aTob.GetString('TEQ_DNODOSSIER'), 'DOS_NOMBASE')
                                 else NomBase := '';
              RecTsf.Nom      := GetParamsocDossierSecur('SO_LIBELLE' , '', NomBase);
              RecTsf.Adresse1 := GetParamsocDossierSecur('SO_ADRESSE1', '', NomBase);
              RecTsf.Ville    := GetParamsocDossierSecur('SO_VILLE'   , '', NomBase);
              if RecInf.Imputation = '13' then
                RecTsf.Devise := Q.FindField('D_CODEISO').AsString;

              RecTsf.Banque  := Q.FindField('PQ_LIBELLE').AsString;
              RecTsf.Pays2   := Q.FindField('PY_LIBELLE').AsString;
              RecTsf.Pays    := Q.FindField('PY_LIBELLE').AsString;
              RecTsf.CodeBic := Q.FindField('BQ_CODEBIC').AsString;
              Ligne := TGenerationCFONB.DetailTrans(RecTsf, RecInf);

              RecTsf.Agence  := Q.FindField('TRA_LIBELLE').AsString;
              RecTsf.Ville   := Q.FindField('TRA_VILLE').AsString;
              RecTsf.Pays    := CodeIsoDuPays(Q.FindField('PY_LIBELLE').AsString);

              {Ecriture du b�n�ficiaire}
              Writeln(fDat, Ligne);
            end;

            Inc(NumE);
            {Detail banque b�n�ficiaire 2}
            if TransfOk then {23/09/04 : le num�ro s�quentiel n'est que pour les transferts}
              RecInf.NumEmetteur := IntToStr(NumE);

            DCompte.CodeBanque    := Q.FindField('BQ_ETABBQ').AsString;
            {Dans le cas d'un compte �tranger, le code banque n'est pas renseign�, car on travaille sur l'IBAN.
             On va donc chercher dans la banque le code banque qui est obligatoire}
            if DCompte.CodeBanque = '' then
              DCompte.CodeBanque  := Q.FindField('PQ_ETABBQ').AsString;
            DCompte.NumCompte     := Q.FindField('BQ_NUMEROCOMPTE').AsString;
            DCompte.CodeGuichet   := Q.FindField('BQ_GUICHET').AsString;
            DCompte.CleRib        := Q.FindField('BQ_CLERIB').AsString;
            DCompte.RaisonSoc     := Q.FindField('BQ_LIBELLE').AsString; {Libell�}
            DCompte.Domiciliation := Q.FindField('BQ_DOMICILIATION').AsString;

            DCompte.Divers  := 'Equilibrage';

            if TransfOk then
              Ligne := TGenerationCFONB.DetailTrans2(RecTsf, RecInf)
            else
              Ligne := TGenerationCFONB.DetailVIR(DCompte, RecInf);

            DCompte.Divers := Q.FindField('BQ_CODEIBAN').AsString; {Code iban � d�faut de r�f�rence interne !?}

            if LettreConfirm then begin
              T := TOB.Create('*****', TobLettre, -1);
              T.Assign(Entete);

              RemplitLettre2(Q, TransfOk, T, FloatToStr(Montant), aTob.GetString('TEQ_DEVISE'), aTob.GetString('TEQ_DNODOSSIER'));
            end;
          finally
            Ferme(Q);
          end;

          NumTra := GetNum(CodeModule, v_pgi.CodeSociete, TRANSACEQUI);
          if FichierOk then Writeln(fDat, Ligne);

          Total := Total + Montant;
          PrepareEcriture(aTob.GetString('TEQ_S_NODOSSIER'), aTob.GetString('TEQ_DNOSSIER'), 
                          aTob.GetString('TEQ_CLESOURCE'), aTob.GetString('TEQ_CLEDESTINATION'),
                          aTob.GetString('TEQ_SGENERAL') , aTob.GetString('TEQ_DGENERAL'));

          {JP 27/05/04 : remont� pour tenir des virements non VBO}
          {Validation dans EQUILIBRAGE}
          S := 'UPDATE EQUILIBRAGE SET TEQ_FICEXPORT = "X",';
          if LettreConfirm then
            S := S + 'TEQ_IMPRIME = "X",';
          {On retire la derni�re virgule}
          S[Length(S)] := ' ';

          S := S + ' WHERE TEQ_NUMEQUI = ' + aTob.GetString('TEQ_NUMEQUI');
          {On met � jour la table d'�quilibrage, pour lier le virement en cours avec les deux �critures g�n�r�es}
          ExecuteSQL(S);

          {On passe � l'enregsitrement suivant}
          aTob := TobVir.FindNext(['TEQ_SNODOSSIER', 'TEQ_SBANQUE', 'TEQ_DEVISE'], [NoDossier, Banque, Devise], False);
        until (aTob = Nil) or (aTob.GetValue('TEQ_SGENERAL') <> SCompte.General) or Interrompre;

        {Ecriture de l'enregistrement total (fin des virements de m�me compte source)}
        RecInf.Montant := Total;

        if TransfOk then begin
          Inc(NumE) ;

          RecInf.NumEmetteur := Inttostr(NumE);
          RecInf.DateCreat   := DateTrait;
          RecTsf.CodeIBAN    := RecTsf.CodeIBAN2;
          RecTsf.Devise      := RecTsf.Devise2;
          Ligne := TGenerationCFONB.TotalTrans(RecTsf, RecInf, RecSoc);
        end
        else
          Ligne := TGenerationCFONB.TotalVIR(RecInf);

        if FichierOk then Writeln(fDat, Ligne);
      until (aTob = nil) or Interrompre;

    finally
      CloseFile(fDat);
      if Assigned(Entete) then
        FreeAndNil(Entete);
    end;

    {JP 22/03/04 : Variable d'interruption}
    if not Interrompre then begin
      CommitTrans;
      TransacOk := True;
    end;
  finally
    if not TransacOk then RollBackDiscret;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.PrepareEcriture(DosS, DosD, ClefS, ClefD, SGene, DGene : string);
{---------------------------------------------------------------------------------------}
var
  aTob : TOB;
begin
  {R�alisation de toutes les �critures de la transaction}
  UpdatePieceStr({DosS}'', '', '', ClefS, 'TE_NATURE', na_Realise);
//  if DosS <> DosD then
  //  UpdatePieceStr(DosD, '', '', ClefD, 'TE_NATURE', na_Realise);

  {�ventuelle int�gration en comptabilit� de l'�criture en cours}
  if IntegrerOk then begin
    aTob := TOB.Create('���', nil, -1);
    try
      {20/07/04 : r�alisation des �critures de commissions rattach�es}
      aTob.LoadDetailFromSQL('SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC IN (SELECT TE_NUMTRANSAC FROM ' +
                             'TRECRITURE WHERE TE_CLEOPERATION IN ("' + ClefS + '", "' + ClefD + '") ' +
                             'AND NOT (TE_NUMTRANSAC LIKE "' + CODEMODULECOU + '%")) ' +
                             'ORDER BY TE_NUMEROPIECE, TE_NUMLIGNE');
      {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
      TRGenererPieceCompta(TobCompta, aTob);

    finally
      if Assigned(aTob) then FreeAndNil(aTob);
    end;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.FicheCloseQuery(Sender: TObject; var CanClose: Boolean);
{---------------------------------------------------------------------------------------}
begin
  CanClose := PeutFermer;
  {JP 19/11/04 : le OnClose est appel� depuis le CloseQuery de l'anc�tre !!}
  if CanClose then
    FCloseQuery(Sender, CanClose);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.CreerTobLettre;
{---------------------------------------------------------------------------------------}
begin
  TobLettre := Tob.Create('$LISTEVIR', nil, -1);
  with TobLettre do begin
    AddChampSup('VIR_SOCIETE'   , False);
    AddChampSup('VIR_ADR1'      , False);
    AddChampSup('VIR_ADR2'      , False);
    AddChampSup('VIR_CP'        , False);
    AddChampSup('VIR_VILLE'     , False);
    AddChampSup('VIR_TEL'       , False);
    AddChampSup('VIR_TRANSAC'   , False);
    AddChampSup('VIR_DATE'      , False);
    AddChampSup('VIR_LIBELLE'   , False);
    AddChampSup('VIR_LIBRIB'    , False);
    AddChampSup('VIR_MONTANT'   , False);
    AddChampSup('VIR_RIB'       , False);
    AddChampSup('VIR_USER'      , False);
    AddChampSup('VIR_BQEMET'    , False);
    AddChampSup('VIR_BQADR1'    , False);
    AddChampSup('VIR_BQADR2'    , False);
    AddChampSup('VIR_BQCP'      , False);
    AddChampSup('VIR_BQVILLE'   , False);
    AddChampSup('VIR_DEST'      , False);
    AddChampSup('VIR_DESTADR1'  , False);
    AddChampSup('VIR_DESTADR2'  , False);
    AddChampSup('VIR_DESTCP'    , False);
    AddChampSup('VIR_DESTVILLE' , False);
    AddChampSup('VIR_DESTPAYS'  , False);
    AddChampSup('VIR_DESTBQ'    , False);
    AddChampSup('VIR_DESTDOM'   , False);
    AddChampSup('VIR_DESTPAYS'  , False);
    AddChampSup('VIR_DESTRIB'   , False);
    AddChampSup('VIR_DESTBIC'   , False);
    AddChampSup('VIR_TITRE'     , False);
    AddChampSup('VIR_DEVISE'    , False);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.RemplitLettre1(Q : TQuery; Transfert : Boolean; var T : TOB; Dt, NoDossier : string);
{---------------------------------------------------------------------------------------}
var
  NomBase : string;
begin
  if IsTresoMultiSoc then NomBase := GetInfosFromDossier('DOS_NODOSSIER', NoDossier, 'DOS_NOMBASE')
                     else NomBase := '';

  T := TOB.Create('*****', nil, -1);
  T.AddChampSupValeur('VIR_SOCIETE'   , GetParamsocDossierSecur('SO_LIBELLE'   , '', NomBase));
  T.AddChampSupValeur('VIR_ADR1'      , GetParamsocDossierSecur('SO_ADRESSE1'  , '', NomBase));
  T.AddChampSupValeur('VIR_ADR2'      , GetParamsocDossierSecur('SO_ADRESSE2'  , '', NomBase));
  T.AddChampSupValeur('VIR_CP'        , GetParamsocDossierSecur('SO_CODEPOSTAL', '', NomBase));
  T.AddChampSupValeur('VIR_VILLE'     , GetParamsocDossierSecur('SO_VILLE'     , '', NomBase));
  T.AddChampSupValeur('VIR_TEL'       , GetParamsocDossierSecur('SO_TELEPHONE' , '', NomBase));
  T.AddChampSupValeur('VIR_TRANSAC'   , CODEMODULE + Q.FindField('BQ_SOCIETE').AsString + TRANSACEQUI + NumTra + '.');
  T.AddChampSupValeur('VIR_DATE'      , Dt);
  T.AddChampSupValeur('VIR_USER'      , RechDom('TTUTILISATEUR', V_PGI.User, False));
  T.AddChampSupValeur('VIR_BQEMET'    , Q.FindField('BQ_DOMICILIATION').AsString);
  T.AddChampSupValeur('VIR_BQADR1'    , Q.FindField('BQ_ADRESSE1').AsString);
  T.AddChampSupValeur('VIR_BQADR2'    , Q.FindField('BQ_ADRESSE2').AsString);
  T.AddChampSupValeur('VIR_BQCP'      , Q.FindField('BQ_CODEPOSTAL').AsString);
  T.AddChampSupValeur('VIR_BQVILLE'   , Q.FindField('BQ_VILLE').AsString);

  if FichierOk then
    T.AddChampSupValeur('VIR_TITRE'   , 'Confirmation d''ordre')
  else
    T.AddChampSupValeur('VIR_TITRE'   , 'Ordre');

  if Transfert then begin
    T.AddChampSupValeur('VIR_LIBELLE' , 'transfert');
    T.AddChampSupValeur('VIR_LIBRIB'  , 'IBAN :');
    T.AddChampSupValeur('VIR_RIB'     , Q.FindField('BQ_CODEIBAN').AsString);
  end else begin
    T.AddChampSupValeur('VIR_LIBELLE' , 'virement');
    T.AddChampSupValeur('VIR_LIBRIB'  , 'RIB :');
    T.AddChampSupValeur('VIR_RIB'     , Q.FindField('BQ_ETABBQ').AsString + '-' +
                                        Q.FindField('BQ_GUICHET').AsString + '-' +
                                        Q.FindField('BQ_NUMEROCOMPTE').AsString + '-' +
                                        Q.FindField('BQ_CLERIB').AsString );
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.RemplitLettre2(Q : TQuery; Transfert : Boolean; var T : TOB; Mt, Dev, NoDossier : string);
{---------------------------------------------------------------------------------------}
var
  NomBase : string;
begin
  if IsTresoMultiSoc then NomBase := GetInfosFromDossier('DOS_NODOSSIER', NoDossier, 'DOS_NOMBASE')
                     else NomBase := '';

  T.AddChampSupValeur('VIR_DEST'      , GetParamsocDossierSecur('SO_LIBELLE'   , '', NomBase));
  T.AddChampSupValeur('VIR_DESTADR1'  , GetParamsocDossierSecur('SO_ADRESSE1'  , '', NomBase));
  T.AddChampSupValeur('VIR_DESTADR2'  , GetParamsocDossierSecur('SO_ADRESSE2'  , '', NomBase));
  T.AddChampSupValeur('VIR_DESTCP'    , GetParamsocDossierSecur('SO_CODEPOSTAL', '', NomBase));
  T.AddChampSupValeur('VIR_DESTVILLE' , GetParamsocDossierSecur('SO_VILLE'     , '', NomBase));
  T.AddChampSupValeur('VIR_DESTPAYS'  , GetParamsocDossierSecur('SO_PAYS'      , '', NomBase));
  T.AddChampSupValeur('VIR_DESTBQ'    , Q.FindField('PQ_LIBELLE').AsString);
  T.AddChampSupValeur('VIR_DESTDOM'   , Q.FindField('BQ_DOMICILIATION').AsString);
  T.AddChampSupValeur('VIR_DESTPAYS'  , Q.FindField('PY_LIBELLE').AsString);
  T.AddChampSupValeur('VIR_DESTBIC'   , Q.FindField('BQ_CODEBIC').AsString);
  T.AddChampSupValeur('VIR_MONTANT'   , Mt);
  T.AddChampSupValeur('VIR_DEVISE'    , Dev);
  if Transfert then T.AddChampSupValeur('VIR_DESTRIB'   , Q.FindField('BQ_CODEIBAN').AsString)
               else T.AddChampSupValeur('VIR_DESTRIB'   , Q.FindField('BQ_ETABBQ').AsString + '-' +
                                                          Q.FindField('BQ_GUICHET').AsString + '-' +
                                                          Q.FindField('BQ_NUMEROCOMPTE').AsString + '-' +
                                                          Q.FindField('BQ_CLERIB').AsString );
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.IntegreCompta;
{---------------------------------------------------------------------------------------}
begin
  if not AfficheMessageErreur(Ecran.Caption, 'Certains virements ne peuvent �tre int�gr�es en comptabilit� ') then begin
    if TobCompta.Detail.Count = 0 then
       HShowMessage('7;' + Ecran.Caption + ';Aucune �criture n''a �t� int�gr�e.'#13 +
                       ' Veuillez v�rifier que les �critures li�es aux virements'#13 +
                       ' correspondent bien � un exercice ouvert en comptabilit�.;I;O;O;O;', '', '')
    else
      {18/09/06 : Nouvelle Int�gration multi-soci�t�s}
      TRIntegrationPieces(TobCompta, False)
  end;

  TobCompta.ClearDetailPC;
end;

{---------------------------------------------------------------------------------------}
function TOF_VIREMENT.VerifCodeFlux : Boolean;
{---------------------------------------------------------------------------------------}
var
  g, c, s : string;
begin
  Result := True;
  if IsTresoMultiSoc then Exit;

  {Si les codes flux sont renseign�s, en th�orie les comptes de contre-parties sont bien renseign�s, car on fait
   un test sur la TomFluxTreso.OnUpdateRecord sur TFT_GENERAL. Ce compte est n�c�ssaire pour g�n�rer l'�criture
   de contrepartie en compta : on ne peut pas cr�er une pi�ce en compta avec compte A en d�bit et compte B en cr�dit.
   Les deux flux doivent avoir le m�me compte g�n�ral "poubelle" de sorte � �quilibrer la pi�ce en compta}
  GetCibSensGeneral(g, s, c, CODETRANSACDEP); {16/09/04 : FQ 10136 : il est inutile de passer par les transactiond}
  CptePoubelle := g;
  GetCibSensGeneral(g, s, c, CODETRANSACREC);
  if (CptePoubelle <> g) or (g = '') then begin
    HShowMessage('22;' + Ecran.Caption + ';Les comptes g�n�raux des flux d''�quilibrage sont diff�rents !'#13 +
                 'Les virements ne seront pas int�gr�s en comptabilit�;W;O;O;O;', '', '');
    Result := False;
  end;
end;

{11/10/06 : FQ 10379
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.BParamOnClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  s := GetControlText('FETAT');
  EditEtat('E', 'TCV', 'LCV', True, nil, '', Ecran.Caption);
  ChargeListeEtat(s);
end;

{11/10/06 : FQ 10379 : recharge la combo des �tats et positionnement sur une ligne
{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.ChargeListeEtat(aEtat : string);
{---------------------------------------------------------------------------------------}
var
  FEtat : THValComboBox;
  dEtat : string;
begin
  FEtat := THValComboBox(GetControl('FETAT'));
  FEtat.ReLoad;

  FEtat.ItemIndex := -1;
  if aEtat = '' then begin
    dEtat := GetFromRegistry(HKEY_LOCAL_MACHINE, 'Software\' + Apalatys + '\'
                             + NomHalley + '\QRS1Def', GetLeNom('TRVIREMENT'), '');
    if dEtat <> '' then
      FEtat.ItemIndex := FEtat.values.IndexOf(dEtat);
    if FEtat.ItemIndex = -1 then
      FEtat.ItemIndex := FEtat.values.IndexOf('LCV');
  end
  else
    FEtat.ItemIndex := FEtat.values.IndexOf(aEtat);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_VIREMENT.InitConfidentialites;
{---------------------------------------------------------------------------------------}
{$IFDEF TRCONF}
var
  SQLConf : string;
{$ENDIF TRCONF}
begin
  DConf := '';
  SConf := '';
  {$IFDEF TRCONF}
  SQLConf := TObjConfidentialite.GetWhereConf(V_PGI.User, tyc_Banque);
  if SQLConf <> '' then SQLConf := ' AND (' + SQLConf + ') ';
  DConf   := AliasSQL(SQLConf, 'BQ', 'BD');
  SConf   := AliasSQL(SQLConf, 'BQ', 'BS');
  {$ENDIF TRCONF}
end;

initialization
  registerclasses ( [ TOF_VIREMENT ] ) ;

end.

