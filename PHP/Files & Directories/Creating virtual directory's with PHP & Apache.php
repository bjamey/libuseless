<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Creating virtual directory's with PHP & Apache

   Date : 24/05/2007
   By   : FSL

Creating virtual directory's with PHP & Apache
==============================================

Maybe you would like some database driven website or you simply don't like the
http://www.zerodegree.de/?page=12&key=13 style then you can use the following
example to devellop a simple "virtual" directory structe.


Configuration in Apaches "httpd.conf":
--------------------------------------
<VirtualHost 134.102.49.5>
   ServerAdmin fschaper@zerodegree.de
   ServerName  testit.zerodegree.de
   ServerAlias zerodegree.de
   DocumentRoot "/your/web/path/test.php3"
</VirtualHost>

The test.php3 file should contain at least:
-------------------------------------------
<?php echo $PHP_SELF; ?>


The virtualhost entry with the documentroot set to a file tells Apache to serve
all requests on testit.zerodegree.de via the test.php3.

When you enter now for example http://testit.zerodegree.de/ your test.php3
script will be excuted as well as when you specify
http://testit.zerodegree.de/this/is/a/test .

You can recieve the informations about what the user typed after "<a
href="http://testit.zerodegree.de/">testit.zerodegree.de</a>" with PHP's
variable "$PHP_SELF".

For example would our file test.php3 containing this line of code "<?php echo
$PHP_SELF; ?>" now return /this/is/a/test

This could be usefull if you want to "simulate" a directory structure, hide the
real content or devellop a database driven webpresence.

Have fun.         
---------------------------------------------------------------------------- */

?>
