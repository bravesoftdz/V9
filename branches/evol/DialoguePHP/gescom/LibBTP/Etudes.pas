unit Etudes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,splash,
  Grids, Hctrls, ExtCtrls, HTB97, StdCtrls, Mask,HEnt1,HMsgBox,EntGC,TarifUtil,
  HSysMenu, Menus,lookup, StrUtils,
{$IFDEF EAGLCLIENT}
  maineagl,
{$ELSE}
  Doc_Parser,DBCtrls, Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} fe_main,
{$ENDIF}
{$IFDEF BTP}
  BTPUTIL,UtilFichiers, CalcOLEGenericBTP,
{$ENDIF}
  FactUtil,Dicobtp,UTOB, AffaireUtil,EtudesUtil,EtudesExt,SaisUtil,ParamSoc,Hstatus,
  UtilXlsBTP,EtudesStruct,EtudePiece,Facture,FactComm, ComCtrls, CBPPath,uEntCommun,
  AglMail,
  MailOl,
  UlibWindows,
  UtilXls,
  UtilTOBPiece,
  FactTiers,
  FactAdresse;


const RowsInit : integer = 30;

//Type TActionTrait = (TatNormal,TatAccept,TatBordereau);

type

  TFEnvoiMail = record
    Sujet           : HString;
    Destinataire    : String;
    Corps           : HTStringList;
    ResultMailForm  : TResultMailForm;
    copie           : String;
    fichiers        : String;
    end;

  TFEtudes = class(TForm)
    Panel1: TPanel;
    DockBottom: TDock97;
    Outils97: TToolbar97;
    BMenuZoom: TToolbarButton97;
    BInfos: TToolbarButton97;
    BActionsLignes: TToolbarButton97;
    BDelete: TToolbarButton97;
    BImprimer: TToolbarButton97;
    BNewligne: TToolbarButton97;
    BArborescence: TToolbarButton97;
    Valide97: TToolbar97;
    BValider: TToolbarButton97;
    BAbandon: TToolbarButton97;
    BAide: TToolbarButton97;
    PENTETE: TPanel;
    LAFF_TIERS: TLabel;
    LAFF_AFFAIRE: TLabel;
    LAFF_NOMCLI: TLabel;
    AFF_LIBELLE: TLabel;
    AFF_TIERS: THCritMaskEdit;
    AFF_AFFAIRE1: THCritMaskEdit;
    AFF_AFFAIRE2: THCritMaskEdit;
    AFF_AFFAIRE3: THCritMaskEdit;
    HmTrad: THSystemMenu;
    PopCreat: TPopupMenu;
    AFF_AFFAIRE: THCritMaskEdit;
    AFF_AVENANT: THCritMaskEdit;
    PopExcel: TPopupMenu;
    DefStructXls: TMenuItem;
    EntreeValDoc: TMenuItem;
    RenvoieDonneeXls: TMenuItem;
    ModifXls: TMenuItem;
    EditionXls: TMenuItem;
    PopDocPgi: TPopupMenu;
    Modificationdudocument1: TMenuItem;
    EditionDocPGI: TMenuItem;
    SelectDocP: TMenuItem;
    SelectDocE: TMenuItem;
    GS: THGrid;
    DOPen: TOpenDialog;
    Panel3: TPanel;
    Etat: TLabel;
    DSave: TSaveDialog;
    RecupDonneeXls: TMenuItem;
    WinTV: TToolWindow97;
    TV: TTreeView;
    RenVoieBordereauXls: TMenuItem;
    REGROUPFACTBIS: THValComboBox;
    TAFF_REGOUPFACT: THLabel;
    AFF_GENERAUTO: THValComboBox;
    TAFF_GENERAUTO: THLabel;
    Label1: TLabel;
    BRechAffaire: TToolbarButton97;
    bnewaff: TToolbarButton97;
    AFF_AFFAIRE0: THCritMaskEdit;
    LAFFAIRE: TLabel;
    NAFF_AFFAIRE1: THCritMaskEdit;
    NAFF_AFFAIRE2: THCritMaskEdit;
    NAFF_AFFAIRE3: THCritMaskEdit;
    NAFF_AVENANT: THCritMaskEdit;
    NAFF_AFFAIRE: THCritMaskEdit;
    NAFF_AFFAIRE0: THCritMaskEdit;
    EnvoiLotCotraitance: TMenuItem;
    N1C: TMenuItem;
    N2C: TMenuItem;
    EnvoiLotGlobal: TMenuItem;
    LblErreur: TLabel;

    //
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BAbandonClick(Sender: TObject);
    procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean;
      Chg: Boolean);
    procedure GSCellEnter(Sender: TObject; var ACol, ARow: Integer;
      var Cancel: Boolean);
    procedure GSCellExit(Sender: TObject; var ACol, ARow: Integer;
      var Cancel: Boolean);
    procedure BDeleteClick(Sender: TObject);
    procedure GSElipsisClick(Sender: TObject);
    procedure GSEnter(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    procedure SelectDocEClick(Sender: TObject);
    procedure SelectDocPClick(Sender: TObject);
    procedure ModifXlsClick(Sender: TObject);
    procedure DefStructXlsClick(Sender: TObject);
    procedure RecupDonneeXlsClick(Sender: TObject);
    procedure RenvoieDonneeXlsClick(Sender: TObject);
    procedure EntreeValDocClick(Sender: TObject);
    procedure Modificationdudocument1Click(Sender: TObject);
    procedure BArborescenceClick(Sender: TObject);
    procedure WinTVClose(Sender: TObject);
    procedure TVClick(Sender: TObject);
    procedure RenVoieBordereauXlsClick(Sender: TObject);
    procedure EditionXlsClick(Sender: TObject);
    procedure EditionDocPGIClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GSDblClick(Sender: TObject);
    procedure REGROUPFACTBISChange(Sender: TObject);
    procedure AFF_GENERAUTOChange(Sender: TObject);
    procedure BRechAffaireClick(Sender: TObject);
    procedure bnewaffClick(Sender: TObject);
    procedure PopExcelPopup(Sender: TObject);
    procedure EnvoiLotCotraitanceClick(Sender: TObject);
    procedure EnvoiLotGlobalClick(Sender: TObject);
    function  ControlePiece(TOBEtudeL : TOB) : boolean;

  private
    { Déclarations privées }
    TOBEtude    : TOB;
    TOBEtude_O  : TOB;
    TOBNatD     : TOB;
    TOBStrDoc_O : TOB;
    TOBStrDoc   : TOB;
    TOBAnnul    : TOB;
    ETudeRef    : TOB;
    Action      : TActionFiche ;
    ValidateOk  : Boolean;
    Modifie     : boolean;
    Affaire     : String;
    NewAffaire  : String;
    LesColonnes : String;
    repertBase  : string;
   	TiersClie   : string;
    fNatureAuxi : string;
    CellCur     : string;
    GS_ORDRE    : Integer;
    GS_NATURE   : Integer;
    GS_INDICE   : Integer;
    GS_TYPE     : Integer;
    GS_LIBELLE  : Integer;
    GS_SELECT   : Integer;
    GS_DATEDEP  : Integer;
    GS_DATEFIN  : Integer;
    GS_FOURNISSEUR : integer;
    Traitement  : TActionTrait;
    fMandataire : boolean;
    EnvoiMail   : TFEnvoiMail;

    procedure AllouerTOB;
    procedure InitLesCols;
    procedure LibererTOB;
    procedure DefinitionGrille;
    procedure EtudieColsListe;
    procedure EtudieColsGrid(GS: THGrid);
    procedure AlimenteTobs;
    procedure chargeEtude;
    procedure definiPopCreat;
    procedure AddSecondaireClick(Sender: TObject);
    procedure AddAttachPrincClick(Sender: TObject);
    procedure AddPrincipalClick(Sender: TObject);
    procedure LibererMenus;
    function ZoneAccessible(ACol, ARow: Integer): boolean;
    procedure ZoneSuivanteOuOk(var ACol, ARow: Integer;
      var Cancel: boolean);
    procedure PostDrawCell(ACol, ARow: Integer; Canvas: TCanvas;
      AState: TGridDrawState);
    function traiteFichier(TOBL: TOB; Acol, Arow: integer): boolean;
    procedure affichePied(Arow:Integer);
    procedure MajTobs;
    procedure UpdateAncienneStructure;
    procedure detruitAncienneStructure;
    procedure EcritTobEtude;
    procedure DefiniPopUpGS (Arow: integer);
    procedure Selectionne(Arow: integer);
    procedure supprimeLaDescript(TOBL: TOB);
    function findstructure(TOBL : TOB; var Commune : boolean): TOB;
    procedure TraitementAbandon;
    procedure supprimeAssociation(TOBL: TOB);
    procedure definiTreeview;
    procedure RaffraichiTreeview;
    procedure PositionneBordereau(TobRef: TOB);
    procedure PositionneLigne (Arow:integer;Acol : integer=-1);
    procedure AjouteAnnulation(TOBEtudeL: TOB);
    procedure VerifExistencePiece(TOBL: TOB);
    procedure SetTraitement(const Value: TActionTrait);
    procedure ZoomOuChoixDateLiv(ACol, ARow: integer);
    procedure NettoyageEtudeVide;
    function EtudeVide(TOBE: TOB): boolean;
    procedure SetNatureAuxi(const Value: String);
    procedure EcritDocumentsViaEtude;
    function GetEmail (TOBL : TOB) : string;

    //FV1 : 16/06/2011
    Function ExisteContact(TOBL : Tob) : boolean;
    Procedure RechercheValeurZone(TOBL : TOB);
    function ChargeTobMail(Tobchaine: Tob; ZoneChaine: string): string;

  public

    { Déclarations publiques }
    property leTraitement : TActionTrait read Traitement write SetTraitement;
    property NatureAuxi : String read fNatureAuxi write SetNatureAuxi;
  end;

Function GestionDetailEtude (NatureAuxi,Client,Affaire: string;mandataire : boolean;Action:TActionFiche;var TOBstudy:TOB;Traitement:TActionTrait=TatNormal): boolean;


var
  FEtudes: TFEtudes;
implementation
{$R *.DFM}
uses UCotraitance,TiersUtil,UfactExportXLS, UtilsRapport;

Function GestionDetailEtude (NatureAuxi,Client,Affaire: string;mandataire : boolean;Action:TActionFiche;var TOBstudy : TOB;Traitement:TActionTrait):boolean;
var FEtude : TFEtudes;
    Indice : Integer;
    TOBL :TOB;
begin
result := true;
FEtude := TFEtudes.Create (application);
TRY
   FEtude.Affaire := Affaire;
   FEtude.TiersClie := Client;
   FEtude.natureAuxi := NatureAuxi;
   FEtude.fMandataire := mandataire;
//   FEtude.New_Affaire := Affaire; // par défaut on propose la meme
   Fetude.Action := Action;
   FEtude.LeTraitement := Traitement;
   FEtude.EtudeRef := TOBstudy;
   Fetude.ShowModal;
FINALLY
   if FEtude.Traitement = TatAccept then
      begin
      if Fetude.ValidateOk then
         begin
         TOBstudy.clearDetail;
         TOBstudy.Dupliquer (FEtude.TOBEtude,false,true);
         for Indice := 0 TO FEtude.TOBEtude.detail.count -1 do
             begin
             if FETude.TOBEtude.detail[Indice].GetValue('BDE_SELECTIONNE')='X' then
                begin
                TOBL := TOB.create ('BDETETUDE',TOBstudy,-1);
                TOBL.dupliquer (FETude.TOBEtude.detail[Indice],false,true);
                end;
             end;
         Result := true;
         end
         else Result := false;
      Fetude.LibererTOB;
      end;
   Fetude.Free;
END;
end;

procedure TFEtudes.AllouerTOB;
begin
//
TOBEtude := TOB.create ('ETUDE',nil,-1);
AddChampsSupEtude (TOBEtude);
TOBEtude_O := TOB.create ('ETUDE',nil,-1);
TOBNATD := TOB.create ('COMMUN',nil,-1);
TOBSTRDOC_O := TOB.Create ('STRUCTUREORIG',nil,-1);
TOBSTRDOC := TOB.Create ('STRUCTURE',nil,-1);
TOBAnnul := TOB.Create ('ANNULATION',nil,-1)
end;

procedure TFEtudes.LibererTOB;
begin
TOBEtude.free;
TOBEtude_O.free;
TOBStrDoc_O.free;
TOBStrDoc.free;
TOBNATD.free;
TOBAnnul.free;

TOBEtude:= nil;
TOBEtude_O:= nil;
TOBSTRDOC_O:=nil;
TOBSTRDoc_O:=nil;
TOBNatD:=nil;
TOBAnnul := nil;
end;

procedure TFEtudes.InitLesCols;
begin
GS_ORDRE := -1;
GS_NATURE := -1;
GS_INDICE := -1;
GS_TYPE := -1;
GS_LIBELLE := -1;
GS_SELECT := -1;
GS_DATEDEP := -1;
GS_DATEFIN := -1;
GS_FOURNISSEUR := -1;
end;

procedure TFEtudes.DefinitionGrille;
begin
if (Action = TaConsult) or (Traitement = TatAccept ) then
   begin
   GS.Options:=GS.Options-[GoEditing,GoTabs,GoAlwaysShowEditor] ;
   GS.Options:=GS.Options+[GoRowSelect];
   end;
end;

procedure TFEtudes.EtudieColsGrid(GS : THGrid);
Var NomCol,LesCols : String ;
    icol,ichamp,iTableLigne : integer ;
begin
LesCols:=GS.Titres[0] ; icol:=0 ;
iTableLigne:=PrefixeToNum('BDE') ;
Repeat
 NomCol:=uppercase(Trim(ReadTokenSt(LesCols))) ;
 if NomCol<>'' then
    BEGIN
    ichamp:=ChampToNum(NomCol) ;
    if ichamp>=0 then
       BEGIN
       if Pos('X',V_PGI.Dechamps[iTableLigne,ichamp].Control)>0 then GS.ColLengths[icol]:=-1 ;
       if NomCol='BDE_ORDRE'       then GS_ORDRE:=icol        else
       if NomCol='BDE_NATUREDOC'   then GS_NATURE:=icol       else
       if NomCol='BDE_INDICE'      then GS_INDICE:=icol       else
       if NomCol='BDE_TYPE'        then GS_TYPE:=icol         else
       if NomCol='BDE_DESIGNATION' then GS_LIBELLE:=icol      else
       if NomCol='BDE_SELECTIONNE' then GS_SELECT:=icol       else
       if NomCol='BDE_DATEDEPART'  then GS_DATEDEP:=icol      else
       if NomCol='BDE_DATEFIN'     then GS_DATEFIN:=icol      else
       if NomCol='BDE_FOURNISSEUR' then GS_FOURNISSEUR :=icol else
        ;
       END;
    END ;
 Inc(icol) ;
Until ((LesCols='') or (NomCol='')) ;
end;

procedure TFEtudes.EtudieColsListe;
var nam,st : string;
    i : integer;
begin
  LesColonnes:=GS.Titres[0] ;
  EtudieColsGrid(GS) ; St:=LesColonnes ;
  for i:=0 to GS.ColCount-1 do
  BEGIN
    Nam:=ReadTokenSt(St) ;
    //   if Nam='BDE_TYPE' then GS.ColFormats[i]:='CB=BTTYPEDOC' ;
    if Nam='BDE_NATUREDOC' then GS.ColFormats[i]:='CB=BTNATUREDOC' ;
    if Nam='BDE_SELECTIONNE' then
    BEGIN
      GS.ColTypes [i]:='B' ;
      GS.colaligns[i]:= tacenter;
      GS.colformats[i]:= inttostr(Integer(csCoche));
    END;
    if ((Nam = 'BDE_DATEDEPART') or (Nam = 'BDE_DATEFIN')) then
    begin
      if (Traitement <> TatBordereaux) then
      begin
        GS.colwidths[i] := 0;
        GS.ColLengths [i] := -1;
      end else
      begin
        GS.ColTypes[i]:='D' ;
        GS.ColFormats[i]:=ShortdateFormat ;
      end;
    end;
  END ;
  if (Traitement <> tatAccept) and (Action <> TaConsult) then
  begin
    GS.ColLengths [GS_INDICE] := -1;
    GS.ColLengths [GS_SELECT] := -1;
    GS.ColLengths [GS_NATURE] := -1; // géré par le programme
    GS.ColLengths [GS_ORDRE] := -1; // géré par le programme
  end;
  if not fMandataire then
  begin
    GS.ColLengths [GS_FOURNISSEUR] := 0;
    GS.ColWidths  [GS_FOURNISSEUR] := -1;
  end;
end;

procedure TFEtudes.AlimenteTobs;
var QQ : TQuery;
    REq : string;
begin
  if (EtudeRef = nil) or (traitement = TatNormal) or (Traitement = TatBordereaux) then
  begin
    if TiersClie <> '' then
    begin
      InitBordereauClient (TOBEtude);
      TOBEtude.PutValue('AFF_TIERS',TiersClie);
    end else
    begin
      QQ := OpenSQL ('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE ="'+Affaire+'"',true,-1, '', True);
      if not QQ.eof then TOBetude.SelectDB ('',QQ);
      ferme (QQ);
    end;
  end else
  BEGIN
    TobEtude.Dupliquer (EtudeRef,true,true);
    AddChampsSupEtude (TOBEtude);
  END;

  QQ := Opensql ('SELECT T_LIBELLE FROM TIERS WHERE T_TIERS="'+ToBEtude.GetValue('AFF_TIERS')+'"',true,-1, '', True);
  if not QQ.eof then TOBEtude.putvalue('LAFF_NOMCLI',QQ.FindField ('T_LIBELLE').AsString );
  ferme (QQ);

  if (EtudeRef = nil) or (traitement = TatNormal) or (Traitement = TatBordereaux) then
  begin
    if TiersClie <> '' then
    begin
      QQ := opensql  ('SELECT * FROM BDETETUDE WHERE BDE_CLIENT="' + TiersClie + '" AND BDE_AFFAIRE=""',true,-1, '', True);
      TOBEtude.LoadDetailDB ('BDETETUDE','','',QQ,false,true);
    end else
    begin
      QQ := opensql  ('SELECT * FROM BDETETUDE WHERE BDE_AFFAIRE="' + affaire + '"',true,-1, '', True);
      TOBEtude.LoadDetailDB ('BDETETUDE','','',QQ,false,true);
    end;
    ferme (QQ);
  end;

  if Traitement <> TatAccept then
  begin
    Req := 'SELECT * FROM BSTRDOC WHERE BSD_AFFAIRE="'+TOBEtude.getvalue('AFF_AFFAIRE')+'" AND BSD_TIERS="'+TOBEtude.GetValue('AFF_TIERS')+'"';
    QQ := Opensql (req,true,-1, '', True);
    if not QQ.eof then
    begin
      TOBSTRDOC.LoadDetailDB ('BSTRDOC','','',QQ,false,true);
    end;
    ferme (QQ);
    if Traitement <> TatBordereaux Then
    begin
      QQ := opensql ('SELECT * FROM COMMUN WHERE CO_TYPE="BND" ORDER BY CO_LIBRE',true,-1, '', True);
    end else
    begin
      QQ := opensql ('SELECT * FROM COMMUN WHERE CO_TYPE="BND" AND CO_CODE = "001" ORDER BY CO_LIBRE',true,-1, '', True);
    end;
    TOBNATD.LoadDetailDB ('COMMUN','','',QQ,false);
    ferme (QQ);
    TOBSTRDOC_O.Dupliquer (TOBSTRDOC,true,true);
    TOBEtude_O.Dupliquer (TOBEtude,true,true);
  end;
end;

procedure TFEtudes.chargeEtude;
begin
AlimenteTobs;
if TOBEtude.detail.count = 0 then AddEtudeInitiale (TOBEtude,TOBNATD,Traitement);
end;

procedure TFEtudes.definiPopCreat;
var TOBL : TOB;
    Indice : integer;
    Melement : TmenuItem;
begin

  if Traitement = TatAccept then exit;
  for Indice := 0 to TOBNatD.detail.count -1 do
  begin
    TOBL := TOBNatD.detail[Indice];
    if (Traitement = TatBordereaux) and (TOBL.GetValue('CO_LIBRE') <> 'PRINC1') then continue;
    Melement := TmenuItem.Create (Self);
    Melement.Caption := TOBL.getValue('CO_LIBELLE');
    if TOBL.GetValue('CO_LIBRE')= 'PRINC' then
       Melement.OnClick := AddPrincipalClick
    else if TOBL.GetValue('CO_LIBRE')= 'PRINC1' then
       Melement.OnClick := AddAttachPrincClick
    else if TOBL.GetValue('CO_LIBRE')= 'SECOND' then
       Melement.OnClick := AddSecondaireClick;
    PopCreat.Items.Add (Melement);
  end;
end;

procedure TFEtudes.LibererMenus;
var MyMenu : TMenuItem;
begin
if PopCreat.items.count = 0 then exit;
repeat
MyMenu := PopCreat.items[0];
MyMenu.Free;
  until PopCreat.items.Count <= 0;
end;

Function TFEtudes.ZoneAccessible ( ACol,ARow : Longint) : boolean ;
Var TOBL : TOB ;
BEGIN
Result:=True ;
TOBL:=GetTOBEtude(TOBEtude,ARow) ; if TOBL=Nil then BEGIN Result:= false;Exit ;END;

if ((GS_NATURE > 0) and (Acol = GS_NATURE)) Then
   Begin
   if ((TOBL.GetValue('BDE_NATUREDOC') = '001') and (TOBL.GetValue('BDE_NAME') <> '')) or
      ((TOBL.GetValue('BDE_NATUREDOC') = '002') and (TOBL.GetValue('BDE_PIECEASSOCIEE') <> '')) then
      begin
      result := false;
      exit;
      end;
   End;
if GS.ColLengths [Acol] = -1 then BEGIN Result := false;exit;END;
END ;

procedure TFEtudes.ZoneSuivanteOuOk ( Var ACol,ARow : Longint ; Var Cancel : boolean ) ;
Var Sens,ii,Lim : integer ;
    OldEna,ChgLig,ChgSens  : boolean ;
BEGIN
OldEna:=GS.SynEnabled ; GS.SynEnabled:=False ;
Sens:=-1 ; ChgLig:=(GS.Row<>ARow) ; ChgSens:=False ;
if GS.Row>ARow then Sens:=1 else if ((GS.Row=ARow) and (ACol<=GS.Col)) then Sens:=1 ;
ACol:=GS.Col ; ARow:=GS.Row ; ii:=0 ;
While Not ZoneAccessible(ACol,ARow)  do
   BEGIN
   Cancel:=True ; inc(ii) ; if ii>500 then Break ;
   if Sens=1 then
      BEGIN
      Lim:=TOBEtude.detail.count ;
      if ((ACol=GS.ColCount-1) and (ARow>=Lim)) then
         BEGIN
         if ChgSens then Break else BEGIN Sens:=-1 ; Continue ; ChgSens:=True ; END ;
         END ;
      if ChgLig then BEGIN ACol:=GS.FixedCols-1 ; ChgLig:=False ; END ;
      if ACol<GS.ColCount-1 then Inc(ACol) else BEGIN Inc(ARow) ; ACol:=GS.FixedCols ; END ;
      END else
      BEGIN
      if ((ACol=GS.FixedCols) and (ARow=1)) then
         BEGIN
         if ChgSens then Break else BEGIN Sens:=1 ; Continue ; END ;
         END ;
      if ChgLig then BEGIN ACol:=GS.ColCount ; ChgLig:=False ; END ;
      if ACol>GS.FixedCols then Dec(ACol) else BEGIN Dec(ARow) ; ACol:=GS.ColCount-1 ; END ;
      END ;
   END ;
GS.SynEnabled:=OldEna ;
END ;

procedure TFEtudes.RaffraichiTreeview;
var TOBL : TOB;
    indice,Ordre : Integer ;
    Tn : TTreeNode ;
    Titre,Nature,QualifNat,Libelle : STring ;
begin
for Indice := 0 to TV.Items.Count -1 do
    begin
    tn := TV.items[indice];
    if tn.data = nil then continue;
    TOBL := tn.data;
    Ordre := TOBL.GetValue('BDE_ORDRE');
    QualifNat := TOBL.GetValue('BDE_QUALIFNAT');
    Nature := TOBL.GetValue('BDE_NATUREDOC');
    Libelle := TOBL.GetValue('BDE_DESIGNATION');
    if QualifNat = 'PRINC' then
       begin
       Tn.text := '('+inttostr(Ordre)+') '+Libelle;
       end;
    if QualifNat = 'PRINC1' then
       begin
       Tn.text := Libelle;
       end;
    if QualifNat = 'SECOND' then
       begin
       Titre := Libelle;
       if TOBL.GetValue('BDE_SELECTIONNE') = 'X' then Titre := Titre + ' (sélectionné)';
       Tn.text := Titre;
       end;
    end;
TV.FullExpand;
end;

// -------------------
// Gestion de la fiche
// -------------------
procedure TFEtudes.definiTreeview;
var TOBL : TOB;
    indice,Ordre : Integer ;
    Tn,TPrinc,Racine,TNature : TTreeNode ;
    DateDep: TdateTime;
    Titre,Nature,QualifNat,Libelle,CurNature : STring ;
begin
TPrinc := nil;
Tnature := nil;
TV.items.clear ;
if Traitement = TatBordereaux then Titre := 'Bordereaux de prix'
															else Titre := 'Arborescence de l''appel d''offre ';
Racine := TV.items.add(Nil, Titre);
for Indice := 0 to TOBEtude.detail.count -1 do
    begin
    TOBL := TOBEtude.detail[Indice];
    Ordre := TOBL.GetValue('BDE_ORDRE');
    QualifNat := TOBL.GetValue('BDE_QUALIFNAT');
    Nature := TOBL.GetValue('BDE_NATUREDOC');
    Libelle := TOBL.GetValue('BDE_DESIGNATION');
    DateDep := TOBL.GetValue('BDE_DATEDEPART');

    Tprinc := Racine;
    Curnature := '';

    if QualifNat = 'PRINC' then
       begin
       TPrinc := TV.Items.AddChild(Racine, '('+inttostr(Ordre)+') '+Libelle);
       TPrinc.Data := TOBL;
       Curnature := '';
       end;
    if (QualifNat = 'PRINC1') and (Traitement <> TatBordereaux) then
       begin
       if CurNature <> Nature then
          begin
          Tnature := TV.Items.Addchild(TPrinc, rechdom ('BTNATUREDOC',Nature,false));
          CurNature := Nature;
          end;
       Tn := TV.Items.AddChild(Tnature, Libelle);
       Tn.Data := TOBL;
       end;
    if (QualifNat = 'PRINC1') and (Traitement = TatBordereaux) then
       begin
       Tnature := TV.Items.Addchild(Racine, rechdom ('BTNATUREDOC',Nature,false)+' '+DateToStr (DateDep) );
       Tnature.Data := TOBL;
       end;
    if QualifNat = 'SECOND' then
       begin
       if CurNature <> Nature then
          begin
          Tnature := TV.Items.Addchild(TPrinc, rechdom ('BTNATUREDOC',Nature,false));
          CurNature := Nature;
          end;
       Titre := Libelle;
       if TOBL.GetValue('BDE_SELECTIONNE') = 'X' then Titre := Titre + ' (sélectionné)';
       Tn := TV.Items.AddChild(TNature, Titre);
       Tn.Data := TOBL;
       end;
    end;
TV.FullExpand;
end;

procedure TFEtudes.FormCreate(Sender: TObject);
begin
  Modifie := false;
  ValidateOk := false;
  AllouerTOB;
  InitLesCols;
  GS.PostDrawCell := PostDrawCell;
  //
  Etat.caption := '';
  LblErreur.Caption := '';
end;

function TFEtudes.EtudeVide(TOBE : TOB) : boolean;
begin
  result :=((TOBE.GEtValue('BDE_TYPE')='001') and (TOBE.GetValue('BDE_NAME') = '')) or
           ((TOBE.GEtValue('BDE_TYPE')='002') and (TOBE.GetValue('BDE_PIECEASSOCIEE') = '')) or
           (TOBE.GEtValue('BDE_TYPE')='');
end;

procedure TFEtudes.NettoyageEtudeVide;

var indice : integer;
		TOBE : TOB;
begin
	Indice := 0;
  if TOBEtude.detail.count = 0 then exit;
  repeat
    TOBE := TOBEtude.detail[Indice];
//    if (TOBE.GEtValue('BDE_NATUREDOC')<>'') and (TOBE.GetValue('BDE_NAME') = '') then
    if EtudeVide(TOBE) then
    begin
    	TOBE.free;
    end else
    begin
    	Inc(Indice);
    end;
  until Indice >= TOBEtude.detail.count;
end;

procedure TFEtudes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Traitement <> TatAccept then
   begin
   if ValidateOk then
      BEGIN
      // le menage des pieces a deja ete fait dans la validation
      FaireMenageRepertoire (TOBEtude,Traitement)
      END else
      BEGIN
      // fais le menage dans le repertoire
      TraitementAbandon;
      FaireMenageRepertoire (TOBEtude_O,Traitement);
      END;
   libererTob;
   end;
LibererMenus;
end;

procedure TFEtudes.FormShow(Sender: TObject);
begin
if Traitement=TatAccept then
   begin
   PENTETE.Height := 113;
   TAFF_REGOUPFACT.Visible := true;
   TAFF_GENERAUTO.Visible := true;
   AFF_GENERAUTO.Visible := true;
   REGROUPFACTBIS.Visible := true;
   AFF_GENERAUTO.DataType := 'AFTGENERAUTO';
   LAFF_AFFAIRE.caption := TraduireMemoire('Appel d''offre');
   bNewAff.Visible := true;
{$IFDEF BTP}
   AFF_GENERAUTO.Plus := 'BTP';
{$ELSE}
   AFF_GENERAUTO.Plus := 'GA';
{$ENDIF}
   AFF_GENERAUTO.ReLoad ;
   REGROUPFACTBIS.DataType := 'AFTREGROUPEFACT';
{$IFDEF BTP}
   REGROUPFACTBIS.Plus := ' AND ((CC_LIBRE = "A")  OR ( CC_LIBRE= "BTP" ))';
{$ELSE}
   REGROUPFACTBIS.Plus := ' AND ((CC_LIBRE = "A")  OR ( CC_LIBRE= "B" ))';
{$ENDIF}
   REGROUPFACTBIS.ReLoad ;
  end else if Traitement = TatBordereaux then
  begin
  	LAFF_AFFAIRE.caption := TraduireMemoire('Affaire');
    Caption := TraduireMemoire('Bordereaux de prix');
    if AFF_AFFAIRE.Text ='' then
    begin
    	AFF_AFFAIRE0.Visible := false;
    	AFF_AFFAIRE1.Visible := false;
    	AFF_AFFAIRE2.Visible := false;
    	AFF_AFFAIRE3.Visible := false;
    	AFF_AVENANT.Visible := false;
      LAFF_AFFAIRE.Visible := false;
    end;
  end;

chargeEtude;
definiTreeview;
GS.ListeParam := 'BTLIGETUDE';
EtudieColsListe;
AffecteGrid (GS,Action) ;
DefinitionGrille;
TOBEtude.PutEcran(Self) ;
ChargeCleAffaire (AFF_AFFAIRE0,AFF_AFFAIRE1,AFF_AFFAIRE2,AFF_AFFAIRE3,AFF_AVENANT,nil,taconsult,Affaire,true);

  bmenuzoom.Visible := false;
  BActionsLignes.Visible := False;

	if Traitement=TatAccept then
	BEGIN
    BInfos.Visible := False;
    NAFF_AFFAIRE0.text := 'A';
    NewAffaire := 'A' + copy(TOBEtude.getValue('AFF_AFFAIRE'),2,16);
    if existeSQl ('SELECT AFF_AFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+NewAffaire+'"') then
    begin
    	NewAffaire := '';
      TOBETUDE.putvalue('NEW_AFFAIRE','X');
      TOBETUDE.putvalue('AFFAIRE_INIT','-');
    end;
    NAFF_AFFAIRE.text := NewAffaire;
    ChargeCleAffaire (NAFF_AFFAIRE0,NAFF_AFFAIRE1,NAFF_AFFAIRE2,NAFF_AFFAIRE3,NAFF_AVENANT,Brechaffaire,taconsult,NewAffaire,true);
	END else if (Traitement = TatBordereaux) and (AFF_AFFAIRE.text='') then
  begin
    AFF_AFFAIRE0.Visible := false;
    AFF_AFFAIRE1.Visible := false;
    AFF_AFFAIRE2.Visible := false;
    AFF_AFFAIRE3.Visible := false;
    AFF_AVENANT.Visible := false;
    LAFF_AFFAIRE.Visible := false;
  end;
AfficheLagrille (GS,TOBEtude,Lescolonnes,1);
GS.RowCount := RowsInit;
HMTrad.ResizeGridColumns(GS) ;
definiPopCreat;
if (Traitement = TatAccept) or (Action = TaConsult) then
   begin
   BNewligne.Visible := false;
   BDelete.Visible := false;
   if Action = TaConsult then BValider.Visible := false;
   end;

if TraiteMent = TatBordereaux then
begin
  Modificationdudocument1.Caption := Traduirememoire('Modification du bordereau');
  EditionDocPGI.Caption := TraduireMemoire('Edition du bordereau');
end;

end;

procedure TFEtudes.TraitementAbandon;
begin
FaireMenagePiece (TOBEtude,TobEtude_O,TOBAnnul);
end;

procedure TFEtudes.supprimeAssociation(TOBL : TOB);
var TOBS : TOB;
begin
if TOBL.FieldExists ('NEW') then
   begin
   AjouteAnnulation (TOBL)
   end else
   begin
   TOBS := TOBEtude_O.findfirst (['BDE_ORDRE','BDE_NATUREDOC','BDE_INDICE'],
                                [TOBL.GetValue('BDE_ORDRE'),TOBL.GetValue('BDE_NATUREDOC'),TOBL.GetValue('BDE_INDICE')],true);
   if TOBS = nil then AjouteAnnulation (TOBL)
                 else BEGIN
                      if TOBL.GetValue('BDE_PIECEASSOCIEE') <> TOBS.GetValue('BDE_PIECEASSOCIEE') then AjouteAnnulation (TOBL);
                      END;
   end;
TOBL.putValue('BDE_NAME','');
TOBL.PutValue('BDE_PIECEASSOCIEE','');
TOBL.PutValue('BDE_NATUREPIECEG','');
TOBL.PutValue('BDE_SOUCHE','');
TOBL.PutValue('BDE_NUMERO',0);
TOBL.PutValue('BDE_INDICEG',0);
TOBS := TOBStrDOc.FinDFirst (['BSD_ORDRE','BSD_TYPE','BSD_NATUREDOC','BSD_INDICE'],
                             [TOBL.GetValue('BDE_ORDRE'),TOBL.GetValue('BDE_TYPE'),TOBL.GetValue('BDE_NATUREDOC'),
                             TOBL.GetValue('BDE_INDICE')],true);
if TOBS <> nil then TOBS.free;
end;

procedure TFEtudes.BAbandonClick(Sender: TObject);
begin
close;
end;

procedure TFEtudes.GSRowEnter(Sender: TObject; Ou: Integer;
  var Cancel: Boolean; Chg: Boolean);
begin
DefiniPopUpGS (Ou);
affichePied (Ou);
end;

procedure TFEtudes.GSCellEnter(Sender: TObject; var ACol, ARow: Integer;
  var Cancel: Boolean);
var  TextMess : string;
begin
TextMess := '';
if Action=taConsult then Exit ;
ZoneSuivanteOuOk(ACol,ARow,Cancel) ;
GS.ElipsisButton := (Acol = GS_TYPE) or (Acol = GS_DATEDEP) or (ACol = GS_DATEFIN) or (Acol = GS_FOURNISSEUR);
if cancel then exit;
CellCur:=GS.Cells[GS.Col,GS.Row] ;
affichePied (Arow);
DefiniPopUpGS (Arow);
end;

procedure TFEtudes.GSCellExit(Sender: TObject; var ACol, ARow: Integer;
  var Cancel: Boolean);
var TOBL : TOB;
begin
  if Action=taConsult then Exit ;
  if GS.Cells[ACol,ARow]=CellCur then Exit ;
  if CellCur <> GS.Cells [Acol,Arow] then
  begin
    TOBL := GetTobEtude (TOBEtude,Arow);
    if TOBL = nil then exit;
    if Acol = GS_TYPE then
    begin
      if (CellCur <> '') then supprimeAssociation(TOBL);
      if (GS.Cells[Acol,Arow] = '001') then if not traiteFichier (TOBL,Acol,ARow) then BEGIN GS.cells[Acol,Arow] := '';exit; END;
      TOBL.putValue('BDE_TYPE',GS.CellValues [Acol,Arow]);
    end;

    if Acol = GS_LIBELLE then
    begin
      TOBL.putValue('BDE_DESIGNATION',GS.CellValues [Acol,Arow]);
      RaffraichiTreeview;
    end;

    affichePied (Arow);
    DefiniPopUpGS (Arow);

    if Acol = GS_DATEDEP then
    begin
      TOBL.putValue('BDE_DATEDEPART',StrToDate(GS.CellValues [Acol,Arow]));
    end;

    if Acol = GS_DATEFIN then
    begin
      if StrToDate(GS.CellValues [Acol,Arow]) < TOBL.GetValue('BDE_DATEDEPART') then
      BEGIN
        PgiBox (TraduireMemoire('Date de fin incorrecte'),caption);
        cancel := true;
        Exit;
      END;
      TOBL.putValue('BDE_DATEFIN',StrToDate(GS.CellValues [Acol,Arow]));
    end;

    if Acol = GS_FOURNISSEUR then
    begin
    	if GS.Cells [Acol,Arow] = '' then
      begin
      	TOBL.putValue('BDE_FOURNISSEUR','');
      end else
      begin
      	GS.cells[Acol,Arow] := UpperCase(GS.cells[Acol,Arow]);
        if not IsIntervenant (Affaire,GS.cells[Acol,Arow]) then
        begin
          PgiInfo ('Intervenant non présent dans la liste',caption);
          cancel := true;
          Exit;
        end;
      end;
      TOBL.putValue('BDE_FOURNISSEUR',GS.Cells [Acol,Arow]);
    end;
  end;
end;


procedure TFEtudes.AddSecondaireClick (Sender : TObject);
var MyMenu : TMenuItem;
    TobPrinc,TOBSecond,TOBNature : TOB;
    Arow : integer;
begin
  MyMenu := TmenuItem(Sender);

  TOBNature := FindNatureEtude (TOBNatD,MyMenu.Caption );
  if TOBNature = nil then
  BEGIN
    PGIBoxAf('Problème de paramétrage nature de document',caption);
    exit;
  END;

  TOBPrinc := FindPrincipal (TOBEtude,GS.row);

  if TobPrinc <> nil then
  begin
    TOBSecond := FindLastSecond (TOBEtude,TOBPrinc,TOBNature.getValue('CO_CODE'),Arow);
    if Arow = -1 then Arow := TOBEtude.detail.count+1
                 else Arow := Arow +1;
    AddEtudeSecond (TOBEtude,TOBPrinc,TOBSecond,TOBNature,ARow);
    if GS.rowCount <= TOBEtude.detail.count then
    begin
      GS.rowCount := GS.rowCount +1;
    end;
    AfficheLagrille (GS,TOBEtude,Lescolonnes,1);
    PositionneLigne (Arow);
    definiTreeview;
    Modifie := true;
  end
  else
  begin
    PGIBoxAf('Vous devez d''abord créer le document principal',caption);
  end;

end;

procedure TFEtudes.AddPrincipalClick (Sender : TObject);
var MyMenu : TMenuItem;
    TOBLastP,TOBNature : TOB;
begin

  MyMenu := TmenuItem(Sender);
  TOBNature := FindNatureEtude (TOBNatD,MyMenu.Caption );

  if TOBNature = nil then
  BEGIN
    PGIBoxAf('Problème de paramétrage nature de document',caption);
    exit;
  END;

  TOBLastP := FindLastPrincipal (TOBEtude); // recherche du dernier principal
  AddEtudePrincipale (TOBEtude,TOBLastP,TOBNature,-1,traitement,TOBLAstP.GEtVAlue('BDE_NATUREAUXI'));

  if GS.rowCount <= TOBEtude.detail.count then
  begin
    GS.rowCount := GS.rowCount +1;
  end;

  //FV1 : lors de la création d'une ligne on vérifie s'il y a un doc Associé
  if TobEtude.detail[TOBEtude.detail.count-1].getstring('BDE_PIECEASSOCIEE') = '' then TobEtude.detail[TOBEtude.detail.count-1].PutValue('BDE_SELECTIONNE', '-');

  AfficheLagrille (GS,TOBEtude,lescolonnes,1);
  PositionneLigne (TOBEtude.detail.count);
  definiTreeview;
  Modifie := true;

end;

procedure TFEtudes.AddAttachPrincClick (Sender : TObject);
var MyMenu : TMenuItem;
    TobPrinc,TOBSecond,TOBNature : TOB;
    Arow: integer;
begin

  MyMenu := TmenuItem(Sender);

  TOBNature := FindNatureEtude (TOBNatD,MyMenu.Caption );

  if TOBNature = nil then
  BEGIN
    PGIBoxAf('Problème de paramétrage nature de document',caption);
    exit;
  END;

  if Traitement <> TatBordereaux then
  begin
    TOBPrinc := FindPrincipal (TOBEtude,GS.row);
    if TobPrinc <> nil then
    begin
      TOBSecond := FindLastSecond (TOBEtude,TOBPrinc,TOBNature.getValue('CO_CODE'),ARow);
      if Arow = -1 then Arow := TOBEtude.detail.count+1
                   else Arow := Arow +1;
      AddEtudeAttachP (TOBEtude,TOBPrinc,TOBSecond,TOBNature,ARow);
      if GS.rowCount <= TOBEtude.detail.count then
      begin
        GS.rowCount := GS.rowCount +1;
      end;
      AfficheLagrille (GS,TOBEtude,Lescolonnes,1);
      PositionneLigne (Arow);
      definiTreeview;
      Modifie := true;
    end
    else
    begin
      PGIBoxAf('Vous devez d''abord créer le document principal',caption);
    end;
  end else
  begin
    TOBPrinc := FindLastPrincipal (TOBEtude,Traitement); // recherche du dernier principal
    AddEtudePrincipale (TOBEtude,TOBPrinc,TOBNature,-1,Traitement);
    if GS.rowCount <= TOBEtude.detail.count then GS.rowCount := GS.rowCount +1;
    AfficheLagrille (GS,TOBEtude,lescolonnes,1);
    PositionneLigne (TOBEtude.detail.count);
    definiTreeview;
    Modifie := true;
  end;

end;

procedure TFEtudes.BDeleteClick(Sender: TObject);
var TOBL : TOB;
    Arow,Acol,ORDInit,Ordre : Integer;
    Cancel : boolean;
begin
	ordre:=0;
	TOBL := GetTOBEtude (TOBEtude,GS.Row) ;
	if TOBL = nil then exit;
	GS.CacheEdit;
	if TOBL.GetValue('BDE_QUALIFNAT')='PRINC' then
  begin
     Arow := GS.row;
     OrdInit := TOBL.GetValue('BDE_ORDRE');
     repeat
     TOBL := GetTOBEtude (TOBEtude,Arow);
     if TOBL = nil then break;
     ordre := TOBL.GetValue('BDE_ORDRE');
     if Ordre = OrdInit then
        begin
        if TOBL.FieldExists ('NEW') then AjouteAnnulation (TOBL);
        supprimeLaDescript (TOBL);
        TOBL.free;
        GS.deleteRow(Arow);
        end;
     until (ordre <> ORdInit) or (TOBEtude.detail.count = 0);
     Modifie := true;
  end else
  begin
     if TOBL.FieldExists ('NEW') then AjouteAnnulation (TOBL);
     supprimeLaDescript (TOBL);
     TOBL.free;
     GS.DeleteRow (GS.row);
     Modifie := true;
  end;
  definiTreeview;
  if ToBEtude.detail.count = 0 then AddEtudeInitiale (TOBEtude,TOBNATD,Traitement);
  AfficheLagrille (GS,TOBEtude,Lescolonnes,Arow);
  Cancel := false;
  GSRowEnter(Self,Arow,Cancel,false);
  GSCellEnter (self,Acol,Arow,Cancel);
  GS.col := Acol;
  GS.row := Arow;
  CellCur := GS.cells[Acol,Arow];
  GS.montreEdit;
end;

procedure TFEtudes.PostDrawCell(ACol, ARow: Integer; Canvas: TCanvas;
  AState: TGridDrawState);
Var ARect : TRect ;
    chaine : string;
    PosG : integer;
begin
if GS.RowHeights[ARow]<=0 then Exit ;
if ARow>GS.TopRow+GS.VisibleRowCount-1 then Exit ;
ARect:=GS.CellRect(ACol,ARow) ;
GS.Canvas.Pen.Style:=psSolid ; GS.Canvas.Pen.Color:=clgray ;
GS.Canvas.Brush.Style:=BsSolid ;
if ((Acol=GS_Type) and (Arow >= GS.fixedRows)) then
   begin
   if GS.cells[Acol,Arow]<> '' then chaine := rechdom ('BTTYPEDOC',GS.cells[Acol,Arow],false)
                               else Chaine := '';
   PosG := Arect.Left + ((ARect.Right - ARect.left - canvas.textwidth(chaine)) div 2);
   canvas.TextOut (PosG,ARect.top + 1,Chaine);
   end;
if ((Acol=GS_FOURNISSEUR) and (Arow >= GS.fixedRows)) then
   begin
   canvas.FillRect(Arect); 
   if GS.cells[Acol,Arow]<> '' then chaine := rechdom ('GCTIERS',GS.cells[Acol,Arow],false)
                               else Chaine := '';
   PosG := Arect.Left + ((ARect.Right - ARect.left - canvas.textwidth(chaine)) div 2);
   canvas.TextOut (PosG,ARect.top + 1,Chaine);
   end;
end;

procedure TFEtudes.GSElipsisClick(Sender: TObject);
var result : boolean;
    TOBL : TOB;
    XX_WHERE : string;
    retour : string;
begin
TOBL := GETTOBEtude(TOBEtude,GS.Row);
if TOBl = nil then exit;
  if GS.col = GS_TYPE then
  begin
    if TOBL.GetValue('BDE_QUALIFNAT') = 'PRINC1' then XX_WHERE:='CO_TYPE="BTD"'
                                                 else XX_WHERE:='CO_TYPE="BTD" AND CO_CODE="001"';
    Result := LookupList (GS,'Type de document','COMMUN','CO_CODE','CO_LIBELLE',XX_WHERE,'CO_LIBELLE',false,-1);
    if (result) and (cellcur <> GS.cells[GS.col,GS.row]) then
    begin
      TOBL := GetTobEtude (TOBEtude,GS.row);
      if ( GS.Cells[GS.col,GS.row] <> '002') then
      begin
      	if not traitefichier (TOBL,GS.col,GS.row) then BEGIN GS.Cells[GS.col,GS.row] := '';exit; END;
      end;
      CellCur := GS.Cells[GS.col,GS.row];
      TOBL.putValue('BDE_TYPE',GS.Cells [GS.col,GS.row]);
      affichePied (GS.row);
      DefiniPopUpGS (GS.row);
    end;
  end else if (GS.col = GS_DATEDEP) or (GS.col = GS_DATEFIN) then
  begin
		ZoomOuChoixDateLiv(GS.Col, GS.Row);
  end else if (GS.col = GS_FOURNISSEUR ) then
  begin
    retour := AGLLanceFiche('BTP','BTMULAFFAIREINTER','BAI_AFFAIRE='+Affaire,'','');
    if retour <> '' then
    begin
    	TOBL.putvalue('BDE_FOURNISSEUR',UpperCase (retour));
      GS.cells[GS.col,GS.row] := UpperCase (retour);
      CellCur := GS.Cells[GS.col,GS.row];
      affichePied (GS.row);
    end;
  end;
end;

procedure TFEtudes.GSEnter(Sender: TObject);
var Acol,Arow : integer;
    Cancel,Chg : boolean;
begin
Arow := 1; Acol := 1;
cancel := false;chg := false;
GS.col := Acol; GS.row:= Arow;
GSRowEnter (self,Acol,Cancel,chg);
GSCellEnter (self,Acol,Arow,Cancel);
GS.row := Arow; GS.col := Acol;
end;

function TFEtudes.traiteFichier (TOBL : TOB;Acol,Arow : integer) : boolean;
var Repertoire,FIchier,FileOut : string;
begin
result := false;
if ( GS.Cells[Acol,Arow] = '001') then
   begin
   Dopen.Filter := 'fichier Excel (*xls;*xlsx)|*.xls;*.xlsx';
   Dopen.DefaultExt := 'xls';
   end;
if DOPen.Execute then
   begin
   // copie du fichier dans le repertoire commun
   FileOut := Dopen.Filename;
   while ExisteFichier (FileOut,TOBEtude) do
      begin
      PGIBoxAF ('Ce fichier existe déjà.#13#10Veuillez définir un autre nom de fichier',caption);
		  repertoire := RepertBase;
      if repertoire = '' then
         begin
         PGIBoxAF ('Veuillez définir le répertoire de stockage dans les paramètres sociétés','PARAM');
         exit;
         end;
      DSave.Filter := Dopen.filter;
      DSave.DefaultExt  := Dopen.DefaultExt ;
      if TiersClie <> '' then
      begin
      	DSave.InitialDir := repertoire+'\T'+TOBEtude.GetValue('AFF_TIERS');
      end else
      begin
      DSave.InitialDir := repertoire+'\'+TOBEtude.GetValue('AFF_AFFAIRE');
      end;
      if not DSave.execute then BEGIN exit;END;
      FileOut := Dsave.FileName;
      end;
   if TiersClie <> '' then
   begin
   	fichier := EnregistreFichier (RepertBase,'T'+TiersClie,DOpen.FileName,FileOut);
   end else
   begin
   fichier := EnregistreFichier (RepertBase,TobEtude.GetValue('AFF_AFFAIRE'),DOpen.FileName,FileOut);
   end;
   if fichier = '' then
      begin
      PGIBoxAF ('Problème lors de la récupération du fichier',caption);
      exit;
      end else BEGIN TOBL.Putvalue('BDE_NAME',Fichier); REsult := true; END;
   end;
end;

procedure TFEtudes.affichePied (Arow:Integer);
var TextMess : string;
    TOBL : TOB;
begin
TextMess := '';
TOBL := GetTobEtude (TOBEtude,Arow);
if TOBl <> nil then
   begin
   if TOBL.GetValue ('BDE_TYPE')='001' then TextMess := 'Fichier Excel : ' + TOBL.GetValue('BDE_NAME');
   end;
Etat.caption := TextMess;
LblErreur.Caption := '';
end;

procedure TFEtudes.BValiderClick(Sender: TObject);
var Acol,Arow : integer;
    cancel : boolean;
    iparterreur : integer;
begin

  Acol := GS.col;
  Arow := GS.row;
  Cancel := false;

  GSCellexit (self,Acol,Arow,cancel);

  if Traitement = TatAccept then
  begin
    if (TOBEtude.GetValue('AFFAIRE_INIT') <> 'X') and (TOBEtude.GetValue('NEW_AFFAIRE') = 'X') Then
    begin
      NewAffaire := '';
      // nouvelle affaire saisie entièrement
      NewAffaire :=DechargeCleAffaire(THEDIT(NAFF_AFFAIRE0),THEDIT(NAFF_AFFAIRE1), THEDIT(NAFF_AFFAIRE2),
                                   THEDIT(NAFF_AFFAIRE3),THEDIT(NAFF_AVENANT),AFF_TIERS.Text,
                                   taCreat,True,True,false,iPartErreur);

      if (iPartErreur <> 0 ) or (NewAffaire = '') then exit;

      If (NewAffaire<>'') Then
      Begin
        NAFF_AFFAIRE.Text := NewAffaire;
        ChargeCleAffaire (NAFF_AFFAIRE0,NAFF_AFFAIRE1,NAFF_AFFAIRE2,NAFF_AFFAIRE3,NAFF_AVENANT,
                          BRechAffaire,taconsult,NewAffaire,true);
        NAFF_AFFAIRE1.enabled := false;
        NAFF_AFFAIRE2.enabled := false;
        NAFF_AFFAIRE3.enabled := false;
        NAFF_AVENANT.enabled := false;
        // Stockage dans la TOBETUDE
        TOBEtude.Putvalue('AFF_AFFAIRE',NAFF_AFFAIRE.text);
        TOBEtude.Putvalue('AFF_AFFAIRE0',NAFF_AFFAIRE0.text);
        TOBEtude.Putvalue('AFF_AFFAIRE1',NAFF_AFFAIRE1.text);
        TOBEtude.Putvalue('AFF_AFFAIRE2',NAFF_AFFAIRE2.text);
        TOBEtude.Putvalue('AFF_AFFAIRE3',NAFF_AFFAIRE3.text);
        TOBEtude.Putvalue('AFF_AVENANT',NAFF_AVENANT.text);

      end else NewAffaire := AFF_AFFAIRE.text;

    end else
    begin
      NewAffaire :=DechargeCleAffaire(THEDIT(NAFF_AFFAIRE0),THEDIT(NAFF_AFFAIRE1), THEDIT(NAFF_AFFAIRE2),
                                      THEDIT(NAFF_AFFAIRE3),THEDIT(NAFF_AVENANT),AFF_TIERS.Text,
                                      taconsult,false,True,false,iPartErreur);
      // Stockage dans la TOBETUDE
      TOBEtude.Putvalue('AFF_AFFAIRE',NAFF_AFFAIRE.text);
      TOBEtude.Putvalue('AFF_AFFAIRE0',NAFF_AFFAIRE0.text);
      TOBEtude.Putvalue('AFF_AFFAIRE1',NAFF_AFFAIRE1.text);
      TOBEtude.Putvalue('AFF_AFFAIRE2',NAFF_AFFAIRE2.text);
      TOBEtude.Putvalue('AFF_AFFAIRE3',NAFF_AFFAIRE3.text);
      TOBEtude.Putvalue('AFF_AVENANT',NAFF_AVENANT.text);
    end;

    TOBEtude.Putvalue('NAFF_AFFAIRE',NAFF_AFFAIRE.text);
    TOBEtude.Putvalue('NAFF_AFFAIRE0',NAFF_AFFAIRE0.text);
    TOBEtude.Putvalue('NAFF_AFFAIRE1',NAFF_AFFAIRE1.text);
    TOBEtude.Putvalue('NAFF_AFFAIRE2',NAFF_AFFAIRE2.text);
    TOBEtude.Putvalue('NAFF_AFFAIRE3',NAFF_AFFAIRE3.text);
    TOBEtude.Putvalue('NAFF_AVENANT',NAFF_AVENANT.text);

    if AFF_GENERAUTO.Text = '' then
    begin
      AFF_GENERAUTO.SetFocus;
      PGIBoxAF ('Vous devez renseigner un mode de facturation',caption);
      exit;
    end;

    if REGROUPFACTBIS.Text = '' then
    begin
      REGROUPFACTBIS.SetFocus;
      PGIBoxAF ('Vous devez renseigner un mode de regroupement',caption);
      exit;
    end;
  end;

  NettoyageEtudeVide;

  if TRANSACTIONS (MajTobs,0) = oeok then
  BEGIN
    ValidateOk := true;
    close;
  END
  ELSE
    PGIBoxAF ('Erreur pendant la sauvegarde des données',caption);

end;

procedure TFEtudes.UpdateAncienneStructure;
var sql : string;
		result,Indice : integer;
begin
  Sql := 'UPDATE AFFAIRE SET AFF_ETATAFFAIRE="ACP",AFF_DATESIGNE="'+UsDateTime(V_PGI.DateEntree)+'" WHERE AFF_AFFAIRE="'+TOBEtude.getValue('OLD_AFFAIRE')+'"';
  result := executeSql (Sql);
  if result < 0 then
  begin
    V_PGI.IoError:=oeunknown ;
    exit;
  end;
  for Indice := 0 to TOBetude.detail.count -1 do
  begin
  	if not TOBEtude.detail[Indice].UpdateDB(true) then
    begin
      V_PGI.IoError:=oeunknown ;
      exit;
    end;
  end;
end;

procedure TFEtudes.detruitAncienneStructure;
var result : integer;
		Sql : string;
begin
  //Sql := 'DELETE FROM BDETETUDE WHERE BDE_AFFAIRE="'+TOBEtude.getValue('AFF_AFFAIRE')+'" AND BDE_NATUREAUXI="CLI" AND BDE_CLIENT="'+TOBEtude.GetValue('AFF_TIERS')+'"';
  Sql := 'DELETE FROM BDETETUDE WHERE BDE_AFFAIRE="'+TOBEtude.getValue('AFF_AFFAIRE')+'" AND BDE_NATUREAUXI="CLI" AND BDE_CLIENT="'+TOBEtude.GetValue('AFF_TIERS')+'"';
  result := executeSql (Sql);
  if result < 0 then
  begin
    V_PGI.IoError:=oeunknown ;
    Exit ;
  end;
  if Traitement = TatAccept then exit;
  if not TOBSTRDOC_O.DeleteDB (true) then
  begin
    V_PGI.IoError:=oeunknown ;
    Exit ;
  end;
end;

procedure TFEtudes.EcritTobEtude;

	procedure  AffecteNewAffaire(TOBAFFinterv, TOBFRS : TOB; Affaire : string);
  var Indice : Integer;
  begin
    for Indice := 0 to TOBAFFinterv.detail.count -1 do
    begin
      TOBAFFinterv.detail[Indice].PutValue('BAI_AFFAIRE',Affaire);
    end;
    for Indice := 0 to TOBFRS.detail.count -1 do
    begin
      TOBFRS.detail[Indice].PutValue('BAF_AFFAIRE',Affaire);
    end;
  end;

var TOBAFF : TOB;
		TOBAFFinterv,TOBFRS : TOB;
    QQ : TQuery;
begin
	TOBEtude.SetAllModifie (true);
  if traitement <> TatAccept then
  begin
  	if not TOBEtude.InsertDBByNivel  (true) then
    begin
      V_PGI.IoError:=oeunknown ;
      Exit ;
    end;
  end else
  begin
    TOBAFFinterv := TOB.Create ('LES INTERVENANTS',nil,-1);
    TOBFRS := TOB.Create ('LES FRAIS',nil,-1);
    TRY
      if ExisteSql ('SELECT BAI_AFFAIRE FROM AFFAIREINTERV WHERE BAI_AFFAIRE="'+ TOBEtude.getValue('OLD_AFFAIRE')+'"') then
      begin
        QQ := OpenSQL('SELECT * FROM AFFAIREINTERV WHERE BAI_AFFAIRE="'+TOBEtude.getValue('OLD_AFFAIRE')+'"',True,-1,'',true);
        TOBAFFinterv.LoadDetailDB('AFFAIREINTERV','','',QQ,false);
        Ferme(QQ);
        QQ := OpenSQL('SELECT * FROM AFFAIREFRSGEST WHERE BAF_AFFAIRE="'+TOBEtude.getValue('OLD_AFFAIRE')+'"',True,-1,'',true);
        TOBFRS.LoadDetailDB('AFFAIREFRSGEST','','',QQ,false);
        Ferme(QQ);
        AffecteNewAffaire(TOBAFFinterv, TOBFRS,TOBEtude.getValue('AFF_AFFAIRE'));
      end;
      // Acceptation d'affaire
      if TOBEtude.getValue('AFF_AFFAIRE') <> TOBEtude.getValue('OLD_AFFAIRE') then
      begin
        if not ExisteSql ('SELECT AFF_AFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBEtude.getValue('AFF_AFFAIRE')+'"') then
        begin
          TOBAFF := TOB.Create ('AFFAIRE',nil,-1);
          TRY
            TOBAFF.dupliquer(TOBEtude,false,true);
            TOBAFF.PutValue('AFF_STATUTAFFAIRE','AFF');
            TOBAFF.PutValue('AFF_AFFAIREREF',TOBAFF.getValue('AFF_AFFAIRE'));
            TOBAFF.PutValue('AFF_REGROUPEFACT',TOBEtude.GetValue('REGROUPFACTBIS'));
            TOBAFF.PutValue('AFF_GENERAUTO',TOBEtude.GetValue('AFF_GENERAUTO'));
            TOBAFF.PutValue('AFF_ETATAFFAIRE', 'ENC');
            TOBAFF.PutValue('AFF_DATESIGNE', V_PGI.DateEntree);

            TOBAFF.SetAllModifie(true);
            if not TOBAFF.InsertDB(nil,true) then
            begin
              V_PGI.IoError:=oeunknown ;
              Exit ;
            end;
            if TOBAFFinterv.Detail.Count > 0 then
            begin
              if not TOBAFFinterv.InsertDB(nil,true) then
              begin
                V_PGI.IoError:=oeunknown ;
                Exit ;
              end;
            end;
            if TOBFRS.Detail.Count > 0 then
            begin
              if not TOBFRS.InsertDB(nil,true) then
              begin
                V_PGI.IoError:=oeunknown ;
                Exit ;
              end;
            end;
          FINALLY
            TOBAFF.free;
          end;
        end;
      end;
    FINALLY
      TOBAFFinterv.free;
      TOBFRS.Free;
    end;
  end;
  if Traitement = TatAccept then exit;
  TOBStrDoc.SetAllModifie (true);
  TOBStrDoc.InsertDB (nil,true);
end;

procedure TFEtudes.EcritDocumentsViaEtude;
begin
//
end;

procedure TFEtudes.MajTobs;
begin
  InitMove(TOBEtude.detail.count,'') ;
  if Traitement <> TatAccept then
  begin
    detruitAncienneStructure;
  end else
  begin
    UpdateAncienneStructure;
    if (V_PGI.IOError=OeOk) then
    begin
    end;
  end;
  if (V_PGI.IOError=OeOk) and (traitement <> TatAccept) then FaireMenagePiece (TOBEtude_O,TOBEtude,TOBAnnul);
  if V_PGI.IOError=OeOk then
  BEGIN
     EcritTobEtude;
     if V_PGI.Ioerror = OeOk then
     begin
     	 EcritDocumentsViaEtude;
     end;
     IF V_PGI.IoError <> OeOk then PGIBoxAF ('Erreur dans la mise à jour',caption);
  END else PGIBoxAF ('Erreur dans la mise à jour',caption);
  FiniMove ;
end;


procedure TFEtudes.DefiniPopUpGS(Arow: integer);
var TOBL,TOBS : TOB;
    StructCreated : boolean;
begin
  GS.PopupMenu := nil;
  Binfos.DropdownMenu := nil;
  if Traitement = TatAccept then exit;
  TOBL := GetTobEtude (TOBEtude,Arow);
  if TOBl = nil then exit;
  if TOBL.GetValue ('BDE_TYPE')='001' then
  begin
    // defaut
    if Action = TaConsult then
    begin
       DefStructXls.visible := false;
    end;
    RenVoieBordereauXls.visible := false;
    RecupDonneeXls.visible := false;
    EntreeValDoc.visible := false;
    RenvoieDonneeXls.Visible := false;
    SelectDocE.visible := false;
    EnvoiLotCotraitance.visible := false;
    N1C.visible := false;
    N2C.visible := false;
    // Document Excel Rattaché
    GS.PopupMenu := PopExcel;
    Binfos.DropdownMenu := PopExcel;
    TOBS := findstructure (TOBL,StructCreated);
    if (TOBL.GetValue('BDE_QUALIFNAT')='PRINC1') then
    begin // Bordereau de prix
      if (TOBS <> nil) and (Action <> TaConsult) and (Traitement <> tatBordereaux) then
      begin
        RenVoieBordereauXls.visible := true;
      end;
      if (TOBS <> nil) and (Action <> TaConsult) and (Traitement = tatBordereaux) then
      begin
        RecupDonneeXls.caption := TraduireMemoire('Récupération du bordereau de prix');
        RecupDonneeXls.visible := True;
        if (TOBL.GetValue('BDE_PIECEASSOCIEE') <> '')  then
        begin
          EntreeValDoc.Caption := TraduireMemoire('Définition des travaux et produits');
          EntreeValDoc.visible := true;
        end;
      end;
    end else
    begin // autre type : etude principale ou secondaire
      if (TOBS <> nil) and (Action <> taConsult) then RecupDonneeXls.visible := true;
      if (TOBEtude.getvalue('AFF_MANDATAIRE')='X') then
//      if (TOBL.getValue('BDE_FOURNISSEUR')<>'') then
      begin
        EnvoiLotCotraitance.visible := true;
        N1C.visible := true;
        N2C.visible := true;
      end;
      if (TOBL.GetValue('BDE_PIECEASSOCIEE') <> '')  then
      begin
        EntreeValDoc.visible := true;
        if (Action <> TaConsult) then
        begin
          RenvoieDonneeXls.Visible := true;
          SelectDocE.visible := true;
        end;
      end;
    end;
    if StructCreated then TOBS.free;
  end else
  if TOBL.GetValue ('BDE_TYPE')='002' then
  begin
    EditionDocPGI.Visible := false;
    SelectDocP.Visible := false;
    // Document PGI rattache
    GS.PopupMenu := PopDocPgi;
    Binfos.DropdownMenu := PopDocPgi;
    if (TOBL.GetValue('BDE_PIECEASSOCIEE') <> '') then
    begin
       EditionDocPGI.Visible := True;
       Modificationdudocument1.visible := true;
       if (Traitement = tatBordereaux)  then Modificationdudocument1.Caption := TraduireMemoire('Définition des travaux et produits');
       if (Action <> TaConsult) and (TraiteMent <> TatBordereaux ) then SelectDocP.Visible := true;
    end;
  end;
end;

procedure TFEtudes.SelectDocEClick(Sender: TObject);
begin
Selectionne (GS.row);
end;

procedure TFEtudes.Selectionne (Arow : integer);
Var Index,Ordre : Integer;
    Nature : string;
    TOBL,TOBS : TOB;
    selectionne : boolean;
begin
  TOBL := GetTobEtude (TOBEtude,Arow);

  if TOBL = nil then exit;

  if TOBL.GetValue('BDE_QUALIFNAT') = 'PRINC1' then exit;

  if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then
  begin
    LblErreur.caption := 'Aucune pièce associée à cet appel d''offre !';
    exit;
  end;

  selectionne := (TOBL.GetValue('BDE_SELECTIONNE')='X');
  Ordre := TOBL.GetValue('BDE_ORDRE');
  if TOBL.GetValue('BDE_QUALIFNAT') <> 'PRINC' then
  begin
    Nature := TOBL.GetValue('BDE_NATUREDOC');
    for Index := 0 to TOBEtude.detail.count -1 do
    begin
      TOBS := TOBEtude.detail[Index];
      if TOBS.GetValue('BDE_ORDRE') > ordre then break;
      if (TOBS.GetValue('BDE_ORDRE')=ordre) and (TOBS.GetValue('BDE_NATUREDOC')=nature) then
        begin
        TOBS.PutValue('BDE_SELECTIONNE','-');
        AfficheLaLigne (GS,TOBEtude,lescolonnes,Index+1);
        end;
    end;
   if not selectionne then TOBL.Putvalue('BDE_SELECTIONNE','X')
                      else TOBL.Putvalue('BDE_SELECTIONNE','-');
   AfficheLaLigne (GS,TOBEtude,lescolonnes,Arow);
  end
  else
  begin
    if not selectionne then
    begin
      TOBL.Putvalue('BDE_SELECTIONNE','X');
      AfficheLaLigne (GS,TOBEtude,lescolonnes,Arow);
    end
    else
    begin
      For Index := Arow to TOBEtude.detail.count  do
          begin
          TOBS := GetTobEtude (TOBEtude,Index);
          if TOBS.GetValue('BDE_ORDRE') > ordre then break;
          TOBS.Putvalue('BDE_SELECTIONNE','-');
          end;
      AfficheLagrille (GS,TOBEtude,Lescolonnes,1);
      end;
   end;
RaffraichiTreeview;
end;

procedure TFEtudes.SelectDocPClick(Sender: TObject);
begin
Selectionne (GS.row);
end;

procedure TFEtudes.ModifXlsClick(Sender: TObject);
var
   //si: TStartupInfo;
   //pi:  TProcessInformation;
   FileName,RepertSource : string;
   TOBL : TOB;
begin
(* RepertSource := GetParamSoc('SO_BTREPAPPOFF'); *)
RepertSource := RepertBase;
if not OfficeExcelDispo then
   begin
   PGIBoxAF ('Office n''est pas installé sur ce poste',caption);
   exit;
   end;
TOBL := GetTobEtude (TOBEtude,GS.Row);
if TOBL = nil then exit;
filename := TOBL.GetValue('BDE_NAME');
if FileName='' then exit;

if Traitement <> tatBordereaux then AddVbModuleFromFile('c:\PGI00\STD\', 'EtudePgi.xla');
//Modif FV : Version 5 - Version 7
//AddVbModuleFromFile ('c:\PGI00\STD\','EtudePgi.xla');

(*
if not lanceAppliWindows (si,pi,GetExcelPath+'EXCEL.exe "'+filename+'"') then
   PgiBoxAf ('Erreur de lancement excel',caption);
*)
    FileExecAndWait (GetExcelPath + 'EXCEL.exe "' + filename + '"');

// COrrection LS le 17/07/03
if Traitement <> tatBordereaux then DelVBModule ('EtudePgi.xla');
// --
end;

procedure TFEtudes.VerifExistencePiece (TOBL : TOB);
begin
  if ((TOBL.GetValue('BDE_PIECEASSOCIEE') <> '') and
  		(TOBL.GetValue('BDE_QUALIFNAT') <> 'PRINC1') and
      (Traitement <> TatBordereaux)) OR
  	 ((TOBL.GetValue('BDE_PIECEASSOCIEE') <> '') and
     	(TOBL.GetValue('BDE_QUALIFNAT') = 'PRINC1') and
      (Traitement = TatBordereaux)) then
  begin
    if PGIAsk ('Une pièce à déjà été créé à partir de la description#13#10Voulez-vous la supprimer ?',caption) = mrYes then
    begin
      // supression logique de la pièce
      AjouteAnnulation (TOBL);
      TOBL.putValue('BDE_PIECEASSOCIEE','');
      TOBL.PutValue('BDE_NATUREPIECEG','');
      TOBL.PutValue('BDE_SOUCHE','');
      TOBL.PutValue('BDE_NUMERO',0);
      TOBL.PutValue('BDE_INDICEG',0);
    end;
  end;
end;

procedure TFEtudes.DefStructXlsClick(Sender: TObject);
var TOBL,TOBS : TOB;
    find : boolean;
begin
//
TOBL := GetTobEtude (TOBEtude,GS.Row);
if TOBL = nil then exit;
  VerifExistencePiece (TOBL);
TOBS := TOBStrDOc.FinDFirst (['BSD_ORDRE','BSD_TYPE','BSD_NATUREDOC','BSD_INDICE'],
                             [TOBL.GetValue('BDE_ORDRE'),TOBL.GetValue('BDE_TYPE'),TOBL.GetValue('BDE_NATUREDOC'),
                             TOBL.GetValue('BDE_INDICE')],true);
if TOBS <> nil then Find := true
               else Find := false;
DefinitionStructXls(TOBEtude,TOBS,GS.row,Action);
if (TOBS <> nil) and (not find) then TOBS.ChangeParent (TOBStrDoc,-1);
DefiniPopUpGS (GS.row);
end;

procedure TFEtudes.supprimeLaDescript (TOBL : TOB);
var TOBS : TOB;
begin
TOBS := TOBStrDOc.FinDFirst (['BSD_ORDRE','BSD_TYPE','BSD_NATUREDOC','BSD_INDICE'],
                             [TOBL.GetValue('BDE_ORDRE'),TOBL.GetValue('BDE_TYPE'),TOBL.GetValue('BDE_NATUREDOC'),
                             TOBL.GetValue('BDE_INDICE')],true);
if TOBS <> nil then TOBS.free;
end;


function TFEtudes.findstructure (TOBL : TOB; var Commune : boolean): TOB;
var TOBS : TOB;
    Req : String;
    QQ : TQuery;
begin
commune := false;
result := TOBStrDOc.FinDFirst (['BSD_ORDRE','BSD_TYPE','BSD_NATUREDOC','BSD_INDICE'],
                             [TOBL.GetValue('BDE_ORDRE'),TOBL.GetValue('BDE_TYPE'),TOBL.GetValue('BDE_NATUREDOC'),
                             TOBL.GetValue('BDE_INDICE')],true);
if result = nil then
   BEGIn
   Req := 'SELECT * FROM BSTRDOC WHERE BSD_TIERS="'+TOBEtude.getvalue('AFF_TIERS')+'" AND ';
   REq := REq + 'BSD_TYPE="'+TOBL.getValue('BDE_TYPE')+'" AND ';
   REq := REq + 'BSD_NATUREDOC="'+TOBL.getValue('BDE_NATUREDOC')+'"';
   QQ := Opensql (req,true,-1, '', True);
   if not QQ.eof then
      BEGIN
      commune := true;
      TobS := TOB.Create ('BSTRDOC',nil,-1);
      TOBS.SelectDB ('',QQ);
      result := TOBS;
      END;
   ferme (QQ);
   end;
end;

procedure TFEtudes.PositionneBordereau (TobRef : TOB);
var TOBL : TOB;
		//CLEDOC : R_Cledoc;
begin
TOBL := TOBEtude.findfirst (['BDE_ORDRE','BDE_QUALIFNAT'],[TOBRef.GetValue('BDE_ORDRE'),'PRINC1'],true);
while TOBL <> nil do
      begin
      TOBL.PuTvalue('BDE_PIECEASSOCIEE',TOBRef.GetValue('BDE_PIECEASSOCIEE'));
      TOBL.PutValue('BDE_NATUREPIECEG',TOBRef.GetValue('BDE_NATUREPIECEG'));
      TOBL.PutValue('BDE_SOUCHE',TOBRef.GetValue('BDE_SOUCHE'));
      TOBL.PutValue('BDE_NUMERO',TOBRef.GetValue('BDE_NUMERO'));
      TOBL.PutValue('BDE_INDICEG',TOBRef.GetValue('BDE_INDICEG'));
      TOBL := TOBEtude.findnext(['BDE_ORDRE','BDE_QUALIFNAT'],[TOBRef.GetValue('BDE_ORDRE'),'PRINC1'],true);
      end;
end;

procedure TFEtudes.RecupDonneeXlsClick(Sender: TObject);
var PieceEtude : TPieceEtude;
    CleDoc : R_CleDoc;
    TOBl,TOBS : TOB;
    StructCreated : boolean;
    splash : TFsplashScreen;
begin
Splash:=Nil;

TOBL := TOBEtude.detail[Gs.row-1];
TOBS := findstructure (TOBL,StructCreated);

if TOBS = nil then BEGIN PGIBoxAf ('Vous devez d''abord définir la structure du fichier',caption); exit; END;

if TOBL.GetValue('BDE_PIECEASSOCIEE') <> '' then
   begin
   if PGIAsk (TraduireMemoire ('Ce traitement a déjà été effectué#13#10Désirez-vous réellement récupérer les données'),caption) <> mryes then
      begin
      if StructCreated then TOBS.free;
      exit;
      end;
   end;
if IsExcelLaunched then BEGIN PGIBox ('Vous devez fermer préalablement les instances d''EXCEL',caption);Exit;END;
PieceEtude := TPieceEtude.Create;
TRY
Valide97.Enabled := false;
Outils97.Enabled := false;
splash := TFsplashScreen.Create (GS.Parent);
splash.Label1.Caption := 'Récupération du fichier excel en cours...';
splash.Show;
splash.Refresh;
if TOBL.GetString('BDE_NAME') <> '' then
   begin
   TRY
   if TOBL.GetString('BDE_PIECEASSOCIEE') = '' then
      begin
      FillChar(CleDoc,Sizeof(CleDoc),#0) ;
      if Traitement <> TatBordereaux then CleDoc.NaturePiece:=VH_GC.AFNatProposition
                                     else Cledoc.Naturepiece := GetParamSoc ('SO_BTNATBORDEREAUX');

      CleDoc.DatePiece:=V_PGI.DateEntree;
      pieceEtude.NewDoc (cledoc,TOBEtude.GetValue('AFF_TIERS'),TOBEtude.GetValue('AFF_AFFAIRE'),TOBEtude.GetValue('AFF_ETABLISSEMENT'),'',true,false);
      //FV1 : ajout contrôle nature travaux et fournisseur
      PieceEtude.Fournisseur := TOBL.GetString('BDE_FOURNISSEUR');
      PieceEtude.NatureTravail := '001';
      if cledoc.NumeroPiece <> 0 then
         BEGIN
         TOBL.putValue('BDE_PIECEASSOCIEE',CodeLaPiece(cledoc));
         TOBL.PutValue('BDE_NATUREPIECEG',Cledoc.NaturePiece);
         TOBL.PutValue('BDE_SOUCHE',Cledoc.Souche);
         TOBL.PutValue('BDE_NUMERO',Cledoc.NumeroPiece);
         TOBL.PutValue('BDE_INDICEG',Cledoc.Indice);
         if TOBL.GetValue('BDE_QUALIFNAT') = 'PRINC' then PositionneBordereau (TOBL);
         END ELSE PGIBoxAf ('Erreur de création document Interne',caption);
      end;

   DeCodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),Cledoc);
   if (ExistePiece (cledoc)) then
      begin
      PieceEtude.CleDoc := CleDoc;
      end;
   PieceEtude.NomFicXls := TOBL.GetValue('BDE_NAME');
   PieceEtude.DefiniStructureXls (TOBS.GetValue('BSD_DESCRIPT'));
   if Traitement = TatBordereaux then PieceEtude.Bordereau := true;
   PieceEtude.VersPgi;
   FINALLY
   PieceEtude.Free;
   if StructCreated then TOBS.free;
   END;
   end else
   begin
   PGIBOX('Vous devez rattacher un document',caption);
   end;
FINALLY
splash.free;
Valide97.Enabled := true;
Outils97.Enabled := true;
END;
DefiniPopUpGS (GS.row);
end;

procedure TFEtudes.RenvoieDonneeXlsClick(Sender: TObject);
var PieceEtude : TPieceEtude;
    CleDoc : R_CleDoc;
    TOBl,TOBS : TOB;
    StructCreated : boolean;
    splash : TFsplashScreen;
begin
if IsExcelLaunched then BEGIN PGIBox ('Vous devez fermer préalablement les instances d''EXCEL',caption);Exit;END;
TOBL := TOBEtude.detail[Gs.row-1];
if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then
   begin
   PGIBoxAf ('Vous n''avez pas saisi les valorisations',caption);
   exit;
   end;
TOBS := findstructure (TOBL,StructCreated);
if TOBS = nil then BEGIN PGIBoxAf ('Vous devez d''abord définir la structure du fichier',caption); exit; END;
if TOBL.GetValue('BDE_NAME') <> '' then
   begin
   Valide97.Enabled := false;
   Outils97.Enabled := false;
   splash := TFsplashScreen.Create (GS.Parent);
   splash.Label1.Caption := 'Renvoi des données vers le fichier Excel';
   splash.Show;
   splash.Refresh;
   PieceEtude := TPieceEtude.Create;
   TRY
      DeCodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),Cledoc);
      PieceEtude.CleDoc := CleDoc;
      PieceEtude.NomFicXls := TOBL.GetValue('BDE_NAME');
      PieceEtude.DefiniStructureXls (TOBS.GetValue('BSD_DESCRIPT'));
      PieceEtude.VersExcel;
   FINALLY
      splash.free;
      PieceEtude.Free;
      Valide97.Enabled := true;
      Outils97.Enabled := true;
   END;
   end else
   begin
   PGIBOXAF ('Vous devez rattacher un document',caption);
   end;
if StructCreated then TOBS.free;
end;

procedure TFEtudes.EntreeValDocClick(Sender: TObject);
var Cledoc : R_Cledoc;
    TOBL : TOB;
    saisieMode : TActionFiche;
begin
TOBL := TOBEtude.detail[Gs.row-1];
if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then exit;
DecodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),CleDoc);
if (not ExistePiece (cledoc)) then
   begin
   TOBL.PutValue('BDE_PIECEASSOCIEE', '');
   exit;
   end;
