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
// Replicates server's exact C++ pc_apply_random_option engine for Twilight Weapons
// Guarantees Durability / Indestructibility (Slot 0) + 2-3 High-Tier Stats (Slots 1, 2, 3)
// --------------------------------------------------------------
function	script	F_ApplyTwilightRandomOptions	{
	.@wep_id  = getarg(0);
	.@inv_idx = getarg(1);

	if (.@inv_idx < 0) return;

	// Reset all 5 option slots first
	for (.@o = 0; .@o < 5; ++.@o) {
		setitemoption .@inv_idx, .@o, 0, 0;
	}

	// Slot 0: DURABILITY / INDESTRUCTIBLE GUARANTEED (100% Guaranteed on every Twilight weapon)
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
"@ -split "`n"

    $resultLines = $lines[0..($startIdx-1)] + $newFuncLines
    [System.IO.File]::WriteAllText($upgradeFile, ($resultLines -join "`n"), $utf8NoBom)
    Write-Host "Successfully replaced F_ApplyTwilightRandomOptions with Durability & Random Options fix!"
} else {
    Write-Host "Could not find F_ApplyTwilightRandomOptions"
}
