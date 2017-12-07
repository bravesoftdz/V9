unit UspecifPOC;

interface

uses
  Classes,
  SysUtils,
  uTob,
  hEnt1,
  hCtrls,
  EntGC,
  SaisUtil,
  wCommuns,
  uEntCommun,
  UtilConso,
  Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  affaireutil,FE_Main
  ;

var TOBlesContratsST : TOB;

procedure GetCoefPoc (Affaire : string; var COEFFG,COEFMARGE : double);
procedure CalculeDonneelignePOC (TOBL : TOB; var COEFFG,COEFMARGE : double);
procedure ApliqueCoeflignePOC (TOBL : TOB; DEV : Rdevise);
procedure AppliqueRGPOC (TOBfacture,TOBAffaire,TOBPorcs,TOBTiers,TOBPIECERG : TOB; DEV : RDevise; NumSituation : integer);
procedure RestitueAvancePOC(TOBFacture,TOBAffaire,TOBPOrcs,TOBBases : TOB;PourcentAvanc : double; DEV : Rdevise; NumSituation : integer);
function GetTauxAffairePOC(CodeAffaire : string; DatePiece : TdateTime) : Double;
procedure EnregistreSit0POC(TOBFacture,TOBSituations : TOB; DEV : Rdevise);
function GetInfoMarcheST(Affaire,Fournisseur,CodeMarche,Champs : string) : Variant;
procedure LibereMemContratST;
procedure AppelsBAST;

implementation
uses FactComm,UtilPGI,FactTOB,FactPiece,FactRG,FactUtil,ParamSOc,ENt1,AglInit,M3FP,cbpPath,LicUtil;

procedure GetCoefPoc (Affaire : string; var COEFFG,COEFMARGE : double);
var fCOEFFG,COEFFS,COEFSAV,COEFFD : double;
    TOBAffaire : TOB;
begin
  if Affaire='' then Exit;
  TOBAffaire := FindCetteAffaire (Affaire);
  if TOBAffaire = nil then
  begin
    StockeCetteAffaire (Affaire);
    TOBAffaire := FindCetteAffaire (Affaire);
  end;
  fCOEFFG := TOBAffaire.GetDouble('AFF_COEFFG');
  COEFFS := TOBAffaire.GetDouble('AFF_COEFFS');
  COEFSAV := TOBAffaire.GetDouble('AFF_COEFSAV');
  COEFFD := TOBAffaire.GetDouble('AFF_COEFFD');
  COEFFG := ARRONDI(fCOEFFG * COEFFS * COEFSAV * COEFFD,4);
  COEFMARGE := TOBAffaire.GetDouble('AFF_COEFMARG');
end;

procedure CalculeDonneelignePOC (TOBL : TOB; var COEFFG,COEFMARGE : double);
var prefixe,Affaire : string;
begin
  prefixe := GetprefixeTable(TOBL);
  if GetInfoParPiece(TOBL.GetString(prefixe+'_NATUREPIECEG'), 'GPP_VENTEACHAT') <> 'VEN' then exit;
  Affaire := TOBL.GetString(prefixe+'_AFFAIRE');
  if Affaire ='' then Exit;
  GetCoefPoc (Affaire,COEFFG,COEFMARGE);
end;

procedure ApliqueCoeflignePOC (TOBL : TOB; DEV : Rdevise);
var coeffg,coefmarg : double;
    prefixe : string;
    fdev : rdevise;
