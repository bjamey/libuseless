// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Ascii to char & vis versa
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 Chr: Returns a String containing the character associated
      with the specified character code.

 Parameters:
      CharCode = Long that identifies a character.

 Returns: String
---------------------------------------------------------------- */
function Chr(CharCode)
{
        return String.fromCharCode(CharCode);
}

/* ----------------------------------------------------------------
 Asc: Returns an Integer representing the character code
      corresponding to the first letter in a string

 Parameters:
      String = The required string argument is any valid
               string expression. If the string if not in
               the range 32-126, the function return ZERO

 Returns: Integer
---------------------------------------------------------------- */
function Asc(string)
{
        var symbols = " !\"#$%&'()*+'-./0123456789:;<=>?@";
        var loAZ = "abcdefghijklmnopqrstuvwxyz";
        symbols += loAZ.toUpperCase();
        symbols += "[\\]^_`";
        symbols += loAZ;
        symbols += "{|}~";
        var loc;
        loc = symbols.indexOf(string);
        if (loc > -1)
        {
                Ascii_Decimal = 32 + loc;
                return (32 + loc);
        }                                                               
        return (0);
}
