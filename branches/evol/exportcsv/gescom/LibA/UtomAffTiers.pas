{***********UNITE*************************************************
Auteur  ...... : A.B
Créé le ...... : 09/02/2005
Modifié le ... : 09/02/2005
Description .. : Liste des intervenants depuis affaire et tâche
Mots clefs ... : TOM;AFFTIERS
*****************************************************************}
unit UtomAffTiers;

interface

uses
  Controls,
  Classes,
{$IFNDEF EAGLCLIENT}
  db,
{$IFNDEF DBXPRESS}dbtables {BDE},
{$ELSE}uDbxDataSet,
{$ENDIF}
{$IFNDEF EAGLSERVER}
  Fiche,
  FichList,
  FE_Main,
{$ENDIF EAGLSERVER}
{$ELSE EAGLCLIENT}
  eFiche,
  eFichList,
  MaineAGL,
{$ENDIF EAGLCLIENT}
{$IFNDEF EAGLSERVER}
  SaisieList,
{$ENDIF EAGLSERVER}
  Utob,
  sysutils,
  HCtrls,
  HEnt1,
  UTOM,
  Windows,
  AffaireUtil,
  DicoBTP,
  EntGC,
  stdctrls,
  wcommuns,
  TiersUtil;

type
  TOM_AFFTIERS = class (TOM)
    procedure OnNewRecord; override;
    procedure OnDeleteRecord; override;
    procedure OnUpdateRecord; override;
    procedure OnAfterUpdateRecord; override;
    procedure OnAfterDeleteRecord; override;
    {$IFNDEF EAGLSERVER}
    procedure OnLoadRecord; override;
    {$ENDIF !EAGLSERVER}
    procedure OnChangeField (F: TField); override;
    procedure OnArgument (stArgument: string); override;
    procedure OnClose; override;
    procedure OnCancelRecord; override;
  private
    fStType, fStTypeOrig, fStAffaire, fStAuxiliaire, fStLibOrig, fStTypeInterv, fStAffaireEcole, fStRang: string;
    fInNumOrig,fInRang: Integer;
    {$IFNDEF EAGLSERVER}
      fbInscrit,fbSaisieList,fbFicheListe: boolean;
      fStAffairesession :string;
    {$ENDIF EAGLSERVER}
    procedure LoadAffaire;
    {$IFNDEF EAGLSERVER}
      procedure LeContactOnElipsisClick (Sender: TObject);
      procedure TousContactOnElipsisClick (Sender: TObject);
	    procedure TypeIntervenantOnClick (Sender: TObject);
      procedure InscrireOnclick (Sender: TObject);
      procedure OnAfterFormShow;
      procedure ClientClick(Sender: TObject);
      procedure RessourceClick(Sender: TObject);
      procedure ContactTouche(Sender: TObject; var Key: char);
      procedure TiersExit(Sender: TObject);
      procedure RessourceExit(Sender: TObject);
    {$ENDIF EAGLSERVER}
  end;

{$IFNDEF EAGLSERVER}
procedure AFLanceFiche_AFIntervenant (Range, lequel, argument: string);
{$ENDIF EAGLSERVER}

implementation
uses AGLInitGC, HDB;
const
  TexteMessage: array [1..5] of string = (
    {1}'Type d''intervenant obligatoire',
    {2}'Code intervenant obligatoire',
    {3}'Inscrit à ',
    {4}'Inscrit à la session de formation',
    {5}'Ce contact est déjà affecté, voulez-vous l''enregistrer ?'
    );

{$IFNDEF EAGLSERVER}
procedure AFLanceFiche_AFIntervenant (Range, lequel, argument: string);
begin
  AGLLanceFiche ('AFF', 'AFINTERVENANT', Range, lequel, Argument);
end;
{$ENDIF EAGLSERVER}

procedure TOM_AFFTIERS.OnArgument (stArgument: string);
var
  TSArgs: TStringList;
  {$IFDEF GIGI}
  X: Integer;
  TypeInter: THDBVALComboBox;
  {$ENDIF GIGI}
begin
  inherited;
  {$IFNDEF EAGLSERVER}
  if ecran <> nil then
  begin
    fbSaisieList := ( ECran is TFSaisieList ); //GA_200807_AB-FQ15139-Edition affaire école
    fbFicheListe := ( ECran is TFFicheListe );
  end;
  {$ENDIF !EAGLSERVER}

  if ctxScot in V_PGI.PGIContexte then
  begin
    SetControlVisible ('AFT_PROPOINTERV', False);
    SetControlVisible ('TAFT_PROPOINTERV', False);
  end;
  if (stArgument = '') then
    exit;
  fInRang := 0; fStAffaireEcole := '';
  fStTypeOrig := (Trim (ReadTokenSt (StArgument)));
{$IFDEF BTP}
  fstTypeOrig := '';
{$ENDIF}  
  TSArgs := TStringList.Create;
  TSArgs.Text := StringReplace (stArgument, ';', chr (VK_RETURN), [rfReplaceAll] );
  fStAffaire := TSArgs.Values ['AFFAIRE'] ;
  fStLibOrig := TSArgs.Values ['LIBELLE'] ;
  fStTypeInterv := TSArgs.Values ['TYPEINTERV'] ;
  fStAffaireEcole := TSArgs.Values ['AFFAIREECOLE'] ;
  fStRang := TSArgs.Values ['RANG'] ;
  if (fStTypeOrig = 'TAC') or (fStTypeOrig = 'LIG') then
    fInNumOrig := valeurI (TSArgs.Values ['NUMERO'] )
  else
    fInNumOrig := 0;
  UpdateCaption (Ecran);
  {$IFNDEF EAGLSERVER}
      //mcd 02/11/2006 transtypage pas forcemment OK CBP7 il faut tester si bien ThEdit (forum)
    if GetControl('LECONTACT')is ThEdit then
    begin
      THEdit (GetControl ('LECONTACT')).OnElipsisClick := LeContactOnElipsisClick;
      // BDU - 11/04/07 - FQ : 13921. Pas de saisie directe
      THEdit (GetControl ('LECONTACT')).OnKeyPress := ContactTouche;
    end;
  // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
  if GetControl('TOUSCONTACT') is THEdit then
  begin
    THEdit(GetControl('TOUSCONTACT')).OnElipsisClick := TousContactOnElipsisClick;
    // BDU - 11/04/07 - FQ : 13921. Pas de saisie directe
    THEdit(GetControl('TOUSCONTACT')).OnKeyPress := ContactTouche;
  end;
  THDBVALComboBox (GetControl ('AFT_TYPEINTERV')).OnClick := TypeIntervenantOnClick;
  {$IFDEF GIGI}
  if not VH_GC.GRCSeria then
  begin
    // Pas de prospect di la GRC n'est pas sérialisée
    TypeInter := THDBVALComboBox(GetControl('AFT_TYPEINTERV'));
    if Assigned(TypeInter) then
    begin
      X := TypeInter.Values.IndexOf('PRO');
      TypeInter.Items.Delete(X);
      TypeInter.Values.Delete(X);
    end;
  end;
  // BDU - 11/04/07 - FQ : 13921
  if not VH_GC.GAAchatSeria then
  begin
    // Pas de fournisseur si achat non sérialisé
    TypeInter := THDBVALComboBox(GetControl('AFT_TYPEINTERV'));
    if Assigned(TypeInter) then
    begin
      X := TypeInter.Values.IndexOf('FOU');
      TypeInter.Items.Delete(X);
      TypeInter.Values.Delete(X);
    end;
  end;
  {$ENDIF}
  // BDU - 15/01/2007. 13599 - Fait pointer les évènements sur des méthodes de ce source (plus de script)
  // Mode CWAS
  {$IFDEF EAGLCLIENT}
  if GetControl('AFT_TIERS') is THEdit then
  begin
    THEdit(GetControl('AFT_TIERS')).OnElipsisClick := ClientClick;
    // BDU - 11/04/07 - FQ : 13921. Contrôle de la saisie manuelle
    THEdit(GetControl('AFT_TIERS')).OnExit := TiersExit;
  end;
  if GetControl('AFT_RESSOURCE') is THEdit then
  begin
    THEdit(GetControl('AFT_RESSOURCE')).OnElipsisClick := RessourceClick;
    // BDU - 11/04/07 - FQ : 13921. Contrôle de la saisie manuelle
    THEdit(GetControl('AFT_RESSOURCE')).OnExit := RessourceExit;
  end;
  {$ELSE}
  // Mode 2/3
  if GetControl('AFT_TIERS') is THDBEdit then
  begin
    THDBEdit(GetControl('AFT_TIERS')).OnElipsisClick := ClientClick;
    // BDU - 11/04/07 - FQ : 13921. Contrôle de la saisie manuelle
    THDBEdit(GetControl('AFT_TIERS')).OnExit := TiersExit;
  end;
  if GetControl('AFT_RESSOURCE') is THDBEdit then
  begin
    THDBEdit(GetControl('AFT_RESSOURCE')).OnElipsisClick := RessourceClick;
    // BDU - 11/04/07 - FQ : 13921. Contrôle de la saisie manuelle
    THDBEdit(GetControl('AFT_RESSOURCE')).OnExit := RessourceExit;
  end;
  {$ENDIF}
  {$ENDIF EAGLSERVER}
  if VH_GC.GCIfDefCEGID then
    SetControlText ('TAFT_LIENAFFTIERS', 'Statut');
  LoadAffaire;
  TSArgs.free;
  if (fStRang <> '') and (fStAffaireEcole = '') and IsNumeric(fStRang) then
    fInRang := StrToInt (fStRang); //AB-200610-FQ12499
{$ifndef EAGLSERVER}
  if fbFicheListe and (fStRang <> '') and (fStAffaireEcole <> '') then
      TFFicheListe (Ecran).SetNewRange (TFFicheListe (Ecran).FRange, '(' + fStRang + ')');
{$endif}
(*         //mcd 02/07/08 suite FQ cbp 15207 on utilise setnexrange dans tous les cas
{$IFDEF EAGLCLIENT}
    TFFicheListe (Ecran).SetNewRange (TFFicheListe (Ecran).FRange, '(' + fStRang + ')');
{$ELSE}
  begin
    Ds.Filter := fStRang;
    DS.Filtered := True;
  end;
{$ENDIF}  *)
{$IFNDEF EAGLSERVER}
  if Assigned(Ecran) and (Ecran is tfFicheListe) then  //AB-200610-FQ12499
    tfFicheListe(Ecran).OnAfterFormShow := OnAfterFormShow;
{$ENDIF EAGLSERVER}
end;

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.OnLoadRecord;
var
  StType,StSQL: String;
  TobTache :tob;
