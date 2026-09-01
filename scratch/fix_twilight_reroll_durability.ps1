$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$upgradeFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\einherjar_weapon_upgrades.txt"

$content = [System.IO.File]::ReadAllText($upgradeFile)

# Replace F_ValkyrieReroll function block
$oldValkReroll = @"
function	script	F_ValkyrieReroll	{
	.@wep_id = getequipid(EQI_HAND_R);
	.@eq_slot = EQI_HAND_R;

	if (!callfunc("F_IsTwilightWeapon", .@wep_id)) {
		.@wep_id = getequipid(EQI_HAND_L);
		.@eq_slot = EQI_HAND_L;
	}

	if (!callfunc("F_IsTwilightWeapon", .@wep_id)) {
		mes "[Valkyrie Kara]";
		mes "Mortal hero, you must equip your ^0000FFTwilight Weapon^000000!";
		mes "I must analyze its Star Fragment directly to tune its cosmic alignment.";
		close;
	}

	// Fetch inventory index of the equipped weapon
	getinventorylist;
	.@real_inv_idx = -1;
	for (.@i = 0; .@i < @inventorylist_count; ++.@i) {
		if (@inventorylist_id[.@i] == .@wep_id && @inventorylist_equip[.@i] > 0) {
			.@real_inv_idx = @inventorylist_idx[.@i];
			break;
		}
	}

	if (.@real_inv_idx < 0) {
		mes "[Valkyrie Kara]";
		mes "Could not locate your equipped weapon in inventory!";
		close;
	}

	// Fetch exact gem recipe for the equipped Twilight Weapon
	.@g1 = 0; .@c1 = 0; .@g2 = 0; .@c2 = 0; .@g3 = 0; .@c3 = 0;
	switch(.@wep_id) {
		case 40012: // Twilight Kukri
		case 40021: // Twilight Jamadhar
			.@g1 = 723; .@c1 = 1; .@g2 = 719; .@c2 = 1; .@g3 = 726; .@c3 = 1; break; // 1 Ruby, 1 Amethyst, 1 Sapphire

		case 40013: // Twilight Edge
			.@g1 = 726; .@c1 = 1; .@g2 = 723; .@c1 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Sapphire, 1 Ruby, 1 Topaz

		case 40014: // Twilight Long Bow
			.@g1 = 727; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Opal, 1 Amethyst

		case 40015: // Twilight Flail
			.@g1 = 723; .@c1 = 1; .@g2 = 722; .@c2 = 2; break; // 1 Ruby, 2 Pearl

		case 40016: // Twilight Staff
			.@g1 = 726; .@c1 = 2; .@g2 = 720; .@c2 = 1; break; // 2 Sapphire, 1 Aquamarine

		case 40017: // Twilight Cleaver
			.@g1 = 723; .@c1 = 2; .@g2 = 728; .@c2 = 1; break; // 2 Ruby, 1 Topaz

		case 40018: // Twilight Slayer
			.@g1 = 723; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Ruby, 1 Amethyst

		case 40019: // Twilight Lance
			.@g1 = 723; .@c1 = 2; .@g2 = 721; .@c2 = 1; break; // 2 Ruby, 1 Emerald

		case 40020: // Twilight Pike
			.@g1 = 723; .@c1 = 1; .@g2 = 721; .@c2 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Ruby, 1 Emerald, 1 Topaz

		case 40022: // Twilight Codex
			.@g1 = 726; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Sapphire, 1 Amethyst

		case 40023: // Twilight Claws
			.@g1 = 719; .@c1 = 2; .@g2 = 727; .@c2 = 1; break; // 2 Amethyst, 1 Opal

		case 40024: // Twilight Violin
		case 40025: // Twilight Whip
			.@g1 = 723; .@c1 = 1; .@g2 = 726; .@c1 = 1; .@g3 = 722; .@c3 = 1; break; // 1 Ruby, 1 Sapphire, 1 Pearl

		case 40026: // Twilight Bracers
			.@g1 = 723; .@c1 = 1; .@g2 = 721; .@c2 = 1; .@g3 = 719; .@c3 = 1; break; // 1 Ruby, 1 Emerald, 1 Amethyst

		case 40027: // Twilight Huuma
			.@g1 = 723; .@c1 = 2; .@g2 = 727; .@c2 = 1; break; // 2 Ruby, 1 Opal

		case 40028: // Guns
		case 40029:
		case 40030:
		case 40031:
		case 40032:
			.@g1 = 727; .@c1 = 1; .@g2 = 719; .@c2 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Opal, 1 Amethyst, 1 Topaz
	}

	mes "[Valkyrie Kara]";
	mes "Mortal hero... I see you carry " + mesitemlink(.@wep_id) + ".";
	mes "As a Valkyrie of Valhalla, I can commune with the cosmic constellations to re-align the living Star Fragment within your weapon.";
	next;
	mes "[Valkyrie Kara]";
	mes "For this celestial alignment, the stars demand ^0000FF100,000 Zeny^000000 and its elemental birthstones:";
	if (.@g1 > 0) mes "- " + .@c1 + "x " + mesitemlink(.@g1);
	if (.@g2 > 0) mes "- " + .@c2 + "x " + mesitemlink(.@g2);
	if (.@g3 > 0) mes "- " + .@c3 + "x " + mesitemlink(.@g3);
	mes "^888888(Tip: Click any item link above to inspect details!)^000000";
	next;

	if (select("Perform Celestial Alignment:Cancel") == 2) {
		mes "[Valkyrie Kara]";
		mes "May the light of Valhalla watch over your path.";
		close;
	}

	// Atomic Verification
	if (Zeny < 100000) {
		mes "[Valkyrie Kara]";
		mes "You do not possess 100,000 Zeny for the alignment ritual!";
		close;
	}
	if ((.@g1 > 0 && countitem(.@g1) < .@c1) || (.@g2 > 0 && countitem(.@g2) < .@c2) || (.@g3 > 0 && countitem(.@g3) < .@c3)) {
		mes "[Valkyrie Kara]";
		mes "You do not carry the required birthstones for this weapon!";
		close;
	}

	if (getequipid(.@eq_slot) != .@wep_id) {
		mes "[Valkyrie Kara]";
		mes "The alignment was interrupted! Your weapon is no longer equipped.";
		close;
	}

	// Deduct Costs
	Zeny -= 100000;
	if (.@g1 > 0) delitem .@g1, .@c1;
	if (.@g2 > 0) delitem .@g2, .@c2;
	if (.@g3 > 0) delitem .@g3, .@c3;

	// Unequip weapon temporarily to modify options on inventory index
	unequip .@eq_slot;

	// Generate and apply 3 high-tier random options tailored to weapon type
	callfunc("F_ApplyTwilightRandomOptions", .@wep_id, .@real_inv_idx);

	// Re-equip the weapon with new options applied
	equip .@wep_id;

	specialeffect2 EF_REPAIRWEAPON;

	mes "[Valkyrie Kara]";
	mes "The Star Fragment blazes with cosmic light!";
	mes "Your " + mesitemlink(.@wep_id) + " has been re-aligned with new Random Options!";
	close;
}
"@

$newValkReroll = @"
function	script	F_ValkyrieReroll	{
	.@wep_id = getequipid(EQI_HAND_R);
	.@eq_slot = EQI_HAND_R;

	if (!callfunc("F_IsTwilightWeapon", .@wep_id)) {
		.@wep_id = getequipid(EQI_HAND_L);
		.@eq_slot = EQI_HAND_L;
	}

	if (!callfunc("F_IsTwilightWeapon", .@wep_id)) {
		mes "[Valkyrie Kara]";
		mes "Mortal hero, you must equip your ^0000FFTwilight Weapon^000000!";
		mes "I must analyze its Star Fragment directly to tune its cosmic alignment.";
		close;
	}

	// Fetch exact gem recipe for the equipped Twilight Weapon
	.@g1 = 0; .@c1 = 0; .@g2 = 0; .@c2 = 0; .@g3 = 0; .@c3 = 0;
	switch(.@wep_id) {
		case 40012: // Twilight Kukri
		case 40021: // Twilight Jamadhar
			.@g1 = 723; .@c1 = 1; .@g2 = 719; .@c2 = 1; .@g3 = 726; .@c3 = 1; break; // 1 Ruby, 1 Amethyst, 1 Sapphire

		case 40013: // Twilight Edge
			.@g1 = 726; .@c1 = 1; .@g2 = 723; .@c1 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Sapphire, 1 Ruby, 1 Topaz

		case 40014: // Twilight Long Bow
			.@g1 = 727; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Opal, 1 Amethyst

		case 40015: // Twilight Flail
			.@g1 = 723; .@c1 = 1; .@g2 = 722; .@c2 = 2; break; // 1 Ruby, 2 Pearl

		case 40016: // Twilight Staff
			.@g1 = 726; .@c1 = 2; .@g2 = 720; .@c2 = 1; break; // 2 Sapphire, 1 Aquamarine

		case 40017: // Twilight Cleaver
			.@g1 = 723; .@c1 = 2; .@g2 = 728; .@c2 = 1; break; // 2 Ruby, 1 Topaz

		case 40018: // Twilight Slayer
			.@g1 = 723; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Ruby, 1 Amethyst

		case 40019: // Twilight Lance
			.@g1 = 723; .@c1 = 2; .@g2 = 721; .@c2 = 1; break; // 2 Ruby, 1 Emerald

		case 40020: // Twilight Pike
			.@g1 = 723; .@c1 = 1; .@g2 = 721; .@c2 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Ruby, 1 Emerald, 1 Topaz

		case 40022: // Twilight Codex
			.@g1 = 726; .@c1 = 2; .@g2 = 719; .@c2 = 1; break; // 2 Sapphire, 1 Amethyst

		case 40023: // Twilight Claws
			.@g1 = 719; .@c1 = 2; .@g2 = 727; .@c2 = 1; break; // 2 Amethyst, 1 Opal

		case 40024: // Twilight Violin
		case 40025: // Twilight Whip
			.@g1 = 723; .@c1 = 1; .@g2 = 726; .@c1 = 1; .@g3 = 722; .@c3 = 1; break; // 1 Ruby, 1 Sapphire, 1 Pearl

		case 40026: // Twilight Bracers
			.@g1 = 723; .@c1 = 1; .@g2 = 721; .@c2 = 1; .@g3 = 719; .@c3 = 1; break; // 1 Ruby, 1 Emerald, 1 Amethyst

		case 40027: // Twilight Huuma
			.@g1 = 723; .@c1 = 2; .@g2 = 727; .@c2 = 1; break; // 2 Ruby, 1 Opal

		case 40028: // Guns
		case 40029:
		case 40030:
		case 40031:
		case 40032:
			.@g1 = 727; .@c1 = 1; .@g2 = 719; .@c2 = 1; .@g3 = 728; .@c3 = 1; break; // 1 Opal, 1 Amethyst, 1 Topaz
	}

	mes "[Valkyrie Kara]";
	mes "Mortal hero... I see you carry " + mesitemlink(.@wep_id) + ".";
	mes "As a Valkyrie of Valhalla, I can commune with the cosmic constellations to re-align the living Star Fragment within your weapon.";
	next;
	mes "[Valkyrie Kara]";
	mes "For this celestial alignment, the stars demand ^0000FF100,000 Zeny^000000 and its elemental birthstones:";
	if (.@g1 > 0) mes "- " + .@c1 + "x " + mesitemlink(.@g1);
	if (.@g2 > 0) mes "- " + .@c2 + "x " + mesitemlink(.@g2);
	if (.@g3 > 0) mes "- " + .@c3 + "x " + mesitemlink(.@g3);
	mes "^888888(Tip: Click any item link above to inspect details!)^000000";
	next;

	if (select("Perform Celestial Alignment:Cancel") == 2) {
		mes "[Valkyrie Kara]";
		mes "May the light of Valhalla watch over your path.";
		close;
	}

	// Atomic Verification
	if (Zeny < 100000) {
		mes "[Valkyrie Kara]";
		mes "You do not possess 100,000 Zeny for the alignment ritual!";
		close;
	}
	if ((.@g1 > 0 && countitem(.@g1) < .@c1) || (.@g2 > 0 && countitem(.@g2) < .@c2) || (.@g3 > 0 && countitem(.@g3) < .@c3)) {
		mes "[Valkyrie Kara]";
		mes "You do not carry the required birthstones for this weapon!";
		close;
	}

	if (getequipid(.@eq_slot) != .@wep_id) {
		mes "[Valkyrie Kara]";
		mes "The alignment was interrupted! Your weapon is no longer equipped.";
		close;
	}

	// Deduct Costs
	Zeny -= 100000;
	if (.@g1 > 0) delitem .@g1, .@c1;
	if (.@g2 > 0) delitem .@g2, .@c2;
	if (.@g3 > 0) delitem .@g3, .@c3;

	// 1. Unequip weapon FIRST
	unequip .@eq_slot;

	// 2. Fetch inventory index AFTER unequipped
	getinventorylist;
	.@real_inv_idx = -1;
	for (.@i = 0; .@i < @inventorylist_count; ++.@i) {
		if (@inventorylist_id[.@i] == .@wep_id && @inventorylist_equip[.@i] == 0) {
			.@real_inv_idx = @inventorylist_idx[.@i];
			break;
		}
	}

	if (.@real_inv_idx < 0) {
		mes "[Valkyrie Kara]";
		mes "Could not locate your unequipped weapon in inventory!";
		close;
	}

	// 3. Generate and apply Durability (Slot 0) + 2-3 High-Tier Random Options
	callfunc("F_ApplyTwilightRandomOptions", .@wep_id, .@real_inv_idx);

	// 4. Re-equip the weapon with new options applied
	equip .@wep_id;

	specialeffect2 EF_REPAIRWEAPON;

	mes "[Valkyrie Kara]";
	mes "The Star Fragment blazes with cosmic light!";
	mes "Your " + mesitemlink(.@wep_id) + " has been re-aligned with new Random Options & Durability!";
	close;
}
"@

