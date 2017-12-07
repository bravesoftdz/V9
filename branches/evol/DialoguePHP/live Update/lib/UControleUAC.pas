unit UControleUAC;

interface
uses shellapi,Windows,SysUtils,ShlObj;

const
  LOGON_WITH_PROFILE=$00000001;

function CreateProcessWithLogon(lpUsername        :PWideChar;
                                lpDomain          :PWideChar;
                                lpPassword        :PWideChar;
                                dwLogonFlags      :DWORD;
                                lpApplicationName :PWideChar;
                                lpCommandLine     :PWideChar;
                                dwCreationFlags   :DWORD;
                                lpEnvironment     :Pointer;
                                lpCurrentDirectory:PWideChar;
                                var lpStartupInfo :TStartupInfo;
                                var lpProcessInfo :TProcessInformation):BOOL;stdcall;external 'advapi32.dll' name 'CreateProcessWithLogonW';
function CreateEnvironmentBlock(var lpEnvironment:Pointer;hToken:THandle;bInherit:BOOL):BOOL;stdcall;external 'userenv.dll';
function DestroyEnvironmentBlock(pEnvironment:Pointer):BOOL;stdcall;external 'userenv.dll';

function RunProcess(Command : String;Parameters:array of string;WorkingDirectory:string=''; Wait: Boolean=true) : integer;
function RunProcessAs(Command:string;Parameters:array of string;Username,Password:string;Domain:string='';WorkingDirectory:string='';Wait:Boolean=False):Cardinal;
function Getuser (UserComposed : string) : string;
function GetDomain (UserComposed : string) : string;
procedure KillProcess(ClassName: PChar; Titre: PChar);
function IsProcessAlive(Titre: PChar) : boolean;
procedure RunAsAdmin(hWnd : HWND; aFile : String; aParameters : String);



implementation


function IsProcessAlive(Titre: PChar) : boolean;
  var Appli : HWND;
begin
  Appli := FindWindow(nil, PChar(Titre));
  result := (Appli <> 0);
end;

procedure KillProcess(ClassName: PChar; Titre: PChar);
var
  ProcessHandle : THandle;
  ProcessID: Integer;
  Appli : HWND;
begin
  Appli := FindWindow(PChar(ClassName), PChar(Titre));
  if Appli <> 0 then
  begin
    GetWindowThreadProcessID(Appli, @ProcessID);
    ProcessHandle := OpenProcess(PROCESS_TERMINATE, FALSE, ProcessId);
    TerminateProcess(ProcessHandle,4);
  end;
end;

function FormatParam(s:string):string;
var
  a:Integer;
  t:Boolean;
