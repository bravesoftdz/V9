{***********UNITE*************************************************
Auteur  ...... : JP
Cr�� le ...... : 06/10/2003
Modifi� le ... : 15/01/2004
Description .. : contenant les fonctions d'import et de formatage d'�criture
Suite ........ : dans la tr�so
Mots clefs ... : TRAVAILLERDATES;UPDATERAPPROCHEMENT;TRAVAILLERDONNEES;TRAVAILLERCOMPTA
*****************************************************************}
{-------------------------------------------------------------------------------------
    Version    |   Date   | Qui  |   Commentaires
--------------------------------------------------------------------------------------
 0.91            06/10/03    JP     Cr�ation de l'unit�
1.2X.001.001     25/03/04    JP     Mise en place de la synchronisation de l'�ch�ancier.
--------------------------------------------------------------------------------------}
unit ImportTreso;

interface

uses
  {$IFNDEF EAGLCLIENT}
  DBTables,
  {$ENDIF}
  Commun, UProcGen, Constantes, UObjGen, HEnt1, HCtrls, Classes, UTob, SysUtils, Controls;


{G�n�re la ligne treso en fonction de la ligne de compta}
function  TravaillerCompta(T : TOB; var UneEcriture : TREcritures; Obj : TObjBanquePrevi) : string;
{Traitements sur les donn�es int�gr�es dans la tables TRECRITURE : dates de valeur}
procedure TravaillerDonnees(ClauseWh : string);
{Maj des �critures de Treso int�gr�es en compta et modifi�es lors du rapprochement bancaire}
procedure UpdateRapprochement(T : TOB);

procedure TravaillerDates(ClauseWh : string);
procedure TravaillerFlux;

implementation

var
  ListeCompte   : TStringList;
  ListeDateDep  : TStringList;

{---------------------------------------------------------------------------------------}
procedure UpdateRapprochement(T : TOB);
{---------------------------------------------------------------------------------------}
var
  n   : Integer;
  NLI : string;
  TSC : string;
  SQL : string;
  s   : string;
  d   : TDate;
begin
  for n := 0 to T.Detail.Count - 1 do begin
      s   := T.Detail[n].GetValue('E_REFINTERNE');
      NLI := Copy(s, Pos('-', s) + 1, 1);
      TSC := Copy(s, 1, Pos('-', s) - 1);
      d   := StrToDate(VarToStr(T.Detail[n].GetValue('E_DATEPOINTAGE')));
    {Mise � jour de la date de pointage}
    SQL := 'UPDATE TRECRITURE SET TE_DATERAPPRO = "' + USDateTime(d) +
           '" WHERE TE_NUMTRANSAC = "' + TSC + '" AND TE_NUMLIGNE = ' + NLI;
    ExecuteSQL(SQL);
    {Mise � jour du champ E_TRESOSYNCHRO.}
    SQL := 'UPDATE ECRITURE SET E_TRESOSYNCHRO = "SYN" WHERE E_EXERCICE = "' + T.Detail[n].GetValue('E_EXERCICE') +
           '" AND E_JOURNAL = "' + T.Detail[n].GetValue('E_JOURNAL') +
           '" AND E_DATECOMPTABLE = "' + USDateTime(StrToDate(VarToStr(T.Detail[n].GetValue('E_DATECOMPTABLE')))) +
           '" AND E_QUALIFPIECE = "' + T.Detail[n].GetValue('E_QUALIFPIECE') +
           '" AND E_NUMEROPIECE = ' + VarToStr(T.Detail[n].GetValue('E_NUMEROPIECE')) +
           ' AND E_NUMLIGNE = ' + VarToStr(T.Detail[n].GetValue('E_NUMLIGNE')) +
           ' AND E_NUMECHE = ' + VarToStr(T.Detail[n].GetValue('E_NUMECHE'));
    ExecuteSQL(SQL);
  end;
end;

{---------------------------------------------------------------------------------------}
function TravaillerCompta(T : TOB; var UneEcriture : TREcritures; Obj : TObjBanquePrevi) : string;
{---------------------------------------------------------------------------------------}
var
  s : string;
  Nouveau : Boolean;

    {-----------------------------------------------------------------}
    procedure MajTresoSynchro;
    {-----------------------------------------------------------------}
    begin
      S := 'UPDATE ECRITURE SET E_TRESOSYNCHRO = "SYN", E_DATEMODIF = "' + USDateTime(Now) + '" ';
      S := S + 'WHERE' +
               ' E_JOURNAL = "'       + T.GetString('E_JOURNAL')     + '" AND' +
               ' E_EXERCICE = "'      + T.GetString('E_EXERCICE')    + '" AND' +
               ' E_DATECOMPTABLE = "' + UsDateTime(T.GetDateTime('E_DATECOMPTABLE')) + '" AND' +
               ' E_NUMEROPIECE = '    + T.GetString('E_NUMEROPIECE') + ' AND'  +
               ' E_NUMLIGNE = '       + T.GetString('E_NUMLIGNE')    + ' AND'  +
               ' E_NUMECHE = '        + T.GetString('E_NUMECHE')     + ' AND'  +
               ' E_QUALIFPIECE = "N"';
      ExecuteSql(S);
    end;

