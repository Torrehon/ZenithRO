Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for recent log files ==="
Get-ChildItem -Path "." -Recurse -Include "*.log","*.err","*.txt" | Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-2) } | ForEach-Object {
    Write-Host "$($_.FullName) | Size: $($_.Length) bytes | LastWrite: $($_.LastWriteTime)"
}
