Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Checking rathena/db/pre-re/status.yml for encoding / BOM ==="
$bytes = [System.IO.File]::ReadAllBytes("d:\SERVER_RO\LevitationRO\rathena\db\pre-re\status.yml")
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "WARNING: rathena/db/pre-re/status.yml HAS A UTF-8 BOM!"
} else {
    Write-Host "rathena/db/pre-re/status.yml has NO UTF-8 BOM."
}

$importBytes = [System.IO.File]::ReadAllBytes("d:\SERVER_RO\LevitationRO\rathena\db\import\status.yml")
if ($importBytes.Length -ge 3 -and $importBytes[0] -eq 0xEF -and $importBytes[1] -eq 0xBB -and $importBytes[2] -eq 0xBF) {
    Write-Host "WARNING: rathena/db/import/status.yml HAS A UTF-8 BOM!"
} else {
    Write-Host "rathena/db/import/status.yml has NO UTF-8 BOM."
}
