object dmAutoPark: TdmAutoPark
  OldCreateOrder = False
  Height = 175
  Width = 284
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Provider = 'MSDASQL.1'
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
