Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Printing complete enum sc_type from status.hpp ==="
$lines = Get-Content -Path "src\map\status.hpp"
$inEnum = $false
$val = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match "enum sc_type") {
        $inEnum = $true
        continue
    }
    if ($inEnum) {
        if ($line -match "^\s*\}\s*;") {
            $inEnum = $false
            break
        }
        $clean = $line -replace "//.*$", ""
        if ($clean -match "SC_") {
            $parts = $clean.Trim().Split(",")
            foreach ($p in $parts) {
                if ($p -match "(SC_\w+)\s*(=.*)?") {
                    $name = $matches[1]
                    $assign = $matches[2]
                    if ($assign -and $assign -match "=\s*(\d+)") {
                        $val = [int]$matches[1]
                    }
                    if ($val -ge 170 -and $val -le 185) {
                        Write-Host "SC ID ${val} : ${name} (Line $($i+1))"
                    }
                    $val++
                }
            }
        }
    }
}
