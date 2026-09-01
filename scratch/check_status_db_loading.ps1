Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching status.cpp for StatusDatabase or STATUS_DB ==="
Select-String -Path "src\map\status.cpp" -Pattern "STATUS_DB|StatusDatabase|status_db" -Context 0,5 | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
