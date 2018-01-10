unit MessagesErreur;

interface

uses HMsgBox, HCtrls;

type
  TypeMsgErreur = (msNone, msError, msWarning, msAsk);

procedure ChargeTHMsgBoxFromArray(var MsgBox : THMsgBox; Tableau : array of string);
function GetTypeMsg(const Mess: String): TypeMsgErreur;

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/05/2005
Modifi� le ... :
Description .. : Messages li�s � la comptabilisation
Mots clefs ... : FactCpta
*****************************************************************}
const MSGERR_TitreCpta : array[1..14] of string 	= (
      {1}   'Comptabilisation des op�rations de caisse'
      {2}  ,'Comptabilisation de la pi�ce'
      {3}  ,'Comptabilisation du tiers'
      {4}  ,'Comptabilisation des articles'
      {5}  ,'Comptabilisation des frais de port'
      {6}  ,'Comptabilisation des taxes'
      {7}  ,'Comptabilisation des remises'
      {8}  ,'Comptabilisation des escomptes'
      {9}  ,'Comptabilisation de la tva intracommunautaire'
      {10} ,'Comptabilisation'
      {11} ,'Comptabilisation des remises en banque'
      {12} ,'Comptabilisation des stocks'
      {13} ,'Comptabilisation de l''extourne'
      {14} ,'Comptabilisation des r�glements'
      );

