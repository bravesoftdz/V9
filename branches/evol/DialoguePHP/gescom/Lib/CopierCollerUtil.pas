unit CopierCollerUtil;

interface
uses {$IFDEF VER150} variants,{$ENDIF} sysutils,classes,windows,messages,controls,forms,hmsgbox,stdCtrls,clipbrd,nomenUtil,
     HCtrls,SaisUtil,HEnt1,Ent1,EntGC,UtilPGI,UTOB,HTB97,FactUtil,FactComm,Menus,
     FactTOB, FactPiece, FactArticle,
{$IFDEF EAGLCLIENT}
  maineagl,
{$ELSE}
  fe_main,{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
  FactVariante,FactEmplacementLivr,
{$IFDEF BTP}
     BTPUtil,FactOuvrage, UTobDebug,Utilfichiers,
{$ENDIF}
     HRichOLE,UTOFBTMEMORISATION,CBPPath;

const MAXITEMS = 5;

type TCopieColle = class(TObject)
private
    fform : TForm;
    fgrid : THGrid;
    TOBimp : TOB;
    ftransfert : TToolWindow97;
    fmemo : TMemo;
    Mcopy : TstringList;
    RowSelected : integer;
    procedure SetGrid(const Value: THGrid); virtual;
protected
		TempFile : string;
    function    RecupTob(Atob: TOB): Integer;
    procedure   ExportTob(TOBLoc : TOB; ChampBlocNote : string; Newgestion : boolean=false);
public
    constructor create (Parent : TForm);
    destructor  destroy; override;
    property    Grid : THGrid read fgrid write SetGrid;
    Property    TOBTmp : TOB read TOBIMP write TOBImp;
end;

type TCopieColleDoc = class (TcopieColle)
private
		FF : TForm;
    TOBLR : TOB; // ligne a raffraichier
    TOBPiece,TOBArticles,TOBAffaire,TOBCatalogu,TOBCpta,TOBTiers,TOBAnaS,TOBAnaP,TOBAdresses : TOB;
    TOBSerie,TOBDesLots,TobNomen,TOBOuvrage : TOB;
    TOBBases,TOBBasesL : TOB;
    SaContexte : TModeAff;
    GereLot,GereSerie,GereStock : boolean ;
    DEV : RDevise;
    fTypeInfo : string;
    RowCollage : integer;
    ColCollage : integer;
    POPGS : TPopupMenu;
    fcreatedPop : boolean;
    fMaxItems : integer;
    MesMenuItem: array[0..MAXITEMS] of TMenuItem;
    venteAchat : string;
    procedure AjouteLigneSel (TOBSel : TOB; Indice: Integer; WithMemo : boolean=false);
    procedure SetGrid(const Value: THGrid); override;
    function AjouteLigneImport(TOBLoc: TOB; var Niveau, Arow: integer; var SauteAFinPar, ArticleNonOk: boolean): boolean;
    procedure InsertDebParagrapheImp(TOBLOC: TOB; niveau, Arow: integer);
    procedure InsertFinParagrapheImp(TOBLOC: TOB; niveau, Arow: integer);
    function InsertLigneArticleImp(TOBLOC: TOB; var Arow: integer;Niveau: integer; var ArticleNonOk: boolean): boolean;
    procedure InsertLigneCommentaireImp(TOBLoc: TOB; Arow,Niveau: Integer);
    procedure InsertLigneTotalImp(TOBLoc: TOB; Arow, Niveau: integer);
    function IsArticleOk(Arow: integer): boolean;
    procedure Collagedonnee (NewGestion : boolean=false);
    function IsTypeTOB: boolean;
    procedure RappellerMemo;
    procedure EnregistreDonne;
    procedure CopieDonnee;
    procedure CouperDonnee;
    procedure DefiniMenuPop(Parent : Tform);
    procedure GSContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure GScopierClick(Sender: TObject);
    procedure GSCouperClick (Sender: TObject);
    procedure GSEnregistrerClick(Sender: TObject);
    procedure GSCollerClick(Sender: TObject);
    procedure GSRappelerClick(Sender: TObject);
    procedure MenuEnabled (State : boolean);
    procedure VerifChampsSupsDetail(TOBOUV: TOB);
		procedure VerifChampsSupsLigne(TOBL : TOB);
    procedure HideMenu;
    procedure CopieChampsLigne(Table : string; TOBLOC, Tobl: Tob);
    procedure CopieDonneeOuvrage (TOBDest,TOBOUV : TOB);
    procedure CopieDetailOuvrage(TOBDest, TOBOUV: TOB);
    procedure AjouteUneLigneAraffraichir (Arow: integer);
    function FindLigne(NumOrdre: integer): TOB;

public
    constructor create (Parent : TForm);
    destructor  destroy; override;
    property    LastSelected : integer read RowSelected;
    property    Devise : RDevise read DEV write DEV;
    property    TypeDonnee : string read FtypeInfo write ftypeInfo;
    procedure   SetTobs (ThePiece,TheSerie,TheDesLots,TheAdresses,TheArticles,TheAffaire,
                         TheCatalogu,TheNomen,TheOuvrage,TheCpta,TheTiers,TheAnaS,TheAnaP,TheBases,TheBasesL : TOB);
    procedure   SetInfoDocument (IfGereLot,IfGereSerie,IfGereStock : boolean; ContexteSaisie : TModeAff; PDEV:RDevise);
    procedure   PositionneCell(Acol,Arow: integer);
    procedure   FlipSelection(Sender: TObject);
    procedure   deselectionneRows;
    procedure   BeforeFlip(Sender: TObject; ARow: Integer;var Cancel: Boolean);
    procedure   Copier;
    procedure   Couper;
    procedure   Enregistrer;
    procedure   Coller;
    procedure   rapeller;
    procedure   Activate;
end;

procedure InitChampsSupNULL (TOBAssoc: TOB);

implementation
uses facture,FactCalc,PiecesRecalculs,FactDOmaines,UtilArticle,FactureBtp;
{ TCopieColle }

constructor TCopieColle.create(Parent: TForm);
begin
  inherited create;
  fform := Parent;
  ftransfert := TToolWindow97.Create (Parent);
  ftransfert.parent := Parent;
  ftransfert.visible := false;
  fmemo := Tmemo.create (ftransfert);
  fmemo.parent := ftransfert;
  fmemo.visible := false;
  Mcopy := TStringList.Create;
  TempFile  := IncludeTrailingBackslash (TCBPPath.GetLocalAppData)+ComputerName+'.TMP';
end;

destructor TCopieColle.destroy;
begin
  fmemo.Free;
  ftransfert.Free;
  Mcopy.Clear;
  Mcopy.free;
  inherited;
end;

procedure TCopieColle.ExportTob(TOBLoc : TOB; ChampBlocNote : string; Newgestion : boolean=false);
var TheText : string;
begin
	if not Newgestion then
  begin
    thetext := TobLoc.SaveToBuffer (true,true,ChampBlocNote);
    MCopy.Add(theText);
  end else
  begin
  	TOBLoc.SaveToBinFile (TempFile,false,true,true,true);
  end;
end;

procedure TCopieColle.SetGrid(const Value: THGrid);
begin
  fgrid := Value;
end;


function TCopieColle.RecupTob(Atob:TOB): Integer;
begin
  Result := 0 ;
  TOBImp := ATob ;
end;

{ TCopieColleDoc }

constructor TCopieColleDoc.create(Parent: TForm);
var ThePop : Tcomponent;
begin
  inherited;
  FF := Parent;
  TOBLR := TOB.Create ('LES LIGNES A RAFFRAICHIR',nil,-1);
  GereLot := false;
  GereSerie := false;
  saContexte := [tModeGridStd];
  RowCollage := -1;
  ColCollage :=-1;
  ThePop := Parent.Findcomponent  ('POPBTP');
  if ThePop = nil then
  BEGIN
    // pas de menu BTP trouve ..on le cree
    POPGS := TPopupMenu.Create(Parent);
    POPGS.Name := 'POPBTP';
    fCreatedPop := true;
  END else
  BEGIN
    fCreatedPop := false;
    POPGS := TPopupMenu(thePop);
  END;
  DefiniMenuPop(Parent);
end;

procedure TCopieColleDoc.DefiniMenuPop (Parent : Tform);
var Indice : integer;

begin
  fMaxItems := 0;
  if not fcreatedPop then
  begin
    MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
    with MesMenuItem[fMaxItems] do
      begin
      Caption := '-';
      end;
    inc (fMaxItems);
  end;
  // CTRL+C = Copier
  MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with MesMenuItem[fMaxItems] do
    begin
    Name := 'BCOPIER';
    Caption := TraduireMemoire ('Copier');
    OnClick := GSCopierClick;
    end;
  MesMenuItem[fMaxItems].ShortCut := ShortCut( Word('C'), [ssCtrl]);
  inc (fMaxItems);

  // CTRL+X = Couper
{ ---- ON VA ATTENDRE ENCORE UN PEU -------------
  MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with MesMenuItem[fMaxItems] do
    begin
    Name := 'BCOUPER';
    Caption := TraduireMemoire ('Couper');
    OnClick := GSCouperClick;
    end;
  MesMenuItem[fMaxItems].ShortCut := ShortCut( Word('X'), [ssCtrl]);
  inc (fMaxItems);
}
  // CTRL+V = Coller
  MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with MesMenuItem[fMaxItems] do
    begin
    Name := 'BCOLLER';
    Caption := TraduireMemoire('Coller');
    OnClick := GSCollerClick;
    end;
  MesMenuItem[fMaxItems].ShortCut := ShortCut(Word('V'), [ssCtrl]);
  inc (fMaxItems);

  // CTRL+ALT+S = Enregistrer
  MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with MesMenuItem[fMaxItems] do
    begin
    Name := 'BENREGISTRER';
    Caption := TraduireMemoire('Enregistrer');
    OnClick :=GSEnregistrerClick;
    end;
  MesMenuItem[fMaxItems].ShortCut := ShortCut(Word('S'), [ssCtrl,ssAlt]);
  inc (fMaxItems);

  // CTRL+ALT+P = Rappeler
  MesMenuItem[fMaxItems] := TmenuItem.Create (parent);
  with MesMenuItem[fMaxItems] do
    begin
    Name := 'BRAPELLER';
    Caption := TraduireMemoire('Rappeler');
    OnClick := GSRappelerClick;
    end;
  MesMenuItem[fMaxItems].ShortCut := ShortCut(Word('P'), [ssCtrl,ssAlt]);
  inc (fMaxItems);

  for Indice := 0 to fMaxItems -1 do
    begin
      if MesMenuItem [Indice] <> nil then POPGS.Items.Add (MesMenuItem[Indice]);
    end;
end;

procedure TCopieColleDoc.SetInfoDocument (IfGereLot,IfGereSerie,IfGereStock : boolean; ContexteSaisie : TModeAff; PDEV:RDevise);
begin
  GereLot := IfGereLot;
  GereSerie := IfGereSerie;
  GereStock := IfGereStock;
  SaContexte := ContexteSaisie;
  DEV := PDEV;
end;

procedure TCopieColleDoc.SetTobs(ThePiece,TheSerie,TheDesLots,TheAdresses,TheArticles,TheAffaire,
                                 TheCatalogu,TheNomen,TheOuvrage,TheCpta,TheTiers,TheAnaS,TheAnaP,TheBases,TheBasesL : TOB);
begin
  TOBPiece := ThePiece;
  TOBSerie := TheSerie;
  TOBDesLots := TheDesLots;
  TOBAdresses := TheAdresses;
  TOBArticles := TheArticles;
  TOBAffaire := TheAffaire;
  TOBCatalogu := TheCatalogu;
  TOBOuvrage := TheOuvrage;
  TOBNomen := TheNomen;
  TOBCpta := TheCpta;
  TOBTiers := TheTiers;
  TOBAnas := TheAnas;
  TOBAnaP := TheAnaP;
  TOBBases := TheBases;
  TOBBasesL := TheBasesL;
// definition par defaut (r�cup)
  VenteAchat :=  TOBPiece.getValue('GP_VENTEACHAT');
end;


procedure TCopieColleDoc.Coller;
begin
  TOBLR.clearDetail;
  if fgrid = nil then Exit;
  if Clipboard.HasFormat(CF_TEXT) then BEGIN SendMessage (fgrid.InplaceEditor.Handle,WM_PASTE,0,0); Exit; END;
  if (not IsTypeTOB)  then
     begin
     SendMessage (fgrid.InplaceEditor.Handle,WM_PASTE,0,0);
     exit;
     end;
  {$IFDEF BTP}
//  fmemo.PasteFromClipboard;
  CollageDonnee (true);
  RowCollage := -1;
  ColCollage := -1;
  {$ENDIF}
end;

procedure TCopieColleDoc.Collagedonnee (NewGestion : boolean=false);
var TOBLOC,TOBL: TOB;
    Indice,Niveau,Localisation : Integer;
    SauteAfinPar,ArticleNonOk : boolean;
    Arow,SavRow,SavCol : integer;
    OldEna,bc,cancel : boolean;
    TOBDLR : TOB;
    DepartIns,FinIns : integer;
    FirstPass : boolean;
begin
  DepartIns := 0 ; FinIns := 0;
  FirstPass := true;
  if RowCollage = -1 then
  begin
    RowCollage := fgrid.row;
    ColCollage := fgrid.col;
  end;
  SavRow := RowCollage;
  SavCol := ColCollage;
  bc:=False ; Cancel:=False ; SavCol:=fgrid.fixedCols ;
  TFFacture(fform).GSRowEnter(fgrid,SavRow,bc,False) ;
  TFFacture(fform).GSCellEnter(fgrid,SavCol,SavRow,Cancel) ;
  fgrid.col := SavCol;
  fgrid.row := Savrow;
  TOBL:=GetTOBLigne(TOBPiece,Savrow) ;
  if IsLigneDetail (nil,TOBL) then exit;
  OldEna:=fgrid.SynEnabled ; fgrid.SynEnabled:=False ;
  SauteAFinPar := false; ArticleNonOk := false;
  if TOBL = nil then
  begin
    Niveau := 0;
  end
  else
  begin
    Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
    // Sur une ligne de d�but de �, on ins�re au-dessus donc au niveau pr�c�dent
    // VARIANTE
    (* if copy(TOBL.getValue('GL_TYPELIGNE'),1,2)='DP' then Niveau:=Niveau-1; *)
    if IsDebutParagraphe(TOBL) then Niveau:=Niveau-1;
  end;
  if not newGestion then
  begin
    TOBLoadFromBuffer (fmemo.Text,RecupTob);
  end;
  Arow := SavRow;
  if TOBIMP = nil then exit;
  if TOBImp.getValue('TYPE') = fTypeInfo then
  BEGIN
    For Indice :=0 to TOBImp.detail.count -1 do
    begin
      TOBLoc := TOBImp.detail[Indice];
      if FIrstPass then
      begin
        DepartIns := Arow;
        FirstPass := false;
      end;
      AjouteLigneImport (TOBLoc,Niveau,Arow,SauteAFinPar,ArticleNonOk);
      FinIns := Arow;
    end;
  end;
  if ArticleNonOk then TFFacture(fform).HPiece.Execute(44,TFFacture(fform).Caption,'') ;
  Arow := SavRow;
  //NumeroteLignesGC(nil,TOBpiece);
  if TOBLR.detail.count > 0 then
  begin
    Indice := 0;
    repeat
      TOBDLR := TOBLR.detail[Indice];
      TOBL := FindLigne(TOBDLR.getValue('NUMORDRE'));
      if TOBL <> nil then
      begin
        Localisation := TOBL.getIndex;
        LoadLesLibDetOuvLig (TOBPIece,TOBOuvrage,TOBTiers,TOBAffaire,TOBL,Localisation,DEV);
        ZeroLigneMontant (TOBL);
      end;
      TOBDLR.free;
    until TOBLR.detail.count = 0;
    //
  end;
  JustNumerote (TObpiece,DepartIns-1);
  //
  TOBPiece.putValue('GP_RECALCULER','X');
  TFFacture(FForm).CalculeLaSaisie (-1,-1,false,true,DepartIns,FinIns);
  // --
  TFFacture(FForm).GS.BeginUpdate;
  if TOBPiece.Detail.Count>=fgrid.RowCount-1 then
  begin
    fgrid.RowCount:=TOBPiece.Detail.Count+2 ;
  end;
  for indice := DepartIns to TOBPiece.Detail.Count - 1 do TFFacture(FForm).AfficheLaLigne(Indice + 1);
  bc:=False ; Cancel:=False ; SavCol:=Fgrid.fixedCols ;
  TFFacture(FForm).GSRowEnter(fgrid,SavRow,bc,False) ;
  TFFacture(FForm).GSCellEnter(fgrid,SavCol,SavRow,Cancel) ;
  fgrid.SynEnabled:=OldEna ;
  fgrid.col := SavCol;
  fgrid.row := Savrow;
  TOBIMP.free;
  fgrid.refresh;
  deselectionneRows;
  TFFacture(FForm).GS.EndUpdate;
  TFFacture(FForm).AfficheLaLigne(fgrid.row);
  TFFacture(fform).GoToLigne (SavRow,SavCol);
  TFFacture(fform).PosValueCell (fgrid.Cells[SavCol,SavRow]) ;
end;

procedure TCopieColleDoc.SetGrid(const Value: THGrid);
begin
inherited;
{$IFDEF BTP}
fgrid.PopupMenu := POPGS;
fgrid.OnContextPopup := GSContextPopup;
fgrid.OnFlipSelection := FlipSelection;
fgrid.OnBeforeFlip := BeforeFlip;
{$ENDIF}
end;

Function TCopieColleDoc.IsTypeTOB : boolean;
begin
result := false;
{$IFDEF LAST}
  fmemo.Clear;
  fmemo.PasteFromClipboard;
  if copy(fmemo.Text,1,4)='$|0|' then Result := true;
  fmemo.clear;
{$ELSE}
  TOBimp := Tob.Create ( 'TOB RECUP', Nil, -1 ) ;
	TOBLoadFromBinFile (tempfile,RecupTob,nil);
  if TOBimp.detail.count > 0 then
  BEGIN
  	result := true;
  END else
  begin
  	freeAndNil (TOBimp);
    SysUtils.DeleteFile(Tempfile);
  end;
{$ENDIF}
end;

procedure TCopieColleDoc.BeforeFlip(Sender: TObject; ARow: Integer; var Cancel: Boolean);
var      TOBL : TOB;
begin
TOBL:=GetTOBLigne(TOBPiece,Arow) ; if TOBL=Nil then BEGIN cancel := true;Exit; END;
// VARIANTE
(* if (copy(TOBL.getValue('GL_TYPELIGNE'),1,2)='TP') then BEGIN cancel := true; Exit; END; *)
if IsFinParagraphe(TOBL) then BEGIN cancel := true; Exit; END;
if not ISLigneGerableCC (TOBPiece,TOBArticles,GereLot,GereSerie,Arow) then BEGIN Cancel := true; exit; END;
if IsLigneDetail (nil,TOBL) then BEGIN cancel := true; Exit; END;
if IsLigneDetailMode (TOBL) then BEGIN cancel := true; Exit; END;      // Rajout pour Mode
if not cancel then RowSelected := Arow;
end;

procedure TCopieColleDoc.FlipSelection(Sender: TObject);
var Arow,Niveau : integer;
    TOBL,TOBL1 : TOB;
    retrieve : boolean;
    RefSais : string;
begin
  if fgrid = nil then Exit;
  if Assigned (fgrid.OnFlipSelection) then
  begin
    Retrieve := true;
    fgrid.OnFlipSelection := nil;
    fgrid.OnBeforeFlip := nil;
  end else Retrieve := false;

  TOBL:=GetTOBLigne(TOBPiece,RowSelected) ; if TOBL=Nil then Exit ;
  // ARIANTE
  (* if (copy(TOBL.getValue('GL_TYPELIGNE'),1,2)='DP') then *)
  if ISDebutParagraphe (TOBL) then
  begin
    Niveau := TOBL.GetValue('GL_NIVEAUIMBRIC');
    for Arow := RowSelected+1 to fgrid.rowcount do
    begin
      TOBL1:=GetTOBLigne(TOBPiece,ARow) ; if TOBL1=Nil then break ;
      fgrid.FlipSelection (Arow);
      // VARIANTE
      (* if (copy(TOBL1.getValue('GL_TYPELIGNE'),1,2)='TP') and *)
      if IsFinParagraphe (TOBL1)  and (Niveau = TOBL1.GetValue('GL_NIVEAUIMBRIC')) then break;
    end;
    RowSelected := Arow;
  end;
  if (TOBL.GetValue ('GL_TYPEARTICLE')='OUV') and (not IsSousDetail (TOBL)) then
  begin
    Niveau := TOBL.GetValue('GL_INDICENOMEN');
    for Arow := RowSelected+1 to fgrid.rowcount do
    begin
      TOBL1:=GetTOBLigne(TOBPiece,ARow) ; if TOBL1=Nil then break ;
      // VARIANTE
      (* if (TOBL1.getValue ('GL_TYPELIGNE') = 'COM') and *)
      if (IsCommentaire(TOBL1) or (IsSousDetail(TOBL1))) and
      (TOBL1.GetVAlue('GL_INDICENOMEN')=Niveau) then fgrid.flipSelection(Arow)
                                                else break;
    end;
    RowSelected := Arow-1;
  end;
  // Rajout pour Mode
  // VARIANTE
  (* if (TOBL.GetValue ('GL_TYPELIGNE')='COM') and (TOBL.GetValue ('GL_TYPEDIM')='GEN') then*)
  if (IsCommentaire(TOBL) or IsSousDetail(TOBL)) and (TOBL.GetValue ('GL_TYPEDIM')='GEN') then
  begin
    RefSais := TOBL.GetValue ('GL_CODESDIM');
    for Arow := RowSelected+1 to fgrid.rowcount do
    begin
      TOBL1:=GetTOBLigne(TOBPiece,ARow) ; if TOBL1=Nil then break ;
      // VARIANTE
      (* if (TOBL1.getValue ('GL_TYPELIGNE') = 'ART') and *)
      if (ISArticle(TOBL1)) and
      (TOBL1.GetVAlue('GL_TYPEDIM')='DIM') and (TOBL1.GetVAlue('GL_CODEARTICLE')=RefSais) then
      BEGIN
        fgrid.flipSelection(Arow);
      END else break;
    end;
    RowSelected := Arow-1;
  end;

  if Retrieve then
  begin
    fgrid.OnFlipSelection := FlipSelection;
    fgrid.OnBeforeFlip := BeforeFlip;
  end;
  //if fgrid.nbselected = 0 then RowSelected := 0;
end;

procedure TCopieColleDoc.Couper;
begin
  Clipboard.clear;
  if fgrid = nil then Exit;
  if (fgrid.nbSelected = 0) and (TFFacture(fform).Action <> taConsult) then
  begin
     SysUtils.DeleteFile (Tempfile);
     SendMessage (fgrid.InplaceEditor.Handle,WM_CUT,0,0);
     exit;
  end;
  {$IFDEF BTP}
  CouperDonnee;
  {$ENDIF}
end;

procedure TCopieColleDoc.Copier;
begin
  Clipboard.clear;
  if fgrid = nil then Exit;
  if (fgrid.nbSelected = 0) and (TFFacture(fform).Action <> taConsult) then
  begin
     SysUtils.DeleteFile (Tempfile);
     SendMessage (fgrid.InplaceEditor.Handle,WM_COPY,0,0);
     exit;
  end;
  {$IFDEF BTP}
  CopieDonnee;
  {$ENDIF}
end;

procedure TCopieColleDoc.CopieDonnee;
var Indice : Integer;
    TOBSEL: TOB;
begin
if fgrid.nbselected = 0 then exit;
fgrid.OnFlipSelection := nil;
fgrid.OnBeforeFlip := nil;
TOBSEL := TOB.create ('DONNEAINS',nil,-1);
TRY
TOBSEL.AddChampSupValeur ('TYPE',ftypeInfo);
for Indice := 1 to fgrid.RowCount do
    begin
    if (fgrid.IsSelected (Indice) ) then
       begin
       ajouteLigneSel (TOBSel,Indice,true);
       end;
    end;
fform.Enabled := false;
ExportTob(TOBSel,'GL_BLOCNOTE',True);
fform.Enabled := true;
Clipboard.clear;
fMemo.Lines :=Mcopy;
fMemo.SelectAll;
fMemo.CopyToClipboard;
Mcopy.Clear ;
FINALLY
TOBSel.free;
fgrid.OnFlipSelection := FlipSelection ;
fgrid.OnBeforeFlip := BeforeFlip;
END;
end;


procedure TCopieColleDoc.CouperDonnee;
var Indice : Integer;
    TOBSEL: TOB;
    TOBTOCUT,TOBTC : TOB;
begin
  if fgrid.nbselected = 0 then exit;
  fgrid.OnFlipSelection := nil;
  fgrid.OnBeforeFlip := nil;
  TOBTOCUT := TOB.Create ('LES LIGNES A COUPER',nil,-1);
  TOBSEL := TOB.create ('DONNEAINS',nil,-1);
  TRY
    TOBSEL.AddChampSupValeur ('TYPE',ftypeInfo);
    for Indice := 1 to fgrid.RowCount do
    begin
      if (fgrid.IsSelected (Indice) ) then
      begin
      	if TFFacture(FF).ControleLigneToCut(Indice) then
        begin
        	TOBTC := TOB.Create ('UNE LIGNE',TOBTOCUT,-1);
          TOBTC.AddChampSupValeur('LA LIGNE',Indice);
        	ajouteLigneSel (TOBSel,Indice,true);
        end;
      end;
    end;
    fform.Enabled := false;
    ExportTob(TOBSel,'GL_BLOCNOTE',True);
    fform.Enabled := true;
    Clipboard.clear;
    fMemo.Lines :=Mcopy;
    fMemo.SelectAll;
    fMemo.CopyToClipboard;
    Mcopy.Clear ;
	FINALLY
    TOBSel.free;
  	TOBTOCUT.free;
  	deselectionneRows;
    fgrid.OnFlipSelection := FlipSelection ;
    fgrid.OnBeforeFlip := BeforeFlip;
	END;
end;

procedure TCopieColleDoc.Enregistrer;
begin
if fgrid = nil then Exit;
if fgrid.nbSelected = 0 then exit;
RowCollage := -1;
ColCollage := -1;
EnregistreDonne;
end;

procedure TCopieColleDoc.EnregistreDonne;
var CodeEnreg,LibEnreg : string;
    Indice : Integer;
    TOBSEL,TOBENREG : TOB;
begin
TOBEnreg := nil;
TOBSel := nil;
if fgrid.nbSelected = 0 then exit;
if FtypeInfo='' then BEGIN (* prout *) exit; END;
fgrid.OnFlipSelection := nil;
fgrid.OnBeforeFlip := nil;
TRY
if DemandeNomEnreg (fTypeInfo,CodeEnreg,LibEnreg) then
   begin
   TOBSEL := TOB.create ('DONNEAINS',nil,-1);
   TOBSEL.AddChampSupValeur ('TYPE',FtypeInfo);
   for Indice := 1 to fgrid.RowCount do
       begin
       if (fgrid.IsSelected (Indice) ) then ajouteLigneSel (TOBSel,Indice);
       end;
   ExportTob(TOBSel,'GL_BLOCNOTE');
   fMemo.Lines :=Mcopy;
   fMemo.SelectAll;
   //
   TOBENREG := TOB.create ('BMEMORISATION',nil,-1);
   TOBENreg.PutValue('BMO_TYPEMEMO',fTypeInfo);
   TOBENreg.PutValue('BMO_CODEMEMO',CodeEnreg);
   TOBENreg.PutValue('BMO_LIBMEMO',LibEnreg);
   TOBENREG.PutValue('BMO_MEMO',fmemo.Text);
   TOBENreg.InsertOrUpdateDB (true);
   end;
FINALLY
if TOBEnreg <> nil then TOBEnreg.free;
if TOBSel <> nil then TOBSel.free;
fgrid.OnFlipSelection := FlipSelection;
fgrid.OnBeforeFlip := BeforeFlip;
END;
end;

procedure TCopieColleDoc.AjouteLigneSel (TOBSel : TOB; Indice: Integer; WithMemo : boolean=false);
var IndiceNomen : Integer;
    TOBLoc,TOBL,TOBOuv,TOBLIen : TOB;
    TypeArticle : string;
begin
TOBL:=GetTOBLigne(TOBPiece,Indice) ;
if TOBL = nil then exit;
// VARIANTE
(* if (TOBL.GetValue ('GL_TYPELIGNE')<>'COM') or (TOBL.GetValue ('GL_INDICENOMEN')=0) then *)
if ((not IsCommentaire(TOBL)) and (not IsSousDetail(TOBL))) or (TOBL.GetValue ('GL_INDICENOMEN')=0) then
  begin
{ MODIF BRL suite pb en copier-coller paragraphe d� � l'ajout de la toblignetarif
  TOBLOC := TOB.Create ('LIGNE',TOBSEL,-1);
  AddLesSupLigne (TOBLOC,false);
}
  TOBLOC:=NewTobLigne(TOBSEL,0);
//  AddLesSupLigne (TOBLOC,false); InitLesSupLigne (TOBLOC);

  CopieChampsLigne ('LIGNE',TOBLOC,TOBL);
  CopieChampsSup (TOBLOC,TOBL);

  TOBLOC.ClearDetail; // on enleve les lignes d'analytique eventuelle
  //
//  if isBlobVide (FF,TOBLOC,'GL_BLOCNOTE') then TOBLoc.putValue('GL_BLOCNOTE','');
	if (not WithMemo) then TOBLoc.putValue('GL_BLOCNOTE','');
(*
		if VarIsNull(TOBLOc.GetValue('GL_BLOCNOTE')) or (VarAsType(TOBLOc.GetValue('GL_BLOCNOTE'), varString) = #0 ) then
  	TOBLOc.PutValue('GL_BLOCNOTE','');
*)
  //
//  InitChampsSupNULL (TOBLoc);
//  InitLesSupLigne (TOBLoc);
// Gestion des ouvrages et article prix pose
  TypeArticle := TOBL.GetValue ('GL_TYPEARTICLE');
{$IFDEF BTP}
  if (TypeArticle = 'OUV') or (TypeArticle = 'ARP') then
     begin
     IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
     if (TOBOUvrage.detail.count > 0) and (IndiceNomen > 0) then
        begin
        TobOuv := TOBOUvrage.detail[IndiceNomen -1];
        TOBLien := TOB.create ('',TOBLOC,-1);
        //
        CopieDonneeOuvrage (TOBLien,TOBOUV);
        //
        { ANCIENNE GESTION AVEC DUPLIQUER
        InsertionChampSupOuv (TOBLien,true);
        TOBLIen.dupliquer (TOBOuv,true,true);
        if isBlobVide (FF,TOBLien,'BLO_BLOCNOTE') then TOBL.putValue('BLO_BLOCNOTE','');
  			InitChampsSupNULL (TOBLien);
        }
        end;
     end;
{$ENDIF}
  if (TypeArticle = 'NOM') then
     begin
     IndiceNomen := TOBL.GetValue('GL_INDICENOMEN');
     TobOuv := TOBnOMEN.detail[IndiceNomen -1];
     TOBLien := TOB.create ('LIGNOMEN',TOBLOC,-1);
     TOBLIEN.AddChampSup('UTILISE',False) ; TOBLIEN.PutValue('UTILISE','-') ;
     TOBLIen.dupliquer (TOBOuv,true,true);
     end;
  end;
end;

function TCopieColleDoc.AjouteLigneImport (TOBLoc : TOB;Var Niveau : integer;var Arow : integer; Var SauteAFinPar : boolean; Var ArticleNonOk : boolean) : boolean;
begin
  Result := false;
  // VARIANTE
  (* if copy(TOBLOc.getValue('GL_TYPELIGNE'),1,2)='DP' then *)
  if IsDebutParagraphe(TOBLoc) then
  begin
    // Debut de paragraphe
    if Niveau = 9 then BEGIN SauteAfinPar := true; ArticleNonOk := true; END;
    if not SauteAFinPar then
    begin
      inc (niveau);
      InsertDebParagrapheImp (TOBLOC,niveau,Arow); inc(Arow);
      result := true;
    end;
    //  VARIANTE
    (* end else if copy(TOBLOC.getValue('GL_TYPELIGNE'),1,2)='TP' then *)
  end else if IsFinParagraphe(TOBLoc) then
  begin
    if not SauteAFinPar then
    begin
      // Fin de paragraphe
      InsertFinParagrapheImp (TOBLOC,niveau,Arow); inc(Arow);
      Dec (niveau);
      result := true;
    end;
    if SauteAFinPar then SauteAFinPar := false;
  end else
  begin
    if not SauteAFinPar then
    begin
      // VARIANTE
      (* if TOBLoc.GetValue('GL_TYPELIGNE') = 'ART' then *)
      if IsArticle(TOBLoc) then
      begin
        result := InsertLigneArticleImp (TOBLOC,Arow,Niveau,ArticleNonOk);
        // VARIANTE
        (* end else if (TOBLoc.getValue('GL_TYPELIGNE') = 'COM') and *)
      end else if (IsCommentaire(TOBLoc)) and
                  (TOBLoc.GetValue('GL_TYPEARTICLE') <> 'EPO') then
      begin
        InsertLigneCommentaireImp (TOBLoc,Arow,Niveau);  inc(Arow);
        result := true;
      end else if (TOBLoc.getValue('GL_TYPELIGNE') = 'TOT') then
      begin
        InsertLigneTotalImp (TOBLoc,Arow,Niveau);  inc(Arow);
        result := true;
      end;
    end;
  end;
end;


procedure TCopieColleDoc.InsertDebParagrapheImp (TOBLOC : TOB; niveau : integer;Arow : integer);
var TOBL : TOB;
    InVariante : boolean;
begin
TOBL := GetTOBLigne (TobPiece,Arow);
InVariante := IsVariante (TOBL);

// Code insertion nouveau paragraphe
InsertTobLigne (TOBPiece,Arow);
TOBL := GetTOBLIgne (TOBPiece,Arow);
AddLesSupLigne(TOBL,False) ;  InitLesSupLigne (TOBL);

PieceVersLigne (TOBPIece,TOBL);
AffaireVersLigne (TOBPiece,TOBL,TOBAffaire);
TOBL.PutValue('GL_LIBELLE',TOBLOC.GetValue('GL_LIBELLE'));
TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
TOBL.PutValue('GL_PIECEPRECEDENTE','');
TOBL.PutValue('GL_PIECEORIGINE','');
TOBL.PutValue('GLC_DOCUMENTLIE','');
// VARIANTE
(* TOBL.PutValue('GL_TYPELIGNE','DP'+ intToStr(Niveau)); *)
if VariantePieceAutorisee (TOBPiece) then
begin
  if InVariante then TOBL.PutValue('GL_TYPELIGNE','DV'+ intToStr(Niveau))
                else TOBL.PutValue('GL_TYPELIGNE',copy(TOBLOc.GetValue('GL_TYPELIGNE'),1,2)+ intToStr(Niveau));
end else TOBL.PutValue('GL_TYPELIGNE','DP'+ intToStr(Niveau));
TOBL.PutValue('GL_NUMORDRE',GetMaxNumOrdre(TOBpiece));
end;

procedure TCopieColleDoc.InsertFinParagrapheImp (TOBLOC : TOB;niveau,Arow : integer);
var TOBL : TOB;
    InVariante : boolean;
begin
TOBL := GetTOBLigne (TobPiece,Arow);
InVariante := IsVariante (TOBL);
// Code insertion fin de paragraphe
InsertTobLigne (TOBPiece,Arow);
TOBL := GetTOBLIgne (TOBPiece,Arow);
AddLesSupLigne(TOBL,False) ;  InitLesSupLigne (TOBL);
PieceVersLigne (TOBPIece,TOBL);
AffaireVersLigne (TOBPiece,TOBL,TOBAffaire);
TOBL.PutValue('GL_LIBELLE',TOBLOC.GetValue('GL_LIBELLE'));
TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
TOBL.PutValue('GL_PIECEPRECEDENTE','');
TOBL.PutValue('GL_PIECEORIGINE','');
TOBL.PutValue('GLC_DOCUMENTLIE','');
// VARIANTE
(* TOBL.PutValue('GL_TYPELIGNE','TP'+ intToStr(Niveau)); *)
if VariantePieceAutorisee (TOBPiece) then
begin
  if InVariante then TOBL.PutValue('GL_TYPELIGNE','TV'+ intToStr(Niveau))
                else TOBL.PutValue('GL_TYPELIGNE',copy(TOBLOc.GetValue('GL_TYPELIGNE'),1,2)+ intToStr(Niveau));
end else TOBL.PutValue('GL_TYPELIGNE','TP'+ intToStr(Niveau));
TOBL.PutValue('GL_NUMORDRE',GetMaxNumOrdre(TOBpiece));
end;

procedure TCopieColleDoc.VerifChampsSupsDetail(TOBOuv : TOB);
var Indice : integer;
begin
  if TOBOuv.fieldExists ('__COEFMARG') then
    if VarType (TOBOuv.GetValue('__COEFMARG')) = VarString then
      TOBOuv.PutValue ('__COEFMARG',Valeur(TOBOuv.GetValue('__COEFMARG')));
  if TOBOuv.fieldExists ('GCA_PRIXBASE') then
    if VarType (TOBOUV.GetValue('GCA_PRIXBASE')) = VarString then
      TOBOuv.PutValue ('GCA_PRIXBASE',Valeur(TOBOUV.GetValue('GCA_PRIXBASE')));
  if TOBOuv.fieldExists ('GA_PAHT') then
    if VarType (TOBOUV.GetValue('GA_PAHT')) = VarString then
      TOBOuv.PutValue ('GA_PAHT',Valeur(TOBOUV.GetValue('GA_PAHT')));
  if TOBOuv.fieldExists ('GA_PVHT') then
    if VarType (TOBOUV.GetValue('GA_PVHT')) = VarString then
      TOBOuv.PutValue ('GA_PVHT',Valeur(TOBOUV.GetValue('GA_PVHT')));
    (* OPTIMIZATION *)
  if TOBOuv.fieldExists ('BLO_PRXACHBASE') then
    if VarType (TOBOUV.GetValue('BLO_PRXACHBASE')) = VarString then
      TOBOuv.PutValue ('BLO_PRXACHBASE',Valeur(TOBOUV.GetValue('BLO_PRXACHBASE')));
  if TOBOuv.fieldExists ('GA_HEURE') then
    if VarType (TOBOUV.GetValue('GA_HEURE')) = VarString then
      TOBOuv.PutValue ('GA_HEURE',Valeur(TOBOUV.GetValue('GA_HEURE')));
  if TOBOuv.fieldExists ('GF_PRIXUNITAIRE') then
    if VarType (TOBOUV.GetValue('GF_PRIXUNITAIRE')) = VarString then
      TOBOuv.PutValue ('GF_PRIXUNITAIRE',Valeur(TOBOUV.GetValue('GF_PRIXUNITAIRE')));
  if TOBOuv.fieldExists ('ANCPA') then
    if VarType (TOBOUV.GetValue('ANCPA')) = VarString then
      TOBOuv.PutValue ('ANCPA',Valeur(TOBOUV.GetValue('ANCPA')));
  if TOBOuv.fieldExists ('ANCPR') then
    if VarType (TOBOUV.GetValue('ANCPR')) = VarString then
      TOBOuv.PutValue ('ANCPR',Valeur(TOBOUV.GetValue('ANCPR')));
(*
  if TOBOuv.fieldExists ('TPSUNITAIRE') then
    if VarType (TOBOUV.GetValue('TPSUNITAIRE')) = VarString then
      TOBOuv.PutValue ('TPSUNITAIRE',Valeur(TOBOUV.GetValue('TPSUNITAIRE')));
*)
  if TOBOuv.fieldExists ('INDICEMETRE') then
    if VarType (TOBOUV.GetValue('INDICEMETRE')) = VarString then
      TOBOuv.PutValue ('INDICEMETRE',Valeur(TOBOUV.GetValue('INDICEMETRE')));
  if TOBOuv.fieldExists ('INDICELIENDEVCHA') then
    if VarType (TOBOUV.GetValue('INDICELIENDEVCHA')) = VarString then
      TOBOuv.PutValue ('INDICELIENDEVCHA',Valeur(TOBOUV.GetValue('INDICELIENDEVCHA')));
  if TOBOUV.detail.count > 0 then
  begin
  	For Indice := 0 to TOBOUV.detail.count -1 do
    begin
    	VerifChampsSupsDetail (TOBOUV.detail[Indice]);
    end;
  end;
end;


function TCopieColleDoc.InsertLigneArticleImp (TOBLOC : TOB;var Arow : integer ;Niveau : integer;var ArticleNonOk:boolean):boolean;

  procedure ReinitMontantAch (TOBL : TOB);
  begin
    TOBL.PutValue('GL_MONTANTFC',0); TOBL.PutValue('GL_MONTANTFR',0); TOBL.PutValue('GL_MONTANTPR',0);
  end;

	procedure InitCopierCollerDetail (TOBD,TOBpiece : TOB);
  var indice : integer;
  begin
    // Correction FQ 12072
    TOBD.PutValue('BLO_COEFFC',0);
    TOBD.PutValue('BLO_COEFFR',0);
    TOBD.PutValue('BLO_MONTANTFC',0);
    TOBD.PutValue('BLO_MONTANTFR',0);
  	if (TOBPIece.GetValue('GP_COEFFC') <> 0) and (TOBD.GetValue('BLO_NONAPPLICFC')<>'X' ) THEN TOBD.PutValue('BLO_COEFFC',TOBPIece.GetValue('GP_COEFFC'));
  	if (TOBPIece.GetValue('GP_COEFFR') <> 0) and (TOBD.GetValue('BLO_NONAPPLICFRAIS')<>'X' ) THEN TOBD.PutValue('BLO_COEFFR',TOBPIece.GetValue('GP_COEFFR'));
//    TOBD.PutValue('BLO_COEFMARG',0);
  end;

  Function TraiteLigneCopierCollerOuv (TOBD,TOBpiece,TOBL,TOBArticle: TOB;DEV : RDevise) : boolean;
  var Indice : integer;
  		TOBA : TOB;
      QQ : TQuery;
      Mess : String;
  begin
    Result := True;

    TOBA := TOBArticles.findFirst(['GA_ARTICLE'],[TOBD.GetValue('BLO_ARTICLE')],true);
    if TOBA = nil then
    begin
      TOBA:=CreerTOBArt(TOBArticles) ;
      QQ := OpenSql ('SELECT A.*,AC.*,N.BNP_TYPERESSOURCE,N.BNP_LIBELLE FROM ARTICLE A '+
                    'LEFT JOIN NATUREPREST N ON N.BNP_NATUREPRES=A.GA_NATUREPRES '+
                    'LEFT JOIN ARTICLECOMPL AC ON AC.GA2_ARTICLE=A.GA_ARTICLE WHERE A.GA_ARTICLE="'+
                    TOBD.GetValue('BLO_ARTICLE')+'"',true);
      if QQ.EOF then
      begin
        Mess := 'Le composant '+ TOBD.Getvalue('BLO_CODEARTICLE')+' - '+TOBD.Getvalue('BLO_LIBELLE')+
                ' dans l''ouvrage ' + TOBL.Getvalue('GL_CODEARTICLE')+' - '+TOBL.Getvalue('GL_LIBELLE') +
                ' ne peut �tre r�cup�r� #13#10 car il est inexistant.';
        PgiBox (TraduireMemoire(Mess),Traduirememoire('Copier-coller de lignes'));
        TOBD.free;
        Result := False;
        Exit;
      end;

      TOBA.SelectDB('',QQ) ;
      Ferme (QQ);
      InitChampsSupArticle (TOBA);
    end;
    //
    if (TOBL.getValue('GL_DOMAINE')<>'') then
    begin
      TOBD.putValue('BLO_DOMAINE',TOBL.getValue('GL_DOMAINE'));
    end;
    if TOBD.getValue('BLO_DOMAINE') <> '' then
    begin
      if TOBA.GetValue('GA_PRIXPASMODIF')<>'X' then
      begin
        AppliqueCoefDomaineActOuv (TOBD);
      end;
    end;
    if TOBD.detail.count > 0 then
    begin
    	Indice := 0;
      while Indice < TOBD.detail.count do
      begin
        result := TraiteLigneCopierCollerOuv (TOBD.Detail[Indice],Tobpiece,TOBL,TOBArticles,Dev);
        Inc(Indice);
      end;
    end;
    //

    VerifChampsSupsDetail(TOBD);
    InitCopierCollerDetail (TOBD,TOBpiece);

    if (TOBD.getValue('BLO_DOMAINE')<>'') then
    begin
      CalculeLigneAcOuv (TOBD,DEV,true,TOBA);
    end;

    ReajusteLigneParDoc (TOBL,TOBD,DEV,1);
    GetValoDetail (TOBD); // pour le cas des Article en prix pos�s
    TOBD.PutValue('GA_PVHT',TOBD.GetValue('BLO_PUHTDEV'));
    if TOBL.GetValue('GL_FACTUREHT')='X' then TOBD.putvalue ('ANCPV',TOBD.Getvalue ('BLO_PUHTDEV'))
                                         else TOBD.putvalue ('ANCPV',TOBD.Getvalue ('BLO_PUTTCDEV'));
  end;

var TOBL,TOBA,TOBOuv : TOB;
    X : double;
    DetailATraiter : boolean;
    TOBLN : TOB;
{$IFDEF BTP}
    Indice : integer;
    valeurs : T_Valeurs;
    PuFix,Qte : double;
{$ENDIF}
    InVariante : boolean;
    QQ : TQuery;
    Mess : String;

begin
  result := false;
  TOBOuv := nil;
  DetailATraiter := false;
  TOBL := GetTOBLigne (TobPiece,Arow);
  InVariante := IsVariante (TOBL);
  // Code Insertion ligne de document
  InsertTobLigne (TOBPiece,Arow);
  TOBL := GetTOBLIgne (TOBPiece,Arow);
  if (TOBLoc.detail.count > 0) and ((TOBLoc.GetValue('GL_TYPEARTICLE')='OUV') or (TOBLoc.GetValue('GL_TYPEARTICLE')='ARP')) then
  begin
    // gestion du detail de l'ouvrage
    TOBOuv := TOB.create ('',nil,-1);
    TOBOUV.dupliquer (TOBLoc.detail[0],true,true);
    TobLoc.ClearDetail;
  end;
  AddLesSupLigne(TOBL,False) ;  InitLesSupLigne (TOBL);
  CopieChampsLigne ('LIGNE',TOBL,TOBLOC);
  CopieChampsSup (TOBL,TOBLOC);
  VerifChampsSupsLigne(TOBL);
  TOBL.PutValue('BLP_NUMMOUV',0);
  TOBL.PutValue('GL_QTESTOCK',TOBL.GetValue('GL_QTEFACT'));
  TOBL.PutValue('GL_QTERESTE',TOBL.GetValue('GL_QTEFACT'));
  TOBL.PutValue('GL_PIECEPRECEDENTE','');
  TOBL.PutValue('GL_PIECEORIGINE','');
  TOBL.PutValue('GLC_DOCUMENTLIE','');
  // Correction FQ 12072
  TOBL.PutValue('GL_COEFFC',0);
  TOBL.PutValue('GL_COEFFR',0);
  // --


  TOBL.PutValue('GL_BLOQUETARIF','-');
  if VenteAchat = 'VEN' then
  begin
    if IsprestationST (TOBL) then
    begin
      if TOBPIece.getValue('GP_APPLICFGST')='-' then TOBL.putValue('GLC_NONAPPLICFRAIS','X') else TOBL.putValue('GLC_NONAPPLICFRAIS','-');
      if TOBPIece.getValue('GP_APPLICFCST')='-' then TOBL.putValue('GLC_NONAPPLICFC','X') else TOBL.putValue('GLC_NONAPPLICFC','-');
    end;
  end;
  //NewTOBLigneFille (TOBL);
  PieceVersLigne (TOBPIece,TOBL);
  AffaireVersLigne (TOBPiece,TOBL,TOBAffaire);
  TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
  if TOBL.GetValue('GL_TYPEARTICLE') <> 'POU' then
  begin
    if TOBPiece.GetValue('GP_FACTUREHT')='X' then X := TOBL.GetValue('GL_PUHTDEV')
                                             else X := TOBL.GetValue('GL_PUTTCDEV');
    // Retablissement du pu dans la monnaie du client
    if TOBL.GetValue('GL_DEVISE') <> TOBPiece.getValue('GP_DEVISE') then
    begin
      X:= DEVISETODEVISE (X,TOBL.GetValue('GL_TAUXDEV'),TOBL.GetValue('GL_COTATION'),
      TOBPiece.GetValue('GP_TAUXDEV'),TOBPiece.GetValue('GP_COTATION'),V_PGI.okdecV);
    end else
    BEGIN
      if TOBPiece.GetValue('GP_FACTUREHT')='X' then X := TOBL.GEtValue('GL_PUHTDEV')
                                               else X := TOBL.GetValue('GL_PUTTCDEV');
    END;

    if TOBPiece.GetValue('GP_FACTUREHT')='X' then TOBL.PutValue('GL_PUHTDEV',X)
                                             else TOBL.PutValue('GL_PUTTCDEV',X);
    TOBL.PutValue('GL_PUHT',DeviseToPIvotEx(TOBL.getValue('GL_PUHTDEV'),DEV.taux,DEV.quotite,V_PGI.okdecP));
    if TOBL.getValue('GL_DPR')<>0 then TOBL.PutValue('GL_COEFMARG',Arrondi(TOBL.getValue('GL_PUHT')/TOBL.getValue('GL_DPR'),4));
  end;

  if Not IsArticleOk (Arow) then
  begin
    ArticleNonOk := true;
    PgiBox (TraduireMemoire('L''article '+ TOBL.Getvalue('GL_CODEARTICLE')+' - '+TOBL.Getvalue('GL_LIBELLE')+'#13#10 ne peut �tre r�cup�r� car inexistant.'),Traduirememoire('Copier-coller de lignes'));
    TOBL.free;
  end else
  begin
    TOBA := FindTOBArtRow (TOBPiece,TOBarticles,Arow);

    TOBL.PutValue('GL_DOMAINE', TOBA.GetValue('GA_DOMAINE')); // application du domaine d'activite
    if TOBPiece.getValue('GP_DOMAINE')<>'' then TOBL.putValue('GL_DOMAINE',TOBPIece.getValue('GP_DOMAINE'));
    if (TOBL.getValue('GL_DOMAINE')<>'') then
    begin
      if TOBA.GetValue('GA_PRIXPASMODIF')<>'X' then
      begin
        AppliqueCoefDomaineLig(TOBL);
      end;
    end;

    if VariantePieceAutorisee (TOBPiece) then
    begin
      if InVariante then SetTypeLigne (TOBL,InVariante)
                    else TOBL.Putvalue('GL_TYPELIGNE',TOBLOc.getValue('GL_TYPELIGNE'));
    end;
    TFFacture(fform).TraiteLaCompta(ARow);
    TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
    {$IFDEF BTP}
    if TOBL.GetValue('GLC_FROMBORDEREAU')='X' then
    begin
    	TOBL.PutValue('GL_BLOQUETARIF','X');
    end else
    begin
      if (TOBPiece.GetValue('_BLOQUETARIF')='X') and (TOBL.getValue('GL_DEVISE')=TOBPiece.getValue('GP_DEVISE')) Then
      begin
        TOBL.PutValue('GL_BLOQUETARIF','X')
      end else
      begin
        TOBL.PutValue('GL_BLOQUETARIF','-')
      end;
    end;
    if TOBL.getValue('GL_PRIXPOURQTE')=0 then TOBL.putValue('GL_PRIXPOURQTE',1);
    if (TobOuv <> nil) and (TOBOUV.detail.count > 0) and (TOBOuv.detail[0].NomTable = 'LIGNEOUV') then
    begin
      TOBLN := TOB.create ('',TOBOUvrage,-1);
      InsertionChampSupOuv (TOBLN,false);
      TOBLN.dupliquer (TOBOuv,true,true);
      if (pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV')>0) and (not NaturepieceOKPourOuvrage(TOBL)) then
      begin
        if TOBLN.detail[0].detail.count > 1 then
        begin
          TOBLN.detail[0].detail[1].free;
        end;
      end;
      // --
      if TOBLN.detail.count > 0 then  // On saute le groupe d'ouvrage
      begin
        DetailATraiter := true;
//        RepriseDonneeArticle (TOBLN,nil,True,false);
    	  Indice := 0;
        while Indice < TOBLN.detail.count do
        begin
          //
          ArticleNonOk := Not TraiteLigneCopierCollerOuv (TOBLN.detail[Indice],TOBPiece,TOBL,TOBArticles,Dev);
          Inc(Indice);
          // --
        end;

        // Correction FQ 12072
      	TOBL.PutValue('GL_COEFFC',0);
      	TOBL.PutValue('GL_COEFFR',0);
      	TOBL.PutValue('GL_MONTANTFC',0);
      	TOBL.PutValue('GL_MONTANTFR',0);
        //
        if (ArticleNonOk = True) or (TOBL.getValue('GL_DOMAINE')<>'') then
        begin
          InitTableau (Valeurs);
          CalculeOuvrageDoc (TOBLN,1,1,true,DEV,valeurs,(TOBPiece.getValue('GP_FACTUREHT')='X'),true,true);
          Qte := TOBL.Getvalue('GL_QTEFACT');
          TOBL.Putvalue('GL_MONTANTPAFG',valeurs[10]*Qte);
          TOBL.Putvalue('GL_MONTANTPAFR',valeurs[11]*Qte);
          TOBL.Putvalue('GL_MONTANTPAFC',valeurs[12]*Qte);
          TOBL.Putvalue('GL_MONTANTFG',valeurs[13]*Qte);
          TOBL.Putvalue('GL_MONTANTFR',valeurs[14]*Qte);
          TOBL.Putvalue('GL_MONTANTFC',valeurs[15]*Qte);
          TOBL.Putvalue('GL_MONTANTPA',Arrondi((Qte * TOBL.GetValue('GL_DPA')),V_PGI.okdecV));
          TOBL.Putvalue('GL_MONTANTPR',Arrondi((Qte * TOBL.GetValue('GL_DPR')),V_PGI.okdecV));

          TOBL.Putvalue('GL_DPA',valeurs[16]);
          TOBL.Putvalue('GL_DPR',valeurs[17]);
          //
          TOBL.Putvalue('GL_PUHTDEV',valeurs[2]);
          TOBL.Putvalue('GL_PUTTCDEV',valeurs[3]);
          TOBL.Putvalue('GL_PUHT',DeviseToPivotEx(TOBL.GetValue('GL_PUHTDEV'),DEV.Taux,DEV.quotite,V_PGI.OkdecP));
          TOBL.Putvalue('GL_PUTTC',DevisetoPivotEx(TOBL.GetValue('GL_PUTTCDEV'),DEV.taux,DEV.quotite,V_PGI.okdecP));
          TOBL.Putvalue('GL_PUHTBASE',TOBL.GetValue('GL_PUHT'));
          TOBL.Putvalue('GL_PUTTCBASE',TOBL.GetValue('GL_PUTTC'));
          TOBL.Putvalue('GL_DPA',valeurs[0]);
          TOBL.Putvalue('GL_DPR',valeurs[1]);
          TOBL.Putvalue('GL_PMAP',valeurs[6]);
          TOBL.Putvalue('GL_PMRP',valeurs[7]);
          TOBL.putvalue('GL_TPSUNITAIRE',valeurs[9]);
					TOBL.putvalue('GL_HEURE',Arrondi(TOBL.getValue('GL_TPSUNITAIRE')*Qte,V_PGI.okdecQ));
        end;
      end;
      TOBL.Putvalue('GL_INDICENOMEN',TobOuvrage.detail.count);
      //
      NumeroteLigneOuv (TOBLN,TOBL,1,1,0,0,0);
      // Correction FQ 12072
      TOBL.PutValue('GL_COEFFC',0);
      TOBL.PutValue('GL_COEFFR',0);
      TOBL.PutValue('GL_MONTANTFC',0);
      TOBL.PutValue('GL_MONTANTFR',0);
      TOBL.PutValue('GL_COEFMARG',0);
      // --
      {$IFDEF BTP}
      PuFix := TOBL.GetValue('GL_PUHTDEV');
      InitTableau (Valeurs);
      CalculeOuvrageDoc (TOBLN,1,1,true,DEV,valeurs,(TOBPiece.getValue('GP_FACTUREHT')='X'),true,true);
      if TOBL.GetValue('GLC_FROMBORDEREAU')='X' then
      begin
      	// forcement en prix bloqu�
      	TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL ,TOBOuvrage,(TOBPiece.getValue('GP_FACTUREHT')='X'),PuFix,Valeurs[2],DEV,false,True);
      end else
      begin
      	TraitePrixOuvrage(TOBPiece,TOBL,TOBBases,TOBBasesL ,TOBOuvrage,(TOBL.GetValue('GL_FACTUREHT')='X'),PuFix,0,DEV,false);
      end;
      // -----------------
//      positionneCoefMarge (TOBL);
      //
      if (pos(TOBL.GetValue('GL_TYPEARTICLE'),'ARP;ARV')>0) and (not NaturepieceOKPourOuvrage(TOBL)) then
      begin
        TOBLN.free;
        TOBL.Putvalue('GL_INDICENOMEN',0);
      end;
      {$ENDIF}
      //
    end else
    begin
      TOBL.putValue('GL_DPA',TOBLOc.getValue('GL_DPA'));
      TOBL.putValue('GL_DPR',TOBLOc.getValue('GL_DPA'));
      // Correction FQ 12072
      TOBL.PutValue('GL_COEFFC',0);
      TOBL.PutValue('GL_COEFFR',0);
      // --
      ReinitMontantAch (TOBL);
      //
  		if (TOBPIece.GetValue('GP_COEFFC') <> 0) and (TOBL.GetValue('GLC_NONAPPLICFC')<>'X' ) THEN TOBL.PutValue('GL_COEFFC',TOBPIece.GetValue('GP_COEFFC'));
  		if (TOBPIece.GetValue('GP_COEFFR') <> 0) and (TOBL.GetValue('GLC_NONAPPLICFRAIS')<>'X' ) THEN TOBL.PutValue('GL_COEFFR',TOBPIece.GetValue('GP_COEFFR'));
      // --
      if TOBL.getVAlue('GL_DOMAINE')<>'' then
      begin
      	CalculeLigneAc (TOBL,DEV,true);
      end else
      begin
      	CalculeLigneAc (TOBL,DEV,false);
      end;
      CalculFraisFromLigne (TOBpiece,TOBL);
//      CalculeBaseFraisLigne (TOBL);
      TOBL.PutValue('GL_COEFMARG',0);
    end;
    StringToRich( TFFacture(fform).Descriptif1, TOBL.GetValue ('GL_BLOCNOTE') );
    if (Length(TFFacture(fform).Descriptif1.text)<>0) and (TFFacture(fform).Descriptif1.text<>#$D#$A) then
    BEGIN
      TOBL.PutValue('GL_BLOCNOTE', RichToString (TFFacture(fform).Descriptif1) );
    END else
    BEGIN
      TOBL.PutValue ('GL_BLOCNOTE','');
    END;
    {$ENDIF}
    result := true;
    TOBL.PutValue('GL_RECALCULER','X');
    TOBL.PUTVALUE('GL_LIBELLE',TOBLOC.GetValue('GL_LIBELLE'));
    TOBL.PutValue('GL_POURCENTAVANC',0)      ;
    TOBL.PutValue('GL_QTEPREVAVANC',0)      ;
    TOBL.PutValue('GL_QTESIT',0)      ;
    TOBL.PutValue('GL_QTESTOCK',TOBL.GetValue('GL_QTEFACT'));
    TOBL.PutValue('GL_QTERESTE',TOBL.GetValue('GL_QTEFACT'));
    TOBL.PutValue('GL_NUMORDRE',GetMaxNumOrdre(TOBpiece));
    //   TOBL.PutValue('GL_NUMORDRE',0)      ;

    ZeroLigneMontant (TOBL);  // reinit des montant de la ligne pour eviter de deduire les montants a ajouter

    {$IFDEF BTP}
    // Traitement des d�tail ouvrages
    if DetailATraiter then
    BEGIN
//      dec(Arow);
      AjouteUneLigneAraffraichir (TOBL.GetValue('GL_NUMORDRE'));
      //        LoadLesLibDetOuvLig (TOBPIece,TOBOuvrage,TOBTiers,TOBAffaire,TOBL,Arow,DEV);
    END;
    {$ENDIF}
    inc(Arow);
  end;

  if TOBOuv <> nil then TOBOuv.free;
end;

procedure TCopieColleDoc.InsertLigneCommentaireImp (TOBLoc : TOB;Arow,Niveau : Integer);
var TOBL : TOB;
  InVariante : boolean;
begin
TOBL := GetTOBLigne (TobPiece,Arow);
InVariante := IsVariante (TOBL);
InsertTobLigne (TOBPiece,Arow);
TOBL := GetTOBLIgne (TOBPiece,Arow);
AddLesSupLigne(TOBL,False) ;  InitLesSupLigne (TOBL);
CopieChampsLigne ('LIGNE',TOBL,TOBLOC);
CopieChampsSup (TOBL,TOBLOC);
VerifChampsSupsLigne(TOBL);
//NewTOBLigneFille (TOBL);
PieceVersLigne (TOBPIece,TOBL);
AffaireVersLigne (TOBPiece,TOBL,TOBAffaire);
TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
TOBL.PutValue('GL_PIECEPRECEDENTE','');
TOBL.PutValue('GL_PIECEORIGINE','');
TOBL.PutValue('GLC_DOCUMENTLIE','');
if VariantePieceAutorisee (TOBPiece) then
  begin
  if InVariante Then TOBL.Putvalue('GL_TYPELIGNE','COV')
                else TOBL.Putvalue('GL_TYPELIGNE',TOBLOc.getValue('GL_TYPELIGNE'))
  end else TOBL.Putvalue('GL_TYPELIGNE','COM');
{$IFDEF BTP}
if (not IsBLobVide(FF,TOBL,'GL_BLOCNOTE')) and (not IsLigneReferenceLivr(TOBL)) then
BEGIN
  TOBL.PutValue('GL_LIBELLE', 'BLOC NOTE ASSOCIE');
  TOBL.PutValue('BLOBONE', 'X');
END ELSE
BEGIN
	TOBL.PutValue ('GL_BLOCNOTE','');
  TOBL.PutValue('BLOBONE', '-');
END;
{$ELSE}
TOBL.PutValue ('GL_LIBELLE',TOBLoc.getValue('GL_LIBELLE'));
{$ENDIF}
TOBL.PutValue('GL_NUMORDRE',GetMaxNumOrdre(TOBpiece));
end;

procedure TCopieColleDoc.InsertLigneTotalImp (TOBLoc : TOB;Arow,Niveau: integer);
var TOBl : TOB;
begin
InsertTobLigne (TOBPiece,Arow);
TOBL := GetTOBLIgne (TOBPiece,Arow);
AddLesSupLigne(TOBL,False) ; InitLesSupLigne (TOBL);
CopieChampsLigne ('LIGNE',TOBL,TOBLOC);
CopieChampsSup (TOBL,TOBLOC);
VerifChampsSupsLigne(TOBL);
//NewTOBLigneFille (TOBL);
PieceVersLigne (TOBPIece,TOBL);
AffaireVersLigne (TOBPiece,TOBL,TOBAffaire);
TOBL.PutValue('GL_NIVEAUIMBRIC',Niveau);
TOBL.PutValue('GL_PIECEPRECEDENTE','');
TOBL.PutValue('GL_PIECEORIGINE','');
TOBL.PutValue('GLC_DOCUMENTLIE','');
TOBL.PutValue('GL_NUMORDRE',GetMaxNumOrdre(TOBpiece));
end;


Function TCopieColleDoc.IsArticleOk (Arow : integer):boolean;
var TOBArt,TOBL : TOB;
    rechart : T_RechArt;
    refsais : string;
begin
result := false;
TOBArt:=FindTOBArtRow (TOBPiece,TobArticles,Arow);
TOBL:=GetTOBLigne(TOBPiece,Arow) ; if TOBL = nil then exit;
if TOBArt<>Nil then
   BEGIN
   Result := true;
   END else
   BEGIN
   TOBArt:=CreerTOBArt(TOBArticles) ;
   RefSais := TOBL.GetValue('GL_CODEARTICLE');
   RechArt:=TrouverArticleSQL(TFFacture(fform).CleDoc.NaturePiece,RefSais,TFFacture(fform).GP_DOMAINE.Value,
                              '',TFFacture(fform).CleDoc.DatePiece,TOBArt,TOBTiers,TOBL.GetValue('GL_ARTICLE')) ;
   if (RechArt = traOk) or (RechArt = TraOkGene) then
      begin
      if Not ArticleAutorise(TOBPiece,TOBArticles,TFFacture(fform).CleDoc.NaturePiece,ARow) then
         BEGIN
         result := false;
         END else
         BEGIN
         result := true;
         END ;
      end;
   END ;
end;

procedure TCopieColleDoc.PositionneCell(Acol, Arow: integer);
begin
rowCollage := Arow;
colCollage := Acol;
end;

procedure TCopieColleDoc.rapeller;
begin
if fgrid = nil then Exit;
RappellerMemo;
RowCollage := -1;
ColCollage := -1;
end;

procedure TCopieColleDoc.deselectionneRows;
begin
{$IFDEF BTP}
fgrid.OnFlipSelection := nil;
fgrid.OnBeforeFlip := nil;
fgrid.AllSelected := false;
fgrid.OnFlipSelection := FlipSelection;
fgrid.OnBeforeFlip := BeforeFlip;
{$ELSE}
fgrid.ClearSelected ;
{$ENDIF}
end;

procedure TCopieColleDoc.RappellerMemo;
var Retour : string;
    TOBMemo : TOB;
    QQ :TQuery;
begin
deselectionneRows;
Retour := AGLLanceFiche ('BTP','BTMEMORIS_MUL','BMO_TYPEMEMO='+fTypeInfo,'','');
if Retour <> '' then
   begin
   TOBMemo := TOB.create ('BMEMORISATION',nil,-1);
   QQ := OpenSQL('Select BMO_MEMO from BMEMORISATION Where BMO_TYPEMEMO="'+fTypeInfo+'" AND' +
             ' BMO_CODEMEMO="'+Retour+'"',True,-1,'',true);
   TOBMemo.SelectDB ('',QQ);
   ferme(QQ);
   fmemo.Clear;
   fmemo.text := TOBMemo.getValue('BMO_MEMO');
   TobMemo.Free;
   Collagedonnee;
   deselectionneRows;
   end;
end;


procedure TCopieColleDoc.GSContextPopup(Sender: TObject; MousePos: TPoint;var Handled: Boolean);
var Acol,Arow : Integer;
    TOBL : TOB;
    Cancel : boolean;
begin
if (MousePos.X = -1) or (MousePos.y = -1) then exit;
fgrid.MouseToCell (MousePos.X,MousePos.Y,Acol,ARow);
TOBL:=GetTOBLigne(TOBPiece,Arow) ;
if TOBL = nil then
   begin
   Handled := true;
   exit;
   end;
Cancel := true;
fgrid.synenabled := false;
if Acol < fgrid.FixedCols then Acol := fgrid.fixedCols;
fgrid.col := Acol;
fgrid.row := Arow;
TFFacture(fform).GSRowEnter (fgrid,Arow,Cancel,false);
TFFacture(fform).GSCellEnter (fgrid,Acol,Arow,cancel);
fgrid.row := Arow;
fgrid.col := Acol;
{$IFDEF BTP}
PositionneCell(Acol,Arow);
{$ENDIF}
fgrid.SynEnabled := true;
if TFFacture(fform).Action = TaConsult then MenuEnabled (false)
                                       else MenuEnabled (true);
end;

procedure TCopieColleDoc.GSCollerClick(Sender: TObject);
begin
Coller;
end;


procedure TCopieColleDoc.GSCouperClick(Sender: TObject);
begin
Couper;
end;

procedure TCopieColleDoc.GScopierClick(Sender: TObject);
begin
Copier;
end;

procedure TCopieColleDoc.GSEnregistrerClick(Sender: TObject);
begin
Enregistrer;
end;

procedure TCopieColleDoc.GSRappelerClick(Sender: TObject);
begin
rapeller;
end;

destructor TCopieColleDoc.destroy;
var indice : integer;
begin
  inherited;
  TOBLR.free;
  for Indice := 0 to fMaxItems -1 do
    begin
    MesMenuItem[Indice].Free;
    end;
if fcreatedPop then POPGS.free;
end;

procedure TCopieColleDoc.MenuEnabled(State: boolean);
var Indice : integer;
begin
  for Indice := 0 to fMaxItems -1 do
  begin
    if (MesMenuItem[Indice].name <> 'BCOPIER') AND
       (MesMenuItem[Indice].name <> 'BCOUPER') AND
       (MesMenuItem[Indice].name <> 'BENREGISTRER') then MesMenuItem[Indice].Enabled := State;
  end;
end;


procedure InitChampsSupNULL (TOBAssoc: TOB);
var NomChamp : string;
    Ind2 : integer;
    Result : string;
begin
   ind2 := 1000;
   NomChamp := TobAssoc.GetNomChamp(ind2);
   while NomChamp <> '' do
   begin
      Result := VarAsType(TobAssoc.GetValeur(ind2), varString);
      if Result = #0 then TobAssoc.PutValeur(ind2,'');
      Inc(ind2);
      NomChamp := TobAssoc.GetNomChamp(ind2);
   end;
end;


procedure TCopieColleDoc.VerifChampsSupsLigne(TOBL: TOB);
var Indice : integer;
		NomChamp : string;
begin
//
  if TOBL.fieldExists ('TOTALACHAT') then
    if VarType (TOBL.GetValue('TOTALACHAT')) = VarString then
      TOBL.PutValue ('TOTALACHAT',Valeur(TOBL.GetValue('TOTALACHAT')));
  if TOBL.fieldExists ('TOTALREVIENT') then
    if VarType (TOBL.GetValue('TOTALREVIENT')) = VarString then
      TOBL.PutValue ('TOTALREVIENT',Valeur(TOBL.GetValue('TOTALREVIENT')));
(*
  if TOBL.fieldExists ('TPSUNITAIRE') then
    if VarType (TOBL.GetValue('TPSUNITAIRE')) = VarString then
      TOBL.PutValue ('TPSUNITAIRE',Valeur(TOBL.GetValue('TPSUNITAIRE')));
*)
  if TOBL.fieldExists ('__COEFMARG') then
    if VarType (TOBL.GetValue('__COEFMARG')) = VarString then
      TOBL.PutValue ('__COEFMARG',Valeur(TOBL.GetValue('__COEFMARG')));
  if TOBL.fieldExists ('GLC_NATUREPIECEG') then
    if VarType (TOBL.GetValue('GLC_NATUREPIECEG')) = VarString then
      TOBL.PutValue ('GLC_NATUREPIECEG','');
  if TOBL.fieldExists ('GLC_SOUCHE') then
    if VarType (TOBL.GetValue('GLC_SOUCHE')) = VarString then
      TOBL.PutValue ('GLC_SOUCHE','');
  if TOBL.fieldExists ('GLC_NUMERO') then
    if VarType (TOBL.GetValue('GLC_NUMERO')) = VarString then
      TOBL.PutValue ('GLC_NUMERO',TOBL.GetValue('GL_NUMERO'));
  if TOBL.fieldExists ('GLC_INDICEG') then
    if VarType (TOBL.GetValue('GLC_INDICEG')) = VarString then
      TOBL.PutValue ('GLC_INDICEG',TOBL.GetValue('GL_INDICEG'));
  if TOBL.fieldExists ('GLC_NUMORDRE') then
    if VarType (TOBL.GetValue('GLC_NUMORDRE')) = VarString then
      TOBL.PutValue ('GLC_NUMORDRE',TOBL.GetValue('GL_NUMORDRE'));
  if TOBL.fieldExists ('GLC_QTACCSAIS') then
    if VarType (TOBL.GetValue('GLC_QTACCSAIS')) = VarString then
      TOBL.PutValue ('GLC_QTACCSAIS',0);
  if TOBL.fieldExists ('GLC_DATEACC') then
    if VarType (TOBL.GetValue('GLC_DATEACC')) = VarString then
      TOBL.PutValue ('GLC_DATEACC',iDate1900);
  if TOBL.fieldExists ('GLC_IDENTIFIANTWNT') then
    if VarType (TOBL.GetValue('GLC_IDENTIFIANTWNT')) = VarString then
      TOBL.PutValue ('GLC_IDENTIFIANTWNT',0);
  if TOBL.fieldExists ('GLC_LIGNEORDRE') then
    if VarType (TOBL.GetValue('GLC_LIGNEORDRE')) = VarString then
      TOBL.PutValue ('GLC_LIGNEORDRE',0);
  if TOBL.fieldExists ('GLC_DATEDEB') then
    if VarType (TOBL.GetValue('GLC_DATEDEB')) = VarString then
      TOBL.PutValue ('GLC_DATEDEB',iDate1900);
  if TOBL.fieldExists ('GLC_DATEFIN') then
    if VarType (TOBL.GetValue('GLC_DATEFIN')) = VarString then
      TOBL.PutValue ('GLC_DATEFIN',iDate1900);
//
  if TOBL.fieldExists ('GCA_PRIXBASE') then
    if VarType (TOBL.GetValue('GCA_PRIXBASE')) = VarString then
      TOBL.PutValue ('GCA_PRIXBASE',Valeur(TOBL.GetValue('GCA_PRIXBASE')));
  if TOBL.fieldExists ('GA_PAHT') then
    if VarType (TOBL.GetValue('GA_PAHT')) = VarString then
      TOBL.PutValue ('GA_PAHT',Valeur(TOBL.GetValue('GA_PAHT')));
  if TOBL.fieldExists ('GA_PVHT') then
    if VarType (TOBL.GetValue('GA_PVHT')) = VarString then
      TOBL.PutValue ('GA_PVHT',Valeur(TOBL.GetValue('GA_PVHT')));
  if TOBL.fieldExists ('BLO_PRXACHBASE') then
    if VarType (TOBL.GetValue('BLO_PRXACHBASE')) = VarString then
      TOBL.PutValue ('BLO_PRXACHBASE',Valeur(TOBL.GetValue('BLO_PRXACHBASE')));
//
for Indice := 0 to TOBL.ChampsSup.Count -1 do
begin
	NomChamp := TOBL.GetNomChamp(1000+indice);
	if VarIsNull(TOBL.GetValue(NomChamp)) or (VarAsType(TOBL.GetValue(NomChamp), varString) = #0 ) then
  begin
  	PGIInfo ('ATTENTION : le champs : '+NomChamp+' est NULL');
  end;
end;

end;

procedure TCopieColleDoc.HideMenu;
var Indice : integer;
begin
  for Indice := 0 to fMaxItems -1 do
  begin
    if (MesMenuItem[Indice].name = 'BCOPIER') OR
    	 (MesMenuItem[Indice].name = 'BCOUPER') OR
    	 (MesMenuItem[Indice].name = 'BCOLLER') OR
       (MesMenuItem[Indice].name = 'BENREGISTRER') or
       (MesMenuItem[Indice].name = 'BRAPELLER') then MesMenuItem[Indice].Visible := false;
  end;
end;

procedure TCopieColleDoc.Activate;
begin
  if (tModeSaisieBordereau in TFFacture(FF).SaContexte) then HideMenu;
end;

procedure TCopieColleDoc.CopieChampsLigne(Table : string; TOBLOC,Tobl: Tob);
var
  TobLigne: Tob;
  i: Integer;
  NomChamp: String;
begin
  if Assigned(Tobl) then
  begin
    TobLigne := Tob.Create(Table, nil, -1);
    try
      for i := 1 to TobLigne.NbChamps do
      begin
        NomChamp := TobLigne.GetNomChamp(i);
        if TOBLoc.fieldExists (NomChamp) then
        begin
          TOBLoc.putValue(NomChamp,TOBL.GetValue(NomChamp));
        end;
      end;
    finally
      TobLigne.Free;
    end;
  end;
end;

procedure TCopieColleDoc.CopieDonneeOuvrage(TOBDest, TOBOUV: TOB);
begin
	// 1er niveau
  InsertionChampSupOuv (TOBDest,false);
  CopieChampsSup (TOBDest,TOBOUV);
  // niveau suivant
  CopieDetailOuvrage (TOBDest,TOBOUV);
end;

procedure TCopieColleDoc.CopieDetailOuvrage (TOBDest,TOBOUV : TOB);
var Indice : integer;
		TOBSuite,TOBDETOUV : TOB;
begin
  for Indice := 0 to TOBOUV.detail.count -1 do
  begin
    TOBDETOUV := TOBOUV.detail[Indice];
    TOBSUite := TOB.Create ('LIGNEOUV',TOBDest,-1);
//    TOBSUite := TOBDest.detail[tobdest.detail.count-1];
    InsertionChampSupOuv (TOBSuite,false);
  	CopieChampsLigne ('LIGNEOUV',TOBSuite,TOBDETOUV);
    CopieChampsSup (TOBSuite,TOBDETOUV);
    VerifChampsSupsDetail (TobSuite);
  	if isBlobVide (FF,TOBSuite,'BLO_BLOCNOTE') then TOBSuite.putValue('BLO_BLOCNOTE','');
//  	InitChampsSupNULL (TOBSuite);
    TOBPiece.putValue('GP_UNIQUEBLO',TOBPiece.getValue('GP_UNIQUEBLO')+1);
    TOBSUITE.putValue('BLO_UNIQUEBLO',TOBPiece.getValue('GP_UNIQUEBLO'));
    if TOBDETOUV.detail.count > 0 then CopieDetailOuvrage (TOBSuite,TOBDetOUV);
  end;
end;


procedure TCopieColleDoc.AjouteUneLigneAraffraichir(Arow : integer);
var TOBALR : TOB;
begin
  TOBALR := TOB.Create('UNE LIGNE',TOBLR,-1);
  TOBALR.AddChampSupValeur ('NUMORDRE',Arow);
end;

function TCopieColleDoc.FindLigne (NumOrdre : integer) : TOB;
var Indice : integer;
    TOBL : TOB;
begin
  result := nil;
  Indice := TOBPiece.detail.count -1;
  repeat
    TOBL := TOBPiece.detail[Indice];
    if TOBL.getValue('GL_NUMORDRE')=NumOrdre then
    begin
      result := TOBL;
      break;
    end else dec(Indice);
  until Indice = 0;
end;

end.
