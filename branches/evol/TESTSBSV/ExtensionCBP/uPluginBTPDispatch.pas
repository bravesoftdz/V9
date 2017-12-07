unit uPluginBTPDispatch;

interface

uses
  uTOB;

function Dispatch(Action, Param:string; RequestTOB:TOB):TOB ; stdcall;

implementation

uses
  Sysutils,
  BTPGetStructure,
  BTPGetVersions,
  uBTPVerrouilleDossier,
  uBTPGetDocument;

const
  // Mettre ici le nom de votre Dll de plugin
  PLUGIN_NAME = 'PluginBTPS';
  PLUGIN_VERSION = '7.3.9.720';

//Fonction de dispatch du plugin
function Dispatch(Action, Param:string; RequestTOB:TOB):TOB ; stdcall;
begin
  // Cr�er syst�matiquement la tob r�sultat
  Result := TOB.Create ('Out', nil, -1);
  try
    // Ajouter syst�matiquement ce champ afin de rendre les tests g�n�riques
    Result.AddChampSupValeur('ERROR', '');

    if Action = 'GetStructure' then
    begin
    	// -----------
    	if (not RequestTOB.fieldExists('SQL')) then
      begin
      	result.putValue ('ERROR',PLUGIN_NAME+'.'+Action+' requ�te d''entr�e non d�finie');
      end else if RequestTOB.getValue('SQL')='' then
      begin
      	result.putValue ('ERROR',PLUGIN_NAME+'.'+Action+' requ�te d''entr�e Vide');
      end else begin
    		BTPGetFieldStructure (RequestTOB.getValue('SQL'),result);
      end;
      // -----------
    end else if Action = 'ISBaseDisponible' then
    begin
      ISBaseDisponible (result);
    end else if Action = 'GetVersionRef' then
    begin
    	BTPGetVersionRef (Result);
    end else if Action = 'GetDocument' then
    begin
    	if (RequestTOB.fieldExists('CLEDOC')) and (RequestTOB.GetString('CLEDOC')<>'') then
      begin
    		BTPGetDocument (RequestTOB,Result);
      end else
      begin
      	result.putValue ('ERROR',PLUGIN_NAME+'.'+Action+' DOCUMENT non d�finie');
      end;
    end else
    begin
      //Provoquera le soul�vement d'une exception par le client
      Result.Free ;
      Result := nil;
    end;
  except
    Result.free;
    //Toujours remonter les erreurs au serveur
    raise;
  end;
end;

end.
