' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Create a circular form
' 
'  Date : 14/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' ----------------------------
' Constants & API Declarations
' ----------------------------

Private Declare Function CreateEllipticRgn Lib "gdi32" (ByVal X1 As Long, ByVal Y1 As Long, ByVal X2 As Long, ByVal Y2 As Long) As Long
Private Declare Function SetWindowRgn Lib "user32" (ByVal hWnd As Long, ByVal hRgn As Long, ByVal bRedraw As Long) As Long

' --------
' Code
' --------

'place this code in the form load event
Private Sub Form_Load()
    Dim lngRegion As Long
    Dim lngReturn As Long
    Dim lngFormWidth As Long
    Dim lngFormHeight As Long

    lngFormWidth = Me.Width / Screen.TwipsPerPixelX
    lngFormHeight = Me.Height / Screen.TwipsPerPixelY

    lngRegion = CreateEllipticRgn(0, 0, lngFormWidth, lngFormHeight)
    lngReturn = SetWindowRgn(Me.hWnd, lngRegion, True)
End Sub
