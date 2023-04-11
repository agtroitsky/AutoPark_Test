(*******************************************************************************
  * @project AutoPark
  * @file    uExport.pas
  * @date    11/04/2023
  * @brief   Модуль экспорта путевых листов в шаблоны Word и Excel
  ******************************************************************************
  *
  * COPYRIGHT(c) 2023 А.Г.Троицкий
  *
*******************************************************************************)

unit uExport;

interface

type
  TExportFieldsRec = record
    sFileIn, sFileOut: string;
    sfPathListNum, sfDriver, sfDispatcher, sfTimeIn, sfTimeOut, sfFuel,
    sfPath, sfCarModel, sfCarNumber: string[20];
  end;

var
  ExcelFields, WordFields: TExportFieldsRec;

function ExportToExcel(aID: integer): boolean;
function ExportToWord(aID: integer): boolean;

implementation

uses System.Variants, ComObj, Vcl.Dialogs, AutoPark_Data, System.SysUtils,
      uCommon, System.IOUtils;

function ExportToExcel(aID: integer): boolean;
var
  i,k: integer;
  s,s1: string;
  ExcelApp,WorkSheet: OleVariant;
  WorkBook, Range: Variant;
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
  ExcelApp:=CreateOleObject('Excel.Application');
  ExcelApp.Visible:=false;
except
  DoQuit('Ошибка запуска "Excel"');
  exit;
end;
s:=ExcelFields.sFileIn;
s:=ExpandFileName(s);
try
  WorkBook:=ExcelApp.Workbooks.Open(s,0,true);
