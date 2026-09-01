$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# First, git checkout to restore clean original scripts
Set-Location -Path "d:\SERVER_RO\LevitationRO"
git checkout -- rathena/npc/custom/soul_quests_1.txt rathena/npc/custom/soul_quests_expanded.txt

$exactMap1 = @(
    @{ Name = "Knight Einherjar"; Sk1 = 1041; Sk2 = 1042; N1 = "Soul of the Blader"; N2 = "Soul of the Lancer" },
    @{ Name = "Crusader Einherjar"; Sk1 = 1053; Sk2 = 1054; N1 = "Soul of the Templar"; N2 = "Soul of the Guardian" },
    @{ Name = "Priest Einherjar"; Sk1 = 1049; Sk2 = 1050; N1 = "Soul of the Exorcist"; N2 = "Soul of the Saint" },
    @{ Name = "Monk Einherjar"; Sk1 = 1061; Sk2 = 1062; N1 = "Soul of the Pugilist"; N2 = "Soul of the Enlightened" },
    @{ Name = "Wizard Einherjar"; Sk1 = 1043; Sk2 = 1044; N1 = "Soul of the Magus"; N2 = "Soul of the Hexer" },
    @{ Name = "Sage Einherjar"; Sk1 = 1057; Sk2 = 1058; N1 = "Soul of the Arcanist"; N2 = "Soul of the Loremaster" },
    @{ Name = "Hunter Einherjar"; Sk1 = 1045; Sk2 = 1046; N1 = "Soul of the Sharpshooter"; N2 = "Soul of the Trapper" },
    @{ Name = "Bard Einherjar"; Sk1 = 1059; Sk2 = 1060; N1 = "Soul of the Resonant"; N2 = "Soul of the Dissonant" },
    @{ Name = "Dancer Einherjar"; Sk1 = 1059; Sk2 = 1060; N1 = "Soul of the Resonant"; N2 = "Soul of the Dissonant" },
    @{ Name = "Blacksmith Einherjar"; Sk1 = 1047; Sk2 = 1048; N1 = "Soul of the Juggernaut"; N2 = "Soul of the Forgemaster" },
    @{ Name = "Alchemist Einherjar"; Sk1 = 1063; Sk2 = 1064; N1 = "Soul of the Apothecary"; N2 = "Soul of the Biomancer" },
    @{ Name = "Assassin Einherjar"; Sk1 = 1051; Sk2 = 1052; N1 = "Soul of the Executioner"; N2 = "Soul of the Viper" },
    @{ Name = "Rogue Einherjar"; Sk1 = 1065; Sk2 = 1066; N1 = "Soul of the Nightblade"; N2 = "Soul of the Mimic" }
)

# Read clean soul_quests_1.txt
$lines1 = [System.IO.File]::ReadAllLines($soul1)
$out1 = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines1.Length; $i++) {
    $line = $lines1[$i]
    $out1.Add($line)

    foreach ($e in $exactMap1) {
        if ($line -match ("script\t" + [regex]::Escape($e.Name))) {
            # Find JobLevel check in this NPC
            for ($j = $i; $j -lt [Math]::Min($lines1.Length, $i+25); $j++) {
                if ($lines1[$j] -match "JobLevel < 25") {
                    for ($k = $j; $k -lt [Math]::Min($lines1.Length, $j+5); $k++) {
                        if ($lines1[$k] -match "^\s*\}\s*$") {
                            # Add lines from $i+1 to $k
                            for ($m = $i + 1; $m -le $k; $m++) {
                                $out1.Add($lines1[$m])
                            }
                            # Inject recovery block with EXACT names
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
                            $out1.Add($recBlock)
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

[System.IO.File]::WriteAllText($soul1, ($out1 -join "`n"), $utf8NoBom)
Write-Host "Injected exact soul recovery in soul_quests_1.txt!"

# Read clean soul_quests_expanded.txt
$lines2 = [System.IO.File]::ReadAllLines($soulexp)
$out2 = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines2.Length; $i++) {
    $line = $lines2[$i]
    $out2.Add($line)

    if ($line -match "script\tChunin Einherjar") {
        for ($j = $i; $j -lt [Math]::Min($lines2.Length, $i+25); $j++) {
            if ($lines2[$j] -match "JobLevel < 25") {
                for ($k = $j; $k -lt [Math]::Min($lines2.Length, $j+5); $k++) {
                    if ($lines2[$k] -match "^\s*\}\s*$") {
                        for ($m = $i + 1; $m -le $k; $m++) { $out2.Add($lines2[$m]) }
                        $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill(1055, 1056)) {
		mes "[Chunin Einherjar]";
		mes "Greetings, shadow brother. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. I shall restore your Hero Soul at no cost!";
		next;
		skill 1055, 1, 0;
		skill 1056, 1, 0;
		mes "[Chunin Einherjar]";
		mes "Your Chunin Hero Souls have been restored!";
		close;
	}
"@
                        $out2.Add($recBlock)
                        $i = $k
                        break
                    }
                }
                break
            }
        }
    } elseif ($line -match "script\tGunslinger Einherjar") {
        for ($j = $i; $j -lt [Math]::Min($lines2.Length, $i+25); $j++) {
            if ($lines2[$j] -match "JobLevel < 25") {
                for ($k = $j; $k -lt [Math]::Min($lines2.Length, $j+5); $k++) {
                    if ($lines2[$k] -match "^\s*\}\s*$") {
                        for ($m = $i + 1; $m -le $k; $m++) { $out2.Add($lines2[$m]) }
                        $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill(1068, 1069)) {
		mes "[Gunslinger Einherjar]";
		mes "Greetings, master marksman. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. I shall restore your Hero Soul at no cost!";
		next;
		skill 1068, 1, 0;
		skill 1069, 1, 0;
		mes "[Gunslinger Einherjar]";
		mes "Your Gunslinger Hero Souls have been restored!";
		close;
	}
"@
                        $out2.Add($recBlock)
                        $i = $k
                        break
                    }
                }
                break
            }
        }
    }
}

[System.IO.File]::WriteAllText($soulexp, ($out2 -join "`n"), $utf8NoBom)
Write-Host "Injected exact soul recovery in soul_quests_expanded.txt!"
