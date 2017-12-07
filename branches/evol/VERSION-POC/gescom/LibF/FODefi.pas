{***********UNITE*************************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 03/04/2001
Modifi� le ... : 03/04/2001
Description .. : D�finition des constantes pour le Front Office
Mots clefs ... : FO
*****************************************************************}
unit FODefi;

interface

///////////////////////////////////////////////////////////////////////////////////////
//  Etats d'une journ�e de caisse
///////////////////////////////////////////////////////////////////////////////////////
const
  ETATJOURCAISSE: array[1..4] of string = (
    {1}'NON', // Non Ouverte
    {2}'OUV', // Ouverte
    {3}'CPR', // Clotur�e provisoirement
    {4}'CDE' // Clotur�e d�finitivement
    );

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Types d'op�rations de caisse
  ///////////////////////////////////////////////////////////////////////////////////////
const
  TYPEOPCBONACHAT: string = 'ABA'; // Acquisition d'un bon d'achat
  TYPEOPCECART: string = 'ECA'; // Ecart de caisse
  TYPEOPCCHQDIF: string = 'ECD'; // Encaissement de ch�que diff�r�
  TYPEOPCENCCREDIT: string = 'ECR'; // Encaissement de cr�dit
  TYPEOPCENTREE: string = 'END'; // Entr�e diverse
  TYPEOPCFDCAISSE: string = 'FCA'; // Fond de caisse
  TYPEOPCPRELEV: string = 'PRE'; // Pr�l�vement
  TYPEOPCREMBARRHES: string = 'RAR'; // Remboursement d'arrhes
  TYPEOPCREMBAVOIR: string = 'RAV'; // Remboursement d'avoir
  TYPEOPCREMBBONACH: string = 'RBA'; // Remboursement de bon d'achat
  TYPEOPCSORTIE: string = 'SOD'; // Sortie diverse
  TYPEOPCARRHES: string = 'VAR'; // Versement d'arrhes

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Types de modes de paiement
  ///////////////////////////////////////////////////////////////////////////////////////
const
  TYPEPAIEESPECE: string = '001'; // Esp�ce
  TYPEPAIEAVOIR: string = '002'; // Avoir
  TYPEPAIECHEQUE: string = '003'; // Ch�que
  TYPEPAIECHQDIFF: string = '004'; // Ch�que diff�r�
  TYPEPAIECB: string = '005'; // Carte bancaire
  TYPEPAIEARRHES: string = '006'; // Arrhes d�j� vers�s
  TYPEPAIERESTEDU: string = '007'; // Reste d�
  TYPEPAIEBONACHAT: string = '008'; // Bon d'achat
  TYPEPAIEAUTRE: string = '009'; // Autre type

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Devise EURO
  ///////////////////////////////////////////////////////////////////////////////////////
const
  SIGLEEURO: string = '�'; // Sigle mon�taire de l'Euro
  CODEEURO: string = 'EUR'; // Code de la devise Euro

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Contr�le de caisse
  ///////////////////////////////////////////////////////////////////////////////////////
const
  FINPIECE: string = 'FINPIE'; // Marque de fin des libell�s des pi�ces
  FINBILLET: string = 'FINBIL'; // Marque de fin des libell�s des billets

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Nature du mod�le d'impression
  ///////////////////////////////////////////////////////////////////////////////////////
  //    Table : MODELES
  //                      MO_TYPE    MO_NATURE
  //            Ticket      "T"        "VTC"      Tickets de caisse
  //            Etat        "E"        "GPJ"      Tickets de caisse format �tat
  //            Document    "L"        "GPI"      Tickets de caisse format document
  //            Etiquette   "E"        "GEA"
  //
const
  NATUREMODTICKET: string = 'GFT';   // Tickets de caisse
  NATUREMODTICETAT: string = 'GPJ';  // Tickets de caisse format �tat
  NATUREMODTICDOC: string = 'GPI';   // Tickets de caisse format document
  NATUREMODCHEQUE: string = 'GFQ';   // Ch�ques
  NATUREMODTICKETZ: string = 'GFC';  // Tickets X et Z
  NATUREMODSTATSGP: string = 'GSP';  // JTR - Nvelles stats - Statistiques pi�ces
  NATUREMODSTATSGPE: string = 'GSE'; // JTR - Nvelles stats - Statistiques mode de paiment
  NATUREMODSTATSGPV: string = 'GSV'; // JTR - Nvelles stats - Statistiques vendeurs
  NATUREMODSTATSGPZ: string = 'GSZ'; // JTR - Sp�cifiques
  // Type des �tats imprim�s sur le Front Office en mode ticket
type
  TTypeEtatFO = (efoTicket, efoTicketX, efoTicketZ, efoRecapVend, efoListeRegle, efoTicketTest,
    efoCheque, efoRemiseBq, efoBonAchat, efoBonAvoir, efoBonArrhes, efoTransfert,
    efoCommande, efoReception, efoStatFam, efoStatRem, efoFdCaisse, efoListeArtVendu,
    efoStatsGP, efoStatsGPE, efoStatsGPV, efoStatsGPZ);

  {==============================================================================================}
  {=================================== CL�S DE REGISTRE =========================================}
  {==============================================================================================}
  ///////////////////////////////////////////////////////////////////////////////////////
  //  Fermeture de journ�e
  ///////////////////////////////////////////////////////////////////////////////////////
