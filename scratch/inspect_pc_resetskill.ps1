Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Inspecting pc_resetskill in pc.cpp ==="
Get-ChildItem -Path "." -Filter "pc.cpp" | ForEach-Object {
    $lines = Get-Content -Path $_.FullName
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "pc_resetskill") {
            Write-Host "Line $($i+1): $($lines[$i])"
            for ($j = $i; $j -le [Math]::Min($lines.Length-1, $i+40); $j++) {
                Write-Host "Line $($j+1): $($lines[$j])"
            }
            break
        }
    }
}
