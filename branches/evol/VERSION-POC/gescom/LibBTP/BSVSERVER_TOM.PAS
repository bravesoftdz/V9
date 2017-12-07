{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 24/08/2017
Modifié le ... :   /  /
Description .. : Source TOM de la TABLE : BSVSERVER (BSVSERVER)
Mots clefs ... : TOM;BSVSERVER
*****************************************************************}
Unit BSVSERVER_TOM ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     Fiche,
     FichList,
{$else}
     eFiche,
     eFichList,
{$ENDIF}
     HDb, 
     forms,
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox, 
     UTOM, 
     UTob,
     HTB97,
     UdefServices,
     UconnectBSV,
     LicUtil,
     UCryptage,
     Graphics,
     ENTGC ;

Type
  TOM_BSVSERVER = Class (TOM)
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnAfterDeleteRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnClose                    ; override ;
    procedure OnCancelRecord             ; override ;
    procedure OnLoadAlerte               ; override ;
    procedure OnAfterCommit              ; override ;
    procedure OnAfterRollBack            ; override ;
    procedure OnAfterBeginTrans          ; override ;
  private
    XX : TconnectBSV;
    CurrentUser,Currentpasswd : string;
    procedure SetServerConnected;
    procedure ConnecteEtRemplit;
    procedure ChangeParamsConnexion (sender : TObject);
    procedure ChangeArchive (Sender : TObject);
    procedure ArchiveTest (Sender : TObject);
    end ;

Implementation

procedure TOM_BSVSERVER.OnNewRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnAfterDeleteRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnLoadRecord ;
begin
  Inherited ;
  if (GetControlText('BP2_SERVERNAME') <> '') and  (GetControlText('BP2_PORT')<> '0') then
  begin
    ConnecteEtRemplit;
  end;
end ;

procedure TOM_BSVSERVER.OnChangeField ( F: TField ) ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnArgument ( S: String ) ;
begin
  Inherited ;
  CurrentUser := V_PGI.UserLogin;
  Currentpasswd := AnsiLowerCase_(MD5(DeCryptageSt(V_PGI.Password)));
  Currentpasswd := FindEtReplace(Currentpasswd,'-','',true);
  THValComboBox (GetControl('TBASENAME')).Enabled := false;
  XX := TconnectBSV.create;
  THEdit(GetControl('BP2_SERVERNAME')).OnExit := ChangeParamsConnexion;
  THEdit(GetControl('BP2_PORT')).OnExit := ChangeParamsConnexion;
  THValComboBox (GetControl('TBASENAME')).OnChange := ChangeArchive;
  TToolbarButton97 (GetControl('BCONNECTARCHIVE')).OnClick := ArchiveTest;
end ;

procedure TOM_BSVSERVER.OnClose ;
begin
  if XX.connected then XX.Disconnect;
  XX.Free;
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnCancelRecord ;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnLoadAlerte;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnAfterBeginTrans;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnAfterCommit;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.OnAfterRollBack;
begin
  Inherited ;
end ;

procedure TOM_BSVSERVER.ConnecteEtRemplit;
begin
  //
  if XX.connected then Exit;
  //
  XX.BSVServer := GetControlText('BP2_SERVERNAME');
  XX.BSVPORT := GetControlText('BP2_PORT');
  TRY
    if XX.ConnectToServer(CurrentUser,CurrentPasswd) then
    begin
      THLabel(GetControl('SERVERSTATUS')).Caption := 'Connecté';
      THLabel(GetControl('SERVERSTATUS')).Font.color := clGreen;
      SetServerConnected;
    end else
    begin
      THLabel(GetControl('SERVERSTATUS')).Caption := 'Non Connecté';
      THLabel(GetControl('SERVERSTATUS')).Font.color := clRed;
    end;
  EXCEPT
    on E : Exception do
    begin
      PGIInfo(e.Message);
    end;
  END;
end;

procedure TOM_BSVSERVER.SetServerConnected;
var II : Integer;
    AA : TArchive;
begin
  XX.GetArchivesList;
  THValComboBox (GetControl('TBASENAME')).Clear;
  THValComboBox (GetControl('TBASENAME')).Items.insert(0,'<<Aucune>>');
  THValComboBox (GetControl('TBASENAME')).values.insert(0,'0');
  THValComboBox (GetControl('TBASENAME')).ItemIndex := 0;
  if XX.LesArchives.Count > 0 then
  begin
    for II := 0 to XX.LesArchives.Count - 1 do
    begin
      AA := XX.LesArchives.items[II];
      THValComboBox (GetControl('TBASENAME')).Items.Insert(II+1,AA.Name);
      THValComboBox (GetControl('TBASENAME')).Values.Insert(II+1,IntToStr(AA.Id));
      if XX.LesArchives.items[II].Id = THDbSpinEdit(GetControl('BP2_ARCHIVE')).value then THValComboBox (GetControl('TBASENAME')).ItemIndex := II+1;
    end;
  end;
  THValComboBox (GetControl('TBASENAME')).Enabled := True;
end;


procedure TOM_BSVSERVER.ChangeParamsConnexion(sender: TObject);
begin
  if (GetControlText('BP2_SERVERNAME') <> '') and  (GetControlText('BP2_PORT')<> '0') then
  begin
    if XX.connected then XX.Disconnect;
    ConnecteEtRemplit;
  end;
end;

procedure TOM_BSVSERVER.ChangeArchive(Sender: TObject);
begin
  SetField ('BP2_ARCHIVE', StrToInt(THValComboBox (GetControl('TBASENAME')).Value) );
end;

procedure TOM_BSVSERVER.ArchiveTest(Sender: TObject);
begin
  if GetField('BP2_ARCHIVE')=0 then exit;
  if XX.connected then if XX.ConnectToArchive(GetField('BP2_ARCHIVE'),VH_GC.BSVUploadOK,VH_GC.BSVOpenDoc) then PGIInfo('Connection Ok') else PGIInfo('Pas de connexion');
end;

Initialization
  registerclasses ( [ TOM_BSVSERVER ] ) ;
end.
