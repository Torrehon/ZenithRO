$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$platFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\platinum_skills.txt"

$scriptText = @"
//===== rAthena Script =======================================
//= Platinum Skills NPC (1st Job & Special Platinum Skills)
//===== Description: =========================================
//= Grants 1st Job and Special Platinum/Quest skills to players.
//============================================================

prontera,128,200,6	script	Platinum Skill NPC	94,{
	mes "[Platinum Skill NPC]";
	mes "Greetings, adventurer!";
	mes "I can grant you all the ^0000FF1st Job & Special Platinum Quest Skills^000000 available for your class.";
	mes "Would you like to receive your platinum skills now?";
	next;
	if (select("Yes, please!:No thanks") == 2) {
		mes "[Platinum Skill NPC]";
		mes "Have a nice day!";
		close;
	}

	// Universal Skills for all classes
	skill "NV_FIRSTAID", 1, SKILL_PERM;
	skill 1013, 1, SKILL_PERM; // Pickup (1013)

	// Direct check by Class ID (Genin = 4501, Hiregun = 4502, Ninja = 25, Gunslinger = 24)
	if (Class == 4501 || BaseClass == 4501) {
		skill 3001, 1, SKILL_PERM; // Shadow Hiding (3001)
	}
	if (Class == 4502 || BaseClass == 4502) {
		skill 1028, 1, SKILL_PERM; // Ammo Crafting (1028)
	}

	switch (BaseClass) {
		case Job_Novice:
			if (Class != Job_Super_Novice)
				skill "NV_TRICKDEAD", 1, SKILL_PERM;
			break;
		case Job_Swordman:
			skill "SM_MOVINGRECOVERY", 1, SKILL_PERM;
			skill "SM_FATALBLOW", 1, SKILL_PERM;
			skill "SM_AUTOBERSERK", 1, SKILL_PERM;
			break;
		case Job_Mage:
			skill "MG_ENERGYCOAT", 1, SKILL_PERM;
			break;
		case Job_Archer:
			skill "AC_MAKINGARROW", 1, SKILL_PERM;
			skill "AC_CHARGEARROW", 1, SKILL_PERM;
			skill 1025, 1, SKILL_PERM; // Momentum (1025)
			break;
		case Job_Acolyte:
			skill "AL_HOLYLIGHT", 1, SKILL_PERM;
			skill 1026, 1, SKILL_PERM; // Zealot (1026)
			break;
		case Job_Merchant:
			skill "MC_CARTREVOLUTION", 1, SKILL_PERM;
			skill "MC_CHANGECART", 1, SKILL_PERM;
			skill "MC_LOUD", 1, SKILL_PERM;
			if (PACKETVER >= 20150826)
				skill "MC_CARTDECORATE", 1, SKILL_PERM;
			break;
		case Job_Thief:
			skill "TF_SPRINKLESAND", 1, SKILL_PERM;
			skill "TF_BACKSLIDING", 1, SKILL_PERM;
			skill "TF_PICKSTONE", 1, SKILL_PERM;
			skill "TF_THROWSTONE", 1, SKILL_PERM;
			break;
		case Job_Ninja:
		case 4501:
			skill 3001, 1, SKILL_PERM; // Shadow Hiding (3001)
			break;
		case Job_Gunslinger:
		case 4502:
			skill 1028, 1, SKILL_PERM; // Ammo Crafting (1028)
			break;
		case Job_Taekwon:
			skill 1029, 1, SKILL_PERM; // Shattering Kicks (1029)
			break;
		default:
			break;
	}

	specialeffect2 EF_ANGEL;
	mes "[Platinum Skill NPC]";
	mes "All ^0000FF1st Job & Special Platinum Skills^000000 for your class have been granted!";
	close;
}
"@

[System.IO.File]::WriteAllText($platFile, $scriptText, $utf8NoBom)
Write-Host "Updated platinum_skills.txt with direct Genin (4501) and Hiregun (4502) checks!"
