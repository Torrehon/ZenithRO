$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$importStatusFile = "d:\SERVER_RO\LevitationRO\rathena\db\import\status.yml"

$content = @"
# ###########################################################################
# Status Change Database Import
# ###########################################################################

Header:
  Type: STATUS_DB
  Version: 4
  Mode: Merge
"@

[System.IO.File]::WriteAllText($importStatusFile, $content, $utf8NoBom)
Write-Host "Updated db/import/status.yml with Mode: Merge!"
