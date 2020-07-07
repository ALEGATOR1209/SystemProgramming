INCLUDE \masm32\include\masm32rt.inc

; (4 * b / c - 1) / (12 * с + а - b)
calc MACRO a, b, d
    MOV AL, 12  ; preparing multiplication
    IMUL d      ; 12 * c         -> AL
    ADD AL, a   ; 12 * c + a     -> AL
    SUB AL, b   ; 12 * c + a - d -> AL
    MOV res, AL ; 12 * c + a - d -> res

    MOV AL, 4   ; preparing multiplication
    IMUL b      ; 4 * b         -> AL
    IDIV d      ; 4 * b / c     -> AL
    DEC AL      ; 4 * b / c - 1 -> AL, AH = 0

    IDIV res    ; (4 * b / c - 1) / (12 * с + а - b) -> AL, AH = 0
ENDM

finalCalc MACRO n, buffer
    LOCAL odd
    LOCAL fin

    MOV BL, n
    SAR BL, 1
    JB odd

    INVOKE wsprintf, addr buffer, addr msg_even_format, BL
    JMP fin

    odd:
    MOV AL, 5
    IMUL n
    INVOKE wsprintf, addr buffer, addr msg_odd_format, AL
    
    fin:
ENDM

printNum MACRO n, buffer
    LOCAL pos
    LOCAL fin
    MOV     CL, n
    TEST    CL, CL
    JNS     pos

    NEG CL
    INVOKE wsprintf, addr buffer, addr msg_neg_format, CL
    JMP fin

    pos:
    INVOKE wsprintf, addr buffer, addr msg_pos_format, CL

    fin:
ENDM

getExpression MACRO i, buff
    printNum a[i], buff_a
    printNum b[i], buff_b
    printNum d[i], buff_d

    calc a[i], b[i], d[i]
    MOV res, AL
    printNum AL, buff_res
    
    finalCalc res, buff_res_final

    INVOKE wsprintf, buff, addr msg_final,
        addr buff_b,
        addr buff_d,
        addr buff_d,
        addr buff_a,
        addr buff_b,
        addr buff_res,
        addr buff_res_final
ENDM

.data
    msg_title       DB "Лабораторна робота 5", 0
    msg_last_final  DB "Результати обчислень:", 10,
        "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0

    msg_final              DB "(4 * %s / %s - 1) / (12 * %s + %s - %s) = %s -> %s", 0
    msg_neg_format         DB "(-%d)", 0
    msg_pos_format         DB "%d", 0
    msg_odd_format         DB "* 5 = %d", 0
    msg_even_format        DB "/ 2 = %d", 0

    buff_last_final        DB 512 DUP (0)
    buff_final             DB 064 DUP (0)
    buff_final_2           DB 064 DUP (0)
    buff_final_3           DB 064 DUP (0)
    buff_final_4           DB 064 DUP (0)
    buff_final_5           DB 064 DUP (0)
    buff_a                 DB 008 DUP (0)
    buff_b                 DB 008 DUP (0)
    buff_d                 DB 008 DUP (0)
    buff_res               DB 008 DUP (0)
    buff_res_final         DB 016 DUP (0)
    current_buff_addr      DD 0

    res                    DB 0
    a                      DB -19, -29, -37, -13, -3
    b                      DB   4,   6,   9,  10, 20
    d                      DB   2,   3,   4,   2,  2
.code
    start:
        MOV EDI, 0
        MOV current_buff_addr, offset buff_final

        hereWeGoAgain:
        getExpression EDI, current_buff_addr

        ADD current_buff_addr, 64
        INC EDI
        CMP EDI, 5
        JB hereWeGoAgain

        INVOKE wsprintf, addr buff_last_final, addr msg_last_final,
            addr buff_final,
            addr buff_final_2,
            addr buff_final_3,
            addr buff_final_4,
            addr buff_final_5

        INVOKE MessageBox, 0, addr buff_last_final, addr msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start
