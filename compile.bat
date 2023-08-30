@echo off

rem  Inno Setup
rem  Copyright (C) 1997-2019 Jordan Russell
rem  Portions by Martijn Laan
rem  For conditions of distribution and use, see LICENSE.TXT.
rem
rem  Batch file to compile the help files and all projects

setlocal

rem -------------------------------------------------------------------------

rem  Compile each project separately because it seems Delphi
rem  carries some settings (e.g. $APPTYPE) between projects
rem  if multiple projects are specified on the command line.

set DELPHIXEDISABLEDWARNINGS=-W-SYMBOL_DEPRECATED -W-SYMBOL_PLATFORM -W-UNSAFE_CAST -W-EXPLICIT_STRING_CAST -W-EXPLICIT_STRING_CAST_LOSS -W-IMPLICIT_INTEGER_CAST_LOSS -W-IMPLICIT_CONVERSION_LOSS

cd Projects
if errorlevel 1 goto exit

cd ISPP
if errorlevel 1 goto failed

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release" -E..\..\Files ISPP.dpr
if errorlevel 1 goto failed

cd ..

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi;vcl;vcl.imaging -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source;ISPP" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Compil32.dpr
if errorlevel 1 goto failed

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCC.dpr
if errorlevel 1 goto failed

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi;vcl -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source;ISPP" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS ISCmplr.dpr
if errorlevel 1 goto failed

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi -Q -B -H -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components" -E..\Files SetupLdr.dpr
if errorlevel 1 goto failed

"%DELPHIXEROOT%\bin\dcc32.exe" --no-config -NSsystem;system.win;winapi;vcl -Q -B -W %DELPHIXEDISABLEDWARNINGS% %1 -U"%DELPHIXEROOT%\lib\win32\release;..\Components;..\Components\UniPs\Source" -E..\Files -DPS_MINIVCL;PS_NOGRAPHCONST;PS_PANSICHAR;PS_NOINTERFACEGUIDBRACKETS Setup.dpr
if errorlevel 1 goto failed

cd ..\Files
if errorlevel 1 goto failed
move SetupLdr.exe SetupLdr.e32
if errorlevel 1 goto failed
move Setup.exe Setup.e32
if errorlevel 1 goto failed

echo Success!
cd ..
goto exit

:failed
echo *** FAILED ***
cd ..
:failed2
exit /b 1

:exit
