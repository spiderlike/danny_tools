@echo off

set givenPath=%1

if "%givenPath%" == "danny" (goto danny)
if "%givenPath%" == "pc" (goto pc)

:danny
echo [ You are in danny's AppData ]
echo.
c:
cd C:\Users\danny_\AppData
goto :EOF


:pc
echo [ You are in ProgramData ]
echo.
c:
cd C:\ProgramData