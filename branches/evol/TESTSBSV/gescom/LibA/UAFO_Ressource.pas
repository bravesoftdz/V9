{***********UNITE*************************************************
Auteur  ...... : PL
Cr�� le ...... : 14/09/2001
Modifi� le ... : 14/09/2001
Description .. : OBJET RESSOURCE
Mots clefs ... : OBJET; RESSOURCE
*****************************************************************}
unit UAFO_Ressource;

interface

uses
  {$IFDEF VER150} Variants, {$ENDIF}
  Classes,
{$IFDEF EAGLCLIENT}
{$ELSE}
  db,
{$IFNDEF DBXPRESS}dbtables {BDE},
{$ELSE}uDbxDataSet,
{$ENDIF}
{$ENDIF}
  sysutils,
  paramsoc,

{$IFDEF AFFAIRE}
  afplanningCst,
  ed_tools,
  CalcOleGenericAff,
  stdctrls,
  hPanel,
  UAFO_REGLES,
  dicoBTP,
{$ENDIF}
{$IFDEF PLUGIN}
  uToolsPlugin,
{$ENDIF !PLUGIN}
  UAFO_FERIE,
  HCtrls,
  HEnt1,
  utob,
  formule
  ;

(******************************************************************************)
// TAFO_Ressource : objet image d'une ressource pouvant �tre cr�� � partir
// d'un code ressource. Seul le code est obligatoire pour la cr�ation d'une
// entit� Ressource.
//
// services :
//
// FonctionDeLaRessource : si une date est pass�e en entr�e, renvoie une TStringList
//                      comprenant un seul �l�ment : la fonction en cours pour la date donn�e
//                         si aucune date n'est fournie, renvoie une TStringList,
//                      comprenant les 4 derni�res fonctions occup�es tri�es de la plus
//                      r�cente (indice 0) � la plus ancienne (indice 3).
// PrixCourant : si une date est pass�e en entr�e, renvoie une TStringList
//                      comprenant un seul �l�ment : le prix en cours pour la date donn�e
//                         si aucune date n'est fournie, renvoie une TStringList,
//                      comprenant les 4 derniers prix tri�s du plus
//                      r�cent (indice 0) au plus ancien (indice 3).
// PRRessource : renvoie le prix de revient de la ressource
// PVRessource : renvoie le prix de vente HT ou TTC de la ressource
// RessourceDisponible : renvoie un booleen indiquant si la ressource est disponible
//                      � la date et heure entr�e
// ListeCompetencesD1Ressource : renvoie une TStringList des comp�tences de la ressource
// AssocieArticle : associe un article � la ressource. Si pas d'article en entree, associe
//                   l'article par defaut de la ressource
// Auteur : Pierre Lenormand le 02/11/99
// PlugIn : Vignette portail : Ressource en sous-charge
(******************************************************************************)
type
  TAFO_Ressource = class
    Ftob_Champs: TOB;

  private
{$IFDEF AFFAIRE}
    //fMMRapportDec : TMemo;               
    //fMMRapportAnn : TMemo;
    fSlRapportDec: TStringList;
    fSlRapportAnn: TStringList;
    procedure ControleListeEtDecale(var pListeJours: TListDate; pRdDuree: Double; pInNbJoursDecal: Integer; pStMethodeDecal: string; pTobJoursOccupes: Tob; pStAffaire, pStRes: string; pTache: RecordTache);
    procedure ControleLastDateGene(var pListeJours: TListDate; pLastDateGene: TdateTime; pBoAjout: Boolean);
    function DecalageJour(var pListeJours: TListDate; pInNbJoursDecal: Integer; pStMethodeDecal: string; pRdDuree: Double; var pStJourEnCours: TdateTime; pTobJoursOccupes: Tob): Integer;
    function PeriodeTravaillee(pStCurJour: TdateTime; pRdDuree: Double; var pStJourTrouve: TdateTime): Boolean;
    function LoadListeJoursOccupes(pStRes: string; pDtDateDeb, pDtDateFin: TDateTime): Tob;
    function PasDansListe(vDtCurDate: TDateTime; pSLJours: TListDate; pBoAjout: Boolean): Boolean;
    function JourPasOccupe(vDtCurDate: TDateTime; pTobJoursOccupes: Tob): Boolean;
    //procedure AddJournal(pStType, PStAffaire, pStTiers, pStInterv, pStRes, pStDtSource, pStDtDest : String);
    //procedure CreeJournaux;

    function GenererLignesPlanning(pListeJours: TListDate; var pInNumLigne: Integer; pTob: Tob; pStAffaire: string;
      pTache: RecordTache; pArticle: RecordArticle; pBoValorisation: Boolean; pRdDuree: Double): Boolean;

{$ENDIF}
    function DonneesFormuleP(AcsChampFormule: Hstring): variant;
    function PaieUtilisee: Boolean;

  public
    Article: TOB; // Variable servant � faire pointer l'occurrence de la ressource sur un article
    TobRessourcePR: TOB;
    TobCalendrier: TOB;
    TobCalendrierRegle: TOB;
    TobAbsenceSalarie: TOB; // Absences saisies dans la paie
    TobAbsencesParPeriode: TOB; // Tob de toutes les absences d�j� calcul�es rang�es par p�riode pour la ressource
    TobDisposParPeriode: TOB; // Tob de toutes les dispos d�j� calcul�es rang�es par p�riode pour la ressource
    gsPeriodiciteCourante: string; // Periodicite qui a servi � calculer les absences (sert � savoir si on doit recalculer au cas o� la p�riodicit� a chang�)
    gsUniteValo: string;
    gbPVHT: boolean;
    gDatePrix: TDateTime;
    gdTempsAnnuel: double;
    giAbsencePaie: integer; // 0=jamais initialis�; 1=les absences sont g�r�es dans la paie pour la ressource courante; -1=pas d'absence pour ce salari� dans la paie
    gbCreateLeger: boolean; // create l�ger pour pr�venir que seuls quelques champs ont �t� charg�s � la cr�ation
    gbCreateAvecLibres: boolean; // create l�g�re avec les champs libres en +
    gobj_JourFerie: TJourFerie;
    gsUniteActivite :string;  //AB-200607-
{$IFDEF PLUGIN}
    plugin :TVignettePlugin;
    constructor Create(AcsCodeRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false;APlugIn :TVignettePlugIn=nil); overload;
{$ELSE}
    constructor Create(AcsCodeRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false); overload;
{$ENDIF}
    destructor Destroy; override;
    property tob_Champs: TOB read Ftob_Champs write Ftob_Champs;

    function FonctionDeLaRessource(AcdDateDeFonction: TDateTime): TStringList;
    function PrixCourant(AcdDateDePrix: TDateTime; AcsTypePrix: string; AcbPVHT: boolean = true): TStringList;
    function PRRessource(AcdDate: TDateTime; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
    function PVRessource(AcdDate: TDateTime; AcbHT: boolean; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
    function CalculPrixRessource(AcdDate: TDateTime; AcsTypePrix: string; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
    function RessourceDisponible(AcdDateHeureDemande: TDateTime): boolean;
    function ListeCompetencesD1Ressource: TStringList;
    function AssocieRessourcePR(AcsCodeRessource: string; AcbForcer: boolean): boolean;
    procedure ChargeCalendriers(AcbForcer: boolean);
//    function AUnCalendrier : boolean;
    procedure ChargeAbsencesSalarie(AcbForcer: boolean);
    function ChargeTousLesChamps(AcsRessource: string): boolean;
    procedure ChargeTempsAnnuel35H;
    function TempsAnnuelRessource(AcsTypeActivite: string; AcdDateDebut, AcdDateFin: TDateTime): double;
    function ExisteUnArticleDeValo(AcsTypeValo, AcsArticle: string): boolean;
    function DetDerniereDateEffetCalendrier(AcdDateRef: TDateTime; var AviIndice: integer): TDateTime;
    function AbsenceSalarieD1Date(AcdDateTestee: TDateTime): TOB;
    function JourTravaille(pDtWork: TDateTime; var NbHeure: double; bAxeHeures: boolean): Boolean;
    function NbHeuresDispo(pDtDebut, pDtFin: TDateTime; sPeriode: string; bForcer: boolean = false): TOB;
    procedure ChargeTOBDispoDeLaRessource(TOBMere: TOB; pDtDebut, pDtFin: TDateTime; pPeriodicite: string);
{$IFDEF AFFAIRE}
    function AssocieArticle(AcsCodeArticle: string): boolean;
    function GenererPlanning(var pInNumLigne: Integer; pTob: Tob; pAFReglesTache: TAFRegles;
      pStAffaire: string; pTache: RecordTache; pArticle: RecordArticle;
      pBoValorisation, pBoAjout: Boolean; pPanel: ThPanel): Boolean;
    //function GetRessourceRemplacement : TAFO_Ressource;
    function NbJoursAbsence(pDtDebut, pDtFin: TDateTime; sPeriode: string; bForcer: boolean = false): TOB;
    procedure ChargeTOBAbsenceDeLaRessource(TOBMere: TOB; pDtDebut, pDtFin: TDateTime; pPeriodicite: string);
{$ENDIF}
  end;

  (******************************************************************************)
  // TAFO_Ressources : liste d'elements de type TAFO_Ressource h�rit� du type TSTRINGLIST
  // Sert � la gestion par listes des ressources
  //
  // services :
  // RessourcesD1Competence : donne la liste des ressources possedant une competence
  // RessourcesD1Fonction : donne la liste des ressources ayant eu ou ayant actuellement
  //                         une fonction. Pour savoir si une des fonctions est valable
  //                         � une date donn�e, il faut appeler le service 'FonctionDeLaRessource'
  //                         ressource par ressource.
  //
  // Lib�ration : la m�moire est enti�rement lib�r�e, par ressource et pour la liste
  //                elle m�me.
  //
  // Utilisation courante :
  //       on cr�� une occurrence de TAFO_Ressources, un appel � l'un des services
  //       rempli la liste, la propri�t� count indiquant le nombre d'entit� TAFO_Ressources
  //       existant dans la liste. On peut aussi g�rer compl�tement sa liste de TAFO_Ressources
  //       en utilisant toutes les m�thodes de l'anc�tre TLIST.
  //
  // Auteur : Pierre Lenormand le 02/11/99
  (******************************************************************************)
type
  TAFO_Ressources = class(TStringList)

  public
    destructor Destroy; override;

    function AddRessource(AcsRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false): integer;
    function TOBRessources(AcsTitreTOB: string): TOB;
    function GetRessource(Index: Integer): TAFO_Ressource;

    procedure RessourcesD1Competence(AcsCompetence: string);
    procedure RessourcesD1Fonction(AcsFonction: string);
    function RessourceD1User(AcsUser: string): string;
		function AddRessourceD1User(AcsUser: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false): integer;
{$IFDEF AFFAIRE}
    procedure RessourceD1TacheAffaire(AcsAffaire, AcsNumeroTache: string);
    function TOBAbsencesDesRessources(pDtDebut, pDtFin: TDateTime; pPeriodicite: string; TobRessource: TOB = nil): TOB;
    function TOBDisponibiliteDesRessources(pDtDebut, pDtFin: TDateTime; pPeriodicite: string; TobRessource: TOB = nil): TOB;
{$ENDIF}
  end;

function RessourceDuSalarie(AcsCodeSalarie: string): string;

implementation

uses
{$IFDEF AFFAIRE}
  UtilTaches,
  AffaireUtil,
  AFUtilArticle,
  utilGa,
{$ENDIF}
  entgc,
  UtilRessource
  ;

const
  TexteMessage: array[1..8] of string = (
    {1}'Affaire : %s. Tiers : %s. Intervention %s non g�n�r�e le %s pour la ressource %s.',
    {2}'Affaire : %s. Tiers : %s. Intervention %s d�cal�e du %s au %s pour la ressource %s.',
    {3}'Intervention d�cal�e',
    {4}'Intervention non g�n�r�e',
    {5}'Affaire : %s. Tiers : %s. Aucune intervention n''a �t� g�n�r�e pour la t�che %s. ',
    {6}'Affaire : %s. Aucune intervention n''a �t� g�n�r�e pour les t�ches en heures.',
    {7}'Si vous avez g�n�r� en utilisant ''Ajouter au planning existant'', vous planifiez � partir de la derni�re date de g�n�ration pr�cis�e dans l''onglet ''R�gles de la fiche T�che''. ',
    {8}'Attention � la date de fin de g�n�ration param�tr�e qui est actuellement au %s.'
    );

//
// Fonctions g�n�rales li�es � la ressource
//
(******************************************************************************)
// RessourceDuSalarie
// Entr�e : Code salari� pour lequel on cherche la ressource associ�e
//
// Sortie : code ressource s'il existe et '' sinon.
(******************************************************************************)

function RessourceDuSalarie(AcsCodeSalarie: string): string;
var
  sSelectR: string;
  QSelectR: TQuery;
begin
  Result := '';
  QSelectR := nil;
  sSelectR := 'SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_SALARIE="' + AcsCodeSalarie + '"';

  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);
    if not QSelectR.EOF then
      // Si la s�lection n'est pas vide
    begin
      Result := QSelectR.FindField('ARS_RESSOURCE').AsString;
    end;
  finally
    Ferme(QSelectR);
  end;
end;

//
// OBJET TAFO_RESSOURCES
//

destructor TAFO_Ressources.Destroy;
var
  i: integer;
begin
  for i := 0 to count - 1 do
  begin
    Objects[i].Free;
  end;

  inherited;
end;

(******************************************************************************)
// RessourcesD1Competence : donne la liste des ressources possedant une competence
//
// entr�e : code fonction recherch�
(******************************************************************************)

procedure TAFO_Ressources.RessourcesD1Competence(AcsCompetence: string);
var
  sSelectR: string;
  QSelectR: TQuery;
  vrRessource: TAFO_Ressource;
  TobCompetRess: TOB;
  i: integer;
begin
  QSelectR := nil;

  sSelectR := 'SELECT DISTINCT ACR_RESSOURCE FROM COMPETRESSOURCE WHERE ACR_COMPETENCE="' + AcsCompetence + '"';
  TobCompetRess := TOB.Create('', nil, -1);
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);

    TobCompetRess.LoadDetailDB('', '', '', QSelectR, true);
    for i := 0 to TobCompetRess.Detail.count - 1 do
    begin
      vrRessource := TAFO_Ressource.Create(string(TobCompetRess.Detail[i].GetValue('ACR_RESSOURCE')));
      if (vrRessource <> nil) then
        if (vrRessource.tob_Champs <> nil) then
          AddObject(TobCompetRess.Detail[i].GetValue('ACR_RESSOURCE'), vrRessource);
    end;

  finally
    Ferme(QSelectR);
    TobCompetRess.Free;
  end;
end;

(******************************************************************************)
// RessourceD1User : donne le code ressource du User en fourni en entr�e
//
// entr�e : code User recherch�
(******************************************************************************)

function TAFO_Ressources.RessourceD1User(AcsUser: string): string;
var
  sSelectR: string;
  QSelectR: TQuery;
begin
  Result := '';
  QSelectR := nil;
  sSelectR := 'SELECT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_UTILASSOCIE="' + AcsUser + '"';

  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);
    if not QSelectR.EOF then
      // Si la s�lection n'est pas vide
    begin
      Result := QSelectR.FindField('ARS_RESSOURCE').AsString;
    end;
  finally
    Ferme(QSelectR);
  end;
end;

// PL le 08/02/06 : Ajout de la ressource trouv�e dans la liste
function TAFO_Ressources.AddRessourceD1User(AcsUser: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false): integer;
var
  sRessCode: string;
begin
  Result := -1;

	// Si le user demand� est le user courant, on a d�j� la ressource sous la main
  // sauf au chargement de l'appli ou en dehors du contexte GC, o� elle est vide
{$IFDEF GCGC}
  if (AcsUser = V_PGI.User) and (VH_GC.RessourceUser <> '') then
		sRessCode := VH_GC.RessourceUser
	else
{$ENDIF GCGC}
		sRessCode := RessourceD1User(V_PGI.User);

	if (sRessCode <> '') then
		Result := AddRessource(sRessCode, AcbAvecCalendrier, AcbLeger, AcbAvecLibres);

end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 08/10/2002
Modifi� le ... :   /  /
Description .. : donne la liste des ressources affect�es � une t�che d'une
                 affaire
                 remarque : cette liste ne ramene que les ressources actives
Mots clefs ... :
*****************************************************************}
{$IFDEF AFFAIRE}

procedure TAFO_Ressources.RessourceD1TacheAffaire(AcsAffaire, AcsNumeroTache: string);
var
  sSelectR: string;
  QSelectR: TQuery;
  vrRessource: TAFO_Ressource;
  TobRessources: TOB;
  i: Integer;

