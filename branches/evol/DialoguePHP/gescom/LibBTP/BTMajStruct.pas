unit BTMajStruct;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ComCtrls, StdCtrls, Hctrls, ExtCtrls, Hgauge,UTob,EntGc,HEnt1, UBob, FileCtrl,
{$IFDEF EAGLCLIENT}
     UtileAGL,uHttp,uWaini,
{$ELSE}
     DBGrids,
     DBCtrls,
     DB,
    {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     MajTable,
     HDB,

{$ENDIF}
		 uBTPVerrouilleDossier,	
     UtilPGI,
     HMsgBox ;

type

  TfbtMajStructure = class(TForm)
    Titre: THLabel;
    PB: TEnhancedGauge;
    CURVUE: THLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

  TMajStructBTP = class
  private
    fCodeStatus : integer;
    TheListModifDest,TheListModifRef : TOB;
    DBRef : TDatabase;
    DestDriver: TDBDriver;
    DestODBC: Boolean;
    RefDriver : TDBDriver;
    RefODBC : Boolean;
    IsFirstChange : boolean;
    IsModeMajHalley : boolean;
    XX :  TfbtMajStructure;
    LanceMajVues : boolean;
    procedure TraiteChangementTable (TheListRef : TOB);
    procedure TraiteChangementParamSoc (TheListRef : TOB);
    procedure GetStructureTableFromRef (TheSTructureRef : TOB; NomTable : string);
    procedure TraiteChangementMenu (TheListRef : TOB);
    procedure TraiteModifVue (TheListRef : TOB);
    procedure CreeTable(TheStructureRef: TOB; NomTable: string);
    function ModifieTable(TheStructureRef: TOB; NomTable: string): boolean;
    procedure InitChampsAjoute (NomTable : string);
    function IsATraiter (NomTable : string) : boolean;
    procedure SetCodeStatus(const Value: integer);
    procedure GetParamSocs (TheListRef,TheParamSocsRef,TheParamSocsDest : TOB);
    function GetRequete(TheListRef: TOB; DBREF: TDatabase): string;
    procedure UpDateDecoupeLigne(SetSQL: string; SetCondition: string='');
    procedure UpDateDecoupeLigneOuvPlat(SetSQL: string; SetCondition: string='');
    procedure UpDateDecoupeLigneCompl(SetSQL:string; SetCondition: string='');
    procedure UpDateDecoupeLigneOUV(SetSQL:string; SetCondition: string='');
    procedure UpDateDecoupePiece(SetSQL:string; SetCondition: string='');
    function GetVueRef(NomVue: string): TOB;
    function IsTraiteVue(TOBRef, TOBDest: TOB): boolean;
    function GetVueDestination(NomVue: string): TOB;
    procedure DropVuesPhysiques;
    procedure CreateVuesPhysiques;
    procedure GetMenus(NumeroMenu: string; TheMenusRef,TheMenusDest: TOB);
    procedure DropMenuDest(NumeroMenu: string);
  public
    property CodeStatus : integer read fCodeStatus write SetCodeStatus;
    constructor create;
    destructor destroy; override;
    procedure lance;
    function IsTablesATraiter : boolean;
  end;


const TEMPTABLE = 'TEMPOR';


function DEVBTP_IMPORT_BOB : Integer;
function MajStructure (IsModeMajHalley : boolean=false): integer;

implementation
uses ChangeVersions;
{$R *.DFM}

{***************************************************************
Intégration des BOBS de développement BTP
*****************************************************************}
function DEVBTP_IMPORT_BOB : Integer;
var sFileBOB                :string;
    Chemin			            :string;
    SearchRec               :TSearchRec;
    ret                     :integer;
BEGIN
  // CODE RETOUR DE LA FONCTION
  Result := 0;

  Chemin := '\\srv-lyo-btp\d$\pgis5\ProjetsBTP\Distrib\BOBS_AUTO_V703\';
  if Not (DirectoryExists (Chemin)) then Exit;

  ret := FindFirst(Chemin+'*.BO*', faAnyFile, SearchRec);
  while ret = 0 do
  begin
       //RECUPERE NOM DU BOB
       sFileBOB := SearchRec.Name;

       case AGLIntegreBob(Chemin + sFileBOB,FALSE,TRUE) of
            0  : Pgiinfo('Intégration de : '+sFileBOB, TitreHalley); //intégration ok
            1  : if V_PGI.SAV then Pgiinfo('Intégration déjà effectuée :'+sFileBOB, TitreHalley);// Intégration déjà effectuée
           -1  :// Erreur d'écriture dans la table YMYBOBS
                begin
                     PGIInfo('Erreur d''écriture dans la table YMYBOBS :'+Chemin + sFileBOB,'DEVBTP_IMPORT_BOB');
                end;
           -2  :// Erreur d'intégration dans la fonction AglImportBob
                begin
                     PGIInfo('Erreur d''intégration dans la fonction AglImportBob :'+Chemin + sFileBOB,'DEVBTP_IMPORT_BOB');
                end;
           -3  ://Erreur de lecture du fichier BOB.
                begin
                     PGIInfo('Erreur de lecture du fichier BOB :'+Chemin + sFileBOB,'DEVBTP_IMPORT_BOB');
                end;
           -4  :// Erreur inconnue.
                begin
                     PGIInfo('Erreur inconnue :'+Chemin + sFileBOB,'DEVBTP_IMPORT_BOB');
                end;
            end;
       ret := FindNext(SearchRec);
   end;
   sysutils.FindClose(SearchRec);
END;

function MajStructure (IsModeMajHalley : boolean=false): integer;
var TheMajStruct : TmajStructBTP;
begin
  //
	if not IsModeMajHalley then
  begin
    if ISVerrouille Then
    begin
      PGIInfo ('Un traitement de mise à jour est en cours..#13#10 Merci de vous reconnecter ultérieurement.');
      result := -1 ;
      exit;
    end;
  end;
  //
  TheMajStruct := TMajStructBTP.create;
  TRY
  	TheMajStruct.IsModeMajHalley := IsModeMajHalley;
    if TheMajStruct.IsTablesATraiter then
    begin
      //
      if not IsModeMajHalley then
      begin
        if PGIAsk  ('Le produit nécessite une mise à jour de structure.#13#10 Avez-vous fait la sauvegarde ?')=MrYes then
        begin
          if PgiAsk ('Confirmez-vous le traitement ?')=Mryes then
          begin
            TheMajStruct.Lance;
            If TheMajStruct.CodeStatus = 1 then
              PGIInfo ('Traitement de mise à jour terminé avec succès.');
          end else TheMajStruct.CodeStatus := -1;
        end else TheMajStruct.CodeStatus := -1;
      end else
      begin
        TheMajStruct.Lance;
      end;
    end;
  FINALLY
    result := TheMajStruct.CodeStatus;
    TheMajStruct.free;
		if not IsModeMajHalley then
    begin
    	Deverrouille;
    end;
  END;
end;


{ TMajStructBTP }

procedure TMajStructBTP.GetStructureTableFromRef(TheSTructureRef: TOB;NomTable: string);
var QQ : TQuery;
begin
  QQ := OpenSQLDb (DBREF,'SELECT * FROM DETABLES WHERE DT_NOMTABLE="'+NomTable+'"',true);
  if QQ.eof then BEGIN fCodeStatus := 120; Exit; END;
  TheSTructureRef.SelectDB ('',QQ);
  ferme (QQ);
  QQ := OpenSQLDb (DBREF,'SELECT * FROM DECHAMPS WHERE DH_PREFIXE="'+TheSTructureRef.getValue('DT_PREFIXE')+'"',true);
  TheSTructureRef.LoadDetailDB ('DECHAMPS','','',QQ,false);
  ferme (QQ);
end;

function TMajStructBTP.IsTablesATraiter: boolean;
var QQ : TQuery;
    VersionRef, VersionDest : string;
    TheModifDest,TheModifRef : TOB;
begin
  result := false;
  if TableExiste ('BTMAJSTRUCTURES') then
  begin
    QQ := OpenSql ('SELECT * FROM BTMAJSTRUCTURES',true);
    TheListModifDest.LoadDetailDB ('BTMAJSTRUCTURES','','',QQ,false);
    ferme (QQ);
  end;
  if TableExisteDB  ('BTMAJSTRUCTURES',DBREF) then
  begin
    QQ := OpenSQLDb (DBREF,'SELECT * FROM BTMAJSTRUCTURES',true);
    TheListModifRef.LoadDetailDB ('BTMAJSTRUCTURES','','',QQ,false);
    ferme (QQ);
  end;

  if TheListModifRef.detail.count > 0 then
  begin
    VersionRef := '';
    VersionDest := '';
    //
    TheModifRef := TheListModifRef.findFirst(['BTV_TYPEELT'],['VERSION'],True);
    versionRef := TheModifRef.getValue('BTV_VERSIONBASEB');
    TheModifDest := TheListModifDest.findFirst(['BTV_TYPEELT'],['VERSION'],True);
    if TheModifDest <> nil then
    begin
      VersionDest :=TheModifDest.GetValue('BTV_VERSIONBASEB');
    end;
    if VersionRef <= VersionDest then exit;
  end else exit;
  result := True;
end;

constructor TMajStructBTP.create;
begin
  IsFirstChange := true;
  fCodeStatus := 0;
  TheListModifDest  := TOB.create ('LES TABLES MODIFIEES PAR BATIMENT',nil,-1);
  TheListModifRef := TOB.create ('LES TABLES A MODIFIER',nil,-1);
  // Sauvegarde du contexte
  DestDriver := V_PGI.Driver; DestODBC := V_PGI.ODBC; V_PGI.StopCourrier := TRUE;
  //
  DBRef := TDatabase.Create(Application);
  DBRef.Name := 'DBREF';
  // Overture de la base REF
  ConnecteDB('Reference', DBRef, 'DBREF');
  RefDriver := V_PGI.Driver; RefODBC := V_PGI.ODBC;
  //
  XX := TfbtMajStructure.Create(Application);  // partie IHM
  XX.Visible := false;
end;

destructor TMajStructBTP.destroy;
begin
  XX.free;
  DBRef.Connected := False;
  DBRef.Free;
  //
  TheListModifDest.free;
  TheListModifRef.free;
  //
  V_PGI.Driver := DestDriver; V_PGI.ODBC := DestODBC; V_PGI.StopCourrier := FALSE;

  inherited;
end;

procedure TMajStructBTP.lance;
var Indice : integer;
    TheListRef : TOB;
    QQ : TQUery;
begin
  if not IsModeMajHalley then
  begin
  	XX.Visible := true;
  	V_Pgi.EnableDeShare := False;
    LanceMajVues := False;

    for Indice := 0 to TheListModifRef.detail.count -1 do
    begin
      TheListref := TheListModifRef.detail[Indice];
      if TheListRef.GetValue('BTV_TYPEELT')='VERSION' then
      begin
        continue;
      end else if TheListRef.GetValue('BTV_TYPEELT')='TABLE' then
      begin
        TraiteChangementTable (TheListRef);
      end else if TheListRef.GetValue('BTV_TYPEELT')='VUE' then
      begin
        TraiteModifVue (TheListRef);
      end else if TheListRef.GetValue('BTV_TYPEELT')='PARAMSOC' then
      begin
        TraiteChangementParamSoc (TheListRef);
      end else if TheListRef.GetValue('BTV_TYPEELT')='MENU' then
      begin
        TraiteChangementMenu (TheListRef);
      end;
      if fCodeStatus > 1 then break;
    end;
    if (fCodeStatus <= 1) then
    BEGIN
      V_Pgi.EnableDeShare := true;
      if LanceMajVues then
      begin
        DropVuesPhysiques ;
        CreateVuesPhysiques;
      end;
    END;
    XX.visible := false;
  end else
  begin
    QQ := OpenSQLDb (DBREF,'SELECT * FROM BTMAJSTRUCTURES',true);
    TheListModifRef.LoadDetailDB ('BTMAJSTRUCTURES','','',QQ,false);
    ferme (QQ);

  	ExecuteSql ('DELETE FROM BTMAJSTRUCTURES');
    TheListModifDest.dupliquer (TheListModifRef,true,true);
    TheListModifDest.InsertDB(nil);
  end;
end;

procedure TMajStructBTP.TraiteChangementParamSoc(TheListRef: TOB);
var NomParamSoc : string;
    TheParamSocsRef,TheParamSocsDest : TOB;
    TheParamSocRef,TheParamSocDest : TOB;
    indice : integer;
    QQ : TQuery;
begin
  TheParamSocsref := TOB.create ('LES PARAMS SOC',nil,-1);
  TheParamSocsDest := TOB.create ('LES PARAMS SOCD',nil,-1);

  NomparamSoc := TheLIstRef.GetValue ('BTV_NOMELT');
	XX.Titre.Caption := 'Mise à jour de Paramètres Sociétés';
  XX.Titre.visible := true;
  XX.Titre.Refresh;
  XX.PB.Visible := true;
  XX.Refresh;
  GetParamSocs (TheListRef,TheParamSocsRef,TheParamSocsDest);
  for indice := 0 to TheParamSocsref.detail.count -1 do
  begin
    TheParamSocRef :=TheParamSocsref.detail[Indice];
    TheParamSocDest := TheParamSocsDest.findFirst(['SOC_NOM'],[TheParamSocRef.GetValue('SOC_NOM')],true);
    if TheParamSocDest = nil then
    begin
      TheParamSocDest := TOB.Create('PARAMSOC',TheParamSocsDest,-1);
      QQ := OpenSql ('SELECT * FROM PARAMSOC WHERE SOC_NOM="'+TheParamSocRef.GetValue('SOC_NOM')+'"',true);
      if QQ.eof then
      begin
        // Nouveau paramsoc
        TheParamSOcDest.Dupliquer (TheParamSocRef,false,true);
        TheParamSocDest.SetAllModifie (true);
      end else
      begin
        // Cas particulier du changement de SOC_TREE
        TheParamSocDest.selectDB('',QQ);
        TheParamSocDest.putValue('SOC_DESIGN',TheParamSocRef.GetValue('SOC_DESIGN'));
        TheParamSocDest.putValue('SOC_TREE',TheParamSocRef.GetValue('SOC_TREE'));
        if TheListRef.GetValue('BTV_WITHDATA')='X' then
        begin
          TheParamSocDest.putValue('SOC_DATA',TheParamSocRef.GetValue('SOC_DATA'));
        end;
        TheParamSocDest.SetAllModifie (true);
      end;
      ferme (QQ);
    end else
    begin
      TheParamSocDest.putValue('SOC_DESIGN',TheParamSocRef.GetValue('SOC_DESIGN'));
      TheParamSocDest.putValue('SOC_TREE',TheParamSocRef.GetValue('SOC_TREE'));
      if TheListRef.GetValue('BTV_WITHDATA')='X' then
      begin
        TheParamSocDest.putValue('SOC_DATA',TheParamSocRef.GetValue('SOC_DATA'));
      end;
      TheParamSocDest.SetAllModifie (true);
    end;
  end;
  //
  if TheParamSocsref.detail.count <> 0 then
  begin
    TheParamSocsDest.InsertOrUpdateDB (true);
  end;
  //
  TheParamSocsref.free;
  TheParamSocsDest.free;
  //
end;

procedure TMajStructBTP.TraiteChangementTable(TheListRef: TOB);
var NomTable : string;
    TheStructureRef : TOB;
begin

  NomTable := TheLIstRef.GetValue ('BTV_NOMELT');
	XX.Titre.Caption := 'Mise à jour de '+NomTable;
  XX.Titre.visible := true;
  XX.Titre.Refresh;
  XX.PB.Visible := true;
  XX.Refresh;
  //
  TheStructureRef := TOB.Create ('DETABLES',nil,-1);
  //
  if TableExisteDB (NomTable,DBREF) then
  begin
    //
    //
    fCodeStatus := 0;
    GetStructureTableFromRef (TheSTructureRef,NomTable);
    if fCodeStatus <> 0 then exit;
    if not TableExiste (NomTable) then
    begin
      XX.PB.MinValue := 0;
      XX.PB.MaxValue  := 3;
      CreeTable (TheStructureRef,NomTable);
      if fCodeStatus <> 0 then exit;
      if TheListRef.GetValue('BTV_WITHDATA')='X' then
      begin
        DBCOPYTABLEBM(DBREF, DBSOC, NomTable, NomTable);
        XX.PB.Progress := XX.PB.Progress + 1;
      end;
      LanceMajVues := True;
    end else
    begin
      XX.PB.MinValue := 0;
      XX.PB.MaxValue  := 8;
      if ModifieTable (TheStructureRef,NomTable) then
      begin
        InitChampsAjoute (NomTable);
        LanceMajVues := True;
      end;
      XX.PB.Progress := XX.PB.Progress + 1;
      if NomTable = 'BTMAJSTRUCTURES' then
      begin
        ExecuteSql ('DELETE FROM BTMAJSTRUCTURES');
        DBCOPYTABLEBM(DBREF, DBSOC, NomTable, NomTable);
      end;
    end;
  end;
  //
  fcodeStatus := 1;
  TheStructureRef.free;
end;

procedure TMajStructBTP.CreeTable (TheStructureRef : TOB;NomTable : string);
begin
  DbCreateTable(DBSOC, TheStructureRef, DestDriver, false);
  XX.PB.Progress := XX.PB.Progress + 1;
//  DBCREATEINDEX(DBSOC, TheStructureRef, DestDriver);
  XX.PB.Progress := XX.PB.Progress + 1;
  // Mise à jour de DETABLES ET DECHAMPS
  TheStructureRef.SetAllModifie (true);
  TheSTructureRef.InsertDB (nil);
end;

function TMajStructBTP.ModifieTable (TheStructureRef : TOB;NomTable : string) : boolean;
begin
	result := false;
  if not IsATraiter (NomTable) then exit;
  result := true;
  if TableExiste (TEMPTABLE) then DBDeleteTable(DBSOC,DestDriver, TEMPTABLE, TRUE);
  XX.PB.Progress := XX.PB.Progress + 1;
  // Phase 2 : Création de la table temporaire avec la nouvelle structure
  DbCreateTable(DBSOC, TheStructureRef, DestDriver, TRUE);
  XX.PB.Progress := XX.PB.Progress + 1;

  // Phase 3 : Copie de l'ancienne table dans la nouvelle table
  DBCOPYTABLEBM(DBSOC, DBSOC, NomTable, TEMPTABLE);
  XX.PB.Progress := XX.PB.Progress + 1;

  // Suppression de DETABLES et DECHAMPS
  ExecuteSql('DELETE FROM DECHAMPS WHERE DH_PREFIXE="' +TheStructureRef.GetValue('DT_PREFIXE') + '"');
  ExecuteSql('DELETE FROM DETABLES WHERE DT_NOMTABLE="' +TheStructureRef.GetValue('DT_NOMTABLE') + '"');
  XX.PB.Progress := XX.PB.Progress + 1;

  // Phase 4 : Suppression de l'ancienne table
  DBDeleteTable(DBSOC, DestDriver, NomTable, TRUE);
  XX.PB.Progress := XX.PB.Progress + 1;

  // Phase 5 : Renommage de la table temporaire sous le nouveau nom
  DBRenameTable(DBSOC, DestDriver, TEMPTABLE, NomTable);
  XX.PB.Progress := XX.PB.Progress + 1;

  // Phase 6 : Création des index
  //  ConnecteTRUEFALSE(DBSOC);
  DBCREATEINDEX(DBSOC, TheStructureRef, DestDriver);
  XX.PB.Progress := XX.PB.Progress + 1;
  // Mise à jour de DETABLES ET DECHAMPS
  TheStructureRef.SetAllModifie (true);
  TheSTructureRef.InsertDB (nil);
end;

procedure TMajStructBTP.InitChampsAjoute(NomTable: string);
begin
  if NomTable = 'CODECPTA' then
  begin
    ExecuteSql ('UPDATE CODECPTA SET GCP_FAMILLETAXE="" WHERE GCP_FAMILLETAXE IS NULL');
  end else
  if NomTable = 'DECISIONACHLIG' then
  begin
    ExecuteSql ('UPDATE DECISIONACHLIG SET BAD_PABASE=0 WHERE BAD_PABASE IS NULL');
    ExecuteSql ('UPDATE DECISIONACHLIG SET BAD_COEFUAUS=0 WHERE BAD_COEFUAUS IS NULL');
  end else
  if NomTable = 'DECISIONACHLFOU' then
  begin
    ExecuteSql ('UPDATE DECISIONACHLFOU SET BDF_COEFUAUS=0 WHERE BDF_COEFUAUS IS NULL');
  end else if NomTable = 'LIGNEOUVPLAT' then
  begin
		 UpdateDecoupeLigneOuvPlat('BOP_MONTANTPR=0, BOP_COEFFG=0, BOP_COEFFR=0, BOP_COEFFC=0',' AND (BOP_COEFFC IS NULL)');
  end else if NomTable = 'AFFAIRE' then
  begin
    ExecuteSql ('UPDATE AFFAIRE SET AFF_FACTURE=(SELECT T_FACTURE FROM TIERS WHERE T_TIERS=AFF_TIERS AND T_NATUREAUXI IN ("CLI","PRO")) WHERE AFF_FACTURE IS NULL');
  end else if NomTable = 'FACTAFF' then
  begin
    ExecuteSql ('UPDATE FACTAFF SET AFA_DATEDEBUTFAC='+DatetoStr(IDate1900)+',AFA_DATEFINFAC='+DateToStr(Idate1900)+' WHERE AFA_DATEDEBUTFAC IS NULL');
  end else if NomTable = 'HRPARAMPLANNING' then
  begin
    ExecuteSql ('UPDATE HRPARAMPLANNING SET HPP_REGCOL1="-", HPP_REGCOL2="-", HPP_REGCOL3="-" WHERE HPP_REGCOL1 IS NULL');
  end else if nomTable ='PARCTIERS' then
  begin
    ExecuteSql ('UPDATE PARCTIERS SET BP1_DATEFINSERIA="20991231" WHERE BP1_DATEFINSERIA IS NULL');
  end else if nomTable ='PIEDECHE' then
  begin
    ExecuteSql ('UPDATE PIEDECHE SET GPE_CODE="",GPE_TIMBRE=0 WHERE GPE_CODE IS NULL');
  end;
end;

function TMajStructBTP.IsATraiter(NomTable: string): boolean;
var QQ : TQUery;
    Versionref,Versiondest : integer;
begin
  QQ := OpenSQLDb (DBREF,'SELECT DT_NUMVERSION FROM DETABLES WHERE DT_NOMTABLE="'+NomTable+'"',true);
  VersionRef := QQ.findfield('DT_NUMVERSION').AsInteger;
  ferme(QQ);
  QQ := OpenSQLDb (DBSOC,'SELECT DT_NUMVERSION FROM DETABLES WHERE DT_NOMTABLE="'+NomTable+'"',true);
  VersionDest := QQ.findfield('DT_NUMVERSION').AsInteger;
  ferme(QQ);
  result:= (VersionRef > Versiondest);
end;

procedure TMajStructBTP.SetCodeStatus(const Value: integer);
begin
  fCodeStatus := Value;
end;

function TMajStructBTP.GetRequete(TheListRef : TOB;DBREF: TDatabase) : string;
begin
  if (Pos (';',TheListRef.GetValue('BTV_NOMELT'))> 0) or IsNumeric (TheListRef.GetValue('BTV_NOMELT')) then
  begin
    // On a affaire ici a une branche
    result := 'SELECT * FROM PARAMSOC WHERE SOC_TREE LIKE "'+TheListRef.GetValue('BTV_NOMELT')+'%"'
  end else
  begin
    // On a affaire ici a un parametre nommé
    result := 'SELECT * FROM PARAMSOC WHERE SOC_NOM = "'+TheListRef.GetValue('BTV_NOMELT')+'"';
  end;
end;

procedure TMajStructBTP.GetParamSocs(TheListRef,TheParamSocsRef,TheParamSocsDest: TOB);
var Sql : string;
    QQ : TQUery;
begin
  Sql := GetRequete(TheListRef,DBREF);
  QQ := OpenSQLDb(DBREF,Sql,True);
  TheParamSocsRef.LoadDetailDB ('PARAMSOC','','',QQ,false);
  ferme(QQ);
  Sql := GetRequete(TheListRef,DBSOC);
  QQ := OpenSql (Sql,True);
  TheParamSocsDest.LoadDetailDB ('PARAMSOC','','',QQ,false);
  ferme(QQ);
  //
end;

procedure TMajStructBTP.DropMenuDest(NumeroMenu : string);
var Sql,Menus : string;
    Mn1,Mn2,Mn3,Mn4 : string;
begin
	menus := NumeroMenu;
  Mn1 := '';
  Mn2 := '';
  Mn3 := '';
  Mn4 := '';
  //
  Mn1 := READTOKENST(Menus);
  if Menus <> '' then
  begin
  	Mn2 := READTOKENST(Menus);
  end;
  if Menus <> '' then
  begin
  	Mn3 := READTOKENST(Menus);
  end;
  if Menus <> '' then
  begin
  	Mn4 := READTOKENST(Menus);
  end;
  Sql := 'DELETE FROM MENU WHERE MN_1='+Mn1;
  if Mn2 <> '' then
  begin
  	Sql := Sql + ' AND MN_2='+Mn2;
  end;
  if Mn3 <> '' then
  begin
  	Sql := Sql + ' AND MN_3='+Mn3;
  end;
  if Mn4 <> '' then
  begin
  	Sql := Sql + ' AND MN_4='+Mn4;
  end;
  Sql := SQl + ' AND MN_TAG < 900000';
  ExecuteSql (Sql);
end;

procedure TMajStructBTP.GetMenus(NumeroMenu : String;TheMenusRef,TheMenusDest: TOB);
var Sql,Menus : string;
    QQ : TQUery;
    Mn1,Mn2,Mn3,Mn4 : string;
begin
	menus := NumeroMenu;
  Mn1 := '';
  Mn2 := '';
  Mn3 := '';
  Mn4 := '';
  //
  Mn1 := READTOKENST(Menus);
  if Menus <> '' then
  begin
  	Mn2 := READTOKENST(Menus);
  end;
  if Menus <> '' then
  begin
  	Mn3 := READTOKENST(Menus);
  end;
  if Menus <> '' then
  begin
  	Mn4 := READTOKENST(Menus);
  end;
  Sql := 'SELECT * FROM MENU WHERE MN_1='+Mn1;
  if Mn2 <> '' then
  begin
  	Sql := Sql + ' AND MN_2='+Mn2;
  end;
  if Mn3 <> '' then
  begin
  	Sql := Sql + ' AND MN_3='+Mn3;
  end;
  if Mn4 <> '' then
  begin
  	Sql := Sql + ' AND MN_4='+Mn4;
  end;
  Sql := SQl + ' AND MN_TAG < 900000';
  QQ := OpenSQLDb(DBREF,Sql,True);
  TheMenusRef.LoadDetailDB ('MENU','','',QQ,false);
  ferme(QQ);
  QQ := OpenSql (Sql,True);
  TheMenusDest.LoadDetailDB ('MENU','','',QQ,false);
  ferme(QQ);
  //
end;

procedure TMajStructBTP.UpDateDecoupeLigneOuvPlat(SetSQL: string; SetCondition: string='');
var NMin, NMax, NCount, NN1, NN2, NbStep: integer;
  ListeNat, ListeSouche: TStrings;
  Q: TQuery;
  QMax: TQuery;
  i, k: integer;
  NbDebutTranche: integer;
  NbFinTranche: integer;
  //PremierNumero: integer;
  DernierNumero: integer;
  //SQL : string ;
begin
  // Lecture des natures
  ListeNat := TStringList.Create;
  ListeSouche := TStringList.Create;
  Q := OpenSQL('Select DISTINCT BOP_NATUREPIECEG, BOP_SOUCHE FROM LIGNEOUVPLAT', True);
  while not Q.EOF do
  begin
    ListeNat.Add(Q.Fields[0].AsString);
    ListeSouche.Add(Q.Fields[1].AsString);
    Q.Next;
  end;
  Ferme(Q);
  // Balayage des pièces avec découpe
  for i := 0 to ListeNat.Count - 1 do
  begin
    // Récupération du plus grand numéros possible
    QMax := OpenSQL('SELECT MIN(BOP_NUMERO), MAX(BOP_NUMERO),COUNT(*) FROM LIGNEOUVPLAT WHERE BOP_NATUREPIECEG="' + ListeNat[i] + '" AND BOP_SOUCHE="' + ListeSouche[i] +
                    '"', True);
    //PremierNumero := QMax.Fields[0].AsInteger;
    DernierNumero := QMax.Fields[1].AsInteger;
    NCount := QMax.Fields[2].AsInteger;
    Ferme(QMax);

    if NCount > 50000 then
    begin
      // Première tranche traitée : 0 à 1000000
      NbDebutTranche := 0;
      NbFinTranche := 1000000;

      while (NbDebutTranche < DernierNumero) do
      begin
        // Récupère le premier et le dernier numéro à traiter dans la tranche
        QMax := OpenSQL('SELECT MIN(BOP_NUMERO), MAX(BOP_NUMERO),COUNT(*) FROM LIGNEOUVPLAT WHERE BOP_NATUREPIECEG="' + ListeNat[i] + '" AND BOP_SOUCHE="' +
          ListeSouche[i] + '" AND BOP_NUMERO>=' + IntToStr(NbDebutTranche) + ' AND BOP_NUMERO<' + IntToStr(NbFinTranche) + '', True);
        NMin := QMax.Fields[0].AsInteger;
        NMax := QMax.Fields[1].AsInteger;
        NCount := QMax.Fields[2].AsInteger;
        Ferme(QMax);

        if NCount > 0 then
        begin
          NbStep := (NMax - NMin) div 25000;
          for k := 0 to NbStep do
          begin
            NN1 := NMin + k * 25000;
            if k < NbStep then NN2 := NN1 + 25000 else NN2 := NMax;
            BeginTrans;
            ExecuteSQL('UPDATE LIGNEOUVPLAT SET ' + SetSQL + ' WHERE BOP_NATUREPIECEG="' + ListeNat[i] + '" AND BOP_SOUCHE="' + ListeSouche[i] + '" AND BOP_NUMERO>=' +
                        IntToStr(NN1) + ' AND BOP_NUMERO<=' + IntToStr(NN2) + ' ' + SetCondition );
            CommitTrans;
          end;
        end;
        // Tranche suivante
        NbDebutTranche := NbDebutTranche + 1000000;
        NbFinTranche := NbFinTranche + 1000000;
      end;
      // sinon trou ds la numéraotation, update pour la souche
    end else ExecuteSQL('UPDATE LIGNEOUVPLAT SET ' + SetSQL + ' WHERE BOP_NATUREPIECEG="' + ListeNat[i] + '" AND BOP_SOUCHE="' + ListeSouche[i] + '"' + ' ' + SetCondition);
  end;
  ListeNat.Clear;
  ListeNat.Free;
  ListeSouche.Clear;
  ListeSouche.Free;
end;

procedure TMajStructBTP.UpDateDecoupeLigne(SetSQL: string; SetCondition : string ='');
var NMin, NMax, NCount, NN1, NN2, NbStep: integer;
  ListeNat, ListeSouche: TStrings;
  Q: TQuery;
  QMax: TQuery;
  i, k: integer;
  NbDebutTranche: integer;
  NbFinTranche: integer;
  //PremierNumero: integer;
  DernierNumero: integer;
  //SQL : string ;
begin
  // Lecture des natures
  ListeNat := TStringList.Create;
  ListeSouche := TStringList.Create;
  Q := OpenSQL('Select DISTINCT GL_NATUREPIECEG, GL_SOUCHE FROM LIGNE', True);
  while not Q.EOF do
  begin
    ListeNat.Add(Q.Fields[0].AsString);
    ListeSouche.Add(Q.Fields[1].AsString);
    Q.Next;
  end;
  Ferme(Q);
  // Balayage des pièces avec découpe
  for i := 0 to ListeNat.Count - 1 do
  begin
    // Récupération du plus grand numéros possible
    QMax := OpenSQL('SELECT MIN(GL_NUMERO), MAX(GL_NUMERO),COUNT(*) FROM LIGNE WHERE GL_NATUREPIECEG="' + ListeNat[i] + '" AND GL_SOUCHE="' + ListeSouche[i] +
                    '"', True);
    //PremierNumero := QMax.Fields[0].AsInteger;
    DernierNumero := QMax.Fields[1].AsInteger;
    NCount := QMax.Fields[2].AsInteger;
    Ferme(QMax);

    if NCount > 50000 then
    begin
      // Première tranche traitée : 0 à 1000000
      NbDebutTranche := 0;
      NbFinTranche := 1000000;

      while (NbDebutTranche < DernierNumero) do
      begin
        // Récupère le premier et le dernier numéro à traiter dans la tranche
        QMax := OpenSQL('SELECT MIN(GL_NUMERO), MAX(GL_NUMERO),COUNT(*) FROM LIGNE WHERE GL_NATUREPIECEG="' + ListeNat[i] + '" AND GL_SOUCHE="' +
          ListeSouche[i] + '" AND GL_NUMERO>=' + IntToStr(NbDebutTranche) + ' AND GL_NUMERO<' + IntToStr(NbFinTranche) + '', True);
        NMin := QMax.Fields[0].AsInteger;
        NMax := QMax.Fields[1].AsInteger;
        NCount := QMax.Fields[2].AsInteger;
        Ferme(QMax);

        if NCount > 0 then
        begin
          NbStep := (NMax - NMin) div 25000;
          for k := 0 to NbStep do
          begin
            NN1 := NMin + k * 25000;
            if k < NbStep then NN2 := NN1 + 25000 else NN2 := NMax;
            BeginTrans;
            ExecuteSQL('UPDATE LIGNE SET ' + SetSQL + ' WHERE GL_NATUREPIECEG="' + ListeNat[i] + '" AND GL_SOUCHE="' + ListeSouche[i] + '" AND GL_NUMERO>=' +
                        IntToStr(NN1) + ' AND GL_NUMERO<=' + IntToStr(NN2) + ' ' + SetCondition );
            CommitTrans;
          end;
        end;
        // Tranche suivante
        NbDebutTranche := NbDebutTranche + 1000000;
        NbFinTranche := NbFinTranche + 1000000;
      end;
      // sinon trou ds la numéraotation, update pour la souche
    end else ExecuteSQL('UPDATE LIGNE SET ' + SetSQL + ' WHERE GL_NATUREPIECEG="' + ListeNat[i] + '" AND GL_SOUCHE="' + ListeSouche[i] + '"' + ' ' + SetCondition);
  end;
  ListeNat.Clear;
  ListeNat.Free;
  ListeSouche.Clear;
  ListeSouche.Free;
end;


procedure TMajStructBTP.UpDateDecoupeLigneCompl(SetSQL: string; SetCondition : string ='');
var NMin, NMax, NCount, NN1, NN2, NbStep: integer;
  ListeNat, ListeSouche: TStrings;
  Q: TQuery;
  QMax: TQuery;
  i, k: integer;
  NbDebutTranche: integer;
  NbFinTranche: integer;
  //PremierNumero: integer;
  DernierNumero: integer;
  //SQL : string ;
begin
  // Lecture des natures
  ListeNat := TStringList.Create;
  ListeSouche := TStringList.Create;
  Q := OpenSQL('Select DISTINCT GLC_NATUREPIECEG, GLC_SOUCHE FROM LIGNECOMPL', True);
  while not Q.EOF do
  begin
    ListeNat.Add(Q.Fields[0].AsString);
    ListeSouche.Add(Q.Fields[1].AsString);
    Q.Next;
  end;
  Ferme(Q);
  // Balayage des pièces avec découpe
  for i := 0 to ListeNat.Count - 1 do
  begin
    // Récupération du plus grand numéros possible
    QMax := OpenSQL('SELECT MIN(GLC_NUMERO), MAX(GLC_NUMERO),COUNT(*) FROM LIGNECOMPL WHERE GLC_NATUREPIECEG="' + ListeNat[i] + '" AND GLC_SOUCHE="' + ListeSouche[i] +
                    '"', True);
    //PremierNumero := QMax.Fields[0].AsInteger;
    DernierNumero := QMax.Fields[1].AsInteger;
    NCount := QMax.Fields[2].AsInteger;
    Ferme(QMax);

    if NCount > 50000 then
    begin
      // Première tranche traitée : 0 à 1000000
      NbDebutTranche := 0;
      NbFinTranche := 1000000;

      while (NbDebutTranche < DernierNumero) do
      begin
        // Récupère le premier et le dernier numéro à traiter dans la tranche
        QMax := OpenSQL('SELECT MIN(GLC_NUMERO), MAX(GLC_NUMERO),COUNT(*) FROM LIGNECOMPL WHERE GLC_NATUREPIECEG="' + ListeNat[i] + '" AND GLC_SOUCHE="' +
          ListeSouche[i] + '" AND GLC_NUMERO>=' + IntToStr(NbDebutTranche) + ' AND GLC_NUMERO<' + IntToStr(NbFinTranche) + '', True);
        NMin := QMax.Fields[0].AsInteger;
        NMax := QMax.Fields[1].AsInteger;
        NCount := QMax.Fields[2].AsInteger;
        Ferme(QMax);

        if NCount > 0 then
        begin
          NbStep := (NMax - NMin) div 25000;
          for k := 0 to NbStep do
          begin
            NN1 := NMin + k * 25000;
            if k < NbStep then NN2 := NN1 + 25000 else NN2 := NMax;
            BeginTrans;
            ExecuteSQL('UPDATE LIGNECOMPL SET ' + SetSQL + ' WHERE GLC_NATUREPIECEG="' + ListeNat[i] + '" AND GLC_SOUCHE="' + ListeSouche[i] + '" AND GLC_NUMERO>=' +
                        IntToStr(NN1) + ' AND GLC_NUMERO<=' + IntToStr(NN2) + ' ' + SetCondition );
            CommitTrans;
          end;
        end;
        // Tranche suivante
        NbDebutTranche := NbDebutTranche + 1000000;
        NbFinTranche := NbFinTranche + 1000000;
      end;
      // sinon trou ds la numéraotation, update pour la souche
    end else ExecuteSQL('UPDATE LIGNECOMPL SET ' + SetSQL + ' WHERE GLC_NATUREPIECEG="' + ListeNat[i] + '" AND GLC_SOUCHE="' + ListeSouche[i] + '"' + ' ' + SetCondition);
  end;
  ListeNat.Clear;
  ListeNat.Free;
  ListeSouche.Clear;
  ListeSouche.Free;
end;


procedure TMajStructBTP.UpDateDecoupeLigneOUV(SetSQL: string; SetCondition : string ='');
var NMin, NMax, NCount, NN1, NN2, NbStep: integer;
  ListeNat, ListeSouche: TStrings;
  Q: TQuery;
  QMax: TQuery;
  i, k: integer;
  NbDebutTranche: integer;
  NbFinTranche: integer;
  //PremierNumero: integer;
  DernierNumero: integer;
  //SQL : string ;
begin
  // Lecture des natures
  ListeNat := TStringList.Create;
  ListeSouche := TStringList.Create;
  Q := OpenSQL('Select DISTINCT BLO_NATUREPIECEG, BLO_SOUCHE FROM LIGNEOUV', True);
  while not Q.EOF do
  begin
    ListeNat.Add(Q.Fields[0].AsString);
    ListeSouche.Add(Q.Fields[1].AsString);
    Q.Next;
  end;
  Ferme(Q);
  // Balayage des pièces avec découpe
  for i := 0 to ListeNat.Count - 1 do
  begin
    // Récupération du plus grand numéros possible
    QMax := OpenSQL('SELECT MIN(BLO_NUMERO), MAX(BLO_NUMERO),COUNT(*) FROM LIGNEOUV WHERE BLO_NATUREPIECEG="' + ListeNat[i] + '" AND BLO_SOUCHE="' + ListeSouche[i] +
                    '"', True);
    //PremierNumero := QMax.Fields[0].AsInteger;
    DernierNumero := QMax.Fields[1].AsInteger;
    NCount := QMax.Fields[2].AsInteger;
    Ferme(QMax);

    if NCount > 50000 then
    begin
      // Première tranche traitée : 0 à 1000000
      NbDebutTranche := 0;
      NbFinTranche := 1000000;

      while (NbDebutTranche < DernierNumero) do
      begin
        // Récupère le premier et le dernier numéro à traiter dans la tranche
        QMax := OpenSQL('SELECT MIN(BLO_NUMERO), MAX(BLO_NUMERO),COUNT(*) FROM LIGNEOUV WHERE BLO_NATUREPIECEG="' + ListeNat[i] + '" AND BLO_SOUCHE="' +
          ListeSouche[i] + '" AND BLO_NUMERO>=' + IntToStr(NbDebutTranche) + ' AND BLO_NUMERO<' + IntToStr(NbFinTranche) + '', True);
        NMin := QMax.Fields[0].AsInteger;
        NMax := QMax.Fields[1].AsInteger;
        NCount := QMax.Fields[2].AsInteger;
        Ferme(QMax);

        if NCount > 0 then
        begin
          NbStep := (NMax - NMin) div 25000;
          for k := 0 to NbStep do
          begin
            NN1 := NMin + k * 25000;
            if k < NbStep then NN2 := NN1 + 25000 else NN2 := NMax;
            BeginTrans;
            ExecuteSQL('UPDATE LIGNEOUV SET ' + SetSQL + ' WHERE BLO_NATUREPIECEG="' + ListeNat[i] + '" AND BLO_SOUCHE="' + ListeSouche[i] + '" AND BLO_NUMERO>=' +
                        IntToStr(NN1) + ' AND BLO_NUMERO<=' + IntToStr(NN2) + ' ' + SetCondition );
            CommitTrans;
          end;
        end;
        // Tranche suivante
        NbDebutTranche := NbDebutTranche + 1000000;
        NbFinTranche := NbFinTranche + 1000000;
      end;
      // sinon trou ds la numéraotation, update pour la souche
    end else ExecuteSQL('UPDATE LIGNEOUV SET ' + SetSQL + ' WHERE BLO_NATUREPIECEG="' + ListeNat[i] + '" AND BLO_SOUCHE="' + ListeSouche[i] + '"' + ' ' + SetCondition);
  end;
  ListeNat.Clear;
  ListeNat.Free;
  ListeSouche.Clear;
  ListeSouche.Free;
end;

procedure TMajStructBTP.UpDateDecoupePiece(SetSQL: string; SetCondition : string ='');
var NMin, NMax, NCount, NN1, NN2, NbStep: integer;
  ListeNat, ListeSouche: TStrings;
  Q: TQuery;
  QMax: TQuery;
  i, k: integer;
  NbDebutTranche: integer;
  NbFinTranche: integer;
  //PremierNumero: integer;
  DernierNumero: integer;
begin
  // Lecture des natures
  ListeNat := TStringList.Create;
  ListeSouche := TStringList.Create;
  Q := OpenSQL('Select DISTINCT GP_NATUREPIECEG, GP_SOUCHE FROM PIECE', True);
  while not Q.EOF do
  begin
    ListeNat.Add(Q.Fields[0].AsString);
    ListeSouche.Add(Q.Fields[1].AsString);
    Q.Next;
  end;
  Ferme(Q);

  // Balayage des pièces avec découpe
  for i := 0 to ListeNat.Count - 1 do
  begin
    // Récupération du plus grand numéros possible
    QMax := OpenSQL('SELECT MIN(GP_NUMERO), MAX(GP_NUMERO),COUNT(*) FROM PIECE WHERE GP_NATUREPIECEG="' + ListeNat[i] + '" AND GP_SOUCHE="' + ListeSouche[i] +
      '"', True);
    //PremierNumero := QMax.Fields[0].AsInteger;
    DernierNumero := QMax.Fields[1].AsInteger;
    NCount := QMax.Fields[2].AsInteger;
    Ferme(QMax);

    // si plus de 50000, update par tranche
    if NCount > 50000 then
    begin
      // Première tranche traitée : 0 à 1000000
      NbDebutTranche := 0;
      NbFinTranche := 1000000;

      while (NbDebutTranche < DernierNumero) do
      begin
        // Récupère le premier et le dernier numéro à traiter dans la tranche
        QMax := OpenSQL('SELECT MIN(GP_NUMERO), MAX(GP_NUMERO),COUNT(*) FROM PIECE WHERE GP_NATUREPIECEG="' + ListeNat[i] + '" AND GP_SOUCHE="' +
          ListeSouche[i] + '" AND GP_NUMERO>=' + IntToStr(NbDebutTranche) + ' AND GP_NUMERO<' + IntToStr(NbFinTranche) + '', True);
        NMin := QMax.Fields[0].AsInteger;
        NMax := QMax.Fields[1].AsInteger;
        NCount := QMax.Fields[2].AsInteger;
        Ferme(QMax);

        if NCount > 0 then
        begin
          NbStep := (NMax - NMin) div 25000;
          for k := 0 to NbStep do
          begin
            NN1 := NMin + k * 25000;
            if k < NbStep then NN2 := NN1 + 25000 else NN2 := NMax;
            BeginTrans;
            ExecuteSQL('UPDATE PIECE SET ' + SetSQL + ' WHERE GP_NATUREPIECEG="' + ListeNat[i] + '" AND GP_SOUCHE="' + ListeSouche[i] + '" AND GP_NUMERO>=' +
              IntToStr(NN1) + ' AND GP_NUMERO<=' + IntToStr(NN2)+ ' ' + SetCondition );
            CommitTrans;
          end;
        end;
        // Tranche suivante
        NbDebutTranche := NbDebutTranche + 1000000;
        NbFinTranche := NbFinTranche + 1000000;
      end;
    end
      // sinon trou ds la numérotation, update pour la souche
    else
    begin
      ExecuteSQL('UPDATE PIECE SET ' + SetSQL
        + ' WHERE GP_NATUREPIECEG="' + ListeNat[i] + '" AND GP_SOUCHE="' + ListeSouche[i] + '"'+ ' ' + SetCondition );
    end;
  end;
  ListeNat.Clear;
  ListeNat.Free;
  ListeSouche.Clear;
  ListeSouche.Free;
end;


procedure TMajStructBTP.TraiteModifVue(TheListRef: TOB);
var TOBREF,TOBDest : TOB;
begin
  TOBREF := GetVueRef(TheListRef.getValue('BTV_NOMELT'));
  TOBDest := GetVueDestination(TheListRef.getValue('BTV_NOMELT'));
  if not IsTraiteVue (TOBRef,TOBDest) then
  begin
    TOBREf.free;
    if TOBdest <> nil then TOBDest.free;
    exit; // --> pas a traiter
  end;

  TOBREF.SetAllModifie(True);
  TOBREF.InsertOrUpdateDB;
  LanceMajVues := True;
  TOBREf.free;
  TOBDest.free;
end;

function TMajStructBTP.GetVueRef (NomVue : string) : TOB;
var QQ : TQuery;
    TOBResult : TOB;
begin
  result := nil;
  QQ := OpenSQLDb (DBRef,'SELECT * FROM DEVUES WHERE DV_NOMVUE="'+NomVue+'"',true);
  if QQ.eof then BEGIN fCodeStatus := 120; Exit; END;
  TOBresult := TOB.Create ('DEVUES',nil,-1);
  TOBresult.SelectDB ('',QQ);
  ferme (QQ);
  result := TOBresult;
end;

function TMajStructBTP.GetVueDestination(NomVue: string): TOB;
var QQ : TQuery;
    TOBResult : TOB;
begin
  result := nil;
  QQ := OpenSQL ('SELECT * FROM DEVUES WHERE DV_NOMVUE="'+NomVue+'"',true);
  if QQ.eof then BEGIN Exit; END;
  TOBresult := TOB.Create ('DEVUES',nil,-1);
  TOBresult.SelectDB ('',QQ);
  ferme (QQ);
  result := TOBresult;
end;

function TMajStructBTP.IsTraiteVue (TOBRef,TOBDest : TOB) : boolean;
begin
  result := true;
  if TOBDest = nil then exit; // -> pas de destination c'est donc une création
  if TOBDest.getValue('DV_NUMVERSION') < TOBRef.getValue('DV_NUMVERSION') then exit; // version sur ref > cele de la base
  result := false;
end;

procedure TMajStructBTP.DropVuesPhysiques;
begin
	XX.Titre.Caption := 'Suppression des vues physiques';
  XX.Titre.visible := true;
  XX.Titre.Refresh;
  XX.PB.Visible := true;
  XX.Refresh;
  XX.CURVUE.visible := true;
  DBDeleteAllView (DBSOC,XX.CURVUE,DestDriver);
  XX.CURVUE.visible := false;
end;

procedure TMajStructBTP.CreateVuesPhysiques;
begin
	XX.Titre.Caption := 'Création des vues physiques';
  XX.Titre.visible := true;
  XX.Titre.Refresh;
  XX.PB.Visible := true;
  XX.CURVUE.visible := true;
  XX.Refresh;
  DBCreateAllView (DBSOC,XX.CURVUE,DestDriver);
  XX.CURVUE.visible := false;
end;

procedure TMajStructBTP.TraiteChangementMenu(TheListRef: TOB);
var NumeroMenu : string;
    TheMenusRef,TheMenusDest : TOB;
    TheMenuRef,TheMenuDest : TOB;
    indice : integer;
begin
  TheMenusref := TOB.create ('LES MENUS SOC',nil,-1);
  TheMenusDest := TOB.create ('LES MENUS SOCD',nil,-1);

  NumeroMenu := TheLIstRef.GetValue ('BTV_NOMELT');
	XX.Titre.Caption := 'Mise à jour des Menus';
  XX.Titre.visible := true;
  XX.Titre.Refresh;
  XX.PB.Visible := true;
  XX.Refresh;
  GetMenus (NumeroMenu,TheMenusRef,TheMenusDest);
  // phase de préparation
  for indice := 0 to TheMenusref.detail.count -1 do
  begin
    TheMenuRef :=TheMenusref.detail[Indice];
    TheMenuDest := TheMenusDest.findFirst(['MN_1','MN_2','MN_3','MN_4'],
    																			[TheMenuRef.GetValue('MN_1'),
                                           TheMenuRef.GetValue('MN_2'),
                                           TheMenuRef.GetValue('MN_3'),
                                           TheMenuRef.GetValue('MN_4')],true);
    if TheMenuDest <> nil then
    begin
    	if TheListRef.GetValue ('BTV_WITHDATA') <> 'X' Then
      begin
        // on récupère la confidentialité du dossier client
        TheMenuRef.putValue('MN_ACCESGRP',TheMenuDest.GetValue('MN_ACCESGRP'));
      end;
    end;
  end;
  //
  // Phase de nettoyage
  //
  DropMenuDest(NumeroMenu);
  TheMenusDest.clearDetail;
  for indice := 0 to TheMenusref.detail.count -1 do
  begin
    TheMenuRef :=TheMenusref.detail[Indice];
    TheMenuDest := TOB.Create ('MENU',TheMenusDest,-1);
    TheMenuDest.Dupliquer(TheMenuref,false,true);
  end;
  //
  // Phase d'insertion des données
  //
  TheMenusDest.SetAllModifie(true);
  TheMenusDest.InsertDB(nil);
  TheMenusref.free;
  TheMenusDest.free;
  //
end;

end.
