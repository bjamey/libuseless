<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: PHP SMTP Authentication send an email through an authenticated SMTP server

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

   function mymail($to,$subject,$message,$headers)
   {
     // set as global variable
     global $GLOBAL;

     // get From address
     if ( preg_match("/From:.*?[A-Za-z0-9\._%-]+\@[A-Za-z0-9\._%-]+.*/", $headers, $froms) ) {
        preg_match("/[A-Za-z0-9\._%-]+\@[A-Za-z0-9\._%-]+/", $froms[0], $fromarr);
        $from = $fromarr[0];
     }

     // Open an SMTP connection
     $cp = fsockopen ($GLOBAL["SMTP_SERVER"], $GLOBAL["SMTP_PORT"], &$errno, &$errstr, 1);
     if (!$cp)
      return "Failed to even make a connection";
     $res=fgets($cp,256);
     if(substr($res,0,3) != "220") return "Failed to connect";

     // Say hello...
     fputs($cp, "HELO ".$GLOBAL["SMTP_SERVER"]."\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "250") return "Failed to Introduce";

     // perform authentication
     fputs($cp, "auth login\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "334") return "Failed to Initiate Authentication";

     fputs($cp, base64_encode($GLOBAL["SMTP_USERNAME"])."\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "334") return "Failed to Provide Username for Authentication";

     fputs($cp, base64_encode($GLOBAL["SMTP_PASSWORD"])."\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "235") return "Failed to Authenticate";

     // Mail from...
     fputs($cp, "MAIL FROM: <$from>\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "250") return "MAIL FROM failed";

     // Rcpt to...
     fputs($cp, "RCPT TO: <$to>\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "250") return "RCPT TO failed";

     // Data...
     fputs($cp, "DATA\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "354") return "DATA failed";

     // Send To:, From:, Subject:, other headers, blank line, message, and finish
     // with a period on its own line (for end of message)
     fputs($cp, "To: $to\r\nFrom: $from\r\nSubject: $subject\r\n$headers\r\n\r\n$message\r\n.\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "250") return "Message Body Failed";

     // ...And time to quit...
     fputs($cp,"QUIT\r\n");
     $res=fgets($cp,256);
     if(substr($res,0,3) != "221") return "QUIT failed";

     return true;
   }

?>
