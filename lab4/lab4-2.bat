@echo off

    if exist "lab4-2.obj" del "lab4-2.obj"
    if exist "lab4-2.exe" del "lab4-2.exe"

    \masm32\bin\ml /Fl /c /coff "lab4-2.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "lab4-2.obj"
    if errorlevel 1 goto errlink
    dir "lab4-2.*"
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

lab4-2.exe
pause
