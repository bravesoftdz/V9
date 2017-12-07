unit MDispAdm;

// majstruc umajstruct

interface

// ubob

uses Forms, dialogs
{$IFDEF VER150}
  , Classes
{$ENDIF}
	,BTMajStruct
  ,uBTPVerrouilleDossier
  ,RegenEcheCon
  ,UApplication
  ;

procedure InitApplication;

type
  Tgctie = class(TDatamodule)
    procedure FMDispADMCreate(Sender: TObject);
  end;

var
  gctie: Tgctie;

implementation

{$R *.DFM}

uses windows, HEnt1, MenuOLG, sysutils, Messages, HMsgBox, {$IFNDEF VER150}Classes, {$ENDIF}Controls, Hctrls,
  HPanel, UIUtil, ImgList, Tablette, FE_Main, EdtEtat, AglInitPlus, AGLInit,
  MajHalley, CreerSoc, CopySoc, Reseau, Mullog, LicUtil, UtomUtilisat, UserGrp_tom,
  UtilPGI, AssistInitSoc, PGIExec, Reindex, Paramsoc, Ent1,
  UtilSoc, Exercice, Souche_tom, FichComm, Pays, Region, CodePost, Devise_TOM,  Tva, MulJal,
  MulGene, MulTiers, MulSecti, CpAxe_Tom, CPStructure_tof,  VentType, CodeAFB,
  EtbMce, OuvreExo, {CalcEuro,} EuroPGI, SuprGene, SuprJal, QRJDivis, EntPGI,
  UtofExportConfidentialite, Confidentialite_tof, MajSocParLot_TOF, LGCOMPTE_TOF, CORRESP_TOM, {STKMoulinette,}
  MajHalleyUtil, ubob, YYBUNDLE_TOF, uMultiDossier, TomProfilUser,BackupRestore_TOF,traduc,AccesPortail_TOF, MajEnRafale
  ,UtomEtabliss,ChangeVersions,BobGestion,URegenVues
  ,UFicheImportExport
{$IFDEF INTERNAT}
  , TOMIdentificationBAncaire
{$ENDIF}
  ;

function VerifSuperviseur: boolean;
begin
  Result := True;
  if not V_PGI.Superviseur then
  begin
    PGIBox('Vous n''avez pas les droits pour acc�der � cette application', 'Attention');
    Result := False;
    FMenuG.ForceClose := True;
    FMenuG.Close;
  end;
end;

function VireMoiCa: string;
begin
  Result := 'SCO_CONSOLIDATION;SCO_SYNAPTIQUE;SCO_MCC;SCO_FISCAPERSO;SCO_TDI;SCO_XISOFLEX;SCO_HRCHR;SCO_KTTRANSPORT;SCO_GPAO';

  //Gis�le MERIEUX Le 29/05/2008 Version 8.1.850.86 Demande N� 2587
  Result := Result + ';SCO_AFFAIRE';
end;

procedure InitCodeProduit;
var
  ii, i: integer;
  stl: HTStringList;
  st, stCombos: string;
begin
  stCombos := 'YYLISTEPRODUITS';
  ii := TTToNum(stCombos);
  st := '';
  if ii > 0 then
  begin
    if (V_PGI.DECombos[ii].Valeurs = nil) then RemplirListe(stCombos, '');
    stl := V_PGI.DeCombos[ii].valeurs;
    if stl = nil then Exit;
    for i := 0 to stl.count - 1 do
    begin
      if V_PGI.CodeProduit <> '' then st := ';';
      V_PGI.CodeProduit := V_PGI.Codeproduit + st + ExtractInfo(stl[i], 1);
    end;
  end;
end;

{$IFDEF MAJBOB}
{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 08/06/2005
Modifi� le ... :   /  /
Description .. : fonction qui indique si PgiMajVer est en version MAJBOB
Mots clefs ... :
*****************************************************************}
function AglOkMajBob(var BobName: string): boolean;
var
  i: integer;
  s: string;
begin
  // Par d�faut
  BobName := '';

  // contr�le des param�tres
  for i := 0 to ParamCount do
  begin
    s := UpperCase(ParamStr(i));
    if Copy(s, 1, 5) = '/BOB=' then
    begin
      BobName := s;
      ReadTokenPipe(BobName, '=');
      BobName := Trim(BobName);
      Break;
    end;
  end;

  // Le nom du fichier doit �tre rempli, sinon => rien
  Result := BobName <> '';
end;
{$ENDIF}