const MSGERR_TexteCpta : array[1..34] of string 	= (
      {1}  'Compte g�n�ral d''escompte absent ou incorrect'
      {2} ,'Compte g�n�ral de remise absent ou incorrect'
      {3} ,'Compte g�n�ral de taxe absent ou incorrect'
      {4} ,'Compte collectif tiers absent ou incorrect'
      {5} ,'Compte g�n�ral de HT absent ou incorrect'
      {6} ,'Compte g�n�ral d''�cart de conversion absent ou incorrect'
      {7} ,'Journal comptable non renseign� pour cette nature de pi�ce'
      {8} ,'Nature comptable non renseign�e'
      {9} ,'Erreur sur la num�rotation du journal comptable'
      {10} ,'Certains comptes g�n�raux, auxiliaires ou analytiques sont incorrects'
      {11} ,'Compte g�n�ral de stock ou variation absent ou incorrect'
      {12} ,'Compte de retenue de garantie absent ou incorrect'
      {13} ,'Compte g�n�ral de taxe RG absent ou incorrect'
      {14} ,'Compte g�n�ral de banque (associ� au journal ou au mode de paiement) absent ou incorrect'
      {15} ,'Erreur, les journaux des modes de paiement sont diff�rent'
      {16} ,'Journal non renseign�'
      {17} ,'Erreur sur le client'
      {18} ,'Certaines �critures ne sont pas �quilibr�es'
      {19} ,'Ecart sur contr�le des pi�ces d''achat' {DBR CPA}
      {20} ,' : Le compte g�n�ral, le code du journal ou le compte de contrepartie du journal est incorrect'
      {21} ,' : Le compte de virement interne ou le journal de la caisse g�n�ral est incorrect'
      {22} ,'Caisse g�n�rale : Le code ou le compte de contrepartie est incorrect'
      {23} ,' : Le compte d''�cart Cr�dit est incorrect'
      {24} ,' : Le compte d''�cart D�bit est incorrect'
      {25} ,'Le R�gime fiscal de la TVA Intracommunautaire est incorrect'
      {26} ,'Erreur lors de l''enregistrement des lignes d''�criture (le n� de pi�ce comptable attribu� %s est peut-�tre d�j� utilis�)'
      {27} ,'Erreur lors de l''enregistrement de la comptabilit� diff�r�e'
      {28} ,'Traitement interrompu.#13Le param�trage du mode de paiement est incorrect'
      {29} ,'Erreur lors de la mise � jour des lignes de r�glements'
      {30} ,'Erreur lors de la suppression des �critures comptables de la %s n� %s'
      {31} ,'Erreur lors de la mise � jour du solde du tiers'
      {32} ,'Erreur lors de la mise � jour du lien de la %s n� %s avec les �critures'
      {33} ,'Ligne de Tiers absente ou incorrecte'
      {34} ,'Ligne de Charges ou Produits absente ou incorrecte'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/05/2005
Modifi� le ... :
Description .. : Messages li�s � la fiche article
Mots clefs ... : UTomArticle
*****************************************************************}
const MSGERR_Article : array[1..78] of string 	= (
      {1}  'Vous devez renseigner un fournisseur' //Catalogue
      {2}, 'Vous devez renseigner la r�f�rence' //Catalogue
      {3}, 'La nature de la pi�ce suivante ne peut �tre �gale � la nature de pi�ce courante'
      {4}, 'Le prix de vente est inf�rieur au prix d''achat'
      {5}, 'Le code barre et le qualifiant code barre doivent �tre renseign�s  '
      {6}, 'Le nombre de caract�res du code barre est incorrect'
      {7}, 'Le code barre est incorrect'
      {8}, 'Le code barre contient des caract�res non autoris�s'
      {9}, 'Le code barre doit �tre num�rique'
      {10}, 'Le libell� doit �tre renseign�'
      {11}, 'L''article de remplacement n''existe pas'
      {12}, 'L''article de substitution n''existe pas'
      {13}, 'Vous ne pouvez pas s�lectionner l''article courant comme article de remplacement'
      {14}, 'Vous ne pouvez pas s�lectionner l''article courant comme article de substitution'
      {15}, 'Erreur de cr�ation de l''article dimensionn�'
      {16}, 'La premi�re famille de taxe est obligatoire '
      {17}, 'Suppression impossible, cet article est utilis� dans une pi�ce'
      {18}, 'Le type prestation/frais/fourniture est obligatoire' // Affaire
      {19}, 'Le code prestation/frais/fourniture est obligatoire' // Affaire
      {20}, 'Le code article est obligatoire'
      {21}, 'L''article n''existe pas' //Catalogue
      {22}, 'Impossible de supprimer un fournisseur principal' //Catalogue
      {23}, 'Le fournisseur n''existe pas' //Catalogue
      {24}, 'Votre base tarif HT fait r�f�rence au fournisseur principal'
      {25}, 'Fournisseur principal inexistant'
      {26}, 'L''article li� doit �tre diff�rent de l''article courant'
      {27}, 'Cet article li� existe d�j�'
      {28}, 'Le calcul de la base tarif se fait uniquement � partir des bases de l''article'
      {29}, 'L''article ayant du stock, la case tenu en stock ne peut �tre d�coch�e'
      {30}, 'Vous devez renseigner le libell�' //Catalogue
      {31}, 'Suppression impossible, cet article est utilis� sur une ligne d''activit�' // Affaire
      {32}, 'Le fournisseur principal n''existe pas'
      {33}, 'Vous n''avez pas calcul� la base tarif'
      {34}, 'Le type d''article financier est obligatoire'
      {35}, 'Article en mouvement, impossible de modifier sa gestion par lot'
      {36}, 'Impossible de d� r�f�rencer un fournisseur principal' //Catalogue
      {37}, 'Calcul du coefficient impossible, le prix de r�f�rence est nul'
      {38}, 'Le type de flux est obligatoire'
      {39}, 'Ce code barres est d�j� affect� � un autre article'
      {40}, 'Cet article est d�j� mouvement�, vous ne pouvez pas modifier le fournisseur'
      {41}, 'Version de d�monstration : le nombre d''articles exc�de le nombre autoris�.'
      {42}, 'Op�ration non disponible, il existe du stock sur cet article'
      {43}, 'Op�ration non disponible, il existe un tarif d�tail sur cet article'
      {44}, 'Les prix des articles dimensionn�s vont �tre mis � jour !'
      {45}, 'Confirmation'
      {46}, 'Cette TVA n''existe pas'
      {47}, 'Cette TPF n''existe pas'
      {48}, 'Choix d''un type d''ouvrage'
      {49}, 'Choix d''un type de nomenclature'
      {50}, 'Confirmez-vous la suppression du catalogue sur l''ancien fournisseur?'
      {51}, 'Le code article est obligatoire sur le catalogue'
      {52}, 'La saisie du champs suivant est obligatoire : '
      {53}, 'Article indisponible, vous devez auparavant valider votre saisie'
      {54}, 'Cette collection n''existe pas'
      {55}, 'Cette valeur n''existe pas'
      {56}, 'La nature de prestation n''existe pas'
      {57}, 'Plusieurs utilisateurs essayent de cr�er le m�me article, veuillez valider de nouveau'
      {58}, 'Renseignez la prestation associ�e !'
      {59}, 'Cet article existe d�j�'
      {60}, 'Le conditionnement ne peut pas �tre celui par d�faut'
      {61}, 'Vous avez saisi un profil mais n''avez pas appliqu� les valeurs de ce profil.' + #13 + ' Souhaitez-vous valider?'
      {62}, 'Caract�re interdit dans le code article'
      {63}, 'Suppression interdite, cet article est utilis� dans les mouvements de stock'
      {64}, 'Cet article est d�j� utilis� dans un autre profil avanc�'
      {65}, 'La limite du nombre maximum de champ est atteinte'
      {66}, 'Ce profil avanc� est utilis� dans des articles'
      {67}, 'L''article de r�f�rence n''existe pas'
      {68}, 'Aucun champ � inclure - V�rifier le mode de copie ou renseigner les champs � inclure.'
      {69}, 'La mise � jour des articles utilisant un profil avanc� qui pr�serve les diff�rences '
            + 'est impossible depuis la fiche profil.' + #13 + ' ' + #13 + ' Pour se faire il faut autoriser la mise � jour du profil depuis la fiche article et,'
            + #13 + ' apr�s modification d''un article profil, valider la modification des articles associ�s.'
      {70}, 'L''article de r�f�rence n''est pas renseign�'
      {71}, 'L''unit� est obligatoire'
      {72}, 'Domaine diff�rent de celui qui vous est assign�'
      {73}, 'Cet article parc est inexistant'
      {74}, 'Du stock existe pour le catalogue#13Le r�f�rencement a un article n''est pas possible'
      {75}, 'La marque est obligatoire'
      {76}, 'Il manque des formules de conversion entre les unit�s de la fiche article'
      {77}, 'Le domaine de l''article n''est pas valide.'
      {78}, 'Un conditionnement par d�faut existe pour ce flux.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR - Inventaire Contremarque
Cr�� le ...... : 18/05/2005
Modifi� le ... :
Description .. : Messages li�s � l'inventaire de Contremarque
Mots clefs ... : SaisieInv
*****************************************************************}
const MSGERR_InvContreM : array[1..14] of string 	= (
      {1}   'Confirmation'
      {2}  ,'Le stock inventori� va �tre forc� � la valeur du stock ordinateur, sur toutes les lignes non saisies !'
      {3}  ,'Le stock inventori� va �tre remis � z�ro, sur toutes les lignes saisies !'
      {4}  ,'Si le stock ordinateur est n�gatif, le stock inventori� sera forc� � z�ro.'
      {5}  ,'L''emplacement n''existe pas pour ce d�p�t. %s'
      {6}  ,'Le lot est obligatoire. %s'
      {7}  ,'Le n� de s�rie est obligatoire. %s'
      {8}  ,'La quantit� doit �tre unitaire en gestion par n� de s�rie. %s'
      {9}  ,'L''article existe d�j� dans la liste avec les m�mes caract�ristiques. %s'
      {10} ,'Le n� de s�rie existe d�j� dans la liste pour ce m�me article. %s'
      {11} ,'Inventaire de type initialisation des stocks. Il existe des mouvements sur cet article/d�p�t. Cr�ation refus�e. %s'
      {12} ,'Le n� de s�rie existe d�j� pour ce m�me article dans la liste : %s'
      {13} ,'Le ' + '%s' + ' contient des caract�res non autoris�s'
      {14} ,'Impossible de saisir une quantit� <> 0 car le n� de s�rie et/ou le n� de lot contiennent des caract�res non-autoris�s.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR - Validation d'inventaire
Cr�� le ...... : 18/05/2005
Modifi� le ... :
Description .. : Messages li�s � la validation des inventaires
Mots clefs ... : UtofValidInv
*****************************************************************}
const MSGERR_ValidInv: array[1..2] of string 	= (
      {1}  'Vous devez renseigner le Tiers Ecarts d''inventaire dans les Param�tes Soci�t�'
      {2} ,'Veuillez s�lectionner au moins une liste � valider'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR - Traitement de validation d'inventaire
Cr�� le ...... : 18/05/2005
Modifi� le ... :
Description .. : Messages li�s � la validation des inventaires
Mots clefs ... : ValidateInv
*****************************************************************}
const MSGERR_ValidInvTrt : array[1..25] of string 	= (
      {1}   'Validation en cours...'
      {2}  ,'Validation effectu�e'
      {3}  ,'&Annuler'
      {4}  ,'&Fermer'
      {5}  ,'Ordre des prix retenu :'
      {6}  ,'Abandon'
      {7}  ,'Validation des listes interrompue par l''utilisateur'
      {8}  ,'-- Traitement interrompu par l''utilisateur --'
      {9}  ,'En cours...'
      {10} ,'Non valid�e'
      {11} ,'Valid�e'
      {12} ,'Saisie incompl�te'
      {13} ,'(une ou plusieurs lignes non inventori�es)'
      {14} ,'Saisie en cours'
      {15} ,'(en cours de traitement par un autre utilisateur)'
      {16} ,'Echec'
      {17} ,'Validation interrompue'
      {18} ,'Tiers Ecarts inventaire inconnu'
      {19} ,''
      {20} ,'Impossible de d�terminer le client par d�faut.'
      {21} ,'Erreur � la cr�ation de la pi�ce'
      {22} ,'Erreur � la cr�ation d''une ligne'
      {23} ,'Impossible de trouver cet article :'
      {24} ,'Erreur � la validation de l''inventaire'
      {25} ,'Impossible de cr�er une pi�ce sans d�p�t'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 25/07/2005
Modifi� le ... :
Description .. : Messages li�s � la remise en banque
Mots clefs ... : GCREMBANQUEESP_TOF
*****************************************************************}
const MSGERR_RemBqe : array[1..4] of string 	= (
      {1}  'Aucun �l�ment s�lectionn�'
      {2}  ,'Traitement termin�'
      {3}  ,'La banque est incorrecte'
      {4}  ,'Ce mode de paiement n''est pas param�tr� pour le module Ventes comptoir' 
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 15/09/2005
Modifi� le ... :
Description .. : Messages li�s � la comptabilisation des stocks
Mots clefs ... : GCCPTASTOCK_TOF
*****************************************************************}
const MSGERR_CptaStock : array[1..10] of string 	= (
      {1}   'Le journal comptable n''est pas renseign�.'
      {2},  'Veuillez confirmer la comptabilisation des stocks d�j� comptabilis�s.'
      {3},  'Veuillez confirmer la comptabilisation des stocks.'
      {4},  'Traitement termin�'
      {5},  'Aucune ligne � traiter'
      {6},  'Erreur lors de la num�ration des �critures'
      {7},  'Erreur lors de la cr�ation des �critures'
      {8},  'Veuillez s�lectionner des �tablissements'
      {9},  'Erreur lors de la mise � jour des mouvements de stock'
      {10}, 'Il n''y a pas de nature de mouvement de stock param�tr�e pour la comptabilisation'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 20/09/2005
Modifi� le ... :
Description .. : Messages li�s aux entr�es exceptionnelles
Mots clefs ... : GCSTKMOTIF_TOF
*****************************************************************}
const MSGERR_EntExcept : array[1..20] of string 	= (
	    {1}  'D�p�t obligatoire.'
      {2}  ,'Article obligatoire.'
			{3}  ,'Motif obligatoire.'
      {4}  ,'Article non g�r� en n� de s�rie.'
      {5}  ,'Veuillez renseigner la dimension.'
      {6}  ,'Veuillez renseigner la dimension.'
      {7}  ,'Veuillez renseigner la dimension.'
      {8}  ,'Veuillez renseigner la dimension.'
      {9}  ,'Veuillez renseigner la dimension.'
      {10} ,'L''article est non g�r� en stock.'
      {11} ,'Stock disponible insuffisant.'
      {12} ,'Article inexistant.'
      {13} ,'Article inexistant pour votre domaine.'
      {14} ,'L''affaire n''existe pas.'
      {15} ,'Le fournisseur est obligatoire.'
      {16} ,'Erreur sur la r�f�rence.'
      {17} ,'Cet article n''est pas g�r� en contremarque.'
      {18} ,'Article ou r�f�rence de contremarque inexistant.'
      {19} ,'Choix abandonn�.'
      {20} ,''
		  );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 26/09/2005
