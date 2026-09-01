Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Inspecting skill_db.yml IDs 660-685 ==="
$lines = Get-Content -Path "pre-re\skill_db.yml"
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "  - Id: (6[678]\d)") {
        Write-Host "$($lines[$i]) : $($lines[$i+1])"
    }
}
