{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 08/12/2015
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTGETREGLCPTA ()
Mots clefs ... : TOF;BTGETREGLCPTA
*****************************************************************}
Unit BTGETREGLCPTA_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
{$ENDIF}
     uTob,
     Paramsoc,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     Ent1,
     HTB97,
     vierge,
     UTOF,
     UEntCommun,
     UtilsRapport,
     BTPUtil,
     SAISUtil ;

Type
  TOF_BTGETREGLCPTA = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    OneDateSt : string;
    JusQua : string;
    JournAuxSt : String;
    DateLancement : string;
    TOBReglements : TOB;
    RapportRecup :  TGestionRapport;
    function ConstitueDebExerciceCourant : String;
    procedure TraitementRecuperationReglements;
    procedure GetPiecesRegl(TOBR: TOB);
    function ConstitueJournal: string;
    procedure EnregistreReglPiece(TOBReglFAC : TOB);
    procedure PrepareEnregPiece(TOBR, TOBRP : TOB);
    procedure ChargePiece(TOBpiece, TOBAcomptes: TOB; Cledoc: r_cledoc);
    procedure VerifAcomptes(TOBAcomptes: TOB);
    procedure InscritAcomptes(TOBPiece, TOBAcomptes, TOBReglFac: TOB);
    function ExisteRegl(TOBACC: TOB): boolean;
    procedure NettoieAcomptes(TOBAcomptes: TOB);
    procedure BeforeEcritAcomptes(TOBAcomptes,TOBPiece: TOB);
    procedure EcritInfosDoc(TOBAcomptes, TOBPiece: TOB);
    procedure EnregMtSituation(TObacomptes, TOBpiece: TOB);
  end ;

Implementation

uses DateUtils,factcpta,UtilTOBPiece;

procedure TOF_BTGETREGLCPTA.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTGETREGLCPTA.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTGETREGLCPTA.OnUpdate ;
var yy,mm,dd : word;
    Io : TIOErr; 
begin
  Inherited ;
  RapportRecup.InitRapport;
  if ThEdit(getControl('DATEDEPART')).Text <> DateToStr(StrToDateTime(OneDateSt)) then
  begin
    DecodeDate(StrtoDate(ThEdit(getControl('DATEDEPART')).Text),yy,mm,dd);
    DateLancement := DateTimeToStr(EncodeDateTime(yy,mm,dd,0,0,0,0));
  end else
  begin
    DateLancement := OneDateSt;
  end;
  //
  JUSqua := DateTimetoStr(NowH); // prochaine date de mise a jour
  if PgiAsk ('ATTENTION : Vous allez lancer un traitement qui peut être long.#13#10 Confirmez-Vous ?') <> mryes then
  begin
    TFVierge(Ecran).ModalResult := 0;
    exit;
  end;

  Io := Transactions (TraitementRecuperationReglements,0);
  Case io of
    OeOk : begin
            RapportRecup.AfficheRapport;
            SetParamSoc('SO_BTGETREGLLASTDATE',JUSQUA);
            PgiInfo ('Traitement Effectué avec succès');
           end;
    else
      PgiInfo ('Erreur en cours de traitement des Données');
  end;
  TForm(ecran).ModalResult := 0;
end ;

procedure TOF_BTGETREGLCPTA.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTGETREGLCPTA.OnArgument (S : String ) ;
begin
  Inherited ;

  RapportRecup   := TGestionRapport.Create(TForm(ecran));
  RapportRecup.Titre   := 'Récupération des règlements des factures suivantes';
  RapportRecup.Affiche := True;
  RapportRecup.Close   := True;
  RapportRecup.Sauve   := false;
  RapportRecup.Print   := false;
  RapportRecup.InitRapport;
  RapportRecup.Visible := false;
  RapportRecup.PosLeft := Round(ecran.Width / 1.5);
  RapportRecup.PosTop  := Round(ecran.Top);
  RapportRecup.Width := round(screen.width / 2);

  TOBReglements := TOB.Create ('LES REGELEMENST',nil,-1);
  OneDateSt := GetParamSocSecur('SO_BTGETREGLLASTDATE','');
  JournauxSt := GetParamSocSecur('SO_BTGETJNLCOMPTA','');
  if OneDateSt = '' then
  begin
    OneDateSt := ConstitueDebExerciceCourant;
  end;
  ThEdit(getControl('DATEDEPART')).Text := DateToStr(StrToDateTime(OneDateSt));
  THMultiValComboBox(getControl('JOURNAUX')).Value:= JournauxSt;
