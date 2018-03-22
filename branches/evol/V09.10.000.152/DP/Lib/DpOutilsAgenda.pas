{***********UNITE*************************************************
Auteur  ...... : BM
Cr�� le ...... : 10/12/2002
Modifi� le ... : 28/02/2003 : Compatibilit� CWAS
Description .. : Unit� commune
Mots clefs ... : DP
*****************************************************************}
unit DpOutilsAgenda;


interface

uses
{$IFDEF EAGLCLIENT}
{$ELSE}
  {$IFNDEF DBXPRESS}dbtables,{$ELSE}uDbxDataSet,{$ENDIF}
{$ENDIF}
    utob, forms;


const
     // une seconde en tdatetime
     dSecond = 1/86400;

     // Autorisation de modification: aucune, seulement l'�tat "r�alis�" ou toute modification autoris�e
     aaNothing  = 0;
     aaDoneOnly = 1;
     aaAll      = 2;

     // Pour lien Outlook
     olFolderCalendar  = 9;
     olAppointment     = 26;
     olAppointmentItem = 1;

     olRecursDaily     = 0;
     olRecursWeekly    = 1;
     olRecursMonthly   = 2;
     olRecursMonthNth  = 3;
     olRecursYearly    = 5;
     olRecursYearNth   = 6;

     olText            = 1;
     olDateTime        = 2;

     olNormal          = 0;
     olPersonal        = 1;
     olPrivate         = 2;
     olConfidential    = 3;

     olFree            = 0;
     olTentative       = 1;
     olBusy            = 2;
     olOutOfOffice     = 3;

     // Type de synchronisation
     ostFull            = 0;
     ostFromOutlook     = 1;
     ostFromCegid       = 2;
     ostNone            = 3;
     ostDesynchro       = 4;
     ostImport          = 5;
     //ostAlready         = -1;
     ostDeleteInOutlook = -2;
     ostDeleteInCegid   = -3;

     // R�solution des conflits
     ocrNone       = 0;
     ocrCegid      = 1;
     ocrOutlook    = 2;
     ocrFull       = 3;
     ocrMostRecent = 4;

     // R�solution de suppression
     odrNone       = 0;
     odrKeep       = 1;
     odrDelete     = 2;
     odrDesync     = 3;


type
     // $$$ JP 25/09/06 - fr�quence de l'activit� (YYAGENDA_FIC)
     ActFrequence = (ACF_NONE, ACF_DAILY, ACF_WEEKLY, ACF_MONTHLY, ACF_YEARLY);

     // $$$ JP 09/10/09 - port�e de la modification (s�rie, l'occurence ou aucune)
     ActPortee = (ACP_NONE, ACP_OCCURENCE, ACP_SERIE, ACP_EXCEPTION);

     // $$$ JP 29/05/07: type d'exception
     ActExcType = (AET_UNKNOWN, AET_NORMAL, AET_DELETED);
                                           

     TOutlookSync = class (TObject)
     private
            m_iTypeSync        :integer;
            m_iConflictSolver  :integer; // Gestion des doubles modification
            m_iSupprSolver     :integer; // Gestion des suppressions
            m_bSupprFull       :boolean; // Gestion des suppressions dans les deux sens? (pour les synchro partielle de type copie)
            m_strGuidBase      :string;
            m_strGuidOutlook   :string;

            // Conteneurs des activit�s (TOB) et des rendez-vous (variant IDispatch d'outlook: collections de appointmentitem)
            m_ActItems         :TOB;
            m_ApptItems        :variant;
            m_iNbSync          :integer;

            function  WeekDaysToWeekMask (strDaysOfWeek:string):integer;
            function  WeekMaskToWeekDays (iDaysOfWeek:integer):string;
            function  IsRecEqual         (ActItem:TOB;      ApptItem:variant):boolean;
            procedure ActApptLink        (ActItem:TOB;      ApptItem:variant);
            function  ActToAppt          (ActItem:TOB;      ApptItem:variant):variant;
            function  ApptToAct          (ApptItem:variant; ActItem:TOB):TOB;

            procedure CreateOutlookEvtCode;

            procedure SyncAppt;
            procedure CopyAndSaveAct;
            procedure DesyncAppt;
            procedure DesyncAct;

     public
            constructor Create   (iTypeSync:integer; iConflictSolver:integer; iSupprSolver:integer; bSupprFull:boolean);

            function    DoSync   ():integer; // renvoie le nb de rdv synchronis�s, ou -1 si erreur
            function    DoImport ():integer; // $$$ JP 07/11/06: import simple depuis outlook
     end;


function  AgendaLanceFiche         (strLequel:string; strArgument:string):string;
procedure AgendaNewActivite        (strUser:string; strDossier:string; bExterne:boolean; bAbsence:boolean);
function  AgendaSendToGi           (strGuidsEvt:string; bUpdateFait:boolean):integer; // $$$ JP - envoi activit� agenda vers e-activit� gi
procedure AgendaMajDroits_V7; // $$$ JP 16/08/06
procedure AgendaLoadDroits         (TOBDroits:TOB; strGroupes:string='');
function  AgendaMajAutorise        (bExterne, bAbsence:boolean; strDroit:string):boolean;
function  AgendaMajType            (Item:TOB):integer;
function  AgendaGetUsers           (strUser:string; TOBDroits:TOB; bExterne:boolean; bAbsence:boolean; strForceUser:string=''; bWithQuote:boolean=TRUE):string;
function  AgendaGetUsersMaxRights  (strUser:string; TOBDroits:TOB):string;
function  AgendaGetUsersMinRights  (strUser:string; TOBDroits:TOB):string;

// $$$ JP 31/08/07: SQL de s�lection des activit�s de l'agenda d�port� ici (avant dans galAgenda)
function AgendaSQLMonoUser         (strUser:string;                         dtMin:TDateTime; dtMax:TDateTime):string;
function AgendaSQLMultiUsers       (strUsers:string; strGroupesConf:string; dtMin:TDateTime; dtMax:TDateTime):string;
function AgendaSQLMonoUserYPL      (strUser:string;                         dtMin:TDateTime; dtMax:TDateTime):string;
function AgendaSQLMultiUsersYPL    (strUsers:string; strGroupesConf:string; dtMin:TDateTime; dtMax:TDateTime):string;

// $$$ JP 09/10/06: cr�ation d'une exception (enreg de JUEVENEMENT li� � JURECEXCEPTION)
// $$$ JP 29/05/07: remise en ligne de la cr�ation d'une exception � partir d'une s�rie
// $$$ JP 20/08/07: bComplete � FALSE => pas de cr�ation d'enreg dans JUEVENEMENT, seulement dans JURECEXCEPTION
function  AgendaCreateException  (Item:TOB; iExceptType:ActExcType=AET_NORMAL; bComplete:boolean=TRUE):string;
procedure AgendaDeleteExceptions (strGuidEvt:string); // strGuidEvt = guid activit� d'origine pour laquelle il faut supprimer TOUTES les exceptions

// $$$ JP 05/10/06: calcul des dates des occurences
{$IFNDEF VER150}
function DayOf        (const AValue:TDateTime):Word;
function DaysInAMonth (const AYear, AMonth:Word):Word;
function DaysInMonth  (const AValue:TDateTime):Word;
function MonthOf      (const AValue:TDateTime):Word;
{$ENDIF}

function AgendaGetDateOfDay      (dtStart:TDateTime; iDayOfMonth:integer):TDateTime;
function AgendaGetDateOfInstance (dtStart:TDateTime; strValidWeekDays:string; iInstance:integer):TDateTime;
function AgendaGetInstanceOfDate (dtStart:TDateTime):integer;
function AgendaGetOccurence      (iRecType:ActFrequence; var dtStart:TDateTime; var dtOccurence:TDateTime; var iOccurence:integer; iInterval:integer = 1; iInstance:integer = 0; strDaysOfWeek:string = ''; {iDayOfWeek:integer = 0;} iDayOfMonth:integer = 0; iMonthOfYear:integer = 0):boolean;

// Gestion occurence/exception/s�rie
function AgendaSelectPortee (strTypeOcc:string; strTitle:string; bExceptEnabled:boolean=FALSE):ActPortee;


/////////// IMPLEMENTATION ////////////

implementation

uses
    sysutils, dpjuroutils, hctrls, paramsoc, hent1, hmsgbox, calcolegenericaff,
    entdp, comobj, dpOutils, hStatus, controls, classes,
    galAgendaChoixRec, // $$$ JP 29/05/07
{$IFDEF VER150}
    DateUtils, Variants,
{$ENDIF}

{$IFDEF EAGLCLIENT}
     MaineAGL;
{$ELSE}
     Fe_main;
{$ENDIF}



function AgendaLanceFiche (strLequel:string; strArgument:string):string;
begin
     Result := AGLLanceFiche ('YY', 'YYAGENDA_FIC', '', strLequel, strArgument);
end;

procedure AgendaNewActivite (strUser:string; strDossier:string; bExterne:boolean; bAbsence:boolean);
var
   strUsers           :string;
   strArg             :string;
   TOBDroits          :TOB;
begin
     if VH_DP.SeriaMessagerie = FALSE then
        exit;

     // Chargement des droits agenda
     TOBDroits := TOB.Create ('les droits', nil, -1);
     try
        AgendaLoadDroits (TOBDroits);
        strUsers := AgendaGetUsers (strUser, TOBDroits, bExterne, bAbsence);
     finally
           TOBDroits.Free;
     end;
     if strUsers = '' then
        exit;

     // Cr�ation d'une nouvelle activit�
     strArg := 'ACTION=CREATION';

     // Utilisateur par d�faut: celui connect�
     strArg := strArg + ';JEV_USER1=' + strUser;

     // Utilisateurs autoris�s en modification
     strArg := strArg + ';USERS=' + strUsers;

     // Dossier par d�faut: celui en s�lection par clic droit
     strArg := strArg + ';JEV_NODOSSIER=' + strDossier;

     // Type d'activit�: absence, rdv interne, rdv externe
     if bExterne = TRUE then
          strArg := strArg + ';JEV_EXTERNE=X;JEV_ABSENCE=-'
     else if bAbsence = TRUE then
          strArg := strArg + ';JEV_EXTERNE=-;JEV_ABSENCE=X'
     else
          strArg := strArg + ';JEV_EXTERNE=-;JEV_ABSENCE=-';

     // Fiche agenda
     AgendaLanceFiche ('', strArg);
end;


{***********A.G.L.***********************************************
Auteur  ...... : J Pomat
Cr�� le ...... : 05/05/2004
Modifi� le ... :   /  /
Description .. : transfert agenda vers eactivite de la GI
Mots clefs ... :
*****************************************************************}
function AgendaSendOneToGi (TOBUneActivite:TOB):boolean; // $$$ JP 12/04/07 obsol�te apparement //; var iCompteur: Integer):boolean;
var
   TOBEAct                             :TOB;
   TOBRess                             :TOB;
   TOBAff                              :TOB;
   TOBArt                              :TOB;
   iDateDeb, iDateFin                  :TDateTime;
   dQteHeure                           :double;
   sAff0, sAff1, sAff2, sAff3, sAff4   :string;
   vNote                               :variant;
   //Q                                   :TQuery;
   TOBNumLig                           :TOB;
   iNumLigne                           :integer;
