Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\npc\quests\hunting_quests" -Filter "*.txt" | ForEach-Object {
    Write-Host "$($_.FullName)"
}
