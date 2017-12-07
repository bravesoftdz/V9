{ Interface invocable IIISLSESeria }

unit IISLSESeriaIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type


  TSeriaDB = class(TRemotable)
  private
    FClient : AnsiString;
    FMethode : AnsiString;
    FDB : AnsiString;
    FDBID: integer;
    FDateAuth: TDateTime;
  published
    property ClientName: AnsiString read FClient write FClient;
    property Methode : AnsiString read FMethode write FMethode;
    property DB: AnsiString read FDB write FDB;
    property DBID: Integer read FDBID write FDBID;
    property DateAuth: TDateTime read FDateAuth write FDateAuth;
  end;

  TSeriaDBArray = array of TSeriaDB;

  { Les interfaces invocables doivent d�river de IInvokable }
  IIISLSESeria = interface(IInvokable)
  ['{684CFF55-C7B7-45D1-BFE8-39325DD88BF1}']

    { Les m�thodes de l'interface invocable ne doivent pas utiliser la convention }
    { d'appel par d�faut ; stdcall est conseill�e }
    function GetSeriaTiers(const CodeTiers : String): TSeriaDBArray; stdcall;
  end;

implementation

initialization
  { Les interfaces invocables doivent �tre recens�es }
  InvRegistry.RegisterInterface(TypeInfo(IIISLSESeria));

end.
 