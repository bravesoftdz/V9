unit Paie_Cjdc;

interface

uses
  SysUtils,
  Classes,
  Controls,
  Forms,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  Buttons,
  hctrls,
  hmsgbox,
{$IFNDEF eAGLClient}
  Db,
{$IFNDEF DBXPRESS}dbTables, {$ELSE}uDbxDataSet, {$ENDIF}
{$ENDIF}
  Utob,
  HEnt1,
  Dialogs,
  FileCtrl,
  Windows, // pour getTempFile   ?
  Paie_cjdc_lib;

type
  TF_Paie_cjdc = class(TForm)
    Panel1: TPanel;
    Chemin: TLabel;
    Annuler: TBitBtn;
    Valider: TBitBtn;
    Label1: TLabel;
    ReceptionBarre: TProgressBar;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    ComboEmetteurs: THValComboBox;
    RichEdit: TRichEdit;
    procedure ActiverFiche(Sender: TObject);
    procedure AnnulerClick(Sender: TObject);
    procedure ValiderClick(Sender: TObject);
    procedure OnChangeEmetteur(Sender: TObject);
//@@    function RecupererWS(ListeEmetteurs: string): Boolean;
    function RecupererWS(ListeEmetteurs: string; Social : boolean = false): Boolean; //@@
    function ExploiterRp(FichierCr: INFOFICHIER; Teleprocedure: integer): boolean;

  private
    { D�clarations priv�es}
    sSQlEmetteur, listeEmetteurs: string;
    ControlerSignatureDgi: boolean;
    NbFichier, NbMessageRejet: Integer;
    TabFichier: array[0..1024] of string;
    Path: array[0..255] of Char;
//    RepTmp  :  string;

  public
    { D�clarations publiques}
 end;

  {--------------------------------
   --- Definition des proc�dures
   --------------------------------}
//@@ function Aff_RecepEnvoi_Web(Transmission: TTRANSMISSION): boolean;
function Aff_RecepEnvoi_Web(Transmission: TTRANSMISSION; Social : boolean = false;SiretEmetteur :string = ''): boolean; //@@
function CreerRequeteWSRecup(TeleProcedure: integer; RepertoireRqRp, FichierRequete,
  TypeListe, DateDeb, DateFin, Statut, SiretEmetteur: string): Boolean;
function CreerRequeteWSDepot(RepertoireRqRp: string; TransmissionWeb: TTransmission): Boolean;
function TransmettreWS(TransmissionWeb: TTransmission; RichEdit: TRichEdit): Boolean;
function DetermineLibelleErreur(Reponse: integer): string;

var
  TransmissionWeb: TTransmission;
  ResultatEnvoiWeb: boolean;
  CheminFichierEnvoiAuto: string;
  NomFichierEnvoiAuto: string;
  pConfig : RPConfig; // contexte courant
  AppPath : string;
  BoolSocial : boolean; //@@
  SiretEmett  : string; //@@
implementation

{$R *.DFM}


function Aff_RecepEnvoi_Web(Transmission: TTRANSMISSION; Social : boolean = false;SiretEmetteur :string = ''): boolean; //@@
var
  Fiche: TF_Paie_cjdc;
begin
  BoolSocial := Social;
  SiretEmett := SiretEmetteur;
  TransmissionWeb := Transmission;
  CheminFichierEnvoiAuto := '';
  Fiche := TF_Paie_cjdc.Create(Application);
  Fiche.ShowModal;
  Fiche.Free;
  Result := ResultatEnvoiWeb;
end;

function Aff_EnvoiAuto_Web(Transmission: TTRANSMISSION; CheminFichier: string): boolean;
var
  Fiche: TF_Paie_cjdc;
begin
  TransmissionWeb := Transmission;
  CheminFichierEnvoiAuto := CheminFichier;
  Fiche := TF_Paie_cjdc.Create(Application);
  Fiche.ShowModal;
  Fiche.Free;
  Result := ResultatEnvoiWeb;
end;



{---------------------------------------------------
 --- Nom   : FormActivate
 --- Objet : Initialisation de la fiche Reception
 ---------------------------------------------------}

