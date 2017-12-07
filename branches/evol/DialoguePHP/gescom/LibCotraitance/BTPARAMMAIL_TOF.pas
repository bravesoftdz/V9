{***********UNITE*************************************************
Auteur  ...... : Franck VAUTRAIN
Créé le ...... : 19/07/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTINTEGREDOC ()
Mots clefs ... : TOF;BTPARAMMAIL
*****************************************************************}
Unit BTPARAMMAIL_TOF ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
     Windows,
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul,
{$ENDIF}
     uTob,
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     HTB97,
     UTOF,
     EtudePiece,
     Dialogs,
     Paramsoc,
     Splash,
     Variants,
     UtilsRapport,
     HRichOLE,
     uEntCommun,
     Udefexport,
     LookUp
     ;

Type

  TOF_BTPARAMMAIL= Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;

  private
    BValider  : TToolbarButton97;
    BDelete   : TToolbarButton97;
    LibObjet  : THEdit;
    ZoneMail  : THEdit;
    TMemoMail : TMemo;
    Rapport   : TGestionRapport;
    TypeMail  : String;
    //
    procedure BDeleteClick(Sender: TObject);
    procedure BValiderClick(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AffichageTabletteParametreMail(sender: Tobject);
    procedure DecodeArg(S: String);
    //
  end ;

Implementation


procedure TOF_BTPARAMMAIL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.OnArgument (S : String ) ;
begin
  Inherited ;

  DecodeArg(S);

  if Assigned(GetControl('MEMOMAIL')) then
  begin
    TMemoMail := TMemo(Ecran.FindComponent('MEMOMAIL'));
    TMemoMail.OnKeyDown := MemoKeyDown;
  end;

  if Assigned(GetControl('OBJET')) then
  begin
    LibObjet := THEdit(Ecran.FindComponent('OBJET'));
  end;

  if Assigned(GetControl('ZONEMAIL')) then
  begin
    ZoneMail := THEdit(Ecran.FindComponent('ZONEMAIL'));
    ZoneMail.OnElipsisClick := AffichageTabletteParametreMail;
  end;

  if Assigned(GetControl('BVALIDER')) then
  begin
    BValider := TToolbarButton97(ecran.FindComponent('BVALIDER'));
    BValider.OnClick := BValiderClick;
  end;

  if Assigned(GetControl('BDELETE')) then
  begin
    Bdelete := TToolbarButton97(ecran.FindComponent('BDELETE'));
    bdelete.OnClick := BDeleteClick;
  end;

  //
  TMemoMail.Clear;
  //
  Rapport := TGestionRapport.Create(Ecran);
  Rapport.Titre   := 'Paramétrage du corps des mails';
  Rapport.Close   := True;
  Rapport.Sauve   := False;
  Rapport.Print   := False;
  Rapport.TableID := 'MAI';
  Rapport.Qualif  := 'COT';

  if TypeMail = 'S' then
    Rapport.IDLienOLE := '{C1017EFA-0310-4191-AD5B-E426474F2213}'
  else
    Rapport.IDLienOLE := '{244CD969-802F-42C0-BA3B-44E4ED339CB5}';

  //
  Rapport.ChargeRapportLo;
  //
  LibObjet.Text := Rapport.Libelle;
  TMemoMail.text := Rapport.Memo.text;

end;

Procedure TOF_BTPARAMMAIL.DecodeArg(S : String);
Var LesArgs   : String;
    UnArg     : String;
    IposEgal  : Integer;
    UnCode    : String;
    UneValeur : String;
begin

	lesArgs := S;

  Repeat
  	UnArg := READTOKENST(LesArgs);
    if UnArg <> '' then
    begin
      IposEgal := Pos('=',UnArg);
      if IposEgal > 0 then
      begin
        Uncode := copy(unArg,1,IPosEgal-1);
        UneValeur := copy(unArg,IPosEgal+1,255);
        if UnCode='TYPEMAIL' then TypeMail := UneValeur;
      end;
    end;
  Until UnArg='';

end;


procedure TOF_BTPARAMMAIL.OnClose ;
begin
  Inherited ;

  //Fin de traitement
  if Assigned(Rapport) then FreeAndNil(Rapport);

end ;

procedure TOF_BTPARAMMAIL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTPARAMMAIL.BValiderClick(Sender : TObject);
begin
  Inherited ;

  if Assigned(Rapport) then
  begin
    Rapport.Memo := TMemoMail;
    Rapport.Libelle := LibObjet.text;
    if Rapport.IdLienOle='' then Rapport.IDLienOLE := '{C1017EFA-0310-4191-AD5B-E426474F2213}';
    Rapport.SauveRapportLo;
  end;

  Ecran.Close;

end ;

procedure TOF_BTPARAMMAIL.BDeleteClick(Sender : TObject);
begin
  Inherited ;

  if PGIAsk('Confirmez la suppression du paramétrage ?', Rapport.Titre) = MrYes then
  begin
    Rapport.DeleteRapportLo;
    TMemoMail.Clear;
  end;

end ;

procedure TOF_BTPARAMMAIL.MemoKeyDown(Sender: TObject; var Key : Word; Shift : TShiftState );
begin
  inherited ;

  if (Key=VK_INSERT) then AffichageTabletteParametreMail(self);

end;

Procedure TOF_BTPARAMMAIL.AffichageTabletteParametreMail(sender : Tobject);
var Ok_LookUp     : Boolean;
    FirstCharSel  : Integer;
begin

  Ok_LookUp := LookupList(ZoneMail,'Insertion Zones','COMMUN','CO_ABREGE','CO_LIBELLE','CO_TYPE="MAI"','CO_CODE',False,-1);

  if not Ok_LookUp then Exit;

  TMemoMail.SetFocus;

  ZoneMail.Text := '[' + ZoneMail.Text + ']';
  FirstCharSel := TMemoMail.SelStart;
  TMemoMail.SelText := ZoneMail.Text;
  TMemoMail.SelStart := FirstCharSel + Length(ZoneMail.Text) + 1;

end;

Initialization
  registerclasses ( [ TOF_BTPARAMMAIL ] ) ;
end.

