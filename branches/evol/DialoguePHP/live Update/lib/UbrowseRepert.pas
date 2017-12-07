unit UbrowseRepert;

interface

uses windows,shlObj, forms;

Function SHGetPathFromIDList (pidl : Integer; pszPath : String) : Integer;
        stdcall;external 'shell32.dll' name 'SHGetPathFromIDListA';

Function SHBrowseForFolder (lpBrowseInfo : BROWSEINFO) : Integer;
        pascal;external 'shell32.dll' name 'SHBrowseForFolderA';

function getrepert (TheForm : Tform) : string;

implementation

function getrepert (theForm : Tform): string;
var
    x : BROWSEINFO;
    Chemin : String;
    pidl : Integer;
    RetVal : Integer;
    p : Integer;
begin
	result := '';
  FillChar(x, SizeOf(x), 0);
  x.hwndOwner  := Tform(TheForm).Handle; //Handle de l'objet de votre fiche
  x.pidlRoot := 0;
  x.lpszTitle  := 'Sélectionnez un répertoire';
  x.ulFlags := 1;

  pidl := SHBrowseForFolder(x);

  Chemin := StringOfChar(Chr(0),512);
  RetVal := SHGetPathFromIDList(pidl, Chemin);
  If RetVal <> 0 Then
  begin
		p := Pos(Chr(0),Chemin);
    result := Copy(Chemin,1,p);
  end;
end;

end.
 