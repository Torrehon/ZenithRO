Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for UNT_ or skill_unit setting in skill.cpp ==="
Select-String -Path "skill.cpp","skill.h" -Pattern "UNT_FREEZING|UNT_LANDMINE|UNT_SKIDTRAP|UNT_FLAMERUBBER|skill_unit_setting" -Context 2,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