begin
     // Par d�faut, non transf�r�
     Result := FALSE;

     // Tables li�es: ressource, affaire et article
     TOBEAct   := nil;
     TOBRess   := TOB.Create ('la ressource', nil, -1);
     TOBAff    := TOB.Create ('la mission', nil, -1);
     TOBArt    := TOB.Create ('la prestation', nil, -1);
     try
        // Faire recherche de la ressource, du tiers, du code prestation...
        TOBRess.LoadDetailFromSQL ('SELECT ARS_RESSOURCE,ARS_TYPERESSOURCE FROM RESSOURCE WHERE ARS_UTILASSOCIE="' + TOBUneActivite.GetString ('JEV_USER1') + '"');
        if TOBRess.Detail.Count = 0 then
           exit;
        TOBAff.LoadDetailFromSQL ('SELECT AFF_AFFAIRE,AFF_TIERS FROM AFFAIRE WHERE AFF_AFFAIRE="' + TOBUneActivite.GetString ('JEV_AFFAIRE') + '"');
        if TOBAff.Detail.Count = 0 then
           exit;
        TOBArt.LoadDetailFromSQL ('SELECT GA_ARTICLE,GA_CODEARTICLE,GA_ACTIVITEREPRISE FROM ARTICLE JOIN JUTYPEEVT ON GA_CODEARTICLE=JTE_CODEARTICLE AND JTE_CODEEVT="' + TOBUneActivite.GetValue ('JEV_CODEEVT') + '" WHERE GA_TYPEARTICLE="PRE"');
        if TOBArt.Detail.Count = 0 then
           exit;

        // D�coupage du code affaire
        CodeAffaireDecoupe (TOBAff.Detail [0].GetValue ('AFF_AFFAIRE'), sAff0, sAff1, sAff2, sAff3, sAff4, taCreat, FALSE);

        // Dates de l'activit�
        iDateDeb := TOBUneActivite.GetValue ('JEV_DATE');
        iDateFin := TOBUneActivite.GetValue ('JEV_DATEFIN');

        // $$$ JP 29/03/2005 - Transfert des seules activit�s sur une m�me journ�es (en attendant la gestion des r�p�titions, et du calendrier GI dans l'agenda)
        if Trunc (iDateDeb) <> Trunc (iDateFin) then
           exit;

        // $$$ JP 03/11/04 - on calcul au 1/4 d'heure pr�s, au plus proche (00-07 min' => 0; 08-22 min' => 1/4 d'heure; 23-37 min' => 2/4 d'heure)
        dQteHeure := Round (96 * (Frac (iDateFin) - Frac (iDateDeb))) / 4;

        // Premi�re initialisation de la cl� e-Activit�, pour une s�rie d'enregistrements
        iNumLigne := -1;
        TOBNumLig := TOB.Create ('le num ligne', nil, -1);
        try
           TOBNumLig.LoadDetailFromSQL ('SELECT MAX(EAC_NUMLIGNE) AS MAXNUMLIG FROM EACTIVITE WHERE EAC_UTILISATEUR="' + V_PGI.User + '" HAVING COUNT(EAC_NUMLIGNE)>0');
           if TOBNumLig.Detail.Count > 0 then
               iNumLigne := TOBNumLig.Detail [0].GetValue ('MAXNUMLIG')
           else
               iNumLigne := 0;
        finally
               FreeAndNil (TOBNumLig);
        end;
        {if iCompteur=-1 then
        begin
          Q := OpenSQL ('SELECT MAX(EAC_NUMLIGNE) FROM EACTIVITE WHERE EAC_UTILISATEUR="'+V_PGI.User+'"', True);
          if (Q<>nil) and (Not Q.EOF) and (not VarIsNull(Q.Fields[0].Value)) then
            iNumLigne := Q.Fields [0]. iCompteur := Q.Fields[0].Value
          else
            iCompteur := 0;
          Ferme(Q);
          end;}

        // Incr�mentation de la cl�
        Inc (iNumLigne);

        // Autant de ligne que de nombre de jour de l'activit� DP (pas clair, � revoir quand activit� r�p�table actif)
        // Insertion nouvelle ligne activit� GI - Cl� EACTIVITE: EAC_TYPEACTIVITE,EAC_AFFAIRE,EAC_RESSOURCE, EAC_DATEACTIVITE, EAC_TYPEARTICLE,EAC_NUMLIGNE
        TOBEAct := TOB.Create ('EACTIVITE', nil, -1);

        // MD 23/11/06 - Nouvelle cl� de EACTIVITE en v7 + remplacement AddChampSupValeur par PutValue
        TOBEAct.PutValue ('EAC_UTILISATEUR', V_PGI.User);
        TOBEAct.PutValue ('EAC_NUMLIGNE', iNumLigne);

        TOBEAct.PutValue ('EAC_DATEACTIVITE', integer (Trunc (iDateDeb)));
        TOBEAct.PutValue ('EAC_TYPEACTIVITE', 'REA');
        TOBEAct.PutValue ('EAC_ACTORIGINE', 'AGE');
        TOBEAct.PutValue ('EAC_AFFAIRE', TOBAff.Detail [0].GetValue ('AFF_AFFAIRE'));
        TOBEAct.PutValue ('EAC_AFFAIRE0', sAff0);
        TOBEAct.PutValue ('EAC_AFFAIRE1', sAff1);
        TOBEAct.PutValue ('EAC_AFFAIRE2', sAff2);
        TOBEAct.PutValue ('EAC_AFFAIRE3', sAff3);
        TOBEAct.PutValue ('EAC_AVENANT', sAff4);
        TOBEAct.PutValue ('EAC_TIERS', TOBAff.Detail [0].GetValue ('AFF_TIERS'));
        TOBEAct.PutValue ('EAC_TYPERESSOURCE', TOBRess.Detail [0].GetValue ('ARS_TYPERESSOURCE'));
        TOBEAct.PutValue ('EAC_RESSOURCE', TOBRess.Detail [0].GetValue ('ARS_RESSOURCE'));
        TOBEAct.PutValue ('EAC_ARTICLE', TOBArt.Detail [0].GetValue ('GA_ARTICLE'));
        TOBEAct.PutValue ('EAC_CODEARTICLE', TOBArt.Detail [0].GetValue ('GA_CODEARTICLE'));
        TOBEAct.PutValue ('EAC_TYPEARTICLE', 'PRE');
        TOBEact.PutValue ('EAC_ACTIVITEREPRIS', TOBUneActivite.GetValue ('GA_ACTIVITEREPRISE'));
        TOBEAct.PutValue ('EAC_LIBELLE', TOBUneActivite.GetValue ('JEV_EVTLIBELLE'));
        TOBEAct.PutValue ('EAC_UNITE', 'H');

        // $$$ JP 03/11/04
        TOBEAct.PutValue ('EAC_QTE', dQteHeure);
        // MD 23/11/06 - Cl� calcul�e plus haut !
        // TOBEAct.PutValue ('EAC_NUMLIGNE', CalculNumCle ('EAC_NUMLIGNE', 'EACTIVITE', 'EAC_TYPEACTIVITE="REA" AND EAC_AFFAIRE="' + TOBAff.Detail [0].GetValue ('AFF_AFFAIRE') + '" AND EAC_RESSOURCE="' + TOBRess.Detail [0].GetValue ('ARS_RESSOURCE') + '" AND EAC_DATEACTIVITE="' + USDATETIME (Trunc (iDateDeb)) + '" AND EAC_TYPEARTICLE="PRE"'));

        // Insertion de la note de l'�v�nement dans l'eactivit� (si existe)
        vNote := TOBUneActivite.GetValue ('JEV_NOTEEVT');
        if (VarIsNull (vNote) = FALSE) and (string (vNote) <> '') then
           TOBEAct.PutValue ('EAC_DESCRIPTIF', vNote);

        // Mise � jour dans la base
        TOBEAct.InsertDB (nil);
        TOBEAct.Free;
        TOBEAct := nil;

        // Ok, les lignes ont �t� ins�r�es, jour par jour
        Result := TRUE;
     finally
            TOBArt.Free;
            TOBAff.Free;
            TOBRess.Free;
            TOBEAct.Free;
     end;
end;

// $$$ JP 15/03/06 - il faut que les guids soient bien avec les ", exemple: "guid1","guid2","guid3"
function AgendaSendToGi (strGuidsEvt:string; bUpdateFait:boolean):integer;
var
   TOBActivite   :TOB;
   i             :integer; // $$$ JP 12/04/07 , iCompteur  :integer;
   strGuid       :string;
begin
     // Par d�faut, le nb d'�l�ment transf�rer est nul
     Result := 0;

     // Doit y avoir au moins une activit� agenda � transf�rer, et que le transfert automatique vers la GI soit autoris�
     if strGuidsEvt = '' then
        exit;
     if GetParamSocSecur ('SO_AGEGENEREGI', True) = FALSE then
        exit;

     // Dans une transaction, car on doit transf�rer TOUT ou RIEN (si probl�me)
     TOBActivite := TOB.Create ('les activites', nil, -1);
     BeginTrans;
     try
     try
        // Pour calcul automatique de la cl� e-Activit�
        // $$$ JP 12/04/07 obsol�te apparement iCompteur := -1;

        // Transfert en Gi des activit� agenda sp�cifi�es
        // $$$ JP 29/03/07: on ne prends pas en compte les activit� d�j� transf�r�es en GI
        TOBActivite.LoadDetailFromSQL ('SELECT * FROM JUEVENEMENT WHERE JEV_GENEREGI<>"X" AND JEV_AFFAIRE<>"" AND JEV_GUIDEVT IN (' + strGuidsEvt + ')');
        for i := 0 to TOBActivite.Detail.Count-1 do
        begin
             // $$$ JP 30/03/07: il faut ne prendre en m�j "GENEREGI" que ceux qui ont �t� bien transf�r� en GI
             if AgendaSendOneToGi (TOBActivite.Detail [i]) = TRUE then // $$$ JP 12/04/07 , iCompteur) = TRUE then
                 Result := Result + 1
             else
                 TOBActivite.Detail [i].PutValue ('JEV_GUIDEVT', '');
        end;

        // Passage � l'�tat fait de ces activit� agenda
        if bUpdateFait = TRUE then
        begin
             // $$$ JP 30/03/07: mise � jour du FAIT s�par�ment du GENEREGI, pour ne mettre � jour GENEREGI que pour ceux qui ont �t� r�ellement transf�r� en GI
             ExecuteSQL ('UPDATE JUEVENEMENT SET JEV_FAIT="X",JEV_DATEMODIF="' + UsDateTime (Now) + '",JEV_UTILISATEUR="' + V_PGI.User + '" WHERE JEV_FAIT<>"X" AND JEV_GUIDEVT IN (' + strGuidsEvt + ')');

             // $$$ JP 30/03/07: il faut ne prendre en m�j "GENEREGI" que ceux qui ont �t� bien transf�r� en GI
             strGuidsEvt := '';
             for i := 0 to TOBActivite.Detail.Count-1 do
             begin
                  strGuid := Trim (TOBActivite.Detail [i].GetString ('JEV_GUIDEVT'));
                  if strGuid <> '' then
                  begin
                       if strGuidsEvt <> '' then
                          strGuidsEvt := strGuidsEvt + '","';
                       strGuidsEvt := strGuidsEvt + strGuid;
                  end;
             end;
             if strGuidsEvt <> '' then
                ExecuteSQL ('UPDATE JUEVENEMENT SET JEV_GENEREGI="X",JEV_DATEMODIF="' + UsDateTime (Now) + '",JEV_UTILISATEUR="' + V_PGI.User + '" WHERE JEV_GENEREGI<>"X" AND JEV_GUIDEVT IN ("' + strGuidsEvt + '")');
        end;

        // Valider les mises � jour dans la base de donn�e
        CommitTrans;
        if Result > 0 then
           PgiInfo (IntToStr (Result) + ' activit�(s) sur ' + IntToStr (TOBActivite.Detail.Count) + ' ont �t� g�n�r�es dans l''e-activit�');
     except
           Result := -1;
           PgiInfo ('Impossible de mettre � jour les activit�s s�lectionn�es');
           RollBack;
     end
     finally
            TOBActivite.Free;
     end;
end;

// $$$ JP 16/08/06: moulinette pour cl� YX_CODE
procedure AgendaMajDroits_V7;
var
   TOBDroits   :TOB;
   TOBUnDroit  :TOB;
   i           :integer;
   strMaster   :string;
   strSlave    :string;
   strKey      :string;
   strPrevKey  :string;
begin
     TOBDroits := TOB.Create ('CHOIXEXT', nil, -1);
     try
        // Chargement de tous les droits agenda existants, sans doublon
        TOBDroits.LoadDetailDBFromSQL ('CHOIXEXT', 'SELECT YX_TYPE,YX_CODE,YX_LIBELLE,YX_ABREGE,YX_LIBRE FROM CHOIXEXT WHERE YX_TYPE="DAU" ORDER BY YX_LIBELLE,YX_ABREGE,YX_LIBRE');

        // Suppression de ces droits
        ExecuteSQL ('DELETE CHOIXEXT WHERE YX_TYPE="DAU"');

        // Mise � jour de la cl�: user1 # user2, en gardant le droit d�j� d�fini, et tant qu'� faire enlever les espaces en trop sur libelle et abreg�
        strPrevKey := '';
        i          := 0;
        while i < TOBDroits.Detail.Count do
        begin
             TOBUnDroit := TOBDroits.Detail [i];
             strMaster  := Trim (TOBUnDroit.GetString ('YX_LIBELLE'));
             strSlave   := Trim (TOBUnDroit.GetString ('YX_ABREGE'));
             strKey     := strMaster + '#' + strSlave;

             // Si doublon de cl� (� cause pb doublon v6.5 et v7.00), on l'ignore: revient � prendre le droit le plus faible, puisque tri� par YX_LIBRE
             if strKey = strPrevKey then
                TOBUnDroit.Free
             else
             begin
                  TOBUnDroit.SetString ('YX_CODE',    strKey);
                  TOBUnDroit.SetString ('YX_LIBELLE', strMaster);
                  TOBUnDroit.SetString ('YX_ABREGE',  strSlave);

                  // Droit suivant
                  strPrevKey := strKey;
                  Inc (i);
             end;
        end;

        // Mise � jour en base
        TOBDroits.SetAllModifie (TRUE);
        TOBDroits.InsertOrUpdateDB;
     finally
            TOBDroits.Free;
     end;
end;

// CHARGEMENT DES DROITS AGENDA DE L'UTILISATEUR CONNECTE
procedure AgendaLoadDroits (TOBDroits:TOB; strGroupes:string);
var
   strRequete   :string;
begin
     // Chargement des droits de l'utilisateur connect� sur les autres utilisateurs (pour les groupes de travail d�finis)
     strRequete := 'SELECT YX_CODE,YX_LIBELLE,YX_ABREGE,US_LIBELLE,YX_LIBRE FROM CHOIXEXT ';
     strRequete := strRequete + 'JOIN UTILISAT ON YX_ABREGE=US_UTILISATEUR ';
     strRequete := strRequete + 'WHERE YX_TYPE="DAU" AND YX_LIBELLE="' + V_PGI.User + '" AND YX_LIBRE<>"0" ';
     if strGroupes <> '' then
        strRequete := strRequete +'AND EXISTS (SELECT 1 FROM USERCONF WHERE YX_ABREGE=UCO_USER AND UCO_GROUPECONF IN (' + strGroupes + ')) ';
     strRequete := strRequete + 'ORDER BY YX_CODE';
     TOBDroits.LoadDetailFromSQL (strRequete);
end;

function AgendaMajAutorise (bExterne, bAbsence:boolean; strDroit:string):boolean;
begin
     Result := (strDroit = '4') OR ((strDroit = '3') AND (bAbsence = FALSE)) OR ((strDroit = '2') AND (bAbsence = TRUE));
end;

function AgendaMajType (Item:TOB):integer;
begin
     if Item.GetValue ('I_ETAT') = 'ACT_DELEXCEPTION' then
          Result := aaNothing
     else if (Item.GetString ('I_PERS') = 'X') and (Item.GetValue ('I_CODE') <> V_PGI.User) then
          Result := aaNothing
     else if AgendaMajAutorise (Item.GetValue ('I_EXTERNE') = 'X', Item.GetValue ('I_ABSENCE') = 'X', string (Item.GetValue ('I_DROIT'))) = FALSE then
          Result := aaNothing
     else if Item.GetValue ('I_FAIT') = 'X' then
          Result := aaDoneOnly
     else
          Result := aaAll;
end;

function AgendaGetUsers (strUser:string; TOBDroits:TOB; bExterne:boolean; bAbsence:boolean; strForceUser:string; bWithQuote:boolean):string;
var
   TOBUnDroit    :TOB;
begin
     // Par d�faut, aucun utilisateur permit pour l'utilisateur sp�cifi�
     Result := '';

     // Enum�ration des utilisateurs permit pour l'utilisateur sp�cifi�
     TOBUnDroit := TOBDroits.FindFirst (['YX_LIBELLE'], [strUser], TRUE);
     while TOBUnDroit <> nil do
     begin
          if (AgendaMajAutorise (bExterne, bAbsence, TOBUnDroit.GetString ('YX_LIBRE')) = TRUE) or (strForceUser = TOBUnDroit.GetString ('YX_ABREGE')) then
             if bWithQUote = TRUE then
                 Result := Result + '"' + TOBUnDroit.GetString ('YX_ABREGE') + '",'
             else
                 Result := Result + TOBUnDroit.GetString ('YX_ABREGE') + ',';

          // Droit suivant
          TOBUnDroit := TOBDroits.FindNext (['YX_LIBELLE'], [strUser], TRUE);
     end;
     if Result <> '' then
        Result := Copy (Result, 1, Length (Result)-1);
end;

function AgendaGetUsersMaxRights (strUser:string; TOBDroits:TOB):string;
var
   TOBUnDroit    :TOB;
begin
     // Par d�faut, aucun utilisateur sur l'agenda duquel l'utilisateur sp�cifi� a tous les droits agenda
     Result := '';

     // Enum�ration des utilisateurs sur l'agenda desquels l'utilisateur sp�cifi� a tous les droits
     TOBUnDroit := TOBDroits.FindFirst (['YX_LIBELLE'], [strUser], TRUE);
     while TOBUnDroit <> nil do
     begin
          if TOBUnDroit.GetString ('YX_LIBRE') = '4' then
             Result := Result + '"' + TOBUnDroit.GetString ('YX_ABREGE') + '",';

          // Droit suivant
          TOBUnDroit := TOBDroits.FindNext (['YX_LIBELLE'], [strUser], TRUE);
     end;
     if Result <> '' then
        Result := Copy (Result, 1, Length (Result)-1);
end;

function AgendaGetUsersMinRights (strUser:string; TOBDroits:TOB):string;
var
   TOBUnDroit    :TOB;
