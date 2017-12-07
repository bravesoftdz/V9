{***********UNITE*************************************************
Auteur  ...... : LS
Créé le ...... : 11/04/2007
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTACCEPTAFF_MUL ()
Mots clefs ... : TOF;BTACCEPTAFF_MUL
*****************************************************************}
Unit BTACCEPTAFF_MUL_TOF ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes,
     M3FP,
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul, 
{$else}
     eMul,
     uTob,
     HQry,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     HTB97,
     HDB,
     UTOF,
     utofAfBaseCodeAffaire;

Type
  TOF_BTACCEPTAFF_MUL = Class (TOF_AFBASECODEAFFAIRE)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit); override;
    
  Public

  Private

    BCherche    : TToolbarButton97;
    BOuvrir1		: TToolbarButton97;

    Fliste 			: THDbGrid;

    CodeAffaire	: ThEdit;

    TAffaire		: THLabel;
    TAffaire0		: THLabel;

    ChkModele		: TCheckBox;
    ChkAdmin		: TCheckBox;

    procedure AcceptationAffaire(TheAffaire : string);

    procedure FlisteDblClick(Sender: TObject);
    procedure MultiAcceptation(Sender: TObject);

  end ;

Implementation

procedure TOF_BTACCEPTAFF_MUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnArgument (S : String ) ;
begin
  fMulDeTraitement := true;
  Inherited ;
  fTableName := 'AFFAIRE';

  //RECUPERATION DES ZONES ECRAN
  //
  CodeAffaire := THEDit(GetControl('AFF_AFFAIRE'));
  //
  TAffaire 	:= THLabel(GetControl('TAFF_AFFAIRE'));
  TAffaire0 := THLabel(GetControl('TAFFAIRE0'));
  //
	ChkModele := TCheckBox(GetControl('AFF_MODELE'));
	ChkAdmin  := TCheckBox(GetControl('AFF_ADMINISTRATIF'));
  //
	Fliste := THDbGrid (GetControl('FLISTE'));
  Fliste.OnDblClick := FlisteDblClick;
  //
  BCherche := TtoolBarButton97(GetControl('BCHERCHE'));
  //
  BOuvrir1 := TtoolBarButton97(GetControl('BOUVRIR1'));
  BOuvrir1.OnClick := MultiAcceptation;

  {$IFDEF LINE}
  TTabSheet(GetControl('PCOMPLEMENT',true)).TabVisible := False;
  Ecran.Caption := 'Acceptation Chantier';
  TAffaire.Caption := 'Chantier :';
  TAffaire0.Caption := 'Type de Chantier';
  SetControlText('AFFAIRE0', 'A');
  SetControlProperty('AFFAIRE0', 'Enabled', False);
  ChkModele.Caption := 'Chantier Modele';
  ChkAdmin.Caption  := 'Chantier Administratif';
  UpdateCaption(TFMul(Ecran)) ;
  {$ENDIF}

end ;

procedure TOF_BTACCEPTAFF_MUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTACCEPTAFF_MUL.FlisteDblClick (Sender : TObject);
var TheAffaire : string;
begin

  TheAffaire:= TFmul(ecran).Q.FindField('AFF_AFFAIRE').AsString;

  {$IFDEF LINE}
  if PgiAsk ('Désirez-vous accepter le chantier ?')=MrYes then
  {$ELSE}
  if PgiAsk ('Désirez-vous accepter l''affaire ?')=MrYes then
  {$ENDIF}
 		 AcceptationAffaire(TheAffaire);

  TFmul(ecran).BChercheClick(ecran);

end;

procedure TOF_BTACCEPTAFF_MUL.AcceptationAffaire(TheAffaire : string);
begin

  //Mise à jour de l'affaire !!!
  if (ExecuteSQL ('UPDATE AFFAIRE SET AFF_ETATAFFAIRE="ACP" WHERE AFF_AFFAIRE="'+ TheAffaire +'"')< 1) then
   	 PgiBox ('Erreur Pendant la mise à jour');

end;

Procedure TOF_BTACCEPTAFF_MUL.MultiAcceptation(Sender : TOBJect);
var TheAffaire : String;
    i 			 : integer;
    QQ			 : TQuery;
{$IFDEF EAGLCLIENT}
    L 			 : THGrid;
{$ELSE}
    Ext 		 : String;
    L 			 : THDBGrid;
{$ENDIF}

begin
  Inherited ;

  //controle si au moins un éléments sélectionné
	if (TFmul(ecran).FListe.NbSelected=0)and(not TFmul(ecran).FListe.AllSelected) then
  	 begin
	   PGIInfo('Aucun chantier sélectionné','');
  	 exit;
   	 end;

  //Demande de confirmation du traitement
  {$IFDEF LINE}
  if PgiAsk ('Désirez-vous accepter le(s) chantier(s) sélectionné(s) ?')<>MrYes then
  {$ELSE}
  if PgiAsk ('Désirez-vous accepter l(les)''affaire(s) sélectionnée(s) ?') <> MrYes then
  {$ENDIF}
     Begin
     SourisNormale;
     TFmul(ecran).BChercheClick(ecran);
  	 exit;
     end;

	L:= TFmul(ecran).FListe;

  SourisSablier;

  TRY
	if L.AllSelected then
  	 begin
  	 QQ:= TFmul(ecran).Q;
     QQ.First;
     while not QQ.EOF do
     		Begin
      	TheAffaire:= QQ.findfield('AFF_AFFAIRE').AsString;
      	AcceptationAffaire(TheAffaire);
     		QQ.next;
      	end;
      	//
   	 end
  else
     begin
     for i:=0 to L.NbSelected-1 do
         begin
	       L.GotoLeBookmark(i);
         TheAffaire := TFMul(TFmul(ecran)).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
         AcceptationAffaire(TheAffaire);
         end;
	   end;
   	 L.AllSelected:=False;
	FINALLY
    SourisNormale;
    TFmul(ecran).BChercheClick(ecran);
  END;

End;

procedure TOF_BTACCEPTAFF_MUL.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_:THEdit);
begin

Aff:=THEdit(GetControl('AFF_AFFAIRE'));

// MODIF LS
Aff0 := THEdit(GetControl('AFF_AFFAIRE0'));

// --
Aff1:=THEdit(GetControl('AFF_AFFAIRE1'));
Aff2:=THEdit(GetControl('AFF_AFFAIRE2'));
Aff3:=THEdit(GetControl('AFF_AFFAIRE3'));
Aff4:=THEdit(GetControl('AFF_AVENANT'));
Tiers:=THEdit(GetControl('AFF_TIERS'));

// affaire de référence pour recherche
Aff_:=THEdit(GetControl('AFF_AFFAIREREF'));
Aff1_:=THEdit(GetControl('AFFAIREREF1'));
Aff2_:=THEdit(GetControl('AFFAIREREF2'));
Aff3_:=THEdit(GetControl('AFFAIREREF3'));
Aff4_:=THEdit(GetControl('AFFAIREREF4'));

end;

Initialization
  registerclasses ( [ TOF_BTACCEPTAFF_MUL ] ) ;
end.

