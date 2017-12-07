{***********UNITE*************************************************
Auteur  ...... : Vautrain Franck
Créé le ...... : 06/01/2004
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTSAISIEVAR ()
Mots clefs ... : TOF;BTSAISIEVAR
*****************************************************************}
Unit UTofBtSaisieVar ;

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
     UTOF ;
const
  ZZNBCOLS = 4;
Type

  TOF_BTSAISIEVAR = Class (TOF)
  private
    LesColonnes : string;
    SG_SEL,SG_CODE,SG_LIBELLE,SG_VALEUR : integer;
    //
    firstLig : integer;
    //
    TOBVariables : TOB;
    // Objets
    GS : THGrid;
    TOBResult : TOB;
    ToutVoir : TCheckBox;
    laValue : string;
    // Assignation initiale
    procedure AssigneObjet;
    procedure AssigneEvent;
    // Grille
//    procedure GSEnter (Sender : TOBject);
    procedure GSSetEvent(Active: boolean);
    procedure GSCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
    procedure RemplitLaGrid;
    procedure AfficheLagrid;
    // ToutVoir
    procedure ToutVoirClick (Sender : Tobject);
    // Divers
    procedure EtudieColList;
    function ZoneAccessible(ACol, ARow: Integer): boolean;
    procedure ZoneSuivanteOuOk(var ACol, ARow: Integer;var Cancel: boolean);

  public
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ; // c'est la où tout commence
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  end ;

function Saisievariables (TobVarMetre : Tob) : boolean;

Implementation

{Evenement sur la TOF }
function Saisievariables (TobVarMetre : Tob) : boolean;
begin

  result := false;

  TOBVarmetre.AddChampSupValeur ('RESULT','-',false);
  TheTOb := TOBvarmetre;
  TRY
    AGLLanceFiche('BTP', 'BTSAISIEVAR','','','');
    if (TheTOB <> nil) and (TheTOB.getValue('RESULT')='X') then result := true;
  FINALLY
    TheTob := nil;
  END;
end;

procedure TOF_BTSAISIEVAR.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIEVAR.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIEVAR.OnUpdate ;
var Acol,Arow : integer;
    Cancel : boolean;
begin
  Inherited ;
  Acol := GS.Col;
  Arow := GS.Row;
  GScellexit(self,Acol,Arow,cancel);
  TOBResult.putValue('RESULT','X');
  TheTOB := TOBResult;
end ;

procedure TOF_BTSAISIEVAR.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIEVAR.OnArgument (S : String ) ;
begin
  Inherited ;
  TOBResult := LaTOB; // recup de TheTOB;
  TOBVariables := laTOB;
  // assignation des objet des la fiche
  AssigneObjet;
  EtudieColList;
  RemplitLaGrid;
  AfficheLagrid;
  // Assignation des evenements une fois que tout est remplit
  AssigneEvent;
end ;

procedure TOF_BTSAISIEVAR.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIEVAR.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTSAISIEVAR.OnCancel () ;
begin
  Inherited ;
end ;

{ Gestion des objets de la fiches }

procedure TOF_BTSAISIEVAR.AssigneEvent;
begin
  GSSetEvent (true);
  ToutVoir.OnClick := ToutVoirClick;
end;

procedure TOF_BTSAISIEVAR.AssigneObjet;
begin
  GS := THGrid(GetControl('GRID'));
  ToutVoir := TCheckBox (GetControl('TOUTVOIR'));
end;

procedure TOF_BTSAISIEVAR.GSCellEnter (Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  ZoneSuivanteOuOk(ACol, ARow, Cancel);
  if not cancel then
  begin
    laValue := GS.cells[SG_VALEUR,GS.row];
  end;
end;

procedure TOF_BTSAISIEVAR.GSCellExit (Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  if TOBVariables.detail[Arow-1] <> nil then
  begin
    TOBVariables.detail[Arow-1].PutValue('BVD_VALEUR',Trim(GS.cells[SG_VALEUR,Arow]));
    GS.Cells[SG_CODE,Arow] := TOBVariables.detail[Arow-1].GetValue('BVD_CODEVARIABLE');
    GS.Cells[SG_LIBELLE,ARow] := TOBVariables.detail[Arow-1].GetValue('BVD_LIBELLE');
  end;
end;

procedure TOF_BTSAISIEVAR.GSRowEnter(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
end;

procedure TOF_BTSAISIEVAR.GSRowExit(Sender: TObject; Ou: Integer; var Cancel: Boolean; Chg: Boolean);
begin
end;

procedure TOF_BTSAISIEVAR.GSSetEvent (Active : boolean);
begin
  if Active then
  begin
    GS.OnCellEnter := GSCellEnter;
    GS.OnCellExit := GSCellExit;
    GS.OnRowEnter := GSRowEnter;
    GS.OnRowExit := GSRowExit;
  end else
  begin
    GS.OnEnter := nil;
    GS.OnCellEnter := nil;
    GS.OnCellExit := nil;
    GS.OnRowEnter := nil;
    GS.OnRowExit := nil;
  end;
end;

procedure TOF_BTSAISIEVAR.RemplitLaGrid;
var indice : integer;
begin
  GS.ColCount := ZZNBCOLS;
  gs.rowCount := 1;
  if TobVariables.detail.count < 2 then GS.RowCount := 2
                                   else GS.RowCount := TobVariables.detail.count +1;
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

procedure TOF_BTSAISIEVAR.AfficheLagrid;
var indice : integer;
begin
  firstLig := 0;
  TRY
  // détail
    for indice := 0 to TOBVariables.detail.count -1 do
    begin
      if (TOBVariables.detail[Indice].GetValue('BVD_VALEUR') <> '') and (not ToutVoir.Checked) then
      begin
        Gs.RowHeights[Indice+1] := 0;
      end else
      begin
        Gs.RowHeights[Indice+1] := 18;
        if firstlig = 0 then FirstLig := Indice +1;
      end;
    end;
  FINALLY
    gs.invalidate;
    gs.refresh;
  END;
end;


procedure TOF_BTSAISIEVAR.ZoneSuivanteOuOk(var ACol, ARow: Longint; var Cancel: boolean);
var Sens, ii, Lim: integer;
  OldEna, ChgLig, ChgSens: boolean;
  ColInit,RowInit : integer;
begin
  ColInit := Acol;
  RowInit := ARow;
  OldEna := GS.SynEnabled;
  GS.SynEnabled := False;
  Sens := -1;
  ChgLig := (GS.Row <> ARow);
  ChgSens := False;
  if GS.Row > ARow then Sens := 1 else if ((GS.Row = ARow) and (ACol <= GS.Col)) then Sens := 1;
  ACol := GS.Col;
  ARow := GS.Row;
  ii := 0;
  while not ZoneAccessible(ACol, ARow) do
  begin
    inc(ii);
    if (Acol = ColInit) and (Arow = RowInit) then Begin cancel:= true; break; End;// un petit tour et puis revient
    if ii > 500 then BEGIN Cancel := true; Break; END;
    if Sens = 1 then
    begin
      Lim := GS.RowCount - 1;
      // ---
      if ((ACol = GS.ColCount - 1) and (ARow >= Lim)) then
      begin
        if ChgSens then
        begin
          cancel := true;
          Break;
        end else
        begin
          Sens := -1;
          Continue;
          ChgSens := True;
        end;
      end;
      if ChgLig then
      begin
        ACol := GS.FixedCols - 1;
        ChgLig := False;
      end;
      if ACol < GS.ColCount - 1 then Inc(ACol) else
      begin
        Inc(ARow);
        ACol := GS.FixedCols;
      end;
    end else
    begin
      if ((ACol = GS.FixedCols) and (ARow = 1)) then
      begin
        if ChgSens then
        BEGIN
          cancel := true;
          Break
        END else
        begin
          Sens := 1;
          Continue;
        end;
      end;
      if ChgLig then
      begin
        ACol := GS.ColCount;
        ChgLig := False;
      end;
      if ACol > GS.FixedCols then Dec(ACol) else
      begin
        Dec(ARow);
        ACol := GS.ColCount - 1;
      end;
    end;
  end;
  GS.SynEnabled := OldEna;
end;


function TOF_BTSAISIEVAR.ZoneAccessible(ACol, ARow: Longint): boolean; { NEWPIECE }
begin
  Result := True;
  if ACol < SG_VALEUR then
  begin
    Result := False;
    EXIT;
  end;
  if (TOBVariables.detail[Arow-1].GetValue('BVD_VALEUR') <> '') and (not ToutVoir.Checked) then
  begin
    result := false;
    Exit;
  end;
end;


// Objet TOUTVOIR

procedure TOF_BTSAISIEVAR.ToutVoirClick(Sender: Tobject);
begin
// TODO
// Codage sur click du tout voir
  AfficheLagrid;
end;

// DIVERS

procedure TOF_BTSAISIEVAR.EtudieColList;
var TheColonnes,NomCol : string;
    icol : integer;
begin
  LesColonnes := 'SEL;BVD_CODEVARIABLE;BVD_LIBELLE;BVD_VALEUR;';
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
        GS.ColLengths [SG_SEL] := -1;   // non saisissable
        GS.ColAligns[SG_SEL] := taCenter;
        GS.cells[SG_SEL,0] := 'Num';
      end else
      if NomCol = 'BVD_CODEVARIABLE' then
      begin
        SG_CODE := icol;
        GS.ColLengths [SG_CODE] := -1; // non saisissable
        GS.ColWidths [SG_CODE] := 70;
        GS.ColAligns[SG_CODE] := taLeftJustify;
        GS.cells[SG_CODE,0] := 'Code';
      end else
      if NomCol = 'BVD_LIBELLE' then
      begin
        SG_LIBELLE := icol;
        GS.ColLengths [SG_LIBELLE] := -1; // non saisissable
        GS.ColWidths [SG_LIBELLE] := 100;
        GS.ColAligns[SG_LIBELLE] := taCenter;
        GS.cells[SG_LIBELLE,0] := 'Désignation';
      end else
      if NomCol = 'BVD_VALEUR' then
      begin
        SG_VALEUR := icol;
        GS.ColWidths [SG_VALEUR] := 255;
        GS.Collengths [SG_VALEUR] := 255;
        GS.ColAligns[SG_VALEUR] := taLeftJustify;
        GS.cells[SG_VALEUR,0] := 'Valeur';
      end;
    inc(icol);
    end;
  until NomCol = '';
end;

Initialization
  registerclasses ( [ TOF_BTSAISIEVAR ] ) ;
end.

