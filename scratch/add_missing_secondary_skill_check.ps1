$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# Update Rogue Einherjar in soul_quests_1.txt
$content1 = [System.IO.File]::ReadAllText($soul1)
$target1 = "if (BaseJob != Job_Rogue) {"
$injection1 = @"
	if (getskilllv(1066) > 0 && getskilllv(1067) == 0) {
		skill 1067, 1, SKILL_PERM;
		specialeffect2 EF_ANGEL;
		mes "[Rogue Einherjar]";
		mes "Ah! You possess the ^0000FFSoul of the Mimic^000000! I have granted you your ^0000FFSupport Plagiarism^000000 skill!";
		close;
	}
	if (BaseJob != Job_Rogue) {
"@

if (-not $content1.Contains("getskilllv(1066) > 0 && getskilllv(1067) == 0")) {
    $content1 = $content1.Replace($target1, $injection1)
    [System.IO.File]::WriteAllText($soul1, $content1, $utf8NoBom)
    Write-Host "Injected auto-grant of 1067 in Rogue Einherjar!"
}

# Update Chunin Einherjar in soul_quests_expanded.txt
$content2 = [System.IO.File]::ReadAllText($soulexp)
$target2 = "if (JobLevel < 25) {"
$injection2 = @"
	if (getskilllv(1056) > 0 && getskilllv(1032) == 0) {
		skill 1032, 1, SKILL_PERM;
		specialeffect2 EF_ANGEL;
		mes "[Chunin Einherjar]";
		mes "Ah! You possess the ^0000FFSoul of the Kuji^000000! I have granted you your ^0000FFDual Wield^000000 skill!";
		close;
	}
	if (JobLevel < 25) {
"@

if (-not $content2.Contains("getskilllv(1056) > 0 && getskilllv(1032) == 0")) {
    $content2 = $content2.Replace($target2, $injection2)
    [System.IO.File]::WriteAllText($soulexp, $content2, $utf8NoBom)
    Write-Host "Injected auto-grant of 1032 in Chunin Einherjar!"
}
