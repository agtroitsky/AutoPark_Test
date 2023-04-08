unit uList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls;

const
  stDriver = 1;
  stDispatcher = 2;
  stCarModel = 3;
  stCar = 4;

type
  TfrmList = class(TForm)
    Panel1: TPanel;
    sgList: TStringGrid;
    btnCreate: TButton;
    procedure sgListDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure sgListDblClick(Sender: TObject);
  private
    { Private declarations }
    fiStyle: integer;
  public
    { Public declarations }
    procedure DoList(aStyle: integer);
  end;

var
  frmList: TfrmList;

implementation

{$R *.dfm}

uses AutoPark_Data, uCar, uCarModel, uPers;

procedure TfrmList.btnCreateClick(Sender: TObject);
var
  i: integer;
  aData: TDataRec;
begin
  aData.iID:=-1;
  case fiStyle of
    stCarModel: begin
      if not frmCarModel.DoCarModel(aData) then exit;
      if not dmAutoPark.DoCarModelData(aData) then exit;
      i:=Length(CarModels);
      aData.iID:=i+1;
      SetLength(CarModels,i+1);
      CarModels[i]:=aData;
      sgList.RowCount:=i+1;
      sgList.Cells[0,i]:=GetCarModelName(CarModels[i].iID);
    end;
    stCar: begin
      if not frmCar.DoCar(aData) then exit;
      if not dmAutoPark.DoCarData(aData) then exit;
      i:=Length(Cars);
      aData.iID:=i+1;
      SetLength(Cars,i+1);
      Cars[i]:=aData;
      sgList.RowCount:=i+1;
      sgList.Cells[0,i]:=GetCarName(Cars[i].iID,false);
    end;
    stDriver: begin
      if not frmPers.DoDriver(aData) then exit;
      if not dmAutoPark.DoDriverData(aData) then exit;
      i:=Length(Drivers);
      aData.iID:=i+1;
      SetLength(Drivers,i+1);
      Drivers[i]:=aData;
      sgList.RowCount:=i+1;
      sgList.Cells[0,i]:=GetDriverName(Drivers[i].iID,false);
    end;
    stDispatcher: begin
      if not frmPers.DoDispatcher(aData) then exit;
      if not dmAutoPark.DoDispatcherData(aData) then exit;
      i:=Length(Dispatchers);
      aData.iID:=i+1;
      SetLength(Dispatchers,i+1);
      Dispatchers[i]:=aData;
      sgList.RowCount:=i+1;
      sgList.Cells[0,i]:=GetDispatcherName(Dispatchers[i].iID,false);
    end;
  end;
end;

procedure TfrmList.DoList(aStyle: integer);
var
  i: integer;
begin
  fiStyle:=aStyle;
  case fiStyle of
    stDriver: begin
      Caption:='Водители';
      sgList.RowCount:=Length(Drivers);
      for i:=0 to High(Drivers) do sgList.Cells[0,i]:=GetDriverName(Drivers[i].iID,false);
    end;
    stDispatcher: begin
      Caption:='Диспетчеры';
      sgList.RowCount:=Length(Dispatchers);
      for i:=0 to High(Dispatchers) do sgList.Cells[0,i]:=GetDispatcherName(Dispatchers[i].iID,false);
    end;
    stCarModel: begin
      Caption:='Модели автомобилей';
      sgList.RowCount:=Length(CarModels);
      for i:=0 to High(CarModels) do sgList.Cells[0,i]:=GetCarModelName(CarModels[i].iID);
    end;
    stCar: begin
      Caption:='Автомобили';
      sgList.RowCount:=Length(Cars);
      for i:=0 to High(Cars) do sgList.Cells[0,i]:=GetCarName(Cars[i].iID,false);
    end;
    else begin
      MessageDlg('Неизвестный стиль'#13'Обратитесь к разработчику',mtError,[mbOk],0);
      exit;
    end;
  end;
  ShowModal;
end;

procedure TfrmList.FormResize(Sender: TObject);
const minWidth = 200;
begin
  if width < minWidth then Width:=minWidth;
  sgList.ColWidths[0]:=sgList.Width-25;
end;

procedure TfrmList.sgListDblClick(Sender: TObject);
var
  i: integer;
  aData: TDataRec;
begin
  i:=sgList.Selection.Top;
  case fiStyle of
    stCarModel: begin
      aData:=CarModels[i];
      if not frmCarModel.DoCarModel(aData) then exit;
      if not dmAutoPark.DoCarModelData(aData) then exit;
      CarModels[i]:=aData;
      sgList.Cells[0,i]:=GetCarModelName(CarModels[i].iID);
    end;
    stCar: begin
      aData:=Cars[i];
      if not frmCar.DoCar(aData) then exit;
      if not dmAutoPark.DoCarData(aData) then exit;
      Cars[i]:=aData;
      sgList.Cells[0,i]:=GetCarName(Cars[i].iID,false);
    end;
    stDriver: begin
      aData:=Drivers[i];
      if not frmPers.DoDriver(aData) then exit;
      if not dmAutoPark.DoDriverData(aData) then exit;
      Drivers[i]:=aData;
      sgList.Cells[0,i]:=GetDriverName(Drivers[i].iID,false);
    end;
    stDispatcher: begin
      aData:=Dispatchers[i];
      if not frmPers.DoDispatcher(aData) then exit;
      if not dmAutoPark.DoDispatcherData(aData) then exit;
      Dispatchers[i]:=aData;
      sgList.Cells[0,i]:=GetDispatcherName(Dispatchers[i].iID,false);
    end;
  end;
end;

procedure TfrmList.sgListDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i,selRow: integer;
  s: string;
  bol: boolean;
begin
  if sgList.RowCount = 0 then exit;
  s:=sgList.Cells[ACol,ARow];
  selRow:=sgList.Selection.Top;
  case fiStyle of
    stDriver: if Length(Drivers) > 0 then bol:=Drivers[ARow].bDeleted else exit;
    stDispatcher: if Length(Dispatchers) > 0 then bol:=Dispatchers[ARow].bDeleted else exit;
    stCarModel: if Length(CarModels) > 0 then bol:=CarModels[ARow].bDeleted else exit;
    stCar: if Length(Cars) > 0 then bol:=Cars[ARow].bDeleted else exit;
    else exit;
  end;
  with sgList.Canvas do begin
    if ARow = selRow then Brush.Color:=clSkyBlue
    else Brush.Color:=clWhite;
    FillRect(Rect);
    if bol then Font.Color:=clRed else Font.Color:=clBlack;
    i:=TextWidth(s) - sgList.ColWidths[0]+10;
    if i > 0 then begin
      sgList.ColWidths[0]:=sgList.ColWidths[0]+i;
    end;
    TextOut(Rect.Left+5,Rect.Top+5,s);
  end;
end;

end.
