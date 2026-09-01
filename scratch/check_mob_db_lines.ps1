Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

$paths = @("db/pre-re/mob_db.yml", "db/re/mob_db.yml", "db/mob_db.yml")

foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Host "=== Found $p (Total lines: $((Get-Content $p).Length)) ==="
        $lines = Get-Content -Path $p
        $start = [Math]::Max(0, 42530 - 1)
        $end = [Math]::Min($lines.Length - 1, 42580 - 1)
        
        for ($i = $start; $i -le $end; $i++) {
            $line = $lines[$i]
            # Check for non-ASCII characters or tab characters
            $hasNonAscii = $line -match "[^\x00-\x7F]"
            $hasTab = $line -match "\t"
            $hasTrailingSpace = $line -match "\s+$"
            $flag = ""
            if ($hasNonAscii) { $flag += " [NON-ASCII]" }
            if ($hasTab) { $flag += " [TAB]" }
            if ($hasTrailingSpace) { $flag += " [TRAILING-SPACE]" }
            
            Write-Host ("Line {0:D5}{1}: {2}" -f ($i+1), $flag, $line)
        }
    }
}
