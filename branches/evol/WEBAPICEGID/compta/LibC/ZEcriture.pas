unit zEcriture;

interface

uses
     uTob,
     SaisUtil, // Tobm
  {$IFNDEF EAGLCLIENT}
     db,
     dbtables,
  {$ENDIF}
     HCtrls,
     HEnt1,
     Ent1,
     UControlCP,
     Dialogs,
     SysUtils, // Memcheck
     ZJournal,
     ZCompte,
     ULibEcriture,
     ZTiers;


Type
  TZEcritureCtx = ( cVPeriodeEcr,
                    cVJournalEcr,
                    cVCompteEcr,
                    cVLettrableEcr,
                    cVEcheanceEcr,
                    cVAnalatytiqEcr,
                    cCPeriodeEcr,
                    cCJournalEcr,
                    cCCompteEcr,
                    cCLettrableEcr,
                    cCEcheanceEcr,
                    cCAnalatytiqEcr);

  TZEcriture = class (TOB)
   private
    FTobErreur : Tob;
    FTobErrLet : Tob;
    FTobSection : Tob;
    FZListJournal : TZListJournal ;
    FZCompte : TZCompte;
    FZTiers : TZTiers;

    FStGeneral : string;
    FStAuxiliaire : string;
    FIndiceGeneral : integer;
    FindiceAuxiliaire : integer;
    FBoMaj : Boolean;
    FBoPasAna : Boolean;

    // V�rification et correction du couple P�riode / Semaine
    // OK CORRECTION
    procedure VPeriode( i : integer );

    // V�rification et correction de Ecriture/Journal
    // OK CORRECTION
    procedure VJournalEcr( i : integer ; vJModeSaisie : string ; vJNatureJal : string );

    // V�rification du compte g�n�ral et auxiliaire de l' �criture
    procedure VCompteEcr( i : integer );

    // V�rification des �critures lettrables sur un compte non lettrable
    procedure VLettrableEcr( i : integer );

    // V�rification de l'�cheance par rapport au param�trage
    procedure VEcheance( i : integer );

    // Chargement de l' analytique de l' �criture
    procedure ChargeAnalytique( vTobEcr : Tob );

    // V�rification de l' Analytiq
    procedure Analytique ( vTobEcr : Tob );

  public
    FZEcritureCtx : array of TZEcritureCtx ;
    FBoParle : Boolean;
    FBoStop : Boolean;

    // Variables globales de l'objet
    constructor Create;
    destructor Destroy; override;
    // Proc�dure de contr�le ou de v�rification � la ligne
    procedure AjouteCtx ( vZEcritureCtx : TZEcritureCtx );
    // Proc�dure de contr�le � la pi�ce
    procedure Execute;

  end;

implementation

{ TZEcriture }

constructor TZEcriture.Create;
begin
  inherited Create('',nil,-1);
  FTobErreur := Tob.Create('', nil, -1);
  FTobErrLet := Tob.Create('', nil, -1);
  FZListJournal := TZListJournal.Create;
  FZCompte := TZCompte.Create( False );
  FZTiers := TZTiers.Create;

  // Teste de l'existence de l'analityq dans la compta
  FBoPasAna := not (ExisteSql('Select Y_GENERAL from ANALYTIQ order by Y_GENERAL'));

  if not FBoPasAna then
  begin
    FTobSection  := Tob.Create('', nil, -1);
    FTobSection.LoadDetailDB('SECTION', '', '', nil, False );
  end;

  // Variable d' arret de l' objet
  FBoStop := False;

end;

destructor TZEcriture.Destroy;
begin
  FreeNil( FTobErreur );
  FreeNil( FTobErrLet );
  FreeNil( FTobSection );
  FreeNil( FZListJournal );
  FreeNil( FZCompte );
  FreeNil( FZTiers );

  inherited;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 11/03/2002
Modifi� le ... :   /  /
Description .. : Parcours la pi�ce afin de traiter chaque �criture
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.Execute;
var i,j : integer;
    lJModeSaisie : string;
    lJNatureJAl : string;
    lOkJournal : Boolean;
