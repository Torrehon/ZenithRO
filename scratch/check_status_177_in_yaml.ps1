Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Checking db/pre-re/status.yml for MODECHANGE / Modechange ==="
Select-String -Path "db\pre-re\status.yml" -Pattern "Modechange|MODECHANGE" -Context 2,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
