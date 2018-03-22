{ Interface invocable IIISLSESign }

unit IISLSESignIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  TEnumTest = (etNone, etAFew, etSome, etAlot);

  TDoubleArray = array of Double;

  TMyEmployee = class(TRemotable)
  private
    FLastName: AnsiString;
    FFirstName: AnsiString;
    FSalary: Double;
  published
    property LastName: AnsiString read FLastName write FLastName;
    property FirstName: AnsiString read FFirstName write FFirstName;
    property Salary: Double read FSalary write FSalary;
  end;

  { Les interfaces invocables doivent d�river de IInvokable }
  IIISLSESign = interface(IInvokable)
  ['{4A1508A7-DC8B-4842-98D6-CAE1F85347F7}']

    { Les m�thodes de l'interface invocable ne doivent pas utiliser la convention }
    { d'appel par d�faut ; stdcall est conseill�e }
    function echoEnum(const Value: TEnumTest): TEnumTest; stdcall;
    function echoDoubleArray(const Value: TDoubleArray): TDoubleArray; stdcall;
    function echoMyEmployee(const Value: TMyEmployee): TMyEmployee; stdcall;
    function echoDouble(const Value: Double): Double; stdcall;
  end;

implementation

initialization
  { Les interfaces invocables doivent �tre recens�es }
  InvRegistry.RegisterInterface(TypeInfo(IIISLSESign));

end.
 