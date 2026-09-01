Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\conf"

Write-Host "=== Searching battle config files for trap settings ==="
Select-String -Path "battle\*.conf","import\*.txt" -Pattern "trap" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
