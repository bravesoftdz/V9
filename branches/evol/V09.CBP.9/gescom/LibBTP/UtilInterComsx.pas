{***********UNITE*************************************************
Auteur  ...... : Olivier TARCY
Cr�� le ...... : 16/04/2002
Modifi� le ... : 22/04/2002
Description .. : Fonctions utilis�es pour l'interface comptable
Mots clefs ... : BOS5;INTERCOMPTA
*****************************************************************}
unit UtilInterComsX;

interface

uses
  HEnt1,
  Forms,
  Windows,
  Classes,
  Controls,
  IniFiles,
  HCtrls,
  UTOB,
  ComCtrls,
  StdCtrls,
  {$IFNDEF EAGLCLIENT}
  DB,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ELSE}
  Uhttp,
  {$ENDIF}
  SysUtils,
  ParamSoc,
  ed_tools,
  EntGC,
  FileCtrl,
  LicUtil,
  Ent1;

  Type
  		ChgComsX = RECORD
        FichierEcr		 : HString;
		    GestEtab 			 : HString;
        TransfertVers	 : Hstring;
	      NatureTransfert: HString;
  			Format 				 : HString;
        DateArret			 : HString;
        Exercice			 : HString;
        DateDebut			 : HString;
        DateDeFin			 : HString;
        Societe 			 : HString; //Soci�t� courante
			  User 					 : HString; //User courant
        DateFile			 : HString;
        TypeEcr				 : HString;
        Email					 : HString;
        Journal				 : HString;
        TypeEcriture	 : Hstring;
		    TypeEcrRecup	 : HString;
		    TypeEcrGen 	 	 : HString;
			  FichierRapport : HString;
        Envoye				 : HString;
      End;

	function GenereFile(ChargeComsx : ChgComsX; Var BlocNotes : TStringList) : Boolean;
  function ImportFile(ChargeComsx : ChgComsX; Var BlocNotes : TStringList) : Boolean;


