@echo off
title Lade Konfiguration...
color 0A
setlocal enabledelayedexpansion

set SCRIPT_PATH=%~dp0scripts
set CONFIG_FILE=%~dp0config.ini

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo Dieses Skript muss als Administrator ausgeführt werden!
    echo Starte das Skript neu mit Admin-Rechten...
    echo.
    powershell -Command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit
)

echo Lade Konfiguration aus %CONFIG_FILE%

for /f "tokens=1,2 delims==" %%A in (%CONFIG_FILE%) do (
    if "%%A"=="TITLE" set TITLE=%%B
    if "%%A"=="COLOR" set COLOR=%%B
)

echo TITLE=%TITLE%
echo COLOR=%COLOR%

title %TITLE%
color %COLOR%

set COUNT=0
for /f "tokens=1,2,3 delims=," %%A in ('findstr /R "^.*=.*" %CONFIG_FILE%') do (
    if NOT "%%A"=="[SCRIPTS]" (
        set /a COUNT+=1
        set MENU_!COUNT!=%%B
        set DESC_!COUNT!=%%C
        set ENABLE_!COUNT!=%%D
    )
)

echo COUNT=%COUNT%
for /L %%N in (1,1,%COUNT%) do (
    echo MENU_%%N=!MENU_%%N!
    echo DESC_%%N=!DESC_%%N!
    echo ENABLE_%%N=!ENABLE_%%N!
)

pause

:menu
cls
echo ==============================
echo       %TITLE%
echo ==============================

for /L %%N in (1,1,%COUNT%) do (
    if !ENABLE_%%N!==1 echo [%%N] !DESC_%%N!
)

echo [X] Beenden
echo ==============================
set /p choice="Bitte eine Option wählen: "

for /L %%N in (1,1,%COUNT%) do (
    if "!ENABLE_%%N!"=="1" if "!choice!"=="%%N" call :run_script !MENU_%%N!
)

if /I "%choice%"=="X" exit
goto menu

:run_script
cls
echo Starte Skript: %1 ...
powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File "%SCRIPT_PATH%\%1"
pause
goto menu