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

  TViewRec = record
    iID: integer;
    bDeleted: boolean;
    sCar, sDriver, sDispatcher: string;
    dFuel, dPath: double;
    tTimeIn, tTimeOut: TDateTime;
  end;

  TdmAutoPark = class(TDataModule)
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetAllData: boolean;
    function GetCarModels: boolean;
    function GetCars: boolean;
    function GetDrivers: boolean;
    function GetLists: boolean;
    function GetViewLists: boolean;
    function GetDispatchers: boolean;
    function DoPathListData(aData: TDataRec): boolean;
    function DoCarModelData(aData: TDataRec): boolean;
    function DoCarData(aData: TDataRec): boolean;
    function DoDriverData(aData: TDataRec): boolean;
    function DoDispatcherData(aData: TDataRec): boolean;
  end;

function GetDriverName(aID: integer; aShort: boolean = true): string;
function GetDispatcherName(aID: integer; aShort: boolean = true): string;
function GetCarName(aID: integer; aShort: boolean = true): string;
function GetCarModelName(aID: integer): string;

var
  dmAutoPark: TdmAutoPark;
  PathLists, Drivers, Dispatchers, CarModels, Cars: array of TDataRec;
  ViewLists: array of TViewRec;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.DateUtils, Dialogs, System.UITypes, uCommon;

function GetDriverName(aID: integer; aShort: boolean = true): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Drivers) do if aID = Drivers[i].iID then begin
    result:=Drivers[i].sdrSurName+' ';
    if aShort then result:=result+Copy(Drivers[i].sdrName,1,1)
          +'.'+Copy(Drivers[i].sdrPatronymic,1,1)+'.'
    else  result:=result+Drivers[i].sdrName+' '+Drivers[i].sdrPatronymic;
    break;
  end;
end;

function GetDispatcherName(aID: integer; aShort: boolean = true): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Dispatchers) do if aID = Dispatchers[i].iID then begin
    result:=Dispatchers[i].sdsSurName+' ';
    if aShort then result:=result+Copy(Dispatchers[i].sdsName,1,1)
          +'.'+Copy(Dispatchers[i].sdsPatronymic,1,1)+'.'
    else result:=result+Dispatchers[i].sdsName+' '+Dispatchers[i].sdsPatronymic;
    break;
  end;
end;

function GetCarName(aID: integer; aShort: boolean = true): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Cars) do if aID = Cars[i].iID then begin
    result:=Cars[i].sNumber;
    if not aShort then result:=GetCarModelName(Cars[i].iCarModelID)+' '+result;
    break;
  end;
end;

function GetCarModelName(aID: integer): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(CarModels) do if aID = CarModels[i].iID then begin
    result:=CarModels[i].sFirm+' '+CarModels[i].sModel;
    break;
  end;
end;

