{***********UNITE*************************************************
Auteur  ...... :
Créé le ...... : 06/06/2001
Modifié le ... :   /  /
Description .. : Source TOF de la TABLE : BTPARIMPDOC ()
Mots clefs ... : TOF;BTPARIMPDOC
*****************************************************************}
Unit UTOFBTPARIMPDOC ;

Interface

uses  M3FP, StdCtrls,Controls,Classes,forms,sysutils,ComCtrls,
      HCtrls,HEnt1,HMsgBox,UTOB,menus, EntGC,FactUtil,UtilPGI,HRichOLE,
      FactTOB,
{$IFDEF EAGLCLIENT}
      MaineAGL,
{$ELSE}
      Fe_Main, db,{$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}MajTable,
{$ENDIF}
      UTOF, AglInit, BTPUtil,uEntCommun,UtilTOBPiece;

Type
  TOF_BTPARIMPDOC = Class (TOF)
    private
    TOBBPD,TOBLIENSOLE : TOB;
    Numero : Integer;
    ClotureFac : boolean;
    validation : boolean;
    NaturePiece,Souche : string;
    procedure ChargeLiensOle(NATUREPIECE, SOUCHE: String);
    procedure AlimenteBlocNotes(Edit1, Edit2: THRichEditOle);
    procedure EnregistreLiensOle(Edit1, Edit2: THRicheditOle);
    public
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (stArgument : String ) ; override ;
    procedure OnClose                  ; override ;
  end ;

Implementation

procedure TOF_BTPARIMPDOC.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTPARIMPDOC.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTPARIMPDOC.OnUpdate ;
begin
  Inherited ;
TOBBPD.GetEcran(Ecran,Nil);

EnregistreLiensOle (THricheditOle(GetControl ('RENTETE')),THricheditOle(GetControl ('RPIED')));

if (TOBBPD.isOneModifie = True) then
  begin
  TOBBPD.SetAllModifie (true);
  if (TOBBPD.Getvalue('BPD_NUMPIECE') = 0) then TOBBPD.Putvalue('BPD_NUMPIECE', Numero) ;
  TOBBPD.InsertOrUpdateDB(False);
  end;
Validation := True;
end ;

procedure TOF_BTPARIMPDOC.OnLoad ;
begin
  Inherited ;
  Validation := False;
end ;

procedure TOF_BTPARIMPDOC.OnArgument (stArgument : String ) ;
Var Tmp, Champ, Valeur, Codessaff, Typefacturation : string;
    QQ : TQuery;
    X, Typep, Typessd : integer;
BEGIN
Inherited;
//récupération des paramètres
Tmp:='';
Tmp:=(Trim(ReadTokenSt(stArgument)));
While (Tmp <> '') do
    BEGIN
    if Tmp<>'' then
        BEGIN
        X:=pos(':',Tmp);
        if x = 0 then X:=pos('=',Tmp);
        if x<>0 then
           begin
           Champ:=copy(Tmp,1,X-1);
           Valeur:=Copy (Tmp,X+1,length(Tmp)-X);
           end;
        if Champ='NATURE' then SetControlText('BPD_NATUREPIECE',valeur);
        if Champ='SOUCHE' then SetControlText('BPD_SOUCHE',valeur);
        if Champ='NUMERO' then SetControlText('BPD_NUMPIECE',valeur);
        if Champ='AFFAIRE' then Codessaff := valeur;
        if TMP='DGD' then ClotureFac:=True;
        END;
    Tmp:=(Trim(ReadTokenSt(stArgument)));
    END;

// mise à jour caption
Ecran.Caption := 'Paramétrage de l''impression des documents de type : '+GetInfoParPiece(GetControlText('BPD_NATUREPIECE'),'GPP_LIBELLE') ;;
UpdateCaption(Ecran);

// Lecture paramétrage pour le numéro de pièce transmis
NaturePiece := GetControlText('BPD_NATUREPIECE');
Souche := GetControlText('BPD_SOUCHE');
Numero :=  StrToInt(GetControlText('BPD_NUMPIECE'));
TOBLIENSOLE := TOB.create ('LESLIENSOLE',nil,-1);
if Numero = 0 then
   begin
   SetControlProperty ('TENTETE','tabvisible',true);
   SetControlProperty ('TPIED','tabvisible',true);
   ChargeLiensOle (NaturePiece,Souche);
   AlimenteBlocNotes (THricheditOle(GetControl ('RENTETE')),THricheditOle(GetControl ('RPIED')));
   end;