if Action = taconsult then SaisieMode := Action else SaisieMode := taModif;
SaisiePiece (Cledoc,SaisieMode,'','','',false,(TOBL.GetValue('BDE_NAME')<>''),false,false,(Traitement = TatBordereaux));
end;

procedure TFEtudes.Modificationdudocument1Click(Sender: TObject);
var PieceEtude : TPieceEtude;
    CleDoc : R_CleDoc;
    TOBl : TOB;
    SaisieMode : TActionFiche;
begin
PieceEtude:=Nil;
TOBL := TOBEtude.detail[Gs.row-1];
if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then
   begin
   TRY
   PieceEtude := TPieceEtude.Create;
   FillChar(CleDoc,Sizeof(CleDoc),#0) ;
   if Traitement <> TatBordereaux then CleDoc.NaturePiece:=VH_GC.AFNatProposition
   																else Cledoc.Naturepiece := GetParamSoc ('SO_BTNATBORDEREAUX');
   CleDoc.DatePiece:= StrToDate(Datetostr(TOBL.GetValue('BDE_DATEDEPART')));
   pieceEtude.NewDoc (cledoc,TOBEtude.GetValue('AFF_TIERS'),TOBEtude.GetValue('AFF_AFFAIRE'),TOBEtude.GetValue('AFF_ETABLISSEMENT'),'',true,false);
   if cledoc.NumeroPiece <> 0 then
      BEGIN
      TOBL.putValue('BDE_PIECEASSOCIEE',CodeLaPiece(cledoc));
      TOBL.PutValue('BDE_NATUREPIECEG',Cledoc.NaturePiece);
      TOBL.PutValue('BDE_SOUCHE',Cledoc.Souche);
      TOBL.PutValue('BDE_NUMERO',Cledoc.NumeroPiece);
      TOBL.PutValue('BDE_INDICEG',Cledoc.Indice);
      END ELSE PGIBoxAf ('Erreur de création document Interne',caption);
   FINALLY
      PieceEtude.Free;
   END;
   end else DecodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),CleDoc);
