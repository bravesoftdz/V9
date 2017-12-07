unit eMDispMP ;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    UIUtil,
    ImgList,
    ComCtrls,				// Pour le removeitem
    IniFiles,
    Prefs,
    Buttons,
    About,
    M3FP,
    // composants Halley
    HPanel,
    Hctrls,
    // AGL
    ParamSoc,
    HEnt1,
    HMsgBox,
    Maineagl,
    MenuOLX,
    UtileAGL,               // LanceEtat
    eTablette,
    AGLInit,
    UTOB,                   // TQuery
    Hout,
    PgiEnv,
    CHOIX,                  // Choisir
    GrpFavoris,
    // entit�s, Outils
    Ent1,                   // GetVH
    CPTEUTIL,               // GetDate
    UtilPGI,
    EntPGI,
    GalEnv,
    SaisUtil,               // TSuiviMP
    // Traitements
    FichComm,               // 1110,1185
    // Etats
//    CPGRANDLIVRETL_TOF,
//    CPBALANCETL_TOF, 		// Etats sur TL
//    TofBalagee,				// Etats suivi des tiers
//    CPJALCENTRAL_TOF,		// Journal centralisateur
//    CPBALGEN_TOF,
//    CPBALAUXI_TOF, 			// Balance g�n� et Auxi
//    uTofCPGLGENE,
//    uTOFCPGLAUXI,
    // Saisie
    eSaisie,
    UTOFCPMULMVT,
    // Consultation des comptes
//    uTofConsEcrPGE,         // Consultation des comptes
    // Param�tres
    CPNATCPTE_TOF,          // 1196 Tables libres
    SOUCHE_TOM,             // 1300, 1301 Compteurs
    EXERCICE_TOM,           // 1290
    CPTABLIBRELIB_TOF,      // 1194
    CPCHOIXTALI_TOF,        // 1196
    SUIVCPTA_TOM,           // 7355
    uTOFCPMulGuide,         // 7352, 7241 (saisie guid�e)
    USERGRP_TOM,            // 3165 Groupe utilisateur
    UTOMUTILISAT,           // 3170 Utilisateur
    PAYS_TOM,               // 1135 Pays
    CPREGION_TOF,           // 1140 R�gions
    CPCODEPOSTAL_TOF,       // 1145 Codes postaux
    // Structures
    UTOFMULPARAMGEN,        // 7112,7145,7178,7211,7118,7151,7184,7214
    CPTiers_Tom,
    CPGeneraux_Tom,
    CPSection_Tom,
    CPJournal_Tom,
    UTofCPSuiviMP,          // pour SelectSuiviMP
    UTofCPGenereMP,         // pour GenereSuiviMP
    CPCFONB_TOF,            // 37545
    CPCFONBMP_TOF,          // 37140,37145,37215,38125,38215,38297
    CPSUIVIACC_TOF,         // 37105
    eSaisEff,               // 37120
    CPLETREGUL_TOF,         // 7520,7521,7523,7524,7525,7526
    uTofConsEcr,            // 25755
    TofEdCpt,               // 39101, 39102
    CPMODIFECHEMP_TOF,      // 37510, 38510, 25760
    UTOFMULRELCPT,          // 7589
    UTOFMULRELFAC,          // 38555
    CPTVATPF_TOF,           // 1170,1173
    MULLETTR,               // 7508,7509
    MULDLETT,               // 7511,7512
    RappAuto,               // 7514,7515 Lettrage automatique
    Confidentialite_TOF     // 60208
    ;

procedure UpdateSeries ;
Procedure AfterProtec ( sAcces : String ) ;
procedure AssignLesZoom ;
procedure AssignZoom ;
procedure RemoveGroupTN(i : Integer ; b : Boolean) ;
Procedure RemoveItemTN(i : Integer) ;
Function LikeS3 : Boolean ;
procedure VireMenuPackAvance (NumModule : integer);
Procedure UpdateModuleCCMP(NumModule : Integer) ;
procedure AfterChangeModule ( NumModule : integer ) ;
procedure InitApplication ;
procedure DispatchTT(Num : Integer; Action : TActionFiche; Lequel,TT,Range : String) ;
Procedure Dispatch ( Num : Integer ; PRien : THPanel ; var retourforce,sortiehalley : boolean);
procedure ChangeMenuDeca ;
Procedure LanceEtatLibreS5 ;
procedure RenseigneSerie ;
Procedure InitLaVariablePGI;

implementation

// PGI Communs

// Uses ;

procedure UpdateSeries ;
Var ii : integer ;
    St : String ;
BEGIN
if ((EstSerie(S3)) or (EstSerie(S5))) then
   BEGIN
   {Axes}
   St:='TTAXE' ; ii:=TTToNum(St) ;
   if ii>0 then
      BEGIN
         if EstSerie(S3) then V_PGI.DECombos[ii].Where:='X_AXE<"A2" AND X_FERME="-"' ;
      END ;
   {Qualifiants pi�ce}
   St:='TTQUALPIECECRIT' ; ii:=TTToNum(St) ;
   if ii>0 then
      BEGIN
      if EstSerie(S5) then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<>"PRE" AND CO_CODE<>"TOU"' else
       if EstSerie(S3) then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<>"PRE" AND CO_CODE<>"NSS" AND CO_CODE<>"SSI"' ;
      END ;
   St:='TTQUALPIECE' ; ii:=TTToNum(St) ;
   if ii>0 then
      BEGIN
      if EstSerie(S5) then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<>"P" AND CO_CODE<>"R"' else
       if EstSerie(S3) then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<>"P" AND CO_CODE<>"R" AND CO_CODE<>"U"' ;
      END ;
  {$IFDEF CCS3}
   {Natures de journaux}
   St:='TTNATJAL' ; ii:=TTToNum(St) ;
   if ii>0 then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<>"ANA"' ;
   {Types de rubrique}
   St:='TTRUBTYPE' ; ii:=TTToNum(St) ;
   if ii>0 then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+
      ' AND CO_CODE<>"A/B" AND CO_CODE<>"A/G" AND CO_CODE<>"B/A" AND CO_CODE<>"BUD" AND CO_CODE<>"G/A" AND CO_CODE<>"G/T" AND CO_CODE<>"T/G"' ;
   {Niveaux de relance}
   St:='TTNIVEAURELANCE' ; ii:=TTToNum(St) ;
   if ii>0 then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND CO_CODE<="003"' ;
   {Journaux}
   St:='TTJOURNAL' ; ii:=TTToNum(St) ;
   if ii>0 then V_PGI.DECombos[ii].Where:=V_PGI.DECombos[ii].Where+' AND J_NATUREJAL<>"ANA"' ;
   St:='TTJOURNAUX' ; ii:=TTToNum(St) ;
   if ii>0 then V_PGI.DECombos[ii].Where:=' AND J_NATUREJAL<>"ANA"' ;
  {$ENDIF}
   END ;
END ;

