Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching src/ for Database loading Mode / Clear logic ==="
Select-String -Path "src\lib\yaml.cpp","src\map\*.cpp" -Pattern "Mode::Merge|clear\(\)|purge\(\)|prepare\(\)" -Context 0,3 | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
