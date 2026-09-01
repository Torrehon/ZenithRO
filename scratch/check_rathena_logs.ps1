Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Checking log/ directory ==="
if (Test-Path "log") {
    Get-ChildItem -Path "log" | ForEach-Object { Write-Host "$($_.Name) ($($_.Length) bytes)" }
} else {
    Write-Host "log directory not found directly in rathena"
}

Write-Host "=== Searching conf/ for console_silent or log settings ==="
Select-String -Path "conf\*.conf","conf\import\*.txt" -Pattern "console_silent|console_msg" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
