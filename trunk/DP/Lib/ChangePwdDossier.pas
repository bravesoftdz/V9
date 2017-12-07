unit ChangePwdDossier;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Vierge, Grids, Hctrls, StdCtrls, ComCtrls, HSysMenu, HTB97,
  UTob, Math, PGIAppli, LicUtil, HMsgBox;

type
  TFChangePwdDossier = class(TFVierge)
    Pages: TPageControl;
    TabPwd: TTabSheet;
    TOldPassWord: THLabel;
    FOldPassWord: TEdit;
    FPwdGlobal: TCheckBox;
    GrpPwd: TGroupBox;
    TPassWord: THLabel;
    TConfirm: THLabel;
    FPassWord: TEdit;
    FConfirm: TEdit;
    FChgPwd: TCheckBox;
    TabApplis: TTabSheet;
    HLabel1: THLabel;
    BSelectAll: TToolbarButton97;
    BDeselectAll: TToolbarButton97;
    GdApplis: THGrid;
    procedure BValiderClick(Sender: TObject);
    procedure FPwdGlobalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FChgPwdClick(Sender: TObject);
    procedure Password_OnChange(Sender: TObject);
    procedure BSelectAllClick(Sender: TObject);
    procedure BDeselectAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GdApplisClick(Sender: TObject);
  private
    { D�clarations priv�es }
    TobApplis : TOB;
    bModifs : Boolean;
    procedure ToutSelectionner(bSelect: Boolean);
    procedure AccesAuxZones(bAcces: Boolean);
  public
    { D�clarations publiques }
    NoDossier : String;
    GoodOldPassword : String;
  end;


function OuvreChangePwdDossier(nodoss: String) : Boolean ;


///////////// IMPLEMENTATION /////////////
implementation

uses PwdDossier, galOutil;

function OuvreChangePwdDossier(nodoss: String) : Boolean ;
var F: TFChangePwdDossier;
begin
  Result := False;
  if nodoss='' then exit;

  // Fait saisir le mot de passe
  F:=TFChangePwdDossier.Create(Application) ;
  F.NoDossier := nodoss;
  F.GoodOldPassword := DecryptageSt(GetPwdDossier(nodoss));
  F.Caption := 'Mot de passe du dossier ' + nodoss + ' :';
  try
    Result:=(F.ShowModal=mrOK) ;
  finally
    F.Free ;
    end ;
end;

{$R *.DFM}

procedure TFChangePwdDossier.BValiderClick(Sender: TObject);
// rq : accepte aussi un nouveau mot de passe vide (= retrait du mot de passe)
var pwdglobal, ApplisProtec, SQL : String;
    i : Integer;
    T : TOB;
begin
  if Not bModifs then begin ModalResult := mrOK; exit; end;
  
  if FOldPassword.Text<>GoodOldPassword then
    begin
    PGIInfo('L''ancien mot de passe est incorrect !');
    Pages.ActivePage := TabPwd;
    FOldPassword.SetFocus;
    end
  else if FChgPwd.Checked and (FPassword.Text<>FConfirm.Text) then
    begin
    PGIInfo('Le mot de passe et la confirmation sont diff�rents !');
    Pages.ActivePage := TabPwd;
    FConfirm.SetFocus;
    end
  else
    begin
    // Mot de passe global pour toutes les applis
    if FPwdGlobal.Checked then pwdglobal := 'X' else pwdglobal := '-';
    // Liste des applis prot�g�es
    // Rq : conserve la pr�c�dente liste, m�me si "toutes applis" est coch�
    ApplisProtec := '';
    for i := 0 to TobApplis.Detail.Count-1 do
      begin
      T := TobApplis.Detail[i];
      if GdApplis.Cells[1, i+1]='X' then
         begin
         // FQ 11372 - On ne conserve pas la liste des applis prot�g�es si on g�re un pwd global
         if pwdglobal='X' then
            GdApplis.Cells[1, i+1] := '-'
         else
           begin
           if ApplisProtec<>'' then ApplisProtec := ApplisProtec+';';
           // nom de l'exe sans .EXE
           ApplisProtec := ApplisProtec + UpperCase(Copy(T.GetValue('NomExe'), 1, Length(T.GetValue('NomExe'))-4));
           end;
         end;
      end;
    AffecteAppliProtec (NoDossier,ApplisProtec);
    SQL := 'UPDATE DOSSIER SET';
    // si modif du mot de passe demand�e
    if FChgPwd.Checked then SQL := SQL + ' DOS_PASSWORD="' + CryptageSt(FPassword.Text) + '",';
    // autres modifs
    SQL := SQL + ' DOS_PWDGLOBAL="' + pwdglobal + '"'
               + ' WHERE DOS_NODOSSIER="'+NoDossier+'"';
    ExecuteSQL(SQL);
    PGIInfo('Modifications effectu�es.');
    ModalResult := mrOK;
    end;
end;

procedure TFChangePwdDossier.FPwdGlobalClick(Sender: TObject);
begin
  bModifs := True;
  TabApplis.TabVisible := Not (FPwdGlobal.Checked);
end;

procedure TFChangePwdDossier.FormShow(Sender: TObject);
var
    i                        : Integer;
    appli                    : TPGIAppli;
    T                        : Tob;
    gammedossier, gammeappli : String;
    larg                     : Integer;
    ApplisProtec             : HTStringList;
