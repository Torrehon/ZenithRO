Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching clif.cpp for UNT_ or skill_unit ==="
Select-String -Path "clif.cpp" -Pattern "UNT_ICEWALL|UNT_LANDMINE|UNT_FREEZINGTRAP|clif_skill_unit" -Context 1,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
