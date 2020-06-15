.486
.model flat, stdcall
option casemap :none

.data
    max     DQ 922337203685477580.0
    min     DQ -922337203685477580.0
    const   DQ 23.0, 2.0
    zero    DQ ?
.code
libmain PROC hInstDLL: DWORD, reason: DWORD, reserved: DWORD
    finit
    fldz
    fstp    zero

    MOV     EAX, 1
    RET
libmain ENDP
calc PROC a: PTR QWORD, b: PTR QWORD, c_: PTR QWORD, d: PTR QWORD, res: PTR QWORD
    finit
    MOV     EAX, d
    fld     QWORD ptr [EAX]
    fld     const[0]
    fmul

    MOV     EAX, c_
    fld     QWORD ptr [EAX]
    fcom    max
    fstsw   AX
    SAHF
    JNC     tangens_error
    fcom    min
    fstsw   AX
    SAHF
    JC      tangens_error

    fptan
    fdivp   st(1), st
    fsub    st, st(1)

    fld     const[8]
    MOV     EAX, b
    fld     QWORD ptr [EAX]
    fmulp   st(1), st

    MOV     EAX, a
    fld     QWORD ptr [EAX]
    fsubp   st(1), st
    
    fcom    zero
    fstsw   AX
    SAHF
    JZ      division_by_zero
    
    fdivp   st(1), st
    JMP     fin

    division_by_zero:
    MOV     EBX, 1
    JMP     fin

    tangens_error:
    MOV     EBX, 2
    JMP     fin

    fin:
    MOV     EAX, res
    fstp    QWORD PTR [EAX]
    RET
calc ENDP
END libmain