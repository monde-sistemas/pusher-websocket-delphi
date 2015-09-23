program PusherClientExample;

uses
  Vcl.Forms,
  example in 'example.pas' {PusherClientExampleForm},
  PusherClient in '..\PusherClient\PusherClient.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPusherClientExampleForm, PusherClientExampleForm);
  Application.Run;
end.
