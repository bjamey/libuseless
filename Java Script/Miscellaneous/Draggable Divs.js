// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Draggable Divs
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
    Add dragging to your div elements. just adding class=”drag” to
    the div element will make it draggable.

    You can set the area in which the div(s) can be dragged                
    using setdragBounds function
-->


<!doctype html public "-//W3C//DTD HTML 3.2 Final//EN">
    <html>
       <head>
          <style>
          .Text{
            font-family: Verdana,Arial,Sans-serif,'Times New Roman';
            font-size: 9pt;
            font-weight: normal;
            font-style: normal;
            color: #666;
            text-decoration: none;
          }

          .alertsBoxTitle{
            font-family: Verdana,Arial,Sans-serif,'Times New Roman';
            font-size: 9pt;
            font-weight: bold;
            font-style: normal;
            color: #ffffff;
            text-decoration: none;
          }
          .alertsBox{
            background: #ECF1F9;
            border: 1px #a1bcdf solid;
          }
          body{
           overflow:hidden;
          }
          </style>

          <script language="javascript">
          // browser detection
          var agt=navigator.userAgent.toLowerCase();
          var is_major = parseInt(navigator.appVersion);
          var is_minor = parseFloat(navigator.appVersion);

          var is_nav  = ((agt.indexOf('mozilla')!=-1) && (agt.indexOf('spoofer')==-1)
                      && (agt.indexOf('compatible') == -1) && (agt.indexOf('opera')==-1)
                      && (agt.indexOf('webtv')==-1) && (agt.indexOf('hotjava')==-1));
          var is_nav4 = (is_nav && (is_major == 4));
          var is_nav6 = (is_nav && (is_major == 5));
          var is_nav6up = (is_nav && (is_major >= 5));
          var is_ie     = ((agt.indexOf("msie") != -1) && (agt.indexOf("opera") == -1));

          var dragapproved=false
          var z,x,y
          var maxleft,maxtop,maxright,maxbottom;

          function setdragBounds()
          {
              // you can set the bounds of the draggable area here
              maxleft = 10;
              maxtop = 10;
              maxright = document.body.clientWidth - 10;
              maxbottom = document.body.clientHeight - 100;
          }

          function move(e)
          {
               var tmpXpos = (!is_ie)? temp1+e.clientX-x: temp1+event.clientX-x;
               var tmpYpos = (!is_ie)? temp2+e.clientY-y : temp2+event.clientY-y;
               if (dragapproved)
               {
                  z.style.left = tmpXpos;
                  z.style.top = tmpYpos;

                  if (tmpXpos < maxleft)
                      z.style.left = maxleft;

                  if (tmpXpos > maxright)
                      z.style.left = maxright;

                  if (tmpYpos < maxtop)
                      z.style.top = maxtop;
                  if (tmpYpos > maxbottom)
                      z.style.top = maxbottom;

                  return false
               }
          }

          function drags(e)
          {
                 if (!(is_ie)&&!(!is_ie)) return

                 var firedobj=(!is_ie)? e.target : event.srcElement
                 var topelement=(!is_ie)? "HTML" : "BODY"

                 while (firedobj.tagName!=topelement && firedobj.className!="drag" && firedobj.tagName!='SELECT' && firedobj.tagName!='TEXTAREA' && firedobj.tagName!='INPUT' && firedobj.tagName!='IMG')
                 {
                     // here you can add the elements that cannot be used for drag . using their class name or id or tag names
                     firedobj=(!is_ie)? firedobj.parentNode : firedobj.parentElement
                 }

                 if (firedobj.className=="drag")
                 {
                     dragapproved = true
                     z = firedobj
                     var tmpheight = z.style.height.split("px")
                     maxbottom = (tmpheight[0])?document.body.clientHeight - tmpheight[0]:document.body.clientHeight - 20;

                     temp1 = parseInt(z.style.left+0)
                     temp2 = parseInt(z.style.top+0)
                     x = (!is_ie)? e.clientX: event.clientX
                     y = (!is_ie)? e.clientY: event.clientY
                     document.onmousemove = move

                     return false
                 }
          }

          document.onmousedown=drags
          document.onmouseup=new Function("dragapproved=false")
       </script>
    </head>

    <body>
      <div id="Dialog" style="width:316px;height:119px;max-width:316px;position:absolute;top:50px;left:140px; z-index:1000;" class="drag">
        <table width="100%" style="width:315px;height:119px" cellspacing="0" cellpadding="0" class="alertsBox" id="dialog_table">
          <tr style="cursor:move">
            <td class="alertsBoxTitle notselectable" colspan="2" align="left" height="21" style="cursor:move;background-color:#32426F">Drag Me</td>
          </tr>
          <tr>
            <td align="center" colspan="2" height="5"> </td>
          </tr>
          <tr>
            <td align="center" colspan="2">
              <table width="97%"  border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                  <td valign='top' align="center">
                    </td>
                </tr>
                <tr>
                  <td valign='top' colspan="2" class="Text">You can place text here</td>
                </tr>
                <tr>
                  <td valign='top' colspan="2" align="center"><br/><input type="button" value="Ok"/></td>
                </tr>
              </table></td>
          </tr>
        </table>
      </div>
    </body>
</html>
