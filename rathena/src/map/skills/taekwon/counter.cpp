// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "counter.hpp"

#include "map/pc.hpp"     // Para poder usar BL_CAST y pc_checkskill
#include "map/status.hpp"

SkillCounter::SkillCounter() : WeaponSkillImpl(TK_COUNTER) {
}

void SkillCounter::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Fórmula base: 150% + 50% * lvl. 
	// Como base_skillratio ya empieza en 100, sumamos 50 + 50 * lvl.
	base_skillratio += 50 + 50 * skill_lv;

	// --- INICIO: Shattering Kicks (Bono de Daño) ---
	const map_session_data *sd = BL_CAST(BL_PC, src);
	if (sd && pc_checkskill(sd, TK_SHATTER) > 0) {
		base_skillratio += 100; // Añade 100% al ratio final
	}
	// --- FIN: Shattering Kicks ---
}