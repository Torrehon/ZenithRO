$possiblePaths = @(
    "C:\xampp\mysql\data\rathena",
    "C:\Program Files\MySQL\MySQL Server 8.0\data\rathena",
    "C:\ProgramData\MySQL\MySQL Server 8.0\data\rathena",
    "C:\MariaDB\data\rathena"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        Write-Host "=== Found MySQL DB directory at $path ==="
        Get-ChildItem -Path $path | ForEach-Object {
            Write-Host "$($_.Name) | Size: $($_.Length) bytes | LastWrite: $($_.LastWriteTime)"
        }
    }
}
