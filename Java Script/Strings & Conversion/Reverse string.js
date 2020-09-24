// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Reverse string
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 ReverseString: Returns a string in which the character order
                of a specified string is reversed

 Parameters:
      Expression = The expression argument is the string whose
                   characters are to be reversed. If expression
                   is a zero-length string (""), a zero-length
                   string is returned. If expression is null,
                   false is returned.

 Returns: String
---------------------------------------------------------------- */
function ReverseString(Expression)
{
        if (Expression == null)
                return (false);

    var dest = '';
    for (var i = (Expression.length - 1); i >= 0; i--)
                dest = dest + Expression.charAt(i);
    return dest;
}
