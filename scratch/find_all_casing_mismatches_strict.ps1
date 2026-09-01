Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Strictly searching for casing mismatches in db/pre-re/status.yml ==="
$scriptConstLines = Get-Content -Path "src\map\script_constants.hpp"
$constants = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::Ordinal)
foreach ($line in $scriptConstLines) {
    if ($line -match "export_constant\((SC_\w+)\)") {
        [void]$constants.Add($matches[1])
    }
}

$statusLines = Get-Content -Path "db\pre-re\status.yml"
$mismatches = @()
for ($i = 0; $i -lt $statusLines.Count; $i++) {
    if ($statusLines[$i] -match "^\s*-\s*Status:\s*(\w+)") {
        $stName = $matches[1]
        $scConst = "SC_" + $stName
        if (-not $constants.Contains($scConst)) {
            $scUpper = "SC_" + $stName.ToUpper()
            if ($constants.Contains($scUpper)) {
                $mismatches += [PSCustomObject]@{
                    Line = $i + 1
                    Original = $stName
                    Upper = $stName.ToUpper()
                    Target = $scUpper
                }
            } else {
                Write-Host "Line $($i+1): Status: $stName -> $scConst completely NOT found!"
            }
        }
    }
}

Write-Host "Found $($mismatches.Count) casing mismatches in status.yml:"
$mismatches | ForEach-Object {
    Write-Host "Line $($_.Line): Status: $($_.Original) -> Should be Status: $($_.Upper) (Target: $($_.Target))"
}
