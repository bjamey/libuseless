<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: HTTP Redirect

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
 Often people want to redirect, visitors to another page. But you always have to
 be aware of if there has been some output or not.

 With this function, you don't really have to bother with this problem.
 It will try to send Header redirect, but also sends META Redirect, Javascript
 Redirect and finaly a link.
*/

function forceRedirect($url, $die = true) {
     if (!headers_sent()) {
         ob_end_clean();
         header("Location: " . $url);
     }

     printf("<html>");
     printf("<meta http-equiv="Refresh" content="0;url=%s">", $url);
     printf("<body onload="try {self.location.href='%s' } catch(e) {}"><a href="%s">Redirect </a></BODY>", $url, $url);
     printf("</html>");

     if ($die)
        die();
}

?>
