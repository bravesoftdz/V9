unit UClientMajP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CoolTrayIcon, Menus, Buttons, ExtCtrls, StdCtrls, ComCtrls,
  FileCtrl, Spin, ImgList,UControleUAC, Mask, UEncryptage, UbrowseRepert,Uregistry;

type
  TFlanceurMajLse = class(TForm)
    TrayIcon: TCoolTrayIcon;
    TimeUpdate: TTimer;
    ImageList7: TImageList;
    ImageList1: TImageList;
    PopupM: TPopupMenu;
    MnChangeParams: TMenuItem;
    N1: TMenuItem;
    MnFindUpdate: TMenuItem;
    N2: TMenuItem;
    MnExit: TMenuItem;
    procedure TrayIconStartup(Sender: TObject; var ShowMainForm: Boolean);
    procedure MnExitClick(Sender: TObject);
    procedure MnFindUpdateClick(Sender: TObject);
    procedure MnChangeParamsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrayIconBalloonHintClick(Sender: TObject);
    procedure TimeUpdateTimer(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    { Déclarations privées }
    ftypeMaj : string;
    //
    RepertStockage : string;
    VerifAuto : boolean;
    Intervalle : integer;
    User : string;
    Password : string;
    ServerUpd : boolean;
    LocalUpd: boolean;
    //

    procedure IsMajDisponible ;
    procedure GetInfos;
    procedure SetInfoTimer;
    procedure LanceInstall;
    function UpdateVers: boolean;

  public
    { Déclarations publiques }
  end;

var
  FlanceurMajLse: TFlanceurMajLse;

implementation

{$R *.dfm}

procedure TFlanceurMajLse.TrayIconStartup(Sender: TObject;
  var ShowMainForm: Boolean);
begin
	ShowmainForm := false;
end;

procedure TFlanceurMajLse.MnExitClick(Sender: TObject);
begin
	close;
end;

procedure TFlanceurMajLse.MnFindUpdateClick(Sender: TObject);
begin
	IsMajDisponible;
  if fTypeMaj ='C' then
  begin
  	TrayIcon.ShowBalloonHint('Information','Une mise à jour est disponible.Cliquez ici pour l''installer',bitInfo, 10);
    TrayIcon.CycleInterval := 150;
    TrayIcon.CycleIcons := true;
  end else
	if fTypeMaj='S' then
  begin
  	TrayIcon.ShowBalloonHint('Information','Une mise à jour est disponible sur le serveur.Cliquez ici pour la télécharger',bitInfo, 10);
    TrayIcon.CycleInterval := 150;
    TrayIcon.CycleIcons := true;
  end;
end;

procedure TFlanceurMajLse.MnChangeParamsClick(Sender: TObject);
var  CegidInstallApp : string;
begin
	CegidInstallApp := GetCegidInstallFolder+'APP';
//  if getUser(user)<> '' then
//  begin
//  	RunProcessAs ('LseMajInfo.exe',[],Getuser(User),Password,GetDomain(User),CegidInstallApp,true);
//  end else
//  begin
  	RunAsAdmin(self.Handle,'LseMajInfo.exe','');
//  	RunProcess ('LseMajInfo.exe',[]);
//  end;
  GetInfos;
	SetInfoTimer;
end;


procedure TFlanceurMajLse.IsMajDisponible;
var CegidInstallApp : string;
begin
	CegidInstallApp := GetCegidInstallFolder+'APP';
  TrayIcon.IconList := ImageList7;
  TrayIcon.CycleInterval := 150;
  TrayIcon.CycleIcons := True;
  if getUser(user)<> '' then
  begin
  	RunAsAdmin(self.Handle,'LseCtrlUpd.exe','/savedcreds /user:'+User)
//  	RunProcessAs ('LseCtrlUpd.exe',[],Getuser(User),Password,GetDomain(User),CegidInstallApp,true);
  end else
  begin
  	RunAsAdmin(self.Handle,'LseCtrlUpd.exe','')
//  	RunProcess ('LseCtrlUpd.exe',[]);
  end;
  TrayIcon.IconList := ImageList1;
  TrayIcon.CycleInterval := 1;
  TrayIcon.CycleIcons := false;
  fTypeMaj := IsVersionDispo;
end;

procedure TFlanceurMajLse.FormCreate(Sender: TObject);
begin
  TrayIcon.IconList := ImageList1;
  TrayIcon.CycleInterval := 1;
  TrayIcon.CycleIcons := false;
  GetInfos;
	SetInfoTimer;
end;

procedure TFlanceurMajLse.TrayIconBalloonHintClick(Sender: TObject);
begin
	TimeUpdate.Enabled := false;
  TrayIcon.IconList := ImageList7;
  TrayIcon.CycleInterval := 150;
  TrayIcon.CycleIcons := True;
	if updatevers then
  begin
  	LanceInstall;
  end;
  TimeUpdate.Enabled := true;
  TrayIcon.IconList := ImageList1;
  TrayIcon.CycleInterval := 1;
  TrayIcon.CycleIcons := false;
end;

function  TFlanceurMajLse.UpdateVers : boolean;
//var CegidInstallApp : string;
begin
	result := true;
//	if ftypeMaj = 'S' then exit; // on ne met a jour localement que si nécessaire
//	CegidInstallApp := GetCegidInstallFolder+'APP';
//  RunProcessAs ('LseUpdVers.exe',[],Getuser(User),Password,GetDomain(User),CegidInstallApp,true);
end;

procedure TFlanceurMajLse.LanceInstall;
var CegidInstallApp : string;
begin
	CegidInstallApp := GetCegidInstallFolder+'APP';
  if getUser(user)<> '' then
  begin
  	RunProcessAs ('LseUpdateCli.exe',[],Getuser(User),Password,GetDomain(User),CegidInstallApp,true);
  end else
  begin
  	RunProcess ('LseUpdateCli.exe',[]);
  end;
end;

procedure TFlanceurMajLse.GetInfos;
begin
	RepertStockage:= GetInfoStocke ('LocalFolder');
  VerifAuto := (getInfoStocke('AutoScan')='1');
  Intervalle := StrToInt(getInfoStocke('Timer'));
  User := GetInfoStocke ('user');
  Password := decrypte(GetInfoStocke ('Password'));
  if getInfoStocke('UpdMethod')='0' then ServerUpd := true else LocalUpd := true;
end;


procedure TFlanceurMajLse.TimeUpdateTimer(Sender: TObject);
begin
  MnFindUpdateClick(self);
end;

procedure TFlanceurMajLse.SetInfoTimer;
begin
  if verifAuto then
  begin
  	TimeUpdate.Interval := (60000 * Intervalle);
    TimeUpdate.Enabled := true;
  end else
  begin
    TimeUpdate.Enabled := false;
  end;
end;



procedure TFlanceurMajLse.TrayIconDblClick(Sender: TObject);
begin
  if fTypeMaj <>'' then
  begin
    TimeUpdate.Enabled := false;
    TrayIcon.IconList := ImageList7;
    TrayIcon.CycleInterval := 150;
    TrayIcon.CycleIcons := True;
    if updatevers then
    begin
      LanceInstall;
    end;
    TrayIcon.IconList := ImageList1;
    TrayIcon.CycleInterval := 1;
    TrayIcon.CycleIcons := false;
    TimeUpdate.Enabled := true;
  end;
end;

end.
