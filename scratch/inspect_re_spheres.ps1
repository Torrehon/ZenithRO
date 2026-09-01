$rePath = "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_etc.yml"
$lines = Get-Content -Path $rePath

$ids = @(13223, 13224, 13225, 13226, 13227)

foreach ($id in $ids) {
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "^\s*-\s*Id:\s*$id\b") {
            Write-Host "=== ID $id in RE ==="
            for ($j = $i; $j -le $i+12; $j++) {
                if ($j -lt $lines.Length) {
                    Write-Host $lines[$j]
                }
            }
        }
    }
}
