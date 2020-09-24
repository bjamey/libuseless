// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert ASCII to Binary
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

{* coded by Jason Myerscough
 * 19/11/02
 * uses parallel arrays
 * converts Ascii values to binary values
 * vote ma code}
program asciitobin;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

type
    BinValues = array[1..8] of integer;

const
     MAXBITS = 8;
     BinaryVals : BinValues = (128, 64, 32, 16, 8, 4, 2, 1);
var
   bits : array[1..MAXBITS] of integer;
   Ch : char;
   AsciiVal : integer;
   Again : char;
   ConHandle : THandle; {Holds the cnsoles handle}

procedure Ascii_To_Bin;
var
   i : integer;
   inner : integer;
   Total : integer;
begin
      ConHandle := GetStdHandle(STD_OUTPUT_HANDLE);
     {* set the bit values to 0 *}
     SetConsoleTextAttribute(ConHandle, FOREGROUND_GREEN);
     for i := 1 to MAXBITS do bits[i] := 0;

     {* prompt the user *}
     write('Please enter a chacter... ');
     readln(Ch);
     AsciiVal := Ord(Ch);
     Total := AsciiVal;
      {* now to sorrt the bits that dont add up to one of the
       * preset values *}

       for i := 1 to MAXBITS do
           begin
                for inner := 1 to MAXBITS do
                    begin
                         if AsciiVal >= BinaryVals[inner]
                            then
                                begin
                                     Dec(AsciiVal, BinaryVals[inner]);
                                     bits[inner] := 1;
                                end;{if}
                    end;{for}
           end;{for}

      {* print the results *}

      writeln('Character entered: ', ch);
      writeln('Ascii Value : ' , Total);
      write('Binary value: ');
      SetConsoleTextAttribute(ConHandle, RGB(100, 55, 120));
      for i := 1 to MAXBITS do write(bits[i], ' ');
end;{procedure}

begin
     repeat
           Ascii_To_Bin;
           writeln;
           writeln;
           write('Do you want to run the program again?.. ');
           readln(Again);
     until((Again = 'N') or (Again = 'n'));
end.{program}

