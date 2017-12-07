{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 13/06/2006
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : UTOFBTAFFAPPEL ()
Mots clefs ... : TOF;UTOFBTAFFAPPEL
*****************************************************************}
Unit UTofBtAffAppel ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
     uTob,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HTB97,
     HEnt1,
     HMsgBox,
     HeureUtil,
     UTOF ,
     UTob ;

Type
  TOF_BTAFFAPPEL = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    //procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

Private

  NOMTIERS   : THEdit;
  ADRESSE1   : THEdit;
  ADRESSE2   : THEdit;
  ADRESSE3   : THEdit;
  CODEPOSTAL : THEdit;
  VILLE      : THEdit;
  NOMCONTACT : THEdit;
  TELEPHONE  : THEdit;
  CONTRAT    : THEdit;
  AFFAIRE    : THEdit;
  DATEDEBUT  : THEdit;
  DATEFIN    : THEdit;
  DATEDEB    : THEdit;
  HEUREDEB   : THEdit;
  HEUREFIN   : THEdit;
  DUREE      : THLabel;

  BTHAUTE    : TToolbarButton97;
  BTBASSE    : TToolbarButton97;
  BTNORMALE  : TToolbarButton97;

  LAFFAIRE   : THLabel;

  DESCRIPTIF : TMemo;

  GRBTYPEACTION : TGroupBox;

  GRIDAFFECTATION : THGrid;

  CodeAppel       : String;
  CodeRessource		: String;

  procedure ChargeAppel;
  procedure GridAffectation_OnClick(Sender: TObject);

  end ;

Implementation

uses uBtpChargeTob,PlanUtil ;

procedure TOF_BTAFFAPPEL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFAPPEL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFAPPEL.ChargeAppel;
Var TobTempo : Tob;
    Contact  : Integer;
    I        : Integer;
    Ressource: String;
    Tiers    : String;
    StArg    : String;
    QQ			 : TQuery;
