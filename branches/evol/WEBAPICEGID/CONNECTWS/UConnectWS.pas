unit UConnectWS;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,WinHttp_TLB,UTOB,HMsgBox,XMLDoc,xmlintf,
  ParamSoc,DateUtils;

type

  TconnectCEGID = class (TObject)
  private
    factive : Boolean;
    fServer : string;
    fport : integer;
    fDossier : string;
    function GetPort: string;
    procedure SetPort(const Value: string);
    procedure SetDossier(const Value: string);
    procedure SetServer(const Value: string);
    function AppelEntriesWS(TOBPiece : TOB; TheXml: WideString;var NumDocOut: Integer): Boolean;
    procedure RemplitTOBDossiers(ListeDoss : TOB;HTTPResponse : WideString);
    procedure RemplitTOBExercices(TOBexer : TOB;HTTPResponse : WideString);
  public
    constructor create;
    destructor destroy; override;
    procedure GetDossiers (var ListeDoss : TOB; var TheResponse : WideString);
    procedure GetExCpta (TOBexer : TOB);

    //
    property CEGIDServer : string read fServer write SetServer;
    property CEGIDPORT : string read GetPort write SetPort;
    property DOSSIER: string read fDossier write SetDossier;
    property IsActive : boolean read factive;
  end;


procedure RecupParamCptaFromWS;
procedure SendEntryCEGID (TOBPiece,TOBecr : TOB; Var SendCegid : boolean);

implementation
uses Hctrls,Aglinit,Hent1,db, {$IFNDEF DBXPRESS} dbtables {$ELSE} uDbxDataSet {$ENDIF};

function StringToStream(const AString: string) : Tstream;
var
  SS: TStringStream;
begin
  SS := TStringStream.Create(AString);
  try
    SS.Position := 0;
    result.CopyFrom(SS, SS.Size);  //This is where the "Abstract Error" gets thrown
  finally
    SS.Free;
  end;
end;

function DateTime2Tdate (TheDateTime : TdateTime ) : String;
var YY,MM,DD,Hours,Mins,secs,milli : Word;
begin
  DecodeDateTime(TheDateTime,YY,MM,DD,Hours,Mins,secs,Milli);
  Result := Format ('%4d-%0.2d-%0.2dT%0.2d:%0.2d:%0.2d',[YY,MM,DD,Hours,Mins,secs]);
end;

function TDate2DateTime (OneTdate : String ) : TDateTime;
var TheTDate : string;
    YYYY,MM,DD : string;
    PDATE : string;
    TheTime : string;
    IposT,II : Integer;
begin
  Result := iDate1900;
  IposT := Pos('T',OneTdate);
  if IposT>0 then
  begin
    II := 0;
    TheTDate := Copy(OneTdate,1,IPosT-1);
    TheTime := Copy(OneTdate,IposT+1,Length(OneTdate)-1);
    repeat
      PDATE := READTOKENPipe(TheTDate,'-');
      if PDATE <> '' then
      begin
        if II = 0 then
        begin
          YYYY := PDATE; Inc(II);
        end else if II = 1 then
        begin
          MM := PDATE; Inc(II);
        end else
        begin
          DD := PDATE; Inc(II);
        end;
      end;
    until PDATE='';
    if (YYYY <> '') and (MM <> '') and (DD <> '') then
    begin
      Result := StrToDateTime(DD+'/'+MM+'/'+YYYY+' '+TheTime);
    end;
  end;
end;


