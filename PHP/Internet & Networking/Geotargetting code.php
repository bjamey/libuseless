<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Geotargetting code

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

  /**
   * Original code from svn://hostip.info/hostip/api/trunk.
   * Optimized & enhanced by Quang Pham @ Saoma, 06.01.07.
   */

  function isPrivateIP($ip)
  {
    list($a, $b, $c, $d) = sscanf($ip, "%d.%d.%d.%d");
    return  $a === null || $b === null || $c === null || $d === null ||
            $a == 10    ||
            $a == 239   ||
            $a == 0     ||
            $a == 127   ||
           ($a == 172 && $b >= 16 && $b <= 31) ||
           ($a == 192 && $b == 168);
  }

  function getIP() {
    $default = false;

    if (isset($_SERVER)) {
      $default_ip = $_SERVER["REMOTE_ADDR"];
      $xforwarded_ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
      $client_ip = $_SERVER["HTTP_CLIENT_IP"];
    } else {
      $default_ip = getenv('REMOTE_ADDR');
      $xforwarded_ip = getenv('HTTP_X_FORWARDED_FOR');
      $client_ip = getenv('HTTP_CLIENT_IP');
    }

    if ($xforwarded_ip != "") {
      $result = $xforwarded_ip;
    } else if ($client_ip != "") {
      $result = $client_ip;
    } else {
      $default = true;
    }

    if (!$default) { // additional check for private ip numbers
      $default = isPrivateIP($result);
    }

    if ($default) {
      $result = $default_ip;
    }

    return $result;
  }

  function showUSContent()
  {
      // show US content here, for ex. Yahoo! ads
  }

  function showInternationalContent()
  {
      // show international content here, for ex. Google ads
  }

  function showGeoTargetContent()
  {
    // make a valid request to the hostip.info API
    $url = "http://api.hostip.info/country.php?ip=".getIP();

    // fetch with curl
    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $country = curl_exec($ch);

    curl_close ($ch);

    // display according geotarget
    if ($country == "US") {
      showUSContent();
    } else {
      showInternationalContent();
    }
  }

  showGeoTargetContent();

?>
