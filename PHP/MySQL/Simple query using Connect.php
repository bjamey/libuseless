<?php /* ----------------------------------------------------------------------
                                        DTT 1.1.5.0  (c)2006 FSL - FreeSoftLand
   Title: Simple query using Connect Script
                                 
   Date : 09.8.2006
   By   : Dimitar Minchev <mitko@bfu.bg>
---------------------------------------------------------------------------- */

 // conect
 require ('connect.php');
 $link = new connection();
 $link->connect();

 // info
 echo '<p>MySQL</p>';

 // query
 $query = mysql_query("select * from mysql.db group by db");

 // cycle
 while ($row = mysql_fetch_assoc($query)) {  
    echo 'Database: '.$r3["db"].'<br>';
 }

 // disconect
 $link->disconnect();

?>
