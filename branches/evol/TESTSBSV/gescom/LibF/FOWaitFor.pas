{***********UNITE*************************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 24/09/2003
Description .. : Fiche d'attente
Mots clefs ... : FO
*****************************************************************}
unit FOWaitFor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {$IFDEF EAGLCLIENT}
  UtileAGL,
  {$ELSE}
  MajTable,
  {$ENDIF}
  StdCtrls, Hctrls, Mask, HTB97, HMsgBox, ExtCtrls;

type
  TFFOWaitFor = class(TForm)
    Dock971: TDock97;
    PBouton: TToolWindow97;
    BValider: TToolbarButton97;
    BFerme: TToolbarButton97;
    DATE: THCritMaskEdit;
    TDATE: THLabel;
    HEURE: THCritMaskEdit;
    THEURE: THLabel;
    LIBELLE: TLabel;
    TITRE: TLabel;
    BStop: TToolbarButton97;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BStopClick(Sender: TObject);
  private
    { D�clarations priv�es }
    IsConnected : Boolean;
    NomDossier: string;
    MultiUserLogin: boolean;
    DateDepart : TDateTime;
    procedure Deconnexion;
    procedure Connexion;
    function VerifDateDepart(DateDepart: TDateTime): boolean;
  public
    { D�clarations publiques }
  end;

function FOLanceDiffere(Titre: string): boolean;

implementation

{$R *.DFM}

uses
  HEnt1;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : Lancement diff�r� avec attente
Mots clefs ... : FO
*****************************************************************}

function FOLanceDiffere(Titre: string): boolean;
var
  XX: TFFOWaitFor;
begin
  SourisSablier;
  XX := TFFOWaitFor.Create(Application);
  if Titre <> '' then XX.Caption := Titre;
  try
    XX.ShowModal;
  finally
    Result := (XX.ModalResult in [mrOk, mrAbort]);
    XX.Free;
  end;
  SourisNormale;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : D�connexion de la base
Mots clefs ... : FO
*****************************************************************}

procedure TFFOWaitFor.Deconnexion;
begin
  IsConnected := False;
  NomDossier := V_PGI.CurrentAlias;
  MultiUserLogin := V_PGI.MultiUserLogin;
  LIBELLE.Caption := TraduireMemoire('D�connexion de la soci�t� ') + NomDossier;
  DeconnecteHalley;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : Reconnexion � la base
Mots clefs ... : FO
*****************************************************************}

procedure TFFOWaitFor.Connexion;
begin
  if Not IsConnected then
  begin
    LIBELLE.Caption := TraduireMemoire('Connexion � la soci�t� ') + NomDossier;
    V_PGI.MultiUserLogin := True;
    {$IFDEF EAGLCLIENT}
      if not ConnecteHalley(NomDossier, False, nil, nil, nil) then
        PGIError('Erreur de connexion n�' + IntToStr(V_PGI.ErreurLogin))
    {$ELSE}
      if not ConnecteHalley(NomDossier, False, nil, nil, nil, nil, False, False) then
        PGIError('Erreur de connexion n�' + IntToStr(V_PGI.ErreurLogin))
    {$ENDIF}
      else IsConnected := True;
    V_PGI.MultiUserLogin := MultiUserLogin;
  end;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : V�rifie si la date de d�part n'est pas d�pass�e
Mots clefs ... : FO
*****************************************************************}

function TFFOWaitFor.VerifDateDepart(DateDepart: TDateTime): boolean;
begin
  Result := ((ModalResult in [mrNone, mrOk]) and (Now < DateDepart));
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : FormShow
Mots clefs ... : FO
*****************************************************************}

procedure TFFOWaitFor.FormShow(Sender: TObject);
var
  Stg: string;
begin
  IsConnected := True;
  LIBELLE.Caption := '';
  Stg := TimeToStr(Now);
  HEURE.Text := Copy(Stg, 1, HEURE.MaxLength);
  // Appel de la fonction d'empilage dans la liste des fiches
  AglEmpileFiche(Self);
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : FormDestroy
Mots clefs ... : FO
*****************************************************************}

procedure TFFOWaitFor.FormDestroy(Sender: TObject);
begin
  // Appel de la fonction de d�pilage dans la liste des fiches
  AglDepileFiche;
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : N. ACHINO
Cr�� le ...... : 23/07/2003
Modifi� le ... : 23/07/2003
Description .. : Click sur BValider
Mots clefs ... : FO
*****************************************************************}

procedure TFFOWaitFor.BValiderClick(Sender: TObject);
begin
  if not BValider.Enabled then Exit;

  DateDepart := StrToDate(DATE.Text) + StrToTime(HEURE.Text);
  if VerifDateDepart(DateDepart) then
  begin
    BValider.Enabled := False;
    DATE.Enabled := False;
    HEURE.Enabled := False;
    Deconnexion;
    SourisSablier;
    Timer1.Enabled := True;
  end
  else PGIError('La date de d�marrage souhait�e est inf�rieure � la date syst�me');
end;

procedure TFFOWaitFor.Timer1Timer(Sender: TObject);
var
  Hour, Min, Sec, MSec: word;
  TpsReste: TDateTime;
begin
  TpsReste := DateDepart - Now;
  DecodeTime(TpsReste, Hour, Min, Sec, MSec);
  Hour := Hour + (Trunc(TpsReste) * 24);
  LIBELLE.Caption := TraduireMemoire('Il reste � attendre')
    + Format(' %dh %.2dm %.2ds', [Hour, Min, Sec]);
  if Not VerifDateDepart(DateDepart) then
  begin
    Timer1.Enabled := False;
    Connexion;
    SourisNormale;
    ModalResult := MrOk;
  end;
end;

procedure TFFOWaitFor.BStopClick(Sender: TObject);
begin
  Timer1.Enabled := False;
  Connexion;
  SourisNormale;
end;

end.
