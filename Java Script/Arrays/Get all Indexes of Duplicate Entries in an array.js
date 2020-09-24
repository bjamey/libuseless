// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get all Indexes of Duplicate Entries in an array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Get all Indexes of Duplicate Entries in an array
  --
  Returns true if the passed value is found in the
  array. Returns false if it is not.
-->

Array.prototype.collectDuplicateIndices = function (value)
{
   var i;
   var dupesStr = "";
   for (i = 0; i < this.length; i++)
   {
       // use === to check for Matches. ie., identical (===), ;
       if (this[i] == value)
       {
           dupesStr += i+",";
       }
   }

   return (dupesStr>“”)?dupesStr:”null”;
};

<!--
   This will return all the index/positions of the duplicate
   entries in an Array as a string seperated with commas.
-->
