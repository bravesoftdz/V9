unit ControlIniFile;

interface
uses hctrls,
  sysutils,HEnt1,
{$IFNDEF EAGLCLIENT}
  uDbxDataSet, DB,
{$ELSE}
  uWaini,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} DB,
{$ENDIF}
	windows,
  uhttp,paramsoc,
  inifiles,
  CBPPath,forms,
  utob,uEntCommun;

const INIFILE = 'CEGIDPGI.INI';
			PRESOCREF = 'socref.mdb';
      NEWSOCREF = 'SocRefbtp.mdb';

function FindPGIIniFile : string;
procedure ControlPGIINI;

implementation

function WindowsDirectory: String;
const
  dwLength: DWORD = 255;
var
  WindowsDir: PChar;
begin
  GetMem(WindowsDir, dwLength);
  GetWindowsDirectory(WindowsDir, dwLength);
  Result := String(WindowsDir);
  FreeMem(WindowsDir, dwLength);
end;

function FindPGIIniFile : string;
  var Localrepert : string;
  		Iexist : integer;
begin
	Iexist := -1;
  // recherche sur repertoire courant
  TRY
  	Result := '';
    Localrepert := ExtractFilePath (Application.ExeName); // repertoire de l'application
    Iexist := FileOpen(IncludeTrailingBackslash(Localrepert)+INIFILE,fmOpenRead );
    if Iexist <0 then
    begin
      Localrepert := TCbpPath.GetCegidUserRoamingAppData; // repertoire Utilisateur
      Iexist := FileOpen(IncludeTrailingBackslash(Localrepert)+INIFILE,fmOpenRead );
      if Iexist <0 then
      begin
        Localrepert := TCBPPath.GetCegidData; // Data de All Users
        Iexist := FileOpen(IncludeTrailingBackslash(Localrepert)+INIFILE,fmOpenRead);
        if Iexist < 0 then
        begin
           LocalRepert := WindowsDirectory;         // Emplacement de windows
           Iexist := FileOpen(IncludeTrailingBackslash(Localrepert)+INIFILE,fmOpenRead);
           if Iexist >= 0 then
           begin
              Result := Localrepert;
           end;
        end else
        begin
          Result := Localrepert;
        end;
      end else
      begin
        Result := Localrepert;
      end;
    end else
    begin
      Result := Localrepert;
    end;
  FINALLY
   if Iexist >= 0 then FileClose(Iexist);
  END;
end;

procedure ControlPGIINI;
{$IFNDEF EAGLCLIENT}
  var RepertIniFile,PreDbffile,NewDbffile : string;
  		preDbfName : string;
      IniPGIFile : Tinifile;
{$ENDIF}
begin
{$IFNDEF EAGLCLIENT}
	RepertIniFile :=  FindPGIIniFile;
	//
  if RepertIniFile <> '' then
  begin
    IniPgiFile := TiniFile.create (IncludeTrailingBackslash (RepertInifile)+INIFILE);
    PreDbffile := IniPgiFile.ReadString('Reference','Database','');
    PreDbfName := ExtractFileName(preDbffile);
    if (LowerCase (PreDbfName) = PRESOCREF) then
    begin
    	NewDbffile := IncludeTrailingBackslash(ExtractFilePath(PreDbffile))+NEWSOCREF;
      if not FileExists (NewDbffile) then  RenameFile(PreDbffile,NewDbffile);
      IniPgiFile.DeleteKey('Reference', 'Database');
      IniPgiFile.WriteString('Reference','Database',NewDbffile);
    end;
    IniPGIFile.Free;
  end;
{$ENDIF}
end;

end.
