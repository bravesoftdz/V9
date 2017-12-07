unit URegenVues;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
{$IFDEF EAGLCLIENT}
     UtileAGL,uHttp,uWaini,
{$ELSE}
     DBGrids,
     DBCtrls,
     DB,
    {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     MajTable,MajHalleyUtil,
     HDB,

{$ENDIF}
  HEnt1,
  StdCtrls, Hctrls, ComCtrls, HStatus, ExtCtrls, HMsgBox,galPatience ;

procedure RegenereVues;

implementation

procedure RegenereVues;
var XX : TFPatience;
begin
	if PGIAsk('Ce traitement va reg�n�rer toutes les vues de la base de donn�es#13#10Confirmez-vous ?',Application.Title)=MrYes then
  begin
		XX := TFPatience.Create(Application.MainForm);
    try
      XX.Show;
      XX.Refresh;
      XX.SetTitre('Suppression des vues...');
      DBDeleteAllView (DBSOC,XX.texte,V_PGI.Driver);
      XX.SetTitre('Cr�ation des vues...');
      XX.Refresh;
  		DBCreateAllView (DBSOC,XX.texte,V_PGI.Driver);
    finally
      XX.Free;
    end;
  end;
end;

end.
