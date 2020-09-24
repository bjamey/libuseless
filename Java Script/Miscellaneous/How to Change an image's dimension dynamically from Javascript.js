// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Change an image’s dimension dynamically from Javascript
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  How to Change an image’s width dynamically from Javascript.
  Using DOM we can do this.
-->

function changeImgSize(objectId, newWidth, newHeight)
{
    imgString = 'theImg = document.getElementById("'+objectId+'")';
    eval(imgString);
    oldWidth = theImg.width;
    oldHeight = theImg.height;

    if (newWidth > 0)
    {
       theImg.width = newWidth;
    }

    if (newHeight > 0)
    {
       theImg.height = newHeight;
    }
}
