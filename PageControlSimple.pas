unit PageControlSimple;

interface

uses
  SysUtils, Classes, Controls, ComCtrls, Messages, CommCtrl, Windows;

type
  TPageControlSimple = class(TPageControl)
  private
    function GetActivePageIndex: Integer;
    procedure HideTitle;
    procedure SetActivePageIndex(const Value: Integer);
    { Private declarations }
  protected
    procedure Loaded; override;
    { Protected declarations }
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    property ActivePageIndex: Integer read GetActivePageIndex write
        SetActivePageIndex;
    Procedure AdjustClientRect(var Rect: TRect); override;    
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('KIV', [TPageControlSimple]);
end;

procedure TPageControlSimple.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  if (csDesigning in ComponentState) then
      Inherited AdjustClientRect(Rect)
  else
    Rect.Top:=0;
end;

constructor TPageControlSimple.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style:=tsFlatButtons;
end;

function TPageControlSimple.GetActivePageIndex: Integer;
begin
Result:=inherited ActivePageIndex;
end;

procedure TPageControlSimple.HideTitle;
var
  i: Integer;
begin
for i:=0 to PageCount-1 do
  Pages[i].TabVisible:=False;
end;

procedure TPageControlSimple.Loaded;
begin
  inherited Loaded;
  if not ((csDesigning in ComponentState) or (csReading in ComponentState)) then
    ActivePageIndex:=ActivePageIndex;
end;

procedure TPageControlSimple.SetActivePageIndex(const Value: Integer);
begin
HideTitle;
inherited ActivePageIndex:=Value;
end;

procedure TPageControlSimple.WndProc(var Message: TMessage);
begin
inherited WndProc(Message);
with Message do
  if (Msg = TCM_ADJUSTRECT) and (Message.WParam = 0) then
    InflateRect(PRect(LParam)^, 4, 4);
end;

end.
