Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Searching mob_skill_db.txt for Poison skills ==="
Select-String -Path "mob_skill_db.txt" -Pattern ",176,|,188," -Context 0,0 | Select-Object -First 15 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
