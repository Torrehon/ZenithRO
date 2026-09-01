Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\ZenithRO" -Recurse -Filter "*book*" | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
