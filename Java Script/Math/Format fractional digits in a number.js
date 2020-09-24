// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Format fractional digits in a number
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/*
  You can use the same above function to get only the
  integer part as below

  (12.3456789).toFixed(0);

  this will give the result 12
*/

Number.prototype.toFixed = function(fractionDigits)
{
   var m = Math.pow(10, fractionDigits);
   return Math.round(this * m, 0) / m;
}
