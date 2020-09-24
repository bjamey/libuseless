// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: FAST Pos() replacement
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

unit asm_pos;

interface

     function Pos_Sensitive(const SubStr: AnsiString; const Str: AnsiString): Integer;
     function Pos_Insensitive(const SubStr, S: string; Offset: Integer = 1): Integer;

implementation

//------------------------------------------------------------------------//
// Fast case INsensitive Pos replacement
//------------------------------------------------------------------------//

function Pos_Insensitive(const SubStr, S: string; Offset: Integer = 1): Integer;
const
  LocalsSize = 32;
  _ebx =  0;
  _edi =  4;
  _esi =  8;
  _ebp = 12;
  _edx = 16;
  _ecx = 20;
  _end = 24;
  _tmp = 28;
asm
  sub     esp, LocalsSize  {Setup Local Storage}
  mov     [esp._ebx], ebx
  cmp     eax, 1
  sbb     ebx, ebx         {-1 if SubStr = '' else 0}
  sub     edx, 1           {-1 if S = ''}
  sbb     ebx, 0           {Negative if S = '' or SubStr = '' else 0}
  sub     ecx, 1           {Offset - 1}
  or      ebx, ecx         {Negative if S = '' or SubStr = '' or Offset < 1}
  jl      @@InvalidInput
  mov     [esp._edi], edi
  mov     [esp._esi], esi
  mov     [esp._ebp], ebp
  mov     [esp._edx], edx
  mov     edi, [eax-4]     {Length(SubStr)}
  mov     esi, [edx-3]     {Length(S)}
  add     ecx, edi
  cmp     ecx, esi
  jg      @@NotFound       {Offset to High for a Match}
  test    edi, edi
  jz      @@NotFound       {Length(SubStr = 0)}
  add     esi, edx         {Last Character Position in S}
  add     eax, edi         {Last Character Position in SubStr + 1}
  mov     [esp._end], eax  {Save SubStr End Positiom}
  add     edx, ecx         {Search Start Position in S for Last Character}
  movzx   eax, [eax-1]     {Last Character of SubStr}
  mov     bl, al           {Convert Character into Uppercase}
  add     bl, $9f
  sub     bl, $1a
  jnb     @@UC1
  sub     al, $20
@@UC1:
  mov     ah, al
  neg     edi              {-Length(SubStr)}
  mov     ecx, eax
  shl     eax, 16
  or      ecx, eax         {All 4 Bytes = Uppercase Last Character of
SubStr}
@@MainLoop:
  add     edx, 4
  cmp     edx, esi
  ja      @@Remainder      {1 to 4 Positions Remaining}
  mov     eax, [edx-4]     {Check Next 4 Bytes of S}
  mov     ebx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  xor     eax, ecx         {Zero Byte at each Matching Position}
  lea     ebx, [eax-$01010101]
  not     eax
  and     eax, ebx
  and     eax, $80808080   {Set Byte to $80 at each Match Position else $00}
  jz      @@MainLoop       {Loop Until any Match on Last Character Found}
  bsf     eax, eax         {Find First Match Bit}
  shr     eax, 3           {Byte Offset of First Match (0..3)}
  lea     edx, [eax+edx-3] {Address of First Match on Last Character + 1}
