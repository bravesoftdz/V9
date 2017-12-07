{***********UNITE*************************************************
Auteur  ...... : SBO
Cr�� le ...... : 01/12/2003
Modifi� le ... :   /  /
Description .. :
Suite ........ : Fonctions utilis�es dans la compta pour le synchro avec la
Suite ........ : tr�so
Mots clefs ... : TRESO;TRSYNCHRO;TRESOSYNCHRO
*****************************************************************}
unit ULibTrSynchro;

interface

uses
{$IFDEF EAGLCLIENT}
{$ELSE}
     DB,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
     SysUtils,    // IntToStr
     Utob,        // TOB
     Hent1,       // TActionFiche
     HMsgBox,     // PGIBox
     HCtrls,      // USDateTime
     SaisUtil,    // EstCptSyn
     uLibEcriture,// TInfoEcriture
     ParamSoc;    // GetParamSocSecur

// Fonctions de gestion du lien Compta-Tr�so version avec des TOBs
Function  ExisteReferencesTresoTOB( vEcr : TOB ) : Boolean ;
Function  DetruitReferencesTresoTOB( vEcr : TOB ) : Integer ;
Function  DetruitEcritureTresoTOB( vEcr : TOB ) : Integer ;
Function  MajTresoEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vInfo : TInfoEcriture = nil ) : Boolean ;
Function  MajTresoSupprEcritureTOB( vEcr : TOB ) : Boolean ;
{JP 17/11/04 : FQ 14972 : maj de E_TRESOSYNCHROo depuis modification des ent�tes de pi�ces,
               unit� dans laquelle on a aussi les Tob journaux et g�n�raux. Cette fonction
               effectue le m�me traitement que EstCptSyn mais avec des Tobs}
procedure MajE_TRESOSYNCHROTob(vEcr, vJal, vGen : TOB);
{JP 12/04/05 : Destruction d'une �criture � partir d'un RMVT}
procedure DetruitEcritureTresoRMVT(Mvt : RMVT);
{JP 12/04/05 : Renvoie vide si E_TRESOSYNCHRO n'a pas besoin d'�tre modifi�, sinon renvoie
               la partie de reuq�te concernant E_TRESOSYNCHRO}
function  MajETresoSynchro(Mvt : RMVT) : string;

// SBO 16/01/2005 : Equivalent EstCptSyn sans requ�te
function  EstCptSynTob( vTobEcr : Tob ; vInfo : TInfoEcriture = nil ) : Boolean ;

implementation

uses
  SaisComm,
  {$IFDEF NOVH}
  ULibCpContexte,
  {$ENDIF NOVH}
  Commun, UtilPgi, {EstMultiSoc}
  Constantes
  , Ent1
  , CPProcGen
  ;



