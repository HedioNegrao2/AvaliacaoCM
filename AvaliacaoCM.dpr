program AvaliacaoCM;

uses
  Vcl.Forms,
  Principal in '..\Principal.pas' {FrmPrincipal},
  Avaliacao2 in 'Avaliacao2.pas',
  Avaliacao1 in 'Avaliacao1.pas',
  Avaliacao3 in 'Avaliacao3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
