{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 09/06/2015
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTEVENTMAT_MUL ()
Mots clefs ... : TOF;BTEVENTMAT_MUL
*****************************************************************}
Unit bteventmat_mul ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFDEF EAGLCLIENT}
     MaineAGL,
     eMul,
     uTob,
{$ELSE}
     DBCtrls, Db,
     {$IFNDEF DBXPRESS}
     dbTables,
     {$ELSE}
     uDbxDataSet,
     {$ENDIF DBXPRESS}
     fe_main,
     HDB,
     Mul,
{$ENDIF EAGLCLIENT}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     //Ajout
     HTB97,
     uEntCommun,
     uTOFComm,
     UTOF;

Type
  TOF_BTEVENTMAT_MUL = Class (tTOFComm)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    //Définition des variables utilisées dans le Uses
    Action    : TActionFiche;
    //
    BInsert   : TToolbarButton97;
    BTSelect  : TToolbarButton97;
    BTSelect1 : TToolbarButton97;
    BTSelect2 : TToolbarButton97;
    BTSelect3 : TToolbarButton97;
    BTSelect4 : TToolbarButton97;
    BTSelect5 : TToolbarButton97;

    BtEfface  : TToolbarButton97;
    BtEfface1 : TToolbarButton97;
    BtEfface2 : TToolbarButton97;
    BtEfface3 : TToolbarButton97;
    BtEfface4 : TToolbarButton97;
    BtEfface5 : TToolbarButton97;
    //
    Grille    : THDBGrid;
    //
    Affaire   : THEdit;
    Affaire0  : THEdit;
    Affaire1  : THEdit;
    Affaire2  : THEdit;
    Affaire3  : THEdit;
    Avenant   : THEdit;
    //
    FamilleMat: THEdit;
    CodeClient: THEdit;
    Ressource : THEdit;
    CodeMat   : THEdit;
    TypeAction: THEdit;
    Borne1    : THEdit;
    Borne2    : THEdit;
    DateDeb   : THEdit;
    DateFin   : THEdit;
    //
    LibAffaire    : THLabel;
    LibClient     : THLabel;
    LibRessource  : THLabel;
    LibMateriel   : THLabel;
    LibTypeAction : THLabel;
    LibFamilleMat : THLabel;
    //
    ModeRecherche : Boolean;
    //
    procedure ClientOnExit(Sender: TObject);
    procedure AffaireOnExit(Sender: TObject);
    Procedure CodeMatOnExit(Sender: TObject);
    procedure Controlechamp(Champ, Valeur: String);
    procedure DateOnExit(Sender: TObject);
    procedure EffaceOnClick(Sender: TObject);
    procedure Efface1OnClick(Sender: TObject);
    procedure Efface2OnClick(Sender: TObject);
    procedure Efface3OnClick(Sender: TObject);
    procedure Efface4OnClick(Sender: TObject);
    procedure Efface5OnClick(Sender: TObject);
    procedure FamilleMatOnExit(Sender: TObject);
    procedure GetObjects;
    procedure GrilleOnDblclick(Sender: TObject);
    Procedure InsertOnclick(Sender : tobject);
    procedure RessourceOnExit(Sender: TObject);
    Procedure TypeActionOnExit(Sender: TObject);
    procedure SelectOnClick(Sender: TObject);
    procedure Select1OnClick(Sender: TObject);
    procedure Select2OnClick(Sender: TObject);
    procedure Select3OnClick(Sender: TObject);
    procedure Select4OnClick(Sender: TObject);
    procedure Select5OnClick(Sender: TObject);
    procedure SetScreenEvents;
  end ;

Implementation

uses  AffaireUtil,
      FactUtil,
      AGLInitGC,
      UtilsParc,
      BTPUtil;

procedure TOF_BTEVENTMAT_MUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnArgument (S : String ) ;
var x       : Integer;
    Critere : string;
    Champ   : string;
    Valeur  : string;
begin

  Inherited ;
  //
  //Chargement des zones ecran dans des zones programme
  GetObjects;
  //
  Critere := uppercase(Trim(ReadTokenSt(S)));
  while Critere <> '' do
  begin
     x := pos('=', Critere);
     if x <> 0 then
        begin
        Champ := copy(Critere, 1, x - 1);
        Valeur := copy(Critere, x + 1, length(Critere));
        end
     else
        Champ := Critere;
     ControleChamp(Champ, Valeur);
     Critere:= uppercase(Trim(ReadTokenSt(S)));
  end;

  //Gestion des évènement des zones écran
  SetScreenEvents;

  ChargeCleAffaire (Affaire0,Affaire1,Affaire2,Affaire3,Avenant, BtSelect, Action, Affaire.Text, False);

end ;

procedure TOF_BTEVENTMAT_MUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTEVENTMAT_MUL.GetObjects;
begin

  if Assigned(GetControl('Fliste'))   then Grille   := THDBGrid(ecran.FindComponent('Fliste'));

  if Assigned(GetControl('BInsert'))  then BInsert  := TToolBarButton97(Getcontrol('BInsert'));

  if Assigned(GetControl('BSelect'))  then BTSelect  := TToolBarButton97(Getcontrol('BSELECT'));
  if Assigned(GetControl('BSelect1')) then BTSelect1 := TToolBarButton97(Getcontrol('BSELECT1'));
  if Assigned(GetControl('BSelect2')) then BTSelect2 := TToolBarButton97(Getcontrol('BSELECT2'));
  if Assigned(GetControl('BSelect3')) then BTSelect3 := TToolBarButton97(Getcontrol('BSELECT3'));
  if Assigned(GetControl('BSelect4')) then BTSelect4 := TToolBarButton97(Getcontrol('BSELECT4'));
  if Assigned(GetControl('BSelect5')) then BTSelect5 := TToolBarButton97(Getcontrol('BSELECT5'));


  if Assigned(GetControl('BEfface'))  then BTEfface  := TToolBarButton97(Getcontrol('BEfface'));
  if Assigned(GetControl('BEfface1')) then BTEfface1 := TToolBarButton97(Getcontrol('BEfface1'));
  if Assigned(GetControl('BEfface2')) then BTEfface2 := TToolBarButton97(Getcontrol('BEfface2'));
  if Assigned(GetControl('BEfface3')) then BTEfface3 := TToolBarButton97(Getcontrol('BEfface3'));
  if Assigned(GetControl('BEfface4')) then BTEfface4 := TToolBarButton97(Getcontrol('BEfface4'));
  if Assigned(GetControl('BEfface5')) then BTEfface5 := TToolBarButton97(Getcontrol('BEfface5'));

  Affaire     := THEdit(GetControl('BEM_AFFAIRE'));
  Affaire0    := THEdit(GetControl('BEM_AFFAIRE0'));
  Affaire1    := THEdit(GetControl('BEM_AFFAIRE1'));
  Affaire2    := THEdit(GetControl('BEM_AFFAIRE2'));
  Affaire3    := THEdit(GetControl('BEM_AFFAIRE3'));
  Avenant     := THEdit(GetControl('BEM_AVENANT'));
  //
  CodeClient  := THEdit(GetControl('BEM_TIERS'));
  Ressource   := THEdit(GetControl('BEM_RESSOURCE'));
  CodeMat     := THEdit(GetControl('BEM_CODEMATERIEL'));
  TypeAction  := THEdit(GetControl('BEM_BTETAT'));
  FamilleMat  := THEdit(GetControl('BFM_CODEFAMILLE'));
  Borne1      := THEdit(GetControl('BORNE1'));
  Borne2      := THEdit(GetControl('BORNE1_'));
  DateDeb     := THEdit(GetControl('BEM_DATEDEB'));
  DateFin     := THEdit(GetControl('BEM_DATEFIN'));
  //
  LibAffaire    := THLabel(GetControl('LIBAFFAIRE'));
  LibClient     := THLabel(GetControl('LIBCLIENT'));
  LibFamilleMat := THLabel(GetControl('LIBFAMILLEMAT'));

  LibRessource  := THLabel(GetControl('LIBRESSOURCE'));
  LibMateriel   := THLabel(GetControl('LIBMATERIEL'));
  LibTypeAction := THLabel(GetControl('LIBTYPEACTION'));

end;

