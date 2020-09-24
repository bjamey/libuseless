'' ----------------------------------------------------------------------------
''                                               DTT (c)2005 FSL - FreeSoftLand
'' Title: TRACKER
''
'' Date : 12/10/2005
'' By   : Shoptalk Systems
'' ----------------------------------------------------------------------------


    'NOTE:  This is the solution to our final lesson.

    'TRACKER.BAS
    'Week 6 Just BASIC Course
    'Copyright 2004 Shoptalk Systems
    'All Rights Reserved
    'This is our wrap-up application for our Just BASIC course
    '------------------------------------------------------------------

    'Dimension our sales lead data array for 500 records.
    dim leads$(500, 13)

    'Dimension our arrays for displaying names in the listbox.
    dim leadNames$(500)
    dim leadIndices(500)

    'Load our bitmaps.
    loadbmp "letter", "letter.bmp"
    loadbmp "call", "call.bmp"
    loadbmp "brochure", "brochure.bmp"
    loadbmp "sale", "sale.bmp"
    loadbmp "deadend", "deadend.bmp"

    'Setup our listbox choices.
    dim eventTypes$(6)
    eventTypes$(0) = "all"
    eventTypes$(1) = "letter"
    eventTypes$(2) = "call"
    eventTypes$(3) = "brochure"
    eventTypes$(4) = "sale"
    eventTypes$(5) = "deadend"
    eventFilter$ = "all"


    'No main window
    nomainwin

    'Set the size of our Window.
    WindowWidth = 400
    WindowHeight = 280


    'Set up the controls and open the window.
    groupbox #main, "", 191, 111, 184, 130
    statictext #main.statictext1, "Sales Leads", 15, 16, 104, 20
    listbox #main.leads, leadNames$(, [leadSelected], 15, 41, 160, 200
    statictext #main.statictext3, "Filter Leads By:", 191, 16, 128, 20
    combobox #main.eventTypes, eventTypes$(, [selectEventType], 191, 41, 144, 115
    button #main.actionButton, "GO!", [action], UL, 319, 76, 56, 20
    statictext #main.action, "No Action", 191, 76, 104, 20
    statictext #main.statictext7, "->", 295, 76, 16, 20
    graphicbox #main.icon, 343, 31, 34, 34
    button #main, "Edit/View Record", [editSalesLead], UL, 207, 131, 152, 20
    button #main, "New Record", [newSalesLead], UL, 207, 156, 152, 20
    button #main, "Edit Letter", [editLetter], UL, 207, 181, 152, 20
    button #main, "Edit Packslip", [editPackslip], UL, 207, 206, 152, 20
    open "Tracker" for dialog as #main
    print #main, "trapclose [quit]"
    print #main.eventTypes, "select all"
    print #main.leads, "singleclickselect"


    'Check to see if our sales lead file exists.
    dim check$(1,1)
    files DefaultDir$, "leads.dat", check$(
    if val(check$(0, 0)) = 1 then gosub [loadLeads]

    gosub [loadNamesList]  'load the listbox


[mainLoop]  'wait here for user input
    input r$
    goto [mainLoop]


[quit]  'exit the program

    gosub [saveLeads]
    close #main
    end



' ==MAIN WINDOW BEHAVIOR==================================================

' This code section manages the listbox, combobox, statictext and other
' controls in the main window, and their interaction with each other.

[loadNamesList]  'fill up our names list with names as appropriate

    if leadCount = 0 then return  'no leads loaded

    nameCount = 0
    for x = 0 to leadCount - 1
        leadNames$(x) = ""
        if leads$(x, 9) = eventFilter$ or eventFilter$ = "all" then _
            leadNames$(nameCount) = leads$(x, 0) + ", " + leads$(x, 1) : _
            leadIndices(nameCount) = x : _
            nameCount = nameCount + 1
    next x

    print #main.leads, "reload"

  return


[selectEventType]  'draw the icon for the selected status

    print #main.eventTypes, "selection?"
    input #main.eventTypes, eventFilter$


    print #main.icon, "cls"
    if eventFilter$ <> "all" then _
        print #main.icon, "drawbmp "; eventFilter$; " 0 0 ; flush"

    gosub [loadNamesList]
    gosub [updateAction]

    goto [mainLoop]


[updateAction]  'Display what the valid action is now.

    print #main.leads, "selectionindex?"
    input #main.leads, index

    action$ = "No Action"
    if eventFilter$ = "letter" and nameCount > 0 then _
        action$ = "Print Letter(s)"
    if eventFilter$ = "call" and nameCount > 0 and index > 0 then _
        action$ = "Make Call"
    if eventFilter$ = "brochure" and nameCount > 0 and index > 0 then _
        action$ = "Sale is Made"
    print #main.action, action$

  return


[action]  'perform the appropriate action for the GO button

    if action$ = "No Action" then [mainLoop]

    if action$ = "Print Letter(s)" then [printLetters]
    if action$ = "Make Call" then [makeCall]
    if action$ = "Sale is Made" then [receivedOrder]

    goto [mainLoop]


[leadSelected]  'A sales lead was selected.  Update the action.

    gosub [updateAction]

    goto [mainLoop]



' ==LOAD/SAVE SALES LEADS================================================

' This code section contains code for loading and saving our sales lead
' data

[loadLeads]  'Load the leads.dat file.

    'The first line of the file contains a count of the records in
    'the file.
    'Each record consists of the following fields on it's own line
    'so we can use LINE INPUT to read the file.

    '0   Last Name
    '1   First Name and middle initial
    '2   Street address 1
    '3   Street address 2
    '4   City
    '5   State
    '6   Zip Code
    '7   Phone #
    '8   Comment
    '9   Event (letter, call, etc)
    '10  Date of last action
    '11  Status of call
    '12  Dead end flag (0 or 1)

    open "leads.dat" for input as #leadsIn
    input #leadsIn, leadCount
    for x = 0 to leadCount - 1
        for y = 0 to 12
            line input #leadsIn, leadData$
            leads$(x, y) = leadData$
        next y
    next x

    close #leadsIn

  return


[saveLeads]  'save our leads data to leads.dat

    open "leads.dat" for output as #leadsOut
    print #leadsOut, leadCount
    for x = 0 to leadCount - 1
        for y = 0 to 12
            print #leadsOut, leads$(x, y)
        next y
    next x

    close #leadsOut

  return



' ==PRINTING FORM LETTERS==================================================

' This code section contains code that prints our form letter or letters.

[printLetters]  'print form letters

    'Check to see if our letter.txt file exists.
    files DefaultDir$, "letter.txt", check$(
    if val(check$(0, 0)) = 0 then _
        notice "File LETTER.TXT is not available.  Cannot print letter." : _
        goto [mainLoop]

    print #main.leads, "selectionindex?"
    input #main.leads, index
    if index > 0 then recordIndex = leadIndices(index - 1)

    'print a single letter if a sales lead is selected
    if index > 0 then _
        gosub [printLetterNow] : _
        gosub [loadNamesList] : _
        goto [mainLoop]

    confirm "Print letter for all entries?"; answer$
    if answer$ = "yes" then [printAllLetters]

    goto [mainLoop]


[printAllLetters]  'print all the letters

    for x = 0 to nameCount - 1
        recordIndex = leadIndices(x)
        gosub [printLetterNow]
    next x

    gosub [loadNamesList]

    goto [mainLoop]


[printLetterNow]  'print a single letter from letter.txt

    open "letter.txt" for input as #letter
    while eof(#letter) = 0
        line input #letter, aLine$
        while instr(aLine$, "<nameTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<nameTag>") - 1) + _
                leads$(recordIndex, 1) + " " + leads$(recordIndex, 0) + _
                mid$(aLine$, instr(aLine$, "<nameTag>") + 9)
        wend
        while instr(aLine$, "<dateTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<dateTag>") - 1) + _
                date$() + mid$(aLine$, instr(aLine$, "<dateTag>") + 9)
        wend
        lprint aLine$
    wend
    dump
    close #letter
    leads$(recordIndex, 9) = "call"    'set new event status
    leads$(recordIndex, 10) = date$()  'set date of last action to today

  return


[editLetter]  'Run Notepad to edit letter.txt

    run "notepad.exe " + DefaultDir$ + "\letter.txt"

    goto [mainLoop]


[editPackslip]  'Run Notepad to edit packslip.txt

    run "notepad.exe " + DefaultDir$ + "\packslip.txt"

    goto [mainLoop]



' ==ENTER NEW LEAD OR EDIT AN EXISTING LEAD================================

' This section of code opens a dialog box for either entering a new lead
' record, or for editing an existing one.  There are a couple of subroutines
' in this section to share common code for the new lead and edit lead parts.

[newSalesLead]  'Open a window for creating a new lead record.

    gosub [setupCommonControls]

    button #leadInfo.default, "&Accept", [acceptNewLeadInfo], UL, 319, 16, 64, 25
    button #leadInfo.button20, "&Cancel", [cancelLeadInfo], UL, 319, 51, 64, 25
    open "Add New Sales Lead" for dialog_modal as #leadInfo
    print #leadInfo, "trapclose [acceptNewLeadInfo]"

    goto [mainLoop]


[acceptNewLeadInfo]   'Accept the new lead info.

    recordIndex = leadCount
    gosub [sharedAcceptCode]
    close #leadInfo
    leads$(leadCount, 9) = "letter"
    leads$(leadCount, 12) = "0"
    leadCount = leadCount + 1
    gosub [loadNamesList]

    goto [mainLoop]


[acceptLeadInfo]   'Accept the edited lead info.

    gosub [sharedAcceptCode]
    close #leadInfo
    gosub [loadNamesList]

    goto [mainLoop]


[cancelLeadInfo]  'Close the lead info window.  Don't save info

    close #leadInfo

    goto [mainLoop]


[sharedAcceptCode]  'This code is used by both New and Edit sales leads.

    print #leadInfo.firstName, "!contents?";
    input #leadInfo.firstName, text$
    leads$(recordIndex, 1) = text$
    print #leadInfo.lastName, "!contents?";
    input #leadInfo.lastName, text$
    leads$(recordIndex, 0) = text$
    print #leadInfo.phone, "!contents?";
    input #leadInfo.phone, text$
    leads$(recordIndex, 7) = text$
    print #leadInfo.address, "!contents?";
    input #leadInfo.address, text$
    leads$(recordIndex, 2) = text$
    print #leadInfo.address2, "!contents?";
    input #leadInfo.address2, text$
    leads$(recordIndex, 3) = text$
    print #leadInfo.city, "!contents?";
    input #leadInfo.city, text$
    leads$(recordIndex, 4) = text$
    print #leadInfo.state, "!contents?";
    input #leadInfo.state, text$
    leads$(recordIndex, 5) = text$
    print #leadInfo.zip, "!contents?";
    input #leadInfo.zip, text$
    leads$(recordIndex, 6) = text$
    print #leadInfo.comment, "!contents?";
    input #leadInfo.comment, text$
    leads$(recordIndex, 8) = text$

  return


[editSalesLead]  'open a window for editing a lead record

    print #main.leads, "selectionindex?"
    input #main.leads, index
    if index = 0 then [mainLoop]
    recordIndex = leadIndices(index - 1)

    gosub [setupCommonControls]

    button #leadInfo.default, "&Accept", [acceptLeadInfo], UL, 319, 16, 64, 25
    button #leadInfo.button20, "&Cancel", [cancelLeadInfo], UL, 319, 51, 64, 25
    open "Edit Sales Lead" for dialog_modal as #leadInfo
    print #leadInfo, "trapclose [acceptLeadInfo]"

    print #leadInfo.firstName, leads$(recordIndex, 1)
    print #leadInfo.lastName, leads$(recordIndex, 0)
    print #leadInfo.phone, leads$(recordIndex, 7)
    print #leadInfo.address, leads$(recordIndex, 2)
    print #leadInfo.address2, leads$(recordIndex, 3)
    print #leadInfo.city, leads$(recordIndex, 4)
    print #leadInfo.state, leads$(recordIndex, 5)
    print #leadInfo.zip, leads$(recordIndex, 6)
    print #leadInfo.comment, leads$(recordIndex, 8)

    goto [mainLoop]


[setupCommonControls]

    WindowWidth = 408
    WindowHeight = 295

    textbox #leadInfo.firstName, 103, 16, 200, 25
    statictext #leadInfo.statictext1, "Last Name", 15, 51, 80, 20
    textbox #leadInfo.lastName, 103, 46, 200, 25
    statictext #leadInfo.statictext3, "First Name", 15, 21, 80, 20
    textbox #leadInfo.phone, 103, 76, 200, 25
    statictext #leadInfo.statictext5, "Address 1", 15, 111, 80, 20
    textbox #leadInfo.address, 103, 106, 200, 25
    statictext #leadInfo.statictext7, "Address 2", 15, 141, 80, 20
    textbox #leadInfo.address2, 103, 136, 200, 25
    statictext #leadInfo.statictext9, "City", 15, 171, 40, 20
    textbox #leadInfo.city, 103, 166, 200, 25
    statictext #leadInfo.statictext11, "State", 15, 201, 48, 20
    textbox #leadInfo.state, 103, 196, 48, 25
    statictext #leadInfo.statictext13, "Zip", 167, 201, 32, 20
    textbox #leadInfo.zip, 199, 196, 104, 25
    statictext #leadInfo.statictext16, "Phone #", 15, 81, 56, 20
    statictext #leadInfo.statictext17, "Comment", 15, 231, 56, 20
    textbox #leadInfo.comment, 103, 226, 200, 25

  return



' ==FOLLOW UP CALL===========================================================

[makeCall]  'display phone call information for making a call

    WindowWidth = 312
    WindowHeight = 200

    statictext #phoneCall.name, "-name-", 31, 21, 240, 20
    statictext #phoneCall.phone, "-phone-", 31, 41, 240, 20
    statictext #phoneCall.lastAction, "-date-", 31, 61, 240, 20
    statictext #phoneCall.statictext5, "Comment", 15, 96, 64, 20
    textbox #phoneCall.comment, 87, 91, 200, 25
    button #phoneCall.button3, "No Contact", [callNoContact], UL, 15, 131, 80, 25
    button #phoneCall.button4, "Contact Made", [callContactMade], UL, 103, 131, 104, 25
    button #phoneCall.button7, "Dead End", [callDeadEnd], UL, 215, 131, 72, 25
    open "Make Phone Call" for dialog_modal as #phoneCall
    print #phoneCall, "trapclose [callNoContact]"

    recordIndex = leadIndices(index - 1)
    print #phoneCall.name, leads$(recordIndex, 1); " "; leads$(recordIndex, 0)
    print #phoneCall.phone, leads$(recordIndex, 7)
    print #phoneCall.lastAction, "Opening letter sent: "; leads$(recordIndex, 10)
    print #phoneCall.comment, leads$(recordIndex, 8)

    goto [mainLoop]


[callNoContact]   'No contact.  Close the window.

    gosub [callGetComment]
    close #phoneCall

    goto [mainLoop]


[callContactMade]   'Contact is made!  Upgrade to brochure event status

    gosub [callGetComment]
    leads$(recordIndex, 9) = "brochure"
    leads$(recordIndex, 10) = date$()
    close #phoneCall

    goto [mainLoop]


[callDeadEnd]   'Perform action for the button named 'button7'

    gosub [callGetComment]
    leads$(recordIndex, 9) = "deadend"
    leads$(recordIndex, 10) = date$()
    close #phoneCall

    goto [mainLoop]


[callGetComment]  'shared code for extracting the comment field

    print #phoneCall.comment, "!contents?";
    input #phoneCall.comment, answer$
    leads$(recordIndex, 8) = answer$

  return


' ==SALE IS MADE============================================================

' This section of the program displays a sales lead and gives the option to
' print a packing slip and update the lead's status to sale.

[receivedOrder]  'The customer ordered after receiving brochure!

    WindowWidth = 312
    WindowHeight = 200

    statictext #brochure.name, "-name-", 31, 21, 240, 20
    statictext #brochure.phone, "-phone-", 31, 41, 240, 20
    statictext #brochure.lastAction, "-date-", 31, 61, 240, 20
    statictext #brochure, "Comment", 15, 96, 64, 20
    textbox #brochure.comment, 87, 91, 200, 25
    button #brochure.button3, "&Print Slip!", [printSlip], UL, 15, 131, 192, 25
    button #brochure.button4, "&Cancel", [cancelNoOrder], UL, 215, 131, 72, 25
    open "Brochure Inspires Sale!" for dialog_modal as #brochure
    print #brochure, "trapclose [cancelNoOrder]"

    recordIndex = leadIndices(index - 1)
    print #brochure.name, leads$(recordIndex, 1); " "; leads$(recordIndex, 0)
    print #brochure.phone, leads$(recordIndex, 7)
    print #brochure.lastAction, "Brochure was sent: "; leads$(recordIndex, 10)
    print #brochure.comment, leads$(recordIndex, 8)

    goto [mainLoop]


[cancelNoOrder]   'No sale.  Close the window.

    gosub [orderGetComment]
    close #brochure

    goto [mainLoop]


[printSlip]   'Sale is made!  Upgrade to sale event status and print slip

    gosub [orderGetComment]
    leads$(recordIndex, 9) = "sale"
    leads$(recordIndex, 10) = date$()
    close #brochure

    'Check to see if our packslip file exists.
    files DefaultDir$, "packslip.txt", check$(
    if val(check$(0, 0)) = 0 then _
        notice "PACKSLIP.TXT not found.  Can't print packing slip!" : _
        goto [mainLoop]

    open "packslip.txt" for input as #packslip
    while eof(#packslip) = 0
        line input #packslip, aLine$
        while instr(aLine$, "<nameTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<nameTag>") - 1) + _
                leads$(recordIndex, 1) + " " + leads$(recordIndex, 0) + _
                mid$(aLine$, instr(aLine$, "<nameTag>") + 9)
        wend
        while instr(aLine$, "<address1Tag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<address1Tag>") - 1) + _
                leads$(recordIndex, 2) + _
                mid$(aLine$, instr(aLine$, "<address1Tag>") + 13)
        wend
        while instr(aLine$, "<address2Tag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<address2Tag>") - 1) + _
                leads$(recordIndex, 3) + _
                mid$(aLine$, instr(aLine$, "<address2Tag>") + 13)
        wend
        while instr(aLine$, "<cityTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<cityTag>") - 1) + _
                leads$(recordIndex, 4) + _
                mid$(aLine$, instr(aLine$, "<cityTag>") + 9)
        wend
        while instr(aLine$, "<stateTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<stateTag>") - 1) + _
                leads$(recordIndex, 5) + _
                mid$(aLine$, instr(aLine$, "<stateTag>") + 10)
        wend
        while instr(aLine$, "<zipTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<zipTag>") - 1) + _
                leads$(recordIndex, 6) + _
                mid$(aLine$, instr(aLine$, "<zipTag>") + 8)
        wend
        while instr(aLine$, "<dateTag>") > 0
            aLine$ = left$(aLine$, instr(aLine$, "<dateTag>") - 1) + _
                date$() + mid$(aLine$, instr(aLine$, "<dateTag>") + 9)
        wend
        lprint aLine$
    wend
    dump
    close #packslip

    goto [mainLoop]


[orderGetComment]  'shared code for extracting the comment field

    print #brochure.comment, "!contents?";
    input #brochure.comment, answer$
    leads$(recordIndex, 8) = answer$

  return

