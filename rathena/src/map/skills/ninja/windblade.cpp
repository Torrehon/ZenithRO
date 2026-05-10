// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "windblade.hpp"

#include <config/core.hpp>

#include "map/pc.hpp"

SkillWindBlade::SkillWindBlade() : SkillImpl(NJ_HUUJIN) {
}

void SkillWindBlade::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	// Ratio fijo de 120% por cada cuchilla
	base_skillratio = 120;
}

void SkillWindBlade::castendDamageId(block_list* src, block_list* target, uint16 skill_lv, t_tick tick, int32& flag) const {
	skill_attack(BF_MAGIC, src, src, target, getSkillId(), skill_lv, tick, flag);
}