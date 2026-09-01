$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$lines = Get-Content -Path $soul1

for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "F_EinherjarWeaponMenu|F_ValkyrieReroll") {
        Write-Host "Line $($i+1): $($lines[$i])"
        for ($j = $i; $j -le $i+60; $j++) {
            if ($j -lt $lines.Length) {
                Write-Host "Line $($j+1): $($lines[$j])"
            }
        }
    }
}
