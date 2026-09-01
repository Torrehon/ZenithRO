$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_equip.yml"

$lines = Get-Content -Path $path

Write-Host "Scanning db/pre-re/item_db_equip.yml from line 25210 to 27000..."

for ($i = 25209; $i -lt [Math]::Min($lines.Length, 27000); $i++) {
    $line = $lines[$i]
    
    # 1. Non-ASCII
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
    
    # 3. Check for invalid quotes in Script blocks or comments
    if ($line -match "^\s*Script:\s*\|" -or $line -match "^\s*EquipScript:\s*\|") {
        # Check script block below
        for ($j = $i+1; $j -lt $lines.Length; $j++) {
            $sLine = $lines[$j]
            if ($sLine -match "^\s{6}\S") {
                # Script line
                if ($sLine -match "#" -and $sLine -notmatch "//") {
                    # In rAthena scripts, # is a global variable prefix (e.g. #VAR), NOT a YAML comment inside script block, unless misplaced!
                }
            } else {
                break
            }
        }
    }
}
