unit UconnectBSV;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,WinHttp_TLB,UTOB,HMsgBox,XMLDoc,xmlintf,
  ParamSoc,DateUtils,ENTGC,SHellApi,XeroTypes;

type
//  TConnectionSource = (Web, Outlook, Word, Excel, Scan, Custom, Mobile);
  TBytesStream = class(TMemoryStream);

  TArchive = class (TObject)
  private
    FName: WideString;
    FId: integer;
  published
    constructor create;
    property Name: WideString read FName write FName;
    property Id: integer read FId write FId;
  end;

  TlistArchive = class (TList)
  private
    function GetItems(Indice: integer): TArchive;
    procedure SetItems(Indice: integer; const Value: TArchive);
  public
    destructor destroy; override;
    property Items [Indice : integer] : TArchive read GetItems write SetItems;
    function Add(Item: TArchive): Integer;
    procedure raz;
  end;

  TconnectBSV = class (TObject)
  private
    fServer : string;
    fServerConnected : boolean;
    fArchiveConnected : Boolean;
    fport : integer;
    fuser : string;
    fArchive : integer;
    fcookie_session : WideString;
    fUId : WideString;
    fArchives : TlistArchive;
    //
    function GetPort: string;
    procedure SetPort(const Value: string);
    procedure SetDossier(const Value: integer);
    procedure SetServer(const Value: string);
    function CookieSession(Entree: WideString): WideString;
    function GetTempfile(Aext: string): string;
    function ConstitueTheMessageConArchive(ArchiveID: Integer): WideString;
    function GetError(HTTPresponse: WideString): string;
    function GetResponseConArchive(HTTPresponse: WideString;ArchiveId: integer): Boolean; overload;
    function GetResponseConArchive(HTTPresponse: WideString; ArchiveId: integer;var UploadRight, ViewRight: boolean): Boolean; overload;
    function SearchDocument (BSVDocumentID : WideString) : boolean;
  public
    constructor create;
    destructor destroy; override;
    //
    property connected : Boolean read fServerConnected;
    property BSVServer : string read fServer write SetServer;
    property BSVPORT : string read GetPort write SetPort;
    property User : string read fuser write fuser;
    property Archive: integer read fArchive write SetDossier;
    property LesArchives : TlistArchive read fArchives;
    procedure DisconnectUser ;
    procedure ResetCookies ;
    //
    function ConnectToServer (login: WideString; password: WideString; talkTo : Boolean=true): Boolean;
    procedure GetArchivesList ;
    function ConnectToArchive (ArchiveID : Integer;var UploadRight : Boolean; var ViewRight : boolean) : Boolean; overload;
    function ConnectToArchive (ArchiveID : Integer) : Boolean; overload;
    procedure GetTOBFieldsUpload (TOBParamsBSV : TOB);
    procedure GetTOBFieldList (TOBP : TOB);
    function GetDocumentExtFromId (BSVDocumentID : WideString) : WideString;
    function GetDocumentFromId (BSVDocumentID,Extension : WideString) : WideString;
    procedure Disconnect;
    function FinalizeNewDocument (FileName : string) : Boolean;
    function SetNumChunks (NBchunks : Integer) : boolean;
    function SendChunk (NumChunk : Integer; Base64Part : AnsiString): boolean;
    function UploadDocument (FileName : string) : boolean;
    function GetDocumentId : WideString;
    function SetFields (TOBFields,TOBPARAMBSV : TOB) : boolean;
    function SetArchiveId : boolean;
    function SetDocumentMD5Hash (FileName : string) : boolean;
    //
    function StockeThisPdf ( FileName : Widestring) : WideString;
    //
  end;

function GetParamsUserBSV (var UploadRight : Boolean; var ViewRight : boolean) : boolean;
procedure GetParamsUploadBSV (TOBParamsBSV : TOB);
procedure VisuDocumentBSV (BSVDocumentID : string);
function StoreDocumentBSV (FileName : string; TOBFields : TOB) : WideString;

implementation

uses Hctrls,Aglinit,Hent1,db, {$IFNDEF DBXPRESS} dbtables {$ELSE} uDbxDataSet,
  XeroBase64 {$ENDIF}, UdefServices, UCryptage,LicUtil;

function StoreDocumentBSV (FileName : string; TOBFields : TOB) : WideString;
var QQ : TQuery;
    XX : TconnectBSV;
    Currentpasswd : Widestring;
    TheArchive : Integer;
    TOBParamsBSV : TOB;
begin
  TheArchive := 0;
  TOBParamsBSV := TOB.Create('LES PARAMS',nil,-1);
  XX := TconnectBSV.create;
  TRY
    QQ := OpenSQL('SELECT * FROM BSVSERVER',True,1,'',true);
    TRY
      if not QQ.eof then
      begin
        XX.BSVServer := QQ.findfield('BP2_SERVERNAME').AsString;
        XX.BSVPORT := QQ.findfield('BP2_PORT').AsString;
        TheArchive := QQ.findfield('BP2_ARCHIVE').AsInteger;
      end;
    FINALLY
      ferme (QQ);
    end;
    if (XX.BSVServer='') or (XX.BSVPORT='0') or (TheArchive=0) then Exit;
    //
    Currentpasswd := AnsiLowerCase_(MD5(DeCryptageSt(V_PGI.Password)));
    Currentpasswd := FindEtReplace(Currentpasswd,'-','',true);
    if not XX.ConnectToServer(V_PGI.UserLogin,Currentpasswd,false) then Exit;
    if Not XX.ConnectToArchive(TheArchive) then Exit;
    if Not XX.SetArchiveId then Exit;

    XX.GetTOBFieldsUpload(TOBParamsBSV);

    if not XX.SetFields (TOBFields,TOBParamsBSV) then Exit;
    if not  XX.UploadDocument (FileName) then Exit;
    Result := XX.GetDocumentId;
  FINALLY
    TOBParamsBSV.free;
    XX.Disconnect;
    XX.Free;
  END;
