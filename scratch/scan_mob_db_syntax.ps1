$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"

$lines = Get-Content -Path $path
for ($i = 42542; $i -lt 43500; $i++) {
    $line = $lines[$i]
    
    # 1. Check for comments that have weird indentation or syntax
    if ($line -match "^\s*#" -and $line -match "30L|TODO|Class:") {
        Write-Host ("Line {0:D5}: {1}" -f ($i+1), $line)
    }
    
    # 2. Check for invalid keys or keys with trailing L (like 30L or 100L)
    if ($line -match "L\b|30L|20L|10L") {
        Write-Host ("Line {0:D5} [TRAILING L]: {1}" -f ($i+1), $line)
    }
    
    # 3. Check for unexpected indentation levels in YAML mapping/sequence
    if ($line -match "^ {1,3}\S" -and $line -notmatch "^  - Id:" -and $line -notmatch "^#") {
        Write-Host ("Line {0:D5} [SUSPICIOUS INDENT 1-3]: {1}" -f ($i+1), $line)
    }
    if ($line -match "^ {5}\S" -and $line -notmatch "^#") {
        Write-Host ("Line {0:D5} [SUSPICIOUS INDENT 5]: {1}" -f ($i+1), $line)
    }
    if ($line -match "^ {7}\S" -and $line -notmatch "^#") {
        Write-Host ("Line {0:D5} [SUSPICIOUS INDENT 7]: {1}" -f ($i+1), $line)
    }
}