if cledoc.NumeroPiece <> 0 then
   begin
   if Action = taconsult then SaisieMode := Action else SaisieMode := taModif;
   SaisiePiece (Cledoc,SaisieMode,'','','',false,false,false,false,(Traitement=TatBordereaux));
   end;
DefiniPopUpGS (GS.row);
end;

procedure TFEtudes.BArborescenceClick(Sender: TObject);
begin
if BArborescence.Down then WinTV.Visible := true
                      else WinTV.Visible := false;
end;

procedure TFEtudes.WinTVClose(Sender: TObject);
begin
BArborescence.Down := false;
end;

procedure TFEtudes.PositionneLigne (Arow:integer;Acol : integer=-1);
var GRow,GCol : integer;
    Cancel : boolean;
    Synchro : boolean;
begin
Synchro := GS.synenabled;
GS.synEnabled := false;
Grow := Arow;
if Acol <> -1 then GCol := Acol else Gcol := GS.Fixedcols ;
GS.col := Gcol;
GS.row:= Grow;
cancel := false;
GS.CacheEdit;
GSRowenter (Self,Grow,cancel,false);
GSCellenter (Self,Gcol,Grow,Cancel);
GS.col := Gcol;
GS.row:= Grow;
CellCur := GS.cells[Gcol,Grow];
GS.SynEnabled := Synchro;
GS.MontreEdit;
end;

