'' ----------------------------------------------------------------------------
''                                               DTT (c)2005 FSL - FreeSoftLand
'' Title: MYHILO
''
'' Date : 12/10/2005
'' By   : Shoptalk Systems
'' ----------------------------------------------------------------------------

    'MYHILO.BAS  -  Week 4 homework solution, Liberty BASIC course

    'This is a minimalistic program but it demonstrates the basics.
    'You may recognize some of this code from our example program,
    'but most of it is new.  Because we are using a dialog box, we
    'can tab between controls, or we can use the mouse.

    'Don't use a main window
    nomainwin

    'Set the width and height of our dialog box
    WindowWidth = 312
    WindowHeight = 145

    'Set up our controls
    statictext #myhilo.instruct, "Enter your guess here:", 14, 16, 176, 20
    textbox #myhilo.guessField, 14, 41, 216, 25
    button #myhilo.guessNow, "Guess", [guessNow], UL, 238, 41, 50, 25
    statictext #myhilo.status, "Status Line:", 14, 81, 176, 20
    button #myhilo.guessNow, "About", [aboutMyhilo], UL, 238, 81, 50, 25

    'Open our program's dialog box
    open "Myhilo Game -  WK4SOL" for dialog as #myhilo

    'When the user want to close our window, goto [quit]
    print #myhilo, "trapclose [quit]"

    'Let's display our about-box
    gosub [aboutMyhiloSub]


[startGame] 'Start a new game of MYHILO

    guessMe = int(rnd(1)*100) + 1
    print #myhilo.guessField, "-Ready for your guess-"


[myhilo.inputLoop]   'Wait here for input event
    input aVar$
    goto [myhilo.inputLoop]


[guessNow]   'Perform action for the button named 'guessNow'

    'Get the guess from our guessField
    print #myhilo.guessField, "!contents?"
    input #myhilo.guessField, guess

    'Now add one to the count variable to count the guesses
    let count = count + 1

    'Check to see if the guess is right
    if guess = guessMe then [win]

    'Check to see if the guess is too low
    if guess < guessMe then status$ = "Guess higher."

    'Check to see if the guess is too high
    if guess > guessMe then status$ = "Guess lower."

    print #myhilo.status, status$; " "; count; " guesses."

    'Go back and wait for more input
    goto [myhilo.inputLoop]


[win]
    'Beep once and tell how many guesses it took to win
    beep
    print #myhilo.status, "You won in " ; count ; "! Play again."

    'Reset the count variable to zero for the next game
    count = 0

    goto [startGame]


[aboutMyhilo]  'call our about-box subroutine

    gosub [aboutMyhiloSub]
    goto [myhilo.inputLoop]


[aboutMyhiloSub]  'display information about our program

    'We could have used a NOTICE statement here, but I wanted to show
    'how to do this using a modal dialog window type.

    'Set the size of our about box
    WindowWidth = 368
    WindowHeight = 190

    'Create statictext controls and an OK button to close the about box
    statictext #about.stext1, "I have decided on a number between one", 22, 16, 312, 20
    statictext #about.stext2, "and a hundred, and I want you to guess", 22, 36, 320, 20
    statictext #about.stext3, "what it is.  I will tell you to guess", 22, 56, 312, 20
    statictext #about.stext4, "higher or lower, and we'll count up", 22, 76, 296, 20
    statictext #about.stext5, "the number of guesses you use.", 22, 96, 256, 20
    button #about.OK, "OK", [closeAboutBox], UL, 278, 111, 64, 35

    'Open our about dialog box as modal
    open "About Myhilo" for dialog_modal as #about

    'Use the same close code as the OK button
    print #about, "trapclose [closeAboutBox]"

    return


[closeAboutBox]   'Perform action for the button named 'OK'

    close #about
    goto [myhilo.inputLoop]


[quit] 'Quit our MYHILO program

    close #myhilo
    end
