$path = "d:\SERVER_RO\LevitationRO\rathena\src\map\mob.cpp"
$lines = Get-Content -Path $path

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "IT_CARD") {
        Write-Host "=== Found IT_CARD at line $($i+1) in mob.cpp ==="
        for ($j = $i-5; $j -le $i+30; $j++) {
            if ($j -ge 0 -and $j -lt $lines.Length) {
                Write-Host "Line $($j+1): $($lines[$j])"
            }
        }
    }
}
