$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_equip.yml"

$lines = Get-Content -Path $path
Write-Host "Scanning all $($lines.Length) lines of db/pre-re/item_db_equip.yml..."

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    
    # 1. Non-ASCII characters
    for ($c = 0; $c -lt $line.Length; $c++) {
        if ([int]$line[$c] -gt 127) {
            Write-Host "Line $($i+1) [NON-ASCII]: '$($line[$c])' (Code: $([int]$line[$c])) -> $line"
            break
        }
    }
    
    # 2. Tabs
    if ($line.Contains("`t")) {
        Write-Host "Line $($i+1) [TAB]: $line"
    }
}
