unit UExportPiece;

interface
uses
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
     MaineAGL,
{$ENDIF}
		 Hent1,TiersUtil,
		 HMsgBox,UTOB, uEntCommun, SysUtils, variants, HCtrls,HRichOle,HTB97,forms,controls,UdefExport,ParamSoc;

type
	TExportDocTOB = class (Tobject)
  	private
    	fTOBresult : TOB;
    	fTOBInterm : TOB;
      fTypeExport : TTypeExport;
      fTOBadresses : TOB;
      fTOBOuvrageI : TOB;
    	fAffaire : string;
      fcledoc : R_CLEDOC;
      fTOBpiece : TOB;
      fTOBOuvrage   : TOB;
      fFournisseur  : string;
      fNomFrs       : String;
      fTexte : THRichEditOLE;
      fInternalWindow : TToolWindow97;

      //
      procedure constitueTOBviaAffaire;
      procedure constitueTOBviaDocument;
      procedure InternalTOBViaDocument (LocalCledoc: R_CLEDOC);
      procedure EnlevepasConcerne (TOBinMem : boolean=false);
      procedure Nettoieparagraphes;
      procedure GetDetailOuvrage (TOBL,TOBOD : TOB);
    	procedure GetDetailFromTOB(TOBL, TOBOD: TOB);
    	function IsDetailInside(IndDep: integer; TOBL: TOB): boolean;
    	procedure SuprimeThisParagraphe(TOBL: TOB; var IndDep: integer);
    	procedure constitueTOBviaCledoc;
    	procedure constitueTOBviaTOB;
    	procedure PutValeur(fTOB, sTOB: TOB);
    	function AddEnteteInterm (TOBP : TOB) : TOB;
    	function AddTOBInterm(TOBpere: TOB): TOB;
      function IsBlocNoteVide(texte: THRichEditOLE;BlocNote: String): boolean;
    public
    	constructor create;
      destructor destroy; override;
      property Affaire : string read fAffaire write fAffaire ;
      property CleDoc : R_CLEDOC  read fcledoc write fcledoc;
      property TOBpiece : TOB  read fTOBpiece write fTOBpiece;
      property TOBouvrage : TOB  read fTOBOuvrage write fTOBOuvrage;
      property Fournisseur : string read fFournisseur write fFournisseur ;
      property NomFrs     : string read fNomFrs write fNomFrs ;
      property TypeExport : TTypeExport read fTypeExport write fTypeExport;
      property TOBResult : TOB read fTOBresult write fTOBresult ;
      procedure constitueExport;
  end;


implementation
uses UtilTOBpiece,factUtil,FactureBTP,FactVariante,FactAdresse,CalcOlegenericBTP;
{ TExportDocTOB }

procedure TExportDocTOB.constitueExport;
begin
  if (faffaire = '') and (fcledoc.NaturePiece = '') and (fTobpiece=nil) then exit;
  if (fTOBresult = nil) then PgiInfo('TOB de sortie non définie');
  if faffaire <> '' then
  begin
  	constitueTOBviaAffaire;
  end else
  begin
		constitueTOBviaDocument;
  end;
end;

procedure TExportDocTOB.constitueTOBviaAffaire;
var QQ : TQuery;
		TOBpieces,fTOB,sTOB,PTOB,TOBA : TOB;
		localCledoc : r_cledoc;
    indice,Ind : integer;
