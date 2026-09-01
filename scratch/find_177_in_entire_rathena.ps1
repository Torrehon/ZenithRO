Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for status_change_start calls with 177 or SC_ ==="
Select-String -Path "npc\custom\*.txt","npc\*.txt","npc\*\*.txt","npc\*\*\*.txt" -Pattern "sc_start|status_change|177" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
