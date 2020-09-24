// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Check If an variable is an array or not in javascript
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  This js function will check if a variable / Object is an
  array or not and returns true or false
--> 

// check if an object is an array or not.
function isArray(obj)
{
       // returns true is it is an array
       return (obj.constructor.toString().indexOf(”Array”) != -1);
}
