library SeriaServeurLSE;

{ Remarque importante concernant la gestion de m�moire de DLL : ShareMem doit
  �tre la premi�re unit� de la clause USES de votre biblioth�que ET de votre projet 
  (s�lectionnez Projet-Voir source) si votre DLL exporte des proc�dures ou des
  fonctions qui passent des cha�nes en tant que param�tres ou r�sultats de fonction.
  Cela s'applique � toutes les cha�nes pass�es de et vers votre DLL --m�me celles
  qui sont imbriqu�es dans des enregistrements et classes. ShareMem est l'unit� 
  d'interface pour le gestionnaire de m�moire partag�e BORLNDMM.DLL, qui doit
  �tre d�ploy� avec vos DLL. Pour �viter d'utiliser BORLNDMM.DLL, passez les 
  informations de cha�nes avec des param�tres PChar ou ShortString. }

uses
  SysUtils,
  Classes,
  FicheVerrouClient in '..\lib\FicheVerrouClient.pas' {Fverrou},
  UAccesDatabase in '..\lib\UAccesDatabase.pas';

{$R *.res}
	procedure SetVerrouClient (Server,DataBase ,CodeClient : PChar);  stdcall;
  var XX : TFverrou;
  begin
  	if not FindTiers (Server,DataBase, CodeClient) then Exit;
  	XX := TFverrou.Create(nil);
    XX.Server := Server;
    XX.client := CodeClient;
    XX.Database := DataBase;
    TRY
    	XX.ShowModal;
    FINALLY
    	XX.Free;
    END;
  end;

  exports
  SetVerrouClient index 0 name 'SetVerrouClient';

begin
end.
 