{***********UNITE*************************************************
Auteur  ...... : Paie Pgi - FLO
Cr�� le ...... : 16/01/2008
Modifi� le ... :   /  /
Description .. : Permet � un salari� d'effectuer une demande de formation
               : Vignette : PG_VIG_SAISDEM
               : Table    : INSCFORMATION
Mots clefs ... : VIGNETTE;DEMANDE;SALARIE;FORMATION
*****************************************************************
PT1  | 14/03/2008 | FLO | Restriction de la liste aux stages du collaborateur appliqu�e par d�faut
						  Concat�nation du libell� et du libell� suite
PT2  | 14/03/2008 | FLO | Gestion multi-dossier formation
PT3  | 25/03/2008 | FLO | Ajout du param�trage du tri de la liste
PT4  | 15/05/2008 | FLO | Rafra�chissement des vignettes associ�s
}
unit PGVIGSAISDEM;

interface
uses
  Classes,
  UTob,
   {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  PGVignettePaie,
  HCtrls;

type
  PG_VIG_SAISDEM= class (TGAVignettePaie)
  protected
    procedure RecupDonnees                                       ; override;
    function  GetInterface   (NomGrille: string = ''): Boolean   ; override;
    procedure GetClauseWhere                                     ; override;
    procedure DrawGrid       (Grille: string)                    ; override;
    function  SetInterface : Boolean                             ; override;
  private
    Millesime, Emploi : String;
    procedure AfficheListeStages;
    procedure OpenDetail;
    procedure EffaceDetail;
    procedure OpenDoc;
    procedure InitialiseVignette;
    procedure Inscription;
  end;


implementation
uses
  SysUtils,
  PGVIGUTIL,
  rtfcounter,
  esession,
  ParamSoc,
  HEnt1,
  StrUtils,PGOutilsFOrmation, uToolsPlugin;

{-----R�cup�ration des controls/valeurs depuis la TobRequest----------------------------}

function PG_VIG_SAISDEM.GetInterface (NomGrille: string): Boolean;
Var Details : Boolean;
begin
  inherited GetInterface ('');

  // Gestion des diff�rents param�tres
       If (Fparam = 'RETOUR')   Then EffaceDetail
  Else if (FParam = 'OPENDOC')  Then OpenDoc
  Else If (FParam = 'INSCRIRE') Then Inscription;

  { 2 cas possibles :
    - Visualisation de la liste des stages
    - Visualisation du d�tail (OPENDETAIL). Dans ce cas, on cache la liste et on affiche
      le d�tail par dessus }
  Details := (Fparam = 'OPENDETAIL') or (Fparam = 'OPENDOC') ;

  SetControlVisible('GRSALARIE',       Not Details);
  SetControlVisible('CKLIMITEEMPLOI',  Not Details);

  SetControlVisible('PANDETAIL',       Details);
  SetControlVisible('BRETOUR',         Details);
  SetControlVisible('BPROGRAMME',      Details);
  SetControlVisible('BINSCRIRE',       Details);

  Result := true;
end;

{-----Chargement des donn�es -----------------------------------------------------------}

procedure PG_VIG_SAISDEM.RecupDonnees;
begin
  inherited;
  	Millesime := ''; 
  	Emploi    := '';
  	
    If (Fparam = '') Then
    Begin
        InitialiseVignette;
    End;

    // Ne rafra�chir la liste que sur le chargement de la vignette et les changements
    // de crit�res mais pas sur la s�lection dans la liste car elle est cach�e
    If (Fparam = 'OPENDETAIL') Then
    Begin
         OpenDetail;
         SetControlVisible('BMORE',   False);
         SetControlVisible('PANRECHERCHE', False);
         SetControlVisible('CKLIMITEEMPLOI', False);
    End
    Else
    Begin
         AfficheListeStages;
         SetControlVisible('BMORE',   True);
         SetControlVisible('PANRECHERCHE', (GetControlValue('LIBELLESTAGE')<>''));
         SetControlVisible('CKLIMITEEMPLOI', ((GetControlValue('EMPLOI')<>'') Or (Emploi <> '')));
    End;
end;

{-----Crit�re de la requ�te ------------------------------------------------------------}

procedure PG_VIG_SAISDEM.GetClauseWhere;
begin
  inherited;
end;

{-----Affectation des controls/valeurs dans la TobRespons ------------------------------}

function PG_VIG_SAISDEM.SetInterface: Boolean;
begin
  inherited SetInterface;
    result:=true;

    // Association de la TobDonnees avec la grille (celle par d�faut etant nomm�e GRSALARIE)
//    If Fparam <> 'OPENDETAIL' Then PutGridDetail('GRSALARIE', TobDonnees);
end;

{-----Formate les donn�es de la grille -------------------------------------------------}

procedure PG_VIG_SAISDEM.DrawGrid (Grille: string);
begin
  inherited;
     SetWidthCol  (Grille, 'CODESTAGE', -1);
     SetWidthCol  (Grille, 'LIBELLE',   200);
     SetWidthCol  (Grille, 'NBHEURES',  50);
     SetFormatCol (Grille, 'NBHEURES',  'D 0 ---');
end;

{-----Affichage des donn�es dans la grille ---------------------------------------------}

procedure PG_VIG_SAISDEM.AfficheListeStages;
var
  StSQL   : String;
  DataTob,T : TOB;
  i       : Integer;
  Libelle : String;
  Mill,Emp:String;
begin

  Try
    // Cr�ation de la TOB principale
    DataTob := TOB.Create('~TEMP', nil, -1);

    // Liste des stages
    If Millesime <> '' Then Mill := Millesime Else Mill := GetControlValue('MILLESIME');
    If Emploi    <> '' Then Emp  := Emploi    Else Emp  := GetControlValue('EMPLOI');
    
    StSQL := 'SELECT PST_CODESTAGE, PST_LIBELLE, PST_LIBELLE1, PST_DUREESTAGE FROM STAGE WHERE PST_ACTIF="X" AND PST_MILLESIME="'+Mill+'"'; //PT1
    If GetControlValue('LIBELLESTAGE') <> '' Then StSQL := StSQL + ' AND PST_LIBELLE LIKE "%'+GetControlValue('LIBELLESTAGE')+'%"';
    If (GetControlValue('CKLIMITEEMPLOI') = True) And (Emp <> '') Then StSQL := StSQL + ' AND PST_CODESTAGE IN (SELECT PMF_CODESTAGE FROM LIENEMPFORM WHERE (PMF_LIBELLEEMPLOI="'+Emp+'" OR PMF_LIBELLEEMPLOI="") AND PMF_ORDRE="-1")'; //PT1
    If PGBundleCatalogue Then
    Begin
        If PGDroitMultiForm Then
            StSQL := StSQL + DossiersAInterroger ('', '', 'PST', True, True) //PT2
        Else
            StSQL := StSQL + DossiersAInterroger ('', V_PGI.NoDossier, 'PST', True, True); //PT2
    End;
    
	//PT3 - D�but
	If GetCritereValue('TRILISTE') <> '' Then
		StSQL := StSQL + ' ORDER BY PST_'+GetCritereValue('TRILISTE')
	Else
    	StSQL := StSQL + ' ORDER BY PST_LIBELLE';
    //PT3 - Fin

    DataTob := OpenSelectInCache (StSQL);
    ConvertFieldValue(DataTob);

    For i:=0 To DataTob.Detail.Count-1 Do
    Begin
      T := TOB.Create('�REPONSE',TobDonnees,-1);
      T.AddChampSupValeur('CODESTAGE',    DataTob.Detail[i].GetValue('PST_CODESTAGE'));
      Libelle := DataTob.Detail[i].GetValue('PST_LIBELLE');
      If DataTob.Detail[i].GetValue('PST_LIBELLE1') <> '' Then Libelle := Libelle + ' ' + DataTob.Detail[i].GetValue('PST_LIBELLE1'); //PT1
      T.AddChampSupValeur('LIBELLE',      Libelle);
      T.AddChampSupValeur('NBHEURES',     DataTob.Detail[i].GetValue('PST_DUREESTAGE'));
    End;

    // For�age si aucun enregistrement pour bien rafra�chir la liste
    If (TobDonnees.Detail.Count = 0) Then
      PutGridDetail('GRSALARIE', TobDonnees);
  Finally
    If Assigned(DataTob) Then FreeAndNil (DataTob);
  End;

end;

{-----Action lanc�e sur clic du bouton BPROGRAMME --------------------------------------}

procedure PG_VIG_SAISDEM.OpenDoc;
var
  filename: string;
  Stage,StSQL : String;
  Q           : TQuery;

  { Sous fonction permettant la cr�ation du fichier RTF contenant le programme du stage }
  function doRTFFile : string;
  var M: TMemoryStream;
      rtf: string;
      LaSession: TISession;
  begin
    rtf := Q.FindField('PST_BLOCNOTE').AsString;
    if lowercase(Copy(rtf, 1, 6)) <> '{\rtf1' then
      exit;
    M := TMemoryStream.Create();
    try
      LaSession := LookupCurrentSession;
      filename := LaSession.eAglDocPath + 'Portail\' + LaSession.SessionId + '.rtf';
      TobResponse.AddChampSupValeur('FILE', '/Portail/' + LaSession.SessionId + '.rtf');
      M.write(rtf[1], Length(rtf));
      M.Seek(0, 0);
      M.SaveToFile(filename);
    finally
      FreeAndNil(M);
    end;
  end;

begin
     // R�cup�ration du code stage pr�c�demment sauvegard� dans un champ cach� de la vignette
     Stage := GetControlValue('CODESTAGE');

     // Recherche du programme
     If Stage <> '' Then
     Begin
        Try
          StSQL := 'SELECT PST_BLOCNOTE FROM STAGE WHERE PST_CODESTAGE="'+Stage+'" AND PST_MILLESIME="'+GetControlValue('MILLESIME')+'"';
          Q := OpenSQL(StSQL, True);
          If Not Q.EOF Then
          Begin
               If CountRTFString(Q.FindField('PST_BLOCNOTE').AsString)>0 Then
                    doRtfFile
               Else
                    // Si pas de document li�, on affiche un message � l'utilisateur
                    MessageErreur := TraduireMemoire('Aucun document n''est rattach�.');
          End;
          Ferme (Q);
        Except
        End;
     end;
end;

{-----Action lanc�e sur double-clic dans la grille --------------------------------------}

procedure PG_VIG_SAISDEM.OpenDetail;
Var
  Stage,StSQL : String;
  Q           : TQuery;
  TobTemp, DataTob, T : TOB;
begin
     Try
          // R�cup�ration dans le flux de la ligne s�l�ctionn�e dans la grille sous forme de TOB
          T := GetLinkedValue('GRSALARIE');

          // R�cup�ration du stage s�lectionn�
          If (T <> Nil) And (T.Detail.Count > 0) Then
          Begin
               Stage := T.Detail[0].GetValue('CODESTAGE');
               // Rappel du libell� de stage
               //SetControlValue('TPST_STAGELIB', T.Detail[0].GetValue('LIBELLE'));
          End
          Else
          Begin
               Stage := '';
               SetControlValue('TPST_STAGELIB', '');
               SetControlValue('TPST_STAGELIB2', '');
          End;
          // Sauvegarde du code stage pour le programme du stage qui s'effectue lors d'une autre action
          SetControlValue('CODESTAGE', Stage);

          // Plan de formation par d�faut
          SetControlValue('CBTYPEPLAN', 'PLF');

          // Recherche des �l�ments de d�tails
          If Stage <> '' Then
          Begin
               StSQL := 'SELECT PST_LIBELLE,PST_LIBELLE1,PST_DUREESTAGE,PST_JOURSTAGE,PST_CENTREFORMGU,PST_NATUREFORM,PST_LIEUFORM FROM STAGE WHERE PST_CODESTAGE="'+Stage+'" AND PST_MILLESIME="'+GetControlValue('MILLESIME')+'"';
               Q := OpenSQL(StSQL, True);
               If Not Q.EOF Then
               Begin
                    SetControlValue('TPST_STAGELIB',  Q.FindField('PST_LIBELLE').AsString);
                    SetControlValue('TPST_STAGELIB2', Q.FindField('PST_LIBELLE1').AsString);
                    SetControlValue('NBHEURES',       Q.FindField('PST_DUREESTAGE').AsString);
                    SetControlValue('NBJOURS',        Q.FindField('PST_JOURSTAGE').AsString);
                    SetControlValue('NATURE',         RechDom('PGNATUREFORM',Q.FindField('PST_NATUREFORM').AsString,False));
                    SetControlValue('CENTREFORM',     RechDom('PGCENTREFORMATION',Q.FindField('PST_CENTREFORMGU').AsString,False));
                    SetControlValue('LIEUFORM',       RechDom('PGLIEUFORMATION',Q.FindField('PST_LIEUFORM').AsString,False));
               End;
               Ferme (Q);
          End
          Else
               EffaceDetail;

          // Simuler une donn�e dans la Tob principale pour ne pas avoir le bandeau "La s�lection ne renvoie aucun enregistrement"
          T := TOB.Create('�DUMMY', TobDonnees, -1);
          T.AddChampSupValeur('CODESTAGE','000000');
          T.AddChampSupValeur('LIBELLE',  '');
          T.AddChampSupValeur('NBHEURES', '');
     Finally
          If Assigned(TobTemp) Then FreeAndNil (TobTemp);
          If Assigned(DataTob) Then FreeAndNil (DataTob);
     End;
end;

{-----Action lanc�e sur clic du bouton retour une fois dans l'�cran de d�tail --}

procedure PG_VIG_SAISDEM.EffaceDetail;
begin
     { R.A.Z. des diff�rents champs pour que, lorsque l'on quitte le d�tail, les donn�es
       ne soient pas repass�es au serveur ce qui peut-�tre p�nalisant s'il y a du volume }
     SetControlValue('NBHEURES',   0);
     SetControlValue('NBJOURS',    0);
     SetControlValue('CENTREFORM', '');
     SetControlValue('NATURE',     '');
     SetControlValue('LIEUFORM',   '');
end;

{-----Initialisation de la vignette -------------------------------------------------}

procedure PG_VIG_SAISDEM.InitialiseVignette;
var Q       : TQuery;
    Affiche : Boolean;
    StSQL   : String;
begin
    Affiche := False;

    Try
        // Recherche du libell� emploi du salari�
        StSQL := 'SELECT PSA_LIBELLEEMPLOI FROM SALARIES WHERE PSA_SALARIE="'+V_PGI.UserSalarie+'"';
        StSQL := AdaptMultiDosForm (StSQL); //PT2

        Q := OpenSQL(StSQL, True);
        If Not Q.Eof Then
        Begin
        	// Sauvegarde de la valeur dans une variable pour l'initialisation de la vignette
        	// En effet, une valeur modifi�e dans le m�me appel de vignette n'est capt� qu'au prochain �v�nement
        	Emploi := Q.FindField('PSA_LIBELLEEMPLOI').AsString;
            SetControlValue('EMPLOI', Emploi);
            Affiche := True;
        End;
        Ferme(Q);

        // Est-ce que les liens emploi-formation sont param�tr�s?
        If Not Affiche Or Not ExisteSQL('SELECT PMF_CODESTAGE FROM LIENEMPFORM') Then
            Affiche := False;

        // R�cup�ration du mill�sime pr�visionnel en cours
        Millesime := RendMillesimePrevisionnel();
    Finally
        SetControlVisible('CKLIMITEEMPLOI', Affiche);
        SetControlValue('MILLESIME', Millesime);
    End;
end;

{-----Inscription du salari� � la formation en cours de visualisation ---------------}

procedure PG_VIG_SAISDEM.Inscription;
var TRefresh : TOB;
begin
    MessageErreur := InscritSalariePrevisionnel(GetControlValue('CODESTAGE'),GetControlValue('MILLESIME'),V_PGI.UserSalarie,
                                                '1',GetControlValue('CBTYPEPLAN'),'',StrToFloat(GetControlValue('NBHEURES')),0,True,RecupTypeUtilisateur('FOR'));

	//PT4
	If MessageErreur = '' Then
	Begin
        // Rafra�chissement des vignettes Mes demandes de DIF et Mes demandes de formation
  		TRefresh := TOB.Create('T_REFRESH', TobResponse, -1);
  		If GetControlValue('CBTYPEPLAN') = 'DIF' Then
  			TRefresh.AddChampSupValeur('NAMES','PG_VIG_DDIFSAL')
  		Else
  			TRefresh.AddChampSupValeur('NAMES','PG_VIG_PREVSAL');
	End;
end;

end.


