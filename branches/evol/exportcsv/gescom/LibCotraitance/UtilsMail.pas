{***********UNITE*************************************************
Auteur  ...... : Franck VAUTRAIN
Créé le ...... : 19/07/2011
Modifié le ... :   /  /    
Description .. : Classes de gestion des Mails
Suite ........ : reformatage des paramètres Mail
Suite ........ : envoi du mail en auto
Suite ........ : contrôle des info de l'envoi
Mots clefs ... : RAPPORT; ERREUR; MAIL
*****************************************************************}
unit UtilsMail;

interface

uses  StdCtrls,
      Controls,
      Classes,
      forms,
      sysutils,
      ComCtrls,
      HCtrls,
      HEnt1,
      Windows,
      {$IFNDEF EAGLCLIENT}
      db,
       {$IFNDEF DBXPRESS}
       dbTables,
       {$ELSE}
       uDbxDataSet,
       {$ENDIF}
      {$ELSE}
      HDB,
      {$ENDIF}
      HMsgBox,
      HRichOLE,
      CBPPath,
      Printers,
      uTOB,
      AglMail,
      MailOl,
      //HTB97;
      ULibWindows,
      UtilFichiers,
      UtilsContacts,
      Utilsrapport,
      variants,
      TiersUtil;

Type
    TGestionMail = class(Tobject)
    private
      fSujet           : HString;
      fCorps           : HTStringList;
      fResultMailForm  : TResultMailForm;
      fDestinataire    : String;
      fCopie           : String;
      fFichiers        : String;
      fTypeDoc         : String;    //XLS : Excel; DOC : WORLD
      fTypeContact     : string;   //'CLI' : client, 'FOU' : Fournisseur, '' : Contact
      fFilesSource     : String;
      fFilesTempo      : String;
      fFournisseur     : String;
      fTiers           : String;
      fContact         : String;
      fAffaire         : String;
      fLblErreur       : String;
      fQualifMail      : String;   //DDE : Demande de prix; COT : Cotraitance; SST : Ss-Traitance; MOE : Maitre d'Oeuvre
      fGestionParam    : Boolean;
      fTobRapport      : TOB;      //Tob de transfert avec l'ensemble des zones à vérifier
    //
      RechContact      : TGestionContact;
    //
      function ControleExistFile : boolean;
      function GetEmail: string;
      function RecupZoneTravail(ZoneChaine: string; TOBTravail: TOB): string;
    //
    public
      constructor Create(Sender : Tobject);
      destructor  Destroy; override;
      //Déclaration des propriété de la classe
      property Sujet           : HString         read fsujet          write fsujet;
      property Corps           : HTStringList    read fcorps          write fcorps;
      property ResultMailForm  : TResultMailForm read fresultMailForm write fResultMailForm;
      property Destinataire    : String          read fdestinataire   write fDestinataire;
      property Copie           : String          read fCopie          write fCopie;
      property Fichiers        : String          read fFichiers       write fFichiers;
      property TypeDoc         : String          read fTypeDoc        write fTypeDoc;
      property TypeContact     : String          read fTypeContact    write fTypeContact;
      property FichierSource   : String          read fFilesSource    write fFilesSource ;
      property FichierTempo    : String          read fFilesTempo     write fFilesTempo;
      property Fournisseur     : String          read fFournisseur    write fFournisseur;
      property Tiers           : String          read fTiers          write fTiers;
      property Contact         : String          read fContact        write fContact;
      property Affaire         : String          read fAffaire        write fAffaire;
      property LblErreur       : String          read fLblErreur      write fLblErreur;
      Property QualifMail      : String          read fQualifMail     write fQualifMail;
      property GestionParam    : Boolean         read fGestionParam   write fGestionParam;
      property TobRapport      : TOB             read fTOBRapport     write fTobRapport;
      //
      procedure CopySourcesurTempo;
      procedure AppelEnvoiMail;
      //
    end;

