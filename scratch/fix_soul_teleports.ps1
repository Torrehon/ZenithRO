$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"

$content = [System.IO.File]::ReadAllText($soul1)

# 1. Update Scholar NPC to offer teleport options
$oldScholar = @"
	if (SOUL_QUEST1_STEP >= 2) {
		mes "[Scholar]";
		mes "Do not delay, brave adventurer!";
		mes "Go to ^0000FFgef_fild07 (182, 240)^000000 with your Dawn Weapon equipped and listen for the call of the cosmos.";
		close;
	}
"@

$newScholar = @"
	if (SOUL_QUEST1_STEP >= 2 || checkquest(90003) >= 1 || checkquest(90004) >= 1 || checkquest(90005) >= 1) {
		mes "[Scholar]";
		mes "Greetings, adventurer! The celestial path to the ancestral sanctuaries is open to you.";
		mes "Would you like me to open a direct portal to one of the sanctuaries?";
		next;
		if (select("Teleport to Sanctuary:Leave") == 1) {
			switch(select("Pantheon of Heroes (2nd Jobs):Chunin Sanctuary (Ninja):Gunslinger Enclave (Gunslinger):Cancel")) {
				case 1:
					close2;
					warp "1@4tro",53,51;
					end;
				case 2:
					close2;
					warp "1@exse",43,23;
					end;
				case 3:
					close2;
					warp "1@exnw",111,103;
					end;
				default:
					close;
			}
		}
		close;
	}
"@

if ($content.Contains($oldScholar.Replace("`r`n", "`n"))) {
    $content = $content.Replace($oldScholar.Replace("`r`n", "`n"), $newScholar.Replace("`r`n", "`n"))
} else {
    $content = $content.Replace($oldScholar, $newScholar)
}

# 2. Update Geffen Field Portal check condition
$oldPortal = "if (SOUL_QUEST1_STEP >= 2 && F_HasDawnWeaponEquipped()) {"
$newPortal = "if (SOUL_QUEST1_STEP >= 2 || checkquest(90003) >= 1 || checkquest(90004) >= 1 || checkquest(90005) >= 1 || F_HasDawnWeaponEquipped()) {"

$content = $content.Replace($oldPortal, $newPortal)

[System.IO.File]::WriteAllText($soul1, $content, $utf8NoBom)
Write-Host "Updated soul_quests_1.txt teleports successfully!"
