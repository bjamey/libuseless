// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check for Duplicates in an array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Note: Idx is the Value of the Column You want to
  check for duplicates
-->

// ----------------------------
// For Single Dimensional Array
// ----------------------------
Array.prototype.chkforDuplicates = function (value)
{
    // Returns true if the passed value is found in the
    // array. Returns false if it is not.

    var i;
    var ctr = 0;

    for (i=0; i < this.length; i++)
    {
        // use === to check for Matches. ie., identical (===), ;
        if (this[i] == value)
        {
            return true;
        }
    }

    return false;
};

// ---------------------------
// For Multi Dimensional Array
// ---------------------------
Array.prototype.chkforDuplicates = function (value,Idx)
{
    // Returns true if the passed value is found in the
    // array. Returns false if it is not.

    var i;
    var ctr = 0;

    for (i = 0; i < this.length; i++)
    {
       // use === to check for Matches. ie., identical (===), ;
       if (this[i][Idx] == value)
       {
           return true;
       }
    }

    return false;
};
