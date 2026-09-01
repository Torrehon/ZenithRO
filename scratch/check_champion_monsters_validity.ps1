$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"

$lines = Get-Content -Path $path

Write-Host "Checking entries from 42543 to 44000..."

for ($i = 42542; $i -lt 44000; $i++) {
    $line = $lines[$i]
    
    # Check for tabs
    if ($line.Contains("`t")) {
        Write-Host "TAB at Line $($i+1): $line"
    }
    
    # Check for non-ASCII
    for ($c = 0; $c -lt $line.Length; $c++) {
        if ([int]$line[$c] -gt 127) {
            Write-Host "NON-ASCII at Line $($i+1), Char $($c+1): '$($line[$c])' (Code: $([int]$line[$c]))"
        }
    }
    
    # Check for unquoted special characters in scalar values
    if ($line -match "^\s+\w+:\s+[^'""#\d\[\]{}].*[:#]") {
        Write-Host "UNQUOTED SPECIAL CHAR at Line $($i+1): $line"
    }
}
