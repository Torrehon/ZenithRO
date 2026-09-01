$files = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re" -Filter "*.yml" -Recurse

$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Write-Host "BOM found in $($f.Name), stripping..."
        $text = [System.IO.File]::ReadAllText($f.FullName)
        [System.IO.File]::WriteAllText($f.FullName, $text, $utf8NoBom)
    }
}
Write-Host "Done checking all YAML files in pre-re."
