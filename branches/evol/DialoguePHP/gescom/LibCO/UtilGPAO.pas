unit UtilGPAO;

interface

  function GetNbEnregInFile (Fichier : String) : integer;

implementation

{***********A.G.L.***********************************************
Auteur  ...... : Y. Peuillon
Cr�� le ...... : 05/11/2003
Modifi� le ... : 26/11/2003
Description .. : Renvoi le nombre d'enregistrement du fichier pass� en
Suite ........ : param�tre
Mots clefs ... : 
*****************************************************************}
function GetNbEnregInFile (Fichier : String) : integer;
var
  FileIn : TextFile;
  Cpt : integer;
begin
  Cpt := 0;
  // Ouverture du fichier en entr�e
  AssignFile(FileIn, Fichier);
  Reset( FileIn );
  try
    // Parcours du fichier en entr�e
    while not SeekEof(FileIn) do
    begin
      Readln( FileIn );
      Inc( Cpt );
    end;
  finally
    CloseFile( FileIn);
  end;
  Result := Cpt;
end;

end.
