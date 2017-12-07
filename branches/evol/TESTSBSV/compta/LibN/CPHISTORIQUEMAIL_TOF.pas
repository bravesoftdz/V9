{ Unit� : Source TOF du Mul : CPHISTORIQUEMAIL ()
--------------------------------------------------------------------------------------
    Version    |   Date   | Qui  |   Commentaires
--------------------------------------------------------------------------------------
 7.01.001.001   08/02/06    JP     Cr�ation de l'unit�
--------------------------------------------------------------------------------------}
unit CPHISTORIQUEMAIL_TOF;

interface

uses
  StdCtrls, Controls, Classes,
  {$IFDEF EAGLCLIENT}
  MaineAGL, eMul,
  {$ELSE}
  FE_Main, db,
  {$IFNDEF DBXPRESS}dbtables,{$ELSE}uDbxDataSet,{$ENDIF}
  Mul, HDB,
  {$ENDIF}
  {$IFDEF VER150}
  Variants,
  {$ENDIF}
  sysutils, UTob, ComCtrls, HCtrls, uTOF;

  type
  TOF_CPHISTORIQUEMAIL = class (TOF)
    procedure OnLoad                ; override;
    procedure OnArgument(S : string); override;
    procedure OnClose               ; override;
    procedure OnDisplay             ; override;
  private
    {$IFDEF EAGLCLIENT}
    FListe : THGrid;
    {$ELSE}
    FListe : THDBGrid;
    {$ENDIF EAGLCLIENT}

    procedure BEnvoieClick(Sender : TObject);
    procedure BDeleteClick(Sender : TObject);
    procedure BOuvrirClick(Sender : TObject);
    procedure ParamTaClick(Sender : TObject);
    procedure SlctAllClick(Sender : TObject);
  end;

procedure CpLanceFiche_HistoriqueMail;

implementation

uses
  HEnt1, HMsgBox, Ent1, HTB97, CPTACHEBAP_TOM, CPPARAMTACHEBAP_TOF, ULibBonAPayer
  {,uLanceProcess};

