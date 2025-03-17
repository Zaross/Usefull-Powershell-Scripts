function Remove-OldFiles {
    param (
        [string]$Path,
        [int]$Days
    )

    $CurrentDate = Get-Date
    $Files = Get-ChildItem -Path $Path -Recurse

    foreach ($File in $Files) {
        if ($File.LastWriteTime -lt $CurrentDate.AddDays(-$Days)) {
            Remove-Item -Path $File.FullName -Force -Recurse
        }
    }
}

$TempPath = [System.IO.Path]::GetTempPath()
Remove-OldFiles -Path $TempPath -Days 7

Clear-RecycleBin -Force

Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait

Write-Output "Disk cleanup completed."