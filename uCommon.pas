unit uCommon;

interface

function floatBoolValidation(s: string; var d: double): boolean;

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


end.
