program LSEClientMaj;

uses
  Forms,
  UClientMajP in 'UClientMajP.pas' {FlanceurMajLse},
  UControleUAC in 'UControleUAC.pas',
  UEncryptage in 'UEncryptage.pas',
  Uregistry in 'Uregistry.pas',
  URVRunAS in 'URVRunAS.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mise à jour des applications LSE-CEGID';
  Application.CreateForm(TFlanceurMajLse, FlanceurMajLse);
  Application.Run;
end.
