{***********UNITE*************************************************
Auteur  ...... : 
Créé le ...... : 01/09/2011
Modifié le ... :   /  /
Description .. : Source TOF de la FICHE : BTPRECUPWEB ()
Mots clefs ... : TOF;BTPRECUPWEB
*****************************************************************}
Unit BTPRECUPWEB_TOF ;

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
     HTB97,
     HCtrls, 
     HEnt1, 
     HMsgBox,
     UTOF,
     HGauge,
     Hpanel,
     DelPhpUnit ;

Type
  TOF_BTRECUPWEB = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    HTTPDial : THttpPost;
    BCHERCHEWEB : TToolbarButton97;
    ADRESSEHTTP : THedit;
    MResult : TMemo;
    Panimation : THPanel;
    Gauge: TEnhancedGauge;
    procedure BchercheClick (Sender : TObject);
  end ;

Implementation

procedure TOF_BTRECUPWEB.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnDelete ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnUpdate ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnLoad ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnArgument (S : String ) ;
begin
  Inherited ;
  HTTPDial := THttpPost.Create(ecran);
  Gauge :=  TEnhancedGauge.Create(application);
  Gauge.Parent := THPanel(GetControl('PANIMATION'));
  Gauge.Align := alClient;
  Gauge.Visible := false;
  TToolbarButton97(GetControl('BCHERCHEWEB')).OnClick := BchercheClick;
  MResult := TMemo(GetControl('Mresult'));
  HTTPDial.Gauge := Gauge;
  HTTPDial.MaxTimeOut := 10000;
  HTTPDial.ProxyPort := '80';
  HTTPDial.MethodeAcces  := TmeGet;
  HTTPDial.Agent := 'Mozilla/4.0 (compatible; ICS-LSE)'; // initialisation du client pour le dialogue
end ;

procedure TOF_BTRECUPWEB.OnClose ;
begin
  FreeAndNil(HTTPDial);
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.OnCancel () ;
begin
  Inherited ;
end ;

procedure TOF_BTRECUPWEB.BchercheClick(Sender: TObject);
var Memo : Tmemo;
begin
	If (HTTPDial.IsCompleted = False) Then HTTPDial.StopPost;

  if THEdit(GetControl('ADRESSEHTTP')).Text = '' then Exit;
  Tmemo(GetControl('MRESULT')).Clear;
  HTTPDial.MaxTimeOut := 10000;
  HTTPDial.URL := THEdit(GetControl('ADRESSEHTTP')).Text;
  HTTPDial.MethodeAcces := tMePost;
  HTTPDial.ResetPost;
  HTTPDial.HttpPost (false);
  if HTTPDial.StringError = '' then
  begin
      Tmemo(GetControl('MRESULT')).Clear;
      Tmemo(GetControl('MRESULT')).Lines.Add(HTTPDial.StringResult);
      memo := Tmemo(GetControl('MRESULT'));
  end else
  begin
    	PgiError (HTTPDial.StringError);
  end;

end;

Initialization
  registerclasses ( [ TOF_BTRECUPWEB ] ) ;
end.