{---------------------------------------------------------------------------------------}
procedure CpLanceFiche_HistoriqueMail;
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche('CP', 'CPHISTORIQUEMAIL', '', '', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.OnArgument(S: string);
{---------------------------------------------------------------------------------------}
begin
  inherited;
  Ecran.HelpContext := 7509120;
  FListe := TFMul(Ecran).FListe;

  TToolbarButton97(GetControl('BENVOIE'    )).OnClick := BEnvoieClick;
  TToolbarButton97(GetControl('BDELETE'    )).OnClick := BDeleteClick;
  TToolbarButton97(GetControl('BOUVRIR'    )).OnClick := BOuvrirClick;
  TToolbarButton97(GetControl('BPARAMTACHE')).OnClick := ParamTaClick;
  TToolbarButton97(GetControl('BSELECTALL' )).OnClick := SlctAllClick;
  FListe.OnDblClick := BOuvrirClick;
  {$IFDEF EAGLCLIENT}
  {15/05/06 : le Bouton est cach� en 2/3 car le param�trage des t�ches ne doit �tre fait
              qu'en eAgl}
  SetControlVisible('BPARAMTACHE', V_PGI.Superviseur);
  {$ENDIF EAGLCLIENT}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.OnClose;
{---------------------------------------------------------------------------------------}
begin
  inherited;

end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.OnDisplay;
{---------------------------------------------------------------------------------------}
begin
  inherited;

end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.OnLoad;
{---------------------------------------------------------------------------------------}
begin
  inherited;

end;

{Suppression des mails s�lectionn�s si GetField('CTA_ENVOYE') <> 'X' :
 Remarque : pour supprimer un mail non envoy�, il faut supprimer l'enregistrement dans la
 Table CPBONSAPAYER
{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.BDeleteClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  p : Integer;
  {$IFDEF EAGLCLIENT}
  F : THGrid;
  {$ELSE}
  F : THDBGrid;
  {$ENDIF}

    {------------------------------------------------------------------------}
    procedure _DetruireMails;
    {------------------------------------------------------------------------}
    begin
      {On ne peut supprimer que les mails envoy�s}
      if TFMul(Ecran).Q.FindField('CTA_ENVOYE').AsString = 'X' then begin
        ExecuteSQL('DELETE FROM CPTACHEBAP WHERE CTA_NATUREMAIL = "' + TFMul(Ecran).Q.FindField('CTA_NATUREMAIL').AsString + '" AND ' +
                   'CTA_DESTINATAIRE = "' + TFMul(Ecran).Q.FindField('CTA_DESTINATAIRE').AsString + '" AND ' +
                   'CTA_DATEENVOI = "' + UsDateTime(TFMul(Ecran).Q.FindField('CTA_DATEENVOI').AsDateTime) + '"');
        Inc(p);
      end;
    end;

begin
  {$IFDEF EAGLCLIENT}
  F := THGrid(TFMul(Ecran).FListe);
  {$ELSE}
  F := THDBGrid(TFMul(Ecran).FListe);
  {$ENDIF}

  p := 0;

  {Aucune s�lection, on sort}
  if (F.NbSelected = 0) and not F.AllSelected then begin
    HShowMessage('0;' + Ecran.Caption + ';Aucun �l�ment n''est s�lectionn�.;W;O;O;O;', '', '');
    Exit;
  end
  else if HShowMessage('0;' + Ecran.Caption + ';�tes vous s�r de vouloir supprimer les mails s�lectionn�s ?;Q;YN;N;N;', '', '') <> mrYes then
    Exit;

  BeginTrans;
  try
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if F.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        _DetruireMails;
        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

    for n := 0 to F.nbSelected - 1 do begin
      F.GotoLeBookmark(n);
      {$IFDEF EAGLCLIENT}
      TFMul(Ecran).Q.TQ.Seek(F.Row - 1);
      {$ENDIF}
      _DetruireMails;
    end;
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      HShowMessage('0;' + Ecran.Caption + '; Traitement interrompu :'#13 + E.Message + ';E;O;O;O;', '', '');
    end;
  end;

  if p > 0 then
    HShowMessage('0;' + Ecran.Caption + ';' + IntToStr(p) + ' mail(s) a (ont) �t� supprim�(s).;I;O;O;O;', '', '');
  {Raffra�chissement de la liste}
  TToolbarButton97(GetControl('BCHERCHE')).Click;
end;

{Envoie des mails s�lectionn�s si GetField('CTA_ENVOYE') <> 'X'
{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.BEnvoieClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  p : Integer;
  {$IFDEF EAGLCLIENT}
  F : THGrid;
  {$ELSE}
  F : THDBGrid;
  {$ENDIF}

    {------------------------------------------------------------------------}
    procedure _EnvoieMails;
    {------------------------------------------------------------------------}
    var
      Obj : TObjEnvoiMail;
    begin
      Obj := TObjEnvoiMail.Create(VarToStr(GetField('CTA_NATUREMAIL')),
                                  VarToStr(GetField('CTA_DESTINATAIRE')),
                                  VarToDateTime(GetField('CTA_DATEENVOI')));
      try
        Obj.EnvoieMail;
        Inc(P);
      finally
        if Assigned(Obj) then FreeAndNil(Obj);
      end;
    end;

begin
  {$IFDEF EAGLCLIENT}
  F := THGrid(TFMul(Ecran).FListe);
  {$ELSE}
  F := THDBGrid(TFMul(Ecran).FListe);
  {$ENDIF}

  p := 0;

  {Aucune s�lection, on sort}
  if (F.NbSelected = 0) and not F.AllSelected then begin
    HShowMessage('0;' + Ecran.Caption + ';Aucun �l�ment n''est s�lectionn�.;W;O;O;O;', '', '');
    Exit;
  end
  else if HShowMessage('0;' + Ecran.Caption + ';�tes vous s�r de vouloir envoyer les mails s�lectionn�s ?;Q;YNC;N;C;', '', '') <> mrYes then
    Exit;

  BeginTrans;
  try
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if F.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        _EnvoieMails;
        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

    for n := 0 to F.nbSelected - 1 do begin
      F.GotoLeBookmark(n);
      {$IFDEF EAGLCLIENT}
      TFMul(Ecran).Q.TQ.Seek(F.Row - 1);
      {$ENDIF}
      _EnvoieMails;
    end;
    CommitTrans;
  except
    on E : Exception do begin
      RollBack;
      HShowMessage('0;' + Ecran.Caption + '; Traitement interrompu :'#13 + E.Message + ';E;O;O;O;', '', '');
    end;
  end;

   HShowMessage('0;' + Ecran.Caption + ';' + IntToStr(p) + ' mail(s) a (ont) �t� envoy�(s).;I;O;O;O;', '', '');
  {Raffra�chissement de la liste}
  TToolbarButton97(GetControl('BCHERCHE')).Click;

end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.BOuvrirClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  CpLanceFiche_TacheBAP('', VarToStr(GetField('CTA_NATUREMAIL')) + ';' +
                            VarToStr(GetField('CTA_DESTINATAIRE')) + ';' +
                            VarToStr(GetField('CTA_DATEENVOI')) + ';', 'ACTION=CONSULTATION;');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.SlctAllClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Fiche : TFMul;
begin
  Fiche := TFMul(Ecran);
  {$IFDEF EAGLCLIENT}
  if not Fiche.FListe.AllSelected then begin
    if not Fiche.FetchLesTous then Exit;
  end;
  {$ENDIF}
  Fiche.bSelectAllClick(nil);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_CPHISTORIQUEMAIL.ParamTaClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
//var
  //TobParam : TOB;
begin

  if HShowmessage('1;' + Ecran.Caption + ';�tes-vous s�r de vouloir modifier le param�trage du gestionnaire de t�ches ?;Q;YN;N;N;', '', '') = mrYes then
    if HShowmessage('1;' + Ecran.Caption + ';La modification du param�trage des t�ches a un impact sur toute la gestion'#13 +
                    'des bons � payer. Souhaitez-vous abandonner ?;Q;YN;Y;Y;', '', '') = mrNo then
    AglLanceFiche('YY', 'YYMULJOBS', '', '', 'XX_WHERE=');
    //AglFicheJob(-1, taCreat, 'CGIGESTIONBAP.EXE', 'TEST', nil, '1PS', 'SENDMAIL', 'BAP', 'Envoi de mails');
  (*
  TobParam := TOB.Create('mmm', nil, -1);
  try
    TOBParam.AddChampSupValeur('USERLOGIN' , V_PGI.UserLogin ) ;
    TOBParam.AddChampSupValeur('INIFILE' , HalSocIni ) ;
    TOBParam.AddChampSupValeur('PASSWORD' , V_PGI.Password ) ;
    TOBParam.AddChampSupValeur('DOMAINNAME' , '' ) ;
    TOBParam.AddChampSupValeur('DATEENTREE' , V_PGI.DateEntree ) ;
    TOBParam.AddChampSupValeur('DOSSIER' , V_PGI.CurrentAlias ) ;
    LanceProcessLocal('CGIGestionBAP', 'ETAPE', 'aucun', TobParam, True);
  finally
    FreeAndNil(TobParam);
  end;
  *)
end;

initialization
  RegisterClasses([TOF_CPHISTORIQUEMAIL]);

end.