begin
  if fAffaire = '' then exit;
  TOBpieces := TOB.create ('LES PIECES',nil,-1);
  TOBA := TOB.create ('AFFAIRE',nil,-1);
  QQ := OpenSql ('SELECT AFF_LIBELLE FROM AFFAIRE WHERE AFF_AFFAIRE="'+faffaire+'"',true,1,'',true);
  if not QQ.eof then
  begin
  	TOBA.selectDb('',QQ);
  end;
  ferme (QQ);
  TRY
    //
    QQ := OpenSql ('SELECT GP_NATUREPIECEG,GP_SOUCHE,GP_NUMERO,GP_INDICEG,GP_REFEXTERNE,GP_REFINTERNE,GP_DATEPIECE,GP_TIERS FROM PIECE WHERE GP_AFFAIRE="'+fAffaire+'" AND GP_NATUREPIECEG="DBT"',true,-1,'',true);
    if not QQ.eof then
    begin
      TOBpieces.loaddetailDB('PIECE','','',QQ,false);
    end;
    ferme (QQ);
    //
    for Indice := 0 to TOBpieces.detail.count -1 do
    begin
      fillChar(LocalCledoc,sizeof(LocalcleDoc),#0);
      //
      LocalCleDoc.NaturePiece :=  TOBpieces.detail[Indice].getValue('GP_NATUREPIECEG');
      LocalCleDoc.Souche :=  TOBpieces.detail[Indice].getValue('GP_SOUCHE');
      LocalCleDoc.NumeroPiece :=  TOBpieces.detail[Indice].getValue('GP_NUMERO');
      LocalCleDoc.Indice :=  TOBpieces.detail[Indice].getValue('GP_INDICEG');
      //
      fTOBresult.putValue('DESCRIPTIF',TOBA.getvalue('AFF_LIBELLE'));
      InternalTOBViaDocument (LocalCledoc);
      if fTOBInterm.detail.count > 0 then
      begin
        PTOB := AddEnteteInterm(fTOBinterm);
        for ind := 0 to fTOBinterm.detail.count -1 do
        begin
        	fTOB := fTOBInterm.detail[Ind];
          sTOB := AddTOBInterm (PTOB);
          PutValeur(fTOB,sTOB);
        END;
      end;
    end;
  FINALLY
    TOBpieces.free;
    TOBA.free;
  END;
  //
end;

procedure TExportDocTOB.constitueTOBviaCledoc ;
var ind : integer;
		fTOB,PTOB,sTOB : TOB;
begin
  InternalTOBViaDocument (fCledoc);
  if fTOBInterm.detail.count > 0 then
  begin
    PTOB := AddEnteteInterm (fTOBinterm);
    for ind := 0 to fTOBinterm.detail.count -1 do
    begin
      fTOB := fTOBInterm.detail[Ind];
      sTOB := AddTOBInterm (PTOB);
      PutValeur(fTOB,sTOB);
		end;
  end;
end;

procedure TExportDocTOB.constitueTOBviaDocument;
begin
  if (fCledoc.NaturePiece  = '') and (fTOBpiece = nil) then exit;
  if fcledoc.NaturePiece <> '' then
  begin
  	constitueTOBviaCledoc;
  end else
  begin
  	constitueTOBviaTOB;
  end;
end;

procedure TExportDocTOB.constitueTOBviaTOB;
var PTOB,sTOB,fTOB : TOB;
		ind : integer;
begin
//	if fTOBpiece.getValue('GP_REFEXTERNE')='' then exit;
	fTOBInterm.Dupliquer(fTOBpiece,true,true);
  EnlevepasConcerne (True); // enleve les lignes qui ne concerne pas le fournisseur concerne
  Nettoieparagraphes;
  if fTOBInterm.detail.count > 0 then
  begin
    PTOB := AddEnteteInterm (fTOBInterm);
    for ind := 0 to fTOBinterm.detail.count -1 do
    begin
      fTOB := fTOBInterm.detail[Ind];
      sTOB := AddTOBInterm (PTOB);
      PutValeur(fTOB,sTOB);
    end;
  end;
end;


constructor TExportDocTOB.create;
begin
	fTOBInterm := TOB.Create ('PIECE',nil,-1);
  fTOBOuvrageI := TOB.Create ('LES OUVRAGES',nil,-1); // pour les sous détail de niveau 1 si besoin
  fTOBadresses := TOB.Create ('LES ADRESSES',nil,-1);

  fInternalWindow := TToolWindow97.create(Application.MainForm);
  fInternalWindow.Parent := Application.MainForm;
  fInternalWindow.Visible := false;
  fInternalWindow.Width := 600;
  //
  fTexte := THRichEditOLE.Create (fInternalWindow);
  ftexte.Parent := fInternalWindow;
  ftexte.text := '';
  ftexte.Align := alClient;
end;

destructor TExportDocTOB.destroy;
begin
	fTOBInterm.free;
  fTOBOuvrageI.free;
  fTexte.free;
  fInternalWindow.free;
  fTOBadresses.free;
  //
  inherited;
end;

procedure TExportDocTOB.EnlevepasConcerne (Tobinmem : boolean);
var Indice,Ind : integer;
		TOBl,TOBOD,TOBOO : TOB;
    Typetravail,OuvNatureTravail : double;
    NumPrix,TypeLigne,Fournisseur, LibFrs : string;
    NumLigne,Numordre,NiveauImbric,decal : integer;
    Qtepere : double;
    DebutRefLigne : string;
    QteDuDetail : double;
    first,EstOuvrage,Estparagraphe : boolean;
begin
	DebutRefLigne := fTOBInterm.getvalue('GP_NATUREPIECEG')+';'+fTOBInterm.getvalue('GP_SOUCHE')+';'+
                   IntToStr(fTOBInterm.getvalue('GP_NUMERO'))+';'+IntToStr(fTOBInterm.getvalue('GP_INDICEG'))+';';
	indice := 0;
  TOBOD := TOB.Create ('LES DETAIL OUV',nil,-1);
  if fTOBinterm.detail.count = 0 then exit;
	repeat
    TOBL := fTOBInterm.detail[indice];
    TypeTravail := valeur(TOBL.getvalue('GLC_NATURETRAVAIL'));
    TypeLigne := TOBL.getvalue('GL_TYPELIGNE');
    Numligne := TOBL.getvalue('GL_NUMLIGNE');
    Numordre := TOBL.getvalue('GL_NUMORDRE');
    fournisseur := TOBL.getvalue('GL_FOURNISSEUR');  if Typetravail = 0 then Fournisseur := '';
    if GetLibTiers('FOU', Fournisseur, LibFrs) then fNomFrs := LibFrs;
    NiveauImbric  := TOBL.getvalue('GL_NIVEAUIMBRIC');
    EstOuvrage := isOuvrage(TOBL);
    Estparagraphe := IsParagraphe(TOBL);
    decal := 0;
    if (EstOuvrage) and (ffournisseur='')  then
    begin
      TOBL.putValue('GL_TYPELIGNE','OUV');
      //
      TOBOD.clearDetail;
      if not TOBinMem then GetDetailOuvrage (TOBL,TOBOD)
                      else GetDetailFromTOB(TOBL,TOBOD);
      QtePere := TOBL.getvalue('GL_QTEFACT');
      Numprix := TOBL.getvalue('GL_REFARTSAISIE');
      for Ind := 0 to TOBOD.detail.count -1 do
      begin
        TOBOO := TOBOD.detail[Ind];
        TOBL := TOB.create ('LIGNE',fTOBInterm,Indice+decal+1);
        QteDuDetail := TOBOO.getvalue('BLO_QTEDUDETAIL'); if QteDuDetail=0 then QteDuDetail :=1;
        TOBL.putValue('GL_TYPELIGNE','SDO');
        TOBL.putValue('GL_NUMLIGNE',NumLigne);
        TOBL.putValue('GL_REFARTSAISIE',TOBOO.getValue('BLO_REFARTSAISIE'));
        TOBL.putValue('GL_LIBELLE',TOBOO.getValue('BLO_LIBELLE'));
        TOBL.putValue('GL_QTEFACT',arrondi(TOBOO.getValue('BLO_QTEFACT')*QtePere/QteDuDetail,V_PGI.OkDecQ));
        TOBL.putValue('GL_QUALIFQTEVTE',TOBOO.getValue('BLO_QUALIFQTEVTE'));
        TOBL.putValue('GL_PUHTDEV',TOBOO.getValue('BLO_PUHTDEV'));
        TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';'+IntToStr(TOBOO.getValue('BLO_UNIQUEBLO'))+';');
        inc(decal);
      end;
      indice := indice + decal;
    end else if (EstOuvrage) and
    						(ffournisseur<>'') and
                (TypeTravail>=0) and (TypeTravail < 10) and
                (ffournisseur <> Fournisseur) then
    begin
      TOBL.free;
      continue;
    end else if (EstOuvrage) and
    						(ffournisseur<>'') and
                (TypeTravail>=0) and (TypeTravail < 10) and
                (ffournisseur = Fournisseur) then
    begin
      TOBL.putValue('GL_TYPELIGNE','ART');
      TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';;');
      inc(indice);
    end else if (ffournisseur<>'') and (Typetravail >= 10) then // partiellement cotraité ou sous traité
    begin
      // c'est forcement un ouvrage
      TOBOD.clearDetail;
      if not TOBinMem then GetDetailOuvrage (TOBL,TOBOD)
                      else GetDetailFromTOB(TOBL,TOBOD);
      QtePere := TOBL.getvalue('GL_QTEFACT');
      Numprix := TOBL.getvalue('GL_REFARTSAISIE');
      first := true;
      for Ind := 0 to TOBOD.detail.count -1 do
      begin
        TOBOO := TOBOD.detail[Ind];
        OuvNatureTravail := Valeur(TOBOO.getValue('BLO_NATURETRAVAIL'));
        if (FFournisseur <> '') and
           (OuvNatureTravail>=0) and
           (OuvNatureTravail < 10) and
           (TOBOO.getValue('BLO_FOURNISSEUR')<>fFournisseur) then continue;
        if first  then
        begin
          TOBL.putValue('GL_TYPELIGNE','ART');
          first := false;
      		decal := 0;
        end else
        begin
          TOBL := TOB.create ('LIGNE',fTOBInterm,Indice+decal+1);
          TOBL.putValue('GL_NIVEAUIMBRIC',NiveauImbric);
          inc(decal);
        end;
        QteDuDetail := TOBOO.getvalue('BLO_QTEDUDETAIL'); if QteDuDetail=0 then QteDuDetail :=1;
        TOBL.putValue('GL_NUMLIGNE',NumLigne);
        TOBL.putValue('GL_REFARTSAISIE',NumPrix+'.'+inttostr(ind+1));
        TOBL.putValue('GL_LIBELLE',TOBOO.getValue('BLO_LIBELLE'));
        TOBL.putValue('GL_QTEFACT',arrondi(TOBOO.getValue('BLO_QTEFACT')*QtePere/QteDuDetail,V_PGI.OkDecQ));
        TOBL.putValue('GL_QUALIFQTEVTE',TOBOO.getValue('BLO_QUALIFQTEVTE'));
        TOBL.putValue('GL_PUHTDEV',TOBOO.getValue('BLO_PUHTDEV'));
        TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';'+IntToStr(TOBOO.getValue('BLO_UNIQUEBLO'))+';');
      end;
      indice := indice + decal +1;
    end else if (TOBL.getValue('GL_TYPELIGNE')='COM') and ((TOBL.getValue('GL_BLOCNOTE')<>'') OR (TOBL.getValue('GL_LIBELLE')='BLOC NOTE ASSOCIE')) then
    begin
    	if (ffournisseur <> '') and (fournisseur <> ffournisseur)  then
      begin
      	TOBL.free;
        continue;
      end else
      begin
        if not IsBlocNoteVide(ftexte,TOBL.getValue('GL_BLOCNOTE')) then
        begin
          first := true;
          for Ind := 0 to fTexte.lines.Count -1 do
          begin
            if first then
            begin
              first := false;
            end else
            begin
              TOBL := TOB.create ('LIGNE',fTOBInterm,Indice+ind);
              TOBL.putValue('GL_NIVEAUIMBRIC',NiveauImbric);
              TOBL.putValue('GL_TYPELIGNE','COM');
            end;
            TOBL.putValue('GL_LIBELLE',ftexte.lines.Strings [Ind]);
        		TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';;');
          end;
          indice := indice + ind;
        end else
        begin
        	TOBL.putValue('GL_LIBELLE','');
          TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';;');
          inc(indice);
        end;
      end;
    end else
    begin
    	if  (not Estparagraphe) and (ffournisseur <> '') and (ffournisseur <> fournisseur) then
      begin
      	TOBL.free;
        continue;
      end else
      begin
        if Isvariante(TOBl) then TOBL.putvalue('GL_TYPELIGNE','VAR');
        TOBL.AddChampSupValeur ('REFLIGNE',DebutRefLigne +IntToStr(NumOrdre)+';;');
        inc(indice);
      end;
    end;
  until Indice >= fTOBinterm.detail.count;
  TOBOD.free;
