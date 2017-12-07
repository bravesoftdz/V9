{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 20/02/2007
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTISFACTURE ()
Mots clefs ... : TOF;BTISFACTURE
*****************************************************************}
Unit BTISFACTURE_TOF ;

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
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     Stat,
     EntGc,
     UtilPgi,
     utofAfBaseCodeAffaire,
     UTOF,uEntCommun ;

Type
  TOF_BTISFACTURE = Class (TOF_AFBASECODEAFFAIRE)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);override ;
  private
  	TOBresultat : TOB;
  	ISFACTURE : TCheckBox;
  	FACTURE,FACTURE_ : THEDIT;
    GP_NATUREPIECEG : THValComboBox;
    procedure NaturePieceChanged (Sender : TObject);
    procedure generelaTOB;
    procedure AddChampTOB (UneTOB : TOB);
    function  EncodeRefPieceDBTLoc (TOBP : TOB) : string;
    procedure GenerelaTOBPourDBT;
    procedure AjouteDBTResultat(TOBD, TOBF: TOB);
    procedure chargelesPieces(TOBL, TOBIni : TOB);
    procedure GenerelaTOBPourFBT;
    procedure AjouteFBTResultat(TOBF, TOBD : TOB);
    function FindLibelleAffaire(CodeAffaire: string): string;
  end ;

Implementation

procedure TOF_BTISFACTURE.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTISFACTURE.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTISFACTURE.OnUpdate ;
begin
  Inherited ;
  generelaTOB;
  if TOBresultat.detail.count > 0 then
  begin
  	TFStat(Ecran).LaTOB := TOBresultat
  end;
end ;

procedure TOF_BTISFACTURE.OnLoad ;
begin
  Inherited ;
  NaturePieceChanged (self);
end ;

procedure TOF_BTISFACTURE.OnArgument (S : String ) ;
begin
  Inherited ;
  TOBresultat := TOB.create ('LA TOB',nil,-1);
  ISFACTURE := TCheckBox (GetCONTROL('ISFACTURE'));
  FACTURE := THEDit(GetControl('FACTURE'));
  FACTURE_ := THEDit(GetControl('FACTURE_'));
  GP_NATUREPIECEG := THValComboBox (GetCOntrol('GP_NATUREPIECEG'));
  GP_NATUREPIECEG.OnChange := NaturePieceChanged;
end ;

procedure TOF_BTISFACTURE.OnClose ;
begin
  Inherited ;
  TOBresultat.free;
end ;

procedure TOF_BTISFACTURE.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTISFACTURE.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTISFACTURE.NaturePieceChanged(Sender: TObject);
begin
	if GetCOntrolText('GP_NATUREPIECEG')<>'DBT' Then
  begin
  	ISFACTURE.visible := false;
    TgroupBox(GetControl('GBFACTURE')).visible := false;
  end else
  begin
  	ISFACTURE.visible := True;
    TgroupBox(GetControl('GBFACTURE')).visible := true;
  end;
end;

procedure TOF_BTISFACTURE.generelaTOB;
var NaturePiece : string;
begin
  NaturePiece := GetCOntrolText('GP_NATUREPIECEG');
  if Naturepiece = 'DBT' Then GenerelaTOBPourDBT
  											 else GenerelaTOBPourFBT;
end;

procedure TOF_BTISFACTURE.chargelesPieces (TOBL,TOBIni : TOB);
var Req : string;
		QQ : TQuery;
    TOBLig,TOBP,TOBUP : TOB;
    //TOBD : TOB;
    indice : integer;
    cledoc : r_cledoc;
