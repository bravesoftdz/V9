{***********UNITE*************************************************
Auteur  ...... : Bruno TREDEZ
Cr�� le ...... : 06/12/2001
Modifi� le ... :   /  /
Description .. : Source TOM de la TABLE : CIB (CIB)
Suite ........ : JP 03/08/03 : Migration eAGL
Suite ........ : JP 04/09/03 : Passage en Fiche Liste
Mots clefs ... : TOM;CIB
*****************************************************************}
{-------------------------------------------------------------------------------------
    Version    |  Date  | Qui | Commentaires
--------------------------------------------------------------------------------------
 1.2.0.001.001  08/03/04   JP  La tom g�re deux fiches TRFICCIB et TRCIB : gestion d'un
                               param�tre dans le OnArgument.
 1.2.X.001.001  08/04/04   JP  Chargement dynamique de Fiche.UniqueName car pour les r�gles d'accro-
                               chage il faut g�rer TCI_ModePaie et non pour les cib de r�f�rence.
 1.9.0.xxx.xxx  25/06/04   JP  Test sur le OnUpdate FQ 10094
 6.0.0.xxx.xxx  12/08/04   JP  Fusion des r�gles d'accrochage et des cib de r�f�rence FQ 10084
                               avec notamment l'utilisation d'une fiche liste � la place d'une fiche
 8.01.001.006   06/03/07   JP  Acc�s au mul des cibs de r�f�rence depuis la fiche liste 
--------------------------------------------------------------------------------------}
unit TomCIB ;

interface

uses {$IFDEF VER150} variants,{$ENDIF}
  {$IFDEF EAGLCLIENT}
  MaineAGL, 
  {$ELSE}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} FE_Main,
  {$ENDIF}
  Controls, Classes, Forms, SysUtils, HCtrls, UTOM, UTob,
  SaisieList, UTableFiltre, HMsgBox;

