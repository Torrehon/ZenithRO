Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for card drop rates custom code in src/map/ ==="

Select-String -Path "*.cpp","*.h" -Pattern "item_rate_card|card_drop|drop_card|card_rate|IT_CARD" -Context 2,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "File $($_.Path) Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
