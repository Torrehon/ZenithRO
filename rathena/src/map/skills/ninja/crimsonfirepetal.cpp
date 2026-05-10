// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "crimsonfirepetal.hpp"

#include "map/pc.hpp"

SkillCrimsonFirePetal::SkillCrimsonFirePetal() : SkillImpl(NJ_KOUENKA) {
}

void SkillCrimsonFirePetal::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratio fijo de 120% por cada pétalo
	base_skillratio = 120;
}

void SkillCrimsonFirePetal::castendDamageId(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32& flag) const {
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}