$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$lines = Get-Content -Path $path

Write-Host "Total lines: $($lines.Length)"

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line.Trim().Length -eq 0) { continue }
    
    if ($line.Contains("`t")) {
        Write-Host "Line $($i+1): TAB detected -> $line"
    }

    $trimmed = $line.TrimStart(' ')
    $indent = $line.Length - $trimmed.Length
    
    if ($indent % 2 -ne 0) {
        Write-Host "Line $($i+1): Odd indentation ($indent spaces) -> '$line'"
    }
}
Write-Host "Check completed."
