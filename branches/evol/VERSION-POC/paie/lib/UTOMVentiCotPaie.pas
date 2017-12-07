{***********UNITE*************************************************
Auteur  ...... : PH
Cr�� le ...... : 11/09/2001
Modifi� le ... : 11/09/2001
Description .. : TOM gestion des ventilations des cotisations pour les
Suite ........ : �critures comptables
Mots clefs ... : PAIE;GENERCOMPTA
*****************************************************************
PT1 SB 29/11/2001 V563 On force la validation avant la Duplication
PT2 SB 30/11/2001 V563 Dysfonctionnement test code existant sur Duplication
PT3 SB 13/12/2001 V570 Fiche de bug n� 279
                       Test code existant ne test pas bon num�ro de dossier
// **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
PT4 PH 03/06/2004 V_500 FQ 11060 Controle duplication
PT5 PH 06/07/2004 V_50 FQ 11001 Contr�le des champs saisis
PT6 PH 08/11/2004 V_60 Duplication DOS en STD
PT7 SB 10/06/2005 V_65 CWAS : Chargement tablette compatibilite CWAS
PT8 GGS 05/02/2007 V_80 Journal �v�nements
PT8-2 GGS 26/04/2007 V_80 Revu gestion Trace
PT8-3 GGS 26/04/2007 V_80 Revu gestion Trace pour duplication
PT9 FC 06/11/2007 V_80 Correction bug journal des �v�nement quand cr�ation (lib Modification au lieu de Cr�ation)
}
unit UTOMVentiCotPaie;

interface
uses Windows, StdCtrls, Controls, Classes, Graphics, forms, sysutils, ComCtrls, HTB97,
{$IFNDEF EAGLCLIENT}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} HDB, DBCtrls, Fe_Main, Fiche,
{$ELSE}
  MaineAgl, eFiche, UtileAGL,
{$ENDIF}
  Grids, HCtrls, HEnt1, EntPaie, HMsgBox, UTOM, UTOB, Vierge, P5Def,
  AGLInit, PGOutils,PgOutils2,
  PAIETOM;                            //PT8
type
  TOM_VENTICOTPAIE = class(PGTOM)     //PT8  TOM devent PGTOM
  private
    PGPredef, PGNodossier, PGCot, mode, DerniereCreate: string;
    CEG, STD, DOS, LectureSeule: Boolean;
    Loaded, OnFerme: boolean;
    MsgError: integer;
    Trace: TStringList;                                            //PT8
    LeStatut:TDataSetState; //PT9
    procedure DupliquerVentilCot(Sender: TObject);
  public
    procedure OnArgument(Arguments: string); override;
    procedure OnLoadRecord; override;
    procedure OnNewRecord; override;
    procedure OnChangeField(F: TField); override;
    procedure OnUpdateRecord; override;
    procedure OnAfterUpdateRecord; override;
  end;

implementation


procedure TOM_VENTICOTPAIE.OnArgument(Arguments: string);
var
  st: string;
  Btn: TToolBarButton97;
begin
  inherited;
//PT8-2   Trace := TStringList.Create ;         //PT8
  st := Trim(Arguments);
  PGPredef := '';
  PGNodossier := '';
  PGPredef := ReadTokenSt(st); // Recup Predefini
  PGNodossier := ReadTokenSt(st); // Recup Nodossier
  PGCot := ReadTokenSt(st); // Recup Cotisation
  Btn := TToolBarButton97(GetControl('BDUPLIQUER'));
  if btn <> nil then Btn.OnClick := DupliquerVentilCot;
  // DEB PT4
  if Pos('CREATION', St) > 1 then
  begin
    if PGPredef = 'CEG' then PGPredef := 'STD';
    SetControlEnabled('BDUPLIQUER', False);
  end
  else SetControlEnabled('BDUPLIQUER', True);
  SetControlVisible('BINSERT', FALSE);
  {
  SetControlEnabled('BDUPLIQUER', False)
  else SetControlEnabled('BDUPLIQUER', True)}
