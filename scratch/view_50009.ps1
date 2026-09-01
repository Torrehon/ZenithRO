$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$lines = Get-Content -Path $etcDb

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "50009") {
        for ($j = -2; $j -le 8; $j++) {
            Write-Host $lines[$i+$j]
        }
    }
}
