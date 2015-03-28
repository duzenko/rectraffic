program Squares;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  RenderThread in 'RenderThread.pas',
  CalcThread in 'CalcThread.pas',
  Box in 'Box.pas',
  Road in 'Road.pas',
  Player in 'Player.pas',
  GameObject in 'GameObject.pas',
  World in 'World.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
