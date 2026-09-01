Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Searching mob_skill_db.txt for METEORASSAULT, SOULBREAKER, WIDEPOISON, POWERUP, AGIUP ==="
Select-String -Path "mob_skill_db.txt" -Pattern "METEOR|SOULBREAKER|WIDEPOISON|POWERUP|AGIUP|PULSESTRIKE" -Context 0,1 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
