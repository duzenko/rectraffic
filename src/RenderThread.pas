unit RenderThread;

interface uses
  Windows, SysUtils, System.Classes, Forms, OpenGL;

type
  TRenderThread = class(TThread)
  private
    RC: HGLRC;
    procedure CreateRC;
    procedure DestroyRC;
    procedure Resize;
    procedure SwapBuffersSync;
    procedure Render;
  protected
    procedure Execute; override;
  public
    Resized: Boolean;
    ClearColor, RectColor: Single;
    Fps: Integer;
    procedure Paint;
  end;

implementation uses
  GameObject, Player, World;

var
  wglSwapIntervalEXT: function(interval: GLint): Boolean; stdcall;

procedure CheckGlError;
var
  e: GLenum;
begin
  e := glGetError;
  if e <> 0 then
    raise Exception.Create(string(gluErrorString(e)));
end;

{ TRenderThread }

procedure TRenderThread.CreateRC;
var
  DC: THandle;
begin
  while Application.MainForm = nil do
    Sleep(1);
  DC := Application.MainForm.Canvas.Handle;
  RC := wglCreateContext(DC);
  if RC = 0 then
    RaiseLastOSError;
  wglMakeCurrent(DC, RC);
  wglSwapIntervalEXT    := wglGetProcAddress('wglSwapIntervalEXT');
  wglSwapIntervalEXT(1);
end;

procedure TRenderThread.DestroyRC;
begin
  wglDeleteContext(RC);
end;

procedure TRenderThread.Execute;
begin
  NameThreadForDebugging('GL Renderer');
  { Place thread code here }
  CreateRC;
  glClearColor(0.0, 0.5, 0.0, 0);
  while not Application.Terminated do begin
    if Resized then
      Resize;

    glClear(GL_COLOR_BUFFER_BIT);
    Render;
    glFinish;
    CheckGlError;

    Synchronize(SwapBuffersSync);
    Sleep(1);
  end;
  DestroyRC;
end;

procedure TRenderThread.Paint;
begin
  Suspended := false;
end;

procedure TRenderThread.Render;
const {$J+}
  LastTime: TDateTime = 0;
  Frames: Integer = 0;
begin
  if LastTime = 0 then
    LastTime := Now;
  if Now - LastTime > 1/86400 then begin
    Fps := Frames;
    Frames := 0;
    LastTime := Now;
  end;
  Inc(Frames);

  glPushMatrix;
  glTranslatef(0{-Player.x}, -Wld.Player.y-PlayerScreenY, 0);
  Wld.Paint;

//  ibx := Round(Box.x);
//  iby := Round(Box.y);

  glPopMatrix;
//  Box.Render;
end;

procedure TRenderThread.Resize;
begin
  with Application.MainForm do begin
    glViewport(0, 0, ClientWidth, ClientHeight);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity;
    gluOrtho2D(-ClientWidth/ClientHeight, ClientWidth/ClientHeight, -1, 1);
  end;
  glMatrixMode(GL_MODELVIEW);
  CheckGlError;
  Resized := false;
end;

procedure TRenderThread.SwapBuffersSync;
begin
  if not SwapBuffers(Application.MainForm.Canvas.Handle) then
    RaiseLastOSError;
end;

end.
