unit uLibValidation;

interface
uses
{$IFNDEF EAGLCLIENT}
  {$IFNDEF DBXPRESS}
     dbtables,
  {$ELSE}
     uDbxDataSet,
  {$ENDIF}
{$ENDIF}
  uTob;
  
// Nombre d'�critures maximum d'un compte que l'on peut valider � la fois
const MaxEcritureVal : integer = 9999;

// Fonctions / Procedures pour la validation
function  ValidationEcriture  ( Where : String ; Evenement : Integer = -1 ) : String;
procedure LogValidation       ( IDSessVal : Integer ; IDDebutVal : Integer ; IDFinVal : Integer ; Evenement : Integer);
function  LanceValideEcriture ( Where : String ; Var IDVal : Integer ) : Boolean;
function  ValideEcriture      ( Where : String ; Var IDVal : Integer ) : Boolean;
function  GetChecksumEcriture ( Where : String ) : String;
procedure SetJalEvent         ( ValSess : integer ; JalSess : integer);

// Fonctions / Procedures communes
function  GetNbEcriture ( Where : String ) : integer;

implementation  
uses
  HCtrls,
  HEnt1,
  HMsgBox,
  LicUtil,
  SysUtils;

{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /    
Description .. : Proc�dure permettant de valider les �critures et de tracer la 
Suite ........ : validation dans la table CPJALVALIDATION
Mots clefs ... : 
*****************************************************************}
function ValidationEcriture ( Where : String ; Evenement : Integer = -1 ) : String;
var
  IDSessVal  : integer;
  IDFinVal   : integer;
  IDDebutVal : integer;
  Q          : TQuery;
  SQL        : String;
  S1,S2      : String;
  Temp       : String;
begin
  Result := '';
  if Where = '' then Exit ;

  // Initialisation
  SQL := 'SELECT (MAX(CPV_IDFINVAL) + 1), (MAX(CPV_SESSION) + 1) FROM CPJALVALIDATION';
  Q   := OpenSQL(SQL,true);
  try       
     IDSessVal  := 0;
     IDDebutVal := 0;
     if not(Q.Eof) then
     begin
       IDDebutVal := Q.Fields[0].AsInteger;
       IDSessVal  := Q.Fields[1].AsInteger;
     end;
     // Cas ou il n'y a encore aucun enregistrement
     if IDDebutVal = 0 then IDDebutVal := 1;
     if IDSessVal  = 0 then IDSessVal  := 1;
  finally
     Ferme(Q);
  end;
                              
  // On valide les �critures
  IDFinVal := IDDebutVal ;
  if LanceValideEcriture(Where,IDFinVal) then
  begin
     // On enregistre la validation
     LogValidation(IDSessVal, IDDebutVal, IDFinVal - 1, Evenement);
     // On calcul le checksum
     Temp   := ' AND E_DOCID >= "' + IntToStr(IDDebutVal) + '" AND E_DOCID <= "' + IntToStr(IDFinVal) + '"';
     S1     := GetChecksumEcriture(Where + Temp + ' AND (E_GENERAL LIKE "1%" OR E_GENERAL LIKE "2%" OR E_GENERAL LIKE "3%" OR E_GENERAL LIKE "4%" OR E_GENERAL LIKE "5%")');
     S2     := GetChecksumEcriture(Where + Temp + ' AND (E_GENERAL LIKE "6%" OR E_GENERAL LIKE "7%")');
     Result := IntToStr(IDSessVal) + ';' + S1 + S2;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 23/08/2007
Modifi� le ... : 27/08/2007
Description .. : Fonction qui  qui segmente les ecritures si besoin et lance la 
Suite ........ : fonction de validation
Mots clefs ... : 
*****************************************************************}
function LanceValideEcriture ( Where : string ; var IDVal : integer ) : boolean;
var
  QJournal   : TQuery;
  QPeriode   : TQuery;
  SQL        : String; 
  Journal    : String;
  Periode    : String;
  NbEcriture : integer;
