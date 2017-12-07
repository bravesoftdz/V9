unit UTraiteTables;

interface
uses
  Classes, SysUtils,
  uTob, hEnt1, hCtrls,
  EntGC, SaisUtil,
  wCommuns
  ,uEntCommun
  ,UtilConso,
  Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  FactSpec, AffaireUtil, BTPUtil, UgenereDocument,Urapport,forms,Paramsoc
  ;

type
  TID = Integer;
  (*
  TOBPIECES
      |
      |-- NATURE (BLF,FF,...)
      |      |
      |      |- TIERS
      |      |    |
      |      |    |- N�DOCUMENT (ID) PIECE
      |           |       |
      |           |       |- LIGNES
      |
      |
      |
      |
      |
  *)

  TListTOB = class (TList)
  private
    function Add(AObject: TOB): Integer;
    function GetItems(Indice: integer): TOB;
    procedure SetItems(Indice: integer; const Value: TOB);
  public
    property Items [Indice : integer] : TOB read GetItems write SetItems;
  end;

  TImportDatasBSV = class (TObject)
  private
    TOBPieces : TOB;
    TOBTiers : TOB;
    TOBProv : TOB;
    TOBArticlesPlus : TOB;
    ListDoc : TListTOB;
    WithRaport : Boolean;
    rapport :  TFBTRapport;
    function ChargelignesDoc(cledoc : R_CLEDOC;IDEntete : integer; GardeRefPrecedente : Boolean=true) : boolean;
    function AddLigne(TOBL: TOB; IDEntete: integer; GardeRefPrecedente : Boolean=true): boolean;
    function AddCommentaire(TOBL: TOB; IdEntete: integer): boolean;
    procedure SetInfosLigne(TOBL,TOBSCAN : TOB);
    function  InsertLigne(TOBPiece,TOBSCAN : TOB) : TOB;
    function EncodeRefLoc(TOBD: TOB): string;
    procedure EnregistreAction(TOBNat, TOBTiers, TOBDOc : TOB; OneResult: Tresult);
    procedure ClotureScan(TOBDoc: TOB);
    function IsATraite : Boolean;
  public
    property TheRapport : TFBTRapport read rapport write rapport;
    property Atraite : boolean read IsATraite;
    property TOBPROVFac : TOB read TOBProv write TOBProv;
    constructor create (WithReport : Boolean=false);
    destructor destroy; override;

    function AddNewEntete (TOBEntete : TOB) : TID;
    function AddDetails (TOBLIGNES : TOB; IDEntete : TID) : Boolean;
    function Finalise : boolean;
    function SetAllTreated (IDEntete : TID; TOBPROV : TOB) : boolean;
  end;

procedure ConstitueDocsFromDatasBSV (WithReport : Boolean);

implementation
uses FactComm,FactTOB,FactUtil,FactArticle,ENt1,UtilTOBPiece,CalcOLEGenericBTP;

procedure ConstitueDocsFromDatasBSV (WithReport : Boolean);
var II : Integer;
    QQ,QQ1 : TQuery;
    TOBEntetes,TOBLIGNEs,TOBPROV,TOBE : TOB;
    IMPBSV : TImportDatasBSV;
    CurID : TID;
    SQL : String;
    Rapport : TFBTRapport;
