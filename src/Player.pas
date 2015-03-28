unit Player;

interface uses
  Classes, Box, GameObject;

type
  TPlayer = class(TBox)
  private
    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Move; override;
  end;

var
//  Player: TPlayer;
  PlayerSpeed: Single = BoxSpeed * 5;

const
  PlayerScreenY = 0.5;

implementation uses
  Windows, World;

{ TPlayer }

constructor TPlayer.Create;
begin
  inherited Create(nil);
  w := 0.15;
  h := 0.18;
  x := 0;
  Color := $ff;
  Wld.Player := Self;
end;

destructor TPlayer.Destroy;
begin

end;

procedure TPlayer.Move;
var
  Crashed: TBox;
begin
  y := y + PlayerSpeed;
  if GetKeyState(VK_LEFT) < 0 then
    x := x - PlayerSpeed;
  if GetKeyState(VK_RIGHT) < 0 then
    x := x + PlayerSpeed;
  if GetKeyState(VK_UP) < 0 then
    PlayerSpeed := PlayerSpeed * 1.02;
  if GetKeyState(VK_DOWN) < 0 then
    PlayerSpeed := PlayerSpeed / 1.02;
  if (l <= -1) or (r >= 1) then
    Reset;
  Crashed := Wld.Intersects(Self);
  if Crashed <> nil then begin
    Reset;
    Wld.Remove(Crashed);
  end;
end;

procedure TPlayer.Reset;
begin
  Sleep(999);
//    x := 0;
//    y := y - 1.3;
end;

end.
