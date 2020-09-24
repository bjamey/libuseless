' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: How to Track Web Visitors Sessions
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Public Class SessionTracker
    Private _context As HttpContext
    Private _expires As Date

    Private _VisitCount As String

    Private _UserHostAddress As String
    Private _UserAgent As String

    Private _OriginalReferrer As String
    Private _OriginalURL As String

    Private _SessionReferrer As String
    Private _SessionURL As String

    Private _browser As HttpBrowserCapabilities

    Private _pages As New ArrayList()

    Public Sub New()
        'HttpContext.Current allows us to gain access to all
        'the intrinsic ASP context objects like Request, Response, Session, etc
        _context = HttpContext.Current

        'provides a default expiration for cookies
        _expires = Now.AddYears(1)

        'load up the tracker
        incrementVisitCount()

        _UserHostAddress = _context.Request.UserHostAddress.ToString
        _UserAgent = _context.Request.UserAgent.ToString

        If Not IsNothing(_context.Request.UrlReferrer) Then
            'set original referrer if not set
            setOriginalReferrer(_context.Request.UrlReferrer.ToString)
            _SessionReferrer = _context.Request.UrlReferrer.ToString
        End If

        If Not IsNothing(_context.Request.Url) Then
            'set original url if not set
            setOriginalURL(_context.Request.Url.ToString)
            _SessionURL = _context.Request.Url.ToString
        End If

        'set the browser capabilities
        _browser = _context.Request.Browser

    End Sub

    'increment the visit count and save in a cookie
    Public Sub incrementVisitCount()
        Const KEY = "VisitCount"

        'check is cookie has been set yet
        If IsNothing(_context.Request.Cookies.Get(KEY)) Then
            _VisitCount = 1
        Else
            _VisitCount = _context.Request.Cookies.Get(KEY).Value + 1
        End If

        'set or reset the cookie
        addCookie(KEY, _VisitCount)
    End Sub

    'set the original referrer to a cookie
    Public Sub setOriginalReferrer(ByVal val As String)
        Const KEY = "OriginalReferrer"

        'check is cookie has been set yet
        If Not IsNothing(_context.Request.Cookies.Get(KEY)) Then
            _OriginalReferrer = _context.Request.Cookies.Get(KEY).Value
        Else
            addCookie(KEY, val)
            _OriginalReferrer = val
        End If
    End Sub

    'set the original url to a cookie
    Public Sub setOriginalURL(ByVal val As String)
        Const KEY = "OriginalURL"

        'check is cookie has been set yet
        If Not IsNothing(_context.Request.Cookies.Get(KEY)) Then
            _OriginalURL = _context.Request.Cookies.Get(KEY).Value
        Else
            addCookie(KEY, val)
            _OriginalURL = val
        End If
    End Sub

    'add the page to an arraylist in the session
    Public Sub addPage(ByVal pageName As String)
        'create a new page tracker item
        Dim pti As New SessionTrackerPage()
        pti.PageName = pageName
        'set a time stamp
        pti.Time = Now

        'add the page tracker item to the array list
        _pages.Add(pti)
    End Sub


    Private Sub addCookie(ByVal key As String, ByVal value As String)
        Dim cookie As HttpCookie
        cookie = New HttpCookie(key, value)
        cookie.Expires = _expires
        _context.Response.Cookies.Set(cookie)
    End Sub


#Region "Properties"

    'Visit Count
    ReadOnly Property VisitCount() As Integer
        Get
            Return _VisitCount
        End Get
    End Property

    'Original Referrer
    ReadOnly Property OriginalReferrer() As String
        Get
            Return _OriginalReferrer
        End Get
    End Property

    'Original URL
    ReadOnly Property OriginalURL() As String
        Get
            Return _OriginalURL
        End Get
    End Property

    'Session Referrer
    ReadOnly Property SessionReferrer() As String
        Get
            Return _SessionReferrer
        End Get
    End Property

    'Session URL
    ReadOnly Property SessionURL() As String
        Get
            Return _SessionURL
        End Get
    End Property

    'Session User Host Address (IP)
    ReadOnly Property SessionUserHostAddress() As String
        Get
            Return _UserHostAddress
        End Get
    End Property

    'Session User Agent
    ReadOnly Property SessionUserAgent() As String
        Get
            Return _UserAgent
        End Get
    End Property

    'Pages - array list
    ReadOnly Property Pages() As ArrayList
        Get
            Return _pages
        End Get
    End Property

    'Browser Cap
    ReadOnly Property Browser() As HttpBrowserCapabilities
        Get
            Return _browser
        End Get
    End Property

#End Region

End Class