begin
  inherited;
//  TCheckBox (GetControl ('AFT_INSCRIT')).OnClick := nil;
  THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).value := GetField('AFT_TYPEINTERV');

  SetControlEnabled ('AFT_TYPEINTERV', (ds.State in [dsinsert] ));
  SetControlText ('LECONTACT', '');
  fBInscrit := (GetField ('AFT_INSCRIT') = 'X');
  if (trim (fStAffaireEcole) <> '') or fbSaisieList then //AB-200510- Affaire école
  begin
    if (GetField ('AFT_AFFAIRESESSION') <> '') then
    begin
      SetControlCaption ('AFT_INSCRIT', TraduitGA (TexteMessage [3] ) + GetField ('AFT_AFFAIRESESSION'));
      {3'Inscrit à ',}
      SetControlEnabled ('AFT_INSCRIT', (TFFicheListe (Ecran).FTypeAction <> taconsult) and (GetField ('AFT_AFFAIRESESSION') = fStAffaireEcole));
    end
    else
    begin
      SetControlCaption ('AFT_INSCRIT', TraduitGA (TexteMessage [4] ));
      {4'Inscrit à la session de formation'}
      SetControlEnabled ('AFT_INSCRIT', (TFFicheListe (Ecran).FTypeAction <> taconsult));
    end;
    TCheckBox (GetControl ('AFT_INSCRIT')).OnClick := InscrireOnclick;
  end
  else
  begin
    SetControlVisible ('AFT_INSCRIT', false);
    SetControlVisible ('AFT_AFFAIRESESSION', false);
    SetControlVisible ('TAFT_AFFAIRESESSION', false);
  end;
  // BDU - 15/01/2007. 13599 - Accessibilité des zones selon le type de contact
  StType := GetField ('AFT_TYPEINTERV');
  // BDU - 13/03/07 - FQ : 13797
  SetControlVisible ('AFT_TIERS', (StType = 'CLI') or (StType = 'PRO') or (StType = 'FOU'));
  SetControlEnabled ('AFT_TIERS', (StType = 'CLI') or (StType = 'PRO') or (StType = 'FOU'));
  SetControlVisible ('AFT_RESSOURCE', (StType = 'RES'));
  SetControlEnabled ('AFT_RESSOURCE', (StType = 'RES'));
  SetControlVisible ('LECONTACT', (StType = 'CON'));
  SetControlEnabled ('LECONTACT', (StType = 'CON'));
  SetControlVisible('TOUSCONTACT', StType = 'ACO');
  SetControlEnabled('TOUSCONTACT', StType = 'ACO');
  // BDU - 15/01/2007. 13599 - Mise à jour des zones contenant le libellé du contact
  SetControlText('TOUSCONTACT', GetField('AFT_LIBELLE'));
  SetControlText('LECONTACT', GetField('AFT_LIBELLE'));
  //GA_200807_AB-FQ15139-Edition affaire école
  if fbSaisieList and (fStAffairesession <> GetField('AFT_AFFAIRESESSION')) then
  begin
    TobTache := Tob.create ('Liste des taches', nil, -1);
    StSQL := 'SELECT TOP 1 ATA_QTEPLANIFPLA,ATA_STATUTPLA,ATA_LIBELLETACHE1,ATA_UNITETEMPS,ATA_QTEINITPLA,ATA_STATUTPLA,ATA_TERMINE,'
    + 'ATA_LIBRETACHE1,ATA_LIBRETACHE2,ATA_LIBRETACHE3,ATA_LIBRETACHE4,ATA_LIBRETACHE5,ATA_LIBRETACHE6,'
    + 'ATA_LIBRETACHE7,ATA_LIBRETACHE8,ATA_LIBRETACHE9,ATA_LIBRETACHEA,APL_DATEDEBPLA,ATA_DESCRIPTIF'
    + ' FROM TACHE,AFPLANNING'
    + ' WHERE ATA_AFFAIRE="' + GetField('AFT_AFFAIRESESSION') + '" AND APL_AFFAIRE=ATA_AFFAIRE AND ATA_NUMEROTACHE=APL_NUMEROTACHE'
    + ' ORDER BY APL_DATEDEBPLA';
    Tobtache.LoadDetailFromSQL(StSQL);
    if Tobtache.detail.count > 0 then
    begin
      TobTache.detail[0].PutEcran(Ecran, ThTabSheet(GetControl('Page1')));
      TobTache.detail[0].PutEcran(Ecran, ThTabSheet(GetControl('Page4')));
      TobTache.detail[0].PutEcran(Ecran, ThTabSheet(GetControl('Page3')));
    end;
    TobTache.free;
    fStAffairesession := GetField('AFT_AFFAIRESESSION');
  end;
