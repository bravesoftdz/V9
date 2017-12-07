{----------------------------------------------------------------}
{ DELPHP - Sub0 - Developpez.com - 07/10/06                      }
{----------------------------------------------------------------}
{                                                                }
{ Interaction entre Delphi et PHP / MySQL                        }
{ Class pour effectuer des requêtes http (post)                  }
{ • Ajoût des sessions pour l'identification                     }
{ • Ajoût des chaines délimiteurs des données                    }
{ • Ajoût téléchargement de données binaires                     }
{ • Modification LS 01/09/2011  Adaptation au nouveaux composant ICS V7}
{                                                                }
{----------------------------------------------------------------}

Unit DelphpUnit;
Interface
Uses Windows, SysUtils, Forms, Classes, OverbyteIcsHttpProt, mmSystem, Math,HGauge,
StdCtrls,uTOB,HTB97,Hctrls
;

Type
  tMethodEchange = (tMePost,TmeGet);

  THttpPost = Class(THttpCli)
    Private
      IsBinaryData: Boolean;
      StartTime: Integer;
      fGauge : TEnhancedGauge;
      fMethod : tMethodEchange;
      fTB : TToolWindow97;
      fMemo : Tmemo;
      fTobresult : TOb;
      fChamps : TStringList;
      Procedure DocDataProc(Sender: TObject; Buffer: Pointer; Len: Integer);
      Procedure RequestDoneProc(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
      Procedure CookieProc(Sender: TObject; Const Data: String; Var Accept: Boolean);
      procedure AddError (TheError : string);
      procedure AffecteResultToTOB;
      procedure MemoriseChamps;
      procedure Definivaleurs (Ligne : Integer);
    Public
      ChampsSaisie: TStrings;
      Completed: Boolean;
      MaxTimeOut: Integer;
      CurTimeOut: Integer;
      StringError: AnsiString;
      StringResult: AnsiString;
      Constructor Create(AOwner: TComponent); Override;
      Destructor Destroy; Override;
      property Gauge : TEnhancedGauge read fGauge write fGauge;
      property MethodeAcces :tMethodEchange read fMethod write fMethod ;
      Procedure ResetPost;
      Procedure AddPost(PostName, PostValue: String);
      Procedure StartPost(BinaryData: Boolean = False);
      Procedure StopPost;
    	function HttpPost(BinaryData: Boolean): Boolean;
      Function IsCompleted: Boolean;
  End;

  Procedure StrExplode(Const s, sep: String; list: TStrings);
  Function StripTags(Const sin: String): String;
  Function AddSlashes(Const st: String): String;
  Function MyUrlEncode(Const st: String): String;
  Function MyUrlDecode(Const st: String): String;
  Function SizeToStr(Const Size: Int64): String;


{----------------------------------------------------------------}
{                                                                }
{                       }IMPLEMENTATION{                         }
{                                                                }
{----------------------------------------------------------------}
uses OverbyteIcsHttpSrv;

Const DelimitData = '·¤·';       { Délimiteur des données reçues }


{----------------------------------------------------------------}
{ CONVERSION D'UNE CHAINE EN LISTE DE CHAINE                     }
{----------------------------------------------------------------}
Procedure StrExplode(Const s, sep: String; list: TStrings);
Var x, l: Integer;
    st: String;
Begin
  l := Length(s);
  If (l <= 0) Then Exit;
  x := 1;
  st := '';
  Repeat
    If (s[x] = sep) Then Begin
      list.Add(st);
      st := '';
    End Else st := st + s[x];
    inc(x);
  Until (x > l);
  If (st <> '') Then list.Add(st);
End;


{----------------------------------------------------------------}
{ RETIRE LES BALISES HTML DU TEXTE                               }
{----------------------------------------------------------------}
Function StripTags(Const sin: String): String;
Var
  x: Integer;
  istag: Boolean;
  newst, curtag, restmp: String;
Begin
  Result := sin;
  restmp := sin;
  istag := False;
  curtag := '';
  Try
    For x := 1 To Length(sin) Do Begin
      If (sin[x] = '<') And (istag = false) Then istag := true Else
      If (sin[x] = '>') And (istag = true) Then
      Begin
        istag := false;
        If (curtag = 'BR') Or (curtag = 'BR/') Or (curtag = 'BR /') Then
        begin
          newst := newst + #13#10;
        end else if (curtag = 'TAB') Or (curtag = 'TAB/') Or (curtag = 'TAB /') Then
        begin
          newst := newst + ';';
        end;
        curtag := '';
      End Else if (istag) then
      begin
        curtag := curtag + UpperCase(sin[x]);
      end else if (istag = false) Then
      begin
      	newst := newst + sin[x]
      end;
    End;
    Result := newst;
  Except
  End;
End;


{----------------------------------------------------------------}
{ ECHAPPEMENT DES CARACTERES SPECIAUX                            }
{----------------------------------------------------------------}
Function AddSlashes(Const st: String): String;
Var x: Integer;
    f: Set Of Char;
Begin
  f := ['/', '\', ''''];
  Result := '';
  If (st = '') Then Exit;
  For x := 1 To Length(st) Do Begin
    If (st[x] In f) Then Result := Result + '\';
    Result := Result + st[x];
  End;
End;


{----------------------------------------------------------------}
{ CONVERSION STRING -> CODE HEXADECIMAL                          }
{----------------------------------------------------------------}
Function MyUrlEncode(Const st: String): String;
Var x: Integer;
Begin
  Result := '';
  If (st = '') Then Exit;
  For x := 1 To Length(st) Do
    Result := Result + IntToHex(Ord(st[x]), 2);
End;


{----------------------------------------------------------------}
{ CONVERSION CODE HEXADECIMAL -> STRING                          }
{----------------------------------------------------------------}
Function MyUrlDecode(Const st: String): String;
Var x: Integer;
Begin
  Result := '';
  If (Length(st) < 2) Then Exit;
  x := 1;
  Repeat
    Result := Result + Chr(Byte(StrToInt('$' + st[x] + st[x + 1])));
    x := x + 2;
  Until (x >= Length(st));
End;


{----------------------------------------------------------------}
{ CONVERSION D'UNE TAILLE EN CHAINE                              }
{----------------------------------------------------------------}
Function SizeToStr(Const Size: Int64): String;
Begin
  If (Size < $400) Then
    Result := Format(' %d octets ', [Size]) Else
  If (Size < $100000) Then
    Result := Format(' %.1f Ko     ', [Size / $400]) Else
  If (Size < $40000000) Then
    Result := Format(' %.1f Mo     ', [Size / $100000]) Else
  If (Size < $10000000000) Then
    Result := Format(' %.2f Go     ', [Size / $40000000]) Else
    Result := Format(' %.2f To     ', [Size / $10000000000])
End;


{----------------------------------------------------------------}
{ CREATION DE L'OBJET                                            }
{----------------------------------------------------------------}
Constructor THttpPost.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  //
  IsBinaryData := false;
  ProxyPort := '80';
  OnDocData := DocDataProc;
  OnRequestDone := RequestDoneProc;
  Oncookie := CookieProc;

  MaxTimeOut := 30000;
  StartTime := TimeGetTime;
  StringError := '';
  StringResult := '';
  ChampsSaisie := TStringList.Create;
  fTB := TToolWindow97.Create(Application);
  fTB.Parent := Application.MainForm;
  fTB.Visible := false;
  fMemo := Tmemo.Create(fTB);
  fMemo.Width := 5000;
  fMemo.Parent := fTB;
  fMemo.Visible := false;
  fTobresult := TOb.Create('LA TOB SORTIE',nil,-1);
  fTobresult.AddChampSupValeur ('RETOUR',0);
  fTobresult.AddChampSupValeur ('LIBERREUR','');
  fChamps := TStringList.Create;
  Completed := True;
End;


{----------------------------------------------------------------}
{ DESTRUCTION DE L'OBJET                                         }
{----------------------------------------------------------------}
Destructor THttpPost.Destroy;
Begin
  OnSendData := Nil;
  SendStream := Nil;
  RcvdStream := Nil;
  ChampsSaisie.Free;
  ChampsSaisie := Nil;
  fMemo.Free;
  fTB.free;
  fTobresult.Free;
  fChamps.Clear;
  fChamps.Free;
  Inherited Destroy;
End;


{----------------------------------------------------------------}
{ REINITIALISATION DES CHAMPS DE SAISIE                          }
{----------------------------------------------------------------}
Procedure THttpPost.ResetPost;
Begin
  ChampsSaisie.Clear;
  StringError := '';
  StringResult := '';
  fTobresult.ClearDetail;
  fMemo.Clear;
  fChamps.Clear;
End;


{----------------------------------------------------------------}
{ AJOUT D'UN CHAMPS DE SAISIE A POSTER                           }
{----------------------------------------------------------------}
Procedure THttpPost.AddPost(PostName, PostValue: String);
Begin
  If (Trim(PostName) <> '') Then
    ChampsSaisie.Add(Trim(PostName) + '=' + UrlEncode(Trim(PostValue)));
End;


{----------------------------------------------------------------}
{ POSTER LA REQUETE                                              }
{----------------------------------------------------------------}
Procedure THttpPost.StartPost(BinaryData: Boolean = False);
Var st: String;
    x: Integer;
Begin

  { Préparation de la requête }
  st := '';
  If (ChampsSaisie.Count > 0) Then
    For x := 0 To ChampsSaisie.Count - 1 Do Begin
      If (st <> '') Then st := st + '&';
      st := st + ChampsSaisie.Strings[x];
    End;

  SendStream := Nil;
  SendStream := TMemoryStream.Create;
  x := Length(st);
  Try
    SendStream.Write(st[1], x);
  Except End;
  If (SendStream.Size < x) Or (x >= 8000000) Then Begin
    AddError('Erreur : Requête trop longue (8Mo max).');
    Exit;
  End;
  SendStream.Position := 0;

  { Réinitialisation du MaxTimeOut }
  StartTime := TimeGetTime;
  StringError := '';
  StringResult := '';
  fTobresult.ClearDetail;
  fMemo.Clear;
  fChamps.Clear;
  Completed := False;

  { Lancement de la requête }
  RcvdStream := Nil;
  RcvdStream := TMemoryStream.Create;
  IsBinaryData := BinaryData;
  if fMethod= tMePost then PostAsync
  										else GetASync;
End;

Function THttpPost.HttpPost(BinaryData : Boolean): Boolean;
Begin
  Result := False;

  { Post la requête }
  if fGauge <> nil then
  begin
    fGauge.Visible := true;
  	fGauge.MaxValue := MaxTimeOut;
  end;
  StartPost(BinaryData);

  { Boucle d'attente de la réception }
  Repeat
    if fGauge <> nil then fGauge.Progress := CurTimeOut;
    Application.ProcessMessages;
    Sleep(50);
  Until (IsCompleted);

  { Affichage du résultat de la requête }
  if fGauge <> nil then
  begin
  	fGauge.Progress := 0;
  	fGauge.Visible  := false;
  end;
  If (StringError <> '') Then
  Begin
    (*
    If (StringError[1] <> #10) Then
    begin
      MessageBox(Application.Handle, PChar(Trim(StringError)), '', MB_APPLMODAL Or MB_OK Or MB_ICONERROR);
    end;
    *)
    StopPost;
    Exit;
  End;
  Result := True;
End;

{----------------------------------------------------------------}
{ RECEPTION DU COOKIE / SESSIONS                                 }
{----------------------------------------------------------------}
Procedure THttpPost.CookieProc(Sender: TObject; Const Data: String; Var Accept: Boolean);
var UnCookie : TCookie;
		UnNom : string;
    Unevaleur : string;
    UneDate : TDateTime;
Begin
//  Cookie := Data;
	UneDate := StrToDate('31/12/2099');
	DecodeCookie(Data,UnNom,Unevaleur,UneDate);
  UnCookie := Cookies.findCookie(UnNom);
  if UnCookie = nil then
  begin
    UnCookie := TCookie.create;
    UnCookie.Stocke (Data);
    Cookies.Add(unCookie);
  end else
  begin
    UnCookie.Stocke (Data);
  end;
End;


{----------------------------------------------------------------}
{ RECEPTION DE DONNEES                                           }
{----------------------------------------------------------------}
Procedure THttpPost.DocDataProc(Sender: TObject; Buffer: Pointer; Len: Integer);
Begin
  If (Len <= 0) Then Exit;
  StartTime := TimeGetTime;
End;


{----------------------------------------------------------------}
{ RECEPTION TERMINEE -> ANALYSE DU RESULTAT                      }
{----------------------------------------------------------------}
Procedure THttpPost.RequestDoneProc(Sender: TObject; RqType: THttpRequest; ErrCode: Word);
Var p, l: Integer;
Begin
//  StringError := '';
//  StringResult := '';
  Completed := True;
  l := RcvdStream.Size;

  { Test de la connection au serveur }
  If (StatusCode = 404) Then
  begin
    AddError('Erreur 404 :'+ Url);
    Exit;
  end Else If (StatusCode >= 400) Then
  begin
  	AddError('Requête abandonnée.');
    Exit;
  end Else If (l <= 0) Then
  Begin
    AddError('Aucune donnée réceptionnée.');
    Exit;
  End;

    { Données binaire dans le flux }
  If (IsBinaryData) then
  Begin
    RcvdStream := Nil;
    RcvdStream := TMemoryStream.Create;
    RcvdStream.Write(StringResult[1], Length(StringResult) - 6);
    RcvdStream.Seek(0, 0);
  End else
  Begin
    { Extraction des données délimitées }
    SetLength(StringResult, l);
    RcvdStream.Seek(0, 0);
    RcvdStream.Read(StringResult[1], l);
    p := Pos(DelimitData, StringResult);
    If (p > 0) Then
    Begin
      p := p + Length(DelimitData);
      StringResult := Copy(StringResult, p, l - p + 1);
      p := Pos(DelimitData, StringResult);
      If (p > 0) Then StringResult := Copy(StringResult, 1, p - 1);
    	StringResult := StripTags(StringResult);
      AffecteResultToTOB;
    End else
    begin
      // Si pas de delimiteur c'est une erreur
    	StringResult := StripTags(StringResult);
      AddError(StringResult);
      exit;
    end;
    { Suppression du code HTML dans les données texte }
  end;
End;


{----------------------------------------------------------------}
{ TEST LA FIN DE RECEPTION EN CAS D'ERREUR, ABANDON OU TIMEOUT   }
{----------------------------------------------------------------}
Function THttpPost.IsCompleted: Boolean;
Begin
  If (MaxTimeOut > 0) Then
    CurTimeOut := Integer(TimeGetTime) - StartTime Else
    CurTimeOut := MaxTimeOut;
  If (CurTimeOut >= MaxTimeOut) Then StringError := 'TimeOut.';
  Result := (Completed) Or (StringError <> '');
End;


{----------------------------------------------------------------}
{ ABANDON DE LA REQUETE PAR L'UTILISATEUR                        }
{----------------------------------------------------------------}
Procedure THttpPost.StopPost;
Begin
  If (Completed = False) Then StringError := 'Requête abandonnée.';
  //  SendMessage(0, FMsg_WM_HTTP_REQUEST_DONE, 0, 0);
  Abort;
  Completed := True;
End;


{----------------------------------------------------------------}

procedure THttpPost.AddError(TheError: string);
begin
	if StringError = '' then
  begin
    StringError := TheError;
  end else
  begin
    StringError := StringError+#13+TheError;
  end;
end;

procedure THttpPost.AffecteResultToTOB;
var indice : Integer;
		StrTemp : string;
begin
	fMemo.Lines.Add(StringResult);
  if fMemo.Lines.Count = 1 then exit;
  for Indice := 0 to Fmemo.lines.Count -1 do
  begin
    if Indice = 0 then
    begin
      MemoriseChamps;
    end else Definivaleurs (indice);
  end;
end;

procedure THttpPost.MemoriseChamps;
var lesChamps,leChamp :string;
begin
	lesChamps := fMemo.Lines[0];
  repeat
  	leChamp := READTOKENST (lesChamps);
    if leChamp <> '' then fChamps.Add(leChamp);
  until leChamp = '';
end;

procedure THttpPost.Definivaleurs(Ligne : Integer);
var Indice : Integer;
		lesvaleurs,lavaleur : string;
    leChamp : string;
    OneTOB : TOB;
begin
	lesValeurs := fMemo.lines[Ligne];
  if lesvaleurs  = '' then Exit;
  OneTOB := TOB.Create('UNE TOB',fTobresult,-1);
  Indice := 0;
  repeat
    lavaleur := READTOKENST(Lesvaleurs);
    if lavaleur <> '' then
    begin
   		leChamp := fChamps.Strings [Indice];
      OneTOB.AddChampSupValeur(leChamp,LaValeur);
      inc(indice);
    end;
  until lavaleur = '';
end;

End.
