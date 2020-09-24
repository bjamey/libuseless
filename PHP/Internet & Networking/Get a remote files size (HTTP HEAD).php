<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Get a remote files size (HTTP HEAD)

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

function remote_file_size ($url){
        $head = "";
        $url_p = parse_url($url);
        $host = $url_p["host"];
        if(!preg_match("/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/",$host)){
                // a domain name was given, not an IP
                $ip=gethostbyname($host);
                if(!preg_match("/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*/",$ip)){
                        //domain could not be resolved
                        return -1;
                }
        }
        $port = intval($url_p["port"]);
        if(!$port) $port=80;
        $path = $url_p["path"];
        //echo "Getting " . $host . ":" . $port . $path . " ...";

        $fp = fsockopen($host, $port, $errno, $errstr, 20);
        if(!$fp) {
                return false;
                } else {
                fputs($fp, "HEAD "  . $url  . " HTTP/1.1\r\n");
                fputs($fp, "HOST: " . $host . "\r\n");
                fputs($fp, "User-Agent: http://www.example.com/my_application\r\n");
                fputs($fp, "Connection: close\r\n\r\n");
                $headers = "";
                while (!feof($fp)) {
                        $headers .= fgets ($fp, 128);
                        }
                }
        fclose ($fp);
        //echo $errno .": " . $errstr . "<br />";
        $return = -2;
        $arr_headers = explode("\n", $headers);
        // echo "HTTP headers for <a href='" . $url . "'>..." . substr($url,strlen($url)-20). "</a>:";
        // echo "<div class='http_headers'>";
        foreach($arr_headers as $header) {
                // if (trim($header)) echo trim($header) . "<br />";
                $s1 = "HTTP/1.1";
                $s2 = "Content-Length: ";
                $s3 = "Location: ";
                if(substr(strtolower ($header), 0, strlen($s1)) == strtolower($s1)) $status = substr($header, strlen($s1));
                if(substr(strtolower ($header), 0, strlen($s2)) == strtolower($s2)) $size   = substr($header, strlen($s2));
                if(substr(strtolower ($header), 0, strlen($s3)) == strtolower($s3)) $newurl = substr($header, strlen($s3));
                }
        // echo "</div>";
        if(intval($size) > 0) {
                $return=intval($size);
        } else {
                $return=$status;
        }
        // echo intval($status) .": [" . $newurl . "]<br />";
        if (intval($status)==302 && strlen($newurl) > 0) {
                // 302 redirect: get HTTP HEAD of new URL
                $return=remote_file_size($newurl);
        }
        return $return;
}

?>
