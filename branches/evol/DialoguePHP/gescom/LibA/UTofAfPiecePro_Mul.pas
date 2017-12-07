unit UTofAfPiecePro_Mul;
{*************************************************************************
  Validation des factures Provisoire en factures DEFINITIVE.
   Principe Multicrit�re avec Multi-S�lection Possible.
   En sortie de Mul:
   * je r�cup�re les factures � valider
   * La date de la facture (seulement si je souhaite qu'elle soit diff�rente

**************************************************************************}
interface                                 
uses
{$IFDEF EAGLCLIENT}
   eMul,Maineagl,
{$ELSE}
   Mul,Fe_Main, db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}HDB,DBGrids,
{$ENDIF}
      StdCtrls,Controls,Classes,forms,sysutils,ComCtrls, vierge,TiersUtil,
      HCtrls,HEnt1,HMsgBox,UTOF, AffaireUtil,Dicobtp,SaisUtil,M3FP,UTofAfBasePiece_Mul,
      Hstatus, Utob, FactGrp,UtilMulTrt,FactComm,UtofAfPiece,ParamSoc,EntGc;

       procedure AGLValidationFacture( Parms : array of variant ; nb : integer );
       Function CtrlDate(Zdat : string) : integer;
Type
     TOF_AFPIECEPRO_MUL = Class (TOF_AFBASEPIECE_MUL)
        procedure OnArgument(stArgument : String ) ; override ;
        procedure ValidationFacture ;
        procedure NaturePieceG_Change(Sender : TObject) ;
  private
     procedure ControleChamp(Champ, Valeur: String);
     END ;

Type
     TOF_AFPIECEPRO_VAL = Class (TOF)
     public
     		procedure OnArgument(stArgument : String ) ; override ;
        procedure OnClose ; override ;
        procedure OnUpdate ; override ;
     END ;

var titre : string;
    natglo : string;

implementation
//*****************************************************************************
//
//   TOF_AFPIECEPRO_MUL
//
//*****************************************************************************
procedure TOF_AFPIECEPRO_MUL.OnArgument(stArgument : String );
var Critere	: String;
    Champ		: String;
    valeur	: String;
    x				: Integer;
    zdeb		: Integer;
    zfin 		: integer;
Begin
	fMulDeTraitement := true;
Inherited;
	FTableName := 'PIECE';
	// Recup des crit�res
	titre:=ecran.caption;

	zdeb := 0;
	zfin := 0;

	Critere:=(Trim(ReadTokenSt(stArgument)));   // TABLE:GP;NATURE:FPR;NOCHANGE_NATUREPIECE

	While (Critere <>'') do
  	  Begin
    	if Critere<>'' then
      	 Begin
         X:=pos(':',Critere);
       	 if x=0 then X:=pos('=',Critere);
         if x<>0 then
            begin
            Champ :=copy(Critere,1,X-1);
            Valeur:=Copy (Critere,X+1,length(Critere)-X);
            end
         else
           Champ := Critere;
         ControleChamp(Champ, Valeur);
         Critere:=(Trim(ReadTokenSt(stArgument)));
    		 end;
      End;

	if ctxscot in V_PGI.Pgicontexte then
   	 begin
   	 SetControlVisible ('GP_REPRESENTANT',false);
   	 SetControlVisible ('TGP_REPRESENTANT',false);
   	 end;

	{$IFDEF BTP}
	//setControlProperty('GP_NATUREPIECEG','PLUS',' AND GPP_NATUREPIECEG="FPR"');
	{$ENDIF}
 	ThValCombobox(GetControl('GP_NATUREPIECEG')).OnChange := NaturePieceG_Change;

  // on ne peut pas mettre une multi-combo car ETATRISQUE est parfois � ''
  if VH_GC.GCIfDefCEGID then
    If GetControl('T_ETATRISQUE') <> Nil then
  	   begin
       SetControlTExt('T_ETATRISQUE','');
       SetControlProperty('T_ETATRISQUE','Operateur',Egal);
       end;

	UpdateCaption(Ecran);

End;

