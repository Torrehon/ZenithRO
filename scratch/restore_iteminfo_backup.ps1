Get-ChildItem -Path "d:\SERVER_RO\LevitationRO" -Recurse -Filter "*itemInfo*" | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
