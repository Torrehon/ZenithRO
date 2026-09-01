Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for HT_FREEZINGTRAP, HT_LANDMINE, HT_SKIDTRAP in src/map/ ==="
Select-String -Path "src\map\*.cpp","src\map\*.h" -Pattern "HT_FREEZING|HT_LANDMINE|HT_SKIDTRAP|HT_ANKLESNARE|UNT_|SUB_" -Context 1,3 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}

Write-Host "`n=== Searching skill_unit_db.yml for trap units ==="
Select-String -Path "db\pre-re\skill_unit_db.yml","db\re\skill_unit_db.yml" -Pattern "HT_FREEZING|HT_LANDMINE|HT_SKIDTRAP" -Context 2,10 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
