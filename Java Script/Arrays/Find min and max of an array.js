// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Find min and max of an array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Find min and max of an array

// Max
Array.prototype.max = function() {
        return Math.max.apply({}, this)
}

// Min
Array.prototype.min = function(){
        return Math.min.apply({}, this)
}
