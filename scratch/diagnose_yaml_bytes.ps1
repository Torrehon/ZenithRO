$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$bytes = [System.IO.File]::ReadAllBytes($path)

Write-Host "File size in bytes: $($bytes.Length)"

# Check for BOM (EF BB BF)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "WARNING: UTF-8 BOM detected at start of file!"
} else {
    Write-Host "No UTF-8 BOM detected."
}

$lines = Get-Content -Path $path
Write-Host "Total lines: $($lines.Length)"

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains("`r")) {
        Write-Host "CR on line $($i+1)"
    }
    # Check for quotes or colons without space
    if ($line -match ":[^\s#]" -and $line -notmatch "https?://") {
        Write-Host "Colon without space on line $($i+1): '$line'"
    }
}
