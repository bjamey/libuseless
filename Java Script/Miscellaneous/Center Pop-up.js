// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Center Pop-up
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

function Center(url)
{
   var w = 250; // set the width of pop-up
   var h = 250; // set the height of pop-up

   var l = Math.floor((screen.width-w)/2);
   var t = Math.floor((screen.height-h)/2);
   window.open(url,"pop","width=" + w + ",height=" + h + ",top=" + t + ",left=" + l);
}                         
