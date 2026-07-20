// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "homunculus_moonlight.hpp"

#include "map/status.hpp"

SkillMoonlight::SkillMoonlight() : WeaponSkillImpl(HFLI_MOON) {
}

void SkillMoonlight::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	// Hits base por nivel (Lv1=1, Lv2-4=2, Lv5=3, coincide con skill_db)
	static const int base_hits[] = { 1, 2, 2, 2, 3 };
	const int lv_index = (skill_lv >= 1 && skill_lv <= 5) ? (skill_lv - 1) : 4;

	// --- CUSTOM: 1 hit extra por cada 25 puntos de AGI ---
	const int agi = status_get_agi(src);
	const int total_hits = base_hits[lv_index] + (agi / 25);

	// Daño fijo de 200% por hit. El motor divide base_skillratio / div_ por golpe,
	// por lo que ajustamos el ratio total para que cada hit resulte en exactamente 200%.
	base_skillratio = 50 * total_hits;

	// Aplicar el numero de hits
	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = total_hits;
	}
}
