  {***********UNITE*************************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 17/11/2003
Modifi� le ... :   /  /
Description .. : Exportation des immobilisations
Mots clefs ... :
Suite..........: - FQ 17215 - TGA 21/12/2005 - GetParamSoc => GetParamSocSecur
Suite..........: - MVG 13/04/2006 - Pour compilation en SERIE1
Suite..........: - MVG 13/04/2006 - Bourreetless en  ImBourreetless Pour compilation en SERIE1
Suite..........: - MVG 13/04/2006 - FaitEnregCompte, ordre SQL pour SERIE1
Suite..........: - BTY 06/06 - FQ 18248 Mise en compatibilit� � CWAS
Suite..........: - BTY 06/06 - FQ 18370 Optimiser la rapidit� de l'export par un order by adapt�
Suite..........: - BTY 06/06 - FQ 18388 Arrondis faux en 2 tiers (OK en eaglclient)
Suite..........: - MVG 12/06/2006 - Report des modifs pour SERIE1
Suite..........: - MBO 10/01/2007 - FQ 19496 - Export du plan fiscal + NON EXPORT DES IMMOS EN VARIABLE
Suite..........: - MBO 08/02/2007 - FQ 19664 - Export d'une immo c�d�e totalement amortie : les dotations des
                                    exo ant�rieurs non prises en cpte dans cumul d�j� amorti
Suite ........ : BTY 05/07 FQ 19820 Mettre dans le .SAV les infos relatives � CRC200-10 si choix Export enrichi
Suite ........ : => nouveau param�tre d'appel de la m�thode Exporte de la class TAmImpExp
Suite ........ : BTY 05/07 FQ 20310 Pour une raison inconnue, I_DUREEREPRISE <0 d�cale l'enreg d'amortissement ECO
Suite ........ : (sert dans immo_tom et amchgtmethode)
Suite ........ : - MBO 12/07/2007 - Export enrichi : export de l'�tablissement
Suite ........ : - MBO 23/07/2007 - fq 21162 - export enrichi : gestion fiscale, calcul sur VNF, notion de remplacement composant
Suite ........ : - BTY 07/07 FQ 21169 Revenir en arri�re sur le tri optimis� de FQ 18370 car les infos immolog et immoamor de certaines
Suite ........ :   immos �taient oubli�es d'o� montants calcul�s � z�ro (cf client SEGEC)
Suite ........ : MBO - 13/09/2007 - FQ 21435 - import des motifs de cession (le code �tait export� sur 1 position alors qu'il en fait 3)

*****************************************************************}
unit AmExport;

interface

uses SysUtils, classes
      , Hctrls, ParamSoc, HEnt1, uTOZ, ed_tools, hmsgBox
     {$IFDEF eAGLClient}
     ,Utob        // pour Tquery en web access FQ 18248
     {$ELSE}
     {$IFNDEF DBXPRESS} ,dbtables {$ELSE} ,uDbxDataSet {$ENDIF}
     {$ENDIF eAGLClient}
      //MVG 13/04/2006
      {$IFDEF SERIE1}
      , s1util, ut0
      {$ELSE}
      , Ent1, uLibWindows
      {$ENDIF SERIE1}
      //Fin MVG 13/04/2006
      , ImEnt, ImEdCalc, ImPlanInfo, ImContra
      {$IFDEF MODENT1}
      , CPTypeCons
      {$ENDIF MODENT1}
      , Math ;          // MaxIntValue FQ 20310

const
  MSG_INFO_PARAM          = 'Sauvegarde des param�tres';
  MSG_INFO_EXERCICE       = 'Sauvegarde de l''exercice en cours';
  MSG_INFO_LIEUX          = 'Sauvegarde des lieux g�ographiques';
  MSG_INFO_MOTIFS         = 'Sauvegarde des motifs de sortie';
  MSG_INFO_STAT           = 'Sauvegarde des statistiques';
  MSG_INFO_FAMILLE        = 'Sauvegarde des familles';
  MSG_INFO_COMPTE         = 'Sauvegarde des comptes';
  MSG_ERR_TOZ             = 'Erreur lors de la compression';
  MSG_ERR_CREATIONARCHIVE = 'Cr�ation de l''archive impossible';
type
      TAmImpExpInfo = procedure ( Sender : TObject; Msg : string; iErreur : integer ) of object;

      TAmImpExp = class
        private
          fOnInformation : TAmImpExpInfo;
          fFichier       : TextFile;
          fEnrichi       : Boolean;    // FQ 19820
          procedure   EcrireFichier ( St : string ); overload;
          procedure   EcrireFichier ( SL : TStringList ); overload;
          procedure   FaitEnregFamille ( SL : TStringList );
          procedure   FaitEnregStat ( SL : TStringList );
          procedure   FaitEnregLieux ( SL : TStringList );
          procedure   FaitEnregMotifsSorties ( SL : TStringList );
          procedure   FaitEnregCompte(SL: TStringList);
          procedure   CompresseFichier ( stFichier : string );
          function    Montant13 ( Montant : double ) : string;
          function    FaitEnregParametre : string;
          function    FaitEnregFiche ( Q : TQuery; NumImmo : integer ) : string;
          function    FaitEnregAmortissement ( Q : TQuery; PlanInfo : TPlanInfo; NumImmo : integer ) : string;
          // ajout mbo - fq 19496 - 10/01/2007
          function    FaitAmortFiscal ( Q : TQuery; PlanInfo : TPlanInfo; NumImmo : integer ) : string;

          function    FaitEnregCreditBail ( Q : TQuery; NumImmo : integer ) : string;
          function    FaitEnregEcheance ( SL : TStringList; Q : TQuery ; NumImmo : integer ) : string;
          function    FaitEnregExercice: string;
          procedure   FaitEnregGroupe ( SL : TStringList );   // FQ 19820
        public
          constructor Create ;
          destructor  Destroy (); override;
          procedure   Exporte ( stFichier : string; bCompression : boolean; bAvancement : boolean = False ;
                                bEnrichi : Boolean = False);  // FQ 19820
        published
          property    OnInformation : TAmImpExpInfo read fOnInformation write fOnInformation;
      end;

procedure ExporteAmortissement;

implementation

{$IFDEF SERIE1}
uses
  hFolders, controls
  {$IFDEF EAGLCLIENT}
  , MenuOLX
  {$ELSE}
  , MenuOLG
  {$ENDIF EAGLCLIENT}
 ;
{$ELSE}
{$ENDIF SERIE1}
procedure ExporteAmortissement;
var
  LExport : TAmImpExp;
  stFichier : string;
begin
  LExport := TAmImpExp.Create;
  LExport.OnInformation := nil;
  // MVG 12/07/2006
  {$IFDEF SERIE1}
  PgiInfo('Veuillez choisir le r�pertoire d''export des Immobilisations') ;
  stFichier:='' ;
  while stFichier='' do
    begin
    with TBrowseFolder.Create(appli) do
      begin
      if Execute then
        stFichier:=Directory ;
      free ;
      end ;
    if (StFichier<>'') then
      begin
      stFichier:=stFichier+'\IMMO.SAV'
      end else
      begin
      if (PgiAsk('Voulez-vous annuler l''export des Immobilisations?')=mrYes) then
        exit ;
      end ;
    end ;

  {$ELSE}
  if ctxPCL in V_PGI.PGIContexte then
    stFichier := ChangeStdDatPath('$DOS\'+'IM2'+V_PGI.NoDossier+'.SAV',True)
  else stFichier := 'C:\IMMO.SAV';
  {$ENDIF SERIE1}
  LExport.Exporte ( stFichier ,True,True);
  LExport.Free;
  PGIInfo('Export termin�.');

  // MVG 12/07/2006
  {$IFDEF SERIE1}
  FMenuG.ChoixModule() ;
  {$ELSE}
  {$ENDIF SERIE1}
end;

{ TAmImpExp }

constructor TAmImpExp.Create;
begin

end;

destructor TAmImpExp.Destroy;
begin
  inherited;

end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Moteur principal de constitution du fichier d'export
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.Exporte(stFichier: string; bCompression : boolean; bAvancement : boolean = False;
           bEnrichi : Boolean = False);   // FQ 19820
var Q : TQuery;
    St, stMessage : string;
    NumImmo : integer;
    SL : TStringList;
begin
  { Initialisation }

  VHImmo^.PlanInfo.Free ; VHImmo^.PlanInfo:=nil ; NumImmo := 0; SL := TStringList.Create;
  fEnrichi :=  bEnrichi;      // FQ 19820

  { Traitements des immobilisations }

  AssignFile( fFichier , stFichier );
  Rewrite ( fFichier );
  //BTY FQ 21169 annule FQ 18370
  //BTY FQ 18370 Am�liorer les performances de ChargeImmo
  Q := OpenSQL ( 'SELECT * FROM IMMO ORDER BY I_COMPTEIMMO', True );
  //Q := OpenSQL ( 'SELECT * FROM IMMO ORDER BY I_COMPTEIMMO,I_IMMO', True );
  try
    { Initialisations }
    if bAvancement then
     // InitMoveProgressForm(nil,'Export des amortissements','Export en cours...',QCount ( Q ),False,True) ;
     // FQ 18248
     InitMoveProgressForm(nil,'Export des amortissements','Export en cours...',RecordsCount(Q),False,True) ;

    { Enregistrements des param�tres }

    { construction de l'enregistrement param�tres }
    EcrireFichier ('***DEBUT***');
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_PARAM, 0);
    EcrireFichier ( FaitEnregParametre );
    { construction de l'enregistrement exercice }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_EXERCICE, 0);
    EcrireFichier ( FaitEnregExercice );
    { construction des enregistrements lieux g�ographiques }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_LIEUX, 0);
    FaitEnregLieux ( SL );
    EcrireFichier ( SL );
    { FQ 18920 }
    if fEnrichi then
    begin
      FaitEnregGroupe ( SL );
      EcrireFichier ( SL );
    end;
    { construction des enregistrements sorties }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_MOTIFS, 0);
    FaitEnregMotifsSorties ( SL );
    EcrireFichier ( SL );
    { construction des enregistrements statistiques }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_STAT, 0);
    FaitEnregStat ( SL );
    EcrireFichier ( SL );
    { construction des enregistrements famille }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_FAMILLE, 0);
    FaitEnregFamille ( SL );
    EcrireFichier ( SL );
    { construction des enregistrements comptes }
    if assigned(fOnInformation) then fOnInformation ( Self, MSG_INFO_COMPTE, 0);
    FaitEnregCompte( SL );
    EcrireFichier ( SL );

    { constitution des enregistrements relatifs aux immobilisations }

    while not Q.Eof do
    begin

      { Calcul des informations du plan d'amortissement }
      Inc ( NumImmo, 1 );
      if assigned(fOnInformation) or bAvancement then
      begin
         stMessage := TraduireMemoire('Immobilisation')+' : '+Q.FindField('I_COMPTEIMMO').AsString
                      +' - '+Q.FindField('I_IMMO').AsString;
         if assigned(fOnInformation) then fOnInformation ( Self, stMessage, 0);
      end;
      if bAvancement then MoveCurProgressForm(stMessage) ;
      //BTY FQ 21169 Annule FQ 18370
      //BTY FQ 18370 Optimiser ChargeImmo en connaissant le order by du select
      //if (VHImmo^.PlanInfo <> nil) then
      //begin
      //   VHImmo^.PlanInfo.SQLWhere :=  Q.FindField('I_COMPTEIMMO').AsString + ';' +
      //                                 Q.FindField('I_IMMO').AsString + ';';
      //   VHImmo^.PlanInfo.SQLOrderBy := 'I_COMPTEIMMO;I_IMMO;';
      //end;
      UpdatePlanInfo (VHImmo^.PlanInfo, Q.FindField('I_IMMO').AsString, VHImmo^.Encours.Fin );

      // ajout mbo pour ne pas exporter les fiches avec plan variable - FQ 19496
      // ajout mbo pour ne pas exporter les fiches remplac�es - 13.07.07 - FQ 21162
      if (VHImmo^.PlanInfo.Plan.AmortEco.Methode <> 'VAR' ) and
         (Q.FindField('I_REMPLACEE').AsString = '') then
      begin
         { Construction de l'enregistrement amortissement }
          St := FaitEnregAmortissement ( Q, VHImmo^.PlanInfo, NumImmo );
          EcrireFichier ( St );

          // ajout mbo - fq 19496 - 10/01/2007
          if VHImmo^.PlanInfo.Plan.Fiscal = true then
          begin
             St := FaitAmortFiscal ( Q, VHImmo^.PlanInfo, NumImmo );
             EcrireFichier ( St );
          end;

          { Construction de l'enregistrement fiche }
          St := FaitEnregFiche ( Q, NumImmo );
          EcrireFichier ( St );
          { Construction des enregistrements li�s aux cr�dit-bails }
          if (Q.FindField('I_NATUREIMMO').AsString = 'CB') or (Q.FindField('I_NATUREIMMO').AsString = 'LOC') then
          begin
            St := FaitEnregCreditBail ( Q, NumImmo );
            EcrireFichier ( St );
            FaitEnregEcheance ( SL, Q,  NumImmo );
            EcrireFichier ( SL );
          end;
       end;
       Q.Next;
    end;
  finally
    Ferme ( Q );
    VHImmo^.PlanInfo.Free ; VHImmo^.PlanInfo:=nil ; SL.Free;
    EcrireFichier ('***FIN***');
    CloseFile ( fFichier );
    if bCompression then CompresseFichier ( stFichier );
    if bAvancement then FiniMoveProgressForm;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution des enregistrement caract�ristiques du plan
Suite ........ : d'amortissement de l'immobilisation
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregAmortissement(Q: TQuery; PlanInfo: TPlanInfo;
  NumImmo: integer): string;
var stCode : string;
    stEtat, stNature, stCompte : string;
    DateDebut, ope : string;
    DureeReprise : integer;
    Depreciation : double;
begin
  stCode := 'FA';
  stEtat := Q.FindField('I_ETAT').AsString;
  stNature := Q.FindField('I_NATUREIMMO').AsString;
  if stEtat = 'FER' then stCode := stCode+'H'
  else stCode := stCode + 'E';
  if (stNature = 'PRO') or (stNature = 'FI') then stCode := stCode+'A'
  else stCode := stCode + 'C';
  if (stNature = 'CB') or (stNature = 'LOC') then
    stCompte := ImBourreEtLess(Q.FindField('I_COMPTELIE').AsString, fbGene, 10 )
  else  stCompte := ImBourreEtLess(Q.FindField('I_COMPTEIMMO').AsString, fbGene, 10 );

  // FQ 19820
  if fEnrichi then
  begin
     DateDebut := FormatDateTime('ddmmyyyy',Q.FindField('I_DATEDEBECO').AsDateTime) +
                  Format ( '%-5s',['']);
     Depreciation := VHImmo^.PlanInfo.Plan.Cumul_depreciation(Q.FindField('I_IMMO').AsString, False)+
                     Q.FindField('I_REPRISEDEP').AsFloat + Q.FindField('I_REPRISEDEPCEDEE').AsFloat;
     if Depreciation <> 0 then
     ope := 'DP'
     else  ope := '  ';
  end else
  begin
     DateDebut := Montant13(0);
     Depreciation := Q.FindField('I_TAUXECO').AsFloat; // comme avant
     ope := '  ';
  end;
  // FQ 20310
  DureeReprise := MaxIntValue([0, Q.FindField('I_DUREEREPRISE').AsInteger]);

  Result := stCode
            +stCompte                                                             // Num�ro de compte
            +Format ( '%6.6d',[NumImmo])                                          // num�ro d'immo
            +'e'                                                                 // amortissement �conomique
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Deb)                       // date d�but exercice
            +Copy(Q.FindField('I_METHODEECO').AsString,1,1)                       // M�thode d'amortissement �co
            +Copy(Q.FindField('I_METHODEECO').AsString,1,1)                       // D�tection chgt m�thode
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Fin)                       // date fin d'exercice
            + ope // '  '                                                         // indicateur d'op�rations effectu�es
            +Montant13(PlanInfo.BaseEco)                                          // Base amortissement
            +Montant13(Q.FindField('I_TAUXECO').AsFloat)                          // Taux d'amortissement
            +Montant13(Q.FindField('I_TAUXECO').AsFloat)                          // D�tection chgt de taux
            +Montant13(PlanInfo.DotationEco)                                      // Dotation p�riode
            +Montant13(0)                                                         // Montant d�rogatoire
            +Montant13(0)                                                         // Cumul d�rogatoire
            +Montant13(PlanInfo.CumulAntEco+PlanInfo.DotationEco+PlanInfo.CumulCessionEco) // fq 19664 - Cumul d�j� amorti
            +Montant13(PlanInfo.CumulAntEco+PlanInfo.DotationEco+PlanInfo.CumulCessionEco) // fq 19664 - Cumul d�j� amorti
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Montant � r�int�grer
            +Montant13(Q.FindField('I_REINTEGRATION').AsFloat)                    // Base r�int�gration
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // dur�e
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // dur�e d�j� amortie
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // cumul nb mois par exercice
            //+Format ( '%5.5d',[Q.FindField('I_DUREEREPRISE').AsInteger])          // base dur�e reprise
            +Format ( '%5.5d',[DureeReprise])                                     // FQ 20310
            +Montant13(PlanInfo.BaseEco)                                          // Base amortissement
            +Montant13(Q.FindField('I_TAUXECO').AsFloat)                          // Taux d'amortissement
            //+Montant13(Q.FindField('I_TAUXECO').AsFloat)                          // D�tection chgt de taux
            +Montant13(Depreciation)                                              // FQ 19820
            +Montant13(PlanInfo.DotationEco)                                      // Dotation p�riode
            +Montant13(0)                                                         // Montant d�rogatoire
            +Montant13(0)                                                         // Cumul d�rogatoire
            +Montant13(PlanInfo.CumulAntEco+PlanInfo.DotationEco+PlanInfo.CumulCessionEco) // fq 19664 -Cumul d�j� amorti
            +Montant13(PlanInfo.CumulAntEco+PlanInfo.DotationEco+PlanInfo.CumulCessionEco) // fq 19664 -Cumul d�j� amorti
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Valeur r�siduelle
            //+Montant13(0)                                                         // Montant � r�int�grer
            +DateDebut
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // dur�e
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // dur�e d�j� amortie
            +Format ( '%5.5d',[Q.FindField('I_DUREEECO').AsInteger])              // cumul nb mois par exercice
            //+Format ( '%5.5d',[Q.FindField('I_DUREEREPRISE').AsInteger])          // base dur�e reprise
            +Format ( '%5.5d',[DureeReprise])                                     // FQ 20310
            +Montant13(Q.FindField('I_QUOTEPART').AsFloat)                        // pourcentage non prof.
            +'  ';
end;

{***********A.G.L.***********************************************
Auteur  ...... : Maryse Boudin
Cr�� le ...... : 10/01/2007
Modifi� le ... :   /  /
Description .. : Constitution des enregistrement caract�ristiques du plan
Suite ........ : d'amortissement FISCAL de l'immobilisation
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitAmortFiscal(Q: TQuery; PlanInfo: TPlanInfo;
  NumImmo: integer): string;
var stCode : string;
    stEtat, stNature, stCompte : string;
    DateDebut, ope, gestion_fiscale, remplacement : string;
    Depreciation : double;
begin
  stCode := 'FA';
  stEtat := Q.FindField('I_ETAT').AsString;
  stNature := Q.FindField('I_NATUREIMMO').AsString;
  if stEtat = 'FER' then stCode := stCode+'H'
  else stCode := stCode + 'E';
  if (stNature = 'PRO') or (stNature = 'FI') then stCode := stCode+'A'
  else stCode := stCode + 'C';
  if (stNature = 'CB') or (stNature = 'LOC') then
    stCompte := ImBourreEtLess(Q.FindField('I_COMPTELIE').AsString, fbGene, 10 )
  else  stCompte := ImBourreEtLess(Q.FindField('I_COMPTEIMMO').AsString, fbGene, 10 );

  // FQ 19820
  if fEnrichi then
  begin
     DateDebut := FormatDateTime('ddmmyyyy',Q.FindField('I_DATEDEBFIS').AsDateTime) +
                  Format ( '%-5s',['']);
     Depreciation := VHImmo^.PlanInfo.Plan.Cumul_depreciation(Q.FindField('I_IMMO').AsString, False)+
                     Q.FindField('I_REPRISEDEP').AsFloat + Q.FindField('I_REPRISEDEPCEDEE').AsFloat;
     if Depreciation <> 0 then   ope := 'DP'
     else  ope := '  ';

     //ajout mbo 13.07.07 - FQ 21162
     gestion_fiscale := IIF(Q.FindField('I_NONDED').AsString='X','O',' ');
     remplacement := IIF(Q.FindField('I_STRING1').AsString ='X','O',' ');

  end else
  begin
     DateDebut := Montant13(0);
     Depreciation := Q.FindField('I_TAUXFISC').AsFloat; // comme avant
     ope := '  ';
     Gestion_fiscale := ' ';
     remplacement := ' ';
  end;


  Result := stCode
            +stCompte                                                             // Num�ro de compte
            +Format ( '%6.6d',[NumImmo])                                          // num�ro d'immo
            +'f'                                                                  // amortissement fiscal
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Deb)                       // date d�but exercice
            +Copy(Q.FindField('I_METHODEFISC').AsString,1,1)                       // M�thode d'amortissement �co
            +Copy(Q.FindField('I_METHODEFISC').AsString,1,1)                       // D�tection chgt m�thode
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Fin)                       // date fin d'exercice
            +ope // '  '                                                                 // indicateur d'op�rations effectu�es
            +Montant13(PlanInfo.BaseFisc)                                          // Base amortissement
            +Montant13(Q.FindField('I_TAUXFISC').AsFloat)                          // Taux d'amortissement
            +Montant13(Q.FindField('I_TAUXFISC').AsFloat)                          // D�tection chgt de taux
            +Montant13(PlanInfo.DotationFisc)                                      // Dotation p�riode
            +Montant13(0)                                                         // Montant d�rogatoire
            +Montant13(0)                                                         // Cumul d�rogatoire
            +Montant13(PlanInfo.CumulAntFisc+PlanInfo.DotationFisc+PlanInfo.CumulCessionFisc) // fq 19664 - Cumul d�j� amorti
            +Montant13(PlanInfo.CumulAntFisc+PlanInfo.DotationFisc+PlanInfo.CumulCessionFisc) // fq 19664 - Cumul d�j� amorti
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Montant � r�int�grer
            +Montant13(0)  //Q.FindField('I_REINTEGRATION').AsFloat)                    // Base r�int�gration
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])              // dur�e
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])              // dur�e d�j� amortie
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])              // cumul nb mois par exercice
            +Format ( '%5.5d',[Q.FindField('I_DUREPRISEFISCL').AsInteger])          // base dur�e reprise
            +Montant13(PlanInfo.BaseFisc)                                          // Base amortissement
            +Montant13(Q.FindField('I_TAUXFISC').AsFloat)                          // Taux d'amortissement
            //+Montant13(Q.FindField('I_TAUXFISC').AsFloat)                          // D�tection chgt de taux
            +Montant13(Depreciation)                                              // FQ 19820
            +Montant13(PlanInfo.DotationFisc)                                      // Dotation p�riode
            +Montant13(0)                                                         // Montant d�rogatoire
            +Montant13(0)                                                         // Cumul d�rogatoire
            +Montant13(PlanInfo.CumulAntFisc+PlanInfo.DotationFisc+PlanInfo.CumulCessionFisc) // fq 19664 -Cumul d�j� amorti
            +Montant13(PlanInfo.CumulAntFisc+PlanInfo.DotationFisc+PlanInfo.CumulCessionFisc) // fq 19664 -Cumul d�j� amorti
            +Montant13(0)                                                         // Valeur r�siduelle
            +Montant13(0)                                                         // Valeur r�siduelle
            //+Montant13(0)                                                         // Montant � r�int�grer
            +DateDebut
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])            // dur�e
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])            // dur�e d�j� amortie
            +Format ( '%5.5d',[Q.FindField('I_DUREEFISC').AsInteger])            // cumul nb mois par exercice
            +Format ( '%5.5d',[Q.FindField('I_DUREPRISEFISCL').AsInteger])       // base dur�e reprise
            +Montant13(0)  //(Q.FindField('I_QUOTEPART').AsFloat)                // pourcentage non prof.
            +Format ( '%-1s', [Gestion_fiscale])
            +Format ( '%-1s', [remplacement]);   //'  ';                                            // g� fiscale + composant
            end;