begin
     // Par d�faut, aucun utilisateur sur l'agenda duquel l'utilisateur sp�cifi� a au moins le droit de lecture
     Result := '';

     // Enum�ration des utilisateurs sur l'agenda desquels l'utilisateur sp�cifi� a au moins le droit de lecture
     TOBUnDroit := TOBDroits.FindFirst (['YX_LIBELLE'], [strUser], TRUE);
     while TOBUnDroit <> nil do
     begin
          if TOBUnDroit.GetString ('YX_LIBRE') <> '0' then
             Result := Result + '"' + TOBUnDroit.GetString ('YX_ABREGE') + '",';

          // Droit suivant
          TOBUnDroit := TOBDroits.FindNext (['YX_LIBELLE'], [strUser], TRUE);
     end;
     if Result <> '' then
        Result := Copy (Result, 1, Length (Result)-1);
end;

function AgendaSQLMonoUser (strUser:string; dtMin:TDateTime; dtMax:TDateTime):string;
begin
     Result := 'SELECT JEV_GUIDEVT,JEV_USER1,YX_LIBELLE,YX_ABREGE,YX_LIBRE,JEV_CODEEVT,JEV_DATE,JEV_DATEFIN,';
     Result := Result + 'JEV_EVTLIBELLE,JEV_LIEU,JEV_NODOSSIER,DOS_LIBELLE,JEV_GUIDPER,JEV_AFFAIRE,';
     Result := Result + 'JEV_FAIT,JEV_EXTERNE,JEV_ABSENCE,JEV_PERS,JEV_OCCURENCEEVT,JUEVTRECURRENCE.*,';
     Result := Result + 'JEX_GUIDEVT,JEX_RECURNUM,JEX_EXCEPTNUM,JEX_EXCEPTTYPE,JEX_GUIDEVTEXCEPT ';

     Result := Result + 'FROM JUEVENEMENT ';

     Result := Result + 'LEFT JOIN DOSSIER ON JEV_NODOSSIER=DOS_NODOSSIER ';
     Result := Result + 'LEFT JOIN JUEVTRECURRENCE ON JEV_GUIDEVT=JEC_GUIDEVT AND JEC_RECURNUM=1';
     Result := Result + 'LEFT JOIN JURECEXCEPTION ON ((JEX_GUIDEVT=JEC_GUIDEVT AND JEX_RECURNUM=JEC_RECURNUM) OR JEX_GUIDEVTEXCEPT=JEV_GUIDEVT) ';
     Result := Result + 'RIGHT JOIN CHOIXEXT ON (YX_TYPE="DAU" AND YX_LIBELLE="' + V_PGI.User + '" AND YX_ABREGE=JEV_USER1 AND YX_LIBRE<>"0") ';

     Result := Result + 'WHERE JEV_FAMEVT="ACT" AND JEV_DOMAINEACT<>"JUR" ';
     Result := Result + 'AND JEV_USER1="' + strUser + '" ';

     Result := Result + 'AND (JEV_DATEFIN>="' + USTIME (dtMin) + '" OR JEV_OCCURENCEEVT<>"SIN") ';
     Result := Result + 'AND JEV_DATE<"' + USTIME (dtMax) + '"';
end;

function AgendaSQLMultiUsers (strUsers:string; strGroupesConf:string; dtMin:TDateTime; dtMax:TDateTime):string;
begin
     // On filtre un peu les users et les groupes de conf
     strUsers       := Trim (UpperCase (strUsers));
     strGroupesConf := Trim (UpperCase (strGroupesConf));

     Result := 'SELECT DISTINCT JEV_GUIDEVT,JEV_USER1,YX_LIBRE,JEV_CODEEVT,JEV_DATE,JEV_DATEFIN,';
     Result := Result + 'JEV_EVTLIBELLE,JEV_LIEU,JEV_NODOSSIER,DOS_LIBELLE,JEV_GUIDPER,JEV_AFFAIRE,';
     Result := Result + 'JEV_FAIT,JEV_EXTERNE,JEV_ABSENCE,JEV_PERS,US_LIBELLE,JEV_OCCURENCEEVT,JUEVTRECURRENCE.*,';
     Result := Result + 'JEX_GUIDEVT,JEX_RECURNUM,JEX_EXCEPTNUM,JEX_EXCEPTTYPE,JEX_GUIDEVTEXCEPT ';

     Result := Result + 'FROM JUEVENEMENT ';

     Result := Result + 'LEFT JOIN DOSSIER ON JEV_NODOSSIER=DOS_NODOSSIER ';
     Result := Result + 'LEFT JOIN UTILISAT ON JEV_USER1=US_UTILISATEUR ';
     Result := Result + 'LEFT JOIN JUEVTRECURRENCE ON JEV_GUIDEVT=JEC_GUIDEVT ';
     Result := Result + 'LEFT JOIN JURECEXCEPTION ON ((JEX_GUIDEVT=JEC_GUIDEVT AND JEX_RECURNUM=JEC_RECURNUM) OR JEX_GUIDEVTEXCEPT=JEV_GUIDEVT) ';
     Result := Result + 'RIGHT JOIN CHOIXEXT ON (YX_TYPE="DAU" AND YX_LIBELLE="' + V_PGI.User + '" AND YX_ABREGE=JEV_USER1 AND YX_LIBRE<>"0") ';
     Result := Result + 'LEFT JOIN USERCONF ON JEV_USER1=UCO_USER ';

     Result := Result + 'WHERE JEV_FAMEVT="ACT" AND JEV_DOMAINEACT<>"JUR" ';
     if (strUsers <> '') and (strUsers <> '<<TOUS>>') then
        Result := Result + 'AND JEV_USER1 IN ("' + StringReplace (strUsers, ';', '","', [rfReplaceAll]) + '") ';
     if (strGroupesConf <> '') and (strGroupesConf <> '<<TOUS>>') then
        Result := Result + 'AND UCO_GROUPECONF IN ("' + StringReplace (strGroupesConf, ';', '","', [rfReplaceAll]) + '") ';

     Result := Result + 'AND (JEV_DATEFIN>="' + USTIME (dtMin) + '" OR JEV_OCCURENCEEVT<>"SIN") ';
     Result := Result + 'AND JEV_DATE<"' + USTIME (dtMax) + '"';
end;

function AgendaSQLMonoUserYPL (strUser:string; dtMin:TDateTime; dtMax:TDateTime):string;
begin
     Result := 'SELECT YRS_USER AS JEV_USER1,YX_LIBELLE,YX_ABREGE,YX_LIBRE,YPL_DATEDEBUT AS JEV_DATE,YPL_DATEFIN AS JEV_DATEFIN,';
     Result := Result + 'YPL_LIBELLE AS JEV_EVTLIBELLE,';
     Result := Result + '"" AS JEV_GUIDEVT,"" AS JEV_CODEEVT,"-" AS JEV_EXTERNE,"-" AS JEV_ABSENCE,"" AS JEV_LIEU,"" AS JEV_GUIDPER,';
     Result := Result + '"" AS JEV_NODOSSIER,"" AS DOS_LIBELLE,"" AS JEV_AFFAIRE,"SIN" AS JEV_OCCURRENCEEVT,';
     Result := Result + 'NULL AS JEC_GUIDEVT,NULL AS JEC_RECURRENCETYPE,NULL AS JEC_START,NULL AS JEC_END,NULL AS JEC_RECURNUM,';
     Result := Result + 'NULL AS JEC_INTERVALLE,NULL AS JEC_NBOCCURRENCE,NULL AS JEC_WEEKDAYS,';
     Result := Result + 'NULL AS JEC_WEEKOFMONTH,NULL AS JEC_DAYOFMONTH,NULL AS JEC_MONTHOFYEAR,';
     Result := Result + 'YPL_PRIVE AS JEV_PERS, YPL_PREFIXE FROM YPLANNING ';

     Result := Result + 'LEFT JOIN YRESSOURCE ON YRS_GUID=YPL_GUIDYRS ';
     Result := Result + 'RIGHT JOIN CHOIXEXT ON (YX_TYPE="DAU" AND YX_LIBELLE="' + V_PGI.User + '" AND YX_ABREGE=YRS_USER AND YX_LIBRE<>"0") ';

     Result := Result + 'WHERE YPL_PREFIXE<>"JEV" ';
     Result := Result + 'AND YRS_USER="' + strUser + '"';

     Result := Result + 'AND YPL_DATEFIN>="' + USTIME (dtMin) + '" ';
     Result := Result + 'AND YPL_DATEDEBUT<"' + USTIME (dtMax) + '"';
end;

function AgendaSQLMultiUsersYPL (strUsers:string; strGroupesConf:string; dtMin:TDateTime; dtMax:TDateTime):string;
begin
     // On filtre un peu les users et les groupes de conf
     strUsers       := Trim (UpperCase (strUsers));
     strGroupesConf := Trim (UpperCase (strGroupesConf));

     Result := 'SELECT YRS_USER AS JEV_USER1,YX_LIBELLE,YX_ABREGE,YX_LIBRE,YPL_DATEDEBUT AS JEV_DATE,YPL_DATEFIN AS JEV_DATEFIN,';
     Result := Result + 'YPL_LIBELLE AS JEV_EVTLIBELLE,';
     Result := Result + '"" AS JEV_GUIDEVT,"" AS JEV_CODEEVT,"-" AS JEV_EXTERNE,"-" AS JEV_ABSENCE,"" AS JEV_LIEU,"" AS JEV_GUIDPER,';
     Result := Result + '"" AS JEV_NODOSSIER,"" AS DOS_LIBELLE,"" AS JEV_AFFAIRE,"SIN" AS JEV_OCCURRENCEEVT,';
     Result := Result + 'NULL AS JEC_GUIDEVT,NULL AS JEC_RECURRENCETYPE,NULL AS JEC_START,NULL AS JEC_END,NULL AS JEC_RECURNUM,';
     Result := Result + 'NULL AS JEC_INTERVALLE,NULL AS JEC_NBOCCURRENCE,NULL AS JEC_WEEKDAYS,';
     Result := Result + 'NULL AS JEC_WEEKOFMONTH,NULL AS JEC_DAYOFMONTH,NULL AS JEC_MONTHOFYEAR,';
     Result := Result + 'YPL_PRIVE AS JEV_PERS, YPL_PREFIXE FROM YPLANNING ';
     Result := Result + 'LEFT JOIN YRESSOURCE ON YRS_GUID=YPL_GUIDYRS ';
     Result := Result + 'RIGHT JOIN CHOIXEXT ON (YX_TYPE="DAU" AND YX_LIBELLE="' + V_PGI.User + '" AND YX_ABREGE=YRS_USER AND YX_LIBRE<>"0") ';
     Result := Result + 'LEFT JOIN USERCONF ON YRS_USER=UCO_USER ';
     Result := Result + 'WHERE YPL_PREFIXE<>"JEV" ';

     if (strUsers <> '') and (strUsers <> '<<TOUS>>') then
        Result := Result + 'AND YRS_USER IN ("' + StringReplace (strUsers, ';', '","', [rfReplaceAll]) + '") ';
     if (strGroupesConf <> '') and (strGroupesConf <> '<<TOUS>>') then
        Result := Result + 'AND UCO_GROUPECONF IN ("' + StringReplace (strGroupesConf, ';', '","', [rfReplaceAll]) + '") ';

     Result := Result + 'AND YPL_DATEFIN>="' + USTIME (dtMin) + '" ';
     Result := Result + 'AND YPL_DATEDEBUT<"' + USTIME (dtMax) + '"';
end;

// $$$ JP 29/05/07: cr�ation d'une exception � partir d'une s�rie
function AgendaCreateException (Item:TOB; iExceptType:ActExcType; bComplete:boolean):string; //; iExceptOcc:integer):string;
var
   strGuidEvt              :string;
   strGuidEvtExcept        :string;
   TOBOcc, TOBExc  :TOB;
begin
     Result  := '';

     // $$$ JP 28/08/07: si exception avec lien sur activit� d'origine, il faut prendre ce lien en priorit�
     strGuidEvt := Item.GetValue ('I_GUIDEVTREC');
     if strGuidEvt = '' then
        strGuidEvt := Item.GetValue ('I_GUIDEVT');

     // Guid de l'exception qui va �tre cr��e
     strGuidEvtExcept := '';

     // Cr�ation de l'activit� repr�sentant l'exception
     if bComplete = TRUE then
     begin
          TOBOcc := TOB.Create ('JUEVENEMENT', nil, -1);
          try
             TOBOcc.LoadDetailDB ('JUEVENEMENT', '"' + strGuidEvt + '"', '', nil, FALSE);
             if TOBOcc.Detail.Count > 0 then
             begin
                  strGuidEvtExcept := AGLGetGuid;
                  with TOBOcc.Detail [0] do
                  begin
                       PutValue ('JEV_GUIDEVT',      strGuidEvtExcept);
                       PutValue ('JEV_OCCURENCEEVT', 'EXC');

                       // $$$ JP 21/08/07: avoir les dates d'exception: celle de l'item fourni
                       PutValue ('JEV_DATE',    Item.GetValue ('I_DATEDEBUT'));
                       PutValue ('JEV_DATEFIN', Item.GetValue ('I_DATEFIN'));

                       // Ajout dans la base
                       InsertDB (nil);
                  end;
             end;
          finally
             TOBOcc.Free;
          end;
     end;

     // Cr�ation de l'exception (li� � la r�currence d�finie)
     TOBExc  := TOB.Create ('JURECEXCEPTION', nil, -1);
     try
        with TOB.Create ('JURECEXCEPTION', TOBExc, -1) do
        begin
             InitValeurs;

             PutValue ('JEX_GUIDEVT',       strGuidEvt);
             PutValue ('JEX_RECURNUM',      1);
             PutValue ('JEX_EXCEPTNUM',     Item.GetValue ('I_OCCURNUM')); // $$$ JP 29/05/07: le n� d'occurence pour identifier l'exception dans la s�rie
             PutValue ('JEX_EXCEPTTYPE',    iExceptType);
             PutValue ('JEX_GUIDEVTEXCEPT', strGuidEvtExcept);
             if InsertDb (nil) = TRUE then
                Result := strGuidEvtExcept;
        end;
     finally
            TOBExc.Free;
     end;
end;

// $$$ JP 21/08/07 (strGuidEvt = guid activit� d'origine pour laquelle il faut supprimer TOUTES les exceptions)
procedure AgendaDeleteExceptions (strGuidEvt:string);
begin
     // Suppression de toutes les exceptions li� � cette activit� (dans JURECEXCEPTION et JUEVENEMENT)
     ExecuteSQL ('DELETE JUEVENEMENT WHERE EXISTS (SELECT 1 FROM JURECEXCEPTION WHERE JEX_GUIDEVTEXCEPT=JEV_GUIDEVT AND JEX_GUIDEVT="' + strGuidEvt + '")');
     ExecuteSQL ('DELETE JURECEXCEPTION WHERE JEX_GUIDEVT="' + strGuidEvt + '"');
end;

