unit UTraiteSaisies;

interface

uses sysutils,classes,windows,messages,hmsgbox,
     HEnt1,Ent1,EntGC,UtilPGI,UTOB,Hctrls,ED_TOOLS, paramsoc,
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     fe_main,
     Forms,
		 variants,
     Stdctrls,
     CBPPath,
     AglInit,
     UserChg,
     MajTable,
     Dialogs,
     Inifiles,
     CalcOleGenericBTP,
     AffaireUtil,
     UtilArticle,
     UtilxlsBTP,
     UtilSaisieConso,
     heureUtil,
     UtilFichiers,
     BtpUtil,
     gerepiece;

Var fWorkBook : Variant;
    TOBConso,TOBressources,TOBARTicles : TOB;
    TOBPiece,TOBLignes : TOB;
    LogFile : textfile;
    NbTraiteOk : integer;
    NbTraiteErr : integer;
    LafeuilleCourante : String;
    Nomlog : String;

Function LanceRecupDocument (NaturePiece : String) : Boolean;

Type
  TTypeErreurControle  = (TcdErrNumConso,TcdErrAffaire,TcdErrPhase,TcdErrNatureMouv,TcdErrRessource,TcdErrCodeArticle,TcdErrQte,TcdErrTypeHeure);

implementation
uses FactCommBtp,FactComm;

procedure EnregistreMvt(TOBD: TOB);
var messageErr  : string;
begin
  if TOBD.getValue('BCO_NATUREMOUV') = 'FAN' then
  begin
    if V_PGI.ioError = oeOK then
      MessageErr := Format ('Enregistrement réussi pour le chantier %s, nature %s et fournisseur %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_LIBELLE')])
    else
      MessageErr := Format ('Erreur enregistrement pour le chantier %s, nature %s et fournisseur %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_LIBELLE')]);
  end else if TOBD.getValue('BCO_NATUREMOUV') = 'FOU' then
  begin

    if V_PGI.ioError = oeOK then
      MessageErr := Format ('Enregistrement réussi pour le chantier %s, nature %s et article %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_CODEARTICLE')])
    else
      MessageErr := Format ('Erreur enregistrement pour le chantier %s, nature %s et article %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_CODEARTICLE')]);
  end else
  begin
    if V_PGI.ioError = oeOK then
      MessageErr := Format ('Enregistrement réussi pour le chantier %s, nature %s et ressource %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_RESSOURCE')])
    else
      MessageErr := Format ('Erreur enregistrement pour le chantier %s, nature %s et ressource %s',
                            [TOBD.getValue('BCO_AFFAIRE'),TOBD.getValue('BCO_NATUREMOUV'),TOBD.getValue('BCO_RESSOURCE')]);
  end;

  Writeln(Logfile,messageErr);
end;

procedure EnregistreConso;
var Indice : integer;
		TOBD : TOB;
begin
//
	for Indice := 0 to TOBConso.detail.count -1 do
  begin
  	TOBD := TOBConso.detail[Indice];
  	if TOBD.GetValue('ERREUR') = -1 then
    begin
    	if not TOBD.InsertDB (nil) then
      begin
        V_PGI.ioError := oeUnknown;
  		  inc(NbTraiteErr);
      end else
        V_PGI.ioError := oeOK;

      EnregistreMvt(TOBD);
  		inc(NbTraiteOk);
    end;
  end;
end;

procedure EnregistreFinTrait;
var MessageErr : string;
begin
  MessageErr := Format ('FIN DE TRAITEMENT : %d lignes enregistrées, %d erreurs',[NbTraiteOk, NbTraiteErr]);
  Writeln(Logfile,messageErr);

  PGIBox('Traitement terminé',Application.Title);
end;

function AddArticle(TOBD: TOB): TOB;
var QQ : TQuery;
begin
	result := nil;
	if TOBD.GetValue('BCO_ARTICLE')='' then exit;
  QQ := OpenSql ('SELECT * FROM ARTICLE WHERE GA_ARTICLE="'+TOBD.GetValue('BCO_ARTICLE')+'"',true,-1, '', True);
  if not QQ.eof then
  begin
  	result := TOB.Create ('ARTICLE',TOBArticles,-1);
  	result.selectdb('',QQ);
  end;
  ferme (QQ);
end;

function AddRessource(TOBD: TOB): TOB;
var QQ : TQuery;
begin
  Result := Nil;
  QQ := OpenSql ('SELECT * FROM RESSOURCE WHERE ARS_RESSOURCE="'+TOBD.GetValue('BCO_RESSOURCE')+'"',true,-1, '', True);
  if not QQ.eof then
  begin
  	result := TOB.Create ('RESSOURCE',TOBressources,-1);
  	result.selectdb('',QQ);
  end;
  ferme (QQ);
end;

procedure SetErreur(TOBD: TOB);
var messageErr : string;
		TheErreur : string;