Modifi� le ... :
Description .. : Messages li�s aux sorties exceptionnelles
Mots clefs ... : STKDEPLACEMENT_TOF
*****************************************************************}
Const	MSGERR_SortExcept: array[1..12] of string = (
      {1}   'Le d�p�t est obligatoire.'
      {2}  ,'L''emplacement est obligatoire.'
      {3}  ,'L''emplacement n''existe pas pour le d�p�t.'
      {4}  ,'L''emplacement de destination doit �tre diff�rent de l''emplacement de s�lection.'
      {5}  ,'Le statut de disponibilit� de l''emplacement est impos�.'
      {6}  ,'Le motif mouvement est obligatoire.'
      {7}  ,'L''affaire est obligatoire.'
      {8}  ,'L''affaire n''existe pas.'
      {9}  ,'Le client est obligatoire.'
      {10}  ,'Le client n''existe pas.'
		  {11}  ,'Le statut de disponibilit� est obligatoire.'
      {12}  ,'Le statut de flux est obligatoire.'
    );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s � la gestion des arrondis
Mots clefs ... : GCARRONDI_TOM
*****************************************************************}
Const MSG_Arrondi : array[1..8] of string = (
	    {1}   'Libell� d''arrondi est obligatoire'
      {2}  ,'Code d''arrondi est obligatoire'
      {3}  ,'L''emplacement d''arriv�e n''est pas renseign�.'
      {4}  ,'La ligne est incorrecte'
      {5}  ,'Voulez-vous enregistrer les modifications ?'
      {6}  ,'Valeur est incoh�rente,s�lectionnez les valeurs en cliquant sur la cellule constante m�thode'
      {7}  ,'Erreur!,Il faut au moins une ligne dans un tableau'
      {8}  ,'Valeur constante est incoh�rente'
		  );

{***********A.G.L.***********************************************
Auteur  ...... : BBI
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s au param�trage ABC
Mots clefs ... : ParametrageABC_TOM
*****************************************************************}
Const MSG_ParamABC_TOM: array[1..5] of string = (
    {1}  'La formule est incorrecte'
    {2} ,'La nature de pi�ce doit �tre renseign�e'
    {3} ,'La fonction est obligatoire pour tout autre flux que l''article'
    {4} ,'Saisie incorrecte. La somme des pourcentages doit �tre �gale � 100'
    {5} ,'Saisie incorrecte. Vous ne pouvez renseigner un seuil sans d�finir son libell�'
        );

{***********A.G.L.***********************************************
Auteur  ...... : BBI
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s au param�trage ABC
Mots clefs ... : ParamOblig_TOF
*****************************************************************}
Const MSG_ParamOblig_TOF: array[1..2] of string 	= (
          {1}  'Voulez-vous enregistrer les modifications ?'
          {2}  ,'Vos modifications seront actives � la prochaine connexion.'
          );

{***********A.G.L.***********************************************
Auteur  ...... : BBI
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s au param�trage ABC
Mots clefs ... : PieceEpure_TOF
*****************************************************************}
const MSG_PieceEpure_TOF : array[1..4] of string 	= (
          {1}   'Le traitement s''est correctement effectu�.'
          {2}  ,'Le traitement ne s''est pas termin� correctement.'
          {3}  ,'Le traitement a �t� interrompu'
          {4}  ,'Confirmez vous la suppression des documents s�lectionn�s ?'
          );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s Bascule de la gestion des unit�s de mesure en mode avanc�
