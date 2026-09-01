Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Printing enum sc_type around 177 from status.hpp ==="
$lines = Get-Content -Path "src\map\status.hpp"
$inEnum = $false
$idx = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "enum sc_type\s*\{") {
        $inEnum = $true
        continue
    }
    if ($inEnum) {
        if ($lines[$i] -match "^\s*\}\s*;") {
            break
        }
        $line = $lines[$i] -replace "//.*$", ""
        if ($line -match "^\s*(SC_\w+)") {
            $name = $matches[1]
            if ($line -match "=\s*(\d+)") {
                $idx = [int]$matches[1]
            }
            if ($idx -ge 170 -and $idx -le 185) {
                Write-Host "Index $idx : $name"
            }
            $idx++
        }
    }
}
