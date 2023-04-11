object frmCar: TfrmCar
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  ClientHeight = 267
  ClientWidth = 196
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
    196
    267)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 17
    Top = 11
    Width = 54
    Height = 13
    Caption = #1043#1086#1089'. '#1085#1086#1084#1077#1088
  end
  object Label3: TLabel
    Left = 17
    Top = 32
    Width = 39
    Height = 13
    Caption = #1052#1086#1076#1077#1083#1100
  end
  object Label2: TLabel
    Left = 17
    Top = 91
    Width = 65
    Height = 13
    Caption = #1043#1086#1076' '#1074#1099#1087#1091#1089#1082#1072
  end
  object Label4: TLabel
    Left = 17
    Top = 131
    Width = 72
    Height = 13
    Caption = #1055#1086#1089#1083#1077#1076#1085#1077#1077' '#1058#1054
  end
  object Label5: TLabel
    Left = 17
    Top = 169
    Width = 55
    Height = 13
    Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084
  end
  object cbCarModel: TComboBox
    Left = 17
    Top = 51
    Width = 161
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 1
  end
  object dpTODate: TDateTimePicker
    Left = 97
    Top = 127
    Width = 81
    Height = 21
    Date = 45022.548412060180000000
    Time = 45022.548412060180000000
    TabOrder = 3
  end
  object edPath: TEdit
    Left = 97
    Top = 166
    Width = 81
    Height = 21
    TabOrder = 4
  end
  object cbDeleted: TCheckBox
    Left = 59
    Top = 193
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
    TabOrder = 5
  end
  object btnOk: TButton
    Left = 11
    Top = 223
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
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 109
    Top = 228
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
    TabOrder = 7
  end
  object seYear: TSpinEdit
    Left = 97
    Top = 88
    Width = 81
    Height = 22
    MaxValue = 2023
    MinValue = 1960
    TabOrder = 2
    Value = 1960
  end
  object edNumber: TEdit
    Left = 97
    Top = 9
    Width = 81
    Height = 21
    TabOrder = 0
  end
end
