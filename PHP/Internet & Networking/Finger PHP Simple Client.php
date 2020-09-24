<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Finger PHP Simple Client

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

        // Client di Finger

        $fp = fsockopen('kernel.org', 79); // Si collega al seguente server nella porta 79

        fputs($fp, '@kernel.org\n'); // Manda una richiesta

        echo '<table border=\'0\' cellspacing=\'1\' cellpadding=\'1\' bgcolor=\'black\'>';

        while( !feof($fp) )
        {
                $text = fgets($fp, 128); // Ritorna una risposta

                if(trim($text) != '')
                {
                        echo '<tr bgcolor=\'white\'>';
                        echo '<td>';
                        echo '<font face=\'Arial\' size=\'-2\'>' . trim($text) . '</font>';
                        echo '</td>';
                        echo '</tr>';
                }
        }

        echo '</table>';

        fclose($fp);

?>
