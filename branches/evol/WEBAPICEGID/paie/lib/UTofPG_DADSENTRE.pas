{***********UNITE*************************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/10/2001
Modifi� le ... : 28/03/2002
Description .. : Unit� de gestion de la fiche de gestion de param�trage
Suite ........ : ent�te entreprise
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
{
PT1   : 08/01/2002 PH V571 Suppression des procedures suivantes :
                           LibereTOBENVOI
                           ChargeTOBENVOI
                           CreeEnvoi
                           qui sont d�plac�s dans Pg_OutilsEnvoi.pas
PT2   : 18/01/2002 VG V571 Remplacement de PGAnnee par PGExercice car le nombre
                           de salari�s pr�sents au 31/12 �tait toujours � 0
PT3   : 30/01/2002 VG V571 Dans le cas de l'alimentation pour un message TDS ou
                           BTP, on force l'alimentation du segment r�gime
                           compl�mentaire � 90000
PT4-1 : 01/02/2002 VG V571 Correction du PT3 qui cr�ait des �l�ments parasites
                           dans la table ENVOISOCIAL
PT4-2 : 01/02/2002 VG V571 Correction pour que le nombre d'enregistrements
                           compt�s
PT5-1 : 04/02/2002 VG V571 Dans le cas de fichier DADSU compl�te ou IRC, on
                           force la pr�sence de l'enregistrement S44
PT5-2 : 04/02/2002 VG V571 On tronque certains enregistrements pour qu'ils
                           respectent la longueur max
PT6-1 : 05/02/2002 VG V571 Ajout d'une barre de patience pendant la construction
                           du pr�-fichier
PT6-2 : 05/02/2002 VG V571 On tronque l'adresse de l'�tablissement
PT6-3 : 05/02/2002 VG V571 Dans le cas de fichier DADSU compl�te ou IRC, on ne
                           force pas la pr�sence de l'enregistrement S44 si il
                           existe un enregistrement S41.G01.01 � 90000
PT7   : 26/02/2002 VG V571 Dans le cas ou on a d�pass� le dernier enregistrement
                           de la TOB, on n'utilise plus la TOB sinon plantage .
                           Ce plantage ne se produit que dans le cas de la
                           g�n�ration du fichier pour TDS seul
PT8   : 26/02/2002 VG V571 Modifications pour la g�n�ration du fichier BTP
PT9   : 12/03/2002 VG V571 Idem PT7
PT10  : 20/03/2002 VG V571 Modification du calcul de la taille du fichier
PT11-1: 28/03/2002 VG V571 Modification du nom du pr�-fichier pour g�n�ration
                           BTP
PT11-2: 28/03/2002 VG V571 Modification de la fonction de cr�ation
                           d'enregistrement dans la table ENVOISOCIAL
PT12-1: 10/04/2002 VG V571 Le num�ro d'ordre n'�tait pas incr�ment� pour la
                           cr�ation d'enregistrements dans la table ENVOISOCIAL
PT12-2: 10/04/2002 VG V571 Dans la table ENVOISOCIAL, on ne cr�e plus les
                           enregistrements avec le code institution '90000'
PT13  : 11/04/2002 VG V571 Si on ne g�re pas les prud'hommes dans le fichier, on
                           ne cr�e pas l'enregistrement du code de la section
                           prud'homale d'�tablissement
PT14  : 10/06/2002 VG V582 Au moment de la g�n�ration du pr�-fichier, cr�ation
                           des �tablissements dont les salari�s sont contenus
                           dans le fichier (cas du fractionnement ou le fichier
                           contenait tous les �tablissements ayant des salari�s)
PT15  : 15/07/2002 VG V585 Adaptation cahier des charges V6R02
PT16  : 20/08/2002 VG V585 Le contr�le sur les �l�ments entreprise (S20) est
                           d�sormais bloquant
PT17  : 02/09/2002 VG V585 Ajout de contr�les par rapport � la longueur,
                           segments obligatoires et coh�rence des donn�es
PT18  : 18/09/2002 VG V585 Dans le cas d'une d�claration IRC, on enl�ve les
                           enregistrements S41.G01.05 et S41.G01.06                           
PT19  : 26/11/2002 VG V591 Si la derni�re p�riode du dernier salari� avait comme
                           dernier enregistrement un r�gime compl�mentaire (pas
                           d'alimentation de la pr�voyance), la g�n�ration du
                           pr�-fichier entrainait un plantage
PT20  : 27/11/2002 VG V591 Si les SIRETs ne sont pas renseign�s dans les
                           param�tres soci�t�, on ne pouvait pas g�n�rer le
                           fichier (m�me si on les renseignait dans la fiche de
                           param�trage de la DADS-U Entreprise)
PT21  : 14/01/2003 VG V591 Pour une meilleure compr�hension des anomalies
                           rencontr�es lors de la g�n�ration du pr�-fichier, on
                           affiche dor�navant le libell� du segment
PT22  : 29/01/2003 VG V591 Avant la pr�paration du pr�-fichier, si les
                           honoraires n'ont pas �t� coch�es, on affiche un
                           message de confirmation - FQ N�10468
PT23-1: 12/03/2003 VG V_42 Tous les champs (obligatoires ou non) doivent �tre
                           diff�rents de ''                           
PT23-2: 17/03/2003 VG V_42 En DADS-U compl�te et DADS-U IRC, si le segment
                           S41.G01.01.001 est � "90000", absence de structure
                           S44 . Par contre, si le segment S41.G01.01.001 est
                           diff�rent de "90000", obligation d'avoir une
                           structure S44 - FQ N�10571
PT24-1: 26/03/2003 VG V_42 Alimentation de la zone "assujetissement � la taxe
                           sur les salaires" en fonction de "% prorata TVA"
PT24-2: 26/03/2003 VG V_42 Jointure pour ne faire qu'une seule requ�te
PT25  : 02/04/2003 VG V_42 Correction pour la DADS-U BTP : D�sactivation de la
                           coche des honoraires + ajout enregistrement
                           �tablissement
PT26-1: 17/04/2003 VG V_42 Les contr�les sont d�sormais conditionn�s au type de
                           d�claration effectu� (Exemple: on ne contr�le pas les
                           champs concernant la pr�voyance pour un fichier de
                           type TDS seul)
PT26-2: 17/04/2003 VG V_42 Contr�le du code APE - FQ N�10626
PT27  : 21/05/2003 VG V_42 Lib�ration de la m�moire allou�e par FindFirst
PT28  : 26/06/2003 PH V_42 Mise � jour DP social
PT29  : 16/09/2003 VG V_42 Adaptation cahier des charges V7R01
PT30  : 23/10/2003 VG V_42 Cr�ation du fichier interm�diaire en EAGL
PT31  : 24/10/2003 VG V_42 Ajout de contr�les lors de la pr�paration du fichier
PT32  : 07/01/2004 VG V_50 Correction du contr�le du nombre d'honoraires.
                           On compte le nombre d'honoraires pour personne
                           morale + nombre d'honoraires pour personne physique
                           FQ N�11040
PT33-1: 27/01/2004 VG V_50 Optimisation du traitement
PT33-2                     Correction du traitement qui cr�ait 2 enregistrements
                           avec le m�me pds_ordreseg (entre le
                           S80.G01.00.001.001 et le S80.G01.00.001.002)
PT34-1: 14/04/2004 VG V_50 Ajout champs ann�es dans la table DADSLEXIQUE
PT34-2:                    Le fichier .log est divis� en 2 : un pour le calcul
                           et un pour la pr�paration
PT34-3:                    Visualisation automatique du fichier .log en fin de
                           pr�paration
PT34-4:                    Gestion obligatoire de la pr�voyance dans le cas de
                           fichier IRC/IP ou IP
PT35-1: 05/07/2004 VG V_50 Adaptation cahier des charges V8R00
PT35-2: 05/07/2004 VG V_50 Ajout de contr�les
PT35-3: 05/07/2004 VG V_50 Epuration des commentaires
PT35-4: 05/07/2004 VG V_50 Optimisation du traitement
PT35-5: 05/07/2004 VG V_50 Gestion des prud'hommes
PT36  : 30/11/2004 VG V_60 Affichage de la case � cocher des prud'hommes
                           FQ N�11808
PT37  : 03/01/2005 VG V_60 Probl�me de tri des enregistrements lorsqu'on g�re
                           les donn�es prud'homales - FQ N�11877
PT38  : 27/01/2005 VG V_60 On n'ins�re que les honoraires qui ont un "montant de
                           r�mun�ration". Les honoraires ne poss�dant pas de
                           montant sont indiqu�s dans le fichier .log
                           FQ N�11928
PT39  : 02/02/2005 VG V_60 Les p�riodes d'inactivit� du dernier salari� de la
                           liste n'�taient pas reprises - FQ N�11963
PT40  : 07/10/2005 VG V_60 Adaptation cahier des charges V8R02
PT41  : 11/10/2005 VG V_60 Pour DADS-U BTP, S41.G01.01.001 aliment�
                           syst�matiquement � tort avec le code '90000'
PT42  : 18/10/2005 VG V_60 Pas de mise � jour de la table ENVOISOCIAL dans le
                           cas d'un salari� ayant une seule caisse de retraite
                           FQ N�12015
PT43  : 02/11/2005 VG V_60 R�initialisation du buffer pour ne pas r�cup�rer
                           l'adresse d'un autre �tablissement - FQ N�12661
PT44  : 24/11/2005 VG V_65 Gestion des donn�es prud'hommales obligatoire pour
                           une d�claration DADS-U compl�te ou TDS seul
                           FQ N�12708
PT45  : 01/12/2005 VG V_65 Il manquait les donn�es prud'hommales sur le dernier
                           salari� - FQ N�12708
PT46  : 20/01/2006 VG V_65 Modification du test pour l'alimentation du "code
                           �tablissement sans salari�" : Bas� d�sormais sur la
                           table DADSDETAIL au lieu de PAIEENCOURS
PT47  : 30/01/2006 VG V_65 Ajout d'une coche pour g�n�ration DADS-U N�ant
                           FQ N�12857
PT48  : 03/02/2006 VG V_65 Ajout d'institutions par type de DADS-U - FQ N�11776
PT49  : 06/02/2006 VG V_65 Ajout de l'emetteur th�orique dans la pr�paration
                           FQ N�11868
PT50  : 20/02/2006 VG V_65 Message d'erreur si fichier DAT/PREP.log non trouv�
PT51-1: 16/10/2006 VG V_70 Traitement DADS-U compl�mentaire
PT51-2: 16/10/2006 VG V_70 Utilisation d'un type pour la cle DADS-U
PT51-3: 16/10/2006 VG V_70 Mise en fonction de la cr�ation des S20
PT51-4: 16/10/2006 VG V_70 Suppression du fichier de contr�le - mise en table
                           des erreurs
PT51-5: 16/10/2006 VG V_70 Adaptation cahier des charges DADS-U V8R04
PT52  : 06/11/2006 VG V_70 Correction gestion du d�calage
PT53  : 08/11/2006 VG V_70 On ne prend plus en compte les �tablissements qui ont
                           �t� s�lectionn�s dans un pr�c�dent envoi mais qui ne
                           sont pas s�lectionn�s dans l'envoi en cours
                           FQ N�13604 et FQ N�13657
PT54  : 14/11/2006 VG V_70 Les donn�es de l'�tablissement n'�taient pas
                           r�initialis�es entre chaque calcul - FQ N�13684
PT55  : 21/11/2006 VG V_70 Permettre de d�clarer des honoraires en DADS-U
                           compl�mentaire - FQ N�13613
PT56  : 14/12/2006 VG V_70 Mauvais s�quencage des enregistrements �tablissement
                           dans le cas de pr�paration des �tablissements de
                           fa�on ind�pendante
PT57-1: 05/01/2007 VG V_72 Modification du message lors de la pr�paration DADS-U
                           dans le cas d'anomalies non bloquantes - FQ N�13813
PT57-2: 05/01/2007 VG V_72 Plantage en fin de pr�paration en cas de chemin
                           inexistant
PT58  : 26/01/2007 VG V_72 DADS-U IRCANTEC : Retraite compl�mentaire non incluse
                           FQ N�13861
PT59  : 14/02/2007 VG V_72 DADS-U TDS : Erreur de transaction en pr�paration
                           FQ N�13924
PT60  : 22/02/2007 VG V_72 Suppression des alertes concernant l'absence de
                           montants dans les honoraires. Les honoraires sans
                           montant ne sont toujours pas pris dans le fichier
PT61  : 29/06/2007 VG V_72 Fichiers en base
PT62  : 14/09/2007 MF V_80 On passe le n� de dossier en param�tre � la fonction
                           AGL__YFILESTD_IMPORT
PT62-1: 30/08/2007 VG V_80 Adaptation cahier des charges V8R05
PT62-2: 05/11/2007 VG V_80 Adaptation cahier des charges V8R06
PT63  : 20/11/2007 NA V_80 FQ 14928 R�cup�ration de l'�tablissement si�ge (et
                           non pas �tab principal)
PT64-1: 28/11/2007 VG V_80 Gestion du champ ET_FICTIF - FQ N�13925
PT64-2: 28/11/2007 VG V_80 Ecriture des rubriques fiscales � z�ro pour les
                           d�clarations qui ne sont pas compl�tes ou TDS
PT64-3: 28/11/2007 VG V_80 Ecriture correcte des donn�es �tablissement
                           saisissable sans �crasement des donn�es saisies
PT65  : 05/12/2007 VG V_80 Affichage du caract�re interdit - FQ N�14961
PT66  : 10/12/2007 VG V_80 Prise en compte des donn�es saisies - FQ N�15037
PT67-1: 11/12/2007 VG V_80 Gestion de la nature "Honoraires seuls"
PT67-2: 11/12/2007 VG V_80 Gestion du champ PDE_DADSCDC
PT68  : 22/01/2008 VG V_80 Gestion des enregistrements �tablissement pour
                           "Honoraires seuls"
PT71  : 25/03/2008 VG V_80 Corrections des DADS-U compl�mentaires
PT72  : 07/04/2008 VG V_80 Correction DADS-U BTP avec code caisse CIBTP
                           FQ N�15341
}
unit UTofPG_DADSENTRE;

interface
uses     UTOF,
         Classes,
         hctrls,
         PgDADSOutils,
         PgDADSCommun,
         ParamSoc,
         Pgoutils2,
         sysutils,
         Vierge,
{$IFNDEF EAGLCLIENT}
         {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ELSE}
{$ENDIF}
         UTOB,
         EntPaie,
         HEnt1,
         HMsgBox,
         controls,
         windows,
         ed_tools,
         hstatus,
         PGDADSControles,
         hdebug,
         UTobDebug,
{$IFNDEF DADSUSEULE}
         P5Def,
{$ENDIF}
         StdCtrls,
         uYFILESTD;

Type
      TOF_PG_DADSENTRE = Class (TOF)
      public
        procedure OnArgument (stArgument:String ); override ;

      private
        Car, Compl, Fraction, NIC, SansFichierBase, SIR, Siren, TD2 : string;
        TypeDecla : string;

        FDADS : TextFile;

        TEtabSelect : TOB;

        Neant : TCheckBox;

        procedure ChargeZones ();
        procedure Generation (Sender: TObject);
        procedure CalculEntreprise();
        procedure GenereFichier();
        procedure CreeEtab();
        procedure ControleEcritureFic (ChampSal, Segment, Nature : string;
                                       var Donnee : string);
        procedure MajDPPaie () ;
        procedure NeantChange (Sender: TObject);
     END ;

implementation
uses Pg_OutilsEnvoi;
{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/10/2001
Modifi� le ... :   /  /
Description .. :
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.OnArgument(stArgument: String);
var
Arg, StPlus : string;
begin
Inherited ;
Arg := stArgument;

SetControlText ('CEXERCICE', Trim (ReadTokenPipe (Arg, '|')));
SetControlText ('MCETAB', Trim (ReadTokenPipe (Arg, '|')));
SetControlText ('L_DDU', Trim (ReadTokenPipe (Arg, '|')));
SetControlText ('L_DAU', Trim (ReadTokenPipe (Arg, '|')));
TypeDecla:= Trim (ReadTokenPipe (Arg, '|'));
Fraction:= Trim (ReadTokenPipe (Arg, '|'));
Car:= Trim (ReadTokenPipe (Arg, '|'));
Compl:= Trim (ReadTokenPipe (Arg, '|'));
SansFichierBase:= Trim (ReadTokenPipe (Arg, '|')); //PT61

TD2:= Copy (TypeDecla, 1, 2);
SetControlText ('CTYPE', TypeDecla) ;
SetControlText ('EFRACTION', Fraction);
SetControlText ('CCAR', Car);
SetControlText ('CHCOMPL', Compl);
SetControlVisible ('CBPRUDH', True);

ErrorDADSU := 0;

{PT62-1
Comm:= THValComboBox (GetControl ('CCOMM'));
if Comm <> NIL then
   Comm.OnChange:= CommChange;
}   

Neant:= TCheckBox (GetControl ('CHNEANT'));
if (Neant<> nil) then
   Neant.OnClick:= NeantChange;

ChargeZones;

TFVierge(Ecran).BValider.OnClick := Generation;

if (TD2>='03') then
   SetControlVisible('CHHONORAIRE', False);

//PT67-1
if (TD2='12') then
   begin
   SetControlVisible ('CHHONORAIRE', True);
   SetControlText ('CHHONORAIRE', 'X');
   SetControlEnabled ('CHHONORAIRE', False);
   end;
//FIN PT67-1

if (TD2<>'01') then
   SetControlVisible('CHPREVOYANCE', False);

if ((TD2='03') or (TD2='08')) then
   SetControlText('CHPREVOYANCE', 'X');

if (TD2<'03') then
   SetControlText('CBPRUDH', 'X');

{PT67-1
if ((TD2='04') or (TD2='09')) then
}
if ((TD2='04') or (TD2='09') or (TD2='12')) then
//FIN PT67-1
   SetControlVisible ('CHNEANT', False);

if ((TD2<>'01') and (TD2<>'02')) then
   SetControlVisible ('CBPRUDH', False);

//PT64-1
StPlus:= ' WHERE ET_FICTIF<>"X"';
SetControlProperty ('CSIEGE', 'Plus', StPlus);
SetControlProperty ('CDEPOSE', 'Plus', StPlus);
SetControlProperty ('MCETAB', 'Plus', StPlus);
//FIN PT64-1
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 02/10/2001
Modifi� le ... :   /  /
Description .. : Chargement des �l�ments de la fiche
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.ChargeZones();
var
BufDest, BufOrig : string;
begin
SetControlText('ERAISONSOC', GetParamSoc('SO_LIBELLE'));

BufOrig := GetParamSoc('SO_SIRET');
ForceNumerique(BufOrig, BufDest);
if ControlSiret(BufDest)=False then
   PGIBox('Le SIRET n''est pas valide.#13#10'+
          'Vous devez le v�rifier en y acc�dant par le module#13#10'+
          'Param�tres/menu Comptabilit�/#13#10'+
          'commande Param�tres comptables/Coordonn�es.#13#10'+
          'Si vous travaillez en environnement multi-dossiers, vous#13#10'+
          'pouvez y acc�der par le Bureau PGI/Annuaire',
          'Saisie Entreprise DADS-U');

SetControlText('ESIREN', Copy(BufDest, 1, 9));
{PT63
SetControlText('CSIEGE', GetParamSoc('SO_ETABLISDEFAUT'));
}
SetControlText('CSIEGE', GetParamSoc('SO_PGCSIEGE'));
//FIN PT63
SetControlText('CDEPOSE', GetParamSoc('SO_PGCDEPOSE'));
SetControlText('ECLIENT', GetParamSoc('SO_PGNUMCLIENT'));
SetControlText('CROUTAGE', GetParamSoc('SO_PGROUTAGE'));
SetControlText('CROUTAGE1', GetParamSoc('SO_PGROUTAGE1'));
SetControlText('CROUTAGE2', GetParamSoc('SO_PGROUTAGE2'));
SetControlText('ESIRET', GetParamSoc('SO_PGSIRETDESTIN'));
SetControlText('ECOORD', GetParamSoc('SO_PGCOORDCRE'));   //PT62-1
If ControlSiret(GetControlText('ESIRET'))=False Then
   PGIBox('Le SIRET n''est pas valide','SIRET Destinataire');

{PT62-1
SetControlText('CCOMM', GetParamSoc('SO_PGCOMMCRE'));
}
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 03/10/2001
Modifi� le ... :   /  /
Description .. : Validation
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.Generation (Sender: TObject);
var
reponse : integer;
begin
reponse := mrYes;
if (GetControlText('CHNEANT')='X') then
   begin
   reponse := PGIAsk('Vous avez choisi de g�n�rer une d�claration n�ant#13#10'+
                     'Confirmez-vous ?','Pr�paration de la DADS-U');
   if reponse=mrNo then
      exit
   else
      TypeDecla:= Copy(TypeDecla, 1, 2)+'55';
   end;

if (GetControlText('CHCOMPL')='X') then
   begin
   reponse := PGIAsk('Vous avez choisi de g�n�rer une d�claration compl�mentaire#13#10'+
                     'Confirmez-vous ?','Pr�paration de la DADS-U');
   if reponse=mrNo then
      exit
   else
      TypeDecla:= Copy(TypeDecla, 1, 2)+'52';
   end;

if ((TypeDecla<'0300') and (GetControlText('CHHONORAIRE')='-') and
   (GetControlText('CHNEANT')<>'X')) then
   reponse := PGIAsk('Vous n''avez pas choisi la gestion des honoraires.#13#10'+
                     'Confirmez-vous ?','Pr�paration de la DADS-U');
if reponse=mrNo then
   exit;

CalculEntreprise;
try
   begintrans;
   if ErrorDADSU=0 then
      CreeEtab;

   if ErrorDADSU=0 then
      GenereFichier;

   FreeAndNil(TEtabSelect);

   CommitTrans;
   
   if V_PGI.ModePcl='1' then
      MajDPPaie;
Except
   Rollback;
   PGIBox ('Une erreur est survenue lors de la mise � jour de la base',
          'Pr�paration de la DADS-U');
   END;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 25/09/2001
Modifi� le ... :   /  /
Description .. : Calcul des �l�ments entreprise pour la DADSU
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.CalculEntreprise();
var
BufDest, BufOrig, Depose, nom, Siege, StEtab : string;
TEtabD : TOB;
QRechEtab : TQuery;
ParamCalc : TParamCalc;
begin
Siege:= GetControlText('CSIEGE');
Depose:= GetControlText('CDEPOSE');
Siren:= GetControlText('ESIREN');
ChargeTOBDADS;
//Remplissage d'un enregistrement entreprise
nom:= '++'+Copy (GetParamSoc('SO_LIBELLE'), 0, 15);
if ((TypeDecla>='0400') and (TypeDecla<'0500')) then
   begin
   if ((Car>='M00') and (Car <='M99')) then
      TypeD:= '005';
   if ((Car>='T00') and (Car <='T99')) then
      TypeD:= '004';
   if ((Car>='S00') and (Car <='S99')) then
      TypeD:= '003';
   if Car='A00' then
      TypeD:= '002';
   end
else
   TypeD:= '001';

if (GetControlText('CHCOMPL')='X') then
   TypeD:= '2'+Copy (TypeD, 2, 2);

DeleteDetail (nom, 0);

StEtab:= 'SELECT ET_SIRET, ET_ETABLISSEMENT, ET_LIBELLE, ET_ADRESSE1,'+
         ' ET_ADRESSE2, ET_ADRESSE3, ET_CODEPOSTAL, ET_VILLE, ET_PAYS'+
         ' FROM ETABLISS';
QRechEtab:=OpenSql(StEtab,TRUE);
TEtab := TOB.Create('Les Etablissements', NIL, -1);
TEtab.LoadDetailDB('ETABLISS','','',QRechEtab,False);
Ferme(QRechEtab);

ParamCalc.Siren:= GetControlText('ESIREN');
ParamCalc.TypeDecla:= TypeDecla;
ParamCalc.TypeD:= TypeD;
ParamCalc.Libelle:= GetParamSoc('SO_LIBELLE');
ParamCalc.Du:= GetControlText('L_DDU');
ParamCalc.Au:= GetControlText('L_DAU');
ParamCalc.Fraction:= Fraction;
ParamCalc.FractionTot:= Getparamsoc('SO_PGFRACTION');
ParamCalc.TobEtab:= TEtab;
ParamCalc.Siege:= GetControlText('CSIEGE');
ParamCalc.Depose:= GetControlText('CDEPOSE');
ParamCalc.Client:= GetControlText('ECLIENT');
ParamCalc.Siret:= GetControlText('ESIRET');
{PT62-1
ParamCalc.Communication:= GetControlText('CCOMM');
}
ParamCalc.Coordonnee:= GetControlText('ECOORD');
{PT62-1
ParamCalc.Civilite:= GetControlText('CCIVILITE');
ParamCalc.Personne:= GetControlText('EPERSONNE');
}
ParamCalc.Routage:= GetControlText('CROUTAGE');
ParamCalc.Routage1:= GetControlText('CROUTAGE1');
ParamCalc.Routage2:= GetControlText('CROUTAGE2');
ParamCalc.Caracteristique:= Car;

if (Siren <> '') then
   begin
   BufOrig:= Siren;
{PT62-2
   If ControlSiret(Siren)=False Then
}
   ForceNumerique(BufOrig, BufDest);
   If (ControlSiret(BufDest)=False) Then
//FIN PT62-2
      begin
      PGIBox ('Le SIRET de l''entreprise n''est pas valide',
              'SIRET de la soci�t�');
      ErrorDADSU:= 1;
      end;
{PT62-2
   ForceNumerique(BufOrig, BufDest);
}
   SIR := Copy(BufDest, 1, 9);
   end
else
   begin
   PGIBox('Le SIRET n''est pas renseign�', 'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

if GetParamSoc('SO_LIBELLE') = '' then
   begin
   PGIBox ('La raison sociale n''est pas renseign�e',
           'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

if (PGAnnee <> '') then
   begin
   TD2:= Copy(TypeDecla,1,2);
   if ((TD2<>'01') and (TD2<>'02') and (TD2<>'03') and (TD2<>'07') and
      (TD2<>'08')) then
      begin
      if (StrToDate(GetControlText('L_DDU'))>StrToDate(GetControlText('L_DAU'))) then
         begin
         PGIBox ('La date de d�but de p�riode est sup�rieure �#13#10'+
                 'la date de fin de p�riode', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;
      end;
   end
else
   begin
   PGIBox('L''exercice n''est pas renseign�', 'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

if (TypeDecla = '') then
   begin
   PGIBox ('Le type de d�claration n''est pas renseign�',
           'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

if ((Fraction = '') or (Getparamsoc('SO_PGFRACTION') = '')) then
   begin
   PGIBox ('La fraction n''est pas renseign�e, #13#10'+
           'soit dans les param�tres soci�t�, #13#10'+
           'soit au niveau du param�trage de l''�cran actuel',
           'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

TEtabD := TEtab.FindFirst(['ET_ETABLISSEMENT'], [Siege], TRUE);
if TEtabD <> nil then
   begin
   if TEtabD.GetValue('ET_SIRET') <> '' then
      begin
      BufOrig := TEtabD.GetValue('ET_SIRET');
      ForceNumerique(BufOrig, BufDest);
      if (Copy (BufDest, 1, 9)<> SIR) then
         begin
         PGIBox ('Le SIREN de l''�tablissement si�ge ne correspond pas#13#10'+
                 'au SIREN de l''entreprise', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;
      if ControlSiret(BufDest)=False then
         begin
         PGIBox ('Le SIRET de l''�tablissement si�ge n''est pas valide',
                 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;
      end
   else
      begin
      PGIBox ('Le SIRET de l''�tablissement si�ge n''est pas renseign�',
              'Saisie Entreprise DADS-U');
      ErrorDADSU:= 1;
      end;

   if (TEtabD.GetValue('ET_CODEPOSTAL') <> '') then
      begin
      if ((TEtabD.GetValue('ET_PAYS') = 'FRA') and
         ((TEtabD.GetValue('ET_CODEPOSTAL') < '00000') or
         (TEtabD.GetValue('ET_CODEPOSTAL') > '99999'))) then
         begin
         PGIBox ('L''adresse de l''�tablissement si�ge (Code postal)#13#10'+
                 'est mal renseign�e', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;
      end
   else
      begin
      PGIBox ('L''adresse de l''�tablissement si�ge (Code postal)#13#10'+
              'est mal renseign�e', 'Saisie Entreprise DADS-U');
      ErrorDADSU:= 1;
      end;

   if TEtabD.GetValue('ET_VILLE') = '' then
      begin
      PGIBox ('L''adresse de l''�tablissement si�ge (Ville) est mal renseign�e',
              'Saisie Entreprise DADS-U');
      ErrorDADSU:= 1;
      end;
   end;

if Depose <> Siege then
   begin
   TEtabD := TEtab.FindFirst(['ET_ETABLISSEMENT'], [Depose], TRUE);
   if TEtabD <> nil then
      begin
      BufOrig:= TEtabD.GetValue('ET_SIRET');
      ForceNumerique(BufOrig, BufDest);
      if (Copy (BufDest, 1, 9)<> SIR) then
         begin
         PGIBox ('Le SIREN de l''�tablissement d�posant ne correspond pas#13#10'+
                 'au SIREN de l''entreprise', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;
      if ControlSiret(BufDest)=False then
         begin
         PGIBox ('Le SIRET de l''�tablissement d�posant n''est pas valide',
                 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;

      if (TEtabD.GetValue('ET_CODEPOSTAL') <> '') then
         begin
         if ((TEtabD.GetValue('ET_PAYS') = 'FRA') and
            ((TEtabD.GetValue('ET_CODEPOSTAL') < '00000') or
            (TEtabD.GetValue('ET_CODEPOSTAL') > '99999'))) then
            begin
            PGIBox ('L''adresse de l''�tablissement d�posant (Code postal)#13#10'+
                    'est mal renseign�e', 'Saisie Entreprise DADS-U');
            ErrorDADSU:= 1;
            end;
         end
      else
         begin
         PGIBox ('L''adresse de l''�tablissement d�posant (Code postal)#13#10'+
                 'est mal renseign�e', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;

      if TEtabD.GetValue('ET_VILLE') = '' then
         begin
         PGIBox ('L''adresse de l''�tablissement d�posant (Ville)#13#10'+
                 'est mal renseign�e', 'Saisie Entreprise DADS-U');
         ErrorDADSU:= 1;
         end;

      end;
   end;

{PT62-1
if ((GetControlText('ESIRET') <> '') and (GetControlText('CCOMM') <> '') and
   ((GetControlText('ECOORD') <> '') or ((GetControlText('CCIVILITE') <> '') and
   (GetControlText('EPERSONNE') <> '')))) then
}
if ((GetControlText ('ESIRET')<>'') and (GetControlText ('ECOORD')<>'')) then
   begin
   ForceNumerique(GetControlText('ESIRET'), BufDest);
   if ControlSiret(BufDest)=False then
      begin
      PGIBox ('Le SIRET du destinataire du compte-rendu d''exploitation#13#10'+
              'n''est pas valide', 'Saisie Entreprise DADS-U');
      ErrorDADSU:= 1;
      end;
   end;

if (Car = '') then
   begin
   PGIBox ('La p�riodicit� de la d�claration n''est pas renseign�e',
           'Saisie Entreprise DADS-U');
   ErrorDADSU:= 1;
   end;

if (ErrorDADSU=0) then
   CalculS20_Entreprise (ParamCalc);

FreeAndNil(TEtab);

LibereTOBDADS;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 25/09/2001
Modifi� le ... :   /  /
Description .. : Calcul des �l�ments entreprise pour la DADSU
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.GenereFichier();
var
Buffer, Buf2, CodeSal, DonneeAEcrire, Etab, EtabSelect, EtatEvent : string;
Exercice, Guid1, Inst, Matricule, MatriculePrec, Millesime, Monnaie : string;
Nomcomplet, NomFic, NomFicRapport, NomFicRapportCalc, StCdc, StCompte : string;
StDate, StDelete, StEntre, StEtab, StEtabGen, StExer, StGener, StHonor : string;
StInact, StNbreH, StPcl, StPrecSeg, StPrudh, StQQ, StSelect, StSupp : string;
StTypeDecla : string;
QCdc, QCompte, QQ, QRechDelete, QRechEntre, QRechEtab, QRechExer : TQuery;
QRechGener, QRechHonor, QRechInact, QRechLexique, QRechPrudh : TQuery;
QRechSelect : TQuery;
TErreurD, TEtabD, TEtabDADS, TEtabDADSD, TGener, TGenerD, TInact, TInactD : TOB;
TInst, TInstFille, TPrudh, TPrudhD, TSupprD : TOB;
CodeRetour, FileAttrs, i, j, Nbre, Nbre30, NbreInst, NbreSeg : integer;
NbreSeg2, NbreSeg3, NumInst, Ordre : integer;
NbreTot, Size : double;
TI : TOB;
Ircantec, Next, S41G02, S44, S90000 : boolean;
sr : TSearchRec;
EnregEnvoi : TEnvoiSocial;
NoDossier : string; // PT62
begin
NbreTot := 0;
Nbre30 := 0;
Size := 0;

Trace:= TStringList.Create;
EtatEvent:= 'OK';

TErreur:= TOB.Create ('DADSCONTROLE', Nil, -1);

if Trace <> nil then
   Trace.Add ('D�but de pr�paration de la DADS-U � '+TimeToStr(Now));

Exercice := RechDom('PGANNEESOCIALE', GetControlText('CEXERCICE'), False);
StTypeDecla:=GetDADSUNature(TD2);
StSelect:= 'SELECT *'+
           ' FROM DADSCONTROLE'+
           ' LEFT JOIN DADSLEXIQUE ON'+
           ' PSU_SEGMENT=PDL_DADSSEGMENT WHERE'+
           ' PSU_TYPE="'+TypeD+'" AND'+
           ' PSU_DATEDEBUT>="'+UsDateTime(DebExer)+'" AND'+
           ' PSU_DATEFIN<="'+UsDateTime(FinExer)+'" AND'+
           ' PSU_EXERCICEDADS="'+Exercice+'" AND'+
           ' PSU_ORIGINECRIT LIKE "S%" AND'+
           ' PSU_ORIGINECRIT <> "SOK" AND'+
           ' ((PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
           ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
           ' PDL_EXERCICEFIN = "")'+StTypeDecla+') OR'+
           ' PSU_ORIGINECRIT = "SKO")'+
           ' ORDER BY PSU_SALARIE, PSU_ORDRE, PSU_SEGMENT';
QRechSelect:= OpenSql(StSelect,TRUE);
if (Not QRechSelect.EOF) then
   TErreur.LoadDetailDB('DADSCONTROLE','','',QRechSelect,False);
Ferme(QRechSelect);
TErreurD:= TErreur.FindFirst (['PSU_ORIGINECRIT'],['SKO'],FALSE);
if (TErreurD <> nil) then
   begin
   i:= PGIAsk ('Des modifications pouvant rendre la d�claration invalide#13#10'+
               'ont �t� effectu�es depuis le dernier contr�le.#13#10'+
               'Vous devriez l''effectuer � partir du Module Paie,#13#10'+
               'Menu DADS-U, Commande Contr�le DADS-U. Voulez-vous continuer ?',
               'Pr�paration de la DADS-U');
   if (i=mrNo) then
      begin
      FreeAndNil(TErreur);
      Trace.Add ('Pr�paration de la DADS-U annul�e � '+TimeToStr(Now));
{$IFNDEF DADSUSEULE}
      CreeJnalEvt ('001', '041', EtatEvent, nil, nil, Trace);
{$ENDIF}
      FreeAndNil (Trace);
      Exit;
      end
   else
      begin
      if Trace <> nil then
         Trace.Add ('Pr�paration de la DADS-U forc�e malgr� la pr�sence de'+
                    ' modifications effectu�es apr�s le dernier contr�le');
      EtatEvent:= 'ERR';
      end;
   end;

if ((TErreur.FillesCount (1) <> 0)) then
   begin
   TErreurD:= TErreur.FindFirst (['PSU_CTRLBLOQUANT'],['X'],FALSE);
   if (TErreurD <> nil) then
      i:= PGIAsk ('Ce dossier comporte des erreurs qui vont rendre la#13#10'+
                  'd�claration invalide. Avant de faire la pr�paration,#13#10'+
                  'vous devez corriger TOUTES les erreurs indiqu�es dans#13#10'+
                  'l''�tat de contr�le avant pr�paration.#13#10'+
                  'Voulez-vous continuer ?',
                  'Pr�paration de la DADS-U')
   else
      i:= PGIAsk ('Ce dossier comporte des alertes. Avant de faire la#13#10'+
                  'pr�paration, il est important de v�rifier TOUTES les#13#10'+
                  'erreurs non bloquantes indiqu�es dans l''�tat de#13#10'+
                  'contr�le avant pr�paration. Voulez-vous continuer ?',
                  'Pr�paration de la DADS-U');
   if (i=mrNo) then
      begin
      FreeAndNil(TErreur);
      Trace.Add ('Pr�paration de la DADS-U annul�e � '+TimeToStr(Now));
{$IFNDEF DADSUSEULE}
      CreeJnalEvt ('001', '041', EtatEvent, nil, nil, Trace);
{$ENDIF}
      FreeAndNil (Trace);
      Exit;
      end
   else
      begin
      if Trace <> nil then
         begin
         if (TErreurD <> nil) then
            Trace.Add ('Pr�paration de la DADS-U forc�e malgr� la pr�sence de '+
                       IntToStr (TErreur.FillesCount (1))+' erreurs dont des'+
                       ' erreurs bloquantes')
         else
            Trace.Add ('Pr�paration de la DADS-U forc�e malgr� la pr�sence de '+
                       IntToStr (TErreur.FillesCount (1))+' erreurs non'+
                       ' bloquantes')
         end;
      EtatEvent:= 'ERR';
      end;
   end;

FreeAndNil (TErreur);

ForceNumerique(GetParamSoc('SO_SIRET'), Buffer);
{$IFDEF EAGLCLIENT}
NomFicRapportCalc := VH_Paie.PgCheminEagl+'\'+Buffer+'_DADSU_PGI.log';
NomFicRapport := VH_Paie.PgCheminEagl+'\'+Buffer+'_DADSU_PGI_PREP.log';
{$ELSE}
NomFicRapportCalc := V_PGI.DatPath+'\'+Buffer+'_DADSU_PGI.log';
NomFicRapport := V_PGI.DatPath+'\'+Buffer+'_DADSU_PGI_PREP.log';
{$ENDIF}
//PT62-2
if (TD2>='03') then
   StDate:= ' PDS_DATEDEBUT>="'+UsDateTime (DebExer)+'" AND'+
            ' PDS_DATEFIN<="'+UsDateTime (FinExer)+'" AND'
else
   StDate:= '';
//FIN PT62-2

//PT67-2
StCdc:= 'SELECT COUNT(PDE_DADSCDC) AS NBANO'+
        ' FROM DADSPERIODES WHERE'+
        ' PDE_TYPE="'+TypeD+'" AND'+
        ' PDE_DATEDEBUT>="'+UsDateTime (DebExer)+'" AND'+
        ' PDE_DATEFIN<="'+UsDateTime (FinExer)+'" AND'+
        ' PDE_EXERCICEDADS="'+PGExercice+'" AND'+
        ' PDE_DADSCDC<>"'+CDC+'"';
QCdc:= OpenSQL (StCdc, True);
if (QCdc.FindField ('NBANO').AsInteger<>0) then
   begin
   PGIBox ('Pr�paration impossible ! des p�riodes n''ont pas �t�#13#10'+
           ' calcul�es avec la version '+CDC+' du cahier des charges.',
           'Pr�paration de la DADS-U');
   Ferme (QCdc);

   EtatEvent:= 'ERR';
   Trace.Add ('Pr�paration de la DADS-U annul�e � '+TimeToStr(Now)+' en raison'+
              ' d''incompatibilit� des p�riodes calcul�es avec le cahier des'+
              ' charges '+CDC+'.');
   CreeJnalEvt ('001', '041', EtatEvent, nil, nil, Trace);
   FreeAndNil (Trace);
   Exit;
   end;
//FIN PT67-2


StCompte:= 'SELECT COUNT(PDS_SALARIE) AS NBENREG'+
           ' FROM DADSDETAIL'+
           ' LEFT JOIN DADSLEXIQUE ON'+
           ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
           ' PDS_TYPE = "'+TypeD+'" AND'+StDate+
           ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
           ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
           ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
           ' PDL_EXERCICEFIN = "")'+StTypeDecla;
QCompte:= OpenSql(StCompte,TRUE);
if (Not QCompte.EOF) then
   Nbre:= QCompte.FindField('NBENREG').Asinteger
else
   Nbre:= 0;
Ferme (QCompte);
InitMoveProgressForm (NIL,'Traitement en cours',
                      'Veuillez patienter SVP ...',Nbre,FALSE,TRUE);
InitMove (Nbre,'');
//Ouverture du fichier
NomFic:= 'DA'+TypeDecla+Car+Siren+Fraction+
         RechDom('PGANNEESOCIALE', GetControlText('CEXERCICE'), False)+'.DAD';
{$IFDEF EAGLCLIENT}
Nomcomplet:= VH_Paie.PgCheminEagl+'\'+NomFic;
{$ELSE}
Nomcomplet:= V_PGI.DatPath+'\'+NomFic;
{$ENDIF}

if FileExists (Nomcomplet) then
      DeleteFile (PChar(Nomcomplet));

try
   begintrans;
   AssignFile (FDADS, Nomcomplet);
{$i-} ReWrite (FDADS); {$i+}
   If IoResult<>0 Then
      Begin
      PGIBox ('Fichier inaccessible : '+Nomcomplet,
              'Pr�paration de la DADS-U');
      FreeAndNil (Trace);
      FiniMove;
      FiniMoveProgressForm;
      Exit ;
      End;

//Donn�es ENTREPRISE
   StEntre:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DONNEE, PDS_ORDRESEG,'+
             ' PDL_DADSNATURE'+
             ' FROM DADSDETAIL'+
             ' LEFT JOIN DADSLEXIQUE ON'+
             ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
             ' PDS_SALARIE = "++'+Copy (GetParamSoc('SO_LIBELLE'), 0, 15)+'" AND'+
             ' PDS_TYPE = "'+TypeD+'" AND'+StDate+
             ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
             ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
             ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
             ' PDL_EXERCICEFIN = "")'+StTypeDecla+
             ' ORDER BY PDS_ORDRESEG,PDS_ORDRE,PDS_SEGMENT,PDS_DATEDEBUT,'+
             'PDS_DATEFIN';
   QRechEntre:= OpenSql(StEntre,TRUE);
   TGener:= TOB.Create('Les �l�ments entreprise', NIL, -1);
   TGener.LoadDetailDB('DADSDETAIL','','',QRechEntre,False);
   Ferme(QRechEntre);

   NbreSeg:= TGener.FillesCount(1);
   NbreTot:= NbreTot + NbreSeg;
   TGenerD:= TGener.FindFirst([''],[''],FALSE);
   For i := 1 to NbreSeg do
       begin
       DonneeAEcrire:= TGenerD.GetValue('PDS_DONNEE');
       ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                            TGenerD.GetValue('PDS_SEGMENT'),
                            TGenerD.GetValue('PDL_DADSNATURE'),
                            DonneeAEcrire);
       MoveCurProgressForm ('Ecriture S20');
       MoveCur (False) ;
       TGenerD:= TGener.FindNext([''],[''],FALSE);
       end;
   FreeAndNil (TGener);

//Donn�es SALARIE
{PT67-1
   if (GetControlText ('CHNEANT')<>'X') then
}
   if ((GetControlText ('CHNEANT')<>'X') and (TD2<>'12')) then
      begin
      TInst:= TOB.Create ('Les Institutions', NIL, -1);
      if (GetControlText ('CHPREVOYANCE')='-') then
         StSupp:= ' AND PDS_SEGMENT NOT LIKE "S45%"'
      else
         StSupp:= '';

      if (TD2='08') then
         StSupp:= StSupp+' AND PDS_SALARIE IN (SELECT PDS_SALARIE'+
                  ' FROM DADSDETAIL WHERE'+
                  ' PDS_TYPE = "'+TypeD+'" AND'+
                  ' PDS_ORDRE > 0 AND'+StDate+
                  ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                  ' PDS_SEGMENT="S45.G01.00.001")';

      StEtab:= '';
      if (THMultiValCombobox(GetControl('MCETAB')).Tous) then
{PT64-1
         StEtabGen:= ''
}
         begin
         TEtabDADS:= TOB.Create ('Les etablissements', nil, -1);
         ChargeEtabNonFictif (TEtabDADS);
         if (TEtabDADS<>nil) then
            begin
            TEtabDADSD:= TEtabDADS.FindFirst ([''], [''], False);
            if (TEtabDADSD<>nil) then
               begin
               Etab:= TEtabDADSD.GetValue ('ET_ETABLISSEMENT');
               while (Etab<>'') do
                     begin
                     StEtab:= StEtab+' PDS_DONNEEAFFICH="'+Etab+'"';
                     TEtabDADSD:= TEtabDADS.FindNext ([''], [''], False);
                     if (TEtabDADSD<>nil) then
                        Etab:= TEtabDADSD.GetValue ('ET_ETABLISSEMENT')
                     else
                        Etab:='';
                     if (Etab<>'') then
                        StEtab:= StEtab+' OR';
                     end;
               StEtabGen:= ' AND'+
                           ' PDS_SALARIE IN (SELECT PDS_SALARIE'+
                           ' FROM DADSDETAIL'+
                           ' WHERE PDS_TYPE = "'+TypeD+'" AND'+
                           ' PDS_ORDRE > 0 AND'+StDate+
                           ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                           ' PDS_SEGMENT="S41.G01.00.005" AND ('+StEtab+'))';
               end
            else
               StEtabGen:= '';
            end
         else
            StEtabGen:= '';
         end
//FIN PT64-1
      else
         begin
         EtabSelect:= GetControlText('MCETAB');
         Etab:= ReadTokenpipe(EtabSelect, ';');
         While (Etab <> '') do
               begin
               StEtab:= StEtab+' PDS_DONNEEAFFICH="'+Etab+'"';
               Etab:= ReadTokenpipe(EtabSelect,';');
               if (Etab <> '') then
                  StEtab:= StEtab+' OR';
               end;
         StEtabGen:= ' AND'+
                     ' PDS_SALARIE IN (SELECT PDS_SALARIE FROM DADSDETAIL'+
                     ' WHERE PDS_TYPE = "'+TypeD+'" AND'+
                     ' PDS_ORDRE > 0 AND'+StDate+
                     ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                     ' PDS_SEGMENT="S41.G01.00.005" AND ('+StEtab+'))';
         end;
      StGener:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DATEDEBUT, PDS_DONNEE,'+
                ' PDS_DONNEEAFFICH, PDS_ORDRE, PDS_ORDRESEG, PDL_DADSNATURE'+
                ' FROM DADSDETAIL'+
                ' LEFT JOIN SALARIES ON'+
                ' PDS_SALARIE = PSA_SALARIE'+
                ' LEFT JOIN DADSLEXIQUE ON'+
                ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
                ' PDS_TYPE = "'+TypeD+'" AND'+
                ' PDS_ORDRE >= 0 AND'+StDate+
                ' PDS_EXERCICEDADS = "'+PGExercice+'"'+StSupp+' AND'+
                ' PDS_SEGMENT NOT LIKE "S41.G02%" AND'+
                ' PSA_DADSFRACTION="'+Fraction+'" AND'+
                ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
                ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
                ' PDL_EXERCICEFIN = "")'+StTypeDecla+StEtabGen+
                ' ORDER BY PDS_SALARIE,PDS_DATEDEBUT,PDS_ORDRE,'+
                ' PDS_ORDRESEG,PDS_SEGMENT,PDS_DATEFIN';
      QRechGener:= OpenSql(StGener,TRUE);
      TGener:= TOB.Create('Les �l�ments salari�s', NIL, -1);
      TGener.LoadDetailDB('DADSDETAIL','','',QRechGener,False);
      Ferme(QRechGener);

      if ((TD2='03') or (TD2='07')) then
         begin
         TGenerD:= TGener.FindFirst (['PDS_SEGMENT', 'PDS_DONNEE'],
                                     ['S41.G01.01.001', '90000'], True);
         while (TGenerD <> nil) do
               begin
               NbreSeg:= 0;
               CodeSal:= TGenerD.GetValue ('PDS_SALARIE');
               Ordre:= TGenerD.GetValue ('PDS_ORDRE');
               TSupprD:= TGener.FindFirst (['PDS_SALARIE', 'PDS_ORDRE'],
                                           [CodeSal, Ordre], True);
               while (TSupprD <> nil) do
                     begin
                     FreeAndNil (TSupprD);
                     TSupprD:= TGener.FindFirst (['PDS_SALARIE', 'PDS_ORDRE'],
                                                 [CodeSal, Ordre], True);
                     end;
               TSupprD:= TGener.FindFirst (['PDS_SALARIE'], [CodeSal], True);
               while (TSupprD <> nil) do
                     begin
                     if (TSupprD.GetValue ('PDS_ORDRE') > 0) then
                        begin
                        NbreSeg:= 1;
                        break;
                        end;
                     TSupprD:= TGener.FindNext (['PDS_SALARIE'],
                                                [CodeSal], True);
                     end;

               if (NbreSeg = 0) then
                  begin
                  TSupprD:= TGener.FindFirst (['PDS_SALARIE'], [CodeSal], True);
                  while (TSupprD <> nil) do
                        begin
                        FreeAndNil (TSupprD);
                        TSupprD:= TGener.FindFirst (['PDS_SALARIE'],
                                                    [CodeSal], True);
                        end;
                  end;

               TGenerD:= TGener.FindFirst (['PDS_SEGMENT', 'PDS_DONNEE'],
                                           ['S41.G01.01.001', '90000'], True);
               end;
         end;

      Next:= False;
      S44:= False;
      S90000:= False;
      S41G02:= True;
      FreeAndNil (TPrudh);
      NbreSeg3:= 0;
      NbreSeg:= TGener.FillesCount(1);
      NbreTot:= NbreTot+NbreSeg;

      TGenerD:= TGener.FindFirst([''],[''],FALSE);
      if (TGenerD <> nil) then
         CodeSal:= TGenerD.GetValue('PDS_SALARIE');
      For i := 1 to NbreSeg do
          begin
          if ((TGenerD<>nil) and
             ((TGenerD.GetValue('PDS_SEGMENT')='S30.G01.00.001') or
             (TGenerD.GetValue('PDS_SEGMENT')>'S41.G02')) and
             (GetControlText('CBPRUDH')='X') and (S41G02=False) and
             (TPrudh<>nil)) then
             begin
             NbreTot:= NbreTot+NbreSeg3;
             TPrudhD:= TPrudh.FindFirst([''],[''],FALSE);
             For j := 1 to NbreSeg3 do
                 begin
                 DonneeAEcrire:= TPrudhD.GetValue('PDS_DONNEE');
                 ControleEcritureFic (TPrudhD.GetValue('PDS_SALARIE'),
                                      TPrudhD.GetValue('PDS_SEGMENT'),
                                      TPrudhD.GetValue('PDL_DADSNATURE'),
                                      DonneeAEcrire);
                 MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                 MoveCur(False) ;
                 TPrudhD:= TPrudh.FindNext([''],[''],FALSE);
                 end;
             S41G02:= True;
             end;

          if ((TGenerD <> nil) and
             ((TGenerD.GetValue('PDS_SEGMENT') = 'S30.G01.00.001') or
             (TGenerD.GetValue('PDS_SEGMENT') = 'S41.G01.00.001')) and
{PT71
             ((TypeDecla = '0151') or (TypeDecla = '0351') or
             (TypeDecla = '0751'))) then
}
             ((TD2='01') or (TD2='03') or (TD2='07'))) then
//FIN PT71
             begin
             if ((StPrecSeg > 'S30') and (S44 = False)) then
                begin
                if ((S90000 = False) and (Ircantec=False)) then
                   begin
                   DonneeAEcrire:= '01';
                   ControleEcritureFic (CodeSal, 'S44.G01.00.001', 'X',
                                        DonneeAEcrire);
                   MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                   MoveCur (False) ;
                   DonneeAEcrire:= IntToStr(StrToInt(StNbreH)*100);
                   ControleEcritureFic (CodeSal, 'S44.G01.00.002', 'N',
                                        DonneeAEcrire);
                   MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                   MoveCur (False) ;
                   NbreTot:= NbreTot+2;
                   end;
                end;
             S44:= False;
             end;

          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT') = 'S41.G01.00.001') and
{PT71
             ((TypeDecla = '0151') or (TypeDecla = '0351') or
             (TypeDecla = '0751'))) then
}
             ((TD2='01') or (TD2='03') or (TD2='07'))) then
//FIN PT71
             begin
             S90000:= False;
             Ircantec:= False;
             end;

          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT')='S30.G01.00.001')) then
             begin
             Nbre30:= Nbre30+1;
             if (Nbre30 <> 1) then
                begin
                StInact:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DATEDEBUT,'+
                          ' PDS_DONNEE, PDS_ORDRE, PDS_ORDRESEG,'+
                          ' PDL_DADSNATURE'+
                          ' FROM DADSDETAIL'+
                          ' LEFT JOIN SALARIES ON'+
                          ' PDS_SALARIE = PSA_SALARIE'+
                          ' LEFT JOIN DADSLEXIQUE ON'+
                          ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
                          ' PDS_SALARIE = "'+Matricule+'" AND'+
                          ' PDS_TYPE = "'+TypeD+'" AND'+
                          ' PDS_ORDRE < 0 AND'+
                          ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                          ' PSA_DADSFRACTION="'+Fraction+'" AND'+
                          ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
                          ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
                          ' PDL_EXERCICEFIN = "")'+StTypeDecla+
                          ' ORDER BY PDS_DATEDEBUT,PDS_ORDRE DESC,'+
                          ' PDS_ORDRESEG,PDS_SEGMENT,PDS_DATEFIN';
                QRechInact:= OpenSql(StInact,TRUE);
                TInact:= TOB.Create ('Les �l�ments Inactivit�', NIL, -1);
                TInact.LoadDetailDB ('DADSDETAIL','','',QRechInact,False);
                Ferme (QRechInact);

                NbreSeg2:= TInact.FillesCount(1);
                NbreTot:= NbreTot+NbreSeg2;
                TInactD:= TInact.FindFirst([''],[''],FALSE);
                For j := 1 to NbreSeg2 do
                    begin
                    DonneeAEcrire:= TInactD.GetValue('PDS_DONNEE');
                    ControleEcritureFic (TInactD.GetValue('PDS_SALARIE'),
                                         TInactD.GetValue('PDS_SEGMENT'),
                                         TInactD.GetValue('PDL_DADSNATURE'),
                                         DonneeAEcrire);
                    MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                    MoveCur (False) ;
                    TInactD:= TInact.FindNext([''],[''],FALSE);
                    end;
                FreeAndNil (TInact);
                end;
             end;

          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT') = 'S41.G01.00.019')) then
             begin
             MatriculePrec:= Matricule;
             Matricule:= TGenerD.GetValue('PDS_DONNEE');
             if (GetControlText('CBPRUDH')='X') then
                begin
                S41G02:= False;
                if (MatriculePrec<>Matricule) then
                   begin
{PT64-1
                   if (THMultiValCombobox(GetControl('MCETAB')).Tous) then
}
                   if ((THMultiValCombobox(GetControl('MCETAB')).Tous) and
                      (TEtabDADS=nil)) then
//FIN PT64-1                      
                      StEtabGen:= ''
                   else
                      StEtabGen:= ' AND'+
                                  ' PDS_ORDRE IN (SELECT PDS_ORDRE FROM'+
                                  ' DADSDETAIL WHERE'+
                                  ' PDS_TYPE = "'+TypeD+'" AND'+
                                  ' PDS_ORDRE > 0 AND'+StDate+
                                  ' PDS_SEGMENT NOT LIKE "S41.G02%" AND'+
                                  ' PDS_SEGMENT="S41.G01.00.005" AND ('+
                                  StEtab+'))';
                   StPrudh:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DATEDEBUT,'+
                             ' PDS_DONNEE, PDS_ORDRE, PDS_ORDRESEG,'+
                             ' PDL_DADSNATURE'+
                             ' FROM DADSDETAIL'+
                             ' LEFT JOIN SALARIES ON'+
                             ' PDS_SALARIE = PSA_SALARIE'+
                             ' LEFT JOIN DADSLEXIQUE ON'+
                             ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
                             ' PDS_SALARIE = "'+Matricule+'" AND'+
                             ' PDS_TYPE = "'+TypeD+'" AND'+
                             ' PDS_ORDRE >= 0 AND'+StDate+
                             ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                             ' PDS_SEGMENT LIKE "S41.G02%" AND'+
                             ' PSA_DADSFRACTION="'+Fraction+'" AND'+
                             ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
                             ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
                             ' PDL_EXERCICEFIN = "")'+StTypeDecla+StEtabGen+
                             ' ORDER BY PDS_DATEDEBUT,PDS_ORDRE, PDS_ORDRESEG,'+
                             ' PDS_SEGMENT,PDS_DATEFIN';

                   QRechPrudh:= OpenSql(StPrudh,TRUE);
                   FreeAndNil (TPrudh);
                   TPrudh:= TOB.Create('Les �l�ments prud''hommaux', NIL, -1);
                   TPrudh.LoadDetailDB('DADSDETAIL','','',QRechPrudh,False);
                   Ferme(QRechPrudh);
                   NbreSeg3:= TPrudh.FillesCount(1);
                   end;
                end;
             end;

          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT') = 'S41.G01.01.001')) then
             begin
{PT62-2
             if ((TypeDecla = '0251') or (TypeDecla = '0851')) then
}
             if (TD2='02') then
                begin
                if ((TGenerD.GetValue ('PDS_DONNEE')<>'I0001') and
                   (TGenerD.GetValue ('PDS_DONNEE')<>'I0002') and
                   (TGenerD.GetValue ('PDS_DONNEE')<>'F0002') and
                   (TGenerD.GetValue ('PDS_DONNEE')<>'R0001') and
                   (TGenerD.GetValue ('PDS_DONNEE')<>'CNBF')) then
                   begin
                   Buffer:= 'S41.G01.01';
                   While Buffer = 'S41.G01.01' do
                         begin
                         TGenerD:= TGener.FindNext([''],[''],FALSE);
                         if TGenerD <> nil then
                            Buffer:= Copy(TGenerD.GetValue('PDS_SEGMENT'),1,10)
                         else
                            Buffer:= '';
                         NbreTot:= NbreTot-1;
                         Next:= True;
                         end;
                   NbreTot:= NbreTot+1;
                   DonneeAEcrire:= '90000';
                   ControleEcritureFic (CodeSal, 'S41.G01.01.001', 'X',
                                        DonneeAEcrire);
                   S90000:= True;
                   MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                   MoveCur (False) ;
                   end
                else
                   begin
                   TInstFille:= TOB.Create('',TInst,-1);
                   TInstFille.AddChampSup('CODE', FALSE);
                   TInstFille.PutValue('CODE', TGenerD.GetValue('PDS_DONNEE'));
                   if (TGenerD.GetValue('PDS_DONNEE') = '90000') then
                      S90000:= True;
                   end;
                end
             else
//PT62-2
             if (TD2='04') then
                begin
                Buf2:= Copy (TGenerD.GetValue ('PDS_DONNEEAFFICH'), 1, 1);
                Buffer:= 'S41.G01.01';
                While (Buffer='S41.G01.01') do
                      begin
                      if (TGenerD.GetValue('PDS_SEGMENT')='S41.G01.01.001') then
                         Buf2:= Copy (TGenerD.GetValue ('PDS_DONNEEAFFICH'), 1, 1);
                      if (Buf2='B') then
                         begin
                         if (TGenerD.GetValue('PDS_SEGMENT')='S41.G01.01.001') then
                            begin
                            TInstFille:= TOB.Create ('', TInst, -1);
                            TInstFille.AddChampSup ('CODE', FALSE);
                            TInstFille.PutValue ('CODE', TGenerD.GetValue ('PDS_DONNEE'));
                            end;
//PT72
                         DonneeAEcrire:= TGenerD.GetValue('PDS_DONNEE');
                         ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                                              TGenerD.GetValue('PDS_SEGMENT'),
                                              TGenerD.GetValue('PDL_DADSNATURE'),
                                              DonneeAEcrire);
                         TGenerD:= TGener.FindNext ([''], [''], FALSE);
                         if TGenerD <> nil then
                            Buffer:= Copy(TGenerD.GetValue('PDS_SEGMENT'),1,10)
//FIN PT72
                         end
                      else
                         begin
                         TGenerD:= TGener.FindNext ([''], [''], FALSE);
                         if TGenerD <> nil then
                            Buffer:= Copy(TGenerD.GetValue('PDS_SEGMENT'),1,10)
                         else
                            begin
                            Buffer:= '';
                            Buf2:= '';
                            end;
                         NbreTot:= NbreTot-1;
                         Next:= True;
                         end;
                      MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                      MoveCur (False);
                      end;
                end
             else
                begin
                TInstFille:= TOB.Create('',TInst,-1);
                TInstFille.AddChampSup('CODE', FALSE);
                TInstFille.PutValue('CODE', TGenerD.GetValue('PDS_DONNEE'));
                if (TGenerD.GetValue('PDS_DONNEE') = '90000') then
                   S90000:= True;
                end;
//FIN PT62-2

             if ((TGenerD <> nil) and
                (Pos('I', TGenerD.GetValue('PDS_DONNEE'))=1)) then
                Ircantec:= True;
             end;

{PT62-2
          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT') = 'S45.G01.01.004')) then
}
          if ((TGenerD<>nil) and
             (TGenerD.GetValue ('PDS_SEGMENT')='S45.G01.01.004.001')) then
//FIN PT62-2
             begin
{PT62-2
             if (TypeDecla = '0851') then
}
             if (TD2='08') then
//FIN PT62-2
                begin
                TInstFille:= TOB.Create('',TInst,-1);
                TInstFille.AddChampSup('CODE', FALSE);
                Buffer:= Copy (TGenerD.GetValue('PDS_DONNEE'), 2, 4);
                TInstFille.PutValue('CODE', Buffer);
                end;
             end;

          if ((TGenerD <> nil) and
             (TGenerD.GetValue('PDS_SEGMENT') = 'S44.G01.00.001')) then
             begin
             if ((S90000=True) or (Ircantec=True)) then
                begin
                Buffer:= 'S44';
                While Buffer = 'S44' do
                      begin
                      TGenerD:= TGener.FindNext([''],[''],FALSE);
                      NbreTot:= NbreTot-1;
                      if TGenerD <> nil then
                         begin
                         Buffer:= Copy(TGenerD.GetValue('PDS_SEGMENT'),1,3);
                         CodeSal:= TGenerD.GetValue('PDS_SALARIE');
                         end
                      else
                         Buffer:= '';
                      Next:= True;
                      end;
                end;

{PT71
             if ((TypeDecla = '0151') or (TypeDecla = '0351') or
                (TypeDecla = '0751')) then
}
             if ((TD2='01') or (TD2='03') or (TD2='07')) then
//FIN PT71
                S44:= True;
             end;

          if (((TGenerD = nil) or
             (TGenerD.GetValue('PDS_SEGMENT') > 'S44')) and
{PT71
             ((TypeDecla = '0151') or (TypeDecla = '0351') or
             (TypeDecla = '0751'))) then
}
             ((TD2='01') or (TD2='03') or (TD2='07'))) then
//FIN PT71
             begin
             if ((StPrecSeg > 'S30') and (S44 = False) and
                (S90000 = False) and (Ircantec=False)) then
                begin
                DonneeAEcrire:= '01';
                ControleEcritureFic (CodeSal, 'S44.G01.00.001', 'X',
                                     DonneeAEcrire);
                MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                MoveCur(False);
                DonneeAEcrire:= IntToStr(StrToInt(StNbreH)*100);
                ControleEcritureFic (CodeSal, 'S44.G01.00.002', 'N',
                                     DonneeAEcrire);
                MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
                MoveCur(False);
                NbreTot:= NbreTot+2;
                end;
             S44:= True;
             end;

          if Next = True then
             Next:= False
          else
             begin
             if TGenerD <> nil then
                begin
                if TGenerD.GetValue('PDS_SEGMENT')='S30.G01.00.008.001' then
                   Buffer:= Copy(TGenerD.GetValue('PDS_DONNEE'),1,32)
                else
                if TGenerD.GetValue('PDS_SEGMENT')='S30.G01.00.008.006' then
                   Buffer:= Copy(TGenerD.GetValue('PDS_DONNEE'),1,26)
                else
                if TGenerD.GetValue('PDS_SEGMENT')='S30.G01.00.008.010' then
                   Buffer:= Copy(TGenerD.GetValue('PDS_DONNEE'),1,10)
                else
                if TGenerD.GetValue('PDS_SEGMENT')='S41.G01.00.010' then
                   Buffer:= Copy(TGenerD.GetValue('PDS_DONNEE'),1,120)
                else
                   Buffer:= TGenerD.GetValue('PDS_DONNEE');
                DonneeAEcrire:= Buffer;
                ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                                     TGenerD.GetValue('PDS_SEGMENT'),
                                     TGenerD.GetValue('PDL_DADSNATURE'),
                                     DonneeAEcrire);
                end;
             MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
             MoveCur (False);
             if TGenerD = nil then
                StPrecSeg:= Copy(TGenerD.GetValue('PDS_SEGMENT'),1,3);
             TGenerD:= TGener.FindNext([''],[''],FALSE);
             end;
          if TGenerD = nil then
             break
          else
             CodeSal:= TGenerD.GetValue('PDS_SALARIE');
          end;

      if ((GetControlText('CBPRUDH')='X') and (S41G02=False) and
         (TPrudh<>nil)) then
         begin
         NbreTot:= NbreTot+NbreSeg3;
         TPrudhD:= TPrudh.FindFirst([''],[''],FALSE);
         For j := 1 to NbreSeg3 do
             begin
             DonneeAEcrire:= TPrudhD.GetValue('PDS_DONNEE');
             ControleEcritureFic (TPrudhD.GetValue('PDS_SALARIE'),
                                  TPrudhD.GetValue('PDS_SEGMENT'),
                                  TPrudhD.GetValue('PDL_DADSNATURE'),
                                  DonneeAEcrire);
             MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
             MoveCur(False) ;
             TPrudhD:= TPrudh.FindNext([''],[''],FALSE);
             end;
         S41G02:= True;
         end;

{PT71
      if ((TypeDecla = '0151') or (TypeDecla = '0351') or
         (TypeDecla = '0751')) then
}
      if ((TD2='01') or (TD2='03') or (TD2='07')) then
//FIN PT71
         begin
         if ((StPrecSeg > 'S30') and (S44 = False) and (Ircantec=False)) then
            begin
            DonneeAEcrire:= '01';
            ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                                 'S44.G01.00.001', 'X', DonneeAEcrire);
            MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
            MoveCur (False) ;
            DonneeAEcrire:= IntToStr(StrToInt(StNbreH)*100);
            ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                                 'S44.G01.00.002', 'N', DonneeAEcrire);
            MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
            MoveCur (False) ;
            NbreTot:= NbreTot+2;
            end;
         end;
      FreeAndNil (TGener);
      StInact:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DATEDEBUT, PDS_DONNEE,'+
                ' PDS_ORDRE, PDS_ORDRESEG'+
                ' FROM DADSDETAIL'+
                ' LEFT JOIN SALARIES ON'+
                ' PDS_SALARIE = PSA_SALARIE'+
                ' LEFT JOIN DADSLEXIQUE ON'+
                ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
                ' PDS_SALARIE = "'+Matricule+'" AND'+
                ' PDS_TYPE = "'+TypeD+'" AND'+
                ' PDS_ORDRE < 0 AND'+
                ' PDS_EXERCICEDADS = "'+PGExercice+'" AND'+
                ' PSA_DADSFRACTION="'+Fraction+'" AND'+
                ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
                ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
                ' PDL_EXERCICEFIN = "")'+StTypeDecla+
                ' ORDER BY PDS_DATEDEBUT,PDS_ORDRE DESC, PDS_ORDRESEG,'+
                ' PDS_SEGMENT, PDS_DATEFIN';
      QRechInact:= OpenSql(StInact,TRUE);
      TInact:= TOB.Create ('Les �l�ments Inactivit�', NIL, -1);
      TInact.LoadDetailDB ('DADSDETAIL','','',QRechInact,False);
      Ferme(QRechInact);

      NbreSeg2:= TInact.FillesCount(1);
      NbreTot:= NbreTot+NbreSeg2;
      TInactD:= TInact.FindFirst([''],[''],FALSE);
      For j:=1 to NbreSeg2 do
          begin
          DonneeAEcrire:= TInactD.GetValue('PDS_DONNEE');
          ControleEcritureFic (TInactD.GetValue('PDS_SALARIE'),
                               TInactD.GetValue('PDS_SEGMENT'),
                               TInactD.GetValue('PDL_DADSNATURE'),
                               DonneeAEcrire);
          MoveCurProgressForm ('Ecriture Salari� '+CodeSal);
          MoveCur (False) ;
          TInactD:= TInact.FindNext([''],[''],FALSE);
          end;
      FreeAndNil (TInact);
      end;       //PT67-1

//Donn�es Honoraires
{PT67-1
      if (GetControlText('CHHONORAIRE')='X') then
}
   if ((GetControlText ('CHNEANT')<>'X') and
      (GetControlText('CHHONORAIRE')='X')) then
//FIN PT67-1      
      begin
{PT64-1
      if (THMultiValCombobox(GetControl('MCETAB')).Tous) then
}
      if ((THMultiValCombobox(GetControl('MCETAB')).Tous) and
         (TEtabDADS=nil)) then
//FIN PT64-1
         StEtabGen:= ''
      else
         StEtabGen:= ' AND'+
                     ' PDS_ORDRE IN (SELECT PDS_ORDRE FROM DADSDETAIL WHERE'+
                     ' PDS_SEGMENT="S70.G01.00.014" AND'+
                     ' PDS_DATEDEBUT >= "'+UsDateTime(DebExer)+'" AND'+
                     ' PDS_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                     ' PDS_EXERCICEDADS = "'+PGExercice+'" AND ('+
                     StEtab+'))';
      StHonor:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DONNEE, PDS_ORDRE,'+
                ' PDS_ORDRESEG, PDL_DADSNATURE'+
                ' FROM DADSDETAIL'+
                ' LEFT JOIN DADSLEXIQUE ON'+
                ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
                ' PDS_SALARIE LIKE "--H%" AND'+
                ' PDS_TYPE="'+TypeD+'" AND'+
                ' PDS_DATEDEBUT>="'+UsDateTime(DebExer)+'" AND'+
                ' PDS_DATEFIN<="'+UsDateTime(FinExer)+'" AND'+
                ' PDS_ORDRE IN (SELECT PDS_ORDRE FROM DADSDETAIL WHERE'+
                ' PDS_SEGMENT="S70.G01.01.002" AND'+
                ' PDS_SALARIE LIKE "--H%" AND PDS_TYPE="'+TypeD+'" AND'+
                ' PDS_DATEDEBUT>="'+UsDateTime(DebExer)+'" AND'+
                ' PDS_DATEFIN<="'+UsDateTime(FinExer)+'") AND'+
                ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
                ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
                ' PDL_EXERCICEFIN = "")'+StTypeDecla+StEtabGen+
                ' ORDER BY PDS_ORDRE,PDS_ORDRESEG,PDS_SEGMENT,'+
                ' PDS_DATEDEBUT,PDS_DATEFIN';
      QRechHonor:= OpenSql(StHonor,TRUE);
      TGener:= TOB.Create('Les �l�ments honoraires', NIL, -1);
      TGener.LoadDetailDB('DADSDETAIL','','',QRechHonor,False);
      Ferme(QRechHonor);

      NbreSeg:= TGener.FillesCount(1);
      NbreTot:= NbreTot+NbreSeg;
      TGenerD:= TGener.FindFirst([''],[''],FALSE);
      For i := 1 to NbreSeg do
          begin
          DonneeAEcrire:= TGenerD.GetValue('PDS_DONNEE');
          ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                               TGenerD.GetValue('PDS_SEGMENT'),
                               TGenerD.GetValue('PDL_DADSNATURE'),
                               DonneeAEcrire);
          MoveCurProgressForm ('Ecriture S70');
          MoveCur(False);
          TGenerD:= TGener.FindNext([''],[''],FALSE);
          end;
      FreeAndNil(TGener);
      end;

//Donn�es ETABLISSEMENT
   StEtab:= '';
   if (THMultiValCombobox(GetControl('MCETAB')).Tous) then
{PT64-1
      StEtabGen:= ''
}
      begin
      if (TEtabDADS<>nil) then
         begin
         TEtabDADSD:= TEtabDADS.FindFirst ([''], [''], False);
         if (TEtabDADSD<>nil) then
            begin
            Etab:= TEtabDADSD.GetValue ('ET_ETABLISSEMENT');
            while (Etab<>'') do
                  begin
                  StEtab:= StEtab+' PDS_SALARIE="**'+Etab+'"';
                  TEtabDADSD:= TEtabDADS.FindNext ([''], [''], False);
                  if (TEtabDADSD<>nil) then
                     Etab:= TEtabDADSD.GetValue ('ET_ETABLISSEMENT')
                  else
                     Etab:='';
                  if (Etab<>'') then
                     StEtab:= StEtab+' OR';
                  end;
{PT66
            StEtabGen:= ' AND'+
                        ' PDS_ORDRE IN (SELECT PDS_ORDRE FROM DADSDETAIL WHERE'+
                        ' PDS_SEGMENT="S80.G01.00.001.001" AND'+
                        ' PDS_DATEDEBUT >= "'+UsDateTime(DebExer)+'" AND'+
                        ' PDS_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                        ' PDS_EXERCICEDADS = "'+PGExercice+'" AND ('+
                        StEtab+'))';
}
            StEtabGen:= ' AND ('+StEtab+')';
//FIN PT66
            end
         else
            StEtabGen:= '';
         end
      else
         StEtabGen:= '';
      end
//FIN PT64-1
   else
      begin
      EtabSelect:= GetControlText ('MCETAB');
      Etab:= ReadTokenpipe (EtabSelect, ';');
      While (Etab <> '') do
            begin
            StEtab:= StEtab+' PDS_SALARIE="**'+Etab+'"';
            Etab:= ReadTokenpipe(EtabSelect,';');
            if (Etab <> '') then
               StEtab:= StEtab+' OR';
            end;
{PT66
      StEtabGen:= ' AND'+
                  ' PDS_ORDRE IN (SELECT PDS_ORDRE FROM DADSDETAIL WHERE'+
                  ' PDS_SEGMENT="S80.G01.00.001.001" AND'+
                  ' PDS_DATEDEBUT >= "'+UsDateTime(DebExer)+'" AND'+
                  ' PDS_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                  ' PDS_EXERCICEDADS = "'+PGExercice+'" AND ('+
                  StEtab+'))';
}
      StEtabGen:= ' AND ('+StEtab+')';
//FIN PT66
      end;

//PT68
   if (TD2<>'12') then
      Buffer:= ''
   else
      Buffer:= ' PDS_SEGMENT NOT LIKE "S80.G62%" AND';
//FIN PT68
   StEtab:= 'SELECT PDS_SALARIE, PDS_SEGMENT, PDS_DONNEE, PDS_ORDRE,'+
            ' PDS_ORDRESEG, PDL_DADSNATURE'+
            ' FROM DADSDETAIL'+
            ' LEFT JOIN DADSLEXIQUE ON'+
            ' PDS_SEGMENT=PDL_DADSSEGMENT WHERE'+
            ' PDS_SALARIE LIKE "**%" AND'+
            ' PDS_TYPE = "'+TypeD+'" AND'+
            ' PDS_DATEDEBUT = "'+UsDateTime(DebExer)+'" AND'+
            ' PDS_DATEFIN = "'+UsDateTime(FinExer)+'" AND'+Buffer+
            ' PDL_EXERCICEDEB <= "'+Exercice+'" AND'+
            ' (PDL_EXERCICEFIN >= "'+Exercice+'" OR'+
            ' PDL_EXERCICEFIN = "")'+StTypeDecla+StEtabGen+
            ' ORDER BY PDS_SALARIE, PDS_ORDRESEG,PDS_SEGMENT,PDS_DATEDEBUT,'+
            'PDS_DATEFIN';
   QRechEtab:=OpenSql(StEtab,TRUE);
   TGener:= TOB.Create('Les �l�ments �tablissement', NIL, -1);
   TGener.LoadDetailDB('DADSDETAIL','','',QRechEtab,False);
   Ferme(QRechEtab);

   NbreSeg:= TGener.FillesCount(1);
   NbreTot:= NbreTot+NbreSeg;
   TGenerD:= TGener.FindFirst([''],[''],FALSE);
   For i := 1 to NbreSeg do
       begin
       DonneeAEcrire:= TGenerD.GetValue('PDS_DONNEE');
       ControleEcritureFic (TGenerD.GetValue('PDS_SALARIE'),
                            TGenerD.GetValue('PDS_SEGMENT'),
                            TGenerD.GetValue('PDL_DADSNATURE'), DonneeAEcrire);
       MoveCurProgressForm ('Ecriture S80');
       MoveCur (False);
       TGenerD:= TGener.FindNext([''],[''],FALSE);
       end;
   FreeAndNil (TGener);

//Donn�es DECLARATION
   if VH_Paie.PGTenueEuro = TRUE then
      begin
      Monnaie:= 'EUR';
      DonneeAEcrire:= FloatToStr(NbreTot);
      ControleEcritureFic ('DRAPEAU FIN', 'S90.G01.00.001', 'N', DonneeAEcrire);
      MoveCurProgressForm ('Ecriture S90');
      MoveCur (False);
      DonneeAEcrire:= '1';
      ControleEcritureFic ('DRAPEAU FIN', 'S90.G01.00.002', 'N', DonneeAEcrire);
      MoveCurProgressForm ('Ecriture S90');
      MoveCur (False);
      end
   else
      begin
      Monnaie:= 'FRF';
      DonneeAEcrire:= FloatToStr(NbreTot);
      ControleEcritureFic ('DRAPEAU FIN', 'S90.G02.00.001', 'N', DonneeAEcrire);
      MoveCurProgressForm ('Ecriture S90');
      MoveCur (False);
      DonneeAEcrire:= '1';
      ControleEcritureFic ('DRAPEAU FIN', 'S90.G02.00.002', 'N', DonneeAEcrire);
      MoveCurProgressForm ('Ecriture S90');
      MoveCur (False);
      end;

   CloseFile (FDADS);

   NoDossier := PgRendNoDossier(); // PT62

//PT61
if (SansFichierBase='-') then
// mise en base du fichier DADS-U confectionn�
   begin

   CodeRetour:= AGL_YFILESTD_IMPORT (NomComplet, 'PAIE', NomFic, 'DAD', 'DAD',
                                     RechDom ('PGANNEESOCIALE', GetControlText ('CEXERCICE'), False),
                                     TypeDecla, Car, Fraction,
                                     '-', '-', '-', '-', '-', 'FRA', 'DOS', NomFic, NoDossier); // PT62
   if (CodeRetour<>-1) then
      PGIInfo (AGL_YFILESTD_GET_ERR (CodeRetour)+'#13#10'+NomComplet);
 end;
//FIN PT61

   FileAttrs:= 0;
   FileAttrs:= FileAttrs+faAnyFile;
   if FindFirst (Nomcomplet, FileAttrs, sr) = 0 then
      begin
      if (sr.Attr and FileAttrs) = sr.Attr then
         Size:= Arrondi(sr.Size/1024, 2);
      sysutils.FindClose(sr);
      end;

//Mise � jour de la table ENVOISOCIAL
      Millesime:= RechDom ('PGANNEESOCIALE',GetControlText('CEXERCICE'),FALSE);
      StExer:= 'SELECT CO_CODE'+
               ' FROM COMMUN WHERE'+
               ' CO_TYPE="PGA" AND'+
               ' CO_LIBELLE="'+Millesime+'"';
      QRechExer:= OpenSQL(StExer,TRUE) ;
      if Not QRechExer.EOF then
         Millesime:= QRechExer.FindField ('CO_CODE').AsString;
      Ferme (QRechExer);

      StDelete:= 'DELETE FROM ENVOISOCIAL WHERE'+
                 ' PES_TYPEMESSAGE= "DAD" AND '+
                 ' PES_MILLESSOC = "'+Millesime+'" AND'+
                 ' PES_DATEDEBUT = "'+UsDateTime(DebExer)+'" AND'+
                 ' PES_DATEFIN = "'+UsDateTime(FinExer)+'" AND'+
                 ' PES_SIRETDO = "'+SIR+NIC+'" AND'+
                 ' PES_FRACTIONDADS = "'+Fraction+'" AND'+
                 ' PES_FICHIERRECU = "'+NomFic+'"';
      ExecuteSQL (StDelete) ;

      Ordre:= 1;
      StDelete:= 'SELECT MAX(PES_CHRONOMESS) AS MAXI FROM ENVOISOCIAL';
      QRechDelete:= OpenSQL(StDelete,TRUE) ;
      if Not QRechDelete.EOF then
         try
         Ordre:= QRechDelete.FindField ('MAXI').AsInteger+1;
         except
               on E: EConvertError do
                  Ordre:= 1;
         end;
      Ferme (QRechDelete);

      if (TInst<>nil) then
         begin
         TInst.Detail.Sort('CODE');
         NbreInst:= TInst.FillesCount(1);
         end;
      ChargeTOBENVOI;

//PT61
// R�cup�ration du GUID pour maj ENVOISOCIAL
      Guid1:= '';
      if (SansFichierBase='-') then
         begin

         if (V_PGI.ModePcl='1') then
            StPcl:= ' AND (YFS_PREDEFINI="DOS" AND'+
                    ' YFS_NODOSSIER="'+V_PGI.NoDossier+'")'
         else
           StPcl:= '';
//Recherche enregistrement dans YFILESTD
         StQQ:= 'SELECT YFS_FILEGUID'+
                ' FROM YFILESTD WHERE'+
                ' YFS_NOM="'+NomFic+'" AND'+
                ' YFS_CODEPRODUIT="PAIE" AND'+
                ' YFS_CRIT1="DAD" AND'+
                ' YFS_CRIT2="'+RechDom('PGANNEESOCIALE', GetControlText ('CEXERCICE'), False)+'" AND'+
                ' YFS_CRIT3="'+TypeDecla+'" AND'+
                ' YFS_CRIT4="'+Car+'" AND'+
                ' YFS_CRIT5="'+Fraction+'" AND'+
                ' YFS_PREDEFINI<>"CEG"'+StPcl;
         QQ:= OpenSQL (StQQ, TRUE);
         if not QQ.EOF then
            Guid1 := QQ.FindField ('YFS_FILEGUID').AsString;
         Ferme(QQ);
         end;
//FIN PT61

      EnregEnvoi.Ordre:= Ordre;
      EnregEnvoi.TypeE:= 'DAD';
      EnregEnvoi.Millesime:= Millesime;
      EnregEnvoi.Periodicite:= Copy(Car, 1, 1);
      EnregEnvoi.DateD:= DebExer;
      EnregEnvoi.DateF:= FinExer;
      EnregEnvoi.Siret:= SIR+NIC;
      EnregEnvoi.Fraction:= Fraction;
      EnregEnvoi.Libelle:= GetControlText('ERAISONSOC');
      EnregEnvoi.Size:= size;
      EnregEnvoi.NomFic:= ExtractFileName(NomFic);
      EnregEnvoi.Statut:= '';
      EnregEnvoi.Monnaie:= Monnaie;
      EnregEnvoi.EmettSoc:= GetParamSoc('SO_PGEMETTEUR');
      EnregEnvoi.Guid1:= Guid1;                              //PT61

{PT62-2
      NatureDecla:= Copy (TypeDecla, 1, 2);
      if (NatureDecla = '01') then
}
      if (TD2='01') then
//FIN PT62-2
         begin
         Inst:= 'ZCOM';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '02') then
}
      if (TD2='02') then
//FIN PT62-2
         begin
         Inst:= 'ZTDS';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '03') then
}
      if (TD2='03') then
//FIN PT62-2
         begin
         Inst:= 'ZIRP';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '04') then
}
      if (TD2='04') then
//FIN PT62-2
         begin
         Inst:= 'ZBTP';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '07') then
}
      if (TD2='07') then
