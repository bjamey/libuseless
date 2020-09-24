// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Format percent
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 FormatPercent: Returns an expression formatted as a
                percentage (multipled by 100) with a
                trailing % character

 Parameters:
      Expression = Expression to be formatted.

 Returns: String
---------------------------------------------------------------- */
function FormatPercent(Expression, NumDigitsAfterDecimal)
{
        var iNumDecimals = NumDigitsAfterDecimal;
        var dbInVal = Expression * 100;
        var bNegative = false;
        var iInVal = 0;
        var strInVal
        var strWhole = "", strDec = "";
        var strTemp = "", strOut = "";
        var iLen = 0;

        if (dbInVal < 0)
        {
                bNegative = true;
                dbInVal *= -1;
        }

        dbInVal = dbInVal * Math.pow(10, iNumDecimals)
        iInVal = parseInt(dbInVal);
        if ((dbInVal - iInVal) >= .5)
        {
                iInVal++;
        }
        strInVal = iInVal + "";
        strWhole = strInVal.substring(0, (strInVal.length - iNumDecimals));
        strDec = strInVal.substring((strInVal.length - iNumDecimals), strInVal.length);
        while (strDec.length < iNumDecimals)
        {
                strDec = "0" + strDec;
        }
        iLen = strWhole.length;
        if (iLen >= 3)
        {
                while (iLen > 0)
                {
                        strTemp = strWhole.substring(iLen - 3, iLen);
                        if (strTemp.length == 3)
                        {
                                strOut = "," + strTemp + strOut;
                                iLen -= 3;
                        }
                        else
                        {
                                strOut = strTemp + strOut;
                                iLen = 0;
                        }
                }
                if (strOut.substring(0, 1) == ",")
                {
                        strWhole = strOut.substring(1, strOut.length);
                }
                else
                {
                        strWhole = strOut;
                }
        }
        if (bNegative)
        {
                return "-" + strWhole + "." + strDec + "%";
        }
        else
        {
                return strWhole + "." + strDec + "%";
        }
}
