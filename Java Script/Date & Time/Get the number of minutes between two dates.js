// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Get the number of minutes between two dates
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* ----------------------------------------------------------------
 MinutesDiff: Returns the number of minutes between two dates.

 Parameters:
    - Date1: First date
    - Date2: Second data

 Returns: Number
---------------------------------------------------------------- */
function MinutesDiff(Date1, Date2)
{
        date1 = new Date();
        date2 = new Date();
        diff  = new Date();

        date1temp = new Date(Date1);
        date1.setTime(date1temp.getTime());

        date2temp = new Date(Date2);
        date2.setTime(date2temp.getTime());

        diff.setTime(Math.abs(date1.getTime() - date2.getTime()));
        timediff = diff.getTime();

        weeks = Math.floor(timediff / (1000 * 60 * 60 * 24 * 7));
        timediff -= weeks * (1000 * 60 * 60 * 24 * 7);

        days = Math.floor(timediff / (1000 * 60 * 60 * 24));
        timediff -= days * (1000 * 60 * 60 * 24);

        hours = Math.floor(timediff / (1000 * 60 * 60));
        timediff -= hours * (1000 * 60 * 60);

        mins = Math.floor(timediff / (1000 * 60));
        timediff -= mins * (1000 * 60);

        secs = Math.floor(timediff / 1000);
        timediff -= secs * 1000;

        return (mins + (hours * 60) + (days * 24 * 60) + (weeks * 7 * 24 * 60))
}
