$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\questinfo_f.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\luafiles514\lua files\datainfo\questinfo_f.lub"
)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($path in $files) {
    $text = [System.IO.File]::ReadAllText($path)
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
    Write-Host "Saved pure UTF-8 without BOM for $path"
}
