$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$upgradeFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\einherjar_weapon_upgrades.txt"

$lines = [System.IO.File]::ReadAllLines($upgradeFile)

$startIdx = -1
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "function\s+script\s+F_ApplyTwilightRandomOptions") {
        $startIdx = $i - 4 # Include comment block above
        break
    }
}

if ($startIdx -ge 0) {
    $newFuncLines = @"
// --------------------------------------------------------------
// Helper Function: F_ApplyTwilightRandomOptions
// Replicates server's exact C++ pc_apply_random_option engine (pc.cpp) for Twilight Weapons
// Applies 1-3 custom random options + Durability (ID 243, value 100)
// --------------------------------------------------------------
function	script	F_ApplyTwilightRandomOptions	{
	.@wep_id  = getarg(0);
	.@inv_idx = getarg(1);

	if (.@inv_idx < 0) return;

	// Reset all 5 option slots first
	for (.@o = 0; .@o < 5; ++.@o) {
		setitemoption .@inv_idx, .@o, 0, 0;
	}

	// 1. Resolve Group ID matching pc_resolve_random_group in C++ (pc.cpp)
	.@group_id = 8; // Default: Physical Weapon (Group 8)
	if (.@wep_id == 40016) { // Twilight Staff (2H Staff)
		.@group_id = 9; // Magic (Group 9)
	} else if (.@wep_id == 40012 || .@wep_id == 40013 || .@wep_id == 40022 || .@wep_id == 40024 || .@wep_id == 40025) {
		// Twilight Kukri (Dagger), Edge (1H Sword), Codex (Book), Violin (Instrument), Whip (Whip)
		.@group_id = 10; // Mixed (Group 10)
	}

	// 2. Determine number of random option slots to apply (1 to 3 slots) matching C++ pc.cpp
	.@slots_to_apply = 1;
	if (rand(100) < 40) {
		.@slots_to_apply = 2;
		if (rand(100) < 15) {
			.@slots_to_apply = 3;
		}
	}

	// 3. Build Pool array matching exact C++ pools in pc.cpp
	deletearray .@pool[0], getarraysize(.@pool);
	.@pool_size = 0;

	if (.@group_id == 9) { // MAGICAL (Group 9)
		setarray .@s[0], 19, 151, 152, 155, 156, 168, 170, 171, 172;
		for (.@i = 0; .@i < 9; ++.@i) { .@pool[.@pool_size] = .@s[.@i]; .@pool_size++; }
		// Elemental Magic Dmg (57, 59, 61, 63, 65, 67, 69, 71, 73, 75)
		for (.@i = 57; .@i <= 75; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		// Magic Dmg vs Size (187, 188, 189)
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
		// Elemental Phys Dmg (37, 39, 41, 43, 45, 47, 49, 51, 53, 55)
		for (.@i = 37; .@i <= 55; .@i += 2) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		// Phys Dmg vs Race (97-106)
		for (.@i = 97; .@i <= 106; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
		// Phys Dmg vs Size (157-159)
		for (.@i = 157; .@i <= 159; ++.@i) { .@pool[.@pool_size] = .@i; .@pool_size++; }
	}

	// 4. Semaphores (Conflict Checks matching C++ pc.cpp)
	.@applied = 0;
	.@has_phys_ele = 0; .@has_mag_ele = 0; .@has_race_dmg = 0;
	.@has_size_phys = 0; .@has_size_mag = 0;

	while (.@applied < .@slots_to_apply && .@pool_size > 0) {
		.@target_idx = rand(.@pool_size);
		.@id_opt = .@pool[.@target_idx];

		// Remove element from pool
		.@pool[.@target_idx] = .@pool[.@pool_size - 1];
		.@pool_size--;

		// Conflict checks (semáforos)
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

		// Calculate exact values matching C++ pc.cpp formulas for Weapon Level 4
		.@val = 1;
		switch(.@id_opt) {
			case 17: .@val = rand(1, 25); break; // ATK (cap 25 for wlv 4)
			case 19: .@val = rand(1, 35); break; // MATK (cap 35 for wlv 4)
			case 18: .@val = rand(1, 15); break; // HIT (cap 15)
			case 16: case 24: case 170: case 171: .@val = rand(1, 10); break; // ASPD %, CRIT (cap 10 for wlv 4)
			case 153: case 154: .@val = rand(1, 20); break; // Long/Short Range Dmg % (cap 20 for wlv 4)
			case 155: case 156: .@val = rand(1, 15); break; // Cast time (cap 15)
			case 168: .@val = rand(1, 20); break; // Magic Dmg % (cap 20 for wlv 4)
			case 147: case 148: case 151: case 152: .@val = rand(1, 5); break; // Def/Mdef Ignore % (cap 5)
			case 187: case 188: case 189: .@val = rand(1, 10); break; // Magic Dmg vs Size (cap 10 for wlv 4)
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

	// 5. Appending Durability Option (ID 243, Value 100) matching pc_set_item_durability
	if (.@applied < 5) {
		setitemoption .@inv_idx, .@applied, 243, 100;
	}

	return;
}
"@ -split "`n"

    $resultLines = $lines[0..($startIdx-1)] + $newFuncLines
    [System.IO.File]::WriteAllText($upgradeFile, ($resultLines -join "`n"), $utf8NoBom)
    Write-Host "Replaced F_ApplyTwilightRandomOptions with exact C++ pools and Durability 243 (100)!"
} else {
    Write-Host "Could not find F_ApplyTwilightRandomOptions"
}
