// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: ADO With JavaScript
//
// Date : 24/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/* -------------------------------------------------
   ADO With JavaScript
   --
   Description: I have not found any sample that shows
   database access with javaScript. Well, I created one.
   It is very simple since Javascript has the activeXObject
   that allow us to call an external object in the same
   way that vbscript uses CreateObject.

   By: Marcio Coelho
------------------------------------------------- */

var conn = new ActiveXObject("ADODB.Connection") ;
var connectionstring = "Provider=sqloledb; Data Source=itdev; Initial Catalog=pubs; User ID=sa;Password=yourpassword"

conn.Open(connectionstring)

var rs = new ActiveXObject("ADODB.Recordset")
rs.Open("SELECT gif, description, page, location FROM menu1", conn)

// Be aware that I am selecting from this table, but you need to pick your own table
while(!rs.eof)
{
    alert(rs(0));
    rs.movenext
}

rs.close
conn.close     
