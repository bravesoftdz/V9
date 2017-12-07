{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 03/06/2015
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTTYPEACTIONMAT ()
Mots clefs ... : TOF;BTTYPEACTIONMAT
*****************************************************************}
Unit BTAFFECTATION_TOF ;

Interface

Uses StdCtrls, 
     Controls,
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     eMul, 
     uTob,
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1,
     HMsgBox,
     uTOB,
     HTB97,
     UTOF ;

Type
  TOF_BTAFFECTATION = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    Action          : TActionFiche;
    //
    Materiel        : THEdit;
    Ressource       : THEdit;
    DateDeb         : THEdit;
    DateFin         : THEdit;
    //
    //
    NumAffect       : THLabel;
    StMateriel      : THLabel;
    StRessource     : THLabel;
    //
    BTDelete        : TToolBarButton97;
    //
    TobAffectation  : Tob;
    //
    StSQL           : String;
    //
    QQ              : TQuery;
    //
    procedure ChargeZoneEcran;
    procedure ChargeZoneTOB;
    procedure Controlechamp(Champ, Valeur: String);
    function  ControleZoneEcran: Boolean;
    procedure CreateTOB;
    procedure DestroyTOB;
    procedure GetObjects;
    procedure MaterielOnElipsisClick(Sender: TObject);
    procedure MaterielOnExit(Sender: TObject);
    procedure RessourceOnElipsisClick(Sender: TObject);
    procedure RessourceOnExit(Sender: TObject);
    procedure SetScreenEvents;
    procedure CalculNoCompteur;
    procedure RazZoneEcran;
  end ;

const
	// libellés des messages
  TexteMessage: array[1..7] of string  = (
          {1}  'Le Code Matériel est obligatoire'
          {2}, 'Le Code Ressource est obligatoire'
          {3}, 'Suppression impossible ce Type Action est utilisé sur un Evénement'
          {4}, 'La suppression a échoué'
          {5}, 'La date de début doit être inférieure ou égale à la date de fin'
          {6}, 'La date de fin doit être supérieure ou égale à la date de début'
          {7}, 'Création Impossible, numéro non déterminé !'
                                         );

Implementation

uses AffaireUtil,
     AGLInitGC,
     LookUp,
     BTPUtil,
     FactUtil,
     UtilsParc;

procedure TOF_BTAFFECTATION.OnNew ;
begin
  Inherited ;
  //
end ;

procedure TOF_BTAFFECTATION.OnDelete ;
begin
  Inherited ;

  //suppression pure et simple de l'enregistrement avec confirmation
  StSQL := 'DELETE BTAFFECTATION WHERE BFF_IDAFFECTATION="' + NumAffect.Caption + '"';
  if ExecuteSQL(StSQL)=0 then PGIError(TexteMessage[3], 'Affectation');

  OnClose;

end ;

procedure TOF_BTAFFECTATION.OnUpdate ;
begin
  Inherited ;

  Ecran.ModalResult := 0;

  if ControleZoneEcran then
  Begin
    if Action = TaCreat then CalculNoCompteur;
    ChargeZoneTOB;
    //mise à jour de la table Famille Matériel
    TobAffectation.InsertOrUpdateDB(True);
    Ecran.ModalResult := 1;
  end;

end ;

procedure TOF_BTAFFECTATION.OnLoad ;
begin
  Inherited ;

  StSQL := 'SELECT * FROM BTAFFECTATION WHERE BFF_IDAFFECTATION="' + NumAffect.Caption + '"';
  QQ := OpenSQL(StSQL, True);

  If not QQ.Eof then
  begin
    TobAffectation.SelectDB('BTAFFECTATION', QQ);
    ChargeZoneEcran;
  end;

  ferme(QQ);

end ;

