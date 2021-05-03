program AvaliacaoCM;

uses
  Vcl.Forms,
  Avaliacao2 in 'Avaliacao2.pas',
  Avaliacao1 in 'Avaliacao1.pas',
  Avaliacao3 in 'Avaliacao3.pas',
  Principal in 'Principal.pas' {FrmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
