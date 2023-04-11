object frmPers: TfrmPers
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1089#1086#1085#1072#1083
  ClientHeight = 246
  ClientWidth = 199
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    199
    246)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 99
    Width = 49
    Height = 13
    Caption = #1054#1090#1095#1077#1089#1090#1074#1086
  end
  object Label4: TLabel
    Left = 8
    Top = 152
    Width = 80
    Height = 13
    Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
  end
  object Label2: TLabel
    Left = 8
    Top = 53
    Width = 19
    Height = 13
    Caption = #1048#1084#1103
  end
  object Label3: TLabel
    Left = 8
    Top = 7
    Width = 44
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103
  end
  object dpBirthDate: TDateTimePicker
    Left = 110
    Top = 150
    Width = 81
    Height = 21
    Date = 45022.548412060180000000
    Time = 45022.548412060180000000
    TabOrder = 3
  end
  object cbDeleted: TCheckBox
    Left = 59
    Top = 176
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
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 8
    Top = 205
    Width = 86
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 5
    ExplicitTop = 207
  end
  object btnCancel: TButton
    Left = 116
    Top = 209
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
    TabOrder = 6
    ExplicitTop = 211
  end
  object edPatronymic: TEdit
    Left = 9
    Top = 119
    Width = 182
    Height = 21
    TabOrder = 2
  end
  object edName: TEdit
    Left = 8
    Top = 72
    Width = 182
    Height = 21
    TabOrder = 1
  end
  object edSurName: TEdit
    Left = 8
    Top = 26
    Width = 182
    Height = 21
    TabOrder = 0
  end
end
