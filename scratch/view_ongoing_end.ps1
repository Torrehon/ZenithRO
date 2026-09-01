$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$lines = Get-Content -Path $path
Write-Host "Total lines in OngoingQuests.lub: $($lines.Length)"

# Show around 24690 and the end
for ($i = 24685; $i -lt [Math]::Min($lines.Length, 24720); $i++) {
    Write-Host "Line $($i+1): $($lines[$i])"
}

Write-Host "=== END OF FILE ==="
for ($i = [Math]::Max(0, $lines.Length - 40); $i -lt $lines.Length; $i++) {
    Write-Host "Line $($i+1): $($lines[$i])"
}
