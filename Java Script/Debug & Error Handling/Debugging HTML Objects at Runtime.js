// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Debugging HTML Objects at Runtime
//
// Date : 23/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

<!--
   Adam Petrie
   Created: 09/27/2005
   Revised: 02/15/2006  (to make it more user/browser friendly).
   Revised: 10/05/2006 (slightly faster, more user/browser friendly, supports
                        innerHTML and outerHTML values now, and a few comments added).

   ---------------
   Functionality :
   ---------------
   Show current values held by a particular object given through the user.
   Also, user can dynamically change attributes (like the background color).
   Tested the following browsers (on XP OS): IE 6.0, NS 8.1.2, Opera 9.2, Firefox 1.5.0.7
   Sample usage: onload="alp_CreateDisplay();"  - from the body HTML tag.
-->

<script language="javascript">
      function alp_BtnGet_click(e)
      {
         // Event to start the processing...
         alp_ResetDiv();
         window.status = "Working...";
         alp_ShowValues(document.getElementById("alp_txt1").value);
         window.status = "Results should be displayed.";
         return true;
      }

      function alp_CreateDisplay() {
        // Creates a debugging display on the bottom of the page.
        var bodyContainer = document.getElementsByTagName("Body").item(0);
        var alp_div_obj_txt, alp_new_obj;

        // create page separator
        alp_new_obj = document.createElement("hr");
        bodyContainer.appendChild(alp_new_obj);

        // create the directions
        alp_new_obj = document.createElement("div");
        alp_new_obj.setAttribute("id","alp_JS_info_2");
        alp_div_obj_txt = document.createTextNode("Type in Object: ");
        alp_new_obj.appendChild(alp_div_obj_txt);
        bodyContainer.appendChild(alp_new_obj);

        // create the text input field
        alp_new_obj = document.createElement("input");
        alp_new_obj.setAttribute("id","alp_txt1");
        alp_new_obj.setAttribute("type","text");
        alp_new_obj.setAttribute("size","40");
        alp_new_obj.setAttribute("value","document.body");
        bodyContainer.appendChild(alp_new_obj);

        //create 'Get Values' Button
        alp_new_obj = document.createElement("input");
        alp_new_obj.setAttribute("id","alp_btn1");
        alp_new_obj.setAttribute("type","button");
        alp_new_obj.setAttribute("value","Get Values");
        alp_new_obj.onclick=alp_BtnGet_click;
        bodyContainer.appendChild(alp_new_obj);

        // create 'Clear Results' Button
        alp_new_obj = document.createElement("input");
        alp_new_obj.setAttribute("id","alp_btn2");
        alp_new_obj.setAttribute("type","button");
        alp_new_obj.setAttribute("value","Clear Results");
        alp_new_obj.onclick=alp_ResetDiv;
        bodyContainer.appendChild(alp_new_obj);
      }

      function alp_ResetDiv()
      {
         // Clears the contents of the DIV displaying all the results.
         window.status = "";
         var alp_div_obj = document.getElementById("alp_JS_info_1");
         if (alp_div_obj != null) {
            alp_div_obj.innerHTML = "";
         }
      }

      function alp_ShowValues(inVal)
      {
         // Will show all the attributes/objects for a object passed in by the user.
         var alp_doc_obj, bodyContainer, alp_div_obj_txt;
         var alp_div_obj = document.getElementById("alp_JS_info_1");
         var alp_txt_obj = document.getElementById("alp_txt1");
         var alp_pos = 0, alp_inner_pos = -1, alp_outer_pos = -1;
         var alp_obj_value_array=new Array();

         // Make sure the display DIV hasn't been created yet as this function can be called multiple times.
         if (alp_div_obj == null) {
            //create the div to show the results
            alp_div_obj = document.createElement("div");
            alp_div_obj.setAttribute("id","alp_JS_info_1");
            alp_div_obj_txt = document.createTextNode("");
            alp_div_obj.appendChild(alp_div_obj_txt);
            bodyContainer = document.getElementsByTagName("Body").item(0);
            bodyContainer.appendChild(alp_div_obj);
         }
         //Reference the 'object' (or change the attribute) the user typed in.
         try {
            alp_doc_obj = eval(inVal);
         }
         catch(e){
            alert("Try using a different object reference instead.");
            alp_txt_obj.focus();
            alp_txt_obj.select();
            return false;  //don't continue the rest of the statements...
         }

         //Get all the attributes from the browser and then sort them
         for (alp_obj_value in alp_doc_obj) {
           alp_obj_value_array[alp_pos] = alp_obj_value;
           alp_pos++;
         }
         alp_obj_value_array.sort();

         //Display attributes and their values
         alp_div_obj.innerHTML = "Object passed in: <b>" + alp_txt_obj.value + "<\/b><br \/><br \/>";
         for (alp_pos=0; alp_pos < alp_obj_value_array.length; alp_pos++) {
         //Not showing innerHTML or outerHTML attributes yet as the actual controls will be created
         // on the page and it could make for some interesting problems.
              if (alp_obj_value_array[alp_pos] == "outerHTML" ) {
                      alp_outer_pos = alp_pos;
              }
              else if (alp_obj_value_array[alp_pos] == "innerHTML") {
                      alp_inner_pos = alp_pos;
              }
         //Show what the attribute/object is currently referencing.
              else {
                 try {
                    alp_div_obj.innerHTML += "<b>" + alp_obj_value_array[alp_pos] + "<\/b> has stored: " +
      alp_doc_obj[alp_obj_value_array[alp_pos]] + "<br \/>";
                 } catch(e){ alp_div_obj.innerHTML += "<b>" + alp_obj_value_array[alp_pos] + "<\/b> gives an error!<br \/>";}
              }
         }
         /// Need to create BOTH textarea controls first (otherwise error). ////
         if (alp_inner_pos != -1) {
           alp_div_obj.innerHTML += "<b>innerHTML<\/b> has stored:<br \/><textarea rows=10 cols=90 id=alp_JS_info_3><\/textarea><br \/>";
         }
         if (alp_outer_pos != -1) {
               alp_div_obj.innerHTML += "<b>outerHTML<\/b> has stored:<br \/><textarea rows=10 cols=90 id=alp_JS_info_4><\/textarea>";
         }
         alp_div_obj.innerHTML += "<br \/>Total Shown: " + alp_obj_value_array.length;

         ///////////////////////////////////////////////////////////////////////
         /// Now Populate the controls appropriately.///////////////////////////
         if (alp_inner_pos != -1) {
           alp_div_obj = document.getElementById("alp_JS_info_3");
               alp_div_obj.value = alp_doc_obj[alp_obj_value_array[alp_inner_pos]];
         }
         if (alp_outer_pos != -1) {
               alp_div_obj = document.getElementById("alp_JS_info_4");
               alp_div_obj.value = alp_doc_obj[alp_obj_value_array[alp_outer_pos]];
         }
         ///////////////////////////////////////////////////////////////////////
      }
</script>
