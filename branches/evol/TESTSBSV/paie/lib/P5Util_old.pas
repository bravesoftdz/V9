{***********UNITE*************************************************
Auteur  ...... : Philippe Dumet
Cr�� le ...... : 30/05/2001
Modifi� le ... : 30/05/2001
Description .. : Unit de d�finition de toutes les variables n�cessaires
Suite ........ : aux calculs des bulletins
Suite ........ : Fonctions de calculs
Mots clefs ... : PAIE;PGBULLETIN;PGREGUL
*****************************************************************}
{
PT1   : 25/06/2001 PH V536 Suppression des Q.next
PT2   : 25/07/2001 VG V540 Ajout champs dans Historique salari�
PT3   : 31/07/2001 SB V547 Modification champ suffixe MODEREGLE
PT4   : 29/08/2001 PH V547 correction bornes de validit� remuneration sur 4 mois
PT5   : 29/08/2001 PH V547 correction bornes de validit� cotisaation sur 4 mois
PT6   : 30/08/2001 SB V547 Calcul du HCPPay�s fiche bug n� 294
PT7   : 03/09/2001 PH V547 correction validit� du au pour les r�mun�rations
PT8   : 03/09/2001 PH V547 on force dans tous les cas le calcul de l'arrondi sur
                           le montant calcul�
PT9   : 05/09/2001 SB V547 L'acquisition annuelle des CP ne correspond plus � 25
                           ou 30 mais � l'acquis mensuelle*12
                           On passe en parametre ETB_NBREACQUISCP et non
                           ETB_NBJOUTRAV
PT10  : 07/09/2001 PH V547 Test du profil FNAL on recherche le profil FNAL que
                           dans la table Salarie ou dans les paramsoc. test plus
                           s�v�re
PT11  : 10/09/2001 SB V547 Fiche de bug n�266 : Gestion des msg d'erreur CP en
                           prep auto . fn SalIntegreCP modifi�e (Aussi ds source
                           SaisBul)
PT12  : 02/10/2001 PH V562 Rajout historisation salarie profil r�mun�ration
PT13  : 15/10/2001 VG V562 Ajout champs dans Historique salari�
PT14  : 23/10/2001 PH V562 Rajout traitement bulletion compl�mentaire et dates
                           �dition
PT15  : 24/10/2001 PH V562 Calcul periode glissante pour variables de type cumul
                           ou rubrique
PT16  : 24/10/2001 PH V562 Date � date glissante dans le cas ou mois fin < mois
                           d�but
PT17  : 13/11/2001 SB V562 Prise de CP sur Acquis en cours
PT18  : 14/11/2001 PH V562 Identification du taux AT en fonction des dates de
                           validit�
PT19  : 16/11/2001 PH V562 Modif du calcul de la date de paiement dans le cas
                           bulletin compl�mentaire
PT20  : 20/11/2001 PH V562 Modif du calcul des dates d'�dition automatique en
                           fonction de l'�tablissement
PT21  : 20/11/2001 PH V562 Modif du calcul des variables recherchant un cumul
                           annuel + paie en cours
PT22  : 22/11/2001 PH V562 ORACLE, Le champ PHB_ORGANISME doit �tre renseign�
PT23  : 22/11/2001 SB V563 Pour ORACLE, Le champ PCN_CODETAPE doit �tre
                           renseign�
PT24  : 27/11/2001 PH V563 Propagation d'une ligne de commentaire
PT25  : 04/12/2001 PH V563 Mode de r�glement pour les bulletins compl�mentaires
PT26  : 19/12/2001 PH V571 Traitement ligne de commentaire pour les cotisations
PT27  : 26/12/2001 PH V571 D�doublement des lignes multiples de commentaire
PT28  : 27/12/2001 PH V571 Calcul des variables de type cumul en tenant compte
                           du mois de RAZ
PT29  : 27/12/2001 PH V571 Calcul des variables de type r�mun�ration tq sur
                           Mois - 1
PT30  : 27/12/2001 PH V571 Calcul des dates Trimestres,ann�es - X et en tenant
                           compte du d�calage
PT31  : 08/01/2002 MF V571 correction fct DiffMoisJour : initialisation de la
                           variable Calcul
PT32  : 07/02/2002 PH V571 suppression historisation salari�
PT33  : 19/03/2002 SB V571 Fiche de bug n�452 Ajout variable de paie pr�defini
                           Cegid : Heures et jours absences pris
PT34  : 22/03/2002 PH V571 Traitement de la civilit�  et de Mode r�glement
                           modifie dans la table Paieencours
PT35  : 26/03/2002 PH V571 Fonction de raz de ChptEntete
PT36  : 26/03/2002 PH V571 10eme ligne de calcul des variables de type calcul
PT37  : 02/04/2002 PH V571 traitement du profil retraite
PT38  : 03/04/2002 PH V571 Modif Calcul base de pr�carit�
PT39  : 04/04/2002 PH V571 Modif insertion rub contenant une variable de nature
                           cumul sur p�riode annuelle
PT40  : 04/04/2002 PH V571 Test si colonne cotisation saisissable
PT41  : 05/04/2002 PH V571 variable glissante sur X mois prennait 1 mois de trop
PT42  : 23/04/2002 SB V571 Fiche de bug 10003 : Calcul du montant de l'absence
                           non calcul� sur 1er bulletin en cr�ation
PT43  : 23/04/2002 SB V571 Fiche de bug 10021 : Ajout de la variable
                           HTHTRAVAILLES pour calcul heures th�oriques
                           travaill�s
PT44  : 29/04/2002 Ph V582 Rajout clause group by pour ????? forcer index
PT45  : 02/05/2002 Ph V582 initialisation du taux at au debut du traitement
PT46  : 02/05/2002 SB V571 Erreur : Pour un SLD, On consomme syst�matiquement
                           l'acquis en cours dans sa totalit� m�me si on ne
                           solde pas la totalit� sur ce mvt (cas AJU Ou AJP) du
                           fait de l'utilisation de pls tob pour l'integration
                           des acquis en cours
PT47  : 28/05/2002 PH V571 Modif Calcul base de pr�carit� Seuil ramen� � 0 jour
PT48  : 11/06/2002 PH V582 Modif des variables des noms des responsables pour
                           traiter tous les cas
PT49  : 18/06/2002 PH V582 Modif Refonte compl�te du calcul de la pr�carit�
PT50  : 01/07/2002 PH V582 modif sur calcul fourchette de dates pour les
                           variables de type cumul
PT51  : 19/06/2002 PH V582 Integration des lignes de la saisie des primes dans
                           le bulletin compl�mentaire Voir PT40 dans SaisBul
PT52-1: 18/07/2002 VG V585 Correction pr�carit� si un seul contrat et que la
                           date de d�but de contrat est la m�me que la date de
                           d�but de bulletin, on ne fait pas le calcul du
                           trenti�me, on prend la totalit� de la base
PT52-2: 19/07/2002 VG V585 Correction pr�carit� si plusieurs contrats dans le
                           cas de d�but et/ou fin de contrat en cours de mois
PT53  : 22/07/2002 SB V582 Modification du calcul des variables 65, 66
PT54  : 25/07/2002 SB V585 D� � l'int�gration des mvts d'annulation d'absences
                           Contr�le des requ�tes si typemvt et sensabs en
                           critere
PT55  : 09/08/2002 PH V582 Evaluation des variables de tests avec des strings
PT56  : 09/08/2002 PH V582 Creation des variables CEGID pour recup champs
                           salaries
PT57  : 05/09/2002 SB V585 Int�gration de la gestion salari� de la m�thode de
                           valorisation au maintien des CP
PT58  : 06/09/2002 PH V585 Variables pour restituer les elements de salaires 5
PT59  : 03/10/2002 SB V585 Optimisation requ�te saisie de la paie
PT60  : 07/10/2002 PH V585 Recherche d'un element national par pr�f�rence
                           DOS,STD,CEG
PT61  : 17/10/2002 SB V585 FQ n�10235 Int�gration du calcul des variables 28,29 heures ouvr�es ouvrables
PT62  : 07/11/2002 PH V591 Prise en compte du decalage de paie sur les �l�ments nationaux en fonction du champ
        decalage
PT63  : 07/11/2002 PH V591 Creation variable 80 rend le mois de la paie (datefin) FQ 10302
PT64  : 07/11/2002 PH V591 Variable de paie rend le taux patronal ou salarial FQ 10276
PT65  : 02/12/2002 PH V591 Recup des infos du bulletin pr�c�dent en excluant les bulletins compl�mentaires
PT66  : 06/12/2002 PH V591 Variable 2 rend horaire Hebdo de la fiche salari�
PT67  : 06/12/2002 PH V591 Nouvelles Variables 72 � 75 + modif 70 et 71
PT68  : 19/12/2002 PH V591 Affectation de la date de paiement � la date de fin de paie si non renseign�e
PT69-1  14/01/2003 SB V591 Suppression des lignes de commentaire CP inop�randes si modification date de fin de bulletin
PT69-2  16/01/2003 SB V591 Calcul variable 50 : Integration du solde que si salari� sorti
PT70  : 23/01/2003 PH V591 Correction du calcul des bornes de dates pour la valorisation d'un cumul ant�rieur avec une p�riode de raz
PT71   30/01/2003 V591 SB Vidage Tob_Abs en sortie et r� entr�e de bulletin
PT72  : 05/02/2003 PH V595 Traitement des tables dossiers en string au lieu d'integer
PT73  : 05/02/2003 PH V595 Tables dossier g�rent aussi une �l�ment national comme retour
PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
PT75-1: 02/06/2003 SB V595 FQ 10705 Mvt SLD de Cloture non valoris�..
PT75-2: 04/06/2003 SB V595 FQ 10523 Int�gration de l'acquis bulletin calcul� sur une variable de paie
PT76  : 04/06/2003 PH V_421 FQ 10425,10620,10655 nvelles variables
PT77  : 04/06/2003 PH V_421 FQ 10689 Salari� sort dans la p�riode mais la cotisation ne se calcule que si le salari� est present le dernier jour du mois
PT78  : 05/06/2003 PH V_421 FQ 10700 Gestion origine de la rubrique dans les bases de cotisations
PT79-1: 06/06/2003 SB V595 Test minimum conventionnel en alpha m�me pour du numerique
PT80  : 11/06/2003 PH V_421 Modification fct de contr�le division par 0 Pour tester si 0.xxx au lieu de O
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
PT81  : 23/06/2003 PH V_421 Modif variables 72,73,74 FQ 10565  appel variable 35 au lieu de 65 Horaire etablissment
PT82-1 : 24/06/2003 SB V_42 FQ 10454 Calcul au maintien sur premier bulletin implique un recalcul des CP
PT82-2 : 25/06/2003 SB V_42 FQ 10717 Calcul nombre de mois anciennete erron� : Nombre de mois entier
PT83-3 : 27/06/2003 SB V_42 FQ 10628 Int�gration procedure � part de l'init des variables heures et jours travaill�s
PT83-4 : 11/08/2003 SB V_42 FQ 10675 Gestion des lignes de commentaire CP par type
PT84   : 26/08/2003 PH V_42 Mise en place saisie arret
PT85   : 09/09/2003 PH V_42 Correction variable 75,74
PT86   : 17/09/2003 PH V_421 Traitement des tables DIW pour une variable de type valeur (idem DIV)
PT87   : 06/10/2003 PH V_421 FQ 10595 Gstion des apppoints avec date de sortie
PT88   : 10/10/2003 SB V_42 Int�gration d'un indicateur des CP pris non pay�s par manque d'acquis
PT89   : 21/10/2003 PH V_42 FQ 10928 Recup de l'appoint precedant en n�gatif sinon mauvais sens
PT90   : 18/11/2003 SB V_50 FQ 10794 Controle profil Cong�s pay�s existant
PT90-1 : 18/11/2003 SB V_50 FQ 11121 Contr�le rubrique aliment� pour g�n�ration libell� CP
PT91   : 05/12/2003 PH V_50 Cr�ation de la variable 103 FQ 11002
PT92   : 10/12/2003 PH V_50 Recalcul syst�matique de la saisie arr�t
PT93   : 11/12/2003 PH V_50 initialisation valeur par defaut FQ 11003
PT94   : 18/12/2003 PH V_50 FQ 11028 Calcul des cotisations que si pr�sent en fin de mois-traitement de la date � idate1900
PT95   : 12/01/2004 PH V_50 FQ 11024 Rubrique sur le bulletin en origine salari� reprend les valeurs m�me si elt variable
PT96   : 24/02/2004 SB V_50 FQ 11130 Calcul Anciennet� �rronn� si salari� entr�e sortie le m�me jour
PT97   : 18/03/2004 SB V_50 FQ 11020 Modification utilisateur des acquis sur la saisie de la paie
PT98   : 19/03/2004 PH V_50 FQ 11200 Prise en compte de nbre de d�cimales dans le calcul des variables
PT99   : 19/03/2004 PH V_50 FQ 11106 Variable 0070 et 0071
PT100  : 05/04/2004 PH V_50 FQ 11231 Prise en compte du cas sp�cifique Alsace Lorraine
PT100-1: 09/04/2004 SB V_50 FQ 11136 Ajout Gestion des cong�s pay�s niveau salari�
PT100-2: 09/04/2004 SB V_50 FQ 11237 Ajout Gestion idem etab jours Cp Suppl
PT101    07/05/2004 SB V_50 FQ 11199 Dysfonctionnement Calcul Indemnit� CP sur 1er bulletin
PT102    10/05/2004 PH V_50 restriction droit acc�s au param�trage CEGID
PT103    17/06/2004 MF V_50 Ajout traitement de suppression des IJSS
PT104    21/06/2004 PH V_50 FQ 10793 Indicateur de contr�le de modification des salari�s pdt la saisie du bulletin
PT105    22/06/2004 PH V_50 Correction fonction RendDateVar ==> calcul de variable de type cumul sur trimestre
PT106    23/06/2004 PH V_50 FQ 11380 Principe en modification de bulletin pas d'alignement des rubriques par rapport aux profils
                                     en cr�ation alignement, bouton D�faire ou revenir � l'�tat initial provoque l'alignement
PT107    23/06/2003 MF V_50 IJSS- Modif message qd ligne non modifiable-->modif PHB_ORIGINELIGNE
PT108    05/07/2004 PH V_50 FQ 11052 Modif Fiche ETABSOCIAL et contr�le sur les dates d'�dition
PT109    05/07/2004 PH V_50 FQ 10959 Nouvelles variables pr�d�finies CEGID
PT110    06/07/2004 PH V_50 FQ 10991 Nouvelles variables pr�d�finies CEGID
PT111    12/07/2004 PH V_50 FQ 11410 Nouvelles variables pr�d�finies CEGID
PT112    10/08/2004 PH V_50 FQ 11464 Prise en compte de la p�riode en cours pour les variables de type rem,cot
PT113    12/08/2004 PH V_50 FQ 11148 Prise en compte du montant de l'acompte dans le calcul de la saisie arret
PT114    19/08/2004 PH V_50 FQ 11432 Message et non calcul d'une variable si celle-ci n'existe pas sionon provoque un ACCESS VIO
PT115    19/08/2004 PH V_50 FQ 10991 Suite : inversion du calcul en fonction du code de la rubrique Mois et Ann�e
PT116    20/08/2004 PH V_50 FQ 10959 R�cup�ration du champ sortie d�finitive
PT117    23/08/2004 PH V_50 FQ 11459 Limitation des trenti�mes si 2 bulletins dans le m�me mois
PT118    23/08/2004 PH V_50 FQ 11425 Variable 140
PT119    23/08/2004 PH V_50 FQ 11429 et 11306 Variable recherchant une table Divers
PT120    24/08/2004 PH V_50 FQ 11454 Suite Si pas �l�ment Nat trouv� alors on rend 0
PT121    25/08/2004 MF V_50 Ajout traitement de suppression des lignes de maintien
PT122    13/09/2004 PH V_50 FQ 10992 Variable 0092 Nombre de jours calendaires du mois
PT123    23/09/2004 PH V_50 FQ 11638 Calcul apprenti sur mauvaise variable
PT124    30/11/2004 MF V_60 ajout de commentaires pour le maintien
PT125    02/12/2004 PH V_60 FQ 11818 Calcul automatique de la variable 0033
PT126    23/12/2004 PH V_60 Prise en compte variable de type cumul sur p�riode annuelle
                            pour le 1er mois dans le cas du d�calage de paie
PT127-1  21/01/2005 SB V_60 FQ 11889 Calcul Cp Acquis sur variable de paie
PT127-2  21/01/2005 SB V_60 FQ 11882 Calcul Indemnit� & absence indemnit� CP
PT128    03/02/2005 SB V_60 FQ 11089 Calcul erronn� anciennet� en jours variable 0010
PT129    08/02/2005 MF V_60 Traitement des commentaires des r�glements d'IJSS (2 nvelles fcts)
}
unit P5Util;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Hent1, HCtrls, ComCtrls, HRichEdt, HRichOLE, HMsgBox, HStatus,
  ExtCtrls, Grids, ImgList, Mask, ClipBrd, richedit, UTOB, P5Def, M3VM, ParamSoc, EntPaie,
  PGVisuObjet,
  // added BY XP le 13-03-2003
  uPaieVariables,
  uPaieRemunerations,
  uPaieCotisations,
  uPaieBases,
  uPaieProfilsPaie,
  uPaieCumuls,
  uPaieEltNatDOS,
  uPaieEltNatSTD,
  uPaieEltNatCEG,
  uPaieEtabCompl,
  uPaieMinConvPaie,
  uPaieMinimumConv,
  uPaieVentiRem,
  uPaieVentiCot,
{$IFNDEF EAGLCLIENT}
  DBTables, M3Code, Fe_Main;
{$ELSE}
  MaineAGL;
{$ENDIF}
const
  SG_Rub: integer = 0;
  SG_Lib: integer = 1;
  SG_Base: integer = 2;
  SG_Taux: integer = 3;
  SG_Coeff: integer = 4;
  SG_Mt: integer = 5;
  SG_TxSal: integer = 3;
  SG_MtSal: integer = 4;
  SG_TxPat: integer = 5;
  SG_MtPat: integer = 6;
  SG_Origine: integer = 6;
  SG_Plfd: integer = 3;
  SG_Tr1: integer = 4;
  SG_Tr2: integer = 5;
  SG_Tr3: integer = 6;
  SG_Plf1: integer = 7;
  SG_Plf2: integer = 8;
  SG_Plf3: integer = 9;

  // Definition de champs mis � jour pendant la saisie du bulletin
type
  TChampBul = record { PT97 Ajout champ }
    Reglt: string;
    DatePai, DateVal: TDateTime;
    HorMod, BasesMod, TranchesMod, TrentMod: Boolean;
    DTrent, NTrent: Integer;
    Ouvres, Houvres, Ouvrables, HOuvrables, HeuresTrav: Double; {PT61 ajout Heures ouvr�es & ouvrables}
    // PT34 : 22/03/2002 PH V571  Civilt� et mode reglement modifi�
    RegltMod: Boolean;
    // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
    Edtdu, Edtau: TDateTime;
    CpAcquisMod: Boolean;
    CpAcq, CpSupl, CpAnc: Double;
  end;
  // Definition d'un type record pour calculer toutes les infos � la fois
type
  TRendRub = record
    MontRem,
      BasRem,
      TauxRem,
      CoeffRem,
      BasCot,
      TSal,
      MSal,
      TPat,
      MPat,
      Plfd1,
      Tr1,
      Tr2,
      Tr3,
      Base,
      Plfd2,
      Plfd3: double;
  end;
  // PT32 : 07/02/2002 PH V571 suppression historisation salari�
  {
  Type HistoSal = class //pour l'historisation du salari�
                  salarie       : String;
                  CodeEmploi    : string;
                  LibelleEmploi : string;
                  Qualification : string;
                  Coefficient   : string;
                  Indice        : string;
                  Niveau        : string;
                  CodeStat      : string;
                  TravailN1     : string;
                  TravailN2     : string;
                  TravailN3     : string;
                  TravailN4     : string;
                  Groupepaie    : string;
                  SalaireMois1  : double;
                  SalaireAnn1   : double;
                  SalaireMois2  : double;
                  SalaireAnn2   : double;
                  SalaireMois3  : double;
                  SalaireAnn3   : double;
                  SalaireMois4  : double;
                  SalaireAnn4   : double;
                  Horairemois   : double;
                  Horairehebdo  : double;
                  HoraireAnnuel : double;
                  TauxHoraire   : double;
                  Dtlibre1      : tdatetime;
                  Dtlibre2      : tdatetime;
                  Dtlibre3      : tdatetime;
                  Dtlibre4      : tdatetime;
                  Boollibre1    : string;
                  Boollibre2    : string;
                  Boollibre3    : string;
                  Boollibre4    : string;
                  CSlibre1      : string;
                  CSlibre2      : string;
                  CSlibre3      : string;
                  CSlibre4      : string;
                  Profil        : string;
                  PeriodBul     : string;
  //PT-12 02/10/01 V562 PH Rajout historisation salarie profil r�mun�ration
                  ProfilRem     : string;
  //PT2
                  DADSProfessio : string;
                  DADSCategorie : string;
                  TauxPartiel   : string;
                  Condemploi    : string;//PT13

                  Bsalarie       : Char;
                  BCodeEmploi    : Char;
                  BLibelleEmploi : Char;
                  BQualification : Char;
                  BCoefficient   : Char;
                  BIndice        : Char;
                  BNiveau        : Char;
                  BCodeStat      : Char;
                  BTravailN1     : Char;
                  BTravailN2     : Char;
                  BTravailN3     : Char;
                  BTravailN4     : Char;
                  BGroupepaie    : Char;
                  BSalaireMois1  : Char;
                  BSalaireAnn1   : Char;
                  BSalaireMois2  : Char;
                  BSalaireAnn2   : Char;
                  BSalaireMois3  : Char;
                  BSalaireAnn3   : Char;
                  BSalaireMois4  : Char;
                  BSalaireAnn4   : Char;
                  BDtlibre1      : Char;
                  BDtlibre2      : Char;
                  BDtlibre3      : Char;
                  BDtlibre4      : Char;
                  BBoollibre1    : Char;
                  BBoollibre2    : Char;
                  BBoollibre3    : Char;
                  BBoollibre4    : Char;
                  BCSlibre1      : Char;
                  BCSlibre2      : Char;
                  BCSlibre3      : Char;
                  BCSlibre4      : Char;
                  BProfil        : Char;
                  BPeriodBul     : Char;
  //PT-12 02/10/01 V562 PH Rajout historisation salarie profil r�mun�ration
                  BProfilRem     : Char;
                  BHorairemois   : Char;
                  BHorairehebdo  : Char;
                  BHoraireAnnuel : Char;
                  BTauxHoraire   : Char;
  //PT2
                  BDADSProfessio : Char;
                  BDADSCategorie : Char;
                  BTauxPartiel   : Char;
                  BCondemploi    : Char;//PT13
                  END ;
  }
  // FIN PT32
var
  TOB_Paie, // Tob liste des paies entete
  TOB_RemSal, // Tob liste des r�mun�rations type Salaires
  TOB_RemAbs,
    TOB_RemAbt,
    TOB_RemAvt,
    TOB_RemCplt,
    TOB_RemPrimes,
    TOB_RemHeures,
    TOB_RemNonImp,
    TOB_RemRet,
{$IFDEF aucasou}
  TOB_ProfilPaies, // Tob liste des Profils
  TOB_Cotisations, // Tob Liste des Cotisations
  TOB_Bases, // Tob Liste des rubriques Base de cotisations
  TOB_ProfilRubs, // Tob liste des rubriques composant les profils
  TOB_Rem, // Tob Liste de TOUTES les r�mun�rations
  TOB_Variables, // Tob liste des Varaibles
  TOB_Cumuls, // TOb liste des cumuls g�r�s par la paie
  TOB_Etablissement, // Tob liste des �tablisssements de la paie pour r�cup�rer le param�trage par d�faut des profils
  TOB_EltNationauxCEG: tob; // Tob des �l�ments nationaux CEGID
  TOB_EltNationauxSTD: tob; // Tob des �l�ments nationaux STANDARD
  TOB_EltNationauxDOS: tob; // Tob des �l�ments nationaux Dossier
{$ENDIF}
  TOB_HistoBasesCot, // TOB historiques des Bases de Cotisation
  TOB_Salarie, // Tob contenant le salari� sur lequel on positionn�
  TOB_CumulSal, // Tob des  Historiques cumuls salaries - Cumuls alimentes par les rubriques du bulletin
  TOB_JourTrav, // TOB calendrier des jours travaill�s
  TOB_ExerSocial, // TOB des exercices sociaux g�r�s
  //    TOB_Minimum,             // TOB des tables Dossiers Minimum Conventionnels, Age, Anciennete, Coeff, Qualif, Indices, niveaux
  //    TOB_DetailMin,           // TOB D�tails des intervalles des tables dossiers
  TOB_Pris, // TOB Cong�s pay�s pris pour le salari�
  TOB_Acquis, // TOB Cong�s pay�s Acquis pour le salari�
  TOB_Solde, // TOB Cong�s pay�s solde pour le salari�
  TOB_ABS, // Tob des absences du salari�
  Tob_VenRem, // Tob des ventilations analytiques des remunerations par defaut
  Tob_VenCot, // Tob des ventilations analytiques des Cotisations par defaut
  //    Tob_VentilRem,           // Tob des preventilations analytiques des remunerations pour recuperer le numero de compte
  //    Tob_VentilCot,           // Tob des preventilations analytiques des Cotisations pour recuperer le numero de compte
  TOBAna, // TOB des ventilations analytiques du bulletin
  TOB_AcquisAVirer, // Tob des acquis � virer
  T_MvtAcquisAVirer, // Tob des acquis en cours � virer
  TOB_PSD, // Tob de HistoSaisRub
  // PT51 : 20/06/2002 PH V582 Traitement des lignes de la saisie des primes
  TOB_PSP, // Tob de HistoSaisPrim
  T_MvtAcquis, // Tob des mvts acquis du bulletin
  Tob_CalendrierSalarie, // Tob calendrier Salarie PT61 nouvel tob
  // PT84   : 26/08/2003 PH V_42 Mise en place saisie arret
  TOB_SaisieArret // Tob contenant les saisies arr�ts
  : TOB; // Tob de la paie en cours de traitement contient Entete + ligne

var
  ForceAlignProfil: Boolean; // PT106 Pour force la la mise � jour des rubriques des profils
  DroitCegPaie: Boolean; // PT102 10/05/2004 PH V_50 restriction droit acc�s au param�trage CEGID
  Codsal: string;
  // PT14 : 23/10/2001 V562 PH Gestion cas particulier du bulletin compl�mentaire
  BullCompl, ProfilSpec: string; // Bulletin compl�m�ntaire X ou -  correspondra � un Boolean dans la table et son profil
  RegimeAlsace: string; // PT100  : 05/04/2004 PH V_50 FQ 11231 Prise en compte du cas sp�cifique Alsace Lorraine
  TypeTraitement: string; // indique si SAISIE ou PREPA (preparati�on automatique)
  Trentieme: Double = -1;
  Suivant, OrdreArrBull: integer; // no d'ordre pour insertion mvt ds table absencesalarie
  //OrdreArrBull : num�ro ordre de l'arrondi cr�� ds le bulletin
  TOB_PaieTraite: TOB;
  DateSSalarie: Tdatetime; // date de sortie du salari�
  GrilleBull: THGrid; // Grille active en saisie de bulletin pour recuperer les infos saisies
  TraceERR: TListBox; // Composant Trace gestion des erreurs pour conserver les anamalies de la paie sans arreter le pgm
  ChpEntete: TChampBul; // Definition d'une structure des champs entete mis � jour par la saisie de bulletin
  ActionSLD, ActionBulCP: TActionBulletin;
  Chargement, PP, TopJPAVANTBULL, ACquisMaj: boolean; // AcquisMaj : �criture depuis le load par calculvalocp
  ValoXP0N, ValoXP0D, JPAVANTBULL: double;
  TauxAT: double; // Taux AT constat� sur le bulletin
  HCPPRIS, // Heures CP pris dans la session
  HCPPAYES, // Heures CP payees dans la session
  HCPASOLDER, // Heures CP � solder dans la session
  JCPACQUIS, // Jours CP acquis dans la session
  JCPACQUISACONSOMME, // Valeur a consomm� sur Jours CP acquis dans la session  // PT17
  JCPACQUISTHEORIQUE, // Jours CP acquis th�orique PT75-2
  MCPACQUIS, // Mois acquis ds la session (trentieme)
  BCPACQUIS, // Base acquis ds la session
  JCPPRIS, // Jours CP pris dans la session
  JCPSOLDE, // Jours CP de type solde pay� ds la session
  JCPPAYES, // Jours CP pay�s dans la session
  JCPPAYESPOSES, // Jours CP pris � int�grer dans la session PT88
  JCPASOLDER, // Jours CP A Solder dans la session
  CPMTABS, // CP Montant Absence
  CPMTINDABS, // CP Montant Indemnite Absence
  CPMTABSSOL, // CP Montant Absence Solde
  CPMTINDABSSOL, // CP Montant Indemnite Absence Solde
  CPMTINDCOMP, // CP Montant Indemnite compensatrice
  ASOLDERAVBULL, // CP � solder hormis ceux du bulletin courant
  JRSAARRONDIR, // CP de la p�riode � solder hors acquis bulletin
  JTHTRAVAILLES, // Jours th�orique travaill�s par le salari� sur la p�riode
  HTHTRAVAILLES, // Heures th�oriques travaill�es par le salari� sur la p�riode //PT43
  PAYECOUR, // pay� sur ce qu'on est en train d'acqu�rir-permet de positionner
  // APAYE3 en alimcongeacquis
  HABSPRIS, //Heure Absence pris  PT33 Ajout nouvels variable
  JABSPRIS: Double; //Jour Absence pris   PT33
  SLDCLOTURE: Boolean; //PT75-1 Indique s'il existe un mvt de solde provenant de la cl�ture CP
  FirstBull: Boolean; { PT101 }
  TopRecalculCPBull: Boolean = False; //PT82-1 Si cumul 12 (maintien) = 0 alors TopRecalculCPBull := True;
  ObjTM3VM: TM3VM; // Objet pour evaluation des variables, utilisation VM du script
  // PT32 : 07/02/2002 PH V571 suppression historisation salari�
  //    TheHistoSal : HistoSal;

  // Gestion des absences d�port�es Salarie,Administrateur ,Responsable validation
  // PT48 : 11/06/2002 PH V582 Modif des variables des noms des responsables pour traiter tous les cas
  LeSalarie, LeNomSal, SalAdm, SalVal: string;
  NotSalAss, ConsultP: Boolean; // Acces en consultation uniquement
  PopUpSalarie: Boolean; // PT104 Restriction � la consultion des salari�s pdt la saisie des bulletin
  // Optimisations
  TOB_DUSALARIE: TOB;
  iPCR_CUMULPAIE, iPCR_SENS, iPCL_ALIMCUMUL, iPCL_ALIMCUMULCOT, iPCL_COEFFAFFECT: Integer;
  iPHC_MONTANT, iPHC_ETABLISSEMENT, iPHC_SALARIE, iPHC_DATEDEBUT, iPHC_DATEFIN, iPHC_REPRISE: Integer;
  iPHC_CUMULPAIE, iPHC_TRAVAILN1, iPHC_TRAVAILN2, iPHC_TRAVAILN3, iPHC_TRAVAILN4, iPHC_CODESTAT: Integer;
  iPHC_CONFIDENTIEL, iPHC_LIBREPCMB1, iPHC_LIBREPCMB2, iPHC_LIBREPCMB3, iPHC_LIBREPCMB4: Integer;
  iPHB_BASEREM, iPHB_MTREM, iPHB_BASECOT, iPHB_MTSALARIAL, iPHB_MTPATRONAL, iPHB_ORIGINEINFO: Integer;
  iPHB_ETABLISSEMENT, iPHB_SALARIE, iPHB_DATEDEBUT, iPHB_DATEFIN, iPHB_NATURERUB, iPHB_RUBRIQUE: Integer;
  iPHB_LIBELLE, iPHB_IMPRIMABLE, iPHB_TAUXREM, iPHB_COEFFREM, iPHB_TAUXSALARIAL, iPHB_TAUXPATRONAL, iPHB_BASEREMIMPRIM: Integer;
  iPHB_TAUXREMIMPRIM, iPHB_COEFFREMIMPRIM, iPHB_BASECOTIMPRIM, iPHB_TAUXSALIMPRIM, iPHB_TAUXPATIMPRIM, iPHB_ORGANISME: Integer;
  iPHB_TAUXAT, iPHB_PLAFOND, iPHB_PLAFOND1, iPHB_PLAFOND2, iPHB_PLAFOND3, iPHB_CONSERVATION, iPHB_ORDREETAT, iPHB_SENSBUL: Integer;
  iPHB_TRAVAILN1, iPHB_TRAVAILN2, iPHB_TRAVAILN3, iPHB_TRAVAILN4, iPHB_CODESTAT, iPHB_CONFIDENTIEL: Integer;
  iPHB_TRANCHE1, iPHB_TRANCHE2, iPHB_TRANCHE3, iPHB_LIBREPCMB1, iPHB_LIBREPCMB2, iPHB_LIBREPCMB3, iPHB_LIBREPCMB4: Integer;
  iPRM_IMPRIMABLE, iPRM_BASEIMPRIMABLE, iPRM_TAUXIMPRIMABLE, iPRM_COEFFIMPRIM, iPRM_ORDREETAT, iPRM_SENSBUL: Integer;
  iPRM_THEMEREM, iPRM_DECBASE, iPRM_DECTAUX, iPRM_DECCOEFF, iPRM_DECMONTANT: Integer;
  iPRM_LIBELLE, iPHB_ORIGINELIGNE: Integer;
  iPCT_IMPRIMABLE, iPCT_BASEIMP, iPCT_TXSALIMP, iPCT_ORGANISME, iPCT_ORDREETAT, iPCT_LIBELLE, iPCT_DU, iPCT_AU: Integer;
  iPCT_MOIS1, iPCT_MOIS2, iPCT_MOIS3, iPCT_MOIS4, iPCT_DECBASE, iPCT_TYPEBASE, iPCT_TYPETAUXSAL, iPCT_TAUXSAL, iPCT_DECTXSAL: Integer;
  iPCT_TYPETAUXPAT, iPCT_TAUXPAT, iPCT_DECTXPAT, iPCT_TYPEFFSAL, iPCT_FFSAL, iPCT_DECMTSAL, iPCT_TYPEFFPAT, iPCT_FFPAT, iPCT_DECMTPAT: Integer;
  iPCT_TYPEMINISAL, iPCT_VALEURMINISAL, iPCT_TYPEMAXISAL, iPCT_VALEURMAXISAL, iPCT_TYPEMINIPAT, iPCT_VALEURMINIPAT: Integer;
  iPCT_TYPEMAXIPAT, iPCT_VALEURMAXIPAT, iPCT_DECBASECOT, iPCT_SOUMISREGUL, iPCT_BASECOTISATION, iPCT_TXPATIMP: Integer;
  iPCT_TYPEPLAFOND, iPCT_PLAFOND, iPCT_TYPETRANCHE1, iPCT_TYPETRANCHE2, iPCT_TYPETRANCHE3, iPCT_TYPEREGUL: Integer;
  iPCT_TRANCHE1, iPCT_TRANCHE2, iPCT_TRANCHE3, iPCT_ORDREAT, iPCT_CODETRANCHE, iPCT_PRESFINMOIS: Integer;
  iCHampPredefini, iCHampDossier, iCHampCodeElt, iCHampDateValidite, iCHampDecaleMois, iChampMontant, iChampMontantEuro, iChampRegimeAlsace: Integer; // PT100
  iPSA_SALARIE, iPSA_ETABLISSEMENT, iPSA_TRAVAILN1, iPSA_TRAVAILN2, iPSA_TRAVAILN3, iPSA_TRAVAILN4, iPSA_CODESTAT, iPSA_LIBREPCMB1: Integer;
  iPSA_LIBREPCMB2, iPSA_LIBREPCMB3, iPSA_LIBREPCMB4, iPSA_CONFIDENTIEL, iPSA_TAUXHORAIRE, iPSA_SALAIREMOIS1, iPSA_SALAIREMOIS2, iPSA_SALAIREMOIS3: Integer;
  iPSA_SALAIREMOIS4, iPSA_SALAIREMOIS5, iPSA_SALAIRANN1, iPSA_SALAIRANN2, iPSA_SALAIRANN3, iPSA_SALAIRANN4, iPSA_SALAIRANN5, iPSA_DATENAISSANCE, iPSA_DATEENTREE: Integer;
  iPSA_DATESORTIE, iPSA_TYPPROFILREM, iPSA_PROFILREM, iPSA_TYPPROFIL, iPSA_PROFIL, iPSA_TYPPERIODEBUL, iPSA_PERIODBUL: Integer;
  iPSA_TYPPROFILRBS, iPSA_PROFILRBS, iPSA_TYPREDREPAS, iPSA_REDREPAS, iPSA_TYPREDRTT1, iPSA_REDRTT1, iPSA_TYPREDRTT2, iPSA_REDRTT2: Integer;
  iPSA_PROFILTPS, iPSA_TYPPROFILAFP, iPSA_PROFILAFP, iPSA_TYPPROFILAPP, iPSA_PROFILAPP, iPSA_TYPPROFILRET, iPSA_PROFILRET: Integer;
  iPSA_TYPPROFILMUT, iPSA_PROFILMUT, iPSA_TYPPROFILPRE, iPSA_PROFILPRE, iPSA_TYPPROFILTSS, iPSA_PROFILTSS, iPSA_TYPPROFILCGE, iPSA_PROFILCGE: Integer;
  iPSA_PROFILCDD, iPSA_PROFILMUL, iPSA_TYPPROFILFNAL, iPSA_PROFILFNAL, iPSA_TYPPROFILTRANS, iPSA_PROFILTRANS, iPSA_TYPPROFILANC, iPSA_PROFILANCIEN: Integer;
  iPSA_LIBELLE, iPSA_PRENOM, iPSA_NUMEROSS, iPSA_ADRESSE1, iPSA_ADRESSE2, iPSA_ADRESSE3, iPSA_CODEPOSTAL, iPSA_VILLE, iPSA_INDICE, iPSA_NIVEAU, iPSA_CONVENTION: Integer;
  iPSA_CODEEMPLOI, iPSA_AUXILIAIRE, iPSA_DATEANCIENNETE, iPSA_QUALIFICATION, iPSA_COEFFICIENT, iPSA_LIBELLEEMPLOI, iPSA_CIVILITE, iPSA_CPACQUISMOIS, iPSA_NBREACQUISCP: Integer;
  iPSA_TYPDATPAIEMENT, iPSA_MOISPAIEMENT, iPSA_JOURPAIEMENT, iPSA_TYPREGLT, iPSA_PGMODEREGLE, iPSA_REGULANCIEN, iPSA_HORHEBDO, iPSA_HORAIREMOIS, iPSA_HORANNUEL: Integer;
  iPSA_PERSACHARGE, iPSA_PCTFRAISPROF, iPSA_MULTIEMPLOY, iPSA_SALAIREMULTI, iPSA_ORDREAT, iPSA_SALAIRETHEO, iPSA_DATELIBRE1, iPSA_DATELIBRE2, iPSA_DATELIBRE3: Integer;
  iPSA_DATELIBRE4, iPSA_VALANCCP, iPSA_ANCIENNETE, iPSA_CALENDRIER, iPSA_STANDCALEND, iPSA_BOOLLIBRE1, iPSA_BOOLLIBRE2, iPSA_BOOLLIBRE3, iPSA_BOOLLIBRE4: Integer;
  iPSA_DADSPROF, iPSA_DADSCAT, iPSA_TAUXPARTIEL, iPSA_CPTYPEMETHOD, iPSA_VALORINDEMCP, iPSA_CPTYPEVALO, iPSA_MVALOMS, iPSA_VALODXMN, iPSA_CPACQUISANC, iPSA_BASANCCP: Integer;
  iPSA_DATANC, iPSA_TYPDATANC, iPSA_DATEACQCPANC, iPSA_NBRECPSUPP, iPSA_CPTYPERELIQ, iPSA_RELIQUAT, iPSA_SORTIEDEFINIT, iPSA_SEXE, IPSA_CONDEMPLOI: Integer;
  iPSA_CONGESPAYES, iPSA_CPACQUISSUPP, iPSA_ANCIENPOSTE: integer; { PT100-1 & PT100-2 }
  // optimisation
procedure MemorisePsa(Unsal: TOB);
procedure MemorisePrm(UneRem: TOB);
procedure MemorisePel(UnElt: TOB);
procedure MemorisePct(UneCot: TOB);
procedure MemorisePcl(TRechCum: TOB);
procedure MemorisePcr(TRechRub: TOB);
procedure MemorisePhb(THB: TOB);
procedure MemorisePhc(UneTob: TOB);
function NumChampTobS(const zz: string; const Ind: Integer): Integer;
function NumChampProfS(const Ch: string): Integer;
// Fin optimisation

// Charge l'ensemble des rubriques composant le bulletin en fonction des profils du salari�
// PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
function ChargeRubriqueSalarie(Salarie: TOB; DateDeb, DateFin: TDateTime; ActionB: TActionBulletin; MtEnvers: Double; TheProfilPart: string): TOB;
procedure ChargeLesTOBPaie; // charge toutes les TOB pour le calcul du bulletin
procedure ChargeLesExercPaie(const DateDeb, DateFin: TDateTime); // Idnetification de l'zxercice social sur lequel on travaille
procedure VideLesTOBPaie(AvecInit: Boolean); // detruit les TOB pour le calcul du bulletin
procedure VideLaTobExer; // detruit la tob contenant l'exercice social
procedure InitLesTOBPaie; // Initialisation des TOB pour le calcul du bulletin
function ValEltNat(const Elt: string; const DatVal: TDateTime): double; // Rend Valeur Element National
function ValCumulDate(const Cumul: string; const DateDebut, DateFin: TDateTime): double; // Rend la valeur d'un cumul de date � date
function ValRubDate(const Rubrique: string; Nature: string; const DateDebut, DateFin: TDateTime): TRendRub; // idem sur une rubrique
function TauxHoraireSal(): double; // Rend Taux Horaire fiche Salari�
function SalaireMensuelSal(): double; // Rend Salaire Mensuel Fiche Salarie
function SalaireAnnuelSal(): double; // Rend Salaire Annuel Fiche Salari�
function CalculTrentieme(const DateDebut, DateFin: TDateTime; TestPaie: Boolean = FALSE): Integer; // Calcul le numerateur du trentieme
function EstDebutMois(const LaDate: TDateTime): boolean; // Indique si la date est le d�but d'un mois
function EstFinMois(const LaDate: TDateTime): boolean; //  Indique si la date est la fin d'un mois
function DiffMoisJour(const DateDebut, DateFin: TDateTime; var NbreMois, NbreJour: Integer): Boolean; // Calcule difference de date � date en mois et jours restants
function AncienneteAnnee(const DateEntree, DateFin: TDateTime): WORD; // Rend le nbre Annee Anciennete entre Date Entree et date du jout
function AncienneteMois(const DateEntree, DateFin: TDateTime): WORD; // Rend le nbre Mois Anciennete entre Date Entree et date du jout
procedure AgeSalarie(const DateFin: TDateTime; var Annee, Mois: WORD); // Rend Age du Salarie en Mois et en Annee
function RendCumulSalSess(const Cumul: string): double; // rend la valeur du cumul salari� calcul� dans la session de paie
procedure RechercheProfil(const Champ1, Champ2: string; Salarie, T_Etab, TPE: TOB); // Recherche en cascade d'un profil � partir du salari� � l'�tablissement
procedure MajRubriqueBulletin(TPE, TPR: TOB; const CodSal, Etab: string; const DateDeb, DateFin: TDateTime); // recup des rubriques du bulletin pr�c�dent et des �l�ments permanents
procedure RecupEltPermanent(TPE, TPR: TOB; const Rubrique: string; Conservation: string = '');
// PT95 // Recup�ration des �l�ments permanents du bulletin pr�c�dent sur les r�mun�rations
procedure AligneProfil(Salarie, T_Etab, TPE: TOB; ActionB: TActionBulletin); // Aligne les lignes du bulletin sur les profils du salari�
procedure AlimCumulSalarie(THB: TOB; const Salarie, NatureRub, Rubrique, Etab: string; const DateDebut, DateFin: TDateTime);
// Alimentation des cumuls Salari�s pour unn salari�,une rubrique
procedure RazTPELignes(TPE: TOB); // Fonction qui d�truit les TOB filles de TPE (destructioon de la TOB des lignes Bulletins)
procedure GrilleAlimLignes(TPE: TOB; Etab, Salarie, Nature: string; DateDebut, DateFin: TDateTime; GrilleBulletin: THGrid; ActionBul: TActionBulletin);
// Fonction qui alimente les lignes de bulletins en fonction de la grille de Saisie
procedure CreationTOBCumSal; // Creation de la TOB des Cumuls Salaries g�r�s dans la paie en cours
procedure DestTOBCumSal; // Fonction de destruction de la  TOB des Cumuls Salari�s
function OkCumSal: Boolean; // Fonction qui indique si les cumuls salari�s ont �t� calcul�s
function DoubleToCell(const X: Double; const DD: integer): string; // Fonction d'affchage d'un montant en fonction du nombre de d�cimales g�r�es pour le champ
function ValoriseMt(const cas: WORD; const Cc: string; const NbreDec: Integer; Base, Taux, Coeff: Double): Double; // Fonction de valorisation d'une ligne de r�mun�ration
function EvalueRem(Tob_Rub: TOB; const Rub: string; var Base, Taux, Coeff, Montant: Double; var lib: string; DateDeb, DateFin: TDateTime; ActionCalcul: TActionBulletin; Ligne:
  Integer): Boolean; // Calcul de la r�mun�ration
function EvalueChampRem(Tob_Rub: TOB; const TypeChamp, Champ, Rub: string; const DateDeb, DateFin: TDateTime): Double; // Calcul d'un champ d'une Remun�ration
function RechCasCodeCalcul(const Cc: string): WORD; // Recherche du cas code calcul
function ValVariable(const VariablePaie: string; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB): double; // Fonction d'�valuation d'une variable
function RechCommentaire(const Rub: string): Boolean; // Fonction qui indique si on c'est une ligne de commentaire associ�e � la rubrique
function RendCodeRub(const Rub: string): string; // Fonction qui rend le code de la rubrique  en supprimant .x pour les lignes de commentaire
procedure AlimChampEntet(const Salarie, Etab: string; const DateDebut, DateFin: TDateTime; Tob_Rub: TOB);
// Fonction alimentation enreg de PAIEENCOURS avec les champs salari� et la saisie
function RendRubrCommentaire(const rub: string; const CurG: THGrid): Integer; // Fonction qui calcule automatiquement le num�ro de la ligne de commentaire
function RecupRem(const ActionCalcul: TActionBulletin; const TypeChamp: string): Boolean; // Fonction qui indique si doit calculer ou r�cuperer le champ de la r�mun�ration
function EvalueCot(Tob_Rub: TOB; const Rub: string; var Base, TxSal, TxPat, MtSal, MtPat: Double; var lib: string; DateDeb, DateFin: TDateTime; ActionCalcul: TActionBulletin; var
  At: Boolean): Boolean; // Calcul de la Cotisation
function EvalueChampCot(Tob_Rub: TOB; const TypeChamp, Champ, Rub: string; const DateDeb, DateFin: TDateTime): Double;
//Fonction d'�valuation d'un champ d'une cotisation en fonction du type du cham
procedure CalculBulletin(Tob_Rub: TOB); // procedure qui valorise les lignes de bulletins en fonction du param�trage et A PARTIR de TOB_Rub
function CalculDatePaie(TOB_Sal: TOB; DatePaie: TDateTime): TDateTime; // fonction de calcul de la date de la paie
procedure AlimProfilMulti(ListeProfil: string; Salarie, TPE: TOB); //  Fonction d'alimentation en rubriques en fonction des profils tq maladie, chomage
function RechVarDefinie(const VariablePaie: string; const DateDebut, DateFin: TDateTime; var MtCalcul: Variant; TOB_Rub: TOB): Boolean;
procedure MemoriseTrentieme(const MtTrent: Double); // Memorisation du trentieme pour les calculs et pour la variable qui rend le trentieme calcul�
procedure RecupTobSalarie(const Salarie: string); // Rechargement de la TOB_Salari�
function ExamCasValeurRem(const ACol: Integer; T1: TOB): Boolean; //fonction qui examine si le champ est du type valeur alors jamais de saisie
function EvalueVarVal(T_Rech: TOB; const DateDebut, DateFin: TDateTime; TOB_Rub: TOB): Double; // fonction evaluation variable de type valeur
function EvalueVarCum(T_Rech: TOB; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB): Double; // fonction evaluation variable de type cumul
procedure RendDateVar(T_Rech: TOB; const DateDeb, DateFin: TDateTime; var ZdatD, ZdatF: TDateTime);
// fonction qui calcule les dates de d�but et de fin pour les cumusls,cotisations, rem...
function EvalueVarRub(const Nature: string; T_Rech: TOB; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB; TypeB, ChampBase: string): Double;
// fonction evaluation variable de type rubrique
function EvalueUnChampVar(const TypeB: string; ChampBase: string; TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime): Variant;
function IsOperateurInegalite(const Operateur: string): boolean; //
function IsOperateurLogique(const Operateur: string): boolean;
function EvalueExpVar(TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime; const Ztype, ZBase, Zoperat: string; const maxO: Integer): string;
// evalue une expression de type variable
function EvalueVarCalcul(TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime; const DebI, FinI: integer; const Ztype, ZBase, Zoperat: string): string;
// evalue une expression de type calcul
function EvalueBas(Tob_Rub: TOB; const Rub: string; var Base, Plafond, Plf1, Plf2, Plf3, TR1, TR2, TR3: Double; var lib: string; const DateDeb, DateFin: TDateTime; ActionCalcul:
  TActionBulletin; const BaseForcee, TrancheForcee: Boolean): Boolean; // Calcul de la Base de cotisation
procedure CalculCumulsRegul(const Rub: string; var Base, Plf1, Plf2, Plf3, TR1, TR2, TR3: Double; DateDeb, DateFin: TDateTime; const ARegulariser: Boolean; const TPlf1, TPlf2,
  TPlf3: string); // fonction de calcul des reguls
function EvalueChampBas(Tob_Rub: TOB; TypeChamp, Champ, Rub: string; DateDeb, DateFin: TDateTime): Double; // evalue un champ d'une base de cotisations
function EvaluePlafond(TOB_Rub: TOB; TypeChamp, Champ, Rub: string; Plafond: Double; DateDeb, DateFin: TDateTime; NbreDec: Integer; TypeRegul: string): Double;
// Fonction de calcul des diff�rents plafond associ�s aux tranches
function ValVarTable(const TypeVar: string; var TDossier: string; const DateDebut, DateFin: TDateTime; TOB_Rub: TOB; Origine: string = ''): Double;
function RendValeurTable(const AgeAnc: string; const TypeVar, Champ, Conv, Sens, NatureRes: string; const DateDebut, DateFin: TDateTime; TOB_RUB: TOB; Period: string = ''):
  Double;
function TestSensTable(AgeAnc, NombreLu: Variant; Sens: string; Period: string = ''): Boolean;
function ValBase(const Rubrique: string): TRendRub;
function RendBaseRubBase(const Rubrique: string; TOB_Rub: TOB; Quoi: Integer = -1): Double;
procedure ChargeBasesSal(const Salarie, Etab: string; DateD, DateF: TDateTime); // Chargement des bases de cotisation pour le calcul des r�guls
function RendModeRegle(TOB_Sal: TOB): string; // Rend le mode de r�glements salari�s
procedure RendDatePaiePrec(var Date1, Date2: TDateTime; const DD, DF: TDateTime); // Dates de la paie pr�c�dentes
procedure Appellesalaries; // Fonctions pour lancer les fiches AGL du zoom
procedure AppelleCotisations;
procedure AppelleVariables;
procedure AppelleEtablissements;
procedure AppelleRemunerations;
procedure AppelleDossier;
procedure AppelleTablesdossier;
procedure AppelleCumuls;
procedure AppelleProfils;
procedure SuppCotExclus(const ThemeExclus: string; TPE: TOB); // Suppression des rubriques ayant un theme de la liste des rubriques d�j� identifi�es ex : URSSAF
procedure EvalueChaineDiv0(var St: string); // Controle chaine dans laquelle il y a une division par 0
procedure IntegrePaye(Tob_Rub, Tob_prisCP: tob; const Etab, Salarie: string; const DateD, DateF: TDateTime; const Typecp: string; ManqueAcquis: Boolean = False);
function PGRecupereProfilCge(const Etab: string): string; //PT90
procedure SalEcritCP(var Tob_cppris: tob);
procedure LibereTobCp(var Tob_cppris: tob);
procedure SalEcritAbs(var Tob_abs: tob);
function SalIntegreCP(TOB_Sal, TOB_Rub, Tob_AcqEnCours: TOB; const DateD, DateF: TDateTime; const Auto: Boolean; var StMsgErr: string): tob; //PT7
procedure GridGriseCell(const GS: THGrid; const Acol, Arow: integer; Canvas: Tcanvas); //
procedure GridDeGriseCell(const GS: THGrid; const Acol, Arow: integer; Canvas: Tcanvas);
function IsOkType(TR: tob; const typecp: string): boolean;
function RendBasePrecarite(const DateDebut, DateFin: TDateTime; const DuSalarie: string): double;
procedure IntegreAbsenceDansPaye(Tob_Rub, Tob_ABS, salarie: tob; const DateD, DateF: tdatetime; const Action: string);
// PT107 IJSS procedure IntegreRub(tob_rub, Salarie: tob; const TypeAbs, aliment: string; const DateD, DateF: tdatetime; const compteur: double; natrub, arub: string);
procedure IntegreRub(tob_rub, Salarie: tob; const TypeAbs, aliment: string; const DateD, DateF: tdatetime; const compteur: double; natrub, arub: string; IJSS, Maintien: Boolean);
procedure Ecritlignecomm(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const Rub, Natrub: string);
procedure RechercheCarMotifAbsence(const Abs: string; var profil, Rubrique, Aliment: string; var Gerecomm, Heure: boolean);
procedure PositionnePaye(t: tob; const DateF: TDateTime);
procedure AnnuleAbsenceBulletin(const CodeSalarie: string; const DateF: tdatetime);
function IsOkFloat(const val: string): boolean;
function IsNumerique(const S: string): boolean;
function ChercheNatRub(Salarie, TPE: TOB; const Profil, rub: string): string;
procedure EnleveCommAbsence(Salarie, Tob_rub: tob; const Arub, Natrub: string; const dated, datef: tdatetime);
procedure IntegreMvtSolde(Tob_Rub, TOB_Salarie: tob; const Etab, Salarie: string; const DateD, DateF: TdateTime);
procedure recalculeValoSolde(const DateD, DateF: tdatetime; P5Etab, TSal, Tob_solde, Tob_rub: tob; const Salarie: string);
//procedure  ChargeACquis(periode:integer;DateD,DateF,DateDP:tdatetime;Salarie:string);
function notVide(T: tob; const MulNiveau: boolean): boolean;
procedure GestionCalculAbsence(tob_rub: tob; const DateD, DateF: tdatetime; const typem: string);
//procedure SupprimeAbsenceDePaye(Tob_Rub, Tob_ABSTEMP,Salarie:tob;DateD, DateF:tdatetime) ;
procedure RemplirHistoBulletin(HistoBul, Salarie, Rubrique, ProfilRub: TOB; const DateDeb, DateFin: TDateTime);
procedure InitialiseVariableStatCP;
procedure InitVarTHTRAVAILLES; //PT83-3
procedure ReaffecteDateMvtcp(const DateFin: tdatetime);
// PT35 : 26/03/2002 PH V571 Fonction de raz de ChptEntete
//PT68    19/12/2002 PH V591 Affectation de la date de paiement � la date de fin de paie si non renseign�e
procedure RazChptEntete(const DateF: TDateTime);

//PT32 : 07/02/2002 PH V571 suppression historisation salari�
{
function  IncrementeSeqNoOrdrePHS(cle_sal: string): Integer;
procedure InitialiseBoolean(var M : Histosal;ValB : boolean);
procedure CopyHistosal(var A,N:Histosal);
}
// FIN PT32
function RecupCot(const ActionCalcul: TActionBulletin; const TypeChamp: string): Boolean;
// PT20 : 20/11/01 V562 PH Modif du calcul des dates d'�dition automatique en fonction de l'�tablissement
procedure CalculeDateEdtPaie(var LDatD, LDatF: TDateTime; T_Etab: TOB);
// PT28 : 27/12/2001 V571 PH Calcul des variables de tupe cumul en tenant compte du mois de RAZ
// PT70 : 23/01/2003 PH V591 Correction du calcul des bornes de dates pour la valorisation d'un cumul ant�rieur avec une p�riode de raz
procedure BorneDateCumul(const DateDeb, DateFin: TDateTime; var ZDatD, ZDatF: TDateTime; const PerRaz: string);
procedure RendBorneDateCumul(const DateDeb, DateFin: TDateTime; var ZDatD, ZdatF: TDateTime; const PerRaz: string);
//PT60 07/10/2002 PH V585 Recherche d'un element national par pr�f�rence DOS,STD,CEG
function ValEltNatPref(const Elt, Pref: string; const DatTrait: TDatetime): double;
procedure LibereTobAbs;

function Paie_RechercheOptimise(const TobSrc: tob; const Field: string; const Valeur: Variant): TOB;
function Paie_RechercheRubrique(const typerubrique, rubrique: string): tob;
procedure RAZTOBPaie();

{$IFNDEF CCS3}
procedure AnnuleIJSSBulletin(const CodeSalarie: string; const DateF: tdatetime); //PT103 IJSS
{$ENDIF}
{$IFNDEF CCS3}
procedure AnnuleMaintienBulletin(const CodeSalarie: string; const DateD, DateF: tdatetime); // PT121 Maintien
{$ENDIF}
{$IFNDEF CCS3}
// d PT124
procedure EcritCommMaint(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const RubMaintien, NatRub: string);
// f PT124
// d PT129
procedure EcritCommIJ(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const RubIJ, NatRub: string);
procedure EnleveCommIJ(Salarie, Tob_rub: tob; const Arub, Natrub: string; const dated, datef: tdatetime);
// f PT129
{$ENDIF}

implementation

uses
{$IFNDEF AGL570d}
  PgiEnv,
{$ENDIF}
  PgCongesPayes,
  PGoutils,
  PgOutils2,
  ed_tools,
  SaisBul;

var
  TOB_TauxAT: tob; // TOB des Taux AT de la Soci�t�
  TOB_PaiePrecedente: tob; // Tob Liste des rubriques du bulletin pr�c�dent
  {***********A.G.L.***********************************************
  Auteur  ...... : Ph
  Cr�� le ...... : 22/08/2003
  Modifi� le ... :   /  /
  Description .. : Fonction qui calcule le montant de la saisie arret sur chaque ligne
  Suite ........ : PT84   : 26/08/2003 PH V_42 Mise en place saisie arret
  Mots clefs ... :
  *****************************************************************}

function RendMtLigneSaisieArret(VariablePaie: string; TOB_SaisieArret: TOB): Double;
var
  i: Integer;
begin
  result := 0;
  for i := 0 to TOB_SaisieArret.detail.count - 1 do
  begin
    if (TOB_SaisieArret.detail[i].GetValue('PTR_RUBRIQUE') = VariablePaie) then
    begin
      result := result + TOB_SaisieArret.detail[i].GetValue('MONTANTBUL');
      TOB_SaisieArret.detail[i].PutValue('INTBULL', 'X');
    end;
  end;
end;
{***********A.G.L.***********************************************
Auteur  ...... : D.T.
Cr�� le ...... : 17/03/2003
Modifi� le ... :   /  /
Description .. : Fonction qui retourne la bonne tob en fonction du type de
Suite ........ : la rurique
Mots clefs ... :
*****************************************************************}

function PaieExpression(const Expression, Vrai, Faux: variant): variant;
begin
  if Expression then result := Vrai else Result := Faux;
end;

{***********A.G.L.***********************************************
Auteur  ...... : D.T.
Cr�� le ...... : 17/03/2003
Modifi� le ... :   /  /
Description .. : Fonction qui retourne la bonne tob en fonction du type de
Suite ........ : la rubrique
Mots clefs ... :
*****************************************************************}

function Paie_RechercheOptimise(const TobSrc: tob; const Field: string; const Valeur: Variant): TOB;
var
  iStart, iMax, iNumChamp, iCount, iPrevCount: integer;
begin
  result := nil;
  if (Pos('PHC_', Field) > 0) then TobSrc.Detail.Sort(Field);
  if Assigned(TobSrc) and (TobSrc.Detail.Count > 0) then
  begin
    // r�cup�ration du n� de champ
    iNumChamp := TobSrc.Detail[0].GetNumChamp(Field);
    if iNumChamp > 0 then
    begin
      iStart := 0;
      iPrevCount := -1;
      iCOunt := 0;
      iMax := TobSrc.Detail.Count - 1;
      if TobSrc.Detail[iMax].GetValeur(iNumChamp) = Valeur then result := TobSrc.Detail[iMax]
      else if TobSrc.Detail[0].GetValeur(iNumChamp) = Valeur then result := TobSrc.Detail[0]
      else while not assigned(result) do
        begin
          if (iPrevCount = iCount) then break;
          iPrevCount := iCount;
          iCount := ((iMax - iStart) shr 1 + iStart);
          if TobSrc.Detail[iCount].GetValeur(iNumChamp) = Valeur then result := TobSrc.Detail[iCount]
          else if TobSrc.Detail[iCount].GetValeur(iNumChamp) < Valeur then iStart := iCount
          else iMax := iCount;
        end;
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : D.T.
Cr�� le ...... : 17/03/2003
Modifi� le ... :   /  /
Description .. : Fonction qui retourne la bonne tob en fonction du type de
Suite ........ : la rurique
Mots clefs ... :
*****************************************************************}

function Paie_RechercheRubrique(const typerubrique, rubrique: string): tob;
begin
  result := nil;
  if typeRubrique = '' then exit;

  if typerubrique = 'AAA' then result := Paie_RechercheOptimise(tob_rem, 'PRM_RUBRIQUE', rubrique)
  else if typerubrique = 'COT' then result := Paie_RechercheOptimise(tob_cotisations, 'PCT_RUBRIQUE', rubrique)
  else if typerubrique = 'BAS' then result := Paie_RechercheOptimise(tob_bases, 'PCT_RUBRIQUE', rubrique);
end;

{***********A.G.L.***********************************************
Auteur  ...... : D.T.
Cr�� le ...... : 17/03/2003
Modifi� le ... :   /  /
Description .. : Fonction qui retourne le pr�fixe en fonction type de
Suite ........ : la rurique
Mots clefs ... :
*****************************************************************}

function Paie_PrefixeRubrique(const typerubrique: string): string;
begin
  result := 'PRM';
  if (typerubrique = 'COT') or (typerubrique = 'BAS') then result := 'PCT';
end;

{***********A.G.L.***********************************************
Auteur  ...... : D.T.
Cr�� le ...... : 14/03/2003
Modifi� le ... :   /  /
Description .. : Fonction de chargement des tob pour les bases et les cotisations
Mots clefs ... :
*****************************************************************}

procedure ChargeCotisations;
begin
  initTOB_Cotisations();
  initTOB_Bases();
end;

// Procedure qui remplit l'historique de paies

procedure RemplirHistoBulletin(HistoBul, Salarie, Rubrique, ProfilRub: TOB; const DateDeb, DateFin: TDateTime);
var
  Prefixe, St: string;
  Nature, Rub, Etab, CodeSal: string;
begin
  if Rubrique = nil then exit;
  Prefixe := TableToPrefixe(Rubrique.NomTable);
  if Prefixe = '' then
  begin
    st := TCS(Rubrique.ChampsSup[0]).Nom;
    Prefixe := ReadTokenPipe(St, '_');
  end;

  Nature := Rubrique.GetValue(Prefixe + '_NATURERUB');
  Rub := Rubrique.GetValue(Prefixe + '_RUBRIQUE');
  Etab := Salarie.GetValeur(iPSA_ETABLISSEMENT);
  CodeSal := Salarie.GetValeur(iPSA_SALARIE);
  if (Etab = '') or (CodeSal = '') or (Nature = '') or (DateDeb = 0) or (DateFIN = 0) then
  begin
    St := 'Salari� : ' + CodeSal + ' Confection du Bulletin : Erreurs Champ non renseign�';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '') else TraceErr.Items.Add(St);
  end;
  if Assigned(HistoBul) and (iPHB_ETABLISSEMENT = 0) then MemorisePhb(HistoBul);
  with HistoBul do
  begin
    PutValeur(iPHB_ETABLISSEMENT, Salarie.GetValeur(iPSA_ETABLISSEMENT));
    PutValeur(iPHB_SALARIE, Salarie.GetValeur(iPSA_SALARIE));
    PutValeur(iPHB_DATEDEBUT, DateDeb);
    PutValeur(iPHB_DATEFIN, DateFin);
    PutValeur(iPHB_NATURERUB, Rubrique.GetValue(Prefixe + '_NATURERUB'));
    PutValeur(iPHB_RUBRIQUE, Rubrique.GetValue(Prefixe + '_RUBRIQUE'));
    PutValeur(iPHB_LIBELLE, Rubrique.GetValue(Prefixe + '_LIBELLE'));
    PutValeur(iPHB_IMPRIMABLE, Rubrique.GetValue(Prefixe + '_IMPRIMABLE'));
    if Prefixe = 'PRM' then
    begin
      //A revoir
      PutValeur(iPHB_BASEREM, 0); //Rubrique.GetValue('PRM_BASEREM')) ;
      PutValeur(iPHB_TAUXREM, 0); //Rubrique.GetValue('PRM_TAUXREM')) ;
      PutValeur(iPHB_COEFFREM, 0); //Rubrique.GetValue('PRM_COEFFREM')) ;
      PutValeur(iPHB_MTREM, 0); //Rubrique.GetValue('PRM_MONTANT')) ;
      //////
      PutValeur(iPHB_BASEREMIMPRIM, Rubrique.GetValue('PRM_BASEIMPRIMABLE'));
      PutValeur(iPHB_TAUXREMIMPRIM, Rubrique.GetValue('PRM_TAUXIMPRIMABLE'));
      PutValeur(iPHB_COEFFREMIMPRIM, Rubrique.GetValue('PRM_COEFFIMPRIM'));
      PutValeur(iPHB_ORDREETAT, Rubrique.GetValue('PRM_ORDREETAT'));
      PutValeur(iPHB_SENSBUL, Rubrique.GetValue('PRM_SENSBUL'));
    end
    else
    begin
      PutValeur(iPHB_BASECOT, 0); //Rubrique.GetValue('PCT_BASECOTISATION')) ;
      PutValeur(iPHB_TAUXSALARIAL, 0); //Rubrique.GetValue('PCT_TAUXSAL')) ;
      PutValeur(iPHB_TAUXPATRONAL, 0); //Rubrique.GetValue('PCT_TAUXPAT')) ;
      PutValeur(iPHB_MTSALARIAL, 0);
      PutValeur(iPHB_MTPATRONAL, 0);
      PutValeur(iPHB_ORGANISME, Rubrique.GetValue('PCT_ORGANISME'));
      PutValeur(iPHB_BASECOTIMPRIM, Rubrique.GetValue('PCT_BASEIMP'));
      PutValeur(iPHB_TAUXSALIMPRIM, Rubrique.GetValue('PCT_TXSALIMP'));
      PutValeur(iPHB_TAUXPATIMPRIM, Rubrique.GetValue('PCT_TXPATIMP'));
      PutValeur(iPHB_ORDREETAT, Rubrique.GetValue('PCT_ORDREETAT'));
      PutValeur(iPHB_SENSBUL, 'P');
    end;

    PutValeur(iPHB_TRAVAILN2, Salarie.GetValeur(iPSA_TRAVAILN2));
    PutValeur(iPHB_TRAVAILN3, Salarie.GetValeur(iPSA_TRAVAILN3));
    PutValeur(iPHB_TRAVAILN4, Salarie.GetValeur(iPSA_TRAVAILN4));
    PutValeur(iPHB_TRAVAILN1, Salarie.GetValeur(iPSA_TRAVAILN1));
    PutValeur(iPHB_CODESTAT, Salarie.GetValeur(iPSA_CODESTAT));
    PutValeur(iPHB_LIBREPCMB1, Salarie.GetValeur(iPSA_LIBREPCMB1));
    PutValeur(iPHB_LIBREPCMB2, Salarie.GetValeur(iPSA_LIBREPCMB2));
    PutValeur(iPHB_LIBREPCMB3, Salarie.GetValeur(iPSA_LIBREPCMB3));
    PutValeur(iPHB_LIBREPCMB4, Salarie.GetValeur(iPSA_LIBREPCMB4));
    //PT22 : 22/11/01 V562 PH ORACLE, Le champ PHB_ORGANISME doit �tre renseign�
    if GetValeur(iPHB_ORGANISME) = '' then PutValeur(iPHB_ORGANISME, '....');
    PutValeur(iPHB_CONFIDENTIEL, Salarie.GetValeur(iPSA_CONFIDENTIEL));
    PutValeur(iPHB_CONSERVATION, 'PRO'); // Pour indiquer que la rubrique vient d'un profil
  end;
  AlimCumulSalarie(HistoBul, CodeSal, Nature, Rub, Etab, DateDeb, DateFin);
end;
//PT32 : 07/02/2002 PH V571 suppression historisation salari�
{
function IncrementeSeqNoOrdrePHS(cle_sal: string): Integer;
var
   q: TQuery;
begin
    result := 1;
    q := OpenSQL('select max (PHS_ORDRE) as maxno from HISTOSALARIE ' +
                 ' where PHS_SALARIE = "' + cle_sal+'"', TRUE);

    if not q.eof then
// $IFDEF EAGLCLIENT
    if q.Fields[0].AsInteger = 0 then
// $ELSE
          if not q.Fields[0].IsNull then
//$ENDIF
             result := ((q.Fields[0]).AsInteger+1);

    Ferme(q);
end;
}
// FIN PT32
{Fonction qui charge la liste des rubriques en fonction du profil
Elle traite les cas particuliers qui consistent � exclure des rubriques de cotisation qui ont un
th�me d�fini exemple EXO exclusion de l'URSSAF.
Le theme � exclure est renseign� au niveau du profil.
Cela provoque alors la suppression de toutes les rubriques de cotisation qui ont ce th�me de la
liste des rubriques composant le bulletin de paie.
}

procedure ChargeProfil(Salarie, TPE: TOB; Profil: string);
var
  TPP, TPR, TRC, THB: TOB;
  ThemeRub, ThemeExclus: string;
  I: Integer;
  iChampNatureRub: integer;
  iChampRubrique: integer;
begin
  if Profil = '' then exit;
  ThemeRub := '';
  ThemeExclus := '';
  TPP := Paie_RechercheOptimise(TOB_ProfilPaies, 'PPI_PROFIL', Profil); // $$$$
  if TPP <> nil then
  begin
    ThemeExclus := TPP.GetValue('PPI_THEMECOT'); // theme des rubriques de cotisations � exclure
    if ThemeExclus <> '' then SuppCotExclus(ThemeExclus, TPE);
    if tpp.Detail.Count > 0 then
    begin
      iChampNatureRub := tpp.detail[0].GetNumChamp('PPM_NATURERUB');
      iChampRubrique := tpp.detail[0].GetNumChamp('PPM_RUBRIQUE');
      for I := 0 to TPP.Detail.count - 1 do
      begin
        TPR := TPP.Detail[I];
        //          SSS := TPR.GetValeur(iChampNatureRub) + TPR.GetValeur(iChampRubrique) ;
        Trc := Paie_RechercheRubrique(TPR.GetValeur(iChampNatureRub), TPR.GetValeur(iChampRubrique));
        if TPE.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], [TPR.GetValeur(iChampNatureRub), TPR.GetValeur(iChampRubrique)], FALSE) = nil then // $$$$
        begin
          // on va ecrire une ligne bulletin THB comme fille de la TOB TPE qui est l'entete bulletin
          THB := TOB.Create('HISTOBULLETIN', TPE, -1);
          RemplirHistoBulletin(THB, Salarie, TRC, TPR, TPE.GetValue('PPU_DATEDEBUT'), TPE.GetValue('PPU_DATEFIN'));
        end;
      end;
    end;
  end;
end;
{ Fonction de recherche de la liste des rubriques composant chaque profil
Attention, Pour chaque profil, il faut regarder son type et s'il est identique � celui de l'�tablissement
il faut alors aller rechercher les profils d�finis par d�faut au nivaeu de l'�tablissement
Attention, il manque le traitement de modification : @@@@@ ??????
CAD on ne reprend pas les rubriques du profil mais le bulletin tel qu'il �tait valoris�
lors de la paie.
Modif 4/4/01 pour reprendre la paie precedente du salarie et non pas Etablissement/Salarie
 donc modif des requetes SQL et des recherches dans les TOB
}
// PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
//        Rajout parametres TheBullCompl, TheProfilPart Pour indiquer si bull compl�mentaire et son profil associ�

function ChargeRubriqueSalarie(Salarie: TOB; DateDeb, DateFin: TDateTime; ActionB: TActionBulletin; MtEnvers: Double; TheProfilPart: string): TOB;
var
  T_Etab, TPR, TPE, TT: TOB;
  Q: TQuery;
  Etab, St: string;
  Date1, Date2, ZDate: TDateTime;
  i: integer;
begin
  TOB_Salarie := Salarie; // Memorisation du salarie sur lequel on travaille
  TPE := TOB.Create('PAIEENCOURS', nil, -1);
  TPE.PutValue('PPU_ETABLISSEMENT', Salarie.GetValeur(iPSA_ETABLISSEMENT));
  Etab := string(Salarie.GetValeur(iPSA_ETABLISSEMENT));
  T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', Etab);
  if T_Etab = nil then
  begin
    St := 'Salari� : ' + CodSal + ' Charge Rubrique Salari� : Etablissement non R�f�renc�';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '') else TraceErr.Items.Add(St);
    result := nil;
    exit;
  end;
  // PT100  : 05/04/2004 PH V_50 FQ 11231 Prise en compte du cas sp�cifique Alsace Lorraine
  RegimeAlsace := T_Etab.GetValue('ETB_REGIMEALSACE');
  // Alimentation des champs Entete du bulletin
  AlimChampEntet(Salarie.GetValeur(iPSA_SALARIE), Salarie.GetValeur(iPSA_ETABLISSEMENT), DateDeb, DateFin, TPE);

  // Chargement des rubriques de chaque profil ref�renc� au niveau salari� en cr�ation
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl <> 'X' then
  begin
    if ActionB = taCreation then AligneProfil(Salarie, T_Etab, TPE, ActionB);
  end
  else
  begin
    if ActionB = taCreation then
    begin
      if TheProfilPart <> '' then ChargeProfil(Salarie, TPE, TheProfilPart)
      else AligneProfil(Salarie, T_Etab, TPE, ActionB);
    end;
  end;

  {CHargement des rubriques composant le bulletin pr�c�dant
  Lecture des paieencours @@@ si on est en mode creation uniquement , en modif on recupere le bulletin tq
  cad le bulletin sur lequel on travaille.

  Cas bulletin compl�mentaire, on ne recherche pas � aligner les rubriques du
  bulletin par<rapport au profil. C'est une image faite � la cr�ation du bulletin
  Si on veut modifier son contenu et le r�aligner par rapport au profil, il faut
  supprimer le bulletin.
  Le bulletin compl�mentaire est un bulletin exceptionnel fait pour saisir des infos
  de paie ap�s que le salari� soit parti ou bien por faire un bulletin de type participation
  pour lequel il n'y a pas d'�l�ments permananents � r�cup�rer.
  Une R�mun�ration suivie des cotisations CSG et CRDS.
  }
  if ActionB = taCreation then
  begin // R�cup�ration de la derni�re paie faite pour le salari�
    TOB_PaiePrecedente := TOB.Create('Le Bulletin de la Paie Pr�c�dante', nil, -1);
    // PT65    02/12/2002 PH V591 Recup des infos du bulletin pr�c�dent en excluant les bulletins compl�mentaires
    st := 'SELECT * FROM PAIEENCOURS WHERE PPU_BULCOMPL <> "X" AND PPU_SALARIE="' + Salarie.GetValeur(iPSA_SALARIE) + '" ORDER BY PPU_DATEDEBUT,PPU_DATEFIN';
    Q := OpenSql(st, TRUE);
    TOB_PaiePrecedente.LoadDetailDB('PAIEENCOURS', '', '', Q, FALSE);
    ferme(Q);
    Date1 := 0;
    Date2 := 0;
    for i := 0 to TOB_PaiePrecedente.Detail.Count - 1 do
      with TOB_PaiePrecedente.Detail[i] do
      begin
        ZDate := TDateTime(GetValue('PPU_DATEFIN'));
        if (Zdate < Date2) and (Date2 <> 0) then break; // cas o� il y a un bulletin post�rieur alors on s'arrete
        if ZDate > DateFin then break;
        Date1 := TDateTime(GetValue('PPU_DATEDEBUT'));
        Date2 := TDateTime(GetValue('PPU_DATEFIN'));
      end;

    // PT65    02/12/2002 PH V591 Free avt le NIL !!!
    TOB_PaiePrecedente.Free;
    TOB_PaiePrecedente := nil;
    if Date2 >= DateFin then // On calcule une paie qui a une paie post�rieure donc on ne prend pas les lignes historiques
    begin
      Date2 := DateFin;
      PLUSMOIS(Date2, -1); // Mois -1 au cas ou mais peu probable car si on a des trous dans les paies
      Date1 := DEBUTDEMOIS(Date2); // Recup�ration du mois precedent
    end;
  end
  else
  begin // Les dates de la paie sont les dates pass�es en param�res
    Date1 := DateDeb;
    Date2 := DateFin;
  end;

  if (Date1 <> 0) and (Date2 <> 0) then
  begin // recup des lignes du dernier bulletin fait pour le salari�/etablissement
    TOB_PaiePrecedente := TOB.Create('Les lignes de la Paie Pr�c�dante', nil, -1);
    st := 'SELECT * FROM HISTOBULLETIN WHERE PHB_SALARIE="' + Salarie.GetValeur(iPSA_SALARIE) + '" AND PHB_DATEDEBUT="' + USDateTime(Date1) + '" AND PHB_DATEFIN="' +
      USDateTime(Date2) + '"';
    Q := OpenSql(st, TRUE);
    if not q.eof then TOB_PaiePrecedente.LoadDetailDB('HISTOBULLETIN', '', '', Q, False);
    Ferme(Q);

    // Modified by XP : 09-04-2003
    // TPR:= TOB_PaiePrecedente.FindFirst(['PHB_SALARIE','PHB_DATEDEBUT','PHB_DATEFIN'],[Salarie.GetValeur (iPSA_SALARIE'),Date1, Date2],TRUE) ; // $$$$
    // while TPR <> NIL do
    for i := 0 to TOB_PaiePrecedente.Detail.Count - 1 do
    begin
      tpr := TOB_PaiePrecedente.Detail[i];
      if ActionB = taCreation then
      begin
        MajRubriqueBulletin(TPE, TPR, CodSal, Etab, DateDeb, DateFin) // controle si la rubrique est pres�nte dans le bulletin et r�cup �l�ment permanent
      end
      else
      begin
        TT := TOB.create('HISTOBULLETIN', TPE, -1);
        if Assigned(TT) and (iPHB_ETABLISSEMENT = 0) then MemorisePhb(TT);
        with TT do
        begin
          Dupliquer(TPR, FALSE, TRUE, TRUE);
          PutValeur(iPHB_ETABLISSEMENT, Etab);
          PutValeur(iPHB_SALARIE, CodSal);
          PutValeur(iPHB_DATEDEBUT, DateDeb);
          PutValeur(iPHB_DATEFIN, DateFin);
        end;
      end;
      // TPR:=TOB_PaiePrecedente.FindNext(['PHB_SALARIE','PHB_DATEDEBUT','PHB_DATEFIN'],[Salarie.GetValeur (iPSA_SALARIE),Date1, Date2],TRUE) ;
    end;

    if ActionB = taModification then
    begin // il oonvient de regarder si on a une nouvelle rubrique dans les profils qui ne soient pas dans le bulletin
      if BullCompl <> 'X' then AligneProfil(Salarie, T_Etab, TPE, ActionB)
      else
      begin
        if TheProfilPart <> '' then ChargeProfil(Salarie, TPE, TheProfilPart)
        else AligneProfil(Salarie, T_Etab, TPE, ActionB);
      end;
    end;

    FreeAndNil(TOB_PaiePrecedente);
  end;

  TPE.Detail.Sort('PHB_NATURERUB;PHB_RUBRIQUE');
  // Tri des rubriques par nature et par code afin de pouvoir les retrouver dans un ordre logique et chrnonologique
  // appel foonction de calcul du bulletin avec la valorisation des cumuls salari�s
  Result := TPE;
end;
{ Fonction de chargement du contexte de la paie
Charge Toutes les TOB en memoire
}

procedure ChargeLesTOBPaie;
var
  I: Integer;
  Them, St, Nat, Rub: string;
  T, T1: TOB;
  Q: TQuery;

  // added by XP le 14-03-2003
  TobTmp: tob; // Tob liste des rubriques composant les profils
  NumError: Integer;
begin
  NumError := 1;
  try
    ObjTM3VM := TM3VM.Create; // creation objet VM Script
    if VH_PAIE.PGAnalytique = TRUE then InitMove(20, ' ') else InitMove(18, ' ');
    initTOB_ProfilPaies();
    NumError := 2;
    MoveCur(FALSE);
    NumError := 3;
    MoveCur(FALSE);
    initTOB_Rem();
    NumError := 4;
    MoveCur(FALSE);

    { TOB_Rem contient la totalit� des Remunerations
    Il convient d'eclater ces rubriques en fonction de leur theme et ainsi
    de remplir les onglets de la saisie de bulletin dans le cas d'une saisie
    avec tous les onglets}
    for I := 0 to TOB_Rem.Detail.count - 1 do
    begin
      T := TOB_REM.Detail[I];
      Them := T.GetValue('PRM_THEMEREM');
      if Them = 'SAL' then T1 := TOB.create('RemSal', TOB_RemSal, -1)
      else if Them = 'ABS' then T1 := TOB.create('RemAbs', TOB_RemAbs, -1)
      else if Them = 'ABT' then T1 := TOB.create('RemAbt', TOB_RemAbt, -1)
      else if Them = 'AVT' then T1 := TOB.create('RemAvt', TOB_RemAvt, -1)
      else if Them = 'RNI' then T1 := TOB.create('RemNonImp', TOB_RemNonImp, -1)
      else if Them = 'INI' then T1 := TOB.create('RemPrimes', TOB_RemPrimes, -1)
      else if Them = 'RSS' then T1 := TOB.create('RemRet', TOB_RemRet, -1)
      else if Them = 'COM' then T1 := TOB.create('RemCplt', TOB_RemCplt, -1)
      else if Them = 'HEU' then T1 := TOB.create('RemHeures', TOB_RemHeures, -1);
      if Them <> '' then T1.Dupliquer(TOB_Rem.Detail[i], TRUE, TRUE);
    end;

    NumError := 5;
    // il convient aussi de diff�rencier les rubriques de Base des rubriques de Cotisations
    ChargeCotisations;
    NumError := 6;

    initTOB_Variables();

    NumError := 7;
    MoveCur(FALSE);

    initTOB_EltNatDOS();
    initTOB_EltNatSTD();
    initTOB_EltNatCEG();

    MoveCur(FALSE);

    TOB_JourTrav.LoadDetailDB('JOURSTRAV', '', '', nil, FALSE, False);

    MoveCur(FALSE);
    // Les cumuls et la gestion associ�e = CUMULRUBRIQUE
    initTOB_Cumuls();

    MoveCur(FALSE);

    initTOB_MinimumConv();
    MoveCur(FALSE);

    // PT72  : 05/02/2003 PH V595 Traitement des tables dossiers en string au lieu d'integer
    initTOB_MinConvPaie();
    MoveCur(FALSE);

    NumError := 8;

    NumError := 9;

    initTOB_EtabCompl();
    MoveCur(FALSE);
    TOB_TauxAT.LoadDetailDB('TAUXAT', '', '', nil, FALSE, False);
    MoveCur(FALSE);

    st := 'SELECT * FROM VENTIL WHERE V_NATURE LIKE "RR%" ORDER BY V_NATURE,V_COMPTE';
    Q := OpenSql(st, TRUE);
    TOB_VenRem.LoadDetailDB('VENTIL', '', '', Q, FALSE, False);
    Ferme(Q);
    MoveCur(FALSE);

    st := 'SELECT * FROM VENTIL WHERE V_NATURE LIKE "RC%" ORDER BY V_NATURE,V_COMPTE';
    Q := OpenSql(st, TRUE);
    TOB_VenCot.LoadDetailDB('VENTIL', '', '', Q, FALSE, False);
    Ferme(Q);
    MoveCur(FALSE);
    if VH_PAIE.PGAnalytique = TRUE then
    begin
      initTOB_VentiRemPaie();
      MoveCur(FALSE);
      initTOB_VentiCotPaie();
      MoveCur(FALSE);
    end;
    FiniMove;
    NumError := 10;

  except
    on E: Exception do
    begin
      ShowMessage('Exception N� ' + IntToStr(NumError));
    end;
  end;
end;

{ Fonction de chargement de l'exercice de la paie en fonction des Date de D�but
et de FIN
}

procedure ChargeLesExercPaie(const DateDeb, DateFin: TDateTime);
var
  Q: TQuery;
  St: string;
begin
  if TOB_ExerSocial <> nil then TOB_ExerSocial.Free;
  TOB_ExerSocial := nil;
  TOB_ExerSocial := TOB.Create('Les exerices du dossier', nil, -1);
  st := 'SELECT * FROM EXERSOCIAL WHERE PEX_DATEDEBUT<="' + UsDateTime(DateDeb) + '" AND PEX_DATEFIN>="' + UsDateTime(DateFin) + '"';
  Q := OpenSql(st, TRUE);
  TOB_ExerSocial.LoadDetailDB('EXERSOCIAL', '', '', Q, False);
  Ferme(Q);
end;


procedure InitLesTOBPaie;
begin
  TOB_Paie := TOB.Create('Les TOB de la paie', nil, -1);
  //TOB_ProfilRubs:=TOB.Create('Les Rubriques des Profils',Nil,-1) ;
  // Creation des TOB Remunerations Idem Onglets saisie de bulletin
  //TOB_Rem:=TOB.Create('Les Remunerations',Nil,-1) ;
  TOB_RemSal := TOB.Create('Les Salaires', nil, -1);
  TOB_RemHeures := TOB.Create('Les Heures', nil, -1);
  TOB_RemPrimes := TOB.Create('Les Primes', nil, -1);
  TOB_RemAbs := TOB.Create('Les Absences', nil, -1);
  TOB_RemCplt := TOB.Create('Les Complements', nil, -1);
  TOB_RemAvt := TOB.Create('Les Avantages', nil, -1);
  TOB_RemAbt := TOB.Create('Les Abattements', nil, -1);
  TOB_RemRet := TOB.Create('Les Retenues', nil, -1);
  TOB_RemNonImp := TOB.Create('Les Non Imposables', nil, -1);

{$IFDEF aucasou}
  TOB_ProfilPaies := TOB.Create('Les Profils', nil, -1);
  TOB_Cotisations := TOB.Create('Les Cotisations', nil, -1);
  TOB_Bases := TOB.Create('Les Bases', nil, -1);
  TOB_Variables := TOB.Create('Les Variables', nil, -1);
  TOB_CumulRubrique := TOB.Create('Les Cumuls Rubriques', nil, -1);
  TOB_Cumuls := TOB.Create('Les Cumuls', nil, -1);
  TOB_Etablissement := TOB.Create('Les Etablissements de la paie', nil, -1);
  TOB_EltNationauxCEG := TOB.Create('Les Elements NatCEG', nil, -1);
  TOB_EltNationauxSTD := TOB.Create('Les Elements NatSTD', nil, -1);
  TOB_EltNationauxDOS := TOB.Create('Les Elements NatDOS', nil, -1);
  TOB_Minimum := TOB.Create('Les tables dossiers', nil, -1);
  TOB_DetailMin := TOB.Create('Le detail des tables', nil, -1);
  TOB_VentilRem := TOB.Create('Les PreVentil des Remunerations', nil, -1);
  TOB_VentilCot := TOB.Create('Les PreVentil des Cotisations', nil, -1);
{$ENDIF}

  TOB_JourTrav := TOB.Create('Le Calendrier', nil, -1);
  TOB_TauxAT := TOB.Create('Les Taux AT', nil, -1);
  TOB_VenRem := TOB.Create('Les VentilAna des Remunerations', nil, -1);
  TOB_VenCot := TOB.Create('Les VentilAna des Cotisations', nil, -1);
end;
{ Fonction de desallocation de la TOB des Exercices du dossier de paie}

procedure VideLaTobExer;
begin
  if TOB_ExerSocial <> nil then TOB_ExerSocial.Free;
  TOB_ExerSocial := nil;
end;
{ Fonction de desallocation de toutes les tob du contexte de la Paie
}

procedure VideLesTOBPaie(AvecInit: Boolean);
begin
  if TOB_Paie <> nil then TOB_Paie.Free;
  //if TOB_ProfilRubs  <> NIL then TOB_ProfilRubs.Free;
  if TOB_RemSal <> nil then TOB_RemSal.Free;
  if TOB_RemHeures <> nil then TOB_RemHeures.Free;
  if TOB_RemPrimes <> nil then TOB_RemPrimes.Free;
  if TOB_RemAbs <> nil then TOB_RemAbs.Free;
  if TOB_RemCplt <> nil then TOB_RemCplt.Free;
  if TOB_RemAvt <> nil then TOB_RemAvt.Free;
  if TOB_RemAbt <> nil then TOB_RemAbt.Free;
  if TOB_RemRet <> nil then TOB_RemRet.Free;
  if TOB_RemNonImp <> nil then TOB_RemNonImp.Free;
{$IFDEF aucasou}
  if TOB_Rem <> nil then TOB_Rem.Free;
  if TOB_ProfilPaies <> nil then TOB_ProfilPaies.Free;
  if TOB_Cotisations <> nil then TOB_Cotisations.Free;
  if TOB_Bases <> nil then TOB_Bases.Free;
  if TOB_Variables <> nil then TOB_Variables.Free;
  if TOB_CumulRubrique <> nil then TOB_CumulRubrique.Free;
  if TOB_Cumuls <> nil then TOB_Cumuls.Free;
  if TOB_Etablissement <> nil then TOB_Etablissement.Free;
  if TOB_EltNationauxSTD <> nil then TOB_EltNationauxSTD.Free;
  if TOB_EltNationauxCEG <> nil then TOB_EltNationauxCEG.Free;
  if TOB_EltNationauxDOS <> nil then TOB_EltNationauxDOS.Free;
  if TOB_Minimum <> nil then TOB_Minimum.Free;
  if TOB_DetailMin <> nil then TOB_DetailMin.Free;
  if TOB_VentilRem <> nil then TOB_VentilRem.Free;
  if TOB_VentilCot <> nil then TOB_VentilCot.Free;
{$ENDIF}
  if TOB_JourTrav <> nil then TOB_JourTrav.Free;
  if TOB_TauxAT <> nil then TOB_TauxAT.Free;
  //TOB_Salarie.Free;
  if TOB_CumulSal <> nil then TOB_CumulSal.Free;
  if TOB_VenRem <> nil then TOB_VenRem.Free;
  if TOB_VenCot <> nil then TOB_VenCot.Free;

  if TOBAna <> nil then TOBAna.Free;

  TOB_Paie := nil;
  TOB_RemSal := nil;
  TOB_RemHeures := nil;
  TOB_RemPrimes := nil;
  TOB_RemAbs := nil;
  TOB_RemCplt := nil;
  TOB_RemAvt := nil;
  TOB_RemAbt := nil;
  TOB_RemRet := nil;
  TOB_RemNonImp := nil;
{$IFDEF aucasou}
  TOB_ProfilPaies := nil;
  TOB_Cotisations := nil;
  TOB_Bases := nil;
  TOB_ProfilRubs := nil;
  TOB_Rem := nil;
  TOB_Variables := nil;
  TOB_CumulRubrique := nil;
  TOB_Cumuls := nil;
  TOB_Etablissement := nil;
  TOB_EltNationauxCEG := nil;
  TOB_EltNationauxSTD := nil;
  TOB_EltNationauxCEG := nil;
  TOB_Minimum := nil;
  TOB_DetailMin := nil;
  TOB_VentilRem := nil;
  TOB_VentilCot := nil;
{$ENDIF}

  TOB_JourTrav := nil;
  TOB_TauxAT := nil;
  TOBAna := nil;
  // TOB_Salarie:=NIL;
  TOB_CumulSal := nil;
  TOB_VenRem := nil;
  TOB_VenCot := nil;
  if AvecInit = TRUE then InitLesTOBPaie;
  if Assigned(ObjTM3VM) then
  begin
    ObjTM3VM.Free; // destruction objet VM script
    ObjTM3VM := nil;
  end;
  //PT61 Vidage de la tob calendrier
  if Tob_CalendrierSalarie <> nil then
  begin
    Tob_CalendrierSalarie.free;
    Tob_CalendrierSalarie := nil;
  end;
  // PT84   : 26/08/2003 PH V_42 Mise en place saisie arret
  FreeAndNil(TOB_SaisieArret);
end;

procedure RAZTOBPaie();
begin
  if Assigned(TOB_Paie) then FreeAndNil(TOB_Paie);
  if Assigned(TOB_RemSal) then FreeAndNil(TOB_RemSal);
  if Assigned(TOB_RemHeures) then FreeAndNil(TOB_RemHeures);
  if Assigned(TOB_RemPrimes) then FreeAndNil(TOB_RemPrimes);
  if Assigned(TOB_RemAbs) then FreeAndNil(TOB_RemAbs);
  if Assigned(TOB_RemCplt) then FreeAndNil(TOB_RemCplt);
  if Assigned(TOB_RemAvt) then FreeAndNil(TOB_RemAvt);
  if Assigned(TOB_RemAbt) then FreeAndNil(TOB_RemAbt);
  if Assigned(TOB_RemRet) then FreeAndNil(TOB_RemRet);
  if Assigned(TOB_RemNonImp) then FreeAndNil(TOB_RemNonImp);
  Nettoyage_Rem();
  Nettoyage_ProfilPaies();
  Nettoyage_Cotisations();
  Nettoyage_Bases();
  Nettoyage_Variables();
  Nettoyage_Cumuls();
  Nettoyage_Etablissement();
  Nettoyage_EltNationauxSTD();
  Nettoyage_EltNationauxCEG();
  Nettoyage_EltNationauxDOS();
  Nettoyage_Minimum();
  Nettoyage_DetailMin();
  Nettoyage_VentilRem();
  Nettoyage_VentilCot();
  if Assigned(TOB_JourTrav) then FreeAndNil(TOB_JourTrav);
  if Assigned(TOB_TauxAT) then FreeAndNil(TOB_TauxAT);
  if Assigned(TOB_CumulSal) then FreeAndNil(TOB_CumulSal);
  if Assigned(TOB_VenRem) then FreeAndNil(TOB_VenRem);
  if Assigned(TOB_VenCot) then FreeAndNil(TOB_VenCot);
  if Assigned(TOBAna) then FreeAndNil(TOBAna);
  if Assigned(Tob_CalendrierSalarie) then FreeAndNil(Tob_CalendrierSalarie);
end;


{Rend la valeur d'un element national � une date donn�e
Si pas de date Alors rend le dernier �l�ment/date trouv�
Si �l�ment non renseign� alors Message Erreur ==> Probl�me de param�trage du
plan de paie
Attention, il manque la gestion de l'EURO pour retourner la valeur dans la bonne monnaie
}

function ValEltNat(const Elt: string; const DatVal: TDateTime): double;
var
  ret: double;
  St: string;
begin
  ret := 0; // initialisation dans le cas peu probable o� on ne trouve pas
  // Il convient de differencier le petit du grand decalage de paie
  // Le petit est bas� sur un exercice social correspond � l'exercice civil
  // alors que le grand est d�cal� - 1 mois
  // PT62    07/11/2002 PH V591 Prise en compte du decalage de paie donc le traitement depend de l'�l�ment
  //         national et du decalage, il faut en tenir compte dans la focntion d'�valuation
  //if (VH_Paie.PGDecalage=True) then DatTrait := PLUSMOIS(DatTrait, 1);
  //if (VH_Paie.PGDecalagePetit=True) then DatTrait := PLUSMOIS(DatTrait, 1);

  if Elt = '' then
  begin
    St := 'Salari� : ' + CodSal + ' El�ment National non renseign�';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
  end
  else
  begin
    // PT60 07/10/2002 PH V585 Recherche d'un element national par pr�f�rence DOS,STD,CEG
    ret := ValEltNatPref(Elt, 'DOS', DatVal);
    if ret = -123456 then ret := ValEltNatPref(Elt, 'STD', DatVal);
    if ret = -123456 then ret := ValEltNatPref(Elt, 'CEG', DatVal);
  end;
  if ret = -123456 then ret := 0; // PT120
  result := ret;
end;
{ Fonction qui rend le taux horaire stock� dans la fiche Salari�
Dans le cas ou celui ci est nul, il faut essayer de la caculer}

function TauxHoraireSal(): double;
begin
  result := TOB_Salarie.GetValeur(iPSA_TAUXHORAIRE);
end;
{ Fonction qui rend le salaire mensuel de la fiche salari�}

function SalaireMensuelSal(): double;
begin
  result := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS1);
end;
{ Fonction qui rend le salaire annuel de la fiche salari�}

function SalaireAnnuelSal(): double;
begin
  result := TOB_Salarie.GetValeur(iPSA_SALAIRANN1);
end;
{ Rend la valeur d'un cumul de date � date.   Les dates sont renseign�es par la function appelante
Attention, pour le moment la fonction fait le calcul quelque soit l'etablissement
Voir s'il faut filtrer l'etablissement ou rajouter un param�tre pour traiter ou non l'etablissement
}

function ValCumulDate(const Cumul: string; const DateDebut, DateFin: TDateTime): double;
var
  Q: TQuery;
  st: string;
begin
  // PT44  group by pour forcer index ????
  // PT50 : 01/07/2002 PH V582 modif sur clacul fourchette de dates pour les variables de type cumul
  St := 'SELECT SUM(PHC_MONTANT) FROM HISTOCUMSAL WHERE PHC_SALARIE="' + CodSal + '" AND PHC_DATEDEBUT>="' + UsDateTime(DateDebut) + '" AND PHC_DATEFIN<="' + UsDateTime(DateFin) +
    '" AND PHC_CUMULPAIE="' + Cumul + '"'; // GROUP BY PHC_SALARIE,PHC_DATEDEBUT,PHC_DATEFIN,PHC_REPRISE,PHC_CUMULPAIE';
  Q := OpenSQL(St, TRUE);
  if not Q.EOF then result := Q.Fields[0].AsFloat
  else result := 0;
  // PT1
  Ferme(Q);
end;
{ Rend la valeur d'une rubrique de date � date.   Les dates sont renseign�es par la function appelante
Attention, pour le moment la fonction fait le calcul quelque soit l'etablissement
Voir s'il faut filtrer l'etablissement ou rajouter un param�tre pour traiter ou non l'etablissement
Optimisation de la requete SQL faite sur le serveur car c'est la requete qui fait les calculs
A la charge de la fonction de renseigner le record en fonction du type de rubrique
}

function ValRubDate(const Rubrique: string; Nature: string; const DateDebut, DateFin: TDateTime): TRendRub;
var
  Q: TQuery;
  ch: string;
  RendRub: TRendRub; // variable contenant le record retourn� par la fonction
begin
  with RendRub do
  begin
    MontRem := 0;
    BasRem := 0;
    TauxRem := 0;
    CoeffRem := 0;
    BasCot := 0;
    TSal := 0;
    MSal := 0;
    TPat := 0;
    MPat := 0;
    Plfd1 := 0;
    Plfd2 := 0;
    Plfd3 := 0;
    Tr1 := 0;
    Tr2 := 0;
    Tr3 := 0;
    Base := 0;
  end;
  // PT29 : 27/12/2001 V571 PH Calcul des variables de type r�mun�ration tq sur Mois - 1
  if Nature = 'REM' then Nature := 'AAA';

  if Nature = 'AAA' then Ch := 'SUM(PHB_MTREM),SUM(PHB_BASEREM),MAX(PHB_TAUXREM),MAX(PHB_COEFFREM)';
  if Nature = 'BAS' then Ch := 'SUM(PHB_PLAFOND1),SUM(PHB_TRANCHE1),SUM(PHB_TRANCHE2),SUM(PHB_TRANCHE3),SUM(PHB_BASECOT),SUM(PHB_PLAFOND2),SUM(PHB_PLAFOND3) ';
  if Nature = 'COT' then Ch := 'SUM(PHB_BASECOT),MAX(PHB_TAUXSALARIAL),MAX(PHB_TAUXPATRONAL),SUM(PHB_MTSALARIAL),SUM(PHB_MTPATRONAL)';
  Q := OpenSQL('SELECT ' + Ch + ' FROM HISTOBULLETIN WHERE PHB_SALARIE="' + CodSal + '" AND PHB_DATEDEBUT>="' + UsDateTime(DateDebut) + '" AND PHB_DATEFIN<="' + UsDateTime(DateFin)
    + '" AND PHB_NATURERUB="' + Nature + '" AND PHB_RUBRIQUE="' + Rubrique + '"', TRUE);
  if not Q.EOF then
  begin
    with RendRub do
    begin
      if Nature = 'AAA' then
      begin
        MontRem := Q.Fields[0].AsFloat;
        BasRem := Q.Fields[1].AsFloat;
        TauxRem := Q.Fields[2].AsFloat;
        CoeffRem := Q.Fields[3].AsFloat;
      end;
      if Nature = 'BAS' then
      begin
        Plfd1 := Q.Fields[0].AsFloat;
        Tr1 := Q.Fields[1].AsFloat;
        Tr2 := Q.Fields[2].AsFloat;
        Tr3 := Q.Fields[3].AsFloat;
        Base := Q.Fields[4].AsFloat;
        Plfd2 := Q.Fields[5].AsFloat;
        Plfd3 := Q.Fields[6].AsFloat;
      end;
      if Nature = 'COT' then
      begin
        BasCot := Q.Fields[0].AsFloat;
        TSal := Q.Fields[1].AsFloat;
        TPat := Q.Fields[2].AsFloat;
        MSal := Q.Fields[3].AsFloat;
        MPat := Q.Fields[4].AsFloat;
      end;
    end;
  end;
  Ferme(Q);
  result := RendRub;
end;
{
Fonction qui calcule le num�rateur du trentieme. Par defaut, le denominateur est tjrs 30.
Quand les dates correspondent � un d�but et une fin de mois, on a tjrs 30/30.
Quand le mois n'est pas complet alors on prend le nombre de jours travaill�s comme num�rateur
quelque soit le nbre de jours dans le mois (28,29,30 ou 31).
Exceptions : Si la p�riode est sup�rieure � 1 mois.
Alors, il convient de calculer le nombre de mois entier calcule en trentieme et de rajouter le nombre
de jours travaill�s sur le dernier mois
exemple : 010199 au 150299 Janvier =30/30 F�vrier =15/30 soit pour 1,5 mois 45/30 et
non 31 + 15 = 46 jours.
Pour des raisons de convenance, le num�rateur et le d�nominateur sont modifiables dans la saisie
de bulletin pour saisir 31/31 sur Janvier.
}

function CalculTrentieme(const DateDebut, DateFin: TDateTime; TestPaie: Boolean = FALSE): Integer;
var
  calcul, NbreJour, NbreMois, Nbt: Integer;
  NMois, PremMois, PremAnnee: WORD;
  St: string;
  OkOk: Boolean;
  Q: TQuery;
begin
  calcul := 0;
  NbreMois := 0;
  NbreJour := 0;
  NMois := 0;
  PremMois := 0;
  PremAnnee := 0;
  if (DateDebut = 0) or (DateFin = 0) then
  begin
    St := 'Salari� : ' + CodSal + ' Trenti�me : La date de d�but ou la date de fin ne sont pas renseign�es';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
  end
  else
  begin
    if (EstDebutMois(DateDebut)) and (EstFinMois(DateFin)) then
    begin
      NOMBREMOIS(DateDebut, DateFin, PremMois, PremAnnee, NMois);
      if NMois = 1 then calcul := 30
      else calcul := 30 * NMois;
    end
    else
    begin
      okok := DiffMoisJour(DateDebut, DateFin, NbreMois, NbreJour);
      if NbreMois <> 0 then calcul := 30 * NbreMois; // conversion du nombre de mois en trentieme de mois
      if NbreJour <> 0 then // Rajout du nombre de jour
      begin
        calcul := calcul + NbreJour;
        if not OkOk then calcul := calcul + 1;
      end;
    end;
  end;
  // DEB PT117
  if (not EstDebutMois(DateDebut)) and TestPaie then
  begin // Cas ou il y a une paie ant�rieure donc on va limiter � 30 trenti�me
    st := 'SELECT SUM (PPU_NUMERATTRENT) NBTRENT FROM PAIEENCOURS WHERE PPU_SALARIE = "' + CodSal + '" AND PPU_DATEDEBUT >="' +
      UsDatetime(DEBUTDEMOIS(DateDebut)) + '" AND PPU_DATEFIN < "' + UsDatetime(DateDebut) + '"';
    Q := OpenSQl(St, TRUE);
    if not Q.EOF then Nbt := Q.FindField('NBTRENT').AsInteger
    else Nbt := 0;
    FERME(Q);
    if Calcul + Nbt > 30 then Calcul := 30 - Nbt;
  end; // FIN PT117
  result := calcul;
end;
// Fonction qui indique si la date est un d�but de mois

function EstDebutMois(const LaDate: TDateTime): boolean;
var
  UneDate: TDateTime;
begin
  result := FALSE;
  UneDate := LaDate;
  if UneDate = DebutdeMois(LaDate) then result := TRUE;
end;
// Fonction qui indique si la date est une fin de mois

function EstFinMois(const LaDate: TDateTime): boolean;
var
  UneDate: TDateTime;
begin
  result := FALSE;
  UneDate := LaDate;
  if UneDate = FindeMois(LaDate) then result := TRUE;
end;
{ Fonction qui calcule le nombre de mois entre 2 dates et le nombre de jours restants
NbreMois contient le nombre de mois entier entre les 2 dates et NbreJour contient le nombre de
jours entre la date de fin et le debut du mois concernant la date de fin
}

function DiffMoisJour(const DateDebut, DateFin: TDateTime; var NbreMois, NbreJour: Integer): Boolean;
var
  PremMois, PremAnnee, NMois: WORD;
  DateCal: TDateTime;
  Calcul: double;
begin
  result := FALSE;
  PremMois := 0;
  PremAnnee := 0;
  NMois := 0;
  Calcul := 0; // PT31
  if DateDebut = DateFin then
  begin
    NbreJour := 1;
    NbreMois := 0;
    result := TRUE;
    exit;
  end;
  NOMBREMOIS(DateDebut, DateFin, PremMois, PremAnnee, NMois);
  //if (EstFinMois(DateFin)) then NMois:=NMois-1; // Car prend en compte le mois non complet
  if NMois > 0 then NMois := NMois - 1;
  NbreMois := NMois;
  if NMois = 0 then
  begin
    Calcul := DateFin - DateDebut;
    NbreJour := StrToInt(FloatToStr(Calcul));
    exit;
  end;
  {DateCal:=FindeMois (DateDebut);
  Calcul:=DateCal-DateDebut;}
  // 3 cas � g�rer
  if (EstDebutMois(DateDebut)) and (not EstFinMois(DateFin)) then
  begin
    DateCal := DebutdeMois(DateFin);
    Calcul := DateFin - DateCal;
  end;
  if (not EstDebutMois(DateDebut)) and (EstFinMois(DateFin)) then
    Calcul := (FinDeMois(DateDebut)) - DateDebut;
  if Calcul >= 31 then Calcul := 30;
  if (not EstDebutMois(DateDebut)) and (not EstFinMois(DateFin)) then
  begin // On donne simplement le nombre de jours entre les 2 dates
    Calcul := DateFin - Datedebut;
    NbreMois := 0;
    result := TRUE;
  end;
  if Calcul = 0 then
  begin
    result := TRUE;
    Calcul := 1;
  end; // La date de fin correspond � un d�but de mois donc 1 trentieme
  // calcul ne peut contenir qu'une valeur entiere <= 31 jours ou > selon les 3 cas si on est sur plusieurs mois
  NbreJour := StrToInt(FloatToStr(Calcul));
end;
// Fonction qui rend le Nombre de mois D'anciennete

function AncienneteMois(const DateEntree, DateFin: TDateTime): WORD;
var
  PremMois, PremAnnee: WORD;
begin
  PremMois := 0;
  PremAnnee := 0;
  result := 0;
  if DateEntree = 0 then result := 0
    //PT82-2 On tient compte du nombre de mois entier
  else
  begin
    AglNombreDeMoisComplet(DateEntree, DateFin, PremMois, PremAnnee, result);
    if DateEntree = DateFin then result := 0; //PT96
  end;
end;
// Fonction qui rend le Nombre d'ann�e D'anciennete, elle calcule l'anciennete en mois et divise par 12

function AncienneteAnnee(const DateEntree, DateFin: TDateTime): WORD;
begin
  result := (AncienneteMois(DateEntree, DateFin)) div 12;
end;
// Fonction qui rend le nombre d'ann�e et de mois pour le calcul de l'age du salari�

procedure AgeSalarie(const DateFin: TDateTime; var Annee, Mois: WORD);
var
  PremMois, PremAnnee: WORD;
  DateNaissance: TDateTime;
begin
  PremMois := 0;
  PremAnnee := 0;
  DateNaissance := TOB_Salarie.GetValeur(iPSA_DATENAISSANCE);
  Annee := AncienneteAnnee(DateNaissance, DateFin);
  NOMBREMOIS(DateNaissance, DateFin, PremMois, PremAnnee, Mois);
end;
// Rend la valeur du cumul salari� calcul� dans la session de paie

function RendCumulSalSess(const Cumul: string): double;
var
  TRech: TOB;
begin
  result := 0;
  if TOB_CumulSal = nil then exit;
  TRech := Paie_RechercheOptimise(TOB_CumulSal, 'PHC_CUMULPAIE', Cumul); // $$$$
  if Assigned(TRech) and (iPHC_MONTANT = 0) then MemorisePhc(TRech);
  if TRech <> nil then Result := TRech.GetValeur(iPHC_MONTANT);
end;
{ Recherche en cascade d'un profil � partir du salari� � l'�tablissement
La fonction a pour but de rechercher le profil mis par d�faut au niveau de l'�tablissement
dans le cas o� le salari� n'est pas personnalis�
Profil FNAL : Idem Dossier donc lecture des param�tres de la paie
}

procedure RechercheProfil(const Champ1, Champ2: string; Salarie, T_Etab, TPE: TOB);
var
  suffixe, Profil: string;
begin
  suffixe := ExtractSuffixe(Champ2); // recup du suffixe du champ profil � traiter
  Profil := string(Salarie.GetValue(Champ1)); // Type Profil : Idem Etab ou Personnalis�
  {  PT-10 07/09/01 V547 PH Test du profil FNAL si Profil '' et non FNAL alors on recherche idem etab
   ceci pour compenser le fait que la zone n'est pas saisie ou mal initialis�e ne provoque pas d'erreur mais
   une exception en vision SAV
  }
  if ((Profil = 'ETB') or (Profil = '')) and (suffixe <> 'PROFILFNAL') then
  begin
    if T_Etab.GetValue('ETB_' + suffixe) <> NULL then Profil := T_Etab.GetValue('ETB_' + suffixe)
    else Profil := '';
  end
  else
  begin // Il n'y a que le profil FNAL qui soit param�trable au niveau du dossier
    if (suffixe = 'PROFILFNAL') and (Profil = 'DOS') then Profil := string(GetParamSoc('SO_PG' + suffixe))
    else Profil := string(Salarie.GetValeur(NumChampProfS(Champ2)));
  end;
  if Profil <> '' then ChargeProfil(Salarie, TPE, Profil);
end;
{ Fonction qui compare la liste TPE des rubriques provenant des profils du salari�s
et une rubrique du bulletin pr�c�dent TPR. Si une rubrique n'existe pas dans TPE
mais existe dans TPR alors on l'a prend si PHB_CONVERSATION=TRUE.
On en profite pour traiter chaque rubrique de TPR pour voir les �l�m�nts permanents
et si on en trouve on r�cup�re les valeurs.
Au d�part les rubriques en provenance des profils ne sont pas valoris�es, c'est la fonction
de calcul du bulletin qui valorise les lignes en fonction des param�trages. Il reste � la
fonction de calcul du bulletin de valoriser toutes les rubriques en fonction des �l�ments
nationaux, remun�ration, cotisations et variable.
On r�cup�re aussi les libell�s modifi�s des rubriques composant le bulletin prec�dant
}

procedure MajRubriqueBulletin(TPE, TPR: TOB; const CodSal, Etab: string; const DateDeb, DateFin: TDateTime);
var
  THB, TRech: TOB;
  Rubrique, NatureRub, Libel: string;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  // dans ce cas on ne recherche aucun �l�ment sur une paie ant�rieure
  if BullCompl = 'X' then exit;

  Rubrique := TPR.GetValue('PHB_RUBRIQUE');
  NatureRub := TPR.GetValue('PHB_NATURERUB');
  Libel := TPR.GetValue('PHB_LIBELLE');
  TRech := TPE.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], [NatureRub, Rubrique], TRUE); // $$$$
  if TRech <> nil then
  begin // Rubrique existante = recup libelle
    TRech.PutValue('PHB_LIBELLE', Libel);
    if NatureRub = 'AAA' then RecupEltPermanent(TRech, TPR, Rubrique); // les �l�ments permanents ne sont que sur les R�mun�rations
  end
  else
  begin // Voir pour le cas de suppression de ligne de profils
    if TPR.GetValue('PHB_CONSERVATION') = 'SAL' then // Cas ou la rubrique est � conserver
    begin
      THB := TOB.Create('HISTOBULLETIN', TPE, -1);
      THB.Dupliquer(TPR, FALSE, TRUE, TRUE);
      //  ok:=TPR.ChangeParent (THB, -1); // recup de la ligne bulletin dans la totalit�
      THB.PutValue('PHB_ETABLISSEMENT', Etab);
      THB.PutValue('PHB_SALARIE', CodSal);
      THB.PutValue('PHB_DATEDEBUT', DateDeb);
      THB.PutValue('PHB_DATEFIN', DateFin);
      // DEB PT95 rajout appel fonction recup des �lements qui remet aussi � 0 les champs concern�s si ils concernent des �l�ments variables
      if NatureRub = 'AAA' then RecupEltPermanent(THB, TPR, Rubrique, 'SAL');
      // FIN PT95
    end;
  end;
end;
{ Fonction qui r�cup�re les �l�ments permanents de la paie pr�c�dente
Elle permet aussi de r�cup�rer en fonction du param�trage soci�t� de la r�cup�ration des
�l�ments permanents
PT95   : 12/01/2004 PH V_50 FQ 11024 Rubrique sur le bulletin en origine salari� reprend les valeurs m�me si elt variable
Donc si on a une rubrique d'origine salari� alors on regarde si c'est un �lement variable alors
on remet � 0 les zones concern�es.
}
// DEB PT95

procedure RecupEltPermanent(TPE, TPR: TOB; const Rubrique: string; Conservation: string = '');
var
  Rub: TOB;
  TypB, TypC, TypT, TypM: string; // Type des differents champs composant une r�mun�ration
begin
  Rub := Paie_RechercheOptimise(TOB_Rem, 'PRM_RUBRIQUE', Rubrique); // $$$$
  if Rub <> nil then
  begin
    TypB := Rub.GetValue('PRM_TYPEBASE');
    TypT := Rub.GetValue('PRM_TYPETAUX');
    TypC := Rub.GetValue('PRM_TYPECOEFF');
    TypM := Rub.GetValue('PRM_TYPEMONTANT');
    if TypB = '01' then TPE.PutValue('PHB_BASEREM', TPR.GetValue('PHB_BASEREM'))
    else if (Conservation = 'SAL') and (TypB = '00') then TPE.PutValue('PHB_BASEREM', 0);
    if TypT = '01' then TPE.PutValue('PHB_TAUXREM', TPR.GetValue('PHB_TAUXREM'))
    else if (Conservation = 'SAL') and (TypT = '00') then TPE.PutValue('PHB_TAUXREM', 0);
    if TypC = '01' then TPE.PutValue('PHB_COEFFREM', TPR.GetValue('PHB_COEFFREM'))
    else if (Conservation = 'SAL') and (TypC = '00') then TPE.PutValue('PHB_COEFFREM', 0);
    if TypM = '01' then TPE.PutValue('PHB_MTREM', TPR.GetValue('PHB_MTREM'))
    else if (Conservation = 'SAL') and (TypM = '00') then TPE.PutValue('PHB_MTREM', 0);
  end;
end;
// FIN PT95

procedure AligneProfil(Salarie, T_Etab, TPE: TOB; ActionB: TActionBulletin);
var
  Q: TQuery;
  ThemeProfil: string;
begin
  ThemeProfil := '';
  //DEB PT106
  if not ForceAlignProfil and (ActionB = taModification) then exit;
  ForceAlignProfil := FALSE;
  //FIN PT106
    // Chargement des rubriques de chaque profil ref�renc� au niveau salari�
    //PT-12 02/10/01 V562 PH Rajout Profil R�mun�ration du Salari�
  RechercheProfil('PSA_TYPPROFILREM', 'PSA_PROFILREM', Salarie, T_Etab, TPE);
  // Profil Salari� mod�le de bulletin
  RechercheProfil('PSA_TYPPROFIL', 'PSA_PROFIL', Salarie, T_Etab, TPE);
  // Profil Periodicite bulletin
  RechercheProfil('PSA_TYPPERIODEBUL', 'PSA_PERIODBUL', Salarie, T_Etab, TPE);
  // Profil R�duction Bas Salaire
  RechercheProfil('PSA_TYPPROFILRBS', 'PSA_PROFILRBS', Salarie, T_Etab, TPE);
  // Profil R�duction REPAS
  RechercheProfil('PSA_TYPREDREPAS', 'PSA_REDREPAS', Salarie, T_Etab, TPE);
  // Profil R�duction RTT 1 Loi Aubry 2
  RechercheProfil('PSA_TYPREDRTT1', 'PSA_REDRTT1', Salarie, T_Etab, TPE);
  // Profil R�duction RTT 2 Loi Robien
  RechercheProfil('PSA_TYPREDRTT2', 'PSA_REDRTT2', Salarie, T_Etab, TPE);
  // Profil Temps Partiel
  ChargeProfil(Salarie, TPE, Salarie.GetValeur(iPSA_PROFILTPS));
  // Profil Abattement pour frais Professionnels
  RechercheProfil('PSA_TYPPROFILAFP', 'PSA_PROFILAFP', Salarie, T_Etab, TPE);
  // Profil Gestion des Appoints
  RechercheProfil('PSA_TYPPROFILAPP', 'PSA_PROFILAPP', Salarie, T_Etab, TPE);
  // Profil Maladie Maintien Salaire supprim� car inclus dans les profils temporaires du bulletin
  //RechercheProfil ('PSA_TYPPROFILMMS', 'PSA_PROFILMMS', Salarie,T_Etab,TPE, ThemRubExclus);
  // PT37 : 02/04/2002 PH V571 traitement du profil retraite
  // Profil retraite
  RechercheProfil('PSA_TYPPROFILRET', 'PSA_PROFILRET', Salarie, T_Etab, TPE);
  // PRofil Mutuelle
  RechercheProfil('PSA_TYPPROFILMUT', 'PSA_PROFILMUT', Salarie, T_Etab, TPE);
  // Profil Pr�voyance
  RechercheProfil('PSA_TYPPROFILPRE', 'PSA_PROFILPRE', Salarie, T_Etab, TPE);
  // Profil Taxe sur les Salaires
  RechercheProfil('PSA_TYPPROFILTSS', 'PSA_PROFILTSS', Salarie, T_Etab, TPE);
  // Profil Repos Compensateur
  // ReChercheProfil ('PSA_TYPPROFILRCO', 'PSA_PROFILRCO', Salarie,T_Etab,TPE);
  // Profil Cong�s Pay�s
  RechercheProfil('PSA_TYPPROFILCGE', 'PSA_PROFILCGE', Salarie, T_Etab, TPE);
  // Profil fin de CDD
  ChargeProfil(Salarie, TPE, Salarie.GetValeur(iPSA_PROFILCDD));
  // Profil Multi Employeur
  ChargeProfil(Salarie, TPE, Salarie.GetValeur(iPSA_PROFILMUL));
  // Profil Multi FNAL
  RechercheProfil('PSA_TYPPROFILFNAL', 'PSA_PROFILFNAL', Salarie, T_Etab, TPE);
  // Profil Multi Transport
  RechercheProfil('PSA_TYPPROFILTRANS', 'PSA_PROFILTRANS', Salarie, T_Etab, TPE);
  // Profil Anciennet�
  RechercheProfil('PSA_TYPPROFILANC', 'PSA_PROFILANCIEN', Salarie, T_Etab, TPE);

  // Cas des profils temporaires cad maladie, chomage qui sont uniquement sur le bulletin
  // Chargement des rubriques pour les profils CAS Particuliers dans ce cas
  // Boucle de chargement sur 2 ou 3 lignes maxi
  Q := OPENSQL('SELECT * FROM PROFILSPECIAUX WHERE PPS_ETABSALARIE="-" AND PPS_CODE="' + Salarie.GetValeur(iPSA_SALARIE) + '"', TRUE);
  while not Q.EOF do
  begin
    ThemeProfil := Q.FindField('PPS_THEMEPROFIL').AsString;
    ChargeProfil(Salarie, TPE, Q.FindField('PPS_PROFIL').AsString);
    Q.Next;
  end;
  Ferme(Q);
end;

{ Fonction d'alimentation des cumuls du salari� pour une rubrique
Pr�pare la structure HISTOCUMSAL qui donnera la possibilit� d'�crire les enregistrements
dans la table.
}

procedure AlimCumulSalarie(THB: TOB; const Salarie, NatureRub, Rubrique, Etab: string; const DateDebut, DateFin: TDateTime);
var
  TRechRub, TRechCum, TRechCumRub, TRechCumSal: TOB;
  Cumul, TypeAlim, Sens, St, LeCoeff: string;
  I: Integer;
  Montant, MtSupp, Coeff: Double;
begin
  MtSupp := 0; // Montant � ajouter/supprimer du cumul salari�
  Cumul := '';
  TypeAlim := '';
  Sens := '';
  TRechRub := Paie_RechercheRubrique(NatureRub, Rubrique);
  if not Assigned(TRechRub) then exit; // Rubrique non trouv�e ne devrait jamais se produire
  if (TRechRub.detail.count > 0) and (iPCR_SENS = 0) then MemorisePcr(TRechRub.detail[0]);
  if Assigned(THB) and (iPHB_BASEREM = 0) then MemorisePhb(THB);

  for I := 0 to TRechRub.Detail.Count - 1 do // boucle sur la recherche des cumuls aliment�s par la rubrique
  begin
    TRechCumRub := TRechRub.Detail[I];
    Cumul := TRechCumRub.GetValeur(iPCR_CUMULPAIE);
    if Cumul = '' then
    begin
      St := 'Salari� : ' + CodSal + ' Cumul Erron�';
      if TypeTraitement <> 'PREPA' then PGIBox(St, '') else TraceErr.Items.Add(St);
    end;

    Sens := TRechCumRub.GetValeur(iPCR_SENS); // Sens alimentation du cumul
    TRechCum := Paie_RechercheOptimise(TOB_Cumuls, 'PCL_CUMULPAIE', Cumul); // $$$$
    if Assigned(TRechCum) and (iPCL_ALIMCUMUL = 0) then MemorisePcl(TRechCum);

    if TrechCum <> nil then
    begin // Cumul trouv� et r�cup�ration du type d'alimentation en fonction du type de rubrique
      if NatureRub = 'AAA' then TypeAlim := TRechCum.GetValeur(iPCL_ALIMCUMUL)
      else TypeAlim := TRechCum.GetValeur(iPCL_ALIMCUMULCOT);

      if (TypeAlim <> '') and (TypeAlim <> 'ZZZ') then
      begin
        TRechCumSal := TOB_CumulSal.FindFirst(['PHC_ETABLISSEMENT', 'PHC_SALARIE', 'PHC_DATEDEBUT', 'PHC_DATEFIN', 'PHC_REPRISE', 'PHC_CUMULPAIE'],
          [Etab, Salarie, DateDebut, DateFin, '-', Cumul], FALSE); // $$$$
        if TRechCumSal = nil then
        begin // Cr�ation du cumul salari� avec initialisation de tous les champs
          Montant := 0;
          TRechCumSal := TOB.Create('HISTOCUMSAL', TOB_CumulSal, -1);
          with TRechCumSal do
          begin // Optimisation
            if iPHC_ETABLISSEMENT = 0 then MemorisePhc(TRechCumSal);

            PutValeur(iPHC_ETABLISSEMENT, Etab);
            PutValeur(iPHC_SALARIE, Salarie);
            PutValeur(iPHC_DATEDEBUT, DateDebut);
            PutValeur(iPHC_DATEFIN, DateFin);
            PutValeur(iPHC_REPRISE, '-');
            PutValeur(iPHC_CUMULPAIE, Cumul);
            PutValeur(iPHC_MONTANT, Montant);
            PutValeur(iPHC_TRAVAILN1, TOB_Salarie.GetValeur(iPSA_TRAVAILN1));
            PutValeur(iPHC_TRAVAILN2, TOB_Salarie.GetValeur(iPSA_TRAVAILN2));
            PutValeur(iPHC_TRAVAILN3, TOB_Salarie.GetValeur(iPSA_TRAVAILN3));
            PutValeur(iPHC_TRAVAILN4, TOB_Salarie.GetValeur(iPSA_TRAVAILN4));
            PutValeur(iPHC_CODESTAT, TOB_Salarie.GetValeur(iPSA_CODESTAT));
            PutValeur(iPHC_CONFIDENTIEL, TOB_Salarie.GetValeur(iPSA_CONFIDENTIEL));
            PutValeur(iPHC_LIBREPCMB1, TOB_Salarie.GetValeur(iPSA_LIBREPCMB1));
            PutValeur(iPHC_LIBREPCMB2, TOB_Salarie.GetValeur(iPSA_LIBREPCMB2));
            PutValeur(iPHC_LIBREPCMB3, TOB_Salarie.GetValeur(iPSA_LIBREPCMB3));
            PutValeur(iPHC_LIBREPCMB4, TOB_Salarie.GetValeur(iPSA_LIBREPCMB4));
          end;
        end
        else Montant := TRechCumSal.GetValeur(iPHC_MONTANT);

        if NatureRub = 'AAA' then // R�mun�ration
        begin
          if TypeAlim = 'BAS' then MtSupp := THB.GetValeur(iPHB_BASEREM)
          else if TypeAlim = 'MSA' then MtSupp := THB.GetValeur(iPHB_MTREM);
        end
        else if NatureRub = 'BAS' then // Base de Cotisation
        begin
          if TypeAlim = 'BAS' then MtSupp := THB.GetValeur(iPHB_BASECOT); // @@@@ Base + Tranches + Palfond
        end
        else if NatureRub = 'COT' then // Cotisation
        begin
          if TypeAlim = 'BAS' then MtSupp := THB.GetValeur(iPHB_BASECOT)
          else if TypeAlim = 'MSA' then MtSupp := THB.GetValeur(iPHB_MTSALARIAL)
          else if TypeAlim = 'MPT' then MtSupp := THB.GetValeur(iPHB_MTPATRONAL)
          else if TypeAlim = 'TRB' then MtSupp := THB.GetValeur(iPHB_TRANCHE2)
          else if TypeAlim = 'TRC' then MtSupp := THB.GetValeur(iPHB_TRANCHE3);
        end;
        // Recherche du coefficient � appliquer ex CSG 95%
        LeCoeff := TRechCum.GetValeur(iPCL_COEFFAFFECT);
        if LeCoeff <> '' then
        begin
          Coeff := ValEltNat(LeCoeff, DateFin);
          if Coeff <> 0 then MtSupp := MtSupp * Coeff;
        end;

        if Sens = '+' then MtSupp := Montant + MtSupp else MtSupp := Montant - MtSupp;

        TRechCumSal.PutValeur(iPHC_MONTANT, ARRONDI(MtSupp, 2));
      end; // fin si TypeAlim reconnu
    end; // fin si cumul existe
  end; // fin boucle sur la liste des cumuls aliment�s par une rubrique
end;
{ Procedure RAZ de la TOB TPE de la paie en cours
Elle d�truit les filles (lignes du bulletin) de la TOB TPE
Cette proc�dure est utilis�e pour la saisie du bulletin dans les cas du d�chargement des lignes afin
de pouvoir historiser les lignes du bulletins
}

procedure RazTPELignes(TPE: TOB);
begin
  TPE.ClearDetail;
end;
{ Fonction qui alimente la liste des rubriques du bulletin en fonction d'une grille de donn�es
}

procedure GrilleAlimLignes(TPE: TOB; Etab, Salarie, Nature: string; DateDebut, DateFin: TDateTime; GrilleBulletin: THGrid; ActionBul: TActionBulletin);
var
  i: Integer;
  Rubrique, Libelle, St: string;
  THB, T_Rub, T_Com, TSal: TOB;
  ObjetACreer: Boolean;
begin
  if (Etab = '') or (Salarie = '') or (Nature = '') or (DateDebut = 0) or (DateFIN = 0) then
  begin
    St := 'Salari� : ' + CodSal + ' Erreur Champs non renseign�s dans la Grille';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
  end;

  TSal := TOB_Salarie;
  if TSal = nil then
  begin
    // TOB_Salarie:=TOB.Create('SALARIES',Nil,-1) ;
    // TOB_Salarie.SelectDB('"'+CodSal+'"',Nil,TRUE) ;
    RecupTobSalarie(CodSal);
    TSal := TOB_Salarie;
  end;
  Libelle := '';
  for i := 1 to GrilleBulletin.RowCount - 1 do
  begin
    Rubrique := GrilleBulletin.Cells[0, i];
    Libelle := GrilleBulletin.Cells[1, i];
    if Rubrique <> '' then
    begin
      ///   THB:=TOB.Create('HISTOBULLETIN',TPE,-1) ;
      //  if (ActionBul <> taCreation) AND (ActionBul<> PremCreation) then THB:=TOB(GrilleBulletin.Objects[0,i]) ;
      THB := TOB(GrilleBulletin.Objects[0, i]);
      ObjetACreer := FALSE;
      if THB = nil then
      begin
        THB := TOB.Create('HISTOBULLETIN', TPE, -1);
        ObjetACreer := TRUE;
      end;
      if Assigned(THB) and (iPHB_ETABLISSEMENT = 0) then MemorisePhb(THB);
      with THB do
      begin
        PutValeur(iPHB_ETABLISSEMENT, Etab);
        PutValeur(iPHB_SALARIE, Salarie);
        PutValeur(iPHB_DATEDEBUT, DateDebut);
        PutValeur(iPHB_DATEFIN, DateFin);
        PutValeur(iPHB_NATURERUB, Nature);
        PutValeur(iPHB_RUBRIQUE, Rubrique);
        PutValeur(iPHB_LIBELLE, Libelle);
        if TSal <> nil then
        begin
          PutValeur(iPHB_TRAVAILN2, TSal.GetValeur(iPSA_TRAVAILN2));
          PutValeur(iPHB_TRAVAILN3, TSal.GetValeur(iPSA_TRAVAILN3));
          PutValeur(iPHB_TRAVAILN4, TSal.GetValeur(iPSA_TRAVAILN4));
          PutValeur(iPHB_TRAVAILN1, TSal.GetValeur(iPSA_TRAVAILN1));
          PutValeur(iPHB_CODESTAT, TSal.GetValeur(iPSA_CODESTAT));
          PutValeur(iPHB_CONFIDENTIEL, TSal.GetValeur(iPSA_CONFIDENTIEL));
          PutValeur(iPHB_LIBREPCMB1, TSal.GetValeur(iPSA_LIBREPCMB1));
          PutValeur(iPHB_LIBREPCMB2, TSal.GetValeur(iPSA_LIBREPCMB2));
          PutValeur(iPHB_LIBREPCMB3, TSal.GetValeur(iPSA_LIBREPCMB3));
          PutValeur(iPHB_LIBREPCMB4, TSal.GetValeur(iPSA_LIBREPCMB4));
        end
        else
        begin
          PutValeur(iPHB_TRAVAILN2, '');
          PutValeur(iPHB_TRAVAILN3, '');
          PutValeur(iPHB_TRAVAILN4, '');
          PutValeur(iPHB_TRAVAILN1, '');
          PutValeur(iPHB_CODESTAT, '');
          PutValeur(iPHB_CONFIDENTIEL, '0');
          PutValeur(iPHB_LIBREPCMB1, '');
          PutValeur(iPHB_LIBREPCMB2, '');
          PutValeur(iPHB_LIBREPCMB3, '');
          PutValeur(iPHB_LIBREPCMB4, '');
        end;
        if Nature = 'AAA' then
        begin // R�mun�ration
          T_RUB := Paie_RechercheOptimise(TOB_REM, 'PRM_RUBRIQUE', Rubrique); // $$$$
          if Assigned(T_RUB) and (iPHB_BASEREM = 0) then MemorisePrm(T_RUB); // Optimisation
          if T_RUB <> nil then
          begin
            PutValeur(iPHB_IMPRIMABLE, T_RUB.GetValeur(iPRM_IMPRIMABLE));
            PutValeur(iPHB_BASEREM, Valeur(GrilleBulletin.Cells[2, i]));
            PutValeur(iPHB_TAUXREM, Valeur(GrilleBulletin.Cells[3, i]));
            PutValeur(iPHB_COEFFREM, Valeur(GrilleBulletin.Cells[4, i]));
            PutValeur(iPHB_MTREM, Valeur(GrilleBulletin.Cells[5, i]));
            //    THB.PutValue('PHB_PREDEFINI', T_RUB.GetValue('PRM_PREDEFINI'));
            PutValeur(iPHB_IMPRIMABLE, T_RUB.GetValeur(iPRM_IMPRIMABLE));
            PutValeur(iPHB_BASEREMIMPRIM, T_RUB.GetValeur(iPRM_BASEIMPRIMABLE));
            PutValeur(iPHB_TAUXREMIMPRIM, T_RUB.GetValeur(iPRM_TAUXIMPRIMABLE));
            PutValeur(iPHB_COEFFREMIMPRIM, T_RUB.GetValeur(iPRM_COEFFIMPRIM));
            PutValeur(iPHB_ORDREETAT, T_RUB.GetValeur(iPRM_ORDREETAT));
            //PT22 : 22/11/01 V562 PH ORACLE, Le champ PHB_ORGANISME doit �tre renseign�
            PutValeur(iPHB_ORGANISME, '....');
            PutValeur(iPHB_SENSBUL, T_RUB.GetValeur(iPRM_SENSBUL));
            PutValeur(iPHB_CONSERVATION, AnsiUpperCase(Copy(GrilleBulletin.CellValues[6, i], 1, 3)));
          end
          else // Rubrique de Remun�ration non trouv�e, on regarde si ce n'est pas un commentaire
          begin
            if RechCommentaire(Rubrique) = TRUE then
            begin // Ordre de presentation de la rubrique lors de l'edition du bulletin est identique � la Rem dont elle d�pend
              PutValeur(iPHB_IMPRIMABLE, 'X'); // Rubrique de commentaire tjrs imprimable
              // PT24   27/11/2001 V563 PH Propagation d'une ligne de commentaire
              // Memorisation pour savoir si on doit reprendre la rubrique de commentaire sur le bulletin suivant
              if Copy(GrilleBulletin.CellValues[6, i], 1, 3) <> '' then
                PutValeur(iPHB_CONSERVATION, AnsiUpperCase(Copy(GrilleBulletin.CellValues[6, i], 1, 3)));
              T_Com := Paie_RechercheOptimise(TOB_REM, 'PRM_RUBRIQUE', RendCodeRub(Rubrique)); // $$$$
              if T_Com <> nil then PutValeur(iPHB_ORDREETAT, T_Com.GetValeur(iPRM_ORDREETAT));
            end;
          end;
        end
        else
        begin
          T_Rub := Paie_RechercheRubrique(Nature, Rubrique);
          if Assigned(T_Rub) and (iPCT_IMPRIMABLE = 0) then MemorisePct(T_Rub);
{$IFDEF aucasou}
          if Nature = 'COT' then T_RUB := TOB_Cotisations.FindFirst(['PCT_NATURERUB', 'PCT_RUBRIQUE'], [Nature, Rubrique], FALSE) // $$$$
          else T_RUB := TOB_Bases.FindFirst(['PCT_NATURERUB', 'PCT_RUBRIQUE'], [Nature, Rubrique], FALSE); // $$$$
{$ENDIF}
          if assigned(t_rub) then
          begin
            PutValeur(iPHB_IMPRIMABLE, T_RUB.GetValeur(iPCT_IMPRIMABLE));
            PutValeur(iPHB_BASECOTIMPRIM, T_RUB.GetValeur(iPCT_BASEIMP));
            PutValeur(iPHB_TAUXSALIMPRIM, T_RUB.GetValeur(iPCT_TXSALIMP));
            //    THB.PutValue('PHB_MTSALIMPRIM',T_RUB.GetValue('PCT_FFSALIMP')) ;
            PutValeur(iPHB_TAUXPATIMPRIM, T_RUB.GetValeur(iPCT_TXPATIMP));
            //    THB.PutValue('PHB_MTPATIMPRIM',T_RUB.GetValue('PCT_FFPATIMP')) ;
            PutValeur(iPHB_ORGANISME, T_RUB.GetValeur(iPCT_ORGANISME));
            PutValeur(iPHB_ORDREETAT, T_RUB.GetValeur(iPCT_ORDREETAT));
            PutValeur(iPHB_SENSBUL, 'P');
          end
          else
          begin
            if RechCommentaire(Rubrique) = TRUE then
            begin // Ordre de presentation de la rubrique lors de l'edition du bulletin est identique � la Rem dont elle d�pend
              PutValeur(iPHB_IMPRIMABLE, 'X'); // Rubrique de commentaire tjrs imprimable
              // PT24   27/11/2001 V563 PH Propagation d'une ligne de commentaire
              // Memorisation pour savoir si on doit reprendre la rubrique de commentaire sur le bulletin suivant
              if Copy(GrilleBulletin.CellValues[6, i], 1, 3) <> '' then
                PutValeur(iPHB_CONSERVATION, AnsiUpperCase(Copy(GrilleBulletin.CellValues[7, i], 1, 3)));
              T_Com := Paie_RechercheOptimise(TOB_Cotisations, 'PCT_RUBRIQUE', RendCodeRub(Rubrique)); // $$$$
{$IFDEF aucasou}
              T_Com := TOB_Cotisations.FindFirst(['PCT_RUBRIQUE'], [RendCodeRub(Rubrique)], FALSE); // $$$$
{$ENDIF}
              if T_Com <> nil then PutValeur(iPHB_ORDREETAT, T_Com.GetValeur(iPCT_ORDREETAT));
            end;
          end;

          if Nature = 'COT' then
          begin
            PutValeur(iPHB_BASECOT, Valeur(GrilleBulletin.Cells[2, i]));
            PutValeur(iPHB_TAUXSALARIAL, Valeur(GrilleBulletin.Cells[3, i]));
            PutValeur(iPHB_MTSALARIAL, Valeur(GrilleBulletin.Cells[4, i]));
            PutValeur(iPHB_TAUXPATRONAL, Valeur(GrilleBulletin.Cells[5, i]));
            PutValeur(iPHB_MTPATRONAL, Valeur(GrilleBulletin.Cells[6, i]));
            PutValeur(iPHB_CONSERVATION, AnsiUpperCase(Copy(GrilleBulletin.CellValues[7, i], 1, 3)));
          end;
          if Nature = 'BAS' then
          begin
            PutValeur(iPHB_BASECOT, Valeur(GrilleBulletin.Cells[2, i]));
            PutValeur(iPHB_PLAFOND, Valeur(GrilleBulletin.Cells[3, i]));
            PutValeur(iPHB_TRANCHE1, Valeur(GrilleBulletin.Cells[4, i]));
            PutValeur(iPHB_TRANCHE2, Valeur(GrilleBulletin.Cells[5, i]));
            PutValeur(iPHB_TRANCHE3, Valeur(GrilleBulletin.Cells[6, i]));
            PutValeur(iPHB_PLAFOND1, Valeur(GrilleBulletin.Cells[7, i]));
            PutValeur(iPHB_PLAFOND2, Valeur(GrilleBulletin.Cells[8, i]));
            PutValeur(iPHB_PLAFOND3, Valeur(GrilleBulletin.Cells[9, i]));
            // PT78  : 05/06/03 PH V_421 FQ 10700 Gestion origine de la rubrique dans les bases de cotisations
            PutValeur(iPHB_CONSERVATION, AnsiUpperCase(Copy(GrilleBulletin.CellValues[10, i], 1, 3)));
          end;
        end;
        if ObjetACreer = TRUE then GrilleBulletin.Objects[0, i] := THB;
        //PT22 : 22/11/01 V562 PH ORACLE, Le champ PHB_ORGANISME doit �tre renseign�
        if GetValeur(iPHB_ORGANISME) = '' then PutValeur(iPHB_ORGANISME, '....');

        if RechCommentaire(Rubrique) = FALSE then AlimCumulSalarie(THB, Salarie, Nature, Rubrique, Etab, DateDebut, DateFin);
      end;
    end;
  end;
end;
// Fonction de creation de la TOB des Cumuls Salari�s

procedure CreationTOBCumSal;
begin
  if TOB_Cumulsal <> nil then
  begin
    TOB_CumulSal.Free;
    TOB_CumulSal := nil;
  end;
  TOB_CumulSal := TOB.Create('Les Cumuls Salari�s', nil, -1);
end;
// Fonction de destruction de la  TOB des Cumuls Salari�s

procedure DestTOBCumSal;
begin
  if TOB_CumulSal <> nil then TOB_CumulSal.Free;
  TOB_CumulSal := nil;
end;
// Fonction qui indique si les cumuls salari�s ont �t� calcul�s

function OkCumSal: Boolean;
begin
  result := FALSE;
  if TOB_CumulSal <> nil then result := TRUE;
end;
// Fonction d'affchage d'un montant en fonction du nombre de d�cimales g�r�es pour le champ

function DoubleToCell(const X: Double; const DD: integer): string;
begin
  if X = 0 then Result := '' else Result := StrfMontant(X, 15, DD, '', TRUE);
end;

// Fonction de valorisation d'une ligne de r�mun�ration

function ValoriseMt(const cas: WORD; const Cc: string; const NbreDec: Integer; Base, Taux, Coeff: Double): Double;
var
  Mt: Double;
begin
  Mt := 0;
  if cas = 2 then // cas 2
  begin
    if Cc = '04' then Mt := Base * Taux
    else Mt := Base * (Taux / 100);
  end;
  if cas = 3 then // cas 3
  begin
    if Coeff = 0 then
    begin
      result := 0;
      exit;
    end;
    if Cc = '02' then Mt := Base * Taux * Coeff;
    if Cc = '03' then Mt := Base * (Taux / 100) * Coeff;
    if Cc = '06' then Mt := Base * (Taux / Coeff);
    if Cc = '07' then Mt := Base * (Taux / 100 / Coeff);
  end;
  // cas 4 et saisie du coeff Cc vaut tjrs 08
  if cas = 4 then Mt := Base * Coeff;
  Mt := ARRONDI(Mt, NbreDec);
  result := Mt;
end;
// Calcul de la r�mun�ration

function EvalueRem(Tob_Rub: TOB; const Rub: string; var Base, Taux, Coeff, Montant: Double; var lib: string; DateDeb, DateFin: TDateTime; ActionCalcul: TActionBulletin; Ligne:
  Integer): Boolean; // Calcul de la r�mun�ration
var
  T1, TRecup: TOB;
  St, Cc, TypeChamp, Champ: string;
  NbreDec, M1, M2, M3, M4: Integer;
  cas: WORD;
  ARecupererRem: Boolean;
  TobADetruire: Boolean;
  BaseRaz, Decalage: Boolean;
  MD, MF, MS, Mois, Annee: string;
  Mini, Maxi: Double; // Minimum et Maximum de la rubrique de r�mun�ration
begin
  result := FALSE;
  TobADetruire := FALSE;
  Base := 0;
  Taux := 0;
  Coeff := 0;
  Montant := 0;
  lib := '';
  T1 := Paie_RechercheOptimise(TOB_Rem, 'PRM_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
  T1 := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [Rub], FALSE); // $$$$
{$ENDIF}
  if Assigned(T1) and (iPRM_LIBELLE = 0) then MemorisePrm(T1);

  if T1 = nil then
  begin
    St := 'Le salari� ' + CodSal + ' La R�mun�ration ' + Rub + ' n''existe pas, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  TRecup := TOB_Rub.FindFirst(['PHB_RUBRIQUE', 'PHB_NATURERUB'], [Rub, 'AAA'], TRUE);
  if (TRecup = nil) and (ActionCalcul <> taCreation) then
  begin
    St := 'Le salari� ' + CodSal + ' La R�mun�ration ' + Rub + ' n''est pas dans le bulletin, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  result := TRUE;
  // doit correspondre au cas creation d'une ligne, si on doit recup�rer les valeurs d�j� saisies ????
  if TRecup = nil then // alors creation d'une tob vide qui existe
  begin
    TobADetruire := TRUE;
    TRecup := TOB.Create('HISTOBULLETIN', nil, -1);
    TRecup.PutValue('PHB_RUBRIQUE', Rub);
    TRecup.PutValue('PHB_NATURERUB', 'AAA');
    if (TypeTraitement <> 'SAISIE') or (GrilleBull = nil) then
    begin
      TRecup.PutValue('PHB_BASEREM', 0);
      TRecup.PutValue('PHB_TAUXREM', 0);
      TRecup.PutValue('PHB_COEFFREM', 0);
      TRecup.PutValue('PHB_MTREM', 0);
      lib := T1.GetValue('PRM_LIBELLE');
    end
    else // cas creation recupere les cellules saisies pour avoir la saisie des elements variables
    begin
      if Ligne <> 0 then
      begin
        TRecup.PutValue('PHB_BASEREM', Valeur(GrilleBull.Cells[2, Ligne]));
        TRecup.PutValue('PHB_TAUXREM', Valeur(GrilleBull.Cells[3, Ligne]));
        TRecup.PutValue('PHB_COEFFREM', Valeur(GrilleBull.Cells[4, Ligne]));
        TRecup.PutValue('PHB_MTREM', Valeur(GrilleBull.Cells[5, Ligne]));
      end
      else
      begin
        TRecup.PutValue('PHB_BASEREM', 0);
        TRecup.PutValue('PHB_TAUXREM', 0);
        TRecup.PutValue('PHB_COEFFREM', 0);
        TRecup.PutValue('PHB_MTREM', 0);
      end;
      lib := T1.GetValue('PRM_LIBELLE');
    end
  end
  else
  begin
    lib := TRecup.GetValue('PHB_LIBELLE');
    if lib = '' then lib := T1.GetValue('PRM_LIBELLE');
  end;
  RendMoisAnnee(DateFin, Mois, Annee);
  Decalage := VH_Paie.PGDecalage; // r�cup�ration des param�tres g�n�raux de la paie
  MD := T1.GetValue('PRM_DU'); // recherche des bornes de validit� de la r�mun�ration
  MF := T1.GetValue('PRM_AU');
  MS := '';
  BaseRaz := FALSE;
  // Cas o� validit� Saisie dans une fourchette
  if (MD <> '') and (MD <> '00') then
  begin
    if Decalage = TRUE then
    begin
      MS := '12'; // 1er mois en decalage concerne le mois de d�cembre
      // PT7 : 03/09/2001 V547 PH correction validit� du au
      if ((StrToInt(Mois) < StrToInt(MD)) or (StrToInt(Mois) > StrToInt(MF))) and (StrToInt(Mois) <> StrToInt(MS)) then BaseRaz := TRUE;
    end;
    if (StrToInt(Mois) < StrToInt(MD)) or (StrToInt(Mois) > StrToInt(MF)) then BaseRaz := TRUE;
    // FIN PT7
  end
  else
  begin
    // Cas o� la validit� est d�finie par des mois de validite
    // PT4 : 29/08/2001 V547 PH correction bornes de validit� remuneration sur 4 mois
    BaseRaz := TRUE;
    M1 := 0;
    M2 := 0;
    M3 := 0;
    M4 := 0;
    if T1.GetValue('PRM_MOIS1') <> '' then M1 := StrToInt(T1.GetValue('PRM_MOIS1'));
    if T1.GetValue('PRM_MOIS2') <> '' then M2 := StrToInt(T1.GetValue('PRM_MOIS2'));
    if T1.GetValue('PRM_MOIS3') <> '' then M3 := StrToInt(T1.GetValue('PRM_MOIS3'));
    if T1.GetValue('PRM_MOIS4') <> '' then M4 := StrToInt(T1.GetValue('PRM_MOIS4'));

    if (StrToInt(Mois) = M1) or
      (StrToInt(Mois) = M2) or
      (StrToInt(Mois) = M3) or
      (StrToInt(Mois) = M4)
      then BaseRaz := FALSE;
    if (M1 = 0) and (M2 = 0) and (M3 = 0) and (M4 = 0) then BaseRaz := FALSE;
    // FIN PT4
  end;

  Cc := T1.GetValue('PRM_CODECALCUL');
  NbreDec := T1.GetValue('PRM_DECBASE');
  TypeChamp := '';
  if BaseRaz = FALSE then // Rubrique A ne pas Calculer car Mois ne correspond pas aux dates de validit�
  begin
    TypeChamp := T1.GetValue('PRM_TYPEBASE');
    ARecupererRem := RecupRem(ActionCalcul, TypeChamp);
    if ARecupererRem = TRUE then Base := TRecup.GetValue('PHB_BASEREM')
    else Champ := T1.GetValue('PRM_BASEREM');
    if (TypeChamp <> '') and (ARecupererRem = FALSE) then Base := EvalueChampRem(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Base := ARRONDI(Base, NbreDec);
  end;
  TypeChamp := '';
  TypeChamp := T1.GetValue('PRM_TYPETAUX');
  ARecupererRem := RecupRem(ActionCalcul, TypeChamp);
  if ARecupererRem = TRUE then Taux := TRecup.GetValue('PHB_TAUXREM')
  else Champ := T1.GetValue('PRM_TAUXREM');
  if (TypeChamp <> '') and (ARecupererRem = FALSE) then Taux := EvalueChampRem(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  NbreDec := T1.GetValue('PRM_DECTAUX');
  Taux := ARRONDI(Taux, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValue('PRM_TYPECOEFF');
  ARecupererRem := RecupRem(ActionCalcul, TypeChamp);
  if ARecupererRem = TRUE then Coeff := TRecup.GetValue('PHB_COEFFREM')
  else Champ := T1.GetValue('PRM_COEFFREM');
  if (TypeChamp <> '') and (ARecupererRem = FALSE) then Coeff := EvalueChampRem(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  NbreDec := T1.GetValue('PRM_DECCOEFF');
  Coeff := ARRONDI(Coeff, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValue('PRM_TYPEMONTANT');
  ARecupererRem := RecupRem(ActionCalcul, TypeChamp);
  if ARecupererRem = TRUE then Montant := TRecup.GetValue('PHB_MTREM')
  else Champ := T1.GetValue('PRM_MONTANT');
  if (TypeChamp <> '') and (ARecupererRem = FALSE) then Montant := EvalueChampRem(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  cas := RechCasCodeCalcul(Cc);
  NbreDec := T1.GetValue('PRM_DECMONTANT');
  if Montant = 0 then Montant := ValoriseMt(cas, Cc, NbreDec, Base, Taux, Coeff);
  if TobADetruire = TRUE then TRecup.Free; // uniquement dans le cas o� la tob a �t� cr�e artificiellement
  // Gestion du minimum et du maximum
  if T1.GetValue('PRM_TYPEMINI') <> '' then
  begin
    Mini := EvalueChampRem(Tob_Rub, T1.GetValue('PRM_TYPEMINI'), T1.GetValue('PRM_VALEURMINI'), Rub, DateDeb, DateFin);
    if Montant < Mini then Montant := Mini; // Seuil Minimum
  end;
  if T1.GetValue('PRM_TYPEMAXI') <> '' then
  begin
    Maxi := EvalueChampRem(Tob_Rub, T1.GetValue('PRM_TYPEMAXI'), T1.GetValue('PRM_VALEURMAXI'), Rub, DateDeb, DateFin);
    if Montant > Maxi then Montant := Maxi; // Seuil Maximum
  end;
  // PT8 : 03/09/2001 V547 PH on force dans tous les cas le calcul de l'arrondi sur le montant calcul�
  Montant := ARRONDI(Montant, NbreDec);
  // PT4 : 29/08/2001 V547 PH correction bornes de validit� remuneration sur 4 mois
  if BaseRaz = TRUE then Montant := 0; // Rubrique A ne pas Calculer car Mois ne correspond pas aux dates de validit�
  // FIN PT4
end;
//Fonction d'�valuation d'un champ d'une r�mun�ration en fonction du type du champ

function EvalueChampRem(Tob_Rub: TOB; const TypeChamp, Champ, Rub: string; const DateDeb, DateFin: TDateTime): Double;
var
  ii: Integer;
  Trech, Trub: TOB;
  St: string;
begin
  result := 0;
  ii := StrToInt(TypeChamp);
  if (ii < 0) or (ii > 10) then exit;
  Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['AAA', Champ], TRUE);
  if ((ii > 3) and (ii < 8)) and (Trech = nil) then
  begin
    St := 'Salari� : ' + CodSal;
    St := St + ' La Rubrique ' + Rub + ' recherche : ' + RechDom('PGTYPECHAMPREM', TypeChamp, FALSE) + ' de la r�mun�ration ' + Champ + ' qui n''existe pas dans le bulletin';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  Trub := Paie_RechercheOptimise(Tob_Rem, 'PRM_RUBRIQUE', rub); // $$$$
{$IFDEF aucasou}
  Trub := Tob_Rem.FindFirst(['PRM_RUBRIQUE'], [rub], FALSE); // $$$$
{$ENDIF}
  case ii of
    0..1: result := 0;
    2: result := ValEltNat(Champ, DateFin);
    3: result := ValVariable(Champ, DateDeb, DateFin, TOB_Rub);
    4: result := Trech.GetValue('PHB_BASEREM');
    5: result := Trech.GetValue('PHB_TAUXREM');
    6: result := Trech.GetValue('PHB_COEFFREM');
    7: result := Trech.GetValue('PHB_MTREM');
    8:
      begin
        if Trub <> nil then result := Valeur(champ);
      end;
  end;

end;

{ Fonction pour savoir si on recupere le montant d�j� calcul� ou saisi de la rubrique
cela correspond � un elt permanent ou un elt variable
Dans le cas d'un champ de type valeur ou prend tjrs la valeur saisie dans  la rubrique
}

function RecupRem(const ActionCalcul: TActionBulletin; const TypeChamp: string): Boolean;
var
  ii: Integer;
begin
  result := FALSE;
  if TypeChamp = '' then exit;
  ii := StrToInt(TypeChamp);
  if (ii = 0) or (ii = 1) then result := TRUE;
end;
// Fonction d'�valuation d'une variable

function ValVariable(const VariablePaie: string; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB): double;
var
  T_Rech, T_Var: TOB;
  St, St3, St2, TypeVar: string;
  val1, val2, val3: Double;
  OkDef: Boolean;
  jj: Integer;
  ThenAlert, ElseAlert: Boolean; // Indicateur si une variable de test renvoie une alerte
  RVar: Variant;
begin
  result := 0;
  if VariablePaie = '' then
  begin
    St := 'Salari� : ' + CodSal + ' On ne peut pas calculer une variable qui n''a pas de code';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  ThenAlert := FALSE;
  ElseAlert := FALSE;
  t_rech := Paie_RechercheOptimise(Tob_Variables, 'PVA_VARIABLE', VariablePaie);
{$IFDEF aucasou}
  T_Rech := TOB_Variables.FindFirst(['PVA_VARIABLE'], [VariablePaie], FALSE); // $$$$
{$ENDIF}
  if (T_Rech = nil) then // PT114 Avant, on ne generait pas d'erreur si variable predefinie CEGID  ==> and (StrToInt(VariablePaie) > 200)
  begin
    St := 'Salari� : ' + CodSal + ' La Variable ' + VariablePaie + ' n''existe pas, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  OkDef := RechVarDefinie(VariablePaie, DateDeb, DateFin, RVar, TOB_Rub);
  if OkDef = TRUE then
  begin
    result := RVar;
    exit;
  end; // Fin Variable CEGID Sortie Fonction
  TypeVar := T_Rech.GetValue('PVA_NATUREVAR');
  if TypeVar = 'VAL' then result := EvalueVarVal(T_Rech, DateDeb, DateFin, TOB_Rub);
  if TypeVar = 'ALE' then
  begin
    if TypeTraitement <> 'PREPA' then PGIBox(T_Rech.GetValue('PVA_MESSAGE1'), T_Rech.GetValue('PVA_MESSAGE2'))
    else
    begin
      TraceErr.Items.Add(T_Rech.GetValue('PVA_MESSAGE1'));
      TraceErr.Items.Add(T_Rech.GetValue('PVA_MESSAGE2'));
    end;
  end;
  if TypeVar = 'CUM' then
    result := EvalueVarCum(T_Rech, DateDeb, DateFin, TOB_Rub);
  if (TypeVar = 'COT') or (TypeVar = 'REM') then result := EvalueVarRub(TypeVar, T_Rech, DateDeb, DateFin, TOB_Rub, '', '');
  if (TypeVar = 'CAL') then
  begin
    st := EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPEBASE', 'PVA_BASE', 'PVA_OPERATMATH', 9);
    EvalueChaineDiv0(St);
    jj := ObjTM3VM.AddExpr('ExpPaie', St);
    result := ObjTM3VM.GetExprValue(jj);
    ObjTM3VM.DeleteExpr(jj);
  end;
  // PT98   : 19/03/2004 PH V_50 FQ 11200 Prise en compte de nbre de d�cimales dans le calcul des variables
  if (TypeVar = 'COT') or (TypeVar = 'REM') or (TypeVar = 'CUM') or (TypeVar = 'CAL') then
  begin
    if (T_Rech.GetValue('PVA_MTARRONDI') >= 0) and (T_Rech.GetValue('PVA_MTARRONDI') < 7) then
      result := ARRONDI(result, T_Rech.GetValue('PVA_MTARRONDI'));
  end;
  // FIN PT98
  if (TypeVar = 'TES') then
  begin
    // ObjTM3VM:=TM3VM.Create ; // creation objet VM Script
    st := EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPEBASE', 'PVA_BASE', 'PVA_OPERATMATH', 6);
    EvalueChaineDiv0(St);
    jj := ObjTM3VM.AddExpr('ExpPaie', St);
    val1 := ObjTM3VM.GetExprValue(jj);
    ObjTM3VM.DeleteExpr(jj);
    if (T_Rech.GetValue('PVA_TYPERESTHEN0') = '03') and (T_Rech.GetValue('PVA_RESTHEN0') > 200) then
    begin // cas d'une variable il ne faut pas chercher � executer le calcul de la variable si c'est une variable d'alerte
      t_var := Paie_RechercheOptimise(Tob_Variables, 'PVA_VARIABLE', T_Rech.GetValue('PVA_RESTHEN0'));
{$IFDEF aucasou}
      T_Var := TOB_Variables.FindFirst(['PVA_VARIABLE'], [T_Rech.GetValue('PVA_RESTHEN0')], FALSE); // $$$$
{$ENDIF}
      if (T_Var <> nil) then
        if T_Var.GetValue('PVA_NATUREVAR') = 'ALE' then ThenAlert := TRUE;
    end;
    val2 := 0;
    if not ThenAlert then
    begin
      if (T_Rech.GetValue('PVA_OPERATRESTHEN0') <> '') and (T_Rech.GetValue('PVA_OPERATRESTHEN0') <> '') then
        st2 := EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPERESTHEN', 'PVA_RESTHEN', 'PVA_OPERATRESTHEN', 3);
      // @@@@@ 2 <-- 3  else st2:=STRFPOINT (EvalueUnChampVar (T_Rech.GetValue ('PVA_TYPERESTHEN0'),T_Rech.GetValue ('PVA_RESTHEN0'), TOB_Rub, T_Rech, 0, DateFin));
      EvalueChaineDiv0(St2);
      jj := ObjTM3VM.AddExpr('ExpPaie', St2);
      val2 := ObjTM3VM.GetExprValue(jj);
      ObjTM3VM.DeleteExpr(jj);
    end;
    if (T_Rech.GetValue('PVA_TYPERESELSE0') = '03') and (T_Rech.GetValue('PVA_RESELSE0') > 200) then
    begin // cas d'une variable, il ne faut pas chercher � executer le calcul de la variable si c'est une variable d'alerte
      t_var := Paie_RechercheOptimise(Tob_Variables, 'PVA_VARIABLE', T_Rech.GetValue('PVA_RESELSE0'));
{$IFDEF aucasou}
      T_Var := TOB_Variables.FindFirst(['PVA_VARIABLE'], [T_Rech.GetValue('PVA_RESELSE0')], FALSE); // $$$$
{$ENDIF}
      if (T_Var <> nil) then
        if T_Var.GetValue('PVA_NATUREVAR') = 'ALE' then ElseAlert := TRUE;
    end;
    Val3 := 0;
    if not ElseAlert then
    begin
      if (T_Rech.GetValue('PVA_OPERATRESELSE0') <> '') and (T_Rech.GetValue('PVA_OPERATRESELSE0') <> '') then
        st3 := EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPERESELSE', 'PVA_RESELSE', 'PVA_OPERATRESELSE', 3) else
        st := STRFPOINT(EvalueUnChampVar(T_Rech.GetValue('PVA_TYPERESELSE0'), T_Rech.GetValue('PVA_RESELSE0'), TOB_Rub, T_Rech, 0, DateFin));
      EvalueChaineDiv0(St3);
      jj := ObjTM3VM.AddExpr('ExpPaie', St3);
      val3 := ObjTM3VM.GetExprValue(jj);
      ObjTM3VM.DeleteExpr(jj);
    end;
    if Val1 = 1 then
    begin // dans tous les cas si on a une variable d'alerte on excute la variable d'alerte
      result := val2;
      if ThenAlert then EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPERESTHEN', 'PVA_RESTHEN', 'PVA_OPERATRESTHEN', 3);
    end
    else
    begin
      result := val3;
      if ElseAlert then EvalueExpVar(TOB_Rub, T_Rech, DateDeb, DateFin, 'PVA_TYPERESELSE', 'PVA_RESELSE', 'PVA_OPERATRESELSE', 3);
    end;
    if VariablePaie = '0304' then
    begin
      st := VariablePaie;
    end;
    // ObjTM3VM.free;
  end;

end;
// Recherche du cas code calcul

function RechCasCodeCalcul(const Cc: string): WORD;
var
  i: Integer;
begin
  i := StrToInt(Cc);
  case i of
    1: result := 1;
    4..5: result := 2;
    8: result := 4;
    2..3: result := 3;
    6..7: result := 3;
  else
    result := 0;
  end;
end;

// Fonction qui indique si on c'est une ligne de commentaire associ�e � la rubrique

function RechCommentaire(const Rub: string): Boolean;
begin
  result := (Copy(Rub, 1, 1) = '.') or (Copy(Rub, 5, 1) = '.');
end;

// Fonction qui rend le code de la rubrique  en supprimant .x pour les lignes de commentaire

function RendCodeRub(const Rub: string): string;
begin
  if not RechCommentaire(Rub) then result := Rub else Result := Copy(Rub, 1, 4);
end;

// Fonction alimentation enreg de PAIEENCOURS avec les champs salari� et la saisie

procedure AlimChampEntet(const Salarie, Etab: string; const DateDebut, DateFin: TDateTime; Tob_Rub: TOB);
begin
  if (TOB_Salarie = nil) then RecupTobSalarie(Salarie)
  else
  begin
    if TOB_Salarie.GetValeur(iPSA_SALARIE) <> Salarie then RecupTobSalarie(Salarie); // Reprend le contenu de la table Salari� au moment o� l'on �crit Entete Bulletin
  end;

  with TOB_Rub do
  begin
    PutValue('PPU_SALARIE', Salarie);
    Codsal := Salarie;
    PutValue('PPU_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT));
    PutValue('PPU_DATEDEBUT', DateDebut);
    PutValue('PPU_DATEFIN', DateFin);
    PutValue('PPU_TRAVAILN1', TOB_Salarie.GetValeur(iPSA_TRAVAILN1));
    PutValue('PPU_TRAVAILN2', TOB_Salarie.GetValeur(iPSA_TRAVAILN2));
    PutValue('PPU_TRAVAILN3', TOB_Salarie.GetValeur(iPSA_TRAVAILN3));
    PutValue('PPU_TRAVAILN4', TOB_Salarie.GetValeur(iPSA_TRAVAILN4));
    PutValue('PPU_CODESTAT', TOB_Salarie.GetValeur(iPSA_CODESTAT));
    PutValue('PPU_CONFIDENTIEL', TOB_Salarie.GetValeur(iPSA_CONFIDENTIEL));
    PutValue('PPU_LIBELLE', TOB_Salarie.GetValeur(iPSA_LIBELLE));
    PutValue('PPU_PRENOM', TOB_Salarie.GetValeur(iPSA_PRENOM));
    PutValue('PPU_NUMEROSS', TOB_Salarie.GetValeur(iPSA_NUMEROSS));
    PutValue('PPU_ADRESSE1', TOB_Salarie.GetValeur(iPSA_ADRESSE1));
    PutValue('PPU_ADRESSE2', TOB_Salarie.GetValeur(iPSA_ADRESSE2));
    PutValue('PPU_ADRESSE3', TOB_Salarie.GetValeur(iPSA_ADRESSE3));
    PutValue('PPU_CODEPOSTAL', TOB_Salarie.GetValeur(iPSA_CODEPOSTAL));
    PutValue('PPU_VILLE', TOB_Salarie.GetValeur(iPSA_VILLE));
    PutValue('PPU_INDICE', TOB_Salarie.GetValeur(iPSA_INDICE));
    PutValue('PPU_NIVEAU', TOB_Salarie.GetValeur(iPSA_NIVEAU));
    PutValue('PPU_CONVENTION', TOB_Salarie.GetValeur(iPSA_CONVENTION));
    PutValue('PPU_CODEEMPLOI', TOB_Salarie.GetValeur(iPSA_CODEEMPLOI));
    PutValue('PPU_AUXILIAIRE', TOB_Salarie.GetValeur(iPSA_AUXILIAIRE));
    PutValue('PPU_LIBREPCMB1', TOB_Salarie.GetValeur(iPSA_LIBREPCMB1));
    PutValue('PPU_LIBREPCMB2', TOB_Salarie.GetValeur(iPSA_LIBREPCMB2));
    PutValue('PPU_LIBREPCMB3', TOB_Salarie.GetValeur(iPSA_LIBREPCMB3));
    PutValue('PPU_LIBREPCMB4', TOB_Salarie.GetValeur(iPSA_LIBREPCMB4));
    PutValue('PPU_DATEANCIENNETE', TOB_Salarie.GetValeur(iPSA_DATEANCIENNETE));
    // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
    PutValue('PPU_BULCOMPL', BullCompl);
    PutValue('PPU_PROFILPART', ProfilSpec);

    with ChpEntete do
    begin
      PutValue('PPU_PGMODEREGLE', Reglt); {PT3}
      PutValue('PPU_PAYELE', DatePai);
      PutValue('PPU_VALIDELE', DateVal);
      PutValue('PPU_QUALIFICATION', TOB_Salarie.GetValeur(iPSA_QUALIFICATION));
      PutValue('PPU_COEFFICIENT', TOB_Salarie.GetValeur(iPSA_COEFFICIENT));
      PutValue('PPU_LIBELLEEMPLOI', TOB_Salarie.GetValeur(iPSA_LIBELLEEMPLOI));
      PutValue('PPU_DATEENTREE', TOB_Salarie.GetValeur(iPSA_DATEENTREE));
      PutValue('PPU_DATESORTIE', TOB_Salarie.GetValeur(iPSA_DATESORTIE));
      // PT34 : 22/03/2002 PH V571 Traitement de la civilit� dans la table Paieencours
      PutValue('PPU_CIVILITE', TOB_Salarie.GetValeur(iPSA_CIVILITE));
      // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
      PutValue('PPU_EDTDEBUT', Edtdu);
      PutValue('PPU_EDTFIN', Edtau);
      PutValue('PPU_BULCOMPL', BullCompl);

      if HorMod then PutValue('PPU_HORAIREMOD', 'X')
      else PutValue('PPU_HORAIREMOD', '-');


      PutValue('PPU_BASESMOD', PaieExpression(BasesMod, 'X', '-'));

      (*
                     if BasesMod then PutValue('PPU_BASESMOD', 'X')
                     else PutValue('PPU_BASESMOD', '-');
      *)

      if TranchesMod then PutValue('PPU_TRANCHESMOD', 'X')
      else PutValue('PPU_TRANCHESMOD', '-');

      if TrentMod then PutValue('PPU_TRENTIEMEMOD', 'X')
      else PutValue('PPU_TRENTIEMEMOD', '-');

      // PT34 : 22/03/2002 PH V571  Civilt� et mode reglement modifi�
      if RegltMod then PutValue('PPU_REGLTMOD', 'X')
      else PutValue('PPU_REGLTMOD', '-');
      { DEB PT97 }
      if CpAcquisMod then PutValue('PPU_CPACQUISMOD', 'X')
      else PutValue('PPU_CPACQUISMOD', '-');
      { FIN PT97 }
      PutValue('PPU_DENOMINTRENT', DTrent);
      PutValue('PPU_NUMERATTRENT', NTrent);
      PutValue('PPU_JOURSOUVRES', Ouvres);
      PutValue('PPU_JOURSOUVRABLE', Ouvrables);
      PutValue('PPU_HEURESREELLES', HeuresTrav);
    end;
  end;
end;
// Fonction qui calcule automatiquement le num�ro de la ligne de commentaire

function RendRubrCommentaire(const rub: string; const CurG: THGrid): Integer;
var
  Num, i: Integer;
  St1: string;
begin
  Num := 1;
  // PT27 : 26/12/2001 V571 PH D�doublement des lignes multiples de commentaire
  for i := 1 to CurG.RowCount - 1 do
  begin
    St1 := CurG.Cells[0, i];
    if Copy(rub, 1, 4) = Copy(St1, 1, 4) then
    begin
      if (Copy(st1, 5, 1) = '.') then
      begin
        if StrToInt(Copy(st1, 6, 1)) >= Num then
        begin
          Num := StrToInt(Copy(st1, 6, 1));
          Num := Num + 1;
        end;
        if Num > 9 then Num := 0;
      end;
    end;
  end;
  result := Num;
end;

{ Ensemble de fonctions pour le calcul des rubriques de cotisation
 Calcul de la cotisation}

function EvalueCot(Tob_Rub: TOB; const Rub: string; var Base, TxSal, TxPat, MtSal, MtPat: Double; var lib: string; DateDeb, DateFin: TDateTime; ActionCalcul: TActionBulletin; var
  At: Boolean): Boolean; // Calcul de la r�mun�ration
var
  T1, TRecup: TOB;
  St, TypeChamp, Champ: string;
  NbreDec, Mois1, Mois2, Mois3, Mois4: Integer;
  BaseRaz, ARecupererCot, Decalage: Boolean;
  Mini, Maxi: Double;
  MD, MF, MS, Mois, Annee: string;
  UneDate: TDateTime;
begin
  Base := 0;
  TxSal := 0;
  TxPat := 0;
  MtPat := 0;
  MtSal := 0;
  lib := '';
  T1 := Paie_RechercheOptimise(TOB_Cotisations, 'PCT_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
  T1 := TOB_Cotisations.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [Rub, 'COT'], FALSE); // $$$$
{$ENDIF}
  if T1 = nil then
  begin
    St := 'Salari� : ' + CodSal + ' La Cotisation ' + Rub + ' n''existe pas, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  if Assigned(T1) and (iPCT_ORDREAT = 0) then MemorisePct(T1);
  if T1.GetValeur(iPCT_ORDREAT) = 'X' then At := TRUE else At := FALSE;
  TRecup := TOB_Rub.FindFirst(['PHB_RUBRIQUE', 'PHB_NATURERUB'], [Rub, 'COT'], TRUE);
  if (TRecup = nil) and (ActionCalcul <> taCreation) then
  begin
    St := 'Salari� : ' + CodSal + ' La Cotisation ' + Rub + ' n''est pas dans le bulletin, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  if Assigned(TRecup) and (iPHB_LIBELLE = 0) then MemorisePhb(TRecup);
  if TRecup = nil then lib := T1.GetValeur(iPCT_LIBELLE)
  else
  begin
    lib := TRecup.GetValeur(iPHB_LIBELLE);
    if lib = '' then lib := T1.GetValeur(iPCT_LIBELLE);
  end;
  // PT77  : 04/06/03 PH V_421 FQ 10689 Salari� sort dans la p�riode mais la cotisation ne se calcule que si le salari� est present le dernier jour du mois
  if T1.GetValeur(iPCT_PRESFINMOIS) = 'X' then
  begin
    if (TOB_Salarie.GetValeur(iPSA_DATESORTIE) <> NULL) then
      UneDate := TOB_Salarie.GetValeur(iPSA_DATESORTIE)
    else UneDate := iDate1900; // PT94   : 18/12/2003 PH V_50 FQ 11028
    if (UneDate < FINDEMOIS(DateFin)) and (UneDate > IDate1900) then exit;
    // FIN PT94
  end;
  // FIN PT77
  Decalage := VH_Paie.PGDecalage; // r�cup�ration des param�tres g�n�raux de la paie
  MD := T1.GetValeur(iPCT_DU); // recherche des bornes de validit� de la cotisation
  MF := T1.GetValeur(iPCT_AU);
  MS := '';
  RendMoisAnnee(DateFin, Mois, Annee);
  BaseRaz := FALSE;
  // Cas o� validit� Saisie dans une fourchette
  if (MD <> '') and (MD <> '00') then
  begin
    if MF = '' then MF := MD; // PT93 initialisation valeur par defaut FQ 11003
    if Decalage = TRUE then
    begin
      MS := '12'; // 1er mois en decalage concerne le mois de d�cembre
      if ((StrToInt(Mois) < StrToInt(MD)) or (StrToInt(Mois) > StrToInt(MF))) and (StrToInt(Mois) <> StrToInt(MS)) then BaseRaz := TRUE;
    end;
    if (StrToInt(Mois) < StrToInt(MD)) or (StrToInt(Mois) > StrToInt(MF)) then BaseRaz := TRUE;
  end
  else
  begin
    // Cas o� la validit� est d�finie par des mois de validite
    //PT5 : 29/08/2001 V547 PH correction bornes de validit� cotisaation sur 4 mois
    Mois1 := 0;
    Mois2 := 0;
    Mois3 := 0;
    Mois4 := 0;

    if T1.GetValeur(iPCT_MOIS1) <> '' then Mois1 := StrToInt(T1.GetValeur(iPCT_MOIS1));
    if T1.GetValeur(iPCT_MOIS2) <> '' then Mois2 := StrToInt(T1.GetValeur(iPCT_MOIS2));
    if T1.GetValeur(iPCT_MOIS3) <> '' then Mois3 := StrToInt(T1.GetValeur(iPCT_MOIS3));
    if T1.GetValeur(iPCT_MOIS4) <> '' then Mois4 := StrToInt(T1.GetValeur(iPCT_MOIS4));
    BaseRaz := TRUE;
    if (StrToInt(Mois) = Mois1) or
      (StrToInt(Mois) = Mois2) or
      (StrToInt(Mois) = Mois3) or
      (StrToInt(Mois) = Mois4)
      then BaseRaz := FALSE;
    if (Mois1 = 0) and (Mois2 = 0) and (Mois3 = 0) and (Mois4 = 0) then BaseRaz := FALSE;

    // FIN PT5
  end;
  // @@@@@ if (ActionCalcul = PremCreation) then lib:=T1.GetValue ('PCT_LIBELLE');
  NbreDec := T1.GetValeur(iPCT_DECBASE);
  TypeChamp := '';
  ARecupererCot := FALSE;
  if BaseRaz = FALSE then // Rubrique A ne pas Calculer car Mois ne correspond pas aux dates de validit�
  begin
    TypeChamp := T1.GetValeur(iPCT_TYPEBASE);
    ARecupererCot := RecupCot(ActionCalcul, TypeChamp);
    if ARecupererCot = TRUE then Base := TRecup.GetValeur(iPHB_BASECOT)
    else Champ := T1.GetValeur(iPCT_BASECOTISATION);
    if (TypeChamp <> '') and (ARecupererCot = FALSE) then Base := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Base := ARRONDI(Base, NbreDec);
  end;
  TypeChamp := '';
  // PT40 : 04/04/2002 PH V571 Test si colonne cotisation saisissable
  TypeChamp := T1.GetValeur(iPCT_TYPETAUXSAL);
  ARecupererCot := RecupCot(ActionCalcul, TypeChamp);
  if ARecupererCot = TRUE then TxSal := TRecup.GetValeur(iPHB_TAUXSALARIAL)
  else Champ := T1.GetValeur(iPCT_TAUXSAL);
  if (TypeChamp <> '') and (ARecupererCot = FALSE) then TxSal := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  NbreDec := T1.GetValeur(iPCT_DECTXSAL);
  TxSal := ARRONDI(TxSal, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPETAUXPAT);
  // PT40 : 04/04/2002 PH V571 Test si colonne cotisation saisissable
  ARecupererCot := RecupCot(ActionCalcul, TypeChamp);
  if ARecupererCot = TRUE then TxPat := TRecup.GetValeur(iPHB_TAUXPATRONAL)
  else Champ := T1.GetValeur(iPCT_TAUXPAT);
  if (TypeChamp <> '') and (ARecupererCot = FALSE) then TxPat := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  NbreDec := T1.GetValeur(iPCT_DECTXPAT);
  TxPat := ARRONDI(TxPat, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEFFSAL);
  // PT40 : 04/04/2002 PH V571 Test si colonne cotisation saisissable
  ARecupererCot := RecupCot(ActionCalcul, TypeChamp);
  if ARecupererCot = TRUE then MtSal := TRecup.GetValeur(iPHB_MTSALARIAL)
  else Champ := T1.GetValeur(iPCT_FFSAL);
  if (TypeChamp <> '') and (ARecupererCot = FALSE) then MtSal := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin)
  else if TypeChamp <> 'ELV' then MtSal := Base * (TxSal / 100);
  NbreDec := T1.GetValeur(iPCT_DECMTSAL);
  MtSal := ARRONDI(MtSal, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEFFPAT);
  // PT40 : 04/04/2002 PH V571 Test si colonne cotisation saisissable
  ARecupererCot := RecupCot(ActionCalcul, TypeChamp);
  if ARecupererCot = TRUE then MtPat := TRecup.GetValeur(iPHB_MTPATRONAL)
  else Champ := T1.GetValeur(iPCT_FFPAT);
  if (TypeChamp <> '') and (ARecupererCot = FALSE) then MtPat := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin)
  else if TypeChamp <> 'ELV' then MtPat := Base * (TxPat / 100);
  NbreDec := T1.GetValeur(iPCT_DECMTPAT);
  MtPat := ARRONDI(MtPat, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEMINISAL); // Recup du mimimum sur Mt salarial
  if (TypeChamp <> '') then
  begin
    Champ := T1.GetValeur(iPCT_VALEURMINISAL);
    Mini := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Mini := ARRONDI(Mini, T1.GetValeur(iPCT_DECMTSAL));
    if MtSal < Mini then MtSal := Mini;
  end;
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEMAXISAL); // Recup du maximum sur Mt salarial
  if (TypeChamp <> '') then
  begin
    Champ := T1.GetValeur(iPCT_VALEURMAXISAL);
    Maxi := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Maxi := ARRONDI(Maxi, T1.GetValeur(iPCT_DECMTSAL));
    if MtSal > Maxi then MtSal := Maxi;
  end;
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEMINIPAT); // Recup du mimimum sur Mt patronal
  if (TypeChamp <> '') then
  begin
    Champ := T1.GetValeur(iPCT_VALEURMINIPAT);
    Mini := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Mini := ARRONDI(Mini, T1.GetValeur(iPCT_DECMTPAT));
    if MtPat < Mini then MtPat := Mini;
  end;
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEMAXIPAT); // Recup du maximum sur Mt patronal
  if (TypeChamp <> '') then
  begin
    Champ := T1.GetValeur(iPCT_VALEURMAXIPAT);
    Maxi := EvalueChampCot(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
    Maxi := ARRONDI(Maxi, T1.GetValeur(iPCT_DECMTPAT));
    if MtPat > Maxi then MtPat := Maxi;
  end;
  if BaseRaz = TRUE then // Rubrique A ne pas Calculer car Mois ne correspond pas aux dates de validit�
  begin
    MtPat := 0;
    MtSal := 0;
  end;
end;
{ Fonction d'�valuation d'un champ d'une r�mun�ration en fonction du type du champ
Rajout du type de champ VAL pour indiquer une valeur � prendre
}

function EvalueChampCot(Tob_Rub: TOB; const TypeChamp, Champ, Rub: string; const DateDeb, DateFin: TDateTime): Double;
var
  T_Rech, T_Rub, T1: TOB;
  St: string;
begin
  result := 0;
  if Champ = '' then exit; // tous les champs ne sont pas obligatoires
  if TypeChamp = 'BDC' then T_Rech := Tob_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['BAS', Champ], TRUE)
  else T_Rech := Tob_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['AAA', Champ], TRUE);
  if (T_Rech = nil) and ((TypeChamp = 'REM') or (TypeChamp = 'BDC')) then
  begin
    St := 'Salari� : ' + CodSal + ' La Rubrique de cotisation ' + Rub + ' est mal param�tr�e ';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  if TypeChamp = 'ELN' then result := ValEltNat(Champ, DateFin)
  else
    if TypeChamp = 'VAR' then result := ValVariable(Champ, DateDeb, DateFin, Tob_Rub)
  else
    if TypeChamp = 'VAL' then
  begin
    t_rub := Paie_RechercheOptimise(TOB_Cotisations, 'PCT_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
    T_rub := TOB_Cotisations.FindFirst(['PCT_RUBRIQUE'], [Rub], FALSE); // $$$$
{$ENDIF}
    if T_Rub <> nil then result := Valeur(Champ);
  end
  else
  begin
    if Assigned(T_Rech) and (iPHB_TRANCHE1 = 0) then MemorisePhb(T_Rech);
    if TypeChamp = 'REM' then result := T_Rech.GetValeur(iPHB_MTREM) // Montant de R�mun�ration
    else
      if TypeChamp = 'BDC' then
    begin
      T1 := Paie_RechercheOptimise(TOB_Cotisations, 'PCT_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
      T1 := TOB_Cotisations.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [Rub, 'COT'], FALSE); // $$$$
{$ENDIF}
      if T1 <> nil then
      begin
        if Assigned(T1) and (iPCT_CODETRANCHE = 0) then MemorisePct(T1);
        st := T1.GetValeur(iPCT_CODETRANCHE);
        if st = 'TOT' then result := T_Rech.GetValeur(iPHB_BASECOT) // Base rubrique de Base de  Cotisation
        else if st = 'TR1' then result := T_Rech.GetValeur(iPHB_TRANCHE1) // TR1 de Base de  Cotisation
        else if st = 'TR2' then result := T_Rech.GetValeur(iPHB_TRANCHE2) // TR2 de Base de  Cotisation
        else if st = 'TR3' then result := T_Rech.GetValeur(iPHB_TRANCHE3) // TR3 de Base de  Cotisation
        else if st = 'U12' then result := T_Rech.GetValeur(iPHB_TRANCHE1) + T_Rech.GetValeur(iPHB_TRANCHE2) // TR1+T2
        else if st = 'U13' then result := T_Rech.GetValeur(iPHB_TRANCHE1) + T_Rech.GetValeur(iPHB_TRANCHE2) + T_Rech.GetValeur(iPHB_TRANCHE3); // TR1+T2+T3
      end;
    end;
  end;
end;

{ Fonction pour savoir si on recupere le montant d�j� calcul� ou saisi de la rubrique de cotisation
cela correspond � un elt permanent
Le 14/03/2000 suppression notion �l�ment permanent remplac�e par valeur
}

function RecupCot(const ActionCalcul: TActionBulletin; const TypeChamp: string): Boolean;
begin
  result := FALSE;
  // PT40 : 04/04/2002 PH V571 Test si colonne cotisation saisissable
  if (ActionCalcul <> taCreation) and ((TypeChamp = 'ELP') or (TypeChamp = 'ELV'))
    then result := TRUE; // ligne sans effet suite � modif
end;
{ Fonction de calcul du bulletin dans son int�gralit�
Parcours de la TOB contenant la liste des rubriques contenues dans le bulletin
et en fonction de la nature, les lignes sont valori�es
Il convient apr�s suivant le cas d'�crire dans la base, de remplir les grilles de
saisie.
Cette fonction est utilisable pour la pr�paration automatique car elle prend en compte
les valeurs des informations (exemple : Elt nationaux)) mais aussi le param�trage des
rubriques au moment o� on fait le calcul==> Donc cette fonction peut �tre appell�e
pour le recalcul d'une paie pour tenir compte des mofications apport�es au plan de paie.
}

{ Ensemble de fonctions pour le calcul des rubriques de Bases de cotisation
 Calcul de la base, Plafond, T1,T2,T3 avec regul si rubrique soumise � r�gularisation}

function EvalueBas(Tob_Rub: TOB; const Rub: string; var Base, Plafond, Plf1, Plf2, Plf3, TR1, TR2, TR3: Double; var lib: string; const DateDeb, DateFin: TDateTime; ActionCalcul:
  TActionBulletin; const BaseForcee, TrancheForcee: Boolean): Boolean; // Calcul de la r�mun�ration
var
  T1, TRecup: TOB;
  St, TypeChamp, Champ, TPlf1, TPlf2, TPlf3: string;
  NbreDec: Integer;
  ARegulariser, ACalculer: Boolean;
begin
  Base := 0;
  Plf1 := 0;
  Plf2 := 0;
  Plf3 := 0;
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  lib := '';
  T1 := Paie_RechercheOptimise(TOB_Bases, 'PCT_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
  T1 := TOB_Bases.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [Rub, 'BAS'], FALSE); // $$$$
{$ENDIF}
  if T1 = nil then
  begin
    St := 'Salari� : ' + CodSal + ' La Base de Cotisation ' + Rub + ' n''existe pas, On ne peut pas la calculer';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  TRecup := TOB_Rub.FindFirst(['PHB_RUBRIQUE', 'PHB_NATURERUB'], [Rub, 'BAS'], TRUE);
  if Assigned(T1) and (iPCT_LIBELLE = 0) then MemorisePct(T1);

  if (TRecup = nil) and (ActionCalcul <> taCreation) then
  begin
    St := 'La Base de Cotisation ' + Rub + ' n''est pas dans le bulletin, On ne peut pas la calculer';
    //  ShowMessage (St); On n'a pas de message car une base peut �tre la somme de 3 bases pouvant etre valoris�es ou pas
    exit;
  end;
  if TRecup = nil then lib := T1.GetValeur(iPCT_LIBELLE)
  else
  begin
    lib := TRecup.GetValeur(iPHB_LIBELLE);
    if lib = '' then lib := T1.GetValeur(iPCT_LIBELLE);
  end;
  // @@@@ if (ActionCalcul = PremCreation) then lib:=T1.GetValue ('PCT_LIBELLE');
  NbreDec := T1.GetValeur(iPCT_DECBASECOT);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEBASE);
  if T1.GetValeur(iPCT_SOUMISREGUL) = 'X' then ARegulariser := TRUE
  else ARegulariser := FALSE;
  if TrancheForcee = TRUE then ARegulariser := FALSE;
  if BaseForcee = TRUE then ACalculer := FALSE else ACalculer := TRUE;
  if ACalculer = FALSE then Base := TRecup.GetValeur(iPHB_BASECOT)
  else Champ := T1.GetValeur(iPCT_BASECOTISATION);
  if (TypeChamp <> '') and (ACalculer = TRUE) then Base := EvalueChampBas(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  Base := ARRONDI(Base, NbreDec);
  TypeChamp := '';
  TypeChamp := T1.GetValeur(iPCT_TYPEPLAFOND);
  if ACalculer = FALSE then
  begin
    Plafond := TRecup.GetValeur(iPHB_PLAFOND);
    Plf1 := TRecup.GetValeur(iPHB_PLAFOND1);
    Plf2 := TRecup.GetValeur(iPHB_PLAFOND2);
    Plf3 := TRecup.GetValeur(iPHB_PLAFOND3);
  end
  else Champ := T1.GetValeur(iPCT_PLAFOND);
  // Recup du plafond theorique
  if (TypeChamp <> '') and (ACalculer = TRUE) then Plafond := EvalueChampBas(Tob_Rub, TypeChamp, Champ, Rub, DateDeb, DateFin);
  Plafond := ARRONDI(Plafond, NbreDec);
  TPlf1 := T1.GetValeur(iPCT_TYPETRANCHE1);
  TPlf2 := T1.GetValeur(iPCT_TYPETRANCHE2);
  TPlf3 := T1.GetValeur(iPCT_TYPETRANCHE3);
  // il convient de calculer le plafond reel sur lequel on va calculer les tranches
  if TrancheForcee = TRUE then // si on saisit les tranches alors le calcul des plafonds est d�activ� car on peut aussi les saisir
  begin
    TR1 := TRecup.GetValeur(iPHB_TRANCHE1);
    TR2 := TRecup.GetValeur(iPHB_TRANCHE2);
    TR3 := TRecup.GetValeur(iPHB_TRANCHE3);
    Plf1 := TRecup.GetValeur(iPHB_PLAFOND1);
    Plf2 := TRecup.GetValeur(iPHB_PLAFOND2);
    Plf3 := TRecup.GetValeur(iPHB_PLAFOND3);
  end
  else // Calcul des regularisations sur les 3 tranches
  begin
    Plf1 := EvaluePlafond(TOB_Rub, T1.GetValeur(iPCT_TYPETRANCHE1), T1.GetValeur(iPCT_TRANCHE1), Rub, Plafond, DateDeb, DateFin, NbreDec, T1.GetValeur(iPCT_TYPEREGUL));
    Plf2 := EvaluePlafond(TOB_Rub, T1.GetValeur(iPCT_TYPETRANCHE2), T1.GetValeur(iPCT_TRANCHE2), Rub, Plafond, DateDeb, DateFin, NbreDec, T1.GetValeur(iPCT_TYPEREGUL)) - Plf1;
    if Plf2 < 0 then Plf2 := 0;
    Plf3 := EvaluePlafond(TOB_Rub, T1.GetValeur(iPCT_TYPETRANCHE3), T1.GetValeur(iPCT_TRANCHE3), Rub, Plafond, DateDeb, DateFin, NbreDec, T1.GetValeur(iPCT_TYPEREGUL)) - Plf1 -
      Plf2;
    if Plf3 < 0 then Plf3 := 0;
    CalculCumulsRegul(Rub, Base, Plf1, Plf2, Plf3, TR1, TR2, TR3, DateDeb, DateFin, ARegulariser, TPlf1, TPlf2, TPlf3);
  end;
end;
// Fonction de calcul des regularisations des rubriques de base de cotisation

procedure CalculCumulsRegul(const Rub: string; var Base, Plf1, Plf2, Plf3, TR1, TR2, TR3: Double; DateDeb, DateFin: TDateTime; const ARegulariser: Boolean; const TPlf1, TPlf2,
  TPlf3: string);
var
  BaseCal: TRendRub;
  Cbas, CPlf1, CTr1, CTr2, CTr3, CPlf2, CPlf3: Double; // Cumuls des valeurs � calculer
  T1: TOB;
  TST2, TST3: Boolean;
  PlafondRub, TypeRegul: string; // champ plafond de la rubrique de base
begin
  Cbas := 0;
  CPlf1 := 0;
  CTr1 := 0;
  CTr2 := 0;
  CTr3 := 0;
  CPlf2 := 0;
  CPlf3 := 0;
  TST2 := FALSE;
  TST3 := FALSE;
  // Recherche exercice social en cours de traitement
  T1 := TOB_ExerSocial.Detail[0];
  DateDeb := T1.GetValue('PEX_DATEDEBUT');
  DateFin := DateDeb - 1; // Regul des montants jusqu'� la date (non incluse) de debut de la session
  // BaseCal:=ValRubDate (Rub, 'BAS', DatD, DatF);  // Calcul&Cumul des champs pour reguls
  if ARegulariser = TRUE then
  begin
    BaseCal := ValBase(Rub); // @@@@@
    with BaseCal do
    begin
      Cbas := Base;
      CPlf1 := Plfd1;
      CPlf2 := Plfd2;
      CPlf3 := Plfd3;
      CTr1 := Tr1;
      CTr2 := Tr2;
      CTr3 := Tr3;
    end;
  end;
  //  calcul Plf1 et Plf2 et Plf3 de la session en cours
  T1 := Paie_RechercheOptimise(TOB_Bases, 'PCT_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
  T1 := TOB_Bases.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [Rub, 'BAS'], FALSE); // $$$$
{$ENDIF}
  if T1 <> nil then
  begin
    PlafondRub := T1.GetValue('PCT_PLAFOND');
    TypeRegul := T1.GetValue('PCT_TYPEREGUL '); // True = Annuelle cas de la Taxe sur les salaires
  end;
  if ((Base + Cbas) >= (Plf1 + CPlf1)) then
  begin
    Tr1 := 0;
    //   if (TST2 = FALSE) AND (CTr2 <>0) then Tr1 := -CTR2;
    Tr1 := Tr1 + Plf1 + CPlf1 - CTr1; // Regul tranche 1
    if (Base + CBas) < (Plf1 + CTr1) then Tr1 := Base + CBas - Ctr1;
  end
  else Tr1 := Base + Cbas - CTr1;

  if (TPlf1 = 'DEP') then Tr1 := Base + Cbas - CTr1; // Deplafonn�e

  if (Plf2 >= 0) or ((Plf2 = 0) and (TypeRegul = 'X')) then // Regul tranche 2 Cas plafond ou regul annuelle
  begin
    Tr2 := 0;
    //  if (TST3 = FALSE) AND (CTR3 <> 0) then TR2:=-CTr3;
    if (Base + CBas - CTr1 - Tr1) < (Plf2 + CTr2) then // plfd1
    begin
      if (Base + CBas - CTr1 - Tr1) > 0 then Tr2 := Base + CBas - Ctr2 - CTr1 - TR1
      else Tr2 := -CTr2;
      //   if (Base+CBas-CTr1-Tr1) < (CPlf1-CTr1) then Tr2 := -CTr2; // D�ficit de tranche 2 > Tranche 2 sans r�gul donc pas de tranche 2
    end
    else
    begin
      Tr2 := Plf2 + CPlf2 - Ctr2;
      if (Base + CBas - CTr1 - Tr1 - CPlf2 - Plf2) < 0 then Tr2 := Tr2 + (Base + CBas - CTr1 - Tr1 - CPlf2 - Plf2);
    end;
    if (TypeRegul = 'X') and (Tr2 > Base) then // Cas regul annuelle et tranche 2 calculee > Base alors limitation � la base
      if TPlf2 <> 'DEP' then Tr2 := Base - Tr1;
    Tr3 := Base - Tr1 - Tr2;
  end;

  if (Plf2 = 0) and (TypeRegul <> 'X') then // Pas de plafond ou regul mensuelle
  begin
    if TPlf3 = '' then Tr3 := 0; // beurk
    //  if Plf2=0 then Tr2:=0; // regul sur tranche2 pratiqu�e
    if (TPlf2 = 'DEP') then Tr2 := Base - Tr1; // Deplafonn�e
  end;
  if (Plf3 <> 0) or ((Plf3 = 0) and (TypeRegul = 'X')) then // Regul tranche 3    AND ((Plf2+CPlf2) >= (Plf3+CPlf3))
  begin
    Tr3 := CBas + Base - CTr1 - Tr1 - Ctr2 - Tr2 - Ctr3;
    if Tr3 > Plf3 + CPlf3 - CTr3 then Tr3 := Plf3 + CPlf3 - CTr3; // limitation sur la tranche 3
    if (TPlf3 = 'DEP') then Tr3 := Base - Tr1 - Tr2; // Deplafonn�e

    // TR4:=Base-Tr1-Tr2-TR3;
  end;
  if ((Plf3 = 0) or ((Plf2 + CPlf2) < (CPlf3 + PLf3))) and (TypeRegul <> 'X') then //
  begin
    //  Tr4:=0;
    if (Plf2 + CPlf2) <= 0 then Tr3 := Base - Tr1 - Tr2;
    //  if (Plf3=0) then Tr3:=0; //  Regul Tranche 3
    if TPlf3 = 'DEP' then Tr3 := Base - Tr1 - Tr2; // Deplafonn�e
    if TPlf3 = '' then Tr3 := 0;
  end;
  if PlafondRub = '' then
  begin
    Tr1 := 0;
    Tr2 := 0;
    Tr3 := 0;
  end;

end;
//Fonction d'�valuation d'un champ d'une Base de cotisation en fonction du type du champ

function EvalueChampBas(Tob_Rub: TOB; TypeChamp, Champ, Rub: string; DateDeb, DateFin: TDateTime): Double;
var
  T_Rech: TOB;
  St: string;
begin
  result := 0;
  if Champ = '' then exit; // tous les champs ne sont pas obligatoires
  T_Rech := Tob_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['AAA', Champ], TRUE);
  if (T_Rech = nil) and (TypeChamp = 'REM') then
  begin
    St := 'Salari� : ' + CodSal + ' La Rubrique de base de cotisation ' + Rub + ' est mal param�tr�e ';
    if TypeTraitement <> 'PREPA' then PGIBox(St, '')
    else TraceErr.Items.Add(St);
    exit;
  end;
  if TypeChamp = 'ELN' then result := ValEltNat(Champ, DateFin) // Recup elelment national
  else
    if TypeChamp = 'VAR' then result := ValVariable(Champ, DateDeb, DateFin, Tob_Rub) // recup calcul d'une variable
  else
    if TypeChamp = 'REM' then result := T_Rech.GetValue('PHB_MTREM'); // Montant de R�mun�ration
end;

// Fonction  de calcul des Plafond1 2 3 en fonction du plafond th�orique calcul�

function EvaluePlafond(TOB_Rub: TOB; TypeChamp, Champ, Rub: string; Plafond: Double; DateDeb, DateFin: TDateTime; NbreDec: Integer; TypeRegul: string): Double;
var
  T_regul: TOB;
begin
  result := 0;
  if TypeRegul = 'X' then // regul de type annuelle utilis�e pour la taxe sur les salaires
  begin
    t_regul := Paie_RechercheOptimise(TOB_HistoBasesCot, 'PHB_RUBRIQUE', Rub); // $$$$
{$IFDEF aucasou}
    T_regul := TOB_HistoBasesCot.FindFirst(['PHB_RUBRIQUE'], [Rub], TRUE);
{$ENDIF}
    if T_regul <> nil then exit; // on a trouv� une ligne historique sur la rubrique de base donc les plafonds annuels sont d�j� connus
  end;
  if Champ = '' then exit; // tous les champs ne sont pas obligatoires donc par exemple pas de plafond en tranche 3
  if TypeChamp = 'ELN' then result := ValEltNat(Champ, DateFin) // Recup elelment national
  else
    if TypeChamp = 'VAR' then result := ValVariable(Champ, DateDeb, DateFin, Tob_Rub) // recup calcul d'une variable
  else
    if TypeChamp = 'NBR' then result := StrToInt(Champ) * Plafond; // Montant du plafondx est  y  fois le plafond
end;

// Fonction qui calcule le bulletion cad qui parcoure la liste des rubriques du bulletins et qui valorise les lignes

procedure CalculBulletin(Tob_Rub: TOB);
var
  i: Integer;
  Base, Taux, Coeff, Montant, TxSal, TxPat, MtSal, MtPat: double;
  Plafond, Plf1, Plf2, Plf3, Tr1, Tr2, Tr3: double;
  CpAcquis,CpMois,CpSupp,CpAnc,CpNbmois,Cpbase : Double; { PT127-1 }
  Ligne, TRech, TETABSAL : TOB;
  lib, Nat, Rub, Them, Etab, CodeSal: string;
  ZDateDeb, ZDateFin: TDateTime;
  AT, OkCalcul: Boolean; { PT127-1 }
  iChampNatureRub, iChampRubrique, iChampDateDebut, iChampDateFin, iChampEtab, iChampSal: integer;
  iChampBaseRem, iChampTauxRem, iChampCoeffRem, iChampMtRem, iChampLibelle: integer;
  iChampBaseCot, iChampTauxSalarial, iChampTauxPatronal, iChampMtSalarial, iChampMtPatronal: integer;
  iChampPlafond, iChampPlafond1, iChampPlafond2, iChampPlafond3, iCHampTranche1, iCHampTranche2, iCHampTranche3: integer;
begin
  DestTOBCumSal; // RAZ des cumuls salari�s car il vont etre recalcul�s
  CreationTOBCumSal;
  // PT92   : 10/12/2003 PH V_50 Recalcul syst�matique de la saisie arr�t
  if Assigned(TOB_SaisieArret) then FreeAndNil(TOB_SaisieArret);
  OkCalcul := False; { PT127-1 }
  Base := 0;
  Taux := 0;
  Coeff := 0;
  Montant := 0;
  TxSal := 0;
  TxPat := 0;
  MtSal := 0;
  MtPat := 0;
  Plf1 := 0;
  Plf2 := 0;
  Plf3 := 0;
  Tr1 := 0;
  Tr2 := 0;
  Tr3 := 0;
  Plafond := 0;
  lib := '';
  nat := '';
  rub := '';
  TauxAt := 0;
  // tri des rubriques par nature et par numero avant le calcul du bulletin
  Tob_Rub.Detail.Sort('PHB_NATURERUB;PHB_RUBRIQUE');

  // optimisation
  if tob_rub.detail.count > 0 then
    with tob_rub.detail[0] do
    begin
      iChampNatureRub := GetNumChamp('PHB_NATURERUB');
      iChampRubrique := GetNumChamp('PHB_RUBRIQUE');
      iChampDateDebut := GetNumChamp('PHB_DATEDEBUT');
      iChampDateFin := GetNumChamp('PHB_DATEFIN');
      iChampEtab := GetNumChamp('PHB_ETABLISSEMENT');
      iChampSal := GetNumChamp('PHB_SALARIE');

      iChampBaseRem := GetNumChamp('PHB_BASEREM');
      iChampTauxRem := GetNumChamp('PHB_TAUXREM');
      iChampCoeffRem := GetNumChamp('PHB_COEFFREM');
      iChampMtRem := GetNumChamp('PHB_MTREM');
      iChampLibelle := GetNumChamp('PHB_LIBELLE');

      iChampBaseCot := GetNumChamp('PHB_BASECOT');
      iChampTauxSalarial := GetNumChamp('PHB_TAUXSALARIAL');
      iChampTauxPatronal := GetNumChamp('PHB_TAUXPATRONAL');
      iChampMtSalarial := GetNumChamp('PHB_MTSALARIAL');
      iChampMtPatronal := GetNumChamp('PHB_MTPATRONAL');

      iChampPlafond := GetNumChamp('PHB_PLAFOND');
      iChampPlafond1 := GetNumChamp('PHB_PLAFOND1');
      iChampPlafond2 := GetNumChamp('PHB_PLAFOND2');
      iChampPlafond3 := GetNumChamp('PHB_PLAFOND3');
      iCHampTranche1 := GetNumChamp('PHB_TRANCHE1');
      iCHampTranche2 := GetNumChamp('PHB_TRANCHE2');
      iCHampTranche3 := GetNumChamp('PHB_TRANCHE3');
    end;

  // 1ere Passe pour traiter toutes les rubriques sauf les remun�rations venant apr�s les cotisations
  for i := 0 to Tob_Rub.Detail.Count - 1 do
  begin
    Base := 0;
    Taux := 0;
    Coeff := 0;
    Montant := 0;
    TxSal := 0;
    TxPat := 0;
    MtSal := 0;
    MtPat := 0;
    lib := '';
    nat := '';
    rub := '';
    Ligne := Tob_Rub.Detail[i];
    if assigned(Ligne) then
      with Ligne do
      begin
        Nat := GetValeur(iChampNatureRub);
        Rub := GetValeur(iChampRubrique);
        ZDateDeb := GetValeur(iChampDateDebut);
        ZDateFin := GetValeur(iChampDateFin);
        Etab := GetValeur(iChampEtab);
        CodeSal := GetValeur(iChampSal);

        if (Nat = 'AAA') and not RechCommentaire(Rub) then
        begin
          // Remun�rations mais on ne calcule pas une rubrique de commentaire associ�e � une r�mun�ration
          trech := Paie_RechercheOptimise(TOB_Rem, 'PRM_RUBRIQUE', Rub); // $$$$
          if assigned(TRech) then
          begin // On recherche le theme de la rubrique
            Them := TRech.GetValue('PRM_THEMEREM');
            { DEB PT127-1 }
            if (Them='ABS') AND (GblCP) AND (OkCalcul=False) and (JCPACQUISTHEORIQUE<>0)  then
              Begin
              TETABSAL := TOB_Etablissement.findfirst(['ETB_ETABLISSEMENT'], [TOB_SALARIE.GetValeur(iPSA_ETABLISSEMENT)], True);
              CpAcquis := ChargeAcquisParametre(TOB_Salarie, TETABSAL, TOB_RUB, ZDateDeb, ZDateFin, True, True, Cpbase, CpNbmois, CpMois, CpSupp, CpAnc);
              if (CpAcquis<>JCPACQUIS) then
                 Begin
                 OkCalcul := True;
                 JCPACQUIS := CpAcquis;
                 InitTobAcquisCp(TOB_Salarie, TETABSAL, ZDateDeb, ZDateFin, Cpbase, CpNbmois, CpMois, CpSupp, CpAnc, suivant);
                 if X <> nil then
                   begin
                   X.CPMOIS.text := floattostr(CpMois);
                   X.CpSupp.text := floattostr(CpSupp);
                   X.CpAnc.text := floattostr(CpAnc);
                   end;
                 MCPACQUIS := Cpnbmois;
                 BCPACQUIS := Cpbase;
                 End;
              End;
            { FIN PT127-1 }
            if (Them <> 'RNI') and (Them <> 'RSS') then
            begin
              EvalueRem(Tob_Rub, rub, Base, Taux, Coeff, Montant, lib, ZDateDeb, ZDateFin, taModification, 0);
              PutValeur(iChampBaseRem, Base);
              PutValeur(iChampTauxRem, Taux);
              PutValeur(iChampCoeffRem, Coeff);
              PutValeur(iChampMtRem, Montant);
              PutValeur(iChampLibelle, lib);
              AlimCumulSalarie(Ligne, CodeSal, Nat, Rub, Etab, ZDateDeb, ZDateFin);
            end;
          end;
        end
          // PT26 : 19/12/2001 V571 PH Traitement ligne de commentaire pour les cotisations
        else if (Nat = 'COT') and (RechCommentaire(Rub) = FALSE) then
        begin
          // Calcul des rubriques de cotisation
          EvalueCot(Tob_Rub, rub, Base, TxSal, TxPat, MtSal, MtPat, lib, ZDateDeb, ZDateFin, taModification, AT);

          PutValeur(iChampBaseCot, Base);
          PutValeur(iChampTauxSalarial, TxSal);
          PutValeur(iChampTauxPatronal, TxPat);
          PutValeur(iChampMtSalarial, MtSal);
          PutValeur(iChampMtPatronal, MtPat);
          PutValeur(iChampLibelle, lib);
          if AT and (MtPat <> 0) then TauxAt := TxPat; // recup du taux at sur une rubrique AT valoris�e
          AlimCumulSalarie(Ligne, CodeSal, Nat, Rub, Etab, ZDateDeb, ZDateFin);
        end
        else if Nat = 'BAS' then
        begin
          // Calcul des rubriques de bases de cotisation
          EvalueBas(Tob_Rub, rub, Base, Plafond, Plf1, Plf2, Plf3, Tr1, Tr2, Tr3, lib, ZDateDeb, ZDateFin, taModification, ChpEntete.BasesMod, ChpEntete.TranchesMod);

          PutValeur(iChampBaseCot, Base);
          PutValeur(iChampPlafond, Plafond);
          PutValeur(iChampPlafond1, Plf1);
          PutValeur(iChampPlafond2, Plf2);
          PutValeur(iChampPlafond3, Plf3);
          PutValeur(iCHampTranche1, Tr1);
          PutValeur(iCHampTranche2, Tr2);
          PutValeur(iCHampTranche3, Tr3);
          PutValeur(iChampLibelle, lib);
          AlimCumulSalarie(Ligne, CodeSal, Nat, Rub, Etab, ZDateDeb, ZDateFin);
        end;
      end; // fin du With
  end; // Fin de la boucle for

  // Deuxieme passe pour traiter uniquement les rubriques de r�mun�rations venant apr�s les cotisations
  for i := 0 to Tob_Rub.Detail.Count - 1 do
  begin
    Base := 0;
    Taux := 0;
    Coeff := 0;
    Montant := 0;
    TxSal := 0;
    TxPat := 0;
    MtSal := 0;
    MtPat := 0;
    lib := '';
    nat := '';
    rub := '';
    Ligne := Tob_Rub.Detail[i];
    if Ligne <> nil then
      with ligne do
      begin
        Nat := GetValeur(iChampNatureRub);
        Rub := GetValeur(iChampRubrique);
        ZDateDeb := GetValeur(iChampDateDebut);
        ZDateFin := GetValeur(iChampDateFin);
        Etab := GetValeur(iChampEtab);
        CodeSal := GetValeur(iChampSal);
        if (Nat = 'AAA') and (RechCommentaire(Rub) = FALSE) then
        begin
          //   Remun�rations mais on ne calcule pas une rubrique de commentaire associ�e � une r�mun�ration
          trech := Paie_RechercheOptimise(TOB_Rem, 'PRM_RUBRIQUE', Rub); // $$$$
          if assigned(TRech) then
          begin // On recherche le theme de la rubrique
            Them := TRech.GetValue('PRM_THEMEREM');
            if (Them = 'RNI') or (Them = 'RSS') then
            begin
              EvalueRem(Tob_Rub, rub, Base, Taux, Coeff, Montant, lib, ZDateDeb, ZDateFin, taModification, 0);
              PutValeur(iChampBaseRem, Base);
              PutValeur(iChampTauxRem, Taux);
              PutValeur(iChampCoeffRem, Coeff);
              PutValeur(iChampMtRem, Montant);
              PutValeur(iChampLibelle, lib);
              AlimCumulSalarie(Ligne, CodeSal, Nat, Rub, Etab, ZDateDeb, ZDateFin);
            end;
          end;
        end
        else
        begin // cas d'une cotisation pour la ducs on recupere le TAUX AT
          // PT26 : 19/12/2001 V571 PH Traitement ligne de commentaire pour les cotisations
          if (Nat = 'COT') and (TauxAT <> 0) and (RechCommentaire(Rub) = FALSE) then Ligne.PutValue('PHB_TAUXAT', TauxAT);
        end; // fin traitement rem ou cot
      end; // Ligne <> nil
  end; // Fin de la boucle for

  Tob_Rub.Detail.Sort('PHB_NATURERUB;PHB_RUBRIQUE');
  // recalcul de la valorisation absence et maintient
end;

procedure IntegreMvtSolde(Tob_Rub, TOB_Salarie: tob; const Etab, Salarie: string; const DateD, DateF: TdateTime);
var
  P5T_Etab: Tob;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  p5t_etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', Etab); // $$$$
{$IFDEF aucasou}
  P5T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [Etab], True);
{$ENDIF}

  if JCPSOLDE = 0 // JCPSOLDE �crit dans Integrepaye
  then
  begin
    BCPACQUIS := Arrondi(RendCumulSalSess('11'), DCP);
    if not CalculValoCP(Tob_solde, Tob_Acquis, P5T_Etab, TOB_Salarie, ChpEntete.Ouvres, ChpEntete.Ouvrables, DateD, DateF, suivant, 'SLD', salarie) //PT-9 ajout Tob_salarie
    then HShowMessage('5;Calcul bulletin :;1 ou plusieurs mouvements de solde n''ont pu �tre pay�s par manque d''acquis;E;O;O;O;;;', '', '');
    ;
    if notVide(Tob_Solde, true) then
      IntegrePaye(Tob_Rub, Tob_Solde, Etab, Salarie, DateD, DateF, 'SLD');
  end
  else
  begin
    //     if BCPACQUIS = Arrondi(RendCumulSalSess ('11'),DCP) then exit;
    if ActionBulCP = tamodification then exit; //mvi
    if AcquisMaj then
      recalculeValoSolde(DateD, DateF, P5T_Etab, TOB_Salarie, Tob_solde, Tob_rub, Salarie) //PT-9 ajout Tob_salarie
    else
      if not CalculValoCP(Tob_solde, Tob_Acquis, P5T_Etab, TOB_Salarie, ChpEntete.Ouvres, ChpEntete.Ouvrables, DateD, DateF, suivant, 'SLD', salarie) //PT-9 ajout Tob_salarie
    then HShowMessage('5;Calcul bulletin :;1 ou plusieurs mouvements de solde n''ont pu �tre pay�s par manque d''acquis;E;O;O;O;;;', '', '');
    ;

  end;
end;
// si modif cumul 11 , recalcul de la valeur des cp solde obligatoire

procedure recalculeValoSolde(const DateD, Datef: tdatetime; P5Etab, TSal, Tob_solde, Tob_rub: tob; const Salarie: string);
var
  DTclotureP, DTFinP, DTDebutP: tdatetime;
  periode: integer;
  NbJoursRef, Valox, NbJAcq, NBJPayes, NBJAcqP: double;
  tp: tob;
  ModeValo: string;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  ModeValo := TrouveModeValorisation(P5etab, TSal); //PT59
  NbJAcq := 0;
  NBJPayes := 0;
  NBJAcqP := 0;
  if TSal.GetValeur(iPSA_CPACQUISMOIS) = 'ETB' then //DEB PT-9
    NbJoursRef := JoursReference(P5Etab.getvalue('ETB_NBREACQUISCP'))
  else
    NbJoursRef := JoursReference(TSal.GetValeur(iPSA_NBREACQUISCP)); //FIN PT-9
  DTclotureP := P5Etab.getvalue('ETB_DATECLOTURECPN');
  periode := RendPeriode(DTFinP, DTDebutP, DTclotureP, DateF);
  {juste pour voir 08-02        BCPACQUIS  := Arrondi(RendCumulSalSess ('11'),DCP);
       DateSortie := Tob_Salarie.GetValeur (iPSA_DATESORTIE);
       if ActionSld = tamodification then
          ChargeACquis(periode,DateD,DateF,DTDebutP,salarie);
       CalculAcquisPeriodeSolde(P5etab,Tob_Acquis,DTDebutP,Dated,NBJAcqP,NbJAcq,NBJPayes);
       Arr := 1+int(NBJAcqP+JCPACQUIS)-(NBJAcqP+JCPACQUIS);
       { suppression des arrondis du bulletin
       Remarque : Si on est en modification, on peut compter sur le date validit�
                  qui correspond � la date fin de bulletin puisque celle ci n'est pas
                  modifiable en modif bulletin.
                  Par contre en cr�ation bulletin, impossible de compter sur cette date
                  car elle peut �tre modifi�e � n'importe quel moment. On aura dc stock�
                  le n� ordre du mvt
       if ActionBulCP <> tacreation then
       begin
       if NotVide(Tob_Acquis,true) then
          begin
          tarr:= Tob_acquis.findfirst(['PCN_TYPECONGE','PCN_DATEVALIDITE'],['ARR',DateF],false);
          while Tarr <> nil do
             begin
             Tarr.free;
             tarr:=Tob_acquis.findnext(['PCN_TYPECONGE','PCN_DATEVALIDITE'],['ARR',DateF],false);
             end;
          end;
       end
       else
       begin
         if NotVide(Tob_Acquis,true) then
         begin
         tarr:=Tob_acquis.findfirst(['PCN_TYPECONGE','PCN_ORDRE','PCN_GENERECLOTURE'],['ARR',OrdreArrBull,'-'],false);
         if Tarr <> nil then Tarr.free;
         end;
       end;        }
  CalculValoX(DTclotureP, DateF, DateD, periode, NbJoursRef, 'SLD', Tob_Acquis, nil);
  if NbJoursRef * 10 * (VALOXP0D + MCPACQUIS) = 0 then
    Valox := 0 else
    //     Valox := arrondi((ValoXP0N+BCPACQUIS)*12/(NbJoursRef*10*(VALOXP0D+MCPACQUIS)),DCP);
    Valox := CalculValoX(DTclotureP, DateF, DateD, periode, NbJoursRef, 'SLD', Tob_Acquis, nil);
  // plut�t avant de g�n�rer un solde
  {re juste pour voir 08-02     RetireAcquisCourant(Tob_Acquis);
       AjouteAcquiscourant(Tob_Acquis,Tob_salarie,DateF,suivant);
        if Tob_pris <> nil then
        begin
        TP := Tob_pris.findfirst([''],[''],True);
        while tp <> nil do
          begin
          if TP.getvalue('PCN_MVTDUPLIQUE') <> 'X' then
             PrisBul    := PrisBul + TP.getvalue('PCN_JOURS');
          TP := Tob_pris.findnext([''],[''],True);
          end;
        end;

       GenereSolde(Tob_Salarie,P5Etab,Tob_Pris,Tob_Acquis, Tob_Solde,DateF,DateD,suivant,JCPACQUIS,PrisBul,'M');}
  {     RetireAcquisCourant(Tob_Acquis);
       AjouteAcquiscourant(Tob_Acquis,Tob_salarie,DateF,suivant);}
  tp := nil;
  if tob_solde <> nil then
    tp := Tob_solde.findfirst(['PCN_PERIODEPY'], ['0'], true);
  while Tp <> nil do
  begin
    if tp.getvalue('PCN_CODERGRPT') <> -1 then
    begin
      TP.putValue('PCN_VALOX', Valox * TP.getvalue('PCN_JOURS'));
      //         ModeValo     := P5Etab.getvalue('ETB_VALORINDEMCP'); // ?????
      if modeValo = 'D' then
        TP.putvalue('PCN_VALORETENUE', TP.getValue('PCN_VALOX'))
      else if ModeValo <> 'M' then
        if TP.getValue('PCN_VALOX') > TP.getValue('PCN_VALOMS') then
          TP.putvalue('PCN_VALORETENUE', TP.getValue('PCN_VALOX'))
        else TP.putvalue('PCN_VALORETENUE', TP.getValue('PCN_VALOMS'));

      AgregeCumulPris(Tob_Solde);
      IntegrePaye(Tob_Rub, Tob_Solde, P5Etab.getvalue('ETB_ETABLISSEMENT'), Salarie, DateD, DateF, 'SLD');
      exit;
    end;
    tp := Tob_solde.findnext(['PCN_PERIODEPY'], ['0'], true);
  end;
end;
{procedure  ChargeACquis(periode:integer;DateD,DateF,DateDP:tdatetime;Salarie:string);
var
st           : string;
Q            : TQuery;
T            : tob;
begin

     if notvide(tob_acquis,true) then exit;
     Tob_Acquis := Tob.create('ACQUIS DE LA PERIODE DU BULLETIN',nil,-1);
     st := 'SELECT * from ABSENCESALARIE WHERE '+
           'PCN_SALARIE = "'+ Salarie  +'" AND '+
           '(PCN_DATEVALIDITE < "' + UsDateTime(dateD)   +
           '" AND PCN_DATEVALIDITE >= "'+ UsDateTime(dateDP) +'") AND '+
           '(PCN_TYPECONGE="ACQ" OR PCN_TYPECONGE="ACA" OR PCN_TYPECONGE="ACS" OR '+
           ' PCN_TYPECONGE="ARR" OR PCN_TYPECONGE="REP" OR '+
           ' PCN_TYPECONGE="AJU" OR ((PCN_TYPECONGE="REL" ) AND PCN_SENSABS = "+"))' +
           ' ORDER BY PCN_DATEVALIDITE DESC';
     Q:=OpenSql(st, TRUE);
     if Q.eof then // pas de cong�s pris
        exit;
     Tob_Acquis.LoadDetailDB('ABSENCESALARIE','','',Q,False) ;
     AcquisMaj := false;
     Ferme(Q);
end;}
{ Fonction qui calcule la date de Paiement de la paie en fonction
de la fiche Salari�. A savoir si la date n'est pas personnalis�e, il faut reprendre
les informations au niveau de l'etablissement
}

function CalculDatePaie(TOB_Sal: TOB; DatePaie: TDateTime): TDateTime;
var
  Zdate, TypeDatPaie, DatPaie, Jour: string;
  T_etab: TOB; // tob etablissement
  MM, JJ, AA: WORD;
begin
  //PT68    19/12/2002 PH V591 Affectation de la date de paiement � la date de fin de paie si non renseign�e
  result := DatePaie;
  Zdate := '';
  TypeDatPaie := '';
  DatPaie := '';
  Jour := '';
  TypeDatPaie := string(TOB_Sal.GetValeur(iPSA_TYPDATPAIEMENT));
  T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Sal.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
  T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Sal.GetValeur(iPSA_ETABLISSEMENT)], TRUE);
{$ENDIF}
  // Type Date de paiement: Idem Etab ou Personnalis�
  if BullCompl <> 'X' then
  begin
    if (TypeDatPaie = 'ETB') or (TypeDatPaie = '') then
    begin
      if T_Etab <> nil then DatPaie := T_Etab.GetValue('ETB_MOISPAIEMENT');
    end
    else DatPaie := TOB_Sal.GetValeur(iPSA_MOISPAIEMENT);
    if DatPaie = 'FDM' then
    begin
      result := FindeMois(DatePaie);
      exit;
    end; // Fin de mois
    if (DatPaie = 'MEC') or (DatPaie = 'MSU') then
    begin
      if DatPaie = 'MSU' then DatePaie := PLUSMOIS(DatePaie, 1);
      Zdate := DateToStr(DatePaie);
      if (TypeDatPaie = 'ETB') or (TypeDatPaie = '') then
      begin
        if T_Etab <> nil then Jour := IntToStr(T_Etab.GetValue('ETB_JOURPAIEMENT'));
      end
      else Jour := IntToStr(TOB_Sal.GetValeur(iPSA_JOURPAIEMENT));
      ZDate := Copy(Jour, 1, 2) + Copy(ZDate, 3, 8);
      if IsValidDate(ZDate) then result := StrToDate(ZDate) // Si date valide alors ok
      else result := FindeMois(DatePaie); // sinon on donne le dernier jour du mois
    end;
  end
    //PT19 : 16/11/01 V562 PH Modif du calcul de la date de paiement dans le cas bulletin compl�mentaire
  else
  begin
    if T_Etab <> nil then DatPaie := T_Etab.GetValue('ETB_BCMOISPAIEMENT')
    else DatPaie := 'FDM'; // si pas renseign� alors fin de mois
    if DatPaie = 'FDM' then
    begin
      result := FindeMois(DatePaie);
      exit;
    end; // Fin de mois
    if (DatPaie = 'MEC') or (DatPaie = 'MSU') then
    begin
      if DatPaie = 'MSU' then DatePaie := PLUSMOIS(DatePaie, 1);
      Zdate := DateToStr(DatePaie);
      if T_Etab <> nil then Jour := IntToStr(T_Etab.GetValue('ETB_BCJOURPAIEMENT'))
      else Jour := IntToStr(TOB_Sal.GetValeur(iPSA_JOURPAIEMENT)); // quoi prendre ?
      if (Jour = '0') and (BullCompl = 'X') then
      begin
        DecodeDate(DatePaie, AA, MM, JJ);
        Jour := IntToStr(JJ);
      end;
      ZDate := Copy(Jour, 1, 2) + Copy(ZDate, 3, 8);
      if IsValidDate(ZDate) then result := StrToDate(ZDate) // Si date valide alors ok
      else result := FindeMois(DatePaie); // sinon on donne le dernier jour du mois
    end;
  end;
end;

{ Fonction qui donne le mode de paiement de la paie en fonction
de la fiche Salari�. A savoir si le mode de paiement n'est pas personnalis�e, il faut reprendre
les informations au niveau de l'etablissement
PT25 : 04/12/2001 V563 PH Mode de r�glement pour les bulletins compl�mentaires
}

function RendModeRegle(TOB_Sal: TOB): string;
var
  TypMode, ModeRegle: string;
  T_etab: TOB; // tob etablissement
begin
  TypMode := '';
  ModeRegle := '';
  TypMode := string(TOB_Sal.GetValeur(iPSA_TYPREGLT));
  T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Sal.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
  T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Sal.GetValeur(iPSA_ETABLISSEMENT)], TRUE);
{$ENDIF}
  if BullCompl = 'X' then
  begin
    if T_Etab <> nil then result := T_Etab.GetValue('ETB_BCMODEREGLE');
    exit;
  end;
  // Type Date de paiement: Idem Etab ou Personnalis�
  if (TypMode = 'ETB') or (TypMode = '') then
  begin
    if T_Etab <> nil then ModeRegle := T_Etab.GetValue('ETB_PGMODEREGLE'); {PT3}
  end
  else ModeRegle := TOB_Sal.GetValeur(iPSA_PGMODEREGLE); {PT3}
  result := ModeRegle;
end;
{ Fonction d'alimentation des rubriques en fonction des profils li�s uniquement � la session de paie
cas pour traiter la maladie, le chomage ...
}

procedure AlimProfilMulti(ListeProfil: string; Salarie, TPE: TOB);
var
  Profil: string;
begin
  Profil := READTOKENST(ListeProfil);
  while Profil <> '' do
  begin
    ChargeProfil(Salarie, TPE, Profil);
    Profil := READTOKENST(ListeProfil);
  end;
end;
{ Fonction qui calcule les variables pr�d�finies et qui ne correspondent pas � une
expression mais qui font appel � des champs de tables
Codes R�serv�s de 1 � 200
//PT55 : 09/08/2002 PH V582 Evaluation des variables de tests avec des strings
                         Mtcalcul variant au lieu de Double
}

function RechVarDefinie(const VariablePaie: string; const DateDebut, DateFin: TDateTime; var MtCalcul: Variant; TOB_Rub: TOB): Boolean;
var
  Code: Integer;
  Mois, Annee: WORD;
  DateAnciennete, Date1, Date2, ZDate: TDateTime;
  RegulMois: Integer;
  TypVar, Val, Etab, CodeSal, LeTypSmic, LeSmic: string;
  T_Etab, TAT, T1, TAcpt: TOB;
  RendRub: TRendRub;
  Borne, C1, CPR1, C2, CPR2, Velt, Abt, TauxAbt: Double;
  MM, JJ, AA: WORD;
  JourOuv, HH, MtAcpt: double;
  Acompte: string;
  TobAcSaisieArret: Tob;
  i: Integer;
  Q: TQuery;
begin
  result := FALSE;
  Val := '';
  Mois := 0;
  Annee := 0;
  MtCalcul := 0;
  Code := ValeurI(VariablePaie);
  if (Code < 1) or (Code > 200) then exit;
  CodeSal := TOB_Salarie.GetValeur(iPSA_SALARIE);
  Etab := TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT);
  if TOB_Salarie.GetValeur(iPSA_DATEANCIENNETE) <= 1 then DateAnciennete := TOB_Salarie.GetValeur(iPSA_DATEENTREE)
  else DateAnciennete := TOB_Salarie.GetValeur(iPSA_DATEANCIENNETE);
  RegulMois := TOB_Salarie.GetValeur(iPSA_REGULANCIEN);
  DateAnciennete := PLUSMOIS(DateAnciennete, RegulMois);
  result := TRUE;
  case Code of
    1: MtCalcul := TOB_Salarie.GetValeur(iPSA_HORAIREMOIS); // Horaire Mensuel Salari�
    // PT66    06/12/2002 PH V591 Variable 2 rend horaire Hebdo de la fiche salari�
    2: MtCalcul := TOB_Salarie.GetValeur(iPSA_HORHEBDO); //   "     Hebdo    "
    3: MtCalcul := TOB_Salarie.GetValeur(iPSA_HORANNUEL); //   "     Mesuel   "
    4: MtCalcul := TOB_Salarie.GetValeur(iPSA_TAUXHORAIRE); //  taux horaire salari�
    5: MtCalcul := RendCumulSalSess('04'); // Salaire de base paie en cours
    6: MtCalcul := RendCumulSalSess('03'); // Horaire de base paie en cours
    7: MtCalcul := TOB_Salarie.GetValeur(iPSA_PERSACHARGE); // Nbre de personnes A charge
    8:
      begin
        AgeSalarie(DateFin, Annee, Mois);
        MtCalcul := Mois;
      end; // Age salari� en mois
    9:
      begin
        AgeSalarie(DateFin, Annee, Mois);
        MtCalcul := Annee;
      end; //       "       Annee
    10: if DateAnciennete < 10 then
        MtCalcul := 0 else MtCalcul := DateFin - DateAnciennete + 1 ; // Anciennt� en jours PT128
    11: if DateAnciennete < 10 then
        MtCalcul := 0 else MtCalcul := AncienneteAnnee(DateAnciennete, DateFin); // Anciennet� en Ann�e
    12: if DateAnciennete < 10 then
        MtCalcul := 0 else MtCalcul := AncienneteMois(DateAnciennete, DateFin); //   " en mois
    13: MtCalcul := JCPACQUISTHEORIQUE; //PT75-2 Jours CP Acquis JCPACQUIS
    14: MtCalcul := DateAnciennete; // Date Anciennet�
    15: MtCalcul := TOB_Salarie.GetValeur(iPSA_DATEENTREE); //
    16: MtCalcul := TOB_Salarie.GetValeur(iPSA_DATESORTIE); //
    17: MtCalcul := TOB_Salarie.GetValeur(iPSA_DATENAISSANCE); //

    20: MtCalcul := Valeur(TOB_Salarie.GetValeur(iPSA_QUALIFICATION));
    21: MtCalcul := Valeur(TOB_Salarie.GetValeur(iPSA_COEFFICIENT));
    22: MtCalcul := Valeur(TOB_Salarie.GetValeur(iPSA_NIVEAU));
    23: MtCalcul := Valeur(TOB_Salarie.GetValeur(iPSA_INDICE));
    24: MtCalcul := TOB_Salarie.GetValeur(iPSA_PCTFRAISPROF); //
    25:
      begin
        if TOB_Salarie.GetValeur(iPSA_MULTIEMPLOY) = 'X' then
        begin
          MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMULTI) + RendCumulSalSess('01');
        end
        else MtCalcul := 0;
      end;
    26:
      begin
        // PT18 : 14/11/01 V562 PH Identification du taux AT en fonction des dates de validit�
        // PT45 : 02/05/2002 Ph V582 initialisation du taux at au debut du traitement
        MtCalcul := 0; // Pour avoir au moins 1 taux m�me � z�ro
        TAT := TOB_TauxAT.FindFirst(['PAT_ETABLISSEMENT', 'PAT_ORDREAT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT), TOB_Salarie.GetValeur(iPSA_ORDREAT)], TRUE);
        while TAT <> nil do
        begin
          if TAT.GetValue('PAT_DATEVALIDITE') <= DateFin then
            MtCalcul := TAT.GetValue('PAT_TAUXAT');
          TAT := TOB_TauxAT.FindNext(['PAT_ETABLISSEMENT', 'PAT_ORDREAT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT), TOB_Salarie.GetValeur(iPSA_ORDREAT)], TRUE);
        end;
      end;
    27: MtCalcul := HTHTRAVAILLES; // Heures th�oriques travaill�es par le salari� sur la p�riode
    28: MtCalcul := ChpEntete.HOuvres; // PT61 Heures ouvr�s
    29: MtCalcul := ChpEntete.HOuvrables; //PT61 Heures ouvrables
    30:
      begin
        if Trentieme > 0 then MtCalcul := Trentieme else MtCalcul := 0;
      end;
    31:
      begin
        TypVar := 'ANC';
        MtCalcul := ValVarTable(TypVar, Val, DateDebut, DateFin, TOB_Rub);
      end; // Anciennet�
    32:
      begin
        TypVar := 'AGE';
        MtCalcul := ValVarTable(TypVar, Val, DateDebut, DateFin, TOB_Rub);
      end; // Age
    33:
      begin
      // DEB PT125
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
        if T_Etab <> nil then
        begin
          TypVar := T_Etab.GetValue('ETB_TYPSMIC'); // Rend soit Elt ou Variable
          Val := T_Etab.GetValue('ETB_SMIC');
        end;
        if TypVar = 'ELT' then MtCalcul := ValEltNat(Val, DateFin)
        else if TypVar = 'VAR' then MtCalcul := ValVariable(Val, DateDebut, DateFin, TOB_Rub)
        else MtCalcul := 0;
//        TypVar := 'DIV';
//        MtCalcul := ValVarTable(TypVar, Val, DateDebut, DateFin, TOB_Rub);
      // FIN PT125
      end; // Minimum Conventionnel
    34:
      begin
        if RendCumulSalSess('04') <> 0 then MtCalcul := (RendCumulSalSess('03') / RendCumulSalSess('04')) // Taux horaire de base reel
        else MtCalcul := 0;
      end;
    35:
      begin // Horaire Etablissement
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
        T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)], True);
{$ENDIF}
        if T_Etab <> nil then MtCalcul := T_Etab.GetValue('ETB_HORAIREETABL');
      end;
    36: MtCalcul := ChpEntete.HeuresTrav; // Heures travaill�es  theoriques
    37: MtCalcul := ChpEntete.Ouvres; // nbre de jours ouvr�s
    38: MtCalcul := ChpEntete.Ouvrables; // nbre de jours ouvrables
    39: MtCalcul := JTHTRAVAILLES; // Jours th�orique travaill�s par le salari� sur la p�riode
    40: MtCalcul := HCPPRIS; // Heures CP pris
    41: MtCalcul := HCPPAYES; // Heures CP pay�es
    42: MtCalcul := HCPASOLDER; // Heures CP A Solder
    43: MtCalcul := JCPACQUIS; // Jours CP Acquis

    44:
      begin
        // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
        if BullCompl <> 'X' then
        begin
          //   if ActionSld <> TaCreation then //mvi PT42 mise en commentaire pour calcul mt absence m�me en cr�ation
          GestionCalculAbsence(tob_rub, Datedebut, datefin, 'PRI');
          MtCalcul := JCPPRIS; // Jours CP Pris
        end;
      end;
    45: MtCalcul := JCPPAYES; // Jours CP Payer
    46: MtCalcul := JCPASOLDER; // Jours CP � solder
    47: MtCalcul := CPMTABS; // Montant absence CP
    48: MtCalcul := CPMTINDABS; // Calcul Indemnit� CP
    49: MtCalcul := CPMTINDCOMP; // Calcul Indemnit� Compensatrice CP
    50:
      begin
        // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
        if BullCompl <> 'X' then
        begin
          if (PP) and (ActionSld = TaModification) then
            PP := false else
          begin
            //PT69-2 Ajout Condition date sortie
            Date1 := TOB_Salarie.GetValeur(iPSA_DATESORTIE);
            if ((Date1 >= DateDebut) and (Date1 <= DateFin)) or (SLDCLOTURE) then //PT75-1
            begin
              IntegreMvtSolde(Tob_rub, TOB_Salarie, Etab, CodeSal, DateDebut, DateFin); //PT-9 ajout Tob_Salarie
              GestionCalculAbsence(tob_rub, Datedebut, datefin, 'SLD'); //mvi
            end;
            ActionSld := TaModification;
          end;
          MtCalcul := JCPSOLDE; // Jours CP solde
          PP := false;
        end;
      end;
    51: MtCalcul := CPMTABSSOL; // Montant absence solde
    52: MtCalcul := CPMTINDABSSOL; // Calcul Indemnit� solde
    53: MtCalcul := HABSPRIS; //PT33 Ajout nouvel variable : Heures Absences pris
    54: MtCalcul := JABSPRIS; //PT33 Ajout nouvel variable : Jours Absences pris

    55: MtCalcul := RendCumulSalSess('13') + RendCumulSalSess('14'); // BAse CSG CRDS en Cours
    56: MtCalcul := RendCumulSalSess('15') + RendCumulSalSess('17'); // Base CSG Deductible
    57: MtCalcul := RendCumulSalSess('16'); // Base CSG Deductible

    60: MtCalcul := RendCumulSalSess('01'); // Brut mois
    61: MtCalcul := RendCumulSalSess('02'); // Brut Fiscal mois
    62: MtCalcul := RendCumulSalSess('10'); // Net A Payer Mois
    63: MtCalcul := RendCumulSalSess('09'); // Net Imposable Mois
    64: MtCalcul := RendCumulSalSess('20'); // Heures r�ellement travaill�es
    65:
      begin //
        Borne := RendCumulSalSess('20'); // Heures travaillees salaries
        {PT53 Mise en commentaire :
        C1    := ValVariable ('35',DateDebut,DateFin, TOB_Rub);    // Horaire etablissement
         if Borne > C1 then Borne := C1;}
        MtCalcul := (RendCumulSalSess('31')) - (Borne * ValEltNat('0011', DateFin));
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (Borne * ValEltNat('0011', DateFin));
      end;
    66:
      begin
        Borne := RendCumulSalSess('20'); // Heures travaillees salaries
        {PT53 Mise en commentaire :
         C1    := ValVariable ('35',DateDebut,DateFin, TOB_Rub);    // Horaire etablissement
         if Borne > C1 then Borne := C1;}
        MtCalcul := RendCumulSalSess('31') - (Borne * ValEltNat('0011', DateFin));
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    67:
      begin
        MtCalcul := (RendCumulSalSess('31')) - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.5);
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.5);
      end;
    68:
      begin
        MtCalcul := RendCumulSalSess('31') - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.5);
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    // PT67    06/12/2002 PH V591 Nouvelles Variables 72 � 75 + modif 70 et 71
    70:
      begin
        // PT99   : 19/03/2004 PH V_50 FQ 11106 Variable 0070 et 0071
        Borne := RendCumulSalSess('22');
        if Borne > 130 then Borne := 130;
        MtCalcul := (RendCumulSalSess('31')) - (Borne * ValEltNat('0011', DateFin) * 1.2);
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (Borne * ValEltNat('0011', DateFin) * 1.2);
      end;
    71:
      begin
        Borne := RendCumulSalSess('22');
        if Borne > 130 then Borne := 130;
        MtCalcul := (RendCumulSalSess('31')) - (Borne * ValEltNat('0011', DateFin) * 1.2);
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    72:
      begin
        Borne := RendCumulSalSess('20'); // Heures travaillees salaries
        C1 := ValVariable('0035', DateDebut, DateFin, TOB_Rub); // horaire �tablissement PT81
        if Borne > C1 then Borne := C1; // limitation � l'horaire �tablissement
        MtCalcul := (RendCumulSalSess('31')) - (Borne * ValEltNat('0011', DateFin));
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (Borne * ValEltNat('0011', DateFin));
      end;
    73:
      begin
        Borne := RendCumulSalSess('20'); // Heures travaillees salaries
        C1 := ValVariable('0035', DateDebut, DateFin, TOB_Rub); // horaire �tablissement  PT81
        if Borne > C1 then Borne := C1; // limitation � l'horaire �tablissement
        MtCalcul := RendCumulSalSess('31') - (Borne * ValEltNat('0011', DateFin));
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    74:
      begin
        Borne := RendCumulSalSess('20'); // Heures travaillees salaries
        C1 := ValVariable('0035', DateDebut, DateFin, TOB_Rub); // horaire �tablissement PT81
        if Borne > C1 then Borne := C1; // limitation � l'horaire �tablissement
        DecodeDate(DateFin, AA, MM, JJ);
        ZDate := EncodeDate(AA, 01, 01); // Calcul de la date au 01/01 en fonction de la date de fin
        MtCalcul := Borne * ValEltNat('0011', ZDate) * 1.2;
        // PT85   : 09/09/2003 PH V_42 Correction variable 74
        if (RendCumulSalSess('31') - MtCalcul < 0) then MtCalcul := RendCumulSalSess('31');
      end;
    75:
      begin
        MtCalcul := RendCumulSalSess('02') - ValVariable('0074', DateDebut, DateFin, TOB_Rub);
        // PT85   : 09/09/2003 PH V_42 Correction variable 75
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    // FIN PT67
    // DEB PT111 Nouvelles variables CEGID
    76:
      begin
        MtCalcul := (RendCumulSalSess('31')) - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.3);
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.3);
      end;
    77:
      begin
        MtCalcul := RendCumulSalSess('31') - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.3);
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    78:
      begin
        MtCalcul := (RendCumulSalSess('31')) - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.4);
        if MtCalcul < 0 then MtCalcul := RendCumulSalSess('31')
        else MtCalcul := (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.4);
      end;
    79:
      begin
        MtCalcul := RendCumulSalSess('31') - (RendCumulSalSess('20') * ValEltNat('0011', DateFin) * 1.4);
        if MtCalcul < 0 then MtCalcul := 0;
      end;
    // PT111
   // PT63    07/11/2002 PH V591 Creation variable 80 rend le mois de la paie (datefin) FQ 10302
    080:
      begin
        DecodeDate(DateFin, AA, MM, JJ);
        MtCalcul := MM;
      end;
    // PT76  : 04/06/03 PH V_421 FQ 10425,10620,10655 nvelles variables
    081: MtCalcul := DateDebut; // Date de d�but du bulletin
    082: MtCalcul := DateFin; // Date de fin du bulletin
    083:
      begin
        if (TOB_Salarie.GetValeur(iPSA_DATESORTIE) = NULL) or
          (TOB_Salarie.GetValeur(iPSA_DATESORTIE) <= 10) then MtCalcul := EncodeDate(2099, 01, 01)
        else MtCalcul := TOB_Salarie.GetValeur(iPSA_DATESORTIE);
      end;
    084:
      begin
        if TOB_Salarie.GetValeur(iPSA_SEXE) = 'M' then MtCalcul := 1
        else MtCalcul := 0;
      end;
    085: MtCalCul := TOB_Salarie.GetValeur(iPSA_PERSACHARGE);
    086:
      begin
        if (VH_PAIE.PGProfilFnal <> '') and (VH_PAIE.PGProfilFnal <> NULL) then MtCalcul := 9
        else MtCalcul := 0;
      end;
    // FIN PT76
    090: MtCalcul := RendBasePrecarite(DateDebut, DateFin, TOB_Salarie.GetValeur(iPSA_SALARIE));
    091:
      begin
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
        T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)], True);
{$ENDIF}
        if T_Etab <> nil then MtCalcul := T_Etab.GetValue('ETB_TAUXVERSTRANS');
      end;
    092: MtCalcul := (FinDEMOIS(DateFin) - DEBUTDEMOIS(DateDebut)) + 1; // PT122 Nombre de jours calendaires du mois
    // PT84   : 26/08/2003 PH V_42 Mise en place saisie arret
    095..098:
      begin
        // DEB PT113 recup du montant de l'acompte avant le calcul de la saisie arret
        if VH_Paie.PGGESTACPT = true then
        begin
          MtAcpt := 0;
          Q := OpenSQL('SELECT PRM_RUBRIQUE FROM REMUNERATION WHERE ##PRM_PREDEFINI## PRM_SAISIEARRETAC="X"', True);
          TobAcSaisieArret := Tob.Create('Les rubriques acomptes', nil, -1);
          TobAcSaisieArret.LoadDetailDB('Les acomptes', '', '', Q, False);
          Ferme(Q);
          for i := 0 to TobAcSaisieArret.Detail.Count - 1 do
          begin
            Acompte := TobAcSaisieArret.Detail[i].GetValue('PRM_RUBRIQUE');
            TAcpt := TOB_Rub.FindFirst(['PHB_RUBRIQUE', 'PHB_NATURERUB'], [Acompte, 'AAA'], TRUE);
            if TAcpt <> nil then MtAcpt := MtAcpt + TAcpt.getvalue('PHB_MTREM');
          end;
          TobAcSaisieArret.Free;
        end
        else MtAcpt := 0;
        if not Assigned(TOB_SaisieArret) then TOB_SaisieArret := PGCalcSaisieArret(CodeSal, DateDebut, DateFin, TOB_Salarie.GetValeur(iPSA_PERSACHARGE), RendCumulSalSess('10'), MtAcpt);
        // FIN PT113
        if Assigned(TOB_SaisieArret) then MtCalcul := RendMtLigneSaisieArret(VariablePaie, TOB_SaisieArret)
        else MtCalcul := 0;
      end;

    100: MtCalcul := ValEltNat('0001', DateFin) * Trentieme; // Plafond salari� proratis�  30eme
    101: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRETHEO); // Salaire Salari� temps complet
    102: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRETHEO) * Trentieme; // Salaire Temps complet 30eme
    103:
      begin // PT91   : 05/12/2003 PH V_50 Cr�ation de la variable 103 Taux horaire chomage partiel
        C1 := ValVariable('0034', DateDebut, DateFin, TOB_Rub) * 0.5;
        C2 := ValEltNat('0017 ', DateFin);
        if C1 > C2 then MtCalcul := C1
        else MtCalcul := C2;
      end;
    // PT56 : 09/08/2002 PH V582 Creation des variables CEGID pour recup champs salaries
    110: MtCalCul := TOB_Salarie.GetValeur(iPSA_DATELIBRE1);
    111: MtCalCul := TOB_Salarie.GetValeur(iPSA_DATELIBRE2);
    112: MtCalCul := TOB_Salarie.GetValeur(iPSA_DATELIBRE3);
    113: MtCalCul := TOB_Salarie.GetValeur(iPSA_DATELIBRE4);
    114: MtCalCul := TOB_Salarie.GetValeur(iPSA_LIBREPCMB1);
    115: MtCalCul := TOB_Salarie.GetValeur(iPSA_LIBREPCMB2);
    116: MtCalCul := TOB_Salarie.GetValeur(iPSA_LIBREPCMB3);
    117: MtCalCul := TOB_Salarie.GetValeur(iPSA_LIBREPCMB4);
    118: MtCalCul := TOB_Salarie.GetValeur(iPSA_TRAVAILN1);
    119: MtCalCul := TOB_Salarie.GetValeur(iPSA_TRAVAILN2);
    120: MtCalCul := TOB_Salarie.GetValeur(iPSA_TRAVAILN3);
    121: MtCalCul := TOB_Salarie.GetValeur(iPSA_TRAVAILN4);
    122: MtCalCul := TOB_Salarie.GetValeur(iPSA_CODESTAT);
    // FIN PT56
    123: // DEB PT109
      begin
        if TOB_Salarie.GetValeur(iPSA_BOOLLIBRE1) = 'X' then MtCalCul := 1 // case 1 � cocher libres de la fiche salari�
        else MtCalCul := 0;
      end;
    124:
      begin
        if TOB_Salarie.GetValeur(iPSA_BOOLLIBRE2) = 'X' then MtCalCul := 1 // case 1 � cocher libres de la fiche salari�
        else MtCalCul := 0;
      end;
    125:
      begin
        if TOB_Salarie.GetValeur(iPSA_BOOLLIBRE3) = 'X' then MtCalCul := 1 // case 1 � cocher libres de la fiche salari�
        else MtCalCul := 0;
      end;
    126:
      begin
        if TOB_Salarie.GetValeur(iPSA_BOOLLIBRE4) = 'X' then MtCalCul := 1 // case 1 � cocher libres de la fiche salari�
        else MtCalCul := 0;
      end;
    127:
      begin
        if TOB_Salarie.GetValeur(iPSA_SORTIEDEFINIT) = 'X' then MtCalCul := 1 // Sortie d�finitive
        else MtCalCul := 0;
      end;
    128: // Jours OUVRES
      begin
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT));
        if T_Etab <> nil then
        begin
          CalCulVarOuvresOuvrablesMois(T_Etab, TOB_Salarie, nil, DebutdeMois(Datedebut), FindeMois(Datedebut), TRUE, JOUROuv, HH);
          MtCalcul := JOUROuv;
        end
        else MtCalcul := 0;
      end;
    129: // Jours Ouvrables
      begin
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT));
        if T_Etab <> nil then
        begin
          CalCulVarOuvresOuvrablesMois(T_Etab, TOB_Salarie, nil, DebutdeMois(Datedebut), FindeMois(Datedebut), FALSE, JOUROuv, HH);
          MtCalcul := JOUROuv;
        end
        else MtCalcul := 0;
      end;
    130: // Date d�but exercice
      begin
        if TOB_ExerSocial <> nil then T1 := TOB_ExerSocial.Detail[0];
        if T1 <> nil then MtCalcul := Double(T1.GetValue('PEX_DATEDEBUT'))
        else MtCalCul := Double(IDate1900);
      end;
    131: // Date fin Exercice
      begin
        if TOB_ExerSocial <> nil then T1 := TOB_ExerSocial.Detail[0];
        if T1 <> nil then MtCalcul := Double(T1.GetValue('PEX_DATEFIN'))
        else MtCalCul := Double(IDate1900);
      end;
    // FIN PT109
 // DEB PT110 Anciennet� dans le poste
    132:
      begin
        DateAnciennete := TOB_Salarie.GetValeur(iPSA_ANCIENPOSTE);
        if DateAnciennete < 10 then
          MtCalcul := 0 else MtCalcul := DateFin - DateAnciennete; // Anciennt� en jours
      end;
    133:
      begin
        DateAnciennete := TOB_Salarie.GetValeur(iPSA_ANCIENPOSTE);
        if DateAnciennete < 10 then
          MtCalcul := 0 else MtCalcul := AncienneteMois(DateAnciennete, DateFin); // Anciennet� en Mois PT115
      end;
    134:
      begin
        DateAnciennete := TOB_Salarie.GetValeur(iPSA_ANCIENPOSTE);
        if DateAnciennete < 10 then
          MtCalcul := 0 else MtCalcul := AncienneteAnnee(DateAnciennete, DateFin); //  Idem en Ann�e PT115
      end;
    135: // test si Date de sortie du salari� dans la p�riode de paie
      begin
        if (TOB_Salarie.GetValeur(iPSA_DATESORTIE) >= DateDebut) and (TOB_Salarie.GetValeur(iPSA_DATESORTIE) <= DateFin) then MtCalcul := 1
        else MtCalcul := 0;
      end;
    // FIN PT110
    140: // M�thode de valorisation CP    PT118
      begin
        if TOB_Salarie.GetValeur(iPSA_VALORINDEMCP) = 'D' then MtCalcul := 1
        else if TOB_Salarie.GetValeur(iPSA_VALORINDEMCP) = 'M' then MtCalcul := 2
        else if TOB_Salarie.GetValeur(iPSA_VALORINDEMCP) = 'X' then MtCalcul := 3
        else MtCalcul := 0;
      end;
    150: MtCalcul := StrToint(VH_Paie.PGMethodHeures); // M�thode de calcul des heures Travaill�es ou R�elles PGMETHODHEURES

    160:
      begin // Prorata TVA etablissement du salari�
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
        T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)], True);
{$ENDIF}
        if T_Etab <> nil then MtCalcul := T_Etab.GetValue('ETB_PRORATATVA');
      end;
    162: MtCalcul := ValVariable('0061', DateDebut, DateFin, TOB_Rub) * ValVariable('0160', DateDebut, DateFin, TOB_Rub) / 100;
    164: MtCalcul := ValEltNat('0070', DateFin) * ValVariable('0160', DateDebut, DateFin, TOB_Rub) / 100;
    166: MtCalcul := ValEltNat('0071', DateFin) * ValVariable('0160', DateDebut, DateFin, TOB_Rub) / 100;
    170: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS1); //  Salaire Mensuel salari� 1
    171: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS2); //  Salaire Mensuel salari� 2
    172: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS3); //  Salaire Mensuel salari� 3
    173: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS4); //  Salaire Mensuel salari� 4

    174: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRANN1); // Salaire Annuel salari� 1
    175: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRANN2); // Salaire Annuel salari� 2
    176: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRANN3); // Salaire Annuel salari� 3
    177: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRANN4); // Salaire Annuel salari� 4
    //PT58 06/09/2002 PH V585 Variables pour restituer les elements de salaires 5
    178: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIREMOIS5); //  Salaire Mensuel salari� 5
    179: MtCalcul := TOB_Salarie.GetValeur(iPSA_SALAIRANN5); // Salaire Annuel salari� 5

    180: MtCalcul := TOB_Salarie.GetValeur(iPSA_PCTFRAISPROF); // % Abattement frais professionnel
    181:
      begin // abattement pour frais professionnels
        if RendDateExerSocial(DateDebut, DateFin, Date1, Date2, FALSE) then
        begin
          CPR1 := ValCumulDate('01', Date1, Date2);
          CPR2 := ValCumulDate('02', Date1, Date2);
          C1 := RendCumulSalSess('01');
          C2 := RendCumulSalSess('02');
          Velt := ValEltNat('0015', DateFin); // limite abattement
          if ((CPR1 - CPR2) > Velt) then MtCalcul := 0 // plafaond abattement depasse donc ZERO
          else
          begin
            TauxAbt := ValVariable('0180', DateDebut, DateFin, TOB_Rub);
            Abt := (C1 * TauxAbt) / 100;
            MtCalcul := C1 - C2 + CPR1 - CPR2 + Abt; // calcul du differentiel
            if (MtCalcul > Velt) then MtCalcul := (Velt - (CPR1 - CPR2)) / (TauxAbt / 100) // ponderation
            else MtCalcul := C1; // abattement = brut du mois en court sur lequel on fait le calcul de l'abattement
          end;
        end;
        // la variable rend la base de l'abattement
      end;
    182:
      begin // rend valeur du smic ou minimum conventionnel de l'etablissement
        T_Etab := Paie_RechercheOptimise(TOB_Etablissement, 'ETB_ETABLISSEMENT', TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)); // $$$$
{$IFDEF aucasou}
        T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)], True);
{$ENDIF}
        if T_Etab <> nil then
        begin
          LeTypSmic := T_Etab.GetValue('ETB_TYPSMIC');
          LeSmic := T_Etab.GetValue('ETB_SMIC');
          if LeTypSmic <> '' then
          begin // le type smic est soit une element national soit une valeur dans une table
            if LeTypSmic = 'ELN' then MtCalcul := ValEltNat(LeSmic, DateFin)
            else
            begin
              LeTypSmic := 'VAR';
              MtCalcul := ValVariable(LeSmic, DateDebut, DateFin, Tob_Rub);
            end;
          end;
        end;
      end;
    183:
      begin // differentiel calcul du brut par rapport Smic
        C1 := RendCumulSalSess('22') + RendCumulSalSess('23') * 1.1 + RendCumulSalSess('24') * 1.25 +
          RendCumulSalSess('25') * 1.33 + RendCumulSalSess('26') * 1.5 + RendCumulSalSess('27') * 2; // cumul des heures coefficient�
        MtCalcul := C1 * ValVariable('0182', DateDebut, DateFin, TOB_Rub);
        if MtCalcul < RendCumulSalSess('02') then MtCalcul := 0
        else MtCalcul := MtCalcul - RendCumulSalSess('02');
      end;
    190:
      begin // Recup appoint de la paie precedente
        Date1 := 0;
        Date2 := 0;
        RendDatePaiePrec(Date1, Date2, DateDebut, DateFin);
        if (Date1 <> 0) and (Date2 <> 0) then
        begin
          RendRub := ValRubDate('9992', 'AAA', Date1, Date2);
          // PT89   : 21/10/2003 PH V_42 FQ 10928 Recup de l'appoint precedant en n�gatif sinon mauvais sens
          MtCalcul := RendRub.MontRem * -1;
        end;
      end;
    191:
      begin // Calcul appoint de la paie en cours si salari� sorti alors pas d'appoint
        Date1 := TOB_Salarie.GetValeur(iPSA_DATESORTIE);
        if (Date1 >= DateDebut) and (Date1 <= DateFin) then MtCalcul := 0 // Date de sortie dans la paie traitee donc pas appoint
        else
        begin
          //         if (Date1 < 10) then  PT87   : 06/10/2003 PH V_421 FQ 10595 Gstion des apppoints avec date de sortie
          MtCalcul := RendCumulSalSess('10') - ARRONDI(RendCumulSalSess('10'), 0);
          MtCalcul := ARRONDI(MtCalcul, 2) * -1;
        end;
      end;
    192:
      begin // Trop per�u rend la valeur du net � payer n�gatif de la paie pr�c�dente
        Date1 := 0;
        Date2 := 0;
        RendDatePaiePrec(Date1, Date2, DateDebut, DateFin);
        if (Date1 <> 0) and (Date2 <> 0) then
        begin
          MtCalcul := ValCumulDate('10', Date1, Date2);
          if MtCalcul > 0 then MtCalcul := 0;
        end;
      end;

  end;
end;

{ Fonction qui sert simplement � memoriser le calcul du trentieme
Attention, cette fonction est � utiliser obligatoirement pour affecter le trentieme.
En saisie, puisque le num�rateur et le d�nominateur peuvent etre saisis, elle est obligatoire
En pr�paration automatique, idem mais le d�nominateur sera tjrs 30
}

procedure MemoriseTrentieme(const MtTrent: Double);
begin
  Trentieme := MtTrent;
end;

{ Fonction qui recup�re le TOB salari� pour avoir tous les champs de la fiche salari�
� jour en fonction de la base : Il faudrait faire une requete SQL contenant que les champs utiles
pour �viter de r�cup�rer ts les champs : Requete trop longue
}

procedure RecupTobSalarie(const Salarie: string);
var
  Q: TQuery;
  st: string;
begin
  //if TOB_Salarie<>NIL then begin TOB_Salarie.free; TOB_Salarie := NIL end;
  if TOB_DUSALARIE <> nil then
  begin
    TOB_DUSALARIE.free;
    TOB_DUSALARIE := nil
  end;
  TOB_DUSALARIE := TOB.Create('Mon SALARIE', nil, -1);
  st := 'SELECT PSA_SALARIE,PSA_ETABLISSEMENT,PSA_TRAVAILN1,PSA_TRAVAILN2,PSA_TRAVAILN3,PSA_TRAVAILN4,PSA_CODESTAT,PSA_LIBREPCMB1,' +
    'PSA_LIBREPCMB2,PSA_LIBREPCMB3,PSA_LIBREPCMB4,PSA_CONFIDENTIEL,PSA_TAUXHORAIRE,PSA_SALAIREMOIS1,PSA_SALAIREMOIS2,PSA_SALAIREMOIS3,' +
    'PSA_SALAIREMOIS4,PSA_SALAIREMOIS5,PSA_SALAIRANN1,PSA_SALAIRANN2,PSA_SALAIRANN3,PSA_SALAIRANN4,PSA_SALAIRANN5,PSA_DATENAISSANCE,PSA_DATEENTREE,' +
    'PSA_DATESORTIE,PSA_TYPPROFILREM,PSA_PROFILREM,PSA_TYPPROFIL,PSA_PROFIL,PSA_TYPPERIODEBUL,PSA_PERIODBUL,' +
    'PSA_TYPPROFILRBS,PSA_PROFILRBS,PSA_TYPREDREPAS,PSA_REDREPAS,PSA_TYPREDRTT1,PSA_REDRTT1,PSA_TYPREDRTT2,PSA_REDRTT2,';
  st := st + 'PSA_PROFILTPS,PSA_TYPPROFILAFP,PSA_PROFILAFP,PSA_TYPPROFILAPP,PSA_PROFILAPP,PSA_TYPPROFILRET,PSA_PROFILRET,' +
    'PSA_TYPPROFILMUT,PSA_PROFILMUT,PSA_TYPPROFILPRE,PSA_PROFILPRE,PSA_TYPPROFILTSS,PSA_PROFILTSS,PSA_TYPPROFILCGE,PSA_PROFILCGE,' +
    'PSA_PROFILCDD,PSA_PROFILMUL,PSA_TYPPROFILFNAL,PSA_PROFILFNAL,PSA_TYPPROFILTRANS,PSA_PROFILTRANS,PSA_TYPPROFILANC,PSA_PROFILANCIEN,' +
    'PSA_LIBELLE,PSA_PRENOM,PSA_NUMEROSS,PSA_ADRESSE1,PSA_ADRESSE2,PSA_ADRESSE3,PSA_CODEPOSTAL,PSA_VILLE,PSA_INDICE,PSA_NIVEAU,PSA_CONVENTION,' +
    'PSA_CODEEMPLOI,PSA_AUXILIAIRE,PSA_DATEANCIENNETE,PSA_QUALIFICATION,PSA_COEFFICIENT,PSA_LIBELLEEMPLOI,PSA_CIVILITE,PSA_CPACQUISMOIS,PSA_NBREACQUISCP,' +
    'PSA_TYPDATPAIEMENT,PSA_MOISPAIEMENT,PSA_JOURPAIEMENT,PSA_TYPREGLT,PSA_PGMODEREGLE,PSA_REGULANCIEN,PSA_HORHEBDO,PSA_HORAIREMOIS,PSA_HORANNUEL,';
  st := st + 'PSA_PERSACHARGE,PSA_PCTFRAISPROF,PSA_MULTIEMPLOY,PSA_SALAIREMULTI,PSA_ORDREAT,PSA_SALAIRETHEO,PSA_DATELIBRE1,PSA_DATELIBRE2,PSA_DATELIBRE3,' +
    'PSA_DATELIBRE4,PSA_VALANCCP,PSA_ANCIENNETE,PSA_CALENDRIER,PSA_STANDCALEND,PSA_BOOLLIBRE1,PSA_BOOLLIBRE2,PSA_BOOLLIBRE3,PSA_BOOLLIBRE4,' +
    'PSA_DADSPROF,PSA_DADSCAT,PSA_TAUXPARTIEL,PSA_CPTYPEMETHOD,PSA_VALORINDEMCP,PSA_CPTYPEVALO,PSA_MVALOMS,PSA_VALODXMN,PSA_CPACQUISANC,PSA_BASANCCP,' +
    'PSA_VALANCCP,PSA_DATANC,PSA_TYPDATANC,PSA_DATEACQCPANC,PSA_NBRECPSUPP,PSA_CPTYPERELIQ,PSA_RELIQUAT,PSA_CONDEMPLOI,';
  st := st + ' PSA_TYPNBACQUISCP,PSA_NBACQUISCP,PSA_SEXE,PSA_SORTIEDEFINIT, '; //PT75-2 ajout new param. // PT116
  st := st + ' PSA_CONGESPAYES,PSA_CPACQUISSUPP,PSA_ANCIENPOSTE '; { PT100-1 & PT100-2 }
  st := st + 'FROM SALARIES WHERE PSA_SALARIE="' + Salarie + '"';
  Q := OpenSql(st, TRUE);
  TOB_DUSALARIE.LoadDetailDB('SALARIES', '', '', Q, False);
  TOB_Salarie := TOB_DUSALARIE.detail[0];
  if iPSA_ETABLISSEMENT = 0 then MemorisePsa(TOB_Salarie);
  Ferme(Q);
end;
//fonction qui examine si le champ est du type valeur alors jamais de saisie

function ExamCasValeurRem(const ACol: Integer; T1: TOB): Boolean;
var
  St: string;
begin
  result := FALSE;
  case ACol of
    2: st := T1.GetValue('PRM_TYPEBASE');
    3: st := T1.GetValue('PRM_TYPETAUX');
    4: st := T1.GetValue('PRM_TYPECOEFF');
    5: st := T1.GetValue('PRM_TYPEMONTANT');
  end;
  if st <> '' then
  begin
    if StrToInt(st) > 1 then result := TRUE;
  end // @@@@ =8 au lieu de >1
  else result := TRUE;
end;
{ Fonction d'�valuation d'une variable de paie de type VALEUR.
Les variables sont du type soit une valeur � proprement dit,
soit un �l�ment national � une date  fixe : Exemple : Elt national au 01/01 alors
que l'on fait la paie du mois de Juillet.
Les autres cas cad Cotisation, Cumuls, Rem ... sont trait�s dans les variables de
type cotisation,cumul,r�mun�ration ce qui offre plus de possibilit�s
}

function EvalueVarVal(T_Rech: TOB; const DateDebut, DateFin: TDateTime; TOB_Rub: TOB): Double;
var
  i: Integer;
  Zdate: TDateTime;
  Mois, Jour, Annee: WORD;
  St, lib, Labase: string;
begin
  result := 0;
  i := StrToInt(T_Rech.GetValue('PVA_TYPEBASE0'));
  St := T_Rech.GetValue('PVA_DATEDEBUT');
  if St <> '' then
  begin // Recup de l'annee dans la date et affection du jj,mois saisis
    DecodeDate(DateFin, Annee, Mois, Jour);
    Jour := StrToInt(Copy(St, 1, 2));
    Mois := StrToInt(Copy(St, 3, 2));
    ZDate := EncodeDate(Annee, Mois, Jour);
  end
  else ZDate := DateFin; // si pas de date de validite alors on prend la date de la paie
  lib := '';
  case i of
    20: lib := 'AGE';
    21: lib := 'ANC';
    22: lib := 'DIV'; // Table Divers ou minimum conventionnel
    // PT86   : 17/09/2003 PH V_421 Traitement des tables DIW pour une variable de type valeur (idem DIV)
    220: lib := 'DIW';
  end;
  LaBase := T_Rech.GetValue('PVA_BASE0');
  case i of
    2: result := ValEltNat(T_Rech.GetValue('PVA_BASE0'), ZDate);
    4: result := T_Rech.GetValue('PVA_BASE0');
    20..22: result := ValVarTable(lib, LaBase, DateDebut, DateFin, TOB_Rub);
    // PT86   : 17/09/2003 PH V_421 Traitement des tables DIW pour une variable de type valeur (idem DIV)
    220: result := ValVarTable(lib, LaBase, DateDebut, DateFin, TOB_Rub);
  end;
end;
{ Fonction d'evaluation d'une variable de type Cumul cad qui valorise un cumul
� une date donn�e
}

function EvalueVarCum(T_Rech: TOB; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB): Double;
var
  ZdatD, ZdatF: TDateTime;
  TCum: TOB;
  PerRaz, LeCum: string; // Periode de raz du cumul
begin
  result := 0;
  PerRaz := '';
  TCum := Paie_RechercheOptimise(TOB_Cumuls, 'PCL_CUMULPAIE', T_Rech.GetValue('PVA_BASE0')); // $$$$
{$IFDEF aucasou}
  TCum := TOB_Cumuls.findFirst(['PCL_CUMULPAIE'], [T_Rech.GetValue('PVA_BASE0')], FALSE);
{$ENDIF}
  if TCum <> nil then PerRaz := Tcum.getvalue('PCL_RAZCUMUL');
  LeCum := T_Rech.GetValue('PVA_BASE0');
  RendDateVar(T_Rech, DateDeb, DateFin, ZdatD, ZdatF);
  // PT28 : 27/12/2001 V571 PH Calcul des variables de tupe cumul en tenant compte du mois de RAZ
  if T_Rech.GetValue('PVA_PERIODECALCUL') = '005' then // Variable recherchant un cumul ant�rieur
    // PT70 : 23/01/2003 PH V591 Correction du calcul des bornes de dates pour la valorisation d'un cumul ant�rieur avec une p�riode de raz
    BorneDateCumul(DateDeb, DateFin, ZdatD, ZdatF, PerRaz);
  // FIN PT28
  if (ZdatD = -1) and (Zdatf = -1) then exit; // variable non calculable session en dehors de la periode de validite
  if (ZdatD = 0) or (ZdatF = 0) then result := RendCumulSalSess(T_Rech.GetValue('PVA_BASE0'))
  else result := ValCumulDate(T_Rech.GetValue('PVA_BASE0'), ZdatD, ZdatF);
  // PT21 : 20/11/01 V562 PH Modif du calcul des variables recherchant un cumul annuel + paie en cours
  if T_Rech.GetValue('PVA_PERIODECALCUL') = '007' then
    result := result + RendCumulSalSess(T_Rech.GetValue('PVA_BASE0'));
end;
{ Fonction d'evaluation d'une variable de type Rubrique cad qui valorise une cotisation ou r�mun�ration
� une date donn�e
}

function EvalueVarRub(const Nature: string; T_Rech: TOB; const DateDeb, DateFin: TDateTime; TOB_Rub: TOB; TypeB, ChampBase: string): Double;
var
  ZdatD, ZdatF: TDateTime;
  Calcul: TRendRub;
  lib, Rub, TypC, Periode: string;
  TRech: TOB;
  AT: Boolean;
begin
  result := 0;
  lib := '';
  ZdatD := 0;
  ZdatF := 0;
  if (TypeB = '') and (ChampBase = '') then
  begin // cas evaluation d'une variable de type cotisation ou r�mun�ration
    Rub := T_Rech.GetValue('PVA_BASE0');
    TypC := T_Rech.GetValue('PVA_TYPEBASE0');
    Periode := T_Rech.GetValue('PVA_PERIODECALCUL'); // PT112
  end
  else
  begin // cas evaluation d'un op�rande d'une variable qui recup�re des infos des rubriques de rem ou de cot
    Rub := Champbase;
    TypC := TypeB;
    Periode := ''; // PT112
  end;
  RendDateVar(T_Rech, DateDeb, DateFin, ZdatD, ZdatF);
  if (ZdatD = -1) and (Zdatf = -1) then exit; // variable non calculable session en dehors de la periode de valisite
  if (ZdatD = 0) or (ZdatF = 0) then
  begin
    if Nature = 'REM' then
      EvalueRem(TOB_Rub, Rub, Calcul.BasRem, Calcul.TauxRem, Calcul.CoeffRem, Calcul.MontRem, lib, DateDeb, DateFin, taModification, 0)
    else
      if Nature = 'COT' then
    begin
      EvalueCot(TOB_Rub, Rub, Calcul.BasCot, Calcul.TSal, Calcul.TPat, Calcul.MSal, Calcul.MPat, lib, DateDeb, DateFin, taModification, AT);
      // PT64    07/11/2002 PH V591 Variable de paie rend le taux patronal ou salarial
      if (TypC = '25') or (TypC = '26') then
      begin
        Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['COT', Rub], TRUE);
        if Trech = nil then exit;
        if TypC = '25' then result := Trech.GetValue('PHB_TAUXSALARIAL')
        else if TypC = '26' then result := Trech.GetValue('PHB_TAUXPATRONAL');
      end;
    end
    else
    begin
      if (Nature >= '05') and (Nature <= '08') then
      begin
        Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['AAA', Rub], TRUE);
        if Trech = nil then exit;
      end
      else if (Nature >= '09') and (Nature <= '10') then
      begin
        Trech := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [Rub], FALSE); // $$$$
        if Trech = nil then exit;
      end
        // PT64    07/11/2002 PH V591 Variable de paie rend le taux patronal ou salarial FQ 10276
      else if ((Nature >= '12') and (Nature <= '14')) or ((Nature >= '25') and (Nature <= '26')) then
      begin
        Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['COT', Rub], TRUE);
        if Trech = nil then exit;
      end
      else if (Nature >= '16') and (Nature <= '19') then
      begin
        Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['BAS', Rub], TRUE);
        if Trech = nil then exit;
      end;
      if Nature = '20' then lib := 'AGE'
      else if Nature = '21' then lib := 'ANC'
      else if Nature = '22' then lib := 'MIN'
        // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
      else if Nature = '220' then lib := 'DIW'
      else if Nature = '02' then result := ValEltNat(Rub, DateFin)
      else if Nature = '03' then result := ValVariable(Rub, DateDeb, DateFin, TOB_Rub)
      else if Nature = '04' then result := Valeur(Rub)
      else if Nature = '05' then result := Trech.GetValue('PHB_BASEREM')
      else if Nature = '06' then result := Trech.GetValue('PHB_TAUXREM')
      else if Nature = '07' then result := Trech.GetValue('PHB_COEFFREM')
      else if Nature = '08' then result := Trech.GetValue('PHB_MTREM')
      else if Nature = '09' then result := EvalueChampRem(TOB_Rub, Trech.GetValue('PRM_TYPEMINI'), Trech.GetValue('PRM_VALEURMINI'), Rub, DateDeb, DateFin) // Mini Rem
      else if Nature = '10' then result := EvalueChampRem(TOB_Rub, Trech.GetValue('PRM_TYPEMINI'), Trech.GetValue('PRM_VALEURMAXI'), Rub, DateDeb, DateFin) // maxi rem
      else if Nature = '12' then result := Trech.GetValue('PHB_BASECOT')
      else if Nature = '13' then result := Trech.GetValue('PHB_MTPATRONAL')
      else if Nature = '14' then result := Trech.GetValue('PHB_MTSALARIAL')
      else if Nature = '16' then result := Trech.GetValue('PHB_BASECOT')
      else if Nature = '17' then result := Trech.GetValue('PHB_TRANCHE1')
      else if Nature = '18' then result := Trech.GetValue('PHB_TRANCHE2')
      else if Nature = '19' then result := Trech.GetValue('PHB_TRANCHE3')
      else if Nature = '23' then result := StrToDate(Rub)
        // PT64    07/11/2002 PH V591 Variable de paie rend le taux patronal ou salarial
      else if Nature = '25' then result := Trech.GetValue('PHB_TAUXSALARIAL')
      else if Nature = '26' then result := Trech.GetValue('PHB_TAUXPATRONAL');
      // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
      if ((Nature >= '20') and (Nature <= '22')) or (Nature = '220') then result := ValVarTable(lib, Rub, DateDeb, DateFin, TOB_Rub);
    end;
  end
  else Calcul := ValRubDate(Rub, Nature, ZdatD, ZdatF);
  if Nature = 'REM' then
  begin
    if TypC = '05' then result := Calcul.BasRem
    else if TypC = '06' then result := Calcul.TauxRem
    else if TypC = '07' then result := Calcul.CoeffRem
    else if TypC = '08' then result := Calcul.MontRem;
    if Periode = '007' then // DEB PT112
    begin
      Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['AAA', Rub], TRUE);
      if Trech <> nil then
      begin
        if TypC = '05' then result := result + Trech.GetValue('PHB_BASEREM')
        else if TypC = '06' then result := result + Trech.GetValue('PHB_TAUXREM')
        else if TypC = '07' then result := result + Trech.GetValue('PHB_COEFFREM')
        else if TypC = '08' then result := result + Trech.GetValue('PHB_MTREM');
      end;
    end; // FIN PT112
  end;
  if Nature = 'COT' then
  begin
    if TypC = '12' then result := Calcul.BasCot
    else if TypC = '14' then result := Calcul.MSal
    else if TypC = '13' then result := Calcul.MPat;
    if Periode = '007' then // DEB PT112
    begin
      Trech := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['COT', Rub], TRUE);
      if Trech <> nil then
      begin
        if TypC = '12' then result := result + Trech.GetValue('PHB_BASECOT')
        else if TypC = '14' then result := result + Trech.GetValue('PHB_MTSALARIAL')
        else if TypC = '13' then result := result + Trech.GetValue('PHB_MTPATRONAL');
      end;
    end; // FIN PT112
  end;

end;
{ fonction qui calcule les dates de d�but et de fin pour borner le calcul sur une p�riode donn�e
pour les cumuls, les cotisations et les r�mun�rations
}

procedure RendDateVar(T_Rech: TOB; const DateDeb, DateFin: TDateTime; var ZdatD, ZdatF: TDateTime);
var
  i, Trimestre, NbreMois: Integer;
  PeriodCal: string;
  Annee, Mois, Jour, Mois1, AA, MM, JJ: WORD;
  LaDate: TDateTime;
begin
  PeriodCal := T_Rech.GetValue('PVA_PERIODECALCUL');
  if (PeriodCal = '000') or (PeriodCal = '') then // calcul sur la paie en cours
  begin
    ZdatD := 0;
    ZdatF := 0; // sur la session en cours
    exit; // Sortie de la fonction pour indiquer que c'est la session de paie en cours � prendre en compte
  end;
  if PeriodCal = '004' then // Calcul par rapport � 2 fourchettes de date
  begin
    DecodeDate(DateFin, Annee, Mois, Jour); // Pour R�cup�rer l'ann�e
    Jour := StrToInt(Copy(T_Rech.GetValue('PVA_DATEDEBUT'), 1, 2));
    Mois := StrToInt(Copy(T_Rech.GetValue('PVA_DATEDEBUT'), 3, 2));
    Mois1 := StrToInt(Copy(T_Rech.GetValue('PVA_DATEFIN'), 3, 2));
    if Mois1 < Mois then ZDatD := EncodeDate(Annee - 1, Mois, Jour)
    else ZDatD := EncodeDate(Annee, Mois, Jour);
    Jour := StrToInt(Copy(T_Rech.GetValue('PVA_DATEFIN'), 1, 2));
    ZDatF := EncodeDate(Annee, Mois1, Jour);
  end;
  if PeriodCal = '001' then // Calcul par rapport au mois
  begin
    i := (StrToInt(Copy(T_Rech.GetValue('PVA_MOISCALCUL'), 2, 2)) * -1);
    ZDatF := PLUSMOIS(DateFin, i);
    ZdatF := FindeMois(ZDatF);
    ZdatD := DebutdeMois(ZDatF);
  end;
  // PT21 : 20/11/01 V562 PH Modif du calcul des variables recherchant un cumul annuel + paie en cours
  if (PeriodCal = '003') or (PeriodCal = '007') then // Calcul par rapport � l'ann�e
  begin
    DecodeDate(DateFin, Annee, Mois, Jour);
    // PT39 : 04/04/2002 PH V571 Modif insertion rub contenant une variable de nature cumul periode annuelle
    if (PeriodCal = '007') then i := 0
    else i := StrToInt(Copy(T_Rech.GetValue('PVA_ANNEE'), 2, 2));
    // PT30 : 27/12/2001 V571 PH Calcul des dates Trimestres,ann�es - X et en tenant compte du d�calage
    Annee := Annee - i;
    if not VH_Paie.PGDecalage then
    begin
      ZDatD := EncodeDate(Annee, 01, 01);
      ZDatF := EncodeDate(Annee, 12, 31);
    end
    else
    begin
    // PT126 Recup de la bonne ann�e si d�calage de paie
      if Mois <> 12 then ZDatD := EncodeDate(Annee - 1, 12, 01)
      else ZDatD := EncodeDate(Annee, 12, 01) ;
      ZDatF := EncodeDate(Annee, 11, 30);
    end;
  end;
  if PeriodCal = '002' then // Calcul par rapport au trimestre
  begin
    DecodeDate(DateFin, Annee, Mois, Jour);
    Trimestre := 4;
    // PT30 : 27/12/2001 V571 PH Calcul des dates Trimestres,ann�es - X et en tenant compte du d�calage
    if not VH_Paie.PGDecalage then
    begin
      if Mois <= 3 then Trimestre := 1
      else if Mois <= 6 then Trimestre := 2
      else if Mois <= 9 then Trimestre := 3;
      if Trimestre = 4 then
      begin
        ZDatD := EncodeDate(Annee, 10, 01);
        ZDatF := EncodeDate(Annee, 12, 31);
      end;
      if Trimestre = 3 then
      begin
        ZDatD := EncodeDate(Annee, 07, 01);
        ZDatF := EncodeDate(Annee, 09, 30);
      end;
      if Trimestre = 2 then
      begin
        ZDatD := EncodeDate(Annee, 04, 01); // PT105  04 au lieu de 03
        ZDatF := EncodeDate(Annee, 06, 30);
      end;
      if Trimestre = 1 then
      begin
        ZDatD := EncodeDate(Annee, 01, 01);
        ZDatF := EncodeDate(Annee, 03, 31);
      end;
    end
    else
    begin
      if Mois <= 2 then Trimestre := 1
      else if Mois <= 5 then Trimestre := 2
      else if Mois <= 8 then Trimestre := 3;
      if Trimestre = 4 then
      begin
        ZDatD := EncodeDate(Annee, 09, 01);
        ZDatF := EncodeDate(Annee, 11, 30);
      end;
      if Trimestre = 3 then
      begin
        ZDatD := EncodeDate(Annee, 06, 01);
        ZDatF := EncodeDate(Annee, 08, 31);
      end;
      if Trimestre = 2 then
      begin
        ZDatD := EncodeDate(Annee, 03, 01);
        ZDatF := EncodeDate(Annee, 05, 31);
      end;
      if Trimestre = 1 then
      begin
        LaDate := EncodeDate(Annee, 2, 1);
        LaDate := FINDEMOIS(LaDate);
        DecodeDate(LaDate, AA, MM, JJ);
        ZDatD := EncodeDate(Annee - 1, 12, 01);
        ZDatF := EncodeDate(Annee, 02, JJ);
      end;
    end;
    i := StrToInt(Copy(T_Rech.GetValue('PVA_TRIMESTRE'), 2, 2));
    ZDatD := PLUSMOIS(ZDatD, i * 3 * -1);
    ZDatF := FINDEMOIS(PLUSMOIS(ZDatF, i * 3 * -1));
  end;
  if PeriodCal = '005' then // Calcul par rapport depuis le Depuis de l'exercice jusqu'� date debut paie -1
  begin // Reprend en fait le cumul ant�rieur
    RendDateExerSocial(DateDeb, DateFin, ZDatD, ZDatF);
    if ZDatF < ZDatD then ZDatF := ZDatD;
    exit;
  end;
  //PT15 : 24/10/01 : V562 : PH Calcul periode glissnate pour variables de type cumul ou rubrique
  if PeriodCal = '006' then
  begin
    NbreMois := T_Rech.GetValue('PVA_NBREMOISGLISS');
    if NbreMois = 0 then
    begin // Pas de mois = pas de calcul
      ZDatD := -1;
      ZDatF := -1;
      exit;
    end;
    NbreMois := NbreMois * -1; // cas c'est toujours par rapport � des mois pr�c�dents
    ZDatF := DebutdeMois(DateDeb) - 1;
    // PT41 : 05/04/2002 PH V571 variable glissante sur X mois prennait 1 mois de trop ajout de 1
    NbreMois := NbreMois + 1;
    // PT50 : 01/07/2002 PH V582 modif sur clacul fourchette de dates pour les variables de type cumul : -1
    ZDatD := PLUSMOIS(ZDatF, NbreMois); // Retour de x mois par rapport fin de mois
    ZDatD := DebutdeMois(ZDatD); // On se positionne au debut du mois pour le prendre
    exit; // on sort pour �viter les contr�les de coh�rence de dates des autres m�thodes
  end;
  if (ZDatD > DateFin) then
  begin // cas Date debut calcul de la variable > date de fin de la session de paie = pas de calcul
    ZDatD := -1;
    ZDatF := -1;
    exit;
  end;
  if (ZDatF > DateDeb) and (PeriodCal <> '004') then
  begin // cas Date fin calcul de la variable < date de debut de la session de paie = pas de calcul
    // PT39 : 04/04/2002 V571 PH Modif insertion rub contenant une variable de nature cumul periode annuelle
    // PT50 : 01/07/2002 V582 PH modif sur clacul fourchette de dates pour les variables de type cumul
    if (PeriodCal = '007') or (PeriodCal = '003') or (PeriodCal = '001') or (PeriodCal = '002') then
    begin // PT105 Prise en compte aussi des p�riodes 001 et 002 et bornage Date debut
      ZDatF := DateDeb - 1;
      if ZDatD > ZDatF then ZDatD := ZDatF;
      exit;
    end;

    ZDatD := -1; // sauf dans le cas d'une variable de  calcul de date � date qui va rechercher un calcul ant�rieur
    ZDatF := -1;
    exit;
  end;
  if ZDatF > DateFin then
  begin // cas Date fin calcul de la variable > Date de fin de la session
    ZDatF := DateDeb - 1; // alors on exclus la sesion en cours
    if ZDatD > ZDatF then
    begin
      ZDatD := -1;
      ZDatF := -1;
      exit;
    end;
  end;
end;


//------------------------------------------------------------------------------
// fonction qui d�tecte la pr�sence d'op�rateur logique et construit une chaine
// d'�valuation autour de ceux ci
//------------------------------------------------------------------------------

function EvalueExpVar(TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime; const Ztype, ZBase, Zoperat: string; const maxO: Integer): string;
var
  chaine: string; // la chaine que je renvoie
  i: integer;
  DebI, FinI: integer; // indices bornant le controle de l'�valuation d'in�galit�.
  Operateur: string; // valeur de l'op�rateur en cours de traitement
  PO, PF: char;
begin
  PO := '(';
  PF := ')';
  DebI := 0;
  chaine := PO;
  for i := 0 to maxO
    do
  begin // for 1
    if T_Rech.FieldExists(Zoperat + inttostr(i)) then
    begin
      Operateur := T_Rech.GetValue(Zoperat + inttostr(i));
    end
    else Operateur := '#0';

    // l'op�rateur est de type et/ou : on traite le bout de chaine jusqu'� cet op�rateur !
    if IsOperateurLogique(Operateur) then
    begin
      FinI := i - 1;
      chaine := chaine + '(' + EvalueVarCalcul(TOB_Rub, T_Rech, DateDebut, DateFin, DebI, FinI, Ztype, ZBase, Zoperat) + ')' + Operateur;
      DebI := i + 1;
    end;
    //       end; // fin si champ existe dans la TOB
  end; // le do begin for 1
  chaine := chaine + PO + EvalueVarCalcul(TOB_Rub, T_Rech, DateDebut, DateFin, DebI, MaxO, Ztype, ZBase, Zoperat) + PF + PF;
  result := chaine;
end;

{
//------------------------------------------------------------------------------
// Fonction qui convertit une s�quence d'op�randes et d'op�rateurs d�pourvues
// d'op�rateurs logiques
//------------------------------------------------------------------------------
// PT55 : 09/08/2002 V582 PH Evaluation des variables de tests avec des strings
   Test si typebase = 24 (= String) alors pas de STRFPOINT
}

function EvalueVarCalcul(TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime; const DebI, FinI: integer; const Ztype, ZBase, Zoperat: string): string;
var
  i, j: integer;
  chaineI: string;
  Operateur: string;
  PO: char;
  PF: char;
begin
  PO := '(';
  PF := ')';
  chaineI := PO;
  if (Zoperat = 'PVA_OPERATRESTHEN') and (FinI = 3)
    then
  begin
    // FinI := 3;
  end;
  for i := DebI to FinI
    do
  begin // do begin no 1
    if T_Rech.FieldExists(Zoperat + inttostr(i)) then
      Operateur := T_Rech.GetValue(Zoperat + inttostr(i))
    else Operateur := '#0';
    // PT36 : 26/03/2002 V571 PH 10eme ligne de calcul des variables de type calcul
    if (Operateur = '') and (i = 9) then Operateur := 'FIN'; // Bornage de la 10Eme ligne
    //1er cas l'op�rateur n'est pas de type op�rateur d'in�galit�, on stocke jusqu'a fin
    if (Operateur = '') and ((T_Rech.GetValue('PVA_NATUREVAR') = 'CAL') or (T_Rech.GetValue('PVA_NATUREVAR') = 'TES')) then break; // Pour sortir ???? @@@@@

    if not IsOperateurInegalite(Operateur) then
    begin // A voir
      if T_Rech.GetValue(Ztype + inttostr(i)) <> '24' then
        chaineI := chaineI + STRFPOINT(EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(i)),
          T_Rech.GetValue(ZBase + inttostr(i)), TOB_Rub, T_Rech, DateDebut, DateFin))
      else chaineI := chaineI + EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(i)),
          T_Rech.GetValue(ZBase + inttostr(i)), TOB_Rub, T_Rech, DateDebut, DateFin);

      if (Operateur = 'FIN') or (i = FinI)
        then
      begin
        chaineI := chaineI + PF;
        result := chaineI;
      end
      else chaineI := chaineI + Operateur;
      continue;
    end;
    //2�me cas l'op�rateur est de type op�rateur d'in�galit�, on stocke jusqu'a fin
    //  On condid�re qu'il n'y a plus d'autre op�rateur logique dans la chaine trait�e
    // sinon, il serait s�par� par un op�rateur logique.
    // A voir
    if T_Rech.GetValue(Ztype + inttostr(i)) <> '24' then
      chaineI := chaineI + STRFPOINT(EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(i)),
        T_Rech.GetValue(ZBase + inttostr(i)), TOB_Rub, T_Rech, DateDebut, DateFin)) + ')'
    else
      chaineI := chaineI + EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(i)),
        T_Rech.GetValue(ZBase + inttostr(i)), TOB_Rub, T_Rech, DateDebut, DateFin) + ')';

    chaineI := PO + chaineI + Operateur + PO;
    for j := i + 1 to FinI
      do
    begin // do begin no 2
      // A voir
      if T_Rech.GetValue(Ztype + inttostr(i)) <> '24' then
        chaineI := chaineI + STRFPOINT(EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(j)),
          T_Rech.GetValue(ZBase + inttostr(j)), TOB_Rub, T_Rech, DateDebut, DateFin))
      else
        chaineI := chaineI + EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(j)),
          T_Rech.GetValue(ZBase + inttostr(j)), TOB_Rub, T_Rech, DateDebut, DateFin);

      Operateur := T_Rech.GetValue(Zoperat + inttostr(j));
      if (Operateur <> 'FIN') and (Operateur <> '') then
        chaineI := chaineI + Operateur
      else
      begin
        result := chaineI + PF + PF;
        exit;
      end;
    end; // for do begin no 2
    // A voir
    if T_Rech.GetValue(Ztype + inttostr(i)) <> '24' then
      chaineI := ChaineI + STRFPOINT(EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(FinI + 1)),
        T_Rech.GetValue(ZBase + inttostr(FinI + 1)), TOB_Rub, T_Rech, DateDebut, DateFin)) + PF + PF
    else
      chaineI := ChaineI + EvalueUnChampVar(T_Rech.GetValue(Ztype + inttostr(FinI + 1)),
        T_Rech.GetValue(ZBase + inttostr(FinI + 1)), TOB_Rub, T_Rech, DateDebut, DateFin) + PF + PF;

    result := chaineI;
    break; // pas la peine de boucler; il ne peut y avoir 2 op�rateur de
    // d'in�galit� dans le bout de chaine d�limit� !
  end; // do begin du for  do begin no 1

  result := chaineI;
end;

//------------------------------------------------------------------------------
// Fonction qui v�rifie si l'op�rateur pass� en param�tre est de type logique
//------------------------------------------------------------------------------

function IsOperateurLogique(const Operateur: string): boolean;
begin
  result := ((Operateur = 'AND') or (Operateur = 'OR'));
end;

//------------------------------------------------------------------------------
// Fonction qui v�rifie si l'op�rateur pass� en param�tre est de type In�galit�
//------------------------------------------------------------------------------

function IsOperateurInegalite(const Operateur: string): boolean;
begin
  result := ((Operateur = '<') or (Operateur = '<=') or
    (Operateur = '>') or (Operateur = '>=') or
    (Operateur = '=') or (Operateur = '<>'));
end;
{ Fonction qui evalue un champ ou operande d'une variable de type calcul ou test
cas 23 specifique pour traiter des comparaisons de dates  Uniquement d�fini pour des
variables de paie.
// PT55 : 09/08/2002 V582 PH Evaluation des variables de tests avec des strings
          La focntion rend un Variant au lieu d'un double + case 24
}

function EvalueUnChampVar(const TypeB: string; ChampBase: string; TOB_Rub, T_Rech: TOB; const DateDebut, DateFin: TDateTime): Variant;
var
  i: Integer;
  T1: TOB;
  lib: string;
  Base, Plafond, Plf1, Plf2, Plf3, TR1, TR2, TR3: Double;
begin
  result := 0;
  Base := 0;
  Plafond := 0;
  Plf1 := 0;
  Plf2 := 0;
  Plf3 := 0;
  TR1 := 0;
  TR2 := 0;
  TR3 := 0;
  lib := '';
  if (TypeB = '') or (ChampBase = '') then exit;
  i := StrToInt(TypeB);
  if (i = 9) or (i = 10) then
  begin
    T1 := Tob_Rem.FindFirst(['PRM_RUBRIQUE'], [ChampBase], FALSE); // $$$$
  end;

  case i of
    20: lib := 'AGE';
    21: lib := 'ANC';
    22: lib := 'DIV'; // Avt MIN ??? Table Divers ou minimum conventionnel
    // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
    220: lib := 'DIW';
  end;

  case i of
    2: result := ValEltNat(ChampBase, DateFin); // cas d'un �lement national
    3: result := ValVariable(ChampBase, DateDebut, DateFin, TOB_Rub); // cas d'une variable
    4: result := VALEUR(ChampBase); // cas d'une valeur
    5..8: result := EvalueVarRub(TypeB, T_Rech, DateDebut, DateFin, TOB_Rub, TypeB, ChampBase); // cas d'une r�mun�ration dans la session de paie
    9:
      begin
        if T1 <> nil then result := EvalueChampRem(TOB_Rub, T1.GetValue('PRM_TYPEMINI'), T1.GetValue('PRM_VALEURMINI'), ChampBase, DateDebut, DateFin);
      end;
    10:
      begin
        if T1 <> nil then result := EvalueChampRem(TOB_Rub, T1.GetValue('PRM_TYPEMINI'), T1.GetValue('PRM_VALEURMAXI'), ChampBase, DateDebut, DateFin);
      end;
    12..14: result := EvalueVarRub(TypeB, T_Rech, DateDebut, DateFin, TOB_Rub, TypeB, ChampBase); // cas d'une cotisation dans la session de paie
    16..19:
      begin
        {        EvalueBas(Tob_Rub, ChampBase, Base, Plafond,Plf1,Plf2,Plf3,TR1,TR2,TR3,lib,DateDebut, DateFin, taModification,ChpEntete.BasesMod,ChpEntete.TranchesMod);
                 result:=Base;}
        result := RendBaseRubBase(ChampBase, TOB_Rub, i - 16); // cas d'une Base de cotisation dans la session de paie ou T1,T2,T3
      end;
    20..22: result := ValVarTable(lib, Champbase, DateDebut, DateFin, TOB_Rub);
    23: result := StrToDate(ChampBase);
    24: result := '''+ChampBase+''';
    // PT64    07/11/2002 PH V591 Variable de paie rend le taux patronal ou salarial
    25..26: result := EvalueVarRub(TypeB, T_Rech, DateDebut, DateFin, TOB_Rub, TypeB, ChampBase); // cas d'une cotisation dans la session de paie
    // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
    220: result := ValVarTable(lib, Champbase, DateDebut, DateFin, TOB_Rub);
  end; // Fin du case
end; // Fin fonction

{ Fonction qui rend la base de la rubrique de base dans la TOB_RUB
Si la rubrique de base n'existe elle rend 0
}

function RendBaseRubBase(const Rubrique: string; TOB_Rub: TOB; Quoi: Integer = -1): Double;
var
  T1: TOB;
begin
  result := 0;
  T1 := TOB_Rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], ['BAS', Rubrique], TRUE);
  if T1 <> nil then
  begin
    if Quoi = 0 then result := T1.GetValue('PHB_BASECOT')
    else if Quoi = 1 then result := T1.GetValue('PHB_TRANCHE1')
    else if Quoi = 2 then result := T1.GetValue('PHB_TRANCHE2')
    else if Quoi = 3 then result := T1.GetValue('PHB_TRANCHE3');
  end;
end;
{ Calcul d'une variable de type Anciennet�, minimum conventionnel, Age
La fonction va rechercher la table dossier avec la convention collective renseign�e
au niveau du salari�
Si elle ne trouve pas alors on recherche la table dossier quelque soit la convention collective
PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas ==> refonte fonction
}

function ValVarTable(const TypeVar: string; var TDossier: string; const DateDebut, DateFin: TDateTime; TOB_Rub: TOB; Origine: string = ''): Double;
var
  Period, TypeNature, Champ, Profil, st: string;
  T1, T_Etab: TOB;
  AgeAnc: Double;
  Inclus, Pris: Boolean;
  Ind, zz: string;
  ii: Integer;
begin
  result := 0;
  if (TypeVar = 'ANC') or (TypeVar = 'DIV') or (TypeVar = 'DIW') or (TypeVar = 'AGE') then TypeNature := 'INT'
  else TypeNature := 'VAL'; // Pour Coeff,Qualif,Niveau,Indice
  if (TypeVar = 'ANC') then
  begin
    if TDossier = '' then
    begin
      if origine = 'CP' then
        TDossier := TOB_Salarie.GetValeur(iPSA_VALANCCP)
      else
        TDossier := TOB_Salarie.GetValeur(iPSA_ANCIENNETE);
    end;
  end;
  if (TypeVar = 'AGE') then
  begin
    if TDossier = '' then
    begin
      if Origine = 'CP' then
        TDossier := TOB_Salarie.GetValeur(iPSA_VALANCCP)
      else
        TDossier := TOB_Salarie.GetValeur(iPSA_ANCIENNETE);
    end;
  end;
  if (TypeVar = 'DIV') then
  begin
    if TDossier = '' then
    begin // ?? recuperation du smic ou MC par rapport � l'�tablissement et non plus par rapport au salarie (n'�tait pas utilis�)
      T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)], True);
      if T_Etab <> nil then TDossier := T_Etab.GetValue('ETB_SMIC');
    end;
  end;

  T1 := TOB_Minimum.FindFirst(['PMI_NATURE', 'PMI_CONVENTION', 'PMI_TYPENATURE', 'PMI_CODE'],
    [TypeVar, TOB_Salarie.GetValeur(iPSA_CONVENTION), TypeNature, TDossier], FALSE); // $$$$
  if T1 = nil then
    T1 := TOB_Minimum.FindFirst(['PMI_NATURE', 'PMI_CONVENTION', 'PMI_TYPENATURE', 'PMI_CODE'],
      [TypeVar, '000', TypeNature, TDossier], FALSE); // Cas convention non renseignee dans table dossier // $$$$
  Pris := TRUE;
  if T1 <> nil then // Recherche si un profil est associ� � la table
  begin
    Profil := T1.GetValue('PMI_PROFIL');
    if Profil <> '' then // Un Profil est s�lectionn�
    begin
      St := T1.GetValue('PMI_INCLUS');
      if st = 'X' then Inclus := TRUE else Inclus := FALSE;
      Pris := FALSE;
      if (Inclus = TRUE) and (Profil = TOB_Salarie.GetValeur(iPSA_PROFIL)) then Pris := TRUE; // Prend que le profil
      if (Inclus = FALSE) and (Profil <> TOB_Salarie.GetValeur(iPSA_PROFIL)) then Pris := TRUE; // on exclut le profil
    end;
  end;
  if (T1 <> nil) and (Pris = TRUE) then
  begin // Table dossier identifiee
    Period := T1.GetValue('PMI_NATUREINT');
    if TypeNature = 'VAL' then // Cas Simple recherche par rapport � Coeff,Indice,Niveau,Qualification
    begin
      if TypeVar = 'COE' then Champ := TOB_Salarie.GetValeur(iPSA_COEFFICIENT)
      else if TypeVar = 'IND' then Champ := TOB_Salarie.GetValeur(iPSA_INDICE)
      else if TypeVar = 'NIV' then Champ := TOB_Salarie.GetValeur(iPSA_NIVEAU)
      else if TypeVar = 'QUA' then Champ := TOB_Salarie.GetValeur(iPSA_QUALIFICATION);
      if Champ <> '' then ; //Result:=ValTableDossier (TypeVar,Champ,TOB_Salarie.GetValeur (iPSA_CONVENTION),T1);  // Recherche par bornage de la valeur
    end
    else
    begin // Autre cas : table anciennet�, age ou Miminum conventionnel
      if (TypeVar = 'DIV') then
      begin
        if Period = 'COE' then Champ := TOB_Salarie.GetValeur(iPSA_COEFFICIENT)
        else if Period = 'IND' then Champ := TOB_Salarie.GetValeur(iPSA_INDICE)
        else if Period = 'NIV' then Champ := TOB_Salarie.GetValeur(iPSA_NIVEAU)
        else if Period = 'QUA' then Champ := TOB_Salarie.GetValeur(iPSA_QUALIFICATION);
      end;
      if (TypeVar = 'DIW') then
      begin
        zz := Copy(Period, 1, 2);
        if (zz <> 'ET') and (zz <> 'ST') then Ind := Copy(Period, 3, 1)
        else Ind := '';
        if IsNumeric (ind) then ii := NumChampTobS(zz, StrToInt(Ind)); // PT125 rajout du test si numerique
        if zz = 'OR' then Champ := TOB_Salarie.GetValeur(ii)
        else if zz = 'TC' then Champ := TOB_Salarie.GetValeur(ii)
        else if zz = 'DT' then Champ := DateToStr(TOB_Salarie.GetValeur(ii))
        else if Period = 'ETB' then Champ := TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT)
        else if Period = 'STA' then Champ := TOB_Salarie.GetValeur(iPSA_CODESTAT);
      end;

      if (TypeVar = 'AGE') or (TypeVar = 'ANC') then
      begin
        if (TypeVar = 'AGE') then
        begin // PT123 Modif Num�ro des 2 variables - rajout 0
          if Period = 'MOI' then AgeAnc := ValVariable('0008', DateDebut, DateFin, TOB_RUB)
          else if Period = 'ANN' then AgeAnc := ValVariable('0009', DateDebut, DateFin, TOB_RUB)
          else if Period = 'JOU' then AgeAnc := DateFin - TOB_Salarie.GetValeur(iPSA_DATENAISSANCE);
        end;
        if (TypeVar = 'ANC') then
        begin
          if Period = 'MOI' then AgeAnc := ValVariable('0012', DateDebut, DateFin, TOB_RUB)
          else if Period = 'ANN' then AgeAnc := ValVariable('0011', DateDebut, DateFin, TOB_RUB)
          else if Period = 'JOU' then AgeAnc := ValVariable('0010', DateDebut, DateFin, TOB_RUB);
        end;
        Result := RendValeurTable(StrfMontant(AgeAnc, 15, 0, '', TRUE), TypeVar, TDossier, T1.GetValue('PMI_CONVENTION'), T1.GetValue('PMI_SENSINT'),
          T1.GetValue('PMI_NATURERESULT'), DateDebut, DateFin, TOB_RUB);
      end // Fin cas Age ou Anciennet�
      else // Cas table Minimum conventionnel
      begin
        Result := RendValeurTable(TDossier, TypeVar, Champ, T1.GetValue('PMI_CONVENTION'), T1.GetValue('PMI_SENSINT'), T1.GetValue('PMI_NATURERESULT'), DateDebut, DateFin,
          TOB_RUB, Period);
      end; // Cas table Minimum conventionnel
    end; // fin si table de type INT(ervalle)
  end; // fin si table dossier identifiee
end;
{ Fonction qui va recherche la valeur dans la table (Coeff, Qualif, Indice, Niveau)
La TOB T1 contient les donn�es de la table des  Coeff dans laquelle on veut trouver la valeur
dans la TOB TOB_DetailMin qui contient le d�tail des it�rations des Coeffs dans l'exemple.
}

function ValTableDossier(TypeVar, Champ, Convent: string; T1: TOB): Double; // Valorisation d'une table
var
  TDetail: TOB;
begin
  result := 0;
  TDetail := TOB_DetailMin.FindFirst(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, Champ, Convent], FALSE); // $$$$
  if TDetail = nil then
    TDetail := TOB_DetailMin.FindFirst(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, Champ, '000'], FALSE); // $$$$
  if TDetail <> nil then ;
end;
{ Fonction qui va recherche dans la TOB detail le champ resultat
AgeAnc Contient la valeur du code � tester
Champ le code de la table sur laquelle on va faire des tests
TypeVar la nature de la table
Conv la conventionj collective
Sens le sens des tests � mettre en oeuvre
La fonction rend une chaine de caracteres car le resultat peut exprimer une autre table, un montant
ou un taux  ou une variable ...
PT72  : 05/02/2003 PH V595 Traitement des tables dossiers en string au lieu d'integer
        revu la fonction sur les tests, cast
PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas ==> Modif la fonction
}

function RendValeurTable(const AgeAnc: string; const TypeVar, Champ, Conv, Sens, NatureRes: string; const DateDebut, DateFin: TDateTime; TOB_RUB: TOB; Period: string = ''):
  Double;
var
  TTrouve: TOB;
  // PT72  : 05/02/2003 PH V595 Traitement des tables dossiers en string au lieu d'integer
  NombreLu, NbreRecu: string;
  ValeurLue, Convent: string;
  Lu, Recu: TDateTime;
begin
  ValeurLue := '';
  if Conv = '' then Convent := '000' // valeur par d�faut quand il n'y a pas de convention renseign�e
  else Convent := Conv;
  if (TypeVar <> 'DIV') and (TypeVar <> 'DIW') then NbreRecu := AgeAnc
  else NbreRecu := Champ;
  ValeurLue := '';
  if (TypeVar <> 'DIV') and (TypeVar <> 'DIW') then
    TTrouve := TOB_DetailMin.FindFirst(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, Champ, Convent], FALSE) // $$$$
  else TTrouve := TOB_DetailMin.FindFirst(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, AgeAnc, Convent], FALSE); // $$$$

  while TTrouve <> nil do
  begin
    // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
    if (TypeVar = 'DIV') or (TypeVar = 'DIW') then
    begin
      if (Sens = '=') and ((TTrouve.GetValue('PCP_NBRE')) = NbreRecu) and (Copy(Period, 1, 2) <> 'DT') then
      begin
        ValeurLue := TTrouve.GetValue('PCP_TAUX');
        break;
      end;
      if (Sens = '=') and (Copy(Period, 1, 2) = 'DT') then
      begin
        Recu := StrToDAte(TTrouve.GetValue('PCP_NBRE'));
        Lu := StrToDate(NbreRecu);
        if (Lu = Recu) then
        begin
          ValeurLue := TTrouve.GetValue('PCP_TAUX');
          break;
        end;
      end;

      if TestSensTable(TTrouve.GetValue('PCP_NBRE'), NbreRecu, Sens, Period) = TRUE then
      begin
        ValeurLue := TTrouve.GetValue('PCP_TAUX');
        if (Sens = '<') or (Sens = '<=') then break;
      end;
    end
    else
    begin
      NombreLu := TTrouve.GetValue('PCP_NBRE');
      if (Sens = '=') and (NombreLu = AgeAnc) then
      begin
        ValeurLue := TTrouve.GetValue('PCP_TAUX');
        break;
      end;
      if TestSensTable(NombreLu, AgeAnc, Sens) = TRUE then // inversion du sens pour les tables apprentis
      begin
        ValeurLue := TTrouve.GetValue('PCP_TAUX');
        if (Sens = '<') or (Sens = '<=') then break;
      end;
    end;
    // PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
    if (TypeVar <> 'DIV') and (TypeVar <> 'DIW') then
      TTrouve := TOB_DetailMin.FindNext(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, Champ, Convent], FALSE) // $$$$
    else TTrouve := TOB_DetailMin.FindNext(['PCP_NATURE', 'PCP_CODE', 'PCP_CONVENTION'], [TypeVar, AgeAnc, Convent], FALSE);
  end;
  if ValeurLue = '' then
  begin
    result := 0;
    exit;
  end; // Anomalie n'a pas trouv� rend 0
  if NatureRes = 'MON' then result := Valeur(ValeurLue)
  else if NatureRes = 'VAR' then result := ValVariable(ValeurLue, DateDebut, DateFin, TOB_RUB)
    // PT73  : 05/02/2003 PH V595 Tables dossier g�rent aussi une �l�ment national comme retour
  else if NatureRes = 'ELT' then result := ValEltNat(ValeurLue, DateFin)
  else result := ValVarTable(NatureRes, ValeurLue, DateDebut, DateFin, TOB_Rub);

end;
{ Fonction de test et de bornage en recherchent dans la TOB detail
cette fonction a uniquement pour but de dire si le test est vrai ou faux en fonction du sens
indiqu� dans la table
PT74  : 06/02/2003 PH V595 Nouvelle nature DIW pour traiter nouveaux cas
         Test sur des dates
}

function TestSensTable(AgeAnc, NombreLu: Variant; Sens: string; Period: string = ''): Boolean;
var
  Lu, Recu: TDateTime;
  PrefZero: string;
begin
  result := FALSE;
  if Copy(Period, 1, 2) = 'DT' then // Cas de test sur une date
  begin
    Lu := StrToDate(NombreLu);
    Recu := StrToDate(AgeAnc);
    if Sens = '<' then if lu < Recu then result := TRUE;
    if Sens = '<=' then if Lu <= Recu then result := TRUE;
    if Sens = '>' then if Lu > Recu then result := TRUE;
    if Sens = '>=' then if Lu >= Recu then result := TRUE;
  end
  else
  begin
    { DEB PT79-1 Dans le cas de valeur numerique, on transtype en alphanumerique
    sur la longueur du code le plus long }
    if (IsNumeric(AgeAnc)) and (Isnumeric(NombreLu)) then
    begin
      if Length(AgeAnc) > Length(NombreLu) then
      begin
        PrefZero := StringOfChar('0', Length(AgeAnc) - Length(NombreLu));
        NombreLu := PrefZero + NombreLu;
      end
      else
        if Length(AgeAnc) < Length(NombreLu) then
      begin
        PrefZero := StringOfChar('0', Length(NombreLu) - Length(AgeAnc));
        AgeAnc := PrefZero + AgeAnc;
      end;
    end; { FIN PT79-1 }
    if Sens = '<' then if NombreLu < AgeAnc then result := TRUE;
    if Sens = '<=' then if NombreLu <= AgeAnc then result := TRUE;
    if Sens = '>' then if NombreLu > AgeAnc then result := TRUE;
    if Sens = '>=' then if NombreLu >= AgeAnc then result := TRUE;
  end;
end;

function ValBase(const Rubrique: string): TRendRub;
var
  T_Base: TOB;
  RendRub: TRendRub; // variable contenant le record retourn� par la fonction
begin
  with RendRub do
  begin
    MontRem := 0;
    BasRem := 0;
    TauxRem := 0;
    CoeffRem := 0;
    BasCot := 0;
    TSal := 0;
    MSal := 0;
    TPat := 0;
    MPat := 0;
    Plfd1 := 0;
    Plfd2 := 0;
    Plfd3 := 0;
    Tr1 := 0;
    Tr2 := 0;
    Tr3 := 0;
    Base := 0;
    if TOB_HistoBasesCot <> nil then
    begin
      T_Base := TOB_HistoBasesCot.FindFirst(['PHB_RUBRIQUE'], [Rubrique], TRUE); // $$$$
      if T_Base <> nil then
      begin
        Plfd1 := T_Base.GetValue('P1');
        Tr1 := T_Base.GetValue('T1');
        Tr2 := T_Base.GetValue('T2');
        Tr3 := T_Base.GetValue('T3');
        Base := T_Base.GetValue('BC');
        Plfd2 := T_Base.GetValue('P2');
        Plfd3 := T_Base.GetValue('P3');
      end;
    end;
  end;
  result := RendRub;
end;

procedure ChargeBasesSal(const Salarie, Etab: string; DateD, DateF: TDateTime);
var
  st: string;
  Q: TQUERY;
  T1: TOB;
  DatD, DatF: TDateTime; // Date Debut et fin exercice
begin
  if TOB_HistoBasesCot <> nil then TOB_HistoBasesCot.Free;
  T1 := TOB_ExerSocial.Detail[0];
  DatD := T1.GetValue('PEX_DATEDEBUT');
  DatF := DateD - 1;
  if DatF < DatD then DatF := DatD; // Cas des reprises de bases en debut d'exercice social
  st := 'select PHB_RUBRIQUE,SUM(PHB_PLAFOND1) P1,SUM(PHB_TRANCHE1) T1,SUM(PHB_TRANCHE2) T2,SUM(PHB_TRANCHE3) T3,SUM(PHB_BASECOT) BC,' +
    'SUM(PHB_PLAFOND2) P2,SUM(PHB_PLAFOND3) P3'
    + ' from HISTOBULLETIN where PHB_NATURERUB="BAS" AND PHB_SALARIE="' + Salarie +
    '" AND PHB_DATEDEBUT >="' + USDateTime(DatD) + '" AND PHB_DATEFIN <="' + USDateTime(DatF) + '"'
    + 'group by PHB_RUBRIQUE';
  TOB_HistoBasesCot := TOB.Create('BASES HISTOBULLETIN', nil, -1);
  Q := OpenSql(st, TRUE);
  if not Q.EOF then
  begin
    TOB_HistoBasesCot.LoadDetailDB('BASES HISTOBULLETIN', '', '', Q, False);
  end;
  Ferme(Q);

end;
// Procedur appel�es en click droit

procedure Appellesalaries;
begin
  AglLanceFiche('PAY', 'SALARIE_MUL', '', '', '');
end;

procedure AppelleCotisations;
begin
  AglLanceFiche('PAY', 'COTISATION_MUL', '', '', '');
  ChargeCotisations;
end;

procedure AppelleVariables;
begin
  AglLanceFiche('PAY', 'VARIABLE_MUL', '', '', '');
end;

procedure AppelleEtablissements;
begin
  AglLanceFiche('PAY', 'ETABLISSEMENT', '', '', '');
end;

procedure AppelleDossier;
begin
{$IFNDEF EAGLCLIENT}
  ParamSociete(FALSE, '', 'SCO_PGPARAMETRES;SCO_PGCARACTERISTIQUES;SCO_PGCOMPTABILITE;SCO_PGDADS;SCO_PGPREFERENCES;SCO_COORDONNEES', '', nil, nil, nil, nil, 0);
{$ENDIF}
end;

procedure AppelleRemunerations;
begin
  AglLanceFiche('PAY', 'REMUNERATION_MUL', '', '', '');
end;

procedure AppelleCumuls;
begin
  AglLanceFiche('PAY', 'CUMUL', '', '', '');
end;

procedure AppelleProfils;
begin
  AglLanceFiche('PAY', 'PROFIL_MUL', '', '', '');
end;

procedure AppelleTablesdossier;
begin
  AglLanceFiche('PAY', 'COEFFICIENT_MUL', 'PMI_TYPENATURE=INT', '', '');
end;

procedure SuppCotExclus(const ThemeExclus: string; TPE: TOB);
var
  T, T_Cot: TOB;
  Nat, Rub, Them: string;
begin
  Nat := 'COT';
  if ThemeExclus = '' then exit; // si pas de theme alors on sort
  T := TPE.FindFirst(['PHB_NATURERUB'], [Nat], TRUE);
  while T <> nil do
  begin
    Rub := T.GetValue('PHB_RUBRIQUE');
    T_Cot := TOB_Cotisations.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [Rub, Nat], FALSE); // $$$$
    if T_Cot <> nil then // Si Cotisation trouvee
    begin
      Them := T_Cot.GetValue('PCT_THEMECOT');
      if Them = ThemeExclus then T.Free; // suppression de l'objet dans la TOB si theme identique
    end;
    T := TPE.FindNext(['PHB_NATURERUB'], [Nat], TRUE);
  end;
end;
{ Fonction qui rend les dates de la paie pr�c�dante
}

procedure RendDatePaiePrec(var Date1, Date2: TDateTime; const DD, DF: TDateTime);
var
  st: string;
  Q: TQuery;
  ZDate: TDateTime;
  TPR: TOB;
begin
  TOB_PaiePrecedente := TOB.Create('Le Bulletin de la Paie Pr�c�dante', nil, -1);
  st := 'SELECT PPU_DATEDEBUT,PPU_DATEFIN,PPU_ETABLISSEMENT,PPU_SALARIE FROM PAIEENCOURS WHERE PPU_ETABLISSEMENT="' + TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT) +
    '" AND PPU_SALARIE="' + TOB_Salarie.GetValeur(iPSA_SALARIE) + '" ORDER BY PPU_DATEDEBUT,PPU_DATEFIN';
  Q := OpenSql(st, TRUE);
  TOB_PaiePrecedente.LoadDetailDB('PAIEENCOURS', '', '', Q, FALSE);
  TPR := TOB_PaiePrecedente.FindFirst(['PPU_ETABLISSEMENT', 'PPU_SALARIE'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT), TOB_Salarie.GetValeur(iPSA_SALARIE)], TRUE); // $$$$
  ferme(Q);
  Date1 := 0;
  Date2 := 0;
  while TPR <> nil do
  begin // recup des dates de la deniere paie
    ZDate := TDateTime(TPR.GetValue('PPU_DATEFIN'));
    if (Zdate < Date2) and (Date2 <> 0) then break; // cas o� il y a un bulletin post�rieur alors on s'arrete
    if ZDate >= DF then break;
    Date1 := TDateTime(TPR.GetValue('PPU_DATEDEBUT'));
    Date2 := TDateTime(TPR.GetValue('PPU_DATEFIN'));
    TPR := TOB_PaiePrecedente.FindNext(['PPU_ETABLISSEMENT', 'PPU_SALARIE'], [TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT), TOB_Salarie.GetValeur(iPSA_SALARIE)], TRUE);
  end;
  TOB_PaiePrecedente.Free;
  TOB_PaiePrecedente := nil;
end;

{ Fonction qui recherche si on va faire une division par 0
Alors remplace 0 par 1
}

procedure EvalueChaineDiv0(var St: string);
const
  Tableau: array[1..10] of string = (
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

var
  Pos1, Pos2, Pos3: Integer;
  St1: string;
begin
  St1 := '/0';
  Pos1 := Pos(St1, St);
  // PT80  : 11/06/2003 PH V_421 Modification fct de contr�le division par 0 Pour tester si 0.xxx au lieu de O
  if (Pos1 <> 0) and (St[Pos1 + 2] <> '.') and (St[Pos1 + 2] <> ',') then
  begin
    St[Pos1 + 1] := '1';
    for Pos2 := Pos1 - 1 downto 1 do
    begin
      St1 := Copy(St, Pos2, 1);
      if (St1 >= '0') and (St1 <= '9') then St[Pos2] := '0'
      else break;
    end;
  end;
  Pos3 := Length(St);
  St1 := ')0';
  Pos1 := Pos(St1, St);
  if Pos1 = 0 then exit;
  for Pos2 := Pos1 to Pos3 do
  begin
    St1 := Copy(St, 1, Pos1); // recup de la chaine jusqu'� )0 inclus ) exclus 0
    if St[Pos1 + 3] <> '0' then St1 := St1 + Copy(St, Pos1 + 3, Pos3) // on exclus le 0 et la ) qui suit
    else St1 := St1 + Copy(St, Pos1 + 2, Pos3); // On exclus simplement le 0 car il est suivi normalement de 0
    St := St1;
    if (Pos(')0', St) > 0) then EvalueChaineDiv0(St)
    else break;
  end;
end;

{ int�gration des mvt cong� dans le bulletin
L'objectif est de g�n�rer les lignes de libell�
et de calculer toutes les variables pr�d�finies utilis�es dans le moteur de paie
Recherche du type de profil defini au niveau du salari� et remonte au niveau de etablissement le cas �ch�ant
}

procedure IntegrePaye(Tob_Rub, Tob_prisCP: tob; const Etab, Salarie: string; const DateD, DateF: TDateTime; const Typecp: string; ManqueAcquis: Boolean = False);
var
  TR, TZ, T, TPR, TP, TL, TOB_libelle, THH, T_ECP: TOB;
  i, j: Integer;
  Rub, TypProfil, Profil : string;
  NbPris, Absence, Indemnite, NBHPris: double;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  Rub := '';
  Profil := '';
  TypProfil := '';
  TOB_Libelle := nil;
  NbPris := 0;
  NBHPris := 0;
  Absence := 0;
  Indemnite := 0;
  if Tob_prisCP = nil then
  begin //mvi en cas de suppression mvt cp via bulletin, passer l� pour virer lignes de bulletin
  end;
  { DEB PT90 }
  Profil := PGRecupereProfilCge(Etab);
  { Integre dans function PGRecupereProfilCge
   T_ECP:=TOB_Etablissement.findfirst(['ETB_ETABLISSEMENT'],[Etab],True);
   TypProfil:=Tob_Salarie.GetValeur (iPSA_TYPPROFILCGE);   // Type Profil : Idem Etab ou Personnalis�
   if (TypProfil='ETB') OR (TypProfil='') then
     begin
     if T_ECP <> NIL then Profil:=T_ECP.GetValue('ETB_PROFILCGE')
     end
   else Profil:=Tob_Salarie.GetValeur (iPSA_PROFILCGE);}
   { FIN PT90 }
  TPR := TOB_ProfilPaies.FindFirst(['PPI_PROFIL'], [Profil], FALSE); // $$$$
  if TPR <> nil then
  begin
    i := 0;
    while i < TPR.Detail.Count do
    begin
      TZ := TPR.Detail[i]; // Recup 1ere rubrique du profil
      if TZ = nil then exit; // Cas improbable o� pas de rubrique dans le profil
      Rub := TZ.GetValue('PPM_RUBRIQUE'); // Recuperation de la 1ere Rubrique du Profil CP pour creer les lignes de libelle
      // on relit la rubrique pour voir son param�trage
      TR := TOB_Rem.findfirst(['PRM_RUBRIQUE'], [Rub], False);
      if TR <> nil then
        if IsOkType(TR, typecp) then break;
      i := i + 1;
    end;
  end; //PT90 Calcul variable m�me si int�gration rubrique sans profil affect�
  NbPris := 0;
  Absence := 0;
  Indemnite := 0;
  NBHPris := 0;
  // a voir mvi 16-01 JCPSOLDE := 0;  CPMTABSSOL := 0; CPMTINDABSSOL := 0;
  TOB_Libelle := TOB.create('Les libelles des cp', nil, -1);
  if Tob_prisCP <> nil then
  begin
    TP := Tob_prisCP.findfirst([''], [''], True);
    while tp <> nil do
    begin
      if TP.getvalue('PCN_MVTDUPLIQUE') <> 'X' then
      begin
        NbPris := NbPris + TP.getvalue('PCN_JOURS');
        NBHPris := NBHPris + TP.getvalue('PCN_HEURES');
        if TP.GetValue('PCN_MODIFABSENCE') = 'X' then
          Absence := Absence + TP.GetValue('PCN_ABSENCEMANU')
        else
          Absence := Absence + TP.GetValue('PCN_ABSENCE');
        if TP.Getvalue('PCN_MODIFVALO') <> 'X' then
        begin
          Indemnite := Indemnite + TP.GetValue('PCN_VALORETENUE');
          TP.putvalue('PCN_BASE', TP.GetValue('PCN_VALORETENUE'));
        end
        else
        begin
          Indemnite := Indemnite + TP.GetValue('PCN_VALOMANUELLE');
          TP.putvalue('PCN_BASE', TP.GetValue('PCN_VALOMANUELLE'))
        end;
        begin // Constitution de la TOB des Libell�s
          TL := TOB.create('Une ligne de libelle', TOB_Libelle, -1);
          TL.AddChampSup('LIBELLE', FALSE);
          TL.PutValue('LIBELLE', TP.Getvalue('PCN_LIBELLE'));
        end;
      end;
      if Typecp = 'SLD' then
      begin
        PositionnePaye(tP, datef);
        TP.putvalue('PCN_DATEFIN', datef);
      end;
      TP := Tob_prisCP.findnext([''], [''], True);
    end;
  end;
{$IFDEF ENCOURS}
  { DEB PT88 }
  if (ManqueAcquis) and (TOB_Libelle <> nil) and (JCPPAYESPOSES - NbPris > 0) then
  begin
    TL := TOB.create('Une ligne de libelle', TOB_Libelle, -1);
    TL.AddChampSup('LIBELLE', FALSE);
    TL.PutValue('LIBELLE', FloatToStr(JCPPAYESPOSES - NbPris) + ' j. CP non int�gr� manque acquis');
  end;
  { FIN PT88 }
{$ENDIF}

  // mv on vire les libelles de la tob_rub cr��s pr�c�demment
 {PT69-1 Modification
 recherche des lignes de commentaire que sur la nature non sur les dates, etab et salari�
  T := Tob_Rub.FindFirst(['PHB_NATURERUB','PHB_DATEDEBUT','PHB_DATEFIN','PHB_ETABLISSEMENT','PHB_SALARIE'],
                          ['AAA',DateD,DateF,Etab,CodSal],TRUE);}
  T := Tob_Rub.FindFirst(['PHB_NATURERUB'], ['AAA'], TRUE);
  while (T <> nil) and (Rub <> '') do //PT90-1 Gestion libell� si rubrique existant
  begin
    if (copy(T.GetValue('PHB_RUBRIQUE'), 1, length(Rub) + 1) = Rub + '.') then
      if T.GetValue('PHB_ORIGINELIGNE') = 'CPA' then T.free; { PT83-4 }
    T := Tob_Rub.FindNext(['PHB_NATURERUB'], ['AAA'], TRUE);
  end;

  if (TOB_Libelle <> nil) and (Rub <> '') then //PT90-1 Gestion libell� si rubrique existant
  begin
    i := 1;
    for J := 0 to TOB_Libelle.Detail.count - 1 do
    begin
      TL := TOB_Libelle.Detail[J];
      THH := TOB.create('HISTOBULLETIN', Tob_Rub, -1);
      THH.PutValue('PHB_RUBRIQUE', Rub + '.' + IntToStr(i));
      THH.PutValue('PHB_NATURERUB', 'AAA');
      THH.PutValue('PHB_DATEDEBUT', DateD);
      THH.PutValue('PHB_DATEFIN', DateF);
      THH.PutValue('PHB_ETABLISSEMENT', Etab);
      THH.PutValue('PHB_SALARIE', CodSal);
      i := i + 1; // incrementation automatique de l'indice du commentaire @@@ voir pour
      THH.PutValue('PHB_BASEREM', 0);
      THH.PutValue('PHB_TAUXREM', 0);
      THH.PutValue('PHB_COEFFREM', 0);
      THH.PutValue('PHB_MTREM', 0);
      THH.PutValue('PHB_CONSERVATION', 'BUL');
      { PT83-4 Ajout du type CPA pour distinguer les lignes de commentaire calcul�
      de celle ins�r� par l'utilisateur }
      THH.PutValue('PHB_ORIGINELIGNE', 'CPA');
      THH.PutValue('PHB_IMPRIMABLE', 'X');
      THH.PutValue('PHB_TRAVAILN2', Tob_Salarie.GetValeur(iPSA_TRAVAILN2));
      THH.PutValue('PHB_TRAVAILN3', Tob_Salarie.GetValeur(iPSA_TRAVAILN3));
      THH.PutValue('PHB_TRAVAILN4', Tob_Salarie.GetValeur(iPSA_TRAVAILN4));
      THH.PutValue('PHB_TRAVAILN1', Tob_Salarie.GetValeur(iPSA_TRAVAILN1));
      THH.PutValue('PHB_CODESTAT', Tob_Salarie.GetValeur(iPSA_CODESTAT));
      THH.PutValue('PHB_LIBREPCMB1', Tob_Salarie.GetValeur(iPSA_LIBREPCMB1));
      THH.PutValue('PHB_LIBREPCMB2', Tob_Salarie.GetValeur(iPSA_LIBREPCMB2));
      THH.PutValue('PHB_LIBREPCMB3', Tob_Salarie.GetValeur(iPSA_LIBREPCMB3));
      THH.PutValue('PHB_LIBREPCMB4', Tob_Salarie.GetValeur(iPSA_LIBREPCMB4));
      THH.PutValue('PHB_CONFIDENTIEL', Tob_Salarie.GetValeur(iPSA_CONFIDENTIEL));
      if TR <> nil then THH.PutValue('PHB_ORDREETAT', TR.GetValue('PRM_ORDREETAT'));
      THH.PutValue('PHB_LIBELLE', TL.GetValue('LIBELLE'));
    end;
  end;
  if Typecp = 'PRI' then
  begin
    JCPPRIS := NbPris;
    HCPPRIS := NBHPris;
    CPMTABS := Absence;
    CPMTINDABS := Indemnite;
    JCPPAYES := NbPris;
    HCPPAYES := NBHPris;
    CPMTABS := Absence;
    CPMTINDABS := Indemnite; {PT6}
  end;
  if Typecp = 'SLD' then
  begin
    JCPSOLDE := NbPris;
    HCPASOLDER := NBHPris;
    CPMTABSSOL := Absence;
    CPMTINDABSSOL := Indemnite;
  end;
  //  end;

  if TOB_Libelle <> nil then TOB_Libelle.Free;
  TOB_Libelle := nil;
end;
{ DEB PT90 Function renvoyant le profil cong�s pay�s niveau salari� ou �tablissement }

function PGRecupereProfilCge(const Etab: string): string;
var
  T_ECP: Tob;
  TypProfil: string;
begin
  Result := '';
  T_ECP := TOB_Etablissement.findfirst(['ETB_ETABLISSEMENT'], [Etab], True);
  TypProfil := Tob_Salarie.GetValeur(iPSA_TYPPROFILCGE); // Type Profil : Idem Etab ou Personnalis�
  if (TypProfil = 'ETB') or (TypProfil = '') then
  begin
    if T_ECP <> nil then Result := T_ECP.GetValue('ETB_PROFILCGE')
  end
  else Result := Tob_Salarie.GetValeur(iPSA_PROFILCGE);
end;
{ FIN PT90 }

function IsOkType(TR: tob; const typecp: string): boolean;
const
  CP: array[0..6] of PChar = ('0040', '0041', '0043', '0044', '0045', '0047', '0048');
  SLD: array[0..4] of PChar = ('0042', '0046', '0049', '0050', '0052');
var
  i: integer;
begin
  result := false;
  if typecp = 'PRI' then
    for i := 0 to 6 do
    begin
      if (((TR.GetValue('PRM_TYPEBASE') = '03') and (TR.getvalue('PRM_BASEREM') = CP[i])) or
        ((TR.GetValue('PRM_TYPETAUX') = '03') and (TR.getvalue('PRM_TAUXREM') = CP[i])) or
        ((TR.GetValue('PRM_TYPECOEFF') = '03') and (TR.getvalue('PRM_COEFFREM') = CP[i])) or
        ((TR.GetValue('PRM_TYPEMONTANT') = '03') and (TR.getvalue('PRM_MONTANT') = CP[i]))) then
      begin
        result := true;
        exit;
      end;
    end;


  if typecp = 'SLD' then
    for i := 0 to 4 do
    begin
      if (((TR.GetValue('PRM_TYPEBASE') = '03') and (TR.getvalue('PRM_BASEREM') = SLD[i])) or
        ((TR.GetValue('PRM_TYPETAUX') = '03') and (TR.getvalue('PRM_TAUXREM') = SLD[i])) or
        ((TR.GetValue('PRM_TYPECOEFF') = '03') and (TR.getvalue('PRM_COEFFREM') = SLD[i])) or
        ((TR.GetValue('PRM_TYPEMONTANT') = '03') and (TR.getvalue('PRM_MONTANT') = SLD[i]))) then
      begin
        result := true;
        exit;
      end;
    end;
end;
{PT-11 : Ajout ds declarations var Auto : Boolean;Var StMsgErr : String }

function SalIntegreCP(TOB_Sal, TOB_Rub, Tob_AcqEnCours: TOB; const DateD, DateF: TDateTime; const Auto: Boolean; var StMsgErr: string): tob; //PT7
var
  P5T_etab, TP, T1, T2: TOB;
  Etab, Salarie, st: string;
  Datesortie: TDateTime;
  Q: TQuery;
  PrisBul: double;
  ManqueAcquis: Boolean;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  result := nil;
  StMsgErr := '';
  ManqueAcquis := False; //PT88
  // Modif Ph Quand une tob est free, il faut la remettre � NIL obligatoirement
  if notVide(TOB_Pris, true) then
  begin
    TOB_Pris.free;
    TOB_Pris := nil;
  end;
  if notVide(TOB_Acquis, true) then
  begin
    TOB_Acquis.free;
    TOB_Acquis := nil;
  end;
  if notVide(TOB_Solde, true) then
  begin
    TOB_Solde.free;
    TOB_Solde := nil;
  end;
  Etab := string(TOB_Sal.GetValeur(iPSA_ETABLISSEMENT));
  Salarie := TOB_Sal.GetValeur(iPSA_SALARIE);
  P5T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [Etab], True);
  Tob_Pris := Tob.create('CONGES PRIS', nil, -1);
  Tob_Acquis := Tob.create('CONGES ACQUIS', nil, -1);
  Tob_Solde := Tob.create('SOLDE CONGES', nil, -1);

  // alimentation de la tob des acquis
  Tob_Acquis := Tob.create('CONGES ACQUIS', nil, -1);
  st := 'SELECT * from ABSENCESALARIE ' +
    'WHERE PCN_SALARIE = "' + Tob_SAL.GetValeur(iPSA_SALARIE) + '" ' +
    'AND PCN_TYPEMVT="CPA" ' + //PT54 Ajout PCN_TYPEMVT="CPA"
  'AND PCN_CODETAPE <> "C" AND PCN_CODETAPE <> "S" AND ' +
    // mv pour arrondi  ' AND PCN_JOURS <> PCN_APAYES AND '+
  '( ( (PCN_TYPECONGE="ACQ" OR PCN_TYPECONGE="ACA" OR PCN_TYPECONGE="ACS")  ' +
    ' AND PCN_DATEFIN <> "' + usdatetime(Datef) + '")' + // ajout mv 6-11-00
  ' OR PCN_TYPECONGE="ARR" OR PCN_TYPECONGE="REP" OR PCN_TYPECONGE="REB" OR ' +
    ' ( ((PCN_TYPECONGE="AJU") OR (PCN_TYPECONGE="AJP") or(PCN_TYPECONGE="REL")) AND PCN_SENSABS = "+"))' +
    ' ORDER BY PCN_DATEVALIDITE, PCN_TYPECONGE';
  Q := OpenSql(st, TRUE);
  if not (Q.eof) then // pas de cong�s acquis
  begin
    Tob_Acquis.LoadDetailDB('ABSENCESALARIE', '', '', Q, False);
    AcquisMaj := false;
  end;
  Ferme(Q);
  //DEB PT17  Duplication de la tob des acquis pour traitement de prise de CP
  if Tob_AcqEnCours <> nil then
  begin
    T1 := Tob_AcqEnCours.FindFirst([''], [''], False);
    while T1 <> nil do
    begin
      T1.PutValue('PCN_APAYES', 0);
      T1.PutValue('PCN_DATEPAIEMENT', 0);
      T2 := Tob.create('CP ACQUIS', Tob_Acquis, -1);
      T2.Dupliquer(T1, True, True, True);
      T1 := Tob_AcqEnCours.FindNext([''], [''], False);
    end;
  end;
  //FIN PT17
  if RecupereCongespris(Tob_Pris, Tob_Sal, DateF) then
  begin
    IntegreSolde(Tob_solde, Tob_pris);
    Suivant := suivant + 1; //PT17 Positionne l'ordre du prochain mvt � cr�er
    if not CalculValoCP(Tob_Pris, Tob_Acquis, P5T_Etab, TOB_SAL, ChpEntete.Ouvres, ChpEntete.Ouvrables, DateD, DateF, suivant, 'PRI', Tob_SAL.GetValeur(iPSA_SALARIE)) then
    begin
      ManqueAcquis := True; //PT88
      if Auto then {DEB PT-11}
        StMsgErr := '1 ou plusieurs mouvements de cong�s n''ont pu �tre pay�s par manque d''acquis pour le salari� ' + Salarie + ' ' + TOB_Sal.GetValeur(iPSA_LIBELLE) + ' ' +
          TOB_Sal.GetValeur(iPSA_PRENOM)
      else {FIN PT-11}
        HShowMessage('5;Calcul bulletin :;1 ou plusieurs mouvements de cong�s n''ont pu �tre pay�s par manque d''acquis;E;O;O;O;;;', '', '');
    end;
  end
  else Tob_Pris := nil;
  //DEB PT17  R�affectation des modifs apport�s � la tob des acquis en cours
  if Tob_AcqEnCours <> nil then
  begin
    T1 := Tob_AcqEnCours.FindFirst([''], [''], False);
    while T1 <> nil do
    begin
      T2 := Tob_Acquis.FindFirst([''], [''], False);
      while T2 <> nil do
      begin
        if T1.GetValue('PCN_ORDRE') = T2.GetValue('PCN_ORDRE') then
        begin
          JCPACQUISACONSOMME := JCPACQUISACONSOMME + T2.GetValue('PCN_APAYES');
          T1.free;
          T1 := Tob.Create('Cp Acq', Tob_AcqEnCours, -1);
          T1.Dupliquer(T2, True, True, True);
          T2.free;
        end;
        T2 := Tob_Acquis.FindNext([''], [''], False);
      end;
      T1 := Tob_AcqEnCours.FindNext([''], [''], False);
    end;
  end;
  //FIN PT17
  PAYECOUR := 0;
  // Est ce que le salari� a une date sortie renseign�e et dans le bulletin ?
  DateSortie := Tob_Sal.GetValeur(iPSA_DATESORTIE);
  if ((DateSortie >= DateD) and (Datesortie <= DateF)) then
  begin
    { DEB PT90 }
    if (PGRecupereProfilCge(Etab) = '') then
    begin
      if Auto then
        StMsgErr := 'G�n�ration du mouvement de solde impossible. Vous devez g�rer un profil cong�s pay�s pour le salari� ' + Salarie + ' ' + TOB_Sal.GetValeur(iPSA_LIBELLE) + ' '
          + TOB_Sal.GetValeur(iPSA_PRENOM)
      else
        PgiBox('Vous devez g�rer un profil cong�s pay�s pour le salari� ' + Salarie + ' ' + TOB_Sal.GetValeur(iPSA_LIBELLE) + ' ' + TOB_Sal.GetValeur(iPSA_PRENOM),
          'G�n�ration du mouvement de solde impossible');
    end
      { FIN PT90 }
    else
    begin
      if Tob_pris <> nil then
      begin
        TP := Tob_pris.findfirst([''], [''], True);
        while tp <> nil do
        begin
          if TP.getvalue('PCN_MVTDUPLIQUE') <> 'X' then
            PrisBul := PrisBul + TP.getvalue('PCN_JOURS');
          TP := Tob_pris.findnext([''], [''], True);
        end;
      end;
      GenereSolde(Tob_sal, P5T_Etab, Tob_Pris, Tob_Acquis, Tob_Solde, dateF, DateD, suivant, JCPACQUIS, PrisBul, 'C');
      // SoldeAcquis(T_MvtAcquis,True); //PT17 Cas SLD on solde les acquis en cours au cas ou modifi�es
      //PT46 Mise en commentaire on solde en validation en fonction du Consomm� sur l'acquis en cour
      AjouteAcquiscourant(Tob_Acquis, Tob_sal, DateF, suivant);
    end;
  end;
  //      IntegrePaye(Tob_Rub, Tob_Solde,Etab,Salarie, DateD, DateF,'SLD' )  ;}

  IntegrePaye(Tob_Rub, Tob_Pris, Etab, Salarie, DateD, DateF, 'PRI', ManqueAcquis); //PT88 Ajout param�tre
  result := Tob_Pris;
end;

//modif mv 17/11/00

procedure SalEcritCP(var Tob_cppris: tob);
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  SupprimeMvtSolde(Tob_cppris);

  if Tob_cppris <> nil then
  begin
    TOB_cpPris.SetAllModifie(TRUE);
    TOB_cpPris.InsertOrUpdateDB(false);
  end;
  if T_MvtAcquis <> nil then //PT17 on met d'abord � jour la tob des acqs en cours
  begin //avant celle des acqs anterieurs
    T_MvtAcquis.SetAllModifie(TRUE);
    T_MvtAcquis.InsertorupdateDB(true);
  end;
  if TOB_Acquis <> nil then
  begin
    TOB_Acquis.SetAllModifie(TRUE);
    TOB_Acquis.InsertOrUpdateDB(true);
  end;
  if Tob_solde <> nil then
  begin
    Tob_Solde.SetAllModifie(TRUE);
    Tob_Solde.InsertOrUpdateDB(true);
  end;
  if Tob_AcquisAVirer <> nil then
  begin
    Tob_AcquisAVirer.deletedb(true);
  end;
  if T_MvtAcquisAVirer <> nil then
  begin
    T_MvtAcquisAVirer.deletedb(true);
    FreeAndNil(T_MvtAcquisAVirer); { PT97 13/05/2004 }
  end;
  {if T_MvtAcquis <> NIL then PT17 mise en commentaire maj au dessus
      begin
      T_MvtAcquis.SetAllModifie (TRUE);
      T_MvtAcquis.InsertorupdateDB(true);
      end;   }
end;

procedure LibereTobCP(var Tob_cppris: tob);
begin
  {if notVide(TOB_cpPris,true)        then TOB_cpPris.free;
  if notVide(TOB_Acquis,true)        then TOB_Acquis.free;
  if notVide(T_MvtAcquis,true)       then T_MvtAcquis.free;
  if notVide(Tob_Solde,true)         then Tob_Solde.free;
  if notVide(Tob_AcquisAVirer, true) then Tob_AcquisAVirer.free;
  if notVide(T_MvtAcquisAVirer, true)then T_MvtAcquisAVirer.free;}
  if TOB_cpPris <> nil then
  begin
    TOB_cpPris.free;
    TOB_cpPris := nil;
  end;
  if TOB_Acquis <> nil then
  begin
    TOB_Acquis.free;
    TOB_Acquis := nil;
  end;
  if T_MvtAcquis <> nil then
  begin
    T_MvtAcquis.free;
    T_MvtAcquis := nil;
  end;
  if Tob_Solde <> nil then
  begin
    Tob_Solde.free;
    Tob_Solde := nil;
  end;
  if Tob_AcquisAVirer <> nil then
  begin
    Tob_AcquisAVirer.free;
    Tob_AcquisAVirer := nil;
  end;
  if T_MvtAcquisAVirer <> nil then
  begin
    T_MvtAcquisAVirer.free;
    T_MvtAcquisAVirer := nil;
  end;
end;

procedure SalEcritAbs(var Tob_abs: tob);
begin
  if notVide(Tob_abs, true) then
  begin
    TOB_abs.SetAllModifie(TRUE);
    TOB_abs.InsertOrUpdateDB(false);
  end;
  exit;
end;
//DEB PT71

procedure LibereTobAbs;
begin
  if Tob_ABS <> nil then
  begin
    Tob_ABS.free;
    Tob_ABS := nil;
  end;
  HABSPRIS := 0;
  JABSPRIS := 0;
end;
//FIN PT71

procedure IntegreAbsenceDansPaye(Tob_Rub, Tob_ABS, Salarie: tob; const DateD, DateF: tdatetime; const Action: string);
var
  t: tob;
  TypeAbs, TypeAbsP, Aliment, Arub, Natrub, profil, ArubP: string;
  CompteurJ, CompteurH, Compteur: double;
  i: integer;
  GereComm, Heure, Premier: boolean;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  if TOB_Abs = nil then exit;
  t := Tob_Abs.findfirst([''], [''], false);
  if t = nil then exit;
  TypeAbs := t.getvalue('PCN_TYPECONGE');
  TypeAbsP := TypeAbs;
  CompteurJ := 0;
  CompteurH := 0;
  Premier := true;
  i := 1;
  RechercheCarMotifAbsence(TypeAbs, profil, ARub, Aliment, GereComm, Heure);
  Arubp := Arub;
  if Profil = '' then Natrub := 'AAA' else
    Natrub := ChercheNatRub(Salarie, Tob_rub, Profil, Arub);
  ChargeProfil(Salarie, Tob_rub, Profil);
  //     if (Action = 'M') then
  EnleveCommAbsence(Salarie, Tob_rub, Arub, Natrub, DateD, Datef);
  while t <> nil do
  begin
    TypeAbs := t.getvalue('PCN_TYPECONGE');
    if TypeAbs <> TypeAbsP then
    begin
      if Heure then
        Compteur := CompteurH else Compteur := CompteurJ;
      if profil = '' then Natrub := 'AAA' else
        Natrub := ChercheNatRub(Salarie, Tob_rub, Profil, Arub);
      //d PT107 IJSS      IntegreRub(tob_rub, Salarie, typeAbsP, Aliment, DateD, DateF, Compteur, Natrub, ARub);
      IntegreRub(tob_rub, Salarie, typeAbsP, Aliment, DateD, DateF, Compteur, Natrub, ARub, False, False);
      // f PT107 IJSS
      CompteurJ := 0;
      CompteurH := 0;
      typeAbsP := TypeAbs;
      RechercheCarMotifAbsence(TypeAbs, profil, ARub, Aliment, GereComm, Heure);
      ChargeProfil(Salarie, Tob_rub, Profil);

      if Arub <> ArubP then
      begin
        //             if (Action = 'M') then
        EnleveCommAbsence(Salarie, Tob_rub, Arub, Natrub, DateD, Datef);
        i := 1;
        Arubp := Arub;
      end;
    end;

    CompteurJ := CompteurJ + T.GetValue('PCN_JOURS');
    CompteurH := CompteurH + T.GetValue('PCN_HEURES');
    RechercheCarMotifAbsence(TypeAbs, profil, ARub, Aliment, GereComm, Heure);
    if GereComm then
    begin
      Ecritlignecomm(Tob_rub, Salarie, t, i, DateD, Datef, ARub, Natrub);
    end;
    PositionnePaye(t, DateF);
    //        if GereComm and not premier then
    //           Ecritlignecomm(Tob_rub,Salarie,t,i,DateD,Datef,ARub,Natrub);
    t := Tob_Abs.findnext([''], [''], false);
    premier := false;
  end;
  // Ecriture du dernier
  if Heure then
    Compteur := CompteurH else
    Compteur := CompteurJ;
  //     if profil = '' then Natrub := 'AAA' else
  //          Natrub := ChercheNatRub( Salarie,Tob_rub,Profil,Arub);
// d PT107 IJSS  IntegreRub(tob_rub, Salarie, typeAbsP, ALiment, DateD, DateF, Compteur, Natrub, ARub);
  IntegreRub(tob_rub, Salarie, typeAbsP, ALiment, DateD, DateF, Compteur, Natrub, ARub, False, False);
  // f PT107 IJSS

end;

function ChercheNatRub(Salarie, TPE: TOB; const Profil, rub: string): string;
var
  TPP, TPR: TOB;
  ThemeRub, Rubrique, ThemeExclus: string;
  I: Integer;
begin
  result := '';
  if Profil = '' then exit;
  ThemeRub := '';
  ThemeExclus := '';
  TPP := TOB_ProfilPaies.FindFirst(['PPI_PROFIL'], [Profil], FALSE); // $$$$
  if TPP <> nil then
  begin
    ThemeExclus := TPP.GetValue('PPI_THEMECOT'); // theme des rubriques de cotisations � exclure
    if ThemeExclus <> '' then SuppCotExclus(ThemeExclus, TPE);
    for I := 0 to TPP.Detail.count - 1 do
    begin
      TPR := TPP.Detail[I];
      Rubrique := TPR.GetValue('PPM_RUBRIQUE');
      if Rub = Rubrique then
      begin
        result := TPR.getvalue('PPM_NATURERUB');
        exit;
      end;
    end;
  end;
end;

{
procedure SupprimeAbsenceDePaye(Tob_Rub, Tob_ABSTEMP,Salarie:tob;DateD, DateF:tdatetime) ;
var
t                        : tob;
TypeAbs,TypeAbsP,Aliment,Arub,Natrub,st : string;
GereComm           : boolean;
i                        : integer;
Q : TQuery;
begin

     if Tob_ABSTEMP = nil                 then exit;
     t := Tob_ABSTEMP.findfirst([''],[''],false);
     if t = nil                       then exit;
     TypeAbs    := t.getvalue('PCN_TYPECONGE');
     TypeAbsP   := TypeAbs;
     i := 1;
     TypeAbs  := t.getvalue('PCN_TYPECONGE');
     RechercheCarMotifAbsence(TypeAbs,Aliment,GereComm,Heure);
     st := 'SELECT * FROM PROFILRUB WHERE PPM_RUBRIQUE IN(SELECT PMA_RUBRIQUE FROM'+
       ' MOTIFABSENCE WHERE PMA_MOTIFABSENCE = "'+TypeAbs+'")';
     Q :=  Opensql(st, true);
     Q.first;
     if Q.eof then begin Arub := '';Natrub:='' end else
        begin
        ARub:= Q.findfield('PPM_RUBRIQUE').asstring;
        NatRub := Q.findfield('PPM_NATURERUB').asstring;
        end;
     ferme(Q);

     while t <> nil do
        begin
        TypeAbs  := t.getvalue('PCN_TYPECONGE');
        if GereComm then
           begin
           Ecritlignecomm(Tob_rub,Salarie,t,i,DateD,Datef,ARub);
           i := i+1;
           end;
        if TypeAbs <> TypeAbsP then
           begin
           IntegreRub(tob_rub,Salarie,typeAbsP,Aliment,DateD, DateF,Compteur,Natrub,ARub);
           typeAbsP  :=TypeAbs;
           i := 1;
           RechercheCarMotifAbsence(TypeAbs,Aliment,GereComm,Heure);
           end;
        PositionnePaye(t,DateF);
        t := Tob_ABSTEMP.findnext([''],[''],false);
        end;
     IntegreRub(tob_rub,Salarie,typeAbsP,ALiment,DateD, DateF,Compteur,Natrub,ARub);

end;
 }

procedure PositionnePaye(t: tob; const datef: tdatetime);
begin
  if T = nil then exit;
  T.putvalue('PCN_CODETAPE', 'P');
  T.putvalue('PCN_DATEPAIEMENT', datef);
end;

procedure AnnuleAbsenceBulletin(const CodeSalarie: string; const DateF: tdatetime);
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  Executesql('UPDATE ABSENCESALARIE SET PCN_DATEPAIEMENT = "' + usdatetime(0) + '", ' +
    'PCN_CODETAPE = "..." WHERE PCN_SALARIE="' + CodeSalarie + //PT23
    '" AND PCN_TYPEMVT = "ABS" AND PCN_SENSABS="-" AND  PCN_TYPECONGE <> "PRI" AND ' + //PT54 Ajout AND PCN_SENSABS="-"
    ' PCN_DATEPAIEMENT = "' + usdatetime(Datef) + '"');
end;

procedure EnleveCommAbsence(Salarie, Tob_rub: tob; const Arub, Natrub: string; const dated, datef: tdatetime);
var
  t: tob;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  // mv on vire les libelles de la tob_rub cr��s pr�c�demment
  T := Tob_Rub.FindFirst(['PHB_NATURERUB', 'PHB_DATEDEBUT', 'PHB_DATEFIN', 'PHB_SALARIE'],
    [Natrub, DateD, DateF, Salarie.GetValeur(iPSA_SALARIE)], TRUE);
  while T <> nil do
  begin
    if ((copy(T.GetValue('PHB_RUBRIQUE'), 1, length(ARub) + 1) = ARub + '.') and
      (T.GetValue('PHB_ORIGINELIGNE') = 'ABS')) then
      T.free;
    T := Tob_Rub.FindNext(['PHB_NATURERUB', 'PHB_DATEDEBUT', 'PHB_DATEFIN', 'PHB_SALARIE'],
      [Natrub, DateD, DateF, Salarie.GetValeur(iPSA_SALARIE)], TRUE);
  end;

end;

procedure Ecritlignecomm(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const Rub, NatRub: string);
var
  Thh, TR: tob;
begin
  TR := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [Rub], FALSE);
  THH := TOB.create('HISTOBULLETIN', Tob_Rub, -1);
  THH.PutValue('PHB_RUBRIQUE', Rub + '.' + IntToStr(i));
  THH.PutValue('PHB_NATURERUB', Natrub);
  THH.PutValue('PHB_DATEDEBUT', DateD);
  THH.PutValue('PHB_DATEFIN', DateF);
  THH.PutValue('PHB_ETABLISSEMENT', Salarie.GetValeur(iPSA_ETABLISSEMENT));
  THH.PutValue('PHB_SALARIE', Salarie.GetValeur(iPSA_SALARIE));
  THH.PutValue('PHB_BASEREM', 0);
  THH.PutValue('PHB_TAUXREM', 0);
  THH.PutValue('PHB_COEFFREM', 0);
  THH.PutValue('PHB_MTREM', 0);
  THH.PutValue('PHB_CONSERVATION', 'BUL');
  THH.PutValue('PHB_LIBELLE', T.GetValue('PCN_LIBELLE'));
  THH.PutValue('PHB_ORIGINELIGNE', 'ABS');
  THH.PutValue('PHB_IMPRIMABLE', 'X');
  THH.PutValue('PHB_TRAVAILN2', Salarie.GetValeur(iPSA_TRAVAILN2));
  THH.PutValue('PHB_TRAVAILN3', Salarie.GetValeur(iPSA_TRAVAILN3));
  THH.PutValue('PHB_TRAVAILN4', Salarie.GetValeur(iPSA_TRAVAILN4));
  THH.PutValue('PHB_TRAVAILN1', Salarie.GetValeur(iPSA_TRAVAILN1));
  THH.PutValue('PHB_CODESTAT', Salarie.GetValeur(iPSA_CODESTAT));
  THH.PutValue('PHB_LIBREPCMB1', Salarie.GetValeur(iPSA_LIBREPCMB1));
  THH.PutValue('PHB_LIBREPCMB2', Salarie.GetValeur(iPSA_LIBREPCMB2));
  THH.PutValue('PHB_LIBREPCMB3', Salarie.GetValeur(iPSA_LIBREPCMB3));
  THH.PutValue('PHB_LIBREPCMB4', Salarie.GetValeur(iPSA_LIBREPCMB4));
  THH.PutValue('PHB_CONFIDENTIEL', Salarie.GetValeur(iPSA_CONFIDENTIEL));
  if TR <> nil then THH.PutValue('PHB_ORDREETAT', TR.GetValue('PRM_ORDREETAT'));
  i := i + 1;

end;

procedure RechercheCarMotifAbsence(const Abs: string; var Profil, Rubrique, Aliment: string; var GereComm, Heure: boolean);
var
  Q: tQuery;
  st: string;
begin
  Aliment := '';
  Gerecomm := false;
  Heure := false;
  Profil := '';
  Rubrique := '';
  st := 'SELECT * FROM MOTIFABSENCE WHERE ##PMA_PREDEFINI## PMA_MOTIFABSENCE = "' + Abs + '"';
  Q := opensql(st, True);
  if Q.eof then exit;
  GereComm := (q.findfield('PMA_GERECOMM').asstring = 'X');
  Aliment := Q.findfield('PMA_ALIMENT').asstring;
  Heure := (Q.findField('PMA_JOURHEURE').asstring = 'HEU');
  Profil := Q.findfield('PMA_PROFILABS').asstring;
  Rubrique := Q.findfield('PMA_RUBRIQUE').asstring;
  Ferme(Q);
end;


//Alimentation des valeurs dans les rubriques d'absence
// PT107 IJSS procedure IntegreRub(tob_rub, Salarie: tob; const TypeAbs, aliment: string; const DateD, DateF: tdatetime; const compteur: double; natrub, arub: string);

procedure IntegreRub(tob_rub, Salarie: tob; const TypeAbs, aliment: string; const DateD, DateF: tdatetime; const compteur: double; natrub, arub: string; IJSS, Maintien: Boolean);
var
  TRC, THB: tob;
begin
  if NatRub = 'AAA' then
  begin
    TRC := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [ARub], FALSE); // $$$$
  end else
  begin
    TRC := Tob_Cotisations.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [ARub, NatRub], FALSE); // $$$$
    if TRC = nil then // Rubrique de base
    begin
      TRC := Tob_Bases.FindFirst(['PCT_RUBRIQUE', 'PCT_NATURERUB'], [ARub, NatRub], FALSE); // $$$$
    end;
  end;

  THB := Tob_rub.FindFirst(['PHB_NATURERUB', 'PHB_RUBRIQUE'], [NatRub, ARub], FALSE); // $$$$
  if THB = nil then
  begin
    THB := TOB.Create('HISTOBULLETIN', tob_rub, -1);
    if TRC <> nil then
      RemplirHistoBulletin(THB, Salarie, TRC, nil, tob_rub.GetValue('PPU_DATEDEBUT'), tob_rub.GetValue('PPU_DATEFIN')); //mv
  end;
  if THB <> nil then
  begin
    if Aliment = 'BAS' then
      THB.PutValue('PHB_BASEREM', Compteur);
    if Aliment = 'TAU' then
      THB.PutValue('PHB_TAUXREM', Compteur);
    if Aliment = 'COE' then
      THB.PutValue('PHB_COEFFREM', Compteur);
    if Aliment = 'MON' then
      THB.PutValue('PHB_MTREM', Compteur);
    {Positionne indicateur pour indiquer la provenance de la ligne dans le bulletin
    ET indiquer que la saisie n'est pas possible car les champs sont pr�calcul�s}
// d PT107 IJSS
    if not (IJSS) and not (maintien) then
      THB.PutValue('PHB_ORIGINELIGNE', 'ABS') // Calcul� par les absences
    else
      if (IJSS) then
      THB.PutValue('PHB_ORIGINELIGNE', 'IJS') // Calcul� par les IJSS
    else
      if (maintien) then
      THB.PutValue('PHB_ORIGINELIGNE', 'MAI'); // Calcul� par le maintien
    // f PT107 IJSS

  end;
end;


{
Initialization
InitLesTOBPaie ;
Finalization
TOB_Paie.Free ;
}

procedure GridGriseCell(const GS: THGrid; const Acol, Arow: integer; Canvas: Tcanvas);
var
  R: TRect;
begin
  Canvas.Brush.color := $00C9C9CB; // $00E4E4E4;
  Canvas.Brush.Style := bsBDiagonal;
  Canvas.Pen.Color := Canvas.Brush.color;
  Canvas.Pen.mode := pmMask; //pmCopy;
  Canvas.Pen.Style := psDot; //psClear;
  Canvas.Pen.Width := 1;
  R := GS.CellRect(Acol, ARow);
  Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
end;

procedure GridDeGriseCell(const GS: THGrid; const Acol, Arow: integer; Canvas: Tcanvas);
var
  R: TRect;
begin
  Canvas.Brush.color := $00E4E4E4;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := Canvas.Brush.color;
  Canvas.Pen.mode := pmMask; //pmCopy;
  Canvas.Pen.Style := psDot; //psClear;
  Canvas.Pen.Width := 1;
  R := GS.CellRect(Acol, ARow);
  Canvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom);
end;
{ function qui calcule la base de pr�carit� .
Identification des dates de d�but de fin de contrat tq qu'il n'ait pas eu de rupture
ou que le contrat n'indique pas un motif de non calcul de la pr�carit�.
La pr�carit� ne concerne que les contrats de type CDD.
3 cas o� la pr�carit� ne se calcule pas :
- refus CDI
- Faute grave
- Autre contrat CDD suivant le contrat
M�thodologie de recherche des contrats CDD :
- si DD lue > DF+5 stockee alors stockage DD et DF
- si DD lue <= DF stockee + 5 et DD lue >= DF stock�e et si DF lue <= DD paie alors Stockage DF
- si CCD et Next non CCD alors Next et RAZ DD et DF Stock�e
L'objectif est de trouver les dates de contrat CDD ayant pour la paie
Il suffit d�s lors de calculer la base de precarite en sommant le cumul dans
la fourchette de dates calculees et de prendre aussi le cumul base de precarite
de la paie en cours
Refonte compl�te du calcul de la pr�carit�.
Elle est tjrs calcul�e en fin de contrat m�me si un autre CDD suit.
Il faut d�s lors recalculer les trentiemes pour la pr�carit� d�j� calcul�e afin de
la deduire sur la pr�carit� en cours
}
// Reecriture calcul base de pr�carit�

function RendBasePrecarite(const DateDebut, DateFin: TDateTime; const DuSalarie: string): double;
var
  Q: TQuery;
  St, TypeContrat, Precarite: string;
  DDLue, DFLue, DDOk, DFOk: TDateTime;
  MDDOk, MDFOk, LaDate: TDateTime;
  NbreTrent, RR, NbreC: Double;
  MtCDD: Double;
  NbreCDD, CtratHorsPaie, NbreCDDP, NBREP: Integer;
  Denom: Double;
  LaFin, DebCtr: TDateTime;
begin
  result := 0;
  DDLue := 0;
  DFLue := 0;
  DDOk := 0;
  DFOk := 0;
  MDDOk := 0;
  MDFOk := 0;
  NbreCDD := 0; // Nbre de CDD Finissant dans la paie
  NbreCDDP := 0;
  // Analyse du nombre de contrats CDD du salari� qui se termine dans la paie et qui commence avt la paie
  st := 'SELECT COUNT(*) NBRECDD FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie + '" AND PCI_TYPECONTRAT="CCD" AND ' +
    ' PCI_FINCONTRAT >="' + UsDateTime(DateDebut) + '" AND PCI_FINCONTRAT <="' + UsDateTime(DateFin) + '"' +
    ' AND PCI_DEBUTCONTRAT <"' + UsDateTime(DateDebut) + '"';
  Q := OpenSql(st, TRUE);
  if not Q.EOF then NbreCDD := Q.FindField('NBRECDD').AsInteger;
  Ferme(Q);
  // Analyse du nombre de contrats CDD du salari� dont les p�riodes sont incluses dans la paie
  st := 'SELECT COUNT(*) NBRECDD FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie + '" AND PCI_TYPECONTRAT="CCD" AND ' +
    ' PCI_FINCONTRAT >="' + UsDateTime(DateDebut) + '" AND PCI_FINCONTRAT <="' + UsDateTime(DateFin) + '"' +
    ' AND PCI_DEBUTCONTRAT >="' + UsDateTime(DateDebut) + '"';
  Q := OpenSql(st, TRUE);
  if not Q.EOF then NbreCDDP := Q.FindField('NBRECDD').AsInteger;
  Ferme(Q);
  // Analyse si contrat CDD qui commence dans la paie qui se termine au del� de la fin de paie
  CtratHorsPaie := 0;
  st := 'SELECT COUNT(*) NBRECDD,MIN (PCI_DEBUTCONTRAT) DEBCTR FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie + '" AND PCI_TYPECONTRAT="CCD" AND ' +
    ' PCI_DEBUTCONTRAT >="' + UsDateTime(DateDebut) + '" AND PCI_FINCONTRAT >"' + UsDateTime(DateFin) + '"';
  Q := OpenSql(st, TRUE);
  if not Q.EOF then
  begin
    CtratHorsPaie := Q.FindField('NBRECDD').AsInteger;
    DebCtr := Q.FindField('DEBCTR').AsDateTime;
  end
  else
  begin
    CtratHorsPaie := 0;
    DebCtr := 0;
  end;
  Ferme(Q);
  // Analyse des diff�rents contrats de travail du salari� soit 1 (dans 99% ces cas) � 4 ou 5 enreg maxi
  // de fa�on � connaitre les dates debut et fin contrat
  st := 'SELECT PCI_TYPECONTRAT,PCI_DEBUTCONTRAT,PCI_FINCONTRAT,PCI_NONPRECARITE FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie +
    '" ORDER BY PCI_SALARIE,PCI_DEBUTCONTRAT DESC';
  Q := OpenSql(st, TRUE);
  while not Q.EOF do
  begin
    TypeContrat := Q.FindField('PCI_TYPECONTRAT').AsString;
    DDLue := Q.FindField('PCI_DEBUTCONTRAT').AsFloat;
    DFLue := Q.FindField('PCI_FINCONTRAT').AsFloat;
    Precarite := Q.FindField('PCI_NONPRECARITE').AsString;
    if (TypeContrat = 'CCD') and (DFLue >= DateDebut) and (DFLue <= DateFin) and (Precarite = '') then
    begin // Cas o� 1er CDD trouv� ou nouveau CDD
      DDOk := DDlue;
      DFOk := DFLue;
      // memorisation du 1er contrat CDD lu dont la date de fin est dans la periode du bulletin     if MDDOk = 0 then MDDOk := DDLue;
      if MDDOk = 0 then MDDOk := DDLue;
      if MDFOk = 0 then MDFOk := DFLue;
    end;
    if (TypeContrat = 'CCD') and (DDLue <= DFOk) and (DDLue > DFOk) and (Precarite <> 'X') then
    begin // Cas CDD prolong� par un autre CDD
    end;
    if (TypeContrat <> 'CCD') and (DDOk <> 0) then
    begin // Cas o� il y a un autre contrat qui ne soit pas un CDD
      if (TypeContrat = 'CDI') and (DDLue > DFOk) and (DDLue < DFOk) and (DDLue < DateDebut) then
      begin // cas CDD suivi d'un CDI dans les jours suivants
        DDOk := 0; // pas de calcul de precarite car embauche definitive
        DFOk := 0;
      end;
    end;
    Q.Next;
  end;
  Ferme(Q);
  if DDOk <> MDDok then NbreC := 2 else NbreC := 1; // on identifie le nombre de contrats (> 1)
  if (DDOk <> 0) and (DFOk <> 0) then
  begin
    // cas 1 seul contrat
    if NbreC = 1 then
    begin
      if DDok >= DateDebut then // 1 Contrat dans la periode de paie
      begin
        if DFok = DateFin then
          result := RendCumulSalSess('18') // cumul base precarite de la paie en cours
        else
        begin // 1 contrat mais date de fin de paie ne correspond pas � la date de fin de contrat
          // ce cas ne devrait pas se produire !!!!
          Denom := DateFin + 1 - DateDebut; // Calcul du denominateur du trentieme
          if Denom > 30 then Denom := 30;
          NbreTrent := CalculTrentieme(DateDebut, DFok) / (Denom);
          if NbreTrent > 1 then NbreTrent := 1;
          result := (RendCumulSalSess('18') * NbreTrent); // cumul base precarite de la paie en cours proratis�e
        end;
      end
      else
      begin // contrat d�bute sur 1 periode pr�c�dente et se termine dans la paie
        if DDok <= (DateDebut - 1) then
        begin
          st := 'SELECT COUNT (*) NBREP FROM PAIEENCOURS WHERE PPU_DATEDEBUT="' + UsDatetime(DDOk) + '" AND PPU_SALARIE="' + DuSalarie + '"';
          Q := OpenSql(St, TRUE);
          if not Q.EOF then NBREP := Q.FindField('NBREP').AsInteger
          else NBREP := 0;
          FERME(Q);
          if NbreP = 0 then LaDate := DebutDeMois(DDOk) // base precarite mois precedents
          else LaDate := DDOK;
          RR := ValCumulDate('18', LaDate, DateDebut - 1);
          St := 'SELECT SUM(PHB_BASEREM) AS MTPRECPAYES' +
            ' FROM HISTOBULLETIN' +
            ' LEFT JOIN REMUNERATION ON' +
            ' PHB_NATURERUB=PRM_NATURERUB AND' +
            ' ##PRM_PREDEFINI## PHB_RUBRIQUE=PRM_RUBRIQUE WHERE' +
            ' PRM_INDEMLEGALES="003" AND' +
            ' PHB_SALARIE="' + DuSalarie + '" AND' +
            ' PHB_DATEDEBUT>="' + UsDateTime(LaDate) + '" AND' +
            ' PHB_DATEFIN<="' + UsDateTime(DateDebut - 1) + '"';
          Q := OpenSql(St, TRUE);
          if not Q.EOF then MtCDD := Q.FindField('MTPRECPAYES').AsFloat
          else MtCDD := 0;
          Ferme(Q);
          result := RR - MtCDD;
          // cas o� on ne fait pas un bulletin � chaque fin de p�riode de contrat
          if result < 0 then
          begin
            NbreTrent := 1;
            st := 'SELECT MAX(PCI_FINCONTRAT) DATECDD FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie +
              '" AND PCI_TYPECONTRAT="CCD" AND ' +
              ' PCI_FINCONTRAT >="' + UsDateTime(DebutDeMois(DDOK)) + '" AND PCI_FINCONTRAT <="' + UsDateTime(DDOK - 1) + '"';
            Q := OpenSql(St, TRUE);
            if not Q.EOF then LaFin := Q.FindField('DATECDD').AsDateTime
            else LaFin := idate1900;
            Ferme(Q);
            if LaFin = Idate1900 then LaFin := DDOK - 1;
            NbreTrent := CalculTrentieme(DebutDeMois(DDOK), LaFin) / 30;
            if NbreTrent > 1 then NbreTrent := 1;
            NbreTrent := 1 - NbreTrent;
            result := ARRONDI(ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOK)) * NbreTrent, 2);
          end;
        end;
        NbreTrent := 1;
        st := 'SELECT COUNT (*) NbreCDD FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie +
          '" AND PCI_TYPECONTRAT="CCD" AND ' +
          ' PCI_DEBUTCONTRAT >="' + UsDateTime(DFOK + 1) + '" AND PCI_DEBUTCONTRAT <="' + UsDateTime(FinDeMois(DFOK)) + '"';
        Q := OpenSql(st, TRUE);
        if not Q.EOF then NbreCDD := Q.FindField('NBRECDD').AsInteger else NbreCDD := 0;
        Ferme(Q);
        if (DateFin <> DFOK) and (NbreCDD > 0) then NbreTrent := CalculTrentieme(DateDebut, DFok) / 30;
        if NbreTrent > 1 then NbreTrent := 1;
        result := result + (RendCumulSalSess('18') * NbreTrent);
      end;
    end
    else // cas o� 2 ou + contrats
    begin
      if (NbreCDD = 0) and (CtratHorsPaie = 0) then
      begin
        // il n'y a que des CDD dans la paie pas de chevauchement de contrat avec periode de paie
        // soit x contrats dans la pais
        NbreTrent := 1;
        if NbreCDDP > 0 then result := RendCumulSalSess('18');
      end
      else
      begin
        if (NbreCDD = 0) and (NbreCDDP >= 1) and (CtratHorsPaie > 0) and (Trentieme <> 30) then
          // il y a des CDD dans la paie pas de chevauchement de contrat avec periode de paie precedante
          // mais un CDD qui commence dans la paie et se poursuit en dehors
        begin
          NbreTrent := (FinDeMois(DebCtr) - DebCtr + 1) / 30; // Recup�ration du nbre de trentieme correspondant au contrat qui continue
          NbreTrent := 1 - (NbreTrent / Trentieme); // Proratisation des trenti�mes calcul�s par rapport au nbre de trentieme de la paie
          result := (RendCumulSalSess('18') * NbreTrent);
        end
        else
        begin
          if ((NbreCDD = 1) and (NbreCDDP > 0)) then
          begin // Contrat(s) dans la paie, mais contrat hors paie(
            result := RendCumulSalSess('18');
          end
          else
          begin
            St := 'SELECT SUM(PHB_BASEREM) AS MTPRECPAYES' +
              ' FROM HISTOBULLETIN' +
              ' LEFT JOIN REMUNERATION ON' +
              ' PHB_NATURERUB=PRM_NATURERUB AND' +
              ' ##PRM_PREDEFINI## PHB_RUBRIQUE=PRM_RUBRIQUE WHERE' +
              ' PRM_INDEMLEGALES="003" AND' +
              ' PHB_SALARIE="' + DuSalarie + '" AND' +
              ' PHB_DATEDEBUT>="' + UsDateTime(DebutDeMois(DDOk)) + '" AND' +
              ' PHB_DATEFIN<="' + UsDateTime(FinDeMois(DDOK)) + '"';
            Q := OpenSql(St, TRUE);
            if not Q.EOF then MtCDD := Q.FindField('MTPRECPAYES').AsFloat
            else MtCDD := 0;
            Ferme(Q);
            result := ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOK)) - MtCDD;
            result := result + ValCumulDate('18', FinDeMois(DDOK) + 1, DateDebut - 1);
            if DateFin <> DFOK then NbreTrent := CalculTrentieme(DateDebut, DFok) / 30;
            if NbreTrent > 1 then NbreTrent := 1;
            result := result + (RendCumulSalSess('18') * NbreTrent);
          end;
        end;
      end;
    end;
  end; // fin si contrats trouves
end;

// PT49 : 18/06/2002 V582 PH Modif Refonte compl�te du calcul de la pr�carit�

function RendBasePrecarite_Old(DateDebut, DateFin: TDateTime; DuSalarie: string): double;
var
  Q: TQuery;
  St, TypeContrat, Precarite: string;
  DDLue, DFLue, DDOk, DFOk: TDateTime;
  MDDOk, MDFOk, MF: TDateTime;
  NbreTrent, RR, NbreC: Double;
  RendRub: TRendRub;
begin
  result := 0;
  DDLue := 0;
  DFLue := 0;
  DDOk := 0;
  DFOk := 0;
  MDDOk := 0;
  MDFOk := 0;
  // Analyse des diff�rents contrats de travail du salari� soit 1 (dans 99% ces cas) � 4 ou 5 enreg maxi
  st := 'SELECT PCI_TYPECONTRAT,PCI_DEBUTCONTRAT,PCI_FINCONTRAT,PCI_NONPRECARITE FROM CONTRATTRAVAIL WHERE PCI_SALARIE="' + DuSalarie +
    '" ORDER BY PCI_SALARIE,PCI_DEBUTCONTRAT DESC';
  Q := OpenSql(st, TRUE);
  while not Q.EOF do
  begin
    TypeContrat := Q.FindField('PCI_TYPECONTRAT').AsString;
    DDLue := Q.FindField('PCI_DEBUTCONTRAT').AsFloat;
    DFLue := Q.FindField('PCI_FINCONTRAT').AsFloat;
    Precarite := Q.FindField('PCI_NONPRECARITE').AsString;
    // PT38 : 03/04/2002 V571 PH Modif Calcul base de pr�carit� Seuil ramen� � 1 jour
    // PT47 : 03/04/2002 V571 PH Modif Calcul base de pr�carit� Seuil ramen� � 0 jour
    if (TypeContrat = 'CCD') and (DFLue >= DateDebut) and (DFLue <= DateFin) and (Precarite = '') then
    begin // Cas o� 1er CDD trouv� ou nouveau CDD
      DDOk := DDlue;
      DFOk := DFLue;
      // memorisation du 1er contrat CDD lu dont la date de fin est dans la periode du bulletin     if MDDOk = 0 then MDDOk := DDLue;
      if MDDOk = 0 then MDDOk := DDLue;
      if MDFOk = 0 then MDFOk := DFLue;
    end;
    if (TypeContrat = 'CCD') and (DDLue <= DFOk) and (DDLue > DFOk) and (DDLue > DFOk) and (Precarite <> 'X') then
    begin // Cas CDD prolong� par un autre CDD
      //     DFOk := DFLue; // on recup�re la date de fin de contrat et on garde la date de debut de contrat
    end;
    if (TypeContrat <> 'CCD') and (DDOk <> 0) then
    begin // Cas o� il y a un autre contrat qui ne soit pas un CDD
      if (TypeContrat = 'CDI') and (DDLue > DFOk) and (DDLue < DFOk) and (DDLue < DateDebut) then
      begin // cas CDD suivi d'un CDI dans les jours suivants
        DDOk := 0; // pas de calcul de precarite car embauche definitive
        DFOk := 0;
      end;
    end;
    Q.Next;
  end;
  Ferme(Q);
  if DDOk <> MDDok then NbreC := 2 else NbreC := 1; // on identifie le nombre de contrats (> 1)
  if (DDOk <> 0) and (DFOk <> 0) then
  begin
    // cas 1 seul contrat
    if NbreC = 1 then
    begin
      if DDok >= DateDebut then // Contrat dans la periode de paie
      begin
        if DFok = DateFin then
          result := RendCumulSalSess('18') // cumul base precarite de la paie en cours
        else
        begin
          {PT52-2
                    NbreTrent := CalculTrentieme(DateDebut,DFok)/30;
          }
          NbreTrent := CalculTrentieme(DateDebut, DFok) / (DateFin + 1 - DateDebut);
          //FIN PT52-2
          if NbreTrent > 1 then NbreTrent := 1;
          result := (RendCumulSalSess('18') * NbreTrent); // cumul base precarite de la paie en cours proratis�e
        end;
      end
      else
      begin // contrat d�bute sur 1 periode pr�c�dente et se termine dans la paie
        //       result := ValCumulDate ('18',DDOk, DateDebut-1); // base precarite mois precedents
        MF := FindeMois(DDOk);
        //PT52-1 Ajout de la condition
        if (DDLue <> DDOK) then
        begin
          if MF = (DateDebut - 1) then // on a qu'un prorata sur le mois precedent
          begin
            {PT52-2
                         NbreTrent := CalculTrentieme(DDok, MF)/30;
                         RR := CalculTrentieme (DebutDeMois (DDok), DDok-1)/30;
                         if (RR + NbreTrent) <> 1 then NbreTrent := 1 - RR; // Correctif pour 30/30 dans le mois
            }
            NbreTrent := CalculTrentieme(DDok, MF) / (MF + 1 - DDLue);
            if DebutDeMois(DDok) > DDLue then
            begin
              RR := CalculTrentieme(DebutDeMois(DDok), DDok - 1) / 30;
              if (RR + NbreTrent) <> 1 then NbreTrent := 1 - RR; // Correctif pour 30/30 dans le mois
            end;
            //FIN PT52-2
            if NbreTrent > 1 then NbreTrent := 1;
            if (ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOk))) <> (ValCumulDate('18', DDOk, FinDeMois(DDOk))) then
            begin
              result := result + ValCumulDate('18', DDOk, DateDebut - 1);
            end
            else
            begin
              result := result + ValCumulDate('18', DebutDeMois(DDOk), DateDebut - 1);
              RendRub := ValRubDate('4282', 'REM', DebutDeMois(DDOk), DDOk - 1);
              result := result - RendRub.BasRem;
            end;
            //            result := ValCumulDate ('18',DebutDeMois(DDOk), DateDebut-1) * NbreTrent;
            result := Result + RendCumulSalSess('18'); // PT52-2
          end
          else
          begin // base precarite sur les mois complets + Base precarite proratis�e
            result := ValCumulDate('18', MF + 1, DateDebut - 1); // base precarite mois precedents complets
            {PT52-2
                         NbreTrent := CalculTrentieme(DDok,MF)/30;
            }
            if ((MF + 1 - DDLue) > 30) then
              NbreTrent := CalculTrentieme(DDok, MF) / 30
            else
              NbreTrent := CalculTrentieme(DDok, MF) / (MF + 1 - DDLue);
            //FIN PT52-2
            if NbreTrent > 1 then NbreTrent := 1;
            {PT52-2
                         result := result + (ValCumulDate ('18',DDok, FinDeMois (DDOk)) * NbreTrent);
                         end;
                      end;
                   result := Result + RendCumulSalSess ('18'); // base precarite de la paie en cours
            }
            if (ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOk))) <> (ValCumulDate('18', DDOk, FinDeMois(DDOk))) then
            begin
              result := result + ValCumulDate('18', DDOk, FinDeMois(DDOk));
            end
            else
            begin
              result := result + ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOk));
              RendRub := ValRubDate('4282', 'REM', DebutDeMois(DDOk), DDOk - 1);
              result := result - RendRub.BasRem;
            end;
            result := Result + RendCumulSalSess('18'); // base precarite de la paie en cours
          end;
        end
        else
        begin
          if MF = (DateDebut - 1) then // on a qu'un prorata sur le mois precedent
          begin
            NbreTrent := CalculTrentieme(DDok, MF) / (MF + 1 - DDLue);
            if DebutDeMois(DDok) >= DDLue then
            begin
              RR := CalculTrentieme(DebutDeMois(DDok), DDok - 1) / 30;
              if (RR + NbreTrent) <> 1 then NbreTrent := 1 - RR; // Correctif pour 30/30 dans le mois
            end;
            if NbreTrent > 1 then NbreTrent := 1;
            result := ValCumulDate('18', DebutDeMois(DDOk), DateDebut - 1) * NbreTrent;

            NbreTrent := CalculTrentieme(DateDebut, DFok) / (DateFin + 1 - DateDebut);
            if NbreTrent > 1 then
              NbreTrent := 1;
            //             result := result + (ValCumulDate ('18',DateDebut, DateFin) * NbreTrent); // base precarite mois en cours
            result := Result + RendCumulSalSess('18'); // @@@@@@ Pour prendre en compte la base p�carit�en cours mais � payer
          end
          else
          begin
            result := ValCumulDate('18', MF + 1, DateDebut - 1); // base precarite mois precedents complets
            if ((MF + 1 - DDLue) > 30) then
              NbreTrent := CalculTrentieme(DDok, MF) / 30
            else
              NbreTrent := CalculTrentieme(DDok, MF) / (MF + 1 - DDLue);
            if NbreTrent > 1 then NbreTrent := 1;
            result := result + (ValCumulDate('18', DebutDeMois(DDOk), FinDeMois(DDOk)) * NbreTrent);
            result := Result + RendCumulSalSess('18'); // base precarite de la paie en cours
          end;
        end;
        //FIN PT52-2
        //FIN PT52-1
      end;
    end
    else // cas o� 2 ou + contrats
    begin
      RR := 0;
      if MDFok = DateFin then result := RendCumulSalSess('18') // base pr�carite de la paie en cours
      else
      begin
        NbreTrent := ((MDFok + 1 - DateDebut) / 30);
        if NbreTrent > 1 then NbreTrent := 1;
        result := (RendCumulSalSess('18') * NbreTrent); // cumul base precarite de la paie en cours proratis�e
      end;
      if MDDok < DateDebut then // // base precarite mois precedents
      begin // contrat d�bute sur 1 periode pr�c�dente et se termine dans la paie
        RR := ValCumulDate('18', MDDOk, DateDebut - 1); // base precarite mois precedents
        if RR = 0 then RR := ValCumulDate('18', DebutDeMois(MDDOk), DateDebut - 1);
      end;
      Result := result + RR;
    end;
  end; // fin si contrats trouves
end;
//------------------------------------------------------------------------------
// Procedure qui permet d'alimenter � chaque validation de bulletin la ligne de
// cong�s acquis correspondant
//------------------------------------------------------------------------------



function IsNumerique(const S: string): boolean;
const
  Numerique = ['0'..'9', ',', '.'];
var
  i: Integer;
begin
  if S = '' then
  begin
    IsNumerique := true;
    exit;
  end;
  IsNumerique := FALSE;
  if Length(S) < 1 then exit;
  for i := 1 to Length(S) do
    if ((not (S[i] in Numerique)) and (Ord(s[i]) <> 160)) then exit;
  IsNumerique := TRUE;
end;

function IsOkFloat(const val: string): boolean;
begin
  result := false;
  if not IsNumerique(Val) then
  begin
    PGIBox('Zone non num�rique', 'Controle de num�ricit�');
    exit;
  end;
  result := true;
end;

function notVide(T: tob; const MulNiveau: boolean): boolean;
var
  tp: tob;
begin
  result := false;
  if t = nil then
    exit;
  tp := t.findfirst([''], [''], MulNiveau);
  result := (tp <> nil);
end;

procedure GestionCalculAbsence(tob_rub: tob; const DateD, DateF: tdatetime; const typem: string);
var
  mul, ValoDxmn: double;
  NBjSem: integer;
  Valo, MValoMs: string;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;
  //DEB PT57 Int�gration de la m�thode de valorisation des CP personnalis� salari�
  RendMethodeValoDixieme(NBjSem, MValoMs, ValoDxmn);
  if MValoMs = 'T' then //Calendrier th�orique
    begin
    if NbJSem = 5 then Mul := 21.67 else Mul := 26;
    end
  else
    begin
    if MValoMs = 'M' then //Gestion manuelle
      begin
      Mul := ValoDxmn;
      end
      else
      begin //Calendrier r�el
      if NbJSem = 5 then Mul := ChpEntete.Ouvres else
        Mul := ChpEntete.Ouvrables;
      end;
    //FIN PT57
    end;  { PT127-2 Replacement du end; pour ne pas englober tout le code et permettre le calcul de l'indemnit� et absence valo CP }
    Valo := TrouveModeValorisation(TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [Tob_Salarie.GetValeur(iPSA_ETABLISSEMENT)], False), Tob_Salarie); //PT59
    if TypeM = 'PRI' then
      if notVide(Tob_Pris, true) then
      begin
        if ReCalculeValoAbsence(Tob_pris, Dated, DateF, Valo, Mul, 'PRI') then
        begin
          AgregeCumulPris(tob_pris);
          IntegrePaye(Tob_Rub, Tob_Pris, Tob_Salarie.GetValeur(iPSA_ETABLISSEMENT), CodSal, DateD, DateF, 'PRI');
        end;
      end;
    if TypeM = 'SLD' then
      if notVide(Tob_Solde, true) then
      begin
        if ReCalculeValoAbsence(Tob_Solde, Dated, DateF, Valo, Mul, 'SLD') then
        begin
          AgregeCumulPris(tob_solde);
          IntegrePaye(Tob_Rub, Tob_solde, Tob_Salarie.GetValeur(iPSA_ETABLISSEMENT), CodSal, DateD, DateF, 'SLD');
        end;
      end;
end;

procedure InitialiseVariableStatCP;
begin
  HCPPRIS := 0; // Heures CP pris dans la session
  HCPPAYES := 0; // Heures CP payees dans la session
  HCPASOLDER := 0; // Heures CP � solder dans la session
  JCPACQUIS := 0; // Jours CP acquis dans la session
  JCPACQUISACONSOMME := 0; // Valeur a consomm� sur Jours CP acquis dans la session PT17
  JCPACQUISTHEORIQUE := 0; // Jours CP acquis th�orique PT75-2
  MCPACQUIS := 0; // Mois acquis ds la session (trentieme)
  BCPACQUIS := 0; // Base acquis ds la session
  ASOLDERAVBULL := 0; // Nbre de jours � solder en cloture de contrat
  JRSAARRONDIR := 0; // CP de la p�riode � solder hors acquis bulletin
  JCPPRIS := 0; // Jours CP pris dans la session
  JCPPAYES := 0; // Jours CP pay�s dans la session
  JCPPAYESPOSES := 0; // Jours CP pris � int�grer dans la session  PT88
  JCPASOLDER := 0; // Jours CP A Solder dans la session
  CPMTABS := 0; // CP Montant Absence
  CPMTINDABS := 0; // CP Montant Indemnite Absence
  CPMTINDCOMP := 0; // CP Montant Indemnite Compensatrice
  JCPSOLDE := 0;
  CPMTABSSOL := 0;
  CPMTINDABSSOL := 0;
  JPAVANTBULL := 0;
  TopJPAVANTBULL := false;
  Chargement := true;
  PP := True;
  ValoXP0N := 0;
  ValoXP0D := 0;
  HABSPRIS := 0; //PT33 Init nouvel variable : Heures Absences pris
  JABSPRIS := 0; //PT33 Init nouvel variable : Jours Absences pris
end;

{ DEB PT83-3 Extrait de InitialiseVariableStatCP }

procedure InitVarTHTRAVAILLES;
begin
  JTHTRAVAILLES := 0; // Jours th�orique travaill�s par le salari� sur la p�riode
  HTHTRAVAILLES := 0; // Heures th�oriques travaill�s par le salari� sur la p�riode //PT43
end;
{ FIN PT83-3 }

procedure ReaffecteDateMvtcp(const DateFin: tdatetime);
var
  i: integer;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if (BullCompl = 'X') or (actionBulcp <> tacreation) or (not assigned(tob_pris)) then
  else
  begin
    for i := 0 to tob_pris.detail.count - 1 do
      with tob_pris.detail[i] do
      begin
        if (getvalue('PCN_DATEFIN') > (10)) and (getvalue('PCN_CODETAPE') <> '...') then //PT23
          putvalue('PCN_DATEFIN', Datefin);
        putvalue('PCN_DATEPAIEMENT', Datefin);
      end;
  end;
end;
// PT32 : 07/02/2002 V571 PH suppression historisation salari�
{
procedure CopyHistosal(var A,N:Histosal);
begin
     A.salarie       := N.SALARIE;
     A.CodeEmploi    := N.CODEEMPLOI;
     A.LibelleEmploi := N.LIBELLEEMPLOI;
     A.Qualification := N.QUALIFICATION;
     A.Coefficient   := N.COEFFICIENT;
     A.Indice        := N.INDICE;
     A.Niveau        := N.NIVEAU;
     A.CodeStat      := N.CODESTAT;
     A.TravailN1     := N.TRAVAILN1;
     A.TravailN2     := N.TRAVAILN2;
     A.TravailN3     := N.TRAVAILN3;
     A.TravailN4     := N.TRAVAILN4;
     A.Groupepaie    := N.Groupepaie;
     A.SalaireMois1  := N.SalaireMois1;
     A.SalaireAnn1   := N.SalaireAnn1;
     A.SalaireMois2  := N.SalaireMois2;
     A.SalaireAnn2   := N.SalaireAnn2;
     A.SalaireMois3  := N.SalaireMois3;
     A.SalaireAnn3   := N.SalaireAnn3;
     A.SalaireMois4  := N.SalaireMois4;
     A.SalaireAnn4   := N.SalaireAnn4;
     A.DtLibre1      := N.Dtlibre1;
     A.Dtlibre2      := N.Dtlibre2;
     A.Dtlibre3      := N.Dtlibre3;
     A.Dtlibre4      := N.Dtlibre4;
     A.Boollibre1    := N.Boollibre1;
     A.Boollibre2    := N.Boollibre2;
     A.Boollibre3    := N.Boollibre3;
     A.Boollibre4    := N.Boollibre4;
     A.CSlibre1      := N.CSlibre1;
     A.CSlibre2      := N.CSlibre2;
     A.CSlibre3      := N.CSlibre3;
     A.CSlibre4      := N.CSlibre4;
     A.Profil        := N.Profil;
     A.PeriodBul     := N.PeriodBul;
//PT-12 02/10/01 V562 PH Rajout historisation salarie profil r�mun�ration
     A.ProfilRem     := N.ProfilRem;
     A.Horairemois   := N.Horairemois;
     A.Horairehebdo  := N.Horairehebdo;
     A.HoraireAnnuel := N.HoraireAnnuel;
     A.TauxHoraire   := N.TauxHoraire;
//PT2
     A.DADSProfessio := N.DADSProfessio;
     A.DADSCategorie := N.DADSCategorie;
     A.TauxPartiel   := N.TauxPartiel;
     A.Condemploi    := N.Condemploi;//PT13
end;

procedure InitialiseBoolean(var M : Histosal;ValB: boolean);
Var
sValB : char;
begin
if Valb = true then
   sValB := 'X' else
   sValB := '-';
with M do begin
     Bsalarie      := sValb;
     BCodeEmploi   := sValb;
     BLibelleEmploi:= sValb;
     BQualification:= sValb;
     BCoefficient  := sValb;
     BIndice       := sValb;
     BNiveau       := sValb;
     BCodeStat     := sValb;
     BTravailN1    := sValb;
     BTravailN2    := sValb;
     BTravailN3    := sValb;
     BTravailN4    := sValb;
     BGroupepaie   := sValb;
     BSalaireMois1 := sValb;
     BSalaireAnn1  := sValb;
     BSalaireMois2 := sValb;
     BSalaireAnn2  := sValb;
     BSalaireMois3 := sValb;
     BSalaireAnn3  := sValb;
     BSalaireMois4 := sValb;
     BSalaireAnn4  := sValb;
     BDtlibre1     := sValb;
     BDtlibre2     := sValb;
     BDtlibre3     := sValb;
     BDtlibre4     := sValb;
     BBoollibre1   := sValb;
     BBoollibre2   := sValb;
     BBoollibre3   := sValb;
     BBoollibre4   := sValb;
     BCSlibre1     := sValb;
     BCSlibre2     := sValb;
     BCSlibre3     := sValb;
     BCSlibre4     := sValb;
//PT-12 02/10/01 V562 PH Rajout historisation salarie profil r�mun�ration
     BProfilRem    := sValb;
     BPeriodBul    := sValb;
     BProfil       := sValb;
     BHorairemois  := sValb;
     BHorairehebdo := sValb;
     BHoraireAnnuel:= sValb;
     BTauxHoraire  := sValb;
//PT2
     BDADSProfessio:= sValb;
     BDADSCategorie:= sValb;
     BTauxPartiel  := sValb;
     BCondemploi   := sValb;//PT13

 end;
end;
}
// FIN PT32
// PT20 : 20/11/01 V562 PH Modif du calcul des dates d'�dition automatique en fonction de l'�tablissement

procedure CalculeDateEdtPaie(var LDatD, LDatF: TDateTime; T_Etab: TOB);
var
  Annee, Mois, Jour, J1, J2: WORD;
  st: string;
begin
  if (T_ETAB.GetValue('ETB_JEDTDU') = 0) and (T_ETAB.GetValue('ETB_JEDTAU') = 0) then exit;
  if (T_ETAB.GetValue('ETB_JEDTDU') <> 0) and (T_ETAB.GetValue('ETB_JEDTAU') <> 0) then
  begin
    DecodeDate(LDatD, Annee, Mois, Jour);
    Jour := T_ETAB.GetValue('ETB_JEDTDU');
    // DEB PT108
    St := IntToStr(Jour) + DateSeparator + IntToStr(Mois) + DateSeparator + IntToStr(Annee);
    if not IsValidDate(st) then
    begin
      Jour := 1;
      LDatD := EncodeDate(Annee, Mois + 1, Jour);
    end
    else LDatD := EncodeDate(Annee, Mois, Jour);
    // FIN PT108
    J1 := T_ETAB.GetValue('ETB_JEDTDU');
    J2 := T_ETAB.GetValue('ETB_JEDTAU');
    if J1 = J2 then
    begin
      LDatF := LDatD; // On �dite sur le m�me mois pour le m�me jour
      exit;
    end;
    LDatD := PLUSMOIS(LDatD, -1); // Jour sur le mois pr�c�dant
    DecodeDate(LDatF, Annee, Mois, Jour);
    Jour := T_ETAB.GetValue('ETB_JEDTAU');
    St := IntToStr(Jour) + DateSeparator + IntToStr(Mois) + DateSeparator + IntToStr(Annee);
    if not IsValidDate(st) then
    begin
      Jour := 1;
      LDatF := EncodeDate(Annee, Mois, Jour);
      LDatF := FINDEMOIS(LDatF);
      exit;
    end;
    LDatF := EncodeDate(Annee, Mois, Jour);
  end;
end;

// PT28 : 27/12/2001 V571 PH Calcul des variables de tupe cumul en tenant compte du mois de RAZ
{ Fonction qui va borner la date de d�but en fonction du mois de RAZ du cumul.
Elle essaie de renseigner le mois de d�but et l'ann�e en fonction des dates calcul�es par rapport
� l'exercice social
Si erreur alors pas de calcul
PT70    23/01/2003 PH V591 Correction du calcul des bornes de dates pour la valorisation d'un cumul ant�rieur avec une p�riode de raz
Rajout dates d�but et fin
}

procedure BorneDateCumul(const DateDeb, DateFin: TDateTime; var ZDatD, ZDatF: TDateTime; const PerRaz: string);
var
  AA, MM, JJ: WORD;
  T_Etab: TOB;
  Etab, LeMoisRaz: string;
  LaDateCP: TDateTime;
begin
  if PerRaz = '' then
  begin
    ZDatD := -1;
    ZDatF := -1;
  end
  else if PerRaz = '99' then ZdatD := IDate1900 // Jamais de RAZ
  else if (PerRaz >= '01') and (PerRaz <= '12') then // Raz par rapport � un mois
    RendBorneDateCumul(DateDeb, DateFin, ZDatD, ZDatF, PerRaz)
  else if PerRaz = '20' then // Debut de p�riode CP
  begin
    Etab := string(TOB_Salarie.GetValeur(iPSA_ETABLISSEMENT));
    T_Etab := TOB_Etablissement.FindFirst(['ETB_ETABLISSEMENT'], [Etab], True);
    if T_Etab <> nil then
    begin
      LaDateCp := T_Etab.getvalue('ETB_DATECLOTURECPN');
      DecodeDate(LaDateCp, AA, MM, JJ);
      LeMoisRaz := IntToStr(MM);
      RendBorneDateCumul(DateDeb, DateFin, ZDatD, ZDatF, LeMoisRaz);
    end
    else
    begin
      ZDatD := -1;
      ZDatF := -1;
    end;
  end;
end;
{Fonction qui renseigne le mois de d�but et l'ann�e
PT70    23/01/2003 PH V591 Correction du calcul des bornes de dates pour la valorisation d'un cumul ant�rieur avec une p�riode de raz
Rajout Datedebut et fin et r��criture de la fonction
}

procedure RendBorneDateCumul(const DateDeb, DateFin: TDateTime; var ZDatD, ZdatF: TDateTime; const PerRaz: string);
var
  AA, MM, JJ: WORD;
  A, M, J: WORD;
begin
  DecodeDate(DateFin, AA, MM, JJ);
  if StrToInt(PerRaz) = MM then
  begin
    ZDatD := -1;
    ZdatF := -1;
    exit;
  end; // Cas ou le mois en cours correspond au mois de raz donc resultat = 0
  ZdatF := DateDeb - 1; // On se positionne juste avant la date de debut de la paie
  ZdatD := DebutDeMois(PLUSMois(ZDatF, -12)); // debut de mois - 1 an complet
  DeCodeDate(ZDatD, AA, MM, JJ);
  DeCodeDate(DateDeb, A, M, J);
  MM := StrToInt(PerRaz);
  if MM < M then AA := A;
  ZDatD := EncodeDate(AA, MM, 01);
end;

// PT35 : 26/03/2002 V571 PH Fonction de raz de ChptEntete

procedure RazChptEntete(const DateF: TDateTime);
begin
  //PT68    19/12/2002 PH V591 Affectation de la date de paiement � la date de fin de paie si non renseign�e
  //  Champ DatePai et DateVal renseign�
  with ChpEntete do
  begin
    Reglt := '';
    DatePai := DateF;
    DateVal := Date;
    HorMod := FALSE;
    BasesMod := FALSE;
    TranchesMod := FALSE;
    TrentMod := FALSE;
    DTrent := 0;
    NTrent := 0;
    Ouvres := 0;
    Houvres := 0; //PT61 Init Houvres � 0
    Ouvrables := 0;
    HOuvrables := 0; //PT61 Init Houvrables � 0
    HeuresTrav := 0;
    RegltMod := FALSE;
    Edtdu := 0;
    Edtau := 0;
    CpAcquisMod := False; { PT97 }
  end;
end;
// FIN PT35
// PT60 07/10/2002 V585 PH Recherche d'un element national par pr�f�rence DOS,STD,CEG

function ValEltNatPref(const Elt, Pref: string; const DatTrait: TDatetime): double;
var
  ret: double;
  datelue, LaDate: TDateTime;
  NoDossier, LeDecalage: string;
  T: TOB;
  FindNum: integer;
  i: integer;
  EltNat: TOB;
begin
  result := -123456; // initialisation
  ret := -123456;
  if Pref = 'CEG' then EltNat := TOB_EltNationauxCEG
  else if Pref = 'STD' then EltNat := TOB_EltNationauxSTD
  else EltNat := TOB_EltNationauxDOS;
  if assigned(EltNat) and (EltNat.detail.Count > 0) then
  begin
    Nodossier := '000000';
{$IFNDEF AGL570d}
    if V_PGI_Env <> nil then
{$ENDIF}
      // **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
      if Pref = 'DOS' then Nodossier := PgRendNoDossier();
    if (iCHampMontant = 0) then MemorisePel(EltNat.Detail[0]);
    i := 0;
    FindNum := -1;
    while i < EltNat.Detail.Count do
    begin
      with EltNat.Detail[i] do
      begin
        if (GetValeur(iChampPredefini) = Pref)
          //                   and (GetValeur(iCHampDossier)=NoDossier)
        and (GetValeur(iCHampCodeElt) = Elt) then
        begin
          FindNum := i;
          break;
        end;
      end;
      Inc(i);
    end;

    if FindNum > -1 then
    begin
      while true do
      begin
        t := EltNat.Detail[FindNum];
        DateLue := T.GetValeur(iCHampDateValidite);
        // PT62 07/11/2002 PH V591 Prise en compte du decalage de paie donc le traitement depend de l'�l�ment national
        LeDecalage := T.GetValeur(iCHampDecaleMois);
        LaDate := DatTrait;
        if (VH_Paie.PGDecalage = True) and (LeDecalage = 'X') then LaDate := PLUSMOIS(DatTrait, 1);
        if (VH_Paie.PGDecalagePetit = True) and (LeDecalage = 'X') then LaDate := PLUSMOIS(DatTrait, 1);
        if DateLue <= LaDate then // fin PT62
        begin
          // PT100  : 05/04/2004 PH V_50 FQ 11231 Prise en compte du cas sp�cifique Alsace Lorraine
          //          if VH_Paie.PGTenueEuro = FALSE then ret := T.GetValeur(iCHampMontant)
          if (RegimeAlsace = 'X') and (T.GetValeur(iChampRegimeAlsace) = 'X') then ret := T.GetValeur(iCHampMontant)
          else ret := T.GetValeur(iCHampMontantEuro);
        end
        else break;
        Inc(FindNum);
        if FindNum = EltNat.Detail.Count then break;
        with EltNat.Detail[FindNum] do
          if (GetValeur(iChampPredefini) <> Pref)
            //                      or (GetValeur(iCHampDossier)<>NoDossier)
          or (GetValeur(iCHampCodeElt) <> Elt) then break;
      end;
    end;
    result := ret;
  end;
end;

procedure MemorisePhc(UneTob: TOB);
begin
  if Assigned(UneTob) then
    with UneTob do
    begin
      iPHC_ETABLISSEMENT := GetNumChamp('PHC_ETABLISSEMENT');
      iPHC_SALARIE := GetNumChamp('PHC_SALARIE');
      iPHC_DATEDEBUT := GetNumChamp('PHC_DATEDEBUT');
      iPHC_DATEFIN := GetNumChamp('PHC_DATEFIN');
      iPHC_REPRISE := GetNumChamp('PHC_REPRISE');
      iPHC_CUMULPAIE := GetNumChamp('PHC_CUMULPAIE');
      iPHC_MONTANT := GetNumChamp('PHC_MONTANT');
      iPHC_TRAVAILN1 := GetNumChamp('PHC_TRAVAILN1');
      iPHC_TRAVAILN2 := GetNumChamp('PHC_TRAVAILN2');
      iPHC_TRAVAILN3 := GetNumChamp('PHC_TRAVAILN3');
      iPHC_TRAVAILN4 := GetNumChamp('PHC_TRAVAILN4');
      iPHC_CODESTAT := GetNumChamp('PHC_CODESTAT');
      iPHC_CONFIDENTIEL := GetNumChamp('PHC_CONFIDENTIEL');
      iPHC_LIBREPCMB1 := GetNumChamp('PHC_LIBREPCMB1');
      iPHC_LIBREPCMB2 := GetNumChamp('PHC_LIBREPCMB2');
      iPHC_LIBREPCMB3 := GetNumChamp('PHC_LIBREPCMB3');
      iPHC_LIBREPCMB4 := GetNumChamp('PHC_LIBREPCMB4');
    end;
end;

procedure MemorisePhb(THB: TOB);
begin
  if Assigned(THB) then
    with THB do
    begin
      iPHB_ETABLISSEMENT := GetNumChamp('PHB_ETABLISSEMENT');
      iPHB_SALARIE := GetNumChamp('PHB_SALARIE');
      iPHB_DATEDEBUT := GetNumChamp('PHB_DATEDEBUT');
      iPHB_DATEFIN := GetNumChamp('PHB_DATEFIN');
      iPHB_NATURERUB := GetNumChamp('PHB_NATURERUB');
      iPHB_RUBRIQUE := GetNumChamp('PHB_RUBRIQUE');
      iPHB_LIBELLE := GetNumChamp('PHB_LIBELLE');
      iPHB_IMPRIMABLE := GetNumChamp('PHB_IMPRIMABLE');
      iPHB_TAUXREM := GetNumChamp('PHB_TAUXREM');
      iPHB_COEFFREM := GetNumChamp('PHB_COEFFREM');
      iPHB_TAUXSALARIAL := GetNumChamp('PHB_TAUXSALARIAL');
      iPHB_TAUXPATRONAL := GetNumChamp('PHB_TAUXPATRONAL');
      iPHB_BASEREMIMPRIM := GetNumChamp('PHB_BASEREMIMPRIM');
      iPHB_TAUXREMIMPRIM := GetNumChamp('PHB_TAUXREMIMPRIM');
      iPHB_COEFFREMIMPRIM := GetNumChamp('PHB_COEFFREMIMPRIM');
      iPHB_BASECOTIMPRIM := GetNumChamp('PHB_BASECOTIMPRIM');
      iPHB_TAUXSALIMPRIM := GetNumChamp('PHB_TAUXSALIMPRIM');
      iPHB_TAUXPATIMPRIM := GetNumChamp('PHB_TAUXPATIMPRIM');
      iPHB_ORGANISME := GetNumChamp('PHB_ORGANISME');
      iPHB_TAUXAT := GetNumChamp('PHB_TAUXAT');
      iPHB_PLAFOND := GetNumChamp('PHB_PLAFOND');
      iPHB_PLAFOND1 := GetNumChamp('PHB_PLAFOND1');
      iPHB_PLAFOND2 := GetNumChamp('PHB_PLAFOND2');
      iPHB_PLAFOND3 := GetNumChamp('PHB_PLAFOND3');
      iPHB_CONSERVATION := GetNumChamp('PHB_CONSERVATION');
      iPHB_ORDREETAT := GetNumChamp('PHB_ORDREETAT');
      iPHB_SENSBUL := GetNumChamp('PHB_SENSBUL');
      iPHB_ORIGINELIGNE := GetNumChamp('PHB_ORIGINELIGNE');
      iPHB_ORIGINEINFO := GetNumChamp('PHB_ORIGINEINFO');
      iPHB_TRAVAILN1 := GetNumChamp('PHB_TRAVAILN1');
      iPHB_TRAVAILN2 := GetNumChamp('PHB_TRAVAILN2');
      iPHB_TRAVAILN3 := GetNumChamp('PHB_TRAVAILN3');
      iPHB_TRAVAILN4 := GetNumChamp('PHB_TRAVAILN4');
      iPHB_CODESTAT := GetNumChamp('PHB_CODESTAT');
      iPHB_CONFIDENTIEL := GetNumChamp('PHB_CONFIDENTIEL');
      iPHB_LIBREPCMB1 := GetNumChamp('PHB_LIBREPCMB1');
      iPHB_LIBREPCMB2 := GetNumChamp('PHB_LIBREPCMB2');
      iPHB_LIBREPCMB3 := GetNumChamp('PHB_LIBREPCMB3');
      iPHB_LIBREPCMB4 := GetNumChamp('PHB_LIBREPCMB4');
      iPHB_BASEREM := GetNumChamp('PHB_BASEREM');
      iPHB_MTREM := GetNumChamp('PHB_MTREM');
      iPHB_BASECOT := GetNumChamp('PHB_BASECOT');
      iPHB_MTSALARIAL := GetNumChamp('PHB_MTSALARIAL');
      iPHB_MTPATRONAL := GetNumChamp('PHB_MTPATRONAL');
      iPHB_TRANCHE1 := GetNumChamp('PHB_TRANCHE1');
      iPHB_TRANCHE2 := GetNumChamp('PHB_TRANCHE2');
      iPHB_TRANCHE3 := GetNumChamp('PHB_TRANCHE3');
      iPHB_ORDREETAT := GetNumChamp('PHB_ORDREETAT');
    end;
end;

procedure MemorisePcl(TRechCum: TOB);
begin
  with TRechCum do
  begin
    iPCL_ALIMCUMUL := GetNumChamp('PCL_ALIMCUMUL');
    iPCL_ALIMCUMULCOT := GetNumChamp('PCL_ALIMCUMULCOT');
    iPCL_COEFFAFFECT := GetNumChamp('PCL_COEFFAFFECT');
  end;
end;

procedure MemorisePcr(TRechRub: TOB);
begin
  with TRechRub do
  begin
    iPCR_CUMULPAIE := GetNumChamp('PCR_CUMULPAIE');
    iPCR_SENS := GetNumChamp('PCR_SENS');
  end;
end;

procedure MemorisePct(UneCot: TOB);
begin
  with UneCot do
  begin
    iPCT_IMPRIMABLE := GetNumChamp('PCT_IMPRIMABLE');
    iPCT_BASEIMP := GetNumChamp('PCT_BASEIMP');
    iPCT_TXSALIMP := GetNumChamp('PCT_TXSALIMP');
    iPCT_ORGANISME := GetNumChamp('PCT_ORGANISME');
    iPCT_ORDREETAT := GetNumChamp('PCT_ORDREETAT');
    iPCT_LIBELLE := GetNumChamp('PCT_LIBELLE');
    iPCT_DU := GetNumChamp('PCT_DU');
    iPCT_AU := GetNumChamp('PCT_AU');
    iPCT_MOIS1 := GetNumChamp('PCT_MOIS1');
    iPCT_MOIS2 := GetNumChamp('PCT_MOIS2');
    iPCT_MOIS3 := GetNumChamp('PCT_MOIS3');
    iPCT_MOIS4 := GetNumChamp('PCT_MOIS4');
    iPCT_DECBASE := GetNumChamp('PCT_DECBASE');
    iPCT_TYPEBASE := GetNumChamp('PCT_TYPEBASE');
    iPCT_TYPETAUXSAL := GetNumChamp('PCT_TYPETAUXSAL');
    iPCT_TAUXSAL := GetNumChamp('PCT_TAUXSAL');
    iPCT_DECTXSAL := GetNumChamp('PCT_DECTXSAL');
    iPCT_TYPETAUXPAT := GetNumChamp('PCT_TYPETAUXPAT');
    iPCT_TAUXPAT := GetNumChamp('PCT_TAUXPAT');
    iPCT_DECTXPAT := GetNumChamp('PCT_DECTXPAT');
    iPCT_TYPEFFSAL := GetNumChamp('PCT_TYPEFFSAL');
    iPCT_FFSAL := GetNumChamp('PCT_FFSAL');
    iPCT_DECMTSAL := GetNumChamp('PCT_DECMTSAL');
    iPCT_TYPEFFPAT := GetNumChamp('PCT_TYPEFFPAT');
    iPCT_FFPAT := GetNumChamp('PCT_FFPAT');
    iPCT_DECMTPAT := GetNumChamp('PCT_DECMTPAT');
    iPCT_TYPEMINISAL := GetNumChamp('PCT_TYPEMINISAL');
    iPCT_VALEURMINISAL := GetNumChamp('PCT_VALEURMINISAL');
    iPCT_DECMTSAL := GetNumChamp('PCT_DECMTSAL');
    iPCT_TYPEMAXISAL := GetNumChamp('PCT_TYPEMAXISAL');
    iPCT_VALEURMAXISAL := GetNumChamp('PCT_VALEURMAXISAL');
    iPCT_TYPEMINIPAT := GetNumChamp('PCT_TYPEMINIPAT');
    iPCT_VALEURMINIPAT := GetNumChamp('PCT_VALEURMINIPAT');
    iPCT_DECMTPAT := GetNumChamp('PCT_DECMTPAT');
    iPCT_TYPEMAXIPAT := GetNumChamp('PCT_TYPEMAXIPAT');
    iPCT_VALEURMAXIPAT := GetNumChamp('PCT_VALEURMAXIPAT');
    iPCT_DECMTPAT := GetNumChamp('PCT_DECMTPAT');
    iPCT_DECBASECOT := GetNumChamp('PCT_DECBASECOT');
    iPCT_SOUMISREGUL := GetNumChamp('PCT_SOUMISREGUL');
    iPCT_BASECOTISATION := GetNumChamp('PCT_BASECOTISATION');
    iPCT_TYPEPLAFOND := GetNumChamp('PCT_TYPEPLAFOND');
    iPCT_PLAFOND := GetNumChamp('PCT_PLAFOND');
    iPCT_TYPETRANCHE1 := GetNumChamp('PCT_TYPETRANCHE1');
    iPCT_TYPETRANCHE2 := GetNumChamp('PCT_TYPETRANCHE2');
    iPCT_TYPETRANCHE3 := GetNumChamp('PCT_TYPETRANCHE3');
    iPCT_TYPEREGUL := GetNumChamp('PCT_TYPEREGUL');
    iPCT_TXPATIMP := GetNumChamp('PCT_TXPATIMP');
    iPCT_TRANCHE1 := GetNumChamp('PCT_TRANCHE1');
    iPCT_TRANCHE2 := GetNumChamp('PCT_TRANCHE2');
    iPCT_TRANCHE3 := GetNumChamp('PCT_TRANCHE3');
    iPCT_ORDREAT := GetNumChamp('PCT_ORDREAT');
    iPCT_CODETRANCHE := GetNumChamp('PCT_CODETRANCHE');
    iPCT_PRESFINMOIS := GetNumChamp('PCT_PRESFINMOIS');
  end;
end;

procedure MemorisePrm(UneRem: TOB);
begin
  with UneRem do
  begin
    iPRM_IMPRIMABLE := GetNumChamp('PRM_IMPRIMABLE');
    iPRM_BASEIMPRIMABLE := GetNumChamp('iPRM_BASEIMPRIMABLE');
    iPRM_BASEIMPRIMABLE := GetNumChamp('PRM_BASEIMPRIMABLE');
    iPRM_TAUXIMPRIMABLE := GetNumChamp('PRM_TAUXIMPRIMABLE');
    iPRM_COEFFIMPRIM := GetNumChamp('PRM_COEFFIMPRIM');
    iPRM_ORDREETAT := GetNumChamp('PRM_ORDREETAT');
    iPRM_SENSBUL := GetNumChamp('PRM_SENSBUL');
    iPRM_LIBELLE := GetNumChamp('PRM_LIBELLE');
    iPRM_THEMEREM := GetNumChamp('PRM_THEMEREM');
    iPRM_DECBASE := GetNumChamp('PRM_DECBASE');
    iPRM_DECTAUX := GetNumChamp('PRM_DECTAUX');
    iPRM_DECCOEFF := GetNumChamp('PRM_DECCOEFF');
    iPRM_DECMONTANT := GetNumChamp('PRM_DECMONTANT');
  end;
end;

procedure MemorisePel(UnElt: TOB);
begin
  with UnElt do
  begin
    iChampPredefini := GetNumChamp('PEL_PREDEFINI');
    iCHampDossier := GetNumChamp('PEL_NODOSSIER');
    iCHampCodeElt := GetNumChamp('PEL_CODEELT');
    iCHampDateValidite := GetNumChamp('PEL_DATEVALIDITE');
    iCHampDecaleMois := GetNumChamp('PEL_DECALMOIS');
    iCHampMontant := GetNumChamp('PEL_MONTANT');
    iCHampMontantEuro := GetNumChamp('PEL_MONTANTEURO');
    // PT100  : 05/04/2004 PH V_50 FQ 11231 Prise en compte du cas sp�cifique Alsace Lorraine
    iChampRegimeAlsace := GetNumChamp('PEL_REGIMEALSACE');
  end;
end;

procedure MemorisePsa(Unsal: TOB);
begin
  with UnSal do
  begin
    iPSA_SALARIE := GetNumChamp('PSA_SALARIE');
    iPSA_ETABLISSEMENT := GetNumChamp('PSA_ETABLISSEMENT');
    iPSA_TRAVAILN1 := GetNumChamp('PSA_TRAVAILN1');
    iPSA_TRAVAILN2 := GetNumChamp('PSA_TRAVAILN2');
    iPSA_TRAVAILN3 := GetNumChamp('PSA_TRAVAILN3');
    iPSA_TRAVAILN4 := GetNumChamp('PSA_TRAVAILN4');
    iPSA_CODESTAT := GetNumChamp('PSA_CODESTAT');
    iPSA_LIBREPCMB1 := GetNumChamp('PSA_LIBREPCMB1');
    iPSA_LIBREPCMB2 := GetNumChamp('PSA_LIBREPCMB2');
    iPSA_LIBREPCMB3 := GetNumChamp('PSA_LIBREPCMB3');
    iPSA_LIBREPCMB4 := GetNumChamp('PSA_LIBREPCMB4');
    iPSA_CONFIDENTIEL := GetNumChamp('PSA_CONFIDENTIEL');
    iPSA_TAUXHORAIRE := GetNumChamp('PSA_TAUXHORAIRE');
    iPSA_SALAIREMOIS1 := GetNumChamp('PSA_SALAIREMOIS1');
    iPSA_SALAIREMOIS2 := GetNumChamp('PSA_SALAIREMOIS2');
    iPSA_SALAIREMOIS3 := GetNumChamp('PSA_SALAIREMOIS3');
    iPSA_SALAIREMOIS4 := GetNumChamp('PSA_SALAIREMOIS4');
    iPSA_SALAIREMOIS5 := GetNumChamp('PSA_SALAIREMOIS5');
    iPSA_SALAIRANN1 := GetNumChamp('PSA_SALAIRANN1');
    iPSA_SALAIRANN2 := GetNumChamp('PSA_SALAIRANN2');
    iPSA_SALAIRANN3 := GetNumChamp('PSA_SALAIRANN3');
    iPSA_SALAIRANN4 := GetNumChamp('PSA_SALAIRANN4');
    iPSA_SALAIRANN5 := GetNumChamp('PSA_SALAIRANN5');
    iPSA_DATENAISSANCE := GetNumChamp('PSA_DATENAISSANCE');
    iPSA_DATEENTREE := GetNumChamp('PSA_DATEENTREE');
    iPSA_DATESORTIE := GetNumChamp('PSA_DATESORTIE');
    iPSA_TYPPROFILREM := GetNumChamp('PSA_TYPPROFILREM');
    iPSA_PROFILREM := GetNumChamp('PSA_PROFILREM');
    iPSA_TYPPROFIL := GetNumChamp('PSA_TYPPROFIL');
    iPSA_PROFIL := GetNumChamp('PSA_PROFIL');
    iPSA_TYPPERIODEBUL := GetNumChamp('PSA_TYPPERIODEBUL');
    iPSA_PERIODBUL := GetNumChamp('PSA_PERIODBUL');
    iPSA_TYPPROFILRBS := GetNumChamp('PSA_TYPPROFILRBS');
    iPSA_PROFILRBS := GetNumChamp('PSA_PROFILRBS');
    iPSA_TYPREDREPAS := GetNumChamp('PSA_TYPREDREPAS');
    iPSA_REDREPAS := GetNumChamp('PSA_REDREPAS');
    iPSA_TYPREDRTT1 := GetNumChamp('PSA_TYPREDRTT1');
    iPSA_REDRTT1 := GetNumChamp('PSA_REDRTT1');
    iPSA_TYPREDRTT2 := GetNumChamp('PSA_TYPREDRTT2');
    iPSA_REDRTT2 := GetNumChamp('PSA_REDRTT2');
    iPSA_PROFILTPS := GetNumChamp('PSA_PROFILTPS');
    iPSA_TYPPROFILAFP := GetNumChamp('PSA_TYPPROFILAFP');
    iPSA_PROFILAFP := GetNumChamp('PSA_PROFILAFP');
    iPSA_TYPPROFILAPP := GetNumChamp('PSA_TYPPROFILAPP');
    iPSA_PROFILAPP := GetNumChamp('PSA_PROFILAPP');
    iPSA_TYPPROFILRET := GetNumChamp('PSA_TYPPROFILRET');
    iPSA_PROFILRET := GetNumChamp('PSA_PROFILRET');
    iPSA_TYPPROFILMUT := GetNumChamp('PSA_TYPPROFILMUT');
    iPSA_PROFILMUT := GetNumChamp('PSA_PROFILMUT');
    iPSA_TYPPROFILPRE := GetNumChamp('PSA_TYPPROFILPRE');
    iPSA_PROFILPRE := GetNumChamp('PSA_PROFILPRE');
    iPSA_TYPPROFILTSS := GetNumChamp('PSA_TYPPROFILTSS');
    iPSA_PROFILTSS := GetNumChamp('PSA_PROFILTSS');
    iPSA_TYPPROFILCGE := GetNumChamp('PSA_TYPPROFILCGE');
    iPSA_PROFILCGE := GetNumChamp('PSA_PROFILCGE');
    iPSA_PROFILCDD := GetNumChamp('PSA_PROFILCDD');
    iPSA_PROFILMUL := GetNumChamp('PSA_PROFILCDD');
    iPSA_TYPPROFILFNAL := GetNumChamp('PSA_TYPPROFILFNAL');
    iPSA_PROFILFNAL := GetNumChamp('PSA_PROFILFNAL');
    iPSA_TYPPROFILTRANS := GetNumChamp('PSA_TYPPROFILTRANS');
    iPSA_PROFILTRANS := GetNumChamp('PSA_PROFILTRANS');
    iPSA_TYPPROFILANC := GetNumChamp('PSA_TYPPROFILANC');
    iPSA_PROFILANCIEN := GetNumChamp('PSA_PROFILANCIEN');
    iPSA_LIBELLE := GetNumChamp('PSA_LIBELLE');
    iPSA_PRENOM := GetNumChamp('PSA_PRENOM');
    iPSA_NUMEROSS := GetNumChamp('PSA_NUMEROSS');
    iPSA_ADRESSE1 := GetNumChamp('PSA_ADRESSE1');
    iPSA_ADRESSE2 := GetNumChamp('PSA_ADRESSE2');
    iPSA_ADRESSE3 := GetNumChamp('PSA_ADRESSE3');
    iPSA_CODEPOSTAL := GetNumChamp('PSA_CODEPOSTAL');
    iPSA_VILLE := GetNumChamp('PSA_VILLE');
    iPSA_INDICE := GetNumChamp('PSA_INDICE');
    iPSA_NIVEAU := GetNumChamp('PSA_NIVEAU');
    iPSA_CONVENTION := GetNumChamp('PSA_CONVENTION');
    iPSA_CODEEMPLOI := GetNumChamp('PSA_CODEEMPLOI');
    iPSA_AUXILIAIRE := GetNumChamp('PSA_AUXILIAIRE');
    iPSA_DATEANCIENNETE := GetNumChamp('PSA_DATEANCIENNETE');
    iPSA_QUALIFICATION := GetNumChamp('PSA_QUALIFICATION');
    iPSA_COEFFICIENT := GetNumChamp('PSA_COEFFICIENT');
    iPSA_LIBELLEEMPLOI := GetNumChamp('PSA_LIBELLEEMPLOI');
    iPSA_CIVILITE := GetNumChamp('PSA_CIVILITE');
    iPSA_CPACQUISMOIS := GetNumChamp('PSA_CPACQUISMOIS');
    iPSA_NBREACQUISCP := GetNumChamp('PSA_NBREACQUISCP');
    iPSA_TYPDATPAIEMENT := GetNumChamp('PSA_TYPDATPAIEMENT');
    iPSA_MOISPAIEMENT := GetNumChamp('PSA_MOISPAIEMENT');
    iPSA_JOURPAIEMENT := GetNumChamp('PSA_JOURPAIEMENT');
    iPSA_TYPREGLT := GetNumChamp('PSA_TYPREGLT');
    iPSA_PGMODEREGLE := GetNumChamp('PSA_PGMODEREGLE');
    iPSA_REGULANCIEN := GetNumChamp('PSA_REGULANCIEN');
    iPSA_HORHEBDO := GetNumChamp('PSA_HORHEBDO');
    iPSA_HORAIREMOIS := GetNumChamp('PSA_HORAIREMOIS');
    iPSA_HORANNUEL := GetNumChamp('PSA_HORANNUEL');
    iPSA_PERSACHARGE := GetNumChamp('PSA_PERSACHARGE');
    iPSA_PCTFRAISPROF := GetNumChamp('PSA_PCTFRAISPROF');
    iPSA_MULTIEMPLOY := GetNumChamp('PSA_MULTIEMPLOY');
    iPSA_SALAIREMULTI := GetNumChamp('PSA_SALAIREMULTI');
    iPSA_ORDREAT := GetNumChamp('PSA_ORDREAT');
    iPSA_SALAIRETHEO := GetNumChamp('PSA_SALAIRETHEO');
    iPSA_DATELIBRE1 := GetNumChamp('PSA_DATELIBRE1');
    iPSA_DATELIBRE2 := GetNumChamp('PSA_DATELIBRE2');
    iPSA_DATELIBRE3 := GetNumChamp('PSA_DATELIBRE3');
    iPSA_DATELIBRE4 := GetNumChamp('PSA_DATELIBRE4');
    iPSA_VALANCCP := GetNumChamp('PSA_VALANCCP');
    iPSA_ANCIENNETE := GetNumChamp('PSA_ANCIENNETE');
    iPSA_CALENDRIER := GetNumChamp('PSA_CALENDRIER');
    iPSA_STANDCALEND := GetNumChamp('PSA_STANDCALEND');
    iPSA_BOOLLIBRE1 := GetNumChamp('PSA_BOOLLIBRE1');
    iPSA_BOOLLIBRE2 := GetNumChamp('PSA_BOOLLIBRE2');
    iPSA_BOOLLIBRE3 := GetNumChamp('PSA_BOOLLIBRE3');
    iPSA_BOOLLIBRE4 := GetNumChamp('PSA_BOOLLIBRE4');
    iPSA_DADSPROF := GetNumChamp('PSA_DADSPROF');
    iPSA_DADSCAT := GetNumChamp('PSA_DADSCAT');
    iPSA_TAUXPARTIEL := GetNumChamp('PSA_TAUXPARTIEL');
    iPSA_CPTYPEMETHOD := GetNumChamp('PSA_CPTYPEMETHOD');
    iPSA_VALORINDEMCP := GetNumChamp('PSA_VALORINDEMCP');
    iPSA_CPTYPEVALO := GetNumChamp('PSA_CPTYPEVALO');
    iPSA_MVALOMS := GetNumChamp('PSA_MVALOMS');
    iPSA_VALODXMN := GetNumChamp('PSA_VALODXMN');
    iPSA_CPACQUISANC := GetNumChamp('PSA_CPACQUISANC');
    iPSA_BASANCCP := GetNumChamp('PSA_BASANCCP');
    iPSA_VALANCCP := GetNumChamp('PSA_VALANCCP');
    iPSA_DATANC := GetNumChamp('PSA_DATANC');
    iPSA_TYPDATANC := GetNumChamp('PSA_TYPDATANC');
    iPSA_DATEACQCPANC := GetNumChamp('PSA_DATEACQCPANC');
    iPSA_NBRECPSUPP := GetNumChamp('PSA_NBRECPSUPP');
    iPSA_CPTYPERELIQ := GetNumChamp('PSA_CPTYPERELIQ');
    iPSA_RELIQUAT := GetNumChamp('PSA_RELIQUAT');
    iPSA_SORTIEDEFINIT := GetNumChamp('PSA_SORTIEDEFINIT');
    iPSA_SEXE := GetNumChamp('PSA_SEXE');
    IPSA_CONDEMPLOI := GetNumChamp('PSA_CONDEMPLOI');
    iPSA_CONGESPAYES := GetNumChamp('PSA_CONGESPAYES'); { PT100-1 }
    iPSA_CPACQUISSUPP := GetNumChamp('PSA_CPACQUISSUPP'); { PT100-2 }
    iPSA_ANCIENPOSTE := GetNumChamp('PSA_ANCIENPOSTE'); // PT110
  end;
end;

function NumChampTobS(const zz: string; const Ind: Integer): Integer;
var
  ii: Integer;
begin
  if zz = 'OR' then
  begin
    case ind of
      1: ii := iPSA_TRAVAILN1;
      2: ii := iPSA_TRAVAILN2;
      3: ii := iPSA_TRAVAILN3;
      4: ii := iPSA_TRAVAILN4;
    end;
  end
  else
  begin
    if zz = 'TC' then
    begin
      case ind of
        1: ii := iPSA_LIBREPCMB1;
        2: ii := iPSA_LIBREPCMB2;
        3: ii := iPSA_LIBREPCMB3;
        4: ii := iPSA_LIBREPCMB4;
      end;
    end
    else
    begin
      if zz = 'DT' then
      begin
        case ind of
          1: ii := iPSA_DATELIBRE1;
          2: ii := iPSA_DATELIBRE2;
          3: ii := iPSA_DATELIBRE3;
          4: ii := iPSA_DATELIBRE4;
        end;
      end;
    end;
  end;
  result := ii; // PT119 Affectation de la valeur trouv�e
end;

function NumChampProfS(const Ch: string): Integer;
var
  ii: Integer;
begin
  if Ch = 'PSA_PROFILREM' then result := iPSA_PROFILREM
  else if Ch = 'PSA_PROFIL' then result := iPSA_PROFIL
  else if Ch = 'PSA_PERIODBUL' then result := iPSA_PERIODBUL
  else if Ch = 'PSA_PROFILRBS' then result := iPSA_PROFILRBS
  else if Ch = 'PSA_REDREPAS' then result := iPSA_REDREPAS
  else if Ch = 'PSA_REDRTT1' then result := iPSA_REDRTT1
  else if Ch = 'PSA_REDRTT2' then result := iPSA_REDRTT2
  else if Ch = 'PSA_PROFILTPS' then result := iPSA_PROFILTPS
  else if Ch = 'PSA_PROFILAFP' then result := iPSA_PROFILAFP
  else if Ch = 'PSA_PROFILAPP' then result := iPSA_PROFILAPP
  else if Ch = 'PSA_PROFILRET' then result := iPSA_PROFILRET
  else if Ch = 'PSA_PROFILMUT' then result := iPSA_PROFILMUT
  else if Ch = 'PSA_PROFILPRE' then result := iPSA_PROFILPRE
  else if Ch = 'PSA_PROFILTSS' then result := iPSA_PROFILTSS
  else if Ch = 'PSA_PROFILCGE' then result := iPSA_PROFILCGE
  else if Ch = 'PSA_PROFILCDD' then result := iPSA_PROFILCDD
  else if Ch = 'PSA_PROFILMUL' then result := iPSA_PROFILMUL
  else if Ch = 'PSA_PROFILFNAL' then result := iPSA_PROFILFNAL
  else if Ch = 'PSA_PROFILTRANS' then result := iPSA_PROFILTRANS
  else if Ch = 'PSA_PROFILANCIEN' then result := iPSA_PROFILANCIEN
  else result := -1;
end;
// d PT103 IJSS
{$IFNDEF CCS3}

procedure AnnuleIJSSBulletin(const CodeSalarie: string; const DateF: tdatetime);
begin
  Executesql('UPDATE REGLTIJSS SET PRI_DATEINTEGR = "' + DateToStr(IDate1900) + '" ' +
    'WHERE PRI_SALARIE="' + CodeSalarie + '" AND ' +
    'PRI_DATEINTEGR = "' + usdatetime(Datef) + '"');
end;
{$ENDIF}
// f PT103 IJSS

// d PT121 Maintien
{$IFNDEF CCS3}

procedure AnnuleMaintienBulletin(const CodeSalarie: string; const DateD, DateF: tdatetime);
begin
  Executesql('DELETE FROM MAINTIEN ' +
    'WHERE PMT_SALARIE="' + CodeSalarie + '" AND ' +
    '((PMT_DATEDEBUT = "' + usdatetime(DateD) + '" AND ' +
    'PMT_DATEFIN = "' + usdatetime(DateF) + '") OR ' +
    '(PMT_DATEDEBUT = "' + usdatetime(2) + '" AND ' +
    'PMT_DATEFIN = "' + usdatetime(2) + '"))');
end;
{$ENDIF}
// f PT121 Maintien
{$IFNDEF CCS3}
// d PT124
procedure EcritCommMaint(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const RubMaintien, NatRub: string);
var
  Thh, TR: tob;
  libelle : string;
begin
  TR := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [RubMaintien], FALSE);
  THH := TOB.create('HISTOBULLETIN', Tob_Rub, -1);
  THH.PutValue('PHB_RUBRIQUE', RubMaintien + '.' + IntToStr(i));
  THH.PutValue('PHB_NATURERUB', Natrub);
  THH.PutValue('PHB_DATEDEBUT', DateD);
  THH.PutValue('PHB_DATEFIN', DateF);
  THH.PutValue('PHB_ETABLISSEMENT', Salarie.GetValeur(iPSA_ETABLISSEMENT));
  THH.PutValue('PHB_SALARIE', Salarie.GetValeur(iPSA_SALARIE));
  THH.PutValue('PHB_BASEREM', 0);
  THH.PutValue('PHB_TAUXREM', 0);
  THH.PutValue('PHB_COEFFREM', 0);
  THH.PutValue('PHB_MTREM', 0);
  THH.PutValue('PHB_CONSERVATION', 'BUL');
  libelle := DateToStr(T.GetValue('PMT_DATEDEBUTABS'))+
             ' au '+
             DateToStr(T.GetValue('PMT_DATEFINABS'))+
             ' � '+
             FloatToStrF(T.GetValue('PMT_PCTMAINTIEN'),ffNumber,20,2)+
             '%';
  if (T.GetValue('PMT_TYPECONGE') = 'NET') or
     (T.GetValue('PMT_TYPECONGE') = 'BRU') then
  begin
    libelle := Trim(T.GetValue('PMT_LIBELLE')) +
               ' '+
               FloatToStrF(T.GetValue('PMT_MTMAINTIEN'),ffNumber,20,2) ;
  end;
  THH.PutValue('PHB_LIBELLE', libelle);
  THH.PutValue('PHB_ORIGINELIGNE', 'MAI');
  THH.PutValue('PHB_IMPRIMABLE', 'X');
  THH.PutValue('PHB_TRAVAILN2', Salarie.GetValeur(iPSA_TRAVAILN2));
  THH.PutValue('PHB_TRAVAILN3', Salarie.GetValeur(iPSA_TRAVAILN3));
  THH.PutValue('PHB_TRAVAILN4', Salarie.GetValeur(iPSA_TRAVAILN4));
  THH.PutValue('PHB_TRAVAILN1', Salarie.GetValeur(iPSA_TRAVAILN1));
  THH.PutValue('PHB_CODESTAT', Salarie.GetValeur(iPSA_CODESTAT));
  THH.PutValue('PHB_LIBREPCMB1', Salarie.GetValeur(iPSA_LIBREPCMB1));
  THH.PutValue('PHB_LIBREPCMB2', Salarie.GetValeur(iPSA_LIBREPCMB2));
  THH.PutValue('PHB_LIBREPCMB3', Salarie.GetValeur(iPSA_LIBREPCMB3));
  THH.PutValue('PHB_LIBREPCMB4', Salarie.GetValeur(iPSA_LIBREPCMB4));
  THH.PutValue('PHB_CONFIDENTIEL', Salarie.GetValeur(iPSA_CONFIDENTIEL));

  if TR <> nil then
      THH.PutValue('PHB_ORDREETAT', TR.GetValue('PRM_ORDREETAT'));
    i := i + 1;
end;
// f PT124
// d PT129
procedure EcritCommIJ(Tob_rub, Salarie, t: tob; var i: integer; const DateD, Datef: tdatetime; const RubIJ, NatRub: string);
var
  Thh, TR: tob;
  libelle : string;
begin
  TR := TOB_Rem.FindFirst(['PRM_RUBRIQUE'], [RubIJ], FALSE);
  THH := TOB.create('HISTOBULLETIN', Tob_Rub, -1);
  THH.PutValue('PHB_RUBRIQUE', RubIJ + '.' + IntToStr(i));
  THH.PutValue('PHB_NATURERUB', Natrub);
  THH.PutValue('PHB_DATEDEBUT', DateD);
  THH.PutValue('PHB_DATEFIN', DateF);
  THH.PutValue('PHB_ETABLISSEMENT', Salarie.GetValeur(iPSA_ETABLISSEMENT));
  THH.PutValue('PHB_SALARIE', Salarie.GetValeur(iPSA_SALARIE));
  THH.PutValue('PHB_BASEREM', 0);
  THH.PutValue('PHB_TAUXREM', 0);
  THH.PutValue('PHB_COEFFREM', 0);
  THH.PutValue('PHB_MTREM', 0);
  THH.PutValue('PHB_CONSERVATION', 'BUL');
  libelle := 'IJSS du '+
             DateToStr(T.GetValue('PRI_DATEDEBUTABS'))+
             ' au '+
             DateToStr(T.GetValue('PRI_DATEFINABS'));

  THH.PutValue('PHB_LIBELLE', libelle);
  THH.PutValue('PHB_ORIGINELIGNE', 'IJS');
  THH.PutValue('PHB_IMPRIMABLE', 'X');
  THH.PutValue('PHB_TRAVAILN2', Salarie.GetValeur(iPSA_TRAVAILN2));
  THH.PutValue('PHB_TRAVAILN3', Salarie.GetValeur(iPSA_TRAVAILN3));
  THH.PutValue('PHB_TRAVAILN4', Salarie.GetValeur(iPSA_TRAVAILN4));
  THH.PutValue('PHB_TRAVAILN1', Salarie.GetValeur(iPSA_TRAVAILN1));
  THH.PutValue('PHB_CODESTAT', Salarie.GetValeur(iPSA_CODESTAT));
  THH.PutValue('PHB_LIBREPCMB1', Salarie.GetValeur(iPSA_LIBREPCMB1));
  THH.PutValue('PHB_LIBREPCMB2', Salarie.GetValeur(iPSA_LIBREPCMB2));
  THH.PutValue('PHB_LIBREPCMB3', Salarie.GetValeur(iPSA_LIBREPCMB3));
  THH.PutValue('PHB_LIBREPCMB4', Salarie.GetValeur(iPSA_LIBREPCMB4));
  THH.PutValue('PHB_CONFIDENTIEL', Salarie.GetValeur(iPSA_CONFIDENTIEL));

  if TR <> nil then
      THH.PutValue('PHB_ORDREETAT', TR.GetValue('PRM_ORDREETAT'));
    i := i + 1;
end;
procedure EnleveCommIJ(Salarie, Tob_rub: tob; const Arub, Natrub: string; const dated, datef: tdatetime);
var
  t: tob;
begin
  // PT14 : 23/10/01 : V562 : PH Rajout traitement bulletion compl�mentaire et dates �dition
  if BullCompl = 'X' then exit;

  T := Tob_Rub.FindFirst(['PHB_NATURERUB', 'PHB_DATEDEBUT', 'PHB_DATEFIN', 'PHB_SALARIE'],
    [Natrub, DateD, DateF, Salarie.GetValeur(iPSA_SALARIE)], TRUE);
  while T <> nil do
  begin
    if ((copy(T.GetValue('PHB_RUBRIQUE'), 1, length(ARub) + 1) = ARub + '.') and
      (T.GetValue('PHB_ORIGINELIGNE') = 'IJS')) then
      T.free;
    T := Tob_Rub.FindNext(['PHB_NATURERUB', 'PHB_DATEDEBUT', 'PHB_DATEFIN', 'PHB_SALARIE'],
      [Natrub, DateD, DateF, Salarie.GetValeur(iPSA_SALARIE)], TRUE);
  end;

end;
// f PT129
{$ENDIF}
end.

