// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Find the Index-Position of an element in an array
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// How to Find the Index/Position of an element in an array

Array.prototype.findIndexByCol = function(value,cIdx) {

      var ctr = "";

      for (var i=0; i < this.length; i++)
      {
           // use === to check for Matches. ie., identical (===), ;
           if (this[i][cIdx] == value)
           {
               //alert(this[i][cIdx]+"===="+value);
               return i;
           }
      }

      return ctr;
};
