<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Simple PHP DB Classes

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

class SimpleDB_Connection
{
        var $conn;
        var $error = 'No Error';

        function SimpleDB_Connection($hostname = 'localhost', $username = null, $password = null)
        {
                $this->conn = @mysql_connect($hostname, $username, $password);
                if (!$this->conn) $this->error = 'Could not connect to database.';
                return $this->conn;
        }

        function query($sql)
        {
                if (!$this->conn)
                {
                        $this->error = 'Not connected to database.';
                        return false;
                }

                $res = @mysql_query($sql, $this->conn);
                if (!$res)
                {
                        $this->error = mysql_error($this->conn);
                        return false;
                }

                return new SimpleDB_Result($res, $this->conn);
        }

        function getError()
        {
                return $this->error;
        }
}

class SimpleDB_Result
{
        var $conn;
        var $res;
        var $numRows;
        var $numAffected;

        function SimpleDB_Result(&$res, &$conn)
        {
                $this->res = $res;
                $this->conn = $conn;
        }

        function getNext()
        {
                $res = @mysql_fetch_assoc($this->res);
                return $res;
        }

        function getNumRows()
        {
                $res = ($this->numRows ? $this->numRows : @mysql_num_rows($this->res));
                $this->numRows = $res;
                return $res;
        }

        function getNumAffected()
        {
                $res = ($this->numAffected ? $this->numAffected : @mysql_affected_rows($this->conn));
                $this->numAffected = $res;
                return $res;
        }
}

/**
 * EXAMPLES:
 */

$db = new SimpleDB_Connection('localhost', 'username', 'password');
$sql = 'SELECT *
                FROM `users`
                WHERE `userid` < 99';
$result = $db->query($sql);
if (!$result) die($db->getError());
if ($result->getNumRows() == 0) die('No Results');
while ($row = $result->getNext())
{
        echo "{$row['username']}<br />\n";
}
?>
