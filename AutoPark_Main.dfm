object frmAutoParkMain: TfrmAutoParkMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1091#1090#1077#1074#1099#1077' '#1083#1080#1089#1090#1099
  ClientHeight = 347
  ClientWidth = 903
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 903
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 893
    object cbShowDelete: TCheckBox
      Left = 8
      Top = 12
      Width = 153
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbShowDeleteClick
    end
  end
  object sgPathLists: TStringGrid
    Left = 0
    Top = 41
    Width = 903
    Height = 306
    Align = alClient
    DefaultDrawing = False
    DrawingStyle = gdsGradient
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 1
    OnDrawCell = sgPathListsDrawCell
    ExplicitWidth = 893
    ExplicitHeight = 296
  end
end
