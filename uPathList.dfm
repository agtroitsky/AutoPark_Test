object frmPathList: TfrmPathList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
  ClientHeight = 361
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 16
    Top = 6
    Width = 61
    Height = 13
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object Label4: TLabel
    Left = 16
    Top = 54
    Width = 49
    Height = 13
    Caption = #1042#1086#1076#1080#1090#1077#1083#1100
  end
  object Label5: TLabel
    Left = 16
    Top = 102
    Width = 55
    Height = 13
    Caption = #1044#1080#1089#1087#1077#1090#1095#1077#1088
  end
  object Label1: TLabel
    Left = 24
    Top = 219
    Width = 94
    Height = 13
    Caption = #1056#1072#1089#1093#1086#1076' '#1090#1086#1087#1083#1080#1074#1072', '#1083
  end
  object Label2: TLabel
    Left = 168
    Top = 219
    Width = 55
    Height = 13
    Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084
  end
  object dpDateOut: TDateTimePicker
    Left = 87
    Top = 154
    Width = 81
    Height = 21
    Date = 45022.548412060180000000
    Time = 45022.548412060180000000
    TabOrder = 0
    Visible = False
  end
  object tpTimeOut: TDateTimePicker
    Left = 174
    Top = 154
    Width = 81
    Height = 21
    Date = 45022.548596226850000000
    Time = 45022.548596226850000000
    Kind = dtkTime
    TabOrder = 1
    Visible = False
  end
  object dpDateIn: TDateTimePicker
    Left = 87
    Top = 187
    Width = 81
    Height = 21
    Date = 45022.548412060180000000
    Time = 45022.548412060180000000
    TabOrder = 2
    Visible = False
  end
  object tpTimeIn: TDateTimePicker
    Left = 174
    Top = 187
    Width = 81
    Height = 21
    Date = 45022.548596226850000000
    Time = 45022.548596226850000000
    Kind = dtkTime
    TabOrder = 3
    Visible = False
  end
  object cbCar: TComboBox
    Left = 16
    Top = 25
    Width = 239
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 4
  end
  object cbDriver: TComboBox
    Left = 16
    Top = 73
    Width = 239
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 5
  end
  object cbDisp: TComboBox
    Left = 16
    Top = 121
    Width = 239
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 6
  end
  object cbOut: TCheckBox
    Left = 16
    Top = 155
    Width = 65
    Height = 17
    Caption = #1042#1099#1077#1093#1072#1083
    TabOrder = 7
    OnClick = cbOutClick
  end
  object cbIn: TCheckBox
    Left = 16
    Top = 188
    Width = 65
    Height = 17
    Caption = #1042#1077#1088#1085#1091#1083#1089#1103
    TabOrder = 8
    OnClick = cbInClick
  end
  object cbDeleted: TCheckBox
    Left = 91
    Top = 265
    Width = 77
    Height = 20
    Caption = #1059#1076#1072#1083#1077#1085
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 9
  end
  object edFuel: TEdit
    Left = 24
    Top = 238
    Width = 94
    Height = 21
    TabOrder = 10
  end
  object edPath: TEdit
    Left = 152
    Top = 238
    Width = 94
    Height = 21
    TabOrder = 11
  end
  object btnOk: TButton
    Left = 32
    Top = 304
    Width = 86
    Height = 33
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 12
  end
  object btnCancel: TButton
    Left = 160
    Top = 308
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 13
  end
end
