// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check if a given date is valid
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 IsDate: Returns a Boolean (true) if the date is true, false
         is not

 Parameters:
        - DateStr: String date in format (MM/DD/YYYY)

 Returns: Boolean
---------------------------------------------------------------- */
function IsDate(dateStr)
{
        // Checks for the following valid date formats:
        // MM/DD/YYYY   MM-DD-YYYY

        var datePat = /^(\d{1,2})(\/|-)(\d{1,2})\2(\d{4})$/;

        var matchArray = dateStr.match(datePat)
        if (matchArray == null)
                return false

        month = matchArray[1]
        day = matchArray[3]
        year = matchArray[4]
        if (month < 1 || month > 12)
                return false

        if (day < 1 || day > 31)
                return false

        if ((month==4 || month==6 || month==9 || month==11) && day==31)
                return false

        if (month == 2)
        {
                var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))
                if (day>29 || (day==29 && !isleap))
                        return false;
        }
        return true;
}
