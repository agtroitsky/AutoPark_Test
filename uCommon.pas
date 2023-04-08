unit uCommon;

interface

function floatBoolValidation(s: string; var d: double): boolean;
function DblToStr(d: double): string;

implementation

uses System.SysUtils;

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

end.
