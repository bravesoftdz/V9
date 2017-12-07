unit ULibEncaDecaESP;

interface

uses
  Hctrls
  ,Classes
  {$IFDEF EAGLCLIENT}
    ,UtileAGL    // Pour LanceEtatTob
    ,HPdfPrev    // pour gestion du spooler
   {$ELSE}
    ,db
    {$IFNDEF DBXPRESS} ,dbtables {$ELSE} ,uDbxDataSet {$ENDIF}
    ,EdtREtat    // Pour LanceEtatTob
    ,EdtRDoc     // Pour LanceDocumentSpool
    ,HPdfPrev    // pour gestion du spooler
    ,uPDFBatch   // pour gestion du spooler
  {$ENDIF}
  ,ParamSoc      // pour le GetParamSoc
  ,UTob
  ,HEnt1
  ,Ent1
  ,SysUtils
  ,ULibEcriture   // Pour fns de base sur tob �criture
  ,SaisComm       // Pour TSorteMontant
  ,Saisutil       // pour GetNewNumJal
  ,hmsgbox        // pour MessageAlerte
  ;

//====================================================
//=== Precision pour les Taux de Frais et Int�r�t ====
//--- Maximum 9 decimales....                     ----
//====================================================
Const
 CCB_NbrDecTauxInteret  = 6 ;
 CFR_NbrDecTauxFrais    = 6 ;

