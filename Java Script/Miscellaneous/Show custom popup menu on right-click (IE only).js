// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Show custom popup menu on right-click (IE only)
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
 GeneratePopupMenu: Defines a new MENU for the right-click
                    event. The arrMenu 'array' must have the
                    following syntax:
                    arrMenu('<tool_tip>'|'<function_to_call OR javascript_code>'|'<menu_string'>)

 Parameters:
      arrMenu  = Array containing the NEW menu
      FontFace = The font name (ie: Tahoma, Times New, Helvetica, etc).
                 If FontFace is blank ('') or ('default') Tahoma
                 font will be used
      FontSize = The font size (8, 9, 12, 24, etc). If FontSize
                     is blank ('') or ('default') font size 8
                     will be used

 Returns: Nothing

 Remarks: - This menu works only with IE 4.01+
          - Use <HR> to separate items in the menu

 Example:
 [body]
        [script language=javascript]
        var arrM = new Array()
        arrM[0] = 'Cancel the current Order|btnCancelOrder_OnClick()|Cancel Order'
        arrM[1] = 'Refresh the Current page|window.location.reload()|Refresh Order'
        arrM[2] = '<hr>'
        arrM[3] = 'Search Products by Category|SearchProducts()|Search Products'
        arrM[4] = '<hr>'
        arrM[5] = 'Display the Agency Order History|AgencyOrderHistory()|Order History'
        arrM[6] = 'Shows the Agency Information|AgencyInfo()|Show Agency Info'
        arrM[7] = 'Add a new Agent to the Database|AddNewAgent()|Add New Agent'
        arrM[8] = '<hr>'
        arrM[9] = 'Enter your Name|var a=prompt("Enter your Name:");showName(a)|Enter Name'
        arrM[10] = '<hr>'
        arrM[11] = 'Close this menu...|alert("This menu will be closed")|Close this Menu'

        GeneratePopupMenu(arrM, '', '')

        function showName(a)
        {
                //This function will be called from the Popup menu//
                alert('Hello' + a);
        }
        [/script]
 [/body]
---------------------------------------------------------------- -->
function GeneratePopupMenu(arrMenu, FontFace, FontSize)
{
        var strTemp = ''
        var A = new Array()

        if (FontFace.length == 0 || FontFace == '' || FontFace.toLowerCase() == 'default')
                FontFace = "Tahoma"

        if (FontSize.length == 0 || FontSize == 0 || FontSize == '' || FontSize.toLowerCase() == 'default')
                FontSize = "8"

        var line_step = ((FontSize * 16) / 8)

        document.write('<style>')
        document.write('#MainMenu {border-top: 1px solid #D4D0C8; border-left: 1px solid LightGrey; border-right: 1px solid Black; border-bottom: 1px solid Black; position: absolute; visibility: hidden}')
        document.write('.MenuItem {border-top: 1px solid White; border-left: 1px solid White; border-right: 1px solid Gray; border-bottom: 1px solid Gray; line-height: ' + line_step + 'px; padding-left: 15px; padding-right: 15px; font-family: ' + FontFace + '; font-size: ' + FontSize + 'pt; background-color: #D4D0C8}')
        document.write('</style>')

        strTemp = "<div id='MainMenu' bgcolor='#D4D0C8'>"
        strTemp = strTemp + "<table border='0' bgcolor='#D4D0C8' cellpadding='0' cellspacing='0' class='MenuItem' valign='top'>"

        for (var I = 0; I <= UBound(arrMenu); I++)
        {
                A = Split(arrMenu[I], "|")
                if (A[0].toLowerCase() != "<hr>")
                {
                        strTemp = strTemp + "<tr><td valign='top' onmouseover='highlight()' onmouseout='lowlight()' style='cursor: hand' "
                        strTemp = strTemp + " toolTip='" + A[0] + "'"
                        strTemp = strTemp + " onClick='javascript:{HideMenu();" + A[1] + "}'>"
                        strTemp = strTemp + A[2] + ""
                        strTemp = strTemp + "</td></tr>"
                }
                else
                {
                        strTemp = strTemp + "<tr><td style='height: 3px; cursor: normal'></td></tr>"
                        strTemp = strTemp + "<tr><td bgcolor=gray style='height: 1px; cursor: normal'></td></tr>"
                        strTemp = strTemp + "<tr><td bgcolor=white style='height: 1px; cursor: normal'></td></tr>"
                        strTemp = strTemp + "<tr><td style='height: 3px; cursor: normal'></td></tr>"
                }
        }

        strTemp = strTemp + "</table></div>"

        document.write(strTemp)

        document.oncontextmenu = DisplayMenu
        if (document.all && window.print)
                document.body.onclick = HideMenu

        return true
}

function highlight()
{
        event.srcElement.style.background = "Navy" //<= change value to change background color
        event.srcElement.style.color = "White"     //<= change value to change fore color
        if (event.srcElement.toolTip != '')
                window.status = event.srcElement.toolTip
}

function lowlight()
{
        event.srcElement.style.backgroundColor = "#D4D0C8"
        event.srcElement.style.color = "Black"
        window.status = ''
}

function DisplayMenu()
{
        var rightedge = document.body.clientWidth - event.clientX
        var bottomedge = document.body.clientHeight - event.clientY

        if (rightedge < MainMenu.offsetWidth)
                MainMenu.style.left = document.body.scrollLeft + event.clientX - MainMenu.offsetWidth
        else
                MainMenu.style.left = document.body.scrollLeft + event.clientX

        if (bottomedge < MainMenu.offsetHeight)
                MainMenu.style.top = document.body.scrollTop + event.clientY - MainMenu.offsetHeight
        else
                MainMenu.style.top = document.body.scrollTop + event.clientY

        MainMenu.style.visibility = "visible"
        return false
}

function HideMenu()
{
        MainMenu.style.visibility = "hidden"
}
