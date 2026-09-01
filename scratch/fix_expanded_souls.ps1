$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

# First git checkout soul_quests_expanded.txt
Set-Location -Path "d:\SERVER_RO\LevitationRO"
git checkout -- rathena/npc/custom/soul_quests_expanded.txt

$lines = [System.IO.File]::ReadAllLines($soulexp)
$out = [System.Collections.Generic.List[string]]::new()

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $out.Add($line)

    if ($line -match "script\tChunin Einherjar") {
        for ($j = $i; $j -lt [Math]::Min($lines.Length, $i+25); $j++) {
            if ($lines[$j] -match "JobLevel < 25") {
                for ($k = $j; $k -lt [Math]::Min($lines.Length, $j+5); $k++) {
                    if ($lines[$k] -match "^\s*\}\s*$") {
                        for ($m = $i + 1; $m -le $k; $m++) { $out.Add($lines[$m]) }
                        $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill(1055, 1056)) {
		mes "[Chunin Einherjar]";
		mes "Greetings, shadow brother. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. Select your Hero Soul to restore it at no cost:";
		next;
		switch(select("Soul of the Kensei:Soul of the Kuji:Cancel")) {
			case 1:
				skill 1055, 1, 0;
				mes "[Chunin Einherjar]";
				mes "Your ^0000FFSoul of the Kensei^000000 has been restored!";
				close;
			case 2:
				skill 1056, 1, 0;
				skill 1032, 1, 0;
				mes "[Chunin Einherjar]";
				mes "Your ^0000FFSoul of the Kuji^000000 and ^0000FFDual Wield^000000 have been restored!";
				close;
			default:
				close;
		}
	}
"@
                        $out.Add($recBlock)
                        $i = $k
                        break
                    }
                }
                break
            }
        }
    } elseif ($line -match "script\tGunslinger Einherjar") {
        for ($j = $i; $j -lt [Math]::Min($lines.Length, $i+25); $j++) {
            if ($lines[$j] -match "JobLevel < 25") {
                for ($k = $j; $k -lt [Math]::Min($lines.Length, $j+5); $k++) {
                    if ($lines[$k] -match "^\s*\}\s*$") {
                        for ($m = $i + 1; $m -le $k; $m++) { $out.Add($lines[$m]) }
                        $recBlock = @"
	if (SOUL_QUEST1_STEP >= 4 && !F_HasSoulSkill(1068, 1069)) {
		mes "[Gunslinger Einherjar]";
		mes "Greetings, master marksman. I sense that the dark void attempted to sever your link with our ancestral Hero Soul...";
		mes "Fear not! Your heroic deeds remain recorded in Valhalla. Select your Hero Soul to restore it at no cost:";
		next;
		switch(select("Soul of the Peacekeeper:Soul of the Enforcer:Cancel")) {
			case 1:
				skill 1068, 1, 0;
				mes "[Gunslinger Einherjar]";
				mes "Your ^0000FFSoul of the Peacekeeper^000000 has been restored!";
				close;
			case 2:
				skill 1069, 1, 0;
				mes "[Gunslinger Einherjar]";
				mes "Your ^0000FFSoul of the Enforcer^000000 has been restored!";
				close;
			default:
				close;
		}
	}
"@
                        $out.Add($recBlock)
                        $i = $k
                        break
                    }
                }
                break
            }
        }
    }
}

[System.IO.File]::WriteAllText($soulexp, ($out -join "`n"), $utf8NoBom)
Write-Host "Updated Chunin and Gunslinger recovery with exact 2 options each!"
