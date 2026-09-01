Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for files matching skill_unit in db ==="
Get-ChildItem -Path "db" -Recurse -Filter "*unit*" | ForEach-Object { Write-Host $_.FullName }

Write-Host "`n=== Searching for HT_FREEZINGTRAP or HT_LANDMINE in db/ ==="
Select-String -Path "db\*.yml","db\**\*.yml" -Pattern "HT_FREEZINGTRAP|HT_LANDMINE|HT_SKIDTRAP" | Select-Object -First 20 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