begin
  QSelectR := nil;

  sSelectR := 'SELECT ATR_RESSOURCE FROM TACHERESSOURCE ';
  sSelectR := sSelectR + 'WHERE ATR_AFFAIRE="' + AcsAffaire + '" ';
  sSelectR := sSelectR + ' AND ATR_STATUTRES = "ACT"';
  if AcsNumeroTache <> '' then
    sSelectR := sSelectR + ' AND ATR_NUMEROTACHE=' + AcsNumeroTache;

  TobRessources := TOB.Create('', nil, -1);
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);

    TobRessources.LoadDetailDB('', '', '', QSelectR, true);
    for i := 0 to TobRessources.Detail.count - 1 do
    begin
      vrRessource := TAFO_Ressource.Create(string(TobRessources.Detail[i].GetValue('ATR_RESSOURCE')));
      if (vrRessource <> nil) then
        if (vrRessource.tob_Champs <> nil) then
          AddObject(TobRessources.Detail[i].GetValue('ATR_RESSOURCE'), vrRessource);
    end;
  finally
    Ferme(QSelectR);
    TobRessources.Free;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 13/09/2004
Modifi� le ... :   /  /
Description .. : donne la TOB des temps d'absence des ressources pr�sentes dans la liste TobRessource
                  dans le m�me ordre d'indice, sur l'intervalle des dates en entr�e
                  avec 3 colonnes en sortie :
                  ARS_RESSOURCE : code de la ressource
                  PERIODE       : p�riode associ�e (du type AAAAMM pour la p�riodicit� MOIS et AAAASS pour la p�riodicit� SEM)
                  NBJABSENCE    : le nombre de jours d'absence
                 REMARQUE IMPORTANTE : la lib�ration de la TOB est � la charge de l'appelant
Mots clefs ... :
*****************************************************************}

function TAFO_Ressources.TOBAbsencesDesRessources(pDtDebut, pDtFin: TDateTime; pPeriodicite: string; TobRessource: TOB = nil): TOB;
var
  ii: integer;
  TOBRess: TOB;
  bChargeLesAbsences: boolean;
begin
  Result := TOB.Create('Les absences', nil, -1);

  for ii := 0 to count - 1 do
    // On boucle sur toutes les ressources de la liste
  begin
    bChargeLesAbsences := true;
    if (TobRessource <> nil) then
      // S'il y a une TOB de ressources en entr�e, on ne charge que les absences de cette tob
      // sinon, on les charge toutes
    begin
      bChargeLesAbsences := false;
      TOBRess := TobRessource.FindFirst(['ARS_RESSOURCE'], [strings[ii]], false);
      if (TOBRess <> nil) then
        bChargeLesAbsences := true;
    end;

    if bChargeLesAbsences then
      // Charge les absences de la ressource courante et les range dans la TOB Result
      // qui devra �tre d�sallou�e par l'appelant
      TAFO_Ressource(Objects[ii]).ChargeTOBAbsenceDeLaRessource(Result, pDtDebut, pDtFin, pPeriodicite);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 28/10/2004
Modifi� le ... :   /  /
Description .. : donne la TOB des temps de disponibilit� des ressources pr�sentes dans la liste TobRessource
                  dans le m�me ordre d'indice, sur l'intervalle des dates en entr�e
                  avec 3 colonnes en sortie :
                  ARS_RESSOURCE : code de la ressource
                  PERIODE       : p�riode associ�e (du type AAAAMM pour la p�riodicit� MOIS et AAAASS pour la p�riodicit� SEM)
                  NBHDISPO      : le nombre d'heures de disponibilit�
                 REMARQUE IMPORTANTE : la lib�ration de la TOB est � la charge de l'appelant
Mots clefs ... :
*****************************************************************}

function TAFO_Ressources.TOBDisponibiliteDesRessources(pDtDebut, pDtFin: TDateTime; pPeriodicite: string; TobRessource: TOB = nil): TOB;
var
  ii: integer;
  TOBRess: TOB;
  bChargeLesDispos: boolean;
begin
  Result := TOB.Create('Les Dispos', nil, -1);

  for ii := 0 to count - 1 do
    // On boucle sur toutes les ressources de la liste
  begin
    bChargeLesDispos := true;
    if (TobRessource <> nil) then
      // S'il y a une TOB de ressources en entr�e, on ne charge que les dispos de cette tob
      // sinon, on les charge toutes
    begin
      bChargeLesDispos := false;
      TOBRess := TobRessource.FindFirst(['ARS_RESSOURCE'], [strings[ii]], false);
      if (TOBRess <> nil) then
        bChargeLesDispos := true;
    end;

    if bChargeLesDispos then
      // Charge les dispos de la ressource courante et les range dans la TOB Result
      // qui devra �tre d�sallou�e par l'appelant
      TAFO_Ressource(Objects[ii]).ChargeTOBDispoDeLaRessource(Result, pDtDebut, pDtFin, pPeriodicite);
  end;
end;

{$ENDIF}

(******************************************************************************)
// RessourcesD1Fonction : donne la liste des ressources ayant eu ou ayant actuellement
//                         une fonction. Pour savoir si une des fonctions est valable
//                         � une date donn�e, il faut appeler le service 'FonctionDeLaRessource'
//                         ressource par ressource.
//
// entr�e : code fonction recherch�
(******************************************************************************)

procedure TAFO_Ressources.RessourcesD1Fonction(AcsFonction: string);
var
  sSelectR: string;
  QSelectR: TQuery;
  vrRessource: TAFO_Ressource;
  TobRessources: TOB;
  i: integer;
begin
  QSelectR := nil;
  sSelectR := 'SELECT DISTINCT ARS_RESSOURCE FROM RESSOURCE WHERE ARS_FONCTION1="' + AcsFonction + '" OR ARS_FONCTION2="' + AcsFonction + '" OR ARS_FONCTION3="' + AcsFonction + '" OR ARS_FONCTION4="' + AcsFonction + '"';

  TobRessources := TOB.Create('', nil, -1);
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);

    TobRessources.LoadDetailDB('', '', '', QSelectR, true);
    for i := 0 to TobRessources.Detail.count - 1 do
    begin
      vrRessource := TAFO_Ressource.Create(string(TobRessources.Detail[i].GetValue('ARS_RESSOURCE')));
      if (vrRessource <> nil) then
        if (vrRessource.tob_Champs <> nil) then
          AddObject(TobRessources.Detail[i].GetValue('ARS_RESSOURCE'), vrRessource);
    end;

  finally
    Ferme(QSelectR);
    TobRessources.Free;
  end;
end;

function TAFO_Ressources.AddRessource(AcsRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false): integer;
var
  vrRessource: TAFO_Ressource;
begin
  vrRessource := nil;
  if (AcsRessource = '') then
  begin
    Result := -2;
    exit;
  end;

  Result := IndexOf(AcsRessource);
  if (Result = -1) then
    // le code n'est pas encore dans la liste
  begin
    try
      vrRessource := TAFO_Ressource.Create(AcsRessource, AcbAvecCalendrier, AcbLeger, AcbAvecLibres);
      if (vrRessource <> nil) then
        if (vrRessource.tob_Champs <> nil) then
          Result := AddObject(AcsRessource, vrRessource)
        else
          vrRessource.Free;
    except
      // En cas d'erreur, on d�salloue ce qu'on a allou�
      vrRessource.Free;
    end;
  end
  else
  begin
    // Si on a deja charg� la ressource, que l'on devrait avoir charg� aussi son calendrier
    // mais que le calendrier est vide, on va le charger
    if (AcbAvecCalendrier = true) and (TAFO_Ressource(GetRessource(Result)).TobCalendrier = nil) then
      TAFO_Ressource(GetRessource(Result)).ChargeCalendriers(true);

    // Si on a d�j� charg� la ressource, que l'on devrait avoir tous les champs
    // mais qu'elle est seulement en chargement l�ger, on va charger le reste
//    if (AcbLeger = true) and
//				((TAFO_Ressource(GetRessource(Result)).gbCreateLeger = false) then
		// PL le 08/02/06 : inversion du test qui �tait faux
    if (AcbLeger = false) and
				(TAFO_Ressource(GetRessource(Result)).gbCreateLeger = true) then
      TAFO_Ressource(GetRessource(Result)).ChargeTousLesChamps('');

  end;
end;

function TAFO_Ressources.TOBRessources(AcsTitreTOB: string): TOB;
var
  i: integer;
  TOBFille: TOB;
begin
  Result := TOB.Create(AcsTitreTOB, nil, -1);

  for i := 0 to count - 1 do
  begin
    TOBFille := TOB.Create('', Result, -1);
    TOBFille.Dupliquer(TAFO_Ressource(Objects[i]).tob_Champs, TRUE, TRUE, TRUE);

    //   TAFO_Ressource(Objects[i]).tob_Champs.ChangeParent(Result, -1);
  end;
end;

function TAFO_Ressources.GetRessource(Index: Integer): TAFO_Ressource;
begin
  result := TAFO_Ressource(Objects[Index]);
end;

//
//
// OBJET TAFO_Ressource
//
//
{$IFDEF PLUGIN}
constructor TAFO_Ressource.Create(AcsCodeRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false;APlugIn :TVignettePlugIn=nil);
var sSQL : string;
{$ELSE}
constructor TAFO_Ressource.Create(AcsCodeRessource: string; AcbAvecCalendrier: boolean = false; AcbLeger: boolean = false; AcbAvecLibres: boolean = false);
var
  bRessTrouvee: boolean;
  QQ: TQuery;
  sSQL: String;
{$ENDIF !PLUGIN}
begin
  gbCreateLeger := AcbLeger;
  gbCreateAvecLibres := AcbAvecLibres;
  // PL le 08/02/06 : Ajout des champs libres optionnellement
  sSQL := 'SELECT ARS_RESSOURCE,ARS_SALARIE,ARS_TYPERESSOURCE,ARS_LIBELLE,ARS_UNITETEMPS,ARS_STANDCALEN,ARS_CALENSPECIF,ARS_ARTICLE,ARS_ETABLISSEMENT,ARS_DEPARTEMENT';
  if AcbAvecLibres then
          sSQL := sSQL + ',ARS_LIBRERES1,ARS_LIBRERES2,ARS_LIBRERES3,ARS_LIBRERES4,ARS_LIBRERES5,ARS_LIBRERES6,ARS_LIBRERES7,ARS_LIBRERES8,ARS_LIBRERES9,ARS_LIBRERESA,ARS_EQUIPERESS';
  sSQL := sSQL + ' FROM RESSOURCE WHERE ARS_RESSOURCE="' + AcsCodeRessource + '"';

{$IFDEF PLUGIN}
   PlugIn := APlugIn;
   tob_Champs := PlugIn.OpenSelectInCache(sSQL); //AB-200609-
   if (tob_Champs <> nil) and (tob_Champs.detail.count > 0) then
   begin
     tob_Champs := tob_Champs.detail[0];
   end;
{$ELSE}
  bRessTrouvee := false;
  Tob_Champs := Tob.Create('RESSOURCE', nil, -1);
  if AcbLeger then // PL le 02/11/04 : create l�ger
  begin
    try
      QQ := OpenSQL(sSQL , true,-1,'',true);
      if not QQ.EOF then
      begin
        bRessTrouvee := true;
        tob_Champs.selectDB('', QQ);
      end;
    finally
      Ferme(QQ);
    end;
  end
  else
    if tob_Champs.SelectDB('"' + AcsCodeRessource + '"', nil) then
  begin
    bRessTrouvee := true;
  end;
  if not bRessTrouvee then
  begin
    tob_Champs.Free;
    tob_Champs := nil;
  end;
{$ENDIF !PLUGIN}

  if (tob_Champs <> nil) then
  begin
    gsUniteValo := tob_Champs.GetValue('ARS_UNITETEMPS');
    gbPVHT := true;
    gDatePrix := 0;
    gdTempsAnnuel := 0;

    // Chargement des calendriers de la ressource
    if AcbAvecCalendrier then
      ChargeCalendriers(true);

    // PL le 04/10/05 : On charge de toutes fa�on les jours f�ri�s
//{$IFDEF AFFAIRE}
    gobj_JourFerie := TJourFerie.Create;
//{$ENDIF}            //AB-200607-
    gsUniteActivite := GetParamSocSecur('SO_AFMESUREACTIVITE', '') ;

  end;
end;

(******************************************************************************)
// ChargeTousLesChamps : Charge tous les champs de la ressource en entr�e
//                       si pas de ressource en entr�e, consid�re que c'est un rechargement
//
// entr�e :
(******************************************************************************)

function TAFO_Ressource.ChargeTousLesChamps(AcsRessource: string): boolean;
var
  sCodeRessource: string;
begin
  Result := false;
  if (AcsRessource = '') then
  begin
    // si on ne pr�cise pas la ressource en entr�e, �a ne peut �tre qu'un rechargement
    if (Tob_Champs = nil) then
      exit; // S'il n'y avait rien avant, on sort

    sCodeRessource := Tob_Champs.GetValue('ARS_RESSOURCE');
  end
  else
    sCodeRessource := AcsRessource;

  if (Tob_Champs <> nil) then
    Tob_Champs.Free;

  Tob_Champs := Tob.Create('RESSOURCE', nil, -1);

  if not Tob_Champs.SelectDB('"' + sCodeRessource + '"', nil) then
  begin
    Tob_Champs.Free;
    Tob_Champs := nil;
  end
  else
    Result := true;

end;

// Charge les temps de la ressource sur la p�riode d'analyse 35H

(******************************************************************************)
// ChargeTempsAnnuel35H : Charge � l'instant t le temps de saisie annuel dans la variable
//                          pr�vue � cet effet : sur l'intervalle d'analyse 35h des param�tres
//
// entr�e :
(******************************************************************************)

procedure TAFO_Ressource.ChargeTempsAnnuel35H;
begin
  gdTempsAnnuel := TempsAnnuelRessource('REA', GetParamSocSecur('SO_AFDATEDEB35', iDate1900), GetParamSocSecur('SO_AFDATEFIN35', iDate2099));
end;

(******************************************************************************)
// DetDerniereDateEffetCalendrier : donne la derniere date d'effet du calendrier r�gle juste inf�rieure
//                                  � la date en entr�e et l'indice de la premi�re TOB calendrier valable
//                                  � la date d'effet
//
// entr�e : Date de r�f�rence, Indice de la premi�re TOB calendrier
(******************************************************************************)

function TAFO_Ressource.DetDerniereDateEffetCalendrier(AcdDateRef: TDateTime; var AviIndice: integer): TDateTime;
var
  i: integer;
begin
  AviIndice := -1;
  Result := idate1900;

  // Ne charge les calendriers que s'il n'ont pas deja �t� charg�s
  ChargeCalendriers(false);

  if (TobCalendrierRegle <> nil) then
  begin
    // La Tob �tant tri�e en ordre d�croissant, on r�cup�re la premi�re date d'effet juste inf�rieure
    // � la date r�f�rence
    i := 0;
    while (i < TobCalendrierRegle.Detail.count) and (TobCalendrierRegle.Detail[i].GetValue('ACG_DATEEFFET') > AcdDateRef) do
      Inc(i);

    if (i < TobCalendrierRegle.Detail.count) then
    begin
      Result := TobCalendrierRegle.Detail[i].GetValue('ACG_DATEEFFET');
      AviIndice := i;
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 24/03/2003
Modifi� le ... : 27/05/2004 par PL
Description .. : Recherche si la paie est utilis�e : en fait, si des lignes d'absences ont �t�
                  saisies pour la ressource courante
Mots clefs ... : PAIE;
*****************************************************************}

function TAFO_Ressource.PaieUtilisee: Boolean;
var
  vSt: string;
  //  vQr : TQuery;

begin
  result := false;
  try
    try
      if (giAbsencePaie = 0) then
      begin
        vSt := 'SELECT PCN_SALARIE FROM ABSENCESALARIE WHERE PCN_SALARIE="' + tob_Champs.GetValue('ARS_SALARIE')
          + '" AND (PCN_TYPEMVT="ABS" OR PCN_TYPECONGE="PRI")'
          + ' AND PCN_MVTDUPLIQUE<>"X"	AND PCN_VALIDRESP="VAL" AND PCN_CODETAPE<>"X"'
          //C.B 13/04/2006
    			// ne pas ternir compte des absences annul�es
    			+ ' AND PCN_ETATPOSTPAIE <> "NAN" ';

        if ExisteSQL(vSt) then
          result := true;
      end
      else
        if (giAbsencePaie = 1) then
        result := true
      else // cas du -1
        result := false;

    finally
      if result then
        giAbsencePaie := 1
      else
        giAbsencePaie := -1;
    end;
  except
    giAbsencePaie := 0;
  end;

  { PL le 27/05/04 :
  je l'ai r�duit au salari� en cours puisqu'on est dans une ressource
  j'ai ajout� une variable giAbsencePaie remplie par cette fonction pour �viter de relancer n fois la m�me req

  vSt := 'SELECT COUNT(*) AS NB FROM ABSENCESALARIE ';
  try
    vQr := OpenSQL(vSt, True);
    if Not vQr.EOF then
    begin
      if vQr.FindField('NB').AsInteger = 0 then
        result := false
      else
        result := true;
    end;
  finally
    Ferme(vQr);
  end;}
end;

{$IFDEF AFFAIRE}
{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 15/10/2002
Modifi� le ... :   /  /
Description .. : genere la liste des jours � planifi�s apr�s application
                 des r�gles et des contraintes de la ressource
Mots clefs ... :
*****************************************************************}
function TAFO_Ressource.GenererPlanning(var pInNumLigne: Integer; pTob: Tob; pAFReglesTache: TAFRegles;
  pStAffaire: string; pTache: RecordTache; pArticle: RecordArticle;
  pBoValorisation, pBoAjout: Boolean; pPanel: ThPanel): Boolean;
var
  vAFReglesRes: TAFRegles;
  vListeJours: TListDate;
  vRdDuree: Double; // dur�e des interventions
  vInNbJoursDecal: Integer; // nombre de jours de decalage maximum
  vStMethodeDecal: string; // m�thode de d�calage des jours
  vRdQte: Double;
  vTobJoursOccupes: Tob;
  vSt : String;

  function QuantiteRessource(pRdQte: Double): Integer;
  begin
    result := 0;
    if trunc(vRdQte) <> vRdQte then
      result := result + 1
    else
      result := trunc(vRdQte);
  end;

begin
  vRdDuree := 1;
  vRdQte := 0;
  result := true;
  vInNbJoursDecal := 0;
  vStMethodeDecal := 'A';

  fSlRapportAnn := TStringList.Create;
  fSlRapportDec := TStringList.Create;
  vAFReglesRes := TAFRegles.create;
  try
    // regles par ressource
    // attention : ramene egalement la quantite initiale de la ressource (vRdQte) utilise dans le else
    if vAFReglesRes.LoadDBReglesRes(pStAffaire, pTache.StNumeroTache, tob_Champs.GetValue('ARS_RESSOURCE'), vRdQte, Ptache.boCompteur) then
    try

      // C.B 27/07/2005
      // si option pas de surbooking
      // Chargement des jours occup�s dans le planning
      if not GetParamsocSecur('SO_AFSURBOOKING', False) then
        ;
      vTobJoursOccupes := LoadListeJoursOccupes(tob_Champs.GetValue('ARS_RESSOURCE'), pAFReglesTache.DtDateDeb, pAFReglesTache.DtDateFin);

      // calculer la quantit� par ressource
      if pTache.BoCompteur then
        vListeJours := vAFReglesRes.GenereListeJours(vRdDuree, vInNbJoursDecal, vStMethodeDecal, vAFReglesRes.QuantiteRessource)
      else
        vListeJours := vAFReglesRes.GenereListeJours(vRdDuree, vInNbJoursDecal, vStMethodeDecal, cInNoCompteur);

      if vListeJours <> nil then
      begin
        try
          ControleLastDateGene(vListeJours, pTache.StLastDateGene, pBoAjout);
          ControleListeEtDecale(vListeJours, vRdDuree, vInNbJoursDecal, vStMethodeDecal,
            vTobJoursOccupes, pStAffaire,
            tob_Champs.GetValue('ARS_RESSOURCE'), pTache);

          if vListeJours.count = 0 then
					begin
          	{5 'Affaire : %s. Tiers : %s. Aucune intervention n''a �t� g�n�r�e pour la t�che %s. Si vous avez g�n�r� en utilisant "Ajouter au planning existant", vous planifiez � partir de la derni�re date de g�n�ration pr�cis�e dans l''onglet "R�gles de la fiche T�che".'}
            vSt := format(TraduitGa(TexteMessage[5]), [PStAffaire, pTache.StTiers, pTache.StLibTache]) + TraduitGa(TexteMessage[7]);
            if pAFReglesTache.DtDateFin < now then
              vSt := vSt + format(TraduitGa(TexteMessage[8]), [dateToStr(pAFReglesTache.DtDateFin)]);
//Modif FV   	AddJournal(fSlRapportAnn, vSt);
          end
          // C.B 02/11/2006
          // on controle si la ressource � bien un calendrier
          // sinon, on ne peut ps g�n�rer
          {else if not AUnCalendrier then
          begin
            vSt := format(TraduitGa(TexteMessage[9]), [tob_Champs.GetValue('ARS_RESSOURCE')]);
          	AddJournal(fSlRapportAnn, vSt);
          end} 
          else
            result := GenererLignesPlanning(vListeJours, pInNumLigne, pTob,
              pStAffaire, pTache, pArticle, pBoValorisation, vRdDuree);
        finally
    			{3 'Intervention d�cal�e',}
//Modif FV CreeJournaux(fSlRapportDec, TexteMessage[3], 'AVE', 'PLG');
			    {4 'Intervention non g�n�r�e',}
//Modif FV CreeJournaux(fSlRapportAnn, TexteMessage[4], 'AVE', 'PLG');
        end;
      end;
    finally
      vListeJours.Free;
    end
      // regles par taches
    else
    try
      // si option pas de surbooking
      // Chargement des jours occup�s dans le planning
      if not GetParamsocSecur('SO_AFSURBOOKING', False) then
        ;
      vTobJoursOccupes := LoadListeJoursOccupes(tob_Champs.GetValue('ARS_RESSOURCE'), pAFReglesTache.DtDateDeb, pAFReglesTache.DtDateFin);

      if pTache.BoCompteur then
        // calculer la quantit� par ressource
        vListeJours := pAFReglesTache.GenereListeJours(vRdDuree, vInNbJoursDecal, vStMethodeDecal, QuantiteRessource(vRdQte))
      else
        vListeJours := pAFReglesTache.GenereListeJours(vRdDuree, vInNbJoursDecal, vStMethodeDecal, cInNoCompteur);

      if vListeJours <> nil then
      begin
        try
          ControleLastDateGene(vListeJours, pTache.StLastDateGene, pBoAjout); //pLastDateGene
          ControleListeEtDecale(vListeJours, vRdDuree, vInNbJoursDecal, vStMethodeDecal,
            vTobJoursOccupes, pStAffaire,
            tob_Champs.GetValue('ARS_RESSOURCE'), pTache);
          if vListeJours.count = 0 then
					begin
          	{5 'Affaire : %s. Tiers : %s. Aucune intervention n''a �t� g�n�r�e pour la t�che %s. Si vous avez g�n�r� en utilisant "Ajouter au planning existant", vous planifiez � partir de la derni�re date de g�n�ration pr�cis�e dans l''onglet "R�gles de la fiche T�che".'}
            vSt := format(TraduitGa(TexteMessage[5]), [PStAffaire, pTache.StTiers, pTache.StLibTache]) + TraduitGa(TexteMessage[7]);
            if pAFReglesTache.DtDateFin < now then
              vSt := vSt + format(TraduitGa(TexteMessage[8]), [dateToStr(pAFReglesTache.DtDateFin)]);
//Modif FV 	AddJournal(fSlRapportAnn, vSt);
					end

          // C.B 02/11/2006
          // on controle si la ressource � bien un calendrier
          // sinon, on ne peut ps g�n�rer
{          else if not AUnCalendrier then
          begin
            vSt := format(TraduitGa(TexteMessage[9]), [tob_Champs.GetValue('ARS_RESSOURCE')]);
          	AddJournal(fSlRapportAnn, vSt);
          end}
          else
            result := GenererLignesPlanning(vListeJours, pInNumLigne, pTob,
              pStAffaire, pTache, pArticle, pBoValorisation, vRdDuree);
        finally
			    {3'Intervention d�cal�e',}
//Modif FV CreeJournaux(fSlRapportDec, TexteMessage[3], 'AVE', 'PLG');
			    {4'Intervention non g�n�r�e',}
//Modif FV CreeJournaux(fSlRapportAnn, TexteMessage[4], 'AVE', 'PLG');
        end;
      end;
    finally
      vListeJours.Free;
      FreeAndNil(vTobJoursOccupes);
    end;
  finally
    vAFReglesRes.Free;
    fSlRapportAnn.Free;
    fSlRapportDec.Free;
  end;
end;
 
{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... :
Modifi� le ... :
Description .. :
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.GenererLignesPlanning(pListeJours: TListDate; var pInNumLigne: Integer; pTob: Tob;
  pStAffaire: string; pTache: RecordTache; pArticle: RecordArticle;
  pBoValorisation: Boolean; pRdDuree: Double): Boolean;
var
  vTob: Tob;
  i: Integer;
  vInNumLigne: Integer;
  vStAff0 : string;     
  vStAff1 : string;
  vStAff2 : string;
  vStAff3 : string;
  vStAvenant : string;

  vDtFin          : TDateTime;
  vRdDureeEnJour  : Double;
  vTOBAffaires    : Tob;
  vAFOAssistants  : TAFO_Ressources;
  vTobArticles    : Tob;
//  vBoTacheHeure   : Boolean;

begin

  result := true;
//  vBoTacheHeure := False;
  vInNumLigne := 0;
  CodeAffaireDecoupe(pStAffaire, vStAff0, vStAff1, vStAff2, vStAff3, vStAvenant, taModif, false);
  vAFOAssistants := TAFO_Ressources.Create;
  vTOBAffaires := TOB.Create('Les Affaires', nil, -1);
  vTOBArticles := TOB.Create('Les Articles', nil, -1);

  try
    //    AFRemplirTOBAffaire('', nil, TobAffaires);
    //    RemplirTOBAssistant( nil, vAFOAssistants, '');

    for i := 0 to pListeJours.count - 1 do
    begin
      //C.B 21/03/2006
      // on ne genere que les taches en jours
      //vSt := 'SELECT ATA_AFFAIRE FROM TACHE WHERE ATA_UNITETEMPS = "H" AND ATA_AFFAIRE = "' + pStAffaire + '"' + ' AND ATA_NUMEROTACHE = ' + pTache.StNumeroTache;
      //if not ExisteSql(vSt) then
      //begin
        MoveCurProgressForm('');
        vTob := TOB.Create('AFPLANNING', pTob, -1);

        vInNumLigne := pInNumLigne + i;
        vTob.PutValue('APL_AFFAIRE', pStAffaire);
        vTob.PutValue('APL_NUMEROLIGNE', vInNumLigne);
        vTob.PutValue('APL_TYPELIGNEPLA', 'TAC');
        vTob.PutValue('APL_TYPEPLA', 'PLA');
        vTob.PutValue('APL_NUMEROTACHE', pTache.StNumeroTache);
        //mcd 26/07/04 ajout trait zone libres
        vTob.PutValue('APL_LIBRETACHE1', pTache.StLib1);
        vTob.PutValue('APL_LIBRETACHE2', pTache.StLib2);
        vTob.PutValue('APL_LIBRETACHE3', pTache.StLib3);
        vTob.PutValue('APL_LIBRETACHE4', pTache.StLib4);
        vTob.PutValue('APL_LIBRETACHE5', pTache.StLib5);
        vTob.PutValue('APL_LIBRETACHE6', pTache.StLib6);
        vTob.PutValue('APL_LIBRETACHE7', pTache.StLib7);
        vTob.PutValue('APL_LIBRETACHE8', pTache.StLib8);
        vTob.PutValue('APL_LIBRETACHE9', pTache.StLib9);
        vTob.PutValue('APL_LIBRETACHEA', pTache.StLibA);
        vTob.PutValue('APL_BOOLLIBRE1', pTache.StBool1);
        vTob.PutValue('APL_BOOLLIBRE2', pTache.StBool2);
        vTob.PutValue('APL_BOOLLIBRE3', pTache.StBool3);
        vTob.PutValue('APL_ValLibre1', pTache.RdVal1);
        vTob.PutValue('APL_ValLibre2', pTache.RdVal2);
        vTob.PutValue('APL_ValLibre3', pTache.RdVal3);
        vTob.PutValue('APL_CharLibre1', pTache.StChar1);
        vTob.PutValue('APL_CharLibre2', pTache.StChar2);
        vTob.PutValue('APL_CharLibre3', pTache.StChar3);
        vTob.PutValue('APL_DateLibre1', pTache.DtDate1);
        vTob.PutValue('APL_DateLibre2', pTache.DtDate2);
        vTob.PutValue('APL_DateLibre3', pTache.DtDate3);
        vTob.PutValue('APL_RESSOURCE', tob_Champs.GetValue('ARS_RESSOURCE'));
        if pTache.StFctTache <> '' then
          vTob.PutValue('APL_FONCTION', pTache.StFctTache)
        else
          vTob.PutValue('APL_FONCTION', '');
        vTob.PutValue('APL_ARTICLE', pTache.StArticle);
        vTob.PutValue('APL_TYPEARTICLE', pArticle.StTypeArticle);
        vTob.PutValue('APL_CODEARTICLE', pArticle.StCodeArticle);

        // recuperer le mode de facturation de l'article
        vTob.PutValue('APL_ACTIVITEREPRIS', pTache.StActiviteRepris);
        vTob.PutValue('APL_TIERS', pTache.StTiers);
        vTob.PutValue('APL_ETATLIGNE', getparamsocSecur('SO_AFPLANNINGETAT', ''));
        vTob.PutValue('APL_LIGNEGENEREE', 'X');
        vTob.PutValue('APL_ACTIVITEGENERE', '-');
        vTob.PutValue('APL_AFFAIRE0', vStAff0);
        vTob.PutValue('APL_AFFAIRE1', vStAff1);
        vTob.PutValue('APL_AFFAIRE2', vStAff2);
        vTob.PutValue('APL_AFFAIRE3', vStAff3);
        vTob.PutValue('APL_AVENANT', vStAvenant);
        vTob.PutValue('APL_ACTIVITEEFFECT', '-');

        // on genere les items du planning dans la meme unit� de temps
        // que la tache
        vTob.PutValue('APL_UNITETEMPS', pTache.StUnite);
        vTob.PutValue('APL_QTEPLANIFIEE', pRdDuree);
        vTob.PutValue('APL_QTEPLANIFUREF', AFConversionUnite(pTache.StUnite, VH_GC.AFMESUREACTIVITE, pRdDuree));
        vTob.PutValue('APL_INITPTPR', '0');
        vTob.PutValue('APL_REALPTPR', '0');
        vTob.PutValue('APL_LIBELLEPLA', pTache.StLibTache);

        vTob.PutValue('APL_DATEDEBPLA', pListeJours.Items[i]);

        // date fin = date deb + qte
        // regle utilis�e : si on ne tombe pas sur un nombre de jour entier
        // on arrondi au nombre de jour sup�rieur
        vRdDureeEnJour := AFConversionUnite(pTache.StUnite, 'J', pRdDuree);
        if int(vRdDureeEnJour) < pRdDuree then
          vRdDureeEnJour := int(vRdDureeEnJour) + 1;
        vDtFin := plusDate(pListeJours.Items[i], round(vRdDureeEnJour - 1), 'J');
        vTob.PutValue('APL_DATEFINPLA', vDtFin);

        // C.B 29/06/2005
        // ajout de la gestion des heures
        vTob.putValue('APL_HEUREDEB_PLA', vTob.GetValue('APL_DATEDEBPLA') + getparamsocSecur('SO_AFAMDEBUT', 0));
        vTob.putValue('APL_HEUREFIN_PLA', vTob.GetValue('APL_DATEFINPLA') + getparamsocSecur('SO_AFPMDEBUT', 0));

        if getParamSocSecur('SO_AFALIGNREALISE', False) then
        begin
          vTob.PutValue('APL_QTEREALISE', vTob.GetValue('APL_QTEPLANIFIEE'));
          vTob.PutValue('APL_QTEREALUREF', vTob.GetValue('APL_QTEPLANIFUREF'));
        end;

        // on aligne les dates de realisation sur les dates de planification
        vTob.PutValue('APL_DATEDEBREAL', vTob.GetValue('APL_DATEDEBPLA'));
        vTob.PutValue('APL_DATEFINREAL', vTob.GetValue('APL_DATEFINPLA'));

        // C.B 29/06/2005
        // ajout de la gestion des heures
        vTob.putValue('APL_HEUREDEB_REAL', vTob.GetValue('APL_HEUREDEB_PLA'));
        vTob.putValue('APL_HEUREFIN_REAL', vTob.GetValue('APL_HEUREFIN_PLA'));

        // valorisation des lignes de planning
        if pBoValorisation then
          ValorisationPlanning (vTob, 'APL', vAFOAssistants, vTOBAffaires, vTobArticles, true, True);
        // on conserve la derniere date g�n�r�e
        if i = (pListeJours.count - 1) then
          ExecuteSql('UPDATE TACHE SET ATA_LASTDATEGENE = "' + UsDateTime(pListeJours.Items[i]) + '" WHERE ATA_AFFAIRE = "' + pStAffaire + '" AND ATA_NUMEROTACHE = ' + pTache.StNumeroTache);
      end;
      //else
      //  vBoTacheHeure := True;
    	//end;

    if pListeJours.count <> 0 then
      pInNumLigne := vInNumLigne + 1;

    //if vBoTacheHeure then
    //  AddJournal(fSlRapportAnn, format(TraduitGa(TexteMessage[6]), [PStAffaire]));

  finally
    FreeAndNil(vTOBAffaires);
    FreeAndNil(vTobArticles);
    vAFOAssistants.Free;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 13/09/2004
Modifi� le ... :
Description .. : Compte le nombre de jours d'absence dans l'intervalle de date en entr�e
                  et renvoie une tob avec les trois champs suivants :
                  ARS_RESSOURCE : ressource courante
                  PERIODE : periode associ�e (cl� pour retrouver les absences)
                  NBJABSENCE : nb de jour d'absence pour cette periode

                 remarques :
                 - IMPORTANT : Met � jour la tob TobAbsencesParPeriode qui contient toutes les absences
                 d�j� r�pertori�es (pour �viter de lancer n fois la m�me recherche) pour la ressource courante
                 cette TOB g�n�rale est d�sallou�e � la destruction de L'objet courant.
                 - si les jours feries sont travaill�s, on ne controle que le calendrier
                 - Les deux dates en entree sont inclues
                 - force le recalcul si bForcer = true
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.NbJoursAbsence(pDtDebut, pDtFin: TDateTime; sPeriode: string; bForcer: boolean = false): TOB;
var
  dNbJAbsence: double;
  pDtCourante: TDateTime;
  Ress: string;
  NbHDemiJournee, NbHeureJour: double;
  TobFille: TOB;
begin
  Result := nil;
  NbHDemiJournee := AFConversionUnite('J', 'H', 0.5);
  Ress := tob_Champs.GetValue('ARS_RESSOURCE');
  dNbJAbsence := 0;
  if (pDtDebut >= pDtFin) then
    exit;

  TobFille := nil;
  try
    // Si on ne force pas le recalcul, on regarde si la p�riode en question est d�j� dispo dans la TOB TobAbsencesParPeriode
    if (not bForcer) and (TobAbsencesParPeriode <> nil) then
      TobFille := TobAbsencesParPeriode.FindFirst(['ARS_RESSOURCE', 'PERIODE'], [Ress, sPeriode], false);

    if (TobFille = nil) then
      // Si la p�riode en question n'est pas calcul�e ou si on force le recalcul,
      // calcul des absences de la p�riode
    begin
      pDtCourante := pDtDebut;
      repeat
        JourTravaille(pDtCourante, NbHeureJour, false);

        if (NbHeureJour = 0) then
          dNbJAbsence := dNbJAbsence + 1
        else
          if (NbHeureJour = NbHDemiJournee) then
          dNbJAbsence := dNbJAbsence + 0.5;

        pDtCourante := pDtCourante + 1;
      until (pDtCourante > pDtFin);

      // On attache la tob resultat � la tob g�n�rale TobAbsencesParPeriode
      // qui contient toutes les absences d�j� calcul�es de la ressource
      TobFille := TOB.Create('La Fille', TobAbsencesParPeriode, -1);
      TobFille.AddChampSupValeur('ARS_RESSOURCE', Ress);
      TobFille.AddChampSupValeur('PERIODE', sPeriode);
      TobFille.AddChampSupValeur('NBJABSENCE', dNbJAbsence);
    end;

  finally
    Result := TobFille;
  end;
end;
{$ENDIF}



{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 28/10/2004
Modifi� le ... :
Description .. : Compte le nombre d'heures de disponibilit� dans l'intervalle de date en entr�e
                  et renvoie une tob avec les 4 champs suivants :
                  ARS_RESSOURCE : ressource courante
                  PERIODE : periode associ�e (cl� pour retrouver les absences)
                  NBHDISPO : nb d'heures de dispo pour cette periode

                 remarques :
                 - IMPORTANT : Met � jour la tob TobDispoParPeriode qui contient toutes les Dispos
                 d�j� r�pertori�es (pour �viter de lancer n fois la m�me recherche) pour la ressource courante
                 cette TOB g�n�rale est d�sallou�e � la destruction de L'objet courant.
                 - si les jours feries sont travaill�s, on ne controle que le calendrier
                 - Les deux dates en entree sont inclues
                 - force le recalcul si bForcer = true
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.NbHeuresDispo(pDtDebut, pDtFin: TDateTime; sPeriode: string; bForcer: boolean = false): TOB;
var
  pDtCourante: TDateTime;
  Ress: string;
  TobFille: TOB;
  NbHDispo, NbHeureDuJour: double;
begin
  Result := nil;
  Ress := tob_Champs.GetValue('ARS_RESSOURCE');
  if (pDtDebut >= pDtFin) then
    exit;

  TobFille := nil;
  try
    // Si on ne force pas le recalcul, on regarde si la p�riode en question est d�j� dispo dans la TOB TobDisposParPeriode
    if (not bForcer) and (TobDisposParPeriode <> nil) then
      TobFille := TobDisposParPeriode.FindFirst(['ARS_RESSOURCE', 'PERIODE'], [Ress, sPeriode], false);

    if (TobFille = nil) then
      // Si la p�riode en question n'est pas calcul�e ou si on force le recalcul,
      // calcul des dispos de la p�riode
    begin
      pDtCourante := pDtDebut;
      NbHDispo := 0;
      repeat
        // Si le jour est travaille on additionne le nombre d'heures
        JourTravaille(pDtCourante, NbHeureDuJour, true);

        NbHDispo := NbHDispo + NbHeureDuJour;

        pDtCourante := pDtCourante + 1;
      until (pDtCourante > pDtFin);

      // On attache la tob resultat � la tob g�n�rale TobDisposParPeriode
      // qui contient toutes les dispos d�j� calcul�es de la ressource
      TobFille := TOB.Create('La Fille', TobDisposParPeriode, -1);
      TobFille.AddChampSupValeur('ARS_RESSOURCE', Ress);
      TobFille.AddChampSupValeur('PERIODE', sPeriode);
      TobFille.AddChampSupValeur('NBHDISPO', NbHDispo);
    end;

  finally
    Result := TobFille;
  end;
end;

{$IFDEF AFFAIRE}
{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 13/09/2004
Modifi� le ... :   /  /
Description .. : donne la TOB des temps d'absence des ressources pr�sentes dans la liste TobRessource ou
                toutes les ressources si TOBRessource est vide.
                TOBMere en entr�e doit �tre allou�e et re�oit en filles toutes les ressources et pour chacune
                les p�riodes assoi�es � l'intervalle de dates et � la p�riodicit� fournies en entr�e

                  avec 3 colonnes en sortie :
                  ARS_RESSOURCE : code de la ressource
                  PERIODE       : p�riode associ�e (du type AAAAMM pour la p�riodicit� MOIS et AAAASS pour la p�riodicit� SEM)
                  NBJABSENCE    : le nombre de jours d'absence

                 REMARQUE IMPORTANTE : la lib�ration de la TOB est � la charge de l'appelant
Mots clefs ... :
*****************************************************************}

procedure TAFO_Ressource.ChargeTOBAbsenceDeLaRessource(TOBMere: TOB; pDtDebut, pDtFin: TDateTime; pPeriodicite: string);
var
  NumSem, NumAnnee: integer;
  sPeriodeCourante, sRessCourante: string;
  Annee, mois, jour: word;
  TobFille: TOB;
  DdebutPeriode, DfinPeriode: TDateTime;
  TobAbsenceRess: TOB;
  bForcer: boolean;
begin
  sRessCourante := tob_Champs.GetValue('ARS_RESSOURCE');

  // Init des champs date courante
  DfinPeriode := pDtDebut - 1;

  repeat // on scrute l'intervalle de dates fourni en entr�e pour le d�composer en n p�riode
    // suivant la p�riodicit� en entr�e

// nouvelles dates courantes
    DdebutPeriode := DfinPeriode + 1;
    DecodeDate(DdebutPeriode, Annee, mois, jour);
    if (pPeriodicite = 'MOIS') then
      DfinPeriode := FinDeMois(DdebutPeriode)
    else
      if (pPeriodicite = 'SEM') then
    begin
      NumSem := NumSemaine(DdebutPeriode, NumAnnee);
      DfinPeriode := PremierJourSemaine(NumSem, NumAnnee) + 7;
    end;

    if (DfinPeriode > pDtFin) then // on rectifie si on depasse la date de fin
      DfinPeriode := pDtFin;

    // On d�termine la p�riode courante
    if (pPeriodicite = 'MOIS') then
      sPeriodeCourante := inttostr(Annee) + inttostr(mois)
    else
      if (pPeriodicite = 'SEM') then
    begin
      NumSem := NumSemaine(DdebutPeriode, NumAnnee);
      sPeriodeCourante := inttostr(NumAnnee) + inttostr(NumSem);
    end;

    TobAbsenceRess := nil;
    if (TobCalendrier <> nil) or (TobAbsenceSalarie <> nil) then
    begin
      bForcer := false;
      if (pPeriodicite <> gsPeriodiciteCourante) then
        // Si la p�riodicit� a chang�e, on force le recalcul
        bForcer := true;

      // Calcule le nombre de jours d'absence
      TobAbsenceRess := NbJoursAbsence(DdebutPeriode, DfinPeriode, sPeriodeCourante, bForcer);
    end;

    if (TobAbsenceRess <> nil) then
    begin
      gsPeriodiciteCourante := pPeriodicite;
      // On duplique la tob r�ponse pour la lier � la tob Mere qui est le r�sultat
      TobFille := TOB.Create('La Fille', TOBMere, -1);
      TobFille.Dupliquer(TobAbsenceRess, true, true);
    end;
  until (DfinPeriode >= pDtFin);
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : PL
Cr�� le ...... : 28/10/2004
Modifi� le ... :   /  /
Description .. : donne la TOB des temps de dispo des ressources pr�sentes dans la liste TobRessource ou
                toutes les ressources si TOBRessource est vide.
                TOBMere en entr�e doit �tre allou�e et re�oit en filles toutes les ressources et pour chacune
                les p�riodes assoi�es � l'intervalle de dates et � la p�riodicit� fournies en entr�e

                  avec 3 colonnes en sortie :
                  ARS_RESSOURCE : code de la ressource
                  PERIODE       : p�riode associ�e (du type AAAAMM pour la p�riodicit� MOIS et AAAASS pour la p�riodicit� SEM)
                  NBHDISPO      : le nombre d'heures de dispo

                 REMARQUE IMPORTANTE : la lib�ration de la TOB est � la charge de l'appelant
Mots clefs ... :
*****************************************************************}

procedure TAFO_Ressource.ChargeTOBDispoDeLaRessource(TOBMere: TOB; pDtDebut, pDtFin: TDateTime; pPeriodicite: string);
var
  NumSem, NumAnnee: integer;
  sPeriodeCourante, sRessCourante: string;
  Annee, mois, jour: word;
  TobFille: TOB;
  DdebutPeriode, DfinPeriode: TDateTime;
  TobDispoRess: TOB;
  bForcer: boolean;
begin
  sRessCourante := tob_Champs.GetValue('ARS_RESSOURCE');

  // Init des champs date courante
  DfinPeriode := pDtDebut - 1;

  repeat // on scrute l'intervalle de dates fourni en entr�e pour le d�composer en n p�riode
    // suivant la p�riodicit� en entr�e

// nouvelles dates courantes
    DdebutPeriode := DfinPeriode + 1;
    DecodeDate(DdebutPeriode, Annee, mois, jour);
    if (pPeriodicite = 'MOIS') then
      DfinPeriode := FinDeMois(DdebutPeriode)
    else
      if (pPeriodicite = 'SEM') then
    begin
      NumSem := NumSemaine(DdebutPeriode, NumAnnee);
      //DfinPeriode := PremierJourSemaine (NumSem, NumAnnee) + 7;
      //AB-200509- si premier J semaine est lundi la semaine suivante on d�butait le mardi
      DfinPeriode := PremierJourSemaine(NumSem, NumAnnee) + 6;
    end;

    if (DfinPeriode > pDtFin) then // on rectifie si on depasse la date de fin
      DfinPeriode := pDtFin;

    // On d�termine la p�riode courante
    if (pPeriodicite = 'MOIS') then
      sPeriodeCourante := inttostr(Annee) + inttostr(mois)
    else
      if (pPeriodicite = 'SEM') then
    begin
      NumSem := NumSemaine(DdebutPeriode, NumAnnee);
      sPeriodeCourante := inttostr(NumAnnee) + inttostr(NumSem);
    end;

    TobDispoRess := nil;
    if (TobCalendrier <> nil) or (TobAbsenceSalarie <> nil) then
    begin
      bForcer := false;
      if (pPeriodicite <> gsPeriodiciteCourante) then
        // Si la p�riodicit� a chang�e, on force le recalcul
        bForcer := true;

      // Calcule le nombre d'heures de dispo
      TobDispoRess := NbHeuresDispo(DdebutPeriode, DfinPeriode, sPeriodeCourante, bForcer);
    end;

    if (TobDispoRess <> nil) then
    begin
      gsPeriodiciteCourante := pPeriodicite;
      // On duplique la tob r�ponse pour la lier � la tob Mere qui est le r�sultat
      TobFille := TOB.Create('La Fille', TOBMere, -1);
      TobFille.Dupliquer(TobDispoRess, true, true);
    end;
  until (DfinPeriode >= pDtFin);
end;


{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 13/11/2002
Modifi� le ... : 10/09/04 par PL
Description .. : Verifie si le jour est travaill�, c'est a dire que le jour
                 est dans le calendrier et que ce n'est pas un jour f�ri� ou de cong�s (rtt)
                 Retourne le nombre d'heures travaill�es dans la journ�e
                 Un jour est travaille d�s qu'une partie du temps de la journ�e est travaill�e
                 c'est le nombre d'heures qui sp�cifie dans quelle proportion

                 remarque : si les jours feries sont travaill�s,
                            on ne controle que le calendrier
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.JourTravaille(pDtWork: TDateTime; var NbHeure: double; bAxeHeures: boolean): Boolean;
var
  i: Integer;
  vInJourSemaine: Integer;
  vDtCourante: TDateTime;
  TobAbsenceDuJour: TOB;
  NbHAbsence, NbJAbsence, NbHeureTravMatin, NbHeureTravApMidi, NbHDemiJournee: double;
begin

  result := true;
  NbHeure := 0;
  NbHeureTravMatin := 0;
  NbHeureTravApMidi := 0;
  NbHDemiJournee := AFConversionUnite('J', 'H', 0.5);
  (* PL et CCO le 27/10/2004 : les r�gles de calendrier avaient �t� faites uniquement pour la gestion des 35h00
  et les notions de jour f�ri� travaill� et de dimanche travaill� est g�rable directement dans le calendrier
    if (TobCalendrierRegle <> nil) then
    begin
      // La Tob �tant tri�e en ordre d�croissant, on r�cup�re la premi�re date d'effet juste inf�rieure
      // � la date saisie et l'indice de la premi�re TOB calendrier valable � la date d'effet
      vDtDerniereDateEffet := DetDerniereDateEffetCalendrier(pDtWork, i);
      if (i <> -1) then
      begin
        if (TobCalendrierRegle.Detail[i].GetValue('ACG_DATEEFFET') = vDtDerniereDateEffet) then
        begin
          if (pDtWork >= TobCalendrierRegle.Detail[i].GetValue('ACG_DATEEFFET')) then
          // Ce qui est normalement forcement le cas
          begin
            // Si c'est un jour f�ri� et que ce n'est pas permis
            if (JourFerie.TestJourFerie(pDtWork) and (TobCalendrierRegle.Detail[i].GetValue('ACG_FERIEPERMIS')='-'))
            // Si c'est un dimanche et que ce n'est pas permis
               or ((DayOfWeek(pDtWork) = 1) and (TobCalendrierRegle.Detail[i].GetValue('ACG_DIMPERMIS')='-')) then
              Result:= false;
          end;
        end;
      end;
    end;
  *)

  if (TobCalendrier <> nil) and Result then
  begin
    // on recherche si le jour est travaill�
    for i := 0 to TobCalendrier.Detail.count - 1 do
    begin
      vDtCourante := TobCalendrier.Detail[i].GetValue('ACA_DATE');
      // cas 1
      // le jour est saisi dans le calendrier
      if (vDtCourante = pDtWork) then
      begin
        NbHeure := TobCalendrier.Detail[i].GetDouble('ACA_DUREE');
        NbHeureTravMatin := TobCalendrier.Detail[i].GetDouble('ACA_HEUREFIN1') - TobCalendrier.Detail[i].GetDouble('ACA_HEUREDEB1');
        NbHeureTravApMidi := TobCalendrier.Detail[i].GetDouble('ACA_HEUREFIN2') - TobCalendrier.Detail[i].GetDouble('ACA_HEUREDEB2');
        // si c'est un jour f�ri� et qu'on ne peut pas travailler les jours f�ri�s
        if gobj_JourFerie.TestJourFerie(pDtWork) and
          (TobCalendrier.Detail[i].GetValue('ACA_FERIETRAVAIL') = '-') then
        begin
          Result := false;
          break;
        end;

        // s'il y a une dur�e, alors le jour est travaill�
        if (TobCalendrier.Detail[i].GetValue('ACA_JOUR') = 0) then
        begin
          if (NbHeure > 0) then
          begin
            Result := true;
            break;
          end
          else
          begin
            Result := false;
            break;
          end;
        end
        else
        begin
          Result := false;
          break;
        end;
      end
        // cas 2
        // jours de la semaine dans le calendrier
      else
      begin
        vInJourSemaine := DayOfWeek(pDtWork) - 1;
        if (vInJourSemaine = 0) then
          vInJourSemaine := 7;
        if ((TobCalendrier.Detail[i].GetValue('ACA_JOUR') = vInJourSemaine) and
          (vDtCourante = iDate1900)) then
        begin
          if (TobCalendrier.Detail[i].GetValue('ACA_DUREE') > 0) then
            // S'il y a du temps de travail pr�vue sur ce jour de semaine
          begin
            if not gobj_JourFerie.TestJourFerie(pDtWork) then
            begin
              NbHeure := TobCalendrier.Detail[i].GetDouble('ACA_DUREE');
              NbHeureTravMatin := TobCalendrier.Detail[i].GetDouble('ACA_HEUREFIN1') - TobCalendrier.Detail[i].GetDouble('ACA_HEUREDEB1');
              NbHeureTravApMidi := TobCalendrier.Detail[i].GetDouble('ACA_HEUREFIN2') - TobCalendrier.Detail[i].GetDouble('ACA_HEUREDEB2');
              result := true;
            end
            else
            begin
              result := false;
            end;
            (*PL le  27/10/04 : le probl�me du jour f�ri� se pose de 2 fa�ons :
                - soit un horaire particulier est saisi ce jour f�ri� et c'est trait� dans le bloc d'avant (au jour le jour)
                - soit aucun horaire particulier n'est trait�, et on d�pend alors de l'horaire par semaine
                          if JourFerie.TestJourFerie(pDtWork) then
                          // Si c'est un jour f�ri�
                          begin
                            // Le jour n'est pas travaill� et on sort de la boucle
                            result := false;
                            break;
                          end
                          else
                          begin*)
                            // Si ce n'est pas un jour f�ri�
                            //result := true;
                            // break; PL le 04/10/04 : et on ne sort pas de la boucle parce qu'il faut continuer
                            // � scruter le calendrier au cas o� un jour pr�cis aurait �t� choisi comme non travaill�
            //              end;
          end
          else
          begin
            // S'il n'y a aucun temps de travail pr�vu sur ce jour de semaine
            result := false;
            // break; PL le 04/10/04 : et on ne sort pas de la boucle parce qu'il faut continuer
            // � scruter le calendrier au cas o� un jour pr�cis aurait �t� choisi comme travaill�
          end;
        end;
      end;
    end; // fin du for
  end;

  // si le jour est travaill� dans le calendrier
  // ou qu'il n'est travaill� qu'une demi journ�e
  // on verifie que ce n'est pas un jour de cong�s ou rtt dans la paie  (ou maladie...)
  if Result and (TobAbsenceSalarie <> nil) then
  begin
    TobAbsenceDuJour := AbsenceSalarieD1Date(pDtWork);
    if (TobAbsenceDuJour <> nil) then
    begin
      NbHAbsence := TobAbsenceDuJour.GetDouble('PCN_HEURES');
      NbJAbsence := TobAbsenceDuJour.GetDouble('PCN_JOURS'); //AB-200509-
      if bAxeHeures then
      begin
        // Plusieurs cas : 1- des heures ont �t� prises mais r�parties sur la journ�e
        if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') <> TobAbsenceDuJour.GetValue('PCN_FINDJ')) then
        begin
          //NbHeure := NbHeure - NbHAbsence
          //AB-200509 - NbHAbsence heures d'absences pour la p�riode de NbJAbsence jours
          NbHeure := NbHeure - NbHAbsence / NbJAbsence;
          if (NbHeure < 0) then
          begin
            NbHeure := 0;
            Result := false;
          end
        end
        else
          // 2- on a pris que des heures le matin
          if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') = 'MAT') and (TobAbsenceDuJour.GetValue('PCN_FINDJ') = 'MAT') then
        begin
          NbHeureTravMatin := NbHeureTravMatin - NbHAbsence;
          if (NbHeureTravMatin < 0) then
            NbHeureTravMatin := 0;

          NbHeure := NbHeureTravMatin + NbHeureTravApMidi;
        end
        else
          // 3- on a pris que des heures l'apr�s midi
          if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') = 'PAM') and (TobAbsenceDuJour.GetValue('PCN_FINDJ') = 'PAM') then
        begin
          NbHeureTravApMidi := NbHeureTravApMidi - NbHAbsence;
          if (NbHeureTravApMidi < 0) then
            NbHeureTravApMidi := 0;

          NbHeure := NbHeureTravMatin + NbHeureTravApMidi;
        end;
      end
      else
      begin
        // Plusieurs cas : 1- des heures ont �t� prises mais r�parties sur la journ�e
        if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') <> TobAbsenceDuJour.GetValue('PCN_FINDJ')) then
        begin
          NbHeure := 0;
          Result := false;
        end
        else
          // 2- on a pris que des heures le matin
          if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') = 'MAT') and (TobAbsenceDuJour.GetValue('PCN_FINDJ') = 'MAT') then
        begin
          if (NbHeureTravApMidi > 0) then
            NbHeure := NbHDemiJournee
          else
          begin
            Result := false;
            NbHeure := 0;
          end;
        end
        else
          // 3- on a pris que des heures l'apr�s midi
          if (TobAbsenceDuJour.GetValue('PCN_DEBUTDJ') = 'PAM') and (TobAbsenceDuJour.GetValue('PCN_FINDJ') = 'PAM') then
        begin
          if (NbHeureTravMatin > 0) then
            NbHeure := NbHDemiJournee
          else
          begin
            NbHeure := 0;
            Result := false;
          end;
        end;
      end;
    end;
  end;

  // R�capitulatif pour la gestion par jour :
  // PL le 15/11/04 : on choisit de g�rer les absences � la demi journ�e de la fa�on suivante :
    // Si le jour est travaill�, qu'on est sur l'axe des absences et que le calcul de la demi journ�e n'est pas d�j� fait dans les absences
      // alors si le nb d'heures travaill�es est inf�rieur ou �gal � 0.5j, alors on renvoie 0.5j  (et >0)
      // sinon on renvoie 1 j
  if (Result and not bAxeHeures and (NbHeure > 0)) then
  begin
    if (NbHeure <= NbHDemiJournee) then
    begin
      NbHeure := NbHDemiJournee;
    end
    else
      NbHeure := 2 * NbHDemiJournee;
  end;
end;

{$IFDEF AFFAIRE}
{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 30/12/2002
Modifi� le ... :
Description .. : Recherche du calendrier des ressources pour affecter les t�ches
                 26/07/2005
                 modification de la m�thode de d�calage en prenant en compte
                 les �l�ments d�j� dans la liste et la planification d�j� effectu�e

                 algorithme : on v�rifie pour chaque �l�ment de la liste
                 - si il n'est pas d�j� dans la liste
                 - si il n'est pas deja travaille pour une autre affaire
                 - si c'est un jour travaill�

Mots clefs ... :
*****************************************************************}

procedure TAFO_Ressource.ControleListeEtDecale(var pListeJours: TListDate; pRdDuree: Double; pInNbJoursDecal: Integer; pStMethodeDecal: string; pTobJoursOccupes: Tob; pStAffaire, pStRes: string; pTache: RecordTache);
var
  i: Integer;
  vStJourListe: TDateTime;
  vStJourTrouve: TdateTime;
  vStJourEnCours: TdateTime;
  vBoTrouve: Boolean;

begin
  for i := pListeJours.Count - 1 downto 0 do
  begin
    vStJourListe := pListeJours.Items[i];
    vStJourEnCours := vStJourListe;
    vStJourTrouve := Idate1900;
    vBoTrouve := False;

    if PasDansListe(vStJourEnCours, pListeJours, False) and
      JourPasOccupe(vStJourEnCours, pTobJoursOccupes) and
      PeriodeTravaillee(vStJourEnCours, pRdDuree, vStJourTrouve) then
      vBoTrouve := True
    else
    begin
      vStJourTrouve := vStJourEnCours;
      case DecalageJour(pListeJours, pInNbJoursDecal, pStMethodeDecal, pRdDuree, vStJourTrouve, pTobJoursOccupes) of
        cInConserver:
          begin
            vBoTrouve := true;
            vStJourTrouve := vStJourEnCours;
          end;
        cInAnnuler:
          begin
            vBoTrouve := false;
          end;
        cInDecaler:
          begin
            if vStJourEnCours <> vStJourTrouve then
              vBoTrouve := true
            else
              vBoTrouve := false;
          end;
      end; // Case
    end;

    //cas 1 : conserver
    // rien

    // cas 2
    // supprime la planification pour cette ressource
    // et tenter le remplacement de ressource
    if not vBoTrouve then
    begin
      // C.B 29/07/2005
      // �criture dans le journal d''�v�nements des jours annul�s
      //AddJournal('ANN', PStAffaire, pTache.StTiers, pTache.StLibTache, pStRes, pListeJours.Strings[i], '');

			// 'Affaire : %s. Tiers : %s. Intervention %s non g�n�r�e le %s pour la ressource %s.',
    	{1'Affaire : %s. Tiers : %s. Intervention %s non g�n�r�e le %s pour la ressource %s.',}
//Modif FV AddJournal(fSlRapportAnn, format(TraduitGa(TexteMessage[1]), [PStAffaire, pTache.StTiers, pTache.StLibTache, pListeJours.Strings[i], pStRes]));
      pListeJours.Delete(i);

      // recherche de la ressource de remplacement
      // si paie serialis�e
      {else if GetParamSoc ('SO_AFRESSREMP') then
      begin
      end

      // sinon effectation de la ressource de remplacement dans les paramsoc
      else
      begin
        //GetParamSoc ('SO_AFRESSREMP');
      end;
      }
    end

      // cas 3 decalage
      // un autre jour est trouv�
    else
      if vBoTrouve and (vStJourEnCours <> vStJourTrouve) and (vStJourTrouve <> IDate1900) then
    begin
      //AddJournal('DEC', PStAffaire, pTache.StTiers, pTache.StLibTache, pStRes, pListeJours.Strings[i], vStJourTrouve);
			//'Affaire : %s. Tiers : %s. Intervention %s d�cal�e du %s au %s pour la ressource %s.',
    	{2'Affaire : %s. Tiers : %s. Intervention %s d�cal�e du %s au %s pour la ressource %s.',}
//Modif FV AddJournal(fSlRapportDec, format(TraduitGa(TexteMessage[2]), [PStAffaire, pTache.StTiers, pTache.StLibTache, pListeJours.Strings[i], vStJourTrouve, pStRes]));

      pListeJours.Delete(i);
      pListeJours.add(vStJourTrouve);
    end;
  end; // end for
end;

{function TAFO_Ressource.GetRessourceRemplacement : TAFO_Ressource;
var
  Q : TQuery;
  S : String;

begin

  S := 'SELECT  ';
  Q := OpenSQL (S, true);

  Try
    if (Not Q.EOF) then
    begin

      // chargement de la ressource de remplacement

    end
    else
      result := nil;

  Finally
    Ferme(Q);
  End;
end;
}

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 24/03/2003
Modifi� le ... :   /  /
Description .. : On d�cale le jour de depart selon la regle choisie en parametre
                 retour : 0 conserve la valeur
                          1 annuler la planification
                          2 decale le jour
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.DecalageJour(var pListeJours: TListDate; pInNbJoursDecal: Integer; pStMethodeDecal: string; pRdDuree: Double; var pStJourEnCours: TdateTime; pTobJoursOccupes: Tob): Integer;
var
  i: integer;
  vBoTrouve: Boolean;
  vStJourEnCours: TdateTime;

begin
  i := 0;
  result := cInAnnuler;
  vBoTrouve := false;

  // regles de report
  if pStMethodeDecal = cStAnnule then
    result := cInAnnuler

  else
    if pStMethodeDecal = cStJour then
    result := cInConserver

  else
    if pStMethodeDecal = cStJourPrec then
  begin
    result := cInDecaler;
    vStJourEnCours := pStJourEnCours - 1;
    while (not vBoTrouve) and (i < pInNbJoursDecal - 1) do
    begin
      if PasDansListe(vStJourEnCours, pListeJours, True) and
        JourPasOccupe(vStJourEnCours, pTobJoursOccupes) and
        PeriodeTravaillee(vStJourEnCours, pRdDuree, pStJourEnCours) then
      begin
        vBoTrouve := true;
        break;
      end
      else
      begin
        i := i + 1;
        vStJourEnCours := vStJourEnCours - 1;
      end;
    end;
  end

  else
    if pStMethodeDecal = cStJourSuiv then
  begin
    result := cInDecaler;
    vStJourEnCours := pStJourEnCours + 1;
    while (not vBoTrouve) and (i < (pInNbJoursDecal - 1)) do
    begin
      if PasDansListe(vStJourEnCours, pListeJours, True) and
        JourPasOccupe(vStJourEnCours, pTobJoursOccupes) and
        PeriodeTravaillee(vStJourEnCours, pRdDuree, pStJourEnCours) then
      begin
        vBoTrouve := true;
        break;
      end
      else
      begin
        i := i + 1;
        vStJourEnCours := vStJourEnCours + 1;
      end;
    end;
  end;

  // si on devait decaler et qu'on n'a pas pu, on annule la planification
  if (not vBoTrouve) and (result = cInDecaler) then
    result := cInAnnuler;

end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 10/05/2002
Modifi� le ... :   /  /
Description .. : si l'ensemble des jours de la periode sont travaill�s
                 la p�riode est travaill�e
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.PeriodeTravaillee(pStCurJour: TDateTime; pRdDuree: Double; var pStJourTrouve: TdateTime): Boolean;
var
  i: Integer;
  vDtJourEnCours: TDateTime;
  vInDuree: Integer;
  NbHeure: double;

begin

  ChargeCalendriers(True);
  vDtJourEnCours := pStCurJour;
  pStJourTrouve := IDate1900;
  result := true;
  if (frac(pRdDuree) <> 0) then
    vInDuree := trunc(pRdDuree) + 1
  else
    vInDuree := trunc(pRdDuree);

  for i := 0 to vInDuree - 1 do
  begin
    if JourTravaille(vDtJourEnCours, NbHeure, false) then
    begin
      // on retourne dans pStJourTrouve le premier jour de decalage trouv�
      if pStJourTrouve = IDate1900 then
        pStJourTrouve := vDtJourEnCours;
      vDtJourEnCours := vDtJourEnCours + 1;
    end
    else
    begin
      result := false;
      break;
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 22/07/2005
Modifi� le ... :
Description .. : Chargement des journ�es planifi�es pour une ressource sur
                 une p�riode donn�e pour ne pas planifier une aurte intervention
                 le m�me jour
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.LoadListeJoursOccupes(pStRes: string; pDtDateDeb, pDtDateFin: TDateTime): Tob;
var
  vSt: string;

begin
  vSt := 'SELECT APL_DATEDEBPLA, APL_DATEFINPLA FROM AFPLANNING ';
  vSt := vSt + ' WHERE APL_RESSOURCE = "' + pStRes + '"';
  vSt := vSt + ' AND APL_DATEDEBPLA >= "' + usDateTime(pDtDateDeb) + '"';
  vSt := vSt + ' AND APL_DATEDEBPLA <= "' + usDateTime(pDtDateFin) + '"';
  result := TOB.Create('AFPLANNING', nil, -1);
  result.LoadDetailFromSQL(vSt);
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 22/07/2005
Modifi� le ... :
Description .. : quand on passe dans cette fonction, la liste � �t� constitu�e
                 on teste donc si la date est 2 fois dans la stringlist
                 pBoAjout permet de savoir si on teste :
                 - une valeur � ajouter dans la liste, dans ce cas une seule
                   pr�sence dans la liste indique deja dans la liste
                 - une valeur est en doublon dans la liste, et donc a decaler,
                   dans ce cas, la pr�sence de 2 fois la date dans la liste
                   indique qu'il y a un doublon dans la liste
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.PasDansListe(vDtCurDate: TDateTime; pSLJours: TListDate; pBoAjout: Boolean): Boolean;
var
  pSLTest: TListDate;
  vInIndex: Integer;

begin
  result := True;
  if not GetParamsocSecur('SO_AFSURBOOKING', False) then
  begin
    pSLTest := TListDate.create;
    try
      pSLTest.Assign(pSLJours);
      vInIndex := pSLTest.indexof(vDtCurDate);

      // tester si on ajoute une valeur dans la liste
      if pBoAjout then
      begin
        if vInIndex <> -1 then
          result := False
        else
          result := True;
      end

        // tester si valeurs en doublons dans la liste
      else
      begin
        if vInIndex <> -1 then
        begin
          pSLTest.delete(vInIndex);
          vInIndex := pSLTest.indexof(vDtCurDate);
          if vInIndex <> -1 then
            result := False
          else
            result := True;
        end
        else
          result := True;
      end;
    finally
      pSLTest.Free;
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 22/07/2005
Modifi� le ... :
Description .. : teste si la date n'est pas d�j� occup�e par autre chose
Mots clefs ... :
*****************************************************************}

function TAFO_Ressource.JourPasOccupe(vDtCurDate: TDateTime; pTobJoursOccupes: Tob): Boolean;
var
  i: Integer;

begin
  result := True;
  if not GetParamsocSecur('SO_AFSURBOOKING', False) then
    for i := 0 to pTobJoursOccupes.detail.count - 1 do
      if (DateToStr(vDtCurDate) >= pTobJoursOccupes.detail[i].GetString('APL_DATEDEBPLA')) and
        (DateToStr(vDtCurDate) <= pTobJoursOccupes.detail[i].GetString('APL_DATEFINPLA')) then
      begin
        result := False;
        Break;
      end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 28/07/2005
Modifi� le ... :
Description .. : tablette des �v�nement GCTYPEEVENEMENT
Mots clefs ... :
*****************************************************************}
{procedure TAFO_Ressource.CreeJournaux;
var
  TobJnal: Tob;
  Indice: integer;
  QIndice: TQuery;

begin
  Indice := 0;

  QIndice := OpenSQL ('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', true);
  if not QIndice.Eof then
    Indice := QIndice.Fields[0].AsInteger + 1;
  Ferme (QIndice);

  // journal d�cal�
  if fMMRapportDec.Lines.count > 0 then
  begin
    TobJnal := Tob.Create ('JNALEVENT', nil, -1);
    try
      TOBJnal.SetString ('GEV_TYPEEVENT', 'PLG');
      TOBJnal.SetString ('GEV_LIBELLE', TexteMessage[3]);
      TOBJnal.SetDateTime ('GEV_DATEEVENT', Now);
      TOBJnal.SetString ('GEV_UTILISATEUR', V_PGI.User);
      TOBJnal.SetInteger ('GEV_NUMEVENT', Indice);
      TOBJnal.SetString ('GEV_ETATEVENT', 'OK');
      TOBJnal.SetString ('GEV_BLOCNOTE', fMMRapportDec.Lines.Text);
      TOBJnal.InsertDB (nil);
    finally
      TobJnal.free;
    end;
  end;

  // journal non g�n�r�
  if fMMRapportAnn.Lines.count > 0 then
  begin
    Indice := Indice + 1;
    TobJnal := Tob.Create ('JNALEVENT', nil, -1);
    try
      TOBJnal.SetString ('GEV_TYPEEVENT', 'PLG');
      TOBJnal.SetString ('GEV_LIBELLE', TexteMessage[4]);
      TOBJnal.SetDateTime ('GEV_DATEEVENT', Now);
      TOBJnal.SetString ('GEV_UTILISATEUR', V_PGI.User);
      TOBJnal.SetInteger ('GEV_NUMEVENT', Indice);
      TOBJnal.SetString ('GEV_ETATEVENT', 'OK');
      TOBJnal.SetString ('GEV_BLOCNOTE', fMMRapportAnn.Lines.Text);
      TOBJnal.InsertDB (nil);
    finally
      TobJnal.free;
    end;
  end;
end;
}

