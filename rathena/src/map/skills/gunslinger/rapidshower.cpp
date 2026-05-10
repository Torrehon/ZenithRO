// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "rapidshower.hpp"
#include "../../status.hpp"

SkillRapidShower::SkillRapidShower() : WeaponSkillImpl(GS_RAPIDSHOWER) {
}

void SkillRapidShower::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	
	// 1. Calcular la cantidad de hits en función de la AGI total
	// 2 de base + 1 por cada 15 de AGI (Sin límite)
	int hits = 2 + (status_get_agi(src) / 15);

	// 2. Definir el daño total: 30% x nivel de skill x cantidad de hits
	base_skillratio = 100 + (10 * skill_lv);

	// 3. Aplicar la división de hits
	if (wd != nullptr) {
		const_cast<Damage*>(wd)->div_ = hits;
	}
}