procedure TFEtudes.TVClick(Sender: TObject);
var Tn : TTreeNode ;
    TOBL,TOBF : TOB;
    Indice,Result : integer;
begin
tn := TV.Selected;
TOBL := tn.data;
if TOBL <> nil then
   begin
   result := -1;
   for Indice := 0 to TOBEtude.detail.count -1 do
       begin
       TOBF := TOBEtude.detail[indice];
       if (TOBF.GetValue('BDE_ORDRE') = TOBL.GetValue('BDE_ORDRE')) and
          (TOBF.GetValue('BDE_NATUREDOC') = TOBL.GetValue('BDE_NATUREDOC')) and
          (TOBF.GetValue('BDE_INDICE') = TOBL.GetValue('BDE_INDICE')) then
           begin
           result := Indice +1;
           break;
           end;
       end;
   if Result <> -1 then
      begin
      PositionneLigne (result);
      end;
   end;
end;

procedure TFEtudes.RenVoieBordereauXlsClick(Sender: TObject);
var PieceEtude : TPieceEtude;
    CleDoc : R_CleDoc;
    TOBL,TOBS : TOB;
    StructCreated : boolean;
    splash : TFsplashScreen;
begin
Splash:=Nil;
if IsExcelLaunched then BEGIN PGIBox ('Vous devez fermer préalablement les instances d''EXCEL',caption);Exit;END;
TOBL := TOBEtude.detail[Gs.row-1];
TOBS := findstructure (TOBL,StructCreated);
if TOBS = nil then BEGIN PGIBoxAf ('Vous devez d''abord définir la structure du fichier',caption); exit; END;
if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then
   begin
   PGIBoxAf ('Vous devez définir les valorisations',caption);
   exit;
   end;
