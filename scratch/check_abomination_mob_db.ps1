Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Inspecting mob 3484 in mob_db.yml ==="
Select-String -Path "mob_db.yml" -Pattern "Id: 3484" -Context 0,25 | ForEach-Object {
    Write-Host $_
}