begin
  if TOBD.GetVAlue('ERREUR') = TcdErrNumConso then
  BEGIN
  	TheErreur := 'Problème d''affectation du N° de consommation';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrAffaire then
  BEGIN
  	TheErreur := 'Ce chantier ('+TOBD.GetValue('BCO_AFFAIRE')+') n''existe pas';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrPhase then
  BEGIN
  	TheErreur := 'Cette phase ('+TOBD.GetValue('BCO_PHASETRA')+') sur le chantier ('+TOBD.GetValue('BCO_AFFAIRE')+') n''existe pas';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrNatureMouv then
  BEGIN
  	TheErreur := 'La nature de mouvement ('+TOBD.GetValue('BCO_NATUREMOUV')+')  n''existe pas';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrRessource then
  BEGIN
  	TheErreur := 'La ressource ('+TOBD.GetValue('BCO_RESSOURCE')+')  n''existe pas';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrCodeArticle then
  BEGIN
  	TheErreur := 'La prestation ('+TOBD.GetValue('BCO_CODEARTICLE')+')  n''existe pas';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrQte then
  BEGIN
  	TheErreur := 'La quantité n''est pas renseignée';
	  inc(NbTraiteErr);
  END else
  if TOBD.GEtVAlue('ERREUR') = TcdErrTypeHeure then
  BEGIN
  	TheErreur := 'Le Type d''heure ('+TOBD.GetValue('BCO_TYPEHEURE')+')  n''existe pas';
	  inc(NbTraiteErr);
  END;
  MessageErr := Format ('Anomalie sur %s ligne %s : %s',[LaFeuilleCourante,TOBD.getValue('NOLIGNE'),TheErreur]);
  Writeln(Logfile,messageErr);
end;

procedure FinaliseConsommation(TOBD: TOB);
var Part0				: string;
    Part1				: string;
    Part2				: String;
    Part3				: String;
    Avenant 		: string;
    Code        : string;
    TypRes			: string;
    NumConso    : double;
    Annee     : word;
    Mois      : word;
    Jour      : word;
    Semaine   : integer;
    DateMouv  : TDateTime;
    TOBres,TOBA  : TOB;
begin
  if (GetNumUniqueConso (NumConso) <> Gncabort) then
  begin
  	if TOBD.GetValue('BCO_CODEARTICLE') <> '' then TOBD.putValue('BCO_ARTICLE',CodeArticleUnique (TOBD.GEtValue('BCO_CODEARTICLE'),'','','','',''))
    else  TOBD.putValue('BCO_ARTICLE','');

    TOBA := TOBArticles.findFirst(['GA_ARTICLE'],[TOBD.getValue('BCO_ARTICLE')],true);
    if TOBA = nil then TOBA := AddArticle(TOBD);

  	TOBD.putValue('BCO_NUMMOUV',NumConso);
    Code := TOBD.GetValue('BCO_AFFAIRE');
    BTPCodeAffaireDecoupe (Code,Part0,Part1,Part2,Part3,Avenant,taModif,false);
    TOBD.putValue('BCO_AFFAIRE0',Part0);
    TOBD.putValue('BCO_AFFAIRE1',Part1);
    TOBD.putValue('BCO_AFFAIRE2',Part2);
    TOBD.putValue('BCO_AFFAIRE3',Part3);
    TOBD.putValue('BCO_QTEFACTUREE',TOBD.GetValue('BCO_QUANTITE'));
    TOBD.putValue('BCO_QTEINIT',TOBD.GetValue('BCO_QUANTITE'));
//    if TOBA <> nil then TOBD.putValue('BCO_QUALIFQTEMOUV',TOBA.GetValue('GA_QUALIFUNITEVTE'));

    // Découpage de la date
    DateMouv:=StrToDate(TOBD.GetValue('BCO_DATEMOUV'));
    DecodeDate(DateMouv, Annee, Mois, Jour);
    // Recherche du Numéro de semaine
    Semaine := NumSemaine(DateMouv);

    TOBD.PutValue('BCO_MOIS', Mois);
    TOBD.PutValue('BCO_FACTURABLE', 'N');
    TOBD.PutValue('BCO_VALIDE', '-');
    TOBD.PutValue('BCO_SEMAINE', Semaine);

    calculeLaLigne (TOBD);

    // Mise à jour libellé :
    if (TOBD.GetValue('BCO_NATUREMOUV')<>'FAN') and (TOBA <> Nil) then TOBD.putValue('BCO_LIBELLE',TOBA.GetValue('GA_LIBELLE'));

  end else
  begin
  	TOBD.putValue('ERREUR',TcdErrNumConso);
    SetErreur (TOBD);
    exit;
  end;
end;

procedure ChargeTobConsos(DateSaisie : TDateTime ; CodeAffaire, CodeArticle, NatureMouv : string ; Montant: Double ; Ligne : integer);
var TOBD : TOB;
begin
  If Montant = 0.0 then Exit;

	TOBD := TOB.Create ('CONSOMMATIONS',TOBConso,-1);
  TOBD.InitValeurs;
  AddLesSupLignesConso (TOBD);
  TOBD.AddChampSupValeur ('ERREUR',-1);
	TOBD.addChampSupValeur('NOLIGNE',inttostr(Ligne));
  TOBD.putValue('BCO_AFFAIRE',CodeAffaire);
  TOBD.putValue('BCO_PHASETRA','');
  TOBD.putValue('BCO_DATEMOUV',DateSaisie);
  TOBD.putValue('BCO_NATUREMOUV',NatureMouv);
  if NatureMouv = 'FAN' then
  begin
    TOBD.putValue('BCO_RESSOURCE','');
    TOBD.putValue('BCO_CODEARTICLE','');
    TOBD.putValue('BCO_LIBELLE','Prorata - Reprise LSE');
    TOBD.putValue('BCO_QUANTITE',-1);
    TOBD.putValue('BCO_DPA',Montant);
    TOBD.putValue('BCO_DPR',Montant);
    TOBD.putValue('BCO_PUHT',Montant);
  end else
  begin
    if Naturemouv <> 'FOU' then
      TOBD.putValue('BCO_RESSOURCE',CodeArticle)
    else
      TOBD.putValue('BCO_RESSOURCE','');
    TOBD.putValue('BCO_CODEARTICLE',CodeArticle);
    TOBD.putValue('BCO_QUANTITE',1);
    TOBD.putValue('BCO_DPA',Montant);
    TOBD.putValue('BCO_DPR',Montant);
    TOBD.putValue('BCO_PUHT',0);
  end;
  TOBD.putValue('BCO_QUALIFQTEMOUV','');
  TOBD.putValue('BCO_TYPEHEURE','');