begin
  Result := false;
  NbEcriture := GetNbEcriture(Where + 'AND E_DOCID = 0 ');
  try
     BeginTrans();
     if NbEcriture > MaxEcritureVal then
     begin
        // Il y a trop d'ecritures � valider on segmente par journal
        SQL := 'SELECT DISTINCT(E_JOURNAL) ' +
               'FROM ECRITURE ' +
               'WHERE ' + Where + ' ' +
               'AND E_DOCID = 0 ' +
               'ORDER BY E_JOURNAL';
        QJournal := OpenSQL(SQL,true);
        while not(QJournal.EOF) do
        begin
           // Pour chaque Journal
           Journal := QJournal.FindField('E_JOURNAL').AsString ;
           NbEcriture := GetNbEcriture(Where + 'AND E_DOCID = 0 AND E_JOURNAL = "' + Journal + '"');
           if NbEcriture > MaxEcritureVal then
           begin
              // Il y a encore trop d'ecritures � valider on segmente par p�riode
              SQL := 'SELECT DISTINCT(E_PERIODE) ' +
                     'FROM ECRITURE ' +
                     'WHERE ' + Where + ' ' +
                     'AND E_DOCID = 0 AND E_JOURNAL = "' + Journal + '"' +
                     'ORDER BY E_PERIODE';
              QPeriode := OpenSQL(SQL,true);
              while not(QPeriode.EOF) do
              begin
                 Periode := QPeriode.FindField('E_PERIODE').AsString ;
                 Result := ValideEcriture(Where + 'AND E_DOCID = 0 AND E_JOURNAL = "' + Journal + '" AND E_PERIODE = "' + Periode + '"',IDVal);
                 if not(Result) then
                 begin
                    RollBack;
                    result := false;
                    Ferme(QPeriode);
                    Ferme(QJournal);
                    Exit;
                 end;
                 QPeriode.Next;
              end;
              Ferme(QPeriode);
           end
           else
           begin
              // Traitement
              Result := ValideEcriture(Where + 'AND E_DOCID = 0 AND E_JOURNAL = "' + Journal + '"',IDVal);
              if ( NbEcriture > 0 ) and not(Result) then
              begin             
                 RollBack;
                 result := false;
                 Ferme(QJournal);
                 Exit;
              end;
           end;
           QJournal.Next;
        end;
        Ferme(QJournal);
     end
     else
     begin
        // Traitement
        if ( NbEcriture > 0 ) then
           result := ValideEcriture(Where + 'AND E_DOCID = 0 ',IDVal);
     end;
     // Tout c'est bien d�roul� on valide la transaction
     CommitTrans
  except
     // Il y a eu un soucis
     on E: Exception do
     begin
        // On remet la BDD en �tat
        RollBack;
        if assigned(QPeriode) then Ferme(QPeriode);
        if assigned(QJournal) then Ferme(QJournal);
{$IFNDEF EAGLSERVER}
        PgiError('Erreur durant LanceValideEcriture : ' + E.Message );
{$ENDIF}
     end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /    
Description .. : Fonction qui valide les �critures (renseigne E_DOCID et 
Suite ........ : E_VALIDE)
Mots clefs ... : 
*****************************************************************}
function ValideEcriture ( Where : string ; var IDVal : integer ) : boolean;
var
  Q          : TQuery;
  SQL        : String;
begin
  result := false;               
  // Validation des �critures
  try     
     BeginTrans() ;
     SQL := 'SELECT E_JOURNAL, E_EXERCICE, E_DATECOMPTABLE, E_NUMEROPIECE, E_NUMLIGNE, E_NUMECHE, E_QUALIFPIECE, E_DOCID, E_VALIDE ' +
            'FROM ECRITURE ' +
            'WHERE ' + Where + ' ' +
            'ORDER BY E_JOURNAL, E_PERIODE, E_NUMEROPIECE, E_NUMLIGNE, E_NUMECHE';
     Q := OpenSql (SQL, false) ;
     while not Q.Eof do
     begin
        Q.Edit;
        Q.FindField('E_VALIDE').AsString := 'X';
        Q.FindField('E_DOCID').AsInteger := IDVal;
        Inc(IDVal);
        Q.Post;
        Q.Next;
     end;                                  
     CommitTrans();
     Result := true;
  except
     on E: Exception do
     begin
        RollBack ();
{$IFNDEF EAGLSERVER}
        PgiError ('Erreur Q.Post : ' + E.Message);
{$ENDIF}
     end;
  end;
  if Assigned(Q) then Ferme(Q);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 23/08/2007