end ;

procedure TOF_BTGETREGLCPTA.OnClose ;
begin
  RapportRecup.free;
  TOBReglements.free;
  Inherited ;
end ;

procedure TOF_BTGETREGLCPTA.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTGETREGLCPTA.OnCancel () ;
begin
  Inherited ;
end ;

function TOF_BTGETREGLCPTA.ConstitueDebExerciceCourant: String;
var TheDate : Tdatetime;
    yy,mm,dd : Word;
begin
  TheDate := GetEnCours.Deb;
  DecodeDate (TheDate,yy,mm,dd);
  TheDate := EncodeDateTime (yy,mm,dd,0,0,0,0);
  result := DateTimeToStr(TheDate);
end;


function TOF_BTGETREGLCPTA.ConstitueJournal : string;
var StIn,StST : string;
begin
  StIn := JournauxSt;
  Result := '';
  repeat
    StST := READTOKENST(StIn);
    if StSt <> '' then
    begin
      if result <> '' then result := Result + ',"'+StSt+'"'
                      else result := '"'+StST+'"';
    end;
  until StSt = '';
end;

procedure TOF_BTGETREGLCPTA.TraitementRecuperationReglements;
var QQ : TQuery;
    Req : String;
    II : integer;
begin
  V_PGI.IOError := oeOk;
  TRY
    // récupération des mouvements de règlements clients sur la période définie
    Req := 'SELECT ECRITURE.*, E1.E_NUMTRAITECHQ AS NUMCHEQUE '+
           'FROM ECRITURE '+
           'LEFT JOIN ECRITURE E1 ON '+
           'E1.E_ETABLISSEMENT=ECRITURE.E_ETABLISSEMENT AND '+
           'E1.E_SOCIETE=ECRITURE.E_SOCIETE AND '+
           'E1.E_EXERCICE = ECRITURE.E_EXERCICE AND '+
           'E1.E_GENERAL=ECRITURE.E_CONTREPARTIEGEN AND '+
           'E1.E_JOURNAL=ECRITURE.E_JOURNAL AND '+
           'E1.E_QUALIFPIECE=ECRITURE.E_QUALIFPIECE AND '+
           'E1.E_NATUREPIECE=ECRITURE.E_NATUREPIECE AND '+
           'E1.E_NUMEROPIECE=ECRITURE.E_NUMEROPIECE '+
           'WHERE '+
           'ECRITURE.E_LETTRAGE <> "" AND '+
           'ECRITURE.E_DATEMODIF >="'+ USDATETIME (StrToDateTime(DateLancement)) + '" AND '+
           'ECRITURE.E_DATEMODIF <="'+ USDATETIME (StrToDateTime(JusQua)) + '" AND '+
           'ECRITURE.E_NATUREPIECE IN ("RC","OC") AND ECRITURE.E_AUXILIAIRE <> "" AND '+
           'ECRITURE.E_JOURNAL IN ('+ConstitueJournal+')';
    QQ := OpenSql (REq,true,-1,'',true);
    if not QQ.eof then
    begin
      TOBReglements.LoadDetailDB('UN REGLEMENT','','',QQ,false);
    end;
  FINALLY
    ferme (QQ);
  END;
  if TOBReglements.detail.count > 0 then
  begin
    For II := 0 to TOBReglements.detail.count -1 do
    begin
      GetPiecesRegl(TOBReglements.detail[II]);
      if V_PGI.IOError  <> oeOk then break;
    end;
  end;
end;

procedure TOF_BTGETREGLCPTA.GetPiecesRegl (TOBR : TOB);
var Req : String;
    QQ : TQuery;
    TOBRP : TOB;
    II : integer;
begin
    TOBRP := TOB.create ('LES PIECES REGLEES',nil,-1);

    Req := 'SELECT * '+
           'FROM ECRITURE '+
           'WHERE '+
           'E_EXERCICE = "'+TOBR.GetString('E_EXERCICE')+'" AND '+
           'E_AUXILIAIRE = "'+TOBR.GetString('E_AUXILIAIRE')+'" AND '+
           'E_GENERAL = "'+TOBR.GetString('E_GENERAL')+'" AND '+
           'E_LETTRAGE = "'+TOBR.GetString('E_LETTRAGE')+'" AND '+
           'E_JOURNAL <> "'+TOBR.GetString('E_JOURNAL')+'" AND '+
           'E_REFGESCOM <> "" AND NOT E_NATUREPIECE IN ("RC","OC")';

    QQ := OpenSql (REq,true,-1,'',true);
    TRY
      if not QQ.eof then
      begin
        TOBR.LoadDetailDB('UNE REGLEMENT FAC','','',QQ,false);
        PrepareEnregPiece (TOBR,TOBRP);
        //
        for II := 0 to TOBRP.detail.count -1 do
        begin
          EnregistreReglPiece (TOBRP.detail[II]);
          if V_PGI.ioError <> OeOk then break;
        end;
      end;
    ferme(QQ);
    FINALLY
      TOBRP.free;
    END;
