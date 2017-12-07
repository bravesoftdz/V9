{***********UNITE*************************************************
Auteur  ...... : MC DESSEIGNET

Cr�� le ...... : 18/01/2007
Modifi� le ... :
Description .. : Focntions utilis�es pour l'automatisation Comsx
                : fortement inspir� des fct correspodnante de UtilIntercompta de mode
Mots clefs ... : Comsx
*****************************************************************}
unit UtilLienComsx;

interface
                                       
uses
  Forms,
  HEnt1,
  Windows,
  CbpPath,
  CbpInifiles,
  Classes,
  IniFiles,
  HCtrls,
{$IFNDEF EAGLCLIENT}
  DB,
{$IFNDEF DBXPRESS}dbtables {BDE},{$ELSE}uDbxDataSet, {$ENDIF}
{$else}
  uHttp,
{$ENDIF}
  SysUtils,
  ParamSoc,
  LicUtil,
  UTOB
 ;

const
  ChCodeCpta    = 'CODECPTA';
  ChSeqDateDeb  = 'SEQDATEDEB';
  ChSeqDateFin  = 'SEQDATEFIN';
  ChSociete     = 'SOCIETE';
  ChCaptionEcr = 'DEJAEXTRAIT.Caption';
  ChJournalEvent = 'JOURNALEVENT';




Var
  // TOB Entete du transfert comptable
  TOBEnteteLienComsx : TOB;
  // Bloc notes
  ZBlocNotes : TStringList ;
  // Ex�cution totale ou par �tape
  ExecutionTotal : Boolean ;

Type
  TTypeTacheInterCpta = (  icPlanifie,  icExport, icImport, icNull );

function NomDuFichierExport( NomFichier : string; var DateFile: string ): string;
procedure TransfertCompta( var LastErr : Integer;
                          const sEtablissmt,  DateDeb, DateFin,
                          DateFile, EtatCompta, BaseCompta, FichierEcr, sEcritures: string;
                          var TrtOk, GenerationFileOk: Boolean;
                          bEcritures, ComptaExterne: Boolean;
                          TacheSuivante : TTypeTacheInterCpta; BlocNotes : TStringList = nil) ;

procedure PSTransfertCompta( RequestTOB, ResultTOB: TOB );
procedure MajJournalEvent ( sMessage : String;  LastError : Integer );
procedure MAJStatutTache (TOBEntete : TOB; Statut : String; Tache : TTypeTacheInterCpta ) ;
procedure MAJBlocNoteTache ( Debut,TacheOk : Boolean; Tache : TTypeTacheInterCpta ) ;
procedure MAJBlocNote (sMessage : String; NumErreur : integer = 0 )  ;
function QuelleTacheSuivante : TTypeTacheInterCpta ;
function ComsxSetLastError( var Num: integer; LibEcran : String = '' ) : String ;
function ControleParametrageExport( RepertoireFichier, RepertoireComSx : String) : integer ;


implementation

uses
 {$IFDEF EAGLSERVER}
  eSession, 
  {$ENDIF}
 HMsgBox;

  // libell�s des messages
Const   TexteMessage: array[1..24] of string = (
    {1} 'Veuillez confirmer la comptabilisation des �critures d�j� extraites.'
    {2}, 'Le traitement ne s''est pas termin� correctement.'
    {3}, 'Transfert comptable'
    {4}, 'Aucune information n''est disponible,vous devez relancer la t�che de chargement.'
    {5}, 'Transfert termin�'
    {6}, 'Rapport de fin : '
    {7}, 'L''�tape "%s" est termin�e.'
    {8}, 'L''�tape "%s" ne s''est pas termin�e correctement.'
    {9}, 'Vous devez relancer cette �tape.'
    {10}, 'T�che termin�e.'
    {11}, 'Vous devez l''installer l''ex�cutable COMSX, il n''est pas pr�sent dans le r�pertoire : '
    {12}, 'Le r�pertoire d''export n''existe pas : '
    {13}, 'Export OK.'
    {14}, 'Probl�me lors de l''export.'
    {15}, 'Import suite export OK.'
    {16}, 'Probl�me lors de l''import (suite export). '
    {17}, 'Le r�pertoire d''export n''est pas param�tr�.'
    {18}, 'Import OK.'
    {19}, 'Probl�me lors de l''import '
    {20}, 'Vous devez l''installer l''ex�cutable eCOMSX, il n''est pas pr�sent dans le r�pertoire : '
    {21}, 'Renseignez le param�trage dans Param�tres->Documents->Documents->Natures Onglet G�n�ralit� :le champ "�quivalence" = FFO".'
    {22}, 'Vous devez le renseigner dans les param�tres soci�t�s->gestion commerciale->Passation comptable->R�pertoire d''export.'
    {23}, 'V�rifier dans CEGIDPGI.INI de la COMSX que la soci�t� suivante existe : '
    {24}, 'Voir le fichier .err pour plus d''informations,ainsi que le journal des �v�nements.'
    );
   // libell�s des taches
  LibTache: array[1..3] of string = (
    {1} 'Export des �critures'
    {2}, 'Transfert comptable'
    {3}, 'Import des �critures'
    ) ;

{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 18/01/2007
Modifi� le ... :   /  /
Description .. : Modifie le journal d'evenement et affiche les messages de
Suite ........ : fin ou d'erreur
Mots clefs ... :
*****************************************************************}
Procedure MajJournalEvent ( sMessage : String ;  LastError : Integer );
Var
  MsgJournal, MsgResume, Statut : String;
