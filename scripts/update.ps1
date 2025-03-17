$admin = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$princ = New-Object System.Security.Principal.WindowsPrincipal($admin)
$adminCheck = $princ.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $adminCheck) {
    Write-Host "Das Skript muss als Administrator ausgeführt werden!" -ForegroundColor Red
    Start-Sleep -Seconds 2
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Starte Winget Upgrade..." -ForegroundColor Cyan
winget upgrade --all --accept-package-agreements --accept-source-agreements --include-unknown

Write-Host "Suche nach Windows-Updates..." -ForegroundColor Cyan
Install-Module PSWindowsUpdate -Force -Confirm:$false
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -IgnoreReboot

Write-Host "Starte Speicherplatzbereinigung..." -ForegroundColor Cyan
cleanmgr /sagerun:1

Write-Host "Überprüfung der Systemdateien mit SFC..." -ForegroundColor Cyan
sfc /scannow

Write-Host "Alle Updates und Bereinigungen abgeschlossen. Drücke ENTER zum Schließen." -ForegroundColor Green
Pause
