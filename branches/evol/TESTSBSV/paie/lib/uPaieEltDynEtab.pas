{***********UNITE*************************************************
Auteur  ...... : FC
Cr�� le ...... : 28/02/2007
Modifi� le ... :   /  /
Description .. : Unit� qui permet de r�cup�rer la tob contenant les �l�ments dynamiques Etablissement
Mots clefs ... :
*****************************************************************}
unit uPaieEltDynEtab;

interface

uses CLasses,
  SysUtils,
{$IFNDEF eaglclient}
  db,
{$IFNDEF DBXPRESS}dbTables, {$ELSE}uDbxDataSet, {$ENDIF}
{$ENDIF}
  hctrls,
  UTob;

function initTOB_EltDynEtab(Etab: string; DateFin: TDateTime): Tob;
function TOB_EltDynEtab(): Tob;
procedure Nettoyage_EltDynEtab();

implementation

var
  LocaleTob: Tob;
  DateModif: TDateTime;

function initTOB_EltDynEtab(Etab: string; DateFin: TDateTime): Tob;
var q: tquery;
  t: tob;
  tfind: tob;
  st: string;
begin

  t := nil;
     // Si premier appel
  if not assigned(LocaleTob) then
  begin
    LocaleTob := Tob.Create('EltDynEtab', nil, -1);
    DateModif := Now ;
{Flux optimis�
        Q := OpenSql('SELECT * FROM ELTNATIONDOS '
          + ' WHERE PED_TYPENIVEAU="ETB"'
          + ' AND PED_VALEURNIVEAU="' + Etab + '"'
          + ' AND PED_DATEVALIDITE<="' + UsTime(DateFin) + '"'
        if not q.eof then LocaleTob.LoadDetailDb('ELTNATIONDOS','','',q,False) ;
        Ferme(q) ;
}
    st := 'SELECT * FROM ELTNATIONDOS '
      + ' WHERE PED_TYPENIVEAU="ETB"'
      + ' AND PED_VALEURNIVEAU="' + Etab + '"'
      + ' AND PED_DATEVALIDITE<="' + UsTime(DateFin) + '"'
      + ' ORDER BY PED_CODEELT,PED_DATEVALIDITE';
    LocaleTob.LoadDetailDbFromSQL('ELTNATIONDOS', st);
  end
  else
  begin
    q := opensql('SELECT * FROM ELTNATIONDOS'
      + ' WHERE PED_TYPENIVEAU = "ETB" '
      + ' AND PED_VALEURNIVEAU="' + Etab + '"'
      + ' AND PED_DATEVALIDITE<="' + UsTime(DateFin) + '"'
      + ' AND PED_DATEMODIF>="' + UsTime(DateModif) + '"'
      + ' ORDER BY PED_CODEELT,PED_DATEVALIDITE', True);
    DateModif := Now;
    if not q.eof then
    begin
      t := tob.create('', nil, -1);
      T.LoadDetailDB('ELTNATIONDOS', '', '', q, false);

           // des variables ont �t� modifi�es ??
      while t.detail.count > 0 do
      begin
        tfind := LocaleTob.FindFirst(['PED_CODEELT', 'PED_DATEVALIDITE'], [t.detail[0].getvalue('PED_CODEELT'), t.detail[0].getvalue('PED_DATEVALIDITE')], false);
        if assigned(tfind) then FreeAndNil(tfind);
        t.Detail[0].ChangeParent(LocaleTob, -1);
      end;

           // Tri !!
      LocaleTob.Detail.Sort('PED_CODEELT;PED_DATEVALIDITE'); //PT1
      FreeAndNil(t);
    end;
    Ferme(q);
  end;
  Result := LocaleTob;
end;

// Fonction qui renvoie dans une TOB, la liste des �l�ments dynamiques d'un �tablissement

function TOB_EltDynEtab(): Tob;
begin
  Result := LocaleTob;
end;

procedure Init();
begin
  LocaleTob := nil;
end;

procedure Nettoyage_EltDynEtab();
begin
  if Assigned(LocaleTob) then FreeAndNil(LocaleTob);
end;


initialization
  init();

finalization
  Nettoyage_EltDynEtab();
end.