procedure SendEntryCEGID (TOBPiece,TOBecr : TOB; Var SendCegid : boolean);

  function EncodeDocType (TypePiece : string) : string;
  begin
    if TypePiece= 'N' then Result := 'Normal'
    else if TypePiece = 'S' then result := 'Simulation';
  end;

  function EncodeEntryType (EntryType : string) : string;
  begin
    if EntryType= 'AC' then Result := 'CustomerCredit'
    else if EntryType = 'AF'  then result := 'ProviderCredit'
    else if EntryType = 'ECC' then result := 'ExchangeDifference'
    else if EntryType = 'FC'  then result := 'CustomerInvoice'
    else if EntryType = 'FF'  then result := 'ProviderInvoice'
    else if EntryType = 'OC'  then result := 'CustomerDeposite'
    else if EntryType = 'OD'  then result := 'SpecificOperation'
    else if EntryType = 'OF'  then result := 'ProviderDeposite'
    else if EntryType = 'RC'  then result := 'CustomerPayment'
    else if EntryType = 'RF'  then result := 'ProviderPayment';
  end;

  function EncodeSens (TOBE : TOB) : string;
  begin
    if TOBE.GetDouble('E_DEBITDEV')<>0 then Result := 'Debit'
                                       else Result := 'Credit';
  end;

  function EnregistreInfoCptaY2 (TOBECr : TOB; TheNumDoc : Integer) : boolean;
  var TOBLBTP : TOB;

  begin
    Result := false;
    TOBLBTP := TOB.Create('BTPECRITURE',nil,-1);
    TRY
      TOBLBTP.SetInteger('BE0_ENTITY',TOBECr.GetInteger('E_ENTITY'));
      TOBLBTP.SetString('BE0_JOURNAL',TOBECr.GetString('E_JOURNAL'));
      TOBLBTP.SetString('BE0_EXERCICE',TOBECr.GetString('E_EXERCICE'));
      TOBLBTP.SetDateTime('BE0_DATECOMPTABLE',TOBECr.GetDateTime('E_DATECOMPTABLE'));
      TOBLBTP.SetInteger('BE0_NUMEROPIECE',TOBECr.GetInteger('E_NUMEROPIECE'));
      TOBLBTP.SetString('BE0_REFERENCEY2',IntToStr(TheNumDoc));
      TOBLBTP.InsertDB(nil);
      Result := True;
    FINALLY
      TOBLBTP.Free;
    END;
  end;

  function EncodeAmount (TOBE : TOB) : string;
  var TheMontant : double;
  begin
    if TOBE.GetDouble('E_DEBITDEV')<>0 then TheMontant := TOBE.GetDouble('E_DEBITDEV')
                                       else TheMontant := TOBE.GetDouble('E_CREDITDEV');
    Result := STRFPOINT(TheMontant);
  end;

  function EncodeDueDate(TOBE : TOB) : string;
  var TheDate : Tdatetime;
  begin
    TheDate := TOBE.GetDateTime('E_DATEECHEANCE');
    if TheDate < iDate1900 then thedate := Idate1900;
    Result := DateTime2Tdate(TheDate);
  end;

  function EncodeExternalDateReference(TOBE : TOB) : string;
  var TheDate : Tdatetime;
  begin
    TheDate := TOBE.GetDateTime('E_DATEREFEXTERNE');
    if TheDate < iDate1900 then thedate := Idate1900;
    Result := DateTime2Tdate(TheDate);
  end;

  function EncodeAxis (TOBAN : TOB) : string;
  begin
    if TOBAN.GetString('Y_AXE')='A1' then result := 'One'
    else if TOBAN.GetString('Y_AXE')='A2' then result := 'Two'
    else if TOBAN.GetString('Y_AXE')='A3' then result := 'Three'
    else if TOBAN.GetString('Y_AXE')='A4' then result := 'Four'
    else if TOBAN.GetString('Y_AXE')='A5' then result := 'Five';
  end;


  function ConstitueEntries(TOBecr : TOB) : WideString;
  var XmlDoc : IXMLDocument ;
      Root,NodeDoc,Entries,Entry,Amounts,EntryAmount,Analytics,Analytic,Sections,Setting,N1 : IXMLNode;
      TOBE,TOBAN : TOB;
      II,JJ : Integer;
      OO : widestring;
  begin
    Result := '';
    XmlDoc := NewXMLDocument();
    XmlDoc.Options := [doNodeAutoIndent];
    TRY
      Root := XmlDoc.AddChild('EntryParameter');
      NodeDoc := Root.AddChild('Document');    // <- Noeud Document ->
      // --- Sur le <document>
      N1 := NodeDoc.Addchild ('AccountingDate');
      N1.Text := DateTime2Tdate(TOBecr.detail[0].GetDateTime('E_DATECOMPTABLE'));
      N1 := NodeDoc.Addchild ('BusinessCenter');
      N1.Text := TOBecr.detail[0].GetString('E_ETABLISSEMENT');
      N1 := NodeDoc.Addchild ('Currency');
      N1.Text := TOBecr.detail[0].GetString('E_DEVISE');
      N1 := NodeDoc.Addchild ('CurrencyRate');
      N1.Text := STRFPOINT(TOBecr.detail[0].Getdouble('E_TAUXDEV'));
      N1 := NodeDoc.Addchild ('DocumentType');
      N1.Text := EncodeDocType(TOBecr.detail[0].GetString('E_QUALIFPIECE'));
      Entries := NodeDoc.Addchild('Entries'); // <- Noeud Entries ->
      for II := 0 to TOBecr.detail.count -1 do
      begin
        TOBE := TOBecr.detail[II];
        Entry := Entries.Addchild('Entry');   // <- Noeud Entry ->
        N1 := Entry.AddChild('AmountDirection');
        N1.Text := EncodeSens(TOBE);
        N1 := Entry.AddChild('ExternalDateReference');
        N1.Text := EncodeExternalDateReference(TOBE);
        N1 := Entry.AddChild('ExternalReference');
        if TOBE.GetString('E_REFEXTERNE') <> '' then N1.Text := TOBE.GetString('E_REFEXTERNE');
        N1 := Entry.AddChild('Description');
        N1.Text := TOBE.GetString('E_LIBELLE');
        N1 := Entry.AddChild('GeneralAccount');
        N1.Text := TOBE.GetString('E_GENERAL');
        N1 := Entry.AddChild('SubsidiaryAccount');
        if TOBE.GetString('E_AUXILIAIRE') <> '' then N1.Text := TOBE.GetString('E_AUXILIAIRE');
        N1 := Entry.AddChild('InternalReference');
        if TOBE.GetString('E_REFINTERNE') <> '' then N1.Text := TOBE.GetString('E_REFINTERNE');

        Amounts := Entry.AddChild('Amounts');    // <- Noeud Amounts ->

        EntryAmount := Amounts.AddChild('EntryAmount');    // <- Noeud EntryAmount ->
        N1 := EntryAmount.AddChild('Amount');
        N1.Text := EncodeAmount(TOBE);
        N1 := EntryAmount.AddChild('DueDate');
        N1.Text := EncodeDueDate(TOBE);
        N1 := EntryAmount.AddChild('Iban');
        if TOBE.GetString('E_RIB') <> '' then N1.Text := TOBE.GetString('E_RIB');
        N1 := EntryAmount.AddChild('PaymentMode');
        N1.Text := TOBE.GetString('E_MODEPAIE');
        if TOBE.GetString('E_MODEPAIE') <> '' then N1 := EntryAmount.AddChild('SepaCreditorIdentifier');
        N1.Attributes ['i:nil'] := 'True';
        N1 := EntryAmount.AddChild('UniqueMandateReference');

        Analytics := Amounts.AddChild('Analytics');    // <- Noeud Analytics> ->
        if TOBE.detail.count > 0 then
        begin
          for JJ := 0 to TOBE.Detail.count -1 do
          begin
            TOBAN := TOBE.detail[JJ];
            if TOBAN.detail.count > 0 then
            begin
              Analytic := Analytics.AddChild('EntryAnalytic');    // <- Noeud EntryAnalytic>> ->
              N1 := Analytic.AddChild('Amount');
              N1.Text := '0';
              N1 := Analytic.AddChild('Axis');
              N1.Text := EncodeAxis(TOBAN.detail[0]);
              N1 := Analytic.AddChild('Percent');
              N1.Text := STRFPOINT( TOBAN.detail[0].getdouble('Y_POURCENTAGE'));
              Sections := Analytic.AddChild('Sections');    // <- Noeud EntryAnalytic>> ->
              Sections.Attributes['xmlns:a'] := 'http://schemas.microsoft.com/2003/10/Serialization/Arrays';
              N1 := Sections.AddChild('a:string');
              N1.Text := TOBAN.detail[0].getString('Y_SECTION');
            end;
          end;
        end else
        begin
          Analytics.Attributes ['i:nil'] := 'True';
        end;
      end;
      N1 := NodeDoc.Addchild ('Journal');
      N1.Text := TOBecr.detail[0].GetString('E_JOURNAL');
      N1 := NodeDoc.Addchild ('EntryType');
      N1.Text := EncodeEntryType(TOBecr.detail[0].GetString('E_NATUREPIECE'));
      Setting := Root.AddChild('Setting');
      N1 := Setting.AddChild('AnalyticBehavior');
      N1.Text := 'Percent';
      N1 := Setting.AddChild('CurrencyBehavior');
      N1.Text := 'Known';
      N1 := Setting.AddChild('ValidationBehavior');
      N1.Text := 'Enabled';
      //
      Root.Attributes['xmlns']  := 'http://schemas.datacontract.org/2004/07/Cegid.Finance.Services.WebPortal';
      Root.Attributes['xmlns:i'] := 'http://www.w3.org/2001/XMLSchema-instance';
      //
      Result := UTF8Encode(Root.XML);
      XmlDoc.SaveToFile('C:\pgi01\XMLOUT\out.xml');
    FINALLY
      XmlDoc:= nil;
    end;
  end;