end;

procedure TExportDocTOB.GetDetailOuvrage(TOBL, TOBOD: TOB);
var TOBO,TOBOO : TOB;
begin
	TOBO := fTOBOuvrageI.FindFirst(['BLO_NUMLIGNE'],[TOBL.getValue('GL_NUMLIGNE')],true);
  while TOBO <> nil do
  begin
  	TOBOO := TOB.create ('LIGNEOUV',TOBOD,-1);
    TOBOO.Dupliquer(TOBO,false,true);
		TOBO := fTOBOuvrageI.FindNext (['BLO_NUMLIGNE'],[TOBL.getValue('GL_NUMLIGNE')],true);
  end;
end;

procedure TExportDocTOB.GetDetailFromTOB (TOBL, TOBOD : TOB);
var TOBO,TOBOO : TOB;
		indiceOuv,Indice : integer;
begin
	IndiceOuv := TOBL.getvalue('Gl_INDICENOMEN'); if IndiceOuv=0 then exit;
	TOBO := TOBOuvrage.detail[IndiceOuv-1]; if TOBO= nil then exit;
  //
  for Indice := 0 to TOBO.detail.count -1 do
  begin
  	TOBOO := TOB.create ('LIGNEOUV',TOBOD,-1);
    TOBOO.Dupliquer(TOBO,false,true);
  end;