{$IFDEF MAJPCL}

// c:\pgi00\app\PGIMAJVER.EXE /USER=CEGID /PASSWORD=46171FC5C3 /DATE=14/09/2005
//    /DOSSIER=DBBLM001@LOCAL_DB0 /MODEPCL=1 /MAJSTRUCTURE=TRUE /MAJSTRUCTAUTO=TRUE /DOSSIERPCL=TRUE
function OkDossierPCL : boolean;
var
  i: integer;
  s: string;
  StDossierPCL : string;
begin
  Result:=false;
  for i := 0 to ParamCount do
  begin
    s := UpperCase(ParamStr(i));
    if Copy(s, 1, 11) = '/DOSSIERPCL' then
    begin
      StDossierPCL := s;
      ReadTokenPipe(stDossierPCL, '=');
      Result := ( stDossierPCL='TRUE' );
      Break;
    end;
  end;
end;
{$ENDIF}

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 05/10/2005
Modifi� le ... :   /  /    
Description .. : proc�dure de lancement de t�che � la connexion � 
Suite ........ : l'application.
Suite ........ : - /OPTIM=PCL permet de lancer la migration vers une base 
Suite ........ : all�g�e
Mots clefs ... : 
*****************************************************************}
procedure DispatchAuto;
var
  i : integer;
  St, stNom, stValue : string;
begin
  for i:=1 to ParamCount do
  begin
    St := ParamStr(i) ;
    stNom:=UpperCase(Trim(ReadTokenPipe(St,'='))) ;
    stValue:=UpperCase(Trim(St)) ;

    if stNom = '/OPTIM' then
    begin
      if ((V_PGI.DossierPCL) and (UpperCase( stValue ) = 'PCL')) then
      begin
{$IFDEF MAJPCL}
        OptimiseDossierPCL;
{$ENDIF}
        Application.ProcessMessages;
        FMenuG.ForceClose := True ;
        FMenuG.Close ;
        Exit;
      end;
    end;
  end;
end;

procedure Dispatch(Num: Integer; PRien: THPanel; var retourforce, sortiehalley: boolean);
var
{$IFDEF MAJBOB}
  stBobDeMiseAJour: string;
{$ENDIF}
  CodeRetour : integer;
  stMessage, Versionbase : string;
  Ok1,Ok2 : Boolean;
begin
  case Num of
    10:
      begin
        if (V_PGI.MajStructAuto) and (V_PGI.RunWithParams) then
        begin
          FMenuG.ForceClose := True;
          PostMessage(FMenuG.Handle, WM_CLOSE, 0, 0);
          Application.ProcessMessages;
          Exit;
        end
        else
        begin
{$IFDEF BTP}
          if (not ISUtilisable) then
          begin
             stMessage := 'Base de donn�es momentan�ment indisponible (mise � niveau en cours) ';
             stMessage := stMessage +#13#10 +'Veuillez r�essayer ult�rieurement';
             PGIInfo(stMessage,'Information de connection');
             FMenuG.ForceClose := True;
             PostMessage(FMenuG.Handle, WM_CLOSE, 0, 0);
             Application.ProcessMessages;
             Exit;
          end;
          VersionBase := RecupVersionbase;
          Coderetour := MajStructure;
          if CodeRetour < 0 then
          begin
      			RetourForce:=True;
            Fmenug.Quitter;
            Exit;
          end;
          //
          TraiteChangementVersions (VersionBase);
          TraitementsBeforeImportBOB (VersionBase);
					// TraiteChangementGamme;
          // PGI_IMPORT_BOB('BAT2008'); ancienne gestion
          Ok1 := (BOB_IMPORT_PCL_STD('BAT2009','Business',False)=1);
          Ok2 := (BOB_IMPORT_PCL_STD('MAJERPCEGIDV9','CEGID',False)=1);
          if (Ok1) or (Ok2) then
          begin
          	TraitementsAfterImportBOB (VersionBase);
						PGIInfo('Mise � jour termin�e.#13#10 Une sortie du produit est nec�ssaire.');
            FMenuG.Quitter;
						Abort;
          end;
          
