$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$lines = Get-Content -Path $path

$ammoIds = @(
    13200, 13201, 13202, 13215, 13216, 13217, 13218, 13219, 13220, 
    13221, 13222, 13223, 13224, 13225, 13226, 13227, 13228, 13229, 
    13230, 13231, 13232, 50021, 50022
)

Write-Host "=== Checking Pre-RE item_db_etc.yml ==="
foreach ($id in $ammoIds) {
    $found = $false
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "^\s*-\s*Id:\s*$id\b") {
            $aegis = ""
            $name = ""
            if ($i+1 -lt $lines.Length) { $aegis = $lines[$i+1] }
            if ($i+2 -lt $lines.Length) { $name = $lines[$i+2] }
            Write-Host "FOUND in Pre-RE: ID $id | $aegis | $name"
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Host "NOT in Pre-RE: ID $id"
    }
}
