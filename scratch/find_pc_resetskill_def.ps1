$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\pc.cpp"
Select-String -Path $path -Pattern "pc_resetskill" | ForEach-Object {
    Write-Host "Line $($_.LineNumber): $($_.Line)"
}
