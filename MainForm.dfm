object CLUFrmMain: TCLUFrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Clicklocker Unpacker'
  ClientHeight = 94
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 19
    Top = 19
    Width = 26
    Height = 13
    Caption = 'Path:'
  end
  object PathEdit: TEdit
    Left = 51
    Top = 16
    Width = 313
    Height = 21
    TabOrder = 0
  end
  object UnpackBtn: TButton
    Left = 51
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Unpack'
    TabOrder = 1
    OnClick = UnpackBtnClick
  end
  object BrowseBtn: TButton
    Left = 370
    Top = 14
    Width = 75
    Height = 25
    Caption = 'Browse'
    TabOrder = 2
    OnClick = BrowseBtnClick
  end
  object ExitBtn: TButton
    Left = 334
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = ExitBtnClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'ClickLocker File | *.exe'
    Left = 408
    Top = 65520
  end
end
