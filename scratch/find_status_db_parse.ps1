Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching status.cpp for parseBody or StatusDatabase ==="
Select-String -Path "src\map\status.cpp" -Pattern "StatusDatabase::" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
