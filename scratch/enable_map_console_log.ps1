$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$mapImportFile = "d:\SERVER_RO\LevitationRO\rathena\conf\import\map_conf.txt"

$content = Get-Content -Path $mapImportFile
$hasLog = $false
foreach ($line in $content) {
    if ($line -match "console_msg_log") {
        $hasLog = $true
    }
}

if (-not $hasLog) {
    $newContent = $content + @("", "// Guardar todo el log del map-server en log/map-msg.log", "console_msg_log: 31")
    [System.IO.File]::WriteAllLines($mapImportFile, $newContent, $utf8NoBom)
    Write-Host "Added console_msg_log: 31 to conf/import/map_conf.txt!"
}
