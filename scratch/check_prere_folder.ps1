Get-ChildItem -Path "D:\SERVER_RO\PARA CLIENTE PRE-RENEWAL" -Recurse -Filter "*itemInfo*" | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
