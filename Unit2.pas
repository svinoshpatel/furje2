﻿unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  Vector = array[0..1000] of Real;
  Vec = array[0..50] of Real;
  TForm2 = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Edital: TEdit;
    Editbl: TEdit;
    EditNg: TEdit;
    EditNe: TEdit;
    Button1: TButton;
    BitBtn1: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Xe, Ye: Vector;
  Xg, Yg: Vector;
  a, b, c: Vec;
  Ne, Ngr: Integer;
  Ng: Integer;
  Tp: Real;
  al, bl: Real;

implementation

{$R *.dfm}

Function f1(x: Real): Real;
Begin
  Tp := bl - al;
  if x < TP / 2 then
    f1 := 2
  else if (x >= TP / 2) and (x < 3 * TP / 4) then
    f1 := 4 * (TP - 2 * x) / TP
  else
    f1 := 8 * (x - TP) / TP;
End;

Function f2(x: Real): Real;
Begin
  Tp := bl - al;
  if x < TP / 3 then
    f2 := 3
  else if (x >= TP / 3) and (x < 2 * TP / 3) then
    f2 := sin((Pi * x) / TP) * 5
  else
    f2 := -2 * (x - TP) / TP;
End;



Procedure TabF(Var Xe: Vector; Var Ye: Vector);
Var
  h: Real;
  i: Integer;
Begin
  h := (bl - al) / Ne;
  Xe[0] := al;
  For i := 0 to Ne - 1 do
  Begin
    if Form2.RadioGroup1.ItemIndex = 0 then
      Ye[i] := f1(Xe[i])
    else if Form2.RadioGroup1.ItemIndex = 1 then
      Ye[i] := f2(Xe[i])
    else
    begin
      ShowMessage('Рівняння не вибрано');
      exit;
    end;
    Xe[i+1] := Xe[i] + h;
  End;
End;

// Процедура побудови і табуляції суми ряду Фур’є згідно з алгоритмом, що є на рис. 1.4.
Procedure Furje(Xe, Ye: Vector; Ne: Integer; var Yg: Vector);
Var
  i, k: Integer;
  w, KOM, S, G, D: Real;
Begin
  Ng := StrToInt(Form2.EditNg.text); // вводимо кількість гармонік
  Tp := bl - al; // TP – період функції
  // Обчислення коефіцієнтів ряду Фур'є
  w := 2 * Pi / Tp;
  For k := 1 to Ng do
  Begin
    KOM := k * w;
    G := 0.0;
    D := 0.0;
    For i := 1 to Ne do
    Begin
      S := KOM * Xe[i];
      G := G + Ye[i] * Cos(S);
      D := D + Ye[i] * Sin(S);
    End;
    a[k] := 2 * G / Ne;
    b[k] := 2 * D / Ne;
    c[k] := Sqrt(Sqr(a[k]) + Sqr(b[k]));
  End;
  a[0] := 0.0;
  For i := 1 to Ne do
    a[0] := a[0] + Ye[i];
  a[0] := a[0] / Ne;
  For i := 0 to Ne - 1 do // побудова і табуляція суми ряду Фур’є
  Begin
    S := 0;
    D := Xe[i] * w;
    For k := 1 to Ng do
    Begin
      KOM := k * D;
      S := S + b[k] * Sin(KOM) + a[k] * Cos(KOM);
    End;
    Yg[i] := a[0] + S;
  End;
End;

Procedure TForm2.Button1Click(Sender: TObject);
Var
  p, zx, zy, ay, bx, krx, kry, xx, yy, Gx, Gy: Real;
  i, j, krokx, kroky, drv, drm, visx, visy, L: Integer;
  minYg, maxYg, maxx, maxy, minx, miny, kx, ky: Real;
  // Процедура візуалізації гармонік
  Procedure Garm(Ng: Integer; c: Vec);
  Var
    i, krokx, x: Integer;
    MaxC, ky, w: Real;
  Begin
    krokx := (Image1.ClientWidth - 2 * L) div Ng;
    MaxC := c[1];
    For i := 2 to Ng do
      If c[i] > MaxC then
        MaxC := c[i];
    ky := (Image1.ClientHeight div 2) / MaxC;
    With Image1.Canvas do
    Begin
      Pen.Color := clHighLight;
      Pen.Width := 2;
      MoveTo(L, L + 20);
      LineTo(L + 10, L + 10);
      LineTo(L + 20, L + 20);
      MoveTo(L + 10, L + 10);
      LineTo(L + 10, Image1.ClientHeight - 50);
      LineTo(Image1.ClientWidth - 20, Image1.ClientHeight - 50);
      MoveTo(Image1.ClientWidth - 40, Image1.ClientHeight - 60);
      LineTo(Image1.ClientWidth - 20, Image1.ClientHeight - 50);
      LineTo(Image1.ClientWidth - 40, Image1.ClientHeight - 40);
      TextOut(L - 2, L, 'C');
      TextOut(ClientWidth - 50, ClientHeight - 25, 'W');
      Pen.Color := clLime;
      Pen.Width := 2;
      x := krokx + 20;
      w := 2 * Pi / (bl - al);
      For i := 1 to Ng do
      Begin
        MoveTo(Round(x) + 3, Image1.ClientHeight - 50);
        LineTo(Round(x) + 3, Image1.ClientHeight - 50 - Round(ky * c[i]));
        TextOut(Round(x), Image1.ClientHeight - Round(ky * c[i]) - 65,
          FloatToStrF(c[i], ffGeneral, 0, 0));
        Ellipse(Round(x), Image1.ClientHeight - 53, Round(x) + 5,
          Image1.ClientHeight - 48);
        Ellipse(Round(x) + 1, Image1.ClientHeight - 50 - Round(ky * c[i]),
          Round(x) + 7, Image1.ClientHeight - 50 - Round(ky * c[i]) + 5);
        x := x + krokx;
      End;
      x := krokx + 19;
      TextOut(Round(x), Image1.ClientHeight - 30,
        'W=' + FloatToStrF(w, ffGeneral, 0, 0));
    End;
  End;