// FIN PT4
end;


procedure TOM_VENTICOTPAIE.OnChangeField(F: TField);
var
  Pred, Rubrique: string;
begin
  inherited;
  if mode = 'DUPLICATION' then exit;
  MsgError := 0;
  if Loaded then
  begin
    Loaded := FALSE;
    exit;
  end;
  if (F.FieldName = 'PVT_PREDEFINI') and (DS.State = dsinsert) then
  begin
    Pred := GetField('PVT_PREDEFINI');
    Rubrique := (GetField('PVT_RUBRIQUE'));
    if Pred = '' then exit;
    AccesPredefini('TOUS', CEG, STD, DOS);
    if (Pred = 'CEG') and (CEG = FALSE) then
    begin
      PGIBox('Vous ne pouvez pas ventiler de rubrique de cotisation pr�d�fini CEGID', 'Acc�s refus�');
      SetControlProperty('PVT_PREDEFINI', 'Value', 'DOS');
      SetField('PVT_PREDEFINI', 'DOS');
      MsgError := 1;
    end;
    if (Pred = 'STD') and (STD = FALSE) then
    begin
      PGIBox('Vous ne pouvez ventiler de rubrique de cotisation pr�d�fini Standard', 'Acc�s refus�');
      SetControlProperty('PVT_PREDEFINI', 'Value', 'DOS');
      SetField('PVT_PREDEFINI', 'DOS');
      MsgError := 1;
    end;
    PGPredef := GetField('PVT_PREDEFINI');
  end;

  if (ds.state in [dsBrowse]) then
  begin
    if LectureSeule then
    begin
      PaieLectureSeule(TFFiche(Ecran), True);
      SetControlEnabled('BDelete', False);
    end;
    SetControlEnabled('BInsert', True);
    SetControlEnabled('PVT_PREDEFINI', False);
    SetControlEnabled('PVT_RUBRIQUE', False);
  end;

end;

procedure TOM_VENTICOTPAIE.OnLoadRecord;
begin
  inherited;
  if not (DS.State in [dsInsert]) then DerniereCreate := '';
  if mode = 'DUPLICATION' then exit;
  Loaded := True;
  AccesPredefini('TOUS', CEG, STD, DOS);
  LectureSeule := FALSE;

  SetControlEnabled('BInsert', True);

  if DS.State in [dsInsert] then
  begin
    LectureSeule := FALSE;
    PaieLectureSeule(TFFiche(Ecran), False);
    //   SetControlEnabled('PVT_PREDEFINI',True);
     //  SetControlEnabled('PVT_RUBRIQUE',True);
    SetControlEnabled('BInsert', False);
    SetControlEnabled('BDelete', False);
  end;
  // DEB PT4
  if DS.State in [dsInsert] then
  begin
    if (Getfield('PVT_PREDEFINI') = 'DOS') or (Getfield('PVT_PREDEFINI') = 'STD') then
      SetControlEnabled('PVT_PREDEFINI', true);
  end
  else SetControlEnabled('PVT_PREDEFINI', False);
  SetControlEnabled('PVT_RUBRIQUE', False);
  // FIN PT4
  if (Getfield('PVT_PREDEFINI') = 'CEG') then
  begin
    LectureSeule := (CEG = False);
    PaieLectureSeule(TFFiche(Ecran), (CEG = False));
    SetControlEnabled('BDelete', CEG);
  end;
  if (Getfield('PVT_PREDEFINI') = 'STD') then
  begin
    LectureSeule := (STD = False);
    PaieLectureSeule(TFFiche(Ecran), (STD = False));
    SetControlEnabled('BDelete', STD);
  end;
  if (Getfield('PVT_PREDEFINI') = 'DOS') then
  begin
    LectureSeule := False;
    PaieLectureSeule(TFFiche(Ecran), (DOS = False));
    SetControlEnabled('BDelete', DOS);
  end;
  PaieConceptPlanPaie(Ecran);
end;