begin
  fdev.Code := '';
  prefixe := GetprefixeTable(TOBL);
  coeffg := 0;
  coefmarg := 0;
  CalculeDonneelignePOC (TOBL,coeffg,coefmarg);
  if (DEV.Code <> '') then
  begin
    fDEv := DEV
  end else
  begin
    if TOBL.FieldExists(prefixe+'_DEVISE') then
    begin
      fdev.Code := TOBL.getString(prefixe+'_DEVISE');
      GetInfosDevise(fDEV);
    end;
  end;
  if coeffg <> 0 then
  begin
    TOBL.putValue(prefixe+'_COEFFG',CoefFg-1);
    TOBL.SetDouble(prefixe+'_DPR',ARRONDI(TOBL.GetDouble(prefixe+'_DPA')*Coeffg,V_PGI.OkDecP));
  end;
  if coefmarg <> 0 then
  begin
    TOBL.putValue(prefixe+'_COEFMARG',coefmarg);
    TOBL.PutValue('POURCENTMARG',Arrondi((coefmarg-1)*100,2));
    TOBL.SetDouble(prefixe+'_PUHT',ARRONDI(TOBL.GetDouble(prefixe+'_DPR')*CoefMarg,V_PGI.OkDecP));
    if fdev.code <> '' then
    begin
      TOBL.SetDouble(prefixe+'_PUHTDEV',pivottodevise(TobL.GetDouble(prefixe+'_PUHT'),DEV.Taux,DEV.quotite,V_PGI.okdecP ));
    end else
    begin
      TOBL.SetDouble(prefixe+'_PUHTDEV',TobL.GetDouble(prefixe+'_PUHT'));
    end;

  end;
end;

function GetMtCautions (Affaire : string;DateMax : TDateTime) : double;
var QQ: TQuery;
begin
  Result := 0;
  QQ:= openSql('SELECT SUM(BAR_CAUTIONMT) FROM AFFAIRERG WHERE BAR_AFFAIRE="'+Affaire+'" AND BAR_DATECAUTION <= "'+USdateTime(DateMax)+'"',True,1,'',true);
  if not QQ.eof then
  begin
    Result := QQ.fields[0].asFloat;
  end;
  ferme (QQ); 
end; 


function GetRGCumulesUsed (AffaireDevis : string; DatePiece : TdateTime; NumSituation : integer) : double;
var TOBBST : TOB;
    SQl : String;
    QQ : TQuery;
begin
  Result := 0;
  TOBBST := TOB.create ('LES SITUATIONS',nil,-1);
  try
    SQL := 'SELECT BST_NATUREPIECE,BST_SOUCHE,BST_NUMEROFAC,BST_NUMEROSIT,SUM(PRG_MTTTCRGDEV) AS MTREGUSED '+
           'FROM BSITUATIONS '+
           'LEFT JOIN PIECERG ON BST_NATUREPIECE=PRG_NATUREPIECEG AND BST_SOUCHE=PRG_SOUCHE AND BST_NUMEROFAC=PRG_NUMERO '+
           'WHERE '+
           'BST_SSAFFAIRE="'+Affairedevis+'" AND '+
           'BST_VIVANTE="X" AND '+
           'BST_NUMEROSIT < '+IntToStr(NumSituation)+' AND '+
           'PRG_CAUTIONMTDEV <> 0 '+
           'GROUP BY BST_NATUREPIECE,BST_SOUCHE,BST_NUMEROFAC,BST_NUMEROSIT';
    QQ := OpenSql (sql,True,-1,'',true);
    if not QQ.eof then
    begin
      QQ.first;
      while not QQ.eof do
      begin
        Result := Result + QQ.fields[4].asFloat;
        QQ.next;
      end;
    end;
    ferme (QQ);
  finally
    TOBBST.free;
  end;
end;

function GetNextNumSituation (TOBPiece : TOB) : integer;
var REq : string;
    Q : Tquery;
begin
  result := 0;
  Req:='SELECT BST_NUMEROSIT '+
       'FROM BSITUATIONS WHERE '+
       'BST_SSAFFAIRE="'+ TOBPiece.GetValue('GP_AFFAIREDEVIS') + '" AND BST_VIVANTE="X" '+
       'ORDER BY BST_SSAFFAIRE,BST_NUMEROSIT DESC';
  Q:=OpenSQL(Req,TRUE,-1,'',true);
  if not Q.EOF then
  begin
    result := Q.Fields[0].AsInteger;
  end;
  Ferme(Q) ;
  Result := Result +1;
end;


procedure AppliqueRGPOC (TOBfacture,TOBAffaire,TOBPorcs,TOBTiers,TOBPIECERG : TOB; DEV : RDevise; NumSituation : integer);
var TOBR : TOB;
    MtCautions,MtRGUsed,Cautionrestante,PorcTTC,MtPieceTTC : double;
    DatePiece : TDateTime;