end;

procedure  TOF_BTGETREGLCPTA.PrepareEnregPiece (TOBR,TOBRP : TOB);
var TOBPP : TOB;
    RefPiece : string;
begin
  repeat
    refPiece := TOBR.detail[0].GetString('E_REFGESCOM');
    TOBPP := TOBRP.findFirst(['REFGESCOM'],[RefPiece],true);
    if TOBPP = nil then
    begin
      TOBPP := TOB.Create ('UNE PIECE',TOBRP,-1);
      TOBPP.AddChampSupValeur('REFGESCOM',refPiece);
    end;
    TOBR.detail[0].ChangeParent(TOBPP,-1);
  until TOBR.detail.count =0;
end;

procedure TOF_BTGETREGLCPTA.ChargePiece (TOBpiece,TOBAcomptes: TOB; Cledoc : r_cledoc);
var Sql : string;
    QQ : Tquery;
begin
  Sql := 'SELECT * FROM PIECE WHERE '+WherePiece(Cledoc,ttdPiece,true);
  QQ := OpenSql(SQl,true,1,'',true);
  if not QQ.eof then
  begin
    TOBPiece.SelectDB('',QQ);
  end;
  ferme (QQ);
  Sql := 'SELECT ACOMPTES.*,"X" AS EXISTE,"-" AS ASUPR FROM ACOMPTES WHERE '+
          WherePiece(Cledoc,ttdAcompte,true)+
          ' ORDER BY GAC_JALECR,GAC_NUMECR,GAC_MODEPAIE,GAC_DATEECR';
  QQ := OpenSql(SQl,true,1,'',true);
  if not QQ.eof then
  begin
    TOBAcomptes.LoadDetailDB('ACOMPTES','','',QQ,false);
  end;
  ferme (QQ);
end;

function TOF_BTGETREGLCPTA.ExisteRegl (TOBACC : TOB) : boolean;
var SQl : String;
begin
  SQl := 'SELECT 1 FROM ECRITURE '+
         'WHERE '+
         'E_AUXILIAIRE="'+TOBACC.GetString('GAC_AUXILIAIRE')+'" AND '+
         'E_JOURNAL="'+TOBACC.GetString('GAC_JALECR')+'" AND '+
         'E_NUMEROPIECE='+ TOBACC.GetString('GAC_NUMECR')+ ' AND '+
         'E_MODEPAIE="'+TOBACC.GetString('GAC_MODEPAIE')+'" AND '+
         'E_DATECOMPTABLE="'+USDATETIME(StrToDate(DateToStr(TOBACC.GetDateTime('GAC_DATEECR'))))+'"';
  result := ExisteSQL(SQl);
end;

procedure TOF_BTGETREGLCPTA.VerifAcomptes(TOBAcomptes : TOB);
var II : integer;
begin
  if TOBAcomptes.detail.count = 0 then exit;
  for II := 0 to TOBAcomptes.detail.count -1 do
  begin
    if not ExisteRegl(TOBacomptes.detail[II]) then TOBAcomptes.detail[II].SetString('ASUPR','X');
  end;
end;


procedure TOF_BTGETREGLCPTA.EnregistreReglPiece  (TOBReglFAC : TOB);
var TOBPiece,TOBAcomptes : TOB;
    RefPiece : string;
    Cledoc : R_Cledoc;
    MsgDocument : string;
