$f1 = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\questinfo_f.lub"
$f2 = "d:\SERVER_RO\LevitationRO\ZenithRO\data\luafiles514\lua files\datainfo\questinfo_f.lub"

foreach ($f in @($f1, $f2)) {
    if (Test-Path $f) {
        Write-Host "=== $f ==="
        Get-Content -Path $f -Head 30 | ForEach-Object { Write-Host $_ }
    }
}
