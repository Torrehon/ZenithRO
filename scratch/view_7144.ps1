$path = "d:\SERVER_RO\LevitationRO\ZenithRO\data\book\7144.txt"
if (Test-Path $path) {
    Get-Content -Path $path -Head 60 | ForEach-Object { Write-Host $_ }
}
