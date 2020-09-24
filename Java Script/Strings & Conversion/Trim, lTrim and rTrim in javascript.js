// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Trim, lTrim and rTrim in javascript
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Trim the space in the left side of the string
function ltrim(s)
{
  return s.replace( /^s*/, “” );
}

// Trim the space in the right side of the string
function rtrim(s)
{
   return s.replace( /s*$/, “” );
}

// Trim the space in the string
function trim(s)
{
   var temp = s;
   return temp.replace(/^s+/,‘’).replace(/s+$/,‘’);
}   
