$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\quest_db.yml"
$text = [System.IO.File]::ReadAllText($path)
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $text, $utf8NoBom)

$bytes = [System.IO.File]::ReadAllBytes($path)
if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "BOM STILL PRESENT!"
} else {
    Write-Host "BOM stripped successfully! First byte is: 0x$($bytes[0].ToString('X2'))"
}
