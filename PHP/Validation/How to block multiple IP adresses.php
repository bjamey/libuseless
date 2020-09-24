<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: How to block multiple IP adresses

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/*
** Function: How to block multiple IP adresses (PHP)
** Desc: Shows how to block multiple IP adresses
** Example: see below
** Author: Jonas John
*/

    // Denied IP's.
    $deny_ips = array(
        '127.0.0.1',
        '192.168.100.1',
        '192.168.200.1',
        '192.168.300.1',
        'xxx.xxx.xxx.xxx'
    );

    // $deny_ips = file('blocked_ips.txt');

    // read user ip adress:
    $ip = isset($_SERVER['REMOTE_ADDR']) ? trim($_SERVER['REMOTE_ADDR']) : '';

    // search current IP in $deny_ips array
    if (($i = array_search($ip, $deny_ips)) !== FALSE)
    {
        // $i = contains the array key of the IP adress.

        // user is blocked:
        print "Your IP adress ('$ip') was blocked!";
        exit;
    }

    // If we reach this section, the IP adress is valid

?>
