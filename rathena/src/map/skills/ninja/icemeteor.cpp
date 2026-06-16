// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "icemeteor.hpp"

#include "map/clif.hpp"
#include "map/pc.hpp"

SkillIceMeteor::SkillIceMeteor() : SkillImpl(NJ_HYOUSYOURAKU) {
}

void SkillIceMeteor::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// Nuevo ratio: 100% + 80% * Nivel de Skill
	base_skillratio += 80 * skill_lv;
	
	if(sd && sd->spiritcharm_type == CHARM_TYPE_WATER && sd->spiritcharm > 0)
		base_skillratio += 100 * sd->spiritcharm;
}

// Nueva función añadida: Invoca el área de daño en las coordenadas del objetivo
void SkillIceMeteor::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	clif_skill_nodamage(target, *target, getSkillId(), skill_lv);
	skill_unitsetting(src, getSkillId(), skill_lv, target->x, target->y, 0);
}

void SkillIceMeteor::castendPos2(block_list* src, int32 x, int32 y, uint16 skill_lv, t_tick tick, int32& flag) const {
	flag|=1;//Set flag to 1 to prevent deleting ammo (it will be deleted on group-delete).
	skill_unitsetting(src,getSkillId(),skill_lv,x,y,0);
}