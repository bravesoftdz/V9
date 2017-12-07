{-------------------------------------------------------------------------------------
  Version    |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
08.01.001.009  28/01/07  JP  Cr�ation de l'unit� : Contient diff�rentes fonctions et variables
                             utiles au nouveau pointage
08.01.001.009  14/02/07  JP  Ajout de la classe anc�tre aux deux saisies simplifi�es : TofAncetreEcr
08.10.001.010  20/09/07  JP  FQ 21349 : annulationn du pointage de mouvements issus d'autres relev�s
                             mais point�s lors de la session que l'on vient de supprimer
08.10.001.010  20/09/07  JP  FQ 21333 : Fen�tre de choix d'une date comptable
08.10.002.001  22/10/07  JP  FQ 21706 : Fonction de conversion d'un fichier sans retour de chariot
08.10.005.001  14/11/07  JP  Gestion des comptes pointables qui ne sont pas bancaires  
--------------------------------------------------------------------------------------}
unit uLibPointage;

interface

uses
  {$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF EAGLCLIENT}
  UTob, UTOF, Classes;


const
  ORIGINERELEVE   = 'INT';
  CODENEWPOINTAGE = 'RAP';
  CODEOLDPOINTAGE = 'OLD';
  CODEPOINTAGEMAN = 'MAN';
  CODEPOINTAGENBQ = 'NBQ';
  LIGNEBANCAIRE   = '���';
  SANSSESSIONPTGE = '*$*';
  SESSIONTRESO    = 'TRE';

  FO_MULEEXBQLIG  = 'M';
  FO_POINTAGE     = 'P';