var OneConnectCEGID : TconnectCEGID;
    TheXml : WideString;
    TheRealNumDoc : Integer;
begin
  SendCegid := false;
  OneConnectCEGID := TconnectCEGID.create;
  TRY
    OneConnectCEGID.CEGIDServer := GetParamSocSecur('SO_BTWSSERVEUR','');
    OneConnectCEGID.CEGIDPORT := GetParamSocSecur('SO_BTWSCEGIDPORT','');
    OneConnectCEGID.DOSSIER := GetParamSocSecur('SO_BTWSCEGIDDOSS','');
    if OneConnectCEGID.IsActive then
    begin
      TheXml := ConstitueEntries(TOBecr);
      if TheXml <> '' then
      begin
        if OneConnectCEGID.AppelEntriesWS (TOBPiece,TheXml,TheRealNumDoc) then
        begin
          // Ecriture dans BTPECRITURE
          if EnregistreInfoCptaY2 (TOBecr,TheRealNumDoc) then SendCegid := True;
        end;
      end;
    end;

  FINALLY
    OneConnectCEGID.free;
  END;

end;




procedure RecupParamCptaFromWS;

  procedure Majexercices (TOBEx : TOB);
  var II : Integer;
      TOBE,TOBEXER,TOBEE : TOB;
  begin
    TOBEXER := TOB.Create('LES EXERCICES',nil,-1);
    TRY
      BEGINTRANS;
      TRY
        ExecuteSQL('DELETE FROM EXERCICE');
        for II := 0 to TOBEx.detail.count -1 do
        begin
          TOBE := TOBEx.detail[II];
          TOBEE := TOB.create('EXERCICE',TOBEXER,-1);
          TOBEE.SetString('EX_EXERCICE',TOBE.GetString('Id'));
          TOBEE.SetString('EX_LIBELLE',TOBE.GetString('Description'));
          TOBEE.SetString('EX_ABREGE',TOBE.GetString('ShortName'));
          TOBEE.SetDateTime('EX_DATEDEBUT',TDate2DateTime(TOBE.GetString('BeginDate')));
          TOBEE.SetDateTime('EX_DATEFIN',TDate2DateTime(TOBE.GetString('EndDate')));
          if TOBE.GetString('State')='FinalClosing' then
          begin
            TOBEE.SetString('EX_ETATCPTA','CDE');
          end else
          begin
            TOBEE.SetString('EX_ETATCPTA','OUV');
          end;
          TOBEE.SetString('EX_ETATBUDGET','OUV');
          TOBEE.SetString('EX_SOCIETE',V_PGI.CodeSociete);
          TOBEE.SetString('EX_VALIDEE','------------------------');
          TOBEE.SetDateTime('EX_DATECUM',Idate1900);
          TOBEE.SetDateTime('EX_DATECUMRUB',Idate1900);
          TOBEE.SetDateTime('EX_DATECUMBUD',Idate1900);
          TOBEE.SetDateTime('EX_DATECUMBUDGET',Idate1900);
          TOBEE.SetInteger('EX_ENTITY',0);
        end;
        if TOBEXER.DETAIL.Count > 0 then
        begin
          TOBEXER.InsertDB(nil);
        end;
        COMMITTRANS;
      EXCEPT
        ROLLBACK;
      END;
    FINALLY
      TOBEXER.Free;
    END;
  end;

  procedure GetInfoFromCegid (OneConnectCEGID : TConnectCEGID;  DateDay : Tdatetime);
  var TOBEx : TOB;
  begin
    TOBEx := TOB.Create ('LES EX CPTA',nil,-1);
    TRY
      TRY
        ExecuteSql ('INSERT INTO BTBLOCAGE '+
                    '(BTB_GUID, BTB_TYPE, BTB_IDDOC, BTB_USER, BTB_DATECREATION, BTB_HEURECREATION) '+
                    'VALUES '+
                    '("RECUPINFOCPTAWS","","","'+V_PGI.User+'","'+UsDateTime(DateDay) + '","' + USDateTime(DateDay) + '")');
        OneConnectCEGID.GetExCpta (TOBEx);
        Majexercices (TOBEx);
        ExecuteSQL('DELETE FROM BTBLOCAGE WHERE BTB_GUID="RECUPINFOCPTAWS"');
        SetParamSoc('SO_BTWSLASTSYNC',DateTimeToStr(DateDay));
      EXCEPT
      end;
    FINALLY
      TOBEx.Free;
    end;
  end;

