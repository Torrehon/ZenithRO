$files = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re" -Filter "*.yml" -Recurse

foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $hasCr = $false
    $hasBom = $false

    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $hasBom = $true
    }

    for ($i = 0; $i -lt $bytes.Length; $i++) {
        if ($bytes[$i] -eq 13) {
            $hasCr = $true
            break
        }
    }

    if ($hasCr -or $hasBom) {
        Write-Host "Converting $($f.Name) to pure LF (BOM=$hasBom, CR=$hasCr)..."
        $startIndex = if ($hasBom) { 3 } else { 0 }
        $cleanBytes = [System.Collections.Generic.List[byte]]::new()
        for ($i = $startIndex; $i -lt $bytes.Length; $i++) {
            if ($bytes[$i] -ne 13) {
                $cleanBytes.Add($bytes[$i])
            }
        }
        [System.IO.File]::WriteAllBytes($f.FullName, $cleanBytes.ToArray())
    }
}

Write-Host "All pre-re YAML database files are now 100% pure LF without BOM."
