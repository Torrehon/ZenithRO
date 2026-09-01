Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Testing all Status entries in db/pre-re/status.yml ==="
$scriptConstLines = Get-Content -Path "src\map\script_constants.hpp"
$constants = @{}
foreach ($line in $scriptConstLines) {
    if ($line -match "export_constant\((SC_\w+)\)") {
        $constants[$matches[1]] = $true
    }
}

$statusLines = Get-Content -Path "db\pre-re\status.yml"
$missing = @()
foreach ($line in $statusLines) {
    if ($line -match "^\s*-\s*Status:\s*(\w+)") {
        $stName = $matches[1]
        $scConst = "SC_" + $stName
        if (-not $constants.ContainsKey($scConst)) {
            # Try uppercase
            $scUpper = "SC_" + $stName.ToUpper()
            if ($constants.ContainsKey($scUpper)) {
                $missing += "Status: $stName -> $scConst NOT FOUND, but $scUpper EXISTS!"
            } else {
                $missing += "Status: $stName -> $scConst NOT FOUND AT ALL!"
            }
        }
    }
}

Write-Host "Found $($missing.Count) mismatching status entries:"
$missing | ForEach-Object { Write-Host $_ }
