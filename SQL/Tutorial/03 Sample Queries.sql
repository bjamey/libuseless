' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: 03 Sample Queries
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------
SELECT  *  FROM customers

SELECT  firstname, lastname, age  FROM customers

SELECT *  FROM  customers  WHERE NAME LIKE "%David%"

SELECT  item, price, price*1.07 (Sale Price)  FROM inventory

SELECT *  FROM  customers  WHERE NAME LIKE "David%"

SELECT NAME  FROM customers  WHERE state="TX" OR state="CA"

SELECT *   FROM friends  WHERE areacode  IN(100,381,204)

SELECT *   FROM friends  WHERE areacode BETWEEN (100,200)


