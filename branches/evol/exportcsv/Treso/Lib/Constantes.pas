unit Constantes;

interface

const
  // Codes des applications
  CODEMODULE    = 'TRE'; {Tr�sorerie}
  CODEMODULECOU = 'COU'; {Pour les �critures sur comptes courants}
  CODEMODULECPT = 'CPT'; {Comptabilit�}
  CODEUNIQUE    = 'U@Q';
  CODEUNIQUEDEC = 'U@D';
  CODECIBREF    = '@ID';
  CODEOPCVM     = '@OP';
  CODESAISIE    = '@SX';
  CODEREPRISEVM = 'V�M'; {Code de reprise des OPCVM pour les champs TOP_USERCOMPTA et TOP_USERVBO}
  CODEICC       = 'C�C';
  CODEDUPLICAT  = 'DUP';
  CODECOURANTS  = 'C�C'; {Codes etablissement et guichet des comptes titres}
  CODETITRES    = 'T�T'; {Codes etablissement et guichet des comptes titres}
  CODEDOSSIERDEF= '000000';

  {Les cat�ogories de transaction}
  tca_OPCVM      = 'OPC';
  tca_CourtTerme = 'TCT';
  tca_MoyenTerme = 'TMT';
  tca_LongTerme  = 'TLT';
  tca_Negociable = 'TCN';

  {Code temporaire lors d'op�ration sur une table, en particulier pour la synchronisation}
  CODETEMPO = '&$�';
  {Codes Flux utilis�s lors des virements}
  CODETRANSACDEP = 'EQD';
  CODETRANSACREC = 'EQR';
  {Diff�rentes cha�nes entrant en compte dans la d�finition du code transaction}
  TRANSACIMPORT = 'ICP';
  TRANSACSAISIE = 'SAIS';
  TRANSACEQUI   = 'EQU';
  TRANSACVENTE  = 'VOP';
  TRANSACICC    = 'ICC';
  {Diff�rentes valeurs de E_TRESOSYNCHRO}
  ets_Rien    = 'RIE';
  ets_Synchro = 'SYN';
  ets_Pointe  = 'MOD';
  ets_Lettre  = 'LET';
  ets_Nouveau = 'CRE';
  ets_BqPrevi = 'BQP'; {Gestion des banques pr�visionnelles}

  {Type d'�tat}
  tye_TicketOpe = 'T';
  tye_OrdrePaie = 'O';
  tye_LettreCon = 'L';
  {Type de vente d'OPCVM}
  vop_CAMP     = 'CAM';
  vop_FIFO     = 'FIF';
  vop_Simple   = 'SIM';
  vop_Partiel  = 'PAR';
  vop_Autre    = 'AUT';
  vop_Supprime = 'SUP';

  {CodeFlux d'initialisation lors d'une r�initialisation de solde}
  CODEREGULARIS  = 'REI';
  {QualifOrigine d'initialisation lors d'une r�initialisation de solde}
  CODEREINIT = 'INI';
  {QualifOrigine des �critures synchronis�es}
  QUALIFCOMPTA = 'CTA';
  {QualifOrigine des �critures de Tr�sorerie}
  QUALIFTRESO = 'TRO';
  {CodeFlux temporaire pour la synchronisation}
  CODEIMPORT = '@#I';
  {Code frais dans la tablette TRTYPEFRAIS pour les frais sur OPCVM}
  CODEFRAISOPCVM = 'FRO';
  {Code Commissions dans la tablette TRTYPEFRAIS pour les frais sur OPCVM}
  CODEFCOMOPCVM = 'COO';
  {Code du compte d'attente dans BanqueCp}
  CODEATTENTEBQ = 'COMPTE@TTENTE';
  {Codes Banque et guichet sur les banques et agences d'attente}
  CODEATTENTE5  = 'XXAXX';
  {Code CIB pour les �critures de simulation}
  CODECIBSIMUL   = '999';
  {Code CIB pour les comptes courants}
  CODECIBCOURANT = '888';
  {Code CIB pour les comptes Titres}
  CODECIBTITRE   = '777';

  {Type de comptes bancaires : Tablette TRTYPECPTE}
  tcb_Titre    = 'TIT';
  tcb_Bancaire = 'BQE';
  tcb_Courant  = 'COU';
  {Clause WHERE sur BanqueCp en mode normal}
  BQCLAUSEWHERE = '(BQ_NATURECPTE = "" OR BQ_NATURECPTE IS NULL OR BQ_NATURECPTE = "' + tcb_Bancaire + '")';

  {Nom des tablettes sur BANQUECP}
  tcp_General  = 'TTBANQUECP';
  tcp_Tous     = 'TRBANQUECPALL';
  tcp_Bancaire = 'TRBANQUECP';

  {Nature des �critures de tr�sorerie}
  na_Realise    = 'R';
  na_Simulation = 'S';
  na_Prevision  = 'P';
  {Pour les comparatifs bug�taire}
  na_PrevSimul  = 'U'; {�critures de Treso pr�visionnelles consid�r�es comme budg�taires}
  na_PrevReal   = 'N'; {�critures de Compta pr�visionnelles et r�alis�es consid�r�es comme Normal}
  {Natures non utilis�es dans la bases, mais uniquement dans des Tobs d'affichage}
  na_Total      = 'T';
  na_Pointe     = 'B'; {B pour banque}
  na_Estime     = 'E';

  {Tag des fonctions pour un test sur les droits}
  dac_Integration  = 136201; {Tag du mul d'int�gration}

  {Nature des comptes g�n�raux}
  nc_Client = 0;
  nc_Fourni = 1;
  nc_Divers = 2;
  nc_Salari = 3;
  nc_Debite = 4;
  nc_Credit = 5;
  max_nature = 5; {Indice maxi des natures}
  nc_Erreur = 10;
  nc_BqCais = 11;
  nc_CouTit = 12;

  {Valeurs pour renseigner le champ TE8COMMISSION d'une �criture}
  suc_Commission = 'C';
  suc_AvecCom    = 'A';
  suc_SansCom    = 'S';
  {N'est pas utilis� dans TRECRITURE, mais permet de passer un param�tre se distinguant des
   trois cas ci-dessus � des routines}
  suc_Divers     = 'D';

  {Valeurs des classes de FLUX}
  cla_Reference  = 'REF';
  cla_Commission = 'COM';
  cla_Previ      = 'PRE';
  cla_Finance    = 'FIN';
  cla_ICC        = 'ICC';
  cla_Guide      = 'GUI';

  {Type d'appel aux fiches TomCib et TRMULCIB_TOF}
  tc_Reference  = 'Ref';
  tc_CIB        = 'Cib';

  {Type de calcul des frais}
  tcf_Niveau  = 'NIV';
  tcf_Tranche = 'TRA';

  {Liste des champs possibles sur lesquels peuvent porter les guides}
  tgu_CIB       = 'CIB';
  tgu_Libelle   = 'LIB';
  tgu_Libelle1  = 'LE1';
  tgu_Libelle2  = 'LE2';
  tgu_Libelle3  = 'LE3';
  tgu_Reference = 'REF';
  tgu_NumeroPie = 'NUM';


  //BASE DE CALCUL
  B30_365 	= 0 ;
  B30_360 	= 1 ;
  B30E_360 	= 2 ;
  BJUSTE_365 	= 3 ;
  BJUSTE_360 	= 4 ;
  BJUSTE_JUSTE	= 5 ;
  	//--------------
  //CALENDRIER
  CalendarWeekBound = 18264; // Valeur de date valide (01/01/1950) ;
  // un petit nombre en plus (<10) indique un jour de la semaine (1=lundi)
  CalendarEasterYear = 1960; // Ann�e pour les dates indiquant un d�calage par rapport � P�ques
  CalendarEasterBound = 22068; // Valeur de date valide (01/06/1960) ;
  {FQ 10546 : 21/01/08 : 1970 n'est pas une ann�e bissextile !! remplac� par 1972}
  CalendarClosedYear = 1972; // Ann�e pour stocker les jours ferm�s (m�me que tablette TTJOURFERIE pour les jours qui sont aussi f�ri�s)
  	//--------------
  //MESSAGES
  TrMessage: array[0..20] of string = (
{0}  'Un CIB est d�j� associ� � cette r�gle.'#13' Confirmez vous l''acc�s � la modification des crit�res ?;Q;YN;N;N',
{1}  'Voulez-vous sauvegarder les modifications effectu�es ?;Q;YN;N;N',
{2}  'Vous allez supprimer d�finitivement les informations. Confirmez vous l''op�ration ?;Q;YN;N;N',
{3}  'Vous devez renseigner le code %%;E;O;O;O',
{4}  'La date de d�part est post�rieure � la date de fin;E;O;O;O',
{5}  'Le compte g�n�ral %% n''a aucun RIB. Op�ration annul�e;E;O;O;O',
{6}  'Traitement effectu� avec succ�s;E;O;O;O',
{7}  'Traitement non effectu�;E;O;O;O',
{8}  'Vous devez s�lectionner un compte pivot pour pouvoir faire un �quilibrage automatique;E;O;O;O',
{9}  'Vous devez avoir au moins un compte g�n�ral;E;O;O;O',
{10} 'Le montant d''un virement doit �tre une valeur strictement positive;E;O;O;O',
{11} 'Le compte d''origine et celui de destination sont identiques;E;O;O;O',
{12} 'Un virement entre ces deux comptes existe d�j�, modifiez son montant au lieu de cr�er un autre virement;E;O;O;O',
{13} 'Le fichier %% existe d�ja, voulez-vous le remplacer ?;Q;YN;N;N',
{14} 'Vous allez annuler la validation des transactions. Confirmez vous l''op�ration ?;Q;YN;N;N',
{15} 'Vous allez �ditez des relev�s. Confirmez vous l''op�ration ?;Q;YN;N;N',
{16} 'R�cup�ration des conditions param�tr�es ?;Q;YN;N;N',
{17} 'Vous allez valider des transactions. Confirmez vous l''op�ration ?;Q;YN;N;N',
{18} 'Vous allez supprimer le virement de %% du compte $$. Confirmez vous l''op�ration ?;Q;YN;N;N',
{19} 'Erreur sur la cl� RIB.'#13' R�cup�ration de la cl� ?;Q;YN;N;N',
{20} 'Confirmez-vous le traitement ?;Q;YN;N;N');
   //--------------
   //TABLES
   //--------------
  trDateMini           = 2;
  //--------------
  //BORNES
  //--------------
  MAXNBJAMBES 	= 5 ;
  VERSEMENT    	= 'VERSEMENT';
  AGIOSINTERETS	= 'AGIOSINTERETS';
  TOMBEE        = 'REMBANTICIPE';

type
  {26/07/05 : FQ 10158 : Structure contenant la clef primaire de la table ECRITURE}
  TClefCompta = record
    Exo : string;
    Jal : string;
    dtC : TDateTime;
    Pce : Integer;
    Lig : Integer;
    Ech : Integer;
    Per : Integer; {17/11/06 : P�riode pour les �critures de bordereau}
    Qlf : string;
    NoD : string;{10/08/06 : Ajout du NoDossier}
  end;

  {FQ 10223 : gestion des erreurs lors de la cr�ation de d'�critures et de TrEcritures}
  TNatErreur = (NatErr_Exo, {L'exercice est vide ou n'est pas ouvert en comptabilit�}
                NatErr_Jal, {Impossible de r�cup�rer le journal dont le compte de contrepartie est le compte bancaire courant}
                NatErr_CIB, {Param�trage incomplet des CIB / Mode de r�glement}
                NatErr_Bqe, {Le code banque n'est pas renseign� dans la fiche banque}
                NatErr_Flx, {Code flux vide}
                NatErr_Gen, {Compte g�n�ral vide}
                NatErr_CoE, {Ecriture de commissions dans la Base}
                NatErr_Tva, {Param�trage incomplet de la Tva en comptabilit� => impossible de r�cup�rer le compte de contre-partie}
                NatErr_Cpt, {Erreur relev�e dans ULibEcriture.CIsValidLigneSaisie}
                NatErr_Int, {Impossible de supprimer une op�ration car elle est in�tgr�e en comptabilit�}
                NatErr_CGn, {Contrepartie non renseign� sur les TrEcriture}
                NatErr_VBO, {Transactions non valid�es BO => ne peuvent �tre int�gr�es en comptabilit�}
                NatErr_Ine
                );
  TMsgErreur  = set of TNatErreur;
  TCatErreur  = (CatErr_None, CatErr_CPT, CatErr_TRE, CatErr_COM);
  TCatErreurs = set of TCatErreur;
  TGroupeErr  = record
    TypeErreur : TCatErreurs;
    Commission : TMsgErreur;
    Ecriture   : TMsgErreur;
    TrEcriture : TMsgErreur;
    MsgCompta  : string;
  end;

  {19/05/05 : Pour savoir, dans la gestion des devises, dans quelle table r�cup�rer la devise}
  TCatSource = (sd_Aucun, sd_OPCVM, sd_Compte); 

  {FQ 10237 : Types pour les fiches de suivi}
  TypePeriod = (tp_1, tp_7, tp_15, tp_30);
  {dsGroupe doit �tre le dernier ou suivi de toute fiche ne faisant pas appel � TofDetail.
   Inversement, dsOPCVM doit rester le dernier type faisant appel � TofDetail}
  TDescendant = (dsDetail, dsPeriodique, dsMensuel, dsSolde, dsTreso, dsCommission, dsBancaire,
                 dsControle, dsOPCVM, dsGroupe);

  {le param�trage de la nature de comptes g�n�raux est-il valide}
  TValideNatCpte = array[0..5] of Boolean;
  {Libell� des banques pr�visionnelles associ�es aux natures des comptes}
  TLibelleParam  = array[0..5] of string;
  {Comptes des banques pr�visionnelles associ�es aux natures des comptes}
  TComptesParam  = array[0..5] of string;

  TDblResult = record
    RE : string;
    RC : string;
    RT : string;
  end;

  {Int�gration comptable}
  TReglesInteg = record
    Exo : string;
    Jal : string;
    Dev : string;
    RIB : string;
    {Champs concernant la TVA}
    Tva : Boolean;
    Cpt : string;
    Tau : Double;
    Reg : string; {11/01/06 : R�gime de TVA}
    Cod : string; {11/01/06 : Code de TVA}

    dtC : TDateTime;
    dtV : TDateTime;
    Lig : Integer;

    {Ajout nouvel int�gration}
    ModeP    : string ;  {Mode de paiement}
    BQGene   : string ; {Compte g�n� correcpondant au BQ Code}
  end;

  {Infos de transaction d'une op�ration : table Transac}
  TInfosTransac = record
    Categorie : string;
    Libelle   : string;
    Flux1     : string;
    Flux2     : string;
    Flux3     : string;
    Flux4     : string;
    Flux5     : string;
  end;

  {Diff�rents Objets d�stin�s aux stockage d'informations dans des StringList}
  TObjCibTanque = class
    CodeCIB : string;
    CodeBQE : string;
    Dossier : string;
  end;

  TObjChaine = class
    Chaine : string;
  end;

  TObjNombre = class
    Nombre : Double;
  end;

  TObjEntier = class
    Entier : Integer;
  end;

  TObjDtValeur = class
    DateVal : TDateTime;
  end;

  TObjLibRub = class
    CodRub : string;
    LibRub : string;
  end;

  TObjDetailTVA = class
    Taux : Double;
    Cpte : string;
    Code : string; {11/01/06}
    Regm : string; {11/01/06}
  end;

  TObjDetailDevise = class
    Devise    : string[3];
    Cotation  : Double;
    DtCotat   : TDateTime;
    NbDecimal : Integer; {23/05/05 : Pour une gestion plus coh�rente des d�cimales}
  end;

  TObjDetContrat = class
    aDtDeb   : TDateTime;
    aDtFin   : TDateTime;
    aComMvt  : Double;
  end;

  TObjInfosBque = class
    Banque  : string;
    General : string;
    Code    : string;
    Dossier : string;
    CodeBq  : string[5];
    CodeGch : string[5];
    CodeCpt : string;
    Cle     : string[2];
    Iban    : string;
  end;

  TClefEcriture = record
    Transac : string;
    Piece   : string;
    Ligne   : string;
    ClefOpe : string;
    ClefVal : string;
  end;

  TRecordCompta = record
    NumTransac : string;
    NumPiece   : string;
    NumLigne   : Integer;
  end;

  TAfficheGrille = (ag_rien, ag_Synchro, ag_CtrlRub, ag_DateSynchro);

  {22/07/05 : Pour le recalcul des soldes par requ�te SQL}
  TEtatEcriture = (cso_Delete, cso_Insert, cso_Update, cso_Init, cso_None);

  TVarTreso = record
    lNomBase   : string;
    lNoDossier : string;
  end;

var
  {Je sais que ce n'est pas beau (une variable globale !), mais c'est la solution la
   plus simple que j'ai trouv�e pour r�soudre le probl�me des num�ri de ligne lors de
   l'int�gration en comptabilit� sans tout remettre en question (c'est peut �tre ce
   qu'il y aurait eu de mieux � faire, car je ne suis pas convaincu par ce traitement
   qui fut mon premier v�ritable Algorithme chez Cegid !!!)}
  RecordCompta : TRecordCompta;

  {FQ 10223 : gestion des erreurs lors de la cr�ation de d'�critures et de TrEcritures}
  ErreurCategorie  : TGroupeErr;
  CategorieCurrent : TCatErreur;
  {Liste des bases du regroupement Tr�so}
  VarTreso : TVarTreso;

implementation

end.
