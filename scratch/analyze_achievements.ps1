$prerePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml"
$rePath = "d:\SERVER_RO\LevitationRO\rathena\db\re\achievement_db.yml"

foreach ($p in @($prerePath, $rePath)) {
    Write-Host "=== Analysis of $p ==="
    if (Test-Path $p) {
        $lines = Get-Content -Path $p
        $shabbyCount = 0
        $shabbyDisabled = 0
        
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "Shabby_Purse") {
                $shabbyCount++
            }
        }
        Write-Host "Total references to Shabby_Purse: $shabbyCount"
    } else {
        Write-Host "File NOT found: $p"
    }
}
