<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How Long Has It Been Since a Certain Date

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

    function getdiff($fromDate)
    {
        list($thisYear, $thisMonth, $thisDay, $thisDoY, $thisDiM) = explode('.', date('Y.n.j.z.t'));

        list($fromYear, $fromMonth, $fromDay) = preg_split('/-0?/', $fromDate);
        $fromDoY = date('z', mktime(0,0,0, $fromMonth, $fromDay, $thisYear));
        if( $fromDoY == $thisDoY ) return array($thisYear-$fromYear, 0, 0);

        $passedYears = ( $thisYear - $fromYear );

        $passedMonths = ( $fromDoY > $thisDoY ) ? 12-( $fromMonth-$thisMonth ) : $thisMonth-$fromMonth;
        $passedDays = ( $thisDay < $fromDay ) ? $thisDiM-( $fromDay-$thisDay ) : $thisDay-$fromDay;

        if( $fromDoY > $thisDoY ) $passedYears--;
        if( $thisDay < $fromDay ) $passedMonths--;

        return array($passedYears, $passedMonths, $passedDays);
    }
?>
