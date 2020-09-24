// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Basic Ajax Syntax
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/*
   ------------------
   Basic Ajax Syntax
   ------------------

   The basic framework of an Ajax-enabled web page. The following
   JavaScript shows how to send a request for an XML file and how
   to receive that request. Of course, in a real life scenario,
   you''ll have to implement better error trapping and actually do
   something with the XML that gets returned.
*/


// Function to "handle" the response
function myHandler()
{
    // Was the request successful?
    if (this.readyState == 4 && this.status == 200)
    {
        // Did the request return a result?
        if (this.responseXML != null && this.responseXML.getElementById("stuff").firstChild.data)
        {
            doSomething(this.responseXML.getElementById("stuff").firstChild.data);
        }
    }
}

var myRequest; // Variable to hold request object

if (window.XMLHttpRequest)
{
    myRequest = new XMLHttpRequest(); // Standards-compliant browsers
} else if (window.ActiveXObject)
{
    myRequest = new ActiveXObject("Msxml2.XMLHTTP"); // For IE
}                                                      

myRequest.onreadystatechange = myHandler;

// "getStuff.php" can be anything that returns an XML file
myRequest.open("GET", "getStuff.php", true);
