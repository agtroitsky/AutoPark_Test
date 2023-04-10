unit uView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AutoPark_Data,
  Vcl.Samples.Spin, Vcl.ComCtrls;

type
  TfrmView = class(TForm)
    GroupBox1: TGroupBox;
    cbSort1: TComboBox;
    cbSort2: TComboBox;
    GroupBox2: TGroupBox;
    btnOk: TButton;
    btnCancel: TButton;
    cbSelect1: TComboBox;
    cbSelect2: TComboBox;
    dpFrom: TDateTimePicker;
    dpTo: TDateTimePicker;
    lbFrom: TLabel;
    lbTo: TLabel;
    seFrom: TSpinEdit;
    seTo: TSpinEdit;
    edPart: TEdit;
    procedure cbSort1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbSelect1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function DoView: boolean;
    procedure DoResetView;
  end;

var
  frmView: TfrmView;

implementation

{$R *.dfm}

procedure TfrmView.DoResetView;
begin
  with CurViewStyle do begin
    iSort1:=0;
    iSort2:=1;
    iSelect1:=0;
  end;
  cbSort1.ItemIndex:=0;
  cbSort1Change(self);
  cbSort2.ItemIndex:=1;
  cbSelect1.ItemIndex:=0;
  cbSelect1Change(self);
end;

procedure TfrmView.cbSelect1Change(Sender: TObject);
var
  i, k, n1, n2: integer;
  d1, d2: TDateTime;
  s: string;
procedure SetToValue;
begin
  lbFrom.Visible:=false;
  lbTo.Visible:=false;
  seFrom.Visible:=false;
  seTo.Visible:=false;
  dpFrom.Visible:=false;
  dpTo.Visible:=false;
  edPart.Visible:=false;
  cbSelect2.Visible:=true;
  cbSelect2.Items.Clear;
  n1:=maxint;
  n2:=0;
end;
procedure SetToNumber;
begin
  cbSelect2.Visible:=false;
  lbFrom.Visible:=true;
  lbFrom.Caption:='От';
  lbTo.Visible:=true;
  seFrom.Visible:=true;
  seTo.Visible:=true;
  dpFrom.Visible:=false;
  dpTo.Visible:=false;
  edPart.Visible:=false;
end;
begin
  case cbSelect1.ItemIndex of
    0: begin
      cbSelect2.Visible:=false;
      lbFrom.Visible:=false;
      lbTo.Visible:=false;
      seFrom.Visible:=false;
      seTo.Visible:=false;
      dpFrom.Visible:=false;
      dpTo.Visible:=false;
      edPart.Visible:=false;
    end;
    vSelectNumber: begin
      SetToNumber;
      seFrom.Value:=1;
      seTo.Value:=Length(PathLists);
    end;
    vSelectCarYear: begin
      SetToNumber;
      for i:=0 to High(Cars) do with Cars[i] do begin
        if iYear < n1 then n1:=iYear;
        if iYear > n2 then n2:=iYear;
      end;
      seFrom.Value:=n1;
      seTo.Value:=n2;
    end;
    vSelectPath: begin
      SetToNumber;
      for i:=0 to High(PathLists) do with PathLists[i] do begin
        k:=Round(Int(dPath));
        if k < n1 then n1:=k;
        Inc(k);
        if k > n2 then n2:=k;
      end;
      seFrom.Value:=n1;
      seTo.Value:=n2;
    end;
    vSelectFuel: begin
      SetToNumber;
      for i:=0 to High(PathLists) do with PathLists[i] do begin
        k:=Round(Int(dFuel));
        if k < n1 then n1:=k;
        Inc(k);
        if k > n2 then n2:=k;
      end;
      seFrom.Value:=n1;
      seTo.Value:=n2;
    end;
    vSelectTimeOut, vSelectTimeIn: begin
      d1:=100000000;
      d2:=0;
      for i:=0 to High(PathLists) do with PathLists[i] do
        if cbSelect1.ItemIndex = vSelectTimeOut then begin
          if tTimeOut < d1 then d1:=tTimeOut;
          if tTimeOut > d2 then d2:=tTimeOut;
        end
        else begin
          if tTimeIn < d1 then d1:=tTimeIn;
          if tTimeIn > d2 then d2:=tTimeIn;
        end;
      cbSelect2.Visible:=false;
      lbFrom.Visible:=true;
      lbFrom.Caption:='От';
      lbTo.Visible:=true;
      seFrom.Visible:=false;
      seTo.Visible:=false;
      dpFrom.Date:=Int(d1);
      dpFrom.Visible:=true;
      dpTo.Visible:=true;
      dpTo.Date:=Int(d2);
      edPart.Visible:=false;
    end;
    vSelectCarNumValue, vSelectCarModValue: begin
      SetToValue;
      with cbSelect2 do begin
        for i:=0 to High(Cars) do begin
          if cbSelect1.ItemIndex = vSelectCarNumValue then s:=Cars[i].sNumber
          else s:=GetCarModelName(Cars[i].iID);
          if Items.IndexOf(s) < 0 then Items.Add(s);
        end;
        ItemIndex:=0;
      end;
    end;
    vSelectCarNumPart, vSelectCarModPart, vSelectDriverPart, vSelectDispPart: begin
      cbSelect2.Visible:=false;
      lbFrom.Visible:=true;
      lbFrom.Caption:='Фрагмент';
      lbTo.Visible:=false;
      seFrom.Visible:=false;
      seTo.Visible:=false;
      dpFrom.Visible:=false;
      dpTo.Visible:=false;
      edPart.Visible:=true;
      edPart.Text:='';
    end;
    vSelectDriverValue: begin
      SetToValue;
      with cbSelect2 do begin
        for i:=0 to High(Drivers) do begin
          s:=GetDriverName(Drivers[i].iID);
          if Items.IndexOf(s) < 0 then Items.Add(s);
        end;
        ItemIndex:=0;
      end;
    end;
    vSelectDispValue: begin
      SetToValue;
      with cbSelect2 do begin
        for i:=0 to High(Dispatchers) do begin
          s:=GetDispatcherName(Dispatchers[i].iID);
          if Items.IndexOf(s) < 0 then Items.Add(s);
        end;
        ItemIndex:=0;
      end;
    end;
  end;
end;

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
        Add('По убыванию имени');
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
  with CurViewStyle do begin
    iSort1:=cbSort1.ItemIndex;
    iSort2:=cbSort2.ItemIndex;
    iSelect1:=cbSelect1.ItemIndex;
    sSelect2:=cbSelect2.Text;
    iFrom:=seFrom.Value;
    iTo:=seTo.Value;
    dFrom:=dpFrom.Date;
    dTo:=dpTo.Date;
    sPart:=edPart.Text;
  end;
  result:=true;
end;

procedure TfrmView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then ModalResult:=mrCancel;
  if Key = VK_RETURN then ModalResult:=mrOk;
end;

end.
