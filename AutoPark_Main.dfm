object frmAutoParkMain: TfrmAutoParkMain
  Left = 0
  Top = 0
  Caption = #1055#1091#1090#1077#1074#1099#1077' '#1083#1080#1089#1090#1099
  ClientHeight = 337
  ClientWidth = 893
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
    Width = 893
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 96
    ExplicitTop = 32
    ExplicitWidth = 185
  end
  object sgPathLists: TStringGrid
    Left = 0
    Top = 41
    Width = 893
    Height = 296
    Align = alClient
    DefaultDrawing = False
    DrawingStyle = gdsGradient
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    TabOrder = 1
    OnDrawCell = sgPathListsDrawCell
    ExplicitTop = 47
  end
end
