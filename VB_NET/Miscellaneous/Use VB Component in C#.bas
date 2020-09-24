' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Use VB Component in C#
' 
'  Date : 25/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

Imports System
Namespace hellovb
Public Class HelloString
Public Function GetString() As String
Console.WriteLine ("Hello World in Visual Basic Program")
End Function
End Class
End Namespace



' Compile it using vbc  /t:library hellovb.vb
' This command will generate hellovb.dll
' Hello World program in C# (hellocs.cs)

using System;
namespace hellocs{
   public class displayA
    {
          public void Displayhello()
          {
                 Console.WriteLine("Hello in C# Program");
          }
    }
}

' Compile it using csc  /t:library hellocs.cs
' This command will generate hellocs.dll

' Main program(in c#) in which we will use these libraries

Main Program in C# (maincs.cs)

using System;
using hellocs;
using hellovb;
class maincs
{
     public static void Main()
     {
         hellovb.HelloString vb = new hellovb.HelloString(); // namespace.classname of  hellovb.vb
          vb.GetString();                                                         //Calling vb function
          hellocs.displayA cs = new hellocs.displayA();  // namespace.classname of  hellocs.cs
           cs.Displayhello();                                               //Calling vb function
      }
}



' Compile it using command csc  maincs.cs /r:hellocs.dll;hellovb.dll


' Output will be

' Hello World in Visual Basic Program
' Hello in C# Program