{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 27/11/2003
Modifi� le ... :   /  /
Description .. :
Suite ........ : Traitement de maj de la table TRECRITURE de la tr�so � la
Suite ........ : cr�ation ou la modification d'une �criture compta
Mots clefs ... :
*****************************************************************}
Function  MajTresoEcritureTOB( vEcr : TOB ; vAction : TActionFiche ; vInfo : TInfoEcriture = nil  ) : Boolean ;
var lBoSyn : Boolean ;
begin

  Result := True ;

  // Traitements valables uniquement pour les �critures normales
  if ( vEcr = nil ) or ( vEcr.GetValue('E_QUALIFPIECE') <> 'N' ) or
     (( vEcr.GetString('E_ECRANOUVEAU') <> 'H' ) and
      ( vEcr.GetString('E_ECRANOUVEAU') <> 'N' )) or
     (( vEcr.GetString('E_ECRANOUVEAU') = 'H' ) and
      {$IFDEF NOVH}
      ((GetParamSocSecur('SO_EXOV8','') <> '') and (vEcr.GetDateTime('E_DATECOMPTABLE') < TCPContexte.GetCurrent.Exercice.ExoV8.Deb) )) then begin
      {$ELSE}
      ((GetParamSocSecur('SO_EXOV8','') <> '') and (vEcr.GetDateTime('E_DATECOMPTABLE') < VH^.ExoV8.Deb) )) then begin
      {$ENDIF NOVH}
    {JP 17/04/07 : c'est plus prudent !!}
    if Assigned(vEcr) then vEcr.PutValue('E_TRESOSYNCHRO', 'RIE');
    Exit;
  end;

  // ------------------
  // ---- CREATION ----
  // ------------------
  if (vAction = taCreat) or (vAction = taCreatOne) or (vAction = taCreatEnSerie) then
  begin

    // -> Notifier la cr�ation � la tr�so si la ligne porte sur un compte de banque
    if Assigned( vInfo )
      then lBoSyn := EstCptSynTob( vEcr, vInfo )
      else lBoSyn := EstCptSyn( vEcr.GetString('E_GENERAL'), vEcr.GetString('E_JOURNAL'), vEcr.GetString('E_NATUREPIECE') <> 'ECC' ) ;

    if lBoSyn then
      vEcr.PutValue('E_TRESOSYNCHRO', 'CRE' ) ;

  end ;

  // ----------------------
  // ---- MODIFICATION ----
  // ----------------------
  if (vAction = taModif) or (vAction = taModifEnSerie) then
  begin

    // Effacer la r�f�rence tr�so si elle existe
    if vEcr.GetValue('E_NUMLIGNE') = 1  then
      DetruitReferencesTresoTOB( vEcr ) ;

    // MAJ de champ de synchro tr�so : E_TRESOSYNCHRO
    if Assigned( vInfo )
      then lBoSyn := EstCptSynTob( vEcr, vInfo )
      else lBoSyn := EstCptSyn( vEcr.GetString('E_GENERAL'), vEcr.GetString('E_JOURNAL'), vEcr.GetString('E_NATUREPIECE') <> 'ECC' ) ;

    if lBoSyn
      then vEcr.PutValue('E_TRESOSYNCHRO', 'CRE' )
      else vEcr.PutValue('E_TRESOSYNCHRO', 'RIE' ) ; // On n'est plus sur un compte de banque...

  end ;

end ;

{SBO 01/12/03 : V�rifie une �criture de tr�so existe avec les r�f�rences de la pi�ce (quelque soit la ligne ou le compte...)
 JP 09/08/06 : gestion du multi soci�t�s en Tr�so  : je pars du principe que la pi�ce comptable
               appartient au dossier V_PGI.SchemaName !!}
Function  ExisteReferencesTresoTOB( vEcr : TOB ) : Boolean ;
var
  lStSQL : String ;
begin
  {La tr�sorerie ne figure que dans une base, param�tr�e dans le paramsoc SO_TRBASETRESO}
  lStSQL := 'SELECT TE_CPNUMLIGNE FROM ' + GetTableDossier(GetParamSocSecur('SO_TRBASETRESO', ''), 'TRECRITURE') + ' WHERE '
            {$IFDEF NOVH}
            + 'TE_NODOSSIER = "' + TCPContexte.GetCurrent.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ELSE}
            + 'TE_NODOSSIER = "' + VH^.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ENDIF NOVH}
            + 'TE_JOURNAL = "' + vEcr.GetString('E_JOURNAL') + '" AND '
            + 'TE_EXERCICE = "' + vEcr.GetString('E_EXERCICE') + '" AND '
            + 'TE_NUMEROPIECE=' + vEcr.GetString('E_NUMEROPIECE');
  if (vEcr.GetString('E_MODESAISIE') = 'BOR') or (vEcr.GetString('E_MODESAISIE') = 'LIB') then
    lStSQL := lStSQL + 'AND TE_NUMTRANSAC LIKE "' + TRANSACIMPORT + vEcr.GetString('E_SOCIETE')
                     + vEcr.GetString('E_JOURNAL') + Copy(vEcr.GetString('E_PERIODE'), 3, 4) + '%" ';
  Result := ExisteSQL( lStSQL ) ;
end ;


