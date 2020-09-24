' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: AND
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

use OF AND  OR
SELECT NAME  FROM customers  WHERE state="TX" AND NAME="Beene"

SELECT NAME  FROM customers  WHERE state="TX" OR state="CA"

SELECT NAME  FROM customers  WHERE state="TX" OR state="CA"

