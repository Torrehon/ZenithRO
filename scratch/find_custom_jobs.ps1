Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src"

Select-String -Path "map\pc.hpp","common\mmo.hpp" -Pattern "4501|4502|GENIN|HIREGUN" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
