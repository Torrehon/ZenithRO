Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for Service4u or DC_SERVICEFORYOU or 177 in db/ and npc/ ==="
Select-String -Path "db\pre-re\*.yml","db\pre-re\*.txt","db\import\*.yml","db\import\*.txt","npc\custom\*.txt" -Pattern "Service4u|DC_SERVICEFORYOU|SC_SERVICE4U|177" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