{$IFNDEF VER150}
function DayOf (const AValue: TDateTime): Word;
var
  LYear, LMonth: Word;
begin
     DecodeDate(AValue, LYear, LMonth, Result);
end;

function MonthOf (const AValue:TDateTime):Word;
var
  LYear, LDay: Word;
begin
     DecodeDate (AValue, LYear, Result, LDay);
end;

function DaysInAMonth (const AYear, AMonth:Word):Word;
begin
     Result := MonthDays [(AMonth = 2) and IsLeapYear(AYear), AMonth];
end;

function DaysInMonth (const AValue:TDateTime):Word;
var
  LYear, LMonth, LDay: Word;
begin
  DecodeDate(AValue, LYear, LMonth, LDay);
  Result := DaysInAMonth(LYear, LMonth);
end;
{$ENDIF}

// Conserve la partie "heure" (partie fractionnaire)
function AgendaGetDateOfDay (dtStart:TDateTime; iDayOfMonth:integer):TDateTime;
var
   wYear, wMonth, wDay  :Word;
begin
     DecodeDate (dtStart, wYear, wMonth, wDay);

     Result := dtStart - wDay + iDayOfMonth;
     if wDay > iDayOfMonth then
        Result := Result + DaysInAMonth (wYear, wMonth);
end;

// Ne conserve PAS la partie "heure" (partie fractionnaire)
function AgendaGetDateOfInstance (dtStart:TDateTime; strValidWeekDays:string; iInstance:integer):TDateTime;
var
   i, iWeekDay   :integer;
   strMonthDays  :string;
begin
     // Par d�faut, date non trouv�e
     Result := iDate1900;

     // On se positionne au d�but du mois
     dtStart := DebutDeMois (dtStart);

     // Jours �ligibles dans le mois
     iWeekDay := DayOfWeek (dtStart);
     if iWeekDay > 2 then
          strMonthDays := Copy (strValidWeekDays, iWeekDay-1, 9-iWeekDay)
     else if iWeekDay < 2 then
          strMonthDays := strValidWeekDays [7];
     for i := 1 to 5 do
         strMonthDays := strMonthDays + strValidWeekDays;
     strMonthDays := Copy (strMonthDays, 1, DaysInMonth (dtStart));

     // On se positionne sur l'instance du jour voulu
     for i := 1 to Length (strMonthDays) do
     begin
          if strMonthDays [i] <> '-' then
          begin
               // Au pire le dernier jour valide trouv�
               Result := dtStart + i - 1;
               if iInstance < 5 then
               begin
                    Dec (iInstance);
                    if iInstance = 0 then
                       exit;
               end
          end;
     end;
end;

function AgendaGetInstanceOfDate (dtStart:TDateTime):integer;
var
   dtMonth       :TDateTime;
   i, iDayOfWeek :integer;
begin
     // Par d�faut, date non trouv�e
     Result := 0;

     // On se positionne au d�but du mois
     dtMonth := DebutDeMois (dtStart);

     // On compte le nb d'instance du jour de semaine de la date sp�cifi� dans le mois, jusqu'� la date sp�cifi�e
     iDayOfWeek := DayOfWeek (dtStart);
     for i := 1 to DayOf (dtStart) do
         if DayOfWeek (dtMonth+i-1) = iDayOfWeek then
            Inc (Result);
end;

// Si iOccurence sp�cifi� (>0), dtOccurence recevra la date d�but de l'occurence n� iOccurence
function AgendaGetOccurence (iRecType:ActFrequence; var dtStart:TDateTime; var dtOccurence:TDateTime; var iOccurence:integer; iInterval:integer = 1; iInstance:integer = 0; strDaysOfWeek:string = ''; {iDayOfWeek:integer = 0;} iDayOfMonth:integer = 0; iMonthOfYear:integer = 0):boolean;
var
   iDayOfWeek       :integer;
   iNewDayOfWeek    :integer;
   i, iNbDays       :integer;
   wYearA, wYearB   :word;
   wMonthA, wMonthB :word;
   wDay             :word;
   dTime            :extended;
   dtDate           :TDateTime;
begin
     Result := FALSE;

     // $$$ JP 05/06/07: si pas de type de r�p�tition, on ne peut rien calculer
     if iRecType = ACF_NONE then
        exit;

     // L'interval doit toujours �tre non nul, sauf en mode Annuel (non utilis�), ou bien hebdomadaire jours ouvrables
     if iInterval = 0 then
        if (iRecType <> ACF_YEARLY) and ((iRecType <> ACF_WEEKLY) or (strDaysOfWeek <> 'XXXXX--')) then
            exit
        else
            iInterval := 1;

     // $$$ JP 05/06/07: calcul de la premi�re occurence d�sormais possible (et toujours ok: = dtStart)
     if iOccurence = 1 then
     begin
          dtOccurence := dtStart;
          Result      := TRUE;
          exit;
     end;

     // L'heure dans la date
     dTime := Frac (dtStart);

     // Calcul de l'occurence en fonction du type de p�riodicit�
     case iRecType of
          ACF_DAILY:
          begin
               // Date de fin par rapport au nb d'occurence
               if iOccurence > 0 then
               begin
                    dtOccurence := dtStart + ((iOccurence-1) * iInterval);
                    Result      := dtOccurence > dtStart;
               end
               else
               begin
                    // Nb d'occurence minimum pour approcher la date de fin (sans la d�passer)
                    iOccurence := Trunc (dtOccurence - dtStart);
                    iOccurence := 1 + (iOccurence div iInterval);
                    Result     := iOccurence > 0;
               end;
          end;

          ACF_WEEKLY:
          begin
               iDayOfWeek := DayOfWeek (dtStart);
               if iDayOfWeek = 1 then
                   iDayOfWeek := 7
               else
                   Dec (iDayOfWeek);
               dtStart := dtStart - iDayOfWeek;

               iNewDayOfWeek := 0;
               for i := iDayOfWeek to 7 do
               begin
                    if strDaysOfWeek [i] <> '-' then
                    begin
                         iNewDayOfWeek := i;
                         break;
                    end;
               end;
               if iNewDayOfWeek = 0 then
               begin
                    for i := 1 to iDayOfWeek - 1 do
                    begin
                         if strDaysOfWeek [i] <> '-' then
                         begin
                              iNewDayOfWeek := i + 7;
                              break;
                         end;
                    end;
               end;

               if iNewDayOfWeek > 0 then
               begin
                    dtStart := dtStart + iNewDayOfWeek;
                    iNbDays := 0;
                    for i := 1 to 7 do
                        if strDaysOfWeek [i] <> '-' then
                           Inc (iNbDays);
                    if iOccurence > 0 then
                    begin
                         dtOccurence := dtStart + 7*((iOccurence-1) div iNbDays)*iInterval;
                         iNbDays := (iOccurence-1) mod iNbDays;
                         while iNbDays > 0 do
                         begin
                              dtOccurence := dtOccurence + 1;
                              Inc (iNewDayOfWeek);
                              if iNewDayOfWeek > 7 then
                              begin
                                   iNewDayOfWeek := 1;
                                   dtOccurence := dtOccurence + 7*(iInterval-1);
                              end;

                              if strDaysOfWeek [iNewDayOfWeek] <> '-' then
                                 Dec (iNbDays);
                         end;

                         Result := dtOccurence > dtStart;
                    end
                    else
                    begin
                         // Nb d'occurence minimum pour approcher la date de fin (sans la d�passer)
                         iOccurence := 0;
                         iDayOfWeek := DayOfWeek (dtStart);
                         if iDayOfWeek = 1 then
                             iDayOfWeek := 7
                         else
                             Dec (iDayOfWeek);
                         dtDate := dtStart;
                         while dtDate <= dtOccurence do
                         begin
                              if strDaysOfWeek [iDayOfWeek] <> '-' then
                                 Inc (iOccurence);

                              dtDate := dtDate + 1;
                              Inc (iDayOfWeek);
                              if iDayOfWeek > 7 then
                              begin
                                   iDayOfWeek := 1;
                                   dtDate     := dtDate + 7*(iInterval-1);
                              end;
                         end;

                         Result := iOccurence > 0;
                    end
               end
               else
                   Result := FALSE;
          end;

          ACF_MONTHLY:
          begin
               if iInstance = 0 then
               begin
                    // Date d�but correspondant au n� de jour du mois sp�cifi�
                    dtStart := AgendaGetDateOfDay (dtStart, iDayOfMonth);

                    // Date fin th�orique de la s�rie
                    if iOccurence > 0 then
                    begin
                         dtOccurence := AgendaGetDateOfDay (IncMonth (dtStart, (iOccurence-1)*iInterval), iDayOfMonth);
                         Result := dtOccurence > dtStart;
                    end
                    else
                    begin
                         DecodeDate (dtStart,     wYearA, wMonthA, wDay);
                         DecodeDate (dtOccurence, wYearB, wMonthB, wDay);
                         iOccurence := 1 + 12*(wYearB-wYearA);
                         if wMonthB >= wMonthA then
                             iOccurence := iOccurence + (wMonthB - wMonthA)
                         else
                             iOccurence := iOccurence - (wMonthA - wMonthB);
                         iOccurence := iOccurence div iInterval;

                         Result := iOccurence > 0;
                    end;
               end
               else
               begin
                    // Date d�but correspondant au n� de jours de semaine sp�cifi� (4�me jeudi, premier lundi, dernier jour ouvrable, ...)
                    dtStart := AgendaGetDateOfInstance (dtStart, strDaysOfWeek, iInstance);

                    // Date fin th�orique de la s�rie
                    if iOccurence > 0 then
                    begin
                         dtOccurence := AgendaGetDateOfInstance (IncMonth (dtStart, (iOccurence-1)*iInterval), strDaysOfWeek, iInstance);

                         // on remet l'heure dans les dates
                         dtStart     := dtStart     + dTime;
                         dtOccurence := dtOccurence + dTime;

                         Result := dtOccurence > dtStart;
                    end
                    else
                    begin
                         DecodeDate (dtStart,     wYearA, wMonthA, wDay);
                         DecodeDate (dtOccurence, wYearB, wMonthB, wDay);
                         iOccurence := 1 + 12*(wYearB-wYearA);
                         if wMonthB >= wMonthA then
                             iOccurence := iOccurence + (wMonthB - wMonthA)
                         else
                             iOccurence := iOccurence - (wMonthA - wMonthB);
                         iOccurence := iOccurence div iInterval;

                         Result := iOccurence > 0;
                    end;
               end;
          end;

          ACF_YEARLY:
          begin
               DecodeDate (dtStart, wYearA, wMonthA, wDay);
               if iInstance = 0 then
               begin
                    dtStart := EncodeDate (wYearA, iMonthOfYear, 1);
                    if iDayOfMonth < DaysInMonth (dtStart) then
                        dtStart := dtStart + iDayOfMonth - 1
                    else
                        dtStart := dtStart + DaysInMonth (dtStart) - 1;
                    if iOccurence > 0 then
                    begin
                         dtOccurence := EncodeDate (wYearA + iOccurence - 1, iMonthOfYear, 1);
                         if iDayOfMonth < DaysInMonth (dtOccurence) then
                             dtOccurence := dtOccurence + iDayOfMonth - 1
                         else
                             dtOccurence := dtOccurence + DaysInMonth (dtOccurence) - 1;

                         // on remet l'heure dans les dates
                         dtStart     := dtStart + dTime;
                         dtOccurence := dtOccurence   + dTime;

                         Result := dtOccurence > dtStart;
                    end
                    else
                    begin
                         DecodeDate (dtOccurence, wYearB, wMonthB, wDay);
                         iOccurence := wYearB-wYearA+1;

                         Result := iOccurence > 0;
                    end;
               end
               else
               begin
                    dtStart := AgendaGetDateOfInstance (EncodeDate (wYearA, iMonthOfYear, 1), strDaysOfWeek, iInstance);
                    if iOccurence > 0 then
                    begin
                         dtOccurence := AgendaGetDateOfInstance (EncodeDate (wYearA+iOccurence-1, iMonthOfYear, 1), strDaysOfWeek, iInstance);

                         // on remet l'heure dans les dates
                         dtStart     := dtStart + dTime;
                         dtOccurence := dtOccurence   + dTime;

                         Result := dtOccurence > dtStart;
                    end
                    else
                    begin
                         DecodeDate (dtOccurence, wYearB, wMonthB, wDay);
                         iOccurence := wYearB-wYearA+1;

                         Result := iOccurence > 0;
                    end;
               end;
          end;
     end;
end;

// $$$ JP 29/05/07: connaitre la port�e souhait�e pour la modification (sur la s�rie ou sur l'occurence en cours)
function AgendaSelectPortee (strTypeOcc:string; strTitle:string; bExceptEnabled:boolean=FALSE):ActPortee;
var
   FChoixPortee :TFAgendaChoixRecurrence;
begin
     // Par d�faut, modification sur la s�rie
     if strTypeOcc <> 'SIN' then
     begin
          Result := ACP_SERIE;

          // $$$ JP 31/08/07: ne pas activer pur l'instant, le faire d�s que les alertes et la synchro outlook prendra en compte les exceptions
          exit;
          
          // Choix de la portee des modifications, uniquement si activit� poss�de une s�rie
          FChoixPortee := TFAgendaChoixRecurrence.Create (nil);
          try
             FChoixPortee.ModifCaption  := strTitle;
             FChoixPortee.ExceptEnabled := bExceptEnabled;
             if FChoixPortee.ShowModal = mrOk then
                 Result := FChoixPortee.ModifPortee
             else
                 Result := ACP_NONE;
          finally
                 FChoixPortee.Free;
          end;
     end
     else
         Result := ACP_OCCURENCE;
end;



//-----------------------------------------------
//           Objet de synchro avec Outlook
//-----------------------------------------------
constructor TOutlookSync.Create (iTypeSync:integer; iConflictSolver:integer; iSupprSolver:integer; bSupprFull:boolean);
begin
     m_iTypeSync       := iTypeSync;
     m_iConflictSolver := iConflictSolver;
     m_iSupprSolver    := iSupprSolver;
     m_bSupprFull      := bSupprFull;

     // Identifiant de la base Cegid pr�vue pour la synchro
     m_strGuidBase := dpGetBaseGuid;
end;

// $$$ JP 30/10/06
function TOutlookSync.WeekDaysToWeekMask (strDaysOfWeek:string):integer;
var
   iDayMask, i   :integer;
begin
     // Par d�faut, aucun jour
     Result := 0;

     // Construction du masque
     if Length (strDaysOfWeek) = 7 then
         strDaysOfWeek := strDaysOfWeek [7] + Copy (strDaysOfWeek, 1, 6)
     else
         strDaysOfWeek := '-' + strDaysOfWeek + StringOfChar ('-', 6-Length (strDaysOfWeek));
     iDayMask := 1;
     for i := 1 to Length (strDaysOfWeek) do
     begin
          if strDaysOfWeek [i] = 'X' then
             Result := Result or iDayMask;
          iDayMask := iDayMask shl 1;
     end;
end;

// $$$ JP 30/10/06
function TOutlookSync.WeekMaskToWeekDays (iDaysOfWeek:integer):string;
var
   iDaysMask   :integer;
