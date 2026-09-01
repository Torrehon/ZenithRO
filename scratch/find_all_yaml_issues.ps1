$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$lines = Get-Content -Path $path

for ($i = 50; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Trim().Length -gt 0 -and -not $line.StartsWith("  ")) {
        Write-Host "Unindented line $($i+1): '$line'"
    }
}