//FIN PT62-2
         begin
         Inst:= 'ZIRC';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '08') then
}
      if (TD2='08') then
//FIN PT62-2
         begin
         Inst:= 'ZIP';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
{PT62-2
      if (NatureDecla = '09') then
}
      if (TD2='09') then
//FIN PT62-2
         begin
         Inst:= 'ZASS';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end
      else
//PT67-1
      if (TD2='12') then
         begin
         Inst:= 'ZTDS';
         EnregEnvoi.Inst:= Inst;
         CreeEnvoi (EnregEnvoi);
         end;
//FIN PT67-1

      LibereTOBENVOI;
      FiniMove;
      FiniMoveProgressForm;

//PT61
      if (SansFichierBase='-') then
// suppression du fichier sur disque
         begin
         if FileExists (NomComplet) then
            DeleteFile(PChar(NomComplet));
         end;
//FIN PT61

      PGIBox ('Pr�paration termin�e.#13#10'+
              'L''�tape suivante est la g�n�ration des envois qui cr�era#13#10'+
              'un fichier pouvant comporter plusieurs entreprises.#13#10'+
              'Module Param�tres, Menu Gestion envois,#13#10'+
              'Commande DADS-U - Envois DADS-U',
              'Pr�paration de la DADS-U');

      if Trace <> nil then
         Trace.Add ('Pr�paration de la DADS-U termin�e � '+TimeToStr(Now));
      if (Trace<>nil) then
{$IFNDEF DADSUSEULE}
         CreeJnalEvt ('001', '041', EtatEvent, nil, nil, Trace);
{$ENDIF}
   FreeAndNil (TInst);
   CommitTrans;