begin
    if ( LastError = 1 ) or ( LastError = 3 )
      or ( LastError = 4 ) or ( LastError = 15 )   then
    begin
      MsgJournal := #13#10 + sMessage ;
      MsgResume :=  TexteMessage[ 2 ]  ;
      Statut := 'ERR' ;
    end
    else
    begin
      MsgJournal := sMessage ;
      if LastError = 0 then
      begin
        MsgResume := TexteMessage[5 ]  ;
      end else
        MsgResume := TexteMessage[ 10 ]  ;
      Statut := 'OK' ;
      MsgJournal := #13#10 + TexteMessage [6] + #13#10  + MsgJournal;
    end ;
  ZBlocNotes.add( MsgJournal);
end ;


function LanceTraitement( LigneDeCommande: string ): Boolean;
var
  TSI: TStartupInfo;
  TPI: TProcessInformation;
begin
  FillChar( TSI, SizeOf( TStartupInfo ), 0 );
  TSI.cb := SizeOf( TStartupInfo );
  Result := CreateProcess( nil, PCHAR( LigneDeCommande ), nil, nil, False,
                           CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, TSI, TPI );
  if( Result ) then
  begin
    while( WaitForSingleObject(Tpi.hProcess, 1000) <> WAIT_OBJECT_0 ) do
    begin
      if( WaitForSingleObject(Tpi.hProcess, 1000) = WAIT_OBJECT_0 ) then
        Break;
      Application.ProcessMessages;
    end;
    CloseHandle( TPI.hProcess );
    CloseHandle( TPI.hThread );
  end;
end;

function GenereFile( const FichierEcr, DateDeb, DateFin, DateFile,Etablis: string;
                      var GenerationFileOk: Boolean; BlocNotes : TStringList = nil ) : Boolean ;
var
  Command, EMail, PathFile, Societe, User, GestionEtab,
  TypeEcrRecup, TypeEcrGen, FichierTiers, Journal, FichierRapport,
  NatureTransfert, TransfertVers, Format, PathComSx, Exclure: string;
  Fileini, Action, NomFichier: string;
  FichierIni: textfile;
  NumErreur,ii : Integer;
  PwdTraitmtlot, UserTraitmtlot : String ;
  Q : TQuery ;
  {$IFDEF EAGL}
  NameServer : String ;
  {$ENDIF}
  
  procedure ErreurParam( Champ, Msg: string );
  begin
    if ( Assigned( BlocNotes ) ) then
    begin
      if ( Champ = '' ) then
        Champ := 'MANQUANT';
      BlocNotes.Add( Msg + Champ );
    end;
  end;

  function HGetComputerName: string;
  var
    S: array[0..255] of char;
    i: {$IFNDEF VER110}LongWord{$ELSE}Integer{$ENDIF};
  begin
    i := sizeof(s);
    GetComputerName(@s, i);
    Result := StrPas(s);
  end;

begin
  Result := False ;
  //Tache Export d'ecritures En cours
  MAJStatutTache (TobEnteteLienCOmsx, 'ENC' , icExport) ;
  // Mise � jour bloc notes de la tache D�but
  MAJBlocNoteTache ( True, False, icExport ) ;
  Try
    GenerationFileOk := False;
    // Type de fichier g�n�r�
    NatureTransfert := TobEnteteLienCOmsx.getvalue('YLO_NATURETRANS');   //JRL ou BAL
    // Transfert vers
