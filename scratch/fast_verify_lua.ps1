$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($path in $files) {
    Write-Host "=== Checking $path ==="
    $text = [System.IO.File]::ReadAllText($path)
    $openCount = ([regex]::Matches($text, '\{')).Count
    $closeCount = ([regex]::Matches($text, '\}')).Count
    Write-Host "Open braces '{': $openCount"
    Write-Host "Close braces '}': $closeCount"
}
