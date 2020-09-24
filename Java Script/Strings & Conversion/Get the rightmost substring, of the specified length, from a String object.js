// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get the rightmost substring, of the specified length, from a String object
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
   Get the rightmost substring, of the specified length,
   from a String object.
-->

String.prototype.right = function (length_)
{
        var _from = this.length - length_;
        if (_from < 0) _from = 0;
        return this.substring(this.length - length_, this.length);
};
