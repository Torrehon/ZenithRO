Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src"

Write-Host "=== Checking PACKETVER in mmo.hpp ==="
Get-ChildItem -Path "." -Recurse -Include "mmo.hpp" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "PACKETVER"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