begin

  //chargement de la grille des affectations
  GridAffectation.Cells[0, 0] := 'Affectation';
  GridAffectation.ColLengths[0] := GridAffectation.Width;

  BTHaute.Visible := False;
  BTNormale.Visible := False;
  BTBasse.Visible := False;

  // Chargement de la tob Adresse
  TobTempo := TOB.Create ('Les Adresses', Nil, -1);
  StArg := 'SELECT ADR_LIBELLE, ADR_LIBELLE2, ADR_ADRESSE1,ADR_ADRESSE2,ADR_ADRESSE3, ADR_CODEPOSTAL, ADR_VILLE, ADR_NUMEROCONTACT';
  StArg := StArg + ' FROM ADRESSES WHERE ADR_REFCODE="' + CodeAppel + '"';
  QQ := OpenSql(StArg, True);
  TobTempo.LoadDetailDB('ADRESSES', '', '', QQ, False);

  If TobTempo.detail.count > 0 then
     Begin
     Contact := TobTempo.Detail[0].GetValue('ADR_NUMEROCONTACT');
     NomTiers.text   := TobTempo.Detail[0].GetValue('ADR_LIBELLE') + ' ' + TobTempo.Detail[0].GetValue('ADR_LIBELLE2');
     Adresse1.text   := TobTempo.Detail[0].GetValue('ADR_ADRESSE1');
     Adresse2.text   := TobTempo.Detail[0].GetValue('ADR_ADRESSE2');
     Adresse3.text   := TobTempo.Detail[0].GetValue('ADR_ADRESSE3');
     CodePostal.text := TobTempo.Detail[0].GetValue('ADR_CODEPOSTAL');
     Ville.text      := TobTempo.Detail[0].GetValue('ADR_VILLE');
     end;

  TobTempo.free;

  // Chargement de la tob Affaire
  StArg := 'SELECT AFF_AFFAIRE1, AFF_AFFAIRE2, AFF_AFFAIRE3, AFF_TIERS, ';
  StArg := StArg + 'AFF_DESCRIPTIF, AFF_CHANTIER, AFF_AFFAIREINIT, AFF_PRIOCONTRAT ';
  StArg := StArg + 'FROM AFFAIRE WHERE AFF_AFFAIRE="' + CodeAppel + '"';
  TobTempo := TOB.Create ('Les Affaires', Nil, -1);
  TobTempo.LoadDetailFromSQL(StArg);
  If TobTempo.detail.count > 0 then
     Begin
     LAffaire.caption := 'Appel N°' + TobTempo.Detail[0].GetValue('AFF_AFFAIRE1') + TobTempo.Detail[0].GetValue('AFF_AFFAIRE2') + TobTempo.Detail[0].GetValue('AFF_AFFAIRE3');
     Tiers            := TobTempo.Detail[0].GetValue('AFF_TIERS');
     Contrat.Text     := TobTempo.Detail[0].GetValue('AFF_AFFAIREINIT');
     Affaire.Text     := TobTempo.Detail[0].GetValue('AFF_CHANTIER');
     Descriptif.Text  := TobTempo.Detail[0].GetValue('AFF_DESCRIPTIF');
     if TobTempo.Detail[0].GetValue('AFF_PRIOCONTRAT') = 1 then
        BTHaute.Visible := True
     Else if TobTempo.Detail[0].GetValue('AFF_PRIOCONTRAT') = 2 then
        BTNormale.Visible := True
     Else if TobTempo.Detail[0].GetValue('AFF_PRIOCONTRAT') = 3 then
       BTBasse.Visible := True;
     end;

  TobTempo.free;

  // Chargement de la tob Contact
  StArg := 'SELECT C_NOM, C_PRENOM, C_TELEPHONE FROM CONTACT WHERE C_TIERS="' + Tiers + '" AND C_NUMEROCONTACT=' + IntToStr(Contact);
  TobTempo := TOB.Create ('Les Contacts', Nil, -1);
  TobTempo.LoadDetailFromSQL(StArg);
  If TobTempo.detail.count > 0 then
     Begin
     NomContact.Text := TobTempo.Detail[0].GetValue('C_PRENOM') + ' ' + TobTempo.Detail[0].GetString('C_NOM');
     Telephone.Text  := TobTempo.Detail[0].GetValue('C_TELEPHONE');
     end;

  TobTempo.free;

  //Chargement de la grille affectation
  StArg := 'SELECT ARS_RESSOURCE, ARS_LIBELLE FROM BTEVENPLAN LEFT JOIN RESSOURCE ON BEP_RESSOURCE = ARS_RESSOURCE WHERE BEP_AFFAIRE = "' + CodeAppel + '"';
  TobTempo := TOB.Create ('Affectation', Nil, -1);
  TobTempo.LoadDetailFromSQL (StArg);

  If Assigned(TobTempo) then
     Begin
     TobTempo.PutGridDetail(GRIDAFFECTATION, False, False, 'ARS_LIBELLE');
     end;

  for i := 0 to TobTempo.Detail.count - 1 do
  		begin
      if TobTempo.detail[I].GetValue('ARS_RESSOURCE') = CodeRessource then
         Begin
      	 GridAffectation.Row := I+1;
         Break;
         end;
      end;

  TobTempo.free;

  GridAffectation_Onclick(GridAffectation);


end ;

procedure TOF_BTAFFAPPEL.OnArgument (S : String ) ;
begin
  Inherited ;

  CodeAppel  := Trim(ReadTokenSt(S));;
  CodeRessource := Trim(ReadTokenSt(S));

  //Déclaration des zones écran
  NomTiers   := THEdit(GetControl('NOMTIERS'));
  Adresse1   := THEdit(GetControl('ADRESSE1'));
  Adresse2   := THEdit(GetControl('ADRESSE2'));
  Adresse3   := THEdit(GetControl('ADRESSE3'));
  CodePostal := THEdit(GetControl('CODEPOSTAL'));
  Ville      := THEdit(GetControl('VILLE'));

  NomContact := THEdit(GetControl('NOMCONTACT'));
  Telephone  := THEdit(GetControl('TELEPHONE'));
  Contrat    := THEdit(GetControl('CONTRAT'));
  Affaire    := THEdit(GetControl('AFFAIRE'));

  DateDeb    := THEdit(GetControl('DATEDEB'));
  DateFin    := THEdit(GetControl('DATEFIN'));
  HeureDeb   := THEdit(GetControl('HEUREDEB'));
  HeureFin   := THEdit(GetControl('HEUREFIN'));
  Duree      := THLabel(GetControl('DUREE'));

  LAffaire   := THLabel(GetControl('LAFFAIRE'));

  BTHaute    := TToolbarButton97(GetControl('BTHAUTE'));
  BTNormale  := TToolbarButton97(GetControl('BTNORMALE'));
  BTBasse    := TToolbarButton97(GetControl('BTBASSE'));

  GRBTYPEACTION := TGroupBox(GetControl('GRBTYPEACTION'));

  DESCRIPTIF := TMemo(GetControl('DESCRIPTIF'));

  GRIDAFFECTATION := THGrid(GetControl('GRIDAFFECTATION'));
  GridAffectation.OnClick := GridAffectation_OnClick;

  ChargeAppel;