Modifi� le ... :   /  /    
Description .. : Procedure enregistrant la validation dans la table 
Suite ........ : CPJALVALIDATION
Mots clefs ... : 
*****************************************************************}
procedure LogValidation( IDSessVal : integer ; IDDebutVal : integer ; IDFinVal : integer ; Evenement : integer);
var
  SQL : string;
begin
  SQL := 'INSERT INTO CPJALVALIDATION (CPV_SESSION, CPV_DATE, CPV_UTILISATEUR, CPV_IDDEBUTVAL, CPV_IDFINVAL, CPV_NUMEVENT) ' +
         'VALUES ( ' + IntToStr(IDSessVal) + ', "' + UsTime(now) + '", "' + V_PGI.User + '", ' + IntToStr(IDDebutVal) + ', ' + IntToStr(IDFinVal) + ', ' + IntToStr(Evenement) + ')';
  ExecuteSQL(SQL); 
end;


{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 12/09/2007
Modifi� le ... :   /  /    
Description .. : Permet de calculer un checksum significatif de la mani�re 
Suite ........ : suivante :
Suite ........ : C = Cryptage (Partie Enti�re (Somme des d�bits pour la 
Suite ........ : p�riode) + Nombre d'�critures pour la p�riode concern�e)
Mots clefs ... :  
*****************************************************************}
function  GetChecksumEcriture ( Where : String ) : String;
var
  SQL        : string;
  Q          : TQuery;
  nbEcriture : integer;
  SommeDebit : integer;
begin
  result     := '';
  SommeDebit := 0;
  SQL        := 'SELECT SUM(E_DEBIT) SOMME FROM ECRITURE WHERE ' + Where ;
  Q          := OpenSQL(SQL,false);
  try
     if not Q.Eof then
        SommeDebit := Q.FindField('SOMME').AsInteger;
  finally
     Ferme(Q);
  end;
  nbEcriture := GetNbEcriture(Where);
  Result     := CryptageSt(IntToStr(SommeDebit) + IntToStr(nbEcriture));
end;


{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 17/10/2007
Modifi� le ... :   /  /    
Description .. : Permet de mettre � jour le num�ro d'evenement dans un 
Suite ........ : enregistrement de la table CPJALVALIDATION
Mots clefs ... : 
*****************************************************************}
procedure SetJalEvent( ValSess : integer ; JalSess : integer);
var
  SQL : String;
  Q   : TQuery;
begin
  SQL := 'SELECT * FROM CPJALVALIDATION WHERE CPV_SESSION = ' + IntToStr(ValSess);
  Q := OpenSQL(SQL,false);
  try
     if not(Q.Eof) then
     begin 
        Q.Edit;
        Q.FindField('CPV_NUMEVENT').AsInteger := JalSess;
        Q.Post;
     end;
  finally
     Ferme(Q);
  end;    
end;
                               
{***********A.G.L.***********************************************
Auteur  ...... : Brice Verch�re
Cr�� le ...... : 27/08/2007
Modifi� le ... :   /  /    
Description .. : Fonction retournant le nombre d'ecriture correspondant � la 
Suite ........ : clause Where pass�e en param�tre
Mots clefs ... : 
*****************************************************************}
function  GetNbEcriture ( Where : String ) : integer;
var
  SQL : String;
  Q   : TQuery;
begin
  Result := 0;
  SQL := 'SELECT COUNT(*) NBECRITURES ' +
         'FROM ECRITURE ' +
         'WHERE ' + Where ;
  try
     Q := OpenSQL(SQL,true);
     if not(Q.Eof) then
        Result := Q.FindField('NBECRITURES').AsInteger;
  finally
    Ferme(Q);
  end;
end;


end.
