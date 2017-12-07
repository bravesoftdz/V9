unit UCstEtebac;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Hctrls, StdCtrls,
  {$IFNDEF EAGLCLIENT}
  DBCtrls,HDB,
  {$ENDIF}
  Mask;


 const
  // numero des champs dans la grille de saisie
 cColDate             = 1;
 cColRefInterne       = 2;
 cColLibelle          = 3;
 cColDebit            = 4;
 cColCredit           = 5;
 cColAFB              = 6; // FB 10174 - LG  - 13/06/2005 - ajout du code interbancaire
 cColPiece            = 7;
 cColImputation       = 8;
 cColTva              = 9;
 cColEtat             = 10;

 // numero des champs dans la grille
 cColGeneralImput     = 1;
 cColAuxiliaireImput  = 2;
 cColReferenceImput   = 3;
 cColLibelleImput     = 4;
 cColDebitImput       = 5;
 cColCreditImput      = 6;

 cColObjectGuide      = 0;
 cColObjectReleve     = 1;

 cStTexteTitreFenetre                  = 'Saisie tr�sorerie';
 cStTexteLigneReleve                   = 'Ligne de relev� num�ro ';
 cStTexteArretGuide                    = 'Voulez-vous arr�ter le guide de saisie ?';
 cStTexteJournalPasPresent             = 'Vous devez d�finir au moins un journal de banque';
 cStTextePasEtablissement              = 'L''�tablissement par d�faut n''est pas renseign�';
 cStTexteImputation                    = 'L''imputation n''est pas valide !';
 cStTexteMontantNegatif                = 'Vous ne pouvez pas saisir des montants n�gatifs';
 cStDateInfDateDebExo                  = 'La date saisie ne peut �tre inf�rieur � la date de d�but de l''exercice N';
 cStDateInfDateFinExo                  = 'La date saisie ne peut �tre sup�rieur � la date de fin de l''exercice N+1';
 cStTexteDateNonValide                 = 'La date sasie n''est pas valide ';
 cStTextePasF10                        = 'Vous ne pouvez pas enregistrer tant que le guide n''est pas fini';
 cStTexteEchap                         = 'Confirmez-vous l''abandon de la saisie ?';
 cStTexteModifLigneImputer             = 'La ligne � �t� modifi�, voulez vous reg�ner le guide ?';
 cStTexteSaisirCompte                  = 'Veuillez saisir un compte bancaire';
 cStTexteSaisirJournal                 = 'Veuillez saisir un journal de banque';
 cStTexteAucunGuideEtebac              = 'Il n''existe aucun guide pour ce journal, ' + #13#10 +
                                         'voulez vous quand m�me int�grer les fichiers ETEBAC ? ';
 cStTexteAucunGuide                    = 'Il n''existe aucun guide pour ce journal, ' + #13#10 +
                                         'Seules les imputations automatiques seront prises en compte !';
 cStTexteErreurEnr                     = 'Erreur lors de l''enregistrement de la ligne courante ! ' + #13#10 + 'valeur :';
 cStTexteErreurSoldeImput              = 'Erreur lors du calcul du soldes des imputations';
 cStTexteErreurAna                     = 'Erreur lors de l''enregistrement de l''analytique sur le champs : ';
 cStTexteGeneralInexistant             = 'Le compte d''imputation inexistant !' + #13#10 + 'valeur :';
 cStTexteDebitEtCreditNull             = 'Le d�bit et le cr�dit ne peuvent �tre nuls';
 cStTexteSoldeNonNull                  = 'L''imputation doit �tre �quilibr�e !' + #13#10 + 'valeur :';
 cStTexteErreurRecupImput              = 'Erreur sur la r�cup�ration des enregistrements de la grille ! ' + #13#10 +
                                         'Abandonner la saisie';
 cStTexteErreurImput                   = 'Erreur sur la validation de la ligne d''imputation ! ';
 cStTexteErreurAnalytiq                = 'Erreur sur l''analytique manuel !';
 cStTexteErreurTva                     = 'Erreur sur la r�cup�ration de la tva !' + #13#10 + 'valeur :';
 cStTexteTransfertReussie              = 'Transfert r�ussi';
 cStTexteConfirmIntegration            = 'Confirmer vous l''int�gration des �critures valides ?';
 cStTexteErreurGenerationEcart         = 'Erreur sur la g�n�ration des �carts de conversion';
 cStTexteErreurGeneContrePartie        = 'Erreur sur la g�n�ration des comptes de contrepartie';
 cStTexteErreurFormuleGuideIncorrect   = 'Erreur dans la formule du guide ';
 cStTexteEnrEnCours                    = 'Enregistrement en cours...';
 cStTexteTraitementEcr                 = 'Int�gration en cours...';

 cStVerrouTreso                        = 'nrTreso';

 type
 
  TModeAna            = ( TModeVisuAna, TModeAutoAna, TModeManuAna , TModeGuideAna);
  TTypeContexte       = ( TModeGuide, TModeAuto, TModeSaisie, TModeImport );

  TTypeLigneReleveBqe = ( TTypeReleve,TTypeImputation, TTypeCompteEuro);


implementation

end.
