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
    btnNew: TButton;
    MainMenu1: TMainMenu;
    miReferences: TMenuItem;
    miDrivers: TMenuItem;
    miDisps: TMenuItem;
    miCarModels: TMenuItem;
    miCars: TMenuItem;
    btnView: TButton;
    btnExcel: TButton;
    btnWord: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sgPathListsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnNewClick(Sender: TObject);
    procedure miDriversClick(Sender: TObject);
    procedure miDispsClick(Sender: TObject);
    procedure miCarModelsClick(Sender: TObject);
    procedure miCarsClick(Sender: TObject);
    procedure sgPathListsDblClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnExcelClick(Sender: TObject);
    procedure btnWordClick(Sender: TObject);
  private
    { Private declarations }
    procedure GridUpdate;
  public
    { Public declarations }
  end;

var
  frmAutoParkMain: TfrmAutoParkMain;

implementation

{$R *.dfm}

uses AutoPark_Data, uPathList, uCar, uList, uView, uExport, IniFiles, uCommon;

var
  lflag: boolean = true;

procedure TfrmAutoParkMain.GridUpdate;
var
  i,k: integer;
begin
  if not dmAutoPark.GetViewLists then exit;
  sgPathLists.RowCount:=Length(PathLists)+1;
  for i:=1 to Length(PathLists) do begin
    with sgPathLists do with PathLists[i-1] do begin
      Cells[0,i]:=IntToStr(iID);
      Cells[1,i]:=sCar;
      Cells[2,i]:=sDriver;
      if tTimeOut = 0 then Cells[3,i]:=''
      else Cells[3,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeOut);
      if tTimeIn = 0 then Cells[4,i]:=''
      else Cells[4,i]:=FormatDateTime('hh:nn dd.mm.yyyy',tTimeIn);
      Cells[5,i]:=format('%.1f',[dPath]);
      Cells[6,i]:=format('%.1f',[dFuel]);
      Cells[7,i]:=sDispatcher;
    end;
  end;
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

procedure TfrmAutoParkMain.btnExcelClick(Sender: TObject);
begin
  ExportToExcel(PathLists[sgPathLists.Selection.Top-1].iID);
end;

procedure TfrmAutoParkMain.btnWordClick(Sender: TObject);
begin
  ExportToWord(PathLists[sgPathLists.Selection.Top-1].iID);
end;

procedure TfrmAutoParkMain.btnNewClick(Sender: TObject);
var
  i: integer;
  aData: TPathListRec;
begin
  aData.iID:=-1;
  if not frmPathList.DoPathList(aData) then exit;
  if not dmAutoPark.DoPathListData(aData) then exit;
  if aData.dPath > 0 then dmAutoPark.AddPathToCar(aData.iCarID,aData.dPath);
  GridUpdate;
end;

procedure TfrmAutoParkMain.sgPathListsDblClick(Sender: TObject);
var
  i: integer;
  aData: TPathListRec;
  d: double;
begin
  i:=sgPathLists.Selection.Top-1;
  aData:=PathLists[i];
  if not frmPathList.DoPathList(aData) then exit;
  if not dmAutoPark.DoPathListData(aData) then exit;
  d:=aData.dPath - PathLists[i].dPath;
  if d <> 0 then dmAutoPark.AddPathToCar(aData.iCarID,d);
  GridUpdate;
end;

procedure TfrmAutoParkMain.btnViewClick(Sender: TObject);
begin
  if not frmView.DoView then exit;
  GridUpdate;
end;

// Инициализация приложения после создания всех форм и units
procedure TfrmAutoParkMain.FormActivate(Sender: TObject);
var
  IniFile: TIniFile;
  s: string;
