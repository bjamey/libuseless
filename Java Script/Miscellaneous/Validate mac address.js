// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Validate mac address
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Validate mac address


function fnValidateMacAddress(macaddr)
{
   var reg1 = /^[A-Fa-f0-9]{1,2}\-[A-Fa-f0-9]{1,2}\-[A-Fa-f0-9]{1,2}\-[A-Fa-f0-9]{1,2}\-[A-Fa-f0-9]{1,2}\-[A-Fa-f0-9]{1,2}$/;
   var reg2 = /^[A-Fa-f0-9]{1,2}\:[A-Fa-f0-9]{1,2}\:[A-Fa-f0-9]{1,2}\:[A-Fa-f0-9]{1,2}\:[A-Fa-f0-9]{1,2}\:[A-Fa-f0-9]{1,2}$/;

   if (reg1.test(macaddr)) {
      return true;
   } else if (reg2.test(macaddr)) {
      return true;
   } else {
      return false;
   }
}
