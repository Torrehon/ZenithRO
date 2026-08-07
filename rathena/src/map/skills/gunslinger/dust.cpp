// Copyright (c) rAthena Dev Teams - Licensed under GNU GPL
// For more information, see LICENCE in the main folder

#include "dust.hpp"

#include "map/pc.hpp"
#include "map/status.hpp"

SkillDust::SkillDust() : SkillImplRecursiveDamageSplash(GS_DUST) {
}

void SkillDust::calculateSkillRatio(const Damage *wd, const block_list *src, const block_list *target, uint16 skill_lv, int32 &base_skillratio, int32 mflag) const {
	base_skillratio += 30 * skill_lv;
}

void SkillDust::applyAdditionalEffects(block_list *src, block_list *target, uint16 skill_lv, t_tick tick, int32 attack_type, enum damage_lv dmg_lv) const {
	const map_session_data* sd = BL_CAST(BL_PC, src);

	if (sd && pc_checkskill(sd, GS_ENFORCER) > 0) {
		sc_start(src, target, SC_PSLOW, 50, skill_lv, 10000);
	}
}