begin
	TOBIni.ClearDetail;
	TOBLig := TOB.Create ('LES LIGNES',nil,-1);
  Req := 'SELECT GL_NATUREPIECEG,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_DATEPIECE,GL_PIECEPRECEDENTE,GP_TOTALHTDEV FROM LIGNE LEFT JOIN PIECE ON GP_NATUREPIECEG=GL_NATUREPIECEG '+
         'AND GP_SOUCHE=GL_SOUCHE AND GP_NUMERO=GL_NUMERO AND GP_INDICEG=GL_INDICEG WHERE '+
         'GL_NATUREPIECEG="'+TOBL.getValue('GP_NATUREPIECEG') +'" and GL_SOUCHE="'+TOBL.getValue('GP_SOUCHE')+'" '+
         'AND GL_NUMERO='+IntToStr(TOBL.getValue('GP_NUMERO'))+ ' AND GL_INDICEG='+IntToStr(TOBL.getValue('GP_INDICEG'))+' '+
         'AND GL_PIECEPRECEDENTE<>""';
  QQ := OpenSql (req,true);
  TOBLIG.loadDetailDb ('LIGNE','','',QQ,false);
  ferme (QQ);
  for Indice := 0 to TOBLig.detail.count -1 do
  begin
    TOBP := TOBLIg.detail[Indice];
    DecodeRefPiece (TOBP.GetValue('GL_PIECEPRECEDENTE'),cledoc);
    TOBUP := TOBIni.findFirst(['GP_SOUCHE','GP_NUMERO','GP_INDICEG'],[cledoc.souche,cledoc.NumeroPiece,cledoc.Indice],true);
    if TOBUP = nil then
    begin
      QQ := OPenSql ('SELECT GP_SOUCHE,GP_NATUREPIECEG,GP_NUMERO,GP_INDICEG,GP_DATEPIECE,GP_TOTALHTDEV FROM PIECE '+
      							 'WHERE GP_NATUREPIECEG="'+cledoc.NaturePiece+'" AND GP_SOUCHE="'+Cledoc.Souche+'" '+
                     'AND GP_NUMERO='+IntToStr(cledoc.NumeroPiece)+' AND GP_INDICEG='+IntToStr(Cledoc.Indice),true);
    	TOBUP := TOB.Create ('PIECE',TOBINI,-1);
      TOBUP.SelectDB ('',QQ);
      ferme (QQ);
    end;
  end;
  TOBLig.free;
end;

procedure TOF_BTISFACTURE.AjouteFBTResultat (TOBF,TOBD : TOB);
var TOBI : TOB;
		Libelle : string;
begin
	TOBI := TOB.Create ('UNE LIGNE', TOBresultat, -1);
  AddChampTOB (TOBI);
  TOBI.PutValue ('ETATFACTURE','Facturé');

  if TOBF <> nil then
  begin
    TOBI.PutValue ('NATUREPIECED',TOBF.GetValue('GP_NATUREPIECEG'));
    TOBI.PutValue ('LIBNATUREPIECED',Rechdom ('GCNATUREPIECEG',TOBF.GetValue('GP_NATUREPIECEG'),false));
    TOBI.PutValue ('AFFAIRE',TOBF.GetValue('GP_AFFAIRE'));
    TOBI.PutValue ('LIBAFFAIRE',copy(FindLibelleAffaire(TOBF.GetValue('GP_AFFAIRE')),1,35));
    TOBI.PutValue ('NUMEROPIECED',TOBF.GetValue('GP_NUMERO'));
    TOBI.PutValue ('MONTANTD',TOBF.GetDouble('GP_TOTALHTDEV'));
  	TOBI.Putvalue ('DATEPIECEF',TOBF.GetValue('GP_DATEPIECE'));
    Libelle := ' Affaire : '+TOBI.GetValue ('LIBAFFAIRE')+' '+TOBI.GetValue('LIBNATUREPIECED')+' '+
    					 IntToStr(TOBF.GetValue('GP_NUMERO'))+
               ' Montant : '+FloatToStrF (TOBF.GetValue('GP_TOTALHTDEV'),ffNumBer,15,V_PGI.OkDecV);
    TOBI.PutValue ('LIBELLEAFFICHAGED',Libelle);
  end;
  if TOBD <> nil then
  begin
    TOBI.PutValue ('NATUREPIECEF',TOBD.GetValue('GP_NATUREPIECEG'));
    TOBI.PutValue ('LIBNATUREPIECEF',Rechdom ('GCNATUREPIECEG',TOBD.GetValue('GP_NATUREPIECEG'),false) );
    TOBI.PutValue ('NUMEROPIECEF',TOBD.GetValue('GP_NUMERO'));
    TOBI.PutValue ('MONTANTF',TOBD.GetValue('GP_TOTALHTDEV'));
    Libelle := TOBI.GetValue('LIBNATUREPIECEF')+' '+
    					 IntToStr(TOBD.GetValue('GP_NUMERO'))+' Du '+  DateToStr (TOBD.GetValue('GP_DATEPIECE'));
