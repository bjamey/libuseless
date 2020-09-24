<?php /* ----------------------------------------------------------------------
                                        DTT 1.1.5.0  (c)2006 FSL - FreeSoftLand
   Title: MySQL Connect script

   Date : 09.8.2006
   By   : Dimitar Minchev <mitko@bfu.bg>
-------------------------------------------------------------------------------
config.ini
----------
[MySQL Database Settings]
db=myDatabase
host=localhost
port=3306
user=root
password=MyPassword

*/               

// Connection class
class connection {

 var $my_connection;

 function connect() {

   // Settings
   $ini_array = parse_ini_file("config.ini");
   $base = $ini_array["db"];
   $host = $ini_array["host"];
   $user = $ini_array["user"];
   $pass = $ini_array["password"];
   $port = $ini_array["port"];

   // Connect
   $this->my_connection = mysql_connect($host.':'.$port,$user,$pass) 
          or die("Could not connect: ".mysql_error());

   // Selecting the base
   mysql_select_db($base);

   // Cyrilic Support
   mysql_query("SET NAMES 'cp1251'");
 } 

 // Disconnect
 function disconnect() {
    mysql_close($this->my_connection);
 }  
}
?>
