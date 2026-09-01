Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Viewing end of mob_skill_db.txt ==="
Get-Content -Path "mob_skill_db.txt" -Tail 50 | ForEach-Object { Write-Host $_ }
