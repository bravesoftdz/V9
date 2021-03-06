{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 27/03/2006
Modifi� le ... :   /  /
Description .. : lancement de la mise a jour en rafale en mode multisoc
Mots clefs ... : MULTISOC
*****************************************************************}
Unit MajEnRafale ;

Interface

Uses StdCtrls,
     Controls,
     Classes,
{$IFDEF VER150} {D7}
  Variants,
{$ENDIF}
{$IFNDEF EAGLCLIENT}
     db,fe_main,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
     majtable,
{$else}
     UtileAGL,
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     Grids,
     HEnt1,galSystem  ,
     PGIAppli,
     HMsgBox, HTB97,HPanel, HsysMenu,
     UTOF,
     UTOB,
     uMultiDossier,
     uMultiDossierUtil ;

function Traitement(libdoss: String; var compteur: Integer ; toMinutes : integer): Boolean;
procedure MiseAJourEnRafale;
procedure Affiche(msg: String);
function Okrafale : integer;
Function  GetBasesMSLogique (CodeRegroupement : string = ''; BaseSql : boolean = True) : String ;

var lancetrtrafale:integer; //-1:cancel,0:non,1:oui

Implementation

Uses MajhalleyUtil, wCommuns, MajSocParLot_Tof,utilpgi;

Const NomExec = 'PGIMajVer.exe';

Function OkRafale : Integer;
Var Regroupement, ListeBases, UneBase :String;
Begin
  LanceTrtRafale := 0;
  If TableExiste('YMULTIDOSSIER') Then Regroupement := GetBasesMSLogique( '##MULTISOC', True );

  If (Regroupement <> '') Then
  Begin
{    UneBase := ReadTokenSt(Regroupement);
    While (UneBase <> '') Do
    Begin
      If ListeBases <> '' then ListeBases := ListeBases + ', ';
      ListeBases := ListeBases + Unebase + ' (vrs ' + IntToStr(VersionBase(UneBase)) +')';
      UneBase := ReadTokenSt(Regroupement);
    End;}
// JS1 161007 : on n'oblige plus le mode SAV pour le msg   If V_PGI.SAV Then et on n'affiche plus la liste
//    Begin
      If IsMonoOuCommune Then
        Case PGIASKCANCEL( chr(13)+
                           'Vous �tes en configuration multi-soci�t�s.'+chr(13)
                         + 'Voulez-vous effectuer la mise � jour en s�rie pour toutes les bases du regroupement ?'+chr(13)
                         + 'Oui : toutes les bases du regroupement seront trait�es'+chr(13)
                         + 'Non : le traitement ne se d�roulera que sur la base courante'+chr(13)
                         + 'Annuler : aucun traitement ne sera effectu�.') Of
            mrYes     : LanceTrtRafale := 1;
            mrNo      : LanceTrtRafale := 0;
            mrCancel  : LanceTrtRafale := -1;
        End
      Else
        Case PGIASKCANCEL( 'Attention, vous �tes en configuration '
                         + 'multi-soci�t�s et vous �tes sur une base d�pendante :'
                         + ' souhaitez-vous la mettre � jour (d�conseill�) ?') Of
            mrYes     : LanceTrtRafale := 1;
            mrNo      : LanceTrtRafale := 0;
            mrCancel  : LanceTrtRafale := -1;
        End;
    End
    Else
      If IsMonoOuCommune Then LanceTrtRafale := 1
      Else
        PGIBOX( 'Vous �tes sur une base d�pendante, mise � jour impossible : ' + Chr(13) +
                'Vous devez imp�rativement lancer la mise � jour sur la base commmune' );
//  End;
  Result := LanceTrtRafale;
End;

procedure MiseAJourEnRafale;
var ListSoc,UneBase:String;
    nberr : Integer;
    cpteur, nberrtot, tominutes : Integer;