if ($content.Contains($oldValkReroll.Replace("`r`n", "`n"))) {
    $content = $content.Replace($oldValkReroll.Replace("`r`n", "`n"), $newValkReroll.Replace("`r`n", "`n"))
} else {
    $content = $content.Replace($oldValkReroll, $newValkReroll)
}

# Replace F_ApplyTwilightRandomOptions function block
$oldApplyFunc = @"
function	script	F_ApplyTwilightRandomOptions	{
	.@wep_id = getarg(0);
	.@inv_idx = getarg(1);

	// 1. Resolve Group ID based on Weapon Subtype (matching pc_resolve_random_group)
	.@group_id = 8; // Default: Physical Weapon (Group 8)
	if (.@wep_id == 40016) { // Twilight Staff (2H Staff)
		.@group_id = 9; // Magic (Group 9)
	} else if (.@wep_id == 40012 || .@wep_id == 40013 || .@wep_id == 40022 || .@wep_id == 40024 || .@wep_id == 40025) {
		// Twilight Kukri (Dagger), Edge (1H Sword), Codex (Book), Violin (Instrument), Whip (Whip)
		.@group_id = 10; // Mixed (Group 10)
	}

	// 2. Determine number of slots to apply (1 to 3 slots)
	.@slots_to_apply = 1;
	if (rand(100) < 40) {
		.@slots_to_apply = 2;
		if (rand(100) < 15) {
			.@slots_to_apply = 3;
		}
	}

	// 3. Build Pool array based on group_id matching server's C++ pools
	deletearray .@pool[0], getarraysize(.@pool);
	.@pool_size = 0;

	if (.@group_id == 9) { // MÁGICAS (Group 9)
		setarray .@s[0], 19, 151, 152, 155, 156, 168, 170, 171, 172;
		for (.@i = 0; .@i < 9; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 57; .@i <= 75; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 187; .@i <= 189; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	} else if (.@group_id == 10) { // MIXTAS (Group 10)
		setarray .@s[0], 16, 17, 18, 19, 24, 147, 148, 151, 152, 153, 154, 155, 156, 164, 168, 170, 171, 172;
		for (.@i = 0; .@i < 18; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 37; .@i <= 55; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 57; .@i <= 75; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 97; .@i <= 106; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 157; .@i <= 159; ++.@i) { .@pool[.@pool_size] = .@size_phys; .@pool_size++; }
		for (.@i = 187; .@i <= 189; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	} else { // FÍSICAS (Group 8)
		setarray .@s[0], 16, 17, 18, 24, 147, 148, 153, 154, 164, 171, 172;
		for (.@i = 0; .@i < 11; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 37; .@i <= 55; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 97; .@i <= 106; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 157; .@i <= 159; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	}

	// 4. Reset all 5 option slots first
	for (.@o = 0; .@o < 5; ++.@o) {
		setitemoption .@inv_idx, .@o, 0, 0;
	}

	// 5. Select options and apply value caps (wlv = 4 for all Twilight weapons)
	.@applied = 0;
	.@has_phys_ele = 0; .@has_mag_ele = 0; .@has_race_dmg = 0;
	.@has_size_phys = 0; .@has_size_mag = 0;

	while (.@applied < .@slots_to_apply && .@pool_size > 0) {
		.@target_idx = rand(.@pool_size);
		.@id_opt = .@pool[.@target_idx];

		// Remove element from pool
		.@pool[.@target_idx] = .@pool[.@pool_size - 1];
		.@pool_size--;

		// Conflict checks (semáforos) matching server's C++ code
		.@conflict = 0;
		if (.@id_opt >= 37 && .@id_opt <= 55) {
			if (.@has_phys_ele) .@conflict = 1; else .@has_phys_ele = 1;
		} else if (.@id_opt >= 57 && .@id_opt <= 75) {
			if (.@has_mag_ele) .@conflict = 1; else .@has_mag_ele = 1;
		} else if (.@id_opt >= 97 && .@id_opt <= 106) {
			if (.@has_race_dmg) .@conflict = 1; else .@has_race_dmg = 1;
		} else if (.@id_opt >= 157 && .@id_opt <= 159) {
			if (.@has_size_phys) .@conflict = 1; else .@has_size_phys = 1;
		} else if (.@id_opt >= 187 && .@id_opt <= 189) {
			if (.@has_size_mag) .@conflict = 1; else .@has_size_mag = 1;
		}

		if (.@conflict) continue;

		// Calculate value based on wlv = 4 formulas matching server's C++ code
		.@val = 1;
		switch(.@id_opt) {
			case 17: .@val = rand(1, 25); break; // ATK (cap 25 for wlv 4)
			case 19: .@val = rand(1, 35); break; // MATK (cap 35 for wlv 4)
			case 18: .@val = rand(1, 15); break; // HIT (cap 15)
			case 16: case 24: case 170: case 171: .@val = rand(1, 10); break; // ASPD %, CRIT (cap 10 for wlv 4)
			case 153: case 154: case 168: .@val = rand(1, 20); break; // cap 20 for wlv 4
			case 155: case 156: .@val = rand(1, 15); break;
			case 147: case 148: case 151: case 152: .@val = rand(1, 5); break;
			case 187: case 188: case 189: .@val = rand(1, 10); break;
			default:
				if ((.@id_opt >= 37 && .@id_opt <= 55) || (.@id_opt >= 57 && .@id_opt <= 75) || (.@id_opt >= 97 && .@id_opt <= 106) || (.@id_opt >= 157 && .@id_opt <= 159) || .@id_opt == 164 || .@id_opt == 172) {
					.@val = rand(1, 15); // cap 15 for wlv 4
				} else {
					.@val = rand(1, 10);
				}
				break;
		}

		setitemoption .@inv_idx, .@applied, .@id_opt, .@val;
		.@applied++;
	}

	return;
}
"@

$newApplyFunc = @"
function	script	F_ApplyTwilightRandomOptions	{
	.@wep_id = getarg(0);
	.@inv_idx = getarg(1);

	if (.@inv_idx < 0) return;

	// Reset all 5 option slots first
	for (.@o = 0; .@o < 5; ++.@o) {
		setitemoption .@inv_idx, .@o, 0, 0;
	}

	// Slot 0: DURABILITY / INDESTRUCTIBLE GUARANTEED (100% Guaranteed)
	if (rand(100) < 30) {
		setitemoption .@inv_idx, 0, 185, 1; // Indestructible Weapon (ID 185)
	} else {
		setitemoption .@inv_idx, 0, 243, rand(20, 50); // Durability +20% to +50% (ID 243)
	}

	// Resolve Group ID based on Weapon Subtype
	.@group_id = 8; // Default: Physical Weapon
	if (.@wep_id == 40016) { // Twilight Staff
		.@group_id = 9; // Magic
	} else if (.@wep_id == 40012 || .@wep_id == 40013 || .@wep_id == 40022 || .@wep_id == 40024 || .@wep_id == 40025) {
		.@group_id = 10; // Mixed
	}

	// Determine 2 to 3 additional random option slots (Slots 1, 2, 3)
	.@extra_slots = (rand(100) < 50) ? 3 : 2;

	deletearray .@pool[0], getarraysize(.@pool);
	.@pool_size = 0;

	if (.@group_id == 9) { // MAGICAL (Group 9)
		setarray .@s[0], 19, 151, 152, 155, 156, 168, 170, 171, 172;
		for (.@i = 0; .@i < 9; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 57; .@i <= 75; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 187; .@i <= 189; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	} else if (.@group_id == 10) { // MIXED (Group 10)
		setarray .@s[0], 16, 17, 18, 19, 24, 147, 148, 151, 152, 153, 154, 155, 156, 164, 168, 170, 171, 172;
		for (.@i = 0; .@i < 18; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 37; .@i <= 55; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 57; .@i <= 75; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 97; .@i <= 106; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 157; .@i <= 159; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 187; .@i <= 189; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	} else { // PHYSICAL (Group 8)
		setarray .@s[0], 16, 17, 18, 24, 147, 148, 153, 154, 164, 171, 172;
		for (.@i = 0; .@i < 11; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		for (.@i = 37; .@i <= 55; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 97; .@i <= 106; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		for (.@i = 157; .@i <= 159; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	}

	.@slot_idx = 1;
	while (.@slot_idx <= .@extra_slots && .@pool_size > 0) {
		.@target_idx = rand(.@pool_size);
		.@id_opt = .@pool[.@target_idx];

		// Remove element from pool
		.@pool[.@target_idx] = .@pool[.@pool_size - 1];
		.@pool_size--;

		.@val = 1;
		switch(.@id_opt) {
			case 17: .@val = rand(15, 30); break; // ATK
			case 19: .@val = rand(20, 40); break; // MATK
			case 18: .@val = rand(10, 25); break; // HIT
			case 16: case 24: case 170: case 171: .@val = rand(5, 12); break; // ASPD %, CRIT
			case 153: case 154: case 168: .@val = rand(10, 25); break;
			case 155: case 156: .@val = rand(10, 20); break;
			case 147: case 148: case 151: case 152: .@val = rand(3, 8); break;
			case 187: case 188: case 189: .@val = rand(5, 15); break;
			default:
				.@val = rand(5, 15);
				break;
		}

		setitemoption .@inv_idx, .@slot_idx, .@id_opt, .@val;
		.@slot_idx++;
	}

	return;
}
"@

if ($content.Contains($oldApplyFunc.Replace("`r`n", "`n"))) {
    $content = $content.Replace($oldApplyFunc.Replace("`r`n", "`n"), $newApplyFunc.Replace("`r`n", "`n"))
} else {
    $content = $content.Replace($oldApplyFunc, $newApplyFunc)
}

[System.IO.File]::WriteAllText($upgradeFile, $content, $utf8NoBom)
Write-Host "Updated einherjar_weapon_upgrades.txt successfully with Durability + Random Options fixes!"
