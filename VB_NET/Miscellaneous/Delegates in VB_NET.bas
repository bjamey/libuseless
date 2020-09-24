' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Delegates in VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'Author     : Pramod Kumar Singh
'Purpose    : To show HOW Delegates WORKS in VB7
'Applicatio : Console
'Date       : 5th Jan 2001
'History   :

Module Module1
    'Define a Delegate
    Delegate Sub CompareFunc(ByVal x As Integer, _
      ByVal y As Integer, ByRef b As Boolean)
    'Define a Event that will be used in AddHandler

    Public Event a As CompareFunc
    'Bubble Sort Algorithm which calles Delegates to perform work
    Function BubbleSort(ByVal SortHigher As CompareFunc, _
        ByVal IntArray() As Integer) As Integer()
        Dim I, J, Value, Temp As Integer
        Dim b As Boolean
        For I = 0 To Ubound(IntArray)
            Value = IntArray(I)
            For J = I + 1 To UBound(IntArray)
                Try
                    SortHigher.Invoke(IntArray(J), Value, b)
                    If b = True Then
                        Temp = IntArray(J)
                        IntArray(J) = Value
                        IntArray(I) = Temp
                        Value = Temp
                    End If
                Catch
                    'Add error handling here, or just proceed
                End Try
            Next J
        Next I
    End Function

    'Actual Event handling , called by Delgates
    Sub Fire(ByVal x As Integer, ByVal y As Integer, ByRef b As Boolean)
        If y > x Then
            b = True
        Else
            b = False
        End If
    End Sub

    'Entry point
    Sub Main()
        Dim IntArray() As Integer = {12, 1, 96, 56, 70}
        Dim iArrayCount As Integer
        Dim iCounter As Integer
        ' Add a delegate Handler
        AddHandler a, (AddressOf Fire)
        'Define Array for Sorting
        iArrayCount = IntArray.Length
        Console.WriteLine("Integer array to be sorted")
        For iCounter = 0 To iArrayCount - 1
            Console.WriteLine(" Value at{0} is {1} ", _
                 iCounter, IntArray(iCounter))
        Next
        'Call the method which is going to raise events
        BubbleSort(Module1.aEvent, IntArray)
        iArrayCount = IntArray.Length
        Console.WriteLine("Integer array after Bubble Sort with Delegate")
        'Display the Data to user on Console
        For iCounter = 0 To iArrayCount - 1
            Console.WriteLine(" Value at{0} is {1}", _
              iCounter, IntArray(iCounter))
        Next

    End Sub
End Module