end;


procedure VisuDocumentBSV (BSVDocumentID : string);
var QQ : TQuery;
    XX : TconnectBSV;
    Currentpasswd,Extension : Widestring;
    DocName : string;
    TheArchive : Integer;
begin
  TheArchive := 0;
  XX := TconnectBSV.create;
  TRY
    QQ := OpenSQL('SELECT * FROM BSVSERVER',True,1,'',true);
    TRY
      if not QQ.eof then
      begin
        XX.BSVServer := QQ.findfield('BP2_SERVERNAME').AsString;
        XX.BSVPORT := QQ.findfield('BP2_PORT').AsString;
        TheArchive := QQ.findfield('BP2_ARCHIVE').AsInteger;
      end;
    FINALLY
      ferme (QQ);
    end;
    if (XX.BSVServer='') or (XX.BSVPORT='0') or (TheArchive=0) then Exit;
    //
    Currentpasswd := AnsiLowerCase_(MD5(DeCryptageSt(V_PGI.Password)));
    Currentpasswd := FindEtReplace(Currentpasswd,'-','',true);
    if not XX.ConnectToServer(V_PGI.UserLogin,Currentpasswd,false) then Exit;
    if Not XX.ConnectToArchive(TheArchive) then Exit;
    Extension := XX.GetDocumentExtFromId (BSVDocumentID);
    if Extension <> '' then
    begin
      XX.SearchDocument (BSVDocumentID);
      DocName := XX.GetDocumentFromId (BSVDocumentID,Extension);
      if DocName <> '' then
      begin
        ShellExecute(0, PCHAR('open'), PChar(DocName), nil, nil, SW_SHOWNORMAL);
      end;
    end;
    XX.Disconnect;
  FINALLY
    XX.Free;
  END;
end;


procedure GetParamsUploadBSV (TOBParamsBSV : TOB);
var QQ : TQuery;
    XX : TconnectBSV;
    Currentpasswd : Widestring;
    TheArchive,II : Integer;
begin
  TheArchive := 0;
  XX := TconnectBSV.create;
  TRY
    QQ := OpenSQL('SELECT * FROM BSVSERVER',True,1,'',true);
    TRY
      if not QQ.eof then
      begin
        XX.BSVServer := QQ.findfield('BP2_SERVERNAME').AsString;
        XX.BSVPORT := QQ.findfield('BP2_PORT').AsString;
        TheArchive := QQ.findfield('BP2_ARCHIVE').AsInteger;
      end;
    FINALLY
      ferme (QQ);
    end;
    if (XX.BSVServer='') or (XX.BSVPORT='0') or (TheArchive=0) then Exit;
    //
    Currentpasswd := AnsiLowerCase_(MD5(DeCryptageSt(V_PGI.Password)));
    Currentpasswd := FindEtReplace(Currentpasswd,'-','',true);
    if not XX.ConnectToServer(V_PGI.UserLogin,Currentpasswd,false) then Exit;
    if Not XX.ConnectToArchive(TheArchive) then Exit;
    XX.GetTOBFieldsUpload(TOBParamsBSV);
    for II := 0 to TOBParamsBSV.detail.count -1 do
    begin
      if TOBParamsBSV.detail[II].GetSTring('TYPE')='list' then
      begin
        XX.GetTOBFieldList(TOBParamsBSV.detail[II]);
      end;
    end;
    XX.Disconnect;
  FINALLY
    XX.Free;
  END;

end;

function GetParamsUserBSV (var UploadRight : Boolean; var ViewRight : boolean) : boolean;
var QQ : TQuery;
    XX : TconnectBSV;
    Currentpasswd : Widestring;
    TheArchive : Integer;
begin
  TheArchive := 0;
  Result := false;
  XX := TconnectBSV.create;
  TRY
    QQ := OpenSQL('SELECT * FROM BSVSERVER',True,1,'',true);
    TRY
      if not QQ.eof then
      begin
        XX.BSVServer := QQ.findfield('BP2_SERVERNAME').AsString;
        XX.BSVPORT := QQ.findfield('BP2_PORT').AsString;
        TheArchive := QQ.findfield('BP2_ARCHIVE').AsInteger;
      end;
    FINALLY
      ferme (QQ);
    end;
    if (XX.BSVServer='') or (XX.BSVPORT='0') or (TheArchive=0) then Exit;
    //
    Currentpasswd := AnsiLowerCase_(MD5(DeCryptageSt(V_PGI.Password)));
    Currentpasswd := FindEtReplace(Currentpasswd,'-','',true);
    if not XX.ConnectToServer(V_PGI.UserLogin,Currentpasswd,false) then Exit;
    Result := true;
    XX.ConnectToArchive(TheArchive,UploadRight,ViewRight);
    XX.Disconnect;
  FINALLY
    XX.Free;
  END;