Except
   Rollback;
   CloseFile(FDADS);
   PGIBox ('Une erreur est survenue lors de la mise � jour de la base',
           'Pr�paration de la DADS-U');
   EtatEvent:= 'ERR';
   if Trace <> nil then
      begin
      Trace.Add ('Pr�paration de la DADS-U annul�e � '+TimeToStr(Now));
{$IFNDEF DADSUSEULE}
      CreeJnalEvt ('001', '041', EtatEvent, nil, nil, Trace);
{$ENDIF}
      end;
   FiniMove;
   FiniMoveProgressForm;
   END;
FreeAndNil (TPrudh);
FreeAndNil (Trace);
FreeAndNil (TEtabDADS); //PT64-1
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 30/10/2001
Modifi� le ... :   /  /
Description .. : Cr�ation des enregistrements ETABLISSEMENT
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.CreeEtab();
var
Buffer, BufDest, BufOrig, CodeAPE, CodeIso, Etab, EtabSelect, Libelle : string;
NomRue, numero, StDate, StEtab, StNbSal, StTestSal : string;
QNbSal, QRechEtab, QTestSal : TQuery;
TEtabD: TOB;
NbSal, reponse, TaxeSal : integer;
EtabAcreer : TypeEtab;
begin
ChargeTOBDADS;

