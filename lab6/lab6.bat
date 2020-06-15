@echo off
    set filename="lab6"
    if exist "%filename%.obj" del "%filename%.obj"
    if exist "%filename%.exe" del "%filename%.exe"

    \masm32\bin\ml /c /Fl /coff "%filename%.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\PoLink /SUBSYSTEM:console "%filename%.obj"
    if errorlevel 1 goto errlink
    dir "%filename%.*"
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
