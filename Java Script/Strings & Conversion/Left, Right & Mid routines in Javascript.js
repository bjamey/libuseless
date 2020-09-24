// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Left, Right & Mid routines in Javascript
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 Left: Returns a String containing a specified number of
       characters from the left side of a string.

 Parameters:
      String = String expression from which the leftmost
               characters are returned. If string contains null,
               false is returned.
      Length = Numeric expression indicating how many characters
               to return. If 0, a zero-length string ("") is
               returned. If greater than or equal to the number
               of characters in string, the entire string is
               returned.

 Returns: String
---------------------------------------------------------------- */
function Left(String, Length)
{
        if (String == null)
                return (false);

        return String.substr(0, Length);
}

/* ----------------------------------------------------------------
 Right: Returns a String containing a specified number of
        characters from the right side of a string.

 Parameters:
      String = String expression from which the leftmost
               characters are returned. If string contains null,
               false is returned.
      Length = Numeric expression indicating how many characters
               to return. If 0, a zero-length string ("") is
               returned. If greater than or equal to the number
               of characters in string, the entire string is
               returned.

 Returns: String
---------------------------------------------------------------- */
function Right(String, Length)
{
        if (String == null)
                return (false);

    var dest = '';
    for (var i = (String.length - 1); i >= 0; i--)
                dest = dest + String.charAt(i);

        String = dest;
        String = String.substr(0, Length);
        dest = '';

    for (var i = (String.length - 1); i >= 0; i--)
                dest = dest + String.charAt(i);

        return dest;
}

/* ----------------------------------------------------------------
 Mid: Returns a String containing a specified number of
      characters from a string

 Parameters:
      String = String expression from which characters are
               returned. If string contains null, false is
               returned.
      Start  = Number. Character position in string at which
               the part to be taken begins. If Start is
               greater than the number of characters in
               string, Mid returns a zero-length string ("").
      Length = Number of characters to return. If omitted
               false is returned.

 Returns: String
---------------------------------------------------------------- */
function Mid(String, Start, Length)
{
        if (String == null)
                return (false);

        if (Start > String.length)
                return '';

        if (Length == null || Length.length == 0)
                return (false);

        return String.substr((Start - 1), Length);
}
