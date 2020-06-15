INCLUDE \masm32\include\masm32rt.inc

PUBLIC tan

.data
    max         DQ 922337203685477580.0
    min			DQ -922337203685477580.0
.code
	; calculates tan(c)
	; Input:
	;	ESI - address of DQ c
	;	EBX - number of error
	;	ECX - address of result DT variable
	; Output: [ECX] - tan(c)
	tan PROC
		XOR EBX, EBX

		finit
		fld 	QWORD PTR [ESI] ; st(0) = c

	    fcom    max
	    fstsw   AX
	    SAHF
    	JNC     tangens_error
    	fcom    min
    	fstsw   AX
    	SAHF
    	JC      tangens_error

	    fptan               ; st(0) = 1, st(1) = tan(c)
    	fdivp   st(1), st   ; st(0) = tan(c)
    	fstp	QWORD PTR [ECX]

    	fin:
		RET

		tangens_error:
		MOV		EBX, 2
		JMP		fin
	tan ENDP
END