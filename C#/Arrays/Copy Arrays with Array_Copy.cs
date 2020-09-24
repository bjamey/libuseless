// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Copy Arrays with Array·Copy
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;

public class CopyArray {

   public static void Main() {
      int[]    integers = new int[] {5, 10, 15};
      double[] doubles  = new double[3];
      Array.Copy (integers, doubles, 2);
      Console.Write ("integers array elements:" );
      foreach (int integer in integers) {
        Console.Write("{0,3}", integer);
        }
      Console.Write ("\ndoubles  array elements:" );
      foreach (double duble in doubles) {
        Console.Write ("{0,3}", duble);
        }
      Console.WriteLine();
      }
   }                      
