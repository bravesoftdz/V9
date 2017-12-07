{***********UNITE*************************************************
Auteur  ...... : Franck VAUTRAIN
Créé le ...... : 19/02/2004
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTVARDOC ()
Mots clefs ... : TOF;BTVARDOC
*****************************************************************}
Unit BTVARDOC_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     Vierge,
     HTB97,
     AglInit,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     fe_main,
{$else}
     eMul,
     maineagl,
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     HPanel ;
const
  ZZNBCOLS = 3;

Type
  TOF_BTVARDOC = Class (TOF)
  private
    // les Variables
    LesColonnes : string;
    SG_SEL,SG_CODE,SG_VALEUR : integer;

    // Les pointeurs
    Cancel : Boolean;


    // Les Tobs
    TOBVariables : TOB;

    // Objets
    GS : THGrid;

    // Les Boutons d'Action
    BDefaire: TToolbarButton97;
    BInsert: TToolbarButton97;
    BDelete: TToolbarButton97;
    BFirst: TToolbarButton97;
    BPrev: TToolbarButton97;
    BNext: TToolbarButton97;
    BLast: TToolbarButton97;
    BValider: TToolbarButton97;

  Public

    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

  private

    //Procedure de gestion des événements sur les boutons
    procedure BDefaireClick(Sender: TObject);
    procedure BInsertClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure BFirstClick(Sender: TObject);
    procedure BPrevClick(Sender: TObject);
    procedure BNextClick(Sender: TObject);
    procedure BLastClick(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    
    //Procedure de gestion des événements sur la Grille
    procedure EtudieColList;
    procedure RemplitLaGrid;
    procedure AfficheLagrid;
    procedure GSSetEvent(Active: boolean);
    procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
  end ;

function ChargeVariables (Action : TactionFiche; TobVarMetre : Tob; NaturePiece, Souche : string; NumeroPiece, Ind : Integer) : boolean;

Implementation
 var
    SNaturePiece : string;
    SSouche : string;
    SNumeroPiece : integer;
    SInd : Integer;
    Ok_Modif : Boolean;

{Evenement sur la TOF }
function ChargeVariables (Action : TactionFiche; TobVarMetre : Tob; NaturePiece, Souche : string; NumeroPiece, Ind : Integer) : boolean;
var StAction : string;
begin

  result := false;
  
  SNaturePiece := NaturePiece;
  SSouche := Souche;
  SNumeroPiece := NumeroPiece;
  SInd := Ind;

  TheTOb := TOBvarmetre;

  if Action = TaConsult then
     stAction := 'ACTION=CONSULTATION'
  else
     stAction := 'ACTION=MODIFICATION';

  AGLLanceFiche('BTP', 'BTVARDOC','','',staction);

  TheTob := nil;

end;

procedure TOF_BTVARDOC.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnArgument (S : String ) ;
begin
  Inherited ;

  Cancel := False;

  TOBVariables := laTOB;
  // assignation des objet des la fiche
  GS := THGrid(GetControl('GRILLE_VAR'));

  EtudieColList;
  RemplitLaGrid;
  AfficheLagrid;

  // Assignation des evenements une fois que tout est remplit
  GSSetEvent (Ok_Modif);

  if TobVariables.Detail.Count= 0 then exit;

  GSRowEnter(self, 1, Cancel, false);

end ;

procedure TOF_BTVARDOC.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTVARDOC.OnCancel () ;
begin
  Inherited ;
end ;

// DIVERS

procedure TOF_BTVARDOC.EtudieColList;
var TheColonnes,NomCol : string;
    icol : integer;
begin
  LesColonnes := 'SEL;BVD_CODEVARIABLE;BVD_VALEUR;';

  gs.rowCount := 1;

  //Definition du nombre de ligne maximum de la grille
  if TobVariables.detail.count < 2 then
     GS.RowCount := 2
  else
     GS.RowCount := TobVariables.detail.count +1;

  GS.ColCount := ZZNBCOLS; // à ne pas oublier

  TheColonnes := lesColonnes;
  icol := 0;

  repeat
    NomCol := UPPERCASE(READTOKENST (TheColonnes));
    if NomCol <> '' then
    begin
      if NomCol = 'SEL' then
      begin
        SG_SEL := icol;
        GS.ColWidths [SG_SEL] := 10;
        GS.ColAligns[SG_SEL] := taCenter;
        GS.cells[SG_SEL,0] := '';
      end else
      if NomCol = 'BVD_CODEVARIABLE' then
      begin
        SG_CODE := icol;
        GS.ColWidths [SG_CODE] := 68;
        GS.ColAligns[SG_CODE] := taLeftJustify;
        GS.cells[SG_CODE,0] := 'Code';
      end else
      if NomCol = 'BVD_VALEUR' then
      begin
        SG_VALEUR := icol;
        GS.ColWidths [SG_VALEUR] := 147;
        GS.ColAligns[SG_VALEUR] := taLeftJustify;
        GS.cells[SG_VALEUR,0] := 'Valeur';
      end;
    inc(icol);
    end;
  until NomCol = '';
end;

procedure TOF_BTVARDOC.RemplitLaGrid;
var indice : integer;
begin

  // détail
  TFVierge(Ecran).HMTrad.ResizeGridColumns(GS);

  for indice := 0 to TOBVariables.detail.count -1 do
  begin
    TOBVariables.detail[Indice].PutValue ('SEL',indice+1);
    TOBVariables.detail[Indice].PutLigneGrid (GS,Indice+1,false,false,LesColonnes);
  end;
  //

  GS.FixedRows := 1;
  gs.invalidate;
  gs.refresh;

end;

procedure TOF_BTVARDOC.AfficheLagrid;
var indice : integer;
begin
  TRY
  // détail
    for indice := 0 to TOBVariables.detail.count -1 do
    begin
      Gs.RowHeights[Indice+1] := 18;
    end;
  FINALLY
    gs.invalidate;
    gs.refresh;
  END;
end;

procedure TOF_BTVARDOC.GSSetEvent (Active : boolean);
begin

  GS.OnRowEnter := GSRowEnter;

  SetControlProperty('BFirst', 'Visible', True);
  SetControlProperty('BLast', 'Visible', True);
  SetControlProperty('BNext', 'Visible', True);
  SetControlProperty('BPrev', 'Visible', True);
  SetControlProperty('BDelete', 'Visible', True);
  SetControlProperty('BInsert', 'Visible', True);
  SetControlProperty('BValider', 'Visible', True);
  SetControlProperty('BDefaire', 'Visible', True);

  BFirst := TToolbarButton97(ecran.FindComponent('BFirst'));
  BLast := TToolbarButton97(ecran.FindComponent('BLast'));
  BNext := TToolbarButton97(ecran.FindComponent('BNext'));
  BPrev := TToolbarButton97(ecran.FindComponent('BPrev'));
  BDelete := TToolbarButton97(ecran.FindComponent('BDelete'));
  BInsert := TToolbarButton97(ecran.FindComponent('BInsert'));
  BDefaire := TToolbarButton97(ecran.FindComponent('BDefaire'));
  BValider := TToolbarButton97(ecran.FindComponent('BValider'));

  BFirst.onclick := BFirstClick;
  BLast.onclick := BLastClick;
  BNext.onclick := BNextClick;
  BPrev.onclick := BPrevClick;
  BDelete.onclick := BDeleteClick;
  BInsert.onclick := BInsertClick;
  BDefaire.onclick :=BDefaireClick;
  BValider.onclick :=BValiderClick;

  SetControlvisible('BDefaire', false);

end;

procedure TOF_BTVARDOC.GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin

  TobVariables.detail[GS.row-1].PutEcran(Ecran, THPanel(GetControl('Panel1')));

  if TobVariables.detail[gs.row-1].GetValue('BVD_QTEEXPPOUR') = 'X' then
    setcontrolvisible('BVD_QTEEXPPOUR', true)
  else
    setcontrolvisible('BVD_QTEEXPPOUR', False);
    
end;

procedure TOF_BTVARDOC.BDefaireClick(Sender: TObject);
begin

  Cancel := false;

  SetControlEnabled('BInsert', true);
  SetControlEnabled('BDelete', True);

  if TobVariables.Detail.Count = 0 then exit;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BDeleteClick(Sender: TObject);
begin

  if TobVariables.Detail.Count = 0 then exit;

  if PGIask(TraduireMemoire('Confirmez-vous la suppression ?'),'Suppression Variables Document') <> mrYes then exit;

  TobVariables.Detail[Gs.Row-1].free;

  GS.DeleteRow(Gs.Row);

  RemplitLaGrid;

  AfficheLagrid;

  if TobVariables.Detail.Count = 0 then exit;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BFirstClick(Sender: TObject);
begin

  if TobVariables.Detail.Count = 0 then exit;

  Cancel := False;

  gs.Row := 1;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BInsertClick(Sender: TObject);
begin

  SetControlEnabled('BInsert', False);
  SetControlEnabled('BDelete', False);

  SetControlText('BVD_CODEVARIABLE', '');
  SetControlText('BVD_LIBELLE', '');
  SetControlText('BVD_VALEUR', '');
  SetControlText('BVD_QTEEXPPOUR', '');

  SetFocusControl('BVD_CODEVARIABLE');

end;

procedure TOF_BTVARDOC.BLastClick(Sender: TObject);
begin

  if TobVariables.Detail.Count = 0 then exit;

  Cancel := False;

  gs.Row := TobVariables.Detail.Count;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BNextClick(Sender: TObject);
begin

  if TobVariables.Detail.Count = 0 then exit;

  Cancel := False;

  if gs.row < TobVariables.Detail.Count then
     gs.Row := Gs.row + 1;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BPrevClick(Sender: TObject);
begin

  if TobVariables.Detail.Count = 0 then exit;

  Cancel := False;

  if gs.row > 1 then
     gs.Row := Gs.row - 1;

  GSRowEnter(self, gs.row, Cancel, false);

end;

procedure TOF_BTVARDOC.BValiderClick(Sender: TObject);
var TobFille : tob;
begin

  Ecran.ModalResult := MrNone;

  if TToolbarButton97 (GetCOntrol('Binsert')).Enabled then
    Begin
      TobVariables.Detail[Gs.row - 1].GetEcran(Ecran, THPanel(GetControl('Panel1')));
    End
  Else
    begin
      GS.InsertRow(TobVariables.Detail.Count + 1);
      TobFille := Tob.Create('BVARDOC', TOBVariables, -1);
      TobFille.Putvalue('BVD_NATUREPIECE', SNaturePiece);
      TobFille.Putvalue('BVD_SOUCHE',SSouche);
      TobFille.Putvalue('BVD_NUMERO',IntToStr(SNumeroPiece));
      TobFille.Putvalue('BVD_INDICE',IntToStr(SInd));
      TobFille.Putvalue('BVD_INDEXFILE',0);
      TobFille.Putvalue('BVD_CODEVARIABLE',GetControlText('BVD_CODEVARIABLE'));
      TobFille.Putvalue('BVD_LIBELLE',GetControlText('BVD_LIBELLE'));
      TobFille.Putvalue('BVD_VALEUR',GetControlText('BVD_VALEUR'));
    end;

  RemplitLaGrid;

  AfficheLagrid;

  SetControlEnabled('BInsert', True);
  SetControlEnabled('BDelete', True);

  if TobVariables.Detail.Count = 0 then exit;

  GSRowEnter(self, gs.row, Cancel, false);

end;

Initialization
  registerclasses ( [ TOF_BTVARDOC ] ) ;
end.

