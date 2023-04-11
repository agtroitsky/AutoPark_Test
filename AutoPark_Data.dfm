object dmAutoPark: TdmAutoPark
  OldCreateOrder = False
  Height = 118
  Width = 227
  object ADOConnection: TADOConnection
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 32
    Top = 24
  end
  object ADOQuery: TADOQuery
    Tag = 1
    Connection = ADOConnection
    Parameters = <>
    Left = 144
    Top = 24
  end
end
