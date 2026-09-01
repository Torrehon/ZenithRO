$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\atcommand.cpp"

Select-String -Path $path -Pattern "mobinfo" -Context 0,5 | ForEach-Object {
    Write-Host "Line $($_.LineNumber): $($_.Line)"
}
