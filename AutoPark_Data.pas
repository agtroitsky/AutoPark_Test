unit AutoPark_Data;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

const
  lNumMax = 10;
  lStrMax = 40;
type
  TDataRec = record
    iID: integer;
    bDeleted: boolean;
  case integer of
    0: (tTimeOut,tTimeIn: TDateTime;
      iDriverID, iCarID, iDispID: integer;
      dFuel, dlPath: double);
    1: (tBirthDate: TDate;
      sdrName, sdrSurName, sdrPatronymic: string[lStrMax]);
    2: (sdsName, sdsSurName, sdsPatronymic: string[lStrMax]);
    3: (sFirm, sModel: string[lStrMax]);
    4: (sNumber: string[lNumMax];
      iCarModelID, iYear: integer;
      tLastTO: TDate;
      dcPath: double);
  end;

{  TPathListRec = record
    iID: integer;
    tTimeOut,tTimeIn: TDateTime;
    iDriverID, iCarID, iDispID: integer;
    dFuel, dPath: double;
    bDeleted: boolean;
  end;

  TDriverRec = record
    iID: integer;
    tBirthDate: TDate;
    sName, sSurName, sPatronymic: string;
    bDeleted: boolean;
  end;

  TDispatcherRec = record
    iID: integer;
    sName, sSurName, sPatronymic: string;
    bDeleted: boolean;
  end;

  TCarModel = record
    iID: integer;
    sFirm, sModel: string;
    bDeleted: boolean;
  end;

  TCarRec = record
    iID: integer;
    sNumber: string;
    iCarModelID, iYear: integer;
    tLastTO: TDate;
    dPath: double;
    bDeleted: boolean;
  end;}

  TdmAutoPark = class(TDataModule)
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetData: boolean;
    function GetCarModels: boolean;
    function DoPathListData(aData: TDataRec): boolean;
    function DoCarModelData(aData: TDataRec): boolean;
  end;

function GetDriverName(aID: integer; aShort: boolean = true): string;
function GetDispName(aID: integer; aShort: boolean = true): string;
function GetCarName(aID: integer; aShort: boolean = true): string;
function GetCarModelName(aID: integer): string;

var
  dmAutoPark: TdmAutoPark;
  PathLists, Drivers, Dispatchers, CarModels, Cars: array of TDataRec;
  ListOrder: array of integer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.DateUtils, Dialogs, System.UITypes;

function GetDriverName(aID: integer; aShort: boolean = true): string;
begin
  result:='???';
  if (aID < 0) or (aID > High(Drivers)) then exit;
  if aShort then result:=Drivers[aID].sdrSurName+' '+Copy(Drivers[aID].sdrName,1,1)
          +'.'+Copy(Drivers[aID].sdrPatronymic,1,1)+'.'
  else  result:=Drivers[aID].sdrSurName+' '+Drivers[aID].sdrName+' '+Drivers[aID].sdrPatronymic;

end;

function GetDispName(aID: integer; aShort: boolean = true): string;
begin
  result:='???';
  if (aID < 0) or (aID > High(Dispatchers)) then exit;
  if aShort then result:=Dispatchers[aID].sdsSurName+' '+Copy(Dispatchers[aID].sdsName,1,1)
          +'.'+Copy(Dispatchers[aID].sdsPatronymic,1,1)+'.'
  else result:=Dispatchers[aID].sdsSurName+' '+Dispatchers[aID].sdsName
          +' '+Dispatchers[aID].sdsPatronymic;
end;

function GetCarName(aID: integer; aShort: boolean = true): string;
var
  k: integer;
begin
  result:='???';
  if (aID < 0) or (aID > High(Cars)) then exit;
  k:=Cars[aID].iCarModelID;
  result:=Cars[aID].sNumber;
  if not aShort then result:=CarModels[k].sFirm+' '+CarModels[k].sModel+' '+result;
end;

function GetCarModelName(aID: integer): string;
var
  k: integer;
begin
  result:='???';
  if (aID < 0) or (aID > High(CarModels)) then exit;
  result:=CarModels[aID].sFirm+' '+CarModels[aID].sModel;
end;

function TdmAutoPark.GetCarModels: boolean;
var
  i: integer;
  s: string;
begin
  s:='SELECT * FROM carmodels';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(CarModels,RecordCount);
    First;
    for i:=0 to High(CarModels) do begin
      CarModels[i].iID:=FieldByName('id').AsInteger;
      CarModels[i].sFirm:=FieldByName('firm').AsString;
      CarModels[i].sModel:=FieldByName('model').AsString;
      CarModels[i].bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
end;

function TdmAutoPark.GetData: boolean;
var
  i: integer;
