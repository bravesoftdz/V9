{***********UNITE*********************************************************************
Auteur  ...... : NA
Cr�� le ...... : 02/04/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : AFFECTSALPOPUL ()
                  Affectation des salari�s � une population pour un type de population
Mots clefs ... : TOF;AFFECTSALPOPUL
*************************************************************************************}
Unit AFFECTSALPOPUL_TOF ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     mul,
{$else}
     eMul, 
{$ENDIF}
     uTob,
     forms,
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox,
     pgpopuloutils,
     UTOF ; 

Type
  TOF_AFFECTSALPOPUL = Class (TOF)
    procedure OnNew                    ; override ;
    procedure OnDelete                 ; override ;
    procedure OnUpdate                 ; override ;
    procedure OnLoad                   ; override ;
    procedure OnArgument (S : String ) ; override ;
    procedure OnDisplay                ; override ;
    procedure OnClose                  ; override ;
    procedure OnCancel                 ; override ;
  private
    TempTypPop : String;
    SendAsIndependantForm : Boolean;
  end ;

Implementation

uses
  Vierge, ed_tools, Entpaie;

procedure TOF_AFFECTSALPOPUL.OnNew ;
begin
  Inherited ;
end ;

procedure TOF_AFFECTSALPOPUL.OnDelete ;
begin
  Inherited ;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 02/04/2007
Modifi� le ... :   /  /    
Description .. : Contr�le des types de population
Mots clefs ... : 
*****************************************************************}
procedure TOF_AFFECTSALPOPUL.OnUpdate ;
var
    Typepop, Typepopulation, St,salarie, nomsal,prenomsal : string; // ,sql2
    anomalie : boolean; //  trtok,
    wdateaffect : Tdatetime;
    QQ : Tquery;
    Listanomalies : Tlistbox;
    UpdateIdemPop : TUpdateIdemPop;
    retourFiche : String;
    tmpStrList : TStringList;
    tobSalariepopul : Tob;
begin
  Inherited ;
  retourFiche := 'False';
//  trtok := true;
  anomalie := false;
  Typepop := Getcontroltext('TYPEPOPUL');
  Typepopulation := Typepop;

  if (Typepop = '<<Tous>>') or (Typepop = '') then
  begin
    PGIBox('Le type de population doit �tre renseign�. ', Ecran.caption);
    setcontroltext('TYPEPOPUL', ' ');
    setfocuscontrol('TYPEPOPUL');
    lasterror := 1;
    exit;
  end;

  if ValidPopulParametres(Typepop) then
    retourFiche := 'True'
  else begin
    retourFiche := 'False';
    PGIBox('Le param�trage des populations n''est pas valide.#10#13'
    +'Vous devez v�rifier l''unicit� et l''exhaustivit� de votre param�trage pour les crit�res choisis.#10#13#10#13'
    +'Vous ne pouvez pas utiliser cette fonctionnalit�.',Ecran.Caption);
    lasterror := 1;
    exit;
  end;

      // Traitement de l'initialisation
