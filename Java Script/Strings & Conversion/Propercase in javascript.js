// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Propercase in javascript
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Propercase in javascript

String.prototype.toProperCase = function()
{
  return this.toLowerCase().replace(/^(.)|\s(.)/g, function($1) { return $1.toUpperCase(); });
}        