end;
{$ENDIF !EAGLSERVER}

procedure TOM_AFFTIERS.OnNewRecord;
begin
  inherited;
  Setfield ('AFT_TYPEORIG', fStTypeOrig);
  Setfield ('AFT_NUMORIG', fInNumOrig);
  Setfield ('AFT_INTERVENTION', fStLibOrig);
  SetField ('AFT_TYPEINTERV', fStTypeInterv);
  SetField ('AFT_AUXILIAIRE', fStAuxiliaire);
  SetControlEnabled ('AFT_NUMORIG', false);
  fStType := '';
  if VH_GC.GCIfDefCEGID then
    SetField ('AFT_LIENAFFTIERS', 'INS');
  if trim (fStAffaireEcole) <> '' then //AB-200510- Affaire école
  begin
    SetField ('AFT_AFFAIRESESSION', fStAffaireEcole);
    SetField ('AFT_INSCRIT', 'X');
    SetControlCaption ('AFT_INSCRIT', TraduitGA (TexteMessage [3] ) + fStAffaireEcole);
    {3'Inscrit à ',}
  end;
end;

procedure TOM_AFFTIERS.OnUpdateRecord;
var
  vQR: TQuery;
  IMax: integer;
  StSql: string;
begin
  inherited;
  SetField('AFT_TYPEINTERV',THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).value);
  if (GetField ('AFT_TYPEINTERV') = '') then
  begin
    LastError := 1;
    SetFocusControl ('AFT_TYPEINTERV');
    LastErrorMsg := TraduitGa (TexteMessage [LastError] );
    {1'Type d''intervenant obligatoire',}
    Exit;
  end else if (GetField ('AFT_RESSOURCE') = '') and (GetField ('AFT_TIERS') = '') and (GetField ('AFT_NUMEROCONTACT') = 0) then
  begin
    LastError := 2;
    // BDU - 13/03/07 - FQ : 13797
    if (GetField ('AFT_TYPEINTERV') = 'CLI') or (GetField('AFT_TYPEINTERV') = 'PRO') or
      (GetField('AFT_TYPEINTERV') = 'FOU') then
      SetFocusControl ('AFT_TIERS')
    else
      if (GetField ('AFT_TYPEINTERV') = 'RES') then
      SetFocusControl ('AFT_RESSOURCE')
    // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
    else if GetField('AFT_TYPEINTERV') = 'ACO' then
      SetFocusControl('TOUSCONTACT')
    else
      SetFocusControl ('LECONTACT');
    LastErrorMsg := TraduitGa (TexteMessage [LastError] );
    {2'Code intervenant obligatoire',}
    Exit;
  end;

  if getfield ('AFT_RANG') = 0 then
  begin
    StSql := 'SELECT MAX(AFT_RANG) FROM AFFTIERS WHERE AFT_AFFAIRE="' + GetField ('AFT_AFFAIRE') +
      '" AND AFT_TYPEORIG="' + fStTypeOrig + '" AND AFT_NUMORIG=' + IntToStr (GetField ('AFT_NUMORIG'));
    vQR := OpenSQL (StSql, true);
    if not vQR.EOF then
      imax := vQR.Fields [0] .AsInteger + 1
    else
      iMax := 1;
    Ferme (vQR);
    SetField ('AFT_RANG', IMax);
  end;
  // BDU - 15/01/2007. 13599 - Mise à jours des zones contenant le libellé du contact
  if GetField('AFT_TYPEINTERV') = 'ACO' then
    SetControlText('TOUSCONTACT', GetField('AFT_LIBELLE'))
  else if GetField('AFT_TYPEINTERV') = 'CON' then
    SetControlText('LECONTACT', GetField('AFT_LIBELLE'))
