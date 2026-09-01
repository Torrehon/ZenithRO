$clsFile = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
if (Test-Path $clsFile) {
    Get-Content -Path $clsFile -Head 30 | ForEach-Object { Write-Host $_ }
} else {
    Write-Host "OngoingQuests_CLS.lub not found."
}
