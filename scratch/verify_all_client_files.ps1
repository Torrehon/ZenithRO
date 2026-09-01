$files = @(
    "d:\SERVER_RO\LevitationRO\ZenithRO\data\questid2display.txt",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_C.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests.lub",
    "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\OngoingQuests_CLS.lub"
)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($path in $files) {
    $text = [System.IO.File]::ReadAllText($path)
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
    Write-Host "Verified and saved pure UTF-8 without BOM for $path"
}
