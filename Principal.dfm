object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Avalica'#231#227'o CM'
  ClientHeight = 428
  ClientWidth = 631
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 631
    Height = 428
    ActivePage = ts1
    Align = alClient
    TabOrder = 0
    object ts1: TTabSheet
      Caption = '1 - Busca perform'#225'tica'
      object lbl1: TLabel
        Left = 24
        Top = 112
        Width = 173
        Height = 13
        Caption = 'Resultado (tempo em milessegundo)'
      end
      object btnInicializarLista: TButton
        Left = 24
        Top = 3
        Width = 105
        Height = 25
        Caption = 'Inicializar listas'
        TabOrder = 0
        OnClick = btnInicializarListaClick
      end
      object btnBuscar: TButton
        Left = 24
        Top = 63
        Width = 105
        Height = 25
        Caption = 'Buscar'
        TabOrder = 1
        OnClick = btnBuscarClick
      end
      object edtBusca: TEdit
        Left = 24
        Top = 36
        Width = 233
        Height = 21
        NumbersOnly = True
        TabOrder = 2
      end
      object mmoResultado: TMemo
        Left = 24
        Top = 131
        Width = 289
        Height = 266
        TabOrder = 3
      end
      object lstValores: TListBox
        Left = 344
        Top = 0
        Width = 279
        Height = 400
        Align = alRight
        ItemHeight = 13
        TabOrder = 4
      end
      object btnExibirLista: TButton
        Left = 152
        Top = 5
        Width = 105
        Height = 25
        Caption = 'Exibir lista'
        TabOrder = 5
        OnClick = btnExibirListaClick
      end
    end
    object ts2: TTabSheet
      Caption = '2 - Convers'#227'o de objeto'
      ImageIndex = 1
      object mmo1: TMemo
        Left = 0
        Top = 240
        Width = 623
        Height = 160
        Align = alBottom
        Lines.Strings = (
          '')
        TabOrder = 0
      end
      object grp1: TGroupBox
        Left = 16
        Top = 0
        Width = 409
        Height = 121
        Caption = 'Produto'
        TabOrder = 1
        object lbl2: TLabel
          Left = 16
          Top = 16
          Width = 46
          Height = 13
          Caption = 'Descri'#231#227'o'
        end
        object lbl4: TLabel
          Left = 293
          Top = 16
          Width = 68
          Height = 13
          Caption = 'Data cadastro'
        end
        object lbl3: TLabel
          Left = 16
          Top = 69
          Width = 69
          Height = 13
          Caption = 'Dias reposi'#231#227'o'
        end
        object lbl5: TLabel
          Left = 120
          Top = 68
          Width = 24
          Height = 13
          Caption = 'Valor'
        end
        object edtDescricao: TEdit
          Left = 16
          Top = 35
          Width = 255
          Height = 21
          TabOrder = 0
          Text = 'Abacate'
        end
        object dtpDataCadastro: TDateTimePicker
          Left = 293
          Top = 35
          Width = 97
          Height = 21
          Date = 44318.985055844910000000
          Time = 44318.985055844910000000
          TabOrder = 1
        end
        object edtDiasReposicao: TEdit
          Left = 16
          Top = 88
          Width = 82
          Height = 21
          Alignment = taRightJustify
          NumbersOnly = True
          TabOrder = 2
          Text = '5'
        end
        object edtValor: TEdit
          Left = 120
          Top = 87
          Width = 89
          Height = 21
          Alignment = taRightJustify
          NumbersOnly = True
          TabOrder = 3
          Text = '3,50'
        end
      end
      object grp2: TGroupBox
        Left = 26
        Top = 127
        Width = 605
        Height = 74
        Caption = 'Item'
        TabOrder = 2
        object lbl6: TLabel
          Left = 11
          Top = 21
          Width = 17
          Height = 13
          Caption = 'Cor'
        end
        object lbl7: TLabel
          Left = 221
          Top = 21
          Width = 39
          Height = 13
          Caption = 'Estoque'
        end
        object edtCor: TEdit
          Left = 8
          Top = 40
          Width = 198
          Height = 21
          TabOrder = 0
          Text = 'Verde'
        end
        object edtEstoque: TEdit
          Left = 221
          Top = 40
          Width = 70
          Height = 21
          Alignment = taRightJustify
          NumbersOnly = True
          TabOrder = 1
          Text = '5'
        end
        object chkAtivo: TCheckBox
          Left = 308
          Top = 40
          Width = 97
          Height = 17
          Caption = 'Ativo'
          TabOrder = 2
        end
        object btnAdcionar: TButton
          Left = 392
          Top = 40
          Width = 97
          Height = 25
          Caption = 'Adcionar Item'
          TabOrder = 3
          OnClick = btnAdcionarClick
        end
      end
      object grp3: TGroupBox
        Left = 431
        Top = 0
        Width = 185
        Height = 121
        Caption = 'Nomes'
        TabOrder = 3
        object lbl8: TLabel
          Left = 16
          Top = 21
          Width = 27
          Height = 13
          Caption = 'Nome'
        end
        object edtNome: TEdit
          Left = 15
          Top = 40
          Width = 158
          Height = 21
          TabOrder = 0
          Text = 'avocado'
        end
        object btn1: TButton
          Left = 16
          Top = 67
          Width = 75
          Height = 25
          Caption = 'Adicionar'
          TabOrder = 1
          OnClick = btn1Click
        end
      end
      object btnSeralizar: TButton
        Left = 26
        Top = 209
        Width = 75
        Height = 25
        Caption = 'Serializar'
        TabOrder = 4
        OnClick = btnSeralizarClick
      end
      object chkFormatarJson: TCheckBox
        Left = 160
        Top = 216
        Width = 97
        Height = 17
        Caption = 'Formatar'
        TabOrder = 5
      end
    end
    object ts3: TTabSheet
      Caption = '3 - Gerenciador de recurso multi-thread'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object mmoThread: TMemo
        Left = 136
        Top = 3
        Width = 487
        Height = 394
        TabOrder = 0
      end
      object btn2: TButton
        Left = 24
        Top = 24
        Width = 75
        Height = 25
        Caption = 'Gerar valores'
        TabOrder = 1
        OnClick = btn2Click
      end
      object btnLerValores: TButton
        Left = 24
        Top = 64
        Width = 75
        Height = 25
        Caption = 'Ler valores'
        TabOrder = 2
        OnClick = btnLerValoresClick
      end
    end
  end
end