const
  ChCodeCpta    = 'CODECPTA';
  ChSeqDateDeb  = 'SEQDATEDEB';
  ChSeqDateFin  = 'SEQDATEFIN';
  ChSociete     = 'SOCIETE';
  ChCaptionEcr = 'DEJAEXTRAIT.Caption';
  ChJournalEvent = 'JOURNALEVENT';

  // DC 04/07/07 - Gestion des retours en n�gatif ou positif
  COMPTA_RETOUR_POSITIF : string = '?';

  // libell�s des messages
  TexteMessage: array[ 1..112 ] of hstring = (
    {1}  'Aucune ligne trouv�e pour la p�riode s�lectionn�e.'
    {2}, 'Aucune pi�ce ne correspond aux crit�res s�lectionn�s.'
    {3}, 'Tiers inconnu.'
    {4}, 'Impossible de trouver le compte HT de l''article pour : '
    {5}, 'Impossible de trouver le compte de taxe pour : '
    {6}, 'Impossible de trouver le compte de remise pour : '
    {7}, 'Impossible de trouver le compte d''escompte pour : '
    {8}, 'Impossible de trouver le compte de r�glement pour : '
    {9}, 'Impossible de trouver le compte de ports et frais pour :'
    {10}, 'Traitement annul� par l''utilisateur'
    {11}, 'Erreur lors de la g�n�ration des lignes.'
    {12}, 'Veuillez confirmer la comptabilisation des �critures d�j� extraites.'
    {13}, 'L''emplacement du fichier d''export n''est pas d�fini dans le param�trage.'
    {14}, 'Le nom de fichier est incorrect.'
    {15}, 'Le traitement ne s''est pas termin� correctement.'
    {16}, 'Impossible de trouver le compte de remise en banque pour : '
    {17}, 'Attention : veuillez confirmer l''int�gration des �critures dans la base courante.'
    {18}, 'Impossible de trouver le compte de frais sur carte bancaire pour : '
    {19}, 'Nombre de boutiques trait�es : %1.0f'
    {20}, 'Nombre de journ�es trait�es : %1.0f'
    {21}, 'Transfert termin�'
    {22}, 'Transfert comptable'
    {23}, 'Confirmez-vous la s�lection ci-dessous ? #13#10'
    {24}, 'Rapport de fin : '
    {25}, 'T�che programm�e en process serveur'
    {26}, 'Impossible de trouver le compte de l''op�ration de caisse pour : '
    {27}, 'L''�tape "%s" est termin�e.'
    {28}, 'L''�tape "%s" ne s''est pas termin�e correctement.'
    {29}, 'Vous devez relancer cette �tape.'
    {30}, 'Aucune t�che n''est en attente ou en cours de traitement.'
    {31}, 'T�che termin�e.'
    {32}, 'Aucune information n''est disponible, vous devez relancez la t�che de chargement.'
    {33}, 'La sauvegarde des �critures dans la table temporaire n''a pas fonctionn�e.'
    {34}, 'Aucunes �critures � g�n�rer.'
    {35}, 'Erreur lors de l''enregistrement des �critures.'
    {36}, 'Vous devez installer l''ex�cutable COMSX, il n''est pas pr�sent dans le r�pertoire : '
    {37}, 'Le r�pertoire d''export n''existe pas : '
    {38}, 'Probl�me lors du chargement des lignes.'
    {39}, 'Probl�me lors du chargement des pi�ces.'
    {40}, 'Aucune pi�ce trouv�e pour la p�riode s�lectionn�e.'
    {41}, 'Probl�me lors du chargement des ports et frais.'
    {42}, 'Probl�me lors du chargement des taxes.'
    {43}, 'Probl�me lors du chargement des acomptes.'
    {44}, 'Probl�me lors du chargement des �ch�ances pour les pi�ces n�goces.'
    {45}, 'Probl�me lors du chargement des op�rations de caisse client.'
    {46}, 'Probl�me lors du chargement des op�rations de caisse.'
    {47}, 'Probl�me lors du chargement des modes de paiement.'
    {48}, 'Probl�me lors du traitement des axes analytiques.'
    {49}, 'Probl�me lors du chargement des remises en banques du coffre.'
    {50}, 'Le journal n''est pas param�tr� pour la nature de pi�ce : '
    {51}, 'Le param�trage des tickets est incorrect.'
    {52}, '%0:s souche %1:s numero %2:s de l''�tablissement %3:s du %4:s'
    {53}, 'Le r�pertoire d''export n''est pas param�tr�.'
    {54}, 'Probl�me de mise � jour du type compta des pi�ces.'
    {55}, 'Impossible de trouver le journal de l''op�ration de caisse pour : '
    {56}, 'Impossible de trouver le journal de r�glement pour : '
    {57}, 'Impossible de trouver le journal de remise en banque pour : '
    {58}, 'V�rifier dans CEGIDPGI.INI de la COMSX que la soci�t� suivante existe : '
    {59}, 'Impossible de trouver le compte collectif pour : '
    {60}, 'Impossible de trouver le compte d''encaissement pour : '
    {61}, 'Vous devez passer le journal suivant en mode saisie="Piece" : '
    {62}, 'L''exercice comptable correspondant aux pi�ces � transf�rer n''existe pas.'
    {63}, 'Le pr�-contr�le des pi�ces est correcte.'
    {64}, 'Le contr�le a r�v�l� des anomalies. Veuillez vous r�f�rer � l''onglet rapport pour plus de d�tails.'
    {65}, 'Les champs "GP_ETABLISSEMENT" et "GL_ETABLISSEMENT" ne sont pas renseign�s.'
    {66}, 'Le champ "GP_ETABLISSEMENT" n''est pas renseign� : '
    {67}, 'Le champ "GL_ETABLISSEMENT" n''est pas renseign� : '
    {68}, 'Incoh�rence sur le r�gime de taxe qui est diff�rent sur la pi�ce et les lignes : '
    {69}, 'Impossible de comptabiliser cette pi�ce sans article mouvement� : '
    {70}, 'V�rifier �galement que la ComSX se lance manuellement sans anomalie. Si tel n''est pas le cas, elle n''est pas install�e correctement.'
    {71}, 'Vous devez installer l''ex�cutable eCOMSX, il n''est pas pr�sent dans le r�pertoire : '
    {72}, 'Renseignez le param�trage dans Param�tres->Documents->Documents->Natures Onglet G�n�ralit� :le champ "�quivalence" = FFO".'
    {73}, 'Vous devez le renseigner dans les param�tres soci�t�s->gestion commerciale->Passation comptable->R�pertoire d''export.'
    {74}, 'Incoh�rence sur le tiers qui est diff�rent sur la pi�ce et les lignes : '
    {75}, 'Incoh�rence sur le tiers factur� qui est diff�rent sur la pi�ce et les lignes : '
    {76}, 'Vous devez renseigner un compteur de simulation sur le journal suivant : '
    {77}, 'Probl�me lors du chargement des litiges.'
    {78}, 'Impossible de trouver le compte du litige : '
    {79}, 'Le nom de la soci�t� ne doit pas contenir d''espaces. Veuillez le modifier dans votre fichier CEGIDPGI.INI.'
    {80}, 'Le nom du r�pertoire d''export ne doit pas contenir d''espaces. Veuillez le modifier dans les param�tres soci�t�s : gestion commerciale->Passation comptable->R�pertoire d''export.'
    {81}, 'Les op�rations de caisse suivantes ont un param�trage incoh�rent.'
    {82}, 'Le type article financier impose que l''option tr�sorerie soit d�coch�e :'
    {83}, 'Le type article financier impose que l''option tr�sorerie soit coch�e :'
    {84}, 'L''option tr�sorerie est ind�finie :'
    {85}, 'Op�ration de caisse : %s - Type article financier : %s - %s'
    {86}, 'Option op�ration de caisse coch�e'
    {87}, 'Option op�ration de caisse d�coch�e'
    {88}, 'Option op�ration de caisse ind�finie'
    {89}, 'Mode de paiement inconnu :'
    {90}, 'Impossible de comptabiliser cette pi�ce comportant des op�rations de caisse tr�sorerie ainsi que d''autres articles'
    {91}, '%0:s souche %1:s n� %2:s date %3:s �tablissement %4:s tiers %5:s'
    {92}, 'Le nom du r�pertoire d''export n''est pas d�fini. Veuillez le d�finir dans les param�tres soci�t�s : gestion commerciale->Passation comptable->R�pertoire d''export.'
    {93}, 'Les pi�ces suivantes, saisies dans une ancienne version, comportent des arrondis de taxes incoh�rents. Vous devez les recalculer par l''utilitaire "Administration/Maintenance/Recalcul des pi�ces".'
    {94}, 'V�rifier �galement que les fichiers suivants soient pr�sents dans le sous-r�pertoire "Script" de votre serveur CWAS :'
    {95}, 'Erreur lors du chargement m�moire des lignes analytiques'
    {96}, 'Vous devez relancer la g�n�ration des �critures.'
    {97}, '%0:s compteurs de la souche %1:s ont �t� utilis�s par un autre utilisateur.'
    {98}, 'Le compteur de la souche %0:s n''est plus positionn� � sa valeur initiale %1:s.'
    {99}, 'Les natures de pi�ces s�lectionn�es sont incompatibles. Le param�trage des dates des �critures comptables doit �tre identique pour toutes les natures s�lectionn�es.'
   {100}, 'V�rifiez ce param�trage via le menu param�tres / Documents / Documents / Natures, onglet personnalisation comptable.'
   {101}, 'Les modes de paiement suivants ont un param�trage incoh�rent.'
   {102}, 'Le compte non collectif %0:s impose que l''option "D�tail sur auxiliaire" du mode de paiement %1:s ne soit pas coch�e.'
   {103}, 'Le compte collectif %0:s impose que l''option "D�tail sur auxiliaire" du mode de paiement %1:s soit coch�e.'
   {104}, 'Les exceptions par �tablissements des modes de paiement suivants ont un param�trage incoh�rent.'
   {105}, 'Le compte non collectif %0:s impose que l''option "D�tail sur auxiliaire" du mode de paiement %1:s (exception �tablissement %2:s) ne soit pas coch�e.'
   {106}, 'Le compte collectif %0:s impose que l''option "D�tail sur auxiliaire" du mode de paiement %1:s (exception �tablissement %2:s) soit coch�e.'
   {107}, 'Les op�rations de caisse suivantes ont un param�trage incoh�rent.'
   {108}, 'Le compte non collectif %0:s impose que l''option "D�tail sur auxiliaire" de l''op�ration de caisse 1:s ne soit pas coch�e.'
   {109}, 'Le compte collectif %0:s impose que l''option "D�tail sur auxiliaire" de l''op�ration de caisse %1:s soit coch�e.'
   {110}, 'Les exceptions par �tablissements des op�rations de caisse suivantes ont un param�trage incoh�rent.'
   {111}, 'Le compte non collectif %0:s impose que l''option "D�tail sur auxiliaire" de l''op�ration de caisse %1:s (exception �tablissement %2:s) ne soit pas coch�e.'
   {112}, 'Le compte collectif %0:s impose que l''option "D�tail sur auxiliaire" de l''op�ration de caisse %1:s (exception �tablissement %2:s) soit coch�e.'
    );


  // libell�s des taches
  LibTache: array[1..7] of hstring = (
    {1}  'Chargement des informations'
    {2}, 'Affectation des comptes'
    {3}, 'G�n�ration des �critures'
    {4}, 'Export des �critures'
    {5}, 'Transfert comptable'
    {6}, 'Import des �critures'
    {7}, 'Pr�-contr�le des pi�ces avant le chargement'
    ) ;

  // Aide au param�trage
  TexteParam: array[1..14] of hstring = (
    {1}  'Renseignez le compte dans "Administration/Liaison comptable/Ventilations comptables".'
    {2}, 'Renseignez le compte dans "Param�tres/Gestion/Taxe/Taux de taxe -> Onglet complement".'
    {3}, 'Renseignez le compte dans "Param�tres/Gestion/Mode de paiement/Compl�ment par �tablissement".'
    {4}, 'Renseignez le compte dans "Administration/Liaison comptable/Ventilations comptables" pour la famille comptable article = FCB.'
    {5}, 'Renseignez le compte dans "Param�tres/Gestion/Op�ration de caisse/Compl�ment par �tablissement".'
    {6}, 'Renseignez le journal dans "Param�tres/Documents/Documents/Natures -> Onglet Action/Comptabilit�.'
    {7}, 'Renseignez le journal dans "Param�tres/Gestion/Mode de paiement/Compl�ment par �tablissement".'
    {8}, 'Renseignez le journal dans "Param�tres/Gestion/Op�ration de caisse/Compl�ment par �tablissement".'
    {9}, 'Renseignez le compte collectif du tiers dans "Donn�es de base/clients ou fournisseurs".'
    {10}, 'Renseignez le compte d''encaissement de l''�tablissement dans "Donn�es de base/�tablissement".'
    {11}, 'Modifier le champ D�part du compteur dans "Administration/Liaison comptable/Compteurs comptables".'
    {12}, 'Modifier le champ Mode saisie du journal dans "Administration/Liaison comptable/Journaux".'
    {13}, 'Cr�er l''exercice comptable dans "Administration/Liaison comptable/Ouverture d''exercice".'
    {14}, 'Renseignez un compteur de simulation du journal dans "Administration/Liaison comptable/Journaux".'
    ) ;

