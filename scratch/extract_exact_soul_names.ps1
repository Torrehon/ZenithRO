$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

Write-Host "=== Extracting exact soul names from soul_quests_1.txt ==="
$lines1 = Get-Content -Path $soul1
for ($i = 0; $i -lt $lines1.Length; $i++) {
    if ($lines1[$i] -match "script\t.*Einherjar") {
        Write-Host "`nNPC: $($lines1[$i])"
        for ($j = $i; $j -le [Math]::Min($lines1.Length-1, $i+60); $j++) {
            if ($lines1[$j] -match "\.@soul_name\$\s*=\s*(.+);") {
                Write-Host "   -> $($matches[1])"
            }
        }
    }
}

Write-Host "`n=== Extracting exact soul names from soul_quests_expanded.txt ==="
$lines2 = Get-Content -Path $soulexp
for ($i = 0; $i -lt $lines2.Length; $i++) {
    if ($lines2[$i] -match "script\t.*Einherjar") {
        Write-Host "`nNPC: $($lines2[$i])"
        for ($j = $i; $j -le [Math]::Min($lines2.Length-1, $i+60); $j++) {
            if ($lines2[$j] -match "\.@soul_name\$\s*=\s*(.+);") {
                Write-Host "   -> $($matches[1])"
            }
        }
    }
}
