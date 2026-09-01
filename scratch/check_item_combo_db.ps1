Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

$comboPaths = Get-ChildItem -Path "db" -Recurse -Include "*combo*.yml"

foreach ($f in $comboPaths) {
    Write-Host "=== Found file: $($f.FullName) ($($f.Length) bytes) ==="
    $lines = Get-Content -Path $f.FullName
    Write-Host "Total lines: $($lines.Length)"
    
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        
        # Check for tabs
        if ($line.Contains("`t")) {
            Write-Host "Line $($i+1) [TAB]: $line"
        }
        
        # Check for invalid indentation in list items
        if ($line -match "^ {1}\S" -or $line -match "^ {3}\S" -or $line -match "^ {5}\S") {
            if ($line -notmatch "^\s*#") {
                Write-Host "Line $($i+1) [ODD INDENT]: $line"
            }
        }
    }
}
