$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($f in $files) {
    Write-Host "=== Searching in $f ==="
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "\[70001\]" -or $lines[$i] -match "70001#") {
            Write-Host "Found 70001 at line $($i+1): $($lines[$i])"
        }
        if ($lines[$i] -match "\[70401\]" -or $lines[$i] -match "70401#") {
            Write-Host "Found 70401 at line $($i+1): $($lines[$i])"
        }
    }
}