begin

  TOBEntetes := TOB.Create ('LES ENTETES',nil,-1);
  TOBLIGNEs := TOB.Create ('LES LIGNES',nil,-1);
  TOBPROV := TOB.Create ('LES PROVENANCES',nil,-1);
  IMPBSV := TImportDatasBSV.create (WithReport);
  if WithReport then
  begin
    Rapport := TFBTRapport.create(application.mainform);
    Rapport.MemoRapport.lines.add('Rien � traiter');
    IMPBSV.rapport := Rapport;
  end;
  try
    QQ := OpenSQL('SELECT * FROM BSVENTETE WHERE B10_TRAITE<> "X"',true,-1,'',true);
    TRY
      if not QQ.Eof then
      begin
        TOBEntetes.LoadDetailDB('BSVENTETE','','',QQ,false);
      end;
    FINALLY
      ferme (QQ);
    end;
    if TOBEntetes.detail.count > 0 then
    begin
      for II := 0 TO TOBEntetes.detail.count -1 do
      begin
        TOBLIGNEs.ClearDetail;
        TOBPROV.ClearDetail;
        TOBE := TOBEntetes.detail[II];
        CurId := IMPBSV.AddNewEntete(TOBEntetes.detail[II]);
        if CurId < 0 then Continue;
        //
        SQL := 'SELECT * FROM BSVLIGNES WHERE '+
                        'B11_FOURNISSEUR = "'+ TOBE.GetString('B10_FOURNISSEUR')+'" AND '+
                        'B11_NATUREPIECE = "'+ TOBE.GetString('B10_NATUREPIECE')+'" AND '+
                        'B11_NUMERODOC = "'+ TOBE.GetString('B10_NUMERODOC')+'"';
        QQ1 := openSql (SQL,True,-1,'',true);
        if not QQ1.eof then
        begin
          TOBLIGNEs.LoadDetailDB('BSVLIGNES','','',QQ1,false);
        end;
        ferme (QQ1);
        if TOBLIGNEs.Detail.count > 0 then
        begin
          IMPBSV.AddDetails (TOBLIGNES,CurID);
        end else
        begin
          SQL := 'SELECT * FROM BSVFROMDOC WHERE '+
                          'B12_FOURNISSEUR = "'+ TOBE.GetString('B10_FOURNISSEUR')+'" AND '+
                          'B12_NATUREPIECE = "'+ TOBE.GetString('B10_NATUREPIECE')+'" AND '+
                          'B12_NUMERODOC = "'+ TOBE.GetString('B10_NUMERODOC')+'"';
          QQ1 := openSql (SQL,True,-1,'',true);
          if not QQ1.eof then
          begin
            TOBPROV.LoadDetailDB('BSVFROMDOC','','',QQ1,false);
          end;
          ferme (QQ1);
          if TOBPROV.detail.count = 0 then continue;
          IMPBSV.SetAllTreated (CurID,TOBPROV);
        end;
      end;
    end;
    TOBLIGNEs.ClearDetail;
    //
    if IMPBSV.Atraite then
    begin
      if TOBPROV.Detail.count > 0 then IMPBSV.TOBPROVFac := TOBProv; // pour les factures achats
      IMPBSV.finalise; // traietement permettant de regrouper les documents en fonction du type receptionn� pour g�n�rer la pi�ce  (ex : reception de CDE FOU --> g�n�ration de la r�ception)
    end;
    //
  finally
    if (WithReport) and (Rapport <> nil) then
    begin
      Rapport.ShowModal;
      Rapport.free;
    end;
    //
    TOBPROV.free;
    TOBEntetes.free;
    TOBLIGNEs.free;
    IMPBSV.free;
  end;
end;

{ TImportDatasBSV }

function TImportDatasBSV.AddCommentaire ( TOBL : TOB ; IdEntete : integer ) : boolean;
Var NewL,TOBP : TOB ;
    RefP : String ;
