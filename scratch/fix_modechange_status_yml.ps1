$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$statusFile = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\status.yml"

$content = Get-Content -Path $statusFile -Raw
$updatedContent = $content -replace "  - Status: Modechange", "  - Status: MODECHANGE"

[System.IO.File]::WriteAllText($statusFile, $updatedContent, $utf8NoBom)
Write-Host "Updated db/pre-re/status.yml: Modechange -> MODECHANGE!"
