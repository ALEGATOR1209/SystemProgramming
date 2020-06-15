@echo off
    set filename="lab7"
    set exec_filename="lab7.exe"
    if exist "%filename%.obj" del "%filename%.obj"
    if exist "%filename%-1.obj" del "%filename%-1.obj"
    if exist "%filename%-2.obj" del "%filename%-2.obj"
    if exist "%filename%-3.obj" del "%filename%-3.obj"
    if exist "%filename%.exe" del "%filename%.exe"

    \masm32\bin\ml /c /coff "%filename%.asm"
    \masm32\bin\ml /c /coff "%filename%-1.asm"
    \masm32\bin\ml /c /coff "%filename%-2.asm"
    \masm32\bin\ml /c /coff "%filename%-3.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%exec_filename% "%filename%.obj" "%filename%-1.obj" "%filename%-2.obj" "%filename%-3.obj"
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