implementation
uses StrUtils;


//création de la classe et création
constructor TGestionMail.Create(sender : Tobject);
begin

  fSujet            := Sujet;
  fCorps            := Corps;
  fResultMailForm   := ResultMailForm;
  fDestinataire     := Destinataire;
  fCopie            := Copie;
  fFichiers         := Fichiers;
  fTypeDoc          := TypeDoc;
  fTypeContact      := TypeContact;
  fFilesSource      := FichierSource;
  fFilesTempo       := FichierTempo;
  fFournisseur      := fournisseur;
  fTiers            := Tiers;
  fContact          := Contact;
  fGestionParam     := False;
  fAffaire          := Affaire;
  fQualifMail       := QualifMail;
  fTobRapport       := TobRapport;

end;

function TGestionMail.ControleExistFile : boolean;
begin

  Result := False;

  if (fTypeContact = 'CLI') AND (fTiers = '') then Exit;
  if (fTypeContact = 'FOU') AND (fFournisseur = '') then Exit;

  if FileExists(FichierTempo) then
  begin
    fichiers := FichierTempo + ';';
    Result := True;
  end;

end;

procedure TGestionMail.CopySourcesurTempo;
begin

  //envoie du fichiers principal dans fichier tempo
  CopyFile(PChar(FichierSource), Pchar(FichierTempo), False);

end;

procedure TGestionMail.AppelEnvoiMail;
Var Rapport : TGestionRapport;
    ecran   : Tform;
    LineSave      : String;
    ZoneChaine    : string;
    ValeurChaine  : string;
    iInd          : Integer;
    DebZone       : Integer;
    FinZone       : Integer;
    TailleZone    : Integer;
    MsgErreur     : String;
    TitreMsg      : String;
