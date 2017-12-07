Unit UTofGCAff_Mul ;

interface

Uses uTofAfBaseCodeAffaire,Classes,HCtrls,HEnt1, Ent1, UTOF,EntGc,sysutils,HDB,paramsoc,StdCtrls
     // mng
     ,menus ,UtilGc, HTB97
{$IFDEF NOMADE}
     ,UtilPOP
{$ENDIF}
{$IFDEF BTP}
     ,facture
{$ENDIF}
{$IFDEF EAGLCLIENT}
      ,emul,MaineAgl,UtileAGL
{$ELSE}
			,fe_main,Mul
{$ENDIF}
      ;

Type
     TOF_GCAFF_MUL = Class (TOF_AFBASECODEAFFAIRE)
        procedure NomsChampsAffaire( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ; override ;
        procedure OnArgument(stArgument : String); override;
        procedure OnLoad ; override ;
        procedure PieceAddRemoveItemFromPopup(stPopup,stItem : string; bVisible : boolean);
{$IFDEF BTP}
        procedure BNewClick (Sender : TObject);
  		private
    		procedure FlisteDblClick(Sender: TObject);
{$ENDIF}
     END ;

     TOF_GCLigne_Mul = Class (TOF_AFBASECODEAFFAIRE)
     private
     public
        procedure OnArgument (Arguments : String ) ; override ;
        procedure NomsChampsAffaire( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ; override ;
    		procedure FlisteDblClick(Sender: TObject);
     END ;

function PlusNatureLIV : string;

implementation

function PlusNatureLIV : string;
begin
{$IFDEF BTP}
 Result := ' AND ((GPP_NATUREPIECEG="CBT") or (GPP_NATUREPIECEG="LBT")';
 Result:= Result +' )';
{$ENDIF}
end;

//************* TOF  TOF_GCLigne_Mul *******************************************
Procedure TOF_GCLigne_Mul.OnArgument (Arguments : String ) ;
Var CC : THValComboBox ;
    Critere ,Champ, valeur : string;
    x : integer;
    znum : Integer;
    znat : String;
{$IFDEF NOMADE}
{$IFDEF EAGLCLIENT}
    NatureDoc : THValComboBox;
{$ELSE}
    NatureDoc : THDBValComboBox;
{$ENDIF} //EAGLCLIENT
{$ENDIF} //NOMADE
begin
inherited ;
// gm le 4/5/02
Critere:=(Trim(ReadTokenSt(Arguments)));
znum := 0;
znat :='';
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
        	if Champ = 'NUMERO' then znum := strtoint(valeur);
          if Champ = 'NATURE' then znat := valeur;

        END;
    Critere:=(Trim(ReadTokenSt(Arguments)));
    END;

//gm le 4/5/02

if Not(ctxAffaire in V_PGI.PGIContexte) and Not(ctxGCAFF in V_PGI.PGIContexte) then SetControlVisible ('TGL_AFFAIRE', False);
CC:=THValComboBox(GetControl('GL_DOMAINE')) ; if CC<>Nil then PositionneDomaineUser(CC,True) ;
CC:=THValComboBox(GetControl('GL_ETABLISSEMENT')) ; if CC<>Nil then PositionneEtabUser(CC) ;
if not VH_GC.GCMultiDepots then
   begin
   SetControlVisible ('TGL_DEPOT', False);
   SetControlVisible ('GL_DEPOT', False);
   end;
{$IFDEF BTP}
   if (copy (Ecran.Name, 0, 11) = 'GCLIGNE_MUL') then
    begin
    THValComboBox(GetControl('GL_NATUREPIECEG')).Plus := PlusNatureLIV;
    SetControlText('GL_NATUREPIECEG','LBT');
    end else
{$ENDIF}
 if (ctxAffaire in V_PGI.PGIContexte)  then
    begin     // attention, ne marchera pas si ce mul est appelé pour autre chose que des Fact founisseur (pas le cas 20/11/01!)
    THValComboBox(GetControl('GL_NATUREPIECEG')).Plus := AfPlusNatureAchat;
    SetControlText('GL_NATUREPIECEG','FF');
    end;


// gm  5/4/2
	if (znum <> 0) then setcontroltext('GL_NUMERO',IntToStr(znum));
  if (znat <>'') then setcontroltext('GL_NATUREPIECEG',znat);

//gm 5/4/2

{$IFDEF NOMADE} //Limite nature des documents pour la sélection
{$IFDEF EAGLCLIENT}
NatureDoc := THValComboBox(GetControl('GL_NATUREPIECEG'));
{$ELSE}
NatureDoc := THDBValComboBox(GetControl('GL_NATUREPIECEG'));
{$ENDIF} //EAGLCLIENT
NatureDoc.Plus := GetNaturePOP('GPP_NATUREPIECEG');
{$ENDIF} //NOMADE
{$IFDEF CCS3}
if ctxGCAFF in V_PGI.PGIContexte then
  begin
  SetControlVisible('GL_AFFAIRE',False);
  SetControlVisible('GL_AFFAIRE1',False); SetControlVisible('GL_AFFAIRE2',False);
  SetControlVisible('GL_AFFAIRE3',False); SetControlVisible('GL_AVENANT',False);
  SetControlVisible('BSELECTAFF1',False); SetControlVisible('TGL_AFFAIRE',False);
  end;
{$ENDIF}
THdbGrid(GetCOntrol('FLISTE')).ondblclick := FlisteDblClick;
end;

Procedure TOF_GCLigne_Mul.NomsChampsAffaire ( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ;
BEGIN
Aff:=THEdit(GetControl('GL_AFFAIRE'))   ; Aff0:=Nil ;
Aff1:=THEdit(GetControl('GL_AFFAIRE1')) ; Aff2:=THEdit(GetControl('GL_AFFAIRE2')) ;
Aff3:=THEdit(GetControl('GL_AFFAIRE3')) ; Aff4:=THEdit(GetControl('GL_AVENANT'))  ;
// tiers non passé sur les écrans d'achats car non maj / tiers de l'affaire
if Pos('ACH',Ecran.Name)= 0 then Tiers:=THEdit(GetControl('GL_TIERS'));
END ;

//******************* TOF TOF_GCAFF_Mul  ***************************************

Procedure TOF_GCAFF_MUL.NomsChampsAffaire ( Var Aff,Aff0,Aff1,Aff2,Aff3,Aff4,Aff_,Aff0_,Aff1_,Aff2_,Aff3_,Aff4_,Tiers,Tiers_ : THEdit ) ;
BEGIN
Aff:=THEdit(GetControl('GP_AFFAIRE'))   ; Aff0:=Nil ;
Aff1:=THEdit(GetControl('GP_AFFAIRE1')) ; Aff2:=THEdit(GetControl('GP_AFFAIRE2')) ;
Aff3:=THEdit(GetControl('GP_AFFAIRE3')) ; Aff4:=THEdit(GetControl('GP_AVENANT'))  ;
// tiers non passé sur les écrans d'achats car non maj / tiers de l'affaire
if Pos('ACH',Ecran.Name)= 0 then Tiers:=THEdit(GetControl('GP_TIERS'))   ;
END ;

procedure TOF_GCAFF_MUL.OnArgument(stArgument : String);
Var CC : THValComboBox ;
    CC2 : THMultiValComboBox ;
    Visu : boolean ;
{$IFDEF BTP}
    NatureDoc : THMultiValComboBox;
    XX_WHERENAT : THedit;
    BNew : TToolbarButton97;
{$ELSE}
  {$IFDEF NOMADE}
  NatureDoc : THDBValComboBox;
  {$ENDIF} //NOMADE
{$ENDIF} //BTP
BEGIN
inherited;
Visu:=False ;
if (copy (Ecran.Name, 0, 11) = 'GCPIECE_MUL') or
   (copy (Ecran.Name, 0, 14) = 'GCPIECEACH_MUL') then
    begin
    if Pos('CONSULTATION',stArgument)>0 then
        begin
        Ecran.Caption := 'Consultation de pièces';
        if THCheckBox(getCOntrol('CONSULTATION')) <> nil then THCheckBox(getCOntrol('CONSULTATION')).Checked := true;
        Visu:=True ;
        end else
        begin
        Ecran.Caption := 'Modification de pièces';
        end;
    end;
UpdateCaption (Ecran);

THdbGrid(GetCOntrol('FLISTE')).ondblclick := FlisteDblClick;

if Not(ctxAffaire in V_PGI.PGIContexte) and Not(ctxGCAFF in V_PGI.PGIContexte)
   then
   BEGIN
   SetControlVisible ('TGP_AFFAIRE1', False);
   SetControlVisible ('GP_AFFAIRE1', False);
   SetControlVisible ('GP_AFFAIRE2', False);
   SetControlVisible ('GP_AFFAIRE3', False);
   SetControlVisible ('GP_AVENANT', False);
   END;
if (ctxAffaire in V_PGI.PGIContexte) and Not(ctxGCAFF in V_PGI.PGIContexte) then
   begin
   if (copy (Ecran.Name, 0, 14) = 'GCTRANSACH_MUL') or (copy (Ecran.Name, 0, 14) = 'GCPIECEACH_MUL') then
    begin     // attention, ne marchera pas si ce mul est appelé pour autre chose que des Fact founisseur (pas le cas 20/11/01!)
    THValComboBox(GetControl('GP_NATUREPIECEG')).Plus := AfPlusNatureAchat;
    SetControlText('GP_NATUREPIECEG','FF');
    end;
{$IFDEF BTP}
   if (copy (Ecran.Name, 0, 11) = 'GCPIECE_MUL') then
    begin
    THValComboBox(GetControl('GP_NATUREPIECEG')).Plus := PlusNatureLIV;
    SetControlText('GP_NATUREPIECEG','LBT');
    end;
{$ENDIF}
   end;
CC:=THValComboBox(GetControl('GP_DOMAINE')) ; if CC<>Nil then PositionneDomaineUser(CC,Visu) ;
CC2:=THMultiValComboBox(GetControl('GP_ETABLISSEMENT')) ; if CC2<>Nil then PositionneEtabUser(CC2);
if ctxmode in V_PGI.PGIContexte then
begin
  SetControlVisible ('SAISIECB', true);
  if (copy (Ecran.Name, 0, 14) = 'GCTRANSACH_MUL') and (stArgument = 'BLF') then
    SetControlProperty('GP_NATUREPIECEG','Plus', 'AND (GPP_NATUREPIECEG="ALF" OR GPP_NATUREPIECEG="CF")');
end;

{$IFDEF BTP}
{$IFDEF NOMADE}
  NatureDoc := THMultiValComboBox(GetControl('GP_NATUREPIECEG'));
{$ENDIF}
if (copy (Ecran.Name, 1, 14) = 'GCPIECEACH_MUL')  then
begin
  SetControlEnabled ('GP_NATUREPIECEG',true);
  BNew := TToolbarButton97 (GetControl('BInsert'));
  BNew.Visible := true;
  Bnew.onclick := BNewClick;
end;

if (copy (Ecran.Name, 1, 16) = 'GCTRANSPIECE_MUL')  then
begin
  SetControlEnabled ('GP_NATUREPIECEG',False);
  THDBValComboBox(GetControl('GP_NATUREPIECEG')).Plus := '';
end;

if (copy (Ecran.Name, 1, 14) = 'BTTRANSACH_MUL')  then
begin
  NatureDoc := THMultiValComboBox(GetControl('GP_NATUREPIECEG'));
  XX_WHERENAT := THEdit(GetControl('XX_WHERENAT'));
  if NatureDoc <> nil then
  begin
    if GetControlText('NEWNATURE') = 'CF' then
    begin
      NatureDoc.Plus  := ' AND (GPP_NATUREPIECEG="DEF") ';
      NatureDoc.enabled := False;
      XX_WHERENAT.Text  :='(GP_NATUREPIECEG="DEF")';
      THEdit(GetControl('GP_VIVANTE')).Text :='X';
    end;
    if GetControlText('NEWNATURE') = 'BLF' then
    begin
      NatureDoc.Plus  := ' AND ((GPP_NATUREPIECEG="CF") OR (GPP_NATUREPIECEG="CFR"))';
      XX_WHERENAT.Text  :='((GP_NATUREPIECEG="CF") OR (GP_NATUREPIECEG="CFR"))';
      THEdit(GetControl('GP_VIVANTE')).Text :='X';
    end;
    if GetControlText('NEWNATURE') = 'FF' then
    begin
      NatureDoc.Plus := ' AND ((GPP_NATUREPIECEG="CF") OR (GPP_NATUREPIECEG="CFR") OR (GPP_NATUREPIECEG="BLF") or (GPP_NATUREPIECEG="LFR"))';
      XX_WHERENAT.Text :='((GP_NATUREPIECEG="CF") OR (GP_NATUREPIECEG="CFR") OR (GP_NATUREPIECEG="BLF") or (GP_NATUREPIECEG="LFR"))';
      THEdit(GetControl('GP_VIVANTE')).Text:='X';
    end;
    if GetControlText('NEWNATURE') = 'BFA' then
    begin
      NatureDoc.Plus := ' AND (GPP_NATUREPIECEG="ALV")';
      XX_WHERENAT.Text :='GP_NATUREPIECEG="ALV"';
      THEdit(GetControl('GP_VIVANTE')).Text:='-';
    end;
  end;
end;
{$IFDEF NOMADE} //Limite nature des documents pour la sélection
NatureDoc.Plus := GetNaturePOP('GPP_NATUREPIECEG');
{$ENDIF} //NOMADE
{$ELSE}

{$IFDEF NOMADE} //Limite nature des documents pour la sélection
NatureDoc := THDBValComboBox(GetControl('GP_NATUREPIECEG'));
NatureDoc.Plus := GetNaturePOP('GPP_NATUREPIECEG');
{$ENDIF} //NOMADE
{$ENDIF}
{$IFDEF CCS3}
if ctxGCAFF in V_PGI.PGIContexte then
  begin
  SetControlVisible('GP_AFFAIRE',False);
  SetControlVisible('GP_AFFAIRE1',False); SetControlVisible('GP_AFFAIRE2',False);
  SetControlVisible('GP_AFFAIRE3',False); SetControlVisible('GP_AVENANT',False);
  SetControlVisible('BSELECTAFF1',False); SetControlVisible('TGP_AFFAIRE1',False);
  end;
{$ENDIF}
end;

{$IFDEF BTP}
procedure TOF_GCAFF_MUL.BNewClick(Sender: TObject);
begin
  CreerPiece(GetControlText('GP_NATUREPIECEG'),True) ;
end;

procedure TOF_GCAFF_MUL.FlisteDblClick(Sender: TObject);
Var StArg 				: String;
    ClePiece			: array [0..7] of Variant;
    TheChaine     : string;
		Fliste	: THDbGrid;
begin
		Fliste := THdbgrid(GetCOntrol('FLISTE'));
		if pos('BTTRANSACH_MUL',ecran.name) > 0 then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[5] := GetControlText('NEWNATURE');
      ClePiece[6] := TcheckBox(GetControl('SAISIECB')).checked;
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      AppelTransformePiece ([thechaine,ClePiece[5],ClePiece[6]],3);
    end else if pos('GCTRANSPIECE_MUL',ecran.name) > 0 then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[5] := GetControlText('NEWNATURE');
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      AppelTransformePiece ([thechaine,ClePiece[5],0],3);
    end else if pos('BTDUPLICPIECE_MUL',ecran.name) > 0 then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[5] := GetControlText('NEWNATURE');
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      AppelDupliquePiece ([thechaine,ClePiece[5]],2);
    end else if (pos('GCPIECE_MUL',ecran.name) > 0) or (pos('GCPIECEACH_MUL',ecran.name) > 0) then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
      ClePiece[5] := GetControlText('NEWNATURE');
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      if THCheckBox(getCOntrol('CONSULTATION')) <> nil then
      begin
				if THCheckBox(getCOntrol('CONSULTATION')).checked then
        begin
      		AppelPiece ([thechaine,'ACTION=CONSULTATION'],2);
        end else
        begin
      		AppelPiece ([thechaine,'ACTION=MODIFICATION'],2);
        end;
      end else
      begin
      	AppelPiece ([thechaine,'ACTION=MODIFICATION'],2);
      end;

    end else if pos('GCDUPLICPIECE_MUL',ecran.name) > 0 then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GP_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GP_INDICEG').AsString;
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      AppelDupliquePiece ([thechaine,GetControltext('NEWNATURE')],2);
    end;

    //
    if GetParamSocSecur('SO_REFRESHMUL', true) then TToolBarButton97(GetControl('Bcherche')).Click;

end;

{$ENDIF}

// mng
procedure TOF_GCAFF_MUL.OnLoad;
BEGIN
inherited;
if  (GetControlText('GP_NATUREPIECEG')<>'') and (GetInfoParPiece(GetControlText('GP_NATUREPIECEG'),'GPP_VENTEACHAT') ='ACH')  then
      SetControlProperty('GP_TIERS','DataType','GCTIERSFOURN') ;
if ( not (ctxGRC in V_PGI.PGIContexte)) or (GetControlText('GP_NATUREPIECEG') <> 'DE')  then
        PieceAddRemoveItemFromPopup ('POPMENUPIECE','MNZPROPOSITION',False);
if (ctxGRC in V_PGI.PGIContexte) and (GetControlText('GP_NATUREPIECEG') = 'DE')  then
        PieceAddRemoveItemFromPopup ('POPMENUPIECE','MNZPROPOSITION',True);

END;
procedure TOF_GCAFF_MUL.PieceAddRemoveItemFromPopup(stPopup,stItem : string; bVisible : boolean);     //PCS
var pop : TPopupMenu ;
    i : integer;
    st : string;
begin
pop :=TPopupMenu(GetControl(stPopup) ) ;
if pop<> nil  then
   for i:=0 to pop.items.count-1 do
       begin
       st:=uppercase(pop.items[i].name);
       if st=stItem then  begin pop.items[i].visible:=bVisible; break; end;
       end;
end ;

procedure TOF_GCLigne_Mul.FlisteDblClick(Sender: TObject);
Var StArg 				: String;
    ClePiece			: array [0..7] of Variant;
    TheChaine     : string;
		Fliste	: THDbGrid;
begin
		Fliste := THdbgrid(GetCOntrol('FLISTE'));
		if (pos('GCLIGNE_MUL',ecran.name) > 0) or (pos('GCLIGNEACH_MUL',ecran.name) > 0) then
    begin
      ClePiece[0] := Fliste.datasource.dataset.FindField('GL_NATUREPIECEG').asString;
      ClePiece[1] := DateTimeToStr(Fliste.datasource.dataset.FindField('GL_DATEPIECE').AsDateTime);
      ClePiece[2] := Fliste.datasource.dataset.FindField('GL_SOUCHE').AsString;
      ClePiece[3] := Fliste.datasource.dataset.FindField('GL_NUMERO').AsString;
      ClePiece[4] := Fliste.datasource.dataset.FindField('GL_INDICEG').AsString;
			TheChaine := ClePiece[0]+';'+ClePiece[1]+';'+ClePiece[2]+';'+ClePiece[3]+';'+ClePiece[4]+';';
      AppelPiece ([thechaine,'ACTION=CONSULTATION'],2);
    end;

    //
    if GetParamSocSecur('SO_REFRESHMUL', true) then TToolBarButton97(GetControl('Bcherche')).Click;

end;

Initialization
Registerclasses([TOF_GCAFF_MUL]) ;
registerclasses([TOF_GCLigne_Mul]);
end.