Procedure AfterProtec ( sAcces : String ) ;
BEGIN

  VH^.OkModCompta:=TRUE ;
  VH^.OkModImmo:=TRUE ;
  VH^.OkModEtebac:=FALSE ;
  VH^.OkModCCMP:=(sAcces[1]='X') ;
  If Not VH^.OldTeleTrans Then VH^.OkModEtebac:=TRUE ;
  V_PGI.NbColModuleButtons:=1;
  V_PGI.NbRowModuleButtons:=6;

  if V_PGI.VersionDemo then
    begin
    if EstSerie(S3)
      then FMenuG.SetModules([37,38,17,18],[16,89,103,107])
      else FMenuG.SetModules([37,38,39,17,18],[16,89,78,103,107]) ;
    end
  else
    begin
    if VH^.OkModCCMP then
      begin
      if EstSerie(S3)
        then FMenuG.SetModules([37,38,17,18],[16,89,103,107])
        else FMenuG.SetModules([37,38,39,17,18],[16,89,78,103,107]) ;
      end
    else FMenuG.SetModules([17,18],[103,107]) ;
    end ;

END ;

procedure AssignLesZoom ;
BEGIN
ProcZoomEdt:=Nil ;
END ;

procedure AssignZoom ;
BEGIN
AssignLesZoom ;
ProcGetVH:=GetVH ;
ProcGetDate:=GetDate ;
END ;

procedure RemoveGroupTN(i : Integer ; b : Boolean) ;
BEGIN
	FMenuG.OutLook.RemoveGroup(i,b) ;
//  TN:=GetTreeItem(FMenuG.TreeView,i) ;
//  If TN<>NIL Then TN.Delete ;
END ;

Procedure RemoveItemTN(i : Integer) ;
Var HOI : THOutItem ;
BEGIN
	HOI:=FMenuG.OutLook.GetItemByTag(i) ;
  If HOI<>NIL Then FMenuG.OutLook.RemoveItem(HOI) ;
//	TN:=GetTreeItem(FMenuG.TreeView,i) ;
//  If TN<>NIL Then TN.Delete ;
END ;

Function LikeS3 : Boolean ;
BEGIN
  Result:=EstSerie(S3) Or EstSerie(S5) Or EstSerie(S7) ;
END ;

procedure VireMenuPackAvance (NumModule : integer);
begin
//   Pas de pack avance en eCCMP pour le moment
//  if EstComptaPackAvance then Exit ;

  // MENU ECRITURE
  if NumModule = 9 then
    begin
    // Ecritures courantes
    RemoveItemTN(7260) ; // Modifications en s�rie sur tables libres
    // Ecritures de pr�vision (groupe complet)
    RemoveGroupTN(7300, True) ;
    // R�visions (groupe complet)
    RemoveGroupTN(76460, True) ;
    end ;

  // STRUCTURE ET PARAMETRE
  if NumModule = 17 then
    begin
    // Modifications en s�rie
    RemoveItemTN( -7116 ) ;
{    RemoveItemTN(7116) ; // Comptes g�n�raux : modifications en s�rie sur tables libres
    RemoveItemTN(7149) ; // Comptes auxiliaires : modifications en s�rie sur tables libres
    RemoveItemTN(7182) ; // Sections analytiques : modifications en s�rie sur tables libres
}
    // Soci�t� - Tables
    RemoveItemTN(1155) ; // Langues
    RemoveItemTN(1193) ; // Niveaux de risque / assurance cr�dit
    // Soci�t� - Tables libres
    RemoveItemTN(1195) ; // Personnalisation des zones libres des mvts
    RemoveItemTN(1197) ; // Recopie des tables libres
    RemoveItemTN(1526) ; // G�n�ration des tables libres � partir des sous-sections
    // Compta analytique
    RemoveItemTN(1455) ; // Cl�s de r�partition
    // Banques
    RemoveItemTN(1732) ; // R�ception Etebac
    end;

  // ADMINISTRATION
  if NumModule = 18 then
    begin
    // Menu instalation
    RemoveGroupTN(3100, True);
{
    // S�ria
    RemoveItemTN(29) ;  // S�rialisation
    // Multi-lingue
    RemoveItemTN(1205) ; // Perso multi-lingue
    RemoveItemTN(1210) ; // Traduction multi-lingue
}    end ;

end ;