//               ' Montant : '+FloatToStrF (TOBF.GetValue('GP_TOTALHTDEV'),ffNumBer,15,V_PGI.OkDecV);
    TOBI.PutValue ('LIBELLEAFFICHAGEF',Libelle);
  end;
end;

procedure TOF_BTISFACTURE.GenerelaTOBPourFBT;
var TOBDep,TOBIni : TOB;
		NaturePiece : string;
    Req : string;
    QQ : TQuery;
    Indice,Ind : integer;
begin
  Req := TFStat(Ecran).stSQL;
  NaturePiece := GetCOntrolText('GP_NATUREPIECEG');
  TOBresultat.ClearDetail;
  TOBDep := TOB.create ('LES DOCUMENTS',nil,-1);
  TOBIni := TOB.create ('LES DBT',nil,-1);
  QQ := OpenSql (req,True);
  TOBDep.loadDetailDb ('PIECE','','',QQ,false);
  ferme (QQ);
  for Indice := 0 to TOBDep.detail.count -1 do
  begin
  	chargelesPieces (TOBDep.detail[Indice],TOBIni);
    for Ind := 0 to TOBini.detail.count -1 do
    begin
      AjouteFBTResultat (TOBDep.detail[Indice],TOBINI.detail[Ind]);
    end;
  end;
  tobdep.free;
  TOBIni.free;
end;

procedure TOF_BTISFACTURE.GenerelaTOBPourDBT;
var TOBDep : TOB;
		TOBLie : TOB;
		NaturePiece : string;
    Req : string;
    QQ : TQuery;
    Atrouver : string;
    Indice,Ind : integer;
begin

  Req := TFStat(Ecran).stSQL;
  Req := req+ ' AND (SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE=GP_AFFAIREDEVIS) IN ("ACP","TER")';
  
  NaturePiece := GetCOntrolText('GP_NATUREPIECEG');

  TOBresultat.ClearDetail;

  TOBDep := TOB.create ('LES DOCUMENTS',nil,-1);
  TOBLIE := TOB.Create ('LA SUITE',nil,-1);

  QQ := OpenSql (req,True);
  TOBDep.loadDetailDb ('PIECE','','',QQ,false);
  ferme (QQ);

  for Indice := 0 to TOBDep.detail.count -1 do
  begin
  	TOBLIE.clearDetail;
    ATrouver := EncodeRefPieceDBTLoc (TOBDep.detail[Indice]);
    //Req := 'SELECT DISTINCT GL_NATUREPIECEG,GL_NUMERO,GL_INDICEG,GP_TOTALHTDEV,GL_DATEPIECE FROM LIGNE LEFT JOIN PIECE ON GP_NATUREPIECEG=GL_NATUREPIECEG '+
    // Modified by f.vautrain 19/10/2017 10:46:43 - FS#2734 - GUINIER : pointage devis & factures, montant facturé incorrect si plusieurs devis sur facture
    Req := 'SELECT DISTINCT L0.GL_NATUREPIECEG, L0.GL_NUMERO, L0.GL_INDICEG, GP_TOTALHTDEV,';
    Req := Req + '(Select SUM(L1.GL_MONTANTHTDEV) FROM LIGNE AS L1 WHERE L1.GL_NUMERO=L0.GL_NUMERO AND L1.GL_PIECEPRECEDENTE LIKE "' + ATrouver + '%" AND (L1.GL_NATUREPIECEG="FBT" OR L1.GL_NATUREPIECEG="ABT") AND L1.GL_TYPELIGNE = "ART") As MONTANTFAC,';
    Req := Req + 'L0.GL_DATEPIECE FROM LIGNE AS L0 LEFT JOIN PIECE ON GP_NATUREPIECEG=L0.GL_NATUREPIECEG ';
    Req := Req + 'AND GP_SOUCHE=L0.GL_SOUCHE AND GP_NUMERO=L0.GL_NUMERO AND GP_INDICEG=L0.GL_INDICEG WHERE ';
    //FV1 - 28/12/2015 : FS#1830 - ECAL : Devis manquants sur Pointage des factures et devis
    Req := Req + 'L0.GL_PIECEORIGINE LIKE "'+Atrouver+'%" AND (L0.GL_NATUREPIECEG="FBT" OR L0.GL_NATUREPIECEG="ABT")';
    req := Req + ' AND L0.GL_DATEPIECE >="'+ USDATETIME (strtodate(FACTURE.Text)) + '"';
    Req := Req + ' AND L0.GL_DATEPIECE <="'+ USDATETIME (strtodate(FACTURE_.Text))+ '"';
    Req := Req + ' AND GL_TYPELIGNE = "ART"';

    //
    //SELECT DISTINCT L0.GL_NATUREPIECEG, L0.GL_NUMERO, L0.GL_INDICEG, GP_TOTALHTDEV,(Select SUM(GL_MONTANTHTDEV) FROM LIGNE AS L1 WHERE  L1.GL_NUMERO=L0.GL_NUMERO AND L1.GL_PIECEPRECEDENTE LIKE "19102017;DBT;DBT;102840;0;%" AND (L1.GL_NATUREPIECEG="FBT" OR L1.GL_NATUREPIECEG="ABT")) As MONTANTFAC,GL_DATEPIECE FROM LIGNE AS L0 LEFT JOIN PIECE ON GP_NATUREPIECEG=L0.GL_NATUREPIECEG AND GP_SOUCHE=L0.GL_SOUCHE AND GP_NUMERO=L0.GL_NUMERO AND GP_INDICEG=L0.GL_INDICEG WHERE L0.GL_PIECEORIGINE LIKE "19102017;DBT;DBT;102840;0;%" AND (L0.GL_NATUREPIECEG="FBT" OR L0.GL_NATUREPIECEG="ABT") AND L0.GL_DATEPIECE >="19000101 00:00:00" AND L0.GL_DATEPIECE <="20991231 00:00:00"
    //

    QQ := OpenSql (Req,true);
    TOBLie.clearDetail;
    TOBLie.loadDetailDb('LIGNE','','',QQ,false);
    ferme (QQ);
    //
    if (TOBLIe.detail.count = 0) and ((ISFACTURE.State = cbgrayed) or (ISFACTURE.State = cbUnchecked)) then AjouteDBTResultat (TOBDep.detail[Indice],nil);
    //
    if ISFacture.State <> cbUnChecked then
    begin
      for Ind := 0 to TOBLIe.detail.count -1 do
      begin
        AjouteDBTResultat (TOBDep.detail[Indice],TOBLIe.detail[Ind]);
      end;
    end;
  end;
  tobdep.free;
  tobLie.free;
