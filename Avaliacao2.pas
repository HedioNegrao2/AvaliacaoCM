unit Avaliacao2;

interface

uses
  System.Generics.Collections, System.JSON.Writers, System.JSON, Data.DBXJSONReflect, System.Rtti;

type
  TIdentificadorPropriedade = class(TCustomAttribute)
  private
    FNome: string;
    procedure SetNome(const Value: string);
  public
    property Nome: string read FNome write SetNome;
    constructor Create(pValue: string);
  end;

  TProdutoItem = class
  private
    FCor: string;
    FAtivo: Boolean;
    FEstoque: Double;
    procedure SetAtivo(const Value: Boolean);
    procedure SetCor(const Value: string);
    procedure SetEstoque(const Value: Double);

  public
    [TIdentificadorPropriedade('COR')]
    property Cor: string read FCor write SetCor;
    [TIdentificadorPropriedade('EST')]
    property Estoque: Double read FEstoque write SetEstoque;
    [TIdentificadorPropriedade('AT')]
    property Ativo: Boolean read FAtivo write SetAtivo;
    constructor Create(pCor: string; pEtoque: Double; pAtivo: Boolean);
  end;

  TProduto = class
  private
    FValor: Currency;
    FLista: TObjectList<TProdutoItem>;
    FDiasParaReposicao: Integer;
    FDescricao: String;
    FDataCadastro: TDateTime;
    FTag: Integer;
    FlistaNomesAlternativos: TList<string>;
    procedure SetDataCadastro(const Value: TDateTime);
    procedure SetDescricao(const Value: String);
    procedure SetDiasParaReposicao(const Value: Integer);
    procedure SetLista(const Value: TObjectList<TProdutoItem>);
    procedure SetValor(const Value: Currency);
    procedure SetTag(const Value: Integer);
    procedure SetlistaNomesAlternativos(const Value: TList<string>);

  public
    [TIdentificadorPropriedade('DSCR')]
    property Descricao: String read FDescricao write SetDescricao;
    [TIdentificadorPropriedade('DT')]
    property DataCadastro: TDateTime read FDataCadastro write SetDataCadastro;
    [TIdentificadorPropriedade('DIAS')]
    property DiasParaReposicao: Integer read FDiasParaReposicao write SetDiasParaReposicao;
    [TIdentificadorPropriedade('VLR')]
    property Valor: Currency read FValor write SetValor;
    [TIdentificadorPropriedade('LST')]
    property Lista: TObjectList<TProdutoItem> read FLista write SetLista;
    [JSONMarshalled(false)]
    property Tag: Integer read FTag write SetTag;
    [TIdentificadorPropriedade('LSTNOMES')]
    property listaNomesAlternativos: TList<string> read FlistaNomesAlternativos write SetlistaNomesAlternativos;

    function AdcionarItem(pCor: string; pEtoque: Double; pAtivo: Boolean = True): Boolean;
    procedure AdcionarNome(pNome: string);
    procedure BeforeDestruction; override;

  end;

  TConversoJSON = class
  private
    function ObjetoParaJSON(pObjeto: TObject; var pBuilder: TJsonTextWriter; pArray: Boolean = false): string;
    procedure ListaParJson(pObjeto: TObject; var pBuilder: TJsonTextWriter; pPropertName: string);
    function ValorValido(pValue: Tvalue): Boolean;
  public
    function Serializar(pObjeto: TObject; pFormatar: Boolean): string;

  end;

implementation

{ TProduto }
uses
  System.Classes, System.SysUtils, System.JSON.Types;

function TProduto.AdcionarItem(pCor: string; pEtoque: Double; pAtivo: Boolean): Boolean;
begin
  if not Assigned(FLista) then
    FLista := TObjectList<TProdutoItem>.Create;
  Result:=  FLista.Add(TProdutoItem.Create(pCor, pEtoque, pAtivo)) >= 0;
end;

procedure TProduto.AdcionarNome(pNome: string);
begin
  if not Assigned(FlistaNomesAlternativos) then
    FlistaNomesAlternativos := TList<string>.Create;
  FlistaNomesAlternativos.Add(pNome);
end;

procedure TProduto.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FLista);
  FreeAndNil(FlistaNomesAlternativos);
end;

procedure TProduto.SetDataCadastro(const Value: TDateTime);
begin
  FDataCadastro := Value;
end;

procedure TProduto.SetDescricao(const Value: String);
begin
  FDescricao := Value;
end;

procedure TProduto.SetDiasParaReposicao(const Value: Integer);
begin
  FDiasParaReposicao := Value;
end;

procedure TProduto.SetLista(const Value: TObjectList<TProdutoItem>);
begin
  FLista := Value;
end;

procedure TProduto.SetlistaNomesAlternativos(const Value: TList<string>);
begin
  FlistaNomesAlternativos := Value;
end;

procedure TProduto.SetTag(const Value: Integer);
begin
  FTag := Value;
end;

procedure TProduto.SetValor(const Value: Currency);
begin
  FValor := Value;
end;

{ TIdentificadorPropriedade }

constructor TIdentificadorPropriedade.Create(pValue: string);
begin
  FNome := pValue;
end;

procedure TIdentificadorPropriedade.SetNome(const Value: string);
begin
  FNome := Value;
end;

{ TProdutoItem }

constructor TProdutoItem.Create(pCor: string; pEtoque: Double; pAtivo: Boolean);
begin
  FCor := pCor;
  FEstoque := pEtoque;
  FAtivo := pAtivo;
end;

procedure TProdutoItem.SetAtivo(const Value: Boolean);
begin
  FAtivo := Value;
end;

procedure TProdutoItem.SetCor(const Value: string);
begin
  FCor := Value;
