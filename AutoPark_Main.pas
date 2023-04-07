unit AutoPark_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ExtCtrls, Vcl.StdCtrls, System.UITypes,
  Vcl.Buttons, Vcl.Menus;

type
  TfrmAutoParkMain = class(TForm)
    Panel1: TPanel;
    sgPathLists: TStringGrid;
    cbShowDelete: TCheckBox;
    Button1: TButton;
    SpeedButton1: TSpeedButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    miDrivers: TMenuItem;
    miDisps: TMenuItem;
    miCarModels: TMenuItem;
    miCars: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sgPathListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure cbShowDeleteClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure miDriversClick(Sender: TObject);
    procedure miDispsClick(Sender: TObject);
    procedure miCarModelsClick(Sender: TObject);
    procedure miCarsClick(Sender: TObject);
  private
    { Private declarations }
    procedure GridUpdate;
    procedure GridClear;
    procedure HideDelete;
  public
    { Public declarations }
  end;

var
  frmAutoParkMain: TfrmAutoParkMain;

implementation

{$R *.dfm}

uses AutoPark_Data, uPathList, uCar, uList;

var
  lflag: boolean = true;

procedure TfrmAutoParkMain.GridUpdate;
var
  i,k: integer;
begin
  sgPathLists.RowCount:=Length(ListOrder)+1;
  for i:=1 to Length(ListOrder) do begin
    k:=ListOrder[i-1];
    with sgPathLists do with PathLists[k] do begin
      Cells[0,i]:=IntToStr(k+1);
      Cells[1,i]:=Cars[iCarID].sNumber;
      Cells[2,i]:=GetDriverName(iDriverID);
      Cells[3,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeIn);
      Cells[4,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeOut);
      Cells[5,i]:=format('%.1f',[dlPath]);
      Cells[6,i]:=format('%.1f',[dFuel]);
      Cells[7,i]:=GetDispName(iDriverID);
    end;
  end;
end;

procedure TfrmAutoParkMain.GridClear;
var
  i: integer;
begin
  with sgPathLists do begin
    RowCount:=2;
    for i:=0 to ColCount-1 do Cells[i,1]:='';
  end;
end;

procedure TfrmAutoParkMain.HideDelete;
var
  i: integer;
begin
  if cbShowDelete.Checked then exit;
  for i:=High(ListOrder) downto 0 do if PathLists[ListOrder[i]].bDeleted then Delete(ListOrder,i,1);
end;

procedure TfrmAutoParkMain.miCarModelsClick(Sender: TObject);
begin
  frmList.DoList(stCarModel);
end;

procedure TfrmAutoParkMain.miCarsClick(Sender: TObject);
begin
  frmList.DoList(stCar);
end;

procedure TfrmAutoParkMain.miDispsClick(Sender: TObject);
begin
  frmList.DoList(stDispatcher);
end;

procedure TfrmAutoParkMain.miDriversClick(Sender: TObject);
begin
  frmList.DoList(stDriver);
end;

procedure TfrmAutoParkMain.Button1Click(Sender: TObject);
var
  rList: TDataRec;
begin
  rList.iID:=-1;
  if not frmPathList.DoPathList(rList) then exit;
end;

procedure TfrmAutoParkMain.cbShowDeleteClick(Sender: TObject);
begin
  if dmAutoPark.GetData then begin
    HideDelete;
    GridUpdate;
  end
  else GridClear;
end;

procedure TfrmAutoParkMain.FormActivate(Sender: TObject);
begin
  if not lflag then exit;
  lflag:=false;

  if dmAutoPark.GetData then begin
    HideDelete;
    GridUpdate;
  end
  else GridClear;


end;

procedure TfrmAutoParkMain.FormCreate(Sender: TObject);
var
  i,n: integer;
begin
  with sgPathLists do begin
    RowCount:=2;
    ColCount:=8;
    Cells[0,0]:='№';
    Cells[1,0]:='Автомобиль';
    Cells[2,0]:='Водитель';
    Cells[3,0]:='Время выезда';
    Cells[4,0]:='Время приезда';
    Cells[5,0]:='Пробег, км';
    Cells[6,0]:='Бензин, л';
    Cells[7,0]:='Диспетчер';
    ColWidths[0]:=50;
    ColWidths[1]:=100;
    ColWidths[2]:=150;
    ColWidths[3]:=120;
    ColWidths[4]:=120;
    ColWidths[5]:=90;
    ColWidths[6]:=90;
    ColWidths[7]:=150;
    n:=0;
    for i:=0 to ColCount-1 do n:=n+ColWidths[i];
  end;
  Width:=n+53;
end;

procedure TfrmAutoParkMain.sgPathListsDrawCell(Sender: TObject; ACol,
                    ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i,selRow: integer;
  s: string;
begin
  s:=sgPathLists.Cells[ACol,ARow];
  selRow:=sgPathLists.Selection.Top;
  with sgPathLists.Canvas do begin
    if gdFixed in State then Brush.Color:=clBtnFace
    else if ARow = selRow then Brush.Color:=clSkyBlue
    else Brush.Color:=clWhite;
    FillRect(Rect);
    Font.Color:=clBlack;
    if ARow <> 0 then begin
      i:=StrToInt(sgPathLists.Cells[0,ARow])-1;
      if PathLists[i].bDeleted then Font.Color:=clRed;
    end;
    TextOut(Rect.Left+5,Rect.Top+5,s);
  end;
end;

procedure TfrmAutoParkMain.SpeedButton1Click(Sender: TObject);
var
  Car: TDataRec;
begin
  Car:=CarModels[0];
  frmCar.ShowModal;
exit;
  Car.iID:=-1;
  dmAutoPark.DoCarModelData(Car);
end;

end.
