Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for casing mismatches in db/pre-re/status.yml ==="
$scriptConstLines = Get-Content -Path "src\map\script_constants.hpp"
$constants = @{}
foreach ($line in $scriptConstLines) {
    if ($line -match "export_constant\((SC_\w+)\)") {
        $constants[$matches[1]] = $true
    }
}

$statusLines = Get-Content -Path "db\pre-re\status.yml"
$mismatches = @()
for ($i = 0; $i -lt $statusLines.Count; $i++) {
    if ($statusLines[$i] -match "^\s*-\s*Status:\s*(\w+)") {
        $stName = $matches[1]
        $scConst = "SC_" + $stName
        if (-not $constants.ContainsKey($scConst)) {
            $scUpper = "SC_" + $stName.ToUpper()
            if ($constants.ContainsKey($scUpper)) {
                $mismatches += [PSCustomObject]@{
                    Line = $i + 1
                    Original = $stName
                    Upper = $stName.ToUpper()
                    Target = $scUpper
                }
            }
        }
    }
}

Write-Host "Found $($mismatches.Count) casing mismatches in status.yml:"
$mismatches | ForEach-Object {
    Write-Host "Line $($_.Line): Status: $($_.Original) should be Status: $($_.Upper) (matches $($_.Target))"
}
