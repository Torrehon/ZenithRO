$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$prePath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\achievement_db.yml"

$lines = [System.IO.File]::ReadAllLines($prePath)
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "^\s*#\s*Rewards:\s*$" -and $i+1 -lt $lines.Length -and $lines[$i+1] -match "^\s*#\s*Item:\s*Shabby_Purse\s*$") {
        $lines[$i]   = "       Rewards:"
        $lines[$i+1] = "         Item: Shabby_Purse"
    }
}

$newText = $lines -join "`n"
[System.IO.File]::WriteAllText($prePath, $newText, $utf8NoBom)
Write-Host "Uncommented all 146 Shabby_Purse rewards in pre-re/achievement_db.yml!"
