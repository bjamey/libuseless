// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Find Patterns in String based Arrays
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Text.RegularExpressions;

namespace DevDistrict.Text.Utilities
{
        ///
        /// Locates a pattern in an array and returns the array index of the first match in the array
        ///
        public class StringArrayLocator
        {
                private string[] _array;

                public StringArrayLocator(string[] arr)
                {
                        _array = arr;
                }

                public int Locate(string pattern)
                {
                        for(int i=0;i<=_array.GetUpperBound(0);i++)
                        {
                                if(Regex.IsMatch(_array[i],pattern,RegexOptions.IgnoreCase))
                                {
                                        return i;
                                }
                        }

                        return -1;
                }
        }
}
