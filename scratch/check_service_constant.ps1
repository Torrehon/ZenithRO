Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching script_constants.hpp for SERVICE ==="
Select-String -Path "src\map\script_constants.hpp" -Pattern "SERVICE" -Context 0,1 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
