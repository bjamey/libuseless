// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Google maps demo
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
  Note: Replace {PERSONALKEY} with your Google API key
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <title>Google Maps JavaScript API Example</title>
        <script src="http://maps.google.com/maps?file=api&v=2&key={PERSONALKEY}"
              type="text/javascript"></script>
        <script type="text/javascript">
        //<![CDATA[
        function load()
        {
           if (GBrowserIsCompatible())
           {
               var map = new GMap2(document.getElementById("map"));

               map.addControl(new GLargeMapControl());
               map.addControl(new GMapTypeControl());
               map.addControl(new GOverviewMapControl());

               map.setCenter(new GLatLng(74.094, 8.453), 13);
           }
        }
        //]]>
        </script>
    </head>

    <body onload="load()" onunload="GUnload()">
      <div id="map" style="width: 800px; height: 600px"></div>
    </body>
</html>
