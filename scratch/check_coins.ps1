$itemDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db.yml"
$lines = Get-Content -Path $itemDb

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -like "*Coin*" -or $lines[$i] -like "*coin*") {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
