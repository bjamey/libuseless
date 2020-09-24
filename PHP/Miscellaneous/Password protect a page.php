<?php /* ----------------------------------------------------------------------
                                                 DTT (c)2006 FSL - FreeSoftLand
   Title: Password protect a page

          Password protection for a single page. Visitors are required to enter
          a password and username into a login form to view the page content.

   Date : 31 May 2006
   By   : TotallyPHP - www.totallyphp.co.uk 
---------------------------------------------------------------------------- */

// Define your username and password
$username = "someuser";
$password = "somepassword";

if ($_POST['txtUsername'] != $username || $_POST['txtPassword'] != $password) {

?>

<h1>Login</h1>

<form name="form" method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
    <p><label for="txtUsername">Username:</label>
    <br /><input type="text" title="Enter your Username" name="txtUsername" /></p>

    <p><label for="txtpassword">Password:</label>
    <br /><input type="password" title="Enter your password" name="txtPassword" /></p>

    <p><input type="submit" name="Submit" value="Login" /></p>

</form>

<?php

}
else {

?>

<p>This is the protected page. Your private content goes here.</p>

<?php

}

?> 