begin
  lOkJournal := False;
  lJModeSaisie := '';
  lJNatureJal  := '';
  i := 0;

  if (FZListJournal.Load([Tobm(Detail[0]).GetValue('E_JOURNAL')]) >=0) then
  begin
    lJModeSaisie := FZListJournal.GetValue('J_MODESAISIE');
    lJNatureJal  := FZListJournal.GetValue('J_NATUREJAL');
    lOkJournal   := True;
  end;

  for j := Low( FZEcritureCtx ) to High( FZEcritureCtx ) do
  begin
    if FZEcritureCtx[j] = cVJournalEcr then
    begin
      if Trim(Tobm(Detail[0]).GetValue('E_JOURNAL')) = '' then
        AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Le champ E_JOURNAL n''est pas renseign�'), FBoParle)
      else
      begin
        if not lOkJournal then
          AjouteErreurMvt( Detail[0], FTobErreur, TraduireMemoire('Le code journal n''existe pas'), FBoParle);
      end;
    end;
  end;

  for i := 0 to Detail.Count - 1 do
  begin
    // Demande d'arr�t du traitement de l'objet
    if FBoStop then Exit;

    // R�cup�ration de l' indice du compte g�n�ral dans le FZCompte
    FStGeneral := Tobm( Detail[i] ).GetMvt('E_GENERAL');
    FIndiceGeneral := FZCompte.GetCompte( FStGeneral );

    // R�cup�ration de l' indice du compte auxiliaire dans le FZTiers
    FStAuxiliaire := Tobm( Detail[i] ).GetMvt('E_AUXILIAIRE');
    FIndiceAuxiliaire := FZTiers.GetCompte( FStAuxiliaire, False );

    // Parcours du Tableau des contextes
    for j := Low( FZEcritureCtx ) to High( FZEcritureCtx ) do
    begin
      case FZEcritureCtx[j] of

        cVPeriodeEcr,
        cCPeriodeEcr : begin
                         FBoMaj := (FZEcritureCtx[j] = cCPeriodeEcr);
                         VPeriode(i);
                       end;

        cVJournalEcr,
        cCJournalEcr : begin
                         FBoMaj := (FZEcritureCtx[j] = cCJournalEcr);
                         if lOkJournal then VJournalEcr(i, lJModeSaisie, lJNatureJal);
                       end;

        cVCompteEcr,
        cCCompteEcr  : begin
                         FBoMaj := (FZEcritureCtx[j] = cCCompteEcr);
                         VCompteEcr(i);
                       end;

        cVLettrableEcr,
        cCLettrableEcr : begin
                           FBoMaj := (FZEcritureCtx[j] = cCLettrableEcr);
                           VLettrableEcr(i);
                         end;

        cVEcheanceEcr,
        cCEcheanceEcr : begin
                          FBoMaj := (FZEcritureCtx[j] = CCEcheanceEcr);
                          VEcheance(i);
                        end;

        cVAnalatytiqEcr,
        cCAnalatytiqEcr : begin
                            FBoMaj := (FZEcritureCtx[j] = cCAnalatytiqEcr);
                            Analytique( Tobm(Detail[i]) );
                          end;

        else FBoMaj := False;
      end;
    end;

    if Tobm(Detail[i]).Modifie then
      Tobm(Detail[i]).UpdateDB;

  end;

  // Enregistrement de la liste d'erreurs dans le journal d'erreur sur les mouvements
  if (not FBoParle) then
  begin
    if (FTobErreur.Detail.Count > 0) then
      SauveErreur( cNomRapportMvt, FTobErreur );
    if (FTobErrLet.Detail.Count > 0) then
      SauveErreur( cNomRapportLet, FTobErrLet );
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 22/03/2002
Modifi� le ... :   /  /
Description .. : Ajoute des �l�ments dans le contexte du ZEcriture,
Suite ........ : pour demander d' effectuer le traitement lors du
Suite ........ : ZEcriture.Execute
Suite ........ :
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.AjouteCtx(vZEcritureCtx : TZEcritureCtx);
begin
  SetLength(FZEcritureCtx,Length(FZEcritureCtx)+1);
  FZEcritureCtx[high(FZEcritureCtx)] := vZEcritureCtx;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification et Correction du couple P�riode / Semaine
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.VPeriode( i : integer );
begin
  if not(Tobm(Detail[i]).OkPeriodeSemaine) then
  begin
    if not FBoMaj then
      AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Erreur dans le champ E_PERIODE/E_SEMAINE'), FBoParle)
    else
      Tobm(Detail[i]).DateComptable := Tobm(Detail[i]).GetValue('E_DATECOMPTABLE');
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification et Correction de Ecriture/Journal
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.VJournalEcr(i : integer ; vJModeSaisie : string ; vJNatureJal : string );
begin
  if not Tobm(Detail[i]).OkEcrANouveau( vJNatureJal ) then
    if not FBoMaj then
      AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Le champ E_ECRANOUVEAU n''est pas coh�rent avec le journal'), FBoParle);

  if not Tobm(Detail[i]).OkModeSaisie( vJModeSaisie ) then
  begin
    if not FBoMaj then
      AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Le champ E_MODESAISIE n''est pas coh�rent avec le journal'), FBoParle)
    else
      if (vJModeSaisie <> '') then
        Tobm(Detail[i]).ModeSaisie := vJModeSaisie;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification du compte g�n�ral et auxiliaire de l' �criture
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.VCompteEcr(i: integer);
var lBoCollectif : Boolean;
    lStAuxiliaire : string;