begin
     Result    := '';
     iDaysMask := 1;
     while iDaysMask < 128 do
     begin
          if (iDaysOfWeek and iDaysMask) = iDaysMask then
              Result := Result + 'X'
          else
              Result := Result + '-';
          iDaysMask := iDaysMask shl 1;
     end;
     Result := Result + Result [1];
     system.Delete (Result, 1, 1);
end;

// $$$ JP 27/10/06: comparaison des r�currences (car elles doivent �tre mises � jour que si elles changent r�ellement)
//                  entre autre cons�quence de la modification d'une r�currence (dans outlook surtout): exceptions supprim�es
function TOutlookSync.IsRecEqual (ActItem:TOB; ApptItem:variant):boolean;
var
   strActRec      :string;
   bApptRec       :boolean;
   vRecItem       :variant;
   strActRecType  :string;
   dtStart        :TDateTime;
   dtEnd          :TDateTime;
   iActTimeStart  :integer;
   iActTimeEnd    :integer;
   iApptTimeStart :integer;
   iApptTimeEnd   :integer;
   iNbOcc         :integer;
begin
     // On compare surtout le type de r�currence, et dans le m�me type les propri�t�s principales
     strActRec := ActItem.GetValue ('JEV_OCCURENCEEVT');
     bApptRec  := ApptItem.IsRecurring;
     if (strActRec = 'REC') and ( bApptRec = TRUE) then
     begin
          vRecItem := ApptItem.GetRecurrencePattern;
          if IDispatch (vRecItem) <> nil then
          begin
               // Comparaison de la plage de p�riodicit�
               dtStart        := ActItem.GetValue ('JEC_START');
               dtEnd          := ActItem.GetValue ('JEC_END');
               iActTimeStart  := Round (Frac (ActItem.GetValue ('JEV_DATE')) * 86400);
               iActTimeEnd    := Round (Frac (ActItem.GetValue ('JEV_DATEFIN')) * 86400);
               iApptTimeStart := Round (Frac (vRecItem.StartTime) * 86400);
               iApptTimeEnd   := Round (Frac (vRecItem.EndTime) * 86400);

               iNbOcc       := ActItem.GetValue ('JEC_NBOCCURRENCE');
               if vRecItem.PatternStartDate <> dtStart then
               begin
                    Result := FALSE;
                    exit;
               end
               else if (iApptTimeStart <> iActTimeStart) or (iApptTimeEnd <> iActTimeEnd) then
               begin
                    Result := FALSE;
                    exit;
               end
               else if (vRecItem.NoEndDate = TRUE) and ((iNbOcc > 0) or (dtEnd > iDate1900)) then
               begin
                    Result := FALSE;
                    exit;
               end
               // $$$ JP 22/01/07: s'il y a une fin dans Outlook et pas dans l'agenda Cegid: diff�rence
               else if (vRecItem.NoEndDate = FALSE) and ((iNbOcc = 0) or (dtEnd <= iDate1900)) then
               begin
                    Result := FALSE;
                    exit;
               end
               else if (dtEnd > iDate1900) and (vRecItem.PatternEndDate <> dtEnd) then
               begin
                    Result := FALSE; // $$$ JP 22/01/07 TRUE;
                    exit;
               end
               // $$$ JP 22/01/07: OccurRences et non pas Occurences!!
               else if (iNbOcc > 0) and (vRecItem.Occurrences <> iNbOcc) then
               begin
                    Result := FALSE; // $$$ JP 22/01/07 TRUE;
                    exit;
               end;

               // Comparaison des propri�t�s de r�currence selon le type de r�currence
               strActRecType := ActItem.GetValue ('JEC_RECURRENCETYPE');
               case vRecItem.RecurrenceType of
                    olRecursDaily:
                    begin
                         if strActRecType <> 'QUO' then
                             Result := FALSE
                         else
                             Result := vRecItem.Interval = ActItem.GetValue ('JEC_INTERVALLE');
                    end;

                    olRecursWeekly:
                    begin
                         if strActRecType <> 'HEB' then
                             Result := FALSE
                         else
                             Result := (vRecItem.Interval      = ActItem.GetValue ('JEC_INTERVALLE')) and
                                       (vRecItem.DayOfWeekMask = WeekDaysToWeekMask (ActItem.GetValue ('JEC_WEEKDAYS')));
                    end;

                    olRecursMonthly:
                    begin
                         if strActRecType <> 'MEN' then
                             Result := FALSE
                         else
                             Result := (vRecItem.Interval   = ActItem.GetValue ('JEC_INTERVALLE')) and
                                       (vRecItem.DayOfMonth = ActItem.GetValue ('JEC_DAYOFMONTH'));
                    end;

                    olRecursMonthNth:
                    begin
                         if strActRecType <> 'MEX' then
                             Result := FALSE
                         else
                             Result := (vRecItem.Interval      = ActItem.GetValue ('JEC_INTERVALLE')) and
                                       (vRecItem.Instance      = ActItem.GetValue ('JEC_WEEKOFMONTH')) and
                                       (vRecItem.DayOfWeekMask = WeekDaysToWeekMask (ActItem.GetValue ('JEC_WEEKDAYS')));
                    end;

                    olRecursYearly:
                    begin
                         if strActRecType <> 'ANN' then
                             Result := FALSE
                         else
                             Result := (vRecItem.MonthOfYear = ActItem.GetValue ('JEC_MONTHOFYEAR')) and
                                       (vRecItem.DayOfMonth  = ActItem.GetValue ('JEC_DAYOFMONTH'));
                    end;

                    olRecursYearNth:
                    begin
                         if strActRecType <> 'ANX' then
                             Result := FALSE
                         else
                             Result := (vRecItem.Instance      = ActItem.GetValue ('JEC_WEEKOFMONTH')) and
                                       (vRecItem.MonthOfYear   = ActItem.GetValue ('JEC_MONTHOFYEAR')) and
                                       (vRecItem.DayOfWeekMask = WeekDaysToWeekMask (ActItem.GetValue ('JEC_WEEKDAYS')));
                    end;
               end;

               vRecItem := unAssigned;
          end
          else
              Result := FALSE;
     end
     else
         Result := (strActRec <> 'REC') and (bApptRec = FALSE);
end;

procedure TOutlookSync.ActApptLink (ActItem:TOB; ApptItem:variant);
var
   vUserProp   :variant;
   strGuidEvt  :string;
begin
     // Un �l�ment de plus synchronis� ou import�
     Inc (m_iNbSync);

     // Infos de synchro dans le rdv (seulement si synchronisation, pas si import)
     if (IDispatch (ApptItem) <> nil) and (m_iTypeSync <> ostImport) then
     begin
          try
             // Identifiant de la base Pgi dans le rdv outlook (on le stocke pour chaque �l�ment, au cas o� plus tard on pourrait synchroniser plusieurs bases Cegid avec le m�me calendrier Outlook)
             vUserProp := ApptItem.UserProperties.Find ('CEGIDBASEGUID');
             if IDispatch (vUserProp) = nil then
                vUserProp := ApptItem.UserProperties.Add ('CEGIDBASEGUID', olText, FALSE); // TRUE); FQ 11807
             if IDispatch (vUserProp) <> nil then
                vUserProp.Value := m_strGuidBase;

             // Identifiant de l'activit� li� dans le rdv outlook
             if ActItem <> nil then
             begin
                  vUserProp := ApptItem.UserProperties.Find ('CEGIDEVTGUID', olText);
                  if IDispatch (vUserProp) = nil then
                     vUserProp := ApptItem.UserProperties.Add ('CEGIDEVTGUID', olText, FALSE);
                  if IDispatch (vUserProp) <> nil then
                  begin
                       strGuidEvt := ActItem.GetValue ('JEV_GUIDEVT');
                       vUserProp.Value := strGuidEvt;
                  end;
             end;
          finally
                 vUserProp := unAssigned;
          end;

          // On enregistre le rdv outlook
          ApptItem.Save;
     end;

     // Infos de synchro dans l'activit� Pgi
     if ActItem <> nil then
     begin
          if IDispatch (ApptItem) <> nil then
          begin
               ActItem.PutValue  ('JEV_DUREE', ApptItem.LastModificationTime);
               if m_iTypeSync <> ostImport then
               begin
                    ActItem.PutValue  ('JEV_FOREIGNID',   ApptItem.EntryId);
                    ActItem.PutValue  ('JEV_FOREIGNAPP',  'OUT');
               end;
          end;
          ActItem.AddChampSupValeur ('SYNCHRO', 'SYNC');
     end;
end;

// Cr�ation d'un enreg' activit� � partir d'un rdv outlook   $$$todo: comment r�cup�rer cat�gorie de calendrier? (pour savoir si personnel, cong�s, ...)
function TOutlookSync.ApptToAct (ApptItem:variant; ActItem:TOB):TOB;
var
   strEvtGuid     :string;
   vRecItem       :variant;