end;

procedure TProdutoItem.SetEstoque(const Value: Double);
begin
  FEstoque := Value;
end;

{ TConversoJSON }

procedure TConversoJSON.ListaParJson(pObjeto: TObject; var pBuilder: TJsonTextWriter; pPropertName: string);
var
  contexto: TRttiContext;
  meth: TRttiMethod;
  Valor: Tvalue;
  i: Integer;
begin
  meth := contexto.GetType(pObjeto.ClassType).GetMethod('ToArray');
  if Assigned(meth) then
  begin
    Valor := meth.Invoke(pObjeto, []);
    if not Valor.IsArray then
      Exit;

    pBuilder.WritePropertyName(pPropertName);
    pBuilder.WriteStartArray;
    for i := 0 to Valor.GetArrayLength - 1 do
      if Valor.GetArrayElement(i).Kind in [tkString, tkUString, tkChar, tkWChar] then
        pBuilder.WriteValue(Valor.GetArrayElement(i).AsString)
      else
        ObjetoParaJSON(Valor.GetArrayElement(i).AsObject, pBuilder, True);
    pBuilder.WriteEndArray;
  end;
end;

function TConversoJSON.ObjetoParaJSON(pObjeto: TObject; var pBuilder: TJsonTextWriter; pArray: Boolean = false): string;

var
  contexto: TRttiContext;
  propriedade: TRttiProperty;
  obj: TObject;
  Valor: Tvalue;
  existeArray: Boolean;
  atributo: TCustomAttribute;
  nomePropriedade: string;
begin
  existeArray := pArray;
  pBuilder.WriteStartObject;

  for propriedade in contexto.GetType(pObjeto.ClassType).GetProperties do
  begin
    nomePropriedade := '';
    for atributo in propriedade.GetAttributes do
    begin
      if atributo is TIdentificadorPropriedade then
        nomePropriedade := TIdentificadorPropriedade(atributo).Nome;
    end;
    if nomePropriedade.IsEmpty then
      Continue;
    if not ValorValido(propriedade.GetValue(pObjeto)) then
      raise Exception.Create('O Valor da propriedade ' + propriedade.Name + ' deve ser informado');

    if propriedade.PropertyType.TypeKind = tkDynArray then
    begin
      ListaParJson(pObjeto, pBuilder, propriedade.Name)
    end
    else if propriedade.PropertyType.TypeKind = tkClass then
    begin
      obj := propriedade.GetValue(pObjeto).AsObject;
      if not Assigned(obj) then
        Continue
      else
        existeArray := false;

      if propriedade.PropertyType.ToString.Contains('TObjectList<') then
        ListaParJson(obj, pBuilder, propriedade.Name)
      else if propriedade.PropertyType.ToString.Contains('TList<') then
        ListaParJson(obj, pBuilder, propriedade.Name)
      else
      begin
        if not existeArray then
          pBuilder.WritePropertyName(propriedade.Name);
        ObjetoParaJSON(obj, pBuilder, existeArray);
      end;
    end
    else if propriedade.PropertyType.TypeKind = tkFloat then
    begin
      Valor := propriedade.GetValue(pObjeto);
      pBuilder.WritePropertyName(nomePropriedade);

      if LowerCase(propriedade.PropertyType.Name) = 'tdatetime' then
        pBuilder.WriteValue(FormatDateTime('dd/mm/yyyy', Valor.AsExtended))
      else if LowerCase(propriedade.PropertyType.Name) = 'currency' then
        pBuilder.WriteValue(Valor.AsCurrency)
      else
        pBuilder.WriteValue(Valor);

    end
    else if propriedade.PropertyType.TypeKind = tkEnumeration then
    begin
      pBuilder.WritePropertyName(propriedade.Name);
      if propriedade.PropertyType.Name = 'Boolean' then
      begin
        pBuilder.WriteValue(propriedade.GetValue(pObjeto).AsBoolean)
      end;
    end
    else
    begin
      pBuilder.WritePropertyName(nomePropriedade);
      pBuilder.WriteValue(propriedade.GetValue(pObjeto));
    end;
  end;
  pBuilder.WriteEndObject;

end;

function TConversoJSON.Serializar(pObjeto: TObject; pFormatar: Boolean): string;
var
  Writer: TJsonTextWriter;
  StringWriter: TStringWriter;
begin
  if not Assigned(pObjeto) then
    raise Exception.Create('Objeto não criado');
  StringWriter := TStringWriter.Create;
  Writer := TJsonTextWriter.Create(StringWriter);
  if pFormatar then
   Writer.Formatting := TJsonFormatting.Indented;
  try
    ObjetoParaJSON(pObjeto, Writer);
     Result := StringWriter.ToString;
   // Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(StringWriter.ToString), 0) as TJSONObject;
  finally
    Writer.Free;
    StringWriter.Free;
  end;

end;

function TConversoJSON.ValorValido(pValue: Tvalue): Boolean;
begin
  if pValue.IsEmpty then
    Exit(false);

  Result := True;

  case pValue.Kind of
    tkInteger:
      Result := pValue.AsInteger > 0;
    tkEnumeration:
      ;
    tkFloat:
      Result := pValue.AsExtended > 0;
    tkString, tkChar,  tkWChar,tkLString, tkWString, tkUString  : Result :=  not pValue.AsString.IsEmpty ;
    tkSet:
      ;
    tkClass:
      ;
    tkMethod:
      ;

    tkVariant:
      ;
    tkArray:
      ;
    tkRecord:
      ;
    tkInterface:
      ;
    tkInt64:
      ;
    tkDynArray:
      ;
    tkClassRef:
      ;
    tkPointer:
      ;
    tkProcedure:
      ;
  end;

end;

end.
