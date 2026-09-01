$files = @(
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt",
    "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"
)

foreach ($f in $files) {
    Write-Host "=== Inspecting $f ==="
    $lines = Get-Content -Path $f
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "script\t.*Einherjar") {
            Write-Host "Line $($i+1): $($lines[$i])"
            for ($j = $i; $j -le [Math]::Min($lines.Length-1, $i+35); $j++) {
                if ($lines[$j] -match "F_HasSoulSkill|SOUL_QUEST1_STEP|countitem") {
                    Write-Host "   Line $($j+1): $($lines[$j])"
                }
            }
        }
    }
}
