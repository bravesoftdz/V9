{***********UNITE*************************************************
Auteur  ...... : Laurent Ab�lard
Cr�� le ...... : 19/11/2007
Modifi� le ... : 23/01/2008
Description .. : Incr�mentation du Num�ro de Build d'un fichier de
Suite ........ : ressource .res
Suite ........ : La compilation d'un projet en ligne de commande
Suite ........ : n'incr�mente pas le Num�ro de Build. Seul IDE
Suite ........ : le fait de fa�on automatique (si l'option est
Suite ........ : coch�e) en reconstruisant le fichier de ressource.
Suite ........ : La m�thode g�n�ralement utilis�e consiste �
Suite ........ : recr�er un fichier source de ressource .rc �
Suite ........ : l'aide des informations stock�es dans le fichier
Suite ........ : .dof mais cette m�thode ne permet pas de conserver
Suite ........ : d'autre ressource que le programmeur aurait stock�
Suite ........ : dans le .res.
Suite ........ : J'ai tester l'usage de la fonction UpdateResource()
Suite ........ : mais cela ne fonctionne pas avec des .res.
Suite ........ : J'opte pour manipuler directement le fichier
Suite ........ : binaire qui est bien document� par Microsoft en :
Suite ........ : ms-help://MS.VSCC.v80/MS.MSDN.v80/MS.WIN32COM.v10.en/winui/winui/windowsuserinterface/resources/introductiontoresources/resourcefileformats.htm
Suite ........ : http://msdn.microsoft.com/library/en-us/winui/WinUI/WindowsUserInterface/Resources/IntroductiontoResources/ResourceReference/ResourceFunctions/LoadImage.asp
Suite ........ : Transform�e en http://msdn2.microsoft.com/fr-fr/library/ms648007.aspx
Mots clefs ... : Ressource, .res, .rc
*****************************************************************}
Unit IncBuildSources;

Interface

Type
  BUILD_OU_VERSION = ( BUILD_FORCE=1, VERSION_FORCE );

  Function IncrementerBuild( CheminRes : String; CheminXml : String = ''; ValeurForcee : String = '';
                             BuildOuVersion : BUILD_OU_VERSION = BUILD_FORCE; VersionProduit : String = '' ) : String;

Implementation
Uses
  Windows,      //Pour VS_FIXEDFILEINFO
  SysUtils,     //Pour ChangeFileExt(), DeleteFile(), RenameFile()
  //hctrls,       //Pour ReadTokenPipe() de l'Agl
  Classes;      //Pour TFileStream;

Type
  TDWORD  = Array [0..MaxInt DIV SizeOf(DWORD)-1] Of DWORD; //Tableau illimit� de DWORD.
  PTDWORD = ^TDWORD;

  //D�scription de la structure StringStructure => http://msdn2.microsoft.com/fr-fr/library/ms646987.aspx
  StringStructure = Packed Record
    wLength      : WORD;
    wValueLength : WORD;
    wType        : WORD;
    szKey        : WideChar;                 //Nom de la variable de taille quelconque
    Padding      : WORD;
    Value        : WideChar;                 //Valeur de la variable de taille wValueLength exprim� en WideChar si wType = 1 sinon exprim� en Octets.
  End;

  //D�scription de la structure StringTable => http://msdn2.microsoft.com/fr-fr/library/ms646992.aspx
  StringTable = Packed Record
    wLength      : WORD;
    wValueLength : WORD;
    wType        : WORD;
    szKey        : Array[1..9] Of WideChar;   //8 Caract�res du 'Microsoft Standard Language identifier' + Le 0 Terminateur (Ex '040C04E4').
    //Padding    : WORD;                      //Pas besoin de Padding pour �tre align� sur des DWORD.
    Children     : StringStructure;
  End;
  PStringStructure = ^StringStructure;

  //D�scription de la structure StringFileInfo => http://msdn2.microsoft.com/fr-fr/library/ms646989.aspx
  StringFileInfo = Packed Record
    wLength      : WORD;
    wValueLength : WORD;
    wType        : WORD;
    szKey        : Array[1..15] Of WideChar;    //14 Caract�res de 'StringFileInfo' + Le 0 Terminateur.
    //Padding    : WORD;                        //Pas besoin de Padding pour �tre align� sur des DWORD.
    Children     : StringTable;
  End;

  //D�scription de la structure VS_VERSIONINFO => http://msdn2.microsoft.com/fr-fr/library/ms647001.aspx
  VS_VERSIONINFO = Packed Record
    wLength      : WORD;
    wValueLength : WORD;
    wType        : WORD;
    szKey        : Array[1..16] Of WideChar;    //15 Caract�res de 'VS_VERSION_INFO' + Le 0 Terminateur.
    Padding1     : WORD;                        //Le Padding pour �tre align� sur des DWORD.
    Value        : VS_FIXEDFILEINFO;
    //Padding2   : WORD;                        //Pas besoin de Padding pour �tre align� sur des DWORD.
    Children     : WORD;
  End;

  TFileStreamString = Class( TFileStream )
    Function WriteStringLn( Texte : String ) : Integer;
  End;