end ;


procedure TOF_BTAFFAPPEL.GridAffectation_OnClick (Sender: TObject) ;
Var Ressource : String;
    TobTempo  : Tob;
    StArg     : String;
    EcartDuree: double;
    HDebut		: TDateTime;
	  HFin			: TDateTime;
begin
  Inherited ;

  Ressource := GridAffectation.CellValues[0, GridAffectation.Row];

  //Chargement de la partie temps date et durée...
  StArg := 'SELECT BTA_LIBELLE, BEP_DATEDEB, BEP_HEUREDEB, BEP_DATEFIN, BEP_HEUREFIN, BEP_DUREE, AFF_CREERPAR ';
  StArg := StArg + 'FROM BTEVENPLAN LEFT JOIN RESSOURCE ON BEP_RESSOURCE = ARS_RESSOURCE ';
  StArg := StArg + 'LEFT JOIN BTETAT ON BTA_BTETAT = BEP_BTETAT ';
  StArg := StArg + 'LEFT JOIN AFFAIRE ON AFF_AFFAIRE = BEP_AFFAIRE ';
  StArg := StArg + 'WHERE BEP_AFFAIRE = "' + CodeAppel + '" AND ARS_LIBELLE = "' + Ressource + '"';

  TobTempo := TOB.Create ('DateTime', Nil, -1);
  TobTempo.LoadDetailFromSQL (StArg);

  DateDeb.text  := DateToStr(TobTempo.Detail[0].GetValue('BEP_DATEDEB'));
  DateFin.text  := DateToStr(TobTempo.Detail[0].GetValue('BEP_DATEFIN'));
(*
  HeureDeb.text := FormatDateTime('hh:mm',TobTempo.Detail[0].GetValue('BEP_HEUREDEB'));
  //HDebut := StrToTime(HeureDeb.text) + (EcartDuree*60) / 1440;
  HeureFin.text := FormatDateTime('hh:mm',TobTempo.Detail[0].GetValue('BEP_HEUREFIN'));
*)
  HeureDeb.text := TimeToStr(TobTempo.Detail[0].GetValue('BEP_DATEDEB'));
  HeureFin.text := TimeToStr(TobTempo.Detail[0].GetValue('BEP_DATEFIN'));
  EcartDuree    := TobTempo.Detail[0].GetValue('BEP_DUREE');
//  Duree.text    := FormatDateTime('hh:mm',StrToTime(FloatToStr(EcartDuree)));
//  Duree.text    := FormatDateTime('hh:mm',FloatToTime(ecartDuree));
  Duree.caption := LibelleDuree (EcartDuree,false);

  GRBTYPEACTION.Caption := TobTempo.Detail[0].GetValue('BTA_LIBELLE');

  if TobTempo.Detail[0].GetValue('AFF_CREERPAR') = 'TAC' then
     Ecran.Caption := 'Fiche visite préventive sous contrat'
  Else
     Ecran.Caption := 'Fiche Appel';

  TobTempo.free;

end ;

procedure TOF_BTAFFAPPEL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFAPPEL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFAPPEL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTAFFAPPEL.OnUpdate;
begin
  inherited;
end;

Initialization
  registerclasses ( [ TOF_BTAFFAPPEL ] ) ;
end.

