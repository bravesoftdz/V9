unit VisuLogbTP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TFVisuLogbTP = class(TForm)
    ListBox1: TListBox;
    PrintDialog1: TPrintDialog;
    Button1: TButton;
    RichEdit1: TRichEdit;
    CheminLog: TEdit;
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FVisuLogbTP: TFVisuLogbTP;

implementation

{$R *.DFM}

procedure TFVisuLogbTP.ListBox1Click(Sender: TObject);
var
    st_chemin, st_trav1 : string;

begin
    st_chemin := ExtractFilePath(ParamStr(0));
    st_trav1 := ListBox1.Items.Strings[ListBox1.ItemIndex];
    if (CheminLog.text <> '') then st_chemin := CheminLog.text;
    RichEdit1.Lines.LoadFromFile(st_chemin + st_trav1 + '.log');
end;

procedure TFVisuLogbTP.FormShow(Sender: TObject);
begin
    ListBox1.ItemIndex := 0;
    ListBox1Click(Sender);
end;

procedure TFVisuLogbTP.Button1Click(Sender: TObject);
begin
    if PrintDialog1.Execute then
        RichEdit1.Print('');
end;

end.
