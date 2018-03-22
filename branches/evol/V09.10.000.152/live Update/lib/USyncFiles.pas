unit USyncFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  UControleUAC,
  UfronctionBase,
  ShellAPI;

type
  TFFSyncfiles = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
    exePath : string;
  public
    { Déclarations publiques }
  end;

var
  FFSyncfiles: TFFSyncfiles;

implementation

{$R *.dfm}

procedure TFFSyncfiles.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//
end;

procedure TFFSyncfiles.FormCreate(Sender: TObject);
begin
//
  exePath := ExtractFilePath(Application.exename);
end;

procedure TFFSyncfiles.FormShow(Sender: TObject);
begin
//
  ExeRunning('LSEClientMaj',true);
  if UpdateUpdProducts then
  begin
    RegenConfFiles;
  end;
  Sleep(2000);
  exePath := ExtractFilePath(Application.exename);
  //
  ShellExecute(Handle, 'runas', PansiChar(IncludeTrailingBackslash (exePath)+'LSEClientMaj.exe'), nil, nil, SW_SHOWNORMAL);
  close;
end;

end.
