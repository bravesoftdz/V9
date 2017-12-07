unit MDispMP ;

interface

uses Forms, HPanel, HEnt1, paramsoc, Classes
{$IFDEF EAGLCLIENT}

{$ELSE}
     ,DB
{$ENDIF}
     ;

Procedure LanceEtatLibreS5 ;
Procedure Dispatch ( Num : Integer ; PRien : THPanel ; Var RetourForce,FermeHalley : boolean );
Procedure AfterProtec ( sAcces : String ) ;
procedure AssignLesZoom ;
procedure RemoveGroupTN(i : Integer ; b : Boolean) ;
Procedure RemoveItemTN(i : Integer) ;
procedure AfterChangeModule ( NumModule : integer ) ;
procedure AssignZoom ;
procedure InitApplication ;
procedure DispatchTT(Num : Integer; Action : TActionFiche; Lequel,TT,Range : String) ;
Procedure InitLaVariablePGI;

type
  TFMDispMP = class(TDatamodule)
end;

procedure RemoveFromMenu ( const iTag : integer; const bGroup : boolean; var stAExclure : string );
procedure TripotageMenuModePGE ( const TNumModule : array of integer; var stAExclure : string );
procedure TripotageMenuInternat ( const TNumModule : array of integer; var stAExclure : string ); //SDA le 18/12/2007
function OnChangeUser : Boolean;

Var FMDispMP : TFMDispMP ;
Init : boolean ;

implementation

uses Choix, ComCtrls, Confidentialite_TOF, Ent1, EntPGI, Exercice_TOM, FichComm, HCtrls, HMsgBox, HOut, Messages,
     MulDLett, MulLettr, RappAuto, SAISBOR, SaisComm, Saisie, SaisUtil, Souche_TOM, SysUtils, TofEdCpt, TomProfilUser,
     UIUtil, UserGrp_TOM, UtilSoc, UtilPGI, UTOB, Windows, CPCHOIXTALI_TOF, CPTABLIBRELIB_TOF, CPGeneraux_Tom, CPJournal_Tom,
     CPTiers_Tom,CPSECTION_TOM, RELANCE_TOM,Corresp_TOM,EdtEtat,
     CPMULEXPORT_TOF,
     NATCPTE_TOM, UTOFCPMULMVT, CPAXE_TOM,
     CPMODIFECHEMP_TOF, {JP 28/10/05 : Suppression de la fiche 2/3 ModEcheMp.Pas}
     UTOFMULRELFAC,     {JP 28/10/05 : Suppression de la fiche 2/3 RelevTie.Pas}
     PLANGENE_TOF,      {JP 28/10/05 : Suppression de la fiche 2/3 QRPLANGE.Pas}
     PLANAUXI_TOF,      {JP 28/10/05 : Suppression de la fiche 2/3 QRPlanJo.Pas}
     PLANSECT_TOF,      {JP 28/10/05 : Suppression de la fiche 2/3 QRSectio.Pas}
     PLANJOUR_TOF,      {JP 28/10/05 : Suppression de la fiche 2/3 QRPlanJo.Pas}
     CPBALAGEE_TOF,     // SBO 18/11/2005 : remplacement TofBalagee par nouvelle bal. ag�e
     eSaisEff,          {JP 13/01/06 : Suppression de la fiche SaisEff.Pas}
     Reseau,
     MulLog,
{$IFDEF TAXES}
    TomYMODELETAXE, // SDA le 12/02/2007
    YYMODELECATREG_TOF, //SDA le 28/02/2007
    YYMODELECATTYP_TOF, //SDA le 28/02/2007
    YYDETAILTAXES_TOF,//SDA le 28/02/2007
    YYCOMPTESPARCAT_TOF, //SDA le 02/03/2007
    YYTYPESTAXES_TOF, //SDA le 05/03/2007
{$ENDIF}
{$IFDEF EAGLCLIENT}
     AGLInit, CPCFONBMP_TOF, CPCODEPOSTAL_TOF, CPLETREGUL_TOF,
     CPREGION_TOF, CPSUIVIACC_TOF, CPTEUTIL,
     CPTVATPF_TOF, DEVISE_TOM, eTablette, Maineagl, MenuOLX, PAYS_TOM, SUIVCPTA_TOM, UtileAGL, uTofConsEcr,
     UTOFMULRELCPT, UTOMUTILISAT,CegidIEU
{$ELSE}
     About,  CegidIEU, AddDico, AffBQE, Buttons, uLibCalcEdtCompta, CFONBMP,
     CodePost, CodeSect, Controls, ConsEcr, CopySoc, CpteSAV, CpteUtil, CreerSoc,
     CtrlFic, DBCtrls, DBGrids,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     Devise_tom, EcheModf, Ed_Tools, EdtDoc, EdtQR, EdtRDoc, EdtREtat,
     etbMce, ExtCtrls, FE_Main, GenereMP, Graph, Graphics, Grids, GrpFavoris, HCalc, HCapCtrl, HDB,
     HFLabel, HMacro, HMenu97, HRotLab, HStatus, HTB97, ImgList, IniFiles, InitSoc, LetRegul, LicUtil,
     Mask, MenuOLG, Menus, MulCour, MulSuivACC,
     MulSuivBAP, REFAUTO_TOM, {ParamLib,} Pays, PGIExec, Prefs,
//     MulGenereMP, MulSuiviMP, // int�gration des modules AGL en 2tiers
//     relance, relanceNew,     // remplacement de  relance, relanceNew par le module AGL en 2tiers
     {QRPlanGe, QrPlanJo, QRSectio, QrTier, JP 28/10/05 : remplacement par PLANGENE_TOF, ...}
     RAZ, Region, ReIndex, UTOFMULRELCPT,  ResulExo,
     Rupture, { BVE 22.05.07 Scenario} SUIVCPTA_TOM, Seria, SQL, StdCtrls, { BVE 03.05.07 Structur} CPSTRUCTURE_TOF,
     Tablette, TofSuiviClient, TofSuiviFou, TradForm, Tradmenu, Traduc,
     //{$IFDEF ESP}
     CPTVATPF_TOF,
     (*{$ELSE}
     Tva,
     {$ENDIF ESP}*) //XVI 24/02/2005
     UEdtComp, UIUtil3, UserChg, UtomUTILISAT, Xuelib
{$ENDIF}
    , CoutTier     //YMO 03/07/2006 FQ 17850 Menu Estimation des co�ts financiers dispo en CWAS  
    , uTOFCPMulGuide // 25/01/2006 Guide.pas supprim�
    , CPMASQUEMUL_TOF // SBO 09/07/2007 FQ20965 : mul des masques de saisie via dans CCMP
    , TofEcheancier
    , CPMulParamGener_TOF  // Mul des sc�narios d'enca/deca
    , CPMulEncaDeca_TOF    // Mul de g�n�ration des enca/deca
    , UTofCPSuiviMP        // remplacement de mulsuivimp par les modules AGL en 2tiers
    , UTofCPGenereMP       // remplacement de mulgeneremp par les modules AGL en 2tiers
    , CPRELANCECLIENT_TOF  // remplacement de  relance, relanceNew par le module AGL en 2tiers
    , CalcScor             // Calcul du scoring (menu relance)
//{$IFDEF ESP}
    , CCONDREMISE_TOM      // Condition de remise espagniole
//{$ENDIF ESP} //XVI 24/02/2005
    , UTOFMULPARAMGEN
    , UTOFCPGLAUXI         // GL en situation
    ,CPJustSold_Qr1_Tof
    ,CptPayeurFacture_tof
    ,CpBalAgeeTp_Qr1_tof
    ,CptPayeurGlAge_tof
    ,CpGlAgeVen_tof
    ,CLIENSSOC_TOM         // liaisons inter-soci�t�s        1765
    ,CLIENSETAB_TOM        // liaisons inter-�tablissement   1760
    ,CPGENECOMPEN_TOF      // G�n�ration de la compensation FP 21/02/2006
    ,CPGENERENCADECA_TOF
    ,CPMULCFONB
    ,LibChpLi
    ,CHGNATUREGENE_TOF
    ,Synchro
    ,TomIdentificationBancaire
{$IFDEF ADRESSE}
    , PARAMADRE_TOM    // Gestion des adresses.
    , SAISIEADR_TOF
{$ENDIF}
    ,uTomBanque
    ,TomAgence
    ,CPCODEAFB_TOF
    ,CPZOOM
    ,CPCFONB_TOF // remplace cfonbat 
    ,CPMULCIRCUITBAP_TOF,
    CPMULAFFECTBAP_TOF,
    CPMAILBAP_TOM,
    CPMULBAP_TOF,
    CPHISTORIQUEMAIL_TOF,
    CPTYPEVISA_TOM,
    CPCIRCUITBAP_TOF,
    TRMULCOMPTEBQ_TOF, {JP 10/05/07 : Liste des comptes bancaires}
    eSaisieTr, {JP 01/06/07 : FQ 20507}
    CPMULTYPEVISA_TOF,
    {$IFDEF MODENT1}
    CPVersion,
    CPTypeCons,
    {$ENDIF MODENT1}
    CPGENEECRTP_TOF  {FQ20627  15.06.07  YMO Branchement menu G�n�ration manuelle sur TP}
    ;

{$R *.DFM}

