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
  private
    { Private declarations }
    fdPath: double;
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
  if aData.iID < 0 then i:=Length(Cars) else i:=aData.iID;
  Caption:='���������� '+IntToStr(i+1);
  if aData.iID < 0 then begin
    edNumber.Text:='';
    cbCarModel.Enabled:=true;
    cbCarModel.Items.Clear;
    for i:=0 to High(CarModels) do if not CarModels[i].bDeleted then
      cbCarModel.Items.AddObject(GetCarModelName(i),TObject(i));
    seYear.Value:=CurrentYear;
    dpTODate.Date:=Int(Now);
    edPath.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    edNumber.Text:=sNumber;
    cbCarModel.Enabled:=false;
    cbCarModel.Text:=GetCarModelName(iCarModelID);
    seYear.Value:=iYear;
    dpTODate.Date:=tLastTO;
    edPath.Text:=format('%.1f',[dcPath]);
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    if iID < 0 then begin
      iCarModelID:=Integer(cbCarModel.Items.Objects[cbCarModel.ItemIndex]);
    end;
    sNumber:=edNumber.Text;
    iYear:=seYear.Value;
    tLastTO:=dpTODate.Date;
    dcPath:=fdPath;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

procedure TfrmCar.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edNumber.Text = '' then begin
    MessageDlg('�� ������ ���. �����',mtError,[mbOk],0);
    edNumber.SetFocus;
    exit;
  end;
  if Length(edNumber.Text) > lNumMax then begin
    MessageDlg('����� ������ ���� �� ������ '+IntToStr(lNumMax)+' ��������',mtError,[mbOk],0);
    edNumber.SetFocus;
    exit;
  end;
  if edPath.Text = '' then begin
    MessageDlg('�� ������ ������',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  if not floatBoolValidation(edPath.Text,fdPath) then begin
    MessageDlg('������� ������ ������',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  if fdPath < 0 then begin
    MessageDlg('������ �� ����� ���� �������������',mtError,[mbOk],0);
    edPath.SetFocus;
    exit;
  end;
  CanClose:=true;
end;

end.