Procedure TOF_AFPIECEPRO_MUL.ControleChamp(Champ : String;Valeur : String);
var nat : string;
Begin

  if Champ = 'STATUT' then
     Begin
     Statut := Valeur;
     if valeur = 'APP' then
        Begin
        natglo :=  nat;
        SetControlText('AFF_AFFAIRE0', 'W');
        SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel');
        SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Appel');
        SetControlText('TGP_AFFAIRE', 'Appel');
        end
     Else if valeur = 'INT' then
          Begin
   			  If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
			    If (NatPiece<>nil)    then natglo :=  natpiece.value; // mcd 09/10/02
			    If (NatPieceMul<>nil) then nat :=  natpieceMul.text; // mcd 09/10/02
//          SetControlText('AFF_AFFAIRE0', 'I');
          SetCOntrolText ('XX_WHERE',' AND GP_GENERAUTO="CON"');
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Contrat');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Contrat');
          SetControlText('TGP_AFFAIRE', 'Contrat');
          end
     Else if valeur = 'AFF' then
          Begin
          If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
  			  If (NatPiece<>nil)    then natglo :=  natpiece.value; // mcd 09/10/02
			    If (NatPieceMul<>nil) then nat :=  natpieceMul.text; // mcd 09/10/02
          SetControlText('AFF_AFFAIRE0', 'A');
          {$IFDEF LINE}
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Affaire');
          SetControlText('TGP_AFFAIRE', 'Affaire');
          {$ELSE}
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Chantier');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Chantier');
          SetControlText('TGP_AFFAIRE', 'Chantier');
          {$ENDIF}
          end
     Else if valeur = 'GRP' then
          Begin
          //If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
  			  //If (NatPiece<>nil)    then natglo :=  natpiece.value; // mcd 09/10/02
			    //If (NatPieceMul<>nil) then nat :=  natpieceMul.text; // mcd 09/10/02
          nat :=  'FPR'; // mcd 09/10/02
  			  natglo :=  'FPR'; // mcd 09/10/02
          natpieceMul.text := nat;
          SetControltext('GP_NATUREPIECEG', 'FPR');
          SetControlText('AFF_AFFAIRE0', '');
          SetCOntrolText ('XX_WHERE',' AND SUBSTRING(GP_AFFAIRE,1,1) IN ("A","W")');
          {$IFDEF LINE}
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Affaire');
          SetControlText('TGP_AFFAIRE', 'Affaire');
          {$ELSE}
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Chantier');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Chantier');
          SetControlText('TGP_AFFAIRE', 'Chantier');
          {$ENDIF}
          end
     Else if valeur = 'PRO' then
          Begin
          If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
   			  If (NatPiece<>nil)    then natglo :=  natpiece.value; // mcd 09/10/02
			    If (NatPieceMul<>nil) then nat :=  natpieceMul.text; // mcd 09/10/02
          SetControlText('AFF_AFFAIRE0', 'P');
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Appel d''offre');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Appel d''offre');
          SetControlText('TGP_AFFAIRE', 'Appel d''offre');
          end
     else
          Begin
          If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
          If (NatPiece<>nil)    then natglo :=  natpiece.value; // mcd 09/10/02
			    If (NatPieceMul<>nil) then nat :=  natpieceMul.text; // mcd 09/10/02
          SetControlText('XX_WHERE', '');
          SetControlText('AFF_AFFAIRE0', '');
          SetControlProperty('BSELECTAFF1', 'Hint', 'Recherche Affaire');
          SetControlProperty('BEFFACEAFF1', 'Hint', 'Effacer Affaire');
          SetControlText('TGP_AFFAIRE', 'Affaire');
          end
     end
  Else if Champ = 'NATURE' then
     Begin
     if valeur = 'FSI' then
        Begin
			  SetControlEnabled('bouvrir',false);
		    Ecran.caption := 'Liste des factures simul�es';
        end
     else if Valeur = 'FAC' then
			  Ecran.caption := 'G�n�ration des avoirs "globaux"';
     end
  else if Champ = 'NUMDEB' then
		 if StrToInt(Valeur) <>0 then SetControlText('GP_NUMERO',valeur)
  else if Champ = 'NUMFIN' then
	   if StrToInt(Valeur) <>0 then SetControlText('GP_NUMERO_',valeur);

end;


procedure TOF_AFPIECEPRO_MUL.NaturePieceG_Change(Sender : TObject) ;
begin

If GetControltext('GP_NATUREPIECEG')='APR' then
  SetControlText('T_ETATRISQUE','')
else
  SetControlText('T_ETATRISQUE', 'R');