except
  on E: EOleException do begin
    DoQuit('Ошибка открытия файла шаблона'#13+E.Message);
    exit;
  end;
end;
  WorkSheet:=WorkBook.WorkSheets[1];
  with PathLists[k] do with ExcelFields do begin
    if sfPathListNum <> '' then WorkSheet.Range[sfPathListNum]:=IntToStr(iID);
    if sfDriver <> '' then WorkSheet.Range[sfDriver]:=GetDriverName(iDriverID);
    if sfDispatcher <> '' then WorkSheet.Range[sfDispatcher]:=GetDispatcherName(iDispID);
    if sfCarModel <> '' then WorkSheet.Range[sfCarModel]:=GetCarModelName(iCarID);
    if sfCarNumber <> '' then WorkSheet.Range[sfCarNumber]:=GetCarNumber(iCarID);
    if (sfTimeIn <> '') and (tTimeIn > 0)  then WorkSheet.Range[sfTimeIn]:=FormatDateTime('yyyy-mm-dd hh:nn',tTimeIn);
    if (sfTimeOut <> '') and (tTimeOut > 0) then WorkSheet.Range[sfTimeOut]:=FormatDateTime('yyyy-mm-dd hh:nn',tTimeOut);
    if (sfFuel <> '') and (dFuel > 0) then WorkSheet.Range[sfFuel]:=format('%.1f',[dFuel]);
    if (sfPath <> '') and (dPath > 0)  then WorkSheet.Range[sfPath]:=format('%.1f',[dPath]);
// Вставка в имя выходного файла текущей даты вместо %D и номера путевого листа вместо %N
    s:=sFileOut;
    repeat
      i:=Pos('%',s);
      if i = 0 then break;
      if s[i+1] = 'N' then s1:=IntToStr(iID);
      if s[i+1] = 'D' then s1:=FormatDateTime('yyyy-mm-dd',Now);
      Delete(s,i,2);
      Insert(s1,s,i);
    until i = 0;
  end;
  s:=ExpandFileName(s);
  s1:=ExtractFilePath(s);
  if not TDirectory.Exists(s1) then MkDir(s1);
try
  ExcelApp.Application.EnableEvents:=false;
  ExcelApp.DisplayAlerts:=false;
  WorkBook.SaveAs(s);
except
  DoQuit('Ошибка сохранения файла "Excel"');
  exit;
end;
  WorkBook.Close;
  MessageDlg('Экспорт успешно завершен',mtInformation,[mbOk],0);
  ExcelApp.Application.EnableEvents:=true;
  ExcelApp.DisplayAlerts:=true;
  ExcelApp.Quit;
  DoQuit;
end;

function ExportToWord(aID: integer): boolean;
var
  i,k: integer;
  s,s1: string;
  WordApp: OleVariant;
  WordDoc, Range: Variant;
  PathList: TPathListRec;

procedure DoQuit(const err: string = '');
begin
  WordApp := unAssigned;
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
  WordApp:=CreateOleObject('Word.Application');
  WordApp.Visible:=false;
except
  DoQuit('Ошибка запуска "Word"');
  exit;
end;
s:=WordFields.sFileIn;
s:=ExpandFileName(s);
try
  WordApp.Documents.Open(s);
except
  on E: EOleException do begin
    DoQuit('Ошибка открытия файла шаблона'#13+E.Message);
    exit;
  end;
end;
  WordDoc:=WordApp.ActiveDocument;
  with PathLists[k] do with WordFields do begin
    if sfPathListNum <> '' then if WordDoc.Bookmarks.Exists(sfPathListNum) then
      WordDoc.Bookmarks.Item(sfPathListNum).Range.InsertAfter(IntToStr(iID));
    if sfDriver <> '' then if WordDoc.Bookmarks.Exists(sfDriver) then
      WordDoc.Bookmarks.Item(sfDriver).Range.InsertAfter(GetDriverName(iDriverID));
    if sfDispatcher <> '' then if WordDoc.Bookmarks.Exists(sfDispatcher) then
      WordDoc.Bookmarks.Item(sfDispatcher).Range.InsertAfter(GetDispatcherName(iDispID));
    if sfCarModel <> '' then if WordDoc.Bookmarks.Exists(sfCarModel) then
      WordDoc.Bookmarks.Item(sfCarModel).Range.InsertAfter(GetCarModelName(iCarID));
    if sfCarNumber <> '' then if WordDoc.Bookmarks.Exists(sfCarNumber) then
      WordDoc.Bookmarks.Item(sfCarNumber).Range.InsertAfter(GetCarNumber(iCarID));
    if (sfTimeIn <> '') and (tTimeIn > 0) then if WordDoc.Bookmarks.Exists(sfTimeIn) then
      WordDoc.Bookmarks.Item(sfTimeIn).Range.InsertAfter(FormatDateTime('yyyy-mm-dd hh:nn',tTimeIn));
    if (sfTimeOut <> '') and (tTimeOut > 0) then if WordDoc.Bookmarks.Exists(sfTimeOut) then
      WordDoc.Bookmarks.Item(sfTimeOut).Range.InsertAfter(FormatDateTime('yyyy-mm-dd hh:nn',tTimeOut));
    if (sfFuel <> '') and (dFuel > 0) then if WordDoc.Bookmarks.Exists(sfFuel) then
      WordDoc.Bookmarks.Item(sfFuel).Range.InsertAfter(Format('%.1f',[dFuel]));
    if (sfPath <> '') and (dPath > 0)  then if WordDoc.Bookmarks.Exists(sfPath) then
      WordDoc.Bookmarks.Item(sfPath).Range.InsertAfter(Format('%.1f',[dPath]));

// Вставка в имя выходного файла текущей даты вместо %D и номера путевого листа вместо %N
    s:=sFileOut;
    repeat
      i:=Pos('%',s);
      if i = 0 then break;
      if s[i+1] = 'N' then s1:=IntToStr(iID);
      if s[i+1] = 'D' then s1:=FormatDateTime('yyyy-mm-dd',Now);
      Delete(s,i,2);
      Insert(s1,s,i);
    until i = 0;
  end;
  s:=ExpandFileName(s);
  s1:=ExtractFilePath(s);
  if not TDirectory.Exists(s1) then MkDir(s1);
try
  WordApp.DisplayAlerts:=false;
  WordDoc.SaveAs(s);
except
  DoQuit('Ошибка сохранения файла "Word"');
  exit;
end;
  WordDoc.Close;
  MessageDlg('Экспорт успешно завершен',mtInformation,[mbOk],0);
  WordApp.DisplayAlerts:=true;
  WordApp.Quit;
  DoQuit;
end;

end.