{$ENDIF}
          DispatchAuto;   // Ajout CA - 05/10/2005
          VerifSuperviseur;
          InitCodeProduit;
        end;
        MiseAJourEnRafale;
      end;

    11: ; //Apr�s deconnection
    12:   // permet de faire qques chose avant connexion et seria
      begin
{$IFDEF MAJBOB}
        stBobDeMiseAJour := '';
        AglOkMajBob(stBobDeMiseAJour);
        V_PGI.BobDeMiseAJour := stBobDeMiseAJour;
{$ENDIF MAJBOB}
        if (V_PGI.ModePCL = '1') then V_PGI.PGIContexte := V_PGI.PGIContexte + [ctxPCL];
{$IFDEF MAJPCL}
        V_PGI.DossierPCL:=OkDossierPCL;
        // CA - 01/09/2005
        if V_PGI.DossierPCL then InitPGIpourDossierPCL;
        // Fin CA
{$ENDIF}


      end;
    13: ;
    15: ;
    16: BEGIN
    		END;
    100: ; // executer depuis le lanceur
    {Soci�t�s et dossiers}
    3130: GestionSociete(PRien, @InitSocietePGI, nil);
    3145: RecopieSoc(PRien, True);
    3220: ReindexSoc;
    4010: AGLLanceFiche('YY', 'YYIMPORTOBJET', '', '', ''); // Import d'objets
    4020: AGLLanceFiche('YY', 'YYMYINDEXES', '', '', ''); // IIndexes suppl�mentaires
    4030: AGLLanceFiche('YY', 'YYJNALEVENT', '', '', ''); // Journal evenements
    4003: YYLanceFiche_MajSocParLot('YY', 'MAJSOCPARLOT', '', '', '');
    4004: AGLLanceFiche('YY', 'YYIMPORTOBJETLOT', '', '', '');
    // majver
    4001: YYLanceFiche_ExportConfidentialite('YY', 'YYEXPORTCONFID', '', '', '');
    4002: YYLanceFiche_ImportConfidentialite('YY', 'YYIMPORTCONFID', '', '', '');

    4005:
      begin
        v_pgi.enableDEShare := false;
        {$IFDEF MAJPCL}
        if PGIAsk('Confirmez-vous le passage en base all�g�e ?') = mrYes then OptimiseDossierPCL; // traitement socref PCL
        {$ENDIF MAJPCL}
        v_pgi.enableDEShare := True;
      end;

{      begin
        v_pgi.enableDEShare := false;
        if PGIAsk('Confirmez-vous la pr�paration de la base PCL ?') = mrYes then PrepareBasePCL; // traitement socref PCL
        v_pgi.enableDEShare := True;
      end;
}
    4042: YYLanceFiche_Bundle('YY', 'YYBUNDLE', '', '', '');
    4041: ParamRegroupementMultidossier;
    4043: AGLLanceFiche('YY', 'YYAJOUTSOCRG', '', '', '');
    4044: LanceImportExport;
    4045: AglLanceFiche('BTP', 'BTSHAREY2', '', '', '');

    4006: AGLLanceFiche ('YY','YYDEFPRT','','',''); //Lancement des Imprimantes par d�faut.

    //Ajout des entr�es du Planning Unifi�
    4203: AGLLanceFiche( 'YY','YYYRESSOURCE_MUL','','','');
    4204: AGLLanceFiche( 'YY','YYYPLANNING_MUL','','','');
    4206: BEGIN RegenereEcheContrats;  RetourForce := true;  END;

    {Utilisateurs et acc�s}
    3165: FicheUserGrp;
    3170:
      begin
        FicheUSer(V_PGI.User);
        ControleUsers;
      end;
    // 3172: AGLLanceFiche('YY', 'PROFILETABL', '', '', 'ETA');
    60211 : AGLLanceFiche('YY','PROFILETABL','','','ETA;GRP') ; // JTR - Fonction en CWAS
    3172  : AGLLanceFiche('YY','PROFILETABL','','','ETA;UTI') ; // JTR - Fonction en CWAS
    3180: ReseauUtilisateurs(False);
    3185: VisuLog;
    3195: ReseauUtilisateurs(True);
    4201: GCLanceFiche_Confidentialite('YY', 'YYCONFIDENTIALITE', '', '', '');
    4202: YYLanceFiche_AccesPortail('YY', 'YYACCESPORTAIL', '', '', ''); //js1  120406 gestion des droits d'acces aux vignettes du portail
    {Param�tres g�n�raux}
    1104: ParamSociete(False, VireMoiCa, '', '', ChargeSocieteHalley, ChargePageSoc, SauvePageSoc, InterfaceSoc, 1105000);
    1290: FicheExercice('', taModif, 0);
    1300: FicheSouche('CPT');
    1110: FicheEtablissement_AGL(taModif);
    65410: ParamTable('YYDOMAINE', taCreat, 0, PRien);
    1120: ParamTable('ttFormeJuridique', taCreat, 1120000, PRien);
    1122: ParamTable('ttCivilite', taCreat, 1122000, PRien);
    1125: ParamTable('ttFonction', taCreat, 1125000, PRien);
    1135: AglLanceFiche('YY', 'YYPAYS', '', '', ''); // OuvrePays ;
    1140: FicheRegion('', '', False);
    1145: OuvrePostal(PRien);
    1150: FicheDevise('', tamodif, False);
    1165: ParamTable('TTREGIMETVA', taCreat, 1165000, PRien);
    1170: ParamTvaTpf(true);
    1175: ParamTvaTpf(false);
    1185: FicheModePaie_AGL('');
    1190: FicheRegle_AGL('', FALSE, taModif);
    1191: ParamTable('ttQualUnitMesure', taCreat, 1190030, PRien);
    1193: ParamTable('ttNivCredit', taCreat, 1190040, PRien);
    {Structures}
    // Zapp� en 2008 -- Idem ENTREPRISE
