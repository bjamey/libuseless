// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Find Left and Right position of an Object
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  When a layer is inside another layer, it’s style.left and
  style.top positions can both be ‘0'

  but the layer itself can be 500 pixels away from the actual
  margin. These functions will return the true offset.
--> 

// To find the left position, add this snippet to your code:

function getPositionLeft(This)
{
     var el = This;var pL = 0;
     while(el)
     {
           pL += el.offsetLeft;
           el = el.offsetParent;
     }

     return pL
}

// To find the top position, add this snippet to your code:
function getPositionTop(This)
{
     var el = This;var pT = 0;
     while(el)
     {
        pT += el.offsetTop;
        el = el.offsetParent;
     }

     return pT
}
