unit UImportLigneExcelFac;

interface
uses sysutils,classes,windows,messages,controls,forms,hmsgbox,stdCtrls,clipbrd,nomenUtil,
     HCtrls,SaisUtil,HEnt1,Ent1,EntGC,UtilPGI,UTOB,HTB97,FactUtil,FactComm,Menus,
     FactTOB, FactPiece, FactArticle,
		 UtilXlsBTP,EtudesExt,ed_tools,variants,
{$IFDEF EAGLCLIENT}
  maineagl,
{$ELSE}
  Doc_Parser,DBCtrls, Db,  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} fe_main,UserChg,AglIsoflex,
{$ENDIF}
{$IFDEF BTP}
 FactOuvrage,BTPUtil, CalcOLEGenericBTP,
{$ENDIF}
 facture,
 FactCpta,
 ParamSoc,FactCalc,
 UtilSuggestion,
 UtilArticle;

type

	TimportLigneFacture = class (Tobject)
  	private
      uForm : TForm;
      fdocExcel : string;
      fWinExcel: OleVariant;
      fLignePGI : integer;
      LigneIni : integer;
      WorkBook,WorkSheet : Variant;
      TOBL : TOB;
    procedure TraitePrixLigneCourante(TOBL: TOB; Pu: double);
    procedure TraitePrixRevientLigneCourante(TOBL: TOB; PR: double);
    public
      TOBPiece,TOBTiers,TOBAffaire,TOBArticles,TOBART,TOBOuvrage,TOBOuvrageP : TOB;
      TOBBases,TOBBasesL,TOBPorcs,TOBpieceRG,TOBbasesRG,TOBConds,TOBTarif : TOB;
      DEV : RDevise;
    	constructor create;
      destructor destroy; override;
    	procedure ajusteDocument;
      procedure execute;
      property documentPGI :TForm write uForm;
      property documentExcel : string read fdocExcel write fdocExcel ;
      property LignePGI : integer read fLignePGI write fLignePGI ;
    	function findTobArt(ArticleDivers: string): TOB;
  end;
implementation
uses factspec,factureBTP,FactDomaines;

{ TimportLigneFacture }

constructor TimportLigneFacture.create;
begin
  fWinExcel := unassigned;
  TOBTarif := TOB.Create ('TARIF',nil,-1);
end;

destructor TimportLigneFacture.destroy;
begin
  if not VarIsEmpty(fWinExcel) then fWinExcel.Quit;
  fWinExcel := unassigned;
  FreeAndNil(TOBTarif);
  inherited;
end;

procedure TimportLigneFacture.execute;
var WinNew : boolean;
		LigneXls,Vide,Error,Integre : integer;
    CodeArticle,Qte,Designation,Pu,ArticleDivers,PR,Ua : string;
    PxAch,Px,CoefuaUs : double;
    Rem : double;
