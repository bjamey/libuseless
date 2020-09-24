' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Object Serialization IN VB·NET
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Option Strict Off
Imports System
Imports System.IO
Imports System.Runtime.Serialization
Imports System.Runtime.Serialization.Formatters.Binary
Public Module SerializationSample
    'Class Node to hold the Linklist Item. Must be marked as
    'serializable
    <Serializable()> Public Class Node
        Public Value As Integer
        Public NextNode As Node = Nothing
        'Constructor
        Public Sub New(ByVal NewValue As Integer)
            MyBase.New()
            Me.Value = NewValue
        End Sub
    End Class
    'Linked List Class.  MUst be marked with
    'serializable attribute
    <Serializable()> Public Class LinkedList
        Private m_head As Node = Nothing
        Private m_tail As Node = Nothing
        'Adding to Linklist
        Public Function Add(ByVal iValue As Integer) As Boolean
            Dim curNode As Node = m_head
            While Not (curNode Is Nothing)
                If (curNode.Value = iValue) Then Return False
                curNode = curNode.NextNode
            End While
            Dim newNode As Node = New Node(iValue)
            If (m_tail Is Nothing) Then
                m_tail = newNode
                m_head = m_tail
            Else
                m_tail.NextNode = newNode
                m_tail = newNode
            End If
            Return True
        End Function
        'Remove from link list
        Public Function Remove(ByVal iValue As Integer) _
              As Boolean
            Dim prevNode As Node = Nothing
            Dim curNode As Node = m_head

            While Not (curNode Is Nothing)
                If (curNode.Value = iValue) Then
                    If (prevNode Is Nothing) Then
                        If (m_head Is m_tail) Then
                            m_tail = Nothing
                            m_head = m_tail
                        Else
                            m_head = m_head.NextNode
                        End If
                    Else
                        prevNode.NextNode = curNode.NextNode
                        Exit While
                    End If
                    Return True
                End If
                prevNode = curNode
                curNode = curNode.NextNode
            End While
            Return False
        End Function
        'Find a specific node in linklist
        Public Function FindNode(ByVal iValue As Integer) As Node
            Dim curNode As Node = m_head
            While Not (curNode Is Nothing)
                If curNode.Value = iValue Then Return curNode
                curNode = curNode.NextNode
            End While
            Return Nothing
        End Function
        'Swap the Node position in linked list
        Public Function SwapPositions(ByVal iValue1 As Integer, _
          ByVal iValue2 As Integer) As Boolean
            Dim curNode As Node = m_head
            Dim Node1 As Node = Nothing
            Dim Node2 As Node = Nothing
            Dim prevNode As Node = Nothing
            Dim prevNode1 As Node = Nothing
            Dim prevNode2 As Node = Nothing

            If iValue1 = iValue2 Then
                Return False
            End If

            While Not (curNode Is Nothing)
                If (curNode.Value = iValue1) Then
                    prevNode1 = prevNode
                    Node1 = curNode
                ElseIf (curNode.Value = iValue2) Then
                    prevNode2 = prevNode
                    Node2 = curNode
                End If

                If (Not (Node1 Is Nothing)) And (Not (Node2 Is Nothing)) Then
                    Exit While
                End If

                prevNode = curNode
                curNode = curNode.NextNode
            End While

            If Node1 Is Nothing Or Node2 Is Nothing Then _
                 Return False

            If (prevNode1 Is Nothing) Then
                m_head = Node2
            Else
                prevNode1.NextNode = Node2
            End If
            If (prevNode2 Is Nothing) Then
                m_head = Node1
            Else
                prevNode2.NextNode = Node1
            End If
            Dim tmp As Node = Node1.NextNode
            Node1.NextNode = Node2.NextNode
            Node2.NextNode = tmp

            Return True
        End Function
        'Display
        Public Sub Draw()
            Dim curNode As Node = m_head
            Debug.Write("List: ")
            While Not (curNode Is Nothing)
                Debug.Write(curNode.Value & "  ")
                curNode = curNode.NextNode
            End While
            Debug.WriteLine("")
        End Sub
    End Class
    'Serialization implementation.
    Public Class Ser
        ReadOnly iMinValue As Integer = 1
        ReadOnly iMaxValue As Integer = 9
        Public Sub Scope1()
            Dim list As LinkedList = New LinkedList()
            Dim i As Integer
            Debug.WriteLine("Entering Scope 1")
            Debug.WriteLine("Creating and filling List ..")
            For i = iMinValue To iMaxValue - 1
                list.Add(i)
            Next
            SaveListToDisk(list)
            Debug.WriteLine("Leaving Scope 1\n")
        End Sub
        Public Sub Scope2()
            Debug.WriteLine("Entering Scope 2")
            Dim list As LinkedList = LoadListFromDisk()
            Debug.WriteLine("Swapping Entries")
            Debug.WriteLine("Swapping 1 and 2")
            list.SwapPositions(1, 2)
            Debug.WriteLine("Swapping 3 and 4")
            list.SwapPositions(3, 4)
            Debug.WriteLine("Swapping 5 and 6")
            list.SwapPositions(5, 6)
            Debug.WriteLine("Swapping 7 and 8")
            list.SwapPositions(7, 8)
            SaveListToDisk(list)
            Debug.WriteLine("Leaving Scope 2\n")
        End Sub
        Public Sub Scope3()
            Debug.WriteLine("Entering Scope 3")
            Dim list As LinkedList = LoadListFromDisk()
            Debug.WriteLine("Swapping Random Entries")
            Dim rnd As Random = New Random()
            Dim num1, num2, i As Integer
            For i = 0 To 15
                While (True)
                    num1 = rnd.Next(iMinValue, iMaxValue + 1)
                    num2 = rnd.Next(iMinValue, iMaxValue + 1)
                    If num1 <> num2 Then
                        Exit While
                    End If
                End While
                Debug.WriteLine("Swapping " & num1 _
                      & " and " & num2)
                list.SwapPositions(num1, num2)
            Next
            SaveListToDisk(list)
            Debug.WriteLine("Leaving Scope 3\n")
        End Sub

        Public Sub Scope4()
            Debug.WriteLine("Entering Scope 4")
            Dim list As LinkedList = LoadListFromDisk()
            Debug.WriteLine("Removing Entries")
            Debug.WriteLine("Removing 1")
            list.Remove(1)
            Debug.WriteLine("Removing 2")
            list.Remove(2)
            Debug.WriteLine("Removing 3")
            list.Remove(3)
            SaveListToDisk(list)
            Debug.WriteLine("Leaving Scope 4\n")
        End Sub
        Private Function LoadListFromDisk() As LinkedList
            Debug.WriteLine _
                ("Deserializing LinkedList from file ..")
            Dim s As Stream = New FileStream("linkedlist.bin", FileMode.Open)
            Dim b As BinaryFormatter = New BinaryFormatter()
            'This casting requires option strict option of vb to
            ' be off
            'While compliing the code use the
            ' switch /optionstrict-
            Dim list As LinkedList = b.Deserialize(s)

            s.Close()
            list.Draw()
            Return list
        End Function
        Private Sub SaveListToDisk(ByRef list As LinkedList)
            list.Draw()



            Debug.WriteLine _
             ("Serializing LinkedList to file ..")

            Dim s As Stream = New FileStream("linkedlist.bin", FileMode.Create)



            Dim b As BinaryFormatter = New BinaryFormatter()
            b.Serialize(s, list)
            s.Close()
        End Sub

    End Class
    Sub Main()
        Dim SerSample As Ser = New Ser()
        With SerSample
            .Scope1()
            .Scope2()
            .Scope3()
            .Scope4()
        End With
    End Sub

End Module
