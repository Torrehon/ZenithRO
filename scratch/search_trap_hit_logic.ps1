Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for skill_unit attack/hit/blown logic in skill.cpp, unit.cpp, battle.cpp ==="
Select-String -Path "*.cpp" -Pattern "UNT_ICEWALL|skill_unit_hit|skill_unit_blown|skill_unit_damage|BL_SKILL" -Context 1,3 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
