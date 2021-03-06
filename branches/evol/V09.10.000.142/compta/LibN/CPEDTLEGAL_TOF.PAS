{***********UNITE*************************************************
Auteur  ...... : Muriel Dumont
Cr�� le ...... : 23/12/2005
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : CPEDTLEGAL ()
Mots clefs ... : TOF;CPEDTLEGAL

Les �ditions l�gales permettent de lancer automatiquement :
- Le Grand-Livre g�n�ral standard (source UTOFCPGLGENE.PAS) du menu "Editions / Grand-livres"
- Le Grand-Livre auxiliaire standard (source UTOFCPGLAUXI.PAS) du menu "Editions / Grand-livres"
- Le journal des �critures (� partir du nouveau source CPJALOUVCLO_TOF.PAS qui permet d'�diter aussi
  le journal d'ouverture et le journal de cl�ture et dont l'�tat se rapproche le plus de l'�dition
  Quick-report
- La balance g�n�rale mouvement�e (nouveau source CPBALGELEGAL_TOF.PAS)
  Nature : CLO et Code : CFS
  Remarque : on fait appel � l'�tat de la balance de cl�ture dont la pr�sentation correspond
  tout � fait � la balance mouvement�e
- La balance auxiliaire mouvement�e (nouveau source CPBALAULEGAL_TOF.PAS)
  Nature : CBA et Code : CBM

Messages d'erreur :
0;Editions l�gales;Les crit�res que vous avez s�lectionn� ne renvoient aucun enregistrement.;W;O;O;O;
1;Editions l�gales;La fourchette de p�riodes que vous avez renseign�e est incoh�rente;W;O;O;O;
2;Editions l�gales;La p�riode %% n'a pas �t� valid�e.;W;O;O;O;
3;Editions l�gales;Ecritures valid�es jusqu'en %%. Confirmez-vous l'impression de cette (ces) p�riode(s) ?;Q;YN;Y;N
4;Editions l�gales;Vous n'avez s�lectionn� aucune �dition.;E;O;O;O;

*****************************************************************}
Unit CPEDTLEGAL_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     Dialogs,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
     FE_Main,
     QRS1,
{$else}
     eMul,
     uTob,
     MaineAGL,
     EQRS1,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     CritEdt,
     HCtrls,
     HEnt1,
     HMsgBox,
     UTOF,
     Ent1,
     hstatus,
     Htb97,
     TofMeth,
     AGLInit;       // TheData

Type
  TOF_CPEDTLEGAL = Class (TOF)
    { Crit�res }
    GlvAux        : TCheckBox;
    BalAux        : TCheckBox;
    JalDiv        : TCheckBox;
    BalGen        : TCheckBox;
    GlvGen        : TCheckBox;
    Lexercice     : THLabel;
    LPeriode      : THLabel;
    La            : THLabel;
    FDateCompta1  : THEdit;
    FDateCompta2  : THEdit;
    FExercice     : THValComboBox;
    FDateCpta1    : THValComboBox;
    FDateCpta2    : THValComboBox;
    FDate1        : THValComboBox;
    FDate2        : THValComboBox;
    ACritEdt      : ClassCritEdt;

    procedure FexerciceOnChange(Sender: TObject);
    procedure FDateComptaOnChange(Sender: TObject);

    private
    FTypeEdition  : string;
    Continuer     : boolean;
    Crit          : TCritEdt;
    procedure RempliComboExo;
    procedure LanceEdit;
    procedure GenPerExo;
    procedure ChangeDateCompta;
    function  CritEdtOk : Boolean;
    function  PeriodesValidees : Boolean;

    procedure PrepareArgumentEditionsLegales;
    procedure PrepareArgumentGl;
    procedure PrepareArgumentBal;
    procedure LanceEditionGLGene( Sender : TObject );  // Grand Livre G�n�ral
    procedure LanceEditionGLAuxi( Sender : TObject );  // Grand Livre Auxiliaire
    procedure LanceEditionJour  (Sender: TObject);     // Journal des �critures
    procedure LanceEditionBALGene( Sender : TObject ); // Balance G�n�rale
    procedure LanceEditionBALAuxi( Sender : TObject ); // Balance Auxiliaire
    procedure ValiderClick( Sender : TObject );

    public
    procedure OnNew                            ; override ;
    procedure OnDelete                         ; override ;
    procedure OnUpdate                         ; override ;
    procedure OnLoad                           ; override ;
    procedure OnArgument (S : String )         ; override ;
    procedure OnClose                          ; override ;
    procedure OnCancel                         ; override ;
  end ;
  procedure CPLanceFiche_EdtLegal;

Implementation

uses
  {$IFDEF MODENT1}
  CPTypeCons,
  ULibExercice,
  {$ENDIF MODENT1}
  utiledt,UTOFCPGLGENE,
  UTOFCPGLAUXI,CPJALOUVCLO_TOF,
  CPBALGELEGAL_TOF,CPBALAULEGAL_TOF;

procedure CPLanceFiche_EdtLegal;
begin
  AGLLanceFiche('CP','CPEDTLEGAL_QR1','','','LEGAL');
end;

procedure TOF_CPEDTLEGAL.RempliComboExo ;
var
  Q     : TQuery ;
  Texte : String ;
begin
  Texte := 'Select EX_EXERCICE,EX_LIBELLE from EXERCICE' +
           ' Where EX_EXERCICE="' + VH^.EnCours.Code + '" Or EX_EXERCICE="' + VH^.Suivant.Code + '"'  ;
  Q := OpenSql(Texte,True) ;
  FExercice.Values.Clear ;
  FExercice.Items.Clear ;
  while Not Q.EOF do begin
    FExercice.Values.Add(Q.Fields[0].AsString) ;
    FExercice.Items.Add(Q.Fields[1].AsString) ;
    Q.Next ;
    end;
  Ferme(Q) ;
end;

procedure TOF_CPEDTLEGAL.GenPerExo ;
{ Cr�ation des p�riodes comptables pour un exercice donn� }
var
  DateExo  : TExoDate ;
  i        : integer ;
  Annee,
  pMois,
  NbMois   : Word ;
  DD       : TdateTime ;
  D1,
  D2       : String ;

begin
  NbMois:=0 ;
  QuelDateDeExo(FExercice.Value,DateExo) ;
  NOMBREPEREXO(DateExo,pMois,Annee,NbMois) ;
  FDateCpta1.Items.Clear ;
  FDateCpta1.Values.Clear ;
  FDateCpta2.Items.clear ;
  FDateCpta2.Values.Clear ;
  FDate1.Items.Clear ;
  FDate1.Values.Clear ;
  FDate2.Items.Clear ;
  FDate2.Values.Clear ;
  for i:=0 to NbMois-1 do begin
    DD:=PlusMois(DateExo.Deb,i) ;
    D1:=FormatDateTime('mmmm yyyy',DD) ;
    D2:=FormatDateTime('mmmm yyyy',DD) ;
    FDateCpta1.Items.Add(FirstMajuscule(D1));
    FDateCpta2.Items.Add(FirstMajuscule(D2));
    FDateCpta1.Values.Add(IntTostr(i)) ;
    FDateCpta2.Values.Add(IntTostr(i)) ;
    FDate1.Items.Add(DateToStr(DebutdeMois(dd))) ;
    FDate2.Items.Add(DateToStr(FindeMois(dd))) ;
    end;
  FDateCpta1.ItemIndex:=0 ;
  FDateCpta2.ItemIndex:=NbMois-1 ;
  FDate1.ItemIndex:=FDateCpta1.ItemIndex;
  FDate2.ItemIndex:=FDateCpta2.ItemIndex ;
  ChangeDateCompta ;
end;

procedure TOF_CPEDTLEGAL.FExerciceOnChange(Sender: TObject);
begin
  GenPerExo;
end;

procedure TOF_CPEDTLEGAL.ChangeDateCompta ;
begin
  FDateCompta1.Text := FDate1.Items[FDate1.ItemIndex] ;
  FDateCompta2.Text := FDate2.Items[FDate2.ItemIndex] ;
end;

procedure TOF_CPEDTLEGAL.FDateComptaOnChange(Sender: TObject);
begin
  FDate1.ItemIndex := FDateCpta1.ItemIndex;
  FDate2.ItemIndex := FDateCpta2.ItemIndex;
  ChangeDateCompta;
end;

function DonneAnnee(LaDate : TDateTime) : Integer;
Var
  a,m,j : Word ;
begin
  DecodeDate(LaDate,a,m,j);
  Result := a;
end;

function TOF_CPEDTLEGAL.PeriodesValidees : Boolean ;
{ V�rification de la validit� des p�riodes s�lectionn�es }
Var
  Q        : TQuery ;
  Periode  : string[24] ;
  i,
  Nb,
  Prem,
  Dern,
  An1,
  An2,
  Reponse  : integer;
  Termine  : Boolean;
  NouvDate : TDateTime;
  Titre,
  Mess     : string;

begin
  Result := False;
  Termine := False;
  Q := OpenSql('Select EX_VALIDEE From EXERCICE Where EX_EXERCICE="' + Crit.Exo.Code + '"',True);
  Periode := Q.FindField('EX_VALIDEE').AsString;
  Ferme(Q);
  Prem := FDateCpta1.ItemIndex+1;
  An1 := DonneAnnee(Crit.Date1);
  Dern := FDateCpta2.ItemIndex+1;
  An2 := DonneAnnee(Crit.Date2);
  Nb := Dern - Prem + 1;
  i := Prem;
  while (i <= Prem + Nb-1) and (Not Termine) do begin
    if Periode[i] <> 'X' then Termine := True
                         else Inc(i) ;
    end;
  Titre := TraduireMemoire('Editions l�gales');
  if Termine then begin
    if (i-Prem = 0) then begin
      if i > 12 then NouvDate := FinDeMois(EncodeDate(An2,i-12,1))
                else NouvDate := FinDeMois(EncodeDate(An1,i,1)) ;
      //MsgBleme.Execute(2,FormatDateTime('mmmm yyyy',NouvDate),'') ;
      Mess := TraduireMemoire('La p�riode %% n''a pas �t� valid�e.');
      HShowMessage ( '0;' + Titre + ';' + Mess + ';W;O;O;O', FormatDateTime('mmmm yyyy',NouvDate), '' ) ;
      end
    else begin
      if i > 12 then NouvDate := FinDeMois(EncodeDate(An2,i-13,1))
                else NouvDate := FinDeMois(EncodeDate(An1,i-1,1));
      //Reponse := MsgBleme.Execute(3,FormatDateTime('mmmm yyyy',NouvDate),'') ;
      Mess := TraduireMemoire('Ecritures valid�es jusqu''en %%. Confirmez-vous l''impression de cette (ces) p�riode(s) ?');
      Reponse := HShowMessage ( '0;' + Titre + ';' + Mess + ';Q;YN;Y;N', FormatDateTime('mmmm yyyy',NouvDate), '' ) ;
      Case Reponse of
         mrYes : begin
                   Crit.Date2 := NouvDate;
                   Crit.DateFin := Crit.Date2;
                   Result := True;
                   end;
         mrNo  : ;
         end;
      end;
    end
  else begin
      Result := True;
      end;
end;

procedure TOF_CPEDTLEGAL.PrepareArgumentEditionsLegales;
{ Initialisation des crit�res communs � toutes les �ditions }
begin
  // Exercice
  ACritEdt.CritEdt.Exo.Code := Crit.Exo.Code;
  // D�but de la Date Comptable
  ACritEdt.CritEdt.Date1 := Crit.Date1;
  // Fin de la Datecomptable
  ACritEdt.CritEdt.Date2 := Crit.Date2;
  ACritEdt.CritEdt.DateDeb := ACritEdt.CritEdt.Date1;
  ACritEdt.CritEdt.DateFin := ACritEdt.CritEdt.Date2;
  // Type d'Ecritures
  ACritEdt.CritEdt.Qualifpiece := 'N';
  // Devise affich�e
  ACritEdt.CritEdt.DeviseAffichee := 'EUR';
  // Mettre en commentaire la suite dans l'attente d'une impl�mentation future
  // Aper�u avant impression
  // ACritEdt.CritEdt.ApercuAvantImpression := TCheckBox(GetControl('FAPERCU')).Checked;
  // Impression couleur
  // ACritEdt.CritEdt.ImpressionCouleur := TCheckBox(GetControl('FCOULEUR')).Checked;
end;

procedure TOF_CPEDTLEGAL.PrepareArgumentGl;
begin
  // Nature de l'�tat : Grand-Livre
  ACritEdt.CritEdt.NatureEtat := neGL;
  // Pi�ce D�but
  ACritEdt.CritEdt.GL.NumPiece1 := 0;
  // Pi�ce Fin
  ACritEdt.CritEdt.GL.NumPiece2 := 999999999;
  // Justificatif de Solde
  ACritEdt.CritEdt.GL.EnDateSituation := false;
end;

procedure TOF_CPEDTLEGAL.PrepareArgumentBal;
begin
  // Nature de l'�tat : Balance
  ACritEdt.CritEdt.NatureEtat := neBal;
  ACritEdt.CritEdt.AvecComparatif := true;
end;

procedure TOF_CPEDTLEGAL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_CPEDTLEGAL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_CPEDTLEGAL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_CPEDTLEGAL.LanceEditionGLGene(Sender: TObject);
{ Lancement de l'�dition du Grand-Livre g�n�ral }
begin
  Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
  PrepareArgumentEditionsLegales;
  PrepareArgumentGl;
  TheData := ACritEdt;
  CPLanceFiche_CPGLGene('LEGALE');
  TheData := nil;
end;

procedure TOF_CPEDTLEGAL.LanceEditionBALGene(Sender: TObject);
{ Lancement de l'�dition de la Balance g�n�rale }
begin
  Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
  PrepareArgumentEditionsLegales;
  PrepareArgumentBal;
  TheData := ACritEdt;
  //CPLanceFiche_CPBALGELEGAL('');
  CPLanceFiche_CPBALGELEGAL(TCheckBox(GetControl('FAPERCU')).Checked,TCheckBox(GetControl('FCOULEUR')).Checked);
  TheData := nil;
end;

procedure TOF_CPEDTLEGAL.LanceEditionBALAuxi(Sender: TObject);
{ Lancement de l'�dition de la Balance auxiliaire }
begin
  Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
  PrepareArgumentEditionsLegales;
  PrepareArgumentBal;
  TheData := ACritEdt;
  //CPLanceFiche_CPBALAULEGAL('');
  CPLanceFiche_CPBALAULEGAL(TCheckBox(GetControl('FAPERCU')).Checked,TCheckBox(GetControl('FCOULEUR')).Checked);
  TheData := nil;
end;

procedure TOF_CPEDTLEGAL.LanceEditionGLAuxi(Sender: TObject);
{ Lancement de l'�dition du Grand-Livre auxiliaire }
begin
  Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
  PrepareArgumentEditionsLegales;
  PrepareArgumentGl;
  TheData := ACritEdt;
  CPLanceFiche_CPGLAuxi('LEGALE');
  TheData := nil;
end;

procedure TOF_CPEDTLEGAL.LanceEditionJour(Sender: TObject);
{ Lancement de l'�dition du Journal }
begin
  Fillchar(ACritEdt.CritEdt, SizeOf(ACritEdt.CritEdt), #0);
  PrepareArgumentEditionsLegales;
  ACritEdt.CritEdt.NatureEtat := neJal;
  TheData := ACritEdt;
  LanceEdLegaleJo(TCheckBox(GetControl('FAPERCU')).Checked,TCheckBox(GetControl('FCOULEUR')).Checked);
  //CPLanceFiche_CPJALOUVCLO('L','');
  TheData := nil;
end;

procedure TOF_CPEDTLEGAL.LanceEdit;
{ Lancement des �ditions }
var
  lstTitre : string;
begin
  lsttitre := Ecran.caption;
  if (GlvAux.Checked) and (Continuer) then begin
    Ecran.caption := lstTitre + ' - ' + TraduireMemoire('Pr�paration du Grand-Livre auxiliaire en cours ....');
    UpdateCaption(ecran);
    LanceEditionGlAuxi(nil);
    end;

  if (GlvGen.Checked) and (Continuer) then begin
    Ecran.caption := lstTitre + ' - ' + TraduireMemoire('Pr�paration du Grand-Livre g�n�ral en cours ....');
    UpdateCaption(ecran);
    LanceEditionGLGene(nil);
    end;

  if (BalAux.Checked) and (Continuer) then begin
    Ecran.caption := lstTitre + ' - ' + TraduireMemoire('Pr�paration de la Balance auxiliaire en cours ....');
    UpdateCaption(ecran);
    LanceEditionBALAuxi(nil);
    end;

  if (BalGen.Checked) and (Continuer) then begin
    Ecran.caption := lstTitre + ' - ' + TraduireMemoire('Pr�paration de la Balance g�n�rale en cours ....');
    UpdateCaption(ecran);
    LanceEditionBALGene(nil);
    end;

  if (JalDiv.Checked) and (Continuer) then begin
    Ecran.caption := lstTitre + ' - ' + TraduireMemoire('Pr�paration du Journal des �critures en cours ....');
    UpdateCaption(ecran);
    LanceEditionJour(nil);
    end;

  Ecran.caption := lstTitre;
  UpdateCaption(ecran);
end;

function  TOF_CPEDTLEGAL.CritEdtOk : Boolean ;
{ V�rification des crit�res d'�dition }
var
  Titre,
  Mess    : string;
begin
  Fillchar(Crit,SizeOf(Crit),#0);
  Crit.Exo.Code := FExercice.Value;
  Crit.Date1 := StrToDate(FDateCompta1.Text);
  Crit.Date2 := StrToDate(FDateCompta2.Text);
  Crit.DateDeb := Crit.Date1;
  Crit.DateFin := Crit.Date2;
  Titre := TraduireMemoire('Editions l�gales');
  if not(GLvAux.Checked or GLvGen.Checked
     or BalAux.Checked or BalGen.Checked or JalDiv.Checked) then begin
    Mess := TraduireMemoire('Vous n''avez s�lectionn� aucune �dition.');
    HShowMessage ( '0;' + Titre + ';' + Mess + ';E;O;O;O', '', '' ) ;
    //MsgBleme.Execute(4,'','') ;
    Result:=False ;
    end
  else begin
    Result := CtrlPerExo(Crit.DateDeb, Crit.DateFin);
    //if Not Result then MsgBleme.Execute(1,'','') ;
    Mess := TraduireMemoire('Les crit�res que vous avez s�lectionn� ne renvoient aucun enregistrement.');
    if not Result then HShowMessage ( '0;' + Titre + ';' + Mess + ';W;O;O;O', '', '' );
    end;
end ;

procedure TOF_CPEDTLEGAL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_CPEDTLEGAL.ValiderClick(Sender:Tobject);
begin
  { Remarque : il ne faut pas lancer les �ditions dans le "OnLoad" sinon en version CWAS
    le message suivant appara�t : "L'�tat n'a pu �tre cr��" }
  Continuer := True ;
  if CritEdtOk and PeriodesValidees then begin
    LanceEdit ;
    end;
end ;

procedure TOF_CPEDTLEGAL.OnArgument (S : String );

begin
  Inherited ;
  ACritEdt := ClassCritEdt.Create;
  FTypeEdition := ReadTokenSt(S);
  TFQRS1(Ecran).FNomFiltre := 'LEGAL' ;
  Ecran.HelpContext := 7712000;
  Continuer := True;
  if CtxPcl in V_Pgi.PgiContexte then
    JalDiv.Caption := '&' + TraduireMemoire('Journal des �critures')
  else
    JalDiv.Caption := '&' + TraduireMemoire('Journal divisionnaire');

  {Crit�res}
  FExercice       := THValComboBox(Getcontrol('FExercice', true));
  FDateCpta1      := THValComboBox(Getcontrol('FDateCpta1', true));
  FDateCpta2      := THValComboBox(Getcontrol('FDateCpta2', true));
  FDate1          := THValComboBox(Getcontrol('FDate1', true));
  FDate2          := THValComboBox(Getcontrol('FDate2', true));
  FDateCompta1    := THEdit(GetControl('FDateCompta1'));
  FDateCompta2    := THEdit(GetControl('FDateCompta2'));
  GlvAux          := TCheckBox(GetControl('GlvAux')) ;
  BalAux          := TCheckBox(GetControl('BalAux')) ;
  JalDiv          := TCheckBox(GetControl('JalDiv')) ;
  BalGen          := TCheckBox(GetControl('BalGen')) ;
  GlvGen          := TCheckBox(GetControl('GlvGen')) ;
  RempliComboExo;
  FExercice.Value := VH^.Entree.Code;
  if FExercice <> nil then begin
    FExercice.OnChange := FExerciceOnChange;
    FExercice.OnChange(NIL);
    end;
  if FDateCompta1 <> nil then FDateCompta1.OnChange := FDateComptaOnChange;
  if FDateCompta2 <> nil then FDateCompta2.OnChange := FDateComptaOnChange;
  if FDateCpta1 <> nil then FDateCpta1.OnChange := FDateComptaOnChange;
  if FDateCpta2 <> nil then FDateCpta2.OnChange := FDateComptaOnChange;
  TToolBarButton97(GetControl('BVALIDER',true)).Onclick := ValiderClick;
end ;

procedure TOF_CPEDTLEGAL.OnClose ;
begin
  Inherited ;
  if Assigned(ACritEdt) then FreeAndNil(ACritEdt);
end ;

procedure TOF_CPEDTLEGAL.OnCancel;
begin
  Inherited ;
  Continuer := False;
end ;

Initialization
  registerclasses ( [ TOF_CPEDTLEGAL ] ) ;
end.



