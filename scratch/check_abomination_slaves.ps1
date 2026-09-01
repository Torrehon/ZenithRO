Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Inspecting mob_skill_db.txt for 3484 and NPC_SUMMONSLAVE ==="
Select-String -Path "mob_skill_db.txt" -Pattern "3484,|SUMMONSLAVE" -Context 0,1 | Select-Object -First 25 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