Var
  // Pour rapport de fin de tache
  NombreBtqTraite, NombreJourneeTraite : Double ;
  // TOB Entete du transfert comptable
  TOBEnteteInterCompta : TOB;
  TobSection : TOB;
  // Evenement avec calcul des temps
  //FLogEvent: TLogEvent;
  // ParamSoc de l'affichage des mesures de temps AUC / SIM / DET
  AfficheMesureTmp: hstring;
  // Bloc notes
  //BlocNotes : TStringList ;
  // Ex�cution totale ou par �tape
  ExecutionTotal : Boolean ;
  //Chemin d'acc�s
	PathFile				: HString;
  PathComSx				: HString;
  FichierIni 			: TIniFile;


Type
  TTypeTacheInterCpta = ( icPreControl, icPlanifie, icChargement, icAffecteCompte, icGenereEcr, icExport, icImport, icNull );

function NomDuFichierExport( NomFichier, Natures: hstring; var DateFile: hstring ): hstring;

//AC 11/29/05

procedure MAJBlocNoteTache (Debut,TacheOk : Boolean; Tache : TTypeTacheInterCpta; Var BlocNotes : TStringList );
procedure MAJBlocNote (Var BlocNotes : TStringList; sMessage : hstring; NumErreur : integer = 0);

Procedure ChargeRapportOK(NomFichier : Hstring; Var BlocNotes : TStringList);
Procedure ChargeRapportErr(NomFichier : Hstring; Var BlocNotes : TStringList);

function SetLastError( Num: integer; LibEcran : hstring = '' ) : hstring ;
function ControleParametrageExport( RepertoireFichier, RepertoireComSx : hstring) : integer ;

function GetPathFileTransfert : string;
function GetPathFileComSx : string;

Function ControleErreurParametres(ChargeComsX : ChgComsx; Var Blocnotes : TStringList ) : Boolean;
Function ChargeIniExport(ChargeComsX: ChgComsX; FileIni : Hstring; Var BlocNotes :TStringList ) : Boolean;
Function ChargeIniImport(ChargeComsX: ChgComsX; FileIni : Hstring; Var BlocNotes :TStringList ) : Boolean;

implementation

uses
{$IFDEF VER150}
	Variants,
{$ENDIF}

{$IFDEF NOMADE}
  UtilPgi,
{$ENDIF NOMADE}

{$IFDEF EAGLSERVER}
  UtilProcessServer,
{$ENDIF EAGLSERVER}
  HMsgBox,
  CBPPath;
  //TobUtil,
  //cbpPath;

