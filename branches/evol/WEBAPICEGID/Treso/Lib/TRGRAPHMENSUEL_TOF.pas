{ Unit� :Source TOF de la FICHE : TRGRAPHMENSUEL
--------------------------------------------------------------------------------------
    Version    |   Date   | Qui  |   Commentaires
--------------------------------------------------------------------------------------
 0.91            15/10/03   JP    Cr�ation de l'unit�
 6.00.014.001    17/09/04   JP    FQ 10128 : on cache les boutons inutiles
 8.00.001.018    05/06/07   JP    FQ 10469 : d�sactvation des filtres et des boutons

--------------------------------------------------------------------------------------}
unit TRGRAPHMENSUEL_TOF;

interface

uses
  Controls, Classes, Graphics, TeEngine, Chart, Windows,
  {$IFDEF EAGLCLIENT}
  MaineAGL,
  {$ELSE}
  FE_Main, 
  {$ENDIF}
  SysUtils, HCtrls, GRS1, Series, GraphUtil, UTOF, UTob,
  HTB97;


type
  TOF_TRGRAPHMENSUEL = Class (TOF)
    procedure OnUpdate                 ; override ;
    procedure OnClose                  ; override ;
    procedure OnArgument (S : String ) ; override ;
  private
    TobSeries : TOB;
    ListeCourbes : string;
    procedure DessineLigne  (Sender : TObject);
  end ;

procedure TRLanceFiche_GraphMensu(Arguments : string);

implementation

