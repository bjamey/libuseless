// ----------------------------------------------------------------------------
//                                      DTT 2.2.1.1  (c)2009 FSL - FreeSoftLand
// Title: Allow only a single program instance
//
// Date : 26/09/2009
// By   : FSL
// ----------------------------------------------------------------------------

using System.Diagnostics;

...
    // Return false if other program instance present
    foreach (Process process in Process.GetProcesses())
    {
        if (process.MainWindowTitle == this.Text)
            return false;
    }