//  Case PGIAskCancel('Le traitement d''affectation des salari�s � une population pour chaque type s�lectionn� #10#13'+
//                     ' va �tre effectu�, voulez vous continuer ?' ,Ecran.Caption) of
//        mrYes   : trtok := true;
//        mrCancel: trtok := false;
//        mrNo    : trtok := false;
//  end;
//  if trtok then
//  begin

  wdateaffect :=  StrToDate(getcontroltext('DATEAFFECT'));
  QQ:= opensql('select PSA_SALARIE,PSA_LIBELLE,PSA_PRENOM from SALARIES where (PSA_DATESORTIE'+
  ' >="'+usdatetime(wdateaffect)+'" or PSA_DATESORTIE <="'+UsdateTime(Idate1900)+'" OR PSA_DATESORTIE IS NULL)'+
  ' and (PSA_DATEENTREE <= "'+usdatetime(wdateaffect)+'")', true);

  InitMoveProgressForm(nil,Ecran.caption, TraduireMemoire('Validation en cours, veuillez patienter...'), QQ.RecordCount + 1, False, true) ;
  MoveCurProgressForm(TraduireMemoire('Affectation'));

  listanomalies := TListbox(Getcontrol('LISTEANOMALIES'));
  listanomalies.Items.clear;

  // cr�ation des affectations dans SALARIEPOPUL
  typepop := typepopulation;
  St := ReadTokenSt(Typepop);
  While (St <> '') do
  Begin
    // Appel de la proc�dure d'affectation
    UpdateIdemPop := TUpdateIdemPop.Create;
    tmpStrList := UpdateIdemPop.MajSALARIEPOPUL(st,wdateaffect);
    listanomalies.Items.AddStrings(tmpStrList);
    FreeAndNil(tmpStrList);
    UpdateIdemPop.Free;
    St := ReadTokenSt(Typepop);
  end;
  // recherche si des salari�s sont exclus pour affichage dans la page "Anomalies"
  // recherche des salari�s pr�sents � la date saisie

  //Chargement de salariepopul
  tobSalariepopul := Tob.Create('donn�es de salariepopul',nil,-1);
  tobSalariepopul.LoadDetailFromSQL('select PNA_SALARIE, PNA_TYPEPOP from SALARIEPOPUL');

  While Not QQ.Eof Do
  begin
    MoveCurProgressForm(TraduireMemoire('Recherche des anomalies'));
    typepop := typepopulation;
    St := ReadTokenSt(Typepop);
    salarie := QQ.findfield('PSA_SALARIE').asstring;
    nomsal :=  QQ.findfield('PSA_LIBELLE').asstring;
    prenomsal := QQ.findfield('PSA_PRENOM').asstring;
    While (St <> '') do
    Begin
      if St <> 'HAB' then
      begin
        if not Assigned(tobSalariepopul.FindFirst(['PNA_SALARIE','PNA_TYPEPOP'],[salarie,st],False)) then
//        sql2:= 'select PNA_SALARIE from SALARIEPOPUL WHERE PNA_SALARIE = "'+salarie+'" and PNA_TYPEPOP = "'+st+'"';
//        if not existesql(sql2) then
        begin
        // Affichage dans page anomalies
        listanomalies.items.Add('le salari� ' + salarie + ' ' + nomsal + ' ' + prenomsal+ ' est exclu des populations de type' +' ' + st);
        anomalie := true;
        end;
      end;
      St := ReadTokenSt(Typepop);
    end;
   QQ.next;
  end;
  ferme(QQ);
  FreeAndNil(tobSalariepopul);
  FiniMoveProgressForm;
  if anomalie = false then
    PgiInfo('Traitement termin�.','Affectation des salari�s')
  else begin
    PgiInfo('Traitement termin�. Il y a des anomalies.','Affectation des salari�s');
    (GetControl('PAGES') as TPageControl).ActivePageIndex := 1;
  end;
//  end;
  (Ecran as  TFVierge).Retour := retourFiche;
  if SendAsIndependantForm and (anomalie = false) then Ecran.Close;// else LastError := 1;
end ;

procedure TOF_AFFECTSALPOPUL.OnLoad ;
begin
  Inherited ;
  SetControlText('TYPEPOPUL',TempTypPop);
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 02/04/2007
Modifi� le ... :   /  /
Description .. : On argument
Mots clefs ... :
*****************************************************************}
procedure TOF_AFFECTSALPOPUL.OnArgument (S : String ) ;
var
stplus : string;
begin
  Inherited ;
  stplus := '';
  if not VH_PAIE.PGSeriaFormation then stplus := ' AND CO_CODE <> "FOR"';
  if not VH_PAIE.PGSeriaPresence then  stplus := stplus + ' AND CO_CODE <> "PRE"';
  if stplus <> '' then SetControlProperty('TYPEPOPUL', 'Plus', stplus);


  if S <> '' then SendAsIndependantForm := True else SendAsIndependantForm := False;
  TempTypPop := Trim(ReadTokenPipe(S, ';')); //On r�cup�re les types de populations a pr�-choisir

end ;

procedure TOF_AFFECTSALPOPUL.OnClose ;
begin
  Inherited ;
end ;

procedure TOF_AFFECTSALPOPUL.OnDisplay () ;
begin
  Inherited ;
end ;

procedure TOF_AFFECTSALPOPUL.OnCancel () ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOF_AFFECTSALPOPUL ] ) ; 
end.
