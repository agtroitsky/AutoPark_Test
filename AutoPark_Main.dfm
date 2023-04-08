object frmAutoParkMain: TfrmAutoParkMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1055#1091#1090#1077#1074#1099#1077' '#1083#1080#1089#1090#1099
  ClientHeight = 337
  ClientWidth = 893
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
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
    ExplicitTop = -6
    object btnNew: TButton
      Left = 96
      Top = 4
      Width = 81
      Height = 35
      Caption = #1053#1086#1074#1099#1081' '#1087#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      TabOrder = 0
      WordWrap = True
      OnClick = btnNewClick
    end
    object btnView: TButton
      Left = 248
      Top = 4
      Width = 81
      Height = 35
      Caption = #1042#1080#1076' '#1090#1072#1073#1083#1080#1094#1099
      TabOrder = 1
      WordWrap = True
      OnClick = btnViewClick
    end
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
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 1
    OnDblClick = sgPathListsDblClick
    OnDrawCell = sgPathListsDrawCell
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 304
    object N1: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      object miDrivers: TMenuItem
        Caption = #1042#1086#1076#1080#1090#1077#1083#1080
        OnClick = miDriversClick
      end
      object miDisps: TMenuItem
        Caption = #1044#1080#1089#1087#1077#1090#1095#1077#1088#1099
        OnClick = miDispsClick
      end
      object miCarModels: TMenuItem
        Caption = #1052#1086#1076#1077#1083#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
        OnClick = miCarModelsClick
      end
      object miCars: TMenuItem
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
        OnClick = miCarsClick
      end
    end
  end
end
