$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

$einherjarMap = @(
    @{ Name = "Knight Einherjar"; Sk1 = 1041; Sk2 = 1042; N1 = "Soul of the Blader"; N2 = "Soul of the Lancer" },
    @{ Name = "Crusader Einherjar"; Sk1 = 1053; Sk2 = 1054; N1 = "Soul of the Templar"; N2 = "Soul of the Paladin" },
    @{ Name = "Priest Einherjar"; Sk1 = 1049; Sk2 = 1050; N1 = "Soul of the High Priest"; N2 = "Soul of the Exorcist" },
    @{ Name = "Monk Einherjar"; Sk1 = 1061; Sk2 = 1062; N1 = "Soul of the Champion"; N2 = "Soul of the Asura" },
    @{ Name = "Wizard Einherjar"; Sk1 = 1043; Sk2 = 1044; N1 = "Soul of the Arch-Mage"; N2 = "Soul of the Elementalist" },
    @{ Name = "Sage Einherjar"; Sk1 = 1057; Sk2 = 1058; N1 = "Soul of the Scholar"; N2 = "Soul of the Sorcerer" },
    @{ Name = "Hunter Einherjar"; Sk1 = 1045; Sk2 = 1046; N1 = "Soul of the Sniper"; N2 = "Soul of the Trapper" },
    @{ Name = "Bard Einherjar"; Sk1 = 1059; Sk2 = 1060; N1 = "Soul of the Minstrel"; N2 = "Soul of the Troubadour" },
    @{ Name = "Dancer Einherjar"; Sk1 = 1059; Sk2 = 1060; N1 = "Soul of the Gypsy"; N2 = "Soul of the Muse" },
    @{ Name = "Blacksmith Einherjar"; Sk1 = 1047; Sk2 = 1048; N1 = "Soul of the Mastersmith"; N2 = "Soul of the Forger" },
    @{ Name = "Alchemist Einherjar"; Sk1 = 1063; Sk2 = 1064; N1 = "Soul of the Biochemist"; N2 = "Soul of the Creator" },
    @{ Name = "Assassin Einherjar"; Sk1 = 1051; Sk2 = 1052; N1 = "Soul of the Assassin Cross"; N2 = "Soul of the Shadow" },
    @{ Name = "Rogue Einherjar"; Sk1 = 1065; Sk2 = 1066; N1 = "Soul of the Stalker"; N2 = "Soul of the Chaser" }
)

$expMap = @(
    @{ Name = "Chunin Einherjar"; Sk1 = 1055; Sk2 = 1056; N1 = "Soul of the Kagerou"; N2 = "Soul of the Oboro" },
    @{ Name = "Gunslinger Einherjar"; Sk1 = 1068; Sk2 = 1069; N1 = "Soul of the Desperado"; N2 = "Soul of the Rebellion" }
)

# Process soul_quests_1.txt
$lines1 = [System.IO.File]::ReadAllLines($soul1)
$newLines1 = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines1.Length; $i++) {
    $line = $lines1[$i]
    $newLines1.Add($line)

    foreach ($e in $einherjarMap) {
        if ($line -match ("script\t" + [regex]::Escape($e.Name))) {
            # Find next JobLevel check line
            for ($j = $i; $j -lt [Math]::Min($lines1.Length, $i+25); $j++) {
                if ($lines1[$j] -match "JobLevel < 25") {
                    # Advance to end of JobLevel check block
                    for ($k = $j; $k -lt [Math]::Min($lines1.Length, $j+5); $k++) {
                        if ($lines1[$k] -match "^\s*\}\s*$") {
                            # Insert recovery block here
                            $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill($($e.Sk1), $($e.Sk2))) {
		mes "[$($e.Name)]";
		mes "Greetings, champion. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. Select your Hero Soul to restore it at no cost:";
		next;
		switch(select("$($e.N1):$($e.N2):Cancel")) {
			case 1:
				skill $($e.Sk1), 1, 0;
				mes "[$($e.Name)]";
				mes "Your ^0000FF$($e.N1)^000000 has been restored!";
				close;
			case 2:
				skill $($e.Sk2), 1, 0;
				mes "[$($e.Name)]";
				mes "Your ^0000FF$($e.N2)^000000 has been restored!";
				close;
			default:
				close;
		}
	}
"@
                            # Store lines to add after $k
                            for ($m = $i + 1; $m -le $k; $m++) {
                                $newLines1.Add($lines1[$m])
                            }
                            $newLines1.Add($recBlock)
                            $i = $k
                            break
                        }
                    }
                    break
                }
            }
            break
        }
    }
}

[System.IO.File]::WriteAllText($soul1, ($newLines1 -join "`n"), $utf8NoBom)
Write-Host "Updated soul_quests_1.txt with recovery options!"

# Process soul_quests_expanded.txt
$lines2 = [System.IO.File]::ReadAllLines($soulexp)
$newLines2 = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines2.Length; $i++) {
    $line = $lines2[$i]
    $newLines2.Add($line)

    foreach ($e in $expMap) {
        if ($line -match ("script\t" + [regex]::Escape($e.Name))) {
            for ($j = $i; $j -lt [Math]::Min($lines2.Length, $i+25); $j++) {
                if ($lines2[$j] -match "JobLevel < 25") {
                    for ($k = $j; $k -lt [Math]::Min($lines2.Length, $j+5); $k++) {
                        if ($lines2[$k] -match "^\s*\}\s*$") {
                            $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill($($e.Sk1), $($e.Sk2))) {
		mes "[$($e.Name)]";
		mes "Greetings, champion. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. Select your Hero Soul to restore it at no cost:";
		next;
		switch(select("$($e.N1):$($e.N2):Cancel")) {
			case 1:
				skill $($e.Sk1), 1, 0;
				mes "[$($e.Name)]";
				mes "Your ^0000FF$($e.N1)^000000 has been restored!";
				close;
			case 2:
				skill $($e.Sk2), 1, 0;
				mes "[$($e.Name)]";
				mes "Your ^0000FF$($e.N2)^000000 has been restored!";
				close;
			default:
				close;
		}
	}
"@
                            for ($m = $i + 1; $m -le $k; $m++) {
                                $newLines2.Add($lines2[$m])
                            }
                            $newLines2.Add($recBlock)
                            $i = $k
                            break
                        }
                    }
                    break
                }
            }
            break
        }
    }
}

[System.IO.File]::WriteAllText($soulexp, ($newLines2 -join "`n"), $utf8NoBom)
Write-Host "Updated soul_quests_expanded.txt with recovery options!"
