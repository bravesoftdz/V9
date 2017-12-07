unit FactPiece ;

interface

uses HEnt1, UTOB,
{$IFNDEF EAGLCLIENT}
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
     HCtrls, FactTOB, SysUtils, EntGC ;

//Procedure NumeroteLignesGC (GS: THGrid; TOBPiece: TOB; ForceRenum: Boolean = False); { NEWPIECE } 
Procedure NumeroteLignesGC (GS: THGrid; TOBPiece: TOB; ForceRenum: Boolean = False; GestionAffichage: boolean = True); { NEWPIECE }
procedure EvaluerMaxNumOrdre(TOBPiece: TOB);
procedure MiseAJourGrid(GS: THGrid; TOBPiece: TOB; CodeArticle: string; Qte: Double; ARow: Integer);
function  SupDimAZero(GS: THGrid; CodeArticle: string; TOBDim, TOBPiece: TOB; ARow: Integer): Integer;
function  GetSoucheG(NaturePieceG, Etablissement, Domaine: String3): String3;
function  GetNumSoucheG(SoucheG: String3): integer;
procedure IncNumSoucheG(SoucheG: String3);
function  HistoPiece(TobPiece_O: Tob): Boolean;
function  SetNumberAttribution(SoucheG: string; NbPiece: integer): integer;
function  SetDefinitiveNumber(TOBPiece, TOBBases, TOBBasesL,TOBEches, TOBNomenclature, TOBAcomptes, TOBPieceRG, TOBBasesRG, TobLigneTarif: TOB; NumDef: integer): boolean;
function  SetNumeroDefinitif(TOBPiece, TOBBases, TOBBasesL,TOBEches, TOBNomenclature, TOBAcomptes, TOBPIeceRG, TOBBasesRG, TobLigneTarif: TOB): boolean;
function  IsTransfert(NaturePiece : String): Boolean;
function LireMaxNumOrdre(TOBPiece: TOB): integer;
procedure EcrireMaxNumordre(TOBPiece: TOB; MaxNumOrdre: integer);
function GetMaxNumOrdre (TOBpiece : TOB) : integer;
procedure JustNumerote (TOBPiece : TOb; Lignedepart: integer=-1);

implementation

uses
  FactTarifs
  ;
procedure EcrireMaxNumordre(TOBPiece: TOB; MaxNumOrdre: integer);
begin
  TOBPiece.PutValue('GP_CODEORDRE', MaxNumOrdre);
end;

procedure EvaluerMaxNumOrdre(TOBPiece: TOB);
var i, NumOrdre, MaxNumOrdre, iNO: integer;
  TOBL: TOB;
begin
  iNO := 0;
  MaxNumOrdre := 0;
  for i := 0 to TOBPiece.Detail.Count - 1 do
  begin
    TOBL := TOBPiece.Detail[i];
    if i = 0 then iNO := TOBL.GetNumChamp('GL_NUMORDRE');
    NumOrdre := TOBL.GetValeur(iNO);
    if NumOrdre > MaxNumOrdre then MaxNumOrdre := NumOrdre;
  end;
  EcrireMaxNumOrdre(TOBPiece, MaxNumOrdre);
end;

function LireMaxNumOrdre(TOBPiece: TOB): integer;
begin
  if TOBPiece.GetValue('GP_CODEORDRE') <= 0 then EvaluerMaxNumOrdre(TOBPiece);
  Result := TOBPiece.GetValue('GP_CODEORDRE');
end;


function GetMaxNumOrdre (TOBpiece : TOB) : integer;
var MaxNumOrdre : integer;
begin
  MaxNumOrdre:=LireMaxNumOrdre(TOBPiece);
  Inc(MaxNumOrdre);
  EcrireMaxNumOrdre(TOBPiece, MaxNumOrdre) ;
  result := MaxNumOrdre;
end;

procedure JustNumerote (TOBPiece : TOb; Lignedepart: integer=-1);
var Depart,Inl,i : integer;
    TOBL : TOB;
begin
  if TOBPiece.detail.count >0 then Inl := TOBPiece.detail[0].GetNumChamp('GL_NUMLIGNE') ;
  if LigneDepart <> -1 Then depart := LigneDepart else depart := 0;
  for i := depart to TOBPiece.Detail.Count-1 do
  begin
    TOBL := GetTOBLigne(TOBPiece, i+1);
    if TOBL <> nil then TOBL.PutValeur(Inl, i+1);
  end;
end;

//Procedure NumeroteLignesGC(GS: THGrid; TOBPiece: TOB; ForceRenum: Boolean = False); { NEWPIECE }
Procedure NumeroteLignesGC (GS: THGrid; TOBPiece: TOB; ForceRenum: Boolean = False; GestionAffichage: boolean = True); { NEWPIECE }
var
  i, inl, ino, NumOrdre, MaxNumOrdre: integer;
  TOBL: TOB;
  TobLigneTarif: Tob;
begin
  inl:=0; ino:=0;
  MaxNumOrdre:=LireMaxNumOrdre(TOBPiece);
  for i := 0 to TOBPiece.Detail.Count-1 do
  begin
    TOBL := GetTOBLigne(TOBPiece, i+1);
    if i=0 then
    begin
      inl := TOBL.GetNumChamp('GL_NUMLIGNE') ;
      ino := TOBL.GetNumChamp('GL_NUMORDRE') ;
    end;
    // Modif BTP
    if GestionAffichage then
      if GS <> nil then GS.Cells[SG_NL,i+1]:=IntToStr(i+1) ;
    // --
    TOBL.PutValeur(inl, i+1);
    NumOrdre := TOBL.GetValeur(ino);
    if (NumOrdre<=0) or ForceRenum then { NEWPIECE }
    begin
      Inc(MaxNumOrdre);
      TOBL.PutValeur(ino, MaxNumOrdre);
    end;
  end;
  EcrireMaxNumOrdre(TOBPiece, MaxNumOrdre) ;
  TobLigneTarif := GetTobLigneTarifInTobPiece(TobPiece);
  NumeroteLigneTarif(TobLigneTarif);
end;

procedure MiseAJourGrid(GS: THGrid; TOBPiece: TOB; CodeArticle: string; Qte: Double; ARow: Integer);
var TOBL: TOB;
  Ligne, i: Integer;
  TotQte: Double;
begin
  i := ARow;
  TOBL := TOBPiece.Detail[i - 1];
  if TOBL = nil then Exit;
  while TOBL.GetValue('GL_CODESDIM') <> CodeArticle do
  begin
    Dec(i);
    if i >= 1 then TOBL := TOBPiece.Detail[i - 1] else
    begin
      Break;
      TOBL := nil;
    end;
    {JLD ! Attention pas de break provoquait boucle infinie !!!!}
  end;
  if TOBL = nil then Exit;
  TotQte := TOBL.GetValue('GL_QTEFACT');
  Ligne := TOBL.GetValue('GL_NUMLIGNE');
  if TOBL.GetValue('GL_TYPEDIM') = 'GEN' then
  begin
    TOBL.PutValue('GL_QTEFACT', TotQte - Qte);
    TOBL.PutValue('GL_QTESTOCK', TotQte - Qte);
    if TOBL.Getvalue('GL_QTEFACT') = 0 then // sup de la ligne GEN si plus de DIM (QTEDIM=0)
    begin
      GS.DeleteRow(Ligne);
      TOBPiece.Detail[Ligne - 1].Free;
      DeleteTobLigneTarif(TobPiece, Ligne - 1);
      NumeroteLignesGC(GS, TOBPiece);
    end;
  end;
end;

function SupDimAZero(GS: THGrid; CodeArticle: string; TOBDim, TOBPiece: TOB; ARow: Integer): Integer;
var NbSup, i, Ligne, Qte: Integer;
  TOBL, TOBItem: TOB;
