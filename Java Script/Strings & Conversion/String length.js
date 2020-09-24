// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: String length
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 Len: Returns a Long containing the number of characters in a
      string or the number of bytes required to store a
      variable.

 Parameters:
      string = Any valid string expression. If string contains
               null, false is returned.

 Returns: Long
---------------------------------------------------------------- */
function Len(string)
{
        if (string == null)
                return (false);

        return String(string).length;
}
