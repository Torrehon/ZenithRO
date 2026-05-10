// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "downkick.hpp"

#include "map/pc.hpp" // Añadimos esto para poder usar BL_CAST y pc_checkskill
#include "map/status.hpp"

SkillDownKick::SkillDownKick() : WeaponSkillImpl(TK_DOWNKICK) {
}

void SkillDownKick::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Tu fórmula: 150% + 40% * lvl.
	// Como base_skillratio ya empieza en 100 internamente, sumamos 50 + 40 * lvl.
	base_skillratio += 50 + 40 * skill_lv;

	// --- INICIO: Shattering Kicks (Bono de Daño) ---
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
		base_skillratio += 150; // Añade 150% al ratio final
	}
	// --- FIN: Shattering Kicks ---
}

void SkillDownKick::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// Stun de 3 segundos (3000 ms). 

	sc_start(src, target, SC_STUN, 3333, skill_lv, 3000);

	// --- INICIO: Shattering Kicks (Reducción de DEF) ---
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
		// Pasamos skill_lv en lugar de 1 para que baje 5% por nivel de Axe Kick.
		// Duración hardcodeada a 10 segundos (10000 milisegundos).
		sc_start(src, target, SC_FLING, 100, skill_lv, 10000);
	}
	// --- FIN: Shattering Kicks ---
}