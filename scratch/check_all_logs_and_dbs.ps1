Set-Location -Path "d:\SERVER_RO\LevitationRO"

Write-Host "=== Searching for server log files, crash dumps, and database files ==="
Get-ChildItem -Path "." -Recurse -Include "*.log","*.err","*.out","*.txt","*.sql" | Where-Object { $_.FullName -notmatch "antigravity" -and $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | ForEach-Object {
    Write-Host "$($_.FullName) | Size: $($_.Length) bytes | LastWrite: $($_.LastWriteTime)"
}