procedure TF_Paie_cjdc.ActiverFiche(Sender: TObject);
begin
	 // r�pertoire de travail de l'utilisateur
    GetTempPath(255, Path); // recup du repertoire Temp -> voir si la methode est la bonne
    pConfig.RepTmp := StrPas(Path) + 'CegidTdi';
    // v�rifier si le r�pertoire existe
    if not DirectoryExists(pConfig.RepTmp) then
    begin
      ForceDirectories(pConfig.RepTmp);
      if not DirectoryExists(pConfig.RepTmp) then
        PgiInfo(pConfig.RepTmp, 'Impossible de cr�er ');
    end;

    AppPath := V_PGI.StdPath;
    AppPath := stringReplace(AppPath, '\STD', '\APP', [rfIgnoreCase]);
  //---Combo �metteur en fonction des confidentialit�s
    ListeEmetteurs := ChargerListeEmetteurs(ComboEmetteurs, '<Tous>');
    ComboEmetteurs.OnChange := OnChangeEmetteur;

    Chemin.Caption := ' Connexion au Service Web je declare';
    Chemin.Refresh;
    RichEdit.clear;

    if TransmissionWeb.ModeEnvoi = RECUP then
    begin
    	Valider.Visible := TRUE;

      if (pConfig.RecupWS = 'True') then
      begin
		    ComboEmetteurs.visible := FALSE;  //de tte mani�re on ne peut pas y acc�der
        GroupBox1.Visible := FALSE;
        Label2.visible := FALSE;

        ReceptionBarre.Min := 0;
  			ReceptionBarre.Max := (length(ListeEmetteurs) div 15) * 2;
  			ReceptionBarre.Step := 1;

        RecupererWS(ListeEmetteurs,BoolSocial); //@@
        Chemin.Caption := ' Service Web je declare : r�sultat r�cup�ration des comptes rendus';
        Chemin.Refresh;
        // fin traitement permettre de quitter
        Annuler.Visible := TRUE;
      end
      else
      begin
      	RichEdit.lines.add ('Configuration incompl�te ou incorrecte');
       	RichEdit.lines.add ('V�rifier le param�trage de la fiche destinataire jedeclare');
      	RichEdit.Lines.add ('V�rifier les comptes (param�trage du site, Service Web)');
      end;
    end
    else
      begin
      	RichEdit.lines.add ('Connexion au Service WEB JDC');
      	Valider.visible := FALSE;
        ResultatEnvoiWeb := TransmettreWS(TransmissionWeb, RichEdit);
        Chemin.Caption := ' Service Web je declare : r�sultat envoi';
        Annuler.visible :=True;
        Chemin.Refresh;
        RichEdit.Refresh;
      end;
end;

procedure TF_Paie_cjdc.OnChangeEmetteur(Sender: TObject);
var
  i: integer;
begin
  // R�cup�rer nouvelle valeur de la requete
  sSqlEmetteur := ComboEmetteurs.value;
  if sSqlEmetteur <> '' then //si on n'a pas choisi <Tous>
  begin
    i := pos('"', sSqlEmetteur); // AND NTM_SIRET ="......."
    ListeEmetteurs := copy(sSqlEmetteur, i, 14) + ';';
  end
end;

{-----------------------------------------------
 --- Nom   : AnnulerClick
 --- Objet : Annule la r�ception des messages
 -----------------------------------------------}

procedure TF_Paie_cjdc.AnnulerClick(Sender: TObject);
begin
  ModalResult := MrOk;
end;


procedure TF_Paie_cjdc.ValiderClick(Sender: TObject);
var
//@@  CheminTampon, ChInformation, Masque, TypeSupport: string;
//@@  UnSiret, sConseil: string;
  ChInformation, TypeSupport: string;
  sConseil: string;