end;

procedure TOF_AFPIECEPRO_MUL.ValidationFacture ;
var  St,zdate ,Nat:string;
     wi:integer;
     TobCOmplete : TOB;
     zdeb : tdatetime;
     Batch : Boolean;
     CC : TcheckBox;
     req,CodeCLient : string;
begin

Repeat
// mcd 12/06/02Zdate :=AGLLanceFiche('AFF','AFPIECEPRO_VAL','','','ZZDATE:'+zdate)
if (natglo = 'FAC') then    // g�n�ration d'avoirs
  Zdate :=AFLanceFiche_Date_ValidPiecePro('ZZDATE:'+zdate+';ZZORI:AVC')
else
  Zdate :=AFLanceFiche_Date_ValidPiecePro('ZZDATE:'+zdate);
until (zdate = '0') or  ( ctrldate(zdate) = 0  );

if (zdate = '0') then
 begin
     PGIInfo('Traitement abandonn�',titre);
     exit;
   end
 else
 Begin
 		zdeb := StrToDate(zdate);
 End;

if (nat = 'FAC') then
  St:= 'Confirmez vous la validation de ces Avoirs au ' + zdate
else
  St:= 'Confirmez vous la validation de ces Factures au ' + zdate;


If (PGIAsk(st,titre)<> mrYes) then exit;
// Traitement par batch possible depuis la fiche
Batch := false;
CC := TCheckBox(GetControl('GENERBATCH'));
if CC <> Nil then Batch := CC.Checked;
// on cr�e une TOB de toutes les pieces s�lectionn�es
TobComplete := TOB.Create ('Liste des pieces',NIL, -1);


// mcd 29/07/02 plus OK avec ajout t_ferme Req :=  'SELECT P.* FROM PIECE AS P LEFT OUTER JOIN AFFAIRE ON AFF_AFFAIRE =GP_AFFAIRE';
// mcd 19/09/02 Req :=  'SELECT P.* FROM PIECE AS P LEFT OUTER JOIN AFFAIRE ON AFF_AFFAIRE =GP_AFFAIRE LEFT OUTER JOIN TIERS ON T_TIERS=GP_TIERS';
Req :=  'SELECT P.* FROM PIECE P LEFT OUTER JOIN AFFAIRE ON AFF_AFFAIRE =GP_AFFAIRE LEFT OUTER JOIN TIERS ON T_TIERS=GP_TIERS';
// PA le 26/09/2001 - Fonction de traitement des enreg du mul externalis�e
TraiteEnregMulTable(TFMul(Ecran),req,'GP_NATUREPIECEG;GP_SOUCHE;GP_NUMERO;GP_INDICEG','PIECE', 'GP_NUMERO','AFPIECEAFFAIRE',TobComplete, True);
//AddLesSupEntete (TOBComplete);


     // on appelle la fct g�n�rique de validation des facture
If (NatPiece<>nil)    then nat :=  natpiece.value; // mcd 09/10/02
If (NatPieceMul<>nil)    then nat :=  natpieceMul.value; // mcd 09/10/02
// mcd ajout 21/10/02 on regarde si le tiers est en risque client ==> on ne traite pas
if (GetInfoParPiece(nat,'GPP_ENCOURS')='X') and (GetInfoParPiece(nat,'GPP_ESTAVOIR')<>'X') then  //mcd 20/11/02 idem saisie piece
 begin
 for wi:=0 to  TobComplete.Detail.count-1 do
    begin
    CodeClient:=TobComplete.detail[wi].Getvalue('GP_TIERS');
    if GetEtatRisqueClient (CodeClient)='R'
        then  TobComplete.detail[wi].free;
    end;
 end;

if (nat = 'APR') then
    // pour les avoirs
  begin
  if (zdeb <> idate1900) then
    RegroupeLesPieces (TObCOmplete,'AVC',True, False,False,0,zdeb,True,False,Batch)
  else
    RegroupeLesPieces (TObCOmplete,'AVC',True, False,False,0,0,True,False,Batch);
  end
