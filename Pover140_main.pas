unit Pover140_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Types;

type
  TPover140MainFrm = class(TForm)
    lbSite: TLabel;
    lbPerson: TLabel;
    btnStart: TButton;
    lbVersion: TLabel;
    Label7: TLabel;
    lbBatch: TLabel;
    btnBatch: TButton;
    lbNom: TLabel;
    btnProtocol: TButton;
    lbStatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnBatchClick(Sender: TObject);
    procedure btnProtocolClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoStart;
  public
    { Public declarations }
  end;

var
  Pover140MainFrm: TPover140MainFrm;

implementation

{$R *.dfm}

uses Common_Def, IniFiles, EP_JSON, Log_Form, Key_Dlg, superobject, EP_Common,
    ComObj, DeviceData, System.DateUtils, System.IOUtils, Get_Bar, OUP, PovParam;

const
  cModel = devID140;
  cQty51 = 51;
  cQty91 = 91;
  cQty151 = 151;
  cQty281 = 281;
  cQty501 = 501;
  cQty1201 = 1201;
  cQty3201 = 3201;
  cQty10001 = 10001;

var
  lflag: boolean = true;
  oCom: ISuperObject;
  Contflag: boolean;
  sDevNum,sProtcolPov: string;
  batchArr: BatchInfArr;
  iPovCnt,iSN: integer;
  dNom,dMin,dInt: double;
  ain, aout: TIntegerDynArray;

procedure doSavePasport(aBatch: boolean = false);
var
  jev,o,o1: ISuperObject;
  s,s0,s1: string;
  i: integer;
begin
// Собственно targets
//  lbStatus.Caption:='Сохранение в электронный паспорт';
  JSONTargets:=so;
  JSONProtBody.s['time']:=DateToISO8601(Now,false);
  o:=so;
  if aBatch then begin
    o.S['batch.bsn']:=IntToStr(oupBatchID)+'_V';
    o.i['batch.batch_qty']:=oupQty;
    o.i['batch.dev_model.id']:=JSONDevModelID;
    o.i['batch.dev_submodel.id']:=JSONDevSubModelID;
    o1:=so;
    for i:=0 to High(aout) do o1.i['select[]']:=aout[i];
    for i:=0 to High(batchArr) do o1.i['full[]']:=batchArr[i].biSN;
    o.S['batch.sns']:=o1.AsString;
//    o.S['batch.sns']:='sns test';
  end
  else begin
    o.S['dev.sn']:=JSONSetBar;
    o.S['dev.comment']:=oCom.AsString;
    o.i['dev.dev_model.id']:=JSONDevModelID;
    if JSONDevSubModelID <> 0 then o.i['dev.dev_submodel.id']:=JSONDevSubModelID;
    o.s['dev.dev_model.#name']:=JSONDevModel;
  end;
  JSONTargets['targets[]']:=o;
  o['target_event']:=so;
  o.s['target_event.#name']:=JSONEvent;
  jev:=o['target_event'];
  o1:=so;
  o1.i['protocol_template.id']:=JSONProtocolID;
  o1.s['protocol_template.#name']:=JSONProtocol;
  o1.s['protocol_template.body']:='';
  jev['protocols[]']:=o1;

  JSONProtBody.S['programmVersion']:=GetMyVer;
  JSONProtBody.S['computerName']:=CompName;
  JSONProtBody.S['programmName']:=ExeName;
  JSONProtBody.s['site.name']:=JSONSite;
  JSONProtBody.i['site.id']:=JSONSiteID;
  JSONProtBody.s['person.name']:=JSONPson;
  JSONProtBody.i['person.id']:=JSONPsonID;
  o1['body']:=JSONProtBody;

//Сохранение в электронный паспорт
  DateTimeToString(s,'yyyy-mm-dd_hhnnss',Now);
  s1:=ExePath+'Protocols\'+s+'.'+JSONSetBar;

  JSLog:=true;

  i:=SaveProtocol;