Begin
  Ne := StrToInt(EditNe.text);
  Ngr := Ne;
  al := StrToFloat(Form2.Edital.text);
  bl := StrToFloat(Form2.Editbl.text);
  TabF(Xe, Ye); // табуляція заданої періодичної функції
  Furje(Xe, Ye, Ne, Yg);
  // обчислення коефіцієнтів ряду Фур'є і табуляція суми ряду
  // Будуємо графіки обох функцій Ye(Xe) та Yg(Xe)
  L := 40; // відступ від країв компоненти TImage
  With Form2.Image1 do
  Begin
    Canvas.Pen.Width := 2;
    Canvas.Pen.Color := clPurple;
    Canvas.Pen.Style := psSolid;
    Canvas.Rectangle(1, 1, Width - 1, Height - 1);
    minYg := Yg[0];
    maxYg := Yg[0];
    For i := 1 to Ngr - 1 do
    Begin
      If maxYg < Yg[i] then
        maxYg := Yg[i];
      If minYg > Yg[i] then
        minYg := Yg[i];
    End;
    minx := Xe[0];
    maxx := Xe[Ne - 1];
    miny := Ye[0];
    maxy := Ye[0];
    For i := 1 to Ne - 1 do
    Begin
      If maxy < Ye[i] then
        maxy := Ye[i];
      If miny > Ye[i] then
        miny := Ye[i];
    End;
    If maxy < maxYg then
      maxy := maxYg;
    If miny > minYg then
      miny := minYg;
    // Обчислюємо значення коефіцієнтів масштабування
    kx := (Width - 2 * L) / (maxx - minx);
    ky := (Height - 2 * L) / (miny - maxy);
    zx := (Width * minx - L * (minx + maxx)) / (minx - maxx);
    zy := (Height * maxy - L * (miny + maxy)) / (maxy - miny);
  End;
  // Обчислюємо розташування плаваючих осей
  If minx * maxx <= 0.0 then
    Gx := 0.0;
  If (minx * maxx > 0.0) then
    Gx := minx;
  If (minx * maxx > 0.0) then
    Gx := minx;
  If (minx * maxx > 0.0) and (minx < 0.0) then
    Gx := maxx;
  If miny * maxy <= 0.0 then
    Gy := 0.0;
  If (miny * maxy > 0.0) and (miny > 0.0) then
    Gy := miny;
  If (miny * maxy > 0.0) and (miny < 0.0) then
    Gy := maxy;
  With Form2.Image1.Canvas do // ------------------------
  Begin
    Pen.Color := clSilver;
    Pen.Width := StrToInt(ComboBox4.Text);
    krokx := (Width - 2 * L) div 10;
    kroky := (Height - 2 * L) div 10;
    For i := 0 to 10 do
    Begin
      MoveTo(L, Round(ky * Gy + zy) + i * kroky);
      LineTo(Width - L, Round(ky * Gy + zy) + i * kroky);
      MoveTo(L, Round(ky * Gy + zy) - i * kroky);
      LineTo(Width - L, Round(ky * Gy + zy) - i * kroky);
      MoveTo(Round(kx * Gx + zx) + i * krokx, L);
      LineTo(Round(kx * Gx + zx) + i * krokx, Height - L);
      MoveTo(Round(kx * Gx + zx) - i * krokx, L);
      LineTo(Round(kx * Gx + zx) - i * krokx, Height - L);
    End;
    xx := minx;
    yy := maxy;
    krx := (maxx - minx) / 10.0;
    kry := (maxy - miny) / 10.0;
    For i := 0 to 9 do
    Begin
      TextOut(L + 4 + i * krokx, Round(ky * Gy + zy) - L + 43,
        FloatToStrF(xx, ffGeneral, 2, 5));
      TextOut(Round(kx * Gx + zx) - L + 10, L + i * kroky - 5,
        FloatToStrF(yy, ffGeneral, 2, 5));
      Pen.Color := clLime;
      xx := xx + krx;
      yy := yy - kry;
    End;
    Pen.Style := psSolid; // малюємо плаваючі осі----------
    Pen.Color := clBlack;
    Pen.Width := StrToInt(ComboBox3.Text);
    MoveTo(L, Round(ky * Gy + zy));
    LineTo(Round(Width - L), Round(ky * Gy + zy));
    MoveTo(Round(kx * Gx + zx), L);
    LineTo(Round(kx * Gx + zx), Round(Height - L));
    Pen.Width := StrToInt(ComboBox2.Text);
    Pen.Color := clRed;
    MoveTo(Round(kx * Xe[0] + zx), Round(ky * Ye[0] + zy));
    For i := 0 to Ne - 1 do
      LineTo(Round(kx * Xe[i] + zx), Round(ky * Ye[i] + zy));
    Pen.Width := StrToInt(ComboBox1.Text);
    Pen.Color := clLime;
    MoveTo(Round(kx * Xe[0] + zx), Round(ky * Yg[0] + zy));
    For i := 0 to Ne - 1 do
      LineTo(Round(kx * Xe[i] + zx), Round(ky * Yg[i] + zy));
  end;
  ShowMessage('Показати гармоніки ?');
  Image1.Picture := nil;
  Garm(Ng, c);
end;

end.
