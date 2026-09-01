Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\db" -Recurse -Filter "*produce*" | ForEach-Object {
    Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
}