function LanceTraitement( LigneDeCommande: string ): Boolean;
var
  TSI: TStartupInfo;
  TPI: TProcessInformation;
begin

  FillChar( TSI, SizeOf( TStartupInfo ), 0 );

  TSI.cb := SizeOf( TStartupInfo );

  Result := CreateProcess( nil, PCHAR( LigneDeCommande ), nil, nil, False,
                           CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, TSI, TPI );
  if (Result) then
     begin
     while( WaitForSingleObject(Tpi.hProcess, 1000) <> WAIT_OBJECT_0 ) do
        begin
        if( WaitForSingleObject(Tpi.hProcess, 1000) = WAIT_OBJECT_0 ) then Break;
        Application.ProcessMessages;
        end;
     CloseHandle( TPI.hProcess );
     CloseHandle( TPI.hThread );
     end;

end;

//G�n�ration du fichier INIT DE traitement par COMSX
function GenereFile(ChargeComsx : ChgComsX; Var BlocNotes : TStringList) : Boolean ;//var GenerationFileOk: Boolean; RapportLst: TStrings = nil );
var //
    FileIni 				: HString;
    //
	  NumErreur  			: Integer;
	  //
    GenerationFileOk: Boolean;

begin

	  Result := False ;

  	MAJBlocNoteTache (True, False, icExport, BlocNotes );

    GenerationFileOk := false;

    // Toujour format �tendu
    PathFile := IncludeTrailingBackslash(ExtractFileDir(ChargeComsX.FichierEcr));
    PathComSx := GetPathFileComSx;

    FileIni := PathFile + 'COMSX.INI';

    // Controle du param�trage pour l'export
    NumErreur := ControleParametrageExport( PathFile, PathComSx ) ;
    if NumErreur <> 0 then
       begin
       if ( NumErreur = 37 ) or ( NumErreur = 53 ) then
          MAJBlocNote(BlocNotes, PathFile, NumErreur)
       else
          MAJBlocNote(BlocNotes, PathComSx, NumErreur);
       exit;
       end;

  	Try
  	  if ControleErreurParametres(ChargeComsX, BlocNotes) then
    	   GenerationFileOk := False
    	else
      	 GenerationFileOk :=  ChargeIniExport(ChargeComsX, FileIni, BlocNotes);
	  Finally
      //Tache Export d'ecritures Termin�
    	if (GenerationFileOk) then
    	   begin
         Result := True ;
         // Mise � jour bloc notes de la tache fin + ok
         MAJBlocNoteTache ( False, True, icExport, BlocNotes ) ;
         ChargeRapportOK(ChargeComSx.FichierEcr, BlocNotes);
         end
      else
         begin
         // Mise � jour bloc notes de la tache fin + erreur
         MAJBlocNoteTache ( False, False, icExport, BlocNotes ) ;
         ChargeRapportErr(ChargeComSx.FichierEcr, BlocNotes);
         end;
			   // Suppression du Fichier INI
    		 if FileExists(FileIni) then DeleteFile(FileIni);
      end;

end;

Function ControleErreurParametres(ChargeComsX : ChgComsx; Var Blocnotes : TStringList ) : Boolean;

   //Procedure d'ecriture des erreurs
   procedure ErreurParam( Champ, Msg: hstring);
   begin
       if ( Assigned( BlocNotes ) ) then
          begin
          if ( Champ = '' ) then
            Champ := 'MANQUANT';
          BlocNotes.Add( Msg + Champ );
          end;
   end;

begin

  result := false;

  With ChargeComsX Do
       Begin
	     if ( Societe = '' ) or ( User = '' ) or ( PathFile = '' ) or ( GestEtab = '' ) or
          ( FichierEcr = '' ) or ( DateDebut = '' ) or ( DateDeFin = '' ) or ( TypeEcrGen = '' ) or ( FichierRapport = '' ) then
	  	    begin
      		if (Assigned(BlocNotes)) then
				      begin
              BlocNotes.Add( '***** ' + TraduireMemoire( 'TRAITEMENT ANNULE ' ) + '***************************************************' );
              BlocNotes.Add( '***** ' + TraduireMemoire( 'ERREUR DANS LES PARAMETRES ' ) + '******************************************' );
              end;
          ErreurParam(FichierEcr, TraduireMemoire( 'Fichier des �critures    : ' ) );
          ErreurParam( Societe, TraduireMemoire( 'Nom de la base           : ' ));
          ErreurParam( User, TraduireMemoire( 'Utilisateur              : ' ));
          if (GestEtab = 'TRUE' ) then
             ErreurParam(GestEtab, TraduireMemoire( 'Multi Etablissements     : OUI' ) )
          else
             ErreurParam( GestEtab, TraduireMemoire( 'Multi Etablissements     : NON' ) );
          ErreurParam( PathFile, TraduireMemoire( 'Emplacement des fichiers : ' ) );
          //ErreurParam( FichierTiers, TraduireMemoire( 'Fichier des tiers        : ' ) );
          ErreurParam( FichierRapport, TraduireMemoire( 'Fichier du rapport       : ' ) );
          ErreurParam( DateDebut, TraduireMemoire( 'Date d�but               : ' ) );
          ErreurParam( DateDeFin, TraduireMemoire( 'Date fin                 : ' ) );
          ErreurParam( TypeEcriture, TraduireMemoire( 'Type �critures           : ' ) );
          ErreurParam( FichierRapport, TraduireMemoire( 'Fichier du rapport       : ' ) );
          result := true;
          end;
       end;

end;

function ImportFile(ChargeComsx : ChgComsX; var BlocNotes : TStringList) : Boolean; //BaseCompta: hstring;
var Fileini					: hstring;
    NomFichier			: hstring;
    GenerationFileOk: Boolean;
    NumErreur  			: Integer;
