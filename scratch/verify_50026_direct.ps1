$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$bytes = [System.IO.File]::ReadAllBytes($path)
$text = [System.Text.Encoding]::GetEncoding(1252).GetString($bytes)

$idx = $text.IndexOf("[50026]")
if ($idx -gt 0) {
    Write-Host "Found [50026] in itemInfo.lua at index $idx!"
    $sub = $text.Substring($idx - 100, 600)
    Write-Host "Snippet around 50026:`n$sub"
}
