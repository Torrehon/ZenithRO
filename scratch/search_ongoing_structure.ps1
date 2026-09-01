$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$lines = Get-Content -Path $path

Write-Host "Total lines in OngoingQuests.lub: $($lines.Length)"

# Let's search for QuestInfoList
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "QuestInfoList") {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