//  ControleDonnee (TOBD);
  if TOBD.GetValue('ERREUR')=-1 then
  begin
  	FinaliseConsommation(TOBD);
  end;
end;


function BeforevalideLeDevis (var RC: TGerePieceRecordTobs) : boolean;
var TOBSS,TOBLF,TOBL,TOBPRG,TOBLRG : TOB;
begin
  result := false;

  TOBL := RC.TobPiece.findfirst(['GL_TYPELIGNE'],['ART'],True);
  if TOBL = nil then exit;

  TOBLRG := RC.TobPiece.findfirst(['GL_TYPELIGNE'],['RG'],True);

// ici on va préparer l'enregistrement de BSITUATIONS, LIGNEFAC et des PIEDBASRG,PIECERG pour la situation cumulative précédente

  // Bsituation de la situation
  TOBSS := TOB.Create('BSITUATIONS',RC.TOBSITUATIONS,-1);
  TOBSS.SetString('BST_NATUREPIECE','FBT');
  TOBSS.SetString('BST_SOUCHE','XXX');
  TOBSS.SetString('BST_NUMEROFAC',RC.TobData.getString('NUMFACSIT'));
  TOBSS.SetString('BST_DATESIT',RC.TobData.getString('DATEDERSIT'));
  TOBSS.SetString('BST_AFFAIRE',RC.TobPiece.GetString('GP_AFFAIRE'));
  TOBSS.SetDouble('BST_MONTANTHT',RC.TobData.GetDouble('DEJAFACTURE'));
  TOBSS.SetDouble('BST_MONTANTTTC',Arrondi(TOBSS.GetDouble('BST_MONTANTHT')*1.2,V_PGI.okdecV));
  TOBSS.SetDouble('BST_MONTANTTVA',TOBSS.GetDouble('BST_MONTANTTTC')-TOBSS.GetDouble('BST_MONTANTHT'));
  TOBSS.SetString('BST_VIVANTE','X');
  TOBSS.SetInteger('BST_INDICESIT',0);
  TOBSS.SetInteger('BST_NUMEROSIT',RC.TobData.GetInteger('NUMSITUATION'));

  // le lignefac de la situation
  TOBLF := TOB.Create ('LIGNEFAC',RC.TOBLigneFac,-1);
  TOBLF.SetString('BLF_NATUREPIECEG','FBT');
  TOBLF.SetString('BLF_SOUCHE','XXX');
  TOBLF.SetString('BLF_NUMERO',RC.TobData.getString('NUMFACSIT'));
  TOBLF.SetInteger('BLF_INDICEG',0);
  TOBLF.SetInteger('BLF_NUMORDRE',TOBL.GetInteger('GL_NUMORDRE'));
  TOBLF.SetDouble('BLF_MTMARCHE',RC.TOBData.GetDouble('MONTANT'));
  TOBLF.SetDouble('BLF_MTCUMULEFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_MTSITUATION',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_QTEMARCHE',RC.TOBData.GetDouble('MONTANT'));
  TOBLF.SetDouble('BLF_QTECUMULEFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_QTESITUATION',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_TOTALTTCDEV',Arrondi(RC.TOBData.GetDouble('DEJAFACTURE')*1.2,V_PGI.okdecV));
  TOBLF.SetDouble('BLF_MTPRODUCTION',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_POURCENTAVANC',Arrondi(RC.TOBData.GetDouble('DEJAFACTURE')/RC.TOBData.GetDouble('MONTANT')*100,2));

  TOBLF := TOB.Create ('PIEDBASE',RC.TobPiedBaseP,-1);
  TOBLF.SetString('GPB_NATUREPIECEG','FBT');
  TOBLF.SetString('GPB_SOUCHE','XXX');
  TOBLF.SetString('GPB_NUMERO',RC.TobData.getString('NUMFACSIT'));
  TOBLF.SetInteger('GPB_INDICEG',0);
  TOBLF.SetString('GPB_CATEGORIETAXE','TN');
  TOBLF.SetString('GPB_CATEGORIETAXE','TX1');
  TOBLF.SetString('GPB_FAMILLETAXE','TN');
  TOBLF.SetDouble('GPB_TAUXTAXE',20);
  TOBLF.SetDouble('GPB_BASETAXE',RC.TobData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('GPB_VALEURTAXE',Arrondi((RC.TobData.GetDouble('DEJAFACTURE')*1.2) - RC.TobData.GetDouble('DEJAFACTURE'),V_PGI.okdecV));
  TOBLF.SetDouble('GPB_BASEDEV',TOBLF.getDouble('GPB_BASETAXE'));
  TOBLF.SetDouble('GPB_VALEURDEV',TOBLF.GetDouble('GPB_VALEURTAXE'));
  TOBLF.SetDouble('GPB_TAUXDEV',1);
  TOBLF.SetDouble('GPB_COTATION',1);
  TOBLF.SetString('GPB_DATETAUXDEV',RC.TobData.getString('DATEDERSIT'));
  TOBLF.SetString('GPB_DEVISE','EUR');
  TOBLF.SetString('GPB_SAISIECONTRE','-');

  if TOBLRG <> nil then
  begin
    // le piecerg de la situation
    TOBPRG := TOB.Create('PIECERG',RC.TOBPieceRGP,-1);
    TOBPRG.SetString('PRG_NATUREPIECEG','FBT');
    TOBPRG.SetString('PRG_SOUCHE','XXX');
    TOBPRG.SetString('PRG_DATEPIECE',RC.TobData.getString('DATEDERSIT'));
    TOBPRG.SetInteger('PRG_NUMERO',RC.TobData.GetInteger('NUMFACSIT'));
    TOBPRG.SetInteger('PRG_INDICEG',0);
    TOBPRG.SetInteger('PRG_NUMLIGNE',TOBLRG.GetInteger('GL_NUMORDRE'));
    TOBPRG.SetString('PRG_TYPERG','TTC');
    TOBPRG.SetDouble('PRG_TAUXRG',5);
    TOBPRG.SetDouble('PRG_MTHTRG',Arrondi(RC.TobData.GetDouble('DEJAFACTURE')*0.05,V_PGI.okdecV));
    TOBPRG.SetDouble('PRG_MTHTRGDEV',TOBPRG.GetDouble('PRG_MTHTRG'));
    TOBPRG.SetDouble('PRG_MTTTCRG',arrondi(TOBPRG.GetDouble('PRG_MTHTRG')*1.2,V_PGI.okdecV));
    TOBPRG.SetDouble('PRG_MTTTCRGDEV',TOBPRG.GetDouble('PRG_MTTTCRG'));
    TOBPRG.SetString('PRG_NUMCAUTION',RC.TOBData.GetString('NUMCAUTION'));
    TOBPRG.SetString('PRG_BANQUECP',RC.TOBData.GetString('BANQUECP'));
    TOBPRG.SetDouble('PRG_CAUTIONMT',RC.TOBData.GetDouble('VALEURCAUTION'));
    TOBPRG.SetDouble('PRG_CAUTIONMTDEV',RC.TOBData.GetDouble('VALEURCAUTION'));
    TOBPRG.SetString('PRG_APPLICABLE','X');

    // le baseRG de la situation
    TOBPRG := TOB.Create('PIEDBASERG',RC.TObbasesRGP,-1);
    TOBPRG.SetString('PBR_NATUREPIECEG','FBT');
    TOBPRG.SetString('PBR_SOUCHE','XXX');
    TOBPRG.SetString('PBR_DATEPIECE',RC.TobData.getString('DATEDERSIT'));
    TOBPRG.SetInteger('PBR_NUMERO',RC.TobData.GetInteger('NUMFACSIT'));
    TOBPRG.SetInteger('PBR_INDICEG',0);
    TOBPRG.SetInteger('PBR_NUMLIGNE',TOBLRG.GetInteger('GL_NUMORDRE'));
    TOBPRG.SetString('PBR_CATEGORIETAXE','TX1');
    TOBPRG.SetString('PBR_FAMILLETAXE','TN');
    TOBPRG.SetDouble('PBR_TAUXTAXE',20);
    TOBPRG.SetDouble('PBR_BASETAXE',Arrondi(RC.TobData.GetDouble('DEJAFACTURE')*0.05,V_PGI.okdecV));
    TOBPRG.SetDouble('PBR_BASEDEV',TOBPRG.GetDouble('PBR_BASETAXE'));
    TOBPRG.SetDouble('PBR_VALEURTAXE',Arrondi(TOBPRG.GetDouble('PBR_BASETAXE')*0.2,V_PGI.okdecV));
    TOBPRG.SetDouble('PBR_VALEURDEV',TOBPRG.GetDouble('PBR_VALEURTAXE'));
    TOBPRG.SetDouble('PBR_TAUXDEV',1);
    TOBPRG.SetString('PBR_DATETAUXDEV',RC.TobData.getString('DATEDERSIT'));
    TOBPRG.SetString('PBR_DEVISE','EUR');
  end;

  result := true;
end;

function AfterValideLeDevis (var RC: TGerePieceRecordTobs) : boolean;
var TOBSS,TOBL,TOBLF,TOBMF,TOBLRG,TOBLL,TOBPRG,TOBPP : TOB;
    RefDevis : string;
    QQ : TQuery;
begin
  result := false;
  TOBL := RC.TobPiece.findfirst(['GL_TYPELIGNE'],['ART'],True);
  if TOBL = nil then exit;
  //
  TOBLRG := RC.TobPiece.findfirst(['GL_TYPELIGNE'],['RG'],True);
  // le lignefac du devis
  TOBLF := TOB.Create ('LIGNEFAC',RC.TOBLigneFac,-1);
  TOBLF.SetString('BLF_NATUREPIECEG',RC.TOBpiece.getString('GP_NATUREPIECEG'));
  TOBLF.SetString('BLF_SOUCHE',RC.TOBpiece.getString('GP_SOUCHE'));
  TOBLF.SetInteger('BLF_NUMERO',RC.TOBpiece.getInteger('GP_NUMERO'));
  TOBLF.SetInteger('BLF_INDICEG',0);
  TOBLF.SetInteger('BLF_NUMORDRE',TOBL.GetInteger('GL_NUMORDRE'));
  TOBLF.SetDouble('BLF_MTMARCHE',RC.TOBData.GetDouble('MONTANT'));
  TOBLF.SetDouble('BLF_MTDEJAFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_MTCUMULEFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_QTEMARCHE',RC.TOBData.GetDouble('MONTANT'));
  TOBLF.SetDouble('BLF_QTEDEJAFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_QTECUMULEFACT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBLF.SetDouble('BLF_TOTALTTCDEV',Arrondi(RC.TOBData.GetDouble('DEJAFACTURE')*1.2,V_PGI.okdecV));
  TOBLF.SetDouble('BLF_POURCENTAVANC',Arrondi(RC.TOBData.GetDouble('DEJAFACTURE')/RC.TOBData.GetDouble('MONTANT')*100,2));
  //
  TOBL.SetDouble('GL_QTESIT',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBL.SetDouble('GL_QTEPREVAVANC',RC.TOBData.GetDouble('DEJAFACTURE'));
  TOBL.SetDouble('GL_POURCENTAVANC',TOBLF.GetDouble('BLF_POURCENTAVANC'));
  TOBL.UpdateDB;

  RefDevis  := EncoderefSel(TOBl);
  TOBMF := TOB.Create ('BTMEMOFACTURE',nil,-1);
  TOBMF.SetString ('BMF_DEVISPRINC',RefDevis);
  TOBMF.SetInteger ('BMF_NUMORDRE',1);
  TOBMF.SetString ('BMF_DEVIS',RefDevis);
  TOBMF.SetString ('BMF_AFFAIRE',RC.TobPiece.GetString('GP_AFFAIRE'));
  TOBMF.SetString ('BMF_AFFAIRE1',RC.TobPiece.GetString('GP_AFFAIRE1'));
  TOBMF.SetString ('BMF_AFFAIRE2',RC.TobPiece.GetString('GP_AFFAIRE2'));
  TOBMF.SetString ('BMF_AFFAIRE3',RC.TobPiece.GetString('GP_AFFAIRE3'));
  TOBMF.SetString ('BMF_NATUREPIECEG',TOBL.GetString('GL_NATUREPIECEG'));
  TOBMF.SetString ('BMF_SOUCHE',TOBL.GetString('GL_SOUCHE'));
  TOBMF.SetInteger ('BMF_NUMERO',TOBL.GetInteger('GL_NUMERO'));
  TOBMF.SetInteger ('BMF_INDICEG',TOBL.GetInteger('GL_INDICEG'));
  TOBMF.SetAllModifie(true);
  TOBMF.InsertDB(nil);
  TOBMF.free;

  if TOBLRG <> nil then
  begin
    TOBLL := TOB.Create('LIGNE',nil,-1);
    TOBLL.SetString('GL_NATUREPIECEG','FBT');
    TOBLL.SetString('GL_SOUCHE','XXX');
    TOBLL.SetString('GL_DATEPIECE',RC.TobData.getString('DATEDERSIT'));
    TOBLL.SetInteger('GL_NUMERO',RC.TobData.GetInteger('NUMFACSIT'));
    TOBLL.SetInteger('GL_INDICEG',0);
    TOBLL.SetInteger('GL_NUMORDRE',TOBLRG.GetInteger('GL_NUMORDRE'));
    TOBLL.SetInteger('GL_NUMLIGNE',TOBLRG.GetInteger('GL_NUMORDRE'));
    TOBLL.SetString('GL_PIECEPRECEDENTE',EncodeRefPiece(TOBLRG));
    TOBLL.SetString('GL_PIECEORIGINE',EncodeRefPiece(TOBLRG));
    TOBLL.SetAllModifie(true); 
    TOBLL.InsertDB(nil);
    TOBLL.Free; 
  end;
  
  if (RC.TobData.getString('CODEGBF')<>'') and (RC.TobData.getdouble('CUMULRBF')<>0) then
  begin
    TOBPP := TOB.Create('PORT',nil,-1);
    TOBLL := TOB.Create('PIEDPORT',nil,-1);
    QQ := OpenSql ('SELECT * FROM PORT WHERE GPO_CODEPORT="'+ RC.TobData.GetString('CODEGBF')+'"',true,1,'',true);
    if not QQ.eof then
    begin
      TOBPP.selectdb('',QQ);
      TOBLL.SetString('GPT_NATUREPIECEG','FBT');
      TOBLL.SetString('GPT_SOUCHE','XXX');
      TOBLL.SetInteger('GPT_NUMERO',RC.TobData.GetInteger('NUMFACSIT'));
      TOBLL.SetInteger('GPT_INDICEG',0);
      TOBLL.SetInteger('GPT_NUMPORT',1);
      TOBLL.SetString('GPT_CODEPORT',RC.TobData.GetString('CODEGBF'));
      TOBLL.SetString('GPT_LIBELLE',TOBPP.GetString('GPO_LIBELLE'));
      TOBLL.SetString('GPT_TYPEPORT',TOBPP.GetString('GPO_TYPEPORT'));
      TOBLL.PutValue('GPT_FAMILLETAXE1', TOBPP.GetValue('GPO_FAMILLETAXE1'));
      TOBLL.PutValue('GPT_COMPTAARTICLE', TOBPP.GetValue('GPO_COMPTAARTICLE'));
      TOBLL.PutValue('GPT_TOTALTTCDEV', RC.TobData.getdouble('CUMULRBF')*-1);
      TOBLL.SetAllModifie(true);
      TOBLL.InsertDB(nil);
    end;
    ferme (QQ);
    TOBLL.Free;
    TOBPP.Free;

  end;


  TOBSS := RC.TOBSITUATIONS.detail[0];
  if TOBSS <> nil then
  begin
    TOBSS.SetString('BST_SSAFFAIRE',RC.TobPiece.GetString('GP_AFFAIREDEVIS'));
    TOBSS.SetAllModifie(true);
    TOBSS.InsertDB(nil);
  end;
  
  if RC.TOBLigneFac.detail.count > 0 then
  begin
    RC.TOBLigneFac.SetAllModifie(true);
    RC.TOBLigneFac.InsertDB(nil);
  end;

  if RC.TobPiedBaseP.detail.count > 0 then
  begin
    RC.TobPiedBaseP.SetAllModifie(true);
    RC.TobPiedBaseP.InsertDB(nil);
  end;

  if RC.TOBPieceRGP.detail.count > 0 then
  begin
    TOBPRG := RC.TOBPieceRGP.detail[0];
    TOBPRG.SetInteger('PRG_NUMLIGNE',TOBLRG.GetInteger('GL_NUMORDRE'));
    RC.TOBPieceRGP.SetAllModifie(true);
    RC.TOBPieceRGP.InsertDB(nil);
  end;

  if RC.TObbasesRGP.detail.count > 0 then
  begin
    RC.TObbasesRGP.SetAllModifie(true);
    RC.TObbasesRGP.InsertDB(nil);
  end;
  result := true;

end;


Function TraiteLesDevis : Boolean;
Var i, lig, col, nbcol : integer;
    Chaine, CodeAffaire, Article, Quantite, Unite, Datepiece : String;
    Qte, Montant : Double;
begin
//      PgiInfo ('Traitement Devis','');

  Result := True;
  LaFeuilleCourante := 'Feuil1';
  For i:=2 to 1000 Do
  begin
    MoveCurProgressForm('Traitement '+LafeuilleCourante+' en cours ...');
    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'A'+intToStr(i));
    if Chaine = '' then Exit;

    CodeAffaire := 'A'+Copy(Chaine,1,9)+'     00';

    // Création pour entete piece
    TOBPiece := Tob.Create ('', nil, -1);

    TobPiece.AddChampSupValeur ('NATUREPIECEG', 'DBT');
    TobPiece.AddChampSupValeur ('AFFAIRE', CodeAffaire);
    TobPiece.AddChampSupValeur ('TIERS', getTiersAffaire(CodeAffaire));
    TobPiece.AddChampSupValeur ('ETABLISSEMENT', GetParamSocSecur('SO_ETABLISDEFAUT','001'));
    TobPiece.AddChampSupValeur ('DOMAINE', '');
    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'B'+intToStr(i));
    if (Chaine <> '') and (IsvalidDate(Chaine)) then TobPiece.AddChampSupValeur ('DATEPIECE', StrToDate(Chaine))
                                                else TobPiece.AddChampSupValeur ('DATEPIECE', StrToDate('01/01/2015'));
    DatePiece := TobPiece.Getvalue ('DATEPIECE');
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'D'+intToStr(i));
    TobPiece.AddChampSupValeur ('REFINTERNE', chaine + ' - Reprise LSE');
    TobPiece.AddChampSupValeur ('ETATAFFAIRE', 'ACP');

    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'E'+intToStr(i));
    Montant := valeur(Chaine);
    TobPiece.AddChampSupValeur ('MONTANT', valeur(Chaine));

    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'F'+intToStr(i));
    TobPiece.AddChampSupValeur ('DEJAFACTURE', valeur(Chaine));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'H'+intToStr(i));
    TobPiece.AddChampSupValeur ('CUMULRG', valeur(Chaine));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'I'+intToStr(i));
    TobPiece.AddChampSupValeur ('CUMULRBF', valeur(Chaine));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'J'+intToStr(i));
    TobPiece.AddChampSupValeur ('VALEURCAUTION', valeur(Chaine));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'K'+intToStr(i));
    TobPiece.AddChampSupValeur ('NUMCAUTION', Chaine);
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'L'+intToStr(i));
    TobPiece.AddChampSupValeur ('NUMSITUATION', StrToInt(Chaine));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'M'+intToStr(i));
    if (Chaine <> '') and (IsvalidDate(Chaine)) then TobPiece.AddChampSupValeur ('DATEDERSIT', StrToDate(Chaine))
                                                else TobPiece.AddChampSupValeur ('DATEDERSIT', StrToDate('30/12/2015'));
    TOBPiece.AddChampSupValeur ('NUMFACSIT', Format('2015%04d',[I-1]));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'N'+intToStr(i));
    TobPiece.AddChampSupValeur ('BANQUECP', Chaine);
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'O'+intToStr(i));
    TobPiece.AddChampSupValeur ('CODEGBF', Chaine); // ocde garantie bonne fin

    // Création pour maj lignes de pièce : total devis
    Article := 'REP_DEVIS';
    Qte := 1.0;
    Unite := '';

    TobLignes := Tob.Create ('', TobPiece, -1);

    TobLignes.AddChampSupValeur ('TYPELIGNE', 'ART');
    TobLignes.AddChampSupValeur ('CODEARTICLE', Article);
    TobLignes.AddChampSupValeur ('ARTICLE', CodeArticleUnique (Article,'','','','',''));
    TobLignes.AddChampSupValeur ('LIBELLE', GetLibelleMateriaux(TOBLignes.GetValue('ARTICLE')));
    TobLignes.AddChampSupValeur ('QTEFACT', Montant);
    TobLignes.AddChampSupValeur ('QUALIFQTE', Unite);
    TobLignes.AddChampSupValeur ('DATELIVRAISON', DatePiece);
    TobLignes.AddChampSupValeur ('DEPOT', GetParamsocsecur('SO_GCDEPOTDEFAUT','001'));
    TobLignes.AddChampSupValeur ('PUHTDEV', Qte);
    TobLignes.AddChampSupValeur ('PUHT', Qte);
    TobLignes.AddChampSupValeur ('DPA', 0.0);
    TobLignes.AddChampSupValeur ('DPR', 0.0);
    TobLignes.AddChampSupValeur ('AVECPRIX', 'X');

    if (TOBPiece.GetDouble('CUMULRG')<> 0) or (TOBPiece.GetDouble('VALEURCAUTION')<> 0)  then
    begin
      TobPiece.AddChampSupValeur ('BASERG', Montant);
      TobLignes := Tob.Create ('', TobPiece, -1);
      TobLignes.AddChampSupValeur ('TYPELIGNE', 'RG');
      TobLignes.AddChampSupValeur ('CODEARTICLE', '');
      TobLignes.AddChampSupValeur ('ARTICLE', '');
      TobLignes.AddChampSupValeur ('LIBELLE', 'Retenue de garantie TTC 5%');
      TobLignes.AddChampSupValeur ('QTEFACT', 1);
      TobLignes.AddChampSupValeur ('QUALIFQTE', '');
      TobLignes.AddChampSupValeur ('DATELIVRAISON', '01/01/1900');
      TobLignes.AddChampSupValeur ('DEPOT', GetParamsocsecur('SO_GCDEPOTDEFAUT','001'));
      TobLignes.AddChampSupValeur ('PUHTDEV', Arrondi(Montant * 0.05,V_PGI.okdecV));
      TobLignes.AddChampSupValeur ('PUHT', Arrondi(Montant * 0.05,V_PGI.okdecV));
      TobLignes.AddChampSupValeur ('DPA', 0.0);
      TobLignes.AddChampSupValeur ('DPR', 0.0);
      TobLignes.AddChampSupValeur ('AVECPRIX', 'X');
    end;

    if (TOBPiece <> nil) and (TOBPiece.Detail.count > 0) then
    begin
      CreatePieceFromTob (TobPiece,BeforevalideLeDevis,AfterValideLeDevis,'ACP');
    end;

    TOBPiece.free;
    TOBPiece := nil;
  end;