procedure TOF_BTAFFECTATION.OnArgument (S : String ) ;
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
  CreateTOB;
  //
  Critere := uppercase(Trim(ReadTokenSt(S)));
  while Critere <> '' do
  begin
     x := pos('=', Critere);
     if x <> 0 then
        begin
        Champ  := copy(Critere, 1, x - 1);
        Valeur := copy(Critere, x + 1, length(Critere));
        end
     else
        Champ := Critere;
     ControleChamp(Champ, Valeur);
     Critere:= uppercase(Trim(ReadTokenSt(S)));
  end;

  //Gestion des évènement des zones écran
  SetScreenEvents;

  if Action = TaCreat then
  begin
    RazZoneEcran;
    if Materiel.Text <> '' then
    begin
      Materiel.ElipsisButton:= False;
      Materiel.Enabled      := False;
      StMateriel.caption    := ChargeInfoMateriel(Materiel.Text, True);
      DateDeb.Text          := DateToStr(Now);
      Datefin.Text          := DateToStr(idate2099);
    end
    else
    begin
      Materiel.Enabled      := True;
      Materiel.ElipsisButton:= True;
    end;
  end
  else
  begin
    Materiel.Enabled        := False;
    Materiel.ElipsisButton  := False;
    //StMateriel.caption      := ChargeInfoMateriel(Materiel.Text, False);
  end;

end ;

procedure TOF_BTAFFECTATION.OnClose ;
begin
  Inherited ;

  DestroyTOB;

end ;

procedure TOF_BTAFFECTATION.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFECTATION.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFECTATION.GetObjects;
begin

  NumAffect       := THLabel(Getcontrol('BFF_IDAFFECTATION'));
  //
  Materiel        := THEdit(Getcontrol('BFF_CODEMATERIEL'));
  Ressource       := THEdit(Getcontrol('BFF_RESSOURCE'));
  DateDeb         := THEdit(Getcontrol('DATEAFF'));
  DateFin         := THEdit(GetControl('DATEAFF_'));
  //
  StMateriel      := THLabel(GetControl('StMATERIEL'));
  StRessource     := THLabel(GetControl('StRESSOURCE'));
  //
  BtDelete        := TToolBarButton97(GetCONTROL('BDELETE'));

end;

procedure TOF_BTAFFECTATION.SetScreenEvents;
begin

  //
  Materiel.Onexit         := MaterielOnExit;
  Ressource.Onexit        := RessourceOnExit;
  //
  Materiel.OnElipsisClick := MaterielOnElipsisClick;
  //
  Ressource.OnElipsisClick:= RessourceOnElipsisClick;
  //
end;

Procedure TOF_BTAFFECTATION.MaterielOnExit(Sender : TObject);
begin

  if Materiel.text <> '' then
    StMateriel.caption := ChargeInfoMateriel(Materiel.Text, True)
  else
    Materiel.SetFocus;

end;

Procedure TOF_BTAFFECTATION.RessourceOnExit(Sender : TObject);
Var StWhere : string;
begin

  stWhere := 'AND  ARS_TYPERESSOURCE="SAL"';

  if Ressource.text <> '' then
    StRessource.Caption := ChargeInfoRessource(Ressource.text, StWhere, True)
  else
    Ressource.setfocus;

end;

Procedure TOF_BTAFFECTATION.MaterielOnElipsisClick(Sender : TObject);
Var StChamps  : string;
    StWhere   : string;
    Title     : string;
Begin

  StChamps  := Materiel.Text;
  StWhere   := '';

  title := 'Recherche Matériel';

  if not LookupList(Materiel,Title,'BTMATERIEL','BMA_CODEMATERIEL','BMA_LIBELLE',StWhere,'BMA_LIBELLE',True,61) then Exit;

  StMateriel.caption := ChargeInfoMateriel(Materiel.Text, True);

end;
Procedure TOF_BTAFFECTATION.RessourceOnElipsisClick(Sender : TObject);
Var StChamps  : string;
    StWhere   : string;
begin

  StChamps  := Ressource.Text;

  stWhere := 'ARS_TYPERESSOURCE="SAL"';

  DispatchRecherche(Ressource, 3, StWhere,'ARS_RESSOURCE=' + Trim(Ressource.Text), '');

  StRessource.caption := ChargeInfoRessource(Ressource.text, ' AND ' + StWhere, True);

end;

Procedure TOF_BTAFFECTATION.Controlechamp(Champ, Valeur : String);
Var Date1 : TdateTime;
    Date2 : TdateTime;
