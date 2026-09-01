$infoLua = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$text = [System.IO.File]::ReadAllText($infoLua)

if ($text -match "(?ms)\[50003\]\s*=\s*\{.*?\n\t\},") {
    Write-Host "Item 50003 match:`n$($matches[0])"
}