end;

Function TraiteLesCF : Boolean;
Var i, lig, col, nbcol : integer;
    Chaine, CodeAffaire, Article, Quantite, Unite, Datepiece, DateLivraison : String;
    Qte, Montant : Double;
begin
//      PgiInfo ('Traitement CF','');

  Result := True;
  LaFeuilleCourante := 'Feuil1';
  For i:=2 to 1000 Do
  begin
    MoveCurProgressForm('Traitement '+LafeuilleCourante+' en cours ...');
    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'A'+intToStr(i));
    if Chaine = '' then Exit;

    CodeAffaire := 'A'+Copy(Chaine,1,9)+'     00';

    // Création pour entete piece
    TOBPiece := Tob.Create ('', nil, -1);

    TobPiece.AddChampSupValeur ('NATUREPIECEG', 'CF');
    TobPiece.AddChampSupValeur ('AFFAIRE', CodeAffaire);
    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'D'+intToStr(i));
    TobPiece.AddChampSupValeur ('TIERS', chaine);
    TobPiece.AddChampSupValeur ('ETABLISSEMENT', GetParamSocSecur('SO_ETABLISDEFAUT','001'));
    TobPiece.AddChampSupValeur ('DOMAINE', '');
    DatePiece := ExcelGetValue(fWorkBook, LaFeuilleCourante,'B'+intToStr(i));
    TobPiece.AddChampSupValeur ('DATEPIECE', StrToDate(DatePiece));
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'C'+intToStr(i));
    TobPiece.AddChampSupValeur ('REFINTERNE', chaine + ' - Reprise LSE');
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'G'+intToStr(i));
    TobPiece.AddChampSupValeur ('REFEXTERNE', chaine);
    chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'H'+intToStr(i));
    TobPiece.AddChampSupValeur ('RESSOURCE', chaine);
    DateLivraison := ExcelGetValue(fWorkBook, LaFeuilleCourante,'I'+intToStr(i));
    if DateLivraison = '' then DateLivraison :=  DatePiece;
    TobPiece.AddChampSupValeur ('DATELIVRAISON', StrToDate(DateLivraison));

    // Création pour maj lignes de pièce : total devis
    Article := 'REP_' + ExcelGetValue(fWorkBook, LaFeuilleCourante,'F'+intToStr(i));;
    Article := UpperCase( Article);
    Montant := 1.0;
    Unite := '';
    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'E'+intToStr(i));
    Qte := StrToFloat(Chaine);

    TobLignes := Tob.Create ('', TobPiece, -1);

    TobLignes.AddChampSupValeur ('TYPELIGNE', 'ART');
    TobLignes.AddChampSupValeur ('CODEARTICLE', Article);
    TobLignes.AddChampSupValeur ('ARTICLE', CodeArticleUnique (Article,'','','','',''));
    TobLignes.AddChampSupValeur ('LIBELLE', GetLibelleMateriaux(TOBLignes.GetValue('ARTICLE')));
    TobLignes.AddChampSupValeur ('QTEFACT', Qte);
    TobLignes.AddChampSupValeur ('QUALIFQTE', Unite);
    TobLignes.AddChampSupValeur ('DEPOT', GetParamsocsecur('SO_GCDEPOTDEFAUT','001'));
    TobLignes.AddChampSupValeur ('PUHTDEV', Montant);
    TobLignes.AddChampSupValeur ('PUHT', Montant);
    TobLignes.AddChampSupValeur ('DPA', Montant);
    TobLignes.AddChampSupValeur ('DPR', Montant);
    TobLignes.AddChampSupValeur ('AVECPRIX', 'X');
    TobLignes.AddChampSupValeur ('DATELIVRAISON', StrToDate(DateLivraison));

    if (TOBPiece <> nil) and (TOBPiece.Detail.count > 0) then
    begin
      CreatePieceFromTob (TobPiece);
    end;

    TOBPiece.free;
    TOBPiece := nil;
  end;
