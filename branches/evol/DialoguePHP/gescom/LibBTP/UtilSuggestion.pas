unit UtilSuggestion;

interface
uses SysUtils, Classes, UTOB, Hctrls, HStatus, StdCtrls, math,
     EntGC, Ent1, AglInit,NomenUtil,UtilArticle,UTofListeInv,
{$IFDEF EAGLCLIENT}
     MaineAGL,
{$ELSE}
     db,{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}FE_Main,
{$ENDIF}
     HEnt1;

type
TTypeUniteResult = (TurStock,TurVente,TurAchat);

TGinfostarifFour = record
	TarifAch : double;
	TarifAchBrut : double;
  Remise : string;
  remisesreelle   : double;
  cascade : string;
  UniteAchat : string;
  CoefUAUs : double;
  LibelleFournisseur : string;
  Tarif : integer;
	end;

function RecupTarifAch (Fournisseur,Article : string; VAR UniteAch : string; var CoefuaUs : double; UniteResult : TTypeUniteResult = TurAchat;
                        PrixNet : boolean=true;PrxArtInclus:boolean=true;TOBA : TOB=nil;QteRef : double=1; DateRef : TdateTime=0) : double; overload;
function RecupTarifAch (TOBArt,TOBTarif,TobTiers : TOB; var UniteAch : string ; var CoefuaUs : double; UniteResult : TTypeUniteResult = TurAchat;
                        PrixNet : boolean=true;PrxArtInclus:boolean=true;QteRef : double=1; Dateref : TdateTime=0) : double; overload;
function SelectionDocuments (LesNaturesAPrendre : string;DateDebut,DateFin: string; TOBListeDocuments : TOB) : boolean;
function GetInfosTarifAch (Fournisseur,Article : string; UniteResult : TTypeUniteResult = TurAchat;
													 PrixNet : boolean=true;PrxArtInclus:boolean=true;TOBA : TOB=nil;QteRef : double=1;
                           DateRef : TdateTime=0) : TGinfostarifFour;

implementation
uses UTOF_VideInside;


function SelectionDocuments (LesNaturesAPrendre : string;DateDebut,DateFin: string; TOBListeDocuments : TOB) : boolean;
begin
  result := false;
  TRY
    TheToB := TOBListeDocuments;
//    SaisirHorsInside('GCSELDOCREA_MUL');
    AGLLanceFiche('GC','GCSELDOCREA_MUL','','','ACTION=MODIFICATION');
    if TheTob <> nil then
    begin
      TOBListeDocuments.clearDetail;
      TOBListeDocuments.Dupliquer (TheTob,true,true);
      TheTOB.free;
      result := true;
    end;
  FINALLY
    TheTob := nil;
  END;
end;

function RecupTarifAch (TOBArt,TOBTarif,TobTiers : TOB; var UniteAch : string ; var CoefuaUs : double; UniteResult : TTypeUniteResult = TurAchat;
                        PrixNet : boolean=true;PrxArtInclus:boolean=true;QteRef : double=1; Dateref : TdateTime=0) : double;
var TOBCatalog : TOB;
    MTPAF,PrixPourQte : Double;
    FUA,FUV,FUS : double;
