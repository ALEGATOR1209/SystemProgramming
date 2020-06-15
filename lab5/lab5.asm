include \masm32\include\masm32rt.inc  


.data
    aarg    	db    12, 16, -8, 20, 24
    carg    	db    3, 6, 5, 10, 4
    darg    	db    5, 11, 1, 9, 10
    titleMsg  	db    "Lab5", 0
    text		db	  "Формула для розрахунків:", 13,
		              "(-2*c - d + 53)/(a/4 - 1)", 13,
		              "Результати обчислень:", 0
    template  	db    "%s", 13,
    				  "1) a = 12, c = 3, d = 5", 13,
		              "Відповідь: %s", 13,
		              "2) a = 16, c = 6, d = 11", 13,
		              "Відповідь: %s", 13,
		              "3) a = -8, c = 5, d = 1", 13,
		              "Відповідь: %s", 13,
		              "4) a = 20, c = 10, d = 9", 13,
		              "Відповідь: %s", 13,
		              "5) a = 24, c = 4, d = 10", 13,
		              "Відповідь: %s", 0
    templ_pos 	db    "%d", 0
    templ_neg  	db    "-%d", 0

    first    	dw    ?
    second    	dw    ?
    third    	db    ?
    fourth    	db    ?
    fifth    	db    ?
    sixth    	db    ?
    
    buf1  db  20  dup  (?)  
    buf2  db  20  dup  (?)  
    buf3  db  20  dup  (?)  
    buf4  db  20  dup  (?)  
    buf5  db  20  dup  (?)  
    buffer   db   256 dup (?)

.code
    plus macro a, b
      xor ax, ax
      mov ax, a
      add ax, b
    endm

    minus macro a, b
      ;;a і b - додатні числа, a - b 
      xor ax, ax
      mov al, b
      neg al
      add al, a
    endm

    multi macro a, b
      xor ax, ax
      mov al, a
      mov cl, b
      imul cl
    endm

    divis macro a, b
      xor ax, ax
      mov al, a
      cbw
      mov cl, b
      idiv cl 
    endm

  save_pos macro buffer
    invoke wsprintf, addr buffer, addr templ_pos, ax
  endm

  save_neg macro buffer
    neg al
    invoke wsprintf, addr buffer, addr templ_neg, al
  endm

    start:
    mov edi, 0
    .WHILE edi != 5
   
    ; 1) -2с
    multi carg[edi], -2
    mov first, ax
    
    ; 2) -d + 53
    minus 53, darg[edi]
    mov second, ax

  	; 3) -2c - d + 53 
    plus first, second
    mov third, al

    ; 4) a/4
    divis aarg[edi], 4
    mov fourth, al

  	; 5) a/4 - 1
    minus fourth, 1
    mov fifth, al

  	; 6) (-2c - d + 53) / (a/4 - 1)
    divis third, fifth
    mov sixth, al

	test   sixth, 1   ;Перевірка числа на парність
	jz     pair       ;парне
	jnz    odd        ;непарне

	pair:
	divis sixth, 2
	jmp lastStep
	  
	odd:
	multi sixth, 5

	lastStep:
	test ax, 80h
	jne negative
	
	.IF edi == 0
	save_pos buf1
  	.ELSEIF edi == 1
  	save_pos buf2
	.ELSEIF edi == 2
  	save_pos buf3
	.ELSEIF edi == 3
  	save_pos buf4
  	.ELSEIF edi == 4
  	save_pos buf5
    .ENDIF
  	jmp continue

  	negative:
	.IF edi == 0
	save_neg buf1
	.ELSEIF edi == 1
	save_neg buf2
	.ELSEIF edi == 2
	save_neg buf3
    .ELSEIF edi == 3
  	save_neg buf4
  	.ELSEIF edi == 4
  	save_neg buf5
    .ENDIF
  
  	continue:
    inc edi
    .ENDW
    
    invoke wsprintf, addr buffer, addr template, addr text, addr buf1, addr buf2, addr buf3, addr buf4, addr buf5
   
    invoke MessageBox, 0, addr buffer, addr titleMsg, MB_OK
    invoke ExitProcess, 0
    
    END start