if TOBL.GetValue('BDE_NAME') <> '' then
   begin
   PieceEtude := TPieceEtude.Create;
   TRY
      Valide97.Enabled := false;
      Outils97.Enabled := false;
      splash := TFsplashScreen.Create (GS.Parent);
      splash.Label1.Caption := 'Traitement du fichier excel en cours...';
      splash.Show;
      splash.Refresh;
      DeCodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),Cledoc);
      PieceEtude.CleDoc := CleDoc;
      PieceEtude.NomFicXls := TOBL.GetValue('BDE_NAME');
      PieceEtude.DefiniStructureXls (TOBS.GetValue('BSD_DESCRIPT'));
      PieceEtude.VersBordereau;
   FINALLY
      PieceEtude.Free;
      Splash.free;
      Valide97.Enabled := true;
      Outils97.Enabled := true;
   END;
   end else
   begin
   PGIBOXAF ('Vous devez rattacher un document',caption);
   end;
if StructCreated then TOBS.free;

end;

procedure TFEtudes.EditionXlsClick(Sender: TObject);
var PieceEtude : TPieceEtude;
    TOBL : TOB;
    splash : TFsplashScreen;
begin

  Splash :=nil;

  TOBL := TOBEtude.detail[Gs.row-1];
  if TOBL.GetValue('BDE_NAME') <> '' then
  begin
    PieceEtude := TPieceEtude.Create;
    TRY
      splash := TFsplashScreen.Create (GS.Parent);
      splash.Label1.Caption := 'Edition du classeur Excel en cours...';
      splash.Show;
      splash.Refresh;
      PieceEtude.NomFicXls := TOBL.GetValue('BDE_NAME');
      PieceEtude.printXls;
    FINALLY
      PieceEtude.Free;
      Splash.free;
    END;
  end else
  begin
    PGIBOXAF ('Vous devez rattacher un document',caption);
  end;
