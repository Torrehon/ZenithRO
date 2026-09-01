# Search item_db for books
$itemDb = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"
$lines = Get-Content -Path $itemDb
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "AegisName:.*Guide" -or $lines[$i] -match "AegisName:.*Book" -or $lines[$i] -match "Script:.*readbook") {
        Write-Host "Line $($i+1): $($lines[$i])"
        for ($j = [Math]::Max(0, $i-3); $j -le [Math]::Min($lines.Length-1, $i+10); $j++) {
            Write-Host "   $($lines[$j])"
        }
        Write-Host "------------------------"
    }
}
