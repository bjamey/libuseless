<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: PGP Encryption Message Verifier

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

# vim: ft=php

function is_pgp($my_string) {

$begin =  strpos($my_string, "-----BEGIN PGP");
if ($begin === false) {
 return false;
}

$sign = strpos($my_string, "----BEGIN PGP SIGN");
if ($sign !== false) {
 return false;
}

$blank = strpos($my_string, "\r\n\r\n");
if ($blank === false) {
 return false;
}

$end = strpos($my_string, "----END");
if ($end === false) {
 return false;
}
if ($end < $begin) {
 return false;
}

return true;
}
?>

<html>
<head><title>is_php</title></head>
<body>
<p>

<?php
if ($_POST['message'] != "") {
if(is_pgp($_POST['message'])==true) {
 echo "I think the following text is a valid pgp encrypted message";
 } else {
 echo "The following text does not validate as a pgp encrypted message";
 }
} else {echo "use the following form to test whether text is pgp encrypted"; }
?>

</p>
<form action=pgp.php method="post">
<textarea name="message"  rows="20" cols="60" wrap="virtual">
<?php echo($_POST['message']); ?>
</textarea>
<input type="submit" value="validate text">
</form>
</body>
</html>

?>