begin
	if fdocExcel = '' then exit;
  //
  LigneIni := fLignePGI;
  ArticleDivers := GetParamSoc ('SO_BTARTICLEDIV');
  ArticleDivers := CodeArticleUnique(ArticleDivers,'','','','','');

  //
  if not OpenExcel (true,fWinExcel,WinNew) then
  begin
    PGIBox (TraduireMemoire('Liaison Excel impossible'),'Liaison EXCEL');
    FDocExcel := '';
    exit;
  end;
  WorkBook := OpenWorkBook (FDocExcel ,fWinExcel);
  WorkSheet := SelectSheet (WorkBook,'Feuil1');
  LigneXls := 0;
  vide := 1;
  Integre := 0;
  Error := 0;
  repeat
  	if Vide > 20 then break;
  	inc(LigneXls);
		CodeArticle := GetExcelFormated (WorkSheet,LigneXls,2);
    designation := trimright(trimleft(GetExcelText (WorkSheet,LigneXls,3)));
		Qte := GetExcelText (WorkSheet,LigneXls,1);
    if pos(',',Qte) > 0 then StringReplace (Qte,',','.',[rfReplaceAll]);
		Pu := GetExcelText (WorkSheet,LigneXls,4);
    if pos(',',pu) > 0 then StringReplace (pu,',','.',[rfReplaceAll]);
    // Pas de récupération du PR en document d'achat
    if (TOBPiece.GetValue('GP_VENTEACHAT') = 'ACH') then
    begin
       PR := ''
    end else
    begin
      PR := GetExcelText (WorkSheet,LigneXls,5);
      if pos(',',pR) > 0 then StringReplace (pR,',','.',[rfReplaceAll]);
    end;

    // pour éliminer ligne entête :
    if (CodeArticle<>'') and (qte<>'') and (designation<>'') and (pu<>'') and (valeur(Qte)=0) then continue;

    if (CodeArticle='') or (qte='') or (valeur(Qte)=0) then
    begin
      inc(vide);
      if (CodeArticle<>'') or (qte<>'')  or (designation<>'') or (pu<>'') then inc(error);
      continue;
    end;
    vide := 0;
    TOBART := findTobArt(CodeArticleUnique2(CodeArticle, ''));
    if (TOBART = nil) and (ArticleDivers <> '') then
    begin
    	TOBART := findTobArt(ArticleDivers);
    end;
    if TOBART= nil then BEGIN inc(Error); continue; END;
    TOBL := Newtobligne (TOBPiece,fLignePgi);
    InitialiseTOBLigne(TOBPiece,TOBTiers,TOBAffaire,flignePgi,false) ;
    TOBL.PutValue('GL_ARTICLE',TOBART.GetValue('GA_ARTICLE'));
    TOBL.PutValue('GL_TYPELIGNE','ART');
    TOBL.PutValue('GL_TYPEARTICLE',TOBART.GetValue('GA_TYPEARTICLE'));
    TOBL.PutValue('GL_CODEARTICLE',TOBART.GetValue('GA_CODEARTICLE'));
    TOBL.putValue('GL_REFARTSAISIE',TOBART.GetValue('GA_CODEARTICLE'));
    TOBL.PutValue('GL_REFARTBARRE', TOBART.GetValue('GA_CODEBARRE'));
    TOBL.PutValue('GL_PRIXPOURQTE', TOBART.GetValue('GA_PRIXPOURQTE'));
    TOBL.PutValue('GL_LIBELLE', TOBART.GetValue('GA_LIBELLE'));
    if GetInfoParPiece(TOBPiece.getValue('GP_NATUREPIECEG'), 'GPP_BLOBART') = 'X' then TOBL.PutValue('GL_BLOCNOTE', TOBART.GetValue('GA_BLOCNOTE'));
    TOBL.PutValue('GL_TYPEREF', 'ART');
    TOBL.PutValue('GL_RECALCULER','X');
    TOBL.PutValue('GL_IDENTIFIANTWOL',GetParamSocSecur ('SO_BTLIVCHANTIER',True));
    ArticleVersLigne (TOBPiece,TOBART,TobConds,TOBL,TOBTiers);
//  Récupération remises fournisseur si document d'achat et pas de pu renseigné sur la ligne
    if (TOBPiece.GetValue('GP_VENTEACHAT') = 'ACH') and (valeur(Pu) = 0) then
    begin
    	rem := 0;
      TOBTARIF.InitValeurs;
      PxAch := RecupTarifAch(TOBART, TOBTarif, TOBTiers,Ua,CoefUaUs,TurAchat, false,true);
			if Ua <> '' then TOBL.putValue('GL_QUALIFQTEVTE',UA);

      if PxAch <> 0 then BEGIN Px := PxAch; TOBL.PutValue ('FROMTARIF','X'); TOBL.PutValue('GL_DPA',Px); END
      							else Px := TOBL.GetValue('GL_PUHTDEV');
      Rem := TOBTarif.GetValue('GF_REMISE');
      TOBL.PutValue('GL_PUHTDEV',Px);
      TOBL.PutValue('GL_COEFCONVQTE',CoefUaUs);
      TOBL.PutValue('GL_REMISELIGNE', Rem);
      TOBL.PutValue('GL_REMISECASCADE', TOBTarif.GetValue('GF_CASCADEREMISE'));
    end;
//
    TraiteLesOuvrages(nil, TOBPiece, TOBArticles, TOBOuvrage ,nil, fLignePGI, False, DEV, true);
    if (designation<>'') then
    begin
      TOBL.putValue('GL_LIBELLE',copy(designation,1,70));
    end;
    TOBL.PutValue('GL_QTEFACT', Qte);
    TOBL.PutValue('GL_QTERESTE', Qte);
    TOBL.PutValue('GL_QTESTOCK', Qte);

    if TOBPiece.getValue('GP_DOMAINE')<>'' then
    begin
    	TOBL.putvalue('GL_DOMAINE',TOBPiece.getValue('GP_DOMAINE'));
    end;
    if TOBART.getValue('GA_PRIXPASMODIF')<>'X' Then
    begin
      AppliqueCoefDomaineLig (TOBL);
    end;

    if valeur(Pu) <> 0 then
    begin
    	TraitePrixLigneCourante (TOBL,valeur(Pu));
    end;
    if valeur(PR) <> 0 then
    begin
    	TraitePrixRevientLigneCourante (TOBL,valeur(Pr));
    end;
    inc(fLignePGI);
    inc(Integre);
  until LigneXls > 5000;
  if fLignePGi <> LigneINi then
  begin
   	NumeroteLignesGC (nil,TOBPiece);
    PgiInfo (format('%d enregistrements intégrés - %d erreurs rencontrées',[integre,error]));
  end;