begin
  ControlerSignatureDGI := FALSE;
  TypeSupport := '';

  // TabFichier contient la liste des fichiers r�cup�r�s
  ReceptionBarre.Min := 0;
  ReceptionBarre.Max := NbFichier;
  ReceptionBarre.Step := 1;


  if (nbFichier > 0) then
  begin
	  RichEdit.Lines.add ('D�but traitement des comptes rendus re�us');
    {
    NbMessageRejet := TraiterLesFichiers(Chemin, ReceptionBarre, TabFichier,
      pConfig.RepTmp, nbFichier, TypeSupport, ControlerSignatureDGI,
      FALSE);
   	//FALSE diff�r� : pour mettre en base
    }
	  RichEdit.Lines.add ('Fin traitement des comptes rendus re�us');

   //--- Affichage r�sultat

    if NbFichier < 2 then
      Chemin.Caption := IntToStr(NbFichier) + ' fichier de compte rendu trait�.'
    else
      Chemin.Caption := IntToStr(NbFichier) + ' fichiers de compte rendu trait�s.';
  end
  else
    Chemin.caption := ''; // pas de fichier � r�cup�rer

  Chemin.Refresh;
  Valider.Enabled := False;

  if (NbMessageRejet > 0) then
  begin
    ChInformation := ' Lors de l''op�ration de r�ception, Tdi a d�tect� des anomalies dans ' + IntToStr(NbMessageRejet);
    if NbMessageRejet = 1 then
      ChInformation := ChInformation + ' fichier'
    else
      ChInformation := ChInformation + ' fichiers';
    sConseil := '"Journal des op�rations".';
    ChInformation := ChInformation + ' Pour plus d''informations' + #13 + #10;
    ChInformation := ChInformation + ', s�lectionner' + sConseil;
    MessageDlg(ChInformation, mtInformation, [mbOk], 0);
  end;
  Valider.Visible := FALSE;
  Annuler.Visible := TRUE;
end;

function DetermineLibelleErreur(Reponse: integer): string;
begin
  Result := '';
  case reponse of
    1: Result := ': non abonn� � la proc�dure';
    2: Result := ': pi�ce jointe manquante';
    3: Result := ': trop de pi�ces jointes';
    4: Result := ': type de compression non support�';
    5: Result := ': requ�te mal form�e';
    6: Result := ': nom de connexion ou mot de passe erron�';
    888: Result := ': l''URL n''est pas accessible '
  end;
end;


function TransmettreWS(TransmissionWeb: TTransmission; RichEdit: TRichEdit): Boolean;
var
  FichierCR: INFOFICHIER;
  ChParametre, Chaine, nomFichierRp, Etiquette, PieceRetour: string;
  Resultat: Boolean;
  Reponse: integer;
  Libelle: string;
  RepertoireRqRp: string;