//    7211: MulticritereJournal(taModif);
//    7112: MulticritereCpteGene(taModif);
//    7145: MultiCritereTiers(taModif);
    // Comptes de correspondance
//    1325: CCLanceFiche_Correspondance('GE'); // Plan de correspondance G�n�raux
//    1330: CCLanceFiche_Correspondance('AU'); // Plan de correspondance Auxiliaire
//    7118: SuppressionCpteGene; //Suppression des comptes g�n�raux (unit� SuprGene)
//    7214: SuppressionJournaux; //Suppression des journaux (unit� SuprJal)
//    7394: JalDivisioPCL; //�dition des journaux divisionnaires (unit� QRJDivis)
//    3205: CCLanceFiche_LongueurCompte; // modif longueur des comptes
    {Analytique}
//    1105: ;// FicheAxeAna('');
//    7178: MulticritereSection(taModif);
    1450: ParamPlanAnal('');
    1460: ParamVentilType;
    { INTERNAT}
{$IFDEF INTERNAT}
    1701 : LanceFicheIdentificationBancaire();
{$ENDIF}
    {Banque}
    1705: FicheBanque_AGL('', taModif, 0);
    1720: ParamTable('ttCFONB', taCreat, 0, PRien);
    1725: ParamCodeAFB;
    1730: ParamTable('ttCodeResident', taCreat, 0, PRien);
    1732: ParamTeletrans;
    {Traitements}
    { GC_DBR_PGIMAJVER10039 }
    7718: begin
            if PgiAsk ('ATTENTION�!Si vous disposez de Cegid business comptabilit�, les traitements de cl�ture et d''ouverture d''exercices doivent se faire en comptabilit�. Confirmez le traitement ?') = mrYes then
              if PrepareOuvreExoSansCompta then OuvertureExo;
          end;
    3131 : YYLanceFiche_BackupSociete('YY', 'BACKUPRESTORE', '', '', 'BACKUP') ; // sauvegarde
    3132 : YYLanceFiche_BackupSociete('YY', 'BACKUPRESTORE', '', '', 'RESTORE') ; // restauration
    3301 : begin
            V_PGI.ZoomOLE := true;  //Affichage en mode modal
            AGLLanceFiche('BTP','BTDEFLICENCES','','','');
            V_PGI.ZoomOLE := false;  //Affichage en mode modal
            FMenuG.PRien.Refresh;
           end;
    3302 : begin
            V_PGI.ZoomOLE := true;  //Affichage en mode modal
            AGLLanceFiche('BTP','BTINTEGRELICENCES','','','');
            V_PGI.ZoomOLE := false;  //Affichage en mode modal
            FMenuG.PRien.Refresh;
           end;
    65550 : RegenereVues ; // Reg�n�ration des vues
  else HShowMessage('2;?caption?;' + TraduireMemoire('Fonction non disponible : ') + ';W;O;O;O;', TitreHalley, IntToStr(Num));
  end;
end;

procedure DispatchTT(Num: Integer; Action: TActionFiche; Lequel, TT, Range: string);
begin
  case Num of
    1: ;
  end;
end;

procedure AfterChangeModule(NumModule: integer);
var
  VireCompta: Boolean;
