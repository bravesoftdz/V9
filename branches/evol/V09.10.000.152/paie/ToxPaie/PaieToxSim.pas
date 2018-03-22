unit PaieToxSim;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  HTB97,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  HPanel,
  uTob,
  hmsgbox,
  Grids,
  Hctrls,
  DBTables,
  PaieToxMoteur,
  HEnt1,
  UIUtil,
  uToxConst,
  uToxClasses,
  uToxDecProc ,
  uToz ;

type
  TFicheSimulation = class(TForm)
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
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
    TobRecup   : TOB ;
  end;

////////////////////////////////////////////////////////////////////////////////
// Proc�dures ou fonctions � exporter
////////////////////////////////////////////////////////////////////////////////
  procedure PaieToxSimulation ;

implementation

//uses AglToxRun;

{$R *.DFM}

procedure PaieToxSimulation ( ) ;
var
  X  : TFicheSimulation;
  PP : THPanel ;
begin
  PP:=FindInsidePanel ;
  X := TFicheSimulation.Create ( Application ) ;
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
function TFicheSimulation.ChargeTOX(TT : TOB) : Integer ;
BEGIN
  TobRecup:=TT ;
  result:=0 ;
END ;

///////////////////////////////////////////////////////////////////////////////
// TobRecup : Cr�ation de la TOB de r�cup�ration
///////////////////////////////////////////////////////////////////////////////
procedure TFicheSimulation.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree ;
end;

procedure TFicheSimulation.FormDestroy(Sender: TObject);
begin
  if TobRecup <> nil then TobRecup.Free ;
end;

procedure TFicheSimulation.BopenClick(Sender: TObject);
var PEnv         : TCollectionEnveloppes ;
    FileNameTox  : string  ;
    FileNameEnv  : string  ;
    length_int   : integer ;
    MaToz        : Toz     ;
    Okay         : boolean ;
    Compress     : boolean ;
    Fichier      : string  ;
    Chemin       : string  ;
    FichierTOX   : string  ;
begin
  MaToz       := nil ;

  if OD.Execute then
  begin
    if UpperCase ( ExtractFileExt ( OD.FileName ) ) = '.ZIP' then
    begin
      Okay     := False ;
      Compress := True ;
      //
      // Extraction du fichier .TOX du .ZIP
      TRY
        TRY
          MaToz := TOZ.Create ;
          if MaToz.OpenZipFile ( OD.FileName, moOpen ) then
          begin
            if MaToz.OpenSession (osExt) then
            begin
              if MaToz.SetDirOut (ExtractFilePath ( OD.FileName )) then
              begin
                if MaToz.CloseSession then
                begin
                  // Suppression de la TOZ
                  Okay := True ;
                  MaToz.Free ;
                  MaToz := Nil ;
                  //
                  // Suppression du fichier TOX.ZIP
                  //
                  Fichier := Copy ( OD.FileName, 1, Length ( OD.FileName  ) ) ;
                  DeleteFile ( Fichier ) ;
                  //
                  // R�-initialise le fichier charg�
                  //
                  Fichier := Copy (OD.FileName , 1, Length ( OD.FileName) -4 ) ;
                end ;
              end ;
            end ;
          end ;
        EXCEPT
          on Erreur : ETozErreur do
          begin
            CompteRendu.lines.add('  ');
            CompteRendu.lines.add('   Impossible de d�zipper le fichier ' + OD.FileName);
            Okay := False ;
          end ;
        end;
      FINALLY
        if MaToz <> Nil then MaToz.Free ;
      end;
    end else
    begin
      Okay     := True ;
      Compress := False ;
      Fichier  := OD.FileName ;
    end;


    if Okay then
    begin
      CompteRendu.lines.add('  ');
      CompteRendu.lines.add('   Int�gration du fichier '+ Fichier);
      //
      // R�cup�ration de la devise d'�mission stock�e dans l'enveloppe
      //
      FileNameTox := Fichier  ;
      trim (FileNameTox);
      length_int  := strlen (PChar (FileNameTox));
      FileNameEnv := copy (FileNameTox, 0, length_int-4) + '.ENV' ;

      PEnv:=TCollectionEnveloppes.Create(TCollectionEnveloppe) ;
      PEnv.LoadEnveloppe(FileNameEnv);
      //
      // Si le fichier �tait compress�, on met � jour l'enveloppe
      // Attention : pour l'instant ne marche pas car �crit que dans la corbeille arriv�e
      //
      if Compress then
      begin
        Chemin     := ExtractFilePath ( OD.FileName );
        FichierTOX := ExtractFileName ( FileNameTox );
        PEnv.Items[0].Update('FICHIER1', FichierTox, False, Chemin) ;
      end;
      //
      // Chargement du fichier en TOB
      //
      TobRecup := Tob.Create ( 'TOB MAITRE', Nil, -1 ) ;
      TOBLoadFromBinFile (FileNameTox, ChargeTOX, nil);
      //
      // int�gration de la TOB
      //
      PaieTraitementDeLaTox (TobRecup, CompteRendu, True, cbDisplay.Checked, True, cbQuickInt.Checked) ;
      //
      // R�-�criture de la TOB dans le fichier
      //
      TobRecup.SaveToBinFile (FileNameTox, False, True, True, False);
      //
      // Lib�ration de la TOB
      //
      TobRecup.free;
      TobRecup:=nil;
      PEnv.free ;
    end ;
  end;
end;

procedure TFicheSimulation.BcancelClick(Sender: TObject);
begin
  Close ;
end;

procedure TFicheSimulation.ToolbarButton971Click(Sender: TObject);
begin
  if TobRecup.Detail.Count = 0 then Exit ;
end;

end.
