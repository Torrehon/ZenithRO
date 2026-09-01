$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($f in $files) {
    Write-Host "=== $f ==="
    $text = [System.IO.File]::ReadAllText($f)
    $openCount = ([regex]::Matches($text, '\{')).Count
    $closeCount = ([regex]::Matches($text, '\}')).Count
    Write-Host "Open '{': $openCount | Close '}': $closeCount"
    
    # Check for missing commas on lines with closing braces before new entry
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "^\s*\}\s*$" -and $i+1 -lt $lines.Length -and $lines[$i+1] -match "^\s*\[\d+\]") {
            Write-Host "WARNING: Line $($i+1) has '}' without trailing comma before line $($i+2): '$($lines[$i+1])'"
        }
    }
}