end;

procedure TFEtudes.EditionDocPGIClick(Sender: TObject);
var PieceEtude : TPieceEtude;
    CleDoc : R_CleDoc;
    TOBL : TOB;
    splash : TFsplashScreen;
begin
  Splash:=Nil;
  TOBL := TOBEtude.detail[Gs.row-1];
  if TOBL.GetValue('BDE_PIECEASSOCIEE') <> '' then
  begin
    PieceEtude := TPieceEtude.Create;
    TRY
      splash := TFsplashScreen.Create (GS.Parent);
      splash.Label1.Caption := 'Edition du document PGI en cours...';
      splash.Show;
      splash.Refresh;
      DeCodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),Cledoc);
      PieceEtude.CleDoc := CleDoc;
      PieceEtude.printPGI;
    FINALLY
      PieceEtude.Free;
      Splash.free;
    END;
  end else
  begin
    PGIBOXAF ('Vous devez rattacher un document',caption);
  end;
end;

procedure TFEtudes.AjouteAnnulation (TOBEtudeL : TOB);
var TOBL : TOB;
begin
  TOBL := TOB.Create ('BDETETUDE',TOBAnnul,-1);
  TOBL.Dupliquer (TOBEtudeL,true,true);
end;

procedure TFEtudes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Traitement = TatAccept then exit;
  if (not (Action = taCOnsult)) And (not ValidateOk) and ((TOBetude.IsOneModifie (true)) or (Modifie)) then
  begin
    if PGIAsk ('Etes-vous sur de vouloir annuler les modifications ?',caption) <> mryes then
    begin
      canclose := false;
    end;
  end;