uses
  UObjFiltres;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_GraphMensu(Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AGLLanceFiche('TR', 'TRGRAPHMENSUEL', '', '', Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRGRAPHMENSUEL.OnUpdate ;
{---------------------------------------------------------------------------------------}
var
  F : TFGRS1;
  stTitre,
  stColonnes, stChampTitre,
  stCriteres, stWhere,
  stTitresCol1, stTitresCol2,
  stColGraph1, stColGraph2 : string;
  tstTitres                : Tstrings;
  ft                       : TFont;
begin
  inherited;

  stCriteres := '';
  stColGraph1 := '';
  stColGraph2 := '';
  stTitresCol1 := '';
  stTitresCol2 := '';
  stTitre := '';

  tstTitres := TStringList.Create;
  ft := TFont.Create;
  try
    {Definition des fonts des titres}
    ft.Style := [fsBold];
    ft.Color := clBlue;
    ft.Size  := 12;

    F := TFGRS1(Ecran);
    TstTitres.Add ('Courbes des recettes/d�penses mensuelles');

    stColonnes  := ListeCourbes;
    stTitre     := 'Mois;Recettes comptables;D�penses comptables;Recettes financi�res;D�penses financi�res;Solde;';
    stColGraph1 := ListeCourbes;
    stColGraph2 := '';
    stChampTitre := stTitre;
    LanceGraph(F, TobSeries, '', stColonnes, stWhere , stTitre , stColGraph1,
                 stColGraph2, tstTitres, nil, TLineSeries , stChampTitre, False);

    if F.Fchart1.SeriesCount > 0 then begin
      {�v�nements qui permet d'�crire au sommet des barres le pourcentage}

      {Pour dessiner des lignes horizontales sur le graphe}
      F.FChart1.SeriesList.Series[1].BeforeDrawValues := DessineLigne;

      {Les comptes ne servent sue de marques, on ne les affiche pas dans le graphe}
      F.FChart1.SeriesList.Series[0].Marks.Visible := False;
      F.FChart1.SeriesList.Series[0].DataSource := nil;

      {Titre des axes}
      F.FChart1.LeftAxis.Title.Caption := 'Montants';
      F.FChart1.BottomAxis.Title.Caption := 'Mois';

      {Titre des l�gendes}
      F.FChart1.SeriesList.Series[1].Title := 'Recettes comptables';
      F.FChart1.SeriesList.Series[2].Title := 'D�penses comptables';
      F.FChart1.SeriesList.Series[3].Title := 'Recettes financi�res';
      F.FChart1.SeriesList.Series[4].Title := 'D�penses financi�res';
      F.FChart1.SeriesList.Series[5].Title := 'Solde';

      {Pour une question de place, on met la l�gende en bas de page}
      F.FChart1.Legend.Alignment := laBottom;

      {Pour ne pas afficher les comptes dans la l�gende : la s�rie 0 concerne les comptes, on s'en moque dans la l�gende}
      F.FChart1.Legend.FirstValue := 1;
      F.FChart1.LeftAxis.LabelsFont.Color := clRed;

      {Font des titres des axes du graph}
      F.FChart1.LeftAxis  .Title.Font.Assign(ft);
      F.FChart1.BottomAxis.Title.Font.Assign(ft);
      F.FChart1.LeftAxis  .Title.Font.Color := clRed;

      ft.Size := 9;
      ft.Style := [];
      {Font des �chelles des axes}
      F.FChart1.LeftAxis  .LabelsFont.Assign(ft);
      F.FChart1.BottomAxis.LabelsFont.Assign(ft);
      F.FChart1.LeftAxis  .LabelsFont.Color := clRed;
    end;
  finally
    FreeAndNil(ft);
    tstTitres.Free;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRGRAPHMENSUEL.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  Ecran.HelpContext := 150;
  SetControlVisible('BUNDO'  , False); {FQ 10128}
  SetControlVisible('BSAUVE' , False); {FQ 10128}
  SetControlVisible('BDELETE', False); {FQ 10128}

  SetControlCaption('TITRE', ReadTokenSt(S));
  SetControlCaption('DEVISE', ReadTokenSt(S));
  SetControlCaption('SOLDE', ReadTokenSt(S));
  {R�cup�ration des colonnes du graphe}
  ListeCourbes := S;
  TobSeries := TFGRS1(Ecran).LaTOF.LaTOB;

  {05/06/07 : FQ 10469 : on cache les filtres}
  CacheFiltreGraph(Ecran);

  {Lancement du traitement, pour qu'en arriv�e sur la fiche, le graphe soit affich�}
  TToolbarButton97(GetControl('BVALIDER')).Click;
  TToolbarButton97(GetControl('BAFFGRAPH')).Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRGRAPHMENSUEL.OnClose;
{---------------------------------------------------------------------------------------}
begin
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRGRAPHMENSUEL.DessineLigne(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  YPosition  : Longint;
  Ecart, Inc : Double;
  Mini, Maxi : Double;
  n, p, k    : Integer;
    {---------------------------------------------------------------------}
    procedure Dessine(Zero : Boolean);
    {---------------------------------------------------------------------}
    begin
      with TFGRS1(Ecran).FChart1, Canvas do begin
        {D�finition du crayon}
        if Zero then Pen.Width := 2
                else Pen.Width := 1;
        Pen.Style := psSolid;
        Pen.Color := clBlue;
        {Dessin de la ligne}
        MoveTo(ChartRect.Left, YPosition);
        LineTo(ChartRect.Left  + Width3D, YPosition - Height3D);
        LineTo(ChartRect.Right + Width3D, YPosition - Height3D);
        {Dessin d'un bout de ligne sur la gauche de l'axe pour faire le lien avec la marque}
        MoveTo(ChartRect.Left, YPosition);
        LineTo(ChartRect.Left - 5, YPosition);
      end
    end;

begin
  p := 0;
  with TFGRS1(Ecran).FChart1 do begin
    {On ne d�ssine une ligne pour la valeur nulle que s'il y a des montants de sens diff�rents}
    {R�cup�ration de la position de 0 sur l'axe vertical}
    YPosition := Series[1].CalcYPosValue(0);
    Dessine(True);

    {Dessin des 7 principales marques}
    {On commence par calculer les extr�mes de la graduation et l'incr�ment, car � ce moment cela
     n'a pas �t� encore fait : Increment = 0 et Min et Max sont les valeurs Min et Max de la s�rie}
    LeftAxis.CalcMinMax(Mini, Maxi);
    Inc   := LeftAxis.CalcIncrement;
    Ecart := Maxi - Mini;
    {On va mettre 7 lignes plus celui de z�ro}
    Ecart := Ecart / 7;
    if Inc <> 0 then Ecart := Ecart / Inc
                else Exit;
    Ecart := Round(Ecart);
    for n := 1 to 7 do begin
      {Tant que le maximun n'est pas atteint, on dessine les lignes du c�t� positif}
      if n * Ecart * Inc < Maxi then begin
        YPosition := Series[1].CalcYPosValue(n * Ecart * Inc);
        Dessine(False);
        p := n;
      end
      {... sinon on passe du c�t� n�gatif}
      else begin
        for k := 1 to 7 - p do
          if k * Ecart * Inc * -1 > Mini then begin
            YPosition := Series[1].CalcYPosValue(k * Ecart * Inc * -1);
            Dessine(False);
          end;
        Exit;
      end;
    end;
  end;
end;

initialization
  RegisterClasses([TOF_TRGRAPHMENSUEL]);

end.
