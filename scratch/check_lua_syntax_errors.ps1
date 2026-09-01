$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($path in $files) {
    Write-Host "=== Searching in $path ==="
    $lines = Get-Content -Path $path
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "\[8214\]" -or $lines[$i] -match "\[8216\]") {
            Write-Host "Line $($i+1): $($lines[$i])"
        }
    }
}