(* 12/11/2005: dans un 1er temps, uniquement S5 permis ,paramsoc pas visible
    if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S5' then
      TransfertVers := 'S5'
    else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S1' then
      TransfertVers := 'S1'
    else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SIS' then
      TransfertVers := 'SISCO'
    else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SAG' then
      TransfertVers := 'SAGE'
    else TransfertVers := 'S5';  *)
    TransfertVers := 'S5';  //uniquement cette option au 12/11/2007
    If NatureTRansfert='JRL' then
    begin // Toujour format �tendu
      Format := 'ETE';
      Exclure:='[PARAM;EXO;';     //les param�tre ne sont pas passer via COMSX
      if TobEnteteLienCOmsx.getvalue('YLO_TRAMODEREGL')<>'X' then
       Exclure:=Exclure + 'MDP;MDR;REG;DEV;';   //Mode r�glement
       //  fait aussi dans mode ,mais mis dans COMSX ??? [SOU;SAT;SSA]' );
      Exclure:= Exclure + ']';
    end
    else begin
      Format := 'STD';
      Exclure:='';
    end;
    PathFile := GetParamSocSecur( 'SO_MBOCHEMINCOMPTA', '' );
    PathComSx := TcbpPath.GetCegidDistriApp ;
    if copy( PathComSx, length( PathComSx ), 1 ) <> '\' then
      PathComSx := PathComSx + '\';
    // Controle du param�trage pour l'export
    NumErreur := ControleParametrageExport( PathFile, PathComSx ) ;
    if NumErreur <> 0 then
    begin
      if NumErreur = 12 then
        MAJBlocNote (PathFile, NumErreur)
    else
        MAJBlocNote (PathComSx, NumErreur) ;
    GenerationFileOk := False ;
    exit ;
    end ;
    if copy( PathFile, length( Pathfile ), 1 ) <> '\' then
      PathFile := PathFile + '\';
    NomFichier := PathFile + FichierEcr ;
    if not (V_PGI.RunFromLanceur) then
        Societe := V_PGI.CurrentAlias //Soci�t� courante
{$ifdef EAGLCLIENT}  //� priori en CWAS il ya le @ et pas en 2/3 !!!!
    else Societe := V_PGI.CurrentAlias ;
{$else}
  {$ifndef EAGLSERVER}
    else Societe := V_PGI.CurrentAlias +'@'+V_PGI.DEfaultSectionName;
  {$else}
    else Societe := V_PGI.CurrentAlias +'@'+LookUpCurrentSession.DEfaultSectionName;
  {$endif}
{$endif}
    User := V_PGI.UserLogin; //User courant
    EMail := ''; //Envoie rapport apr�s traitement
    GestionEtab := 'TRUE'; // toujours prise en compte de l'�tablissement de l'�criture
    TypeEcrRecup := 'N';
    TypeEcrGen := 'N'; //copy(GetInfoParPiece(Nature, 'GPP_TYPEECRCPTA'), 1, 1);
    Journal := '[' + GetParamSocSecur( 'SO_EXPJRNX', '' ) + ']'; // Journal d'�criture g�n�r�
    ii:= Pos ( '-', FichierEcr);
    if II > 0 then FichierRapport:= Copy (FichierEcr,1,ii-1 )
    else FichierRapport:='';
    FichierRapport := FichierRapport +'-'+ DateFile + '-RAPPORT.TXT'; //Nom du fichier d'export
    //Test si pb
    if ( Societe = '' ) or ( User = '' ) or ( PathFile = '' ) or ( GestionEtab = '' ) or //or (FichierTiers = '')
       ( FichierEcr = '' ) or ( DateDeb = '' ) or ( DateFin = '' ) or ( TypeEcrGen = '' ) or ( FichierRapport = '' ) then
    begin
      if( Assigned( BlocNotes ) ) then
      begin
        BlocNotes.Add( '***** ' + TraduireMemoire( 'TRAITEMENT ANNULE ' ) + '***************************************************' );
        BlocNotes.Add( '***** ' + TraduireMemoire( 'ERREUR DANS LES PARAMETRES ' ) + '******************************************' );
      end;
    ErreurParam( Societe, TraduireMemoire( 'Nom de la base           : ' ) );
    ErreurParam( User, TraduireMemoire( 'Utilisateur              : ' ) );
    if( GestionEtab = 'TRUE' ) then
      ErreurParam( GestionEtab, TraduireMemoire( 'Multi Etablissements     : OUI' ) )
    else
      ErreurParam( GestionEtab, TraduireMemoire( 'Multi Etablissements     : NON' ) );
    ErreurParam( PathFile, TraduireMemoire( 'Emplacement des fichiers : ' ) );
    ErreurParam( FichierTiers, TraduireMemoire( 'Fichier des tiers        : ' ) );
    ErreurParam( FichierEcr, TraduireMemoire( 'Fichier des �critures    : ' ) );
    ErreurParam( FichierRapport, TraduireMemoire( 'Fichier du rapport       : ' ) );
    ErreurParam( DateDeb, TraduireMemoire( 'Date d�but               : ' ) );
    ErreurParam( DateFin, TraduireMemoire( 'Date fin                 : ' ) );
    ErreurParam( FichierRapport, TraduireMemoire( 'Fichier du rapport       : ' ) );
    GenerationFileOk := False;
    end
    else
    begin
      ////////// CREATION du .INI
      Action := 'COMMANDE';
      {$IFDEF EAGL}  // Pour le eBo et le Process serveur
        FileIni := PathFile + 'eComSX.INI';
      {$ELSE}
        FileIni := PathFile + 'COMSX.INI';
      {$ENDIF}
      AssignFile( FichierIni, FileIni );
      ReWrite( FichierIni );
      Writeln( FichierIni, '[COMMANDE]' );
      Writeln( FichierIni, 'NOMFICHIER      =' + PathFile + FichierEcr );
      Writeln( FichierIni, 'TRANSFERTVERS	=' + TransfertVers );
      Writeln( FichierIni, 'NATURETRANSFERT =' + NatureTransfert );
      Writeln( FichierIni, 'FORMAT    	=' + Format );
      Writeln( FichierIni, 'DATEARRET	=01/01/1900' );
      Writeln( FichierIni, 'EXERCICE	=' );
      If NatureTransfert='JRL' then
      begin
        Writeln( FichierIni, 'DATEECR1	=' + DateDeb );
        Writeln( FichierIni, 'DATEECR2	=' + DateFin );
        Writeln( FichierIni, 'TYPE		=' + TypeEcrRecup );
        Writeln( FichierIni, 'TYPEECR		=' + TypeEcrGen );
        Writeln( FichierIni, 'GESTIONETAB	=' + GestionEtab );
        Writeln( FichierIni, 'JOURNAL		=' + Journal );
        Writeln( FichierIni, 'RAPPORT		=' + FichierRapport );
        Writeln( FichierIni, 'ETABLISSEMENT	=[' + Etablis+']' );
        if TobEnteteLienCOmsx.getvalue('YLO_TABLELIBRE')='X' then
         Writeln( FichierIni, 'EXPARAMETRE	=[TL;]' );   //on veut les table libre tiers
        if TobEnteteLienCOmsx.getvalue('YLO_ANNULVALID')='X' then
            Writeln( FichierIni, 'ANNULVALIDATION	=TRUE' );
        if TobEnteteLienCOmsx.getvalue('YLO_DEJAEXTRAIT')='X' then
            Writeln( FichierIni, 'EXPORTE	=TRUE' )
        else Writeln( FichierIni, 'EXPORTE	=FALSE' );
        Writeln( FichierIni, 'CTRS		=TRUE' );
      end
      else begin
        Writeln( FichierIni, 'DATEECR1	=' + Stdate1900 );
        Writeln( FichierIni, 'DATEECR2	=' + Stdate2099 );
        Writeln( FichierIni, 'EXPARAMETRE	=[TL;TIE;]' );   //on veut les table libre tiers
        Writeln( FichierIni, 'PARAMDOS		=TRUE' );
      end;
      Writeln( FichierIni, 'MAIL		=' + EMail );
      Writeln( FichierIni, 'EXCLURE		='+Exclure );
      Flush( FichierIni );
      CloseFile( FichierIni );
      // Fin FICHIER INI
      PwdTraitmtlot := V_PGI.Password;
      UserTraitmtlot := V_PGI.UserLogin;
      // ... car le mot de passe du jour ne marchera plus � minuit...
      //pas test� au 12/11/2007.....
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
      {$IFNDEF EAGL}
      Command := PathComSx+'ComSx.exe /USER="' + UserTraitmtlot + '"'+
        ' /PASSWORD='+PwdTraitmtlot +
        ' /DOSSIER=' + Societe +
        ' /INI=' + PathFile + 'COMSX.INI;EXPORT;Minimized';
      {$ELSE}
      {$IFDEF EAGLCLIENT}
          //?? besoin portNumber? � priori non 12/11/07 NameServer := AppServer.HostName + ':' + inttostr (AppServer.portnumber);
      NameServer := AppServer.HostName ;
      {$ELSE}
      NameServer := HGetComputerName ;
      {$ENDIF EAGLCLIENT}
      Command := PathComSx+'eComSx.exe /SERVER="'+NameServer+'" /USER="' + UserTraitmtlot + '"'+
        ' /PASSWORD='+PwdTraitmtlot +
        ' /DATE='+DateToStr(V_PGI.DateEntree)+' /DOSSIER=' + Societe +
        ' /INI=' + PathFile + 'eComSx.ini;EXPORT;Minimized' ;
      {$ENDIF}
      GenerationFileOk := LanceTraitement( Command );
      if not FileExists( NomFichier ) then
      begin
        MAJBlocNote (Societe, 2) ;
        GenerationFileOk := False ;
      end ;
    end ;
    finally
      if ( GenerationFileOk ) then
      begin
        Result := True ;
        //Tache Export d'ecritures Termin�
        MAJStatutTache (TobEnteteLienCOmsx, 'OK' , icExport) ;
        // Mise � jour bloc notes de la tache fin + ok
        MAJBlocNoteTache ( False, True, icExport ) ;
      end else
      begin
        // Mise � jour bloc notes de la tache fin + erreur
        MAJBlocNoteTache ( False, False, icExport ) ;
      end ;
      DeleteFile( FileIni );
    end;
end;

function ControleParametrageExport ( RepertoireFichier, RepertoireComSx : String) : integer ;
begin
  Result := 0 ;
  if ( RepertoireFichier = '' ) then
    Result := 17
  else if not DirectoryExists( RepertoireFichier ) then
    Result := 12
  {$IFNDEF EAGL}
  else if not FileExists( RepertoireComSx+'ComSx.exe' ) then
    Result := 11 ;
  {$ELSE}
  else if not FileExists( RepertoireComSx+'eComSx.exe' ) then
    Result := 20 ;
  {$ENDIF}
end ;



function ImportFile( const FichierEcr, BaseCompta: string; var GenerationFileOk: Boolean; BlocNotes : TStringList = nil ) : Boolean;
var
  Command, PathFile, Societe, User, EMail,  SansEchec, PathComSx,TypeEcritureGen,TypeEcritureImp: string;
  Fileini, Action, NomFichier: string;
  FicIni: THIniFile;
  PwdTraitmtlot, UserTraitmtlot : String ;
  Q : TQuery ;
  {$IFDEF EAGL}
  NameServer : String ;
  {$ENDIF}

  function HGetComputerName: string;
  var
    S: array[0..255] of char;
    i: {$IFNDEF VER110}LongWord{$ELSE}Integer{$ENDIF};
  begin
    i := sizeof(s);
    GetComputerName(@s, i);
    Result := StrPas(s);
  end;

