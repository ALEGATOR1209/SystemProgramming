INCLUDE \masm32\include\masm32rt.inc
include \masm32\include\Fpu.inc
includelib \masm32\lib\Fpu.lib

; saves top of the coprocessor's stack to buff with 15 decimal numbers after point (max for FpuFLtoA) precision
save MACRO buff, saveDQ
    .IF div_zero == 1
        INVOKE crt_sprintf, ADDR buff, ADDR msg_zero
        JMP @F
    .ELSEIF div_zero == 2
        INVOKE crt_sprintf, ADDR buff, ADDR msg_tangens
        JMP @F
    .ENDIF

    INVOKE FpuFLtoA, 0, 15, ADDR buff, SRC1_FPU or SRC2_DIMM

    MOV AL, 1
    CMP AL, saveDQ ; if saveDQ == 1 -> print DQ with 18 numbers after point
    JNE @F
    fst temp
    INVOKE crt_sprintf, ADDR buff[18], ADDR msg_num, temp
    @@:
ENDM

; (tg(c) - d * 23) / (2 * b - a)
calc MACRO a, b, c_, d, res
    MOV     div_zero, 0
    finit

    fld     d           ; st(0) = d
    fld     const[0]    ; st(0) = 23, st(1) = d
    fmul                ; st(0) = d * 23
    save    buff_temp_1, 0

    fld     c_          ; st(0) = c, st(1) = d * 2
    fcom    max
    fstsw   AX
    SAHF
    JNC     tangens_error
    fcom    min
    fstsw   AX
    SAHF
    JC      tangens_error

    fptan               ; st(0) = 1, st(1) = tan(c), st(2) = d * 23
    
    fdivp   st(1), st   ; st(0) = tan(c), st(1) = d * 23
    save    buff_temp_2, 0

    fsub    st, st(1)   ; st(0) = tan(c) - d * 23
    save    buff_temp_3, 0

    fld     const[8]    ; st(0) = 2, st(1) = tan(c) - d * 23
    fld     b           ; st(0) = b, st(1) = 2, st(2) = tan(c) - d * 23
    fmulp   st(1), st   ; st(0) = b * 2, st(1) = tan(c) - d * 23
    save    buff_temp_4, 0

    fld     a           ; st(0) = a, st(1) = b * 2, st(2) = tan(c) - d * 23
    fsubp   st(1), st   ; st(0) = b * 2 - a, st(1) = tan(c) - d * 23
    save    buff_temp_5, 0
    
    fcom    zero
    fstsw   AX
    SAHF
    JZ      division_by_zero
    
    fdivp   st(1), st   ; st(0) = (tan(c) - d * 23) / (2 * b - a)
    JMP     fin

    division_by_zero:
    MOV     div_zero, 1
    JMP     fin

    tangens_error:
    MOV     div_zero, 2
    save    buff_temp_2, 0
    JMP     fin

    fin:
    save    buff_temp_6, 0
    fstp    res
ENDM

getExpression MACRO i, buff
    calc a[i*8], b[i*8], c_[i*8], d[i*8], res[i*8]
    .IF div_zero == 1
        INVOKE crt_sprintf, ADDR buff_temp_7, ADDR msg_zero
    .ELSEIF div_zero == 2
        INVOKE crt_sprintf, ADDR buff_temp_7, ADDR msg_tangens
    .ELSE
        INVOKE crt_sprintf, ADDR buff_temp_7, ADDR msg_res, res[i*8]
    .ENDIF

    INVOKE crt_sprintf, buff, ADDR msg_final, a[i*8], b[i*8], c_[i*8], d[i*8], ADDR buff_temp_7,
        ADDR buff_temp_1,
        ADDR buff_temp_2,
        ADDR buff_temp_3,
        ADDR buff_temp_4,
        ADDR buff_temp_5,
        ADDR buff_temp_6

ENDM

.data
    msg_title       DB "Лабораторна робота 6", 0
    msg_last_final  DB "Результати обчислень:", 10,
        "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0

    msg_final              DB "a = %.18f, b = %.18f, c = %.18f, d = %.18f", 10, "res = %s", 10, ; 0, ; uncomment 0 for shorter output
                              "     d * 23 = %s", 10,
                              "     tg(c) = %s", 10,
                              "     tg(c) - d * 23 = %s", 10,
                              "     b * 2 = %s", 10,
                              "     b * 2 - a = %s", 10,
                              "     (tg(c) - d * 23) / (2 * b - a) = %s", 0

    msg_num                DB "   DQ = %.25f", 0
    msg_res                DB "%.18f", 0
    msg_zero               DB "Division by zero.", 0
    msg_tangens            DB "tan: invalid argument.", 0

    buff_last_final        DB 4096 DUP (0)
    buff_final             DB 1024 DUP (0)
    buff_final_2           DB 1024 DUP (0)
    buff_final_3           DB 1024 DUP (0)
    buff_final_4           DB 1024 DUP (0)
    buff_final_5           DB 1024 DUP (0)
    buff_size = $ - buff_final_5

    buff_temp_1            DB 0128 DUP (' '), 0
    buff_temp_2            DB 0128 DUP (' '), 0
    buff_temp_3            DB 0128 DUP (' '), 0
    buff_temp_4            DB 0128 DUP (' '), 0
    buff_temp_5            DB 0128 DUP (' '), 0
    buff_temp_6            DB 0128 DUP (' '), 0
    buff_temp_7            DB 0128 DUP (0)

    current_buff_ADDR      DD 0

    res                    DQ 5 DUP (0)
    a                      DQ 1.23   , 10.42, -110.54, -12.09, 12.09
    b                      DQ -2.34  , -2.39, 34.13  , -12.0 , 12.0
    c_                     DQ 3.14159, 12.50, 0.00035, -9.0  , 9.0
    d                      DQ 4.56   , -1.43, 0.51   , -1.2  , 1.2
    const                  DQ 23.0, 2.0
    temp                   DQ 0.0
    div_zero               DB 0
    zero                   DQ 0.0
    max                    DQ 922337203685477580.0
    min                    DQ -922337203685477580.0
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