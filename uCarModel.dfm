object frmCarModel: TfrmCarModel
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1052#1086#1076#1077#1083#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
  ClientHeight = 140
  ClientWidth = 208
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
    208
    140)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 11
    Top = 45
    Width = 39
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1052#1086#1076#1077#1083#1100
    ExplicitTop = 169
  end
  object Label1: TLabel
    Left = 11
    Top = 18
    Width = 32
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = #1052#1072#1088#1082#1072
    ExplicitTop = 142
  end
  object edModel: TEdit
    Left = 59
    Top = 42
    Width = 125
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 1
  end
  object cbDeleted: TCheckBox
    Left = 59
    Top = 69
    Width = 84
    Height = 20
    Anchors = [akLeft, akBottom]
    Caption = #1059#1076#1072#1083#1077#1085#1072
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 2
  end
  object btnOk: TButton
    Left = 8
    Top = 99
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
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 109
    Top = 103
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
    TabOrder = 4
  end
  object edFirm: TEdit
    Left = 59
    Top = 15
    Width = 125
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 0
  end
end
