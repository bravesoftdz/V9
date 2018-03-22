{***********A.G.L.Priv�.*****************************************
Auteur  ...... : RPALLIA
Cr�� le ...... : 06/02/2008
Modifi� le ... :   /  /
Description .. : Unit� permettant de modifier la structure des bases
Mots clefs ... :
*****************************************************************}
unit UModifStructure ;

interface

uses  HCtrls, Forms, Windows,
      SysUtils, HMsgBox,
      CBPPath,
      HEnt1, PGIAppli,
      Paramsoc;

procedure MajCodeNAF;


implementation
uses galSystem, EntDp,
{$IFDEF EAGLCLIENT}
     BobGestion,
{$ENDIF}
     galPatience;


//RP0 05/02/08 - MAJ Code NAF sur 5 caract�res
procedure  MajCodeNAF;
var
{$IFNDEF EAGLCLIENT}
    ScriptSql, ScriptSqlLoc, ScriptToUpload, ChemLog, ChemLogLoc, LigneCmd, User, Password: string;
{$ENDIF}
    F : TFPatience;
begin
    //Verification si la MAJ a d�j� �t� faite
    if ExisteSQL ('SELECT 1 FROM DETABLES WHERE DT_NOMTABLE="ANNUAIRE" AND DT_NUMVERSION < 174') = TRUE then
        begin
          try
            if not EstBloque('MAJCodeNAF', FALSE) and ((V_Applis<>Nil) and (V_Applis.Applis.Count<>0)) then
            begin
              Bloqueur('MAJCodeNAF', TRUE);

              {$IFNDEF EAGLCLIENT}
              // Chemin du script c�t� serveur
              ScriptSql := V_PGI.DatPath+'\SOCREF\Maj_CodeNAF.sql';
              // avec son chemin local vu par le serveur
              ScriptSqlLoc := GetParamSocSecur('SO_ENVPATHDATLOC', V_PGI.DatPath)+'\SOCREF\Maj_CodeNAF.sql';
              // Normalement le script ne peut pas �tre d�ploy� sur le serveur dans PGI01\DAT\SOCREF
              // donc on fait un upload depuis le r�pertoire STD\BUREAU local
              if Not FileExists(ScriptSQL) then
              begin
                ScriptToUpload := TCbpPath.GetCegidDistriStd+'\BUREAU\Maj_CodeNAF.sql';
                if FileExists(ScriptToUpload) then
                  try
                    ForceDirectories(V_PGI.DatPath+'\SOCREF');
                    CopyFile(PChar(ScriptToUpload), PChar(ScriptSQL), False);
                  except
                    on E:Exception do if V_PGI.SAV then PGIInfo(E.Message, 'T�l�chargement du script');
                  end;
              end;

              //ScriptSql := TCbpPath.GetCegidDistriStd+'\BUREAU\Maj_CodeNAF.sql';
              //ChemLog := TCbpPath.GetCegidDistriStd+'\BUREAU\Maj_CodeNAF_BaseCommune.log';
              ChemLog := V_PGI.DatPath + '\SOCREF\Maj_CodeNAF_BaseCommune.log';
              ChemLogLoc := GetParamSocSecur('SO_ENVPATHDATLOC', V_PGI.DatPath) + '\SOCREF\Maj_CodeNAF_BaseCommune.log';
              {$IFDEF DBXADO}
              User     := DBSOC.Params.Values['User_name'];
              Password := DBSOC.Params.Values['Password'];
              {$ELSE}
              User     := DBSOC.Params.Values['USER NAME'] ;
              Password := DBSOC.Params.Values['PASSWORD'] ;
              {$ENDIF}
              if FileExists(ScriptSql) then
              begin
                LigneCmd := // 'cmd /c echo Ne pas fermer cette fen�tre : mise � jour en cours...'
                  //  +' & '+ // => concat�nation en ligne de commande
                     'osql -S'+VH_DP.LeServeurSql
                     +' -d'+V_PGI.DbName
                     +' -U'+User
                     +' -P'+Password
                     +' -i"'+ScriptSqlLoc+'"'
                     +' -o"'+ChemLogLoc+'"'
                     +' -n';
                try
                  F := FenetrePatience('Mise � jour du Code NAF en cours, veuillez patientez...');
                  F.lCreation.Caption := 'Ex�cution du script Maj_CodeNAF.sql';
                  F.lAide.Caption     := 'sur la base commune '+V_PGI.DbName;
                  F.Invalidate;
                  Application.ProcessMessages;
                  // Ex�cution directe sur le serveur
                  ExecCmdShell(LigneCmd);
                Finally
                  if F<>Nil then begin F.Close; F.Free; end;
                end;
                if V_PGI.SAV then FileExecOrTop('notepad.exe '+ChemLog, False, True, False, '');
              end;

              {$ELSE}
              try
                F := FenetrePatience('Mise � jour du Code NAF en cours, veuillez patientez...');
                F.lCreation.Caption := 'Ex�cution du script Maj_CodeNAF.sql';
                F.lAide.Caption     := 'sur la base commune '+V_PGI.DbName;
                F.Invalidate;
                Application.ProcessMessages;
                // Ex�cution directe sur le serveur
                CWAS_EXECSCRIPTSQL('Maj_CodeNAF.sql', 'Maj_CodeNAF_BaseCommune.log', F, True);
              Finally
                if F<>Nil then begin F.Close; F.Free; end;
              end;
              {$ENDIF EAGLCLIENT}

            end; // fin if Not EstBloque

          finally
            if JaiBloque('MAJCodeNAF') then Bloqueur('MAJCodeNAF', FALSE);
          end;
    end;

end;

end.
