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
    function DoPathList(var aData: TDataRec): boolean;
  end;

var
  frmPathList: TfrmPathList;

implementation

{$R *.dfm}

uses uCommon;

procedure TfrmPathList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edFuel.Text = '' then begin
    MessageDlg('Не указан расход топлива',mtError,[mbOk],0);
    edFuel.SetFocus;
    exit;
  end;
  if not floatBoolValidation(edFuel.Text,fdFuel) then begin
    MessageDlg('Неверно указан расход топлива',mtError,[mbOk],0);
    edFuel.SetFocus;
    exit;
  end;
  if fdFuel < 0 then begin
    MessageDlg('Расход топлива не может быть отрицательным',mtError,[mbOk],0);
    edFuel.SetFocus;
    exit;
  end;
  if edPath.Text = '' then begin
    MessageDlg('Не указан пробег',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  if not floatBoolValidation(edPath.Text,fdPath) then begin
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
    if (dpDateOut.Date = dpDateIn.Date) and (tpTimeOut.Time < tpTimeIn.Time) then begin
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

function TfrmPathList.DoPathList(var aData: TDataRec): boolean;
var
  i: integer;
begin
  result:=false;
  if aData.iID < 0 then i:=Length(PathLists) else i:=aData.iID;
  Caption:='Путевой лист №'+IntToStr(i+1);
  if aData.iID < 0 then begin
    cbDriver.Enabled:=true;
    cbDriver.Items.Clear;
    for i:=0 to High(Drivers) do if not Drivers[i].bDeleted then
      cbDriver.Items.AddObject(GetDriverName(i,false),TObject(i));
    cbDisp.Enabled:=true;
    cbDisp.Items.Clear;
    for i:=0 to High(Dispatchers) do if not Dispatchers[i].bDeleted then
        cbDisp.Items.AddObject(GetDispName(i,false),TObject(i));
    cbCar.Enabled:=true;
    cbCar.Items.Clear;
    for i:=0 to High(Cars) do if not Cars[i].bDeleted then
        cbCar.Items.AddObject(GetCarName(i,false),TObject(i));
    cbOut.Checked:=false;
    cbIn.Checked:=false;
    edFuel.Text:='';
    edPath.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    cbDriver.Text:=GetDriverName(iDriverID,false);
    cbDriver.Enabled:=false;
    cbDisp.Text:=GetDispName(iDispID,false);
    cbDisp.Enabled:=false;
    cbCar.Text:=GetCarName(iCarID,false);
    cbCar.Enabled:=false;
    if tTimeIn = 0 then cbIn.Checked:=false
    else begin
      cbIn.Checked:=true;
      dpDateIn.Date:=Int(tTimeIn);
      tpTimeIn.Time:=Frac(tTimeIn);
    end;
    if tTimeOut = 0 then cbOut.Checked:=false
    else begin
      cbOut.Checked:=true;
      dpDateOut.Date:=Int(tTimeOut);
      tpTimeOut.Time:=Frac(tTimeOut);
    end;
    edFuel.Text:=format('%.1f',[dFuel]);
    edPath.Text:=format('%.1f',[dlPath]);
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    if iID < 0 then begin
      iDriverID:=Integer(cbDriver.Items.Objects[cbDriver.ItemIndex]);
      iDispID:=Integer(cbDisp.Items.Objects[cbDisp.ItemIndex]);
      iCarID:=Integer(cbCar.Items.Objects[cbCar.ItemIndex]);
    end;
    if cbIn.Checked then tTimeIn:=dpDateIn.Date+tpTimeIn.Time
    else tTimeIn:=0;
    if cbOut.Checked then tTimeOut:=dpDateOut.Date+tpTimeOut.Time
    else tTimeOut:=0;
    dFuel:=fdFuel;
    dlPath:=fdPath;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

end.