end;

function TimportLigneFacture.findTobArt (ArticleDivers : string) : TOB;
var TOBA : TOB;
    QQ : Tquery;
begin
  result := nil;
  TOBA := TOBArticles.FindFirst (['GA_ARTICLE'],[ArticleDivers],true);
  if TOBA = nil then
  begin
    QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE FROM ARTICLE A '+
    							 'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
    							 'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+ArticleDivers+'"',true,-1,'',true);
    if not QQ.eof then
    begin
      TOBA := TOB.create ('ARTICLE',TOBArticles,-1);
      TOBA.SelectDB ('',QQ);
      InitChampsSupArticle (TOBA);
      CalculePrixArticle (TOBA);
      result := TOBA;
    end;
    ferme (QQ);
  end else result := TOBA;
end;

procedure TimportLigneFacture.ajusteDocument;
var indice : integer;
    TOBL : TOB;
    IndiceOuv : integer;
begin
  {$IFDEF BTP}
  for Indice := LigneIni to TOBPiece.detail.count -1 do
  begin
    TOBL := TOBpiece.detail[indice];
    IndiceOuv := TOBL.GetValue('GL_INDICENOMEN');
    if (IndiceOuv > 0) and (IsOuvrage(TOBL)) then ReAffecteLigOuv(IndiceOuv, TobL, TobOuvrage);
  end;
  {$ENDIF}
end;

procedure TimportLigneFacture.TraitePrixLigneCourante (TOBL : TOB;Pu : double);
var TypeArticle : string;
		EnHt : boolean;
begin
//
	TypeArticle := TOBL.getValue('GL_TYPEARTICLE');
  EnHt := (TOBPiece.getValue('GP_FACTUREHT')='X');
  if (TypeArticle = 'OUV') or (TypeArticle = 'ARP') then
  begin
  	TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL,TOBOuvrage, EnHt, Pu,0,DEV,false);
  end;
//
  if EnHt then
  begin
    TOBL.PutValue('GL_PUHTDEV',Pu);
    TOBL.putValue('GL_PUHT',DEVISETOPIVOTEx (Pu,DEV.Taux,DEV.Quotite,V_PGI.okdecP));
  end else
  begin
    TOBL.PutValue('GL_PUTTCDEV',Pu);
    TOBL.putValue('GL_PUTTC',DEVISETOPIVOTEx (Pu,DEV.Taux,DEV.Quotite,V_PGI.okdecP));
  end;
//
	TOBL.putValue('GL_BLOQUETARIF','X');
end;

procedure TimportLigneFacture.TraitePrixRevientLigneCourante(TOBL: TOB; PR: double);
var TypeArticle : string;
		TOBOUV,TOBOA : TOB;
begin
	TypeArticle := TOBL.getValue('GL_TYPEARTICLE');
  if (TypeArticle = 'OUV') then exit;
  //
  TOBL.putValue('GL_DPR',PR);
  if TOBL.getValue('GL_DPA') <> 0 then
  begin
  	TOBL.putValue('GL_COEFFG',Arrondi((TOBL.getValue('GL_DPR')/TOBL.getValue('GL_DPA'))-1,4));
  end else
  begin
  	TOBL.putValue('GL_COEFFG',0);
  end;
  TOBL.putValue('GL_COEFMARG',0);
	if (TypeArticle = 'ARP') then
  begin
    if TOBL.getValue('GL_INDICENOMEN') = 0 then exit;
    TOBOUV := TOBOuvrage.detail[TOBL.getValue('GL_INDICENOMEN')-1];
    if TOBOUV = nil then exit;
    TOBOA := TOBOUV.detail[0].detail[0];
    if TOBOA = nil then exit;
    TOBOA.putValue('BLO_DPR',Pr);
    TOBOA.putValue('BLO_COEFFG',0);
    TOBOA.putValue('BLO_COEFMARG',0);
  end;
end;


end.
