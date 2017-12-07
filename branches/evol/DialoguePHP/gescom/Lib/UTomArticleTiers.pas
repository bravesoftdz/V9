{***********UNITE*************************************************
Auteur  ...... : Olivier Tarcy
Cr�� le ...... : 04/02/2000
Modifi� le ... : 04/05/2000
Description .. : TOM pour ARTICLETIERS et tables asssoci�es :
Suite ........ :    - ARTICLE
Suite ........ :    - TIERS
Suite ........ : 1) R�f�rencer des articles chez un client
Suite ........ : 2) R�f�rencer pour un article un client
Suite ........ : Contr�le des 4 champs obligatoires dans le OnLoad :
Suite ........ :    - existence
Suite ........ :    - validit�
Mots clefs ... : ARTICLETIERS;REFARTICLE;REFTIERS;REFERENCEMENT
*****************************************************************}
unit UTomArticleTiers;

interface
uses AGLInit,HCtrls,Classes,Forms,HEnt1,UTOM,UTOB,
{$IFDEF EAGLCLIENT}
      MaineAGL,
{$ELSE}
      DBGrids,DBCtrls,FichGrid,DB,Fe_Main,HDB,
{$ENDIF}
     M3FP,UtilArticle,
     AGLInitGC,Controls,SysUtils,HMsgBox,Grids;

Type
  TOM_ArticleTiers = Class (TOM)
  private
    CodeTiers,RaisonSociale,CodeArticle : String ;
    SelectionArticles : TOB ;
    nbRef : integer ; i_ref : integer ;
    FinSaisie : boolean ; ErreurTrouvee:integer ; EstPasseParValider : Boolean ;
  public
    procedure OnNewRecord ; override ;
    procedure OnLoadRecord ; override ;
    procedure OnUpdateRecord ; override ;
    procedure OnArgument (stArgument : String ) ; override ;
    procedure OnChangeField (F : TField) ; override ;
    procedure OnEllipsis (Sender: TObject ) ;
    procedure Saisie (value : integer);
    procedure SaisieRef ;
    procedure Valider (i : integer);
    procedure RefSuivante ;
    procedure DonnerFocus (FieldName : String) ;
    function  RecordIsValid: Integer; 
END ;


const	//**** libell�s des messages d'erreur ****//
	TexteMessage: array[1..8] of string = (
          {1}        'La r�f�rence du client existe d�j� chez ce tiers.'
          {2}        ,'L''article est d�j� r�f�renc� pour ce client.'
          {3}        ,'Le code article n''existe pas.'
          {4}        ,'Le code article doit �tre renseign�.'
          {5}        ,'Le code client n''existe pas.'
          {6}        ,'Le code client doit �tre renseign�.'
          {7}        ,'La r�f�rence chez le client doit �tre renseign�e.'
          {8}        ,'La d�signation doit �tre renseign�e.'
                                                  );
     //**** position des colonnes dans DBGRID ****//
     colonneCodeArticle = 0 ;
     colonneCodeClient  = 0 ;

implementation

procedure TOM_ArticleTiers.OnArgument(stArgument:String);
{$IFDEF EAGLCLIENT}
var Fliste : THGrid ;
{$ELSE}
var Fliste : THDBGrid ;
{$ENDIF}
    x : integer ;
    Critere, ChampCritere, ValeurCritere : string ;
begin
  inherited;
{$IFDEF EAGLCLIENT}
  Fliste:=THGrid(GetControl('Fliste')) ;
{$ELSE}
  Fliste:=THDBGrid(GetControl('Fliste')) ;
{$ENDIF}
  if (Fliste=NIL) then exit ;
  Fliste.OnEditButtonClick := OnEllipsis ;
  EstPasseParValider := False ;i_ref:=0; nbRef:=0; //**** initialisations ****//

//**** r�cup�ration des arguments ****//
Repeat
    Critere:=Trim(ReadTokenSt(StArgument)) ;
    if Critere<>'' then
        begin
        x:=pos('=',Critere);
        if x<>0 then
           begin
           ChampCritere:=copy(Critere,1,x-1);
           ValeurCritere:=copy(Critere,x+1,length(Critere));
           if ChampCritere='CODE_TIERS' then CodeTiers := ValeurCritere ;
           if ChampCritere='RAISON_SOCIALE' then RaisonSociale := ValeurCritere ;
           if ChampCritere='CODE_ARTICLE' then CodeArticle := ValeurCritere ;
           end;
        end;
