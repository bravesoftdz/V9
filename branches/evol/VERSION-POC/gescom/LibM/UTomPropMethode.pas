unit UTomPropMethode;

interface
uses M3FP, StdCtrls, Controls, Classes, Dialogs, HStatus, Grids,
  HCtrls, HEnt1, HMsgBox, Hdimension, UTOB, UTOM, AGLInit, EntGC, PropoAffectTrf,
  {$IFDEF EAGLCLIENT}
  Maineagl, eFichList,
  {$ELSE}
  dbTables, DBGrids, db, FE_Main, FichList,
  {$ENDIF}
  forms, sysutils, ComCtrls, HDB, math;

const MaxDimChamp = 10;

type
  TOM_PROPMETHODE = class(TOM)
  private
    CodeDepot: string;
    MethodeSelected: Boolean;
    procedure G_AFFCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure G_AFFCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
    procedure Calculcoeff;
  public

    initChamp: array[1..MaxDimChamp] of string;
    TobListe, TobAffiche: TOB;
    GLISTE, GAFFICHE: THGrid;
    procedure OnClose; override;
    procedure OnArgument(Arguments: string); override;
    procedure OnLoadRecord; override;
    procedure OnUpdateRecord; override;
    procedure OnDeleteRecord; override;
    procedure OnMajListe;
    procedure Changetaillecol;
    procedure OnChangeField(F: TField); override;
    procedure ChangeSelectBtq;
    procedure ClickFlecheDroite;
    procedure ClickFlecheGauche;
    procedure ClickFlecheTous;
    procedure ClickFlecheAucun;
    procedure ClickFlecheHaut;
    procedure ClickFlecheBas;
    procedure RefreshGrid(posListe, posAffiche: integer);
    procedure RefreshBouton;
    procedure SetLastError(Num: integer; ou: string);
  end;

const
  BTN_DROIT = 'DROIT';
  BTN_GAUCHE = 'GAUCHE';
  BTN_HAUT = 'HAUT';
  BTN_BAS = 'BAS';
  BTN_TOUS = 'TOUS';
  BTN_AUCUN = 'AUCUN';
  GRD_LISTE = 'GLISTE';
  GRD_AFFICHE = 'GAFFICHE';

  // libell�s des messages
  TexteMessage: array[1..3] of string = (
    {1}'Vous devez saisir une quantit� ',
    {2}'Saisir une date de d�but et une date de fin de p�riode',
    {3}'La date de fin doit �tre sup�rieure � la date de d�but'
    );

implementation

procedure TOM_PROPMETHODE.OnClose;
var TobMethode: TOB;
begin
  inherited;
  TobAffiche.free;
  TobAffiche := nil;
  TobListe.free;
  TobListe := nil;
  if MethodeSelected then
  begin
    TobMethode := TheTob;
    AlimenteTobMethode(GetField('GTM_CODEMETPAFF'), GetField('GTM_TYPEMETPAFF'),
      GetField('GTM_ARRONDI'), GetField('GTM_UTILCOEFETAB'),
      GetField('GTM_QTEDIM'), GetField('GTM_QTEMINDIM'),
      GetField('GTM_QTEMAXDIM'), DatetoStr(GetField('GTM_DEBPERVTE')),
      DatetoStr(GetField('GTM_FINPERVTE')), TobMethode);
    TheTob := TobMethode;
  end;
end;

procedure TOM_PROPMETHODE.OnArgument(Arguments: string);
begin
  inherited;
  CodeDepot := (ReadTokenSt(Arguments));
  GLISTE := THGrid(GetControl('GLISTE'));
  GAFFICHE := THGRID(GetControl('GAFFICHE'));
  GAFFICHE.OnCellEnter := G_AFFCellEnter;
  GAFFICHE.OnCellExit := G_AFFCellExit;
  MethodeSelected := False;
end;

procedure TOM_PROPMETHODE.OnLoadRecord;
begin
  inherited;
  if GetField('GTM_CODEMETPAFF') = '' then ChangeSelectBtq;
end;

procedure TOM_PROPMETHODE.OnChangeField(F: TField);
var Actif: boolean;
    TypeMet : String;