begin
  if not lflag then exit;
  lflag:=false;

  IniFile:=TIniFile.Create(ExePath+IniName);
  s:='Provider=MSDASQL.1;Persist Security Info=True;User ID=';
  s:=s+IniFile.ReadString('Connect','User','')+';';
  s:=s+'Password='+IniFile.ReadString('Connect','Password','')+';';
  s:=s+'Extended Properties="Driver=MySQL ODBC 8.0 ANSI Driver;SERVER=';
  s:=s+IniFile.ReadString('Connect','Server','')+';';
  s:=s+'UID='+IniFile.ReadString('Connect','User','')+';';
  s:=s+'PWD='+IniFile.ReadString('Connect','Password','')+';';
  s:=s+'DATABASE='+IniFile.ReadString('Connect','Database','')+';';
  s:=s+'PORT='+IniFile.ReadString('Connect','Port','')+'"';
  dmAutoPark.ADOConnection.ConnectionString:=s;
  with ExcelFields do begin
    sFileIn:=IniFile.ReadString('Excel','FileIn','');
    sFileOut:=IniFile.ReadString('Excel','FileOut','');
    sfPathListNum:=IniFile.ReadString('Excel','PathListNum','');
    sfDriver:=IniFile.ReadString('Excel','Driver','');
    sfDispatcher:=IniFile.ReadString('Excel','Dispatcher','');
    sfTimeIn:=IniFile.ReadString('Excel','TimeIn','');
    sfTimeOut:=IniFile.ReadString('Excel','TimeOut','');
    sfFuel:=IniFile.ReadString('Excel','Fuel','');
    sfPath:=IniFile.ReadString('Excel','Path','');
    sfCarModel:=IniFile.ReadString('Excel','CarModel','');
    sfCarNumber:=IniFile.ReadString('Excel','CarNumber','');
  end;
  with WordFields do begin
    sFileIn:=IniFile.ReadString('Word','FileIn','');
    sFileOut:=IniFile.ReadString('Word','FileOut','');
    sfPathListNum:=IniFile.ReadString('Word','PathListNum','');
    sfDriver:=IniFile.ReadString('Word','Driver','');
    sfDispatcher:=IniFile.ReadString('Word','Dispatcher','');
    sfTimeIn:=IniFile.ReadString('Word','TimeIn','');
    sfTimeOut:=IniFile.ReadString('Word','TimeOut','');
    sfFuel:=IniFile.ReadString('Word','Fuel','');
    sfPath:=IniFile.ReadString('Word','Path','');
    sfCarModel:=IniFile.ReadString('Word','CarModel','');
    sfCarNumber:=IniFile.ReadString('Word','CarNumber','');
  end;
  IniFile.Free;
  if not dmAutoPark.GetAllData then exit;
  frmView.DoResetView;
  GridUpdate;
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
    ColWidths[0]:=30;
    ColWidths[1]:=100;
    ColWidths[2]:=150;
    ColWidths[3]:=100;
    ColWidths[4]:=100;
    ColWidths[5]:=70;
    ColWidths[6]:=70;
    ColWidths[7]:=150;
    n:=0;
    for i:=0 to ColCount-1 do n:=n+ColWidths[i];
  end;
  Width:=n+53;
  Caption:=Caption+'  '+GetMyVer;
end;

// Своя отрисовка таблицы для выделения красным цветом удаленных элементов
procedure TfrmAutoParkMain.sgPathListsDrawCell(Sender: TObject; ACol,
                    ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i,selRow: integer;
  s: string;
begin
  if Length(PathLists) = 0 then exit;
  s:=sgPathLists.Cells[ACol,ARow];
  selRow:=sgPathLists.Selection.Top;
  with sgPathLists.Canvas do begin
    if gdFixed in State then Brush.Color:=clBtnFace
    else if ARow = selRow then Brush.Color:=clSkyBlue
    else Brush.Color:=clWhite;
    FillRect(Rect);
    Font.Color:=clBlack;
    if ARow <> 0 then if PathLists[aRow-1].bDeleted then Font.Color:=clRed;
    i:=TextWidth(s) - sgPathLists.ColWidths[ACol]+10;
    if i > 0 then begin
      sgPathLists.ColWidths[ACol]:=sgPathLists.ColWidths[ACol]+i;
      sgPathLists.Width:=sgPathLists.Width+i;
    end;
    TextOut(Rect.Left+5,Rect.Top+5,s);
  end;
end;

end.
