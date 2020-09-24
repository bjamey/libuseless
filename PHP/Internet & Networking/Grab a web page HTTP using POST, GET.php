<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Grab a web page HTTP using POST, GET

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
    Want to grab a web page like you would using the LWP::Simple module in
    Perl? Well, I've created a quick little user-agent style page-puller that can
    use either HTTP POST or GET, depending on what you feel like doing.
*/

function pullpage( $method, $host, $usepath, $postdata = "" ) {
 # open socket to filehandle
 $fp = pfsockopen( $host, 80, &$errno, &$errstr, 120 , 1);

 # user-agent name
 $ua = "yourUserAgent/1.0";

 if( !$fp ) {
    print "$errstr ($errno)<br>n";
 }
 else {
    if( $method == "GET" ) {
        fputs( $fp, "GET $usepath HTTP/1.0n" , 1);
    }
    else if( $method == "POST" ) {
        fputs( $fp, "POST $usepath HTTP/1.0n" , 1);
    }

    fputs( $fp, "User-Agent: ".$ua."n" , 1);
    fputs( $fp, "Accept: */*n" , 1);
    fputs( $fp, "Accept: image/gifn" , 1);
    fputs( $fp, "Accept: image/x-xbitmapn" , 1);
    fputs( $fp, "Accept: image/jpegn" , 1);

    if( $method == "POST" ) {
        $strlength = strlen( $postdata , 1);

        fputs( $fp,
         "Content-type: application/x-www-form-urlencodedn" , 1);
        fputs( $fp, "Content-length: ".$strlength."nn" , 1);
        fputs( $fp, $postdata."n" , 1);
    }

    fputs( $fp, "n" , 1);

    $output = "";

    # while content exists, keep retrieving document in 1K chunks
    while( !feof( $fp ) ) {
        $output .= fgets( $fp, 1024 , 1);
    }

    fclose( $fp , 1);
 }

 return $output;
 }
?>
