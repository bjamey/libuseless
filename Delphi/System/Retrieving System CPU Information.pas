// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Retrieving System CPU Information
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

(* -----------------------------------------------
   Retrieve various informations about the CPU
   like: brand id, factory speed, which instruction
   set supported etc.

   Author: Leslie Tailor
----------------------------------------------- *)

unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tfrm_main = class(TForm)
    img_info: TImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure info(s1, s2: string);
  end;

var
  frm_main: Tfrm_main;
  gn_speed_y: Integer;
  gn_text_y: Integer;
const
  gn_speed_x: Integer = 8;
  gn_text_x: Integer  = 15;
  gl_start: Boolean   = True;

implementation

{$R *.DFM}

procedure Tfrm_main.FormShow(Sender: TObject);
var
  _eax, _ebx, _ecx, _edx: Longword;
  i: Integer;
  b: Byte;
  b1: Word;
  s, s1, s2, s3, s_all: string;
begin
  //Set the startup colour of the image
  img_info.Canvas.Brush.Color := clblue;
  img_info.Canvas.FillRect(rect(0, 0, img_info.Width, img_info.Height));


  gn_text_y := 5; //position of the 1st text

  asm                //asm call to the CPUID inst.
    mov eax,0         //sub. func call
    db $0F,$A2         //db $0F,$A2 = CPUID instruction
    mov _ebx,ebx
    mov _ecx,ecx
    mov _edx,edx
  end;

  for i := 0 to 3 do   //extract vendor id
  begin
    b := lo(_ebx);
    s := s + chr(b);
    b := lo(_ecx);
    s1:= s1 + chr(b);
    b := lo(_edx);
    s2:= s2 + chr(b);
    _ebx := _ebx shr 8;
    _ecx := _ecx shr 8;
    _edx := _edx shr 8;
  end;
  info('CPU', '');
  info('   - ' + 'Vendor ID: ', s + s2 + s1);

  asm
    mov eax,1
    db $0F,$A2
    mov _eax,eax
    mov _ebx,ebx
    mov _ecx,ecx
    mov _edx,edx
  end;
  //06B1
  //|0000| |0000 0000| |0000| |00| |00| |0110| |1011| |0001|
  b := lo(_eax) and 15;
  info('   - ' + 'Stepping ID: ', IntToStr(b));
  b := lo(_eax) shr 4;
  info('   - ' + 'Model Number: ', IntToHex(b, 1));
  b := hi(_eax) and 15;
  info('   - ' + 'Family Code: ', IntToStr(b));
  b := hi(_eax) shr 4;
  info('   - ' + 'Processor Type: ', IntToStr(b));
  //31.   28. 27.   24. 23.   20. 19.   16.
  //  0 0 0 0   0 0 0 0   0 0 0 0   0 0 0 0
  b := lo((_eax shr 16)) and 15;
  info('   - ' + 'Extended Model: ', IntToStr(b));

  b := lo((_eax shr 20));
  info('   - ' + 'Extended Family: ', IntToStr(b));

  b := lo(_ebx);
  info('   - ' + 'Brand ID: ', IntToStr(b));
  b := hi(_ebx);
  info('   - ' + 'Chunks: ', IntToStr(b));
  b := lo(_ebx shr 16);
  info('   - ' + 'Count: ', IntToStr(b));
  b := hi(_ebx shr 16);
  info('   - ' + 'APIC ID: ', IntToStr(b));

  //Bit 18 =? 1     //is serial number enabled?
  if (_edx and $40000) = $40000 then
    info('   - ' + 'Serial Number ', 'Enabled')
  else
    info('   - ' + 'Serial Number ', 'Disabled');

  s := IntToHex(_eax, 8);
  asm                  //determine the serial number
    mov eax,3
    db $0F,$A2
    mov _ecx,ecx
    mov _edx,edx
  end;
  s1 := IntToHex(_edx, 8);
  s2 := IntToHex(_ecx, 8);
  Insert('-', s, 5);
  Insert('-', s1, 5);
  Insert('-', s2, 5);
  info('   - ' + 'Serial Number: ', s + '-' + s1 + '-' + s2);

  asm
    mov eax,1
    db $0F,$A2
    mov _edx,edx
  end;
  info('', '');
  //Bit 23 =? 1
  if (_edx and $800000) = $800000 then
    info('MMX ', 'Supported')
  else
    info('MMX ', 'Not Supported');

  //Bit 24 =? 1
  if (_edx and $01000000) = $01000000 then
    info('FXSAVE & FXRSTOR Instructions ', 'Supported')
  else
    info('FXSAVE & FXRSTOR Instructions Not ', 'Supported');

  //Bit 25 =? 1
  if (_edx and $02000000) = $02000000 then
    info('SSE ', 'Supported')
  else
    info('SSE ', 'Not Supported');

  //Bit 26 =? 1
  if (_edx and $04000000) = $04000000 then
    info('SSE2 ', 'Supported')
  else
    info('SSE2 ', 'Not Supported');

  info('', '');

  asm     //execute the extended CPUID inst.
    mov eax,$80000000   //sub. func call
    db $0F,$A2
    mov _eax,eax
  end;

  if _eax > $80000000 then  //any other sub. funct avail. ?
  begin
    info('Extended CPUID: ', 'Supported');
    info('   - Largest Function Supported: ', IntToStr(_eax - $80000000));
    asm     //get brand ID
      mov eax,$80000002
      db $0F
      db $A2
      mov _eax,eax
      mov _ebx,ebx
      mov _ecx,ecx
      mov _edx,edx
    end;
    s  := '';
    s1 := '';
    s2 := '';
    s3 := '';
    for i := 0 to 3 do
    begin
      b := lo(_eax);
      s3:= s3 + chr(b);
      b := lo(_ebx);
      s := s + chr(b);
      b := lo(_ecx);
      s1 := s1 + chr(b);
      b := lo(_edx);
      s2 := s2 + chr(b);
      _eax := _eax shr 8;
      _ebx := _ebx shr 8;
      _ecx := _ecx shr 8;
      _edx := _edx shr 8;
    end;

    s_all := s3 + s + s1 + s2;

    asm
      mov eax,$80000003
      db $0F
      db $A2
      mov _eax,eax
      mov _ebx,ebx
      mov _ecx,ecx
    mov _edx,edx
    end;
    s  := '';
    s1 := '';
    s2 := '';
    s3 := '';
    for i := 0 to 3 do
    begin
      b := lo(_eax);
      s3 := s3 + chr(b);
      b := lo(_ebx);
      s := s + chr(b);
      b := lo(_ecx);
      s1 := s1 + chr(b);
      b := lo(_edx);
      s2 := s2 + chr(b);
      _eax := _eax shr 8;
      _ebx := _ebx shr 8;
      _ecx := _ecx shr 8;
      _edx := _edx shr 8;
    end;
    s_all := s_all + s3 + s + s1 + s2;

    asm
      mov eax,$80000004
      db $0F
      db $A2
      mov _eax,eax
      mov _ebx,ebx
      mov _ecx,ecx
      mov _edx,edx
    end;
    s  := '';
    s1 := '';
    s2 := '';
    s3 := '';
    for i := 0 to 3 do
    begin
      b  := lo(_eax);
      s3 := s3 + chr(b);
      b := lo(_ebx);
      s := s + chr(b);
      b := lo(_ecx);
      s1 := s1 + chr(b);
      b  := lo(_edx);
      s2 := s2 + chr(b);
      _eax := _eax shr 8;
      _ebx := _ebx shr 8;
      _ecx := _ecx shr 8;
      _edx := _edx shr 8;
    end;
    info('Brand String: ', '');
    if s2[Length(s2)] = #0 then setlength(s2, Length(s2) - 1);
    info('', '   - ' + s_all + s3 + s + s1 + s2);
  end
  else
    info('   - Extended CPUID ', 'Not Supported.');
end;

procedure Tfrm_main.info(s1, s2: string);
begin
  if s1 <> '' then
  begin
    img_info.Canvas.Brush.Color := clblue;
    img_info.Canvas.Font.Color  := clyellow;
    img_info.Canvas.TextOut(gn_text_x, gn_text_y, s1);
  end;
  if s2 <> '' then
  begin
    img_info.Canvas.Brush.Color := clblue;
    img_info.Canvas.Font.Color  := clWhite;
    img_info.Canvas.TextOut(gn_text_x + img_info.Canvas.TextWidth(s1), gn_text_y, s2);
  end;
  Inc(gn_text_y, 13);
end;

end.
