Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Select-String -Path "mob_db.yml" -Pattern "AS_D_RAGGED_GOLEM" -Context 0,35 | ForEach-Object {
    Write-Host $_
}
