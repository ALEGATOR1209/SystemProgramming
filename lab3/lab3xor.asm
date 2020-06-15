.386
INCLUDE \masm32\include\masm32rt.inc

IDC_EDIT EQU 1001
IDC_TEXT EQU 1002

MainDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
ErrorDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
DataDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD

.data?
    hInstance   DD ?
    usrInput    DB 64 DUP (?)

.data
    msg_title  EQU "À‡·‡ 3"
    msg_pass   EQU "¬‚Â‰≥Ú¸ Ô‡ÓÎ¸, ·Û‰¸ Î‡ÒÍ‡:"
    msg_data   EQU 10, "Œ—Œ¡»—“≤ ƒ¿Õ≤:", 10 ,\
        "œ≤¡ -  Œ¬¿À»ÿ»Õ Œ. ﬁ.", 10,      \
        "ƒ¿“¿ Õ¿–Œƒ∆≈ÕÕﬂ - 12.09.2001", 10,\
        "ÕŒÃ≈– «¿À≤ Œ¬ » - 8410", 0
    msg_error  EQU 10, "ÕÂÔ‡‚ËÎ¸ÌËÈ Ô‡ÓÎ¸, ÒÔÓ·ÛÈÚÂ ˘Â ‡Á!", 0
    password   DB "bsd~}d"
    passKey	   DB 12h
    passLen    DWORD 6

.code
    start:
        MOV hInstance, FUNC(GetModuleHandle, NULL)
        CALL mainWindow
        INVOKE ExitProcess, 0

    mainWindow PROC
        Dialog msg_title, "Monotype Corsiva", 20,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            3,                                         \
            50, 50, 150, 75,                            \
            1024
    
        DlgStatic msg_pass, 1, 0, 5, 150, 8, IDC_TEXT
        DlgEdit WS_BORDER or ES_WANTRETURN, 3, 20, 140, 9, IDC_EDIT
        DlgButton "OK", WS_TABSTOP, 50, 35, 50, 15, IDOK
        
        CallModalDialog hInstance, 0, MainDlgProc, NULL
        RET
    mainWindow ENDP

    dataWindow PROC
        Dialog msg_title, "Monotype Corsiva", 20,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            1,                                         \
            50, 50, 150, 75,                            \
            1024
    
        DlgStatic msg_data, 0, 0, 0, 150, 75, IDC_TEXT
        
        CallModalDialog hInstance, 0, DataDlgProc, NULL
        RET
    dataWindow ENDP

    errorWindow PROC
        Dialog msg_title, "Monotype Corsiva", 15,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            1,                                         \
            50, 50, 150, 30,                            \
            1024
    
        DlgStatic msg_error, 1, 0, 0, 150, 20, IDC_TEXT
        CallModalDialog hInstance, 0, ErrorDlgProc, NULL
        RET
    errorWindow ENDP

    MainDlgProc PROC hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
        LOCAL count:DWORD
        .IF uMsg == WM_COMMAND
            .IF wParam == IDOK
                MOV count, FUNC(GetDlgItemText, hWin, IDC_EDIT, ADDR usrInput, 512)
                MOV EAX, passLen
                .IF count != EAX
                    JMP error
                .ENDIF

                MOV EDI, 0
                validation:
                MOV DL, password[EDI]
                MOV DH, usrInput[EDI]
                XOR DH, passKey
                .IF DL != DH
                    JMP error
                .ENDIF

                INC EDI
                .IF EDI == count
                    JMP success
                .ENDIF

                JMP validation

                success:
                    CALL dataWindow
                    RET

                error:
                    CALL errorWindow
                    RET
            .ENDIF
        .ELSEIF uMsg == WM_CLOSE
            INVOKE EndDialog, hWin, 0
        .ENDIF

        XOR EAX, EAX
        RET
    MainDlgProc ENDP

    ErrorDlgProc PROC hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
        .IF uMsg == WM_CTLCOLORSTATIC
            INVOKE SetTextColor, wParam, Red
            INVOKE GetSysColorBrush, COLOR_WINDOW       
            RET
        .ELSEIF uMsg == WM_CLOSE
            INVOKE EndDialog, hWin, 0
        .ENDIF

        XOR EAX, EAX
        RET
    ErrorDlgProc ENDP

    DataDlgProc PROC hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
        .IF uMsg == WM_CTLCOLORSTATIC
            INVOKE SetTextColor, wParam, Blue
            INVOKE GetSysColorBrush, COLOR_WINDOW       
            RET
        .ELSEIF uMsg == WM_CLOSE
            INVOKE EndDialog, hWin, 0
        .ENDIF

        XOR EAX, EAX
        RET
    DataDlgProc ENDP
END start