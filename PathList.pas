unit PathList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls;

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
    CheckBox2: TCheckBox;
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
  public
    { Public declarations }
    function DoList(aID: integer): boolean;
  end;

var
  frmPathList: TfrmPathList;

implementation

{$R *.dfm}

uses AutoPark_Data;

function floatBoolValidation(s: string; var d: double): boolean;
var
  i: integer;
  c: char;
begin
  c:=TFormatSettings.Create.DecimalSeparator;
  result:=true;
  i:=Pos('.',s);
  if i > 0 then s[i]:=c;
  i:=Pos(',',s);
  if i > 0 then s[i]:=c;
  try
    d:=StrToFloat(s);
  except
    result:=false;
  end;
end;

procedure TfrmPathList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;

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

function TfrmPathList.DoList(aID: integer): boolean;
var
  i: integer;
  d: double;
begin
  result:=false;
  Caption:='Путевой лист №'+IntToStr(Length(PathLists)+1);
  cbDriver.Items.Clear;
  for i:=0 to High(Drivers) do if not Drivers[i].bDeleted then
      cbDriver.Items.AddObject(GetDriverName(i,false),TObject(i));
  cbDisp.Items.Clear;
  for i:=0 to High(Dispatchers) do if not Dispatchers[i].bDeleted then
      cbDisp.Items.AddObject(GetDispName(i,false),TObject(i));
  cbCar.Items.Clear;
  for i:=0 to High(Cars) do if not Cars[i].bDeleted then
      cbCar.Items.AddObject(GetCarName(i,false),TObject(i));
  if ShowModal <> mrOk then exit;
  if not floatBoolValidation(edFuel.Text,d) then begin

end;

end.