BEGIN
  Result := false;
  TOBP := ListDoc.GetItems(IDEntete); if TOBP = nil then Exit;
  NewL:=NewTOBLigne(TOBP,-1) ; if TOBL<>Nil then NewL.Dupliquer(TOBL,False,True) ;
  PieceVersLigne(TOBP,NewL);
  NewL.PutValue('GL_NUMORDRE', 0) ;
  RefP:=RechDom('GCNATUREPIECEG',TOBL.GetValue('GL_NATUREPIECEG'),False)
      +' N� '+IntToStr(TOBL.GetValue('GL_NUMERO'))
      +' du '+DateToStr(TOBL.GetValue('GL_DATEPIECE'));
  RefP:=Copy(RefP,1,70) ;
  NewL.PutValue('GL_LIBELLE',RefP)    ; NewL.PutValue('GL_TYPELIGNE','COM') ;
  NewL.PutValue('GL_TYPEDIM','NOR')   ; NewL.PutValue('GL_CODEARTICLE','') ;
  NewL.PutValue('GL_ARTICLE','')      ; NewL.PutValue('GL_QTEFACT',0) ;
  NewL.PutValue('GL_QTESTOCK',0)      ; NewL.PutValue('GL_PUHTDEV',0) ;
  NewL.PutValue('GL_QTERESTE',0)      ; { NEWPIECE }
  // --- GUINIER ---
  NewL.PutValue('GL_MTRESTE',0)       ; { NEWPIECE }

  NewL.PutValue('GL_PUTTCDEV',0)      ; NewL.PutValue('GL_TYPEARTICLE','') ;
  NewL.PutValue('GL_PUHT',0)          ; NewL.PutValue('GL_PUHTNET',0) ;
  NewL.PutValue('GL_PUTTC',0)         ; NewL.PutValue('GL_PUTTCNET',0) ;
  NewL.PutValue('GL_PUHTBASE',0)      ; NewL.PutValue('GL_FAMILLETAXE1','') ;
  NewL.PutValue('GL_TYPENOMENC','')   ; NewL.PutValue('GL_QUALIFMVT','') ;
  NewL.PutValue('GL_REFARTSAISIE','') ; NewL.PutValue('GL_REFARTBARRE','') ;
  NewL.PutValue('GL_REFCATALOGUE','') ; NewL.PutValue('GL_TYPEREF','') ;
  NewL.PutValue('GL_REFARTTIERS','')  ;
  {Modif AC 4/07/03 Pas de GL_CODESDIM sur les lignes commentaire}
  NewL.PutValue('GL_CODESDIM','')  ;
  {Fin Modif AC}
  {Modif JLD 20/06/2002}
  NewL.PutValue('GL_ESCOMPTE',TOBL.GetValue('GL_ESCOMPTE')) ;
  NewL.PutValue('GL_REMISEPIED',TOBL.GetValue('GL_REMISEPIED')) ;
  {Fin modif}

  //JS 17/06/03
  NewL.PutValue('GL_INDICESERIE',0) ; NewL.PutValue('GL_INDICELOT',0) ;
  NewL.PutValue('GL_REMISELIGNE',0) ;
  // Modif BTP
  NewL.PutValue('GL_TYPEARTICLE','EPO');
  NewL.PutValue('GL_PUHTNETDEV',0)    ; NewL.PutValue('GL_PUTTCNETDEV',0) ;
  NewL.PutValue('GL_BLOCNOTE','')    ; NewL.PutValue('GL_QUALIFQTEVTE','') ;
  NewL.PutValue('GL_INDICENOMEN',0) ;
  // ---
  ZeroLigne(NewL) ;
  Result := true;
END ;

function TImportDatasBSV.EncodeRefLoc(TOBD : TOB) : string;
begin
  Result := '';
  if (TOBD.GetDateTime ('B11_DATEORIGINE')=iDate1900) or (TOBD.GetString('B11_NATUREORIGINE')='') or (TOBD.GetString('B11_SOUCHEORIGINE')='') or (TOBD.GetInteger('B11_NUMEROORIGINE')=0) then Exit;
  Result := FormatDateTime('ddmmyyyy',TOBD.GetDateTime ('B11_DATEORIGINE'))+';'+TOBD.GetString('B11_NATUREORIGINE')+';'+TOBD.GetString('B11_SOUCHEORIGINE')+';'+TOBD.GetString('B11_NUMEROORIGINE')+';'+TOBD.GetString('B11_INDICEORIGINE')+';'+TOBD.GetString('B11_NUMORDREORI')+';';
end;

function TImportDatasBSV.AddDetails(TOBLignes: TOB;IDEntete: TID): Boolean;

  function findPieceInProv (cledoc : R_CLEDOC;TOBPIECEREF : TOB) : Boolean;
  begin
    Result := (TOBPIECEREF.FindFirst(['NATUREPIECEG','SOUCHE','NUMERO'],[cledoc.NaturePiece,cledoc.Souche,cledoc.NumeroPiece],true)<>nil);
  end;

  function addRefInProv (cledoc : R_CLEDOC;TOBPIECEREF : TOB) : Boolean;
  var TOBL : TOB;
  begin
    TOBL := TOB.Create('_UNE LIGNE_',TOBPIECEREF,-1);
    TOBL.AddChampSupValeur('NATUREPIECEG',cledoc.NaturePiece);
    TOBL.AddChampSupValeur('SOUCHE',cledoc.souche);
    TOBL.AddChampSupValeur('NUMERO',cledoc.NumeroPiece);
    Result := True;
  end;

  function FindProvenanceInTOB (TOBP : TOB;provenance : string) : TOB;
  begin
    Result := TOBP.findFirst(['GL_PIECEPRECEDENTE'],[Provenance],True);
  end;