begin

  	Result := False ;

  	MAJBlocNoteTache ( True, False, icImport, BlocNotes ) ;

    GenerationFileOk := True;
    //
    PathFile :=  ExtractFileDir(ChargeComsX.FichierEcr) + '\'; //GetPathFileTransfert;
    PathComSx := GetPathFileComSx;

    FileIni := PathFile + 'COMSX.INI';

    // Controle du param�trage pour l'export
    NumErreur := ControleParametrageExport( PathFile, PathComSx ) ;
    if NumErreur <> 0 then
       begin
       if ( NumErreur = 37 ) or ( NumErreur = 53 ) then
          MAJBlocNote(BlocNotes, PathFile, NumErreur)
       else
          MAJBlocNote(BlocNotes, PathComSx, NumErreur);
       exit;
       end;

    //
    NomFichier := ChargeComsX.FichierEcr ;
    NomFichier := ChangeFileExt(NomFichier, '.ARC');
    //
  	Try
       if ControleErreurParametres(ChargeComsX, BlocNotes) then
     		  GenerationFileOk := False
  	   else
          GenerationFileOk := ChargeIniImport(ChargeComsX, FileIni, BlocNotes);
    Finally
   		 if ( GenerationFileOk ) then
    			begin
      		Result := True ;
		      // Mise � jour bloc notes de la tache fin + ok
    		  MAJBlocNoteTache(False, True, icImport, BlocNotes ) ;
          ChargeRapportOK(ChargeComSx.FichierEcr, BlocNotes);
			    end
       else
          Begin
    			// Mise � jour bloc notes de la tache fin + erreur
     			MAJBlocNoteTache ( False, False, icImport, BlocNotes ) ;
          ChargeRapportErr(ChargeComSx.FichierEcr, BlocNotes);
          end;
  	end;

    // Suppression du Fichier INI
    if FileExists(FileIni) then DeleteFile(FileIni);

end;

Procedure ChargeRapportOK(Nomfichier : Hstring ;Var BlocNotes : TStringList);
Begin

    NomFichier := ExtractFileName(Nomfichier);
    NomFichier := ChangeFileExt(NomFichier, '.OK');
    NomFichier := 'ListeCom' + Nomfichier;

    Nomfichier := Pathfile + Nomfichier;

    if not FileExists(Nomfichier) then exit;

    //Chgargement rapport d'erreur dans bloc-note...
    Blocnotes.LoadFromFile(Nomfichier);

    //Suppression du rapport d'erreur
    DeleteFile(NomFichier);

end;

Procedure ChargeRapportErr(Nomfichier : Hstring ;Var BlocNotes : TStringList);
Begin

    NomFichier := ExtractFileName(Nomfichier);
    NomFichier := ChangeFileExt(NomFichier, '.err');
    NomFichier := 'ListeCom' + Nomfichier;

    if not FileExists(Nomfichier) then exit;

    //Chgargement rapport d'erreur dans bloc-note...
    Blocnotes.LoadFromFile(Nomfichier);

    //Suppression du rapport d'erreur
    DeleteFile(NomFichier);

end;

Function ChargeIniExport(ChargeComsX : ChgComsX; FileIni : Hstring; Var BlocNotes :TStringList ) : Boolean;
Var Action				 : HString;
		sExclure,StExt2,sExct1			 : HString;
 	  PwdTraitmtlot	 : HString;
	  UserTraitmtlot : HString;
    Q 						 : TQuery;
    Command				 : HString;
Begin

   ////////// CREATION du .INI
   Result := false;

   Action  := 'COMMANDE';

   if FileExists( Fileini ) then DeleteFile( FileIni );

   //AssignFile( FichierIni, FileIni );

   FichierIni := TIniFile.Create( Fileini );
   //ReWrite( FichierIni );

	 FichierIni.WriteString(Action, 'NOMFICHIER', ChargeComsX.FichierEcr);
   FichierIni.WriteString(Action, 'GESTIONETAB', ChargeComsX.GestEtab);
   FichierIni.WriteString(Action, 'TRANSFERTVERS', ChargeComsX.TransfertVers );
   FichierIni.WriteString(Action, 'NATURETRANSFERT', ChargeComsX.NatureTransfert );
   FichierIni.WriteString(Action, 'FORMAT', ChargeComsX.Format );
   FichierIni.WriteString(Action, 'DATEARRET', ChargeComsX.DateArret);
   FichierIni.WriteString(Action, 'EXERCICE', ChargeComsX.Exercice );
   FichierIni.WriteString(Action, 'DATEECR1', ChargeComsX.DateDebut );
   FichierIni.WriteString(Action, 'DATEECR2', ChargeComsX.DateDeFin );
   FichierIni.WriteString(Action, 'TYPE', ChargeComsX.TypeEcrRecup );
   FichierIni.WriteString(Action, 'TYPEECR', ChargeComsX.TypeEcrGen );
   FichierIni.WriteString(Action, 'MAIL', ChargeComsX.EMail );
   FichierIni.WriteString(Action, 'JOURNAL', ChargeComsX.Journal );
   FichierIni.WriteString(Action, 'RAPPORT', ChargeComsX.FichierRapport );

   // Les param�tres � exclure lors de l'export ComSx sont d�finis par le param�tre soci�t� :
   //Administration PGI / Param�tres de d�bogage / Param�tres exclus lors de l'export : multi-combo sur la tablette MBOCPTAEXCLPAR
   if ExisteSql( 'SELECT 1 FROM PARAMSOC WHERE SOC_NOM="SO_MBOCPTAEXCLPA1"' ) then // Test pour mise en place avant cr�ation du paramsoc dans la socref officielle
      begin
      sExclure := '';
      sExct1 := GetParamSocSecur( 'SO_MBOCPTAEXCLPA1', 'MDP;MDR;DEV;REG;SOU;EXO;TL;SSA;PARAM' ); // Tous par d�faut
      if sExct1 = '<<Tous>>' then sExct1 := '';
      StExt2 :=  GetParamSocSecur( 'SO_MBOCPTAEXCLPA2', '' ); // Aucun par d�faut
      if StExt2 = '<<Tous>>' then StExt2 := '';
      if sExct1 <> '' then sExclure := sExct1;
      if StExt2 <> '' then if sExclure<>'' then sExclure := sExclure+';'+stExt2 else sExclure := StExt2;
      end
   else
   //sExclure := 'MDP;MDR;DEV;REG;SOU;EXO;TL;SSA;PARAM';
     sExclure := '';

   FichierIni.WriteString( Action, 'EXCLURE', '[' + sExclure + ']' );
   FichierIni.WriteString( Action,'EXPORTE', ChargeComsX.Envoye);
   FichierIni.WriteString( Action, 'CTRS', 'TRUE' );

   FichierIni.Free;

   // Fin FICHIER INI
   PwdTraitmtlot := V_PGI.Password;
   UserTraitmtlot := V_PGI.UserLogin;

   // ... car le mot de passe du jour ne marchera plus � minuit...
	 if V_PGI.Password=CryptageSt(DayPass(Date)) then
     	begin
      Q := OpenSQL('select US_ABREGE, US_PASSWORD from UTILISAT where US_SUPERVISEUR="X"', True);
      if not Q.Eof then
         begin
         UserTraitmtlot := Q.FindField('US_ABREGE').AsString;
         PwdTraitmtlot := Q.FindField('US_PASSWORD').AsString;
         end;
	 	  Ferme(Q);
      End;

   {$IFDEF EAGLCLIENT}
   Command := PathComSx + 'eComSx.exe /SERVER="' + AppServer.HostName + '"';
   {$ELSE}
   Command := PathComSx+'ComSx.exe';
   {$ENDIF EAGLCLIENT}

   Command := Command + ' /USER="' + UserTraitmtlot + '"'+ ' /PASSWORD=' + PwdTraitmtlot
                      + ' /DATE=' + DateToStr( V_PGI.DateEntree ) + ' /DOSSIER=' + ChargeComsx.Societe
                      + ' /INI=' + PathFile + 'ComSx.ini;' + ChargeComsx.TypeEcriture+ ';Minimized' ;

   MAJBlocNote(BlocNotes, Command, 0);

   Result := LanceTraitement( Command );

   //Control existance du fichier final
	 if not FileExists(ChargeComSx.FichierEcr ) then
      begin
      MAJBlocNote (BlocNotes, ChargeComsX.Societe, 58) ;
      MAJBlocNote (BlocNotes, 'PGIComSxAPI.dll ComSx.inf', 94);
      MAJBlocNote (BlocNotes , '', 70);
      Result := False ;
      end;

