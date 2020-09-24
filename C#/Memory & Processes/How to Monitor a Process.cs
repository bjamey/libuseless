// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Monitor a Process
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System;
using System.Windows.Forms;

namespace DevDistrict.MachineMonitor
{
        public class Monitor
        {
                [STAThread()]
                public static void Main()
                {
                        System.Diagnostics.Process[] p = System.Diagnostics.Process.GetProcessesByName("Notepad");

                        if (p.Length<0)
                        {
                                Console.WriteLine("No process");
                                return;
                        }

                        if (p[0].HasExited)
                        {
                                Console.WriteLine("Process Exited");
                                return;
                        }

                        p[0].Exited+=new EventHandler(Startup_Exited);

                        while(!p[0].HasExited)
                        {
                                p[0].WaitForExit(30000);

                                Console.WriteLine("checking process health");
                        }
                }

                private static void Startup_Exited(object sender, EventArgs e)
                {
                        Console.WriteLine("PROCESS EXIT CAUGHT");
                }
        }
}
