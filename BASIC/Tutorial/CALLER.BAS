'' ----------------------------------------------------------------------------
''                                               DTT (c)2005 FSL - FreeSoftLand
'' Title: CALLER
''
'' Date : 12/10/2005
'' By   : Shoptalk Systems
'' ----------------------------------------------------------------------------

    'CALLER.LOG
    'Here is the solution to our homework assignment for
    'week 3 of our Just BASIC course
    'Copyright 2004 Shoptalk Systems
    'All rights reserved

[menu]  'display menu options

    cls
    print "**Caller Log Program**"
    print
    print " 1) Enter a phone call"
    print " 2) Search by caller's name"
    print " 3) Search by person called"
    print " 4) Quit"
    print
    print "Choose an option from 1 to 4."
    input ">"; option

    if option < 1 or option > 4 then gosub [badOption]
    if option = 1 then gosub [enterAPhoneCall]
    if option = 2 then gosub [searchByCallersName]
    if option = 3 then gosub [searchByPersonCalled]
    if option = 4 then [quit]

    goto [menu]

[badOption]  'display a notice that a bad selection was made

    print
    beep
    print "Option "; option; " is unsupported."
    print "Press any key."
    dummyVar$ = input$(1)

    return

[enterAPhoneCall]  'accept a phone log entry from the user

    cls
    print "**Enter a Phone Call**"
    print

    input "Caller's name ?"; callersName$
    input "Name of person called ?"; personCalled$
    input "Date of call (press 'Enter' for "+date$()+") ?"; dateOfCall$
    if dateOfCall$ = "" then dateOfCall$ = date$()
    input "Time of call (press 'Enter' for "+time$()+") ?"; timeOfCall$
    if timeOfCall$ = "" then timeOfCall$ = time$()
    input "Purpose of call ?"; purposeOfCall$
    input "Phone # where the caller can be reached ?"; callersPhone$


[saveEditCancelLoop]  'give the user the option to save, edit or abort

    cls
    gosub [displayEntryInfo]
    print "Save, Edit, Cancel Entry (S/E/C)?";
    answer$ = input$(1)

    if answer$ = "S" or answer$ = "s" then gosub [saveEntry] : goto [menu]
    if answer$ = "E" or answer$ = "e" then gosub [editEntry]
    if answer$ = "C" or answer$ = "c" then [menu]

    goto [saveEditCancelLoop]


[displayEntryInfo]  'display call information

    print "           Caller's name : "; callersName$
    print "   Name of person called : "; personCalled$
    print "            Date of call : "; dateOfCall$
    print "            Time of call : "; timeOfCall$
    print "         Purpose of call : "; purposeOfCall$
    print "Caller can be reached at : "; callersPhone$

    return


[editEntry]  'edit call information

    cls
    print "**Edit Caller Entry**"
    print

    print "           Caller's name : "; callersName$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then callersName$ = newEntry$

    print "   Name of person called : "; personCalled$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then personCalled$ = newEntry$

    print "            Date of call : "; dateOfCall$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then dateOfCall$ = newEntry$

    print "            Time of call : "; timeOfCall$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then timeOfCall$ = newEntry$

    print "         Purpose of call : "; purposeOfCall$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then purposeOfCall$ = newEntry$

    print "Caller can be reached at : "; callersPhone$
    input "  Press Enter, or retype > "; newEntry$
    if newEntry$ <> "" then callersPhone$ = newEntry$

    return


[saveEntry]  'write the entry info to PHONELOG.TXT

    open "PHONELOG.TXT" for append as #out

    print #out, callersName$
    print #out, personCalled$
    print #out, dateOfCall$
    print #out, timeOfCall$
    print #out, purposeOfCall$
    print #out, callersPhone$

    close #out

    return


[searchByCallersName]  'look for a phone log entry by caller's name

    cls
    print "**Search by Caller's Name**"
    print
    print "Please enter a partial name to search by."
    input ">"; searchCaller$
    if searchCaller$ = "" then [menu]  'nothing entered, abort search

    searchCaller$ = upper$(searchCaller$) 'convert to uppercase for search

    open "PHONELOG.TXT" for input as #in

    foundFlag = 0
    quitFlag = 0
    if eof(#in) = -1 then [endOfCallerSearch]


[searchByCallerLoop]
    gosub [readEntry]  'get next entry from PHONELOG.TXT
    if instr(upper$(callersName$), searchCaller$) > 0 then gosub [matched]
    if eof(#in) = 0 and quitFlag = 0 then [searchByCallerLoop]


[endOfCallerSearch]
    close #in
    if foundFlag = 0 then print "No matches."
    print "Press any key."
    dummyVar$ = input$(1)
    goto [menu]


[searchByPersonCalled]  'look for a phone log entry by person called

    cls
    print "**Search by Person Called**"
    print
    print "Please enter a partial name to search by."
    input ">"; searchCalled$
    if searchCalled$ = "" then [menu]  'nothing entered, abort search

    searchCalled$ = upper$(searchCalled$) 'convert to uppercase for search

    open "PHONELOG.TXT" for input as #in

    foundFlag = 0
    quitFlag = 0
    if eof(#in) = -1 then [endOfCalledSearch]


[searchByCalledLoop]
    gosub [readEntry]  'get next entry from PHONELOG.TXT
    if instr(upper$(personCalled$), searchCalled$) > 0 then gosub [matched]
    if eof(#in) = 0 and quitFlag = 0 then [searchByCalledLoop]


[endOfCalledSearch]
    close #in
    if foundFlag = 0 then print "No matches."
    print "Press any key."
    dummyVar$ = input$(1)
    goto [menu]


[readEntry]  'read the next entry from PHONELOG.TXT

    line input #in, callersName$
    line input #in, personCalled$
    line input #in, dateOfCall$
    line input #in, timeOfCall$
    line input #in, purposeOfCall$
    line input #in, callersPhone$

    return


[matched]  'stop and show a match & ask what to do next

    foundFlag = 1
    print "---------Match---------"
    gosub [displayEntryInfo]
    print
    print "Next Entry, Quit Searching (N/Q)?"
    answer$ = input$(1)
    'only check for quit response
    if answer$ = "Q" or answer$ = "q" then quitFlag = 1

    return


[quit]  'end CALLER.BAS here

    end