end;

Function TraiteLesConsos : Boolean;
Var i, lig, col, nbcol : integer;
    Chaine, CodeAffaire : String;
    Montant : Double;
begin
//      PgiInfo ('Traitement Cumule A date','');
  Result := True;
  LaFeuilleCourante := 'Feuil1';
  For i:=2 to 1000 Do
  begin
    MoveCurProgressForm('Traitement '+LafeuilleCourante+' en cours ...');

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'A'+intToStr(i));
    if Chaine = '' then Exit;

    CodeAffaire := 'A'+Copy(Chaine,1,9)+'     00';

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'B'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_BEENT', 'MO', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'C'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_BEINT', 'EXT', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'D'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_BEST', 'EXT', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'E'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_MOOUV', 'MO', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'F'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_MOTEC', 'MO', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'G'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_MOINT', 'EXT', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'H'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_MOST', 'EXT', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'I'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_SSTAC', 'EXT', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'J'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_ACHFM', 'FOU', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'K'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, 'REP_FRDIV', 'LOC', Montant, i);

    Chaine := ExcelGetValue(fWorkBook, LaFeuilleCourante,'L'+intToStr(i));
    Montant := StrToFloat(Chaine);
    // Traitement de la ligne
    ChargeTOBConsos(V_PGI.DateEntree, CodeAffaire, '', 'FAN', Montant, i);

    end;
