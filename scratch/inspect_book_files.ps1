$tablePath = "d:\SERVER_RO\LevitationRO\ZenithRO\data\bookitemnametable.txt"
if (Test-Path $tablePath) {
    Write-Host "=== bookitemnametable.txt ==="
    Get-Content -Path $tablePath
}

$bookDir = "d:\SERVER_RO\LevitationRO\ZenithRO\data\book"
if (Test-Path $bookDir) {
    Write-Host "=== Files inside data\book\ ==="
    Get-ChildItem -Path $bookDir -Recurse | ForEach-Object {
        Write-Host "$($_.FullName) - Size: $($_.Length) bytes"
    }
}