TOBBPD := TOB.Create('BTPARDOC',nil,-1);
QQ:=OpenSQL('SELECT * FROM BTPARDOC WHERE BPD_NATUREPIECE="'+NaturePiece+'" AND BPD_SOUCHE="'+Souche+'" AND BPD_NUMPIECE='+ intToStr(Numero),True) ;
If Not QQ.EOF then
  Begin
    TOBBPD.SelectDB('',QQ);
    TOBBPD.PutEcran(Ecran,Nil);
  End
else
  Begin
  Ferme(QQ);
  QQ:=OpenSQL('SELECT * FROM BTPARDOC WHERE BPD_NATUREPIECE="'+NaturePiece+'" AND BPD_SOUCHE="'+Souche+'" AND BPD_NUMPIECE=0',True) ;
  If Not QQ.EOF then
    Begin
    TOBBPD.SelectDB('',QQ);
    TOBBPD.PutEcran(Ecran,Nil);
    End
  else
    Begin
    SetControlProperty ('BPD_TYPEPRES','Value',DOU_TOUS);
    SetControlText('BPD_IMPTOTPAR', 'X');
    SetControlText('BPD_IMPTOTSSP', 'X');
    SetControlProperty ('BPD_TYPESSD','Value',0);
    SetControlText('BPD_IMPCOLONNES', '-');
    SetControlText('BPD_IMPMETRE', 'S');
    SetControlText('BPD_TYPBLOCNOTE', 'D');
    SetControlText('BPD_SAUTAPRTXTDEB', '-');
    SetControlText('BPD_SAUTAVTTXTFIN', '-');
    SetControlText('BPD_IMPRECPAR', '-');
    SetControlText('BPD_IMPRECSIT', '-');
    SetControlText('BPD_IMPTABTOTSIT', '-');
    SetControlText('BPD_IMPDESCRIPTIF', 'I');
    SetControlText('BPD_DESCREMPLACE', '-');
    SetControlText('BPD_IMPRVIATOB', 'X');
    SetControlText('BPD_IMPBASPAGE', '-');
    End;
  End;

Ferme(QQ) ;

Typep := StrToInt(GetControlText('BPD_TYPEPRES'));
SetControlProperty ('BPD_TYPEPRES','Value',DOU_AUCUN);

if (Typep and DOU_CODE) = DOU_CODE then
  SetControlChecked('CB_CODE',True);
if (Typep and DOU_LIBELLE) = DOU_LIBELLE then
  SetControlChecked('CB_LIBELLE',True);
if (Typep and DOU_QTE) = DOU_QTE then
  SetControlChecked('CB_QTE',True);
if (Typep and DOU_UNITE) = DOU_UNITE then
  SetControlChecked('CB_UNITE',True);
if (Typep and DOU_PU) = DOU_PU then
  SetControlChecked('CB_PU',True);
if (Typep and DOU_MONTANT) = DOU_MONTANT then
  SetControlChecked('CB_MONTANT',True);

Typessd := StrToInt(GetControlText('BPD_TYPESSD'));
if Typessd < DOU_AUCUN then
  SetControlChecked('RB_SSD1',True)
else if Typessd = DOU_AUCUN then
  SetControlChecked('RB_SSD2',True)
else
  begin
  SetControlChecked('RB_SSD3',True);
  SetControlVisible ('GB1',True);
  SetControlProperty ('BPD_TYPESSD','Value',DOU_AUCUN);
  if (Typessd and DOU_CODE) = DOU_CODE then
    SetControlChecked('CB_CODE1',True);
  if (Typessd and DOU_LIBELLE) = DOU_LIBELLE then
    SetControlChecked('CB_LIBELLE1',True);
  if (Typessd and DOU_QTE) = DOU_QTE then
    SetControlChecked('CB_QTE1',True);
  if (Typessd and DOU_UNITE) = DOU_UNITE then
    SetControlChecked('CB_UNITE1',True);
  if (Typessd and DOU_PU) = DOU_PU then
    SetControlChecked('CB_PU1',True);
  if (Typessd and DOU_MONTANT) = DOU_MONTANT then
    SetControlChecked('CB_MONTANT1',True);
  end;

