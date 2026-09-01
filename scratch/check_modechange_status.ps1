Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching pre-re/status.yml and re/status.yml for ModeChange ==="
Select-String -Path "pre-re\status.yml","re\status.yml" -Pattern "ModeChange" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
