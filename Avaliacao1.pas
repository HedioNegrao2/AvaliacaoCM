unit Avaliacao1;

interface

uses
  System.Generics.Collections, System.SysUtils;

type

  TBusca = class
  private
    FLista: TList<string>;
    FDicionario: TDictionary<Integer,string>;
    FResultado: string;
  public
    property Lista: TList<string> read FLista;

    procedure InicializarListas;
    function Encontrou(pValor: string): Boolean;
    function Resultado: string;


    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;



  end;

implementation

{ TBusca }
uses
  System.Diagnostics, System.TimeSpan;

procedure TBusca.AfterConstruction;
begin
  inherited;
  FLista :=  TList<string>.Create;
  FDicionario :=  TDictionary<Integer,string>.Create();
end;

procedure TBusca.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FLista);
  FreeAndNil(FDicionario);
end;

function TBusca.Encontrou(pValor: string): Boolean;
var
  indice: Integer;
  tempo: TStopWatch;
  valor: string;
  i: Integer;
  sb: TStringBuilder;
begin
  sb := TStringBuilder.Create;
  try
    tempo := TStopWatch.Create;
    tempo.Start;
    indice := FLista.IndexOf(pValor);
    tempo.Stop;
    Result :=  indice >= 0;
    sb.Append('Indexof: '+tempo.Elapsed.TotalMilliseconds.ToString);
    sb.AppendLine;
    tempo := TStopWatch.Create;
    tempo.Start;
    for valor in FLista do
    begin
      if valor =  pValor then
      begin
        tempo.Stop;
        Break;
      end;
    end;
    tempo.Stop;
    sb.Append('for in : '+tempo.Elapsed.TotalMilliseconds.ToString);
    sb.AppendLine;

    tempo := TStopWatch.Create;
    tempo.Start;
    for i:= 0 to FLista.Count -1  do
    begin
      if FLista[i] =  pValor then
      begin
        tempo.Stop;
        Break;
      end;
    end;
    tempo.Stop;
    sb.Append('for  '+tempo.Elapsed.TotalMilliseconds.ToString);
    sb.AppendLine;

    tempo := TStopWatch.Create;
    tempo.Start;
    FDicionario.ContainsValue(valor);
    tempo.Stop;
    sb.Append('Dicionario  '+tempo.Elapsed.TotalMilliseconds.ToString);
    FResultado := sb.ToString;
  finally
    sb.Free
  end;


end;

procedure TBusca.InicializarListas;
 var
  i : Integer;
  j : Extended;
begin
  FLista.Clear;
  FDicionario.Clear;
  for I := 0 to 50000 do
  begin
    j := Int(1+ Random(1000000));
    FLista.Add(J.ToString());
    FDicionario.Add(I , j.ToString());
  end;
end;

function TBusca.Resultado: string;
begin
  Result := FResultado;
end;

end.
