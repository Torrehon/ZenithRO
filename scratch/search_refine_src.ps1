Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Checking refine_cash_db or refine rates in src ==="
Select-String -Path "src\map\*.cpp","src\map\*.h" -Pattern "refine|refining|refine_db" | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
