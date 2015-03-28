unit GameObject;

interface uses
  Classes;

type
  TGameObject = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; virtual; abstract;
    procedure Move; virtual; abstract;
  end;

implementation uses
  SysUtils, World;

{ TGameObject }

constructor TGameObject.Create;
begin
  inherited Create(nil);
  Wld.Objects.Add(Self);
end;

destructor TGameObject.Destroy;
begin
  inherited;
end;

end.