begin
  Result := '';
  {On ne traite pas les �critures pr�visionnelles que l'on ne peut rattacher � aucune banque}
  if (T.GetString('E_BANQUEPREVI') = '') and not Obj.IsValide(Obj.NatToIndice(T.GetString('G_NATUREGENE'))) then begin
    Result := T.GetString('E_GENERAL') + ';' + T.GetString('E_NUMEROPIECE') + ';' + T.GetString('E_NUMLIGNE') + ';' + TraduireMemoire('Banque pr�visionnelle non renseign�e') + ';';
    Exit;
  end;

  UneEcriture.TE_NUMTRANSAC     := TRANSACIMPORT + V_PGI.CodeSociete + T.GetString('E_JOURNAL') + IntToStr(T.GetInteger('E_NUMEROPIECE'));
  UneEcriture.TE_CODEFLUX       := CODEIMPORT; {JP 04/03/04}
  UneEcriture.TE_NUMLIGNE       := T.GetInteger('E_NUMLIGNE') + T.GetInteger('E_NUMECHE');
  UneEcriture.TE_NUMECHE        := T.GetInteger('E_NUMECHE');
  UneEcriture.TE_CPNUMLIGNE     := T.GetInteger('E_NUMLIGNE');
  UneEcriture.TE_CODECIB        := T.GetString('E_MODEPAIE');
  UneEcriture.TE_JOURNAL        := T.GetString('E_JOURNAL');
  UneEcriture.TE_NUMEROPIECE    := T.GetInteger('E_NUMEROPIECE');
  UneEcriture.TE_EXERCICE       := T.GetString('E_EXERCICE');
  UneEcriture.TE_REFINTERNE     := T.GetString('E_REFINTERNE');
  UneEcriture.TE_SOCIETE        := T.GetString('E_SOCIETE');
  UneEcriture.TE_ETABLISSEMENT  := T.GetString('E_ETABLISSEMENT');
  UneEcriture.TE_QUALIFORIGINE  := QUALIFCOMPTA;
  UneEcriture.TE_LIBELLE        := T.GetString('E_LIBELLE');
  {JP 22/03/04 : Les chaines commen�ant par "@@" ne sont pas compatible Oracle}
  UneEcriture.TE_USERCREATION   := CODETEMPO;
  {27/09/04 : FQ 10119 : Gestion des modes de paiement dans les rubriques}
  UneEcriture.TE_USERMODIF      := T.GetString('E_MODEPAIE');
  UneEcriture.TE_USERCOMPTABLE  := V_PGI.User;
  UneEcriture.TE_DEVISE         := T.GetString('E_DEVISE');
  {E_Couverture �tant un montant en valeur absolu ...}
  if (T.GetDouble('E_DEBIT') - T.GetDouble('E_CREDIT')) >= 0 then begin
    UneEcriture.TE_MONTANT        := T.GetDouble('E_DEBIT') - T.GetDouble('E_CREDIT') - T.GetDouble('E_COUVERTURE');
    UneEcriture.TE_MONTANTDEV     := T.GetDouble('E_DEBITDEV') - T.GetDouble('E_CREDITDEV') - T.GetDouble('E_COUVERTUREDEV');
  end else begin
    UneEcriture.TE_MONTANT        := T.GetDouble('E_DEBIT') - T.GetDouble('E_CREDIT') + T.GetDouble('E_COUVERTURE');
    UneEcriture.TE_MONTANTDEV     := T.GetDouble('E_DEBITDEV') - T.GetDouble('E_CREDITDEV') + T.GetDouble('E_COUVERTUREDEV');
  end;
  {La cotation en compta semble �tre l'inverse de la tr�so et de la chancellerie.
   Pour plus de s�curit�, on la recalcule, m�me si le champ est rarement utilis� !
   Dans les tables Chancell et Trecriture MntDev := Cotation * Mnt�}
  UneEcriture.TE_COTATION       := 1; {Par d�faut}
  if UneEcriture.TE_MONTANT <> 0 then
    UneEcriture.TE_COTATION     := UneEcriture.TE_MONTANTDEV / UneEcriture.TE_MONTANT;
  { JP 09/04/04 : Voil� quelque chose qui doit �tre un oubli, car la gestion en compta est diff�rente
                  de celle de la tr�so : dans cette derni�re, l'�criture est forc�ment dans la devise
                  du compte, alors qu'en compta la devise est au choix en fonction du journal de la pi�ce
  UneEcriture.TE_COTATION       := T.GetDouble('E_COTATION');}
  UneEcriture.TE_DATERAPPRO     := T.GetString('E_DATEPOINTAGE');

  {Dans le cas des �critures pr�visionnelles, la date d'op�ration n'est pas la date comptable mais la date
   d'�ch�ance. Dans un premier temps, on stocke la date d'�ch�ance dans TE_DATEVALID et on mettra � jour
   TE_DATECOMPTABLE (date d'op�ration) dans le travail sur les dates de valeur : ceci pour une raison, �
   savoir que les crit�res de s�lection reposent, entre autre, sur E_DATECOMPTABLE / TE_DATECOMPTABLE, donc
   si TE_DATECOMPTABLE �tait diff�rent de E_DATECOMPTABLE, certains traitements ne seraient pas correctement
   effectu�s, notamment le calcul des dates de valeur car ceratines �critures sont exclues par le filtrage sur
   la date d'op�ration : cf UObjGen.MajDeviseEtValeur }
  UneEcriture.TE_DATECOMPTABLE  := T.GetString('E_DATECOMPTABLE');
  {Ecritures bancaires ...}
  if Obj.NatToIndice(T.GetString('G_NATUREGENE')) = nc_BqCais then begin
    UneEcriture.TE_GENERAL        := T.GetString('E_GENERAL');
    UneEcriture.TE_CONTREPARTIETR := T.GetString('E_CONTREPARTIEGEN');
    UneEcriture.TE_NATURE         := na_Realise;
    UneEcriture.TE_DATEVALID      := DateToStr(iDate1900);
  end

  {... ou �ch�ancier}
  else begin
    if T.GetString('E_BANQUEPREVI') <> '' then
      UneEcriture.TE_GENERAL      := T.GetString('E_BANQUEPREVI')
    else
      UneEcriture.TE_GENERAL      := Obj.GetCompte(Obj.NatToIndice(T.GetString('G_NATUREGENE')));

    UneEcriture.TE_CONTREPARTIETR := T.GetString('E_GENERAL');
    UneEcriture.TE_NATURE         := na_Prevision;
    UneEcriture.TE_DATEVALID      := T.GetString('E_DATEECHEANCE');
  end;

  UneEcriture.TE_CODEBANQUE       := Obj.GetEtabBq (UneEcriture.TE_GENERAL);
  UneEcriture.TE_CODEGUICHET      := Obj.GetGuichet(UneEcriture.TE_GENERAL);
  UneEcriture.TE_NUMCOMPTE        := Obj.GetNumCpt (UneEcriture.TE_GENERAL);
  UneEcriture.TE_CLERIB           := Obj.GetCleRib (UneEcriture.TE_GENERAL);
  UneEcriture.TE_IBAN             := Obj.GetIban   (UneEcriture.TE_GENERAL);

  {Le code banque est n�cessaire en tr�so => on n'int�gre pas la ligne}
  if (UneEcriture.TE_CODEBANQUE = '') then begin
    Result := T.GetString('E_GENERAL') + ';' + T.GetString('E_NUMEROPIECE') + ';' + T.GetString('E_NUMLIGNE') + ';' + TraduireMemoire('Code banque non renseign�') + ';';
    Exit;
  end
  else if (UneEcriture.TE_CODECIB = '') then begin
    Result := T.GetString('E_GENERAL') + ';' + T.GetString('E_NUMEROPIECE') + ';' + T.GetString('E_NUMLIGNE') + ';' + TraduireMemoire('Mode de paiement non renseign�') + ';';
    Exit;
  end;

  UneEcriture.TE_DATECREATION := DateToStr(V_PGI.DateEntree);
  UneEcriture.TE_DATEMODIF    := DateToStr(iDate1900);
  UneEcriture.TE_DATEVALEUR   := DateToStr(iDate1900);

  {Le champ TE_USERVALID va servir temporairement de Champ SENS}
  if UneEcriture.TE_MONTANTDEV >= 0 then UneEcriture.TE_USERVALID := 'ENC'
                                    else UneEcriture.TE_USERVALID := 'DEC';

  {Si le montant est �gal � z�ro (on peut supposer que l'�criture vient d'�tre lettr�e) et qu'il s'agit d'une
   �criture de l'�ch�ancier ou bien si l'�criture est compl�tement lettr�e, on la supprime de la tr�sorerie.
   On fait aussi le test sur le montant en devise pour contourner d�ventuels probl�mes d'arrondi dans le cas
   d'un lettrage en devise}
  if ((UneEcriture.TE_MONTANT = 0) and (Obj.NatToIndice(T.GetString('G_NATUREGENE')) <> nc_BqCais)) or
     ((UneEcriture.TE_MONTANTDEV = 0) and (Obj.NatToIndice(T.GetString('G_NATUREGENE')) <> nc_BqCais)) or
     (T.GetString('E_ETATLETTRAGE') = 'TL') then begin
    ExecuteSQL('DELETE FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + UneEcriture.TE_NUMTRANSAC + '" ' +
                'AND TE_NUMLIGNE = ' + IntToStr(UneEcriture.TE_NUMLIGNE));

    {05/10/04 : Il faut mettre � jour la table ECRITURE ici, car si la TRECRITURE est supprim�e, le traitement
                dans UObjGen.MajDeviseEtValeur ne sera pas lanc� et E_TRESOSYNCHRO restera � "LET"}
    MajTresoSynchro;
  end
  else begin
    {L'�criture comptable a pu �tre cr�e puis modifi�e avant d'avoir �t� synchronis�e : on s'assure
     qu'elle existe bien}
    s := 'SELECT TE_NUMTRANSAC FROM TRECRITURE WHERE TE_NUMTRANSAC = "' + UneEcriture.TE_NUMTRANSAC + '" ' +
         'AND TE_NUMLIGNE     = '  + IntToStr(UneEcriture.TE_NUMLIGNE);

    Nouveau := (T.GetValue('E_SYNCHROTRESO') = 'CRE');

    if not Nouveau then begin
      Nouveau := not ExisteSQL(s);
      {05/10/04 : Si l'�criture existe et que l'on passe par ici, c'est qu'on est soit en lettrage partiel soit
                  en modification d'�criture bancaire : a priori TE_USERCREATION n'est plus � CODETEMPO, donc
                  comme ci-dessus, UObjGen.MajDeviseEtValeur ne sera pas �x�cut� sur l'�criture courante}
      if not Nouveau then
        MajTresoSynchro;
    end;
    {S'il s'agit d'une nouvelle �criture ou d'une �criture modifi�e en compta avant d'avoir �t� synchronis�e}
    EcritTREcriture(UneEcriture, Nouveau);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure RecalculerSoldes;
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  {Recalcul des soldes par compte bancaire}
  for n := 0 to ListeCompte.Count - 1 do
    RecalculSolde(ListeCompte[n], ListeDateDep[n], 0, True);
end;

{Calculs des dates de valeur, des codes CIB, des devises et des clefs
{---------------------------------------------------------------------------------------}
procedure TravaillerDates(ClauseWh : string);
{---------------------------------------------------------------------------------------}
var
  SQL : string;
  Q   : TQuery;
  Obj : TDateValeur;
begin
  {JP 22/03/04 : Les chaines commen�ant par "@@" ne sont pas compatible Oracle}
  SQL := 'SELECT TE_CODECIB MODEPAIE, TE_GENERAL GENERAL, TE_USERVALID SENS, BQ_BANQUE BANQUE FROM TRECRITURE ' +
         'LEFT JOIN BANQUECP ON BQ_GENERAL = TE_GENERAL ' +
         'WHERE TE_USERCREATION = "' + CODETEMPO + '" ' +
         'GROUP BY BQ_BANQUE, TE_CODECIB, TE_GENERAL, TE_USERVALID';
  Q := OpenSQL(SQL, True);
  try
    if not Q.EOF then begin
      Obj := TDateValeur.Create;
      try
        Obj.ModePaie.LoadDetailDB('', '', '', Q, False);
        Obj.RecupConditionValeur;
        MajDeviseEtValeur(Obj, ClauseWh, 'TE_USERCREATION')
      finally
        FreeAndNil(Obj);
      end;
    end;
  finally
    Ferme(Q);
  end;
end;

{JP 04/05/04 : FQ 10062 : gestion du sens : maintenant un m�me compte pourra �tre rattach�
               � deux rubriques en fonction de son sens (positif ou n�gatif)
{---------------------------------------------------------------------------------------}
procedure TravaillerFlux;
{---------------------------------------------------------------------------------------}
var
  Lib : string;
  Rub : string;
  Gen : string;
  Pai : string;
  SQL : string;
  Obj : TObjRubrique;
  Q   : TQuery;
  n   : Integer;
begin
  Obj := TObjRubrique.Create;
  try
  {27/09/04 : FQ 10119 : Gestion des modes de paiement dans les rubriques : on rajoute
              TE_USERMODIF (dans lequel est stock� le mode de paiement) dans la requ�te}
    Q := OpenSQL('SELECT DISTINCT TE_CONTREPARTIETR GENERAL, TE_USERMODIF AMODE FROM TRECRITURE WHERE ' +
                 'TE_CODEFLUX = "' + CODEIMPORT + '" GROUP BY TE_CONTREPARTIETR, TE_USERMODIF ' +
                 'ORDER BY TE_USERMODIF DESC', True);
    Obj.Generaux.LoadDetailDB('***', '', '', Q, False);
    Ferme(Q);
    {Construction de la liste de correspondance Comptes g�n�raux / Rubriques}
    Obj.SetListeCorrespondance;
    {27/09/04 : la TOB est Tri�e par mode de paiement. On commence par les modes de paiement
                non-vides => on traite les cas particuliers avant le cas g�n�ral}
    for n := 0 to Obj.Generaux.Detail.Count - 1 do begin
      Gen := Obj.Generaux.Detail[n].GetString('GENERAL');
      Pai := Obj.Generaux.Detail[n].GetString('AMODE'); {27/09/04}
      {R�cup�ration de la rubrique rattach�e au compte de contrepartie et au sens de l'�criture}
      Obj.GetCorrespondance(Gen, Rub, Lib, 'C', Pai);

      {JP 04/03/04 : Si la rubrique n'a pas �t� param�tr�e, on laisse IMP pour pouvoir relancer
                     le traitement (FQ 10017)}
      if (Trim(Rub) <> '') then begin
        SQL := 'UPDATE TRECRITURE SET TE_CODEFLUX = "' + Rub + '" WHERE TE_CONTREPARTIETR = "' + Gen +
               '" AND TE_CODEFLUX = "' + CODEIMPORT + '" AND TE_MONTANT >= 0';
        if Trim(Pai) <> '' then {27/09/04 : si le mode de paiment n'est pas vide}
          SQL :=  SQL + ' AND TE_USERMODIF = "' + Pai + '"';
        ExecuteSQL(SQL);
      end;

      {R�cup�ration de la rubrique rattach�e au compte de contrepartie d'une �criture n�gative}
      Obj.GetCorrespondance(Gen, Rub, Lib, 'D', Pai);
      {JP 04/03/04 : Si la rubrique n'a pas �t� param�tr�e, on laisse IMP pour pouvoir relancer
                     le traitement (FQ 10017)}
      if (Trim(Rub) = '') then Continue;
      SQL := 'UPDATE TRECRITURE SET TE_CODEFLUX = "' + Rub + '" WHERE TE_CONTREPARTIETR = "' + Gen +
             '" AND TE_CODEFLUX = "' + CODEIMPORT + '" AND TE_MONTANT < 0';
        if Trim(Pai) <> '' then {27/09/04 : si le mode de paiment n'est pas vide}
          SQL :=  SQL + ' AND TE_USERMODIF = "' + Pai + '"';
      ExecuteSQL(SQL);
    end;
  finally
    FreeAndNil(Obj);
  end;
end;

{---------------------------------------------------------------------------------------}
procedure TravaillerDonnees(ClauseWh : string);
{---------------------------------------------------------------------------------------}
var
  Cpt : TQuery;
begin
  {Constitution des listes des comptes g�n�raux et des dates de d�part pour le recalcul des soldes}
  ListeCompte  := TStringList.Create;
  ListeDateDep := TStringList.Create;
  try
    Cpt := OpenSql('SELECT DISTINCT TE_GENERAL , MIN (TE_DATECOMPTABLE) FROM TRECRITURE WHERE TE_CODEFLUX = "' +
                   CODEIMPORT + '" GROUP BY TE_GENERAL', True);
    while not Cpt.EOF do begin
      ListeCompte .Add(Cpt.Fields[0].AsString);
      ListeDateDep.Add(Cpt.Fields[1].AsString);
      Cpt.Next;
    end;
    Ferme(Cpt);
    {Gestion de la date de valeur/ codecib}
    TravaillerDates(ClauseWh);
    {Mise � jour des codes flux}
    TravaillerFlux;
    {Recalcul des soldes}
    RecalculerSoldes;
  finally
    FreeAndNil(ListeCompte);
    FreeAndNil(ListeDateDep);
  end;
end ;

end.
