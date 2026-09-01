$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\skill.cpp"
$lines = Get-Content -Path $path

Write-Host "=== Searching skill.cpp lines 14170 to 14460 ==="
for ($i = 14170; $i -le 14460; $i++) {
    if ($i -lt $lines.Length) {
        Write-Host "Line $($i+1): $($lines[$i])"
    }
}
