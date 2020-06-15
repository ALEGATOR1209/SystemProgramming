INCLUDE \masm32\include\masm32rt.inc

PUBLIC den, extrn_res
EXTERN extrn_a:QWORD, extrn_b:QWORD

.data
	extrn_res  DQ  0.0, 0.0
    zero       DQ  0.0
.code
	; calculates 2 * b - a and checks if it's 0
	; INPUT:
	; 	extrn_a - QWORD
	; 	extrn_b - QWORD
	; OUTPUT:
	; 	[extrn_res + 0] - QWORD result of calculations 2 * b - a
	; 	[extrn_res + 8] - QWORD result of calculations 2 * b
	; 	ESI = 1 if 2 * b - a = 0
	den PROC
		XOR		ESI, ESI
		finit
		fld1
		fld1
		faddp 	st(1), st

		fld 	extrn_b
	    fmulp   st(1), st
	    fst		extrn_res[8]

	    fld     extrn_a
	    fsubp   st(1), st

	    fcom    zero
    	fstsw   AX
    	SAHF
    	JZ      division_by_zero

    	fin:
	    fstp	extrn_res
	    RET

	    division_by_zero:
	    MOV		ESI, 1
	    JMP 	fin
	den ENDP
END