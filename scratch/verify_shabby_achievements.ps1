$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\re\achievement_db.yml"
)

foreach ($f in $files) {
    Write-Host "=== Verifying $f ==="
    $lines = Get-Content -Path $f
    $commented = 0
    $enabled = 0
    
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "#Rewards:" -and $i+1 -lt $lines.Length -and $lines[$i+1] -match "Shabby_Purse") {
            $commented++
        }
        if ($lines[$i] -match "Rewards:" -and -not ($lines[$i] -match "#") -and $i+1 -lt $lines.Length -and $lines[$i+1] -match "Shabby_Purse") {
            $enabled++
        }
    }
    Write-Host "Commented: $commented | Enabled: $enabled"
}
