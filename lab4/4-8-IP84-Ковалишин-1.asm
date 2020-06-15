.386
INCLUDE \masm32\include\masm32rt.inc

IDC_EDIT EQU 1001
IDC_TEXT EQU 1002

MainDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
ErrorDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD
DataDlgProc PROTO :DWORD, :DWORD, :DWORD, :DWORD

printText MACRO text, x, y, w, h
    ; default text ID = 100
    ;; we've just replaced 1 string of code with 5 string macros
    DlgStatic text, 1, x, y, w, h, 100
ENDM

; XOR-based cipher
encode MACRO input, len, key
    MOV EDI, 0 ; returns result back into input buffer
    @@: ;; I was forced to make this useless comment
        MOV AH, key
        XOR input[EDI], AH
        INC EDI
        CMP EDI, len
        JB @B
ENDM

; compares equality of 2 string
compare MACRO str1, str2, len
    MOV EDI, 0 ; returns result in AH
    MOV AH, 0 ;; AH = 0 - strings are equal
    @@:       ;; AH = 1 - string aren't equal
        MOV DL, str1[EDI]
        MOV DH, str2[EDI]
        
        .IF DL != DH
            MOV AH, 1
        .ENDIF

        INC EDI
        .IF EDI < len
            JMP @B
        .ENDIF
ENDM

.data?
    hInstance           DD ?
    usrInput            DB 64 DUP (?)

.data
    msg_title           EQU "Ëàáà 4"
    msg_pass            EQU "Ââåä³òü ïàðîëü, áóäü ëàñêà:"
    msg_data_title      EQU "ÎÑÎÁÈÑÒ² ÄÀÍ²:"
    msg_data_name       EQU "Ï²Á - ÊÎÂÀËÈØÈÍ Î. Þ."
    msg_data_birthday   EQU "ÄÀÒÀ ÍÀÐÎÄÆÅÍÍß - 12.09.2001"
    msg_data_num        EQU "ÍÎÌÅÐ ÇÀË²ÊÎÂÊÈ - 8410"
    msg_error           EQU 10, "Íåïðàâèëüíèé ïàðîëü, ñïðîáóéòå ùå ðàç!", 0
    password            DB "bsd~}d"
    passKey             DB 12h
    passLen             DD 6

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

        printText msg_pass, 0, 5, 150, 8    
        DlgEdit WS_BORDER or ES_WANTRETURN, 3, 20, 140, 9, IDC_EDIT
        DlgButton "OK", WS_TABSTOP, 50, 35, 50, 15, IDOK

        CallModalDialog hInstance, 0, MainDlgProc, NULL
        RET
    mainWindow ENDP

    dataWindow PROC
        Dialog msg_title, "Monotype Corsiva", 20,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            4,                                         \
            50, 50, 150, 75,                            \
            1024
    
        printText msg_data_title,    0, 00, 150, 10
        printText msg_data_name,     0, 10, 150, 10
        printText msg_data_birthday, 0, 20, 150, 10
        printText msg_data_num,      0, 30, 150, 40

        CallModalDialog hInstance, 0, DataDlgProc, NULL
        RET
    dataWindow ENDP

    errorWindow PROC
        Dialog msg_title, "Monotype Corsiva", 15,    \
            WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
            1,                                         \
            50, 50, 150, 30,                            \
            1024
    
        printText msg_error, 0, -5, 150, 20
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

                encode usrInput, passLen, passKey
                compare password, usrInput, passLen
                
                .IF AH != 0
                    JMP error
                .ENDIF

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