Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src"

Write-Host "=== Searching for IT_CARD in src/map/ ==="
Select-String -Path "map\*.cpp" -Pattern "IT_CARD" -Context 0,2 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
