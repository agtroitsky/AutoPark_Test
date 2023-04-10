unit uCommon;

interface

Var
  ExePath, IniName: string;

function floatBoolValidation(s: string; var d: double): boolean;
function DblToStr(d: double): string;
function GetMyVer: string;

implementation

uses Winapi.Windows, System.SysUtils, VCL.Forms;

type
	PVerInfo = ^TVerInfo;
	TVerInfo = packed record
		Padding: array[0..47] of byte;
		Minor,Major,Build,Release: word;
  end;

function floatBoolValidation(s: string; var d: double): boolean;
var
  i: integer;
  c: char;
begin
  c:=TFormatSettings.Create.DecimalSeparator;
  result:=true;
  i:=Pos('.',s);
  if i > 0 then s[i]:=c;
  i:=Pos(',',s);
  if i > 0 then s[i]:=c;
  try
    d:=StrToFloat(s);
  except
    result:=false;
  end;
end;

function DblToStr(d: double): string;
begin
  result:=IntToStr(Round(Int(d)));
  result:=result+'.';
  result:=result+IntToStr(Round(Frac(d)*10));
end;

function GetMyVer: string;
var
	ii: integer;
	hr: hrsrc;
begin
	Result:='';
	hr:=FindResource(HInstance,PChar(1),RT_VERSION);
	ii:=LoadResource(HInstance,hr);
	if ii = 0 then exit;
	with PVerInfo(ii)^ do Result:='Версия: '+IntToStr(Major)+'.'+IntToStr(Minor)
                              +'.'+IntToStr(Release)+'.'+IntToStr(Build);
end;

begin
  ExePath:=ExtractFilePath(Application.ExeName);
	IniName:=ExtractFileName(Application.ExeName);
  Delete(IniName, Pos('.',IniName),10);
  IniName:=IniName+'.ini';
end.