end;

procedure TExportDocTOB.InternalTOBViaDocument(LocalCledoc: R_CLEDOC);
var QQ : Tquery;
		Sql : string;
begin
  fTOBInterm.clearDetail;
  fTOBInterm.InitValeurs ;
  fTOBOuvrageI.cleardetail;
  fTOBadresses.ClearDetail;
  Sql := 'SELECT GP_NATUREPIECEG,GP_SOUCHE,GP_NUMERO,GP_INDICEG,GP_REFEXTERNE,GP_REFINTERNE,'+
  			 'GP_DATEPIECE,GP_NUMADRESSELIVR,GP_NUMADRESSEFACT,GP_TIERS,GP_AFFAIRE FROM PIECE WHERE '+WherePiece(LocalCledoc,ttdPiece,true);
  QQ := OpenSql (Sql,true,1,'',true);
  if not QQ.eof then
  begin
  	fTOBInterm.SelectDB('',QQ);
  end;
  ferme (QQ);
  //
  LoadLesAdresses (fTOBinterm,fTOBadresses);
  //
//	if fTOBInterm.getValue('GP_REFEXTERNE')='' then exit;
  //
  Sql := 'SELECT GL_NUMORDRE,GL_NUMLIGNE,GL_INDICENOMEN,GL_TYPELIGNE,GL_TYPEARTICLE,GL_REFARTSAISIE,'+
  			 'GL_LIBELLE,GL_QTEFACT,GL_QUALIFQTEVTE,GL_PUHTDEV,GL_FOURNISSEUR,GL_NIVEAUIMBRIC,GL_BLOCNOTE,' +
  			 'GLC_NATURETRAVAIL FROM LIGNE LEFT JOIN LIGNECOMPL ON '+
  			 'GLC_NATUREPIECEG=GL_NATUREPIECEG AND GLC_SOUCHE=GL_SOUCHE AND GLC_NUMERO=GL_NUMERO AND '+
         'GLC_INDICEG=GL_INDICEG AND GLC_NUMORDRE=GL_NUMORDRE '+
  			 'WHERE '+WherePiece(LocalCledoc,ttdLigne,false)+' ORDER BY GL_NUMLIGNE';
  QQ := OpenSql (Sql,true,-1,'',true);
  if not QQ.eof then
  begin
  	fTOBInterm.LoadDetailDB('LIGNE','','',QQ,false,true);
  end;
  ferme (QQ);
  Sql := 'SELECT BLO_NUMLIGNE,BLO_N1,BLO_TYPELIGNE,BLO_TYPEARTICLE,BLO_QTEDUDETAIL,'+
  			 'BLO_REFARTSAISIE,BLO_LIBELLE,BLO_QTEFACT,BLO_QUALIFQTEVTE,BLO_PUHTDEV,BLO_FOURNISSEUR,BLO_NATURETRAVAIL '+
  			 'FROM LIGNEOUV WHERE '+WherePiece(LocalCledoc,ttdOuvrage,true)+' AND BLO_N2=0 ORDER BY BLO_NUMLIGNE,BLO_N1';
  QQ := OpenSql (Sql,true,-1,'',true);
  if not QQ.eof then
  begin
  	fTOBouvrageI.LoadDetailDB('LIGNEOUV','','',QQ,false,true);
  end;
  ferme (QQ);
  EnlevepasConcerne; // enleve les lignes qui ne concerne pas le fournisseur concerne
  Nettoieparagraphes;
