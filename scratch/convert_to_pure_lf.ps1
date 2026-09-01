$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$bytes = [System.IO.File]::ReadAllBytes($path)

# Remove BOM if present (EF BB BF)
$startIndex = 0
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    $startIndex = 3
}

$cleanBytes = [System.Collections.Generic.List[byte]]::new()
for ($i = $startIndex; $i -lt $bytes.Length; $i++) {
    if ($bytes[$i] -ne 13) { # Skip \r (13)
        $cleanBytes.Add($bytes[$i])
    }
}

[System.IO.File]::WriteAllBytes($path, $cleanBytes.ToArray())

# Verify
$newBytes = [System.IO.File]::ReadAllBytes($path)
$cr = 0
$lf = 0
for ($i = 0; $i -lt $newBytes.Length; $i++) {
    if ($newBytes[$i] -eq 13) { $cr++ }
    if ($newBytes[$i] -eq 10) { $lf++ }
}

Write-Host "File saved with pure LF!"
Write-Host "CR count: $cr"
Write-Host "LF count: $lf"
Write-Host "First byte: 0x$($newBytes[0].ToString('X2'))"