DeleteDetail ('**', -400);        //PT64-3

//Donn�es Salari�-Etab
TEtabSelect := TOB.Create('Les �tablissements', NIL, -1);
EtabSelect:= GetControlText('MCETAB');
If not THMultiValCombobox(GetControl('MCETAB')).Tous then
   begin
   Etab:= ReadTokenpipe(EtabSelect, ';');
   While (Etab <> '') do
         begin
         TEtabD:= Tob.Create('UnEtab', TEtabSelect, -1);
         TEtabD.AddChampSupValeur('CODE', Etab);
         Etab:= ReadTokenpipe(EtabSelect,';');
         end;
   end
else
   RemplirListe ('TTETABLISSEMENT' ,'ET_FICTIF<>"X"' ,TEtabSelect);   //PT64-1

TEtabD := TEtabSelect.FindFirst([''],[''],FALSE);
if TEtabD <> nil then
   begin
{PT62-2
   Num:= 1;
}   
   Etab := '';
   While (TEtabD<>nil) do
         begin
         InitEtab (EtabAcreer);
         EtabAcreer.Code:= '**'+TEtabD.GetValue('CODE');
{PT62-2
         EtabAcreer.Num:= Num;
}

         if (TEtabD.GetValue('CODE') <> Etab) then
            begin
            StEtab := 'SELECT ET_ETABLISSEMENT, ET_SIRET, ET_LIBELLE,'+
                      ' ET_ADRESSE1, ET_ADRESSE2, ET_ADRESSE3, ET_CODEPOSTAL,'+
                      ' ET_VILLE, ET_PAYS, ET_APE, ETB_PRUDH, ETB_PRORATATVA'+
                      ' FROM ETABLISS'+
                      ' LEFT JOIN ETABCOMPL ON'+
                      ' ETB_ETABLISSEMENT=ET_ETABLISSEMENT WHERE'+
                      ' ET_ETABLISSEMENT="'+TEtabD.GetValue('CODE')+'"';
            QRechEtab:=OpenSql(StEtab,TRUE);
            if (not QRechEtab.EOF) then
               begin
               BufOrig := QRechEtab.FindField('ET_SIRET').AsString;
               ForceNumerique(BufOrig, BufDest);
               if ControlSiret(BufDest)=False then
                  begin
                  PGIBox ('Le SIRET de l''�tablissement '+
                         TEtabD.GetValue('CODE')+' n''est pas valide',
                         'Calcul �tablissement DADS-U');
                  ErrorDADSU:= 1;
                  end;

               if (Copy (BufDest, 1, 9)<> Copy (SIREN, 1, 9)) then
                  begin
                  PGIBox ('Le SIREN de l''�tablissement '+
                          TEtabD.GetValue('CODE')+' ne correspond pas au'+
                          ' SIREN de l''entreprise',
                          'Calcul �tablissement DADS-U');
                  ErrorDADSU:= 1;
                  end;

               if (QRechEtab.FindField('ET_CODEPOSTAL').AsString <> '') then
                  begin
                  if ((QRechEtab.FindField('ET_PAYS').AsString = 'FRA') and
                     ((QRechEtab.FindField('ET_CODEPOSTAL').AsString < '00000') or
                     (QRechEtab.FindField('ET_CODEPOSTAL').AsString > '99999'))) then
                     begin
                     PGIBox ('L''adresse de l''�tablissement '+
                            QRechEtab.FindField('ET_ETABLISSEMENT').AsString+
                            ' est mal renseign�e', 'Informations obligatoires DADS-U');
                     ErrorDADSU:= 1;
                     end;
                  end
               else
                  begin
                  PGIBox ('L''adresse de l''�tablissement '+
                         QRechEtab.FindField('ET_ETABLISSEMENT').AsString+
                         ' est mal renseign�e', 'Informations obligatoires DADS-U');
                  ErrorDADSU:= 1;
                  end;

               if QRechEtab.FindField('ET_VILLE').AsString = '' then
                  begin
                  PGIBox ('L''adresse de l''�tablissement '+
                         QRechEtab.FindField('ET_ETABLISSEMENT').AsString+
                         ' est mal renseign�e',
                         'Informations obligatoires DADS-U');
                  ErrorDADSU:= 1;
                  end;

               CodeAPE:= QRechEtab.FindField('ET_APE').AsString;
               if (RechDom('YYCODENAF', CodeAPE, TRUE)='') then
                  begin
                  reponse:= PGIAsk ('L''�tablissement "'+
                                    QRechEtab.FindField('ET_ETABLISSEMENT').AsString+'"#13#10'+
                                    ' a pour code APE "'+CodeAPE+'" qui est inconnu. #13#10'+
                                    'Voulez-vous continuer ?',
                                    'Informations obligatoires DADS-U');
                  if (reponse=mrNo) then
                     ErrorDADSU:= 1;
                  end;
               EtabAcreer.NAF:= CodeAPE;

               EtabAcreer.Siret:= BufDest;
               EtabAcreer.Libelle:= QRechEtab.FindField('ET_LIBELLE').AsString;

               Buffer:= '';
               EtabAcreer.Adr_Adresse1:= QRechEtab.FindField('ET_ADRESSE1').AsString;
               EtabAcreer.Adr_Adresse2:= QRechEtab.FindField('ET_ADRESSE2').AsString;
               EtabAcreer.Adr_Adresse3:= QRechEtab.FindField('ET_ADRESSE3').AsString;
               if (EtabAcreer.Adr_Adresse2 <> '') then
                  begin
                  if (EtabAcreer.Adr_Adresse3 <> '') then
                     Buffer:= EtabAcreer.Adr_Adresse2+' '+
                              EtabAcreer.Adr_Adresse3
                  else
                     Buffer:= EtabAcreer.Adr_Adresse2;
                  end
               else
                  if (EtabAcreer.Adr_Adresse3 <> '') then
                     Buffer:= EtabAcreer.Adr_Adresse3;

               if (Buffer <> '') then
                  EtabAcreer.Adr_Complement:= Buffer;

               if (EtabAcreer.Adr_Adresse1 <> '') then
                  AdresseNormalisee (EtabAcreer.Adr_Adresse1, numero, NomRue);

               if (numero <> '') then
                  EtabAcreer.Adr_Numero:= numero;
               if (NomRue <> '') then
                  EtabAcreer.Adr_NomRue:= NomRue;

               EtabAcreer.Adr_CP:= QRechEtab.FindField('ET_CODEPOSTAL').AsString;
               EtabAcreer.Adr_Ville:= PGUpperCase(QRechEtab.FindField('ET_VILLE').AsString);

               if ((QRechEtab.FindField('ET_PAYS').AsString <> 'FRA') and
                  (QRechEtab.FindField('ET_PAYS').AsString <> '')) then
                  begin
                  PaysISOLib (QRechEtab.FindField('ET_PAYS').AsString, CodeIso,
                              Libelle);
                  EtabAcreer.Adr_PaysCode:= CodeIso;
                  EtabAcreer.Adr_PaysNom:= Libelle;
                  end;

               StDate:= UsDateTime(StrToDate('31/12/'+PGExercice));
               StNbSal:= 'SELECT COUNT(PSA_SALARIE) AS NBSAL'+
                         ' FROM SALARIES WHERE'+
                         ' (PSA_DATESORTIE="'+UsDateTime(IDate1900)+'" OR'+
                         ' PSA_DATESORTIE IS NULL OR'+
                         ' PSA_DATESORTIE>="'+StDate+'") AND'+
                         ' PSA_DATEENTREE<="'+StDate+'" AND'+
                         ' PSA_DATEENTREE IS NOT NULL AND'+
                         ' PSA_ETABLISSEMENT="'+QRechEtab.FindField('ET_ETABLISSEMENT').AsString+'"';
               QNbSal:= OpenSql (StNbSal,True);

               if (not QNbSal.EOF) then
                  NbSal:= QNbSal.FindField('NBSAL').asinteger
               else
                  NbSal:= 0;
               Ferme (QNbSal);

               EtabAcreer.Effectif:= IntToStr(NbSal);

               If (NbSal=0) then
                  begin
                  StTestSal:= 'SELECT COUNT(DISTINCT(PDS_SALARIE)) AS NBPAIE'+
                              ' FROM DADSDETAIL WHERE'+
                              ' PDS_SEGMENT="S41.G01.00.005" AND'+
                              ' PDS_DONNEEAFFICH="'+QRechEtab.FindField('ET_ETABLISSEMENT').AsString+'" AND'+
                              ' PDS_DATEFIN <= "'+UsDateTime(FinExer)+'" AND'+
                              ' PDS_DATEDEBUT >= "'+UsDateTime(DebExer)+'" AND'+
                              ' PDS_EXERCICEDADS = "'+PGExercice+'"';
                  QTestSal:= OpenSql(StTestSal,True);

                  if (QTestSal.FindField('NBPAIE').AsInteger=0) then
                     EtabAcreer.SansSal:= '01';
                  Ferme(QTestSal);
                  end;

               TaxeSal:= QRechEtab.FindField('ETB_PRORATATVA').AsInteger;
               if (TaxeSal=0) then
                  EtabAcreer.TaxeSal:= '02'
               else
                  EtabAcreer.TaxeSal:= '01';

               if (GetControlText('CBPRUDH')='X') then
{PT62-2
                  EtabAcreer.Prudh:= QRechEtab.FindField('ETB_PRUDH').AsString;
}
                  begin
                  EtabAcreer.PrudhSect:= QRechEtab.FindField ('ETB_PRUDH').AsString;
                  EtabAcreer.PrudhDero:= '';
                  end;
