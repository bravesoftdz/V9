{***********UNITE*************************************************
Auteur  ...... : Vincent Laroche
Cr�� le ...... : 28/01/2005
Modifi� le ... :   /  /    
Description .. : Remplac� en eAGL par COPIEBUD_TOF.PAS
Mots clefs ... : 
*****************************************************************}
unit CopieBud;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Ent1,
  Hent1, StdCtrls, Buttons, ExtCtrls, HCtrls, hmsgbox, Spin, DB,
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  Hqry, HStatus, SaisUtil, HSysMenu, HPanel, UiUtil, HTB97, Vierge;

Procedure RecopieBudgetSimple ;

type
  TFCopieBud = class(TFVierge)
    Psource: TPanel;
    Bevel1: TBevel;
    TBuds: TLabel;
    TNatS: TLabel;
    NbE: TLabel;
    NbEcr: TLabel;
    Label1: TLabel;
    BudS: THValComboBox;
    GbCS: TGroupBox;
    TExoDebS: TLabel;
    TExoFinS: TLabel;
    ExoDebS: THValComboBox;
    ExoFinS: THValComboBox;
    GenS: TEdit;
    SecS: TEdit;
    SattS: TEdit;
    GattS: TEdit;
    ShS: TEdit;
    AxS: THValComboBox;
    NatS: THValComboBox;
    GbPer: TGroupBox;
    TPerdebS: TLabel;
    TPerFinS: TLabel;
    PerDebS: THValComboBox;
    PerFinS: THValComboBox;
    CbS: THValComboBox;
    PDestination: TPanel;
    TBudD: TLabel;
    TNatD: TLabel;
    TCoef: TLabel;
    LPct: TLabel;
    Label2: TLabel;
    Coef: TEdit;
    BudD: THValComboBox;
    GroupBox2: TGroupBox;
    TExoDebD: TLabel;
    TExoFinD: TLabel;
    ExoDebD: THValComboBox;
    ExoFinD: THValComboBox;
    GenD: TEdit;
    SecD: TEdit;
    GattD: TEdit;
    SattD: TEdit;
    ShD: TEdit;
    AxD: THValComboBox;
    NatD: THValComboBox;
    GroupBox1: TGroupBox;
    TPerdebF: TLabel;
    TPerFinF: TLabel;
    PerDebD: THValComboBox;
    PerFinD: THValComboBox;
    CbD: THValComboBox;
    QCopi: TQuery;
    QNbEcr: TQuery;
    HM: THMsgBox;
    procedure FormShow(Sender: TObject);
    procedure BudSChange(Sender: TObject);
    procedure NatSChange(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    NumPiece : String ;
    NextNumPiece : Longint ;
    Procedure ChargeInfosJournal(Sender : TObject) ;
    Procedure ChercheNbEcr ;
    Function  LanceCopie : Boolean ;
    Function  ControleCopieOk : Boolean ;
    Function  ControleJalOk : Boolean ;
    Function  NumPieceOk : Boolean ;
    Function  ControleNatOk : Boolean ;
    Function  ControleComptesOk : Boolean ;
    Function  ControleAxeOk : Boolean ;
    Function  ControleCptAttOk : Boolean ;
    Function  ControleCoefOk : Boolean ;
    Procedure RunLaCopie ;
    Function  ChargeLesPeriodes : Boolean ;
    Function  ChercheLaDateCompta(D : TDateTime) : TDateTime ;
    Procedure ChageInfoPeriode(Pref : String ; Q : TQuery) ;
  end;

implementation

{$R *.DFM}

Procedure RecopieBudgetSimple ;
var FCopieBud : TFCopieBud ;
    PP : THPanel ;
BEGIN
FCopieBud:=TFCopieBud.Create(Application) ;
PP:=FindInsidePanel ;
if PP=Nil then
   BEGIN
    Try
     FCopieBud.ShowModal ;
    Finally
     FCopieBud.Free ;
    End ;
   SourisNormale ;
   END else
   BEGIN
   InitInside(FCopieBud,PP) ;
   FCopieBud.Show ;
   END ;
END ;


procedure TFCopieBud.FormShow(Sender: TObject);
begin
  inherited;
NumPiece:='' ; NbEcr.Caption:='0' ;
NatS.Value:='INI' ; //QNbEcr.Prepare ;
PrepareSQLODBC(QNbEcr) ;
Coef.Text:='0' ;
end;

procedure TFCopieBud.ChargeInfosJournal(Sender : TObject) ;
Var QLoc  : TQuery ;
    Cb : THValComboBox ;
    Pref : String ;
BEGIN
Cb:=THValComboBox(Sender) ;
Pref:=Copy(Cb.Name,Length(Cb.Name),1) ;
QLoc:=OpenSQL('Select * from BUDJAL Where BJ_BUDJAL="'+Cb.Value+'"',True) ;
if Not QLoc.EOF then
   BEGIN
   THValComboBox(FindComponent('ExoDeb'+Pref)).Value:=QLoc.FindField('BJ_EXODEB').AsString ;
   THValComboBox(FindComponent('ExoFin'+Pref)).Value:=QLoc.FindField('BJ_EXOFIN').AsString ;
   THValComboBox(FindComponent('Ax'+Pref)).Value:=QLoc.FindField('BJ_AXE').AsString ;
   TEdit(FindComponent('Gatt'+Pref)).Text:=QLoc.FindField('BJ_GENEATTENTE').AsString ;
   TEdit(FindComponent('Satt'+Pref)).Text:=QLoc.FindField('BJ_SECTATTENTE').AsString ;
   if QLoc.FindField('BJ_BUDGENES2').AsString<>'' then TEdit(FindComponent('Gen'+Pref)).Text:=QLoc.FindField('BJ_BUDGENES').AsString+QLoc.FindField('BJ_BUDGENES2').AsString
                                                  else TEdit(FindComponent('Gen'+Pref)).Text:=QLoc.FindField('BJ_BUDGENES').AsString ;
   if QLoc.FindField('BJ_BUDSECTS2').AsString<>'' then TEdit(FindComponent('Sec'+Pref)).Text:=QLoc.FindField('BJ_BUDSECTS').AsString+QLoc.FindField('BJ_BUDSECTS2').AsString
                                                  else TEdit(FindComponent('Sec'+Pref)).Text:=QLoc.FindField('BJ_BUDSECTS').AsString ;
   TEdit(FindComponent('Sh'+Pref)).Text:=QLoc.FindField('BJ_COMPTEURNORMAL').AsString ;
   ChageInfoPeriode(Pref,QLoc) ;
   END ;
Ferme(QLoc) ;
END ;

Procedure TFCopieBud.ChageInfoPeriode(Pref : String ; Q : TQuery) ;
Var DDeb,DFin,DTemp : TDateTime ;
    LDat : String ;
BEGIN
DDeb:=Q.FindField('BJ_PERDEB').AsDateTime ; DFin:=Q.FindField('BJ_PERFIN').AsDateTime ;
THValComboBox(FindComponent('PerDeb'+Pref)).Values.Clear ; THValComboBox(FindComponent('PerDeb'+Pref)).Items.Clear ;
THValComboBox(FindComponent('PerFin'+Pref)).Values.Clear ; THValComboBox(FindComponent('PerFin'+Pref)).Items.Clear ;
Repeat
 DTemp:=FindeMois(DDeb) ;
 LDat:=FormatDateTime('mmmm yyyy',DDeb) ; LDat:=FirstMajuscule(LDat) ;
 THValComboBox(FindComponent('PerDeb'+Pref)).Items.Add(LDat) ;
 THValComboBox(FindComponent('PerDeb'+Pref)).Values.Add(DateToStr(DDeb)) ;
 LDat:=FormatDateTime('mmmm yyyy',DTemp) ; LDat:=FirstMajuscule(LDat) ;
 THValComboBox(FindComponent('PerFin'+Pref)).Items.Add(LDat) ;
 THValComboBox(FindComponent('PerFin'+Pref)).Values.Add(DateToStr(DTemp)) ;
 DDeb:=PlusMois(DDeb,1) ;
Until DTemp>=DFin ;
if THValComboBox(FindComponent('PerDeb'+Pref)).Values.Count>0 then
   THValComboBox(FindComponent('PerDeb'+Pref)).Value:=THValComboBox(FindComponent('PerDeb'+Pref)).Values[0] ;
if THValComboBox(FindComponent('PerFin'+Pref)).Values.Count>0 then
   THValComboBox(FindComponent('PerFin'+Pref)).Value:=THValComboBox(FindComponent('PerFin'+Pref)).Values[THValComboBox(FindComponent('PerFin'+Pref)).Values.Count-1] ;
END ;

procedure TFCopieBud.BudSChange(Sender: TObject);
begin
ChargeInfosJournal(Sender) ;
if THValComboBox(Sender).Name='BudS' then ChercheNbEcr ;
end;

Procedure TFCopieBud.ChercheNbEcr ;
Var i : Integer ;
BEGIN
QNbEcr.Close ;
QNbEcr.Params[0].AsString:=BudS.Value ;
QNbEcr.Params[1].AsString:=NatS.Value ;
QNbEcr.Open ; i:=0 ; NumPiece:='' ;
While Not QNbEcr.Eof do
   BEGIN
   NumPiece:=NumPiece+IntToStr(QNbEcr.Fields[0].AsInteger)+';' ;
   Inc(i) ; QNbEcr.Next ;
   END ;
NbEcr.Caption:=IntToStr(i) ;
QNbEcr.Close ;
if i>1 then NbE.Caption:=HM.Mess[10] else NbE.Caption:=HM.Mess[9] ;
END ;

procedure TFCopieBud.NatSChange(Sender: TObject);
begin
if BudS.Value='' then Exit ;
ChercheNbEcr ;
end;

procedure TFCopieBud.BValiderClick(Sender: TObject);
Var io : TIoErr ;
begin
  inherited;
if Not LanceCopie then Exit ;
if Not ControleCopieOk then Exit ;
QCopi.Close ; QCopi.Sql.Clear ; QCopi.Sql.Add('Select * From BUDECR Where BE_BUDJAL="'+W_W+'"') ;
ChangeSql(QCopi) ;
io:=Transactions(RunLaCopie,2) ;
if io<>oeOk then MessageAlerte(HM.Mess[17]) else HM.Execute(18,'','') ;
end;

Function TFCopieBud.LanceCopie : Boolean ;
BEGIN Result:=HM.Execute(0,'','')=mrYes ; END ;

Function TFCopieBud.ChargeLesPeriodes : Boolean ;
Var i : Integer ;
BEGIN
Result:=False ;
CbS.Values.Clear ; CbS.Items.Clear ; CbD.Values.Clear ; CbD.Items.Clear ;
for i:=PerDebS.ItemIndex to PerDebS.Values.Count-1 do
  if DebutdeMois(StrToDate(PerFinS.Values[PerFinS.ItemIndex]))>=StrToDate(PerDebS.Values[i]) then
     BEGIN CbS.Values.Add(PerDebS.Values[i]) ; CbS.Items.Add(PerDebS.Items[i]) ; END ;
if StrToDate(CbS.Values[CbS.Values.Count-1])<DebutdeMois(StrToDate(PerFinS.Values[0])) then
   for i:=0 to PerFinS.ItemIndex do
       BEGIN CbS.Values.Add(DateToStr(DebutDeMois(StrToDate(PerFinS.Values[i])))) ; CbS.Items.Add(PerFinS.Items[i]) ; END ;

for i:=PerDebD.ItemIndex to PerDebD.Values.Count-1 do
  if DebutdeMois(StrToDate(PerFinD.Values[PerFinD.ItemIndex]))>=StrToDate(PerDebD.Values[i]) then
     BEGIN CbD.Values.Add(PerDebD.Values[i]) ; CbD.Items.Add(PerDebD.Items[i]) ; END ;
if StrToDate(CbD.Values[CbD.Values.Count-1])<DebutdeMois(StrToDate(PerFinD.Values[0])) then
   for i:=0 to PerFinD.ItemIndex do
       BEGIN CbD.Values.Add(DateToStr(DebutDeMois(StrToDate(PerFinD.Values[i])))) ; CbD.Items.Add(PerFinD.Items[i]) ; END ;

if CbS.Values.Count<>CbD.Values.Count then BEGIN HM.Execute(16,'','') ; PerFinD.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ControleCopieOk : Boolean ;
BEGIN
Result:=False ;
if Not ControleJalOk     then Exit ;
if Not NumPieceOk        then Exit ;
if Not ControleNatOk     then Exit ;
if Not ControleComptesOk then Exit ;
if Not ControleAxeOk     then Exit ;
if Not ControleCptAttOk  then Exit ;
if Not ControleCoefOk    then Exit ;
if Not ChargeLesPeriodes then Exit ;
Result:=True ;
END ;

Function TFCopieBud.ControleJalOk : Boolean ;
BEGIN
Result:=False ;
if BudS.Value='' then BEGIN HM.Execute(2,'','') ; BudS.SetFocus ; Exit ; END ;
if BudD.Value='' then BEGIN HM.Execute(2,'','') ; BudD.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.NumPieceOk : Boolean ;
BEGIN
Result:=False ;
if NumPiece='' then BEGIN HM.Execute(1,'','') ; BudS.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ControleNatOk : Boolean ;
BEGIN
Result:=False ;
if NatS.Value='' then BEGIN HM.Execute(3,'','') ; NatS.SetFocus ; Exit ; END ;
if NatD.Value='' then BEGIN HM.Execute(3,'','') ; NatD.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ControleComptesOk : Boolean ;
Var StGS,StSS,St : String ;
    i : Integer ;
BEGIN
Result:=False ;
if Length(GenS.Text)<>Length(GenD.Text) then BEGIN HM.Execute(5,'','') ; BudD.SetFocus ; Exit ; END ;
if Length(SecS.Text)<>Length(SecD.Text) then BEGIN HM.Execute(6,'','') ; BudD.SetFocus ; Exit ; END ;
StGS:=Trim(GenS.Text) ; StSS:=Trim(SecS.Text) ; //RR 21/04/2005 FQ 15484
While StGS<>'' do
   BEGIN
   St:=ReadTokenSt(StGS)+';' ; i:=Pos(St,GenD.Text) ;
   if i<=0 then BEGIN HM.Execute(5,'','') ; BudD.SetFocus ; Exit ; END ;
   END ;
While StSS<>'' do
   BEGIN
   St:=ReadTokenSt(StSS)+';' ; i:=Pos(St,SecD.Text) ;
   if i<=0 then BEGIN HM.Execute(6,'','') ; BudD.SetFocus ; Exit ; END ;
   END ;
Result:=True ;
END ;

Function TFCopieBud.ControleAxeOk : Boolean ;
BEGIN
Result:=False ;
if AxS.Value<>AxD.Value then BEGIN HM.Execute(7,'','') ; BudD.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ControleCptAttOk : Boolean ;
BEGIN
Result:=False ;
if GattS.Text<>GattD.Text then BEGIN HM.Execute(11,'','') ; BudD.SetFocus ; Exit ; END ;
if SattS.Text<>SattD.Text then BEGIN HM.Execute(12,'','') ; BudD.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ControleCoefOk : Boolean ;
Const Num = ['0'..'9','.',',','-','+'] ;
Var   i : Integer ;
      St : String ;
      OkOk : Boolean ;
BEGIN
Result:=False ; St:=Coef.Text ; OkOk:=True ;
for i:=1 to Length(St) do
   if (Not(St[i] in Num)) then BEGIN OkOk:=False ; Break ; END ;
if Not OkOk then BEGIN HM.Execute(13,'','') ; Coef.SetFocus ; Exit ; END ;
Result:=True ;
END ;

Function TFCopieBud.ChercheLaDateCompta(D : TDateTime) : TDateTime ;
BEGIN
Result:=StrToDate(CbD.Values[CbS.Values.IndexOf(DateToStr(D))]) ;
END ;

Procedure TFCopieBud.RunLaCopie ;
Var MM : String17 ;
    QLoc : TQuery ;
    i : Integer ;
    Exo,MemoNumPiece : String ;
    DCpta,NowFutur : TDateTime ;
    D,C,UnCoef : Double ;
BEGIN
MM:='' ; QLoc:=Nil ; MemoNumPiece:=NumPiece ; NowFutur:=NowH ;
QCopi.Open ;
While NumPiece<>'' do
  BEGIN
  NextNumPiece:=GetNum(EcrBud,ShD.Text,MM,0) ;
  QLoc:=OpenSql('Select * From BUDECR Where BE_BUDJAL="'+BudS.Value+'" '+
                'And BE_NATUREBUD="'+NatS.Value+'" '+
                'And BE_QUALIFPIECE="N" And BE_NUMEROPIECE="'+ReadTokenSt(NumPiece)+'" '+
                'And BE_DATECOMPTABLE>="'+UsdateTime(StrToDate(PerDebS.Values[PerDebS.ItemIndex]))+'" And '+
                'BE_DATECOMPTABLE<="'+UsDateTime(DebutdeMois(StrToDate(PerFinS.Values[PerFinS.ItemIndex])))+'" Order by BE_DATECOMPTABLE',True) ;
  InitMove(RecordsCount(QLoc),HM.Mess[8]) ;
  While Not QLoc.Eof do
     BEGIN
     DCpta:=ChercheLaDateCompta(QLoc.FindField('BE_DATECOMPTABLE').AsDateTime) ;
     Exo:=QuelExoDt(DCpta) ; UnCoef:=Valeur(Coef.Text) ;
     D:=QLoc.FindField('BE_DEBIT').AsFloat+((QLoc.FindField('BE_DEBIT').AsFloat*UnCoef)/100) ;
     C:=QLoc.FindField('BE_CREDIT').AsFloat+((QLoc.FindField('BE_CREDIT').AsFloat*UnCoef)/100) ;
     QCopi.Insert ; InitNew(QCopi) ;
     for i:=0 to QCopi.FieldCount-1 do
       BEGIN
       if QCopi.Fields[i].FieldName='BE_BUDJAL'        then QCopi.Fields[i].AsVariant:=BudD.Value   else
       if QCopi.Fields[i].FieldName='BE_EXERCICE'      then QCopi.Fields[i].AsVariant:=Exo          else
       if QCopi.Fields[i].FieldName='BE_DATECOMPTABLE' then QCopi.Fields[i].AsVariant:=DCpta        else
       if QCopi.Fields[i].FieldName='BE_DATEMODIF'     then QCopi.Fields[i].AsVariant:=NowFutur     else
       if QCopi.Fields[i].FieldName='BE_AXE'           then QCopi.Fields[i].AsVariant:=AxD.Value    else
       if QCopi.Fields[i].FieldName='BE_NUMEROPIECE'   then QCopi.Fields[i].AsVariant:=NextNumPiece else
       if QCopi.Fields[i].FieldName='BE_DEBIT'         then QCopi.Fields[i].AsVariant:=D            else
       if QCopi.Fields[i].FieldName='BE_CREDIT'        then QCopi.Fields[i].AsVariant:=C            else
       if QCopi.Fields[i].FieldName='BE_NATUREBUD'     then QCopi.Fields[i].AsVariant:=NatD.Value   else
       if QCopi.Fields[i].FieldName='BE_BLOCNOTE'      then
          BEGIN
          if Not TMemoField(QLoc.FindField('BE_BLOCNOTE')).IsNull
             then TMemoField(QCopi.FindField('BE_BLOCNOTE')).Assign(TMemoField(QLoc.FindField('BE_BLOCNOTE'))) ;
          END else
       QCopi.Fields[i].AsVariant:=QLoc.Fields[i].AsVariant ;
       END ;
     QCopi.Post ;
     MoveCur(False) ; QLoc.Next ;
     END ;
  SetIncNum(EcrBud,ShD.Text,NextNumPiece,0) ; FiniMove ; Ferme(QLoc) ; // GP Ferme
  END ;
NumPiece:=MemoNumPiece ;
QCopi.Close ;
END ;

procedure TFCopieBud.FormCreate(Sender: TObject);
begin
  inherited;
PopUpMenu:=ADDMenuPop(PopUpMenu,'','') ;
end;

end.

