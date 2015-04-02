unit Main;

interface uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  RenderThread, CalcThread;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    FRender: TRenderThread;
    FCalc: TCalcThread;
    FPrevMouseX, FPrevMouseY: Integer;
    procedure Save;
    procedure Load;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation uses
  Player, GameObject, World;

{$R *.dfm}

const
  pfd: TPixelFormatDescriptor = (
    nSize: sizeOf(pfd);
    nVersion: 1;
    dwFlags: PFD_DRAW_TO_WINDOW + PFD_SUPPORT_OPENGL + PFD_DOUBLEBUFFER
  );

procedure TForm1.FormClick(Sender: TObject);
begin
//  FRender.Paint;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  i := ChoosePixelFormat(Canvas.Handle, @pfd);
  if i = 0 then
    RaiseLastOSError;
  if not SetPixelFormat(Canvas.Handle, i, @pfd) then
    RaiseLastOSError;
  FCalc := TCalcThread.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FCalc.Free;
  FRender.Free;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_ESCAPE:
    Close;
  VK_SPACE:
    FCalc.Suspended := not FCalc.Suspended;
  VK_F5:
    Save();
  VK_F9:
    Load();
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPrevMouseX := X;
  FPrevMouseY := Y;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
{  case Round(100*X/ClientWidth) of
  0..9:
    Dec(FCalc.SteerDelta);
  90..99:
    Inc(FCalc.SteerDelta);
  end;}
  if (FPrevMouseX = 0) and (FPrevMouseY = 0) then begin
//    Exit;
  end else begin
    Inc(FCalc.SteerDelta, X - FPrevMouseX);
  end;
  FPrevMouseX := X;
  FPrevMouseY := Y;
//  FRender.ClearColor := X / ClientWidth;
//  FRender.RectColor := Y / ClientHeight;
//  FRender.Paint;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  FRender.Paint;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  FRender.Resized := true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FRender := TRenderThread.Create();
  FRender.RectColor := 1;
end;

procedure TForm1.Load;
var
  Binary, Text: TStream;
  Reader: TReader;
begin
  Text := TFileStream.Create('world.dfm', fmOpenRead);
  Binary := TMemoryStream.Create();
  Reader := TReader.Create(Binary, 4096);
  try
    ObjectTextToBinary(Text, Binary);
    Binary.Position := 0;
    Wld.Load(Reader);
  finally
    Reader.Free;
    Binary.Free;
    Text.Free;
  end;
end;

procedure TForm1.Save;
var
  Binary, Text: TStream;
  Writer: TWriter;
begin
  Text := TFileStream.Create('world.dfm', fmCreate);
  Binary := TMemoryStream.Create;
  Writer := TWriter.Create(Binary, 4096);
  try
    Wld.Save(Writer);
    Writer.FlushBuffer;
    TMemoryStream(Binary).SaveToFile('debug.bin');
    Binary.Position := 0;
    ObjectBinaryToText(Binary, Text);
  finally
    Writer.Free;
    Binary.Free;
    Text.Free;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Caption := Format('%d %d %d %f',
    [FRender.Fps, FCalc.Lps, Wld.Boxes.Count, Wld.Player.y])
end;

end.
