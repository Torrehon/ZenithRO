$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_equip.yml"

$lines = Get-Content -Path $path
for ($i = 25216 - 1; $i -lt [Math]::Min($lines.Length, 25350); $i++) {
    $line = $lines[$i]
    $leadingSpaces = 0
    if ($line -match "^(\s+)") {
        $leadingSpaces = $matches[1].Length
    }
    
    $hasNonAscii = $false
    for ($c = 0; $c -lt $line.Length; $c++) {
        if ([int]$line[$c] -gt 127) {
            $hasNonAscii = $true
            break
        }
    }
    
    $flag = ""
    if ($hasNonAscii) { $flag += " [NON-ASCII]" }
    if ($line.Contains("`t")) { $flag += " [TAB]" }
    
    Write-Host ("Line {0:D5} [Indent:{1:D2}]{2}: {3}" -f ($i+1), $leadingSpaces, $flag, $line)
}
