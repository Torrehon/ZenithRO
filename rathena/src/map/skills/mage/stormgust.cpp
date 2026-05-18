// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "stormgust.hpp"

#include <config/core.hpp>

#include "map/status.hpp"

SkillStormGust::SkillStormGust() : SkillImpl(WZ_STORMGUST) {
}

void SkillStormGust::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

void SkillStormGust::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
#ifdef RENEWAL
	base_skillratio -= 30; // Offset only once
	base_skillratio += 50 * skill_lv;
#else
	base_skillratio += 30 * skill_lv;
#endif

    map_session_data* sd = const_cast<map_session_data*>(BL_CAST(BL_PC, src));
// --- SOUL OF THE MAGUS: Multiplicador Total ---

	if (sd != nullptr && pc_checkskill(sd, WZ_MAGUSSOUL) > 0) {
		
		// 1. Calculamos el ratio de daño total real (Añadiendo el 100% base)
		int32 total_ratio = 100 + base_skillratio;
		
		// 2. Aplicamos el aumento del +15% de daño real (multiplicativo)
		total_ratio = (total_ratio * 115) / 100;
		
		// 3. Devolvemos la variable al formato "extra" que rAthena espera
		base_skillratio = total_ratio - 100;
	}
}


void SkillStormGust::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	// Storm Gust counter was dropped in renewal


	sc_start(src,target,SC_FREEZING,15+(2*skill_lv),skill_lv,skill_get_time2(getSkillId(),skill_lv));

}