//FIN PT62-2
               if (ErrorDADSU=0) then
                  CalculS80_Etablissement(EtabAcreer);
               end;
            Ferme(QRechEtab);

            Etab := TEtabD.GetValue('CODE');
{PT62-2
            Num:= Num+1;
}
            end;
         TEtabD := TEtabSelect.FindNext([''],[''],FALSE);
         end;

   end;
LibereTOBDADS;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Vincent GALLIOT
Cr�� le ...... : 21/08/2002
Modifi� le ... :   /  /
Description .. : Fonction permettant de contr�ler et d'�crire les donn�es
Suite ........ : dans le pr�-fichier
Mots clefs ... : PAIE,PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.ControleEcritureFic (ChampSal, Segment, Nature : string;
                                                var Donnee : string);
var
CInterdit, Libelle : string;
reponse : integer;
begin
Libelle := '';

{PT65
reponse:= ControleCar(Donnee , Nature, True);
}
reponse:= ControleCar(Donnee , Nature, True, CInterdit);
//FIN PT65
if (((TD2='03') or (TD2='04') or (TD2='07') or (TD2='08')) and
   ((Copy (Segment, 1, 14)='S41.G01.00.035') or
   (Copy (Segment, 1, 14)='S41.G01.00.063'))) then
{PT64-2
   Donnee:= '0';
}
   begin
   if (Copy (Segment, 16, 3)='001') then
      Donnee:= '0';
   end;