end;

{ TconnectBSV }


function TconnectBSV.GetError (HTTPresponse : WideString) : string;
var XmlDoc : IXMLDocument ;
    NodeFolder,OneNode,OneErr : IXMLNode;
    II,JJ,KK : Integer;
begin
  Result := '';
  XmlDoc := NewXMLDocument();
  TRY
    TRY
      XmlDoc.LoadFromXML(HTTPResponse);
    EXCEPT
      On E: Exception do
      begin
        PgiError('Erreur durant Chargement XML : ' + E.Message );
      end;
    end;
    if not XmlDoc.IsEmptyDoc then
    begin
      For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
      begin
        NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
        if NodeFolder.NodeName = 'soap:Body' then
        begin
          for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
          begin
            OneNode := NodeFolder.ChildNodes [JJ];
            if OneNode.NodeName = 'soap:Fault' then
            begin
              for KK := 0 to OneNode.ChildNodes.Count -1 do
              begin
                OneErr := OneNode.ChildNodes [KK];
                if OneErr.NodeName = 'faultstring' then
                begin
                  if Result = '' then result := OneErr.NodeValue;
                  break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  FINALLY
    XmlDoc:= nil;
  end;
end;

function TconnectBSV.ConstitueTheMessageConArchive(ArchiveID  : Integer) : WideString;
begin
  Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
            '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
            '<soap:Body>'+
            '<ConnectToArchive xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
            '<archiveId>%d</archiveId>'+
            '<connectionSource>%s</connectionSource>'+
            '</ConnectToArchive>'+
            '</soap:Body>'+
            '</soap:Envelope>',[archiveId,'Custom']);
  Result := UTF8Encode(Result);
end;

function TconnectBSV.GetResponseConArchive (HTTPresponse : WideString; ArchiveId : integer;var UploadRight : Boolean; var ViewRight : boolean) : Boolean; 
var XmlDoc : IXMLDocument ;
    NodeFolder,OneNode,OneDetail,OneResult,OneRight : IXMLNode;
    II,JJ,KK,LL,MM : Integer;
begin
  Result := false;
  XmlDoc := NewXMLDocument();
  TRY
    TRY
      XmlDoc.LoadFromXML(HTTPResponse);
    EXCEPT
      On E: Exception do
      begin
        PgiError('Erreur durant Chargement XML : ' + E.Message );
      end;
    end;
    if not XmlDoc.IsEmptyDoc then
    begin
      For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
      begin
        NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
        if NodeFolder.NodeName = 'soap:Body' then
        begin
          for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
          begin
            OneNode := NodeFolder.ChildNodes [JJ];
            if OneNode.NodeName = 'ConnectToArchiveResponse' then
            begin
              for KK := 0 to OneNode.ChildNodes.Count -1 do
              begin
                OneDetail := OneNode.ChildNodes [KK];
                if OneDetail.NodeName = 'ConnectToArchiveResult' then
                begin
                  for LL := 0 to OneDetail.ChildNodes.Count -1 do
                  begin
                    OneResult := OneDetail.ChildNodes[LL];
                    if OneResult.NodeName = 'Id' then result := (OneResult.NodeValue=ArchiveID)
                    else if OneResult.NodeName = 'CurrentArchiveRights' then
                    begin
                      for MM := 0 to OneResult.ChildNodes.Count -1 do
                      begin
                        OneRight := OneResult.ChildNodes[MM];
                        if OneRight.NodeName ='Upload' then UploadRight := (OneRight.NodeValue='true')
                        else if OneRight.NodeName ='OpenDocument' then ViewRight := (OneRight.NodeValue='true');
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  FINALLY
    XmlDoc:= nil;
  end;
end;

function TconnectBSV.GetResponseConArchive (HTTPresponse : WideString; ArchiveId : integer) : Boolean; 
var XmlDoc : IXMLDocument ;
    NodeFolder,OneNode,OneDetail,OneResult : IXMLNode;
    II,JJ,KK,LL : Integer;
begin
  Result := false;
  XmlDoc := NewXMLDocument();
  TRY
    TRY
      XmlDoc.LoadFromXML(HTTPResponse);
    EXCEPT
      On E: Exception do
      begin
        PgiError('Erreur durant Chargement XML : ' + E.Message );
      end;
    end;
    if not XmlDoc.IsEmptyDoc then
    begin
      For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
      begin
        NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
        if NodeFolder.NodeName = 'soap:Body' then
        begin
          for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
          begin
            OneNode := NodeFolder.ChildNodes [JJ];
            if OneNode.NodeName = 'ConnectToArchiveResponse' then
            begin
              for KK := 0 to OneNode.ChildNodes.Count -1 do
              begin
                OneDetail := OneNode.ChildNodes [KK];
                if OneDetail.NodeName = 'ConnectToArchiveResult' then
                begin
                  for LL := 0 to OneDetail.ChildNodes.Count -1 do
                  begin
                    OneResult := OneDetail.ChildNodes[LL];
                    if OneResult.NodeName = 'Id' then
                    begin
                      result := (OneResult.NodeValue=ArchiveID);
                      break;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  FINALLY
    XmlDoc:= nil;
  end;
end;