const
  REGJOURNEE: string = 'FOJournee';
  REGFERMETICKETZ: string = 'FermeTicketZ'; // Encha�ner sur l'impression du ticket Z
  REGFERMERECAPVD: string = 'FermeRecapVd'; // Encha�ner sur l'impression du r�capitulatif vendeurs
  REGFERMEFDCAISSE: string = 'FermeFdCaisse'; // Encha�ner sur l'impression du fond de caisse
  REGFERMELISTEART: string = 'FermeListeArt'; // Encha�ner sur l'impression de la liste des articles vendus
  REGFERMELISTEREG: string = 'FermeListeReg'; // Encha�ner sur l'impression de la liste des r�glements
  REGFERMEFOBO: string = 'FermeFOBO'; // Encha�ner sur le d�marrage des liaisons FO-BO
  REGTMODEBIMP: string = 'TMODeButImprime'; // Temps d'attente pour lancer la 1�re impression
  REGTMOFINIMP: string = 'TMOFinImprime'; // Temps d'attente pour les impressions suivantes
  REGALERTEALF: string = 'AlerteAnnonces'; // Message d'alerte si annonces non valid�es
  
  ///////////////////////////////////////////////////////////////////////////////////////
  //  Retransmission d'une journ�e
  ///////////////////////////////////////////////////////////////////////////////////////
const
  REGTRANSJOUR: string = 'ReTransJour';
  REGENVOIIMMEDIAT: string = 'EnvoiImmediat'; // Envoi imm�diat
  REGCODECENTRAL: string = 'CodeSiteCentral'; // Code du site central
  REGLISTEREQUETES: string = 'ListeRequetes'; // Liste des requ�tes � associer
  REGCODEEVENEMENT: string = 'CodeEvenement'; // Code de l'�v�nement � g�n�rer
  REGTMODEMARRAGE: string = 'TMODemarrage'; // Temps d'attente pour lancer les �changes
  REGTMOATTENTEFIN: string = 'TMOAttenteFin'; // Temps d'attente pour v�rifier la fin des �changes

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Situation Flash
  ///////////////////////////////////////////////////////////////////////////////////////
const
  REGSITUFLASH: string = 'SituationFlash';
  REGCATEGORIEPARDEFAUT: string = 'DefaultCategorie';
  REGSTATSPARDEFAUT: string = 'DefaultStats';
  REGVENDEURSPARDEFAUT: string = 'DefaultVendeurs';
  REGTYPECATEGPARDEFAUT: string = 'DefaultTypeCateg';
  REGREGLTSPARDEFAUT: string = 'DefaultReglements';
  REGDETAILOPCAISSE: string = 'DetailOpCaisse';
  REGDETAILPRESTATION: string = 'DetailPrestation';
  REGCAISSEBTQ: string = 'CaisseBoutique';
  STATSINI: Integer = 0;
  STATSCATEG: Integer = 1;
  VENDEURSINI: Integer = 0;
  VENDEURSACTIFS: Integer = 1;
  TYPECATEGINI: Integer = 0;
  TYPECATEGTOUT: Integer = 1;
  REGLTSINI: Integer = 0;
  REGLTSTOUS: Integer = 1;
  REGLTSAUCUN: Integer = 2;

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Mode de connexion � la caisse
  ///////////////////////////////////////////////////////////////////////////////////////
const
  REGCONNEXCAIS: string = 'FOConnexionCaisse';
  REGCHAQUEFOIS: string = 'ChaqueFois'; // A chaque choix d'une ligne de menu
  REGTOUTESLIGNES: string = 'ToutesLignes'; // Pour toutes les lignes du menu
  REGVERIFVERROU: string = 'VerifVerrou'; // V�rifie si la caisse est d�j� en cours d'utilisation.

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Choix de la caisse
  ///////////////////////////////////////////////////////////////////////////////////////
const
  CAISSEPARDEFAUT: string = 'DefaultCash'; // Nom du param�tre de la registry pour stocker la caisse choisie
  CAISSEMONOPOSTE: string = 'CaisseMonoPoste'; // Caisse isol�e

  ///////////////////////////////////////////////////////////////////////////////////////
  //  Saisie de ticket
  ///////////////////////////////////////////////////////////////////////////////////////
const
  REGSAISIETIC: string = 'FOSaisieTicket';
  REGTMOSIMUCLAV: string = 'TMOSimuleClavier'; // Temps attente avant de simuler la frappe d'une touche
  REGAUTODIALTPE: string = 'AutoDialTpe'; // Lancement automatique du dialogue avec le TPE
  REGQTEMAXFFO: string = 'QteMaxFFO'; // Quantit� maximum autoris�e pour une ligne de ticket
  REGPRIXMAXFFO: string = 'PrixMaxFFO'; // Prix maximum autoris� pour une ligne de ticket

implementation

end.