begin
//  result := 0;
	CoefUaUs := 0;
  TOBCatalog := TOB.Create ('CATALOGU',nil,-1);
  TRY
    chargeTOBs (TOBArt,TOBCatalog,TOBTiers,TOBTarif,QteRef,DateRef);

    FUV := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITEVTE'));
    FUS := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITESTO'));
    FUA := RatioMesure('PIE', TobCatalog.getValue('GCA_QUALIFUNITEACH'));
    CoefuaUs := TobCatalog.getValue('GCA_COEFCONVQTEACH');
    if TOBTarif.GetValue('GF_PRIXUNITAIRE') <> 0 then
      begin
        MTPAF :=TOBTarif.GetValue('GF_PRIXUNITAIRE');
      end else
      begin
        PrixPourQte := TOBCatalog.GetValue('GCA_PRIXPOURQTEAC');
        if PrixPourQte = 0 then PrixPourQte := 1;
        if TOBCatalog.GetValue('GCA_PRIXBASE') = 0 then
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXVENTE')/PrixPourQte;
        end else
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXBASE')/PrixPourQte;
        end;
      end;
    UniteAch := TOBCatalog.GetValue('GCA_QUALIFUNITEACH');
    if (MTPAF = 0) and (PrxArtInclus) then
    begin
    	if CoefUaUs <> 0 then
      begin
      	MTPAF := TobArt.getValue('GA_PAHT') / FUV * FUS / CoefUaUs;
      end else
      begin
      	MTPAF := TobArt.getValue('GA_PAHT') / FUV * FUA;
      end;
    end;
    if PrixNet then MTPAF := arrondi(MTPAF * (1-(TOBTarif.GetValue('GF_REMISE')/100)),V_PGI.OkDecP )
               else MTPAF := arrondi(MTPAF ,V_PGI.OkDecP );
    if uniteResult = TurStock then
    begin
    	if CoefUaUs <> 0 then
      begin
      	MTPAF := (MTPAF * CoefuaUs);
      end else
      begin
      	MTPAF := (MTPAF/FUA ) * FUS;
      end
    end else
    if uniteResult = TurVente then
    begin
    	if CoefUaUs <> 0 then
      begin
      	MTPAF := (MTPAF*CoefUaUs ) / FUS * FUV;
      end else
      begin
      	MTPAF := (MTPAF/FUA ) * FUV;
      end;
    end;
    Result := MTPAF;
  FINALLY
    TOBCatalog.free;
  END;
end;

function RecupTarifAch (Fournisseur,Article : string; VAR UniteAch : string ; var CoefUaUs : double; UniteResult : TTypeUniteResult = TurAchat;
                        PrixNet : boolean=true;PrxArtInclus:boolean=true;TOBA : TOB=nil;QteRef : double=1; DateRef : TdateTime=0) : double;
var TOBTiers,TobArt,TOBTarif,TOBCatalog : TOB;
    MTPAF,PrixPourQte : double;
    FUV,FUA,FUS : double;
    QQ : TQuery;
begin
	CoefUaUs := 0;
  result := 0;
  if fournisseur = '' then exit;
  TOBTarif := TOB.Create ('TARIF',nil,-1);
  TOBCatalog := TOB.Create ('CATALOGU',nil,-1);
  TOBTiers := TOB.Create ('TIERS',nil,-1);
  TOBART := TOB.Create ('ARTICLE',nil,-1);
  TRY
//    TOBART.PutValue('GA_ARTICLE',Article);
    QQ := OpenSql ('SELECT GA2_SOUSFAMTARART,* FROM ARTICLE LEFT JOIN ARTICLECOMPL ON GA2_ARTICLE=GA_ARTICLE WHERE GA_ARTICLE="'+Article+'"',True);
//    TOBARt.LoadDB (true);
    TOBARt.SelectDB ('',QQ);
    ferme (QQ);
    TOBTiers.putValue ('T_TIERS',Fournisseur);
    TOBTiers.LoadDB (true);
    chargeTOBs (TOBArt,TOBCatalog,TOBTiers,TOBTarif,Qteref,Dateref);
//
    FUV := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITEVTE'));
    FUS := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITESTO'));
    FUA := RatioMesure('PIE', TobCatalog.getValue('GCA_QUALIFUNITEACH'));
