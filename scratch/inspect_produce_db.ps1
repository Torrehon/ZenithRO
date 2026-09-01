$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\produce_db.txt"
$lines = Get-Content -Path $path

Write-Host "=== Searching produce_db.txt for Acid Bottle / Fire Bottle / Grenade Bottle ==="
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "7135" -or $lines[$i] -match "7136" -or $lines[$i] -match "Acid_Bottle" -or $lines[$i] -match "Fire_Bottle" -or $lines[$i] -match "Bottle_Grenade") {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