begin
  NbSup := 0;
  i := ARow;
  Qte := 0;
  TOBL := TOBPiece.Detail[i];
  while TOBL.GetValue('GL_TYPEDIM') = 'DIM' do
  begin
    TOBItem := TOBDim.FindFirst(['GA_ARTICLE'], [TOBL.GetValue('GL_ARTICLE')], False);
    if TOBItem = nil then
    begin
      Ligne := TOBL.GetValue('GL_NUMLIGNE');
      Qte := Qte + TOBL.GetValue('GL_QTEFACT');
      GS.DeleteRow(Ligne);
      TOBPiece.Detail[Ligne - 1].Free;
      DeleteTobLigneTarif(TobPiece, Ligne - 1);
      NbSup := NbSup + 1;
      NumeroteLignesGC(GS, TOBPiece);
    end else i := i + 1;
    if i > TOBPiece.Detail.Count - 1 then break;
    TOBL := TOBPiece.Detail[i];
  end;
  Result := NbSup;
  if TOBDim.Detail.Count = 0 then
  begin
    MiseAJourGrid(GS, TOBPiece, CodeArticle, Qte, ARow);
  end;
end;

function GetSoucheG(NaturePieceG, Etablissement, Domaine: String3): String3;
begin
  {$IFDEF NOMADE}
  Result := GetColonneSQL('SITEPIECE', 'GSP_SOUCHE', 'GSP_NATUREPIECEG="' + NaturePieceG + '" and GSP_CODESITE="' + PCP_LesSites.LeSiteLocal.SSI_CODESITE + '"');
  if (result = '') and (V_PGI.SuperViseur) then
  begin
  {$ENDIF}
    result := '';
    if Etablissement <> '' then Result := GetInfoParPieceCompl(NaturePieceG, Etablissement, 'GPC_SOUCHE');
    if (Result = '') and (Domaine <> '') then Result := GetInfoParPieceDomaine(NaturePieceG, Domaine, 'GDP_SOUCHE');
    if Result = '' then Result := GetInfoParPiece(NaturePieceG, 'GPP_SOUCHE');
  {$IFDEF NOMADE}
  end;
  {$ENDIF}
end;

