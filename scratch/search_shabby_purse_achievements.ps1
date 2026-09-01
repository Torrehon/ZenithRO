$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\re\achievement_db.yml"
)

foreach ($f in $files) {
    Write-Host "=== Searching in $f ==="
    if (Test-Path $f) {
        $lines = Get-Content -Path $f
        for ($i = 0; $i -lt $lines.Length; $i++) {
            if ($lines[$i] -match "Shabby_Purse" -or $lines[$i] -match "22876") {
                Write-Host "Found at line $($i+1): $($lines[$i])"
                for ($j = [Math]::Max(0, $i-15); $j -le [Math]::Min($lines.Length-1, $i+5); $j++) {
                    Write-Host "   $($lines[$j])"
                }
            }
        }
    }
}