begin
  if NumSituation = -1 then NumSituation := GetNextNumSituation(TOBfacture);
  if TOBfacture.GetDateTime('GP_DATEPIECE') < TOBAffaire.GetDouble('AFF_DATERG') then Exit;
  //
  DatePiece := TOBfacture.GetDateTime('GP_DATEPIECE');
  PorcTTC := CalculPort (false,TOBPorcs);

  MtPieceTTC := TOBFacture.getvalue('GP_TOTALTTCDEV') - PorcTTC;
  //
  if TOBAffaire.GetDouble('AFF_TAUXRG')=0 then Exit;
  //
  MtCautions := GetMtCautions (TOBFacture.GetString('GP_AFFAIRE'),DatePiece);
  MtRGUsed := GetRGCumulesUsed (TOBFacture.GetString('GP_AFFAIREDEVIS'),DatePiece,NumSituation);
  Cautionrestante := MtCautions - MtRGUsed; if Cautionrestante < 0 then Cautionrestante := 0;
  //
  TOBR := TOB.Create('PIECERG',TOBPIECERG,-1);
  InitLigneRg (TOBR,TOBfacture);
  TOBR.SetString('PRG_APPLICABLE','X');
  TOBR.SetString('PRG_NATUREPIECEG',TOBfacture.GetString('GP_NATUREPIECEG'));
  TOBR.SetString('PRG_SOUCHE',TOBfacture.GetString('GP_SOUCHE'));
  TOBR.SetInteger('PRG_NUMERO',TOBfacture.GetInteger('GP_NUMERO'));
  TOBR.SetInteger('PRG_INDICEG',TOBfacture.GetInteger('GP_INDICEG'));
  TOBR.SetInteger('PRG_INDICEG',TOBfacture.GetInteger('GP_INDICEG'));
  TOBR.SetString('PRG_TYPERG','TTC');
  TOBR.SetDouble('PRG_TAUXRG',TOBAffaire.GetDouble('AFF_TAUXRG'));
  TOBR.SetDouble('PRG_TAUXDEV',TOBfacture.GetDouble('GP_TAUXDEV'));
  TOBR.SetDouble('PRG_COTATION',TOBfacture.GetDouble('GP_COTATION'));
  TOBR.putvalue('PRG_DATETAUXDEV',TOBfacture.GetValue('GP_DATETAUXDEV'));
  TOBR.putvalue('PRG_DEVISE',TOBfacture.GetValue('GP_DEVISE'));
  TOBR.putvalue('PRG_SAISIECONTRE','-');
  //
  TOBR.SetDouble('PRG_MTTTCRGDEV', ARRONDI(MtPieceTTC*(TOBR.GetDouble('PRG_TAUXRG')/100),DEV.Decimale));
  TOBR.SetDouble('PRG_MTTTCRG', DEVISETOPIVOT(TOBR.GetDouble('PRG_MTTTCRGDEV'),DEV.Taux,DEV.Quotite));
  //
  if Cautionrestante <> 0 then
  begin
    TOBR.SetString('PRG_NUMCAUTION', '111');
    TOBR.SetString('PRG_BANQUECP', 'INT');
    TOBR.SetDouble('PRG_CAUTIONMTDEV', Cautionrestante);
    TOBR.SetDouble('PRG_CAUTIONMT', DEVISETOPIVOT(TOBR.GetDouble('PRG_CAUTIONMTDEV'),DEV.Taux,DEV.Quotite));
  end;
  //

end;

function GetAvanceRest (AffaireDevis ,CodePort : string; NumSituation : integer) : double;
var TOBBST : TOB;
    SQl : String;
    QQ : TQuery;
