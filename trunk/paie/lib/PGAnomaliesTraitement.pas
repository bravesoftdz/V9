{***********UNITE*************************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Classe g�rant les anomalies r�sultant d'un traitement de masse
Suite ........ : afin de les afficher dans une list-box.
Suite ........ : Deux niveaux d'anomalie sont g�r�s pour chaque type :
Suite ........ : ERReur, INFOrmation et WARNing.
Mots clefs ... : ANOMALIE;TRAITEMENT;
*****************************************************************
}
Unit PGAnomaliesTraitement;

Interface

Uses StdCtrls,
     Classes,
     HEnt1;

// Niveaux d'anomalie
Const INFO1=0;
      INFO2=1;
      WARN1=2;
      WARN2=3;
      ERR1 =4;
      ERR2 =5;

Type
  TAnomalies = Class
  private
    Messages : Array[0..5] Of TStrings;
    Libs     : Array[0..5] Of String;
    DuplicateSymbols : Boolean;
    Underlined       : Boolean;
    CharUnderline	 : Char;
    InError			 : Boolean;
    procedure SetDuplicate  (Const Value : Boolean);	// Sauvegarde ou non les lignes doublonn�es
    procedure SetUnderlined (Const Value : Boolean);	// Soulignement des titres des niveaux
  public
     constructor Create;
     destructor  Destroy; override;
     procedure Clear;
     procedure Add (TypeAno : ShortInt; Text : String);
     procedure PutInList (List : TListBox);
     procedure ChangeLibAno (TypeAno : ShortInt; TextOfReplacement : String);
     property  SetDuplicateSymbols : Boolean read DuplicateSymbols write SetDuplicate;
     property  SetUnderlinedTitles : Boolean read Underlined       write SetUnderlined;
     property  IsErrorOccurred 	   : Boolean read InError;
  end;

Implementation

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Constructeur
Mots clefs ... :
*****************************************************************}
Constructor TAnomalies.Create;
var i : shortInt;
begin
     inherited;

     For i := 0 To ERR2 Do
     Begin
          Messages[i] := TStringList.Create;
     End;

     Libs[0] := TraduireMemoire('Informations :');
     Libs[1] := TraduireMemoire('Informations :');
     Libs[2] := TraduireMemoire('Erreurs de coh�rence :');
     Libs[3] := TraduireMemoire('Erreurs de coh�rence :');
     Libs[4] := TraduireMemoire('Erreurs graves :');
     Libs[5] := TraduireMemoire('Erreurs graves :');
     
     DuplicateSymbols := False;
     CharUnderline    := '-';
     InError		  := False;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Destructeur
Mots clefs ... :
*****************************************************************}
Destructor TAnomalies.Destroy;
var i : shortInt;
begin
     For i := 0 To ERR2 Do
     Begin
          If Assigned (Messages[i]) Then Messages[i].Free;
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Permet d'ajouter un message � la liste de cat�gorie TypeAno
Mots clefs ... :
*****************************************************************}
procedure TAnomalies.Add(TypeAno: ShortInt; Text: String);
begin
     If Assigned(Messages[TypeAno]) Then
     Begin
     	If (DuplicateSymbols) Or ((Not DuplicateSymbols) And (Messages[TypeAno].IndexOf(Text) = -1)) Then
     	Begin
           Messages[TypeAno].Add(Text);
           If (TypeAno=ERR1) Or (TypeAno=ERR2) Then InError := True;
        End;
    End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Vide les listes d'erreur, info, et warning
Mots clefs ... :
*****************************************************************}
procedure TAnomalies.Clear;
var i : shortInt;
begin
     For i := 0 To ERR2 Do
     Begin
          If Assigned (Messages[i]) Then Messages[i].Clear;
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Exporte les listes de messages dans une list-box.
Suite ........ : L'ordre est le suivant : Erreurs, Warnings puis Infos.
Suite ........ : Avant chaque type, le libell� est ins�r�.
Mots clefs ... :
*****************************************************************}
procedure TAnomalies.PutInList (List : TListBox);
var i,j : shortInt;
    s : String;
begin
     If List <> Nil Then
     Begin
          For i := ERR2 DownTo 0 Do
          Begin
               If (Assigned(Messages[i])) And (Messages[i].Count > 0) Then
               Begin
                    If List.Items.Count > 0 Then List.Items.Add('');
                    List.Items.Add(Libs[i]);
                    If Underlined Then 
                    Begin
                    	s := ''; 
                    	For j := 1 To Length(Libs[i]) Do s:=s+CharUnderline;
                    	List.Items.Add(s);
                    End;
                    List.Items.AddStrings(Messages[i]);
               End;
          End;

          If List.Items.Count = 0 Then List.Items.Add(TraduireMemoire('Aucune anomalie.'));
     End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 22/07/2007
Modifi� le ... :   /  /
Description .. : Permet de sp�cifier un libell� particulier � afficher dans
Suite ........ : la list-box pour un type donn�.
Mots clefs ... :
*****************************************************************}
procedure TAnomalies.ChangeLibAno(TypeAno: ShortInt; TextOfReplacement: String);
begin
     Libs[TypeAno] := TextOfReplacement;
end;

procedure TAnomalies.SetDuplicate (const Value : Boolean);
Begin
	DuplicateSymbols := Value;
End;

procedure TAnomalies.SetUnderlined (Const Value : Boolean);
Begin
	Underlined := Value;
End;

end.
