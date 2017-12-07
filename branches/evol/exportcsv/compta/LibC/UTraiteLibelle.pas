unit UTraiteLibelle;

interface

uses
    Windows,
    Messages,
    SysUtils,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
{$IFDEF EAGLCLIENT}
{$ELSE}
    {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF}
{$ENDIF}
    Vierge,
    HSysMenu,
    HTB97,
    StdCtrls,
    Hctrls,
    HPanel,
    UiUtil,
    HStatus,
    hmsgbox,
    UTob,
    HEnt1, UTobView, ExtCtrls, Mask, ed_Tools, ImgList;


type
  TFTraiteLibelle = class(TFVierge)
    iml_Liste: TImageList;
    MsgBox: THMsgBox;
    TobViewer1: TTobViewer;
    Panel1: TPanel;
    PPARAM: TGroupBox;
    PGEN: TCheckBox;
    PTIERS: TCheckBox;
    PSectionana: TCheckBox;
    PJRL: TCheckBox;
    PEcriture: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ChoixTraite: THValComboBox;
    Label2: TLabel;
    FCar: THCritMaskEdit;
    PAbrege: TCheckBox;
    Label3: TLabel;
    CRemplace: THCritMaskEdit;
    Label4: TLabel;
    Premplace: THCritMaskEdit;
    Supaccens: TCheckBox;
    procedure BValiderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BFermeClick(Sender: TObject);
    procedure ChoixTraiteChange(Sender: TObject);
  private
    function  Traitement (Table, Ext, Order : string; Champ : string='LIBELLE') : Boolean;
    procedure ModifCarAccentue (var St : String );
    procedure ModifCarAccentueMajMin (var St : String );
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  FTraiteLibelle: TFTraiteLibelle;

Procedure TraitementLibelle ;

implementation

{$R *.DFM}

{=======================================================================================}
Procedure TraitementLibelle ;
var
  PP : THPanel;
begin
  FTraiteLibelle := TFTraiteLibelle.Create(Application);
  PP:=FindInsidePanel ;
  if PP=Nil then begin
    try
      FTraiteLibelle.ShowModal;
    finally
      FTraiteLibelle.Free;
    end;
    end
  else begin
    InitInside(FTraiteLibelle,PP) ;
    FTraiteLibelle.Show ;
  end;
end;

procedure  TFTraiteLibelle.ModifCarAccentue (var St : String );
var
p : integer;
BEGIN
// fiche 20949
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'E'; end until not (p > 0);


repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'A'; end until not (p > 0);


repeat begin p := Pos('�',St); if p >0 then St[p] := 'C'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'C'; end until not (p > 0);

repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'U'; end until not (p > 0);


repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'I'; end until not (p > 0);

repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := 'O'; end until not (p > 0);


END ;

procedure  TFTraiteLibelle.ModifCarAccentueMajMin (var St : String );
var
p : integer;
BEGIN

repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);


repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);


repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);

repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);

repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);

repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);
repeat begin p := Pos('�',St); if p >0 then St[p] := '�'; end until not (p > 0);

END ;


{=======================================================================================}
function TFTraiteLibelle.Traitement (Table, Ext, Order : string; Champ : string='LIBELLE') : Boolean;
var
Q1               : TQuery;
Libelle, Lib, x  : string;
i, ij, cj, p     : integer;
ChaineRech : string;
TLib,TL,TJRL     : TOB;
Annulation       : Boolean;
Where            : string;
begin
 Result := False;
 TJRL := nil;
 if (Ext = 'E_')  and  (PAbrege.Checked) then exit;

(*
 if PAbrege.Checked then
    Champ := 'ABREGE'
 else
    Champ := 'LIBELLE';
 *)
 Annulation := FALSE;

 ChaineRech := FCar.Text;
 if Ext = 'E_' then
 begin
    Q1   :=OpenSQL('SELECT J_JOURNAL FROM JOURNAL',TRUE);
    TJRL := TOB.Create('', nil, -1);
    TJRL.LoadDetailDB('JOURNAL', '', '', Q1, TRUE, TRUE);
    cj := TJRL.detail.count;
    Ferme(Q1);
 end
 else cj := 1;

 TextProgressForm ('Travail en cours ... Veuillez patienter ...');
 for ij := 0 to  cj-1 do
 begin
       if Ext = 'E_' then
       begin
           Where := ' Where E_JOURNAL="'+ TJRL.detail[ij].GetValue('J_JOURNAL')+'" ';
           MoveCurProgressForm('Journal : '+ TJRL.detail[ij].GetValue('J_JOURNAL'))
       end
       else Where := '';

       TLib := TOB.Create('', nil, -1);
       Q1 :=OpenSQL('SELECT * FROM ' + Table + Where + Order,TRUE) ;
       TLib.LoadDetailDB(TABLE, '', '', Q1, TRUE, FALSE);
       Ferme(Q1);

       try
          BeginTrans ;
          for  i :=0  to  TLib.detail.count-1 do
          begin
                 TL  := TLib.detail[i];
                 Lib := TL.GetValue(Ext+Champ);
                 Libelle := lib;
                 if not (MoveCurProgressForm ('')) then
                              Annulation := TRUE;
                 if Libelle <> '' then
                 begin
                      case  ChoixTraite.value[1] of
                       '1' :
                           begin
                                Libelle := AnsiUpperCase(Lib);
                                if Supaccens.Checked then ModifCarAccentue(Libelle);
                           end;
                       '2' :
                          begin
                                Libelle := LowerCase (Lib);  ModifCarAccentueMajMin(Libelle);
                          end;
                       '3' : Libelle := AnsiUpperCase(Lib[1])+ LowerCase(Copy(Lib,2, length(Lib)));
                       '4' : // suppression d'une chaine
                         begin
                                x := ReadTokenPipe (Lib, ChaineRech);
                                if x <> '' then Libelle := x
                                else if (x = '') and (Lib <> '') then
                                   Libelle := Lib;
                                while x <> '' do
                                begin
                                     x := ReadTokenPipe (Lib, ChaineRech);
                                     if x <> '' then
                                        Libelle := Libelle + x;
                                end;
                         end;
                         '5' :  // rempla�er une chaine
                         begin
                          repeat
                             p := Pos(CRemplace.Text, Lib);
                             Libelle := lib;
                             if p >0 then
                             begin
                                  Libelle := Copy (Lib, 0, p-1) + Premplace.Text +
                                  Copy (Lib, p+length(Cremplace.Text), length(Lib));
                                  lib := Libelle;
                             end;
                          until  (p = 0);
                         end;
                       end;
                 end;
                 TL.PutValue(Ext+Champ, Libelle);
                 TL.UpdateDB(FALSE, TRUE);
                 if Annulation then break;
           end;
       finally
           if TLib <> nil then
                TLib.free;
           if not Annulation then commitTrans
           else  RollBack ;
       end;
       if Annulation then break;
 end; // for
 Result := (not Annulation);
