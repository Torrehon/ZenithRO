Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Select-String -Path "mob.cpp" -Pattern "item_drop_card_min|item_rate_card|card_drop|200|100" -Context 2,5 | Select-Object -First 40 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