Mots clefs ... : gcBasculeUnite_Tof
*****************************************************************}
const	MSG_BasculeUnite : array[1..5] of string = (
      {1}   'La bascule des unit�s a d�j� �t� effectu�e.'
      {2}  ,'La table des unit�s contient des doublons, le lancement de la bascule est impossible.'
      {3}  ,'La table des unit�s contient des quotit�s nulles, le lancement de la bascule est impossible.'
      {4}  ,'Le qualifiant par d�faut n''est pas renseign�.'
      {5}  ,'L''unit� par d�faut n''est pas renseign�e.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s � l'archivage des mouvements de stock
Mots clefs ... : ArchivageMouvement_TOF
*****************************************************************}
const MSG_ArchiveMvt : array[1..3] of string = (
      {1}  'Les mouvements seront archiv�s jusqu''au '
      {2} ,'Les mouvements de stock ne peuvent �tre archiv�s au del� du '
      {3} ,''
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 16/11/2005
Modifi� le ... :
Description .. : Messages li�s � l'affectation des mvt de contremarque
Mots clefs ... : GCAFFECTCONTREM_TOF
*****************************************************************}
const MSG_AffecteContreM: array[1..1] of string 	= (
      {1} 'Sans fournisseur, la ligne ne sera plus de contremarque. Voulez vous continuer ?'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s � la gestion des Articles/Qt�s
Mots clefs ... : ArticleQte_Tom
*****************************************************************}
const MSG_ArticleQte: array[1..2] of string 	= (
      {1} 'Le code article doit �tre renseign�'
      {2} ,''
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s � la duplication de nomenclature
Mots clefs ... : ChoixDupNomen
*****************************************************************}
const MSG_DupNomen: array[1..3] of string 	= (
      {1}  'La r�f�rence de la nomenclature existe d�j�'
      {2} ,'La r�f�rence de l''ouvrage existe d�j�'
      {3} ,'Veuillez renseigner le code'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s aux formules de calcul ABC
Mots clefs ... : FormuleCalculABC_TOF
*****************************************************************}
const MSG_FrmlCalcABC : array[1..3] of string = (
      {1}  'La formule est incorrecte'
      {2} ,'Les champs doivent �tre de type num�rique'
      {3} ,''
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s aux Articles/Parc
Mots clefs ... : GCArticleParc_Tom
*****************************************************************}
const MSG_ArticleParc : array[1..4] of string = (
      {1}  'Suppression impossible : article parc r�f�renc� dans les articles'
      {2} ,'L''activation de la gestion de versions#13 vous oblige � cr�er au moins une version'
      {3} ,'Suppression impossible : article parc r�f�renc� dans les versions',
      {4} 'La saisie du champ suivant est obligatoire : '
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s aux Commandes ouvertes
Mots clefs ... : GcCdeOuv_TOF
*****************************************************************}
const MSG_CdeOuv : array[1..6] of string = (
      {1}  'Vous ne pouvez pas saisir une quantit� n�gative.'
      {2} ,'Vous n''avez pas renseign� l''article.'
      {3} ,'L''article : %s n''existe pas.'
      {4} ,'Vous ne pouvez pas saisir une p�riodicit� n�gative.'
      {5} ,'Vous ne pouvez pas saisir un nombre de cadence n�gatif ou nul.'
      {6} ,'Vous n''avez pas renseign� le type de cadence.'
		  );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s � la gestion du colisage
Mots clefs ... : GcColisage_Tom
*****************************************************************}
const MSG_Colisage : array[1..3] of string = (
      {1} 'Le poids brut d''une unit� logistique ne peut �tre inf�rieur � son poids net.'
      {2} ,'Vous devez choisir un pr�parateur existant dans la liste.'
      {3} ,'Vous devez choisir un emballeur existant dans la liste.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s � la gestion du colisage
Mots clefs ... : AssistAffecteDepot
*****************************************************************}
const MSG_AssAffecteDepot : array[1..10] of string = (
      {1}  'INFORMATION'
      {2}  ,'Tous les mouvements de la base contiennent un d�p�t.'+#13+#10+'L''�x�cution de cet utilitaire n''est pas n�cessaire.'
      {3}  ,'CONFIRMATION'
      {4}  ,'Veuillez confirmer la mise � jour des mouvements sans d�p�t.'
      {5}  ,'ERREUR'
      {6}  ,'Le code du d�p�t ne peut �tre sup�rieur � 3 alphanum�riques.'
      {7}  ,'Le libell� du d�p�t ne peut �tre sup�rieur � 35 alphanum�riques.'
      {8}  ,'Ce code de d�p�t existe d�j�.'
      {9}  ,''
      {10} ,''
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Messages li�s au RAZ de l'activit�
Mots clefs ... : AssistRazActivite
*****************************************************************}
const MSG_AssRazActivite : array[1..8] of string = (
      {1}  'ERREUR'
      {2}  ,'ATTENTION'
      {3}  ,'CONFIRMATION'
      {4}  ,'Le mot de passe est incorrect.'
      {5}  ,'Il faut imp�rativement une sauvegarde r�cente de votre base avant de continuer.#13#10Si vous n''en avez pas, cliquez sur "Abandonner" pour annuler l''op�ration sinon, cliquez sur "Oui" pour continuer.'
      {6}  ,'Veuillez confirmer l''�x�cution de la remise � z�ro de l''activit�'
      {7}  ,'Cet utilitaire supprime d�finitivement toutes les informations li�es � la soci�t�.#13#10Veuillez confirmer...'
      {8}  ,'L''�x�cution de cet utilitaire est impossible tant qu''il y a d''autres utilisateurs connect�s sur la base.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. :
Mots clefs ... : EditAcompteDiff_TOF
*****************************************************************}
const MSG_EditAcpteDiff : array[1..3] of string = (
     {1}  'Aucun �l�ment s�lectionn�'
     {2}, 'Aucun �tat mod�le param�tr�'
     {3}, 'Trop de documents s�lectionn�s. Veuiller r�duire la s�lection'
     );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 15/11/2005
Modifi� le ... :
Description .. : Messages li�s aux Param�trage des natures de pi�ces
Mots clefs ... : UtomPiece.pas
*****************************************************************}
Const	MSG_PARPIECE: array[1..23] of string = (
      {1}    'Le code "Nature de Pi�ce" doit �tre renseign�'
      {2}   ,'L''intitul� doit �tre renseign�'
      {3}   ,'Le type de flux doit �tre renseign�'
      {4}   ,'Le mode de cr�ation doit �tre renseign�'
      {5}   ,'La nature suivante XXX n''est pas une nature de pi�ce existante'
      {6}   ,'Les pi�ces suivantes sont circulaires : XXX'
      {7}   ,'La nature �quivalente XXX n''est pas une nature de pi�ce existante'
      {8}   ,'Cette nature de pi�ce ne peut �tre supprim�e, des pi�ces y font r�f�rences'
      {9}   ,'Suppression impossible, cette nature est r�f�renc�e comme nature suivante pour le type de pi�ce XXX'
      {10}  ,'Le montant de visa doit �tre sup�rieur ou �gal � z�ro'
      {11}  ,'Vos modifications seront actives � la prochaine connexion'
      {12}  ,'Le domaine d''activit� doit �tre renseign�'
      {13}  ,'Vous ne pouvez pas utiliser les tables libres si aucune d''elles n''est renseign�e'
      {14}  ,'ATTENTION !!! La Gestion des reliquats et la Gestion des lots sont activ�es.'+#13+' Il sera impossible de g�n�rer des reliquats sur les articles g�r�s en lots.'
      {15}  ,'La nature suivante XXX ne peut �tre s�lectionn�e.#13 Se reporter � l''aide sur le "Solde avant transformation".'
      {16}  ,'Le mod�le WORD n''existe pas'
      {17}  ,'Liste affaire'
      {18}  ,'Liste de saisie'
      {19}  ,'ERREUR !!! Une des pi�ces pr�c�dentes est param�tr�e avec la comptabilisation "Normale"'
      {20}  ,'Certains comptes de TVA ou TPF n''ont pas de comptes FAR FAE'
      {21}  ,'Le compte FAR FAE est incorrect'
      {22}  ,'La gestion de FAR FAE ne peut se faire que sur un passage en comptabilit� de type "Ecriture normale"'
      {23}  ,'ERREUR !!! Les nomenclatures ne sont pas accept�es dans les pi�ce d''achat '
    );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 15/11/2005