procedure TOM_VENTICOTPAIE.OnNewRecord;
begin
  inherited;
  if mode = 'DUPLICATION' then exit;
  Loaded := TRUE;
  // DEB PT4
  if PGPredef <> '' then
  begin
    setControlEnabled('PVT_PREDEFINI', TRUE);
    SetField('PVT_PREDEFINI', PGPredef);
  end;
  // FIN PT4

  if PGNodossier <> '' then SetField('PVT_NODOSSIER', PGNodossier);
  if PGCot <> '' then SetField('PVT_RUBRIQUE', PGCot);
end;

procedure TOM_VENTICOTPAIE.OnUpdateRecord;
var Predef : String;
begin
  inherited;
  OnFerme := False;
  LeStatut := DS.State; //PT9
  if (DS.State in [dsInsert]) then
    DerniereCreate := GetField('PVT_RUBRIQUE')
  else
    if (DerniereCreate = GetField('PVT_RUBRIQUE')) then OnFerme := True; // le bug arrive on se casse !!!
  if mode = 'DUPLICATION' then exit;
  if (DS.State = dsinsert) then
  begin
    if (GetField('PVT_PREDEFINI') <> 'DOS') then
      SetField('PVT_NODOSSIER', '000000')
    else
      // **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
      SetField('PVT_NODOSSIER', PgRendNoDossier());
  end;
  // PT4  SetField('PVT_PREDEFINI', GetField('PVT_PREDEFINI'));
  LastError := MsgError;
  // DEB PT5
  if (GetField('PVT_RACINE1') = '') and (GetField('PVT_RACINE2') = '') then
  begin
    PgiBox('Vous devez renseigner au moins une racine', Ecran.caption);
    LastError := 1;
  end;
  if (GetField('PVT_RACINE1') <> '') then
  begin
    if (GetField('PVT_PARTSALPAT1') = '') then PgiBox('Vous devez renseigner le type d''alimentation 1', Ecran.caption);
    if (GetField('PVT_SENS1') = '') then PgiBox('Vous devez renseigner le sens 1', Ecran.caption);
    if (GetField('PVT_PARTSALPAT1') = '') or (GetField('PVT_SENS1') = '') then LastError := 2;
  end;
  if (GetField('PVT_RACINE2') <> '') then
  begin
    if (GetField('PVT_PARTSALPAT2') = '') then PgiBox('Vous devez renseigner le type d''alimentation 2', Ecran.caption);
    if (GetField('PVT_SENS2') = '') then PgiBox('Vous devez renseigner le sens 2', Ecran.caption);
    if (GetField('PVT_PARTSALPAT2') = '') or (GetField('PVT_SENS2') = '') then LastError := 2;
  end;
  // FIN PT5
  PreDef := GetField('PVT_PREDEFINI');
  if (DS.State in [dsInsert]) then
  begin
    if (PreDef = 'CEG') AND (NOT CEG) then
    begin
    PgiBox('Vous n''�tes pas autoris� � cr�er une ventilation CEGID', Ecran.caption);
    LastError := 1;
    end
    else
    if (PreDef = 'STD') AND (NOT STD) then
    begin
    PgiBox('Vous n''�tes pas autoris� � cr�er une ventilation standard', Ecran.caption);
    LastError := 1;
    end
    else
    if (PreDef = 'DOS') AND (NOT DOS) then
    begin
    PgiBox('Vous n''�tes pas autoris� � cr�er une ventilation dossier', Ecran.caption);
    LastError := 1;
    end;
  end;
end;

procedure TOM_VENTICOTPAIE.OnAfterUpdateRecord;
var
  even : boolean;  //PT8
begin
  inherited;
  Trace := TStringList.Create ;         //PT8-2
  even := IsDifferent(dernierecreate,PrefixeToTable(TFFiche(Ecran).TableName),'PVT_RUBRIQUE',TFFiche(Ecran).LibelleName,Trace,TFFiche(Ecran),LeStatut);  //PT8 //PT9
  FreeAndNil (Trace);  //PT8-2  Trace.free;
  if OnFerme then Ecran.Close;
