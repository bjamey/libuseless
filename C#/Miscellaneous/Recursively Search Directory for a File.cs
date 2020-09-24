// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Recursively Search Directory for a File
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

System.Collections.ArrayList files = new System.Collections.ArrayList();
 DirSearch(@"C:",ref files);
//Method to Search Directory for specified file Type.Paste it outside the function
public void DirSearch(string sDir,ref System.Collections.ArrayList files)
{
         try
        {
           foreach (string d in System.IO.Directory.GetDirectories(sDir))
           {
                foreach (string f in System.IO.Directory.GetFiles(d, "*.txt"))
                {
                   files.Add(f);
                }
                DirSearch(d,ref files);
           }
        }
        catch (System.Exception excpt)
        {
                Console.WriteLine(excpt.Message);
        }
}