end;

Function ChargeIniImport(ChargeComsX : ChgComsX; FileIni : Hstring; Var BlocNotes :TStringList ) : Boolean;
Var Action				 : HString;
 	  PwdTraitmtlot	 : HString;
	  UserTraitmtlot : HString;
    Q 						 : TQuery;
    Command				 : HString;
Begin

   ////////// CREATION du .INI
   Action := 'COMMANDE';

   if FileExists( Fileini ) then DeleteFile( FileIni );

   FichierIni := TIniFile.Create( Fileini );

   //Writeln( FichierIni, '[COMMANDE]' );

   FichierIni.WriteString( Action, 'REPERTOIRE', PathFile );
   FichierIni.WriteString( Action, 'NOMFICHIER', ExtractFileName(ChargeComsX.FichierEcr));
   FichierIni.WriteString( Action, 'MAIL', ChargeComsX.EMail );
   FichierIni.WriteString( Action, 'TYPEECR', ChargeComsX.TypeEcrRecup);
   FichierIni.WriteString( Action, 'ECRINTEGE', 'N');

   // AC 09/03/07 SansEchec � FALSE tout le temps sinon blocage de l'import si les sections analytiques n'existes pas
   FichierIni.WriteString( Action, 'SANSECHEC', 'FALSE' );

   FichierIni.free;

   // Fin FICHIER INI
   PwdTraitmtlot := V_PGI.Password;
   UserTraitmtlot := V_PGI.UserLogin;

   // ... car le mot de passe du jour ne marchera plus � minuit...
   if V_PGI.Password=CryptageSt(DayPass(Date)) then
      begin
      Q := OpenSQL('select US_ABREGE, US_PASSWORD from UTILISAT where US_SUPERVISEUR="X"', True);
      if not Q.Eof then
         begin
         UserTraitmtlot := Q.FindField('US_ABREGE').AsString;
         PwdTraitmtlot := Q.FindField('US_PASSWORD').AsString;
         end;
      Ferme(Q);
      end ;

   //if BaseCompta <> '' then Societe := BaseCompta;
   {$IFDEF EAGLCLIENT}
   Command := PathComSx + 'eComSx.exe /SERVER="'+ AppServer.HostName +'"';
   {$ELSE}
   Command := PathComSx + 'ComSx.exe';
   {$ENDIF EAGLCLIENT}
   Command := Command + ' /USER="' + UserTraitmtlot + '"'
                      + ' /PASSWORD='+ PwdTraitmtlot
                      + ' /DATE='+ DateToStr(V_PGI.DateEntree)
                      + ' /DOSSIER=' + ChargeComSx.Societe
                      + ' /INI=' + PathFile + 'ComSx.ini;' + ChargeComsx.TypeEcriture+ ';Minimized' ;

   Result := LanceTraitement( Command );

   if FileExists(ChargeComsx.FichierEcr) then
    	begin
      MAJBlocNote (BlocNotes, ChargeComSx.Societe, 58) ;
      MAJBlocNote (BlocNotes, 'PGIComSxAPI.dll ComSx.inf', 94);
      Result := False;
      end;

end;

function HGetComputerName: hstring;
var S: array[0..255] of char;
    i: {$IFNDEF VER110}LongWord{$ELSE}Integer{$ENDIF};
begin
    i := sizeof(s);
    GetComputerName(@s, i);
    Result := StrPas(s);
end;

