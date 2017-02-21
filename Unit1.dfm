object Form1: TForm1
  Left = 299
  Top = 99
  Caption = 'Form1'
  ClientHeight = 219
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar1: TProgressBar
    Left = 5
    Top = 199
    Width = 683
    Height = 17
    Smooth = True
    Step = 1
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 8
    Top = 35
    Width = 680
    Height = 158
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 575
    Top = 4
    Width = 113
    Height = 29
    Caption = #1054#1073#1079#1086#1088
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 561
    Height = 21
    TabOrder = 2
    Text = #1055#1072#1087#1082#1072'..'
  end
end