SetControlChecked('C_IMPRECPAR',(GetControlText('BPD_IMPRECPAR') = 'X'));
SetControlVisible ('C_IMPRECSIT',False);
SetControlVisible ('C_IMPTABTOTSIT',False);
if (NaturePiece = 'FBT') or (NaturePiece = 'DAC') then
   begin
   TypeFacturation := RenvoieTypeFact(Codessaff);
   if ((numero = 0) or
       (typefacturation='AVA') or
       (typefacturation='DAC')) then
      begin
      SetControlVisible ('C_IMPRECSIT',True);
      SetControlChecked('C_IMPRECSIT',(GetControlText('BPD_IMPRECSIT') = 'X'));
      SetControlVisible ('C_IMPTABTOTSIT',True);
      SetControlChecked('C_IMPTABTOTSIT',(GetControlText('BPD_IMPTABTOTSIT') = 'X'));
      end;
   end;

SetControlChecked('C_IMPTOTPAR',(GetControlText('BPD_IMPTOTPAR') = 'X'));
SetControlChecked('C_IMPTOTSSP',(GetControlText('BPD_IMPTOTSSP') = 'X')) ;
SetControlChecked('C_IMPCOLONNES',(GetControlText('BPD_IMPCOLONNES') = 'X')) ;
SetControlChecked('C_IMPMETRE',(GetControlText('BPD_IMPMETRE') = 'T')) ;
SetControlChecked('C_TYPBLOCNOTE',(GetControlText('BPD_TYPBLOCNOTE') = 'L')) ;
SetControlChecked('C_SAUTTXTDEB',(GetControlText('BPD_SAUTAPRTXTDEB') = 'X')) ;
SetControlChecked('C_SAUTTXTFIN',(GetControlText('BPD_SAUTAVTTXTFIN') = 'X')) ;
SetControlChecked('C_IMPBASPAGE',(GetControlText('BPD_IMPBASPAGE') = 'X')) ;

if (GetControlText('BPD_IMPDESCRIPTIF') = 'S') then
  begin
  SetControlChecked('RB_SDESC',True);
  SetControlVisible ('C_DESCREMPLACE',False);
  end
else if (GetControlText('BPD_IMPDESCRIPTIF') = 'T') then
  SetControlChecked('RB_TDESC',True)
else
  SetControlChecked('RB_IDESC',True);

SetControlChecked('C_DESCREMPLACE',(GetControlText('BPD_DESCREMPLACE') = 'X'));

if (ctxChr in V_PGI.PGIContexte) then // RH le 13/10/2003
  begin
  SetControlProperty ('TGENERAL','tabvisible',false);
  SetControlProperty ('TENTETE', 'tabvisible',false);
  end;

if (NaturePiece <> VH_GC.AFNatAffaire) and (NaturePiece <> VH_GC.AFNatProposition) then
begin
//  if (Naturepiece = 'ABT') or ((Naturepiece = 'FBT') and (typefacturation = 'DIR')) then : tests BRL
  if (Naturepiece = 'ABT') or (Naturepiece = 'FBT') or (NaturePiece = 'DAC') or (NaturePiece = 'BCE') then
     SetControlChecked('C_IMPRVIATOB',(GetControlText('BPD_IMPRVIATOB') = 'X'))
  else
  begin
     SetControlVisible ('C_IMPRVIATOB',False);
     SetControlText('BPD_IMPRVIATOB','-');
  end;
end else
begin
  SetControlChecked('C_IMPRVIATOB',(GetControlText('BPD_IMPRVIATOB') = 'X'));
end;

if ClotureFac then
begin
	SetControlChecked('C_IMPRVIATOB',true);
  SetControlEnabled('C_IMPRVIATOB',false);
end;

if Pos(NaturePiece,'ABC;FBC;')>0 then
begin
  SetControlProperty ('TGENERAL','tabvisible',false);
