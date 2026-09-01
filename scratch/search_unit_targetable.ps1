Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for UF_ (Unit Flags) in skill.cpp / skill.h ==="
Select-String -Path "skill.cpp","clif.cpp","unit.cpp","battle.cpp" -Pattern "UF_|unit_flag|UF_DAMAGEABLE|UF_ATTACKABLE|UF_HIT" -Context 1,3 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