end;

{=======================================================================================}
procedure TFTraiteLibelle.BValiderClick(Sender: TObject);
var count : integer;
var Q1    : TQuery;
OkTraitement : Boolean;
begin
  inherited;

count := 0;
if (PGIAsk('Vous allez modifier d�finitivement les libell�s.#13#10Confirmez vous le traitement ?', '') <> mrYes) then exit;
if PGEN.Checked then
begin
 Q1   :=OpenSQL('SELECT count(*) FROM GENERAUX',TRUE);
 count := Q1.Fields[0].asinteger;
 Ferme(Q1);
end;
if PTIERS.Checked then
begin
 Q1   :=OpenSQL('SELECT count(*) FROM TIERS',TRUE);
 count := count + Q1.Fields[0].asinteger;
 Ferme(Q1);
end;
if PSectionana.Checked then
begin
 Q1   :=OpenSQL('SELECT count(*) FROM SECTION',TRUE);
 count := count + Q1.Fields[0].asinteger;
 Ferme(Q1);
end;
if PJRL.Checked then
begin
 Q1   :=OpenSQL('SELECT count(*) FROM JOURNAL',TRUE);
 count := count + Q1.Fields[0].asinteger;
 Ferme(Q1);
end;
if PEcriture.Checked then
begin
 Q1   :=OpenSQL('SELECT count(*) FROM ECRITURE',TRUE);
 count := count + Q1.Fields[0].asinteger;
 Ferme(Q1);
end;

InitMoveProgressForm (nil, 'Traitement des libell�s ', 'Traitement en cours ...', count, TRUE, TRUE) ;
OkTraitement := TRUE;
if PGEN.Checked and OkTraitement then
begin
     if PAbrege.Checked then
        Traitement ('GENERAUX', 'G_', '', 'ABREGE');
     OkTraitement := Traitement ('GENERAUX', 'G_','');
end;

if PTIERS.Checked and OkTraitement then
begin
     if PAbrege.Checked then
        Traitement ('TIERS', 'T_', '', 'ABREGE');
     OkTraitement := Traitement ('TIERS', 'T_', '');
end;

if PSectionana.Checked and OkTraitement then
begin
     if PAbrege.Checked then
        Traitement ('SECTION', 'S_', '', 'ABREGE');
     OkTraitement := Traitement ('SECTION', 'S_', '');
end;

if PJRL.Checked and OkTraitement then
begin
     if PAbrege.Checked then
        Traitement ('JOURNAL', 'J_', '','ABREGE');
     OkTraitement := Traitement ('JOURNAL', 'J_', '');
end;

if PEcriture.Checked and OkTraitement then
     Traitement ('ECRITURE', 'E_', ' ORDER BY E_JOURNAL, E_EXERCICE, E_DATECOMPTABLE, E_NUMEROPIECE, E_NUMLIGNE, E_NUMECHE, E_QUALIFPIECE');

FiniMoveProgressForm;

end;

{=======================================================================================}
procedure TFTraiteLibelle.FormShow(Sender: TObject);
begin
  inherited;
end;

{=======================================================================================}
procedure TFTraiteLibelle.BFermeClick(Sender: TObject);
begin
  inherited;
Close ;
end;

procedure TFTraiteLibelle.ChoixTraiteChange(Sender: TObject);
begin
  inherited;
if ChoixTraite.value[1] = '4' then
begin
  FCar.Enabled   := TRUE;
  Label2.Enabled := TRUE;
end
else
begin
  FCar.Enabled   := FALSE;
  Label2.Enabled := FALSE;
end;

if ChoixTraite.value[1] = '5' then
begin
  CRemplace.Enabled := TRUE;
  Label3.Enabled    := TRUE;
  Label4.Enabled    := TRUE;
  PRemplace.Enabled := TRUE;
end
else
begin
  CRemplace.Enabled := FALSE;
  Label3.Enabled    := FALSE;
  Label4.Enabled    := FALSE;
  PRemplace.Enabled := FALSE;
end;
if ChoixTraite.value[1] = '1' then
  Supaccens.Enabled := TRUE
else
begin
  Supaccens.Enabled := FALSE;
  Supaccens.Checked := FALSE;
end;

end;

end.
