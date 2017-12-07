unit ToxStart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HTB97, ComCtrls, StdCtrls, ExtCtrls, HPanel, uTob, hmsgbox, Grids, Hctrls,
  DBTables, voirTob, ToxMoteur,
  UTox, AglToxRun, ToxFunctions,
  Spin, ParamSoc ;

type
  TGestionEchange = class(TForm)
    Panel1: TPanel;
    ButtonStopTox: TToolbarButton97;
    ButtonStartTox: TToolbarButton97;
    CompteRendu: TMemo;
    GroupBox1: TGroupBox;
    AfficheDonnee: TCheckBox;
    AfficheErreur: TCheckBox;
    Intervalle: TSpinEdit;
    Label1: TLabel;
    Confirmation: TCheckBox;
    procedure ButtonStartToxClick(Sender: TObject);
    procedure ButtonStopToxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
      { D�clarations priv�es }
    procedure ToxInformation(P: PToxEnveloppe ; var ATraiter: boolean);
    procedure ToxTraitement (P: PToxEnveloppe ; Index: integer ; TheTob: TOB; var Areecrire, Archiver, Rejeter: boolean);
    procedure ToxErreur     (CodeErreur: Integer; const MessageErreur: String);

  public
    { D�clarations publiques }
  end;

////////////////////////////////////////////////////////////////////////////////
// Proc�dures ou fonctions � exporter
////////////////////////////////////////////////////////////////////////////////
   procedure ToxGestionEchanges ;

implementation

{$R *.DFM}

procedure ToxGestionEchanges ( ) ;
var
  X : TGestionEchange;
begin
  X := TGestionEchange.Create ( Application ) ;
  X.ShowModal ;
  X.Free ;
end ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Bouton de d�marrage des �changes
////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TGestionEchange.ButtonStartToxClick(Sender: TObject);
var Delai           : integer ;
begin
    Delai           := Intervalle.Value ;

    Intervalle.Enabled     := False ;
    ButtonStopTox.enabled  := True;
    ButtonStartTox.Enabled := False;

    //AglStartTox ( 'TESTTOX', nil, ToxTraitement, nil, '', '', '', '', '', DemarreImmediat, Delai*60 );
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// Bouton d'arr�t des �changes
////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TGestionEchange.ButtonStopToxClick(Sender: TObject);
begin
  //if AglStatusTox then
  //begin
       AglStopTox ;
       ButtonStopTox.enabled  := False;
       ButtonStartTox.Enabled := True;
       Intervalle.Enabled     := True ;
  //end;
end;

///////////////////////////////////////////////////////////////////////////////
// Fonction appel�e par AglStartTox
// Doit-on trait�e la TOX ???
//          Valeur Retourn�e       True  : la TOX doit �tre trait�e
//                                 False : la TOX sera trait�e plus tard
///////////////////////////////////////////////////////////////////////////////
procedure TGestionEchange.ToxInformation ( P: PToxEnveloppe ; var ATraiter: boolean ) ;
begin
  CompteRendu.lines.add('   ') ;
  //CompteRendu.lines.add('   Arriv�e d''un fichier TOX �mis par ' + P^.Emetteur^.Libelle + ' le ' + DateToStr(P^.DateMsg)) ;
  CompteRendu.lines.add('   Arriv�e d''un fichier TOX �mis par ' + P^.Emetteur^.Libelle) ;
  CompteRendu.lines.add('   Site Destinataire : ' + P^.Destinataire^.Libelle) ;
  CompteRendu.lines.add('   ') ;

  ATraiter := True ;
  if Confirmation.checked then
  begin
    //if PGIAsk('Arriv�e d''un fichier TOX �mis par ' + P^.Emetteur^.Libelle + ' le ' + DateToStr(P^.DateMsg) , 'Confirmation')<>mrYes then
    if PGIAsk('Arriv�e d''un fichier TOX �mis par ' + P^.Emetteur^.Libelle  , 'Confirmation')<>mrYes then
    begin
      ATraiter := False ;
    end;
  end;

   CompteRendu.lines.add('   Sortie confirmation ') ;

