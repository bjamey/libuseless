// ----------------------------------------------------------------------------
//                                               DTT (c)2005 FSL - FreeSoftLand
// Title: ShutDown
//
//        Force system shutdown (NT, 2K, XP, 2K3 only)
//
// Date : 12/10/2005
// By   : FSL
// ----------------------------------------------------------------------------

void __fastcall ShutDown(void) {
    AnsiString sErrore;

    HANDLE hToken;                  // handle of process token
    TOKEN_PRIVILEGES tkp;           // pointer of token structure

    // Get process token

    if (!OpenProcessToken (GetCurrentProcess()
                          ,TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY
                          ,&hToken)) {
        sErrore = "IF_OPEN_PROCESS_TOKEN";          // Error type
        goto Errore;
    }

    // Get LUID privilege

    LookupPrivilegeValue (NULL
                         ,SE_SHUTDOWN_NAME
                         ,&tkp.Privileges[0].Luid);   

    tkp.PrivilegeCount = 1;
    tkp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;

    // Get shutdown privilege for this process

    AdjustTokenPrivileges (hToken
                          ,FALSE
                          ,&tkp
                          ,0
                          ,(PTOKEN_PRIVILEGES) NULL
                          ,0);

    if (GetLastError() != ERROR_SUCCESS) {
        sErrore = "IF_ADJUST_TOKEN_PRIVILEGES";     // Error type
        goto Errore;
    }

    if (InitiateSystemShutdown(NULL, NULL, 10, EWX_SHUTDOWN, false)== 0) {
        sErrore = "InitiateSystemShutdown";        // Error type
        goto Errore;
    }
    return;
Errore:
  sErrore = "ShutDown error: " + sErrore;
  Application->NormalizeTopMosts();
  Application->MessageBox(sErrore.c_str(), "Warning!", MB_OK);
  Application->RestoreTopMosts();
}