begin
  TOBPiece := TOB.Create('PIECE',nil,-1);
  TOBACOMPTES := TOB.Create ('LES ACOMPTES',nil,-1);
  TRY
    RefPiece := TOBReglFAC.GetString('REFGESCOM');
    Cledoc := DecodeRefCPGescom (RefPiece);
    ChargePiece (TOBpiece,TOBAcomptes,Cledoc);
    if V_PGI.IOError <> OEOk then Exit;
    VerifAcomptes(TOBAcomptes);
    if V_PGI.IOError <> OEOk then Exit;
    InscritAcomptes (TOBPiece,TOBAcomptes,TOBReglFac);
    if V_PGI.IOError <> OEOk then Exit;
    NettoieAcomptes (TOBAcomptes);
    if V_PGI.IOError <> OEOk then Exit;
    BeforeEcritAcomptes (TOBAcomptes,TOBPiece);
    if V_PGI.IOError <> OEOk then Exit;
    EcritInfosDoc (TOBAcomptes,TOBPiece);
    if V_PGI.IOError <> OEOk then Exit;
    MsgDocument := 'Reglements pour la '+
                   rechdom('GCNATUREPIECEG',TOBpiece.getValue('GP_NATUREPIECEG'),false)+' N° '+
                   InttoStr(TOBPiece.getInteger('GP_NUMERO'))+' '+
                   'd''un montant de '+
                   StrF00(TOBPiece.getDouble('GP_ACOMPTEDEV'),V_PGI.okdecV); 
    RapportRecup.SauveLigMemo(MsgDocument);
  FINALLY
    TOBPiece.free;
    TOBACOMPTES.free;
  END;
end;

procedure TOF_BTGETREGLCPTA.EnregMtSituation (TObacomptes,TOBpiece : TOB) ;
var Req : string;
    MontantRegl,MontantAcompte : double;
    TOBSIt : TOB;
    QQ : TQuery;
begin
  req := 'SELECT * FROM BSITUATIONS WHERE BST_NATUREPIECE="'+TOBPIece.GetValue('GP_NATUREPIECEG')+'" AND ';
  req := Req + 'BST_SOUCHE="'+TOBPIece.GetVAlue('GP_SOUCHE')+'" AND BST_NUMEROFAC="'+inttoStr(TOBPiece.GetValue('GP_NUMERO'))+'"';
  QQ := OpenSql(Req,true,-1,'',true);
  if not QQ.eof then
  begin
    GetMontantsAcomptes (TOBAcomptes,MontantAcompte,MontantRegl);
    TOBSit := TOB.create ('BSITUATIONS',nil,-1);
    TRY
      TOBSIt.SelectDB ('',QQ);
      TOBSIT.PutValue('BST_MONTANTREGL',MontantRegl);
      TOBSIT.PutValue('BST_MONTANTACOMPTE',MontantAcompte);
      TOBSit.SetAllModifie (true);
      if not TOBSIT.UpdateDB (false) then V_PGI.ioerror := oeUnknown;
    FINALLY
      TOBSIT.free;
    END;
  end;
  ferme (QQ);
end;

procedure TOF_BTGETREGLCPTA.EcritInfosDoc (TOBAcomptes,TOBPiece : TOB);
var II : Integer;
begin
  For II := 0 to TOBAcomptes.detail.count -1 do
  begin
    if TOBAcomptes.detail[II].GetString('EXISTE')='X' then
    begin
      if not TOBAcomptes.detail[II].UpdateDB then
      begin
        V_PGI.ioerror := oeUnknown;
      end;
    end else
    begin
      TOBAcomptes.detail[II].SetAllModifie(true);
      if not TOBAcomptes.detail[II].InsertDB(nil) Then
      begin
        V_PGI.ioerror := oeUnknown;
      end;
    end;
  end;
  //
  EnregMtSituation (TObacomptes,TOBpiece);
  if V_PGI.ioerror = OeOk then if not TOBPiece.UpdateDB then V_PGI.ioerror := oeUnknown;
  
end;


procedure TOF_BTGETREGLCPTA.InscritAcomptes (TOBPiece,TOBAcomptes,TOBReglFac : TOB);
var II : integer;
    TOBRF,TOBACC : TOB;
