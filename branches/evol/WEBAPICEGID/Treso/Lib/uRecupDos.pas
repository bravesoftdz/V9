{Diverses Moulinettes pour les tables de la Tr�sorerie, en particulier pour le passage
 en Multi soci�t�s avec la gestion du champ NoDossier

 La fonction MonoToMultiSoc lance quoiqu'il arrive MoulineBQCODE car maintenant la Tr�so
 est maintenant structur�e autour de BQ_CODE et non plus BQ_GENERAL.

 En Multi soci�t� :
  Si l'on veut fusionner des bases, il faut
  En pr�alable, il faut int�grer la bob des ParamSoc et par le PGIMajVer mettre � jour dans toutes
  les bases le ParamSoc SO_TRBASETRESO

  1/ Dans tous les cas, suppression des listes et integration des BOB
  2/ On commence par mettre la table BANQUECP en configuration : FUSIONNEBANQUECP
  3/ On met ensuite � jour les champs NoDossier : MAJNODOSSIER
  4/ On modifie la valeur de champs _GENERAL avec la valeur BQ_CODE
  5/ D�placement des �critures de r�initialisation au matin du 01/01
  6/ On fusionne ensuite les 4 tables de conditions
  7/ On fusionne les tables de mouvements (Le param�trage est celui de la base Tr�so, sauf
     pour BANQUECP qui est fusionn�) ?!!
--------------------------------------------------------------------------------------
    Version   |  Date   | Qui | Commentaires
--------------------------------------------------------------------------------------
7.09.001.001   01/08/06   JP   MOULINEBQCODE : remplacement de la valeur pour les champs
                               _GENERAL de BQ_GENERAL par BQ_CODE
7.09.001.001   02/08/06   JP   FUSIONNEBANQUECP : la table BANQUECP �tant maintenant partag�e, reprise
                               de tous les comptes du regroupement ##MULTISOC dans la base de r�f�rence
7.09.001.001   03/08/06   JP   MAJNODOSSIER : lors de la cr�ation des champs _NODOSSIER, ils sont
                               initialiser par le PGIMAJVER � "000000" : mise � jour avec V_PGI.NoDossier
                               ou par l'utilisation de la table Dossier
7.09.001.001   03/08/06   JP   FUSIONNETABLEMVT : int�gre dans la base Tr�so tous les mouvements de
                               tr�sorerie �ventuellement saisis dans d'autres bases
7.09.001.001   04/08/06   JP   FUSIONNECONDITIONS : fusion des conditions de valeur, �quililibrage,
                               de d�couvert et de financements / placements
7.09.001.001   03/10/06   JP   CREERIBATTENTE : Cr�ation pour les Tr�sos multi soci�t�s des banques et les
                               agences pour les comptes courants et les comptes titres
7.09.001.001   18/10/06   JP   MAJTABLEDOSSIER : Renseigne le libell� dans la table dossier
7.09.001.001   06/11/06   JP   MAJREINIT : d�place les �critures de r�initialisation du 01/01 soir au
                               01/01 matin. Le solde est recalcul� par d�duction des �critures du 01/01
                               Traitement effectu� que l'on soit en Multi soci�t�s ou non
7.09.001.007   02/03/07   JP   Gestion de RB_NODOSSIER
8.00.002.002   01/08/07   JP   Purge des comptes sp�ciaux s'ils ne se justifient pas
8.10.001.010   20/09/07   JP   FQ 10511 : On nettoie les tables de conditions dont le compte n'existe plus
8.10.001.011   27/09/07   JP   Gestion de l'ajout de dossier dans un p�le de Tr�so (cf. TRADDCASHPOOLING_TOF)
                               Maintenant la moulinette en ouverture d'appli si SO_TRMOULINEBQCODE <> "X", se
                               contente de g�rer le basculement de BQ_GENERAL vers BQ_CODE. Toute la gestion de
                               fusion li�e au cash pooling est g�rer de puis TRADDCASHPOOLING_TOF
--------------------------------------------------------------------------------------}
unit uRecupDos;

interface