end;

procedure TExportDocTOB.Nettoieparagraphes;
var Indice : integer;
    TOBL : TOB;
begin
  Indice := fTOBInterm.detail.count -1;
  repeat
    if Indice >= 0 then
    begin
      TOBL := fTOBInterm.detail[Indice];
      if IsFinParagraphe(TOBL) then
      begin
        if not IsDetailInside (Indice,TOBL) then
        begin
          SuprimeThisParagraphe (TOBL,Indice);
        end;
      end;
      dec(Indice);
    end;
  until indice <= 0;
end;

function TExportDocTOB.IsDetailInside(IndDep: integer; TOBL: TOB): boolean;
var indice : integer;
    Niveau : integer;
    TOBI : TOB;
begin
  result := false;
  Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
  for Indice := Inddep-1 downto 0 do
  begin
    TOBI := fTOBInterm.detail[Indice];
    if IsArticle (TOBI) then BEGIN result := true; break; END;
    if IsDebutParagraphe (TOBI,Niveau) then break;
  end;
end;

procedure TExportDocTOB.SuprimeThisParagraphe(TOBL : TOB; var IndDep: integer);
var Niveau : integer;
    TOBI : TOB;
    StopItNow : boolean;
begin
  Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
  StopItNow := false;
  repeat
    TOBI := fTOBInterm.detail[IndDep];
    if IsDebutParagraphe (TOBI,Niveau) then StopItNow := true;
    TOBI.free;
    Dec(IndDep);
  until (IndDep < 0 ) or (StopItNow);
