
Unit Lugemine;

Interface

Type 
  kjt = Record
    datestr   : packed array [1..20] Of char;
    date      : TDateTime;
    temp      : Single;
    wind      : Single;
  End;
  ajt = Record
    data: array Of kjt;
    len: Integer;
  End;
  Andmejada = ajt;
  PAndmejada = ^Andmejada;
Function Loe(Const fail:String): Andmejada;

Implementation

Uses CRT, sysutils, classes, strutils;

Const 
  RekordiditeFail = 'ARC-2021-01-24.txt';

Function sisendFail(sf:String): String;

Var 
  Sisend : String = '';
Begin

  If sf <> '' Then
    Begin
      If FileExists(sf) Then Sisend := sf
      Else WriteLn('Faili ei leitud: ', sf);
    End;
  If sisend = '' Then
    Begin
      WriteLn('Vaikimisi: ', RekordiditeFail);
      Repeat
        Write (DateTimeToStr(now), '> Faili nimi: ');
        ReadLn(Sisend);
        WriteLn;
        If Sisend = ^C Then        // read the key pressed
          Begin
            writeln('Ctrl-C pressed, exit ...');
            halt;
          End;
        If Sisend = '' Then Sisend := RekordiditeFail;
        If Not FileExists(Sisend) Then WriteLn('Faili ei leitud: ', Sisend)
      Until FileExists(Sisend);
    End;
  WriteLn;
  sisendFail := Sisend;
End;

Function Loe(Const fail:String): Andmejada;

Var 
  C : Andmejada;
  Sisend, Rida, tmp      : String;
  andmed      : Text;
  i, Offset, P, j, err: Integer;
  B: kjt;
  fs: TFormatSettings;
  dt: TDateTime;
Begin
  fs := DefaultFormatSettings;
  fs.ShortDateFormat := 'YYYY-MM-DD';
  fs.LongTimeFormat := 'YYYY-MM-DD hh:nn:ss';
  fs.DateSeparator := '-';
  fs.TimeSeparator := ':';
  fs.DecimalSeparator := '.';
  WriteLn('Programm loeb andmekandjast kuup2eva, kellaaja ning');
  WriteLn('temepratuurin2itajad ja teeb andmetest graafiku.');

  Sisend := sisendFail(fail);

  Assign(andmed,Sisend);
  Reset(andmed);
  i := 0;
  j := 0;
  C.len := 0;

  While Not Eof(andmed) Do
    Begin
      ReadLn(andmed, Rida);
      //WriteLn('Rida ', i,' on ', Rida );
      If i>0 Then
        Begin
        { Rida := "20210124 00:00	-1.6		-2.3	90.0	3.6	5.8	95.0	995.3" }
          Offset := 1;
          P := PosEx(#9, Rida, Offset);
          //WriteLn(i, '1:Offset,P: ', Offset,',', P );
          If P>0 Then
            Begin
              B.datestr := Concat(COPY(Rida, Offset, 4) , '-', COPY(Rida, Offset
                           +4, 2
                           ), '-', COPY(Rida, Offset+6, P-7), ':00');
              B.date := strtodatetime(B.datestr,fs);
              Offset := P+1;
              P := PosEx(#9, Rida, Offset);
              If P>0 Then
                Begin
                  tmp := COPY(Rida,Offset,P-Offset);
                  val(tmp, B.temp, err);
                  B.temp := StrToFloat(tmp, fs);
                End;
            End;
          If j<=C.len Then
            Begin
              j := j+16;
              setLength(C.data, j);
            End;
          C.data[C.len] := B;
          C.len := C.len+1;
          //WriteLn('Rida ', i,' on {', B.datestr, ',',B.temp:0:2,'}');
        End;
      //If i>5 Then
      //  Break;
      i := i +1;
    End;
  Loe := C;
End;

End.
