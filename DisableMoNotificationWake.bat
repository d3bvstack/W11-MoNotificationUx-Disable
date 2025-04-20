@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo   DISABLE MoNotificationUx.exe WAKE UP
echo ===================================================
echo.
echo Current User: %USERNAME%
echo Date/Time: %DATE% %TIME%
echo.

echo Checking if MoNotificationUx.exe is configured to wake the computer...
echo.

:: Check current wake sources
echo Current wake sources:
powercfg /lastwake
echo.

:: Look for MoNotificationUx in the Task Scheduler
echo Searching for MoNotification tasks in Task Scheduler...
schtasks /query /fo list /v | findstr /i "MoNotification"
echo.

:: Disable the Microsoft Office Click-to-Run Service notification task
echo Attempting to modify Microsoft Office notification tasks...
schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates 2.0" /DISABLE 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Successfully disabled Office Automatic Updates task.
) else (
    echo Office Automatic Updates task not found or access denied.
)
echo.

schtasks /Change /TN "\Microsoft\Office\Office Subscription Maintenance" /DISABLE 2>nul
if %ERRORLEVEL% EQU 0 (
    echo Successfully disabled Office Subscription Maintenance task.
) else (
    echo Office Subscription Maintenance task not found or access denied.
)
echo.

:: Disable Windows notification wake ability
echo Attempting to disable notification wake ability...
echo.

:: Disable notification related wake timers
echo Disabling all wake timers...
powercfg /waketimers

:: Set "Allow wake timers" to Disabled in power settings
echo Disabling wake timers in power settings...
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 0

:: Disable all task scheduler wake abilities related to notifications
echo Modifying system notification tasks...
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Reboot" /DISABLE 2>nul
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /DISABLE 2>nul
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE 2>nul

:: Modify registry to disable notifications waking the computer
echo Modifying registry settings for notifications...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_TOAST" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_CRITICAL_TOAST" /t REG_DWORD /d 0 /f

echo.
echo ===================================================
echo   VERIFY CHANGES
echo ===================================================
echo.
echo Current wake timers (should be none):
powercfg /waketimers
echo.

echo Completed. MoNotificationUx.exe should no longer wake your computer.
echo Please restart your computer for all changes to take effect.
echo.
pause
