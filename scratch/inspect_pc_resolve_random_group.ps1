$pcCpp = "d:\SERVER_RO\LevitationRO\rathena\src\map\pc.cpp"
$lines = Get-Content -Path $pcCpp

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "pc_resolve_random_group") {
        Write-Host "=== Found pc_resolve_random_group at line $($i+1) ==="
        for ($j = $i-5; $j -le $i+50; $j++) {
            if ($j -ge 0 -and $j -lt $lines.Length) {
                Write-Host "Line $($j+1): $($lines[$j])"
            }
        }
        break
    }
}
