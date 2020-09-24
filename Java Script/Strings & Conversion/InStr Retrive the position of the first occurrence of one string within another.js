// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: InStr Retrive the position of the first occurrence of one string
//        within another
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 InStr: Returns a Long specifying the position of the first
        occurrence of one string within another. Is String1
        or String2 are null, false is returned.

 Parameters:
      String1 = String expression being searched.
      String2 = String expression sought

 Returns: Integer
---------------------------------------------------------------- */
function InStr(String1, String2)
{
        var a = 0;

        if (String1 == null || String2 == null)
                return (false);

        String1 = String1.toLowerCase();
        String2 = String2.toLowerCase();

        a = String1.indexOf(String2);
        if (a == -1)
                return 0;
        else
                return a + 1;
}