begin
  Result := False ;
  //Tache Import d'ecritures En cours
  MAJStatutTache (TobEnteteLienCOmsx, 'ENC' , icImport) ;
  // Mise � jour du log pour le trac� de la t�che
  // Mise � jour bloc notes de la tache D�but
  MAJBlocNoteTache ( True, False, icImport ) ;
  Try
    GenerationFileOk := True;
    PathFile := GetParamSocSecur( 'SO_MBOCHEMINCOMPTA', '' ); // Chemin fichier TRA
    if copy( PathFile, length( Pathfile ), 1 ) <> '\' then
      PathFile := PathFile + '\';
    PathComSx := TcbpPath.GetCegidDistriApp ;
    if copy( PathComSx, length( PathComSx ), 1 ) <> '\' then
      PathComSx := PathComSx + '\';
    NomFichier := PathFile + FichierEcr ;
    NomFichier := ChangeFileExt(NomFichier, '.ARC') ;
    if not (V_PGI.RunFromLanceur) then
        Societe := V_PGI.CurrentAlias //Soci�t� courante
{$ifndef EAGLSERVER}
    else Societe := V_PGI.DEfaultSectionName;
{$else}
    else Societe := LookUpCurrentSession.DEfaultSectionName;
{$endif}
    User := V_PGI.UserLogin; //User courant
    EMail := ''; // Envoie rapport apr�s traitement
    TypeEcritureGen := 'N'; // Gestion du type ecriture g�n�r�e
    TypeEcritureImp := 'N'; // Gestion du type ecriture import�
    SansEchec := 'FALSE';
    if ( PathFile = '' ) or ( FichierEcr = '' ) or ( Societe = '' ) or ( User = '' ) or
       ( TypeEcritureGen = '' ) or ( TypeEcritureImp = '' ) then
    begin
      if( Assigned(BlocNotes) ) then
      begin
        BlocNotes.Add( '***** ' + TraduireMemoire( 'TRAITEMENT ANNULE ' ) + '***************************************************' );
        BlocNotes.Add( '***** ' + TraduireMemoire( 'ERREUR DANS LES PARAMETRES ' ) + '******************************************' );
        BlocNotes.Add( TraduireMemoire( 'Fichier des �critures   : ' ) + PathFile + FichierEcr );
        BlocNotes.Add( TraduireMemoire( 'Nom de la base          : ' ) + Societe );
        BlocNotes.Add( TraduireMemoire( 'Utilisateur             : ' ) + User );
        BlocNotes.Add( TraduireMemoire( 'Type �criture re�ues    : ' ) + TypeEcritureGen );
        BlocNotes.Add( TraduireMemoire( 'Type �criture � g�n�rer : ' ) + TypeEcritureImp );
      end;
      GenerationFileOk := False;
    end
    else
    begin
      ////////// CREATION du .INI
      Action := 'COMMANDE';
     {$IFDEF EAGL}
       FileIni := PathFile + 'eComSX.INI';
     {$ELSE}
       FileIni := PathFile + 'COMSX.INI';
     {$ENDIF}
      if FileExists( Fileini ) then
        DeleteFile( FileIni );
      FicIni := THIniFile.Create( Fileini );
      FicIni.WriteString( Action, 'REPERTOIRE      ', PathFile );
      FicIni.WriteString( Action, 'NOMFICHIER      ', FichierEcr );
      FicIni.WriteString( Action, 'MAIL		', EMail );
      FicIni.WriteString( Action, 'TYPEECRIMP    ', TypeEcritureImp );
      FicIni.WriteString( Action, 'TYPEECRGEN    ', TypeEcritureGen );
      FicIni.WriteString( Action, 'SANSECHEC	', SansEchec );
      FicIni.WriteString (Action, 'RUPTUREPIECE' ,'TRUE' ); //Manon 15/11/07 pour Ok sur piece en import
      FicIni.free;
      PwdTraitmtlot := V_PGI.Password;
      UserTraitmtlot := V_PGI.UserLogin;
      // ... car le mot de passe du jour ne marchera plus � minuit...
      //pas test� au 12/11/2007
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
      {$IFNDEF EAGL}
      if BaseCompta = '' then
        Command := PathComSx + 'ComSx.exe /USER="' + UserTraitmtlot + '"'+
          ' /PASSWORD='+PwdTraitmtlot +
          ' /DOSSIER=' + Societe +
          ' /INI=' + PathFile + 'COMSX.INI;IMPORT;Minimized'
       else
        Command := PathComSx + 'ComSx.exe /USER="' + UserTraitmtlot + '"' +
          ' /PASSWORD='+PwdTraitmtlot +
          ' /DOSSIER=' + BaseCompta +
          ' /INI=' + PathFile + 'COMSX.INI;IMPORT;Minimized';
      {$ELSE}
      {$IFDEF EAGLCLIENT}
            // ?? � priori pas besoin du n� 12/11/2007 NameServer := AppServer.HostName + ':' + inttostr (AppServer.portnumber) ;
      NameServer := AppServer.HostName  ;
      {$ELSE}
      NameServer := HGetComputerName ;
      {$ENDIF EAGLCLIENT}
      if BaseCompta = '' then
        Command := PathComSx + 'eComSx.exe /SERVER="'+NameServer+'" /USER="' + UserTraitmtlot + '"'+
          ' /PASSWORD='+PwdTraitmtlot +
          ' /DATE='+DateToStr(V_PGI.DateEntree)+' /DOSSIER=' + Societe +
          ' /INI=' + PathFile + 'eComSx.ini;IMPORT;Minimized'
      else
        //  Suppression PassWord pour connection avec autre utilisateur que CEGID
        Command := PathComSx + 'eComSx.exe /SERVER="'+NameServer+'" /USER="' + UserTraitmtlot + '"'+
          ' /PASSWORD='+PwdTraitmtlot +
          ' /DATE='+DateToStr(V_PGI.DateEntree)+' /DOSSIER=' + BaseCompta +
          ' "/INI=' + PathFile + 'eComSx.ini;IMPORT;Minimized"' ;
      {$ENDIF EAGL}

      GenerationFileOk := LanceTraitement( Command );
      if not FileExists( NomFichier ) then
      begin
        MAJBlocNote (BaseCompta, 2) ;
        GenerationFileOk := False ;
      end ;
    end ;
    Finally
      if ( GenerationFileOk ) then
      begin
        Result := True ;
        //Tache Import d'ecritures Termin�
        MAJStatutTache (TobEnteteLienCOmsx, 'OK' , icImport) ;
        // Mise � jour bloc notes de la tache fin + ok
        MAJBlocNoteTache ( False, True, icImport ) ;
      end else
      begin
        // Mise � jour bloc notes de la tache fin + erreur
        MAJBlocNoteTache ( False, False, icImport ) ;
      end ;
      // Mise � jour du log pour le trac� de la t�che
      DeleteFile( FileIni );
    end;