{SBO 01/12/03 : Supprime les �critures de tr�so r�f�ren�ant la pi�ce contenu l'ecriture est pass� en param�tre.
 JP 09/08/06 : gestion du multi soci�t�s en Tr�so  : je pars du principe que la pi�ce comptable
               appartient au dossier V_PGI.SchemaName !!
 JP 18/06/07 : FQ 20766 : ajout d'un espace avant le AND TE_NUMTRANSA}
Function  DetruitReferencesTresoTOB( vEcr : TOB ) : Integer ;
var lStSQL : String ;
begin
  {La tr�sorerie ne figure que dans une base, param�tr�e dans le paramsoc SO_TRBASETRESO}
  lStSQL := 'DELETE FROM ' + GetTableDossier(GetParamSocSecur('SO_TRBASETRESO', ''), 'TRECRITURE') + ' WHERE '
            {$IFDEF NOVH}
            + 'TE_NODOSSIER = "' + TCPContexte.GetCurrent.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ELSE}
            + 'TE_NODOSSIER = "' + VH^.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ENDIF NOVH}
            + 'TE_JOURNAL = "' + vEcr.GetString('E_JOURNAL') + '" AND '
            + 'TE_EXERCICE = "' + vEcr.GetString('E_EXERCICE') + '" AND '
            + 'TE_NUMEROPIECE=' + vEcr.GetString('E_NUMEROPIECE');
  if (vEcr.GetString('E_MODESAISIE') = 'BOR') or (vEcr.GetString('E_MODESAISIE') = 'LIB') then
    {18/06/07 : FQ 20766 : ajout d'un espace avant le AND TE_NUMTRANSA}
    lStSQL := lStSQL + ' AND TE_NUMTRANSAC LIKE "' + TRANSACIMPORT + vEcr.GetString('E_SOCIETE')
                     + vEcr.GetString('E_JOURNAL') + Copy(vEcr.GetString('E_PERIODE'), 3, 4) + '%" ';
  Result := ExecuteSQL( lStSQL ) ;
end ;


{SBO 28/11/03 : Supprime les �critures de tr�so r�f�ren�ant l'ecriture contenu dans la Tob
                Equivalent de DetruitEcritureTreso et Equivalent de DetruitEcritureTresoRMVT mais avec une TOB
 JP 09/08/06 : gestion du multi soci�t�s en Tr�so  : je pars du principe que la pi�ce comptable
               appartient au dossier V_PGI.SchemaName !!}
Function  DetruitEcritureTresoTOB( vEcr : TOB ) : Integer ;
var
  lStSQL : String ;
begin
  {La tr�sorerie ne figure que dans une base, param�tr�e dans le paramsoc SO_TRBASETRESO}
  lStSQL := 'DELETE FROM ' + GetTableDossier(GetParamSocSecur('SO_TRBASETRESO', ''), 'TRECRITURE') + ' WHERE '
            {$IFDEF NOVH}
            + 'TE_NODOSSIER = "' + TCPContexte.GetCurrent.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ELSE}
            + 'TE_NODOSSIER = "' + VH^.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ENDIF NOVH}
            + 'TE_JOURNAL="' + vEcr.GetString('E_JOURNAL') + '" AND '
            + 'TE_EXERCICE = "' + vEcr.GetString('E_EXERCICE') + '" AND '
            + 'TE_NUMEROPIECE=' + vEcr.GetString('E_NUMEROPIECE') + ' AND '
            + 'TE_CPNUMLIGNE=' + vEcr.GetString('E_NUMLIGNE')  + ' AND '
            + 'TE_NUMECHE=' + vEcr.GetString('E_NUMECHE')  + ' ' ;
  if (vEcr.GetString('E_MODESAISIE') = 'BOR') or (vEcr.GetString('E_MODESAISIE') = 'LIB') then
    lStSQL := lStSQL + 'AND TE_NUMTRANSAC LIKE "' + TRANSACIMPORT + vEcr.GetString('E_SOCIETE')
                     + vEcr.GetString('E_JOURNAL') + Copy(vEcr.GetString('E_PERIODE'), 3, 4) + '%" ';
  Result := ExecuteSQL( lStSQL ) ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : SBO
