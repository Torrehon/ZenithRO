// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "disarm.hpp"

#include "map/clif.hpp"

SkillDisarm::SkillDisarm() : WeaponSkillImpl(GS_DISARM) {
}
void SkillDisarm::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {


	base_skillratio = 40 * skill_lv;
}	
void SkillDisarm::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	skill_strip_equip(src, target, getSkillId(), skill_lv);
	clif_skill_nodamage(src, *target, getSkillId(), skill_lv);
}