Procedure UpdateModuleCCMP(NumModule : Integer) ;
//Var HOI : THOutItem ;
//    TN : TTreeNode ;
BEGIN
  // MODIF PACK AVANCE :
  VireMenuPackAvance(NumModule) ;

  if EstSerie(S3) then
    begin
    RemoveGroupTN(-7456,True) ; // Etats Libres
    end ;

  // Ecritures
{   LE MODULE 9 - Ecritures N'EST PLUS UTILISE
  If NumModule=9 Then
    begin
    RemoveItemTN(7005);        // Saisie bordereau
    RemoveItemTN(7245);        // Saisie d'effets
    RemoveItemTN(7247);        // Saisie de r�glements
    RemoveItemTN(7241);        // Saisie guid�e
    RemoveItemTN(7256);        // Visualisation
    RemoveItemTN(7259);        // Modification
    RemoveItemTN(7264);        // Modif. ent�te de pi�ces
    RemoveItemTN(-82);         // Suppression
    RemoveItemTN(7268);        // Brouillard
    RemoveGroupTN(7271,TRUE);  // Simulations
    RemoveGroupTN(7292,TRUE);  // Situations
    RemoveGroupTN(7325,TRUE);  // Abonnements
    RemoveGroupTN(7361,TRUE);  // Analytiques
    end;
}
  // Structure & param�tres
  if NumModule=17 Then
    begin
    //  FMenuG.OutLook.RemoveGroup(1,FALSE) ;
    If LikeS3 Then
      begin
      RemoveGroupTN(-7352,TRUE) ;
      RemoveItemTN(-7115) ; // Modif en s�rie
      RemoveItemTN(1705) ;  // Etb bancaire
      RemoveItemTN(1720) ;  // Code CFONB
      RemoveItemTN(1725) ;  // Code AFB
      RemoveItemTN(1730) ;  // Code r�sidents �trangers
      RemoveItemTN(1272) ;  // Param�trage mod�les banque
      RemoveItemTN(1271) ;  // Documents / Etats libres / Budgets
      RemoveItemTN(1175) ;  // Param�trage TPF
  (*    If Not EstSerie(S3) Then begin
        If Not EstSpecif('51195') Then RemoveItemTN(1269) ; // Lettres virements
        END
      Else RemoveItemTN(1269) ; // Lettres virements *)
      If Not EstSerie(S3) Then
        begin
        If Not EstSpecif('51192') Then
          RemoveItemTN(1266) ; // Lettres virements
        end
      Else RemoveItemTN(1266) ; // Lettres virements
  //    RemoveItemTN(1266) ; // Lettres^pr�l�vements
      RemoveItemTN(1247) ; // Edition en cours de saisie
      RemoveItemTN(-22) ;
      RemoveItemTN(-23); //Impression
      RemoveItemTN(1248) ;  // Bon � payer
      RemoveItemTN(-1280) ; // Editions param�trables
      RemoveItemTN(1191) ; // Qualifiant Qte
      If Not VH^.OldTeletrans Then
        RemoveGroupTN(1700,TRUE) ; // ETEBAC
      end ;

    // Structures...
    RemoveItemTN(7117) ;        // Modifications natures de comtpes
    RemoveGroupTN(-23, True) ;  // Impressions
    RemoveItemTN(-6) ;   // Ouvertures
    // Soci�t�...
    RemoveItemTN(1104) ;  // Param�tres soci�t�
    RemoveItemTN(1105) ;  // Axe analytiques
    //RemoveItemTN(1170) ;  // Param�trage TVA
    //RemoveItemTN(1175) ;  // Param�trage TPF
    // Param�tres...

        // Param�tres
        //RR 02/06/2003
        RemoveItemTN(1315) ; // Plans de r�f�rence
        RemoveItemTN(-9) ;   // Comptes de correspondance
        RemoveItemTN(-10) ;  // Plans de ruptures des �ditions
        RemoveItemTN(1425) ; // Libell�s automatiques
        RemoveItemTN(-1426); // Comptes de regroupement
        RemoveItemTN(-11) ;  // Analytiques
        RemoveItemTN(-12);   // Etapes de r�glement
        RemoveItemTN(-13);   // Param�tres de relance

    RemoveItemTN(1198) ;       //Synchro Table Libre
    // Ecritures...
    // Banques...
    // Documents...
    RemoveGroupTN(1225, True) ;
    end ;

  // Administrations / Outils
  If NumModule=18 Then
    begin
  //  FMenuG.OutLook.RemoveGroup(1,FALSE) ;

    //BPY 17/01/2003 A VALIDER
    {FMenuG.OutLook.RemoveGroup(0,FALSE) ;
    FMenuG.OutLook.RemoveGroup(1,FALSE) ;
    FMenuG.OutLook.RemoveGroup(1,FALSE) ;
    RemoveItemTN(3125) ; RemoveItemTN(-3200) ; RemoveItemTN(-3240) ;}
    RemoveGroupTN(3125, True) ;
    RemoveGroupTN(-3200, True) ;
    RemoveGroupTN(-3240, True) ;
    If LikeS3 Then
      RemoveGroupTN(3172, True) ;
    // En attente passage eAGL :
    RemoveItemTN(3180) ;
    RemoveItemTN(3185) ;
    RemoveItemTN(3195) ;
    END ;

  // Suivi fournisseurs
  If NumModule=38 Then
    begin
    If LikeS3 Then
      begin
      RemoveGroupTN(-38305,TRUE) ; // Pav� lots
  (*    If Not EstSerie(S3) Then begin
          If Not EstSpecif('51195') Then RemoveGroupTN(-38210,TRUE) ; // Pav� virements
          END
        Else RemoveGroupTN(-38210,TRUE) ; // Pav� virements *)
      RemoveItemTN(38210) ; // Emissions de bordereaux
      RemoveItemTN(38290) ; // Emissions de bordereaux internationales
      RemoveItemTN(38535) ; // Profil utilisateur
      RemoveItemTN(38540) ; // Circuit validation d�caissement
      RemoveItemTN(38550) ; // Saisie de tr�so
      end ;

    // Groupes autres traiements
//    RemoveItemTN(38555) ; // relev� de facture
    RemoveItemTN(7589) ;  // Relev� de comptes

    // Groupe Lettrage
{$IFDEF SEPT}
    RemoveItemTN(7521);
    RemoveItemTN(7525);
    RemoveItemTN(7526);
{$ENDIF}

    // Groupe Editions
    RemoveGroupTN(-38515,True);

    // Groupe Etats libres
    RemoveGroupTN(-7456,True) ;

    // BPY le 16/12/2003 => suppression des export CFONB a la demande de la FFF
    RemoveItemTN(38125);
    RemoveItemTN(38215);
    RemoveItemTN(38297);
    // fin BPY

    end ;

  // Tiers payeurs
  If NumModule=39 Then
    begin
    // Editions non eAGL :
    RemoveItemTN(39103);  // Factures
    RemoveItemTN(39104);  // Balance Ag�e
    RemoveItemTN(39105);  // Grandlivre Ag�e
    RemoveItemTN(39106);  // Balance ventil�e
    RemoveItemTN(39107);  // Grandlivre ventil�e
    end;

  // Suivi clients
  If NumModule=37 Then
    begin
      //=== Pav�s � oter ===
      RemoveGroupTN(-37250,TRUE) ; // pav� ch�que
      RemoveGroupTN(-37260,TRUE) ; // Pav� carte bleu
      RemoveGroupTN(-37305,TRUE) ; // Pav� lots
      // Pav� Lettrage
{$IFDEF SEPT}
    RemoveItemTN(7520);
    RemoveItemTN(7523);
    RemoveItemTN(7524);
{$ENDIF}

      RemoveGroupTN(37400,TRUE) ;  // Pav� Relance
      RemoveGroupTN(-37515,TRUE) ; // Pav� Editions
      RemoveGroupTN(-7456,TRUE) ;  // Pav� Etats libres

      //=== D�tails des Pav�s ===
      // Dans le pav� Pr�l�vements
      RemoveItemTN(37210) ; // Emission de bordereau

      // Dans le pav� autres traitements
      RemoveItemTN(37510) ;   // Modification des �ch�ances
      RemoveItemTN(37535) ;   // Profil utilisateur
//      RemoveItemTN(37555) ;   // Relev� de facture
//      RemoveItemTN(7589) ;    // Relev� de comptes

      // autres ???
      RemoveItemTN(-37260) ;
      RemoveItemTN(-37305) ;
      RemoveItemTN(37550) ; // saisie tr�so

      // BPY le 16/12/2003 => suppression des export CFONB a la demande de la FFF
      RemoveItemTN(-44);
      RemoveItemTN(37215);
      // fin BPY
    end ;
end ;

procedure AfterChangeModule ( NumModule : integer ) ;
var
  i : Integer;
BEGIN
  UpdateSeries ;
  AssignLesZoom ;
  ChargeMenuPop(integer(hm19),FMenuG.DispatchX) ;
  if FMenuG.PopupMenu=Nil then FMenuG.PopUpMenu:=ADDMenuPop(Nil,'','') ;
  // Supprime le menu Soci�t� du popup car la fonction AGL n'est pas encore port�e
  for i := 0 to FMenuG.PopupMenu.Items.Count-1 do begin
    if FMenuG.PopupMenu.Items[i].Tag = 25770 then begin
      FMenuG.PopupMenu.Items[i].Free;
      Break;
    end;
  end;
  UpdateModuleCCMP(NumModule) ;
  case NumModule of
    37 : BEGIN VH^.CCMP.LotCli := True; VH^.CCMP.LotFou := False; end;
    38 : BEGIN VH^.CCMP.LotCli := False; VH^.CCMP.LotFou := True; end;
  end;
END ;

procedure InitApplication ;
Var sDom : String ;
BEGIN
  AssignZoom ;
  FMenuG.OnDispatch:=Dispatch ;
  FMenuG.OnChangeModule:=AfterChangeModule ;
  FMenuG.OnChargeMag:=ChargeMagHalley ;
  FMenuG.OnAfterProtec:=AfterProtec ;
  FMenuG.OnMajAvant:=nil;
  FMenuG.OnMajApres:=nil;
  FMenuG.SetModules([6],[]) ;
  FMenuG.SetPreferences(['Saisies'],False) ;
  If EstSerie(S3) Then
    BEGIN
    sDom:='00016011' ;
    VH^.SerProdEtebac:='00018011' ;
    VH^.SerProdCCMP  :='00037050' ;
    FMenuG.SetSeria(sDom,[VH^.SerProdCCMP],['Suivi des r�glements']) ;
    END Else
  If EstSerie(S5) Then
    BEGIN
    sDom:='05990011' ;
    VH^.SerProdEtebac:='05030011' ;
    VH^.SerProdCCMP  :='00035050' ;
    FMenuG.SetSeria(sDom,[VH^.SerProdCCMP],['Suivi des r�glements']) ;
    END Else
  If EstSerie(S7) Then
    BEGIN
    sDom:='07990011' ;
    VH^.SerProdEtebac:='05030011' ;
    VH^.SerProdCCMP  :='00036050' ;
    FMenuG.SetSeria(sDom,[VH^.SerProdCCMP],['Suivi des r�glements']) ;
    END ;
     (*
     00037 : s3 CCMP
     00036 : s5 CCMP
     *)
//FMenug.BSeria.Visible:=FALSE ;
  FMenuG.SetModules([6],[]) ;
  FMenuG.SetPreferences(['Saisies'],False) ;
// Ajout me 07/01/2002
//ConnectDico := False;
END ;

procedure DispatchTT(Num : Integer; Action : TActionFiche; Lequel,TT,Range : String) ;
begin
    case Num of
        // general
        1,7112 : FicheGene(Nil,'',LeQuel,Action,0);
        // tiers
        2,7145 : FicheTiers(LeQuel,Action,1);
        // journal
        4,7211 : FicheJournal(Lequel,Action);

        // tables libres
        5 :
            begin
                if (not (pos('GENE',TT) = 0)) then AGLFicheNatCpte(nil,'G0'+AnsiLastChar(TT),'',Action,1)
                else if (not (pos('SECT',TT) = 0)) then AGLFicheNatCpte(nil,'S0'+AnsiLastChar(TT),'',Action,1)
                else if (not (pos('TIERS',TT) = 0)) then AGLFicheNatCpte(nil,'T0'+AnsiLastChar(TT),'',Action,1)
                else AGLFicheNatCpte(nil,'I0'+AnsiLastChar(TT),'',Action,1);
            end;

        // ???
        995 : ParamTable(TT,Action,0,Nil,9) ;   {choixext}
        997 : ParamTable(TT,Action,0,Nil,6) ;   {choixext}
        999 : ParamTable(TT,Action,0,Nil,3) ;   {choixcode ou commun}

        // section
        71781 : FicheSection(nil,'A1',Lequel,Action,1);
        71782 : FicheSection(nil,'A2',Lequel,Action,1);
        71783 : FicheSection(nil,'A3',Lequel,Action,1);
        71784 : FicheSection(nil,'A4',Lequel,Action,1);
        71785 : FicheSection(nil,'A5',Lequel,Action,1);

        // compteur
        72111 :
            begin
                case Action of
                    taCreat : YYLanceFiche_Souche('CPT','','ACTION=CREATION;CPT');
                    taModif : YYLanceFiche_Souche('CPT','','ACTION=MODIFICATION;CPT');
                else YYLanceFiche_Souche('CPT','','ACTION=CONSULTATION;CPT');
                end;
            end;

    end ;
end ;

Procedure Dispatch ( Num : Integer ; PRien : THPanel ; var retourforce,sortiehalley : boolean);
BEGIN
  Case Num of
    6 : ;
    10 : begin
           ChargeHalleyUser ;
        end;       //  apr�s connexion
    11 : ; //  apr�s d�connexion
    12 : ; //  avant connexion et s�ria
    13 : ;
    15 : ; //  ??????
    16 : ; // Entre connexion et chargemodule
    100 : {if (ctxPCL in V_PGI.PGIContexte) or (True) then
              begin
                if PCL_IMPORT_BOB('CCS5') = 1 then
                begin
                  stMessage := 'LE SYSTEME A DETERMINE UNE MAJ DE MENU';
                  stMessage := stMessage +#13#10 +'POUR ETRE PRISE EN COMPTE';
                  stMessage := stMessage +#13#10 +'LE LOGICIEL VA SE FERMER AUTOMATIQUEMENT';
                  stMessage := stMessage +#13#10 +'VOUS DEVEZ RELANCER L''APPLICATION';
                  PGIInfo(stMessage+' : '+V_PGI_Env.DBSocName,'MAJ MENU');
                  FMenuG.ForceClose := TRUE;
                  PostMessage(FmenuG.Handle,WM_CLOSE,0,0) ;
                  RetourForce:=true;
                  FermeHalley:=true;
                  exit;
                end;
                if not LanceAssistantComptaPCL(True) then begin FMenuG.ForceClose := True; FMenuG.Close; Exit; end;
                RetourForce:=True ;
              end;
            } ;

//==== Suivi clients (37)  ====
    // Traites
      37105 : SuivAcceptation(prClient);     // Suivi acceptation
      37108 : SelectSuiviMP(smpEncTraEdt) ;  // Lettres-traites // Pr�paration
      37110 : GenereSuiviMP(smpEncTraEdtNC); // Lettres-traites // Editions des lettres-traite
      37115 : GenereSuiviMP(smpEncTraEdt) ; // Lettres-traites // Edition et comptabilisation des lettres-traite
      37120 : SaisieEffet(OnEffet);         // Saisie des traites en retour d'acceptation
      37124 : SelectSuiviMP(smpEncTraPor) ; // Portefeuille // Pr�paration
      37125 : GenereSuiviMP(smpEncTraPor) ; // Portefeuille // Mise en portefeuille
      37129 : SelectSuiviMP(smpEncTraEnc) ; // Remise � l'encaissement // Pr�paration
      37130 : GenereSuiviMP(smpEncTraEnc) ; // Remise � l'encaissement // Remise
      37134 : SelectSuiviMP(smpEncTraEsc) ; // Remise � l'escompte // Pr�paration
      37135 : GenereSuiviMP(smpEncTraEsc) ; // Remise � l'escompte // Remise
      37137 : SelectSuiviMP(smpEncTraBqe) ; // Remise en banque // Pr�paration
      37138 : GenereSuiviMP(smpEncTraBqe) ; // Remise en banque // Remise
      37140 : ExportCFONBMP(smpEncTraEsc) ; // Export CFONB // Traites-BOR � l'escompte
      37145 : ExportCFONBMP(smpEncTraEnc) ; // Export CFONB // Traites-BOR � l'encaissement

    // Pr�l�vements
      37203 : SelectSuiviMP(smpEncPreEdt) ; // Pr�paration
      37205 : GenereSuiviMP(smpEncPreEdtNC) ; // Edition des lettres-pr�l�vement
      37204 : GenereSuiviMP(smpEncPreEdt) ; // Edition et comptabilisation des lettres-pr�l�vement

      37207 : SelectSuiviMP(smpEncPreBqe) ; // Comptabilisation pr�l�vement // Pr�paration
      37208 : GenereSuiviMP(smpEncPreBqe) ; // Comptabilisation pr�l�vement // Comptabilisation
      37210 : ; // Emissions de bordereaux clients
      37215 : ExportCFONBMP(smpEncPreBqe) ; // Export CFONB

    // Ch�ques
      37250 : SaisieEffet(OnChq) ;          // Saisie des ch�ques en portefeuille
      37251 : SelectSuiviMP(smpEncChqPor) ; // Mise en portefeuille // Pr�paration
      37252 : GenereSuiviMP(smpEncChqPor) ; // Mise en portefeuille // Remise
      37253 : SelectSuiviMP(smpEncChqBqe) ; // Remise � l'encaissement // Pr�paration
      37254 : GenereSuiviMP(smpEncChqBqe) ; // Remise � l'encaissement // Remise
      37256 : ; // Emission de bordereaux

    // Cartes bleues
      37260 : SaisieEffet(OnCB) ;          // Saisie de cartes bleues en portefeuille
      37261 : SelectSuiviMP(smpEncCBPor) ; // Mise en portefeuille // Pr�paration
      37262 : GenereSuiviMP(smpEncCBPor) ; // Mise en portefeuille // Remise
      37263 : SelectSuiviMP(smpEncCBBqe) ; // Remise � l'encaissement // Pr�paration
      37264 : GenereSuiviMP(smpEncCBBqe) ; // Remise � l'encaissement // Remise
      37266 : ; // Emission de bordereaux

    // Gestion par lots
//      37305 : AffecteBanquePrevi(True,taCreat) ;  // Cr�ation d'un lot
//      37310 : AffecteBanquePrevi(True,taModif) ;  // Modification d'un lot
//      37312 : UpdateLibelleToutModele ;           // Suppression d'un lot
      37315 : GenereSuiviMP(smpEncTous)   ;       // Encaissements

    // Lettrage
      7508 : LanceLettrageMP(prClient);             // Lettrage manuel
      7511 : LanceDeLettrageMP(prClient);           // D�lettrage
      7514 : RapprochementAutoMP('','',prClient);   // Lettrage automatique
{$IFNDEF SEPT}
      7520 : RegulLettrageMP(True,False,prCLient);  // R�gularisation de lettrage
      7523 : RegulLettrageMP(False,False,prCLient); // Diff�rence de change
      7524 : RegulLettrageMP(False,True,prCLient);  // Ecart de conversion
{$ENDIF}

    // Relances
//      37405 : If Not EstSpecif('51197') Then RelanceClientNew(True,True) Else RelanceClient(True,True);     // Manuelles // Effets en retour d'acceptation
//      37410 : If Not EstSpecif('51197') Then RelanceClientNew(True,False) Else RelanceClient(True,False);   // Manuelles // Autres mode en retard de r�glement
//      37415 : If Not EstSpecif('51197') Then RelanceClientNew(False,True) Else RelanceClient(False,True);   // Automatiques // Effets en retour d'acceptation
//      37420 : If Not EstSpecif('51197') Then RelanceClientNew(False,False) Else RelanceClient(False,False); // Automatiques // Autres mode en retard de r�glement
//      7583 : CalculScoring;          // Calcul du scoring
//      7598 : LanceCoutTiers('',0);   // Estimation des co�ts financiers

    // Editions
//      37515 : Echeancier(smpEncTous);                       // Ech�ancier
//      37520 : JustSolde(smpEncTous);                        // Justificatif de solde
//      37525 : CPLanceFiche_BalanceAgee;                     // Balance �g�e
//      7550 : GLivreAge;                                     // Grand-livre �g�
//      37530 : CPLanceFiche_BalanceVentilee;                 // Balance ventil�e
//      7559 : GLVentile ;                                    // Grand-livre ventil�
//      7560 : GLAuxiliaireL;                                 // Grand-livre auxiliaire en situation
      37531 : AGLLanceFiche('CP', 'SUIVICLIENT', '', '', ''); // Statistiques

    // Autres traitemens
      37502 : GenereSuiviMP(smpEncDiv);                         // Encaissements divers
      37505 : ExportCFONBBatch(False,True,tslAucun);            // Emissions de bordereaux banque
      37510 : ModifEcheMP;                                    // Modifications des �ch�ances
      37535 : AGLLanceFiche('CP', 'PROFILUSER', '', '', 'CLI'); // Profils utilisateur
      37545 : ExportCFONBBatch(True,True,tslAucun,smpEncTous);  // Export CFONB
      37550 : SaisieEffet(OnBqe,srCli);                         // Saisie de tr�sorerie
      37555 : ReleveFacture;                                  // Relev�s de factures - SUPPRIME
      7589 : ReleveCompte;                                    // Relev�s de comptes

    // Etats libres
//      7456 : LanceEtatLibreS5 ;

//==== Suivi fournisseurs (38)  ====
    // B.O.R.
      38104 : SelectSuiviMP(smpDecBorEdt);   // Lettres-BOR // Pr�paration
      38105 : GenereSuiviMP(smpDecBorEdtNC); // Lettres-BOR // Edition des lettres BOR
      38110 : GenereSuiviMP(smpDecBorEdt);   // Lettres-BOR // Edition et comptabilisation des lettres-BOR
      38114 : SelectSuiviMP(smpDecTraPor);   // Mise en portefeuille // Pr�paration
      38115 : GenereSuiviMP(smpDecTraPor);   // Mise en portefeuille // Mise en portefeuille
      38119 : SelectSuiviMP(smpDecBorDec);   // Remise en banque // Pr�paration
      38120 : GenereSuiviMP(smpDecBorDec);   // Remise en banque // Remise
      38125 : ExportCFONBMP(smpDecBorDec);   // Export CFONB

    // Virements
      38202 : SelectSuiviMP(smpDecVirEdt) ;   // Lettres-virement // Pr�paration
      38206 : GenereSuiviMP(smpDecVirEdtNC) ; // Lettres-virement // Edition des lettres-virement
      38203 : GenereSuiviMP(smpDecVirEdt) ;   // Lettres-virement // Edition et comptabilisation des lettres-virement
      38204 : SelectSuiviMP(smpDecVirBqe) ;   // Comptabilisation virement // Pr�paration
      38205 : GenereSuiviMP(smpDecVirBqe) ;   // Comptabilisation virement // Comptabilisation
//      38210 :;                                // Emissions de bordereaux // SUPPRIME
      38215 : ExportCFONBMP(smpDecVirBqe) ;   // Export CFONB

    // Virements internationaux
      38282 : SelectSuiviMP(smpDecVirInEdt) ;   // Lettres-virement internationale // Pr�paration
      38286 : GenereSuiviMP(smpDecVirInEdtNC) ; // Lettres-virement internationale // Edition des lettres-virement internationale
      38283 : GenereSuiviMP(smpDecVirInEdt) ;   // Lettres-virement internationale // Edition et comptabilisation des lettres-virement internationale
      38284 : SelectSuiviMP(smpDecVirInBqe) ;   // Comptabilisation virement internationale // Pr�paration
      38285 : GenereSuiviMP(smpDecVirInBqe) ;   // Comptabilisation virement internationale // Comptabilisation
//      38290 : ;                                 // Emissions de bordereaux // SUPPRIME
      38297 : ExportCFONBMP(smpDecVirInBqe) ;   // Export CFONB

    // Gestion par lots
//      38305 : AffecteBanquePrevi(False,taCreat);  // Cr�ation d'un lot
//      38310 : AffecteBanquePrevi(False,taModif);  // Modification d'un lot
//      38311 : SuivBAP;                            // Bons � payer
//      38312 :;                                    // Suppression  d'un lot
      38315 : GenereSuiviMP(smpDecTous);          // D�caissements

    // Ch�ques
      38408 : SelectSuiviMP(smpDecChqEdt);   // Lettres-ch�ques // Pr�paration lettre ch�que
      38409 : GenereSuiviMP(smpDecChqEdtNC); // Lettres-ch�ques // Edition des lettres-ch�que
      38410 : GenereSuiviMP(smpDecChqEdt);   // Lettres-ch�ques // Edition et comptabilisation des lettres-ch�que

    // Lettrage
      7509 : LanceLettrageMP(prFournisseur);             // Lettrage manuel
      7512 : LanceDeLettrageMP(prFournisseur);           // D�lettrage
      7515 : RapprochementAutoMP('','',prFournisseur);   // Lettrage automatique
{$IFNDEF SEPT}
      7521 : RegulLettrageMP(True,False,prFournisseur);  // R�gularisation de lettrage
      7525 : RegulLettrageMP(False,False,prFournisseur); // Diff�rence de change
      7526 : RegulLettrageMP(False,True,prFournisseur);  // Ecart de conversion
{$ENDIF}

    // Editions
//      38515 : Echeancier(smpDecTous);                       // Ech�ancier
//      38520 : JustSolde(smpDecTous);                        // Justificatif de solde
//      38525 : CPLanceFiche_BalanceAgee;                     // Balance �g�e
//      7550 : GLivreAge;                                     // Grand-livre �g�
//      38530 : CPLanceFiche_BalanceVentilee;                 // Balance ventil�e
//      7559 : GLVentile ;                                    // Grand-livre ventil�
//      7560 : GLAuxiliaireL;                                 // Grand-livre auxiliaire en situation
//      38531 : AGLLanceFiche('CP', 'SUIVIFOU', '', '', '');  // Statistiques

    // Autres traitements
      38502 : GenereSuiviMP(smpDecDiv);                              // D�caissements divers
      38505 : ExportCFONBBatch(False,FALSE,tslAucun);                // Emission borderau banque
      38510 : ModifEcheMP;                                         // Modification d'�ch�ances
//      38535 : AGLLanceFiche('CP', 'PROFILUSER', '', '', 'FOU');    // Profils utilisateurs
//      38540 : ;// SUPPRIME                                         // Circuit Validation d�caissement
      38545 : If LikeS3 Then ExportCFONBBatch(True,False,tslAucun);  // Export CFONB
      38550 : SaisieEffet(OnBqe,srFou);                              // Saisie de tr�sorerie
      38555 : ReleveFacture;                                       // Relev�s de factures
//      7589 :; // Voir Suivi clients

    // Etats libres
//      7456 :; // Voir Suivi clients

//==== Ecritures (9)  ====
    // Courantes
    7244 : MultiCritereMvt(taCreat,'N',False);                     // Saisie courante
//      7005 : SaisieFolio(taModif);                                   // Saisie bordereau

//==== Tiers payeurs (39)  ====
    // Editions
      39101 : CCLanceFiche_EPTIERSP('TFP');                         // Tiers factur� par payeur
      39102 : CCLanceFiche_EPTIERSP('TFA');                         // Tiers factur� avec payeur
//      39103 : BrouillardTP;                                       // Factures
//      39104 : BalanceAge2TP;                                      // Balance �g�e
//      39105 : GLivreAgeTP;                                        // Grand-livre �g�
//      39106 : BalVentileTP;                                       // Balance ventil�e
//      39107 : GLVentileTP;                                        // Grand-livre ventil�

//==== Structures et param�tres (17) ====
    // Structures
    7112 : CCLanceFiche_MULGeneraux('C;7106000');  // Comptes g�n�raux
    7145 : CPLanceFiche_MULTiers('C;7139000');     // Comptes auxiliaires   // 7145000 : Modification
    7178 : CPLanceFiche_MULSection('C;7172000');   // Sections analytiques  // 7175000,7178000 : Modification ; 7176000 : Assistant de cr�ation
    7211 : CPLanceFiche_MULJournal('C;7205000');   // Journaux              // 7208000,7211000 : Modification
//    7117 : ; // Modification de nature des comptes g�n�raux
    7118 : CCLanceFiche_MULGeneraux('S;7118000');  // Suppressions // Comptes g�n�raux
    7151 : CPLanceFiche_MULTiers('S;7151000');     // Suppressions // Comptes auxiliaires
    7184 : CPLanceFiche_MULSection('S;7184000');   // Suppressions // Sections analytiques
    7214 : CPLanceFiche_MULJournal('S;7214000');   // Suppressions // Journaux

// A FAIRE
//    7133 : CCLanceFiche_MULGeneraux('I;7133000');     // Impressions // Comptes g�n�raux
//    7166 : CPLanceFiche_MULTiers('I;7166000');        // Impressions // Tiers
//    7199 : CPLanceFiche_MULSection('I;7199000');      // Impressions // Sections analytiques
//    7229 : CPLanceFiche_MULJournal('I;7229000');      // Impressions // Journaux
    7124 : CCLanceFiche_MULGeneraux('F;7124000');  // Ouverture/Fermeture // Fermeture des g�n�raux
    7127 : CCLanceFiche_MULGeneraux('O;7127000');  // Ouverture/Fermeture // Ouverture des g�n�raux
    7157 : CPLanceFiche_MULTiers('F;7157000');     // Ouverture/Fermeture // Fermeture des auxiliaires
    7160 : CPLanceFiche_MULTiers('O;7160000');     // Ouverture/Fermeture // Ouverture des auxiliaires
    7190 : CPLanceFiche_MULSection('F;7190000');   // Ouverture/Fermeture // Fermeture des sections
    7193 : CPLanceFiche_MULSection('O;7193000');   // Ouverture/Fermeture // Ouverture des sections
    7220 : CPLanceFiche_MULJournal('F;7220000');   // Ouverture/Fermeture // Fermeture des journaux
    7223 : CPLanceFiche_MULJournal('O;7223000');   // Ouverture/Fermeture // Ouverture des journaux
//    7115 : MulticritereCpteGene(taModifEnSerie);   // Modifications en s�rie // Comptes g�n�raux
//    7148 : MultiCritereTiers(taModifEnSerie);      // Modifications en s�rie // Tiers
//    7181 : MulticritereSection(taModifEnSerie);    // Modifications en s�rie // Sections analytiques

    // Soci�t�
//    1104 : ParamSociete(False,VirerParamSoc,'SCO_PARAMETRESGENERAUX;SCO_CCMP','',RechargeParamSoc,ChargePageSoc,SauvePageSoc,InterfaceSoc,1105000);  // Param�tres soci�t�
//    1105 : FicheAxeAna ('') ;                                   // Axes analytiques
    1110 : FicheEtablissement_AGL(taModif) ;                      // Etablissements

    1120 : ParamTable('ttFormeJuridique',taCreat,1120000,PRien) ; // Tables // Formes juridiques
    1122 : ParamTable('ttCivilite',taCreat,1122000,PRien) ;       // Tables // Civilit�s
    1125 : ParamTable('ttFonction',taCreat,1125000,PRien) ;       // Tables // Fonctions des contacts
    1135 : OuvrePays ;                                            // Tables // Pays
    1140 : FicheRegion('','',False) ;                             // Tables // R�gion
    1145 : OuvrePostal(PRien) ;                                   // Tables // Codes postaux}
    1150 : AGLLanceFiche('YY','DEVISE','','','');                 // Tables // Devises
    1165 : ParamTable('TTREGIMETVA',taCreat,1165000,PRien) ;      // Tables // R�gimes fiscaux
    1170 : ParamTvaTpf(true) ;                                    // Tables // TVA par r�gime fiscal
    1175 : ParamTvaTpf(false) ;                                   // Tables // TPF par r�gime fiscal
    1185 : FicheModePaie_AGL('');                                 // Tables // Modes de paiement
    1190 : FicheRegle_AGL('',FALSE,taModif) ;                     // Tables // Conditions de r�glements
    1191 : ParamTable('ttQualUnitMesure',taCreat,1190030,PRien) ; // Tables // Qualifiants des quantit�s
    1194 : CPLanceFiche_ParamTablesLibres;  // Tables libres // Personalisation
    1196 : CPLanceFiche_ChoixTableLibre;    // Tables libres // Saisie
//    1198 : // Tables libres // Synchronisation

    // Param�tres
    1290 : YYLanceFiche_Exercice('0');                              // Exercice
    1300 : YYLanceFiche_Souche('CPT','','ACTION=MODIFICATION;CPT'); // Compteurs // Comptables
    1301 : YYLanceFiche_Souche('REL','','ACTION=MODIFICATION;REL'); // Compteurs // Relev�s
//      1315 : FichePlanRef(1,'',taModif);                            // Plans de r�f�rence
//      1325 : CCLanceFiche_Correspondance('GE');	// Plan de correspondance // G�n�raux
//      1330 : CCLanceFiche_Correspondance('AU');	// Plan de correspondance // Auxiliaire
//      1345 : CCLanceFiche_Correspondance('A1');	// Plan de correspondance // Axe analytique 1
//      1350 : CCLanceFiche_Correspondance('A2');	// Plan de correspondance // Axe analytique 2
//      1355 : CCLanceFiche_Correspondance('A3');	// Plan de correspondance // Axe analytique 3
//      1360 : CCLanceFiche_Correspondance('A4');	// Plan de correspondance // Axe analytique 4
//      1365 : CCLanceFiche_Correspondance('A5');	// Plan de correspondance // Axe analytique 5
//      1375 : PlanRupture('RUG');                // Plan de rupture des �ditions // Comptes g�n�raux
//      1380 : PlanRupture('RUT');                // Plan de rupture des �ditions // Comptes auxiliaires
//      1395 : PlanRupture('RU1');                // Plan de rupture des �ditions // Sections axe 1
//      1400 : PlanRupture('RU2');                // Plan de rupture des �ditions // Sections axe 2
//      1405 : PlanRupture('RU3');                // Plan de rupture des �ditions // Sections axe 3
//      1410 : PlanRupture('RU4');                // Plan de rupture des �ditions // Sections axe 4
//      1415 : PlanRupture('RU5');                // Plan de rupture des �ditions // Sections axe 5
//      1425 : ParamLibelle ;                     // Libell�s automatiques
//      1426 :; // Compte de regroupement // Comptes g�n�raux
//      1450 : ParamPlanAnal('');  // Analytiques // Structures analytiques
//      1460 : ParamVentilType;    // Analytiques // Ventilations types

//      1485 : ParamEtapeReg(True,'',True);  // Etapes de r�glement // Etapes d'encaissement
//      1490 : ParamEtapeReg(False,'',True); // Etapes de r�glement // Etapes de d�caissement
//      1491 : CircuitDec;                   // Etapes de r�glement // Circuit de validation des d�caissements

//      7574 : CCLanceFiche_ParamRelance('RTR');  // Param�tres de relance // Effets en retour d'acceptation
//      7577 : CCLanceFiche_ParamRelance('RRG');  // Param�tres de relance // Autres modes en retard de r�glement

    // Ecritures
    7352 : CPLanceFiche_MulGuide('','','');   // Guide
    7355 : CPLanceFiche_Scenario('','');      // Sc�nario

    // Banques
    1705 : FicheBanque_AGL('',taModif,0);                  // Etablissements bancaires
    1720 : ParamTable('ttCFONB',taCreat,0,PRien);          // Codes CFONB
//    1725 : ParamCodeAFB;                                 // Codes AFB
//    1730 : ParamTable('ttCodeResident',taCreat,0,PRien); // Codes r�sidents �trangers
//    1272 : AglLanceFiche('CP','PARAMODBQ','','','');     // Param�trage mod�le-banque

    // Documents
//      1235 : EditDocument('L','REL','',TRUE);             // Comptabilit� // Lettres de relances
//      1240 : EditDocument('L','RLV','RLV',FALSE);         // Comptabilit� // Relev�s de factures
//      1245 : EditDocument('L','RLC','',True);             // Comptabilit� // Relev�s de comptes
//      1247 : EditEtat('E','SAI','',True,nil,'','');       // Comptabilit� // Editions en cours de saisie
//      1248 : EditEtat('E','BAP','',True,nil,'','');       // Comptabilit� // Bons � payer

//      1267 : EditDocument('L','LCH','',True);             // Banque // Lettres ch�ques
//      1268 : EditDocument('L','LTR','',True);             // Banque // Traites LCR/BOR
//      1269 : EditDocument('L','LVI','',True);             // Banque // Lettres virement
//      1266 : EditDocument('L','LPR','',True);             // Banque // Lettres pr�l�vement
//      1257 : EditEtat('E','BOR','',True,nil,'','');       // Banque // Bordereaux d'accompagnement

    // Editions param�trables - SUPPRIME

//      1270 : EditEtatS5S7('E','UCO','',True,nil,'','');  // Etats libres // Comptabilit�
//      1271 : EditEtatS5S7('E','UBU','',True,nil,'','');  // Etats libres // Budget

//==== Administrations / Outils (18) ====
    // Soci�t�
//    3130 : GestionSociete(PRien,@InitSociete,NIL);  // Gestionnaire des soci�t�s
//    3140 : LanceAssistSO;                           // Assistant de param�trage
//    3145 : RecopieSoc(PRien,True);                  // Recopie soci�t� � soci�t�
//    3155 : RAZSociete;                              // Remise � z�ro de l'activit�

    // Utilisateurs et acc�s
    3165  : FicheUserGrp;                                      // Groupes d'utilisateurs
    60208 : GCLanceFiche_Confidentialite( 'YY','YYCONFIDENTIALITE','','','37;38;39;17;18;27'); 
    3170  : BEGIN FicheUSer(V_PGI.User) ; ControleUsers ; END; // Utilisateurs
    3172  : AGLLanceFiche('YY','PROFILETABL','','','ETA');     // Restrictions utilisateurs
//    3180  : ReseauUtilisateurs(False);                       // Utilisateurs connect�s
//    3185  : VisuLog;                                         // Suivi d'activit�
//    3195  : ReseauUtilisateurs(True);                        // Remise � z�ro connexions

    // Outils - SUPPRIME

    // Comptables - SUPPRIME

 //=== Menu Pop Compta ===
    25710 : CCLanceFiche_MULGeneraux('C;7106000');  // Comptes g�n�raux
    25720 : CPLanceFiche_MULTiers('C;7139000');     // Comptes auxiliaires
    25730 : CPLanceFiche_MULSection('C;7172000');   // Sections analytiques
    25740 : CPLanceFiche_MULJournal('C;7205000');   // Journaux
    25750 : MultiCritereMvt(taConsult,'N',False);   // Consultation des �critures
    25755 : OperationsSurComptes('','','') ;	    // Consultation des comptes
    25760 : ModifEcheMP;                            // Modification des �ch�ances
//    25770 : ParamSociete(False,VirerParamSoc,'SCO_PARAMETRESGENERAUX;SCO_CCMP','',RechargeParamSoc,ChargePageSoc,SauvePageSoc,InterfaceSoc,1105000) ;
    else HShowMessage('2;?caption?;'+TraduireMemoire('Fonction non disponible : ')+';W;O;O;O;',TitreHalley,IntToStr(Num)) ;
  end ;
END ;

// Modifie les boutons circuits de deca
procedure ChangeMenuDeca ;
var Q      : TQuery ;
    n      : integer ;
    s      : string ;
begin
Q:=OpenSQL('SELECT * FROM CHOIXCOD WHERE CC_TYPE="CID" ORDER BY CC_CODE',True) ;
n:=0 ;
While not Q.EOF do
   begin
   Inc(n) ;
   s:=Q.FindField('CC_LIBELLE').AsString ;
   if Trim(s)='' then FMenuG.RemoveItem(74990+n) else FMenuG.RenameItem(74990+n,s) ;
   Q.Next ;
   end ;
Ferme(Q) ;
end ;

Procedure LanceEtatLibreS5 ;
Var CodeD : String ;
begin
CodeD:=Choisir('Choix d''un �tat libre','MODELES','MO_CODE || " " || MO_LIBELLE','MO_CODE','MO_NATURE="UCO" AND MO_MENU="X"','') ;
if CodeD<>'' then LanceEtat('E','UCO',CodeD,True,False,False,Nil,'','',False) ;
end;

procedure RenseigneSerie ;
var Buffer: array[0..1023] of Char;
    sWinPath,sIni : String ;
begin
  //HalSocIni:='CCS5.ini' ;
  HalSocIni:='CEGIDPGI.ini' ;
  GetWindowsDirectory(Buffer,1023);
  SetString(sWinPath, Buffer, StrLen(Buffer));
  sIni:=sWinPath+'\'+HALSOCINI ;
  if FileExists(sIni) then
     BEGIN
     //HalSocIni:='CCS5.ini' ;
     HalSocIni:='CEGIDPGI.ini' ;
     NomHalley:= 'Comptabilit� S5' ;
     TitreHalley := 'Suivi des r�glements S5' ;
     V_PGI.LaSerie:=S5 ;
     Application.HelpFile:=ExtractFilePath(Application.ExeName)+'CCMP.HLP' ;
     END else
     BEGIN
     //HalSocIni:='CCS7.ini' ;
     HalSocIni:='CEGIDPGI.ini' ;
     NomHalley:= 'Comptabilit� S7' ;
     TitreHalley := 'Suivi des r�glements S7' ;
     V_PGI.LaSerie:=S7 ;
     Application.HelpFile:=ExtractFilePath(Application.ExeName)+'CCMP.HLP' ;
     END ;
END ;

Procedure InitLaVariablePGI;
Begin
//RenseigneSerie ;
Apalatys:='CEGID' ;
Copyright:='� Copyright ' + Apalatys ;
V_PGI.OutLook:=FALSE ;
V_PGI.VersionDemo:=false ;
V_PGI.VersionReseau:=True ;
V_PGI.MenuCourant:=0 ;

V_PGI.VersionDEV:=False ;
V_PGI.ImpMatrix := True ;
V_PGI.OKOuvert:=FALSE ;
V_PGI.Halley:=TRUE ;
//V_PGI.NiveauAcces:=1 ;
V_PGI.OfficeMsg:=True ;
V_PGI.NumMenuPop:=27 ;
V_PGI.DispatchTT:=DispatchTT ;
V_PGI.ParamSocLast:=False ;
V_PGI.RAZForme:=TRUE ;
V_PGI.PGIContexte:=[ctxCompta] ;
V_PGI.MajPredefini:=False ;
V_PGI.BlockMAJStruct:=True ;
V_PGI.EuroCertifiee:=True ;
V_PGI.CegidAPalatys:=FALSE ;
V_PGI.CegidBureau:=TRUE ;
V_PGI.StandardSurDP:=True ;

RenseignelaSerie(ExeCCMP) ;

(*V_PGI.NumVersion:='4.47' ;
V_PGI.NumBuild:='105.001' ;
V_PGI.NumVersionBase:=611 ;
V_PGI.DateVersion:=EncodeDate(2003,12,1) ;*)

ChargeXuelib ;

V_PGI.NoModuleButtons:=False ;
V_PGI.NbColModuleButtons:=1 ;
end;

Initialization
  ProcChargeV_PGI :=  InitLaVariablePGI ;

end.