end;

Function TraiteLesDonnees (filename, Typ : String) : Boolean;
begin
  Result := True;
  LaFeuilleCourante := '';

  // tester existence affaire
  Application.BringToFront;
  Application.ShowMainForm:=True;

  NomLog := ChangeFileExt (filename,'.log');
  AssignFile (LogFile,NomLog);
  rewrite(Logfile);

  TOBConso := TOB.Create ('LES CONSO',nil,-1);
  TOBressources := TOB.Create ('LES RESSOURCES',nil,-1);
	TOBArticles := TOB.Create ('LES ARTICLES',nil,-1);

  TOBPiece := nil;

  NbTraiteOk := 0;

  if Typ = 'DBT' then
    TraiteLesDevis
  else if Typ = 'CF' then
    TraiteLesCF
  else if Typ = 'CONSOS' then
    TraiteLesConsos;

  if TOBConso.detail.count > 0 then
  begin
    EnregistreConso;
    TOBConso.ClearDetail;
  end;

	EnregistreFinTrait;

  TOBConso.free;
  TOBressources.free;
  TOBArticles.free;

  CloseFile(logfile);

end;

Function LanceRecupDocument (NaturePiece : String) : Boolean;
var filename, LocalRepert, filenamecourt, filenamearchive : string;
    IniPGIFile : Tinifile;
    ODExcelFile: TOpenDialog;
    fWinExcel: OleVariant;
    fnewInst : boolean;
    Affaire, CodeAffaire : String;
    DateSaisie : TDateTime;
begin
  Result := True;

  InitMoveProgressForm(Application.MainForm,Application.Title, 'Traitement en cours, veuillez patienter...', 200, False, true) ;

  ODExcelFile := TOpenDialog.create(nil) ;
  ODExcelFile.Filter := 'fichiers Excel (*xls;*xlsx)|*.xls;*.xlsx';
  if ODExcelFile.execute then
  begin
    Filename := ODexcelFile.FileName;
  end;
  ODExcelFile.free;

  if filename <> '' then
  begin
    if not OpenExcel(true,fWinExcel,fNewInst) then
    begin
      PgiError ('Excel n''est pas installé sur ce poste','');
      Result:=False;
      FiniMoveProgressForm ;
      exit;
    end;
    fWorkBook := OpenWorkBook(filename ,fWinExcel);
    TRY
//      PgiInfo ('Traitement du document Excel : '+filename,'');
      Result:=TraiteLesDonnees (filename, NaturePiece);
    EXCEPT
      PgiInfo ('Traitement impossible du document Excel','');
      Result:=False;
    END;

    ExcelClose (fwinExcel);
  end;

  FiniMoveProgressForm ;

end ;

end.

