// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Remove control character from a string
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Remove control character from a string

function removeNL(s)
{
     // NewLine, CarriageReturn and Tab characters from a String
     // will be removed and will return the new string

     r = "";
     for (i = 0; i < s.length; i++)
     {
         if (s.charAt(i) != '\n' & s.charAt(i) != '\r' & s.charAt(i) != '\t') {
             r += s.charAt(i);
         }
     }

     return r;
}