function NomDuFichierExport( NomFichier, Natures: hstring; var DateFile: hstring ): hstring;
var Extract: integer;
    DateSyst: TDateTime;
    Annee, Mois, Jour, Hre, Min, Sec, mSec: Word;
    ComplementNom: hstring;

  function TraiteDecode( Num : integer ): hstring;
  begin
    if Num < 10 then
      Result := '0' + IntToStr( Num )
    else
      Result := IntToStr( Num );
  end;

begin

  DateSyst := Now;
  DecodeDate( DateSyst, Annee, Mois, Jour );
  DecodeTime( DateSyst, Hre, Min, Sec, mSec );
  DateFile := IntToStr( Annee ) + TraiteDecode( Mois ) + TraiteDecode( Jour ) + TraiteDecode( Hre ) + TraiteDecode( Min );

  while pos( ';', Natures ) > 0 do
     begin
     Extract := pos( ';', Natures );
     Natures := copy( Natures, 1, Extract - 1 ) + '-' + copy( Natures, Extract + 1, length( Natures ) );
     end;

  if NomFichier <> '' then
     ComplementNom := NomFichier
  else
     ComplementNom := Natures ;

  //SO_TYPECOMSX
  if ( GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S1' ) or
     ( GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S5' ) then
     Result := ComplementNom + '-' + DateFile + '.TRA'
  else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SIS' then
     Result := ComplementNom + '-' + DateFile + '.TRF'
  else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SAG' then
     Result := ComplementNom + '-' + DateFile + '.PNM';

end;


{***********A.G.L.***********************************************
Auteur  ...... : A. Cathelineau
Cr�� le ...... : 25/04/2006
Modifi� le ... : 28/04/2006
Description .. : Mise � jour du bloc note pour chaque tache avec son �tat
Suite ........ : Debut, Fin et son statut Ok, Err
Mots clefs ... :
*****************************************************************}
procedure MAJBlocNoteTache ( Debut,TacheOk : Boolean; Tache : TTypeTacheInterCpta; Var BlocNotes : TStringList) ;
Var
  sErr : hstring ;
  NumEtape : Integer ;
begin

  NumEtape := 0 ;

  case Tache of
    icChargement :
        NumEtape := 1 ;
    icAffecteCompte :
        NumEtape := 2 ;
    icGenereEcr :
        NumEtape := 3 ;
    icExport :
        NumEtape := 4 ;
    icImport :
        NumEtape := 6 ;
    icNull :
        NumEtape := 5 ;
    icPreControl :
        NumEtape := 7 ;
  end;

  if Debut then
     begin
     if NumEtape > 1 then BlocNotes.Add('');
     BlocNotes.Add( LibTache[NumEtape] )
     end
  else
     begin
     if TacheOk then
        begin
        if NumEtape <> 5 then
           BlocNotes.Add( Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[NumEtape] ] ) )
        else
           BlocNotes.Add( TraduireMemoire( 'Le ' )+LibTache[NumEtape]+TraduireMemoire( ' est termin�' ) ) ;
        end
     else
        begin
        sErr := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[NumEtape] ] )  ;
        sErr := sErr + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        BlocNotes.Add( sErr ) ;
        end ;
     end ;

end ;

{***********A.G.L.***********************************************
Auteur  ...... : A. Cathelineau
Cr�� le ...... : 11/05/2006
Modifi� le ... :   /  /
Description .. : Mise � jour du bloc note pour les erreurs
Mots clefs ... :
*****************************************************************}
procedure MAJBlocNote (Var BlocNotes : TStringList; sMessage : hstring; NumErreur : integer = 0)  ;
Var
  sText : hstring ;
begin

  BlocNotes.Add( '' );

  if NumErreur <> 0 then
  begin
    case NumErreur of
      51 : begin
             BlocNotes.Add( TraduireMemoire( TexteMessage [ 51 ] ) );
             BlocNotes.Add( TraduireMemoire( TexteMessage [ 72 ] ) );
           end;
      53 : begin
             BlocNotes.Add( TraduireMemoire( TexteMessage [ 53 ] ) );
             BlocNotes.Add( TraduireMemoire( TexteMessage [ 73 ] ) );
           end;
    else
      BlocNotes.Add( TraduireMemoire( TexteMessage [ NumErreur ] ) );
    end;
  end;

  sText := '  '+ sMessage + #13#10 ;

  if sMessage <> '' then BlocNotes.Add( sText );

end ;

{***********A.G.L.***********************************************
Auteur  ...... : A. Cathelineau
Cr�� le ...... : 15/05/2006
Modifi� le ... :   /  /
Description .. : retourne le message d'erreur suivant le traitement effectu�
Suite ........ : et le resultat
Mots clefs ... :
*****************************************************************}
function SetLastError( Num: integer; LibEcran : hstring = '' ) : hstring ;
Var
  sMessage : hstring ;
