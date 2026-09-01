$rePath = "d:\SERVER_RO\LevitationRO\rathena\db\re\item_db_usable.yml"
$lines = Get-Content -Path $rePath
for ($i = 59295; $i -le 59325; $i++) {
    if ($i -lt $lines.Length) {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}

Write-Host "=== Checking pre-re item_db_usable.yml for Old Money Pocket / ID ==="
$prerePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_usable.yml"
$prereLines = Get-Content -Path $prerePath
for ($i = 0; $i -lt $prereLines.Length; $i++) {
    if ($prereLines[$i] -match "Old Money Pocket" -or $prereLines[$i] -match "22538") {
        Write-Host "Pre-re Line $($i+1): $($prereLines[$i])"
    }
}