end;

function TExportDocTOB.AddEnteteInterm (TOBP : TOB): TOB;
var TOBA : TOB;
begin
	result := TOB.Create ('UNDOCUMENT',fTOBresult,-1);
	result.AddChampSupValeur ('REFEXTERNE',TOBP.GetValue('GP_REFEXTERNE'));
	result.AddChampSupValeur ('REFINTERNE',TOBP.GetValue('GP_REFINTERNE'));
	result.AddChampSupValeur ('CODETIERS',TOBP.GetValue('GP_TIERS'));
	result.AddChampSupValeur ('AFFAIRE',BTPCodeAffaireAffiche(TobP.GetValue('GP_AFFAIRE')));
	result.AddChampSupValeur ('REFFOURNISSEUR',fFournisseur);
	result.AddChampSupValeur ('EXPEDITEUR',getparamSocSecur('SO_SIRET',''));
	result.AddChampSupValeur ('INFOPIECE',Rechdom('GCNATUREPIECEG',TOBP.GetValue('GP_NATUREPIECEG'),false)+' N°'+inttostr(TOBP.GetValue('GP_NUMERO')));
	result.AddChampSupValeur ('IDPIECE',TOBP.GetValue('GP_NATUREPIECEG')+':'+
  																		TOBP.GetValue('GP_SOUCHE')+':'+
                                      inttostr(TOBP.GetValue('GP_NUMERO'))+':'+
                                      IntToStr(TOBP.GetValue('GP_INDICEG'))
                                      );
	result.AddChampSupValeur ('DATEPIECE',TOBP.GetValue('GP_DATEPIECE'));
  if fTypeExport <> TteSousTrait then
  begin
    TOBA := fTOBadresses.detail[0]; // adresses de facturation
    result.AddChampSupValeur ('FACJURIDIQUE',rechdom('TTFORMEJURIDIQUE',TOBA.getValue('GPA_JURIDIQUE'),false));
    result.AddChampSupValeur ('FACLIBELLE',TOBA.getValue('GPA_LIBELLE'));
    result.AddChampSupValeur ('FACLIBELLE2',TOBA.getValue('GPA_LIBELLE2'));
    result.AddChampSupValeur ('FACADRESSE1',TOBA.getValue('GPA_ADRESSE1'));
    result.AddChampSupValeur ('FACADRESSE2',TOBA.getValue('GPA_ADRESSE2'));
    result.AddChampSupValeur ('FACADRESSE3',TOBA.getValue('GPA_ADRESSE3'));
    result.AddChampSupValeur ('FACCODEPOST',TOBA.getValue('GPA_CODEPOSTAL'));
    result.AddChampSupValeur ('FACVILLE',TOBA.getValue('GPA_VILLE'));
    result.AddChampSupValeur ('FACCPVILLE',TOBA.getValue('GPA_CODEPOSTAL')+' '+TOBA.getValue('GPA_VILLE'));
    result.AddChampSupValeur ('FACPAYS',TOBA.getValue('GPA_PAYS'));
    result.AddChampSupValeur ('FACNIF',TOBA.getValue('GPA_NIF'));
  end else
  begin
    result.AddChampSupValeur ('FACJURIDIQUE',rechdom('TTFORMEJURIDIQUE',getparamSocSecur('SO_NATUREJURIDIQUE',''),false));
    result.AddChampSupValeur ('FACLIBELLE',getparamSocSecur('SO_LIBELLE',''));
    result.AddChampSupValeur ('FACLIBELLE2','');
    result.AddChampSupValeur ('FACADRESSE1',getparamSocSecur('SO_ADRESSE1',''));
    result.AddChampSupValeur ('FACADRESSE2',getparamSocSecur('SO_ADRESSE2',''));
    result.AddChampSupValeur ('FACADRESSE3',getparamSocSecur('SO_ADRESSE3',''));
    result.AddChampSupValeur ('FACCODEPOST',getparamSocSecur('SO_CODEPOSTAL',''));
    result.AddChampSupValeur ('FACVILLE',getparamSocSecur('SO_VILLE',''));
    result.AddChampSupValeur ('FACCPVILLE',getparamSocSecur('SO_CODEPOSTAL','')+' '+getparamSocSecur('SO_VILLE',''));
    result.AddChampSupValeur ('FACPAYS',getparamSocSecur('SO_PAYS',''));
    result.AddChampSupValeur ('FACNIF',getparamSocSecur('SO_NIF',''));
  end;
  //
	TOBA := fTOBadresses.detail[1]; // adresses de livraison
	result.AddChampSupValeur ('LIVJURIDIQUE',rechdom('TTFORMEJURIDIQUE',TOBA.getValue('GPA_JURIDIQUE'),false));
	result.AddChampSupValeur ('LIVLIBELLE',TOBA.getValue('GPA_LIBELLE'));
	result.AddChampSupValeur ('LIVLIBELLE2',TOBA.getValue('GPA_LIBELLE2'));
	result.AddChampSupValeur ('LIVADRESSE1',TOBA.getValue('GPA_ADRESSE1'));
	result.AddChampSupValeur ('LIVADRESSE2',TOBA.getValue('GPA_ADRESSE2'));
	result.AddChampSupValeur ('LIVADRESSE3',TOBA.getValue('GPA_ADRESSE3'));
	result.AddChampSupValeur ('LIVCODEPOST',TOBA.getValue('GPA_CODEPOSTAL'));
	result.AddChampSupValeur ('LIVVILLE',TOBA.getValue('GPA_VILLE'));
	result.AddChampSupValeur ('LIVCPVILLE',TOBA.getValue('GPA_CODEPOSTAL')+' '+TOBA.getValue('GPA_VILLE'));
	result.AddChampSupValeur ('LIVPAYS',TOBA.getValue('GPA_PAYS'));
	result.AddChampSupValeur ('LIVNIF',TOBA.getValue('GPA_NIF'));