until  Critere='';

  if (CodeTiers<>'') then SetControlText('CODETIERS',CodeTiers);
  if (CodeArticle='') then Ecran.caption:=Ecran.Caption+' '+CodeTiers+' '+RaisonSociale
  else Ecran.caption:=Ecran.Caption+' '+CodeArticle+' '+RechDom('GCARTICLEGENERIQUE',CodeArticle,False);
end;

procedure TOM_ArticleTiers.OnNewRecord ;
{$IFDEF EAGLCLIENT}
var FListe : THGrid ;
{$ELSE}
var FListe : THDBGrid ;
{$ENDIF}
    champTOB : string ;
begin
  inherited;
{$IFDEF EAGLCLIENT}
  Fliste:=THGrid(GetControl('Fliste')) ;
{$ELSE}
  Fliste:=THDBGrid(GetControl('Fliste')) ;
{$ENDIF}
  if (Fliste=NIL) then exit ;
  EstPasseParValider := False ;
  if (nbref <> 0) and (i_ref < nbRef) then    // cas d'une selection d'article
    begin
    inc(i_ref) ;
    champTOB := 'ArticleNo'+ IntToStr(i_ref);
    FListe.SelectedField:=FListe.DataSource.DataSet.FindField('GAT_ARTICLE');
    FListe.SelectedField.Value:=SelectionArticles.GetValue(champTOB);
    DonnerFocus('GAT_REFARTICLE');
    end ;

   Fliste.Columns[colonneCodeClient].ButtonStyle:=cbsEllipsis  ;
   if (CodeArticle<>'') then
    begin  // � partir d'une fiche article
      SetField('GAT_ARTICLE',CodeArticle);
      DonnerFocus('GAT_REFTIERS');
    end else
     begin  // � partir d'une fiche tiers
     SetField('GAT_REFTIERS',CodeTiers);
     if nbref = 0 then DonnerFocus('GAT_ARTICLE');
     end;

end;

procedure TOM_ArticleTiers.OnLoadRecord ;
begin
inherited ;
if (DS.state<>dsInsert) and (nbref <> 0) and (i_ref < nbRef) then    // cas d'une selection d'article
        TFFicheGrid(Ecran).bouge( nbInsert) ;
end ;


procedure TOM_ArticleTiers.OnEllipsis (Sender: TObject ) ;
{$IFDEF EAGLCLIENT}
var FListe : THGrid ;
{$ELSE}
var FListe : THDBGrid ;
{$ENDIF}
begin
  if Sender is THDBGrid then
    begin
      Fliste:=THDBGrid(Sender) ;
      if (Fliste=NIL) then exit ;
      if (DS.State<>dsInsert) then DS.Insert ;
      if FListe.SelectedField.Fieldname='GAT_ARTICLE' then
        begin
          if ctxMode in V_PGI.PGIContexte
             then FListe.SelectedField.Value:=DispatchArtMode(1,'RETOUR_CODEARTICLE=X;GA_CODEARTICLE='+FListe.SelectedField.AsString,'','')
             else FListe.SelectedField.Value:=AGLLanceFiche('GC','GCARTICLE_RECH','RETOUR_CODEARTICLE=X;GA_CODEARTICLE='+FListe.SelectedField.AsString,'','');
          DonnerFocus('GAT_REFARTICLE');
        end;
      if FListe.SelectedField.Fieldname='GAT_REFTIERS' then
        begin
        CodeTiers:=DispatchRecherche (Nil, 2 ,'T_NATUREAUXI="CLI"','','') ;
          if (CodeTiers<>'') then
            begin
              RaisonSociale:=RechDom('TZTCLIENT',CodeTiers,False);
              SetField('GAT_REFTIERS',CodeTiers);
              DonnerFocus('GAT_REFARTICLE');
            end;
        end;
    end;
end;

procedure TOM_ArticleTiers.OnChangeField (F:TField) ;
begin
  inherited;
  if ((F.FieldName='GAT_ARTICLE') and (GetField('GAT_LIBELLE')='') and (GetField('GAT_ARTICLE')<>'') ) then
    SetField('GAT_LIBELLE', LibelleArticleGenerique(GetField('GAT_ARTICLE')));
end;