begin
   try
     // Si pas d'activit� � mettre � jour, c'est une cr�ation
     if ActItem = nil then
     begin
          ActItem := TOB.Create ('les activit�s', m_ActItems, -1);
          strEvtGuid := AglGetGuid;

          with ActItem do
          begin
               AddChampSupValeur ('JEV_GUIDEVT',  strEvtGuid);
               AddChampSup ('JEV_CODEEVT',        FALSE);
               AddChampSupValeur ('JEV_OCCURENCEEVT', 'SIN'); // $$$ JP 29/03/07: par d�faut, pas de r�currence
               AddChampSup ('JEV_DATE',           FALSE);
               AddChampSup ('JEV_DATEFIN',        FALSE);
               AddChampSup ('JEV_EVTLIBELLE',     FALSE);
               AddChampSup ('JEV_LIEU',           FALSE);
               AddChampSup ('JEV_AFFAIRE',        FALSE);
               AddChampSup ('JEV_GUIDPER',        FALSE);
               AddChampSup ('JEV_NODOSSIER',      FALSE);
               AddChampSup ('JEV_EXTERNE',        FALSE);
               AddChampSup ('JEV_ABSENCE',        FALSE);
               AddChampSup ('JEV_PERS',           FALSE);
               AddChampSup ('JEV_ALERTE',         FALSE);
               AddChampSup ('JEV_ALERTEDATE',     FALSE);
               AddChampSup ('JEV_DUREE',          FALSE);
               AddChampSup ('JEV_FOREIGNID',      FALSE);
               AddChampSup ('JEV_FOREIGNAPP',     FALSE);

               // $$$ JP22/01/07: pas de r�currence par d�faut
               AddChampSupValeur ('JEC_GUIDEVT',  ''); //strEvtGuid);
               AddChampSupValeur ('JEC_RECURNUM', 0); //1); // Pour l'instant qu'une seul r�currence par activit�
               AddChampSup ('JEC_INTERVALLE',     FALSE);
               AddChampSup ('JEC_START',          FALSE);
               AddChampSup ('JEC_END',            FALSE);
               AddChampSup ('JEC_NBOCCURRENCE',   FALSE);
               AddChampSup ('JEC_RECURRENCETYPE', FALSE);
               AddChampSup ('JEC_WEEKDAYS',       FALSE);
               AddChampSup ('JEC_DAYOFMONTH',     FALSE);
               AddChampSup ('JEC_WEEKOFMONTH',    FALSE);
               AddChampSup ('JEC_MONTHOFYEAR',    FALSE);
          end;
     end
     else
        strEvtGuid := ActItem.GetValue ('JEV_GUIDEVT');

     // Nouvelle TOB (on r�cup�rera les identifiant de l'activit� sp�cifi�e si elle existe)
     with ActItem do
     begin
          PutValue ('JEV_EVTLIBELLE', ApptItem.Subject);
          PutValue ('JEV_LIEU',       ApptItem.Location);
          if ApptItem.ReminderSet = TRUE then
          begin
                PutValue ('JEV_ALERTE',     'X');
                PutValue ('JEV_ALERTEDATE', ApptItem.Start - (ApptItem.ReminderMinutesBeforeStart/1440));
          end
          else
          begin
                PutValue ('JEV_ALERTE',     '-');
                PutValue ('JEV_ALERTEDATE', iDate1900);
          end;

          // Sensitivity <=> JEV_PERS
          if ApptItem.Sensitivity = olPrivate then
              PutValue ('JEV_PERS', 'X')
          else
              PutValue ('JEV_PERS', '-');

          // "Cong�" dans Categories <=> JEV_ABSENCE
          if Pos ('Cong� (Jour de)', ApptItem.Categories) > 0 then
          begin
               PutValue ('JEV_ABSENCE', 'X');
               PutValue ('JEV_EXTERNE', '-');
               PutValue ('JEV_CODEEVT', 'OUTABS');
          end
          else
          begin
               PutValue ('JEV_ABSENCE', '-');

               // Busy <=> JEV_EXTERNE et JEV_CODEEVT
               if ApptItem.BusyStatus = olOutOfOffice then
               begin
                    PutValue ('JEV_EXTERNE', 'X');
                    PutValue ('JEV_CODEEVT', 'OUTEXT');
               end
               else
               begin
                    PutValue ('JEV_EXTERNE', '-');
                    PutValue ('JEV_CODEEVT', 'OUTINT');
               end;
          end;

          // Cr�ation de la r�currence si elle a chang�e
          if IsRecEqual (ActItem, ApptItem) = FALSE then //if ApptItem.IsRecurring = TRUE then
          begin
               // Les dates
               PutValue ('JEV_DATE',    ApptItem.Start);
               PutValue ('JEV_DATEFIN', ApptItem.End);
               if ApptItem.AllDayEvent = TRUE then
                  PutValue ('JEV_DATEFIN', GetValue ('JEV_DATEFIN') - 1/1440);

               // Si r�currente ou pas, on aliement ou non les propri�t�s de r�currence de l'activit�
               if ApptItem.IsRecurring = FALSE then
                    // Activit� pas (ou plus) r�currente. Lors de l'enreg' de la TOB, l'enreg de r�currence sera supprim�
                    PutValue ('JEV_OCCURENCEEVT', 'SIN')
               else
               begin
                    // Lecture des propri�t�s de r�currence du rendez-vous outlook
                    vRecItem := ApptItem.GetRecurrencePattern;
                    if IDispatch (vRecItem) <> nil then
                    begin
                         // $$$ JP 22/01/07: il faut bien sp�cifier le guid activit� pour pouvoir le supprimer de la base
                         PutValue ('JEC_GUIDEVT',  strEvtGuid);
                         PutValue ('JEC_RECURNUM', 1);

                         PutValue ('JEV_OCCURENCEEVT', 'REC');
                         PutValue ('JEC_INTERVALLE',   vRecItem.Interval);
                         PutValue ('JEC_START',        vRecItem.PatternStartDate);
                         if vRecItem.NoEndDate = FALSE then
                             PutValue ('JEC_END', vRecItem.PatternEndDate)
                         else
                             PutValue ('JEC_END', iDate1900);
                         PutValue ('JEC_NBOCCURRENCE', 0);

                         // Type de r�currence
                         case vRecItem.RecurrenceType of
                              0: // Quotidienne
                                 PutValue ('JEC_RECURRENCETYPE', 'QUO');

                              1: // Hebdomadaire
                                 PutValue ('JEC_RECURRENCETYPE', 'HEB');

                              2: // Mensuel
                                 PutValue ('JEC_RECURRENCETYPE', 'MEN');

                              3: // Mensuel par instance de jour
                                 PutValue ('JEC_RECURRENCETYPE', 'MEX');

                              5: // Annuel
                                 PutValue ('JEC_RECURRENCETYPE', 'ANN');

                              6: // Annuel par instance de jour
                                 PutValue ('JEC_RECURRENCETYPE', 'ANX');
                         end;

                         // Jours de semaine �ligibles
                         PutValue ('JEC_WEEKDAYS', WeekMaskToWeekDays (vRecItem.DayOfWeekMask));

                         // Les autres propri�t�s
                         PutValue ('JEC_DAYOFMONTH',  vRecItem.DayOfMonth);
                         PutValue ('JEC_WEEKOFMONTH', vRecItem.Instance);
                         PutValue ('JEC_MONTHOFYEAR', vRecItem.MonthOfYear);
                    end
                    else
                         PutValue ('JEV_OCCURENCEEVT', 'SIN');
               end;

               vRecItem := unAssigned;
          end
          else
          begin
               // Ne pas oublier les dates (� faire en dernier, sinon IsRecEqual impossible)
               PutValue ('JEV_DATE',    ApptItem.Start);
               PutValue ('JEV_DATEFIN', ApptItem.End);
               if ApptItem.AllDayEvent = TRUE then
                  PutValue ('JEV_DATEFIN', GetValue ('JEV_DATEFIN') - 1/1440)

               // $$$ JP 22/01/07: pourquoi forcer � rdv non p�riodique, puisque les recurrences sont �gales (donc peuvent exister)
               //PutValue ('JEV_OCCURENCEEVT', 'SIN');
          end;
     end;

     // Fait le lien entre l'activit� et le rdv outlook (id de l'un dans l'autre, et vice-versa + date synchro=date modif' rdv outlook)
     ActApptLink (ActItem, ApptItem);

     Result := ActItem;
   except
         on E:Exception do
         begin
              PgiInfo ('Erreur de copie du rendez-vous "' + DateTimeToStr (ApptItem.Start) + ' - ' + ApptItem.Subject + '" dans l''activit� associ�e'#10' Erreur: ' + E.Message);
              Result := nil;

              // Il faut marquer l'activit� comme trait�e (non synchronis�e), sinon consid�r�e en phase 2 comme � supprimer
              if (ActItem <> nil) and (ActItem.FieldExists ('SYNCHRO') = FALSE) then
                 ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC');
         end;
   end;
end;

// Cr�ation d'un rdv outlook � partir d'un enreg' activit�
function TOutlookSync.ActToAppt (ActItem:TOB; ApptItem:variant):variant;
var
   vRecItem      :variant;
   strRecType    :string;
   strValue      :string;
   iDaysOfWeek   :integer;
   i             :integer;
begin
   try
     // Si pas de rendez-vous outlook � mettre � jour, c'est une cr�ation
     if IDispatch (ApptItem) = nil then
        ApptItem := m_ApptItems.Add (olAppointmentItem);

     if IDispatch (ApptItem) <> nil then
     begin
          // Libell� (ent�te) et lieu (la note difficile: message de s�curit� dans outlook + r�cup�ration uniquement du texte (pas d'image, ...))
          strValue          := ActItem.GetValue ('JEV_EVTLIBELLE');
          ApptItem.Subject  := strValue;
          strValue          := ActItem.GetValue ('JEV_LIEU');
          ApptItem.Location := strValue;

          // Alerte (rappel Outlook)
          if ActItem.GetValue ('JEV_ALERTE') = 'X' then
          begin
               ApptItem.ReminderSet                := TRUE;
               ApptItem.ReminderMinutesBeforeStart := (ActItem.GetValue ('JEV_DATE') - ActItem.GetValue ('JEV_ALERTEDATE'))*1440;
          end
          else
               ApptItem.ReminderSet                := FALSE;

          // Sensitivity <=> JEV_PERS
          if ActItem.GetValue ('JEV_PERS') = 'X' then
              ApptItem.Sensitivity := olPrivate
          else                     
              // On change la sensibilit� si pas olConfidential avant (sinon on fait rien: le rdv doit garder son statut confidentiel, non g�r� en pgi)
              if ApptItem.Sensitivity <> olConfidential then
                 ApptITem.Sensitivity := olNormal;

          // "Cong�" dans Categories <=> JEV_ABSENCE
          strValue := ApptItem.Categories;
          i        := Pos ('Cong� (Jour de)', strValue);
          if ActItem.GetValue ('JEV_ABSENCE') = 'X' then
          begin
               if i = 0 then
                  ApptItem.Categories := strValue + ';Cong� (Jour de)';
          end
          else if i > 0 then
               ApptItem.Categories := Copy (strValue, 1, i-1) + Copy (strValue, i+15, Length (strValue));

          // Busy <=> JEV_EXTERNE
          if ActItem.GetValue ('JEV_EXTERNE') = 'X' then
              ApptItem.BusyStatus := olOutOfOffice
          else
              // On change le statut occup� si olOutOfOffice avant (sinon on fait rien: le rdv doit garder son statut occup� ou tentative, non g�r� en pgi)
              if ApptItem.BusyStatus = olOutOfOffice then
                 ApptItem.BusyStatus := olFree;

          // Maj de la r�currence si n�cessaire
          if IsRecEqual (ActItem, ApptItem) = FALSE then
          begin
               // On supprime l'ancienne r�currence (s'il le faut, on la re-cr�er de toute pi�ces)
               ApptItem.ClearRecurrencePattern;

               // Date de d�part du rdv (la date d�but de la r�currence s'en d�duise)
               ApptItem.Start       := ActItem.GetValue ('JEV_DATE');
               ApptItem.End         := ActItem.GetValue ('JEV_DATEFIN');
               ApptItem.AllDayEvent := (Frac (ActItem.GetValue ('JEV_DATE')) = 0.0) and (1440*Frac (ActItem.GetValue ('JEV_DATEFIN')) > 1438);

               // Si pas de r�currence pgi, on supprime la r�currence outlook
               if ActItem.GetValue ('JEV_OCCURENCEEVT') = 'REC' then
               begin
                    // On cr�er la r�currence outlook si c'�tait pas d�j� le cas
                    vRecItem := ApptItem.GetRecurrencePattern;

                    // Type de r�currence (hebdomadaire, ...)
                    strRecType := ActItem.GetValue ('JEC_RECURRENCETYPE');
                    if strRecType = 'QUO' then
                    begin
                         vRecItem.RecurrenceType := olRecursDaily;
                         vRecItem.Interval       := ActItem.GetValue ('JEC_INTERVALLE');
                    end
                    else
                    begin
                         // D�termination des jours de semaine �ligibles
                         iDaysOfWeek := WeekDaysToWeekMask (ActItem.GetValue ('JEC_WEEKDAYS'));

                         // Selon type de r�currence, on alimente le rdv outlook
                         if strRecType = 'HEB' then
                         begin
                              // $$$ JP 27/10/06: on ne change rien si d�j� d�fini en "tous les jour de travail" (impossible de sp�cifier � outlook cette r�currence)
                              i := ActItem.GetValue ('JEC_INTERVALLE');
                              vRecItem.RecurrenceType := olRecursWeekly;
                              if i = 0 then
                                 i := 1; // H�las, outlook renvoie 0 mais ne l'accepte pas en �criture!
                              vRecItem.Interval       := i;
                              vRecItem.DayOfWeekMask  := iDaysOfWeek;
                         end
                         else if strRecType = 'MEN' then
                         begin
                              vRecItem.RecurrenceType := olRecursMonthly;
                              vRecItem.DayOfMonth     := ActItem.GetValue ('JEC_DAYOFMONTH');
                              vRecItem.Interval       := ActItem.GetValue ('JEC_INTERVALLE');
                         end
                         else if strRecType = 'MEX' then
                         begin
                              vRecItem.RecurrenceType := olRecursMonthNth;
                              vRecItem.Instance       := ActItem.GetValue ('JEC_WEEKOFMONTH');
                              vRecItem.Interval       := ActItem.GetValue ('JEC_INTERVALLE');
                              vRecItem.DayOfWeekMask  := iDaysOfWeek;
                         end
                         else if strRecType = 'ANN' then
                         begin
                              vRecItem.RecurrenceType := olRecursYearly;
                              vRecItem.DayOfMonth     := ActItem.GetValue ('JEC_DAYOFMONTH');
                              vRecItem.MonthOfYear    := ActItem.GetValue ('JEC_MONTHOFYEAR');
                         end
                         else if strRecType = 'ANX' then
                         begin
                              vRecItem.RecurrenceType := olRecursYearNth;
                              vRecItem.Instance       := ActItem.GetValue ('JEC_WEEKOFMONTH');
                              vRecItem.MonthOfYear    := ActItem.GetValue ('JEC_MONTHOFYEAR');
                              vRecItem.DayOfWeekMask  := iDaysOfWeek;
                         end;
                    end;

                    // Fr�quence, nb d'occurence et/ou date de fin de r�currence
                    if ActItem.GetValue ('JEC_NBOCCURRENCE') > 0 then
                         vRecItem.Occurrences := ActItem.GetValue ('JEC_NBOCCURRENCE')
                    else if ActItem.GetValue ('JEC_END') > iDate1900 then
                         vRecItem.PatternEndDate := ActItem.GetValue ('JEC_END');
               end;
          end
          else
          begin
               // On m�j les dates seulement si le rdv non r�current (l'activit� ne l'est pas non plus, sinon IsRecEqual renverrait FALSE)
               if ApptItem.IsRecurring = FALSE then
               begin
                    ApptItem.Start       := ActItem.GetValue ('JEV_DATE');
                    ApptItem.End         := ActItem.GetValue ('JEV_DATEFIN');
                    ApptItem.AllDayEvent := (Frac (ActItem.GetValue ('JEV_DATE')) = 0.0) and (1440*Frac (ActItem.GetValue ('JEV_DATEFIN')) > 1438);
               end;
          end;

          // Lien entre l'activit� et le rdv outlook
          ActApptLink (ActItem, ApptItem);

          vRecItem := unAssigned;
     end;

     Result := ApptItem;
   except
         on E:Exception do
         begin
              PgiInfo ('Erreur de copie activit� "' + DateTimeToStr (ActItem.GetValue ('JEV_DATE')) + ' - ' + ActItem.GetValue ('JEV_EVTLIBELLE') + '" dans le rendez-vous associ�'#10' Erreur: ' + E.Message);
              Result := unAssigned;

              // Il faut marquer l'activit� comme trait�e (non synchronis�e), sinon consid�r�e en phase 2 comme � supprimer
              if ActItem.FieldExists ('SYNCHRO') = FALSE then
                 ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC');
         end;
   end;
end;

// Synchro rdv/activit�s � partir de l'�num�ration des rendez-vous outlook
procedure TOutlookSync.SyncAppt;
var
   vApptItem        :variant;
   vApptUserProp    :variant;
   strGuidInRdv     :string;
   ActItem          :TOB;
   iItemCopy        :integer;
   dtApptModif      :TDateTime;
   dtActModif       :TDateTime;
   dtLastSynchro    :TDateTime;
   bApptModified    :boolean;
   bActModified     :boolean;
begin
     // On �num�re tout les appointmentitem
     vApptItem  := m_ApptItems.GetFirst;
     while IDispatch (vApptItem) <> nil do
     begin
          MoveCur (FALSE);

          // Que les �l�ments de type rendez-vous
          if vApptItem.Class = olAppointment then
          begin
               // Guid de l'activit� d�j� synchronis�e
               vApptUserProp := vApptItem.UserProperties.Find ('CEGIDEVTGUID');
               if (IDispatch (vApptUserProp) <> nil) and (vApptUserProp.Type = olText) then
                   strGuidInRdv := vApptUserProp.Value
               else
                   strGuidInRdv := '';

               // En mode outlook vers Cegid, ou bidirectionnel, on cr�er la TOB si changement ou si pas encore connue dans base Cegid
               ActItem := nil;
               if strGuidInRdv <> '' then
               begin
                    ActItem := m_ActItems.FindFirst (['JEV_GUIDEVT'], [strGuidInRdv], TRUE);

                    // $$$ JP 11/12/06: si activit� d�j� synchronis�, le rdv est (normalement) un rdv dupliqu� dans Outlook: on enl�ve le lien et on fait comme si c'�tait un rdv outlook non encore synchronis� avec une activit�
                    if (ActItem <> nil) and (ActItem.FieldExists ('SYNCHRO') = TRUE) then
                    begin
                         strGuidInRdv := '';
                         ActItem      := nil;
                    end;
               end;

               // D�termination du sens de la copie (pgi vers outlook, outlook vers pgi, dans les deux sens, ou bien rien), dans les �l�ments existants ou dans des nouveaux �l�ments si n�cessaire
               iItemCopy := ostNone;
               if ActItem = nil then
               begin
                    // Si pas d'activit� li�e � un rdv pourtant synchronis�, l'activit� � donc �t� supprim�e
                    if strGuidInRdv <> '' then
                    begin
                         case m_iSupprSolver of
                              odrKeep:
                                 // Recopie si l'h�te de destination est autoris� � recevoir un �l�ment de ce genre
                                 if (m_iTypeSync <> ostFromCegid) or (m_bSupprFull = TRUE) then
                                    iItemCopy := ostFromOutlook;

                              odrDelete:
                                 // On supprime si l'h�te de suppression est autoris� � se voir enlever un �l�ment de ce genre
                                 if (m_iTypeSync <> ostFromOutlook) or (m_bSupprFull = TRUE) then
                                    iItemCopy := ostDeleteInOutlook;
                         end;
                    end
                    else if m_iTypeSync <> ostFromCegid then
                         // Simple copie (rdv non encore li� � une activit� Pgi)
                         iItemCopy := ostFromOutlook;
               end
               else
               begin
                    // $$$ JP 12/04/07: en cwas, il faudra faire autrement, car horloge client pas = � horloge serveur:
                    // pb surtout pour rdv outlook client. Cr�er un champ de r�f�rence JEV_SYNCLOCALDATE
                    // (et aussi JEV_SYNCSERVERDATE pour remplacer JEV_DUREE non pr�vu au d�part pour �a)

                    // Activit� et rdv li�s: on regarde si l'une et/ou l'autre modifi�e depuis derni�re synchro (date de synchro r�f�rence=JEV_DUREE)
                    // (on prend une marge de latence d'une seconde, car date = virgule flottante)
                    // Il faut aussi ne pas resynchroniser des rdv/activit�s (g�n�r� lors de la cr�ation d'un rdv outlook dans une it�ration pr�c�dente)
                    // $$$ JP obligatoirement non synchronis� si on passe ici if ActItem.FieldExists ('SYNCHRO') = FALSE then
                    //begin
                    dtLastSynchro := ActItem.GetValue ('JEV_DUREE');
                    dtApptModif   := vApptItem.LastModificationTime;
                    bApptModified := Abs (dtApptModif  - dtLastSynchro) > dSecond;
                    dtActModif    := ActItem.GetValue ('JEV_DATEMODIF');
                    bActModified  := Abs (dtActModif   - dtLastSynchro) > dSecond;

                    // Selon le mode de synchro
                    case m_iTypeSync of
                         // Dans le sens unique Outlook vers Pgi, on copie le rdv dans l'activit� si ce rdv est modifi� depuis derni�re synchro
                         ostFromOutlook:
                                 if bApptModified = TRUE then
                                    iItemCopy := ostFromOutlook;

                         // Dans le sens unique Pgi vers Outlook, on copie l'activit� dans le rdv (sans se poser de question)
                         ostFromCegid:
                                 if bActModified = TRUE then
                                    iItemCopy := ostFromCegid;

                         // En synchro, on copie selon le mode de r�solution de conflit (si conflit), sinon le rdv dans l'activit�
                         ostFull:
                                 if bApptModified = TRUE then
                                 begin
                                      if bActModified = TRUE then
                                      begin
                                           // Conflit de modification (l'un ou l'autre a raison, ou bien le dernier modifi�, ou bien encore cr�ation de doublon)
                                           case m_iConflictSolver of
                                                ocrCegid:
                                                   iItemCopy := ostFromCegid;

                                                ocrOutlook:
                                                   iItemCopy := ostFromOutlook;

                                                ocrFull:
                                                   iItemCopy := ostFull;

                                                ocrMostRecent:
                                                   if dtApptModif - dtActModif > dSecond then
                                                        iItemCopy := ostFromOutlook
                                                   else if dtActModif - dtApptModif > dSecond then
                                                        iItemCopy := ostFromCegid
                                                   else
                                                        iItemCopy := ostFull;
                                           end;
                                      end
                                      else
                                          // Uniquement le rdv modifi�: on le copie dans l'activit�
                                          iItemCopy := ostFromOutlook;
                                 end
                                 else if bActModified = TRUE then
                                      // Uniquement l'activit� modifi�e: on la copie dans le rdv
                                      iItemCopy := ostFromCegid;
                    end;
                    //end
                    //else
                    //    // D�j� synchronis�: ne rien faire du tout, m�me pas marquage pour synchro
                    //    iItemCopy := ostAlready;
               end;

               // Copie des �l�ments dans un sens ou dans les deux (full)
               case iItemCopy of
                    ostNone:
                       if ActItem <> nil then
                          ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC');

                    ostFromCegid:
                       ActToAppt (ActItem, vApptItem);

                    ostFromOutlook:
                       ApptToAct (vApptItem, ActItem);

                    ostFull:
                    begin
                         ActToAppt (ActItem,   unAssigned);
                         ApptToAct (vApptItem, nil);
                    end;

                    ostDeleteInOutlook:
                    begin
                         vApptItem.Delete;
                         Inc (m_iNbSync);
                    end;
               end;
          end;

          // Element outlook suivant (normalement un rdv, mais peut �tre une t�che)
          vApptItem := m_ApptItems.GetNext;
     end;

     vApptItem := unAssigned;
end;

procedure TOutlookSync.CopyAndSaveAct;
var
   i            :integer;
   strEntryId   :string;
   strSync      :string;
   ActItem      :TOB;
   TOBEvt       :TOB;
   TOBRec       :TOB;
   TOBEvtDel    :TOB;
   TOBRecDel    :TOB;
   strSQL       :string;
begin
     // Les tob r�elles pour mise � jour de la base une fois le traitement fini
     TOBEvt    := TOB.Create ('JUEVENEMENT', nil, -1);
     TOBRec    := TOB.Create ('JUEVTRECURRENCE', nil, -1);
     if m_iTypeSync <> ostImport then
     begin
          TOBEvtDel := TOB.Create ('JUEVENEMENT', nil, -1);
          TOBRecDel := TOB.Create ('JUEVTRECURRENCE', nil, -1);
     end;

     // On ne synchronise que les �l�ments non encore synchronis� dans la phase 1 (les nouvelles activit�s, ou celles d�j� synchronis�es, mais supprim�es dans outlook et pas dans PGI)
     for i := 0 to m_ActItems.Detail.Count - 1 do
     begin
          MoveCur (FALSE);

          // L'activit� � synchroniser
          ActItem := m_ActItems.Detail [i];

          // Synchro de cette activit� si pas d�j� fait
          if ActItem.FieldExists ('SYNCHRO') = FALSE then
          begin
               strEntryId := ActItem.GetValue ('JEV_FOREIGNID');
               if strEntryId <> '' then
               begin
                    // S'il y a un identifiant outlook et que ce rdv outlook n'a pas �t� trait� dans phase 1, c'est qu'il n'existe plus dans outlook: on le supprime ou le garde selon ce qui est sp�cifi�
                    case m_iSupprSolver of
                         odrKeep:
                            // Recopie si l'h�te de destination est autoris� � recevoir un �l�ment de ce genre
                            if (m_iTypeSync <> ostFromOutlook) or (m_bSupprFull = TRUE) then
                                 ActToAppt (ActItem, unAssigned)
                            else
                                 ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC'); // � priori inutile (car getvalue d'un champ inexistant renvoie '')

                         odrDelete:
                            // On marque pour suppression si l'h�te de suppression est autoris� � se voir enlever un �l�ment de ce genre
                            if (m_iTypeSync <> ostFromCegid) or (m_bSupprFull = TRUE) then
                            begin
                                 ActItem.AddChampSupValeur ('SYNCHRO', 'DELETED');
                                 Inc (m_iNbSync);
                            end
                            else
                                ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC'); // � priori inutile (car getvalue d'un champ inexistant renvoie '')

                         odrNone:
                            ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC'); // � priori inutile (car getvalue d'un champ inexistant renvoie '')
                    end;
               end
               // Sinon, on copie l'activit� dans un nouveau rdv outlook (si outlook "r�cepteur" d'�l�ment)
               else if m_iTypeSync <> ostFromOutlook then
                    ActToAppt (ActItem, unAssigned)
               else
                    ActItem.AddChampSupValeur ('SYNCHRO', 'NOSYNC'); // � priori inutile
          end;

          // Si activit� synchronis�e (dans la phase 1 ou 2), on la copie dans la TOB des �l�ments � enregistrer
          strSync := ActItem.GetValue ('SYNCHRO');
          if strSync = 'SYNC' then
          begin
               with TOB.Create ('JUEVENEMENT', TOBEvt, -1) do
               begin
                    InitValeurs;
                    PutValue ('JEV_GUIDEVT',      ActItem.GetValue ('JEV_GUIDEVT'));
                    PutValue ('JEV_USER1',        V_PGI.User);
                    PutValue ('JEV_GUIDPER',      ActItem.GetValue ('JEV_GUIDPER'));
                    PutValue ('JEV_NODOSSIER',    ActItem.GetValue ('JEV_NODOSSIER'));
                    PutValue ('JEV_AFFAIRE',      ActItem.GetValue ('JEV_AFFAIRE'));
                    PutValue ('JEV_FAMEVT',       'ACT');
                    PutValue ('JEV_CODEEVT',      ActItem.GetValue ('JEV_CODEEVT'));
                    PutValue ('JEV_EXTERNE',      ActItem.GetValue ('JEV_EXTERNE'));
                    PutValue ('JEV_ABSENCE',      ActItem.GetValue ('JEV_ABSENCE'));
                    PutValue ('JEV_PERS',         ActItem.GetValue ('JEV_PERS'));
                    PutValue ('JEV_DATE',         ActItem.GetValue ('JEV_DATE'));
                    PutValue ('JEV_DATEFIN',      ActItem.GetValue ('JEV_DATEFIN'));
                    PutValue ('JEV_EVTLIBELLE',   ActItem.GetValue ('JEV_EVTLIBELLE'));
                    PutValue ('JEV_LIEU',         ActItem.GetValue ('JEV_LIEU'));
                    PutValue ('JEV_ALERTE',       ActItem.GetValue ('JEV_ALERTE'));
                    PutValue ('JEV_ALERTEDATE',   ActItem.GetValue ('JEV_ALERTEDATE'));
                    PutValue ('JEV_OCCURENCEEVT', ActItem.GetValue ('JEV_OCCURENCEEVT'));
                    if m_iTypeSync <> ostImport then
                    begin
                         PutValue ('JEV_FOREIGNID',    ActItem.GetValue ('JEV_FOREIGNID'));
                         PutValue ('JEV_FOREIGNAPP',   ActItem.GetValue ('JEV_FOREIGNAPP'));
                         PutValue ('JEV_DUREE',        ActItem.GetValue ('JEV_DUREE'));
                    end;

                    // La date de modification doit �tre exactement la m�me que celle du rdv outlook, donc on la sp�cifie nous-m�me
                    // $$$ JP 12/04/07: pb en eagl (peut �tre aussi 2/3): date modification souhait�e �cras�e lors de la m�j de la tob!
                    // On fait autrement: maj des datemodif par UPDATE (apr�s l'insertorupdatedb) sur tous les �l�ments de la tob
                    //SetDateModif (ActItem.GetValue ('JEV_DUREE'));

                    // $$$ JP 11/12/06: il faut consid�rer que tous les champs sont modifi�s (puisqu'on ne s'est pas fond� sur l'enreg �ventuellement existant)
                    SetAllModifie (TRUE);
                    // FQ 12002 : Sauf le champ JEV_NOTEEVT qui doit �tre conserv�
                    SetModifieField('JEV_NOTEEVT', False);
               end;

               // Gestion de la r�currence de l'activit�
               if ActItem.GetValue ('JEV_OCCURENCEEVT') = 'REC' then
               begin
                    with TOB.Create ('JUEVTRECURRENCE', TOBRec, -1) do
                    begin
                         InitValeurs;
                         PutValue ('JEC_GUIDEVT',         ActItem.GetValue ('JEC_GUIDEVT'));
                         PutValue ('JEC_RECURNUM',        ActItem.GetValue ('JEC_RECURNUM')); // Pour l'instant, une seule r�currence possible
                         PutValue ('JEC_INTERVALLE',      ActItem.GetValue ('JEC_INTERVALLE'));
                         PutValue ('JEC_START',           ActItem.GetValue ('JEC_START'));
                         PutValue ('JEC_END',             ActItem.GetValue ('JEC_END'));
                         PutValue ('JEC_NBOCCURRENCE',    ActItem.GetValue ('JEC_NBOCCURRENCE'));
                         PutValue ('JEC_RECURRENCETYPE',  ActItem.GetValue ('JEC_RECURRENCETYPE'));
                         PutValue ('JEC_WEEKDAYS',        ActItem.GetValue ('JEC_WEEKDAYS'));
                         PutValue ('JEC_DAYOFMONTH',      ActItem.GetValue ('JEC_DAYOFMONTH'));
                         PutValue ('JEC_WEEKOFMONTH',     ActItem.GetValue ('JEC_WEEKOFMONTH'));
                         PutValue ('JEC_MONTHOFYEAR',     ActItem.GetValue ('JEC_MONTHOFYEAR'));

                         // $$$ JP 11/12/06: il faut consid�rer que tous les champs sont modifi�s (puisqu'on ne s'est pas fond� sur l'enreg �ventuellement existant)
                         SetAllModifie (TRUE);
                    end;
               end
               else if (m_iTypeSync <> ostImport) and (ActItem.GetValue ('JEC_GUIDEVT') <> '') then
               begin
                    // $$$ JP 30/10/06: si pas de r�currence, il faut supprimer l'�ventuelle r�currence existante
                    with TOB.Create ('JUEVTRECURRENCE', TOBRecDel, -1) do
                    begin
                         InitValeurs;
                         PutValue ('JEC_GUIDEVT',  ActItem.GetValue ('JEC_GUIDEVT'));
                         PutValue ('JEC_RECURNUM', ActItem.GetValue ('JEC_RECURNUM'));
                    end;
               end;
          end
          else if (m_iTypeSync <> ostImport) and (strSync = 'DELETED') then
          begin
               with TOB.Create ('JUEVENEMENT', TOBEvtDel, -1) do
               begin
                    InitValeurs;
                    PutValue ('JEV_GUIDEVT', ActItem.GetValue ('JEV_GUIDEVT'));
               end;

               if ActItem.GetValue ('JEV_OCCURENCEEVT') = 'REC' then
               begin
                    with TOB.Create ('JUEVTRECURRENCE', TOBRecDel, -1) do
                    begin
                         InitValeurs;
                         PutValue ('JEC_GUIDEVT',  ActItem.GetValue ('JEC_GUIDEVT'));
                         PutValue ('JEC_RECURNUM', ActItem.GetValue ('JEC_RECURNUM')); // Pour l'instant, une seule r�currence possible
                    end;
               end;
          end;
     end;

     // On enregistre les activit�s (et r�currence d'activit�)
     BeginTrans;
     try
        // Les activit�s supprim�es
        if m_iTypeSync <> ostImport then
        begin
             for i := 0 to TOBEvtDel.Detail.Count - 1 do
                 TOBEvtDel.Detail [i].DeleteDB;
             for i := 0 to TOBRecDel.Detail.Count - 1 do
                 TOBRecDel.Detail [i].DeleteDB;
        end;

        // Les activit�s mises � jour ou ajout�es
        // Les activit�s mises � jour ou ajout�es
        if TOBEvt.Detail.Count > 0 then
        begin
             // $$$ JP 12/04/07: pas le choix, pour fixer sa propre datemodif (en eagl), faut passer par executesql
             if TOBEvt.InsertOrUpdateDB = TRUE then
             begin
                  strSQL := 'UPDATE JUEVENEMENT SET JEV_DATEMODIF=JEV_DUREE WHERE JEV_GUIDEVT IN ("';
                  for i := 0 to TOBEvt.Detail.Count - 1 do
                  begin
                       if i > 0 then
                          strSQL := strSQL + '","';
                       strSQL := strSQL + TOBEvt.Detail [i].GetValue ('JEV_GUIDEVT');
                  end;
                  strSQL := strSQL + '")';
                  TOBEvt.ClearDetail; // On sait jamais
                  ExecuteSQL (strSQL);
             end;
             // $$$ JP 12/04/07 fin
        end;

        // Les r�currences
        if TOBRec.Detail.Count > 0 then
           TOBRec.InsertOrUpdateDB;

        // Transaction termin�e
        CommitTrans;
     except
           RollBack;
     end;

     if m_iTypeSync <> ostImport then
     begin
          TOBRecDel.Free;
          TOBEvtDel.Free;
     end;
     TOBRec.Free;
     TOBEvt.Free;
