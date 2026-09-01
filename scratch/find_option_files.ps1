Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Get-ChildItem -Path "." -Recurse -Include "*option*" | ForEach-Object {
    Write-Host $_.FullName
}
