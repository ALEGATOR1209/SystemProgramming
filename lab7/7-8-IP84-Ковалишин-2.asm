INCLUDE \masm32\include\masm32rt.inc

PUBLIC mult

.data
	const		DQ -23.0
.code
	; Calculates -23 * d
	; Input:
	;	[EBP + 8]  - address of result
	;	[EBP + 12] - first 32 bits of d
	;	[EBP + 16] - last  32 bits of d
	;Output:
	;	QWORD PTR [EBP + 8] - -23d
 	mult PROC
 		PUSH 	EBP
 		MOV 	EBP, ESP
 		PUSH	EAX

 		MOV		EAX, [EBP + 8]

 		finit
 		fld		const
 		fld		QWORD PTR [EBP + 12]
	    fmul

 		fstp	QWORD PTR [EAX]

 		POP		EAX
 		POP		EBP
 		RET		12
	mult ENDP
END