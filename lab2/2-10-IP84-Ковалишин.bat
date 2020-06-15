@echo off

set startFolder=%cd%
set masm_path=C:\masm32\bin
set dos_box="C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe"
set filename=%1

cd C:\
for /f "tokens=* USEBACKQ" %%i in (`dir %filename% /s /b`) do (
	set asmfile=%%i
	goto next1
)
:	next1

cd "%asmfile%\..\"
set folder=%cd%

@echo "ASMFILE = %asmfile%"
@echo "DIR = %folder%"

%masm_path%\ml /Bl %masm_path%\link16.exe %asmfile%
%dos_box% -c "mount c %folder% " -c c: -c %filename:.asm=.COM%

cd %startFolder%
