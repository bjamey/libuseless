// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get, Clear, Set and Enable bit operations for pascal
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// ---------------------------------------------------------- //
function GetBit(const Value: DWord; const Bit: Byte): Boolean;
begin
     Result := (Value and (1 shl Bit)) <> 0;
end;
// ---------------------------------------------------------- //
function ClearBit(const Value: DWord; const Bit: Byte): DWord;
begin
     Result := Value and not (1 shl Bit);
end;
// ---------------------------------------------------------- //
function SetBit(const Value: DWord; const Bit: Byte): DWord;
begin
     Result := Value or (1 shl Bit);
end;
// ---------------------------------------------------------- //
function EnableBit(const Value: DWord; const Bit: Byte; const TurnOn: Boolean): DWord;
begin
     Result := (Value or (1 shl Bit)) xor (Integer(not TurnOn) shl Bit);
end;
