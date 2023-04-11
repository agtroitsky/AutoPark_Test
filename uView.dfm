object frmView: TfrmView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1080#1076' '#1090#1072#1073#1083#1080#1094#1099
  ClientHeight = 273
  ClientWidth = 262
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    262
    273)
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 85
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
    TabOrder = 0
    object cbSort1: TComboBox
      Left = 3
      Top = 19
      Width = 232
      Height = 21
      Style = csDropDownList
      ItemIndex = 7
      TabOrder = 0
      Text = #1055#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103
      OnChange = cbSort1Change
      Items.Strings = (
        #1055#1086' '#1085#1086#1084#1077#1088#1091
        #1055#1086' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1102
        #1055#1086' '#1074#1086#1076#1080#1090#1077#1083#1102
        #1055#1086' '#1076#1080#1089#1087#1077#1090#1095#1077#1088#1091
        #1055#1086' '#1087#1088#1086#1073#1077#1075#1091
        #1055#1086' '#1088#1072#1089#1093#1086#1076#1091' '#1090#1086#1087#1083#1080#1074#1072
        #1055#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1074#1099#1077#1079#1076#1072
        #1055#1086' '#1074#1088#1077#1084#1077#1085#1080' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103)
    end
    object cbSort2: TComboBox
      Left = 3
      Top = 51
      Width = 232
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 99
    Width = 241
    Height = 110
    Caption = #1054#1090#1073#1086#1088
    TabOrder = 1
    object lbFrom: TLabel
      Left = 15
      Top = 55
      Width = 14
      Height = 13
      Caption = #1054#1090
    end
    object lbTo: TLabel
      Left = 133
      Top = 55
      Width = 13
      Height = 13
      Caption = #1076#1086
    end
    object cbSelect1: TComboBox
      Left = 7
      Top = 20
      Width = 228
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbSelect1Change
      Items.Strings = (
        #1042#1089#1077' '#1079#1072#1087#1080#1089#1080' '#1073#1077#1079' '#1086#1090#1073#1086#1088#1072
        #1053#1086#1084#1077#1088' '#1087#1091#1090#1077#1074#1086#1075#1086' '#1083#1080#1089#1090#1072
        #1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072
        #1042#1088#1077#1084#1103' '#1074#1086#1079#1074#1088#1072#1097#1077#1085#1080#1103
        #1053#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103', '#1079#1085#1072#1095#1077#1085#1080#1077
        #1053#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103', '#1092#1088#1072#1075#1084#1077#1085#1090
        #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103', '#1079#1085#1072#1095#1077#1085#1080#1077
        #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103', '#1092#1088#1072#1075#1084#1077#1085#1090
        #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        #1060#1048#1054' '#1074#1086#1076#1080#1090#1077#1083#1103', '#1079#1085#1072#1095#1077#1085#1080#1077
        #1060#1048#1054' '#1074#1086#1076#1080#1090#1077#1083#1103', '#1092#1088#1072#1075#1084#1077#1085#1090
        #1060#1048#1054' '#1076#1080#1089#1087#1077#1090#1095#1077#1088#1072', '#1079#1085#1072#1095#1077#1085#1080#1077
        #1060#1048#1054' '#1076#1080#1089#1087#1077#1090#1095#1077#1088#1072', '#1092#1088#1072#1075#1084#1077#1085#1090
        #1055#1088#1086#1073#1077#1075', '#1082#1084
        #1056#1072#1089#1093#1086#1076' '#1090#1086#1087#1083#1080#1074#1072', '#1083)
    end
    object cbSelect2: TComboBox
      Left = 7
      Top = 51
      Width = 228
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
    object dpFrom: TDateTimePicker
      Left = 37
      Top = 51
      Width = 81
      Height = 21
      Date = 45025.834419606480000000
      Time = 45025.834419606480000000
      TabOrder = 2
    end
    object dpTo: TDateTimePicker
      Left = 154
      Top = 51
      Width = 81
      Height = 21
      Date = 45025.834419606480000000
      Time = 45025.834419606480000000
      TabOrder = 3
    end
    object seFrom: TSpinEdit
      Left = 37
      Top = 51
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object seTo: TSpinEdit
      Left = 154
      Top = 51
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 5
      Value = 0
    end
    object edPart: TEdit
      Left = 80
      Top = 51
      Width = 155
      Height = 21
      TabOrder = 6
    end
    object cbShowDeleted: TCheckBox
      Left = 52
      Top = 82
      Width = 137
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      TabOrder = 7
    end
  end
  object btnOk: TButton
    Left = 28
    Top = 230
    Width = 86
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 239
  end
  object btnCancel: TButton
    Left = 158
    Top = 234
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 243
  end
end
