// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Find and replace a string inside another string
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Find and replace a string inside another string
String.prototype.findandreplace = function (find, replace)
{
        var myString = this;
        var counter = 0;

        while (counter < myString.length)
        {
                var start = myString.indexOf(find, counter);
                if (start == -1)
                {
                        break;
                } else {
                        var before = myString.substr(0, start);
                        var after = myString.substr(start + find.length, myString.length);
                        myString = before + replace + after;
                        var counter = before.length + replace.length;
                }
        }

        return myString;
};
