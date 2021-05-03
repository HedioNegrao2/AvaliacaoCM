unit Avaliacao3;

interface

uses
  System.Generics.Collections, System.SysUtils;

type

  Tcontador =  class
  private
    FValor: Integer;
    FNome: string;
    procedure SetNome(const Value: string);
    procedure SetValor(const Value: Integer);

  public
    property Nome: string read FNome write SetNome;
    property Valor: Integer read FValor write SetValor;
    constructor Crate(pNome:string; pValor: Integer);
  end;

  TMultthread =  class
  private
    Flista: Tobjectlist<Tcontador>;
    FMulti : TMultiReadExclusiveWriteSynchronizer;
    FLog: TProc<string>;
  public
    procedure SetLog(pValue: TProc<string>);
    procedure AicrementarValor(pNome: string);
    function LerValor(pValor: Integer ): Tcontador;
    function TotalItens: Integer;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  TExecuta = class
  private
    FMultThread : TMultthread;
    FLog: TProc<string>;
  public
    procedure Gerar;
    procedure Ler;
    procedure Log(pValue: TProc<string> );

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;


  end;


implementation

uses
  System.Threading, System.Classes;
{ Tcontador }

constructor Tcontador.Crate(pNome: string; pValor: Integer);
begin
  FNome := pNome;
  FValor := pValor;
end;

procedure Tcontador.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure Tcontador.SetValor(const Value: Integer);
begin
  FValor := Value;
end;

{ TMultthread }

procedure TMultthread.AfterConstruction;
begin
  inherited;
  FMulti := TMultiReadExclusiveWriteSynchronizer.Create;
  Flista := Tobjectlist<Tcontador>.Create();
end;

procedure TMultthread.AicrementarValor(pNome: string);
const
  MSG =  'Thread %S adcionando valor %s';
var
  valor: Integer;
begin
  FMulti.BeginWrite();
  try
    valor:=  Flista.Count + 1;
    if valor >100 then
      Abort;

    Flista.Add(Tcontador.Crate(pNome, valor));
    FLog(Format(MSG, [pNome, valor.ToString]));
  finally
    FMulti.EndWrite();
  end;
end;

procedure TMultthread.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FMulti);
  FreeAndNil(Flista);
end;

function TMultthread.LerValor(pValor: Integer): Tcontador;
var
  item: Tcontador;
begin
  Result := nil;
  FMulti.BeginRead();
  try
    for item in Flista do
    begin
      if item.Valor =  pValor then
        Result := item;
    end;
  finally
    FMulti.EndRead();
  end;
end;

procedure TMultthread.SetLog(pValue: TProc<string>);
begin
  FLog :=  pValue;
end;

function TMultthread.TotalItens: Integer;
begin
  FMulti.BeginRead();
  try
    Result := Flista.Count;
  finally
    FMulti.EndRead();
  end;
end;

{ TExecuta }

procedure TExecuta.AfterConstruction;
begin
  inherited;
  FMultThread := TMultthread.Create;
end;

procedure TExecuta.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FMultThread);
end;

procedure TExecuta.Gerar;
begin
  TTask.Run(
      procedure
      var
        I : Integer;
      begin
        while (FMultThread.TotalItens <= 100) do
        begin
          TThread.Sleep(5);
          TThread.Synchronize(
              TThread.CurrentThread,
              procedure
              begin
                FMultThread.AicrementarValor('Thread 1');

              end);
        end;
      end
  );

  TTask.Run(
      procedure
      var
        I : Integer;
      begin
        while (FMultThread.TotalItens <= 100) do
        begin
          TThread.Sleep(50);
          TThread.Synchronize(
              TThread.CurrentThread,
              procedure
              begin
                FMultThread.AicrementarValor('Thread 2');
              end
          )
        end;
      end
  );

  TTask.Run(
      procedure
      var
        I : Integer;
      begin
        while (FMultThread.TotalItens <= 100) do
        begin
          TThread.Sleep(20);
          TThread.Synchronize(
              TThread.CurrentThread,
              procedure
              begin
                FMultThread.AicrementarValor('Thread 3');
              end
          );
        end;
      end
  );

end;

procedure TExecuta.Ler;
begin
 TTask.Run(
      procedure
      var
        I : Integer;
        item: Tcontador;
      begin
        for i := 1 to  101 do
        begin
          TThread.Sleep(50);
          TThread.Synchronize(  nil,
                procedure
                begin
                item := FMultThread.LerValor(i);
                if Assigned(item) then
                  Self.FLog( 'Thread 1 lendo ' + item.Valor.ToString + ' gerado por' + item.nome)
                else
                 Self.FLog( 'Não localizou o valor   ' + i.ToString);
        end
                               );

        end;
      end
  );

 TTask.Run(
      procedure
      var
        I : Integer;
        item: Tcontador;
      begin
        for i := 1 to  100 do
          TThread.Synchronize(
              TThread.CurrentThread,
              procedure
              begin
                item := FMultThread.LerValor(i);
                if Assigned(item) then
                  Self.FLog( 'Thread 2 lendo ' + item.Valor.ToString + ' gerado por' + item.nome)
                else
                 Self.FLog( 'Não localizou o valor   ' + i.ToString);
              end);
      end
  );

   TTask.Run(
      procedure
      var
        I : Integer;
        item: Tcontador;
      begin
        for i := 1 to  100 do
          TThread.Synchronize(
              TThread.CurrentThread,
              procedure
              begin
                item := FMultThread.LerValor(i);
                if Assigned(item) then
                  Self.FLog( 'Thread 3 lendo ' + item.Valor.ToString + ' gerado por' + item.nome)
                else
                 Self.FLog( 'Não localizou o valor   ' + i.ToString);
              end);
      end
  );

end;

procedure TExecuta.Log(pValue: TProc<string>);
begin
  Self.FLog := pValue;
  FMultThread.SetLog(pValue);
end;

end.