Modifi� le ... :
Description .. : Messages li�s � la saisie de pi�ces
Mots clefs ... : Facture.pas
*****************************************************************

ATTENTION !!! Les array sont en d�calage de -1 par rapport aux THMsgBox
exemple : MSG_FactErr[1] = Herr.execute[0]
}

Const MSG_FactTitre: array[1..30] of string = ( // = HTitres
      {1}   'Liste des articles'
      {2}  ,'Articles'
      {3}  ,'Tiers'
      {4}  ,'Liste des affaires'
      {5}  ,'Affaires'
      {6}  ,'ATTENTION : Pi�ce non enregistr�e !'
      {7}  ,'ATTENTION : Cette pi�ce en cours de traitement par un autre utilisateur n''a pas �t� enregistr�e !'
      {8}  ,'Liste des commerciaux'
      {9}  ,'Conditionnements'
      {10}  ,'Conditionnement en cours :'
      {11}  ,'Non affect�'
      {12}  ,'Liste des commerciaux'
      {13}  ,'Liste des d�p�ts '
      {14}  ,'ATTENTION : Cette pi�ce ne peut pas passer en comptabilit� et n''a pas �t� enregistr�e !'
      {15}  ,'Euro '
      {16}  ,'Autres'
      {17}  ,'Libell�s automatiques'
      {18}  ,'(r�f�rence de substitution possible :'
      {19}  ,'(remplacement par r�f�rence :'
      {20}  ,'ATTENTION : l''impression ne s''est pas correctement effectu�e !'
      {21}  ,'ATTENTION : la suppression ne s''est pas correctement effectu�e !'
      {22}  ,'Cr�dit accord� :'
      {23}  ,'Encours actuel :'
      {24}  ,'ATTENTION : La pi�ce pr�sente un probl�me de num�rotation et n''a pas �t� enregistr�e !'
      {25}  ,'Client'
      {26}  ,'Fournisseur'
      {27}  ,''
      {28}  ,'ATTENTION. Le stock disponible est insuffisant pour certains articles.'
      {29}  ,'Changement de code TVA'
      {30}  ,'Changement du r�gime fiscal de la pi�ce'
      );

      MSG_FactPiece: array[1..84] of string = ( // = HPiece
      {1}   '1;?caption?;Il n''existe pas de tarif pour cet article correspondant � la devise de la pi�ce !;E;O;O;O;'
      {2}  ,'2;?caption?;Saisie impossible. Il n''existe pas de tarif pour cet article correspondant � la devise de la pi�ce !;E;O;O;O;'
      {3}  ,'3;?caption?;Saisie impossible. Cet article ferm� n''est pas autoris� pour cette nature de pi�ce;E;O;O;O;'
      {4}  ,'4;?caption?;Choix impossible. Ce tiers ferm� ne peut pas �tre appel� pour cette nature de pi�ce;E;O;O;O;'
      {5}  ,'5;?caption?;Choix impossible. La nature du tiers associ� � l''affaire n''est pas compatible avec la nature de pi�ce;E;O;O;O;'
      {6}  ,'6;?caption?;Vous devez renseigner un tiers valide;E;O;O;O;'
      {7}  ,'7;?caption?;Confirmez-vous l''abandon de la saisie ?;Q;YN;Y;N;'
      {8}  ,'8;?caption?;Voulez-vous affecter ce d�p�t sur toutes les lignes concern�es ?;Q;YN;Y;N;'
      {9}  ,'9;?caption?;Choix impossible. Ce code tiers est incorrect;E;O;O;O;'
      {10}  ,'10;?caption?;Cette pi�ce ne peut pas �tre modifi�e ni transform�e, seule la consultation est autoris�e;E;O;O;O;'
      {11}  ,'11;?caption?;Cet article est en rupture, confirmez-vous malgr� tout la quantit� ?;Q;YN;Y;N;'
      {12}  ,'12;?caption?;Cet article est en rupture ;E;O;O;O;'
      {13}  ,'13;?caption?;Cet article n''est plus g�r� ;E;O;O;O;'
      {14}  ,'14;?caption?;Le plafond de cr�dit accord� au tiers est d�pass� ! ;E;O;O;O;'
      {15}  ,'15;?caption?;Le cr�dit accord� au tiers est d�pass� ! ;E;O;O;O;'
      {16}  ,'16;?caption?;Voulez-vous saisir ce taux dans la table de chancellerie ?;Q;YN;Y;N;O;'
      {17}  ,'17;?caption?;ATTENTION : Le taux en cours est de 1. Voulez-vous saisir ce taux dans la table de chancellerie;Q;YN;Y;N;O;'
      {18}  ,'18;?caption?;ATTENTION : la marge de la ligne est inf�rieure au minimum requis;E;O;O;O;'
      {19}  ,'19;?caption?;La date que vous avez renseign�e n''est pas valide;E;O;O;O;'
      {20}  ,'20;?caption?;La date que vous avez renseign�e n''est pas dans un exercice ouvert;E;O;O;O;'
      {21}  ,'21;?caption?;La date que vous avez renseign�e est ant�rieure � une cl�ture;E;O;O;O;'
      {22}  ,'22;?caption?;La date que vous avez renseign�e est ant�rieure � une cl�ture;E;O;O;O;'
      {23}  ,'23;?caption?;La date que vous avez renseign�e est en dehors des limites autoris�es;E;O;O;O;'
      {24}  ,'24;?caption?;ATTENTION : la marge de la ligne est inf�rieure au minimum requis. Voulez-vous changer de code utilisateur ?;Q;YN;N;N;'
      {25}  ,'25;?caption?;Le plafond de cr�dit accord� au tiers est d�pass�. Voulez-vous changer de code utilisateur ? ;Q;YN;N;N;'
      {26}  ,'26;?caption?;Vous ne pouvez pas saisir avant le ;E;O;O;O;'
      {27}  ,'27;?caption?;Cette pi�ce contient d�j� des lignes. Reprise des lignes de l''affaire impossible ;E;O;O;O;'
      {28}  ,'28;?caption?;Attention : Vous n''avez pas affect� d''affaire sur cette pi�ce ;E;O;O;O;'
      {29}  ,'29;?caption?;La date est ant�rieure � celle de derni�re cl�ture de stock;E;O;O;O;'
      {30}  ,'30;?caption?;Confirmez-vous la suppression de la pi�ce ?;Q;YN;N;N;'
      {31}  ,'31;?caption?;Voulez-vous r�percuter la date de livraison de l''ent�te sur toutes les lignes?;Q;YN;Y;N;O;'
      {32}  ,'32;?caption?;Voulez-vous r�percuter la date de livraison de l''ent�te sur les lignes s�lectionn�es ?;Q;YN;Y;N;O;'
      {33}  ,'33;?caption?;Vous devez renseigner une devise;E;O;O;O;'
      {34}  ,'34;?caption?;Vous avez enregistr� des acomptes ou des r�glements. Voulez-vous les supprimer ?;Q;YN;Y;N;O;'
      {35}  ,'35;?caption?;Ce client est en rouge ! Vous ne pouvez pas lui cr�er de pi�ce �  ce niveau de risque;E;O;O;O;'
      {36}  ,'36;?caption?;Confirmez-vous la suppression de tout le paragraphe ?;Q;YN;N;N;'
      {37}  ,'37;?caption?;Cet article est tenu en stock, vous ne pouvez le contremarquer;E;O;O;O;'
      {38}  ,'38;?caption?;Cette pi�ce contient d�j� des lignes, vous ne pouvez pas changer le fournisseur;E;O;O;O;'
      {39}  ,'39;?caption?;Confirmez vous le changement du code TVA sur toutes les lignes saisies ?;Q;YN;Y;N;'
      {40}  ,'40;?caption?;Confirmez vous le changement du r�gime fiscal de la pi�ce ?;Q;YN;Y;N;'
      {41}  ,'41;?caption?;Erreur sur le code du commercial;E;O;O;O;'
      {42}  ,'42;?caption?;Vous devez renseigner un motif par d�faut;E;O;O;O;'
      {43}  ,'43;?caption?;Vous ne pouvez pas saisir une quantit� n�gative;E;O;O;O;'
      {44}  ,'44;?caption?;Cette pi�ce ne peut pas �tre modifi�e, seule la derni�re situation est modifiable;E;O;O;O;'
      {45}  ,'45;?caption?;Certains articles n''ont pu �tre recup�r�s;E;O;O;O;'
      {46}  ,'46;?caption?;G�n�ration impossible : le param�trage est incomplet;E;O;O;O;'
      {47}  ,'47;?caption?;Date inf�rieure � arr�t� de p�riode;E;O;O;O;'
      {48}  ,'48;?caption?;Saisie impossible. Cet article n''est g�rable qu''en contremarque.;E;O;O;O;'
      {49}  ,'49;?caption?;La saisie par code barre n''a pas �t� valid�e, voulez-vous la valider ?;Q;YN;Y;N;'
      {50}  ,'50;?caption?;Le taux d''escompte ne peut exc�der 100%. ;E;O;O;O;'
      {51}  ,'51;?caption?;Le taux de remise ne peut exc�der 100%. ;E;O;O;O;'
      {52}  ,'52;?caption?;Attention ! La quantit� saisie est inf�rieure au total des quantit�s des pi�ces suivantes.;E;O;O;O;'
      {53}  ,'53;?caption?;Vous ne pouvez pas supprimer cette ligne, d''autres lignes y sont associ�es.;E;O;O;O;'
      {54}  ,'54;?caption?;Vous ne pouvez pas changer l''article de cette ligne.;E;O;O;O;'
      {55}  ,'55;?caption?;Toutes les lignes de la pi�ce d''origine ont �t� transform�es.;E;O;O;O;'
      {56}  ,'56;?caption?;ATTENTION: La suppression est impossible car de l''activit� a �t� saisie ;E;O;O;O;'
      {57}  ,'57;?caption?;La quantit� de la ligne est sup�rieure au maximum autoris�;E;O;O;O;'
      {58}  ,'58;?caption?;Le d�p�t est obligatoire.;E;O;O;O;'
      {59}  ,'59;?caption?;Confirmez-vous le solde de cette ligne ?;Q;YN;N;N;'
      {60}  ,'60;?caption?;Voulez-vous d�-solder de cette ligne ?;Q;YN;N;N;'
      {61}  ,'61;?caption?;Vous ne pouvez pas supprimer cette ligne, la ligne de la pi�ce pr�c�dente est sold�e.;E;O;O;O;'
      {62}  ,'62;?caption?;Confirmez-vous le solde de toutes les lignes de la piece ?;Q;YN;N;N;'
      {63}  ,'63;?caption?;Cet article n''a pas de catalogue, vous ne pouvez le contremarquer.;E;O;O;O;'
      {64}  ,'64;?caption?;Cet article est g�r� en lot ou en num�ro de s�rie, vous ne pouvez le contremarquer;E;O;O;O;'
      {65}  ,'65;?caption?;La quantit� saisie est sup�rieure � la quantit� restant � lancer;E;O;O;O;'
      {66}  ,'66;?caption?;Le n� d''ordre est obligatoire.;E;O;O;O;'
      {67}  ,'67;?caption?;La phase est obligatoire.;E;O;O;O;'
      {68}  ,'68;?caption?;Le traitement est obligatoire.;E;O;O;O;'
      {69}  ,'69;?caption?;Voulez-vous affecter la modification aux lignes commissionnables de la pi�ce ?;Q;YN;Y;N;'
      {70}  ,'70;?caption?;Confirmez vous le changement du code TVA sur toutes les lignes s�lectionn�es ?;Q;YN;Y;N;'
      {71}  ,'71;?caption?;Un compteur diff�rent est param�tr� pour cet �tablissement. Le changement est impossible;E;O;O;O;'
      {72}  ,'72;?caption?;Confirmez-vous le d�-solde de toutes les lignes de la piece ?;Q;YN;N;N;'
      {73}  ,'73;?caption?;La facture d''acompte ne pourra �tre produite qu''une fois comptabilis�e;E;O;O;O;'
      {74}  ,'74;?caption?;Une prestation �cole existe d�j�.;E;O;O;O;'
      {75}  ,'75;?caption?;Vous devez saisir une prestation de type planification article �cole.;E;O;O;O;'
      {76}  ,'76;?caption?;Voulez-vous modifier le code affaire sur toutes les lignes ?;Q;YN;Y;N;'
      {77}  ,'77;?caption?;Ce tiers n''a pas de commercial;W;O;O;O;'
      {78}  ,'78;?caption?;Choix impossible. Ce type de tiers n''est pas autoris� pour la nature de pi�ce;E;O;O;O;'
      {79}  ,'79;?caption?;Choix impossible. Cet article n''a pas de nomenclature d''assemblage;E;O;O;O;'
      {80}  ,'80;?caption?;Cet article ne peut plus �tre utilis�, sa date de suppression est d�pass�e;E;O;O;O;'
      {81}  ,'81;?caption?;L''article %s n''existe pas;E;O;O;O;'
      {82}  ,'82;?caption?;Choix impossible. La nomenclature d''assemblage n''a pas de composants;E;O;O;O;'
      {83}  ,'83;?caption?;La date de pi�ce n''est pas comprise entre les dates limites des param�tres soci�t� !;E;O;O;O;'
      {84}  ,'84;?caption?;L''article n''est pas tenu en Stock !;E;O;O;O;'
         );

      MSG_FactAveugle: array[1..5] of String = ( // = HAveugle
      {1}   'ATTENTION : code barre inconnu.'
      {2}  ,'2;?Caption?;La quantit� de cet article est sup�rieure � celle attendue dans le document. #13 Voulez-vous l''ajouter au document ?;Q;YN;Y;N;'
      {3}  ,'ATTENTION : vous ne pouvez pas saisir une quantit� n�gative.'
      {4}  ,'3;?Caption?;Voulez-vous supprimer tous les articles saisis ?;Q;YN;Y;N;'
      {5}  ,'ATTENTION : cet article ne correspond pas � ce fournisseur.'
      );

      MSG_FactErr: array[1..17] of String = ( // = HErr
      {1}   'Erreurs en validation'
      {2}  ,'2;?caption?;Vous ne pouvez pas enregistrer une pi�ce vide;E;O;O;O;'
      {3}  ,'3;?caption?;Vous ne pouvez pas enregistrer une pi�ce sans articles;E;O;O;O;'
      {4}  ,'4;?caption?;Vous ne pouvez pas enregistrer une pi�ce sans mouvements;E;O;O;O;'
      {5}  ,'5;?caption?;Vous ne pouvez pas enregistrer une pi�ce � cette date;E;O;O;O;'
      {6}  ,'6;?caption?;Enregistrement impossible : l''acompte est sup�rieur au total de la pi�ce;E;O;O;O;'
      {7}  ,'7;?caption?;Enregistrement impossible : la devise est incorrecte;E;O;O;O;'
      {8}  ,'8;?caption?;La pi�ce d''origine est d�j� trait�e;E;O;O;O;'
      {9}  ,'9;?caption?;Le contr�le facture n''est pas valide;E;O;O;O;'
      {10}  ,'10;?caption?;Le circuit est obligatoire;E;O;O;O;'
      {11}  ,'11;?caption?;L''ordre, la phase et le traitement de production sont obligatoires;E;O;O;O;'
      {12}  ,'12;?caption?;Le code march� est obligatoire;E;O;O;O;'
      {13}  ,'13;?caption?;La date de d�but est sup�rieure � la date de fin;E;O;O;O;'
      {14}  ,'14;?caption?;Ce code march� existe d�j� dans une autre pi�ce, pour le m�me couple article, tiers;E;O;O;O;'
      {15}  ,'15;?caption?;March� : Doublon sur code march� et/ou chevauchement des dates de march� dans cette pi�ce;E;O;O;O;'
      {16}  ,'16;?caption?;Vous ne pouvez pas enregistrer une pi�ce avec une ou des lignes dont le montant est �gal � z�ro;E;O;O;O;'
      {17}  ,'17;?caption?;Les dates de validit� ne couvrent pas les appels pass�s sur ce march�;E;O;O;O;'
      );

      MSG_FactTexteSortie: array[1..6] of string 	= ( // = TexteSortie
      {1}   'Vous ne pouvez pas modifier la quantit� de cette pi�ce'
      {2}  ,'Vous ne pouvez pas facturer plus que ce que vous avez livr�.'#13'Veuillez saisir une ligne de compl�ment pour cet article'
      {3}  ,'Vous ne pouvez pas facturer plus que ce que vous avez r�ceptionn�.'#13'Veuillez saisir une ligne de compl�ment pour cet article'
      {4}  ,'Vous ne pouvez pas supprimer la ligne'
      {5}  ,'Vous ne pouvez pas changer le signe de la ligne'
      {6}  ,'Saisir la prestation � planifier et le nombre de participants'
      );
      
