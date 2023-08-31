@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2022 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Batch file to compile ISHelpGen

setlocal


rem -------------------------------------------------------------------------

set DELPHIXEDISABLEDWARNINGS=-W-SYMBOL_DEPRECATED -W-SYMBOL_PLATFORM -W-UNSAFE_CAST -W-EXPLICIT_STRING_CAST -W-EXPLICIT_STRING_CAST_LOSS -W-IMPLICIT_INTEGER_CAST_LOSS -W-IMPLICIT_CONVERSION_LOSS

echo Compiling ISHelpGen.dpr:
"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release" ISHelpGen.dpr
if errorlevel 1 goto failed

echo Success!
exit /b 0

:failed
echo *** FAILED ***
:failed2
exit /b 1
