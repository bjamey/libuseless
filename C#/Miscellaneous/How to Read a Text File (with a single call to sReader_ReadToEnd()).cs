// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: How to Read a Text File (with a single call to sReader·ReadToEnd())
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

     public static string getFileAsString(string fileName) {
         StreamReader sReader = null;
         string contents = null;
         try {
            FileStream fileStream = new FileStream(fileName, FileMode.Open, FileAccess.Read);
            sReader = new StreamReader(fileStream);
            contents = sReader.ReadToEnd();
         } finally {
           if(sReader != null) {
               sReader.Close();
            }
         }
         return contents;
      }                                                     