begin
  if FIndiceGeneral <> -1 then
  begin
    lBoCollectif := FZCompte.IsCollectif( FIndiceGeneral );
    lStAuxiliaire := Tobm(Detail[i]).GetMvt('E_AUXILIAIRE');

    if (lBoCollectif) then
    begin
      if FZTiers.GetCompte( lStAuxiliaire, False) = -1 then
        if not FBoMaj then
        begin
          if Trim( lStAuxiliaire ) = '' then
            AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_AUXILIAIRE : Le champ n''est pas renseign�'), FBoParle)
          else
            AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_AUXILIAIRE : Le compte auxiliaire n''existe pas'), FBoParle);
        end;
    end
    else
    begin
      if Trim(lStAuxiliaire) <> '' then
        if not FBoMaj then
          AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_AUXILIAIRE : Le compte auxiliaire ne devrait pas �tre renseign�'), FBoParle)
        else
          Tobm(Detail[i]).PutMvt('E_AUXILIAIRE','');
    end;
  end
  else
    if not FBoMaj then
      AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_GENERAL : Le compte g�n�ral n''existe pas'), FBoParle);
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification des �critures lettrables sur un compte non
Suite ........ : lettrable
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.VLettrableEcr(i: integer);
var
  //lBoGeneCollectif : Boolean;
  lBoGeneLettrable : Boolean;
  lStEcrEtatLettrage : string;
  lStNatureGene : string;