end;

procedure TFEtudes.GSDblClick(Sender: TObject);
begin
  if Action = taconsult then exit;
  Selectionne (GS.row);
end;

procedure TFEtudes.REGROUPFACTBISChange(Sender: TObject);
begin
  TOBEtude.putvalue('REGROUPFACTBIS',REGROUPFACTBIS.Value  );
end;

procedure TFEtudes.AFF_GENERAUTOChange(Sender: TObject);
begin
  TOBEtude.putvalue('AFF_GENERAUTO',AFF_GENERAUTO.Value  );
end;

procedure TFEtudes.BRechAffaireClick(Sender: TObject);
begin
  NAFF_AFFAIRE.text := '';
  GetAffaireEntete(NAFF_AFFAIRE, NAFF_Affaire1, NAFF_Affaire2, NAFF_Affaire3, NAFF_AVENANT, AFF_TIERS, false, false, false, false, true,'FAC');
  if AFF_AFFAIRE.Text <> '' then
  begin
    TOBETUDE.putvalue('NEW_AFFAIRE','-');
    affaire := NAFF_AFFAIRE.text;
    ChargeCleAffaire (NAFF_AFFAIRE0,NAFF_AFFAIRE1,NAFF_AFFAIRE2,NAFF_AFFAIRE3,NAFF_AVENANT,BRechAffaire,taconsult,Affaire,true);
    NAFF_AFFAIRE1.enabled := false;
    NAFF_AFFAIRE2.enabled := false;
    NAFF_AFFAIRE3.enabled := false;
    NAFF_AVENANT.enabled := false;
    brechaffaire.Visible := false;
  end;
end;

procedure TFEtudes.bnewaffClick(Sender: TObject);
begin
  affaire := 'A';
  TOBETUDE.putvalue('NEW_AFFAIRE','X');
  TOBETUDE.putvalue('AFFAIRE_INIT','-');
  NAFF_AFFAIRE0.Text := 'A';
  NAFF_AFFAIRE1.enabled := true;
  NAFF_AFFAIRE2.enabled := true;
  NAFF_AFFAIRE3.enabled := true;
  NAFF_AVENANT.enabled := true;
  brechaffaire.Visible := true;
  brechaffaire.enabled := true;
  ChargeCleAffaire (NAFF_AFFAIRE0,NAFF_AFFAIRE1,NAFF_AFFAIRE2,NAFF_AFFAIRE3,NAFF_AVENANT,BRechAffaire,taCreat,Affaire,true);
  if NAFF_AFFAIRE0.Text <> 'A' then NAFF_AFFAIRE0.Text := 'A';
end;

procedure TFEtudes.SetTraitement(const Value: TActionTrait);
begin
	Traitement := Value;
  if Traitement = TatBordereaux then
  begin
  	repertBase := GetParamSoc('SO_BTREPBORDPRIX');
  end else
  begin
  	repertBase := GetParamSoc('SO_BTREPAPPOFF');
  end;
end;


procedure TFEtudes.ZoomOuChoixDateLiv(ACol, ARow: integer);
var TOBL: TOB;
  HDATE: THCritMaskEdit;
  Coord: TRect;
begin
  // DEBUT MODIF CHR
  if (ACol <> GS_DateDep) and (ACol <> GS_DateFin) then Exit;
  // FIN MODIF CHR
  if Action = taConsult then Exit;
	TOBL := GETTOBEtude(TOBEtude,GS.Row);
  if TOBL = nil then Exit;
  Coord := GS.CellRect(GS.Col, GS.Row);
  HDATE := THCritMaskEdit.Create(GS);
  HDATE.Parent := GS;
  HDATE.Top := Coord.Top;
  HDATE.Left := Coord.Left;
  HDATE.Width := 3;
  HDATE.Visible := False;
  HDATE.OpeType := otDate;
  HDATE.Text := GS.CellValues [Acol,Arow];
  GetDateRecherche(TForm(HDATE.Owner), HDATE);
  // DEBUT MODIF CHR
  if HDATE.Text <> '' then GS.Cells[ACol, GS.Row] := HDATE.Text;
  // FIN MODIF CHR
  HDATE.Free;
end;

procedure TFEtudes.SetNatureAuxi(const Value: String);
begin
  fNatureAuxi := Value;
  if fNatureAuxi = '' then fNatureAuxi := 'CLI';
end;

procedure TFEtudes.PopExcelPopup(Sender: TObject);
begin
	DefiniPopUpGS (GS.row);
end;

procedure TFEtudes.EnvoiLotCotraitanceClick(Sender: TObject);
var Cledoc          : R_Cledoc;
    Fournisseur     : String;
    sFile           : String;
    Dfile           : String;
    TOBL            : TOB;