end ;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fonction appel�e par AglStartTox, permettant de trait�e la TOX
// Argument
//         DateFichier               Date du fichier TOX
//         SiteEmetteur              site �metteur
//         TOX                       TOX � traiter
//         AReecrire                 Si on retourne True  -> La TOX est r�-ecrite et remise dans Corbeille Arriv�e
//                                                  False -> Pas de r��criture et prise en compte de "AArchiver"
//         AArchiver                 Si on retourne True  -> TOX trait�e, elle est copi�e dans "Corbeille Trait�e"
//                                                  False -> TOX rejet�e, elle est copi�e dans "Corbeille Rejet"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TGestionEchange.ToxTraitement ( P: PToxEnveloppe ; Index: integer ; TheTob: TOB; var Areecrire, Archiver, Rejeter: boolean);
var EtatTox      : integer;
    NbTraitement : integer ;
begin

  CompteRendu.lines.add('  Traitement de la TOX �mise par ' + P^.Emetteur^.Libelle + ' le ' + FormatDateTime('ddmmyyyy', P^.DateMsg)) ;
  CompteRendu.lines.add('   Site Destinataire : ' + P^.Destinataire^.Libelle) ;
  CompteRendu.lines.add('   ') ;

  EtatTox := TraitementDeLaTox (TheTob, CompteRendu, True, AfficheDonnee.checked, AfficheErreur.checked) ;

  if EtatTox = ToxARetraiter then
  begin
    if not TheTob.FieldExists ('NB_TRAITEMENT') then
    begin
      TheTOB.AddChampSup ('NB_TRAITEMENT', False) ;
      TheTOB.PutValue    ('NB_TRAITEMENT', 1);
      NbTraitement := 1 ;
    end else
    begin
      NbTraitement := TheTOB.GetValue ('NB_TRAITEMENT');
      inc (NbTraitement) ;
      TheTOB.PutValue ('NB_TRAITEMENT', NbTraitement);
    end;
    if NbTraitement >= GetParamSoc ('SO_GCTOXNBTRT') then
    begin
      CompteRendu.lines.add('   ----> TOX trait�e ' + IntToStr (NbTraitement) + ' fois. Recopie du fichier dans la corbeille des rejets')  ;
      EtatTox := ToxRejeter ;
    end;
  end;

  if EtatTox = ToxRejeter then
  begin
    AReecrire := False ;
    Archiver  := False ;
    Rejeter   := True  ;
    CompteRendu.lines.add('   ----> Fichier rejet�')  ;
  end
  else if EtatTox = ToxIntegrer then
  begin
    AReecrire := False ;
    Archiver  := True  ;
    Rejeter   := False ;
    CompteRendu.lines.add('   ----> Fichier int�gr�')  ;
  end else
  begin
    AReecrire := True ;
    Archiver  := False;
    Rejeter   := False;
    CompteRendu.lines.add('   ----> Fichier comportant des erreurs. Il sera retrait� ult�rieurement')  ;
  end;
end ;

procedure TGestionEchange.ToxErreur ( CodeErreur: Integer ; const MessageErreur: String ) ;
begin
  ShowMessage ( 'Message TOX(' + IntToStr ( CodeErreur ) + ') ' + MessageErreur ) ;
end ;

procedure TGestionEchange.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //if AglStatusTox then AglStopTox ;
end;

procedure TGestionEchange.FormCreate(Sender: TObject);
begin
     AfficheDonnee.Checked := GetParamSoc ('SO_GCTOXAFFDONNEES');
     AfficheErreur.Checked := GetParamSoc ('SO_GCTOXAFFERREURS');
     Intervalle.Value      := GetParamSoc ('SO_GCTOXDELAI');
     Confirmation.Checked  := GetParamSoc ('SO_GCTOXCONFIRM');
end;

end.
