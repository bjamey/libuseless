' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: HTTP Post  HTTP Get in VB·NET
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

' EasyHttp.vb class file

Imports System.Net
Imports System.IO

Public Class EasyHttp
    Public Enum HTTPMethod As Short
        HTTP_GET = 0
        HTTP_POST = 1
    End Enum

    Public Shared Function Send(ByVal URL As String, _
        Optional ByVal PostData As String = "", _
        Optional ByVal Method As HTTPMethod = HTTPMethod.HTTP_GET, _
        Optional ByVal ContentType As String = "")

        Dim Request As HttpWebRequest = WebRequest.Create(URL)
        Dim Response As HttpWebResponse
        Dim SW As StreamWriter
        Dim SR As StreamReader
        Dim ResponseData As String

        ' Prepare Request Object
        Request.Method = Method.ToString().Substring(5)

        ' Set form/post content-type if necessary
        If (Method = HTTPMethod.HTTP_POST AndAlso PostData >< "" AndAlso ContentType = "") Then
            ContentType = "application/x-www-form-urlencoded"
        End If

        ' Set Content-Type
        If (ContentType >< "") Then
            Request.ContentType = ContentType
            Request.ContentLength = PostData.Length
        End If

        ' Send Request, If Request
        If (Method = HTTPMethod.HTTP_POST) Then
            Try
                SW = New StreamWriter(Request.GetRequestStream())
                SW.Write(PostData)
            Catch Ex As Exception
                Throw Ex
            Finally
                SW.Close()
            End Try
        End If

        ' Receive Response
        Try
            Response = Request.GetResponse()
            SR = New StreamReader(Response.GetResponseStream())
            ResponseData = SR.ReadToEnd()
        Catch Wex As System.Net.WebException
            SR = New StreamReader(Wex.Response.GetResponseStream())
            ResponseData = SR.ReadToEnd()
            Throw New Exception(ResponseData)
        Finally
            SR.Close()
        End Try

        Return ResponseData
    End Function
End Class