procedure TOF_BTEVENTMAT_MUL.SetScreenEvents;
begin

  If Assigned(Grille)                 then Grille.OnDblClick := GrilleOnDblclick;

  if Assigned(BInsert)                then BInsert.OnClick   := InsertOnClick;

  if Assigned(BTSelect)               then BTSelect.OnClick  := SelectOnClick;
  if Assigned(BTSelect1)              then BTSelect1.OnClick := Select1OnClick;
  if Assigned(BTSelect2)              then BTSelect2.OnClick := Select2OnClick;
  if Assigned(BTSelect3)              then BTSelect3.OnClick := Select3OnClick;
  if Assigned(BTSelect4)              then BTSelect4.OnClick := Select4OnClick;
  if Assigned(BTSelect5)              then BTSelect5.OnClick := Select5OnClick;


  if Assigned(Ressource)              then Ressource.OnExit  := RessourceOnExit;
  if Assigned(Affaire)                then Affaire.OnExit    := AffaireOnExit;
  if Assigned(CodeClient)             Then CodeClient.OnExit := ClientOnExit;
  if Assigned(CodeMat)                then CodeMat.OnExit    := CodeMatOnExit;
  if Assigned(TypeAction)             then TypeAction.OnExit := TypeActionOnExit;
  if assigned(FamilleMat)             Then FamilleMat.OnExit := FamilleMatOnExit;
  if Assigned(Borne1)                 then Borne1.OnExit     := DateOnExit;
  if Assigned(Borne2)                 then Borne2.OnExit     := DateOnExit;


  if Assigned(BTEfface)               then BTEfface.OnClick  := EffaceOnClick;
  if Assigned(BTEfface1)              then BTEfface1.OnClick := Efface1OnClick;
  if Assigned(BTEfface2)              then BTEfface2.OnClick := Efface2OnClick;
  if Assigned(BTEfface3)              then BTEfface3.OnClick := Efface3OnClick;
  if Assigned(BTEfface4)              then BTEfface4.OnClick := Efface4OnClick;
  if Assigned(BTEfface5)              then BTEfface5.OnClick := Efface5OnClick;


end;

Procedure TOF_BTEVENTMAT_MUL.Controlechamp(Champ, Valeur : String);
begin

  if Champ='ACTION' then
  begin
    if      Valeur='CREATION'     then Action:=taCreat
    else if Valeur='MODIFICATION' then Action:=taModif
    else if Valeur='CONSULTATION' then Action:=taConsult;
  end
  else if Champ = 'RECH' then
  begin
    if valeur='X'                 then ModeRecherche:=true;
  end else if Champ = 'ENCOURS' then
  begin
    ModeRecherche:=true;
  end;

end;

Procedure TOF_BTEVENTMAT_MUL.GrilleOnDblclick(Sender : TObject);
Var Argument        : String;
    Identification  : String;
begin

  Identification := Grille.Datasource.Dataset.FindField('BEM_IDEVENTMAT').AsString;


  if Moderecherche then
  begin
  	TFMul(Ecran).Retour := Identification;
    TFMul(Ecran).Close;
  end
  else
  begin
    if Identification = '' then
      Argument := 'ACTION=CREATION'
    else
      Argument := 'IDEVENEMENT=' + Identification + ';ACTION=MODIFICATION';

    AGLLanceFiche('BTP','BTEVENTMAT','','',Argument);

    refreshDB();
  end;


end;

procedure TOF_BTEVENTMAT_MUL.InsertOnclick(Sender: TObject);
Var Argument : String;
begin

  Argument := 'ACTION=CREATION';

  AGLLanceFiche('BTP','BTEVENTMAT','','',Argument);

  refreshDB();

end;