type
  TTypeVisu = (tv_Tout, tv_Bancaire, tv_Comptable, tv_Pointe, tv_NonPointe, tv_Session, tv_EnCours);

  TRecRib = record
    Etab    : string;
    Guichet : string;
    Compte  : string;
    Clef    : string;
    Iban    : string;
  end;

  {20/09/07 : FQ 21333 : Fen�tre de choix d'une date}
  TOF_CPCHOIXDATECPT = class(TOF)
    procedure OnArgument(S : string); override;
    procedure OnUpdate              ; override;
    class function GetDate(aDate : TDateTime) : TDateTime;
  end;

{D�termine si en Tr�sorerie, on pointe sur TRECRITURE}
function  EstPointageSurTreso : Boolean;
{Faut-il cacher le pointage en compta ? Oui, si pointage sur TRECRITURE}
function  MsgPointageSurTreso : Boolean;
{Vide le pointage sur (TR)ECRITURE et EEXBQLIG}
function  CDepointeEcriture(CptJnl, RefPtge, NumSession : string; vDatePointage : TDateTime) : Boolean;
{On ne peut supprimer une r�f�rence de pointage que s'il n'y en a pas de post�rieure}
function  CanDeleteRefPtge(Compte : string; dtPointage : TDateTime) : Boolean;
{V�rifie que le relev� de CEtebac que l'on se pr�pare � int�grer dans EexBqLig est coh�rent avec l'existant}
function  HasCoherenceCEtebacEexbq(const DtOpe01, DtOpe07 : TDateTime; const Rib : TRecRib; const Mnt07 : Double) : string;
{Remise � z�ro du pointage : traitement pr�liminaire et appel � LanceRazPointage}
procedure CRazModePointage;
function  MajTotauxPointe(vCompte : string; vTotDebPTP, vTotCrePTP, vTotDebPTD, vTotCrePTD : Double;
                          vBoInit : Boolean = True; vDossier : string = '') : Boolean;
{Gestion des diff�rentes possibilit�s de LookUp sur la zone g�n�rale : Journal, BanqueCp, Generaux}
procedure LookUpGenePtge(Sender : TObject);
{S'agit-il d'un relev� int�gr� dans EEXBQLIG ?}
function IsReleveAuto(Value : string) : Boolean;
{Est-on en compta PCL}
function IsComptaPCL : Boolean;
{Tob de l'�cran de pointage}
procedure AddChampPointage(var aTob : TOB);
{Pour cacher en compta des menus pointage si pointage sur TRECRITURE}
function EstPointageCache : Boolean;
{Gestion du code Iso sur la devise EUR en Mode PCL}
function TesteCodeIsoDevise(var aCodeIso, aDevise : string) : string;
{20/09/07 : FQ 21333 : acc�s � une fen�tre de choix de date}
function RecupDateComptable(DateDef : TDateTime) : TDateTime;
function CEstPointageEnConsultationSurDossier : boolean;

implementation


uses
  {$IFNDEF BUREAU}
  CpteSav {CTrouveContrePartie},
  {$ENDIF BUREAU}
  {$IFDEF EAGLCLIENT}
  MaineAgl,
  {$ELSE}
  FE_Main,
  {$ENDIF EAGLCLIENT}
  CPVersion,
  utilPGI {_Blocage}, ED_Tools {InitMoveProgressForm}, LicUtil {CryptageSt},
  HStatus {InitMove}, UtilSais {CUpdateCumulsPointeMS}, Lookup, Vierge,
  SysUtils, ParamSoc, HEnt1, HCtrls, Constantes, Ent1, HMsgBox, Commun, Controls;


{Lancement de la remise � z�ro proprement dite du pointage
 NewPointage : A True, on se limite aux mouvement qui ont un code rappro (<=> au nouveau pointage
               A False, on vide tout le pointage et on purge EEXBQ et EEXBQLIG
 Titre : Titre des messages et de la ProgressForm}
procedure LanceRazPointage(NewPointage : Boolean; Titre : string); forward;



{GCO : D�termine si la configuration du dossier autorise les modfis
       de pointage pour savoir qui a raison l'expert ou le client
       Valeur de retour : True si en mode Consultation
       False si en mode Cr�ation/Modification
{---------------------------------------------------------------------------------------}
function CEstPointageEnConsultationSurDossier : boolean;
{---------------------------------------------------------------------------------------}
begin

  result := false ;

  // SBO 12/09/2008 : En mode classique (lien S1 non coch�), on ne test pas le mode de pointage "S1"  
  if (GetparamsocSecur ('SO_CPMODESYNCHRO', TRUE) = FALSE) then exit ;

  if CtxPcl in V_PGI.PGIContexte then begin
    if (GetParamsoc ('SO_CPLIENGAMME') = 'AUC') or (GetParamsoc ('SO_CPLIENGAMME') = 'SI') or (GetParamsoc ('SO_CPLIENGAMME') = '') then
      Result := False
    else begin
      // GCO - 07/10/2005 - FQ 15988
      Result := (GetParamsoc ('SO_CPPOINTAGESX') = 'CLI') or (GetParamsoc ('SO_CPPOINTAGESX') = 'AUC');
    end;
  end
  else begin // Contexte PGE
    if (GetParamsoc ('SO_CPLIENGAMME') = 'AUC') or (GetParamsoc ('SO_CPLIENGAMME') = 'SI') or (GetParamsoc ('SO_CPLIENGAMME') = '') then
      Result := False
    else
      Result := (GetParamsoc ('SO_CPPOINTAGESX') = 'EXP');
  end;
end;

{D�termine si en Tr�sorerie, on pointe sur TRECRITURE : pour cela il faut �tre en Tr�so,
 demander le pointage sur TRECRITURE et ne pas �tre en pointage sur Journal
 Par contre si on est en Cash Pooling, il n'y a pas de choix, on pointe sur TRECRITURE
 (vu avec OG le 08/02/07), ce qui signifie que l'on supprime le pointage en compta !!
{---------------------------------------------------------------------------------------}
function EstPointageSurTreso : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := IsTresoMultiSoc or
            ((ctxTreso in V_PGI.PGIContexte) and
            GetParamSocSecur('SO_TRPOINTAGETRESO', False) and
            not GetParamSocSecur('SO_POINTAGEJAL', False));
  if Result and not GetParamSocSecur('SO_TRPOINTAGETRESO', False) then
    SetParamSoc('SO_TRPOINTAGETRESO', True);
end;

{---------------------------------------------------------------------------------------}
function EstPointageCache : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := EstComptaTreso
            and
            (
             (
              EstMultiSoc and (GetParamSocSecur('SO_TRBASETRESO', '') <> '')
             )
             or
             (
              GetParamSocSecur('SO_TRPOINTAGETRESO', False) and not GetParamSocSecur('SO_POINTAGEJAL', False)
             )
            );
end;

{Faut-il cacher le pointage en compta ? Oui, si pointage sur TRECRITURE
 18/09/07 : FQ 21439 : Faute d'orthographe sur "vieilles"}
{---------------------------------------------------------------------------------------}
function MsgPointageSurTreso : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := True;
  if GetParamSocSecur('SO_TRPOINTAGETRESO', False) or EstPointageCache {(EstMultiSoc and EstComptaTreso)} then begin
    Result := PGIAsk(TraduireMemoire('Vous �tres en pointage sur les Flux de Tr�sorerie.') + #13 +
                     TraduireMemoire('L''utilisation de cette fonction depuis la Comptabilit� est r�serv�e aux vieilles ') + #13 +
                     TraduireMemoire('sessions de pointage ou aux sessions sur des comptes pointables non bancaires.') + #13 + #13 +
                     TraduireMemoire('Souhaitez-vous poursuivre ?')) = mrYes;
  end;
end;

{14/06/07 : Gestion du code Iso sur la devise EUR en Mode PCL
{---------------------------------------------------------------------------------------}
function TesteCodeIsoDevise(var aCodeIso, aDevise : string) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := '';
  if aCodeIso = '' then begin
    if (CtxPcl in V_PGI.PGIContexte) and (aDevise = V_PGI.DevisePivot) then begin
      if ExecuteSQL('UPDATE DEVISE SET D_CODEISO = "' + V_PGI.DevisePivot + '" WHERE D_DEVISE = "EUR"') > 0 then begin
        aCodeIso := 'EUR';
        Exit;
      end;
    end;
    Result := TraduireMemoire('Impossible de r�cup�rer le code ISO de la devise');
  end;
end;

{S'agit-il d'un relev� int�gr� dans EEXBQLIG ?
{---------------------------------------------------------------------------------------}
function IsReleveAuto(Value : string) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := (Value = ORIGINERELEVE) or (Value = CODENEWPOINTAGE);
end;

{Est-on en compta PCL}
{---------------------------------------------------------------------------------------}
function IsComptaPCL : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := (ctxPcl in V_PGI.PGIContexte) and (ctxCompta in V_PGI.PGIContexte);
end;

{Depointe les �critures d'une r�f�rence de pointage
 Si Pointage sur Compte --> CptJnl = Compte
 Si Pointage sur Journal --> CptJnl = Journal
{---------------------------------------------------------------------------------------}
function CDepointeEcriture(CptJnl, RefPtge, NumSession : string; vDatePointage : TDateTime) : Boolean;
{---------------------------------------------------------------------------------------}
{$IFNDEF BUREAU}
var
  lContrePartie : string;
  SQL           : string;
  Gene          : string;
{$ENDIF BUREAU}
begin
  Result := True;
  {$IFNDEF BUREAU}
  if VH^.PointageJal then begin
    lContrePartie := CTrouveContrePartie(CptJnl);
    if lContrePartie = '' then begin
      PGIError(TraduireMemoire('Impossible de trouver le compte de contrepartie du journal : ') + CptJnl, TraduireMemoire('Traitement annul�'));
      Result := False;
      Exit;
    end;
  end;

  BeginTrans;
  try
    {Pointage sur TRECRITURE}
    if EstPointageSurTreso then begin
      {Suppression du pointage des �critures de Tr�so}
      SQL := 'UPDATE TRECRITURE SET TE_CODERAPPRO = "", TE_REFPOINTAGE = "",' +
             'TE_DATERAPPRO = "' + USDateTime(iDate1900) + '" WHERE ' +
             'TE_GENERAL = "' + CptJnl + '" AND ' +
             'TE_DATERAPPRO = "' + UsDateTime(vDatePointage) + '"';
      ExecuteSQL(SQL);

      {JP 29/05/07 : Oubli de ma part : Suppression du pointage des �critures}
      Gene := GetGeneFromBqCode(CptJnl);
      SQL := 'UPDATE ECRITURE SET E_REFPOINTAGE = "", E_NATURETRESO = "", ' +
              'E_DATEPOINTAGE = "' + USDateTime(iDate1900) + '" WHERE ' +
              'E_GENERAL = "' + Gene + '" AND ' +
              'E_REFPOINTAGE = "' + RefPtge + '" AND ' +
              'E_DATEPOINTAGE = "' + UsDateTime(vDatePointage) + '"';
      ExecuteSQL(SQL);
    end

    {Pointage sur journal}
    else if VH^.PointageJal then begin
      {Suppression du pointage des �critures comptables}
      SQL := 'UPDATE ECRITURE SET E_REFPOINTAGE = "", E_NATURETRESO = "", ' +
              {FQ Tr�so 10019 : maj du champ E_TRESOSYNCHRO, Pour que lors de prochaine synchronisation
                                de la tr�sorerie le champ TE_DATERAPPRO puisse �tre mis � jour}
              'E_TRESOSYNCHRO = "' + ets_Pointe + '", ' +
              'E_DATEPOINTAGE = "' + USDateTime(iDate1900) + '" WHERE ' +
              'E_JOURNAL = "' + CptJnl + '" AND ' +
              'E_GENERAL <> "' + lContrePartie + '" AND ' +
              'E_REFPOINTAGE = "' + RefPtge + '" AND ' +
              'E_DATEPOINTAGE = "' + UsDateTime(vDatePointage) + '"';
      ExecuteSQL(SQL);
    end

    {Pointage sur compte bancaire}
    else begin
      {Suppression du pointage des �critures}
      SQL := 'UPDATE ECRITURE SET E_REFPOINTAGE = "", E_NATURETRESO = "", ' +
              {$IFDEF TRSYNCHRO}
              {FQ Tr�so 10019 : maj du champ E_TRESOSYNCHRO, Pour que lors de prochaine synchronisation
                                de la tr�sorerie le champ TE_DATERAPPRO puisse �tre mis � jour}
              'E_TRESOSYNCHRO = "' + ets_Pointe + '", ' +
              {$ENDIF}
              'E_DATEPOINTAGE = "' + USDateTime(iDate1900) + '" WHERE ' +
              'E_GENERAL = "' + CptJnl + '" AND ' +
              'E_REFPOINTAGE = "' + RefPtge + '" AND ' +
              'E_DATEPOINTAGE = "' + UsDateTime(vDatePointage) + '"';
      ExecuteSQL(SQL);
    end;

    (*
    {Suppression du pointage des mouvements bancaires}
    SQL := 'UPDATE EEXBQLIG SET CEL_REFPOINTAGE = "", CEL_CODERAPPRO = "", ' +
           'CEL_DATEPOINTAGE = "' + USDateTime(iDate1900) + '" WHERE ' +
           'CEL_GENERAL = "' + CptJnl + '" AND ' +
           'CEL_REFPOINTAGE = "' + RefPtge + '" AND ' +
           'CEL_DATEPOINTAGE = "' + UsDateTime(vDatePointage) + '"';
    if Trim(CodePtge) <> '' then
      SQL := SQL + ' AND CEL_CODERAPPRO = "' + CodePtge + '"';
      *)
    SQL := 'DELETE FROM EEXBQLIG WHERE CEL_GENERAL = "' + CptJnl + '" AND ' +
           '(CEL_VALIDE <> "X" OR CEL_VALIDE IS NULL) AND CEL_NUMRELEVE = ' + NumSession ;
    ExecuteSQL(SQL);

    {20/09/07 : FQ 21349 : annulationn du pointage de mouvements issus d'autres relev� mais
                point�s lors de la session que l'on vient de supprimer}
    SQL := 'UPDATE EEXBQLIG SET CEL_REFPOINTAGE = "", CEL_CODERAPPRO = "", ' +
           'CEL_DATEPOINTAGE = "' + USDateTime(iDate1900) + '" WHERE ' +
           'CEL_GENERAL = "' + CptJnl + '" AND ' +
           'CEL_REFPOINTAGE = "' + RefPtge + '" AND ' +
           'CEL_DATEPOINTAGE = "' + UsDateTime(vDatePointage) + '"';
    ExecuteSQL(SQL);

    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      PgiError('Erreur SQL : ' + E.Message, 'Fonction : CDepointeEcriture');
      Result := False;
    end;
  end;
  {$ENDIF BUREAU}
end;

{On ne peut supprimer une r�f�rence de pointage que s'il n'y en a pas de post�rieure
{---------------------------------------------------------------------------------------}
function CanDeleteRefPtge(Compte : string; dtPointage : TDateTime) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := not ExisteSQL('SELECT EE_REFPOINTAGE FROM EEXBQ WHERE EE_GENERAL = "' + Compte +
                          '" AND EE_DATEPOINTAGE > "' + UsDateTime(dtPointage) + '"');
end;

{Supprime toutes les r�f�rences de pointage manuelles
 Enleve les infos de pointage des �critures associ�es
 Met � z�ro les champs G_TOTDEB,etc.... de la Table GENERAUX
{---------------------------------------------------------------------------------------}
procedure CRazModePointage;
{---------------------------------------------------------------------------------------}
var
  lStTitrePGIInfo : string;
  lStQuestion     : string;
  NewPointage     : Boolean;
  mrResult        : TModalResult;
begin
  {JP 17/07/07 : FQ 20605 : par d�faut, on fait une RAZ compl�te}
  NewPointage := False;//True;

  {GCO - 27/10/2004 FQ 14804}
  if CEstPointageEnConsultationSurDossier then begin
    PgiInfo(TraduireMemoire('Vous avez indiqu� une liaison avec une comptabilit�') + ' ' +
            RechDom('CPLIENCOMPTABILITE',GetParamSocSecur('SO_CPLIENGAMME', ''), False) + ' ' +
            TraduireMemoire('et la gestion du pointage') + ' '#13 +
            TraduireMemoire('est effectu�e') + ' ' + RechDom('CPPOINTAGESX', GetParamSocSecur('SO_CPPOINTAGESX', ''), False) + '. ' +
            TraduireMemoire('Vous n''avez pas acc�s � cette commande.'), TraduireMemoire('Remise � z�ro du pointage'));
    Exit;
  end;

  lStTitrePGIInfo := TraduireMemoire('Remise � z�ro du pointage');
  if VH^.PointageJal then
    lStTitrePGIInfo := lStTitrePGIInfo + ' ' + TraduireMemoire('sur journal')
  else begin
    if EstPointageSurTreso then
      lStTitrePGIInfo := lStTitrePGIInfo + ' ' + TraduireMemoire('sur flux de Tr�sorerie')
    else
      lStTitrePGIInfo := lStTitrePGIInfo + ' ' + TraduireMemoire('sur compte g�n�ral');
  end;

  {On est dans une compta avec Tr�so ou en Tr�so}
  if EstComptaTreso then begin
    if (ctxTreso in V_PGI.PGIContexte) and {On est en Tr�so}
       ((not V_PGI.Superviseur) or (V_PGI.PassWord <> CryptageSt(DayPass(Date)))) then begin
      PGIError(TraduireMemoire('Seul un administrateur avec le mot de passe du jour peut effectuer ce traitement'), lStTitrePGIInfo);
      Exit;
    end;

    if PgiAsk(TraduireMemoire('Attention : Vous allez supprimer le pointage du dossier. Confirmez vous le traitement ?'), lStTitrePGIInfo) = MrNo then
      Exit;

    if EstPointageSurTreso then
      lStQuestion := TraduireMemoire('Voulez-vous supprimer compl�tement le pointage (Oui), simplement le pointage sur') + #13 +
                     TraduireMemoire('les flux de Tr�sorerie (Non) ou abandonner (Annuler) ?')
    else
      lStQuestion := TraduireMemoire('Voulez-vous supprimer compl�tement le pointage (Oui), simplement le nouveau') + #13 +
                     TraduireMemoire('pointage (Non) ou abandonner (Annuler) ?');

    mrResult := HShowMessage('0;' + lStTitrePGIInfo + ';' + lStQuestion + ';Q;YNC;C;C;', '', '');
    case mrResult of
      mrCancel : Exit;
      mrYes    : NewPointage := False;
      mrNo     : NewPointage := True;
    end;

  end

  {On est dans une compta qui n'a pas de Tr�so}
  else begin
    if PgiAsk(TraduireMemoire('Attention : Vous allez supprimer le pointage du dossier. Confirmez vous le traitement ?'), lStTitrePGIInfo) = MrNo then
      Exit;

    if PgiAsk(TraduireMemoire('Attention : Le pointage va �tre compl�tement supprim�. Voulez vous abandonner le traitement ?'), lStTitrePGIInfo) = MrYes then
      Exit;
  end;

  LanceRazPointage(NewPointage, lStTitrePGIInfo);
end;

{Lancement de la remise � z�ro proprement dite du pointage
{---------------------------------------------------------------------------------------}
procedure LanceRazPointage(NewPointage : Boolean; Titre : string);
{---------------------------------------------------------------------------------------}
{$IFNDEF BUREAU}
var
  SQL : string;
  Dos : string;
  chD : string;
{$ENDIF BUREAU}
begin
  {$IFNDEF BUREAU}
  if IsTresoMultiSoc and (VarTreso.lNomBase = '') then
    ChargeVarTreso;

  if not _BlocageMonoPoste(True) then Exit;
  try
    BeginTrans;
    InitMoveProgressForm(nil, Titre, TraduireMemoire('Suppression'), 3, True, True);
    try

      {On Commence par vider EEXBQ}
      MoveCurProgressForm(TraduireMemoire('Suppression des sessions de pointage'));
      if NewPointage then
        ExecuteSql('DELETE FROM EEXBQ WHERE EE_ORIGINERELEVE = "' + CODENEWPOINTAGE + '"')
      else
        ExecuteSql('DELETE FROM EEXBQ');

      {On vide EEXBQLIG}
      MoveCurProgressForm(TraduireMemoire('Suppression des mouvements bancaires'));
      SQL := 'DELETE FROM EEXBQLIG';
      if NewPointage then
        SQL := SQL + ' WHERE CEL_CODEPOINTAGE <> "" AND CEL_CODEPOINTAGE IS NOT NULL';
      ExecuteSql(SQL);

      {On "nettoie" les r�f�rence de pointage de TRECRITURE}
      MoveCurProgressForm(TraduireMemoire('Suppression du pointage sur les �critures de Tr�sorerie'));
      SQL := 'UPDATE TRECRITURE SET TE_CODERAPPRO = "", TE_DATERAPPRO  = "' + UsDateTime(iDate1900) +
      {JP 17/07/07 : Ajoute de TE_REFPOINTAGE}
             '", TE_REFPOINTAGE = "" ' + 'WHERE TE_DATERAPPRO > "' + UsDateTime(iDate1900) + '"';
      if NewPointage then
        SQL := SQL + ' AND TE_CODERAPPRO <> "" AND TE_CODERAPPRO IS NOT NULL';
      ExecuteSql(SQL);

      {En tr�so multi dossiers, on est obligatoirement sur en pointage sur TRECRITURE :
       il faut donc nettoyer toutes les bases du rergoupement}
      if IsTresoMultiSoc then begin
        Dos := VarTreso.lNomBase;
        chD := ReadTokenSt(Dos);
        while chD <> '' do begin
          {On "nettoie" les r�f�rence de pointage de ECRITURE}
          MoveCurProgressForm(TraduireMemoire('Suppression du pointage sur les �critures comptables (Dossier :' + chD + ')'));
          SQL := 'UPDATE ECRITURE SET E_REFPOINTAGE = "", E_NATURETRESO = "", ' +
                  'E_DATEPOINTAGE  = "' + UsDateTime(iDate1900) + '" ' + 'WHERE E_REFPOINTAGE <> ""';
          if NewPointage then
            SQL := SQL + ' AND E_NATURETRESO <> "" AND E_NATURETRESO IS NOT NULL';
          ExecuteSql(SQL);

          {On passe au dossier suivant}
          chD := ReadTokenSt(Dos);
        end;
      end

      else begin
        SQL := 'UPDATE ECRITURE SET E_REFPOINTAGE = "", E_NATURETRESO = "", ' +
                'E_DATEPOINTAGE  = "' + UsDateTime(iDate1900) + '" ' + 'WHERE E_REFPOINTAGE <> ""';
        if NewPointage then
          SQL := SQL + ' AND E_NATURETRESO <> "" AND E_NATURETRESO IS NOT NULL';
        ExecuteSql(SQL);
      end;

      CommitTrans;

      {Mise � jour des Totaux point�s}
      if IsTresoMultiSoc then begin
        Dos := VarTreso.lNomBase;
        chD := ReadTokenSt(Dos);
        while chD <> '' do begin
          MoveCurProgressForm(TraduireMemoire('Suppression des totaux point�s des comptes g�n�raux (Dossier :' + chD + ')'));
          if NewPointage then
            RecalculTotPointeNew1('', chD)
          else
            MajTotauxPointe('', 0, 0, 0, 0, True, chD);
          {On passe au dossier suivant}
          chD := ReadTokenSt(Dos);
        end;
      end
      else begin
        {Mise � jour des totaux point�s des comptes g�n�raux}
        MoveCurProgressForm(TraduireMemoire('Suppression des totaux point�s des comptes g�n�raux'));
        if NewPointage then
          RecalculTotPointeNew1('')
        else
          MajTotauxPointe('', 0, 0, 0, 0);
      end;

      PgiInfo(TraduireMemoire('Le traitement s''est correctement termin�.'), Titre);

    except
      on E : Exception do
      begin
        PgiError(TraduireMemoire('Erreur SQL : ') + E.Message, TraduireMemoire('Fonction : CRazModePointage'));
        RollBack;
      end;
    end;

  finally
    FiniMoveProgressForm;
    _DeblocageMonoPoste(True);
  end;
  {$ENDIF BUREAU}
end;

{---------------------------------------------------------------------------------------}
function MajTotauxPointe(vCompte : string; vTotDebPTP, vTotCrePTP, vTotDebPTD, vTotCrePTD : Double;
                         vBoInit : Boolean = True; vDossier : string = '') : Boolean;
{---------------------------------------------------------------------------------------}
{$IFNDEF BUREAU}
var
  Gene : string;
  SQL  : string;
{$ENDIF BUREAU}
begin
  Result := True;
  {$IFNDEF BUREAU}

  {Recherche du compte de contrepartie car pointage sur journal}
  if VH^.PointageJal then begin
    {S'il n'y a pas de journal en param�tre ...}
    if vCompte = '' then begin
      {... Soit on fait une RAZ g�n�ral ...}
      if vBoInit and (vTotDebPTP = 0) and (vTotCrePTP = 0) and (vTotDebPTD = 0) and (vTotCrePTD = 0) then begin
        ExecuteSQL('UPDATE ' + GetTableDossier(vDossier, 'GENERAUX') + ' SET G_TOTDEBPTP = 0, G_TOTCREPTP = 0, G_TOTDEBPTD = 0, G_TOTCREPTD = 0');
        {Si la table est partag�e, on met � jour les cumuls}
        if not EstTablePartagee( 'GENERAUX' ) then
        CReinitCumulsPointeMS('', vDossier);
      end
      {... Soit il y a un probl�me !!}
      else
        Result := False;
      Exit;
    end
    else begin
      Gene := CTrouveContrePartie(vCompte);
      {Si on ne trouve pas le compte de contrepartie du Journal}
      if Gene = '' then begin
        Result := False;
        Exit;
      end;
    end
  end
  else
    Gene := vCompte;

  if not EstTablePartagee( 'GENERAUX' ) then begin
    SQL := 'UPDATE ' + GetTableDossier(vDossier, 'GENERAUX') + ' SET ';
    if vBoInit then begin
      SQL := SQL + 'G_TOTDEBPTP = ' + StrFPoint(vTotDebPTP) + ', ';
      SQL := SQL + 'G_TOTCREPTP = ' + StrFPoint(vTotCrePTP) + ', ';
      SQL := SQL + 'G_TOTDEBPTD = ' + StrFPoint(vTotDebPTD) + ', ';
      SQL := SQL + 'G_TOTCREPTD = ' + StrFPoint(vTotCrePTD) + ' ';
    end
    else begin
      {Si on met � jour les soldes, on s'assure que l'on a bien un compte de d�fini}
      if Gene = '' then begin
        Result := False;
        Exit;
      end;
      SQL := SQL + 'G_TOTDEBPTP = G_TOTDEBPTP + ' + StrFPoint(vTotDebPTP) + ', ';
      SQL := SQL + 'G_TOTCREPTP = G_TOTCREPTP + ' + StrFPoint(vTotCrePTP) + ', ';
      SQL := SQL + 'G_TOTDEBPTD = G_TOTDEBPTD + ' + StrFPoint(vTotDebPTD) + ', ';
      SQL := SQL + 'G_TOTCREPTD = G_TOTCREPTD + ' + StrFPoint(vTotCrePTD) + ' ';
    end;

    if Gene <> '' then
      SQL := SQL + ' WHERE G_GENERAL = "' + Gene + '"';
    ExecuteSQL(SQL);
  end
  else begin
    {Si le compte est vide ...}
    if (Gene = '') then begin

      if vBoInit and (vTotDebPTP = 0) and (vTotCrePTP = 0) and (vTotDebPTD = 0) and (vTotCrePTD = 0) then
        {... Soit on fait une RAZ g�n�ral ...}
        CReinitCumulsPointeMS(vCompte, vDossier)
      else
        {... Soit il y a un probl�me !!}
        Result := False;
    end
    else
      CUpdateCumulsPointeMS(vCompte, vTotDebPTP, vTotCrePTP, vTotDebPTD, vTotCrePTD, vBoInit, vDossier);
  end;
  {$ENDIF BUREAU}
end;

{V�rifie que le relev� de CEtebac que l'on se pr�pare � int�grer dans EexBqLig est coh�rent avec l'existant
{---------------------------------------------------------------------------------------}
function HasCoherenceCEtebacEexbq(const DtOpe01, DtOpe07 : TDateTime; const Rib : TRecRib; const Mnt07 : Double) : string;
{---------------------------------------------------------------------------------------}
var
  S  : string;
  Dc : Integer;
  Q  : TQuery;
  Ok : Boolean;
begin
  Result := '';

  S := 'SELECT (EE_NEWSOLDECRE + EE_NEWSOLDECREEURO - EE_NEWSOLDEDEBEURO - EE_NEWSOLDEDEB) MNT, EE_DATESOLDE, ';
  S := S + 'BQ_LIBELLE, EE_DEVISE FROM EEXBQ LEFT JOIN BANQUECP ON EE_GENERAL = BQ_GENERAL ';
  S := S + 'WHERE BQ_ETABBQ = "' + Rib.Etab + '" AND ' +
           'BQ_GUICHET = "' + Rib.Guichet + '" AND ' +
           'BQ_NUMEROCOMPTE = "' + Rib.Compte + '" AND ';
  S := S + 'EE_DATESOLDE <= "' + UsDateTime(DtOpe01) +
           '" ORDER BY EE_DATESOLDE DESC';
  Q := OpenSQL(S, True);
  try
    if not Q.EOF then begin
      {R�cup�ration du nombre de d�cimales de la devise}
      Dc := CalcDecimaleDevise(Q.FindField('EE_DEVISE').AsString);

      {On s'assure qu'il n'existe pas d�j� une session de pointage � la date du relev�}
      Ok := Q.FindField('EE_DATESOLDE').AsDateTime <> DtOpe07;
      if Ok then begin
        {Une incoh�rence des soldes entre EEXBQ et un relev� n'est pas une anomalie bloquante ...}
        if Arrondi(Q.FindField('MNT').AsFloat, Dc) <> Arrondi(Mnt07, Dc) then
          {... c'est � l'utilisateur de d�terminer s'il poursuit ou non}
          Ok := PGIAsk(TraduireMemoire('Il y a une incoh�rence entre le solde final de la session de pointage du ') + #13 +
                           Q.FindField('EE_DATESOLDE').AsString + '(' + StrFPoint(Q.FindField('MNT').AsFloat) + ')'#13 +
                           TraduireMemoire('et le solde d''origine du relev�') + ' (' + StrFPoint(Mnt07) + ') ' +
                           TraduireMemoire('sur le compte') + #13 + ' "' + Q.FindField('BQ_LIBELLE').AsString + '".'#13#13 +
                           TraduireMemoire('Souhaitez-vous malgr� tout int�grer le relev� ?'), TraduireMemoire('Coh�rence des relev�s')) = mrYes;
        if not Ok then
          Result := TraduireMemoire('Le solde du fichier n''est pas coh�rent avec la derni�re session de pointage.');
      end
      else
        Result := TraduireMemoire('Il existe d�j� une session de pointage � la date du relev�');
    end
    else begin
      {Il n'y a pas de r�f�rence de pointage ant�rieure au relev�}
      Ok := True;
      Result := SANSSESSIONPTGE;
    end;

  finally
    Ferme(Q);
  end;

  {Il n'y a pas de r�f�rence de pointage ant�rieure au relev� ou tout est OK ...}
  if Ok then begin
    {... On s'assure qu'il n'y en pas de post�rieure}
    S := 'SELECT EE_DATESOLDE FROM EEXBQ LEFT JOIN BANQUECP ON EE_GENERAL = BQ_GENERAL ';
    S := S + 'WHERE BQ_ETABBQ = "' + Rib.Etab + '" AND ' +
             'BQ_GUICHET = "' + Rib.Guichet + '" AND ' +
             'BQ_NUMEROCOMPTE = "' + Rib.Compte + '" AND ';
    S := S + 'EE_DATESOLDE > "' + UsDateTime(DtOpe07) + '"';
    if ExisteSQL(S) then
      Result := TraduireMemoire('Il y a une session de pointage post�rieure');
  end;
end;

{Gestion des diff�rentes possibilit�s de LookUp sur la zone g�n�rale : Journal, BanqueCp, Generaux}
{---------------------------------------------------------------------------------------}
procedure LookUpGenePtge(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  lSt : string;
begin
  if not VH^.PointageJal then begin
    {On a trois cas :
     1/ Pointage sur TRECRITURE, on affiche banquecp et on retourne BQ_CODE
     2/ Pointage sur ECRITURE en Tr�so, on affiche banquecp (pour r�cup�rer le dossier) et on retourne BQ_GENERAL
     3/ Pointage sur ECRITURE en  Compta, on travaille sur les g�n�raux pointable}
    if CtxTreso in V_PGI.PGIContexte then begin
      {JP 25/01/08 : FQ 10547 : Le filtre sur les dossiers a �t� mutualis� dans Commun.GetTrFiltreDossiers}
      lSt := GetTrFiltreDossiers;

      lSt := FiltreBanqueCp(tcp_Bancaire, tcb_Bancaire, lSt);
      if lSt <> '' then begin
        if Pos('AND', lSt) = 1 then System.Delete(lSt, 1, 3);
        lSt := lSt ;//+ 'WHERE ';
      end;

      if EstPointageSurTreso then
        LookUpList(THEdit(Sender), TraduireMemoire('Compte'), 'BANQUECP', 'BQ_CODE', 'BQ_LIBELLE', lSt, 'BQ_CODE', True, 0)
      else
        LookUpList(THEdit(Sender), TraduireMemoire('Compte'), 'BANQUECP', 'BQ_GENERAL', 'BQ_LIBELLE', lSt, 'BQ_GENERAL', True, 0);
    end
    else begin
      {14/11/07 : En pointage sur TRECRITURE, on autorise en compta le pointage sur les comptes non bancaires}
      if EstPointageCache then
        LookUpList(THEdit(Sender), TraduireMemoire('Compte g�n�ral'), 'GENERAUX', 'G_GENERAL', 'G_LIBELLE',
                    'G_POINTABLE = "X" AND G_NATUREGENE <> "BQE"', 'G_GENERAL', True, 0)

      {14/11/07 : Le pointage sur journal n'est compatible qu'avec des comptes bancaires}
      else if VH^.PointageJal then
        LookUpList(THEdit(Sender), TraduireMemoire('Compte g�n�ral'), 'GENERAUX', 'G_GENERAL', 'G_LIBELLE',
                    'G_POINTABLE = "X" AND G_NATUREGENE = "BQE"', 'G_GENERAL', True, 0)

      else
        LookUpList(THEdit(Sender), TraduireMemoire('Compte g�n�ral'), 'GENERAUX', 'G_GENERAL', 'G_LIBELLE',
            'G_POINTABLE="X"', 'G_GENERAL', True, 0);
    end;
  end
  else begin
    lSt := 'SELECT J_JOURNAL, J_LIBELLE FROM JOURNAL LEFT JOIN GENERAUX ON J_CONTREPARTIE=G_GENERAL ' +
        'WHERE J_NATUREJAL="BQE" AND G_POINTABLE="X"';{ ORDER BY J_JOURNAL' SG6 19/01/05 FQ 15135 }

    LookUpList(THEdit(Sender), 'Journal', 'JOURNAL', 'J_JOURNAL', 'J_LIBELLE', '', 'J_JOURNAL', True, 0, lSt);
  end;
end;

{Cette fonction est n�cessaire pour s'assurer que l'on met bien les champs dans le bon ordre
 et de ce fait, autoriser le ChangeParent
{---------------------------------------------------------------------------------------}
procedure AddChampPointage(var aTob : TOB);
{---------------------------------------------------------------------------------------}
begin //OK@@
  aTob.AddChampSup('CLE_DATECOMPTABLE', False);
  aTob.AddChampSup('CLE_NUMEROPIECE'  , False);
  aTob.AddChampSup('CLE_NUMLIGNE'     , False);
  aTob.AddChampSup('CLE_REFPOINTAGE'  , False);
  aTob.AddChampSup('CLE_DEVISE'       , False);
  aTob.AddChampSup('CLE_CIB'          , False);
  aTob.AddChampSup('CLE_REFINTERNE'   , False);
  aTob.AddChampSup('CLE_LIBELLE'      , False);
  aTob.AddChampSup('CLE_REFEXTERNE'   , False);
  aTob.AddChampSup('CLE_REFLIBRE'     , False);
  aTob.AddChampSup('CLE_NUMTRAITECHQ' , False);
  aTob.AddChampSup('CLE_DEBIT'        , False);
  aTob.AddChampSup('CLE_CREDIT'       , False);
  aTob.AddChampSup('CLE_DEBITDEV'     , False);
  aTob.AddChampSup('CLE_CREDITDEV'    , False);
  aTob.AddChampSup('CLE_JOURNAL'      , False);
  aTob.AddChampSup('CLE_EXERCICE'     , False);
  aTob.AddChampSup('CLE_DATEVALEUR'   , False);
  aTob.AddChampSup('CLE_DATEPOINTAGE' , False);
  aTob.AddChampSup('CLE_NUMECHE'      , False);
  aTob.AddChampSup('CLE_QUALIFPIECE'  , False);
  aTob.AddChampSup('CLE_GENERAL'      , False);
  aTob.AddChampSup('CLE_MONTANT'      , False);
  aTob.AddChampSup('CLE_MONTANTDEV'   , False);
  aTob.AddChampSup('CLE_MANUEL'       , False);
  aTob.AddChampSup('CLE_DATEECHEANCE' , False);
  aTob.AddChampSup('CLE_POINTE'       , False);
  aTob.AddChampSup('CLE_OLDREF'       , False);
  aTob.AddChampSup('MODIFIE'          , False);
end;

{---------------------------------------------------------------------------------------}
function RecupDateComptable(DateDef : TDateTime) : TDateTime;
{---------------------------------------------------------------------------------------}
begin
  Result := TOF_CPCHOIXDATECPT.GetDate(DateDef);
  if Result = iDate1900 then
    Result := DateDef;
end;


{ TOF_CPCHOIXDATECPT }

{---------------------------------------------------------------------------------------}
class function TOF_CPCHOIXDATECPT.GetDate(aDate: TDateTime): TDateTime;
{---------------------------------------------------------------------------------------}
var
  stDate : string; 
begin
  Result := iDate1900;
  stDate := AglLanceFiche('CP', 'CPCHOIXDATECPT', '', '', DateToStr(aDate) + ';');
  if (stDate <> '') and IsValidDate(stDate) then
    Result := StrToDate(stDate);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPCHOIXDATECPT.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
begin
  inherited;
  SetControlText('EDDATE', ReadTokenSt(S));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPCHOIXDATECPT.OnUpdate;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  TFVierge(Ecran).Retour := GetControlText('EDDATE');
end;

initialization
  RegisterClasses([TOF_CPCHOIXDATECPT]);

end.