{***********A.G.L.***********************************************
Auteur  ...... : JSI
Cr�� le ...... : 08/02/2006
Modifi� le ... :
Description .. : Messages li�s aux contr�les de suppression
...............  et fermeture des tiers
Mots clefs ... :
*****************************************************************}
Const	MSGERR_SupprTiers : array[1..38] of string = (
        {1}        'Ce compte auxiliaire est mouvement�',
        {2}        'Ce compte auxiliaire est r�f�renc� dans un guide d''�criture comptable',
        {3}        'Ce compte auxiliaire sert de mod�le pour la cr�ation',
        {4}        'Ce compte auxiliaire est r�f�renc� dans un catalogue',
        {5}        'Ce compte auxiliaire est r�f�renc� dans une ligne d''�criture',
        {6}        'Ce compte auxiliaire est r�f�renc� dans une ligne de pi�ce interne',
        {7}        'Ce compte auxiliaire est r�f�renc� dans une pi�ce',
        {8}        'Ce compte auxiliaire est r�f�renc� dans une pi�ce interne',
        {9}       'Ce compte auxiliaire est un compte de correspondance',
        {10}       'Ce compte auxiliaire est un client ou un fournisseur d''attente',
        {11}       'Ce compte auxiliaire est r�f�renc� dans une section analytique',
        {12}       'Ce compte auxiliaire est r�f�renc� pour un autre compte auxiliaire',
        {13}       'Ce compte auxiliaire est un utilisateur',
        {14}       '14;Suppression des comptes auxiliaires;Vous n''avez rien s�lectionn�;E;O;O;O;',
        {15}       '15;Suppression des comptes auxiliaires;D�sirez-vous un compte rendu des comptes d�truits?;Q;YNC;N;C;',
        {16}       '16;Suppression des comptes auxiliaires;D�sirez-vous un compte rendu des comptes non d�truits?;Q;YNC;N;C;',
        {17}       'Compte supprim�',
        {18}       'Compte en cours d''utilisation !',
        {19}       'Aucun',
        {20}       '�l�ment s�lectionn�',
        {21}       '�l�ments s�lectionn�s',
        {22}       '22;',
        {23}       '23;',
        {24}       '24;',
        {25}       '25;',
        {26}       'Ce compte est mouvement� en pi�ces de Gestion Commerciale',
        {27}       'Ce compte est mouvement� en r�glements de Gestion Commerciale',
        {28}       'Ce compte est r�f�renc� dans les activit�s',
        {29}       'Ce compte est r�f�renc� dans les ressources',
        {30}       'Ce compte est r�f�renc� en affaire',
        {31}       'Ce compte est r�f�renc� dans les actions',
        {32}       'Ce compte est r�f�renc� dans les propositions',
        {33}       'Ce compte est r�f�renc� comme salari�',
        {34}       'Ce compte est r�f�renc� dans le catalogue',
        {35}       'Ce compte est mouvement� dans la paie comme salari�',
        {36}       'Ce compte est r�f�renc� dans les projets',
        {37}       'Ce compte est r�f�renc� dans les documents GED',
        {38}       'Ce tiers a du parc en service'
          );

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 02/02/2006
Modifi� le ... :
Description .. : Messages li�s � la fiche tiers
Mots clefs ... : UtomTiers.pas
*****************************************************************}
Const	MSG_Tiers : array[1..58] of string = (
      {1}  'Le code doit �tre renseign�'
      {2}  ,'La raison sociale doit �tre renseign�e'
      {3}  ,'Le client payeur sp�cifi� n''existe pas ou n''est pas un client payeur'
      {4}  ,'Le code du repr�sentant n''existe pas'
      {5}  ,'Le code du tiers factur� n''existe pas ou n''est pas un client'
      {6}  ,'Le code de l''apporteur n''existe pas'
      {7}  ,'Le tiers n''est pas un client'
      {8}  ,'Le destinataire de l''adresse est obligatoire'
      {9}  ,'Le code postal de l''adresse est obligatoire'
      {10} ,'La ville de l''adresse est obligatoire'
      {11} ,'Les natures de pi�ces suivantes et courantes doivent �tre diff�rentes'
      {12} ,'Vous ne pouvez choisir ce type de pi�ce suivante du fait de la circularit� : XXX'
      {13} ,'Le plafond autoris� ne doit pas �tre inf�rieur au cr�dit accord�'
      {14} ,'Le montant de visa doit etre sup�rieur � z�ro'
      {15} ,'Le compte collectif doit �tre renseign�#13Veuillez le renseigner dans les param�tres comptables'
      {16} ,'La nature d''auxiliaire n''est pas d�finie'
      {17} ,'Une fiche existe d�j� avec ce code tiers'
      {18} ,'Le mode de r�glement doit �tre renseign�'
      {19} ,'Le r�gime fiscal doit �tre renseign�'
      {20} ,'L''adresse doit �tre renseign�e'
      {21} ,'Une fiche existe d�j� avec ce code auxiliaire'
      {22} ,'Le mois de cl�ture � une valeur incorrecte'   // AFfaire
      {23} ,'Le compte Auxiliaire doit �tre renseign� '
      {24} ,'Le compte Collectif n''existe pas'
      {25} ,'Le code groupe n''existe pas'
      {26} ,'Le code prescripteur n''existe pas'
      {27} ,'Probl�me de cr�ation de la fiche Suspect'  // GRC
      {28} ,'Version de d�monstration, vous n''�tes pas autoris� � cr�er plus de 10 tiers'
      {29} ,'Le num�ro de Siret ou Siren n''est pas correct '
      {30} ,'Ce num�ro de Siret existe d�j� sur la fiche tiers : '// GRC
      {31} ,'Vous ne pouvez cr�er qu''une seule adresse de facturation' // Affaire
      {32} ,'Version de d�monstration : le nombre de tiers exc�de le nombre autoris�.'
      {33} ,'Champ obligatoire : '
      {34} ,'Ce num�ro de Siren existe d�j� sur la fiche tiers : ' // mng : 34
      {35} ,'Date d''expiration inf�rieure � la date de d�livrance' //CHR
      {36} ,'La saisie du champ suivant est obligatoire : '
      {37} ,'Le code du tiers livr� n''existe pas ou n''est pas un client'
      {38} ,'Cette r�gion n''appartient pas � ce pays'
      {39} ,'Le fournisseur pay� sp�cifi� n''existe pas'
      {40} ,'L''emetteur de factures sp�cifi� n''existe pas'
      {41} ,'Le code NIF est obligatoire'
      {42} ,'Un code ressource libre est inexistant'
      {43} ,'Un code assistant libre est inexistant'
      {44} ,'Ce tiers n''est pas un tiers payeur'
      {45} ,'Le jour de naissance n''est pas correct'
      {46} ,'L''ann�e de naissance doit �tre saisie sur 4 caract�res'
      {47} ,'L''adresse de livraison n''existe pas'
      {48} ,'L''adresse de facturation n''existe pas'
      {49} ,'Le commercial est obligatoire'
      {50} ,'Cette enseigne n''existe pas'
      {51} ,'Ce transporteur n''existe pas'
      {52} ,'Ce fournisseur transporteur est utilis� dans les tarifs.' + #13 + ' Vous ne pouvez supprimer le type de fournisseur "transporteur".'
      {53} ,'Ce fournisseur transporteur est affect� � un tiers.' + #13 + ' Vous ne pouvez supprimer le type de fournisseur "transporteur".'
      {54} ,'Ce fournisseur transporteur est affect� � une adresse.' + #13 + ' Vous ne pouvez supprimer le type de fournisseur "transporteur".'
      {55} ,'Le compte n''est pas un collectif fournisseur.'
      {56} ,'Le compte n''est pas un collectif client.'
      {57} ,'La prestation de transport est incorrecte .'
      {58} ,'Le code frais renseign� est inconnu.'
      );

