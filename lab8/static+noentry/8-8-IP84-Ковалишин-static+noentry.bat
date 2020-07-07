@echo off
    set filename="8-8-IP84-Ковалишин-main-static"
    if exist "%filename%.obj" del "%filename%.obj"
    if exist "%filename%.exe" del "%filename%.exe"

    set libname="8-8-IP84-Ковалишин-lib-noentry"
    if exist "%libname%.dll"  del "%libname%.dll"
    if exist "%libname%.exp"  del "%libname%.exp"
    if exist "%libname%.obj"  del "%libname%.obj"
    if exist "%libname%.lib"  del "%libname%.lib"

    \masm32\bin\ml /c /coff "%libname%.asm"
    \masm32\bin\Link.exe /OUT:"%libname%.dll" /DEF:%libname%.def /NOENTRY /DLL "%libname%.obj"

    \masm32\bin\ml /c /coff "%filename%.asm"
    if errorlevel 1 goto errasm

    \masm32\bin\Link.exe /SUBSYSTEM:console "%filename%.obj"
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
