@echo off

    if exist "lab5.obj" del "lab5.obj"
    if exist "lab5.exe" del "lab5.exe"

    \masm32\bin\ml /c /coff "lab5.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:CONSOLE "lab5.obj"
    if errorlevel 1 goto errlink
    dir "lab5.*"
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

pause