{***********A.G.L.***********************************************
Auteur  ...... : MNG
Cr�� le ...... : 23/03/2006
Modifi� le ... :
Description .. : Messages li�s � la gestion des alertes
Mots clefs ... : Alerte
*****************************************************************}
Const	MSG_Alertes : array[1..3] of string  = (
          {1}         'La zone "Alerte sur" doit �tre renseign�e',
          {2}         'Vous devez s�lectionner un ou plusieurs utilisateur(s)',
          {3}         'Vous devez s�lectionner un ou plusieurs groupe(s)'
        );          
{***********A.G.L.***********************************************
Auteur  ...... : Thibaut Sublet
Cr�� le ...... : 25/08/2006
Modifi� le ... :
Description .. : Messages d'erreur en gestion des pi�ces/lignes
Mots clefs ... : PREPAEXPE
*****************************************************************}
const MSGERR_PrepaExpe: Array[1..4] of String = (
          {1}  'Il existe des lignes extraites en pr�paration d''exp�dition.'
          {2} ,'Il existe du stock affect� par la pr�paration d''exp�dition.'
          {3} ,'Cette ligne est extraite en pr�paration d''exp�dition.'
          {4} ,'Il existe du stock affect� � cette ligne par la pr�paration d''exp�dition.'
  );

