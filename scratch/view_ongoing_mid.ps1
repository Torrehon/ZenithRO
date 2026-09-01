$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub"
$lines = Get-Content -Path $path

for ($i = 87080; $i -lt 87120; $i++) {
    Write-Host "Line $($i+1): $($lines[$i])"
}