//XMG 20/04/04 d�but
//procedure AjouteChampsSuppDesGeneraux ( vTob : Tob ; Suff : String ) ;
//Procedure ChargeInfosGeneral( vTob : TOB ; Suff , ChampGeneral : String ) ;
//XMG 20/04/04 fin //on ne les utilise plus....
Function  TypeEncaDecaVersTypeFrais ( EncaDeca : String ) : String ;
Function  VerifieCoherenceSelection_ESP( TobOrigine, TobScenario : TOB ) : Boolean ;
Procedure EnregistreLesMontants ( vTobEcr : TOB ; ldbSolde : Double ; lDev : Rdevise ) ;
Function  ChercheEcritureFrais ( vTobFrais : Tob ; CFR_FRAISREMISE : String ) : Tob ;
Function PartieCommuneEcritureFrais_ESP (lTobEche, lTobScenario , vTobFrais : TOB ; idxFrais : Integer ; Suff : String ; vInfoEcr : TInfoEcriture) : Tob ; //XMG 20/04/04
Function  CalCuleMontantFrais_ESP (lDbMontant : Double ; lTobParamFrais : TOB ) : Double ;
procedure GenereFraisRemise_ESP (BaseFrais : Double ; lTobEche, lTobScenario , vTobFrais : TOB ; IdxFrais : integer ; VDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
Procedure CalculeFraisRemiseParType_ESP(lTobEche, TobScenario, vTobFrais : Tob ; ldbMontant : Double ; VDev : RDevise ; TypeFrais : String ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
procedure CalculeFraisRemise_ESP( lTobEche, TobScenario, vTobfrais : TOB ; vdev : RDevise ; Var vDbFraisGen : Double ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
procedure GenereContrepartieEcritureFrais_ESP(lTobEche,lTobScenario, vTobFrais : TOB ; vDev : RDevise ; idxFrais : integer ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
Procedure CalculeContrepartieFraisRemise_ESP(ltobEche, tobScenario, vTobFrais : TOB ; vdev : RDevise ; vInfoEcr : TInfoEcriture) ; //XMG 20/04/04
procedure GenereContrepartieEcritureRisque_ESP (lTobEche,TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
procedure GenereEcritureRisque_ESP (lTobEche, TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; dbMontantEche, dbMontantInt : Double ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
procedure CalculeEcritureRisque_ESP (lTobEche, TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
//Procedure GenereEtatsESP ( vTobGene, vTobScenario : TOB ; vBoBordereau : Boolean ) ; //XMG 20/04/04 � SUPPRIMER
procedure ChargeComplementExport ( vTobExp : TOB ; vStTable, vstchOrig, vStChDest : String ) ; //XMG 20/04/04

Procedure TerminePieceEncaDecaESP      ( vTobOrigine , vTobGene, vTobScenario : TOB ; vDev : RDevise ) ;
Procedure TermineAnalytiqueEncaDecaESP ( vTobGene, vTobScenario : TOB ; vDev : RDevise ) ;
Procedure RecopieInfosEcheanceESP      ( vTobOrigine , vTobGene : TOB ) ;
Procedure AffecteNumeroPieceNormal  ( vTobPiece : TOB ; vJournal : String ; vDateComptable : TDateTime ) ;



implementation

uses
  {$IFDEF MODENT1}
  CPProcGen,
  CPTypeCons,
  CPProcMetier,
  {$ENDIF MODENT1}
  uLibEncaDeca ;

//XVI 24/02/2005
Function TypeEncaDecaVersTypeFrais ( EncaDeca : String ) : String ;
Begin
  Result:='' ;
  if pos(';'+EncaDeca+';',';REC;REE;')>0 then Result:='REM' else  //remises Banque
  if pos(';'+EncaDeca+';',';RJC;RJE;')>0 then Result:='REJ' else  //Rejet remise
  if pos(';'+EncaDeca+';',';IMC;IME;')>0 then Result:='IMP' else  //Impay�
  if EncaDeca='RNG'                      then Result:='REL' ;     //Relancement Client
End ;

{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 08/04/2004
Modifi� le ... :   /  /    
Description .. : enregistre le montant dans la bonne zone (D�bit ou Cr�dit).
Suite ........ :
Suite ........ : Pour le D�bit le montant doit �tre positif
Suite ........ : Pour le cr�dit il doit �tre negatif
Mots clefs ... :
*****************************************************************}
Procedure EnregistreLesMontants ( vTobEcr : TOB ; ldbSolde : Double ; lDev : Rdevise ) ;
Begin
  if ldbSolde > 0 then
     CSetMontants(vTobEcr,ldbSolde,0,lDEV,false)
  else
     CSetMontants(vTobEcr,0,-ldbSolde,lDEV,false);
End ;

Function ChercheEcritureFrais ( vTobFrais : Tob ; CFR_FRAISREMISE : String ) : Tob ;
Begin
   Result:=vTobFrais.FindFirst(['CodeFrais'],[CFR_FRAISREMISE],FALSE) ;
   if not Assigned(Result) then
      Begin
      Result:=TOB.Create('ECRITURE PAR FRAIS',VtobFrais,-1) ;
      Result.AddChampsup('CodeFrais',FALSE) ;
      Result.PutValue('CodeFrais',CFR_FRAISREMISE) ;
      End ;
End ;

Function PartieCommuneEcritureFrais_ESP (lTobEche, lTobScenario , vTobFrais : TOB ; idxFrais : Integer ; Suff : String ; vInfoEcr : TInfoEcriture) : Tob ; //XMG 20/04/04
var lTobEcrFrais : TOB ; //Tob qui regroupe toutes les lignes de l'�criture d'un type concret
Begin
   lTobEcrFrais:=ChercheEcritureFrais(vTobFrais,lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_FRAISREMISE')) ;
   Result:= TOB.Create('ECRITURE', ltobEcrFrais, -1 ) ;
   Result.InitValeurs ;
   CPutDefautEcr( Result) ;
   //XMG 20/04/04 d�but
   vInfoEcr.LoadCompte( lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_GENERAL'+Suff) );
   vInfoEcr.LoadAux( lTobEche.GetValue('E_AUXILIAIRE') ) ;
   // Compte de g�n�ration lettrable ?
   if ( vInfoEcr.Compte_GetValue('G_LETTRABLE') = 'X') {or
      ( (lTobParamFrais.detail[0].GetValue('G_COLLECTIF'+Suff) = 'X') and (lTobEche.GetValue('E_ETATLETTRAGE') <> 'RI') )} //XMG (???)
     then CRemplirInfoLettrage( Result )
   // Compte de g�n�ration pointable ?
    else if vInfoEcr.Compte_GetValue('G_POINTABLE') = 'X'
            then CRemplirInfoPointage( Result ) ;
  // Compte ventilable
  if ( vInfoEcr.Compte_GetValue('G_VENTILABLE') = 'X')
   //XMG 20/04/04 fin
    then Result.PutValue('E_ANA', 'X')
    else begin
         Result.PutValue('E_ANA', '-') ;
         Result.ClearDetail ;
         end ;
    // Infos Sup pour gestion enca/d�ca
    {AjouteChampsSuppEcriture( Result ) ;
    Result.PutValue('ESTECHEORIG', '-' ) ;
    Result.PutValue('CLEECHEORIG', '' ) ;} //XMG il ne fallait pas, non????

   // Recopie des infos de l'�ch�ance d'origine
   RecopieInfosEcheanceESP ( lTobEche, Result ) ;

   // Comptes de contrepartie
   Result.PutValue('E_CONTREPARTIEGEN',      lTobScenario.Detail[0].GetValue('CCB_GENERAL') ) ; //La compte Banque
   Result.PutValue('E_CONTREPARTIEAUX',      '') ;

   // -------------------------------------------
   // -- Infos param�tr�s dans le le sc�nario  --
   // -------------------------------------------
   // G�n�ral / Auxiliaire
   //XMG 20/04/04 d�but
   Result.PutValue('E_GENERAL', vInfoEcr.StCompte ) ;
   if vInfoEcr.Compte_GetValue('G_COLLECTIF') = 'X'
     then Result.PutValue('E_AUXILIAIRE', vInfoEcr.StAux )
   //XMG 20/04/04 fin
     else Result.PutValue('E_AUXILIAIRE', '' ) ;

   // Journal
   Result.PutValue('E_JOURNAL',     lTobScenario.Detail[0].GetValue('CCB_JOURNAL') ) ;
   //Result.PutValue('E_JOURNAL',     lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_JOURNAL') ) ;

   // Exercice et Date
   Result.PutValue('E_EXERCICE',         QuelExoDT( lTobScenario.GetValue('DATECOMPTABLE') ) ) ;
   Result.PutValue('E_DATECOMPTABLE',    lTobScenario.GetValue('DATECOMPTABLE') ) ;
   Result.PutValue('E_PERIODE',          GetPeriode(lTobScenario.GetValue('DATECOMPTABLE') ) ) ;
   Result.PutValue('E_SEMAINE',          NumSemaine(lTobScenario.GetValue('DATECOMPTABLE') ) ) ;

   // Ref interne
   if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFINTERNE1') <> '' then
     Result.PutValue('E_REFINTERNE',   lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFINTERNE1') ) ;
   // Libelle
   if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE1') <> '' then
     Result.PutValue('E_LIBELLE',      lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE1') )
   else if trim(Result.GetValue('E_LIBELLE'))='' then
     Result.PutValue('E_LIBELLE',      lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE') ) ;
   // Ref externe
   if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFEXTERNE1') <> '' then
     Result.PutValue('E_REFEXTERNE',   lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFEXTERNE1') ) ;
   // Ref libre
   if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFLIBRE1') <> '' then
     Result.PutValue('E_REFLIBRE',     lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFLIBRE1') ) ;
End ;

{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 19/03/2004
Modifi� le ... :   /  /
Description .. : Calcule le montant des frais, en prenant en compte le
Suite ........ : minimum et la partie fixe, sur le montant pass�.....
Mots clefs ... :
*****************************************************************}
Function CalCuleMontantFrais_ESP (lDbMontant : Double ; lTobParamFrais : TOB ) : Double ;
Begin
 Result:=Arrondi(ldbMontant*arrondi(lTobparamFrais.GetValue('CFR_TAUXFRAIS')/100,CFR_NbrDecTauxFrais),V_PGI.OkdecV) ;
 if (Arrondi(lTobparamFrais.GetValue('CFR_FRAISMIN'),V_PGI.OkDecV)>0) and
    (Arrondi(lTobparamFrais.GetValue('CFR_FRAISMIN'),V_PGI.OkDecV)>Result) then Result:=Arrondi(lTobparamFrais.GetValue('CFR_FRAISMIN'),V_PGI.OkDecV) ;
 Result:=Arrondi(Result+lTobparamFrais.GetValue('CFR_FRAISFIXE'),V_PGI.OkDecV) ;
End ;

procedure GenereFraisRemise_ESP (BaseFrais : Double ; lTobEche, lTobScenario , vTobFrais : TOB ; IdxFrais : integer ; VDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var ldbFrais  : Double ; // Montant des Frais
    lTobEcr   : TOB ;    // Ligen de l'�criture .....
Begin
  ldbFrais:=CalculeMontantFrais_ESP(BaseFrais,lTobScenario.Detail[0].Detail[IdxFrais]) ;
  lTobEcr:=PartieCommuneEcritureFrais_ESP(ltobEche,lTobScenario,vtobFrais,IdxFrais,'FRAIS',vInfoEcr) ; //XMG 20/04/04
  // ------------------------
  // --  MAJ des montants  --
  // ------------------------
  EnregistreLesMontants ( lTobEcr,ldbFrais,Vdev);
 // CSetMontants( lTobEcr, ldbFrais, 0, vDev, True );
End ;

Procedure CalculeFraisRemiseParType_ESP(lTobEche, TobScenario, vTobFrais : Tob ; ldbMontant : Double ; VDev : RDevise ; TypeFrais : String ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var lInIdxFrais : Integer ;   // Index parcourt frais Remise (ESP)
Begin
  if (TobScenario.Detail.Count>0) then
     //Calculs des frais....
     For lInIdxFrais:=0 to TobScenario.Detail[0].Detail.count-1 do
        if TobScenario.Detail[0].detail[lInIdxFrais].GetValue('CFR_BASECALCUL')=TypeFrais then
           Begin
           //g�neration de la pi�ce des frais
           GenereFraisRemise_ESP(ldbMontant,lTobEche,TobScenario,vTobFrais,lInIdxFrais,vDev,vInfoEcr) ; //XMG 20/04/04
           End ;
End ;

{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 19/03/2004
Modifi� le ... :   /  /
Description .. : Calcule et g�n�re l'�criture comptable des frais (pour ceux
Suite ........ : qui doivent se calculer en d�tail....
Suite ........ :
Suite ........ : On cumule aussi le montant de l'�cheance pour les frais
Suite ........ : globales....
Mots clefs ... :
*****************************************************************}
procedure CalculeFraisRemise_ESP( lTobEche, TobScenario, vTobfrais : TOB ; vdev : RDevise ; Var vDbFraisGen : Double ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var ldbMontant  : Double ;    // Montant de l'�ch�ance....
Begin
  if (TobScenario.Detail.Count>0) then
     Begin
     ldbMontant:=GetLeMontant( lTobEche.GetValue('E_DEBITDEV')+lTobEche.GetValue('E_CREDITDEV'), lTobEche.GetValue('E_COUVERTUREDEV'),  lTobEche.GetValue('E_SAISIMP') ) ;
     vDbFraisGen:=Arrondi(vDbFraisGen+ldbMontant,V_PGI.OkDecV) ;            //On cumule les Montants des �cheances pour les frais globales...
     CalculeFraisRemiseParType_Esp(lTobEche,TobScenario,vTobFrais,ldbMontant,vDev,'TRA',vInfoEcr) ; //XMG 20/04/04
     End ;
End ;

procedure GenereContrepartieEcritureFrais_ESP(lTobEche,lTobScenario, vTobFrais : TOB ; vDev : RDevise ; idxFrais : integer ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var lTobEcr      : Tob ;    // Ligne de l'�criture en g�n�ration....
    lTobEcrFrais : TOB ;    //Tob qui regroupe toutes les lignes de l'�criture d'un type concret
    ldbSolde     : Double ; // Solde de l'�criture
    ldbMntTVA    : Double ; // Montant de la TVA
Begin
   if (lTobScenario.Detail.count>0) then
      begin
      lTobEcrFrais:=ChercheEcritureFrais(vTobFrais,lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_FRAISREMISE')) ;
      if (lTobEcrFrais.Detail.Count>0) then
         Begin
         ldbSolde:=Arrondi(lTobEcrFrais.SommeSimple('E_DEBITDEV',[''],[''],FALSE),V_PGI.OkDecV)
                  -Arrondi(lTobEcrFrais.SommeSimple('E_CREDITDEV',[''],[''],FALSE),V_PGI.OkDecV) ;
         //Calcule de la TVA
         if lTobScenario.Detail[0].Detail[IdxFrais].GetValue('CFR_TVA')<>'' then
            begin
            ldbMntTVA:=Ht2tva(ldbSolde,VH^.RegimeDefaut,FALSE,lTobScenario.Detail[0].Detail[IdxFrais].GetValue('CFR_TVA'),'',TRUE,V_PGI.OkDecV) ;
            if ldbMntTVA>0 then
               Begin
               lTobEcr:=PartieCommuneEcritureFrais_ESP(ltobEche,lTobScenario,vtobFrais,IdxFrais,'TVA',vInfoEcr) ; //XMG 20/04/04
               // ------------------------
               // --  MAJ des montants  --
               // ------------------------
               //CSetMontants( lTobEcr, ldbMntTVA, 0, vDev, True );
               EnregistreLesMontants (lTobEcr,ldbMntTVA,vDev) ;
               lTobEcr.PutValue('E_REGIMETVA',VH^.RegimeDefaut) ;
               lTobEcr.PutValue('E_TVA',lTobScenario.Detail[0].Detail[IdxFrais].GetValue('CFR_TVA')) ;
               lTobEcr.PutValue('E_TPF',lTobScenario.Detail[0].Detail[IdxFrais].GetValue('CFR_TVA')) ;
               End ;
            End ;
         ldbSolde:=Arrondi(lTobEcrFrais.SommeSimple('E_DEBITDEV',[''],[''],FALSE),V_PGI.OkDecV)
                  -Arrondi(lTobEcrFrais.SommeSimple('E_CREDITDEV',[''],[''],FALSE),V_PGI.OkDecV) ;
         if Arrondi(ldbSolde,V_PGI.OkDecV)<>0 then
            Begin
            lTOBEcr:= TOB.Create('ECRITURE', lTobEcrFrais, -1 ) ;
            lTOBEcr.InitValeurs ;
            CPutDefautEcr( lTobEcr) ;
            //XMG 20/04/04 d�but
            vInfoEcr.LoadCompte( lTobScenario.Detail[0].GetValue('CCB_GENERAL') );
            vInfoEcr.LoadAux(lTobEche.GetValue('E_AUXILIAIRE')) ;
            // Compte de g�n�ration lettrable ?
            if ( vInfoEcr.Compte_GetValue('G_LETTRABLE') = 'X') {or
               ( (lTobParamFrais.detail[0].GetValue('G_COLLECTIF'+Suff) = 'X') and (lTobEche.GetValue('E_ETATLETTRAGE') <> 'RI') )} //XMG (???)
              then CRemplirInfoLettrage( lTobEcr )
            // Compte de g�n�ration pointable ?
             else if vInfoEcr.Compte_GetValue('G_POINTABLE') = 'X'
                     then CRemplirInfoPointage( lTobEcr ) ;
            // Compte ventilable
            if ( vInfoEcr.Compte_GetValue('G_VENTILABLE') = 'X')
            //XMG 20/04/04 fin
              then lTobEcr.PutValue('E_ANA', 'X')
              else begin
                   lTobEcr.PutValue('E_ANA', '-') ;
                   lTobEcr.ClearDetail ;
                   end ;
             // Infos Sup pour gestion enca/d�ca
             {AjouteChampsSuppEcriture( lTobEcr ) ;
             lTobEcr.PutValue('ESTECHEORIG', '-' ) ;
             lTobEcr.PutValue('CLEECHEORIG', '' ) ;} //XMG il ne fallait pas, non????

            // Recopie des infos de l'�ch�ance d'origine
            RecopieInfosEcheanceESP ( lTobEche, lTobEcr ) ;

            // Comptes de contrepartie
            lTobEcr.PutValue('E_CONTREPARTIEGEN',      lTobScenario.GetValue('CPG_GENERAL') ) ; //lTobScenario.Detail[0].GetValue('CCB_GENERAL') ) ; //La compte Banque
            lTobEcr.PutValue('E_CONTREPARTIEAUX',      '') ;

            // -------------------------------------------
            // -- Infos param�tr�s dans le le sc�nario  --
            // -------------------------------------------
            // G�n�ral / Auxiliaire
            //XMG 20/04/04 d�but
            lTobEcr.PutValue('E_GENERAL', vInfoEcr.StCompte ) ;
            if vInfoEcr.Compte_GetValue('G_COLLECTIF') = 'X'
              then lTobEcr.PutValue('E_AUXILIAIRE', vInfoEcr.StAux )
            //XMG 20/04/04 fin
              else lTobEcr.PutValue('E_AUXILIAIRE', '' ) ;

            // Journal
            lTobEcr.PutValue('E_JOURNAL',     lTobScenario.Detail[0].GetValue('CCB_JOURNAL') ) ;
            //lTobEcr.PutValue('E_JOURNAL',     lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_JOURNAL') ) ;

            // Exercice et Date
            lTobEcr.PutValue('E_EXERCICE',         QuelExoDT( lTobScenario.GetValue('DATECOMPTABLE') ) ) ;
            lTobEcr.PutValue('E_DATECOMPTABLE',    lTobScenario.GetValue('DATECOMPTABLE') ) ;
            lTobEcr.PutValue('E_PERIODE',          GetPeriode(lTobScenario.GetValue('DATECOMPTABLE') ) ) ;
            lTobEcr.PutValue('E_SEMAINE',          NumSemaine(lTobScenario.GetValue('DATECOMPTABLE') ) ) ;

            // Ref interne
            if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFINTERNE1') <> '' then
              lTobEcr.PutValue('E_REFINTERNE',   lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFINTERNE1') ) ;
            // Libelle
            if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE1') <> '' then
              lTobEcr.PutValue('E_LIBELLE',      lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE1') )
            else if trim(lTobEcr.GetValue('E_LIBELLE'))='' then
              lTobEcr.PutValue('E_LIBELLE',      lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_LIBELLE') ) ;
            // Ref externe
            if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFEXTERNE1') <> '' then
              lTobEcr.PutValue('E_REFEXTERNE',   lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFEXTERNE1') ) ;
            // Ref libre
            if lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFLIBRE1') <> '' then
              lTobEcr.PutValue('E_REFLIBRE',     lTobScenario.Detail[0].Detail[idxFrais].GetValue('CFR_REFLIBRE1') ) ;
            // ------------------------
            // --  MAJ des montants  --
            // ------------------------
            //Invers�s.....
            EnregistreLesMontants (lTobEcr,-ldbSolde, vDev) ;
            //CSetMontants( lTobEcr, ldbCredit, ldbDebit, vDev, True );
            End ;
         End ;
      End ;
End ;                     // on equilibre la piece sur la monnais pivot


Procedure CalculeContrepartieFraisRemise_ESP(ltobEche, tobScenario, vTobFrais : TOB ; vdev : RDevise ; vInfoEcr : TInfoEcriture) ; //XMG 20/04/04
var lInIdxFrais : Integer ;   // Index parcourt frais Remise (ESP)
Begin
  if (TobScenario.Detail.Count>0) then
     //Calculs des frais....
     For lInIdxFrais:=0 to TobScenario.Detail[0].Detail.count-1 do
           //g�neration de la contrepartie des frais
           GenereContrepartieEcritureFrais_ESP(lTobEche,TobScenario,vtobFrais,vdev,lInIdxFrais,vInfoEcr) ; //XMG 20/04/04
End ;
{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 22/03/2004
Modifi� le ... :   /  /
Description .. : Pr�pare la ligne de l'�criture, soit pour le risque, soit pour
Suite ........ : l'int�r�t, de la deuxi�me �criture (celle du risque) pour les
Suite ........ : remise � l'escompte....
Mots clefs ... :
*****************************************************************}
Function PartieCommuneEcritureRisque_ESP (lTobEche, TobScenario, vTobRemEscompte : TOB ; Suff : String ; numRef : integer ; vInfoEcr : TInfoEcriture ) : Tob ; //XMG 20/04/04
Var LeSuffCompte : String ;
Begin
   Result:= TOB.Create('ECRITURE', vTobRemEscompte, -1 ) ;
   Result.InitValeurs ;
   CPutDefautEcr( Result) ;
   //XMG 20/04/04 d�but
   LeSuffCompte:=Suff ;
   if stricomp('BANQUE',pchar(LeSuffCompte))=0 then LeSuffCompte:='' ;
   vInfoEcr.LoadCompte( TobScenario.Detail[0].GetValue('CCB_GENERAL'+LeSuffCompte) );
   vInfoEcr.LoadAux(lTobEche.GetValue('E_AUXILIAIRE')) ;
   // Compte de g�n�ration lettrable ?
   if ( vInfoEcr.Compte_GetValue('G_LETTRABLE') = 'X') {or
      ( (TobScenario.detail[0].GetValue('G_COLLECTIF'+Suff) = 'X') and (lTobEche.GetValue('E_ETATLETTRAGE') <> 'RI') )} //XMG (???)
     then CRemplirInfoLettrage( Result )
   // Compte de g�n�ration pointable ?
    else if vInfoEcr.Compte_GetValue('G_POINTABLE') = 'X'
            then CRemplirInfoPointage( Result ) ;
   // Compte ventilable
   if ( vInfoEcr.Compte_GetValue('G_VENTILABLE') = 'X')
   //XMG 20/04/04 fin
     then Result.PutValue('E_ANA', 'X')
     else begin
          Result.PutValue('E_ANA', '-') ;
          Result.ClearDetail ;
          end ;
    // Infos Sup pour gestion enca/d�ca
    {AjouteChampsSuppEcriture( Result ) ;
    Result.PutValue('ESTECHEORIG', '-' ) ;
    Result.PutValue('CLEECHEORIG', '' ) ;} //XMG il ne fallait pas, non????
                               
   // Recopie des infos de l'�ch�ance d'origine
   RecopieInfosEcheanceESP ( lTobEche, Result ) ;

   // Comptes de contrepartie
   Result.PutValue('E_CONTREPARTIEGEN',      TobScenario.detail[0].GetValue('CCB_GENERAL') ) ; //La compte Banque
   Result.PutValue('E_CONTREPARTIEAUX',      '') ;

   // -------------------------------------------
   // -- Infos param�tr�s dans le le sc�nario  --
   // -------------------------------------------
   // G�n�ral / Auxiliaire
   //XMG 20/04/04 d�but
   Result.PutValue('E_GENERAL', vInfoEcr.StCompte ) ;
   if vInfoEcr.Compte_GetValue('G_COLLECTIF') = 'X'
     then Result.PutValue('E_AUXILIAIRE', vInfoEcr.StAux )
   //XMG 20/04/04 fin
     else Result.PutValue('E_AUXILIAIRE', '' ) ;

   // Journal
    Result.PutValue('E_JOURNAL',     TobScenario.detail[0].GetValue('CCB_JOURNAL') ) ;

    // Exercice et Date
    Result.PutValue('E_EXERCICE',         QuelExoDT( TobScenario.GetValue('DATECOMPTABLE') ) ) ;
    Result.PutValue('E_DATECOMPTABLE',    TobScenario.GetValue('DATECOMPTABLE') ) ;
    Result.PutValue('E_PERIODE',          GetPeriode(TobScenario.GetValue('DATECOMPTABLE') ) ) ;
    Result.PutValue('E_SEMAINE',          NumSemaine(TobScenario.GetValue('DATECOMPTABLE') ) ) ;

   // Ref interne
   if TobScenario.detail[0].GetValue('CCB_REFINTERNE'+inttostr(NumRef)) <> '' then
     Result.PutValue('E_REFINTERNE',   TobScenario.detail[0].GetValue('CCB_REFINTERNE'+inttostr(NumRef)) ) ;
   // Libelle
   if TobScenario.detail[0].GetValue('CCB_LIBELLE'+inttostr(NumRef)) <> '' then
     Result.PutValue('E_LIBELLE',      TobScenario.detail[0].GetValue('CCB_LIBELLE'+inttostr(NumRef)) )
   else if trim(Result.GetValue('E_LIBELLE'))='' then
     Result.PutValue('E_LIBELLE',      TobScenario.Detail[0].GetValue('CCB_LIBELLE') ) ;
   // Ref externe
   if TobScenario.detail[0].GetValue('CCB_REFEXTERNE'+inttostr(NumRef)) <> '' then
     Result.PutValue('E_REFEXTERNE',   TobScenario.detail[0].GetValue('CCB_REFEXTERNE'+inttostr(NumRef)) ) ;
   // Ref libre
   if TobScenario.detail[0].GetValue('CCB_REFLIBRE'+inttostr(NumRef)) <> '' then
     Result.PutValue('E_REFLIBRE',     TobScenario.detail[0].GetValue('CCB_REFLIBRE'+inttostr(NumRef)) ) ;
End ;


{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 22/03/2004
Modifi� le ... :   /  /
Description .. : G�n�r� les lignes n�cessaires de l'�criture de risque par
Suite ........ : �ch�ance des remises � l'escompte.
Mots clefs ... :
*****************************************************************}
procedure GenereEcritureRisque_ESP (lTobEche, TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; dbMontantEche, dbMontantInt : Double ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var lTobEcr : Tob ; // Ligne de l'�criture en g�n�ration....
Begin

   if dbMontantEche<>0 then
      Begin
      lTobEcr:=PartieCommuneEcritureRisque_ESP(lTobEche,TobScenario,VTobRemEscompte,'RISQUE',1,vInfoEcr) ; //XMG 20/04/04
      // ------------------------
      // --  MAJ des montants  --
      // ------------------------
      EnregistreLesMontants (lTobEcr,-dbMontantEche,vDev) ;
      //CSetMontants( lTobEcr, 0, dbMontantEche, vDev, True );
      End ;

   if dbMontantInt<>0 then
      Begin
      lTobEcr:=PartieCommuneEcritureRisque_ESP(lTobEche,TobScenario,VTobRemEscompte,'INTERET',2,vInfoEcr) ; //XMG 20/04/04
      // ------------------------
      // --  MAJ des montants  --
      // ------------------------
      //CSetMontants( lTobEcr, dbMontantInt, 0, vDev, True );
      EnregistreLesMontants (lTobEcr, dbMontantInt,vDev) ;
      End ;
End ;

procedure GenereContrepartieEcritureRisque_ESP (lTobEche,TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
var lTobEcr   : Tob ;    // Ligne de l'�criture en g�n�ration....
    ldbSolde  : Double ; // Solde Total de l'�citure....
Begin
   if (TobScenario.Detail.count>0) and (vTobRemEscompte.Detail.Count>0) then
      Begin
      ldbSolde:=Arrondi(vTobRemEscompte.SommeSimple('E_CREDITDEV',[''],[''],FALSE),V_PGI.OkDecV)
               -Arrondi(vTobRemEscompte.SommeSimple('E_DEBITDEV',[''],[''],FALSE),V_PGI.OkDecV) ;

      if Arrondi(ldbSolde,V_PGI.OkDecV)<>0 then
         Begin
         lTobEcr:=PartieCommuneEcritureRisque_ESP(lTobEche,TobScenario,VTobRemEscompte,'BANQUE',3,vInfoEcr) ; //XMG 20/04/04
         // ------------------------
         // --  MAJ des montants  --
         // ------------------------
         EnregistreLesMontants ( lTobEcr,ldbSolde, vDev) ;
         //CSetMontants( lTobEcr, ldbDebit, ldbCredit, vDev, True );
         End ;
      End ;
End ;
{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 19/03/2004
Modifi� le ... :   /  /
Description .. : Calcule la partie �ch�ance de la deuxi�me
Suite ........ : �criture qui acompagne les remises � l'escompte (aussi
Suite ........ : connue comme l'�criture du risque.....)
Mots clefs ... :
*****************************************************************}
procedure CalculeEcritureRisque_ESP (lTobEche, TobScenario, vTobRemEscompte : TOB ; vDev : RDevise ; vInfoEcr : TInfoEcriture ) ; //XMG 20/04/04
Var ldbMontant  : Double ;    // Montant de l'�ch�ance....
    ldbInteret  : Double ;    // Montant Int�r�t
    lInNbrJours : Integer ;   // Nombre jours jusqu'� l'�ch�ance ....
    lInJoursAn  : Integer ;   // Nombre de jours de l'an (365 Naturel / 360 Commercial)
    lstEncaDeca : String  ;  //Type d'enca/Deca
Begin
  if (TobScenario.Detail.Count>0) then
     Begin
     lStEncaDeca:=TobScenario.GetValue('CPG_TYPEENCADECA') ;
     //G�n�ration de la pi�ce supplementaire des remises en Escompte.
     if (lStEncaDeca='IME') or    //IME.- Impay�, ...
        ((pos(';'+lStEncaDeca+';',';REE;RJE;')>0) and   //  ... REE.- Remise et RJE.- Rejet (toujours Escompte)
         ( (arrondi(TobScenario.detail[0].GetValue('CCB_TAUXINT'),CCB_NbrDecTauxInteret)>0) or
           (arrondi(TobScenario.detail[0].GetValue('CCB_INTERETMIN'),V_PGI.OkDecV)>0) ))       and
        (TobScenario.detail[0].GetValue('CCB_GENERALRISQUE')<>'')                                  then
        Begin
        ldbMontant:=GetLeMontant( lTobEche.GetValue('E_DEBITDEV')+lTobEche.GetValue('E_CREDITDEV'), lTobEche.GetValue('E_COUVERTUREDEV'),  lTobEche.GetValue('E_SAISIMP') ) ;
        //Ce montant on le passe au compte de Risque....

        if lStEncaDeca='IME' then
           Begin
           ldbInteret:=0 ;
           ldbMontant:=-ldbMontant ;
           end
        else
           Begin
           lInNbrJours:=lTobEche.GetValue('E_DATEECHEANCE')-TobScenario.GetValue('DATECOMPTABLE') ;

           if TobScenario.detail[0].GetValue('CCB_MODECALCULINT')='NAT' then lInJoursAn:=365 // An Natural
                                                                        else lInJoursAn:=360 ; // An Commercial

           ldbInteret:=Arrondi(ldbMontant*((arrondi(TobScenario.detail[0].GetValue('CCB_TAUXINT'),CCB_NbrDecTauxInteret)/lInJoursAn)*lInNbrJours),V_PGI.OkDecV) ;

           //Si Interet inferieur au ,minimum, on reprend le minimum....
           if (arrondi(TobScenario.detail[0].GetValue('CCB_INTERETMIN'),V_PGI.OkDecV)>0) and
              (arrondi(TobScenario.detail[0].GetValue('CCB_INTERETMIN'),V_PGI.OkDecV)>ldbInteret) then lDbInteret:=arrondi(TobScenario.detail[0].GetValue('CCB_INTERETMIN'),V_PGI.OkDecV) ;
           if lstEncaDeca='RJE' then
              begin
              ldbMontant:=-ldbMontant ;
              ldbInteret:=-ldbInteret ;
              end ;
           End ;
        //On g�n�re la ligne de l'int�r�t....
        if Arrondi(ldbMontant+lDBInteret,V_PGI.OkDecV)<>0 then
           GenereEcritureRisque_ESP(ltobeche,tobscenario,vTobRemEscompte,vdev,ldbMontant,ldbInteret,vInfoEcr) ; //XMG 20/04/04
        End ;
     End ;
End ;

{***********A.G.L.***********************************************
Auteur  ...... : X.Maluenda
Cr�� le ...... : 18/03/2004
Modifi� le ... : 19/03/2004
Description .. : Par rapport aux type d'Enca/Deca on fait les verifications
Suite ........ : n�cessaires....
Suite ........ : - Pour les remises (en g�n�ral), on verifie la coh�rence
Suite ........ : de la date des �ch�ances par rapport la date de r�f�rence
Suite ........ : et le nombre de hours minimum et maximum...
Suite ........ : - Seulement pour les remises � l'escompte, on verifie qu'on
Suite ........ : ne depasse pas le plafond de risque....
Mots clefs ... :
*****************************************************************}
Function  VerifieCoherenceSelection_ESP( TobOrigine, TobScenario : TOB ) : Boolean ;
var TypeEncaDeca                 : String ;
    idxOri,JMin,JMax             : integer ;
    PlafondEscompte,SoldeRisque  : Double ;
    DateRef                      : TDateTime ;
    qq                           : TQuery ;
begin
  Result:=FALSE ;
  TypeEncaDeca:=TobScenario.GetValue('CPG_TYPEENCADECA') ;
  if (pos(';'+TypeEncaDeca+';',';REC;REE;')>0) and                                                            //Si je suis en train de faire une remise....
     (TobScenario.Detail.Count=1)              and                                                            //.. et j'ai des conditions...
     ( (TobScenario.Detail[0].GetValue('CCB_NBREJMIN')+TobScenario.Detail[0].GetValue('CCB_NBREJMAX')>0)  or  //... et je dois verifier la date d'�ch�ance....
       ( (TypeEncaDeca='REE') and                                                                             //... ou C'est une Remise Escompte....
         (Arrondi(TobScenario.Detail[0].GetValue('CCB_PLAFOND'),V_PGI.OkDecV)>0))                             //... et J'ai un plafond � verifier....
     )                                                                                                        then  //...Alors....

       Begin
       SoldeRisque:=0 ;
       PlafondEscompte:=0 ;
       if (TypeEncaDeca='REE') then                                                       // Si Remise Escompte....
          Begin
          PlafondEscompte:=Arrondi(TobScenario.Detail[0].GetValue('CCB_PLAFOND'),V_PGI.OkDecV) ; //... je recup�re le Plafond
          //Recupere le solde courant.....
          QQ:=OpenSQL('select G_TOTALDEBIT-G_TOTALCREDIT from GENERAUX where G_GENERAL="'+TobScenario.Detail[0].GetValue('CCB_GENERAILRISQUE')+'"',TRUE) ;
          if not QQ.Eof then
             SOldeRisque:=QQ.Fields[0].AsFloat ;
          Ferme(QQ) ;
          End ;

       Jmin:=TobScenario.Detail[0].GetValue('CCB_NBREJMIN') ;
       Jmax:=TobScenario.Detail[0].GetValue('CCB_NBREJMAX') ;
       DateRef:=TobScenario.GetValue('DATECOMPTABLE') ; //Date de r�f�rence pour le calcule du nombre de jours...

       For idxOri:=0 to TobOrigine.Detail.Count-1 do
        Begin
        if (TypeEncaDeca='REE') and (PlafondEscompte>0) then
           begin
           SoldeRisque:=Arrondi(SoldeRisque+Toborigine.Detail[idxOri].GetValue('E_DEBIT')-Toborigine.Detail[idxOri].GetValue('E_DEBIT'),V_PGI.OkdecV) ;
           if SoldeRisque>PlafondEscompte then
               Begin
               PgiBox('On d�passe le plafond prevu pour les remises � l''escompte avec l''�criture XXXXX!') ;
               Exit ;
               end ;
           End ;
        if (Jmin>0) and (TobOrigine.Detail[idxOri].GetValue('E_DATEECHEANCE')-DateRef<Jmin) then
           begin
           PgiBox('l''�cart entre la date de comptabilisation et la date d''�ch�ance de l''�criture XXXXX est inferieur � l''�cart prevu!') ;
           Exit ;
           End ;
        if (JMax>0) and (TobOrigine.Detail[idxOri].GetValue('E_DATEECHEANCE')-DateRef>Jmin) then
           Begin
           PgiBox('l''�cart entre la date de comptabilisation et la date d''�ch�ance de l''�criture XXXXX est superieur � l''�cart prevu!') ;
           Exit ;
           End ;
        End ;
       End ;
  Result:=TRUE ;
End ;
//XMG 05/04/04 fin

//XMG 20/04/04 d�but
(*Procedure GenereEtatsESP ( vTobGene, vTobScenario : TOB ; vBoBordereau : Boolean ) ; //XMG 20/04/04
var lStNature   : String ;
    lStCode     : String ;
    lStSpooler  : String ;
    lApercu     : Boolean ;
    lTobEtat    : Tob ;
    lTobLigne   : Tob ;
    lTobRupt    : Tob ;
    i           : Integer ;
    lStRuptAuxi : String ;
    lDtRuptEche : TdateTime ;
    lTLReq      : TList ;
    lIndexDR    : Integer ;
    lIndexDF    : Integer ;
{$IFNDEF EAGLCLIENT}
    lStRep      : String ;
    lBoXFichier : Boolean ;
    lStRacine   : String ;
    lInSouche   : Integer ;
{$ENDIF EAGLCLIENT}
    lBoDialog   : Boolean ;
    lMontant    : Double ;
    lMontantDev : Double ;
    lSens       : Double ;
begin

  // Pas de pi�ces � �diter, pas d'�dition...
  if vTobGene.Detail.Count = 0 then
     Exit ;

  // Init param�tres
  if not vBoBordereau then
     begin
     lStNature   := vTobScenario.GetValue('CPG_ETATNATURE') ;
     lStCode     := vTobScenario.GetValue('CPG_MODELEENCADECA') ;
     lStRuptAuxi := vTobGene.Detail[ 0 ].GetValue('E_AUXILIAIRE') ;
     lDtRuptEche := vTobGene.Detail[ 0 ].GetValue('E_DATEECHEANCE') ;
     lBoDialog   := vTobScenario.getValue('CPG_MODELECHX') = 'X' ;
     end
   else
     Begin
     lStNature   := 'BOR' ;
     lStCode     := vTobScenario.GetValue('CPG_BORDEREAUMOD') ;
     lBoDialog   := vTobScenario.getValue('CPG_BORDEREAUCHX') = 'X' ;
     lStRuptAuxi := '' ;
     lDtRuptEche := idate1900 ;
     End ;

  lApercu     := vTobScenario.GetValue('APERCU')  = 'X' ;
  lIndexDR    := 1 ;
  lIndexDF    := 1 ;
  lMontant    := 0 ;
  lMontantDev := 0 ;
  lTobRupt    := nil ;

  // Co�ficient multiplicateur des montants <> pour ENC / DEC
  if vTobScenario.GetValue('CPG_FLUXENCADECA')='ENC'
     then lSens := -1.0
     else lSens := 1.0 ;

  // Gestion du spooler
  if vTobScenario.GetValue('SPOOLER') = 'X' then
    begin
    lStSpooler := vTobScenario.GetValue('REPSPOOLER') + '\' + lStCode + '.PDF' ;
    V_PGI.NoPrintDialog := True;
    V_PGI.QRPDF         := True;
    V_PGI.QRPDFQueue    := lStSpooler;
    V_PGI.QRPDFMerge    := lStSpooler;
    lApercu             := True ;
    end ;

  try
    // D�but du spooler
    if vTobScenario.GetValue('SPOOLER') = 'X' then
      StartPDFBatch( lStSpooler );

    // Pour une impression de documents -> gestion des tables temporaire DOCFACT et DOCREGL
    if (not vboBordereau) and (vTobScenario.GetValue('CPG_AVECDOC') = 'X') then
         // =================================================
         // ==== EDITION DOCUMENT VIA DOCFACT ET DOCREGL ====
         // =================================================
      begin
      // ********************************************************
      // **** Suppression pr�alable des ch�ques non imprim�s ****
      // ********************************************************
      ExecuteSQL('DELETE FROM DOCREGLE WHERE DR_USER="'+V_PGI.User+'"') ;
      ExecuteSQL('DELETE FROM DOCFACT WHERE DF_USER="'+V_PGI.User+'"') ;
      lTLReq := TList.Create ;

      // ********************************
      // **** Parcours des �ch�ances ****
      // ********************************
      for i := 0 to vTobGene.Detail.Count-1  do
        begin

        lTobLigne := vTobGene.Detail[ i ] ;

        // Uniquement les lignes concern�es (Ech�ances Tiers)
        if lTobLigne.GetValue('ESTECHEORIG') <> 'X' then Continue ;

        // Si rupture (ou derni�re ligne), cr�ation d'un nouveau document DOCREGL
        if RuptureEtats( i, lTobLigne, vTobScenario, lStRuptAuxi, lDtRuptEche ) then
          begin
          GenereDOCREGL    ( lTobRupt, vTobScenario, lIndexDR, lMontant, lMontantDev ) ;
          GenereRequeteDoc ( lTobRupt, vTobScenario, lTLReq, lIndexDR ) ;
          lIndexDR := lIndexDR + 1 ;
          lMontant    := 0 ;
          lMontantDev := 0 ;
          lIndexDF    := 0 ;
          end ;

        // MAJ des montants
        lMontant    := lMontant    + ( lTobLigne.GetValue('E_DEBIT')    - lTobLigne.GetValue('E_CREDIT') ) * lSens ;
        lMontantDev := lMontantDev + ( lTobLigne.GetValue('E_DEBITDEV') - lTobLigne.GetValue('E_CREDITDEV') ) * lSens ;

        // Cr�ation d'une ligne de DocFact
        GenereDOCFACT ( lTobLigne, vTobScenario, lIndexDR, lIndexDF ) ;
        lTobRupt    := lTobLigne ;
        lIndexDF    := lIndexDF + 1 ;

        end ;

      // Prise en compte de la derni�re rupture
      GenereDOCREGL    ( lTobRupt, vTobScenario, lIndexDR, lMontant, lMontantDev ) ;
      GenereRequeteDoc ( lTobRupt, vTobScenario, lTLReq, lIndexDR ) ;

      // **************************************
      // **** Ex�cution du lanceDocument : ****
      // **************************************
      {$IFNDEF EAGLCLIENT} // Pas de spooler avec les documents en EAGL
      if vTobScenario.GetValue('SPOOLER') = 'X' then
        begin
        lStRep      := vTobScenario.GetValue('REPSPOOLER') ;           // R�p spooler
        lBoXFichier := vTobScenario.GetValue('XFICHIERSPOOLER')='X' ;  // Racine Nom fichier
        lStRacine   := vTobScenario.GetValue('CPG_MODELEENCADECA') ;   // X Fichiers
        lInSouche   := 0 ;                                             // Souche
        LanceDocumentSpool( 'L', lStNature, lStCode, lTLReq, nil, lApercu, lBoDialog,
                            FALSE, lStRep, lStRacine, lBoXFichier, lInSouche );
        end
      else
      {$ENDIF}
        LanceDocument     ( 'L', lStNature, lStCode, lTLReq, nil, lApercu, lBoDialog ) ;
      FreeAndNil( lTLReq ) ;

      end
    else // Sinon utilisation d'une tob virtuelle avec lanceEtatTob
         // ==========================
         // ==== EDITION ETAT AGL ====
         // ==========================
        begin
        // Compl�te Tob Etats
        CompleteTobPourEtat ( vTobGene, vTobScenario ) ;
        lTobEtat    := Tob.Create('TOB_ETAT', nil, -1 ) ;
        // Parcours du r�glement
        for i := 0 to vTobGene.Detail.Count - 1 do
          begin
          // Uniquement les lignes concern�es (Ech�ances Tiers)
          lTobLigne := vTobGene.Detail[ i ] ;
          if lTobLigne.GetValue('ESTECHEORIG') <> 'X' then Continue ;
          // Si rupture lancement de l'�tat avec pour auxi en cours
          if (not vboBordereau) and (RuptureEtats ( i, lTobLigne, vTobScenario, lStRuptAuxi, lDtRuptEche)) then //XMG 05/04/04
            begin
            LanceEtatTOB( 'E' , lStNature , lStCode ,
                            lTobEtat,
                            lApercu, False, False, Nil, '', '', False ) ;  //manque le param�tre de PrintDialog.....

            FreeAndNil( lTobEtat ) ;
            lTobEtat    := Tob.Create('TOB_ETAT', nil, -1 ) ;
            end ;
          // duplication pour alimentation de l'�tat
          Tob.Create('ECRITURE', lTobEtat, -1).Dupliquer( lTobLigne, False, True) ;
          end ;
        // Si rupture lancement de l'�tat avec pour auxi en cours
        if lTobEtat.Detail.count > 0 then
          begin
          LanceEtatTOB( 'E' , lStNature , lStCode ,
                        lTobEtat,
                        lApercu, False, False, Nil, '', '', False ) ;  //manque le param�tre de PrintDialog.....
          FreeAndNil( lTobEtat ) ;
          end ;
        end ;

    // Fin du spooler
    if vTobScenario.GetValue('SPOOLER') = 'X' then
      begin
      CancelPDFBatch;
      {$IFNDEF EAGLCLIENT}
        PreviewPDFFile('', lStSpooler );
      {$ENDIF}
      end ;

  finally
    // Remise � z�ro param�tres PDF
    if vTobScenario.GetValue('SPOOLER') = 'X' then
      begin
      V_PGI.QRPDF       := False;
      V_PGI.QRPDFQueue  := '';
      V_PGI.QRPDFMerge  := '';
      end ;

  end;

end ;
*)//XMG 20/04/04
//XMG 20/04/04 d�but
procedure ChargeComplementExport ( vTobExp : TOB ; vStTable, vstchOrig, vStChDest : String ) ;
var lQuery : TQuery ;
    lStSQL : String ;
    lidx   : integer ;
Begin
  lStSQL:='select * from '+vStTable+' where '+vstChDest+'="'+vTobExp.GetValue(vstChOrig)+'"' ;
  lQuery:=OpenSQL(lstSQL,TRUE) ;
  if not lQuery.Eof then
     for lidx:=0 to lQuery.FieldCount-1 do
       Begin
       vTobExp.AddChampsup(lQuery.Fields[lIdx].FieldName,FALSE) ;
       vTobExp.PutValue(lQuery.Fields[lIdx].FieldName,lQuery.Fields[lIdx].Value) ;
       End ;
  Ferme(lQuery) ;
End ;
//XMG 20/04/04 fin




{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 08/01/2004
Modifi� le ... : 31/01/2006
Description .. : Renseigne les derni�res infos de la pi�ce d'enca/d�ca
Suite ........ : g�n�r�, telles que :
Suite ........ :  - mise en place du num�ro de pi�ce,
Suite ........ :  - maj du num�ro de ligne,
Suite ........ :  - maj de la nature de la pi�ce,
Suite ........ : 
Suite ........ :  - finition de l'analytique
Suite ........ : 
Suite ........ : 30/04/2004 : Ajout de la gestion de l'uniformisation des
Suite ........ : modes de paiement.
Suite ........ : 
Suite ........ : 31/01/2006 : SBO transf�r� dans sp�cif ESP car plus utilis� 
Suite ........ :  en standard.
Mots clefs ... : 
*****************************************************************}
Procedure TerminePieceEncaDecaESP      ( vTobOrigine , vTobGene, vTobScenario : TOB ; vDev : RDevise ) ;
Var lInCpt        : Integer ;
    lInNum        : Integer ;
    lTobLg        : TOB ;
    lStNat        : String ;
    lDtDateModif  : TDateTime ;
begin

  // Nouveau num�ro de pi�ce DE TYPE SIMULATION !!!!
  if VH^.PaysLocalisation=CodeISOES then //XVI 24/02/2005
     lInNum  := GetNewNumJal( vTobGene.Detail[0].GetValue('E_JOURNAL'), False, vTobScenario.GetValue('DATECOMPTABLE') )
  else
     lInNum  := GetNewNumJal( vTobScenario.GetValue('CPG_JOURNAL'), False, vTobScenario.GetValue('DATECOMPTABLE') ) ;
  // D�termination du Type de pi�ce
  lStNat  := vTobScenario.GetValue('NATUREPIECE') ;
  // Date de modification unique pour les lignes
  lDtDateModif := NowH ;

  // Parcours des lignes de la tob g�n�r�e
  for lInCpt:=0 to vTobGene.Detail.Count-1 do
    begin
    lTobLg := vTobGene.Detail[ lInCpt ] ;

    // MAJ num�ro de ligne
    lTobLg.PutValue('E_NUMLIGNE'	 ,  lInCpt + 1 ) ;
    // MAJ num�ro de pi�ce
    lTobLg.PutValue('E_NUMEROPIECE',  lInNum  ) ;
    // MAJ nature de pi�ce
    lTobLg.PutValue('E_NATUREPIECE',  lStNat  ) ;
    // Encaissement / D�caissement ?
    lTobLg.PutValue('E_ENCAISSEMENT', SensEnc( lTobLg.GetValue('E_DEBITDEV') , lTobLg.GetValue('E_CREDITDEV') ) ) ;
    // Date de modification
    lTobLg.PutValue('E_DATEMODIF', lDtDateModif) ;

    // Finition de l'analytique
    TermineAnalytiqueEncaDecaESP ( lTobLg, vTobScenario, vDev ) ;

    end ;

end ;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 08/01/2004
Modifi� le ... : 08/01/2004
Description .. : Finition des lignes de ventilation analytique :
Suite ........ :  - Affecte les infos venant de la ligne d'�criture g�n�,
Suite ........ :  - maj du num�ro de ligne de ventilation,
Suite ........ :  - calcul des totaux et pourcentage de la ligne.
Mots clefs ... : 
*****************************************************************}
Procedure TermineAnalytiqueEncaDecaESP ( vTobGene, vTobScenario : TOB ; vDev : RDevise ) ;
var lInAxe, lInAna    : Integer ;
    lTobAxe, lTobAna  : TOB ;
    lMontantEcr       : Double ; //
    lMontantDev       : Double ;
    lPourcent         : Double ;
    lDebitAna         : Double ;
    lCreditAna        : Double ;
    lTotalPourcent    : Double ;
    lTotalDebit       : Double ;
    lTotalCredit      : Double ;
begin

  // Parcours des axes
  for lInAxe:=0 to vTobGene.Detail.Count-1 do
    begin

    // Initialisation des cumuls
    lTotalPourcent    := 0 ;
    lTotalDebit       := 0 ;
    lTotalCredit      := 0 ;

    // Parcours des ventilations de chaque axe
    lTobAxe := vTobGene.Detail[lInAxe] ;
    for lInAna:=0 to lTobAxe.Detail.Count-1 do
      begin
      lTobAna:=lTobAxe.Detail[lInAna] ;

      // Num�ro de ligne
      lTobAna.PutValue('Y_NUMVENTIL',      IntToStr(lInAna+1)) ;

      // Cl� �criture g�n�ral
      lTobAna.PutValue('Y_EXERCICE',       vTobGene.GetValue('E_EXERCICE')) ;
      lTobAna.PutValue('Y_DATECOMPTABLE',  vTobGene.GetValue('E_DATECOMPTABLE')) ;
      lTobAna.PutValue('Y_JOURNAL',        vTobGene.GetValue('E_JOURNAL')) ;
      lTobAna.PutValue('Y_NUMEROPIECE',    vTobGene.GetValue('E_NUMEROPIECE')) ;
      lTobAna.PutValue('Y_NUMLIGNE',       vTobGene.GetValue('E_NUMLIGNE')) ;
      lTobAna.PutValue('Y_NATUREPIECE',    vTobGene.GetValue('E_NATUREPIECE')) ;
      lTobAna.PutValue('Y_QUALIFPIECE',    vTobGene.GetValue('E_QUALIFPIECE')) ;

      // Autre infos ecritures g�n�rale
      lTobAna.PutValue('Y_GENERAL',        vTobGene.GetValue('E_GENERAL')) ;
      lTobAna.PutValue('Y_REFINTERNE',     vTobGene.GetValue('E_REFINTERNE')) ;
      lTobAna.PutValue('Y_LIBELLE',        vTobGene.GetValue('E_LIBELLE')) ;
      lTobAna.PutValue('Y_AUXILIAIRE',     vTobGene.GetValue('E_AUXILIAIRE')) ;
      lTobAna.PutValue('Y_PERIODE',        vTobGene.GetValue('E_PERIODE')) ;
      lTobAna.PutValue('Y_SEMAINE',        vTobGene.GetValue('E_SEMAINE')) ;
      lTobAna.PutValue('Y_CONTREPARTIEGEN',vTobGene.GetValue('E_CONTREPARTIEGEN')) ;
      lTobAna.PutValue('Y_CONTREPARTIEAUX',vTobGene.GetValue('E_CONTREPARTIEAUX')) ;
      lTobAna.PutValue('Y_QUALIFECRQTE1',  vTobGene.GetValue('E_QUALIFQTE1') ) ;
      lTobAna.PutValue('Y_QUALIFECRQTE2',  vTobGene.GetValue('E_QUALIFQTE2') ) ;

      // Montant total �criture g�n�rale
      lMontantEcr   := vTobGene.GetValue('E_DEBIT') + vTobGene.GetValue('E_CREDIT') ;
      lTobAna.PutValue('Y_TOTALECRITURE', lMontantEcr ) ;
      lMontantDev   := vTobGene.GetValue('E_DEBITDEV') + vTobGene.GetValue('E_CREDITDEV') ;
      lTobAna.PutValue('Y_TOTALDEVISE',   lMontantDev ) ;

      // Finition des calculs si report de l'analytique au d�tail de l'�ch�ance
      // Sauf pour la derni�re ligne qui est calcul� par diff�rence total - cumul
      if (vTobScenario.GetValue('CPG_METHODEANA') = 'DET') and
         (lInAna < lTobAxe.Detail.Count - 1 ) then
        begin
        lDebitAna      := Arrondi( vTobGene.GetValue('E_DEBITDEV')  * lTobAna.GetValue('Y_POURCENTAGE') / 100.0, vDev.Decimale ) ;
        lCreditAna     := Arrondi( vTobGene.GetValue('E_CREDITDEV') * lTobAna.GetValue('Y_POURCENTAGE') / 100.0, vDev.Decimale ) ;
        // MAJ montant tob
        CSetMontants( lTobAna, lDebitAna, lCreditAna, vDev, True );
        // stockage du cumul pour calcul exact de la derni�re ligne
        lTotalPourcent := lTotalPourcent + lTobAna.GetValue('Y_POURCENTAGE') ;
        lTotalDebit    := lTotalDebit + lTobAna.GetValue('Y_DEBITDEV') ;
        lTotalCredit   := lTotalCredit + lTobAna.GetValue('Y_CREDITDEV') ;
        end ;

      // Calcul pourcentage des quantit�s
      lPourcent := 0 ;
      if lTobAna.GetValue('Y_TOTALQTE1')<>0 then
        lPourcent := Arrondi( 100.0*( lTobAna.GetValue('Y_QTE1') ) / lTobAna.GetValue('Y_TOTALQTE1'), 4 ) ;
      lTobAna.PutValue('Y_POURCENTQTE1',    lPourcent) ;
      lPourcent := 0 ;
      if lTobAna.GetValue('Y_TOTALQTE2')<>0 then
        lPourcent := Arrondi( 100.0*( lTobAna.GetValue('Y_QTE2') ) / lTobAna.GetValue('Y_TOTALQTE2'), 4 ) ;
      lTobAna.PutValue('Y_POURCENTQTE2',    lPourcent) ;

      end ;

    // Finition des calculs si report de l'analytique au d�tail de l'�ch�ance
    // Pour la derni�re ligne : calcul par diff�rence total - cumul
    if (lTobAxe.Detail.Count > 0) and (vTobScenario.GetValue('CPG_METHODEANA') = 'DET') then
      begin
      lTobAna        := lTobAxe.Detail[ lTobAxe.Detail.Count - 1 ] ;
      lDebitAna      := vTobGene.GetValue('E_DEBITDEV') - lTotalDebit ;
      lCreditAna     := vTobGene.GetValue('E_CREDITDEV') - lTotalCredit ;
      lPourcent      := 100 - lTotalPourcent ;
      // MAJ montant tob
      CSetMontants( lTobAna, lDebitAna, lCreditAna, vDev, True );
      // MAJ pourcentage
      lTobAna.PutValue('Y_POURCENTAGE', lPourcent ) ;
      end ;


    end ;
end ;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 08/01/2004
Modifi� le ... :   /  /
Description .. : Affecte � la ligne d'�criture g�n�r�e, les informations �
Suite ........ : reprendre de la ligne d'�ch�ance d'origine.
Mots clefs ... :
*****************************************************************}
Procedure RecopieInfosEcheanceESP      ( vTobOrigine , vTobGene : TOB ) ;
begin
  // Infos auxiliaire
  CDupliquerInfoAux( vTobOrigine, vTobGene );

  // Infos G�n�rale
  vTobGene.PutValue('E_REFINTERNE',       vTobOrigine.GetValue('E_REFINTERNE') ) ;
  vTobGene.PutValue('E_LIBELLE',          vTobOrigine.GetValue('E_LIBELLE') ) ;
  vTobGene.PutValue('E_RIB',              vTobOrigine.GetValue('E_RIB') ) ;

  // TVA ???
  vTobGene.PutValue('E_TVAENCAISSEMENT',  vTobOrigine.GetValue('E_TVAENCAISSEMENT') ) ;
  vTobGene.PutValue('E_REGIMETVA',        vTobOrigine.GetValue('E_REGIMETVA') ) ;
  vTobGene.PutValue('E_TVA',              vTobOrigine.GetValue('E_TVA') ) ;
  vTobGene.PutValue('E_TPF',              vTobOrigine.GetValue('E_TPF') ) ;

  // Infos Compl�mentaires
  vTobGene.PutValue('E_REFEXTERNE',       vTobOrigine.GetValue('E_REFEXTERNE') ) ;
  vTobGene.PutValue('E_DATEREFEXTERNE',   vTobOrigine.GetValue('E_DATEREFEXTERNE') ) ;
  vTobGene.PutValue('E_REFLIBRE',       vTobOrigine.GetValue('E_REFLIBRE') ) ;
  vTobGene.PutValue('E_AFFAIRE',        vTobOrigine.GetValue('E_AFFAIRE') ) ;
  vTobGene.PutValue('E_QTE1',           vTobOrigine.GetValue('E_QTE1') ) ;
  vTobGene.PutValue('E_QTE2',           vTobOrigine.GetValue('E_QTE2') ) ;
  vTobGene.PutValue('E_QUALIFQTE1',     vTobOrigine.GetValue('E_QUALIFQTE1') ) ;
  vTobGene.PutValue('E_QUALIFQTE2',     vTobOrigine.GetValue('E_QUALIFQTE2') ) ;
  vTobGene.PutValue('E_LIBRETEXTE0',    vTobOrigine.GetValue('E_LIBRETEXTE0') ) ;
  vTobGene.PutValue('E_LIBRETEXTE1',    vTobOrigine.GetValue('E_LIBRETEXTE1') ) ;
  vTobGene.PutValue('E_LIBRETEXTE2',    vTobOrigine.GetValue('E_LIBRETEXTE2') ) ;
  vTobGene.PutValue('E_LIBRETEXTE3',    vTobOrigine.GetValue('E_LIBRETEXTE3') ) ;
  vTobGene.PutValue('E_LIBRETEXTE4',    vTobOrigine.GetValue('E_LIBRETEXTE4') ) ;
  vTobGene.PutValue('E_LIBRETEXTE5',    vTobOrigine.GetValue('E_LIBRETEXTE5') ) ;
  vTobGene.PutValue('E_LIBRETEXTE6',    vTobOrigine.GetValue('E_LIBRETEXTE6') ) ;
  vTobGene.PutValue('E_LIBRETEXTE7',    vTobOrigine.GetValue('E_LIBRETEXTE7') ) ;
  vTobGene.PutValue('E_LIBRETEXTE8',    vTobOrigine.GetValue('E_LIBRETEXTE8') ) ;
  vTobGene.PutValue('E_LIBRETEXTE9',    vTobOrigine.GetValue('E_LIBRETEXTE9') ) ;
  vTobGene.PutValue('E_TABLE0',         vTobOrigine.GetValue('E_TABLE0') ) ;
  vTobGene.PutValue('E_TABLE1',         vTobOrigine.GetValue('E_TABLE1') ) ;
  vTobGene.PutValue('E_TABLE2',         vTobOrigine.GetValue('E_TABLE2') ) ;
  vTobGene.PutValue('E_TABLE3',         vTobOrigine.GetValue('E_TABLE3') ) ;
  vTobGene.PutValue('E_LIBREDATE',      vTobOrigine.GetValue('E_LIBREDATE') ) ;
  vTobGene.PutValue('E_LIBREBOOL0',     vTobOrigine.GetValue('E_LIBREBOOL0') ) ;
  vTobGene.PutValue('E_LIBREBOOL1',     vTobOrigine.GetValue('E_LIBREBOOL1') ) ;
  vTobGene.PutValue('E_LIBREMONTANT0',  vTobOrigine.GetValue('E_LIBREMONTANT0') ) ;
  vTobGene.PutValue('E_LIBREMONTANT1',  vTobOrigine.GetValue('E_LIBREMONTANT1') ) ;
  vTobGene.PutValue('E_LIBREMONTANT2',  vTobOrigine.GetValue('E_LIBREMONTANT2') ) ;
  vTobGene.PutValue('E_LIBREMONTANT3',  vTobOrigine.GetValue('E_LIBREMONTANT3') ) ;
  vTobGene.PutValue('E_CONSO',          vTobOrigine.GetValue('E_CONSO') ) ;
end ;


{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 29/04/2004
Modifi� le ... :   /  /
Description .. : Met en place un num�ro de pi�ce de compteur "normal"
Suite ........ : dans la pi�ce pass� en param�tre.
Mots clefs ... :
*****************************************************************}
Procedure AffecteNumeroPieceNormal ( vTobPiece : TOB ; vJournal : String ; vDateComptable : TDateTime ) ;
Var lInCpt  : Integer ;
    lInAxe  : Integer ;
    lInAna  : Integer ;
    lInNum  : Integer ;
    lTobLg  : TOB ;
    lTobAxe : TOB ;
    lTobAna : TOB ;
begin

  // Nouveau num�ro de pi�ce TYPE NORMAL !!!
  lInNum  := GetNewNumJal( vJournal, True, vDateComptable ) ;

  // Parcours des lignes de la tob g�n�r�e
  for lInCpt:=0 to vTobPiece.Detail.Count-1 do
    begin
    lTobLg := vTobPiece.Detail[ lInCpt ] ;
    // MAJ num�ro de pi�ce
    lTobLg.PutValue('E_NUMEROPIECE',  lInNum  ) ;

    // Parcours des ventilations de chaque axe
    for lInAxe:=0 to lTobLg.Detail.Count-1 do
      begin
      lTobAxe := lTobLg.Detail[lInAxe] ;
      for lInAna:=0 to lTobAxe.Detail.Count-1 do
        begin
        lTobAna:=lTobAxe.Detail[lInAna] ;
        lTobAna.PutValue('Y_NUMEROPIECE',    lInNum ) ;
        end ;
      end ;

    end ;

end ;


end.


