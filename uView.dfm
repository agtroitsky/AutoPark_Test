object frmView: TfrmView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1080#1076' '#1090#1072#1073#1083#1080#1094#1099
  ClientHeight = 296
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
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 89
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
    TabOrder = 0
    object cbSort1: TComboBox
      Left = 3
      Top = 24
      Width = 163
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
      Width = 163
      Height = 21
      Style = csDropDownList
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 103
    Width = 185
    Height = 105
    Caption = #1054#1090#1073#1086#1088
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 8
    Top = 242
    Width = 86
    Height = 33
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 106
    Top = 247
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
    TabOrder = 3
  end
end
