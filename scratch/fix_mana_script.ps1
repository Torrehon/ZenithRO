$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$manaFile = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\mana.txt"

$manaContent = @"
// ==========================================================
// Sistema de Ciclo Ambiental Dinámico y Mana Engine
// Estados Globales: Día (0), Noche (1), Lluvia de Estrellas (2)
// ==========================================================

-	script	EnvCycleManager	-1,{
OnInit:
	if ($StarShowerChance == 0) set $StarShowerChance, 20; 
	
	// --- REGISTRO DE CIUDADES Y FIELDS PARA NOCHE Y CLIMA (LEAVES / DESTELLOS) ---
	deletearray .map_list$[0];
	setarray .map_list$[0], "prontera","geffen","payon","morocc","alberta","izlude","aldebaran","comodo","yuno","amatsu","gonryun","louyang","ayothaya","umbala","einbroch","lighthalzen","rachel","veins","hugel","niflheim","jawaii","moscovia","brasilis","dewata","malangdo","malaya";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "prt_fild00","prt_fild01","prt_fild02","prt_fild03","prt_fild04","prt_fild05","prt_fild06","prt_fild07","prt_fild08","prt_fild09","prt_fild10","prt_fild11";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "pay_fild01","pay_fild02","pay_fild03","pay_fild04","pay_fild05","pay_fild06","pay_fild07","pay_fild08","pay_fild09","pay_fild10";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "gef_fild00","gef_fild01","gef_fild02","gef_fild03","gef_fild04","gef_fild05","gef_fild06","gef_fild07","gef_fild08","gef_fild09","gef_fild10","gef_fild11","gef_fild12","gef_fild13","gef_fild14";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "moc_fild01","moc_fild02","moc_fild03","moc_fild07","moc_fild11","moc_fild12","moc_fild13","moc_fild16","moc_fild17","moc_fild18","moc_fild19","moc_fild20";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "mjolnir_01","mjolnir_02","mjolnir_03","mjolnir_04","mjolnir_05","mjolnir_06","mjolnir_07","mjolnir_08","mjolnir_09","mjolnir_10","mjolnir_11","mjolnir_12";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "cmd_fild01","cmd_fild02","cmd_fild03","cmd_fild04","cmd_fild05","cmd_fild06","cmd_fild07","cmd_fild08","cmd_fild09";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "yuno_fild01","yuno_fild02","yuno_fild03","yuno_fild04","yuno_fild05","yuno_fild06","yuno_fild07","yuno_fild08","yuno_fild09","yuno_fild10","yuno_fild11","yuno_fild12";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "ein_fild01","ein_fild02","ein_fild03","ein_fild04","ein_fild05","ein_fild06","ein_fild07","ein_fild08","ein_fild09","ein_fild10";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "lhz_fild01","lhz_fild02","lhz_fild03","ra_fild01","ra_fild02","ra_fild03","ra_fild04","ra_fild05","ra_fild06","ra_fild07","ra_fild08","ra_fild09","ra_fild10","ra_fild11","ra_fild12","ra_fild13";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "ve_fild01","ve_fild02","ve_fild03","ve_fild04","ve_fild05","ve_fild06","ve_fild07","hu_fild01","hu_fild02","hu_fild03","hu_fild04","hu_fild05","hu_fild06","hu_fild07";

	set .@n, getarraysize(.map_list$);
	setarray .map_list$[.@n], "ama_fild01","gon_fild01","lou_fild01","ayo_fild01","ayo_fild02","um_fild01","um_fild02","spl_fild01","spl_fild02","spl_fild03","man_fild01","man_fild02","man_fild03","bra_fild01","dew_fild01","ma_fild01","ma_fild02";

	// Habilitar el ciclo de noche en todos los mapas de la lista
	for (set .@i, 0; .@i < getarraysize(.map_list$); set .@i, .@i + 1) {
		setmapflag .map_list$[.@i], mf_nightenabled;
	}

	// Valores base por seguridad al arrancar
	set $Global_EnvState, 0;
	set $ManaEvent_Active, 0;
	day;
	callsub L_RemoveLeaves;
	setbattleflag "base_exp_rate", 500, true;
	setbattleflag "job_exp_rate", 500, true;
	end;

// ==========================================================
// Subrutinas de Clima Global (mf_leaves)
// Previene la acumulacion limpiando siempre antes de aplicar
// ==========================================================
L_ApplyLeaves:
	callsub L_RemoveLeaves;
	for (set .@i, 0; .@i < getarraysize(.map_list$); set .@i, .@i + 1) {
		setmapflag .map_list$[.@i], mf_leaves;
	}
	return;

L_RemoveLeaves:
	for (set .@i, 0; .@i < getarraysize(.map_list$); set .@i, .@i + 1) {
		removemapflag .map_list$[.@i], mf_leaves;
	}
	return;

// ==========================================================
// Gatillos Manuales (Llamados desde el NPC Interruptor)
// ==========================================================
OnManualStart:
	set $StarShowerChance, 100; // Forzamos la lluvia
	goto L_TriggerCycle;
	end;

OnManualStop:
	set $ManaEvent_Active, 0;
	set $Global_EnvState, 0;
	day;
	callsub L_RemoveLeaves;
	setbattleflag "base_exp_rate", 500, true;
	setbattleflag "job_exp_rate", 500, true;
	
	announce "The mana flow has been manually stabilized. EXP rates are back to 5.00x.", bc_all|bc_blue;
	end;

// ==========================================================
// Gatillo Automático (Cada 3 horas)
// ==========================================================
OnHour00:OnHour03:OnHour06:OnHour09:OnHour12:OnHour15:OnHour18:OnHour21:
L_TriggerCycle: 

	set .@roll, rand(1, 100);

	if (.@roll <= $StarShowerChance) {
		// ==============================================
		// ¡ÉXITO! LLUVIA DE ESTRELLAS (Estado 2)
		// ==============================================
		set $Global_EnvState, 2;
		set $StarShowerChance, 20; 
		
		night;
		callsub L_ApplyLeaves;
		
		// MANA ENGINE: Cálculo Aleatorio 6.00x - 8.00x
		set .@new_rate, rand(600, 800);
		set .@int, .@new_rate / 100;
		set .@dec, .@new_rate % 100;
		if (.@dec < 10) set .@dec$, "0" + .@dec;
		else set .@dec$, "" + .@dec;

		// Aplicación directa y nativa de rates con recarga integrada (, true)
		setbattleflag "base_exp_rate", .@new_rate, true;
		setbattleflag "job_exp_rate", .@new_rate, true;

		set $ManaEvent_Active, 1;

		announce "A breathtaking meteor shower illuminates the dark sky! Mana flow burst, EXP bonus " + .@int + "." + .@dec$ + "x active.", bc_all|bc_blue;

	} else {
		// ==============================================
		// FALLO: CICLO NORMAL (Día / Noche)
		// ==============================================
		set $StarShowerChance, $StarShowerChance + 10;
		
		// Restablecemos clima de hojas y rates base si veníamos de una lluvia activa
		callsub L_RemoveLeaves;
		if ($ManaEvent_Active == 1) {
			set $ManaEvent_Active, 0;
			setbattleflag "base_exp_rate", 500, true;
			setbattleflag "job_exp_rate", 500, true;
		}

		// Alternamos entre Día y Noche
		if ($Global_EnvState == 0 || $Global_EnvState == 2) {
			set $Global_EnvState, 1;
			night;
			announce "The moon takes over as a quiet night falls.", bc_all|bc_blue;
		} else {
			set $Global_EnvState, 0;
			day;
			announce "The sun rises, bringing a warm new day.", bc_all|bc_yellow;
		}
	}
	end;
}
"@

[System.IO.File]::WriteAllText($manaFile, $manaContent, $utf8NoBom)
Write-Host "Updated npc/custom/mana.txt to fix leaves effect stacking!"