begin

  if Champ = 'ACTION' then
  begin
    if      Valeur='CREATION'     then Action:=taCreat
    else if Valeur='MODIFICATION' then Action:=taModif
    else if Valeur='CONSULTATION' then Action:=taConsult;
  end;

  if      Champ = 'MATERIEL'      then Materiel.Text      := Valeur
  else if Champ = 'RESSOURCE'     then Ressource.Text     := Valeur
  else if Champ = 'IDAFFECTATION' then NumAffect.Caption  := Valeur
  else if Champ = 'DATEDEB'       then
  begin
    Date1         := StrToDate(Valeur);
    DateDeb.Text  := DateToStr(Date1);
  end
  else if Champ='DATEFIN'         then
  begin
    Date2         := StrToDate(Valeur);
    DateFin.Text  := DateToStr(Date2);
  end;  

end;

Procedure TOF_BTAFFECTATION.CreateTOB;
begin

  TobAffectation := Tob.Create('BTAFFECTATION', nil, -1);

end;

procedure TOF_BTAFFECTATION.DestroyTOB;
begin

  FreeAndNil(TobAffectation);

end;

Procedure TOF_BTAFFECTATION.ChargeZoneEcran;
Var StWhere : String;
begin

  NumAffect.Caption := TobAffectation.GetString('BFF_IDAFFECTATION');
  //
  Materiel.Text    := TobAffectation.GetString('BFF_CODEMATERIEL');
  if Materiel.text <> '' then StMateriel.caption := ChargeInfoMateriel(Materiel.Text, False);

  Ressource.Text  := TobAffectation.GetString('BFF_RESSOURCE');
  if Ressource.text <> '' then
  Begin
    stWhere := 'AND  ARS_TYPERESSOURCE="SAL"';
    StRessource.Caption := ChargeInfoRessource(Ressource.text, StWhere, False);
  end;

  DateDeb.Text      := TobAffectation.GetString('BFF_DATEDEB');
  DateFin.Text      := TobAffectation.GetString('BFF_DATEFIN');

end;

function TOF_BTAFFECTATION.ControleZoneEcran : Boolean;
Var Date1 : TDateTime;
    Date2 : TDateTime;
begin

  Result := False;

  if Materiel.text = '' then
  begin
    PGIError(TexteMessage[1], 'Affectation');
    Materiel.SetFocus;
    Exit;
  end;

  if Ressource.text = '' then
  begin
    PGIError(TexteMessage[2], 'Affectation');
    Ressource.SetFocus;
    Exit;
  end;

  Date1 := StrToDate(DateDeb.Text);
  Date2 := StrToDate(Datefin.Text);

  if Date1 > Date2 then
  begin
    PGIError(TexteMessage[5], 'Affectation');
    Datedeb.SetFocus;
    Exit;
  end;

  if Date2 < Date1 then
  begin
    PGIError(TexteMessage[6], 'Affectation');
    DateFin.SetFocus;
    Exit;
  end;

  Result := True;

end;

Procedure TOF_BTAFFECTATION.ChargeZoneTOB;
begin

  TobAffectation.PutValue('BFF_IDAFFECTATION',NumAffect.Caption);
  //
  TobAffectation.PutValue('BFF_CODEMATERIEL', Materiel.Text);
  TobAffectation.PutValue('BFF_RESSOURCE',    Ressource.Text);
  TobAffectation.PutValue('BFF_DATEDEB',      DateDeb.Text);
  TobAffectation.PutValue('BFF_DATEFIN',      DateFin.Text);

end;

procedure TOF_BTAFFECTATION.CalculNoCompteur;
Var NumAff : Integer;
begin       

  if not GetNumCompteur('BFF',iDate1900, NumAff) then
  begin
    PGIError(TexteMessage[7], 'Affectation Matériel');
    OnClose;
  end
  else NumAffect.Caption := IntToStr(NumAff);

end;

Procedure TOF_BTAFFECTATION.RazZoneEcran;
begin

  Ressource.Text      := '';
  DateDeb.Text        := DateToStr(idate1900);
  DateFin.Text        := DateToStr(idate2099);
  //
  StMateriel.Caption  := '...';
  StRessource.Caption := '...';
  //
  BtDelete.visible := False;

end;


Initialization
  registerclasses ( [ TOF_BTAFFECTATION ] ) ;
end.