begin

  if lancetrtrafale = 1 then
  begin
    nberr := 0;
    nberrtot := 10;
    tominutes := 60;

    ListSoc := GetBasesMSLogique ('##MULTISOC', true);

    UneBase:=ReadTokenSt(ListSoc);
    begin
      While (Unebase <> '') do
      begin

          if not Traitement(UneBase, cpteur, tominutes) then nberr := nberr+1;

          if nberr>nberrtot then
          begin
            affiche('Le nombre d''�checs de traitement est ');
            affiche('sup�rieur � la tol�rance ('+IntToStr(nberrtot)+')');
            lancetrtrafale:=-1;
            break;
          end;
          UneBase:=ReadTokenSt(ListSoc);
      end;
    end;
  end;
  lancetrtrafale := 0;
end;

function  Traitement(libdoss: String; var compteur: Integer ; toMinutes : integer): Boolean;
var VDoss: Variant;
    lgcde : String;
    Stop:boolean;
begin
  Result := False;

  Affiche(IntToStr(compteur)+'. Mise � jour du dossier '+libdoss+' � '+TimeToStr(Now));
  PutToDebugLog(IntToStr(compteur)+'. Mise � jour du dossier '+libdoss+' � '+TimeToStr(Now),True);

  compteur := compteur + 1;

  VDoss := VersionBase(libdoss);
  if VDoss = -1 then exit;
  if V_PGI.NumVersionSocRef  = VDoss then
  begin
    affiche('--> Dossier '+libdoss+' � jour.');
    Result := True;
    exit;
  end;

  lgcde := ExtractFilePath(Application.ExeName) + NomExec;

  lgcde := lgcde + ' /USER='+V_PGI.UserLogin+' /PASSWORD='+V_PGI.Password+' /DATE='+DateToStr(V_PGI.DateEntree)+' /DOSSIER='+libdoss+' /MAJSTRUCTURE=TRUE /MAJSTRUCTAUTO=TRUE';

  affiche(lgcde);

  FileExecAndWaitUntil(lgcde, tominutes, Stop);

  if Stop then
  begin
    affiche('Traitement interrompu par l''utilisateur');
    exit;
  end;
  // V�rifie version de la base obtenue
  VDoss := VersionBase(libdoss);
  if V_PGI.NumVersionSocRef = VDoss then affiche('--> Dossier '+libdoss+' � jour.')
  else
  begin
    affiche('La version du dossier '+libdoss+' est '+IntToStr(VDoss)+' au lieu de '+IntToStr(V_PGI.NumVersionSocRef));
    affiche('Echec, ou mise � jour pas encore termin�e pour ce dossier...');
    exit;
  end;
  Result := True;
end;

procedure Affiche(msg: String);
begin
  LogAgl('***  ' + msg + '  ***');
  PutToDebugLog(msg,True);
end;

Function GetBasesMSLogique (CodeRegroupement : string = ''; BaseSql : boolean = True) : String ;
var lQMD     : TQuery ;
    lTSData  : TStringList ;
    lStVal   : String ;
    lStBase  : String ;
begin

  result := '' ;

  if CodeRegroupement = '' then CodeRegroupement := MS_CODEREGROUPEMENT;

  // r�cup�ration param�trage du regroupement
  lStVal := '' ;
  lQMD   := OpenSQL('SELECT * FROM YMULTIDOSSIER WHERE YMD_CODE = "' + CodeRegroupement + '"', True ) ;
  if not lQMD.Eof then
    lStVal := lQMD.FindField('YMD_DETAILS').AsString ;
  Ferme( lQMD ) ;
  if lStVal = '' then Exit ;

  // R�cup�ration 1�re ligne
  lTSData      := TStringList.Create ;
  lTSData.Text := lStVal ;
  lStVal       := lTSData.Strings[0] ;

  // On ne garde que le nom des bases
  while lStVal<>'' do
    begin
    lStBase := ReadTokenSt( lStVal ) ;
//    if BaseSql then
//    begin
      result := result + wLeft(lstBase,pos('|',lstBase)-1) + ';';
//    end else
//      result  := result + ReadTokenPipe( lStBase , '|' ) + ';' ;
    end ;

  FreeAndNil( lTSData ) ;

end ;

end.
