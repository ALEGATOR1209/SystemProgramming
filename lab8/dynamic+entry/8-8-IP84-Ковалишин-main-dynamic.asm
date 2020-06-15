.486
.model flat, stdcall
option casemap :none

include \masm32\include\user32.inc   ; proto for MessabeBox function
include \masm32\include\kernel32.inc ; protos for LoadLibrary, GetProcAddress, FreeLibrary, ExitProcess
include \masm32\include\msvcrt.inc   ; proto for crt_sprintf

includelib \masm32\lib\user32.lib    ; implementation of MessabeBox
includelib \masm32\lib\kernel32.lib  ; implementations of LoadLibrary, GetProcAddress, FreeLibrary, ExitProcess
includelib \masm32\lib\msvcrt.lib    ; implementation of crt_sprintf

pushRef MACRO n
    LEA     EAX, n
    PUSH    EAX
ENDM

getExpression MACRO i, buff
    pushRef res[i*8]
    pushRef d[i*8]
    pushRef c_[i*8]
    pushRef b[i*8]
    pushRef a[i*8]
    CALL    [calc]

    .IF EBX == 1
        INVOKE crt_sprintf, ADDR buff_res, ADDR msg_err_1
    .ELSEIF EBX == 2
        INVOKE crt_sprintf, ADDR buff_res, ADDR msg_err_2
    .ELSE
        INVOKE crt_sprintf, ADDR buff_res, ADDR msg_num, res[i*8]
    .ENDIF

    INVOKE crt_sprintf, buff, ADDR msg_final, a[i*8], b[i*8], c_[i*8], d[i*8], ADDR buff_res
ENDM

.data?
    lib_h                  DD ?
    calc                   DD ?
.data
    ; STRINGS
    msg_title              DB "Лабораторна робота 8", 0
    msg_last_final         DB "Результати обчислень:", 10,
        "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0

    msg_final              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f", 10, "res = %s", 0

    msg_num                DB "%.18f", 0
    msg_err_1              DB "Division by zero.", 0
    msg_err_2              DB "tan: invalid argument.", 0
    msg_lib_error          DB "Library or function not found", 0

    lib_name               DB "8-8-IP84-Ковалишин-lib-entry", 0
    lib_func               DB "calc", 0

    ; BUFFERS
    buff_last_final        DB 40960 DUP (0)
    buff_final             DB 10240 DUP (0)
    buff_final_2           DB 10240 DUP (0)
    buff_final_3           DB 10240 DUP (0)
    buff_final_4           DB 10240 DUP (0)
    buff_final_5           DB 10240 DUP (0)
    buff_size = $ - buff_final_5
    buff_res			   DB 1024	DUP (0)

    current_buff_ADDR      DD 0

    ; VARIABLES
    res                    DQ 5 DUP (0)
    a                      DQ 1.23   , 10.42, -110.54, 12.09 , 1209.0
    b                      DQ -2.34  , -2.39, 34.13  , 6.045 , 120.0
    c_                     DQ 3.14159, 12.50, 0.00035, -9.0  , 1.0e20
    d                      DQ 4.56   , -1.43, 0.51   , -1.2  , 928.2

    MB_OK                  EQU 0
.code
    start:
        INVOKE LoadLibrary, ADDR lib_name
        CMP EAX, 0
        JE lib_error

        MOV lib_h, EAX
        INVOKE GetProcAddress, lib_h, ADDR lib_func
        MOV calc, EAX
        CMP EAX, 0
        JE lib_error

        MOV EDI, 0
        MOV current_buff_ADDR, offset buff_final

        hereWeGoAgain:
        getExpression EDI, current_buff_ADDR

        ADD current_buff_ADDR, buff_size
        INC EDI
        CMP EDI, 5
        JB hereWeGoAgain

        INVOKE crt_sprintf, ADDR buff_last_final, ADDR msg_last_final,
            ADDR buff_final,
            ADDR buff_final_2,
            ADDR buff_final_3,
            ADDR buff_final_4,
            ADDR buff_final_5
        
        INVOKE FreeLibrary, lib_h
        JMP fin

        lib_error:
        INVOKE crt_sprintf, ADDR buff_last_final, ADDR msg_lib_error

        fin:
        INVOKE MessageBox, 0, ADDR buff_last_final, ADDR msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start