Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Searching for 50020 or Alchemist in soul_quests_1.txt ==="
Select-String -Path "soul_quests_1.txt" -Pattern "50020|Alchemist|getskill|Soul|soul" -Context 2,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