begin
  Result := 0;
  TOBBST := TOB.create ('LES SITUATIONS',nil,-1);
  try
    SQL := 'SELECT BST_NATUREPIECE,BST_SOUCHE,BST_NUMEROFAC,BST_NUMEROSIT,SUM(GPT_TOTALTTCDEV) AS MTAVANCEUSED '+
           'FROM BSITUATIONS '+
           'LEFT JOIN PIEDPORT ON BST_NATUREPIECE=GPT_NATUREPIECEG AND BST_SOUCHE=GPT_SOUCHE AND BST_NUMEROFAC=GPT_NUMERO '+
           'WHERE '+
           'BST_SSAFFAIRE="'+Affairedevis+'" AND BST_VIVANTE="X" AND BST_NUMEROSIT < '+IntToStr(NumSituation)+' AND GPT_CODEPORT="'+CodePort+'" '+
           'GROUP BY BST_NATUREPIECE,BST_SOUCHE,BST_NUMEROFAC,BST_NUMEROSIT';
    QQ := OpenSql (sql,True,-1,'',true);
    if not QQ.eof then
    begin
      QQ.first;
      while not QQ.eof do
      begin
        Result := Result + QQ.fields[4].asFloat;
        QQ.next;
      end;
    end;
    ferme (QQ);
  finally
    TOBBST.free;
  end;
  if result < 0 then result := result * (-1);
end;

procedure RestitueAvancePOC(TOBFacture,TOBAffaire,TOBPOrcs,TOBBases : TOB;PourcentAvanc : double; DEV : Rdevise; NumSituation : integer);
var TOBP,TOBPORT : TOB;
    MtAvance,DebutRest,FinRest,PourcReel,RelAvance,AvanceRest : double;
    CodePort : String;
    QQ : TQuery;
    DD : TDateTime;
begin
  //
  if NumSituation = -1 then NumSituation := GetNextNumSituation(TOBfacture);
  TOBPORT := TOB.Create('PORT',nil,-1);
  TRY
    MtAvance := TOBAffaire.GetDouble('AFF_MTAVANCE');
    if MtAvance=0 then Exit;
    CodePort := GetparamSocSecur('SO_BTRACPOC',''); if CodePort = '' then exit;
    QQ := OpenSQL('SELECT * FROM PORT WHERE GPO_CODEPORT="'+CodePort+'"',True,1,'',true);
    if not QQ.eof then
    begin
      TOBPORT.SelectDB('',QQ);
    end;
    ferme (QQ);
    AvanceRest := GetAvanceRest (TOBFacture.GetString('GP_AFFAIREDEVIS'),CodePort,NumSituation);
    // UTILISABLE ??
    if TOBPORT.GetString('GPO_CODEPORT')='' then Exit;
    DD := TOBPORT.GetValue('GPO_DATESUP');
    if ((DD < V_PGI.DateEntree) and (DD > iDate1900)) then Exit;
    if (TOBPORT.GetValue('GPO_FRAISREPARTIS')='X')  then Exit;
    if (TOBPORT.GetValue('GPO_FERME') = 'X') then exit;
    //
    DebutRest := TOBAffaire.GetDouble('AFF_DEBRESTAVANCE');
    FinRest := TOBAffaire.GetDouble('AFF_FINRESTAVANCE');
    //
    if (DebutRest = 0) and (FinREst = 0) then
    begin
      PourcReel := PourcentAvanc;
      RelAvance := (MtAvance * PourcReel);
    end else
    begin
      if (PourcentAvanc < DebutRest) then exit;
      //  Soit : (% Avancement - %Debut restitution) / (%Fin de restitution - %Debut restitution) = % de restitution sur cette facture
      PourcReel  := (PourcentAvanc - DebutRest) / (FinRest - DebutRest);
      if PourcentAvanc < FinRest then RelAvance := (MtAvance * PourcReel) - AvanceRest else RelAvance := MtAvance - AvanceRest;
    end;
    TOBP := TOB.Create('PIEDPORT',TOBPOrcs,-1);
    TOBP.SetString('GPT_CODEPORT', CodePort);
    ChargeTobPiedPort (TOBP,TOBPORT,TOBFacture);
    //
    if TOBP.GetBoolean('GPO_RETENUEDIVERSE') then TOBP.SetDouble('GPT_BASETTCDEV', RelAvance)
                                             else TOBP.SetDouble('GPT_BASETTCDEV', RelAvance * -1);
    TOBP.SetDouble('GPT_BASETTC', DeviseToPivot(TOBP.GetDouble('GPT_BASETTCDEV'),DEV.Taux,DEV.Quotite));
    CalculMontantsPiedPort(TobFacture, TOBP,TOBBases);

    //
  FINALLY
    TOBPORT.Free;
  END;

