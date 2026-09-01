$prePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\item_db_etc.yml"

# First, revert the added block 13223-13227 from pre-re/item_db_etc.yml
$preText = [System.IO.File]::ReadAllText($prePath)
$marker = "  - Id: 13223"
if ($preText.Contains($marker)) {
    $idx = $preText.IndexOf($marker)
    $cleanPreText = $preText.Substring(0, $idx).TrimEnd() + "`n"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($prePath, $cleanPreText, $utf8NoBom)
    Write-Host "Reverted pre-re/item_db_etc.yml (removed added block 13223-13227)!"
}

# Search all ammo / sphere / grenade items in pre-re/item_db_etc.yml
$lines = Get-Content -Path $prePath
Write-Host "`n=== All Grenades / Spheres / Bullets existing natively in pre-re/item_db_etc.yml ==="
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "Sphere|Grenade|Bullet|Shell") {
        for ($j = [Math]::Max(0, $i-5); $j -le [Math]::Min($lines.Length-1, $i+5); $j++) {
            if ($lines[$j] -match "^\s*-\s*Id:\s*\d+") {
                Write-Host "Line $($j+1): $($lines[$j]) | $($lines[$j+1]) | $($lines[$j+2])"
            }
        }
    }
}
