$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# Process soul_quests_1.txt
$lines1 = [System.IO.File]::ReadAllLines($soul1)
for ($i = 0; $i -lt $lines1.Length; $i++) {
    if ($lines1[$i] -match "if \(SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill\(") {
        $lines1[$i] = $lines1[$i].Replace("SOUL_QUEST1_STEP >= 4", "(SOUL_QUEST1_STEP >= 4 || checkquest(90004) >= 1 || checkquest(90005) >= 1)")
    }
}
[System.IO.File]::WriteAllText($soul1, ($lines1 -join "`n"), $utf8NoBom)
Write-Host "Updated recovery conditions in soul_quests_1.txt!"

# Process soul_quests_expanded.txt
$lines2 = [System.IO.File]::ReadAllLines($soulexp)
for ($i = 0; $i -lt $lines2.Length; $i++) {
    if ($lines2[$i] -match "if \(SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill\(") {
        $lines2[$i] = $lines2[$i].Replace("SOUL_QUEST1_STEP >= 4", "(SOUL_QUEST1_STEP >= 4 || checkquest(90004) >= 1 || checkquest(90005) >= 1)")
    }
}
[System.IO.File]::WriteAllText($soulexp, ($lines2 -join "`n"), $utf8NoBom)
Write-Host "Updated recovery conditions in soul_quests_expanded.txt!"