else
  if (nat = 'FPR') then
    // pour les factures
    begin
    if (zdeb <> idate1900) then
      RegroupeLesPieces (TObCOmplete,'FAC',True, False,False,0,zdeb,True,False,Batch)     //GMGM
    else
      RegroupeLesPieces (TObCOmplete,'FAC',True, False,False,0,0,True,False,Batch);       //GMGM
    end
  else
    // pour les factures en avoir
    begin
    if (zdeb <> idate1900) then
      RegroupeLesPieces (TObCOmplete,'AVC',True, False,False,0,zdeb,True,False,Batch)     //GMGM
    else
      RegroupeLesPieces (TObCOmplete,'AVC',True, False,False,0,0,True,False,Batch);       //GMGM
    end;



TobComplete.free;

end;


//*****************************************************************************
//
//   TOF_AFPIECEPRO_VAL  : Saisie date d�finitive
//
//*****************************************************************************

procedure TOF_AFPIECEPRO_Val.OnArgument(stArgument : String );
Var Critere, Champ, valeur  : String;
    x : integer;
    zdateD,Zori: string;

begin
Inherited;
  zdated := '';
  // Recup des crit�res
  Critere:=(Trim(ReadTokenSt(stArgument)));
  While (Critere <>'') do
      BEGIN
      if Critere<>'' then
          BEGIN
          X:=pos(':',Critere);
          if x<>0 then
             begin
             Champ:=copy(Critere,1,X-1);
             Valeur:=Copy (Critere,X+1,length(Critere)-X);
             end;
          if Champ = 'ZZDATE' then ZDateD := Valeur;
          if Champ = 'ZZORI'  then ZOri := Valeur;
          END;
      Critere:=(Trim(ReadTokenSt(stArgument)));
      END;

  if ((ZDateD = '') and (getcontroltext('ZZDATE') <> '')) then
     ZDateD :=  getcontroltext('ZZDATE');

  if (ZDateD = '') then
    ZDateD := DateToStr(V_PGI.DateEntree);

  SetControlText('ZZDATE',zdateD);

  if (zori = 'AVC' ) then // avoirs globaux
  begin
    SetControlText('TZZDATE','Les avoirs seront g�n�r�s � la date du');
  end;

END;


procedure TOF_AFPIECEPRO_Val.OnUpdate;
Var
  ST  : String;
	Ret : integer;
              
begin
  inherited ;
  st := GetControlText('ZZDATE');
  ret:= CtrlDate(st);
  if (ret = 1) then PGIInfo('la date saisie n''est pas valide',titre)
  else
  Begin
    if (ret = 2) then PGIInfo('la date saisie n''est pas dans un exercice ouvert',titre);
    if (ret = 3) then PGIInfo('la date saisie est inf�rieure � la date d''arr�t� de p�riode',titre);
  End;
end;                   

procedure TOF_AFPIECEPRO_Val.OnClose;
begin
inherited ;
if (ctrldate(getcontroltext('ZZDATE')) = 0)  then
  TfVierge(Ecran).retour :=  getcontroltext('ZZDATE')
else
  TfVierge(Ecran).retour :=  '0';

End;


Function CtrlDate(Zdat : string) : integer;
begin
result := 0;

if not(IsValidDate(Zdat)) then
  Begin
    result := 1;
  End
else
    Begin
    if (ControleDate(Zdat) > 0) then
         Begin
    	result := 2;
        End
  else   if (StrToDAte(Zdat) <> Idate1900) and (ctxscot in V_PGI.PGIContexte)
    and (StrToDAte(Zdat) < GetParamSoc('So_AFDATEDEBUTACT')) then result:=3;  //mcd 09/08/02 bloque si < arr�t� p�riode
  End;
end;
//*****************************************************************************
//
//  FIN
//
//*****************************************************************************

procedure AGLValidationFacture( Parms : array of variant ; nb : integer );
var  F : TForm;
     LaTof : TOF;
BEGIN

F:=TForm(Longint(Parms[0])) ;

if (F is TFmul) then
	LaTof:=TFMul(F).LaTOF
else
	exit;

if (LaTof is TOF_AfPiecePro_Mul) then
	TOF_AfPiecePro_Mul(LaTof).ValidationFacture
else
    exit;

END;

procedure InitAfPiecePro();
begin
RegisterAglProc('ValidationFacture',True,1,AGLValidationFacture);
end;

Initialization
registerclasses([TOF_AFPIECEPRO_MUL]);
registerclasses([TOF_AFPIECEPRO_VAL]);
InitAfPiecePro();
// report modif PCS 13/05/03 Finalization
end.










