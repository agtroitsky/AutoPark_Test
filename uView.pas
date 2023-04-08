unit uView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AutoPark_Data;

type
  TfrmView = class(TForm)
    GroupBox1: TGroupBox;
    cbSort1: TComboBox;
    cbSort2: TComboBox;
    GroupBox2: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    procedure cbSort1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    function DoView: boolean;
  end;

var
  frmView: TfrmView;

implementation

{$R *.dfm}

procedure TfrmView.cbSort1Change(Sender: TObject);
begin
  with cbSort2.Items do begin
    Clear;
    case cbSort1.ItemIndex of
      vSortNumber, vSortPath, vSortFuel, vSortTimeOut, vSortTimeIn: begin
        Add('По возрастанию');
        Add('По убываанию');
        cbSort2.ItemIndex:=0;
      end;
      vSortCar: begin
        Add('По возрастанию номера');
        Add('По убываанию номера');
        Add('По возрастанию модели');
        Add('По убываанию модели');
        cbSort2.ItemIndex:=0;
      end;
      vSortDriver,vSortDisp: begin
        Add('По возрастанию фамилии');
        Add('По убываанию фамилии');
        Add('По возрастанию имени');
        Add('По убываанию имени');
        cbSort2.ItemIndex:=0;
      end;
    end;
  end;
end;

function TfrmView.DoView: boolean;
begin
  result:=false;
  cbSort1.ItemIndex:=CurViewStyle.iSort1;
  cbSort2.ItemIndex:=CurViewStyle.iSort2;
  if ShowModal <> mrOk then exit;
  CurViewStyle.iSort1:=cbSort1.ItemIndex;
  CurViewStyle.iSort2:=cbSort2.ItemIndex;
  result:=true;
end;

procedure TfrmView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult:=mrCancel;
  if Key = VK_RETURN then ModalResult:=mrOk;
end;

end.
