$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$enc = [System.Text.Encoding]::GetEncoding(949)
$text = [System.IO.File]::ReadAllText($path, $enc)

Write-Host "Length:" $text.Length
$sampleIndex = $text.IndexOf("[502] =")
if ($sampleIndex -ge 0) {
    Write-Host "Sample [502]:"
    Write-Host $text.Substring($sampleIndex, 300)
} else {
    Write-Host "[502] not found"
}
