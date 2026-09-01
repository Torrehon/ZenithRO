Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Searching mob_skill_db.txt for SUMMONSLAVE with multiple val IDs ==="
Select-String -Path "mob_skill_db.txt" -Pattern "196,.*,slavele," -Context 0,0 | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
