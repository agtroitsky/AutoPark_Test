unit AutoPark_Data;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TPathListRec = record
    tTimeOut,tTimeIn: TDateTime;
    iDriverID, iCarID, iDispID: integer;
    dFuel, dPath: double;
    bDeleted: boolean;
  end;

  TDriverRec = record
    tBirthDate: TDate;
    sName, sSurName, sPatronymic: string;
    bDeleted: boolean;
  end;

  TDispatcherRec = record
    sName, sSurName, sPatronymic: string;
    bDeleted: boolean;
  end;

  TCarModel = record
    sFirm, sModel: string;
    bDeleted: boolean;
  end;

  TCarRec = record
    sNumber: string;
    iModelID, iYear: integer;
    tLastTO: tDate;
    dPath: double;
    bDeleted: boolean;
  end;

  TdmAutoPark = class(TDataModule)
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetData: boolean;
    function AddPathList(aData: TPathListRec): boolean;
  end;

function GetDriverName(aID: integer; aShort: boolean = true): string;
function GetDispName(aID: integer; aShort: boolean = true): string;
function GetCarName(aID: integer; aShort: boolean = true): string;

var
  dmAutoPark: TdmAutoPark;
  PathLists: array of TPathListRec;
  Drivers: array of TDriverRec;
  Dispatchers: array of TDispatcherRec;
  CarModels: array of TCarModel;
  Cars: array of TCarRec;
  ListOrder: array of integer;
  CurList: TPathListRec;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.DateUtils, Dialogs, System.UITypes;

function GetDriverName(aID: integer; aShort: boolean = true): string;
begin
  result:='???';
  if (aID < 0) or (aID > High(Drivers)) then exit;
  if aShort then result:=Drivers[aID].sSurName+' '+Copy(Drivers[aID].sName,1,1)
          +'.'+Copy(Drivers[aID].sPatronymic,1,1)+'.'
  else  result:=Drivers[aID].sSurName+' '+Drivers[aID].sName+' '+Drivers[aID].sPatronymic;

end;

function GetDispName(aID: integer; aShort: boolean = true): string;
begin
  result:='???';
  if (aID < 0) or (aID > High(Dispatchers)) then exit;
  if aShort then result:=Dispatchers[aID].sSurName+' '+Copy(Dispatchers[aID].sName,1,1)
          +'.'+Copy(Dispatchers[aID].sPatronymic,1,1)+'.'
  else result:=Dispatchers[aID].sSurName+' '+Dispatchers[aID].sName
          +' '+Dispatchers[aID].sPatronymic;
end;

function GetCarName(aID: integer; aShort: boolean = true): string;
var
  k: integer;
begin
  result:='???';
  if (aID < 0) or (aID > High(Dispatchers)) then exit;
  k:=Cars[aID].iModelID;
  result:=Cars[aID].sNumber;
  if not aShort then result:=CarModels[k].sFirm+' '+CarModels[k].sModel+' '+result;
end;

function TdmAutoPark.GetData: boolean;
var
  i: integer;
begin
  SetLength(PathLists,10);
  SetLength(Drivers,2);
  SetLength(Dispatchers,2);
  SetLength(CarModels,2);
  SetLength(Cars,2);
  SetLength(ListOrder,Length(PathLists));
  for i:=0 to High(ListOrder) do ListOrder[i]:=i;

  with Drivers[0] do begin
    sSurName:='Кормухин';
    sName:='Сергей';
    sPatronymic:='Васильевич';
    tBirthDate:=EncodeDate(2001,7,16);
    bDeleted:=false;
  end;
  with Drivers[1] do begin
    sSurName:='Васильков';
    sName:='Иван';
    sPatronymic:='Петрович';
    tBirthDate:=EncodeDate(1996,3,6);
    bDeleted:=false;
  end;

  with Dispatchers[0] do begin
    sSurName:='Василевская';
    sName:='Варвара';
    sPatronymic:='Степановна';
    bDeleted:=false;
  end;
  with Dispatchers[1] do begin
    sSurName:='Петрушевский';
    sName:='Максим';
    sPatronymic:='Сергеевич';
    bDeleted:=false;
  end;

  with CarModels[0] do begin
    sFirm:='Toyota';
    sModel:='Corolla';
    bDeleted:=false;
  end;
  with CarModels[1] do begin
    sFirm:='Toyota';
    sModel:='Camry';
    bDeleted:=false;
  end;

  with Cars[0] do begin
    sNumber:='A123TC196';
    iModelID:=0;
    iYear:=2021;
    tLastTO:=EncodeDate(2023,1,10);
    dPath:=22345.8;
    bDeleted:=false;
  end;
  with Cars[1] do begin
    sNumber:='K548PM96';
    iModelID:=1;
    iYear:=2020;
    tLastTO:=EncodeDate(2023,1,17);
    dPath:=43565.6;
    bDeleted:=false;
  end;

  with PathLists[0] do begin
    tTimeIn:=EncodeDateTime(2023,2,10,6,11,0,0);
    tTimeOut:=EncodeDateTime(2023,2,10,13,45,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=18.3;
    dPath:=200.6;
    bDeleted:=true;
  end;
  with PathLists[1] do begin
    tTimeIn:=EncodeDateTime(2023,2,10,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,10,19,28,0,0);
    iDriverID:=1;
    iCarID:=1;
    iDispID:=1;
    dFuel:=36.3;
    dPath:=400.9;
    bDeleted:=false;
  end;
  with PathLists[2] do begin
    tTimeIn:=EncodeDateTime(2023,2,15,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,15,19,28,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=56.3;
    dPath:=650.9;
    bDeleted:=false;
  end;
  with PathLists[3] do begin
    tTimeIn:=EncodeDateTime(2023,2,16,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,16,19,28,0,0);
    iDriverID:=1;
    iCarID:=1;
    iDispID:=1;
    dFuel:=21.3;
    dPath:=280.9;
    bDeleted:=false;
  end;
  with PathLists[4] do begin
    tTimeIn:=EncodeDateTime(2023,2,17,9,15,0,0);
    tTimeOut:=EncodeDateTime(2023,2,17,19,28,0,0);
    iDriverID:=0;
    iCarID:=0;
    iDispID:=0;
    dFuel:=38.3;
    dPath:=350.9;
    bDeleted:=false;
  end;
  PathLists[5]:=PathLists[0];
  PathLists[6]:=PathLists[1];
  PathLists[7]:=PathLists[2];
  PathLists[8]:=PathLists[3];
  PathLists[9]:=PathLists[4];
  result:=true;
end;

function TdmAutoPark.AddPathList(aData: TPathListRec): boolean;
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
    if dPath < 0 then begin
      MessageDlg('Указан отрицательный пробег',mtError,[mbOk],0);
      exit;
    end;
  end;
  with ADOQuery do begin
    SQL.Clear;
//    s:='INSERT pathlists(
    SQL.Add(s);
    i:=ExecSQL;
  end;

end;

end.