function GetNumSoucheG(SoucheG: String3): integer;
var Q: TQuery;
begin
  Result := 0;
  if SoucheG = '' then Exit;
  Q := OpenSQL('SELECT SH_NUMDEPART FROM SOUCHE WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '"', True,-1, '', True);
  if not Q.EOF then Result := Q.Fields[0].AsInteger;
  Ferme(Q);
end;

function GetNumPieceG(NaturePieceG, Etablissement, Domaine: String3): integer;
var SoucheG: String3;
begin
  Result := 0;
  SoucheG := GetSoucheG(NaturePieceG, Etablissement, Domaine);
  if SoucheG = '' then Exit;
  Result := GetNumSoucheG(SoucheG);
end;

procedure IncNumSoucheG(SoucheG: String3);
begin
  if SoucheG = '' then Exit;
  ExecuteSQL('UPDATE SOUCHE SET SH_NUMDEPART=SH_NUMDEPART+1 WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '"');
end;

procedure IncNumPieceG(NaturePieceG, Etablissement, Domaine: String3);
var SoucheG: String3;
begin
  if NaturePieceG = '' then Exit;
  SoucheG := GetSoucheG(NaturePieceG, Etablissement, Domaine);
  if SoucheG = '' then Exit;
  IncNumSoucheG(SoucheG);
end;

function HistoPiece(TobPiece_O: Tob): Boolean; { NEWPIECE }
begin
  if Assigned(TobPiece_O) then
    Result := (GetInfoParPiece(TOBPiece_O.GetValue('GP_NATUREPIECEG'), 'GPP_HISTORIQUE') = 'X')
  else
    Result := False;
end;

function SetNumberAttribution(SoucheG: string; NbPiece: integer): integer;
var QQ: TQuery;
  NumDef: Longint;
  Nb, ii: integer;
  Okok: boolean;
begin
  Result := 0;
  if SoucheG = '' then Exit;
  if NbPiece <= 0 then NbPiece := 1;
  ii := 0;
  repeat
    NumDef := -1;
    inc(ii);
    QQ := OpenSQL('SELECT SH_NUMDEPART FROM SOUCHE WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '"', True,-1, '', True);
    if not QQ.EOF then NumDef := QQ.Fields[0].AsInteger;
    Ferme(QQ);
    if NumDef <= 0 then exit;
    Nb := ExecuteSQL('UPDATE SOUCHE SET SH_NUMDEPART=' + IntToStr(NumDef + NbPiece) + ' WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '" AND SH_NUMDEPART='
      + IntToStr(NumDef));
    Okok := (Nb = 1);
  until ((Okok) or (ii > 20));
  if not Okok then
  begin
    V_PGI.IoError := oeUnknown;
    Exit;
  end;
  Result := NumDef;
end;

function SetDefinitiveNumber(TOBPiece, TOBBases, TOBBasesL,TOBEches, TOBNomenclature, TOBAcomptes, TOBPieceRG, TOBBasesRG, TobLigneTarif: TOB; NumDef: integer): boolean;
var SoucheG: String3;
  i, iNum: integer;
  j: integer;
  TOBB: TOB;
begin
  Result := False;
  iNum := 0;
  SoucheG := TOBPiece.GetValue('GP_SOUCHE');
  if SoucheG = '' then Exit;
  if NumDef <= 0 then exit;
  Result := True;
  if NumDef <> TOBPiece.GetValue('GP_NUMERO') then
  begin
    TOBPiece.PutValue('GP_NUMERO', NumDef);
    for i := 0 to TOBPiece.Detail.Count - 1 do
    begin
      if i = 0 then iNum := TOBPiece.Detail[i].GetNumChamp('GL_NUMERO');
      TOBB := TOBPiece.Detail[i];
      TOBB.PutValeur(iNum, NumDef);
    end;
    if TOBBases <> nil then for i := 0 to TOBBases.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBBases.Detail[i].GetNumChamp('GPB_NUMERO');
        TOBB := TOBBases.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;
    if TOBBasesL <> nil then for i := 0 to TOBBasesL.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBBasesL.Detail[i].GetNumChamp('BLB_NUMERO');
        TOBB := TOBBasesL.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;
    if TOBEches <> nil then for i := 0 to TOBEches.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBEches.Detail[i].GetNumChamp('GPE_NUMERO');
        TOBB := TOBEches.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;
    if TOBAcomptes <> nil then
    begin
      TOBAcomptes.AddChampSup('CHGTNUM',False); // JT eQualité 10246 (Pour maj ECRITURE si chgt numéro)
      for i := 0 to TOBAcomptes.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBAcomptes.Detail[i].GetNumChamp('GAC_NUMERO');
          TOBB := TOBAcomptes.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
          // JT Modif libellé acomptes
          TOBB.PutValue('GAC_LIBELLE',Copy('Ac./Règ. ' + DateToStr(TOBPiece.GetValue('GP_DATEPIECE')) + ' Pce. '+ IntToStr(NumDef), 1, 35));
        end;
    end;
    if TOBPieceRG <> nil then for i := 0 to TOBPieceRG.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBPIECERg.Detail[i].GetNumChamp('PRG_NUMERO');
        TOBB := TOBPIECERG.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;
    if TOBBasesRg <> nil then for i := 0 to TOBBasesRg.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBBasesRg.Detail[i].GetNumChamp('PBR_NUMERO');
        TOBB := TOBBasesRG.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;

    if Assigned(TobLigneTarif) then
    begin
      for i := 0 to TobLigneTarif.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TobLigneTarif.Detail[i].GetNumChamp('GL_NUMERO');
        TobB := TobLigneTarif.Detail[i];
        TobB.PutValeur(iNum, NumDef);
        for j := 0 to TobB.Detail.Count - 1 do TobB.Detail[j].PutValue('GLT_NUMERO', NumDef)
      end;
    end;
  end;
end;

function SetNumeroDefinitif(TobPiece, TobBases, TOBBasesL,TobEches, TobNomenclature, TobAcomptes, TobPIeceRG, TobBasesRG, TobLigneTarif : tob): boolean;
var SoucheG: String3;
  QQ: TQuery;
  NumDef: Longint;
  Nb, i, iNum: integer;
  j           : integer;
  TOBB: TOB;
begin
  Result := False;
  NumDef := 0;
  iNum := 0;
  SoucheG := TOBPiece.GetValue('GP_SOUCHE');
  if SoucheG = '' then Exit;
  QQ := OpenSQL('SELECT SH_NUMDEPART FROM SOUCHE WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '"', True,-1, '', True);
  if not QQ.EOF then NumDef := QQ.Fields[0].AsInteger;
  Ferme(QQ);
  if NumDef > 0 then
  begin
    Nb := ExecuteSQL('UPDATE SOUCHE SET SH_NUMDEPART=' + IntToStr(NumDef + 1) + ' WHERE SH_TYPE="GES" AND SH_SOUCHE="' + SoucheG + '"');
    if Nb <> 1 then
    begin
      V_PGI.IoError := oeUnknown;
      Exit;
    end;
    Result := True;
    if NumDef <> TOBPiece.GetValue('GP_NUMERO') then
    begin
      TOBPiece.PutValue('GP_NUMERO', NumDef);
      for i := 0 to TOBPiece.Detail.Count - 1 do
      begin
        if i = 0 then iNum := TOBPiece.Detail[i].GetNumChamp('GL_NUMERO');
        TOBB := TOBPiece.Detail[i];
        TOBB.PutValeur(iNum, NumDef);
      end;
      if TOBBases <> nil then for i := 0 to TOBBases.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBBases.Detail[i].GetNumChamp('GPB_NUMERO');
          TOBB := TOBBases.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;
      if TOBBasesL <> nil then for i := 0 to TOBBasesL.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBBasesL.Detail[i].GetNumChamp('BLB_NUMERO');
          TOBB := TOBBasesL.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;
      if TOBEches <> nil then for i := 0 to TOBEches.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBEches.Detail[i].GetNumChamp('GPE_NUMERO');
          TOBB := TOBEches.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;
      if TOBAcomptes <> nil then for i := 0 to TOBAcomptes.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBAcomptes.Detail[i].GetNumChamp('GAC_NUMERO');
          TOBB := TOBAcomptes.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;
      if TOBPIECERG <> nil then for i := 0 to TOBPIECERG.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBPIECERG.Detail[i].GetNumChamp('PRG_NUMERO');
          TOBB := TOBPIECERG.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;
      if TOBBasesRG <> nil then for i := 0 to TOBBasesRG.Detail.Count - 1 do
        begin
          if i = 0 then iNum := TOBBasesRG.Detail[i].GetNumChamp('PBR_NUMERO');
          TOBB := TOBBasesRG.Detail[i];
          TOBB.PutValeur(iNum, NumDef);
        end;

      if Assigned(TobLigneTarif) then
      begin                                                                                       
        for i := 0 to TobLigneTarif.Detail.Count - 1 do                                           
        begin                                                                                     
          if i = 0 then iNum := TobLigneTarif.Detail[i].GetNumChamp('GL_NUMERO');                 
          TobB := TobLigneTarif.Detail[i];                                                        
          TobB.PutValeur(iNum, NumDef);                                                           
          for j := 0 to TobB.Detail.Count - 1 do TobB.Detail[j].PutValue('GLT_NUMERO', NumDef)    
        end;                                                                                      
      end;                                                                                        
    end;
  end;
end;

function IsTransfert(NaturePiece : String): Boolean;
begin
  if (NaturePiece = 'TEM') or (NaturePiece = 'TRV') or (NaturePiece = 'TRE') then
    Result := True
  else Result := False;
end;

end.
