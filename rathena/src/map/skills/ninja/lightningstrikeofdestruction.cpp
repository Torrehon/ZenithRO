// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "lightningstrikeofdestruction.hpp"

#include <config/core.hpp>

#include "map/clif.hpp"
#include "map/pc.hpp"

SkillLightningStrikeOfDestruction::SkillLightningStrikeOfDestruction() : SkillImpl(NJ_RAIGEKISAI) {
}

void SkillLightningStrikeOfDestruction::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// Nueva fórmula custom de daño: 100% + 80% * Skill Level
	base_skillratio += 80 * skill_lv;

	// Se mantiene el bono de daño si el Ninja usa Charms de viento
	if(sd && sd->spiritcharm_type == CHARM_TYPE_WIND && sd->spiritcharm > 0)
		base_skillratio += 20 * sd->spiritcharm;
}

// Lógica de casteo para que el área de daño (Unit) se genere sobre el objetivo
void SkillLightningStrikeOfDestruction::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(target, *target, getSkillId(), skill_lv);
	skill_unitsetting(src, getSkillId(), skill_lv, target->x, target->y, 0);
}

void SkillLightningStrikeOfDestruction::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	flag |= 1;

	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}