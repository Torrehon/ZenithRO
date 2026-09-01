Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\conf"

Write-Host "=== Searching drops.conf for item_rate_card ==="
Select-String -Path "battle/drops.conf","import/battle_conf.txt" -Pattern "item_rate_card|item_drop_card" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