begin
  inherited;
  if (F.FieldName = 'GTM_TYPEMETPAFF') then
  begin
    TypeMet := GetField('GTM_TYPEMETPAFF');
    if (TypeMet = 'YSM') then Actif := False else Actif := True;
    SetControlEnabled('GTM_QTEDIM', Actif);
    SetControlEnabled('TGTM_QTEDIM', Actif);
    SetControlEnabled('GTM_QTEMINDIM', Actif);
    SetControlEnabled('TGTM_QTEMINDIM', Actif);
    SetControlEnabled('GTM_QTEMAXDIM', Actif);
    SetControlEnabled('TGTM_QTEMAXDIM', Actif);
    SetControlEnabled('GTM_DEBPERVTE', Actif);
    SetControlEnabled('TGTM_DEBPERVTE', Actif);
    SetControlEnabled('GTM_FINPERVTE', Actif);
    SetControlEnabled('TGTM_FINPERVTE', Actif);
    SetControlEnabled('GTM_UTILSTKETAB', Actif);
    SetControlEnabled('GTM_VERIFSTKMAX', Actif);
    SetControlEnabled('GTM_REPARATIO', Actif);
    SetControlEnabled('GTM_UTILCOEFETAB', Actif);
    SetControlEnabled('GTM_ARRONDI', Actif);
    SetControlEnabled('TGTM_ARRONDI', Actif);
    if (TypeMet = 'QTE') then
    begin
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
    end
    else if (TypeMet = 'PDS') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
      SetControlEnabled('GTM_REPARATIO', False);
      SetControlEnabled('GTM_UTILCOEFETAB', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
    end
    else if (TypeMet = 'SMS') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
    end
    else if (TypeMet = 'SMP') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
    end
    else if (TypeMet = 'SXS') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
      SetControlEnabled('GTM_VERIFSTKMAX', False);
      SetControlEnabled('GTM_REPARATIO', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
    end
    else if (TypeMet = 'SXP') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_DEBPERVTE', False);
      SetControlEnabled('TGTM_DEBPERVTE', False);
      SetControlEnabled('GTM_FINPERVTE', False);
      SetControlEnabled('TGTM_FINPERVTE', False);
      SetControlEnabled('GTM_UTILSTKETAB', False);
      SetControlEnabled('GTM_VERIFSTKMAX', False);
      SetControlEnabled('GTM_REPARATIO', False);
    end
    else if (TypeMet = 'PVT') or (TypeMet = 'PVV') then
    begin
      SetControlEnabled('GTM_QTEDIM', False);
      SetControlEnabled('TGTM_QTEDIM', False);
      SetControlEnabled('GTM_QTEMINDIM', False);
      SetControlEnabled('TGTM_QTEMINDIM', False);
      SetControlEnabled('GTM_QTEMAXDIM', False);
      SetControlEnabled('TGTM_QTEMAXDIM', False);
      SetControlEnabled('GTM_VERIFSTKMAX', False);
    end;
    Changetaillecol;
  end
  else if (F.FieldName = 'GTM_UTILCOEFETAB') then Changetaillecol;
end;

procedure TOM_PROPMETHODE.OnUpdateRecord;
begin
  inherited;
  if (GetField('GTM_TYPEMETPAFF') = 'QTE') and (GetField('GTM_QTEDIM') = 0) then
  begin
    SetLastError(1, 'GTM_QTEDIM');
    exit;
  end
  else if (GetField('GTM_TYPEMETPAFF') = 'SMS') and (GetField('GTM_QTEMINDIM') = 0) then
  begin
    SetLastError(1, 'GTM_QTEMINDIM');
    exit;
  end
  else if (GetField('GTM_TYPEMETPAFF') = 'SXS') and (GetField('GTM_QTEMAXDIM') = 0) then
  begin
    SetLastError(1, 'GTM_QTEMAXDIM');
    exit;
  end
  else if (GetField('GTM_TYPEMETPAFF') = 'PVT') then
  begin
    if (GetField('GTM_DEBPERVTE') = iDate1900) or (GetField('GTM_FINPERVTE') = iDate1900) then
    begin
      SetLastError(2, '');
      exit;
    end;
    if (GetField('GTM_DEBPERVTE') > GetField('GTM_FINPERVTE')) then
    begin
      SetLastError(3, '');
      exit;
    end;
  end
  else if (GetField('GTM_TYPEMETPAFF') <> 'QTE') then SetField('GTM_QTEDIM', 0)
  else if (GetField('GTM_TYPEMETPAFF') <> 'SMS') then SetField('GTM_QTEMINDIM', 0)
  else if (GetField('GTM_TYPEMETPAFF') <> 'SXS') then SetField('GTM_QTEMAXDIM', 0)
  else if (GetField('GTM_TYPEMETPAFF') <> 'PVT') then
  begin
    SetField('GTM_DEBPERVTE', iDate1900);
    SetField('GTM_FINPERVTE', iDate1900);
  end;
  OnMajListe;
end;

procedure TOM_PROPMETHODE.OnDeleteRecord;
var stReq: string;
begin
  inherited;
  stReq := 'delete from PROPMETETAB where GTQ_CODEMETPAFF="' + GetField('GTM_CODEMETPAFF') + '"';
  ExecuteSQL(stReq);
end;

procedure TOM_PROPMETHODE.SetLastError(Num: integer; ou: string);
begin
  if ou <> '' then SetFocusControl(ou);
  LastError := Num;
  LastErrorMsg := TexteMessage[LastError];
  MethodeSelected := False;
end;

procedure TOM_PROPMETHODE.RefreshGrid(posListe, posAffiche: integer);
begin
  TobAffiche.PutGridDetail(GAFFICHE, False, False, 'LIBELLE;POIDS;COEFF', True);
  TobListe.PutGridDetail(GLISTE, False, False, 'LIBELLE', True);
  GAFFICHE.Row := Min(posAffiche, GAFFICHE.RowCount - 1);
  GLISTE.Row := Min(posListe, GLISTE.RowCount - 1);
  RefreshBouton;
end;

// Boutons enable / disable

procedure TOM_PROPMETHODE.RefreshBouton;
begin
  SetControlEnabled('BFLECHEDROITE', TobListe.Detail.Count > 0);
  SetControlEnabled('BFLECHEGAUCHE', TobAffiche.Detail.Count > 0);
  SetControlEnabled('BFLECHEHAUT', GAFFICHE.Row > 1);
  SetControlEnabled('BFLECHEBAS', GAFFICHE.Row < GAFFICHE.RowCount - 1);
  SetControlEnabled('BFLECHETOUS', TobListe.Detail.Count > 0);
  SetControlEnabled('BFLECHEAUCUN', TobAffiche.Detail.Count > 0);
end;

procedure TOM_PROPMETHODE.ClickFlecheDroite;
var indiceFille: integer;
begin
  // Y a t il quelque chose de s�lectionn� ?
  if GLISTE.Row < 0 then exit;
  // Changement du parent de l'�l�ment de la liste des �tablissements
  if TobAffiche.Detail.Count > 0 then indiceFille := GAFFICHE.Row else indiceFille := 0;
  TobListe.detail[GLISTE.Row - 1].ChangeParent(TobAffiche, indiceFille);
  RefreshGrid(GLISTE.Row, GAFFICHE.Row + 1);
end;

procedure TOM_PROPMETHODE.ClickFlecheGauche;
var indiceFille: integer;
begin
  // Y a t il quelque chose de s�lectionn� ?
  if GAFFICHE.Row < 0 then exit;
  // Changement du parent de l'�l�ment des �tablissements affich�s
  if TobListe.Detail.Count > 0 then indiceFille := GLISTE.Row else indiceFille := 0;
  TobAffiche.detail[GAFFICHE.Row - 1].PutValue('POIDS', 0);
  TobAffiche.detail[GAFFICHE.Row - 1].PutValue('COEFF', 1.0);
  TobAffiche.detail[GAFFICHE.Row - 1].ChangeParent(TobListe, indiceFille);
  RefreshGrid(GLISTE.Row + 1, GAFFICHE.Row);
end;

procedure TOM_PROPMETHODE.ClickFlecheTous;
var indiceFille, iGrd, posliste: integer;
begin
  if GLISTE.RowCount < 2 then exit;
  // Changement du parent de l'�l�ment de la liste des �tablissements
  if GAFFICHE.RowCount > 2 then indiceFille := GAFFICHE.Row else indiceFille := 0;
  posliste := TobListe.detail.count - 1;
  for iGrd := 0 to posliste do TobListe.detail[0].ChangeParent(TobAffiche, indiceFille + iGrd);
  RefreshGrid(1, indiceFille + posliste);
end;

procedure TOM_PROPMETHODE.ClickFlecheAucun;
var indiceFille, iGrd, posaffiche: integer;
begin
  if GAFFICHE.RowCount < 2 then exit;
  // Changement du parent de l'�l�ment de la liste des �tablissements
  posaffiche := TobAffiche.detail.count - 1;
  if GLISTE.RowCount > 2 then indiceFille := GLISTE.Row else indiceFille := 0;
  for iGrd := 0 to posaffiche do TobAffiche.detail[0].ChangeParent(TobListe, indiceFille + iGrd);
  RefreshGrid(indiceFille + posaffiche, 1);
end;

procedure TOM_PROPMETHODE.ClickFlecheHaut;
begin
  if GAFFICHE.Row < 1 then exit;
  // Changement de l'indice dans la Tob parent
  TobAffiche.detail[GAFFICHE.Row - 1].ChangeParent(TobAffiche, GAFFICHE.Row - 2);
  RefreshGrid(GLISTE.Row, GAFFICHE.Row - 1);
end;

procedure TOM_PROPMETHODE.ClickFlecheBas;
begin
  if GAFFICHE.Row > GAFFICHE.RowCount - 2 then exit;
  // Changement de l'indice dans la Tob parent
  TobAffiche.detail[GAFFICHE.Row - 1].ChangeParent(TobAffiche, GAFFICHE.Row);
  RefreshGrid(GLISTE.Row, GAFFICHE.Row + 1);
end;

procedure TOM_PROPMETHODE.G_AFFCellEnter(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  if GAFFICHE.Col = 0 then GAFFICHE.Col := 1;
  if (GetField('GTM_TYPEMETPAFF') = 'PDS') and (GAFFICHE.Col = 2) then GAFFICHE.Col := 1;
  if (GetField('GTM_TYPEMETPAFF') <> 'PDS') and (GAFFICHE.Col = 1) then GAFFICHE.Col := 2;
end;

procedure TOM_PROPMETHODE.G_AFFCellExit(Sender: TObject; var ACol, ARow: Integer; var Cancel: Boolean);
begin
  if (Acol = 1) then TobAffiche.detail[ARow - 1].PutValue('POIDS', ValeurI(GAFFICHE.Cells[Acol, ARow]));
  if (Acol = 2) then TobAffiche.detail[ARow - 1].PutValue('COEFF', Valeur(GAFFICHE.Cells[Acol, ARow]));
  if (GetField('GTM_TYPEMETPAFF') = 'PDS') then Calculcoeff;
end;

procedure TOM_PROPMETHODE.Calculcoeff;
var TOBT: TOB;
  i_ind, totpoids: integer;
  totcoeff: double;
begin
  totpoids := 0;
  for i_ind := 0 to TobAffiche.Detail.count - 1 do
  begin
    TobT := TobAffiche.Detail[i_ind];
    totpoids := totpoids + TOBT.GetValue('POIDS');
  end;
  for i_ind := 0 to TobAffiche.Detail.count - 1 do
  begin
    TobT := TobAffiche.Detail[i_ind];
    if TOBT.GetValue('POIDS') <> 0 then
      TOBT.PutValue('COEFF', Arrondi((TOBT.GetValue('POIDS') / totpoids) * 100.0, 2))
    else
      TOBT.PutValue('COEFF', 0.0);
  end;
  totcoeff := 0;
  for i_ind := 0 to TobAffiche.Detail.count - 1 do
  begin
    TobT := TobAffiche.Detail[i_ind];
    totcoeff := totcoeff + TOBT.GetValue('COEFF');
  end;
  if totcoeff <> 100.0 then
  begin
    totcoeff := 100.0 - totcoeff;
    for i_ind := 0 to TobAffiche.Detail.count - 1 do
    begin
      if TobAffiche.Detail[i_ind].GetValue('POIDS') <> 0 then
      begin
        TobAffiche.Detail[i_ind].PutValue('COEFF', (TobAffiche.Detail[i_ind].GetValue('COEFF') + totcoeff));
        break;
      end;
    end;
  end;
  RefreshGrid(GLISTE.Row, GAFFICHE.Row);
end;

procedure AGLOnChangeSelectBtq(Parms: array of variant; nb: integer);
var F: TForm;
  OM: TOM;
begin
  F := TForm(Longint(Parms[0]));
  if (F is TFFicheListe)
    then OM := TFFicheListe(F).OM
  else exit;
  if (OM is TOM_PROPMETHODE) then TOM_PROPMETHODE(OM).ChangeSelectBtq else exit;
end;

procedure TOM_PROPMETHODE.ChangeSelectBtq;
var iListe, iEtab, i_ind: integer;
  bTrouve: boolean;
  QQ, QQ2: TQuery;
  TobEtab, TobTemp, TobT: TOB;
begin
  inherited;
  if not (ctxMode in V_PGI.PGIContexte) then exit;
  // Chargement de la liste des �tablissements et du param�trage existant.
  if TobListe <> nil then TobListe.free;
  if TobAffiche <> nil then TobAffiche.free;
  TobListe := TOB.CREATE('Liste �tablissements', nil, -1);
  TobAffiche := TOB.CREATE('Etablissements affich�s', nil, -1);
  TobEtab := TOB.CREATE('LEtab', nil, -1);
  TobTemp := TOB.Create('', nil, -1);
  // Chargement param�trage sauvegard�
  QQ2 := OpenSQL('select GTQ_ETABLISSEMENT,ET_LIBELLE,GTQ_COEFREPAR,GTQ_POIDS from PROPMETETAB ' +
    'left join ETABLISS on ET_ETABLISSEMENT = GTQ_ETABLISSEMENT ' +
    //  'where GTQ_CODEMETPAFF = "'+GetField ('GTM_CODEMETPAFF')+'" order by GTQ_LIGMETPAFF',True) ;
    'where GTQ_CODEMETPAFF = "' + GetControltext('GTM_CODEMETPAFF') + '" order by GTQ_LIGMETPAFF', True);

  if not QQ2.eof then TobTemp.LoadDetailDB('', '', '', QQ2, false);

  for i_ind := 0 to TobTemp.Detail.count - 1 do
  begin
    TobT := TOB.Create('SelEtablissement', TobEtab, -1);
    TobT.AddChampSup('ETABLISSEMENT', False);
    TobT.AddChampSup('LIBELLE', False);
    TobT.AddChampSup('COEFF', False);
    TobT.AddChampSup('POIDS', False);
    TobT.InitValeurs;
    TobT.PutValue('ETABLISSEMENT', TobTemp.Detail[i_ind].GetValue('GTQ_ETABLISSEMENT'));
    TobT.PutValue('LIBELLE', TobTemp.Detail[i_ind].GetValue('ET_LIBELLE'));
    TobT.PutValue('COEFF', TobTemp.Detail[i_ind].GetValue('GTQ_COEFREPAR'));
    TobT.PutValue('POIDS', TobTemp.Detail[i_ind].GetValue('GTQ_POIDS'));
  end;
  TobTemp.free;
  Ferme(QQ2);

  TobTemp := TOB.Create('', nil, -1);
  QQ := OpenSQL('select ET_ETABLISSEMENT,ET_LIBELLE,ET_ABREGE from ETABLISS order by ET_ETABLISSEMENT', True);
  if not QQ.eof then TobTemp.LoadDetailDB('', '', '', QQ, false);
  for i_ind := 0 to TobTemp.Detail.count - 1 do
  begin
    //if (TobTemp.Detail[i_ind].GetValue('ET_ETABLISSEMENT') <> CodeDepot) then
    //  begin
    TobT := TOB.Create('Etablissement', TobListe, -1);
    TobT.AddChampSup('ETABLISSEMENT', False);
    TobT.AddChampSup('LIBELLE', False);
    TobT.AddChampSup('COEFF', False);
    TobT.AddChampSup('POIDS', False);
    TobT.InitValeurs;
    TobT.PutValue('ETABLISSEMENT', TobTemp.Detail[i_ind].GetValue('ET_ETABLISSEMENT'));
    TobT.PutValue('LIBELLE', TobTemp.Detail[i_ind].GetValue('ET_LIBELLE'));
    TobT.PutValue('COEFF', 1.0);
    TobT.PutValue('POIDS', 0);
    //  end;
  end;
  TobTemp.free;
  Ferme(QQ);

  if TobEtab.Detail.Count > 0 then
  begin
    // Chargement de la liste des �tablissements dans TobListe
    // et bascule des �tablissements de TobEtat dans TobAffiche tri� suivant l'ordre d�finit dans TobEtat
    iEtab := 0;
    while iEtab < TobEtab.Detail.Count do
    begin
      iListe := 0;
      bTrouve := False;
      while (not bTrouve) and (iListe < TobListe.Detail.Count) do
      begin
        bTrouve := (TobListe.Detail[iListe].GetValue('ETABLISSEMENT')
          = TobEtab.Detail[iEtab].GetValue('ETABLISSEMENT'));
        inc(iListe);
      end;
      if bTrouve then // Transfert dans TobAffiche
      begin
        TobListe.Detail[iListe - 1].PutValue('COEFF', TobEtab.Detail[iEtab].GetValue('COEFF'));
        TobListe.Detail[iListe - 1].PutValue('POIDS', TobEtab.Detail[iEtab].GetValue('POIDS'));
        TobListe.Detail[iListe - 1].ChangeParent(TobAffiche, -1);
      end;
      inc(iEtab);
    end;
  end else
  begin
    // Param�trage non pr�d�fini, chargement dans TobAffiche tri� par code �tablissement
    for iListe := 0 to TobListe.Detail.Count - 1 do
    begin
      TobListe.detail[0].ChangeParent(TobAffiche, iListe);
    end;
  end;
  // Affichage des tobs
  GLISTE := THGrid(GetControl('GLISTE'));
  GAFFICHE := THGrid(GetControl('GAFFICHE'));
  TobAffiche.PutGridDetail(GAFFICHE, False, False, 'LIBELLE;POIDS;COEFF', True);
  TobListe.PutGridDetail(GLISTE, False, False, 'LIBELLE', True);
  Changetaillecol;
  RefreshBouton;
  TobEtab.free;
end;

procedure TOM_PROPMETHODE.Changetaillecol;
begin
  GLISTE.ColWidths[0] := 172;
  GLISTE.ColAligns[0] := taLeftJustify;
  GAFFICHE.ColWidths[0] := 144;
  GAFFICHE.ColAligns[0] := taLeftJustify;
  GAFFICHE.ColWidths[1] := 50;
  GAFFICHE.ColAligns[1] := taRightJustify;
  GAFFICHE.ColWidths[2] := 50;
  GAFFICHE.ColAligns[2] := taRightJustify;
  GAFFICHE.Col := 1;
  if (GetField('GTM_TYPEMETPAFF') <> 'PDS') then
  begin
    GAFFICHE.Col := 2;
    GAFFICHE.ColWidths[0] := 194;
    GAFFICHE.ColWidths[1] := 0;
  end;
  if (GetField('GTM_UTILCOEFETAB') = '-')
    and (GetField('GTM_TYPEMETPAFF') <> 'PDS') then
  begin
    GAFFICHE.ColWidths[0] := 244;
    GAFFICHE.ColWidths[1] := 0;
    GAFFICHE.ColWidths[2] := 0;
  end;
  if (GAFFICHE.ColWidths[1] = 0) and (GAFFICHE.ColWidths[2] = 0) then
  begin
    GAFFICHE.Options := GAFFICHE.Options + [goRowSelect];
    GAFFICHE.Options := GAFFICHE.Options - [goEditing];
  end else
  begin
    GAFFICHE.Options := GAFFICHE.Options - [goRowSelect];
    GAFFICHE.Options := GAFFICHE.Options + [goEditing];
  end;
  GAFFICHE.ColFormats[1] := '##';
  GAFFICHE.ColFormats[2] := '# ##0.00';
end;

procedure AGLOnMajListe(Parms: array of variant; nb: integer);
var F: TForm;
  OM: TOM;
begin
  F := TForm(Longint(Parms[0]));
  if (F is TFFicheListe)
    then OM := TFFicheListe(F).OM
  else exit;
  if (OM is TOM_PROPMETHODE) then TOM_PROPMETHODE(OM).OnMajListe else exit;
end;

procedure TOM_PROPMETHODE.OnMajListe;
var stReq: string;
  iAffiche, indiceFille: integer;
  TOBT: TOB;
  maj: boolean;
begin
  if ctxMode in V_PGI.PGIContexte then
  begin
    if (GetField('GTM_TYPEMETPAFF') = 'PDS') then Calculcoeff;

    stReq := 'delete from PROPMETETAB where GTQ_CODEMETPAFF="' + GetField('GTM_CODEMETPAFF') + '"';
    ExecuteSQL(stReq);
    // Svgde des �tablissements affich�s en cconsultation multi-d�p�ts : position > 100
    iAffiche := 0;
    while iAffiche < TobAffiche.Detail.count do
    begin
      TobT := TobAffiche.Detail[iAffiche];
      maj := True;
      if (GetField('GTM_TYPEMETPAFF') = 'PDS')
        and (TobAffiche.Detail[iAffiche].GetValue('POIDS') = 0) then maj := False;

      if maj then
      begin
        stReq := 'insert into PROPMETETAB (GTQ_CODEMETPAFF,GTQ_LIGMETPAFF,GTQ_ETABLISSEMENT,GTQ_COEFREPAR,GTQ_POIDS)' +
          ' values ("' + GetField('GTM_CODEMETPAFF') + '",' + inttostr(iAffiche) +
          ',"' + TobT.GetValue('ETABLISSEMENT') + '",' + StrfPoint(TobT.GetValue('COEFF')) + ',' + inttostr(TobT.GetValue('POIDS')) + ')';
        ExecuteSQL(stReq);
      end else
      begin
        if TobListe.Detail.Count > 0 then indiceFille := GLISTE.Row else indiceFille := 0;
        TobT.ChangeParent(TobListe, indiceFille);
        RefreshGrid(GLISTE.Row + 1, GAFFICHE.Row);
        iAffiche := iAffiche - 1;
      end;
      inc(iAffiche);
    end;
  end;
end;

function AGLOnSelListe(Parms: array of variant; nb: integer): variant;
var F: TForm;
  OM: TOM;
begin
  Result := True;
  F := TForm(Longint(Parms[0]));
  if (F is TFFicheListe)
    then OM := TFFicheListe(F).OM
  else exit;
  if (OM is TOM_PROPMETHODE) then TOM_PROPMETHODE(OM).MethodeSelected := True else exit;
end;

procedure AGLOnClickBouton2(Parms: array of variant; nb: integer);
var F: TForm;
  OM: TOM;
begin
  F := TForm(Longint(Parms[0]));
  if (F is TFFicheListe) then OM := TFFicheListe(F).OM else exit;
  if (OM is TOM_PROPMETHODE) then
  begin
    if (Parms[1] = GRD_LISTE) or (Parms[1] = GRD_AFFICHE) then TOM_PROPMETHODE(OM).RefreshBouton
    else
    begin
      //Ces 2 lignes permettent de d'afficher le message : voulez-vous enregistrer... quand on s�lectionne une m�thode
      TOM_PROPMETHODE(OM).DS.Edit;
      TOM_PROPMETHODE(OM).SetField('GTM_LIBMETPAFF', TOM_PROPMETHODE(OM).GetField('GTM_LIBMETPAFF'));
      if Parms[1] = BTN_DROIT then TOM_PROPMETHODE(OM).ClickFlecheDroite
      else if Parms[1] = BTN_GAUCHE then TOM_PROPMETHODE(OM).ClickFlecheGauche
      else if Parms[1] = BTN_HAUT then TOM_PROPMETHODE(OM).ClickFlecheHaut
      else if Parms[1] = BTN_BAS then TOM_PROPMETHODE(OM).ClickFlecheBas
      else if Parms[1] = BTN_TOUS then TOM_PROPMETHODE(OM).ClickFlecheTous
      else if Parms[1] = BTN_AUCUN then TOM_PROPMETHODE(OM).ClickFlecheAucun;
    end;
  end;
end;

initialization
  registerclasses([TOM_PROPMETHODE]);
  RegisterAglProc('OnChangeSelectBtq', True, 1, AGLOnChangeSelectBtq);
  RegisterAglProc('OnMajListe', True, 1, AGLOnMajListe);
  RegisterAglFunc('OnSelListe', True, 1, AGLOnSelListe);
  RegisterAglProc('OnClickBouton2', True, 1, AGLOnClickBouton2);
end.
