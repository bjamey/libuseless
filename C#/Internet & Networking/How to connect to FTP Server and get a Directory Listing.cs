// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to connect to FTP Server and get a Directory Listing
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            FtpWebRequest request = (FtpWebRequest)FtpWebRequest.Create("ftp://ftp.microsoft.com");

            //Set username and password for the FTP Server
            NetworkCredential c = new NetworkCredential("anonymous", "thisisme@hotmail.com");
            request.Credentials = c;

            //Set the command to get the directory listing. If you want to do something else
            //this is the place to look, the enumeration has many different operations.
            request.Method = WebRequestMethods.Ftp.ListDirectory;

            //Go go gadget!
            FtpWebResponse response = (FtpWebResponse)request.GetResponse();

            //Read the results and spit em at the console
            using (StreamReader reader = new StreamReader(response.GetResponseStream()))
            {
                string text = reader.ReadLine();

                while(text!=null)
                {
                    Console.WriteLine(text);
                    text = reader.ReadLine();
                }
            }
        }
    }
}
