object frmList: TfrmList
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmList'
  ClientHeight = 265
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 266
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnCreate: TButton
      Left = 88
      Top = 10
      Width = 75
      Height = 22
      Caption = #1057#1086#1079#1076#1072#1090#1100
      TabOrder = 0
      OnClick = btnCreateClick
    end
  end
  object sgList: TStringGrid
    Left = 0
    Top = 41
    Width = 266
    Height = 224
    Align = alClient
    ColCount = 1
    DefaultDrawing = False
    DrawingStyle = gdsClassic
    FixedCols = 0
    FixedRows = 0
    TabOrder = 1
    OnDblClick = sgListDblClick
    OnDrawCell = sgListDrawCell
    ExplicitHeight = 161
    ColWidths = (
      253)
  end
end
