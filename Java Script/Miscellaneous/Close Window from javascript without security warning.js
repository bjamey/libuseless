// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Close Window from javascript without security warning
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
    Set your link like this :

    <a href="javascript:closeWindow();">Close Window</a>
-->

function closeWindow()
{
     if (navigator.appName=="Microsoft Internet Explorer")
     {
         this.focus();
         self.opener = this;
         self.close();
     }
     else
     {
         window.open('', '_parent', '');
         window.close();
     }
}       
