Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Write-Host "=== Searching for Trading Merchant in izlude_in ==="
Get-ChildItem -Path "." -Recurse -Include "*.txt" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "Trading Merchant|izlude_in"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
