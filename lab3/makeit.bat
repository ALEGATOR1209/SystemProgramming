@echo off

    if exist "lab3.obj" del "lab3.obj"
    if exist "lab3.exe" del "lab3.exe"

    \masm32\bin\ml /c /coff "lab3.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "lab3.obj"
    if errorlevel 1 goto errlink
    dir "lab3.*"
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

lab3.exe
pause
