$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# Process soul_quests_1.txt
$lines1 = [System.IO.File]::ReadAllLines($soul1)
for ($i = 0; $i -lt $lines1.Length; $i++) {
    if ($lines1[$i] -match "skill 10\d\d, 1, 0;") {
        $lines1[$i] = $lines1[$i].Replace(", 1, 0;", ", 1, SKILL_PERM;")
    }
}
[System.IO.File]::WriteAllText($soul1, ($lines1 -join "`n"), $utf8NoBom)
Write-Host "Updated skill flags in soul_quests_1.txt to SKILL_PERM!"

# Process soul_quests_expanded.txt
$lines2 = [System.IO.File]::ReadAllLines($soulexp)
for ($i = 0; $i -lt $lines2.Length; $i++) {
    if ($lines2[$i] -match "skill 10\d\d, 1, 0;") {
        $lines2[$i] = $lines2[$i].Replace(", 1, 0;", ", 1, SKILL_PERM;")
    }
    if ($lines2[$i] -match "skill 1032, 1, 0;") {
        $lines2[$i] = $lines2[$i].Replace(", 1, 0;", ", 1, SKILL_PERM;")
    }
}
[System.IO.File]::WriteAllText($soulexp, ($lines2 -join "`n"), $utf8NoBom)
Write-Host "Updated skill flags in soul_quests_expanded.txt to SKILL_PERM!"