begin

  Corps.Clear;
  MsgErreur := '';
  TitreMsg := '';

  if Destinataire = '' then Destinataire := GetEmail;

  //recherche des mails paramétrés !!!!!!!!!!
  Rapport := TGestionRapport.Create(ecran);
  Rapport.Titre   := Sujet;
  Rapport.Close   := True;
  Rapport.Sauve   := False;
  Rapport.Print   := False;
  Rapport.TableID := 'MAI';

  if not ControleExistFile then
    MsgErreur := TraduireMemoire('Aucun fichier à envoyer ' + FichierTempo + ' vérifiez les chemins d''accès');

  if QualifMail = 'DDE' then
  begin
    TitreMsg := TraduireMemoire('Demande de Prix Fournisseur');
    Rapport.Qualif  := 'DDE';
    Rapport.IDLienOLE := '{385F1E5C-ACBE-4A3D-831B-DCE91F46D8CE}';
  end
  else if QualifMail = 'COT' then
  begin
    TitreMsg := TraduireMemoire('Appel d''offre Cotraitant');
    Rapport.Qualif  := 'COT';
    Rapport.IDLienOLE := '{C1017EFA-0310-4191-AD5B-E426474F2213}';
  end
  else if QualifMail = 'SST' then
  begin
    TitreMsg := TraduireMemoire('Appel d''offre sous-Traitant');
    Rapport.Qualif  := 'COT';
    Rapport.IDLienOLE := '{36786D50-0540-4F8D-80D7-C8EF7CF75FDA}';
  end
  else if QualifMail = 'MOE' then
  begin
    TitreMsg := TraduireMemoire('Appel d''offre Maitre d''oeuvre');
    Rapport.Qualif  := 'COT';
    Rapport.IDLienOLE := '{244CD969-802F-42C0-BA3B-44E4ED339CB5}';
  end;

  if MsgErreur <> '' then pgiinfo(MsgErreur, TitreMsg);

  //
  if fGestionParam then Rapport.ChargeRapportLo;

  Sujet := rapport.Libelle;
  if Sujet = '' then  Sujet := 'Envoi automatique de Mail';

  //contrôle corps rapport !!!!
  For iInd := 0 to Rapport.Memo.Lines.count do
  begin
    LineSave  := Rapport.Memo.lines[iInd];
    While Pos('[', LineSave) <> 0 do
    begin
      DebZone    := pos('[' , LineSave );
      FinZone    := pos(']' , LineSave );
      TailleZone := FinZone - DebZone;
      ZoneChaine := copy(LineSave, DebZone, TailleZone + 1);
      if assigned(TobRapport) then
      begin
        ValeurChaine := RecupZoneTravail(copy(ZoneChaine, 2, TailleZone-1), TobRapport);
        //if ValeurChaine = '' then
        //  LineSave := AnsiReplaceText(LineSave, ZoneChaine, '<Erreur>')
        //else
        LineSave := AnsiReplaceText(LineSave, ZoneChaine, ValeurChaine);
      end
      else
        LineSave := AnsiReplaceText(LineSave, ZoneChaine, ' ');
    end;
    corps.Add(LineSave);
  end;

  if ((Length(Corps.Text) = 0) or (Corps.Text = '')) or (Corps.Text = #$D#$A) then
  begin
    Corps.Clear;
    Corps.add ('Bonjour');
    Corps.add ('');
    Corps.add ('');
    Corps.add ('');
    Corps.add ('Cordialement');
  end;

	ResultMailForm := AglMailForm(fSujet,fdestinataire,fcopie,Corps,ffichiers,false);

  if ResultMailForm = rmfOkButNotSend then SendMail(fSujet,fdestinataire,fCopie,Corps,ffichiers,True,1, '', '');

  corps.Clear;

end;

//traduction de la chaine venant de la tob
function TGestionMail.RecupZoneTravail(ZoneChaine : string; TOBTravail : TOB) : string;
begin

  Result := '';

  if TOBTravail.FieldExists(ZoneChaine) then
    Result := TOBTravail.GetValue(ZoneChaine)
  else
    Result := '<Erreur>';
    
  if VarisNull(result) or (VarAsType(result,VarString)=#0) then result := '';

end;

function TGestionMail.GetEmail : string;
begin

  LblErreur := 'Récupération de l''adresse Mail...';

  //chargement de l'outil recherche contact
  RechContact := TGestionContact.Create(Self);

  RechContact.QualifMail      := QualifMail;
  Rechcontact.CleDocNatPiece  := TobRapport.GetString('GP_NATUREPIECEG');
  Rechcontact.CleDocsouche    := TobRapport.GetString('GP_SOUCHE');
  Rechcontact.CleDocNumPiece  := TobRapport.GetString('GP_NUMERO');

  RechContact.Contact         := Contact;

  //chargement des zones outil
  if fTypeContact = 'CLI' then       //Client
  begin
    RechContact.Contact       := '';
    Rechcontact.TypeTiers     := 'CLI';
    RechContact.Tiers         := Tiers;
  end
  else if fTypeContact = 'FOU' then  //Fournisseur
  begin
    RechContact.Contact       := '';
    Rechcontact.TypeTiers     := 'FOU';
    RechContact.Tiers         := Fournisseur;
  end;

  RechContact.Auxiliaire    := TiersAuxiliaire(RechContact.Tiers);
  Rechcontact.LibelleTiers  := '';
  RechContact.Numtel        := '';
  RechContact.Part          := '-';
  RechContact.Affaire       := Affaire;

	result := '';

  if RechContact.Contact <> '' then
    RechContact.lectureMailContact
  else
  begin
    Rechcontact.RechercheContact;
    if RechContact.Contact <> '' then RechContact.lectureMailContact;
  end;

  if RechContact.Mail = '' then RechContact.LectureMailTiers;

  Result := RechContact.Mail;

  FreeAndNil(RechContact);

  LblErreur := '';

end;


destructor TGestionMail.Destroy;
begin


inherited;
end;

end.
