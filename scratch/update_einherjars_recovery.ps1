$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# Process soul_quests_1.txt
$lines1 = Get-Content -Path $soul1
for ($i = 0; $i -lt $lines1.Length; $i++) {
    if ($lines1[$i] -match "^\s*if \(SOUL_QUEST1_STEP >= 5\) \{$") {
        $lines1[$i] = '	if (SOUL_QUEST1_STEP >= 5 && F_HasSoulSkill(' + $lines1[$i+13].Replace('if (F_HasSoulSkill(', '').Replace(') {', '')
    }
    if ($lines1[$i] -match "^\s*if \(countitem\(50020\) < 1\) \{$") {
        $lines1[$i] = '	if (SOUL_QUEST1_STEP < 4 && countitem(50020) < 1) {'
    }
    if ($lines1[$i] -match "^\s*delitem 50020, 1;$" -and $lines1[$i-1] -match "close;") {
        $lines1[$i] = '	if (SOUL_QUEST1_STEP < 4) delitem 50020, 1;'
    }
    if ($lines1[$i] -match "^\s*SOUL_QUEST1_STEP = 4;$" -and $lines1[$i-1] -match "if \(\.@sk2 > 0\)") {
        $lines1[$i] = '	if (SOUL_QUEST1_STEP < 4) SOUL_QUEST1_STEP = 4;'
    }
}

# Write back soul_quests_1.txt
$newText1 = $lines1 -join "`n"
[System.IO.File]::WriteAllText($soul1, $newText1, $utf8NoBom)
Write-Host "Updated soul_quests_1.txt for soul skill recovery!"

# Process soul_quests_expanded.txt
$lines2 = Get-Content -Path $soulexp
for ($i = 0; $i -lt $lines2.Length; $i++) {
    if ($lines2[$i] -match "^\s*if \(SOUL_QUEST1_STEP >= 5\) \{$") {
        $lines2[$i] = '	if (SOUL_QUEST1_STEP >= 5 && F_HasSoulSkill(' + $lines2[$i+14].Replace('if (F_HasSoulSkill(', '').Replace(') {', '')
    }
    if ($lines2[$i] -match "^\s*if \(countitem\(50020\) < 1\) \{$") {
        $lines2[$i] = '	if (SOUL_QUEST1_STEP < 4 && countitem(50020) < 1) {'
    }
    if ($lines2[$i] -match "^\s*delitem 50020, 1;$" -and $lines2[$i-1] -match "close;") {
        $lines2[$i] = '	if (SOUL_QUEST1_STEP < 4) delitem 50020, 1;'
    }
    if ($lines2[$i] -match "^\s*SOUL_QUEST1_STEP = 4;$" -and $lines2[$i-1] -match "if \(\.@sk2 > 0\)") {
        $lines2[$i] = '	if (SOUL_QUEST1_STEP < 4) SOUL_QUEST1_STEP = 4;'
    }
}

# Write back soul_quests_expanded.txt
$newText2 = $lines2 -join "`n"
[System.IO.File]::WriteAllText($soulexp, $newText2, $utf8NoBom)
Write-Host "Updated soul_quests_expanded.txt for soul skill recovery!"