uses
  {$IFDEF EAGLCLIENT}
  {$ELSE}
  {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
  {$ENDIF EAGLCLIENT}
  SysUtils;

{Fonction g�n�rique appelant l'ensemble des traitements n�cessaires pour avoir
 une Tr�sorerie en configurations multi soci�t�s}
function MonoToMultiSoc : Boolean;
{Moulinette pour remplacer la valeur des champs _GENERAL par BQ_CODE dans la Tr�so}
function MoulineBQCODE(CurBase : string) : Boolean;
{Maj la valeur des champs _GENERAL par BQ_CODE dans la Tr�so}
function MajBQCode(CurBase, ChpWhere : string) : Boolean;
{Fusionne les enregistrements de BANQUECP des bases pass�es en param�tre}
function FusionneBanqueCp(Reg : string; AvecMsg : Boolean = True) : Boolean;
{Fusionne les 4 tables de conditions pour la base pass� een param�tre}
function FusionneConditions(CurBase : string; PoolBase : string) : Boolean;
{Mise � jour des champs NoDossier des bases pass�es en param�tre}
function MajNoDossier(FBase : string) : Boolean;
{Int�gre dans la base Tr�so tous les mouvements de tr�sorerie d'autres bases}
function FusionneTableMvt(CurBase : string; PoolBase : string) : Boolean;
{Mise � jour de la table DOS_LIBELLE � partir de SO_LIBELLE}
procedure MajTableDossier(CurBase : string);
{D�placement des �critures de r�initialisation au 01/01/XX au matin}
function MajReInit(Compte : string = '') : Boolean;
{Ajout de Banquecp dans la table de partage et maj de BQ_NODOSSIER et BQ_CODE}
function PartageBanqueCP(CurBase : string) : Boolean;
{Fonctions de gestion du ProgressForm}
procedure InitProgress(Titre : string; NB : Integer);
procedure MajProgress(Value : Integer; Caption, Sub : string);
procedure TermineProgress;
procedure CreeInfosTitreCourant; 

implementation

uses
  {$IFNDEF EAGLCLIENT}
  BobGestion, uHListe,
  {$ENDIF EAGLCLIENT}
  HCtrls, uTob, HStatus, ParamSoc, Constantes, HEnt1, HMsgBox, Commun, Controls,
  UtilPgi, UProcGen, ed_Tools, UProcSolde, Math, UTobDebug, Forms;

var
  ValProgress : Integer;

function  TesteBaseTresoMulti : Boolean; forward;
procedure CreeRibAttente; forward;
function  GetTablePartageLoc(NomTable : string; NomBase : string = '') : string; forward;
function  GetListeChamps(NomTable : string) : string; forward;
{26/06/07 : Mise � jour de la table CompteurTreso, car on a pu changer le champ SO_SOCIETE}
procedure MajCompteurTreso; forward;
{01/08/07 : Purge des comptes sp�ciaux s'ils ne se justifient pas}
procedure  FinaliseMoulinette; forward;


{---------------------------------------------------------------------------------------}
function GetTablePartageLoc(NomTable : string; NomBase : string = '') : string;
{---------------------------------------------------------------------------------------}
begin
  {On force le DBO sur la base locale}
  if NomBase = '' then NomBase := V_PGI.SchemaName;

  if isMssql then Result := NomBase + '.DBO.' + NomTable
             else Result := NomBase + '.' + NomTable;

end;

{---------------------------------------------------------------------------------------}
procedure InitProgress(Titre : string; NB : Integer);
{---------------------------------------------------------------------------------------}
begin
  ValProgress := 0;
  InitMoveProgressForm(nil, Titre, '', NB, False, True);
end;

{---------------------------------------------------------------------------------------}
procedure MajProgress(Value : Integer; Caption, Sub : string);
{---------------------------------------------------------------------------------------}
begin
  ValProgress := ValProgress + Value;
  TextsProgressForm(ValProgress, TraduireMemoire('Mise � jour des structures'), Caption, Sub);
  Application.ProcessMessages;
end;

{---------------------------------------------------------------------------------------}
procedure TermineProgress;
{---------------------------------------------------------------------------------------}
begin
  FiniMoveProgressForm;
end;

{Configuration de la Tr�sorerie en Multi soci�t�s
Attention !! CeTraitement ne peut �tre effectu� qu'en 2/3 � cause de l'int�gration des BOBS
{---------------------------------------------------------------------------------------}
function MonoToMultiSoc : Boolean;
{---------------------------------------------------------------------------------------}
var
//  CurBase : string;
  LBases  : string;
begin
  Result := False;
  InitProgress(TraduireMemoire('Mise � jour des structures'), 200);
  BeginTrans;

  try
    {Cr�ation d'un Rib sp�cial pour toutes les mouvements qui ne "passeraient" correctement MoulineBQCODE}
    CreeRibAttente;
    LBases := FiltreBaseTreso;

    {Fusion des comptes bancaires dans la base de r�f�rence}
    if EstMultiSoc then begin
      MajProgress(5, 'Gestion du param�trage', 'TesteBaseTresoMulti');

      {Si le Pgi est en MultiSoc mais pas la Tr�so}
      //if not IsTresoMultiSoc then begin
        {On s'assure qu'il ne s'agit pas d'une erreur et on lance MoulineBQCODE}
        Result := TesteBaseTresoMulti;
        if not Result then RollBack
                      else CommitTrans;
        FiniMoveProgressForm;
        Exit;
      (*
      end;

      {Cr�ation des agences et banques pour comptes titres et courants}
      MajProgress(5, 'Gestion du param�trage', 'CreeInfosTitreCourant');
      CreeInfosTitreCourant;

      {Fusion des comptes bancaires dans la base de r�f�rence}
      MajProgress(5, 'Gestion du param�trage', 'FusionneBanqueCp');
      if not FusionneBanqueCp(LBases, False) then begin
        RollBack;
        Exit;
      end;

      {Mise � jour des champs NoDossier qui sont � "000000"}
      MajProgress(5, 'Gestion du param�trage', 'MajNoDossier');
      if not MajNoDossier(LBases) then begin
        RollBack;
        Exit;
      end;

      {Il faut commencer par la base Treso MS}
      CurBase := V_PGI.SchemaName;
      while CurBase <> '' do begin
        {Mise � jour de la table Dossier}
        MajProgress(5, 'Dossier : ' + CurBase, 'MajTableDossier');
        MajTableDossier(CurBase);

        {Traitements g�n�raux}
        if (not MoulineBQCODE(CurBase)) or
           (not FusionneConditions(CurBase)) or
           (not FusionneTableMvt(CurBase)) then begin
          Result := False;
          RollBackDiscret;
          FiniMoveProgressForm;
          Exit;
        end;

        {Base suivante}
        CurBase := ReadTokenSt(LBases);
        {La base Treso MS a �t� faite en premier}
        if CurBase = V_PGI.SchemaName then CurBase := ReadTokenSt(LBases);
      end;

      {26/06/07 : Mise � jour de la table CompteurTreso, car on a pu changer le champ SO_SOCIETE}
      MajCompteurTreso;

      {D�placement des dates de r�initialisation au 01/01/ au matin apr�s la fusion des tables TRECRITURE}
      MajReInit;
      *)
    end

    {On est en mono base, mais il faut quand m�me utiliser BQ_CODE � la place de BQ_GENERAL
     et d�placer les dates de r�initialisation au 01/01/ au matin}
    else begin
      if MoulineBQCODE('') then
        MajReInit
      else begin
        RollBack;
        TermineProgress;
        Exit;
      end;
    end;

    {01/08/07 : Purge des comptes sp�ciaux s'ils ne se justifient pas}
    FinaliseMoulinette;

    Result := True;
    FiniMoveProgressForm;
    CommitTrans;
  except
    on E : Exception do begin
      Result := False;
      RollBack;
      TermineProgress;
    end;
  end;
end;

{Moulinette pour remplacer la valeur des champs _GENERAL par BQ_CODE dans la Tr�so
{---------------------------------------------------------------------------------------}
function MoulineBQCODE(CurBase : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  NomTable   : string;
  FNoDossier : string;

    {-------------------------------------------------------------------}
    procedure MajChpGeneral(Table, Chp : string);
    {-------------------------------------------------------------------}
    begin
      Movecur(False);
      NomTable := Table;

      {Pour les comptes/codes qui n'auraient pas pu �tre r�cup�r�s}
      ExecuteSQL('UPDATE ' + Table + ' SET ' + Chp + ' = "' + CODEATTENTEBQ + '" WHERE ' + CHP + ' = "" OR ' + CHP + ' IS NULL');
      Movecur(False);
      {Mise � jour du champ}
      ExecuteSQL('UPDATE ' + NomTable + ' SET ' + Chp + ' = (SELECT BQ_CODE FROM BANQUECP WHERE BQ_GENERAL = ' +
                 Chp + ' AND BQ_NODOSSIER = "' + FNoDossier + '")');
    end;

begin
  MajProgress(5, 'Dossier : ' + CurBase, 'MoulineBQCODE');

  Result := False;
  InitMove(40, '');
  BeginTrans;
  try
    try
      {R�cup�ration du NoDossier}
      if CurBase <> '' then
        FNoDossier := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_NODOSSIER')
      else begin
        NomTable := 'BANQUECP';
        CurBase  := V_PGI.SchemaName;
        {On n'est pas multiTreso}
        if EstMultiSoc then begin
          FNoDossier := GetInfosFromDossier('DOS_NOMBASE', V_PGI.SchemaName, 'DOS_NODOSSIER');
          ExecuteSQL('UPDATE ' + GetTablePartageLoc('BANQUECP') + ' SET BQ_NATURECPTE = "' + tcb_Bancaire + '", ' +
                     'BQ_NODOSSIER = "' + FNoDossier + '", BQ_CODE = SUBSTRING(BQ_GENERAL, 1, 12)||"' + StrRight(FNoDossier, 5) + '" ' +
                     'WHERE (BQ_NODOSSIER = "" OR BQ_NODOSSIER IS NULL ' +
                     'OR BQ_NODOSSIER = "' + CODEDOSSIERDEF + '") AND (BQ_NATURECPTE <> "' + tcb_Courant + '" ' +
                     'OR BQ_NATURECPTE = "" OR BQ_NATURECPTE IS NULL)');
          {Si on n'est pas sur la base de partage}
          if not ExisteSQL('SELECT ##TOP 1## DS_NOMBASE FROM DESHARE WHERE DS_NOMBASE = "' + V_PGI.SchemaName + '"') then begin
            {18/10/07 : Chez SIC, le compte d'attente existait d�j� dans la base COMPTANOO ... Par pr�caution}
            ExecuteSQL('DELETE FROM ' + GetTablePartageLoc('BANQUECP') + ' WHERE BQ_CODE = "' + CODEATTENTEBQ + '"');

            ExecuteSQL('INSERT INTO BANQUECP (' + GetListeChamps('BANQUECP') + ') SELECT ' + GetListeChamps('BANQUECP') + ' FROM ' + GetTablePartageLoc('BANQUECP'));
            ExecuteSQL('DELETE FROM ' + GetTablePartageLoc('BANQUECP'));
          end;
        end
        else begin
          FNoDossier := CODEDOSSIERDEF;
          {Mise � jour de la nature des comptes dans banquesCP, si l'on est en MonoBase car le FusionneBanqueCp n'est pas lanc�}
          ExecuteSQL('UPDATE BANQUECP SET BQ_NATURECPTE = "' + tcb_Bancaire + '", BQ_NODOSSIER = "' +
                     FNoDossier + '" WHERE BQ_NATURECPTE = "" OR BQ_NATURECPTE IS NULL');
        end;
      end;

      if not MajBQCode(CurBase, 'BQ_GENERAL') then begin
        RollBack;
        Exit;
      end;

    except
      on E : Exception do begin
        PGIError(TraduireMemoire('Le Traitement de mise � jour des structures a �chou�.'#13 +
                                 'Une erreur est intervenue lors du traitement de la table'#13 +
                                 NomTable + ', avec le message : '#13#13) +
                                 E.Message);
        RollBack;
        Exit;
      end;
    end;

    Result := True;
  finally
    if Result then begin
      CommitTrans;
      SetParamSocDossier('SO_TRMOULINEBQCODE', True, CurBase);
    end;
    FiniMove;
  end;
end;

{Fusionne les enregistrements de BANQUECP des bases pass�es en param�tre}
{---------------------------------------------------------------------------------------}
function FusionneBanqueCp(Reg : string; AvecMsg : Boolean = True) : Boolean;
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  T : TOB;
  F : TOB;
  n : Integer;
  d : string;
  S : string;
  B : string;
  L : string;
begin
  Result := False;
  MajProgress(20, 'Dossier : G�n�ral', 'FusionneBanqueCp');

  if AvecMsg then begin
    {Double confirmation}
    if HShowMessage('0;Fusion des comptes bancaires;Ce traitement consiste � r�cup�rer toutes les donn�es'#13 +
                    'concernant les comptes bancaires des diff�rents dossiers '#13 +
                    'pour les enregistrer dans le dossier de r�f�rence.'#13#13 +
                    'Souhaitez-vous poursuivre ?;Q;YN;N;N;', '', '') = mrNo then Exit;
    if HShowMessage('0;Fusion des comptes bancaires;Ce traitement � un impact important sur la comtabilit�,'#13 +
                    'la paie et la tr�sorerie.'#13#13'Souhaitez vous abandonner ?;Q;YN;Y;Y;', '', '') = mrYes then Exit;
  end;

  L := Reg;
  B := ReadTokenSt(L);
  S := '';
  while B <> '' do begin
    if S = '' then begin
      if isMssql then
        S := 'SELECT "' + B + '" ADOSSIER, * FROM ' + B + '.DBO.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR ' +
                 'BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"'
      else
        S := 'SELECT "' + B + '" ADOSSIER, BANQUECP.* FROM ' + B + '.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR ' +
                 'BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"'
    end
    else begin
      if isMssql then
        S := S + ' UNION ALL SELECT "' + B + '" ADOSSIER, * FROM ' + B + '.DBO.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR ' +
                 'BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"'
      else
        S := S + ' UNION ALL SELECT "' + B + '" ADOSSIER, BANQUECP.* FROM ' + B + '.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR ' +
                 'BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"'
    end;
    B := ReadTokenSt(L);
  end;

  {On ne traite que les comptes qui n'ont pas le NODOSSIER de correctement param�tr�}
  Q := OpenSQL(S, True);
  T := TOB.Create('ABANQUECP', nil, -1);
  try
    T.LoadDetailDB('BANQUECP', '', '', Q, False);

    for n := 0 to T.Detail.Count - 1 do begin
      F := T.Detail[n];
      d := GetInfosFromDossier('DOS_NOMBASE', F.GetString('ADOSSIER'), 'DOS_NODOSSIER');
      F.SetString('BQ_CODE', Copy(F.GetString('BQ_GENERAL'), 1, 12) + StrRight(d, 5));
      F.SetString('BQ_NODOSSIER', d);
      if F.GetString('BQ_NATURECPTE') = '' then F.SetString('BQ_NATURECPTE', tcb_Bancaire);
    end;

    BeginTrans;
    try
      {Suppression des anciens enregistrements}
      L := Reg;
      d := ReadTokenSt(L);
      while d <> '' do begin
        if isMssql then
          ExecuteSQL('DELETE FROM ' + d + '.DBO.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"')
        else
          ExecuteSQL('DELETE FROM ' + d + '.BANQUECP WHERE BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "" OR BQ_NODOSSIER = "' + CODEDOSSIERDEF + '"');
        d := ReadTokenSt(L);
      end;

      Result := True;
      for n := 0 to T.Detail.Count - 1 do begin
        F := T.Detail[n];
        F.DelChampSup('ADOSSIER', False);
        d := F.MakeInsertSQL;
        Result := (ExecuteSQL(d) = 1);
        if not Result then Break;
      end;

      if Result then begin
        CommitTrans;
        if AvecMsg then
          HShowMessage('0;Fusion des comptes bancaires;Traitement termin�;I;O;O;O;', '', '');
      end
      else begin
        RollBack;
        HShowMessage('0;Fusion des comptes bancaires;Impossible de mettre � jour BANQUECP;E;O;O;O;', '', '');
      end;

    except
      on E : Exception do begin
        RollBack;
        PGIError('Fusion des comptes bancaires interrompue : '#13 + E.Message);
      end;
    end;
  finally
    Ferme(Q);
    FreeAndNil(T);
  end;
end;

{Fusionne les 4 tables de conditions pour la base pass�e en param�tre
{---------------------------------------------------------------------------------------}
function FusionneConditions(CurBase : string; PoolBase : string) : Boolean;
{---------------------------------------------------------------------------------------}
begin
  MajProgress(5, 'Dossier : ' + CurBase, 'FusionneConditions');
  Result := False;
  {Bien s�r, on ne traite pas la base de Tr�osreire}
  if PoolBase = CurBase then begin
    Result := True;
    Exit;
  end
  {Par pr�caution ...}
  else if (CurBase = '') or (PoolBase = '') then
    Exit;

  InitMove(5, '');
  try
    BeginTrans;
    try
      MajProgress(5, 'Dossier : ' + CurBase, 'Copie les conditions');

      MoveCur(False);
      ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'CONDITIONDEC') + ' (' + GetListeChamps('CONDITIONDEC') + ') SELECT ' + GetListeChamps('CONDITIONDEC') + ' FROM ' + GetTableDossier(CurBase, 'CONDITIONDEC'));
      MoveCur(False);
      ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'CONDITIONEQUI') + ' (' + GetListeChamps('CONDITIONEQUI') + ') SELECT ' + GetListeChamps('CONDITIONEQUI') + ' FROM ' + GetTableDossier(CurBase, 'CONDITIONEQUI'));
      MoveCur(False);
      ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'CONDITIONFINPLAC') + ' (' + GetListeChamps('CONDITIONFINPLAC') + ') SELECT ' + GetListeChamps('CONDITIONFINPLAC') + ' FROM ' + GetTableDossier(CurBase, 'CONDITIONFINPLAC'));
      MoveCur(False);
      ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'CONDITIONVAL') + ' (' + GetListeChamps('CONDITIONVAL') + ') SELECT ' + GetListeChamps('CONDITIONVAL') + ' FROM ' + GetTableDossier(CurBase, 'CONDITIONVAL'));
      MoveCur(False);

      {05/10/07 : Supppression des conditions}
      MajProgress(5, 'Dossier : ' + CurBase, 'Supprime les conditions');

      MoveCur(False);
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONDEC'));
      MoveCur(False);
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONEQUI'));
      MoveCur(False);
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONFINPLAC'));
      MoveCur(False);
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONVAL'));
      MoveCur(False);

      CommitTrans;
      Result := True;
    except
      on E : Exception do begin
        RollBack;
        PGIError('Fusion des conditions (Base : ' + CurBase + ') interrompue :'#13#13 + E.Message);
        Result := False;
      end;
    end;
  finally
    FiniMove;
  end;
end;

{Mise � jour des champs NoDossier des bases pass�es en param�tre.
Th�oriquement, cela ne doit se faire que sur une base, car la Tr�so est mono base et multi
soci�t�s ; cependant, l'on ne peut exclure qu'il y ait une demande pour un passage en multi
soci�t�s chez des clients qui avait plusieurs dossiers. Il faut donc ex�cuter ce traitement
avant de fusionner les bases.
Le Cas de BANQUECP est trait� � part, car la Table est partag�e et le besoin de traiter cette
table peut �tre ind�pendant de l'utilisation de la Tr�so.
{---------------------------------------------------------------------------------------}
function MajNoDossier(FBase : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  FNoDossier : string;
  CurBase    : string;

    {-------------------------------------------------------------------}
    function MajTables : Boolean;
    {-------------------------------------------------------------------}
    begin
      BeginTrans;
      try
        Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'COURTSTERMES') + ' SET TCT_NODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TCT_NODOSSIER = "" OR TCT_NODOSSIER = "' + CODEDOSSIERDEF + '" OR TCT_NODOSSIER IS NULL');
        Movecur(False); Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'EQUILIBRAGE') + ' SET TEQ_SNODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TEQ_SNODOSSIER = "" OR TEQ_SNODOSSIER = "' + CODEDOSSIERDEF + '" OR TEQ_SNODOSSIER IS NULL');
        Movecur(False); Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'EQUILIBRAGE') + ' SET TEQ_DNODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TEQ_DNODOSSIER = "" OR TEQ_DNODOSSIER = "' + CODEDOSSIERDEF + '" OR TEQ_DNODOSSIER IS NULL');
        Movecur(False); Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'TRECRITURE') + ' SET TE_NODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TE_NODOSSIER = "" OR TE_NODOSSIER = "' + CODEDOSSIERDEF + '" OR TE_NODOSSIER IS NULL');
        Movecur(False); Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'TROPCVM') + ' SET TOP_NODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TOP_NODOSSIER = "" OR TOP_NODOSSIER = "' + CODEDOSSIERDEF + '" OR TOP_NODOSSIER IS NULL');
        Movecur(False); Movecur(False);
        ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'TRVENTEOPCVM') + ' SET TVE_NODOSSIER = "' + FNoDossier + '" ' +
                   'WHERE TVE_NODOSSIER = "" OR TVE_NODOSSIER = "' + CODEDOSSIERDEF + '" OR TVE_NODOSSIER IS NULL');
        Movecur(False);
        CommitTrans;
        Result := True;
      except
        on E : Exception do begin
          RollBack;
          PGIError('Mise � jour des champs "NODOSSIER" (Base : ' + CurBase + ') interrompue :'#13#13 + E.Message);
          Result := False;
        end;
      end;
    end;

begin
  Result := True;
  {On est sur la base courante ...}
  if FBase = '' then begin
    {... On reprend la valeur de V_PGI.NoDossier initialis�e dans MDisp.Dispacth(10)}
    FNoDossier := V_PGI.NoDossier;
    CurBase := V_PGI.SchemaName;
    InitMove(12, '');
    Result := MajTables;
    FiniMove;
  end

  {On a une liste de dossiers}
  else begin
    InitMove((NbOccurences(';', FBase) + 1) * 12, '');
    try
      CurBase := ReadTokenSt(FBase);
      while CurBase <> '' do begin
        {On va chercher la valeur de NoDossier dans la table DOSSIER � partir du nom de la base}
        FNoDossier := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_NODOSSIER');

        if (FNoDossier = '') or (not MajTables) then begin
          Result := False;
          // ListBox
          Break;
        end;

        {Base suivante}
        CurBase := ReadTokenSt(FBase);
      end;
    finally
      FiniMove;
    end;
  end;

end;

{---------------------------------------------------------------------------------------}
function FusionneTableMvt(CurBase : string; PoolBase : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  Q  : TQuery;
  s  : string;
  r  : string;
  CS : string;
begin
  Result := False;

  {Bien s�r, on ne traite pas la base de Tr�oserie MS}
  if PoolBase = CurBase then begin
    CS := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_SOCIETE');
    if CS = '' then Exit;
    Result := True;
    r := 'UPDATE ' + GetTableDossier(CurBase, 'TROPCVM') + ' SET TOP_NUMOPCVM = SUBSTRING(TOP_NUMOPCVM, 1, 3)||"' + CS + '"||SUBSTRING(TOP_NUMOPCVM, 7, 10)';
    ExecuteSQL(r);
    r := 'UPDATE ' + GetTableDossier(CurBase, 'TRVENTEOPCVM') + ' SET TVE_NUMTRANSAC = SUBSTRING(TVE_NUMTRANSAC, 1, 3)||"' + CS + '"||SUBSTRING(TVE_NUMTRANSAC, 7, 10)';
    ExecuteSQL(r);
    r := 'UPDATE ' + GetTableDossier(CurBase, 'COURTSTERMES') + ' SET TCT_NUMTRANSAC = SUBSTRING(TCT_NUMTRANSAC, 1, 3)||"' + CS + '"||SUBSTRING(TCT_NUMTRANSAC, 7, 10)';
    ExecuteSQL(r);
    Exit;
  end
  {Par pr�caution ...}
  else if (CurBase = '') or (PoolBase = '') then
    Exit;

  CS := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_SOCIETE');
  if CS = '' then Exit;

  BeginTrans;
  try
    {18/10/06 : Pour �viter les duplications de clefs sur TCT_NUMTRANSAC, on change le code soci�t� du Num�ro de transaction}
    MajProgress(5, 'Dossier : ' + CurBase, 'COURTSTERMES');
    {Mise � jour de la base en cours de traitement}
    r := 'UPDATE ' + GetTableDossier(CurBase, 'COURTSTERMES') + ' SET TCT_NUMTRANSAC = SUBSTRING(TCT_NUMTRANSAC, 1, 3)||"' + CS + '"||SUBSTRING(TCT_NUMTRANSAC, 7, 10)';
    ExecuteSQL(r);
    {Insertion des donn�es de la base courante dans la base Tr�so}
    r := 'INSERT INTO ' + GetTableDossier(PoolBase, 'COURTSTERMES') + ' (' + GetListeChamps('COURTSTERMES') + ') SELECT ' + GetListeChamps('COURTSTERMES') + ' FROM ' + GetTableDossier(CurBase, 'COURTSTERMES');
    ExecuteSQL(r);

    {18/10/06 : Pour �viter les duplications de clefs sur TOP_NUMOPCVM, on change le code soci�t� du Num�ro d'OPCVM
                Comme le num�ro d'OPCVM est repris dans les ventes, mise � jour aussi des ventes}
    MajProgress(5, 'Dossier : ' + CurBase, 'TROPCVM');
    {Mise � jour de la base en cours de traitement}
    r := 'UPDATE ' + GetTableDossier(CurBase, 'TROPCVM') + ' SET TOP_NUMOPCVM = SUBSTRING(TOP_NUMOPCVM, 1, 3)||"' + CS + '"||SUBSTRING(TOP_NUMOPCVM, 7, 10)';
    ExecuteSQL(r);
    r := 'UPDATE ' + GetTableDossier(CurBase, 'TRVENTEOPCVM') + ' SET TVE_NUMTRANSAC = SUBSTRING(TVE_NUMTRANSAC, 1, 3)||"' + CS + '"||SUBSTRING(TVE_NUMTRANSAC, 7, 10)';
    ExecuteSQL(r);
    {Insertion des donn�es de la base courante dans la base Tr�so}
    ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'TROPCVM') + ' (' + GetListeChamps('TROPCVM') + ') SELECT ' + GetListeChamps('TROPCVM') + ' FROM ' + GetTableDossier(CurBase, 'TROPCVM'));

    {18/10/06 : Pour �viter les duplications de clefs sur TVE_NUMVENTE, on ajoute le maximum d�j�
                pr�sent dans ma table aux Op�rations que l'on ins�re dans la table
                ExecuteSQL('INSERT INTO TRVENTEOPCVM SELECT * FROM ' + GetTableDossier(CurBase, 'TRVENTEOPCVM'));}
    MajProgress(5, 'Dossier : ' + CurBase, 'TRVENTEOPCVM');
    Q := OpenSQL('SELECT MAX(TVE_NUMVENTE) FROM ' + GetTableDossier(PoolBase, 'TRVENTEOPCVM'), True);
    if not Q.EOF then s := Q.Fields[0].AsString;
    Ferme(Q);
    if Trim(s) = '' then s := '0';

    r := 'INSERT INTO ' + GetTableDossier(PoolBase, 'TRVENTEOPCVM') + ' (TVE_CODEOPCVM,TVE_COMMISSIONEUR,TVE_COMPTA,TVE_COTATION,TVE_COURSEUR,TVE_DATEACHAT,TVE_DATECOMPTA,TVE_DATECREATION,';
    r := r + 'TVE_DATEMODIF,TVE_DATEVBO,TVE_DATEVENTE,TVE_DEVISE,TVE_FRAISEUR,TVE_GENERAL,TVE_LETTRECONFIRM,TVE_LIBELLE,TVE_MONTANT,TVE_MONTANTDEV,';
    r := r + 'TVE_NBVENDUE,TVE_NODOSSIER,TVE_NUMLIGNE,TVE_NUMTRANSAC,TVE_NUMVENTE,TVE_ORDREPAIE,TVE_PMVALUEBRUT,TVE_PMVALUEBRUTDEV,TVE_PMVALUENETDEV,';
    r := r + 'TVE_PMVALUENETTE,TVE_PORTEFEUILLE,TVE_RENDEMENT,TVE_RENDEMENTNET,TVE_SOCIETE,TVE_TICKET,TVE_TVAVENTEEUR,TVE_TYPEVENTE,TVE_USERCOMPTA,';
    r := r + 'TVE_USERCREATION,TVE_USERMODIF,TVE_USERVBO,TVE_VALBO) ';
    r := r + 'SELECT TVE_CODEOPCVM,TVE_COMMISSIONEUR,TVE_COMPTA,TVE_COTATION,TVE_COURSEUR,TVE_DATEACHAT,TVE_DATECOMPTA,TVE_DATECREATION,';
    r := r + 'TVE_DATEMODIF,TVE_DATEVBO,TVE_DATEVENTE,TVE_DEVISE,TVE_FRAISEUR,TVE_GENERAL,TVE_LETTRECONFIRM,TVE_LIBELLE,TVE_MONTANT,TVE_MONTANTDEV,';
    r := r + 'TVE_NBVENDUE,TVE_NODOSSIER,TVE_NUMLIGNE,TVE_NUMTRANSAC,TVE_NUMVENTE + 1 + ' + s + ',TVE_ORDREPAIE,TVE_PMVALUEBRUT,TVE_PMVALUEBRUTDEV,TVE_PMVALUENETDEV,';
    r := r + 'TVE_PMVALUENETTE,TVE_PORTEFEUILLE,TVE_RENDEMENT,TVE_RENDEMENTNET,TVE_SOCIETE,TVE_TICKET,TVE_TVAVENTEEUR,TVE_TYPEVENTE,TVE_USERCOMPTA,';
    r := r + 'TVE_USERCREATION,TVE_USERMODIF,TVE_USERVBO,TVE_VALBO FROM ' + GetTableDossier(CurBase, 'TRVENTEOPCVM');
    ExecuteSQL(r);


    {18/10/06 : Pour �viter les duplications de clefs sur TEQ_NUMEQUI, on ajoute le maximum d�j�
                pr�sent dans ma table aux Op�rations que l'on ins�re dans la table
                ExecuteSQL('INSERT INTO EQUILIBRAGE SELECT * FROM '  + GetTableDossier(CurBase, 'EQUILIBRAGE'));}
    MajProgress(5, 'Dossier : ' + CurBase, 'EQUILIBRAGE');
    Q := OpenSQL('SELECT MAX(TEQ_NUMEQUI) FROM ' + GetTableDossier(PoolBase, 'EQUILIBRAGE'), True);
    if not Q.EOF then s := Q.Fields[0].AsString;
    Ferme(Q);
    if Trim(s) = '' then s := '0';

    r := 'INSERT INTO ' + GetTableDossier(PoolBase, 'EQUILIBRAGE') + ' (TEQ_CLEDESTINATION,TEQ_CLESOURCE,TEQ_COTATION,TEQ_DATECREATION,TEQ_DEVISE,TEQ_DGENERAL,';
    r := r + 'TEQ_DNODOSSIER,TEQ_FICEXPORT,TEQ_FICVIR,TEQ_IMPRIME,TEQ_MONTANT,TEQ_MONTANTDEV,TEQ_NUMEQUI,TEQ_SBANQUE,';
    r := r + 'TEQ_SGENERAL,TEQ_SNODOSSIER,TEQ_SOCIETE,TEQ_USERCREATION,TEQ_VALIDBO) ';
    r := r + 'SELECT TEQ_CLEDESTINATION,TEQ_CLESOURCE,TEQ_COTATION,TEQ_DATECREATION,TEQ_DEVISE,TEQ_DGENERAL,';
    r := r + 'TEQ_DNODOSSIER,TEQ_FICEXPORT,TEQ_FICVIR,TEQ_IMPRIME,TEQ_MONTANT,TEQ_MONTANTDEV,TEQ_NUMEQUI + 1 + ' + s + ',TEQ_SBANQUE,';
    r := r + 'TEQ_SGENERAL,TEQ_SNODOSSIER,TEQ_SOCIETE,TEQ_USERCREATION,TEQ_VALIDBO FROM '  + GetTableDossier(CurBase, 'EQUILIBRAGE');
    ExecuteSQL(r);

    MajProgress(5, 'Dossier : ' + CurBase, 'TRECRITURE');
    ExecuteSQL('INSERT INTO ' + GetTableDossier(PoolBase, 'TRECRITURE') + ' (' + GetListeChamps('TRECRITURE') + ') SELECT ' + GetListeChamps('TRECRITURE') + ' FROM ' + GetTableDossier(CurBase, 'TRECRITURE'));

      {05/10/07 : Supppression des mouvements}
      MajProgress(5, 'Dossier : ' + CurBase, 'Suppression de l''�quilibrage');
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'EQUILIBRAGE'));
      MajProgress(5, 'Dossier : ' + CurBase, 'Suppression des Ventes d''OPCVM');
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'TRVENTEOPCVM'));
      MajProgress(5, 'Dossier : ' + CurBase, 'Suppression des OPCVM');
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'TROPCVM'));
      MajProgress(5, 'Dossier : ' + CurBase, 'Suppression op�rations � courts');
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'COURTSTERMES'));
      MajProgress(5, 'Dossier : ' + CurBase, 'Suppression des flux de tr�sorerie');
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'TRECRITURE'));

    CommitTrans;
    Result := True;
  except
    on E : Exception do begin
      RollBack;
      PGIError('Fusion des conditions (Base : ' + CurBase + ') interrompue :'#13#13 + E.Message);
      Result := False;
    end;
  end;

  {S'il n'y pas de probl�me pour la clef primaire car le Te_NoDossier doit �tre diff�rent dans chaque
   base apr�s l'ex�cution de MoulineBQCODE, il est possible de se retrouver avec des clefs d'op�ration
   et de valeur identique : cela risue de poser des probl�mes lors calculs de soldes

  recherche des cas ou la clef op�ration existe en plusieurs exemplaires ...
  Q := OpenSQL('SELECT COUNT (*) NOMBRE, TE_CLEOPERATION, TE_GENERAL FROM TRECRITURE  GROUP BY TE_CLEOPERATION, TE_GENERAL ORDER BY NOMBRE DESC', True);
}
end;

{Si le Pgi est en MultiSoc mais pas la Tr�so, on s'assure qu'il ne s'agit pas d'une
 erreur et on lance MoulineBQCODE
{---------------------------------------------------------------------------------------}
function TesteBaseTresoMulti : Boolean;
{---------------------------------------------------------------------------------------}
begin
  Result := False;

(*
// GP le 23/06/2008 : On cache le cash
  if EstMultiSoc and not EstTablePartagee('BANQUECP') then begin
    if PGIAsk(TraduireMemoire('Vous �tes en multi soci�t�s mais la table "BANQUECP" n''est pas partag�e.') + #13 +
              TraduireMemoire('Si vous poursuivez le traitement, cela signifie que vous renoncez � la ') + #13 +
              TraduireMemoire('possibilit� de faire du cash pooling sur ce dossier') + #13#13 +
              TraduireMemoire('Si vous souhaitez partager la table "BANQUECP", il faut mettre � jour') + #13 +
              TraduireMemoire('votre r�f�rentiel dans le PGIMajVer.') + #13#13 +
              TraduireMemoire('Souhaitez-vous abandonner ?'),
       TraduireMemoire('Mise � jour des structures')) = mrYes then
      Exit
    else
      SetParamSoc('SO_TRNOCASHPOOLING', True);
  end;
*)
(*
  if HShowMessage('0;Mise � jour des structures;' +
                  'Le PGI est param�tr� comme �tant en mode multi soci�t�s mais pas'#13 +
                  'la tr�sorerie. Pour activer le mode multi soci�t�s dans le module de'#13 +
                  'Tr�sorerie, il faut commencer par mettre � jour le param�tre soci�t� '#13 +
                  '"Base de la Tr�sorerie" par l''interm�diaire du PgiMajVer, '#13 +
                  'et ce pour toutes les bases � traiter.'#13#13 +
                  '�tes-vous s�r de vouloir poursuivre, sachant qu''il ne sera plus'#13 +
                  'possible ensuite de configurer cette soci�t� en mode multi soci�t�s ?;W;YN;N;N;', '', '') = mrYes then begin
  *)
    if HShowMessage('0;Mise � jour des structures; Il est souhaitable de faire une sauvegarde de la base'#13 +
                    ' avant de lancer le traitement.'#13#13'Souhaitez-vous abandonner ?;W;YN;Y;Y', '', '') = mrNo then begin
      {1/ Mise � jour des champs XXX_GENERAL}
      {2/ Mise � jour des champs NoDossier qui sont � "000000"}
      {3/ D�placement des dates de r�initialisation au 01/01/ au matin apr�s la fusion des tables TRECRITURE}
      Result := MoulineBQCODE('') and MajNoDossier('') and MajReInit;
      if Result then begin
        MajTableDossier(V_PGI.SchemaName);
        Result := True;
      end;
    end;
  //end;
end;

{---------------------------------------------------------------------------------------}
procedure CreeRibAttente;
{---------------------------------------------------------------------------------------}
begin
  if not ExisteSql('SELECT BQ_CODE FROM BANQUECP WHERE BQ_CODE = "' + CODEATTENTEBQ + '"') then
    {Cr�ation �ventuelle d'un compte d'attente pour les champs _general vide}
    ExecuteSql('INSERT INTO BANQUECP (BQ_CODE, BQ_GENERAL, BQ_BANQUE, BQ_AGENCE, BQ_LIBELLE, BQ_DEVISE, BQ_PAYS, ' +
               'BQ_SOCIETE, BQ_NODOSSIER, BQ_NATURECPTE, BQ_ETABBQ, BQ_GUICHET, BQ_NUMEROCOMPTE, BQ_CLERIB, '+
               'BQ_CODECIB, BQ_DOMICILIATION ) ' +
               'VALUES ("' + CODEATTENTEBQ + '", "' + CODEATTENTEBQ + '", "' + GetBanqueCourant + '", "' + GetAgenceCourant +
                             '", "' + CODEATTENTEBQ + '", "' + V_PGI.DevisePivot + '", "' +
                             CodePaysDeIso(GetParamSocSecur('SO_PAYSLOCALISATION', '')) + '", "' +
                             V_PGI.CodeSociete + '", "' + V_PGI.NoDossier + '", "' + tcb_Courant + '", "' +
                             CODEATTENTE5 + '", "' + CODEATTENTE5 + '", "' + CODEATTENTE5 + '", "53", "' +
                           GetCibCourant + '", "' + TraduireMemoire('Compte d''attente') + '")');
end;

{---------------------------------------------------------------------------------------}
procedure CreeInfosTitreCourant;
{---------------------------------------------------------------------------------------}
begin
  GetBanqueCourant;
  GetAgenceCourant;
  //GetBanqueTitre;
  //GetAgenceTitre;
end;

{Mise � jour de la table DOS_LIBELLE � partir de SO_LIBELLE
{---------------------------------------------------------------------------------------}
procedure MajTableDossier(CurBase : string);
{---------------------------------------------------------------------------------------}
begin
  ExecuteSQL('UPDATE DOSSIER SET DOS_LIBELLE = "' + GetParamsocDossierSecur('SO_LIBELLE', CurBase, CurBase) + '", ' +
                                 'DOS_SOCIETE = "' + GetParamsocDossierSecur('SO_SOCIETE', CurBase, CurBase) +
             '" WHERE DOS_NOMBASE = "' + CurBase + '"');
end;

{D�placement des �critures de r�initialisation au 01/01/XX au matin}
{---------------------------------------------------------------------------------------}
function MajReInit(Compte : string = '') : Boolean;
{---------------------------------------------------------------------------------------}
var
  n : Integer;
  G : string;
  D : string;
  M : string;
  S : string;
  T : TOB;
  C : TDateTime;
begin
  Result := True;
  C := Date;

  {D�placement des �critures de r�initialisation au 01/01/XX au matin}
  T := TOB.Create('JJJ', nil, -1);
  try
    S := 'SELECT TE_GENERAL, TE_DATEVALEUR, TE_SOLDEDEV, TE_SOLDEDEVVALEUR, TE_CLEOPERATION, TE_CLEVALEUR ' +
         'FROM TRECRITURE WHERE TE_CODEFLUX = "' + CODEREGULARIS + '" ';
    if Compte <> '' then S := S + 'AND TE_GENERAL = "' + Compte + '" ';
    S := S + 'ORDER BY TE_GENERAL, TE_DATEVALEUR';

    BeginTrans;
    try
      T.LoadDetailFromSQL(S);

      if T.Detail.Count > 0 then begin
        M := T.Detail[0].GetString('TE_GENERAL');
        C := T.Detail[0].GetDateTime('TE_DATEVALEUR');
      end;

      for n := 0 to T.Detail.Count - 1 do begin
        G := T.Detail[n].GetString('TE_GENERAL');
        D := UsDateTime(T.Detail[n].GetDateTime('TE_DATEVALEUR'));
        MajProgress(5, 'Gestion des soldes du compte : ' + G, 'MajReInit');
        {D�placement des �critures de r�initialisation au matin et calcul des nouveaux soldes}
        ExecuteSQL('UPDATE TRECRITURE SET ' +
                   'TE_SOLDEDEVVALEUR = TE_SOLDEDEVVALEUR - (SELECT SUM(TE_MONTANTDEV) FROM TRECRITURE WHERE TE_GENERAL = ' +
                   '"' + G + '" AND TE_DATEVALEUR = "' + D + '" ), ' +
                   'TE_SOLDEDEV = TE_SOLDEDEV - (SELECT SUM(TE_MONTANTDEV) FROM TRECRITURE WHERE TE_GENERAL = ' +
                   '"' + G + '" AND TE_DATECOMPTABLE = "' + D + '" ), ' +
                   'TE_CLEOPERATION = SUBSTRING(TE_CLEOPERATION, 1, 2)||"0000"||SUBSTRING(TE_CLEOPERATION, 7, 7), ' +
                   'TE_CLEVALEUR = SUBSTRING(TE_CLEVALEUR, 1, 2)||"0000"||SUBSTRING(TE_CLEVALEUR, 7, 7) ' +
                   'WHERE TE_CODEFLUX = "REI" AND TE_GENERAL = "' + G + '" AND TE_DATEVALEUR = "' + D + '"');


        if M = G then
          {On m�morise la date de r�initialisation la plus ancienne pour le compte courant}
          C := Min(C, T.Detail[n].GetDateTime('TE_DATEVALEUR'))
        {On a chang� de compte ...}
        else begin
          {... On recalcule des soldes sur le compte pr�c�dent}
          RecalculSolde(M, DateToStr(C), 0, True);
          M := G;
          C := T.Detail[n].GetDateTime('TE_DATEVALEUR');
        end;
      end;

      {Pour le dernier compte trait�, on recalcule les soldes}
      if T.Detail.Count > 0 then begin
        if M = G then
          {On m�morise la date de r�initialisation la plus ancienne pour le compte courant}
          C := Min(C, T.Detail[T.Detail.Count - 1].GetDateTime('TE_DATEVALEUR'));
        {R�cup�ration du nouveau solde de mill�sime}
        //R := GetSoldeMillesime(M, DateToStr(C), '', False, False);
        {... On recalcule des soldes sur le compte pr�c�dent}
        //RecalculSolde(M, DateToStr(C), R, False);
        RecalculSolde(M, DateToStr(C), 0, True);
      end;
      CommitTrans;
    except
      on E : Exception do begin
        Result := False;
        RollBack;
        PGIError('Une erreur est intervenue dans la r�initialisation des soldes avec le message :'#13#13 + E.Message); 
      end;
    end;
  finally
    FreeAndNil(T);
  end;
end;

{---------------------------------------------------------------------------------------}
function  GetListeChamps(NomTable : string) : string;
{---------------------------------------------------------------------------------------}
begin

  if NomTable = 'BANQUECP' then begin
    Result := ' BQ_ADRESSE1,BQ_ADRESSE2,BQ_ADRESSE3,BQ_AGENCE,BQ_BANQUE,BQ_CALENDRIER,BQ_CLERIB,BQ_CODE,BQ_CODEBIC,BQ_CODECIB,BQ_CODEIBAN,BQ_CODEPOSTAL,BQ_COMMENTAIRE,BQ_COMPTEFRAIS,BQ_CONTACT,BQ_CONVENTIONLCR,BQ_DATEDERNSOLDE,BQ_DELAIBAPLCR,';
    Result := Result + 'BQ_DELAILCR,BQ_DELAIPRELVACC,BQ_DELAIPRELVORD,BQ_DELAITRANSINT,BQ_DELAIVIRBRULANT,BQ_DELAIVIRCHAUD,BQ_DELAIVIRORD,BQ_DERNSOLDEDEV,BQ_DERNSOLDEFRS,BQ_DESTINATAIRE,BQ_DEVISE,BQ_DIVTERRIT,BQ_DOMICILIATION,BQ_ECHEREPLCR,BQ_ECHEREPPRELEV,BQ_ENCOURSLCR,';
    Result := Result + 'BQ_ETABBQ,BQ_FAX,BQ_GENERAL,BQ_GUICHET,BQ_GUIDECOMPATBLE,BQ_INDREMTRANS,BQ_JOURFERMETUE,BQ_LANGUE,BQ_LETTRECHQ,BQ_LETTRELCR,BQ_LETTREPRELV,BQ_LETTREVIR,BQ_LIBELLE,BQ_MULTIDEVISE,BQ_NATURECPTE,BQ_NODOSSIER,BQ_NUMEMETLCR,BQ_NUMEMETPRE,BQ_NUMEMETVIR,';
    Result := Result + 'BQ_NUMEROCOMPTE,BQ_PAYS,BQ_PLAFONDLCR,BQ_RAPPAUTOREL,BQ_RAPPROAUTOLCR,BQ_RELEVEETRANGER,BQ_REPBONAPAYER,BQ_REPIMPAYELCR,BQ_REPIMPAYEPRELV,BQ_REPLCR,BQ_REPLCRFOURN,BQ_REPPRELEV,BQ_REPRELEVE,BQ_REPVIR,BQ_SOCIETE,BQ_TELEPHONE,BQ_TELEX,';
    Result := Result + 'BQ_TYPEREMTRANS,BQ_VILLE ';
    if isMssql then Result := Result + ',BQ_BLOCNOTE ';
  end
  else if NomTable = 'CONDITIONDEC' then begin
    Result := ' TCN_AGENCE,TCN_AUTORISATION,TCN_BASECALCUL,TCN_CALCULSOLDE,TCN_CPFD,TCN_DATECONTRAT,TCN_FLUX,TCN_GENERAL,TCN_LIEAUTO,TCN_MAJOTAUX1,TCN_MAJOTAUX2,TCN_MAJOTAUX3,TCN_MULTAUX1,TCN_MULTAUX2,TCN_MULTAUX3,TCN_NBJOUR,TCN_PERIODE,TCN_PLAFOND1,';
    Result := Result + 'TCN_PLAFOND2,TCN_PLAFONDCPFD,TCN_PLAFONNEE,TCN_SOCIETE,TCN_SOLDEVALEUR,TCN_TAUXREF1,TCN_TAUXREF2,TCN_TAUXREF3,TCN_TYPECALCFRAIS,TCN_TYPEPREMIER ';
  end
  else if NomTable = 'CONDITIONEQUI' then begin
    Result := ' TCE_AGENCE,TCE_ARRONDI,TCE_CREDITMIN,TCE_DEBITMIN,TCE_GENERAL,TCE_SOCIETE,TCE_SOLDECONS,TCE_SOLDECRED,TCE_SOLDEDEB,TCE_TYPESOLDE ';
  end
  else if NomTable = 'CONDITIONFINPLAC' then begin
    Result := ' TCF_AGIOSDEDUIT,TCF_AGIOSPRECOMPTE,TCF_BANQUE,TCF_BASECALCUL,TCF_CONDITIONFP,TCF_DATEDEBUT,TCF_DATEFIN,TCF_GENERAL,TCF_MONTANT,TCF_NBJOURBANQUE,TCF_NBJOURENCAISS,TCF_NBJOURMINAGIOS,TCF_SOCIETE,TCF_TAUXFIXE,TCF_TAUXPRECOMPTE,TCF_TAUXVAR,';
    Result := Result + 'TCF_VALMAJORATION,TCF_VALMULTIPLE,TCF_VALTAUX ';
  end
  else if NomTable = 'CONDITIONVAL' then begin
    Result := ' TCV_BANQUE,TCV_CODECIB,TCV_COMMISSION1,TCV_COMMISSION2,TCV_COMMISSION3,TCV_GENERAL,TCV_NBJDEUXIEME,TCV_NBJPREMIER,TCV_SOCIETE,TCV_TYPEDEUXIEME,TCV_TYPEGLISSEMENT,TCV_TYPEPREMIER ';
  end
  else if NomTable = 'COURTSTERMES' then begin
    Result := ' TCT_ABREGE,TCT_AGENCECOMM,TCT_AGENCEDEBIT,TCT_AGENCEMEP,TCT_AGENCETOMBEE,TCT_AGIOSMONTANT,TCT_BASECALCUL,TCT_CATTRANSAC,TCT_CODETAUX,TCT_COMPTECOMM,TCT_COMPTEDEBIT,TCT_COMPTEMEP,TCT_COMPTETOMBEE,TCT_COMPTETR,TCT_CONTREPARTIETR,TCT_CORRDEBIT,';
    Result := Result + 'TCT_CORRMEP,TCT_CORRTOMBEE,TCT_COURSTAUX,TCT_CREATEUR,TCT_DATECREATION,TCT_DATEDENOUAGE,TCT_DATEDEPART,TCT_DATEFIN,TCT_DATEMODIFI,TCT_DATEOPERATION,TCT_DATEVBO,TCT_DEDUIT,TCT_DENOUEUR,TCT_DEVCTRVALEUR,TCT_DEVMONTANT,TCT_DEVPRIXUNIT,TCT_DOSSIER,';
    Result := Result + 'TCT_INTERLOCUTEUR,TCT_INTERMEDIAIRE,TCT_LETTRECONFIRM,TCT_LIBELLE,TCT_MAJORATION,TCT_MNTAGIOS,TCT_MNTMEP,TCT_MNTRESULTAT,TCT_MNTTOMBE,TCT_MONTANT,TCT_MONTANTCTRVAL,TCT_MULTIPLE,TCT_NBJOUR,TCT_NBJOURBANQUE,TCT_NODOSSIER,TCT_NOMBREPARTS,TCT_NUMTRANSAC,';
    Result := Result + 'TCT_OPERATEURCRE,TCT_OPERATEURMOD,TCT_OPERATEURVBO,TCT_ORDREPAIE,TCT_PORTEFEUILLE,TCT_PRECOMPTE,TCT_PREDEFINI,TCT_PRIXUNITAIRE,';
    Result := Result + 'TCT_RIBCOMPTECOMM,TCT_RIBCOMPTEDEBIT,TCT_RIBCOMPTEMEP,TCT_RIBCOMPTETOMBE,TCT_SOCIETE,TCT_STATUT,TCT_TAUXFIXE,TCT_TAUXPRECOMPTE,TCT_TAUXRESULTAT,TCT_TICKET,TCT_TRANSAC,TCT_UTILISATEUR,TCT_VALBO,TCT_VALTAUX ';
    if isMssql then Result := Result + ',TCT_BLOCNOTE ';
  end
  else if NomTable = 'TROPCVM' then begin
    Result := ' TOP_BASECALCUL,TOP_CODEOPCVM,TOP_COMACHAT,TOP_COMACHATDEV,TOP_COMPTA,TOP_COMVENTE,TOP_COMVENTEDEV,TOP_CONTREPARTIE,TOP_COTATIONACH,TOP_COTATIONVEN,TOP_DATEACHAT,TOP_DATECOMPTA,TOP_DATECREATION,TOP_DATEFIN,TOP_DATEMODIF,';
    Result := Result + 'TOP_DATEVBO,TOP_DEVISE,TOP_DOSSIER,TOP_FRAISACH,TOP_FRAISACHDEV,TOP_FRAISVEN,TOP_FRAISVENDEV,TOP_GENERAL,TOP_INTERMEDIAIRE,TOP_LETTRECONFIRM,TOP_LIBELLE,TOP_MONTANTACH,TOP_MONTANTACHDEV,TOP_MONTANTVEN,TOP_MONTANTVENDEV,';
    Result := Result + 'TOP_NBPARTACHETE,TOP_NBPARTVENDU,TOP_NODOSSIER,TOP_NUMOPCVM,TOP_ORDREPAIE,TOP_PORTEFEUILLE,TOP_PRIXUNITAIRE,TOP_REFERENCE,TOP_SOCIETE,TOP_STATUT,TOP_TICKET,TOP_TRANSACTION,TOP_TVAACHAT,TOP_TVAACHATDEV,TOP_TVAVENTE,';
    Result := Result + 'TOP_TVAVENTEDEV,TOP_TYPEVENTE,TOP_USERCOMPTA,TOP_USERCREATION,TOP_USERMODIF,TOP_USERVBO,TOP_VALBO ';
    if isMssql then Result := Result + ',TOP_BLOCNOTE ';
  end
  else if NomTable = 'TRECRITURE' then begin
    Result := ' TE_CLEOPERATION,TE_CLERIB,TE_CLEVALEUR,TE_CODEBANQUE,TE_CODECIB,TE_CODEFLUX,TE_CODEGUICHET,TE_COMMISSION,TE_CONTREPARTIETR,TE_COTATION,TE_CPNUMLIGNE,TE_DATECOMPTABLE,TE_DATECREATION,TE_DATEMODIF,TE_DATERAPPRO,TE_DATEVALEUR,';
    Result := Result + 'TE_DATEVALID,TE_DEVISE,TE_ETABLISSEMENT,TE_EXERCICE,TE_GENERAL,TE_IBAN,TE_JOURNAL,TE_LIBELLE,TE_MONTANT,TE_MONTANTDEV,TE_NATURE,TE_NODOSSIER,TE_NUMCOMPTE,TE_NUMECHE,TE_NUMEROPIECE,TE_NUMLIGNE,TE_NUMTRANSAC,';
    Result := Result + 'TE_QUALIFORIGINE,TE_REFINTERNE,TE_SOCIETE,TE_SOLDEDEV,TE_SOLDEDEVVALEUR,TE_USERCOMPTABLE,TE_USERCREATION,TE_USERMODIF,TE_USERVALID ';
  end;
end;

{26/06/07 : Mise � jour de la table CompteurTreso, car on a pu changer le champ SO_SOCIETE}
{---------------------------------------------------------------------------------------}
procedure MajCompteurTreso;
{---------------------------------------------------------------------------------------}
begin
  MajProgress(5, TraduireMemoire('Mise � jour des compteurs'), 'Maj Societe');
   ExecuteSQL('UPDATE COMPTEURTRESO SET TCP_SOCIETECOMPT = "' + V_PGI.CodeSociete + '" WHERE NOT (TCP_SOCIETECOMPT IN ("U@D", "U@Q"))');
  MajProgress(5, TraduireMemoire('Mise � jour des compteurs'), TraduireMemoire('Contr�le'));
  { faire des select sur les table mvt, pour voir ou en sont les num�ro de transaction
   OU
    Comparer toutes les tables compteur du regroupement pour reprendre la valeur la plus �lev�e}
end;

{01/08/07 : Purge des comptes sp�ciaux s'ils ne se justifient pas
{---------------------------------------------------------------------------------------}
procedure FinaliseMoulinette;
{---------------------------------------------------------------------------------------}
begin
  MajProgress(5, TraduireMemoire('Finalisations'), TraduireMemoire('Contr�les'));
  {1/ Suppression du compte d'attente s'il n'y a pas d'�criture orpheline}
  if not ExisteSQL('SELECT TE_GENERAL FROM TRECRITURE WHERE TE_GENERAL = "' + CODEATTENTEBQ + '"') then
    ExecuteSQL('DELETE FROM BANQUECP WHERE BQ_CODE = "' + CODEATTENTEBQ + '"');
  {2/ si on n'est pas en Cash pooling, suppression de banque, agence et cib de comptes courants}
  if not IsTresoMultiSoc then begin
    ExecuteSQL('DELETE FROM BANQUES WHERE PQ_BANQUE = "' + CODECOURANTS + '"');
    ExecuteSQL('DELETE FROM AGENCE WHERE TRA_AGENCE = "' + CODECOURANTS + '"');
    ExecuteSQL('DELETE FROM CIB WHERE TCI_CODECIB = "' + CODECIBCOURANT + '"');
  end;
end;

{Ajout de Banquecp dans la table de partage et maj de BQ_NODOSSIER et BQ_CODE
{---------------------------------------------------------------------------------------}
function PartageBanqueCP(CurBase : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  FNoDossier : string;
  Base       : string;
begin
  Result := False;
  try
    FNoDossier := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_NODOSSIER');
    Base := GetTablePartageLoc('BANQUECP', CurBase);
    {Si la table BANQUECP est vide, c'est qu'elle a d�j� �t� fusionn�es lors de la moulinette V8}
    if not ExisteSQL('SELECT BQ_CODE FROM ' + Base) then Base := 'BANQUECP';
    {Pour stocker le code afin de pouvoir mettre � jour les champs _GENERAL}
    ExecuteSQL('UPDATE ' + Base + ' SET BQ_REPIMPAYEPRELV = BQ_CODE ');

    {Si la base �tait ind�pendante du regroupement multi soci�t�s lorsque l'on est entr� en V8,
    on fusionne BANQUECP dans la base de r�f�rence}
    if Base <> 'BANQUECP' then begin
      ExecuteSQL('UPDATE ' + Base + ' SET ' +
                 'BQ_NODOSSIER = "' + FNoDossier + '", BQ_CODE = SUBSTRING(BQ_GENERAL, 1, 12)||"' + StrRight(FNoDossier, 5) + '" ' +
                 'WHERE (BQ_NODOSSIER = "" OR BQ_NODOSSIER IS NULL OR BQ_NODOSSIER = "' + CODEDOSSIERDEF + '")');
      ExecuteSQL('UPDATE ' + Base + ' SET BQ_NATURECPTE = "' + tcb_Bancaire + '" ' +
                 'WHERE (BQ_NATURECPTE <> "' + tcb_Courant + '" OR BQ_NATURECPTE = "" OR BQ_NATURECPTE IS NULL)');

      {Si on n'est pas sur la base de partage}
      if not ExisteSQL('SELECT ##TOP 1## DS_NOMBASE FROM DESHARE WHERE DS_NOMBASE = "' + CurBase + '"') then begin
        ExecuteSQL('INSERT INTO BANQUECP (' + GetListeChamps('BANQUECP') + ') SELECT ' + GetListeChamps('BANQUECP') + ' FROM ' + GetTablePartageLoc('BANQUECP', CurBase));
        ExecuteSQL('DELETE FROM ' + GetTablePartageLoc('BANQUECP', CurBase));
      end;
    end;
  except
    on E : Exception do begin
      PGIError(TraduireMemoire('Le Traitement de mise � jour des structures a �chou�.'#13 +
                               'Une erreur est intervenue lors du traitement de la table') + #13 +
                               CurBase + '.BANQUECP' + TraduireMemoire(', avec le message : ') + #13#13 +
                               E.Message);
      Exit;
    end;
  end;
  Result := True;
end;

{Maj la valeur des champs _GENERAL par BQ_CODE dans la Tr�so}
{---------------------------------------------------------------------------------------}
function MajBQCode(CurBase, ChpWhere : string) : Boolean;
{---------------------------------------------------------------------------------------}
var
  NomTable   : string;
  FNoDossier : string;

    {-------------------------------------------------------------------}
    procedure MajChpGeneral(Table, Chp : string);
    {-------------------------------------------------------------------}
    begin
      Movecur(False);
      NomTable := Table;

      {Pour les comptes/codes qui n'auraient pas pu �tre r�cup�r�s}
      ExecuteSQL('UPDATE ' + Table + ' SET ' + Chp + ' = "' + CODEATTENTEBQ + '" WHERE ' + CHP + ' = "" OR ' + CHP + ' IS NULL');
      Movecur(False);
      {Mise � jour du champ}
      ExecuteSQL('UPDATE ' + NomTable + ' SET ' + Chp + ' = (SELECT BQ_CODE FROM BANQUECP WHERE ' + ChpWhere + ' = ' +
                 Chp + ' AND BQ_NODOSSIER = "' + FNoDossier + '")');
    end;

var
  Q   : TQuery;
  Err : Integer;
  NOk : Integer;
  StE : string; 
begin
  Result := False;
  try
    FNoDossier := GetInfosFromDossier('DOS_NOMBASE', CurBase, 'DOS_NODOSSIER');
    if FNoDossier = '' then FNoDossier := V_PGI.NoDossier;

    {09/01/07 : FQ COMPTA 22146 : g�rer dans le mul de suppression des RUBRIQUES
    MajProgress(5, 'Dossier : ' + CurBase, 'NETTOYAGE DES RUBRIQUES');
    if ExisteSQL('SELECT RB_RUBRIQUE FROM ' + GetTableDossier(CurBase, 'RUBRIQUE') + ' R1 WHERE EXISTS (SELECT RB_RUBRIQUE FROM '+
               GetTableDossier(CurBase, 'RUBRIQUE') + ' R2 WHERE R1.RB_RUBRIQUE = R2.RB_RUBRIQUE AND R1.RB_NODOSSIER <> R2.RB_NODOSSIER)') then
      ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'RUBRIQUE') + ' WHERE RB_NODOSSIER = "" OR RB_NODOSSIER IS NULL');

    if (FNoDossier <> CODEDOSSIERDEF) and (FNoDossier <> '') then begin
      MajProgress(5, 'Dossier : ' + CurBase, 'RUBRIQUE');
      ExecuteSQL('UPDATE ' + GetTableDossier(CurBase, 'RUBRIQUE') + ' SET RB_NODOSSIER = "' + FNoDossier +
                 '" WHERE RB_NODOSSIER = "' + CODEDOSSIERDEF + '" OR RB_NODOSSIER = "" OR RB_NODOSSIER IS NULL');
    end;}

    {20/09/07 : FQ 10511 On nettoie les tables de conditions dont le compte n'existe plus}
    MajProgress(2, 'Dossier : ' + CurBase, TraduireMemoire('Nettoyage des conditions de valeur'));
    ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONVAL') + ' WHERE NOT (TCV_GENERAL IN (SELECT ' + ChpWhere + ' FROM BANQUECP WHERE BQ_NODOSSIER = "' + FNoDossier + '"))');
    MajProgress(2, 'Dossier : ' + CurBase, TraduireMemoire('Nettoyage des conditions de d�couvert'));
    ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONDEC') + ' WHERE NOT (TCN_GENERAL IN (SELECT ' + ChpWhere + ' FROM BANQUECP WHERE BQ_NODOSSIER = "' + FNoDossier + '"))');
    MajProgress(2, 'Dossier : ' + CurBase, TraduireMemoire('Nettoyage des conditions d''�quilibrage'));
    ExecuteSQL('DELETE FROM ' + GetTableDossier(CurBase, 'CONDITIONEQUI') + ' WHERE NOT (TCE_GENERAL IN (SELECT ' + ChpWhere + ' FROM BANQUECP WHERE BQ_NODOSSIER = "' + FNoDossier + '"))');

    MajProgress(5, 'Dossier : ' + CurBase, 'CONDITIONDEC');
    MajChpGeneral(GetTableDossier(CurBase, 'CONDITIONDEC'    ), 'TCN_GENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'CONDITIONEQUI');
    MajChpGeneral(GetTableDossier(CurBase, 'CONDITIONEQUI'   ), 'TCE_GENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'CONDITIONFINPLAC');
    MajChpGeneral(GetTableDossier(CurBase, 'CONDITIONFINPLAC'), 'TCF_GENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'CONDITIONVAL');
    MajChpGeneral(GetTableDossier(CurBase, 'CONDITIONVAL'    ), 'TCV_GENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'TRVENTEOPCVM');
    MajChpGeneral(GetTableDossier(CurBase, 'TRVENTEOPCVM'    ), 'TVE_GENERAL');

    MajProgress(5, 'Dossier : ' + CurBase, 'EQUILIBRAGE');
    MajChpGeneral(GetTableDossier(CurBase, 'EQUILIBRAGE'     ), 'TEQ_SGENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'EQUILIBRAGE');
    MajChpGeneral(GetTableDossier(CurBase, 'EQUILIBRAGE'     ), 'TEQ_DGENERAL');
    MajProgress(5, 'Dossier : ' + CurBase, 'COURTSTERMES');
    MajChpGeneral(GetTableDossier(CurBase, 'COURTSTERMES'    ), 'TCT_COMPTETR');
    MajProgress(5, 'Dossier : ' + CurBase, 'TRECRITURE');
    MajChpGeneral(GetTableDossier(CurBase, 'TRECRITURE'      ), 'TE_GENERAL'  );
    MajProgress(5, 'Dossier : ' + CurBase, 'TROPCVM');
    MajChpGeneral(GetTableDossier(CurBase, 'TROPCVM'         ), 'TOP_GENERAL' );

    {15/11/07 : Il arrive dans certains cas, malheureusement je n'arrive pas � reproduire que les
                champs _GENERAL soient vid�s. Je pense que le probl�me ne se pose uniquement lorsque
                l'on passe en cash pooling sur des dossiers sur lesquels l'on aurait pas suivi le
                processus dans le bon ordre, notamment le partage de BANQUECP apr�s la moulinette V8}
    Err := 0;
    NOk := 0;
    Q := OpenSQL('SELECT COUNT(TE_GENERAL) NBR FROM ' + GetTableDossier(CurBase, 'TRECRITURE') +
                 ' WHERE TE_GENERAL = "" OR TE_GENERAL IS NULL', True, -1, '', True);
    if not Q.EOF then Err := Q.FindField('NBR').AsInteger;
    Ferme(Q);

    Q := OpenSQL('SELECT COUNT(TE_GENERAL) NBR FROM ' + GetTableDossier(CurBase, 'TRECRITURE') +
                 ' WHERE TE_GENERAL <> "" AND TE_GENERAL IS NOT NULL', True, -1, '', True);
    if not Q.EOF then NOk := Q.FindField('NBR').AsInteger;
    Ferme(Q);

    if (NOk + Err) > 0 then begin
      if Err > 0 then begin
        {On a perdu tous les g�n�raux, on arr�te tout}
        if NOk = 0 then
          raise Exception.Create(TraduireMemoire('Le processus a �chou�. Il y a une incoh�rence sur les comptes bancaires.') + #13 +
                                 TraduireMemoire('Cela est s�rement d� � un partage trop tardif de "BANQUECP".') + #13#13 +
                                 TraduireMemoire('Il faudra probablement repartir d''une sauvegarde ant�rieure � la premi�re') + #13 +
                                 TraduireMemoire('entr�e dans la Tr�sorerie 2008.'))
        else begin
          Q := OpenSQL('SELECT MAX(TE_DATECOMPTABLE) DTC FROM ' + GetTableDossier(CurBase, 'TRECRITURE') +
                       ' WHERE TE_GENERAL = "" OR TE_GENERAL IS NULL', True, -1, '', True);
          try
            {Les �critures vides sont de vieilles �critures, on avertit mais on passe outre}
            if Q.FindField('DTC').AsDateTime < (Date + 500) then
              PGIBox(TraduireMemoire('Des �critures vieilles de plus de 18 mois �taient incoh�rentes et ont ') + #13 +
                     TraduireMemoire('perdu leur compte. Il faudra les supprimer pour ne pas fausser la Tr�sorerie.'),
                     TraduireMemoire('Mise � jour des comptes bancaires'))
            {Les �critures vides sont (relativement) r�centes et mais il y a moins de 10% d'erreurs, on propose de continuer}
            else if NOk > 9 * Err then begin
              if PGIAsk(TraduireMemoire('Il y a certaines incoh�rences sur les comptes bancaires : les �critures vont ') + #13 +
                        TraduireMemoire('perdre leur compte et seront inutilisables en Tr�sorerie.') + #13#13 +
                        TraduireMemoire('Souhaitez-vous abandonner le traitement ?'),
                        TraduireMemoire('Mise � jour des comptes bancaires')) = mrYes then
                raise Exception.Create(TraduireMemoire('Traitement abandonn�'));
            end
            else begin
              Err := Round(100 * Err / (Err + NOk));
              raise Exception.Create(TraduireMemoire('Le processus a �chou�. Il y a une incoh�rence sur certains comptes bancaires(') + IntToStr(Err) + ' %)');
            end;

          finally
            Ferme(Q);
          end;
        end;
      end;
    end;

  except
    on E : Exception do begin
      StE := TraduireMemoire('Le Traitement de mise � jour des structures a �chou�.') + #13 +
             TraduireMemoire('Une erreur est intervenue lors de la mise � jour des champs g�n�raux') + #13;
      if CurBase <> '' then StE := StE + TraduireMemoire('de la base "') + CurBase + '"';
      StE := StE + TraduireMemoire(', avec le message : ') + #13#13 + E.Message;
      PGIError(StE, TraduireMemoire('Mise � jour des comptes bancaires'));
      Exit;
    end;
  end;
  Result := True;
end;


end.