begin

  Resultat := False;
  TransmissionWeb.FichierRequete := stringReplace(TransmissionWeb.FichierEnvoi, '.edi', '', [rfIgnoreCase]);
  NomFichierRp := TransmissionWeb.FichierRequete + '.rp';
  TransmissionWeb.FichierRequete := TransmissionWeb.FichierRequete + '.rq';
  RepertoireRqRp := pConfig.RepTmp + 'WS';
  if not DirectoryExists(RepertoireRqRp) then
    ForceDirectories(RepertoireRqRp);
  //--- Creation de la requete
  RichEdit.Clear;
  RichEdit.setFocus;

  if CreerRequeteWSDepot(RepertoireRqRp, TransmissionWeb) then
  begin
    ChParametre := AppPath + '\cjdc.exe ' + RepertoireRqRp + '\' + TransmissionWeb.FichierRequete;
    if (TDI_Executer(ChParametre)) then
    begin
     //
      if Tdi_OuvrirFichierCR(FichierCR, '', RepertoireRqRp + '\' + nomFichierRp, MODE_LECTURE) then
      begin
        while (not Tdi_FinFichierCR(FichierCr)) do
        begin
          TDI_LireFichierCR(FichierCR, Chaine);
          Etiquette := ReadTokenPipe(Chaine, '=');
          if (strlcomp(Pchar(Etiquette), 'OPERATION', 9) = 0) then continue;
          if (strlcomp(Pchar(Etiquette), 'CODE', 4) = 0) then
          begin
            Reponse := strToInt(Chaine);
            if Reponse = 0 then
            begin
              Resultat := TRUE;
              Libelle := 'Transmission r�ussie';
            end
            else
            begin
              Libelle := 'Echec transmission, erreur ' + intTostr(Reponse);
              Libelle := Libelle + DetermineLibelleErreur(Reponse);
            end;
            RichEdit.Lines.add(Libelle);
            continue;
          end;
          if (strlcomp(Pchar(Etiquette), 'LIBELLE', 7) = 0) then
          begin
            RichEdit.Lines.add(Chaine);
          end;

          if (strlcomp(Pchar(Etiquette), 'PIECERETOUR', 10) = 0) then
          begin
            PieceRetour := Chaine;
            continue;
          end;

          if (strlcomp(Pchar(Etiquette), 'TEXTE', 5) = 0) then
          begin
            RichEdit.Lines.add(Chaine);

            while (not Tdi_FinFichierCR(FichierCr)) do
            begin
              TDI_LireFichierCR(FichierCR, Chaine);
              RichEdit.Lines.add(Chaine);
            end;
          end;
        end;
        Tdi_FermerFichierCR(FichierCR);
        DeleteFile(pchar(TransmissionWeb.FichierRequete));
      end;
    end
    else
      Resultat := FALSE;

    DeleteFile(pchar(PieceRetour));
  end;

  Result := Resultat;
end;

{***********A.G.L.***********************************************
Auteur  ...... : GCattenot
Cr�� le ...... : 30/08/2006
Modifi� le ... : 21/05/2007
Description .. : R�cup�re les comptes rendus mis � disposition par le portail
Suite ........ : 
Suite ........ : Parametre re�u liste des �metteurs:
Suite ........ : 32697904000010;32788811100025;
Mots clefs ... : 
*****************************************************************}


function TF_Paie_cjdc.RecupererWS(ListeEmetteurs: string; Social : boolean = false): Boolean; //@@
var
  FichierCR: INFOFICHIER;
  ChParametre, nomFichierRq, NomFichierRp: string;
  Resultat: Boolean;
  RepertoireRqRp: string;
  SiretEmetteur: string;
  TypeListe, DateDeb, DateFin, Statut, Date: string;

begin
  Resultat := False;
  RepertoireRqRp := pConfig.RepTmp + 'WS';
  if not DirectoryExists(RepertoireRqRp) then
    ForceDirectories(RepertoireRqRp);
  TypeListe := ACS_ARS;
//  TypeListe := ACS;
//  TypeListe := TOUS;

//  Statut := NOUVELLES; // nouvelles pi�ces
  Statut := TOUTES; // nouvelles pi�ces

  DateDeb := '01/03/2007';
  DateFin := TDI_ObtenirDateFormat;
  //DateFin := StringReplace(DateFin, '/', '', [rfReplaceAll]);
  NomFichierRq := 'UneRequete.rq';
  NomFichierRp := stringReplace(NomFichierRq, '.rq', '.rp', [rfIgnoreCase]);
  RichEdit.clear;

  Date := DateTimeToStr (now);

  siretEmetteur := ReadTokenPipe(ListeEmetteurs, ';'); //premier Siret
  if (Social) then
    siretEmetteur := SiretEmett; //@@
  while siretEmetteur <> '' do
  begin
    if InitInfoWS(SiretEmetteur, TransmissionWeb, Social) then // identifiants de connexion   @@
    begin
  // g�nerer Requ�te /TVA, r�cup�rer et exploiter les fichiers
  // on boucle sur la liste des �metteurs et pour chacun d'eux on active
  // la r�cup�ration pour TVA puis TDFC
  //--- Creation de la requete pour la TVA
  		// Mettre � jour la date de la derni�re connexion de r�cup�ration
//@@      ExecuteSql ('UPDATE NTDI_EMETTEUR SET NEM_RESERVE1="' + Date +'" WHERE NEM_SIRET ="' + SiretEmetteur +'"');


 //--- Creation de la requete pour DUCS
       if CreerRequeteWSRecup(transmissionWeb.teleprocedure, RepertoireRqRp, nomFichierRq,
          TypeListe, DateDeb, DateFin, Statut, SiretEmetteur) then
        begin
          ChParametre := AppPath  + '\cjdc.exe ' + RepertoireRqRp + '\' + NomFichierRq;
          if (TDI_Executer(ChParametre)) then
          begin
            if Tdi_OuvrirFichierCR(FichierCR, '', RepertoireRqRp + '\' + nomFichierRp, MODE_LECTURE) then
            begin
              ExploiterRp(FichierCr, transmissionWeb.teleprocedure); // mettre � jour RichEdit, traiter les iCR

              Tdi_FermerFichierCR(FichierCR);
              DeleteFile(pchar(TransmissionWeb.FichierRequete));
            end;
          end
          else
            Resultat := FALSE;
				end;
        RichEdit.refresh;
        ReceptionBarre.StepIt;
//      end;
//--- Crer une autre requete pour DADSU car on ne peut pas tout
//    r�cup�rer d'un coup
    end;
    siretEmetteur := ReadTokenPipe(ListeEmetteurs, ';'); //Siret suivant
  end;
  Result := Resultat;
end;

//
//Exploitation de la r�ponse � la requ�te sur le servic Web: traitement des ICR
// les ICR sont copi�s dans UP pour r�int�grer un traitement unique de prise en compte
//

function TF_Paie_cjdc.ExploiterRp(FichierCr: INFOFICHIER; Teleprocedure: integer): boolean;
var
  Chaine, Etiquette, PieceRetour, StatutPieceRetour, TypePieceRetour: string;
  Reponse, nb: integer;
  Libelle: string;
  CheminDest : string;
begin
  Result := FALSE;
  Reponse := 0;
  nbFichier := 0;

  while (not Tdi_FinFichierCR(FichierCr)) do
  begin
    TDI_LireFichierCR(FichierCR, Chaine);
    Etiquette := ReadTokenPipe(Chaine, '=');
    if (strlcomp(Pchar(Etiquette), 'OPERATION', 9) = 0) then continue;
    if (strlcomp(Pchar(Etiquette), 'CODE', 4) = 0) then
    begin
      Reponse := strToInt(Chaine);
      if Reponse = 0 then
      begin
        Result := TRUE;
        Libelle := 'R�ception des comptes rendus r�ussie';
      end
      else
        Libelle := 'Echec, erreur:' + intTostr(Reponse); ;
      Libelle := Libelle + DetermineLibelleErreur(Reponse);
//			RichEdit.Lines.add(Libelle); mis � jour apr�s le libelle
      continue;
    end;

    if (strlcomp(Pchar(Etiquette), 'LIBELLE', 7) = 0) then
    begin
      RichEdit.Lines.add(Chaine);
      RichEdit.Lines.add(Libelle);
    end;

    if (strlcomp(Pchar(Etiquette), 'NBELEMENTS', 6) = 0) then
    begin
      nb := strToInt(Chaine);
      if (nb = 0) and (Reponse = 0) then
        RichEdit.Lines.add('Aucun nouveau compte rendu');
    end;


    if (strlcomp(Pchar(Etiquette), 'TYPEPIECE', 8) = 0) then
    begin
      TypePieceRetour := Chaine;
      continue;
    end;
    if (strlcomp(Pchar(Etiquette), 'STATUT', 6) = 0) then
    begin
      StatutPieceRetour := Chaine;
      continue;
    end;
    if (strlcomp(Pchar(Etiquette), 'PIECERETOUR', 10) = 0) then
    begin
      PieceRetour := Chaine;
            //lancer le traitement de la pi�ce
      if (PieceRetour <> '') and
        ((TypePieceRetour = ACS) or (TypePieceRetour = ARS)) then
      begin
        // donc on copie dans le r�pertoire personnel
        CheminDest := pConfig.RepTmp + '\' + extractFilename(PieceRetour);
      	TDI_CopierFichier(PieceRetour, CheminDest);
        // maj  table des fichiers � traiter
        TabFichier[nbFichier] :=  extractFilename(PieceRetour);
        inc (nbFichier);
		    DeleteFile(pchar(PieceRetour));
      end;
      continue;
    end;

    if (strlcomp(Pchar(Etiquette), 'TEXTE', 5) = 0) then
    begin
      RichEdit.Lines.add(Chaine);
      while (not Tdi_FinFichierCR(FichierCr)) do
      begin
        TDI_LireFichierCR(FichierCR, Chaine);
        if strlcomp(pchar(Chaine), '[', 1) = 0 then break;
        RichEdit.Lines.add(Chaine);
      end;
    end;
  end;
end;



function CreerRequeteWSDepot(RepertoireRqRp: string; TransmissionWeb: TTransmission): Boolean;
var
  Fichier: TextFile;
  Chaine: string;
  sGuid: string;

begin
	if not FileExists (AppPath + '\cjdc.exe ') then
  begin
  	PgiInfo ('Echec', 'Composant cjdc non trouv�');
  	Result := FALSE;
  end
  else

  if FileExists(TransmissionWeb.FichierChemin) then
  begin
    if (TDI_OuvrirFichier(Fichier, '', RepertoireRqRp + '\' + TransmissionWeb.FichierRequete, MODE_CREATE)) then
    begin
      Chaine := '# Infos op�ration :' + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);
      Chaine := 'OPERATION=DEPOT' + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);
      Chaine := 'DATEOP=' + TDI_ObtenirDateHeure + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'PROCEDURE=';
      if TransmissionWeb.teleprocedure = TDFC then
        Chaine := Chaine + 'edi-tdfc'
      else
        if TransmissionWeb.teleprocedure = TVA then
          Chaine := Chaine + 'edi-tva'
      else
        if TransmissionWeb.teleprocedure = DUCS then
          Chaine := Chaine + 'ducs'
      else
        if TransmissionWeb.teleprocedure = DADSU then
          Chaine := Chaine + 'dadsu';

      Chaine := Chaine + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'ID=' + TransmissionWeb.IdWS + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);
      Chaine := 'MDP=' + TransmissionWeb.MpWS + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'URL=' + TransmissionWeb.UrlWS + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'USER=' + V_PGI.User + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'REPERTOIRE=' + RepertoireRqRp + #13 + #10;
      // Enlever le \ � la fin
      TDI_EcrireFichier(Fichier, Chaine);

      sGuid := stringReplace(TransmissionWeb.FichierRequete, '.rq', '', [rfIgnoreCase]);
      Chaine := 'GUID=' + sGuid + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);

      Chaine := 'PIECEJOINTE=' + TransmissionWeb.FichierChemin + #13 + #10;
      TDI_EcrireFichier(Fichier, Chaine);
      TDI_FermerFichier(Fichier);
