// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Control + Click action in javascript
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Control+click action in javascript

  Gives you control to perform actions when the control key and
  the mouse button is clicked in the same time. Something similar
  to selecting elements in Windows with ctrl+click.

  Just change the event.ctrlKey to event.shiftKey to make it
  shift+click. If you don't get it don't worry the snippet contains
  the demo for shift+click too.

  You may need to change the event.which though 1 = left click,
  2 = middle click, 3 = right click(at least in firefox 1.5.0.5)
-->

document.onmousedown = function(event){
     if (event.ctrlKey && event.which == 1) {
         alert('ctrl-clicked');
     }

     if (event.shiftKey && event.which == 1) {
        alert('shift-clicked');
     }
}
