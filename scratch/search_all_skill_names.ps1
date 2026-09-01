Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching for BREAKER, METEOR, WIDE in skill_db.yml ==="
$lines = Get-Content -Path "pre-re\skill_db.yml"
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "Name: (.*BREAKER.*|.*METEOR.*|.*WIDE.*|.*POISON.*)") {
        Write-Host "$($lines[$i-1]) -> $($lines[$i])"
    }
}
