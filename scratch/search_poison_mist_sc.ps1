Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for 752 or SC_ in status.hpp / skill.cpp ==="
Select-String -Path "src\map\status.hpp","src\map\status.cpp","src\map\skills\*.cpp","src\map\skills\*\*.cpp" -Pattern "MH_POISON_MIST|POISON_MIST|752" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
