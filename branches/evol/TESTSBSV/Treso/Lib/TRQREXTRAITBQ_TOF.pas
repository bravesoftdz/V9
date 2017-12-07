{ Unit� : Source TOF de la FICHE : TRQRETRAITBQ
--------------------------------------------------------------------------------------
    Version   |   Date | Qui |   Commentaires
--------------------------------------------------------------------------------------
 0.91          13/11/03  JP   Cr�ation de l'unit�
07.00.001.001  27/12/05  JP   FQ 10298 : Rupture par soci�t� pour l'�tat MultiSoc
07.06.001.001  09/10/06  JP   FQ 10347 : Ajout du choix de la r�f�rence de pointage
07.06.001.001  24/10/06  JP   Gestion des filtres multi soci�t�s
                              Mise en place de l'anc�tre des �tats
07.06.001.001  17/11/06  JP   FQ 10378 : Gestion des relev�s vides (1 ligne '01' d'ent�te et une ligne '07' de pied
                              mais pas de ligne '04' et '05' de d�tail
07.09.001.005  30/01/07  JP   FQ 10400 : Si en mono soci�t�, la conversion BQ_CODE -> BQ_GENERAL n'est pas faite
08.00.001.013  03/05/07  JP   Correction de la requ�te pour le libell� de la soci�t�
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TRQREXTRAITBQ_TOF;

interface

uses
  StdCtrls, Controls, Classes,
  {$IFNDEF EAGLCLIENT}
  QRS1, FE_Main, {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ELSE}
  eQRS1, MaineAGL, uTob,
  {$ENDIF}
  SysUtils, UTOF, uAncetreEtat;

type
  TOF_TRQREXTRAITBQ = class(TRANCETREETAT)
    procedure OnArgument(S : string); override;
    procedure OnUpdate              ; override;
  private
    MultiSoc  : Boolean; {27/12/05 : FQ 10298}
    NomBase   : string;  {09/10/06 : FQ 10347}
    BqGeneral : string;  {09/10/06 : FQ 10347}

    procedure ChoixDossier     (Sender : TObject);{27/12/05 : FQ 10298}
    procedure RefPointageOnClik(Sender : TObject);{09/10/06 : FQ 10347}
    procedure BqCodeOnChange   (Sender : TObject);{09/10/06 : FQ 10347}
  end;

procedure TRLanceFiche_Extrait(Dom, Fiche, Range, Lequel, Arguments : string);

implementation

uses
  {$IFDEF TRCONF}
  ULibConfidentialite,
  {$ENDIF TRCONF}
  LookUp, HCtrls, Commun, HEnt1, UtilPgi, ParamSoc;

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_Extrait(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
var
  s : string;
begin
  {27/12/05 : FQ 10298 : pour savoir qui est l'appelant}
  if Fiche = 'TRQREXTRAITBQMD' then s := 'MULTI;'
                               else s := 'MONO;';
  AGLLanceFiche(Dom, Fiche, Range, Lequel, s);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQREXTRAITBQ.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
begin
  {$IFDEF TRCONF}
  TypeConfidentialite := tyc_Banque + ';';
  {$ENDIF TRCONF}
  inherited;
  MultiSoc := False;
  Ecran.HelpContext := 150;

  {27/12/05 : FQ 10298 : Gestion de la rupture sur le champ societe}
  if ReadTokenSt(S) = 'MULTI' then begin
    THValComboBox(GetControl('MULTIDOSSIER')).OnChange := ChoixDossier;
    MultiSoc := True;
  end;

  {09/10/06 : FQ 10347 : on ne g�re la r�f�rence de pointage qu'en mode mono soci�t�}
  THEdit(GetControl('EE_REFPOINTAGE')).OnElipsisClick := RefPointageOnClik;
  SetControlVisible('EE_REFPOINTAGE' , not MultiSoc);
  SetControlVisible('TEE_REFPOINTAGE', not MultiSoc);
  {30/01/06 : FQ 10400 : on ex�cute BqCodeOnChange m�me en mono soci�t�}
  THEdit(GetControl('BQ_CODE')).OnChange := BqCodeOnChange;

  {24/10/06 : On filtre les comptes en fonction des soci�t�s du regroupement Tr�so}
  if not EtatMD then
    THEdit(GetControl('BQ_CODE')).Plus := FiltreBanqueCp(THEdit(GetControl('BQ_CODE')).DataType, '', '');
end;

{09/10/06 : FQ 10347 : Ajout du choix de la r�f�rence de pointage
{---------------------------------------------------------------------------------------}
procedure TOF_TRQREXTRAITBQ.RefPointageOnClik(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  LookUpList(THEdit(Sender), 'R�f�rence de pointage', GetTableDossier(NomBase, 'EEXBQ'),'EE_REFPOINTAGE','EE_DATEPOINTAGE','EE_GENERAL="' + BqGeneral + '"', 'EE_DATEPOINTAGE DESC', True, 0);
end;

{30/01/07 : Gestion de de la conversion BQ_CODE -> BQ_GENERAL en mono soci�t�
            Avant BqCodeOnChange n'�tait appel� que si IsTresoMultiSoc = True
{---------------------------------------------------------------------------------------}
procedure TOF_TRQREXTRAITBQ.BqCodeOnChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  s : string;
begin
  if IsTresoMultiSoc then
    s := 'SELECT BQ_GENERAL, DOS_NOMBASE FROM BANQUECP ' +
         'LEFT JOIN DOSSIER ON DOS_NODOSSIER = BQ_NODOSSIER ' +
         'WHERE BQ_CODE = "' + GetControlText('BQ_CODE') + '"'
  else
    s := 'SELECT BQ_GENERAL FROM BANQUECP ' +
         'WHERE BQ_CODE = "' + GetControlText('BQ_CODE') + '"';

  NomBase := V_PGI.SchemaName;

  Q := OpenSQL(s, True);
  if not Q.EOF then begin
    if IsTresoMultiSoc then
      NomBase := Q.FindField('DOS_NOMBASE').AsString;
    BqGeneral := Q.FindField('BQ_GENERAL' ).AsString;
  end;
  Ferme(Q);
end;

{27/12/05 : FQ 10298 : Si on demande un �tat multi-soci�t�, on pr�cise qu'il faut afficher
            la rupture Societe qui contient le libell� de la soci�t�
{---------------------------------------------------------------------------------------}
procedure TOF_TRQREXTRAITBQ.ChoixDossier(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if GetControlText('MULTIDOSSIER') <> '' then SetControlText('MULTISOC', 'X')
                                          else SetControlText('MULTISOC', '-');
end;

{16/11/06 : FQ 10378 : il faut pr�fixer les tables non partag�es
{---------------------------------------------------------------------------------------}
procedure TOF_TRQREXTRAITBQ.OnUpdate;
{---------------------------------------------------------------------------------------}
var
  where : string;
begin
  inherited;
  where := TFQRS1(Ecran).WhereSQL;
  {03/05/07 : Gestion du libell� de la soci�t�}
  if EstMultiSoc then
    TFQRS1(Ecran).WhereSQL := 'SELECT E.*, L.*, B.*, D.D_LIBELLE, DOSSIER.DOS_LIBELLE SOCLIB FROM ' + GetTableDossier(NomBase, 'EEXBQ') + ' E ' +
                              'LEFT JOIN ' + GetTableDossier(NomBase, 'EEXBQLIG') + ' L ON E.EE_NUMRELEVE = CEL_NUMRELEVE AND E.EE_GENERAL = CEL_GENERAL ' +
                              'LEFT JOIN BANQUECP B ON EE_GENERAL = BQ_GENERAL ' +
                              'LEFT JOIN DEVISE D ON EE_DEVISE = D_DEVISE ' +
                              'LEFT JOIN DOSSIER ON DOS_NODOSSIER = BQ_NODOSSIER '
  else
    TFQRS1(Ecran).WhereSQL := 'SELECT E.*, L.*, B.*, D.D_LIBELLE, "' + GetParamSocSecur('SO_LIBELLE', '') + '" SOCLIB FROM EEXBQ E ' +
                              'LEFT JOIN EEXBQLIG L ON E.EE_NUMRELEVE = CEL_NUMRELEVE AND E.EE_GENERAL = CEL_GENERAL ' +
                              'LEFT JOIN BANQUECP B ON EE_GENERAL = BQ_GENERAL ' +
                              'LEFT JOIN DEVISE D ON EE_DEVISE = D_DEVISE ';

  TFQRS1(Ecran).WhereSQL := TFQRS1(Ecran).WhereSQL + ' WHERE ' + Where;
  TFQRS1(Ecran).WhereSQL := TFQRS1(Ecran).WhereSQL + 'ORDER BY SOCLIB, EE_GENERAL, EE_NUMRELEVE';
end;

initialization
  RegisterClasses([TOF_TRQREXTRAITBQ]);

end.

