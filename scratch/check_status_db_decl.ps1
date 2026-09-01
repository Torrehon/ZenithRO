Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching status.hpp for status_db declaration ==="
Select-String -Path "src\map\status.hpp" -Pattern "status_db" -Context 0,2 | Select-Object -First 10 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
