$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$cp949 = [System.Text.Encoding]::GetEncoding(949)
$bytes = [System.IO.File]::ReadAllBytes($path)

$text = $cp949.GetString($bytes)
Write-Host "Sample text with CP949:"
Write-Host $text.Substring(0, 300)