var II : Integer;
    TOBD,TOBP,TOBL : TOB;
    cledoc : r_cledoc;
    provenance : string;
    TOBPIECEREF  : TOB;
begin
  Result := false;
  TOBPIECEREF := TOB.Create('LES PIECES',nil,-1);
  TOBP := ListDoc.GetItems(IDEntete); if TOBP = nil then Exit;
  TRY
    // 1er passage -- > recup des lignes provenance (ex : sur reception XXX - commande YYY puis Commande ZZZ)
    for II := 0 to TOBLignes.detail.Count -1 do
    begin
      TOBD := TOBLignes.detail[II];
      provenance := EncodeRefLoc(TOBD);
      if provenance <> '' then
      begin
        DecodeRefPiece(provenance,cledoc);
        if not findPieceInProv (cledoc,TOBPIECEREF) then
        begin
          if not ChargelignesDoc(cledoc,IDEntete) then Exit;
          addRefInProv (cledoc,TOBPIECEREF);
        end;
      end;
    end;
    TOBPieceRef.ClearDetail;
    // second passage --> on positionne les qtes + prix receptionn�es si on trouve une provenance sinon on cr�e une ligne
    for II := 0 to TOBLignes.detail.Count -1 do
    begin
      TOBD := TOBLignes.detail[II];
      TOBP := ListDoc.GetItems(IDEntete); if TOBP = nil then Exit;
      provenance := EncodeRefLoc(TOBD);
      if provenance <> '' then
      begin
        TOBL := FindProvenanceInTOB (TOBP,provenance);
        if TOBL <> nil then
        begin
          SetInfosLigne(TOBL,TOBD);
        end else
        begin
          TOBL := InsertLigne(TOBP,TOBD); // ligne ajout� via BSV
        end;
        if (TOBP.GetString('GP_AFFAIRE')='') and (TOBL.GetString('GL_AFFAIRE')<>'') and (TOBP.GetString('MULTIAFFAIRE')<>'X') then
        begin
          TOBP.SetString('GP_AFFAIRE',TOBL.GetString('GL_AFFAIRE'));
          TOBP.SetString('GP_AFFAIRE1',TOBL.GetString('GL_AFFAIRE1'));
          TOBP.SetString('GP_AFFAIRE2',TOBL.GetString('GL_AFFAIRE2'));
          TOBP.SetString('GP_AFFAIRE3',TOBL.GetString('GL_AFFAIRE3'));
          TOBP.SetString('GP_AVENANT',TOBL.GetString('GL_AVENANT'));
        end else if (TOBP.GetString('GP_AFFAIRE')<>'') and (TOBL.GetString('GL_AFFAIRE')<>'') and (TOBL.GetString('GL_AFFAIRE')<>TOBP.GetString('GP_AFFAIRE')) then
        begin
          TOBP.SetString('GP_AFFAIRE','');
          TOBP.SetString('GP_AFFAIRE1','');
          TOBP.SetString('GP_AFFAIRE2','');
          TOBP.SetString('GP_AFFAIRE3','');
          TOBP.SetString('GP_AVENANT','');
          TOBP.SetString('MULTIAFFAIRE','X');
        end;
      end else
      begin
        // pas de provenance origine --> nouvelle ligne
        TOBL := InsertLigne(TOBP,TOBD); // ligne ajout� via BSV
        TOBL.SetString('GL_AFFAIRE',TOBP.GetString('GP_AFFAIRE'));
        TOBP.SetString('GL_AFFAIRE1',TOBL.GetString('GP_AFFAIRE1'));
        TOBP.SetString('GL_AFFAIRE2',TOBL.GetString('GP_AFFAIRE2'));
        TOBP.SetString('GL_AFFAIRE3',TOBL.GetString('GP_AFFAIRE3'));
        TOBP.SetString('GL_AVENANT',TOBL.GetString('GP_AVENANT'));
      end;
    end;
    Result := True;
  FINALLY
    TOBPIECEREF.Free;
  END;
