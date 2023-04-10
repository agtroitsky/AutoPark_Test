unit uPathList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, AutoPark_Data, System.UITypes;

type
  TfrmPathList = class(TForm)
    dpDateOut: TDateTimePicker;
    tpTimeOut: TDateTimePicker;
    dpDateIn: TDateTimePicker;
    tpTimeIn: TDateTimePicker;
    cbCar: TComboBox;
    Label3: TLabel;
    cbDriver: TComboBox;
    Label4: TLabel;
    cbDisp: TComboBox;
    Label5: TLabel;
    cbOut: TCheckBox;
    cbIn: TCheckBox;
    cbDeleted: TCheckBox;
    edFuel: TEdit;
    Label1: TLabel;
    edPath: TEdit;
    Label2: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure cbOutClick(Sender: TObject);
    procedure cbInClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    fdFuel, fdPath: double;
  public
    { Public declarations }
    function DoPathList(var aData: TPathListRec): boolean;
  end;

var
  frmPathList: TfrmPathList;

implementation

{$R *.dfm}

uses uCommon;

procedure TfrmPathList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edFuel.Text = '' then fdfuel:=0
  else if not floatBoolValidation(edFuel.Text,fdFuel) then begin
    MessageDlg('Неверно указан расход топлива',mtError,[mbOk],0);
    edFuel.SetFocus;
    exit;
  end;
  if fdFuel < 0 then begin
    MessageDlg('Расход топлива не может быть отрицательным',mtError,[mbOk],0);
    edFuel.SetFocus;
    exit;
  end;
  if edPath.Text = '' then fdPath:=0
  else if not floatBoolValidation(edPath.Text,fdPath) then begin
    MessageDlg('Неверно указан пробег',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  if fdPath < 0 then begin
    MessageDlg('Пробег не может быть отрицательным',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  if cbCar.Text = '' then begin
    MessageDlg('Не выбран автомобиль',mtError,[mbOk],0);
    cbCar.SetFocus;
    exit;
  end;
  if cbDriver.Text = '' then begin
    MessageDlg('Не выбран водитель',mtError,[mbOk],0);
    cbDriver.SetFocus;
    exit;
  end;
  if cbDisp.Text = '' then begin
    MessageDlg('Не выбран диспетчер',mtError,[mbOk],0);
    cbDisp.SetFocus;
    exit;
  end;
  i:=Integer(cbDriver.Items.Objects[cbDriver.ItemIndex]);
  if Drivers[i].bDeleted then begin
    MessageDlg('Указан удаленный водитель',mtError,[mbOk],0);
    exit;
  end;
  i:=Integer(cbCar.Items.Objects[cbCar.ItemIndex]);
  if Cars[i].bDeleted then begin
    MessageDlg('Указан удаленный автомобиль',mtError,[mbOk],0);
    exit;
  end;
  i:=Integer(cbDisp.Items.Objects[cbDisp.ItemIndex]);
  if Dispatchers[i].bDeleted then begin
    MessageDlg('Указан удаленный диспетчер',mtError,[mbOk],0);
    exit;
  end;
  if cbIn.Checked and (not cbOut.Checked) then begin
    MessageDlg('Указано время возвращения'#13'но не указано время выезда',mtError,[mbOk],0);
    cbOut.SetFocus;
    exit;
  end;
  if cbIn.Checked and cbOut.Checked then begin
    if dpDateOut.Date > dpDateIn.Date then begin
      MessageDlg('Дата возвращения раньше даты выезда',mtError,[mbOk],0);
      dpDateOut.SetFocus;
      exit;
    end;
    if (dpDateOut.Date = dpDateIn.Date) and (tpTimeIn.Time < tpTimeOut.Time) then begin
      MessageDlg('Время возвращения раньше времени выезда',mtError,[mbOk],0);
      tpTimeOut.SetFocus;
      exit;
    end;
  end;
  CanClose:=true;
end;

procedure TfrmPathList.cbOutClick(Sender: TObject);
begin
  tpTimeOut.Visible:=cbOut.Checked;
  dpDateOut.Visible:=cbOut.Checked;
end;

procedure TfrmPathList.cbInClick(Sender: TObject);
begin
  tpTimeIn.Visible:=cbIn.Checked;
  dpDateIn.Visible:=cbIn.Checked;
end;

function TfrmPathList.DoPathList(var aData: TPathListRec): boolean;
var
  i: integer;
begin
  result:=false;
  if aData.iID < 0 then i:=Length(PathLists) else i:=aData.iID;
  Caption:='Путевой лист №'+IntToStr(i+1);
  if aData.iID < 0 then begin
    cbDriver.Items.Clear;
    for i:=0 to High(Drivers) do if not Drivers[i].bDeleted then
      cbDriver.Items.AddObject(GetDriverName(Drivers[i].iID),TObject(i));
    cbDisp.Items.Clear;
    for i:=0 to High(Dispatchers) do if not Dispatchers[i].bDeleted then
        cbDisp.Items.AddObject(GetDispatcherName(Dispatchers[i].iID),TObject(i));
    cbCar.Items.Clear;
    for i:=0 to High(Cars) do if not Cars[i].bDeleted then
        cbCar.Items.AddObject(GetCarName(Cars[i].iID),TObject(i));
    cbOut.Checked:=false;
    dpDateOut.Date:=Int(Now);
    tpTimeOut.Time:=Frac(Now);
    cbIn.Checked:=false;
    dpDateIn.Date:=Int(Now);
    tpTimeIn.Time:=Frac(Now);
    edFuel.Text:='';
    edPath.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    cbDriver.Items.Clear;
    for i:=0 to High(Drivers) do if not Drivers[i].bDeleted then
      cbDriver.Items.AddObject(GetDriverName(Drivers[i].iID),TObject(i));
    cbDriver.ItemIndex:=cbDriver.Items.IndexOf(GetDriverName(iDriverID));
    cbDisp.Items.Clear;
    for i:=0 to High(Dispatchers) do if not Dispatchers[i].bDeleted then
        cbDisp.Items.AddObject(GetDispatcherName(Dispatchers[i].iID),TObject(i));
    cbDisp.ItemIndex:=cbDisp.Items.IndexOf(GetDispatcherName(iDispID));
    cbCar.Items.Clear;
    for i:=0 to High(Cars) do if not Cars[i].bDeleted then
        cbCar.Items.AddObject(GetCarName(Cars[i].iID),TObject(i));
    cbCar.ItemIndex:=cbCar.Items.IndexOf(GetCarName(iCarID));
    if tTimeIn = 0 then begin
      cbIn.Checked:=false;
      dpDateIn.Date:=Int(Now);
      tpTimeIn.Time:=Frac(Now);
    end
    else begin
      cbIn.Checked:=true;
      dpDateIn.Date:=Int(tTimeIn);
      tpTimeIn.Time:=Frac(tTimeIn);
    end;
    if tTimeOut = 0 then begin
      cbOut.Checked:=false;
      dpDateOut.Date:=Int(Now);
      tpTimeOut.Time:=Frac(Now);
    end
    else begin
      cbOut.Checked:=true;
      dpDateOut.Date:=Int(tTimeOut);
      tpTimeOut.Time:=Frac(tTimeOut);
    end;
    edFuel.Text:=format('%.1f',[dFuel]);
    edPath.Text:=format('%.1f',[dPath]);
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    iDriverID:=Drivers[Integer(cbDriver.Items.Objects[cbDriver.ItemIndex])].iID;
    iDispID:=Dispatchers[Integer(cbDisp.Items.Objects[cbDisp.ItemIndex])].iID;
    iCarID:=Cars[Integer(cbCar.Items.Objects[cbCar.ItemIndex])].iID;
    if cbIn.Checked then tTimeIn:=Int(dpDateIn.Date)+Frac(tpTimeIn.Time)
    else tTimeIn:=0;
    if cbOut.Checked then tTimeOut:=Int(dpDateOut.Date)+Frac(tpTimeOut.Time)
    else tTimeOut:=0;
    dFuel:=fdFuel;
    dPath:=fdPath;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

end.