end;

procedure TOM_AFFTIERS.OnChangeField (F: TField);
//var
//  vQR: TQuery;
//  StSql, StType: string;
begin
  inherited;
  if (F.FieldName = 'AFT_TYPEINTERV') and (GetField (F.FieldName) <> '') then
  begin
    // BDU - 15/01/2007. 13599 - Tout est mis en commentaire
    {
    StType := GetField ('AFT_TYPEINTERV');
    SetControlVisible ('AFT_TIERS', (StType = 'CLI'));
    SetControlEnabled ('AFT_TIERS', (StType = 'CLI'));
    SetControlVisible ('AFT_RESSOURCE', (StType = 'RES'));
    SetControlEnabled ('AFT_RESSOURCE', (StType = 'RES'));
    SetControlVisible ('LECONTACT', (StType = 'CON'));
    SetControlEnabled ('LECONTACT', (StType = 'CON'));
    // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
    SetControlVisible('TOUSCONTACT', StType = 'ACO');
    SetControlEnabled('TOUSCONTACT', StType = 'ACO');
    }
  end
  else
  begin
    // BDU - 15/01/2007. 13599 - Tout est mis en commentaire
    {
    StSql := '';
    // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers". La sélection ne se fait pas sur l'auxiliaire mais sur le code tiers
    if (F.FieldName = 'AFT_NUMEROCONTACT') and (GetField(F.FieldName) <> 0) and
      (GetField('AFT_TYPEINTERV') = 'ACO') and (GetField('AFT_TIERS') <> '') then
      stSql := Format('SELECT C_NOM, C_PRENOM, C_CIVILITE FROM CONTACT WHERE C_TYPECONTACT = "T" ' +
        'AND C_TIERS = "%s" AND C_NUMEROCONTACT = %s',
        [GetField('AFT_TIERS'), (GetField ('AFT_NUMEROCONTACT'))])
    else if (F.FieldName = 'AFT_TIERS') and (GetField (F.FieldName) <> '') and
      (GetField('AFT_TYPEINTERV') = 'CLI') then
      StSql := 'SELECT T_LIBELLE FROM TIERS WHERE T_TIERS="' + GetField (F.FieldName) + '"'
    else if (F.FieldName = 'AFT_RESSOURCE') and (GetField (F.FieldName) <> '') and
      (GetField('AFT_TYPEINTERV') = 'RES') then
      StSql := 'SELECT ARS_LIBELLE FROM RESSOURCE WHERE ARS_RESSOURCE="' + GetField (F.FieldName) + '"'
    else if (F.FieldName = 'AFT_NUMEROCONTACT') and (GetField (F.FieldName) <> 0) and
      (GetField('AFT_TYPEINTERV') = 'CON') then
      StSql := 'SELECT C_NOM,C_PRENOM,C_CIVILITE FROM CONTACT WHERE C_TYPECONTACT="T" ' +
        'AND C_AUXILIAIRE="' + fStAuxiliaire + '" AND C_NUMEROCONTACT=' + IntToStr (GetField (F.FieldName));
    if (StSql <> '') then
    begin
      vQR := OpenSQL (StSql, true);
      if not vQR.EOF then
      begin
        if vQR.Fields [0] .FieldName = 'C_NOM' then
        begin
          SetControlText ('LECONTACT', vQR.Fields [0] .AsString);
          // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
          SetControlText('TOUSCONTACT', vQR.Fields [0] .AsString);
          if DS.State in [dsEdit, dsInsert] then
          begin
            SetField ('AFT_TYPECONTACT', 'T');
            SetField ('AFT_LIBELLE', vQR.Fields [2] .AsString + ' ' + vQR.Fields [0] .AsString + ' ' + vQR.Fields [1] .AsString);
          end;
        end
        else
          if DS.State in [dsEdit, dsInsert] then
            SetField ('AFT_LIBELLE', vQR.Fields [0] .AsString);
      end;
      Ferme (vQR);
    end;
    }
  end;
end;

procedure TOM_AFFTIERS.LoadAffaire;
var
  vSql: string;
  vQR: TQuery;
  iPosition: integer;
