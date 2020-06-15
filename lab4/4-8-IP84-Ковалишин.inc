printText MACRO text, x, y, w, h
    ; default text ID = 100
    ;; we've just replaced 1 string of code with 5 string macros
    DlgStatic text, 1, x, y, w, h, 100
ENDM

; XOR-based cipher
encode MACRO input, len, key
	LOCAL cycle
    MOV EDI, 0 ; returns result back into input buffer
    cycle: ;; I was forced to make this useless comment
        MOV AH, key
        XOR input[EDI], AH
        INC EDI
        CMP EDI, len
        JB cycle
ENDM

; compares equality of 2 string
compare MACRO str1, str2, len
    LOCAL cycle
    MOV EDI, 0 ; returns result in AH
    MOV AH, 0 ;; AH = 0 - strings are equal
    cycle:       ;; AH = 1 - string aren't equal
        MOV DL, str1[EDI]
        MOV DH, str2[EDI]
        
        .IF DL != DH
            MOV AH, 1
        .ENDIF

        INC EDI
        .IF EDI < len
            JMP cycle
        .ENDIF
ENDM
