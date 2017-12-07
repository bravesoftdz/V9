unit USplashLanceur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Hctrls, jpeg, ExtCtrls;

type
  TFsplash = class(TForm)
    IMGFOND: THImage;
    HLabel1: THLabel;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

function OpenSplash : TFsplash;
procedure CloseSplash (var XX : TFsplash);

implementation

{$R *.dfm}

function OpenSplash : TFsplash;
begin
  Result := TFsplash.Create(Application);
  Result.Show;
  Result.Update;
end;

procedure CloseSplash (var XX : TFsplash);
begin
  if Assigned(XX) then
  begin
  	FreeAndNil(XX);
  end;
end;

end.