implementation

{***********A.G.L.***********************************************
Auteur  ...... : JTR
Cr�� le ...... : 18/11/2005
Modifi� le ... :
Description .. : Creer un THMsgBox depuis un tableau de message
Mots clefs ... :
*****************************************************************}
procedure ChargeTHMsgBoxFromArray(var MsgBox : THMsgBox; Tableau : array of string);
var Cpt : integer;
begin
  for Cpt := 0 to High(Tableau) do
    MsgBox.Mess.add(Tableau[Cpt]);
end;

{***********A.G.L.***********************************************
Auteur  ...... : BBI
Cr�� le ...... : 19/04/2006
Modifi� le ... :
Description .. : Indique la nature du message en prenant en compte
                 le caractere situ� apr�s le texte (E, W, Q)
Mots clefs ... :
*****************************************************************}
function GetTypeMsg(const Mess: String): TypeMsgErreur;
var stType : string;
begin
  stType := Mess;
  ReadTokenSt(stType);
  ReadTokenSt(stType);
  ReadTokenSt(stType);
  stType := ReadTokenSt(stType);
  Result := msNone;
  if (stType = 'E') or (stType = 'X') then Result := msError
  else if stType = 'W' then Result := msWarning
  else if stType = 'Q' then Result := msAsk
  ;
end;

end.
