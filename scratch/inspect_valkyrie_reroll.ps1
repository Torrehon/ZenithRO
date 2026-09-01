$path = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\einherjar_weapon_upgrades.txt"
$lines = Get-Content -Path $path

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "F_ValkyrieReroll") {
        Write-Host "=== Found F_ValkyrieReroll at line $($i+1) ==="
        for ($j = $i; $j -le [Math]::Min($lines.Length-1, $i+80); $j++) {
            Write-Host "Line $($j+1): $($lines[$j])"
        }
    }
}
