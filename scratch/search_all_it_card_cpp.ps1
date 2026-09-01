Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Select-String -Path "*.cpp","skills\*\*.cpp" -Pattern "IT_CARD" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
