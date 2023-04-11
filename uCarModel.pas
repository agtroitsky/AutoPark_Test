(*******************************************************************************
  * @project AutoPark
  * @file    uCarModel.pas
  * @date    11/04/2023
  * @brief   Форма редактирования справочника моделей автомобилей
  ******************************************************************************
  *
  * COPYRIGHT(c) 2023 А.Г.Троицкий
  *
*******************************************************************************)

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
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
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
    MessageDlg('Не указана марка',mtError,[mbOk],0);
    edFirm.SetFocus;
    exit;
  end;
  if Length(edFirm.Text) > lStrMax then begin
    MessageDlg('Марка должна быть не длинее '+IntToStr(lStrMax)+' символов',mtError,[mbOk],0);
    edFirm.SetFocus;
    exit;
  end;
  if edModel.Text = '' then begin
    MessageDlg('Не указана модель',mtError,[mbOk],0);
    edModel.SetFocus;
    exit;
  end;
  if Length(edModel.Text) > lStrMax then begin
    MessageDlg('Модель должна быть не длинее '+IntToStr(lStrMax)+' символов',mtError,[mbOk],0);
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
  if aData.iID < 0 then i:=Length(CarModels)+1 else i:=aData.iID;
  Caption:='Модель автомобиля '+IntToStr(i);
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

procedure TfrmCarModel.FormShow(Sender: TObject);
begin
  edFirm.SetFocus;
end;

procedure TfrmCarModel.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult:=mrCancel;
  if Key = VK_RETURN then ModalResult:=mrOk;
end;

end.
