$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$lines = Get-Content -Path $path

Write-Host "=== Line 85865 to 85880 ==="
for ($i = 85865; $i -lt 85880; $i++) {
    Write-Host "Line $($i+1): $($lines[$i])"
}

Write-Host "=== Line 87100 to 87115 ==="
for ($i = 87100; $i -lt 87115; $i++) {
    Write-Host "Line $($i+1): $($lines[$i])"
}