procedure TOF_BTEVENTMAT_MUL.SelectOnClick(Sender: TObject);
Var StChamps  : String;
begin

  StChamps  := Affaire.Text;

  if GetAffaireEnteteSt(Affaire0, Affaire1, Affaire2, Affaire3, AVENANT, nil, StChamps, false, false, false, True, true,'') then Affaire.text := StChamps;

  ChargeCleAffaire (Affaire0,Affaire1,Affaire2,Affaire3,Avenant, BtSelect, Action, Affaire.Text, False);

  LibAffaire.Caption := ChargeInfoAffaire(Affaire.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.AffaireOnExit(Sender : TObject);
Var IP      : Integer;
begin

  Affaire.text := DechargeCleAffaire(Affaire0, Affaire1, Affaire2, Affaire3, Avenant, '', Action, False, True, false, IP);

  LibAffaire.caption := ChargeInfoAffaire(Affaire.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.Select1OnClick(Sender: TObject);
Var StChamps  : string;
    StWhere   : string;
Begin

  StChamps  := CodeClient.Text;

  StWhere   := 'T_NATUREAUXI="CLI"';

  DispatchRecherche(CodeClient, 2, StWhere,'T_TIERS=' + Trim(CodeClient.Text), '');

  LibClient.caption := ChargeInfoTiers(CodeClient.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.ClientOnExit(Sender : TObject);
begin

  LibClient.caption := ChargeInfoTiers(CodeClient.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.RessourceOnExit(Sender : TObject);
Var StWhere : string;
begin

  Stwhere   := ' AND ARS_TYPERESSOURCE in ("MAT", "SAL", "OUT")';

  LibRessource.Caption := ChargeInfoRessource(Ressource.Text, StWhere, False);

end;

procedure TOF_BTEVENTMAT_MUL.Select2OnClick(Sender: TObject);
Var StChamps  : String;
    StWhere   : String;
begin

  StChamps  := ressource.Text;

  Stwhere   := 'ARS_TYPERESSOURCE in ("MAT", "SAL", "OUT")';

  DispatchRecherche(Ressource, 3, StWhere,'ARS_RESSOURCE=' + Trim(Ressource.Text), '');

  LibRessource.Caption := ChargeInfoRessource(Ressource.Text, ' AND ' + StWhere, False);

end;

procedure TOF_BTEVENTMAT_MUL.Select3OnClick(Sender: TObject);
begin

  CodeMat.text := AGLLanceFiche('BTP','BTMATERIEL_MUL','','','RECH=X');

  LibMateriel.caption := ChargeInfoMateriel(CodeMat.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.Select4OnClick(Sender: TObject);
Var Stwhere : String;
begin

  TypeAction.text := AGLLanceFiche('BTP','BTTYPEACTION_MUL','','','TYPEACTION=PMA;RECH=X');

  Stwhere := ' AND BTA_TYPEACTION="PMA"';
  LibTypeAction.caption := ChargeInfoTypeAction(TypeAction.Text, Stwhere, False);

end;

procedure TOF_BTEVENTMAT_MUL.Select5OnClick(Sender: TObject);
begin

  FamilleMat.text := AGLLanceFiche('BTP','BTFAMILLEMAT_MUL','','','RECH=X');

  LibFamilleMat.caption := ChargeInfoFamMat(FamilleMat.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.EffaceOnClick(Sender: TObject);
begin

  Affaire.Text  := '';
  Affaire0.Text := '';
  Affaire1.Text := '';
  Affaire2.Text := '';
  Affaire3.Text := '';
  Avenant.Text  := '';

  LibAffaire.caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.Efface1OnClick(Sender: TObject);
begin

  CodeClient.text := '';
  LibClient.Caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.Efface2OnClick(Sender: TObject);
begin

  Ressource.text := '';
  LibRessource.caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.Efface3OnClick(Sender: TObject);
begin

  CodeMat.Text := '';
  LibMateriel.Caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.Efface4OnClick(Sender: TObject);
begin

  TypeAction.Text := '';
  LibTypeAction.caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.Efface5OnClick(Sender: TObject);
begin

  FamilleMat.Text := '';
  LibFamilleMat.caption := '';

end;

procedure TOF_BTEVENTMAT_MUL.CodeMatOnExit(Sender: TObject);
begin

  LibMateriel.caption := ChargeInfoMateriel(CodeMat.Text,False);

end;

procedure TOF_BTEVENTMAT_MUL.TypeActionOnExit(Sender: TObject);
Var Stwhere : String;
begin


  Stwhere := ' AND BTA_TYPEACTION="PMA"';
  LibTypeAction.caption := ChargeInfoTypeAction(TypeAction.Text,StWhere, False);

end;

procedure TOF_BTEVENTMAT_MUL.FamilleMatOnExit(Sender: TObject);
begin


  LibFamilleMat.caption := ChargeInfoFamMat(FamilleMat.Text, False);

end;

procedure TOF_BTEVENTMAT_MUL.DateOnExit(Sender: TObject);
begin

  DateDeb.text := Borne1.Text;
  DateFin.text := Borne2.Text;

end;


Initialization
  registerclasses ( [ TOF_BTEVENTMAT_MUL ] ) ;
end.