end;


procedure TransfertCompta( var LastErr : Integer;
                          const  sEtablissmt,  DateDeb, DateFin,
                          DateFile, EtatCompta, BaseCompta, FichierEcr, sEcritures: string;
                          var TrtOk, GenerationFileOk: Boolean;
                          bEcritures, ComptaExterne: Boolean;
                          TacheSuivante : TTypeTacheInterCpta; BlocNotes : TStringList = nil ) ;
var
  CodeCpta: string;
  ExportationOk, ImportationOk : Boolean ;
begin

  LastErr := 1;
  CodeCpta := TobEnteteLienCOmsx.GetString( 'YLO_CODECPTA' ) ;
  Try
    ExportationOk := False ;
    ImportationOk := True ;
    case TacheSuivante of
    icExport :
      begin
        // Exportation des ecritures dans un fichier
        Try
        ExportationOk := GenereFile( FichierEcr, DateDeb, DateFin, DateFile,sEtablissmt,  GenerationFileOk, BlocNotes );
        finally
          if ExportationOk then
            LastErr := 13
          else
            LastErr := 14 ;
        end ;
      end ;
    icImport :
      begin
        // Exportation des ecritures dans un fichier
        Try
          LastErr := 0 ;
          if( not(ComptaExterne) or (BaseCompta <> '') ) then
            ImportationOk := ImportFile( FichierEcr, BaseCompta, GenerationFileOk, BlocNotes );
        finally
          if not ImportationOk then
            LastErr := 19
          else if LastErr=0 then LAstErr:=18;
        end ;
      end ;
    icNull :
      begin
        // on chaine le tout
        Try
        ExportationOk :=GenereFile( FichierEcr, DateDeb, DateFin, DateFile, sEtablissmt, GenerationFileOk, BlocNotes )
        finally
          if ExportationOk then
          begin
            LastErr := 13 ;
            // Import du fichier en automatique
            if( not(ComptaExterne) or (BaseCompta <> '') ) then
              begin
              ImportationOk := ImportFile( FichierEcr, BaseCompta, GenerationFileOk, BlocNotes );
              if not ImportationOk then
                 LastErr := 16
              else LastErr:=15;
              end;
          end else
            LastErr := 14 ;
        end ;
      end ;
    end; //fin du case
  finally
    if LastErr = 0 then
      // Mise � jour bloc notes du transfert fin + ok
          MAJBlocNoteTache ( False, True, icNull ) ;
  end ;
end;

 // fct appeler pour le process serveur.
procedure PSTransfertCompta( RequestTOB, ResultTOB: TOB );
var
  DateFile, EtatCompta, sEcritures,
  FichierEcr,  sErreur,BaseCompta: string;
  TrtOk, GenerationFileOk,
  ComptaExterne: Boolean;
  LastErreur : Integer;
  // Date relative pour le transfert comptable en process server
  DateDeb, DateFin : TDateTime;
  SeqDateDeb, SeqDateFin : String;
  ClauseEtab : String;
  //iEtab : Integer ;