begin
  if FIndiceGeneral = -1 then Exit;

  lStNatureGene := FZCompte.GetValue('G_NATUREGENE', FIndiceGeneral);
  //lBoGeneCollectif := FZCompte.IsCollectif( FIndiceGeneral );
  lBoGeneLettrable := FZCompte.IsLettrable( FIndiceGeneral );
  lStEcrEtatLettrage := Tobm(Detail[i]).GetMvt('E_ETATLETTRAGE');

  if (lStNatureGene = 'TIC') or (lStNatureGene = 'TID') then
  begin
    if (not lBoGeneLettrable) and (lStEcrEtatLettrage <> 'RI') then
    begin
      if not FBoMaj then
        AjouteErreurLet( Detail[i], FTobErrLet, TraduireMemoire('Champ E_ETATLETTRAGE : incoh�rence n�1 avec la nature du compte g�n�ral' + FStGeneral), FBoParle);
    end;

    if lBoGeneLettrable and ( lStEcrEtatLettrage = 'RI' ) then
    begin
      if not FBoMaj then
        AjouteErreurLet( Detail[i], FTobErrLet, TraduireMemoire('Champ E_ETATLETTRAGE : incoh�rence n�2 avec la nature du compte g�n�ral' + FStGeneral), FBoParle);
    end;

  end
  else
    if (lStNatureGene = 'COC') or (lStNatureGene = 'COD') or
       (lStNatureGene = 'COF') or (lStNatureGene = 'COS') then
    begin
      if FIndiceAuxiliaire = -1 then Exit;

      if (FZTiers.GetValue('T_LETTRABLE', FIndiceAuxiliaire) = '-') and (lStEcrEtatLettrage <> 'RI') then
      begin
        if not FBoMaj then
        AjouteErreurLet( Detail[i], FTobErrLet, TraduireMemoire('Champ E_ETATLETTRAGE : incoh�rence n�1 avec la nature du compte auxiliaire' + FStAuxiliaire), FBoParle);
      end;

      if (FZTiers.GetValue('T_LETTRABLE', FIndiceAuxiliaire) = 'X') and (lStEcrEtatLettrage = 'RI') then
      begin
        if not FBoMaj then
        AjouteErreurLet( Detail[i], FTobErrLet, TraduireMemoire('Champ E_ETATLETTRAGE : incoh�rence n�2 avec la nature du compte auxiliaire' + FStAuxiliaire), FBoParle);
      end;

    end
    else
    begin
      if (lStEcrEtatLettrage <> 'RI') then
      begin
        if not FBoMaj then
          AjouteErreurLet( Detail[i], FTobErrLet, TraduireMemoire('Champ E_ETATLETTRAGE : incoh�rence n�3 avec la nature du compte g�n�ral' + FStGeneral), FBoParle);
      end;

    end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification de l'�cheance par rapport au param�trage
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.VEcheance(i: integer);
var lBoEche : Boolean;
    lStAuxiliaire : string;
    lIndiceTiers : integer;
begin
  if FIndiceGeneral = -1 then Exit;

  lBoEche := Tobm(Detail[i]).GetMvt('E_ECHE') = 'X';
  if FZCompte.IsCollectif( FIndiceGeneral ) then
  begin
    // Le compte est collectif, il faut v�rifier T_LETTRABLE
    lStAuxiliaire := Tobm(Detail[i]).GetMvt('E_AUXILIAIRE');
    lIndiceTiers := FZTiers.GetCompte( lStAuxiliaire, False );
    if lIndiceTiers <> -1 then
    begin
      if (lBoEche and (FZTiers.GetValue('T_LETTRABLE',lIndiceTiers) = '-')) or
         (not lBoEche and (FZTiers.GetValue('T_LETTRABLE',lIndiceTiers) = 'X')) then
      begin
        if not FBoMaj then
          AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_ECHE : incoh�rence avec le compte auxiliaire ' + lStAuxiliaire), FBoParle)
        else
          Detail[i].PutValue('E_ECHE', FZTiers.GetValue('T_LETTRABLE',lIndiceTiers));
      end;
    end;
  end
  else
  begin
    if not lBoEche and ( (FZCompte.GetValue('G_LETTRABLE', FIndiceGeneral ) = 'X') or
                         ( (FZCompte.GetValue('G_POINTABLE', FIndiceGeneral ) = 'X') and
                           ( (FZCompte.GetValue('G_NATUREGENE',FIndiceGeneral ) = 'BQE') or
                             (FZCompte.GetValue('G_NATUREGENE',FIndiceGeneral ) = 'CAI')
                           )
                         )
                       ) then
    begin
      if not FBoMaj then
        AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_ECHE : incoh�rence avec le compte g�n�ral ' + FStGeneral), FBoParle)
      else
        Detail[i].PutValue('E_ECHE','X');
    end;

    if lBoEche and ((FZCompte.GetValue('G_LETTRABLE', FIndiceGeneral ) = '-') and
                    (FZCompte.GetValue('G_POINTABLE', FIndiceGeneral ) = '-')) then
    begin
      if not FBoMaj then
        AjouteErreurMvt( Detail[i], FTobErreur, TraduireMemoire('Champ E_ECHE : incoh�rence avec le compte g�n�ral ' + FStGeneral), FBoParle)
      else
        Detail[i].PutValue('E_ECHE','-');
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 03/04/2002
Modifi� le ... :   /  /
Description .. : Charge l' analytique pour l' �criture pass�e en param�tre
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.ChargeAnalytique(vTobEcr: Tob);
var j : integer;
    lSqlAna : TQuery;
    lTAxe : TOB;
