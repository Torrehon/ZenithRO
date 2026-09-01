Set-Location -Path "d:\SERVER_RO"

Write-Host "=== Searching for SQL backups and dump files ==="
Get-ChildItem -Path "." -Recurse -Include "*.sql","*.bak","*.dump","*.gz","*.zip" | Where-Object { $_.FullName -notmatch "rathena\\sql-files" } | ForEach-Object {
    Write-Host "$($_.FullName) | Size: $($_.Length) bytes | LastWrite: $($_.LastWriteTime)"
}