type
  TOM_CIB = Class (TOM)
    procedure OnChangeField(F: TField); override;
    procedure OnArgument   (S: string); override;
    procedure OnNewRecord             ; override;
    procedure OnAfterUpdateRecord     ; override;
    procedure OnUpdateRecord          ; override; {25/06/04}
  private
    TF      : TTableFiltre;
    MonType : string; {JP 08/03/04 : gestion du type d'appel}

    procedure DoDuplicate    (Sender : TObject);
    procedure BRegleClick    (Sender : TObject);
    procedure BReferenceClick(Sender : TObject); {06/03/07}
  end;

procedure TRLanceFiche_CIB(Dom, Fiche, Range, Lequel, Arguments : string);

Implementation

uses
  Constantes, HTB97, REGLEACCRO_TOM, TRMULCIB_TOF, HEnt1;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_CIB(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.OnArgument(S : string);
{---------------------------------------------------------------------------------------}
var
  bt : TToolbarButton97;
begin
  inherited;

  ReadTokenSt(S);
  {JP 08/03/04 : Il y a deux appels possibles � la tom : }
  MonType := ReadTokenSt(S);
  {... pour les cib ...}
  if MonType = tc_CIB then begin
    Ecran.HelpContext := 50000145;

    {On travaille sur la fiche en saisie Liste TRCIB}
    if (Ecran <> nil) and (Ecran is TFSaisieList) then
      TF := TFSaisieList(Ecran).LeFiltre
    else
      Abort;
    TToolbarButton97(GetControl('BTCREER')).OnClick := DoDuplicate;
    TToolbarButton97(GetControl('BREGLE' )).OnClick := BRegleClick;
    {06/03/07 : Acc�s au cibs de r�f�rence}
    bt := TToolbarButton97(GetControl('BPARAMLISTE'));
    bt.Visible := True;
    bt.Hint := TraduireMemoire('Voir les CIB de r�f�rence');
    bt.OnClick := BReferenceClick; {06/03/07}
  end
  else begin
    Ecran.HelpContext := 50000146;
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.DoDuplicate(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  SQL : string;
  Bqe : string;
  Q   : TQuery;
begin
  if MonType = tc_CIB then begin
    Bqe := VarToStr(TF.TOBFiltre.GetValue('PQ_BANQUE'));
    {Si des modifications sont en cours on demande la validation/ annulation}
    if not TF.CanReload or TF.Changed then begin
      HShowMessage('0;' + Ecran.Caption + ';Veuillez enregistrer ou annuler les modifications en cours.;W;O;O;O;', '', '');
      Exit;
    end;

    {03/06/04 : Th�oriquement le probl�me ne doit pas se poser}
    if Bqe = '' then begin
      HShowMessage('1;' + Ecran.Caption + ';Veuillez s�lectionner une banque.;W;O;O;O;', '', '');
      Exit;
    end;

    Q := OpenSQL('SELECT COUNT(TCI_CODECIB) FROM CIB WHERE TCI_BANQUE = "' + Bqe + '" ', True);
    try
      SQL := 'INSERT INTO CIB (TCI_CODECIB, TCI_LIBELLE, TCI_ABREGE, TCI_MODEPAIE, TCI_REGLEACCRO, TCI_SENS, TCI_BANQUE, TCI_PREDEFINI) ' +
             'SELECT TCI_CODECIB, TCI_LIBELLE, TCI_ABREGE, TCI_MODEPAIE, TCI_REGLEACCRO, TCI_SENS, "' + Bqe + '", "STD" ' +
             'FROM CIB WHERE TCI_BANQUE = "' + CODECIBREF + '"';
      {On ne duplique les codes CIB de "r�f�rence" que si cette banque n'a pas d�j� de code CIB de d�finis}
      if Q.Fields[0].AsInteger = 0 then
        ExecuteSQL(SQL)
      else begin
        {03/06/04 : ajout de la possibilit� de reprendre le param�trage de r�f�rence}
        if HShowMessage('2;' + Ecran.Caption + ';�tes-vous s�r de vouloir supprimer le param�trage actuel et'#13 +
                                               'de vouloir r�cup�rer le param�trage de r�f�rence ?;Q;YN;N;N;', '', '') = mrYes then begin
          ExecuteSQL('DELETE FROM CIB WHERE TCI_BANQUE = "' + Bqe + '"');
          ExecuteSQL(SQL);
        end;
      end;
    finally
      Ferme(Q);
    end;
    TF.RefreshLignes('');
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.OnChangeField ( F: TField ) ;
{---------------------------------------------------------------------------------------}
begin
  inherited ;
  if MonType = tc_CIB then begin
    {Mise � jour du libelle lors du choix d'un code CIB}
    if (UpperCase(F.FieldName) = 'TCI_CODECIB') and (TF.State in [dsInsert, dsEdit]) then begin
      TF.StartUpdate;
      SetField('TCI_LIBELLE', RechDom('TRCIB', F.AsString, False, ''));
      TF.EndUpdate;
    end;
  end;
end ;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.OnNewRecord;
{---------------------------------------------------------------------------------------}
begin
  inherited;
  if MonType = tc_Reference then SetField('TCI_BANQUE', CODECIBREF);
  if CtxPcl in V_PGI.PGIContexte then SetField('TCI_PREDEFINI', 'CEG')
                                 else SetField('TCI_PREDEFINI', 'STD');
end;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.OnAfterUpdateRecord;
{---------------------------------------------------------------------------------------}
{$IFDEF EAGLCLIENT}
var
  ph : string;
{$ENDIF}
begin
  inherited;
  {$IFDEF EAGLCLIENT}
  {03/06/04 : Mon ma�tre dirait que c'est anti-informatique, mais, bon il faut bien trouver une
              solution. Il se trouve que des clients ont plusieurs modes de paiement pour un seul
              et m�me cib => l'index doit donc �tre banque;cib;modepaie. Si cela ne pose pas de probl�me
              pour les cib par banque et les r�gles d'accrochage car on ne peut pas affecter le mode
              de paiement, il en va diff�remment pour les cib de r�f�rence car pour faciliter la
              t�che de l'utilisateur on a mis dans la table CIB les codes AFB avec un code banque @ID :
              il faut donc que l'utilisateur commence par affecter ... le mode de paiement avant de
              s'attaquer aux r�gles d'accrochage et aux cib par banque : d'o� le probl�me, comment faire
              un update sur un enregistrement dont on est en train de modifier l'index primaire ; si
              en 2/3, l'agl sait le faire ce n'est pas le cas en cwas, c'est pourquoi je le fais � la
              main apr�s le updaterecord. XP dirait que c'est de la merde, mais tant que �a marche ... !}
  if MonType = tc_Reference then begin
    if VarToStr(GetFieldAvantModif('TCI_MODEPAIE')) = '' then
      ph := '(TCI_MODEPAIE = "" OR TCI_MODEPAIE IS NULL)'
    else
      ph := 'TCI_MODEPAIE = "' + GetFieldAvantModif('TCI_MODEPAIE') + '"';

    ExecuteSQL('UPDATE CIB SET TCI_MODEPAIE = "' + GetField('TCI_MODEPAIE') + '", TCI_SENS = "' + GetField('TCI_SENS') +
               '" WHERE TCI_BANQUE = "' + CODECIBREF + '" AND TCI_CODECIB = "' + GetField('TCI_CODECIB') + '" AND ' + ph);
  end;
  {$ENDIF}
end;

{---------------------------------------------------------------------------------------}
procedure TOM_CIB.OnUpdateRecord;
{---------------------------------------------------------------------------------------}
var
  bq : string;

  {--------------------------------------------------}
  function ExisteDeja : Boolean;
  {--------------------------------------------------}
  var
    T : TOB;
  begin
    T := TF.TOBFiltre.FindFirst(['TCI_BANQUE', 'TCI_MODEPAIE', 'TCI_SENS'],
                                [bq, GetField('TCI_MODEPAIE'), GetField('TCI_SENS')], True);

    if Assigned(T) and (T.GetString('TCI_CODECIB') = GetField('TCI_CODECIB')) then
      {L'enregistrement trouv� est celui en cours, ce qui n'est pas pertinent}
      T := TF.TOBFiltre.FindNext(['TCI_BANQUE', 'TCI_MODEPAIE', 'TCI_SENS'],
                                 [bq, GetField('TCI_MODEPAIE'), GetField('TCI_SENS')], True);
    Result := Assigned(T);
  end;

begin
  {14/01/04 : En eAgl au moins il arrive que cette ligne dans OnNewRecord soit inefficace}
  if MonType = tc_Reference then SetField('TCI_BANQUE', CODECIBREF);
  inherited;
  {25/06/04 : FQ 10094.
              On regarde s'il n'existe pas un autre CIB pour cette banque qui aurait le m�me sens et
              le m�me mode de paiement. Cependant on n'applique pas le test sur le sens MIX qui lors
              de la synchronisation n'est qu'une solution de repli si l'on n'a pas trouv� un ENC ou DEC}
  if GetField('TCI_SENS') = 'MIX' then Exit;

  if MonType = tc_Reference then bq := CODECIBREF
  else if MonType = tc_CIB  then bq := TF.TOBFiltre.GetString('PQ_BANQUE');

  {29/06/04 : Si le sens ou le mode de paiement est vide, le test n'a pas de sens}
  if (Trim(GetField('TCI_SENS')) = '') or (Trim(GetField('TCI_MODEPAIE')) = '') then Exit;

  if ((MonType = tc_Reference) and
      {Si les modification porte sur le sens}
      IsFieldModified('TCI_SENS') and
      {on est sur la Fiche, on fait la v�rification sur la table}
      ExisteSQL('SELECT TCI_CODECIB FROM CIB WHERE TCI_BANQUE = "' + bq + '" AND TCI_SENS = "' +
                GetField('TCI_SENS') + '" AND TCI_MODEPAIE = "' + GetField('TCI_MODEPAIE') + '"'))
     or
     {On est sur la fiche liste, on travaille sur les valeurs en cache}
     ((MonType = tc_CIB) and ExisteDeja) then
    {On ne valide la modification que sur confirmation de l'utilisateur}
    LastError := HShowMessage('0;' + Ecran.Caption + ';Il existe d�j� un CIB pour ce mode de r�glement et ce sens.'#13 +
                              'Cela pourra cr�er des incoh�rence lors de la synchronisation des �critures comptables.'#13 +
                              '�tes-vous s�r de vouloir continuer ?;Q;YN;N;N', '', '') - mryes;

end;

{Bouton d'acc�s au param�trage des r�gles d'accrochage
{---------------------------------------------------------------------------------------}
procedure TOM_CIB.BRegleClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  {Appel de l'�cran de param�trage}
  TRLanceFiche_ParamRegleAccro('TR', 'TRFICHEACCROCHAGE', '', '', '');
  {Rafra�chissement de la tablette}
  THValComboBox(GetControl('TCI_REGLEACCRO')).Reload;
end;

{06/03/07 : Bouton d'acc�s au mul des cibs de r�f�rence
{---------------------------------------------------------------------------------------}
procedure TOM_CIB.BReferenceClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_MulCIB('TR', 'TRMULCIB', '', '', tc_Reference);
end;

initialization
  registerclasses ( [ TOM_CIB ] ) ;

end.

