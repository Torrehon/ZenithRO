$etcDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$lines = Get-Content -Path $etcDb

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Id:\s*50007") {
        Write-Host "Found 50007 at line $($i+1)"
        for ($j = -2; $j -le 12; $j++) {
            Write-Host $lines[$i+$j]
        }
    }
}