begin
  // V�rification des param�tres d'entr�e
  if( ResultTOB = nil ) then
    Exit;
  // Creation du blocnotes
  ZBlocNotes := TStringList.Create;
  Serreur:='';
  LastErreur:=0;

  if( (RequestTOB = nil) or not(RequestTOB.FieldExists(ChCodeCpta)) or not(RequestTOB.FieldExists(ChSociete))
  or not(RequestTOB.FieldExists(ChSeqDateDeb)) or not(RequestTOB.FieldExists(ChSeqDateFin))
  or not(RequestTOB.FieldExists(ChCaptionEcr)) or not(RequestTOB.FieldExists(ChJournalEvent))) then
  begin
    ResultTOB.SetString( 'ERROR', TraduireMemoire('Param�tres incorrects') );
    Exit;
  end;
  // Chargement de l'ent�te du transfert comptable
  if not Assigned(TobEnteteLienCOmsx) then
    TobEnteteLienCOmsx := TOB.Create( 'YLIENCOMSX',nil ,0 ) ;
  TobEnteteLienCOmsx.SelectDB( '"' + RequestTOB.GetString( ChCodeCpta ) + '"', nil ) ;
    //mcd � voir ?? comment cela va se passer en PCL ????
  V_PGI.CurrentAlias := RequestTOB.GetString( ChSociete );
  sEcritures := TobEnteteLienCOmsx.GetString( 'YLO_DEJAEXTRAIT' );
  if( sEcritures = '-' ) then
    EtatCompta := '"ATT"'
  else
    EtatCompta := '"ATT","EXP"';
  //Calcul du nom du fichier .TRA ou .TRT
  FichierEcr := NomDuFichierExport( TobEnteteLienCOmsx.GetString( 'YLO_NOMFICHIER' ), DateFile );
{$ifdef GIGI}
  COmptaExterne := true; // on force � compta diff�rente de la base en cours, sinon, pas d'utilist� ...
{$else}
  ComptaExterne := GetParamSocSecur( 'SO_COMPTAEXTERNE', False ); //option obligatoire en PME
{$endif}
  SeqDateDeb := RequestTOB.GetString(ChSeqDateDeb) ;
  SeqDateFin := RequestTOB.GetString(ChSeqDateFin) ;

  // Tache Planifie Execut�e Termine
  MAJStatutTache (TobEnteteLienCOmsx, 'OK' , icPlanifie) ;

  with TobEnteteLienCOmsx do
  begin
    ClauseEtab := GetString('YLO_ETABLISS'); // AC 20/11/06
    
    DateDeb := StrToDateTime( GetString( 'YLO_DATEDEBUT' ) );
    DateFin := StrToDateTime( GetString( 'YLO_DATEFIN' ) );
    BaseCOmpta:=  GetString('YLO_BASECOMPTA');
{$ifdef EAGLSERVER}
{$ifdef GIGI} //en PCL, il faut ajouter le nom de la DB00, aligner sur UtofLienCOmsx
    if basecompta<>'' then Basecompta :='DB'+Basecompta + '@'+V_PGI.CurrentAlias;
{$endif}
{$endif}
    CalcDatesRelatives( DateDeb, DateFin, SeqDateDeb, SeqDateFin, Nowh);
    TransfertCompta( LastErreur, ClauseEtab,
                                  DateTimeToStr(DateDeb), DateTimeToStr(DateFin),
                                  DateFile, EtatCompta,  BAseCOmpta,
                                  FichierEcr, RequestTOB.GetString(ChCaptionEcr),
                                  TrtOk, GenerationFileOk,
                                  sEcritures <> '-', ComptaExterne, icNull, ZBlocNotes );
  end;
  sErreur := ComsxSetLastError( LastErreur ) ;
  ResultTOB.SetString( 'ERROR', sErreur );
  // mise � jour du Journal event
  MajJournalEvent ( sErreur,  LastErreur ) ;
  // Mise � jour du bloc note
  TobEnteteLienCOmsx.SetString( 'YLO_BLOCNOTE', ZBlocNotes.Text ) ;
  TobEnteteLienCOmsx.UpdateDB ;
  // Suppression du blocnote
  FreeAndNil(ZBlocNotes) ;
end;


{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 18/01/2007
Modifi� le ... :   /  /    
Description .. : Mise � jour du statut des taches 
Mots clefs ... : 
*****************************************************************}
procedure MAJStatutTache (TOBEntete : TOB; Statut : String; Tache : TTypeTacheInterCpta ) ;
Var
  NomChampTache, NomChampDate, NomChampUtilisateur : String ;
begin

  case Tache of
    icPlanifie :
      begin
        NomChampTache := 'YLO_PLANIFIE' ;
        NomChampDate := 'YLO_DATEPLANIF' ;
        NomChampUtilisateur := 'YLO_USERPLANIF' ;
      end ;
    icExport :
      begin
        NomChampTache := 'YLO_EXPORT' ;
        NomChampDate := 'YLO_DATEEXPORT' ;
        NomChampUtilisateur := 'YLO_USEREXPORT' ;
      end ;
    icImport :
      begin
        NomChampTache := 'YLO_IMPORT' ;
        NomChampDate := 'YLO_DATEIMPORT' ;
        NomChampUtilisateur := 'YLO_USERIMPORT' ;
      end ;
  end ;
  TOBEntete.SetString(NomChampTache, Statut) ;
  if Statut = 'ENC' then
  begin
    TOBEntete.SetDateTime(NomChampDate, NowH) ;
    TOBEntete.SetString(NomChampUtilisateur, V_PGI.User) ;
  end ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 25/04/2006
Modifi� le ... : 28/04/2006
Description .. : Mise � jour du bloc note pour chaque tache avec son �tat
Suite ........ : Debut, Fin et son statut Ok, Err
Mots clefs ... :
*****************************************************************}
procedure MAJBlocNoteTache ( Debut,TacheOk : Boolean; Tache : TTypeTacheInterCpta ) ;
Var
  sErr : String ;
  NumEtape : Integer ;
begin
  if Debut and ( not ExecutionTotal ) then
    ZBlocNotes.Clear ;
  NumEtape := 0 ;

  case Tache of
    icExport :
        NumEtape := 1 ;
    icImport :
        NumEtape := 3 ;
    icNull :
        NumEtape := 2 ;
  end ;
  if Debut then
    ZBlocNotes.Add( LibTache[NumEtape] )
  else
  begin
    if TacheOk then
    begin
      if NumEtape <> 5 then
        ZBlocNotes.Add( Format( TexteMessage [7] , [ LibTache[NumEtape] ] ) )
      else
        ZBlocNotes.Add( TraduireMemoire( 'Le ' )+LibTache[NumEtape]+TraduireMemoire( ' est termin�' ) ) ;
    end 
    else
    begin
      sErr := Format( TexteMessage [8], [ LibTache[NumEtape] ] )  ;
      sErr := sErr + ' ' + TexteMessage [9] + ' ' + TexteMessage [24];
      ZBlocNotes.Add( sErr ) ;
    end ;
  end ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 11/05/2006
