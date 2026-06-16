// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "throwzeny.hpp"

#include "map/pc.hpp"

// Apunta a WeaponSkillImpl
SkillThrowZeny::SkillThrowZeny() : WeaponSkillImpl(NJ_ZENYNAGE) {
}

void SkillThrowZeny::calculateSkillRatio(const Damage* wd, const block_list* src, const block_list* target, uint16 skill_lv, int32& base_skillratio, int32 mflag) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	// DAÑO BASE (Mammonite Bufado): 300% + 70% por nivel de habilidad
	base_skillratio += 300 + 70 * skill_lv;

	// MEJORA KENSEI SOUL: Añade un 300% extra de multiplicador si tiene la pasiva
	if (sd != nullptr && pc_checkskill(sd, NJ_KENSEISOUL) > 0) {
		base_skillratio += 300;
	}
}

void SkillThrowZeny::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	skill_attack(skill_get_type(getSkillId()),src,src,target,getSkillId(),skill_lv,tick,flag);
}