end;

function TImportDatasBSV.AddLigne(TOBL : TOB; IDEntete : integer; GardeRefPrecedente : Boolean=true): boolean;
var TOBP : TOB;
    RefPiece : string;
begin
  Result := false;
  TOBP := ListDoc.GetItems(IDEntete); if TOBP = nil then Exit;
  RefPiece := EncodeRefPiece(TOBL);
  if GardeRefPrecedente then
  begin
    TOBL.SetString('GL_PIECEPRECEDENTE',RefPiece);
    if TOBL.GetString('GL_PIECEORIGINE')='' then TOBL.SetString('GL_PIECEORIGINE',RefPiece);
  end else
  begin
    TOBL.SetString('GL_PIECEPRECEDENTE','');
  end;
  TOBL.SetInteger('GL_NUMLIGNE',0);
  TOBL.SetInteger('GL_NUMORDRE',0);
  if GardeRefPrecedente then
  begin
    TOBL.SetDouble('GL_QTEFACT',0);
    TOBL.SetDouble('GL_QTERESTE',0);
    TOBL.SetDouble('GL_QTERELIQUAT',0);
  end;
  TOBL.ChangeParent(TOBP,-1);
  PieceVersLigne(TOBP,TOBL);
  result :=true;
end;

function TImportDatasBSV.AddNewEntete(TOBEntete: TOB): TID;
var TOBNAT,TOBTIERS,TOBDOC : TOB;
    Nature,Tiers,Affaire : string;
    Numdoc : string;
    DateDoc : TDateTime;
    cledoc : r_cledoc;
    P0,P1,P2,P3,Av : string;
