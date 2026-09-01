Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "--- Searching src/map for AM_PHARMACY ---"
Get-ChildItem -Path "src/map" -Recurse -Include "*.cpp","*.hpp","*.c","*.h" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "AM_PHARMACY"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}

Write-Host "--- Searching db for produce_db / pharmacy ---"
Get-ChildItem -Path "db" -Recurse -Include "*.yml","*.txt","*.conf" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "Fire_Bottle"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
