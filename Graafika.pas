
Unit Graafika;

Interface

Uses Lugemine;
Function Joonista(andmed:Andmejada): Integer;

Implementation

Uses sysutils, Graph, crt, Math;

Procedure KaivitaGraafika;

Var 
  grdriver, {Graafika draiver}
  grmode, {Graafikamood}
  errcode : SmallInt; {Veakoodi puhver}
Begin
  grdriver := vga;
  grmode := vgahi;
  initgraph(grdriver, grmode,'');
  errcode := graphresult;
  If errcode <> grok Then
    Begin
      CloseGraph;
      writeln('Graphics error: ', grapherrormsg(errcode));
      halt(1);
    End;
End;

Function Find_Max(Arr: Andmejada): Double;

Var 
  i: Integer;
  N : Double;
  k: kjt;
Begin
  For i:=1 To Arr.len Do
    Begin
      k := Arr.data[i];
      If i=1 Then
        Begin
          N := k.temp;
        End
      Else
        Begin
          If k.temp>N Then N := k.temp;
        End;
    End;
  Find_Max := N;
End;

Function Find_Min(Arr: Andmejada): Double;

Var 
  i: Integer;
  N : Double;
  k: kjt;
Begin
  For i:=1 To Arr.len Do
    Begin
      k := Arr.data[i];
      If i=1 Then
        Begin
          N := k.temp;
        End
      Else
        Begin
          If k.temp<N Then N := k.temp;
        End;
    End;
  Find_Min := N;
End;

Function Joonista(andmed:Andmejada): Integer;

Var 
  X, Y, Xp    : Word;
  Varv    : Word;
  h, i, j, l, o, BHSec, EHSEC : longint;
  MinI, MaxI, TF, ETTS, BTTS, CTTS, TLP   : longint;
  YA, YL, YSamm, TickY, YAREA, YComp : Double;
  XSamm, Max, Min, MinAbs, MaxAbs, k, m, TRange : Double;
  fs: TFormatSettings;
  dt: TDateTime;
  FF : TFloatFormat = ffGeneral;
  R: ^kjt;
  BTT, ETT, CTT : TTimeStamp;
