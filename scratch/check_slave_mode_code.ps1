Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for status_calc_slave_mode ==="
Select-String -Path "src\map\*.cpp","src\map\*.hpp" -Pattern "status_calc_slave_mode" -Context 2,10 | Select-Object -First 5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
