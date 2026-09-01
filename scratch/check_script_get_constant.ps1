Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching script.cpp for script_get_constant ==="
Select-String -Path "src\map\script.cpp" -Pattern "script_get_constant" -Context 0,10 | Select-Object -First 10 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