end;



procedure TOM_VENTICOTPAIE.DupliquerVentilCot(Sender: TObject);
var
{$IFNDEF EAGLCLIENT}
  Code: THDBEdit;
{$ELSE}
  Code: THEdit;
{$ENDIF}
  Rubrique : string;
  Champ: array[1..3] of Hstring;
  Valeur: array[1..3] of variant;
  Ok: Boolean;
  st : string;   //PT8-3
  begin
  // PT4  TFFiche(Ecran).BValider.Click; //PT1
  mode := 'DUPLICATION';
  Rubrique := GetField('PVT_RUBRIQUE');
  AglLanceFiche('PAY', 'CODE', '', '', 'VENT;' + Rubrique + '; ;4');
  if PGCodeDupliquer <> '' then
  begin
    Champ[1] := 'PVT_PREDEFINI';
    Valeur[1] := PGCodePredefini;
    // **** Refonte acc�s V_PGI_env ***** V_PGI_env.nodossier remplac� par PgRendNoDossier() *****
    Champ[2] := 'PVT_NODOSSIER';
    Valeur[2] := PgRendNoDossier();
    if PGCodePredefini = 'DOS' then Valeur[2] := PgRendNoDossier() //PT3
    else Valeur[2] := '000000'; //PT3
    Champ[3] := 'PVT_RUBRIQUE';
    Valeur[3] := PGCodeDupliquer; //PT2 StrToInt
    Ok := RechEnrAssocier('VENTICOTPAIE', Champ, Valeur);
    if Ok = False then //Test si code existe ou non
    begin
{$IFNDEF EAGLCLIENT}
      Code := THDBEdit(GetControl('PVT_RUBRIQUE'));
{$ELSE}
      Code := THEdit(GetControl('PVT_RUBRIQUE'));
{$ENDIF}
      if (code <> nil) then DupliquerPaie(TFFiche(Ecran).TableName, Ecran);
      SetField('PVT_RUBRIQUE', PGCodeDupliquer);
      SetField('PVT_PREDEFINI', PGCodePredefini);
      // PT4 AccesFicheDupliquer(TFFiche(Ecran), PGCodePredefini, NoDossier, LectureSeule);
      // PT6 Duplication DOS en STD
      if GetField ('PVT_PREDEFINI') = 'DOS' then SetField('PVT_NODOSSIER', PgRendNoDossier())
      else SetField('PVT_NODOSSIER', '000000');
      // FIN PT6
      SetControlEnabled('PVT_RUBRIQUE', False);
      SetControlEnabled('PVT_PREDEFINI', False);
//PT8-3
      if Assigned(Trace) then FreeAndNil(Trace);
      Trace := TStringList.Create;
      st := 'Duplication de la rubrique '+Rubrique;
      Trace.add (st);
      st := 'Cr�ation de la rubrique '+ GetField('PVT_RUBRIQUE');
      Trace.add (st);
      EnDupl := 'OUI';
      IsDifferent(dernierecreate, PrefixeToTable(TFFiche(Ecran).TableName), TFFiche(Ecran).CodeName, TFFiche(Ecran).LibelleName, Trace, TFFiche(Ecran)); //PT44
      FreeAndNil(Trace);
      EnDupl := 'NON';
//Fin PT8-3
      TFFiche(Ecran).Bouge(nbPost);
      {$IFNDEF EAGLCLIENT}
      ChargementTablette(TFFiche(Ecran).TableName, '');
      {$ELSE}
      ChargementTablette(TableToPrefixe(TFFiche(Ecran).TableName), ''); //PT7
      {$ENDIF}
      end
    else
      HShowMessage('5;Ventilation des cotisations :;La duplication est impossible, la ventilation existe d�j�.;W;O;O;O;;;', '', '');
  end;
  mode := '';
end;


initialization
  registerclasses([TOM_VENTICOTPAIE]);
end.