Modifi� le ... :   /  /    
Description .. : Mise � jour du bloc note pour les erreur
Mots clefs ... : 
*****************************************************************}
procedure MAJBlocNote (sMessage : String; NumErreur : integer = 0 )  ;
Var
  sText : String ;
begin
  ZBlocNotes.Add( '' );
  if NumErreur <> 0 then
  begin
    case NumErreur of
      15 : begin
             ZBlocNotes.Add( TraduireMemoire (TexteMessage [ 15 ]) );
             ZBlocNotes.Add( TraduireMemoire (TexteMessage [ 21 ]) );
           end;
      17 : begin
             ZBlocNotes.Add( TraduireMemoire (TexteMessage [ 17 ]) );
             ZBlocNotes.Add( TraduireMemoire (TexteMessage [ 22 ]) );
           end;
    else
      ZBlocNotes.Add( TraduireMemoire( TexteMessage [ NumErreur] ) );
    end;
  end;
  sText := '  '+ sMessage + #13#10 ;
  if sMessage <> '' then
    ZBlocNotes.Add( sText );
end ;
    
{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 03/05/2006
Modifi� le ... :   /  /    
Description .. : Retourne l'�tape suivante � ex�cuter 
Mots clefs ... : 
*****************************************************************}
function QuelleTacheSuivante : TTypeTacheInterCpta ;
begin
  Result := icNull ;
  if ( TobEnteteLienCOmsx.GetString( 'YLO_PLANIFIE' ) = 'ENC' ) then
  begin
    Result := icPlanifie ;
  end
  else if ( TobEnteteLienCOmsx.GetString( 'YLO_EXPORT' ) = 'ATT' )
    or ( TobEnteteLienCOmsx.GetString( 'YLO_EXPORT' ) = 'ENC' ) then
  begin
    Result := icExport ;
  end 
  else if ( TobEnteteLienCOmsx.GetString( 'YLO_IMPORT' ) = 'ENC' )
   or ( TobEnteteLienCOmsx.GetString( 'YLO_IMPORT' ) = 'ATT' ) then
  begin
    Result := icImport ;
  end ;
end ;



{***********A.G.L.***********************************************
Auteur  ...... : MC Desseignet
Cr�� le ...... : 18/01/2007
Modifi� le ... :   /  /
Description .. : retourne le message d'erreur suivant le traitement effectu�
Suite ........ : et le resultat
Mots clefs ... :
*****************************************************************}
function ComsxSetLastError( var Num: integer; LibEcran : String = '' ) : String ;
Var
  sMessage : String ;
begin
  case num of
    13 :
      begin
        // Tache exportation ok
        sMessage := Format( TexteMessage [7] , [ LibTache[ 1 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
        num:=0
      end ;
    14 :
      begin
        // Tache exportation erreur
        sMessage := Format( TexteMessage [8], [ LibTache[ 1 ] ] )  ;
        sMessage := sMessage + ' ' + TexteMessage [9]+ '#13#10 ' + TexteMessage [24] ;
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    15 :
      begin
        // Tache importation ok
        sMessage := Format( TexteMessage [7] , [ LibTache[ 3 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
        num:=0
      end ;
    16 :
      begin
        // Tache importation erreur
        sMessage := Format( TexteMessage [8], [ LibTache[ 3 ] ] )  ;
        sMessage := sMessage + ' ' + TexteMessage [9] + '#13#10 ' + TexteMessage [24];
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    18 :
      begin
        // Tache importation ok
        sMessage := Format( TexteMessage [7] , [ LibTache[ 2 ] ] ) ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
        num:=0
      end ;
    19 :
      begin
        // Tache importation erreur
        sMessage := Format( TexteMessage [8], [ LibTache[ 2 ] ] )  ;
        sMessage := sMessage + ' ' + TexteMessage [9] ;
        {$IFNDEF EAGLSERVER}
          PGIError( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
    0 :
      begin
        // Transfert comptable termin�
        sMessage := TexteMessage [5] ;
        {$IFNDEF EAGLSERVER}
          PGIInfo( sMessage, LibEcran ) ;
        {$ENDIF EAGLSERVER}
      end ;
  end ;
  Result := sMessage ;
end;

function NomDuFichierExport( NomFichier: string; var DateFile: string ): string;
var
  DateSyst: TDateTime;
  Annee, Mois, Jour, Hre, Min, Sec, mSec: Word;
  ComplementNom: String;

  function TraiteDecode( Num : integer ): string;
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
  if NomFichier <> '' then
    ComplementNom := NomFichier;
(* SO_TYPECOMSX  12/11/2007 paramsoc pas g�r� � ce jour, uniquement S5
  if ( GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S1' ) or ( GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'S5' )
     or ( GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = '' )then
    Result := ComplementNom + '-' + DateFile + '.TRA'
  else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SIS' then
    Result := ComplementNom + '-' + DateFile + '.TRF'
  else if GetParamSocSecur( 'SO_TYPECOMSX', 'S5' ) = 'SAG' then
    Result := ComplementNom + '-' + DateFile + '.PNM';  *)
  Result := ComplementNom + '-' + DateFile + '.TRA'; //12/11/2007 uniquement S5 � ce jour
end;

end.