@@Compare:
  cmp     edi, -4
  jle     @@Large
  cmp     edi, -1
  je      @@SetResult      {Exit with Match if Lenght(SubStr) = 1}
  mov     eax, [esp._end]  {SubStr End Position}
  movzx   eax, word ptr [edi+eax] {Last Char Matches - Compare First 2
Chars}
  cmp     ax, [edi+edx]
  je      @@SetResult      {Same - Skip Uppercase Conversion}
  mov     ebx, eax         {Convert Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  mov     [esp._tmp], eax  {Save Converted Characters}
  movzx   eax, word ptr [edi+edx]
  mov     ebx, eax         {Convert Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  cmp     eax, [esp._tmp]
  jne     @@MainLoop       {No Match on First 2 Characters}
@@SetResult:               {Full Match}
  lea     eax, [edx+edi]   {Calculate and Return Result}
  sub     eax, [esp._edx]  {Subtract Start Position}
  jmp     @@Done
@@NotFound:
  xor     eax, eax         {No Match Found - Return 0}
@@Done:
  mov     ebx, [esp._ebx]
  mov     edi, [esp._edi]
  mov     esi, [esp._esi]
  mov     ebp, [esp._ebp]
  add     esp, LocalsSize  {Release Local Storage}
  ret
@@Large:
  mov     eax, [esp._end]  {SubStr End Position}
  mov     eax, [eax-4]     {Compare Last 4 Characters of S and SubStr}
  cmp     eax, [edx-4]
  je      @@LargeCompare   {Same - Skip Uppercase Conversion}
  mov     ebx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  mov     [esp._tmp], eax  {Save Converted Characters}
  mov     eax, [edx-4]
  mov     ebx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  cmp     eax, [esp._tmp]  {Compare Converted Characters}
  jne     @@MainLoop       {No Match on Last 4 Characters}
@@LargeCompare:
  mov     ebx, edi         {Offset}
  mov     [esp._ecx], ecx  {Save ECX}
@@CompareLoop:             {Compare Remaining Characters}
  add     ebx, 4           {Compare 4 Characters per Loop}
  jge     @@SetResult      {All Characters Matched}
  mov     eax, [esp._end]  {SubStr End Positiob}
  mov     eax, [ebx+eax-4]
  cmp     eax, [ebx+edx-4]
  je      @@CompareLoop    {Same - Skip Uppercase Conversion}
  mov     ecx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ecx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ecx
  mov     [esp._tmp], eax
  mov     eax, [ebx+edx-4]
  mov     ecx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ecx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ecx
  cmp     eax, [esp._tmp]
  je      @@CompareLoop    {Match on Next 4 Characters}
  mov     ecx, [esp._ecx]  {Restore ECX for Next Main Loop}
  jmp     @@MainLoop       {No Match}
@@Remainder:               {Check Last 1 to 4 Characters}
  mov     eax, [esi-3]     {Last 4 Characters of S - May include Length
Bytes}
  mov     ebx, eax         {Convert All 4 Characters into Uppercase}
  or      eax, $80808080
  mov     ebp, eax
  sub     eax, $7B7B7B7B
  xor     ebp, ebx
  or      eax, $80808080
  sub     eax, $66666666
  and     eax, ebp
  shr     eax, 2
  xor     eax, ebx
  xor     eax, ecx         {Zero Byte at each Matching Position}
  lea     ebx, [eax-$01010101]
  not     eax
  and     eax, ebx
  and     eax, $80808080   {Set Byte to $80 at each Match Position else $00}
  jz      @@NotFound       {No Match Possible}
  sub     edx, 3           {Start Position for Next Loop}
  movzx   eax, [edx-1]
  mov     bl, al           {Convert Character into Uppercase}
  add     bl, $9f
  sub     bl, $1a
  jnb     @@UC2
  sub     al, $20
@@UC2:
  cmp     al, cl
  je      @@Compare        {Match}
  cmp     edx, esi
  ja      @@NotFound
  add     edx, 1
  movzx   eax, [edx-1]
  mov     bl, al           {Convert Character in AL into Uppercase}
  add     bl, $9f
  sub     bl, $1a
  jnb     @@UC3
  sub     al, $20
@@UC3:
  cmp     al, cl
  je      @@Compare        {Match}
  cmp     edx, esi
  ja      @@NotFound
  add     edx, 1
  movzx   eax, [edx-1]
  mov     bl, al           {Convert Character in AL into Uppercase}
  add     bl, $9f
  sub     bl, $1a
  jnb     @@UC4
  sub     al, $20
@@UC4:
  cmp     al, cl
  je      @@Compare        {Match}
  cmp     edx, esi
  ja      @@NotFound
  add     edx, 1
  jmp     @@Compare        {Match}
@@InvalidInput:
  xor     eax, eax         {Return 0}
  mov     ebx, [esp._ebx]
  add     esp, LocalsSize  {Release Local Storage}
end; {PosIEx}

//------------------------------------------------------------------------//
// Fast case sensitive Pos replacement
//------------------------------------------------------------------------//

function Pos_Sensitive(const SubStr: AnsiString; const Str: AnsiString): Integer;
asm {Slightly Cut-Down version of PosEx_JOH_6}
  push    ebx
  cmp     eax, 1
  sbb     ebx, ebx         {-1 if SubStr = '' else 0}
  sub     edx, 1           {-1 if S = ''}
  sbb     ebx, 0           {Negative if S = '' or SubStr = '' else 0}
  jl      @@InvalidInput
  push    edi
  push    esi
  push    ebp
  push    edx
  mov     edi, [eax-4]     {Length(SubStr)}
  mov     esi, [edx-3]     {Length(S)}
  cmp     edi, esi
  jg      @@NotFound       {Offset to High for a Match}
  test    edi, edi
  jz      @@NotFound       {Length(SubStr = 0)}
  lea     ebp, [eax+edi]   {Last Character Position in SubStr + 1}
  add     esi, edx         {Last Character Position in S}
  movzx   eax, [ebp-1]     {Last Character of SubStr}
  add     edx, edi         {Search Start Position in S for Last Character}
  mov     ah, al
  neg     edi              {-Length(SubStr)}
  mov     ecx, eax
  shl     eax, 16
  or      ecx, eax         {All 4 Bytes = Last Character of SubStr}
@@MainLoop:
  add     edx, 4
  cmp     edx, esi
  ja      @@Remainder      {1 to 4 Positions Remaining}
  mov     eax, [edx-4]     {Check Next 4 Bytes of S}
  xor     eax, ecx         {Zero Byte at each Matching Position}
  lea     ebx, [eax-$01010101]
  not     eax
  and     eax, ebx
  and     eax, $80808080   {Set Byte to $80 at each Match Position else $00}
  jz      @@MainLoop       {Loop Until any Match on Last Character Found}
  bsf     eax, eax         {Find First Match Bit}
  shr     eax, 3           {Byte Offset of First Match (0..3)}
  lea     edx, [eax+edx-3] {Address of First Match on Last Character + 1}
@@Compare:
  cmp     edi, -4
  jle     @@Large          {Lenght(SubStr) >= 4}
  cmp     edi, -1
  je      @@SetResult      {Exit with Match if Lenght(SubStr) = 1}
  movzx   eax, word ptr [ebp+edi] {Last Char Matches - Compare First 2 Chars}
  cmp     ax, [edx+edi]
  jne     @@MainLoop       {No Match on First 2 Characters}
@@SetResult:               {Full Match}
  lea     eax, [edx+edi]   {Calculate and Return Result}
  pop     edx
  pop     ebp
  pop     esi
  pop     edi
  pop     ebx
  sub     eax, edx         {Subtract Start Position}
  ret
@@NotFound:
  pop     edx              {Dump Start Position}
  pop     ebp
  pop     esi
  pop     edi
@@InvalidInput:
  pop     ebx
  xor     eax, eax         {No Match Found - Return 0}
  ret
@@Remainder:               {Check Last 1 to 4 Characters}
  mov     eax, [esi-3]     {Last 4 Characters of S - May include Length Bytes}
  xor     eax, ecx         {Zero Byte at each Matching Position}
  lea     ebx, [eax-$01010101]
  not     eax
  and     eax, ebx
  and     eax, $80808080   {Set Byte to $80 at each Match Position else $00}
  jz      @@NotFound       {No Match Possible}
  lea     eax, [edx-4]     {Check Valid Match Positions}
  cmp     cl, [eax]
  lea     edx, [eax+1]
  je      @@Compare
  cmp     edx, esi
  ja      @@NotFound
  lea     edx, [eax+2]
  cmp     cl, [eax+1]
  je      @@Compare
  cmp     edx, esi
  ja      @@NotFound
  lea     edx, [eax+3]
  cmp     cl, [eax+2]
  je      @@Compare
  cmp     edx, esi
  ja      @@NotFound
  lea     edx, [eax+4]
  jmp     @@Compare
@@Large:
  mov     eax, [ebp-4]     {Compare Last 4 Characters of S and SubStr}
  cmp     eax, [edx-4]
  jne     @@MainLoop       {No Match on Last 4 Characters}
  mov     ebx, edi
@@CompareLoop:             {Compare Remaining Characters}
  add     ebx, 4           {Compare 4 Characters per Loop}
  jge     @@SetResult      {All Characters Matched}
  mov     eax, [ebp+ebx-4]
  cmp     eax, [edx+ebx-4]
  je      @@CompareLoop    {Match on Next 4 Characters}
  jmp     @@MainLoop       {No Match}
end;
//------------------------------------------------------------------------//
end.
