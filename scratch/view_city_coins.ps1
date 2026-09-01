$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$lines = Get-Content -Path $etcDb

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Id:\s*5000[3-8]") {
        for ($j = 0; $j -le 8; $j++) {
            Write-Host $lines[$i+$j]
        }
        Write-Host "---"
    }
}