begin
  for j := 1 to MAXAXE do
  begin
    lTAxe := Tob.Create('A' + IntToStr(j), vTobEcr, -1);
    lSqlAna := nil;
    try
      lSqlAna := OpenSql('Select * from ANALYTIQ where ' +
                         'Y_EXERCICE = "' + Tobm(vTobEcr).GetMvt('E_EXERCICE') + '" and ' +
                         'Y_JOURNAL = "' + Tobm(vTobEcr).GetMvt('E_JOURNAL') + '" and ' +
                         'Y_DATECOMPTABLE = "' + UsDateTime(StrToDate(Tobm(vTobEcr).GetMvt('E_DATECOMPTABLE'))) + '" and ' +
                         'Y_NUMEROPIECE = ' + IntToStr(Tobm(vTobEcr).GetMvt('E_NUMEROPIECE')) + ' and ' +
                         'Y_NUMLIGNE = ' + IntToStr(Tobm(vTobEcr).GetMvt('E_NUMLIGNE')) + ' and ' +
                         'Y_QUALIFPIECE = "' + Tobm(vTobEcr).GetMvt('E_QUALIFPIECE') + '" and ' +
                         'Y_AXE = "' + 'A' + IntToStr(j) + '" order by Y_NUMVENTIL', True);

      if not lSqlAna.IsEmpty then
        lTAxe.LoadDetailDB('', '', '', lSqlAna, False);
    finally
      FreeNil( lSqlAna );
    end;
  end;
end;

{***********A.G.L.***********************************************
Auteur  ...... : Gilles COSTE
Cr�� le ...... : 28/03/2002
Modifi� le ... :   /  /
Description .. : V�rification de l' analytique
Mots clefs ... :
*****************************************************************}
procedure TZEcriture.Analytique(vTobEcr : Tob);
var lBoVentilable : Boolean;
    j,k : integer;
begin
  if (FBoPasAna) or (FIndiceGeneral = -1) then Exit;

  lBoVentilable := FZCompte.GetValue('G_VENTILABLE', FIndiceGeneral ) = 'X';

  if (lBoVentilable and (Tobm(vTobEcr).GetMvt('E_ANA') <> 'X')) or
     (not lBoVentilable and (Tobm(vTobEcr).GetMvt('E_ANA') = 'X')) then
  begin
    if not FBoMaj then
    begin
      AjouteErreurMvt( vTobEcr, FTobErreur, TraduireMemoire('Champ E_ANA : incoh�rence avec le compte g�n�ral ' + FStGeneral), FBoParle);
      Exit;
    end;
  end;

  // Tous est ok, on charge l'analytique de l' �criture
  ChargeAnalytique( vTobEcr );

  for j := 0 to vTobEcr.Detail.Count -1 do
  begin
    //showmessage('dans j' + intToStr(j));
    for k := 0 to vTobEcr.Detail[j].Detail.Count -1 do
    begin
      //showmessage('dans k' + intToStr(k));
      if FTobSection.FindFirst(['S_SECTION'], [vTobEcr.Detail[j].Detail[k].GetValue('Y_SECTION')],False) = nil then
      begin
        if not FBoMaj then
          AjouteErreurMvt( vTobEcr, FTobErreur, TraduireMemoire('Champ Y_SECTION : La section n''existe pas'), FBoParle);
      end;
    end;
  end;

end;

end.