end;

procedure TOutlookSync.DesyncAppt;
var
   vApptItem        :variant;
   vApptUserProp    :variant;
   bDesync          :boolean;
begin
     try
        vApptItem  := m_ApptItems.GetFirst;
        while IDispatch (vApptItem) <> nil do
        begin
             MoveCur (FALSE);

             // Que les �l�ments de type rendez-vous
             if vApptItem.Class = olAppointment then
             begin
                  // Pour savoir si une d�synchro a �t� effectu�e (bien que normalement si CEGIDBASEGUID est pr�sent, CEGIDEVTGUID aussi)
                  bDesync := FALSE;

                  // On enl�ve le Guid de la base de l'activit� d�j� synchronis�e, et le guid de l'activit�
                  vApptUserProp := vApptItem.UserProperties.Find ('CEGIDBASEGUID');
                  if IDispatch (vApptUserProp) <> nil then
                  begin
                       vApptUserProp.Delete;
                       bDesync := TRUE;
                  end;

                  // Guid de l'activit� d�j� synchronis�e
                  vApptUserProp := vApptItem.UserProperties.Find ('CEGIDEVTGUID');
                  if IDispatch (vApptUserProp) <> nil then
                  begin
                       vApptUserProp.Delete;
                       bDesync := TRUE;
                  end;

                  // Si modif' faite, on enregistre le rdv (et on m�j le compteur)
                  if bDesync = TRUE then
                  begin
                       vApptItem.Save;
                       Inc (m_iNbSync);
                  end;
             end;

             // Element outlook suivant (normalement un rdv, mais peut �tre une t�che)
             vApptItem := m_ApptItems.GetNext;
        end;
     finally
            vApptUserProp := unAssigned;
            vApptItem     := unAssigned;
     end;
