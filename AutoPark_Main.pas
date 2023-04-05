unit AutoPark_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls;

type
  TfrmAutoParkMain = class(TForm)
    Panel1: TPanel;
    sgPathLists: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sgPathListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAutoParkMain: TfrmAutoParkMain;

implementation

{$R *.dfm}

uses AutoPark_Data;

var
  lflag: boolean = true;

procedure TfrmAutoParkMain.FormActivate(Sender: TObject);
var
  i,k: integer;
begin
  if not lflag then exit;
  lflag:=false;

  if dmAutoPark.GetData then begin
    sgPathLists.RowCount:=Length(PathLists)+1;
    for i:=1 to Length(PathLists) do begin
      k:=ListOrder[i-1];
      with sgPathLists do with PathLists[k] do begin
        Cells[0,i]:=IntToStr(k+1);
        Cells[1,i]:=Cars[iCarID].sNumber;
        Cells[2,i]:=GetDriverShortName(iDriverID);
        Cells[3,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeIn);
        Cells[4,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeOut);
        Cells[5,i]:=format('%.1f',[dPath]);
        Cells[6,i]:=format('%.1f',[dFuel]);
        Cells[7,i]:=GetDispShortName(iDriverID);
      end;
    end;
  end;

end;

procedure TfrmAutoParkMain.FormCreate(Sender: TObject);
begin
  with sgPathLists do begin
    ColCount:=8;
    Cells[0,0]:='№';
    Cells[1,0]:='Автомобиль';
    Cells[2,0]:='Водитель';
    Cells[3,0]:='Время выезда';
    Cells[4,0]:='Время приезда';
    Cells[5,0]:='Пробег, км';
    Cells[6,0]:='Бензин, л';
    Cells[7,0]:='Диспетчер';
    ColWidths[0]:=30;
    ColWidths[1]:=120;
    ColWidths[2]:=120;
    ColWidths[3]:=120;
    ColWidths[4]:=120;
    ColWidths[5]:=120;
    ColWidths[6]:=120;
    ColWidths[7]:=120;
  end;
end;

procedure TfrmAutoParkMain.sgPathListsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i: integer;
  s: string;
begin
  s:=sgPathLists.Cells[ACol,ARow];
  with sgPathLists.Canvas do begin
    Brush.Color:=clWhite;
    if gdFixed in State then begin
      Brush.Color:=clBtnFace;
      FillRect(Rect);
    end;
    Font.Color:=clBlack;
    if ARow <> 0 then begin
      i:=StrToInt(sgPathLists.Cells[0,ARow])-1;
      if PathLists[i].bDeleted then Font.Color:=clRed;
    end;
    TextOut(Rect.Left+5,Rect.Top+5,s);
  end;


end;

end.
