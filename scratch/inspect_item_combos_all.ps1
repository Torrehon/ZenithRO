$paths = @(
    "d:\SERVER_RO\LevitationRO\rathena\db\import\item_combos.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_combos.yml",
    "d:\SERVER_RO\LevitationRO\rathena\db\item_combos.yml"
)

foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Host "=========================================="
        Write-Host "Inspecting $p"
        Write-Host "=========================================="
        $lines = Get-Content -Path $p
        
        for ($i = 0; $i -lt $lines.Length; $i++) {
            $line = $lines[$i]
            
            # Check tabs
            if ($line.Contains("`t")) {
                Write-Host "Line $($i+1) [TAB]: $line"
            }
            
            # Check unclosed brackets
            $openB = ($line -replace '[^\[]').Length
            $closeB = ($line -replace '[^\]]').Length
            if ($openB -ne $closeB) {
                Write-Host "Line $($i+1) [UNMATCHED BRACKETS]: $line"
            }
            
            # Check unclosed quotes
            $qCount = ($line -replace '[^"]').Length
            if ($qCount % 2 -ne 0) {
                Write-Host "Line $($i+1) [ODD DOUBLE QUOTES]: $line"
            }
            
            # Check script blocks ending without semicolon
            if ($line -match "^\s{6}\S" -and $line -notmatch ";\s*$" -and $line -notmatch "^\s*#" -and $line -notmatch "^\s*//") {
                Write-Host "Line $($i+1) [SCRIPT MISSING SEMICOLON]: $line"
            }
        }
    }
}