begin
  iPosition := ChargeCleAffaire (nil, THEdit (GetControl ('AFT_AFFAIRE1')), THEdit (GetControl ('AFT_AFFAIRE2')),
    THEdit (GetControl ('AFT_AFFAIRE3')), THEDIT (GetControl ('AFT_AVENANT')), nil, taConsult, fStAffaire, false);
  if iPosition > 0 then
    THLabel (GetControl ('LIBAFFAIRE')).left := iPosition;
  vSql := 'SELECT AFF_AFFAIRE,AFF_LIBELLE';
  vSql := vSql + ',T_TIERS, T_LIBELLE,T_AUXILIAIRE';
  if (fStTypeOrig = 'TAC') and (fInNumOrig <> 0) then
    vSql := vSql + ',ATA_LIBELLETACHE1';
  vSql := vSql + ' FROM TIERS,AFFAIRE';
  if (fStTypeOrig = 'TAC') and (fInNumOrig <> 0) then
    vSql := vSql + ' LEFT JOIN TACHE ON ATA_AFFAIRE="' + fStAffaire + '" AND ATA_NUMEROTACHE=' + IntToStr (fInNumOrig);
  vSql := vSql + ' WHERE AFF_AFFAIRE = "' + fStAffaire + '"';
  vSql := vSql + ' AND AFF_TIERS = T_TIERS';
  vQR := OpenSql (vSql, True);
  if not vQR.Eof then
  begin
    SetControltext ('LibAffaire', vQR.FindField ('AFF_LIBELLE').AsString);
    SetControltext ('LeClient', vQR.FindField ('T_TIERS').AsString);
    SetControltext ('LibClient', vQR.FindField ('T_LIBELLE').AsString);
    fStAuxiliaire := vQR.FindField ('T_AUXILIAIRE').AsString;
    if (fStTypeOrig = 'TAC') and (fInNumOrig <> 0) then
      fStLibOrig := vQR.FindField ('ATA_LIBELLETACHE1').AsString;
  end;
  ferme (vQR);
end;

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.LeContactOnElipsisClick (Sender: TObject);
var
  StNumeroContact, StRang, StSql: string;
  iNumeroContact: integer;
  Q: TQuery;
begin
  StRang := 'T;' + fStAuxiliaire + ';';
  if GetField ('AFT_NUMEROCONTACT') <> 0 then
    StRang := StRang + IntToStr (GetField ('AFT_NUMEROCONTACT')) + ';';
  StNumeroContact := AGLLanceFiche ('YY', 'YYCONTACT', StRang, '', 'FROMSAISIE;FROMFORMATION;');
  //
  StNumeroContact := ReadTokenSt(StNumeroContact);
  iNumeroContact := valeurI (StNumeroContact);
  if (iNumeroContact <> 0) then
  begin
    StSql := 'SELECT AFT_RANG FROM AFFTIERS WHERE AFT_AFFAIRE="' + GetField ('AFT_AFFAIRE') + '"' +
             ' AND AFT_TYPEORIG="' + fStTypeOrig + '" AND AFT_NUMORIG=' + IntToStr (fInNumOrig) +
             ' AND AFT_TYPEINTERV="CON" AND AFT_NUMEROCONTACT=' + IntToStr (iNumeroContact);
    {5'Ce contact est déjà affecté, voulez-vous l''enregistrer ?' }
    if (DS.State in [dsInsert] ) and Existesql(StSql) and (PGIAskAF (TexteMessage [5] , Ecran.caption ) <> mrYes) then
      Exit;

    if not (DS.State in [dsInsert, dsEdit] ) then
      DS.edit;
    SetField ('AFT_NUMEROCONTACT', iNumeroContact);
    // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers". Renseignement systématique du code tiers
    SetField('AFT_TIERS', TiersAuxiliaire(fStAuxiliaire, True));
    // BDU - 15/01/2007. 13599 - Recherche les éléments du libellé
    Q := OpenSQl('SELECT C_NOM, C_PRENOM, C_CIVILITE FROM CONTACT ' +
      'WHERE C_TYPECONTACT = "T" AND C_AUXILIAIRE ="' + fStAuxiliaire +
      // BDU - 10/04/07 - FQ : 13919. Remplacer StNumeroContact par iNumeroContact
      '" AND C_NUMEROCONTACT = ' + IntToStr(iNumeroContact), True);
    try
      if not Q.EOF then
      begin
        SetField('AFT_LIBELLE', Q.Fields[2].AsString + ' ' + Q.Fields[0].AsString + ' ' + Q.Fields[1].AsString);
        SetControlText('LECONTACT', Trim(GetField('AFT_LIBELLE')));
      end
      else
        SetControlText('LECONTACT', '');
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.TypeIntervenantOnClick (Sender: TObject);
begin
  if fStType <> THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).value then
  begin
    fStType := THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).value;
    // BDU - 13/03/07 - FQ : 13797
    SetControlVisible ('AFT_TIERS', (fStType = 'CLI') or (fStType = 'PRO') or (fStType = 'FOU'));
    SetControlEnabled ('AFT_TIERS', (fStType = 'CLI') or (fStType = 'PRO') or (fStType = 'FOU'));
    SetControlVisible ('AFT_RESSOURCE', (fStType = 'RES'));
    SetControlEnabled ('AFT_RESSOURCE', (fStType = 'RES'));
    SetControlVisible ('LECONTACT', (fStType = 'CON'));
    SetControlEnabled ('LECONTACT', (fStType = 'CON'));
    // BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
    SetControlVisible('TOUSCONTACT', fStType = 'ACO');
    SetControlEnabled('TOUSCONTACT', fStType = 'ACO');
    Setfield ('AFT_TIERS', '');
    Setfield ('AFT_RESSOURCE', '');
    Setfield ('AFT_LIBELLE', '');
    SetField ('AFT_NUMEROCONTACT', 0);
    SetControlText ('LECONTACT', '');
    SetControlText('TOUSCONTACT', '');
  end;
