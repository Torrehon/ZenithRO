Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Searching for Einherjar scripts in soul_quests_1.txt ==="
Select-String -Path "soul_quests_1.txt" -Pattern "script\t.*Einherjar" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
