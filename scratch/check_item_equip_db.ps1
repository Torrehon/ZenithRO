Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

$paths = @(
    "db/pre-re/item_db_equip.yml",
    "db/re/item_db_equip.yml",
    "db/item_db_equip.yml",
    "db/import/item_db_equip.yml"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        $totalLines = (Get-Content $p).Length
        Write-Host "=== Found $p (Total lines: $totalLines) ==="
        if ($totalLines -ge 25200) {
            $lines = Get-Content -Path $p
            $start = 25210 - 1
            $end = [Math]::Min($lines.Length - 1, 25300 - 1)
            
            for ($i = $start; $i -le $end; $i++) {
                $line = $lines[$i]
                
                # Check for non-ASCII
                $hasNonAscii = $false
                for ($c = 0; $c -lt $line.Length; $c++) {
                    if ([int]$line[$c] -gt 127) {
                        $hasNonAscii = $true
                        break
                    }
                }
                
                $hasTab = $line.Contains("`t")
                $flag = ""
                if ($hasNonAscii) { $flag += " [NON-ASCII]" }
                if ($hasTab) { $flag += " [TAB]" }
                
                Write-Host ("Line {0:D5}{1}: {2}" -f ($i+1), $flag, $line)
            }
        }
    }
}
