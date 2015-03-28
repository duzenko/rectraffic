unit World;

interface uses
  Types, Classes, Contnrs, SyncObjs, Box, Player, Road;

type
  TWorld = class(TComponent)
  private
    FSync: TCriticalSection;
    procedure RemoveHind;
  public
    Player: TPlayer;
//    Road: TRoad;
    Objects, Boxes: TObjectList;
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Paint;
    procedure Move;
    function Intersects(Box: TBox): TBox;
    procedure Remove(Obj: TObject);
    procedure Save(Stream: TWriter);
    procedure Load(Stream: TReader);
  published
  end;

var
  Wld: TWorld;

implementation uses
  SysUtils, GameObject;

{ TGameObjects }

constructor TWorld.Create;
begin
  inherited Create(nil);
  FSync := TCriticalSection.Create;
  Objects := TObjectList.Create;
  Boxes := TObjectList.Create(false);
end;

destructor TWorld.Destroy;
begin
  FreeAndNil(Objects);
  FreeAndNil(Boxes);
  FreeAndNil(FSync);
  inherited;
end;

function TWorld.Intersects(Box: TBox): TBox;
var
  i: Integer;
begin
  for I := 0 to Boxes.Count - 1 do
    if TBox(Box).Intersects(TBox(Boxes[i])) then
      Exit(TBox(Boxes[i]));
  Result := nil;
end;

procedure TWorld.Load;
begin
  FSync.Enter;
  try
    Boxes.Clear;
    Objects.Clear;
    Stream.Root := Self;
    Stream.BeginReferences;
    Stream.ReadSignature;
    Stream.ReadStr;
    Stream.ReadStr;
    Stream.ReadListEnd;
    while not Stream.EndOfList do begin
      Stream.ReadComponent(nil);
    end;
    Stream.EndReferences;
  finally
    FSync.Leave;
  end;
end;

procedure TWorld.Move;
var
  i: Integer;
begin
  FSync.Enter;
  try
    for i := Objects.Count-1 downto 0 do
      TGameObject(Objects[i]).Move;
  finally
    FSync.Leave;
  end;
  RemoveHind;
end;

procedure TWorld.Paint;
var
  i: Integer;
begin
  FSync.Enter;
  try
    for i := 0 to Objects.Count-1 do
      TGameObject(Objects[i]).Paint;
  finally
    FSync.Leave;
  end;
end;

procedure TWorld.Remove(Obj: TObject);
begin
  FSync.Enter;
  try
    Objects.Remove(Obj);
    Boxes.Remove(Obj);
  finally
    FSync.Leave;
  end;
end;

procedure TWorld.RemoveHind;
var
  i: Integer;
begin
    for i := Boxes.Count-1 downto 0 do begin
      if (TBox(Boxes[i]).t < Player.y - 1e9) then begin
        Remove(Boxes[i]);
      end;
    end;
end;

procedure TWorld.Save;
var
  i: Integer;
const
  prefix: Byte = $80;
begin
  Stream.WriteSignature;
  Stream.WriteUTF8Str('DATA');
  Stream.WriteUTF8Str('Objects');
  Stream.WriteListEnd;
  for i := 0 to Objects.Count-1 do begin
    Stream.WriteComponent(TGameObject(Objects[i]));
  end;
  Stream.WriteListEnd;
end;

initialization
  Wld := TWorld.Create;
  RegisterClasses([TRoad, TPlayer]);

finalization
  FreeAndNil(Wld);

end.