begin
  inherited;
  // pas d'applis
  if (V_Applis=Nil) or (V_Applis.Applis.Count=0) then exit;
  gammedossier := GetGammeDossier(NoDossier);

  // Liste des applis
  TobApplis := TOB.Create('Applications', Nil, -1);
  for i := 0 to V_Applis.Applis.Count - 1 do
    begin
    appli := TPGIAppli(V_Applis.Applis[i]);

    // des applis eagl peuvent cohabiter avec des applis agl
{$IFDEF EAGLCLIENT}
    if Not appli.eAgl then Continue;
{$ELSE}
    if appli.eAgl then Continue;
{$ENDIF}

    if Not appli.Visible then Continue;
    if appli.Nom = 'CEGIDPGI.EXE' then Continue;

    // s�rie de l'appli
    if (appli.Serie='S1') or (appli.Serie='S3') then
      gammeappli := 'S1S3'
    else
      gammeappli := 'S5S7';
    if gammedossier<>gammeappli then Continue;

    // remplit TobApplis
    T := TOB.Create('Enreg', TobApplis, -1);
    T.AddChampSupValeur('NomExe', appli.Nom);
    T.AddChampSupValeur('Application', appli.Titre);
    // rq : on pourrait T.Data := appli;
    end;

  // Colonne indiquant si appli prot�g�e ou pas
  ApplisProtec := HTStringList.Create;
  FPwdGlobal.Checked := ToutesApplisProtected(NoDossier, ApplisProtec);
  TabApplis.TabVisible := Not (FPwdGlobal.Checked);
  for i := 0 to TobApplis.Detail.Count-1 do
    begin
    T := TobApplis.Detail[i];
    if ApplisProtec.IndexOf(T.GetValue('NomExe'))>-1 then
      TobApplis.Detail[i].AddChampSupValeur('Prot�g�e', 'X')
    else
      TobApplis.Detail[i].AddChampSupValeur('Prot�g�e', '-');
    end;
  ApplisProtec.Free;

  // Affichage
  larg := GdApplis.Width div 5;
  GdApplis.ColWidths[0] := 3*larg; // libell�
  GdApplis.ColWidths[1] := larg;   // case � cocher

  // Type bool�en pour pouvoir s�lectionner / d�selectionner les applis prot�g�es
  GdApplis.FlipBool := True;
  GdApplis.ColTypes[1] := 'B';
  GdApplis.ColFormats[1] := IntToStr(Ord(csCheckbox));
  GdApplis.ColEditables[1] := False;

  // remplissage
  TobApplis.PutGridDetail(GdApplis, False, False, 'Application;Prot�g�e');
  // GdApplis.RowCount := Max(TobApplis.Detail.Count+1,2); // ou TobApplis.FillesCount(0)+1;
  HMTrad.ResizeGridColumns(GdApplis);

  // acc�s au param�trage uniquement si existe un mot de passe et qu'on l'a renseign�
  AccesAuxZones( (GoodOldPassword<>'') and (FOldPassword.Text<>'') );

  Pages.ActivePage := TabPwd;

  if GoodOldPassword='' then
    begin
    FChgPwd.Caption := 'Mettre un mot de passe';
    FChgPwd.SetFocus;
    FOldPassword.Visible := False;
    TOldPassword.Visible := False;
    GrpPwd.Top := GrpPwd.Top - 20;
    end
  else
    begin
    FOldPassword.SetFocus;
    FChgPwd.Enabled := False;
    end;
end;

procedure TFChangePwdDossier.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if TobApplis<>Nil then FreeAndNil(TobApplis);
  inherited;
end;

procedure TFChangePwdDossier.FChgPwdClick(Sender: TObject);
begin
  bModifs := True;
  FPassword.Enabled := FChgPwd.Checked;
  FConfirm.Enabled := FChgPwd.Checked;
  TPassword.Enabled := FChgPwd.Checked;
  TConfirm.Enabled := FChgPwd.Checked;
  if Not FChgPwd.Checked then
    begin
    FPassword.Text := '';
    FConfirm.Text := '';
    end;
  Password_OnChange(Sender);
end;

procedure TFChangePwdDossier.Password_OnChange(Sender: TObject);
begin
  bModifs := True;
  FChgPwd.Enabled := (GoodOldPassword='') or (FOldPassword.Text<>'');
  // pas d'acc�s au param�trage si ancien mot de passe vide
  // et pas de demande de modif du mot de passe
  AccesAuxZones( ( FOldPassword.Text<>'') or ( FChgPwd.Checked and (FPassword.Text<>'') ) );
end;

procedure TFChangePwdDossier.BSelectAllClick(Sender: TObject);
begin
  ToutSelectionner(True);
end;

procedure TFChangePwdDossier.BDeselectAllClick(Sender: TObject);
begin
  ToutSelectionner(False);
end;

procedure TFChangePwdDossier.ToutSelectionner(bSelect: Boolean);
var i: Integer;
begin
  for i := 1 to GdApplis.RowCount do
    begin
    if bSelect then
      GdApplis.Cells[1, i] := 'X'
    else
      GdApplis.Cells[1, i] := '-';
    end;
end;

procedure TFChangePwdDossier.FormCreate(Sender: TObject);
begin
  inherited;
  bModifs := False;
end;

procedure TFChangePwdDossier.GdApplisClick(Sender: TObject);
begin
  inherited;
  bModifs := True;
end;

procedure TFChangePwdDossier.AccesAuxZones(bAcces: Boolean);
begin
  FPwdGlobal.Enabled := bAcces;
  GdApplis.Enabled := bAcces;
  BSelectAll.Enabled := bAcces;
  BDeselectAll.Enabled := bAcces;
end;

end.
