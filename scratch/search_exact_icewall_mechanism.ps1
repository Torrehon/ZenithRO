Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for WZ_ICEWALL handling in skill.cpp, clif.cpp, unit.cpp, battle.cpp ==="
Select-String -Path "*.cpp" -Pattern "WZ_ICEWALL|UNT_ICEWALL" -Context 1,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
