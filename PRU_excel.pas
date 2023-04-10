unit PRU_excel;

interface

function writeExcel: integer;

implementation

uses
  Dialogs, Variants, ComObj, ActiveX, PRU_common, PRU_drv, sysutils, Math,
  	System.IOUtils, EAN_Types, Common_Def, EP_JSON;

//threadvar
var
  App,OO,WS: OleVariant;
  Workbook, Range, Range1, Cell1, Cell2, ArrayData  : Variant;
  namePattern: string;
  startRow, startCol: integer;

procedure DoQuit(const err: string);
begin
  OO:=unAssigned;
  WS:=unAssigned;
  if err <> '' then MessageDlg(err,mtError,[mbOk],0);
end;

procedure SaveReestr(aFile: string);
var
  i: integer;
  s,s1,sf,sh: string;
begin
  sh:='Время;Тип;Зав.№;Файл;Установка;Исполнитель';
  s1:=';'+aFile+';'+JSONSite+';'+JSONPson;
  for i:=0 to NumDevice-1 do with RSArr[i] do begin
    if not Present then continue;
    s:=FormatDateTime('hh:nn:ss',now);
    s:=s+';K-'+IntToStr(DevType)+';№';
    if (DevType = 223) or (DevType = 523) then s:=s+LowBar else s:=s+TechBar;
    s:=s+s1;
    sf:=ExePath+'Реестр\'+FormatDateTime('yyyymmdd',now);
    if Valid then sf:=sf+'_valid.csv' else sf:=sf+'_invalid.csv';
    WriteFileStr(sf,s,sh);
  end;
end;

function writeExcel: integer;
var
  i,j,i1,ik,k,k1,k2,n, prolivNumPhase, curPhase, prolivCalNum:integer;
  sheetName,s, s1: string;
  pr: ProlivRec;
  ppr: prolivParamRec;
  f,p,t,ro,v,v1,v2: double;
  devName : String;
  fil: Text;
begin
  namePattern:=cfgPath+'Шаблоны\'+curConfig.reportTemplate;
  devName:=JSONDevModel+'-'+JSONDevSubModel;

  startCol:=2;
  startRow:=3;
{
//******************************************************************************
//=== тестовые данные
  for i:=0 to c_prolivArcSize do begin
    pr.tStart:=(i)/24;
    pr.Pin:=i+0.1;
    pr.Pout:=i+0.2;
    pr.Tin:=i+0.3;
    pr.Tout:=i+0.4;
    pr.pulseWeight:=i+0.5;
    pr.curFlow:=i+0.6;
    for i1 := 0 to 11 do begin
      pr.vol[i1]:=i+0.7+i1/1000;
      pr.time[i1]:=i+0.8+i1/1000;
    end;
    prolivConst[i]:=pr;
  end;
  for i:=0 to 11 do begin
    RSArr[i].SerNum:=IntToStr(88888800+i);
    RSArr[i].Version:='5.'+IntToStr(i);
    RSArr[i].RdCoef.K0:=i+0.1;
    RSArr[i].WrCoef.K0:=i+0.2;
    RSArr[i].RdCoef0.K0:=i+0.3;
    for j := 1 to 8 do begin
      RSArr[i].RdCoef.Ki[j]:=i+0.1+j/1000;
      RSArr[i].WrCoef.Ki[j]:=i+0.2+j/1000;
      RSArr[i].RdCoef0.Ki[j]:=i+0.3+j/1000;
      RSArr[i].RdCoef.Vi[j]:=i+0.4+j/1000;
      RSArr[i].WrCoef.Vi[j]:=i+0.5+j/1000;
      RSArr[i].RdCoef0.Vi[j]:=i+0.6+j/1000;
    end;
  end;
//******************************************************************************
}

  try
	  App := CreateOleObject('Excel.Application');
  except
	  DoQuit('Ошибка запуска "Excel"');
    Result:=-101;
	  exit;
  end;
  try
	  App.Visible := false;
	  WorkBook:=App.Workbooks.Add(namePattern);
  except
    on E: EOleException do begin
      Result:=-102;
      DoQuit(E.Message);
      App := unAssigned;
      exit;
    end;
  end;

  App.Application.EnableEvents := false;

