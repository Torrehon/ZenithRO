Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\quests"

Write-Host "=== Searching for bioethics or homunculus in quests/ ==="
Select-String -Path "*.txt","**/*.txt" -Pattern "Bioethics|bioethics|homunculus|lhz_in02|Regelschirm" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
