Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Checking modified skill files in rathena/db ==="
git status --short | Select-String -Pattern "skill"