// envisager autre chose pour m�moriser la requ�te
//      Tdi_CopierFichier(RepertoireRqRp + '\' + TransmissionWeb.FichierRequete,
//        TDI_RendRepertoire(TDI) + '\' + ExtractFileName(TransmissionWeb.FichierRequete));

      Result := True;
    end
    else
    begin
      Chaine := 'Impossible de cr�er la requ�te WS ' + TransmissionWeb.FichierRequete;
      MessageDlg(Chaine, mtError, [mbOk], 0);
      Result := False;
    end;
  end
  else
  begin
    Chaine := 'Impossible de trouver ' + TransmissionWeb.FichierChemin;
    MessageDlg(Chaine, mtError, [mbOk], 0);
    result := False;
  end;
end;


function CreerRequeteWSRecup(TeleProcedure: integer; RepertoireRqRp, FichierRequete,
  TypeListe, DateDeb, DateFin, Statut, SiretEmetteur: string): Boolean;
var
  Fichier: TextFile;
  Chaine: string;
  sGuid: string;
  sTeleprocedure: string;
begin
	if not FileExists (AppPath  + '\cjdc.exe ') then
  begin
  	PgiInfo ('Echec', 'Composant cjdc non trouv�');
  	Result := FALSE;
  end
  else
  if (TDI_OuvrirFichier(Fichier, '', RepertoireRqRp + '\' + FichierRequete, MODE_CREATE)) then
  begin
    Chaine := '# Infos op�ration :' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'OPERATION=RECUP' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'DATEOP=' + TDI_ObtenirDateHeure + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'PROCEDURE=';
    if Teleprocedure = TDFC then
      sTeleprocedure := 'edi-tdfc'
    else
      if Teleprocedure = TVA then
        sTeleprocedure := 'edi-tva'
    else
      if Teleprocedure = DUCS then
        sTeleprocedure := 'ducs'
    else
      if Teleprocedure = DADSU then
        sTeleprocedure := 'dadsu';

    Chaine := Chaine + sTeleprocedure + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'LIBELLE= Demande de comptes rendus ' + sTeleprocedure + ' pour le cabinet �metteur: ' + SiretEmetteur + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'COMPRESSION=ZIP' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := '# Authentification :' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'ID=' + TransmissionWeb.IdWS + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'MDP=' + TransmissionWeb.MpWS + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'URL=' + TransmissionWeb.UrlWS + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'USER=' + V_PGI.User + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := '# Chemins :' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'REPERTOIRE=' + RepertoireRqRp + #13 + #10;
      // Enlever le \ � la fin
    TDI_EcrireFichier(Fichier, Chaine);

    sGuid := stringReplace(FichierRequete, '.rq', '', [rfIgnoreCase]);
    Chaine := 'GUID=' + sGuid + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := '# Infos demande :' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'RECUPPIECES=OUI' + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'TYPELISTE=' + TypeListe + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'DATEDEB=' + DateDeb + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'DATEFIN=' + DateFin + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    Chaine := 'STATUT=' + Statut + #13 + #10;
    TDI_EcrireFichier(Fichier, Chaine);

    TDI_FermerFichier(Fichier);
    Result := True;
  end
  else
  begin
    Chaine := 'Impossible de cr�er la requ�te WS r�cup�ration ' + TransmissionWeb.FichierRequete;
    MessageDlg(Chaine, mtError, [mbOk], 0);
    Result := False;
  end;
end;


end.