begin
  V_PGI.VersionDemo := False;
  VireCompta := True;
  V_PGI.LaSerie := S5;
  if ctxPCL in V_PGI.PGIContexte then
  begin
    // maintenant qu'on peut le lancer en direct
  end else
  begin
    // PCS 13/10/2003 modules compta toujours pr�sents.
    VireCompta := False;
  end;
  //
	FMenuG.RemoveGroup(-7211, True);
  FMenuG.RemoveItem(1105);
  FMenuG.RemoveItem(7178);

  if VireCompta then
  begin
    FMenuG.RemoveGroup(-3200, True);
    FMenuG.RemoveGroup(-1705, True);
    FMenuG.RemoveGroup(-1105, True);
    FMenuG.RemoveGroup(-7211, True);
    FMenuG.RemoveGroup(-1104, True);
    FMenuG.RemoveItem(3172);
    FMenuG.RemoveItem(3185);
    FMenuG.RemoveItem(7718);
  end;
  UpdateSeries;
  //if not FileExists(ExtractFilePath(Application.ExeName) + 'INI_E26BCFEE-5C71-498E-BF4C-B5B3400A2CCE.ini') then
  if not V_PGI.DossierPCL then
    FMenuG.RemoveItem(4005);
  // virer param�trage multi soc si PCL
  if (V_PGI.ModePCL = '1') then
  begin
    FMenuG.RemoveItem(4041);
    FMenuG.RemoveItem(4042);
  end;
  if isOracle then
  begin
    FMenuG.RemoveItem(3131);
    FMenuG.RemoveItem(3132);
  end;
end;


procedure InitApplication;
begin
  FMenuG.OnMajAvant := MAJHalleyAvant;
  FMenuG.OnMajApres := MAJHalleyApres;
  FMenuG.IsMajPossible := MAJHalleyIsPossible;
  FMenuG.OnMajPendant := MajHalleyPendant;
  FMenuG.OnDispatch := Dispatch;
  FMenuG.OnChargeMag := ChargeMagHalley;
  FMenuG.OnChangeModule := AfterChangeModule;
  FMenuG.SetModules([4], [49]);
  FMenuG.bSeria.Visible := False;
  V_PGI.DispatchTT := DispatchTT;
  VH^.OkModCompta := True;
  VH^.OkModBudget := True;
  VH^.OkModImmo := True;
  VH^.OkModEtebac := True;
end;

procedure Tgctie.FMDispADMCreate(Sender: TObject);
begin
  PGIAppAlone := True;
  CreatePGIApp;
end;

procedure InitialisationVPGI;
begin

  Apalatys := 'LSE';
  NomHalley := 'MAJVERBTP';

  V_PGI.NumVersionBase := 998 ;
  TitreHalley := 'Administration soci�t�s BTP    Base ' + IntToStr(V_PGI.NumVersionBase);
  HalSocIni := 'CEGIDPGI.ini';

  Copyright := '� Copyright ' + Apalatys;
  V_PGI.NumVersion := '9.1' ;
  V_PGI.NumBuild := IntToStr(V_PGI.NumVersionBase) + '.146';
  V_PGI.DateVersion := EncodeDate(2017, 11, 14) ;

  V_PGI.LaSerie := S5;

  V_PGI.OutLook := TRUE;
  V_PGI.OfficeMsg := TRUE;
  V_PGI.ToolsBarRight := TRUE;
  ChargeXuelib;

  // pour forcer mode SAV en Qualit�
  if FileExists(ExtractFilePath(Application.ExeName) + 'INI_4B8D120B-1877-4E78-A817-331A23A35209.ini') then V_PGI.SAV := True;

  {$IFDEF XAVIER}
  V_PGI.SAV := True ;
  V_PGI.Debug := True ;
  V_PGI.DebugSQL := True ;
  {$ENDIF}

  V_PGI.AlterTable := True;
  V_PGI.VersionDemo := TRUE;
  V_PGI.VersionReseau := true;
  V_PGI.ImpMatrix := True;
  V_PGI.OKOuvert := FALSE;
  V_PGI.Halley := TRUE;
  V_PGI.MenuCourant := 0;
  //V_PGI.Decla100:=TRUE;

  V_PGI.RazForme := TRUE;



  V_PGI.StandardSurDP := True;
  V_PGI.MajPredefini := True;
  V_PGI.CegidApalatys := False;
  V_PGI.CegidBureau := True;
  V_PGI.IsPgiMajVer := True;
  // V_PGI.MajStructAuto := true ;

  v_pgi.enableTableToView:=False;
  V_PGI.RazForme:=TRUE;
	GetInfoMajApplication;

end;

initialization
  ProcChargeV_PGI := InitialisationVPGI;

end.