var OneConnectCEGID : TconnectCEGID;
    finTrait : Boolean;
    NbTry : Integer;
    DateDay,LastSync,LastDate : TDateTime;
begin
  finTrait := false;
  NbTry := 1;
  DateDay := Date;
  LastSync := StrToDate(DateToStr(StrToDateTime(GetParamSocSecur('SO_BTWSLASTSYNC','31/12/20199 23:59:59'))));
  OneConnectCEGID := TconnectCEGID.create;
  TRY
    OneConnectCEGID.CEGIDServer := GetParamSocSecur('SO_BTWSSERVEUR','');
    OneConnectCEGID.CEGIDPORT := GetParamSocSecur('SO_BTWSCEGIDPORT','');
    OneConnectCEGID.DOSSIER := GetParamSocSecur('SO_BTWSCEGIDDOSS','');
    if OneConnectCEGID.IsActive then
    begin
      repeat
        TRY
          if DateDay > LastSync then
          begin
            GetInfoFromCegid (OneConnectCEGID,DateDay);
            finTrait := True;
          end else
          begin
            fintrait := true;
          end;
        except
          Sleep(1000); inc(NbTry);
        end;
      until (finTrait) or (NbTry > 30);
    end else
    begin
      ;
    end;
  FINALLY
    OneConnectCEGID.Free;
  end;
