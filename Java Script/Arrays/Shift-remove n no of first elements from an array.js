// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Shift-remove n no of first elements from an array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Shift/remove n no of first elements from an array

function shiftElts(Obj, elts)
{
  for( var i = 0;  i<elts; i++ )
  {
     Obj.shift();
  }
};                
