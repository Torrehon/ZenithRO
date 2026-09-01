$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$lines = Get-Content -Path $path

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Contains("`t")) {
        Write-Host "Tab on line $($i+1): $line"
    }
}

# Check for empty lines or weird comments between list items
for ($i = 7160; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -match "^#") {
        Write-Host "Comment at root column on line $($i+1): $line"
    }
}
