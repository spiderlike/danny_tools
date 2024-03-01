@echo off

set a=%1

if "%a%"=="off" (goto off)
powershell "bluetooth.ps1 on"
goto :EOF

:off
powershell "bluetooth.ps1 off"
