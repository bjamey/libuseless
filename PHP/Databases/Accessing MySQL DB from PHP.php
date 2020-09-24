<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Accessing MySQL DB from PHP

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

        $UserName = "@@@@@";
        $PassWord = "$$$$$";
        $DataBase = "%%%%%";
        $HostName = "localhost"; // Unless your host is remote, use localhost.

        $MySQLConnection = mysql_connect($HostName, $UserName, $PassWord) or die("Unable to connect to MySQL Database!!");

        $MySQLSelectedDB = mysql_select_db($DataBase, $MySQLConnection) or die("Could not Set the Database!!");

        $MySQLRecordSet = mysql_query("SELECT TOP 5 field_1, field_2 FROM some_phpbb_table");

        while ($MyRow = mysql_fetch_array($MySQLRecordSet, MYSQL_ASSOC)) {
                print "First Field: " . $MyRow{'field_1'} . " Second Field: " . $MyRow{'field_2'} . "<br>";
        }
        mysql_close($MySQLConnection);
}
?>
