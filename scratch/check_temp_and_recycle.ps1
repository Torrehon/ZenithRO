$recycleBin = "C:\`$Recycle.Bin"
if (Test-Path $recycleBin) {
    Get-ChildItem -Path $recycleBin -Recurse -Filter "*itemInfo*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "Recycle bin: $($_.FullName) - Size: $($_.Length) bytes"
    }
}

$temp = $env:TEMP
Get-ChildItem -Path $temp -Recurse -Filter "*itemInfo*" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Temp: $($_.FullName) - Size: $($_.Length) bytes"
}
