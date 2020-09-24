' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: Cryptogarphy - Data Encryption and Decryption
' 
'  Date : 15/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

'**************************************
' Name: Cryptogarphy - Data Encryption and Decryption
'
' Description:The following sample code shows the creation of a CryptoStream to
'             encrypt a file using the DES algorithm. First, the FileStream that
'             will contain the encrypted file is created. Then, an instance of a
'             DES implementation is created. If an instance of a symmetric or
'             asymmetric algorithm is created without explicit constructor
'             arguments, a random key (or public or private key pair) is
'             generated and default properties are set that cover most encryption
'             or decryption scenarios. A DES encryptor object is created on the
'             DES instance. Next, a CryptoStream is created by passing the
'             FileStream instance and the DES encryptor into the CryptoStream
'             constructor; the stream is set to write mode. Finally, we write a
'             byte array of plain text to the stream and close the stream. The
'             result is a file named "EncryptedFile.txt" which contains the DES
'             encryption of bytearrayinput.
'
' By: Pankaj Nagar
'
'
' Inputs:Stream argument - Defines the stream on which the cryptographic transform
'        is to be performed. Any stream that derives from System.IO.Stream can be
'        plugged in here. For example, pass in an instance of System.IO.FileStream
'        to perform a cryptographic transform on a file.
'
' Returns:The result is a file named "EncryptedFile.txt" which contains the DES
'         encryption of bytearrayinput.
'
'Assumes:Because CryptoStream derives from Stream, it is possible to use
'        CryptoStream to define cryptographic transforms on other cryptographic
'        streams. This makes it possible to chain objects that implement
'        CryptoStream together, for example encrypting a file and computing the
'        hash for the encryption in a single operation.
'
' ICrypto Transformtransform - Defines the cryptographic transform that is to be
' performed on the stream. Because every class that derives from HashAlgorithm
' implements the ICryptoTransform interface, an instance of a hash algorithm can
' be passed in here to take the hash of a stream. All symmetric encryption or
' decryption algorithms that derive from the SymmetricAlgorithm class have
' CreateEncryptor() and CreateDecryptor() functions that return an instance of
' an ICryptoTransform implementation. To define a TripleDES encryption on a
' given stream, call the CreateEncryptor() function on an instance of a TripleDES
' implementation and pass the result into the CryptoStream constructor. Generally,
' any class that implements ICryptoTransform can be passed into the CryptoStream
' constructor.
'
' CryptoStreamMode mode - Defines whether you are reading from or writing to the
' stream. To write to a CryptoStream you must pass CryptoStreamMode.Write into
' the CryptoStream constructor. To read from the stream, CryptoStreamMode.Read
' must be passed into the constructor.
'
'Side Effects:None
'**************************************

Imports System
Imports System.IO
Imports System.Security.Cryptography

Class FileEncrypt
      Public Shared Function ConvertStringToByteArray(s As [String]) As [Byte]()
             Dim ca As [Char]() = s.ToCharArray()
             Dim ba(ca.Length - 1) As [Byte]
             Dim i As Integer
             For i = 0 To ba.Length - 1
                 ba(i) = Convert.ToByte(ca(i))
             Next i

             Return ba
      End Function 'ConvertStringToByteArray

      Public Shared Sub Main()
             Dim fs As New FileStream("EncryptedFile.txt", FileMode.Create, FileAccess.Write)
             ' Creating a file stream
             Console.WriteLine("Enter Some Text to be stored in encrypted file:")
             Dim strinput As [String] = Console.ReadLine()
             Dim bytearrayinput As [Byte]() = ConvertStringToByteArray(strinput)

             ' DES instance with random key
             Dim des As New DESCryptoServiceProvider()

             ' Create DES Encryptor from this instance
             Dim desencrypt As ICryptoTransform = des.CreateEncryptor()

             ' Create Crypto Stream that transforms file stream using des encryption
             Dim cryptostream As New CryptoStream(fs, desencrypt, CryptoStreamMode.Write)

             ' Write out DES encrypted file
             cryptostream.Write(bytearrayinput, 0, bytearrayinput.Length)
             cryptostream.Close()

             ' Create file stream to read encrypted file back
             Dim fsread As New FileStream("EncryptedFile.txt", FileMode.Open, FileAccess.Read)

             ' Create DES Decryptor from our des instance
             Dim desdecrypt As ICryptoTransform = des.CreateDecryptor()

             ' Create crypto stream set to read and do a des decryption transform on
             ' incoming bytes
             Dim cryptostreamDecr As New CryptoStream(fsread, desdecrypt, CryptoStreamMode.Read)

             ' Print out the contents of the decrypted file
             Console.WriteLine(New StreamReader(cryptostreamDecr).ReadToEnd())
             Console.WriteLine ()
             Console.WriteLine ("Press Enter to continue...")
             Console.ReadLine()
      End Sub 'Main
End Class 'FileEncrypt
