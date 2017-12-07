(**************************** PROGRAMME *********************************
Auteur  ...... : Laurent Ab�lard
Cr�� le ...... : 20/11/2007
Modifi� le ... : 23/01/2008
Description .. : Incr�mentation du Num�ro de Build d'un fichier de
Suite ........ : ressource .res
Suite ........ : IncBuild.exe NomFichier.res
Mots clefs ... : Ressource, .res, .rc, Build
************************************************************************)
Program IncBuild;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows,
  Classes,
  StrUtils,
  IncBuildSources in '..\LIB\IncBuildSources.pas';

(******************************************************************
  Conversion d'une chaine ANSI dans le Code de Page OEM
******************************************************************)
Function StrAnsiToOEM( Const Texte : String ) : String;
Var
  TailleChaine : Integer;

Begin
  TailleChaine := Length(Texte);
  SetLength( Result, TailleChaine );
  AnsiToOemBuff( @Texte[1], @Result[1], TailleChaine );
End;


(******************************************************************
  Procedure de sortie standard dans le Code Page OEM
******************************************************************)
Procedure Afficher( Const Texte : String );
Begin
  Writeln( 'IncBuild : ' + StrAnsiToOEM( Texte ) );
End;

(******************************************************************
  Point d'entr�e du programme principal
******************************************************************)
Var
  TypeValeurForcee : BUILD_OU_VERSION;
  TypeParametre    : String;
  ValeurForcee     : String;
  NomFichier       : String;
  Parametre        : String;
  CheminXml        : String;
  Resultat         : String;
  VersionProduit   : String;
  i                : Cardinal;

Begin

  ExitCode := 0;

  NomFichier := ParamStr(1);
  If NomFichier = '' Then
  Begin
    Afficher( 'Usage : ' );
    Afficher( ExtractFileName( ParamStr(0) ) + ' Nom_de_fichier.res [-x:Chemin_fichier_log.xml] '
                                             + '[-v:Num�ro_de_Version_Forc�e | -b:Num�ro_de_Build_Forc�e]' );
    Afficher( 'O� le num�ro de version doit avoir la forme Majeur.Mineure.Release.build' );
    Afficher( 'Retourne 1 en cas d''erreur sinon 0.' );
    Exit;
  End;

    //** R�cup�ration des param�tres **//
  TypeValeurForcee := BUILD_FORCE;
  ValeurForcee     := '';
  CheminXml        := '';
  VersionProduit    :='';

  For i := 2 To ParamCount() Do
  Begin
    If Length(ParamStr(i)) > 3 Then
    Begin

      TypeParametre := LeftStr( ParamStr(i), 3 );
      Parametre     := AnsiMidStr( ParamStr(i), 4, 10000 );

        //** Param�tre du Chemin d'un Fichier de R�sultat en XML **//
      If TypeParametre = '-x:' Then
      Begin
        CheminXml := Parametre;
      End

        //** Param�tre Num�ro de Build Forc� **//
      Else If TypeParametre = '-b:' Then
      Begin

        If ValeurForcee <> '' Then
        Begin
          Afficher( 'Vous ne pouvez pas sp�cifier un Num�ro de Build Forc� en m�me temps qu''un Num�ro de Version Forc�e.' );
          Exit;
        End;

        TypeValeurForcee := BUILD_FORCE;
        ValeurForcee     := Parametre;

      End

        //** Param�tre Num�ro de Version Forc�e **//
      Else If TypeParametre = '-v:' Then
      Begin

        If ValeurForcee <> '' Then
        Begin
          Afficher( 'Vous ne pouvez pas sp�cifier un Num�ro de Version Forc�e en m�me temps qu''un Num�ro de Build Forc�.' );
          Exit;
        End;

        TypeValeurForcee := VERSION_FORCE;
        ValeurForcee     := Parametre;

      End
      Else If TypeParametre = '-p:' Then
      Begin

        VersionProduit     := Parametre;

      End;
    End;
  End;

    //** Traitement du Fichier .res **//
  Try

    Resultat := IncrementerBuild( NomFichier, CheminXml, ValeurForcee, TypeValeurForcee, VersionProduit );
    If Resultat <> '' Then
      Afficher( Resultat );

  Except

    On Ex : Exception Do
    Begin
      Afficher( Ex.Message );
      Afficher( 'Avec les param�tres : ' + NomFichier +' , '+ CheminXml +' , '+ ValeurForcee );
      ExitCode := 1;
    End;

  End;

End.
