// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: StrConv change string case (lowercase, uppercase or propercase) with this function
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 StrConv: Returns a String converted as specified in the
          Parameters Section.

 Parameters:
      String     = String expression to be converted.
      Conversion = Number specifying the type of conversion
                   to perform.
                   1 = TO UPPER CASE
                   2 = to lower case
                   3 = To Proper Case
                   If Conversion is null or not specified 1
                   is set as default.

 Returns: String
---------------------------------------------------------------- */
function StrConv(String, Conversion)
{
        var index;
        var tmpStr;
        var tmpChar;
        var preString;
        var postString;
        var strlen;

        if (Conversion == null || Conversion.length == 0)
                Conversion = '1';

        if (Conversion != '1' && Conversion != '2' && Conversion != '3')
                Conversion = '1';

        if (Conversion == '1')
                return String.toUpperCase();

        if (Conversion == '2')
                return String.toLowerCase();

        //Proper Case
        tmpStr = String.toLowerCase();
        strLen = tmpStr.length;
        if (strLen > 0)
        {
                for (index = 0; index < strLen; index++)
                {
                        if (index == 0)
                        {
                                tmpChar = tmpStr.substring(0, 1).toUpperCase();
                                postString = tmpStr.substring(1, strLen);
                                tmpStr = tmpChar + postString;
                        }
                        else
                        {
                                tmpChar = tmpStr.substring(index, index + 1);
                                if (tmpChar == " " && index < (strLen - 1))
                                {
                                        tmpChar = tmpStr.substring(index + 1, index + 2).toUpperCase();
                                        preString = tmpStr.substring(0, index + 1);
                                        postString = tmpStr.substring(index + 2,strLen);
                                        tmpStr = preString + tmpChar + postString;
                                }
                        }
                }
        }
        return tmpStr;
}