//
    if TOBTarif.GetValue('GF_PRIXUNITAIRE') <> 0 then
      begin
        MTPAF :=TOBTarif.GetValue('GF_PRIXUNITAIRE');
      end else
      begin
        PrixPourQte := TOBCatalog.GetValue('GCA_PRIXPOURQTEAC');
        CoefUaUs := TOBCatalog.GetValue('GCA_COEFCONVQTEACH');
        if PrixPourQte = 0 then PrixPourQte := 1;

        if TOBCatalog.GetValue('GCA_PRIXBASE') = 0 then
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXVENTE')/prixPourQte;
        end else
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXBASE')/prixPourQte;
        end;
      end;
    UniteAch := TOBCatalog.GetValue('GCA_QUALIFUNITEACH');
    if (MTPAF = 0) and (PrxArtInclus) then MTPAF := TOBART.GetValue ('GA_PAHT');
    if PrixNet then MTPAF := arrondi(MTPAF * (1-(TOBTarif.GetValue('GF_REMISE')/100)),V_PGI.OkDecP)
               else MTPAF := arrondi(MTPAF ,V_PGI.OkDecP );
    if uniteResult = TurStock then
    begin
    	if CoefUaUs <> 0 then
      begin
      	MTPAF := (MTPAF / CoefUaUS);
      end else
      begin
      	MTPAF := (MTPAF / FUA ) * FUS;
      end;
    end else
    if uniteResult = TurVente then
    begin
    	if CoefUaUs <> 0 then
      begin
      	MTPAF := (MTPAF / CoefuaUs ) / FUS * FUV;
      end else
      begin
      	MTPAF := (MTPAF / FUA ) * FUV;
      end;

      if TOBA <> nil then
      begin
        if not TOBA.FieldExists ('GCA_QUALIFUNITEACH') then TOBA.AddChampSup('GCA_QUALIFUNITEACH',false);
        TOBA.PutValue('GCA_QUALIFUNITEACH',TobCatalog.getValue('GCA_QUALIFUNITEACH'));
        TOBA.PutValue('GA_PAHT',MTPAF);
        TOBA.PutValue('GA_DPA',MTPAF);
        RecalculPrPV (TOBA,TOBCataLog);
      end;
    end;
    Result := MTPAF;
  FINALLY
    TOBTArif.free;
    TOBCatalog.free;
    TOBTiers.free;
    TOBARt.free;
  END;
end;


function GetInfosTarifAch (Fournisseur,Article : string; UniteResult : TTypeUniteResult = TurAchat;
													 PrixNet : boolean=true;PrxArtInclus:boolean=true;TOBA : TOB=nil;QteRef : double=1;
                           DateRef : TdateTime=0) : TGinfostarifFour;
var TOBTiers,TobArt,TOBTarif,TOBCatalog : TOB;
    MTPAF,PrixPourQte,MTPABrut : double;
    FUV,FUA,FUS,CoefuaUS : double;
    QQ : TQuery;
begin
  result.TarifAch := 0;
  result.UniteAchat := '';
  result.TarifAchBrut := 0;
  result.Remise := '';
  result.remisesreelle := 0;
  result.LibelleFournisseur := '';
  result.CoefUAUs := 0;
  if fournisseur = '' then exit;
  TOBTarif := TOB.Create ('TARIF',nil,-1);
  TOBCatalog := TOB.Create ('CATALOGU',nil,-1);
  TOBTiers := TOB.Create ('TIERS',nil,-1);
  TOBART := TOB.Create ('ARTICLE',nil,-1);
  TRY
    TOBART.PutValue('GA_ARTICLE',Article);
//    TOBARt.LoadDB (true);
    QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
    							 'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
    							 'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+Article+'"',true);
    TOBArt.selectDb ('',QQ);
    ferme(QQ);
    TOBTiers.putValue ('T_TIERS',Fournisseur);
    TOBTiers.LoadDB (true);
    chargeTOBs (TOBArt,TOBCatalog,TOBTiers,TOBTarif,Qteref,Dateref);