//  writeLog('Сохранение в электронный паспорт '+JSONUrl+' > '+JSONSend.asString);
  s:='Сохранение в электронный паспорт '+JSONUrl;
  JSONSend.SaveTo(s1,true, false);
  if i <> 0 then begin
    writeLog(s+' Ошибка'#13+OJ.JError);
    KeyDlg.ShowError(s+' Ошибка'#13+OJ.JError);
    s0:=ExePath+'ToSend';
    if not TDirectory.Exists(s0) then MkDir(s0);
    s1:=s0+'\'+s+'_'+JSONSetBar+'.json';
    JSONSend.SaveTo(s1,true, false);
  end
  else writeLog(s+' успешно');
end;

function CheckDevice: boolean;
var
  i,j: integer;
  s,s1: string;
begin
  result:=false;

try
  iSN:=StrToInt(Copy(sbar,Length(sbar)-7,8));
except
  iSN:=0;
end;
  s:=Copy(sbar,1,12);
  if (Length(sbar) <> 26) or (s <> '010465006729') or (iSN = 0) then begin
    KeyDlg.ShowError('Неверный формат штрихкода: '#13+sbar);
    exit;
  end;
  s:=Copy(sbar,3,14);
  if CheckPartBar(s) <> 0 then begin
    KeyDlg.ShowError('Исполнение не найдено');
    exit;
  end;

  s:=sBar;
  while Length(s) > 8 do Delete(s,1,1);
  sDevNum:=s;

  JSONSetBar:=sDevNum;
  if (JSONDevModelID <> PartsArr[JSONPartIdx].ModelID) or (JSONDevSubModelID <> PartsArr[JSONPartIdx].ID) then begin
    KeyDlg.ShowError('Требуется '+ModelsArr[cModel].Name+PartsArr[JSONDevSubModelID].Name);
    exit;
  end;

  oCOM:=nil;
  for i:=0 to high(batchArr) do if batchArr[i].biSN = iSn then begin
    oCom:=batchArr[i].biCOM;
    break;
  end;
  if oCOM = nil then begin
    KeyDlg.ShowError('Прибор в запуске не найден');
    exit;
  end;

  j:=oCom.I['tstatus'];
  if (j and ftConvert) = 0 then begin
    s:='Прибор '+sBar+' не прошел конвертацию';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;
  if (j and ftRegistr) = 0 then begin
    s:='Прибор '+sBar+' не прошел регистрацию';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;

  if (j and ftPoverka) <> 0 then begin
    s:='Прибор '+sBar+'  уже был поверен';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;

  if oCom.i['batch'] = 0 then begin
    s:='У прибора '+sBar+'  нет запуска';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;
  if oCom.i['batch'] <> oupBatchID then begin
    s:='Прибор '+sBar+'  из другого запуска';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;
  result:=true;
end;

function GetPrec(aSn: string): boolean;
var
  i,j: integer;
  s: string;
begin
  result:=false;
  s:='select p1.id as id1, p1.created_at as data,'
      +' protocol_body::JSON  -> ''caliber''  -> ''nom''  -> ''device'' -> ''prec'' as nom,'
      +' protocol_body::JSON  -> ''caliber''  -> ''min''  -> ''device'' -> ''prec'' as min,'
      +' protocol_body::JSON  -> ''caliber''  -> ''int''  -> ''device'' -> ''prec'' as int'
      +' from protocols as p1'
      +' join evts as e1 on p1.protocol_template_id = ''62'' and p1.evt_id = e1.id'
      +' join devs as d1 on d1.id = e1.dev_id and d1.sn = '''+aSn+''''+' and d1.dev_model_id = '+IntToStr(JSONDevModelID)
      +' order by p1.id desc';
  i:=DoSQL(s);
  if i <> 0 then begin
    writeLog('*** На запрос: '+s+' Получен ответ ошибка: '+IntToStr(i)+': '+OJ.JError);
    KeyDlg.ShowError('Ошибка SQL'+IntToStr(i)+': '+OJ.JError);
    exit;
  end;
  s:=OJ.JObj.AsString;

  j:=OJ.JObj['raw_queries[0].result'].AsArray.Length;
  if j = 0 then begin
    s:='Протокол '+aSN+' не найден';
    writeLog('*** '+s);
    KeyDlg.ShowError(s);
    exit;
  end;

  s:=OJ.JObj['raw_queries[0].result[0]'].AsString;
  dNom:=OJ.JObj.D['raw_queries[0].result[0].nom'];
  dMin:=OJ.JObj.D['raw_queries[0].result[0].min'];
  dInt:=OJ.JObj.D['raw_queries[0].result[0].int'];
  if (dNom = 0) or (dInt = 0) or (dMin = 0) then exit;
  result:=true;
end;

procedure TPover140MainFrm.btnBatchClick(Sender: TObject);
var
  i,n: integer;
begin
  btnStart.Enabled:=false;
  btnProtocol.Enabled:=false;
  lbBatch.Caption:='----';
  repeat
    i:=KeyDlg.GetInt('Введите НОМЕР запуска',n);
    if i <> mrYes then exit;
    i:=GetOUPBatch(n);
    if i < 0 then begin
      KeyDlg.ShowError(OUPErrorStr(i));
      exit;
    end;
    if i > 0 then break;
    KeyDlg.ShowError('Запуск '+IntToStr(n)+' не найден');
  until false;
  lbBatch.Caption:=IntToStr(oupBatchID);
  JSONDevModelID:=cModel;
  JSONDevSubModelID:=oupEPSubmodelID;
  CheckPartID(JSONDevSubModelID);
  if JSONDevModelID <> PartsArr[JSONPartIdx].ModelID then begin
    KeyDlg.ShowError('Запуск должен быть на '+ModelsArr[cModel].Name);
    exit;
  end;
  i:=GetBatchInfo(oupBatchID,batchArr);
  if i <> 0 then begin
    writeLog('*** Получен ответ ошибка: '+IntToStr(i)+': '+OJ.JError);
    KeyDlg.ShowError('Ошибка SQL'+IntToStr(i)+': '+OJ.JError);
    exit;
  end;
  case JSONDevSubModelID of
    757..760: sProtcolPov:='Протокол поверки шаблон КАРАТ-140-М-15.xlsx';
    807..810: sProtcolPov:='Протокол поверки шаблон КАРАТ-140-М-20.xlsx';
    811,812: sProtcolPov:='Протокол поверки шаблон КАРАТ-140-Э1-15.xlsx';
    813,814: sProtcolPov:='Протокол поверки шаблон КАРАТ-140-Э1-20.xlsx';
    else KeyDlg.ShowError('нет шаблона протокола поверки');
  end;
  lbNom.Caption:=ModelsArr[cModel].Name+PartsArr[JSONDevSubModelID].Name
    +'  '+IntToStr(Length(batchArr))+' / '+IntToStr(oupQty);
  if Length(batchArr) < oupQty then
    KeyDlg.ShowInf('В запуске '+IntToStr(Length(batchArr))+' приборов из '+IntToStr(oupQty));
  iPovCnt:=0;
  for i:=0 to High(batchArr) do begin
    if (batchArr[i].biCOM.I['tstatus'] and ftPoverka) > 0 then Inc(iPovCnt);
  end;
  lbNom.Caption:=ModelsArr[cModel].Name+'-'+PartsArr[JSONPartIdx].Name
    +'  '+IntToStr(iPovCnt)+' / '+IntToStr(oupQty);
  if iPovCnt = oupQty then begin
    KeyDlg.ShowInf('В запуске '+IntToStr(oupBatchID)+' все приборы поверены');
    btnProtocol.Enabled:=true;
    exit;
  end;
  btnStart.Enabled:=true;
end;

procedure TPover140MainFrm.btnStartClick(Sender: TObject);
var
  s: string;
  i: integer;
  o: ISuperObject;
begin
  btnStart.Enabled:=false;
try
  iSN:=0;
  repeat
	  Contflag:=false;
    btnStart.Enabled:=false;
    DoStart;
    btnStart.Enabled:=true;
  until not Contflag;
finally
  btnStart.Enabled:=true;
end;
end;

procedure TPover140MainFrm.btnProtocolClick(Sender: TObject);
var
  s,sBox,sDevice, sCap, sRow, sPov, sSrcDir, sProDir, sModel: string;
  i,ii,j,k,n, nSel, nErr, nLin, nXls, iSn: integer;
  App,WS: OleVariant;
  Workbook, Range, Range1, Cell1, Cell2, ArrayData  : Variant;
  o: ISuperObject;
  dNom,dInt,dMin: double;
  d,m,y,w: word;
  CSVFile: textfile;
  bEP: boolean;

procedure DoQuit(const err: string = '');
begin
  WS:=unAssigned;
  App := unAssigned;
  if err <> '' then MessageDlg(err,mtError,[mbOk],0);
end;

begin
  if PovParamFrm.ShowModal <> mrOk then exit;

  sSrcDir:=ExePath+'Шаблоны\';
  sProDir:=ExePath+'Протоколы\'+IntToStr(oupBatchID)+'\';
  ForceDirectories(sProDir);
  sModel:=ModelsArr[cModel].TypeName+' '+ModelsArr[cModel].Name+'-'+PartsArr[JSONPartIdx].Name;

  nXls:=0;
  case oupQty of
//    1: begin nSel:=1; nErr:=0; end;
    cQty51..cQty91-1: begin nSel:=13; nErr:=0; nLin:=8; nXls:=150; end;
    cQty91..cQty151-1: begin nSel:=20; nErr:=0; nLin:=8; nXls:=150;  end;
    cQty151..cQty281-1: begin nSel:=32; nErr:=0; nLin:=9; nXls:=280;  end;
    cQty281..cQty501-1: begin nSel:=50; nErr:=1; nLin:=12; nXls:=500;  end;
    cQty501..cQty1201-1: begin nSel:=80; nErr:=2; nLin:=20; nXls:=1200;  end;
    cQty1201..cQty3201-1: begin nSel:=125; nErr:=3; end;
    cQty3201..cQty10001-1: begin nSel:=200; nErr:=5; end;
    else begin
      KeyDlg.ShowError('Неверный размер запуска '+IntToStr(oupQty));
      exit;
    end;
  end;
  case oupQty of
//    1: begin nLin:=1; nXls:=150; end;
    51..90: begin nLin:=8; nXls:=150; end;
    91..150: begin nLin:=8; nXls:=150;  end;
    151..280: begin nLin:=9; nXls:=280;  end;
    281..500: begin nLin:=12; nXls:=500;  end;
    501..630: begin nLin:=14; nXls:=600;  end;
    631..1200: begin nLin:=20; nXls:=1200;  end;
    else begin
      KeyDlg.ShowError('Нет шаблона протокола отбора');
      exit;
    end;
  end;


// **********  Формирование выборки

  i:=GetBatchVInfo(oupBatchID,ain,aout);
  if (i = 0) and (Length(aout) > 0) then begin
    if Length(aout) <> nSel then begin
      KeyDlg.ShowError('Размер выборки '+IntToStr(Length(aout))+' не '+IntToStr(nSel));
      exit;
    end;
    if Length(ain) <> oupQty then begin
      KeyDlg.ShowError('Количество приборов '+IntToStr(Length(ain))+' не '+IntToStr(oupQty));
      exit;
    end;
    for i:=0 to high(ain) do begin
      for j:=0 to high(batchArr) do begin
        bEP:=(ain[i] = batchArr[j].biSN);
        if bEP then begin
          n:=j;
          break;
        end;
      end;
      if not bEP then begin
        KeyDlg.ShowError('Номера приборов в запуске не совпадают '+IntToStr(ain[i]));
        exit;
      end;
    end;
    if KeyDlg.ShowCont('Запуск уже оформлен'#13'повторить протоколы?') <> mrYes then exit;
  end
  else begin
    bEP:=false;
    aout:=nil;
    Randomize;
    for i:=0 to nSel-1 do begin
      repeat
        k:=Random(high(batchArr));
        iSn:=batchArr[k].biSN;
        n:=200;
        for j:=0 to high(aout) do begin
          if iSn = aout[j] then begin
            n:=-1;
            break
          end;
          if iSn < aout[j] then begin
            n:=j;
            break
          end;
        end;
      until n >= 0;
      Insert(iSn,aout,n);
    end;
  end;

// **********  Протокол отбора
  lbStatus.Caption:='Протокол отбора';
  Application.ProcessMessages;

try
  App := CreateOleObject('Excel.Application');
  App.Visible := false;
  App.Application.EnableEvents := false;
  App.DisplayAlerts := False;
except
  DoQuit('Ошибка запуска "Excel"');
  exit;
end;
try
  WorkBook:=App.Workbooks.Open(sSrcDir+'Протокол отбора шаблон '+IntToStr(nXls)+'.xlsx',0,true);
except
  on E: EOleException do begin
    s:=E.Message;
    writeLog('---> Ошибка: '+s);
    DoQuit(s);
    exit;
  end;
end;
  WS:=WorkBook.WorkSheets[1];

//  sBox:=WS.Range['A2'];
  s:=sModel+'     '+'Протокол отбора образцов из запуска (партии) № '+IntToStr(oupBatchID);
  WS.Range['A1']:=s;

  sBox:=' ';
  for i:=0 to high(batchArr) do begin
    s:=Format('%.8d', [batchArr[i].biSN]);
    sBox:=sBox+s;
    if i < high(batchArr) then begin
      sBox:=sBox+',';
      if ((i+1) mod nLin) = 0 then sBox:=sBox+#10+' ';
    end;
  end;
  WS.Range['B4']:=sBox;

  sBox:='';
  for i:=0 to nSel-1 do begin
    s:=Format('%.8d', [aout[i]]);
    sBox:=sBox+s;
    if i < nSel-1 then sBox:=sBox+', ';
  end;
  WS.Range['C4']:=sBox;

  s:='Поверитель: __________ /'+PovParamFrm.cbPov.Text+'/      Дата: '+FormatDateTime('dd.mm.yyyy',PovParamFrm.pDate.DateTime);
  WS.Range['A8']:=s;
  WS.Range['A4']:=#10+IntToStr(oupQty);
  WS.Range['D4']:=#10+IntToStr(nErr);
  WS.Range['E4']:=#10+IntToStr(nErr+1);
  WS.Range['F4']:=#10'0';

  WorkBook.ExportAsFixedFormat(0, sProDir+'Протокол отбора '+IntToStr(oupBatchID)+'.pdf', EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
  WorkBook.close;

// **********  Протокол гидравлических испытаний
  lbStatus.Caption:='Протокол испытаний';
  Application.ProcessMessages;

{try
  App := CreateOleObject('Excel.Application');
  App.Visible := false;
except
  DoQuit('Ошибка запуска "Excel"');
  exit;
end;}
try
  WorkBook:=App.Workbooks.Open(sSrcDir+'Акт гидравлических испытаний шаблон 80.xlsx',0,true);
except
  on E: EOleException do begin
    s:=E.Message;
    writeLog('---> Ошибка: '+s);
    DoQuit(s);
    exit;
  end;
end;
  WS:=WorkBook.WorkSheets[1];

//  WS.Range['E3']:=FormatDateTime('dd.mm.yyyy',PovParamFrm.pDate.DateTime);
  WS.Range['C4']:=IntToStr(oupBatchID);
  WS.Range['C5']:=ModelsArr[cModel].Name+'-'+PartsArr[JSONPartIdx].Name;

  s:=WS.Range['B8'];
  WS.Range['B8']:=Gydro.Str1;
  s:=WS.Range['B8'];
  WS.Range['B9']:=Gydro.Str2;
  WS.Range['B10']:=Gydro.Str3;

  for i:=0 to nSel-1 do begin
    s:=Format('%.8d', [aout[i]]);
    WS.Cells[16+(i div 4),1+(i mod 4)*2]:=s;
    WS.Cells[16+(i div 4),2+(i mod 4)*2]:='герметичен';
  end;

  WS.Range['E39']:=PovParamFrm.cbGPerson.Text;
  WS.Range['E41']:=PovParamFrm.cbGMaster.Text;

  WorkBook.ExportAsFixedFormat(0, sProDir+'Протокол испытаний '+IntToStr(oupBatchID)+'.pdf', EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
  WorkBook.close;

// **********  Протоколы поверки

  for i:=0 to High(aout) do begin
    dNom:=18;
    dInt:=18;
    dMin:=18;
    for j:=0 to high(batchArr) do if batchArr[j].biSN = aout[i] then begin
      oCom:=batchArr[j].biCOM;
      break;
    end;
    dNom:=oCom.D['prec.nom'];
    dInt:=oCom.D['prec.int'];
    dMin:=oCom.D['prec.min'];
    if (dNom = 0) or (Abs(dNom) > 2) then begin
      s:='У прибора '+IntToStr(aout[i])+' погрешность nom = '+Format('%.3f', [dNom]);
      writeLog('---> Ошибка: '+s);
      DoQuit(s);
      exit;
    end;
    if (dInt = 0) or (Abs(dInt) > 2) then begin
      s:='У прибора '+IntToStr(aout[i])+' погрешность int = '+Format('%.3f', [dInt]);
      writeLog('---> Ошибка: '+s);
      DoQuit(s);
      exit;
    end;
    if (dMin = 0) or (Abs(dMin) > 5) then begin
      s:='У прибора '+IntToStr(aout[i])+' погрешность Min = '+Format('%.3f', [dMin]);
      writeLog('---> Ошибка: '+s);
      DoQuit(s);
      exit;
    end;

    lbStatus.Caption:='Протокол поверки'#13+IntToStr(high(aout)-i)+'  '+IntToStr(aout[i]);
    Application.ProcessMessages;
  try
    WorkBook:=App.Workbooks.Open(sSrcDir+sProtcolPov,0,true);
    App.Application.EnableEvents := false;
    App.DisplayAlerts := False;
  except
    on E: EOleException do begin
      s:=E.Message;
      writeLog('---> Ошибка: '+s);
      DoQuit(s);
      exit;
    end;
  end;
    WS:=WorkBook.WorkSheets[1];
    WS.Range['D3']:=sModel;
    WS.Range['D7']:=' '+IntToStr(aout[i]);
    WS.Range['B10']:=PovParamFrm.lbPrus.Caption;
    WS.Range['B12']:=PovParamFrm.lbSec.Caption;
    WS.Range['B13']:=PovParamFrm.lbTerm.Caption;
    WS.Range['F16']:=PovParamFrm.edTa.Text;
    WS.Range['F17']:=PovParamFrm.edPa.Text;
    WS.Range['F18']:=PovParamFrm.edHum.Text;
    WS.Range['F19']:=PovParamFrm.edTw.Text;

    WS.Range['I29']:=dNom;
    WS.Range['I30']:=dInt;
    WS.Range['I31']:=dMin;

    WS.Range['C37']:=FormatDateTime('dd.mm.yyyy',PovParamFrm.pDate.DateTime);
    WS.Range['J37']:=PovParamFrm.cbPov.Text;
    if PovParamFrm.cbSta.ItemIndex > 0 then begin
      WS.Range['J38']:=PovParamFrm.cbSta.Text;
      WS.Range['G38']:='Стажер: ';
      WS.Range['G38']:='______________';
    end;

    s:=sProDir+'\Протокол поверки '+IntToStr(aout[i])+'.pdf';
    WorkBook.ExportAsFixedFormat(0,s, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam, EmptyParam);
    WorkBook.close;
  end;
  App.quit;
  DoQuit;

// **********  CSV для ФИФ
  lbStatus.Caption:='Журнал поверочниых работ';

  AssignFile(CSVFile, sProDir+'Журнал '+IntToStr(oupBatchID)+'.csv');
  FileMode := 0;  {Set file access to read-only. }
  {$I-}
  Rewrite(CSVFile);
  {$I+}
  i:=IOResult;
  if i <> 0 then begin
    KeyDlg.ShowError('Ошибка '+IntToStr(i)+' создания файла журнала');
    exit;
  end;

  for i:=0 to high(batchArr) do with batchArr[i] do begin
    s:='87786-22;Счетчики воды;КАРАТ-140;'+PartsArr[JSONPartIdx].Name+';'+IntToStr(biSN);
    s:=s+';ООО НПП "Уралтехнология";'+FormatDateTime('dd.mm.yyyy',PovParamFrm.pDate.DateTime);
    DecodeDate(PovParamFrm.pDate.DateTime-1,y,m,d);
    s:=s+';'+FormatDateTime('dd.mm.yyyy',EncodeDate(y+6,m,d));
    s:=s+';Первичная;Пригодно;;Да;;;'+PovParamFrm.cbPov.Text+';МП 208-049-2022;';
    s:=s+';'+spPRUS+';'+spName+';'+spReg+';'+spSN+';';
    s:=s+';'+PovParamFrm.edTa.Text+'°С'+';'+PovParamFrm.edPa.Text+' кПа';
    s:=s+';'+PovParamFrm.edHum.Text+'%'+';Температура воды '+PovParamFrm.edTw.Text+'°С';
    writeln(CSVFile,s);
  end;
  CloseFile(CSVFile);

  lbStatus.Caption:='';

  if bEP then exit;

  JSONProtBody:=so;
  JSONProtBody.S['batch.device_model']:=PartsArr[JSONDevSubModelID].ModelName;
  JSONProtBody.S['batch.device_submodel']:=PartsArr[JSONDevSubModelID].Name;
  JSONProtBody.i['batch.id']:=oupBatchID;
  JSONProtBody.i['batch.qty']:=oupQty;

  for i:=0 to High(aout) do JSONProtBody.i['sns.select[]']:=aout[i];
  for i:=0 to High(batchArr) do JSONProtBody.i['sns.full[]']:=batchArr[i].biSN;
//  JSONProtBody.S['batch.sns']:='sns test';
  doSavePasport(true);
end;

procedure TPover140MainFrm.DoStart;
var
  i: integer;
  s: string;
begin
  if oupBatchID = 0 then begin
    KeyDlg.ShowError('Не введен номер запуска');
    exit;
  end;

  if iSN = 0 then s:='Сканируйте штрихкод'#13'паспорта'
  else s:='Прибор '+sDevNum+' поверен'#13'Сканируйте следующий паспорт';
  i:=GetBar.ReadBar(s);
  if i = mrAbort then sbar:='01046500672918952119460072'
  else if i <> mrOk then begin
    KeyDlg.ShowInf('Операция отменена');
    exit;
  end;

  writeLog('==============================================');
  writeLog('Штрихкод паспорта: '+sbar);

  if not CheckDevice then exit;
  JSONProtBody:=so;
  JSONProtBody.S['device.sn']:=sDevNum;
  JSONProtBody.S['device.model']:=PartsArr[JSONDevSubModelID].ModelName;
  JSONProtBody.S['device.submodel']:=PartsArr[JSONDevSubModelID].Name;
  JSONProtBody.i['batch']:=oupBatchID;
// ToDo
  i:=oCom.i['tstatus'] or ftPoverka;
  oCom.i['tstatus']:=i;
  batchArr[0].biCOM.i['tstatus'];
  doSavePasport;
  iPovCnt:=0;
  for i:=0 to High(batchArr) do begin
    if (batchArr[i].biCOM.I['tstatus'] and ftPoverka) > 0 then Inc(iPovCnt);
  end;
  lbNom.Caption:=ModelsArr[cModel].Name+'-'+PartsArr[JSONPartIdx].Name
    +'  '+IntToStr(iPovCnt)+' / '+IntToStr(oupQty);
  if iPovCnt = oupQty then begin
    KeyDlg.ShowInf('В запуске '+IntToStr(oupBatchID)+' все приборы поверены');
    btnProtocol.Enabled:=true;
    btnStart.Enabled:=false;
    exit;
  end;
  Contflag:=true;
end;

procedure TPover140MainFrm.FormActivate(Sender: TObject);
var
  s: string;
begin
  if not lflag then exit;
  lflag:=false;

//  PovParamFrm.ShowModal;
  LogMemo:=LogForm.memLog;
  writeLog('');
  writeLog('===***********************************************************===');
  s:='************ Запуск программы '+ExtractFileName(Application.ExeName)+' '+GetMyVer('v.')+' ********';
  writeLog(s);
  btnStart.Enabled:=false;
  lbStatus.Caption:='Загрузка';
  OUPCheckIn;
  JSONSystem:='Karat-140';
  JSONLogIn:='kartech';
  JSONPass:='54321';
  JSONEventID:=116;
  JSONEvent:='Поверка 140';
  JSONProtocolID:=64;
  JSONProtocol:='Протокол фиксации поверки';
	EP_CheckIn(false,0,0);
  lbSite.Caption:='Рабочее место: '#13+JSONSite;
  lbPerson.Caption:='Исполнитель: '#13+JSONPson;
  EP_Load([bsParts]);
  ForceDirectories(ExePath+'\Протоколы');
  lbStatus.Caption:='';
  btnStart.Enabled:=true;
  btnBatchClick(self);
end;

procedure TPover140MainFrm.FormCreate(Sender: TObject);
var
  hm: THandle;
  w: array[0..100] of widechar;
  s: string;
  pw: pwidechar;
begin
  s:='Конвертация140';
	pw:=StrPCopy(w,s);
	HM:=OpenMutex(MUTEX_ALL_ACCESS, false, pw);
  if HM <> 0 then begin
    MessageDlg('Программа уже запущена!', mtError, [mbOk], 0);
    Halt;
  end;
	HM:=CreateMutex(nil, false, pw);  lbVersion.Caption:=GetMyVer('v.');
  EP_Create;
  OUPInit;
end;

procedure TPover140MainFrm.FormDestroy(Sender: TObject);
begin
	EP_Destroy;
  OUPDone;
end;

procedure TPover140MainFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (ssAlt in Shift) and (Key = Ord('L')) then begin
  	if not LogForm.Visible then	LogForm.Left:=Left-LogForm.Width-2;
  	LogForm.Visible:=not LogForm.Visible;
  end

end;

end.

// 1008 - добавлены 140-Э