var  hFicLog        : TFileStreamString;

Const
  AGRANDISSEMENT_MAX : Integer = 4 * Sizeof(WideChar) * 2;  //Passer de 8.0.743.0 � 8.0.743.65535 deux fois (Pour FileVersion et pour ProductVersion)

(*******************************************************************************************
  M�thode qui converti une valeur de chaine en un WORD avec des contr�les.
*******************************************************************************************)
Function ConvertirNumero( ValeurChaine : String; NomObjet : String ) : WORD;
Var
  Valeur : Integer;

Begin

  ValeurChaine := Trim(ValeurChaine);
  If ValeurChaine = '' Then
    Raise Exception.CreateFmt( 'La valeur du %s ne peut pas �tre vide.', [NomObjet] );

    //** Tenter de convertir la chaine en un entier **//
  Try
    Valeur := StrToInt( ValeurChaine );
  Except
    On Ex : Exception Do
    Begin
      Raise Exception.CreateFmt( 'La valeur du %s est incorrect.'#13#10'%s', [NomObjet,Ex.Message] );
    End;
  End;

    //** Contr�ler les valeurs limites **//
  If Valeur < 0 Then
  Begin
    Raise Exception.CreateFmt( 'La valeur du %s ne peut pas �tre n�gative', [NomObjet] );
  End;

  If Valeur > High(Word) Then
  Begin
    Raise Exception.CreateFmt( 'La valeur du %s ne peut pas d�passer la valeur %d.', [NomObjet,High(Word)] );
  End;

  Result := Valeur;

End;

(*******************************************************************************************
  M�thode qui �crit une chaine dans un flux apr�s lui avoir ajout�e RC.
*******************************************************************************************)
Function TFileStreamString.WriteStringLn( Texte : String ) : Integer;
Var
  TexteLn : String;
Begin
  TexteLn := Texte + #13#10;
  Result  := Write( PChar(TexteLn)^, Length(TexteLn) );
End;

(*******************************************************************************************
  Fonction permettant d'aligner un Pointeur sur des doubles mots.
*******************************************************************************************)
Function AlignerDWORD( p : Pointer ) : Pointer; Overload;
Begin
  Result := Pointer( Integer( (PChar(p) + Sizeof(DWORD) - 1) ) And Not (Sizeof(DWORD) - 1) );
End;

Function AlignerDWORD( p : Integer ) : Integer; Overload;
Begin
  Result := (p + Sizeof(DWORD) - 1) And Not (Sizeof(DWORD) - 1);
End;

function READTOKENPipe(var St: string; Sep: string): string;
var
  i: Integer;
begin
  i := Pos(Sep, St);
  if i <= 0 then
    i := Length(St) + 1;
  Result := Copy(St, 1, i - 1);
  Delete(St, 1, i + Length(Sep) - 1);
end;

(*******************************************************************************************
  D�scription de la structure String => http://msdn2.microsoft.com/fr-fr/library/ms646987.aspx
  Retourne le nombre d'octets d'agrandissement ou de R�duction eventuel.
*******************************************************************************************)
Function TraiterStringStructure( Var sStringStructure : StringStructure
                               ; Var sVS_FIXEDFILEINFO : VS_FIXEDFILEINFO; Const pFin : PChar
                               ; Var Resultat : String;  VersionProduit : String = '' ) : Integer;
Var
  Agrandissement : Integer;
  TaillePadding  : Integer;
  TailleValeur   : Integer;
  pNewValue      : PWideChar;
  NewValue       : WideString;
  //hFicLog        : TFileStreamString;
  pValue         : PWideChar;
  pKey           : PWideChar;

Begin

  Result := 0;

  //Contr�ler qu'il s'agisse bien de cha�nes de caract�res.
  If sStringStructure.wType <> 1 Then
    Raise Exception.Create( 'Erreur de structure ''String''' );

  pKey := @sStringStructure.szKey;

  //On ne traite que la Valeur de FileVersion et de ProductVersion
  //If (pKey <> 'FileVersion') And (pKey <> 'ProductVersion') Then Exit;
  If (pKey = 'FileVersion') Then // Exit;
  begin
    //Recalculer la nouvelle valeur sous forme de cha�ne de caract�res.
    WideFmtStr( NewValue, '%d.%d.%d.%d', [HIWORD(sVS_FIXEDFILEINFO.dwFileVersionMS)
                                         ,LOWORD(sVS_FIXEDFILEINFO.dwFileVersionMS)
                                         ,HIWORD(sVS_FIXEDFILEINFO.dwFileVersionLS)
                                         ,LOWORD(sVS_FIXEDFILEINFO.dwFileVersionLS)] );

    pValue := AlignerDWORD( pKey + Length(pKey) + 1 );

    //retourner le r�sultat sous forme de chaine et de fichier XML.
    Resultat := 'Incr�mentation de ' + pValue + ' vers ' + NewValue;

    If hFicLog <> nil Then
    Begin
     // Try
        //NomFichierLog := ChangeFileExt(Trim(NomFichierLog), '.xml' );
       // hFicLog       := TFileStreamString.Create( NomFichierLog, fmCreate );

        Try
          //hFicLog.WriteStringLn( '<?xml version="1.0" encoding="iso-8859-1"?>' );
          hFicLog.WriteStringLn( '<IncBuild>' );
          hFicLog.WriteStringLn( '  <Num�roAvant>' + pValue   + '</Num�roAvant>' );
          hFicLog.WriteStringLn( '  <Num�roApr�s>' + NewValue + '</Num�roApr�s>' );
          hFicLog.WriteStringLn( '</IncBuild>' );
        Except
        End;

     // Finally
     //   FreeAndNil( hFicLog );
     // End;
    End;
  End  // fin si FileVersion
  else
    If (pKey = 'ProductVersion') Then
    begin
      NewValue := VersionProduit;
      pValue := AlignerDWORD( pKey + Length(pKey) + 1 );
      Try

          hFicLog.WriteStringLn( '<ProductVersion>' );
          hFicLog.WriteStringLn( '  <Avant>' + pValue   + '</Avant>' );
          hFicLog.WriteStringLn( '  <Apr�s>' + NewValue + '</Apr�s>' );
          hFicLog.WriteStringLn( '</ProductVersion>' );
      Except
      End;

      //retourner le r�sultat sous forme de chaine et de fichier XML.
     //  Resultat := 'Incr�mentation de ' + pValue + ' vers ' + NewValue;

    end
  else exit;

  TailleValeur   := (Length(NewValue) + 1) * Sizeof(WideChar);
  TaillePadding  := 0;
  Agrandissement := AlignerDWORD(TailleValeur) - AlignerDWORD(sStringStructure.wValueLength * Sizeof(WideChar));
  //If Abs(Agrandissement) > AGRANDISSEMENT_MAX Then
  //  Raise Exception.Create( 'Erreur de calcul de l''Agrandissement' );

  //Il est n�cessaire d'agrandir pour pouvoir ins�rer les nouveaux caract�res.
  If Agrandissement > 0 Then
  Begin

    Move( pValue^, Pointer(PChar(pValue) + Agrandissement)^, pFin - pValue );

    //Remplir la zone de Padding
    TaillePadding := AlignerDWORD(TailleValeur) - TailleValeur;
    If TaillePadding > 0 Then
      Move( #0#0#0#0, Pointer( PChar(pValue) + ((Length(NewValue)+1) * Sizeof(WideChar)) )^, TaillePadding );

  End

  //Il est n�cessaire de r�duire.
  Else If Agrandissement < 0 Then
  Begin

    pNewValue := Pointer( PChar(pValue) + Abs(Agrandissement) );
    Move( pNewValue^, pValue^ ,pFin - pValue );

  End;

  //Copier la nouvelle valeur
  pNewValue := @NewValue[1];
  Move( pNewValue^, pValue^, TailleValeur );

  sStringStructure.wValueLength := Length(NewValue) + 1;
  sStringStructure.wLength      := sStringStructure.wLength + Agrandissement;
  Result                        := Agrandissement;

End;


(*******************************************************************************************
  D�scription de la structure StringTable => http://msdn2.microsoft.com/fr-fr/library/ms646992.aspx
  Retourne le nombre d'octets d'agrandissement ou de R�duction eventuel.
*******************************************************************************************)
Function TraiterStringTable( Var sStringTable : StringTable; Var sVS_FIXEDFILEINFO : VS_FIXEDFILEINFO
                           ; Const pFin : PChar; Var Resultat : String;  VersionProduit : String = '' ) : Integer;
Var
  TailleStructure : Integer;
  Agrandissement  : Integer;
  TailleTableau   : Integer;
  pString         : PStringStructure;

Begin

  If sStringTable.wValueLength <> 0 Then
    Raise Exception.Create( 'Erreur sur la taille de la structure ''StringTable''' );

  //Ne PAS faire de contr�le sur le Type car BORLAND => 0 et MICROSOFT => 1 !!!!
  //If sStringTable.wType <> 0 Then
  //  Raise Exception.Create( 'Erreur sur le type de la structure ''StringTable''' );

  //Traiter le champ children de type Tableau de StringStructure
  Agrandissement := 0;
  TailleTableau  := sStringTable.wLength - (Sizeof(sStringTable) - Sizeof(StringStructure));  //Conserver la taille du tableau en Octets.
  pString        := @sStringTable.Children;
  Repeat

    TailleStructure := AlignerDWORD( pString.wLength ); //Conserver la Taille de la Structure avant Modifications.
    Agrandissement  := Agrandissement + TraiterStringStructure( pString^, sVS_FIXEDFILEINFO, pFin, Resultat, VersionProduit );

    //Passer � la Structure String Suivante (Le membre wLength a put �tre modifi� par la fonction TraiterStringStructure())
    TailleTableau := TailleTableau - TailleStructure;
    pString       := AlignerDWORD( PChar(pString) + pString.wLength );

  Until TailleTableau <= 0;

  sStringTable.wLength := sStringTable.wLength + Agrandissement;
  Result := Agrandissement;

End;


(*******************************************************************************************
  D�scription de la structure StringFileInfo => http://msdn2.microsoft.com/fr-fr/library/ms646989.aspx
  Retourne le nombre d'octets d'agrandissement ou de R�duction eventuel.
*******************************************************************************************)
Function TraiterStringFileInfo( Var sStringFileInfo : StringFileInfo; Var sVS_FIXEDFILEINFO : VS_FIXEDFILEINFO
                              ; Const pFin : PChar; Var Resultat : String;  VersionProduit : String = ''  ) : Integer;
Var
  Agrandissement : Integer;

Begin

  If sStringFileInfo.wValueLength <> 0 Then
    Raise Exception.Create( 'Erreur sur la taille de la structure ''StringFileInfo''' );

  //Ne PAS faire de contr�le sur le Type car BORLAND => 0 et MICROSOFT => 1 !!!!
  //If sStringFileInfo.wType <> 1 Then
  //  Raise Exception.Create( 'Erreur sur le type de la structure ''StringFileInfo''' );

  //Contr�ler la cl� de contr�le.
  If WideCompareStr( sStringFileInfo.szKey, 'StringFileInfo' ) <> 0 Then
    Raise Exception.Create( 'Erreur sur la cl� de la structure ''StringFileInfo''' );

  //Traiter le champ children de type StringTable
  Agrandissement := TraiterStringTable( StringTable((@sStringFileInfo.Children)^), sVS_FIXEDFILEINFO, pFin, Resultat,  VersionProduit );

  sStringFileInfo.wLength := sStringFileInfo.wLength + Agrandissement;
  Result := Agrandissement;

End;

(*******************************************************************************************
  D�scription de la structure VS_VERSIONINFO => http://msdn2.microsoft.com/fr-fr/library/ms647001.aspx
  Retourne le nombre d'octets d'agrandissement ou de R�duction eventuel.
*******************************************************************************************)
Function TraiterVS_VERSIONINFO( Var sVS_VERSIONINFO : VS_VERSIONINFO; Const pFin : PChar;
                                Var Resultat : String;  ValeurForcee : String = '';
                                BuildOuVersion : BUILD_OU_VERSION = BUILD_FORCE; VersionProduit : String = '' ) : Integer;
Var
  Agrandissement : Integer;
  VersionMajeur  : WORD;
  VerionMineure  : WORD;
  Release        : WORD;
  Build          : WORD;

Begin

  If sVS_VERSIONINFO.wValueLength < SizeOf(VS_FIXEDFILEINFO) Then
    Raise Exception.Create( 'Erreur sur la taille de la structure ''VS_VERSIONINFO''' );

  //Contr�ler la cl� de contr�le.
  If WideCompareStr( sVS_VERSIONINFO.szKey, 'VS_VERSION_INFO' ) <> 0 Then
    Raise Exception.Create( 'Erreur sur la cl� de la structure ''VS_VERSIONINFO''' );

  If sVS_VERSIONINFO.wType <> 0 Then
    Raise Exception.Create( 'Erreur sur le type de la structure ''VS_VERSIONINFO''' );

  //Si on n'a pas de valeur forc�e on relit les valeurs dans le .res
  If ValeurForcee = '' Then
  Begin

    //D�scription de la structure VS_FIXEDFILEINFO => http://msdn2.microsoft.com/fr-fr/library/ms646997.aspx
    VersionMajeur := HIWORD(sVS_VERSIONINFO.Value.dwFileVersionMS);
    VerionMineure := LOWORD(sVS_VERSIONINFO.Value.dwFileVersionMS);
    Release       := HIWORD(sVS_VERSIONINFO.Value.dwFileVersionLS);
    Build         := LOWORD(sVS_VERSIONINFO.Value.dwFileVersionLS);

    //Incr�menter le num�ro de build
    If Build < High(WORD) Then
      Inc(Build)
    Else
      Build := 0;

  End
  Else
  Begin

    //On relit les valeur dans le fichier .res si la valeur forc�e correspond seulement au build.
    If BuildOuVersion = BUILD_FORCE Then
    Begin

      //D�scription de la structure VS_FIXEDFILEINFO => http://msdn2.microsoft.com/fr-fr/library/ms646997.aspx
      VersionMajeur := HIWORD(sVS_VERSIONINFO.Value.dwFileVersionMS);
      VerionMineure := LOWORD(sVS_VERSIONINFO.Value.dwFileVersionMS);
      Release       := HIWORD(sVS_VERSIONINFO.Value.dwFileVersionLS);
      Build         := ConvertirNumero( ValeurForcee, 'Num�ro de Build' );

    End
    Else
    Begin

      //sinon on force la valeur du num�ro de version.
      VersionMajeur := ConvertirNumero( ReadTokenPipe( ValeurForcee , '.' ), 'Num�ro de Version Majeure' );
      VerionMineure := ConvertirNumero( ReadTokenPipe( ValeurForcee , '.' ), 'Num�ro de Version Mineure' );
      Release       := ConvertirNumero( ReadTokenPipe( ValeurForcee , '.' ), 'Num�ro de Release' );
      Build         := ConvertirNumero( ReadTokenPipe( ValeurForcee , '.' ), 'Num�ro de Build' );

    End;

  End;

  sVS_VERSIONINFO.Value.dwFileVersionMS := MakeLong( VerionMineure, VersionMajeur );
  sVS_VERSIONINFO.Value.dwFileVersionLS := MakeLong( Build, Release );

  //sVS_VERSIONINFO.Value.dwProductVersionMS := sVS_VERSIONINFO.Value.dwFileVersionMS;
  //sVS_VERSIONINFO.Value.dwProductVersionLS := sVS_VERSIONINFO.Value.dwFileVersionLS;

  //Traiter le champ children de type StrinFileInfo
  Agrandissement := TraiterStringFileInfo( StringFileInfo((@sVS_VERSIONINFO.Children)^), sVS_VERSIONINFO.Value, pFin, Resultat, VersionProduit );

  sVS_VERSIONINFO.wLength := sVS_VERSIONINFO.wLength + Agrandissement;
  Result := Agrandissement;

End;

(*******************************************************************************************
   Cette Fonction Incr�mente le Num�ro de Build du fichier .res passer en param�tre.
   On peut forcer la version � enregistrer voir seulement le num�ro de Build.
   Le r�sultat peut aussi �tre stock� dans un fichier XML.
   Param�tres :
      - CheminRes      : Chemin du Fichier .res � modifier.
      - CheminXml      : Chemin du Fichier XML de r�sultat.
      - ValeurForcee   : Valeur forc�e pour la version ou le Build selon le param�tre BuildOuVersion
      - BuildOuVersion : Param�tre qui pr�cise le contenu de ValeurForcee.
********************************************************************************************)
Function IncrementerBuild( CheminRes : String; CheminXml : String = ''; ValeurForcee : String = '';
                           BuildOuVersion : BUILD_OU_VERSION = BUILD_FORCE; VersionProduit : String = '' ) : String;

Var
  TailleRessource : Integer;
  Agrandissement  : Integer;
  TailleFichier   : Integer;
  CheminSource    : String;
  CheminDestin    : String;
  NomFichierLog   : String;
  TailleALire     : Integer;
  hFicSource      : TFileStream;
  hFicDestin      : TFileStream;
  HeaderSize      : DWORD;
  DataSize        : DWORD;
  Ressource       : Pointer;
  CodeType        : WORD;
  Control         : WORD;
  NomType         : PWideChar;
  Entete          : PTDWORD;

Begin

  Result := '';
  CheminSource := ChangeFileExt(CheminRes, '.res' );
  CheminDestin := ChangeFileExt(CheminRes, '.~res' );

  Try   //Toujours tenter de nettoyer le fichier temporaire.  ==> DeleteFile( CheminDestin );
    hFicLog := nil;
    if CheminXml <>'' then
    begin
      NomFichierLog := ChangeFileExt(Trim(CheminXml), '.xml' );
      hFicLog       := TFileStreamString.Create( NomFichierLog, fmCreate );
      hFicLog.WriteStringLn( '<?xml version="1.0" encoding="iso-8859-1"?>' );
    end;
    Try
      hFicSource := TFileStream.Create( CheminSource, fmOpenRead );
    Except
      //Les projets ne comporte pas toujours un fichier.res comme les applications de type CONSOLE par exemple.
      On EFOpenError Do
      Begin
        Result := 'Impossible d''ouvrir le fichier ' + CheminSource + '.'#13#10'Op�ration abandonn�e';
        Exit;
      End;
    End;

    Try   //Bloc ==> FreeAndNil( hFicSource );

      hFicDestin := TFileStream.Create( CheminDestin, fmCreate );

      Try   //Bloc ==> FreeAndNil( hFicDestin );

        TailleFichier := hFicSource.Size;

        //Parcours des ressources du Fichier .RES
        Repeat

          //Lire la taille des donn�es de la ressource.
          TailleALire := SizeOf(DataSize);
          Try
            hFicSource.ReadBuffer( DataSize, TailleALire );
          Except
            Raise Exception.CreateFmt( 'Erreur de lecture du fichier %s.', [CheminSource] );
          End;
          TailleFichier := TailleFichier - TailleALire;

          //Lire la taille de l'Ent�te.
          TailleALire := SizeOf(HeaderSize);
          Try
            hFicSource.ReadBuffer( HeaderSize, TailleALire );
          Except
            Raise Exception.CreateFmt( 'Erreur de lecture du fichier %s.', [CheminSource] );
          End;
          TailleFichier := TailleFichier - TailleALire;
          If HeaderSize <= (3 * SizeOf(DWORD)) Then
            Raise Exception.CreateFmt( 'Erreur de lecture du fichier %s.#10#13 Format Incorrect, Ent�te Vide', [CheminSource] );

          //Lire le reste de l'Ent�te.
          Entete := PTDWORD(AllocMem( HeaderSize ));
          
          Try   //Bloc ==> If Entete <> Nil Then FreeMem( Entete );
            Entete[0] := DataSize;
            Entete[1] := HeaderSize;

            TailleALire := HeaderSize - SizeOf(DataSize) - SizeOf(HeaderSize);
            Try
              hFicSource.ReadBuffer( Entete[2], TailleALire );
            Except
              Raise Exception.CreateFmt( 'Erreur de lecture du fichier %s.', [CheminSource] );
            End;
            TailleFichier := TailleFichier - TailleALire;

            //Lire le 1er WORD du type.
            Control := LOWORD(Entete[2]);
            If Control = $FFFF Then
            Begin

              //Lire le Code du type.
              CodeType := HIWORD(Entete[2]);

            End
            Else
            Begin

              NomType := PWideChar(@Entete[2]);

              //Convertir le nom en Code
              If NomType      = 'RT_VERSION'      Then CodeType := DWORD(RT_VERSION)
              Else If NomType = 'RT_CURSOR'       Then CodeType := DWORD(RT_CURSOR)
              Else If NomType = 'RT_BITMAP'       Then CodeType := DWORD(RT_BITMAP)
              Else If NomType = 'RT_ICON'         Then CodeType := DWORD(RT_ICON)
              Else If NomType = 'RT_MENU'         Then CodeType := DWORD(RT_MENU)
              Else If NomType = 'RT_DIALOG'       Then CodeType := DWORD(RT_DIALOG)
              Else If NomType = 'RT_STRING'       Then CodeType := DWORD(RT_STRING)
              Else If NomType = 'RT_FONTDIR'      Then CodeType := DWORD(RT_FONTDIR)
              Else If NomType = 'RT_FONT'         Then CodeType := DWORD(RT_FONT)
              Else If NomType = 'RT_ACCELERATOR'  Then CodeType := DWORD(RT_ACCELERATOR)
              Else If NomType = 'RT_RCDATA'       Then CodeType := DWORD(RT_RCDATA)
              Else If NomType = 'RT_MESSAGETABLE' Then CodeType := DWORD(RT_MESSAGETABLE)
              Else If NomType = 'RT_GROUP_CURSOR' Then CodeType := DWORD(RT_GROUP_CURSOR)
              Else If NomType = 'RT_GROUP_ICON'   Then CodeType := DWORD(RT_GROUP_ICON)
              Else If NomType = 'RT_DLGINCLUDE'   Then CodeType := DWORD(RT_DLGINCLUDE)
              Else If NomType = 'RT_PLUGPLAY'     Then CodeType := DWORD(RT_PLUGPLAY)
              Else If NomType = 'RT_VXD'          Then CodeType := DWORD(RT_VXD)
              Else If NomType = 'RT_ANICURSOR'    Then CodeType := DWORD(RT_ANICURSOR)
              Else If NomType = 'RT_ANIICON'      Then CodeType := DWORD(RT_ANIICON)
              Else CodeType := 0;

            End;

            //Les Ent�tes de Ressources sont align�s sur des Doubles Mots.
            TailleRessource := AlignerDWORD( DataSize );

            //Lire le reste de la ressource.
            Try   //Bloc ==> If Ressource <> Nil Then FreeMem( Ressource );

              If TailleRessource > 0 Then
              Begin

                //On alloue AGRANDISSEMENT_MAX caract�res suppl�mentaires pour tenir compte d'un eventuel agrandissement.
                Ressource := AllocMem( TailleRessource + (AGRANDISSEMENT_MAX * SizeOf(WideChar)) );
                Try
                  hFicSource.ReadBuffer( Ressource^, TailleRessource );
                Except
                  Raise Exception.CreateFmt( 'Erreur de lecture du fichier %s.', [CheminSource] );
                End;
                TailleFichier := TailleFichier - TailleRessource;

                If MakeIntResource(CodeType) = RT_VERSION Then
                Begin

                  //Modifier la ressource VS_VERSIONINFO
                  Agrandissement := TraiterVS_VERSIONINFO( VS_VERSIONINFO(Ressource^)
                                                         , PChar(PChar(Ressource) + TailleRessource)
                                                         , Result,  ValeurForcee, BuildOuVersion, VersionProduit );

                  TailleRessource := TailleRessource + Agrandissement;
                  Entete[0]       := WORD( Integer(Entete[0]) + Agrandissement );
                End;

              End;

              //Ranger l'Ent�te �ventuellement modifi� dans le fichier de destination.
              Try
                hFicDestin.WriteBuffer( Entete^, HeaderSize );
              Except
                Raise Exception.CreateFmt( 'Erreur d''�criture dans le fichier %s.', [CheminDestin] );
              End;

              //Ranger la ressource �ventuellement modifi�e dans le fichier de destination.
              If TailleRessource > 0 Then
                Begin
                Try
                  hFicDestin.WriteBuffer( Ressource^, TailleRessource );
                Except
                  Raise Exception.CreateFmt( 'Erreur d''�criture dans le fichier %s.', [CheminDestin] );
                End;
              End;

            Finally
              If Ressource <> Nil Then FreeMem( Ressource );
              Ressource := Nil;
            End;

          Finally
            If Entete <> Nil Then FreeMem( Entete );
            Entete := Nil;
          End;

        Until TailleFichier <= 0;

      Finally
        FreeAndNil( hFicDestin );
      End;

    Finally
      FreeAndNil( hFicSource );
    End;

    //Apr�s la cr�ation du fichier Temporaire
    If Not DeleteFile( CheminSource ) Then
      Raise Exception.CreateFmt( 'Impossible de d�truire le fichier ''%s.''', [CheminSource] );

    If Not RenameFile( CheminDestin, CheminSource ) Then
      Raise Exception.CreateFmt( 'Impossible de renommer le fichier de ''%s'' en ''%s.''', [CheminDestin,CheminSource] );

  Finally
    //Toujours tenter de nettoyer le fichier temporaire.
    DeleteFile( CheminDestin );
    FreeAndNil( hFicLog );
  End;

End;

End.

