Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Validating all status entries before line 1912 in db/pre-re/status.yml ==="
$scriptConstLines = Get-Content -Path "src\map\script_constants.hpp"
$constants = New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
foreach ($line in $scriptConstLines) {
    if ($line -match "export_constant\((SC_\w+|EFST_\w+|SCS_\w+|SCB_\w+|OPTION_\w+)\)") {
        [void]$constants.Add($matches[1])
    }
}

$statusLines = Get-Content -Path "db\pre-re\status.yml"
$errors = @()

for ($i = 0; $i -lt 1920; $i++) {
    $line = $statusLines[$i]
    if ($line -match "^\s*-\s*Status:\s*(\w+)") {
        $st = $matches[1]
        $sc = "SC_" + $st
        if (-not $constants.Contains($sc)) {
            $errors += "Line $($i+1): Status $st -> $sc not in script_constants!"
        }
    }
    if ($line -match "^\s*Icon:\s*(\w+)") {
        $ic = $matches[1]
        if (-not $constants.Contains($ic) -and $ic -ne "EFST_BLANK") {
            $errors += "Line $($i+1): Icon $ic not in script_constants!"
        }
    }
}

Write-Host "Found $($errors.Count) errors before line 1912:"
$errors | ForEach-Object { Write-Host $_ }