{procedure TAFO_Ressource.AddJournal(pStType, PStAffaire, pStTiers, pStInterv, pStRes, pStDtSource, pStDtDest : String);
begin
  if pStType = 'DEC' then
  begin
    fMMRapportDec.Lines.Append(format(TraduitGa(TexteMessage[2]), [PStAffaire, pStTiers, pStInterv, pStDtSource, pStDtDest, pStRes]));
    fMMRapportDec.Lines.Append('');
  end
  else if pStType = 'ANN' then
  begin
{procedure TAFO_Ressource.AddJournal(pStType, PStAffaire, pStTiers, pStInterv, pStRes, pStDtSource, pStDtDest : String);
    fMMRapportAnn.Lines.Append (format(TraduitGa(TexteMessage[1]), [PStAffaire, pStTiers, pStInterv, pStDtSource, pStRes]));
    fMMRapportAnn.Lines.Append ('');
  end;
end;                    
}

{***********A.G.L.***********************************************
Auteur  ...... : CB
Cr�� le ...... : 28/10/2002
Modifi� le ... :
Description .. : si on est en ajout, on ne cree les lignes que depuis la
                 derniere date de g�n�ration
Mots clefs ... :
*****************************************************************}

procedure TAFO_Ressource.ControleLastDateGene(var pListeJours: TListDate; pLastDateGene: TdateTime; pBoAjout: Boolean);
var
  i: Integer;
begin
  if pBoAjout then
    for i := pListeJours.count - 1 downto 0 do
    begin
      if pListeJours.Items[i] <= pLastDateGene then
        pListeJours.delete(i);
    end;
end;

{$ENDIF} // AFFAIRE

(******************************************************************************)
// ChargeCalendriers : Charge les calendriers li�s � la ressource
//
//
// entr�e : AcbForcer � true pour �craser les pr�c�dents
(******************************************************************************)

procedure TAFO_Ressource.ChargeCalendriers(AcbForcer: boolean);
var
  QQ: TQuery;
  sReq, sStandCalend: string;
  bCalSpecif: boolean;
begin
  QQ := nil;
  bCalSpecif := false;
  if (tob_Champs = nil) then
    exit;
  // PL le 04/10/05 : on va chercher un calendrier par d�faut maintenant
  //if (tob_Champs.GetValue('ARS_STANDCALEN')='') then exit;

  // On peut cr�er les tob des temps d'absence et de dispo en attendant qu'elles soient remplies
  if (TobAbsencesParPeriode = nil) then
    TobAbsencesParPeriode := TOB.Create('Les Absences', nil, -1);
  if (TobDisposParPeriode = nil) then
    TobDisposParPeriode := TOB.Create('Les Dispos', nil, -1);

  //
  // Calendrier
  //
  if (tob_Champs.GetValue('ARS_CALENSPECIF') = 'X') then
    bCalSpecif := true;

  if (TobCalendrier = nil) or (AcbForcer = true) then
  begin
    TobCalendrier.Free;
    TobCalendrier := nil;
{$IFNDEF PLUGIN}
    TobCalendrier := Tob.Create('CALENDRIER', nil, -1);
    TobCalendrier.InitValeurs(FALSE);
{$ENDIF !PLUGIN}
    // S'il y a un calendrier sp�cifique...
    if bCalSpecif then
    begin
      try
        sStandCalend := tob_Champs.GetValue('ARS_STANDCALEN');
        if (sStandCalend <> '') then
        begin
          sReq := 'SELECT * FROM CALENDRIER WHERE ACA_STANDCALEN="' + sStandCalend
            + '" AND ACA_RESSOURCE="' + tob_Champs.GetValue('ARS_RESSOURCE') + '"';
          // SELECT * justifi� car on a besoin de tous les champs pour les controles en aval
          // et le nombre d'enregistrements pour une ressource est restreint
{$IFDEF PLUGIN}
          TobCalendrier := PlugIn.OpenSelectInCache(sReq); //AB-200609-
{$ELSE !PLUGIN}
          QQ := OpenSQL(sReq, true,-1,'',true);
          if (not QQ.EOF) then
            TobCalendrier.LoadDetailDB('', '', '', QQ, false);
{$ENDIF !PLUGIN}
        end;

        if ((TobCalendrier<> nil) and (TobCalendrier.detail.count = 0)) or (sStandCalend = '') then
          bCalSpecif := false;

      finally
        Ferme(QQ);
        QQ := nil;
      end;
    end;

    // S'il n'y a pas de calendrier sp�cifique
    if (not bCalSpecif) then
    begin
      // Soit il y a un calendrier standard d'affect� � la ressource, et on prend celui l�
      sStandCalend := tob_Champs.GetValue('ARS_STANDCALEN');
      if (sStandCalend <> '') then
      begin
        try
          //sReq := 'SELECT * FROM CALENDRIER WHERE ACA_STANDCALEN="' + tob_Champs.GetValue('ARS_STANDCALEN')
          //      + '" AND ACA_RESSOURCE="***"';
          // PL le 04/10/05 : on affine la requ�te pour tenir compte des sp�cificit� de la paie
          sReq := 'SELECT * FROM CALENDRIER WHERE ACA_STANDCALEN="' + sStandCalend
            + '" AND ACA_RESSOURCE="***" AND ACA_SALARIE="***"';
          // SELECT * justifi� car on a besoin de tous les champs pour les controles en aval
          // et le nombre d'enregistrements pour une ressource est restreint
{$IFDEF PLUGIN}
          TobCalendrier := PlugIn.OpenSelectInCache(sReq); //AB-200609-
{$ELSE !PLUGIN}
          QQ := OpenSQL(sReq, true,-1,'',true);
          if (not QQ.EOF) then
            TobCalendrier.LoadDetailDB('', '', '', QQ, false);
          //else // PL le 04/10/05 : on va chercher un calendrier par d�faut maintenant
            //begin
              //TobCalendrier.Free;
              //TobCalendrier := nil;
            //end;
{$ENDIF !PLUGIN}
        finally
          Ferme(QQ);
          QQ := nil;
        end;
      end;

      if (TobCalendrier = nil) or ((TobCalendrier <> nil) and (TobCalendrier.Detail.count = 0)) then
        // Soit il n'y a pas de calendrier standard et on va chercher le calendrier par d�faut
      begin
        sStandCalend := GetParamSocSecur('SO_AFSTANDCALEN', '');
        if (sStandCalend <> '') then
        begin
          try
            sReq := 'SELECT * FROM CALENDRIER WHERE ACA_STANDCALEN="' + sStandCalend
              + '" AND ACA_RESSOURCE="***" AND ACA_SALARIE="***"';
            // SELECT * justifi� car on a besoin de tous les champs pour les controles en aval
            // et le nombre d'enregistrements pour une ressource est restreint
{$IFDEF PLUGIN}
            TobCalendrier := PlugIn.OpenSelectInCache(sReq); //AB-200609-
{$ELSE}
            QQ := OpenSQL(sReq, true,-1,'',true);
            if (not QQ.EOF) then
              TobCalendrier.LoadDetailDB('', '', '', QQ, false);
{$ENDIF !PLUGIN}
          finally
            Ferme(QQ);
            QQ := nil;
          end;
        end;
      end;

      if (TobCalendrier <> nil) and (TobCalendrier.Detail.count = 0) then
        // Si apr�s tout �a on n'a toujours pas de calendrier, on lib�re la TOB
      begin
        TobCalendrier.Free;
        TobCalendrier := nil;
      end;

    end;
  end;

  //
  // Calendrier Regle
  //
  // Attention : la variable bCalSpecif a pu �voluer depuis l'init pr�c�dente
  if (tob_Champs.GetValue('ARS_CALENSPECIF') = 'X') then
    bCalSpecif := true;

  if (TobCalendrierRegle = nil) or (AcbForcer = true) then
  begin
    TobCalendrierRegle.Free;
    TobCalendrierRegle := nil;
{$IFNDEF PLUGIN}
    TobCalendrierRegle := Tob.Create('CALENDRIERREGLE', nil, -1);
    TobCalendrierRegle.InitValeurs(FALSE);
{$ENDIF !PLUGIN}
    if bCalSpecif then
    begin
      try
        // C'est important de laisser l'ordre d�croissant par date d'effet, car on dispose ainsi du calendrier le
        // plus r�cent en premier
        sReq := 'SELECT * FROM CALENDRIERREGLE WHERE ACG_STANDCALEN="' + tob_Champs.GetValue('ARS_STANDCALEN')
          + '" AND ACG_RESSOURCE="' + tob_Champs.GetValue('ARS_RESSOURCE') + '" ORDER BY ACG_DATEEFFET DESC';
        // SELECT * justifi� car on a besoin de tous les champs pour les controles en aval
        // et le nombre d'enregistrements pour une ressource est restreint
{$IFDEF PLUGIN}
        TobCalendrierRegle := PlugIn.OpenSelectInCache(sReq); //AB-200609-
        if (TobCalendrierRegle = nil) or ((TobCalendrierRegle <> nil) and (TobCalendrierRegle.detail.count=0)) then
          bCalSpecif := false;
{$ELSE}
        QQ := OpenSQL(sReq, true,-1,'',true);
        if (not QQ.EOF) then
          TobCalendrierRegle.LoadDetailDB('', '', '', QQ, false)
        else
          bCalSpecif := false;
{$ENDIF !PLUGIN}
      finally
        Ferme(QQ);
        QQ := nil;
      end;
    end;

    if not bCalSpecif then
    begin
      try
        // C'est important de laisser l'ordre d�croissant par date d'effet, car on dispose ainsi du calendrier le
        // plus r�cent en premier
        sReq := 'SELECT * FROM CALENDRIERREGLE WHERE ACG_STANDCALEN="' + tob_Champs.GetValue('ARS_STANDCALEN')
          + '" AND ACG_RESSOURCE="***" ORDER BY ACG_DATEEFFET DESC';
        // SELECT * justifi� car on a besoin de tous les champs pour les controles en aval
        // et le nombre d'enregistrements pour une ressource est restreint
{$IFDEF PLUGIN}
        TobCalendrierRegle := PlugIn.OpenSelectInCache(sReq); //AB-200609-
{$ELSE}
        QQ := OpenSQL(sReq, true,-1,'',true);
        if (not QQ.EOF) then
          TobCalendrierRegle.LoadDetailDB('', '', '', QQ, false)
        else
        begin
          TobCalendrierRegle.Free;
          TobCalendrierRegle := nil;
        end;
{$ENDIF !PLUGIN}
      finally
        Ferme(QQ);
      end;
    end;
  end;

  //
  // Absence des salari�s
  //
  if (AcbForcer = true) then
    giAbsencePaie := 0; // On force le rechargement des absences salari�
  if PaieUtilisee then
  begin
    ChargeAbsencesSalarie(AcbForcer);
  end;
end;
 
{function TAFO_Ressource.AUnCalendrier : Boolean;
begin
  if (TobCalendrier = nil) then
  begin
    ChargeCalendriers(true);
    if (TobCalendrier = nil) then
      result := False
    else
      result := True;
  end
  else
    result := True;
end;}

(******************************************************************************)
// ChargeAbsencesSalarie : Charge les absences de la ressource depuis la table de la paie
//
//
// entr�e : AcbForcer � true pour �craser les pr�c�dents
(******************************************************************************)
procedure TAFO_Ressource.ChargeAbsencesSalarie(AcbForcer: boolean);
var
  sReq: string;
  QQ: TQuery;
begin

  if (TobAbsenceSalarie <> nil) and not AcbForcer then
    exit;

  TobAbsenceSalarie.Free;
  TobAbsenceSalarie := nil;

  try
    sReq := 'SELECT PCN_SALARIE,PCN_TYPECONGE,PCN_DATEDEBUTABS,PCN_DATEFINABS,' +
      'PCN_TYPEMVT,PCN_ORDRE,PCN_JOURS,PCN_HEURES,PCN_DEBUTDJ,PCN_FINDJ,' +
      'PMA_LIBELLE,PMA_ABREGE,PMA_EDITION,PMA_PRISTOTAL FROM ABSENCESALARIE ' +

      //C.B 13/04/2006
      // ajout suite demande de la paie
      'LEFT JOIN MOTIFABSENCE ON ##PMA_PREDEFINI## PMA_MOTIFABSENCE=PCN_TYPECONGE ' +
      'WHERE PCN_SALARIE="' + tob_Champs.GetValue('ARS_SALARIE') +
	    //C.B 13/04/2006
  	  // ne pas ternir compte des absences annul�es
    	'" AND PCN_ETATPOSTPAIE <> "NAN" ' +       // PL le 19/04/06 : oublie guillemets, ce commentaire est � virer apr�s v�rif

      //                  '" AND ((PCN_DATEDEBUTABS>="'+USDateTime(DateDeb-1)+'" '+
    //                  'AND PCN_DATEDEBUTABS<="'+USDateTime(DateFin)+'") '+ //PT29REP DateDeb-1 : Cas abs fin de mois anterieur, et 1er jour mois en cours repos salari�
    //                  'OR (PCN_DATEFINABS>="'+USDateTime(DateDeb-1)+'" '+
    //                  'AND PCN_DATEFINABS<="'+USDateTime(DateFin)+'" )) '+
		// PL le 19/04/06 : guillemets en trop, ce commentaire est � virer apr�s v�rif
    ' AND ((PCN_TYPEMVT="ABS" AND PCN_SENSABS="-") OR (PCN_TYPECONGE="PRI" AND PCN_TYPEMVT="CPA" AND PCN_MVTDUPLIQUE="-" )) ' + //PT35REP Ajout AND PCN_SENSABS="-"
    //            'AND PMA_EDITION="X" '+ // PL le 08/11/04 : vu avec la paie ce jour : ne sert � rien, juste pour voir 'absence dans les �edin
    'ORDER BY PCN_DATEDEBUTABS,PCN_DATEFINABS';
{$IFDEF PLUGIN}
    TobAbsenceSalarie := PlugIn.OpenSelectInCache(sReq); //AB-200609-
{$ELSE}
    TobAbsenceSalarie := Tob.Create('Les_Absences_Salarie', nil, -1);
    TobAbsenceSalarie.InitValeurs(FALSE);
    QQ := OpenSQL(sReq, true,-1,'',true);
    if (not QQ.EOF) then
      TobAbsenceSalarie.LoadDetailDB('', '', '', QQ, false);
{$ENDIF !PLUGIN}
  finally
    Ferme(QQ);
    QQ := nil;
  end;
end;

(******************************************************************************)
// AbsenceSalarieD1Date : cherche si une date est dans un intervalle d'absence de la
// ressource courante dans la table ABSENCESALARIE de la paie
//
//
// entr�e : AcdDateTestee : date � tester
// sortie : renvoie la tob de la ligne d'absence si elle est trouv�e, sinon nil
(******************************************************************************)

function TAFO_Ressource.AbsenceSalarieD1Date(AcdDateTestee: TDateTime): TOB;
var
  TOBDet: TOB;
  i: integer;
begin
  Result := nil;
  if PaieUtilisee then
  begin
    for i := 0 to (TobAbsenceSalarie.Detail.count - 1) do
      // Sur toutes les absences du salarie saisies dans la paie
    begin
      TOBDet := TobAbsenceSalarie.Detail[i];
      if (AcdDateTestee >= TOBDet.GetValue('PCN_DATEDEBUTABS')) and (AcdDateTestee <= TOBDet.GetValue('PCN_DATEFINABS')) then
      begin
        Result := TOBDet;
        break;
      end;
    end;
  end;
end;

destructor TAFO_Ressource.Destroy;
begin
  gsUniteValo := '';
  tob_Champs.Free;      
  Article.Free;
  TobRessourcePR.Free;
  TobCalendrier.Free;
  TobCalendrierRegle.Free;
  TobAbsenceSalarie.Free;
  TobAbsencesParPeriode.Free;
  TobDisposParPeriode.Free;
//{$IFDEF AFFAIRE}
  gobj_JourFerie.Free;
//{$ENDIF}
  inherited;
end;

(******************************************************************************)
// TempsAnnuelRessource : donne le temps de travail effectif de la ressource
//                        dans l'unite de saisie d'activite
//
// entr�e : Type d'activite : REA ou PLA, Date de d�but et Date de fin d'analyse
(******************************************************************************)

function TAFO_Ressource.TempsAnnuelRessource(AcsTypeActivite: string; AcdDateDebut, AcdDateFin: TDateTime): double;
var
  sSelectR: string;
  QSelectR: TQuery;
  TobQte: TOB;
  i: integer;
  dQteCourante: double;
  sUniteCourante: string;

begin
  Result := 0;
  QSelectR := nil;
  if (tob_Champs = nil) then
    exit;

  sSelectR := 'SELECT SUM(ACT_QTE) AS ACT_QTE, ACT_UNITE FROM ACTIVITE WHERE ACT_TYPEACTIVITE="' + AcsTypeActivite
    + '" AND ACT_RESSOURCE="' + tob_Champs.GetValue('ARS_RESSOURCE')
    + '" AND ACT_DATEACTIVITE>="' + UsDateTime(AcdDateDebut)
    + '" AND ACT_DATEACTIVITE<="' + UsDateTime(AcdDateFin)
    + '" AND ACT_TYPEARTICLE="PRE" AND ACT_ACTIVITEEFFECT="X" GROUP BY ACT_UNITE';

  TobQte := TOB.Create('', nil, -1);
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);
    if not QSelectR.EOF then
      // Si la s�lection n'est pas vide
    begin

      TobQte.LoadDetailDB('Qte par an', '', '', QSelectR, False);

      for i := 0 to TobQte.Detail.count - 1 do
      begin
        sUniteCourante := TobQte.Detail[i].GetValue('ACT_UNITE');
        dQteCourante := TobQte.Detail[i].GetValue('ACT_QTE');
        Result := Result + AFConversionUnite(sUniteCourante, gsUniteActivite, dQteCourante);
      end;
    end;
  finally
    Ferme(QSelectR);
    TobQte.Free;
  end;