begin
  FillChar (cledoc,sizeof(cledoc),#0);
  //
  Result := -1;
  Nature := TOBEntete.GetString('B10_NATUREPIECE');
  Tiers := TOBEntete.GetString('B10_FOURNISSEUR');
  NumDoc := TOBEntete.GetString('B10_NUMERODOC');
  DateDoc := StrToDate(DateToStr(TOBEntete.GetDateTime('B10_DATEDOC')));
  Affaire := TOBEntete.GetString('B10_AFFAIRE');
  cledoc.NaturePiece := Nature;
  cledoc.DatePiece := DateDoc;
  //
  TOBNAT := TOBPieces.FindFirst (['NATURE'],[Nature],false);
  if TOBNAT = nil then
  begin
    TOBNAT := TOB.Create('UNE NATURE',TOBPieces,-1);
    TOBNAT.AddChampSupValeur('NATURE',Nature);
  end;
  TOBTIERS := TOBNAT.FindFirst(['FOURNISSEUR'],[Tiers],false);
  if TOBTIERS = nil then
  begin
    TOBTiers := TOB.Create('UN FOURNISSEUR',TOBNAT,-1);
    TOBTIERS.AddChampSupValeur('FOURNISSEUR',Tiers);
  end;
  TOBDOC := TOBTIERS.FindFirst(['GP_REFEXTERNE'],[NumDOc],false);
  if TOBDOC = nil then
  begin
    TOBDOC := CreerTOBPieceVide (cledoc,Tiers,'','','',True,False);
    TOBDOC.ChangeParent(TOBTIERS,-1);
    TOBDOC.AddChampSupValeur('MULTIAFFAIRE','-');
    TOBDOC.Data := TOBEntete;       // on fait pointer cette entete de document sur l'entete des elements scann�s
    TOBDOC.SetString('GP_REFEXTERNE',NumDoc);
    TOBDOC.SetString('GP_BLOCNOTE',TOBEntete.GetString('B10_COMMENTAIRE'));
    TOBDOC.SetString('GP_BSVREF',TOBEntete.GetString('B10_IDZEDOC'));
    TOBDOC.SetString('GP_AFFAIRE',TOBEntete.GetString('B10_AFFAIRE'));
    BTPCodeAffaireDecoupe (TOBEntete.GetString('B10_AFFAIRE'),P0,P1,P2,P3,Av,taCreat,False);
    TOBDOC.SetString('GP_AFFAIRE1',P1);
    TOBDOC.SetString('GP_AFFAIRE2',P2);
    TOBDOC.SetString('GP_AFFAIRE3',P3);
    TOBDOC.SetString('GP_AVENANT',Av);
    Result := ListDoc.Add(TOBDOC);
  end;
end;

function TImportDatasBSV.ChargelignesDoc(cledoc: R_CLEDOC;IDEntete: integer; GardeRefPrecedente : Boolean=true): boolean;
var QQ : TQuery;
    SQl : String;
    TOBLignes,TOBL : TOB;
    II : integer;
    IFirst,WithLigneFac : Boolean;
begin
  Result := false;
  WithLigneFac := (Pos(cledoc.NaturePiece ,'FBT;DAC;FBP;BAC')>0);
  TOBLignes := TOB.Create('LES LIGNES',nil,-1);
  TRY
    Sql := MakeSelectLigneBtp (true,false,WithLigneFac);
    Sql := Sql + ' WHERE ' + WherePiece(CleDoc, ttdLigne,false,true) + ' ORDER BY GL_NUMLIGNE';

    QQ := OpenSQL(SQl,True,-1,'',true);
    if not QQ.eof then
    begin
      TOBLignes.LoadDetailDB('LIGNE','','',QQ,false);
    end;
    Ferme(QQ);
    if TOBLignes.Detail.count > 0 then
    begin
      ifirst := True;
      II := 0;
      repeat
        TOBL := TOBLignes.detail[II];
        if IFirst then
        begin
          AddCommentaire(TOBL, IDEntete);
          IFirst := false;
        end;
        AddLigne (TOBL,IDEntete,GardeRefPrecedente);
      until II >= TOBLignes.Detail.count;  
      Result := True;
    end;
  FINALLY
    TOBLignes.Free;
  END;

end;

constructor TImportDatasBSV.create (WithReport : Boolean=false);
begin
  TOBPieces := TOB.create ('LES DOCUMLENTS',nil,-1);
  ListDoc := TListTOB.Create;
  WithRaport := WithReport;
  TOBArticlesPlus := TOB.Create ('LES ART',nil,-1);
end;

destructor TImportDatasBSV.destroy;
begin
  TOBPieces.free;
  ListDoc.Free;
  TOBArticlesPlus.free;
  inherited;
end;

function TImportDatasBSV.Finalise: boolean;
var XX : TGenerePiece;
    II,JJ,KK : Integer;
    TOBN,TOBT,TOBD : TOB;
    TheResult : Tresult;
begin
  Result := false;
  Rapport.MemoRapport.Clear;
  XX := TGenerePiece.create;
  try
    XX.TOBArticlePlus := TOBArticlesPlus;
    XX.TOBPROVFAC := TOBProv;
    for II := 0 to TOBPieces.detail.count -1 do
    begin
      TOBN := TOBPieces.detail[II]; // Une Nature
      for JJ := 0 to TOBN.Detail.count -1 do
      begin
        TOBT := TOBN.Detail[JJ]; // Un Tiers
        begin
          for KK := 0 to TOBT.Detail.Count -1 do
          begin
            TOBD := TOBT.detail[KK];
            TheResult := XX.GenereDocument(TOBD);
            EnregistreAction (TOBN,TOBT,TOBD,XX.result);
            if TheREsult.ErrorResult = OeOk then  ClotureScan (TOBD);
          end;
        end;
      end;
    end;
  finally
    XX.Free;
  end;
end;

function TImportDatasBSV.InsertLigne(TOBPiece, TOBSCAN: TOB): TOB;

  function ChargeTOBA(RefUnique : string; stDepot : string) : TOB; // DBR : D�pot unique charg�
  var Q : TQuery;
      SQL : String;
      TobArt : TOB;
  begin
    TOBART:=nil;
    SQL := 'SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE,'+
           '"" AS REFARTSAISIE, '+
           '"" AS REFARTBARRE, '+
           '"" AS REFARTTIERS, '+
           '"" AS _FROMOUVRAGE, '+
           '"-" AS SUPPRIME, '+
           '"-" AS UTILISE '+
          'FROM ARTICLE A '+
          'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
          'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE '+
          'WHERE GA_ARTICLE="'+RefUnique+'"';
    Q:=OpenSQL(SQL,True,-1,'',true) ;
    if Not Q.EOF then
    begin
      TobArt := CreerTOBArt(TOBArticlesPlus);
      TobArt.SelectDB('',Q);
      LoadTOBDispo(TobArt, True, '"' + stDepot + '"') ; // DBR : D�pot unique charg�
    end;
    Ferme(Q);
    Result:=TobArt;
  end;


var TOBLigne,TOBART : TOB;
begin
  Result := nil;
  TOBLigne:=NewTOBLigne(TOBPiece,-1) ;
  AddLesSupLigne(TOBLigne,false);
  InitLesSupLigne(TOBLigne);
  PieceVersLigne(TobPiece, TOBLigne);

  TobArt := ChargeTOBA(TOBSCAN.GetString('B11_ARTICLE'),TOBLigne.GetValue('GL_DEPOT'));
  if TOBART = nil then exit;
//
  TobLigne.SetString('GL_TYPEREF', 'ART');
  TobLigne.SetString('GL_ARTICLE', TOBSCAN.GetString('B11_ARTICLE'));
  TobLigne.SetString('GL_CODEARTICLE', copy(TobLigne.GetString('GL_ARTICLE'),1,18));
  TobLigne.SetString('GL_REFARTSAISIE', TobLigne.GetString('GL_CODEARTICLE'));
  TOBLigne.SetDouble('GL_QTEFACT', TOBSCAN.GetDouble('B11_QUANTITE'));
  TobLigne.SetDouble('GL_QTESTOCK', TobLigne.GetDouble('GL_QTEFACT'));
  TobLigne.SetDouble('GL_QTERESTE', TobLigne.GetDouble('GL_QTEFACT'));
  ArticleVersLigne (TOBPiece,TOBART,nil,TOBLigne,TOBTiers);
  { Divers }
  TobLigne.PutValue('GL_PERIODE', GetPeriode(TobLigne.GetValue('GL_DATEPIECE')));
  TobLigne.PutValue('GL_SEMAINE', NumSemaine(TobLigne.GetValue('GL_DATEPIECE')));
  if TobArt.GetValue('GA_STATUTART') = 'UNI' then TobLigne.PutValue('GL_TYPEDIM', 'NOR')
                                             else TobLigne.PutValue('GL_TYPEDIM', TobArt.GetValue('GA_STATUTART'));
  //Laisser ces lignes apr�s PreAffecteLigne :
  if GetInfoParPiece(TOBPiece.getString('GL_NATUREPIECEG'), 'GPP_VENTEACHAT') = 'VEN' then TobLigne.PutValue('GL_QUALIFQTEVTE', TobSCAN.GetValue('B11_UNITE'))
                                                                                      else TobLigne.PutValue('GL_QUALIFQTEACH', TobSCAN.GetValue('B11_UNITE'));
  TobLigne.PutValue('GL_LIBELLE', TobSCAN.GetValue('B11_LIBELLE'));
  if TOBSCAN.GetValue('B11_PRIX') <> 0 then TobLigne.PutValue('GL_PUHTDEV', TOBSCAN.GetValue('B11_PRIX'));
  if (TOBPiece.GetString('GP_NATUREPIECEG')<>'CBT') or
     ((TOBPiece.GetString('GP_NATUREPIECEG')='CBT') and (not GetParamSocSecur('SO_BTLIVBESOINDEF',false))) then
  begin
    if GetParamSocSecur ('SO_BTLIVCHANTIER',True) then TobLigne.PutValue('GL_IDENTIFIANTWOL',-1);
  end;

  TobLigne.SetInteger('GL_NUMLIGNE',0);
  TobLigne.SetInteger('GL_NUMORDRE',0);
  result := TOBLigne;
end;

function TImportDatasBSV.SetAllTreated(IDEntete: TID; TOBPROV : TOB): boolean;
var II : Integer;
    TOBP : TOB;
    cledoc : R_CLEDOC;
begin
  Result := false;
  // 1er passage -- > recup des lignes provenance (ex : sur reception XXX - commande YYY puis Commande ZZZ)
  for II := 0 to TOBPROV.detail.Count -1 do
  begin
    TOBP := TOBPROV.detail[II];
    FillChar(cledoc,SizeOf(Cledoc),#0);
    cledoc.NaturePiece := TOBP.GetString('B12_NATUREORIGINE');
    cledoc.Souche := TOBP.GetString('B12_SOUCHEORIGINE');
    cledoc.NumeroPiece := TOBP.GetInteger('B12_NUMEROORIGINE');
    cledoc.Indice  := StrToInt(TOBP.GetString('B12_INDICEORIGINE'));
    if not ChargelignesDoc(cledoc,IDEntete,false) then Exit; // dans le cas ou l'on a le document complet on ne garde pas le document de reference --> POC
  end;
end;

procedure TImportDatasBSV.SetInfosLigne(TOBL, TOBSCAN: TOB);
begin
  TOBL.SetDouble('GL_QTEFACT',TOBSCAN.GetDouble('B11_QUANTITE'));
  TOBL.SetDouble('GL_QTERESTE',TOBSCAN.GetDouble('B11_QUANTITE'));
  TOBL.SetDouble('GL_QTESTOCK',TOBSCAN.GetDouble('B11_QUANTITE'));
  TOBL.SetDouble('GL_PUHTDEV',TOBSCAN.GetDouble('B11_PRIX'));
end;

procedure TImportDatasBSV.EnregistreAction(TOBNat,TOBTiers, TOBDOc : TOB; OneResult: Tresult);
var  MsgErreur : WideString;
    TOBP : TOB;
begin
  TOBP := TOB(TOBDoc.data);
  if OneResult.ErrorResult = Oeok then
  begin
    MsgErreur := RechDom('GCNATUREPIECEG',TOBP.GetSTring('B10_NATUREPIECE'),false) + ' N� '+TOBP.GetSTring('B10_NUMERODOC')+' pour le tiers :'+TOBP.GetSTring('B10_FOURNISSEUR')+ ' g�n�r� sous le N� interne :'+InttoStr(Oneresult.NumeroDoc);
  end else
  begin
    MsgErreur := 'Une erreur s''est produite durant la g�n�ration de '+RechDom('GCNATUREPIECEG',TOBP.GetSTring('B10_NATUREPIECE'),false) + ' N� '+TOBP.GetSTring('B10_NUMERODOC')+' pour le tiers : '+TOBP.GetSTring('B10_FOURNISSEUR');
  end;
  if MsgErreur <> '' then
  begin
    if WithRaport then Rapport.MemoRapport.Lines.Add(MsgErreur); 
  end;
end;

procedure TImportDatasBSV.ClotureScan(TOBDoc: TOB);
var TOBP : TOB;
begin
  TOBP := TOB(TOBDoc.data);
  ExecuteSql ('UPDATE BSVENTETE '+
              'SET B10_TRAITE="X" '+
              'WHERE '+
              'B10_FOURNISSEUR="'+TOBP.getString('B10_FOURNISSEUR')+'" AND '+
              'B10_NATUREPIECE="'+TOBP.getString('B10_NATUREPIECE')+'" AND '+
              'B10_NUMERODOC="'+TOBP.getString('B10_NUMERODOC')+'"');
end;

function TImportDatasBSV.IsATraite: Boolean;
begin
  Result := (TOBPieces.Detail.count >0);
end;

{ TListTOB }

function TListTOB.Add(AObject: TOB): Integer;
begin
  result := Inherited Add(AObject);
end;

function TListTOB.GetItems(Indice: integer): TOB;
begin
  result := TOB (Inherited Items[Indice]);
end;

procedure TListTOB.SetItems(Indice: integer; const Value: TOB);
begin
  Inherited Items[Indice]:= Value;

end;

end.