{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... : 20/11/2003
Description .. : Constitution des enregistrement pour les donn�es de type
Suite ........ : cr�dit-bail
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregCreditBail(Q: TQuery;  NumImmo: integer): string;
var stCode : string;
begin
  if Q.FindField('I_ETAT').AsString <> 'FER' then stCode := 'FLEC'
  else stCode := 'FLHC';
  Result := stCode
            +ImBourreEtLess(Q.FindField('I_COMPTELIE').AsString, fbGene, 10)          // Num�ro de compte
            +Format ( '%6.6d',[NumImmo])                                            // num�ro d'immo
            +ImBourreEtLess(Q.FindField('I_COMPTEIMMO').AsString, fbGene, 10)         // Num�ro de compte rattachement
            +Format ( '%-15s',[Copy(Q.FindField('I_NUMCONTRATCB').AsString,1,15)])  // No de contrat
            +'N'                                                                    // TVA r�cup�rable ou non
            +Format ( '%-25s',[Copy(Q.FindField('I_ORGANISMECB').AsString,1,25)])   // Organisme
            +Format ( '%-1s',[Copy(Q.FindField('I_PERIODICITE').AsString,1,1)])     // Fr�quence
            +Format ( '%-1s',[Copy(Q.FindField('I_VERSEMENTCB').AsString,1,1)])     // Avance ou �chu
            +IIF(Q.FindField('I_TYPELOYERCB').AsString='LCO','L','D')               // Type de contrat
            +FormatDateTime('ddmmyyyy',Q.FindField('I_DATEDEBUTECH').AsDateTime)    // date 1�re �ch�ance
            +FormatDateTime('ddmmyyyy',Q.FindField('I_DATEFINECH').AsDateTime)      // date fin �ch�ance
            +'          '                                                           // compte d�p�t garantie
            +Format ( '%6.6d',[0])                                                  // immo d�p�t garantie
            +'V'                                                                    // calcul de la valeur r�siduelle
            +Montant13(Q.FindField('I_MONTANTPREMECHE').AsFloat)                    // Montant 1�re �ch�ance
            +Montant13(Q.FindField('I_FRAISECHE').AsFloat)                          // Montant frais 1�re ech.
            +Montant13(Q.FindField('I_MONTANTSUIVECHE').AsFloat)                    // Montant ech. suivantes
            +Montant13(Q.FindField('I_FRAISECHE').AsFloat)                          // Montant frais ech. suiv
            +Montant13(Q.FindField('I_RESIDUEL').AsFloat)                           // Montant r�siduel
            +Montant13(0)                                                           // Montant d�p�t garantie
            ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... : 20/11/2003
Description .. : Constitution des enregistrement pour les donn�es de type
Suite ........ : �cheance de cr�dit-bail
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregEcheance(SL: TStringList; Q: TQuery;
  NumImmo: integer): string;
var stCode : string;
    St : string;
    i : integer;
    LeContrat : TImContrat;
    ATranche : PTranche;
begin
  SL.Clear;
  if Q.FindField('I_TYPELOYERCB').AsString = 'LVA' then
  begin
    if Q.FindField('I_ETAT').AsString <> 'FER' then stCode := 'FPE'
    else stCode := 'FPH';
    LeContrat := TImContrat.Create;
    try
      LeContrat.ChargeFromCode ( Q.FindField('I_IMMO').AsString );
      LeContrat.ChargeTableEcheance;
      LeContrat.CalculEcheances;
      if LeContrat.ListeTranches <> nil then
      begin
        for i := 0 to LeContrat.ListeTranches.Count - 1 do
        begin
          ATranche := LeContrat.ListeTranches.Items[i];
          St := stCode
                +ImBourreEtLess(Q.FindField('I_COMPTELIE').AsString, fbGene, 10)          // Num�ro de compte
                +Format ( '%6.6d',[NumImmo])                                            // num�ro d'immo
                +Format ( '%4.4d',[i])                                                  // num�ro d'ordre
                +FormatDateTime('ddmmyyyy',ATranche^.DateDebut)                         // date d�but p�riode
                +FormatDateTime('ddmmyyyy',ATranche^.DateFin)                           // date fin p�riode
                +Montant13(ATranche^.Montant)                                           // Montant
                +Montant13(ATranche^.Frais)                                             // Frais
                +Format ( '%6.6d',[ATranche^.nEcheance])                                // nombre d'�ch�ances
                ;
         SL.Add ( St );
        end;
      end;
    finally
      LeContrat.Free;
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de la liste codes famille
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregFamille(SL: TStringList);
var Ql : TQuery;
    St : string;
begin
  SL.Clear;
  // MVG 12/07/2006  
  {$IFDEF SERIE1}
  Ql := OpenSQL ('SELECT * FROM CHOIXCOD WHERE CC_TYPE="LI2"', True);
  try
    while not Ql.Eof do
    begin
      St := 'TST'
            +Format ( '%-4s',[Copy(Ql.FindField('CC_CODE').AsString,1,3)])        // code
            +Format ( '%-20s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,20)])     // libell�
            +Format ( '%5.5d',[0])                                                  // nombre de fois utilis�
            +'  ';
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
  {$ELSE}
  Ql := OpenSQL ('SELECT * FROM NATCPTE WHERE NT_TYPECPTE="I01"', True);
  try
    while not Ql.Eof do
    begin
      St := 'TFA'
            +Format ( '%-2s',[Copy(Ql.FindField('NT_NATURE').AsString,1,2)])        // code
            +Format ( '%-20s',[Copy(Ql.FindField('NT_LIBELLE').AsString,1,20)])     // libell�
            +Format ( '%5.5d',[0])                                                  // nombre de fois utilis�
            ;
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
  {$ENDIF SERIE1}
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de l'enregistrement des donn�es de la fiche
Suite ........ : immobilisation
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregFiche(Q: TQuery; NumImmo: integer): string;
var stCode : string;
    stNature, stEtat, stCompte : string;
    IntituleFac, etablissement,PlanFuturVNC, PlanFuturVNF : string;
begin
  stCode := 'FF';
  stEtat := Q.FindField('I_ETAT').AsString;
  stNature := Q.FindField('I_NATUREIMMO').AsString;
  if stEtat = 'FER' then stCode := stCode+'H'
  else stCode := stCode + 'E';
  if (stNature = 'PRO') or (stNature = 'FI') then stCode := stCode+'A'
  else stCode := stCode + 'C';
  if (stNature = 'CB') or (stNature = 'LOC') then
    stCompte := ImBourreEtLess(Q.FindField('I_COMPTELIE').AsString, fbGene, 10 )
  else  stCompte := ImBourreEtLess(Q.FindField('I_COMPTEIMMO').AsString, fbGene, 10 );

  // FQ 19820 Code regroupement et Calcul plan futur avec la VNC
  if fEnrichi then
  begin
     //ajout mbo pour le code etablissement
     IntituleFac := Q.FindField('I_GROUPEIMMO').AsString;
     etablissement:= Q.FindField('I_ETABLISSEMENT').AsString;
     PlanFuturVNC := IIF(Q.FindField('I_JOURNALA').AsString='***','O',' ');
     PlanFuturVNF := IIF(Q.FindField('I_FUTURVNFISC').AsString='***','O',' ');
  end else
  begin
     IntituleFac := '';
     PlanFuturVNF := ' ';
     PlanFuturVNC := ' ';
  end;

  Result := stCode
            +stCompte                                                               // Num�ro de compte
            +Format ( '%6.6d',[NumImmo])                                            // num�ro d'immo
            +'  '                                                                   // famille
            +Format ( '%-25s',[Copy(Q.FindField('I_LIBELLE').AsString,1,25)])       // Libell�
            +IIF (Q.FindField('I_QUALIFIMMO').AsString='R','R','F')                 // Gestion fictif ou r�el
            +FormatDateTime('ddmmyyyy',Q.FindField('I_DATEPIECEA').AsDateTime)      // Date d'achat
            +FormatDateTime('ddmmyyyy',Q.FindField('I_DATEAMORT').AsDateTime)       // Date d'amortissement
            +Format ( '%-10s',[Copy(Q.FindField('I_REFINTERNEA').AsString,1,10)])   // N� facture
            +Format ( '%-15s',[Copy(Q.FindField('I_TIERSA').AsString,1,15)])        // Fournisseur
            +IIF (Q.FindField('I_ETAT').AsString='CLO','*',' ')                     // indicateur de cl�ture
            +Format ( '%-3s',[Copy(Q.FindField('I_LIEUGEO').AsString,1,3)])         // lieu g�ographique
            +'    '                                                                 // indicateur statistique
            +'         '                                                            // codes op�rations
            //+'                    '                                               // zone d'intitul� facultative
            +Format ( '%-3s',[IntituleFac])                                         // code regroupement
            +Format ( '%-17s',[Etablissement])                                        //code etablissement
            //+Montant13(Q.FindField('I_MONTANTHT').AsFloat+
            +Montant13(Q.FindField('I_VALEURACHAT').AsFloat+                        // FQ 16167 : pour cas des sorties
                      + Q.FindField('I_TVARECUPERABLE').AsFloat
                      - Q.FindField('I_TVARECUPEREE').AsFloat)                      // Montant TTC
            +Montant13(Q.FindField('I_TVARECUPERABLE').AsFloat)                   // Tva r�cup�rable
            +Montant13(Q.FindField('I_TVARECUPEREE').AsFloat)                     // Tva r�cup�r�e
            +Montant13(Q.FindField('I_BASETAXEPRO').AsFloat)                      // Base TP
            +Montant13(Q.FindField('I_VALEURACHAT').AsFloat)                      // FQ 16167 : pour cas des sorties
            +Montant13(0)                                                         // Valeur rachat leasing
            +Montant13(0)                                                         // Taux int�r�t leasing
            +Montant13(0)                                                         // Taux aide fiscale
            +Format ( '%13d',[Q.FindField('I_QUANTITE').AsInteger*100])             // Montant HT
            +Montant13(0)                                                         // dotation minimum
            +PlanFuturVNC
            +PlanFuturVNF
            +Format ( '%-10s',[Copy(Q.FindField('I_IMMO').AsString,1,10)])          // montant base origine ==> code immo PGI
            ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de la liste des lieux g�ographiques
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregLieux(SL: TStringList);
var Ql : TQuery;
    St : string;
begin
  SL.Clear;
  Ql := OpenSQL ('SELECT * FROM CHOIXCOD WHERE CC_TYPE="GEO"', True);
  try
    while not Ql.Eof do
    begin
      St := 'TGE'
            +Format ( '%-3s',[Copy(Ql.FindField('CC_CODE').AsString,1,3)])         // code
            +Format ( '%-20s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,20)])    // libell�
            +Format ( '%5.5d',[0])                                                // nombre de fois utilis�
            ;
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Tyn�vez Bernadette
Cr�� le ...... : 10/05/2007
Modifi� le ... : 10/05/2007
Description .. : Constitution de la liste des codes regroupement
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregGroupe(SL: TStringList);
var Ql : TQuery;
    St : string;
    Composant : string;
begin
  SL.Clear;
  Ql := OpenSQL ('SELECT * FROM CHOIXCOD WHERE CC_TYPE="IGI"', True);
  try
    while not Ql.Eof do
    begin
      if Ql.FindField('CC_LIBRE').AsString = 'X' then Composant := 'X'
      else Composant := '-';

      St := 'TRG'
            +Format ( '%-3s',[Copy(Ql.FindField('CC_CODE').AsString,1,3)])       // code
            +Format ( '%-35s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,35)])  // Libell�
            +Format ( '%-1s',[Composant])                                        // Approche par composant
        //    +Format ( '%-14s',[Copy(Ql.FindField('CC_ABREGE').AsString,1,14)])   // Libell� abr�g�
            +Format ( '%-14s',[''])                                              // blancs
            ;
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de la liste des lieux g�ographiques
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregMotifsSorties(SL: TStringList);
var Ql : TQuery;
    St : string;
begin
  SL.Clear;
  Ql := OpenSQL ('SELECT * FROM CHOIXCOD WHERE CC_TYPE="MDC"', True);
  try
    while not Ql.Eof do
    begin
      {modif mbo - 13.09.07 - FQ 21435 -le code est sur 3 positions et non sur 1 position
      St := 'TCE'
            +Format ( '%-1s',[Copy(Ql.FindField('CC_CODE').AsString,1,1)])         // code
            +Format ( '%-15s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,15)])    // libell�
            +Format ( '%5.5d',[0])                                                 // nombre de fois utilis�
            ;
      }
      St := 'TCE'
            +Format ( '%-3s',[Copy(Ql.FindField('CC_CODE').AsString,1,3)])         // code
            +Format ( '%-15s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,15)])    // libell�
            +Format ( '%5.5d',[0])                                                 // nombre de fois utilis�
            ;

      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de la liste des comptes
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregCompte(SL: TStringList);
var Qc : TQuery;
    St : string;
begin
  SL.Clear;
  {$IFDEF SERIE1}
  Qc := OpenSQL ('SELECT G_GENERAL,G_LIBELLE FROM GENERAUX WHERE '
                  +' G_GENERAL IN (SELECT I_COMPTEIMMO FROM IMMO)'
                  +' OR G_GENERAL IN (SELECT I_COMPTELIE FROM IMMO WHERE I_COMPTELIE<>"")'
                  +' GROUP BY G_GENERAL,G_LIBELLE',True);
  {$ELSE}
  Qc := OpenSQL ('SELECT G_GENERAL,G_LIBELLE FROM GENERAUX WHERE G_GENERAL IN '
                  +'(SELECT DISTINCT(I_COMPTEIMMO) COMPTE FROM IMMO UNION '
                  +'( SELECT DISTINCT (I_COMPTELIE) COMPTE FROM IMMO WHERE I_COMPTELIE<>""))',True);
  {$ENDIF SERIE1}
  try
    while not Qc.Eof do
    begin
      St := 'TTC'
            +Format ( '%-10s',[ImBourreEtLess(Qc.FindField('G_GENERAL').AsString,fbGene,10)])     // compte g�n�ral
            +Format ( '%-25s',[Copy(Qc.FindField('G_LIBELLE').AsString,1,25)])                  // libell�
            ;
      SL.Add(St);
      Qc.Next;
    end;
  finally
    Ferme (Qc);
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de l'enregistrement des param�tres du dossier
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregParametre: string;
var Produit, Version : string;
begin
  { enregistrement param�tres }
    // MVG 12/07/2006
    // BTY 05/07 FQ 19820
  if fEnrichi then
  begin
     Produit := 'C';
     Version := '00068';
  end else
  begin
     Produit := '';
     Version := '00099';
  end;

  Result := 'PPA'                                                         // code
            +'     '                                                      // num�ro de dossier
            +Format ( '%-30s',[Copy(GetParamSocSecur('SO_LIBELLE',''),1,30)])     // Libell� du dossier
            +Format ( '%-32s',[Copy(GetParamSocSecur('SO_ADRESSE1',''),1,32)])    // adresse 1
            +Format ( '%-32s',[Copy(GetParamSocSecur('SO_ADRESSE2',''),1,32)])    // adresse 2
            +Format ( '%5s %25s',[Copy(GetParamSocSecur('SO_CODEPOSTAL',''),1,5), // code postal
                                  Copy(GetParamSocSecur('SO_VILLE',''),1,25)])    // ville
            +Format ( '%-20s',[Copy(GetParamSocSecur('SO_TELEPHONE',''),1,20)])   // t�l�phone
            +Format ( '%-1s',[Produit])                                   // FQ 19820
            +Format ( '%-29s',[''])                                       // commentaires sur les 29 car restants
            +'N'                                                          // param�trage lettre inventaire
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Deb)               // D�but exercice
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Fin)               // Fin exercice
            +'0'                                                          // standard s�lectionn�
            +'  '                                                         // type dossierpour liasses fiscales
            +FormatDateTime('ddmmyyyy',VHImmo^.Precedent.Fin)             // Date de derni�re cl�ture
            +'N'                                                          // gestion code stat
            +'N'                                                          // gestion des en-cours
            +'O'                                                          // gestion historique
            +' '                                                          // cl�ture d�j� effectu�e
            +Format ( '%-32s',[''])                                       // activit�
            +Format ( '%-14s',[Copy(GetParamSocSecur('SO_SIRET',''),1,14)])       // siret
            +Format ( '%-4s',[Copy(GetParamSocSecur('SO_APE',''),1,4)])           // code APE
            +Format ( '%-8s',[''])                                        // mot de passe
            {$IFDEF SERIE1}
            +Format ( '%5.5d',[Trunc(GetParamSocSecur('SO_LGCPTGEN',''))])       // longueur des comptes
            {$ELSE}
            +Format ( '%5.5d',[Trunc(GetParamSocSecur('SO_LGCPTEGEN',''))])       // longueur des comptes
            {$ENDIF SERIE1}
            +Format ( '%-5s',[Version])                                   // version du fichier FQ 19820
            +'E'                                                          // monnaie du dossier
            ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... : 25/11/2003
Description .. : Constitution de l'enregistrement exercice
Mots clefs ... :
*****************************************************************}
function TAmImpExp.FaitEnregExercice : string;
begin
  { enregistrement exercices }
  Result := Result
            + 'TEX'
            +FormatDateTime('yyyymmdd',VHImmo^.Encours.Fin)               // date fin exercice
            +FormatDateTime('ddmmyyyy',VHImmo^.Encours.Deb)               // date d�but exercice
            ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Christophe Ayel
Cr�� le ...... : 19/11/2003
Modifi� le ... :   /  /
Description .. : Constitution de la liste codes stat
Mots clefs ... :
*****************************************************************}
procedure TAmImpExp.FaitEnregStat(SL: TStringList);
var Ql : TQuery;
    St : string;
begin
  SL.Clear;
  // MVG 12/07/2006
  {$IFDEF SERIE1}
  Ql := OpenSQL ('SELECT * FROM CHOIXCOD  WHERE CC_TYPE="LI1"', True);
  try
    while not Ql.Eof do
    begin
      St := 'TST'
            +Format ( '%-4s',[Copy(Ql.FindField('CC_CODE').AsString,1,3)])        // code
            +Format ( '%-20s',[Copy(Ql.FindField('CC_LIBELLE').AsString,1,20)])     // libell�
            +Format ( '%5.5d',[0])                                                  // nombre de fois utilis�
            +'  ';
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
  {$ELSE}
  Ql := OpenSQL ('SELECT * FROM NATCPTE WHERE NT_TYPECPTE="I00"', True);
  try
    while not Ql.Eof do
    begin
      St := 'TST'
            +Format ( '%-4s',[Copy(Ql.FindField('NT_NATURE').AsString,4,4)])        // code
            +Format ( '%-20s',[Copy(Ql.FindField('NT_LIBELLE').AsString,1,20)])     // libell�
            +Format ( '%5.5d',[0])                                                  // nombre de fois utilis�
            +'  ';
      SL.Add(St);
      Ql.Next;
    end;
  finally
    Ferme (Ql);
  end;
  {$ENDIF SERIE1}
end;

function TAmImpExp.Montant13(Montant: double): string;
begin
  // FQ 18388
  // R�sultats diff�rents en 2 tiers et en eaglclient sur des ,50 => arrondir avant de formater
  //Result := Format ( '%13.0f',[Montant*100]);
  Result := Format ( '%13.0f',[Arrondi(Montant*100,0)]);
end;

procedure TAmImpExp.EcrireFichier(St: string);
begin
  Writeln ( fFichier , St );
end;

procedure TAmImpExp.EcrireFichier(SL: TStringList);
var i : integer;
begin
  for i:=0 to SL.Count - 1 do
    Writeln ( fFichier, SL[i] )
end;

procedure TAmImpExp.CompresseFichier(stFichier: string);
var stFichierArchive : string;
    TheToz : TOZ;
    stExt : string;
begin
  stExt := ExtractFileExt(stFichier);
  if stExt = '' then stFichierArchive := stFichier + '.zip'
  else stFichierArchive := FindEtReplace(stFichier, stExt, '.zip',False);

  TheToz := TOZ.Create ;
  try
    if TheToz.OpenZipFile ( stFichierArchive, moCreate ) then
    begin
      if TheToz.OpenSession ( osAdd ) then
      begin
        if TheToz.ProcessFile ( stFichier, '' ) then
          TheToz.CloseSession
        else
        begin
          if Assigned ( OnInformation ) then OnInformation ( Self, MSG_ERR_TOZ , -1);
          TheToz.CancelSession ;
        end ;
      end else if Assigned ( OnInformation ) then OnInformation ( Self, MSG_ERR_TOZ , -1);
    end
    else
    begin
      if Assigned ( OnInformation ) then OnInformation ( Self, MSG_ERR_CREATIONARCHIVE , -1);
      exit ;
    end ;
  TheToz.Free;    
  except
    on E: Exception do
      begin
        if Assigned ( OnInformation ) then OnInformation ( Self, 'Toz Error : '+E.Message , -1);
        TheToz.Free;
      end ;
  end;
end;

end.