Begin
  KaivitaGraafika;
  TickY := 4;
  Max := Find_Max(andmed);
  Min := Find_Min(andmed);
  MaxI := Math.Ceil(Max);
  MinI := Math.Floor(Min);
  MinAbs := abs(MinI);
  MaxAbs := abs(MaxI);
  YA := GetMaxY-(GetMaxY*(1/6));
  YL := ((GetMaxY*1/6));
  fs := DefaultFormatSettings;
  fs.ShortDateFormat := 'yyyy-mm-dd';
  BTT := DateTimeToTimeStamp(andmed.data[0].date);
  ETT := DateTimeToTimeStamp(andmed.data[andmed.len-1].date);
  OutTextXY(10, 10, 'Temperatuuri andmed ajas');
  OutTextXY(10, round(YL-40), 'Temperatuur [C]');
  OutTextXY(GetmaxX-100, GetmaxY-40, 'Aeg [h]');
  //alumine joon
  MoveTo(50,round(YA));
  LineTo(GetMaxX-50,round(YA));
  OutTextXY(10, round(YA)-5, IntToStr(MinI));
  //vasak joon
  MoveTo(50,round(YA));
  LineTo(50,round(YL));
  //ylemine joon
  MoveTo(50,round(YL));
  LineTo(GetMaxX-50,round(YL));
  OutTextXY(10, round(YL)-5, IntToStr(MaxI));
  //parem joon
  MoveTo(GetMaxX-50,round(YA));
  LineTo(GetMaxX-50,round(YL));
  //WriteLn('Y piirid ',YL:0:2,' ',YA:0:2,' ',GetMaxY);
  Yarea := YA-YL;
  j := round(Yarea/TickY);
  i := round(YL+j);
  l := 1;
  m := (MinAbs+MaxAbs)/TickY;

  SetLineStyle(Dashedln, 0, 1);
  While i<YA Do
    Begin
      MoveTo(50,i);
      LineTo(GetMaxX-50,i);
      OutTextXY(10, i-5, FloatToStrF(MaxI-(l*m),FF,2,2));
      i := i+j;
      l := l+1;
    End;

  SetLineStyle(Solidln, 0, 1);
  Varv := LightRed;
  j := andmed.len;
  i := 0;
  k := 0.1;
  //Ytelg
  YSamm := YArea/((MinAbs+MaxAbs)/k);
  YComp := 0;
  If Min<0 Then
    YComp := MinAbs/k*Ysamm;
  SetColor(Varv); {Seame ellipsi piirjoone ja täidise värvi}
  SetFillStyle(SolidFill,Varv);
  //WriteLn('Y samm ',YSamm:0:2,' ',YA-YL:0:2);
  //MoveTo(0,GetMaxY);
  Y := 0;
  BHSec := BTT.Date*24*3600;
  EHSec := ETT.Date*24*3600;
  ETTS := EHSec+round(ETT.Time/1000);
  BTTS := BHSec+round(BTT.Time/1000);
  TF := Math.Ceil((ETTS-BTTS)/3600)*3600;
  //esimese punkti aeg sekundites
  o := 0;
  R := @andmed.data[o];
  CTT := DateTimeToTimeStamp(R^.date);
  CTTS := CTT.Date*24*3600+longint(round(CTT.Time/1000));

  // timeframe in seconds 0..TF+1200
  i := 0;
  j := TF+1200;
  XSamm := (GetMaxX-100)/j;
  X := 50;
  Y := round((YA)-(R^.temp*YSamm/k)-YComp);
  // timestamp in seconds
  l := BHSec-600;
  // beginning of first day in seconds
  TLP := BHSec;
  // frame for draw timeline
  h := round(TF/6);

  While i<j Do
    Begin
      If (l = TLP) Or (l = CTTS) Then
        Begin
          xp := round(50+Xsamm*i);
        End;
      If l = TLP Then
        Begin
          SetColor(white);
          SetLineStyle(Dashedln, 0, 1);
          MoveTo(xp,round(YA));
          LineTo(xp,round(YL));
          if R<>nil then
          dt:=R^.date
          else
          dt:= TimeStampToDateTime(CTT);

          if CTT.time = 0 then
            OutTextXY(xp-35, round(YA+10), FormatDateTime('DD.MM hh:nn', dt))
          else
          OutTextXY(xp-15, round(YA+10), FormatDateTime('hh:nn', dt));
          TLP := TLP+h;
        End;
      If l = CTTS Then
        Begin
          SetColor(Varv);
          SetLineStyle(Solidln, 0, 1);
          WriteLn('Punktid: ',X,', ',Y, ' ', R^.datestr ,' ', R^.temp:0:2);
          //move to prev X point
          MoveTo(X,Y);
          // Compute new X
          X := xp;
          Y := round((YA)-(R^.temp*YSamm/k)-YComp);
          If o>0 Then LineTo(X,Y);
          o := o+1;
          //o punkti aeg sekundites
          if o<andmed.len then
            begin
          R := @andmed.data[o];
          CTT := DateTimeToTimeStamp(R^.date);
          CTTS := CTT.Date*24*3600+longint(round(CTT.Time/1000));
            end
          else
          begin
               R := nil;
               CTT.Time:=0;
               CTT.Date:=CTT.Date+1;
          end;
        End;
      i := i+60;
      l := l+60;
    End;




{
  i := 0;
  j := andmed.len;
  While i < j Do
    Begin
      R := andmed.data[i];
      CTT := DateTimeToTimeStamp(R.date);
      Y := round((YA)-(R.temp*YSamm/k)-YComp);
      WriteLn('Punktid: ',X,', ',Y, ' ', R.datestr ,' ', R.temp:0:2);
      //Circle(X,Y, 1);
      If i>0 Then LineTo(X,Y);
      MoveTo(X,Y);
      X := X+XSamm;
      i := i+1;
    End;
    }
  ReadLn;
  CloseGraph;
  Joonista := 0;
End;
End.
