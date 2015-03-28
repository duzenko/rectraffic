unit CalcThread;

interface uses
  System.Classes;

type
  TCalcThread = class(TThread)
  protected
    procedure Execute; override;
  public
    Lps, SteerDelta: Integer;
  end;

implementation uses
  Windows, SysUtils, Forms, Box, Math, Road, Player, GameObject, World;

{ TCalcThread }

procedure TCalcThread.Execute;
const {$J+}
  LastTime: TDateTime = 0;
  Frames: Integer = 0;
begin
  NameThreadForDebugging('Calc');
  TRoad.Create(nil);
  TPlayer.Create(nil);
  while not Application.Terminated do begin
    if LastTime = 0 then
      LastTime := Now;
    if Now - LastTime > 1/86400 then begin
      Lps := Frames;
      Frames := 0;
      LastTime := Now;
    end;
    Inc(Frames);

    SteerDelta := 0;
    Wld.Move;
    Sleep(1);
  end;
//  GameObjects.Clear;
end;

end.
