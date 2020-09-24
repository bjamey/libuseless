// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Open URL Return a concatenated string with all the 'objects values' contained in a FORM HTML
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!-- ----------------------------------------------------------------
OpenURL: Return a concatenated string with all the 'objects
          values' contained in a FORM HTML in the format:
          page_to_redirect.html/asp?object1=xxxx&object2=yyyyy&...

 Parameters:
      URL  = URL to redirect
      Form = Form name (be sure not to use QUOTES when passing
             the Form name)

 Returns: URL

 Example: var redirect = OpenURL('mytest.asp', frmMyForm)
          alert(redirect)
          window.nagivate(redirect)
---------------------------------------------------------------- -->
function OpenURL(URL, Form)
{
        if (URL.length == 0 || URL == null)
                return (false);

        var form_length = Form.elements.length;
        var myform = Form;
        var mytype = '';
        var temp = URL + '?';

        for (var i = 0; i < form_length; i++)
        {
                mytype = myform.elements[i].type
                mytype = mytype.toLowerCase();
                if (mytype == 'text' || mytype == 'hidden' || mytype == 'select-one' ||
                    mytype == 'checkbox' || mytype == 'radio' || mytype == 'select-multiple')
                {
                        var t = myform.elements[i].name
                        if (t == null || t == '')
                                t = myform.elements[i].id
                        if (mytype == 'text' || mytype == 'hidden')
                                temp = temp + t + "=" + escape(myform.elements[i].value);
                        else if (mytype == 'checkbox' || mytype == 'radio')
                                temp = temp + t + "=" + escape(myform.elements[i].checked);
                        else if (mytype == 'select-one' || mytype == 'select-multiple')
                                temp = temp + t + "=" + escape(myform.elements[i][myform.elements[i].selectedIndex].value);
                        if (i < form_length - 1)
                                temp = temp + "&";
                }
        }
        temp = temp.substring(temp, temp.length - 1)

        return temp;
}