end;

function TExportDocTOB.AddTOBInterm (TOBpere : TOB) : TOB;
begin
	result := TOB.Create ('ONELIGNE',TOBpere,-1);
  result.AddChampSupValeur('REFLIGNE',' ');
  result.AddChampSupValeur('TYPELIGNE',' ');
  result.AddChampSupValeur('REFARTLIGNE',' ');
  result.AddChampSupValeur('LIBELLELIGNE',' ');
  result.AddChampSupValeur('QTELIGNE',0);
  result.AddChampSupValeur('UNITELIGNE',' ');
  result.AddChampSupValeur('PULIGNE',0);
  result.AddChampSupValeur('NIVEAUIMBRIC',0);
end;

procedure TExportDocTOB.PutValeur(fTOB,sTOB : TOB);
var qualif : string;
begin
	sTOB.putValue('REFLIGNE',fTOB.getValue('REFLIGNE'));
  sTOB.putValue('TYPELIGNE',fTOB.getValue('GL_TYPELIGNE'));
  if fTOB.getValue('GL_REFARTSAISIE') <> '' then
  	sTOB.putValue('REFARTLIGNE',fTOB.getValue('GL_REFARTSAISIE'));
  if fTOB.getValue('GL_LIBELLE') <> '' then
  sTOB.putValue('LIBELLELIGNE',fTOB.getValue('GL_LIBELLE'));
  sTOB.putValue('QTELIGNE',fTOB.getValue('GL_QTEFACT'));
  qualif := RechDom('GCQUALUNITTOUS',fTOB.getValue('GL_QUALIFQTEVTE'),false);
  if fTOB.getValue('GL_QUALIFQTEVTE') <> '' then sTOB.putValue('UNITELIGNE',fTOB.getValue('GL_QUALIFQTEVTE'));
  sTOB.putValue('PULIGNE',fTOB.getValue('GL_PUHTDEV'));
  sTOB.putValue('NIVEAUIMBRIC',fTOB.getValue('GL_NIVEAUIMBRIC'));
end;


function TExportDocTOB.IsBlocNoteVide(texte: THRichEditOLE;BlocNote: String): boolean;
begin
	result := true;
 	StringToRich(Texte, BlocNote);
  if (Length(Texte.Text) <> 0) and (texte.Text <> #$D#$A) then result := false;
end;

end.