//===============================================================================
// Точки контроля

  WS:=WorkBook.WorkSheets[cmax_pointsCal+2];
  WS.Range['G2']:=DateToStr(Now);
  WS.Range['A14']:='Контрольные проливки';
  WS.Range['G3']:=devName;
  WS.Range['B4']:='Номер запуска';
  WS.Range['G4']:=BatchNum;
  WS.Range['B5']:='Вид потока';
  if curConfig.Reverse then s:='обратный' else s:='прямой';
  WS.Range['G5']:=s;
  WS.Range['B6']:='Установка';
  WS.Range['G6']:=JSONSite;
  WS.Range['B7']:='Исполнитель';
  WS.Range['G7']:=JSONPson;
  WS.Range['B8']:='ПО проливной';
  s:=GetMyVer;
  WS.Range['G8']:=s;

  WS.Range['R3']:=curConfig.TAtm;
  WS.Range['R4']:=curConfig.PAtm;
  WS.Range['R5']:=curConfig.HAtm;

  for j:=0 to 11 do begin
    if not RSArr[j].Present then continue;
// пауза, чтобы частотник не останавливался
    sleep(100);
    if (RSArr[j].DevType = 223) or (RSArr[j].DevType = 523) then begin
      s:=RSArr[j].LowBar;
      while Length(s) > 8 do Delete(s,1,1);
    end
    else s:=RSArr[j].SerNum;
    WS.Cells[11,8+j]:=s;
    WS.Cells[12,8+j]:=RSArr[j].Version;
    if curConfig.devModel <> dev551 then WS.Cells[13,8+j]:=format('%.5f',[RSArr[j].RdCoef.dT0]);
  end;
 {
  for I := 1 to curConfig.numPointContr do begin

    curPhase:=i+curConfig.numPointCalib;
    ppr:=prolivConfig[curPhase];
    if ppr.numProliv=0 then Continue;


    prolivNumPhase:=0;
    for I1 := 0 to curConfig.numPointCalib do  begin
      prolivNumPhase:=prolivNumPhase+prolivConfig[i1].numProliv;
    end;
    prolivCalNum:=prolivNumPhase;
    for I1 := 1 to i-1 do begin
      prolivNumPhase:=prolivNumPhase+prolivConfig[curConfig.numPointCalib+i1].numProliv;
    end;
}

  prolivCalNum:=0;
  for I1 := 0 to curConfig.numPointCalib do  begin
    prolivCalNum:=prolivCalNum+prolivConfig[i1].numProliv;
  end;

  for curPhase := 0 to curConfig.numPointContr+curConfig.numPointCalib do begin