end;
(*
{$IFDEF LINE}
  if (NaturePiece = 'FBT') And (TypeFacturation <> 'DIR') then
     Begin
     SetControlChecked('C_IMPRVIATOB',False);
     SetControlText('BPD_IMPRVIATOB','-');
     End
  else
     Begin
	   SetControlChecked('C_IMPRVIATOB',True);
     SetControlText('BPD_IMPRVIATOB','X');
     end;

  SetControlVisible('C_IMPRVIATOB',false);
  SetControlChecked('C_IMPMETRE',False);
  SetControlText('BPD_IMPMETRE','-');
  SetControlVisible('C_IMPMETRE',false);
  SetControlVisible('C_TYPBLOCNOTE',false);
{$ENDIF}
*)
end;

procedure TOF_BTPARIMPDOC.OnClose ;
begin
  Inherited ;
TOBBPD.GetEcran(Ecran,Nil);
if (TOBBPD.isOneModifie = True) and (Validation = False) then
    begin
    If (PGIAsk('Voulez-vous enregistrer les modifications ?','')= mrYes) Then
      OnUpdate;
    end;

  TOBBPD.Free;
  TOBLIENSOLE.free;
end ;

procedure TOF_BTPARIMPDOC.ChargeLiensOle (NATUREPIECE,SOUCHE: String);
var CleDoc       : R_CleDoc ;
    Q : Tquery;
begin
CleDoc.NaturePiece:=NaturePiece ;
CleDoc.Souche:=Souche ;
CleDoc.NumeroPiece:=0 ;
CleDoc.Indice:=0 ;
Q:=OpenSQL('SELECT * FROM LIENSOLE WHERE '+WherePiece(CleDoc,ttdLienOle,False),True) ;
if not Q.eof then TOBLIENSOLE.LoadDetailDB('LIENSOLE','','',Q,False) ;
Ferme(Q) ;
end;

procedure TOF_BTPARIMPDOC.EnregistreLiensOle (Edit1,Edit2 : THRicheditOle);
var T : TOB;
    Piece : string;
begin
piece:=NaturePiece+':'+Souche+':0:0' ;

if (TOBLIENSOLE.detail.count > 0) then
   begin
   TOBLiensOLE.DeleteDB;
   TOBLiensOLe.ClearDetail;
   end;

if (length (Edit1.Text) <> 0) and (Edit1.text <> #$D#$A) and (Edit1.text <> '') then
   begin
   T := TOB.create ('LIENSOLE',TOBLiensOLE,-1);
   T.PutValue('LO_TABLEBLOB', 'GP');
   T.PutValue('LO_QUALIFIANTBLOB', 'MEM');
   T.PutValue('LO_IDENTIFIANT', Piece);
   T.PutValue('LO_RANGBLOB', 1);
   T.PutValue('LO_OBJET',RichtoString(Edit1));
   end;
if (length (Edit2.Text) <> 0) and (Edit2.text <> #$D#$A) and (Edit2.text <> '') then
   begin
   T := TOB.create ('LIENSOLE',TOBLIENSOLE,-1);
   T.PutValue('LO_TABLEBLOB', 'GP');
   T.PutValue('LO_QUALIFIANTBLOB', 'MEM');
   T.PutValue('LO_IDENTIFIANT', Piece);
   T.PutValue('LO_RANGBLOB', 2);
   T.PutValue('LO_OBJET',RichtoString(Edit2));
   end;

if (TOBLIENSOLE.detail.count > 0) then
   begin
   TOBLIensOle.SetAllModifie (true);
   TOBLiensOLE.InsertDBTable (nil);
   end;

end;

procedure TOF_BTPARIMPDOC.AlimenteBlocNotes (Edit1,Edit2:THRichEditOle);
var T : TOB;
begin
if TOBLIENSOLE.Detail.count > 0 then
   begin
   T := TOBLIENSOLE.FindFirst (['LO_RANGBLOB'],['1'],false);
   if (T<>nil) then
      begin
      StringTorich(Edit1,T.GetValue('LO_OBJET'));
      end;
   T := TOBLIENSOLE.FindFirst (['LO_RANGBLOB'],['2'],false);
   if (T<>nil) then
      begin
      StringTorich(Edit2,T.GetValue('LO_OBJET'));
      end;
   end;
end;

Initialization
  registerclasses ( [ TOF_BTPARIMPDOC ] ) ;
end.
