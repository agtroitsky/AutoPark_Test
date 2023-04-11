(*******************************************************************************
  * @project AutoPark
  * @file    uCar.pas
  * @date    11/04/2023
  * @brief   Форма редактирования справочника автомобилей
  ******************************************************************************
  *
  * COPYRIGHT(c) 2023 А.Г.Троицкий
  *
*******************************************************************************)

unit uCar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.ComCtrls, AutoPark_Data;

type
  TfrmCar = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    cbCarModel: TComboBox;
    Label2: TLabel;
    dpTODate: TDateTimePicker;
    Label4: TLabel;
    Label5: TLabel;
    edPath: TEdit;
    cbDeleted: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    seYear: TSpinEdit;
    edNumber: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fdPath: double;
    iCurrentID: integer;
  public
    { Public declarations }
    function DoCar(var aData: TDataRec): boolean;
  end;

var
  frmCar: TfrmCar;

implementation

{$R *.dfm}

uses uCommon;

function TfrmCar.DoCar(var aData: TDataRec): boolean;
var
  i: integer;
begin
  result:=false;
  if aData.iID < 0 then i:=Length(Cars)+1 else i:=aData.iID;
  Caption:='Автомобиль '+IntToStr(i);
  iCurrentID:=aData.iID;
  if aData.iID < 0 then begin
    edNumber.Text:='';
    cbCarModel.Items.Clear;
    for i:=0 to High(CarModels) do if not CarModels[i].bDeleted then
      cbCarModel.Items.AddObject(GetCarModelName(CarModels[i].iID),TObject(i));
    seYear.Value:=CurrentYear;
    dpTODate.Date:=Int(Now);
    edPath.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    edNumber.Text:=sNumber;
    cbCarModel.Items.Clear;
    for i:=0 to High(CarModels) do if not CarModels[i].bDeleted then
      cbCarModel.Items.AddObject(GetCarModelName(CarModels[i].iID),TObject(i));
    cbCarModel.ItemIndex:=cbCarModel.Items.IndexOf(GetCarModelName(iCarModelID));
    seYear.Value:=iYear;
    dpTODate.Date:=tLastTO;
    edPath.Text:=format('%.1f',[dPath]);
    cbDeleted.Checked:=bDeleted;
  end;
  if ShowModal <> mrOk then exit;
  with aData do begin
    iCarModelID:=CarModels[Integer(cbCarModel.Items.Objects[cbCarModel.ItemIndex])].iID;
    sNumber:=edNumber.Text;
    iYear:=seYear.Value;
    tLastTO:=dpTODate.Date;
    dPath:=fdPath;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

procedure TfrmCar.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edNumber.Text = '' then begin
    MessageDlg('Не указан гос. номер',mtError,[mbOk],0);
    edNumber.SetFocus;
    exit;
  end;
  if Length(edNumber.Text) > lNumMax then begin
    MessageDlg('Номер должен быть не длинее '+IntToStr(lNumMax)+' символов',mtError,[mbOk],0);
    edNumber.SetFocus;
    exit;
  end;
  for i:=0 to High(Cars) do if (edNumber.Text = Cars[i].sNumber) and (Cars[i].iID <> iCurrentID) then begin
    MessageDlg('Такой номер уже есть в системе',mtError,[mbOk],0);
    edNumber.SetFocus;
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
  CanClose:=true;
end;

procedure TfrmCar.FormShow(Sender: TObject);
begin
  edNumber.SetFocus;
end;

procedure TfrmCar.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult:=mrCancel;
  if Key = VK_RETURN then ModalResult:=mrOk;
end;

end.
