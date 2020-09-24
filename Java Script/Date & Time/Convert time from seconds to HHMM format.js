// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Convert time from seconds to HHMM format
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// Convert time from seconds to HH:MM format

function sec2hrsmins(Seconds,noUnits)
{
        lSeconds = Seconds;
        lHrs = parseInt(lSeconds / 3600);
        lMinutes = (parseInt(lSeconds / 60)) - (lHrs * 60);

        if(lSeconds == 60)
        {
                lMinutes = lMinutes + 1;
                lSeconds = 0;
        }

        if(lMinutes == 60)
        {
            lMinutes = 0;
            lHrs = lHrs + 1;
        }

        tSeconds = lSeconds - ( (lHrs * 60)+(lMinutes * 60) );

        if (noUnits)
                return (lHrs + ":" + lMinutes);
        else
                return (lHrs+"H:" + lMinutes + "m");
}                             
