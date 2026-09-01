Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Inspecting status.hpp for Status Change 177 ==="
$lines = Get-Content -Path "src\map\status.hpp"
$scIndex = 0
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "enum sc_type") {
        for ($j = $i; $j -lt $i + 400; $j++) {
            if ($lines[$j] -match "SC_") {
                if ($scIndex -ge 174 -and $scIndex -le 180) {
                    Write-Host "Index ${scIndex}: $($lines[$j])"
                }
                $scIndex++
            }
        }
        break
    }
}