end;
{$ENDIF !EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.InscrireOnclick (Sender: TObject); //AB-200510- Affaire école
begin
  if not (DS.State in [dsInsert, dsEdit] ) and
    (TCheckBox (GetControl ('AFT_INSCRIT')).Checked <> (GetField ('AFT_INSCRIT') = 'X')) then
    DS.edit;
  if (DS.State = dsEdit) then
  begin
    fBInscrit := (GetField ('AFT_INSCRIT') = 'X');
    if (TCheckBox (GetControl ('AFT_INSCRIT')).Checked) then
    begin
      SetField ('AFT_AFFAIRESESSION', fStAffaireEcole);
      SetControlCaption ('AFT_INSCRIT', TraduitGA (TexteMessage [3] ) + fStAffaireEcole);
      {3'Inscrit à ',}
    end
    else
    begin
      SetField ('AFT_AFFAIRESESSION', '');
      SetControlCaption ('AFT_INSCRIT', TraduitGA (TexteMessage [4] ));
      {4'Inscrit à la session de formation'}
    end;
  end;
end;
{$ENDIF !EAGLSERVER}

procedure TOM_AFFTIERS.OnDeleteRecord;
begin
  inherited;
end;

procedure TOM_AFFTIERS.OnClose;
begin
  inherited;
end;

procedure TOM_AFFTIERS.OnCancelRecord;
begin
  inherited;
end;

procedure TOM_AFFTIERS.OnAfterUpdateRecord;
begin
  inherited;
end;

procedure TOM_AFFTIERS.OnAfterDeleteRecord;
begin
  inherited;
end;

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.OnAfterFormShow;
begin
  if fInRang <> 0 then //AB-200610-FQ12499
  begin
    while not DS.EOF do
    if DS.FindField('AFT_RANG').AsInteger = fInRang then
      Break
    else
      TFFicheliste(Ecran).BNextClick(ecran);
    fInRang := 0;
  end;
end;
{$ENDIF !EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.ClientClick(Sender: TObject);
var
  Q: TQuery;
  S: String;
begin
  {$IFNDEF ERADIO}
    // BDU - 13/03/07 - FQ : 13797
    S := THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).Value;
    S := DispatchRecherche(THCritMaskEdit(GetControl('AFT_TIERS')), 2, 'T_NATUREAUXI="' + S + '"', '', '');
  {$ELSE  !ERADIO}
    S := '';
  {$ENDIF !ERADIO}
  if S <> '' then
  begin
    // BDU - 15/01/2007. 13599 - Récupération des éléments du libellé
    Q := OpenSQL('SELECT T_LIBELLE FROM TIERS WHERE T_TIERS = "' + S + '"', True);
    try
      if not Q.EOF then
        SetField('AFT_LIBELLE', Q.Fields[0].AsString)
      else
        SetField('AFT_LIBELLE', '');
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF !EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.RessourceClick(Sender: TObject);
var
  Q: TQuery;
  S: String;
begin
  {$IFNDEF ERADIO}
    S := DispatchRecherche(THCritMaskEdit(GetControl('AFT_RESSOURCE')), 3, '', '', '');
  {$ELSE  !ERADIO}
    S := '';
  {$ENDIF !ERADIO}
  if S <> '' then
  begin
    // BDU - 15/01/2007. 13599 - Récupération des éléments du libellé
    Q := OpenSQL('SELECT ARS_LIBELLE FROM RESSOURCE WHERE ARS_RESSOURCE = "' + S + '"', True);
    try
      if not Q.EOF then
        SetField('AFT_LIBELLE', Q.Fields[0].AsString)
      else
        SetField('AFT_LIBELLE', '');
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF !EAGLSERVER}

