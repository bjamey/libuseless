// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Encrypting data from one stream to another and attaching hash of the password
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

using System.Security.Cryptography;
using System.IO;
using System.Data;
using System;
using System.Collections;
using System.ComponentModel;

public class PasswordEncryptor
{
        private byte[] _keyBytes;
        private byte[] _IVBytes;
        private int _bufferSize=256;
        private byte[] _hash;

        public PasswordEncryptor(string password)
        {
                byte[] saltValueBytes  = null;
                PasswordDeriveBytes pdb = new PasswordDeriveBytes(password,saltValueBytes,"SHA1",50);
                _keyBytes = pdb.GetBytes(32);
                _IVBytes = pdb.GetBytes(16);

                HashAlgorithm hasher = SHA256.Create();
                _hash = hasher.ComputeHash(System.Text.ASCIIEncoding.ASCII.GetBytes("password"));
        }

        public void EncryptWithHash(Stream input, ref Stream output)
        {
                output.Write(_hash,0,_hash.Length);

                RijndaelManaged rj = new System.Security.Cryptography.RijndaelManaged();
                rj.Mode= CipherMode.CBC;

                ICryptoTransform trans = rj.CreateEncryptor(_keyBytes, _IVBytes);

                CryptoStream cs = new CryptoStream(output, trans, CryptoStreamMode.Write);

                byte[] bytes = new byte[_bufferSize];

                int byteCount;

                while((byteCount = input.Read(bytes, 0, bytes.Length))!= 0)
                {
                        cs.Write(bytes,0,byteCount);
                }

                cs.FlushFinalBlock();
                //cs.Close();
        }

        public void DecryptWithHash(Stream input, ref Stream output)
        {
                byte[] inputHash = new byte[_hash.Length];
                input.Read(inputHash,0,_hash.Length);

                if (inputHash.Length!=_hash.Length) throw new Exception("Invalid Password");

                for (int i=0;i<_hash.Length;i++)
                {
                        if (_hash[i]!=inputHash[i]) throw new Exception("Invalid Password");
                }

                RijndaelManaged rj = new System.Security.Cryptography.RijndaelManaged();
                rj.Mode= CipherMode.CBC;

                ICryptoTransform trans = rj.CreateDecryptor(_keyBytes, _IVBytes);

                CryptoStream cs = new CryptoStream(input, trans, CryptoStreamMode.Read);

                byte[] bytes = new byte[_bufferSize];

                int byteCount;

                while((byteCount = cs.Read(bytes, 0, bytes.Length))!= 0)
                {
                        output.Write(bytes,0,byteCount);
                }

                cs.Flush();
        }

}
