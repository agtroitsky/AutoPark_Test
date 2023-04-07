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

uses AutoPark_Data, uCar, uCarModel;

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
      aData.iID:=i;
      SetLength(CarModels,i+1);
      CarModels[i]:=aData;
      sgList.RowCount:=i+1;
      sgList.Cells[0,i]:=GetCarModelName(i);
    end;
    stCar: begin
      if not frmCar.DoCar(aData) then exit;
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
      for i:=0 to High(Drivers) do sgList.Cells[0,i]:=GetDriverName(i,false);
    end;
    stDispatcher: begin
      Caption:='Диспетчеры';
      sgList.RowCount:=Length(Dispatchers);
      for i:=0 to High(Dispatchers) do sgList.Cells[0,i]:=GetDispName(i,false);
    end;
    stCarModel: begin
      Caption:='Модели автомобилей';
      sgList.RowCount:=Length(CarModels);
      for i:=0 to High(CarModels) do begin
        sgList.Cells[0,i]:=GetCarModelName(i);
        sgList.Objects[0,i]:=TObject(i);
      end;
    end;
    stCar: begin
      Caption:='Автомобили';
      sgList.RowCount:=Length(Cars);
      for i:=0 to High(Cars) do sgList.Cells[0,i]:=GetCarName(i,false);
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
  i,selRow: integer;
  aData: TDataRec;
begin
  selRow:=sgList.Selection.Top;
  i:=Integer(sgList.Objects[0,selRow]);
  case fiStyle of
    stCarModel: begin
      aData:=CarModels[i];
      if not frmCarModel.DoCarModel(aData) then exit;
      if not dmAutoPark.DoCarModelData(aData) then exit;
      CarModels[i]:=aData;
      sgList.Cells[0,selRow]:=GetCarModelName(i);

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
  s:=sgList.Cells[ACol,ARow];
  selRow:=sgList.Selection.Top;
  case fiStyle of
    stDriver: bol:=Drivers[ARow].bDeleted;
    stDispatcher: bol:=Dispatchers[ARow].bDeleted;
    stCarModel: bol:=CarModels[ARow].bDeleted;
    stCar: bol:=Cars[ARow].bDeleted;
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
