$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

foreach ($path in $files) {
    Write-Host "=== Checking $path ==="
    $lines = Get-Content -Path $path
    $openBraces = 0
    $closeBraces = 0

    for ($i = 0; $i -lt $lines.Length; $i++) {
        $l = $lines[$i]
        $openBraces += ($l.ToCharArray() | Where-Object { $_ -eq '{' }).Count
        $closeBraces += ($l.ToCharArray() | Where-Object { $_ -eq '}' }).Count
    }

    Write-Host "Open braces '{': $openBraces"
    Write-Host "Close braces '}': $closeBraces"
    if ($openBraces -eq $closeBraces) {
        Write-Host "Brace count MATCHES perfectly!"
    } else {
        Write-Host "WARNING: Brace count MISMATCH!"
    }
}
