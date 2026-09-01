$extracted = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$bytes = [System.IO.File]::ReadAllBytes($extracted)
$text = [System.Text.Encoding]::GetEncoding(1252).GetString($bytes)

# Find where tbl = { starts and where it ends
$idx = $text.LastIndexOf("main()")
if ($idx -gt 0) {
    Write-Host "main() found at index $idx"
    $sub = $text.Substring([Math]::Max(0, $idx - 500), 500)
    Write-Host "Text before main():`n$sub"
}