// пауза, чтобы частотник не останавливался
    sleep(100);

    if (not curConfig.devModel in [dev520v3, dev213, dev551]) and (curPhase < curConfig.numPointCalib+1) then continue;

    ppr:=prolivConfig[curPhase];
    if ppr.numProliv=0 then Continue;


    prolivNumPhase:=0;
    for I1 := 0 to curPhase-1 do  begin
      prolivNumPhase:=prolivNumPhase+prolivConfig[i1].numProliv;
    end;
{}
    for j := 1 to ppr.numProliv do begin

      k:=prolivNumPhase+j-1;
      pr:=prolivConst[k];

      if not curConfig.devModel in [dev520v3, dev213, dev551] then k:=k-prolivCalNum;

      k1:=k*2+15;
      k2:=k+k1+5;

      ws.Rows[k1+1].EntireRow.Insert($FFFFEFE7, EmptyParam);
      ws.Rows[k1+1].EntireRow.Insert($FFFFEFE7, EmptyParam);
      ws.Rows[k2+1].EntireRow.Insert($FFFFEFE7, EmptyParam);

      Range:=WS.Range[WS.Cells[k1,1], WS.Cells[k1,19]];
      Range.Borders[8].colorIndex:=1;
      Range.Borders[9].colorIndex:=1;
      if j = 1 then Range.Borders[8].Weight:=4 else Range.Borders[8].Weight:=2;
      Range.Borders[9].Weight:=1;

      Cell1:=WS.Cells[k2,7];
      Cell2:=WS.Cells[k2,19];
      Range:=WS.Range[Cell1, Cell2];
      if j = 1 then
      if (curConfig.devModel in [dev520v3, dev213, dev551]) and (curPhase < curConfig.numPointCalib+1) then begin
        Range.Interior.colorIndex:=3;
        Range.Borders[9].colorIndex:=3;
        Range.Borders[8].colorIndex:=3;
        Range.Borders[9].Weight:=4;
        Range.Borders[8].Weight:=4;
      end
      else begin
        Range.Borders[8].colorIndex:=1;
        Range.Borders[8].Weight:=4;
      end;

      if pr.numPulse = 0 then continue;

      WS.Cells[k1,1]:=timeToStr(pr.tStart);
      WS.Cells[k1,2]:=pr.curFlow;
      if pr.prMode > 0 then WS.Cells[k1+1,2]:='Весовой' else WS.Cells[k1+1,2]:='Сличение';
      WS.Cells[k1,3]:=pr.pulseWeight;
      WS.Cells[k1+1,3]:=pr.RefVol;
      WS.Cells[k1,4]:=pr.numPulse;
      WS.Cells[k1+1,4]:=pr.prMode;
      WS.Cells[k1,5]:=pr.Pin;
      WS.Cells[k1+1,5]:=pr.StartWeight;
      WS.Cells[k1,6]:=pr.Pout;
      WS.Cells[k1+1,6]:=pr.StopWeight;
      WS.Cells[k1,7]:=pr.Tin;
      for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        WS.Cells[k1,8+i1]:=pr.vol[i1];
        WS.Cells[k1+1,8+i1]:=pr.time[i1];
      end;

      WS.Cells[k2,7]:=pr.curFlow;

      if pr.prMode > 0 then v2:=pr.RefVol/pr.time[pr.prMode-1] else v2:=0;

      for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        if pr.prMode > 0 then v1:=v2*pr.time[i1] else v1:=pr.vol[i1];
        if v1 < 1e-6 then f:=200 else f:=(pr.pulseWeight*(pr.numPulse-1)*1000 - v1)/v1*100;
        WS.Cells[k2,8+i1]:=f;
      end;
    end;
  end;
  WS.Rows[k1+2].Delete;
  WS.Rows[k2+1].Delete;

//===============================================================================
// Точки калибровки


  for I := 1 to curConfig.numPointCalib+1 do begin

// пауза, чтобы частотник не останавливался
    sleep(100);

    curPhase:=i-1;
    case curConfig.devModel of
      dev520v3, dev213: sheetName:='K'+IntToStr(i)+'V'+IntToStr(i);
      dev551: sheetName:='A'+IntToStr(i)+'B'+IntToStr(i);
      else begin
        if i=1 then  sheetName:='Kосн' else
        if i=2 then sheetName:='V1'
        else if (i = 4) and (curConfig.RS48) then sheetName:='P'
        else sheetName:='K'+IntToStr(i-1)+'V'+IntToStr(i-1);
      end;
    end;
    ppr:=prolivConfig[curPhase];

    WS:=WorkBook.WorkSheets[i];

//    WorkBook.WorkSheets[1].Copy(EmptyParam,WorkBook.WorkSheets[i]);
//    WS:=WorkBook.WorkSheets[i+1];
    WS.name:=sheetName;
    s:=DateToStr(Now);
    WS.Range['G2']:=s;
    WS.Range['B5']:='Вид потока';
    if curConfig.Reverse then s:='обратный' else s:='прямой';
    WS.Range['G5']:=s;
    WS.Range['B8']:='ПО проливной';
    WS.Range['G8']:=GetMyVer;
    WS.Range['A14']:='Расчет коэффициента   '+sheetName;
    WS.Range['G3']:=devName;

    WS.Range['R3']:=curConfig.TAtm;
    WS.Range['R4']:=curConfig.PAtm;
    WS.Range['R5']:=curConfig.HAtm;

    if curConfig.devModel in [dev520v3, dev213] then begin
      WS.Range['A25']:='Значение коэффициента   K'+IntToStr(i);
      WS.Range['A28']:='Значение коэффициента   V'+IntToStr(i);