function TdmAutoPark.GetCarModels: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT * FROM carmodels';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(CarModels,RecordCount);
    First;
    for i:=0 to High(CarModels) do with CarModels[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then begin
        MessageDlg('������� ������� ����������� ����������',mtError,[mbOk],0);
        exit;
      end;
      sFirm:=FieldByName('firm').AsString;
      sModel:=FieldByName('model').AsString;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
  result:=true;
end;

function TdmAutoPark.GetCars: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT * FROM cars';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(Cars,RecordCount);
    First;
    for i:=0 to High(Cars) do with Cars[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then begin
        MessageDlg('������� ����������� ����������',mtError,[mbOk],0);
        exit;
      end;
      sNumber:=FieldByName('number').AsString;
      iCarModelID:=FieldByName('model_id').AsInteger;
      iYear:=FieldByName('year').AsInteger;
      tLastTO:=FieldByName('last_to').AsDateTime;
      dCPath:=FieldByName('path').AsFloat;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
  result:=true;
end;

function TdmAutoPark.GetDrivers: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT * FROM drivers';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(Drivers,RecordCount);
    First;
    for i:=0 to High(Drivers) do with Drivers[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then begin
        MessageDlg('������� ��������� ����������',mtError,[mbOk],0);
        exit;
      end;
      sdrName:=FieldByName('name').AsString;
      sdrPatronymic:=FieldByName('patronymic').AsString;
      sdrSurName:=FieldByName('surname').AsString;
      tBirthDate:=FieldByName('birthdate').AsDateTime;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
  result:=true;
end;

function TdmAutoPark.GetLists: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT * FROM pathlists';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(PathLists,RecordCount);
    First;
    for i:=0 to High(PathLists) do with PathLists[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then begin
        MessageDlg('������� ������� ������ ����������',mtError,[mbOk],0);
        exit;
      end;
      tTimeOut:=FieldByName('timeout').AsDateTime;
      tTimeIn:=FieldByName('timein').AsDateTime;
      iDriverID:=FieldByName('driver_id').AsInteger;
      iCarID:=FieldByName('car_id').AsInteger;
      iDispID:=FieldByName('disp_id').AsInteger;
      dFuel:=FieldByName('fuel').AsFloat;
      dlPath:=FieldByName('path').AsFloat;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
  result:=true;
end;

function TdmAutoPark.GetViewLists: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT pl.id as lnum, pl.timeout as ltimeout, pl.timein as ltimein,';
  s:=s+' pl.fuel as lfuel, pl.path as lpath, pl.deleted as ldeleted,';
  s:=s+' CONCAT(dr.surname,'' '',dr.name,'' '',dr.patronymic) as ldriver,';
  s:=s+' CONCAT(ds.surname,'' '',ds.name,'' '',ds.patronymic) as ldisp,';
  s:=s+' CONCAT(cr.number,'' '',cm.firm,'' '',cm.model) as lcar';
  s:=s+' FROM pathlists pl';
  s:=s+' JOIN drivers as dr on dr.id = pl.driver_id';
  s:=s+' JOIN disps as ds on ds.id = pl.disp_id';
  s:=s+' JOIN cars as cr on cr.id = pl.car_id';
  s:=s+' JOIN carmodels as cm on cm.id = cr.model_id';
  s:=s+' order by pl.id desc';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(ViewLists,RecordCount);
    First;
    for i:=0 to High(ViewLists) do begin
      ViewLists[i].iID:=FieldByName('lnum').AsInteger;
      ViewLists[i].tTimeOut:=FieldByName('ltimeout').AsDateTime;
      ViewLists[i].tTimeIn:=FieldByName('ltimein').AsDateTime;
      ViewLists[i].sDriver:=FieldByName('ldriver').AsString;
      ViewLists[i].sCar:=FieldByName('lcar').AsString;
      ViewLists[i].sDispatcher:=FieldByName('ldisp').AsString;
      ViewLists[i].dFuel:=FieldByName('lfuel').AsFloat;
      ViewLists[i].dPath:=FieldByName('lpath').AsFloat;
      ViewLists[i].bDeleted:=FieldByName('ldeleted').AsInteger > 0;
      Next;
    end;
    Active:=false;
except
    on E: Exception do begin
      Active:=false;
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  end;
  result:=true;
end;

function TdmAutoPark.GetDispatchers: boolean;
var
  i: integer;
  s: string;
begin
  result:=false;
  s:='SELECT * FROM disps';
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(Dispatchers,RecordCount);
    First;
    for i:=0 to High(Dispatchers) do with Dispatchers[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then begin
        MessageDlg('������� ����������� ����������',mtError,[mbOk],0);
        exit;
      end;
      sdsName:=FieldByName('name').AsString;
      sdsPatronymic:=FieldByName('patronymic').AsString;
      sdsSurName:=FieldByName('surname').AsString;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  result:=true;
  end;
end;

function TdmAutoPark.GetAllData: boolean;
var
  bol: boolean;
begin
  result:=GetCarModels;
  bol:=GetCars;
  result:=result or bol;
  bol:=GetDrivers;
  result:=result or bol;
  bol:=GetDispatchers;
  result:=result or bol;
  bol:=GetLists;
  result:=result or bol;
end;

function TdmAutoPark.DoCarModelData(aData: TDataRec): boolean;
var
  i,k: integer;
  s: string;
  bol: boolean;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO carmodels (firm, model, deleted) VALUES(';
    s:=s+''''+aData.sFirm+''',';
    s:=s+''''+aData.sModel+''',';
    s:=s+'0);';
  end
  else begin
    bol:=false;
    for i:=0 to High(CarModels) do if CarModels[i].iID = aData.iID then begin
      k:=i;
      bol:=true;
      break;
    end;
    if not bol then begin
      MessageDlg('������ �� �������'#13'���������� � ������������',mtError,[mbOk],0);
      exit;
    end;
    bol:=false;
    s:='UPDATE carmodels SET';
    if aData.sFirm <> CarModels[k].sFirm then begin
      s:=s+' firm='''+aData.sFirm+'''';
      bol:=true;
    end;
    if aData.sModel <> CarModels[k].sModel then begin
      if bol then s:=s+',';
      s:=s+' model='''+aData.sModel+'''';
      bol:=true;
    end;
    if aData.bDeleted <> CarModels[k].bDeleted then begin
      if bol then s:=s+',';
      if aData.bDeleted then s:=s+' deleted=1' else s:=s+' deleted=0';
      bol:=true;
    end;
    if not bol then begin
      result:=true;
      exit;
    end;
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

function TdmAutoPark.DoDriverData(aData: TDataRec): boolean;
var
  i,k: integer;
  s: string;
  bol: boolean;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO drivers (name, patronymic, surname, birthdate, deleted) VALUES(';
    s:=s+''''+aData.sdrName+''',';
    s:=s+''''+aData.sdrPatronymic+''',';
    s:=s+''''+aData.sdrSurName+''',';
    s:=s+''''+FormatDateTime('yyyy-mm-dd',aData.tBirthDate)+''',';
    s:=s+'0);';
  end
  else begin
    bol:=false;
    for i:=0 to High(Drivers) do if Drivers[i].iID = aData.iID then begin
      k:=i;
      bol:=true;
      break;
    end;
    if not bol then begin
      MessageDlg('������ �� �������'#13'���������� � ������������',mtError,[mbOk],0);
      exit;
    end;
    bol:=false;
    s:='UPDATE drivers SET';
    if aData.sdrName <> Drivers[k].sdrName then begin
      s:=s+' name='''+aData.sdrName+'''';
      bol:=true;
    end;
    if aData.sdrPatronymic <> Drivers[k].sdrPatronymic then begin
      if bol then s:=s+',';
      s:=s+' patronymic='''+aData.sdrPatronymic+'''';
      bol:=true;
    end;
    if aData.sdrSurName <> Drivers[k].sdrSurName then begin
      if bol then s:=s+',';
      s:=s+' surname='''+aData.sdrSurName+'''';
      bol:=true;
    end;
    if aData.tBirthDate <> Drivers[k].tBirthDate then begin
      if bol then s:=s+',';
      s:=s+' birthdate='''+FormatDateTime('yyyy-mm-dd',aData.tBirthDate)+'''';
      bol:=true;
    end;
    if aData.bDeleted <> Drivers[k].bDeleted then begin
      if bol then s:=s+',';
      if aData.bDeleted then s:=s+' deleted=1' else s:=s+' deleted=0';
      bol:=true;
    end;
    if not bol then begin
      result:=true;
      exit;
    end;
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

function TdmAutoPark.DoDispatcherData(aData: TDataRec): boolean;
var
  i,k: integer;
  s: string;
  bol: boolean;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO disps (name, patronymic, surname, deleted) VALUES(';
    s:=s+''''+aData.sdsName+''',';
    s:=s+''''+aData.sdsPatronymic+''',';
    s:=s+''''+aData.sdsSurName+''',';
    s:=s+'0);';
  end
  else begin
    bol:=false;
    for i:=0 to High(Dispatchers) do if Dispatchers[i].iID = aData.iID then begin
      k:=i;
      bol:=true;
      break;
    end;
    if not bol then begin
      MessageDlg('������ �� �������'#13'���������� � ������������',mtError,[mbOk],0);
      exit;
    end;
    bol:=false;
    s:='UPDATE disps SET';
    if aData.sdsName <> Dispatchers[k].sdsName then begin
      s:=s+' name='''+aData.sdrName+'''';
      bol:=true;
    end;
    if aData.sdsPatronymic <> Dispatchers[k].sdsPatronymic then begin
      if bol then s:=s+',';
      s:=s+' patronymic='''+aData.sdsPatronymic+'''';
      bol:=true;
    end;
    if aData.sdsSurName <> Dispatchers[k].sdsSurName then begin
      if bol then s:=s+',';
      s:=s+' surname='''+aData.sdsSurName+'''';
      bol:=true;
    end;
    if aData.bDeleted <> Dispatchers[k].bDeleted then begin
      if bol then s:=s+',';
      if aData.bDeleted then s:=s+' deleted=1' else s:=s+' deleted=0';
      bol:=true;
    end;
    if not bol then begin
      result:=true;
      exit;
    end;
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

function TdmAutoPark.DoCarData(aData: TDataRec): boolean;
var
  i,k: integer;
  s: string;
  bol: boolean;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO cars (number, model_id, year, last_to, path, deleted) VALUES(';
    s:=s+''''+aData.sNumber+''',';
    s:=s+IntToStr(aData.iCarModelID)+',';
    s:=s+IntToStr(aData.iYear)+',';
    s:=s+''''+FormatDateTime('yyyy-mm-dd',aData.tLastTO)+''',';
    s:=s+''''+DblToStr(aData.dcPath)+''',';
    s:=s+'0);';
  end
  else begin
    bol:=false;
    for i:=0 to High(Cars) do if Cars[i].iID = aData.iID then begin
      k:=i;
      bol:=true;
      break;
    end;
    if not bol then begin
      MessageDlg('������ �� �������'#13'���������� � ������������',mtError,[mbOk],0);
      exit;
    end;
    bol:=false;
    s:='UPDATE cars SET';
    if aData.sNumber <> Cars[k].sNumber then begin
      s:=s+' number='''+aData.sNumber+'''';
      bol:=true;
    end;
    if aData.iCarModelID <> Cars[k].iCarModelID then begin
      if bol then s:=s+',';
      s:=s+' model_id='+IntToStr(aData.iCarModelID);
      bol:=true;
    end;
    if aData.iYear <> Cars[k].iYear then begin
      if bol then s:=s+',';
      s:=s+' year='+IntToStr(aData.iYear);
      bol:=true;
    end;
    if aData.tLastTO <> Cars[k].tLastTO then begin
      if bol then s:=s+',';
      s:=s+' last_to='''+FormatDateTime('yyyy-mm-dd',aData.tLastTO)+'''';
      bol:=true;
    end;
    if aData.dcPath <> Cars[k].dcPath then begin
      if bol then s:=s+',';
      s:=s+' path='''+DblToStr(aData.dcPath)+'''';
      bol:=true;
    end;
    if aData.bDeleted <> Cars[k].bDeleted then begin
      if bol then s:=s+',';
      if aData.bDeleted then s:=s+' deleted=1' else s:=s+' deleted=0';
      bol:=true;
    end;
    if not bol then begin
      result:=true;
      exit;
    end;
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
  i,k: integer;
  s: string;
  bol: boolean;
begin
  result:=false;
  if aData.iID < 0 then begin
    s:='INSERT INTO pathlists (timeout, timein, driver_id, car_id, disp_id, fuel, path, deleted) VALUES(';
    s:=s+''''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aData.tTimeIn)+''',';
    s:=s+''''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aData.tTimeOut)+''',';
    s:=s+IntToStr(aData.iDriverID)+',';
    s:=s+IntToStr(aData.iCarID)+',';
    s:=s+IntToStr(aData.iDispID)+',';
    s:=s+''''+DblToStr(aData.dFuel)+''',';
    s:=s+''''+DblToStr(aData.dlPath)+''',';
    s:=s+'0);';
  end
  else begin
    bol:=false;
    for i:=0 to High(PathLists) do if PathLists[i].iID = aData.iID then begin
      k:=i;
      bol:=true;
      break;
    end;
    if not bol then begin
      MessageDlg('������ �� �������'#13'���������� � ������������',mtError,[mbOk],0);
      exit;
    end;
    bol:=false;
    s:='UPDATE pathlists SET';
    if aData.tTimeOut <> PathLists[k].tTimeOut then begin
      s:=s+' timeout='''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aData.tTimeOut)+'''';
      bol:=true;
    end;
    if aData.tTimeIn <> PathLists[k].tTimeIn then begin
      if bol then s:=s+',';
      s:=s+' timein='''+FormatDateTime('yyyy-mm-dd hh:nn:ss',aData.tTimeIn)+'''';
      bol:=true;
    end;
    if aData.iDriverID <> PathLists[k].iDriverID then begin
      if bol then s:=s+',';
      s:=s+' driver_id='+IntToStr(aData.iDriverID);
      bol:=true;
    end;
    if aData.iCarID <> PathLists[k].iCarID then begin
      if bol then s:=s+',';
      s:=s+' car_id='+IntToStr(aData.iCarID);
      bol:=true;
    end;
    if aData.iDispID <> PathLists[k].iDispID then begin
      if bol then s:=s+',';
      s:=s+' disp_id='+IntToStr(aData.iDispID);
      bol:=true;
    end;
    if aData.dFuel <> PathLists[k].dFuel then begin
      if bol then s:=s+',';
      s:=s+' fuel='''+DblToStr(aData.dFuel)+'''';
      bol:=true;
    end;
    if aData.dlPath <> PathLists[k].dlPath then begin
      if bol then s:=s+',';
      s:=s+' path='''+DblToStr(aData.dlPath)+'''';
      bol:=true;
    end;
    if aData.bDeleted <> Cars[k].bDeleted then begin
      if bol then s:=s+',';
      if aData.bDeleted then s:=s+' deleted=1' else s:=s+' deleted=0';
      bol:=true;
    end;
    if not bol then begin
      result:=true;
      exit;
    end;
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

end.