function TconnectBSV.ConnectToArchive (ArchiveID : Integer) : Boolean;
var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if not fServerConnected  then
  begin
    PgiInfo('LE Serveur BSV n''est pas connecté');
    Exit;
  end;
  url := Format(CONNECTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := ConstitueTheMessageConArchive(ArchiveId);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/ConnectToArchive');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result  := GetResponseConArchive(http.ResponseText,ArchiveID);
      if result then
      begin
        fArchiveConnected := True;
        fArchive := ArchiveID;
      end;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.ConnectToArchive(ArchiveID: Integer;var UploadRight : Boolean; var ViewRight : boolean): Boolean;
var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if not fServerConnected  then
  begin
    PgiInfo('LE Serveur BSV n''est pas connecté');
    Exit;
  end;
  url := Format(CONNECTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := ConstitueTheMessageConArchive(ArchiveId);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/ConnectToArchive');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result  := GetResponseConArchive(http.ResponseText,ArchiveID,UploadRight,ViewRight);
      if result then
      begin
        fArchiveConnected := True;
        fArchive := ArchiveID;
      end;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;


function TconnectBSV.CookieSession (Entree : WideString) : WideString;

  function FindEol (ENtree : WideString; Posdepart : integer) : Integer;
  var II : Integer;
      NextStr : string;
  begin
    Result := 0;
    for II := PosDepart to Length(Entree) do
    begin
      NextStr := '';
      if II +2 <= Length(Entree) then
      begin
        NextStr := Copy(Entree,II,2);
        if NextStr = #$D#$A then
        begin
          Result := II;
          break;
        end;
      end else break;
    end;
  end;

var IPos1,Ipos2,Ilng,X : Integer;
    TheCHaine,TheSubChaine : string;
    TheCookie,TheValue : string;
begin
  iPos1 := Pos('Set-Cookie:',Entree);
  if iPos1 > 0 then
  begin
    iPos2 := FindEol(Entree,Ipos1);
    if Ipos2 > 0 then
    begin
      Ilng := IPos2-IPos1;
      TheCHaine := Copy(Entree,IPos1,Ilng);
      TheCHaine := Copy(TheCHaine,12,Length (TheCHaine)); // enleve le 'Set-Cookie:'
      repeat
        TheSubChaine := Trim(TrimRight(READTOKENST(TheChaine)));
        if TheSubChaine <> '' then
        begin
          x := pos('=', TheSubChaine);
          if x <> 0 then
          begin
            TheCookie := copy(TheSubChaine, 1, x - 1);
            TheValue := copy(TheSubChaine, x + 1, length(TheSubChaine));
            if TheCookie = 'ASP.NET_SessionId' then Result := TheValue;
          end;
        end;
      until TheSubChaine = '';
    end;
  end;
end;


function TconnectBSV.ConnectToServer(login, password: WideString; talkTo : Boolean=true): Boolean;

  function ConstitueTheMessage(login,Password : WideString) : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<ConnectToServer xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<login>%s</login>'+
              '<password>%s</password>'+
              '<connectionSource>%s</connectionSource>'+
              '<connectionId>%s</connectionId>'+
              '</ConnectToServer>'+
              '</soap:Body>'+
              '</soap:Envelope>',[login,Password,'Custom',fUID]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : Boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    Result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'ConnectToServerResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'ConnectToServerResult' then
                  begin
                    result := (OneErr.NodeValue='true');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
  fresponse : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    if talkTo then PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(CONNECTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(login,Password);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/ConnectToServer');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        if talkTo then ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result  := GetResponse(http.ResponseText);
      fresponse := http.GetAllResponseHeaders ;
      fcookie_session := CookieSession(fresponse);
      fServerConnected := True;
      fuser := login;
    end else
    begin
      if talkTo then ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

constructor TconnectBSV.create;
var UID : TGUID;
begin
  fArchives := TlistArchive.create;
  fServer := '';
  fServerConnected := false;
  fArchiveConnected := false;
  fport := 80;
  fArchive := -1;
  fuser := '';
  if CreateGuid(UID) = S_OK then fUID := GUIDToString(UID);
end;

destructor TconnectBSV.destroy;
begin
  if fServerConnected then Disconnect;
  fArchives.Free;
  inherited;
end;

procedure TconnectBSV.Disconnect;
begin
  DisconnectUser;
  fArchives.raz;
  fcookie_session := '';
  fServerConnected := false;
  fServer := '';
  fServerConnected := false;
  fport := 80;
  fArchive := -1;
  fuser := '';
end;

procedure TconnectBSV.DisconnectUser ;

  function ConstitueTheMessage : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<Disconnect xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<login>%s</login>'+
              '<connectionSource>%s</connectionSource>'+
              '<connectionId>%s</connectionId>'+
              '</Disconnect>'+
              '</soap:Body>'+
              '</soap:Envelope>',[fuser,'Custom',fUID]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : string;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    Result := '';
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'DisconnectResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'DisconnectResult' then
                  begin
                    result := (OneErr.NodeValue);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;
var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  if fServer = '' then
  begin
    Exit;
  end;
  url := Format(CONNECTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage;
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/Disconnect');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
//      Result  := GetResponse(http.ResponseText);
//      fcookie_session := CookieSession(fresponse);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

procedure TconnectBSV.GetArchivesList;

  function ConstitueTheMessage : WideString;
  begin
    Result := '<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetArchivesList xmlns="http://ZeDOC.fr/ZeDOCNetSolution/"/>'+
              '</soap:Body>'+
              '</soap:Envelope>';
    Result := UTF8Encode(Result);
  end;

  procedure GetResponse (HTTPresponse : WideString; ArchiveList : TlistArchive) ;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,ArchivesListResult,ArchiveMinInfo : IXMLNode;
      II,JJ,KK,LL,MM : Integer;
      OneArchive : TArchive;
  begin
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetArchivesListResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  ArchivesListResult := OneNode.ChildNodes [KK];
                  if ArchivesListResult.NodeName = 'GetArchivesListResult' then
                  begin
                    for LL := 0 to ArchivesListResult.ChildNodes.Count -1 do
                    begin
                      ArchiveMinInfo := ArchivesListResult.ChildNodes [LL];
                      if ArchiveMinInfo.NodeName = 'ArchiveMinInfo' then
                      begin
                        OneArchive := TArchive.Create;
                        for MM := 0 to ArchiveMinInfo.ChildNodes.Count -1 do
                        begin
                          if ArchiveMinInfo.ChildNodes [MM].NodeName = 'Name' then OneArchive.Name := ArchiveMinInfo.ChildNodes [MM].nodeValue
                          else if ArchiveMinInfo.ChildNodes [MM].NodeName = 'Id' then OneArchive.Id := ArchiveMinInfo.ChildNodes [MM].NodeValue;
                        end;
                        if (OneArchive.Name <> '') and (OneArchive.ID <> 0) then
                        begin
                          ArchiveList.Add(OneArchive);
                        end else OneArchive.Free;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;
  
var http: IWinHttpRequest;
    url : string;
    TheXml : WideString;
begin
  if not fServerConnected then Exit;
  url := Format(OPERATIONURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage;
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetArchivesList');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      GetResponse(http.ResponseText,fArchives);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;

end;

function TconnectBSV.GetPort: string;
begin
  Result := IntToStr(fPort);
end;

procedure TconnectBSV.ResetCookies;
begin
  fcookie_session := '';
end;

procedure TconnectBSV.SetDossier(const Value: integer);
begin
  fArchive := Value;
end;

procedure TconnectBSV.SetPort(const Value: string);
begin
  if IsNumeric(Value) then fport := strtoint(Value);
  if fport = 0 then fPort := 80;
end;

procedure TconnectBSV.SetServer(const Value: string);
begin
  fServer := Value;
end;

function TconnectBSV.StockeThisPdf(FileName: Widestring): WideString;
begin
  
end;

procedure TconnectBSV.GetTOBFieldsUpload(TOBParamsBSV: TOB);

  function ConstitueTheMessage : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetArchiveFieldsOnUpload xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<archiveId>%d</archiveId>'+
              '</GetArchiveFieldsOnUpload>'+
              '</soap:Body>'+
              '</soap:Envelope>',[fArchive]);
    Result := UTF8Encode(Result);
  end;

  procedure GetResponse (HTTPresponse : WideString; ArchiveList : TlistArchive) ;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,ArchivesListResult,ArchiveMinInfo,ONEDesc : IXMLNode;
      II,JJ,KK,LL,MM : Integer;
      OneArchive : TOB;
  begin
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetArchiveFieldsOnUploadResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  ArchivesListResult := OneNode.ChildNodes [KK];
                  if ArchivesListResult.NodeName = 'GetArchiveFieldsOnUploadResult' then
                  begin
                    for LL := 0 to ArchivesListResult.ChildNodes.Count -1 do
                    begin
                      ArchiveMinInfo := ArchivesListResult.ChildNodes [LL];
                      if ArchiveMinInfo.NodeName = 'ZedocScanField' then
                      begin
                        OneArchive := TOB.Create ('ONE FIELD',TOBParamsBSV,-1);;
                        for MM := 0 to ArchiveMinInfo.ChildNodes.Count -1 do
                        begin
                          ONEDesc := ArchiveMinInfo.ChildNodes[MM];
                          OneArchive.AddChampSupValeur(ONEDesc.NodeName,ONEDesc.NodeValue);
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var http: IWinHttpRequest;
    url : string;
    TheXml : WideString;
begin
  if not fServerConnected then Exit;
  url := Format(OPERATIONURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage;
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetArchiveFieldsOnUpload');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      GetResponse(http.ResponseText,fArchives);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;

end;

procedure TconnectBSV.GetTOBFieldList(TOBP: TOB);

  function ConstitueTheMessage (FieldId : string) : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetListFieldValues xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<fieldId>%s</fieldId>'+
              '</GetListFieldValues>'+
              '</soap:Body>'+
              '</soap:Envelope>',[FieldId]);
    Result := UTF8Encode(Result);
  end;

  procedure GetResponse (HTTPresponse : WideString; TOBP : TOB) ;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,ArchivesListResult,ArchiveMinInfo : IXMLNode;
      II,JJ,KK,LL : Integer;
      UnCHoix : TOB;
  begin
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetListFieldValuesResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  ArchivesListResult := OneNode.ChildNodes [KK];
                  if ArchivesListResult.NodeName = 'GetListFieldValuesResult' then
                  begin
                    for LL := 0 to ArchivesListResult.ChildNodes.Count -1 do
                    begin
                      ArchiveMinInfo := ArchivesListResult.ChildNodes [LL];
                      UnCHoix := TOB.Create ('UN CHOIX',TOBP,-1);
                      UnCHoix.AddChampSupValeur('VALEUR',ArchiveMinInfo.NodeValue);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var http: IWinHttpRequest;
    url : string;
    TheXml : WideString;
begin
  if not fServerConnected then Exit;
  url := Format(OPERATIONURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(TOBP.GetString('ID'));
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetListFieldValues');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      GetResponse(http.ResponseText,TOBP);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;

end;

function TconnectBSV.GetDocumentExtFromId(BSVDocumentID : WideString): WideString;

  function ConstitueTheMessage(BSVDocumentID : WideString) : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetDocumentExtFromId xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<documentId>%s</documentId>'+
              '</GetDocumentExtFromId>'+
              '</soap:Body>'+
              '</soap:Envelope>',[BSVDocumentID]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : WideString;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    Result := '';
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetDocumentExtFromIdResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'GetDocumentExtFromIdResult' then
                  begin
                    TRY
                      result := OneErr.NodeValue;
                    EXCEPT
                      result := '';
                    END;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
  fresponse : WideString;
begin
  Result := '';
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(DOCUMENTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(BSVDocumentID);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetDocumentExtFromId');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result  := GetResponse(http.ResponseText);
      fresponse := http.GetAllResponseHeaders ;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.GetDocumentFromId(BSVDocumentID, Extension: WideString): WideString;

  function ConstitueTheMessage(BSVDocumentID : WideString) : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetDocumentFromId xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<documentId>%s</documentId>'+
              '<archiveId>%d</archiveId>'+
              '<lockDocument>false</lockDocument>'+
              '</GetDocumentFromId>'+
              '</soap:Body>'+
              '</soap:Envelope>',[BSVDocumentID,fArchive]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : RawByteString;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := '';
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetDocumentFromIdResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'GetDocumentFromIdResult' then
                  begin
                    result := OneErr.NodeValue;
                    Result := Base64DecodeStr (result);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
  TheStream : RawByteString;
  OneFile : TFileStream;
begin
  Result := '';
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(DOCUMENTURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(BSVDocumentID);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetDocumentFromId');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      TheStream  := GetResponse(http.ResponseText);
      Result := GetTempfile(Extension); // nom du fichier
      if TheStream <> '' then
      begin
        OneFile := TFileStream.Create(Result,fmOpenReadWrite);
        TRY
          OneFile.WriteBuffer(Pointer(TheStream)^,length(TheStream));
        FINALLY
          OneFile.Free;
        END;
      end;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.GetTempfile (Aext : string): string;
var
  Buffer: array[0..1023] of Char;
  aFile : String;
begin
  GetTempPath(Sizeof(Buffer)-1,Buffer);
  GetTempFileName(Buffer,'TMP',0,Buffer);
  SetString(aFile, Buffer, StrLen(Buffer));
  Result:=ChangeFileExt(aFile,aExt);
  RenameFile(aFile,Result);
end;

function TconnectBSV.GetDocumentId: WideString;

  function ConstitueTheMessage : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<GetDocumentId xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<connectionId>%s</connectionId>'+
              '</GetDocumentId>'+
              '</soap:Body>'+
              '</soap:Envelope>',[fUID]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : WideString;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := '';
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'GetDocumentIdResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'GetDocumentIdResult' then
                  begin
                    result := OneErr.NodeValue;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := '';
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage;
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/GetDocumentId');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := GetResponse(http.ResponseText);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.UploadDocument(FileName: string): boolean;

  function ArrayToString(const a: array of Char): string;
  begin
    if Length(a)>0 then
      SetString(Result, PChar(@a[0]), Length(a))
    else
      Result := '';
  end;

const chunkSize = 1320000;
var NbChunks : Integer;
    TheMemFile : TmemoryStream;
    II : Integer;
    realSize,MaxSize,BuffSize,TrfSize : Integer;
    TT : PAnsiChar;
    PP : array of char;
    TheBlockO,TheBlockI : AnsiString;
begin
  Result := false;
  TheMemFile := TmemoryStream.Create;
  TRY
    TheMemFile.LoadFromFile(FileName);
    if TheMemFile.Size = 0 then Exit;
    realSize := TheMemFile.Size;
    if TheMemFile.Size > chunkSize then
    begin
      if (TheMemFile.Size mod chunkSize) > 0 then NbChunks := (TheMemFile.Size div chunkSize) +1
                                             else NbChunks := (TheMemFile.Size div chunkSize);
    end else NbChunks := 1;
    //
    if NbChunks = 0 then Exit;
    if not SetNumChunks (NbChunks) Then Exit;
    //
    TrfSize := 0;
    MaxSize := TheMemFile.Size;
    if MaxSize < chunkSize then BuffSize := MaxSize else Buffsize := chunkSize;
    TheMemFile.Position := 0;
    for II := 0 to NbChunks -1 do
    begin
      if TrfSize > MaxSize then break;
      SetLength(PP,BuffSize);
      realSize := TheMemFile.Read(PP[0],BuffSize);
      SetLength(PP,realSize);
      TheBlockO := Base64EncodeStr(string(Copy(PP,0,Length(PP))));
      if not SendChunk (II,TheBlockO) then Exit;
      TrfSize := TrfSize + Buffsize;
      if TrfSize < MaxSize then BuffSize := chunkSize else BuffSize := MaxSize - trfSize;
    end;
  finally
    TheMemFile.free;
  end;
  if not SetDocumentMD5Hash (FileName) then Exit;
  if not FinalizeNewDocument (FileName) then exit;
  result := true;
end;

function TconnectBSV.SetFields(TOBFields,TOBPARAMBSV: TOB): boolean;

  function ConstitueTheMessage(TOBFields,TOBPARAMBSV : TOB) : WideString;
  var II : Integer;
      TOBL,TOBP : TOB;
  begin
    Result := '<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<SetFields xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<fields>';
    for II := 0 to TOBFields.Detail.Count -1 do
    begin
      TOBL := TOBFields.Detail[II];
      TOBP := TOBPARAMBSV.findfirst(['ID'],[TOBL.GetString('BP3_CODE')],true); if TOBP = nil then continue;
      Result := Result +
                format('<FieldMinInfo>'+
                '<Name>%s</Name>'+
                '<Id>%d</Id>'+
                '<Value>%s</Value>'+
                '<Type>%s</Type>'+
                '<Invisible>%s</Invisible>'+
                '<Mask>%s</Mask>'+
                '<OpenList>%s</OpenList>'+
                '<ListPath>%s</ListPath>'+
                '<IsOdbcLinkAffectedOnChange>%s</IsOdbcLinkAffectedOnChange>'+
                '<IsOdbcLinkAffectedOnLoad>%s</IsOdbcLinkAffectedOnLoad>'+
                '<OdbcLinkQuery></OdbcLinkQuery>'+
                '<OdbcLinkId></OdbcLinkId>'+
                '<TriggerFieldId></TriggerFieldId>'+
                '<ListMaximumSelectableValueNumber>%s</ListMaximumSelectableValueNumber>'+
                '<alphabetical_list_sort_on_upload>%s</alphabetical_list_sort_on_upload>'+
                '<Required>true</Required>'+
                '</FieldMinInfo>',
                [
                TOBL.GetString('BP3_LIBELLE'),
                TOBL.GetInteger('BP3_CODE'),
                TOBL.GetString('BP3_VALEUR'),
                TOBP.GetString('TYPE'),
                TOBP.GetString('INVISIBLE'),
                TOBP.GetString('MASK'),
                TOBP.GetString('OPENLIST'),
                TOBP.GetString('LISTPATH'),
                TOBP.GetString('ISODBCLINKAFFECTEDONCHANGE'),
                TOBP.GetString('ISODBCLINKAFFECTEDONLOAD'),
                TOBP.GetString('LISTMAXIMUMSELECTABLEVALUENUMBER'),
                TOBP.GetString('ALPHABETICALLISTSORTONUPLOAD')
                ]);

    end;
    Result := Result + Format('</fields>'+
              '<connectionId>%s</connectionId>',[fUId]);
    Result := Result+'</SetFields>'+
              '</soap:Body>'+
              '</soap:Envelope>';
    Result := UTF8Encode(Result);
  end;

var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(TOBFields,TOBPARAMBSV);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/SetFields');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := True;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.SearchDocument(BSVDocumentID: WideString): boolean;

  function ConstitueTheMessage (BSVDocumentID : string) : WideString;
  begin
    Result := Format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<Search xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<query>interDBZEDOC contains(%s)</query>'+
              '<archiveId>%d</archiveId>'+
              '</Search>'+
              '</soap:Body>'+
              '</soap:Envelope>',[BSVDocumentID,fArchive]);
    Result := UTF8Encode(Result);
  end;

var http: IWinHttpRequest;
    url : string;
    TheXml : WideString;
begin
  Result := false;
  if not fServerConnected then Exit;
  url := Format(OPERATIONURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(BSVDocumentID);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/Search');
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      result := True;
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;

end;

function TconnectBSV.SetNumChunks (NBchunks : Integer) : boolean;

  function ConstitueTheMessage(NbChunks : integer) : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<SetNumChunks xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<numChunks>%d</numChunks>'+
              '<connectionId>%s</connectionId>'+
              '</SetNumChunks>'+
              '</soap:Body>'+
              '</soap:Envelope>',[NbChunks,fUId]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString) : boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'SetNumChunksResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'SetNumChunksResult' then
                  begin
                    result := (OneErr.NodeValue='true');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(NbChunks);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/SetNumChunks');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := Getresponse(http.ResponseText);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.SendChunk(NumChunk: Integer;Base64Part: AnsiString): boolean;

  function ConstitueTheMessage(NumChunk : integer; Base64Part :AnsiString ) : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<SendChunk xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<ChunkNumber>%d</ChunkNumber>'+
              '<ChunkBuffer>%s</ChunkBuffer>'+
              '<connectionId>%s</connectionId>'+
              '</SendChunk>'+
              '</soap:Body>'+
              '</soap:Envelope>',[NumChunk,Base64Part,fUID]);
    Result := UTF8Encode(Result);
  end;
  
  function GetResponse (HTTPresponse : WideString) : boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'SendChunkResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'SendChunkResult' then
                  begin
                    result := (OneErr.NodeValue='true');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage(NumChunk,Base64Part);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/SendChunk');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := GetResponse(http.ResponseText);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.FinalizeNewDocument(FileName: string): Boolean;

  function ConstitueTheMessage(ErrorMessage,FileName: string) : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<FinalizeNewDocument xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<ErrorMessage>%s</ErrorMessage>'+
              '<documentName>%s</documentName>'+
              '<doOcr>false</doOcr>'+
              '<connectionId>%s</connectionId>'+
              '</FinalizeNewDocument>'+
              '</soap:Body>'+
              '</soap:Envelope>',[ErrorMessage,FileName,fUId]);
    Result := UTF8Encode(Result);
  end;

  function GetResponse (HTTPresponse : WideString; var ResponseErr : string) : boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'FinalizeNewDocumentResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'FinalizeNewDocumentResult' then
                  begin
                    result := OneErr.NodeValue;
                  end else if OneErr.NodeName = 'ErrorMessage' then
                  begin
                    if OneErr.NodeValue <> null then ResponseErr := OneErr.NodeValue;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;

var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
  ErrorMessage : string;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage('',ExtractFileName(FileName));
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/FinalizeNewDocument');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result  := GetResponse(http.ResponseText, ErrorMessage);
      if not Result then ShowMessage(ErrorMessage);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.SetArchiveId: boolean;

  function ConstitueTheMessage : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<SetArchiveId xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<archiveId>%d</archiveId>'+
              '<connectionId>%s</connectionId>'+
              '</SetArchiveId>'+
              '</soap:Body>'+
              '</soap:Envelope>',[fArchive,fUID]);
    Result := UTF8Encode(Result);
  end;
  
  function GetResponse (HTTPresponse : WideString) : boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'SetArchiveIdResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'SetArchiveIdResult' then
                  begin
                    result := (OneErr.NodeValue='true');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var
  http: IWinHttpRequest;
  url : string;
  TheXml : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage;
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/SetArchiveId');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := GetResponse(http.ResponseText);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

function TconnectBSV.SetDocumentMD5Hash(FileName: string): boolean;

  function ConstitueTheMessage (TheMd5File : string) : WideString;
  begin
    Result := format('<?xml version="1.0" encoding="utf-8"?>'+
              '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">'+
              '<soap:Body>'+
              '<SetDocumentMD5Hash xmlns="http://ZeDOC.fr/ZeDOCNetSolution/">'+
              '<hash>%s</hash>'+
              '<connectionId>%s</connectionId>'+
              '</SetDocumentMD5Hash>'+
              '</soap:Body>'+
              '</soap:Envelope>',[TheMd5File,fUID]);
    Result := UTF8Encode(Result);
  end;
  
  function GetResponse (HTTPresponse : WideString) : boolean;
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneNode,OneErr : IXMLNode;
      II,JJ,KK : Integer;
  begin
    result := false;
    XmlDoc := NewXMLDocument();
    TRY
      TRY
        XmlDoc.LoadFromXML(HTTPResponse);
      EXCEPT
        On E: Exception do
        begin
          PgiError('Erreur durant Chargement XML : ' + E.Message );
        end;
      end;
      if not XmlDoc.IsEmptyDoc then
      begin
        For II := 0 to Xmldoc.DocumentElement.ChildNodes.Count -1 do
        begin
          NodeFolder := XmlDoc.DocumentElement.ChildNodes[II]; // Liste des <Folder>
          if NodeFolder.NodeName = 'soap:Body' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneNode := NodeFolder.ChildNodes [JJ];
              if OneNode.NodeName = 'SetDocumentMD5HashResponse' then
              begin
                for KK := 0 to OneNode.ChildNodes.Count -1 do
                begin
                  OneErr := OneNode.ChildNodes [KK];
                  if OneErr.NodeName = 'SetDocumentMD5HashResult' then
                  begin
                    result := (OneErr.NodeValue='true');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var
  http: IWinHttpRequest;
  url : string;
  TheXml,fMd5File : WideString;
begin
  Result := false;
  if fServer = '' then
  begin
    PgiInfo('LE Serveur BSV n''est pas défini');
    Exit;
  end;
  fMd5File := MD5File(FileName);
  url := Format(UPLOADURL,[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(2); // Disable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('charset', 'utf8');
    http.SetRequestHeader('Accept', 'text/xml,*/*');
    TheXml := constitueTheMessage (fMd5File);
    http.SetRequestHeader('Content-Length',IntToStr(length(TheXml)));
    http.SetRequestHeader('Cookie','ASP.NET_SessionId='+fcookie_session);
    http.SetRequestHeader('SOAPAction','http://ZeDOC.fr/ZeDOCNetSolution/SetDocumentMD5Hash');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      Result := GetResponse(http.ResponseText);
    end else
    begin
      ShowMessage(GetError(http.ResponseText));
    end;
  finally
    http := nil;
  end;
end;

{ TlistArchive }

function TlistArchive.Add(Item: TArchive): Integer;
begin
	Result := inherited add(Item);
end;


procedure TlistArchive.raz;
var indice : integer;
begin
  if count > 0 then
  begin
    for Indice := count -1 downto 0 do
    begin
       TArchive (Items [Indice]).free;
       Items[Indice] := nil;
       Delete(Indice);
    end;
    Pack;
  end;
end;

destructor TlistArchive.destroy;
begin
  raz;
  inherited;
end;

function TlistArchive.GetItems(Indice: integer): TArchive;
begin
  result := TArchive(Inherited Items[Indice]);
end;


procedure TlistArchive.SetItems(Indice: integer; const Value: TArchive);
begin
  Inherited Items[Indice]:= Value;
end;

{ TArchive }

constructor TArchive.create;
begin
  FName := '';
  fID := 0;
end;

end.
