unit BtpAnalDev;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, UTobView, ExtCtrls, HPanel, HTB97,UTOB;

type
  Analyse = (AnDocument,AnOuvrage,AnNone);

  TFBtpAnalDev = class(TForm)
    Dock971: TDock97;
    ToolWindow971: TToolWindow97;
    BValider: TToolbarButton97;
    HPanel1: THPanel;
    HPanel2: THPanel;
    TobViewer1: TTobViewer;
    TVLig: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { D�clarations priv�es }
    NatureAnalyse : Analyse;
    Article,Nomenclature,Libelle : string;
    TOBAnalyse : TOB;
    procedure RemplitTableAnalyse;
  public
    { D�clarations publiques }
  end;

procedure EntreeAnalyseBtp (params : array of variant;NbParams : integer);

implementation

{$R *.DFM}

procedure EntreeAnalyseBtp (params : array of variant;NbParams : integer);
var
  Indice : Integer;
  St1,St2,Article,Nomenclature,Libelle,Param : String;
  NatureAnalyse : Analyse;
  FBtpAnalDev: TFBtpAnalDev;
begin
// R�cup�ration des param�tres
NatureAnalyse := AnNone;
For indice:= 0 to NbParams - 1 do
begin
   Param := string(Params[Indice]);
   st1 := Copy(Param, 0, Pos('=',Param) - 1);
   if st1 = 'ARTICLE' then
   begin
       st2 := Copy(Param, Pos('=',Param) + 1, 255);
       NatureAnalyse := AnOuvrage;
       Article := St2;
   end;
   if st1 = 'NOMEN' then
   begin
       st2 := Copy(Param, Pos('=',Param) + 1, 255);
       NatureAnalyse := AnOuvrage;
       Nomenclature := St2;
   end;
   if st1 = 'LIBELLE' then
   begin
       st2 := Copy(Param, Pos('=',Param) + 1, 255);
       Libelle := St2;
   end;
end;
// Controle des param�tres pass�s
if ((NatureAnalyse = AnOuvrage) and
   ((Article = '') or (Nomenclature = ''))) or (NatureAnalyse = AnNone) then
begin
     exit;
end;
FBtpAnalDev := TFBtpAnalDev.Create (Application);
FBtpAnalDev.NatureAnalyse := NatureAnalyse;
if NatureAnalyse = AnOuvrage then
begin
     FBtpAnalDev.Article := Article;
     FBtpAnalDev.Nomenclature := Nomenclature;
end;
FBtpAnalDev.RemplitTableAnalyse;
FBtpAnalDev.ShowModal;
end;

procedure TFBtpAnalDev.RemplitTableAnalyse ();
begin
if NatureAnalyse = AnOuvrage then
begin

end
else
begin
end;

end;

procedure TFBtpAnalDev.FormCreate(Sender: TObject);
begin
//
end;

procedure TFBtpAnalDev.FormShow(Sender: TObject);
begin
//
end;

end.
