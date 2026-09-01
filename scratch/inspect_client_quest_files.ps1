$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\questinfo_f.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\luafiles514\lua files\datainfo\questinfo_f.lub"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $len = (Get-Item $f).Length
        Write-Host "File: $f (Size: $len bytes)"
        $first10 = Get-Content -Path $f -Head 15
        Write-Host "First 15 lines:"
        $first10 | ForEach-Object { Write-Host "  $_" }
        Write-Host "------------------------------------"
    } else {
        Write-Host "File NOT found: $f"
    }
}
