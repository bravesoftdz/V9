{***********UNITE*************************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /
Description .. : Multicrit�res saisie group�e des acomptes
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************
PT1 06/08/2004 V_50 JL FQ 11480 Modif contr�le date sortie pour salari� avec 30/12/1899
PT2 16/06/2006 V_65 SB FQ 12937 Refonte raffraichissement de la grille
PT3 25/07/2008 JPP V_80 FQ 15626 Interdire la saisie group�e d'acomptes si aucun salari� n'est selectionn�
}
unit UTofPG_MulAcompteGrp;

interface
uses Classes,  Sysutils, Controls, AglInit,
     {$IFNDEF EAGLCLIENT}
     mul, FE_Main,
     {$ELSE}                                  
     emul, MaineAgl,Utob,
     {$ENDIF}
     Utof,  hctrls,  HTB97,  HMsgBox, HQry, Hent1 ;


type
  TOF_PGMULACOMPTEGRP = class(TOF)
    procedure OnLoad; override;
    procedure OnArgument(Arguments: string); override;
  private
    LanceAcompte: Boolean;
    procedure PGLanceFiche(Sender: TObject);
    procedure ActiveWhere(Sender: TObject);
    procedure ExitEdit(Sender: TObject);
  end;

implementation
uses Entpaie, PGoutils2; 


{ TOF_PGMULACOMPTEGRP }


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /    
Description .. : Affectation du XX_WHERE
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}
procedure TOF_PGMULACOMPTEGRP.ActiveWhere(Sender: TObject);
var
  DateSaisie: TDateTime;
begin
  if LanceAcompte then exit;
  DateSaisie := StrToDate(GetControlText('DATESAISIE'));
  SetControlText('XX_WHERE', ' (PSA_DATESORTIE>="' + USDateTime(DateSaisie) + '" ' +
    'OR PSA_DATESORTIE is null OR PSA_DATESORTIE<="'+UsDateTime(IDate1900)+'" ) ' + //PT1
    'AND PSA_DATEENTREE<="' + USDateTime(DateSaisie) + '"');
end;

{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /    
Description .. : Exit des zones de saisie matricule salari�
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}
procedure TOF_PGMULACOMPTEGRP.ExitEdit(Sender: TObject);
var
  edit: thedit;
begin
  edit := THEdit(Sender);
  { AffectDefautCode que si gestion du code salari� en Num�rique }
  if edit <> nil then
    if (VH_Paie.PgTypeNumSal = 'NUM') and (length(Edit.text) < 11) and (isnumeric(edit.text)) then
      edit.text := AffectDefautCode(edit, 10);
end;

procedure TOF_PGMULACOMPTEGRP.OnArgument(Arguments: string);
var
  Bouvrir: TToolBarButton97;
  Defaut: ThEdit;
begin
  inherited;
  { Valeur par d�faut }
  SetControlText('TYPESAISIE', 'GRP');
  { Gestionnaire d'�v�nement }
  Bouvrir := TToolBarButton97(GetControl('BOuvrir'));
  if Bouvrir <> nil then Bouvrir.OnClick := PGLanceFiche;
  Defaut := ThEdit(getcontrol('PSA_SALARIE'));
  if Defaut <> nil then Defaut.OnExit := ExitEdit;
  Defaut := ThEdit(getcontrol('PSA_SALARIE_'));
  if Defaut <> nil then Defaut.OnExit := ExitEdit;
end;

procedure TOF_PGMULACOMPTEGRP.OnLoad;
begin
  inherited;
  { Application du XX_WHERE }
  ActiveWhere(nil);
end;


{***********A.G.L.Priv�.*****************************************
Auteur  ...... : Paie PGI
Cr�� le ...... : 30/01/2004
Modifi� le ... :   /  /    
Description .. : Sur le bouton Ouvrir
Mots clefs ... : PAIE;ACOMPTE
*****************************************************************}
procedure TOF_PGMULACOMPTEGRP.PGLanceFiche(Sender: TObject);
var
  Salarie, St: string;
  i: integer;
  Selection : boolean;   { PT2 }
begin
  Selection := False;    { PT2 }

  { Gestion de la s�lection de salari� }
  if (TFMul(Ecran).FListe.nbSelected > 0) and (not TFMul(Ecran).FListe.AllSelected) then
  begin
    if PgiAsk('Vous avez selectionn� des salari�s. Voulez-vous g�n�rer des acomptes que pour ces salari�s?', Ecran.caption) = mrYes then
    begin
      St := ''; Selection := True;  { PT2 }
      { G�n�ration acompte pour salari� s�lectionn� }
      { Composition du clause WHERE pour limiter le mul � ces salari�s }
      for i := 0 to TFMul(Ecran).FListe.NbSelected - 1 do
      begin
        {$IFDEF EAGLCLIENT}
        TFMul(Ecran).Q.TQ.Seek(TFMul(Ecran).FListe.Row - 1);
        {$ENDIF}
        TFMul(Ecran).FListe.GotoLeBookmark(i);
        Salarie := TFmul(Ecran).Q.FindField('PSA_SALARIE').asstring;
        St := St + ' PSA_SALARIE="' + Salarie + '" OR';
      end;
      TFMul(Ecran).FListe.ClearSelected;
      if St <> '' then // PT3
        SetControlText('XX_WHERE', GetControlText('XX_WHERE') + ' AND (' + Copy(St, 1, Length(st) - 2) + ')'); // PT3
      LanceAcompte := True;
      TFMul(Ecran).BCherche.Click;
      LanceAcompte := False;
    end
    else
      exit;
  end
  else if (TFMul(Ecran).FListe.nbSelected = 0) and (not TFMul(Ecran).FListe.AllSelected) then
  // DEB PT3
  begin
    PgiInfo('Vous devez pr�alablement s�lectionner les salari�s', Ecran.caption);
    exit;
  end;
  // FIN PT3

  { Confirmation de la g�n�ration des acomptes }
  if PgiAsk('Voulez-vous g�n�rer des acomptes pour les salari�s affich�s?', Ecran.caption) = mrNo then
  begin
    TheMulQ := nil;
    SetControlText('XX_WHERE', '');  { PT2 }
    TFMul(Ecran).BCherche.Click;     { PT2 }

    exit;
  end;

  { R�cup�ration de la Query pour traitement dans la fiche vierge }
  {$IFDEF EAGLCLIENT}
  if not Selection then TFMul(Ecran).Fetchlestous;  { PT2 }
   TheMulQ := TOB(Ecran.FindComponent('Q'));
  {$ELSE}
  TheMulQ := THQuery(Ecran.FindComponent('Q'));
  {$ENDIF}
  { Ouverture de la fiche }
  AglLanceFiche('PAY', 'ACOMPTE_GRP', '', '', GetControlText('TYPESAISIE'));
  TheMulQ := nil;
  SetControlText('XX_WHERE', '');  { PT2 }
  TFMul(Ecran).BCherche.Click;     { PT2 }
end;

initialization
  registerclasses([TOF_PGMULACOMPTEGRP]);
end.