begin
  GetCarModels;
  SetLength(PathLists,10);
  SetLength(Drivers,2);
  SetLength(Dispatchers,2);
  SetLength(Cars,2);
  SetLength(ListOrder,Length(PathLists));
  for i:=0 to High(ListOrder) do ListOrder[i]:=i;

  with Drivers[0] do begin
    sdrSurName:='Кормухин';
    sdrName:='Сергей';
    sdrPatronymic:='Васильевич';
    tBirthDate:=EncodeDate(2001,7,16);
    bDeleted:=false;
  end;
  with Drivers[1] do begin
    sdrSurName:='Васильков';
    sdrName:='Иван';
    sdrPatronymic:='Петрович';
    tBirthDate:=EncodeDate(1996,3,6);
    bDeleted:=false;
  end;

  with Dispatchers[0] do begin
    sdsSurName:='Василевская';
    sdsName:='Варвара';
    sdsPatronymic:='Степановна';
    bDeleted:=false;
  end;
  with Dispatchers[1] do begin
    sdsSurName:='Петрушевский';
    sdsName:='Максим';
    sdsPatronymic:='Сергеевич';
    bDeleted:=false;
  end;

  with Cars[0] do begin
    sNumber:='A123TC196';
    iCarModelID:=0;
    iYear:=2021;
    tLastTO:=EncodeDate(2023,1,10);
    dcPath:=22345.8;
    bDeleted:=false;
  end;
  with Cars[1] do begin
    sNumber:='K548PM96';
    iCarModelID:=1;
    iYear:=2020;
    tLastTO:=EncodeDate(2023,1,17);
    dcPath:=43565.6;
    bDeleted:=false;
  end;

  with PathLists[0] do begin
    tTimeIn:=EncodeDateTime(2023,2,10,6,11,0,0);
    tTimeOut:=EncodeDateTime(2023,2,10,13,45,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=18.3;
    dlPath:=200.6;
    bDeleted:=true;
  end;
  with PathLists[1] do begin
    tTimeIn:=EncodeDateTime(2023,2,10,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,10,19,28,0,0);
    iDriverID:=1;
    iCarID:=1;
    iDispID:=1;
    dFuel:=36.3;
    dlPath:=400.9;
    bDeleted:=false;
  end;
  with PathLists[2] do begin
    tTimeIn:=EncodeDateTime(2023,2,15,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,15,19,28,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=56.3;
    dlPath:=650.9;
    bDeleted:=false;
  end;
  with PathLists[3] do begin
    tTimeIn:=EncodeDateTime(2023,2,16,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,16,19,28,0,0);
    iDriverID:=1;
    iCarID:=1;
    iDispID:=1;
    dFuel:=21.3;
    dlPath:=280.9;
    bDeleted:=false;
  end;
  with PathLists[4] do begin
    tTimeIn:=EncodeDateTime(2023,2,17,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,17,19,28,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=38.3;
    dlPath:=350.9;
    bDeleted:=false;
  end;
  PathLists[5]:=PathLists[0];
  PathLists[6]:=PathLists[1];
  PathLists[7]:=PathLists[2];
  PathLists[8]:=PathLists[3];
  PathLists[9]:=PathLists[4];
  result:=true;
end;

function TdmAutoPark.DoCarModelData(aData: TDataRec): boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO carmodels (firm, model, deleted) VALUES(''';
    s:=s+aData.sFirm+''',''';
    s:=s+aData.sModel+''',';
    s:=s+'0);';
  end
  else begin
    s:='UPDATE carmodels SET firm=''';
    s:=s+aData.sFirm+''', model=''';
    s:=s+aData.sModel+''', deleted=';
    if aData.bDeleted then s:=s+'1' else s:=s+'0';
    s:=s+' WHERE id='+IntToStr(aData.iID)+';';
  end;
  with ADOQuery do begin
    SQL.Clear;
    SQL.Add(s);
try
    i:=ExecSQL;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  result:=true;
  end;
end;

function TdmAutoPark.DoPathListData(aData: TDataRec): boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  with aData do begin
    if (tTimeOut > 0) and (tTimeOut < Now) then begin
      MessageDlg('Нельзя оформить путевку в прошлое',mtError,[mbOk],0);
      exit;
    end;
    if (tTimeIn > 0) and ((tTimeIn-tTimeOut) < 1/24/6) then begin
      MessageDlg('Поездка не может быть короче 10 минут',mtError,[mbOk],0);
      exit;
    end;
    if (iDriverID < 0) or (iDriverId > High(Drivers)) then begin
      MessageDlg('Неправильно указан водитель',mtError,[mbOk],0);
      exit;
    end;
    if Drivers[iDriverID].bDeleted then begin
      MessageDlg('Указан удаленный водитель',mtError,[mbOk],0);
      exit;
    end;
    if (iCarID < 0) or (iCarID > High(Cars)) then begin
      MessageDlg('Неправильно указан автомобиль',mtError,[mbOk],0);
      exit;
    end;
    if Cars[iCarID].bDeleted then begin
      MessageDlg('Указан удаленный автомобиль',mtError,[mbOk],0);
      exit;
    end;
    if (iDispID < 0) or (iDispID > High(Dispatchers)) then begin
      MessageDlg('Неправильно указан диспетчер',mtError,[mbOk],0);
      exit;
    end;
    if Dispatchers[iDispID].bDeleted then begin
      MessageDlg('Указан удаленный диспетчер',mtError,[mbOk],0);
      exit;
    end;
    if dFuel < 0 then begin
      MessageDlg('Указан отрицательный расход топлива',mtError,[mbOk],0);
      exit;
    end;
    if dlPath < 0 then begin
      MessageDlg('Указан отрицательный пробег',mtError,[mbOk],0);
      exit;
    end;
  end;

end;

end.
