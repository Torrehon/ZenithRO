// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "crimsonfireformation.hpp"

#include "map/pc.hpp"
#include "map/status.hpp" // Necesario para SC_BURNING y sc_start

SkillCrimsonFireFormation::SkillCrimsonFireFormation() : SkillImpl(NJ_KAENSIN) {
}

void SkillCrimsonFireFormation::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	base_skillratio -= 50;
	if(sd && sd->spiritcharm_type == CHARM_TYPE_FIRE && sd->spiritcharm > 0)
		base_skillratio += 20 * sd->spiritcharm;
}

void SkillCrimsonFireFormation::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag|=1;//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}

// --- SOUL OF THE KUJI: 30% Burning al nivel 10 ---
void SkillCrimsonFireFormation::applyAdditionalEffects(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd != nullptr && pc_checkskill(sd, NJ_KUJISOUL) > 0) {
		if (skill_lv == 10) {
			// sc_start(origen, objetivo, Estado, Probabilidad 3000 = 30%, nivel, Duración en ms)
			sc_start(src, target, SC_BURNING, 3000, skill_lv, 10000); 
		}
	}
}