Cr�� le ...... : 27/11/2003
Modifi� le ... :   /  /
Description .. :
Suite ........ : Traitement de maj de la table TRECRITURE de la tr�so � la
Suite ........ : suppression d'une ecriture compta
Mots clefs ... :
*****************************************************************}
Function  MajTresoSupprEcritureTOB( vEcr : TOB ) : Boolean ;
begin

  Result := True ;

  // Traitements valables uniquement pour les �critures normales
  if ( vEcr = nil ) or ( vEcr.GetValue('E_QUALIFPIECE') <> 'N' ) or
     (( vEcr.GetString('E_ECRANOUVEAU') <> 'H' ) and
      ( vEcr.GetString('E_ECRANOUVEAU') <> 'N' )) or
     (( vEcr.GetString('E_ECRANOUVEAU') = 'H' ) and
      {$IFDEF NOVH}
      ((GetParamSocSecur('SO_EXOV8','') <> '') and (vEcr.GetDateTime('E_DATECOMPTABLE') < TCPContexte.GetCurrent.Exercice.ExoV8.Deb) )) then
      {$ELSE}
      ((GetParamSocSecur('SO_EXOV8','') <> '') and (vEcr.GetDateTime('E_DATECOMPTABLE') < VH^.ExoV8.Deb) )) then
      {$ENDIF NOVH}
    Exit ;

  // ---------------------
  // ---- SUPPRESSION ----
  // ---------------------
  // Effacer les r�f�rences tr�so poru toute la pi�ce comptable en 1 fois.
  // Traitement effectuer sur la premi�re ligne uniquement.
  if vEcr.GetValue('E_NUMLIGNE') = 1  then
      DetruitReferencesTresoTOB( vEcr ) ;

  // Remarque : le statut E_TRESOSYNCHRO de la pi�ce d�truite est plac� � RIE dans le module SupprEcr.pas

end ;

{JP 17/11/04 : FQ 14972 : maj de E_TRESOSYNCHROo depuis modification des ent�tes de pi�ces,
               unit� dans laquelle on a aussi les Tob journaux et g�n�raux. Cette fonction
               effectue le m�me traitement que EstCptSyn mais avec des Tobs}
{---------------------------------------------------------------------------------------}
procedure MajE_TRESOSYNCHROTob(vEcr, vJal, vGen : TOB);
{---------------------------------------------------------------------------------------}
var
  Cpte  : string;
  Jnal  : string;
  n     : Integer;

    {----------------------------------------------------------------------}
    function Synchronisable(NonEcc : Boolean) : Boolean;
    {----------------------------------------------------------------------}
    begin
      {La tob g�n�ral n'est pas forc�ment assign�e}
      if (vGen = nil) or (vJal = nil) then begin
        Result := EstCptSyn(Cpte, Jnal, NonEcc);
        Exit;
      end;

      {Est-ce un compte de banque}
      Result := vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'BQE'], True) <> nil;
      if Result then Exit;

      {S'agit-il d'un compte collectif / TIC / TID et d'un journal d'Achat / Vente / OD mais pas une �criture d'�cart de change}
      Result := ((vJal.FindFirst(['J_JOURNAL', 'J_NATUREJAL'], [Jnal, 'ACH'], True) <> nil) or
                 (vJal.FindFirst(['J_JOURNAL', 'J_NATUREJAL'], [Jnal, 'VTE'], True) <> nil) or
                 ((vJal.FindFirst(['J_JOURNAL', 'J_NATUREJAL'], [Jnal, 'OD'], True) <> nil) and NonEcc))
                and
                ((vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'COD'], True) <> nil) or
                 (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'COC'], True) <> nil) or
                 (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'COF'], True) <> nil) or
                 (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'COS'], True) <> nil) or
                 (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'TIC'], True) <> nil) or
                 (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'TID'], True) <> nil));
      if Result then Exit;

      {JP 09/08/06 : Gestion des comptes courants.
                     Il s'agit d'un compte divers figurant dans CLIENSSOC et d'un journal de banque ou d'OD param�tr�
                     Cette fonction �tant appel�e depuis la modification d'ent�te de pi�ce, je pars
                     du principe qu'il n'y a pas lieu de g�rer le dossier pour le ParamSoc et CLIENSSOC}
      Result := EstMultiSoc and
                (vGen.FindFirst(['G_GENERAL', 'G_NATUREGENE'], [Cpte, 'DIV'], True) <> nil) and
                ((vJal.FindFirst(['J_JOURNAL', 'J_NATUREJAL'], [Jnal, 'BQE'], True) <> nil) or
                 (vJal.FindFirst(['J_JOURNAL', 'J_NATUREJAL'], [Jnal, 'OD' ], True) <> nil)) and
                ExisteSQL('SELECT CLS_GENERAL FROM CLIENSSOC WHERE CLS_GENERAL = "' + Cpte + '"');
    end;