begin
  For II := 0 to TOBReglFac.detail.count -1  do
  begin
    TOBRF := TOBReglFac.detail[II];
    TOBACC := TOBAcomptes.findFirst(['GAC_JALECR','GAC_NUMECR','GAC_MODEPAIE','GAC_DATEECR'],
                                  [TOBRF.GetString('E_JOURNAL'),
                                   TOBRF.GetInteger('E_NUMEROPIECE'),
                                   TOBRF.GetString('E_MODEPAIE'),
                                   TOBRF.GetDateTime ('E_DATECOMPTABLE')],true);
    if TOBACC = nil then
    begin
      //n'existe pas encore..---> c'est un petit nouveauuuu
      TOBACC := TOB.Create ('ACOMPTES',TOBAComptes,-1);
      TOBACC.AddChampSupValeur('EXISTE','-');
      TOBACC.AddChampSupValeur('ASUPR','-');
      TOBACC.SetString('GAC_NATUREPIECEG',TOBpiece.GetString('GP_NATUREPIECEG'));
      TOBACC.SetString('GAC_SOUCHE',TOBpiece.GetString('GP_SOUCHE'));
      TOBACC.SetInteger('GAC_NUMERO',TOBpiece.GetInteger('GP_NUMERO'));
      TOBACC.SetInteger('GAC_INDICEG',TOBpiece.GetInteger('GP_INDICEG'));
      TOBACC.SetString('GAC_JALECR',TOBRF.GetString('E_JOURNAL'));
      TOBACC.SetInteger('GAC_NUMECR',TOBRF.GetInteger('E_NUMEROPIECE'));
      TOBACC.SetDouble('GAC_MONTANT',TOBRF.GetDouble('E_COUVERTURE'));
      TOBACC.SetDouble('GAC_MONTANTDEV',TOBRF.GetDouble('E_COUVERTUREDEV'));
      TOBACC.SetString('GAC_MODEPAIE',TOBRF.GetString('E_MODEPAIE'));
      if TOBRF.GetString('E_NATUREPIECE')='RC' then TOBACC.SetString('GAC_ISREGLEMENT','X') else TOBACC.SetString('GAC_ISREGLEMENT','-'); 
      TOBACC.SetString('GAC_NUMCHEQUE',TOBRF.getstring('NUMCHEQUE'));
      TOBACC.SetString('GAC_LIBELLE',TOBRF.getstring('E_LIBELLE'));
      TOBACC.SetString('GAC_QUALIFPIECE',TOBRF.getstring('E_QUALIFPIECE'));
      TOBACC.SetString('GAC_AUXILIAIRE',TOBRF.getstring('E_AUXILIAIRE'));
      TOBACC.SetString('GAC_CPTADIFF','-');
      TOBACC.PutValue('GAC_DATEECR',TOBRF.GetValue('E_DATECOMPTABLE'));
      TOBACC.PutValue('GAC_DATEECHEANCE',TOBRF.GetValue('E_DATEECHEANCE'));
    end;
  end;
end;

procedure TOF_BTGETREGLCPTA.NettoieAcomptes (TOBAcomptes : TOB);
var II : integer;
begin
  II := 0;
  repeat
    if TOBAcomptes.detail[II].getString('ASUPR')='X' then
    begin
      TOBAcomptes.detail[II].DeleteDB; 
      TOBAcomptes.detail[II].free;
    end else inc(II);
  until II >= TOBAcomptes.detail.count;
end;

procedure TOF_BTGETREGLCPTA.BeforeEcritAcomptes (TOBAcomptes,TOBPiece : TOB);
var II : integer;
    NumOrdre : integer;
    LJALECR : string;
    LNUMECR : integer;
    JALECR : string;
    NUMECR : integer;
    TOBA : TOB;
    Acompte ,AcompteDev : double;
begin
  TOBAcomptes.detail.sort ('GAC_JALECR,GAC_NUMECR');
  NumOrdre := 0;
  Acompte := 0;
  AcompteDev := 0;
  LJALECR := '';
  LNUMECR := 0;
  for II := 0 to TOBAcomptes.detail.count -1 do
  begin
    TOBA := TOBAcomptes.detail[II];

    JALECR := TOBA.getString('GAC_JALECR');
    NUMECR := TOBA.GetInteger('GAC_NUMECR');

    if (JALECR<>LJALECR) or
       (NUMECR<>LNUMECR) then
    begin
      LJALECR := JALECR;
      LNUMECR := NUMECR;
      NumOrdre := 0;
    end else Inc(Numordre);
    TOBA.setInteger('GAC_NUMORDRE',NumOrdre);
    Acompte := Acompte + TOBA.getDouble ('GAC_MONTANT');
    AcompteDEV := AcompteDEV + TOBA.getDouble ('GAC_MONTANTDEV');
  end;
  TOBPiece.SetDouble('GP_ACOMPTE',Acompte);
  TOBPiece.SetDouble('GP_ACOMPTEDEV',AcompteDEV);
end;

Initialization
  registerclasses ( [ TOF_BTGETREGLCPTA ] ) ;
end.
