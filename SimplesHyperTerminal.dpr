program SimplesHyperTerminal;

uses
  FMX.Forms,
  main in 'main.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