end;

(******************************************************************************)
// FonctionDeLaRessource
// Entr�e : Date � laquelle on cherche la fonction
//
// Si la date d'entr�e est vide, la fonction renvoi la liste des fonctions rang�es
// dans l'ordre chronologique, l'indice 0 �tant la plus r�cente et l'indice 3 la plus
// ancienne
// Si la date d'entr�e est saisie, la fonction renvoi une liste avec pour seul �l�ment
// la fonction � la date d'entr�e (indice 0)
(******************************************************************************)

function TAFO_Ressource.FonctionDeLaRessource(AcdDateDeFonction: TDateTime): TStringList;
var
  vslFonctions, sDates: TStringList;
  i, j, k: integer;
begin
  Result := nil;

  vslFonctions := TStringList.Create;
  sDates := TStringList.Create;

  try
    sDates.Add(tob_Champs.GetValue('ARS_DATEFONC1'));
    vslFonctions.Add(tob_Champs.GetValue('ARS_FONCTION1'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEFONC2'));
    vslFonctions.Add(tob_Champs.GetValue('ARS_FONCTION2'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEFONC3'));
    vslFonctions.Add(tob_Champs.GetValue('ARS_FONCTION3'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEFONC4'));
    vslFonctions.Add(tob_Champs.GetValue('ARS_FONCTION4'));

    // on trie la liste dans l'ordre des dates
    for k := 0 to 3 do
      for i := 3 downto 0 do
        for j := 3 downto 0 do
        begin
          if isvaliddate(sDates[i]) and isvaliddate(sDates[j]) then
            if (i < j) and (strtodate(sDates[i]) < strtodate(sDates[j])) then
            begin
              vslFonctions.exchange(i, j);
              sDates.exchange(i, j);
              break;
            end;
        end;

    if (AcdDateDeFonction = 0) or (AcdDateDeFonction = iDate1900) then
      // Si aucune date n'est fournie en entr�e, on renvoie la liste des 4 derni�res
      // fonctions pratiqu�es tri�es de la plus rescente=0 � la plus ancienne=3
    begin
      Result := vslFonctions;
      exit;
    end;

    // Une date d'entr�e a �t� fournie, on cherche donc la fonction � la date juste inf�rieure
    // � cette date entr�e
    try
      for i := 0 to 3 do
      begin
        if (AcdDateDeFonction >= strtodate(sDates[i])) then
        begin
          Result := TStringList.Create;
          TStringList(Result).Add(vslFonctions[i]);
          break;
        end;
      end;

    finally
      vslFonctions.Free;
    end;

  finally
    sDates.free;
  end;
end;

(******************************************************************************)
// PrixCourant
// Entr�e : Date � laquelle on cherche la prix
//          Type de prix recherch� (PR ou PV)
//          pour le PV : HT ou TTC
//
// Si la date d'entr�e est vide, la fonction renvoi la liste des prix rang�s
// dans l'ordre chronologique, l'indice 0 �tant le plus r�cent et l'indice 3 le plus
// ancien
// Si la date d'entr�e est saisie, la fonction renvoi une liste avec pour seul �l�ment
// le prix � la date d'entr�e (indice 0)
(******************************************************************************)

function TAFO_Ressource.PrixCourant(AcdDateDePrix: TDateTime; AcsTypePrix: string; AcbPVHT: boolean = true): TStringList;
var
  vslPrix, sDates: TStringList;
  i, j, k: integer;
begin
  Result := nil;

  vslPrix := TStringList.Create;
  sDates := TStringList.Create;

  try
    sDates.Add(tob_Champs.GetValue('ARS_DATEPRIX'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEPRIX2'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEPRIX3'));
    sDates.Add(tob_Champs.GetValue('ARS_DATEPRIX4'));
    if (AcsTypePrix = 'R') then
      // Prix de revient
    begin
      vslPrix.Add(tob_Champs.GetValue('ARS_TAUXREVIENTUN'));
      vslPrix.Add(tob_Champs.GetValue('ARS_TAUXREVIENTUN2'));
      vslPrix.Add(tob_Champs.GetValue('ARS_TAUXREVIENTUN3'));
      vslPrix.Add(tob_Champs.GetValue('ARS_TAUXREVIENTUN4'));
    end
    else
      // Prix de vente
    begin
      if AcbPVHT then
        // HT
      begin
        vslPrix.Add(tob_Champs.GetValue('ARS_PVHT'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVHT2'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVHT3'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVHT4'));
      end
      else
        // TTC
      begin
        vslPrix.Add(tob_Champs.GetValue('ARS_PVTTC'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVTTC2'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVTTC3'));
        vslPrix.Add(tob_Champs.GetValue('ARS_PVTTC4'));
      end;
    end;

    // on trie la liste dans l'ordre des dates
    for k := 0 to 3 do
      for i := 3 downto 0 do
        for j := 3 downto 0 do
        begin
          if isvaliddate(sDates[i]) and isvaliddate(sDates[j]) then
            if (i < j) and (strtodate(sDates[i]) < strtodate(sDates[j])) then
            begin
              vslPrix.exchange(i, j);
              sDates.exchange(i, j);
              break;
            end;
        end;

    if (AcdDateDePrix = 0) or (AcdDateDePrix = iDate1900) then
      // Si aucune date n'est fournie en entr�e, on renvoie la liste des 4 derniers
      // prix tri�s du plus rescent=0 au plus ancien=3
    begin
      Result := vslPrix;
      exit;
    end;

    // Une date d'entr�e a �t� fournie, on cherche donc le prix � la date juste inf�rieure
    // � cette date entr�e
    try
      for i := 0 to 3 do
      begin
        if (AcdDateDePrix >= strtodate(sDates[i])) then
        begin
          Result := TStringList.Create;
          TStringList(Result).Add(vslPrix[i]);
          break;
        end;
      end;

    finally
      vslPrix.Free;
    end;

  finally
    sDates.free;
  end;
end;

(******************************************************************************)
// AssocieArticle
// Entr�e : Code Article � associer
//
// Associe la TOB du code article en entree � la ressource courante
// Si le code article est vide, associe l'article par defaut de la ressource
// ATTENTION : supprime l'ancien article associe
(******************************************************************************)
{$IFDEF AFFAIRE} //mcd 04/06/03 mis en ifdef affaire .. appeler depuis activit�. intuile en paie

function TAFO_Ressource.AssocieArticle(AcsCodeArticle: string): boolean;
var
  tobArticle: TOB;
begin
  Result := false;
  // on reinitialise l'unite de temps de valorisation avec l'unite de la ressource
  gsUniteValo := tob_Champs.GetValue('ARS_UNITETEMPS');

  tobArticle := Tob.Create('ARTICLE', nil, -1);
  tobArticle.InitValeurs(FALSE);
  if (AcsCodeArticle = '') then
    // s'il n'y a pas d'article associ�, on prend l'article de la ressource par defaut
    tobArticle.SelectDB('"' + tob_Champs.GetValue('ARS_ARTICLE') + '"', nil);
//else
//Modif FV    TrouverArticleSQL_GI(false, AcsCodeArticle, tobArticle, '', GetParamSocSecur('SO_AFFRAISCOMPTA', False)); // PL le 10/03/04 : on ne ram�ne les compl�ments que pour les frais en compta

  // Si on n'a toujours pas d'article associ�, on ne peut rien faire
  if (tobArticle = nil) then
    exit;

  if (tobArticle.GetValue('GA_ARTICLE') = '') then
  begin
    tobArticle.Free;
    exit;
  end;

  // Sinon, on associe le nouvel article
  if (Article <> nil) then
    Article.Free;
  Article := tobArticle;
  Result := true;
end;
{$ENDIF}

(******************************************************************************)
// AssocieRessourcePR
// Entr�e : Code Ressource
// AcbForcer : forcer la mise � jour
//
// Associe la TOB d�finie par les valeurs en entree � la ressource courante
// la TOB contient 1 ou plusieurs occurrences suivant les fonctions et le rang
(******************************************************************************)

function TAFO_Ressource.AssocieRessourcePR(AcsCodeRessource: string; AcbForcer: boolean): boolean;
var
  QSelectR: TQuery;
  sSelectR: string;
begin
  if (TobRessourcePR <> nil) and (AcbForcer = False) then
  begin
    Result := true;
    exit;
  end;

  if (TobRessourcePR = nil) then
    TobRessourcePR := TOB.Create('Les RessourcePRs', nil, -1)
  else
  begin
    TobRessourcePR.ClearDetail;
    TobRessourcePR.InitValeurs(False);
  end;

  // on selectionne tous les PR ou PV (suivant le type valo) par fonctions/rang correspondant � la ressource courante
  sSelectR := 'SELECT ARP_TYPEVALO, ARP_RESSOURCE, ARP_FONCTION, ARP_RANG, ARP_FAMILLENIV1, ARP_FAMILLENIV2, ARP_FAMILLENIV3, ARP_ARTICLE, ARP_FORMULE , ARP_DEPARTEMENT FROM RESSOURCEPR WHERE ARP_RESSOURCE="'
    + AcsCodeRessource + '"';

  QSelectR := nil;
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);
    if not QSelectR.EOF then
      TobRessourcePR.LoadDetailDB('', '', '', QSelectR, false);

    Result := true;
  finally
    Ferme(QSelectR);
  end;
end;

(******************************************************************************)
//
// PRRessource : renvoie le prix de revient de la ressource
//
// Entr�e : Date du prix cherch�
//          TOB Article pour lequel on fait cette recherche
//          ou le code Article
//          Code de l'affaire li�e
//
// Si une ligne de PR dans la table RESSOURCEPR correspond � l'article en entr�e
// suivant l'ordre de priorit� suivant
//                                     - identifiant article
//                                     - Familles d'article 1,2 et 3
//                                     - Familles d'article 1 et 2
//                                     - Familles d'article 1 et 3
//                                     - Familles d'article 2 et 3
//                                     - Familles d'article 1
//                                     - Familles d'article 2
//                                     - Familles d'article 3
//                                     - D�partement
// on applique la formule de calcul du PR associ�e � la ligne courante
// sinon,
// on lit le taux de revient unitaire de la table RESSOURCE
//
(******************************************************************************)

function TAFO_Ressource.CalculPrixRessource(AcdDate: TDateTime; AcsTypePrix: string; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
var
  sArticle: string;
  sFam123, sFam12, sFam13, sFam23, sFam1, sFam2, sFam3: string;
  sDep, sFormuleDep: string;
  {$IFDEF VER150}
  sFormule: hString;
  {$ELSE}
  sFormule: string;
  {$ENDIF}
  vResultat, v2: variant;
  dCoeffConvert: double;
{$IFDEF AFFAIRE}
  TOBAffaire: TOB;
{$ENDIF}
	TT: TOB;
  ListePrix: TStringList;
begin
  Result := 0;
  sArticle := '';
  sFam123 := '';
  sFam12 := '';
  sFam13 := '';
  sFam23 := '';
  sFam1 := '';
  sFam2 := '';
  sFam3 := '';
  sDep := '';
  sFormuleDep := '';
  sFormule := '';
  gDatePrix := AcdDate;

  if (ActobArticle = nil) then
  begin
{$IFDEF AFFAIRE} //mcd 04/03/03
    AssocieArticle(AcsCodeArticle);
{$ENDIF}
  end
  else
  begin
    if (Article <> nil) then
      Article.Free;

    Article := Tob.Create('ARTICLE', nil, -1);
    Article.Dupliquer(ActobArticle, true, true, false);
  end;

{$IFDEF AFFAIRE}
  if (AcsCodeAffaire <> '') then
  begin
    TobAffaire := Tob.Create('AFFAIRE', nil, -1);
    try
      if AFRemplirTOBAffaire(AcsCodeAffaire, TobAffaire, ActobAffaires) then
        sDep := TobAffaire.GetValue('AFF_DEPARTEMENT');

    finally
      TobAffaire.Free;
    end;
  end;
{$ENDIF}

  if (Article <> nil) or (sDep <> '') then
  begin
    if AssocieRessourcePR(tob_Champs.GetValue('ARS_RESSOURCE'), false) then
    begin
      // on cherche si une ligne de PR correspond � l'article en entr�e, pour la ressource courante
      // Si aucune ligne de correspond, on cherche si les trois famille de l'article en entr�e correspondent
      // aux trois familles d'une ligne PR ou
      // que les familles correspondent deux par deux ou une � une
      // Si rien ne correspond, on cherche si le d�partement en entr�e correspond au d�partement d'une ligne PR
      TT := TobRessourcePR.FindFirst(['ARP_TYPEVALO', 'ARP_RESSOURCE'], [AcsTypePrix, tob_Champs.GetValue('ARS_RESSOURCE')], TRUE);
      while (TT <> nil) and (sArticle = '') do
      begin
        if (Article <> nil) then
        begin
          if (TT.GetValue('ARP_ARTICLE') = Article.GetValue('GA_ARTICLE')) then
            sArticle := TT.GetValue('ARP_FORMULE');

          if ((TT.GetValue('ARP_FAMILLENIV1') <> '')
            and (TT.GetValue('ARP_FAMILLENIV2') <> '')
            and (TT.GetValue('ARP_FAMILLENIV3') <> '')) then
            if ((TT.GetValue('ARP_FAMILLENIV1') = Article.GetValue('GA_FAMILLENIV1'))
              and (TT.GetValue('ARP_FAMILLENIV2') = Article.GetValue('GA_FAMILLENIV2'))
              and (TT.GetValue('ARP_FAMILLENIV3') = Article.GetValue('GA_FAMILLENIV3'))) then
              sFam123 := TT.GetValue('ARP_FORMULE');

          if ((TT.GetValue('ARP_FAMILLENIV1') <> '') and (TT.GetValue('ARP_FAMILLENIV2') <> '')) then
            if (TT.GetValue('ARP_FAMILLENIV1') = Article.GetValue('GA_FAMILLENIV1'))
              and (TT.GetValue('ARP_FAMILLENIV2') = Article.GetValue('GA_FAMILLENIV2')) then
              sFam12 := TT.GetValue('ARP_FORMULE');

          if ((TT.GetValue('ARP_FAMILLENIV1') <> '') and (TT.GetValue('ARP_FAMILLENIV3') <> '')) then
            if (TT.GetValue('ARP_FAMILLENIV1') = Article.GetValue('GA_FAMILLENIV1'))
              and (TT.GetValue('ARP_FAMILLENIV3') = Article.GetValue('GA_FAMILLENIV3')) then
              sFam13 := TT.GetValue('ARP_FORMULE');

          if ((TT.GetValue('ARP_FAMILLENIV2') <> '') and (TT.GetValue('ARP_FAMILLENIV3') <> '')) then
            if (TT.GetValue('ARP_FAMILLENIV2') = Article.GetValue('GA_FAMILLENIV2'))
              and (TT.GetValue('ARP_FAMILLENIV3') = Article.GetValue('GA_FAMILLENIV3')) then
              sFam23 := TT.GetValue('ARP_FORMULE');

          if (TT.GetValue('ARP_FAMILLENIV1') <> '') then
            if (TT.GetValue('ARP_FAMILLENIV1') = Article.GetValue('GA_FAMILLENIV1')) then
              sFam1 := TT.GetValue('ARP_FORMULE');

          if (TT.GetValue('ARP_FAMILLENIV2') <> '') then
            if (TT.GetValue('ARP_FAMILLENIV2') = Article.GetValue('GA_FAMILLENIV2')) then
              sFam2 := TT.GetValue('ARP_FORMULE');

          if (TT.GetValue('ARP_FAMILLENIV3') <> '') then
            if (TT.GetValue('ARP_FAMILLENIV3') = Article.GetValue('GA_FAMILLENIV3')) then
              sFam3 := TT.GetValue('ARP_FORMULE');

        end;

        if (sDep <> '') then
        begin
          if (TT.GetValue('ARP_DEPARTEMENT') = sDep) then
            sFormuleDep := TT.GetValue('ARP_FORMULE');
        end;

        TT := TobRessourcePR.FindNext(['ARP_TYPEVALO', 'ARP_RESSOURCE'],
          [AcsTypePrix, tob_Champs.GetValue('ARS_RESSOURCE')],
          TRUE);
      end;

      if (sArticle <> '') then
        // on a trouve une ligne de PR correspondant � l'article en entr�e
        // la formule � appliquer est stock�e dans la variable sArticle
        sFormule := sArticle
      else
        if (sFam123 <> '') then
        sFormule := sFam123
      else
        if (sFam12 <> '') then
        sFormule := sFam12
      else
        if (sFam13 <> '') then
        sFormule := sFam13
      else
        if (sFam23 <> '') then
        sFormule := sFam23
      else
        if (sFam1 <> '') then
        sFormule := sFam1
      else
        if (sFam2 <> '') then
        sFormule := sFam2
      else
        if (sFam3 <> '') then
        sFormule := sFam3
      else
        if (sDep <> '') then
        sFormule := sFormuleDep;

    end;
  end;

  if (sFormule <> '') then
    // on a trouv� un article ou une combinaison de famille d'articles correspondant
    // � l'article en entr�e ou un d�partement correspondant correspondant au d�partement en entr�e
    // Il faut appliquer cette formule pour obtenir le PR
  begin
    V_PGI.ErreurFormule := true;
    sFormule := '{' + sFormule + '}';
    vResultat := 0;
    if TestFormule(sFormule) then
    begin
      sFormule := '{"#.###,0"' + sFormule + '}'; //mcd 09/12/02
      vResultat := GFormule(sFormule, DonneesFormuleP, nil, 1);
      // PL le 14/01/03 : gestion des erreurs
      if (vResultat <> 'Erreur') and (vResultat <> '') then
      begin
        try
          v2 := VarAsType(vResultat, varDouble);
          Result := v2;
        except
          Result := 0;
        end;
      end;
    end;
  end
  else
    // on n'a pas trouv� d'article ni de combinaison de famille correspondant
    // � l'article en entr�e ni de d�partement, on prend le champ TAUXREVIENTUN de la ressource
    // ou PVHT ou TTC suivant le type de valo
  begin
    dCoeffConvert := 1;
    ListePrix := PrixCourant(AcdDate, AcsTypePrix, gbPVHT);
    if (gsUniteValo <> tob_Champs.GetValue('ARS_UNITETEMPS')) then
      // Si l'unite de valorisation est diff�rente de l'unite de la ressource
      // on doit convertir en sortie
    begin
      dCoeffConvert := AFConversionUnite(tob_Champs.GetValue('ARS_UNITETEMPS'), gsUniteValo, 1);
      if dCoeffConvert = 0 then
        dCoeffConvert := 1;
    end;

    if (ListePrix <> nil) then
    begin
      if (ListePrix.Count <> 0) then
        Result := Valeur(ListePrix[0]) / dCoeffConvert;
      ListePrix.Free;
    end;
  end;

end;

(******************************************************************************)
// ExisteUnArticleDeValo : renvoie true si il existe une valorisation personnalis�e
//                         de la ressource pour l'article pass� en param�tre
//
// Entr�e :     AcsTypeValo type de valorisation
//              AcsArticle article � tester
//
(******************************************************************************)

function TAFO_Ressource.ExisteUnArticleDeValo(AcsTypeValo, AcsArticle: string): boolean;
var
  T: TOB;
begin
  Result := false;
  if (AcsArticle = '') or (AcsTypeValo = '') then
    exit;

  if AssocieRessourcePR(tob_Champs.GetValue('ARS_RESSOURCE'), false) then
  begin
    T := TobRessourcePR.FindFirst(['ARP_TYPEVALO', 'ARP_RESSOURCE', 'ARP_ARTICLE'], [AcsTypeValo, tob_Champs.GetValue('ARS_RESSOURCE'), AcsArticle], TRUE);
    if (T <> nil) then
      Result := true;
  end;
end;

(******************************************************************************)
// DonneesFormuleP : renvoie un variant contenant la valeur du champ de la table
//                      RESSOURCE ou ARTICLE suivant le ChampFormule pass� en entr�e
//
// Entr�e : ChampFomule contenant le code d�fini dans la formule correspondant
//          � un champ soit dans la table RESSOURCE, soit dans la table ARTICLE
(******************************************************************************)

function TAFO_Ressource.DonneesFormuleP(AcsChampFormule: Hstring): variant;
var
  sTypePrix: string;
  dTauxUnit, dTauxUnitPres, dCoeffConvert, dCoeffConvert2: double;
  ListePrix: TStringList;
begin
  ListePrix := nil;
  dTauxUnit := 0;
  dTauxUnitPres := 0;
  dCoeffConvert := 1; //dCoeffConvert2 := 1;
  // On d�termine en quelle unit� on traduit : soit dans l'unit� de la ressource, soit dans l'unit� de l'article associ�
  if (Article <> nil) then
  begin
    if (AcsChampFormule = 'TAUXREVIENT') or (AcsChampFormule = 'TAUXVENTE') then
    begin
      sTypePrix := 'R';
      if (AcsChampFormule = 'TAUXVENTE') then
        sTypePrix := 'V';
      ListePrix := PrixCourant(gDatePrix, sTypePrix, gbPVHT);
    end;

    if (gsUniteValo = tob_Champs.GetValue('ARS_UNITETEMPS')) then
      // Unit� de la ressource
    begin
      dTauxUnit := tob_Champs.GetValue('ARS_TAUXUNIT');

      if (gsUniteValo = Article.GetValue('GA_QUALIFUNITEVTE')) then
        // Si l'article est exprim� dans la meme unit� que la ressource
        dTauxUnitPres := Article.GetValue('GA_PMRP')
      else
        // sinon, on traduit de l'unite de l'article vers l'unite de valorisation (ressource)
      begin
        dCoeffConvert2 := AFConversionUnite(Article.GetValue('GA_QUALIFUNITEVTE'), gsUniteValo, 1);
        if dCoeffConvert2 = 0 then
          dCoeffConvert2 := 1;
        dTauxUnitPres := Article.GetValue('GA_PMRP') / dCoeffConvert2;
      end;
    end
    else
      if (gsUniteValo = Article.GetValue('GA_QUALIFUNITEVTE')) then
      // Unit� de l'article
    begin
      // l'unite de la ressource est forcement differente de l'unite de valorisation (article), sinon on serait pass� dans le
      // premier test
      // on convertit donc la ressource dans l'unite de valorisation (article)
      dCoeffConvert := AFConversionUnite(tob_Champs.GetValue('ARS_UNITETEMPS'), gsUniteValo, 1);
      if dCoeffConvert = 0 then
        dCoeffConvert := 1;
      dTauxUnit := tob_Champs.GetValue('ARS_TAUXUNIT') / dCoeffConvert;

      dTauxUnitPres := Article.GetValue('GA_PMRP');
    end
    else
      // autre unit� (unit� d'activit� par exemple)
    begin
      // Tout est converti dans l'unit� de valorisation
      dCoeffConvert := AFConversionUnite(tob_Champs.GetValue('ARS_UNITETEMPS'), gsUniteValo, 1);
      if (dCoeffConvert = 0) then
        dCoeffConvert := 1;
      dTauxUnit := tob_Champs.GetValue('ARS_TAUXUNIT') / dCoeffConvert;

      dCoeffConvert2 := AFConversionUnite(Article.GetValue('GA_QUALIFUNITEVTE'), gsUniteValo, 1);
      if (dCoeffConvert2 = 0) then
        dCoeffConvert2 := 1;
      dTauxUnitPres := Article.GetValue('GA_PMRP') / dCoeffConvert2;
    end;
  end;

  Result := 1;
  // ATTENTION, si modif de cette fct, faire idem dans TOM_RessourcePR (UtomRessource)
  AcsChampFormule := AnsiUppercase(AcsChampFormule);
  if (AcsChampFormule = 'TAUXUNITRES') then
    result := dTauxUnit
  else
    if (AcsChampFormule = 'FRAISGEN1') then
    result := tob_Champs.GetValue('ARS_TAUXFRAISGEN1')
  else
    if (AcsChampFormule = 'FRAISGEN2') then
    result := tob_Champs.GetValue('ARS_TAUXFRAISGEN2')
  else
    if (AcsChampFormule = 'COEFMETIER') then
    result := tob_Champs.GetValue('ARS_COEFMETIER')
  else
    if (AcsChampFormule = 'TAUXREVIENT') or (AcsChampFormule = 'TAUXVENTE') then
  begin
    if (ListePrix <> nil) then
    begin
      if (ListePrix.Count <> 0) then
        Result := Valeur(ListePrix[0]) / dCoeffConvert;
      ListePrix.Free;
    end;
  end
  else
    if (AcsChampFormule = 'TAUXPATRON') then
    result := tob_Champs.GetValue('ARS_TAUXCHARGEPAT')
  else
  begin
    // traitement des zones articles
    if ((AcsChampFormule = 'TAUXUNITPRES') or (AcsChampFormule = 'FRAISGENPRES')) then
    begin
      if (AcsChampFormule = 'TAUXUNITPRES') then
        result := dTauxUnitPres
      else
        if (Article <> nil) then
        if (AcsChampFormule = 'FRAISGENPRES') then
          result := Article.GetValue('GA_COEFFG');
    end;
  end;
end;

(******************************************************************************)
// PRRessource : renvoie le prix de revient de la ressource
//
//
(******************************************************************************)

function TAFO_Ressource.PRRessource(AcdDate: TDateTime; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
begin
  Result := CalculPrixRessource(AcdDate, 'R', ActobArticle, ActobAffaires, AcsCodeArticle, AcsCodeAffaire);
end;

(******************************************************************************)
// PVRessource : renvoie le prix de vente de la ressource
//
// Entr�e : booleen indiquant si c'est le HT = True ou le TTC = False que l'on
// veut en sortie
//
(******************************************************************************)

function TAFO_Ressource.PVRessource(AcdDate: TDateTime; AcbHT: boolean; ActobArticle: TOB; ActobAffaires: TOB; AcsCodeArticle: string; AcsCodeAffaire: string = ''): double;
//var
//dCoeffConvert:double;
begin
  // on prend comme r�f�rence le PV HT ou TTC ?
  gbPVHT := AcbHT;

  Result := CalculPrixRessource(AcdDate, 'V', ActobArticle, ActobAffaires, AcsCodeArticle, AcsCodeAffaire);
  {Result := 0;
  if (gsUniteValo=tob_Champs.GetValue('ARS_UNITETEMPS')) then
     // Si l'unite de valorisation est la meme que l'unite de la ressource
     dCoeffConvert:=1
  else
     // Sinon on doit convertir en sortie
     begin
     dCoeffConvert := AFConversionUnite(tob_Champs.GetValue('ARS_UNITETEMPS'), gsUniteValo, 1);
     if dCoeffConvert=0 then dCoeffConvert :=  1;
     end;

  if (AcbHT = true) then
     // on veut le HT
     Result := tob_Champs.GetValue('ARS_PVHT') / dCoeffConvert
  else
     // on veut le TTC
     Result := tob_Champs.GetValue('ARS_PVTTC') / dCoeffConvert;
  }

end;

(******************************************************************************)
// RessourceDisponible : renvoie un booleen indiquant si la ressource est disponible
//                      � la date et heure entr�e
//
// Entr�e : Date et heure auxquelles on veut savoir si la ressource est disponible
//
// Il s'agit de la disponibilit� par rapport aux dates et heures de pr�sence
// (CDD, temps partiel, location...) normales de la ressource.
//
(******************************************************************************)

function TAFO_Ressource.RessourceDisponible(AcdDateHeureDemande: TDateTime): boolean;
var
  dDebutDispo: TDateTime;
  dFinDispo: TDateTime;
  sStandCalen: string;
  bCalenSpecif: boolean;
begin
  Result := False;

  dDebutDispo := tob_Champs.GetValue('ARS_DEBUTDISPO');
  dFinDispo := tob_Champs.GetValue('ARS_FINDISPO');
  sStandCalen := tob_Champs.GetValue('ARS_STANDCALEN');
  bCalenSpecif := tob_Champs.GetValue('ARS_CALENSPECIF');

  if (AcdDateHeureDemande < dDebutDispo)
    and (AcdDateHeureDemande >= dFinDispo) then
    // Si la date/heure fournie en entr�e n'est pas dans l'intervalle de
    // disponibilit� de la ressource, inutile d'aller voir plus en d�tail
    // la ressource n'est pas disponible
    exit
  else
    // en attendant les services de l'objet Gestion de calendrier, on renvoie vrai
    // si la date d'entr�e et comprise dans les dates de la ressource
    Result := true;

  // On va regarder si la date/heure d'entr�e est dans le calendrier li� � la ressource
  if (bCalenSpecif = false) then
    // Il ne s'agit pas d'un calendrier sp�cifique, on va lire le calendrier standard
    // dont le code est dans le champ STANDCALEN
  begin
  end
  else
    // On va lire le calendrier sp�cifique de la ressource
  begin
  end;
end;

(******************************************************************************)
//
// ListeCompetencesD1Ressource: renvoie une TStringList des comp�tences de la ressource
//
(******************************************************************************)

function TAFO_Ressource.ListeCompetencesD1Ressource: TStringList;
var
  sSelectR: string;
  QSelectR: TQuery;
  vslListCompet: TStringList;
  TobCompetRess: TOB;
  i: integer;
begin
  QSelectR := nil;
  Result := nil;

  sSelectR := 'SELECT ACR_COMPETENCE FROM COMPETRESSOURCE WHERE ACR_RESSOURCE="' + tob_Champs.GetValue('ARS_RESSOURCE') + '"';

  TobCompetRess := TOB.Create('', nil, -1);
  try
    QSelectR := OpenSQL(sSelectR, TRUE,-1,'',true);
    vslListCompet := TStringList.Create;

    TobCompetRess.LoadDetailDB('', '', '', QSelectR, true);
    for i := 0 to TobCompetRess.Detail.count - 1 do
    begin
      vslListCompet.Add(TobCompetRess.Detail[i].GetValue('ACR_RESSOURCE'));
    end;

  finally
    Ferme(QSelectR);
    TobCompetRess.Free;
  end;

  if (vslListCompet.Count <> 0) then
    Result := vslListCompet;

end;

end.
