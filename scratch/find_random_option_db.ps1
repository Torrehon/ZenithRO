Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Get-ChildItem -Path "." -Recurse -Filter "*random*.yml" | ForEach-Object {
    Write-Host $_.FullName
}