//      WS.Name:='K'+IntToStr(i)+'V'+IntToStr(i);
      if i = 1 then begin
        Range:=WS.Range['A25:S27'];
        Range1:=WS.Range['A31:S33'];
        Range.Copy(Range1);
        if curConfig.devModel = dev213 then WS.Range['A31']:='Значение коэффициента термокомпенсации'
        else WS.Range['A31']:='Значение коэффициента   T1+T2';
      end;
    end
    else if curConfig.devModel = dev551 then begin
      WS.Range['A25']:='Значение коэффициента   A'+IntToStr(i);
      WS.Range['A28']:='Значение коэффициента   B'+IntToStr(i);
//      WS.Name:='A'+IntToStr(i)+' B'+IntToStr(i);
      Range:=WS.Range['A25:S27'];
      Range1:=WS.Range['A31:S33'];
      Range.Copy(Range1);
      WS.Range['A31']:='Значение кода '+IntToStr(i);
    end
    else if i in [1,2] then WS.Range['A25']:='Значение коэффициента   '+sheetName
    else if (i = 4) and (curConfig.RS48) then WS.Range['A25']:='Значение коэффициента  P'
    else begin
      WS.Range['A25']:='Значение коэффициента   K'+IntToStr(i-1);
      WS.Range['A28']:='Значение коэффициента   V'+IntToStr(i-1);
    end;

    k:=ppr.numProliv+2;

    if curConfig.devModel in [dev520v3, dev213] then for i1 := 0 to 11 do begin
      if not RSArr[i1].Present then continue;
      WS.Cells[25,8+i1]:=RSArr[i1].RdCoef0.Ki[i];
      WS.Cells[26,8+i1]:=RSArr[i1].WrCoef.Ki[i];
      WS.Cells[27,8+i1]:=RSArr[i1].RdCoef.Ki[i];
      WS.Cells[28,8+i1]:=RSArr[i1].RdCoef0.Vi[i];
      WS.Cells[29,8+i1]:=RSArr[i1].WrCoef.Vi[i];
      WS.Cells[30,8+i1]:=RSArr[i1].RdCoef.Vi[i];
      ik:=30;
      if i = 1 then begin
        ik:=33;
        WS.Cells[31,8+i1]:=RSArr[i1].RdCoef0.K0;
        WS.Cells[32,8+i1]:=RSArr[i1].WrCoef.K0;
        WS.Cells[33,8+i1]:=RSArr[i1].RdCoef.K0;
      end;
      Range:=WS.Range[WS.Cells[25,8+i1], WS.Cells[ik,8+i1]];
      Range.NumberFormat:='0';
    end
    else if curConfig.devModel = dev551 then for i1 := 0 to 11 do begin
      if not RSArr[i1].Present then continue;
      WS.Cells[25,8+i1]:=RSArr[i1].RdCoef0.Ki[i];
      WS.Cells[26,8+i1]:=RSArr[i1].WrCoef.Ki[i];
      WS.Cells[27,8+i1]:=RSArr[i1].RdCoef.Ki[i];
      WS.Cells[28,8+i1]:=RSArr[i1].RdCoef0.Vi[i];
      WS.Cells[29,8+i1]:=RSArr[i1].WrCoef.Vi[i];
      WS.Cells[30,8+i1]:=RSArr[i1].RdCoef.Vi[i];
      WS.Cells[31,8+i1]:=RSArr[i1].RdCoef0.Ci[i];
      WS.Cells[32,8+i1]:=RSArr[i1].WrCoef.Ci[i];
      WS.Cells[33,8+i1]:=RSArr[i1].RdCoef.Ci[i];
//      Range:=WS.Range[WS.Cells[25,8+i1], WS.Cells[33,8+i1]];
//      Range.NumberFormat:='0';
    end
    else case curPhase of
      0: for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        WS.Cells[25,8+i1]:=RSArr[i1].RdCoef0.K0;
        WS.Cells[26,8+i1]:=RSArr[i1].WrCoef.K0;
        WS.Cells[27,8+i1]:=RSArr[i1].RdCoef.K0;
//        WS.Rows[28].Delete;
//        WS.Rows[29].Delete;
//        WS.Rows[30].Delete;
      end;
      1: for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        WS.Cells[25,8+i1]:=RSArr[i1].RdCoef0.Vi[1];
        WS.Cells[26,8+i1]:=RSArr[i1].WrCoef.Vi[1];
        WS.Cells[27,8+i1]:=RSArr[i1].RdCoef.Vi[1];
