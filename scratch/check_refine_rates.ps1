Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for refine db and config files ==="
Get-ChildItem -Recurse -Include "*refine*" | ForEach-Object {
    Write-Host $_.FullName
}

Write-Host "`n=== Checking db/pre-re/refine_db.yml if it exists ==="
$refineDbPaths = @(
    "db/pre-re/refine_db.yml",
    "db/re/refine_db.yml",
    "db/refine_db.yml",
    "db/import/refine_db.yml"
)

foreach ($p in $refineDbPaths) {
    if (Test-Path $p) {
        Write-Host "--- Content of $p ---"
        Get-Content $p | Select-Object -First 100
    }
}
