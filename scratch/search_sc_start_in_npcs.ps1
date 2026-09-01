Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Write-Host "=== Searching custom and quests NPCs for sc_start ==="
Get-ChildItem -Recurse -Filter "*.txt" | Select-String -Pattern "sc_start" | Select-Object -First 40 | ForEach-Object {
    Write-Host "$($_.Filename): Line $($_.LineNumber): $($_.Line)"
}