//        WS.Rows[28].Delete;
//        WS.Rows[29].Delete;
//        WS.Rows[30].Delete;
      end;
      2..cmax_pointsCal: for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        WS.Cells[25,8+i1]:=RSArr[i1].RdCoef0.Ki[i-1];
        WS.Cells[26,8+i1]:=RSArr[i1].WrCoef.Ki[i-1];
        WS.Cells[27,8+i1]:=RSArr[i1].RdCoef.Ki[i-1];
        if (curPhase <> 4) or (not curConfig.RS48) then begin
          WS.Cells[28,8+i1]:=RSArr[i1].RdCoef0.Vi[i-1];
          WS.Cells[29,8+i1]:=RSArr[i1].WrCoef.Vi[i-1];
          WS.Cells[30,8+i1]:=RSArr[i1].RdCoef.Vi[i-1];
        end;
      end;
    end;


    for j:=0 to 11 do begin
      if not RSArr[j].Present then continue;
      WS.Cells[11,8+j]:=RSArr[j].SerNum;
      WS.Cells[12,8+j]:=RSArr[j].Version;
      WS.Cells[13,8+j]:=format('%.5f',[RSArr[j].RdCoef.dT0]);
    end;

    if ppr.numProliv=0 then Continue;

    prolivNumPhase:=0;
    for I1 := 0 to i-2 do prolivNumPhase:=prolivNumPhase+prolivConfig[i1].numProliv;

    for j := 1 to ppr.numProliv do begin

      pr:=prolivConst[prolivNumPhase+j-1];

      Range:=WS.Range[WS.Cells[13+j*2,1], WS.Cells[13+j*2,19]];
      Range.Borders[8].colorIndex:=1;
      Range.Borders[9].colorIndex:=1;
      Range.Borders[8].Weight:=2;
      Range.Borders[9].Weight:=1;

      if pr.numPulse = 0 then continue;

      s:=timeToStr(pr.tStart);
      WS.Cells[13+j*2,1]:=s;
      WS.Cells[13+j*2,2]:=pr.curFlow;
      if pr.prMode > 0 then WS.Cells[13+j*2+1,2]:='Весовой' else WS.Cells[13+j*2+1,2]:='Сличение';
      WS.Cells[13+j*2,3]:=pr.pulseWeight;
      if pr.prMode = 0 then WS.Cells[13+j*2+1,3].NumberFormat:='0';
      WS.Cells[13+j*2+1,3]:=pr.RefVol;
      WS.Cells[13+j*2,4]:=pr.numPulse;
      WS.Cells[13+j*2+1,4]:=pr.prMode;
      WS.Cells[13+j*2,5]:=pr.Pin;
      WS.Cells[13+j*2+1,5]:=pr.StartWeight;
      WS.Cells[13+j*2,6]:=pr.Pout;
      WS.Cells[13+j*2+1,6]:=pr.StopWeight;
      WS.Cells[13+j*2,7]:=pr.Tin;
      WS.Cells[13+j*2+1,7]:=pr.KCorr;
//      WS.Cells[12+j*2,5]:=pr.Tout;
      for i1 := 0 to 11 do begin
        if not RSArr[i1].Present then continue;
        WS.Cells[13+j*2,8+i1]:=pr.vol[i1];
        WS.Cells[13+j*2+1,8+i1]:=pr.time[i1];
      end;
    end;

  end;
  s:=ExePath+'Архив';
  if not TDirectory.Exists(s) then MkDir(s);
//  WorkBook.WorkSheets[1].Delete;
  s:=s+'\'+FormatDateTime('yyyymmdd_hhnnss',now);
  WorkBook.SaveAs(s);
  if PRU_Mode in [modPRUS_8, modPRUS_15A] then begin
    WorkBook.close;
  end
  else begin
{$I-}
    DeleteFile(ExePath+'Текущий отчёт.xls');
    DeleteFile(ExePath+'Текущий отчёт.xlsx');
{$I+}
    WorkBook.SaveAs(ExePath+'Текущий отчёт');
    App.Visible:=true;
  end;
  app:=Unassigned;
  SaveReestr(s);
  Result:=0;
end;




end.
