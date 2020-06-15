@echo off
    set filename="lab4-1"
    if exist "%filename%.obj" del "%filename%.obj"
    if exist "%filename%.exe" del "%filename%.exe"

    \masm32\bin\ml /Fl /c /coff "%filename%.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "%filename%.obj"
    if errorlevel 1 goto errlink
    dir "lab4.*"
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

%filename%.exe
pause
