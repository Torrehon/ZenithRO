Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\client_2023_clean" -Recurse -Filter "*itemInfo*" | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
