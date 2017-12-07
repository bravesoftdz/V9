unit ToxSimCash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HTB97, ComCtrls, StdCtrls, ExtCtrls, HPanel, uTob, hmsgbox, Grids, Hctrls,
  DBTables, ToxMoteur, HEnt1, UIUtil, uToxConst, uToxClasses, uToxDecProc  ;



type
  TFicheSimulationCash = class(TForm)
    HPanel1: THPanel;
    HPanel3: THPanel;
    OD: TOpenDialog;
    Label1: TLabel;
    CompteRendu: TMemo;
    PMain: THPanel;
    Label3: TLabel;
    Bopen: TToolbarButton97;
    cbQuickInt: TCheckBox; // int�gration rapide
    cbDisplay: TCheckBox;  // affichage des donn�es lors de l'int�gration
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BopenClick(Sender: TObject);
    procedure BcancelClick(Sender: TObject);
    procedure ToolbarButton971Click(Sender: TObject);
    function  ChargeTOX (TT : TOB) : Integer ;
    procedure FormCreate(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    TobRecup   : TOB ;
  end;

////////////////////////////////////////////////////////////////////////////////
// Proc�dures ou fonctions � exporter
////////////////////////////////////////////////////////////////////////////////
  procedure ToxSimulationCash ;

implementation

//uses AglToxRun;

{$R *.DFM}

procedure ToxSimulationCash ( ) ;
var
  X  : TFicheSimulationCash;
  PP : THPanel ;
begin
  PP:=FindInsidePanel ;
  X := TFicheSimulationCash.Create ( Application ) ;
  if PP=Nil then
   BEGIN
    try
      X.ShowModal ;
    finally
      X.Free ;
    end ;
   END else
   BEGIN
   InitInside(X,PP) ;
   X.Show ;
   END ;
end;

///////////////////////////////////////////////////////////////////////////////
// Charge la TOX du fichier dans la TOB "TobRecup"
///////////////////////////////////////////////////////////////////////////////
function TFicheSimulationCash.ChargeTOX(TT : TOB) : Integer ;
BEGIN
  TobRecup:=TT ;
  result:=0 ;
END ;

///////////////////////////////////////////////////////////////////////////////
// TobRecup : Cr�ation de la TOB de r�cup�ration
///////////////////////////////////////////////////////////////////////////////
procedure TFicheSimulationCash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree ;
end;

procedure TFicheSimulationCash.FormDestroy(Sender: TObject);
begin
  if TobRecup <> nil then TobRecup.Free ;
end;

procedure TFicheSimulationCash.BopenClick(Sender: TObject);
var PEnv         : TCollectionEnveloppes ;
    EtatTox      : integer ;
    Devise       : string  ;
    BasculeEuro  : boolean ;
    FileNameTox  : string  ;
    FileNameEnv  : string  ;
    length       : integer ;
    ArchivageTox : boolean ;
begin

  if OD.Execute then
  begin
    CompteRendu.lines.add('  ');
    CompteRendu.lines.add('   Int�gration du fichier '+OD.FileName);
    //
    // R�cup�ration de la devise d'�mission stock�e dans l'enveloppe
    //
    FileNameTox := OD.FileName ;
    trim (FileNameTox);
    length      := strlen (PChar (FileNameTox));
    FileNameEnv := copy (FileNameTox, 0, length-4) + '.ENV' ;

    PEnv:=TCollectionEnveloppes.Create(TCollectionEnveloppe) ;
    PEnv.LoadEnveloppe(FileNameEnv);
    //
    // R�cup�ration de la devise d'�mission
    //
    Devise:=PEnv.Items[0].GetInfoComp('DEVISE', Devise);
    if Devise = '' then  Devise := V_PGI.DevisePivot;
    //
    // Le site �metteut a t il bascul� en EURO ?
    //
    BasculeEuro:=PEnv.Items[0].GetInfoComp('BASCULEEURO', BasculeEuro);
    //
    // Chargement du fichier en TOB
    //
    TobRecup := Tob.Create ( 'TOB MAITRE', Nil, -1 ) ;
    TOBLoadFromBinFile (OD.FileName, ChargeTOX, nil);
    //
    // int�gration de la TOB
    //
    AvantArchivageTox (TobRecup, ArchivageTox);
    //
    // R�-�criture de la TOB dans le fichier
    //
    TobRecup.SaveToBinFile (OD.FileName, False, True, True, False);
    //
    // Lib�ration de la TOB
    //
    TobRecup.free;
    TobRecup:=nil;
  end ;
end;

procedure TFicheSimulationCash.BcancelClick(Sender: TObject);
begin
  Close ;
end;

procedure TFicheSimulationCash.ToolbarButton971Click(Sender: TObject);
begin
  if TobRecup.Detail.Count = 0 then Exit ;
end;

procedure TFicheSimulationCash.FormCreate(Sender: TObject);
begin
  OD.Filter := 'Fichiers des �changes PGI (*.TOX)|*.TOX';
end;

end.