end;

procedure TOutlookSync.DesyncAct;
begin
     // On enl�ve toute r�f�rence de synchro vers outlook dans la table des activit�s
     m_iNbSync := m_iNbSync + ExecuteSQL ('UPDATE JUEVENEMENT SET JEV_FOREIGNID="",JEV_FOREIGNAPP="" WHERE (JEV_FOREIGNID<>"") OR (JEV_FOREIGNAPP="OUT")');

     // Il faut enlever la r�f�rence vers le calendrier Outlook
     ExecuteSQL ('DELETE CHOIXEXT WHERE YX_TYPE="SYA" AND YX_TYPE="OUT"');
end;

procedure TOutlookSync.CreateOutlookEvtCode;
var
   TOBCodeEvt  :TOB;
   i, iPos     :integer;
   strCodes    :string;
   strCode     :string;
begin
     strCodes := 'OUTEXT;OUTINT;OUTABS;';
     TOBCodeEvt := TOB.Create ('code evt', nil, -1);
     TOBCodeEvt.LoadDetailFromSQL ('SELECT JTE_CODEEVT FROM JUTYPEEVT WHERE JTE_CODEEVT IN ("OUTEXT","OUTINT","OUTABS")');
     for i := 0 to TOBCodeEvt.Detail.Count - 1 do
     begin
          strCode := TOBCodeEvt.Detail [i].GetString ('JTE_CODEEVT');
          iPos := Pos (strCode, strCodes);
          if iPos > 0 then
             Delete (strCodes, iPos, 7);
     end;
     TOBCodeEvt.Free;

     strCode := Trim (ReadTokenST (strCodes));
     while strCode <> '' do
     begin
          with TOB.Create ('JUTYPEEVT', nil, -1) do
          begin
               InitValeurs;
               PutValue ('JTE_CODEEVT',      strCode);
               PutValue ('JTE_FAMEVT',       'ACT');
               PutValue ('JTE_EVTLIBELLE',   'Rendez-vous de Microsoft Outlook');
               PutValue ('JTE_EVTLIBABREGE', 'Rdv Ms-Outlook');
               PutValue ('JTE_VERSION',      1);
               if strCode = 'OUTEXT' then
                   PutValue ('JTE_EXTERNE',  'X')
               else
                   PutValue ('JTE_EXTERNE',  '-');
               if strCode = 'OUTABS' then
                   PutValue ('JTE_ABSENCE',  'X')
               else
                   PutValue ('JTE_ABSENCE',  '-');
               PutValue ('JTE_PREDEFINI',    'CEG');
               InsertDB (nil);
               Free;
          end;

          strCode := Trim (ReadTokenST (strCodes));
     end;
end;

function TOutlookSync.DoSync:integer; // renvoie le nb de rdv synchronis�s, ou -1 si erreur
var
   strReq         :string;
   strValue       :string;
   vOutlook       :variant;
   vMapi          :variant;
   vCalFolder     :variant;
   vSyncItem      :variant;
   vUserProp      :variant;
begin
     // Par d�faut, aucune synchronisation effectu�e
     m_iNbSync := 0;

     // Si mode de synchro sur none, on fait rien
     if (m_iTypeSync = ostNone) or (m_iTypeSync = ostImport) then
        exit;

     // En mode d�-synchronisation, pas la peine de v�rifier guid base en cours, ni type d'�v�nement
     if m_iTypeSync <> ostDesynchro then
     begin
          // Identifiant de la base Cegid contenant les activit�s
          if m_strGuidBase = '' then
          begin
               PgiInfo ('Synchronisation impossible avec Outlook: l''identifiant de la base commune n''est pas initialis�');
               exit;
          end;

          // Avant tout, il faut cr�er un type d'activit� sp�cifique pour import Outlook (comme pour synchro pda)
          CreateOutlookEvtCode;
     end;

     SourisSablier;
     try
        // Chargement de toutes les activit�s d�j� synchro, et les nouvelles si elles sont dans les crit�res d�finis (date d�but, recurrence...)
        m_ActItems := TOB.Create ('les activit�s', nil, -1);
        strReq := 'SELECT * FROM JUEVENEMENT LEFT JOIN JUEVTRECURRENCE ON (JEV_GUIDEVT=JEC_GUIDEVT AND JEC_RECURNUM=1) WHERE JEV_FAMEVT="ACT" ';
        strReq := strReq + 'AND JEV_DOMAINEACT<>"JUR" AND JEV_USER1="' + V_PGI.User + '" ';
        strReq := strReq + 'AND (JEV_FOREIGNID="" OR JEV_FOREIGNAPP="OUT") ';
        strReq := strReq + 'ORDER BY JEV_FOREIGNID,JEV_DATE';
        m_ActItems.LoadDetailFromSQL (strReq);

        // Chargement des rendez-vous Outlook
        vOutlook := CreateOleObject ('Outlook.Application');
        if IDispatch (vOutlook) <> nil then
        begin
             // Ok, on se positionne sur le folder du calendrier par d�faut et on r�cup�re les rendez-vous synchronisable
             vMapi := vOutlook.GetNamespace ('MAPI');
             if IDispatch (vMapi) <> nil then
             begin
                  vCalFolder := vMapi.GetDefaultFolder (olFolderCalendar);
                  if IDispatch (vCalFolder) <> nil then
                  begin
                       // $$$ JP 03/11/06: on doit connaitre l'identifiant de stockage du calendrier outlook
                       m_strGuidOutlook := VOutlook.ProductCode; //vCalFolder.StoreId;

                       // LEs rdv outlook � synchroniser (peut contenir des �l�ments autre que des rdv, seront filtrer lors de la synchro)
                       m_ApptItems := vCalFolder.Items; // $$$ JP pour l'instant pas de restriction... Restrict ('[ResponseStatus] >= 0 And [ResponseStatus] <= 3');
                  end;
             end;
        end;

        // Quelques v�rifications
        if ( (IDispatch (m_ApptItems) = nil) or (m_ApptItems.Count = 0)) and (m_ActItems.Detail.Count = 0) then
           exit;

        // V�rification de la coh�rence de synchro (si d�j� fait), sauf en mode d�synchro
        if m_iTypeSync <> ostDesynchro then
        begin
             // $$$ JP 03/11/06: Pgi doit avoir CE calendrier Outlook comme r�f�rence de synchro (si d�j� synchronis� avec Outlook)
             strValue := '';
             with TOB.Create ('le calendrier outlook', nil, -1) do
             begin
                  LoadDetailFromSQL ('SELECT YX_LIBELLE FROM CHOIXEXT WHERE YX_TYPE="SYA" AND YX_CODE="OUT"');
                  if Detail.Count > 0 then
                      strValue := Detail [0].GetValue ('YX_LIBELLE')
                  else
                      strValue := '';
                  Free;
             end;
             if (strValue <> '') and (strValue <> m_strGuidOutlook) then
             begin
                  // Si pas CE calendrier Outlook, on peut le remplacer, mais avec double confirmation
                  if PgiAsk ('L''agenda Expert est d�j� synchronis� avec un autre calendrier Outlook.'#10' D�sirez-vous tout de m�me faire la synchronisation avec ce calendrier Outlook?') <> mrYes then
                     exit;
                  if PgiAsk ('Deuxi�me confirmation:'#10#10' Ce calendrier Outlook deviendra le calendrier de r�f�rence pour la synchronisation'#10' Confirmez-vous la synchronisation avec ce calendrier Outlook?') <> mrYes then
                     exit;

                  // Ok, on prend cette r�f�rence de calendrier outlook comme r�f�rence de synchro
                  // $$$ JP 12/04/07: non, il faut justement conserver ce nouvel identifiant Outlook pour la synchro qui s'annonce
                  // m_strGuidOutlook := strValue;
             end;

             // $$$ JP 03/11/06: Outlook doit avoir CET agenda Expert comme r�f�rence de synchro (si d�j� synchronis� avec Cegid Expert)
             strValue  := '';
             try
                vSyncItem := m_ApptItems.Find ('[CEGIDBASEGUID] <> "" and [CEGIDBASEGUID] <> "' + m_strGuidBase + '"'); // $$$ JP 12/04/07: chercher s'il y en a au moins un diff�rent //Find ('[CEGIDBASEGUID] <> ""');

                if IDispatch (vSyncItem) <> nil then
                begin
                     vUserProp := vSyncItem.UserProperties.Find ('CEGIDBASEGUID');
                     if IDispatch (vUserProp) <> nil then
                     begin
                          strValue := vUserProp.Value;
                          vUserProp := unAssigned;
                     end;
                     vSyncItem := unAssigned;
                end;
             except
                   strValue := '';
             end;
             if (strValue <> '') and (strValue <> m_strGuidBase) then
             begin
                  if PgiAsk ('Certains rendez-vous Outlook sont d�j� synchronis�s avec un autre agenda Expert.'#10' D�sirez-vous tout de m�me faire une synchronisation avec ce calendrier Outlook?') <> mrYes then
                     exit;
                  if PgiAsk ('Deuxi�me confirmation:'#10#10' Certains rendez-vous Outlook sont d�j� synchronis�s avec un autre agenda Expert.'#10' Confirmez-vous la synchronisation avec ce calendrier Outlook?') <> mrYes then
                     exit;

                  // $$$ JP 12/04/07: non, il faut justement conserver ce nouvel identifiant Cegid pour la synchro qui s'annonce
                  //m_strGuidBase := strValue;
             end;

             // Nombre d'�l�ments � synchronis�: �tape
             InitMove (m_ApptItems.Count + m_ActItems.Detail.Count, '');

             // 1�re passe: synchro � partir des rendez-vous d'Outlook (en marquant les activit�s qui seront synchronis�es pour ne pas le refaire en phase 2)
             SyncAppt;

             // 2�me passe: recopie des activit�s non synchronis�es (car nouvelles dans outlook), et mise � jour base pgi des activit�s synchronis�es
             CopyAndSaveAct;

             // On enregistre l'id du calendrier Outlook utilis� pour la synchro, si y'a bien eu une synchro
             if m_iNbSync > 0 then
             begin
                  with TOB.Create ('CHOIXEXT', nil, -1) do
                  begin
                       InitValeurs;
                       PutValue ('YX_TYPE',    'SYA');
                       PutValue ('YX_CODE',    'OUT');
                       PutValue ('YX_LIBELLE', m_strGuidOutlook);

                       InsertOrUpdateDB;
                       Free;
                  end;
             end;
        end
        else
        begin
             // 1�re passe: on d�-synchronise les rdv outlook
             DesyncAppt;

             // 2�me passe: on d�-synchronise les activit� Expert
             DesyncAct;
        end;
     finally
            FiniMove;
            SourisNormale;
            Result       := m_iNbSync;
            m_ApptItems  := unAssigned;
            vCalFolder   := unAssigned;
            vMapi        := unAssigned;
            vOutlook     := unAssigned;
            m_ActItems.Free;
     end;
end;

function TOutlookSync.DoImport:integer;
var
   i, iIndex  :integer;
   vOutlook   :variant;
   vExplorer  :variant;
   vApptItem  :variant;
   bRecurring :boolean;
   strEntry   :string;
   RecList    :TStringList;
begin
     // Par d�faut, pas de rendez-vous import�s
     Result := 0;

     // Si mode de synchro sur none, on fait rien
     if m_iTypeSync <> ostImport then
        exit;

     SourisSablier;
     try
        // Avant tout, il faut cr�er un type d'activit� sp�cifique pour import Outlook (comme pour synchro pda)
        CreateOutlookEvtCode;

        // On construit la TOB destin�e � recevoir les nouveaux �l�ments
        m_ActItems := TOB.Create ('les activit�s', nil, -1);

        // Enum�ration rdv s�lectionn�s pour copie dans l'agenda Expert
        vOutlook := CreateOleObject ('Outlook.Application');
        if IDispatch (vOutlook) <> nil then
        begin
             vExplorer := vOutlook.ActiveExplorer;
             if IDispatch (vExplorer) <> nil then
             begin
                  m_ApptItems := vExplorer.Selection;
                  if IDispatch (m_ApptItems) <> nil then
                  begin
                       if m_ApptItems.Count < 1 then
                          exit;

                       // Liste des rdv r�p�tables d�j� trait� (pour �viter d'importer x fois le m�me)
                       RecList            := TStringList.Create;
                       RecList.Sorted     := TRUE;
                       RecList.Duplicates := dupIgnore;

                       // Copie des rdv dans une nouvelle activit�
                       try
                          // Nombre d'�l�ments � synchronis�: �tape
                          InitMove (m_ApptItems.Count, '');

                          for i := 1 to m_ApptItems.Count do
                          begin
                               // Element pas forc�ment un rdv
                               vApptItem := m_ApptItems.Item (i);
                               if IDispatch (vApptItem) <> nil then
                               begin
                                    // Alimentation de la TOB des activit�s � enregistrer
                                    if (vApptItem.Class = olAppointment) then
                                    begin
                                         bRecurring := vApptItem.IsRecurring;
                                         strEntry   := vApptItem.EntryId;
                                         if (bRecurring = FALSE) or (RecList.Find (strEntry, iIndex) = FALSE) then
                                            if (ApptToAct (vApptItem, nil) <> nil) and (bRecurring = TRUE) then
                                               RecList.Add (strEntry);
                                    end;
                               end;
                          end;

                          // Enregistrement des activit�s g�n�r�es
                          CopyAndSaveAct;
                       finally
                              RecList.Free;
                       end;
                  end;
             end;
        end;
     finally
            FiniMove;
            SourisNormale;
            Result       := m_iNbSync;
            m_ApptItems  := unAssigned;
            vExplorer    := unAssigned;
            vOutlook     := unAssigned;
            m_ActItems.Free;
     end;
end;


end.
