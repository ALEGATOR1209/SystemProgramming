INCLUDE \masm32\include\masm32rt.inc
INCLUDE \masm32\include\Fpu.inc
INCLUDELIB \masm32\lib\Fpu.lib

EXTERN tan:PROTO
EXTERN den:PROTO
EXTERN extrn_res:QWORD
EXTERN mult:PROTO
PUBLIC extrn_a, extrn_b

save MACRO buff, num, error
    .IF error == 1
        INVOKE crt_sprintf, ADDR buff, ADDR msg_err_1
    .ELSEIF error == 2
        INVOKE crt_sprintf, ADDR buff, ADDR msg_err_2
    .ELSE
        INVOKE crt_sprintf, ADDR buff, ADDR msg_num, num
    .ENDIF
ENDM

copyDQ MACRO in, out ; copies dq value from in to out
    MOV     ESI, DWORD ptr in
    MOV     DWORD ptr out, ESI
    MOV     ESI, DWORD ptr in[4]
    MOV     DWORD ptr out[4], ESI
ENDM

; (tg(c) - d * 23) / (2 * b - a)
calc MACRO a, b, c_, d, res
    MOV     error_status, 0

    ; -23 * d
    PUSH    DWORD PTR d[4]
    PUSH    DWORD PTR d
    PUSH    offset temp2
    CALL    mult
    save    buff_temp_1, temp2, error_status

    ; tg(c)
    LEA     ESI, c_
    LEA     ECX, temp1
    CALL    tan
    MOV     error_status, EBX
    save    buff_temp_2, temp1, error_status

    finit
    fld     temp1       ; st(0) = tan(c)
    fld     temp2       ; st(0) = -23d, st(1) = tan(c) 

    fadd    st, st(1)   ; st(0) = tan(c) - d * 23
    fstp     temp1
    save    buff_temp_3, temp1, error_status

    ; 2 * b - a
    copyDQ  a, extrn_a
    copyDQ  b, extrn_b
    CALL    den
    save    buff_temp_4, extrn_res[8], error_status
    save    buff_temp_5, extrn_res, error_status
    .IF error_status == 0
        MOV     error_status, ESI
    .ENDIF

    .IF error_status == 0
        finit
        fld     temp1
        fld     extrn_res
        fdivp   st(1), st
        fstp    res
    .ENDIF

    save    buff_temp_6, res, error_status

ENDM

getExpression MACRO i, buff
    calc a[i*8], b[i*8], c_[i*8], d[i*8], res[i*8]
    save buff_temp_7, res[i*8], error_status

    INVOKE crt_sprintf, buff, ADDR msg_final, a[i*8], b[i*8], c_[i*8], d[i*8], ADDR buff_temp_7,
        ADDR buff_temp_1,
        ADDR buff_temp_2,
        ADDR buff_temp_3,
        ADDR buff_temp_4,
        ADDR buff_temp_5,
        ADDR buff_temp_6

ENDM

.data
    ; STRINGS
    msg_title       DB "Лабораторна робота 6", 0
    msg_last_final  DB "Результати обчислень:", 10,
        "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0

    msg_final              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f", 10, "res = %s", 10, 0, ; uncomment 0 for shorter output
                              "     -23 * d = %s", 10,
                              "     tg(c) = %s", 10,
                              "     tg(c) - d * 23 = %s", 10,
                              "     b * 2 = %s", 10,
                              "     b * 2 - a = %s", 10,
                              "     (tg(c) - d * 23) / (2 * b - a) = %s", 0

    msg_num                DB "%.18f", 0
    msg_err_1              DB "Division by zero.", 0
    msg_err_2              DB "tan: invalid argument.", 0

    ; BUFFERS
    buff_last_final        DB 40960 DUP (0)
    buff_final             DB 10240 DUP (0)
    buff_final_2           DB 10240 DUP (0)
    buff_final_3           DB 10240 DUP (0)
    buff_final_4           DB 10240 DUP (0)
    buff_final_5           DB 10240 DUP (0)
    buff_size = $ - buff_final_5

    buff_temp_1            DB 01280 DUP (0)
    buff_temp_2            DB 01280 DUP (0)
    buff_temp_3            DB 01280 DUP (0)
    buff_temp_4            DB 01280 DUP (0)
    buff_temp_5            DB 01280 DUP (0)
    buff_temp_6            DB 01280 DUP (0)
    buff_temp_7            DB 01280 DUP (0)

    current_buff_ADDR      DD 0

    ; VARIABLES
    res                    DQ 5 DUP (0)
    a                      DQ 1.23   , 10.42, -110.54, 12.09 , 1209.0
    b                      DQ -2.34  , -2.39, 34.13  , 6.045 , 120.0
    c_                     DQ 3.14159, 12.50, 0.00035, -9.0  , 1.0e20
    d                      DQ 4.56   , -1.43, 0.51   , -1.2  , 928.2

    temp1                  DQ 0.0
    temp2                  DQ 0.0
    error_status           DD 0

    ; PUBLICS
    extrn_a                DQ 0.0
    extrn_b                DQ 0.0
.code
    start:
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

        INVOKE MessageBox, 0, ADDR buff_last_final, ADDR msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start