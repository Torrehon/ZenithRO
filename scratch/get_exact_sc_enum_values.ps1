Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Calculating exact enum sc_type integer values in status.hpp ==="
$lines = Get-Content -Path "src\map\status.hpp"
$inEnum = $false
$val = 0

foreach ($line in $lines) {
    if ($line -match "enum sc_type") {
        $inEnum = $true
        continue
    }
    if ($inEnum) {
        if ($line -match "^\s*\}\s*;") {
            $inEnum = $false
            break
        }
        # Ignore comments or empty lines
        $cleanLine = $line -replace "//.*$", ""
        if ($cleanLine -match "^\s*(SC_\w+)\s*(=\s*(\d+))?\s*,?") {
            $scName = $matches[1]
            if ($matches[3]) {
                $val = [int]$matches[3]
            }
            if ($val -ge 170 -and $val -le 185) {
                Write-Host "SC Enum $val => $scName"
            }
            $val++
        }
    }
}
