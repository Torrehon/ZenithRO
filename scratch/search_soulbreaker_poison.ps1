Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching skill_db.yml for SOULBREAKER and POISON ==="
Select-String -Path "pre-re\skill_db.yml" -Pattern "Name: .*SOULBREAKER|Name: .*POISON" -Context 2,0 | ForEach-Object {
    Write-Host "$($_.Context.PreContext)"
    Write-Host "$($_.Line)"
}
