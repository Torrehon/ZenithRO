Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Searching for 3484 in mob_skill_db.txt ==="
Select-String -Path "mob_skill_db.txt" -Pattern "3484," -Context 1,1 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
