unit AutoPark_Data;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

const
  lNumMax = 10;
  lStrMax = 40;

  vSortNumber = 0;
  vSortCar    = 1;
  vSortDriver = 2;
  vSortDisp   = 3;
  vSortPath   = 4;
  vSortFuel   = 5;
  vSortTimeOut = 6;
  vSortTimeIn = 7;

  vSortUp1  = 0;
  vSortDwn1 = 1;
  vSortUp2  = 2;
  vSortDwn2 = 3;

  vSelectNumber      = 1;
  vSelectTimeOut     = 2;
  vSelectTimeIn      = 3;
  vSelectCarNumValue = 4;
  vSelectCarNumPart  = 5;
  vSelectCarModValue = 6;
  vSelectCarModPart  = 7;
  vSelectCarYear     = 8;
  vSelectDriverValue = 9;
  vSelectDriverPart  = 10;
  vSelectDispValue   = 11;
  vSelectDispPart    = 12;
  vSelectPath        = 13;
  vSelectFuel        = 14;

type
  TDataRec = record
    iID: integer;
    bDeleted: boolean;
  case integer of
    1: (tBirthDate: TDate;
      sdrName, sdrSurName, sdrPatronymic: string[lStrMax]);
    2: (sdsName, sdsSurName, sdsPatronymic: string[lStrMax]);
    3: (sFirm, sModel: string[lStrMax]);
    4: (sNumber: string[lNumMax];
      iCarModelID, iYear: integer;
      tLastTO: TDate;
      dPath: double);
  end;

  TPathListRec = record
    iID: integer;
    bDeleted: boolean;
    iDriverID, iCarID, iDispID: integer;
    sCar, sDriver, sDispatcher: string;
    dFuel, dPath: double;
    tTimeIn, tTimeOut: TDateTime;
  end;

  TViewStyleRec = record
    iSort1, iSort2: integer;
    iSelect1, iFrom, iTo: integer;
    sPart, sSelect2: ansistring;
    dFrom, dTo: TDateTime;
    bShowDeleted: boolean;
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
    function GetViewLists: boolean;
    function GetDispatchers: boolean;
    function DoPathListData(aData: TPathListRec): boolean;
    function DoCarModelData(aData: TDataRec): boolean;
    function DoCarData(aData: TDataRec): boolean;
    function DoDriverData(aData: TDataRec): boolean;
    function DoDispatcherData(aData: TDataRec): boolean;
    function AddPathToCar(aCarID: integer; aPath: double): boolean;
  end;

function GetDriverName(aID: integer): string;
function GetDispatcherName(aID: integer): string;
function GetCarNumber(aID: integer): string;
function GetCarName(aID: integer): string;
function GetCarModelName(aID: integer): string;

var
  dmAutoPark: TdmAutoPark;
  PathLists: array of TPathListRec;
  Drivers, Dispatchers, CarModels, Cars: array of TDataRec;
  CurViewStyle: TViewStyleRec;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.DateUtils, Dialogs, System.UITypes, uCommon;

function GetDriverName(aID: integer): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Drivers) do if aID = Drivers[i].iID then with Drivers[i] do begin
    result:=sdrSurName+' '+sdrName+' '+sdrPatronymic;
    break;
  end;
end;

function GetDispatcherName(aID: integer): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Dispatchers) do if aID = Dispatchers[i].iID then with Dispatchers[i] do begin
    result:=sdsSurName+' '+sdsName+' '+sdsPatronymic;
    break;
  end;
end;

function GetCarNumber(aID: integer): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Cars) do if aID = Cars[i].iID then begin
    result:=Cars[i].sNumber;
    break;
  end;
end;

function GetCarName(aID: integer): string;
var
  i: integer;
