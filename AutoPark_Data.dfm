object dmAutoPark: TdmAutoPark
  OldCreateOrder = False
  Height = 175
  Width = 284
  object ADOConnection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSDASQL.1;Password=12345678;Persist Security Info=True;' +
      'User ID=root;Extended Properties="DRIVER={MySQL ODBC 8.0 ANSI Dr' +
      'iver};UID=root;PWD=12345678;DATABASE=auto_test;PORT=3306;COLUMN_' +
      'SIZE_S32=1;"'
    Left = 32
    Top = 24
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 128
    Top = 24
  end
end
