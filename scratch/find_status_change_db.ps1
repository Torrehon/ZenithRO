Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Locating status_change_db.yml ==="
Get-ChildItem -Recurse -Filter "*status_change_db*" | ForEach-Object { Write-Host $_.FullName }
