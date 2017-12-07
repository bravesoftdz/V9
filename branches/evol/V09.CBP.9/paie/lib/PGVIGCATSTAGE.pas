{***********UNITE*************************************************
Auteur  ...... : Paie Pgi - FLO
Cr�� le ...... : 13/06/2007
Modifi� le ... :   /  /
Description .. : liste des stages du catalogue
               : Vignette : PG_VIG_CATSTAGE
               : Table    : STAGE
Mots clefs ... : VIGNETTE;STAGE;CATALOGUE
*****************************************************************
PT1  | 18/01/2008 | FLO | Ajout d'un panel pour la recherche du libell� stage et du 2e libell� en visu d�tail
PT2  | 14/03/2008 | FLO | Concat�nation du libell� et du libell� suite
PT3  | 18/03/2008 | FLO | Prise en compte du multi-dossier
PT4  | 25/03/2008 | FLO | Plus de concat�nation du libell� suite dans le d�tail car d�j� repris par la liste
PT5  | 25/03/2008 | FLO | Ajout du param�trage du tri de la liste
}
unit PGVIGCATSTAGE;

interface
uses
  Classes,
  UTob,
   {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  PGVignettePaie,
  HCtrls;

type
  PG_VIG_CATSTAGE= class (TGAVignettePaie)
  protected
    procedure RecupDonnees                                       ; override;
    function  GetInterface   (NomGrille: string = ''): Boolean   ; override;
    procedure GetClauseWhere                                     ; override;
    procedure DrawGrid       (Grille: string)                    ; override;
    function  SetInterface : Boolean                             ; override;
  private
    procedure AfficheListeStages;
    procedure OpenDetail;
    procedure EffaceDetail;
    procedure OpenDoc;
    procedure InitialiseChampsLibres;
  end;


implementation
uses
  SysUtils,
  PGVIGUTIL,
  rtfcounter,
  PGOutilsFormation,
  esession,
  ParamSoc,
  HEnt1, StrUtils;

{-----R�cup�ration des controls/valeurs depuis la TobRequest----------------------------}

function PG_VIG_CATSTAGE.GetInterface (NomGrille: string): Boolean;
Var Details : Boolean;
begin
  inherited GetInterface ('');

  // Gestion des diff�rents param�tres
  If (Fparam = 'RETOUR') Then EffaceDetail       // Supprime les donn�es du d�tail lors de sa fermeture
  Else if (FParam = 'OPENDOC') then OpenDoc;

  { 2 cas possibles :
    - Visualisation de la liste des stages
    - Visualisation du d�tail (OPENDETAIL). Dans ce cas, on cache la liste et on affiche
      le d�tail par dessus }
  Details := (Fparam = 'OPENDETAIL') or (Fparam = 'OPENDOC') ;

  SetControlVisible('GRSALARIE',        Not Details);
  SetControlVisible('TPST_FORMATION1', (Not Details) And (GetCritereValue('CHPLIBRE1') <> ''));
  SetControlVisible('PST_FORMATION1',  (Not Details) And (GetCritereValue('CHPLIBRE1') <> ''));
  SetControlVisible('TPST_FORMATION2', (Not Details) And (GetCritereValue('CHPLIBRE2') <> ''));
  SetControlVisible('PST_FORMATION2',  (Not Details) And (GetCritereValue('CHPLIBRE2') <> ''));

  SetControlVisible('PANDETAIL',       Details);
  SetControlVisible('PAN_BOUTONS',     Details);
  SetControlVisible('BRETOUR',         Details);
  SetControlVisible('BPROGRAMME',      Details);
  SetControlVisible('TPROGRAMME',      Details);

  Result := true;
end;

{-----Chargement des donn�es -----------------------------------------------------------}

procedure PG_VIG_CATSTAGE.RecupDonnees;
begin
  inherited;
    If (Fparam = '') Then
    Begin
        InitialiseChampsLibres;
    End;

    // Ne rafra�chir la liste que sur le chargement de la vignette et les changements
    // de crit�res mais pas sur la s�lection dans la liste car elle est cach�e
    If (Fparam = 'OPENDETAIL') Then
    Begin
         OpenDetail;
         SetControlVisible('BMORE',   False);  //PT1
         SetControlVisible('PANRECHERCHE', False);
    End
    Else
    Begin
         AfficheListeStages;
         SetControlVisible('BMORE',   True);  //PT1
         SetControlVisible('PANRECHERCHE', (GetControlValue('LIBELLESTAGE')<>''));
    End;
end;

{-----Crit�re de la requ�te ------------------------------------------------------------}

procedure PG_VIG_CATSTAGE.GetClauseWhere;
begin
  inherited;
end;

{-----Affectation des controls/valeurs dans la TobRespons ------------------------------}

function PG_VIG_CATSTAGE.SetInterface: Boolean;
begin
  inherited SetInterface;
    result:=true;

    // Association de la TobDonnees avec la grille (celle par d�faut etant nomm�e GRSALARIE)
//    If Fparam <> 'OPENDETAIL' Then PutGridDetail('GRSALARIE', TobDonnees);
end;

{-----Formate les donn�es de la grille -------------------------------------------------}

procedure PG_VIG_CATSTAGE.DrawGrid (Grille: string);
begin
  inherited;
     SetFormatCol(Grille, 'NBHEURES', 'D 0 ---');  //PT1
     SetFormatCol(Grille, 'NATURE',   'C 0 ---');  //PT1
     SetWidthCol (Grille, 'CODESTAGE', -1);
     SetWidthCol (Grille, 'LIBELLE',   200);
     SetWidthCol (Grille, 'NATURE',    50);
     SetWidthCol (Grille, 'NBHEURES',  50);
end;

{-----Affichage des donn�es dans la grille ---------------------------------------------}

procedure PG_VIG_CATSTAGE.AfficheListeStages;
var
  StSQL   : String;
  DataTob,T : TOB;
  i       : Integer;
  Libelle : String;
  Dossier : String;
begin

  Try
    // Cr�ation de la TOB principale
    DataTob := TOB.Create('~TEMP', nil, -1);     

    // Liste des stages
    StSQL := 'SELECT PST_CODESTAGE, PST_LIBELLE, PST_LIBELLE1, PST_NATUREFORM, PST_DUREESTAGE FROM STAGE WHERE PST_ACTIF="X" AND PST_MILLESIME="0000"'; //PT2
    If GetControlValue('PST_FORMATION1') <> '' Then StSQL := StSQL + ' AND PST_FORMATION'+RightStr(GetCritereValue('CHPLIBRE1'),1)+'="'+GetControlValue('PST_FORMATION1')+'"';
    If GetControlValue('PST_FORMATION2') <> '' Then StSQL := StSQL + ' AND PST_FORMATION'+RightStr(GetCritereValue('CHPLIBRE2'),1)+'="'+GetControlValue('PST_FORMATION2')+'"';
    If GetControlValue('LIBELLESTAGE') <> ''   Then StSQL := StSQL + ' AND PST_LIBELLE LIKE "%'+GetControlValue('LIBELLESTAGE')+'%"'; //PT1
	If PGBundleCatalogue Then 
	Begin
		If PGDroitMultiForm Then Dossier := '' Else Dossier := V_PGI.NoDossier;
		StSQL := StSQL + DossiersAInterroger ('', Dossier, 'PST', True, True); //PT3
	End;
	
	//PT5 - D�but
	If GetCritereValue('TRILISTE') <> '' Then
		StSQL := StSQL + ' ORDER BY PST_'+GetCritereValue('TRILISTE')
	Else
    	StSQL := StSQL + ' ORDER BY PST_LIBELLE';
    //PT5 - Fin

    DataTob := OpenSelectInCache (StSQL);
    ConvertFieldValue(DataTob);

    For i:=0 To DataTob.Detail.Count-1 Do
    Begin
      T := TOB.Create('�REPONSE',TobDonnees,-1);
      Libelle := DataTob.Detail[i].GetValue('PST_LIBELLE');
      If DataTob.Detail[i].GetValue('PST_LIBELLE1') <> '' Then Libelle := Libelle + ' ' + DataTob.Detail[i].GetValue('PST_LIBELLE1'); //PT2
      T.AddChampSupValeur('CODESTAGE',    DataTob.Detail[i].GetValue('PST_CODESTAGE'));
      T.AddChampSupValeur('LIBELLE',      Libelle);
      T.AddChampSupValeur('NATURE',       RechDom('PGNATUREFORM',DataTob.Detail[i].GetValue('PST_NATUREFORM'),False));
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

procedure PG_VIG_CATSTAGE.OpenDoc;
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
     stage := GetControlValue('CODESTAGE');

     // Recherche du programme
     If Stage <> '' Then
     Begin
          StSQL := 'SELECT PST_BLOCNOTE FROM STAGE WHERE PST_CODESTAGE="'+Stage+'" AND PST_MILLESIME="0000"';
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
     end;
end;

{-----Action lanc�e sur double-clic dans la grille --------------------------------------}

procedure PG_VIG_CATSTAGE.OpenDetail;
Var
  Stage,StSQL : String;
  Q           : TQuery;
  i           : Integer;
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
               SetControlValue('TPST_STAGELIB', T.Detail[0].GetValue('LIBELLE'));
          End
          Else
          Begin
               Stage := '';
               SetControlValue('TPST_STAGELIB', '');
          End;
          // Sauvegarde du code stage pour le programme du stage qui s'effectue lors d'une autre action
          SetControlValue('CODESTAGE', Stage);

          // Recherche des �l�ments de d�tails
          If Stage <> '' Then
          Begin
               StSQL := 'SELECT PST_DUREESTAGE,PST_JOURSTAGE,PST_COUTBUDGETE,PST_COUTUNITAIRE,PST_CENTREFORMGU,PST_NATUREFORM,PST_FORMATION1,PST_FORMATION2,PST_FORMATION3,PST_FORMATION4 FROM STAGE WHERE PST_CODESTAGE="'+Stage+'" AND PST_MILLESIME="0000"';
               Q := OpenSQL(StSQL, True);
               If Not Q.EOF Then
               Begin
                    //If Q.FindField('PST_LIBELLE1').AsString <> '' Then  //PT1 //PT4
                    //    SetControlValue('TPST_STAGELIB', GetControlValue('TPST_STAGELIB') + ' ' + Q.FindField('PST_LIBELLE1').AsString);
                    SetControlValue('NBHEURES',   Q.FindField('PST_DUREESTAGE').AsString);
                    SetControlValue('NBJOURS',    Q.FindField('PST_JOURSTAGE').AsString);
                    SetControlValue('COUTPEDAG',  Q.FindField('PST_COUTBUDGETE').AsFloat);
                    SetControlValue('COUTFORFAIT',Q.FindField('PST_COUTUNITAIRE').AsFloat);
                    SetControlValue('NATURE',     RechDom('PGNATUREFORM',Q.FindField('PST_NATUREFORM').AsString,False));
                    SetControlValue('CENTREFORM', RechDom('PGCENTREFORMATION',Q.FindField('PST_CENTREFORMGU').AsString,False));
                    SetControlValue('FORMATION1', RechDom('PGFORMATION1',Q.FindField('PST_FORMATION1').AsString,False));
                    SetControlValue('FORMATION2', RechDom('PGFORMATION2',Q.FindField('PST_FORMATION2').AsString,False));
                    SetControlValue('FORMATION3', RechDom('PGFORMATION3',Q.FindField('PST_FORMATION3').AsString,False));
                    SetControlValue('FORMATION4', RechDom('PGFORMATION4',Q.FindField('PST_FORMATION4').AsString,False));
               End;
               Ferme (Q);

               // Emplois associ�s
               TobTemp := TOB.Create ('~TEMP', Nil, -1);
               DataTob := TOB.Create ('~EMPLOIS', Nil, -1);
               StSQL := 'SELECT PMF_LIBELLEEMPLOI FROM LIENEMPFORM WHERE PMF_CODESTAGE="'+Stage+'" AND PMF_ORDRE="-1"';
               TobTemp := OpenSelectInCache (StSQL);
               ConvertFieldValue(TobTemp);

               For i := 0 To TobTemp.Detail.Count - 1 Do
               Begin
                    T := TOB.Create('�EMPLOIS', DataTob, -1);
                    T.AddChampSupValeur('LIBELLEEMPLOI', RechDom('PGLIBEMPLOI',TobTemp.Detail[i].GetValue('PMF_LIBELLEEMPLOI'),False));
               End;

               PutGridDetail('GREMPLOIS', DataTob);
          End
          Else
               EffaceDetail;

          // Simuler une donn�e dans la Tob principale pour ne pas avoir le bandeau "La s�lection ne renvoie aucun enregistrement"
          T := TOB.Create('�DUMMY', TobDonnees, -1);
          T.AddChampSupValeur('CODESTAGE','000000');
          T.AddChampSupValeur('LIBELLE',  '');
          T.AddChampSupValeur('NATURE',   '');
          T.AddChampSupValeur('NBHEURES', '');

     Finally
          If Assigned(TobTemp) Then FreeAndNil (TobTemp);
          If Assigned(DataTob) Then FreeAndNil (DataTob);
     End;
end;

{-----Action lanc�e sur clic du bouton retour une fois dans l'�cran de d�tail --}

procedure PG_VIG_CATSTAGE.EffaceDetail;
Var DataTob : TOB;
begin
     { R.A.Z. des diff�rents champs pour que, lorsque l'on quitte le d�tail, les donn�es
       ne soient pas repass�es au serveur ce qui peut-�tre p�nalisant s'il y a du volume }
     SetControlValue('NBHEURES',   0);
     SetControlValue('NBJOURS',    0);
     SetControlValue('COUTPEDAG',  0);
     SetControlValue('COUTFORFAIT',0);
     SetControlValue('MEMO',       '');
     SetControlValue('CENTREFORM', '');
     SetControlValue('NATURE',     '');
     SetControlValue('FORMATION1', '');
     SetControlValue('FORMATION2', '');
     SetControlValue('FORMATION3', '');
     SetControlValue('FORMATION4', '');
     DataTob := TOB.Create ('~EMPLOIS', Nil, -1);
     PutGridDetail('GREMPLOIS', DataTob);
     If Assigned(DataTob) Then FreeAndNil (DataTob);
end;

{-----Met � jour les champs libres formation -----------------------------------}

procedure PG_VIG_CATSTAGE.InitialiseChampsLibres;
var i,NbLibres : Integer;
    {Sous-fonction : Affiche ou cache les champs libres formation du d�tail}
    procedure VisibiliteChampFormation(Numero: Integer; NomChamp: String);
    begin
        SetControlVisible('T'+NomChamp+IntToStr(Numero), Not (Numero > NbLibres));
        SetControlVisible(NomChamp+IntToStr(Numero),     Not (Numero > NbLibres));
        If Numero > NbLibres Then Exit;
        SetControlValue('T'+NomChamp+IntToStr(Numero), GetParamSoc('SO_PGFFORLIBRE'+IntToStr(Numero)));
    end;

    {Sous-fonction : Affiche ou cache les champs crit�res formation}
    procedure VisibiliteCriteresFormation(Numero: Integer; NomChamp: String);
    var Choix   : String;
        Visible : Boolean;
    begin
        Choix   := GetCritereValue('CHPLIBRE'+IntToStr(Numero));
        If Choix <> '' Then Choix := RightStr(Choix, 1);
        Visible := (Not (Numero > NbLibres)) And (Choix <> '');

        SetControlVisible('T'+NomChamp+IntToStr(Numero), Visible);
        SetControlVisible(NomChamp+IntToStr(Numero),     Visible);
        If Not Visible Then Exit;

        SetControlValue('T'+NomChamp+IntToStr(Numero), GetParamSoc('SO_PGFFORLIBRE'+Choix));

        // Mise � jour de la combo
        ChargeValeursCombo (Self, NomChamp+IntToStr(Numero), 'PGFORMATION'+Choix, '', True);
    end;
begin
    NbLibres := GetParamSoc('SO_PGFNBFORLIBRE');

    // D�tails
    For i:=1 To 4 Do
    Begin
        VisibiliteChampFormation (i, 'FORMATION');
    End;

    // Crit�res
    For i:=1 To 2 Do
    Begin
        VisibiliteCriteresFormation (i, 'PST_FORMATION');
    End;
end;
end.


