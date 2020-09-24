// ----------------------------------------------------------------------------
//                                               DTT (c)2006 FSL - FreeSoftLand
// Title: ScreenSaver
//
//        Basic structure for simple screensaver.
//
// Date : 27/04/2006
// By   : Stefano
// ----------------------------------------------------------------------------

int main(int argc, char* argv[])
{
        /*
             argc contain the number of given parameters
             Possible parameters:
             "\p" --> preview
             "\c" --> configuration
             "\s" --> screensaver
             Must be present into 2nd parameter (argv[1]).
        */

        if (argc < 2) return 0;
        
        if (argv[1][1]=='p')      //PREVIEW
        {
                //
                ShowMessage("Here must be the preview!");
        }
        else if (argv[1][1]=='c') //CONFIG
        {              
                //
                ShowMessage("Here must be the configuration!");           
        }
        else if (argv[1][1]=='s') //SCREENSAVER
        {
                //
                ShowMessage("Here must be the screensaver routine!");
        }

        return 0;
}
//---------------------------------------------------------------------------
