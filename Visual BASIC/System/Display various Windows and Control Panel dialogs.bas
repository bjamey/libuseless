' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Display various Windows and Control Panel dialogs
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' -------
' Code
' -------

Sub CP_Dialog()
    ' Launch Control Panel Dialog

    Dim dblReturn As Double

    ' Depending on the dialog, replace "rundll32.exe shell..." with the correspondant command line below
    dblReturn = Shell("rundll32.exe shell32.dll,Control_RunDLL access.cpl,,1", 1)
End Sub



'Control Panel    ( CONTROL.EXE )
'--------------------------------
'Control Panel:
'    rundll32.exe shell32.dll,Control_RunDLL
'
'Add/Remove Programs    ( APPWIZ.CPL )
'-------------------------------------
'Add/Remove Programs Properties (Install/Uninstall):
'    rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,1
'Add/Remove Programs Properties (Windows Setup):
'    rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,2
'Add/Remove Programs Properties (Startup Disk):
'    rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,3
'
'Display Options    ( DESK.CPL )
'-------------------------------
'Display Properties (Background):
'    rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
'Display Properties (Screen Saver):
'    rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1
'Display Properties (Appearance):
'    rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,2
'Display Properties (Settings):
'    rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,3
'
'Regional Settings    ( INTL.CPL )
'---------------------------------
'Regional Settings Properties (Regional Settings):
'    rundll32.exe shell32.dll,Control_RunDLL intl.cpl,,0
'Regional Settings Properties (Number):
'    rundll32.exe shell32.dll,Control_RunDLL intl.cpl,,1
'Regional Settings Properties (Currency):
'    rundll32.exe shell32.dll,Control_RunDLL intl.cpl,,2
'Regional Settings Properties (Time):
'    rundll32.exe shell32.dll,Control_RunDLL intl.cpl,,3
'Regional Settings Properties (Date):
'    rundll32.exe shell32.dll,Control_RunDLL intl.cpl,,4
'
'Joystick Options    ( JOY.CPL )
'-------------------------------
'Joystick Properties (Joystick):
'    rundll32.exe shell32.dll,Control_RunDLL joy.cpl
'
'Mouse/Keyboard/Printers/Fonts Options    ( MAIN.CPL )
'-----------------------------------------------------
'Mouse Properties:
'    rundll32.exe shell32.dll,Control_RunDLL main.cpl @0
'Keyboard Properties:
'    rundll32.exe shell32.dll,Control_RunDLL main.cpl @1
'Printers:
'    rundll32.exe shell32.dll,Control_RunDLL main.cpl @2
'Fonts:
'    rundll32.exe shell32.dll,Control_RunDLL main.cpl @3
'
'Mail and Fax Options    ( MLCFG32.CPL )
'---------------------------------------
'Microsoft Exchange Profiles (General):
'    rundll32.exe shell32.dll,Control_RunDLL mlcfg32.cpl
'
'Multimedia/Sounds Options    ( MMSYS.CPL )
'------------------------------------------
'Multimedia Properties (Audio):
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,0
'Multimedia Properties (Viedo):
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,1
'Multimedia Properties (MIDI):
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,2
'Multimedia Properties (CD Music):
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,3
'Multimedia Properties (Advanced):
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,4
' = = = = = = = = = = = = = = = = = = = = = = = = = = =
'Sounds Properties:
'    rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl @1
'
'Modem Options    ( MODEM.CPL )
'------------------------------
'Modem Properties (General):
'    rundll32.exe shell32.dll,Control_RunDLL modem.cpl
'
'Network Options    ( NETCPL.CPL )
'---------------------------------
'Network (Configuration):
'    rundll32.exe shell32.dll,Control_RunDLL netcpl.cpl
'
'Password Options    ( PASSWORD.CPL )
'------------------------------------
'Password Properties (Change Passwords):
'    rundll32.exe shell32.dll,Control_RunDLL password.cpl
'
'System/Add New Hardware Options    ( SYSDM.CPL )
'------------------------------------------------
'System Properties (General):
'    rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,0
'System Properties (Device Manager):
'    rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,1
'System Properties (Hardware Profiles):
'    rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,2
'System Properties (Performance):
'    rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,3
' = = = = = = = = = = = = = = = = = = = = = = = = = = =
'Add New Hardware Wizard:
'    rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl @1
'
'Date and Time Options    ( TIMEDATE.CPL )
'-----------------------------------------
'Date/Time Properties:
'    rundll32.exe shell32.dll,Control_RunDLL timedate.cpl
'
'Microsoft Mail Postoffice Options    ( WGPOCPL.CPL )
'----------------------------------------------------
'Microsoft Workgroup Postoffice Admin:
