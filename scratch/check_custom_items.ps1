$itemDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db.yml"
$lines = Get-Content -Path $itemDb

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "^\s*-\s*Id:\s*5000\d") {
        Write-Host "Line $($i+1): $($lines[$i])"
        for ($j = 1; $j -le 5; $j++) {
            Write-Host "   $($lines[$i+$j])"
        }
    }
}
