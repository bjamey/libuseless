// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Delete Internet Explorer Cache Files
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

{ ----------------------------------------
   Delete Internet Explorer Cache Files
   --
   Required unit: wininet
---------------------------------------- }

procedure DeleteIECache();
var
   lpEntryInfo: PInternetCacheEntryInfo;
   hCacheDir: LongWord (*Handle*);
   dwEntrySize, dwLastError: LongWord;
begin
     // Get size of first entry in dwEntrySize
     dwEntrySize := 0;
     FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);

     // Create structure that can hold entry
     GetMem(lpEntryInfo, dwEntrySize);

     // Get first cache entry and handle to retrieve next entry, output url
     hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
     // if (hCacheDir <> 0) then Memo1.Lines.Add(string(lpEntryInfo^.lpszSourceUrlName));

     // Delete Cache
     DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);

     // Free structure
     FreeMem(lpEntryInfo);

     // Retrieve all subsequent entries
     repeat
           dwEntrySize := 0;
           FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
           dwLastError := GetLastError();
           if GetLastError = ERROR_INSUFFICIENT_BUFFER then
           begin
                GetMem(lpEntryInfo, dwEntrySize);
                // if FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize) then Memo1.Lines.Add(string(lpEntryInfo^.lpszSourceUrlName));

                FreeMem(lpEntryInfo);
           end;
     until dwLastError = ERROR_NO_MORE_ITEMS;
end;