procedure TOM_ArticleTiers.Saisie( value : integer) ;
{$IFDEF EAGLCLIENT}
var FListe:THGrid ;
{$ELSE}
var FListe:THDBGrid ;
{$ENDIF}
  begin
    Fliste:=THDBGrid(GetControl('Fliste')) ;
    if (Fliste=NIL) then exit ;
    nbRef:=value ;
    SelectionArticles:=TheTOB; TheTOB:=Nil;
    //**** si plusieurs r�f�rences on est en mode multis�lection donc activation du bouton R�f. suivante *******
    if (nbRef > 0) then SetControlEnabled('BNEXTREF',TRUE);
    i_ref:=0 ;
    SaisieRef; //**** on continue la saisie *****
  end;

procedure TOM_ArticleTiers.SaisieRef ;
begin
  TFFicheGrid(Ecran).bouge(nbInsert) ;
end;

procedure TOM_ArticleTiers.Valider(i : integer) ;
{$IFDEF EAGLCLIENT}
var FListe:THGrid ;
{$ELSE}
var FListe:THDBGrid ;
{$ENDIF}
begin
  Fliste:=THDBGrid(GetControl('Fliste')) ;
  if (Fliste=NIL) then exit ;
  if i = 1 then TFFicheGrid(Ecran).BValiderClick(Ecran);
  EstPasseParValider := True ;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Olivier Tarcy
Cr�� le ...... : 03/05/2000
Modifi� le ... :   /  /
Description .. : Sauter un article dans un r�f�rencement multiple
Mots clefs ... :
*****************************************************************}
procedure TOM_ArticleTiers.RefSuivante ;
{$IFDEF EAGLCLIENT}
var FListe:THGrid ;
{$ELSE}
var FListe:THDBGrid ;
    champ : string ;
{$ENDIF}
begin
  Fliste:=THDBGrid(GetControl('Fliste')) ;
  if (Fliste=NIL) then exit ;
  Fliste.Datasource.Dataset.ClearFields ;
  SetField('GAT_REFTIERS',CodeTiers);
  if (i_ref = nbRef) then
    begin
      DS.Delete ;
      SetControlEnabled ('BNEXTREF',False);
      SetControlEnabled ('BARTICLESEL',True);
      if nbref > 1 then PGIInfo('R�f�rencement termin�','INFORMATION') ;
      nbRef:= 0 ; i_ref:=0 ;
      DonnerFocus('GAT_ARTICLE') ; DS.First ;
    end
  else if (i_ref<nbRef) then
  begin
    inc(i_ref) ;
    champ:='ArticleNo'+IntToStr(i_ref);
    FListe.SelectedField:=FListe.DataSource.DataSet.FindField('GAT_ARTICLE');
    FListe.SelectedField.Value:=SelectionArticles.GetValue(champ);
    DonnerFocus('GAT_REFARTICLE');
  end
end;

function TOM_ArticleTiers.RecordIsValid: Integer; 
begin
  Result := 0;

  if (Result = 0) and (GetField('GAT_ARTICLE')    = '') then Result := 4;
  if (Result = 0) and (GetField('GAT_REFTIERS')   = '') then Result := 6;
  if (Result = 0) and (GetField('GAT_REFARTICLE') = '') then Result := 7;
  if (Result = 0) and (GetField('GAT_LIBELLE')    = '') then Result := 8;

  if (Result = 0) and  ExisteSQL('SELECT * FROM ARTICLETIERS WHERE GAT_REFTIERS="' + GetField('GAT_REFTIERS') + '" AND GAT_REFARTICLE="' + GetField('GAT_REFARTICLE') + '"'    ) then Result := 1;
  if (Result = 0) and (ExisteSQL('SELECT * FROM ARTICLETIERS WHERE GAT_ARTICLE="' + GetField('GAT_ARTICLE') +'" AND GAT_REFTIERS="' + GetField('GAT_REFTIERS') +'"')           ) then Result := 2;
  if (Result = 0) and ((GetField('GAT_ARTICLE')<>'') and ( not ExisteSQL('SELECT GA_CODEARTICLE FROM ARTICLE WHERE GA_CODEARTICLE="'+GetField('GAT_ARTICLE')+'"'))             ) then Result := 3;
  if (Result = 0) and ((GetField('GAT_REFTIERS')<>'') and (not ExisteSQL('Select T_AUXILIAIRE FROM TIERS WHERE T_TIERS="'+GetField('GAT_REFTIERS')+'" AND T_NATUREAUXI="CLI"'))) then Result := 5;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Olivier Tarcy
