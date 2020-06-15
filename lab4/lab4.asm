
    .386
    .model flat, stdcall
    option casemap :none   


    include /masm32/include/windows.inc
    include /masm32/include/user32.inc
    include /masm32/include/kernel32.inc
 
    includelib /masm32/lib/user32.lib
    includelib /masm32/lib/kernel32.lib

	szText macro name, text
		local 	lbl
		jmp	lbl
		name 	db text, 0
		lbl:
	endm

	showData macro x_cor, y_cor, text	
		invoke CreateWindowEx,NULL,
                addr classStatic,
                text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                x_cor,
                y_cor,
                150,
                20,
                hWnd,
                2001,
                hInstance,
                NULL
	endm

	xorInput macro in
		local cycle
		mov di, 0
    	cycle:
		mov dh, in[di]
        xor dh, passwordKey
    	inc di
    	cmp di, passwordLenght
    	jne cycle
	endm

	comparePassword macro in
		local cycle
		local finish

		mov bl, 1
		mov di, -1
		
    	cycle:
		inc di
    	cmp di, passwordLenght
		je finish
		mov dh, in[di]
    	cmp dh, password[di]
    	je cycle
		mov bl, 0
		finish:
	endm

	WinMain proto :dword, :dword, :dword, :dword
	WndProc proto :dword, :dword, :dword, :dword

	.data
		classEdit db "edit",0
		classStatic db "static",0
		classButton db "button",0
		userName db "Zhenya Zasko", 0
		userNumber db "8408", 0
		userBrthday db "12.02.2001", 0
		text db "Enter the password",0
		error db "Password is incorrect", 0
		userData db "User data: ", 0
		buttonText db "Log in",0

		password db 6Dh, 7Fh, 68h, 6Ah, 6Bh, 64h
		passwordKey db 00001100b
		passwordLenght = $ - password



	.data?
		hInstance 		dd ?
		lpszCmdLine		dd ?
		hEditText 		HWND ?
		input db 64 DUP (?)

	.code

	

start:

	invoke 	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	GetCommandLine
	mov	lpszCmdLine, eax

	invoke 	WinMain, hInstance, NULL, lpszCmdLine, SW_SHOWDEFAULT
	invoke	ExitProcess, eax


WinMain proc 	hInst 		:dword, 
		hPrevInst 	:dword,
		szCmdLine 	:dword,
		nShowCmd 	:dword

	local 	wc 	:WNDCLASSEX
	local 	msg 	:MSG
	local 	hWnd 	:HWND

	szText	szClassName, "BasicWindow"
	szText	szWindowTitle, "Log In Window"

	mov	wc.cbSize, sizeof WNDCLASSEX
	mov	wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
	mov 	wc.lpfnWndProc, WndProc
	mov 	wc.cbClsExtra, NULL
	mov	wc.cbWndExtra, NULL

	push	hInst
	pop 	wc.hInstance

	mov	wc.hbrBackground, COLOR_BTNFACE + 1
	mov	wc.lpszMenuName, NULL
	mov 	wc.lpszClassName, offset szClassName

	invoke	LoadIcon, hInst, IDI_APPLICATION
	mov	wc.hIcon, eax
	mov	wc.hIconSm, eax

	invoke	LoadCursor, hInst, IDC_ARROW
	mov	wc.hCursor, eax

	invoke	RegisterClassEx, addr wc

	invoke	CreateWindowEx, WS_EX_APPWINDOW, addr szClassName, addr szWindowTitle,
				WS_OVERLAPPEDWINDOW, 
				300, 300, 400, 400, 
				NULL, NULL, hInst, NULL

	mov	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

MessagePump:

	invoke 	GetMessage, addr msg, NULL, 0, 0

	cmp 	eax, 0
	je 	MessagePumpEnd

	invoke	TranslateMessage, addr msg
	invoke	DispatchMessage, addr msg

	jmp 	MessagePump

MessagePumpEnd:

	mov	eax, msg.wParam
	ret

WinMain endp


WndProc proc 	hWnd 	:dword,
		uMsg 	:dword,
		wParam 	:dword,
	 	lParam 	:dword

	.if uMsg==WM_CREATE
		invoke CreateWindowEx,NULL,
                addr classEdit,
                NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL or WS_BORDER,
                120,
                120,
                150,
                20,
                hWnd,
                2000,
                hInstance,
                NULL 
        mov hEditText, eax
        invoke CreateWindowEx,NULL,
                addr classStatic,
                addr text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                125,
                100,
                150,
                20,
                hWnd,
                2001,
                hInstance,
                NULL
        invoke CreateWindowEx,NULL,
                addr classButton,
                addr buttonText,
                WS_VISIBLE or WS_CHILD,
                145,
                160,
                100,
                20,
                hWnd,
                2002,
                hInstance,
                NULL
	.elseif uMsg == WM_DESTROY
		invoke 	PostQuitMessage, 0
		xor	eax, eax
		ret
		.elseif uMsg==WM_COMMAND
    	cmp wParam, 2002
    	jne stop
    	
		invoke SendMessage, hEditText, WM_GETTEXT, 40, addr input
		xorInput input
		comparePassword input
		
		cmp bl, 1
		jne correct
    	
    	incorrect:
		showData 125, 200, addr error
    	jmp stop
    	correct:
		showData 125, 200, addr userData
		showData 125, 220, addr userName
		showData 125, 240, addr userNumber
		showData 125, 260, addr userBrthday
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
        ret
	.endif
		stop:
    	xor eax,eax
    	ret
WndProc endp

end start