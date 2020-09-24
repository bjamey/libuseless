<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Relative Date Retriever

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function relative_date($time)
{
    $today = strtotime(date('M j, Y'));
    $reldays = ($time - $today)/86400;
    if ($reldays >= 0 && $reldays < 1) {
        return 'today';
    } else if ($reldays >= 1 && $reldays < 2) {
        return 'tomorrow';
    } else if ($reldays >= -1 && $reldays < 0) {
        return 'yesterday';
    }
    if (abs($reldays) < 7) {
        if ($reldays > 0) {
            $reldays = floor($reldays);
            return 'in ' . $reldays . ' day' . ($reldays != 1 ? 's' : '');
        } else {
            $reldays = abs(floor($reldays));
            return $reldays . ' day'  . ($reldays != 1 ? 's' : '') . ' ago';
        }
    }
    if (abs($reldays) < 182) {
        return date('l, F j',$time ? $time : time());
    } else {
        return date('l, F j, Y',$time ? $time : time());
    }
}

?>
