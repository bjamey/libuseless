// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: A simple edit in place
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

/*
   Author: Snyke ( http://www.Snyke.net )
   Description: In-Situ Editing of text paragraphs on click.
   Based on 'Edit-in-Place with Ajax' of 24ways.org
   @params string element, parameters (get)

   -------
   Note :
   -------
   This code require Prototype JavaScript Framework [ http://prototype.conio.net/ ]
   Which is also included in this library
*/

function editinplace(obj, params)
{
        Element.hide(obj);
        var textarea = '<div id="' + obj.id +
            '_editor"><textarea class="editable" id="' + obj.id +
            '_edit" name="' + obj.id + '" rows="4" cols="60">' +
            obj.innerHTML + '</textarea>';
        var button = '<div><input id="' + obj.id +
                     '_save" type="button" value="Save" /> <input id="' +
                     obj.id + '_cancel" type="button" value="Cancel" /></div></div>';
        new Insertion.After(obj, textarea + button);
        Event.observe(obj.id + '_save', 'click', function(){saveChanges(obj, params)}, false);
        Event.observe(obj.id + '_cancel', 'click', function(){cleanUp(obj)}, false);
}

function saveChanges(obj, params)
{
        var new_content =  escape($F(obj.id + '_edit'));
        obj.innerHTML   = "<img src='thm/img/loading.gif'> Saving...";

        cleanUp(obj, true);

        var success     = function(t){editComplete(t, obj);}
        var failure     = function(t){editFailed(t, obj);}
        var url         = 'index.php';
        var pars        = '&' + params + '&ajax=editinplace&id=' + obj.id + '&content=' + new_content;
        var myAjax      = new Ajax.Request(url, {method:'post', postBody:pars, onSuccess:success, onFailure:failure});
}

function cleanUp(obj, keepEditable)
{
        Element.remove(obj.id+'_editor');
        Element.show(obj);
        //new Effect.Highlight(obj, { duration: 3.0 });
}

function editComplete(t, obj)
{
        obj.innerHTML   = t.responseText;
}

function editFailed(t, obj)
{
        obj.innerHTML   = 'Could not save...';
        cleanUp(obj);
}