//   XXXX  XXXX  XXXX  X
//   X     X  X  X     X
//   XXXX  XXXX  X XX  X
//   X     X  X  X  X  X
//   XXXX  X  X  XXXX  XXXX

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 12/09/2003
Modifi� le ... :   /  /
Description .. : Suppression d'une ligen ou d'un groupe de menu avec mise
Suite ........ : � jour de la liste des tag supprim�s
Mots clefs ... :
*****************************************************************}
procedure RemoveFromMenu ( const iTag : integer; const bGroup : boolean; var stAExclure : string );
begin
  if bGroup then FMenuG.RemoveGroup (iTag, True)
  else RemoveItemTN (iTag);
  stAExclure := stAExclure+IntToStr(iTag)+';';
end;

{***********A.G.L.***********************************************
Auteur  ...... :
Cr�� le ...... : 12/09/2003
Modifi� le ... : 22/09/2003
Description .. : - Suppression des menus PGE
Suite ........ : - Constitution de la liste des tag � supprimer pour la gestion
Suite ........ : des favoris PGE
Mots clefs ... :
*****************************************************************}
procedure TripotageMenuModePGE ( const TNumModule : array of integer; var stAExclure : string );
var i, NumModule : integer;
begin

  // Autres modules � exclures
  for i := 0 to High(TNumModule) do
  begin
    NumModule := TNumModule[i];
    case NumModule of

      { Suivi clients }
      37 : begin
           VH^.CCMP.LotCli := True;
           VH^.CCMP.LotFou := False;
           if VH^.PaysLocalisation=CodeISOES then
           begin
              RemoveFromMenu(-37105,TRUE,stAExclure) ;
              RemoveFromMenu(-37205,TRUE,stAExclure) ;
              RemoveFromMenu(-37250,TRUE,stAExclure) ;
              RemoveFromMenu(-37260,TRUE,stAExclure) ;
              // SBO 20/04/007 : ajout du menu pr�paration
              RemoveFromMenu(-37502,TRUE,stAExclure) ;//RemoveFromMenu(37502,FALSE,stAExclure) ;
              RemoveFromMenu(37405,FALSE,stAExclure) ;
              RemoveFromMenu(37415,FALSE,stAExclure) ;
              RemoveFromMenu(37545,FALSE,stAExclure) ;
              RemoveFromMenu(37560,FALSE,stAExclure) ;
              RemoveFromMenu(37565,FALSE,stAExclure) ;
              RemoveFromMenu(-7456,TRUE,stAExclure) ;
           end else
               RemoveFromMenu(-370100,TRUE,stAExclure) ; //XVI 24/02/2005

{
             If Not EstSerie(S3) Then
               begin
               If Not EstSpecif('51192') Then RemoveFromMenu(-37205,TRUE, stAExclure) ; // Pav� pr�l�vements
               end
             else begin
               RemoveFromMenu(-37205,TRUE, stAExclure) ; // Pav� pr�l�vements
               RemoveFromMenu(-7456, True, stAExclure) ; // Etats libres // FQ 12951
             end;
}
             RemoveFromMenu(-37250,TRUE, stAExclure) ; // pav� ch�que
             RemoveFromMenu(-37260,TRUE, stAExclure) ; // Pav� carte bleu
             RemoveFromMenu(-37305,TRUE, stAExclure) ; // Pav� lots
             RemoveFromMenu(-37250, False, stAExclure) ;
             RemoveFromMenu(-37260, False, stAExclure) ;
             RemoveFromMenu(-37305, False, stAExclure) ;
             RemoveFromMenu(37535, False, stAExclure) ; //Profil utilisateur
             RemoveFromMenu(37550, False, stAExclure) ; // saisie tr�so
             RemoveFromMenu(7524, False, stAExclure) ; // Lettrage --> Ecart de conversion
             RemoveItemTN(37210) ;                   // Emission de bordereau pr�l�vement client
             RemoveFromMenu(37600,TRUE, stAExclure) ; {JP 10/05/07 : anciens �tats}


             // BPY le 16/12/2003 => suppression des export CFONB a la demande de la FFF
             RemoveItemTN(-44);
             RemoveItemTN(37215);
             // fin BPY

             // SBO 05/09/2006 : code sp�cif pour Encaissement de masse Direct NRJ
             if not EstSpecif('51206') then
               RemoveFromMenu (37590, False, stAExclure);

          end ;

      { Suivi fournisseurs }
      38 : begin
            if not Init then
            begin
              VH^.CCMP.LotCli := False;
              VH^.CCMP.LotFou := True;
            end ;
            if VH^.PaysLocalisation=CodeISOES then
            begin
              RemoveFromMenu(38100,TRUE,stAExclure) ;
              RemoveFromMenu(-38210,TRUE,stAExclure) ;
              RemoveFromMenu(38280,TRUE,stAExclure) ;
              RemoveFromMenu(38400,TRUE,stAExclure) ;
              // SBO 20/04/007 : ajout du menu pr�paration
              RemoveFromMenu(-38502,TRUE,stAExclure) ;//RemoveFromMenu(38502,FALSE,stAExclure) ;
              RemoveFromMenu(38505,FALSE,stAExclure) ;
              RemoveFromMenu(38545,FALSE,stAExclure) ;
              RemoveFromMenu(38560,FALSE,stAExclure) ;
              RemoveFromMenu(38565,FALSE,stAExclure) ;
              RemoveFromMenu(-7456,TRUE,stAExclure) ;
             end else
             begin
              RemoveFromMenu(-380100,TRUE,stAExclure) ;
             End ; //XVI 24/02/2005

             RemoveFromMenu(-38305,TRUE, stAExclure) ; // Pav� lots
             RemoveFromMenu(38210, False, stAExclure) ; // Emissions de bordereaux
             RemoveFromMenu(38290, False, stAExclure) ; // Emissions de bordereaux internationales
             RemoveFromMenu(38535, False, stAExclure) ; // Profil utilisateur
             RemoveFromMenu(38540, False, stAExclure) ; // Circuit validation d�caissement
             RemoveFromMenu(38550, False, stAExclure) ; // Saisie de tr�so

           //YMO 10/01/2006 FQ17118 Suppression aussi du menu "autres traitements"
         //  RemoveFromMenu(38555, False, stAExclure) ; // relev� de facture

           RemoveFromMenu(7526, False, stAExclure) ; // Lettrage --> Ecart de conversion

           // BPY le 16/12/2003 => suppression des export CFONB a la demande de la FFF
           RemoveItemTN(38125);
           RemoveItemTN(38215);
           RemoveItemTN(38297);
           // fin BPY
           RemoveFromMenu(38600,TRUE, stAExclure) ; {JP 10/05/07 : anciens �tats}

           // SBO 05/09/2006 : code sp�cif pour Encaissement de masse Direct NRJ
           if not EstSpecif('51206') then
             RemoveFromMenu (38590, False, stAExclure);

           // BPY le 09/09/2004 : Fiche n� 14410 : suppression de l'export !