begin
  case num of
    11 :
      begin
        // Tache chargement ok
        sMessage := Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[ 1 ] ]) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    12 :
      begin
        // Tache chargement erreur
        sMessage := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[ 1 ] ] )  ;
        sMessage := sMessage + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    21 :
      begin
        // Tache affectation ok
        sMessage := Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[ 2 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    22 :
      begin
        // Tache affectation erreur
        sMessage := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[ 2 ] ] )  ;
        sMessage := sMessage + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    31 :
      begin
        // Tache g�n�ration ok
        sMessage := Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[ 3 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    32 :
      begin
        // Tache g�n�ration erreur
        sMessage := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[ 3 ] ] )  ;
        sMessage := sMessage + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    41 :
      begin
        // Tache exportation ok
        sMessage := Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[ 4 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    42 :
      begin
        // Tache exportation erreur
        sMessage := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[ 4 ] ] )  ;
        sMessage := sMessage + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    51 :
      begin
        // Tache importation ok
        sMessage := Format_( TraduireMemoire( TexteMessage[ 27 ] ), [ LibTache[ 6 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    52 :
      begin
        // Tache importation erreur
        sMessage := Format_( TraduireMemoire( TexteMessage[ 28 ] ), [ LibTache[ 6 ] ] )  ;
        sMessage := sMessage + ' ' + TraduireMemoire( TexteMessage[ 29 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    100 :
      begin
        // Contr�le de coh�rence ok
        sMessage := LibTache[ 7 ] + #13#10  ;
        sMessage := TraduireMemoire( TexteMessage[ 63 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    101 :
      begin
        // Contr�le de coh�rence non ok
        sMessage := LibTache[ 7 ] + #13#10  ;
        sMessage := TraduireMemoire( TexteMessage[ 64 ] );
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    0 :
      begin
        // Transfert comptable termin�
        sMessage := TraduireMemoire( TexteMessage[ 21 ] );
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
  end ;
  Result := sMessage ;
end;

function GetPathFileTransfert : string;
begin

  Result := GetParamSocSecur( 'SO_MBOCHEMINCOMPTA', '' );

  if copy(Result, length( Result ), 1 ) <> '\' then Result := Result + '\';

end;

function GetPathFileComSx : string;
Var V : String;
begin

  {$IFDEF EAGLSERVER}
  if ExisteSql( 'SELECT 1 FROM PARAMSOC WHERE SOC_NOM="SO_MBOCHEMINPSCOMSX"' ) then // Test pour mise en place avant cr�ation du paramsoc dans la socref officielle
    Result := GetParamSocSecur('SO_MBOCHEMINPSCOMSX', '' );

  if Result = '' then
     Begin
     V := GetFromRegistry(HKey_Local_Machine, 'Software\CEGID_BTP\PgiService', 'Scripts', V, True);
     Result := V;
     end;
  {$ELSE EAGLSERVER}
  Result := '';
  {$ENDIF EAGLSERVER}

  // R�pertoire de la ComSx dans "param�tre de d�bogage"
  if Result = '' then Result := IncludeTrailingBackslash(GetParamSocSecur('SO_BTCHEMINCOMSX', ''));
  if result = '' then Result := IncludeTrailingBackslash(TcbpPath.GetCegidDistriApp);  
  //
  if Result = '' then Result := ExtractFileDir(Application.ExeName) + '\';

  //
  //Result := IncludeTrailingPathDelimiter( Result );

end;

function ControleParametrageExport ( RepertoireFichier, RepertoireComSx : hstring) : integer ;
begin
  Result := 0 ;
  if ( RepertoireFichier = '' ) then
    Result := 53
  else if not DirectoryExists( RepertoireFichier ) then
    Result := 37
  {$IFDEF EAGLCLIENT}
  else if not FileExists( RepertoireComSx + 'eComSx.exe' ) then
    Result := 71 ;
  {$ELSE EAGLCLIENT} // Version 2 tiers et Process Serveur
  else if not FileExists( RepertoireComSx + 'ComSx.exe' ) then
    Result := 36 ;
  {$ENDIF EAGLCLIENT}
end ;

procedure MajRapport( const sEtablissmt, DateDeb, DateFin, NatureD, sEcritures, FichierEcr: hstring;
                      ComptaExterne, bEcritures: Boolean; BlocNotes : TStringList = nil );
var
  Cpt, QteOptions : integer;
  TousEts, TtesNatPces, NatPce, Ets, RgpPce : hstring;
  TempNotes : TStringList ;

  procedure AddTexte( Texte : hstring );
  begin
    QteOptions := QteOptions + 1;
    TempNotes.Add( Texte );
  end;

begin
  if( BlocNotes = nil ) then
  //if( RapportLst = nil ) then
    Exit;
  TempNotes := TStringList.Create;
  TempNotes.Add( '***** ' + TraduireMemoire( 'PARAMETRES ' ) + '**********************************************************' );
  Cpt := 0;
  TousEts := sEtablissmt;
  while( TousEts <> '' ) do
  begin
    Cpt := Cpt + 1;
    Ets := ReadTokenSt( TousEts );
    if Cpt = 1 then
      AddTexte( TraduireMemoire( 'Etablisement(s) : ' ) + Ets + ' - ' + RechDom( 'TTETABLISSEMENT', Ets, False ) )
    else
      AddTexte( '                : ' + Ets + ' - ' + RechDom( 'TTETABLISSEMENT', Ets, False ) );
  end;
  TempNotes.Add( Format_( TraduireMemoire('P�riode         : du %s au %s'), [DateDeb, DateFin] ) );
  Cpt := 0;
  TtesNatPces := NatureD;
  while( TtesNatPces <> '' ) do
  begin
    Cpt := Cpt + 1;
    NatPce := ReadTokenSt( TtesNatPces );
    if GetInfoParPiece( NatPce, 'GPP_REGROUPCPTA' ) = 'AUC' then
      RgpPce := TraduireMemoire( ' (aucun regroupement)' )
    else if GetInfoParPiece( NatPce, 'GPP_REGROUPCPTA' ) = 'JOU' then
      RgpPce := TraduireMemoire( ' (regroupement journalier)' )
    else if GetInfoParPiece( NatPce, 'GPP_REGROUPCPTA' ) = 'MOI' then
      RgpPce := TraduireMemoire( ' (regroupement mensuel' )
    else if GetInfoParPiece( NatPce, 'GPP_REGROUPCPTA' ) = 'SEM' then
      RgpPce := TraduireMemoire( ' (regroupement hebdomadaire)' );
    if Cpt = 1 then
      AddTexte( TraduireMemoire( 'Piece(s)        : ' ) + GetInfoParPiece( NatPce, 'GPP_LIBELLE' ) + RgpPce )
    else
      AddTexte( '                  ' + GetInfoParPiece( NatPce, 'GPP_LIBELLE' ) + RgpPce );
  end;
  if ComptaExterne then
  begin
    if bEcritures then
      AddTexte( sEcritures );
    AddTexte( TraduireMemoire( 'Export des �critures en fin de traitement dans :' ) );
    AddTexte( ' ' + FichierEcr );
  end;
  TempNotes.AddStrings ( BlocNotes );
  BlocNotes.Clear;
  BlocNotes.AddStrings ( TempNotes );
end;

end.
