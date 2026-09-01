Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for Invalid status change in status.cpp ==="
Select-String -Path "src\map\status.cpp" -Pattern "Invalid status change|SC_POISON_MIST" -Context 2,5 | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