end;

procedure TOF_BTISFACTURE.AddChampTOB(UneTOB: TOB);
begin
  UneTOB.AddChampSupValeur ('ETATFACTURE','Non Facturé');
  UneTOB.AddChampSupValeur ('NATUREPIECED','');
  UneTOB.AddChampSupValeur ('LIBNATUREPIECED','');
  UneTOB.AddChampSupValeur ('NUMEROPIECED',0);
  UneTOB.addChampSupValeur ('LIBELLEAFFICHAGED','');
  UneTOB.AddChampSupValeur ('AFFAIRE','');
  UneTOB.AddChampSupValeur ('LIBAFFAIRE','');
  UneTOB.AddChampSupValeur ('MONTANTD',0.0);
  UneTOB.AddChampSupValeur ('MONTANTF',0.0);
  UneTOB.AddChampSupValeur ('NATUREPIECEF','');
  UneTOB.AddChampSupValeur ('DATEPIECEF','');
  UneTOB.AddChampSupValeur ('LIBNATUREPIECEF','');
  UneTOB.addChampSupValeur ('LIBELLEAFFICHAGEF','');
  UneTOB.AddChampSupValeur ('NUMEROPIECEF',0);
end;

function TOF_BTISFACTURE.EncodeRefPieceDBTLoc(TOBP: TOB): string;
var DD : TDateTime;
    Std : string;
begin
    DD := TOBP.GetValue('GP_DATEPIECE');
    StD := FormatDateTime('ddmmyyyy', DD);
    Result := StD + ';' + TOBP.GetValue('GP_NATUREPIECEG') + ';' + TOBP.GetValue('GP_SOUCHE') + ';'
      + IntToStr(TOBP.GetValue('GP_NUMERO')) + ';' + IntToStr(TOBP.GetValue('GP_INDICEG')) +';';
end;