// BDU - 30/11/06, Ajout du type "Contact d'un autre tiers"
{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.TousContactOnElipsisClick (Sender: TObject);
var
  Retour,
  Auxiliaire: string;
  NumeroContact: integer;
  Q: TQuery;
begin
  Retour := AGLLanceFiche ('AFF', 'AFCONTACT_MUL', '', '', 'CONSULTATION;CONTACT_AFFAIRE');
  try
    // La première valeur n'est pas utilisée
    ReadTokenSt(Retour);
    // L'auxiliaire est en deuxième position
    Auxiliaire := ReadTokenSt(Retour);
    // Le numéro de contact est en troisième position
    NumeroContact := StrToInt(ReadTokenSt(Retour));
  except
    NumeroContact := 0;
  end;
  if (NumeroContact <> 0) then
  begin
    if not (DS.State in [dsInsert, dsEdit] ) then
      DS.edit;
    // Attention, l'affectation de AFT_TIERS doit être avant celle de AFT_NUMEROCONTACT
    SetField('AFT_TIERS', TiersAuxiliaire(Auxiliaire, True));
    SetField ('AFT_NUMEROCONTACT', NumeroContact);
    // BDU - 15/01/2007. 13599 - Récupération des éléments du libellé
    // BDU - 01/10/07 - FQ : 13963. Ajout du code du tiers
    Q := OpenSQl('SELECT C_NOM, C_PRENOM, C_CIVILITE, C_TIERS FROM CONTACT ' +
      'WHERE C_TYPECONTACT = "T" AND C_TIERS = "' + GetField('AFT_TIERS') +
      '" AND C_NUMEROCONTACT = ' + IntToStr(NumeroContact), True);
    try
      if not Q.EOF then
      begin
        // BDU - 01/10/07 - FQ : 13963. Ajout du code du tiers
        SetField('AFT_LIBELLE', Q.Fields[3].AsString + ' - ' + Q.Fields[2].AsString + ' ' + Q.Fields[0].AsString + ' ' + Q.Fields[1].AsString);
        SetControlText('TOUSCONTACT', GetField('AFT_LIBELLE'));
      end
      else
        SetControlText('TOUSCONTACT', '');
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.ContactTouche(Sender: TObject; var Key: char);
begin
  Key := #0;
end;
{$ENDIF EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.RessourceExit(Sender: TObject);
var
  S: String;
  Q: TQuery;
begin
  if DS.State in [dsEdit, dsInsert] then
  begin
    S := UpperCase(Trim(GetControlText('AFT_RESSOURCE')));
    if S = '' then
    begin
      SetControlText('AFT_LIBELLE', '');
      Exit;
    end;
    S := 'SELECT ARS_LIBELLE, ARS_RESSOURCE FROM RESSOURCE WHERE ARS_RESSOURCE = "' + S + '"';
    Q := OpenSQL(S, True);
    try
      if not Q.EOF then
      begin
        SetField('AFT_LIBELLE', Q.Fields[0].AsString);
        SetField('AFT_RESSOURCE', Q.Fields[1].AsString);
      end
      else
      begin
        SetField('AFT_LIBELLE', '');
        SetField('AFT_RESSOURCE', '');
        SetControlText('AFT_RESSOURCE', '');
        SetFocusControl('AFT_RESSOURCE');
      end;
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF EAGLSERVER}

{$IFNDEF EAGLSERVER}
procedure TOM_AFFTIERS.TiersExit(Sender: TObject);
var
  S: String;
  Q: TQuery;
begin
  if DS.State in [dsEdit, dsInsert] then
  begin
    S := UpperCase(Trim(GetControlText('AFT_TIERS')));
    if S = '' then
    begin
      SetControlText('AFT_LIBELLE', '');
      Exit;
    end;
    S := 'SELECT T_LIBELLE, T_TIERS FROM TIERS WHERE T_TIERS = "' + S + '"';
    S := S + ' AND T_NATUREAUXI = "' + THDBValcomboBox (GetControl ('AFT_TYPEINTERV')).Value + '"';
    Q := OpenSQL(S, True);
    try
      if not Q.EOF then
      begin
        SetField('AFT_LIBELLE', Q.Fields[0].AsString);
        SetField('AFT_TIERS', Q.Fields[1].AsString);
      end
      else
      begin
        SetField('AFT_LIBELLE', '');
        SetField('AFT_TIERS', '');
        SetControlText('AFT_TIERS', '');
        SetFocusControl('AFT_TIERS');
      end;
    finally
      Ferme(Q);
    end;
  end;
end;
{$ENDIF EAGLSERVER}

initialization
  registerclasses ([TOM_AFFTIERS] );
end.