Cr�� le ...... : 28/03/2000
Modifi� le ... : 28/03/2000
Description .. : Contr�le de la saisie des donn�es
Mots clefs ... : GAT_ARTICLE;GAT_REFARTICLE;GAT_GAT_LIBELLE
*****************************************************************}
procedure TOM_ArticleTiers.OnUpdateRecord ;
Var S1,S2,S3,S4,MessageCaption:String;
begin
  inherited;
  if EstPasseParValider = False then Valider(0);
  ErreurTrouvee:=0;

  LastError := RecordIsValid;
  if Assigned(Ecran) then 
  begin
    if LastError <> 0 then
    begin
      PGIBox(TexteMessage[LastError], Ecran.Caption);
      case LastError of
        1,7: DonnerFocus('GAT_REFARTICLE');
        2:
          begin
            if (CodeArticle<>'') then DonnerFocus('GAT_REFTIERS') else DonnerFocus('GAT_ARTICLE');
          end;
        3,4: DonnerFocus('GAT_ARTICLE');
        5,6: DonnerFocus('GAT_REFTIERS');
        8  : DonnerFocus('GAT_LIBELLE');
      end;
    end
    else
    begin
      if (nbRef > 0) and (i_ref = nbref) then FinSaisie := True ;
      if FinSaisie = True then {TFFicheGrid(Ecran).Bouge(nbInsert)}
      begin
        if (nbRef > 1) then PGIInfo('R�f�rencement termin�','INFORMATION') ;
          DonnerFocus('GAT_ARTICLE') ; DS.First ;
        nbRef:= 0 ; i_ref:=0 ; FinSaisie := False;
        SetControlEnabled('BNEXTREF',False) ; SetControlEnabled('BARTICLESEL',True) ;
      end ;
    end;
  end
  else
  begin
    { Validation d'une TOBGAT sans �cran associ� }
    if not fTob.FieldExists('Error') then
      fTob.AddChampSupValeur('Error', '');
    if LastError <> 0 then
      fTob.PutValue('Error', TexteMessage[LastError]);
  end;
end;

//******** placer le focus sur le champ voulu **********************************
procedure TOM_ArticleTiers.DonnerFocus (FieldName : String) ;
{$IFDEF EAGLCLIENT}
var FListe : THGrid ;
{$ELSE}
var FListe : THDBGrid ;
{$ENDIF}
begin
  Fliste:=THDBGrid(GetControl('Fliste')) ;
  if (Fliste=NIL) then exit ;
  FListe.SelectedField:=FListe.DataSource.DataSet.FindField(FieldName);
  FListe.SelectedField.FocusControl;
end;

procedure AGLSaisie( parms: array of variant; nb: integer ) ;
var  F : TForm ; OM : TOM ;
begin
  F:=TForm(Longint(Parms[0])) ;
  if (F is TFFicheGrid) then OM:=TFFicheGrid(F).OM else exit;
  if (OM is TOM_ArticleTiers) then TOM_ArticleTiers(OM).Saisie(integer(Parms[1])) else exit;
end;

procedure AGLValider( parms: array of variant; nb: integer ) ;
var  F : TForm ; OM : TOM ;
begin
  F:=TForm(Longint(Parms[0])) ;
  if (F is TFFicheGrid) then OM:=TFFicheGrid(F).OM else exit;
  if (OM is TOM_ArticleTiers) then TOM_ArticleTiers(OM).Valider(integer(Parms[1])) else exit;
end;

procedure AGLRefSuivante( parms: array of variant; nb: integer ) ;
var  F : TForm ; OM : TOM ;
begin
  F:=TForm(Longint(Parms[0])) ;
  if (F is TFFicheGrid) then OM:=TFFicheGrid(F).OM else exit;
  if (OM is TOM_ArticleTiers) then TOM_ArticleTiers(OM).RefSuivante else exit;
end;

Initialization
registerclasses([TOM_ARTICLETIERS]) ;
RegisterAglProc( 'Saisie', TRUE , 1, AGLSaisie );
RegisterAglProc( 'Valider', TRUE , 1, AGLValider );
RegisterAglProc( 'RefSuivante', TRUE , 0, AGLRefSuivante );
end.