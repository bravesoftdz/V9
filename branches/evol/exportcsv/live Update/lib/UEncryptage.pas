unit UEncryptage;

interface
const
	decalage = 70;

function crypte(text:string):string;          //Fonction pour crypter la chaine
function decrypte(text:string):string;       //Fonction pour décrypter la chaine

implementation

function crypte(text:string):string;          //Fonction pour crypter la chaine
var pos:integer;
		text1:string;
begin
	result := '';
	if text = '' then exit;
  text1 := text;
  for pos := 1 to length(text1) do
  	text1[pos] := chr(ord(text1[pos]) + decalage);        //crypte la chaine
  crypte := text1;
end;

function decrypte(text:string):string;       //Fonction pour décrypter la chaine
var pos:integer;
  	text1:string;
begin
	result := '';
	if text = '' then exit;
  text1 := text;
  for pos := 1 to length(text1) do
  	text1[pos] := chr(ord(text1[pos]) - decalage);             //decrypte la chaine
  result := text1;
end;

end.

 