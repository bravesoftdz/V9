unit UtilEnvoieMail;

interface
uses Dialogs,SysUtils,WinInet,types,classes,StdCtrls,IdMessage, IdSMTP,IdGlobal, IdTCPClient, IdHeaderList;

function isConnexionOk: Boolean;
function SMTPSendMail (AdrFrom,Adrto,AdrCpy : string; Body : Tmemo ; SmtpAdr,SmtpPort,Smtpuser, Smtppassw : string; WithAutentification : boolean) : Boolean;

implementation

function isConnexionOk: Boolean;
var
  dwFlags: DWord;
begin
  dwFlags := INTERNET_CONNECTION_MODEM or INTERNET_CONNECTION_LAN or INTERNET_CONNECTION_PROXY;
  Result := InternetGetConnectedState(@dwFlags, 0);
end;

function SMTPSendMail (AdrFrom,Adrto,AdrCpy : string; Body : Tmemo ; SmtpAdr,SmtpPort,Smtpuser, Smtppassw : string; WithAutentification : boolean) : Boolean;
var
  XIdMessage: TIdMessage;
  IdSMTP: TIdSMTP;
  MessageSt: TStrings;
  i: Integer;
  Fichiers: Array Of String;
begin
  Result := false;
  XIdMessage := TIdMessage.Create(nil); //cr�ation dynamique du composant

  XIdMessage.From.Address := AdrFrom;

  //Ces deux lignes peuvent-�tre r�p�t�es autant de fois que vous d�sirez
  //d'adresse de r�ponse et/ou de destinataire
  XIdMessage.ReplyTo.Add.Address := AdrFrom;
  XIdMessage.Recipients.Add.Address := Adrto;
  XIdMessage.Recipients.Add.Address := AdrFrom;
  XIdMessage.Subject := 'Confirmation d''arret d''utilisation';
  XIdMessage.ContentType := 'multipart/alternative'; //Message 'd�coup�' en plusieurs parties

  MessageSt := Body.Lines; //par exemple... il faut juste que ce soit un TStrings !

  //Ici on va cr�er les diff�rentes parties du message
  //Au cas o� le client ne g�re pas les messages HTML :
  With TIdText.Create(XIdMessage.MessageParts, MessageSt) Do
  Begin
    ContentType := 'text/plain';
    Body.Insert(0, 'Ce message est un message HTML. Configurez votre client de courrier �lectronique' +
   'pour le visionner de mani�re appropri�e');
  end;

  //Ajout du message au format HTML (en supposant que Message contient du HTML) :
  with TIdText.Create(XIdMessage.MessageParts, MessageSt) do
    ContentType := 'text/html';

  //Et maintenant, l'ajout des pi�ces jointes :
  //Le tableau de strings Fichiers doit �tre remplis avec les chemins complets des fichiers � inclure
  for i := Low(Fichiers) to High(Fichiers) do
    TIdAttachment.Create(XIdMessage.MessageParts, Fichiers[i]);

  //On passe ensuite � l'envoi du message:
  IdSMTP := TIdSMTP.Create(nil) ; //Cr�ation dynamique du composant

  IdSMTP.Port := StrtoInt(SmtpPort); //Le port SMTP standard...
  IdSMTP.Host := SmtpAdr;  //Le serveur auquel se connecter
  if WithAutentification then
  begin
    IdSMTP.Username := Smtpuser;
    IdSMTP.Password  := Smtppassw;
  end;

  //Ensuite on se connecte et on envoit le message, en g�rant les erreurs, tant qu'� faire !
  Try
    Try
      IdSMTP.Connect;
      IdSMTP.Send(XIdMessage);
      Result := True;
    except
      on e: exception do MessageDlg(e.Message, mtError, [mbOK], 0);
    end;
  finally
    IdSMTP.Disconnect;
    IdSMTP.Free;
    XIdMessage.Free;
  end;

end;

end.
