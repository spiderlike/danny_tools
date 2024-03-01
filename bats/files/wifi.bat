@echo off

set connection=%1

if "%connection%" == "off" (goto switch_off)
if "%connection%" == "on" (goto switch_on)
goto :EOF

:switch_off
netsh interface set interface name="myNetwork" admin=disabled
goto :EOF

:switch_on
netsh interface set interface name="myNetwork" admin=enabled 
netsh wlan connect name="Ruler"