unit uCarModel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AutoPark_Data;

type
  TfrmCarModel = class(TForm)
    Label5: TLabel;
    edModel: TEdit;
    cbDeleted: TCheckBox;
    btnOk: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    edFirm: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function DoCarModel(var aData: TDataRec): boolean;
  end;

var
  frmCarModel: TfrmCarModel;

implementation

{$R *.dfm}

uses uCommon;

procedure TfrmCarModel.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
  if ModalResult <> mrOk then exit;
  CanClose:=false;
  if edFirm.Text = '' then begin
    MessageDlg('�� ������� �����',mtError,[mbOk],0);
    edFirm.SetFocus;
    exit;
  end;
  if Length(edFirm.Text) > lStrMax then begin
    MessageDlg('����� ������ ���� �� ������ '+IntToStr(lStrMax)+' ��������',mtError,[mbOk],0);
    edFirm.SetFocus;
    exit;
  end;
  if edModel.Text = '' then begin
    MessageDlg('�� ������� ������',mtError,[mbOk],0);
    edModel.SetFocus;
    exit;
  end;
  if Length(edModel.Text) > lStrMax then begin
    MessageDlg('������ ������ ���� �� ������ '+IntToStr(lStrMax)+' ��������',mtError,[mbOk],0);
    edModel.SetFocus;
    exit;
  end;
  CanClose:=true;
end;

function TfrmCarModel.DoCarModel(var aData: TDataRec): boolean;
var
  i: integer;
begin
  result:=false;
  if aData.iID < 0 then i:=Length(CarModels) else i:=aData.iID;
  Caption:='������ ���������� '+IntToStr(i+1);
  if aData.iID < 0 then begin
    edFirm.Text:='';
    edModel.Text:='';
    cbDeleted.Checked:=false;
  end
  else with aData do begin
    edFirm.Text:=sFirm;
    edModel.Text:=sModel;
    cbDeleted.Checked:=bDeleted;
  end;

  if ShowModal <> mrOk then exit;
  with aData do begin
    sFirm:=edFirm.Text;
    sModel:=edModel.Text;
    bDeleted:=cbDeleted.Checked;
  end;
  result:=true;
end;

end.