//
    FUV := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITEVTE'));
    FUS := RatioMesure('PIE', TobArt.getValue('GA_QUALIFUNITESTO'));
    FUA := RatioMesure('PIE', TobCatalog.getValue('GCA_QUALIFUNITEACH'));
    coefUaUs := TobCatalog.getValue('GCA_COEFCONVQTEACH');
//
    if TOBTarif.GetValue('GF_PRIXUNITAIRE') <> 0 then
      begin
        MTPAF :=TOBTarif.GetValue('GF_PRIXUNITAIRE');
      end else
      begin
        PrixPourQte := TOBCatalog.GetValue('GCA_PRIXPOURQTEAC');
        if PrixPourQte = 0 then PrixPourQte := 1;

        if TOBCatalog.GetValue('GCA_PRIXBASE') = 0 then
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXVENTE')/prixPourQte;
        end else
        begin
          MTPAF :=TOBCatalog.GetValue('GCA_PRIXBASE')/prixPourQte;
        end;
     end;

    if (MTPAF = 0) and (PrxArtInclus) then MTPAF := TOBART.GetValue ('GA_PAHT');
    if PrixNet then
    begin
      MTPABrut := arrondi(MTPAF ,V_PGI.OkDecP );
    	MTPAF := arrondi(MTPAF * (1-(TOBTarif.GetValue('GF_REMISE')/100)),V_PGI.OkDecP);
    end else
    begin
    	MTPAF := arrondi(MTPAF ,V_PGI.OkDecP );
      MTPABrut := MTPAF;
    end;
    if uniteResult = TurStock then
    begin
    	if CoefUaUs <> 0 then
      begin
        MTPAF := arrondi(MTPAF / CoefUaUs,V_PGI.okdecP);
        MTPABrut := arrondi(MTPABrut /CoefuaUs,V_PGI.okdecP);
      end else
      begin
        MTPAF := Arrondi((MTPAF / FUA ) * FUS,V_PGI.okdecP);
        MTPABrut := Arrondi((MTPABrut / FUA ) * FUS,V_PGI.okdecP);
      end;
    end else
    if uniteResult = TurVente then
    begin
    	if CoefUaUs <> 0 then
      begin
        MTPAF := Arrondi((MTPAF / CoefuaUs ) / FUS * FUV,V_PGI.okdecP);
        MTPABrut := Arrondi((MTPABrut / CoefUaUS ) / FUS * FUV,V_PGI.okdecP);
      end else
      begin
        MTPAF := arrondi((MTPAF / FUA ) * FUV,V_PGI.okdecP);
        MTPABrut := Arrondi((MTPABrut / FUA ) * FUV,V_PGI.OkdecP);
      end;
      if TOBA <> nil then
      begin
        if not TOBA.FieldExists ('GCA_QUALIFUNITEACH') then TOBA.AddChampSup('GCA_QUALIFUNITEACH',false);
        TOBA.PutValue('GCA_QUALIFUNITEACH',TobCatalog.getValue('GCA_QUALIFUNITEACH'));
        TOBA.PutValue('GA_PAHT',MTPAF);
        TOBA.PutValue('GA_DPA',MTPAF);
        RecalculPrPV (TOBA,TOBCataLog);
      end;
    end;
    Result.UniteAchat := TOBCatalog.GetValue('GCA_QUALIFUNITEACH');
    Result.Remise := TOBTarif.GetValue ('GF_CALCULREMISE');
    result.remisesreelle := TOBTarif.GetValue('GF_REMISE');
    result.cascade := TOBTarif.GetValue('GF_CASCADEREMISE');
    Result.TarifAch := MTPAF;
    Result.TarifAchBrut := MTPABrut;
    result.LibelleFournisseur := TOBTiers.GetValue('T_LIBELLE');
		result.tarif := TOBTarif.GetValue('GF_TARIF');
    result.CoefUAUs := CoefuaUs;
  FINALLY
    TOBTArif.free;
    TOBCatalog.free;
    TOBTiers.free;
    TOBARt.free;
  END;
end;

end.