begin
  result:='???';
  for i:=0 to High(Cars) do if aID = Cars[i].iID then with Cars[i] do begin
    result:=sNumber+' '+GetCarModelName(Cars[i].iCarModelID);
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
  bDamaged: boolean;
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
    bDamaged:=false;
    for i:=0 to High(CarModels) do with CarModels[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then Bdamaged:=true;
      sFirm:=FieldByName('firm').AsString;
      sModel:=FieldByName('model').AsString;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
    if bDamaged then MessageDlg('Таблица моделей автомобилей повреждена',mtError,[mbOk],0);
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
  bDamaged: boolean;
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
    bDamaged:=false;
    for i:=0 to High(Cars) do with Cars[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then Bdamaged:=true;
      sNumber:=FieldByName('number').AsString;
      iCarModelID:=FieldByName('model_id').AsInteger;
      iYear:=FieldByName('year').AsInteger;
      tLastTO:=FieldByName('last_to').AsDateTime;
      dPath:=FieldByName('path').AsFloat;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
    if bDamaged then MessageDlg('Таблица автомобилей повреждена',mtError,[mbOk],0);
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
  bDamaged: boolean;
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
    bDamaged:=false;
    for i:=0 to High(Drivers) do with Drivers[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then Bdamaged:=true;
      sdrName:=FieldByName('name').AsString;
      sdrPatronymic:=FieldByName('patronymic').AsString;
      sdrSurName:=FieldByName('surname').AsString;
      tBirthDate:=FieldByName('birthdate').AsDateTime;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
    if bDamaged then MessageDlg('Таблица водителей повреждена',mtError,[mbOk],0);
except
    on E: Exception do begin
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
  bDamaged: boolean;
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
    bDamaged:=false;
    for i:=0 to High(Dispatchers) do with Dispatchers[i] do begin
      iID:=FieldByName('id').AsInteger;
      if iID <> (i+1) then Bdamaged:=true;
      sdsName:=FieldByName('name').AsString;
      sdsPatronymic:=FieldByName('patronymic').AsString;
      sdsSurName:=FieldByName('surname').AsString;
      bDeleted:=FieldByName('deleted').AsInteger > 0;
      Next;
    end;
    if bDamaged then MessageDlg('Таблица диспетчеров повреждена',mtError,[mbOk],0);
except
    on E: Exception do begin
      MessageDlg(E.Message,mtError,[mbOk],0);
      exit;
    end;
end;
  result:=true;
  end;
end;

function TdmAutoPark.GetViewLists: boolean;
var
  i: integer;
  s: ansistring;
begin
  result:=false;
  s:='SELECT pl.id as lnum, pl.timeout as ltimeout, pl.timein as ltimein,';
  s:=s+' pl.fuel as lfuel, pl.path as lpath, pl.deleted as ldeleted,';
  s:=s+' pl.driver_id, pl.disp_id, pl.car_id,';
  s:=s+' CONCAT(dr.surname,'' '',dr.name,'' '',dr.patronymic) as ldriver,';
  s:=s+' CONCAT(ds.surname,'' '',ds.name,'' '',ds.patronymic) as ldisp,';
  s:=s+' CONCAT(cr.number,'' '',cm.firm,'' '',cm.model) as lcar,';
  s:=s+' CONCAT(cm.firm,'' '',cm.model) as scar';
  s:=s+' FROM pathlists pl';
  s:=s+' JOIN drivers as dr on dr.id = pl.driver_id';
  s:=s+' JOIN disps as ds on ds.id = pl.disp_id';
  s:=s+' JOIN cars as cr on cr.id = pl.car_id';
  s:=s+' JOIN carmodels as cm on cm.id = cr.model_id';
  if not CurViewStyle.bShowDeleted then s:=s+' AND pl.deleted = 0';
  case CurViewStyle.iSelect1 of
    vSelectNumber: s:=s+' WHERE pl.id BETWEEN '+IntToStr(CurViewStyle.iFrom)+' AND '+IntToStr(CurViewStyle.iTo);
    vSelectTimeOut: s:=s+' WHERE pl.timeout BETWEEN '''
          +FormatDateTime('yyyy-mm-dd',Int(CurViewStyle.dFrom))
          +''' AND '''+FormatDateTime('yyyy-mm-dd',Int(CurViewStyle.dTo))+'''';
    vSelectTimeIn: s:=s+' WHERE pl.timein BETWEEN '''
          +FormatDateTime('yyyy-mm-dd',Int(CurViewStyle.dFrom))
          +''' AND '''+FormatDateTime('yyyy-mm-dd',Int(CurViewStyle.dTo))+'''';
    vSelectCarNumValue: s:=s+' WHERE cr.number = '''+CurViewStyle.sSelect2+'''';
    vSelectCarNumPart: s:=s+' WHERE cr.number LIKE %'''+CurViewStyle.sPart+'''%';
    vSelectCarModValue: s:=s+' WHERE lcar = '''+CurViewStyle.sSelect2+'''';
    vSelectCarModPart: s:=s+' WHERE lcar LIKE %'''+CurViewStyle.sPart+'''%';
    vSelectCarYear: s:=s+' WHERE cr.year BETWEEN '+IntToStr(CurViewStyle.iFrom)+' AND '+IntToStr(CurViewStyle.iTo);
    vSelectDriverValue: s:=s+' WHERE ldriver = '''+CurViewStyle.sSelect2+'''';
    vSelectDriverPart: s:=s+' WHERE ldriver LIKE %'''+CurViewStyle.sPart+'''%';
    vSelectDispValue: s:=s+' WHERE ldisp = '''+CurViewStyle.sSelect2+'''';
    vSelectDispPart: s:=s+' WHERE ldisp LIKE %'''+CurViewStyle.sPart+'''%';
    vSelectPath: s:=s+' WHERE pl.path BETWEEN '+IntToStr(CurViewStyle.iFrom)+' AND '+IntToStr(CurViewStyle.iTo);
    vSelectFuel: s:=s+' WHERE pl.fuel BETWEEN '+IntToStr(CurViewStyle.iFrom)+' AND '+IntToStr(CurViewStyle.iTo);
  end;
  case CurViewStyle.iSort1 of
    vSortNumber: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by pl.id';
      vSortDwn1: s:=s+' order by pl.id desc';
    end;
    vSortCar: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by cr.number';
      vSortDwn1: s:=s+' order by cr.number desc';
      vSortUp2: s:=s+' order by scar';
      vSortDwn2: s:=s+' order by scar desc';
    end;
    vSortDriver: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by dr.surname';
      vSortDwn1: s:=s+' order by dr.surname desc';
      vSortUp2: s:=s+' order by dr.name';
      vSortDwn2: s:=s+' order by dr.name desc';
    end;
    vSortDisp: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by ds.surname';
      vSortDwn1: s:=s+' order by ds.surname desc';
      vSortUp2: s:=s+' order by ds.name';
      vSortDwn2: s:=s+' order by ds.name desc';
    end;
    vSortPath: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by lpath';
      vSortDwn1: s:=s+' order by lpath desc';
    end;
    vSortFuel: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by lfuel';
      vSortDwn1: s:=s+' order by lfuel desc';
    end;
    vSortTimeOut: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by ltimeout';
      vSortDwn1: s:=s+' order by ltimeout desc';
    end;
    vSortTimeIn: case CurViewStyle.iSort2 of
      vSortUp1: s:=s+' order by ltimeout';
      vSortDwn1: s:=s+' order by ltimeout desc';
    end;
  end;
  with ADOQuery do begin
    Active:=false;
    SQL.Clear;
    SQL.Add(s);
try
    Active:=true;
    SetLength(PathLists,RecordCount);
    First;
    for i:=0 to High(PathLists) do with PathLists[i] do begin
      iID:=FieldByName('lnum').AsInteger;
      tTimeOut:=FieldByName('ltimeout').AsDateTime;
      tTimeIn:=FieldByName('ltimein').AsDateTime;
      iDriverID:=FieldByName('driver_id').AsInteger;
      sDriver:=FieldByName('ldriver').AsString;
      iCarID:=FieldByName('car_id').AsInteger;
      sCar:=FieldByName('lcar').AsString;
      iDispID:=FieldByName('disp_id').AsInteger;
      sDispatcher:=FieldByName('ldisp').AsString;
      dFuel:=FieldByName('lfuel').AsFloat;
      dPath:=FieldByName('lpath').AsFloat;
      bDeleted:=FieldByName('ldeleted').AsInteger > 0;
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
      MessageDlg('Запись не найдена'#13'Обратитесь к разработчику',mtError,[mbOk],0);
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
      MessageDlg('Запись не найдена'#13'Обратитесь к разработчику',mtError,[mbOk],0);
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
      MessageDlg('Запись не найдена'#13'Обратитесь к разработчику',mtError,[mbOk],0);
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

function TdmAutoPark.AddPathToCar(aCarID: integer; aPath: double): boolean;
var
  i,k: integer;
begin
  result:=false;
  k:=-1;
  for i:=0 to High(Cars) do if aCarID = Cars[i].iID then begin
    k:=i;
    break;
  end;
  if k < 0 then begin
    MessageDlg('При коррекции пробега автомобиль не найден'#13'Обратитесь к разработчику',mtError,[mbOk],0);
    exit;
  end;
  Cars[k].dPath:=Cars[k].dPath+aPath;
  if not DoCarData(Cars[k]) then exit;
  result:=true;
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
    s:=s+''''+DblToStr(aData.dPath)+''',';
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
      MessageDlg('При сохранении автомобиль не найден'#13'Обратитесь к разработчику',mtError,[mbOk],0);
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
    if aData.dPath <> Cars[k].dPath then begin
      if bol then s:=s+',';
      s:=s+' path='''+DblToStr(aData.dPath)+'''';
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

function TdmAutoPark.DoPathListData(aData: TPathListRec): boolean;
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
    s:=s+''''+DblToStr(aData.dPath)+''',';
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
      MessageDlg('При сохранении путевой лист не найден'#13'Обратитесь к разработчику',mtError,[mbOk],0);
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
    if aData.dPath <> PathLists[k].dPath then begin
      if bol then s:=s+',';
      s:=s+' path='''+DblToStr(aData.dPath)+'''';
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
