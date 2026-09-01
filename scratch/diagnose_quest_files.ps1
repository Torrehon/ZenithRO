$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\questinfo_f.lub"
)

foreach ($f in $files) {
    if (Test-Path $f) {
        $bytes = [System.IO.File]::ReadAllBytes($f)
        $text = [System.IO.File]::ReadAllText($f)
        Write-Host "=== $f ==="
        Write-Host "Size: $($bytes.Length) bytes"
        
        # Check if 70016 or 70401 exists
        $has70016 = $text.Contains("70016")
        $has70401 = $text.Contains("70401")
        Write-Host "Contains 70016: $has70016 | Contains 70401: $has70401"
    } else {
        Write-Host "FILE NOT FOUND: $f"
    }
}