begin
  for n := 0 to vEcr.Detail.Count - 1 do begin
    Cpte := vEcr.Detail[n].GetString('E_GENERAL');
    Jnal := vEcr.Detail[n].GetString('E_JOURNAL');
    if Synchronisable(vEcr.Detail[n].GetString('E_NATUREPIECE') <> 'ECC') then
      vEcr.Detail[n].SetString('E_TRESOSYNCHRO', 'CRE')
    else
      vEcr.Detail[n].SetString('E_TRESOSYNCHRO', 'RIE');
  end;
end;

{JP 12/04/05 : Destruction d'une �criture � partir d'un RMVT
 JP 09/08/06 : gestion du multi soci�t�s en Tr�so  : je pars du principe que la pi�ce comptable
               appartient au dossier V_PGI.SchemaName !!
 JP 18/06/07 : FQ 20766 : ajout d'un espace avant le AND TE_NUMTRANSA}
{---------------------------------------------------------------------------------------}
procedure DetruitEcritureTresoRMVT(Mvt : RMVT);
{---------------------------------------------------------------------------------------}
var
  lStSQL : string;
  Period : Integer;
begin

  {La tr�sorerie ne figure que dans une base, param�tr�e dans le paramsoc SO_TRBASETRESO}
  lStSQL := 'DELETE FROM ' + GetTableDossier(GetParamSocSecur('SO_TRBASETRESO', ''), 'TRECRITURE') + ' WHERE '
            {$IFDEF NOVH}
            + 'TE_NODOSSIER = "' + TCPContexte.GetCurrent.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ELSE}
            + 'TE_NODOSSIER = "' + VH^.TresoNoDossier + '" AND ' {JP 09/08/06 : TRESO MS}
            {$ENDIF NOVH}
            + 'TE_JOURNAL = "' + Mvt.Jal + '" AND '
            + 'TE_EXERCICE = "' + Mvt.Exo + '" AND '
            + 'TE_NUMEROPIECE = ' + IntToStr(Mvt.Num) + ' AND '
            + 'TE_CPNUMLIGNE = ' + IntToStr(Mvt.NumLigne) + ' AND '
            + 'TE_NUMECHE = ' + IntToStr(Mvt.NumEche);
  if Mvt.Bordereau then begin
    Period := GetPeriode(Mvt.DateC);
    Period := Period - 200000; {pour supprimer le 2 et le 0 du d�but de p�riode}
    {18/06/07 : FQ 20766 : ajout d'un espace avant le AND TE_NUMTRANSA}
    lStSQL := lStSQL + ' AND TE_NUMTRANSAC LIKE "' + TRANSACIMPORT + V_PGI.CodeSociete + Mvt.Jal + IntToStr(Period) + '%" ';
  end;
  ExecuteSQL(lStSQL);
end;

{JP 12/04/05 : Renvoie vide si E_TRESOSYNCHRO n'a pas besoin d'�tre modifi�, sinon renvoie
               la partie de reuq�te concernant E_TRESOSYNCHRO
{---------------------------------------------------------------------------------------}
function MajETresoSynchro(Mvt : RMVT) : string;
{---------------------------------------------------------------------------------------}
begin
  Result := '';

  {$IFDEF NOVH}
  if (Mvt.Simul <> 'N') or ((GetParamSocSecur('SO_EXOV8','') <> '') and (Mvt.DateC < TCPContexte.GetCurrent.Exercice.ExoV8.Deb)) then
  {$ELSE}
  if (Mvt.Simul <> 'N') or ((GetParamSocSecur('SO_EXOV8','') <> '') and (Mvt.DateC < VH^.ExoV8.Deb)) then
  {$ENDIF NOVH}
    Exit ;
  {On exclut les �criture d'�-nouveaux typ�es "OAN"}
  if Mvt.ANouveau and
     ExisteSQL('SELECT E_ECRANOUVEAU FROM ECRITURE WHERE E_ECRANOUVEAU = "OAN" AND ' + WhereEcriture(tsGene, Mvt, True)) then
    Exit;

  {On regarde si le compte est synchronisable}
  if EstCptSyn( Mvt.General, Mvt.Jal, Mvt.Nature <> 'ECC' ) then begin
    Result := ', E_TRESOSYNCHRO = "' + ets_Nouveau + '" ';
    {JP 15/05/07 : FQ 10467 : destruction du flux Tr�so, pour que la Tr�so prenne en compte la modification}
    DetruitEcritureTresoRMVT(Mvt);
  end;
end;

{SBO 16/01/05 : Retourne True si le compte est synchronisable en Tr�sorerie.
                Equivalent de EstCptSyn sans requ�te (SaisUtil.pas)
 JP 09/08/06 : Gestion des comptes courants/groupes
{---------------------------------------------------------------------------------------}
function  EstCptSynTob( vTobEcr : Tob ; vInfo : TInfoEcriture = nil ) : Boolean ;
{---------------------------------------------------------------------------------------}
var lBoDetruireInfo : Boolean ;
begin

  result := False ;

  if not Assigned( vTobEcr ) then
    exit ;

  {JP 17/04/07 : C'est plus prudent}
  if vTobEcr.GetValue('E_QUALIFPIECE') <> 'N' then Exit;

  // Gestion auto du TInfoEcriture
  if vInfo = nil then
    begin
    vInfo           := TInfoEcriture.Create ;
    lBoDetruireInfo := true ;
    end
  else lBoDetruireInfo := false ;

  // Le compte est-il un compte de banque ?
  if vInfo.LoadCompte( vTobEcr.GetString('E_GENERAL') ) then
    result := vInfo.Compte.GetValue('G_NATUREGENE') = 'BQE' ;

  // Autres cas...
  if not result then
    begin
    result := ( vTobEcr.GetString('E_NATUREPIECE') <> 'ECC' ) and
              ( vInfo.LoadJournal( vTobEcr.GetString('E_JOURNAL') ) and ( pos( vInfo.Journal.GetValue('J_NATUREJAL'), 'ACH;VTE;OD') > 0 ) ) and
              ( vInfo.LoadCompte(  vTobEcr.GetString('E_GENERAL') ) and ( pos( vInfo.Compte.GetValue('G_NATUREGENE'), 'COD;COC;COF;COS;TIC;TID') > 0 ) ) ;
    end ;
  {JP 09/08/06 : Gestion des comptes courants}
  if not Result then
    Result := EstMultiSoc and
              (vInfo.Compte.GetValue('G_NATUREGENE') = 'DIV') and
              ((vInfo.Journal.GetValue('J_NATUREJAL') = 'BQE') or
               (vInfo.Journal.GetValue('J_NATUREJAL') = 'OD')) and
              ExisteSQL('SELECT CLS_GENERAL FROM ' + GetTableDossier(vInfo.Dossier, 'CLIENSSOC') +
                        ' WHERE CLS_GENERAL = "' + vTobEcr.GetString('E_GENERAL') + '"');

  // Lib�ratin du TInfoEcriture si gestion auto...
  if lBoDetruireInfo then vInfo.Free ;

end;


end.