end;

{ TconnectCEGID }


function TconnectCEGID.AppelEntriesWS (TOBPiece : TOB; TheXml : WideString; var NumDocOut : Integer) : Boolean;

  procedure EnregistreEVT (TOBPiece : TOB; NumDocOut : Integer ; MessageOut : widestring);
  var TobJnal : TOB;
      Nature : string;
      BlocNote : TStringList;
      QQ : TQuery;
      NumEvt : Integer;
  begin
    Nature := RechDom('GCNATUREPIECEG', TOBPiece.GetValue('GP_NATUREPIECEG'), False);
    BlocNote := TStringList.Create;
    if NumDocOut <> 0 then
    begin
      BlocNote.Add(Nature + TraduireMemoire(' numéro ') + IntToStr(TOBPiece.GetValue('GP_NUMERO')));
      BlocNote.Add(TraduireMemoire( format('L''écriture comptable %d à été créé en comptabilité',[NumDocOut])));
    end else
    begin
      BlocNote.Add(Nature + TraduireMemoire(' numéro ') + IntToStr(TOBPiece.GetValue('GP_NUMERO')));
      BlocNote.Add('Annomalie lors du transfert');
      BlocNote.Add(TraduireMemoire('Message : ') + MessageOut);
    end;

    TobJnal := TOB.Create('JNALEVENT', nil, -1);
    TobJnal.PutValue('GEV_TYPEEVENT', 'WS');
    TobJnal.PutValue('GEV_LIBELLE', 'Liaison WebApi Fiscalité');
    TobJnal.PutValue('GEV_DATEEVENT', Date);
    TobJnal.PutValue('GEV_UTILISATEUR', V_PGI.User);
    if NumDocOut <> 0 then TobJnal.PutValue('GEV_ETATEVENT', 'OK')
                      else TobJnal.PutValue('GEV_ETATEVENT', 'ERR');
    TobJnal.PutValue('GEV_BLOCNOTE', BlocNote.Text);
    QQ := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT', True,-1, '', True);
    if not QQ.EOF then
    begin
      NumEvt := QQ.Fields[0].AsInteger;
    end;
    Inc(NumEvt);
    Ferme(QQ);
    TOBJnal.PutValue('GEV_NUMEVENT', NumEvt);
    TobJnal.InsertDB(nil);
    TobJnal.Free;
    BlocNote.Free;
  end;

  procedure  EnregistreResponse (TOBPiece : TOB; HTTPResponse: Widestring; var NumDocOut : integer);
  var XmlDoc : IXMLDocument ;
      NodeFolder,OneErr : IXMLNode;
      II,JJ : Integer;
      TOBL : TOB;
      MessageOut : string;
  begin
    NumDocOut := 0;
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
          if NodeFolder.NodeName = 'DocumentNumber' then
          begin
            NumDocOut := StrToInt(NodeFolder.NodeValue); 
          end else if NodeFolder.NodeName = 'Errors' then
          begin
            for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
            begin
              OneErr := NodeFolder.ChildNodes [JJ];
              if MessageOut = '' then MessageOut := OneErr.NodeValue
                                 else MessageOut := MessageOut + '#13#10'+ OneErr.NodeValue;
              EnregistreEVT (TOBPiece,NumDocOut,MessageOut);
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

