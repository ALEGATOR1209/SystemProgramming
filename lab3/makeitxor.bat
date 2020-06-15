@echo off

    if exist "lab3xor.obj" del "lab3xor.obj"
    if exist "lab3xor.exe" del "lab3xor.exe"

    \masm32\bin\ml /c /coff "lab3xor.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "lab3xor.obj"
    if errorlevel 1 goto errlink
    dir "lab3xor.*"
    goto TheEnd

  :errlink
    echo _
    echo Link error
    goto TheEnd

  :errasm
    echo _
    echo Assembly Error
    goto TheEnd
    
  :TheEnd

lab3xor.exe
pause
