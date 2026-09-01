Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching mob.cpp for SUMMONSLAVE or slave handling ==="
Select-String -Path "src\map\mob.cpp" -Pattern "MSC_SLAVE|NPC_SUMMONSLAVE|mob_summonslave" -Context 2,5 | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
