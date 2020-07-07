@echo off

    if exist "lab1.obj" del "lab1.obj"
    if exist "lab1.exe" del "lab1.exe"

    \masm32\bin\ml /c /coff "lab1.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "lab1.obj"
    if errorlevel 1 goto errlink
    dir "lab1.*"
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

lab1.exe
pause
