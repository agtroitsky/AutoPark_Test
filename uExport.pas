unit uExport;

interface

type
  TExportFieldsRec = record
    sInFile, sOutFile: string;
    sfPathListNum, sfDriver, sfDispatcher, sfTimeIn, sfTimeOut, sfFuel,
    sfPath, sfCarModel, sfCarNumber: string[20];
  end;

var
  ExcelFields, WordFields: TExportFieldsRec;

  function ExportToExcel(aID: integer): boolean;

implementation

uses System.Variants, ComObj, Vcl.Dialogs, AutoPark_Data, System.SysUtils;

function ExportToExcel(aID: integer): boolean;
var
  i,k: integer;
  ExcelApp,WorkSheet: OleVariant;
  Workbook, Range: Variant;
  PathList: TPathListRec;

procedure DoQuit(const err: string = '');
begin
  WorkSheet:=unAssigned;
  ExcelApp := unAssigned;
  if err <> '' then MessageDlg(err,mtError,[mbOk],0);
end;

begin
  result:=false;
  k:=-1;
  for i:=0 to High(PathLists) do if aID = PathLists[i].iID then begin
    k:=i;
    break;
  end;
  if k < 0 then begin
    MessageDlg('При экспорте путевой лист не найден'#13'Обратитесь к разработчику',mtError,[mbOk],0);
    exit;
  end;
try
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Visible := false;
  ExcelApp.Application.EnableEvents := false;
  ExcelApp.DisplayAlerts := False;
except
  DoQuit('Ошибка запуска "Excel"');
  exit;
end;
try
  WorkBook:=ExcelApp.Workbooks.Open(ExcelFields.sInFile,0,true);
except
  on E: EOleException do begin
    DoQuit(E.Message);
    exit;
  end;
end;
  WorkSheet:=WorkBook.WorkSheets[1];
  with PathLists[k] do with ExcelFields do begin
    if sfPathListNum <> '' then WorkSheet.Range[sfPathListNum]:=IntToStr(iID);
    if sfDriver <> '' then WorkSheet.Range[sfDriver]:=GetDriverName(iDriverID);
    if sfDispatcher <> '' then WorkSheet.Range[sfDispatcher]:=GetDispatcherName(iDispID);
    if sfTimeIn <> '' then WorkSheet.Range[sfTimeIn]:=FormatDateTime('yyyy-mm-dd hh:nn',tTimeIn);
    if sfTimeOut <> '' then WorkSheet.Range[sfTimeOut]:=FormatDateTime('yyyy-mm-dd hh:nn',tTimeOut);
    if (sfFuel <> '') and (dFuel > 0) then WorkSheet.Range[sfFuel]:=format('%.1f',[dFuel]);
    if (sfPath <> '') and (dPath > 0)  then WorkSheet.Range[sfPath]:=format('%.1f',[dPath]);
    if sfCarModel <> '' then WorkSheet.Range[sfCarModel]:=GetCarModelName(iCarID);
    if sfCarNumber <> '' then WorkSheet.Range[sfCarNumber]:=GetCarNumber(iCarID);
  end;


end;

end.
