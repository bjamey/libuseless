// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Download webpage from URL and print to console
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Net;
using System.Text;
using System.IO;

namespace Test {

   class GetWebPage {
      public static void Main(string[] args) {
         for(int i=0;i<args.Length;i++) {
            HttpWebRequest httpWebRequest =
               (HttpWebRequest)WebRequest.Create(args[i]);

            HttpWebResponse httpWebResponse =
                    (HttpWebResponse)httpWebRequest.GetResponse();

            Stream stream = httpWebResponse.GetResponseStream();

            StreamReader streamReader =
               new StreamReader(stream, Encoding.ASCII);
            Console.WriteLine(streamReader.ReadToEnd());
         }

         Console.Read();
      }
   }

}
