unit UtilGrpBtp;

interface
Uses HEnt1, HCtrls, UTOB, Ent1, SysUtils, SaisUtil, UtilPGI, AGLInit,
     FactUtil, UtilSais, EntGC, Classes, SaisComm, FactComm, FactNomen,
{$IFDEF EAGLCLIENT}
{$ELSE}
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
     FactAffaire, FactPiece, FactCpta, FactCalc, ParamSoc, UtilArticle,
{$IFDEF BTP}
     BTPUtil,UplannifChUtil,
{$ENDIF}
     FactArticle, DepotUtil, FactTOB,
     FactContreM , StockUtil,uEntCommun ;

procedure UG_reajusteStockPiecePrecedent(TobGenere,TobPiece,TobArticles : TOB);

implementation
uses factgrpBtp;

procedure UG_reajusteStockPiecePrecedent(TobGenere,TobPiece,TobArticles : TOB);
var TOBL,TOBOLDL : TOB;
    indice : integer;
    cledoc : R_CLEDOC;
    precedent,Courant : string;
    ColMoins,ColPlus : string;
    RatioVA : double;
    GereReliquat : boolean;
begin
  for Indice := 0 To TOBGenere.detail.count -1 do
  begin
    TOBL := TOBGenere.detail[Indice];
    // Réajustement des stocks
    Courant := EncodeRefPiece (TOBL,0,true);
    Precedent := TOBL.GetValue('GL_PIECEPRECEDENTE');
    if IsSameDocument (Courant,Precedent) then continue;
    //
    if Precedent <> '' then
    begin
      DecoderefPiece (precedent,cledoc);
      GereReliquat := (GetInfoParPiece(Cledoc.Naturepiece, 'GPP_RELIQUAT')='X');
      TOBOLDL := TOBpiece.findFirst(['GL_NATUREPIECEG','GL_NUMERO','GL_NUMORDRE'],
                                    [cledoc.NaturePiece,cledoc.numeroPiece,Cledoc.NumOrdre],true);
      if TOBOLDL = nil then continue;
      if TOBL.getValue('GL_QTESTOCK') <> 0 then
      begin
      	if GereReliquat then // le document ne gere pas des reliquats
        begin
          TOBOLDL.PutValue('GL_QTERESTE',TOBOLDL.GetValue('GL_QTERESTE')-TOBL.GetValue('GL_QTESTOCK'));
          if TOBOLDL.GetValue('GL_QTERESTE') < 0 then TOBOLDL.PutValue('GL_QTERESTE',0);
        end;
        if (TOBOLDL <> nil) and (TOBOLDL.GetValue('GL_TENUESTOCK')='X') then
        begin
          ColMoins := GetInfoParPiece(Cledoc.Naturepiece, 'GPP_QTEMOINS');
          ColPlus := GetInfoParPiece(Cledoc.Naturepiece, 'GPP_QTEPLUS');
          RatioVA := GetRatio(TOBOLDL, nil, trsStock);
          MajQteStock (TOBL,TOBArticles,nil,ColPlus,ColMoins,false,RatioVa);
        end;
      end;
    end;
  end;
end;
end.
 
