$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\skill.cpp"
$lines = Get-Content -Path $path

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "is_custom_whitelist_skill") {
        Write-Host "Line $($i+1): $($lines[$i])"
        for ($j = $i-5; $j -le $i+35; $j++) {
            if ($j -ge 0 -and $j -lt $lines.Length) {
                Write-Host "Line $($j+1): $($lines[$j])"
            }
        }
        break
    }
}
