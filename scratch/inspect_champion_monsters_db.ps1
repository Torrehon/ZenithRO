$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db.yml"

$lines = Get-Content -Path $path
for ($i = 42540 - 1; $i -lt 42600; $i++) {
    $line = $lines[$i]
    $leadingSpaces = 0
    if ($line -match "^(\s+)") {
        $leadingSpaces = $matches[1].Length
    }
    $hasTab = $line.Contains("`t")
    Write-Host ("Line {0:D5} [Indent:{1:D2}][Tab:{2}]: {3}" -f ($i+1), $leadingSpaces, $hasTab, $line)
}
