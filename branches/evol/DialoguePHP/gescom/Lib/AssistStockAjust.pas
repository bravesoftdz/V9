unit AssistStockAjust;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   assist, HSysMenu, hmsgbox, StdCtrls, HTB97, ComCtrls, ExtCtrls, Hctrls, HEnt1,
   HPanel, UTob,  HStatus, Grids, EntGC,
{$IFDEF EAGLCLIENT}
{$ELSE}
   {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
   HDimension, Mask;

procedure EntreeStockAjust;
function  EntreeStockAjustUnArticle(RefArt,RefDep : string) : Boolean;

type
  TFStockAjust = class(TFAssist)
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PTITRE: THPanel;
    HLabel1: THLabel;
    PanelFin: TPanel;
    TTextFin1: THLabel;
    TTextFin2: THLabel;
    TWarning: THLabel;
    LBX_Param: TListBox;
    HLabel2: THLabel;
    GBParam: TGroupBox;
    TDepot: THLabel;
    Depot: THValComboBox;
    TRecap: THLabel;
    ProgressBar: TProgressBar;
    TProgressBar: THLabel;
    TArticle: THLabel;
    CodeArticle: THCritMaskEdit;
    TCodeArticle: THLabel;
    procedure FormShow(Sender: TObject);
    procedure bFinClick(Sender: TObject);
    procedure bAnnulerClick(Sender: TObject);
    procedure bSuivantClick(Sender: TObject);
    procedure bPrecedentClick(Sender: TObject);

  private
    { Déclarations privées }
    StopTT, TTdebut : boolean;
    i_cpte : integer;
    TobDispoMAJ, TobRecap : TOB;
    RefArticle,RefDepot : string;
    ModifDispo : Boolean;

    //Traitement de MAJ // retourne false si annulation par l'utilisateur
    function TraitementOK : boolean;
    function RecupDepot(Pref,Depot : string) : string;

    //fonctions de traitement des données, recherche des <>
    function  AjustQteStock(TobLigne : TOB ; TypeQte : string) : double; //Rech des pièces dans les lignes de doc
    function  GetParentQte(TOBLigneEtNomen : TOB) : Double;
    function  MAJQuantite (TobDispo : TOB) : boolean; //MAJ des qtés dans la tob
    function  GetPlusMoins(TypeQte,NaturePiece : string) : integer;
    procedure ChargeDispo(TobDispo : TOB ; stArticle,stDepot : string);
    function  ChargeLigne(stArticle, stDepot : string) : TOB;

    //MAJ des quantités dans la TOBDispo
    procedure DebutTransaction;
    procedure MAJTableDispo;

    //Enreg du résultat dans le jal d'événements
    Procedure NoteEvenement(Evenement, Etat : string);

    //Gestion de la tob récap
    procedure ChargeTobRecap(TOBTT : TOB ; stQte : string ; OldQte,NewQte : double);
    function  RechDim(TobDispoArt : TOB) : string;
    procedure RechercheLot; //Recherche dans tob recap tous les articles gérés par lot
    procedure AjouteTobLot(TOBR : TOB); //Ajout de tob lot à toutes les tob recap dont l'article est géré par lot
                                        //si les quantités diffèrent


  public
    { Déclarations publiques }
  end;


implementation

uses InvUtil,StockUtil,UTofAjustStock,UTofConsultStock;

{$R *.DFM}
procedure EntreeStockAjust;
var Fo_Ajust : TFStockAjust;
begin
     Fo_Ajust := TFStockAjust.Create (Application);
     Fo_Ajust.RefArticle:='';
     Fo_Ajust.RefDepot:='';
     Try
         Fo_Ajust.ShowModal;
     Finally
         Fo_Ajust.free;
     End;
end;

function  EntreeStockAjustUnArticle(RefArt,RefDep : string) : Boolean;
var Fo_Ajust : TFStockAjust;
begin
Result:=False;
if (RefArt<>'') and (RefDep<>'')  then
   begin
   Fo_Ajust := TFStockAjust.Create (Application);
   Fo_Ajust.RefArticle:=RefArt;
   Fo_Ajust.RefDepot:=RefDep;
   Try
       Fo_Ajust.ShowModal;
   Finally
       Result:=Fo_Ajust.ModifDispo;
       Fo_Ajust.free;
   End;
   end;
end;

procedure TFStockAjust.FormShow(Sender: TObject);
begin
  inherited;
StopTT:=false; ModifDispo:=False;
Depot.ItemIndex:=0;
if RefDepot<>'' then
   begin
   Depot.Value:=RefDepot;
   Depot.Enabled:=False;
   end;
if RefArticle<>'' then
   begin
   CodeArticle.Visible:=True;
   CodeArticle.text:=Copy(RefArticle,1,18);
   TCodeArticle.Visible:=True;
   end;
end;


////////////////////////////////////////////////////////////////////////////////
//*************************Evénements de la form******************************//
////////////////////////////////////////////////////////////////////////////////

procedure TFStockAjust.bSuivantClick(Sender: TObject);
begin
  inherited;
if (bSuivant.Enabled) then bFin.Enabled := False else bFin.Enabled := True;
LBX_Param.Clear;
LBX_Param.Items.Add('');
LBX_Param.Items.Add('Dépôt : ' + Depot.Text);
if RefArticle<>'' then
   begin
   LBX_Param.Items.Add('Article : ' + CodeArticle.Text);
   end;
end;

procedure TFStockAjust.bPrecedentClick(Sender: TObject);
begin
  inherited;
if (bSuivant.Enabled) then bFin.Enabled := False else bFin.Enabled := True;
end;

procedure TFStockAjust.bFinClick(Sender: TObject);
begin
inherited;
bfin.Enabled:=false;
TobDispoMAJ:=TOB.Create('',nil,-1);
TobRecap := TOB.Create('GCTMPAJUSTSTOCK',nil,-1);
i_cpte:=0;

if  not TraitementOK then
    begin
    NoteEvenement('Traitement interrompu par l''utilisateur','INT');
    end else
    begin
    if TobRecap.Detail.Count > 0 then
       begin
       RechercheLot;
       if ValideStkAjust(TobRecap, Depot.Text) then DebutTransaction
       else NoteEvenement('Traitement annulé','INT');
       end else
       begin    //si pas de <> de stock
       Msg.Execute (3,Caption,'');
       NoteEvenement('Vérification OK','OK');
       end;
    end;
TProgressBar.Caption := ''; TArticle.Caption := '';
ProgressBar.Visible := false;
ProgressBar.Max := 0;
TTDebut:=false;
TobDispoMAJ.Free ; TobRecap.Free;

RestorePage ;
P.ActivePage := PreviousPage;
PChange(nil) ;
bPrecedent.Enabled := false;
end;

procedure TFStockAjust.bAnnulerClick(Sender: TObject);
begin
  inherited;
if not TTdebut then exit;
if Msg.Execute (1,Caption,'')=mryes then StopTT:=True
   else ModalResult:=0;
end;


////////////////////////////////////////////////////////////////////////////////
//*************************Chargement de la tob dispo*************************//
////////////////////////////////////////////////////////////////////////////////

////////Traitement d'ajustement du stock
function TFStockAjust.TraitementOK : boolean;
var i_dep,i_art : integer;
    TobDispo,TobAMvt : TOB;
    stSQL, stArticle, stDepot,WhereArt,FinSql : string;
begin
//Initialisation
Result := true ; TTdebut:=true;
stDepot := ''; WhereArt:='';
FinSql:=' ORDER BY GA_ARTICLE';
ProgressBar.Visible := true;
TobAMvt := TOB.Create('',nil,-1);

for i_dep := 1 to Depot.Items.Count -1 do
    begin
    if (Depot.Value <> '') and (Depot.Value <> Depot.Values[i_dep]) then continue;
    stDepot := Depot.Values[i_dep];
    if RefArticle<>'' then
       begin
       WhereArt:=' GA_ARTICLE="'+RefArticle+'" AND (';
       FinSql:=')';
       end;
     //récup des identifiants article mouvementés ou présent dans dispo
    stSQL := 'SELECT DISTINCT GA_ARTICLE, GA_LIBELLE FROM ARTICLE WHERE '+WhereArt+' EXISTS '+
        '(SELECT GQ_ARTICLE FROM DISPO WHERE GQ_ARTICLE=ARTICLE.GA_ARTICLE AND GQ_CLOTURE="-"'+RecupDepot('GQ',stDepot)+') OR EXISTS '+
        '(SELECT GL_ARTICLE FROM LIGNE WHERE GL_ARTICLE=ARTICLE.GA_ARTICLE AND GL_ARTICLE<>"" AND GL_TENUESTOCK="X" '
         +RecupDepot('GL',stDepot)+' AND GL_QUALIFMVT<>"ANN" '+') OR EXISTS '+
        '(SELECT GLN_ARTICLE FROM LIGNENOMEN LEFT JOIN LIGNE ON '+
        '(GL_NATUREPIECEG=GLN_NATUREPIECEG AND GL_SOUCHE=GLN_SOUCHE AND GL_NUMERO=GLN_NUMERO AND GL_INDICEG=GLN_INDICEG AND GL_NUMLIGNE=GLN_NUMLIGNE) '+
        'WHERE GLN_ARTICLE=ARTICLE.GA_ARTICLE AND GLN_ARTICLE<>"" AND GLN_TENUESTOCK="X" '
         +RecupDepot('GL',stDepot)+' AND GL_QUALIFMVT<>"ANN" )'+FinSql;

    TobAMvt.LoadDetailFromSQL(stSQL);
    ProgressBar.Max := TobAMvt.Detail.Count;
    TProgressBar.Caption := Msg.Mess[5] + Depot.items[i_dep];

    for i_art := 0 to TobAMvt.Detail.Count -1 do
        begin
        stArticle := TobAMvt.Detail[i_art].GetValue('GA_ARTICLE');
        TArticle.Caption := Msg.Mess[6] + Trim(Copy(TobAMvt.Detail[i_art].GetValue('GA_ARTICLE'),1,18)) + '  ' +
            TobAMvt.Detail[i_art].GetValue('GA_LIBELLE');
        if StopTT then
           begin
           Result := false;
           TobAMvt.Free;
           exit;
           end;
        //Chargement des infos
        TobDispo := TOB.Create('DISPO',TobDispoMAJ,-1);
        ChargeDispo(TobDispo,stArticle,stDepot);
        ProgressBar.StepIt;
        if not MAJQuantite(TobDispo) then TobDispo.Free;//Dispo correct donc pas de MAJ
        end;
    TobAMvt.ClearDetail;
    ProgressBar.Max := 0;
    end;
TobAMvt.Free;
end;

function TFStockAjust.RecupDepot(Pref,Depot : string) : string;
begin
if Depot <> '' then Result := ' AND '+ Pref +'_DEPOT="' + Depot + '"'
    else Result := '';
end;


////////MAJ des quantités dans la TOB Dispo
function TFStockAjust.MAJQuantite (TobDispo : TOB) : boolean;
var  TQte : TQtePrixRec;
     Change : boolean;
     TobLigne : TOB;
     QtePhys,LivreCli, LivreFou, ReserveCli, ReserveFou, PrepaCli : double;
     StArt,stDep : string;
begin
Change := false;
QtePhys := TobDispo.GetValue('GQ_PHYSIQUE');
stArt := TobDispo.GetValue('GQ_ARTICLE');
stDep := TobDispo.GetValue('GQ_DEPOT');
TQte := TQtePrixRec(GetQtePrixDateListe(stArt,stDep,StrToDate('31/12/2099')));
if TQte.SomethingReturned then
   begin
   if Arrondi(TQte.Qte,V_PGI.OkDecQ) <> QtePhys then
      begin
      ChargeTobRecap(TobDispo,'Qté Physique',QtePhys,TQte.Qte);
      TobDispo.PutValue('GQ_PHYSIQUE',TQte.Qte);
      TobDispo.PutValue('GQ_DPA',TQte.DPA);
      TobDispo.PutValue('GQ_DPR',TQte.DPR);
      TobDispo.PutValue('GQ_PMAP',TQte.PMAP);
      TobDispo.PutValue('GQ_PMRP',TQte.PMRP);
      Change := true;
      end;
   end else TobDispo.PutValue('GQ_PHYSIQUE',0);

TobDispo.PutValue('GQ_LIVRECLIENT',0);
TobDispo.PutValue('GQ_LIVREFOU',0);
TobDispo.PutValue('GQ_RESERVECLI',0);
TobDispo.PutValue('GQ_RESERVEFOU',0);
TobDispo.PutValue('GQ_PREPACLI',0);

TobLigne := ChargeLigne(stArt,stDep);

if TobLigne.Detail.Count>0 then
   begin
   LivreCli:=AjustQteStock(TobLigne,'LC');
   if LivreCli <> TobDispo.GetValue('GQ_LIVRECLIENT') then
      begin
       ChargeTobRecap(TobDispo,'Livré client',TobDispo.GetValue('GQ_LIVRECLIENT'),LivreCli);
       TobDispo.PutValue('GQ_LIVRECLIENT',LivreCli);
       Change := true;
       end;

   LivreFou:=AjustQteStock(TobLigne,'LF');
   if LivreFou <> TobDispo.GetValue('GQ_LIVREFOU') then
      begin
      ChargeTobRecap(TobDispo,'Livré fournisseur',TobDispo.GetValue('GQ_LIVREFOU'),LivreFou);
      TobDispo.PutValue('GQ_LIVREFOU',LivreFou);
      Change := true;
      end;

   ReserveCli:=AjustQteStock(TobLigne,'RC');
   if ReserveCli <> TobDispo.GetValue('GQ_RESERVECLI') then
      begin
      ChargeTobRecap(TobDispo,'Reservé client',TobDispo.GetValue('GQ_RESERVECLI'),ReserveCli);
      TobDispo.PutValue('GQ_RESERVECLI',ReserveCli);
      Change := true;
      end;

   ReserveFou:=AjustQteStock(TobLigne,'RF');
   if ReserveFou <> TobDispo.GetValue('GQ_RESERVEFOU') then
      begin
      ChargeTobRecap(TobDispo,'Reservé fournisseur',TobDispo.GetValue('GQ_RESERVEFOU'),ReserveFou);
      TobDispo.PutValue('GQ_RESERVEFOU',ReserveFou);
      Change := true;
      end;

   PrepaCli:=AjustQteStock(TobLigne,'PRE');
   if PrepaCli <> TobDispo.GetValue('GQ_PREPACLI') then
      begin
      ChargeTobRecap(TobDispo,'Preparé client',TobDispo.GetValue('GQ_PREPACLI'),PrepaCli);
      TobDispo.PutValue('GQ_PREPACLI',PrepaCli);
      Change := true;
      end;
   end;
TobLigne.Free;
Result := Change;
end;

procedure TFStockAjust.ChargeDispo(TobDispo : TOB ; stArticle,stDepot : string);
var stSelect : string;
    QDispo : TQuery;
begin
stSelect := ' GA_LOT, GA_LIBELLE, GA_GRILLEDIM1,GA_GRILLEDIM2,GA_GRILLEDIM3,'+
         'GA_GRILLEDIM4,GA_GRILLEDIM5,GA_CODEDIM1,GA_CODEDIM2,GA_CODEDIM3,'+
         'GA_CODEDIM4,GA_CODEDIM5,GA_STATUTART ';
QDispo:=OpenSQL('SELECT DISPO.*, ' + stSelect +
        'FROM DISPO LEFT JOIN ARTICLE ON GQ_ARTICLE=GA_ARTICLE '+
        'WHERE GQ_ARTICLE="'+stArticle+'"'+ RecupDepot('GQ',stDepot) + ' AND GQ_CLOTURE="-"',true,-1,'',true);
if not QDispo.Eof then
     begin
     TobDispo.SelectDB('',QDispo);
     Ferme(QDispo);
     end else
     begin //pb : article mouvementé non présent dans dispo
     Ferme(QDispo);
     TobDispo.InitValeurs;
     QDispo:=OpenSQL('SELECT' + stSelect + 'FROM ARTICLE WHERE GA_ARTICLE="'+stArticle+'"',true,-1,'',true);
     if not QDispo.Eof then TobDispo.SelectDB('',QDispo);
     Ferme(QDispo);
     TobDispo.PutValue('GQ_ARTICLE',stArticle);
     TobDispo.PutValue('GQ_DEPOT',stDepot);
     TobDispo.PutValue('GQ_CLOTURE','-');
     end;
end;

function TFStockAjust.ChargeLigne(stArticle,stDepot : string) : TOB;
var stSQL, stChamp, stWhere : string;
    TobLigne, TobLigneNomen : TOB;
    TOBNew, TOBLN : TOB;
    i_ind : integer;
    ParentQte : double;
begin
TobLigne := TOB.Create('',nil,-1);
stWhere := RecupWhereNaturePiece('LC;LF;RC;RF;PRE','GL');
   if stWhere <> '' then stWhere := ' AND ' + stWhere;

stChamp := 'GL_ARTICLE,GL_DEPOT,GL_QUALIFQTESTO,GL_COEFCONVQTE,GL_QUALIFQTEACH,GL_QUALIFQTEVTE,GL_NATUREPIECEG,GL_DATEPIECE,GL_SOUCHE,GL_NUMERO,GL_INDICEG,GL_NUMLIGNE,GL_PIECEPRECEDENTE,GL_QTESTOCK,GL_QTERESTE,GL_VIVANTE,GL_DPA,GL_DPR';
stSQL := 'SELECT ' + stChamp + ' FROM LIGNE ' +
         'WHERE GL_ARTICLE="'+stArticle+'" '+
{$IFDEF BTP}
				 'AND GL_TYPELIGNE<>"CEN" '+
{$ENDIF}
         'AND GL_DEPOT="'+stDepot+'" '+
         'AND GL_TENUESTOCK="X" AND GL_QUALIFMVT<>"ANN" '+ stWhere +
         'AND GL_VIVANTE="X" ' +
         'ORDER BY GL_DATEPIECE';
TobLigne.LoadDetailFromSQL(stSQL);

///Nomenclatures..
TobLigneNomen := TOB.Create('',nil,-1);
stSQL := 'SELECT '+stChamp+',GLN_ARTICLE,GLN_QUALIFQTESTO , GLN_QUALIFQTEACH , GLN_QUALIFQTEVTE , GLN_COMPOSE, GLN_NATUREPIECEG, GLN_SOUCHE,GLN_NUMERO,GLN_INDICEG,GLN_NUMLIGNE,GLN_ORDRECOMPO, GLN_QTE '+
         ' FROM LIGNENOMEN LEFT JOIN LIGNE ON (GL_NATUREPIECEG=GLN_NATUREPIECEG AND GL_SOUCHE=GLN_SOUCHE AND GL_NUMERO=GLN_NUMERO AND GL_INDICEG=GLN_INDICEG AND GL_NUMLIGNE=GLN_NUMLIGNE) '+
         'WHERE GLN_ARTICLE="'+stArticle+'" '+
         'AND GLN_TENUESTOCK="X" AND GL_QUALIFMVT<>"ANN" '+
         'AND GL_DEPOT="'+stDepot+'" '+ stWhere +
         'AND GL_VIVANTE="X" ' +
         'ORDER BY GL_DATEPIECE';
TobLigneNomen.LoadDetailFromSQL(stSQL);

/////Concaténation de tobLigne et tobLignenomen
for i_ind := 0 to TobLigneNomen.Detail.Count -1 do
  begin
  TOBLN := TobLigneNomen.Detail[i_ind];
  with TOBLN do
   TOBNew := TOBLigne.FindFirst(['GL_NATUREPIECEG', 'GL_DATEPIECE', 'GL_SOUCHE', 'GL_NUMERO', 'GL_INDICEG', 'GL_NUMLIGNE'],
                                 [GetValue('GL_NATUREPIECEG'), GetValue('GL_DATEPIECE'), GetValue('GL_SOUCHE'), GetValue('GL_NUMERO'), GetValue('GL_INDICEG'), GetValue('GL_NUMLIGNE')],
                                 false);
  if TOBNew = nil then
    begin
    TOBNew := TOB.Create('LIGNE', TOBLigne, -1);
    TOBNew.Dupliquer(TOBLN, true, true);
    TOBNew.PutValue('GL_QTESTOCK', 0);
    TOBNew.PutValue('GL_QTERESTE', 0);
    end;

  ParentQte := GetParentQte(TOBLN);
  TOBNew.PutValue('GL_QTESTOCK', TOBNew.GetValue('GL_QTESTOCK') +
                                 (TOBLN.GetValue('GL_QTESTOCK') * ParentQte) );
  TOBNew.PutValue('GL_QTERESTE', TOBNew.GetValue('GL_QTERESTE') +
                                 (TOBLN.GetValue('GL_QTERESTE') * ParentQte) );
  end;
TobLigneNomen.Free;
Result := TobLigne;
end;

//Rech des natures de pièces affectantes la quantité TypeQte
function TFStockAjust.GetPlusMoins(TypeQte,NaturePiece : string) : integer;
begin
result := 0;
if Pos(TypeQte,GetInfoParpiece(NaturePiece,'GPP_QTEPLUS'))> 0 then result := 1 else
if Pos(TypeQte,GetInfoParpiece(NaturePiece,'GPP_QTEMOINS'))> 0 then result := -1;
end;

function TFStockAjust.GetParentQte(TOBLigneEtNomen : TOB) : Double;
var Q : TQuery;
    TOBParent : TOB;
begin
result := TOBLigneEtNomen.GetValue('GLN_QTE');
if (TOBLigneEtNomen.GetValue('GLN_COMPOSE') = null) or
   (TOBLigneEtNomen.GetValue('GLN_COMPOSE') = '') then exit;
Q := OpenSQL('SELECT GLN_NATUREPIECEG,GLN_SOUCHE,GLN_NUMERO,GLN_INDICEG,GLN_NUMLIGNE,GLN_COMPOSE,GLN_ORDRECOMPO,GLN_QTE '+
             'FROM LIGNENOMEN '+
             'WHERE GLN_ARTICLE="'+TOBLigneEtNomen.GetValue('GLN_COMPOSE')+'" '+
                   'AND GLN_NUMORDRE='+IntToStr(TOBLigneEtNomen.GetValue('GLN_ORDRECOMPO'))+' '+
                   'AND GLN_NATUREPIECEG="'+TOBLigneEtNomen.GetValue('GLN_NATUREPIECEG')+'" '+
                   'AND GLN_SOUCHE="'+TOBLigneEtNomen.GetValue('GLN_SOUCHE')+'" '+
                   'AND GLN_NUMERO='+IntToStr(TOBLigneEtNomen.GetValue('GLN_NUMERO'))+' '+
                   'AND GLN_INDICEG='+IntToStr(TOBLigneEtNomen.GetValue('GLN_INDICEG'))+' '+
                   'AND GLN_NUMLIGNE='+IntToStr(TOBLigneEtNomen.GetValue('GLN_NUMLIGNE')), true,-1,'',true);
TOBParent := TOB.Create('LIGNE', nil, -1);
if not TOBParent.SelectDB('', Q) then begin TOBParent.Free; TOBParent := nil; end;
Ferme(Q);
if TOBParent <> nil then begin result := result * GetParentQte(TOBParent);
                               TOBParent.Free; end;
end;

function TFStockAjust.AjustQteStock(TobLigne : TOB ; TypeQte : string) : double;
var itob, fac1 : integer;
    Qte,Ratio : double;
    TOBL  : TOB;
begin
    Result := 0;
    for itob := 0 to TobLigne.Detail.Count -1 do
    begin
        TOBL := TobLigne.Detail[itob];
        Qte := 0;
        fac1 := GetPlusMoins(TypeQte,TOBL.GetValue('GL_NATUREPIECEG'));
        if fac1 <> 0 then
//  BBI
//            Qte := (fac1 * (TOBL.GetValue('GL_QTESTOCK')-TOBL.GetValue('GL_QTERESTE')));
            Qte := (fac1 * TOBL.GetValue('GL_QTERESTE'));

        if TOBL.FieldExists('GLN_QUALIFQTESTO') then // nomenclature
            Ratio:=GetRatio (TOBL,TOBL, trsStock)
        else Ratio:=GetRatio (TOBL,nil, trsStock);
        Qte:=Arrondi(Qte/Ratio,V_PGI.OkDecQ) ;
        Result := Result + Qte;
    end;
    if Result < 0 then Result := 0;  // JS le 31/10/2003
end;

//Gestion de la tob recap
procedure TFStockAjust.ChargeTobRecap(TOBTT : TOB ; stQte : string ; OldQte,NewQte : double);
var TobR : TOB;
begin
TOBR:=TOB.Create('GCTMPAJUSTSTOCK',TobRecap,-1);
TOBR.InitValeurs;
TOBR.PutValue('GZE_UTILISATEUR',V_PGI.USer);
TOBR.PutValue('GZE_COMPTEUR',i_cpte);
TOBR.PutValue('GZE_ARTICLE',TOBTT.GetValue('GQ_ARTICLE'));
TOBR.PutValue('GZE_DEPOT',TOBTT.GetValue('GQ_DEPOT'));
TOBR.PutValue('GZE_RUBRIQUE',stQte);
TOBR.PutValue('GZE_OLDQTE',OldQte);
TOBR.PutValue('GZE_NEWQTE',NewQte);
TOBR.PutValue('GZE_NUMEROLOT','');
if TOBTT.GetValue('GA_STATUTART') = 'DIM' then
   TOBR.PutValue('GZE_DIM',RechDim(TOBTT));
TOBR.AddChampSup('LIBELLE',false);
TOBR.AddChampSup('LOT',false);
TOBR.PutValue('LOT',TOBTT.GetValue('GA_LOT'));
TOBR.PutValue('LIBELLE',TOBTT.GetValue('GA_LIBELLE'));

i_cpte:=i_cpte+1;
end;

function TFStockAjust.RechDim(TobDispoArt : TOB) : string;
var i_indDim : integer;
    GrilleDim,CodeDim,LibDim,StDim : string;
begin
StDim:='';
for i_indDim := 1 to MaxDimension do
    begin
    GrilleDim := TobDispoArt.GetValue ('GA_GRILLEDIM' + IntToStr (i_indDim));
    CodeDim := TobDispoArt.GetValue ('GA_CODEDIM' + IntToStr (i_indDim));
    LibDim := GCGetCodeDim (GrilleDim, CodeDim, i_indDim);
    if LibDim <> '' then
       if StDim='' then StDim:=StDim + LibDim
       else StDim := StDim + ' - ' + LibDim;
    end;
Result := stDim;
end;

procedure TFStockAjust.RechercheLot;
var TobR : TOB;
    stArt, stDep : string;
begin
stArt:=''; stDep:='';
TobR := TobRecap.FindFirst(['LOT'],['X'],false);
While TobR <> nil do
    begin
    if (TobR.GetValue('GZE_ARTICLE')<>stArt) or (TobR.GetValue('GZE_DEPOT')<>stDep) then
       AjouteTobLot(TobR);
    stArt:=TobR.GetValue('GZE_ARTICLE');
    stDep:=TobR.GetValue('GZE_DEPOT');
    TobR := TobRecap.FindNext(['LOT'],['X'],false);
    end;
end;


procedure TFStockAjust.AjouteTobLot(TOBR : TOB);
var QLot : TQuery;
begin
QLot := OpenSQL('SELECT * FROM DISPOLOT WHERE GQL_ARTICLE="'
                +TOBR.GetValue('GZE_ARTICLE')+'" AND GQL_DEPOT="'
                +TOBR.GetValue('GZE_DEPOT')  +'"',true,-1,'',true);
if not QLot.Eof then TOBR.LoadDetailDB('DISPOLOT','','',QLot,false);
Ferme(QLot);
if TOBR.Somme('GQL_PHYSIQUE',[''],[''],true) = TOBR.GetValue('GZE_NEWQTE') then
   begin  //Qté dans dispolot correcte donc pas de réajustement des lots
   TOBR.ClearDetail;
   TOBR.PutValue('LOT','-');
   end;
end;

////////////////////////////////////////////////////////////////////////////////
////MAJ des tables Dispo, Dispolot
procedure TFStockAjust.DebutTransaction;
var ioerr : TIOErr ;
begin
ioerr := Transactions(MAJTableDispo,2);
if ioerr <> oeOk then
   begin
   ModifDispo:=False;
   Msg.Execute (2,Caption,'');
   NoteEvenement('Erreur - Opération annulée','ERR');
   end else
   begin
   ModifDispo:=True;
   NoteEvenement('Le traitement s''est correctement effectué','OK');
   Msg.Execute (4,Caption,'');
   end;
end;

procedure TFStockAjust.MAJTableDispo; //Maj Dispo, DispoLot
var i_lot : integer;
    TOBR, TobLot : TOB;
begin
TOBDispoMAJ.InsertOrUpdateDB(true);
if TobRecap.Detail.Count<=0 then exit;
TobR := TobRecap.FindFirst(['LOT'],['X'],false);
if TobR = nil then exit;
TobLot:=TOB.Create('',nil,-1);
While TobR <> nil do
    begin
    ExecuteSQL('DELETE FROM DISPOLOT WHERE GQL_ARTICLE="'+ TOBR.GetValue('GZE_ARTICLE') +
                              '" AND GQL_DEPOT="' + TOBR.GetValue('GZE_DEPOT') + '"');
    for i_lot := TOBR.Detail.Count -1 downto 0 do
           TOBR.Detail[i_lot].ChangeParent(TobLot,-1);
    TobR := TobRecap.FindNext(['LOT'],['X'],false);
    end;
TobLot.SetAllModifie(True);
TobLot.InsertDB(nil);
TobLot.Free;
end;

////////////////////////////////////////////////////////////////////////////////
////Enreg du résultat dans le jal d'événements
Procedure TFStockAjust.NoteEvenement(Evenement, Etat : string);
var TobJNL : TOB;
    Mess : TStringList;
    Indice : integer;
    QIndice : TQuery;
begin
//exit;
Indice := 0;
Mess := TStringList.Create;
Mess.Clear;
Mess.Add(PTITRE.Caption);
Mess.Add('Traitement effectué pour le dépôt  : '+Depot.Text);
If RefArticle <>'' then Mess.Add('Vérification unitaire pour l''article référence : '+RefArticle);
Mess.Add(Evenement);
QIndice := OpenSQL('SELECT MAX(GEV_NUMEVENT) FROM JNALEVENT',true,-1,'',true);
if not QIndice.Eof then
     Indice := QIndice.Fields[0].AsInteger + 1;
Ferme(QIndice);

TobJNL := TOB.Create('JNALEVENT',nil,-1);

TobJNL.PutValue('GEV_NUMEVENT',Indice);
TobJNL.PutValue('GEV_TYPEEVENT','STK');
TobJNL.PutValue('GEV_LIBELLE',PTITRE.Caption);
TobJNL.PutValue('GEV_DATEEVENT',V_PGI.DateEntree);
TobJNL.PutValue('GEV_UTILISATEUR',V_PGI.USer);
TobJNL.PutValue('GEV_ETATEVENT',Etat);
TobJNL.PutValue('GEV_BLOCNOTE', Mess.Text);
TobJNL.InsertDB(nil);
TobJNL.free;
Mess.Free;
end;

end.