begin

	TOBL:=GetTOBEtude(TOBEtude,GS.Row) ; if TOBL=Nil then Exit ;

  if (TOBL.getValue('BDE_FOURNISSEUR')<>'') then
  begin
    sFile := TOBL.getvalue('BDE_NAME');
    Dfile := IncludeTrailingBackslash(GetWindowsTempPath)+ExtractFileName(sFile);
    CopieFichier(sFile,Dfile);
  end
  else
  begin
    Dfile := '';
    if TOBL.GetValue('BDE_PIECEASSOCIEE') = '' then
    begin
      PgiInfo ('Pensez à intégrer le document XLS dans l''étude PGI', application.name);
    end
    else
    begin
  		DecodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),CleDoc);
      Fournisseur := AGLLanceFiche('BTP','BTMULAFFAIREINTER','BAI_AFFAIRE=' + TOBEtude.GetValue('AFF_AFFAIRE'),'','');
      if Fournisseur <> '' then
      begin
        TOBL.PutValue('BDE_FOURNISSEUR', Fournisseur);
    	  Dfile := GenereDocumentXls(Cledoc,fournisseur);
      end;
    end;
    if Dfile = '' then exit;
  end;

  //
  EnvoiMail.Destinataire := GetEmail (TOBL);

  RechercheValeurZone(TOBL);

  {*
  if EnvoiMail.sujet = '' then EnvoiMail.Sujet := 'Envoie du Lot au Cotraitant';

  if ((Length(EnvoiMail.Corps.Text) <> 0) or (EnvoiMail.Corps.Text='')) and (EnvoiMail.Corps.Text <> #$D#$A) then
  begin
    EnvoiMail.Corps.add ('Bonjour');
    EnvoiMail.Corps.add ('');
    EnvoiMail.Corps.add ('Merci de me faire parvenir au plus vite le chiffrage de votre lot');
    EnvoiMail.Corps.add ('');
    EnvoiMail.Corps.add ('Cordialement');
  end;
  *}

  if Fournisseur <> '' then TOBL.PutValue('BDE_FOURNISSEUR', '');

  EnvoiMail.copie := '';

  EnvoiMail.fichiers := Dfile+';';

	EnvoiMail.ResultMailForm := AglMailForm(EnvoiMail.Sujet,EnvoiMail.Destinataire,EnvoiMail.copie,EnvoiMail.Corps,EnvoiMail.fichiers,false);

  if EnvoiMail.ResultMailForm = rmfOkButNotSend then SendMail(EnvoiMail.Sujet,EnvoiMail.Destinataire,EnvoiMail.Copie,EnvoiMail.Corps,EnvoiMail.fichiers,True,1, '', '');

  EnvoiMail.corps.free;

end;

Procedure TFEtudes.RechercheValeurZone(TOBL : TOB);
var Rapport   : TGestionRapport;
    Cledoc    : R_Cledoc;
    TobPiece  : TOB;
    TobTiers  : TOB;
    TobFrs    : TOB;
    TobAdr    : TOB;
    TobAffInt : TOB;
    TobAffaire: TOB;
    QQ        : TQuery;
    LineSave      : String;
    ZoneChaine    : string;
    ValeurChaine  : string;
    iInd          : Integer;
    DebZone       : Integer;
    FinZone       : Integer;
    TailleZone    : Integer;

  //
  function RecupZoneTravail(ZoneChaine : string; TOBL : TOB) : string;
  begin

    Result := '';

    result := ChargetobMail(TOBL, ZoneChaine);

    if Result = '' then
    begin
      result := ChargetobMail(TobPiece, ZoneChaine);
      if Result = '' then
      begin
        result := ChargetobMail(Tobfrs, ZoneChaine);
        if Result = '' then
        begin
          Result := ChargeTobMail(TobTiers, ZoneChaine);
          if Result = '' then
          begin
            Result := ChargeTobMail(TOBAdr, ZoneChaine);
            if Result = '' then
            begin
              Result := ChargeTobMail(TOBAffaire, ZoneChaine);
              if Result = '' then
              begin
                Result := ChargeTobMail(TobAffInt, ZoneChaine);
              end;
            end;
          end;
        end;
      end;
    end;

  end;

begin

  if TOBL = nil then Exit;

  DeCodeRefPiece (TOBL.GetValue('BDE_PIECEASSOCIEE'),Cledoc);

  if not assigned(TobPiece) then
  begin
    TobPiece := TOB.Create('PIECE', nil, -1);
    LoadPieceLignes(CleDoc, TobPiece);
  end;

  // lecture table tiers
  if not assigned(TobTiers) then
  begin
    TobTiers := TOB.Create('TIERS', nil, -1);
    RemplirTOBTiers (TOBTiers,TOBPiece.getValue('GP_TIERS'),Cledoc.NaturePiece, false);
    if TobTiers.FieldExists('T_LIBELLE') then TobTiers.AddChampSupValeur('T_NOMCLI', TobTiers.GetString('T_LIBELLE'));
  end;

  if not Assigned(TobFrs) then
  begin
    TobFrs := TOB.Create('FOURNISSEUR', nil, -1);
    RemplirTOBTiers (TOBFrs,TOBL.getValue('BDE_FOURNISSEUR'),Cledoc.NaturePiece, false);
    if TobFrs.FieldExists('T_LIBELLE') then TobFrs.AddChampSupValeur('T_NOMFRS', TobFrs.GetString('T_LIBELLE'));
  end;

  // Lecture Adresses
  if not Assigned(TobAdr) then
  begin
    TobAdr := TOB.Create('ADRESSE', nil, -1);
    LoadLesAdresses(TOBPiece,TOBAdr) ;
  end;

  // Lecture Affaire
  if not Assigned(TobAffaire) then
  begin
    TobAffaire := TOB.Create('AFFAIRE', nil, -1);
    QQ := OpenSQL('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="'+ TOBPIECE.GetValue('GP_AFFAIRE') +'"',True,-1, '', True);
    TOBAffaire.SelectDB('',QQ);
    Ferme(QQ);
  end;

  if not Assigned(TobAffInt) then
  begin
    TobAffInt := TOB.Create('AFFAIRE', nil, -1);
    QQ := OpenSQL('SELECT * FROM AFFAIREINTERV WHERE BAI_AFFAIRE="'+ TOBPIECE.GetValue('GP_AFFAIRE') +'"',True,-1, '', True);
    TobAffInt.SelectDB('',QQ);
    Ferme(QQ);
  end;

  EnvoiMail.Corps := hTStringList.Create;

  //chargement de l'enreg Param Mail dans LIENOLE.
  Rapport := TGestionRapport.Create(Self);

  Rapport.Titre   := 'Envoi chiffrage cotraitant';
  Rapport.Close   := True;
  Rapport.Sauve   := False;
  Rapport.Print   := False;
  Rapport.TableID := 'MAI';
  Rapport.Qualif  := 'COT';
  Rapport.IDLienOLE := '{C1017EFA-0310-4191-AD5B-E426474F2213}';
  //
  Rapport.ChargeRapportLo;
  //
  EnvoiMail.Sujet := Rapport.Libelle;

  For iInd := 0 to Rapport.Memo.Lines.count do
  begin
    LineSave  := Rapport.Memo.lines[iInd];
    While Pos('[', LineSave) <> 0 do
    begin
      DebZone    := pos('[' , LineSave );
      FinZone    := pos(']' , LineSave );
      TailleZone := FinZone - DebZone;
      ZoneChaine := copy(LineSave, DebZone, TailleZone + 1);
      ValeurChaine := RecupZoneTravail(copy(ZoneChaine, 2, TailleZone-1), TOBL);
      if ValeurChaine = '' then
        LineSave := AnsiReplaceText(LineSave, ZoneChaine, '<Erreur>')
      else
        LineSave := AnsiReplaceText(LineSave, ZoneChaine, ValeurChaine);
    end;
    EnvoiMail.corps.Add(LineSave);
  end;

  Freeandnil(TobPiece);
  FreeAndnil(TobTiers);
  FreeAndNil(TobAdr);
  FreeAndNil(TobAffaire);

end;

Function TFEtudes.ChargeTobMail(Tobchaine : Tob; ZoneChaine : string) : string;
begin

  Result := '';

  if TOBChaine.FieldExists(ZoneChaine) then
    Result := TOBchaine.GetValue(ZoneChaine);

end;

//FV1 : 15/06/2011 => envoie lot appels d'offre globalisé...
procedure TFEtudes.EnvoiLotGlobalClick(Sender: TObject);
var ResultMailForm : TResultMailForm;
    //
    i       : Integer;
    //
    Sujet   : HString;
    Corps   : HTStringList;
    //
    copie   : String;
    fichiers: String;
    Dest    : string;
    sFile   : String;
    Dfile   : String;
    Grp_file: string;
    //
    Select  : Boolean;
begin

  if TOBEtude=Nil then Exit ;

  //Contrôle si le contact existe pour les co-traitants sélectionnés
  if not ExisteContact(TOBEtude) then
  begin
    pgiinfo(TraduireMemoire('Le contact renseigné n''existe pas, veuillez le renseigner avant de continuer !'), TraduireMemoire('Appel d''offre Globalisé'));
    exit;
  end;

  //contrôle adresse mail du contact de l'appel d'offre
  if TOBEtude.GetString('MAIL') = '' then
  begin
    pgiinfo(TraduireMemoire('L''adresse mail du contact n''est pas valide, veuillez la renseigner avant de continuer !'), TraduireMemoire('Appel d''offre Globalisé'));
    exit;
  end;

  select := false;

  for i:=0 to TOBEtude.Detail.count-1 do
  begin
    if TOBEtude.detail[i].GetBoolean('BDE_SELECTIONNE') then Select := TOBEtude.Detail[i].GetBoolean('BDE_SELECTIONNE');
    //contrôle existence du fichier XLS associé à l'appel d'offre
    if FileExists(TOBEtude.Detail[i].GetString('BDE_NAME')) then
    begin
      sFile := TOBEtude.detail[i].GetString('BDE_NAME');
      //contrôle si le fichier est remplit ou non...
      if not ControlePiece(TOBEtude.detail[i]) THEN
      begin
        Grp_file := 'Erreur';
        Break;
      end;
      //Création d'une liste de fichiers à ajouter en pièce jointe...
      Dfile := IncludeTrailingBackslash(GetWindowsTempPath)+ExtractFileName(sFile);
      CopieFichier(sFile,Dfile);
      sFile := ExtractFileName(sFile);
      if Grp_file = '' then
        Grp_file := Dfile
      else
        Grp_File := Grp_file + ';' + Dfile;
    end
    else
      pgiinfo(TraduireMemoire('Le fichier ' + TOBEtude.detail[i].GetString('BDE_NAME') + ' n''existe pas'), TraduireMemoire('Appel d''offre Globalisé'));
  end;

  //envoie du message mail !!!!
  try
    LblErreur.Caption := 'envoie du Mail...';
    if Grp_file = '' then
      pgiinfo(TraduireMemoire('Aucun lot à envoyer, vérifiez les chemins d''accès aux fichiers'), TraduireMemoire('Appel d''offre Globalisé'))
    else if Grp_file = 'Erreur' then
      pgiinfo(TraduireMemoire('L''appel d''offre ' + TOBEtude.detail[i].GetString('BDE_NAME') + ' n''est pas renseigné dans sa totalité !'), TraduireMemoire('Appel d''offre Globalisé'))
    else
    begin
      if select then
      begin
        Dest  := TOBEtude.GetString('MAIL');
        Corps := hTStringList.Create;
        Sujet := 'Envoi Global des lots';
        copie := '';
        Corps.add ('Bonjour');
        Corps.add ('');
        Corps.add ('Veuillez trouver en pièce jointe l''ensemble des lots faisant l''objet');
        Corps.add ('d''un chiffrage');
        Corps.add ('');
        Corps.add ('Nous vous en souhaitons bonne réception.');
        Corps.add ('Cordialement');
        Corps.add ('');
        fichiers := Grp_File;

        ResultMailForm := AglMailForm(Sujet,Dest,copie,Corps,fichiers,false);
        if ResultMailForm = rmfOkButNotSend then SendMail(Sujet,Dest,Copie,Corps,fichiers,True,1, '', '');
        corps.free;
      end
      else
      begin
        pgiinfo(TraduireMemoire('Aucun lot de sélectionné'), TraduireMemoire('Appel d''offre Globalisé'));
      end;
    end;
  finally
    LblErreur.Caption := '';
  end;

end;

function TFEtudes.GetEmail(TOBL: TOB): string;
var QQ : TQuery;
		NumContact : integer;
    Req : string;
begin

  LblErreur.Caption := 'Récupération de l''adresse Mail...';

	result := '';
  numContact := 0;

  req := 'SELECT BAI_NUMEROCONTACT FROM AFFAIREINTERV WHERE BAI_AFFAIRE="' + TOBL.getvalue('BDE_AFFAIRE') + '" ' +
  			 'AND BAI_TIERSFOU="' + TOBL.getValue('BDE_FOURNISSEUR') + '"';

  QQ := OpenSql (req,true,1,'',true);
  if not QQ.eof then
  begin
  	numContact := QQ.findField('BAI_NUMEROCONTACT').AsInteger;
  end;
  ferme (QQ);
  if numContact <> 0 then
  begin
    Req := 'SELECT C_RVA FROM CONTACT WHERE C_TYPECONTACT="T" AND '+
           'C_AUXILIAIRE="'+TiersAuxiliaire(TOBL.getValue('BDE_FOURNISSEUR'))+'" AND C_NUMEROCONTACT='+inttoStr(numContact);
    QQ := OpenSql (req,true,1,'',true);
    if not QQ.eof then
    begin
    	result := QQ.findfield('C_RVA').AsString;
    end;
    ferme (QQ);
  end;
  if result = '' then
  begin
    Req := 'SELECT T_RVA FROM TIERS WHERE T_NATUREAUXI="FOU" AND T_TIERS="'+TOBL.getValue('BDE_FOURNISSEUR')+'"';
    QQ := openSql (Req,true,1,'',true);
    if not QQ.eof then
    begin
    	result := QQ.findfield('T_RVA').AsString;
    end;
    ferme (QQ);
  end;

  LblErreur.Caption := '';

end;

//contrîole existence du contact et de l'adresse mail associée !!!
Function TFEtudes.ExisteContact(TOBL : Tob) : boolean;
var Affaire   : String;
    Tiers     : String;
    Contact   : String;
    AdrMail   : String;
    NomContact: String;
    StSQL     : String;
    QQ        : TQuery;
begin

  Result := False;

  if TOBL = nil then Exit;

  LblErreur.Caption := 'Contrôle existance contact en cours...';

  //init des zones de stockage
  Contact     := '';
  AdrMail     := '';
  NomContact  := '';

  StSQL := '';

  Affaire := TOBL.GetString('AFF_AFFAIRE');
  Tiers   := TOBL.GetString('AFF_TIERS');

  //récupération du contact associé à l'affaire
  Contact := TOBL.GetString('AFF_NUMEROCONTACT');

  if Contact = '0' then
  begin
    //Recherche du contact principal du tiers de l'affaire
    StSQL := 'SELECT C_RVA, C_NUMEROCONTACT, C_NOM FROM CONTACT WHERE C_TIERS="' + Tiers + '" AND C_PRINCIPAL="X"';
    QQ := OpenSQL(StSQL, false);
    if not QQ.Eof then
    begin
      Contact    := QQ.FindField ('C_NUMEROCONTACT').AsString;
      AdrMail    := QQ.FindField ('C_RVA').AsString;
      NomContact := QQ.FindField ('C_NOM').AsString;
      result := true;
    end;
    ferme (QQ);
  end
  else
  begin
    //Recherche de l'adresse mail et du nom du contact de l'affaire
    StSQL := 'SELECT C_RVA, C_NOM FROM CONTACT WHERE C_TIERS="' + Tiers + '" AND C_NUMEROCONTACT="' + contact + '"';
    QQ := OpenSQL(StSQL, false);
    if not QQ.Eof then
    begin
      AdrMail    := QQ.FindField ('C_RVA').AsString;
      NomContact := QQ.FindField ('C_NOM').AsString;
      result := true;
    end;
    ferme(QQ);
  end;

  if AdrMail = '' then
  begin
    //Si l'adresse mail est à blanc chargement de celle du tiers de l'affaire
    StSQL := 'SELECT T_RVA FROM TIERS WHERE T_TIERS="' + Tiers + '"';
    QQ := OpenSQL(StSQL, false);
    if not QQ.Eof then AdrMail := QQ.findfield('T_RVA').AsString;
    ferme (QQ);
  end;

  TOBL.AddChampSupValeur('CONTACT', Contact);
  TOBL.AddChampSupValeur('NOMCONTACT', NomContact);
  TOBL.AddChampSupValeur('MAIL', AdrMail);

  LblErreur.Caption := '';

end;

function TFEtudes.ControlePiece(TOBEtudeL: TOB): boolean;
var PieceEtude    : TPieceEtude;
    TOBl          : TOB;
    TOBS          : TOB;
    StructCreated : boolean;
begin

  Result := False;

  TOBL    := TOBEtudeL;
  TOBS    := findstructure (TOBL,StructCreated);

  if TOBS = nil then
  BEGIN
    PGIBox ('Vous devez d''abord définir la structure du fichier',caption);
    exit;
  END;

  {*if IsExcelLaunched then
  BEGIN
    PGIBox ('Vous devez fermer préalablement les instances d''EXCEL',caption);
    Exit;
  END;*}

  PieceEtude := TPieceEtude.Create;

  TRY
    LblErreur.Caption := 'Contrôle du fichier excel en cours...';
    if TOBL.GetString('BDE_NAME') <> '' then
    begin
      TRY
        PieceEtude.NomFicXls := TOBL.GetString('BDE_NAME');
        PieceEtude.DefiniStructureXls (TOBS.GetString('BSD_DESCRIPT'));
        Result := PieceEtude.IsDocumentvalorise;
      FINALLY
        PieceEtude.Free;
        if StructCreated then TOBS.free;
      END;
    end else
    begin
      Pgibox ('Vous devez rattacher un document',caption);
    end;
  FINALLY
    LblErreur.caption := '';
  END;

end;

end.
