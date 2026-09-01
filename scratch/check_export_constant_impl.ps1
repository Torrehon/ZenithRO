Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for export_constant definition in src/map/ ==="
Select-String -Path "src\map\*.cpp","src\map\*.hpp" -Pattern "#define export_constant" -Context 0,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
