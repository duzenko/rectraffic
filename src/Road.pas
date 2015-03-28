unit Road;

interface uses
  GameObject;

type
  TRoad = class(TGameObject)
    procedure Paint; override;
    procedure Move; override;
  end;

implementation uses
  Math, OpenGL, Box, Player, World;

{ TRoad }

procedure TRoad.Move;
const {$J+}
  LastGenY: Single = 0;
begin
  if Wld.Player.y - LastGenY < 0.3 then
    Exit;
  TBox.Create(nil);
  LastGenY := Wld.Player.y
end;

procedure TRoad.Paint;
var
  i, j: Integer;
  iY: Single;
const
  cInterval = 0.36;
  cLength = 0.1;
begin
  glColor3f(0.4, 0.4, 0.5);
  glPushMatrix;
  glLoadIdentity();
  glBegin(GL_QUADS);
  glVertex2f(-1, +1);
  glVertex2f(+1, +1);
  glVertex2f(+1, -1);
  glVertex2f(-1, -1);
  glColor3f(1, 1, 1);
  glVertex2f(-0.03, +1);
  glVertex2f(-0.01, +1);
  glVertex2f(-0.01, -1);
  glVertex2f(-0.03, -1);
  glVertex2f(+0.03, +1);
  glVertex2f(+0.01, +1);
  glVertex2f(+0.01, -1);
  glVertex2f(+0.03, -1);
  glEnd;
  glPopMatrix;

  iy := Round((Wld.Player.y-1)/cInterval)*cInterval;
  glPushMatrix;
  glTranslate(0, iy, 0);
  glBegin(GL_QUADS);
  for I := 0 to 12 do
  for j := 1 to 3 do begin
    glVertex2f(j/4-0.01, i*cInterval);
    glVertex2f(j/4+0.01, i*cInterval);
    glVertex2f(j/4+0.01, i*cInterval+cLength);
    glVertex2f(j/4-0.01, i*cInterval+cLength);
    glVertex2f(-j/4-0.01, i*cInterval);
    glVertex2f(-j/4+0.01, i*cInterval);
    glVertex2f(-j/4+0.01, i*cInterval+cLength);
    glVertex2f(-j/4-0.01, i*cInterval+cLength);
  end;
  glEnd;
  glPopMatrix;
end;

end.
