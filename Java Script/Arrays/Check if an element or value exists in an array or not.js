// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check if an element or value exists in an array or not
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
    This function will Check if an element or value exists in an
    array or not.
    And return true if the passed value is found in the array.
    Returns false if it is not found in the array.

    --------
    Note :
    --------
    If you don’t want to perform case sensitive check, then set
    caseSensitve=true and call the function.
-->

Array.prototype.inArray = function (value,caseSensitive)
// Returns true if the passed value is found in the
// array. Returns false if it is not.
{
   var i;
   for (i = 0; i < this.length; i++)
   {
        // use === to check for Matches. ie., identical (===),
        if (caseSensitive)
        {
           // performs match even the string is case sensitive
           if (this[i].toLowerCase() == value.toLowerCase())
           {
               return true;
           }
        } else {
           if (this[i] == value)
           {
               return true;
           }
        }
   }

   return false;
};