function TOF_BTISFACTURE.FindLibelleAffaire(CodeAffaire : string) : string;
var QQ : Tquery;
begin
  result := '';
  QQ := OpenSql ('SELECT AFF_LIBELLE FROM AFFAIRE WHERE AFF_AFFAIRE="'+CodeAffaire+'"',true);
  if not QQ.eof then result := QQ.findField ('AFF_LIBELLE').asString;
  ferme (QQ);
end;

procedure TOF_BTISFACTURE.AjouteDBTResultat (TOBD,TOBF : TOB);
var TOBI : TOB;
    TOBL  : TOB;
		Libelle : string;
begin
	TOBI := TOB.Create ('UNE LIGNE', TOBresultat, -1);
  AddChampTOB (TOBI);

  if TOBD <> nil then
  begin
    TOBI.PutValue ('NATUREPIECED',TOBD.GetValue('GP_NATUREPIECEG'));
    TOBI.PutValue ('LIBNATUREPIECED',Rechdom ('GCNATUREPIECEG',TOBD.GetValue('GP_NATUREPIECEG'),false) );
    TOBI.PutValue ('NUMEROPIECED',TOBD.GetValue('GP_NUMERO'));
    TOBI.PutValue ('AFFAIRE',TOBD.GetValue('GP_AFFAIRE'));
    TOBI.PutValue ('LIBAFFAIRE',copy(FindLibelleAffaire(TOBD.GetValue('GP_AFFAIRE')),1,35));
    TOBI.PutValue ('MONTANTD',TOBD.GetValue('GP_TOTALHTDEV'));
    Libelle := ' Affaire : '+TOBI.GetValue ('LIBAFFAIRE')+' '+TOBI.GetValue('LIBNATUREPIECED')+' '+
    					 IntToStr(TOBD.GetValue('GP_NUMERO'))+
               ' Montant : '+FloatToStrF (TOBD.GetValue('GP_TOTALHTDEV'),ffNumBer,15,V_PGI.OkDecV);
    TOBI.PutValue ('LIBELLEAFFICHAGED',Libelle);

  end;

  if TOBF <> nil then
  begin
    TOBI.PutValue ('NATUREPIECEF',    TOBF.GetValue('GL_NATUREPIECEG'));
    TOBI.PutValue ('LIBNATUREPIECEF', Rechdom ('GCNATUREPIECEG',TOBF.GetValue('GL_NATUREPIECEG'),false));
    TOBI.PutValue ('NUMEROPIECEF',    TOBF.GetValue('GL_NUMERO'));
    //TOBI.PutValue ('MONTANTF',        TOBF.GetDouble ('GP_TOTALHTDEV'));
    // Modified by f.vautrain 19/10/2017 11:08:25 - FS#2734 - GUINIER : pointage devis & factures, montant facturé incorrect si plusieurs devis sur facture
    TOBI.PutValue ('MONTANTF',  TOBF.GetValue('MONTANTFAC'));
  	TOBI.PutValue ('ETATFACTURE','Facturé');
  	TOBI.PutValue ('DATEPIECEF',TOBF.GetValue('GL_DATEPIECE'));
    Libelle := TOBI.GetValue('LIBNATUREPIECEF')+' '+
    					 IntToStr(TOBF.GetValue('GL_NUMERO'))+' Du '+  DateToStr (TOBF.GetValue('GL_DATEPIECE'));
//               ' Montant : '+FloatToStrF (TOBF.GetValue('GP_TOTALHTDEV'),ffNumBer,15,V_PGI.OkDecV);
    TOBI.PutValue ('LIBELLEAFFICHAGEF',Libelle);
  end;
end;

procedure TOF_BTISFACTURE.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2,
  Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers,
  Tiers_: THEdit);
begin
  Aff:=THEdit(GetControl('GP_AFFAIRE'));
  Aff0:=THEdit(GetControl('AFFAIRE0'));
  Aff1:=THEdit(GetControl('GP_AFFAIRE1'));
  Aff2:=THEdit(GetControl('GP_AFFAIRE2'));
  Aff3:=THEdit(GetControl('GP_AFFAIRE3'));
  Aff4:=THEdit(GetControl('GP_AVENANT'));
  Tiers:=THEdit(GetControl('GP_TIERS'));
end;

Initialization
  registerclasses ( [ TOF_BTISFACTURE ] ) ;
end.

