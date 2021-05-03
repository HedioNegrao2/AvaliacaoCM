unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections, Vcl.ComCtrls, 
  Avaliacao1,  Avaliacao2, Avaliacao3;

type
  TFrmPrincipal = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    ts3: TTabSheet;
    btnInicializarLista: TButton;
    btnBuscar: TButton;
    edtBusca: TEdit;
    mmoResultado: TMemo;
    lstValores: TListBox;
    lbl1: TLabel;
    btnExibirLista: TButton;
    mmo1: TMemo;
    grp1: TGroupBox;
    lbl2: TLabel;
    edtDescricao: TEdit;
    lbl4: TLabel;
    lbl3: TLabel;
    dtpDataCadastro: TDateTimePicker;
    lbl5: TLabel;
    edtDiasReposicao: TEdit;
    edtValor: TEdit;
    grp2: TGroupBox;
    grp3: TGroupBox;
    edtCor: TEdit;
    edtEstoque: TEdit;
    chkAtivo: TCheckBox;
    lbl6: TLabel;
    lbl7: TLabel;
    btnAdcionar: TButton;
    edtNome: TEdit;
    btn1: TButton;
    lbl8: TLabel;
    btnSeralizar: TButton;
    mmoThread: TMemo;
    btn2: TButton;
    btnLerValores: TButton;
    chkFormatarJson: TCheckBox;
    procedure btnInicializarListaClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnLerValoresClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExibirListaClick(Sender: TObject);
    procedure btnSeralizarClick(Sender: TObject);
    procedure btnAdcionarClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    FAvalicao1 : TBusca;
    FAvalicao2 : TProduto;
    FAvalicao3 : TExecuta;
  public
    procedure AfterConstruction; override;
    { Public declarations }
    
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

{ TForm2 }
uses
  System.Diagnostics, System.TimeSpan;

procedure TFrmPrincipal.btnInicializarListaClick(Sender: TObject);
var
  item: string;
begin
  if not Assigned(FAvalicao1) then  
    FAvalicao1 := TBusca.Create;
  FAvalicao1.InicializarListas;     
end;

procedure TFrmPrincipal.btnSeralizarClick(Sender: TObject);
var
  serializar: TConversoJSON;  
begin     

  try
    FAvalicao2.Descricao :=  edtDescricao.Text;
    FAvalicao2.DataCadastro :=  dtpDataCadastro.DateTime;
    FAvalicao2.DiasParaReposicao := StrToInt(edtDiasReposicao.Text);
    FAvalicao2.Valor := StrToCurr(edtValor.Text);
  except
    on e: Exception do
      raise Exception.Create('Erro ao serializar ' +  sLineBreak + e.Message);
  end;

  serializar := TConversoJSON.Create;
  try
    mmo1.Lines.Add('-----------------------------------------------------------');
    mmo1.Lines.Add(serializar.Serializar(FAvalicao2, chkFormatarJson.Checked));
  finally
    serializar.Free;
  end;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAvalicao1);
end;

procedure TFrmPrincipal.btnBuscarClick(Sender: TObject);
begin
  if not Assigned(FAvalicao1) then
    raise Exception.Create('É necessário inicilaizar a lista antes');
  if FAvalicao1.Encontrou(edtBusca.Text) then
    ShowMessage('Valor '+ edtBusca.Text +' encontrado')
  else
    ShowMessage('Não foi possível localizar o valor '+ edtBusca.Text);
  mmoResultado.Lines.Add('-----------------------');
  mmoResultado.Lines.Add(FAvalicao1.Resultado);  

end;

procedure TFrmPrincipal.btnExibirListaClick(Sender: TObject);
var
  item: string;
begin
  if not Assigned(FAvalicao1) then
    raise Exception.Create('É necessário inicilaizar a lista antes');
  lstValores.Clear;
  for item in FAvalicao1.Lista do
  begin
    lstValores.Items.Add(item)  ;
  end;    

end;

procedure TFrmPrincipal.AfterConstruction;
begin
  inherited;
   FAvalicao2 := TProduto.Create;
end;

procedure TFrmPrincipal.btn1Click(Sender: TObject);
begin
  FAvalicao2.AdcionarNome(edtNome.Text);
end;

procedure TFrmPrincipal.btn2Click(Sender: TObject);
begin
  mmoThread.Clear;
  if not Assigned(FAvalicao3) then
   FAvalicao3 := TExecuta.Create;
  FAvalicao3.Log(procedure (pValor: string)
  begin
      mmoThread.Lines.Add(pValor);
  end
  );
  FAvalicao3.Gerar;

end;

procedure TFrmPrincipal.btnLerValoresClick(Sender: TObject);
begin
  if not Assigned(FAvalicao3) then
    raise Exception.Create('É necessário gerar os valores antes');

  FAvalicao3.Log(procedure (pValor: string)
  begin
      mmoThread.Lines.Add(pValor);
  end
  );
  FAvalicao3.Ler;
end;


procedure TFrmPrincipal.btnAdcionarClick(Sender: TObject);
begin
  try
    FAvalicao2.AdcionarItem(edtCor.Text, StrToFloat(edtEstoque.Text), chkAtivo.Checked);
  except
    on e:  Exception do
      raise Exception.Create('Erro ao adcionar o item' + sLineBreak + e.Message);
  end;
end;

end.
