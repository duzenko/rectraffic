unit Box;

interface uses
  Classes, GameObject;

type
  TBox = class(TGameObject)
  protected
    w, h, fx, fy: Single;
    c: Cardinal;
    function WheelBase: Single;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function b: Single;
    function t: Single;
    function l: Single;
    function r: Single;
    procedure Paint; override;
    procedure Move; override;
    function Intersects(Box: TBox): Boolean;
  published
    property Width: Single read w write w;
    property Height: Single read h write h;
    property X: Single read fx write fx;
    property Y: Single read fy write fy;
    property Color: Cardinal read c write c;
  end;

const
  BoxSpeed = 0.0002;

implementation uses
  OpenGL, Math, SysUtils, Player, World;

{ TBox }

function TBox.b: Single;
begin
  Result := y - h/2
end;

constructor TBox.Create;
begin
  inherited Create(nil);
  Wld.Boxes.Add(Self);
  w := 0.1 + 0.05*Random;
  h := 0.4*(Random+0.3);
  x := (Random(8)+0.5)/4-1 + (0.2-w)*(Random-0.5);
  if Wld.Player <> nil then
    y := Wld.Player.y + 1 + PlayerScreenY + h/2;
  Color := Random($1000000);
end;

destructor TBox.Destroy;
begin
  inherited;
end;

function TBox.Intersects(Box: TBox): Boolean;
begin
  if Box = Self then
    Exit(false);
  Result := (box.l < r) and (l < box.r) and (box.b <t) and (b < box.t);
end;

function TBox.WheelBase: Single;
begin
  Result := h*0.5;
end;

function TBox.l: Single;
begin
  Result := x - w/2;
end;

procedure TBox.Move;
begin
  if x > 0 then
    y := y + BoxSpeed
  else
    y := y - BoxSpeed
end;

procedure TBox.Paint;
begin
  if t < Wld.Player.y-1 then
    Exit;
  glColor3ubv(@Color);
  glRectf(l, t, r, b);
end;

function TBox.r: Single;
begin
  Result := x + w/2;
end;

function TBox.t: Single;
begin
  Result := y + h/2;
end;

end.
