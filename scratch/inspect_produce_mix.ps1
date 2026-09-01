$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\skill.cpp"
$lines = Get-Content -Path $path

Write-Host "=== Searching skill.cpp lines 13900 to 14170 ==="
for ($i = 13900; $i -le 14170; $i++) {
    if ($i -lt $lines.Length) {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
