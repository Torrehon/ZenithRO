Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Checking existence of db/status.yml ==="
if (Test-Path "db\status.yml") {
    Write-Host "db/status.yml EXISTS! Size: $((Get-Item db\status.yml).Length) bytes"
} else {
    Write-Host "db/status.yml DOES NOT EXIST."
}

if (Test-Path "db\pre-re\status.yml") {
    Write-Host "db/pre-re/status.yml EXISTS! Size: $((Get-Item db\pre-re\status.yml).Length) bytes"
}
