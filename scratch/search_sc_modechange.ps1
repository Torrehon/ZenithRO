Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching src/map/ for SC_MODECHANGE ==="
Select-String -Path "src\map\*.cpp","src\map\*.hpp","src\map\skills\*\*.cpp" -Pattern "SC_MODECHANGE" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
