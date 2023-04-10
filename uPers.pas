unit uPers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.Mask, Vcl.ComCtrls, AutoPark_Data;

type
  TfrmPers = class(TForm)
    Label1: TLabel;
    dpBirthDate: TDateTimePicker;
    Label4: TLabel;
    cbDeleted: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    edPatronymic: TEdit;
    Label2: TLabel;
    edName: TEdit;
    Label3: TLabel;
    edSurName: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    iCurrentID, iMode: integer;
  public
    { Public declarations }
    function DoDriver(var aData: TDataRec): boolean;
    function DoDispatcher(var aData: TDataRec): boolean;
  end;

var
  frmPers: TfrmPers;

implementation

{$R *.dfm}

uses uCommon;

const
  ModeDriver = 1;
  ModeDispatcher = 2;

function TfrmPers.DoDriver(var aData: TDataRec): boolean;
var
  i: integer;
begin
  result:=false;
  dpBirthDate.Visible:=true;
  Label4.Visible:=true;
  iCurrentID:=aData.iID;
  iMode:=ModeDriver;
  if aData.iID < 0 then i:=Length(Drivers)+1 else i:=aData.iID;
  Caption:='Водитель '+IntToStr(i);
  if aData.iID < 0 then begin
    edName.Text:='';
    edPatronymic.Text:='';
    edSurName.Text:='';
    dpBirthDate.Date:=Int(Now);
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    edName.Text:=sdrName;
    edPatronymic.Text:=sdrPatronymic;
    edSurName.Text:=sdrSurName;
    dpBirthDate.Date:=tBirthDate;
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    sdrName:=edName.Text;
    sdrPatronymic:=edPatronymic.Text;
    sdrSurName:=edSurName.Text;
    tBirthDate:=dpBirthDate.Date;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

function TfrmPers.DoDispatcher(var aData: TDataRec): boolean;
var
  i: integer;
begin
  dpBirthDate.Visible:=false;
  Label4.Visible:=false;
  result:=false;
  iCurrentID:=aData.iID;
  iMode:=ModeDispatcher;
  if aData.iID < 0 then i:=Length(Drivers)+1 else i:=aData.iID;
  Caption:='Диспетчер '+IntToStr(i);
  if aData.iID < 0 then begin
    edName.Text:='';
    edPatronymic.Text:='';
    edSurName.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    edName.Text:=sdsName;
    edPatronymic.Text:=sdsPatronymic;
    edSurName.Text:=sdsSurName;
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    sdsName:=edName.Text;
    sdsPatronymic:=edPatronymic.Text;
    sdsSurName:=edSurName.Text;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

procedure TfrmPers.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
  s:string;
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edName.Text = '' then begin
    MessageDlg('Не указано имя',mtError,[mbOk],0);
    edName.SetFocus;
    exit;
  end;
  if Length(edName.Text) > lStrMax then begin
    MessageDlg('Имя должно быть не длинее '+IntToStr(lStrMax)+' символов',mtError,[mbOk],0);
    edName.SetFocus;
    exit;
  end;
  if Length(edPatronymic.Text) > lStrMax then begin
    MessageDlg('Отчество должно быть не длинее '+IntToStr(lStrMax)+' символов',mtError,[mbOk],0);
    edPatronymic.SetFocus;
    exit;
  end;
  if edSurName.Text = '' then begin
    MessageDlg('Не указана фамилия',mtError,[mbOk],0);
    edSurName.SetFocus;
    exit;
  end;
  if Length(edSurName.Text) > lStrMax then begin
    MessageDlg('Фамилия должна быть не длинее '+IntToStr(lStrMax)+' символов',mtError,[mbOk],0);
    edSurName.SetFocus;
    exit;
  end;
  s:=edSurName.Text+' '+edName.Text+' '+edPatronymic.Text;
  if iMode = ModeDriver then begin
    for i:=0 to High(Drivers) do if (GetDriverName(Drivers[i].iID) = s) and (Drivers[i].iID <> iCurrentID) then begin
      MessageDlg('Такое сочетание ФИО уже есть в системе',mtError,[mbOk],0);
      edName.SetFocus;
      exit;
    end;
  end
  else begin
    for i:=0 to High(Dispatchers) do if (GetDispatcherName(Dispatchers[i].iID) = s) and (Dispatchers[i].iID <> iCurrentID) then begin
      MessageDlg('Такое сочетание ФИО уже есть в системе',mtError,[mbOk],0);
      edName.SetFocus;
      exit;
    end;
  end;

  CanClose:=true;
end;

procedure TfrmPers.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult:=mrCancel;
  if Key = VK_RETURN then ModalResult:=mrOk;
end;

procedure TfrmPers.FormShow(Sender: TObject);
begin
  edSurName.SetFocus;
end;

end.