begin
  result := false;
  url := Format('http://%s:%d/CegidFinanceWebApi/api/v1/%s/entries',[fServer,fport,fDossier]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(0); // Enable SSO
    http.Open('POST', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('Accept', 'application/xml');
    TRY
      http.Send(TheXml);
    EXCEPT
      on E: Exception do
      begin
        EnregistreResponse (TOBPiece,http.ResponseText,NumDocOut);
        ShowMessage(E.Message);
        exit;
      end;
    end;
    if http.status = 200 then
    begin
      EnregistreResponse (TOBPiece,http.ResponseText,NumDocOut);
      if NumDocOut <> 0 then result := true;
    end else
    begin
      EnregistreResponse (TOBPiece,http.ResponseText,NumDocOut);
    end;
  finally
    http := nil;
  end;


end;

constructor TconnectCEGID.create;
begin
  factive := false;
  fServer := '';
  fport := 80;
  fDossier := '';
end;

destructor TconnectCEGID.destroy;
begin

  inherited;
end;

procedure TconnectCEGID.GetDossiers(var ListeDoss: TOB; var TheResponse : WideString);
var
  http: IWinHttpRequest;
  url : string;
begin
  if fServer = '' then
  begin
    PgiInfo('LE Serveur CEGID Y2 n''est pas défini');
    Exit;
  end;
  url := Format('http://%s:%d/CegidFinanceWebApi/api/v1/folders',[fServer,fport]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(0); // Enable SSO
    http.Open('GET', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('Accept', 'application/xml,*/*');
    TRY
      http.Send(EmptyParam);
    EXCEPT
      on E: Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    END;
    if http.status = 200 then
    begin
      TheResponse := http.ResponseText;
      RemplitTOBDossiers(ListeDoss,http.ResponseText);
    end;
  finally
    http := nil;
  end;


end;

procedure TconnectCEGID.GetExCpta (TOBexer : TOB);
var
  http: IWinHttpRequest;
  url : string;
  TheResponse : WideString;
begin
  url := Format('http://%s:%d/CegidFinanceWebApi/api/v1/%s/fiscalYears',[fServer,fport,fDossier]);
  http := CoWinHttpRequest.Create;
  try
    http.SetAutoLogonPolicy(0); // Enable SSO
    http.Open('GET', url, False);
    http.SetRequestHeader('Content-Type', 'text/xml');
    http.SetRequestHeader('Accept', 'application/xml,*/*');
    http.Send(EmptyParam);
    if http.status = 200 then
    begin
      TheResponse := http.ResponseText;
      RemplitTOBExercices(TOBexer,http.ResponseText);
    end;
  finally
    http := nil;
  end;
end;

function TconnectCEGID.GetPort: string;
begin
  Result := IntToStr(fPort);
end;

procedure TconnectCEGID.RemplitTOBDossiers(ListeDoss: TOB; HTTPResponse: WideString);
var XmlDoc : IXMLDocument ;
    NodeFolder,OneStep : IXMLNode;
    II,JJ : Integer;
    TOBL : TOB;
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
        TOBL := TOB.Create('UN DOSSIER',ListeDoss,-1);
        for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
        begin
          OneStep := NodeFolder.ChildNodes.Nodes[JJ];
          TOBL.AddChampSupValeur(OneStep.NodeName,OneStep.NodeValue);
        end;
      END;
    end;
  FINALLY
  	XmlDoc:= nil;
  end;
end;

procedure TconnectCEGID.RemplitTOBExercices(TOBexer: TOB; HTTPResponse: WideString);
var XmlDoc : IXMLDocument ;
    NodeFolder,OneStep : IXMLNode;
    II,JJ : Integer;
    TOBL : TOB;
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
        TOBL := TOB.Create('UN EXERCICE',TOBexer,-1);
        for JJ := 0 to NodeFolder.ChildNodes.Count -1 do
        begin
          OneStep := NodeFolder.ChildNodes.Nodes[JJ];
          TOBL.AddChampSupValeur(OneStep.NodeName,OneStep.NodeValue);
        end;
      END;
    end;
  FINALLY
  	XmlDoc:= nil;
  end;
end;

procedure TconnectCEGID.SetDossier(const Value: string);
begin
  fDossier := Value;
  factive :=  (fServer <> '') and (fDossier <> ''); 
end;

procedure TconnectCEGID.SetPort(const Value: string);
begin
  if IsNumeric(Value) then fport := strtoint(Value);
  if fport = 0 then fPort := 80;
  factive :=  (fServer <> '') and (fDossier <> ''); 
end;

procedure TconnectCEGID.SetServer(const Value: string);
begin
  fServer := Value;
  factive :=  (fServer <> '') and (fDossier <> ''); 
end;

end.
