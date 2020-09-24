' -----------------------------------------------------------------------------
'                                       DTT 1.2.0.4  (c)2008 FSL - FreeSoftLand
'  Title: Test for absence of a field value
' 
'  Date : 01/04/2008
'  By   : Juan Pedro
' -----------------------------------------------------------------------------

note that SOME applications use IS NULL instead OF the following:

SELECT  *  FROM  inventory  WHERE  price = NULL