end;

function GetTauxAffairePOC(CodeAffaire : string; DatePiece : TdateTime) : Double;
var TOBAffaire : TOB;
begin
  Result := 0;
  if CodeAffaire='' then Exit;
  TOBAffaire := FindCetteAffaire (CodeAffaire);
  if TOBAffaire = nil then
  begin
    StockeCetteAffaire (CodeAffaire);
    TOBAffaire := FindCetteAffaire (CodeAffaire);
  end;
  if DatePiece >= TOBaffaire.getDateTime('AFF_DATERG') then
  begin
    result := TOBaffaire.getDouble('AFF_TAUXRG');
  end;
end;

procedure EnregistreSit0POC(TOBFacture,TOBSituations : TOB; DEV : Rdevise);
var TT,TOBT,TOBAffaire : TOB;
    CodeAffaire : string;
    Taux : Double;
begin
  CodeAffaire := TOBFacture.getString('GP_AFFAIRE');
  if CodeAffaire='' then Exit;
  if ExisteSQL('SELECT 1 FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+TOBFacture.getString('GP_AFFAIREDEVIS')+'" AND BST_NUMEROSIT=0 AND BST_NATUREPIECE="FBT" AND BST_INDICESIT=0 AND BST_VIVANTE="X"') then
  begin
    ExecuteSQL('DELETE FROM BSITUATIONS WHERE BST_SSAFFAIRE="'+TOBFacture.getString('GP_AFFAIREDEVIS')+'" AND BST_NUMEROSIT=0 AND BST_NATUREPIECE="FBT" AND BST_INDICESIT=0 AND BST_VIVANTE="X"');
  end;

  TOBAffaire := FindCetteAffaire (CodeAffaire);
  if TOBAffaire = nil then
  begin
    StockeCetteAffaire (CodeAffaire);
    TOBAffaire := FindCetteAffaire (CodeAffaire);
  end;
  TT := TOB.Create ('BSITUATIONS',TOBSituations,-1);   
  TT.SetString('BST_NATUREPIECE','FBT');
  TT.SetInteger('BST_NUMEROFAC',0);
  TT.SetString('BST_SOUCHE',GetSoucheG('FBT', TOBFacture.GetValue('GP_ETABLISSEMENT'), TOBFacture.GetValue('GP_DOMAINE')));
  TT.SetInteger('BST_NUMEROSIT',0);
  TT.SetString('BST_AFFAIRE',TOBFacture.getString('GP_AFFAIRE'));
  TT.SetString('BST_SSAFFAIRE',TOBFacture.getString('GP_AFFAIREDEVIS'));
  TT.SetDouble('BST_MONTANTTTC',TOBAffaire.getDouble('AFF_MTAVANCE'));
  TOBT:=VH^.LaTOBTVA.FindFirst(['TV_TVAOUTPF','TV_REGIME','TV_CODETAUX'],['TX1',TOBFacture.GetValue('GP_REGIMETAXE'),'TN'],False) ;
  if TOBT <> nil then Taux:=1+(TOBT.GetValue('TV_TAUXVTE')/100)
                 else Taux := 0;

  TT.SetDouble('BST_MONTANTHT',Arrondi(TT.getDouble('BST_MONTANTTTC')/ Taux,DEV.decimale));
  TT.SetDouble('BST_MONTANTTVA',TT.getDouble('BST_MONTANTTTC')-TT.getDouble('BST_MONTANTHT'));
  TT.SetDateTime('BST_DATESIT',TOBFacture.geTDateTime('GP_DATEPIECE'));
  TT.SetString('BST_VIVANTE','X');
end;

function GetServerName : string;
var Qs : TQuery;
begin
  try
    Qs := OpenSQL('SELECT CAST (@@SERVERNAME AS VARCHAR) AS MONSERVEUR',true);
    if not Qs.Eof then result := Qs.FindField('MONSERVEUR').AsString
                  else result := '';
  finally
    Ferme(Qs);
  end;
end;

function AGLAppelMarcheST( parms: array of variant; nb: integer ) : variant;
var CodeChantier,SousTrait,CodeMarche,DBName,ServerName : string;
    TheLance,EmailPasswd : string;
begin
  EmailPasswd := DecryptageSt(V_PGI.EMailPassword);
  CodeChantier := parms[0];
  SousTrait := parms[1];
  CodeMarche := parms[2];
  DBName := V_PGI.DBName;
  ServerName := GetServerName;
  TheLance := IncludeTrailingBackslash(TcbpPath.GetCegid)+'Specif-POC\APP\MarcheST.exe /userLSE='+V_PGI.User+' /EmailPwd='+EmailPasswd +' /Serveur='+ServerName+' /BaseDeDonnees='+DBName+' /CodeChantier="'+CodeChantier+'" /SousTraitant='+SousTrait+' /CodeMarche='+CodeMarche+' /Action=M';
  FileExecAndWait (TheLance);
end;

function AGLAppelCreationMarcheST( parms: array of variant; nb: integer ) : variant;
var CodeChantier,SousTrait,CodeMarche,DBName,ServerName : string;
    TheLance,EmailPasswd : string;
begin
  EmailPasswd := DecryptageSt(V_PGI.EMailPassword);
  CodeChantier := parms[0];
  DBName := V_PGI.DBName;
  ServerName := GetServerName;
  TheLance := IncludeTrailingBackslash(TcbpPath.GetCegid)+'Specif-POC\APP\MarcheST.exe /userLSE='+V_PGI.User +' /EmailPwd='+EmailPasswd+' /Serveur='+ServerName+' /BaseDeDonnees='+DBName+' /CodeChantier="'+CodeChantier+'" /Action=C';
  FileExecAndWait (TheLance);
end;

function GetInfoMarcheST(Affaire,Fournisseur,CodeMarche,Champs : string) : Variant;
var TT : TOB;
    QQ : TQuery;
    Marche : string;
begin
  Result := #0;
  if (affaire = '') or (Fournisseur='') or (CodeMarche='') then Exit;
  Marche := Copy(CodeMarche,1,8);
  if Marche = '' then exit;
  TT := TOBlesContratsST.FindFirst(['BM0_AFFAIRE','BM0_FOURNISSEUR','BM0_MARCHE'],[Affaire,Fournisseur,Marche],true);
  if TT = nil then
  begin
    QQ := OpenSQL('SELECT * FROM BTMARCHEST WHERE BM0_AFFAIRE="'+Affaire+'" AND BM0_FOURNISSEUR="'+Fournisseur+'" AND BM0_MARCHE="'+Marche+'"',True,1,'',true );
    if not QQ.eof then
    begin
      TT := TOB.Create('BTMARCHEST',TOBlesContratsST,-1);
      TT.SelectDB('',QQ);
    end;
    ferme (QQ);
  end;
  if TT = nil then Exit;
  Result := TT.GetValue('BM0_'+Champs);
end;

procedure LibereMemContratST;
begin
  TOBlesContratsST.ClearDetail;
end;

procedure AppelsBAST;
var DBName,ServerName,EmailPasswd : string;
    TheLance : string;
begin
  DBName := V_PGI.DBName;
  EmailPasswd := DecryptageSt(V_PGI.EmailSmtpPassword);
  ServerName := GetServerName;
  TheLance := IncludeTrailingBackslash(TcbpPath.GetCegid)+'Specif-POC\APP\MarcheST.exe /userLSE='+V_PGI.User +' /Serveur='+ServerName+' /EmailPwd='+EmailPasswd+' /BaseDeDonnees='+DBName+' /Action=S';
  FileExecAndWait (TheLance);
end;


Initialization
 TOBlesContratsST := TOB.create ('LES CONTRATS ST',nil,-1);

 RegisterAglFunc('AppelMarcheST',False,4,AGLAppelMarcheST);
 RegisterAglFunc('AppelCreationMarcheST',False,1,AGLAppelCreationMarcheST);

finalization
 TOBlesContratsST.free;

end.