//FIN PT64-2
Debug ('Paie PGI/Pr�paration DADS-U : '+Segment+' | '+Donnee+' | '+
       IntToStr (reponse));
Writeln(FDADS, Segment+','''+Donnee+'''')
end;

procedure TOF_PG_DADSENTRE.MajDPPaie;
var T, T1, T2 : TOB ;
    Q     : TQuery ;
    St    : String;
    OkOk  : Boolean ;
    i     : Integer ;
    Mt    : Double ;
begin
OkOk := FALSE ;
if V_PGI.ModePCL = '1' then
   OkOk := True ;
if OkOk then
   begin
   T := TOB.create ('', NIL, -1);
   T1 := TOB.Create ('DPTABPAIE', T, -1) ;
   if Assigned (T1) then
      begin
      if VH_PAIE.PGDecalage then
         T1.PutValue ('DTP_DECALAGEPAIE', 'X')
      else
         T1.PutValue ('DTP_DECALAGEPAIE', '-') ;
      T1.PutValue ('DTP_NODOSSIER', PgRendNoDossier) ;
      T1.PutValue ('DTP_DATEDEB', DebExer) ;
      T1.PutValue ('DTP_DATEFIN', FINExer) ;
      T1.PutValue ('DTP_MILLESIME', 'N') ;
      T1.PutValue ('DTP_LIBEXERCICE', 'Social du '+DateToStr(DebExer)+' au '+
                                      DateToStr (FinExer) );
      St := 'SELECT PDS_DONNEEAFFICH'+
            ' FROM DADSDETAIL WHERE'+
            ' PDS_DATEDEBUT>="'+UsDateTime(DebExer)+'" AND'+
            ' PDS_DATEFIN <="'+UsDateTime (FinExer)+'" AND'+
            ' PDS_EXERCICEDADS ="'+PGExercice+'" AND'+
            ' PDS_TYPE="'+TypeD+'" AND'+
            ' PDS_SEGMENT="S41.G01.00.035.001"';
      Q := OpenSql (St, TRUE);
      T2 := TOB.Create ('LE Brut de la DADS', NIL,-1);
      T2.LoadDetailDB ('_DADSDETAIL','', '', Q, FALSE) ;
      Mt := 0 ;
      for i := 0 To T2.detail.count -1 do
          Mt := Mt + StrToFloat (T2.Detail [i].getValue ('PDS_DONNEEAFFICH') ) ;
      Ferme (Q) ;
      T1.PutVAlue ('DTP_MONTANTDADS', Mt ) ;
      FreeAndNil (T2) ;
      St:= 'SELECT Count (*) FROM SALARIES WHERE'+
           ' PSA_DATESORTIE>="'+UsDateTime (FinExer)+'" OR'+
           ' PSA_DATESORTIE = "'+UsDateTime (Idate1900)+'" OR'+
           ' PSA_DATESORTIE IS NULL';
      Q := OpenSql (St, TRUE);
      if NOT Q.EOF then
         T1.PutValue ('DTP_EFFECTIF', Q.Fields [0].AsInteger) ;
      Ferme (Q) ;
      St:= 'SELECT Count (*) FROM SALARIES WHERE'+
           ' PSA_DATESORTIE>="'+UsDateTime (DebExer)+'" AND'+
           ' PSA_DATESORTIE <="'+UsDateTime (FinExer)+'"';
      Q := OpenSql (St, TRUE);
      if NOT Q.EOF then
         T1.PutValue ('DTP_NBSORTIES', Q.Fields [0].AsInteger) ;
      Ferme (Q) ;
      St:= 'SELECT Count (*) FROM SALARIES WHERE'+
           ' PSA_DATEENTREE>="'+UsDateTime (DebExer)+'" AND'+
           ' PSA_DATEENTREE <="'+UsDateTime (FinExer)+'"';
      Q := OpenSql (St, TRUE);
      if NOT Q.EOF then
         T1.PutValue ('DTP_NBENTREES', Q.Fields [0].AsInteger) ;
      Ferme (Q) ;
      T.InsertOrUpdateDB (FALSE);
      end;
   FreeAndNil (T) ;
   end;
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : VG
Cr�� le ...... : 06/10/2005
Modifi� le ... :   /  /
Description .. : Modification de la valeur du motif d'entr�e
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
{PT62-1
procedure TOF_PG_DADSENTRE.CommChange(Sender: TObject);
begin
if (GetControlText('CCOMM') = '03') then
   begin
   SetControlVisible ('ECOORD', True);
   SetControlVisible ('CCIVILITE', False);
   SetControlVisible ('EPERSONNE', False);
   SetControlText('LCOORD', 'Adresse mail');
   SetControlText('ECOORD', GetParamSoc('SO_PGCOORDCRE'));
   SetControlText('CCIVILITE', '');
   SetControlText('EPERSONNE', '');
   end
else
if (GetControlText('CCOMM') = '05') then
   begin
   SetControlVisible ('ECOORD', False);
   SetControlVisible ('CCIVILITE', True);
   SetControlVisible ('EPERSONNE', True);
   SetControlText('LCOORD', 'Personne destinataire');
   SetControlText('ECOORD', '');
   SetControlText ('CCIVILITE', GetParamSoc('SO_PGCIVILCRE'));
   if (GetControlText ('CCIVILITE')='') then
      SetControlText ('CCIVILITE', 'MR');
   SetControlText('EPERSONNE', GetParamSoc('SO_PGNOMCRE'));
   end;
end;
}


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : VG
Cr�� le ...... : 30/01/2006
Modifi� le ... :   /  /
Description .. : Modification de la CheckBox Neant
Mots clefs ... : PAIE;PGDADSU
*****************************************************************}
procedure TOF_PG_DADSENTRE.NeantChange(Sender: TObject);
begin
if (GetControlText('CHNEANT') = 'X') then
   begin
   SetControlEnabled ('CHPREVOYANCE', False);
   SetControlEnabled ('CHHONORAIRE', False);
   SetControlText('CHPREVOYANCE', '');
   SetControlText('CHHONORAIRE', '');
   end
else
   begin
   SetControlEnabled ('CHPREVOYANCE', True);
   SetControlEnabled ('CHHONORAIRE', True);
   end;
end;

Initialization
registerclasses([TOF_PG_DADSENTRE]) ;

end.
