unit UExportParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls,FileCtrl,Uregistry,UConstantes,Ulog;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Repository: TEdit;
    BFindEmplacement: TSpeedButton;
    Panel1: TPanel;
    BtCache: TSpeedButton;
    Bvalide: TSpeedButton;
    CBACCESOUTILS: TCheckBox;
    procedure BvalideClick(Sender: TObject);
    procedure BtCacheClick(Sender: TObject);
    procedure BFindEmplacementClick(Sender: TObject);
  private
    { D�clarations priv�es }
    procedure ExportParams;

  public
    { D�clarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.BvalideClick(Sender: TObject);
begin
  if Repository.Text = '' then
  begin
    Application.MessageBox('Merci de renseigner le r�pertoire de stockage','Export des param�tres',MB_OKCANCEL or MB_ICONEXCLAMATION);
    exit;
  end;
  ExportParams;
  close;
end;

procedure TForm2.BtCacheClick(Sender: TObject);
begin
  close;
end;

procedure TForm2.BFindEmplacementClick(Sender: TObject);
var TheRepert : string;
begin
  TheRepert := Repository.text;
  if SelectDirectory ('S�lectionner le r�pertoire de stockage',Repository.text,Therepert) then Repository.text := TheRepert;
end;

procedure TForm2.ExportParams;
var DIrectory,NbMins : string;
    InfoFile,OutilsVisible : string;
begin
  DIrectory:= GetInfoStocke ('ServerRepository');
  NbMins := getInfoStocke('Timer');
  OutilsVisible := GetInfoStocke('OutilsVisible');
  if CBACCESOUTILS.checked then OutilsVisible := 'NON';
  DeleteFile(IncludeTrailingBackslash(Repository.text)+NAMEPARAM);
  InfoFile := DIrectory+SEPARATOR+NbMins+SEPARATOR+OutilsVisible;
  ecritLog (IncludeTrailingBackslash(Repository.text),InfoFile,NAMEPARAM);
end;

end.
