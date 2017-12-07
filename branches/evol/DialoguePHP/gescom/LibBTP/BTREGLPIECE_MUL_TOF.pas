{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 23/01/2007
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTREGLPIECE_MUL ()
Mots clefs ... : TOF;BTREGLPIECE_MUL
*****************************************************************}
Unit BTREGLPIECE_MUL_TOF ;

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
		 M3FP,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     Ent1,
     AglInitBtp,
     uTofAfBaseCodeAffaire ;

Type
  TOF_BTREGLPIECE_MUL = Class (TOF_AFBASECODEAFFAIRE)
  private
  public
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
    procedure NomsChampsAffaire( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ; override ;

  end ;

procedure SaisieReglementsPiece(Tiers, NaturePiece, Souche : string; Numero, Indice : integer);

Implementation

procedure TOF_BTREGLPIECE_MUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnArgument (S : String ) ;
Var CC 			: THValComboBox ;
    Critere	: string;
    Champ		: string;
    Valeur	: string;
    i_ind 	: integer;
begin
	fMulDeTraitement := true;
  Inherited ;
  fTableName := 'PIECE';
	Critere:=(Trim(ReadTokenSt(S)));

  While (Critere <> '') do
  BEGIN
    i_ind:=pos(':',Critere);
    if i_ind = 0 then i_ind:=pos('=',Critere);
    if i_ind <> 0 then
       begin
       Champ:=copy(Critere,1,i_ind-1);
       Valeur:=Copy (Critere,i_ind+1,length(Critere)-i_ind);
       end
    else
       Champ := Critere;
    Critere:=(Trim(ReadTokenSt(S)));
  END;

CC:=THValComboBox(GetControl('GP_DOMAINE')) ; if CC<>Nil then PositionneDomaineUser(CC) ;
CC:=THValComboBox(GetControl('GP_ETABLISSEMENT')) ;if CC<>Nil then PositionneEtabUser(CC) ;

end ;

procedure TOF_BTREGLPIECE_MUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTREGLPIECE_MUL.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2,
  Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers,
  Tiers_: THEdit);
begin
  inherited;
  Aff:=THEdit(GetControl('GP_AFFAIRE'))   ;
  Aff0:=THEdit(GetControl('GP_AFFAIRE0'));
  Aff1:=THEdit(GetControl('GP_AFFAIRE1')) ;
  Aff2:=THEdit(GetControl('GP_AFFAIRE2')) ;
  Aff3:=THEdit(GetControl('GP_AFFAIRE3')) ;
  Aff4:=THEdit(GetControl('GP_AVENANT'))  ;
  Tiers:=THEdit(GetControl('GP_TIERS'))   ;
end;


procedure DemandeReglementSitDAC( parms: array of variant; nb: integer ) ;
var
  F : TForm;
  Q : TQuery ;
  i :integer;
  Numero, Indice : integer;
  CodeAffaire, Affaireref, NaturePiece, Souche :string;
  Tiers, Mess : string;
  DemandeAcompte,AnnulAcceptation : boolean;
begin
  F:=TForm(Longint(Parms[0]));
  Tiers := string(Parms[1]);
  NaturePiece := string(Parms[2]);
  Souche := string(Parms[3]);
  Numero := Integer(Parms[4]);
  Indice := Integer(Parms[5]);
  SaisieReglementsPiece(Tiers, NaturePiece, Souche, Numero, Indice);
end;


procedure SaisieReglementsPiece(Tiers, NaturePiece,Souche: string; Numero, Indice: integer);
var XX : TAcceptationDocument;
begin
  XX := TAcceptationDocument.create;
  XX.naturePiece := NaturePiece;
  XX.Souche := Souche;
  XX.numero := numero;
  XX.Indice := Indice;
  XX.Tiers := Tiers;
  XX.ChargeLesTobs;
  //
  XX.GereReglements;
  //
  XX.free;
end;

Initialization
  registerclasses ( [ TOF_BTREGLPIECE_MUL ] ) ;
 	RegisterAglProc( 'DemandeReglementSitDAC',True,6,DemandeReglementSitDAC);
end.