begin
  Result:=s;
  t:=False;
  for a:=Length(s) downto 1 do
    if s[a] in [' ',#32] then begin
      t:=True;
      Break;
    end;
  if t and not (s[1] in ['''','"']) then
    Result:='"'+s+'"';
end;

procedure Error(s:string);
begin
  raise Exception.Create(s);
end;

procedure OSError(s:string);
begin
 raise Exception.Create(s+#13#10+SysErrorMessage(GetLastError));
end;


function RunProcess(Command : String;Parameters:array of string;WorkingDirectory:string=''; Wait: Boolean=true) : integer;
var
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  CreateOK : Boolean;
  wCommandLine,wCurrentDirectory : string;
  a:Integer;
begin
    { fill with known state }
	result := -1;
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);

  if WorkingDirectory='' then
    wCurrentDirectory:=GetCurrentDir
  else
    wCurrentDirectory:=WorkingDirectory;
  wCurrentDirectory := IncludeTrailingBackslash(wCurrentDirectory);
  wCommandLine:='';
  // if not SetCurrentDir (wCurrentDirectory) then RaiseLastOsError;
  for a:=Low(Parameters) to High(Parameters) do
    wCommandLine:=wCommandLine+' "'+Parameters[a]+'" ';
  CreateOK := CreateProcess(PAnsiChar(Command), PChar(wCommandLine), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS,
              nil, PAnsiChar(wCurrentDirectory), StartInfo, ProcInfo);
    { check to see if successful }
  if CreateOK then
    begin
        //may or may not be needed. Usually wait for child processes
      if Wait then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    end
  else
    begin
      RaiseLastOSError;
     end;
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

function RunProcessAs(Command:string;Parameters:array of string;Username,Password:string;Domain:string='';WorkingDirectory:string='';Wait:Boolean=False):Cardinal;
(*
  Execute the Command with the given Parameters, Username, Domain, Password and Working Directory. Parameters containing white spaces are
  automatically embraced into quotes before being sent to avoid having them splitted by the system. If either Domain or Working Directory
  are empty the current one will be used instead.

  If Wait is specified the function will wait till the command is completely executed and will return the exit code of the process,
  otherwise zero.

  Suitable Delphi exceptions will be thrown in case of API failure.
*)
var
  a:Integer;
  n:Cardinal;
  h:THandle;
  p:Pointer;
  PI:TProcessInformation;
  SI:TStartupInfo;
  t:array[0..MAX_PATH] of WideChar;
	wUser,wDomain,wPassword,wCommandLine,wCurrentDirectory:WideString;
begin
	result := 0;
  ZeroMemory(@PI,SizeOf(PI));
  ZeroMemory(@SI,SizeOf(SI));
  SI.cb:=SizeOf(SI);
  if not LogonUser(PChar(Username),nil,PChar(Password),LOGON32_LOGON_INTERACTIVE,LOGON32_PROVIDER_DEFAULT,h) then
  begin
  	OSError ('Connexion sur le compte utilisateur impossible');
  	exit;
  end;
  try
    if not CreateEnvironmentBlock(p,h,True) then
    begin
			OSError('Environnement utilisateur inaccessible');
      exit;
    end;
    try
      wUser:=Username;
      wPassword:=Password;
      wCommandLine:=Command;
      for a:=Low(Parameters) to High(Parameters) do
        wCommandLine:=wCommandLine+' '+FormatParam(Parameters[a]);
      if Domain='' then
      begin
        n:=SizeOf(t);
        if not GetComputerNameW(t,n) then
          exit;
        wDomain:=t;
      end else
        wDomain:=Domain;
      if WorkingDirectory='' then
        wCurrentDirectory:=GetCurrentDir
      else
        wCurrentDirectory:=WorkingDirectory;
      if not CreateProcessWithLogon(PWideChar(wUser),PWideChar(wDomain),PWideChar(wPassword),LOGON_WITH_PROFILE,nil,PWideChar(wCommandLine),CREATE_UNICODE_ENVIRONMENT,p,PWideChar(wCurrentDirectory),SI,PI) then
      begin
      	OSError('Impossible de créer le processus');
        exit;
      end;
      try
        if Wait then
        begin
          WaitForSingleObject(PI.hProcess,INFINITE);
          if not GetExitCodeProcess(PI.hProcess,Result) then
            exit;
        end else
         Result:=0;
      finally
        CloseHandle(PI.hProcess);
        CloseHandle(PI.hThread);
      end;
    finally
      DestroyEnvironmentBlock(p);
    end;
  finally
  	CloseHandle(h);
  end;
end;

function Getuser (UserComposed : string) : string;
var iPos : integer;
begin
  result := userComposed;
  ipos := pos ('/',userComposed);
  if iPos = 0 then ipos := pos ('\',userComposed);
  if Ipos = 0 then exit;
  result := copy(UserComposed,ipos+1,255);
end;

function GetDomain (UserComposed : string) : string;
var iPos : integer;
begin
	result := '';
  iPos := pos ('/',userComposed);
  if iPos = 0 then ipos := pos ('\',userComposed);
  if Ipos = 0 then exit;
  result := copy(UserComposed,1,ipos-1);
end;

procedure RunAsAdmin(hWnd : HWND; aFile : String; aParameters : String);
Var
 Sei : TShellExecuteInfoA;
begin
 Fillchar(sei,SizeOf(sei),0);
 sei.cbSize := SizeOf(sei);
 sei.Wnd    := hWnd;
 sei.fMask  := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
 sei.lpfile := PChar(aFile);
 sei.lpVerb := 'runas';
 sei.lpParameters := PChar(aParameters);
 sei.nShow := SW_SHOWNORMAL;
 if not ShellExecuteEx(@sei) then
  RaiseLastOSError;
end;


end.
