Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\ZenithRO" -Recurse -Filter "*itemInfo*" | ForEach-Object {
    Write-Host $_.FullName
}
