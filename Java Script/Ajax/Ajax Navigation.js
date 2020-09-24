// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Ajax Navigation
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<html>
  <head>
      <script language="javascript">
      var please_wait = "Please wait while the page is opening....";

      function open_url(url, target) {
               if ( ! document.getElementById) {
                        return false;
               }

               if (please_wait != null) {
                        document.getElementById(target).innerHTML = please_wait;
               }

               if (window.ActiveXObject) {
                        link = new ActiveXObject("Microsoft.XMLHTTP");
               } else if (window.XMLHttpRequest) {
                        link = new XMLHttpRequest();
               }

               if (link == undefined) {
                        return false;
               }
               link.onreadystatechange = function() { response(url, target); }
               link.open("GET", url, true);
               link.send(null);
      }

      function response(url, target)
      {
               if (link.readyState == 4) {
                       document.getElementById(target).innerHTML = (link.status == 200) ? link.responseText : "Ooops!! A broken link! Please contact the webmaster of this website ASAP and give him the fallowing errorcode: " + link.status;
              }
      }

      function set_loading_message(msg)
      {
               please_wait = msg;
      }
      </script>
  </head>

  <body>
      <a href="javascript:void(0)" onclick="open_url('page-1.html','my_site_content');">Go to page 1</a><br />
      <a href="javascript:void(0)" onclick="open_url('page-2.html','my_site_content');">Go to page 2</a><br />
      <a href="javascript:void(0)" onclick="open_url('page-3.html','my_site_content');">Go to page 3</a><br />
      <a href="javascript:void(0)" onclick="open_url('page-4.html','my_site_content');">Go to page 4</a><br />
      <a href="javascript:void(0)" onclick="open_url('xxxx.html','my_site_content');">Broken Link</a><br />

      <div id="my_site_content">
      </div>
  </body>
</html>
