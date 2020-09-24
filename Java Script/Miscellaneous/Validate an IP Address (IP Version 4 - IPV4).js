// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Validate an IP Address (IP Version 4 - IPV4)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Validate an IP Address (IP Version 4 - IPV4)

function fnValidateIPAddress(ipaddr)
{
   var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/;
   if (re.test(ipaddr))
   {
      //split into units with dots "."
      var parts = ipaddr.split(".");

      //if the first unit is zero
      if (parseInt(parseFloat(parts[0])) == 0)
      {
         return false;
      }

      if (parseInt(parseFloat(parts[3])) == 0)
      {
         return false;
      }

      // if any part is greater than 255
      for (var i=0; i<parts.length; i++)
      {
         if (parseInt(parseFloat(parts[i])) > 254)
         {
                 return false;
         }
      }

      return true;
   } else
   {
      return false;
   }
}                                  
