Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for MF_LEAVES in C++ ==="
Select-String -Path "*.cpp","*.h" -Pattern "MF_LEAVES|mf_leaves|clif_weather" -Context 1,5 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
