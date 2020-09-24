<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: WWW-Authenticate example

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */


$login_successful = false;

// check user & pwd:
if (isset($_SERVER['PHP_AUTH_USER']) && isset($_SERVER['PHP_AUTH_PW']))
{
    $usr = $_SERVER['PHP_AUTH_USER'];
    $pwd = $_SERVER['PHP_AUTH_PW'];

    if ($usr == 'jonas' && $pwd == 'secret'){
        $login_successful = true;
    }
}

// login ok?
if (!$login_successful)
{
    // send 401 headers:
    // realm="something" will be shown in the login box
    header('WWW-Authenticate: Basic realm="Secret page"');
    header('HTTP/1.0 401 Unauthorized');
    print "Login failed!\n";

}
else
{
    // show secret page:
    print 'you reached the secret page!';
}

?>
