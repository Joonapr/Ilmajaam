

Program Ilmajaam;
{$mode objFPC}

Uses Lugemine, Graafika;

Var
  i: integer;
  c: Andmejada;
  failinimi: String = '';

Begin

  writeLn('Programm k2ivitatakse asukohast: ',paramStr(0));

  For i := 1 To paramCount() Do
    Begin
      writeLn(i:2, '. argument: ', paramStr(i));
    End;

  If paramCount()>0 Then
    Begin
      failinimi := paramStr(1);
    End;
  c := Loe(failinimi);
  Joonista(c);

End.