//           if (not Init) then RemoveFromMenu(38570,False,stAExclure); {JP 16/05/05 : FQ 15333}
           // Fin BPY

           // GP le 20/08/2008 : N� 22604
           RemoveFromMenu(38546, False, stAExclure) ; // Saisie de tr�so

           end ;

      { Tiers payeurs }
      39 : begin
             RemoveFromMenu(39200,TRUE, stAExclure) ; {JP 10/05/07 : anciens �tats}
          end ;

      { Structures et param�tres }
      17 :  begin
            //SDA le 27/12/2007
           {$IFNDEF TAXES}
             RemoveFromMenu (-50, False, stAExclure) ;
             RemoveFromMenu (1770, False, stAExclure) ;
             RemoveFromMenu (1775, False, stAExclure) ;
             RemoveFromMenu (1780, False, stAExclure) ;
             RemoveFromMenu (1790, False, stAExclure) ;
             RemoveFromMenu (1795, False, stAExclure) ;
             RemoveFromMenu (1800, False, stAExclure) ;
            {$ENDIF}
            //Fin SDA le 27/12/2007
            if VH^.PaysLocalisation<>CodeISOES then
               removeFromMenu(170329,FALSE,stAExclure) ; //XVI 24/02/2005
    //YMO FQ17149 08/02/2006 Remise en place menu ecritures
    //        RemoveFromMenu(-7352, True, stAExclure);

        {YMO FQ 17121 04&11/04/2006 Remise en place des menus  Vu avec IB
          RemoveFromMenu(-7115, False, stAExclure); // Modif en s�rie
        }
              RemoveFromMenu (1197, False, stAExclure); // Recopie des tables libres
              RemoveFromMenu (1526, False, stAExclure); // G�n�ration des tables libres � partir des sous-sections

              RemoveFromMenu(7240, False, stAExclure); // Modif en s�rie dates sur contrats en cours 28/03/06 YMO
              {JP 10/05/07 : vu avec OG et CA : on ouvre tout le menu banque
              RemoveFromMenu(1705, False, stAExclure);  // Etb bancaire
              RemoveFromMenu(1720, False, stAExclure);  // Code CFONB
              RemoveFromMenu(1725, False, stAExclure);  // Code AFB
              RemoveFromMenu(1730, False, stAExclure);  // Code r�sidents �trangers}
              RemoveFromMenu(1272, False, stAExclure);  // Param�trage mod�les banque
              RemoveFromMenu(1271, False, stAExclure);  // Documents / Etats libres / Budgets
// 13045        RemoveFromMenu(1175, False, stAExclure);  // Param�trage TPF

              {JP 12/08/05 : FQ 16458 : Dans la mesure o� le reste a �t� activ� depuis la V6,
                             il n'y a pas de raison d'exclure le param�trage
              If Not EstSerie(S3) Then
                begin
                If Not EstSpecif('51192') Then RemoveFromMenu(1266, False, stAExclure); // Lettres virements
                end;}
              //YMO 18/10/2006 FQ17128 menus supprim�s dans "Structures et para - structures - Impressions"
              //(vu avec OG le 18/10/2006)
              RemoveFromMenu(-23, False, stAExclure);  // Impressions
              RemoveFromMenu(-22, False, stAExclure);
     //         RemoveFromMenu(-1280, False, stAExclure); // Editions param�trables
// 13045        RemoveFromMenu(1191, False, stAExclure); // Qualifiant Qte
              { d�j� supprim� YMO 11/01/2006 FQ17150 suppression du menu Banque
              If Not VH^.OldTeletrans Then RemoveFromMenu(1700, True, stAExclure); // ETEBAC
              }
            RemoveFromMenu(1315, False, stAExclure); // Plans r�f�rence
            //FP 25/04/2006 FQ17902 RemoveFromMenu(-9, False, stAExclure);   // Compte correspondance
            RemoveFromMenu(-10, False, stAExclure);  // Plan de rupture �dition
            RemoveFromMenu(1425, False, stAExclure); // libell� automatiques
            RemoveFromMenu(-11, False, stAExclure);  // Param�tres / Analytique
            RemoveFromMenu(-12, False, stAExclure);  // Param�tres / Etapes r�glement
            RemoveFromMenu(-1426, False, stAExclure); // Compte de regroupement
// 13045      RemoveFromMenu(1198, False, stAExclure); //Synchro Table Libre
            RemoveFromMenu(1750, False, stAExclure); // Multi dossier
            {JP 02/11/04 : Les r�visions n'ont rien � faire dans CCMP}
            RemoveFromMenu(54700, True, stAExclure);

            //YMO 10/01/2005 FQ17152 1 menu �t� de "�tats libres"
            RemoveFromMenu(1271, False, stAExclure); // Budget

            //YMO 10/01/2005 FQ17151 3 menus �t�s de "�ditions param�trables"
            RemoveFromMenu(1291, False, stAExclure); // Compte de r�sultat
            RemoveFromMenu(1292, False, stAExclure); // Bilan
            RemoveFromMenu(1293, False, stAExclure); // S.I.G

            if not EstComptaTreso then begin
              RemoveFromMenu (1706, False, stAExclure); // Agences bancaires
              RemoveFromMenu (1707, False, stAExclure); // Comptes bancaires
            end;
            {$IFDEF EAGLCLIENT}
            if not GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then
              RemoveFromMenu (1266, False, stAExclure); // Lettres pr�l�vements
            if not GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then
              RemoveFromMenu (1267, False, stAExclure); 
            if not GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then
              RemoveFromMenu (1268, False, stAExclure);
            if not GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then
              RemoveFromMenu (1269, False, stAExclure); // Lettres virements
            RemoveFromMenu (1235, False, stAExclure);   // Comptabilit� // Lettres de relances
            RemoveFromMenu (1240, False, stAExclure);   // Comptabilit� // Relev�s de factures
            RemoveFromMenu (1245, False, stAExclure);   // Comptabilit� // Relev�s de comptes
            {$ENDIF}
            { MODIF BVE 16/01/2007
            //YMO 11/01/2006 FQ17150 suppression du menu Banque
            RemoveGroupTN(1700,TRUE) ; // YMO
            END MODIF BVE 16/01/2007 }
            {JP 18/04/07 : On autorise maintenant
            RemoveFromMenu(-14100, False, stAExclure); JP 22/02/06 : Bons � payer : retrait du bouton
            RemoveFromMenu(-14100, True , stAExclure); JP 22/02/06 : Bons � payer : retrait des sous-menus}

            // suppression Param�trage multisoc
            RemoveFromMenu (1755, false, stAExclure) ;
            if not EstMultiSoc then
              begin
              RemoveFromMenu (1765, False, stAExclure) ;
              end ;

            end ;
      { Outils et administration }
      18 :  begin
            RemoveFromMenu(3125, True, stAExclure);
            RemoveFromMenu(-3240, True, stAExclure);
            RemoveFromMenu(-3200, True, stAExclure);
            if not VH^.OkModMultilingue
             then RemoveFromMenu (3100, True, stAExclure); // Menu installation // 14693
            //c'est le dernier module charg�, on annule donc l'initialisation
            Init := false ;
{ // FINALEMENT LES FAVORIS NE SONT PAS ACTIVES POUR CCMP
            // Ouverture du menu pour outils pour les favoris
            RemoveFromMenu (3205, False, stAExclure);
            RemoveFromMenu (3210, False, stAExclure);
            RemoveFromMenu (3215, False, stAExclure);
            RemoveFromMenu (3220, False, stAExclure);
            RemoveFromMenu (3221, False, stAExclure);}
            end;
    end;
  end;
end;

function OnChangeUser : Boolean;
begin
  Result := CHARGEMAGHALLEY;
end;

Procedure LanceEtatLibreS5 ;
Var CodeD : String ;
BEGIN
if (VH^.CCMP.LotCli) then CodeD:=Choisir('Choix d''un �tat libre','MODELES','MO_CODE || " " || MO_LIBELLE','MO_CODE','MO_NATURE="UCO" AND MO_CODE LIKE "C%"','')
                     else CodeD:=Choisir('Choix d''un �tat libre','MODELES','MO_CODE || " " || MO_LIBELLE','MO_CODE','MO_NATURE="UCO" AND MO_CODE LIKE "F%"','') ;
if CodeD<>'' then LanceEtat('E','UCO',CodeD,True,False,False,Nil,'','',False) ;
END ;

Procedure Dispatch ( Num : Integer ; PRien : THPanel ; Var RetourForce,FermeHalley : boolean );
BEGIN
  case Num of
    6 : ;
    10 : BEGIN
      UpdateComboslookUp ;
      ChargeHalleyUser ;
      TripoteStatus ;
      InitTableTemporaire('') ;
      ChargeNoDossier; {JP 31/07/06 : Chargement de NoDossier en PGE}
      VH^.GereSousPlan:=FALSE ;
    END ;
    11 : ; // Apr�s d�connexion
    12 :
        // Interdiction de lancer en direct
        {$IFNDEF EAGLCLIENT}
        if (Not V_PGI.RunFromLanceur) and (V_PGI.ModePCL='1') then
        begin
          FMenuG.FermeSoc;
          FMenuG.Quitter;
          exit;
        end
        {$ENDIF}
        ;
    13 : ;
    15 : ;
    16 : begin
         // SBO 03/07/2007 : ajout des code specif compta en base
         V_PGI.Specif := V_PGI.Specif + ',' + GetParamSocSecur('SO_CPCODESPECIF', '', True) ;
         end;
    100 : ;

//=============================
//==== Suivi clients (37)  ====
//=============================
    370101 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=MPF') ; //Mise en portefeuille
    370102 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=REC') ; //Remise � e'encaissement
    370103 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=REE') ; //Remise � l'escompte
    370104 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=COC') ; //Confirmation rem8ise encaissement
    370105 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=COE') ; //Confirmation remise escompte
    370106 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=IMC') ; //Impay� remise encaissement
    370107 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=IME') ; //Impay� remise escompte
    370108 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=PIM') ; //r�glement impay�
    370109 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=RNG') ; //Re-negotation
    370110 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=ENC') ; //Encaissement directe
    370111 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=RJC') ; //Reject remise encaissement
    370112 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=RJE') ; //Reject remise escompte
    370113 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=ENC;OPERATION=FUS') ; //Fusion traites. //XVI 24/02/2005
    // Traites
    37105 : SuivAcceptation(prClient);     // Suivi acceptation
    37108 : SelectSuiviMP(smpEncTraEdt) ; // Pr�paration lettres traites client
    37110 : GenereSuiviMP(smpEncTraEdtNC);// G�n�ration Lettres-traite clients
    37115 : GenereSuiviMP(smpEncTraEdt) ; // G�n�ration Lettres-traite clients
    7596  : ExportCFONBBatch(False,False,tslTraite); // R�-�dition
    37120 : SaisieEffet(OnEffet) ;
    37124 : SelectSuiviMP(smpEncTraPor) ; // Pr�paration mise en portefeuille client
    37125 : GenereSuiviMP(smpEncTraPor) ; // Mise en portefeuille traite accept�e
    37129 : SelectSuiviMP(smpEncTraEnc) ; // Pr�paration encaissement traite client
    37130 : GenereSuiviMP(smpEncTraEnc) ; // Encaissement traites clients Voir le smpEncTraBqe
    37134 : SelectSuiviMP(smpEncTraEsc) ; // Pr�paration escompte traite client
    37135 : GenereSuiviMP(smpEncTraEsc) ; // Eescompte traites clients
    37137 : SelectSuiviMP(smpEncTraBqe) ; // Preparation remise en banque traites
    37138 : GenereSuiviMP(smpEncTraBqe) ; // Remise en banque traites clients
    37140 : ExportCFONBMP(smpEncTraEsc) ; // Export cfong traite escompte
    37145 : ExportCFONBMP(smpEncTraEnc) ; // Export cfong traite encaissement

    // Pr�l�vements
    37203 : SelectSuiviMP(smpEncPreEdt) ;   // Pr�paration lettre pr�l�vements
    37205 : GenereSuiviMP(smpEncPreEdtNC);  // Edition des lettres-pr�l�vement
    37204 : GenereSuiviMP(smpEncPreEdt) ;   // Edition et comptabilisation des lettres-pr�l�vement
    37207 : SelectSuiviMP(smpEncPreBqe) ;   // Comptabilisation pr�l�vement // Pr�paration
    37208 : GenereSuiviMP(smpEncPreBqe) ;   // Comptabilisation pr�l�vement // Comptabilisation
    37210 : ;                               // Emissions de bordereaux clients
    37215 : ExportCFONBMP(smpEncPreBqe) ;   // Export CFONB

    // Ch�ques
    37250 : SaisieEffet(OnChq) ;          // Saisie des ch�ques en portefeuille
    37251 : SelectSuiviMP(smpEncChqPor) ; // Mise en portefeuille // Pr�paration
    37252 : GenereSuiviMP(smpEncChqPor) ; // Mise en portefeuille // Remise
    37253 : SelectSuiviMP(smpEncChqBqe) ; // Remise � l'encaissement // Pr�paration
    37254 : GenereSuiviMP(smpEncChqBqe) ; // Remise � l'encaissement // Remise
    37256 : ;                             // Emission de bordereaux

    // Cartes bleues
    37260 : SaisieEffet(OnCB) ;          // Saisie de cartes bleues en portefeuille
    37261 : SelectSuiviMP(smpEncCBPor) ; // Mise en portefeuille // Pr�paration
    37262 : GenereSuiviMP(smpEncCBPor) ; // Mise en portefeuille // Remise
    37263 : SelectSuiviMP(smpEncCBBqe) ; // Remise � l'encaissement // Pr�paration
    37264 : GenereSuiviMP(smpEncCBBqe) ; // Remise � l'encaissement // Remise
    37266 : ;                            // Emission de bordereaux

    // Gestion par lots
{$IFDEF EAGLCLIENT}
    // A FAIRE
{$ELSE}
    37305 : AffecteBanquePrevi(True,taCreat) ;  // Cr�ation d'un lot
    37310 : AffecteBanquePrevi(True,taModif) ;  // Modification d'un lot
    37312 : UpdateLibelleToutModele ;           // Suppression d'un lot
{$ENDIF}
//    37305 : AffecteBanquePrevi(True,taCreat) ;  // Cr�ation d'un lot
//    37310 : AffecteBanquePrevi(True,taModif) ;  // Modification d'un lot
//    37312 : UpdateLibelleToutModele ;           //Suppression lot
    37315 : GenereSuiviMP(smpEncTous)   ;       // Encaissements

    // Lettrage
    7508 : LanceLettrageMP(prClient);             // Lettrage manuel
    7511 : LanceDeLettrageMP(prClient);           // D�lettrage
    7514 : RapprochementAutoMP('','',prClient);   // Lettrage automatique
    7520 : RegulLettrageMP(True,False,prCLient);  // R�gularisation de lettrage
    7523 : RegulLettrageMP(False,False,prCLient); // Diff�rence de change
    7524 : RegulLettrageMP(False,True,prCLient);  // Ecart de conversion

    // Relances clients
    37405 : RelanceClient(True,True) ;    // relance manuelle sur traites
    37410 : RelanceClient(True,False) ;   // relance manuelle sur autres modes paiement
    37415 : RelanceClient(False,True) ;   // relance auto sur traites
    37420 : RelanceClient(False,False) ;  // relance auto sur autres modes paiement
    7583  : CalculScoring ;

    7598  : LanceCoutTiers('',0) ;  //YMO 03/07/2006 FQ 17850 Menu Estimation des co�ts financiers dispo en CWAS

    // Editions
    37515 : AGLLanceFiche('CP', 'EPECHEANCIER','','ECH','ECH'); //FQ17255 YMO 06/01/2005
    37520 : CPLanceFiche_JustSold(smpEncTous);// JustSolde(smpEncTous) ; Lek 190106
    37525 : CPLanceFiche_BalanceAgee;
    37530 : CPLanceFiche_BalanceVentilee;  // Balance ventil�e
    37531 : AGLLanceFiche('CP', 'SUIVICLIENT', '', '', ''); // Statistiques

    // Autres traitemens
    37501 : SelectSuiviMP(smpEncDiv);                         // Pr�paration Encaissements divers // SBO 20/04/007 : ajout du menu pr�paration
    37502 : GenereSuiviMP(smpEncDiv);                         // Comptabilisation Encaissements divers
    37505 : ExportCFONBBatch(False,True,tslAucun);            // Emissions de bordereaux banque
    37510 : ModifEcheMP;                                      // Modifications des �ch�ances
    37535 : AGLLanceFiche('CP', 'PROFILUSER', '', '', 'CLI'); // Profils utilisateur
    37545 : ExportCFONBBatch(True,True,tslAucun,smpEncTous);  // Export CFONB
    37550 : SaisieEffet(OnBqe,srCli);                         // Saisie de tr�sorerie - SUPPRIME
    37555 : ReleveFacture;                                    // Relev�s de factures - SUPPRIME
     7589 : ReleveCompte;                                     // Relev� de compte

    37560 : CPLanceFiche_MulEncaDeca ( '', '', 'FLUX=ENC' ) ;                       // G�n�ration des enca/deca
    37565 : CPLanceFiche_MulParamGener ( '', '', 'ACTION=MODIFICATION' ) ;  // Param�trage des sc�narios
    37570 : CP_LanceFicheExport('CLI;');{JP 02/05/05 : FQ 15333}
    37580 : SelectSuiviMP(smpCompenCli);         //FP 21/02/2006
    37585 : GenererCompensation(smpCompenCli);   //FP 21/02/2006
    37590 : CPLanceFiche_GenereEncaDeca( 'FLUX=ENC' ) ;
    // Etats libres
{$IFDEF EAGLCLIENT}
    7456 : LanceEtatLibreS5 ;
{$ELSE}
     7456 : LanceEtatLibreS5 ;
{$ENDIF}

//==================================
//==== Suivi fournisseurs (38)  ====
//==================================
    380101 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=DEC;OPERATION=MPF') ; //Mise en portefeuille
    380102 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=DEC;OPERATION=DEC') ; //Decaissement directe
    380103 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulEncaDeca('','','ACTION=MODIFICATION;Flux=DEC;OPERATION=FUS') ; //Fusion des traites //XVI 24/02/2005
    // B.O.R.
    38104 : SelectSuiviMP(smpDecBorEdt);   // Lettres-BOR // Pr�paration
    38105 : GenereSuiviMP(smpDecBorEdtNC); // Lettres-BOR // Edition des lettres BOR
    38110 : GenereSuiviMP(smpDecBorEdt);   // Lettres-BOR // Edition et comptabilisation des lettres-BOR
    7597  : ExportCFONBBatch(False,False,tslBOR); // R�-�dition
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
//    38210 :;                                // Emissions de bordereaux // SUPPRIME
    38215 : ExportCFONBMP(smpDecVirBqe) ;   // Export CFONB

    // Virements internationaux
    38282 : SelectSuiviMP(smpDecVirInEdt) ;   // Lettres-virement internationale // Pr�paration
    38286 : GenereSuiviMP(smpDecVirInEdtNC) ; // Lettres-virement internationale // Edition des lettres-virement internationale
    38283 : GenereSuiviMP(smpDecVirInEdt) ;   // Lettres-virement internationale // Edition et comptabilisation des lettres-virement internationale
    38284 : SelectSuiviMP(smpDecVirInBqe) ;   // Comptabilisation virement internationale // Pr�paration
    38285 : GenereSuiviMP(smpDecVirInBqe) ;   // Comptabilisation virement internationale // Comptabilisation
//    38290 : ;                                 // Emissions de bordereaux // SUPPRIME
    38297 : ExportCFONBMP(smpDecVirInBqe) ;   // Export CFONB

    17141 : CpLanceFiche_TypeVisaMul;
    17142 : CpLanceFiche_CircuitMul;
    17143 : CpLanceFiche_MailsBAP('', '', '');

    11301 : CpLanceFiche_AffectationCircuit;
    11304 : CpLanceFiche_MulBap(tym_Modif);
    11308 : CpLanceFiche_MulBap(tym_Suivi);
    11312 : CpLanceFiche_MulBap(tym_Relance);
    11314 : CpLanceFiche_MulBap(tym_Suppression);
    11316 : CpLanceFiche_MulBap(tym_Purge);
    11318 : CpLanceFiche_MulBap(tym_Tous); {JP 24/03/07 : FQ 19949}
    11320 : CpLanceFiche_HistoriqueMail;

    // Gestion par lots
{$IFDEF EAGLCLIENT}
// A FAIRE
{$ELSE}
    38305 : AffecteBanquePrevi(False,taCreat) ;  // Cr�ation d'un lot
    38310 : AffecteBanquePrevi(False,taModif) ;  // Modification d'un lot
    38311 : SuivBAP ; // Bons � payer
    38312 : ; //Suppression lot - SUPPRIME
{$ENDIF}
    38315 : GenereSuiviMP(smpDecTous);          // D�caissements

    // Ch�ques
    38408 : SelectSuiviMP(smpDecChqEdt);   // Lettres-ch�ques // Pr�paration lettre ch�que
    38409 : GenereSuiviMP(smpDecChqEdtNC); // Lettres-ch�ques // Edition des lettres-ch�que
    38410 : GenereSuiviMP(smpDecChqEdt);   // Lettres-ch�ques // Edition et comptabilisation des lettres-ch�que

    // Lettrage
    7509 : LanceLettrageMP(prFournisseur);             // Lettrage manuel
    7512 : LanceDeLettrageMP(prFournisseur);           // D�lettrage
    7515 : RapprochementAutoMP('','',prFournisseur);   // Lettrage automatique
    7521 : RegulLettrageMP(True,False,prFournisseur);  // R�gularisation de lettrage
    7525 : RegulLettrageMP(False,False,prFournisseur); // Diff�rence de change
    7526 : RegulLettrageMP(False,True,prFournisseur);  // Ecart de conversion

    // Editions

    38515 : AGLLanceFiche('CP', 'EPECHEANCIER','','ECH','ECH'); // Ech�ancier  //FQ17255 YMO 06/01/2005
    7550 : CPLanceFiche_CPTGLAge;// GLivreAge ; Lek remplace 190106
    7559 : CPLanceFiche_CPTGLVentil;// GLVentile ; Lek remplace 190106
    7560 : CPLanceFiche_CPGLAUXI('');//GLAuxiliaireL;     // Grand-livre auxiliaire en situation
    38520 : CPLanceFiche_JustSold(smpDecTous);// JustSolde(smpDecTous); Lek 190106                       // Justificatif de solde
    38525 : CPLanceFiche_BalanceAgee;                     // Balance �g�e
    38530 : CPLanceFiche_BalanceVentilee;                 // Balance ventil�e
    38531 : AGLLanceFiche('CP', 'SUIVIFOU', '', '', '');  // Statistiques

    // Autres traitements
    38501 : SelectSuiviMP(smpDecDiv);                              // Pr�paration D�caissements divers // SBO 20/04/007 : ajout du menu pr�paration
    38502 : GenereSuiviMP(smpDecDiv);                              // Comptabilisation D�caissements divers
    38505 : ExportCFONBBatch(False,FALSE,tslAucun);                // Emission borderau banque
    38510 : ModifEcheMP;                                           // Modification d'�ch�ances
{$IFDEF EAGLCLIENT}
// A FAIRE
{$ELSE}
    38535 : AGLLanceFiche('CP', 'PROFILUSER', '', '', 'FOU');      // Profils utilisateurs
{$ENDIF}
//    38540 : ;// SUPPRIME                                         // Circuit Validation d�caissement
    38545 : ExportCFONBBatch(True,False,tslAucun);  // Export CFONB // If LikeS3 vir� YMO 26/01/2006
    38546 : CP_LanceFicheMulCFONB(''); {Export param�trable}
    38550 : SaisieEffet(OnBqe,srFou);                              // Saisie de tr�sorerie
    38555 : ReleveFacture;                                         // Relev�s de factures
//    7589 : ReleveCompte; // Voir Suivi clients
    38560 : CPLanceFiche_MulEncaDeca ( '', '', 'FLUX=DEC' ) ;                       // G�n�ration des enca/deca
    38565 : CPLanceFiche_MulParamGener ( '', '', 'ACTION=MODIFICATION' ) ;  // Param�trage des sc�narios
    38570 : CP_LanceFicheExport('FOU;');{JP 02/05/05 : FQ 15333}
    38580 : SelectSuiviMP(smpCompenFou);         //FP 21/02/2006
    38585 : GenererCompensation(smpCompenFou);   //FP 21/02/2006
    38590 : CPLanceFiche_GenereEncaDeca( 'FLUX=DEC' ) ;

    // Etats libres
//    7456 :; // Voir Suivi clients

//========================
//==== Ecritures (9)  ====
//========================
    // Courantes
    7244 : MultiCritereMvt(taCreat,'N',False);                     // Saisie courante
    7005 : SaisieFolio(taModif);                                   // Saisie bordereau
    {JP 01/06/07 : FQ 20507 : branchement des saisies d'effets de r�glements}
    7245 : PrepareSaisTresEffet ;
    7247 : PrepareSaisTres ;

//========================
//==== Banques (17)  ====
//========================
    {JP 10/05/07 : Branchement de l'ensemble du menu banque : cf FQ 19536}
    1701 : LanceFicheIdentificationBancaire;
    1705 : if EstComptaTreso then TRLanceFiche_Banques('TR','TRCTBANQUE', '', '', '')
                             else FicheBanque_AGL('',taModif,0);
    1706 : TRLanceFiche_Agence('TR','TRAGENCE', '', '', '');
    1707 : TRLanceFiche_BanqueCP('TR','TRMULCOMPTEBQ','','','');
    1720 : ParamTable('ttCFONB',tacreat,500005,PRien);        // Codes CFONB
    1725 : ParamCodeAFB;                                 // Code AFB
    1730 : ParamTable('ttCodeResident',taCreat,500007,PRien) ;

{$IFDEF EAGLCLIENT}
{$ELSE}
    1732 : ParamTeletrans ;
{$ENDIF}

//==== Tiers payeurs (39)  ====
    // Editions
    39101 : CCLanceFiche_EPTIERSP('TFP');                         // Tiers factur� par payeur
    39102 : CCLanceFiche_EPTIERSP('TFA');                         // Tiers factur� avec payeur

    {--- Lek230106 Edition tiers payeurs}
    39103 : CPLanceFiche_CPTPAYEURFACTURE;{BrouillardTP ;}
    39104 : CPLanceFiche_BalAgeeTPayeur;  {BalanceAge2TP}
    39105 : CPLanceFiche_CPTPayeurGLAge;   {GLivreAgeTP ;}
    39106 : CPLanceFiche_BalVentilTPayeur; {BalVentilTP}
    39107 : CPLanceFiche_CPTPAYEURGLVENTIL; {GLivreVenilTP}

    7239 : CPLanceFiche_CPGeneEcrTP('', '', 'S'); {FQ20627  15.06.07  YMO Branchement menu G�n�ration manuelle sur TP}

//=======================================
//==== Structures et param�tres (17) ====
//=======================================
    {JP 28/10/05 : Mise ne place des QRS1}
    7133 : CPLanceFiche_PLANGENE('');     // Impression / Comptes g�n�raux
    7166 : CPLanceFiche_PLANAUXI('');     // Impression / Comptes auxiliaires
    7199 : CPLanceFiche_PLANSECT('', ''); // Impression / Sections analytiques
    7229 : CPLanceFiche_PLANJOUR('');     // Impression / Journaux

    // Structures
{$IFDEF EAGLCLIENT}
    7112 : CCLanceFiche_MULGeneraux('C;7106000');  // Comptes g�n�raux
    7145 : CPLanceFiche_MULTiers('C;7139000');     // Comptes auxiliaires   // 7145000 : Modification
    7178 : CPLanceFiche_MULSection('C;7172000');   // Sections analytiques  // 7175000,7178000 : Modification ; 7176000 : Assistant de cr�ation
    7211 : CPLanceFiche_MULJournal('C;7205000');   // Journaux              // 7208000,7211000 : Modification

    7117 : CPLanceFiche_ChgNatureGene;

    7118 : CCLanceFiche_MULGeneraux('S;7118000');  // Suppressions // Comptes g�n�raux
    7151 : CPLanceFiche_MULTiers('S;7151000');     // Suppressions // Comptes auxiliaires
    7184 : CPLanceFiche_MULSection('S;7184000');   // Suppressions // Sections analytiques
    7214 : CPLanceFiche_MULJournal('S;7214000');   // Suppressions // Journaux

    7124 : CCLanceFiche_MULGeneraux('F;7124000');  // Ouverture/Fermeture // Fermeture des g�n�raux
    7127 : CCLanceFiche_MULGeneraux('O;7127000');  // Ouverture/Fermeture // Ouverture des g�n�raux
    7157 : CPLanceFiche_MULTiers('F;7157000');     // Ouverture/Fermeture // Fermeture des auxiliaires
    7160 : CPLanceFiche_MULTiers('O;7160000');     // Ouverture/Fermeture // Ouverture des auxiliaires
    7190 : CPLanceFiche_MULSection('F;7190000');   // Ouverture/Fermeture // Fermeture des sections
    7193 : CPLanceFiche_MULSection('O;7193000');   // Ouverture/Fermeture // Ouverture des sections
    7220 : CPLanceFiche_MULJournal('F;7220000');   // Ouverture/Fermeture // Fermeture des journaux
    7223 : CPLanceFiche_MULJournal('O;7223000');   // Ouverture/Fermeture // Ouverture des journaux

    // Modifications en s�rie
// A FAIRE
{$ELSE}
    7112 : CCLanceFiche_MULGeneraux('C;7112000'); // Comptes g�n�raux
    7145 : CPLanceFiche_MULTiers('C;7145000');    // Comptes auxiliaires
    7178 : CPLanceFiche_MULSection('C;7178000');  // Sections analytiques
    7211 : CPLanceFiche_MULJournal('C;7205000');  // Journaux

    7117 : CPLanceFiche_ChgNatureGene;

    7118 : CCLanceFiche_MULGeneraux('S;7118000');  // Suppressions // Comptes g�n�raux
    7151 : CPLanceFiche_MULTiers('S;7151000');     // Suppressions // Comptes auxiliaires
    7184 : CPLanceFiche_MULSection('S;7184000');   // Suppressions // Sections analytiques
    7214 : CPLanceFiche_MULJournal('S;7214000');   // Suppressions // Journaux

    {JP 28/10/05 : Remplacement par les fiches AGL
    7133 : PlanGeneral('', false) ;             // Impressions // Comptes g�n�raux
    7166 : PlanAuxi('',False) ;                 // Impressions // Tiers
    7199 : PlanSection('','',FALSE) ;           // Impressions // Sections analytiques
    7229 : PlanJournal('',FALSE) ;              // Impressions // Journaux}


    7124 : CCLanceFiche_MULGeneraux('F;7124000');  // Ouverture/Fermeture // Fermeture des g�n�raux
    7127 : CCLanceFiche_MULGeneraux('O;7127000');  // Ouverture/Fermeture // Ouverture des g�n�raux
    7157 : CPLanceFiche_MULTiers('F;7157000');     // Ouverture/Fermeture // Fermeture des auxiliaires
    7160 : CPLanceFiche_MULTiers('O;7160000');     // Ouverture/Fermeture // Ouverture des auxiliaires
    7190 : CPLanceFiche_MULSection('F;7190000');   // Ouverture/Fermeture // Fermeture des sections
    7193 : CPLanceFiche_MULSection('O;7193000');   // Ouverture/Fermeture // Ouverture des sections
    7220 : CPLanceFiche_MULJournal('F;7220000');   // Ouverture/Fermeture // Fermeture des journaux
    7223 : CPLanceFiche_MULJournal('O;7223000');   // Ouverture/Fermeture // Ouverture des journaux

{$ENDIF}

    // 11/01/2006 YMO FQ17121 Activation des menus en CWAS  
    // Modifications en s�rie
    7115 : CCLanceFiche_MULGeneraux('SERIE;7115000'); // MulticritereCpteGene(taModifEnSerie);
    7148 : CPLanceFiche_MULTiers('SERIE;7148000');    // MultiCritereTiers(taModifEnSerie);
    7181 : CPLanceFiche_MULSection('SERIE;7181000');  // MulticritereSection(taModifEnSerie);



    // Soci�t�
{$IFDEF EAGLCLIENT}
    1104 : ParamSociete(False,'','SCO_PARAMETRESGENERAUX;SCO_CCMP','',RechargeParamSoc,ChargePageSoc,SauvePageSoc,InterfaceSoc,1105000) ;
    1105 : FicheAxeAna ('') ;
{$ELSE}
    1104 : ParamSociete(False,BrancheParamSocAVirer,'SCO_PARAMETRESGENERAUX;SCO_CCMP','',RechargeParamSoc,ChargePageSoc,SauvePageSoc,InterfaceSoc,1105000) ;
    1105 : FicheAxeAna ('') ;
{$ENDIF}

    1110 : FicheEtablissement_AGL(taModif) ;                      // Etablissements
    1120 : ParamTable('ttFormeJuridique',taCreat,1120000,PRien) ; // Tables // Formes juridiques
    1122 : ParamTable('ttCivilite',taCreat,1122000,PRien) ;       // Tables // Civilit�s
    1125 : ParamTable('ttFonction',taCreat,1125000,PRien) ;       // Tables // Fonctions des contacts
    1135 : OuvrePays ;                                            // Tables // Pays
    1140 : FicheRegion('','',False) ;                             // Tables // R�gion
    1145 : OuvrePostal(PRien) ;                                   // Tables // Codes postaux}
    1150 : FicheDevise('',tamodif,False) ;                        // Tables // Devises
    1155 : ParamTable('TTLANGUE',taCreat,1155000,PRien) ;  {JP 05/06/07 : FQ 20527 : ajout du menu dans CCMP}
    1165 : ParamTable('TTREGIMETVA',taCreat,1165000,PRien) ;      // Tables // R�gimes fiscaux
    1170 : ParamTvaTpf(true) ;                                    // Tables // TVA par r�gime fiscal
    1175 : ParamTvaTpf(false) ;                                   // Tables // TPF par r�gime fiscal
    1185 : FicheModePaie_AGL('');                                 // Tables // Modes de paiement
    1190 : FicheRegle_AGL('',FALSE,taModif) ;                     // Tables // Conditions de r�glements
    1191 : ParamTable('ttQualUnitMesure',taCreat,1190030,PRien) ; // Tables // Qualifiants des quantit�s
    1193 : ParamTable('ttNivCredit',taCreat,1190040,PRien) ;      // Tables // Niveaux de risque / Assurance cr�dit
    1194 : CPLanceFiche_ParamTablesLibres;  // Tables libres // Personalisation
    1195 : AGLModifLibelleChampLibre('','') ; // FQ 16256 SBO 01/08/2005
    1196 : CPLanceFiche_ChoixTableLibre;    // Tables libres // Saisie
    1198 : SynchroTaLi;                     // Tables libres // Synchronisation    
    1760 : CPLanceFiche_LiensEtab('','','') ;
    1765 : CPLanceFiche_LiensSociete('','','') ;

    {$IFDEF TAXES}
    1770 : YYLanceFiche_ModeleTaxe; //SDA le 12/02/2007
    1775 : YYLanceFiche_TypesTaxes; //SDA le 12/02/2007
    1780 : YYLanceFiche_ModeleCatRegime; //SDA le 12/02/2007
    1790 : YYLanceFiche_ModeleCatType; //SDA le 15/02/2007
    1795 : YYLanceFiche_CompteParCatTaxe; //SDA le 02/03/2007
    1800 : YYLanceFiche_Detailtaxes;//SDA le 26/02/2007
    {$ENDIF}

    // Param�tres
    1290 : YYLanceFiche_Exercice('0');                              // Exercice
{$IFDEF ADRESSE}
    1396 : YY_LanceParamAdresse;    // Gestion des adresses.
    1397 : YY_LanceSaisieAdresse;
{$ENDIF}
    //1300 : YYLanceFiche_Souche('CPT'); // Compteurs // Comptables
    //1301 : YYLanceFiche_Souche('REL'); // Compteurs // Relev�s
    1300 : YYLanceFiche_Souche('CPT','','ACTION=MODIFICATION;CPT'); //Compteurs
    1301 : YYLanceFiche_Souche('REL','','ACTION=MODIFICATION;REL'); //Compteurs
    170329 : if VH^.PaysLocalisation=CodeISOES then
                CPLanceFiche_MulParamGener('','','ACCTION=MODIF;') ; //Param�trage des sc�narii pour l'espagne. //XVI 24/02/2005

    1325 : CCLanceFiche_Correspondance('GE');	// Plan de correspondance G�n�raux
{b FP 25/04/2006 FQ17902}
    1330 : CCLanceFiche_Correspondance('AU');	// Plan de correspondance Auxiliaire
{e FP 25/04/2006}
//    1345 : CCLanceFiche_Correspondance('A1');	// Plan de correspondance Axe analytique 1 - SUPPRIME
//    1350 : CCLanceFiche_Correspondance('A2');	// Plan de correspondance Axe analytique 2 - SUPPRIME
//    1355 : CCLanceFiche_Correspondance('A3');	// Plan de correspondance Axe analytique 3 - SUPPRIME
//    1360 : CCLanceFiche_Correspondance('A4');	// Plan de correspondance Axe analytique 4 - SUPPRIME
//    1365 : CCLanceFiche_Correspondance('A5');	// Plan de correspondance Axe analytique 5 - SUPPRIME

//    1375 : PlanRupture('RUG');                // Plan de rupture des �ditions // Comptes g�n�raux - SUPPRIME
//    1380 : PlanRupture('RUT');                // Plan de rupture des �ditions // Comptes auxiliaires - SUPPRIME
//    1395 : PlanRupture('RU1');                // Plan de rupture des �ditions // Sections axe 1 - SUPPRIME
//    1400 : PlanRupture('RU2');                // Plan de rupture des �ditions // Sections axe 2 - SUPPRIME
//    1405 : PlanRupture('RU3');                // Plan de rupture des �ditions // Sections axe 3 - SUPPRIME
//    1410 : PlanRupture('RU4');                // Plan de rupture des �ditions // Sections axe 4 - SUPPRIME
//    1415 : PlanRupture('RU5');                // Plan de rupture des �ditions // Sections axe 5 - SUPPRIME

//    1425 : ParamLibelle ;                     // Libell�s automatiques - SUPPRIME

//    1450 : ParamPlanAnal('');  // Analytiques // Structures analytiques - SUPPRIME
//    1460 : ParamVentilType;    // Analytiques // Ventilations types - SUPPRIME

//    1485 : ParamEtapeReg(True,'',True);  // Etapes de r�glement // Etapes d'encaissement - SUPPRIME
//    1490 : ParamEtapeReg(False,'',True); // Etapes de r�glement // Etapes de d�caissement - SUPPRIME
//    1491 : CircuitDec;                   // Etapes de r�glement // Circuit de validation des d�caissements - SUPPRIME

    // Param�trage relance
    7574 : CCLanceFiche_ParamRelance('RTR');  // Param�tres de relance // Effets en retour d'acceptation - SUPPRIME
    7577 : CCLanceFiche_ParamRelance('RRG');  // Param�tres de relance // Autres modes en retard de r�glement - SUPPRIME

    // YMO 11/01/2006 FQ17149 Remise en place des 2 menus
    // Ecritures
{$IFDEF EAGLCLIENT}
    7352 : CPLanceFiche_MulGuide('','','');   // Guide - SUPPRIME (Remis 11/01/2006)
    7355 : CPLanceFiche_Scenario('','');      // Sc�nario - SUPPRIME (Remis 11/01/2006)
{$ELSE}
    7352 : CPLanceFiche_MulGuide('','',''); // ParamGuide('','NOR',taModif);  // Guide - SUPPRIME (Remis 11/01/2006) Resupprim� le 25/01/2006
    7355 : ParamScenario('','');          // Sc�nario - SUPPRIME (Remis 11/01/2006)
{$ENDIF}
    17420 : CPLanceFiche_MasqueMul('','','ACTION=MODIFICATION;CMS_TYPE=SAI') ; // SBO 09/07/2007 FQ20965 : mul des masques de saisie via dans CCMP


    // Banques
//    1705 : FicheBanque_AGL('',taModif,0);                  // Etablissements bancaires - SUPPRIME
//    1720 : ParamTable('ttCFONB',taCreat,0,PRien);          // Codes CFONB - SUPPRIME
//    1725 : ParamCodeAFB;                                 // Codes AFB - SUPPRIME
//    1730 : ParamTable('ttCodeResident',taCreat,0,PRien); // Codes r�sidents �trangers - SUPPRIME

    // Documents

    // Perso/Traduc
    {$IFDEF EAGLCLIENT}
    {$ELSE}
    1205 : ParamTraduc(TRUE,Nil) ;   // MODIF PACK AVANCE
    1210 : ParamTraduc(FALSE,NIL) ;  // MODIF PACK AVANCE
    {$ENDIF}

{$IFNDEF EAGLCLIENT}
// A FAIRE
    1235 : EditDocument('L','REL','',TRUE);             // Comptabilit� // Lettres de relances
{ FQ 19667 BVE 09.05.07
    1240 : EditDocument('L','RLV','RLV',FALSE);         // Comptabilit� // Relev�s de factures }
    1240 : EditDocument('L','RLV','RLV',FALSE);         // Comptabilit� // Relev�s de factures
{ END FQ 19967 }
    1245 : EditDocument('L','RLC','',True);             // Comptabilit� // Relev�s de comptes
{$ENDIF}
    1247 : EditEtat('E','SAI','',True,nil,'','');       // Comptabilit� // Editions en cours de saisie
    1248 : EditEtat('E','BAP','',True,nil,'','');       // Comptabilit� // Bons � payer

{$IFDEF EAGLCLIENT}
    1266 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLP', '',True, nil, '', 'Lettres pr�l�vements');
    1267 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLC', '',True, nil, '', 'Lettres ch�ques');
    1268 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLT', '',True, nil, '', 'Traites LCR / BOR');
    1269 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLV', '',True, nil, '', 'Lettres virements');
{$ELSE}
    1266 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLP', '',True, nil, '', 'Lettres pr�l�vements')
                                                               else EditDocument('L','LPR','',True) ;
    {JP 24/01/06 : FQ 17234 : G�n�rateur de documents ou d'�tats en fonction du ParamSoc}
    1267 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLC', '',True, nil, '', 'Lettres ch�ques')
                                                               else EditDocument('L','LCH','',True) ;
    1268 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLT', '',True, nil, '', 'Traites LCR / BOR')
                                                               else EditDocument('L','LTR','',True) ;
    {JP 04/06/07 : FQ 19416 : G�n�rateur de documents ou d'�tats en fonction du ParamSoc}
    1269 : if GetParamSocSecur('SO_CPDOCAVECETAT', True, True) then EditEtat('E', 'CLV', '',True, nil, '', 'Lettres virements')
                                                               else EditDocument('L','LVI','',True) ;
{$ENDIF}
    1257 : EditEtat('E','BOR','',True,nil,'','');       // Banque // Bordereaux d'accompagnement
    1270 : EditEtatS5S7('E','UCO','',True,nil,'','');  // Etats libres // Comptabilit�
    1271 : EditEtatS5S7('E','UBU','',True,nil,'','');  // Etats libres // Budget

    //YMO FQ17151 08/02/2006 Editions param�trables

    1280 : EditEtatS5S7('E','JDP','',TRUE,nil,'','') ; // Journal divisionnaire
    1281 : EditEtatS5S7('E','JAC','',TRUE,nil,'','') ; // Journal centralisateur
    1282 : EditEtatS5S7('E','JPE','',TRUE,nil,'','') ; // Journal p�riodique
    1283 : EditEtatS5S7('E','JAL','',TRUE,nil,'','') ; // Journal g�n�ral
    1284 : EditEtatS5S7('E','GLP','',TRUE,nil,'','') ; // Grand livre g�n�ral
    1285 : EditEtatS5S7('E','GLB','',TRUE,nil,'','') ; // Grand livre auxiliaire
    1286 : EditEtatS5S7('E','BGE','',TRUE,nil,'','') ; // Balance g�n�rale
    1287 : EditEtatS5S7('E','BAU','',TRUE,nil,'','') ; // Balance auxiliaire
    1288 : EditEtatS5S7('E','BVE','',TRUE,nil,'','') ; // Balance ventil�e
    1289 : EditEtatS5S7('E','JTA','',TRUE,nil,'','') ; // Tableau d'avancement

//==== Administrations / Outils (18) ====
    // Soci�t�
{$IFDEF EAGLCLIENT}
// A FAIRE
{$ELSE}
    3130 : GestionSociete(PRien,@InitSociete,NIL) ;
//    3140 : LanceAssistSO ;
    3145 : RecopieSoc(PRien,True) ;
    3155 : RAZSociete ;
{$ENDIF}

    // Utilisateurs et acc�s
    3165  : FicheUserGrp;                                      // Groupes d'utilisateurs
    3170  : BEGIN FicheUSer(V_PGI.User) ; ControleUsers ; END; // Utilisateurs
{$IFDEF EAGLCLIENT}
    60208 : GCLanceFiche_Confidentialite( 'YY','YYCONFIDENTIALITE','','','37;38;39;17;18;27'); // Gestion des droits d'acc�s
    3180  : ReseauUtilisateurs(False);                       // Utilisateurs connect�s
    3185  : VisuLog;                                         // Suivi d'activit�
    3195  : ReseauUtilisateurs(True);                        // Remise � z�ro connexions
{$ELSE}
    // FQ 14889 : SG6 29/10/2004 : Suppression du menu �criture (n�9) de la gestion des droits d'acc�s
    60208 : GCLanceFiche_Confidentialite( 'YY','YYCONFIDENTIALITE','','','37;38;39;17;18;27'); // Gestion des droits d'acc�s
    3180 : ReseauUtilisateurs(False) ;
    3185 : VisuLog ;
    3195 : ReseauUtilisateurs(True) ;
{$ENDIF}
    3172  : YYLanceFiche_ProfilUser;     // Restrictions utilisateurs
    3198 : AGLLanceFiche('CP', 'CPREINITFNCT', '', '', '');

    // Outils - SUPPRIME

    // Comptables - SUPPRIME

    //Menu Pop Compta
    25750 : MultiCritereMvt(taConsult,'N',False);   // Consultation des �critures
    25755 : OperationsSurComptes('','','') ;	    // Consultation des comptes
    25760 : ModifEcheMP;                            // Modification des �ch�ances
    25710 : CCLanceFiche_MULGeneraux('P;7112000');  // Comptes g�n�raux
    25720 : CPLanceFiche_MULTiers('P;7145000');     // Comptes auxiliaires
    25730 : CPLanceFiche_MULSection('P;7178000');   // Sections analytiques
    25740 : CPLanceFiche_MULJournal('P;7205000');   // Journaux
    25770 : ParamSociete(False,BrancheParamSocAVirer,'SCO_PARAMETRESGENERAUX;SCO_CCMP','',RechargeParamSoc,ChargePageSoc,SauvePageSoc,InterfaceSoc,1105000) ;
    4006 : AGLLanceFiche ('YY','YYDEFPRT','','','TYPE=E');
    else HShowMessage('2;?caption?;'+TraduireMemoire('Fonction non disponible : ')+';W;O;O;O;',TitreHalley,IntToStr(Num)) ;
  end ;
END ;

Procedure AfterProtec ( sAcces : String ) ;
BEGIN

  //Variable permettant de stipuler que nous sommes en phase d'initialisation.
  Init := True ;

  VH^.OkModCompta:=TRUE ;
  VH^.OkModImmo:=TRUE ;
  VH^.OkModEtebac:=FALSE ;
  VH^.OkModCPPackIFRS := False ; // Modif IFRS
  VH^.OkModCCMP:=(sAcces[1]='X') ;
  If Not VH^.OldTeleTrans Then VH^.OkModEtebac:=TRUE ;
  V_PGI.NbColModuleButtons:=1;
  V_PGI.NbRowModuleButtons:=6;

  if V_PGI.VersionDemo then begin
    //RR BS = BP if EstSerie(S3) then FMenuG.SetModules([37,38,17,18],[16,89,103,107])
                    FMenuG.SetModules([37,38,39,17,18],[16,89,78,103,107]) ;
    end
  else begin
    If VH^.OkModCCMP Then begin
      //RR BS = BP  if EstSerie(S3) then FMenuG.SetModules([37,38,17,18],[16,89,103,107])
                    FMenuG.SetModules([37,38,39,17,18],[16,89,78,103,107]) ;
      end
    else FMenuG.SetModules([17,18],[103,107]) ;
  end;
end;

procedure AssignLesZoom ;
BEGIN
{$IFDEF EAGLCLIENT}
ProcZoomEdt:=Nil ;
{$ELSE}
ProcZoomEdt:=ZoomEdtEtat ;
ProcCalcEdt:=CalcOLEEtat ;
{$ENDIF}
END ;

procedure RemoveGroupTN(i : Integer ; b : Boolean) ;
Var TN : TTreeNode ;
BEGIN
  FMenuG.OutLook.RemoveGroup(i,b);
  // A FAIRE : Voir si OK en eAgl
  TN:=GetTreeItem(FMenuG.TreeView,i) ;
  If TN<>NIL Then TN.Delete ;
END ;

Procedure RemoveItemTN(i : Integer) ;
Var HOI : THOutItem ;
    TN : TTreeNode ;
BEGIN
  HOI:=FMenuG.OutLook.GetItemByTag(i) ;
  If HOI<>NIL Then FMenuG.OutLook.RemoveItem(HOI) ;
  // A FAIRE : Voir si OK en eAgl
  TN:=GetTreeItem(FMenuG.TreeView,i);
  If TN<>NIL Then TN.Delete ;
END ;

procedure AfterChangeModule ( NumModule : integer ) ;
var
  stAExclure : string;
BEGIN
  UpdateSeries ;
  AssignLesZoom ;
  ChargeMenuPop(integer(hm19),FMenuG.DispatchX) ;
  if FMenuG.PopupMenu=Nil then FMenuG.PopUpMenu:=ADDMenuPop(Nil,'','') ;
(* JP 10/05/07 : Uniformisation
{$IFDEF EAGLCLIENT}
  // Supprime le menu Soci�t� du popup car la fonction AGL n'est pas encore port�e
  for i := 0 to FMenuG.PopupMenu.Items.Count-1 do begin
    if FMenuG.PopupMenu.Items[i].Tag = 25770 then begin
      FMenuG.PopupMenu.Items[i].Free;
      Break;
    end;
  end;
  UpdateModuleCCMP(NumModule) ;
{$ELSE}
  TripotageMenuModePGE ( [NumModule] , stAExclure ) ;
{$ENDIF}
*)
  TripotageMenuModePGE ( [NumModule] , stAExclure ) ;
  TripotageMenuInternat ( [NumModule] , stAExclure ) ; //SDA le 18/12/2007
end;

procedure AssignZoom ;
BEGIN
AssignLesZoom ;
ProcGetVH:=GetVH ;
ProcGetDate:=GetDate ;
{$IFDEF EAGLCLIENT}
// Nothing !
{$ELSE}
if Not Assigned(ProcZoomGene)    then ProcZoomGene    :=FicheGene    ;
if Not Assigned(ProcZoomTiers)   then ProcZoomTiers   :=FicheTiers   ;
if Not Assigned(ProcZoomSection) then ProcZoomSection :=FicheSection ;
if Not Assigned(ProcZoomJal)     then ProcZoomJal     :=FicheJournal ;
if Not Assigned(ProcZoomCorresp) then ProcZoomCorresp :=ZoomCorresp  ;
If Not Assigned(ProcZoomNatCpt)  Then ProcZoomNatCpt  :=FicheNatCpte ;
{$ENDIF}
END ;

procedure InitApplication ;
Var sDom : String ;
BEGIN
  AssignZoom ;
  FMenuG.OnDispatch:=Dispatch ;
  FMenuG.OnChangeModule:=AfterChangeModule ;
  FMenuG.OnChargeMag:=ChargeMagHalley ;
  FMenuG.OnAfterProtec:=AfterProtec ;
{$IFDEF EAGLCLIENT}
// Nothing !
{$ELSE}
  FMenuG.OnChangeUser := OnChangeUser;
{$ENDIF}

  FMenuG.OnMajAvant:=nil;
  FMenuG.OnMajApres:=nil;
  // Favoris D�sactiv�s pour CCMP
  // FMenuG.OnChargeFavoris := ChargeFavoris;
  FMenuG.SetModules([6],[]) ;
  FMenuG.SetPreferences(['Saisies'],False) ;
If CS3 Then
  BEGIN
  sDom:='00433010' ; //COMPTA
  VH^.SerProdCCMP  :='00037080' ;
  END Else
  BEGIN
  sDom:='00434010' ; //COMPTA
  VH^.SerProdCCMP  :='00035080' ;
  END ;

  if EstSerie(S7) Then begin
    sDom:='00434010' ;
    VH^.SerProdCCMP  :='00035080' ;
  end;
  FMenuG.SetSeria(sDom,[VH^.SerProdCCMP],['Suivi des r�glements']) ;
  {$IFDEF TESTSIC}
  {$IFDEF EAGLCLIENT}
  SaveSynRegKey('eAGLHost', 'CWAS-DEV3:80', true);
  FCegidIE.HostN.Enabled := false;
  {$ENDIF EAGLCLIENT}
  {$ENDIF TESTSIC}
END ;

procedure DispatchTT(Num : Integer; Action : TActionFiche; Lequel,TT,Range : String) ;
begin
  case Num of
//{$IFDEF EAGLCLIENT}
    1,7112 : FicheGene(Nil,'',LeQuel,Action,0);
    2,7145 : FicheTiers(Nil,'',LeQuel,Action,1) ;
    4,7211 : FicheJournal(Nil,'', Lequel,Action,0);

    // tables libres
    5 : begin
      if (not (pos('GENE',TT) = 0)) then FicheNatCpte(nil,'G0'+AnsiLastChar(TT),'',Action,1)
      else if (not (pos('SECT',TT) = 0)) then FicheNatCpte(nil,'S0'+AnsiLastChar(TT),'',Action,1)
      else if (not (pos('TIERS',TT) = 0)) then FicheNatCpte(nil,'T0'+AnsiLastChar(TT),'',Action,1)
      else FicheNatCpte(nil,'I0'+AnsiLastChar(TT),'',Action,1);
    end;

    // ???
    995 : ParamTable(TT,Action,0,Nil,9) ;   {choixext}
    997 : ParamTable(TT,Action,0,Nil,6) ;   {choixext}
    999 : ParamTable(TT,Action,0,Nil,3) ;   {choixcode ou commun}

    // Comptes de correspondance
    1325 : CCLanceFiche_Correspondance('GE');	// Plan de correspondance G�n�raux
    1330 : CCLanceFiche_Correspondance('AU');	// Plan de correspondance Auxiliaire

    // section
    71781 : FicheSection(nil,'A1',Lequel,Action,1);
    71782 : FicheSection(nil,'A2',Lequel,Action,1);
    71783 : FicheSection(nil,'A3',Lequel,Action,1);
    71784 : FicheSection(nil,'A4',Lequel,Action,1);
    71785 : FicheSection(nil,'A5',Lequel,Action,1);

    // compteur
    72111 : begin
      case Action of
        taCreat : YYLanceFiche_Souche('CPT','','ACTION=CREATION;CPT');
        taModif : YYLanceFiche_Souche('CPT','','ACTION=MODIFICATION;CPT');
        else YYLanceFiche_Souche('CPT','','ACTION=CONSULTATION;CPT');
      end;
    end;
(*{$ELSE}
    1 : FicheGene(Nil,'',LeQuel,Action,0) ;
    2 : FicheTiers(Nil,'',LeQuel,Action,1) ;
    4 : FicheJournal(Nil,'',Lequel,Action,0) ;
{$ENDIF}*)
    99999 : if VH^.PaysLocalisation=CodeISOES then //XVI 24/02/2005
               FicheCondRemiseESPCP(Lequel,Action) ;
  end ;
end ;

Procedure InitLaVariablePGI;
Begin
Apalatys:='CEGID' ;
Copyright:='� Copyright ' + Apalatys ;

  // 13584
  if ctxPCL in V_PGI.PGIContexte then V_PGI.PortailWeb := 'http://experts.cegid.fr/home.asp'
                                 else V_PGI.PortailWeb := 'http://utilisateurs.cegid.fr';

V_PGI.OutLook:=FALSE ;
V_PGI.VersionDemo:=True ;
V_PGI.VersionReseau:=True ;
V_PGI.MenuCourant:=0 ;
V_PGI.VersionDEV:=False;
V_PGI.ImpMatrix := True;
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
V_PGI.EuroCertifiee:=False ;
V_PGI.CegidAPalatys:=FALSE ;
V_PGI.CegidBureau:=TRUE ;
V_PGI.StandardSurDP:=True ;

If CS3 Then  V_PGI.LaSerie:=S3 Else V_PGI.LaSerie:=S5 ;

RenseignelaSerie(ExeCCMP) ;

ChargeXuelib ;

V_PGI.NoModuleButtons:=False ;
V_PGI.NbColModuleButtons:=1 ;
// Initialis� � Vrai par d�faut !
V_PGI.EnableTableToView := False ;

end;

{***********A.G.L.**************************************************************
Auteur  ...... : Sylvie DE ALMEIDA
Cr�� le ...... : 18/12/2007
Modifi� le ... :
Description .. : Gestion des modules Internat - pour �tre homog�ne avec CCS5
Mots clefs ... :
*******************************************************************************}
procedure TripotageMenuInternat ( const TNumModule : array of integer; var stAExclure : string );
var i, NumModule : integer;
begin

  for i := 0 to High(TNumModule) do
  begin
    NumModule := TNumModule[i];
    case NumModule of
      // =====================================================
      // === Suivi clients (37) et suivi fournisseurs (38) ===
      // =====================================================
      37 : begin
              //Belgique - export CFONB - CFONB est une norme fran�aise uniquement
              if VH^.PaysLocalisation<>CodeISOFR then
              begin
                RemoveFromMenu(37545,FALSE,stAExclure) ;
              end;
           end;
      38 : begin
              //Belgique - export CFONB - CFONB est une norme fran�aise uniquement
              if VH^.PaysLocalisation<>CodeISOFR then
              begin
                //Pour autres traitements
                RemoveFromMenu(-38545,TRUE,stAExclure) ;
                RemoveFromMenu(-38545,FALSE,stAExclure) ;
              end;
           end;
    end;
  end;
end;

Initialization
CS3:=FALSE ;
If Pos('MPS3',ParamStr(0))>0 Then CS3:=TRUE ;
  ProcChargeV_PGI :=  InitLaVariablePGI ;
end.



