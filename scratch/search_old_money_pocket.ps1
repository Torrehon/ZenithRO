Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching item_db for Old Money Pocket ==="
Get-ChildItem -Path "db" -Recurse -Include "*.yml" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "Old_Money_Pocket|Money_Pocket|Old Money"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}

Write-Host "=== Searching achievement_db for Old Money Pocket ==="
Get-ChildItem -Path "db" -Recurse -Filter "*achievement*" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "Old_Money_Pocket|Money_Pocket|7622|7621|7623|7624|7625"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
