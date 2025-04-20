# DisableMoNotificationWake.bat

## Overview
`DisableMoNotificationWake.bat` is a Windows batch script designed to prevent the MoNotificationUx.exe process from waking your computer from sleep or standby. This is particularly useful if you've noticed your computer waking up unexpectedly and identified MoNotificationUx.exe (Microsoft's notification service) as the cause.

## Requirements
- Windows 10 or Windows 11 operating system
- Administrator privileges
- Basic understanding of running batch files

## Installation
1. Download the `DisableMoNotificationWake.bat` file
2. Save it to a location of your choice on your computer
3. No additional installation steps are required

## Usage
1. Right-click on `DisableMoNotificationWake.bat`
2. Select "Run as administrator"
3. Follow any prompts that appear in the command window
4. Restart your computer after running the script for all changes to take effect

## What This Script Does
The script performs the following actions to prevent MoNotificationUx.exe from waking your computer:

- Checks and displays current wake sources for verification
- Searches for and disables Microsoft Office notification-related scheduled tasks
- Disables notification wake capabilities in Windows settings
- Turns off all wake timers in power settings
- Disables Windows Update tasks that might wake the system
- Modifies registry settings to prevent notifications from waking the device

## Detailed Operations
```batch
# Disables Office-related scheduled tasks
schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates 2.0" /DISABLE
schtasks /Change /TN "\Microsoft\Office\Office Subscription Maintenance" /DISABLE

# Disables wake timers in power settings
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 0
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 0

# Disables Windows Update tasks that might wake the system
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Reboot" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /DISABLE
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /DISABLE

# Modifies registry settings to prevent notifications from waking the device
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_TOAST" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_CRITICAL_TOAST" /t REG_DWORD /d 0 /f
```

## Troubleshooting
If your computer continues to wake unexpectedly after running this script:

1. Use `powercfg /lastwake` in Command Prompt to identify what's waking your computer
2. Check Device Manager for devices that might be configured to wake the system:
   - Open Device Manager
   - For each device (especially network adapters and input devices):
     - Right-click → Properties → Power Management
     - Uncheck "Allow this device to wake the computer"

## Reverting Changes
If you need to restore notification wake functionality:

1. Re-enable the scheduled tasks that were disabled:
```batch
schtasks /Change /TN "\Microsoft\Office\Office Automatic Updates 2.0" /ENABLE
schtasks /Change /TN "\Microsoft\Office\Office Subscription Maintenance" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Reboot" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /ENABLE
schtasks /Change /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /ENABLE
```

2. Re-enable wake timers in power settings:
```batch
powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 1
powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_SLEEP RTCWAKE 1
```

3. Restore registry settings:
```batch
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_TOAST" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_WAKE_TO_CRITICAL_TOAST" /t REG_DWORD /d 1 /f
```

## Important Notes
- This script modifies system settings. Only run it if you understand its purpose.
- Some critical notifications might not wake your computer after running this script.
- Microsoft Office updates may be delayed if related tasks are disabled.
- Some Windows Update functionality may be affected.
